function ANCIENT_GET_COMBO(typeList)
    local buffList = {}
    --local clsList, clsCnt = GetClassList("ancient_combo")
    --for i = 1,clsCnt do
    --    local cls = GetClassByIndexFromList(clsList,i-1)
    --    local isValid = true
    --    for j = 1,4 do
    --        local type = TryGetProp(cls,"TypeName_"..j)
    --        if type ~="None" then
    --            if typeList[type] == nil or typeList[type] < TryGetProp(cls,"TypeNum_"..j) then
    --                isValid = false
    --            end
    --        else
    --            break;
    --        end
    --    end
    --    if isValid == true then
    --        --여기 로직 추가
    --        local over = TryGetProp(cls,"Over")
    --        local buffName = TryGetProp(cls,"BuffName")
    --        buffList[buffName] = over
    --    end
    --end
     
    return buffList;
end

function IS_ANCIENT_ENABLE_MAP(self)
    
    if IsServerSection() == 1 then
        zoneName = GetZoneName(self);
    else
        zoneName = session.GetMapName();
    end
    
    local levelDungeonList = {'id_chaple','id_remains','id_remains3','id_castle2','id_3cmlake_26_1'}
    for i = 1,#levelDungeonList do
        if zoneName == levelDungeonList[i] then
            return "YES"
        end
    end

    local mapCls = GetClass("Map", zoneName);
    local mapType = TryGetProp(mapCls, "MapType", "None");
    local mapKeyword = TryGetProp(mapCls, "Keyword", "None");
    if mapType == "Field" or zoneName == 'd_solo_dungeon_2' or mapKeyword == "FreeDungeon" or mapKeyword == "Mission" or zoneName == "onehour_test1" then
        return "YES"
    end
    
    return "NO"
end