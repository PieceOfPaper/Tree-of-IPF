function EVENT_1806_WEEKEND(self)
    if IsBuffApplied(self, 'EVENT_1806_WEEKEND_BUFF') == 'YES' then
        if IS_DAY_EVENT_1806_WEEKEND_INDUN_SILVER() ~= 'YES' then
            RemoveBuff(self, 'EVENT_1806_WEEKEND_BUFF')
        end
    else
        if IS_DAY_EVENT_1806_WEEKEND_INDUN_SILVER() == 'YES' then
            AddBuff(self, self, 'EVENT_1806_WEEKEND_BUFF')
        end
    end
end

function IS_DAY_EVENT_1806_WEEKEND_INDUN_SILVER()
    local now_time = os.date('*t')
    local month = now_time['month']
    local year = now_time['year']
    local day = now_time['day']
    local wday = now_time['wday']
    local hour = now_time['hour']

    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)

    if nowbasicyday <= SCR_DATE_TO_YDAY_BASIC_2000(2018, 7, 12) then
        if wday == 1 or (wday == 7 and hour >= 6) or (wday == 2 and hour < 6) then
            return 'YES'
        end
    end

    return 'NO'
end

--function IS_DAY_EVENT_1806_WEEKEND()
--    local now_time = os.date('*t')
--    local month = now_time['month']
--    local year = now_time['year']
--    local day = now_time['day']
--    local wday = now_time['wday']
--
--    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
--    if nowbasicyday <= SCR_DATE_TO_YDAY_BASIC_2000(2018, 7, 12) then
--        if wday == 1 or wday == 7 then
--            return 'YES'
--        end
--    end
--
--    return 'NO'
--end

-- EVENT_1806_WEEKEND_BUFF_REMOVE
function EVENT_1806_WEEKEND_BUFF_REMOVE(self)
    if IsBuffApplied(self, 'EVENT_1806_WEEKEND_BUFF') == 'YES' then
        if IS_DAY_EVENT_1806_WEEKEND_INDUN_SILVER() ~= 'YES' then
            RemoveBuff(self, 'EVENT_1806_WEEKEND_BUFF')
        end
    else
        if IS_DAY_EVENT_1806_WEEKEND_INDUN_SILVER() == 'YES' then
            AddBuff(self, self, 'EVENT_1806_WEEKEND_BUFF')
        end
    end
end


function SCR_BUFF_ENTER_EVENT_1806_WEEKEND_BUFF(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 1
end
function SCR_BUFF_UPDATE_EVENT_1806_WEEKEND_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end
function SCR_BUFF_LEAVE_EVENT_1806_WEEKEND_BUFF(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 1
end

