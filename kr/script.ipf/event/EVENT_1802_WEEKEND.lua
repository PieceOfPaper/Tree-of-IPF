function EVENT_1802_WEEKEND(self)
    if IsBuffApplied(self, 'ENTER_Event_1802_weekend') == 'YES' then
        if IS_DAY_EVENT_1802_WEEKEND(self) ~= 'YES' then
            RemoveBuff(self, 'Event_1802_weekend')
        end
    else
        if IS_DAY_EVENT_1802_WEEKEND(self) == 'YES' then
            AddBuff(self, self, 'Event_1802_weekend')
        end
    end
end

function IS_DAY_EVENT_1802_WEEKEND(self)
    local now_time = os.date('*t')
    local month = now_time['month']
    local year = now_time['year']
    local day = now_time['day']
    local wday = now_time['wday']

    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)

    if nowbasicyday >= SCR_DATE_TO_YDAY_BASIC_2000(2018, 2, 22) and nowbasicyday <= SCR_DATE_TO_YDAY_BASIC_2000(2018, 3, 8) then
        if wday == 1 or wday == 7 or (month == 3 and day == 1) then
            return 'YES'
        end
    end

    return 'NO'
end


-- Event_1802_weekend
function SCR_BUFF_ENTER_Event_1802_weekend(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM + 100;
    self.MATK_BM = self.MATK_BM + 100;
    self.DEF_BM = self.DEF_BM + 100;
    self.MDEF_BM = self.MDEF_BM + 100;
    self.MSPD_BM = self.MSPD_BM + 3;
end

function SCR_BUFF_LEAVE_Event_1802_weekend(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM - 100;
    self.MATK_BM = self.MATK_BM - 100;
    self.DEF_BM = self.DEF_BM - 100;
    self.MDEF_BM = self.MDEF_BM - 100;
    self.MSPD_BM = self.MSPD_BM - 3;
end
