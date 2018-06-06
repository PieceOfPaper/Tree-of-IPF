-- gacha_cube.lua --

function GACHA_CUBE_ON_INIT(addon, frame)

end

-- ť�� �̱� ��� ��� �κ�
function CANCEL_GACHA_CUBE()
	SET_MOUSE_FOLLOW_BALLOON(nil);
	ui.SetEscapeScp("");

	CancelGachaCube();												-- �̱� ��Ҹ� ������ �˸�.

	local gachaCubeFrame = ui.GetFrame("gacha_cube");	
	GHACHA_CUBE_UI_RESET(gachaCubeFrame);							-- UI ����		
end

-- ��ư Ŭ�� (2, 3��° �̱�)
function GACHA_CUBE_OK_BTN(frame, ctrl)
	item.DoPremiumItemGachaCube();	-- 1��°�� �ٸ��� ������ null�� ���� ����
end

-- �̱� ���� ��, ��� UIâ �����Ͽ� ���� 
function GACHA_CUBE_SUCEECD(invItemClsID, rewardItem, btnVisible)
	-- UIâ ���ͼ�	 �ʱ�ȭ
	local gachaCubeFrame = ui.GetFrame("gacha_cube");	
	GHACHA_CUBE_UI_RESET(gachaCubeFrame);	
	GACHA_CUBE_SUCEECD_UI(gachaCubeFrame, invItemClsID, rewardItem, btnVisible);
end


-- �̱� ���� ��, ��� UIâ ��� �ٲٱ�
function GACHA_CUBE_SUCEECD_EX(invItemClsID, rewardItem, btnVisible)	
	-- UIâ ���ͼ�	 
	local gachaCubeFrame = ui.GetFrame("gacha_cube");	
	GACHA_CUBE_SUCEECD_UI(gachaCubeFrame, invItemClsID, rewardItem, btnVisible);
end
	
--
function GACHA_CUBE_SUCEECD_UI(frame, invItemClsID, rewardItem, btnVisible)
	-- UIâ�� ȣ���� ť�� ���� ������
	local cubeItem = GetClassByType("Item", invItemClsID);

	-- UIâ�� ��ġ ����
	local invframe = ui.GetFrame("inventory");

	-- ��� UI â�� ���������� ������ �������� ��� �� ����.
	SET_SLOT_APPLY_FUNC(invframe, "GHACHA_CUBE_ITEM_LOCK", "Consume");
	
	-- UIâ�� ��� ����
	ui.SetEscapeScp("CANCEL_GACHA_CUBE()");
	
	-- �������� ȣ���� ������ �̸� �� ��ư�� ��� ����	
	local CubeNameFrame = frame:GetChild("richtext_1");	
	local sucName = string.format("{@st41b}%s", cubeItem.Name);	
	CubeNameFrame:SetTextByKey("value", sucName);
	local BtnFrame = frame:GetChild("button_1");	

	local price = TryGet(cubeItem, "NumberArg1");
	
	if IS_SEASON_SERVER(nil) == 'YES' then
	    price = math.floor(price/2)
	end
	
	if price ~= nil then
		price = GetCommaedText(price);
	end

	local sucValue = string.format("{@st41b}%s{nl}{img icon_item_silver 20 20 }%s", ScpArgMsg("ONE_MORE_TIME"), price);
	BtnFrame:SetTextByKey("value", sucValue);	
	BtnFrame:SetVisible(btnVisible);

	-- ��ȸ�� ��� ����������
	local EndFrame = frame:GetChild("richtext_4");
	if btnVisible == '0'  then
		EndFrame:SetVisible(1);
	else
		EndFrame:SetVisible(0);
	end

	-- ���� ��ǰ �̸����� ������Ʈ ���� ã��
	local reward = GetClass("Item", rewardItem);
		
	-- ���� ���� ���Կ� ����
	local slot  = frame:GetChild("slot");
	SET_SLOT_ITEM_OBJ(slot, reward);							-- ������ �̸����� ������ ����
	SET_ITEM_TOOLTIP_BY_TYPE(slot:GetIcon(), reward.ClassID);	-- ������ ���� Ÿ������ ����
	
	-- ���� �� �̸� ����
	local rewardNameFrame = frame:GetChild("itemName");
	rewardNameFrame:SetTextByKey("value", reward.Name);	
	
	if reward.ItemType ~= 'Equip' then
		imcSound.PlaySoundEvent('sys_cube_open_normal');
	else
		imcSound.PlaySoundEvent('sys_cube_open_jackpot');	
	end
	
	-- AnimPicture ����
	local startAnim = GET_CHILD(frame, 'animpic', 'ui::CAnimPicture');
	startAnim:PlayAnimation();	
	
	-- ������ ���� UIâ ���̱�
	frame:ShowWindow(1);
end

-- UI ����
function GHACHA_CUBE_UI_RESET(frame)	
	frame:SetUserValue("GACHA_CUBE", "None");		-- ȣ���� ������ ���� �ʱ�ȭ
	local itemName = frame:GetChild("itemName");	-- ����� �̸� ������ �޾ƿ���
	itemName:SetTextByKey("value", "");				-- �̸� �ʱ�ȭ
		
	local slot  = frame:GetChild("slot");			-- ����� ���� ������ �޾ƿ���
	slot  = tolua.cast(slot, 'ui::CSlot');			
	slot:ClearIcon();								-- �� �������� �ʱ�ȭ

	frame:ShowWindow(0);							-- ������ �����
	
	local invframe = ui.GetFrame("inventory");		-- �κ��丮 ������ �޾ƿ���
	SET_SLOT_APPLY_FUNC(invframe, "GHACHA_CUBE_ITEM_UNLOCK", "Consume");
	SET_SLOT_APPLY_FUNC(invframe, "None", "Consume");			-- �κ� ���� ���� ���� �ʱ�ȭ
end

-- Inven ���� GHACHA_CUBE ���� ITEM�� �� ��Ű�� 
function GHACHA_CUBE_ITEM_LOCK(slot)
	local item = GET_SLOT_ITEM(slot);
	if nil == item then
		return;
	end
	local obj = GetIES(item:GetObject());
	if TryGetProp(obj, "Script") == "SCR_FIRST_USE_GHACHA_CUBE" then	-- GHACHA_CUBE ���� ITEM��
		slot:GetIcon():SetGrayStyle(1);						-- �ش� ������ ���� �˰�.
		slot:ReleaseBlink();
	end	
end

-- Inven ���� GHACHA_CUBE ���� ITEM�� ��� ��Ű��
function GHACHA_CUBE_ITEM_UNLOCK(slot)
	local item = GET_SLOT_ITEM(slot);
	if nil == item then
		return;
	end
	local obj = GetIES(item:GetObject());
	if TryGetProp(obj, "Script") == "SCR_FIRST_USE_GHACHA_CUBE" then	-- GHACHA_CUBE ���� ITEM��
	end	
end

