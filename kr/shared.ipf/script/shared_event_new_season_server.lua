-- 2008 여름 시즌서버
function IS_SEASON_SERVER(pc)
    local groupid = GetServerGroupID();
    
    -- qa 1006, 스테이지 8001
    if (GetServerNation() == "KOR" and (groupid == 1006 or groupid == 8001)) then
        return "YES";
    end

    if (GetServerNation() == "KOR" and (groupid == 3001 or groupid == 3002)) then
        return "YES";
    end

    if (GetServerNation() == "GLOBAL" and (groupid == 10001 or groupid == 10003 or groupid == 10004 or groupid == 10005)) then
        return "YES";
    end

    if pc ~= nil then
        local accObj = nil;
        if IsServerObj(pc) == 1 then
            accObj = GetAccountObj(pc);
        else
            accObj = GetMyAccountObj();
        end

        if accObj == nil then
            return "NO";
        end
        
        local value = TryGetProp(accObj, "EVENT_NEW_SEASON_SERVER_ACCOUNT", 0);     
        if value == GET_SEASON_SERVER_CHECK_PROP_VALUE() then
            return "YES";
        else
            return "NO";
        end
    end

    return "NO";
end

function IS_SEASON_SERVER_OPEN()
    local now_time = date_time.get_lua_now_datetime_str();
    local end_time = "2020-08-06 06:00:00";
    
    return date_time.is_later_than(now_time, end_time);
end

function GET_SEASON_SERVER_CHECK_PROP_VALUE()
    if GetServerNation() == "KOR" then
        return 1;
    end

    if GetServerNation() == "GLOBAL" then
        return 2;
    end
end