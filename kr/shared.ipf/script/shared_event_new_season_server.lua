-- 글로벌 신섭 룰렛 이벤트 가능 조건 확인
function IS_EVENT_NEW_SEASON_SERVER(accObj)
    return false;
end

-- 2008 여름 시즌서버
function IS_SEASON_SERVER(pc)
    local groupid = GetServerGroupID();
    
    if (GetServerNation() == "KOR" and (groupid == 3001 or groupid == 3002)) then
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
        if value == 1 then
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