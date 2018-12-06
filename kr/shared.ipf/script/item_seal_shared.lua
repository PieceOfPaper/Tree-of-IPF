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

-- 인장 강화 재료 아이템
function IS_VALID_SEAL_MATERIAL_ITEM(targetSeal, materialSeal)    
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
    return MAX_SEAL_OPTION_COUNT;
end

-- 인장 강화 기본 확률 -- hs_comment: 재성씨!
function GET_SEAL_BASIC_RATIO(targetSeal, materialSeal)
    local curReinforceValue = GET_CURRENT_SEAL_LEVEL(targetSeal);

    return 50;
end

-- 인장 강화 마정석 증폭 확률 -- hs_comment: 재성씨!
function GET_SEAL_ADDITIONAL_RATIO(targetSeal, materialSeal, additionalItem, additionalItemCount)
    local basicRatio = GET_SEAL_BASIC_RATIO(targetSeal, materialSeal); -- 기본 확률
    local maxNeedItemCount = GET_MAX_SEAL_ADDIONAL_ITEM_COUNT(targetSeal, materialSeal); -- 넣을 수 있는 마정석 최대 개수



    return additionalItem.UseLv * additionalItemCount;
end

-- 인장 강화 재료(마정석) 아이템 -- hs_comment: 재성씨!
function IS_SEAL_ADDITIONAL_ITEM(item)
    if item.ClassName ~= GET_SEAL_ADDITIONAL_ITEM() then
        return;
    end
    return true;
end

-- 인장 강화 재료 아이템 최대 개수 -- hs_comment: 재성씨!
function GET_MAX_SEAL_ADDIONAL_ITEM_COUNT(targetSeal, materialSeal)
    return 20;
end

-- 인장 강화 가격 -- hs_comment: 재성씨!
function GET_SEAL_PRICE(targetSeal, materialSeal, additionalItem, additionalItemCount)
    return 10000;
end