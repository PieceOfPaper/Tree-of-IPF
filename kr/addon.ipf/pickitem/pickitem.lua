function PICKITEM_ON_INIT(addon, frame)
	PickCount = 0;
end

function END_PICKITEM(frame, msg, argStr, argNum)

	local frame = ui.GetFrame("sysmenu");
	local btn = frame:GetChild("inven");
	if IMCRandom(1, 3) == 1 then
		btn:PlayEvent("BIG_ITEM_GET");
	else
		btn:PlayEvent("ITEM_GET");
	end

	imcSound.PlaySoundEvent('item_insert');
end

function PICKITEM_DO_SHOW_UI()

	local frame = ui.GetFrame("pickitem");
	frame:ShowWindow(1);
	frame:SetDuration(2);
	frame:Invalidate();

end

function PICKITEM_IN(frame, msg, itemGuid, itemCount, class)
	if class.ItemType == "Unused" then
        frame:ShowWindow(0);
		return;
	end

	--frame:ShowWindow(1);
	PickCount = PickCount + 1;

	-- Pcik �����۽� ȭ�� �߾ӿ� ǥ���� ControlSet ����
	local PickItem 			= frame:GetChild('pickitem');
	local PickItemGropBox	= tolua.cast(PickItem, "ui::CGroupBox");
	PickItemGropBox:RemoveAllChild();

	-- ControlSet �̸� ����
	local img = GET_ITEM_ICON_IMAGE(class);
	
	local controlSetName = "icon_"..tostring(PickCount);

	local PickItemCountObj		= PickItemGropBox:CreateControlSet('pickitemset_Type', controlSetName, 8, 8);
	local PickItemCountCtrl		= tolua.cast(PickItemCountObj, "ui::CControlSet");
	PickItemCountCtrl:SetGravity(ui.LEFT, ui.TOP);

	local ConSetBySlot 	= PickItemCountCtrl:GetChild('slot');
	local slot			= tolua.cast(ConSetBySlot, "ui::CSlot");
	local icon = CreateIcon(slot);
	local iconName = img;

	icon:Set(iconName, 'PICKITEM', itemCount, 0);

	-- ������ �̸��� ȹ�淮 ���
	local printName	 = '{@st43}' ..GET_FULL_NAME(class);
	local printCount = '{@st41b}'..ScpArgMsg("GetByCount{Count}", "Count", itemCount);

	PickItemCountCtrl:SetTextByKey('ItemName', printName);
	PickItemCountCtrl:SetTextByKey('ItemCount', printCount);


	-- �������̸� �ʹ��涧 ©���� resize �ϴ� ����.
	PickItemGropBox:Resize(300, 120);
	frame:Resize(300, 120);
	local textLen = string.len(printName);
	local rate = 6;
	if textLen < 20 then
		rate = 2;
	end
	PickItemGropBox:Resize(PickItemGropBox:GetWidth() + (textLen*rate), PickItemGropBox:GetHeight());
	frame:Resize(PickItemGropBox:GetWidth() + (textLen*rate), PickItemGropBox:GetHeight());


	PickItemGropBox:UpdateData();
	PickItemGropBox:Invalidate();
	

	ReserveScript("PICKITEM_DO_SHOW_UI()", 1);
end

function PICKITEM_ON_MSG(frame, msg, argStr, argNum)
	if  msg ==  'INV_ITEM_ADD' or msg == 'INV_ITEM_CHANGE_COUNT' then


	end

	if msg == 'BUFF_ADD' then
		frame:ShowWindow(0);
	end
end

