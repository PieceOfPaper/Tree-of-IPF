function QUEST_LIB_DIALOGPRECHECK(pc, dialogName, handle)
    local npcselectIES = GetClass('NPCSelectDialog',dialogName)
    if npcselectIES ~= nil then
        if npcselectIES.IdleDialog ~= 'None' then
            return 1
        else
            for i = 1, MAX_NORMALDIALOG_COUNT do
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
	return QuestSubNpcDialogPreCheck(pc, dialog);
    
end
