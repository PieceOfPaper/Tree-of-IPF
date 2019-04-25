-- quest_chase.lua

local chaseQuestList = nil;
local function _GET_CHASE_QUEST_LIST()

	if chaseQuestList == nil then
		chaseQuestList = {}
	end

	return chaseQuestList;
end


local function _GET_CHASE_TITLE_INFO(titleName)
	local list = _GET_CHASE_QUEST_LIST()
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

function GET_CHASE_TITLE_INFO()
	return _GET_CHASE_TITLE_INFO("quest_command_window")
end


local function _SET_CHASE_QUEST_INFO(titleName, questClassID, state, abandonCheck)
	local titleInfo = _GET_CHASE_TITLE_INFO(titleName)
	if titleInfo == nil then
		--titleInfo가 없으면 생성	
		local list = _GET_CHASE_QUEST_LIST()
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


function SET_CHASE_QUEST_INFO(questIES, questInfo)
	local titleName = "quest_command_window"
	_SET_CHASE_QUEST_INFO(titleName, questInfo.QuestClassID, questInfo.State, questInfo.AbandonCheck)
end

function _UPDATE_CHASE_QUEST_INFO(questIES)
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

			SET_CHASE_QUEST_INFO(questIES, questInfo)
		end
	end
end

function UPDATE_CHASE_QUEST_LIST()	
	-- 퀘스트 리스트를 삭제.
	local list = _GET_CHASE_QUEST_LIST();
	for notUse, titleInfo in pairs(list) do
		titleInfo.questInfoList = {}
	end

	-- 지령창 퀘스트 다시 채우기
	local max = quest.GetCheckQuestCount();
	for i=0, max-1 do
		local questID =	quest.GetCheckQuest(i);
		local questIES = GetClassByType("QuestProgressCheck", questID);
		if questIES ~= nil then
		_UPDATE_CHASE_QUEST_INFO(questIES)
		end
	end
end

-- 추적 퀘스트 그리기.
function DRAW_CHASE_QUEST_LIST(frame, y)	
	if frame == nil then
		frame = ui.GetFrame('quest')
	end

	UPDATE_CHASE_QUEST_LIST()

	local bgCtrl = GET_CHILD_RECURSIVELY(frame, 'questGbox');
	local questList = _GET_CHASE_QUEST_LIST()
	local height = 0;
	for notUse, questInfo in pairs(questList) do
		height = height + DRAW_CHASE_QUEST_CTRL(bgCtrl, questInfo, y + height)
	end

	return height;
end


function DRAW_CHASE_QUEST_CTRL(bgCtrl, titleInfo, y)
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
	local mapName = ClMsg("quest_command_window")
	if mapCls ~= nil then
		mapName = mapCls.Name
	end
	local questMapNameText = GET_CHILD_RECURSIVELY(titleCtrlSet, "questMapNameText")
	questMapNameText:SetTextByKey("mapName",  mapName)
	questMapNameText:SetTextByKey("count", questInfoCount) 
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
