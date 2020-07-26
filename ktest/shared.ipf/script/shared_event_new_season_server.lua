-- 글로벌 신섭 룰렛 이벤트 가능 조건 확인
function IS_EVENT_NEW_SEASON_SERVER(accObj)
    if GetServerNation() == 'GLOBAL' then
        local groupid = GetServerGroupID();
        if groupid == 10001 or groupid == 10003 or groupid == 10004 or groupid == 10005 then
            return true;
        end

        if accObj == nil then
            return false;
        end

        local prop = TryGetProp(accObj, "EVENT_NEW_SEASON_SERVER_ACCOUNT", 0);
        if prop == 1 then
            if groupid == 1001 or groupid == 2001 then
                return true;
            elseif groupid == 1003 or groupid == 2003 then
                return true;
            elseif groupid == 1004 or groupid == 2004 then
                return true;
            elseif groupid == 1005 or groupid == 2005 then
                return true;
            end
        end        
        
    end

    return false;
end
