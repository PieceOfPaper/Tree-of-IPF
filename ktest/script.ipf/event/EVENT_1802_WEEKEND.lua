function EVENT_1804_WEEKEND(self)
    if IsBuffApplied(self, 'Event_1710_Holiday') == 'YES' then
        if IS_DAY_EVENT_1804_WEEKEND(self) ~= 'YES' then
            RemoveBuff(self, 'Event_1710_Holiday')
        end
    else
        if IS_DAY_EVENT_1804_WEEKEND(self) == 'YES' then
            AddBuff(self, self, 'Event_1710_Holiday')
        end
    end
end

function IS_DAY_EVENT_1804_WEEKEND(self)
    local now_time = os.date('*t')
    local month = now_time['month']
    local year = now_time['year']
    local day = now_time['day']
    local wday = now_time['wday']

    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)

    if nowbasicyday >= SCR_DATE_TO_YDAY_BASIC_2000(2018, 4, 21) and nowbasicyday <= SCR_DATE_TO_YDAY_BASIC_2000(2018, 4, 29) then
        if wday == 1 or wday == 7 then
            return 'YES'
        end
    end

    return 'NO'
end

-- EVENT_1804_WEEKEND_BUFF_REMOVE
function EVENT_1804_WEEKEND_BUFF_REMOVE(self)
    if IsBuffApplied(self, 'Event_1710_Holiday') == 'YES' then
        if IS_BASIC_FIELD_DUNGEON(self) ~= 'YES' or IS_DAY_EVENT_1804_WEEKEND(self) ~= 'YES' then
            RemoveBuff(self, 'Event_1710_Holiday')
        end
    else
        if IS_BASIC_FIELD_DUNGEON(self) == 'YES' and IS_DAY_EVENT_1804_WEEKEND(self) == 'YES' then
            AddBuff(self, self, 'Event_1710_Holiday')
        end
    end
end

--
--
---- Event_1802_weekend
--function SCR_BUFF_ENTER_Event_1802_weekend(self, buff, arg1, arg2, over)
--end
--
--function SCR_BUFF_LEAVE_Event_1802_weekend(self, buff, arg1, arg2, over)
--end
