


function ON_CUSTOM_QUEST_DELETE(frame, msg, keyName, argNum)
	local groupbox = frame:GetChild('questGbox');
	
	local ctrlName = "_Q_CUSTOM_" .. keyName;
	groupbox:RemoveChild(ctrlName);
	ALIGN_QUEST_CTRLS(groupbox);

	local frame2 = ui.GetFrame("questinfoset_2");
	local GroupCtrl = GET_CHILD(frame2, "member", "ui::CGroupBox");
	GroupCtrl:RemoveChild(ctrlName);
	QUESTINFOSET_2_MAKE_CUSTOM(frame2, true);
end

function ON_CUSTOM_QUEST_UPDATE(frame, msg, keyName, argNum)

	local customQuest = geQuest.GetCustomQuest(keyName);
	if customQuest == nil then
		return;
	end

	local groupbox = frame:GetChild('questGbox');
	local frame2 = ui.GetFrame("questinfoset_2");	
	if customQuest.useMainUI == 1 then
		local key = customQuest:GetKey();
		local ctrlName = "_Q_CUSTOM_" .. key;
		local quest_ctrl = groupbox:CreateOrGetControlSet('custom_quest_list', ctrlName, 20, 0);
		local ret = CUSTOM_CONTROLSET_UPDATE(quest_ctrl, customQuest);
		if ret == -1 then
			groupbox:RemoveChild(ctrlName);
			
			local GroupCtrl = GET_CHILD(frame2, "member", "ui::CGroupBox");
			GroupCtrl:RemoveChild(ctrlName);
		end
	end

	ALIGN_QUEST_CTRLS(groupbox);
	QUESTINFOSET_2_MAKE_CUSTOM(frame2, true);
	frame2:ShowWindow(1);

end

function CUSTOM_CONTROLSET_UPDATE(quest_ctrl, quest)
	local funcName = quest:GetFuncName();
	local _func = _G[funcName];
	return _func(quest_ctrl, quest:GetStrArg(), quest.numArg);
end

function QUESTINFOSET_2_MAKE_CUSTOM(frame, updateSize)

	local GroupCtrl = GET_CHILD(frame, "member", "ui::CGroupBox");
	local cnt = geQuest.GetCustomQuestCount();
	for i = 0, cnt - 1 do
		local customQuest = geQuest.GetCustomQuestByIndex(i);
		local key = customQuest:GetKey();
		local ctrlName = "_Q_CUSTOM_" .. key;
		-- ���⼭ ���� �̸����� ã�� �����ϴ� �������
		--local ctrlset = GroupCtrl:CreateOrGetControlSet('emptyset2', ctrlName, 0, 0);
		local ctrlset = GroupCtrl:CreateOrGetControlSet('emptyset2', ctrlName.."_"..i, 0, 0);
		ctrlset:Resize(GroupCtrl:GetWidth() - 20, ctrlset:GetHeight());
		CUSTOM_CONTROLSET_UPDATE(ctrlset, customQuest)
	end
	
	if updateSize == true then
		QUEST_GBOX_AUTO_ALIGN(frame, GroupCtrl, 0, 3, 100);
	end
end

function ATTACH_QUEST_CTRLSET_TEXT(ctrlset, key, text, startx, y)
	local content = ctrlset:CreateOrGetControl('richtext', key, startx, y, ctrlset:GetWidth() - 60, 10);
	tolua.cast(content, "ui::CRichText");
	content:EnableSplitBySpace(0);
	content:EnableHitTest(0);
	content:SetTextFixWidth(1);
	content:SetText(text);
	y = y + content:GetHeight();
	return y;

end

function MIN_LV_NOTIFY_UPDATE(ctrlset, strArg, minLv)
	local name = GET_CHILD(ctrlset, "name", "ui::CRichText");
	if name == nil then
		name = ctrlset:CreateOrGetControl('richtext', 'name', 10, 0, ctrlset:GetWidth() - 10, 30);
		name = tolua.cast(name, "ui::CRichText");
	end

	name:SetText(ScpArgMsg("NextQuestAbleLevel:{Auto_1}", "Auto_1", minLv));
	ctrlset:Resize(ctrlset:GetWidth(), name:GetY() + name:GetHeight() + 5);
	return y;
end


function MGAME_QUEST_UPDATE(ctrlset)

	local stageList = session.mgame.GetStageQuestList();
	local stageCnt = stageList:size();
	if stageCnt == 0 then
		return -1;
	end

	local name = GET_CHILD(ctrlset, "name", "ui::CRichText");
	if name == nil then
		name = ctrlset:CreateOrGetControl('richtext', 'name', 40, 10, ctrlset:GetWidth() - 10, 100);
		name = tolua.cast(name, "ui::CRichText");
	end
		
	DESTROY_CHILD_BYNAME(ctrlset, 'ITEM_');
			
	local nameTxt = "{@st42}";
	local startx = 25;
	local y = 20;
    
	local stageList = session.mgame.GetStageQuestList();
	local stageCnt = stageList:size();
	if stageCnt == 0 then
		return -1;
	end

	for j = 0 , stageCnt - 1 do
		local stageInfo = stageList:at(j);
		local stageInstInfo = session.mgame.GetStageInst(stageInfo:GetStageName());
		if stageInstInfo ~= nil and 0 == stageInstInfo.isCompleted then
			local monList = stageInfo:GetMonsterList();
			local timeOut = stageInfo.timeOut;

			local ignoreThisControl = false;
			if timeOut > 0 and stageInstInfo ~= nil then
				local serverTime = GetServerAppTime();
				local remainSec = timeOut - serverTime;
				if remainSec < 3 then
					ignoreThisControl = true;
				end
			end

			if ignoreThisControl == false then

				local titleName = stageInfo:GetTitleName();
				if titleName ~= "" then
					y = ATTACH_QUEST_CTRLSET_TEXT(ctrlset, "ITEM_TITLE_" .. j, "{@st41_yellow} ".. titleName, startx, y);
				end

				if timeOut > 0 and stageInstInfo ~= nil then
					local serverTime = GetServerAppTime();
					local remainSec = timeOut - serverTime;
					y = ATTACH_TIME_CTRL_EX(ctrlset, "ITEM_TIME_" .. j , remainSec, 50, y);
				end

				for i = 0 ,  monList:size() - 1 do
					local monInfo = monList:at(i);
					local monTypes = monInfo:GetMonTypes();
					if monTypes:size() > 0 then
						local monName = GetClassByType("Monster", monTypes:at(0));
						local txt = string.format("%s (%d/%d)", monName.Name, monInfo.curCount ,monInfo.count);
						y = ATTACH_QUEST_CTRLSET_TEXT(ctrlset, "ITEM_MON_" .. j .. "_".. i, "{@st42} ".. txt, startx, y);
					end
				end

				local privList = stageInfo:GetPrivateQuestList();
				for i = 0 , privList:size() - 1 do
					local pQuest = privList:at(i);
					if true == pQuest.enabled then
						if pQuest:GetQuestType() == geMGame.QUEST_SOBJ then
							pQuest = tolua.cast(pQuest, "geMGame::PRIVATE_QUEST_SOBJ");					
							local titleValue = GET_SOBJ_QUEST_TITLE(pQuest);
							if titleValue ~= nil then
								y = ATTACH_QUEST_CTRLSET_TEXT(ctrlset, "ITEM_SOBJ_" .. j .. "_".. i, titleValue, startx, y);
								y = y + 10;
							end
						end
					end
				end
			end
		end
	end
	
	local avandonquest_try = ctrlset:GetChild("avandonquest_try")
	if avandonquest_try ~= nil then
	    avandonquest_try:ShowWindow(0)
	end
	local dialogReplay = ctrlset:GetChild("dialogReplay")
	if dialogReplay ~= nil then
	    dialogReplay:ShowWindow(0)
	end
	local abandon = ctrlset:GetChild("abandon")
	if abandon ~= nil then
	    abandon:ShowWindow(0)
	end
	local save = ctrlset:GetChild("save")
	if save ~= nil then
	    save:ShowWindow(0)
	end
	ctrlset:Resize(ctrlset:GetWidth(), y + 20);
	return y;

end

function GET_SOBJ_QUEST_TITLE(sObjInfo)

	local sObj = session.GetSessionObjectByName(sObjInfo:GetClsName());
	if sObj == nil then
		return nil;
	end

	local obj = GetIES(sObj:GetIESObject());
	local val = obj[sObjInfo:GetPropName()];
	local formatStr = sObjInfo:GetTitleFormat();
	local isCompleted = false;
	if val >= sObjInfo.destValue then
		val = sObjInfo.destValue;
		isCompleted = true;
	end

	local ret = string.format(formatStr, val, sObjInfo.destValue);
	if isCompleted == true then
		return "{@st42_gray}{cl}"..  ret;
	else
		return "{@st42}" .. ret;
	end
end

function ATTACH_TIME_CTRL_EX(ctrlset, ctrlName, timeSec, startx, y)

	local timeSet = ctrlset:CreateOrGetControlSet('emptyset2', ctrlName, startx + 10, y);
	local xSpace = 10;

	local txt = timeSet:CreateOrGetControl("richtext", "commatext", xSpace + 60, 10, 100, 100);
	tolua.cast(txt, "ui::CRichText");
	txt:SetText("{s22}{ol}:{/}");

	local m1time = timeSet:CreateOrGetControl('picture', "m1time", xSpace, 5, 28, 38);
	local m2time = timeSet:CreateOrGetControl('picture', "m2time", xSpace + 30, 5, 28, 38);
	local s1time = timeSet:CreateOrGetControl('picture', "s1time", xSpace + 70, 5, 28, 38);
	local s2time = timeSet:CreateOrGetControl('picture', "s2time", xSpace + 100, 5, 28, 38);
	tolua.cast(m1time, "ui::CPicture");
	m1time:SetImage("time_0");
	timeSet:SetValue(timeSec);
	timeSet:SetUserValue("STARTTIME", imcTime.GetAppTime());
	timeSet:RunUpdateScript("UPDATE_Q_TIME_CTRLSET_EX", 0.1);
	UPDATE_Q_TIME_CTRLSET_EX(timeSet);
		
	return timeSet:GetHeight() + timeSet:GetY();
end


function UPDATE_Q_TIME_CTRLSET_EX(ctrlset)

	local totalTime = ctrlset:GetValue();
	local startTime = ctrlset:GetUserIValue("STARTTIME");
	local elapsedTime = imcTime.GetAppTime() - startTime;
	if elapsedTime >= totalTime then
		return 0;
	end
		
	local remainTime = (totalTime - elapsedTime);
	local lastValue = ctrlset:GetUserIValue("LastSec");
	if lastValue == remainTime then
		return 1;
	end

	ctrlset:SetUserValue("LastSec", remainTime);

	local min, sec = GET_QUEST_MIN_SEC(remainTime);

	SET_QUESTINFO_TIME_TO_SET(min, sec, ctrlset);
	ctrlset:GetTopParentFrame():Invalidate();
	return 1;

end


	
	
	

