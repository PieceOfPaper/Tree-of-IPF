function SCR_POINT_DISTANCE(x1,z1,x2,z2)
    return math.floor((math.abs(x1-x2)^2 + math.abs(z1-z2)^2)^0.5);
end

function SCR_POINT_DISTANCE_CHAT (pc, before_x,before_z,after_x,after_z)
    local result = SCR_POINT_DISTANCE (before_x,before_z,after_x,after_z)
    Chat(pc,'DISTANCE = '..result)
end

function SCR_OBJECT_DISTANCE(obj1, obj2)
    local obj1_X, obj1_Y, obj1_Z = GetPos(obj1)
    local obj2_X, obj2_Y, obj2_Z = GetPos(obj2)
    
    return SCR_POINT_DISTANCE(obj1_X,obj1_Z,obj2_X,obj2_Z)
end

