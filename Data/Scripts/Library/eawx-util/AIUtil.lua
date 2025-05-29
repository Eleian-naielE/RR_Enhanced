function Set_Fleet_Marker(taskforce)
    local Fleet_Location = taskforce.Get_Planet_Location()
    local Fleet_Owner = taskforce.Get_Owner()
    local Space_Unit_List = taskforce.Get_Unit_Table()
    local Fleet_Marker = Spawn_Unit("AI_Fleet_Marker", Fleet_Location, Fleet_Owner)
    GlobalValue.Set()
    local Fleet_Marker_ID = Fleet_Marker.Get_Object_ID()
end

function Pathfinder_Setup()
    
end