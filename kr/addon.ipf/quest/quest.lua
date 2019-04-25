-- quest.lua

local tabInfo = {
    progressTab = 0,			-- 진행중
	completeTab  = 1,			-- 완료됨
};

local levelFilter = {
	Min = 0,
	Max = 420,
	Range = 30, -- PC의 +- 레벨 범위.
}

local levelOption = {
	All = 0,
	Suitable = 1,
}

local questViewOptions = {
	level_min = levelFilter.Min,
	level_max = levelFilter.Max,
	modeFilterOptions =  {
		Main = true,
		Sub = false,
		Repeat = false,
		Party = false,
		KeyItem = false,
		Chase = true, -- 가상 모드(추적중인 항목만 보여주기 위한 모드)
	}
};

local questViewOptionsSave = {
	tabInfo = nil,
	levelOption = nil,
	modeFilterOptions = nil,
}


-- UI데이터를 제외한 퀘스트 데이터 모음. (정렬을 위해 index를 1~n 으로 기록)
local questList = {
	progressQuestList = nil,
	completeQuestList = nil,
}

function QUEST_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'QUEST_UPDATE_ALL');
	addon:RegisterMsg('QUEST_UPDATE', 'UPDATE_QUEST_INFO');
	addon:RegisterMsg('UPDATE_SKILLMAP', 'QUEST_UPDATE_ALL');
	addon:RegisterMsg('QUEST_UPDATE_', "UPDATE_QUEST_INFO")
	addon:RegisterMsg('GET_NEW_QUEST', 'NEW_QUEST_ADD');

	-- custom quest
	addon:RegisterMsg('CUSTOM_QUEST_UPDATE', 'ON_CUSTOM_QUEST_UPDATE');
	addon:RegisterMsg('CUSTOM_QUEST_DELETE', 'ON_CUSTOM_QUEST_DELETE');

	-- party quest
	addon:RegisterMsg('PARTY_UPDATE', "ON_PARTY_UPDATE_SHARED_QUEST")

	-- 초기화 함수에서 퀘스트 목록을 제거한다. 
	questList = nil;
	questViewOptionsSave =
	{
		tabInfo = nil,
		levelOption = nil,
		modeFilterOptions = nil,
	}
	
end

local function _CHECK_QUEST_LIST(tabIndex)
	if questList == nil then
		questList = {
			progressQuestList = nil,
			completeQuestList = nil,
		}
	end

	if tabIndex == tabInfo.progressTab then
		if questList.progressQuestList == nil then
			questList.progressQuestList = {}
		end
	elseif tabIndex == tabInfo.completeTab then
		if questList.completeQuestList == nil then			
			questList.completeQuestList = {}
		end
	end
end

local function _GET_QUEST_LIST(tabIndex)

	_CHECK_QUEST_LIST(tabIndex)

	if tabIndex == tabInfo.progressTab then
		return  questList.progressQuestList;
	elseif tabIndex == tabInfo.completeTab then
		return questList.completeQuestList;	
	end

	return nil

end

local function _GET_TITLE_INFO(tabIndex, titleName)
	local list = _GET_QUEST_LIST(tabIndex)
	if list == nil then
		return nil
	end

	for index,titleInfo in pairs(list) do
		if titleInfo.name == titleName then
			return titleInfo;
		end
	end

	return nil;
end

local function _REMOVE_TITLE_INFO(tabIndex, titleName)
	local list = _GET_QUEST_LIST(tabIndex)
	if list == nil then
		return nil
	end
	
	for id=#list, 1, -1 do
		local titleInfo = list[id]
		if titleInfo.name == titleName then
			table.remove(list, id);
		end
	end
end

local function _SET_QUEST_INFO(tabIndex, titleName, questClassID, state, abandonCheck)
	local titleInfo = _GET_TITLE_INFO(tabIndex, titleName)
	if titleInfo == nil then
		--titleInfo가 없으면 생성	
		local list = _GET_QUEST_LIST(tabIndex)
		local makeTitleInfo = {
				name = titleName,
				isOpened = true,
				questInfoList ={}
			}
		local index = #list;
		list[index + 1] = makeTitleInfo
		titleInfo = list[index + 1]
	end

	-- 이미 들어 있으면 갱신.
	for index, questInfo in pairs(titleInfo.questInfoList) do
		if questInfo.QuestClassID == questClassID then
			questInfo.State = state;
			questInfo.AbandonCheck = abandonCheck;
			return 
		end
	end

	-- 없으면 끝에 추가.
	local questIndex = #titleInfo.questInfoList;
	titleInfo.questInfoList[questIndex + 1] = { State = state,
												AbandonCheck = abandonCheck, 
												QuestClassID = questClassID 
											  }
end

local function _GET_QUEST_INFO(tabIndex, titleName, questClassID)
	local titleInfo = _GET_TITLE_INFO(tabIndex, titleName)
	if titleInfo == nil then
		return nil;
	end

	-- 이미 들어 있으면 갱신.
	for index, questInfo in pairs(titleInfo.questInfoList) do
		if questInfo.QuestClassID == questClassID then
			return questInfo
		end
	end

	return nil;
end

local function _REMOVE_QUEST_INFO(tabIndex, titleName, questClassID)
	
	local list = _GET_TITLE_INFO(tabIndex, titleName)
	if list == nil then
		return
	end

	local questInfoList = list.questInfoList;
	for id=#questInfoList, 1, -1 do
		local questInfo = questInfoList[id]
		if questInfo.QuestClassID == questClassID then
			table.remove(questInfoList, id);
		end
	end

	-- questlist의 개수가 0이면 TITLE도 지워준다.
	if #questInfoList == 0 then
		_REMOVE_TITLE_INFO(tabIndex, titleName)
	end
end

local function _COPY_TABLE(obj)
	if type(obj) ~= 'table' then return obj end
	local res = setmetatable({}, getmetatable(obj))
	for k, v in pairs(obj) do res[_COPY_TABLE(k)] = _COPY_TABLE(v) end
	return res
end

local function _CHECK_SAVE_OPTION()
	if questViewOptionsSave  == nil then
		questViewOptionsSave = {
			tabInfo = nil,
			levelOption = nil,
			modeFilterOptions = nil,
		}
	end
end

local function _RESET_QUEST_MODE_FILTER(frame)
	if frame == nil then
		return
	end

	_CHECK_SAVE_OPTION()

	if questViewOptionsSave.modeFilterOptions ~=nil then
		questViewOptions.modeFilterOptions = nil;
		questViewOptions.modeFilterOptions = _COPY_TABLE(questViewOptionsSave.modeFilterOptions);
		return
	end

	questViewOptions.modeFilterOptions =  
	{ 
		Main = true, 
		Sub = false, 
		Repeat = false,		
		Party = false, 
		KeyItem = false,							
		Chase = true, -- 가상 모드(추적중인 항목만 보여주기 위한 모드)
	};

	_SAVE_QUEST_MODE_FILTER()
end

function _SAVE_QUEST_MODE_FILTER()
	_CHECK_SAVE_OPTION()

	if questViewOptions.modeFilterOptions ~= nil then
		questViewOptionsSave.modeFilterOptions  = _COPY_TABLE(questViewOptions.modeFilterOptions);
	end
end

local function _RESET_QUEST_TAB_INFO(frame)
	if frame == nil then
		return
	end
	
	_CHECK_SAVE_OPTION()
	local tabIndex = tabInfo.progressTab
	if questViewOptionsSave.tabInfo ~= nil then
		tabIndex = questViewOptionsSave.tabInfo
		return
	end

	frame:SetUserValue("CurTabIndex", tabIndex);
	local questbox_tab = GET_CHILD_RECURSIVELY(frame, 'questBox', "ui::CTabControl");
	questbox_tab:SelectTab(tabIndex);

	_SAVE_QUEST_TAB_INFO()
end

function _SAVE_QUEST_TAB_INFO()
	_CHECK_SAVE_OPTION()

	local frame = ui.GetFrame('quest')
	if frame == nil then
		questViewOptionsSave.tabInfo = tabInfo.progressTab
		return
	end

	local tabIndex = frame:GetUserIValue('CurTabIndex')
	questViewOptionsSave.tabInfo = tabIndex
end

local function _RESET_QUEST_LEVEL_OPTION(frame)
	_CHECK_SAVE_OPTION()

	local tabIndex =  tabInfo.progressTab
	local frame = ui.GetFrame('quest')
	if frame ~= nil then
		tabIndex = frame:GetUserIValue('CurTabIndex')
	end

	if questViewOptionsSave.levelOption ~= nil then

		local preFixName = 'progress';
		if tabIndex == tabInfo.completeTab then
			preFixName = 'complete';
		end

		-- 모든 레벨
		local allCtrlName = preFixName .. 'LeveLFilterOpt_1';
		local allCtrlRadio = GET_CHILD_RECURSIVELY(frame, allCtrlName);
		if allCtrlRadio ~= nil then
			AUTO_CAST(allCtrlRadio);

			if questViewOptionsSave.levelOption == levelOption.All then
			--	allCtrlRadio:SetCheck(true);
				allCtrlRadio:Select();
			else
				allCtrlRadio:SetCheck(false);
			end
		end

		-- 적정 레벨
		local suitableCtrlName = preFixName .. 'LeveLFilterOpt_2';
		local suitableCtrlRadio = GET_CHILD_RECURSIVELY(frame, suitableCtrlName);
		if suitableCtrlRadio ~= nil then
			AUTO_CAST(suitableCtrlRadio);
			if questViewOptionsSave.levelOption == levelOption.Suitable then
				--suitableCtrlRadio:SetCheck(true);
				suitableCtrlRadio:Select();
			else
				suitableCtrlRadio:SetCheck(false);
			end
		end
	end
	
	-- 레벨 필터 초기화
	local levelOption = GET_QUEST_LEVEL_OPTION(tabIndex);
	if levelOption ~= nil then
		SET_QUEST_LEVEL_OPTION(levelOption);
	else -- nil 일경우 현재 level을 +10까지를 범위로 잡음.
		local lv = GETMYPCLEVEL();
		if lv ~= nil then
			questViewOptions.level_min = levelFilter.Min;
			questViewOptions.level_max = lv + levelFilter.Range;
			if questViewOptions.level_max > levelFilter.Max then
				questViewOptions.level_max = levelFilter.Max;
			end
		end
	end

	_SAVE_QUEST_LEVEL_OPTION()
end

function _SAVE_QUEST_LEVEL_OPTION()
	_CHECK_SAVE_OPTION()

	local frame = ui.GetFrame('quest')
	if frame == nil then
		questViewOptionsSave.levelOption = levelOption.All
		return
	end

	local tabIndex = frame:GetUserIValue('CurTabIndex')
	local levelOption = GET_QUEST_LEVEL_OPTION(tabIndex);
	questViewOptionsSave.levelOption = levelOption
end

function _QUEST_VIEW_FILTER_RESET(frame)
	_RESET_QUEST_MODE_FILTER(frame);
	_RESET_QUEST_TAB_INFO(frame)
	_RESET_QUEST_LEVEL_OPTION(frame)
	local questtypeFilter = GET_CHILD_RECURSIVELY(frame, "questtypeFilter");
	QUEST_MODE_FILTER_CHANGE(frame, questtypeFilter, true);
end

function QUEST_FRAME_OPEN(frame)  
	_QUEST_VIEW_FILTER_RESET(frame)
	QUEST_TAB_CHANGE(frame)
end

function QUEST_FRAME_CLOSE(frame)
	local questDetailFrame = ui.GetFrame('questdetail');
	if questDetailFrame:IsVisible() == 1 then
		questDetailFrame:ShowWindow(0);
	end

	local questfilterFrame = ui.GetFrame('quest_filter');
	if questfilterFrame:IsVisible() == 1 then
		questfilterFrame:ShowWindow(0);
	end
end

function UI_TOGGLE_QUEST()
	if app.IsBarrackMode() == true then
		return;
	end
	ui.ToggleFrame('quest')
end

function NEW_QUEST_ADD(frame, msg, argStr, argNum) 
	
	local questIES = GetClassByType("QuestProgressCheck", argNum);
	local sobjIES = GET_MAIN_SOBJ();

	local ret = QUEST_ABANDON_RESTARTLIST_CHECK(questIES, sobjIES);
	local questState = SCR_QUEST_CHECK(sobjIES, questIES.ClassName);
	--퀘스트 중 대화만 끝나면 바로 success인 퀘스트가 있다. 이런 퀘스트도 수락시 지령창에 표시함

	-- new quest check
	if ret == 'NOTABANDON' or questState == 'SUCCESS' then
        local isNew = 0
		if questState == 'SUCCESS' or (questIES.QuestMode ~= nil and (questIES.QuestMode == 'MAIN' or questIES.QuestMode == "SUB" or questIES.QuestMode == "REPEAT" or  questIES.QuestMode == "PARTY")) then
            isNew = 1
		end
		
		if isNew == 1 and quest.IsCheckQuest(argNum) == false then
			if quest.GetCheckQuestCount() < 5 then		
				quest.AddCheckQuest(argNum);
				local questframe2 = ui.GetFrame("questinfoset_2");
				UPDATE_QUESTINFOSET_2(questframe2); -- infoset에 보여줌.
			end
		end
	end

	-- 퀘스트 정보 업데이트
	if questIES ~= nil then
		_UPDATE_QUEST_INFO(questIES)
	end

	-- 퀘스트창이 열려있다면 다시 그려줄 수 있도록 예약.
	QUEST_RESERVE_DRAW_LIST(frame)
end

function QUEST_UPDATE_ALL(frame)
	frame = ui.GetFrame("quest")
	
	local clsList, cnt = GetClassList("QuestProgressCheck");
	for i = 0, cnt -1 do
		local questIES = GetClassByIndexFromList(clsList, i);
		_UPDATE_QUEST_INFO(questIES)
	end
	-- sort
	SORT_QUEST_LIST(frame)
	-- draw
	DRAW_QUEST_LIST(frame)
end

function SORT_QUEST_LIST(frame)
	if frame == nil then
		frame = ui.GetFrame('quest')
	end
	local tabIndex = frame:GetUserIValue('CurTabIndex')
	local questList = _GET_QUEST_LIST(tabIndex)
	-- title info sort
	table.sort(questList, SORT_TITLE_INFO_FILTER);

	-- quest list sort
	for index, titleInfo in pairs(questList) do
		if tabIndex == tabInfo.progressTab then
			table.sort(titleInfo.questInfoList, SORT_QUEST_PROGRESS_INFO_FILTER)
		elseif tabIndex == tabInfo.completeTab then
			table.sort(titleInfo.questInfoList, SORT_QUEST_COMPLETE_INFO_FILTER)
		end
	end
end

function UPDATE_QUEST_LIST()
	local frame = ui.GetFrame('quest')
	if frame == nil then
		return 
	end

	QUEST_RESERVE_DRAW_LIST(frame)
end

function DRAW_QUEST_LIST(frame)
	if frame == nil then
		frame = ui.GetFrame('quest')
	end
	
	-- 퀘스트 창이 닫혀 있다면 갱신하지 않고 리턴
	if frame:IsVisible() == 0 then
		return 
	end
	
	local bgCtrl = nil
	local tabIndex = frame:GetUserIValue('CurTabIndex')
	if tabIndex == tabInfo.progressTab then
		bgCtrl = GET_CHILD_RECURSIVELY(frame, 'questGbox');
	elseif tabIndex == tabInfo.completeTab then
		bgCtrl = GET_CHILD_RECURSIVELY(frame, 'completeGbox');
	end

	if bgCtrl == nil then
		return
	end
	
	bgCtrl:RemoveAllChild()
	
	-- 컨트롤 그리기.
	local y = 0
	if tabIndex == tabInfo.progressTab then
		-- 커스텀 퀘스트
		-- y = y + DRAW_CUSTOM_QUEST_LIST(frame, y)  -- 퀘스트창에 보여질 할 이유가 없으므로 주석처리함.
		-- 추적 퀘스트 (항상 최상단)
		if questViewOptions.modeFilterOptions['Chase'] == true then
			y = y + DRAW_CHASE_QUEST_LIST(frame, y) 
		end
	end
	
	-- 일반 퀘스트
	local questList = _GET_QUEST_LIST(tabIndex)
	for notUse, titleInfo in pairs(questList) do
		y = y + DRAW_QUEST_CTRL(bgCtrl, titleInfo, y)
	end
	
	bgCtrl:Invalidate()
	frame:Invalidate();
end

function _UPDATE_QUEST_INFO(questIES)
	if questIES == nil then
		return 
	end

	local pc = GetMyPCObject();
	local sobjIES = GET_MAIN_SOBJ();
	local questClassName = questIES.ClassName
	if questClassName ~= "None" then
		if IS_ABOUT_JOB(questIES) == false then 
			local abandonCheck = QUEST_ABANDON_RESTARTLIST_CHECK(questIES, sobjIES); -- 포기퀘스트 체크
			local questState = SCR_QUEST_CHECK_C(pc, questClassName); 					 -- 퀘스트 상태
			local questInfo = {
				State = questState,
				AbandonCheck = abandonCheck, 
				QuestClassID = questIES.ClassID,
			};

			SET_QUEST_INFO(questIES, questInfo)
		end
	end
end

function UPDATE_QUEST_INFO(frame, msg, argStr, argNum) 
	local questIES = GetClassByType("QuestProgressCheck", argNum);
	-- 퀘스트 정보 업데이트
	if questIES ~= nil then
		_UPDATE_QUEST_INFO(questIES)
	end
end

function GET_QUEST_TAB_INDEX(state)

	if state == 'COMPLETE' then
		return tabInfo.completeTab
	end

	return tabInfo.progressTab
end

function INVALIDATE_QUEST_INFO(tabIndex, questIES, questInfo)

	local list = { "Start", "Prog", "End"}
	local state = CONVERT_STATE(questInfo.State);
	local titleName = questIES[state .. "Map"]
	if titleName == "None" then
		titleName = "ETC"
	end

	for notUse,stateName in pairs(list) do
		-- 맵이 틀릴 때
		local curName = questIES[stateName .. "Map"]
		if curName == "None" then
			curName = "ETC"
		end

		if state ~= stateName and titleName ~= curName then
			-- 해당 맵에 들어 있는 QUEST_INFO를 제거함.
			_REMOVE_QUEST_INFO(tabIndex, curName, questIES.ClassID)
		end
	end

end

function SET_QUEST_INFO(questIES, questInfo)
	-- IMPOSSIBLE 이거나 존서브퀘스트들. 아직 보여지지 않아야 하는 퀘스트들 확인.
	if CHECK_QUEST_VIEW_HIDE(questIES, questInfo.State, questInfo.AbandonCheck ) == true then
		-- 걸러져야 하는데 추적중인 항목이면 추적을 해제한다.
		if quest.IsCheckQuest(questIES.ClassID) == true then
			quest.RemoveCheckQuest(questIES.ClassID);
		end
		return
	end

	-- progress / complete 위치 결정
	local tabIndex =  GET_QUEST_TAB_INDEX(questInfo.State);
	local state = CONVERT_STATE(questInfo.State);
	local titleName = questIES[state .. "Map"]
	if titleName == "None" then
		titleName = "ETC"
	end

	-- 다른 상태일 때의 맵에 해당 정보가 있는지 확인해서 지워야한다.
	INVALIDATE_QUEST_INFO(tabIndex, questIES, questInfo)

	-- 완료 탭 정보라면 진행중 탭에 있는 정보를 제거 해야 한다.
	if tabIndex == tabInfo.completeTab then
		_REMOVE_QUEST_INFO(tabInfo.progressTab, titleName, questIES.ClassID )
		-- 또한 추적중인 상태를 해제한다.
		if quest.IsCheckQuest(questIES.ClassID) == true then
			quest.RemoveCheckQuest(questIES.ClassID);
		end
	end

	_SET_QUEST_INFO(tabIndex, titleName, questInfo.QuestClassID, questInfo.State, questInfo.AbandonCheck)
end

-- titleinfo 정보를 가지고 컨트롤을 생성함.
function DRAW_QUEST_CTRL(bgCtrl, titleInfo, y)
	if bgCtrl == nil then
		return 0;
	end
	
	local questInfoCount = #titleInfo.questInfoList;
	if questInfoCount == 0 then
		return 0;
	end

	local titleCtrlSet = bgCtrl:CreateOrGetControlSet('quest_list_title', titleInfo.name, 0, y );
	if titleCtrlSet == nil then
		return 0;
	end
	titleCtrlSet = tolua.cast(titleCtrlSet, "ui::CControlSet");

	-- title 정보 설정
	local mapCls = GetClass("Map", titleInfo.name)
	local mapName = ClMsg("EtcMapQuestTitle")
	if mapCls ~= nil then
		mapName = mapCls.Name
	end
	local questMapNameText = GET_CHILD_RECURSIVELY(titleCtrlSet, "questMapNameText")
	questMapNameText:SetTextByKey("mapName", mapName)
	questMapNameText:SetTextByKey("count", questInfoCount) -- #1 우선 모든 퀘스트 숫자를 넣음.
	local openMark = GET_CHILD_RECURSIVELY(titleCtrlSet, "openMark")
	openMark:SetImage(titleCtrlSet:GetUserConfig("OPENED_CTRL_IMAGE"))

	-- child 설정.
	local drawTargetCount = 0
	local questCtrlTotalHeight =0;
	local questListGbox = GET_CHILD_RECURSIVELY(titleCtrlSet, "questListGbox")
	local controlSetType = "quest_list_oneline"
	local controlsetHeight = ui.GetControlSetAttribute(controlSetType, 'height');
	
	if  questListGbox ~= nil then
		-- 오픈 마크 처리.
		if titleInfo.isOpened == true then
		
			openMark:SetImage(titleCtrlSet:GetUserConfig("CLOSED_CTRL_IMAGE"))
		end

		-- 퀘스트 목록 순회.
		local cnt = 1
		for index = 1, questInfoCount do
			local questInfo = titleInfo.questInfoList[index]
			-- filter 적용
			if CHECK_QUEST_VIEW_FILTER(titleInfo.name, questInfo) == true then
				
				if titleInfo.isOpened == true then -- 트리가 열려있을 때만 컨트롤 생성
					local ctrlName = "_Q_" .. questInfo.QuestClassID;
					local Quest_Ctrl = questListGbox:CreateOrGetControlSet(controlSetType, ctrlName, 5, controlsetHeight * (drawTargetCount));			
					
					-- 배경 설정.
					if cnt % 2 == 1 then
						Quest_Ctrl:SetSkinName("chat_window_2");
					else
						Quest_Ctrl:SetSkinName('None');
					end
					cnt = cnt +1
					
					-- detail 설정
					UPDATE_QUEST_CTRL(Quest_Ctrl, questInfo );

					questCtrlTotalHeight = questCtrlTotalHeight + Quest_Ctrl:GetHeight();
				end

				drawTargetCount = drawTargetCount +1
			end
		end	
	end

	--#1 실제로 그려진 퀘스트 갯수로 조정함.
	questMapNameText:SetTextByKey("count", drawTargetCount)
	
	titleCtrlSet:Resize(titleCtrlSet:GetWidth(),titleCtrlSet:GetHeight() + questCtrlTotalHeight )
	questListGbox:Resize(questListGbox:GetWidth(), questCtrlTotalHeight)
	titleCtrlSet:Invalidate();


	-- 필터에 의해 걸러져서 원래 그려야 할 목록이 0개라면 title도 그리지 않아야 한다.
	if  drawTargetCount == 0 then
		bgCtrl:RemoveChild(titleInfo.name);
		return 0;
	end

	return titleCtrlSet:GetHeight()
end

function SET_QUEST_CTRL_MARK(ctrl, questIES, state)
	local Quest_Ctrl = 	tolua.cast(ctrl, "ui::CControlSet"); 
	
	local questIconImgName = GET_ICON_BY_STATE_MODE(state, questIES);
	local questTab = questIES.QuestMode;
	local questMarkPic = GET_CHILD(Quest_Ctrl, "questmark", "ui::CPicture");
	local questTabTxt = ClMsg(questTab)..' '..ClMsg("Quest")

	if state == 'POSSIBLE' then
        questMarkPic:EnableHitTest(1);
        questMarkPic:SetTextTooltip("{@st59}"..questTabTxt.." '"..questIES.Name..ScpArgMsg("Auto_'_SiJag_KaNeungHapNiDa{/}"))
    elseif state == 'PROGRESS' then
        questMarkPic:EnableHitTest(1);
        questMarkPic:SetTextTooltip("{@st59}"..questTabTxt.." '"..questIES.Name..ScpArgMsg("Auto_'_JinHaeng_JungipNiDa{/}"))
    elseif state == 'SUCCESS' then
        questMarkPic:EnableHitTest(1);
        questMarkPic:SetTextTooltip("{@st59}"..questTabTxt.." '"..questIES.Name..ScpArgMsg("Auto_'_BoSangeul_BateuSeyo{/}"))
    end

	questMarkPic:ShowWindow(1);
	questMarkPic:SetImage(questIconImgName);
	
end

function SET_QUEST_CTRL_TEXT(ctrl, questIES)
	local Quest_Ctrl = 	tolua.cast(ctrl, "ui::CControlSet"); 
	local nametxt = GET_CHILD(Quest_Ctrl, "name", "ui::CRichText");
	local leveltxt = GET_CHILD(Quest_Ctrl, "level", "ui::CRichText");

	local textFont = ""
	local textColor = ""
	if questIES.QuestMode =="MAIN" then
		textFont = Quest_Ctrl:GetUserConfig("MAIN_FONT")
		textColor = Quest_Ctrl:GetUserConfig("MAIN_COLOR")
	elseif questIES.QuestMode =="SUB" then
		textFont = Quest_Ctrl:GetUserConfig("SUB_FONT")
		textColor = Quest_Ctrl:GetUserConfig("SUB_COLOR")
	elseif questIES.QuestMode =="REPEAT" then
		textFont = Quest_Ctrl:GetUserConfig("REPEAT_FONT")
		textColor = Quest_Ctrl:GetUserConfig("REPEAT_COLOR")
	elseif questIES.QuestMode =="PARTY" then
		textFont = Quest_Ctrl:GetUserConfig("PARTY_FONT")
		textColor = Quest_Ctrl:GetUserConfig("PARTY_COLOR")
	elseif questIES.QuestMode =="KEYITEM" then
		textFont = Quest_Ctrl:GetUserConfig("KEYITEM_FONT")
		textColor = Quest_Ctrl:GetUserConfig("KEYITEM_COLOR")
	end

	-- 퀘스트 레벨과 이름의 폰트 및 색상 지정.
	nametxt:SetText(textFont .. textColor .. questIES.Name)	
	leveltxt:SetText(textColor .. textColor .. "Lv " .. questIES.Level)

end

function SET_QUEST_CTRL_BTN(ctrl, questIES, state , abandonCheck)
	local Quest_Ctrl = 	tolua.cast(ctrl, "ui::CControlSet"); 
	
	local isComplete = false
	if state == "COMPLETE" then
		isComplete = true;
	end

	local shareParty = GET_CHILD(Quest_Ctrl, "shareParty", "ui::CCheckBox");
	if shareParty ~= nil then
		shareParty:SetEventScriptArgNumber(ui.LBUTTONUP, questIES.ClassID);
	end

	local questPositionCheck = GET_CHILD(Quest_Ctrl, "questPositionCheck", "ui::CButton");
	if questPositionCheck ~= nil then
		questPositionCheck:SetEventScriptArgNumber(ui.LBUTTONUP, questIES.ClassID);
	end

	local abandonquest_try = GET_CHILD(Quest_Ctrl, "abandonquest_try", "ui::CButton");
	if abandonquest_try ~= nil then
		abandonquest_try:SetEventScriptArgNumber(ui.LBUTTONUP, questIES.ClassID);
	end

	local dialogReplay = GET_CHILD(Quest_Ctrl, "dialogReplay", "ui::CButton");
	if dialogReplay ~= nil then
		dialogReplay:SetEventScriptArgNumber(ui.LBUTTONUP, questIES.ClassID);
	end

	local abandon = GET_CHILD(Quest_Ctrl, "abandon", "ui::CButton");
	if abandon ~= nil then
		abandon:SetEventScriptArgNumber(ui.LBUTTONUP, questIES.ClassID);
	end

	local chase = GET_CHILD(Quest_Ctrl, "chase", "ui::CCheckBox");

	if isComplete == true then
		-- check btn 제거
		chase:ShowWindow(0)

		-- 다이얼로그 버튼을 제외한 나머지 버튼 제거
		shareParty:ShowWindow(0)
		questPositionCheck:ShowWindow(0)
		abandonquest_try:ShowWindow(0)
		abandon:ShowWindow(0)
	
		-- 다이얼로그 버튼 이동
		local rect = abandon:GetMargin();
		dialogReplay:SetMargin(rect.left, rect.top, rect.right, rect.bottom)
	else
		abandon:ShowWindow(0)
		abandonquest_try:ShowWindow(0)
		questPositionCheck:ShowWindow(0)

		-- 포기 버튼 활성화.
		if questIES.AbandonUI == 'YES' and (state == "PROGRESS" or state == 'SUCCESS') then 
			abandon:ShowWindow(1)
		end

		-- 포기한 퀘스트라면 재시작 버튼을 활성화.
		if abandonCheck == "ABANDON/LIST" and state == 'POSSIBLE' then
			abandonquest_try:ShowWindow(1)
			abandon:ShowWindow(0)
		end

		-- 위치정보를 사용할 수 있는지 확인
		if CHECK_QUEST_LOCATION(questIES) == true then
			questPositionCheck:ShowWindow(1)
		end
	
		if IS_SHARED_QUEST(questIES.ClassID) == true then
			shareParty:SetCheck(1)
		end

		-- 추적 버튼
		chase:SetTextTooltip(ScpArgMsg("Auto_{@st59}CheKeu_HaMyeon_HwaMyeon_oLeunJjoge_KweSeuTeu_alLiMiKa_NaopNiDa{nl}KweSeuTeu_alLiMiNeun_ChoeDae_5KaeKkaJi_DeungLog_KaNeungHapNiDa{/}"))
		-- 추적중인 퀘스트의 경우 체크박스에 체크를 해야한다.
		if quest.IsCheckQuest(questIES.ClassID) == true then 
			if (state == "POSSIBLE" or state == "SUCCESS") and SCR_ISFIRSTJOBCHANGEQUEST(questIES) == 'NO' and questIES.POSSI_WARP ~= 'YES' then			
				chase:SetCheck(1);
				ADD_QUEST_INFOSET_CTRL(Quest_Ctrl:GetTopParentFrame(), chase, 'None', questIES.ClassID, true);	
			else
				quest.AddCheckQuest(questIES.ClassID);
				chase:SetCheck(1);
				ADD_QUEST_INFOSET_CTRL(Quest_Ctrl:GetTopParentFrame(), chase, 'None', questIES.ClassID, true);
			end

		end
		chase:SetEventScript(ui.LBUTTONDOWN, "ADD_QUEST_INFOSET_CTRL");
		chase:SetEventScriptArgNumber(ui.LBUTTONDOWN, questIES.ClassID);
		chase:SetEventScript(ui.LBUTTONUP, "UPDATE_QUEST_LIST");
		
	end
end

function UPDATE_QUEST_CTRL(ctrl, questInfo)
	
	local Quest_Ctrl = 	tolua.cast(ctrl, "ui::CControlSet"); 

	local state = questInfo.State;
	local abandonCheck = questInfo.AbandonCheck;
	local questID = questInfo.QuestClassID;
	local questIES = GetClassByType('QuestProgressCheck',questID)
	
	-- 퀘스트 마크 설정
	SET_QUEST_CTRL_MARK(Quest_Ctrl, questIES, state);

	-- 레벨, 이름 설정.
	SET_QUEST_CTRL_TEXT(Quest_Ctrl, questIES)

	-- 버튼 설정
	SET_QUEST_CTRL_BTN(Quest_Ctrl, questIES, state , abandonCheck)

	-- 컨트롤 설정
	Quest_Ctrl:SetUserValue("QUEST_CLASSID", questIES.ClassID);
	Quest_Ctrl:SetUserValue("QUEST_LEVEL", questIES.Level)

	Quest_Ctrl:SetEventScript(ui.LBUTTONDOWN, "QUEST_CLICK_INFO");
	Quest_Ctrl:SetEventScriptArgNumber(ui.LBUTTONDOWN, questID);

	Quest_Ctrl:SetEventScript(ui.RBUTTONUP, "RUN_EDIT_QUEST_REWARD");
	Quest_Ctrl:SetEventScriptArgNumber(ui.RBUTTONUP, questID);

	Quest_Ctrl:ShowWindow(1);
	Quest_Ctrl:EnableHitTest(1);
    Quest_Ctrl:SetTextTooltip(ScpArgMsg("ClickToViewDetailInfomation"))
end

function ADD_QUEST_INFOSET_CTRL(frame, ctrl, argStr, questClassID, notUpdateRightUI)
	tolua.cast(ctrl, "ui::CCheckBox");   
	if ctrl:IsChecked() == 1 then
		quest.AddCheckQuest(questClassID);                
		if quest.GetCheckQuestCount() > 5 then
			ctrl:SetCheck(0);
			quest.RemoveCheckQuest(questClassID);            
			return;
		end
	else
		quest.RemoveCheckQuest(questClassID);        
	end

	if notUpdateRightUI ~= true then
		local questframe2 = ui.GetFrame("questinfoset_2");
		UPDATE_QUESTINFOSET_2(questframe2);
	end

	
end

function SORT_TITLE_INFO_FILTER(a,b)
	if a == nil or b == nil then
		return false;
	end

	local mapClsA = GetClass("Map", a.name)
	local mapNameA = ClMsg("EtcMapQuestTitle")
	local levelA = 9999;
	if mapClsA ~= nil then
		levelA = mapClsA.QuestLevel
		mapNameA = mapClsA.Name
	end

	local mapClsB = GetClass("Map", b.name)
	local mapNameB = ClMsg("EtcMapQuestTitle")
	local levelB = 9999;
	if mapClsB ~= nil then
		levelB = mapClsB.QuestLevel
		mapNameB = mapClsB.Name
	end

	-- 1. level
	 if tonumber(levelA) < tonumber(levelB) then
		return true;
	 elseif tonumber(levelA) > tonumber(levelB) then
	 	return false;
	 end
	
	-- 2. name
	if tonumber(levelA) == tonumber(levelB) and string.upper(mapNameA) < string.upper(mapNameB) then
		return true;
	end


	return false;
end

function SORT_QUEST_PROGRESS_INFO_FILTER(a, b)
	if a == nil or b == nil then
		return false;
	end

	local questA_ID = a.QuestClassID;
	local questB_ID = b.QuestClassID;
	if questA_ID == nil or questB_ID == nil then
		return false;
	end

	local questA_IES = GetClassByType('QuestProgressCheck',questA_ID)
	local questB_IES = GetClassByType('QuestProgressCheck',questB_ID)
	if questA_IES == nil or questB_IES == nil then
		return false;
	end

	-- 1. level
	local levelA = questA_IES.Level;
	local levelB = questB_IES.Level;
	if tonumber(levelA) < tonumber(levelB) then
		return true;
	elseif tonumber(levelA) > tonumber(levelB) then
		return false;
	end

	-- 2. name
	local nameA = questA_IES.Name;
	local nameB = questB_IES.Name;
	if tonumber(levelA) == tonumber(levelB) and string.upper(nameA) < string.upper(nameB) then
		return true;
	end

	return false;
end

function SORT_QUEST_COMPLETE_INFO_FILTER(a, b)
	if a == nil or b == nil then
		return false;
	end

	local questA_ID = a.QuestClassID;
	local questB_ID = b.QuestClassID;
	if questA_ID == nil or questB_ID == nil then
		return false;
	end

	local questA_IES = GetClassByType('QuestProgressCheck',questA_ID)
	local questB_IES = GetClassByType('QuestProgressCheck',questB_ID)
	if questA_IES == nil or questB_IES == nil then
		return false;
	end

	-- 1. name
	local nameA = string.upper(questA_IES.Name);
	local nameB =  string.upper(questB_IES.Name);
	if nameA < nameB then
		return true;
	elseif nameA > nameB then
		return false;
	end

	-- 2. level
	local levelA = questA_IES.Level;
	local levelB = questB_IES.Level;
	if nameA == nameB and tonumber(levelA) < tonumber(levelB) then
		return true;
	end

	return false;
end

function CHECK_QUEST_VIEW_FILTER(titleName, questInfo) 
	local frame = ui.GetFrame("quest")
	if frame == nil then
		return true;
	end

	local tabIndex = frame:GetUserIValue('CurTabIndex')
	if tabIndex == nil then
		return true;
	end

	local ret = true;
	if tabIndex == tabInfo.progressTab then
		ret = CHECK_PROGRESS_QUEST_VIEW_FILTER(titleName, questInfo)
	elseif tabIndex == tabInfo.completeTab then
		ret = CHECK_COMPLETE_QUEST_VIEW_FILTER(titleName, questInfo)
	end

	return ret
end

local function _TRANS_MODE_STRING(questMode )

	local modeStr = "";
	if questMode == 'MAIN' then
		modeStr = "Main";
	elseif questMode == 'SUB' then
		modeStr = "Sub";
	elseif questMode == 'REPEAT' then
		modeStr = "Repeat";
	elseif questMode == 'PARTY' then
		modeStr = "Party";
	elseif questMode == 'KEYITEM' then
		modeStr = "KeyItem";
	end

	return modeStr;
end

function CHECK_PROGRESS_QUEST_VIEW_FILTER(titlename, questInfo)
	local state = questInfo.State
	local abandonCheck = questInfo.AbandonCheck
	local questClassID = questInfo.QuestClassID

	-- check box filter
	local isViewPossibleQuest = config.GetXMLConfig("ViewPossibleQuest")
	local isViewProgressQuest = config.GetXMLConfig("ViewProgressQuest")
	local isViewAbandonQuest = config.GetXMLConfig("ViewAbandonQuest")

	if isViewPossibleQuest == 0 and state == 'POSSIBLE' then
		if isViewAbandonQuest == 0 then
			return false;
		elseif isViewAbandonQuest == 1 and abandonCheck ~= 'ABANDON/LIST' then
			return false;
		end
	elseif isViewProgressQuest == 0 and (state == 'PROGRESS' or state == 'SUCCESS') then
		if isViewAbandonQuest == 0 then
			return false;
		elseif isViewAbandonQuest == 1 and abandonCheck ~= 'ABANDON/LIST' then
			return false;
		end
	end

	if isViewAbandonQuest == 0 and abandonCheck == 'ABANDON/LIST' then
		return false;
	end

	local questIES = GetClassByType('QuestProgressCheck', questClassID)
	if questIES == nil then
		return false;
	end

	-- Mode Filter
	local modeStr = _TRANS_MODE_STRING(questIES.QuestMode)
	local isModeCorrect = false;
	for key, value in pairs(questViewOptions.modeFilterOptions ) do
		if key == modeStr and value == true then
			isModeCorrect = true;
			break;
		end
	end
	
	-- 추적 필터
	if quest.IsCheckQuest(questClassID) == true and questViewOptions.modeFilterOptions['Chase'] == true then
		isModeCorrect = true; 
	end

	if isModeCorrect == false then
		return false;
	end
	
	-- Level Filter
	if quest.IsCheckQuest(questClassID) == false then -- 추적 중인 퀘스트가 아닐 때 레벨 필터를 통과시킨다.
		if questViewOptions.level_min > questIES.Level or questViewOptions.level_max < questIES.Level then
			return false;
		end
	end

	-- add sub mode filter
	if CHECK_QUEST_MODE_ALL(questIES) == false then
	 if  CHECK_SUB_MODE_FILER(questIES) == false then
		return false;
	 end
	end

	-- search text filter
	local frame = ui.GetFrame('quest')
	local searchEdit = GET_CHILD_RECURSIVELY(frame, "questSearch", "ui::CEditBox");
	if searchEdit == nil then
		return true;
	end
	
	local searchText = searchEdit:GetText();
	if searchText == nil or string.len(searchText) == 0 then
		return true;
	end

	string.lower(searchText);

	-- title과 일치하는지 먼저검사.
	if titlename ~= nil then
		local mapCls = GetClass("Map", titlename)
		local mapName = ClMsg("EtcMapQuestTitle")
		if mapCls ~= nil then
			mapName = mapCls.Name
		end
		local titleTransName = dic.getTranslatedStr(mapName)
		string.lower(titleTransName);
		if string.find(mapName, searchText) ~= nil then
			return true;
		end 
	end
	
	-- questName 검사
	local questName = questIES.Name;
	questName = dic.getTranslatedStr(questName)
	questName = string.lower(questName); 

	if string.find(questName, searchText) == nil then
		return false;
	end 

	return true
end

function CHECK_QUEST_MODE_ALL(questIES)
	-- allcheck 확인.
	local allCheck = true
	for k, modeFilter in pairs(questViewOptions.modeFilterOptions) do
		if modeFilter == false then
			allCheck = false;
			break;
		end
	end

	if allCheck == true and questViewOptions.modeFilterOptions['Chase'] == true then
		return true;
	end

	return false;
end

function CHECK_SUB_MODE_FILER(questIES)

	local pc = GetMyPCObject();
	if pc == nil then
		return true;
	end

	local isCorrect = false;
	if questIES.QuestMode == 'SUB' and questViewOptions.modeFilterOptions['Sub'] == true then
		isCorrect = true;
	else 
		return true;
	end

	if isCorrect == true and LINKZONECHECK(GetZoneName(pc), questIES.StartMap) == 'YES'  and QUEST_SUB_VIEWCHECK_LEVEL(pc, questIES) == 'YES' then

		return true
	end
	
	return false
end

function CHECK_COMPLETE_QUEST_VIEW_FILTER(titlename, questInfo)
	local state = questInfo.State
	local abaondonCheck = questInfo.AbandonCheck
	local questClassID = questInfo.QuestClassID

	local questIES = GetClassByType('QuestProgressCheck', questClassID)
	if questIES == nil then
		return false;
	end

	-- Mode Filter
	local modeStr = _TRANS_MODE_STRING(questIES.QuestMode)
	local isModeCorrect = false;
	for key, value in pairs(questViewOptions.modeFilterOptions ) do
		if key == modeStr and value == true then
			isModeCorrect = true;
			break;
		end
	end

	if isModeCorrect == false then
		return false;
	end

	-- Level Filter
	if questViewOptions.level_min > questIES.Level or questViewOptions.level_max < questIES.Level then
		return false;
	end
	
	-- search text filter
	local frame = ui.GetFrame('quest')
	local searchEdit = GET_CHILD_RECURSIVELY(frame, "questSearch2", "ui::CEditBox");
	if searchEdit == nil then
		return true;
	end

	local searchText = searchEdit:GetText();
	if searchText == nil or string.len(searchText) == 0 then
		return true;
	end

	string.lower(searchText);
	-- title과 일치하는지 먼저검사.
	if titlename ~= nil then
		local mapCls = GetClass("Map", titlename)
		local mapName = ClMsg("EtcMapQuestTitle")
		if mapCls ~= nil then
			mapName = mapCls.Name
		end
		local titleTransName = dic.getTranslatedStr(mapName)
		string.lower(titleTransName);
		if string.find(mapName, searchText) ~= nil then
			return true;
		end 
	end
	
	-- questName 검사
	local questName = questIES.Name;
	questName = dic.getTranslatedStr(questName)
	questName = string.lower(questName);

	if string.find(questName, searchText) == nil then
		return false;
	end 

	return true
end

function CLICK_QUEST_MAP_TITLE(ctrl)
	if ctrl == nil then
		return
	end

	local frame = ui.GetFrame('quest')
	if frame == nil then
		return
	end

	local tabIndex = frame:GetUserIValue('CurTabIndex')
	local titleInfo = nil
	if ctrl:GetName() == "quest_command_window" then
		titleInfo = GET_CHASE_TITLE_INFO()
	else
		titleInfo = _GET_TITLE_INFO(tabIndex, ctrl:GetName())
	end

	if titleInfo.isOpened == true then
		titleInfo.isOpened = false;
	else		
		titleInfo.isOpened = true;
	end

	DRAW_QUEST_LIST(frame)
end

function GET_QUEST_LEVEL_OPTION(tabIndex)

	local frame = ui.GetFrame('quest')
	if frame == nil then
		return levelOption.All;
	end
	local preFixName = 'progress';
	if tabIndex == tabInfo.completeTab then
		preFixName = 'complete';
	end
	
	-- 모든 레벨 옵션 체크 확인
	local allCtrlName = preFixName .. 'LeveLFilterOpt_1';
	local allCtrlRadio = GET_CHILD_RECURSIVELY(frame, allCtrlName);
	if allCtrlRadio ~= nil then
		AUTO_CAST(allCtrlRadio);
		if allCtrlRadio:IsChecked() == 1 then
			return levelOption.All;
		end
	end
	-- 적정 레벨 옵션 체크 확인
	local suitableCtrlName = preFixName .. 'LeveLFilterOpt_2';
	local suitableCtrlRadio = GET_CHILD_RECURSIVELY(frame, suitableCtrlName);
	if suitableCtrlRadio ~= nil then
		AUTO_CAST(suitableCtrlRadio);
		if suitableCtrlRadio:IsChecked() == 1 then
			return levelOption.Suitable;
		end
	end

	return nil;
end

function SET_QUEST_LEVEL_OPTION(_levelOption)
	if levelOption == nil then
		return
	end

	if _levelOption == levelOption.All then
		questViewOptions.level_min = levelFilter.Min;
		questViewOptions.level_max = levelFilter.Max;
	elseif _levelOption == levelOption.Suitable then
		local lv = GETMYPCLEVEL();
		if lv == nil then 
			return
		end

		questViewOptions.level_min = lv - levelFilter.Range;
		if questViewOptions.level_min < levelFilter.Min then
			questViewOptions.level_min = levelFilter.Min;
		end

		questViewOptions.level_max = lv + levelFilter.Range;
		if questViewOptions.level_max > levelFilter.Max then
			questViewOptions.level_max = levelFilter.Max;
		end
	end

	_SAVE_QUEST_LEVEL_OPTION()
end

function CLICK_QUEST_LEVEL_OPTION(frame, ctrl, argStr, argNum)
	if ctrl == nil then
		return
	end

	local frame = ui.GetFrame('quest')
	if frame == nil then
		return
	end

	local tabIndex = frame:GetUserIValue('CurTabIndex');
	local levelOption = GET_QUEST_LEVEL_OPTION(tabIndex);
	SET_QUEST_LEVEL_OPTION(levelOption);
	DRAW_QUEST_LIST(ctrl:GetTopParentFrame());
end

function GET_QUEST_MODE_OPTION()
	return questViewOptions.modeFilterOptions;
end

function SET_QUEST_MODE_OPTION(_modeFilterOptions)
	questViewOptions.modeFilterOptions = _modeFilterOptions;
	_SAVE_QUEST_MODE_FILTER()
end

function CLICK_QUEST_MODE_OPTION(frame, ctrl, argStr, argNum)
	QUEST_FILTER_OPEN(frame:GetTopParentFrame(), ctrl );
end

function MOUSE_MOVE_QUEST_MODE_OPTION(frame, ctrl, argStr, argNum)

end

function QUEST_RESET_CHASE(frame, ctrl, argStr, argNum)
	quest.RemoveCheckQuestAll();
	
	-- infoset
	local questframe2 = ui.GetFrame("questinfoset_2");
	UPDATE_QUESTINFOSET_2(questframe2); 
	-- quest
	local topFrame = ui.GetFrame("quest");
	DRAW_QUEST_LIST(topFrame)
end

function QUEST_TAB_CHANGE(frame, argStr, argNum)
	local topFrame = frame:GetTopParentFrame();
	local questGbox = GET_CHILD_RECURSIVELY(topFrame, 'questGbox');
	local completeGbox = GET_CHILD_RECURSIVELY(topFrame, 'completeGbox');
	local questbox_tab = GET_CHILD_RECURSIVELY(topFrame, 'questBox', "ui::CTabControl");
	local index = questbox_tab:GetSelectItemIndex();

	topFrame:SetUserValue("CurTabIndex", index);

	local levelOption = GET_QUEST_LEVEL_OPTION(index);
	if levelOption ~= nil then
		SET_QUEST_LEVEL_OPTION(levelOption);
	end

	if index == tabInfo.progressTab then
		QUEST_UPDATE_ALL(topFrame);
		completeGbox:ShowWindow(0);
		questGbox:ShowWindow(1);
	elseif index == tabInfo.completeTab then
	    QUEST_UPDATE_ALL(topFrame)
		completeGbox:ShowWindow(1);
		questGbox:ShowWindow(0);
	end
	
	_SAVE_QUEST_TAB_INFO()
	_SAVE_QUEST_LEVEL_OPTION()
end

function QUEST_MODE_FILTER_CHANGE(frame, ctrl, doNotDraw)
	frame = ui.GetFrame('quest')
	
	local alignoption = tolua.cast(ctrl, "ui::CDropList");
	if alignoption ~= nil then
		questViewOptions.mode = alignoption:GetSelItemIndex();
		
		local resetChaseQuest = GET_CHILD_RECURSIVELY(frame, "resetChaseQuest");
		if questViewOptions.mode == modeFilter.Chase then
			resetChaseQuest:ShowWindow(1)
		else
			resetChaseQuest:ShowWindow(0)
		end

	end

	if doNotDraw == nil then
		DRAW_QUEST_LIST(frame);
	end
end

function QUEST_CLICK_INFO(frame, slot, argStr, argNum)        
	if argNum == 0 then
		return;
	else
		local xPos = frame:GetWidth() -50;
		session.SetUserConfig("CUR_QUEST", argNum);

		local _isCompleteQuest = false;
		local tabIndex = frame:GetUserIValue('CurTabIndex')
		if tabIndex == tabInfo.progressTab then
			_isCompleteQuest = false;
		else
			_isCompleteQuest = true;
		end

		QUESTDETAIL_INFO(argNum, xPos, {
			isCompleteQuest = _isCompleteQuest,
		});
		return;
	end
end
 
function CHECK_SEARCH_TEXT()
	local frame = ui.GetFrame('quest')
	if frame == nil then
	 return false
	end

	local editName = "questSearch"
	local tabIndex = frame:GetUserIValue('CurTabIndex')
	if tabIndex == tabInfo.completeTab then
		editName = "questSearch2"
	end

	
	local searchEdit = GET_CHILD_RECURSIVELY(frame, editName, "ui::CEditBox");
	if searchEdit == nil then
		return false;
	end

	local searchText = searchEdit:GetText();
	if searchText == nil or string.len(searchText) == 0 then
		return false;
	end

	return true;
end

function SEARCH_QUEST_ENTER(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	if frame == nil then
	 return 
	end

	if CHECK_SEARCH_TEXT() == false then
		return
	end

	DRAW_QUEST_LIST(frame);
end

function SEARCH_QUEST_NAME(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	if frame == nil then
	 return 
	end

	if CHECK_SEARCH_TEXT() == false then
		return
	end

	DRAW_QUEST_LIST(frame);
end

function CHECK_QUEST_VIEW_HIDE_JOB(questIES)
	if questIES.Check_Job == 0 then
		return false;
	end
	
	local job = GETMYPCJOB();
	if job == nil then
		return false
	end

	local checkJobList = 
	{ 
		questIES.Job1,
		questIES.Job2,
		questIES.Job3,
		questIES.Job4
	}

	for notUse, checkJob in pairs(checkJobList) do
		local jobCls = GetClass('Job', checkJob);
		if checkJob ~= 'None' and IS_EXIST_JOB_IN_HISTORY(jobCls.ClassID) == false then
			return true;
		end
	end

	return false;
end

function IS_JOB_LVUP(pc, jobHistory, questIES)
	-- jobLvUp check
	local jobinfo = SCR_STRING_CUT(questIES.JobLvup)
	local job_name = jobinfo[1]

	
	if job_name == 'None' then	
		return true;
	end

	if string.find(jobHistory, job_name) ~= nil then
		local res =  SCR_QUEST_CHECK_MODULE_JOBLVUP(pc, questIES);
		if res == 'YES' then
			return true;	
		end			
	end


	return false
end

function IS_JOB_LVDOWN(pc, jobHistory, questIES)
	-- jobLvDown check
	local jobinfo = SCR_STRING_CUT(questIES.JobLvdown)
	local job_name = jobinfo[1]

	if job_name == 'None' then
		return true;
	end

	if string.find(jobHistory, job_name) ~= nil then
		local res =  SCR_QUEST_CHECK_MODULE_JOBLVDOWN(pc, questIES);
		if res == 'YES' then
			return true;
		end 
	end

	return false
end

function IS_ABOUT_JOB(questIES)
	 local pc = GetMyPCObject();
	 local jobHistory = GetMyJobHistoryString();
	if pc == nil or jobHistory == nil then

	 	return false;
	 end
	
	 if (IS_JOB_LVUP(pc, jobHistory, questIES) == true and IS_JOB_LVDOWN(pc, jobHistory, questIES) == true) or  tonumber(questIES.JobStep) ~= 0 then	
		return false;
	 end

	 return true;
end

function CHECK_QUEST_VIEW_HIDE(questIES, State, AbandonCheck)
	if State == "IMPOSSIBLE" then 
		return true
	elseif State == 'POSSIBLE' then 
		local pc = GetMyPCObject();
		local result, subQuestZoneList;
		result1, subQuestZoneList = HIDE_IN_QUEST_LIST(pc, questIES, State, AbandonCheck, subQuestZoneList)	
		if result1 == 1 then
			return true
		end
	elseif State == "COMPLETE" then 
		-- 완료 상태의 퀘스트는 HIDE_IN_QUEST_LIST 함수로 검사하지 않고  JOB검사 한번 더함.
	 	return CHECK_QUEST_VIEW_HIDE_JOB(questIES);
	end

	return false
end

function QUEST_ABANDON_RESTARTLIST_CHECK(questIES, sObj_main)
    local result
	if sObj_main == nil then
		return nil;
	end
    local questAutoIES = GetClass('QuestProgressCheck_Auto',questIES.ClassName)
    if (sObj_main[questIES.ClassName] == QUEST_ABANDON_VALUE or sObj_main[questIES.ClassName] == QUEST_FAIL_VALUE or sObj_main[questIES.ClassName] == QUEST_SYSTEMCANCEL_VALUE) and questIES.QuestMode ~= 'KEYITEM'  then
        local trackInfo = SCR_STRING_CUT(questAutoIES.Track1)
        if trackInfo[1] == 'SPossible' or (trackInfo[1] == 'SProgress' and questAutoIES.Possible_NextNPC == 'PROGRESS') or (trackInfo[1] == 'SSuccess' and questAutoIES.Possible_NextNPC == 'SUCCESS') then
            result = 'ABANDON/NOTLIST'
        elseif questIES.ClassName == 'DROPITEM_COLLECTINGQUEST' or questIES.ClassName == 'DROPITEM_REQUEST1' then
            result = 'NOTABANDON'
        else
            result = 'ABANDON/LIST'
        end
    else
        result = 'NOTABANDON'
    end

    return result
end

function HIDE_IN_QUEST_LIST(pc, questIES, State, abandonResult, subQuestZoneList)
	local startMode = questIES.QuestStartMode;
	local sObj = session.GetSessionObjectByName("ssn_klapeda");
	if sObj ~= nil then
    	sObj = GetIES(sObj:GetIESObject());
    end
	local result1
	result1, subQuestZoneList = SCR_POSSIBLE_UI_OPEN_CHECK(pc, questIES, subQuestZoneList)

	if abandonResult == 'ABANDON/LIST' or questIES.PossibleUI_Notify == 'UNCOND' then
		return 0, subQuestZoneList;
	elseif result1 == "HIDE" then
		if State ~= nil and State ~= 'POSSIBLE' then
			return 1, subQuestZoneList
		end
	elseif startMode == 'NPCENTER_HIDE' then
	    return 1, subQuestZoneList
	elseif startMode == "GETITEM" then		
	    return 1, subQuestZoneList
	elseif startMode == "USEITEM" then
		return 1, subQuestZoneList
	elseif IS_WORLDMAPPREOPEN(questIES.StartMap) == 'NO' then
		return 1, subQuestZoneList
	elseif sObj ~= nil and questIES.QuestMode == 'MAIN' and pc.Lv < 100 and questIES.QStartZone ~= 'None' and sObj.QSTARTZONETYPE ~= 'None' and questIES.QStartZone ~=  sObj.QSTARTZONETYPE and LINKZONECHECK(GetZoneName(pc), questIES.StartMap) == 'NO'  then
		return 1, subQuestZoneList
	elseif (questIES.QuestMode == 'MAIN' or questIES.QuestMode == 'REPEAT' or questIES.QuestMode == 'SUB') and LINKZONECHECK(GetZoneName(pc), questIES.StartMap) == 'NO' and QUEST_VIEWCHECK_LEVEL(pc, questIES) == 'NO' and SCR_ISFIRSTJOBCHANGEQUEST(questIES) == 'NO'  then
		return 1, subQuestZoneList
	end

	return 0, subQuestZoneList;
end

function IS_WORLDMAPPREOPEN(zoneClassName)
    local mapCls = GetClass('Map', zoneClassName)
    if mapCls ~= nil and GetPropType(mapCls, 'WorldMapPreOpen') ~= nil and mapCls.WorldMapPreOpen == 'YES' then
        return 'YES'
    end
    return 'NO'
end

function QUEST_VIEWCHECK_LEVEL(pc, questIES)
	--    if pc.Lv < 10 then
	--       if questIES.Level <= pc.Lv + 10 then
	--            return 'YES'
	--        end
	--    else
	--        if questIES.Level <= pc.Lv + 10 and questIES.Level >= pc.Lv - 10 then
	--            return 'YES'
	--        end
	--    end
	--    
	--    return 'NO'

	return 'YES'
end

function QUEST_SUB_VIEWCHECK_LEVEL(pc, questIES)
	   if pc.Lv < 30 then
	      if questIES.Level <= pc.Lv + 30 then
	           return 'YES'
	       end
	   else
	       if questIES.Level <= pc.Lv + 30 and questIES.Level >= pc.Lv - 30 then
	           return 'YES'
	       end
	   end
	   
	   return 'NO'
end

function LINKZONECHECK(fromZone, toZone)
    local result = 'NO'

    if fromZone == toZone then
        result = 'YES'
        return result
    end

    if fromZone == nil or toZone == nil or fromZone == 'None' or toZone == 'None' then
        return result
    else
        local zoneIES1 = GetClass('Map', fromZone)
        local zoneIES2 = GetClass('Map', toZone)
        if zoneIES1 == nil or zoneIES2 == nil then
            return result
        end

        local linkList = SCR_STRING_CUT(zoneIES1.QuestLinkZone)
        if #linkList > 0 then
            for i = 1, #linkList do
                if linkList[i] == toZone then
                    result = 'YES'
                    return result
                end
            end
        end
	end
	
    return result
end	
	
function QUEST_TIMER_DRAW_LIST()
	local topFrame = ui.GetFrame("quest");
	if topFrame ~= nil then
		DRAW_QUEST_LIST(topFrame)
		
		local timer = topFrame:GetChild("addontimer");
		tolua.cast(timer, "ui::CAddOnTimer");
		timer:Stop(); 
	end
end

function QUEST_RESERVE_DRAW_LIST(frame)
	if frame == nil then
		frame = ui.GetFrame("quest");
	end

	local timer = frame:GetChild("addontimer");
	tolua.cast(timer, "ui::CAddOnTimer");
	timer:Stop(); 
	timer:SetUpdateScript("QUEST_TIMER_DRAW_LIST");
	timer:Start(0.5, 0); 
end

function IS_SHARED_QUEST(classID)
	local myInfo = session.party.GetMyPartyObj(PARTY_NORMAL);
	if myInfo == nil then
		return false;
	end

	local obj = GetIES(myInfo:GetObject());
	local savedID = obj.Shared_Quest;
	
	if tonumber(classID) == tonumber(savedID) then
		return true;
	end
	
	return false;
end

function RUN_EDIT_QUEST_REWARD(frame, ctrl, str, questID)
    RUN_QUEST_EDIT_TOOL(questID)
end

function RUN_QUEST_EDIT_TOOL(questID)
	if 1 == session.IsGM() then
        local questIES = GetClassByType('QuestProgressCheck',questID)
	    local yesScp = string.format("SCR_GM_QUEST_UI_QUEST_CHEAT_YES(%d)",questID);
	    local noScp = string.format("SCR_GM_QUEST_UI_QUEST_CHEAT_NO(%d)",questID);
    	ui.MsgBox(ScpArgMsg('QUEST_CHEAT_MSG1','QUESTNAME', questIES.Name) , yesScp, noScp);
	end

end

function SCR_GM_QUEST_UI_QUEST_CHEAT_YES(questID)
    control.CustomCommand("SCR_GM_QUEST_UI_QUEST_CHEAT", questID);
end

function SCR_GM_QUEST_UI_QUEST_CHEAT_NO(questID)
    local quest_ClassName = GetClassString('QuestProgressCheck', questID, 'ClassName')
    local questdocument = io.open('..\\release\\questauto\\InGameEdit_Quest.txt','w')
    questdocument:write(quest_ClassName)
    io.close(questdocument)

    local path = debug.GetR1Path();
    path = path .. "questauto\\QuestAutoTool_v1.exe";

	debug.ShellExecute(path);
end

function SCR_QUEST_DIALOG_REPLAY(ctrlSet, ctrl, strArg, numArg)
    local questClassID = numArg;
    control.CustomCommand("QUEST_DIALOG_REPLAY_SERVER", questClassID);
end

function SCR_QUEST_ABANDON_SELECT(ctrlSet, ctrl, strArg, numArg)
    local questClassID = numArg;
    local questIES = GetClassByType('QuestProgressCheck', questClassID)
    ui.MsgBox(ScpArgMsg("QUEST_ABANDON_SELECT_MSG","QUEST",questIES.Name), string.format("EXEC_ABANDON_QUEST(%d)", tonumber(questClassID)), "None");
end

function SCR_ABANDON_QUEST_TRY(ctrlSet, ctrl, strArg, numArg)
	local questClassID = numArg;
	pc.ReqExecuteTx("RESTART_Q", questClassID);
end

function CHECK_QUEST_LOCATION(questIES)
	if GET_QUEST_LOCATION(questIES) == "None" then
		return false;
	end
	
	return true;
end

function GET_QUEST_LOCATION(questIES)
	local pc = GetMyPCObject();
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);
	local state = CONVERT_STATE(result);
	local map = questIES[state .. 'Map'];
	local location = questIES[state .. 'Location'];

	if location ~= '' and location ~= "None" then
		local strList = SCR_STRING_CUT_SPACEBAR(location)
		return strList[1];
	end

	if map ~= '' and map ~= "None" then
		return map
	end

	return "None";
end

function SCR_VIEW_QUEST_LOCATION(ctrlSet, ctrl, strArg, numArg)
	local questClassID = numArg; 
	local questIES = GetClassByType('QuestProgressCheck',questClassID)
	local mapName = GET_QUEST_LOCATION(questIES)

	OPEN_FLOATINGLOCATIONMAP_INFO(mapName);	
end

function EXEC_ABANDON_QUEST(questID)    
	local frame = ui.GetFrame('quest');
	pc.ReqExecuteTx("ABANDON_Q", questID);

	local questinfoset2Frame = ui.GetFrame('questinfoset_2');
	UPDATE_QUESTINFOSET_2(questinfoset2Frame, 'ABANDON_QUEST', 0, questID);

	quest.RemoveAllQuestMonsterList(questID);
	quest.RemoveCheckQuest(questID);

	DRAW_QUEST_LIST(frame);
end

function SCR_QUEST_SHARE_PARTY_MEMBER(ctrlSet, ctrl, strArg, numArg)
	local frame = ui.GetFrame('quest');

	local questClassID = numArg; 
	local shared = IS_SHARED_QUEST(questClassID);
	if shared == true then
		-- 기 등록한 공유 퀘스트 이므로 캔슬 시킨다.
		CANCEL_QUEST_SHARE_PARTY_MEMBER()
	elseif shared == false then
		party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Quest", questClassID);
		REQUEST_QUEST_SHARE_PARTY_PROGRESS(questClassID)
	end

	DRAW_QUEST_LIST(frame);
end

function REQUEST_QUEST_SHARE_PARTY_PROGRESS(questClsID)
	party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Progress", -1)

	local myInfo = session.party.GetMyPartyObj(PARTY_NORMAL);
	if nil == myInfo then
		return;
	end

	local myObj = GET_MY_PARTY_INFO_C()
	local sharedQuestID = TryGetProp(myObj, 'Shared_Quest')
	if nil == sharedQuestID or sharedQuestID == 0 then
		return;
	end

	local questIES = GetClassByType("QuestProgressCheck", questClsID)
	if questIES == nil then
		return;
	end

	local progStr = SCR_QUEST_CHECK_C(GetMyPCObject(), questIES.ClassName)
	local progValue = quest.GetQuestStateValue(progStr)
	party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Progress", progValue)
	party.SendSharedQuestSession(questIES.ClassID, questIES.ClassName, myInfo:GetAID());
end

function CANCEL_QUEST_SHARE_PARTY_MEMBER()
	party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Quest", 0);
	party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Quest", -1);
end

function ON_PARTY_UPDATE_SHARED_QUEST()
	local myInfo = session.party.GetMyPartyObj(PARTY_NORMAL);
	local myPartyMemObj = GET_MY_PARTY_INFO_C()
	local sharedQuestID = TryGetProp(myPartyMemObj, 'Shared_Quest')
	if myInfo ~= nil and sharedQuestID ~= nil and sharedQuestID > 0 then
		local questCls = GetClassByType('QuestProgressCheck', sharedQuestID)
		if questCls ~= nil then
			REQUEST_QUEST_SHARE_PARTY_PROGRESS(sharedQuestID)
		end
	end
end
