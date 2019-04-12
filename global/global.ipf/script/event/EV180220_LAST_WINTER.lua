function SCR_PRECHECK_CONSUME_STEAM_ICICLE(pc)
    local x,y,z = GetPos(pc);
    local fndList1, fndCount1 = SelectObjectPos(pc, x, y, z, 30, "ALL");
    for i = 1, fndCount1 do
        if fndList1[i].ClassName == 'bonfire_1' then
            LookAt(pc, fndList1[i])
            return 1;
        end
    end
    SendSysMsg(pc, "UseItAroundCampfires");
end

function SCR_EV180220_LAST_WINTER_DIALOG(self, pc)
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local hour = now_time['hour']
    local min = now_time['min']
    local ymin = (yday * 24 * 60) + hour * 60 + min
    local aObj = GetAccountObj(pc)

    if aObj.EV180220_LAST_WINTER_DAY_CHECK ~= yday then
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'EV180220_LAST_WINTER_KEY_CHECK', 0);
        local ret = TxCommit(tx)
    end

    local select = ShowSelDlg(pc, 0, 'NPC_EVENT_LAST_WINTER_DLG1', ScpArgMsg("EVENT_STEAM_LAST_WINTER_SEL2"), ScpArgMsg("EVENT_STEAM_LAST_WINTER_SEL3"), ScpArgMsg("Cancel")) 
    if select == 1 then
        if IsBuffApplied(pc, 'Event_Steam_Last_Winter') == 'NO' then
            AddBuff(self, pc, 'Event_Steam_Last_Winter', 1, 0, 7200000, 1);
        else
            ShowOkDlg(pc, 'NPC_EVENT_LAST_WINTER_DLG4', 1) 
        end
    elseif select == 2 then
        if ymin - aObj.EV180220_LAST_WINTER_TIME_CHECK >= 120 and aObj.EV180220_LAST_WINTER_KEY_CHECK < 3 then
            local tx = TxBegin(pc)
            TxGiveItem(tx, 'Premium_Enchantchip14', 2, 'LAST_WINTER');
            TxGiveItem(tx, 'Event_Steam_Last_Winter_Icicle', 2, 'LAST_WINTER');
            TxGiveItem(tx, 'Event_Steam_Last_Winter_Key', 2, 'LAST_WINTER');
            TxSetIESProp(tx, aObj, 'EV180220_LAST_WINTER_TIME_CHECK', ymin);
            TxSetIESProp(tx, aObj, 'EV180220_LAST_WINTER_KEY_CHECK', aObj.EV180220_LAST_WINTER_KEY_CHECK + 1);
            TxSetIESProp(tx, aObj, 'EV180220_LAST_WINTER_DAY_CHECK', yday);
            local ret = TxCommit(tx)
        else
            ShowOkDlg(pc, 'NPC_EVENT_LAST_WINTER_DLG5', 1) 
        end
    end
end