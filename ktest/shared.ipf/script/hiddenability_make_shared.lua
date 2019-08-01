-- 등록 가능 재료
function IS_HIDDENABILITY_MATERIAL_PIECE(itemobj)
    if TryGetProp(itemobj, 'ClassName', 'None') == "HiddenAbility_Piece" then
		return true;
	end
    
    return false;
end

function IS_HIDDENABILITY_MATERIAL_STONE(itemobj)
    if TryGetProp(itemobj, 'ClassName', 'None') == "Premium_item_transcendence_Stone" then
		return true;
	end
    
    
    return false;
end

function IS_HIDDENABILITY_MATERIAL_TOTAL_CUBE(itemobj)
    if TryGetProp(itemobj, 'ClassName', 'None') == "HiddenAbility_TotalCube" then
		return true;
	end
    
    return false;
end

-- 신비한 서 제작시 필요한 신비한 서 낱장 개 수 
function HIDDENABILITY_MAKE_NEED_PIECE_COUNT(ClassName)
    if ClassName == "HiddenAbility_TotalCube" then
        return 2;
    end
    
    return 10;
end

-- 신비한 서 제작시 필요한 여신의 축복석 개 수 
function HIDDENABILITY_MAKE_NEED_STONE_COUNT(ClassName)
    return 10;
end

-- 신비한 서 분해가 가능한 아이템인지 
function IS_HIDDENABILITY_DECOMPOSE_MATERIAL(itemobj)
    if TryGetProp(itemobj, 'GroupName', 'None') == "HiddenAbility" then
        return true;
    end

    return false;
end
