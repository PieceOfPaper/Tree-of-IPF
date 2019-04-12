
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