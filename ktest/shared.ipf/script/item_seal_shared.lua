-- 인장 아이템
function IS_SEAL_ITEM(item)
    if item == nil then
        return false;
    end

    if TryGetProp(item, 'GroupName', 'None') == 'Seal' then
        return true;
    end

    return false;
end

-- 재료 인장 아이템
function IS_SEAL_MATERIAL_ITEM(item)
    if item == nil then
        return false;
    end

    if TryGetProp(item, 'StringArg', 'None') == 'Seal_Material' then
        return true;
    end

    return false;
end

-- 인장 강화 재료 아이템
function IS_VALID_SEAL_MATERIAL_ITEM(targetSeal, materialSeal)
    if IS_SEAL_MATERIAL_ITEM(targetSeal) == true and IS_SEAL_MATERIAL_ITEM(materialSeal) ~= true then
        return false, "SealMaterialTargetItemWarning";
    end

    if IS_SEAL_ITEM(targetSeal) == false or IS_SEAL_ITEM(materialSeal) == false then        
        return false;
    end

    if targetSeal.ItemGrade ~= materialSeal.ItemGrade then
        return false;
    end

    if GET_CURRENT_SEAL_LEVEL(targetSeal) ~= GET_CURRENT_SEAL_LEVEL(materialSeal) then
        return false;
    end

    return true;
end

-- 현재 인장 강화 레벨
function GET_CURRENT_SEAL_LEVEL(item)
    if IS_SEAL_ITEM(item) == false then
        return 0;
    end

    for i = 1, item.MaxReinforceCount do
        if TryGetProp(item, 'SealOption_'..i, 'None') == 'None' then
            return i - 1;
        end
    end
    return item.MaxReinforceCount;
end

-- 인장 강화 재료(마정석) 아이템 -- 
function IS_SEAL_ADDITIONAL_ITEM(item)
    if item.ClassName ~= GET_SEAL_ADDITIONAL_ITEM() then
        return;
    end
    return true;
end

-- 인장 강화 재료 아이템 최대 개수
function GET_MAX_SEAL_ADDIONAL_ITEM_COUNT(targetSeal, materialSeal)
    local matMaxCount = 0;
    
    if targetSeal == nil then
        return 0;
    end

    local itemlv = TryGetProp(targetSeal, 'UseLv')
    if itemlv == nil then
        return 0;
    end
    
    local grade = TryGetProp(targetSeal, 'ItemGrade')
    if grade == nil then
        return 0;
    end
    
    local reinforce = GET_CURRENT_SEAL_LEVEL(targetSeal)
    
    matMaxCount = 1 + ((itemlv / 50) + (reinforce ^ 3 ) ) * ((grade-1) / 5)

    return math.floor(matMaxCount);
end

-- 인장 강화 가격 --
function GET_SEAL_PRICE(targetSeal, materialSeal, additionalItem, additionalItemCount, taxRate)
    if targetSeal == nil then
        return 0;
    end

    local itemlv = TryGetProp(targetSeal, 'UseLv')
    local grade = TryGetProp(targetSeal, 'ItemGrade')
    local reinforceValue = GET_CURRENT_SEAL_LEVEL(targetSeal)

    local price = math.floor((grade ^ (reinforceValue / 2) * itemlv * 500) / 1000)
    price = price * 1000

    if taxRate ~= nil then
        price = tonumber(CALC_PRICE_WITH_TAX_RATE(price, taxRate))
    end

    return SyncFloor(price);
end