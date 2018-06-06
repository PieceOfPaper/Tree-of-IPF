function SCR_REMAINS39_RP_1_NPC_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_REMAINS39_RP_1_NPC_NORMAL_1(self, pc)
    SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 18, "CHAR120_REMAINS39_RP_1_NPC1", "CHAR120_REMAINS39_RP_1_NPC2")
end

function SCR_REMAINS39_RP_1_NPC_NORMAL_1_PRE(pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        return "YES"
    end
    return "NO"
end