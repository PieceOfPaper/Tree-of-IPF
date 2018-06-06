-- lib_recipe.lua

function SCR_GET_RECIPE_ITEM(recipeMaterialCls)
     return GET_INVITEMS_BY_TYPE_WORTH_SORTED('IS_VALID_RECIPE_MATERIAL', recipeMaterialCls.ClassID);
end

function SCR_GET_RECIPE_ITEM_BOOSTTOKEN(recipeMaterialCls)   
     return GET_INVITEMS_BY_TYPE_WORTH_SORTED('IS_VALID_RECIPE_MATERIAL_FOR_BOOSTTOKEN', recipeMaterialCls.ClassName);
end

function GET_INVITEMS_BY_TYPE_WORTH_SORTED(compareScript, compareProperty)
	local resultlist = {};
	local invItemList = session.GetInvItemList();
	local index = invItemList:Head();
	local itemCount = session.GetInvItemList():Count();
    local CompareFunction = _G[compareScript];

	for i = 0, itemCount - 1 do		
		local invItem = invItemList:Element(index);
		if invItem ~= nil then
			local itemobj = GetIES(invItem:GetObject());		
			if CompareFunction(compareProperty, itemobj) then
				resultlist[#resultlist+1] = invItem;
			end
		end
		index = invItemList:Next(index);
	end
	
	table.sort(resultlist, SORT_INVITEM_BY_WORTH);
	return resultlist
end

function IS_VALID_RECIPE_MATERIAL_FOR_BOOSTTOKEN(compareProperty, itemObj, pc)
    if compareProperty == nil or itemObj == nil then
        return false;
    end

    -- 네이밍 규칙을 통한 검사
    local itemClassName = itemObj.ClassName;
    if itemClassName ~= compareProperty and string.find(itemClassName, compareProperty..'_') == nil then
        return false;
    end
    -- 1분짜리 경험의서는 예외처리 해달라고 하셨음
    if itemClassName == 'Premium_boostToken_test1min' and compareProperty == 'Premium_boostToken' then
        return false;
    end
     -- 기간 지난 것도 안돼
    if itemObj.ItemLifeTimeOver > 0 then
        if pc ~= nil then
            SendSysMsg(pc, 'CannotUseLifeTimeOverItem');
        end
        return false;
    end

    return true;
end

function IS_VALID_RECIPE_MATERIAL(compareProperty, itemObj)
    if compareProperty == nil or itemObj == nil then
        return false;
    end
    local itemType = TryGetProp(itemObj, 'ClassID'); -- ies object인 경우
    if itemType == nil then
        itemType = itemObj.type; -- invItem인 경우
    end
    if compareProperty ~= itemType then
        return false;
    end

    return true;
end

function IS_VALID_RECIPE_MATERIAL_BY_NAME(compareProperty, itemObj)
    if compareProperty == nil or itemObj == nil then
        return false;
    end
    if compareProperty ~= itemObj.ClassName then
        return false;
    end

    return true;
end

function GET_MATERIAL_VALIDATION_SCRIPT(recipeCls)
    local validRecipeMaterial = 'IS_VALID_RECIPE_MATERIAL_BY_NAME';
    local getMaterialScript = TryGetProp(recipeCls, 'GetMaterialScript');
    if getMaterialScript == 'SCR_GET_RECIPE_ITEM_BOOSTTOKEN' then
        validRecipeMaterial = 'IS_VALID_RECIPE_MATERIAL_FOR_BOOSTTOKEN';
    end
    return validRecipeMaterial;
end

function GET_INV_ITEM_COUNT_BY_TYPE(pc, itemType, recipeCls)
    local getMaterialScript = TryGetProp(recipeCls, 'GetMaterialScript');
    if getMaterialScript == 'SCR_GET_RECIPE_ITEM_BOOSTTOKEN' then -- 기간제도 합해서 체크해줘야 하는 경우
        return GET_INV_ITEM_COUNT_BY_TYPE_FOR_BOOSTTOKEN(pc, itemType, recipeCls);
    end
    return GetInvItemCountByType(pc, itemType);
end

function GET_INV_ITEM_COUNT_BY_TYPE_FOR_BOOSTTOKEN(pc, itemType, recipeCls)
    local invItemCount = 0;
    local pcInvList = GetInvItemList(pc);
    local materialItemCls = GetClassByType('Item', itemType);
    if materialItemCls == nil then
        return invItemCount;
    end
    local itemClassName = materialItemCls.ClassName;

    if itemClassName == recipeCls.ClassName then -- 제작서인 경우
        return GetInvItemCountByType(pc, itemType);
    end

    -- 경험의서 재료
    local validRecipeMaterial = GET_MATERIAL_VALIDATION_SCRIPT(recipeCls);
    local IsValidRecipeMaterial = _G[validRecipeMaterial];
    if pcInvList == nil or #pcInvList < 1 then
        return invItemCount;
    end

    for i = 1 , #pcInvList do
        local invItem = pcInvList[i];
        if invItem ~= nil and IsValidRecipeMaterial(itemClassName, invItem) then
            invItemCount = invItemCount + 1;
        end
    end
    return invItemCount;
end

function IS_ALL_MATERIAL_CHECKED(checkList, numCheckList)
    if #checkList < numCheckList then
        print("number of material limit isn't 5?? plz modify item_manufacture.lua!");
        return false;
    end

    for i = 1 , numCheckList do
        if checkList[i] == false then
            return false;
        end
    end
    return true;
end

