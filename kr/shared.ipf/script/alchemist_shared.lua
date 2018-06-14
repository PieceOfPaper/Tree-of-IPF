--alchemist_shared.lua

function GET_BRIQUETTING_NEED_LOOK_ITEM_CNT(targetItem) -- hs_comment: 안용씨 또는 재성씨 여기 브리케팅 할 때 필요한 외형 무기 개수 공식 써주세여 --
	local needItem = 6 - targetItem.ItemGrade

	return needItem;
		end
		
function GET_BRIQUETTING_NEED_MATERIAL_LIST(targetItem) -- hs_comment: 안용씨 또는 재성씨 여기 브리케팅 할 때 소멸될 재료 아이템 이름이랑 개수 리스트 반환시켜주세요 --
	if targetItem.ItemGrade > 3 then
		return 'misc_ore23', 1;
	else
		return 'misc_ore22', 1;
		end
	
	return 'None', -1;
	end

function GET_BRIQUETTING_PRICE(targetItem, lookItem, lookMaterialItemList)
	if IS_BRIQUETTING_DUMMY_ITEM(lookItem) == true then
		return 0;
end

	for i = 1, #lookMaterialItemList do
		if IS_BRIQUETTING_DUMMY_ITEM(lookMaterialItemList[i]) == true then
		return 0;
	end
	end

	return targetItem.ItemGrade * 200000; -- hs_comment: 정수씨? 안용씨? 재성씨? 여기 브리케팅 실버 비용 공식 써주세요 --
end

function IS_BRIQUETTING_DUMMY_ITEM(item)
	if item.StringArg == 'BriquettingDummy' then -- hs_comment: 재성씨 여기 목각 아이템 StringArg 정해서 써주세여. 일단 제맘대로 해둠 --
		return true;
	end
	
	return false;
end

function IS_VALID_LOOK_MATERIAL_ITEM(lookItem, lookMatItemList)
	for i = 1, #lookMatItemList do
		local lookMatItem = lookMatItemList[i];
		if lookItem.ClassName ~= lookMatItem.ClassName then
			if IS_BRIQUETTING_DUMMY_ITEM(lookMatItem) == false then
				return false;
			end
			
			-- 목각 코어인 경우
			if lookMatItem.ItemGrade < lookItem.ItemGrade then -- 등급이 이상이면 통과. 아니면 실패
				return false;
			end
		end
end

	return true;
end