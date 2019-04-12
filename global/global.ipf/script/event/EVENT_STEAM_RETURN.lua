function SCR_STEAM_RETURN_EVENT_DIALOG(self,pc)
    local aObj = GetAccountObj(pc);
    local now_time = os.date('*t')
    local yday = now_time['yday']

    if aObj.EV180109_STEAM_RETURN_JOIN_CHECK ~= 1 then
        ShowOkDlg(pc,'EVENT_STEAM_RETURN_DLG_1', 1)
        return
    end
    if aObj.EV180109_STEAM_RETURN_DAY_CHECK ~= yday then
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'EV180109_STEAM_RETURN_DAY_CHECK', yday);
        TxSetIESProp(tx, aObj, 'EV180109_STEAM_RETURN_REWARD_CHECK', 0);
        local ret = TxCommit(tx)
    end
    if aObj.EV180109_STEAM_RETURN_JOIN_CHECK == 1 and aObj.EV180109_STEAM_RETURN_REWARD_CHECK == 0 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Event_Cb_Buff_Item', 5, "EVENT_RETURN")
        TxSetIESProp(tx, aObj, 'EV180109_STEAM_RETURN_REWARD_CHECK', 1);
        local ret = TxCommit(tx)
        ShowOkDlg(pc,'NPC_EVENT_JP_DAY_CHECK_2', 1)
    elseif aObj.EV180109_STEAM_RETURN_JOIN_CHECK == 1 and aObj.EV180109_STEAM_RETURN_REWARD_CHECK == 1 then
        ShowOkDlg(pc,'NPC_EVENT_TODAY_NUMBER_5', 1)
    end
end

function SCR_USE_EVENT_RETURN_BOX(pc)
    local aObj = GetAccountObj(pc);
    local now_time = os.date('*t')
    local yday = now_time['yday']

    local tx = TxBegin(pc)
    TxGiveItem(tx, 'PremiumToken_5d_event', 1, "EVENT_RETURN")
    TxGiveItem(tx, 'Premium_boostToken03_event01', 5, "EVENT_RETURN")
    TxGiveItem(tx, 'Ability_Point_Stone_500', 1, "EVENT_RETURN")
    TxGiveItem(tx, 'Premium_SkillReset_14d', 1, "EVENT_RETURN")
    TxGiveItem(tx, 'Premium_StatReset14', 1, "EVENT_RETURN")
    TxGiveItem(tx, 'Event_Cb_Buff_Item', 5, "EVENT_RETURN")
    TxGiveItem(tx, 'Event_Cb_Buff_Potion', 1, "EVENT_RETURN")
    TxSetIESProp(tx, aObj, 'EV180109_STEAM_RETURN_JOIN_CHECK', 1);
    TxSetIESProp(tx, aObj, 'EV180109_STEAM_RETURN_REWARD_CHECK', 1);
    TxSetIESProp(tx, aObj, 'EV180109_STEAM_RETURN_DAY_CHECK', yday);
    local ret = TxCommit(tx)
    if ret == 'SUCCESS' then
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("EVENT_STEAM_RETURN_SEL2"), 8);
    end
end