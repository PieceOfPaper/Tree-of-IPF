-- skilltree.lua

function SKILLTREE_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg('GAME_START', 'SKILLLIST_GAMESTART');
	addon:RegisterOpenOnlyMsg('RESET_SKL_UP', 'RESERVE_SKLUP_RESET');

	addon:RegisterMsg('JOB_CHANGE', 'SKILLTREE_ON_JOB_CHANGE');
	addon:RegisterMsg('UPDATE_SKILLMAP', 'UPDATE_SKILLTREE');
	addon:RegisterMsg('SKILL_LIST_GET', 'UPDATE_SKILLTREE');
	addon:RegisterMsg('ABILITY_LIST_GET', 'UPDATE_SKILLTREE');
	addon:RegisterMsg('SKILL_PROP_UPDATE', 'UPDATE_SKILLTREE');

	addon:RegisterMsg('RESET_ABILITY_UP', 'UPDATE_ABILITYLIST');
	addon:RegisterMsg('RESET_ABILITY_ACTIVE', 'REFRESH_SKILL_TREE');
end

function UI_TOGGLE_SKILLTREE()
	if app.IsBarrackMode() == true then
		return;
	end

	ui.ToggleFrame('skilltree')

end

function SKILL_TREE_SET_TARGET_CHAR_ID(cid)

	local frame = ui.GetFrame("skilltree");
	frame:SetUserValue("TARGET_CID", cid);
	SKILLTREE_OPEN(frame);

end

function SKILLTREE_ON_JOB_CHANGE(frame)

    local job = info.GetJob(session.GetMyHandle());
	session.SetUserConfig("SELECT_SKLTREE", job);
	UPDATE_SKILLTREE(frame)
end

function SKILLTREE_OPEN(frame)
	
	frame:Invalidate();
	local questInfoSetFrame = ui.GetFrame('questinfoset_2');
	if questInfoSetFrame:IsVisible() == 1 then
		questInfoSetFrame:ShowWindow(0);
	end

	frame:SetUserValue("CLICK_ABIL_ACTIVE_TIME", imcTime.GetAppTime());
	REFRESH_SKILL_TREE(frame);

	local skilltreegbox = GET_CHILD_RECURSIVELY(frame,'skilltree_pip')
	skilltreegbox:SetScrollPos(0);

end

function SKILLTREE_CLOSE(frame)
	local questInfoSetFrame = ui.GetFrame('questinfoset_2');
	if questInfoSetFrame:IsVisible() == 0 and ui.IsVisibleFramePIPType('SKILLTREE') == false then
		questInfoSetFrame:ShowWindow(1);
	end

	ROLLBACK_SKILL(frame);
end

function UPDATE_ABILITYLIST(frame, msg, argStr, argNum)

	if msg == 'RESET_ABILITY_UP' then
		local learnAbilID = argNum;
		if learnAbilID == 0 then
			local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
			timer:Stop();
		end
	end

	REFRESH_SKILL_TREE(frame);
	frame:Invalidate();
end

function MAKE_CLASS_INFO_LIST(frame)

	local clslist, cnt  = GetClassList("Job");

	local canChangeJob = session.CanChangeJob();
	local haveJobNameList = {};
	local haveJobGradeList = {};


	local nowjob = info.GetJob(session.GetMyHandle());
	local nowjName = GetClassString('Job', nowjob, 'Name');

	local nowjNameRtxt = GET_CHILD_RECURSIVELY(frame, 'nowJobName', 'ui::CRichText')
	local nowjNametext = nowjName;
	nowjNameRtxt:SetText('{@st41}{s20}'..nowjNametext)

	local grid = GET_CHILD_RECURSIVELY(frame, 'skill', 'ui::CGrid')
	grid:SetForbidClose(true)
	grid:RemoveAllChild();

	local cid = frame:GetUserValue("TARGET_CID");
	local pcSession = session.GetSessionByCID(cid);
	local pcJobInfo = pcSession.pcJobInfo;

	local lastclassCtrlcount = 0
	local cnt = pcJobInfo:GetJobCount();

	for i = 0 , cnt - 1 do
		local jobID = pcJobInfo:GetJobByIndex(i);
		if jobID == -1 then
			break;
		end

		local cls = GetClassByTypeFromList(clslist, jobID);
		if cls == nil then
			break;
		end

		local classCtrl = grid:CreateOrGetControlSet('classtreeIcon', 'classCtrl_'..cls.ClassName, 0, 0);
		classCtrl:ShowWindow(1);

		classCtrl:SetEventScript(ui.LBUTTONUP, "OPEN_SKILL_INFO");
		classCtrl:SetEventScriptArgString(ui.LBUTTONUP, cls.ClassName);
		classCtrl:SetEventScriptArgNumber(ui.LBUTTONUP, cls.ClassID);
		classCtrl:SetOverSound("button_over")
		classCtrl:SetClickSound("button_click_3")
		local selectJobID = session.GetUserConfig("SELECT_SKLTREE", 0);
		if selectJobID == 0 then
			INSERT_SKILL_TREE(frame, jobID)
		end

		local classSlot = GET_CHILD(classCtrl, "slot", "ui::CSlot");
		classSlot:EnableHitTest(0)
		--classSlot:SetEventScript(ui.LBUTTONUP, "OPEN_SKILL_INFO");
		--classSlot:SetEventScriptArgString(ui.LBUTTONUP, cls.ClassName);
		--classSlot:SetEventScriptArgNumber(ui.LBUTTONUP, cls.ClassID);
		local selectedarrowPic = GET_CHILD(classCtrl, "selectedarrow", "ui::CPicture");
		selectedarrowPic:ShowWindow(0)

		local icon = CreateIcon(classSlot);
		local iconname = cls.Icon;
		icon:SetImage(iconname);
		
		local upCtrl = GET_CHILD(classCtrl, "upbtn", "ui::CButton");
		--upCtrl:SetImage('skill_up_btn');
		upCtrl:SetEventScript(ui.LBUTTONUP, "CLASS_PTS_UP");
		upCtrl:SetEventScriptArgString(ui.LBUTTONUP, cls.ClassID);
		upCtrl:SetOverSound('button_over');
		local classLv = pcJobInfo:GetJobGrade(jobID);
		upCtrl:SetEventScriptArgNumber(ui.LBUTTONUP, classLv);
		upCtrl:SetClickSound("button_click_skill_up");
		--upCtrl:ShowWindow(0);

		-- 클래스 렙업이 가능하면 upCtrl보여주기. 테스트용
		local curLv = session.GetUserConfig("CLASSUP_" .. cls.ClassName, 0);
		if canChangeJob == false or curLv >= cls.MaxLevel * classLv then
			upCtrl:ShowWindow(0);
		else
			upCtrl:ShowWindow(1);
		end
		upCtrl:ShowWindow(0);

		-- 클래스 이름
		local nameCtrl = GET_CHILD(classCtrl, "name", "ui::CRichText");
		nameCtrl:SetText("{@st41}".. cls.Name);

		-- 클래스 레벨 (★로 표시)
		local levelCtrl = GET_CHILD(classCtrl, "level", "ui::CRichText");
		local levelFont = frame:GetUserConfig("Font_Normal");
		session.SetUserConfig("CLASSUP_" .. cls.ClassName, classLv);

		local startext = ""
		for i = 1 , 3 do
			if i <= classLv then
				startext = startext .. ("{img star_in_arrow 20 20}")
			else
				startext = startext .. ("{img star_out_arrow 20 20}")
			end
		end

		levelCtrl:SetText(startext);

		-- 아래에서 전직가능한 클래스 그릴때 이미 배운클래스는 예외처리하려고 haveJobNameList 추가함
		haveJobNameList[#haveJobNameList+1] = cls.ClassName;
		haveJobGradeList[#haveJobGradeList+1] = classLv;

		lastclassCtrlcount = lastclassCtrlcount + 1
	end

	local detailypos = (math.floor((lastclassCtrlcount - 1) /3) + 1) * 140

	local detail = GET_CHILD_RECURSIVELY(frame,'detailGBox','ui::CGroupBox')
	detail:SetOffset(detail:GetOriginalX(),grid:GetY() + detailypos)
end

-- 서버에 전직 요청
function SCR_CHANGE_JOB(jobID)
	packet.ReqChangeJob(jobID);
end

-- 클래스렙 업글 or 배우기
function CLASS_PTS_UP(frame, control, clsID, level)

	local clslist, cnt  = GetClassList("Job");
	local cls = GetClassByTypeFromList(clslist, clsID);
	if cls == nil then
		return;
	end

	if level == nil then
		level = 0;
	end

	local yesScp = string.format("SCR_CHANGE_JOB(%d)", clsID);
	local txt = "";
	if level > 0 then
		txt = cls.Name.. ScpArgMsg("Auto__KeulLaeSeuLeul_LeBeleopHaSiKessSeupNiKka?");
	else
		txt = cls.Name .. ScpArgMsg("Auto__KeulLaeSeuLeul_BaeuSiKessSeupNiKka?");
	end
	ui.MsgBox(txt, yesScp, "None");

end

function OPEN_SKILL_INFO(frame, control, jobName, jobID, isSkillInfoRollBack)

	frame = frame:GetTopParentFrame();	
	local cid = frame:GetUserValue("TARGET_CID");
	local pc = GetPCObjectByCID(cid);
	if pc == nil then
		return;
	end

	-- 애니메이션 기능 넣어줘야하는데 그건 UI기능 정리된후 나중에...
	session.SetUserConfig("SELECT_SKLTREE", jobID);
	if isSkillInfoRollBack ~= 0 then
		ROLLBACK_SKILL(frame);
	end
	local parentFrame = frame:GetTopParentFrame();

	local treelist = {};
	GET_TREE_INFO_LIST(frame, jobName, treelist);

	local grid = GET_CHILD_RECURSIVELY(parentFrame, "skill", "ui::CGrid");
	
	-- 선택한 직업 아래 화살표 그려주기
	local pcSession = session.GetSessionByCID(cid);
	local pcJobInfo = pcSession.pcJobInfo;
	local clslist, cnt  = GetClassList("Job");
	local jobCnt = pcJobInfo:GetJobCount();
	for i = 0 , jobCnt - 1 do
		local jobID = pcJobInfo:GetJobByIndex(i);
		if jobID == -1 then
			break;
		end

		local cls = GetClassByTypeFromList(clslist, jobID);
		if cls == nil then
			break;
		end

		local classctrl = GET_CHILD(grid, 'classCtrl_'..cls.ClassName, "ui::CControlSet");

		if classctrl ~= nil then
			local arrowPic = GET_CHILD(classctrl, 'selectedarrow', 'ui::CPicture')
			if cls.ClassName == jobName then
				
				arrowPic:ShowWindow(1)
			else
				arrowPic:ShowWindow(0)
			end
		end
		
	end
	
	local detailName = 'classCtrl_'..jobName
	local detail = GET_CHILD_RECURSIVELY(parentFrame,'detailGBox','ui::CGroupBox')
	detail:RemoveAllChild();

	local skillsRtext = detail:CreateOrGetControl('richtext', 'skills', 10, 25, 100, 30);
	skillsRtext:SetFontName("white_20_ol");
	skillsRtext:SetText(ScpArgMsg('JustSkill'))

	local posY = 0
	for i = 1 , #treelist do
		-- 서버에서 사람들이 가장 많이 찍은 1, 2등 스킬
		local topSkillName1 = ui.GetRedisHotSkillByRanking(jobName, 1);		
		local topSkillName2 = ui.GetRedisHotSkillByRanking(jobName, 2);
		posY = MAKE_SKILLTREE_ICON(detail, jobName, treelist, i, topSkillName1, topSkillName2);
	end

	posY = posY + 30
	
	local abilitysLline = detail:CreateOrGetControl('labelline', 'abilityslabellibe', 0, posY-25, 570, 2);
	abilitysLline:SetSkinName('labelline_def_2')
	local abilitysRtext = detail:CreateOrGetControl('richtext', 'abilitys', 10, posY-5, 100, 30);
	abilitysRtext:SetFontName("white_20_ol");
	abilitysRtext:SetText(ScpArgMsg('JustAbility'))

	-- Ability
	-- 특성 있으면 여기다가 구분선 하나 추가할 것
	local abilList = pcSession.abilityList;
	local abilListCnt = 0;
	if abilList ~= nil then
		abilListCnt = abilList:Count();
	end

	local flag = 0
	local lastypos = posY
	if abilListCnt > 0 then

		local abilindex = 0
		for i=0, abilListCnt - 1 do			
			local abil = abilList:Element(i);
			if abil ~= nil then
				local cls = GetIES(abil:GetObject());
				local ableJobList = StringSplit(cls.Job, ';');
				for j=1, #ableJobList do
					local ableJobName = ableJobList[j];
					if ableJobName == jobName then
						lastypos = MAKE_ABILITY_ICON(frame, pc, detail, cls, posY, abilindex + 1);
						flag = 1;
						abilindex = abilindex + 1
						break;
					end
				end
			end
		end
	end

	if flag == 0 then
		abilitysRtext:SetText('')
		abilitysLline:ShowWindow(0)
	else
		abilitysLline:ShowWindow(1)
	end

	REFRESH_STAT_TEXT(parentFrame, treelist);	
	
	local skilltreegbox = GET_CHILD_RECURSIVELY(parentFrame,'skilltree_pip','ui::CGroupBox')
	if lastypos + detail:GetY() < skilltreegbox:GetHeight() then
		detail:Resize(detail:GetOriginalWidth(), lastypos)
	else
		detail:Resize(detail:GetOriginalWidth()-20, lastypos)
	end
	
	parentFrame:Invalidate();
end

function MAKE_ABILITY_ICON(frame, pc, detail, abilClass, posY, listindex)

	local row = (listindex-1) % 1; -- 예전에는 한줄에 두개씩 보여줬다. /1을 2로 바꾸면 다시 복구됨
	local col = math.floor((listindex-1) / 1);

	local skilltreeframe = ui.GetFrame('skilltree')
	local CTL_WIDTH = skilltreeframe:GetUserConfig("ControlWidth")
	local CTL_HEIGHT = skilltreeframe:GetUserConfig("ControlHeight")
	local xBetweenMargin = 10
	local yBetweenMargin = 10

	local classCtrl = detail:CreateOrGetControlSet('ability_set', 'ABIL_'..abilClass.ClassName, 10 + (CTL_WIDTH + xBetweenMargin) * row, posY + 20 + (CTL_HEIGHT + yBetweenMargin) * col);
	classCtrl:ShowWindow(1);
	
    -- 항상 활성화 된 특성은 특성 활성화 버튼을 안보여준다.
	if abilClass.AlwaysActive == 'NO' then
		-- 특성 활성화 버튼
		local activeImg = GET_CHILD(classCtrl, "activeImg", "ui::CPicture");
	    activeImg:EnableHitTest(1);
	    activeImg:SetEventScript(ui.LBUTTONUP, "TOGGLE_ABILITY_ACTIVE");
	    activeImg:SetEventScriptArgString(ui.LBUTTONUP, abilClass.ClassName);
	    activeImg:SetEventScriptArgNumber(ui.LBUTTONUP, abilClass.ClassID);
	    activeImg:SetOverSound('button_over');
	    activeImg:SetClickSound('button_click_big');

    	if abilClass.ActiveState == 1 then
		    activeImg:SetImage("ability_on");
	    else
		    activeImg:SetImage("ability_off");
	    end
	    activeImg:ShowWindow(1);
	end
	
	-- 특성 아이콘
	local classSlot = GET_CHILD(classCtrl, "slot", "ui::CSlot");
	local icon = CreateIcon(classSlot);	
	icon:SetImage(abilClass.Icon);
	icon:SetTooltipType('ability');
	icon:SetTooltipStrArg(abilClass.Name);
	icon:SetTooltipNumArg(abilClass.ClassID);
	local abilIES = GetAbilityIESObject(pc, abilClass.ClassName);
	icon:SetTooltipIESID(GetIESGuid(abilIES));

	-- 특성 이름
	local nameCtrl = GET_CHILD(classCtrl, "abilName", "ui::CRichText");
	nameCtrl:SetText("{@st41}{s16}".. abilClass.Name);

	-- 특성 레벨
	local abilLv = abilIES.Level;

	local levelCtrl = GET_CHILD(classCtrl, "abilLevel", "ui::CRichText");
	levelCtrl:SetText("Lv.".. abilLv);
	--classCtrl:SetSkinName("test_skin_gary_01");
	return classCtrl:GetY() + classCtrl:GetHeight() + 30;
end
--[[
function UPDATE_LEARN_ABIL_TIME(frame, timer, str, num, time)

	local pc  = GetMyPCObject();
	local sysTime = geTime.GetServerSystemTime();
	local learnAbilTime = imcTime.GetSysTimeByStr(pc.LearnAbilityTime);
	local difSec = imcTime.GetDifSec(learnAbilTime, sysTime);
	local min = math.floor(difSec / 60);
		
	local abilName = frame:GetUserValue("LEARN_ABIL_NAME");
	local abilClassName = frame:GetUserValue("LEARN_ABIL_CLASSNAME");

	local grid = GET_CHILD(frame, 'skill', 'ui::CGrid')
	local detail = grid:CreateOrGetDetailView('classCtrl_'..abilClassName, 380, 999999);
	local classCtrl = detail:CreateOrGetControlSet('ability_set', 'ABIL_'..abilClassName, 0, 0);
	
	UPDATE_LEARING_ABIL_INFO(frame)
end]]

function TOGGLE_ABILITY_ACTIVE(frame, control, abilName, abilID)

	local curTime = imcTime.GetAppTime();
	local topFrame = ui.GetFrame('skilltree')
	local prevClickTime = tonumber( topFrame:GetUserValue("CLICK_ABIL_ACTIVE_TIME") );

	if prevClickTime + 0.1 > curTime then
		return;
	end

	-- 이특성에 해당 스킬을 시전중이면 on/off를 하지 못하게 한다.
	if abilName == "Corsair7" and 1 == geClientSkill.MyActorHasCmd('HOOKEFFECT') then
		return;
	end
	
	topFrame:SetUserValue("CLICK_ABIL_ACTIVE_TIME", curTime);
	pc.ReqExecuteTx("SCR_TX_PROPERTY_ACTIVE_TOGGLE", abilName);
end


function GET_TREE_INFO_LIST(frame, jobName, treelist)

	local cid = frame:GetUserValue("TARGET_CID");
	local pcSession = session.GetSessionByCID(cid);
	local skillList = pcSession.skillList;
	
	local pc = GetPCObjectByCID(cid);
	local clslist, cnt  = GetClassList("SkillTree");
	local index = 1;
	while 1 do
		local name = jobName .. "_" ..index;
		local cls = GetClassByNameFromList(clslist, name);
		if cls == nil then
			break;
		end
		
		local maxLv = GET_SKILLTREE_MAXLV(pc, jobName, cls);

		if 0 < maxLv then
			treelist[index] = {};
			local info = treelist[index];
			info["class"] = cls;

			local lv = 0;
			local obj = nil;
			local dbLv = 0;
			local skl = skillList:GetSkillByName(cls.SkillName)
			if skl ~= nil then
				obj = GetIES(skl:GetObject());
				lv = obj.Level;
				dbLv = obj.LevelByDB;
			end
			
			info["obj"] = obj;
			info["lv"] = lv;
			info["DBLv"] = dbLv;
			info["statlv"] = session.GetUserConfig("SKLUP_" .. cls.SkillName, 0);
		end
		
		index = index + 1;		
	end
end

function MAKE_STANCE_ICON(reqstancectrl, reqstance, EnableCompanion)
	local mainSum = 1;
	local mainWeapon = {}
	local mainWeaponName = {}
	local subSum = 1;
	local subWeapon = {}
	local subWeaponName = {}
	local tooltipText = "";
	local iconCount = 0;

	local compainon = 0;

	if EnableCompanion == "YES" then
		local shareBtn = reqstancectrl:CreateControl("picture", "companion", 100, 37, 28, 20)
		shareBtn:ShowWindow(1);	
		shareBtn = tolua.cast(shareBtn, "ui::CPicture");
		shareBtn:SetImage("weapon_companion");
		--shareBtn:SetTextTooltip();
		tooltipText = ScpArgMsg("companionRide").."{nl}"
		compainon = 20;	
	end

	if reqstance == "None" then
		local shareBtn = reqstancectrl:CreateControl("picture", "All", 100 + compainon, 37, 28, 20)
		shareBtn:ShowWindow(1);	
		shareBtn = tolua.cast(shareBtn, "ui::CPicture");
		shareBtn:SetImage("weapon_All");
		--shareBtn:SetTextTooltip(ScpArgMsg("EquipAll"));
		local tooltipSize = 28;
		if compainon ~= 0 then
			tooltipSize = tooltipSize + 20
		end

		local shareBtn = reqstancectrl:CreateControl("picture", "iconTooltip", 100, 37, tooltipSize, 20)
		shareBtn = tolua.cast(shareBtn, "ui::CPicture");
		shareBtn:SetTextTooltip(tooltipText..ScpArgMsg("EquipAll"));				
		return
	end	
	
	local stancelist, stancecnt = GetClassList("Stance");	
	for word in string.gmatch(reqstance, "%a+")do
		local stance = GetClassByNameFromList(stancelist, word);	
		local index = string.find(stance.ClassName, "Artefact")
		if index == nil then
				tooltipText = tooltipText..stance.Name.."{nl}";
		end
	end
	
	for i = 0, stancecnt -1 do
		local stance = GetClassByIndexFromList(stancelist, i)
		local index = string.find(reqstance, stance.ClassName)
		--스탠스는 TwoHandBow인데.. 쇠뇌이름이 Bow라서 위에 스트링파인드에 걸림..
		--쇠뇌이름을 변경하면 데이터작업자들이 고통스러우니.. 예외를 둔다.. 진짜 망한 구조임..
		
		if (reqstance == "TwoHandBow") and (stance.ClassName == "Bow") then
			index = nil;
		end
		if index ~= nil then
			local index = string.find(stance.ClassName, "Artefact")
			if index == nil then
				if stance.UseSubWeapon == "NO" then
					mainWeapon[mainSum] = stance.Icon
					mainWeaponName[mainSum] = stance.Name
					mainSum = mainSum + 1
				elseif stance.UseSubWeapon == "YES" then
					local flag = 0
					for i = 0, #subWeapon do
						if subWeapon[i] == stance.Icon then
							flag = 1
						end
					end
					if flag == 0 then
						subWeapon[subSum] = stance.Icon
						subWeaponName[subSum] = stance.Name
						subSum = subSum + 1
					end
				end
			end
		end
	end
	
	local index = 0	
	for i = 1, #mainWeapon do
		local shareBtn = reqstancectrl:CreateControl("picture", mainWeapon[i]..i, (100 + compainon)+((i-1)*20), 37, 20, 20)
		shareBtn = tolua.cast(shareBtn, "ui::CPicture");
		shareBtn:SetImage(mainWeapon[i]);
		--shareBtn:SetTextTooltip(mainWeaponName[i]);	
		index = index + 1
		iconCount = iconCount + 1
	end

	for i = 1, #subWeapon do
		local shareBtn = reqstancectrl:CreateControl("picture", subWeapon[i]..index+i, (100 + compainon)+((index+i-1)*20), 37, 20, 20)
		shareBtn = tolua.cast(shareBtn, "ui::CPicture");
		shareBtn:SetImage(subWeapon[i]);
		--shareBtn:SetTextTooltip(subWeaponName[i]);	
		iconCount = iconCount + 1
	end

	if iconCount > 0 then 
		local compainonindex = 0		
		if compainon ~= 0 then
			compainonindex = 1
		end
		local shareBtn = reqstancectrl:CreateControl("picture", "iconTooltip", 100, 37, (compainonindex + iconCount)*20, 20)
		shareBtn = tolua.cast(shareBtn, "ui::CPicture");
		shareBtn:SetTextTooltip(tooltipText);	
	end
	
end

function MAKE_SKILLTREE_ICON(frame, jobName, treelist, listindex, topSkillName1, topSkillName2)

	local sklObj;
	local sklDBLevel = 0;
	local info = treelist[listindex];
	local cls = info["class"];
	local obj = info["obj"];
	local lv = info["lv"];
	local statlv = info["statlv"];
	local totallv = lv + statlv;
	
	local cid = frame:GetUserValue("TARGET_CID");
	local pcSession = session.GetSessionByCID(cid);
	local skillList = pcSession.skillList;
	
	local skl = skillList:GetSkillByName(cls.SkillName)
	if skl ~= nil then
		sklObj = GetIES(skl:GetObject());	
		if sklObj ~= nil then 
			sklDBLevel = sklObj.LevelByDB;
		end
	end

	local sklBM = math.abs(sklDBLevel - lv)

	local pc = GetPCObjectByCID(cid);
	local maxlv = GET_SKILLTREE_MAXLV(pc, jobName, cls);
	local remainstat = GET_REMAIN_SKILLTREE_PTS(treelist);

	local row = (listindex-1) % 1; -- 예전에는 한줄에 두개씩 보여줬다. /1을 2로 바꾸면 다시 복구됨
	local col = math.floor((listindex-1) / 1);

	local skilltreeframe = ui.GetFrame('skilltree')
	local CTL_WIDTH = skilltreeframe:GetUserConfig("ControlWidth")
	local CTL_HEIGHT = skilltreeframe:GetUserConfig("ControlHeight")
	local xBetweenMargin = 5
	local yBetweenMargin = 10

	local skillCtrl = frame:CreateOrGetControlSet('skilltreeIcon', 'classCtrl_'..cls.ClassName, 10 + (CTL_WIDTH + xBetweenMargin) * row, 50 + (CTL_HEIGHT + yBetweenMargin) * col);
	skillCtrl:ShowWindow(1);
	skillCtrl:SetUserValue("JOBNAME", jobName);
	--skillCtrl:EnableScrollBar(0)
	local skillSlot = GET_CHILD(skillCtrl, "slot", "ui::CSlot");
	local icon = CreateIcon(skillSlot);

	local typeclass = GetClass(cls.Type, cls.SkillName);
	local iconname = "icon_" .. typeclass.Icon;
	icon:SetImage(iconname);
	
	--스크롤이 이 위에서 안움직여서 해줬습니다.
	local bggroupbox = GET_CHILD(skillCtrl, "slot_bg", "ui::CGroupBox");
	
	bggroupbox:EnableScrollBar(0);
	bggroupbox = GET_CHILD(skillCtrl, "slot_bg2", "ui::CGroupBox");
	bggroupbox:EnableScrollBar(0);
	bggroupbox = GET_CHILD(skillCtrl, "slot_bg3", "ui::CGroupBox");
	bggroupbox:EnableScrollBar(0);
	bggroupbox = GET_CHILD(skillCtrl, "slot_bg4", "ui::CGroupBox");
	bggroupbox:EnableScrollBar(0);

	local sptxt = GET_CHILD(skillCtrl, "sp_txt", "ui::CRichText");
	local sp = GET_CHILD(skillCtrl, "sp", "ui::CRichText");
	sp:ShowWindow(0);
	sptxt:ShowWindow(0);
	local time;
	local timtext =GET_CHILD(skillCtrl, "time", "ui::CRichText");
	timtext:ShowWindow(0);

	local reqstance = GET_CHILD(skillCtrl, "reqstance", "ui::CRichText");
	reqstance:ShowWindow(0);
	
	local cooltime = GET_CHILD(skillCtrl, "cooltimeimg", "ui::CPicture")
	cooltime:ShowWindow(0)
	
	local labelline = skillCtrl:GetChild("labelline")
	labelline:ShowWindow(0)
	
	if obj ~= nil then
		labelline:ShowWindow(1)
		cooltime:ShowWindow(1)
		sp:ShowWindow(1);
		sptxt:ShowWindow(1);

		if session.GetUserConfig("SKLUP_" .. cls.SkillName) == 0 then
			sp:SetText("{@st66b}{s18}"..obj["SpendSP"].."{/}");
		else
			-- lvUpSpendSP의 루아에서의 float 정밀도를 수정하기위해 소수 5자리에서 반올림한다.
			-- 값을 print로 찍어보면 원래 값과 같지만.. 서버와 계산값을 맞출려면 이렇게 해야 한다.
			local lvUpSpendSpRound = math.floor((obj.LvUpSpendSp * 10000) + 0.5)/10000; 
			
			local spendSP = obj["BasicSP"] + ((lv-1) + session.GetUserConfig("SKLUP_" .. cls.SkillName)) * lvUpSpendSpRound
			spendSP = math.floor(spendSP)
			sp:SetText("{@st66b}{s18}"..spendSP.."{/}");
		end
		sptxt:SetText("{@st66b}".."SP.".."{/}");
		timtext:ShowWindow(1);

		if obj["CoolDown"] ~= 0 then
			time = obj["CoolDown"] * 0.001
		timtext:SetText("{@st66b}{s18}"..GET_TIME_TXT_TWO_FIGURES(time).."{/}");
		else
			timtext:SetText("{@st66b}{s18}"..ScpArgMsg("{Sec}","Sec", 0).."{/}");	
		end

		MAKE_STANCE_ICON(skillCtrl, typeclass.ReqStance, typeclass.EnableCompanion)
	else
		icon:SetGrayStyle(1)
		local dummyObj = GetClass("Skill", cls.SkillName)	
		sp:ShowWindow(1);
		sptxt:ShowWindow(1);
		
		local spendSP = 0;
		-- lvUpSpendSP의 루아에서의 float 정밀도를 수정하기위해 소수 5자리에서 반올림한다.
		-- 값을 print로 찍어보면 원래 값과 같지만.. 서버와 계산값을 맞출려면 이렇게 해야 한다.
		local lvUpSpendSpRound = math.floor((dummyObj.LvUpSpendSp * 10000) + 0.5)/10000; 
		
		if session.GetUserConfig("SKLUP_" .. cls.SkillName) >= 1 then
			spendSP = dummyObj["BasicSP"] + (session.GetUserConfig("SKLUP_" .. cls.SkillName) - 1) * lvUpSpendSpRound 
		else
			spendSP =dummyObj["BasicSP"] +  session.GetUserConfig("SKLUP_" .. cls.SkillName) * lvUpSpendSpRound
		end
		spendSP = math.floor(spendSP)
		sp:SetText("{@st66b}{s18}"..spendSP.."{/}");
		sptxt:SetText("{@st66b}".."SP.".."{/}");

		cooltime:ShowWindow(1)

		if dummyObj.BasicCoolDown ~= 0 then
			time = dummyObj.BasicCoolDown * 0.001
			timtext:SetText("{@st66b}{s18}"..GET_TIME_TXT_TWO_FIGURES(time).."{/}");
		else
			timtext:SetText("{@st66b}{s18}"..ScpArgMsg("{Sec}","Sec", 0).."{/}");
		end
		timtext:ShowWindow(1);
		MAKE_STANCE_ICON(skillCtrl, typeclass.ReqStance, typeclass.EnableCompanion)
	end

	local hotimg = GET_CHILD(skillCtrl, "hitimg", "ui::CPicture");
	if topSkillName1 == cls.SkillName then
		hotimg:SetImage("Hit_indi_icon");
	elseif topSkillName2 == cls.SkillName then
		hotimg:SetImage("Hit_indi_icon");
	else
		hotimg:SetImage("None_Mark");
	end

	icon:SetTooltipType('skill');
	icon:SetTooltipStrArg(cls.SkillName);
	icon:SetTooltipNumArg(typeclass.ClassID);
	icon:SetTooltipIESID(GetIESGuid(obj));
	icon:Set(iconname, "Skill", typeclass.ClassID, 1);
	skillSlot:SetSkinName('slot');

	local nameCtrl = GET_CHILD(skillCtrl, "name", "ui::CRichText");
	nameCtrl:SetText("{@st41}"..typeclass.Name);
	local upCtrl = GET_CHILD(skillCtrl, "upbtn", "ui::CButton");
	upCtrl:SetImage('plus_button');
	upCtrl:SetEventScript(ui.LBUTTONUP, "SKL_PTS_UP");
	upCtrl:SetEventScriptArgString(ui.LBUTTONUP, cls.ClassID);
	upCtrl:SetEventScriptArgNumber(ui.LBUTTONUP, lv);
	upCtrl:SetClickSound("button_click_skill_up");

	if totallv >= maxlv then
		if totallv - sklBM == maxlv then
			upCtrl:SetImage('testlock_button');
			upCtrl:SetTextTooltip(ScpArgMsg('NeedMoreRank'));
		end
	else
		upCtrl:SetTextTooltip(ScpArgMsg('SkillLevelUp'));
	end

	if remainstat <= 0 then
		if totallv ~= maxlv then
			upCtrl:ShowWindow(0);
		end
	else
		upCtrl:ShowWindow(1);
	end

	local levelCtrl = GET_CHILD(skillCtrl, "level", "ui::CRichText");
	local leveltxt = GET_CHILD(skillCtrl, "level_txt", "ui::CRichText");
	local levelFont = "{@st66b}{s18}"
	if totallv > 0  then
		icon:SetGrayStyle(0);
		nameCtrl:SetGrayStyle(0);
		levelCtrl:ShowWindow(1);
		leveltxt:ShowWindow(1);
		if totallv >= maxlv then
			if totallv - sklBM == maxlv then
				levelFont = "{@st66b}{s18}";
				skillCtrl:SetSkinName("skill_max");
			end
		else
			skillCtrl:SetSkinName("bg_active");
		end
	else
		skillCtrl:SetSkinName("test_skin_gary_01");
		--icon:SetGrayStyle(1);
		--nameCtrl:SetGrayStyle(1);
		levelFont = "{@st66b}{s18}"
		levelCtrl:ShowWindow(0);
		leveltxt:ShowWindow(0);
	end
	
	levelCtrl:SetText(levelFont..totallv);

	if obj == nil then
		levelCtrl:ShowWindow(1);
		leveltxt:ShowWindow(1);
		local leveltxt = "";
		if session.GetUserConfig("SKLUP_" .. cls.SkillName) >= 1 then
			leveltxt = "{@st66b}{s18}"..1 + session.GetUserConfig("SKLUP_" .. cls.SkillName) - 1;
		else
			leveltxt = "{@st66b}{s18}"..1 + session.GetUserConfig("SKLUP_" .. cls.SkillName);
		end
		levelCtrl:SetText(leveltxt)
	end


	if lv == 0 then
		skillSlot:EnableDrag(0);
	else
		skillSlot:EnableDrag(1);
	end

	frame:Invalidate();

	return skillCtrl:GetY() + skillCtrl:GetHeight()
end

function REFRESH_POINT(frame)
	local pc = GetMyPCObject();
	local txt = frame:GetChild("point");
	txt:SetText(ScpArgMsg("POINT") .. " : " .. pc.AbilityPoint);
end

function SKILLLIST_GAMESTART(frame)
	local jobObj = info.GetJob(session.GetMyHandle());
	local jobCtrlTypeName = GetClassString('Job', jobObj, 'CtrlType');
	ui.ReqRedisSkillPoint(jobCtrlTypeName);
	
	REFRESH_SKILL_TREE(frame);
	REFRESH_STAT_TEXT(frame);

	local selectJobID = info.GetJob(session.GetMyHandle());
	session.SetUserConfig("SELECT_SKLTREE", selectJobID);

	local clslist, cnt  = GetClassList("Job");
	local cls = GetClassByTypeFromList(clslist, selectJobID);

	
	local grid = GET_CHILD(frame, 'skill', 'ui::CGrid')

	OPEN_SKILL_INFO(frame, nil, cls.ClassName, selectJobID, 1)
	frame:Invalidate()

end

function UPDATE_SKILLTREE(frame)
	local reservereset = session.GetUserConfig("SKL_RESET", 0);
	if reservereset == 1 then
		ROLLBACK_SKILL(frame);
		session.SetUserConfig("SKL_RESET", 0);
	else
		REFRESH_SKILL_TREE(frame);
	end
	frame:Invalidate();
end

function RESERVE_SKLUP_RESET(frame)
	session.SetUserConfig("SKL_RESET", 1);
end

function GET_REMAIN_SKILLTREE_PTS(treelist)
	local pc = GetMyPCObject();
	local jobID = session.GetUserConfig("SELECT_SKLTREE", 0);

	local bonusstat = GetRemainSkillPts(pc, jobID);
	local totaluse = 0;
	for i = 1 , #treelist do
		local info = treelist[i];
		local uselevel = info["statlv"];
		if uselevel > 0 then
			totaluse = totaluse + uselevel;
		end
	end

	return bonusstat - totaluse;
end

function EXEC_COMMIT_SKILL()

	local pcobj = GetMyPCObject();
	local bonusstat = session.GetUserConfig("SKL_REMAIN", 0);

	local frame = ui.GetFrame("skilltree");
	local treename = GET_SKILL_TREE_NAME(frame);

	local curJob = session.GetUserConfig("SELECT_SKLTREE", 0);
	local ArgStr = string.format("%d", curJob);
	local treelist = {};
	GET_TREE_INFO_LIST(frame, treename, treelist);

	local isReq = 0;
	local cnt = #treelist;
	for i = 1 , cnt do
		local info = treelist[i];
		local cls = info["class"];

		local usedpts = session.GetUserConfig("SKLUP_" .. cls.SkillName, 0);
		if usedpts > 0 then
			isReq = 1;
		end
		ArgStr = string.format("%s %d", ArgStr, usedpts);
		session.SetUserConfig("SKLUP_" .. cls.SkillName, 0);
	end

	if isReq == 1 then
		pc.ReqExecuteTx_NumArgs("SCR_TX_SKILL_UP", ArgStr);
	end

	--imcSound.PlaySoundItem('statsup');

	if session.GetUserConfig("SKL_REMAIN") == 0 then
		frame:ShowWindow(0);
	end
end

function GET_SKILL_TREE_NAME(frame)

	local selectJobID = session.GetUserConfig("SELECT_SKLTREE", 0);
	if selectJobID == 0 then
		return 'None';
	end
	local clslist, cnt  = GetClassList("Job");
	local cls = GetClassByTypeFromList(clslist, selectJobID);

	return cls.ClassName;
end

function ROLLBACK_SKILL(frame)

	frame = frame:GetTopParentFrame();
	local treename = GET_SKILL_TREE_NAME(frame);
	if treename == 'None' then
		return;
	end

	local treelist = {};
	GET_TREE_INFO_LIST(frame, treename, treelist);

	local changed = 0;
	local cnt = #treelist;
	for i = 1 , cnt do
		local info = treelist[i];
		local cls = info["class"];

		local set = session.SetUserConfig("SKLUP_" .. cls.SkillName, 0);
		if set == 1 then
			changed = 1;
		end

	end

	if changed == 0 then
		return;
	end

	local pc = GetMyPCObject();
	local bonusstat = GET_REMAIN_SKILLTREE_PTS(treelist);
	session.SetUserConfig("SKL_REMAIN", bonusstat);

	REFRESH_SKILL_TREE(frame);

end

function SKL_PTS_UP(frame, control, clsID, level)
	local pc = GetMyPCObject();
	local remain = session.GetUserConfig("SKL_REMAIN", 0);
	if remain == 0 then
		return;
	end

	frame = frame:GetTopParentFrame();

	local cls = GetClassByType("SkillTree", clsID);
	local curpts = session.GetUserConfig("SKLUP_" .. cls.SkillName, 0);
	local skl = session.GetSkillByName(cls.SkillName)
	if skl ~= nil then
		obj = GetIES(skl:GetObject());	
		if obj.LevelByDB ~= obj.Level then 
			level = obj.LevelByDB;
		end
	end

	local selectJobID = session.GetUserConfig("SELECT_SKLTREE", 0);
	local jobName = GetClassByType("Job", selectJobID).ClassName;
	local maxlv = GET_SKILLTREE_MAXLV(pc, jobName, cls);

	if maxlv <= curpts + level then
		return;
	end

	session.SetUserConfig("SKLUP_" .. cls.SkillName, curpts + 1);
	REFRESH_SKILL_TREE(frame);

end

function REFRESH_STAT_TEXT(frame, treelist)

	local cid = frame:GetUserValue("TARGET_CID");
	local pc = GetPCObjectByCID(cid);
	local txtctrl = GET_CHILD_RECURSIVELY(frame,'PTS','ui::CRichText')
	if treelist == nil then
		txtctrl:SetText("");
	else
		local treecnt = #treelist;
		local remainstat = GET_REMAIN_SKILLTREE_PTS(treelist);
		session.SetUserConfig("SKL_REMAIN", remainstat);
		local txt = string.format("%s : {@st43b}%d{/}", ScpArgMsg("REMAIN_POINT"), remainstat);
		txtctrl:SetText(txt);
	end

	frame:GetChild("COMMIT"):ShowWindow(1);
	frame:GetChild("CANCEL"):ShowWindow(1);
end

function REFRESH_SKILL_TREE(frame)

	HIDE_CHILD_BYNAME(frame, 'skillCtrl_');
	MAKE_CLASS_INFO_LIST(frame);

	local selectJobID = session.GetUserConfig("SELECT_SKLTREE", 0);
	if selectJobID <= 0 then	
		selectJobID = info.GetJob(session.GetMyHandle());
	end

	local clslist, cnt  = GetClassList("Job");
	local cls = GetClassByTypeFromList(clslist, selectJobID);
	
	if cls ~= nil then
		OPEN_SKILL_INFO(frame, nil, cls.ClassName, selectJobID, 0)
	end

	UPDATE_LEARING_ABIL_INFO(frame)

	frame:Invalidate();
end

function UPDATE_LEARING_ABIL_INFO(frame)

	local nowLearingGBox = GET_CHILD(frame, 'nowLearingGBox','ui::CGroupBox')
	nowLearingGBox:ShowWindow(0);

	local cid = frame:GetUserValue("TARGET_CID");
	local pc = GetPCObjectByCID(cid);
	for i = 0, RUN_ABIL_MAX_COUNT do
		local prop = "None";
		if 0 == i then
			prop = "LearnAbilityID";
		else
			prop = "LearnAbilityID_" ..i;
		end
		if pc[prop] ~= nil and pc[prop] > 0 then
			nowLearingGBox:ShowWindow(1);
			local ctr = nowLearingGBox:CreateOrGetControlSet("learing_abil_ctrl", "CTRLSET_" .. i, ui.LEFT, 0, 0, 0, 0, 0);
			local abilClass = GetClassByType("Ability", pc[prop]);

			if abilClass ~= nil then

				local titlepicture = GET_CHILD(ctr, 'learningAbilPic','ui::CPicture')

				local iconname = abilClass.Icon;
				titlepicture:SetImage(iconname);

				local nowLearingRtxt = GET_CHILD(ctr, 'nowLearing','ui::CRichText')

				local jobClsList, jobCnt = GetClassList('Job');
				for i=0, jobCnt-1 do
					local cls = GetClassByIndexFromList(jobClsList, i);
					
					local tempstr = 'Ability_' .. cls.EngName
					
					local clslist, cnt  = GetClassList(tempstr);
					if clslist ~= nil then
						local foundabilcls = GetClassByNameFromList(clslist, abilClass.ClassName);
						if foundabilcls ~= nil then
							ctr:SetTextByKey('clsName',cls.Name)
						end
					end
				end

				local abilIES = GetAbilityIESObject(pc, abilClass.ClassName);

				if abilIES ~= nil then
					local abilLv = abilIES.Level + 1;
					ctr:SetTextByKey('level',abilLv)
				end
				
				ctr:SetTextByKey('abilName',abilClass.Name)

				local remainTimeRtxt = GET_CHILD(ctr, 'remainTime','ui::CRichText')
				local sysTime = geTime.GetServerSystemTime();
				local propTime = "None";
				if i == 0 then
					propTime = "LearnAbilityTime";
				else
					propTime = "LearnAbilityTime_" ..i;
				end
				local learnAbilTime = imcTime.GetSysTimeByStr(pc[propTime]);
				local difSec = imcTime.GetDifSec(learnAbilTime, sysTime);
				local min = math.floor(difSec / 60);

				if min < 0 then
					min = 0;
				end

				remainTimeRtxt:SetTextByKey('remaintime',min + 1)
				
				local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
				--timer:SetUpdateScript("UPDATE_LEARN_ABIL_TIME");
				timer:SetUpdateScript("UPDATE_LEARING_ABIL_INFO");
				timer:Stop();
				timer:Start(1, 0);
				--frame:SetUserValue("LEARN_ABIL_NAME", abilClass.Name);
				--frame:SetUserValue("LEARN_ABIL_CLASSNAME", abilClass.ClassName);

				ctr:SetUserValue("PROP_INDEX", i);
			end
		else
			local ctr = nowLearingGBox:GetChild("CTRLSET_" .. i);
			if nil ~= ctr then
				nowLearingGBox:RemoveChild("CTRLSET_" .. i);
			end
		end
	end

	GBOX_AUTO_ALIGN(nowLearingGBox, 10, 0, 10, true, true);

	local skilltreegbox = GET_CHILD_RECURSIVELY(frame,'skilltree_pip')
	local destHeight = nowLearingGBox:GetY() - skilltreegbox:GetY();
	skilltreegbox:Resize(skilltreegbox:GetWidth(), destHeight);
	
end


function INSERT_SKILL_TREE(frame, jobid)

		local clslist, cnt  = GetClassList("Job");
		local cls = GetClassByTypeFromList(clslist, jobid);

		if cls ~= nil then
			OPEN_SKILL_INFO(frame, nil, cls.ClassName, jobid, 0)
		end

		session.SetUserConfig("SELECT_SKLTREE", 0);
end


function REQ_ROLL_BACK_LEARING_ABIL(frame, btn)

	local propIndex = frame:GetUserValue("PROP_INDEX");
	if propIndex ~= 'None' then

		local yesScp = string.format("EXC_ROLL_BACK_LEARING_ABIL(%d)", tonumber(propIndex));
		local txt = ScpArgMsg("REQ_CANCEL_LEARING_ABIL");
		ui.MsgBox(txt, yesScp, "None");
	end
end

function EXC_ROLL_BACK_LEARING_ABIL(propIndex)
	control.CustomCommand("REQUEST_CANCEL_LEARNING_ABIL", propIndex);
end