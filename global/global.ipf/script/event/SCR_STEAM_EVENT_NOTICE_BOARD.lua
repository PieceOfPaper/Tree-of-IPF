function SCR_STEAM_TREASURE_EVENT_DIALOG(self,pc)
    local select = ShowSelDlg(pc,0, 'EV_DAILYBOX_SEL', ScpArgMsg("Steam_Event_SongPyeon"), ScpArgMsg("Cancel"))

    if select == 1 then
        local msgBig = nil 
        local aobj = GetAccountObj(pc);
        local now_time = os.date('*t')
        local year = now_time['year']
        local month = now_time['month']
        local day = now_time['day']
        local nowYday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
        if aobj ~= nil then
            if aobj.CHUSEOK_EVENT_DATE < nowYday or aobj.CHUSEOK_EVENT_DAY_COUNT < 3 then
                msgBig = ScpArgMsg('CHUSEOK_EVENT_MSG2')
            end
        end
        local select1 = ShowSelDlg(pc, 0, 'EV_SONGPYEON_DESC1',  ScpArgMsg('CHUSEOK_EVENT_MSG1'), ScpArgMsg('CHUSEOK_EVENT_MSG3'), msgBig, ScpArgMsg('Auto_DaeHwa_JongLyo'))
        
        if select1 == 1 then
            local dlgTable = {'KLAPEDA_CHUSEOK_EVENT_SELECT1','KLAPEDA_CHUSEOK_EVENT_ERROR1','KLAPEDA_CHUSEOK_EVENT_ERROR2'}
	        SCR_CHUSEOK_EVENT_EXCHANGE1(pc, dlgTable)
        elseif select1 == 2 then
            SCR_CHUSEOK_EVENT_EXCHANGE3(pc)
        elseif select1 == 3 then
            SCR_CHUSEOK_EVENT_EXCHANGE2(pc)
        end
    end
end

function SCR_CHUSEOK_EVENT_EXCHANGE1(pc, dlgTable)
    local input = ShowTextInputDlg(pc, 0, dlgTable[1])
    local price = 100
    input = tonumber(input)
    if input ~= nil and input > 0 then
        local count = GetInvItemCount(pc, 'Vis')
        local value = price * input
        if count >= value then
            GIVE_TAKE_ITEM_TX(pc, 'R_Event_160908_5/'..input, 'Vis/'..value, 'CHUSEOK_EVENT')
        else
            ShowOkDlg(pc,dlgTable[2], 1)
        end
    else
        ShowOkDlg(pc,dlgTable[3], 1)
    end
end

function SCR_CHUSEOK_EVENT_EXCHANGE2(pc)
    local aObj = GetAccountObj(pc)
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local year = now_time['year']

    if aObj ~= nil then
        if aObj.DAYCHECK_EVENT_LAST_DATE ~= year..'/'..yday then
            local tx = TxBegin(pc);
            TxSetIESProp(tx, aObj, 'DAYCHECK_EVENT_LAST_DATE', year..'/'..yday)
            TxGiveItem(tx, 'R_Event_160908_6', 3, "CHUSEOK_EVENT")
            local ret = TxCommit(tx);
        end
    end
end

function SCR_CHUSEOK_EVENT_EXCHANGE3(pc)
    local aObj = GetAccountObj(pc)
    local now_time = os.date('*t')
    local yday = now_time['yday']
    local count = GetInvItemCount(pc, 'R_Event_160908_6')
    
    if aObj.ExchangeRewardDay == yday then
        ShowOkDlg(pc, 'EV_EXCHANGE3_DESC2', 1)
        return
    end
    
    if count < 5 then
        ShowOkDlg(pc, 'EV_EXCHANGE3_DESC1', 1)
        return
    end
    
    if aObj ~= nil then
        if aObj.ExchangeRewardDay ~= yday then
            local tx = TxBegin(pc);
            TxSetIESProp(tx, aObj, 'ExchangeRewardDay', yday)
            TxGiveItem(tx, 'Premium_indunReset_14d', 1, "CHUSEOK_EVENT_EXCHANGE3")
            TxTakeItem(tx, 'R_Event_160908_6', 5, "CHUSEOK_EVENT_EXCHANGE3");
            local ret = TxCommit(tx);
        end
    end
end