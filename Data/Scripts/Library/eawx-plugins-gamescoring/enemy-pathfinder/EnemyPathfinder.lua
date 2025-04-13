require("PGBase")
require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("eawx-util/StoryUtil")
require("PGSpawnUnits")

EnemyPathfinder = class()

function EnemyPathfinder:new()
    
    self.player_enemy = nil
    self.pathfinder_enabled = false
    self.human_player = Find_Player("local")
    crossplot:subscribe("GAME_MODE_STARTING", self.mode_start, self)
    crossplot:subscribe("GAME_MODE_ENDING", self.mode_end, self)
    
end

function EnemyPathfinder:mode_start(mode)
    if mode ~= "Space" or TestValid(Find_First_Object("SCRIPTED_BATTLE_MARKER")) == true then
        self.pathfinder_enabled = false
        return
    end
    local player_attacker = Find_First_Object("Attacker Entry Position").Get_Owner()
    -- if player_attacker ~= self.human_player then
        self.pathfinder_enabled = true
        self.player_enemy = player_attacker
		self.initial_setup = false
		self.found_pathfinder = false
		self.moved_to_reinforcement = false
    -- end
end

function EnemyPathfinder:update() 
    
    if self.pathfinder_enabled == false then
        return
    end
	if self.initial_setup == false then
		self:initialise_setup()
	end
	if self.found_pathfinder == false then
    	self:get_pathfinder()
	end
	if self.found_pathfinder == true and self.moved_to_reinforcement == false then
		self:reinforcement_non_pathfinder()
	end
end

function EnemyPathfinder:initialise_setup()
	self.spawned_list = Find_All_Objects_Of_Type("Transport | Gunship | Corvette | Frigate | Capital | SuperCapital", self.player_enemy)
    for _, spawned_unit in pairs(self.spawned_list) do
        spawned_unit.Hide(true)		--Hides objects
        spawned_unit.Hide(true)
        spawned_unit.Prevent_All_Fire(true)	--Stops units from firing
    end
	self.unit_to_pathfind = nil			--Stores value of pathfinder
    self.pathfinder_id = nil				--Stored ID of pathfinder and compared against objects to store into reinforcement pool 
    self.pathfinder_category_table = nil	--Table of objects found in category
    self.entry_pos_obj = Find_First_Object("Attacker Entry Position") --postion dummy, used to teleport pathfinder to location

    self.category_table = { 				--table of categories to loop through
        "Corvette",
        "Frigate",
        "Capital",
        "SuperCapital",
        "Gunship",
        "Transport",
    }
	self.initial_setup = true

end

function EnemyPathfinder:get_pathfinder()

        for _, category in ipairs(self.category_table) do							--Loop through categories
            self.pathfinder_category_table = Find_All_Objects_Of_Type(category, self.player_enemy) --Search individual categories for units
			if table.getn(self.pathfinder_category_table) > 0 then								--If table contains units
                self.unit_to_pathfind = self.pathfinder_category_table[1]					--Assign first object in table as valid pathfinder
                self.unit_to_pathfind.Teleport(self.entry_pos_obj)						--Move pathfinder to location
                self.unit_to_pathfind.Cinematic_Hyperspace_In(1)						--Do hyperspace jump
                
                self.unit_to_pathfind.Prevent_All_Fire(false)						--Allow weapon fire
                self.unit_to_pathfind.Make_Invulnerable(false)						--Allow damage
                self.unit_to_pathfind.Prevent_AI_Usage(false)						--AI can use
                self.pathfinder_id = self.unit_to_pathfind.Get_Parent_Mode_Object_ID()	--Store pathfinder ID
				self.found_pathfinder = true
            end
            StoryUtil.ShowScreenText("Unit not found in category: "..category..", attempting next category", 5)	--debug print if unit not found in category 
        end
        StoryUtil.ShowScreenText("Pathfinder not selected, attempting on next loop", 5)	--debug print if unit not found in loop

end

function EnemyPathfinder:reinforcement_non_pathfinder()
	StoryUtil.ShowScreenText("Pathfinder ID:  "..self.pathfinder_id, 5)						--Debug print of pathfinder ID
		for _, spawned_unit in pairs(self.spawned_list) do									--Loop once more through all units
			if spawned_unit.Get_Parent_Mode_Object_ID() ~= self.pathfinder_id then				--Compare ID does not match pathfinders
				Add_Reinforcement(spawned_unit.Get_Type(), self.player_enemy)		--Add to reinforcement pool
				spawned_unit.Despawn()														--Clear unit from battle
			end
		end
	self.moved_to_reinforcement = true
end


function EnemyPathfinder:mode_end()
    self.pathfinder_enabled = false
end
return EnemyPathfinder