--function SCR_EVENT_1805_NEWUSER_NPC_DIALOG(self, pc)
--    local aObj = GetAccountObj(pc)
--    local select = ShowSelDlg(pc, 0, 'EVENT_1805_NEWUSER_DLG1', ScpArgMsg('EVENT_1805_NEWUSER_MSG4'), ScpArgMsg('EVENT_1805_NEWUSER_MSG5'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
--    if select == 1 then
--        if aObj.EVENT_1805_NEWUSER_REWARD_COUNT > 0 then
--            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1805_NEWUSER_MSG2"), 10);
--            return
--        end
--        
--        if aObj.ExistingUserFlag == 1 then
--            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1805_NEWUSER_MSG3"), 10);
--            return
--        end
--        local tx = TxBegin(pc)
--        TxSetIESProp(tx, aObj, 'EVENT_1805_NEWUSER_REWARD_COUNT', aObj.EVENT_1805_NEWUSER_REWARD_COUNT+1)
--        TxGiveItem(tx, 'EVENT_1805_NEWUSER_MEDAL', 1, 'EVENT_1805_NEWUSER')
--        TxGiveItem(tx, 'EVENT_1805_NEWUSER_ACHIEVE_BOX', 4, 'EVENT_1805_NEWUSER')
--        TxGiveItem(tx, 'Mic', 20, 'EVENT_1805_NEWUSER')
--        local ret = TxCommit(tx)
--        
--        if ret == 'SUCCESS' then
--            ShowOkDlg(pc, 'EVENT_1805_NEWUSER_DLG2', 1)
--        end
--    elseif select == 2 then
--        EVENT_1805_GUILD_ABILITY(self,pc,aObj)
--    end
--end

--function SCR_SSN_KLAPEDA_EVENT_1805_NEWUSER(self, sObj, msg, argObj, argStr, argNum)
--    if IsBuffApplied(self, 'EVENT_1805_NEWUSER_BUFF_1') == 'YES' then
--        RemoveBuff(self, 'EVENT_1805_NEWUSER_BUFF_1')
--    end
--    if IsBuffApplied(self, 'EVENT_1805_NEWUSER_BUFF_2') == 'YES' then
--        RemoveBuff(self, 'EVENT_1805_NEWUSER_BUFF_2')
--    end
--end

function SCR_BUFF_ENTER_EVENT_1805_NEWUSER_BUFF_1(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 2
end
function SCR_BUFF_UPDATE_EVENT_1805_NEWUSER_BUFF_1(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end
function SCR_BUFF_LEAVE_EVENT_1805_NEWUSER_BUFF_1(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 2
end

function SCR_BUFF_ENTER_EVENT_1805_NEWUSER_BUFF_2(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 2
end
function SCR_BUFF_UPDATE_EVENT_1805_NEWUSER_BUFF_2(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end
function SCR_BUFF_LEAVE_EVENT_1805_NEWUSER_BUFF_2(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 2
end

--function SCR_USE_EVENT_1805_NEWUSER_MEDAL(self,argObj,argstr,arg1,arg2)
--	local range = 300;
--	local list, cnt = GetPartyMemberList(self, PARTY_NORMAL, range);
--    local buffName = 'EVENT_1805_NEWUSER_BUFF_1'
--    
--    if cnt > 0 then
--        if cnt >= 3 then
--            buffName = 'EVENT_1805_NEWUSER_BUFF_2'
--        end
--    	for i = 1, cnt do
--    	    AddBuff(self, list[i], buffName, 1, 0, 1800000, 1);
--    	end
--    end
--end
--
--function SCR_PRE_EVENT_1805_NEWUSER_MEDAL(self,argstr,arg1,arg2)
--    local achive = GetEquipAchieveName(self);
--    local partyObj = GetPartyObj(self)
--    
--    if achive == "EVENT_1805_NEWUSER_ACHIEVE" and partyObj ~= nil then
--        return 1
--    else
--        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1805_NEWUSER_MSG1"), 10);
--    end
--    
--    return 0
--end
