function IS_LEGEND_MISC_EXCHANGE_ITEM(itemObj)
    local clslist, cnt  = GetClassList("legend_misc_exchange_list");
	for i = 0 , cnt - 1 do
        local cls = GetClassByIndexFromList(clslist, i);
        if cls.ClassName == itemObj.StringArg then
            return true;
        end
    end

    return false;
end

function GET_LEGEND_MISC_EXCHANGE_ITEM_LIST(changegroup)
    local classnameList = {};

	local cls = GetClass("legend_misc_exchange_list", changegroup);
    local strlist = StringSplit(cls.ChangeItem, '/');
    return strlist;
end

function GET_LEGEND_MISC_EXCHANGE_MATERIAL_LIST(changegroup)
    local classnameList = {};
    local needCntList = {};

    local cls = GetClass("legend_misc_exchange_list", changegroup);
    local matCnt = cls.MaterialItemCnt;
	for i = 1, matCnt do
		local propName = "MaterialItem_"..i;
		local itemClassName = TryGetProp(cls, propName);
		local needCnt = TryGetProp(cls, propName.."_cnt");
        
        classnameList[i] = itemClassName;
        needCntList[i] = needCnt;
    end
    
    return classnameList, needCntList;
end
