-- equip_cardslot.lua --

function EQUIP_CARDSLOT_INFO_INIT(addon, frame)
	frame:SetUserValue("REMOVE_CARD_IESID", 0);
end

-- üũ�ڽ�ó�������ִٸ� �ݰ� �ݾ��ִٸ� ������. 
function CHECK_BTN_OPNE_CARDINVEN(ctrl)

	-- ��ư�� �ƴ� �ؽ�Ʈ�� �������� �������� ���� �������� �κ��� �������� ��.
	local frame	= ctrl:GetTopParentFrame();
	local isOpen = frame:GetUserIValue("MONCARDLIST_OPENED");	

	if isOpen == nil then
		return;
	end

	local arrowImgText = "";
	
	local moncardGbox = frame:GetChild('moncardGbox');
	local monCardBtn = frame:GetChild('moncard_btn');
	local monCardBtn_text = monCardBtn:GetChild('moncard_btn_text');
	
	local invGbox = frame:GetChild('inventoryGbox');
	local tree_box = GET_CHILD_RECURSIVELY(invGbox, 'treeGbox_Item');
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
	-- ī�彽���� �����ִٸ� ������ �Ѵ�. �κ� �׷� �ڽ��� �Ʒ��� ������ �۰�.
		invGbox:Resize(invGboxOriX, invGboxOriY + offsetY, invGboxW, invGboxH - offsetY);
		tree_box_E:Resize(tree_boxW_E, tree_boxH_E - offsetY);
		tree_box_E:SetScrollBar(tree_boxH_E - offsetY);
		tree_box:Resize(tree_boxW, tree_boxH - offsetY);
		tree_box:SetScrollBar(tree_boxH - offsetY);
		monCardBtn:SetOffset(monCardBtn:GetOriginalX(), monCardBtn:GetOriginalY() + offsetY);
		searchGbox:Invalidate();
		invGbox:Invalidate();
		-- ī�彽���� ������ ���� ����� �ش�.
		CARD_SLOT_CREATE(moncardGbox); 

		isOpen = 1;
		moncardGbox:ShowWindow(isOpen);
		arrowImgText = "moncard_inven_down";
	else								
	-- ī�彽���� �����ִٸ� ������ �Ѵ�. �κ� �׷� �ڽ��� ���� ũ��� �ǵ�����.
		invGbox:Resize(invGboxOriX, invGboxOriY, invGboxW, invGboxH + offsetY);
		tree_box_E:Resize(tree_boxW_E, tree_boxH_E + offsetY);
		tree_box_E:SetScrollBar(tree_boxH_E + offsetY);
		tree_box:Resize(tree_boxW, tree_boxH + offsetY);
		tree_box:SetScrollBar(tree_boxH + offsetY);
		monCardBtn:SetOffset(monCardBtn:GetOriginalX(), monCardBtn:GetOriginalY());
		searchGbox:Invalidate();
		invGbox:Invalidate();
		
		isOpen = 0;
		moncardGbox:ShowWindow(isOpen);
		arrowImgText = "moncard_inven_up";
	end;
	
	frame:SetUserValue("MONCARDLIST_OPENED", isOpen);
	monCardBtn_text:SetTextByKey("arrow", arrowImgText); 

end;

-- �κ��丮�� ī�� ���� ���� �κ�
function CARD_SLOT_CREATE(frame)
	local card_slotset = GET_CHILD(frame, "card_slotset");
	if card_slotset ~= nil then
		local gradeRank = session.GetPcTotalJobGrade();
		-- ī�� ���� ���� 7��ũ�� ��. Ȯ��� �̸� �ٲ��ָ� ��.
		if gradeRank >= JOB_CHANGE_MAX_RANK then
			gradeRank = JOB_CHANGE_MAX_RANK;
		end
		card_slotset:RemoveAllChild();			-- ����� ���� ���� �ִ��Ŵ� ����.
		card_slotset:SetColRow(gradeRank, 1);	-- ���� ��ũ �տ� ���� ī�� ���� �� ����
		card_slotset:CreateSlots();

		for i = 0, gradeRank - 1 do				-- ������ ���ʺ��� ������� ����		
			local cardID, cardLv, cardExp = GETMYCARD_INFO(i);			
			CARD_SLOT_SET(card_slotset, i, cardID, cardLv, cardExp);
		end;
	end;
end;

-- ī�带 ī�� ���Կ� ������Ű�� �Լ�
function CARD_SLOT_SET(ctrlSet, slotIndex, itemClsId, itemLv, itemExp)
	local cls = nil ;
	local cardID = tonumber(itemClsId);
	local cardLv = tonumber(itemLv);
	local cardExp = tonumber(itemExp);
	
	local slot = ctrlSet:GetSlotByIndex(slotIndex);
	if slot == nil then
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
	if icon == nil then		
		-- icon�� ���ٴ� �� ���� �������� �ʾҴٴ� ��.
		icon = CreateIcon(slot);
	end;	
	if cls ~= nil then		
		local imageName = cls.TooltipImage;
		if imageName ~= nil then
			icon:SetImage(cls.TooltipImage);
			icon:Invalidate();
		end;
	end;
	
	-- ���� ���� (ī�� �������� IES�� ������� ������ �Ȱ��� ���� ������ ���� ���� ����)
	slot:SetEventScript(ui.MOUSEMOVE, "EQUIP_CARDSLOT_INFO_TOOLTIP_OPEN");
	slot:SetEventScriptArgNumber(ui.MOUSEMOVE, slotIndex);		
	slot:SetEventScript(ui.LOST_FOCUS, "EQUIP_CARDSLOT_INFO_TOOLTIP_CLOSE");
end;

-- �κ��丮�� ī�� ���� ������ Ŭ���� ����â���� �������� ��ũ��Ʈ
function CARD_SLOT_RBTNUP_ITEM_INFO(frame, slot, argStr, argNum)
	local icon = slot:GetIcon();		
	if icon == nil then		
		return;		
	end;

	EQUIP_CARDSLOT_INFO_OPEN(slot:GetSlotIndex());
end

-- ī�� ���� ����â ����
function EQUIP_CARDSLOT_INFO_OPEN(slotIndex)
	local frame = ui.GetFrame('equip_cardslot_info');
	
	if frame:IsVisible() == 1 then
		frame:ShowWindow(0);	
	end
	
	local cardID, cardLv, cardExp = GETMYCARD_INFO(slotIndex);
	
	if cardID == 0 then
		return;
	end
	
	-- ī�� ���� �����ϱ� ����
	frame:SetUserValue("REMOVE_CARD_SLOTINDEX", slotIndex);

	local inven = ui.GetFrame("inventory");
	local cls = GetClassByType("Item", cardID);

	-- �ȳ��޼����� �̸� ����
	local infoMsg = GET_CHILD(frame, "infoMsg");
	infoMsg:SetTextByKey("Name", cls.Name);

	-- ī�� �̹��� ����
	local card_img = GET_CHILD(frame, "card_img");
	card_img:SetImage(cls.TooltipImage);	
		
	local multiValue = 64;	-- �� �� ī�� �̹����� �ϰ� �ʹٸ� 90 ����. (��, ī�巹�� �϶� ������ �� �Ⱥ��� �� ����.)
	local star_bg = GET_CHILD(frame, "star_bg");
	local cardStar_Before = GET_CHILD(star_bg, "cardStar_Before");
	local cardStar_After = GET_CHILD(star_bg, "cardStar_After");
	local downArrow = GET_CHILD(star_bg, "downArrow");
	local imgSize = 35;
	if cardLv <= 1 then	
		multiValue = 90;
		cardStar_After:SetTextByKey("value", GET_STAR_TXT(imgSize, cardLv, obj));
		cardStar_Before:SetVisible(0);
		downArrow:SetVisible(0);
	else
		cardStar_Before:SetTextByKey("value", GET_STAR_TXT(imgSize, cardLv, obj));
		cardStar_After:SetTextByKey("value", GET_STAR_TXT(imgSize, cardLv - 1, obj));	-- ī�� ���Ž� �� �ϳ� �پ��� ����.
		cardStar_Before:SetVisible(1);
		downArrow:SetVisible(1);
	end;

	-- ī�� ũ�� ��ȯ. 
	card_img:Resize(3 * multiValue, 4 * multiValue);

	-- ���ŵǴ� ȿ�� ǥ���ϴ� ��. 
	local removedEffect =  string.format("%s{/}", cls.Desc);	
	if cls.Desc == "None" then
		removedEffect = "{/}";
	end
	local bg = GET_CHILD(frame, "bg");
	local effect_info = GET_CHILD(bg, "effect_info");
	effect_info:SetTextByKey("RemovedEffect", removedEffect);
	
	-- ����â ��ġ�� �κ� ������ ����.
	frame:SetOffset(inven:GetX() - frame:GetWidth(), frame:GetY());

	frame:ShowWindow(1);	
end

-- ī�� ���� ����â �ݱ�
function EQUIP_CARDSLOT_BTN_CANCLE()
	local frame = ui.GetFrame('equip_cardslot_info');	
	frame:ShowWindow(0);
end

-- ���� ī�带 �κ��丮�� ī�� ���Կ� �巹�׵������ �����Ϸ� �� ���.
function CARD_SLOT_DROP(frame, slot, argStr, argNum)
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();
	if toFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		local item = session.GetInvItem(iconInfo.ext);		
		if nil == item then
			return;
		end
		CARD_SLOT_EQUIP(slot, item);
	end
end;

-- ���� ī�带 �κ��丮�� ī�� ���Կ� ���� ��û�ϱ� ���� �޼��� �ڽ��� �ѹ� �� Ȯ��
function CARD_SLOT_EQUIP(slot, item)
	local obj = GetIES(item:GetObject());
	if obj.GroupName == "Card" then			
		local slotIndex = slot:GetSlotIndex();
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

-- ���� ī�� ���� ��û
function REQUEST_EQUIP_CARD_TX()
	local invFrame = ui.GetFrame("inventory");	
	local itemGuid = invFrame:GetUserValue("EQUIP_CARD_GUID");
	local slotIndex = invFrame:GetUserIValue("EQUIP_CARD_SLOTINDEX");
	local argStr = string.format("%d#%s", slotIndex, itemGuid);
	pc.ReqExecuteTx("SCR_TX_EQUIP_CARD_SLOT", argStr);
	invFrame:SetUserValue("EQUIP_CARD_GUID", "");
	invFrame:SetUserValue("EQUIP_CARD_SLOTINDEX", "");	
end

-- ���� ī�� ���� ��û �������
function REQUEST_EQUIP_CARD_CANCLE()
	local invFrame = ui.GetFrame("inventory");	
	invFrame:SetUserValue("EQUIP_CARD_GUID", "");
	invFrame:SetUserValue("EQUIP_CARD_SLOTINDEX", "");	
end

-- ���� ī�带 �κ��丮�� ī�� ���Կ� ���� ����
function _CARD_SLOT_EQUIP(slotIndex, itemClsId, itemLv, itemExp)
	local invFrame    = ui.GetFrame("inventory");	
	local moncardGbox = invFrame:GetChild('moncardGbox');
	if moncardGbox:IsVisible() == 0 then
		return;
	end;
	local card_slotset = GET_CHILD(moncardGbox, "card_slotset");
	if card_slotset ~= nil then
		CARD_SLOT_SET(card_slotset, slotIndex -1, itemClsId, itemLv, itemExp);
	end;
	invFrame:SetUserValue("EQUIP_CARD_GUID", "");
	invFrame:SetUserValue("EQUIP_CARD_SLOTINDEX", "");	
end;

-- ī�� ������ ī�� ���� ��û
function EQUIP_CARDSLOT_BTN_REMOVE(frame, ctrl)
	local inven = ui.GetFrame("inventory");
	local argStr = string.format("%d", frame:GetUserIValue("REMOVE_CARD_SLOTINDEX"));

	argStr = argStr .. " 0" -- 0: ī�� ���� �������鼭 ����
	pc.ReqExecuteTx_NumArgs("SCR_TX_UNEQUIP_CARD_SLOT", argStr);
end;

-- �κ��丮�� ī�� ���� ���� ����
function _CARD_SLOT_REMOVE(slotIndex)
	local frame = ui.GetFrame('inventory');
	local gBox = GET_CHILD(frame, "moncardGbox");	
	local card_slotset = GET_CHILD(gBox, "card_slotset");
	if card_slotset ~= nil then
		local slot = card_slotset:GetSlotByIndex(slotIndex - 1);
		if slot ~= nil then
			slot:ClearIcon();
		end;
	end;
	
	local cardFrame = ui.GetFrame('equip_cardslot_info');
	cardFrame:ShowWindow(0);
end;

-- ī�� ���� ��� �Լ�
function GETMYCARD_INFO(slotIndex)	
	local myPCetc = GetMyEtcObject();
	local cardID = myPCetc[string.format("EquipCardID_Slot%d", slotIndex + 1)];
	local cardLv = myPCetc[string.format("EquipCardLv_Slot%d", slotIndex + 1)];
	local cardExp = myPCetc[string.format("EquipCardExp_Slot%d", slotIndex + 1)];
	return cardID, cardLv, cardExp;
end

-- �ܰ� ��ȣ�ϰ�, ī�� ������ ī�� ����
function EQUIP_CARDSLOT_BTN_REMOVE_WITHOUT_EFFECT(frame, ctrl)
	local inven = ui.GetFrame("inventory");
	local argStr = string.format("%d", frame:GetUserIValue("REMOVE_CARD_SLOTINDEX"));

	argStr = argStr .. " 1" -- 1�� arg list�� �ѱ�� 5tp �Ҹ��� ī�� ���� �϶� ����
	pc.ReqExecuteTx_NumArgs("SCR_TX_UNEQUIP_CARD_SLOT", argStr);
end;