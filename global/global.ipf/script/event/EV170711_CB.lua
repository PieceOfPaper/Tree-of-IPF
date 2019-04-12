function SCR_EVENT_CB_DIALOG(self, pc)
    local cbTicket = GetInvItemCount(pc, "Event_CB_Ticket")
    local aObj = GetAccountObj(pc);
    local now_time = os.date('*t')
    local yday = now_time['yday']

    if aObj.EV171017_STEAM_CB_DAY ~= yday then
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'EV171017_STEAM_CB_DAY', yday);
        TxSetIESProp(tx, aObj, 'EV171017_STEAM_CB_COUNT', 0);
        local ret = TxCommit(tx)
    end
    if aObj.EV171017_STEAM_CB_CHECK == 1 and aObj.EV171017_STEAM_CB_COUNT == 0 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Event_Cb_Buff_Item', 5, "EVENT_CB")
        TxSetIESProp(tx, aObj, 'EV171017_STEAM_CB_COUNT', 1);
        local ret = TxCommit(tx)
        ShowOkDlg(pc,'NPC_EVENT_JP_DAY_CHECK_2', 1)
        return
    elseif aObj.EV171017_STEAM_CB_CHECK == 1 then
        ShowOkDlg(pc,'NPC_EVENT_TODAY_NUMBER_5', 1)
        return
    end
    if cbTicket > 0 then
        local tx = TxBegin(pc)
        TxTakeItem(tx, 'Event_CB_Ticket', 1, "EVENT_CB") 
        TxGiveItem(tx, 'PremiumToken_5d_event', 1, "EVENT_CB")
        TxGiveItem(tx, 'Premium_boostToken03_event01', 5, "EVENT_CB")
        TxGiveItem(tx, 'Ability_Point_Stone', 1, "EVENT_CB")
        TxGiveItem(tx, 'Premium_SkillReset_14d', 1, "EVENT_CB")
        TxGiveItem(tx, 'Premium_StatReset14', 1, "EVENT_CB")
        TxGiveItem(tx, 'Event_Cb_Buff_Item', 5, "EVENT_CB")
        TxGiveItem(tx, 'Event_Cb_Buff_Potion', 1, "EVENT_CB")
        TxSetIESProp(tx, aObj, 'EV171017_STEAM_CB_CHECK', 1);
        TxSetIESProp(tx, aObj, 'EV171017_STEAM_CB_COUNT', 1);
        TxSetIESProp(tx, aObj, 'EV171017_STEAM_CB_DAY', yday);
        local ret = TxCommit(tx)
    else
        ShowOkDlg(pc,'NPC_EVENT_CB_1', 1)
    end
end