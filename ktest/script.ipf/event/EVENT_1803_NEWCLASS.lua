function SCR_PRE_EVENT_1803_NEWCLASS_BOX_RTA(self)
    local class = 'Char1_18'
    local classIES = GetClass('Job', class)
    local jobCircle, jobRank = GetJobGradeByName(self, class);
    if jobCircle >= 1 then
        return 1
    end
    
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1803_NEWCLASS_MSG1","CLASS",classIES.Name), 5);
    return 0
end

function SCR_USE_EVENT_1803_NEWCLASS_BOX_RTA(self)
    local select = ShowSelDlg(self, 0, 'EVENT_1803_NEWCLASS_DLG1', ScpArgMsg('Yes'), ScpArgMsg('No'))
    if select == 1 then
        local item = 'EVENT_1803_NEWCLASS_BOX_RTA'
        local giveitem = 'costume_Char1_18_4'
        local itemIES = GetClass('Item', item)
        local giveitemIES = GetClass('Item', giveitem)
        local tx = TxBegin(self)
        TxGiveItem(tx, giveitem, 1, 'EVENT_1803_NEWCLASS_RTA')
        local ret = TxCommit(tx)
        if ret == 'SUCCESS' then
            SCR_SEND_NOTIFY_REWARD(self, itemIES.Name, giveitemIES.Name)
        end
    end
end



function SCR_PRE_EVENT_1803_NEWCLASS_BOX_OMJ(self)
    local class = 'Char2_20'
    local classIES = GetClass('Job', class)
    local jobCircle, jobRank = GetJobGradeByName(self, class);
    if jobCircle >= 1 then
        return 1
    end
    
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1803_NEWCLASS_MSG1","CLASS",classIES.Name), 5);
    return 0
end

function SCR_USE_EVENT_1803_NEWCLASS_BOX_OMJ(self)
    local select = ShowSelDlg(self, 0, 'EVENT_1803_NEWCLASS_DLG1', ScpArgMsg('Yes'), ScpArgMsg('No'))
    if select == 1 then
        local item = 'EVENT_1803_NEWCLASS_BOX_OMJ'
        local giveitem = 'costume_Char2_20_04'
        local itemIES = GetClass('Item', item)
        local giveitemIES = GetClass('Item', giveitem)
        local tx = TxBegin(self)
        TxGiveItem(tx, giveitem, 1, 'EVENT_1803_NEWCLASS_OMJ')
        local ret = TxCommit(tx)
        if ret == 'SUCCESS' then
            SCR_SEND_NOTIFY_REWARD(self, itemIES.Name, giveitemIES.Name)
        end
    end
end