

function QUESTDETAIL_ON_INIT(addon, frame)

end

function QUESTDETAIL_ON_MSG(frame, msg, argStr, argNum)

end

function QUESTDETAIL_INFO(questID, xPos)

	local frame = ui.GetFrame('questdetail');
	local box = frame:GetChild('box');
	tolua.cast(box, "ui::CGroupBox");
	box:DeleteAllControl();

	local y = 5;

	local questCls = GetClassByType("QuestProgressCheck", questID);
	local cls = GetClassByType("QuestProgressCheck_Auto", questID);

	local titleStory = 'None';
	local pc = GetMyPCObject();
	local result = SCR_QUEST_CHECK_C(pc, questCls.ClassName);
	local State = CONVERT_STATE(result);
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
	local titleText = GET_QUEST_DETAIL_TITLE(questCls, sObj);    
	
	titleStory = questCls[State..'Story'];

	y = BOX_CREATE_RICHTEXT(box, "title", y, 20, "{@st41}"..titleText);

	local s_obj		= GetClass("SessionObject", questCls.Quest_SSN);
	local s_info	= nil;
	if s_obj ~= nil then
		local s_info = session.GetSessionObject(s_obj.ClassID);
		if s_info ~= nil then
			s_obj = GetIES(s_info:GetIESObject());
			box:SetValue(s_info.type);
		end
	end
	
	y = MAKE_QUESTINFO_BY_IES(box, questCls, 20, y + 5, s_obj, result, 1);

    if titleStory ~= 'None' and titleStory ~= questCls[State..'Desc'] then
    	y = BOX_CREATE_RICHTEXT(box, "story", y + 10, 20, "{#150800}{b}"..titleStory);
    end
    
    local repeat_reward_item = {}
    local repeat_reward_achieve = {}
    local repeat_reward_achieve_point = {}
    local repeat_reward_exp = 0;
    local repeat_reward_npc_point = 0
    local repeat_reward_select = false
    local repeat_reward_select_use = false
    
    repeat_reward_item, repeat_reward_achieve, repeat_reward_achieve_point, repeat_reward_exp, repeat_reward_npc_point, repeat_reward_select, repeat_reward_select_use = SCR_REPEAT_REWARD_CHECK(pc, questCls, cls, sObj)
    
	y = y + 10;
    if result == 'PROGRESS' or result == 'SUCCESS' then
    	y = MAKE_DETAIL_TAKE_CTRL(box, questCls, y);
    end
	y = MAKE_SELECT_REWARD_CTRL(box, y, cls);

    local reward_result = QUEST_REWARD_CHECK(questCls.ClassName)
    if #reward_result > 0 then
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
	
	if cls.Success_Lv_Exp > 0 then
        local xpIES = GetClass('Xp', pc.Lv)
        if xpIES ~= nil then
            local lvexpvalue =  math.floor(xpIES.QuestStandardExp * cls.Success_Lv_Exp)
            if lvexpvalue ~= nil and lvexpvalue > 0 then
	            succExp = succExp + lvexpvalue
            end
            local lvjobexpvalue =  math.floor(xpIES.QuestStandardJobExp * cls.Success_Lv_Exp)
            if lvjobexpvalue ~= nil and lvjobexpvalue > 0 then
	            succJobExp = succJobExp + lvjobexpvalue
            end
        end
    end
    
	if succExp > 0 then
	    y = y + 5
		y = BOX_CREATE_RICHTEXT(box, "t_successExp", y, 20, ScpArgMsg("Auto_{@st41}KyeongHeomChi_:_") .."{s20}{ol}{#FFFF00}"..  succExp.."{/}", 10);
		local tempY = y
		y = MAKE_QUESTINFO_REWARD_LVUP(box, questCls, 20, y, '{@st41b}')
		if tempY ~= y then
		    y = y - 5
		end
	end
	if succJobExp > 0 then
		y = BOX_CREATE_RICHTEXT(box, "t_successJobExp", y, 20, ScpArgMsg("SuccessJobExpGiveMSG1") .."{s20}{#FFFF00}"..  succJobExp.."{/}", 10);
	end

	y = MAKE_BASIC_REWARD_ITEM_CTRL(box, cls, y);
    
    y = MAKE_BASIC_REWARD_RANDOM_CTRL(box, questCls, cls, y + 20);
    
	y = MAKE_BASIC_REWARD_REPE_CTRL(box, questCls, cls, y + 20);

    if questCls.AbandonUI == 'YES' then
        if result == 'PROGRESS' or result == 'SUCCESS' then
        	y = MAKE_ABANDON_CTRL(frame, box, y);
        	y = y + 30;
    	end
    end

	frame:ShowWindow(1);
	box:Resize(box:GetWidth(), y);
	frame:Resize(xPos, frame:GetY(), frame:GetWidth(), y + 100);
	frame:Invalidate()
end

function GET_QUEST_DETAIL_TITLE(questCls, sObj)
    local titleText = nil;
    if questCls.QuestMode == 'REPEAT' then
		if sObj ~= nil then
			if questCls.Repeat_Count ~= 0 then
				titleText = questCls.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/{Auto_2})","Auto_1", sObj[questCls.QuestPropertyName..'_R'] + 1, "Auto_2",questCls.Repeat_Count);
			else
				titleText = questCls.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/MuHan)","Auto_1", sObj[questCls.QuestPropertyName..'_R'])
			end
		end
	elseif questCls.QuestMode == 'PARTY' then
	    if sObj ~= nil then
	        titleText = questCls.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/{Auto_2})","Auto_1", sObj.PARTY_Q_COUNT1 + 1, "Auto_2",CON_PARTYQUEST_DAYMAX1)
	    end
	end
	
	if titleText == nil then
	    titleText = questCls.Name;
	end
	
	titleText = "["..ScpArgMsg("Level{Level}","Level",questCls.Level).."] "..titleText;    
    return titleText;
end

function MAKE_DETAIL_TAKE_CTRL(box, cls, y)
  y = y + 10;
    local flag = false
    local pc
    local sObj_quest
    if cls.Quest_SSN ~= 'None' then
	    pc = GetMyPCObject();
        sObj_quest = GetSessionObject(pc, cls.Quest_SSN)
        if sObj_quest ~= nil and sObj_quest.SSNInvItem ~= 'None' then
            flag = true
        end
    end
	if cls.Succ_InvItemName1 ~= "None" or cls.Succ_EqItemName1 ~= "None" or flag == true then
		y = BOX_CREATE_RICHTEXT(box, "need_item", y, 20, ScpArgMsg("Auto_{@st41}Pilyo_aiTem"));
		for i = 1 , QUEST_MAX_INVITEM_CHECK do
			local propName = "Succ_InvItemName" .. i;
			if cls[propName] ~= "None" then
				y = MAKE_ITEM_TAG_TEXT_CTRL(y, box, "need_Item", cls[propName], cls["Succ_InvItemCount" .. i], i);
			end
		end
		
		for i = 1 , QUEST_MAX_EQUIP_CHECK do
			local propName = "Succ_EqItemName" .. i;
			if cls[propName] ~= "None" then
				y = MAKE_ITEM_TAG_TEXT_CTRL(y, box, "need_Item", cls[propName], 1, i);
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
            		    y = MAKE_ITEM_TAG_TEXT_CTRL(y, box, "need_Item", InvItemName, needcnt, i);
            		end
            	end
            end
		end
	end
    
	return y;
end

function MAKE_ABANDON_CTRL(frame, box, y)
	local abandonBtn = box:CreateControl('button', 'abandon_btn', -15, -40, 160, 50);
	tolua.cast(abandonBtn, 'ui::CButton');
	abandonBtn:SetGravity(ui.CENTER_HORZ, ui.BOTTOM);
	abandonBtn:SetText(frame:GetUserConfig("ABANDON_FONT") .. ClMsg("Abandon"));
	abandonBtn:SetTooltipType('texthelp');
	abandonBtn:SetSkinName(frame:GetUserConfig("ABAONDON_BUTTON_SKIN"));
	abandonBtn:SetTooltipArg(frame:GetUserConfig("ABANDON_TOOLTIP_FONT") .. ClMsg("AbandonQuest"));
    
    local curquest = session.GetUserConfig("CUR_QUEST", 0);
    local StrScript = string.format("EXEC_ABANDON_QUEST(%d)", curquest);
    abandonBtn:SetEventScript(ui.LBUTTONUP, StrScript);
	abandonBtn:SetOverSound('button_over');
	abandonBtn:SetClickSound('button_click_big');

	return y + abandonBtn:GetHeight();
end



