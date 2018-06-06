function SCR_SSN_MASTER_FIREMAGE1_BASIC_HOOK(self, sObj)
	RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_MASTER_FIREMAGE1_KillMonster', 'YES')
	RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_MASTER_FIREMAGE1_KillMonster_PARTY', 'YES')
end
function SCR_CREATE_SSN_MASTER_FIREMAGE1(self, sObj)
	SCR_SSN_MASTER_FIREMAGE1_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_MASTER_FIREMAGE1(self, sObj)
	SCR_SSN_MASTER_FIREMAGE1_BASIC_HOOK(self, sObj)
	ABANDON_TRACK_QUEST(self, sObj.QuestName, 'SYSTEMCANCEL', 'PROGRESS')
end

function SCR_DESTROY_SSN_MASTER_FIREMAGE1(self, sObj)
end

function SCR_SSN_MASTER_FIREMAGE1_KillMonster(self, sObj, Msg, ArgObj, ArgStr, ArgNum)
    local questCheck = SCR_QUEST_CHECK(self, 'MASTER_FIREMAGE1')
    if questCheck ~= nil then
        if questCheck == 'PROGRESS' then
            if GetZoneName(self) == 'c_voodoo' then
                if ArgObj.ClassName == "spector_F_purple_J1" then
                    sObj.QuestInfoValue1 = sObj.QuestInfoValue1 +1
                    SaveSessionObject(self, sObj)
                end
            end
        end
    end
end


function SCR_SSN_MASTER_FIREMAGE1_KillMonster_PARTY(self, party_pc, sObj, msg, argObj, argStr, argNum)
    if party_pc ~= nil and self ~= nil then
        if SHARE_QUEST_PROP(self, party_pc) == true then
            if GetLayer(self) ~= 0 then
                if GetLayer(self) == GetLayer(party_pc) then
                    SCR_SSN_MASTER_FIREMAGE1_KillMonster(self, sObj, msg, argObj, argStr, argNum)
                end
            else
                SCR_SSN_MASTER_FIREMAGE1_KillMonster(self, sObj, msg, argObj, argStr, argNum)
            end
        end
    end
end
