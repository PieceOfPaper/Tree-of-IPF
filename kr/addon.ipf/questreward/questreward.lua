MAX_QUEST_TAKEITEM = 4;
MAX_QUEST_SELECTITEM = 8;
QUESTREWARD_SELECT = 1;

function QUESTREWARD_ON_INIT(addon, frame)
	addon:RegisterMsg("SHOW_QUEST_SEL_DLG", "ON_SHOW_QUEST_SEL_DLG");
	addon:RegisterMsg('ESCAPE_PRESSED', 'QUESTREWARD_ON_ESCAPE');
	addon:RegisterMsg('QUESTREWARD_LEFT', 'QUESTREWARD_ON_MSG');
	addon:RegisterMsg('QUESTREWARD_RIGHT', 'QUESTREWARD_ON_MSG');
	addon:RegisterMsg('REWARDSELECT', 'QUESTREWARD_ON_MSG');
	addon:RegisterMsg('DIALOG_ITEM_SELECT', 'ON_QUEST_ITEM_SELECT');
	addon:RegisterMsg('CHANGE_COUNTRY', 'QUESTREWARD_ON_LANGUAGECHANGE');

	

	local frame 	= ui.GetFrame('questreward');
	frame:SetUserValue("QUEST_REWARD_PC_CON_LOCK", 0);
end

function QUESTREWARD_ON_MSG(frame, msg, argStr, argNum)

	if  msg == 'QUESTREWARD_LEFT' or msg == 'QUESTREWARD_RIGHT' then
		if QUESTREWARD_SELECT == 0 then
			QUESTREWARD_SELECT = 1;

			local ItemBtn = frame:GetChild('UseBtn');
			local x, y = GET_SCREEN_XY(ItemBtn);
			mouse.SetPos(x,y);
			mouse.SetHidable(0);
		else
			local ItemBtn = frame:GetChild('CancelBtn');
			if ItemBtn:IsVisible() == 1 then
				QUESTREWARD_SELECT = 0;

				local x, y = GET_SCREEN_XY(ItemBtn);
				mouse.SetPos(x,y);
				mouse.SetHidable(0);
			end
		end
	elseif msg == 'REWARDSELECT' then
		if QUESTREWARD_SELECT == 0 then
			local ItemBtn = frame:GetChild('CancelBtn');
			CANCEL_QUEST_REWARD(frame, ItemBtn);
		else
			CONFIRM_QUEST_REWARD(frame);
		end
	end
end

function QUESTREWARD_CLOSE(frame)
	QUESTREWARD_SELECT = 1;
end

function ON_SHOW_QUEST_SEL_DLG(frame, msg, str, questID)

	pc.RequestStop();

	QUEST_REWARD_TEST(frame, questID);

end


function QUEST_REWARD_TEST(frame, questID)

	local questCls = GetClassByType("QuestProgressCheck", questID);
	local cls = GetClassByType("QuestProgressCheck_Auto", questID);

	local box = frame:GetChild('box');
	tolua.cast(box, "ui::CGroupBox");
	box:DeleteAllControl();
	local y = 5;
	
	local questName
    local pc = GetMyPCObject();
    
    if questCls.QuestMode == 'REPEAT' then
        local sObj = GetSessionObject(pc, 'ssn_klapeda')
		if sObj ~= nil then
			if questCls.Repeat_Count ~= 0 then
				questName = questCls.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/{Auto_2})","Auto_1", sObj[questCls.QuestPropertyName..'_R'] + 1, "Auto_2",questCls.Repeat_Count)
			else
				questName = questCls.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/MuHan)","Auto_1", sObj[questCls.QuestPropertyName..'_R'])
			end
		end
	elseif questCls.QuestMode == 'PARTY' then
	    local sObj = GetSessionObject(pc, 'ssn_klapeda')
	    if sObj ~= nil then
	        questName = questCls.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/{Auto_2})","Auto_1", sObj.PARTY_Q_COUNT1 + 1, "Auto_2",CON_PARTYQUEST_DAYMAX1)
	    end
	end
	if questName == nil then
	    questName = questCls.Name
	end
	
	y = BOX_CREATE_RICHTEXT(box, "title", y, 20, "{@st41}"..questName);
	if questCls.ProgDesc == 'None' then
	    if questCls.EndDesc ~= 'None' then
        	y = BOX_CREATE_RICHTEXT(box, "questDesc", y, 20, "{@st66b}"..questCls.EndDesc);
        end
    else
        if questCls.ProgDesc == questCls.StartDesc then
            if questCls.EndDesc ~= 'None' then
                y = BOX_CREATE_RICHTEXT(box, "questDesc", y, 20, "{@st66b}"..questCls.EndDesc);
            end
        else
            if questCls.ProgDesc ~= 'None' then
                y = BOX_CREATE_RICHTEXT(box, "questDesc", y, 20, "{@st66b}"..questCls.ProgDesc);
            end
        end
    end
    
    local repeat_reward_item = {}
    local repeat_reward_achieve = {}
    local repeat_reward_achieve_point = {}
    local repeat_reward_exp = 0;
    local repeat_reward_npc_point = 0
    local repeat_reward_select = false
    local repeat_reward_select_use = false
    
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    
    repeat_reward_item, repeat_reward_achieve, repeat_reward_achieve_point, repeat_reward_exp, repeat_reward_npc_point, repeat_reward_select, repeat_reward_select_use = SCR_REPEAT_REWARD_CHECK(pc, questCls, cls, sObj)
    
	y = MAKE_TAKEITEM_CTRL(box, cls, y);
	y = MAKE_SELECT_REWARD_CTRL(box, y, cls);
	
    local reward_result = QUEST_REWARD_CHECK(questCls.ClassName)
    if #reward_result > 0 then
        y = y + 20;
    	y = BOX_CREATE_RICHTEXT(box, "t_addreward", y, 20, ScpArgMsg("Auto_{@st41}BoSang"));
    	y = MAKE_BASIC_REWARD_MONEY_CTRL(box, cls, y);
    	y = MAKE_BASIC_REWARD_BUFF_CTRL(box, cls, y);
    	y = MAKE_BASIC_REWARD_HONOR_CTRL(box, cls, y);
    	y = MAKE_BASIC_REWARD_PCPROPERTY_CTRL(box, cls, y);
    end
    
	local succExp = cls.Success_Exp;
	local succJobExp = 0;
	if repeat_reward_exp > 0 then
	    succExp = succExp + repeat_reward_exp
	end
	
    if succExp > 0 then
        succJobExp = succJobExp + math.floor(succExp * 77 /100)
    end
    
	if cls.Success_Lv_Exp > 0 then
        local xpIES = GetClass('Xp', pc.Lv)
        if xpIES ~= nil then
            local lvexpvalue =  math.floor(xpIES.QuestStandardExp * cls.Success_Lv_Exp)
            if lvexpvalue ~= nil and lvexpvalue > 0 and pc.Lv < PC_MAX_LEVEL then
	            succExp = succExp + lvexpvalue
            end
            local lvjobexpvalue =  math.floor(xpIES.QuestStandardJobExp * cls.Success_Lv_Exp)
            if lvjobexpvalue ~= nil and lvjobexpvalue > 0 and GetJobLv(pc) < 15 then
	            succJobExp = succJobExp + lvjobexpvalue
            end
        end
    end
    
	if succExp > 0 then
	    succExp = GET_COMMAED_STRING(succExp)
	    y = y + 5;
		y = BOX_CREATE_RICHTEXT(box, "t_successExp", y, 20, ScpArgMsg("Auto_{@st41}KyeongHeomChi_:_") .."{s20}{ol}{#FFFF00}"..succExp.."{/}", 10);	
		local tempY = y
		y = MAKE_QUESTINFO_REWARD_LVUP(box, questCls, 20, y, '{@st41b}')
		if tempY ~= y then
		    y = y - 5
		end
	end
	if succJobExp > 0 then
	    succJobExp = GET_COMMAED_STRING(succJobExp)
		y = BOX_CREATE_RICHTEXT(box, "t_successJobExp", y, 20, ScpArgMsg("SuccessJobExpGiveMSG1") .."{s20}{#FFFF00}"..  succJobExp.."{/}", 10);
		y = y + 10;
	end

	y = MAKE_BASIC_REWARD_ITEM_CTRL(box, cls, y);
	
	y = MAKE_BASIC_REWARD_RANDOM_CTRL(box, questCls, cls, y + 20)
    y = MAKE_REWARD_STEP_ITEM_CTRL(box, questCls, cls, y, 'SUCCESS')
    y = y + 10
	
    if cls.Success_RepeatComplete ~= 'None' then
    	y = MAKE_BASIC_REWARD_REPE_CTRL(box, questCls, cls, y + 20);
--    	y = y + 20
    end

	
	local cancelBtn = frame:GetChild('CancelBtn');
	local useBtn = frame:GetChild('UseBtn');

	    --[[
	box:Resize(box:GetWidth(), y);

	frame:ShowWindow(1);
	frame:Resize(frame:GetWidth(), box:GetY()+ box:GetHeight() + 20);
		]]
	box:Resize(box:GetWidth(), y);
	local maxSizeHeightFrame = box:GetY() + box:GetHeight() + 20;
	local maxSizeHeightWnd = ui.GetSceneHeight();
	if maxSizeHeightWnd < (maxSizeHeightFrame + 50) then 
		local margin = maxSizeHeightWnd/2;
		box:EnableScrollBar(1);
		box:Resize(box:GetWidth() + 15, margin - useBtn:GetHeight() - 40);
		box:SetScrollBar(margin - useBtn:GetHeight() - 40);
		box:InvalidateScrollBar();
		frame:Resize(frame:GetWidth() + 10, margin);
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
    
    local flag = false
    
    local dlgShowState = SCR_QUEST_SUCC_REWARD_DLG(pc, questCls, cls, sObj)
    
    if dlgShowState == 'DlgBefore' then
        if questCls.QuestEndMode ~= 'SYSTEM' and cls.Success_Move == 'None' and ((cls.Possible_NextNPC == 'SUCCESS' and cls.Success_Dialog1 ~= 'None') or cls.Possible_NextNPC ~= 'SUCCESS' or cls.Possible_SelectDialog1 ~= 'None') and (cls.Progress_PCLoopAnim == 'None' or cls.Progress_NextNPC ~= 'SUCCESS' or (cls.Progress_NextNPC == 'SUCCESS' and cls.Success_Dialog1 ~= 'None')) then
            local index
            for index = 1, 10 do
                if cls['Success_Dialog'..index] ~= 'None' then
                    flag = true
                    break
                end
            end
            if repeat_reward_select == false or (repeat_reward_select == true and repeat_reward_select_use == true) then
                for index = 1, MAX_QUEST_SELECTITEM do
                    if cls['Success_SelectItemName'..index] ~= 'None' then
                        flag = true
                        break
                    end
                end
            end
        end
    end
    
	if flag == false then
		useBtn:ShowWindow(0)
		cancelBtn:ShowWindow(0)
		control.DialogItemSelect(100);
		imcSound.PlaySoundEvent("quest_success_1");
		frame:SetUserValue("QUEST_REWARD_PC_CON_LOCK", 1);
		ReserveScript("AUTO_CLOSE_QUESTREWARD_FRAME()", 4);
	else
		useBtn:ShowWindow(1)
		local ItemBtn = frame:GetChild('UseBtn');
		local x, y = GET_SCREEN_XY(ItemBtn);
		mouse.SetPos(x,y);
		mouse.SetHidable(0);
	end

end

function AUTO_CLOSE_QUESTREWARD_FRAME()

	local frame = ui.GetFrame('questreward')
	frame:SetUserValue("QUEST_REWARD_PC_CON_LOCK", 0);
	frame:ShowWindow(0);
end

function CONFIRM_QUEST_REWARD(frame, ctrl, argStr, argNum)
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
		control.DialogItemSelect(selected);
	else
		control.DialogItemSelect(100);
	end
	frame = frame:GetTopParentFrame();
	frame:ShowWindow(0);
	imcSound.PlaySoundEvent("quest_success_1");
end

function QUESTREWARD_ON_LANGUAGECHANGE(frame)
	
	control.DialogItemSelect(0);
	
end

function QUESTREWARD_ON_ESCAPE(frame)
	if frame:IsVisible() == 1 then
		control.DialogItemSelect(0);
		frame:ShowWindow(0);
	end

end

function CANCEL_QUEST_REWARD(frame, ctrl, argStr, argNum)
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


function MAKE_MONEY_TAG_TEXT_CTRL(y, box, ctrlNameHead, itemCount, index)
	local txt = GET_MONEY_TAG_TXT(itemCount);
	local richTxt;
	y, richTxt = BOX_CREATE_RICH_CONTROLSET(box, ctrlNameHead .. index, y, 20, txt, index);
	return y;
end

function MAKE_ITEM_TAG_TEXT_CTRL(y, box, ctrlNameHead, itemName, itemCount, index)
	local cls = GetClass("Item", itemName);
	if cls == nil then
		return y;
	end
	
	local icon = GET_ITEM_ICON_IMAGE(cls);
	    
    y = y + 5
    
    chIndex = index
    
    while 1 do
        local check = GET_CHILD(box, ctrlNameHead .. chIndex);
        if check ~= nil then
            chIndex = chIndex + 1
        else
            break
        end
    end
    
	local ctrlSet = box:CreateOrGetControlSet('quest_reward', ctrlNameHead .. chIndex, 10, y);
	tolua.cast(ctrlSet, "ui::CControlSet");
	ctrlSet:SetValue(chIndex);
	ctrlSet:SetStretch(1);
	ctrlSet:Resize(box:GetWidth() - 20, ctrlSet:GetHeight());

	local itemCls = GetClass("Item", itemName);
	local slot = GET_CHILD(ctrlSet, "slot", "ui::CSlot");
	SET_SLOT_IMG(slot, icon);

	local itemNameCtrl = GET_CHILD(ctrlSet, "ItemName", "ui::CRichText");
	local itemText = " ";
	if itemCount < 0 then
		local invItem = session.GetInvItemByName(itemName);
		if invItem ~= nil then
		    itemText = ScpArgMsg("{Auto_1}ItemName{Auto_2}NeedCount", "Auto_1", itemCls.Name, "Auto_2", GetCommaedText(invItem.count));
		else
		    itemText = '{@st45w3}{s18}'..itemCls.Name..'{/}'
		end
	else
	    if itemName ~= 'Vis' then
			itemText = ScpArgMsg("{Auto_1}ItemName{Auto_2}NeedCount","Auto_1", itemCls.Name, "Auto_2",GetCommaedText(itemCount));
		else
    		itemText = ScpArgMsg("QuestRewardMoneyText", "Auto_1", GetCommaedText(itemCount));
    	end
    end
	itemNameCtrl:SetText(itemText);

	ctrlSet:SetEnableSelect(1);
	ctrlSet:SetSelectGroupName("QuestRewardList");
	ctrlSet:SetOverSound('button_cursor_over_2');
	SET_ITEM_TOOLTIP_BY_TYPE(ctrlSet, itemCls.ClassID);
	y = y + ctrlSet:GetHeight();
	return y;
end

function MAKE_RECIPE_TAG_TEXT_CTRL(y, box, ctrlNameHead, itemName, itemCount, index)
	local cls = GetClass("Recipe", itemName);
	if cls == nil then
		return y;
	end
	local wikiCls = GetClass("Wiki", cls.ClassName);
	if wikiCls == nil then
		return y;
	end

	local ctrlSet = box:CreateOrGetControlSet('quest_reward', ctrlNameHead .. index, 10, y);
	tolua.cast(ctrlSet, "ui::CControlSet");
	ctrlSet:SetValue(index);
	ctrlSet:SetStretch(1);
	ctrlSet:Resize(box:GetWidth() - 10, ctrlSet:GetHeight());

	local slot = ctrlSet:GetChild("slot");
	tolua.cast(slot, "ui::CSlot");
	SET_SLOT_IMG(slot, cls.Icon);

	local ItemName = ctrlSet:GetChild("ItemName");
	local itemText
	itemText = ScpArgMsg("Auto_{@st45w3}{s18}{Auto_1}_1Kae", "Auto_1",wikiCls.Name);
	ItemName:SetText(itemText);

	ctrlSet:SetEnableSelect(1);
	ctrlSet:SetSelectGroupName("QuestRewardList");
	ctrlSet:SetOverSound('button_cursor_over_2');
--	SET_ITEM_TOOLTIP_BY_TYPE(ctrlSet, itemCls.ClassID);

	y = y + ctrlSet:GetHeight();

	return y;
end

function MAKE_ACHIEVE_TAG_TEXT_CTRL(y, box, ctrlNameHead, achieveCls, index)

	local icon = achieveCls.Icon;
	local ctrlSet = box:CreateOrGetControlSet('quest_reward', ctrlNameHead .. index, 10, y);
	tolua.cast(ctrlSet, "ui::CControlSet");
	ctrlSet:SetValue(index);
	ctrlSet:SetStretch(1);
	ctrlSet:Resize(box:GetWidth() - 10, ctrlSet:GetHeight());

	local slot = ctrlSet:GetChild("slot");
	tolua.cast(slot, "ui::CSlot");
	SET_SLOT_IMG(slot, icon);

	local ItemName = ctrlSet:GetChild("ItemName");
	local itemText = string.format("{@st45tw3}{s18}%s", achieveCls.Name);

	ItemName:SetText(itemText);

	ctrlSet:SetEnableSelect(1);
	ctrlSet:SetSelectGroupName("QuestRewardList");
	--SET_ITEM_TOOLTIP_BY_TYPE(ctrlSet, itemCls.ClassID);

	y = y + ctrlSet:GetHeight();

	return y;
end

function MAKE_BUFF_TAG_TEXT_CTRL(y, box, ctrlNameHead, buffName, index)

	local txt = GET_BUFF_TAG_TXT(buffName);
	local richTxt;
	y = y + 5
	y, richTxt = BOX_CREATE_RICH_CONTROLSET(box, ctrlNameHead .. index, y, 20, txt, index);
	richTxt:EnableHitTest(1);
	SET_BUFF_TOOLTIP_BY_NAME(richTxt, buffName);

	return y;
end

function MAKE_PCPROPERTY_TAG_TEXT_CTRL(y, box, ctrlNameHead, propertyName, value, index)

	local txt = GET_PCPROPERTY_TAG_TXT(propertyName, value);
	local richTxt;
	y = y + 10
	y, richTxt = BOX_CREATE_RICH_CONTROLSET(box, ctrlNameHead .. index, y, 20, txt, index);
	richTxt:EnableHitTest(1);

	return y;
end

function MAKE_HONOR_TAG_TEXT_CTRL(y, box, ctrlNameHead, honorName, point_value, index)

	local txt = GET_HONOR_TAG_TXT(honorName, point_value);
	local richTxt;
	y, richTxt = BOX_CREATE_RICH_CONTROLSET(box, ctrlNameHead .. index, y, 20, txt, index);
	richTxt:EnableHitTest(1);

	return y;
end


function BOX_CREATE_RICH_CONTROLSET(box, name, y, height, text, index)

	local isOddCol = 0;
	if math.floor((index - 1) % 2) == 1 then
		isOddCol = 1;
	end

	local x = 10;
	if isOddCol == 1 then
		x = box:GetWidth() / 2;
		y = y - height - 10;
	end

	local newSet = box:CreateControlSet("richtxt", name, x + 10, y);
	local title = newSet:GetChild("text");
	title:SetText(text);

	return y + height, newSet;
end

function MAKE_TAKEITEM_CTRL(box, cls, y)
    y = y + 10
    
    local isuse = false
	local pc = GetMyPCObject();
    for i = 1 , MAX_QUEST_TAKEITEM do
        if cls["Success_TakeItemName" .. i] ~= "None" and ( cls["Success_TakeItemCount" .. i] > 0 or GetInvItemCount(pc, cls["Success_TakeItemName" .. i]) > 0) then
            isuse = true
            break
        end
    end
    
	local questCls = GetClassByType("QuestProgressCheck", cls.ClassID);
    local sObj_quest = GetSessionObject(pc, questCls.Quest_SSN) 
    if sObj_quest ~= nil and sObj_quest.SSNInvItem ~= 'None' then
        isuse = true
    end
    
	if isuse == true then
		y = BOX_CREATE_RICHTEXT(box, "need_item", y, 20, ScpArgMsg("QuestSuccessTakeItem"));
		for i = 1 , MAX_QUEST_TAKEITEM do
			local propName = "Success_TakeItemName" .. i;
			if cls[propName] ~= "None" then
			    if cls["Success_TakeItemCount" .. i] ~= -100 or GetInvItemCount(pc, cls[propName]) > 0 then
    				y = MAKE_ITEM_TAG_TEXT_CTRL(y, box, "need_Item", cls[propName], cls["Success_TakeItemCount" .. i], i);
    			end
			end
		end
		if sObj_quest ~= nil and sObj_quest.SSNInvItem ~= 'None' then
		    local itemList = SCR_STRING_CUT(sObj_quest.SSNInvItem, ':')
            local maxCount = math.floor(#itemList/3)
            for i = 1, maxCount do
                local InvItemName = itemList[i*3 - 2]
        		local itemclass = GetClass("Item", InvItemName);
        		if itemclass ~= nil then
            		local needcnt = itemList[i*3 - 1]
                    y = MAKE_ITEM_TAG_TEXT_CTRL(y, box, "need_Item", InvItemName, needcnt, i);
            	end
            end
		end
	end
	
	return y;
end

function MAKE_BASIC_REWARD_PCPROPERTY_CTRL(box, cls, y)
    local pcProperty = GetClass('reward_property', cls.ClassName)
    if pcProperty ~= nil then
        if pcProperty.Property ~= "AchievePoint" then
            y = MAKE_PCPROPERTY_TAG_TEXT_CTRL(y, box, "reward_PcProperty", pcProperty.Property, pcProperty.Value, 1);
        end
    end
    
	return y;
end

function MAKE_BASIC_REWARD_HONOR_CTRL(box, cls, y)
	local index = 0;

	if cls.Success_HonorPoint ~= "None" then
	    local honor_name, point_value = string.match(cls.Success_HonorPoint,'(.+)[/](.+)')
	    if honor_name ~= nil then
	        y = MAKE_HONOR_TAG_TEXT_CTRL(y, box, "reward_Honor", honor_name, point_value, 1);
	    end
	end

	return y;
end

function MAKE_BASIC_REWARD_RANDOM_CTRL(box, questCls, questAutoCls, y)
    local pc = GetMyPCObject();
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    if questAutoCls.Success_RandomReward ~= 'None' and GetPropType(sObj, questCls.QuestPropertyName..'_RR') ~= nil and sObj[questCls.QuestPropertyName..'_RR'] ~= 'None' then
        y = y + 10
        y = BOX_CREATE_RICHTEXT(box, "t_reward_random", y, 20, ScpArgMsg("DialogSelectRandomRewardTxt"));
        
        local randomReward = SCR_STRING_CUT(questAutoCls.Success_RandomReward)
        local randomRewardItem = SCR_STRING_CUT_COLON(sObj[questCls.QuestPropertyName..'_RR'])
        
        y = MAKE_ITEM_TAG_TEXT_CTRL(y, box, "reward_item_random", randomRewardItem[1], tonumber(randomRewardItem[2]), 0);
    	y = MAKE_RECIPE_TAG_TEXT_CTRL(y, box, "reward_item_random", randomRewardItem[1], tonumber(randomRewardItem[2]), 0);
    	y = y + 10
--    	local index = 1
--    	local lineflag = false
--    	for i = 1, #randomReward do
--    	    
--    	    local flag = false
--    	    if questAutoCls.Success_RandomExcept == 'YES' then
--        	    local history = SCR_STRING_CUT(sObj[questCls.QuestPropertyName..'_RRL'])
--        	    for x = 1, #history do
--        	        if tonumber(history[x]) == i then
--        	            flag = true
--        	            break
--        	        elseif  randomReward[i] == sObj[questCls.QuestPropertyName..'_RR'] then
--        	            flag = true
--        	            break
--        	        elseif #randomRewardItem >= 3 and i == randomRewardItem[3] then
--        	            flag = true
--        	            break
--        	        end
--        	    end
--        	else
--        	    if randomReward[i] == sObj[questCls.QuestPropertyName..'_RR'] then
--    	            flag = true
--    	        elseif #randomRewardItem >= 3 and i == randomRewardItem[3] then
--    	            flag = true
--    	        end
--        	end
--    	    
--    	    if flag == false then
--    	        local itemInfo = SCR_STRING_CUT_COLON(randomReward[i])
--    	        if lineflag == false then
--    	            y = BOX_CREATE_RICHTEXT(box, "t_reward_randomlist", y, 50, ScpArgMsg("DialogSelectRandomRewardListTxt"));
--    	        end
--    	        if string.find(randomReward[i], "SCR_QUEST_RANDOM_") ~= nil then
--    	            if itemInfo[1] == '' then
--    	            else
--    	                itemInfo = nil
--    	            end
--    	        end
--    	        if itemInfo ~= nil then
--        	        y = MAKE_ITEM_ICON_CTRL_QUEST(y, box, "randomlist", itemInfo[1], tonumber(itemInfo[2]), index);
--                    index = index + 1
--        	    end
--	            lineflag = true
--    	    end
--    	end
--    	
--    	if lineflag == true then
--    	    y = y + 80
--    	end
    end
    
    return y
end

function MAKE_ITEM_ICON_CTRL_QUEST(y, box, ctrlNameHead, itemName, itemCount, index)
    local recipeIES = GetClass("Recipe", itemName);
    local itemIES = GetClass("Item", itemName);
    local width = box:GetWidth() - 10
    if recipeIES ~= nil or itemIES ~= nil then
        local icon
        local classID
        if recipeIES ~= nil then
            icon = recipeIES.Icon
            classID = recipeIES.ClassID
        elseif itemIES ~= nil then
            icon = itemIES.Icon
            classID = itemIES.ClassID
        end
        local ctrlSet = box:CreateOrGetControlSet('quest_reward_itemicon', ctrlNameHead .. index, 10+((index%5 - 1) * 70), y);
    	tolua.cast(ctrlSet, "ui::CControlSet");
    	ctrlSet:SetValue(index);
    	ctrlSet:SetStretch(1);
    
    	local itemCls = GetClass("Item", itemName);
    	local slot = GET_CHILD(ctrlSet, "slot", "ui::CSlot");
    	SET_SLOT_IMG(slot, icon);
    	
    	if index % 5 == 0 then
    	    y = y + ctrlSet:GetHeight();
    	end
    	
--    	ctrlSet:SetEnableSelect(1);
--        ctrlSet:SetOverSound('button_cursor_over_2');
        ctrlSet:EnableHitTest(1);
    	SET_ITEM_TOOLTIP_BY_TYPE(ctrlSet, classID)
    end
	return y
end
function MAKE_BASIC_REWARD_REPE_CTRL(box, questCls, questAutoCls, y)
	local pc = GetMyPCObject();
	local sObj = GetSessionObject(pc, 'ssn_klapeda')
	if sObj ~= nil then
	    
    	local repeat_reward_item = {}
        local repeat_reward_achieve = {}
        local repeat_reward_achieve_point = {}
        local repeat_reward_exp = 0;
        local repeat_reward_npc_point = 0
        local repeat_reward_select = false
        local repeat_reward_select_use = false
        local money = 0
        
    	repeat_reward_item, repeat_reward_achieve, repeat_reward_achieve_point, repeat_reward_exp, repeat_reward_npc_point, repeat_reward_select, repeat_reward_select_use = SCR_REPEAT_REWARD_CHECK(pc, questCls, questAutoCls, sObj)
	    if #repeat_reward_item > 0 or #repeat_reward_achieve > 0 or #repeat_reward_achieve_point > 0 or repeat_reward_exp > 0 or repeat_reward_npc_point > 0 then
	        y = y + 10
	        y = BOX_CREATE_RICHTEXT(box, "t_reward_repeat", y, 20, ScpArgMsg("Auto_{@st41}ChuKa_BoSang{/}"));
	        y = y + 5
	        if #repeat_reward_item > 0 then
	            for i = 1, #repeat_reward_item do
	                if repeat_reward_item[i][2] ~= 'Vis' then
        				y = MAKE_ITEM_TAG_TEXT_CTRL(y, box, "reward_item_repeat", repeat_reward_item[i][2], repeat_reward_item[i][3], i);
        				y = MAKE_RECIPE_TAG_TEXT_CTRL(y, box, "reward_item_repeat", repeat_reward_item[i][2], repeat_reward_item[i][3], i);
        				y = y + 5
        			else
        			    money = money + repeat_reward_item[i][3]
        			end
	            end
	        end
	        
	        if #repeat_reward_achieve > 0 then
	            for i = 1, #repeat_reward_achieve do
	                local achieve = GetClass('Achieve', repeat_reward_achieve[i][2])
	                local txt = ScpArgMsg("RepeatRewardAchieve")..'{s20}{ol}{#FFFF00}'..achieve.Name
	                
	                y = BOX_CREATE_RICHTEXT(box, 'achieve'..i, y, 20, txt);
	                y = y + 5
	            end
	        end
	        
	        if #repeat_reward_achieve_point > 0 then
	            for i = 1, #repeat_reward_achieve_point do
	                local achievePoint = GetClass('AchievePoint', repeat_reward_achieve_point[i][2])
	                local txt = ScpArgMsg("RepeatRewardAchievePoint","Auto_1",achievePoint.Name,"Auto_2",repeat_reward_achieve_point[i][3])
	                
	                y = BOX_CREATE_RICHTEXT(box, 'achievePoint'..i, y, 20, txt);
	                y = y + 5
	            end
	        end
	        
	        if repeat_reward_exp > 0 then
	            y = BOX_CREATE_RICHTEXT(box, "exp_repeat", y, 20, ScpArgMsg("Auto_{@st41}KyeongHeomChi_:_") .."{s20}{ol}{#FFFF00}"..  repeat_reward_exp.."{/}");
	            y = y + 5
	        end
	        
	        if repeat_reward_npc_point > 0 then
	            y = BOX_CREATE_RICHTEXT(box, "npcpoint_repeat", y, 20, ScpArgMsg("RepeatRewardNPCPoint") .."{s20}{ol}{#FFFF00}"..  repeat_reward_npc_point.."{/}");
	            y = y + 5
	        end
	        
	        if money > 0 then
	            y = MAKE_MONEY_TAG_TEXT_CTRL(y, box, "money_Item_repeat", money, 1);
	            y = y + 10
	        end
	    end
	end
	return y;
end

function MAKE_BASIC_REWARD_MONEY_CTRL(box, cls, y)
	local count = 0;

	if cls.Success_ItemName1 ~= "None" then
		for i = 1 , MAX_QUEST_TAKEITEM do
			local propName = "Success_ItemName" .. i;
			if cls[propName] ~= "None" and cls[propName] == 'Vis' then
				count = count + tonumber(cls["Success_ItemCount" .. i])
			end
		end
	end
    
    if count > 0 then
        y = MAKE_ITEM_TAG_TEXT_CTRL(y, box, "reward_item", 'Vis', count, 1);
    end
	return y;
end

function MAKE_BASIC_REWARD_ITEM_CTRL(box, cls, y)
    local MySession		= session.GetMyHandle();
	local MyJobNum		= info.GetJob(MySession);
	local JobName		= GetClassString('Job', MyJobNum, 'ClassName');
	local index = 0
	local job = SCR_JOBNAME_MATCHING(JobName)
	local pc = GetMyPCObject();

	local isItem = 0;
	if cls.Success_ItemName1 ~= "None" or cls.Success_JobItem_Name1 ~= "None" then
		for i = 1 , MAX_QUEST_TAKEITEM do
			local propName = "Success_ItemName" .. i;
			if cls[propName] ~= "None" and cls[propName] ~= "Vis" then
				y = MAKE_ITEM_TAG_TEXT_CTRL(y, box, "reward_item", cls[propName], cls["Success_ItemCount" .. i], i);
				index = index + 1
				isItem = 1;
			end
		end

        for i = 1, 20 do
            if cls['Success_JobItem_Name'..i] ~= 'None' and cls['Success_JobItem_JobList'..i] ~= 'None' then
                local jobList = SCR_STRING_CUT(cls['Success_JobItem_JobList'..i])
                if SCR_Q_SUCCESS_REWARD_JOB_GENDER_CHECK(pc, jobList, job, pc.Gender, cls.Success_ChangeJob) == 'YES' then
                    local propName = 'Success_JobItem_Name'..i

                    y = MAKE_ITEM_TAG_TEXT_CTRL(y, box, "reward_item", cls[propName], cls["Success_JobItem_Count" .. i], index + i);
        			isItem = 1;
                end
            end
        end
	end

	local frame 	= ui.GetFrame('questreward');
	local cancelBtn = frame:GetChild('CancelBtn');
	local useBtn = frame:GetChild('UseBtn');

	if isItem == 0 then
		cancelBtn:ShowWindow(0);
		useBtn:SetGravity(ui.CENTER_HORZ, ui.BOTTOM);
        useBtn:SetOffset(0, 40);

	else
		cancelBtn:ShowWindow(1);
		useBtn:SetGravity(ui.CENTER_HORZ, ui.BOTTOM);
        useBtn:SetOffset(-85, 40);
	end

	return y;
end


function MAKE_BASIC_REWARD_BUFF_CTRL(box, cls, y)

	if cls.Success_Buff1 ~= "None" then
		for i = 1 , MAX_QUEST_TAKEITEM do
			local propName = "Success_Buff" .. i;
			if cls[propName] ~= "None" then
				local sList = StringSplit(cls[propName], "/");
				y = MAKE_BUFF_TAG_TEXT_CTRL(y, box, "reward_buff", sList[1], i);
			end
		end
	end

	return y;
end


function MAKE_SELECT_REWARD_CTRL(box, y, questCls, callFunc)
    if questCls.Success_SelectItemName1 == "None" then
		return y;
	end
	
    local questIES = GetClassByType("QuestProgressCheck", questCls.ClassID);
    local pc = GetMyPCObject();
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    
    local repeat_reward_item = {}
    local repeat_reward_achieve = {}
    local repeat_reward_achieve_point = {}
    local repeat_reward_exp = 0;
    local repeat_reward_npc_point = 0
    local repeat_reward_select = false
    local repeat_reward_select_use = false
        
    
    repeat_reward_item, repeat_reward_achieve, repeat_reward_achieve_point, repeat_reward_exp, repeat_reward_npc_point, repeat_reward_select, repeat_reward_select_use  = SCR_REPEAT_REWARD_CHECK(pc, questIES, questCls, sObj)
    if repeat_reward_select == false or (repeat_reward_select == true and repeat_reward_select_use == true) then
        if callFunc == 'DIALOGSELECT_QUEST_REWARD_ADD' then
            y = BOX_CREATE_RICHTEXT(box, "t_selreward", y, 20, ScpArgMsg("Auto_{@st54}BoSang_SeonTaeg"));
        else
        	y = BOX_CREATE_RICHTEXT(box, "t_selreward", y, 20, ScpArgMsg("Auto_{@st41}BoSang_SeonTaeg"));
        end
    
    	for i = 1, MAX_QUEST_SELECTITEM do
    		local propName = "Success_SelectItemName" .. i;
    		local itemName = questCls[propName];
    		if itemName == "None" then
    			break;
    		end
    
    		local itemCnt = questCls[ "Success_SelectItemCount" .. i];
    		y = CREATE_QUEST_REWARE_CTRL(box, y, i, itemName, itemCnt, callFunc);
    	end
    end

	return y;

end

function CREATE_QUEST_REWARE_CTRL(box, y, index, ItemName, itemCnt, callFunc)
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
	
	local ctrlSet = box:CreateControlSet('quest_reward_s', "REWARD_" .. index, x, y);
	tolua.cast(ctrlSet, "ui::CControlSet");
	ctrlSet:SetValue(index);
	
	if callFunc == 'DIALOGSELECT_QUEST_REWARD_ADD' then
	    ctrlSet:Resize(box:GetHeight() + 70,ctrlSet:GetHeight())
	end

	local itemCls = GetClass("Item", ItemName);
	local slot = ctrlSet:GetChild("slot");
	tolua.cast(slot, "ui::CSlot");
	SET_SLOT_IMG(slot, itemCls.Icon);

	local ItemName = ctrlSet:GetChild("ItemName");
	local itemText = string.format("{@st41b}%s x%d", itemCls.Name, itemCnt);
	ItemName:SetText(itemText);

	ctrlSet:SetOverSound("button_cursor_over_3");
	ctrlSet:SetClickSound("button_click_stats");
	ctrlSet:SetEnableSelect(1);
	ctrlSet:SetSelectGroupName("QuestRewardList");
	SET_ITEM_TOOLTIP_BY_TYPE(ctrlSet, itemCls.ClassID);

	ctrlSet:Resize(box:GetWidth() - 30, ctrlSet:GetHeight());

	y = y + ctrlSet:GetHeight();
	return y;

end

function BOX_CREATE_RICHTEXT(box, name, y, height, text, marginX)
    if marginX == nil then
        marginX = 0
    end
	local title = box:CreateControl("richtext", name, 10 + marginX, y, box:GetWidth() - 30, height);
	tolua.cast(title, "ui::CRichText");
	title:SetTextFixWidth(1);
	title:SetText(text.."{/}");
	return y + title:GetHeight(), title;
end

function ON_QUEST_ITEM_SELECT(frame, msg, str, num)
	local sObj = session.GetSessionObjectByName("ssn_guildquest");
	if sObj == nil then
		return nil;
	end

	local obj = GetIES(sObj:GetIESObject());
	if obj.Step25 == 0 then
		return nil;
	end

	local cls = GetClassByType("GuildQuest", obj.Step25);
	if cls == nil then
		return nil;
	end

	local box = frame:GetChild("box");
	tolua.cast(box, "ui::CGroupBox");

	box:DeleteAllControl();

	local ctrlwidth =  ui.GetControlSetAttribute('itemselect', 'width') + 50;
	local y = 5;
	y = BOX_CREATE_RICHTEXT(box, "title", y, 20, "{@st41}"..cls.Title.."{/}");

	local condtext = GET_GUILDQUEST_COND(cls, obj);
	if condtext ~= "" then
		y = BOX_CREATE_RICHTEXT(box, "guildquestcond", y, 20, "{@st41b}"..condtext.."{/}");
	end
	local reqText = GET_GUILDQUEST_REQ(cls, obj);
	if reqText ~= "" then
		y = BOX_CREATE_RICHTEXT(box, "guildreq", y, 20, "{@st41b}"..reqText.."{/}");
	end

	y = y + 30;
	y = BOX_CREATE_RICHTEXT(box, "t_addreward", y, 20, ScpArgMsg("Auto_{@st41}BoSang{/}"));

	if cls.RewardItem ~= "None" then
		local item = GetClass("Item", cls.RewardItem);
		local itemcount = math.floor(cls.RewardCount * ( 100 + obj.Step24 ) / 100);
		desc = GET_MONEY_REWARD_TXT(item, itemcount);
		y = BOX_CREATE_RICHTEXT(box, "guildMoney", y, 20, ScpArgMsg("WillReceiveReward")..desc.."{/}");
	end

	local expamount = cls.ExpAmount;
	
    local pc = GetMyPCObject();
    
	if pc.Lv < PC_MAX_LEVEL and expamount > 0 then
		local fixexp  = math.floor(expamount * ( 100 + obj.Step24 ) / 100);
		y = BOX_CREATE_RICHTEXT(box, "t_successExp", y, 20, ScpArgMsg("Auto_{@st41}KyeongHeomChi_:_") .."{s20}{ol}{#FFFF00}"..  fixexp.."{/}");
		
		if session.GetMaxEXP() - session.GetEXP() - fixexp <= 0 then
            local content = box:CreateOrGetControl('richtext', 'QUESTINFOREWARDLVUP', 10, y, box:GetWidth() , 10);
        	content:EnableHitTest(0);
        	content:SetTextFixWidth(0);
        	content:SetText(ScpArgMsg('QUESTINFOREWARDLVUP','Auto_1',pc.Lv + 1));
        	y = y + content:GetHeight()+5;
        end
	end

	local list = session.GetSelectItemList();
	local cnt = list:Count();

	local width = 200;
	if cnt > 1 then
		y = y + 5;
		y = BOX_CREATE_RICHTEXT(box, "guildSelectItem", y, 20, ScpArgMsg('Auto_{@st41b}BoSangeul_SeonTaegHaSipSio_:_{/}'));
		width = 400;
	end

	local x = 10;

	for i = 0 , cnt - 1 do
		local info = list:Element(i);
		y = SELECTITEM_CRE_CTRL_SET(box, x, y, info, i + 1);
	end

	y = y + 100;

	local cancelBtn = frame:GetChild('CancelBtn');
	local useBtn = frame:GetChild('UseBtn');

	if cnt == 0 then
		cancelBtn:ShowWindow(0);
        useBtn:SetOffset(0, -30);
		useBtn:SetGravity(ui.CENTER_HORZ, ui.BOTTOM);
	else
		cancelBtn:ShowWindow(1);
        useBtn:SetOffset(-60, -30);
		useBtn:SetGravity(ui.CENTER_HORZ, ui.BOTTOM);
	end

	box:Resize(box:GetWidth(), box:GetHeight());
	frame:Resize(width, y);

	frame:ShowWindow(1);
end

function SELECTITEM_CRE_CTRL_SET(box, x, y, info, index)
	if index % 2 == 0 then
		x = x + 150;
	end

	local cls = GetIES(info:GetObject());
	local set = box:CreateControlSet('quest_reward_s', "REWARD_" .. index , x, y);
	tolua.cast(set, "ui::CControlSet");
	set:SetValue(info.index);

	local slot = set:GetChild("slot");
	tolua.cast(slot, "ui::CSlot");
	local imgName = GET_ICON_BY_NAME(cls.ClassName);
	SET_SLOT_IMG(slot, imgName);

	local name = set:GetChild("ItemName");
	name:SetText(GET_FULL_NAME(cls));

	set:SetEnableSelect(1);
	set:SetSelectGroupName("QuestRewardList");

	set:Resize(box:GetWidth() - 20, set:GetHeight());
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, info, cls.ClassName, 'select', info.type, info.index);

	if index % 2 == 0 then
		y = y + set:GetHeight();
	end

	return y;
	-----------------------------------------
	--[[local cls = GetClass("Item", itemName);
	local icon = cls.Icon;

	local ctrlSet = box:CreateControlSet('quest_reward', ctrlNameHead .. index, 4, y);
	tolua.cast(ctrlSet, "ui::CControlSet");
	ctrlSet:SetValue(index);

	local itemCls = GetClass("Item", itemName);
	local slot = ctrlSet:GetChild("slot");
	tolua.cast(slot, "ui::CSlot");
	SET_SLOT_IMG(slot, "icon_" .. itemCls.Icon);

	local ItemName = ctrlSet:GetChild("ItemName");
	local itemText = ScpArgMsg("Auto_{s18}{ol}{Auto_1}_{Auto_2}_Kae","Auto_1", itemCls.Name, "Auto_2",itemCount);
	ItemName:SetText(itemText);

	ctrlSet:SetEnableSelect(1);
	ctrlSet:SetSelectGroupName("QuestRewardList");
	SET_ITEM_TOOLTIP_BY_TYPE(ctrlSet, itemCls.ClassID);

	y = y + ctrlSet:GetHeight();

	return y;]]--

end

function SELECTITEM_SELECT(frame, ctrl, str, id)

	control.DialogItemSelect(id);
end


function QUEST_REWARD_CHECK(questname)
    local cls = GetClass("QuestProgressCheck_Auto", questname)
    local result = {}
    local pc = GetMyPCObject();
    local MySession		= session.GetMyHandle();
	local MyJobNum		= info.GetJob(MySession);
	local JobName		= GetClassString('Job', MyJobNum, 'ClassName');
	local job = SCR_JOBNAME_MATCHING(JobName)

--    if cls.Success_Exp > 0 then
--        flag[#flag + 1] = 'Exp'
--    end

    for i = 1, 4 do
        if cls['Success_ItemName'..i] ~= 'None' then
            result[#result + 1] = 'Item'
            break
        end
    end
    
    for i = 1, 20 do
        if cls['Success_JobItem_Name'..i] ~= 'None' and cls['Success_JobItem_JobList'..i] ~= 'None' then
            local jobList = SCR_STRING_CUT(cls['Success_JobItem_JobList'..i])
            if SCR_Q_SUCCESS_REWARD_JOB_GENDER_CHECK(pc, jobList, job, pc.Gender, cls.Success_ChangeJob) == 'YES' then
                result[#result + 1] = 'JobItem'
            end
        end
    end

    for i = 1, 4 do
        if cls['Success_Buff'..i] ~= 'None' then
            result[#result + 1] = 'Buff'
            break
        end
    end

    if cls.Success_HonorPoint ~= 'None' then
        result[#result + 1] = 'HonorPoint'
    end
    
    local pcProperty = GetClass('reward_property', questname)
    if pcProperty ~= nil then
        result[#result + 1] = 'PCProperty'
    end

    return result
end


