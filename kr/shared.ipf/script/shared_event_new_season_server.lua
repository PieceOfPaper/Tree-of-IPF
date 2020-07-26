-- 글로벌 신섭 룰렛 이벤트 가능 조건 확인
function IS_EVENT_NEW_SEASON_SERVER(accObj)
    if GetServerNation() == 'GLOBAL' then
        local groupid = GetServerGroupID();
        if groupid == 10001 or groupid == 10003 or groupid == 10004 or groupid == 10005 then
            return true;
        end

        local prop = TryGetProp(accObj, "EVENT_NEW_SEASON_SERVER_ACCOUNT", 0);
        if prop == 1 then
            if GetServerGroupID() == 1001 or GetServerGroupID() == 2001 then
                return true;
            elseif GetServerGroupID() == 1003 or GetServerGroupID() == 2003 then
                return true;
            elseif GetServerGroupID() == 1004 or GetServerGroupID() == 2004 then
                return true;
            elseif GetServerGroupID() == 1005 or GetServerGroupID() == 2005 then
                return true;
            end
        end        
        
    end

    return false;
end
