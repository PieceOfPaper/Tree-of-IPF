function SCR_SSN_MASTER_ALCHEMIST1_BASIC_HOOK(self, sObj)
	RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_MASTER_ALCHEMIST1_RUN', 'YES')
	RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_MASTER_ALCHEMIST1_RUN_PARTY', 'YES')
end

function SCR_CREATE_SSN_MASTER_ALCHEMIST1(self, sObj)
	SCR_SSN_MASTER_ALCHEMIST1_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_MASTER_ALCHEMIST1(self, sObj)
	SCR_SSN_MASTER_ALCHEMIST1_BASIC_HOOK(self, sObj)
end

function SCR_DESTROY_SSN_MASTER_ALCHEMIST1(self, sObj)
end



function SCR_SSN_MASTER_ALCHEMIST1_RUN(self, sObj, msg, argObj, argStr, argNum)
    local questCheck1 = SCR_QUEST_CHECK(self,'MASTER_ALCHEMIST1')
    local itemCheck1 = GetInvItemCount(self, "JOB_ALCHEMIST_6_1_ITEM_1")
    local itemCheck2 = GetInvItemCount(self, "JOB_ALCHEMIST_6_1_ITEM_3")
    local itemCheck3 = GetInvItemCount(self, "JOB_ALCHEMIST_6_1_ITEM_2")
    if questCheck1 == 'PROGRESS' then
        if GetLayer(self) == 0 then
            if argObj.Faction == "Monster" then
                if GetZoneName(self) == 'f_orchard_34_1' then
                    if itemCheck1 < 40 then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_MASTER_ALCHEMIST1', nil, nil, nil, 'JOB_ALCHEMIST_6_1_ITEM_1/1')
                    end
                elseif GetZoneName(self) == 'f_siauliai_35_1' then
                    if itemCheck2 < 40 then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_MASTER_ALCHEMIST1', nil, nil, nil, 'JOB_ALCHEMIST_6_1_ITEM_3/1')
                    end
                elseif GetZoneName(self) == 'f_coral_32_1' then
                    if itemCheck3 < 40 then
                        SCR_PARTY_QUESTPROP_ADD(self, 'SSN_MASTER_ALCHEMIST1', nil, nil, nil, 'JOB_ALCHEMIST_6_1_ITEM_2/1')
                    end
                end
            end
        end
    end
end

function SCR_SSN_MASTER_ALCHEMIST1_RUN_PARTY(self, party_pc, sObj, msg, argObj, argStr, argNum)
    if party_pc ~= nil and self ~= nil then
        if SHARE_QUEST_PROP(self, party_pc) == true then
            if GetLayer(self) ~= 0 then
                if GetLayer(self) == GetLayer(party_pc) then
                    SCR_SSN_MASTER_ALCHEMIST1_RUN(self, sObj, msg, argObj, argStr, argNum)
                end
            else
                SCR_SSN_MASTER_ALCHEMIST1_RUN(self, sObj, msg, argObj, argStr, argNum)
            end
        end
    end
end
