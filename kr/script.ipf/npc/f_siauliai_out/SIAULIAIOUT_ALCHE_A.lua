

function SCR_SIAULIAIOUT_ALCHE_A_DIALOG(self,pc)
	COMMON_QUEST_HANDLER(self,pc)
end


function SCR_ALCHEMIST_DLG_PREFUNC_01(self, pc)
    local result1 = SCR_QUEST_CHECK(pc, 'SOUT_Q_16')
    local result2 = SCR_QUEST_CHECK(pc, 'MINE_3_RESQUE1')
    if result1 == "COMPLETE" and result2 ~= "COMPLETE" then
        return "YES"
    end
end

function SCR_ALCHEMIST_DLG_PREFUNC_02(self, pc)
    local result2 = SCR_QUEST_CHECK(pc, 'MINE_3_RESQUE1')
    if result2 == "COMPLETE" then 
        return "YES"
    end
end


function SCR_SIAULIAIOUT_ALCHE_A_ENTER(self, pc)
    local hideCheck = isHideNPC(pc, "SIAULIAIOUT_ALCHE_A")
    if hideCheck == "NO" then
        local levelCheck = pc.Lv
        if levelCheck >= 360 then
            AddHelpByName(pc, 'TUTO_ITEM_LINK')
        end
    end
end