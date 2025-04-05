require("deepcore/std/class")
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
    if player_attacker ~= Find_Player("local") then
        self.pathfinder_enabled = true
        self.player_enemy = player_attacker
    end
end

function EnemyPathfinder:update() 
    if self.pathfinder_enabled then
        self:spawn_pathfinder()
    end
end

function EnemyPathfinder:spawn_pathfinder()
    
    local spawned_list = Find_All_Objects_Of_Type(self.player_enemy, "Transport | Gunship | Corvette | Frigate | Capital | SuperCapital")
    for _, spawned_unit in pairs(spawned_list) do
        spawned_unit.Despawn()
        Add_Reinforcement(spawned_unit, self.player_enemy)
    end
    
    Object.Prevent_All_Fire(true)

    Object.Cancel_Hyperspace()

    Object.Hide(true)
    Object.Hide(true)

    local heightType = Find_Object_Type(heights[GameRandom(1, table.getn(heights))])
    local zLayerDummyList = Spawn_Unit(heightType, Object.Get_Position(), Object.Get_Owner())
    local zLayerDummy = zLayerDummyList[1]
    Object.Teleport(zLayerDummy)

    Object.Cinematic_Hyperspace_In(1)
    zLayerDummy.Despawn()
    Object.Prevent_All_Fire(false)
    Object.Make_Invulnerable(false)
    Object.Prevent_AI_Usage(false)
end


function EnemyPathfinder:mode_end()
    self.pathfinder_enabled = false
end
return EnemyPathfinder




--[[
    Object.Prevent_All_Fire(true)

    Object.Cancel_Hyperspace()

    Object.Hide(true)
    Object.Hide(true)

    local heightType = Find_Object_Type(heights[GameRandom(1, table.getn(heights))])
    local zLayerDummyList = Spawn_Unit(heightType, Object.Get_Position(), Object.Get_Owner())
    local zLayerDummy = zLayerDummyList[1]
    Object.Teleport(zLayerDummy)

    Object.Cinematic_Hyperspace_In(1)
    zLayerDummy.Despawn()
    Object.Prevent_All_Fire(false)
    Object.Make_Invulnerable(false)
    Object.Prevent_AI_Usage(false)
    ]]