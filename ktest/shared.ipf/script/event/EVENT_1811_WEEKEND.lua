function SCR_EVENT_1811_WEEKEND_CHECK(inputType)
    local now_time = os.date('*t')
    local month = now_time['month']
    local day = now_time['day']
    
    local t = {
                {11,24,{'REINFORCE'}},
                {11,25,{'TRANSCEND'}},
                {12,1,{'ITEMRANDOMRESET'}},
                {12,2,{'LOOTINGCHANCE'}},
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
                {1,6,{'TRANSCEND'}}
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