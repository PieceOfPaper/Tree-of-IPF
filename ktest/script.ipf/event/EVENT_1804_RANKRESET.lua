function SCR_EVENT_1804_RANKRESET_NPC_DIALOG(self, pc)    
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
    local jobCircle1 = GetJobGradeByName(pc, 'Char4_1')
    local jobCircle2 = GetJobGradeByName(pc, 'Char3_1')
    if jobCircle1 >= 1 or jobCircle2 >= 1 then
        selmsg1_2 = ScpArgMsg('EVENT_1801_RANKRESET_MSG2')
    end
    local select = ShowSelDlg(pc, 0, 'BALANCE_7_GIVE_ITEM_DLG1', ScpArgMsg('EVENT_1801_RANKRESET_MSG1'), selmsg1_2, ScpArgMsg('Auto_DaeHwa_JongLyo'))
    
    if select == 1 then
        local jobCircle3 = GetJobGradeByName(pc, 'Char4_1')
        local jobCircle4 = GetJobGradeByName(pc, 'Char3_1')
        local jobCircle5 = GetJobGradeByName(pc, 'Char1_20')
        if (jobCircle3 == nil or jobCircle3 < 1) and (jobCircle4 == nil or jobCircle4 < 1) and (jobCircle5 == nil or jobCircle5 < 1) then
            ShowOkDlg(pc, 'BALANCE_7_GIVE_ITEM_DLG3', 1)
            return
        end
        if sObj.EVENT_1804_CLR_DATE ~= 'None' then
            ShowOkDlg(pc, 'BALANCE_7_GIVE_ITEM_DLG2', 1)
            return
        end
        local tx = TxBegin(pc)
        TxSetIESProp(tx, sObj, 'EVENT_1804_CLR_DATE', nowDate)
        if jobCircle5 >= 1 then
            TxGiveItem(tx, 'Premium_SkillReset_14d', 2, 'EVENT_1804_RANKRESE')
        else
            TxGiveItem(tx, 'Premium_StatReset14', 2, 'EVENT_1804_RANKRESE')
            TxGiveItem(tx, 'Premium_SkillReset_14d', 2, 'EVENT_1804_RANKRESE')
            TxGiveItem(tx, 'Premium_Abillitypoint_14d', 2, 'EVENT_1804_RANKRESE')
        end
        local ret = TxCommit(tx)
    elseif select == 2 then
        local exchangeItem
        if jobCircle1 >= 1 then
            local itemList = {{'misc_brokenwheel', 1, 'misc_torturetools', 3},
                                {'wood_01', 1, 'wood_06', 1},
                                {'wood_03', 1, 'wood_06', 1},
                                {'wood_04', 1, 'wood_06', 1},
                                {'wood_02', 1, 'wood_06', 1}}

            local selmsg2_1 = ScpArgMsg('EVENT_1801_RANKRESET_MSG3','ITEM1',GetClassString('Item', itemList[1][1],'Name'),'COUNT1',itemList[1][2],'ITEM2',GetClassString('Item', itemList[1][3],'Name'),'COUNT2',itemList[1][4])
            local selmsg2_2 = ScpArgMsg('EVENT_1801_RANKRESET_MSG3','ITEM1',GetClassString('Item', itemList[2][1],'Name'),'COUNT1',itemList[2][2],'ITEM2',GetClassString('Item', itemList[2][3],'Name'),'COUNT2',itemList[2][4])
            local selmsg2_3 = ScpArgMsg('EVENT_1801_RANKRESET_MSG3','ITEM1',GetClassString('Item', itemList[3][1],'Name'),'COUNT1',itemList[3][2],'ITEM2',GetClassString('Item', itemList[3][3],'Name'),'COUNT2',itemList[3][4])
            local selmsg2_4 = ScpArgMsg('EVENT_1801_RANKRESET_MSG3','ITEM1',GetClassString('Item', itemList[4][1],'Name'),'COUNT1',itemList[4][2],'ITEM2',GetClassString('Item', itemList[4][3],'Name'),'COUNT2',itemList[4][4])
            local selmsg2_5 = ScpArgMsg('EVENT_1801_RANKRESET_MSG3','ITEM1',GetClassString('Item', itemList[5][1],'Name'),'COUNT1',itemList[5][2],'ITEM2',GetClassString('Item', itemList[5][3],'Name'),'COUNT2',itemList[5][4])
            
            local select2 = ShowSelDlg(pc, 0, 'BALANCE_7_GIVE_ITEM_DLG7', selmsg2_1, selmsg2_2, selmsg2_3, selmsg2_4, selmsg2_5, ScpArgMsg('Auto_DaeHwa_JongLyo'))
            
            if select2 >= 1 and select2 <= 5 then
                exchangeItem = itemList[select2]
            end
        elseif jobCircle2 >= 1 then
            local itemList = {{'misc_claymore', 1, 'misc_trapkit', 10},
                                {'wood_03', 3, 'misc_trapkit', 1},
                                {'wood_02', 3, 'misc_trapkit', 1},
                                {'misc_wire', 1, 'misc_trapkit', 10}}

            local selmsg2_1 = ScpArgMsg('EVENT_1801_RANKRESET_MSG3','ITEM1',GetClassString('Item', itemList[1][1],'Name'),'COUNT1',itemList[1][2],'ITEM2',GetClassString('Item', itemList[1][3],'Name'),'COUNT2',itemList[1][4])
            local selmsg2_2 = ScpArgMsg('EVENT_1801_RANKRESET_MSG3','ITEM1',GetClassString('Item', itemList[2][1],'Name'),'COUNT1',itemList[2][2],'ITEM2',GetClassString('Item', itemList[2][3],'Name'),'COUNT2',itemList[2][4])
            local selmsg2_3 = ScpArgMsg('EVENT_1801_RANKRESET_MSG3','ITEM1',GetClassString('Item', itemList[3][1],'Name'),'COUNT1',itemList[3][2],'ITEM2',GetClassString('Item', itemList[3][3],'Name'),'COUNT2',itemList[3][4])
            local selmsg2_4 = ScpArgMsg('EVENT_1801_RANKRESET_MSG3','ITEM1',GetClassString('Item', itemList[4][1],'Name'),'COUNT1',itemList[4][2],'ITEM2',GetClassString('Item', itemList[4][3],'Name'),'COUNT2',itemList[4][4])
            
            local select2 = ShowSelDlg(pc, 0, 'BALANCE_7_GIVE_ITEM_DLG7', selmsg2_1, selmsg2_2, selmsg2_3, selmsg2_4, ScpArgMsg('Auto_DaeHwa_JongLyo'))
            
            if select2 >= 1 and select2 <= 4 then
                exchangeItem = itemList[select2]
            end
        end
        if exchangeItem ~= nil then
            local targetItem = exchangeItem[1]
            local targetItemCount = exchangeItem[2]
            local giveItem = exchangeItem[3]
            local giveItemCount = exchangeItem[4]
            
            local nowItemCount = GetInvItemCount(pc, targetItem)
            if nowItemCount >= targetItemCount then
                local exchangeCount = math.floor(nowItemCount/targetItemCount)
                
                local tx = TxBegin(pc)
                TxTakeItem(tx, targetItem, exchangeCount*targetItemCount, 'EVENT_1804_RANKRESE')
                TxGiveItem(tx, giveItem, exchangeCount*giveItemCount, 'EVENT_1804_RANKRESE')
                local ret = TxCommit(tx)
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("REQUEST_TAKE_ITEM"), 5);
            end
        end
    end
end
