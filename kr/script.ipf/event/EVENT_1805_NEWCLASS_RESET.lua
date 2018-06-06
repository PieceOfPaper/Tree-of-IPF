function SCR_EVENT_1805_NEWCLASS_RESET_NPC_DIALOG(self, pc)  
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local nowDate = year..'/'..month..'/'..day
    
    local sObj = GetSessionObject(pc, 'ssn_klapeda')
    
    if sObj == nil then
        return
    end
    
    local selmsg1_2
    local jobCircle1 = GetJobGradeByName(pc, 'Char3_12')
    local jobCircle2 = GetJobGradeByName(pc, 'Char4_20')
    
    local select = ShowSelDlg(pc, 0, 'EVENT_1805_NEWCLASS_RESET_DLG1', ScpArgMsg('EVENT_1805_NEWCLASS_RESET_MSG1'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
    
    if select == 1 then
        if jobCircle1 < 1 and jobCircle2 < 1 then
            ShowOkDlg(pc, 'EVENT_1805_NEWCLASS_RESET_DLG3', 1)
            return
        end
        
        if sObj.EVENT_1805_NEWCLASS_RESET_ACC_COUNT >= 3 then
            ShowOkDlg(pc, 'EVENT_1805_NEWCLASS_RESET_DLG4', 1)
            return
        end
        
        if sObj.EVENT_1805_NEWCLASS_RESET_DATE == nowDate then
            ShowOkDlg(pc, 'EVENT_1805_NEWCLASS_RESET_DLG2', 1)
            return
        end
        
        local tx = TxBegin(pc)
        TxSetIESProp(tx, sObj, 'EVENT_1805_NEWCLASS_RESET_DATE', nowDate)
        TxSetIESProp(tx, sObj, 'EVENT_1805_NEWCLASS_RESET_ACC_COUNT', sObj.EVENT_1805_NEWCLASS_RESET_ACC_COUNT + 1)
        TxGiveItem(tx, 'Premium_RankReset_1d', 1, 'EVENT_1805_NEWCLASS_RESET')
        TxGiveItem(tx, 'Premium_StatReset_1d', 1, 'EVENT_1805_NEWCLASS_RESET')
        local ret = TxCommit(tx)
        if ret == 'SUCCESS' then
            local lastCount = ''
            if sObj.EVENT_1805_NEWCLASS_RESET_ACC_COUNT == 3 then
                lastCount = ScpArgMsg("EVENT_1805_NEWCLASS_RESET_MSG3")
            end
            
            SendAddOnMsg(pc, "NOTICE_Dm_GetItem", lastCount..ScpArgMsg("EVENT_1805_NEWCLASS_RESET_MSG2","COUNT",sObj.EVENT_1805_NEWCLASS_RESET_ACC_COUNT), 10)
        end
    end
end
