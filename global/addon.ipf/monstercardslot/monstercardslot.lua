-- monstercardslot.lua


function MONSTERCARDSLOT_ON_INIT(addon, frame)
--	addon:RegisterMsg("MSG_UPDATE_MONSTERCARDSLOT_UI", "MONSTERCARDSLOT_FRAME_OPEN");
	addon:RegisterMsg("DO_OPEN_MONSTERCARDSLOT_UI", "MONSTERCARDSLOT_FRAME_OPEN");
end

function MONSTERCARDSLOT_FRAME_OPEN(frame)
	
	ui.OpenFrame("monstercardslot")
	CARD_SLOTS_CREATE(frame)
--	CHECK_BTN_OPNE_CARDINVEN(frame)
end

function MONSTERCARDSLOT_FRAME_CLOSE(frame)
	
end

-- equip_cardslot.lua --

function EQUIP_CARDSLOT_INFO_INIT(addon, frame)
	frame:SetUserValue("REMOVE_CARD_IESID", 0);
end

-- 체크박스처럼열려있다면 닫고 닫아있다면 열리게. 
function CHECK_BTN_OPNE_CARDINVEN(ctrl)

	-- 버튼이 아닌 텍스트를 누를때가 있음으로 상위 프레임인 인벤을 기준으로 함.
	local frame	= ctrl:GetTopParentFrame();
	local isOpen = frame:GetUserIValue("MONCARDLIST_OPENED");	

	if isOpen == nil then
		return;
	end

	local arrowImgText = "";
	
	local moncardGbox = frame:GetChild('moncardGbox');
	local monCardBtn = frame:GetChild('moncard_btn');
--	local monCardBtn_text = monCardBtn:GetChild('moncard_btn_text');
	
	local invGbox = frame:GetChild('inventoryGBox');
	local tree_box = GET_CHILD_RECURSIVELY(invGbox, 'treeGbox_ITEM');
	local tree_box_E = GET_CHILD_RECURSIVELY(invGbox, 'treeGbox_Equip');

	local offsetY = moncardGbox:GetHeight();
	local invGboxOriX = invGbox:GetOriginalX();
	local invGboxOriY = invGbox:GetOriginalY();
	local invGboxW = invGbox:GetWidth();
	local invGboxH = invGbox:GetHeight();
	local tree_boxW = tree_box:GetWidth();
	local tree_boxH = tree_box:GetHeight();
	local tree_boxW_E = tree_box_E:GetWidth();
	local tree_boxH_E = tree_box_E:GetHeight();
	
	local searchGbox = invGbox:GetChild('searchGbox');	

	if isOpen == 0 then					
	-- 카드슬롯이 닫혀있다면 열리게 한다. 인벤 그룹 박스는 아래로 내리고 작게.
		invGbox:Resize(invGboxOriX, invGboxOriY + offsetY, invGboxW, invGboxH - offsetY);
		tree_box_E:Resize(tree_boxW_E, tree_boxH_E - offsetY);
		tree_box_E:SetScrollBar(tree_boxH_E - offsetY);
		tree_box:Resize(tree_boxW, tree_boxH - offsetY);
		tree_box:SetScrollBar(tree_boxH - offsetY);
	--	monCardBtn:SetOffset(monCardBtn:GetOriginalX(), monCardBtn:GetOriginalY() + offsetY);
		searchGbox:Invalidate();
		invGbox:Invalidate();
		-- 카드슬롯을 갯수에 맞춰 만들어 준다.
	--	CARD_SLOT_CREATE(moncardGbox); 

		isOpen = 1;
		moncardGbox:ShowWindow(isOpen);
	--	arrowImgText = "moncard_inven_down";
	else								
	-- 카드슬롯이 열려있다면 닫히게 한다. 인벤 그룹 박스는 원래 크기로 되돌리기.
		invGbox:Resize(invGboxOriX, invGboxOriY, invGboxW, invGboxH + offsetY);
		tree_box_E:Resize(tree_boxW_E, tree_boxH_E + offsetY);
		tree_box_E:SetScrollBar(tree_boxH_E + offsetY);
		tree_box:Resize(tree_boxW, tree_boxH + offsetY);
		tree_box:SetScrollBar(tree_boxH + offsetY);
	--	monCardBtn:SetOffset(monCardBtn:GetOriginalX(), monCardBtn:GetOriginalY());
		searchGbox:Invalidate();
		invGbox:Invalidate();
		
		isOpen = 0;
		moncardGbox:ShowWindow(isOpen);
		arrowImgText = "moncard_inven_up";
	end;
	
	frame:SetUserValue("MONCARDLIST_OPENED", isOpen);
--	monCardBtn_text:SetTextByKey("arrow", arrowImgText); 

end;

-- 인벤토리의 카드 슬롯 생성 부분
function CARD_SLOTS_CREATE(frame)
	local monsterCardSlotFrame = frame;
	if monsterCardSlotFrame == nil then
		monsterCardSlotFrame = ui.GetFrame('monstercardslot')
	end

	CARD_SLOT_CREATE(monsterCardSlotFrame, 'ATK', 0)
	CARD_SLOT_CREATE(monsterCardSlotFrame, 'DEF', 3)
	CARD_SLOT_CREATE(monsterCardSlotFrame, 'UTIL', 6)
	CARD_SLOT_CREATE(monsterCardSlotFrame, 'STAT', 9)

end;

function CARD_SLOT_CREATE(monsterCardSlotFrame, cardGroupName, slotIndex)
	local frame = monsterCardSlotFrame;
	if frame == nil then
		frame = ui.GetFrame('monstercardslot')
	end

	if cardGroupName == nil then
		return
	end

	local card_slotset = GET_CHILD_RECURSIVELY(frame, cardGroupName .. "card_slotset");
	local card_labelset = GET_CHILD_RECURSIVELY(frame, cardGroupName .. "card_labelset");

	if card_slotset ~= nil and card_labelset ~= nil then
		for i = 0, 2 do				-- 슬롯은 왼쪽부터 순서대로 결정		
			local slot_label = card_labelset:GetSlotByIndex(i);
			if slot_label == nil then
				return;
			end
			local icon_label = CreateIcon(slot_label)
			if cardGroupName == 'ATK' then
				icon_label : SetImage('red_cardslot1')
			elseif cardGroupName == 'DEF' then
				icon_label : SetImage('blue_cardslot1')
			elseif cardGroupName == 'UTIL' then
				icon_label : SetImage('purple_cardslot1')
			elseif cardGroupName == 'STAT' then
				icon_label : SetImage('green_cardslot1')
			end
			local cardID, cardLv, cardExp = GETMYCARD_INFO(slotIndex + i);			
			CARD_SLOT_SET(card_slotset, card_labelset, i, cardID, cardLv, cardExp);
		end;
	end;
end

-- 카드를 카드 슬롯에 설정시키는 함수
function CARD_SLOT_SET(ctrlSet, slot_label_set, slotIndex, itemClsId, itemLv, itemExp)
	local cls = nil ;
	local cardID = tonumber(itemClsId);
	local cardLv = tonumber(itemLv);
	local cardExp = tonumber(itemExp);

	local cardCls = GetClassByType("Item", itemClsId)
	local cardGroupName = 'None';
	if cardCls == nil then
		return;
	end
	if cardCls.CardGroupName == nil or cardCls.CardGroupName == 'None' then
		--cardGroupName = 'None';
		return
	end
	cardGroupName = cardCls.CardGroupName

	local slot = ctrlSet:GetSlotByIndex(slotIndex);
	if slot == nil then
		return;
	end
			
	local slot_label = slot_label_set:GetSlotByIndex(slotIndex);
	if slot_label == nil then
		return;
	end

	if cardID > 0 then
		cls = GetClassByType("Item", cardID);
		if cls.GroupName ~= "Card" then		
			return;
		end;		
	else
		slot:ClearIcon();
		return;
	end;
	
	local icon = slot:GetIcon();	
	local icon_label = slot_label:GetIcon();
	if icon == nil or icon_label == nil then		
		-- icon이 없다는 건 아직 장착되지 않았다는 말.
		icon = CreateIcon(slot);
		icon_label = CreateIcon(slot_label)
	end;	
	if cls ~= nil then		
		local imageName = cls.TooltipImage;
		if imageName ~= nil then			
			icon:SetImage(cls.TooltipImage);
			local icon_label = CreateIcon(slot_label)
			if cardGroupName == 'ATK' then
				icon_label : SetImage('red_cardslot')
			elseif cardGroupName == 'DEF' then
				icon_label : SetImage('blue_cardslot')
			elseif cardGroupName == 'UTIL' then
				icon_label : SetImage('purple_cardslot')
			elseif cardGroupName == 'STAT' then
				icon_label : SetImage('green_cardslot')
			end
			icon:Invalidate();
			icon_label:Invalidate();
		end;
	end;
	
	-- 툴팁 생성 (카드 아이템은 IES가 사라지기 때문에 똑같이 생긴 툴팁을 따로 만들어서 적용)

	slot:SetEventScript(ui.MOUSEMOVE, "EQUIP_CARDSLOT_INFO_TOOLTIP_OPEN");
	slot:SetEventScriptArgNumber(ui.MOUSEMOVE, slotIndex);
slot:SetEventScript(ui.LOST_FOCUS, "EQUIP_CARDSLOT_INFO_TOOLTIP_CLOSE");
end;

-- 인벤토리의 카드 슬롯 오른쪽 클릭시 정보창오픈 과정시작 스크립트
function CARD_SLOT_RBTNUP_ITEM_INFO(frame, slot, argStr, argNum)
	local icon = slot:GetIcon();		
	if icon == nil then		
		return;		
	end;

	local parentSlotSet = slot:GetParent()
	if parentSlotSet == nil then
		return
	end

	local slotIndex = slot:GetSlotIndex()

	if parentSlotSet:GetName() == 'ATKcard_slotset' then
		slotIndex = slotIndex + 0
	elseif parentSlotSet : GetName() == 'DEFcard_slotset' then
		slotIndex = slotIndex + 3
	elseif parentSlotSet : GetName() == 'UTILcard_slotset' then
		slotIndex = slotIndex + 6
	elseif parentSlotSet : GetName() == 'STATcard_slotset' then
		slotIndex = slotIndex + 9
	end
		
	EQUIP_CARDSLOT_INFO_OPEN(slotIndex);
end

-- 카드 슬롯 정보창 열기
function EQUIP_CARDSLOT_INFO_OPEN(slotIndex)
	local frame = ui.GetFrame('equip_cardslot_info');
	
	if frame:IsVisible() == 1 then
		frame:ShowWindow(0);	
	end
	
	local cardID, cardLv, cardExp = GETMYCARD_INFO(slotIndex);
	
	if cardID == 0 then
		return;
	end
	
	-- 카드 슬롯 제거하기 위함
	frame:SetUserValue("REMOVE_CARD_SLOTINDEX", slotIndex);

	local inven = ui.GetFrame("inventory");
	local cls = GetClassByType("Item", cardID);

	-- 안내메세지에 이름 적용
	local infoMsg = GET_CHILD(frame, "infoMsg");
	infoMsg:SetTextByKey("Name", cls.Name);

	-- 카드 이미지 적용
	local card_img = GET_CHILD(frame, "card_img");
	card_img:SetImage(cls.TooltipImage);	
		
	local multiValue = 64;	-- 꽉 찬 카드 이미지를 하고 싶다면 90 으로. (단, 카드레벨 하락 정보가 잘 안보일 수 있음.)
	local star_bg = GET_CHILD(frame, "star_bg");
	local cardStar_Before = GET_CHILD(star_bg, "cardStar_Before");
	local cardStar_After = GET_CHILD(star_bg, "cardStar_After");
	local downArrow = GET_CHILD(star_bg, "downArrow");
	local imgSize = frame:GetUserConfig('starSize');
	if cardLv <= 1 then	
		multiValue = 90;
		cardStar_After:SetTextByKey("value", GET_STAR_TXT(imgSize, cardLv, obj));
		cardStar_Before:SetVisible(0);
		downArrow:SetVisible(0);
	else
		cardStar_Before:SetTextByKey("value", GET_STAR_TXT(imgSize, cardLv, obj));
		cardStar_After:SetTextByKey("value", GET_STAR_TXT(imgSize, cardLv - 1, obj));	-- 카드 제거시 별 하나 줄어들게 설정.
		cardStar_Before:SetVisible(1);
		downArrow:SetVisible(1);
	end;

	-- 카드 크기 변환. 
--	card_img:Resize(3 * multiValue, 4 * multiValue);

	-- 제거되는 효과 표시하는 곳. 
	local removedEffect =  string.format("%s{/}", cls.Desc);	
	if cls.Desc == "None" then
		removedEffect = "{/}";
	end
	local bg = GET_CHILD(frame, "bg");
	local effect_info = GET_CHILD(bg, "effect_info");
	effect_info:SetTextByKey("RemovedEffect", removedEffect);
	
	-- 정보창 위치를 인벤 옆으로 붙힘.
	frame:SetOffset(inven:GetX() - frame:GetWidth(), frame:GetY());

	frame:ShowWindow(1);	
end

-- 카드 슬롯 정보창 닫기
function EQUIP_CARDSLOT_BTN_CANCLE()
	local frame = ui.GetFrame('equip_cardslot_info');
	frame:ShowWindow(0);
end

-- 몬스터 카드를 인벤토리의 카드 슬롯에 드레그드롭으로 장착하려 할 경우.
function CARD_SLOT_DROP(frame, slot, argStr, argNum)
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();
	
	if toFrame:GetName() == 'monstercardslot' then
		local iconInfo = liftIcon:GetInfo();

		if iconInfo == nil then
			return
		end

		local item = session.GetInvItem(iconInfo.ext);		
		if nil == item then
			return;
		end
		local cardObj = GetClassByType("Item", item.type)

		local parentSlotSet = slot:GetParent()
		if parentSlotSet == nil then
			return
		end
		

		local cardGroupName_slotset = cardObj.CardGroupName .. 'card_slotset'
		if parentSlotSet:GetName() ~= cardGroupName_slotset then
			--같은 card group 에 착용해야합니다 메세지 띄워줘야해
			ui.SysMsg(ClMsg("ToEquipSameCardGroup"));
			return
		end

		CARD_SLOT_EQUIP(slot, item, cardObj.CardGroupName);
	end
end;

-- 몬스터 카드를 인벤토리의 카드 슬롯에 장착 요청하기 전에 메세지 박스로 한번 더 확인
function CARD_SLOT_EQUIP(slot, item, groupNameStr)
	local obj = GetIES(item:GetObject());
	if obj.GroupName == "Card" then			
		local slotIndex = slot:GetSlotIndex();
		if groupNameStr == 'ATK' then
			slotIndex = slotIndex + 0
		elseif groupNameStr == 'DEF' then
			slotIndex = slotIndex + 3
		elseif groupNameStr == 'UTIL' then
			slotIndex = slotIndex + 6
		elseif groupNameStr == 'STAT' then
			slotIndex = slotIndex + 9
		end

		local pcEtc = GetMyEtcObject()
		if pcEtc["EquipCardID_Slot"..slotIndex + 1] ~= 0 then
			ui.SysMsg(ClMsg("AlreadyEquippedThatCardSlot"));
			return;
		end

		local itemGuid = item:GetIESID();
		local invFrame    = ui.GetFrame("inventory");	
		invFrame:SetUserValue("EQUIP_CARD_GUID", itemGuid);
		invFrame:SetUserValue("EQUIP_CARD_SLOTINDEX", slotIndex);	
		local textmsg = string.format("[ %s ]{nl}%s", obj.Name, ScpArgMsg("AreYouSureEquipCard"));	
		ui.MsgBox_NonNested(textmsg, invFrame:GetName(), "REQUEST_EQUIP_CARD_TX", "REQUEST_EQUIP_CARD_CANCLE");		
		return 1;
	end;
	return 0;
end

-- 몬스터 카드 장착 요청
function REQUEST_EQUIP_CARD_TX()
	local invFrame = ui.GetFrame("inventory");	
	local itemGuid = invFrame:GetUserValue("EQUIP_CARD_GUID");
	local slotIndex = invFrame:GetUserIValue("EQUIP_CARD_SLOTINDEX");
	local argStr = string.format("%d#%s", slotIndex, itemGuid);
	pc.ReqExecuteTx("SCR_TX_EQUIP_CARD_SLOT", argStr);
	invFrame:SetUserValue("EQUIP_CARD_GUID", "");
	invFrame:SetUserValue("EQUIP_CARD_SLOTINDEX", "");	
end

-- 몬스터 카드 장착 요청 사전취소
function REQUEST_EQUIP_CARD_CANCLE()
	local invFrame = ui.GetFrame("inventory");	
	invFrame:SetUserValue("EQUIP_CARD_GUID", "");
	invFrame:SetUserValue("EQUIP_CARD_SLOTINDEX", "");	
end

-- 몬스터 카드를 인벤토리의 카드 슬롯에 장착 동작
function _CARD_SLOT_EQUIP(slotIndex, itemClsId, itemLv, itemExp)
	local moncardFrame = ui.GetFrame("monstercardslot");
	local invFrame    = ui.GetFrame("inventory");	
	
	if moncardFrame:IsVisible() == 0 then
		return;
	end;

	if invFrame:IsVisible() == 0 then
		return;
	end;

	local cardObj = GetClassByType("Item", itemClsId);
	if cardObj == nil then
		return;
	end

	local groupNameStr = cardObj.CardGroupName
	local groupSlotIndex = slotIndex
	if groupNameStr == 'ATK' then
		groupSlotIndex = groupSlotIndex - 0
	elseif groupNameStr == 'DEF' then
		groupSlotIndex = groupSlotIndex - 3
	elseif groupNameStr == 'UTIL' then
		groupSlotIndex = groupSlotIndex - 6
	elseif groupNameStr == 'STAT' then
		groupSlotIndex = groupSlotIndex - 9
	end

	local moncardGbox = GET_CHILD_RECURSIVELY(moncardFrame, groupNameStr .. 'cardGbox');
	local card_slotset = GET_CHILD(moncardGbox, groupNameStr .. "card_slotset");

	local card_labelset = GET_CHILD(moncardGbox, groupNameStr .. "card_labelset");
	if card_slotset ~= nil and card_labelset then
		CARD_SLOT_SET(card_slotset, card_labelset, groupSlotIndex -1, itemClsId, itemLv, itemExp);
	end;
	invFrame:SetUserValue("EQUIP_CARD_GUID", "");
	invFrame:SetUserValue("EQUIP_CARD_SLOTINDEX", "");	
end;

-- 카드 슬롯의 카드 제거 요청
function EQUIP_CARDSLOT_BTN_REMOVE(frame, ctrl)
	local inven = ui.GetFrame("monstercardslot");
	local argStr = string.format("%d", frame:GetUserIValue("REMOVE_CARD_SLOTINDEX"));

	argStr = argStr .. " 0" -- 0: 카드 레벨 떨어지면서 제거
	pc.ReqExecuteTx_NumArgs("SCR_TX_UNEQUIP_CARD_SLOT", argStr);
end;

-- 인벤토리의 카드 슬롯 제거 동작
function _CARD_SLOT_REMOVE(slotIndex, cardGroupName)
	local frame = ui.GetFrame('monstercardslot');

	local groupNameStr = cardGroupName
	
	local groupSlotIndex = slotIndex
	if cardGroupName == 'ATK' then
		groupSlotIndex = slotIndex - 0
	elseif cardGroupName == 'DEF' then
		groupSlotIndex = slotIndex - 3
	elseif cardGroupName == 'UTIL' then
		groupSlotIndex = slotIndex - 6
	elseif cardGroupName == 'STAT' then
		groupSlotIndex = slotIndex - 9
	end

	local gBox = GET_CHILD_RECURSIVELY(frame, groupNameStr .. 'cardGbox');
	local card_slotset = GET_CHILD(gBox, groupNameStr .. "card_slotset");
	local card_labelset = GET_CHILD(gBox, groupNameStr .. "card_labelset");
	if card_slotset ~= nil and card_labelset ~= nil then
--	if card_slotset ~= nil then
		local slot = card_slotset:GetSlotByIndex(groupSlotIndex - 1);
		if slot ~= nil then
			slot:ClearIcon();
		end;

		local slot_label = card_labelset:GetSlotByIndex(groupSlotIndex - 1);
		if slot_label ~= nil then
			local icon_label = CreateIcon(slot_label)
			if cardGroupName == 'ATK' then
				icon_label : SetImage('red_cardslot1')
			elseif cardGroupName == 'DEF' then
				icon_label : SetImage('blue_cardslot1')
			elseif cardGroupName == 'UTIL' then
				icon_label : SetImage('purple_cardslot1')
			elseif cardGroupName == 'STAT' then
				icon_label : SetImage('green_cardslot1')
			end
		--	slot_label : ClearIcon();
		end;
	end;
	
	local cardFrame = ui.GetFrame('equip_cardslot_info');
	cardFrame:ShowWindow(0);
end;

-- 카드 정보 얻는 함수
function GETMYCARD_INFO(slotIndex)	
	local myPCetc = GetMyEtcObject();
	local cardID = myPCetc[string.format("EquipCardID_Slot%d", slotIndex + 1)];
	local cardLv = myPCetc[string.format("EquipCardLv_Slot%d", slotIndex + 1)];
	local cardExp = myPCetc[string.format("EquipCardExp_Slot%d", slotIndex + 1)];
	return cardID, cardLv, cardExp;
end

-- 단계 보호하고, 카드 슬롯의 카드 제거
function EQUIP_CARDSLOT_BTN_REMOVE_WITHOUT_EFFECT(frame, ctrl)
	local inven = ui.GetFrame("monstercardslot");
	local argStr = string.format("%d", frame:GetUserIValue("REMOVE_CARD_SLOTINDEX"));

	argStr = argStr .. " 1" -- 1을 arg list로 넘기면 5tp 소모후 카드 레벨 하락 안함
	pc.ReqExecuteTx_NumArgs("SCR_TX_UNEQUIP_CARD_SLOT", argStr);
end;