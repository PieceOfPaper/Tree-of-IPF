function DIALOGSELECT_ON_INIT(addon, frame)

	DialogSelect_index = 0;
	DialogSelect_count = 0;
	DialogSelect_offsetY = frame:GetY();
	DialogSelect_Type = 0;

	addon:RegisterMsg('DIALOG_CHANGE_SELECT', 'DIALOGSELECT_ON_MSG');
	addon:RegisterMsg('DIALOG_ADD_SELECT', 'DIALOGSELECT_ON_MSG');
	addon:RegisterMsg('DIALOG_NUMBER_RANGE', 'DIALOGSELECT_ON_MSG');
	addon:RegisterMsg('DIALOG_TEXT_INPUT', 'DIALOGSELECT_ON_MSG');
	addon:RegisterMsg('DIALOG_CLOSE', 'DIALOGSELECT_ON_MSG');
	addon:RegisterMsg('DIALOGSELECT_UP', 'DIALOGSELECT_ON_MSG');
	addon:RegisterMsg('DIALOGSELECT_DOWN', 'DIALOGSELECT_ON_MSG');
	addon:RegisterMsg('DIALOGSELECT_SELECT', 'DIALOGSELECT_ON_MSG');
	addon:RegisterMsg('ESCAPE_PRESSED', 'DIALOGSELECT_ON_PRESS_ESCAPE');
end

function DIALOGSELECT_ITEM_ADD(frame, msg, argStr, argNum)
	if argNum == 1 then
		if DIALOGSELECT_QUEST_REWARD_ADD(frame, argStr) == 1 then
			frame:SetUserValue("FIRSTORDER_MAXHEIGHT", 1);			
			return;
		else
			local questRewardBox = frame:GetChild('questreward');
			if questRewardBox ~= nil then
				frame:RemoveChild('questreward');
			end
		end
	end

	local questRewardBox = frame:GetChild('questreward');
	if questRewardBox ~= nil then
		argNum = argNum - 1;
	end
	
	local controlName = 'item' .. argNum .. 'Btn'
	local ItemBtn		= frame:GetChild(controlName);
	local ItemBtnCtrl	= tolua.cast(ItemBtn, 'ui::CButton');
	local locationUI = DialogSelect_offsetY - argNum * 37 - 10;

	ItemBtnCtrl:SetGravity(ui.CENTER_HORZ, ui.TOP);
    
	if questRewardBox ~= nil then
		local width  = questRewardBox:GetWidth();
		local height = questRewardBox:GetHeight();
		local offset = 10 + ((argNum-1) * 40);
		local offsetEx = 10 + ((argNum) * 40);
		local y = tonumber(frame:GetUserValue("QUESTFRAME_HEIGHT"));	
		local frameHeight = offset + y + 50;
		local maxHeight = ui.GetSceneHeight();
		
		questRewardBox:SetGravity(ui.CENTER_HORZ, ui.TOP);		
				
		local spaceBtnHeight = (10 + (argNum * 40) + 40) - 40 ;
		questRewardBox:SetOffset(0, 50);	
		if tonumber(frame:GetUserValue("FIRSTORDER_MAXHEIGHT")) == 1 then			
			if (y + (maxHeight - frame:GetY())) > (maxHeight) then	
				local frameMaxHeight = maxHeight/2;
				frameHeight = offset + frameMaxHeight + 50;		
					
				local boxHeight = frameMaxHeight - spaceBtnHeight;		
				questRewardBox:Resize(width + 10, boxHeight );
				questRewardBox:SetScrollBar(boxHeight );
				frame:SetUserValue("IsScroll", "YES");		
				ItemBtnCtrl:SetOffset(0, boxHeight + offsetEx);	
			else				
				frame:SetUserValue("IsScroll", "NO");	
				ItemBtnCtrl:SetOffset(0, height + offset + 10 + ItemBtnCtrl:GetHeight());			
			end;
			frame:SetUserValue("FIRSTORDER_MAXHEIGHT", 0);
		else			
			if frame:GetUserValue("IsScroll") == "NO" then
				height = y + ItemBtnCtrl:GetHeight();	
				frameHeight = height + offset + 50;	
				ItemBtnCtrl:SetOffset(0, height + offset + 10);
			else
				frameHeight = height + offsetEx + 50;	
				ItemBtnCtrl:SetOffset(0, height + offsetEx);
			end
		end;		
		frame:Resize(600, frameHeight + 10);			
		frame:ShowWindow(1);	
		
	else
		ItemBtnCtrl:SetOffset(0, (argNum-1) * 40 + 40);
		frame:Resize(600, argNum * 40 + 90);
        frame:SetOffset(frame:GetX(),  locationUI);
	end

	ItemBtnCtrl:SetEventScript(ui.LBUTTONDOWN, 'control.DialogSelect(' .. argNum .. ')');
	ItemBtnCtrl:ShowWindow(1);
	ItemBtnCtrl:SetText('{s18}{b}{#2f1803}'..argStr);
  frame:Update()
end




function DIALOGSELECT_QUEST_REWARD_ADD(frame, argStr)
	local questCls = GetClass("QuestProgressCheck", argStr);
	local cls = GetClass("QuestProgressCheck_Auto", argStr);
	local pc = GetMyPCObject();
	
	if questCls == nil or cls == nil then
		return 0;
	end

	local questRewardBox = frame:CreateOrGetControl('groupbox', 'questreward', 10, 10, frame:GetWidth()-70, frame:GetHeight());
	tolua.cast(questRewardBox, "ui::CGroupBox");
	questRewardBox:DeleteAllControl();
	questRewardBox:EnableDrawFrame(0);
	questRewardBox:EnableScrollBar(1);
	questRewardBox:EnableResizeByParent(0);
	questRewardBox:ShowWindow(1);
    
    local questName
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
	
	local y = 0;
	if questCls.QuestMode == 'MAIN' then
	    y = BOX_CREATE_RICHTEXT(questRewardBox, "title", y, 50, "{@st41}{#FFCC00}"..ScpArgMsg("Auto_[Mein]_")..questName);
	else
    	y = BOX_CREATE_RICHTEXT(questRewardBox, "title", y, 50, "{@st41}"..questName);
    end
    
    
    
    local pc = GetMyPCObject();
    
    local repeat_reward_item = {}
    local repeat_reward_achieve = {}
    local repeat_reward_achieve_point = {}
    local repeat_reward_exp = 0;
    local repeat_reward_npc_point = 0
    local repeat_reward_select = false
    local repeat_reward_select_use = false
    
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    
    repeat_reward_item, repeat_reward_achieve, repeat_reward_achieve_point, repeat_reward_exp, repeat_reward_npc_point, repeat_reward_select, repeat_reward_select_use = SCR_REPEAT_REWARD_CHECK(pc, questCls, cls, sObj)
    
    y = MAKE_SELECT_REWARD_CTRL(questRewardBox, y, cls, 'DIALOGSELECT_QUEST_REWARD_ADD');
    
	y = y + 30;
    
    local reward_result = QUEST_REWARD_CHECK(argStr)
    if #reward_result > 0 then
    	y = BOX_CREATE_RICHTEXT(questRewardBox, "t_addreward", y, 50, ScpArgMsg("DialogSelectRewardTxt"));
    	y = MAKE_BASIC_REWARD_MONEY_CTRL(questRewardBox, cls, y);
    	y = MAKE_BASIC_REWARD_BUFF_CTRL(questRewardBox, cls, y);
    	y = MAKE_BASIC_REWARD_HONOR_CTRL(questRewardBox, cls, y);
    	y = MAKE_BASIC_REWARD_PCPROPERTY_CTRL(questRewardBox, cls, y);
    end
    
	local succExp = cls.Success_Exp;
	if repeat_reward_exp > 0 then
	    succExp = succExp + repeat_reward_exp
	end
	
	if cls.Success_Lv_Exp > 0 then
        local xpIES = GetClass('Xp', questCls.Level)
        if xpIES ~= nil then
            local lvexpvalue =  math.floor(xpIES.QuestStandardExp * cls.Success_Lv_Exp)
            if lvexpvalue ~= nil and lvexpvalue > 0 then
	            succExp = succExp + lvexpvalue
            end
        end
    end
    
	if succExp > 0 then
		y = BOX_CREATE_RICHTEXT(questRewardBox, "t_successExp", y, 50, ScpArgMsg("Auto_{@st41}KyeongHeomChi_:_") .."{s20}{#FFFF00}"..  succExp.."{/}");
		
		y = MAKE_QUESTINFO_REWARD_LVUP(questRewardBox, questCls, 10, y)
	end

	y = MAKE_REWARD_ITEM_CTRL(questRewardBox, cls, y);
    y = MAKE_BASIC_REWARD_RANDOM_CTRL(questRewardBox, questCls, cls, y)
	y = MAKE_BASIC_REWARD_REPE_CTRL(questRewardBox, questCls, cls, y)
	questRewardBox:Resize(10, 10, questRewardBox:GetWidth(), y+30);
	frame:SetUserValue("QUESTFRAME_HEIGHT",  y+30);
	frame:Invalidate();
	return 1;
end

function DIALOGSELECT_ON_MSG(frame, msg, argStr, argNum)
	frame:Invalidate();
	frame:SetOffset(frame:GetX(),frame:GetY())
    if  msg == 'DIALOG_CHANGE_SELECT'  then
		for i = 1, 11 do
			local childName = 'item' .. i .. 'Btn'
			local ItemBtn = frame:GetChild(childName);
			ItemBtn:ShowWindow(0);
		end

		local numberEdit = frame:GetChild('numberEdit');
		local numberHelp = frame:GetChild('numberHelp');
		numberHelp:ShowWindow(0);
		numberEdit:ShowWindow(0);

		DialogSelect_index = 0;
		DialogSelect_count = 0;

	elseif msg == 'DIALOG_NUMBER_RANGE' then
		local numberHelp = frame:GetChild('numberHelp');
		numberHelp:ShowWindow(1);
		argStr = math.floor(argStr);
		numberHelp:SetText(ScpArgMsg('Auto_ChoeSo_:_')..argStr..ScpArgMsg('Auto__ChoeDae_:_')..argNum);
		local numberEdit = frame:GetChild('numberEdit');
		tolua.cast(numberEdit, "ui::CEditControl");
		numberEdit:SetText(argStr);
		numberEdit:Resize(70, 40);
		numberEdit:ShowWindow(1);
		numberEdit:SetNumberMode(1);
		numberEdit:AcquireFocus();
		frame:Resize(400, 100);
		DialogSelect_Type = 1;
	elseif msg == 'DIALOG_TEXT_INPUT' then
		local numberEdit = frame:GetChild('numberEdit');
		tolua.cast(numberEdit, "ui::CEditControl");
		numberEdit:ClearText();
		numberEdit:Resize(360, 40);
		numberEdit:ShowWindow(1);
		numberEdit:SetNumberMode(0);
		numberEdit:AcquireFocus();
		frame:Resize(400, 100);
		DialogSelect_Type = 2;
		frame:SetOffset(frame:GetX(),math.floor(ui.GetSceneHeight()*0.7))
		
		local questreward = frame:GetChild('questreward');
		if questreward ~= nil then
    		questreward:ShowWindow(0)
    	end
	elseif  msg == 'DIALOG_ADD_SELECT'  then
		DialogSelect_Type = 0;
		DIALOGSELECT_ITEM_ADD(frame, msg, argStr, argNum);

		local questRewardBox = frame:GetChild('questreward');
		if questRewardBox ~= nil then
			argNum = argNum - 1;
		end
		DialogSelect_count = argNum;

		local ItemBtn = frame:GetChild('item1Btn');
		local itemWidth = ItemBtn:GetWidth();
		local x, y = GET_SCREEN_XY(ItemBtn,itemWidth/2.5);

		DialogSelect_index = 1;

		mouse.SetPos(x,y);
		mouse.SetHidable(0);

	elseif  msg == 'DIALOG_CLOSE'  then
		frame:SetUserValue("QUESTFRAME_HEIGHT",  0);
		frame:SetUserValue("FIRSTORDER_MAXHEIGHT", 0);			
		frame:SetUserValue("IsScroll", "NO");	
		ui.CloseFrame(frame:GetName());
		DialogSelect_index = 0;
		DialogSelect_count = 0;
		mouse.SetHidable(1);

	elseif msg == 'DIALOGSELECT_UP' then
		DialogSelect_index = DialogSelect_index - 1;
		if DialogSelect_index <= 0 then
			DialogSelect_index = DialogSelect_count;
		end
		DIALOGSELECT_ITEM_SELECT(frame);

	elseif msg == 'DIALOGSELECT_DOWN' then
		DialogSelect_index = DialogSelect_index + 1;
		if DialogSelect_index > DialogSelect_count then
			DialogSelect_index = 1;
		end
		DIALOGSELECT_ITEM_SELECT(frame);

	elseif msg == 'DIALOGSELECT_SELECT' then
		if DialogSelect_index ~= 0 then
			control.DialogSelect(DialogSelect_index);
		end
	end
end

function DIALOGSELECT_ITEM_SELECT(frame)
	local childName = 'item' .. DialogSelect_index .. 'Btn'
	local ItemBtn = frame:GetChild(childName);

	if ItemBtn == nil then
		return;
	end;

    local itemWidth = ItemBtn:GetWidth();
	local x, y = GET_SCREEN_XY(ItemBtn,itemWidth/2.5);
	mouse.SetPos(x, y);
	mouse.SetHidable(0);
end

function DIALOGSELECT_ON_PRESS_ESCAPE(frame, msg, argStr, argNum)
	if Dialog_IsTalking == 1 then
		control.DialogCancel();
	end
end

function DIALOGSELECT_NUMBER_ENTER(frame, ctrl)
	local strText = ctrl:GetText();

	if strText ~= nil then
		if DialogSelect_Type == 1 then
			local number = tonumber(strText);
			control.DialogNumberSelect(number);
		elseif DialogSelect_Type == 2 then
			control.DialogStringSelect(strText);
		end
	end
end

function DIALOGSELECT_STRING_ENTER(frame, ctrl)
	local strText = ctrl:GetText();

	if strText ~= nil then
		control.DialogStringSelect(strText);
	end
end

function MAKE_REWARD_ITEM_CTRL(box, cls, y)

	local MySession		= session.GetMyHandle();
	local MyJobNum		= info.GetJob(MySession);
	local JobName		= GetClassString('Job', MyJobNum, 'ClassName');
	local job = SCR_JOBNAME_MATCHING(JobName)
	local index = 0
	local pc = GetMyPCObject();


	local isItem = 0;

	if cls.Success_ItemName1 ~= "None" or cls.Success_JobItem_Name1 ~= "None" then
		for i = 1 , MAX_QUEST_TAKEITEM do
			local propName = "Success_ItemName" .. i;
			if cls[propName] ~= "None" and cls[propName] ~= 'Vis' then
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

	return y;
end


