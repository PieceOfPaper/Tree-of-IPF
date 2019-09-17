-- 등록 가능 재료
function IS_HIDDENABILITY_MATERIAL_PIECE(itemobj)    
    if TryGetProp(itemobj, 'ClassName', 'None') == "HiddenAbility_Piece" then
		return true;
	end
    
    if itemobj.StringArg == "HiddenAbility_MasterPiece" then
		return true;
    end

    if itemobj.StringArg == "Event_HiddenAbility_MasterPiece" then
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

-- 신비한 서 제작시 여신의 축복석 아이템이 필요없는 아이템
function IS_HIDDENABILITY_MATERIAL_MASTERPIECE(itemobj)
    if itemobj.StringArg == "HiddenAbility_MasterPiece" then
		return true;
	end
    
    if itemobj.StringArg == "Event_HiddenAbility_MasterPiece" then
		return true;
	end
    
    return false;
end

-- 신비한 서 제작시 필요한 신비한 서 낱장 개 수 
function HIDDENABILITY_MAKE_NEED_PIECE_COUNT(ClassName, itemobj)
    if itemobj.StringArg == "HiddenAbility_MasterPiece" then
		return 1;
    end

    if itemobj.StringArg == "Event_HiddenAbility_MasterPiece" then
		return 1;
    end

    return 2;
end

-- 신비한 서 제작시 필요한 여신의 축복석 개 수 
function HIDDENABILITY_MAKE_NEED_STONE_COUNT(ClassName)
    return 5;
end

-- 분해 가능한 신비한 서(낱장) 인가
function IS_HIDDENABILITY_DECOMPOSE_MATERIAL(itemobj)
    if TryGetProp(itemobj, 'ClassName', 'None') == "HiddenAbility_Piece" then
		return true;
    end
    
    return false;
end

-- 분해 가능한 신비한 서 인가
function IS_HIDDENABILITY_DECOMPOSE_BOOK_MATERIAL(itemobj)
    local ClassName = TryGetProp(itemobj, 'ClassName', 'None')
    local StringArg = TryGetProp(itemobj, 'StringArg', 'None')
    
    if string.find(ClassName, 'HiddenAbility_') ~= nil and StringArg ~= 'HiddenAbility_MasterPiece' then
        local cls = GetClass('Item', ClassName)
        if cls ~= nil then
            return true
        end
    end

    if string.find(ClassName, 'HiddenAbility_') ~= nil and StringArg ~= 'Event_HiddenAbility_MasterPiece' then
        local cls = GetClass('Item', ClassName)
        if cls ~= nil then
            return true
        end
    end
    
    return false
end