function SCR_EVENT_1903_WEEKEND_CHECK(inputType, isServer)

    local sysTime
    
    if isServer == true then
        sysTime = GetDBTime()
    else
        sysTime = geTime.GetServerSystemTime();
    end
    
    local month = sysTime.wMonth
    local day = sysTime.wDay
    local t = {
                {4,5,{'REINFORCE', 'TRANSCEND'}},
                {4,6,{'EXP'}},
                {4,7,{'LOOTINGCHANCE','ITEMRANDOMRESET'}},
                {4,13,{'REINFORCE', 'TRANSCEND'}},
                {4,14,{'EXP'}},
                {4,20,{'LOOTINGCHANCE','ITEMRANDOMRESET'}},
                {4,21,{'REINFORCE', 'TRANSCEND'}},
                {4,27,{'EXP'}},
                {4,28,{'LOOTINGCHANCE','ITEMRANDOMRESET'}},
                {5,4,{'REINFORCE', 'TRANSCEND'}},
                {5,11,{'EXP','LOOTINGCHANCE','ITEMRANDOMRESET'}},
                {5,12,{'EXP','LOOTINGCHANCE','ITEMRANDOMRESET'}},
                }
    for i = 1, #t do
        if t[i][1] == month and t[i][2] == day then
            for i2 = 1, #t[i][3] do
                if inputType == t[i][3][i2] then
                    return 'YES'
                end
            end
            break
        end
    end
    
    return 'NO'
end

function SCR_EVENT_1903_WEEKEND_LOOTINGCHANCE_BUFF_CHECK(self, isServer)
    if IsServerSection() == 1 then
        local buffList = {{'LOOTINGCHANCE','Event_ep11_LootingChance'}
                            ,{'EXP','Event_ep11_Expup'}
                            ,{'REINFORCE','Event_ep11_reinforce'}}
        for i = 1,#buffList do
            if SCR_EVENT_1903_WEEKEND_CHECK(buffList[i][1], isServer) == 'YES' then
                if IsBuffApplied(self, buffList[i][2]) ~= 'YES' then
                    AddBuff(self, self, buffList[i][2])
                    AddBuff(self, self, 'Event_ep11_Expup_base')
                end
            else
                if IsBuffApplied(self, buffList[i][2]) == 'YES' then
                    RemoveBuff(self, buffList[i][2])
                end
            end
        end
    end
end


function SCR_RAID_EVENT_20190102(pc, isServer)
    if 1 == 1 then
        return false;
    end

    local sysTime

    if isServer == true then
        sysTime = GetDBTime()
    else
        sysTime = geTime.GetServerSystemTime();
    end
    
    local month = sysTime.wMonth
    local day = sysTime.wDay
   
    if (month == 1 and day == 31 ) or (month == 2 and day <= 7) then
        return true
    else
        return false
    end
end