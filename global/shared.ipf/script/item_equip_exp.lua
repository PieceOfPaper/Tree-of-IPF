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
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Danoh_3'); --대만 단오절
    sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_WeddingCake'); -- 웨딩 케잌
    sumExp = sumExp + IsBuffAppliedEXP(pc, 'EVENT_1706_FREE_EXPUP'); --이런 이벤트
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Steam_Wedding'); --스팀 웨딩 이벤트
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Nru_Buff_Item'); --해외 신규 유저 이벤트
    sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Monster_EXP_UP'); --해외 페이스북 컴패니언 이벤트
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Steam_Happy_New_Year'); --해외 신년 이벤트
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Umbrella_1'); --비 이벤트
    sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Umbrella_2'); --비 이벤트
    sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Umbrella_3'); --비 이벤트
    sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Umbrella_4'); --비 이벤트
    sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Umbrella_5'); --비 이벤트
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'EVENT_1708_JURATE_1'); --비 이벤트
    sumExp = sumExp + IsBuffAppliedEXP(pc, 'EVENT_1712_SECOND_BUFF'); --2주년 기념수의 축복
    sumExp = sumExp + IsBuffAppliedEXP(pc, 'EVENT_1712_XMAS_FIRE'); --크리스마스 폭죽 이벤트
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Steam_Last_Winter'); --마지막 겨울
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Steam_Base_Buff'); --해외 버프
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_7Day_Exp_1'); --출석 체크
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_7Day_Exp_2'); --출석 체크
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_7Day_Exp_3'); --출석 체크
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_7Day_Exp_4'); --출석 체크
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_7Day_Exp_5'); --출석 체크
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_7Day_Exp_6'); --출석 체크
	sumExp = sumExp + IsBuffAppliedEXP(pc, 'Event_Steam_Server_Buff'); --스팀 버전업 이벤트 
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
	        return item.UseLv;
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
