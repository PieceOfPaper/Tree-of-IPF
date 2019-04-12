-- gacha_cube.lua --

function GACHA_CUBE_ON_INIT(addon, frame)

end

-- 큐브 뽑기 기능 취소 부분
function CANCEL_GACHA_CUBE()
	SET_MOUSE_FOLLOW_BALLOON(nil);
	ui.SetEscapeScp("");

	CancelGachaCube();												-- 뽑기 취소를 서버에 알림.

	local gachaCubeFrame = ui.GetFrame("gacha_cube");	
	GHACHA_CUBE_UI_RESET(gachaCubeFrame);							-- UI 리셋		
end

-- 버튼 클릭 (2, 3번째 뽑기)
function GACHA_CUBE_OK_BTN(frame, ctrl)
	item.DoPremiumItemGachaCube();	-- 1번째와 다르게 서버에 null값 직접 전송
end

-- 뽑기 성공 후, 결과 UI창 생성하여 띄우기 
function GACHA_CUBE_SUCEECD(invItemClsID, rewardItem, btnVisible)
	-- UI창 얻어와서	 초기화
	local gachaCubeFrame = ui.GetFrame("gacha_cube");	
	GHACHA_CUBE_UI_RESET(gachaCubeFrame);	
	GACHA_CUBE_SUCEECD_UI(gachaCubeFrame, invItemClsID, rewardItem, btnVisible);
end


-- 뽑기 성공 후, 결과 UI창 요소 바꾸기
function GACHA_CUBE_SUCEECD_EX(invItemClsID, rewardItem, btnVisible)	
	-- UI창 얻어와서	 
	local gachaCubeFrame = ui.GetFrame("gacha_cube");	
	GACHA_CUBE_SUCEECD_UI(gachaCubeFrame, invItemClsID, rewardItem, btnVisible);
end
	
--
function GACHA_CUBE_SUCEECD_UI(frame, invItemClsID, rewardItem, btnVisible)
	-- UI창을 호출한 큐브 정보 얻어놓기
	local cubeItem = GetClassByType("Item", invItemClsID);

	-- UI창의 위치 설정
	local invframe = ui.GetFrame("inventory");

	-- 결과 UI 창이 있을때에는 나머지 아이템은 모두 락 상태.
	SET_SLOT_APPLY_FUNC(invframe, "GHACHA_CUBE_ITEM_LOCK", "Consume");
	
	-- UI창의 취소 설정
	ui.SetEscapeScp("CANCEL_GACHA_CUBE()");
	
	-- 프레임의 호출한 아이템 이름 및 버튼의 비용 설정	
	local CubeNameFrame = frame:GetChild("richtext_1");	
	local sucName = string.format("{@st41b}%s", cubeItem.Name);	
	CubeNameFrame:SetTextByKey("value", sucName);
	local BtnFrame = frame:GetChild("button_1");	

	local price = TryGet(cubeItem, "NumberArg1");
	if price ~= nil then
		price = GetCommaedText(price);
	end

	local sucValue = string.format("{@st41b}%s{nl}{img icon_item_silver 20 20 }%s", ScpArgMsg("ONE_MORE_TIME"), price);
	BtnFrame:SetTextByKey("value", sucValue);	
	BtnFrame:SetVisible(btnVisible);

	-- 기회를 모두 소진했을때
	local EndFrame = frame:GetChild("richtext_4");
	if btnVisible == '0'  then
		EndFrame:SetVisible(1);
	else
		EndFrame:SetVisible(0);
	end

	-- 언은 경품 이름으로 오브젝트 정보 찾기
	local reward = GetClass("Item", rewardItem);
		
	-- 뽑은 템을 슬롯에 설정
	local slot  = frame:GetChild("slot");
	SET_SLOT_ITEM_OBJ(slot, reward);							-- 아이템 이름으로 아이콘 설정
	SET_ITEM_TOOLTIP_BY_TYPE(slot:GetIcon(), reward.ClassID);	-- 아이템 툴팁 타입으로 설정
	
	-- 뽑은 템 이름 설정
	local rewardNameFrame = frame:GetChild("itemName");
	rewardNameFrame:SetTextByKey("value", reward.Name);	
	
	if reward.ItemType ~= 'Equip' then
		imcSound.PlaySoundEvent('sys_cube_open_normal');
	else
		imcSound.PlaySoundEvent('sys_cube_open_jackpot');	
	end
	
	-- 설정해 놓은 UI창 보이기
	frame:ShowWindow(1);
end

-- UI 리셋
function GHACHA_CUBE_UI_RESET(frame)	
	frame:SetUserValue("GACHA_CUBE", "None");		-- 호출한 아이템 정보 초기화
	local itemName = frame:GetChild("itemName");	-- 결과물 이름 프레임 받아오기
	itemName:SetTextByKey("value", "");				-- 이름 초기화
		
	local slot  = frame:GetChild("slot");			-- 결과물 슬롯 프레임 받아오기
	slot  = tolua.cast(slot, 'ui::CSlot');			
	slot:ClearIcon();								-- 빈 슬롯으로 초기화

	frame:ShowWindow(0);							-- 프레임 숨기기
	
	local invframe = ui.GetFrame("inventory");		-- 인벤토리 프레임 받아오기
	SET_SLOT_APPLY_FUNC(invframe, "GHACHA_CUBE_ITEM_UNLOCK", "Consume");
	SET_SLOT_APPLY_FUNC(invframe, "None", "Consume");			-- 인벤 슬롯 접근 상태 초기화
end

-- Inven 에서 GHACHA_CUBE 관련 ITEM만 락 시키기 
function GHACHA_CUBE_ITEM_LOCK(slot)
	local item = GET_SLOT_ITEM(slot);
	if nil == item then
		return;
	end
	local obj = GetIES(item:GetObject());
	if TryGetProp(obj, "Script") == "SCR_FIRST_USE_GHACHA_CUBE" then	-- GHACHA_CUBE 관련 ITEM만
		slot:GetIcon():SetGrayStyle(1);						-- 해당 아이템 슬롯 검게.
		slot:ReleaseBlink();
	end	
end

-- Inven 에서 GHACHA_CUBE 관련 ITEM만 언락 시키기
function GHACHA_CUBE_ITEM_UNLOCK(slot)
	local item = GET_SLOT_ITEM(slot);
	if nil == item then
		return;
	end
	local obj = GetIES(item:GetObject());
	if TryGetProp(obj, "Script") == "SCR_FIRST_USE_GHACHA_CUBE" then	-- GHACHA_CUBE 관련 ITEM만
	end	
end

