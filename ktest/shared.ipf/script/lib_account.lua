local TAB_SLOT_COUNT = 70

function GET_COUNT_ACCOUNT_WAREHOUSE_SLOT_PER_TAB()
    return TAB_SLOT_COUNT
end

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
-- 0 / 1
-- tab_index 0 ~
function IS_VALID_INDEX_OF_ACCOUNT_WAREHOUSE(invIndex, pc)    
    if IsPremiumState(pc, ITEM_TOKEN) ~= 1 then
        local cnt = GET_ACCOUNT_WAREHOUSE_SLOT_COUNT(pc, accountObj)        
        if invIndex < 0 or invIndex > cnt then
            return 0
        else
            return 1
        end
    elseif IsPremiumState(pc, ITEM_TOKEN) == 1 then
        if invIndex >= TAB_SLOT_COUNT and invIndex < TAB_SLOT_COUNT + (TAB_SLOT_COUNT * 4) then
            return 1
        else
            return 0
        end
    end

    return 0
end