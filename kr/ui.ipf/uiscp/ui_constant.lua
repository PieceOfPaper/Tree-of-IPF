--- ui_constant.lua --

iconW = 30;
iconH = 30;

TEXT_ZONENAMELIST = {}

if #TEXT_ZONENAMELIST == 0 then
    local maplist, mapcnt  = GetClassList("Map");
    for i = 0 , mapcnt - 1 do
        local cls = GetClassByIndexFromList(maplist, i);
        local zoneName = TryGetProp(cls,'Name', 'None')
        if zoneName ~= 'None' and table.find(TEXT_ZONENAMELIST, zoneName) == 0 then
            TEXT_ZONENAMELIST[#TEXT_ZONENAMELIST + 1] = zoneName
        end
    end
    
    local arealist, areacnt  = GetClassList("Map_Area");
    for i = 0 , areacnt - 1 do
        local cls = GetClassByIndexFromList(arealist, i);
        local zoneName = TryGetProp(cls,'Name', 'None')
        if zoneName ~= 'None' and table.find(TEXT_ZONENAMELIST, zoneName) == 0 then
            TEXT_ZONENAMELIST[#TEXT_ZONENAMELIST + 1] = zoneName
        end
    end
end

TEXT_MONNAMELIST = {}
if #TEXT_MONNAMELIST == 0 then
    local exceptList, exceptcnt  = GetClassList("DialogExceptionText");
    local except = {}
    for i = 0 , exceptcnt - 1 do
        local cls = GetClassByIndexFromList(exceptList, i);
        local clstype = TryGetProp(cls,'Type', 'None')
        local clsword = TryGetProp(cls,'Word', 'None')
        if clstype == 'MONSTER' then
            except[#except + 1] = clsword
        end
    end
    
    local monlist, moncnt  = GetClassList("Monster");
    for i = 0 , moncnt - 1 do
        local cls = GetClassByIndexFromList(monlist, i);
        local monName = TryGetProp(cls,'Name', 'None')
        local monRank = TryGetProp(cls,'MonRank', 'None')
        local faction = TryGetProp(cls,'Faction', 'None')
        if monName ~= 'None' and table.find(TEXT_ZONENAMELIST, monName) == 0 and monRank ~= 'MISC' and monRank ~= 'NPC' and monRank ~= 'Pet' and faction == 'Monster' then
            if table.find(except, monName) == 0 then
                TEXT_MONNAMELIST[#TEXT_MONNAMELIST + 1] = monName
            end
        end
    end
end