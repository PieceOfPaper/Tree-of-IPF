-- homunclus.lua

function HOMUNCLUS_ON_INIT(addon)
	addon:RegisterMsg("OPEN_HOMUNCLUS_INFO", "ON_OPEN_HOMUNCLUS");
	addon:RegisterMsg("UPDATE_HOMUNCLUS_SKILL", "UPDATE_HOMUNCLUS_SKILL_LIST");
	addon:RegisterMsg('BUFF_UPDATE', 'UPDATE_HOMUNCLUS_SKILL_LIST');
end

function ON_OPEN_HOMUNCLUS(frame, msg, argStr, argNum)
	frame:ShowWindow(1);
	frame:SetUserValue("HANDLE", argNum);

	UPDATE_HOMUNCLUS_INFO(frame, argStr);
	UPDATE_HOMUNCLUS_SKILL_LIST(frame);
end

function HOMUNCLUS_UI_CLOSE(frame)
	frame:ShowWindow(0);
end

function SHOW_REMAIN_HOMUNCLUS_DEAD(ctrl)
	if nil == ctrl then
		return 0;
	end
	local elapsedSec = imcTime.GetAppTime() - ctrl:GetUserIValue("STARTSEC");
	local startSec = ctrl:GetUserIValue("REMAINSEC");
	startSec = startSec - elapsedSec;

	if 0 >= startSec then
		local frame = ctrl:GetParent();
		local btn = frame:GetChild("btn");
		btn:SetEnable(1);
		ctrl:SetTextByKey("value", '');
		ctrl:StopUpdateScript("SHOW_REMAIN_HOMUNCLUS_DEAD");
		return 0;
	end
	local timeTxt = GET_TIME_TXT(startSec);
	ctrl:SetTextByKey("value", "" .. timeTxt.."");
	return 1;
end

function UPDATE_HOMUNCLUS_INFO(frame, argStr)
	local myHandle = session.GetMyHandle();
	local buff = info.GetBuffByName(myHandle, 'Homunculus_Skill_Buff');
	if buff == nil then
		return;
	end

	local infogBox = frame:GetChild('infogBox');
	local name = infogBox:GetChild('name');
	name:SetTextByKey('value', argStr);

	local pcetc = GetMyEtcObject();
	local data = infogBox:GetChild('data');
	data:SetTextByKey('value', argStr);

	if pcetc.alchemist_Homunculus ~= 'None' then
		local registerTime = imcTime.GetSysTimeByStr(pcetc.alchemist_Homunculus)
		local sysTime = geTime.GetServerSystemTime();	
		local difSec = imcTime.GetDifSec(registerTime, sysTime);
		if difSec > 0 then
			data:SetUserValue("REMAINSEC", difSec);
			data:SetUserValue("STARTSEC", imcTime.GetAppTime());
			SHOW_REMAIN_HOMUNCLUS_DEAD(data);
			data:RunUpdateScript("SHOW_REMAIN_HOMUNCLUS_DEAD", 1);
		else
			data:SetTextByKey('value', '');
		end
	else
		data:SetTextByKey('value', '');
	end


	-- 가상몹을 생성합시다.
	local tempObj = CreateGCIES("Monster", 'pcskill_Homunculus');
	if nil == tempObj then
		return;
	end

	tempObj.Lv = buff.arg1;
	local hp = SCR_Get_MON_MHP(tempObj);
	local myHp = infogBox:GetChild('hpStr');
	myHp:SetTextByKey("value", hp);
	
	-- 물리 공격력
	local richText = GET_CHILD(infogBox,'mtk',"ui::CRichText")
	richText:SetTextByKey("value", math.floor(SCR_Get_MON_MAXPATK(tempObj)));

	-- 마법 공격력
	richText = GET_CHILD(infogBox,'magic',"ui::CRichText")
	richText:SetTextByKey("value", math.floor(SCR_Get_MON_MAXMATK(tempObj)));

	-- 방어력
	richText = GET_CHILD(infogBox,'mtk_def',"ui::CRichText")
	richText:SetTextByKey("value", math.floor(SCR_Get_MON_DEF(tempObj)));
	
	-- 마법 방어력
	richText = GET_CHILD(infogBox,'magic_def',"ui::CRichText")
	richText:SetTextByKey("value", math.floor(SCR_Get_MON_MDEF(tempObj)));
	

	-- 생성한 가상몹을 지워야져
	DestroyIES(tempObj);
end

function UPDATE_HOMUNCLUS_SKILL_SLOT(frame, sklObj, ctrlSet)
	for i = 1, 4 do
		local slot = GET_CHILD(frame, "slot_"..i, "ui::CSlot");
		local icon = slot:GetIcon();
		if nil == icon then
			icon = CreateIcon(slot);
			icon:SetImage('icon_'..sklObj.Icon)
			icon:SetTooltipType('skill');
			icon:SetTooltipStrArg(sklObj.ClassName);
			icon:SetTooltipNumArg(sklObj.ClassID);
			local chld = GET_CHILD(ctrlSet, "excute", "ui::CCheckBox");
			chld:SetCheck(1);
			break;
		end
	end
end

function UPDATE_HOMUNCLUS_SKILL_LIST(frame, msg, argStr, argNum)
	if argNum ~= 3074 and nil ~= argNum then
		return;
	end

	local sklList = frame:GetChild('sklList');
	sklList:RemoveAllChild();

	local skillgBox = frame:GetChild('skillgBox');
	for i = 1, 4 do
		local slot = GET_CHILD(skillgBox, "slot_"..i, "ui::CSlot");
		slot:ClearIcon();
	end

	local allSklList = GET_HOMUNCULUS_SKILLS();
	local sklCnt = 0;
	for i = 1, #allSklList do
		local skillInfo = session.GetSkillByName(allSklList[i]);
		if nil ~= skillInfo then
			local ctrlSet = sklList:CreateControlSet("homunclus_skl_list", "CTRLSET_" .. i, ui.LEFT, 0, 0, 0, 0, 0);
			local sklObj = GetIES(skillInfo:GetObject());
			local skillName = ctrlSet:GetChild('skillName');
			skillName:SetTextByKey('value', sklObj.Name )
			
			local pskl = GET_CHILD(ctrlSet, "pskl", "ui::CPicture");
			pskl:SetImage('icon_'..sklObj.Icon);
			
			local excute = ctrlSet:GetChild('excute');
			
			local isCheck = 0;
			if sklCnt < 4 then
				isCheck = IS_HOMUNCLUS_SKILL_ACQUIRE(sklObj.ClassID);
				if 0 == isCheck then
					sklCnt = sklCnt + 1;
					UPDATE_HOMUNCLUS_SKILL_SLOT(skillgBox, sklObj, ctrlSet);
				end
			end
			excute:SetEnable(isCheck); 
			ctrlSet:SetUserValue('SKLNAME', allSklList[i]);
		end
	end

	GBOX_AUTO_ALIGN(sklList, 20, 0, 0, true, false); 
end

function IS_HOMUNCLUS_SKILL_ACQUIRE(sklID)
	local buff = info.GetMyPcBuff('Homunculus_Skill_Buff')
	if nil == buff then
		return 1; 
	end

	if buff.arg2 == sklID then
		return 0;
	elseif buff.arg3 == sklID then
		return 0;
	elseif buff.arg4 == sklID then
		return 0;
	elseif buff.arg5 == sklID then
		return 0;
	end

	return 1;
end

function HOMUNCLUS_SKL_SELECT(frame, ctrl)
	if ctrl:IsChecked() == 1 then
		ctrl:SetCheck(1);
	else
		ctrl:SetCheck(0);
	end
end

function HOMUNCLUS_SKL_APPLIED(frame, ctrl)
	ui.OpenFrame('homuncluslast');
end

function HOMUNCLUS_SKL_CANCLE(frame, ctrl)
	frame = frame:GetTopParentFrame();
	UPDATE_HOMUNCLUS_SKILL_LIST(frame);
end