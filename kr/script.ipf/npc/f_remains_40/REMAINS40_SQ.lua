function SCR_REMAINS_40_CANOLIN_01_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc);
end

function SCR_REMAINS_40_CANOLIN_01_NORMAL_1(self, pc)
    SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 19, "CHAR120_REMAINS_40_CANOLIN_01_1", "CHAR120_REMAINS_40_CANOLIN_01_2")
end

function SCR_REMAINS_40_CANOLIN_01_NORMAL_1_PRE(pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        return "YES"
    end
    return "NO"
end

function SCR_REMAINS_40_TARA_01_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc);
end

function SCR_REMAINS_40_TARA_02_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc);
end

function SCR_REMAINS40_SQ_02_ENTER(self, pc)
    COMMON_QUEST_HANDLER(self,pc);
end

function SCR_REMAINS40_BOARD01_DIALOG(self, pc)
    ShowOkDlg(pc, "REMAINS40_BOARD01_BASIC01", 1)
end
