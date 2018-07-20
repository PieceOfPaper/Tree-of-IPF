function SCR_SSN_ORSHA_HQ2_BASIC_HOOK(self, sObj)
    SCR_REGISTER_QUEST_PROP_HOOK(self, sObj)
	RegisterHookMsg(self, sObj, 'KillMonster', 'ORSHA_HQ2_KillMonsterItem', 'YES')
end
function SCR_CREATE_SSN_ORSHA_HQ2(self, sObj)
	SCR_SSN_ORSHA_HQ2_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_ORSHA_HQ2(self, sObj)
	SCR_SSN_ORSHA_HQ2_BASIC_HOOK(self, sObj)
end

function SCR_DESTROY_SSN_ORSHA_HQ2(self, sObj)
end

function ORSHA_HQ2_KillMonsterItem(self, sObj, Msg, ArgObj, ArgStr, ArgNum)
    local quest = SCR_QUEST_CHECK(self, "ORSHA_HQ2")
    if quest == "PROGRESS" then
        if GetZoneName(self) == "f_bracken_63_3" then
            if ArgObj.ClassName == "raffly" then
                local item1 = GetInvItemCount(self, "ORSHA_HIDDENQ2_ITEM2")
                if item1 < 5 then
                    RunZombieScript("GIVE_ITEM_TX", self, "ORSHA_HIDDENQ2_ITEM2", 1, "QUEST")
                    if sObj.QuestInfoValue1 < sObj.QuestInfoMaxCount1 then
            	        sObj.QuestInfoValue1 = sObj.QuestInfoValue1 + 1
                        SaveSessionObject(self, sObj)
                    end
                end
            elseif ArgObj.ClassName == "ellogua" then
                local item2 = GetInvItemCount(self, "ORSHA_HIDDENQ2_ITEM3")
                if item2 < 4 then
                    RunZombieScript("GIVE_ITEM_TX", self, "ORSHA_HIDDENQ2_ITEM3", 1, "QUEST")
                    if sObj.QuestInfoValue2 < sObj.QuestInfoMaxCount2 then
            	        sObj.QuestInfoValue2 = sObj.QuestInfoValue2 + 1
                        SaveSessionObject(self, sObj)
                    end
                end
            end
        end
    end
end