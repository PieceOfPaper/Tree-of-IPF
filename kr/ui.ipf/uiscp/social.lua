-- ui/uiscp/social.lua --

function SOCIAL_MYPAGE_VIEW(frame)
	local descText = GET_CHILD(frame, "descText", "ui::CRichText");
	descText:SetText(ScpArgMsg("Auto_{@st43}MaiPeiJi{/}"));
end

function SOCIAL_GUESTBOOK_VIEW(frame)	
	local descText = GET_CHILD(frame, "descText", "ui::CRichText");
	descText:SetText(ScpArgMsg("Auto_{@st43}BangMyeongLog{/}"));
end

function SOCIAL_SELL_VIEW(frame)
	local descText = GET_CHILD(frame, "descText", "ui::CRichText");
	descText:SetText(ScpArgMsg("Auto_{@st43}KaeinSangJeom{/}"));
	ui.OpenFrame("inventory");
end

function SOCIAL_BUY_VIEW(frame)
	local descText = GET_CHILD(frame, "descText", "ui::CRichText");
	descText:SetText(ScpArgMsg("Auto_{@st43}KuMaeyoCheong{/}"));
	ui.OpenFrame("wiki");
end

function SOCIAL_MERCENARY_VIEW(frame)
	local descText = GET_CHILD(frame, "descText", "ui::CRichText");
	descText:SetText(ScpArgMsg("Auto_{@st43}yongByeongKyeyag{/}"));
end


function OPEN_SOCIAL_POSE_VIEW(frame)
	ui.ToggleFrame('social');
	local frame = ui.GetFrame("social");
	SOCIAL_GBOX_SHOW(frame, 'poseGbox');
	SOCIAL_POSE_VIEW(frame);
	
	local macroFrame = ui.GetFrame("chatmacro");
	if macroFrame ~= nil and macroFrame:IsVisible() == 0 then
		ui.ToggleFrame('chatmacro')
	else
		ui.CloseFrame('chatmacro')
	
	end
end

function SOCIAL_POSE_VIEW(frame)

	print('????')
	--[[
	local descText = GET_CHILD(frame, "descText", "ui::CRichText");
	descText:SetText(ScpArgMsg("Auto_{@st43}aegSyeonPoJeu{/}"));
	
	local posePicasa = GET_CHILD(frame, "poseGbox", "ui::CPicasa");	
	
	local clslist = GetClassList("Pose");
	local index = 0;
	while 1 do
		local cls = GetClassByIndexFromList(clslist, index);
		if cls == nil then
			break;
		end
		
		posePicasa:AddCategory(cls.Category, cls.Category);
		local picasaItem = posePicasa:AddItem(cls.Category, cls.ClassName, cls.Icon, cls.Name, "None");
		if picasaItem ~= nil then
			tolua.cast(picasaItem, 'ui::CPicasaItem');
			picasaItem:SetValue(cls.ClassID);
			picasaItem:SetLBtnDownScp("SOCIAL_POSE", "None", cls.ClassID);			
			picasaItem:EnableDrag(true);
			local icon = picasaItem:GetIcon();
			icon:SetUserValue('POSEID', cls.ClassID);
		end
		
		index = index + 1;
	end]]
end

function SOCIAL_GBOX_SHOW(frame, showGBoxName)	

	if frame == nil then
		return;
	end

	HIDE_CHILD_BYNAME(frame, "Gbox");
	local showGBox = frame:GetChild(showGBoxName);
	showGBox:ShowWindow(1);		
end

function MYPAGE_COMMENT_REGISTER(frame, ctrl, argStr, argNum)
	local writeEditCtrl = GET_CHILD(frame, "writeEdit", "ui::CEditControl");
	if writeEditCtrl:GetText() ~= "" then
		session.AddMyPageComment(writeEditCtrl:GetText(), 0, 0);
		writeEditCtrl:ClearText();		
	end
end

function QUESTBOOK_COMMENT_REGISTER(frame, ctrl, argStr, argNum)

	local writeEditCtrl = GET_CHILD(frame, "writeEdit", "ui::CEditControl");
	if writeEditCtrl:GetText() ~= "" then
		session.AddGuestBookComment(writeEditCtrl:GetText(), 0, 0);
		writeEditCtrl:ClearText();
	end
end

function VIEW_COMMENT_CHECK(commentCtrlSet, checkBox, argStr, argNum)		
	local socialFrame = ui.GetFrame("social");
	local mypageGbox = socialFrame:GetChild("mypageGbox");
	local boardModeOn = GET_CHILD(mypageGbox, "boardModeOn", "ui::CButton");
	
	if argStr == "true" then		
		local commentGbox = commentCtrlSet:GetParent();
		local cnt = commentGbox:GetChildCount();
		for  i = 0, cnt -1 do
			local childObj = commentGbox:GetChildByIndex(i);
			local name = childObj:GetName();
			if string.find(name, "_comment") ~= nil and commentCtrlSet ~= childObj then
				local viewCheckBox = GET_CHILD(childObj, "viewComment", "ui::CCheckBox");				
				if viewCheckBox:IsChecked() == 1 then
					viewCheckBox:SetCheck(0);
				end
			end
		end
		boardModeOn:SetEventScriptArgNumber(ui.LBUTTONUP, commentCtrlSet:GetValue());
		boardModeOn:SetEnable(1);

		boardModeOn:SetDragScp('START_DRAG_POSE');
	else
		boardModeOn:SetEnable(0);
	end	
end


function START_DRAG_POSE(frame, ctrl)
	
	local poseID = ctrl:GetValue();
	print('START_DRAG_POSE', poseID);
	frame:SetTooltipNumArg(poseID);
end

function SELL_MODE_CHECK(sellGbox)
	local cnt = sellGbox:GetChildCount();
	for  i = 0, cnt -1 do
		local childObj = sellGbox:GetChildByIndex(i);
		local name = childObj:GetName();
		if string.find(name, "sellItem_") ~= nil then
			local sellItemSlot = GET_CHILD(childObj, "slot", "ui::CSlot");
			local sellCountNumUpDown = GET_CHILD(childObj, "countEdit", "ui::CNumUpDown");
			
			local sellItemIcon = sellItemSlot:GetIcon();
			local sellItemIconInfo = sellItemIcon:GetInfo();
			
			local invenInfo = session.GetInvItem(sellItemIconInfo.ext);	
			session.AddSellMode(invenInfo:GetIESID(), sellCountNumUpDown:GetNumber());			
		end
	end
end

function BUY_MODE_CHECK(buyGbox)
	local cnt = buyGbox:GetChildCount();
	for  i = 0, cnt -1 do
		local childObj = buyGbox:GetChildByIndex(i);
		local name = childObj:GetName();
		if string.find(name, "buyItem_") ~= nil then
			local buyItemSlot = GET_CHILD(childObj, "slot", "ui::CSlot");
			local buyCountNumUpDown = GET_CHILD(childObj, "countEdit", "ui::CNumUpDown");
			local buyPriceNumUpDown = GET_CHILD(childObj, "priceEdit", "ui::CNumUpDown");
			
			local buyItemIcon = buyItemSlot:GetIcon();
			local buyItemIconInfo = buyItemIcon:GetInfo();
			
			session.AddBuyMode(buyItemIconInfo.type, buyPriceNumUpDown:GetNumber(), buyCountNumUpDown:GetNumber());
		end
	end
end

function SOCIAL_SELL_ITEM_ADD(invIndex, itemCount)	
	local invenInfo = session.GetInvItem(invIndex);	
	session.AddSellMode(invenInfo:GetIESID(), 1, itemCount);
end

function SOCIAL_SELL_ITEM_DELETE(shopIndex)
	session.DeleteSellMode(shopIndex);
end
