function GET_LIMITATION_TO_BUY(tpItemID)
    local tpItemObj = GetClassByType('TPitem', tpItemID);    
    if tpItemObj == nil then
        return 'NO', 0;
    end

    local accountLimitCount = TryGetProp(tpItemObj, 'AccountLimitCount');
    if accountLimitCount ~= nil and accountLimitCount > 0 then
        return 'ACCOUNT', accountLimitCount;
    end

    local monthLimitCount = TryGetProp(tpItemObj, 'MonthLimitCount');
    if monthLimitCount ~= nil and monthLimitCount > 0 then
        return 'MONTH', monthLimitCount;
    end

    return 'NO', 0;
end

itemOptCheckTable = nil;
function CREATE_ITEM_OPTION_TABLE()
    --추가할 프로퍼티가 존재한다면 밑에다가 추가하면 됨.
    itemOptCheckTable = {
    "Reinforce_2", -- 강화
    "Transcend", -- 초월
    "IsAwaken", -- 각성
    "RandomOptionRareValue",
    }
end

function IS_MECHANICAL_ITEM(itemObject)
    if itemOptCheckTable == nil then
        CREATE_ITEM_OPTION_TABLE();
    end

    if itemOptCheckTable == nil or #itemOptCheckTable == 0 then
        return false;
    end 

    for i = 1, #itemOptCheckTable do
        local itemProp = TryGetProp(itemObject, itemOptCheckTable[i]);
        if itemProp ~= nil then
            if itemProp > 0 then
                return true;
            end
        end
    end

    local maxSocketCnt = TryGetProp(itemObject, 'MaxSocket', 0);
    if maxSocketCnt > 0 then
        if IsServerSection() == 0 then
            local invitem = GET_INV_ITEM_BY_ITEM_OBJ(itemObject);
            if invitem == nil then
                return false;
            end
            for i = 0, itemObject.MaxSocket - 1 do
                if invitem:IsAvailableSocket(i) == true then
                    return true;
                end                
            end
        else
            for i = 0, itemObject.MaxSocket - 1 do
                local equipGemID = GetItemSocketInfo(itemObject, i);
                if equipGemID ~= nil then
                    return true;
                end
            end
        end    
    end

    return false;
end

function GET_COMMON_SOCKET_TYPE()
	return 5;
end