function TRADESELECTITEM_ON_INIT(addon, frame)
end

function OPEN_TRADE_SELECT_ITEM(invItem)
	local frame = ui.GetFrame("tradeselectitem")
	local itemobj = GetIES(invItem:GetObject());
	local itemGuid = invItem:GetIESID();

	local box = frame:GetChild('box');
	tolua.cast(box, "ui::CGroupBox");
	box:DeleteAllControl();
	local y = 5;
	local cls = GetClass("TradeSelectItem", itemobj.ClassName)
	frame:SetTitleName("{@st43}{s22}"..ClMsg(cls.TitleClientMsg))
	frame:SetUserValue("UseItemGuid", itemGuid);
	local index = 1;

	while 1 do
		local itemIndex = TryGetProp(cls, "SelectItemName_"..index)
		if itemIndex ~= nil then
			index = index + 1;
		else
			break;
		end
	end

	for i = 1, index do
		local itemName = TryGetProp(cls, "SelectItemName_"..i);
		local itemCount = TryGetProp(cls, "SelectItemCount_"..i);
		if itemName ~= 'None' and itemName ~= nil and itemCount ~= 0 and itemCount ~= nil then
			y = CREATE_QUEST_REWARE_CTRL(box, y, i, itemName, itemCount, nil);	
			y = y + 5
		end
	end

	local cancelBtn = frame:GetChild('CancelBtn');
	local useBtn = frame:GetChild('UseBtn');

	box:Resize(box:GetWidth(), y);
	
	local maxSizeHeightFrame = box:GetY() + box:GetHeight() + 20;
	local maxSizeHeightWnd = ui.GetSceneHeight();
	if maxSizeHeightWnd < (maxSizeHeightFrame + 50) then 
		local margin = maxSizeHeightWnd/2;
		box:EnableScrollBar(1);
		box:Resize(box:GetWidth() + 15, margin - useBtn:GetHeight() - 40);
		box:SetScrollBar(0);
		box:InvalidateScrollBar();
		frame:Resize(frame:GetWidth() + 10, margin + 100);
	else
		box:SetCurLine(0) -- scroll init
		box:EnableScrollBar(0);
		box:Resize(box:GetWidth(), y);
		frame:Resize(frame:GetWidth() + 10, maxSizeHeightFrame);
	end;
	
	frame:ShowWindow(1);

	
	local selectExist = 0;
	local cnt = box:GetChildCount();
	for i = 0 , cnt - 1 do
		local ctrlSet = box:GetChildByIndex(i);
		local name = ctrlSet:GetName();
		if string.find(name, "REWARD_") ~= nil then
			selectExist = 1;
		end 
	end
	frame:ShowWindow(1);
end

function REQUEST_TRADE_ITEM(frame, ctrl, argStr, argNum)
	local box = frame:GetChild('box');
	tolua.cast(box, "ui::CGroupBox");

	local selectExist = 0;
	local selected = 0;
	local cnt = box:GetChildCount();
	for i = 0 , cnt - 1 do
		local ctrlSet = box:GetChildByIndex(i);
		local name = ctrlSet:GetName();
		if string.find(name, "REWARD_") ~= nil then
			tolua.cast(ctrlSet, "ui::CControlSet");
			if ctrlSet:IsSelected() == 1 then
				selected = ctrlSet:GetValue();
			end
			selectExist = 1;
		end
	end

	if selectExist == 1 and selected == 0 then
		ui.MsgBox(ScpArgMsg("Auto_BoSangeul_SeonTaegHaeJuSeyo."));
		return;
	end

	if selectExist == 1 then
		local itemGuid = frame:GetUserValue("UseItemGuid");
		local argStr = string.format("%s#%d", itemGuid, selected);
		pc.ReqExecuteTx("SCR_TX_TRADE_SELECT_ITEM", argStr);
	end

	frame = frame:GetTopParentFrame();
	frame:ShowWindow(0);
end

function CANCEL_TRADE_ITEM(frame, ctrl, argStr, argNum)
	local box = frame:GetChild('box');
	tolua.cast(box, "ui::CGroupBox");

	local cnt = box:GetChildCount();
	for i = 0 , cnt - 1 do
		local ctrlSet = box:GetChildByIndex(i);
		local name = ctrlSet:GetName();
		if string.find(name, "REWARD_") ~= nil then
			tolua.cast(ctrlSet, "ui::CControlSet");
			ctrlSet:Deselect();
		end
	end
	control.DialogItemSelect(0);
	frame = frame:GetTopParentFrame();
	frame:ShowWindow(0);
end