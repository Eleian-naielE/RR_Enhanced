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
    crossplot:subscribe("TACTICAL_UNIT_DESTROYED", self.on_tactical_unit_destroyed, self)
    self.spawn_list = nil
    self.categorized_list = {}
    self.Marker = nil 
    
end

function EnemyPathfinder:mode_start(mode)
    if mode ~= "Space" or TestValid(Find_First_Object("SCRIPTED_BATTLE_MARKER")) == true then
        return
    end
    local player_attacker = Find_First_Object("Attacker Entry Position").Get_Owner()
    if player_attacker ~= self.human_player then
        self.player_enemy = player_attacker
    end
end

function EnemyPathfinder:on_tactical_unit_destroyed(object_name, object_power, object_is_hero, object)
    if object.get_owner == self.player_enemy then
        
end

function EnemyPathfinder:Categorize(UnitList)
    for k, Unit in pairs(UnitList) do
        self.categorized_list[Unit] 
        
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