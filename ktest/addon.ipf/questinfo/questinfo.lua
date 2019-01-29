function QUESTINFO_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'UPDATE_QUESTMARK');
	addon:RegisterMsg('QUEST_UPDATE', 'UPDATE_QUESTMARK');
	addon:RegisterMsg('S_OBJ_UPDATE', 'UPDATE_QUESTMARK');
	addon:RegisterMsg('GET_NEW_QUEST', 'UPDATE_QUESTMARK');
		
	addon:RegisterMsg('INV_ITEM_ADD', 'UPDATE_QUESTMARK');
	addon:RegisterMsg('NPC_ENTER', 'UPDATE_QUESTMARK');
end 

function UPDATE_QUESTMARK(frame, msg, argStr, argNum)
	DebounceScript("DEBOUNCE_QUESTUPDATE_MARK", 1.0);
end

function DEBOUNCE_QUESTUPDATE_MARK()
	-- AddQuestMark 로직 UpdateQuestMark 함수 내부로 옮김
    quest.UpdateQuestMark();
end

function CHECK_QUEST_NPC_STATE(questIES)

	-- ����Ʈ �����ҽÿ� �ڵ����� NPC�����ִ°� �����Ѵ�.
	if questIES.QuestMode ~= "MAIN" then
		return;
	end

	local isVisible = session.IsVisibleNPC(questIES.StartMap, questIES.StartNPC);
	if isVisible == 0 then
		packet.ReqCheckQuestNPCState(questIES.ClassID);
	end
	
end