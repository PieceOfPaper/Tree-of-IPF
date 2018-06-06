function APPRAISAL_PC_ON_INIT(addon, frame)	
	addon:RegisterMsg("SUCCESS_APPRALSAL_PC", "APPRAISAL_PC_REFRESH");
end

function APPRAISAL_PC_UI_COMMON(groupName, sellType, handle)
	-- set user value
	local frame = ui.GetFrame("appraisal_pc");
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	local sklName = GetClassByType("Skill", groupInfo.classID).ClassName;
	frame:SetUserValue("GroupName", groupName);
	frame:SetUserValue("SELL_TYPE", sellType);
	frame:SetUserValue("HANDLE", handle);
	frame:SetUserValue("SKILLNAME", sklName)

	-- default tab: appraisalBox
	local tab = frame:GetChild('tab');
	local tabCtrl = tolua.cast(tab, "ui::CTabControl");
	tabCtrl:ChangeTab(0);
	ITEMBUFF_SHOW_TAB(tabCtrl, handle);
	
	APPRAISAL_PC_TAB_CHANGE(frame, nil, handle);
	APPRAISAL_PC_REFRESH(frame);
	
	frame:ShowWindow(1);
end

function APPRAISAL_PC_CALC_NEEDCOUNT(frame)
	local frame = frame:GetTopParentFrame();
	local handle = frame:GetUserIValue('HANDLE');
	if handle ~= session.GetMyHandle() then
		return;
	end

	local slotSet = GET_CHILD_RECURSIVELY(frame,"slotlist","ui::CSlotSet")
	local needCnt = 0;
	local groupName = frame:GetUserValue("GroupName");
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);	

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();

		local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
		local itemobj = GetIES(invitem:GetObject());
		local itemName, cnt = ITEMBUFF_NEEDITEM_Appraiser_Apprise(nil, itemobj);
		
		needCnt = needCnt + cnt;
	end

	local materialNeedText = GET_CHILD_RECURSIVELY(frame, 'materialNeedText');
	materialNeedText:SetTextByKey('cnt', needCnt.." "..ClMsg("CountOfThings"));
	frame:SetUserValue('NEED_COUNT', needCnt);
end

function APPRAISAL_PC_SHOW_MATERIALBOX(frame, handle)
	local materialBox = GET_CHILD_RECURSIVELY(frame, 'materialBox');

	if session.GetMyHandle() == handle then
		local materialPic = GET_CHILD_RECURSIVELY(frame, 'materialPic');
		local materialNameText = GET_CHILD_RECURSIVELY(frame, 'materialNameText');
		local materialNeedText = GET_CHILD_RECURSIVELY(frame, 'materialNeedText');
		local remainCnt = GET_CHILD_RECURSIVELY(frame, 'remainCnt');

		local pc = GetMyPCObject();
		local invItemList = session.GetInvItemList();
		local checkFunc = _G["ITEMBUFF_STONECOUNT_" .. frame:GetUserValue("SKILLNAME")];
		local name, cnt = checkFunc(invItemList, frame);
		local cls = GetClass("Item", name);
		local txt = GET_ITEM_IMG_BY_CLS(cls, 60);

		materialPic:SetTextByKey('name', txt);
		materialNameText:SetTextByKey('name', cls.Name);
		local text = cnt .. " " .. ClMsg("CountOfThings");
		remainCnt:SetTextByKey('cnt', text);
		materialBox:ShowWindow(1);
	else
		materialBox:ShowWindow(0);
	end
end

function APPRAISAL_PC_TAB_CHANGE(frame, ctrl, handle)
	local appraisalBox = GET_CHILD_RECURSIVELY(frame, 'appraisalBox');
	local historyBox = GET_CHILD_RECURSIVELY(frame, 'historyBox');
	local tabCtrl = GET_CHILD_RECURSIVELY(frame, 'tab');

	local tabIndex = tabCtrl:GetSelectItemIndex();
	if tabIndex == 0 then -- 감정 탭
		appraisalBox:ShowWindow(1);
		historyBox:ShowWindow(0);
	elseif tabIndex == 1 then -- 기록 탭
		appraisalBox:ShowWindow(0);
		historyBox:ShowWindow(1);
	end

	if handle == session.GetMyHandle() or handle == "" then
		tabCtrl:ShowWindow(1);
	else
		tabCtrl:ShowWindow(0);
	end
end

function APPRAISAL_PC_CANCEL(frame, ctrl)
	frame = frame:GetTopParentFrame();
	local groupName = frame:GetUserValue("GroupName");
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	if groupInfo == nil then
		return;
	end
	
	session.autoSeller.Close(groupName);
	frame:ShowWindow(0);
end

function APPRAISAL_PC_EXECUTE(frame)
	local frame = frame:GetTopParentFrame();
	local handle = frame:GetUserIValue("HANDLE");
	local skillName = frame:GetUserValue("SKILLNAME");
	local slotSet = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet")
	
	session.ResetItemList();	
	
	-- check selected item
	if slotSet:GetSelectedSlotCount() < 1 then
		ui.MsgBox(ScpArgMsg("DON_T_HAVE_ITEM_TO_APPRAISAL"));
		return;
	end

	-- check money
	if handle ~= session.GetMyHandle() and GET_TOTAL_MONEY() < frame:GetUserIValue('TOTAL_MONEY') then
		ui.MsgBox(ScpArgMsg("Auto_SoJiKeumi_BuJogHapNiDa."));
		return;
	end

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();

		session.AddItemID(iconInfo:GetIESID());
	end

	session.autoSeller.BuyItems(handle, AUTO_SELL_APPRAISE, session.GetItemIDList(), skillName);
end

function APPRAISAL_PC_ITEM_LBTDOWN(frame, ctrl)
	ui.EnableSlotMultiSelect(1);
	APPRAISAL_UPDATE_MONEY(frame);
	APPRAISAL_PC_CALC_NEEDCOUNT(frame);
end

function APPRAISAL_PC_UI_CLOSE()
	local frame = ui.GetFrame('appraisal_pc');
	ui.EnableSlotMultiSelect(0);
	frame:ShowWindow(0)
end

function APPRAISAL_PC_UPDATE_HISTORY(frame)
	local groupName = frame:GetUserValue("GroupName");	
	local cnt = session.autoSeller.GetHistoryCount(groupName);
	local gboxctrl = frame:GetChild("historyBox");
	local historyStrBox = gboxctrl:GetChild("historyStrBox");
	historyStrBox:RemoveAllChild();

	for i = cnt -1 , 0, -1 do
		local info = session.autoSeller.GetHistoryByIndex(groupName, i);
		local ctrlSet = historyStrBox:CreateControlSet("squire_rpair_history", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);

		local sList = StringSplit(info:GetHistoryStr(), "#");
		local userName = sList[1];
		local property = ctrlSet:GetChild("UserName");
		property:SetTextByKey("value", userName .. ClMsg("AppraisedItemFor"));
		
		local itemStr = "";
		local priceStr = "";

		for i = 2, #sList do
			if i % 2 == 0 then
				local itemCls = GetClassByType("Item", sList[i]);
				if nil ~= itemCls then
					itemStr = itemStr.. itemCls.Name.."{nl}" ;
				end
			else
				priceStr = priceStr .. ClMsg("AppraisalCost") .. ":" .. sList[i].."{nl}";
			end

		end

		local itemname = ctrlSet:GetChild("itemName");
		itemname:SetTextByKey("value", itemStr);
		local price = ctrlSet:GetChild("Price");
		price:SetTextByKey("value", priceStr);
		ctrlSet:Resize(historyStrBox:GetWidth() - 40, price:GetY() + price:GetHeight()); -- 40: SCROLL_WIDTH
		ctrlSet:Invalidate();
	end

	GBOX_AUTO_ALIGN(historyStrBox, 20, 3, 10, true, false);
end

function APPRAISAL_PC_REFRESH(frame)
	local handle = frame:GetUserIValue('HANDLE');

	APPRAISAL_UPDATE_ITEM_LIST(frame);
	APPRAISAL_PC_SHOW_MATERIALBOX(frame, handle);
	APPRAISAL_PC_CALC_NEEDCOUNT(frame);
	APPRAISAL_PC_UPDATE_HISTORY(frame);
end

function APPRAISAL_PC_ON_TYPING(parent, ctrl)
	ctrl = tolua.cast(ctrl, 'ui::CEditControl');
	local inputPrice = ctrl:GetNumber();
	if inputPrice < 1 then
		ctrl:SetText('1');
		ui.MsgBox(ScpArgMsg('InputPriceBetween{MIN}{MAX}', 'MIN', 1, 'MAX', APPRRISE_MAX_UNIT_MONEY));
	elseif inputPrice > APPRRISE_MAX_UNIT_MONEY then
		ctrl:SetText(tostring(APPRRISE_MAX_UNIT_MONEY));
		ui.MsgBox(ScpArgMsg('InputPriceBetween{MIN}{MAX}', 'MIN', 1, 'MAX', APPRRISE_MAX_UNIT_MONEY));
	end
end