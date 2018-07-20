function SCR_PRECHECK_LETICIA_CONSUME(isServer)
--7월 1일 전에는 사용 못하도록 제어 --
    if GetServerNation() ~= "KOR" then
        return 'YES'
    end

    local sysTime = nil;
    if isServer == "SERVER" then
        sysTime = GetDBTime();
    else
        sysTime = geTime.GetServerSystemTime();
    end
    
    if sysTime == nil then
        return "NO";
    end
    
    local nowTime = tonumber(string.format("%04d%02d%02d%02d", sysTime.wYear, sysTime.wMonth, sysTime.wDay, sysTime.wHour))
    
    
    if nowTime >= 2017070118 and nowTime <= 2017073123 then
        return 'YES'
    end
    
    return "NO"
end
