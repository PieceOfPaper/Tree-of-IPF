function SCR_EVENT_1706_FISHING_BALLOON_DIALOG(self,pc)
    local select = ShowSelDlg(pc, 0, 'EVENT_1706_FISHING_BALLOON_DLG1', ScpArgMsg("EVENT_1706_FISHING_BALLOON_MSG1"), ScpArgMsg("Auto_DaeHwa_JongLyo"))
    if select == 1 then
        local balloonList = {{'E_Balloon_7',34},{'E_Balloon_8',33},{'E_Balloon_9',33}}
        for i = 1, #balloonList do
            if GetInvItemCount(pc,balloonList[i][1]) > 0 then
                SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('EVENT_1706_FISHING_BALLOON_MSG2','ITEM',GetClassString('Item',balloonList[i][1],'Name')), 10)
                ShowOkDlg(pc, 'EVENT_1706_FISHING_BALLOON_DLG2', 1)
                return
            end
        end
        
        
        local maxRate = 0
        for i = 1, #balloonList do
            maxRate = maxRate + balloonList[i][2]
        end
        
        local rand = IMCRandom(1, maxRate)
        local targetIndex = 0
        local accRate = 0
        
        for i = 1, #balloonList do
            accRate = accRate + balloonList[i][2]
            if rand <= accRate then
                targetIndex = i
                break
            end
        end
        local tx = TxBegin(pc);
--        if sObj.EVENT_1706_FISHING_BALLOON_COUNT == 0 then
--            local pcGender = pc.Gender
--            local costumeList = {'costume_simple_festival_m','costume_simple_festival_f'}
--            TxGiveItem(tx, costumeList[pcGender], 1, 'EVENT_1706_FISHING_ARTEFACT')
--        end
    	TxGiveItem(tx, balloonList[targetIndex][1], 1, 'EVENT_1706_FISHING_BALLOON')
--    	TxSetIESProp(tx, sObj, 'EVENT_1706_FISHING_BALLOON_COUNT', sObj.EVENT_1706_FISHING_BALLOON_COUNT + 1)
    	local ret = TxCommit(tx);
    end
end
