function SCR_EVENT_1811_WEEKEND_CHECK(inputType)
    local now_time = os.date('*t')
    local month = now_time['month']
    local day = now_time['day']
    
    local t = {
                {12,8,{'REINFORCE'}},
                {12,9,{'TRANSCEND'}},
                {12,15,{'ITEMRANDOMRESET'}},
                {12,16,{'LOOTINGCHANCE'}},
                {12,22,{'REINFORCE'}},
                {12,23,{'TRANSCEND'}},
                {12,25,{'ITEMRANDOMRESET','LOOTINGCHANCE'}},
                {12,29,{'REINFORCE'}},
                {12,30,{'TRANSCEND'}},
                {1,1,{'ITEMRANDOMRESET','LOOTINGCHANCE'}},
                {1,5,{'REINFORCE'}},
                {1,6,{'TRANSCEND'}},
                {1,12,{'ITEMRANDOMRESET'}},
                {1,13,{'LOOTINGCHANCE'}},
                {1,19,{'REINFORCE'}},
                {1,20,{'TRANSCEND'}}
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


function SCR_EVENT_1811_WEEKEND_LOOTINGCHANCE_BUFF_CHECK(self)
    if IsServerSection() == 1 then
        if IsBuffApplied(self, 'Event_1710_Holiday') == 'YES' then
            if IS_BASIC_FIELD_DUNGEON(self) ~= 'YES' or SCR_EVENT_1811_WEEKEND_CHECK('LOOTINGCHANCE') ~= 'YES' then
                RemoveBuff(self, 'Event_1710_Holiday')
            end
        else
            if IS_BASIC_FIELD_DUNGEON(self) == 'YES' and SCR_EVENT_1811_WEEKEND_CHECK('LOOTINGCHANCE') == 'YES' then
                AddBuff(self, self, 'Event_1710_Holiday')
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
   
    if (month == 2 and day >= 18 ) or (month == 3 and day <= 20) then
        return true
    else
        return false
    end
end