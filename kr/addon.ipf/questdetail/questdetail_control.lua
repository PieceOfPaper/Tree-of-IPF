-- questdetial_control.lua

-- 리치텍스트.
function QUESTDETAIL_BOX_CREATE_RICHTEXT(baseCtrl, x, y, width, height, name, text, prop) 
	local title = baseCtrl:CreateControl("richtext", name, x, y, width, height);
	tolua.cast(title, "ui::CRichText");
	
	if prop ~= nil then
		if prop.text_align ~= nil then
			title:SetTextAlign(prop.text_align.horz,prop.text_align.vert );
		end
	end

	title:SetTextFixWidth(1);
	title:SetText(text.."{/}");
	return title:GetHeight()
end

-- 리치 컨트롤셋
function QUESTDETAIL_BOX_CREATE_RICH_CONTROLSET(baseCtrl, x, y, width, height, name, text, prop)
 
	if prop.index ~= nil then
		local index = prop.index;
		local isOddCol = 0;
		if math.floor((index - 1) % 2) == 1 then
			isOddCol = 1;
		end

		local x = 10;
		if isOddCol == 1 then
			x = baseCtrl:GetWidth() / 2;
			y = y - height - 10;
		end
	end
  --
	
	local newSet = baseCtrl:CreateControlSet("richtxt", name, x, y);
	local title = newSet:GetChild("text");
	title:SetText(text);
	newSet:Resize(newSet:GetOriginalWidth(), title:GetHeight());

	return newSet:GetHeight(), newSet ;

end

-- 태그 텍스트 컨트롤
function QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(baseCtrl, x, y, name, itemName, itemCount, index, prop) 
	local cls = GetClass("Item", itemName);
	if cls == nil then
		return 0;
	end

	local height = 0;
	local icon = GET_ITEM_ICON_IMAGE(cls);
	local chIndex = index;
	
    while 1 do
        local check = GET_CHILD(baseCtrl, name .. chIndex);
        if check ~= nil then
            chIndex = chIndex + 1
        else
            break
        end
	end

	local ctrlSet = baseCtrl:CreateOrGetControlSet('quest_reward', name .. chIndex, x, y);
	tolua.cast(ctrlSet, "ui::CControlSet");
	ctrlSet:SetValue(chIndex);
	ctrlSet:SetStretch(1);
	ctrlSet:Resize(baseCtrl:GetWidth() - 30, ctrlSet:GetHeight());

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
	return ctrlSet:GetHeight();
end

-- 레시피 태그 텍스트 컨트롤
function QUESTDETAIL_MAKE_RECIPE_TAG_TEXT_CTRL(baseCtrl, x, y, name, itemName, itemCount, index, prop)
	local cls = GetClass("Recipe", itemName);
	if cls == nil then
		return 0;
	end

	local wikiCls = GetClass("Wiki", cls.ClassName);
	if wikiCls == nil then
		return 0;
	end

	local height = 0;

	local ctrlSet = baseCtrl:CreateOrGetControlSet('quest_reward', name .. index, x, y);
	tolua.cast(ctrlSet, "ui::CControlSet");
	ctrlSet:SetValue(index);
	ctrlSet:SetStretch(1);
	ctrlSet:Resize(baseCtrl:GetWidth() - 10, ctrlSet:GetHeight());

	local slot = ctrlSet:GetChild("slot");
	tolua.cast(slot, "ui::CSlot");
	SET_SLOT_IMG(slot, cls.Icon);

	local ItemName = ctrlSet:GetChild("ItemName");
	local itemText = "";
	itemText = ScpArgMsg("Auto_{@st45w3}{s18}{Auto_1}_1Kae", "Auto_1",wikiCls.Name);
	ItemName:SetText(itemText);

	ctrlSet:SetEnableSelect(1);
	ctrlSet:SetSelectGroupName("QuestRewardList");
	ctrlSet:SetOverSound('button_cursor_over_2');

	return ctrlSet:GetHeight();
end

-- 실버 태그 텍스트 컨트롤
function QUESTDETAIL_MAKE_MONEY_TAG_TEXT_CTRL(baseCtrl, x, y, name, itemCount, _index)
	local txt = GET_MONEY_TAG_TXT(itemCount);
	local height, rich_text = QUESTDETAIL_BOX_CREATE_RICH_CONTROLSET(baseCtrl, x, y, 0, 20, name .. _index, txt, { index = _index});
	return height;
end

-- 칭호 태그 텍스트 컨트롤
function QUESTDETAIL_MAKE_HONOR_TAG_TEXT_CTRL(baseCtrl, x, y, name, itemName, itemCount, _index, prop)

	local txt = GET_HONOR_TAG_TXT(itemName, itemCount);
	local height, rich_text = QUESTDETAIL_BOX_CREATE_RICH_CONTROLSET(baseCtrl, x, y, 0, 20, name .. _index, txt, { index = _index});
	rich_text:EnableHitTest(1);
	return height;
end

-- 버튼 컨트롤
function QUESTDETAIL_BOX_CREATE_BUTTON(baseCtrl, x, y, width, height, name, text, prop) 
	local makeBtn = baseCtrl:CreateControl('button', name, x, y, width,height);
    if makeBtn == nil then
        return 0;
    end
    
    tolua.cast(makeBtn, 'ui::CButton');

	if prop.gravity ~= nil then
        makeBtn:SetGravity(prop.gravity.horz, prop.gravity.vert);
    else
        makeBtn:SetGravity(ui.LEFT, ui.TOP);
    end
	
	if prop.margin ~= nil then
		makeBtn:SetMargin(prop.margin[1], prop.margin[2], prop.margin[3], prop.margin[4]);
	else 
		makeBtn:SetMargin(0,0,0,0);
	end

    makeBtn:SetText(text);
    
    if prop.skinName ~= nil then
        makeBtn:SetSkinName( prop.skinName);
    else
        makeBtn:SetSkinName("test_gray_button");
    end

    if prop.tooltip ~= nil then
        makeBtn:SetTooltipType(prop.tooltip.type);
        makeBtn:SetTooltipArg(prop.tooltip.arg);
    end

	if prop.eventScript ~= nil then
		-- down
        if prop.eventScript.LBtnDownScp ~= nil then
            makeBtn:SetEventScript(ui.LBUTTONDOWN, prop.eventScript.LBtnDownScp);
        end
        if prop.eventScript.LBtnDownScpArgNumber ~= nil then
            makeBtn:SetEventScriptArgNumber(ui.LBUTTONDOWN, prop.eventScript.LBtnDownScpArgNumber);
		end
		if prop.eventScript.LBtnDownScpArgString ~= nil then
            makeBtn:SetEventScriptArgString(ui.LBUTTONDOWN, prop.eventScript.LBtnDownScpArgString);
		end
		-- up
		if prop.eventScript.LBtnUpScp ~= nil then
			makeBtn:SetEventScript(ui.LBUTTONUP, prop.eventScript.LBtnUpScp);
		end
		if prop.eventScript.LBtnUpScpArgNumber ~= nil then
            makeBtn:SetEventScriptArgNumber(ui.LBUTTONUP, prop.eventScript.LBtnUpScpArgNumber);
		end
		if prop.eventScript.LBtnUpScpArgString ~= nil then
            makeBtn:SetEventScriptArgString(ui.LBUTTONUP, prop.eventScript.LBtnUpScpArgString);
		end

    end

	makeBtn:SetOverSound('button_over');
	makeBtn:SetClickSound('button_click_big');

	return makeBtn:GetHeight();
end
--------------

function QUESTDETAIL_CREATE_QUEST_REWARD_CTRL(baseCtrl, x, y, itemName, itemCount, index, prop)
	
	local ctrlSet = baseCtrl:CreateControlSet('quest_reward_s', "REWARD_" .. index, x, y);
	tolua.cast(ctrlSet, "ui::CControlSet");
	ctrlSet:SetValue(index);
	
	local itemCls = GetClass("Item", itemName);
	local slot = ctrlSet:GetChild("slot");
	tolua.cast(slot, "ui::CSlot");
	SET_SLOT_IMG(slot, itemCls.Icon);

	local ItemName = ctrlSet:GetChild("ItemName");
	local itemText = string.format("{@st41b}%s x%d", itemCls.Name, itemCount);
	ItemName:SetText(itemText);

	ctrlSet:SetOverSound("button_cursor_over_3");
	ctrlSet:SetClickSound("button_click_stats");
	ctrlSet:SetEnableSelect(1);
	ctrlSet:SetSelectGroupName("QuestRewardList");
	SET_ITEM_TOOLTIP_BY_TYPE(ctrlSet, itemCls.ClassID);

	ctrlSet:Resize(baseCtrl:GetWidth() - 30, ctrlSet:GetHeight());
	
	return ctrlSet:GetHeight();
end


-----------

-- 보상 - 필요 아이템
function QUESTDETAIL_MAKE_REWARD_TAKE_CTRL(gbBody, x, y, questIES)
	local cls = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
	local flag = false;
	if cls.Quest_SSN ~= 'None' then
		local pc = GetMyPCObject();
		local sObj_quest = GetSessionObject(pc, cls.Quest_SSN)
		if sObj_quest ~= nil and sObj_quest.SSNInvItem ~= 'None' then
			flag = true
		end
	end

	local height = 0;

	if cls.Succ_InvItemName1 ~= "None" or cls.Succ_EqItemName1 ~= "None" or flag == true then
		height =  height + QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x, y + height, gbBody:GetWidth() - 30, 20, "need_item",ScpArgMsg("Auto_{@st41}Pilyo_aiTem"));

	   for i = 1 , QUEST_MAX_INVITEM_CHECK do
		   local propName = "Succ_InvItemName" .. i;
		   if cls[propName] ~= "None" then
			   height = height + QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(bgBody, x, y + heihgt, "need_Item", cls[propName], cls["Succ_InvItemCount" .. i], i);
		   end
	   end
	   
	   for i = 1 , QUEST_MAX_EQUIP_CHECK do
		   local propName = "Succ_EqItemName" .. i;
		   if cls[propName] ~= "None" then
				height = height + QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(bgBody, x, y + heihgt, "need_Item",  cls[propName], 1, i);
		   end
	   end
	   
	   if cls.Quest_SSN ~= 'None' then
		   if sObj_quest ~= nil and sObj_quest.SSNInvItem ~= 'None' then
			   local itemList = SCR_STRING_CUT(sObj_quest.SSNInvItem, ':')
			   local maxCount = math.floor(#itemList/3)
			   for i = 1, maxCount do
				   local InvItemName = itemList[i*3 - 2]
				   local needcnt = itemList[i*3 - 1]
				   local itemclass = GetClass("Item", InvItemName);
				   if itemclass ~= nil then
						height = height + QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(bgBody, x, y + heihgt, "need_Item",  InvItemName, needcnt, i);
				   end
			   end
		   end
	   end
   end

   return height;
end

-- 보상 - 선택 아이템
function QUESTDETAIL_MAKE_SELECT_REWARD_CTRL(gbBody, x, y, questIES)
	
	local questAutoCls = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
	if questAutoCls.Success_SelectItemName1 == "None" then
		return 0;
	end
	
	local pc = GetMyPCObject();
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    
    local repeat_reward_item = {}
    local repeat_reward_achieve = {}
    local repeat_reward_achieve_point = {}
    local repeat_reward_exp = 0;
    local repeat_reward_npc_point = 0
    local repeat_reward_select = false
    local repeat_reward_select_use = false
	
	repeat_reward_item, repeat_reward_achieve, repeat_reward_achieve_point, repeat_reward_exp, repeat_reward_npc_point, repeat_reward_select, repeat_reward_select_use  = SCR_REPEAT_REWARD_CHECK(pc, questIES, questAutoCls, sObj)

	local height = 0;
    
    if repeat_reward_select == false or (repeat_reward_select == true and repeat_reward_select_use == true) then
		
		local topFrame = gbBody:GetTopParentFrame();
        local titleText = topFrame:GetUserConfig('QUEST_SELECT_REWARD_TEXT');
        if titleText == nil then
			titleText =  ScpArgMsg("Auto_{@st41}BoSang_SeonTaeg")
		end
		
		height = height +  QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x, y + height, gbBody:GetWidth() - 30 ,20, "t_selreward", titleText);
		
		for i = 1, MAX_QUEST_SELECTITEM do
    		local propName = "Success_SelectItemName" .. i;
    		local itemName = questAutoCls[propName];
    		if itemName == "None" then
    			break;
    		end
    
			local itemCnt = questAutoCls[ "Success_SelectItemCount" .. i];
			height = height + QUESTDETAIL_CREATE_QUEST_REWARD_CTRL(gbBody, x, y+height, itemName, itemCnt, i)
    	end
    end

	return height;

end

-- 보상 - 실버 정보
function QUESTDETAIL_MAKE_REWARD_MONEY_CTRL(gbBody, x, y, questIES)
	local cls = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
	
	local height = 0;
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
		height = height + QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(gbBody, x, y + height, "reward_item", 'Vis', count, 1);
	end
	
	return height;
end

-- 보상 - 버프 정보
function QUESTDETAIL_MAKE_REWARD_BUFF_CTRL(gbBody, x, y, questIES)
	local cls = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
	local height = 0;
	
	if cls.Success_Buff1 ~= "None" then
		for i = 1 , MAX_QUEST_TAKEITEM do
			local propName = "Success_Buff" .. i;
			if cls[propName] ~= "None" then
				local sList = StringSplit(cls[propName], "/");
				height = height + QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(gbBody, x, y + height, "reward_buff", sList[1], i);
			end
		end
	end

	return height;
end

-- 보상 - 칭호 정보
function QUESTDETAIL_MAKE_REWARD_HONOR_CTRL(gbBody, x, y, questIES)
	local cls = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
	local height = 0;
	local index = 0;

	if cls.Success_HonorPoint ~= "None" then
	    local honor_name, point_value = string.match(cls.Success_HonorPoint,'(.+)[/](.+)')
		if honor_name ~= nil then
			height = height + QUESTDETAIL_MAKE_HONOR_TAG_TEXT_CTRL(gbBody, x, y + height, "reward_Honor", honor_name, point_value, 1);
	    end
	end

	return height;
end

-- 보상 - 프로퍼티(업적,스탯등)
function QUESTDETAIL_MAKE_REWARD_PCPROPERTY_CTRL(gbBody, x, y, questIES)
	local cls = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
	local height = 0;
	local pcProperty = GetClass('reward_property', cls.ClassName);
    if pcProperty ~= nil then
		if pcProperty.Property ~= "AchievePoint" then
			height = height + QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(gbBody, x, y + height, "reward_PcProperty", pcProperty.Property, pcProperty.Value, 1);
        end
	elseif cls.Success_StatByBonus > 0 then
		height = height + QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(gbBody, x, y + height, "reward_PcProperty", 'StatByBonus', cls.Success_StatByBonus, 1);
    end
    
	return height;
end

-- 보상 - journy.... 
function QUESTDETAIL_MAKE_REWARD_JOURNEYSHOP_CTRL(gbBody, x, y, questIES)
	local cls = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
	local height = 0;
	local marginY = 5;
	local journeyShop = GetClass('reward_property', 'JS_Quest_Reward_'..cls.ClassName)
    if journeyShop ~= nil then
        for i = 1, 5 do
			if journeyShop['RewardItem'..i] ~= 'None' then
				height = marginY + height + QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(gbBody, x, y + height,  "reward_JourneyShop", journeyShop['RewardItem'..i], journeyShop['RewardCount'..i], i);
            end
        end
    end
    
	return height;
end

-- 보상 - 경험치
function  QUESTDETAIL_MAKE_EXP_REWARD_CTRL(gbBody, x, y, questIES)
	
	local cls = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
	local pc = GetMyPCObject();
	local sObj = GetSessionObject(pc, 'ssn_klapeda')
	local repeat_reward_item = {}
    local repeat_reward_achieve = {}
    local repeat_reward_achieve_point = {}
    local repeat_reward_exp = 0;
    local repeat_reward_npc_point = 0
    local repeat_reward_select = false
    local repeat_reward_select_use = false
	
	repeat_reward_item, repeat_reward_achieve, repeat_reward_achieve_point, repeat_reward_exp, repeat_reward_npc_point, repeat_reward_select, repeat_reward_select_use = SCR_REPEAT_REWARD_CHECK(pc, questIES, cls, sObj)
	
	local height = 0;
	
	-- 경험치 보상 계산
	local succExp = cls.Success_Exp;
	local succJobExp = 0;
	if repeat_reward_exp > 0 then
	    succExp = succExp + repeat_reward_exp
	end
	
	local sumvalue = MultForBigNumberInt64(tostring(succExp), tostring(77));
	sumvalue = DivForBigNumberInt64(tostring(sumvalue), tostring(100));
    if succExp > 0 then
		succJobExp = tonumber(SumForBigNumberInt64(succJobExp, sumvalue));
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
	
	-- 경험치 보상
	if succExp > 0 then
		succExp = GET_COMMAED_STRING(succExp)
		local marginX = 10;
		height = height + QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x + marginX, y + height, gbBody:GetWidth() - 30 ,20, "t_successExp", ScpArgMsg("Auto_{@st41}KyeongHeomChi_:_") .."{s20}{ol}{#FFFF00}"..  succExp.."{/}");

		marginX = 20;
		height = height + QUESTDETAIL_MAKE_QUESTINFO_REWARD_LVUP(gbBody, x + marginX, y+height, questIES, { font = '{@st41b}'});
	end

	-- 잡 경험치 보상
	if succJobExp > 0 then
		succJobExp = GET_COMMAED_STRING(succJobExp)
		local marginX = 10;
		height = height + QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x + marginX, y + height, gbBody:GetWidth() - 30 ,20, "t_successJobExp",  ScpArgMsg("SuccessJobExpGiveMSG1") .."{s20}{#FFFF00}"..  succJobExp.."{/}");
	end

	return height;
end
-- 보상 - 레벨업
function  QUESTDETAIL_MAKE_QUESTINFO_REWARD_LVUP(gbBody,  x, y, questIES, prop)
	
	local pc = SCR_QUESTINFO_GET_PC();
    local nextPCLvIES = GetClass('Xp', pc.Lv + 1)
    if nextPCLvIES == nil then
        return 0
	end

	if GET_QUESTINFO_PC_FID() ~= 0 then
        return 0
	end
	
	local height = 0;
	local font = '{@st41b}'
	if prop.font ~= nil then
		font = prop.font;
	end

	local quest_auto = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
    
    local repeat_reward_item = {}
    local repeat_reward_achieve = {}
    local repeat_reward_achieve_point = {}
    local repeat_reward_exp = 0;
    local repeat_reward_npc_point = 0
    local repeat_reward_select = false
    local repeat_reward_select_use = false
    
    repeat_reward_item, repeat_reward_achieve, repeat_reward_achieve_point, repeat_reward_exp, repeat_reward_npc_point, repeat_reward_select, repeat_reward_select_use = SCR_REPEAT_REWARD_CHECK(pc, questIES, quest_auto, sObj)
    
	local qRewardExp = 0
    
    if quest_auto.Success_Exp > 0 then
        qRewardExp = qRewardExp + quest_auto.Success_Exp
    end
    
    if repeat_reward_exp ~= nil or repeat_reward_exp > 0 then
        qRewardExp = qRewardExp + repeat_reward_exp
    end
    
    if quest_auto.Success_Lv_Exp > 0 and pc.Lv < PC_MAX_LEVEL then
        local xpIES = GetClass('Xp', pc.Lv)
        if xpIES ~= nil then
            local lvexpvalue =  math.floor(xpIES.QuestStandardExp * quest_auto.Success_Lv_Exp)
            if lvexpvalue ~= nil and lvexpvalue > 0 then
	            qRewardExp = qRewardExp + lvexpvalue
            end
        end
	end
	
	if pc.Lv < PC_MAX_LEVEL and qRewardExp > 0 and session.GetMaxEXP() - session.GetEXP() - qRewardExp <= 0 then
	    local content = gbBody:CreateOrGetControl('richtext', 'QUESTINFOREWARDLVUP', x, y, gbBody:GetWidth() - x - SCROLL_WIDTH, 10);
    	content:EnableHitTest(0);
    	content:SetTextFixWidth(0);
    	content:SetText(font..ScpArgMsg('QUESTINFOREWARDLVUP','Auto_1',pc.Lv + 1));
    	height = height + content:GetHeight(); 
   end
    
	return height;
end

-- 보상 - 아이템
function QUESTDETAIL_MAKE_REWARD_ITEM_CTRL(gbBody, x, y, questIES)
	local cls = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
	local MySession = session.GetMyHandle();
	local MyJobNum = info.GetJob(MySession);
	local JobName = GetClassString('Job', MyJobNum, 'ClassName');
	local index = 0
	local job = SCR_JOBNAME_MATCHING(JobName)
	local pc = GetMyPCObject();

	local height = 0;
	local isItem = 0;
	if cls.Success_ItemName1 ~= "None" or cls.Success_JobItem_Name1 ~= "None" then
		for i = 1 , MAX_QUEST_TAKEITEM do
			local propName = "Success_ItemName" .. i;
			if cls[propName] ~= "None" and cls[propName] ~= "Vis" then
				height = height + QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(gbBody, x, y + height,  "reward_item", cls[propName], cls["Success_ItemCount" .. i], i);
				index = index + 1
				isItem = 1;
			end
		end

        for i = 1, 20 do
            if cls['Success_JobItem_Name'..i] ~= 'None' and cls['Success_JobItem_JobList'..i] ~= 'None' then
                local jobList = SCR_STRING_CUT(cls['Success_JobItem_JobList'..i])
                if SCR_Q_SUCCESS_REWARD_JOB_GENDER_CHECK(pc, jobList, job, pc.Gender, cls.Success_ChangeJob) == 'YES' then
                    local propName = 'Success_JobItem_Name'..i
					height = height + QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(gbBody, x, y + height, "reward_item", cls[propName], cls["Success_JobItem_Count" .. i], index + i);
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

	return height;
end

-- 보상 - 랜덤 보상(??)
function QUESTDETAIL_MAKE_REWARD_RANDOM_CTRL(gbBody, x, y, questIES)
	local questAutoCls = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
	local pc = GetMyPCObject();
	local sObj = GetSessionObject(pc, 'ssn_klapeda')
	local height = 0;
    if questAutoCls.Success_RandomReward ~= 'None' and GetPropType(sObj, questIES.QuestPropertyName..'_RR') ~= nil and sObj[questIES.QuestPropertyName..'_RR'] ~= 'None' then
        height = height + QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x, y + height, gbBody:GetWidth() - 30 ,20, "t_reward_random",  ScpArgMsg("DialogSelectRandomRewardTxt"));
		
		local randomReward = SCR_STRING_CUT(questAutoCls.Success_RandomReward)
        local randomRewardItem = SCR_STRING_CUT_COLON(sObj[questIES.QuestPropertyName..'_RR'])
		
		height = height + QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(gbBody, x, y + height, "reward_item_random", randomRewardItem[1], tonumber(randomRewardItem[2]), 0);
		height = height + QUESTDETAIL_MAKE_RECIPE_TAG_TEXT_CTRL(gbBody, x, y + height, "reward_item_random", randomRewardItem[1], tonumber(randomRewardItem[2]), 0);
    end
    
    return height;
end

-- 보상 - 단계별
function QUESTDETAIL_MAKE_REWARD_STEP_ITEM_CTRL(gbBody, x, y, questIES)
	local cls = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
	local pc = GetMyPCObject();
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);
	local state = CONVERT_STATE(result);
	local height = 0;
	
	if TryGetProp(cls, 'StepRewardList1') ~= nil and TryGetProp(cls, 'StepRewardList1') ~= 'None' then
        local duplicate = TryGetProp(cls, 'StepRewardDuplicatePayments')
        local lastReward
        local pc = GetMyPCObject();
        if duplicate == 'NODUPLICATE' then
            local sObj = GetSessionObject(pc, 'ssn_klapeda')
            local lastRewardList = TryGetProp(sObj, questIES.QuestPropertyName..'_SRL')
            if lastRewardList ~= nil and lastRewardList ~= 'None' then
                lastReward = SCR_STRING_CUT(lastRewardList)
            end
        end
        local maxRewardIndex
        if state == 'SUCCESS' then
            for index = 1, 10 do
                if table.find(lastReward, index) == 0 then
                    local stepRewardFuncList = TryGetProp(cls, 'StepRewardFunc'..index)
                    if stepRewardFuncList ~= nil and stepRewardFuncList ~= 'None' then
                        stepRewardFuncList = SCR_STRING_CUT(stepRewardFuncList)
                        local stepRewardFunc = _G[stepRewardFuncList[1]]
                        if stepRewardFunc ~= nil then
                            local result = stepRewardFunc(pc, stepRewardFuncList)
                            if result == 'YES' then
                                maxRewardIndex = index
                            end
                        end
                    end
                end
            end
		end
		
        local titleFlag = 0
        for index = 1, 10 do
            if (state == nil and table.find(lastReward, index) == 0) or (state == 'SUCCESS' and maxRewardIndex == index) then
				if titleFlag == 0 then
					height = height + QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x, y + height, gbBody:GetWidth() - 30 ,20, "t_stepReward", '{@st54}{b}'..ScpArgMsg("QUEST_STEPREWARD_MSG1"));
					titleFlag = 1
                end
                local rewardList = SCR_TABLE_TYPE_SEPARATE(SCR_STRING_CUT(TryGetProp(cls, 'StepRewardList'..index)), {'ITEM'})
                local itemList = rewardList['ITEM']
				if itemList ~= nil and itemList[1] ~= 'None' and #itemList > 0 then
					local marginX = 10;
					height = height + QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, marginX + x, y + height, gbBody:GetWidth() - 30 ,50, "s_stepReward_text_"..index, '{@st41b}'..ScpArgMsg("QUEST_STEPREWARD_MSG2", "STEP", index));
					for i2 = 1, #itemList/2 do
                        local itemName = itemList[i2*2 - 1]
						local itemCount = itemList[i2*2]
						height = height + QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(gbBody, x, y + height, "s_stepReward_item_", itemName, itemCount, index*10+i2);
                    end
                end
            end
        end
	end
	
    return height;
end


-- 보상 - 반복
function QUESTDETAIL_MAKE_REWARD_REPEAT_CTRL(gbBody, x, y, questIES)
	local height = 0;
	local questAutoCls = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
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
        
		repeat_reward_item, repeat_reward_achieve, repeat_reward_achieve_point, repeat_reward_exp, repeat_reward_npc_point, repeat_reward_select, repeat_reward_select_use = SCR_REPEAT_REWARD_CHECK(pc, questIES, questAutoCls, sObj)
		
	    if #repeat_reward_item > 0 or #repeat_reward_achieve > 0 or #repeat_reward_achieve_point > 0 or repeat_reward_exp > 0 or repeat_reward_npc_point > 0 then
			height = height + QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x, y + height, gbBody:GetWidth() - 30 ,20 , "t_reward_repeat", ScpArgMsg("Auto_{@st41}ChuKa_BoSang{/}"));

			if #repeat_reward_item > 0 then
	            for i = 1, #repeat_reward_item do
					if repeat_reward_item[i][2] ~= 'Vis' then
						height = height + QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(gbBody, x, y + height, "reward_item_repeat", repeat_reward_item[i][2], repeat_reward_item[i][3], i);
						height = height + QUESTDETAIL_MAKE_RECIPE_TAG_TEXT_CTRL(gbBody, x, y + height, "reward_item_repeat", repeat_reward_item[i][2], repeat_reward_item[i][3], i);
        			else
        			    money = money + repeat_reward_item[i][3]
        			end
	            end
	        end
	        
	        if #repeat_reward_achieve > 0 then
	            for i = 1, #repeat_reward_achieve do
	                local achieve = GetClass('Achieve', repeat_reward_achieve[i][2])
	                local txt = ScpArgMsg("RepeatRewardAchieve")..'{@st41b}{#0064FF}'..achieve.Name
					height = height + QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x, y + height, gbBody:GetWidth() - 30 ,20 , 'achieve'..i, txt);
	            end
	        end
	        
	        if #repeat_reward_achieve_point > 0 then
	            for i = 1, #repeat_reward_achieve_point do
	                local achievePoint = GetClass('AchievePoint', repeat_reward_achieve_point[i][2])
	                local txt = ScpArgMsg("RepeatRewardAchievePoint","Auto_1",achievePoint.Name,"Auto_2",repeat_reward_achieve_point[i][3])
					height = height + QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x, y + height, gbBody:GetWidth() - 30 ,20 , 'achievePoint'..i, txt);
	            end
	        end
	        
			if repeat_reward_exp > 0 then
				height = height + QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x, y + height, gbBody:GetWidth() - 30 ,20 , 'exp_repeat', ScpArgMsg("Auto_{@st41}KyeongHeomChi_:_") .."{s20}{ol}{#FFFF00}"..  repeat_reward_exp.."{/}");
	        end
	        
			if repeat_reward_npc_point > 0 then
				height = height + QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x, y + height, gbBody:GetWidth() - 30 ,20 , 'npcpoint_repeat', ScpArgMsg("RepeatRewardNPCPoint") .."{s20}{ol}{#FFFF00}"..  repeat_reward_npc_point.."{/}");
	        end
	        
			if money > 0 then
				height = height + QUESTDETAIL_MAKE_ITEM_TAG_TEXT_CTRL(gbBody, x, y + height, "reward_item_repeat", repeat_reward_item[i][2], repeat_reward_item[i][3], i);
				height = height + QUESTDETAIL_MAKE_MONEY_TAG_TEXT_CTRL(gbBody, x, y + height, "money_Item_repeat", money, 1 );
	        end
	    end
	end

	return height;
end


function QUESTDETAIL_MAKE_DIALOG_BTN(frame, gbBody, x, y, questIES, _gravity, _margin)
    local height = 0;

    local btnWidth = 160;
    local btnHeight = 50;
    local text = frame:GetUserConfig("BUTTON_FONT") .. ClMsg("ViewDialog");

    if _gravity == nil then
        _gravity =  { horz = ui.CENTER_HORZ, vert = ui.BOTTOM };
    end

    if _margin == nil then
        _margin = {0,0,0,10}
    end

    height = height + QUESTDETAIL_BOX_CREATE_BUTTON(gbBody, x, y, btnWidth, btnHeight, 'quest_dialog_btn', text, {
        gravity = _gravity,
        mragin = _margin,
        skinName = frame:GetUserConfig("BUTTON_SKIN"),
        tooltip ={
            type = 'texthelp',
            arg = frame:GetUserConfig("BUTTON_TOOLTIP_FONT") .. ClMsg("ViewQuestDialog"),
        },
        eventScript = {
            LBtnDownScp = "SCR_QUEST_DIALOG_REPLAY",
            LBtnDownScpArgNumber = questIES.ClassID,
            LBtnUpScp = "QUESTDETAIL_CLOSE_FRAME",
        },
    });

    return height;
end

function QUESTDETAIL_MAKE_LOCATION_BTN(frame, gbBody, x, y, questIES, _gravity, _margin)
    local height = 0;
    local btnWidth = 160;
    local btnHeight = 50;
    local text = frame:GetUserConfig("BUTTON_FONT") .. ClMsg("ViewLocation");

    if _gravity == nil then
        _gravity =  { horz = ui.CENTER_HORZ, vert = ui.BOTTOM };
    end

    if _margin == nil then
        _margin = {0,0,0,10}
    end


    height = height + QUESTDETAIL_BOX_CREATE_BUTTON(gbBody, x, y+height, btnWidth, btnHeight, 'quest_location_btn', text, {
        gravity = _gravity,
        margin = _margin,
        skinName = frame:GetUserConfig("BUTTON_SKIN"),
        tooltip ={
            type = 'texthelp',
            arg = frame:GetUserConfig("BUTTON_TOOLTIP_FONT") .. ClMsg("ViewQuestLocation"),
        },
        eventScript = {
            LBtnDownScp = "SCR_VIEW_QUEST_LOCATION",
            LBtnDownScpArgNumber = questIES.ClassID,
            LBtnUpScp = "QUESTDETAIL_CLOSE_FRAME",
        },
    });

    return height;
end

function QUESTDETAIL_MAKE_ABANDON_BTN(frame, gbBody, x, y, questIES, _gravity, _margin)
    local height = 0;
    local btnWidth = 160;
    local btnHeight = 50;
    local text = frame:GetUserConfig("BUTTON_FONT") .. ClMsg("Abandon");

    if _gravity == nil then
        _gravity =  { horz = ui.CENTER_HORZ, vert = ui.BOTTOM };
    end

    if _margin == nil then
        _margin = {0,0,0,10}
    end


    height = height + QUESTDETAIL_BOX_CREATE_BUTTON(gbBody, x, y+height, btnWidth, btnHeight, 'quest_abandon_btn', text, {
        gravity = _gravity,
        margin = _margin,
        skinName = frame:GetUserConfig("BUTTON_SKIN"),
        tooltip ={
            type = 'texthelp',
            arg = frame:GetUserConfig("BUTTON_TOOLTIP_FONT") .. ClMsg("AbandonQuest"),
        },
        eventScript = {
            LBtnDownScp = "SCR_QUEST_ABANDON_SELECT",
            LBtnDownScpArgNumber = questIES.ClassID,
            LBtnUpScp = "QUESTDETAIL_CLOSE_FRAME",
        },
    });

    return height;
end

function QUESTDETAIL_MAKE_RESTART_BTN(frame, gbBody, x, y, questIES, _gravity, _margin)
    local height = 0;
    local btnWidth = 160;
    local btnHeight = 50;
    local text = frame:GetUserConfig("BUTTON_FONT") .. ClMsg("Restart");

    if _gravity == nil then
        _gravity =  { horz = ui.CENTER_HORZ, vert = ui.BOTTOM };
    end

    if _margin == nil then
        _margin = {0,0,0,10}
    end


    height = height + QUESTDETAIL_BOX_CREATE_BUTTON(gbBody, x, y+height, btnWidth, btnHeight, 'quest_restart_btn', text, {
        gravity = _gravity,
        margin = _margin,
        skinName = frame:GetUserConfig("BUTTON_SKIN"),
        tooltip ={
            type = 'texthelp',
            arg = frame:GetUserConfig("BUTTON_TOOLTIP_FONT") .. ClMsg("RestartQuest"),
        },
        eventScript = {
            LBtnDownScp = "SCR_ABANDON_QUEST_TRY",
            LBtnDownScpArgNumber = questIES.ClassID,
            LBtnUpScp = "QUESTDETAIL_CLOSE_FRAME",
        },
    });

    return height;
end