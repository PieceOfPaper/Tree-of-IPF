

function SCR_JOB_LINKER2_2_TRIGGER_ENTER(self,pc)
	local questCheck1 = SCR_QUEST_CHECK(pc, 'JOB_LINKER2_2')
	local questCheck2 = SCR_QUEST_CHECK(pc, 'SUBMASTER_LINKER1_2')
	if questCheck1 == "PROGRESS" then
    	COMMON_QUEST_HANDLER(self,pc)
    elseif questCheck2 == "PROGRESS" then
        local itemCheck = GetInvItemCount(pc, "SUBMASTER_LINKER1_2_ITEM")
        if itemCheck == 1 then
            COMMON_QUEST_HANDLER(self,pc)
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("SUBMASTER_LINKER1_2_IN_LAYER"), 5)
        else
            return
        end
    else
        return
    end
end

function SCR_JOB_LINKER2_2_NPC_DIALOG(self,pc)
	local questCheck1 = SCR_QUEST_CHECK(pc, 'JOB_LINKER2_2')
	local questCheck2 = SCR_QUEST_CHECK(pc, 'SUBMASTER_LINKER1_2')
    if questCheck1 == 'PROGRESS' or questCheck2 == "PROGRESS" then
    local result = DOTIMEACTION_R(pc, ScpArgMsg("JOB_LINKER2_2_NPC_OPEN"), 'MAKING', 3)
        if result == 1 then
            RunScript("SCR_JOB_LINKER2_2_NPC_RUN", self, pc);
        end
    end
end


function SCR_JOB_LINKER2_2_NPC_RUN(self,pc)
    PlayAnim(self, "OPENSTD", 1)
    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("SUBMASTER_LINKER1_2_GOT_BOOK"), 5)
    GIVE_ITEM_TX(pc, 'Book7', 1, 'Quest')
    PlayEffectLocal(pc, pc, 'F_cleric_smite_cast_light', 1.5,0, "TOP")
    sleep(1500)
--    ObjectColorBlend(pc, 0,130,153,110, 0)
    ObjectColorBlend(pc, 255,255,255,255, 0)
    sleep(1500)
    SetLayer(pc, 0)
end

-- JOB_LINKER2_2 ?ш린/?ㅽ뙣 ?⑥닔 --
function JOB_LINKER2_2_FAIL(self, tx)
    ObjectColorBlend(self, 255,255,255,255, 0)
end
