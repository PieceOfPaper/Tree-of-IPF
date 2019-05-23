function IS_VALID_ITEM_FOR_GIVING_PREFIX(item)
    if TryGetProp(item, 'LegendGroup', 'None') == 'None' then
        return false;        
    end

    return true;
end

-- 스택형 한종류 아이템 이름은 반환
function GET_LEGEND_PREFIX_MATERIAL_ITEM_NAME(legendgroup)
    return 'Legend_ExpPotion_2_complete';
end

function GET_LEGEND_PREFIX_NEED_MATERIAL_COUNT(item)
    if item == nil then
        return 0;
    end
    
    if item.LegendGroup == 'Velcoffer' then
        if item.GroupName == 'Armor' then
            return 6;
        end
        return 24;
    elseif item.LegendGroup == 'Savinose' or item.LegendGroup == 'Varna' then
        if item.GroupName == 'Armor' then
            return 8;
        end
        return 26;
    else
        return 99999;
    end



end

function GET_LEGEND_PREFIX_ITEM_NAME(item, prefix)
    if prefix == nil then
        prefix = TryGetProp(item, 'LegendPrefix', 'None');
    end
    
    local nameText = item.Name;    
	if prefix ~= 'None' then
		local prefixCls = GetClass('LegendSetItem', prefix);
        if prefixCls ~= nil then
		    nameText = prefixCls.Name..' '..nameText;
        end
	end
	return nameText;
end
