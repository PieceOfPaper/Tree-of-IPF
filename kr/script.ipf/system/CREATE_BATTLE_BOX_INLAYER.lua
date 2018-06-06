function DRT_S_FIXCAM(pc, x,y,z, dist)
    local list, cnt = GetLayerPCList(GetZoneInstID(pc), GetLayer(pc))
    if cnt >= 1 then
        for i = 1, cnt do
            if list[i].ClassName == 'PC' then
                FixCamera(list[i],x,y,z, dist)
            end
        end
    end
    
end

function CREATE_BATTLE_BOX_INLAYER(pc, customRange)
    local monList, monCount = GetLayerMonList(GetZoneInstID(pc), GetLayer(pc))
    local distance = 0
    local boxMon
    
    if monCount > 0 then
        for i = 1, monCount do
            local monListDistance = SCR_OBJECT_DISTANCE(pc, monList[i])
            if distance < monListDistance then
                distance = monListDistance
            end
        end
    end
    
    if distance > 0 then
        local x,y,z = GetPos(pc)
        if customRange ~= nil then
            distance = math.floor(distance/2) + 150 + customRange
        else
            distance = math.floor(distance/2) + 150
        end
        boxMon = CREATE_BATTLE_BOX(pc, 20, "None", 1000, x-distance, y, z-distance, x+distance, y, z+distance)
    end
    
    if monCount > 0 and boxMon ~= nil then
        for i = 1, monCount do
            if IsHostileFaction(pc, monList[i]) == 'YES' then
                ADD_BATTLE_BOX_MONSTER(boxMon, monList[i])
            end
        end
    end
    
    
    if boxMon ~= nil then
        local list, cnt = GET_PARTY_ACTOR(pc, 0)
        for i = 1, cnt do
    		local partyPC = list[i];
            local emptyIndex = GetEmptyArgIndex(boxMon);
        	if emptyIndex ~= 0 then
            	SetExArg(boxMon, emptyIndex, partyPC);
            	CopyScrollLock(boxMon, partyPC);
            end
        end
    end
end