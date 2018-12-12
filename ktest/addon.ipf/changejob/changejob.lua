function CHANGEJOB_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg('GAME_START', 'CHANGEJOB_GAMESTART');
	addon:RegisterMsg('JOB_HISTORY_UPDATE', 'UPDATE_CHANGEJOB');
	addon:RegisterMsg('CHANGE_CLIENT_SIZE', 'CHANGEJOB_SIZE_UPDATE');
	addon:RegisterMsg('UPDATE_CLASS_RESET_POINT_INFO', 'ON_UPDATE_CLASS_RESET_POINT_INFO');
end

function CHANGEJOB_SIZE_UPDATE(frame)	
	if ui.GetSceneHeight() / ui.GetSceneWidth() <= ui.GetClientInitialHeight() / ui.GetClientInitialWidth() then
		frame:Resize(ui.GetSceneWidth() * ui.GetClientInitialHeight() / ui.GetSceneHeight() ,ui.GetClientInitialHeight())
	end
	frame:Invalidate();
end

local function ENABLE_JOB_SELECT_GUIDE(frame, isEnable)
	local jobSelectBox = GET_CHILD_RECURSIVELY(frame, 'jobSelectBox');
	jobSelectBox:SetVisible(isEnable);
end

function CHANGEJOB_OPEN(frame)
	session.job.ReqClassResetPoint();	
	CHANGEJOB_SIZE_UPDATE(frame)
	UPDATE_CHANGEJOB(frame);	
	ENABLE_JOB_SELECT_GUIDE(frame, 0);
	CHANGEJOB_CLOSE_ROLLBACK_MODE(frame);
end


function CHANGEJOB_CLOSE(frame)

end


function CHANGEJOB_GAMESTART(frame)

	CHANGEJOB_SIZE_UPDATE(frame);
	UPDATE_CHANGEJOB(frame);

end

function IS_HAD_JOB(id)
	local myJobList = GetMyJobList();
	for i = 1, #myJobList do
		if myJobList[i] == id then
			return true;
		end
	end
	return false;
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
	
	local pc = GetMyPCObject();
	if IS_KANNUSHI_GENDER_CHANGE_FLAG(pc, jobinfo.ClassName) == 'YES' then
	    return 1;
	end
	

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

local function _SET_PLAYTIME_TOOLTIP(ctrl, playTime, startTime)
	local text = string.format('%s%s{nl}%s%s', ClMsg('Auto_{@st43}JeonJig_ilJa_:_'), GET_DATE_TXT(startTime), ClMsg('Auto_{@st43}PeulLei_Taim_:_'), GET_TIME_TXT(playTime));
	ctrl:SetTextTooltip(text);
end

local function UPDATE_CURRENT_CLASSTREE_INFO(frame)
	local pc = GetMyPCObject();
	local mainSession = session.GetMainSession();
	local pcJobInfo = mainSession.pcJobInfo;
	local jobCount = pcJobInfo:GetJobCount();
	local jobHistoryList = {};
	for i = 0, jobCount - 1 do
		local jobHistory = pcJobInfo:GetJobInfoByIndex(i);		
		jobHistoryList[#jobHistoryList + 1] = {
			JobClassID = jobHistory.jobID, JobSequence = jobHistory.index, PlayTime = jobHistory:GetPlaySecond(), 
			StartTime = imcTime.ImcTimeToSysTime(jobHistory.startTime);
		};
	end
	table.sort(jobHistoryList, function(lhs, rhs)
			return lhs.JobSequence < rhs.JobSequence;
		end);

	local SHOW_MAX_RANK = 4;
	local FIRST_JOB_NAME_STYLE = frame:GetUserConfig('FIRST_JOB_NAME_STYLE');
	local JOB_NAME_STYLE = frame:GetUserConfig('JOB_NAME_STYLE');
	for i = 1, SHOW_MAX_RANK do		
		local jobCtrlset = GET_CHILD_RECURSIVELY(frame, 'curJobSet_'..i);
		local jobInfo = jobHistoryList[i];
		local jobCls = nil;
		if jobInfo ~= nil then
			jobCls = GetClassByType('Job', jobInfo.JobClassID);
			local jobNameText = GET_CHILD(jobCtrlset, 'jobNameText');			
			jobNameText:SetTextByKey('name', GET_JOB_NAME(jobCls, GETMYPCGENDER()));			
			if i == 1 then
				jobNameText:SetTextByKey('style', FIRST_JOB_NAME_STYLE);
			else
				jobNameText:SetTextByKey('style', JOB_NAME_STYLE);
			end

			local jobEmblemPic = GET_CHILD(jobCtrlset, 'jobEmblemPic');
			jobEmblemPic:SetImage(jobCls.Icon);
			_SET_PLAYTIME_TOOLTIP(jobEmblemPic, jobInfo.PlayTime, jobInfo.StartTime);

			jobCtrlset:ShowWindow(1);
		else
			jobCtrlset:ShowWindow(0);
		end

		local rankRollBackBtn = GET_CHILD(jobCtrlset, 'rankRollBackBtn');
		local infoPic = GET_CHILD(jobCtrlset, 'infoPic');
		infoPic:ShowWindow(0);
		if i == 1 then
			rankRollBackBtn:ShowWindow(0);			
		elseif jobInfo ~= nil then
			rankRollBackBtn:ShowWindow(1);			
			rankRollBackBtn:SetEventScript(ui.LBUTTONDOWN, 'RANKROLLBACK_BTN_CLICK');
			rankRollBackBtn:SetEventScriptArgNumber(ui.LBUTTONDOWN, jobInfo.JobClassID);

			if jobCls ~= nil then
				local PrecheckScp = _G['SCR_RANK_ROLLBACK_PRECHECK_'..jobCls.EngName];
				if PrecheckScp ~= nil and PrecheckScp(pc) == false then
					infoPic:ShowWindow(1);
				end
			end
		end
	end
end

local function _UPDATE_JOB_STAT_RATIO(frame, jobCls)
	local function SetJobStatRatio(statType, jobCls)
		local statText = GET_CHILD_RECURSIVELY(frame, 'statRatioText_'..statType);
		statText:SetTextByKey('ratio', string.format('%.1f', jobCls[statType] / 2));
	end
	SetJobStatRatio('STR', jobCls);
	SetJobStatRatio('INT', jobCls);
	SetJobStatRatio('CON', jobCls);
	SetJobStatRatio('MNA', jobCls);
	SetJobStatRatio('DEX', jobCls);
end

function CJ_UPDATE_RIGHT_INFOMATION(frame, jobid)
	frame = frame:GetTopParentFrame();
	frame:SetUserValue('CUR_SELECT_RIGHT_JOB_ID', jobid);

	UPDATE_CURRENT_CLASSTREE_INFO(frame);
	
	local jobinfo = GetClassByType('Job', jobid);
	local totaljobcount = session.GetPcTotalJobGrade()
	local stringtest = 'ChangeJobQuest'..totaljobcount	
	local myIconInfo = info.GetIcon( session.GetMyHandle() );
	local headIndex = myIconInfo:GetHeadIndex();	
	local charpic = GET_CHILD_RECURSIVELY(frame, "class_image");
	local charimgName = ui.CaptureFullStdImage(jobid, GETMYPCGENDER(), headIndex);
	charpic:SetImage(charimgName);

	local jobclassname_richtext = GET_CHILD_RECURSIVELY(frame, "className");
	jobclassname_richtext:SetTextByKey("param_name", GET_JOB_NAME(jobinfo, GETMYPCGENDER()));

	local captionstr = 'Caption1';
	local jobclasscaption_richtext = GET_CHILD_RECURSIVELY(frame, "classExplain");
	jobclasscaption_richtext:SetTextByKey("param_explain", jobinfo[captionstr]);

	local skillsGbox = GET_CHILD_RECURSIVELY(frame, 'groupbox_skills');
	skillsGbox:RemoveAllChild();

	local jobskills = {}
	local clslist, cnt  = GetClassList("SkillTree");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);

		local checkJobName = jobinfo.ClassName .. '_';
		if string.find(cls.ClassName, checkJobName) ~= nil then
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
		local skillClass = GetClass("Skill", jobskills[i]);
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
		local skl = session.GetSkillByName(skillClass.ClassName);
		if skl ~= nil then
			icon:SetTooltipIESID(skl:GetIESID());
		end
		icon:Set(iconname, "Skill", skillClass.ClassID, 1);

		skillslot:SetSkinName('slot');
	end		
		
	local mbg = frame:GetChild("mbg");
	local jobchangebutton = GET_CHILD(mbg, "class_select", "ui::CButton");
	local canChangeJob = session.CanChangeJob();
	local rollbackInfoBox = GET_CHILD_RECURSIVELY(frame, 'rollbackInfoBox');
	local isClassChangeMode = rollbackInfoBox:IsVisible() == 1;
	if isClassChangeMode == true then
		canChangeJob = true;
	end	

	if IS_HAD_JOB(jobinfo.ClassID) == true then
		canChangeJob = false;
	end
    jobchangebutton:SetEnable(0);
    
    local jobCircleValue = session.GetJobGrade(jobinfo.ClassID);    
--    if jobinfo.HiddenJob == "YES" then
--    	local pcEtc = GetMyEtcObject();
--    	if pcEtc["HiddenJob_"..jobinfo.ClassName] ~= 300 and IS_KOR_TEST_SERVER() == false then
--    	    return;
--    	end
--	end

	local charImgBox = GET_CHILD_RECURSIVELY(frame, 'charImgBox');
	local jobEmblemPic = GET_CHILD(charImgBox, 'jobEmblemPic');
	jobEmblemPic:SetImage(jobinfo.Icon);

	_UPDATE_JOB_STAT_RATIO(frame, jobinfo);

    local pc = GetMyPCObject();
    local preFuncName = TryGetProp(jobinfo, 'PreFunction')
    if preFuncName ~= nil and preFuncName ~= 'None' then
        local preFunc = _G[preFuncName]
		if preFunc ~= nil then
			local jobCount = GetTotalJobCount(pc);
			if isClassChangeMode == true then
				jobCount = jobCount - 1;
			end
			local result = preFunc(pc, jobCount);			
            if result == 'NO' then
                return;
            end
        end
	end

	if canChangeJob == true and CHANGEJOB_CHECK_QUEST_SCP_CONDITION_IGNORE_SELECTEDJOB(jobinfo[stringtest]) == 1 then
		if CJ_JOB_PROPERTYQUESTCHECK() == 1 then
			if CJ_JOB_GENDERCHECK(jobid) == 1 then
				if isClassChangeMode or session.GetPcTotalJobGrade() < JOB_CHANGE_MAX_RANK then
					jobchangebutton:SetEventScript(ui.LBUTTONDOWN, 'CJ_CLICK_CHANGEJOBBUTTON')
					jobchangebutton:SetEventScriptArgNumber(ui.LBUTTONDOWN, jobid);	
					jobchangebutton:SetEnable(1);
				else
					jobchangebutton:SetEnable(0);						
				end
			else
				jobchangebutton:SetEnable(0);
			end
		else
			jobchangebutton:SetEnable(0);
		end
	else
		jobchangebutton:SetEnable(0);
	end	
end

exechangejobid = 0

local function _EXCHANGE_JOB(frame, destJobID)
	frame = frame:GetTopParentFrame();
	local scrJob = frame:GetUserIValue('EXCHANGE_SRC_JOB');
    ui.CloseFrame('changejob');

	frame = ui.GetFrame("rankrollback");	
	frame:SetUserValue('TARGET_JOB_CLASS_ID', scrJob);
	frame:SetUserValue('DEST_JOB_CLASS_ID', destJobID)
	frame:ShowWindow(1);
	RANKROLLBACK_CHECK_PLAYER_STATE(frame);
end

function CJ_CLICK_CHANGEJOBBUTTON(frame, slot, argStr, argNum)	
	local pc = GetMyPCObject();
	local nowjobName = pc.JobName;
	local nowjobID = GetClass("Job", nowjobName).ClassID;
	local havepts = GetRemainSkillPts(pc, nowjobID);	
	local jobid = argNum
	local jobinfo = GetClassByType('Job', jobid);

	local rollbackInfoBox = GET_CHILD_RECURSIVELY(frame:GetTopParentFrame(), 'rollbackInfoBox');
	if rollbackInfoBox:IsVisible() == 1 then
		_EXCHANGE_JOB(frame, jobid);
		return;
	end

	exechangejobid = jobid
	
	local yesScp = string.format("EXEC_CHANGE_JOB()");
	ui.MsgBox( ScpArgMsg("JobClassSelect").." : {@st41}'"..GET_JOB_NAME(jobinfo, GETMYPCGENDER()) ..ScpArgMsg("Auto__{nl}JeongMalLo_JinHaengHaSiKessSeupNiKka?"), yesScp, "None");

end

function EXEC_CHANGE_JOB()

	control.CustomCommand("CLICK_CHANGEJOB_BUTTON", exechangejobid) 
	ui.CloseFrame('changejob')

end

local function IS_NEW_JOB(jobCls)
	if jobCls.ClassName == 'Char5_2' or jobCls.ClassName == 'Char5_3' then
		return true;
	end
	return false;
end

local function TRANS_BOOLEAN(number)
	if number == 0 then
		return false;
	end
	return true;
end

function UPDATE_CHANGEJOB(frame)
	local pc = GetMyPCObject();
	local pcjobinfo = GetClass('Job', pc.JobName)
	local pcCtrlType = pcjobinfo.CtrlType

	local charpic = GET_CHILD(frame, "class_image", "ui::CPicture");

	local pcjobinfotype = 0
	local canChangeJob = session.CanChangeJob();

	local groupbox_main = GET_CHILD_RECURSIVELY(frame, 'cjgroupbox_main');
	groupbox_main = tolua.cast(groupbox_main, "ui::CGroupBox");
	groupbox_main:RemoveAllChild();
	
	local function _IS_SATISFIED_HIDDEN_JOB_TRIGGER(jobCls)	
		local preFuncName = TryGetProp(jobCls, 'PreFunction', 'None');
		if jobCls.HiddenJob == 'NO' then
			return true;
		end

		if preFuncName == 'None' then
			return true;
		end
	--	if jobCls.HiddenJob == "YES" then
	--    	local pcEtc = GetMyEtcObject();
	--    	if pcEtc["HiddenJob_"..jobCls.ClassName] ~= 300 and IS_KOR_TEST_SERVER() == false then
	--    	    return false;
	--    	end
	--	end
		return false;
	end

	local jobInfos = {};
	local forHotJobList = {};
	local jobList, jobCnt = GetClassList("Job");
	for i = 0, jobCnt - 1 do
		local jobCls = GetClassByIndexFromList(jobList, i);
		if pcCtrlType == jobCls.CtrlType and jobCls.Rank <= JOB_CHANGE_MAX_RANK then			
			jobInfos[#jobInfos + 1] = { JobClassID = jobCls.ClassID,
										IsHave = IS_HAD_JOB(jobCls.ClassID),
										IsNew = IS_NEW_JOB(jobCls),
										HotCount = session.GetChangeJobHotRank(jobCls.ClassName),
										IsSatisfiedHiddenQuest = _IS_SATISFIED_HIDDEN_JOB_TRIGGER(jobCls)};
										
			forHotJobList[#forHotJobList + 1] = { JobClassID = jobCls.ClassID, HotCount = session.GetChangeJobHotRank(jobCls.ClassName) };
		end
	end
	table.sort(forHotJobList, function(lhs, rhs)
			return lhs.HotCount > rhs.HotCount; -- 내림차순
		end);

	local jobSelectBox = GET_CHILD_RECURSIVELY(frame, 'jobSelectBox');
	local job_select_guide_start = jobSelectBox:CreateOrGetControlSet("job_select_guide_start", "job_select_guide_start", 0, 0);
	AUTO_CAST(job_select_guide_start)
	local job_pic = GET_CHILD_RECURSIVELY(job_select_guide_start, "job_pic");
	local jobSelectGuideImg = job_select_guide_start:GetUserConfig("Icon_"..pcCtrlType);
	job_pic:SetImage(jobSelectGuideImg);

	local totaljobgrade = session.GetPcTotalJobGrade()
	local jobsPerALine = 3
	local jobbox_width = 280
	local jobbox_height = 134
	local margin_x = 20
	local margin_y = 0
	local sum_margin_y = 40
	local margin_x_per_eachpic = tonumber(frame:GetUserConfig('CLASS_CTRLSET_MARGIN_X'));
	local margin_y_per_eachpic = tonumber(frame:GetUserConfig('CLASS_CTRLSET_MARGIN_Y'));

	local BUTTON_IMG_NEW_JOB = frame:GetUserConfig('BUTTON_IMG_NEW_JOB');
	local BUTTON_IMG_HAVE_JOB = frame:GetUserConfig('BUTTON_IMG_HAVE_JOB');
	local BUTTON_IMG_HIDDEN_JOB = frame:GetUserConfig('BUTTON_IMG_HIDDEN_JOB');
	local BUTTON_IMG_DEFAULT = frame:GetUserConfig('BUTTON_IMG_DEFAULT');
	local BUTTON_IMG_HAD_HIDDEN_JOB = frame:GetUserConfig('BUTTON_IMG_HAD_HIDDEN_JOB');

	local groupbox_sub_newjob = groupbox_main:CreateOrGetControlSet('groupbox_sub', 'groupbox_sub_newjob', 0, 0);
	local cjobGbox = GET_CHILD(groupbox_sub_newjob, 'changeJobGbox');
	cjobGbox:RemoveAllChild();

	local changeJob_richtext = GET_CHILD_RECURSIVELY(frame, 'changeJob_richtext');
	changeJob_richtext:SetText(ScpArgMsg("Auto_{@st44}Daeum_LaengKeu_KeulLaeSeu_JeongBo"));	
	changeJob_richtext:SetGravity(ui.LEFT, ui.TOP);
	changeJob_richtext:SetOffset(30, 10);

	local labelline = GET_CHILD_RECURSIVELY(frame, 'labelline');
	labelline:SetGravity(ui.LEFT, ui.TOP);
	labelline:SetOffset(30, changeJob_richtext:GetHeight() + 18);

	local totalHeight = 0;
	for i = 1, #jobInfos do
		local info = jobInfos[i];
		local row = math.floor((i - 1) / jobsPerALine);
		local col = (i - 1) % jobsPerALine;
		local x = margin_x + col * (jobbox_width + margin_x_per_eachpic);
		local y = margin_y + row * (jobbox_height + margin_y_per_eachpic);			

		local jobCls = GetClassByType('Job', info.JobClassID);
		local subClassCtrl = cjobGbox:CreateOrGetControlSet('jobinfo', 'JOB_INFO_'..jobCls.ClassName , x, y);
		local button = GET_CHILD(subClassCtrl, "button");

		-- button img
		if info.IsHave == true then
		    local preFuncName = TryGetProp(jobCls, 'PreFunction', 'None')
			if jobCls.HiddenJob == 'YES' and preFuncName ~= 'None'  then
				button:SetImage(BUTTON_IMG_HAD_HIDDEN_JOB);
			else
				button:SetImage(BUTTON_IMG_HAVE_JOB);
			end
		elseif info.IsSatisfiedHiddenQuest == false then
			button:SetImage(BUTTON_IMG_HIDDEN_JOB);
		else
			button:SetImage(BUTTON_IMG_DEFAULT);
		end
		
		-- hot tag
		local charpic = GET_CHILD(subClassCtrl, "hotimg");
		charpic:ShowWindow(0);
		if info.HotCount > 0 then
			local numberOfShowHot = math.min(2, #forHotJobList);
			for hotIter = 1, numberOfShowHot do
				if forHotJobList[hotIter].JobClassID == info.JobClassID then
					charpic:ShowWindow(1);
				end
			end
		end
		if info.IsNew == true then
			charpic:SetImage(BUTTON_IMG_NEW_JOB);
			charpic:ShowWindow(1);
		end

		-- name			
		local jobnameCtrl = GET_CHILD(subClassCtrl, "jobname");
		jobnameCtrl:SetTextByKey("param_jobcname", GET_JOB_NAME(jobCls, GETMYPCGENDER()));
				
		button:SetEventScript(ui.LBUTTONDOWN, 'CJ_CLICK_INFO')
		button:SetEventScriptArgNumber(ui.LBUTTONDOWN, info.JobClassID);

		totalHeight = y + subClassCtrl:GetHeight();
	end
	groupbox_sub_newjob:Resize(groupbox_sub_newjob:GetWidth(), totalHeight + 30);

	local mains = session.GetMainSession();
	local jobhistorysession = mains.pcJobInfo;
	local jobhistory = jobhistorysession:GetJobInfoByIndex(totaljobgrade-1);

	CJ_UPDATE_RIGHT_INFOMATION(frame, pcjobinfo.ClassID);

	local scrollBarCurLine = cjobGbox:GetCurLine();
	cjobGbox:SetCurLine(0);
end

function CJ_CLICK_INFO(frame, slot, argStr, jobClsID)
	local originalframe = ui.GetFrame("changejob");
	CJ_UPDATE_RIGHT_INFOMATION(originalframe, jobClsID);
end

function CHANGEJOB_SHOW_RANKROLLBACK()
	local lastJobGrade = session.GetPcTotalJobGrade();
	local pc = GetMyPCObject();
	local frame = ui.GetFrame('changejob');
end

function ON_CHANGE_JOB_SELECT_GUIDE_START(frame, btn)
	ui.CloseFrame("changejob")
	ui.OpenFrame("job_select_guide");
end

function ON_UPDATE_CLASS_RESET_POINT_INFO(frame, msg, argStr, argNum)	
	local curExp = session.job.GetClassResetPointExp();
	local curGainExp = session.job.GetClassResetPointGainExp();	

	-- weekly exp
	local weeklyMaxExp = GET_MAX_WEEKLY_CLASS_RESET_POINT_EXP();
	local weelyGainExpText = GET_CHILD_RECURSIVELY(frame, 'weelyGainExpText');
	weelyGainExpText:SetTextByKey('cur', curGainExp);
	weelyGainExpText:SetTextByKey('max', weeklyMaxExp);

	-- gauge
	local maxExp = GET_MAX_CLASS_RESET_POINT_EXP();
	local resetGauge = GET_CHILD_RECURSIVELY(frame, 'resetGauge');
	local targetExp = curExp + (weeklyMaxExp - curGainExp);
	resetGauge:SetPoint(targetExp, maxExp);

	local resetExpGauge = GET_CHILD_RECURSIVELY(frame, 'resetExpGauge');
	local curAvailableExp = curExp;
	resetExpGauge:SetPoint(curAvailableExp, maxExp);

	-- count
	local myResetPointText = GET_CHILD_RECURSIVELY(frame, 'myResetPointText');
	local availableCount = math.floor(curAvailableExp / weeklyMaxExp);
	myResetPointText:SetTextByKey('count', availableCount);
	
	local CLASS_RESET_EXP_ON_IMG = frame:GetUserConfig('CLASS_RESET_EXP_ON_IMG');
	local CLASS_RESET_EXP_OFF_IMG = frame:GetUserConfig('CLASS_RESET_EXP_OFF_IMG');
	local MAX_AVAILABLE_COUNT = 3;
	for i = 1, MAX_AVAILABLE_COUNT do
		local availablePic = GET_CHILD_RECURSIVELY(frame, 'availablePic_'..i);
		if i <= availableCount then
			availablePic:SetImage(CLASS_RESET_EXP_ON_IMG);
		else
			availablePic:SetImage(CLASS_RESET_EXP_OFF_IMG);
		end
	end
end

function RANKROLLBACK_BTN_CLICK(parent, ctrl, argStr, srcJobID)
	local frame = parent:GetTopParentFrame();
	local rollbackInfoBox = GET_CHILD_RECURSIVELY(frame, 'rollbackInfoBox');
	rollbackInfoBox:ShowWindow(1);
	frame:SetUserValue('EXCHANGE_SRC_JOB', srcJobID);

	local arrowPic = GET_CHILD(rollbackInfoBox, 'arrowPic');
	imcUIAnim:PlayMoveExponential(arrowPic, 'right', true, 50, 0.005, true);
end

function CHANGEJOB_CLOSE_ROLLBACK_MODE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local rollbackInfoBox = GET_CHILD_RECURSIVELY(frame, 'rollbackInfoBox');
	rollbackInfoBox:ShowWindow(0);
	CJ_UPDATE_RIGHT_INFOMATION(frame, frame:GetUserIValue('CUR_SELECT_RIGHT_JOB_ID'));
end

function CHANGEJOB_ON_ESCAPE(frame)
	local rollbackInfoBox = GET_CHILD_RECURSIVELY(frame, 'rollbackInfoBox');
	if rollbackInfoBox:IsVisible() == 1 then
		rollbackInfoBox:ShowWindow(0);
		return;
	end
	ui.CloseFrame('changejob');
end