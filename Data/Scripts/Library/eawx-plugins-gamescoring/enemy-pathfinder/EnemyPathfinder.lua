require("PGBase")
require("deepcore/std/class")
require("deepcore/crossplot/crossplot")
require("eawx-util/StoryUtil")
require("PGSpawnUnits")

--[[

WARNING!!! Needs serious re-implementation!!

]]
EnemyPathfinder = class()

function EnemyPathfinder:new()
    
    self.player_enemy = nil
    self.human_player = Find_Player("local")
    crossplot:subscribe("GAME_MODE_STARTING", self.mode_start, self)
    crossplot:subscribe("GAME_MODE_ENDING", self.mode_end, self)
    crossplot:subscribe("TACTICAL_UNIT_DESTROYED", self.check_unit, self)
    self.spawn_list = nil
    
end

function EnemyPathfinder:mode_start(mode)
    if mode ~= "Space" or TestValid(Find_First_Object("SCRIPTED_BATTLE_MARKER")) == true then
        return
    end
    local player_attacker = Find_First_Object("Attacker Entry Position").Get_Owner()
    if player_attacker ~= self.human_player then
        self.player_enemy = player_attacker
        self.spawned_list = Find_All_Objects_Of_Type("Transport | Gunship | Corvette | Frigate | Capital | SuperCapital", self.player_enemy)
        self.Marker = Spawn_From_Reinforcement_Pool(Find_Object_Type("AI_Fleet_Marker"), "Attacker Entry Position", self.player_enemy)
        self.Marker.Get_Parent_Mode_Object_ID()
        for _, spawned_unit in pairs(spawned_list) do
            spawned_unit.Despawn()
            Add_Reinforcement(spawned_unit, self.player_enemy)
        end
        self:get_pathfinder()
    end
end

function EnemyPathfinder:check_unit(object_name, object_power, object_is_hero, object)
    if self.spawn_list[object] == true then
        for _, v in pairs(self.spawn_list) do
            if v == object then
                table.remove(tbl, i)
                break
            end
        end
    end
end

function EnemyPathfinder:get_pathfinder()

    local target_index = GameRandom.Free_Random(1,table.getn(target_list))

    target_index.Teleport("Attacker Entry Position")						--Move pathfinder to location
    target_index.Cinematic_Hyperspace_In(1)						--Do hyperspace jump
                
    target_index.Prevent_All_Fire(false)						--Allow weapon fire
    target_index.Make_Invulnerable(false)						--Allow damage
    target_index.Prevent_AI_Usage(false)

    self.Marker.Despawn()

    StoryUtil.ShowScreenText(message, 15, self.active_target)

end



function EnemyPathfinder:mode_end()
    
    self.player_enemy = nil
    self.spawned_list = nil
    self.Marker = nil
	StoryUtil.ShowScreenText("Script end", 5)
end
return EnemyPathfinder