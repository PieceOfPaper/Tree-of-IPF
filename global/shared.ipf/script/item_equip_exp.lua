-- item_equip_exp.lua

function GET_MORE_EXP_BOOST_TOKEN(pc)
	local sumExp = 0.0;
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Premium_boostToken');	-- 경험의 서 경험치
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Premium_boostToken02');	-- 경험의서 4배
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Premium_boostToken03');	-- 경험의서 8배
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Premium_boostToken04'); -- 이벤트 경험의 서
	return sumExp;
end

function GET_MORE_EVENT_EXP(pc)
	local sumExp = 0.0;
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_LargeSongPyeon');	-- 대왕송편
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Largehoney_Songpyeon'); -- 대왕꿀송편
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_161110_candy'); -- 대왕꿀송편
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_161215_1'); -- 축복이 깃든 새싹 1단계
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_161215_2'); -- 축복이 깃든 새싹 2단계
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_161215_3'); -- 축복이 깃든 새싹 3단계
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_161215_4'); -- 축복이 깃든 새싹 4단계
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_161215_5'); -- 축복이 깃든 새싹 5단계
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Premium_Fortunecookie_1'); -- 포춘 쿠키 1단계
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Premium_Fortunecookie_2'); -- 포춘 쿠키 2단계
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Premium_Fortunecookie_3'); -- 포춘 쿠키 3단계
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Premium_Fortunecookie_4'); -- 포춘 쿠키 4단계
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Premium_Fortunecookie_5'); -- 포춘 쿠키 5단계
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Rice_Soup');	-- 떡국
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_LargeRice_Soup');	-- 특대 떡국
        sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_WhiteDay_Buff');	-- 화이트데이
        sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Goddess');	-- 여신의 조각상
        sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_RedOrb_GM');	-- 이벤트 참여
        sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_ManWoo_Pet_1'); --pet
        sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_FireSongPyeon'); --스팀1주년 폭죽 
	return sumExp; 
end

function GET_MORE_EVENT_EXP_JAEDDURY(pc)
	local sumExp = 0.0;
	if "YES" == IsBuffApplied(pc, 'Event_CharExpRate') then
		local etc = GetETCObject(pc);
		local rate = TryGetProp(etc, "EventCharExpRate");
		if rate ~= nil and rate > 0 then
			sumExp = sumExp + rate;
		end		
	end	
	return sumExp; 
end

-- 아이템의 exp 를 설정 ItemExp
function GET_MIX_MATERIAL_EXP(item)
	if item.EquipXpGroup == "None" then
		return 0;
	end

	local prop = geItemTable.GetProp(item.ClassID);
	local itemExp = TryGetProp(item, 'ItemExp')
	
	if itemExp ~= nil then
	    if item.ItemType == "Equip" then
	        return item.ItemLv;
	    elseif item.EquipXpGroup == 'hethran_material' then
			return itemExp;
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
