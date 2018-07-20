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

function GET_RECIPE_GROUP_NAME(groupname)

	if groupname == 'Wood' then
		return ScpArgMsg('RecipeGroup_Wood')
	end

	if groupname == 'Quest' then
		return ScpArgMsg('RecipeGroup_Quest')
	end

	if groupname == 'Weapon' then
		return ScpArgMsg('RecipeGroup_Weapon')
	end

	if groupname == 'Armor' then
		return ScpArgMsg('RecipeGroup_Armor')
	end

	if groupname == 'THSword' then
		return ScpArgMsg('RecipeGroup_THSword')
	end

	if groupname == 'Neck' then
		return ScpArgMsg('RecipeGroup_Neck')
	end

	if groupname == 'Pants' then
		return ScpArgMsg('RecipeGroup_Pants')
	end

	if groupname == 'THBow' then
		return ScpArgMsg('RecipeGroup_THBow')
	end

	if groupname == 'Bow' then
		return ScpArgMsg('RecipeGroup_Bow')
	end

	if groupname == 'Sword' then
		return ScpArgMsg('RecipeGroup_Sword')
	end

	if groupname == 'Staff' then
		return ScpArgMsg('RecipeGroup_Staff')
	end

	if groupname == 'Mace' then
		return ScpArgMsg('RecipeGroup_Mace')
	end

if groupname == 'THMace' then
		return ScpArgMsg('RecipeGroup_THMace')
	end

	if groupname == 'None' then
		return ScpArgMsg('RecipeGroup_None')
	end

	if groupname == 'Spear' then
		return ScpArgMsg('RecipeGroup_Spear')
	end

	if groupname == 'Shirt' then
		return ScpArgMsg('RecipeGroup_Shirt')
	end

	if groupname == 'Gloves' then
		return ScpArgMsg('RecipeGroup_Gloves')
	end

	if groupname == 'Boots' then
		return ScpArgMsg('RecipeGroup_Boots')
	end
	
	if groupname == 'Shield' then
		return ScpArgMsg('RecipeGroup_Shield')
	end

	if groupname == 'Material' then
		return ScpArgMsg('RecipeGroup_Material')
	end

	if groupname == 'Ring' then
		return ScpArgMsg('RecipeGroup_Ring')
	end
	
	if groupname == 'THStaff' then
		return ScpArgMsg('RecipeGroup_THStaff')
	end
    
    if groupname == 'THSpear' then
		return ScpArgMsg('RecipeGroup_THSpear')
	end
	
	if groupname == 'Rapier' then
		return ScpArgMsg('RecipeGroup_Rapier')
	end
	
	if groupname == 'Pistol' then
		return ScpArgMsg('RecipeGroup_Pistol')
	end
	
	if groupname == 'Hat' then
		return ScpArgMsg('RecipeGroup_Hat')
	end
	
	if groupname == 'SubWeapon' then
		return ScpArgMsg('RecipeGroup_SubWeapon')
	end
	
	if groupname == 'Artefact' then
		return ScpArgMsg('RecipeGroup_Artefact')
	end

	if groupname == 'Armband' then
		return ScpArgMsg('RecipeGroup_Armband')
	end
	
	if groupname == 'MagicAmulet' then
		return ScpArgMsg('RecipeGroup_MagicAmulet')
	end
	
	if groupname == 'Cannon' then
		return ScpArgMsg('RecipeGroup_Cannon')
	end
	
	if groupname == 'Dagger' then
		return ScpArgMsg('RecipeGroup_Dagger')
	end
	
	if groupname == 'Musket' then
		return ScpArgMsg('RecipeGroup_Musket')
	end
	
	if groupname == 'Premium' then
		return ScpArgMsg('TP_Premium')
	end
	
	if groupname == 'Drug' then
		return ScpArgMsg('Drug')
	end
	
	return groupname;

end

function GET_RECIPE_MATERIAL_INFO(recipeCls, index)
    local clsName = "Item_"..index.."_1";
	local itemName = recipeCls[clsName];
	if itemName == "None" then
		return nil;
	end
		
	local dragRecipeItem = GetClass('Item', itemName);
	local recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(recipeCls, clsName);

	local invItem = nil;
	local invItemlist = nil;
    local ignoreType = false;
    local getMaterialScript = TryGetProp(recipeCls, 'GetMaterialScript');
    -- itemtradeshop.xml처럼 GetMaterialScript 칼럼이 추가될 필요 없는 레시피 클래스를 위해 디폴트 값 입력
    if getMaterialScript == nil then
        getMaterialScript = 'SCR_GET_RECIPE_ITEM';
    end
    local GetMaterialItemListFunc = _G[getMaterialScript];

	if dragRecipeItem.MaxStack > 1 then
		invItem = session.GetInvItemByType(dragRecipeItem.ClassID);
	else
		invItemlist = GetMaterialItemListFunc(dragRecipeItem); -- 기간제는 스택형 ㄴㄴ라서 비스택형만 대체
        ignoreType = true; -- 개수 셀 때 type만 검사하지 않도록 함
	end

	local invItemCnt = GET_PC_ITEM_COUNT_BY_LEVEL(dragRecipeItem.ClassID, recipeItemLv);
    if ignoreType then
        invItemCnt = #invItemlist;
    end

	return recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist;

end