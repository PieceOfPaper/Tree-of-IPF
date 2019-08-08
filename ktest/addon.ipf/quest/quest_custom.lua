-- quest_custom.lua

local customQuestList = nil;
local styleinfoType = {"bar", "text"};

local function _GET_CUSTOM_QUEST_LIST()

	if customQuestList == nil then
		customQuestList = {}
	end

	return customQuestList;
end


local function _REMOVE_CUSTOM_QUEST_INFO(keyName)
	local list = _GET_CUSTOM_QUEST_LIST()
	if list == nil then
		return nil
	end
	
	for id=#list, 1, -1 do
		local customQuestInfo = list[id]
		if customQuestInfo.Key == keyName then
			table.remove(list, id);
		end
	end

end

local function _GET_CUSTOM_QUEST_INFO(keyName)
	local list = _GET_CUSTOM_QUEST_LIST()
	if list == nil then
		return nil
	end

	for index,customQuestInfo in pairs(list) do
		if customQuestInfo.Key == keyName then
			return customQuestInfo;
		end
	end

	return nil;
end

local function _SET_CUSTOM_QUEST_INFO(keyName)
	local list = _GET_CUSTOM_QUEST_LIST()
	if list == nil then
		return
	end

	-- 이미 있으면 그냥 리턴.
	for index, questInfo in pairs(list) do
		if questInfo.Key == keyName then
			return
		end
	end
	
	-- 없으면 끝에 추가.
	local questIndex = #list;
	list[questIndex + 1] = { Key = keyName}
	
end

-- style info ui update
function ON_STYLE_INFO_UPDATE(frame, msg, argStr, argNum)
	local frame2 = ui.GetFrame("questinfoset_2");
	local GroupCtrl = GET_CHILD(frame2, "member", "ui::CGroupBox");
	local cnt = geQuest.GetCustomQuestCount();
	for i = 0, cnt - 1 do
		local customQuest = geQuest.GetCustomQuestByIndex(i);
		local key = customQuest:GetKey();
		local ctrlName = "_Q_CUSTOM_" .. key;
		local ctrlset = GroupCtrl:CreateOrGetControlSet('emptyset2', ctrlName.."_"..i, 0, 0);
		CUSTOM_CONTROLSET_UPDATE(ctrlset, customQuest, argStr, argNum)

		if IS_STYLE_INFO_DRAW() == false then
			ctrlset:ShowWindow(0);
		end
	end
	
	QUEST_GBOX_AUTO_ALIGN(frame, GroupCtrl, 0, 3, 100);

end

-- 커스텀 퀘스트 그리기.
function DRAW_CUSTOM_QUEST_LIST(frame, y)	
	if frame == nil then
		frame = ui.GetFrame('quest')
	end

	local bgCtrl = GET_CHILD_RECURSIVELY(frame, 'questGbox');
	local questList = _GET_CUSTOM_QUEST_LIST()
	local height = 0;
	for notUse, customQuestInfo in pairs(questList) do
		height = height + DRAW_CUSTOM_QUEST_CTRL(bgCtrl, customQuestInfo, y + height)
	end

	return height;
end

function DRAW_CUSTOM_QUEST_CTRL(bgCtrl, customQuestInfo, y)
	if bgCtrl == nil then
		return 0;
	end

	local customQuest = geQuest.GetCustomQuest(customQuestInfo.Key);
	if customQuest == nil then
		_REMOVE_CUSTOM_QUEST_INFO(customQuestInfo.Key)
		return 0;
	end

	local frame2 = ui.GetFrame("questinfoset_2");
	local key = customQuest:GetKey();
	local ctrlName = "_Q_CUSTOM_" .. key;
	local quest_ctrl = bgCtrl:CreateOrGetControlSet('custom_quest_list', ctrlName, 0, 0);
	local ret = CUSTOM_CONTROLSET_UPDATE(quest_ctrl, customQuest);
	if ret == -1 then
		bgCtrl:RemoveChild(ctrlName);
		
		local GroupCtrl = GET_CHILD(frame2, "member", "ui::CGroupBox");
		GroupCtrl:RemoveChild(ctrlName);
		return 0; -- 지령창에만 표시하는 커스텀 컨트롤이므로 0을 리턴.
	end

	return quest_ctrl:GetHeight()
end

	
function ON_CUSTOM_QUEST_DELETE(frame, msg, keyName, argNum)
	_REMOVE_CUSTOM_QUEST_INFO(keyName)

	DRAW_QUEST_LIST(frame)

	-- INFOSET
	local frame2 = ui.GetFrame("questinfoset_2");    
	local GroupCtrl = GET_CHILD(frame2, "member", "ui::CGroupBox");
	GroupCtrl:RemoveChild(ctrlName);
	QUESTINFOSET_2_MAKE_CUSTOM(frame2, true);
end

function ON_CUSTOM_QUEST_UPDATE(frame, msg, keyName, argNum)
	local customQuest = geQuest.GetCustomQuest(keyName);
	if customQuest == nil then
		_REMOVE_CUSTOM_QUEST_INFO(keyName)
		return
	end

	if customQuest.useMainUI == 1 then
		_SET_CUSTOM_QUEST_INFO(keyName)
	end

	DRAW_QUEST_LIST(frame);

	-- INFOSET
	local frame2 = ui.GetFrame("questinfoset_2");	
	QUESTINFOSET_2_MAKE_CUSTOM(frame2, true);
	frame2:ShowWindow(1);
end

function CUSTOM_CONTROLSET_UPDATE(quest_ctrl, quest, argStr, cnt)
	local funcName = quest:GetFuncName();
	local _func = _G[funcName];
	return _func(quest_ctrl, quest:GetStrArg(), quest.numArg, argStr, cnt);
end

function QUESTINFOSET_2_MAKE_CUSTOM(frame, updateSize)
	local GroupCtrl = GET_CHILD(frame, "member", "ui::CGroupBox");
	local customOption = GET_CHILD(frame, "quest_custom", "ui::CCheckBox");

	if customOption:IsChecked() == 1 then
		GroupCtrl:DeleteAllControl();
	end

	if IS_STYLE_INFO_DRAW() == false then
		return;
	end

	local cnt = geQuest.GetCustomQuestCount();
	for i = 0, cnt - 1 do
		local customQuest = geQuest.GetCustomQuestByIndex(i);
		local key = customQuest:GetKey();
		local ctrlName = "_Q_CUSTOM_" .. key;
		local ctrlset = GroupCtrl:CreateOrGetControlSet('emptyset2', ctrlName.."_"..i, 0, 0);
		ctrlset:Resize(GroupCtrl:GetWidth() - 20, ctrlset:GetHeight());
		CUSTOM_CONTROLSET_UPDATE(ctrlset, customQuest)
	end
	
	if updateSize == true then
		QUEST_GBOX_AUTO_ALIGN(frame, GroupCtrl, 0, 3, 100);
	end
end

function ATTACH_STYLE_INFO_CTRLSET(ctrlset, key, style, text, curCount, count, startx, y)
	if style == "bar" then
		local content = ctrlset:CreateOrGetControlSet('style_info_ctrlset_bar', key, startx, y);
		AUTO_CAST(content);

		local txt = string.format("{@st42}목표 : %s", text);
		local text = GET_CHILD(content, 'text');
		text:SetText(txt);

		local bar = GET_CHILD(content, 'bar');
		bar:SetPoint(curCount, count);

		if count <= curCount then
			bar:SetBarColor(0xFFFFE400)
			text:SetColorTone('FF444444');
		elseif curCount == -1 then
			text:SetColorTone('FF444444');
		end
	
		y = y + content:GetHeight();
		return y;
	else
		local txt = "";

		local content = ctrlset:CreateOrGetControlSet('style_info_ctrlset_text', key, startx, y);
		AUTO_CAST(content);

		local pic = GET_CHILD(content, 'pic');
		local labelline = GET_CHILD_RECURSIVELY(content, 'labelline');
		labelline:SetVisible(0);
		pic:ShowWindow(0);
		
		if curCount < count then
			txt = string.format("{@st42}(%d/%d) %s", curCount, count, text);

			-- 해당 퀘스트 실패
			if -1 == curCount then
				txt = string.format("{@st42}%s", text);
				pic:SetImage("mark_img_x")
				pic:ShowWindow(1);
				labelline:SetVisible(1);
			end

		else			
			txt = string.format("{@st42}%s", text);
			pic:SetImage("mark_img_o")
			pic:ShowWindow(1);
			labelline:SetVisible(1);
		end

		local text = GET_CHILD(content, 'text');
		text:SetText(txt);

		if pic:IsVisible() == 1 then
			local rect = text:GetMargin();
			text:SetMargin(rect.left + (pic:GetWidth() * 1.5), rect.top, rect.right, rect.bottom);
			text:SetColorTone('FF444444');
		end

		y = y + content:GetHeight();
	
		return y;
		
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


function MGAME_QUEST_UPDATE(ctrlset, strArg, numArg, str, cnt)
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

	local styleinfolist = {}		-- key : styleinfoType, value : stagelist index
	for j = 1, #styleinfoType do
		styleinfolist[styleinfoType[j]] = {};	
	end

	for j = 0 , stageCnt - 1 do
		local stageInfo = stageList:at(j);
		local stageName = stageInfo:GetStageName();
		local stageInstInfo = session.mgame.GetStageInst(stageName);
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

				local styleinfo = stageInfo:GetStyleInfoQuest();
				if IS_STYLE_INFO_CHECK(styleinfo) then
					if cnt ~= nil and str == styleinfo.valueName then
						if cnt == -1 and styleinfo.curCount < styleinfo.count then
							-- cnt가 -1 이고(미션 실패) 목표 수치를 못채웠을 경우 
							styleinfo.curCount = cnt;
						elseif cnt ~= -1 then 
							-- 평소대로 카운팅 되는 경우 
							styleinfo.curCount = cnt;
						end
					end

					y = ATTACH_STYLE_INFO_CTRLSET(ctrlset, "ITEM_STYLE_INFO_"..styleinfo.valueName, styleinfo.style, styleinfo.text, styleinfo.curCount, styleinfo.count, startx, y);
				end 

				for i = 0 , monList:size() - 1 do
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

			elseif str == nil and cnt == nil and ignoreThisControl == true then
				-- timeOut이 지났지만 미션을 실패 했을 경우
				local styleinfo = stageInfo:GetStyleInfoQuest();
				if IS_STYLE_INFO_CHECK(styleinfo) and styleinfo.remainOption == true then 
					local titleName = stageInfo:GetTitleName();
					if titleName ~= "" then
						y = ATTACH_QUEST_CTRLSET_TEXT(ctrlset, "ITEM_TITLE_" .. j, "{@st41_yellow} ".. titleName, startx, y);
					end

					if styleinfo.curCount < styleinfo.count then
						styleinfo.curCount = -1;
					end
					y = ATTACH_STYLE_INFO_CTRLSET(ctrlset, "ITEM_STYLE_INFO_"..styleinfo.valueName, styleinfo.style, styleinfo.text, styleinfo.curCount, styleinfo.count, startx, y);
				end
			end
		elseif stageInstInfo ~= nil and 1 == stageInstInfo.isCompleted then
			-- 클리어한 미션의 styleinfotype에 맞게 styleinfolist에 추가
			local styleinfo = stageInfo:GetStyleInfoQuest();
			if IS_STYLE_INFO_CHECK(styleinfo) and styleinfo.remainOption == true then 
				styleinfolist[styleinfo.style][#styleinfolist[styleinfo.style]+1] = j;
			end
		end

	end

	if str == nil and cnt == nil then
		for k = 1, #styleinfoType do
			local infotype = styleinfoType[k];
			for w = 1, #styleinfolist[infotype]	do
				-- 클리어한 미션 출력 UI 출력
				local index = styleinfolist[infotype][w];
				local stageInfo = stageList:at(index);			
				local styleinfo = stageInfo:GetStyleInfoQuest();
				if IS_STYLE_INFO_CHECK(styleinfo) and styleinfo.remainOption == true then
					local titleName = stageInfo:GetTitleName();
					if titleName ~= "" then
						y = ATTACH_QUEST_CTRLSET_TEXT(ctrlset, "ITEM_TITLE_"..index, "{@st41_yellow} ".. titleName, startx, y);
					end

					if  styleinfo.curCount ~= -1 and styleinfo.curCount < styleinfo.count then
						-- 미션이 클리어 됬으니 목표 수치를 못채웠어도 클리어 표시(O 아이콘)로 바꿔주기위해 curCount변경
						styleinfo.curCount = styleinfo.count;
					end

					y = ATTACH_STYLE_INFO_CTRLSET(ctrlset, "ITEM_STYLE_INFO_"..styleinfo.valueName, styleinfo.style, styleinfo.text, styleinfo.curCount, styleinfo.count, startx, y);
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

function QUEST_CUSTOM_OPTION_CHECK(frame, ctrl, argStr, argNum)
	local frame2 = ui.GetFrame("questinfoset_2");
	local customOption = GET_CHILD(frame2, "quest_custom", "ui::CCheckBox");
	if argStr ~= "" and argNum >= 0 then
		customOption:SetCheck(argNum);
	end

	if argStr ~= "" then
		customOption:SetUserValue("is_quest_custom_draw", argNum);
	end

	UPDATE_QUESTINFOSET_2(frame2);

end
	
function IS_STYLE_INFO_CHECK(styleinfo)

	if styleinfo ~= nil and styleinfo.text ~= "" and (styleinfo.style == "bar" or styleinfo.style == "text" ) then 
		return true;
	end

	return false;
end
	
function IS_STYLE_INFO_DRAW()
	local frame2 = ui.GetFrame("questinfoset_2");	
	local customOption = GET_CHILD(frame2, "quest_custom", "ui::CCheckBox");
	local value = customOption:GetUserValue("is_quest_custom_draw");
	if value == '-1' then
		return false;
	end

	return true;
end