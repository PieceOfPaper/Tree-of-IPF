function SCR_SSN_CORAL_44_3_SQ_60_BASIC_HOOK(self, sObj)
	RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_CORAL_44_3_SQ_60_KillMonster', 'YES')
	RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_CORAL_44_3_SQ_60_KillMonster', 'YES')
	SCR_REGISTER_QUEST_PROP_HOOK(self, sObj)
end
function SCR_CREATE_SSN_CORAL_44_3_SQ_60(self, sObj)
	SCR_SSN_CORAL_44_3_SQ_60_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_CORAL_44_3_SQ_60(self, sObj)
	SCR_SSN_CORAL_44_3_SQ_60_BASIC_HOOK(self, sObj)
	ABANDON_TRACK_QUEST(self, sObj.QuestName, 'SYSTEMCANCEL', 'PROGRESS')
end

function SCR_DESTROY_SSN_CORAL_44_3_SQ_60(self, sObj)
end

function SCR_CORAL_44_3_SQ_60_KillMonster(self, sObj, msg, argObj, argStr)
    local result = SCR_QUEST_CHECK(self, 'CORAL_44_3_SQ_60')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_coral_44_3' then
            if GetLayer(self) ~= 0 then
                if argObj.ClassName == 'boss_varleking_Q1' then
                    SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CORAL_44_3_SQ_60', 'QuestInfoValue2', 1)
--                    local list, cnt = GetWorldObjectList(self, "MON", 400)
--                    if cnt >= 1 then
--                        for i = 1, cnt do
--                            if list[i].ClassName == 'npc_friar_01' then
--                                Chat(list[i], ScpArgMsg("CORAL_44_3_SQ_60_MSG1"))
--                                SCR_PARTY_QUESTPROP_ADD(self, 'SSN_CORAL_44_3_SQ_60', 'Step1', 1, nil, nil, nil, nil, nil, nil, nil, nil, nil, 'NOTICE_Dm_scroll/'..ScpArgMsg("CORAL_44_3_SQ_60_MSG2")..'/8')
--                            end
--                        end
--                    end
                end
            end
        end
    end
end