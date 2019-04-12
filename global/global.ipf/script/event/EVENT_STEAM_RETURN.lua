function SCR_STEAM_RETURN_EVENT_DIALOG(self,pc)
    local aObj = GetAccountObj(pc);
    local now_time = os.date('*t')
    local yday = now_time['yday']

    if aObj.EVENT_1708_JURATE_START ~= 1 then
        ShowOkDlg(pc,'EVENT_STEAM_RETURN_DLG_1', 1)
        return
    end
    if aObj.EVENT_1708_JURATE_REWARD_COUNT ~= yday then
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'EVENT_1708_JURATE_REWARD_COUNT', yday);
        TxSetIESProp(tx, aObj, 'EVENT_1708_JURATE_COUNT', 0);
        local ret = TxCommit(tx)
    end
    if aObj.EVENT_1708_JURATE_START == 1 and aObj.EVENT_1708_JURATE_COUNT == 0 then
        local tx = TxBegin(pc)
        TxGiveItem(tx, 'Event_Cb_Buff_Item', 5, "EVENT_RETURN")
        TxSetIESProp(tx, aObj, 'EVENT_1708_JURATE_COUNT', 1);
        local ret = TxCommit(tx)
        ShowOkDlg(pc,'NPC_EVENT_JP_DAY_CHECK_2', 1)
    elseif aObj.EVENT_1708_JURATE_START == 1 and aObj.EVENT_1708_JURATE_COUNT == 1 then
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
    TxSetIESProp(tx, aObj, 'EVENT_1708_JURATE_START', 1);
    TxSetIESProp(tx, aObj, 'EVENT_1708_JURATE_COUNT', 1);
    TxSetIESProp(tx, aObj, 'EVENT_1708_JURATE_REWARD_COUNT', yday);
    local ret = TxCommit(tx)
    if ret == 'SUCCESS' then
        SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("EVENT_STEAM_RETURN_SEL2"), 8);
    end
end