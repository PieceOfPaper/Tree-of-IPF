-- shared_field_dungeon.lua

function SCR_FIELD_DUNGEON_CONSUME_DECREASE(pc, name, value)
    local mapProp = nil
    if IsServerSection() == 1 then
        mapProp = GetMapProperty(pc)
    else
        local mapName = session.GetMapName()
        mapProp = GetClass('Map', mapName)
    end
    
    if mapProp ~= nil then
        local mapLv = TryGetProp(mapProp, 'QuestLevel')
        if mapLv > 420 then
            if name == 'Sta_Run' then
                return 0
            elseif name == 'SpendSP' then
                return value
            elseif name == 'CoolDown' then
                local reduceRate = 0

                if IsBuffApplied(pc, 'FIELD_DEFAULTCOOLDOWN_BUFF') == 'YES' then
                    reduceRate = 0.3
                end

                if IsBuffApplied(pc, 'FIELD_COOLDOWNREDUCE_BUFF') == 'YES' then
                    reduceRate = 0.7
                end

                return value * (1 - reduceRate)
            end
        end
    end

    return value
end