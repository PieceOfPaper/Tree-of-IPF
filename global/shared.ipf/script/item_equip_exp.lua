-- item_equip_exp.lua

function GET_MORE_EXP_BOOST_TOKEN(pc)
	
	-- 경험의서 8배
	if 'YES' == IsBuffApplied(pc, 'Premium_boostToken03') then
		return 3.0;
	end

	-- 경험의서 4배
	if 'YES' == IsBuffApplied(pc, 'Premium_boostToken02') then
		return 1.5;
	end

	-- 이벤트 경험의 서
	if 'YES' == IsBuffApplied(pc, 'Premium_boostToken04') then
		return 0.5;
	end

	-- 경험의 서 경험치
	if 'YES' == IsBuffApplied(pc, 'Premium_boostToken') then
		return 0.3;
	end

	return 0.0;
end

function GET_MIX_MATERIAL_EXP(item)

	if item.EquipXpGroup == "None" then
		return 0;
	end

	local prop = geItemTable.GetProp(item.ClassID);
	local itemExp = TryGetProp(item, 'ItemExp')
	if itemExp ~= nil then
	    if item.ItemType == "Equip" then
	        return item.ItemLv;
	    end
		return prop:GetMaterialExp(itemExp);
	end
	
	return 0;
end

function GET_ITEM_LEVEL(item)

	local expValue = TryGetProp(item, "ItemExp");
	if expValue == nil then
		return 0;
	end

	local prop = geItemTable.GetProp(item.ClassID);
	local itemExp = TryGetProp(item, 'ItemExp');
	return prop:GetLevel(itemExp);

end

function GET_ITEM_MAX_LEVEL(item)
	local prop = geItemTable.GetProp(item.ClassID);	
	return prop:GetMaxLevel();
end

function GET_ITEM_PREV_LEVEL(item, Exp)
	
	if Exp == nil then
		Exp = item.ItemExp;
	end

	local prop = geItemTable.GetProp(item.ClassID);	
	local lv = prop:GetPrevByExp(Exp); 

	return lv;
end


function GET_ITEM_LEVEL_EXP(item, itemExp)

	if itemExp == nil then
		itemExp = item.ItemExp;
	end

	local prop = geItemTable.GetProp(item.ClassID);
	local lv = prop:GetLevel(itemExp);
	local curExp = prop:GetCurExp(itemExp);
	local maxExp = prop:GetMaxExp(itemExp);
	return lv, curExp, maxExp;

end

function GET_ITEM_LEVEL_EXP_BYCLASSID(ClassID, itemExp)
	local prop = geItemTable.GetProp(ClassID);
	local lv = prop:GetLevel(itemExp);
	local curExp = prop:GetCurExp(itemExp);
	local maxExp = prop:GetMaxExp(itemExp);
	return lv, curExp, maxExp;

end


function IS_ITEM_UPGRADABLE(item)

	local prop = geItemTable.GetProp(item.ClassID);
	if prop:Upgradable() == false then
		return false;
	end

	local curLevel = GET_ITEM_LEVEL(item);
	if curLevel >= prop:GetMaxLevel() and prop:GetMaxLevel() > 0 then
		return true;
	end

	return false;

end

function GET_MATERIAL_PRICE(item)

	local prop = geItemTable.GetProp(item.ClassID);
	local lv = prop:GetExpInfo(item.ItemExp);
	if lv == nil then
		return item.MaterialPrice;
	end

	return lv.priceMultiple * item.MaterialPrice

end

function GET_ITEM_EXP_BY_LEVEL(item, level)

	local prop = geItemTable.GetProp(item.ClassID);
	local lv = prop:GetExpInfoByLevel(level);
	if lv == nil then
		return 0;
	end

	return lv.totalExp;


end

function GET_WEAPON_PARAM_LIST(item, list)

	local prop = geItemTable.GetProp(item.ClassID);
	local cnt = prop:GetExpPropCount();
	list[1] = "Level";
	for i = 0 , cnt - 1 do
		list[i+2] = prop:GetExPropByIndex(i);
	end

end
