function SCR_REMAINS39_MQ_MONUMENT1_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_REMAINS39_MQ_MONUMENT2_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_REMAINS39_MQ_MONUMENT3_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_REMAINS39_MQ_MONUMENT4_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_REMAINS39_MQ_MONUMENT5_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_REMAINS39_MQ_MONUMENT6_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_REMAINS39_PEAPLE_DIALOG(self, pc)
 COMMON_QUEST_HANDLER(self, pc)
end

function SCR_REMAIN39_SQ_MOJE_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_REMAIN39_SQ_MOJE_NORMAL_1(self, pc)
    SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 16, "CHAR120_REMAIN39_SQ_MOJE1", "CHAR120_REMAIN39_SQ_MOJE2")
end

function SCR_REMAIN39_SQ_MOJE_NORMAL_1_PRE(pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        return "YES"
    end
    return "NO"
end

function SCR_REMAIN39_SQ_MAN_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_REMAIN39_SQ_MAN_NORMAL_1(self, pc)
    SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 17, "CHAR120_REMAIN39_SQ_MAN1", "CHAR120_REMAIN39_SQ_MAN2")
end

function SCR_REMAIN39_SQ_MAN_NORMAL_1_PRE(pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        return "YES"
    end
    return "NO"
end

function SCR_REMAIN39_SQ_WOOD_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end


function SCR_FEDIMIAN_DETECTIVE_GUARD_DIALOG(self, pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        local sel = ShowSelDlg(pc,0, 'CHAR120_FEDIMIAN_DETECTIVE_GUARD0', ScpArgMsg('CHAR120_FEDIMIAN_DETECTIVE_SEL1'))
        if sel == 1 then
            SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 20, "CHAR120_FEDIMIAN_DETECTIVE_GUARD1", "CHAR120_FEDIMIAN_DETECTIVE_GUARD2")
        end
    end
    
    local select = ShowSelDlg(pc,0, 'FEDIMIAN_DETECTIVE_GUARD_basic01', ScpArgMsg('FEDIMIAN_DETECTIVE_GUARD_01'), ScpArgMsg('FEDIMIAN_DETECTIVE_GUARD_02'), ScpArgMsg('FEDIMIAN_DETECTIVE_GUARD_03'),ScpArgMsg('FEDIMIAN_DETECTIVE_GUARD_04'), ScpArgMsg("Auto_KeuMan_DunDa"))
    if select == 1 then
         ShowOkDlg(pc, 'FEDIMIAN_DETECTIVE_GUARD_basic02', 1)
       SCR_FEDIMIAN_DETECTIVE_GUARD_DIALOG(self, pc)
    elseif select == 2 then
         ShowOkDlg(pc, 'FEDIMIAN_DETECTIVE_GUARD_basic03', 1)
        SCR_FEDIMIAN_DETECTIVE_GUARD_DIALOG(self, pc)
    elseif select == 3 then
         ShowOkDlg(pc, 'FEDIMIAN_DETECTIVE_GUARD_basic04', 1)
        SCR_FEDIMIAN_DETECTIVE_GUARD_DIALOG(self, pc)
    elseif select == 4 then
         ShowOkDlg(pc, 'FEDIMIAN_DETECTIVE_GUARD_basic05', 1)
        SCR_FEDIMIAN_DETECTIVE_GUARD_DIALOG(self, pc)
    elseif select == 5 then
        return
    end
end

function SCR_FEDIMIAN_DETECTIVE_GUARD_NORMAL_1(self, pc)
    SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 20, "CHAR120_FEDIMIAN_DETECTIVE_GUARD1", "CHAR120_FEDIMIAN_DETECTIVE_GUARD2")
end

function SCR_FEDIMIAN_DETECTIVE_GUARD_NORMAL_1_PRE(pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        return "YES"
    end
    return "NO"
end

function SCR_CRIMINAL_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_CRIMINAL_NORMAL_1(self, pc)
    ShowOkDlg(pc, 'HIDDEN_CHAR120_MSTEP2_2', 1)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    if hidden_prop == 20 then
        SCR_SET_HIDDEN_JOB_PROP(pc, "Char1_20", 30)
    end
end

function SCR_CRIMINAL_NORMAL_1_PRE(pc)
    local hidden_prop = SCR_GET_HIDDEN_JOB_PROP(pc, "Char1_20")
    if hidden_prop <= 30 and hidden_prop >= 20 then
        return 'YES'
    end
    return 'NO'
end

function SCR_CRIMINAL_NORMAL_2(self, pc)
    SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 21, "CHAR120_CRIMINAL1", "CHAR120_CRIMINAL2")
end

function SCR_CRIMINAL_NORMAL_2_PRE(pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        return "YES"
    end
    return "NO"
end

function SCR_GHOST_APPEAR_ENTER(self, pc)
--    local result = SCR_QUEST_CHECK(pc, 'REMAIN39_SQ04')
--    if result == 'PROGRESS' then
--        local ghost = CREATE_NPC(pc, 'npc_matron2', -603, 457, 137, 0, 'Neutral', GetLayer(pc), ScpArgMsg('Auto_KeuLiSeuTiNaui_yeongHon'))
--        ObjectColorBlend(ghost, 10, 130, 255, 180, 1)
--    end
end

function SCR_REMAIN39_SQ03_GIRL_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_REMAIN39_SQ03_GIRL_NORMAL_1(self, pc)
    SCR_CHAR120_MSTEP5_2_HINT_DLG_CHECK(pc, 22, "CHAR120_REMAIN39_SQ03_GIRL1", "CHAR120_REMAIN39_SQ03_GIRL2")
end

function SCR_REMAIN39_SQ03_GIRL_NORMAL_1_PRE(pc)
    local result = SCR_CHAR120_MSTEP5_2_HINT_PREDLG(pc)
    if result == "YES" then
        return "YES"
    end
    return "NO"
end

function SCR_REMAINS39_GHOST_DIALOG(self, pc)
	StopMove(self)
	LookAt(self, pc)
	HoldScpForMS(self, 60000);
	COMMON_QUEST_HANDLER(self, pc)
end

function SCR_REMAINS39_MQ03_TEXT(self)
    ShowBalloonText(self, "REMAINS39_MQ03_ST", 3)
end

function REMAINS39_PEAPLE_TEXT(self)
    local list, cnt = SelectObjectByClassName(self, 300, 'npc_village_uncle_3')
    local i
    for i = 1 , cnt do
        LookAt(list[i], self)
        ChatLocal(list[i], self, ScpArgMsg("REMAINS39_PEAPLE"), 3)
        return
    end
end

function SCR_REMAINS39_GHOST_BAG_1_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function SCR_REMAINS39_GHOST_BAG_2_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self, pc)
end

function REMAINS39_GHOST_BAG_1(self)
    ShowBalloonText(self, "REMAIN39_SQ02_BAG_1", 4)
end


function REMAIN39_SQ03_BAL(self)
    ShowBalloonText(self, "REMAIN39_SQ03_BAL", 4)
end

function REMAIN39_SQ03_BAL_1(self)
    ShowBalloonText(self, "REMAIN39_SQ03_BAL_1", 3)
end