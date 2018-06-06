function QUESTINFO_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'UPDATE_QUESTMARK');
	addon:RegisterMsg('QUEST_UPDATE', 'UPDATE_QUESTMARK');
	addon:RegisterMsg('S_OBJ_UPDATE', 'UPDATE_QUESTMARK');
	addon:RegisterMsg('GET_NEW_QUEST', 'UPDATE_QUESTMARK');
		
	addon:RegisterMsg('INV_ITEM_ADD', 'UPDATE_QUESTMARK');
	addon:RegisterMsg('NPC_ENTER', 'UPDATE_QUESTMARK');
end 

function UPDATE_QUESTMARK(frame, msg, argStr, argNum)
	-- 아래의 로직 cpp로 옮기고, 비동기적으로 처리되도록 수정하였습니다.
	ui.UpdateQuestMark();

	--[[local pc = GetMyPCObject();d
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    local subQuestZoneList = {}
    if sObj == nil then
		return;
	end
	local cnt = GetNPCMarkCheckCount();	
	for i = 0, cnt -1 do
			local questIES = GetNPCMarkCheckQuest(i);
			
			if sObj[questIES.QuestPropertyName] <= 0 then
			    if questIES.StartNPC ~= 'None' then
    			    quest.QuestMarkAdd(questIES.StartNPC, "None", 0);
    			end
    			if questIES.ProgNPC ~= 'None' and questIES.StartNPC ~= questIES.ProgNPC then
    			    quest.QuestMarkAdd(questIES.ProgNPC, "None", 0);
    			end
    			if questIES.EndNPC ~= 'None' and questIES.StartNPC ~= questIES.EndNPC and questIES.ProgNPC ~= questIES.EndNPC then
    			    quest.QuestMarkAdd(questIES.EndNPC, "None", 0);
    			end
			end
			-- ����Ʈ ���¸� üũ�Ѵ�
    		local result    = SCR_QUEST_CHECK_C(pc, questIES.ClassName);
			
    		if result == 'POSSIBLE' then
    			CHECK_QUEST_NPC_STATE(questIES);
    		end
    		
    		local State     = CONVERT_STATE(result);
    		local questName = questIES['ClassName'];
    		local npcname   = questIES[State .. 'NPC'];
    		
			if result == 'COMPLETE' then
				local endName = questIES.EndNPC;
    			if endName ~= npcname then
    				quest.QuestMarkAdd(endName, "None", 0);
    			end
			end
			
			if State == 'End' then
    			local progname = questIES.ProgNPC;
    			if progname ~= npcname then
    				quest.QuestMarkAdd(progname, "None", 0);
    			end
    			local startname = questIES.StartNPC;
    			if startname ~= npcname then
    				quest.QuestMarkAdd(startname, "None", 0);
    			end
    		elseif State == 'Prog' then
    			local startname = questIES.StartNPC;				
    			if startname ~= npcname then					
    				quest.QuestMarkAdd(startname, "None", 0);					
    			end
    		end   		
    		-- ����Ʈ ���� �Ұ���
    		if result == 'IMPOSSIBLE' then			
    			-- ����Ʈ ���� �Ұ����ϰ�쿡��?����Ʈ ��ũ�� �������� �ʴ´�.
				
    		-- ����Ʈ ���� ���������� ���� ���̿� ���� ��ũ�� �����?
    		elseif result == 'POSSIBLE' then
    		    local flag = 0
    		    if questIES.PossibleUI_Notify == 'UNCOND' then
    		        flag = 1
    		    end
    		    if flag == 0 then
    		        local result
    		        result, subQuestZoneList = SCR_POSSIBLE_UI_OPEN_CHECK(pc, questIES, subQuestZoneList, 'NPCMark')
    		        if result == "HIDE"
    		        or questIES.QuestStartMode == 'NPCENTER_HIDE'
    		        or questIES.QuestStartMode == 'GETITEM'
    		        or questIES.QuestStartMode == 'USEITEM' then
    		        else
    		            flag = 1
    		        end
    		    end
    		    
    		    if flag == 1 then
        			-- ����Ʈ ���� �����ϸ� �ش� NPC�� !(����ǥ)�� �����Ѵ�.			
        			local tail, isMain = GET_MARK_TAIL(questIES);
        			quest.QuestMarkAdd(npcname, "I_quest_mask_possible" .. tail, 2, isMain);
        		end
    		-- ����Ʈ ������
    		elseif result == 'PROGRESS' then
    			if questIES ~= nil and questIES.StartNPC ~= questIES.ProgNPC and questIES.StartNPC ~= questIES.EndNPC and questIES.ProgNPC == questIES.EndNPC then
    				local questIES_auto = GetClass('QuestProgressCheck_Auto',questIES.ClassName)
        			if questIES_auto ~= nil and ( questIES_auto.Progress_NextNPC == 'SUCCESS' or questIES_auto.Progress_NextNPC == 'ENDNPC') then
            			local tail, isMain = GET_MARK_TAIL(questIES);
            			quest.QuestMarkAdd(npcname, "I_quest_mask_success" .. tail, 3, isMain);
            		else
            			local tail, isMain = GET_MARK_TAIL(questIES);				
            			quest.QuestMarkAdd(npcname, "I_quest_mask_progress" .. tail, 1, isMain);
            		end
        		else
        			local tail, isMain = GET_MARK_TAIL(questIES);				
        			quest.QuestMarkAdd(npcname, "I_quest_mask_progress" .. tail, 1, isMain);
        		end
    		
    		-- ����Ʈ �Ϸ�
    		elseif result == 'SUCCESS' then
    			local tail, isMain = GET_MARK_TAIL(questIES);
    			quest.QuestMarkAdd(npcname, "I_quest_mask_success" .. tail, 3, isMain);
    		
    		else
    			quest.QuestMarkAdd(npcname, "None", 0);
    		
    		end
    end		
        
    quest.UpdateQuestMark();]]--
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