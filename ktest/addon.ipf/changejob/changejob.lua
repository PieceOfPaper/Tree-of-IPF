CHANGE_JOB_TYPE_CAN_UPGRADE = 0;
CHANGE_JOB_TYPE_HAVE = 1;
CHANGE_JOB_TYPE_HAVE_NOT = 2;
CHANGE_JOB_TYPE_NEW = 3;

function CHANGEJOB_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg('GAME_START', 'CHANGEJOB_GAMESTART');
	addon:RegisterMsg('JOB_HISTORY_UPDATE', 'UPDATE_CHANGEJOB');
	addon:RegisterMsg('CHANGE_CLIENT_SIZE', 'CHANGEJOB_SIZE_UPDATE');

end

function CHANGEJOB_SIZE_UPDATE(frame)
	
	if ui.GetSceneHeight() / ui.GetSceneWidth() <= ui.GetClientInitialHeight() / ui.GetClientInitialWidth() then
		frame:Resize(ui.GetSceneWidth() * ui.GetClientInitialHeight() / ui.GetSceneHeight() ,ui.GetClientInitialHeight())
	end
	frame:Invalidate();
end


function CHANGEJOB_OPEN(frame)
	CHANGEJOB_SIZE_UPDATE(frame)
	UPDATE_CHANGEJOB(frame);
	frame:Invalidate();
end


function CHANGEJOB_CLOSE(frame)

end


function CHANGEJOB_GAMESTART(frame)

	CHANGEJOB_SIZE_UPDATE(frame);
	UPDATE_CHANGEJOB(frame);

end


function IS_HAD_JOB(id)

	local ret = 1;
	local index = 0;

	while 1 do

		local jobID = session.GetHaveJobIdByIndex(index); 

		if jobID == -1 then
			ret = 0;
			break;
		end

		if jobID == id then
			ret = 1;
			break;
		end

		index = index + 1;
	end

	return ret;

end

function CHANGEJOB_CHECK_QUEST_SCP_CONDITION_IGNORE_SELECTEDJOB(questname)

	local questIES = GetClass('QuestProgressCheck', questname);
	local req_script_check = 0
	local pc = GetMyPCObject();

    if questIES.Check_Script == 0 then
		return 1
    elseif questIES.Script_Condition == 'AND' then
        if questIES.Check_Script >= 1 then
            for i = 1, questIES.Check_Script do
                if questIES['Script'..i] ~= nil and questIES['Script'..i] ~= 'None' and questIES['Script'..i] ~= '' then
                    local scriptInfo = SCR_STRING_CUT(questIES['Script'..i])


					if 'IS_SELECTED_JOB' == scriptInfo[1] then
						
						req_script_check = req_script_check + 1;
					else
						local func = _G[scriptInfo[1]];
					
						if func ~= nil then
							local result = func(pc, questname, scriptInfo);
							if result == 'YES' then
								req_script_check = req_script_check + 1;
								end
							end
					end
							
						end
					end
 
            if req_script_check == questIES.Check_Script then
				return 1
            end
        end
    elseif questIES.Script_Condition == 'OR' then
        if questIES.Check_Script >= 1 then
            local i
            for i = 1, questIES.Check_Script do
                if questIES['Script'..i] ~= nil and questIES['Script'..i] ~= 'None' and questIES['Script'..i] ~= '' then
                    local scriptInfo = SCR_STRING_CUT(questIES['Script'..i])
                    local func = _G[scriptInfo[1]];

					if 'IS_SELECTED_JOB' ~= scriptInfo[1] then
						if func ~= nil then
							local result = func(pc, questname, scriptInfo);
							if result == 'YES' then
								return 1
							end
						end
					end

                end
            end
        end
    end

	return 0;
end


function CJ_JOB_PROPERTYQUESTCHECK()

	local pc = GetMyPCObject();
    
    local etcObj
	if IsServerSection(pc) == 1 then
		etcObj = GetETCObject(pc);
	else
		etcObj = GetMyEtcObject();
	end
    
    if etcObj.JobChanging ~= 0 then
        return 0
    end
    
	return 1
end

function CJ_JOB_GENDERCHECK(jobid)
	local jobinfo = GetClassByType('Job', jobid);
	local jobGender = TryGetProp(jobinfo, 'Gender');
	local myGender = GETMYPCGENDER();	

	if myGender == nil or jobGender == nil then
		return 0;
	end
	if jobGender == 'Male' then
		if myGender ~= 1 then
			return 0;
		end		
	elseif jobGender == 'Female' then
		if myGender ~= 2 then
			return 0;
		end
	end	
	return 1;
end

function CJ_UPDATE_RIGHT_INFOMATION(frame, jobid, infotype, nowcircle)	

	if nowcircle == 0 then
		print('error! nowcircle == 0, why?')
	end
	
	local jobinfo = GetClassByType('Job', jobid)

	local totaljobcount = session.GetPcTotalJobGrade()
	local stringtest = 'ChangeJobQuest'..totaljobcount
	
	local myIconInfo = info.GetIcon( session.GetMyHandle() );
	local headIndex = myIconInfo:GetHeadIndex();
	
	local charpic = GET_CHILD(frame, "class_image", "ui::CPicture");
	local charimgName = ui.CaptureFullStdImage(jobid, GETMYPCGENDER(), headIndex);
	charpic:SetImage(charimgName);

	local groupbox_infotext = frame:GetChild('groupbox_infotext');
	

	local jobclassname_richtext = GET_CHILD(groupbox_infotext, "className", "ui::CRichText");
	--jobclassname_richtext:SetText(jobinfo.Name);
	jobclassname_richtext:SetTextByKey("param_name", GET_JOB_NAME(jobinfo));


	local jobclasscircle_richtext = GET_CHILD(groupbox_infotext, "classCircle", "ui::CRichText");
	--local jobcircle = session.GetJobGrade(jobid)
	local jobcircle = nowcircle

	if jobcircle == 0 then
		if session.CanChangeJob() == 1 then
			jobclasscircle_richtext:ShowWindow(0)
		else
			jobclasscircle_richtext:ShowWindow(0)
		end
	elseif jobcircle == 1 then
		jobclasscircle_richtext:ShowWindow(0) 
	else
		jobclasscircle_richtext:ShowWindow(1)
		jobclasscircle_richtext:SetTextByKey('param_circle',jobcircle);
	end

	local captionstr = 'Caption'..nowcircle
	--local captionstr = 'Caption'

	local jobclasscaption_richtext = GET_CHILD(frame, "classExplain", "ui::CRichText");
	jobclasscaption_richtext:SetTextByKey("param_explain",jobinfo[captionstr]);

--	local ratingstr = jobinfo.Rating
--	ratingstr_arg = {}

--	for i = 1, 2 do 
--		ratingstr_arg[i] = string.sub(ratingstr,2*i-1,2*i-1)
--		ratingstr_arg[i] = ratingstr_arg[i] + 0
--
--		local starrating = ''
--		for i = 1 , ratingstr_arg[i] do
--			starrating = starrating .. ScpArgMsg('StarRating')
--		end
--
--		local ratingtextname = 'classRating'..i
--		local ratingText = frame:GetChild(ratingtextname);
--		
--		ratingText:SetTextByKey("rating", starrating);
--	end

	
	local ratingstr = jobinfo.Rating
	
	local ratingText1 = frame:GetChild('classRating1');
	local ratingText2 = frame:GetChild('classRating2');

	ratingText1:SetTextByKey("rating", jobinfo.ControlType);
	ratingText2:SetTextByKey("rating", jobinfo.ControlDifficulty);
	

	
	local skillsGbox = frame:GetChild('groupbox_skills');
	skillsGbox:RemoveAllChild();

	local jobskills = {}
	local clslist, cnt  = GetClassList("SkillTree");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);

		local checkJobName = jobinfo.ClassName .. '_';
		if string.find(cls.ClassName, checkJobName) ~= nil and cls.UnlockGrade < jobcircle+1 then
			jobskills[#jobskills+1] = cls.SkillName
		end
	end

	local skillimage_width = 60
	local skillimage_height = 60
	local margin_x = 0;
	local margin_y = 0;
	local margin_x_per_eachpic = 4;
	local margin_y_per_eachpic = 5;
	local skillsPerALine = 6
	for i = 1, #jobskills do

		local skillClass = GetClass("Skill", jobskills[i])
		if skillClass == nil then
			break
		end

		local row = math.floor((i - 1) / skillsPerALine);
		local col = (i - 1)  % skillsPerALine;
		local x = margin_x + col * (skillimage_width + margin_x_per_eachpic);
		local y = margin_y + row * (skillimage_height + margin_y_per_eachpic);

		local skillslot = skillsGbox:CreateOrGetControl('slot', "SLOT_" .. i, x, y, skillimage_width, skillimage_height);
		skillslot = tolua.cast(skillslot, "ui::CSlot")
		skillslot:ShowWindow(1)
		skillslot:SetOverSound('win_open')

		local icon = CreateIcon(skillslot)
		local iconname = "icon_" .. skillClass.Icon;
		
		icon:SetImage(iconname)
		icon:SetTooltipType('skill');
		icon:SetTooltipStrArg(skillClass.ClassName);
		icon:SetTooltipNumArg(skillClass.ClassID);
		icon:Set(iconname, "Skill", skillClass.ClassID, 1);

		skillslot:SetSkinName('slot');

	end
	
	
	local mbg = frame:GetChild("mbg");
	local jobchangebutton = GET_CHILD(mbg, "class_select", "ui::CButton");
	--skillslot:SetOverSound('win_open')
	local canChangeJob = session.CanChangeJob();

	if canChangeJob == true and CHANGEJOB_CHECK_QUEST_SCP_CONDITION_IGNORE_SELECTEDJOB(jobinfo[stringtest]) == 1 then

		if infotype == CHANGE_JOB_TYPE_HAVE then
			jobchangebutton:ShowWindow(0);
		else
			if CJ_JOB_PROPERTYQUESTCHECK() == 1 then
				if CJ_JOB_GENDERCHECK(jobid) == 1 then
					if session.GetPcTotalJobGrade() <= JOB_CHANGE_MAX_RANK then
						jobchangebutton:SetEventScript(ui.LBUTTONDOWN, 'CJ_CLICK_CHANGEJOBBUTTON')
						jobchangebutton:SetEventScriptArgNumber(ui.LBUTTONDOWN, jobid);	
						jobchangebutton:ShowWindow(1);
					else
						jobchangebutton:ShowWindow(0);
						ui.SysMsg(ScpArgMsg('Auto_aJig_KuHyeonDoeJi_aneun_JeonJig_KweSeuTeuipNiDa.'));
					end
				else
					jobchangebutton:ShowWindow(0);
				end
			else
				jobchangebutton:ShowWindow(0);
			end
		end

	else
		jobchangebutton:ShowWindow(0);
	end
	
end

exechangejobid = 0

function CJ_CLICK_CHANGEJOBBUTTON(frame, slot, argStr, argNum)

	local pc = GetMyPCObject();
	local nowjobName = pc.JobName;
	local nowjobID = GetClass("Job", nowjobName).ClassID;
	local havepts = GetRemainSkillPts(pc, nowjobID);
	
	--if havepts > 0 then 
		--ui.SysMsg(ScpArgMsg('PlzConsumeRemainSkillPts'));
		--return;
	--end

	local jobid = argNum
	local jobinfo = GetClassByType('Job', jobid)

	exechangejobid = jobid
	
	local yesScp = string.format("EXEC_CHANGE_JOB()");
	ui.MsgBox( ScpArgMsg("JobClassSelect").." : {@st41}'"..jobinfo.Name ..ScpArgMsg("Auto__{nl}JeongMalLo_JinHaengHaSiKessSeupNiKka?"), yesScp, "None");

end

function EXEC_CHANGE_JOB()

	control.CustomCommand("CLICK_CHANGEJOB_BUTTON", exechangejobid) 
	ui.CloseFrame('changejob')

end


function UPDATE_CHANGEJOB(frame)	

	local pc = GetMyPCObject();
	local pcjobinfo = GetClass('Job', pc.JobName)
	local pcCtrlType = pcjobinfo.CtrlType

	local charpic = GET_CHILD(frame, "class_image", "ui::CPicture");

	local pcjobinfotype = 0
	local canChangeJob = session.CanChangeJob();

	local clslist, cnt  = GetClassList("Job");
	local index = 0;

	local groupbox_main = frame:GetChild('cjgroupbox_main');
	groupbox_main = tolua.cast(groupbox_main, "ui::CGroupBox");
	groupbox_main:RemoveAllChild();

	

	local maxGradeOfTheJobThatIhad = 0;

	local hadjobarray = {};	
	local mgrade = 0

	if canChangeJob == true then
		mgrade = session.GetPcTotalJobGrade()+1		
	else
		
		for i = 0 , cnt - 1 do
			local cls = GetClassByIndexFromList(clslist, i);
			local ishave = IS_HAD_JOB(cls.ClassID);
			if ishave == 1 then
				if cls.Rank > mgrade then
					mgrade = cls.Rank
				end
			end
		end
	end
	
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
        local jobCircle = session.GetJobGrade(cls.ClassID)
		if cls.MaxCircle > jobCircle then
    		local ishave = IS_HAD_JOB(cls.ClassID);
    		local clsRank = cls.Rank;
    
    		local totaljobcount = session.GetPcTotalJobGrade()
    		local stringtest = 'ChangeJobQuest'..totaljobcount
    		local changejobquestname = cls[stringtest]
    		local flag = 1
    
    		local ChangeJobQuestCircleText = "ChangeJobQuestCircle"..jobCircle+1
    		local pc = GetMyPCObject();
    		local sObj = GetSessionObject(pc, 'ssn_klapeda')
    		
    		if sObj.QSTARTZONETYPE == "StartLine1" then
    			ChangeJobQuestCircleText = ChangeJobQuestCircleText.."_1"	
    		elseif sObj.QSTARTZONETYPE == "StartLine2" then
    			ChangeJobQuestCircleText = ChangeJobQuestCircleText.."_2"
    		end
    		
    		local nowjobID = GetClassByType("Job", cls.ClassID);
    
    
    
    --		if changejobquestname ~= 'None' then
    --			if CHANGEJOB_CHECK_QUEST_SCP_CONDITION_IGNORE_SELECTEDJOB(changejobquestname) ~= 1 then
    --				flag = 0
    --			end
    --		else
    --			flag =0
    --		end
    
    		if ishave == 1 then 
    
    			local subindex = #hadjobarray + 1
    			hadjobarray[subindex] = {}
    			hadjobarray[subindex][1] = cls.ClassID
    
    			if canChangeJob == true then
    				hadjobarray[subindex][2] = CHANGE_JOB_TYPE_CAN_UPGRADE 
    			else
    				hadjobarray[subindex][2] = CHANGE_JOB_TYPE_HAVE 
    			end
    
    			hadjobarray[subindex][3] = cls.Name
    			hadjobarray[subindex][4] = session.GetChangeJobHotRank(cls.ClassName);
    			
    			
    			if jobCircle+1 >= 4 then
    				hadjobarray[subindex][5] = "None"
    			else
    				hadjobarray[subindex][5] = nowjobID[ChangeJobQuestCircleText]
    			end
    
    
    			if pcjobinfo.ClassID == cls.ClassID then
    				pcjobinfotype = hadjobarray[subindex][2]
    			end
    
    		else 
    
    			if cls.CtrlType == pcCtrlType then
    			
    --			local totaljobcount = session.GetPcTotalJobGrade()
    --				local stringtest = 'ChangeJobQuest'..totaljobcount
    --				local changejobquestname = cls[stringtest]
    --				local flag = 1
    --				if changejobquestname ~= 'None' then
    --					if CHANGEJOB_CHECK_QUEST_SCP_CONDITION_IGNORE_SELECTEDJOB(changejobquestname) ~= 1 then
    --						flag = 0
    --					end
    --				end
    
    				if clsRank <= session.GetPcTotalJobGrade()+1 then
    				
    					if clsRank <= session.GetPcTotalJobGrade() then
    						if cls.HiddenJob == "NO" then 						
    						local subindex = #hadjobarray + 1
    						hadjobarray[subindex] = {}
    						hadjobarray[subindex][1] = cls.ClassID	
    						hadjobarray[subindex][2] = CHANGE_JOB_TYPE_HAVE_NOT 
    						hadjobarray[subindex][3] = cls.Name
    						hadjobarray[subindex][4] = session.GetChangeJobHotRank(cls.ClassName);						
    							hadjobarray[subindex][5] = nowjobID[ChangeJobQuestCircleText]	
    						elseif cls.HiddenJob == "YES" then
    							local pcEtc = GetMyEtcObject();
    							if pcEtc["HiddenJob_"..cls.ClassName] == 300 or IS_KOR_TEST_SERVER() then
    							    local questIES = GetClass('QuestProgressCheck',nowjobID[ChangeJobQuestCircleText])
    							    local req_joblvup = SCR_QUEST_CHECK_MODULE_JOBLVUP(pc, questIES)
    							    local req_joblvdown = SCR_QUEST_CHECK_MODULE_JOBLVDOWN(pc, questIES)
    							    if req_joblvup == 'YES' and req_joblvdown == 'YES' then
        								local subindex = #hadjobarray + 1
        								hadjobarray[subindex] = {}
        								hadjobarray[subindex][1] = cls.ClassID	
        								hadjobarray[subindex][2] = CHANGE_JOB_TYPE_NEW 
        								hadjobarray[subindex][3] = cls.Name
        								hadjobarray[subindex][4] = session.GetChangeJobHotRank(cls.ClassName);	
        								hadjobarray[subindex][5] = nowjobID[ChangeJobQuestCircleText]	
        							end
    							end
    						end
    					elseif cls.HiddenJob == "NO" then
    						if canChangeJob == true then
    							local subindex = #hadjobarray + 1
    							hadjobarray[subindex] = {}
    							hadjobarray[subindex][1] = cls.ClassID
    							hadjobarray[subindex][2] = CHANGE_JOB_TYPE_NEW 
    							hadjobarray[subindex][3] = cls.Name
    							hadjobarray[subindex][4] = session.GetChangeJobHotRank(cls.ClassName);							
    							hadjobarray[subindex][5] = nowjobID[ChangeJobQuestCircleText]				
    						end
    					
    					elseif cls.HiddenJob == "YES" then
    						if canChangeJob == true then
    							local pcEtc = GetMyEtcObject();
    							if pcEtc["HiddenJob_"..cls.ClassName] == 300 or IS_KOR_TEST_SERVER() then
    							    local questIES = GetClass('QuestProgressCheck',nowjobID[ChangeJobQuestCircleText])
    							    local req_joblvup = SCR_QUEST_CHECK_MODULE_JOBLVUP(pc, questIES)
    							    local req_joblvdown = SCR_QUEST_CHECK_MODULE_JOBLVDOWN(pc, questIES)
    							    if req_joblvup == 'YES' and req_joblvdown == 'YES' then
        								local subindex = #hadjobarray + 1
        								hadjobarray[subindex] = {}
        								hadjobarray[subindex][1] = cls.ClassID
        								hadjobarray[subindex][2] = CHANGE_JOB_TYPE_NEW 
        								hadjobarray[subindex][3] = cls.Name
        								hadjobarray[subindex][4] = session.GetChangeJobHotRank(cls.ClassName);			
        								hadjobarray[subindex][5] = nowjobID[ChangeJobQuestCircleText]	
        							end
    							end
    						end
    					end
    				end
    			end
    
    
    			if pcjobinfo.ClassID == cls.ClassID then
    				pcjobinfotype = hadjobarray[subindex][2]
    			end
    
    		end
    	end
	end

	
	local firstHotJobID = 0;
	local secontHotJobID = 0;
	local hotCount = 0;
	for i = 1, 2 do
		if i == 2 and #hadjobarray < 4 then		
			break;
		end

		for j = 1, #hadjobarray do
			if hotCount < hadjobarray[j][4] then
				if i == 1 then
					firstHotJobID = hadjobarray[j][1];
					hotCount = hadjobarray[j][4];
				elseif i == 2 and  hadjobarray[j][1] ~= firstHotJobID then
					secontHotJobID = hadjobarray[j][1];
					hotCount = hadjobarray[j][4];
				end				
			end
		end
		hotCount = 0;
	end

	local totaljobgrade = session.GetPcTotalJobGrade()

	
	local jobsPerALine = 3
	local jobbox_width = 280
	local jobbox_height = 134
	local margin_x = 20
	local margin_y = 20
	local sum_margin_y = 40
	local margin_x_per_eachpic = 20
	local margin_y_per_eachpic = 10

	local  drawnewjobcnt = 0
	for i = 1, #hadjobarray do
		if hadjobarray[i][2] ~= CHANGE_JOB_TYPE_HAVE then
			drawnewjobcnt = drawnewjobcnt + 1
		end
	end

	local howmanyline = math.ceil(drawnewjobcnt/jobsPerALine)	
	
	local groupbox_sub_newjob = groupbox_main:CreateOrGetControlSet('groupbox_sub', 'groupbox_sub_newjob', 0, 0)
	groupbox_sub_newjob:Resize(groupbox_sub_newjob:GetWidth(), (howmanyline * (jobbox_height + margin_y_per_eachpic * 11)) + sum_margin_y)

	local rankRollBackBtn = GET_CHILD(groupbox_sub_newjob, 'rankRollBackBtn');
	rankRollBackBtn:ShowWindow(0);

	local cjobGbox = groupbox_sub_newjob:GetChild('changeJobGbox');
	cjobGbox:Resize(groupbox_sub_newjob:GetWidth(),groupbox_sub_newjob:GetHeight() + 10)

	cjobGbox = tolua.cast(cjobGbox, "ui::CGroupBox");
	cjobGbox:RemoveAllChild();

	local changeJob_richtext = groupbox_sub_newjob:GetChild('changeJob_richtext');
	--changeJob_richtext:SetText("{@st44}"..(totaljobgrade+1)..ScpArgMsg("Auto_{@st44}Daeum_LaengKeu_KeulLaeSeu_JeongBo"))
	changeJob_richtext:SetText(ScpArgMsg("Auto_{@st44}Daeum_LaengKeu_KeulLaeSeu_JeongBo"))
	local index =1
	for i = 1, #hadjobarray do

		if hadjobarray[i][2] ~= CHANGE_JOB_TYPE_HAVE then
			
            if session.GetJobGrade(hadjobarray[i][1]) <= 2 then
				local row = math.floor((index - 1) / jobsPerALine);
				local col = (index - 1)  % jobsPerALine;
				local x = margin_x + col * (jobbox_width + margin_x_per_eachpic);
				local y = (cjobGbox:GetHeight() - jobbox_height)  - ( margin_y + row * (jobbox_height + margin_y_per_eachpic));
	
				local subClassCtrl = cjobGbox:CreateOrGetControlSet('jobinfo', hadjobarray[i][2]..'_CJ_A_JOBRANK_'..index , x + 130, y);
				local button = GET_CHILD(subClassCtrl, "button", "ui::CButton");
	
				if hadjobarray[i][2] == CHANGE_JOB_TYPE_CAN_UPGRADE then
					button:SetImage("btn_upclass");	
				elseif hadjobarray[i][2] == CHANGE_JOB_TYPE_HAVE then
					button:SetImage("btn_enclass");	
				elseif hadjobarray[i][2] == CHANGE_JOB_TYPE_HAVE_NOT then
					button:SetImage("btn_unclass");	
				elseif hadjobarray[i][2] == CHANGE_JOB_TYPE_NEW then
					button:SetImage("btn_newclass");	
				else
					print('error')
				end

	
				local jobnameCtrl = GET_CHILD(subClassCtrl, "jobname", "ui::CRichText");
				local jobName = hadjobarray[i][3];

				
				if hadjobarray[i][1] == firstHotJobID or hadjobarray[i][1] == secontHotJobID then
					local charpic = GET_CHILD(subClassCtrl, "hotimg", "ui::CPicture");
					charpic:SetImage("class_hot_img")
				end

				jobnameCtrl:SetTextByKey("param_jobcname", jobName);

				local jobclassCtrl = GET_CHILD(subClassCtrl, "jobclass", "ui::CRichText");
				local jobclass = session.GetJobGrade(hadjobarray[i][1])
		
				if jobclass > 0 then
					button:SetImage("btn_upclass");	
					jobclassCtrl:SetTextByKey("param_jobclass", jobclass+1);
					jobclassCtrl:ShowWindow(1)
				else
					jobclassCtrl:ShowWindow(0)	
				end

				local tempstr = hadjobarray[i][2]..(jobclass+1)
				
				button:SetEventScript(ui.LBUTTONDOWN, 'CJ_CLICK_INFO')
				button:SetEventScriptArgNumber(ui.LBUTTONDOWN, hadjobarray[i][1]);	
				button:SetEventScriptArgString(ui.LBUTTONDOWN, tempstr);	

				index = index +1
			end
		end

		

	end

	
	for i = 0, totaljobgrade-1 do

		local index = totaljobgrade - i
		
		local mains = session.GetMainSession();
		local jobhistorysession = mains.jobHistory
		local jobhistorycount = jobhistorysession:GetJobHistoryCount()

		local groupbox_sub_oldjob = groupbox_main:CreateOrGetControlSet('groupbox_sub', 'groupbox_sub_oldjob'..index, 0, (10 + groupbox_sub_newjob:GetHeight() + 10) + (i * (jobbox_height + 60)) )
		groupbox_sub_oldjob:Resize(groupbox_sub_oldjob:GetWidth(), jobbox_height + margin_y_per_eachpic + sum_margin_y)

		local rankRollBackBtn = GET_CHILD(groupbox_sub_oldjob, 'rankRollBackBtn');
		rankRollBackBtn:ShowWindow(0);

		local cjobGbox = groupbox_sub_oldjob:GetChild('changeJobGbox');
		cjobGbox:Resize(groupbox_sub_oldjob:GetWidth(),groupbox_sub_oldjob:GetHeight())
		cjobGbox = tolua.cast(cjobGbox, "ui::CGroupBox");
		--cjobGbox:RemoveAllChild();

		
		if index == totaljobgrade then

			
			local jobhistory = jobhistorysession:GetJobHistory(index-1);
			local jobinfoclass = GetClassByType('Job', jobhistory.jobID)

		
			local changeJob_richtext = groupbox_sub_oldjob:GetChild('changeJob_richtext');
			--changeJob_richtext:SetTextByKey("rankinfo", index);
			changeJob_richtext:SetTextByKey("rankinfo", index);
			--changeJob_richtext:SetText(ScpArgMsg("Auto_HyeonJae_Jigeop_JeongBo"));

			local subClassCtrl = cjobGbox:CreateOrGetControlSet('jobinfo', 'CJ_A_OLD_JOBRANK_'..index , 150, 25);
			local button = GET_CHILD(subClassCtrl, "button", "ui::CButton");

			
			local jobnameCtrl = GET_CHILD(subClassCtrl, "jobname", "ui::CRichText");
			local jobName = GET_JOB_NAME(jobinfoclass);

			jobnameCtrl:SetTextByKey("param_jobcname", jobName);

			local jobclassCtrl = GET_CHILD(subClassCtrl, "jobclass", "ui::CRichText");
			local jobclass = jobhistory.grade

			if jobclass > 1 then
				
				button:SetImage("btn_upclass");	
				jobclassCtrl:SetTextByKey("param_jobclass", jobclass);
				jobclassCtrl:ShowWindow(1)
			else
				button:SetImage("btn_enclass");	
				jobclassCtrl:ShowWindow(0)
			end

			local starttime = jobhistorysession:GetJobHistoryStartTime_Systime(index-1);
			local strstarttime = GET_DATE_TXT(starttime)

			local jobchange_date_text = cjobGbox:CreateOrGetControl('richtext','jobchange_date', 450, 50, 400, 25);
			jobchange_date_text:SetText(ScpArgMsg("Auto_{@st43}JeonJig_ilJa_:_")..strstarttime);

			local nowjobplaytime = GET_NOW_JOB_PLAYTIME()
			local strplaytime = GET_TIME_TXT(nowjobplaytime)

			local jobchange_playtime_text = cjobGbox:CreateOrGetControl('richtext','jobchange_playtime', 450, 70, 400, 25);
			jobchange_playtime_text:SetText(ScpArgMsg("Auto_{@st43}PeulLei_Taim_:_")..strplaytime);

			local tempstr = CHANGE_JOB_TYPE_HAVE..jobclass

			button:SetEventScript(ui.LBUTTONDOWN, 'CJ_CLICK_INFO')
			button:SetEventScriptArgNumber(ui.LBUTTONDOWN, jobhistory.jobID);	
			button:SetEventScriptArgString(ui.LBUTTONDOWN, tempstr);	
		else

			
			local jobhistory = jobhistorysession:GetJobHistory(index-1);
			local jobinfoclass = GetClassByType('Job', jobhistory.jobID)

			--local groupbox_sub_oldjob = groupbox_main:CreateOrGetControlSet('groupbox_sub', 'groupbox_sub_oldjob'..index, 0, (10 + groupbox_sub_newjob:GetHeight() + 10) + (i * (jobbox_height + 60)) )
			--groupbox_sub_oldjob:Resize(groupbox_sub_oldjob:GetWidth(), jobbox_height + margin_y_per_eachpic + sum_margin_y)

			--local cjobGbox = groupbox_sub_oldjob:GetChild('changeJobGbox');
			--cjobGbox:Resize(groupbox_sub_oldjob:GetWidth(),groupbox_sub_oldjob:GetHeight())
			--cjobGbox = tolua.cast(cjobGbox, "ui::CGroupBox");
			--cjobGbox:RemoveAllChild();

		
			local changeJob_richtext = groupbox_sub_oldjob:GetChild('changeJob_richtext');
			changeJob_richtext:SetTextByKey("rankinfo", index);

			local subClassCtrl = cjobGbox:CreateOrGetControlSet('jobinfo', 'CJ_A_OLD_JOBRANK_'..index , 150, 25);
			local button = GET_CHILD(subClassCtrl, "button", "ui::CButton");

			local jobnameCtrl = GET_CHILD(subClassCtrl, "jobname", "ui::CRichText");
			local jobName = GET_JOB_NAME(jobinfoclass);

			jobnameCtrl:SetTextByKey("param_jobcname", jobName);

			local jobclassCtrl = GET_CHILD(subClassCtrl, "jobclass", "ui::CRichText");
			local jobclass = jobhistory.grade

			if jobclass > 1 then
				
				button:SetImage("btn_upclass");	
				jobclassCtrl:SetTextByKey("param_jobclass", jobclass);
				jobclassCtrl:ShowWindow(1)
			else
				button:SetImage("btn_enclass");	
				jobclassCtrl:ShowWindow(0)
			end

			local starttime = jobhistorysession:GetJobHistoryStartTime_Systime(index-1);
			local strstarttime = GET_DATE_TXT(starttime)

			local jobchange_date_text = cjobGbox:CreateOrGetControl('richtext','jobchange_date', 450, 50, 400, 25);
			jobchange_date_text:SetText(ScpArgMsg("Auto_{@st43}JeonJig_ilJa_:_")..strstarttime);

			local nowjobplaytime = jobhistory.playSecond
			local strplaytime = GET_TIME_TXT(nowjobplaytime)

			local jobchange_playtime_text = cjobGbox:CreateOrGetControl('richtext','jobchange_playtime', 450, 70, 400, 25);
			jobchange_playtime_text:SetText(ScpArgMsg("Auto_{@st43}PeulLei_Taim_:_")..strplaytime);

			local tempstr = CHANGE_JOB_TYPE_HAVE..jobclass
			
			button:SetEventScript(ui.LBUTTONDOWN, 'CJ_CLICK_INFO')
			button:SetEventScriptArgNumber(ui.LBUTTONDOWN, jobhistory.jobID);	
			button:SetEventScriptArgString(ui.LBUTTONDOWN, tempstr);	

		
		end

		
		
	end

	local mains = session.GetMainSession();
	local jobhistorysession = mains.jobHistory
	local jobhistory = jobhistorysession:GetJobHistory(totaljobgrade-1);

	CJ_UPDATE_RIGHT_INFOMATION(frame, pcjobinfo.ClassID,pcjobinfotype,jobhistory.grade)

	local scrollBarCurLine = cjobGbox:GetCurLine();
	cjobGbox:SetCurLine(0);


	frame:Invalidate();
	
end

function GET_NOW_JOB_PLAYTIME()

	local mains = session.GetMainSession();
	local jobhistorysession = mains.jobHistory
	local jobhistorycount = jobhistorysession:GetJobHistoryCount()
	local jobhistorynow = jobhistorysession:GetJobHistory(jobhistorycount-1);
	local beforeplaytime = jobhistorynow.playSecond
	local modetime = session.GetModeTime();
	local temptemp = jobhistorysession:GetDifFromJobHistoryStartTimeAndNowTime(jobhistorycount-1);

	if temptemp < 0 then
		temptemp = 0
	end

	if beforeplaytime == 0 then
		return temptemp
	end

	return beforeplaytime + modetime

end


function CJ_CLICK_INFO(frame, slot, argStr, argNum)

	local tempstring = string.sub(argStr,1,1)
	local tempint = tempstring + 0

	local tempstring2 = string.sub(argStr,2,string.len(argStr))
	local tempint2 = tempstring2 + 0

	if tempint2 > 10 then 
	    tempint2 = 10
	end

	local originalframe = ui.GetFrame("changejob");
	CJ_UPDATE_RIGHT_INFOMATION(originalframe, argNum, tempint,tempint2)
end


function CHANGEJOB_SHOW_RANKROLLBACK()
	local lastJobGrade = session.GetPcTotalJobGrade();
	local pc = GetMyPCObject();
	local frame = ui.GetFrame('changejob');    
    local lastJobBox = GET_CHILD_RECURSIVELY(frame, 'groupbox_sub_oldjob'..lastJobGrade);
    local rankRollBackBtn = GET_CHILD(lastJobBox, 'rankRollBackBtn');
    rankRollBackBtn:ShowWindow(1);

	if pc.LastRankRollbackIndex >= lastJobGrade then
		rankRollBackBtn:SetColorTone('FF444444');
		rankRollBackBtn:SetTextTooltip(ScpArgMsg('CannotBecause{LAST_INDEX}', 'LAST_INDEX', pc.LastRankRollbackIndex));
		rankRollBackBtn:SetUserValue('ENABLE_RANKROLLBACK', 'NO');
	end
end