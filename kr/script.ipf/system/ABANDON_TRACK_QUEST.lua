function ABANDON_TRACK_QUEST(self, questname, abandon_or_fail, quest_state)

	if 0 == IS_ABLE_ABANDON_QUEST(self, questname) then
		return;
	end

    if quest_state ~= nil then
        local quest_state_list = SCR_STRING_CUT(quest_state)
        local i
        local flag = 0
        if #quest_state_list > 0 then
            local now_state = SCR_QUEST_CHECK(self,questname)
            for i = 1, #quest_state_list do
                if now_state == quest_state_list[i] then
                    flag = flag + 1
                    break
                end
            end
        end
        
        if flag == 0 then
            return
        end
    end
    
    
    local questIES = GetClass('QuestProgressCheck', questname);
    local questIES_auto = GetClass('QuestProgressCheck_Auto', questname);
    local sObj = GetSessionObject(self, 'ssn_klapeda');

    
    if sObj[questIES.QuestPropertyName] >= 10 and questIES_auto.Track1 ~= 'None' then
        RunZombieScript('ABANDON_TRACK_QUEST_SUB',self, questname, abandon_or_fail)
    elseif sObj[questIES.QuestPropertyName] < 10 and questIES_auto.Track1 ~= 'None' and string.find(questIES_auto.Track1,'SPossible/') ~= nil then
        RunZombieScript('ABANDON_TRACK_QUEST_SUB',self, questname, abandon_or_fail)
--        print('AAA questIES_auto.Track1',questIES_auto.Track1,'sObj[questIES.QuestPropertyName]',sObj[questIES.QuestPropertyName])
    end
end

function ABANDON_TRACK_QUEST_SUB(self, questname, abandon_or_fail)
	if 0 == IS_ABLE_ABANDON_QUEST(self, questname) then
		return;
	end

    ABANDON_Q_BY_NAME(self, questname, abandon_or_fail)
    local questIES_auto = GetClass('QuestProgressCheck_Auto', questname);
	if string.find(questIES_auto.Track1,'SPossible/') == nil and (string.find(questIES_auto.Track1,'SProgress/') == nil or questIES_auto.Possible_NextNPC ~= 'PROGRESS') then
	    local sObj = GetSessionObject(self, 'ssn_klapeda');
	    local questIES = GetClass('QuestProgressCheck', questname);
	    local req_ReenterTime = SCR_QUEST_PRE_CHECK_REENTERTIME(questIES, sObj)
	    
	    local attQuestMode = TryGetProp(questIES, 'QuestMode', 'MAIN')
	    local attRepeat_Count = TryGetProp(questIES, 'Repeat_Count', 0)
	    local attQuestPropertyName = TryGetProp(questIES, 'QuestPropertyName', 'None')
	    local nowRepeat_Count
	    if attQuestPropertyName ~= nil then
	        nowRepeat_Count = TryGetProp(sObj, attQuestPropertyName..'_R')
	    end
	    
	    if attQuestMode == 'REPEAT' and attRepeat_Count > 0 and nowRepeat_Count >= attRepeat_Count then
	    else
    	    if req_ReenterTime == 'YES' then
                SCR_QUEST_POSSIBLE_AGREE(self, questname, nil, 'YES')
            end
        end
--    	SCR_QUEST_POSSIBLE_AGREE_PROP_CHANGE(self, questname)
    end
end
