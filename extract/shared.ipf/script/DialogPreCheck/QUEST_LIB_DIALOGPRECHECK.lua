function QUEST_LIB_DIALOGPRECHECK(pc, dialogName, handle)
    local npcselectIES = GetClass('NPCSelectDialog',dialogName)
    if npcselectIES ~= nil then
        if npcselectIES.IdleDialog ~= 'None' then
            return 1
        else
            for i = 1, 10 do
                if npcselectIES['NormalDialog'..i] ~= 'None' then
                    return 1
                end
            end
            
            for i = 1, 50 do
                if npcselectIES['QuestName'..i] ~= 'None' then
                    local questIES = GetClass('QuestProgressCheck',npcselectIES['QuestName'..i])
                    if questIES ~= nil then
                        if questIES.StartNPC == dialogName or questIES.ProgNPC == dialogName or questIES.EndNPC == dialogName then
                            local result = SCR_QUEST_CHECK(pc, npcselectIES['QuestName'..i])
                            if result == 'POSSIBLE' then
                                if questIES.StartNPC == dialogName then
                                    local func = _G['SCR_'..dialogName..'_PRE_DIALOG_ANGLE']
                                    if func ~= nil then
                                        local result = func(pc, dialogName, handle)
                                        if result == 'YES' then
                                            return 1
                                        end
                                    else
                                        return 1
                                    end
                                end
                            elseif result == 'PROGRESS' then
                                if questIES.StartNPC == dialogName or questIES.ProgNPC == dialogName then
                                    local func = _G['SCR_'..dialogName..'_PRE_DIALOG_ANGLE']
                                    if func ~= nil then
                                        local result = func(pc, dialogName, handle)
                                        if result == 'YES' then
                                            return 1
                                        end
                                    else
                                        return 1
                                    end
                                end
                            elseif result == 'SUCCESS' then
                                if questIES.StartNPC == dialogName or questIES.ProgNPC == dialogName or questIES.EndNPC == dialogName then
                                    local func = _G['SCR_'..dialogName..'_PRE_DIALOG_ANGLE']
                                    if func ~= nil then
                                        local result = func(pc, dialogName, handle)
                                        if result == 'YES' then
                                            return 1
                                        end
                                    else
                                        return 1
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        return 0
    end
    
    return 0
end

function QUEST_SUB_NPC_DIALOGPRECHECK(pc, dialog)
    local main_sObj = GetSessionObject(pc, 'ssn_klapeda')
    
    local clslist, cnt  = GetClassList("SessionObject");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		if GetPropType(cls, 'QuestName') ~= nil then
		    if cls.QuestName ~= "None" then
		        for x = 1, 10 do
					if cls['QuestInfoNPCFunc'..x] ~= nil then
		            if cls['QuestInfoNPCFunc'..x] ~= "None" then
		                local npcFuncList = SCR_STRING_CUT(cls['QuestInfoNPCFunc'..x])
		                local maxindex = #npcFuncList
		                for y = 1, maxindex do
		                    if npcFuncList[y] == dialog then
		                        if GetPropType(main_sObj, cls.QuestName) ~= nil then
		                            if main_sObj[cls.QuestName] > 0 and main_sObj[cls.QuestName] < 200 then
        		                        local quset_sObj = GetSessionObject(pc, cls.ClassName)
        		                        if quset_sObj ~= nil then
        		                            if quset_sObj['QuestInfoMaxCount'..x] > quset_sObj['QuestInfoValue'..x] then
        		                                return 1
        		                            end
        		                        end
        		                    end
		                        end
		                        break
		                    end
		                end
		            end
		        end
		    end
		end
	end
	end
	
    return 0
end
