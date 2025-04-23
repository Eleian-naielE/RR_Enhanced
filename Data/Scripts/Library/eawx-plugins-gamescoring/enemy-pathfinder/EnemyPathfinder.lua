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
    self.setup_bool = false
    self.found_bool = false
    self.ending_bool = false
    
end

function EnemyPathfinder:mode_start(mode)
    if mode ~= "Space" or TestValid(Find_First_Object("SCRIPTED_BATTLE_MARKER")) == true then
        self.pathfinder_enabled = false
        return
    end
    local player_attacker = Find_First_Object("Attacker Entry Position").Get_Owner()
    if player_attacker ~= self.human_player then
        self.player_enemy = player_attacker
        local spawned_list = Find_All_Objects_Of_Type("Transport | Gunship | Corvette | Frigate | Capital | SuperCapital", self.player_enemy)
        for _, spawned_unit in pairs(spawned_list) do
            spawned_unit.Hide(true)		--Hides objects
            spawned_unit.Prevent_All_Fire(true)	--Stops units from firing
        end
        self.pathfinder_enabled = true
    end
end



function EnemyPathfinder:selection_begin()
    if TestValid(self.player_enemy) ~= true then
        return
    end

    local spawned_list = Find_All_Objects_Of_Type("Transport | Gunship | Corvette | Frigate | Capital | SuperCapital", self.player_enemy)

    


    local target_index = GameRandom.Free_Random(1,table.getn(target_list))
    self.active_target = target_list[target_index]

    StoryUtil.ShowScreenText(message, 15, self.active_target)

end



function EnemyPathfinder:mode_end()
    self.pathfinder_enabled = false
    self.player_enemy = nil
	StoryUtil.ShowScreenText("Script end", 5)						--Debug script mode end
end
return EnemyPathfinder