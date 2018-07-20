function EVENT_1805_WEEKEND(self)
    if IsBuffApplied(self, 'EVENT_1805_WEEKEND_BUFF') == 'YES' then
        if IS_DAY_EVENT_1805_WEEKEND(self) ~= 'YES' then
            RemoveBuff(self, 'EVENT_1805_WEEKEND_BUFF')
        end
    else
        if IS_DAY_EVENT_1805_WEEKEND(self) == 'YES' then
            AddBuff(self, self, 'EVENT_1805_WEEKEND_BUFF')
        end
    end
end

function IS_DAY_EVENT_1805_WEEKEND(self)
    local now_time = os.date('*t')
    local month = now_time['month']
    local year = now_time['year']
    local day = now_time['day']
    local wday = now_time['wday']

    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)

    if nowbasicyday <= SCR_DATE_TO_YDAY_BASIC_2000(2018, 6, 28) then
        if wday == 1 or wday == 7 or (month == 5 and day == 22) or (month == 6 and day == 6) or (month == 6 and day == 13) then
            return 'YES'
        end
    end

    return 'NO'
end

-- EVENT_1805_WEEKEND_BUFF_REMOVE
function EVENT_1805_WEEKEND_BUFF_REMOVE(self)
    if IsBuffApplied(self, 'EVENT_1805_WEEKEND_BUFF') == 'YES' then
        if IS_DAY_EVENT_1805_WEEKEND(self) ~= 'YES' then
            RemoveBuff(self, 'EVENT_1805_WEEKEND_BUFF')
        end
    else
        if IS_DAY_EVENT_1805_WEEKEND(self) == 'YES' then
            AddBuff(self, self, 'EVENT_1805_WEEKEND_BUFF')
        end
    end
end


function SCR_BUFF_ENTER_EVENT_1805_WEEKEND_BUFF(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 3
end
function SCR_BUFF_UPDATE_EVENT_1805_WEEKEND_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    Heal(self, 500, 0)
    HealSP(self, 300, 0)
    return 1
end
function SCR_BUFF_LEAVE_EVENT_1805_WEEKEND_BUFF(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 3
end

--
--
---- Event_1802_weekend
--function SCR_BUFF_ENTER_Event_1802_weekend(self, buff, arg1, arg2, over)
--end
--
--function SCR_BUFF_LEAVE_Event_1802_weekend(self, buff, arg1, arg2, over)
--end
