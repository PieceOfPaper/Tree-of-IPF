function SCR_STEAM_NEW_YEAR_BOX_DIALOG(self, pc)
    local kCount = GetInvItemCount(pc, 'Event_Steam_Last_Winter_Key')
    local aObj = GetAccountObj(pc)

    if aObj.EV180220_LAST_WINTER_EGG_CHECK == 0 then
        if kCount >= 10 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_JaMulSoe_yeoNeun_Jung"), 'MAKING', 3)
            if result == 1 then
                local tx = TxBegin(pc)
                TxTakeItem(tx, 'Event_Steam_Last_Winter_Key', 10, 'LAST_WINTER');
                TxGiveItem(tx, 'egg_020', 1, 'LAST_WINTER');
                TxSetIESProp(tx, aObj, 'EV180220_LAST_WINTER_EGG_CHECK', 1);
                local ret = TxCommit(tx)
                if ret == 'SUCCESS' then
                    ShowOkDlg(pc, 'NPC_EVENT_LAST_WINTER_DLG3', 1)
                    local teamlv = GetTeamLevel(pc)
                    local teamName = GetTeamName(pc);
                    IMCLOG_CONTENT("180220_LAST_WINTER_EVENT", "PClv:  ", pc.Lv, "TeamLv:  ", teamlv, "TeamName:   ", teamName)
                end
            end
        else
            ShowOkDlg(pc, 'NPC_EVENT_LAST_WINTER_DLG2', 1)
        end
    else
        if kCount > 0 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_JaMulSoe_yeoNeun_Jung"), 'MAKING', 3)
        local rand = IMCRandom(1, 100);   
            if result == 1 then
                if rand <= 5 then
                    local tx = TxBegin(pc)
                    TxTakeItem(tx, 'Event_Steam_Last_Winter_Key', 1, 'LAST_WINTER');
                    TxGiveItem(tx, 'Premium_boostToken_14d', 1, 'LAST_WINTER');
                    local ret = TxCommit(tx)
                elseif rand <= 30 then
                    local tx = TxBegin(pc)
                    TxTakeItem(tx, 'Event_Steam_Last_Winter_Key', 1, 'LAST_WINTER');
                    TxGiveItem(tx, 'RestartCristal', 1, 'LAST_WINTER');
                    local ret = TxCommit(tx)
                elseif rand <= 60 then
                    local tx = TxBegin(pc)
                    TxTakeItem(tx, 'Event_Steam_Last_Winter_Key', 1, 'LAST_WINTER');
                    TxGiveItem(tx, 'Mic', 1, 'LAST_WINTER');
                    local ret = TxCommit(tx)
                else
                    local tx = TxBegin(pc)
                    TxTakeItem(tx, 'Event_Steam_Last_Winter_Key', 1, 'LAST_WINTER');
                    TxGiveItem(tx, 'Premium_WarpScroll_14d', 1, 'LAST_WINTER');
                    local ret = TxCommit(tx)
                end
            end
            return
        end
        ShowOkDlg(pc, 'NPC_EVENT_LAST_WINTER_DLG3', 1)
    end
end