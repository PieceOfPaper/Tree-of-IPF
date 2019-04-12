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
function CREATE_ITEM_OTP_TABLE()
    --추가할 프로퍼티가 존재한다면 밑에다가 추가하면 됨.
    itemOptCheckTable = {
    "Reinforce_2", -- 강화
    "Transcend", -- 초월
    "IsAwaken", -- 각성
    "Socket_Equip_0", -- 젬장착
    "Socket_Equip_1",
    "Socket_Equip_2",
    "Socket_Equip_3",
    "Socket_Equip_4",
    "Socket_Equip_5",
    "Socket_Equip_6",
    "Socket_Equip_7",
    "Socket_Equip_8",
    "Socket_Equip_9",
    "Socket_0", -- 소켓 추가
    "Socket_1",
    "Socket_2",
    "Socket_3",
    "Socket_4",
    "Socket_5",
    "Socket_6",
    "Socket_7",
    "Socket_8",
    "Socket_9",
    }
end

function IS_MECHANICAL_ITEM(itemObject)
    if itemOptCheckTable == nil then
        CREATE_ITEM_OTP_TABLE();
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

    return false;
end