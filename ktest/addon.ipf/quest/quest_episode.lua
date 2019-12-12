-- quest_episode.lua

local episodeStateInfo = {
	Locked = 0,
	Clear = 1,			-- 완료
	Reward  = 2,		-- 보상 받기 가능
	Progress = 3,     -- 진행중
};

local episodeQuestList = nil;
local function _GET_EPISODE_QUEST_LIST()

	if episodeQuestList == nil then
		episodeQuestList = {}
	end

	return episodeQuestList;
end

local function _GET_EPISODE_TITLE_INFO(titleName)
	local list = _GET_EPISODE_QUEST_LIST()
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

function GET_EPISODE_TITLE_INFO(titleName)
	return _GET_EPISODE_TITLE_INFO(titleName)
end

local function _SET_EPISODE_QUEST_INFO(titleName, episodeNumberStr, episodeName, questClassID, state)

	local titleInfo = _GET_EPISODE_TITLE_INFO(titleName)
	if titleInfo == nil then
		--titleInfo가 없으면 생성	
		local list = _GET_EPISODE_QUEST_LIST()
		local makeTitleInfo = {
				name = titleName,
				episodeNumberString = episodeNumberStr,
				episodeName = episodeName,			
				isOpened = false,
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
			return 
		end
	end

	-- 없으면 끝에 추가.
	local questIndex = #titleInfo.questInfoList;
	titleInfo.questInfoList[questIndex + 1] = { State = state,
												QuestClassID = questClassID 
											  }
end

function SET_EPISODE_QUEST_INFO(episodeCls, questIES, questInfo)

	local episodeRewardCls = GetClass("Episode_Reward", episodeCls.EpisodeName)
	if episodeRewardCls == nil then
		return
	end

	_SET_EPISODE_QUEST_INFO(episodeCls.EpisodeName, episodeRewardCls.ClassNumberString, episodeRewardCls.EpisodeName , questInfo.QuestClassID, questInfo.State)
end

function _UPDATE_EPISODE_QUEST_INFO(episodeCls)
	if episodeCls == nil then
		return;
	end

	local questID = TryGetProp(episodeCls, "QuestID");
	if questID == nil then
		return;
	end

	local questIES = GetClassByType("QuestProgressCheck",questID)
	if questIES == nil then
		return;
	end

	local pc = GetMyPCObject();
	local questClassName = questIES.ClassName
	if questClassName ~= "None" then
			local questState = SCR_QUEST_CHECK_C(pc, questClassName); 					 -- 퀘스트 상태
			local questInfo = {
				State = questState,
				QuestClassID = questIES.ClassID,
			};
			SET_EPISODE_QUEST_INFO(episodeCls, questIES, questInfo)
	end
end

function UPDATE_EPISODE_QUEST_LIST()	
	frame = ui.GetFrame("quest")

	-- 퀘스트 리스트를 삭제.
	local list = _GET_EPISODE_QUEST_LIST();
	for notUse, titleInfo in pairs(list) do
		titleInfo.questInfoList = {}
	end

	-- 에피소드 정보 업데이트
	local clsList, cnt = GetClassList("Episode_Quest");
	for i = 0, cnt -1 do
		local episodeCls = GetClassByIndexFromList(clsList, i);
		_UPDATE_EPISODE_QUEST_INFO(episodeCls)
	end

	-- draw
	DRAW_EPISODE_QUEST_LIST(frame)
end


function DRAW_EPISODE_QUEST_LIST(frame)	
	if frame == nil then
		frame = ui.GetFrame('quest')
	end

	-- 퀘스트 창이 닫혀 있다면 갱신하지 않고 리턴
	if frame:IsVisible() == 0 then
		return 
	end

	local bgCtrl = GET_CHILD_RECURSIVELY(frame, 'episodeGbox');
	if bgCtrl == nil then
		return
	end
	
	bgCtrl:RemoveAllChild()
	local questList = _GET_EPISODE_QUEST_LIST()
	local y = 0
	for notUse, titleInfo in pairs(questList) do
		y = y + DRAW_EPISODE_QUEST_CTRL(bgCtrl, titleInfo, y)
	end

	bgCtrl:Invalidate()
	frame:Invalidate();
end

function CHECK_EPISODE_STATE(episodeRewardClassname)
	local pc = GetMyPCObject();
	local result = SCR_EPISODE_CHECK(pc, episodeRewardClassname)
	if result == "Locked" then
		return episodeStateInfo.Locked;
	elseif result == "Clear" then
		return episodeStateInfo.Clear;
	elseif result == "Reward" then
		return episodeStateInfo.Reward;
	end

	return episodeStateInfo.Progress;
end


-- titleinfo 정보를 가지고 컨트롤을 생성함.
function DRAW_EPISODE_QUEST_CTRL(bgCtrl, titleInfo, y)

	if bgCtrl == nil then
		return 0;
	end

	local titleCtrlSet = bgCtrl:CreateOrGetControlSet('episode_list_title', titleInfo.name, 0, y );
	if titleCtrlSet == nil then
		return 0;
	end
	titleCtrlSet = tolua.cast(titleCtrlSet, "ui::CControlSet");

	-- 보상 상태
	-- 1. 락
	-- 2. 클리어 - 모두 완료했고 보상을 가져갔음
	-- 3. 보상 받기 가능
	-- 4. 진행중
	local episodeState = CHECK_EPISODE_STATE(titleInfo.name)
	local colorTone = "FFFFFFFF";
	local backGroundSkinName = titleCtrlSet:GetUserConfig("NORMAL_SKIN");
	if episodeState == episodeStateInfo.Locked then
		colorTone = titleCtrlSet:GetUserConfig("LOCK_COLORTONE");
		backGroundSkinName = titleCtrlSet:GetUserConfig("LOCK_SKIN");
	elseif episodeState == episodeStateInfo.Clear then
		colorTone = titleCtrlSet:GetUserConfig("CLEAR_COLORTONE");
	end

	local textToolTip = nil;
	if episodeState == episodeStateInfo.Locked then
		textToolTip = ScpArgMsg("EpisodeLockMsg")
	elseif episodeState == episodeStateInfo.Clear then
		textToolTip = ScpArgMsg("EpisodeClearMsg")
	end 

	-- title 정보 설정
	local episodeGbox = GET_CHILD_RECURSIVELY(titleCtrlSet, "episodeGbox")
	local episodeNameText = GET_CHILD_RECURSIVELY(titleCtrlSet, "episodeNameText")
	local questNameText = GET_CHILD_RECURSIVELY(titleCtrlSet, "questNameText")
	episodeGbox:SetSkinName(backGroundSkinName);
	episodeGbox:SetColorTone(colorTone);
	episodeNameText:SetTextByKey("name", titleInfo.episodeNumberString);
	episodeNameText:SetColorTone(colorTone);
	questNameText:SetTextByKey("name", titleInfo.episodeName);
	questNameText:SetColorTone(colorTone);

	if textToolTip ~= nil then
		episodeGbox:SetTextTooltip(textToolTip)
		episodeGbox:EnableHitTest(1);
	end


	-- 상태 이미지 처리
	local clearMark = GET_CHILD_RECURSIVELY(titleCtrlSet, "clearMark")	
	local lockMark = GET_CHILD_RECURSIVELY(titleCtrlSet, "lockMark")	
	clearMark:ShowWindow(0);
	lockMark:ShowWindow(0);
	if episodeState == episodeStateInfo.Locked then
		lockMark:ShowWindow(1);
		if textToolTip ~= nil then
			lockMark:SetTextTooltip(textToolTip)
		end
	elseif episodeState == episodeStateInfo.Clear then
		clearMark:ShowWindow(1);
		clearMark:SetEventScriptArgString(ui.LBUTTONUP, titleInfo.name); -- episode name
		clearMark:SetEventScript(ui.LBUTTONUP, 'CLICK_EPISODE_REWARD');
		clearMark:EnableHitTest(1);
		if textToolTip ~= nil then
			clearMark:SetTextTooltip(textToolTip)
		end
	end

	-- 보상상자
	local rewardBtn = GET_CHILD_RECURSIVELY(titleCtrlSet, "rewardBtn")	
	local rewardStepBox = GET_CHILD_RECURSIVELY(titleCtrlSet, "rewardStepBox")	
	local rewardDigitNotice = GET_CHILD_RECURSIVELY(titleCtrlSet, "rewardDigitNotice")	
	rewardStepBox:ShowWindow(0);
	rewardDigitNotice:ShowWindow(0);
	rewardBtn:ShowWindow(1);
	rewardBtn:SetEventScriptArgString(ui.LBUTTONUP, titleInfo.name); -- episode name
	if episodeState == episodeStateInfo.Reward then
		rewardStepBox:ShowWindow(1);
		rewardDigitNotice:ShowWindow(1);
		rewardBtn:SetColorTone(colorTone);
	elseif episodeState == episodeStateInfo.Clear then
		rewardBtn:SetImage(titleCtrlSet:GetUserConfig("CLEAR_REWARD_BOX"));
		rewardBtn:SetColorTone(colorTone);
		rewardBtn:ShowWindow(0);
	elseif episodeState == episodeStateInfo.Locked then
		rewardBtn:SetImage(titleCtrlSet:GetUserConfig("LOCK_REWARD_BOX"));
	else
		rewardBtn:SetColorTone(colorTone);
	end


	-- 이 아래는 locked, Clear일 때는 그릴 필요가 없음.
	local questMapTitleGbox = GET_CHILD_RECURSIVELY(titleCtrlSet, "questMapTitleGbox")
	local questListGbox = GET_CHILD_RECURSIVELY(titleCtrlSet, "questListGbox")
	local questCtrlTitleHeight = 0;
	local questCtrlTotalHeight =0;

	if episodeState ~= episodeStateInfo.Locked then
		-- 퀘스트 목록 제목
		local openMark = GET_CHILD_RECURSIVELY(titleCtrlSet, "openMark")	
		openMark:SetImage(titleCtrlSet:GetUserConfig("OPENED_CTRL_IMAGE"))
		-- 오픈 마크 처리.
		if titleInfo.isOpened == true then
			openMark:SetImage(titleCtrlSet:GetUserConfig("CLOSED_CTRL_IMAGE"))
		end

		questCtrlTitleHeight = titleCtrlSet:GetUserConfig("QUEST_CTRL_TITLE_HEIGHT");
		
		-- 퀘스트 목록
		local drawTargetCount = 0
		local controlSetType = "episode_list_oneline"
		local controlsetHeight = ui.GetControlSetAttribute(controlSetType, 'height');

		if questListGbox ~= nil then
			-- 퀘스트 목록 순회.
			local questInfoCount = #titleInfo.questInfoList;
			local cnt = 1
			for index = 1, questInfoCount do
				local questInfo = titleInfo.questInfoList[index]
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
					UPDATE_EPISODE_QUEST_CTRL(Quest_Ctrl, questInfo );

					questCtrlTotalHeight = questCtrlTotalHeight + Quest_Ctrl:GetHeight();
				end

				drawTargetCount = drawTargetCount +1
			end	
		end
	end

	titleCtrlSet:Resize(titleCtrlSet:GetWidth(),titleCtrlSet:GetHeight() + questCtrlTitleHeight + questCtrlTotalHeight )
	questMapTitleGbox:Resize(questMapTitleGbox:GetWidth(), questCtrlTitleHeight)
	questListGbox:Resize(questListGbox:GetWidth(), questCtrlTotalHeight)
	titleCtrlSet:Invalidate();
	return titleCtrlSet:GetHeight()
end

function UPDATE_EPISODE_QUEST_CTRL(ctrl, questInfo)

	local Quest_Ctrl = 	tolua.cast(ctrl, "ui::CControlSet"); 

	local state = questInfo.State;
	local questID = questInfo.QuestClassID;
	local questIES = GetClassByType('QuestProgressCheck',questID)
	
	-- 퀘스트 마크 설정
	SET_EPISODE_QUEST_CTRL_MARK(Quest_Ctrl, questIES, state);

	-- 레벨, 이름 설정.
	SET_EPISODE_QUEST_CTRL_TEXT(Quest_Ctrl, questIES, state)

	-- 버튼 설정
	SET_EPISODE_QUEST_CTRL_BTN(Quest_Ctrl, questIES, state)

	-- 컨트롤 설정
	Quest_Ctrl:SetUserValue("QUEST_CLASSID", questIES.ClassID);
	Quest_Ctrl:SetUserValue("QUEST_LEVEL", questIES.Level)

	Quest_Ctrl:ShowWindow(1);
	Quest_Ctrl:EnableHitTest(1);
	
end


function SET_EPISODE_QUEST_CTRL_MARK(ctrl, questIES, state)
	local Quest_Ctrl = 	tolua.cast(ctrl, "ui::CControlSet"); 
	local questIconImgName = "minimap_1_MAIN";
	local questMarkPic = GET_CHILD(Quest_Ctrl, "questmark", "ui::CPicture");
	if state == "COMPLETE" then
		questIconImgName = "minimap_clear"
	end
	
	questMarkPic:ShowWindow(1);
	questMarkPic:SetImage(questIconImgName);
end


function SET_EPISODE_QUEST_CTRL_TEXT(ctrl, questIES, state)
	local Quest_Ctrl = 	tolua.cast(ctrl, "ui::CControlSet"); 
	local nametxt = GET_CHILD(Quest_Ctrl, "name", "ui::CRichText");
	local leveltxt = GET_CHILD(Quest_Ctrl, "level", "ui::CRichText");


	local textFont = Quest_Ctrl:GetUserConfig("NORMAL_FONT")
	local textColor = Quest_Ctrl:GetUserConfig("NORMAL_COLOR")
	if state == "COMPLETE" then
		textFont =  Quest_Ctrl:GetUserConfig("COMP_FONT")
		textColor =  Quest_Ctrl:GetUserConfig("COMP_COLOR")
	end

	-- 퀘스트 레벨과 이름의 폰트 및 색상 지정.
	nametxt:SetText(textFont .. textColor .. questIES.Name)	
	leveltxt:SetText(textColor .. textColor .. "Lv " .. questIES.Level)
end

function SET_EPISODE_QUEST_CTRL_BTN(ctrl, questIES, state)
	local Quest_Ctrl = 	tolua.cast(ctrl, "ui::CControlSet"); 
	local questLink = GET_CHILD(Quest_Ctrl, "questLink", "ui::CCheckBox");
	local complete = GET_CHILD(Quest_Ctrl, "complete", "ui::CButton");
	if questLink == nil or complete == nil then
		return
	end

	questLink:ShowWindow(0);
	complete:ShowWindow(0);

	if state == "POSSIBLE" or state == "PROGRESS" or state == "SUCCESS" then
		questLink:ShowWindow(1);
		questLink:SetEventScriptArgNumber(ui.LBUTTONUP, questIES.ClassID);
	elseif state == "COMPLETE" then
		complete:ShowWindow(1);
	end
end

function SCR_LINK_EPISODE_QUEST(ctrlSet, ctrl, strArg, numArg)
	local questClassID = numArg; 

	ON_SERACH_QUEST_NAME(questClassID)
	ON_QUEST_GROUP_OPEN(questClassID)
	ON_MAIN_QUEST_FILTER();
	ON_CHANGE_QUEST_TAB()
	
end

function CLICK_EPISODE_REWARD(ctrlSet, ctrl, strArg, numArg)
	if strArg == nil or strArg =="" then
		return;
	end
	
	local frame = ctrlSet:GetTopParentFrame();
	local xPos = frame:GetWidth() -50;

	QUESTEPISODEREWARD_INFO(strArg, xPos, {} );
	
end
