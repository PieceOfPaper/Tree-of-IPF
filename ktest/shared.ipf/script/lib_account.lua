function GET_ACCOUNT_WAREHOUSE_SLOT_COUNT(pc, accountObj)
    if accountObj == nil then
        return 0;
    end
    local slotCount = accountObj.BasicAccountWarehouseSlotCount + accountObj.MaxAccountWarehouseCount + accountObj.AccountWareHouseExtend + accountObj.AccountWareHouseExtendByItem;
    -- token
    if IsServerObj(pc) == 1 then
        if IsPremiumState(pc, ITEM_TOKEN) == 1 then
            slotCount = slotCount + ADDITIONAL_SLOT_COUNT_BY_TOKEN;
        end
    else
        if session.loginInfo.IsPremiumState(ITEM_TOKEN) == true then
            slotCount = slotCount + ADDITIONAL_SLOT_COUNT_BY_TOKEN;
        end
    end
    return slotCount;
end