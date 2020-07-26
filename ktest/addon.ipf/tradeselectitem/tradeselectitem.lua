function TRADESELECTITEM_ON_INIT(addon, frame)
end

function OPEN_TRADE_SELECT_ITEM(invItem)
    local itemobj = GetIES(invItem:GetObject());
    if itemobj.ItemLifeTimeOver == 1 then
		ui.SysMsg(ScpArgMsg('LessThanItemLifeTime'));
		return
	end
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
			y = CREATE_QUEST_REWARE_CTRL(box, y, i, itemName, itemCount, nil, itemobj.ClassName);	
			y = y + 5
		end
	end
	
	frame:SetUserValue("TradeSelectItem", itemobj.ClassName);

	local cancelBtn = frame:GetChild('CancelBtn');
	cancelBtn:SetVisible(1);
	local useBtn = frame:GetChild('UseBtn');
	useBtn:SetEventScript(ui.LBUTTONUP,'REQUEST_TRADE_ITEM')
	local useBtnMargin = useBtn:GetMargin();
	local xmargin = frame:GetUserConfig("USE_BTN_X_MARGIN");
	useBtn:SetMargin(tonumber(xmargin), 0, 0, useBtnMargin.bottom);

	box:Resize(box:GetOriginalWidth(), y);	    
	local screen_height = option.GetClientHeight();
	local maxSizeHeightFrame = box:GetY() + box:GetHeight() + 20;
	local maxSizeHeightWnd = ui.GetSceneHeight();
    
    if maxSizeHeightWnd >= 950 then        
        maxSizeHeightWnd = 950
    
        if maxSizeHeightWnd > screen_height then
            maxSizeHeightWnd = screen_height * 0.8
        end
    end
    
    if maxSizeHeightFrame >= maxSizeHeightWnd then
        maxSizeHeightFrame = maxSizeHeightWnd
    end
       
	if maxSizeHeightWnd < (maxSizeHeightFrame + 50) then                 
		local margin = maxSizeHeightWnd/2;
		box:EnableScrollBar(1);

		box:Resize(box:GetOriginalWidth(), margin - useBtn:GetHeight() - 40);
		box:SetScrollBar(0);
		box:InvalidateScrollBar();
		frame:Resize(frame:GetOriginalWidth(), margin + 100);
	else
		box:SetCurLine(0) -- scroll init
		
		box:Resize(box:GetOriginalWidth(), y);
		frame:Resize(frame:GetOriginalWidth(), maxSizeHeightFrame);
	end;
	box:SetScrollPos(0);
	
	local selectExist = 0;
	local cnt = box:GetChildCount();
	for i = 0 , cnt - 1 do
		local ctrlSet = box:GetChildByIndex(i);
		local name = ctrlSet:GetName();
		if string.find(name, "REWARD_") ~= nil then
			selectExist = 1;
		end 
	end

	local NeedItemSlot = frame:GetChild('NeedItemSlot')
	local NeedItemName = frame:GetChild('NeedItemName')
	NeedItemName:SetVisible(0)
	NeedItemSlot:SetVisible(0)
	frame:ShowWindow(1);
end

function OPEN_TRADE_ANCIENT_CARD_ITEM(frame, msg, strArg, numArg)
end

function OPEN_TRADE_SELECT_MUTIPLE_ITEM(targetItemNameList, targetItemCostList,targetItemName, rewareItemName)
	local frame = ui.GetFrame("tradeselectitem")
	local useItemCls = GetClass("Item","EVENT_190919_ANCIENT_SCROLL")
	frame:SetTitleName("{@st43}{s22}"..useItemCls.Name)

	local y = 5;
	local box = frame:GetChild('box');
	tolua.cast(box, "ui::CGroupBox");
	box:DeleteAllControl();

	for i = 1, #targetItemNameList do
		--y = CREATE_ANCIENT_CARD_CTRL(box, y, i, rewareItemName, 1,targetItemName, targetItemNameList[i], targetItemCostList[i]);	
		--y = y + 5
	end

	local cancelBtn = frame:GetChild('CancelBtn');
	cancelBtn:SetVisible(0)
	local useBtn = frame:GetChild('UseBtn');
	useBtn:SetEventScript(ui.LBUTTONUP,'REQUEST_TRADE_ANCIENT_CARD')
	local useBtnMargin = useBtn:GetMargin();
	useBtn:SetMargin(0,0,0,useBtnMargin.bottom)
	box:Resize(box:GetOriginalWidth(), y);

	local screen_height = option.GetClientHeight();
	local maxSizeHeightFrame = box:GetY() + box:GetHeight() + 20;
	local maxSizeHeightWnd = ui.GetSceneHeight();
    if maxSizeHeightWnd >= 950 then        
        maxSizeHeightWnd = 950
    
        if maxSizeHeightWnd > screen_height then
            maxSizeHeightWnd = screen_height * 0.8
        end
    end
    if maxSizeHeightFrame >= maxSizeHeightWnd then
        maxSizeHeightFrame = maxSizeHeightWnd
    end
	if maxSizeHeightWnd < (maxSizeHeightFrame + 50) then                 
		local margin = maxSizeHeightWnd/2;
		box:EnableScrollBar(1);

		box:Resize(box:GetOriginalWidth(), margin - useBtn:GetHeight() - 40);
		box:SetScrollBar(0);
		box:InvalidateScrollBar();
		frame:Resize(frame:GetOriginalWidth(), margin + 100);
	else
		box:SetCurLine(0) -- scroll init
		
		box:Resize(box:GetOriginalWidth(), y);
		frame:Resize(frame:GetOriginalWidth(), maxSizeHeightFrame);
	end;
	box:SetScrollPos(0);

	local selectExist = 0;
	local cnt = box:GetChildCount();
	for i = 0 , cnt - 1 do
		local ctrlSet = box:GetChildByIndex(i);
		local name = ctrlSet:GetName();
		if string.find(name, "REWARD_") ~= nil then
			selectExist = 1;
		end 
	end

	local NeedItemSlot = frame:GetChild('NeedItemSlot')
	local NeedItemName = frame:GetChild('NeedItemName')
	
	NeedItemName:SetVisible(1)
	NeedItemSlot:SetVisible(1)
	
	tolua.cast(NeedItemSlot, "ui::CSlot");
	local NeedItemCls = GetClass("Item", targetItemName);
	local NeedIcon = GET_ITEM_ICON_IMAGE(NeedItemCls, GETMYPCGENDER())
	SET_SLOT_IMG(NeedItemSlot, NeedIcon);

	local targetItem = session.GetInvItemByName(targetItemName);
	frame:SetUserValue("NEED_ITEM",targetItemName)
	local targetItemCnt = 0;
	if targetItem ~= nil then
		targetItemCnt = targetItem.count;
	end
	NeedItemName:SetTextByKey('total', targetItemCnt);
    NeedItemName:SetTextByKey('select', 0);
	
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
		
        local tradeSelectItem = frame:GetUserValue("TradeSelectItem");
        local cls = GetClass("TradeSelectItem", tradeSelectItem)
		local warningYesNoMsg = TryGetProp(cls, 'WarningYesNoMsg')
        if warningYesNoMsg ~= nil and warningYesNoMsg ~= '' and warningYesNoMsg ~= 'None' then
            local selectItemName = GetClass('Item', TryGetProp(cls, 'SelectItemName_'..selected)).Name
            local yesScp = string.format("REQUEST_TRADE_ITEM_WARNINGYES(\"%s\")",argStr);
        	ui.MsgBox(ScpArgMsg(warningYesNoMsg,'ITEM', selectItemName) , yesScp, 'None');
        else
    		pc.ReqExecuteTx("SCR_TX_TRADE_SELECT_ITEM", argStr);
    	end
	end

	frame = frame:GetTopParentFrame();
	frame:ShowWindow(0);
end

function SCR_GET_ANCIENT_CARD_TOTAL_COST(frame, ctrl, argStr, argNum)
	frame = frame:GetTopParentFrame()
	local box = frame:GetChild('box');
	tolua.cast(box, "ui::CGroupBox");

	local totalCost = 0;
	local cnt = box:GetChildCount();
	for i = 0 , cnt - 1 do
		local ctrlSet = box:GetChildByIndex(i);
		local name = ctrlSet:GetName();
		if string.find(name, "REWARD_") ~= nil then
			tolua.cast(ctrlSet, "ui::CControlSet");
			if ctrlSet:IsSelected() == 1 then
				local classID = ctrlSet:GetValue();
				totalCost = totalCost + ctrlSet:GetUserValue("Cost");
			end
		end
	end
	local NeedItemName = GET_CHILD_RECURSIVELY(frame,'NeedItemName')
	frame:SetUserValue("COST",totalCost)
	NeedItemName:SetTextByKey('select', totalCost);
end

function REQUEST_TRADE_ANCIENT_CARD(frame, ctrl, argStr, argNum)
	local box = frame:GetChild('box');
	tolua.cast(box, "ui::CGroupBox");

	local selectExist = 0;
	local selected = "";
	local monClassIDList = frame:GetUserValue("ANCIENT_CARD_LIST")
	monClassIDList = StringSplit(monClassIDList,';')
	local cnt = box:GetChildCount();
	for i = 0 , cnt - 1 do
		local ctrlSet = box:GetChildByIndex(i);
		local name = ctrlSet:GetName();
		if string.find(name, "REWARD_") ~= nil then
			tolua.cast(ctrlSet, "ui::CControlSet");
			if ctrlSet:IsSelected() == 1 then
				if selected ~= "" then
					selected = selected .. ' ';
				end
				selected = selected .. monClassIDList[ctrlSet:GetValue()]
			end
			selectExist = 1;
		end
	end

	local totalCost = tonumber(frame:GetUserValue("COST"))
	local targetItemName = frame:GetUserValue("NEED_ITEM")
	local targetItem = session.GetInvItemByName(targetItemName);
	local itemCount = 0
	if targetItem ~= nil then
		itemCount = targetItem.count
	end
	if totalCost > itemCount then
		addon.BroadMsg("NOTICE_Dm_scroll", ClMsg("NoEnoguhtItemCantOpenCube"), 3);
		return;
	end
	local iesID = frame:GetUserValue("IES_ID")
	if selected == '' then
		local str = ScpArgMsg("AncientScrollSelect")
		local yesScp = string.format("ANCIENT_SCROLL_EMPTY_USE(\"%s\")", iesID);
		ui.MsgBox(str, yesScp, "None");
		return;
	end
	if selectExist == 1 then
		pc.ReqExecuteTx_Item("SCR_TRADE_SELECT_ANCIENT_CARD", iesID,selected);
	end

	frame = frame:GetTopParentFrame();
	frame:ShowWindow(0);
end

function REQUEST_TRADE_ITEM_WARNINGYES(argStr)
    pc.ReqExecuteTx("SCR_TX_TRADE_SELECT_ITEM", argStr);
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

-- JOB 선택
function OPEN_TRADE_SELECT_JOB(invItem)
	local frame = ui.GetFrame("tradeselectitem")
	frame:SetTitleName('{@st43}{s22}' ..ScpArgMsg('SkillPointPotion'))
	local box = frame:GetChild('box');
	tolua.cast(box, "ui::CGroupBox");
	box:DeleteAllControl();
	local y = 5;

	local jobList = GetMyJobList()

    local lv = TryGetProp(GetMyPCObject(), 'Lv', 1)
    if lv < PC_MAX_LEVEL - 10 then
		ui.SysMsg(ScpArgMsg('CannotBecauseBaseLevel'));        
        return;
    end

	if #jobList < 4 then
        ui.SysMsg(ScpArgMsg('CannotBecauseLessJobSequence'));
        return
    end

    if GetJobLv(GetMyPCObject()) < 45 then
        ui.SysMsg(ScpArgMsg('CannotChangeJobBecauseJobLevel'));        
        return;
    end

	for i = 1,#jobList do
		local jobCls = GetClassByType("Job",jobList[i])
		if jobCls ~= nil then
			local jobName = jobCls.Name
			y = CREATE_QUEST_REWARE_CTRL_JOB(box, y, i, jobCls);	
			y = y + 5
		end
	end

	local cancelBtn = frame:GetChild('CancelBtn');
	local useBtn = frame:GetChild('UseBtn');
	useBtn:SetEventScript(ui.LBUTTONUP,'REQUEST_TRADE_JOB')

	box:Resize(box:GetOriginalWidth(), y);	    
	local screen_height = option.GetClientHeight();
	local maxSizeHeightFrame = box:GetY() + box:GetHeight() + 20;
	local maxSizeHeightWnd = ui.GetSceneHeight();
    
    if maxSizeHeightWnd >= 950 then        
        maxSizeHeightWnd = 950
    
        if maxSizeHeightWnd > screen_height then
            maxSizeHeightWnd = screen_height * 0.8
        end
    end
    
    if maxSizeHeightFrame >= maxSizeHeightWnd then
        maxSizeHeightFrame = maxSizeHeightWnd
    end
       
	if maxSizeHeightWnd < (maxSizeHeightFrame + 50) then                 
		local margin = maxSizeHeightWnd/2;
		box:EnableScrollBar(1);

		box:Resize(box:GetOriginalWidth(), margin - useBtn:GetHeight() - 40);
		box:SetScrollBar(0);
		box:InvalidateScrollBar();
		frame:Resize(frame:GetOriginalWidth(), margin + 100);
	else
		box:SetCurLine(0) -- scroll init
		
		box:Resize(box:GetOriginalWidth(), y);
		frame:Resize(frame:GetOriginalWidth(), maxSizeHeightFrame);
	end;
	box:SetScrollPos(0);
	local selectExist = 0;
	local cnt = box:GetChildCount();
	for i = 0 , cnt - 1 do
		local ctrlSet = box:GetChildByIndex(i);
		local name = ctrlSet:GetName();
		if string.find(name, "REWARD_") ~= nil then
			selectExist = 1;
		end 
	end

	local NeedItemSlot = frame:GetChild('NeedItemSlot')
	local NeedItemName = frame:GetChild('NeedItemName')
	NeedItemName:SetVisible(0)
	NeedItemSlot:SetVisible(0)

    local itemGuid = invItem:GetIESID();
	frame:SetUserValue("UseItemGuid", itemGuid);    
	frame:ShowWindow(1);
end

function CREATE_QUEST_REWARE_CTRL_JOB(box, y, index, jobCls)
	local isOddCol = 0;
	if math.floor((index - 1) % 2) == 1 then
		isOddCol = 0;
	end

	local x = 5;
	if isOddCol == 1 then
		x = (box:GetWidth() / 2) + 5;
		local ctrlHeight = ui.GetControlSetAttribute('quest_reward_s', 'height');
		y = y - ctrlHeight - 10;
	end
	local jobName = jobCls.Name
	local jobIcon = jobCls.Icon
	local ctrlSet = box:CreateControlSet('quest_reward_s', "REWARD_" .. index, x, y);
	tolua.cast(ctrlSet, "ui::CControlSet");
	--여기 값을 나중에 받아서 처리!!
	ctrlSet:SetValue(jobCls.ClassID);
	
	local slot = ctrlSet:GetChild("slot");
	tolua.cast(slot, "ui::CSlot");
	
	local icon = CreateIcon(slot)
	icon:SetImage(jobIcon)

	local jobText = ctrlSet:GetChild("ItemName");
	jobName = "{@st41b}"..jobName
	jobText:SetText(jobName);
	ctrlSet:SetOverSound("button_cursor_over_3");
	ctrlSet:SetClickSound("button_click_stats");
	ctrlSet:SetEnableSelect(1);
	ctrlSet:SetSelectGroupName("QuestRewardList");
	
	ctrlSet:Resize(box:GetWidth() - 30, ctrlSet:GetHeight());

	y = y + ctrlSet:GetHeight();
	return y;

end

function REQUEST_TRADE_JOB(frame, ctrl, argStr, argNum)    
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
		--선택한 ClassID		
		local itemGuid = frame:GetUserValue("UseItemGuid");
		local argStr = string.format("%s", selected);
        pc.ReqExecuteTx_Item("SCR_USE_ADD_SKILL_POINT", itemGuid, argStr);
	end

	frame = frame:GetTopParentFrame();
	frame:ShowWindow(0);
end

function TEST_JOB_SELECT_UI(self)
	ExecClientScp(self,"OPEN_TRADE_SELECT_JOB()")
end
