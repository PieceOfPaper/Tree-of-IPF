--function EVENT_1805_GUILD_DAY_MIC_REWARD(pc)
--    local now_time = os.date('*t')
--    local year = now_time['year']
--    local month = now_time['month']
--    local day = now_time['day']
--    local nowDate = year..'/'..month..'/'..day
--    local aObj = GetAccountObj(pc)
--    
--    if aObj.EVENT_1805_GUILD_DAY_MIC_REWARD_DATE ~= nowDate then
--        local tx = TxBegin(pc)
--        TxSetIESProp(tx, aObj, 'EVENT_1805_GUILD_DAY_MIC_REWARD_DATE', nowDate)
--        TxGiveItem(tx, 'Mic', 5, 'EVENT_1805_GUILD_DAY_MIC')
--        local ret = TxCommit(tx)
--    end
--end

function SCR_USE_EVENT_1805_GUILD_CARD_LV4(self,argObj,argstr,arg1,arg2)
    local guildObj = GetGuildObj(self);
    if guildObj ~= nil then
    	local guildIES = GetClass("GuildExp", 4);
    	
    	local tx = TxBegin(self);
    	TxSetPartyProp(tx, PARTY_GUILD, "Exp", guildIES.Exp);
    	TxSetPartyProp(tx, PARTY_GUILD, "Level", 4);
       	local ret = TxCommit(tx);
    
    	if ret == "SUCCESS" then
    	    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1805_GUILD_MSG3"), 10);
    	end
    end
end

function SCR_PRE_EVENT_1805_GUILD_CARD_LV4(self,argstr,arg1,arg2)
    local guildObj = GetGuildObj(self);
    if guildObj == nil then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1805_GUILD_MSG1"), 10);
        return 0
    end
    local curLevel = guildObj.Level
    
    if curLevel > 1 then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1805_GUILD_MSG2"), 10);
        return 0
    end
    
    return 1
end


--function EVENT_1805_GUILD_ABILITY(self,pc,aObj)
--    local guildObj = GetGuildObj(pc);
--    if guildObj ~= nil then
--        local now_time = os.date('*t')
--        local year = now_time['year']
--        local month = now_time['month']
--        local day = now_time['day']
--        local nowDate = year..'/'..month..'/'..day
--        
--        local lastRewardWeek = 0
--        if aObj.EVENT_1805_GUILD_WEEK_REWARD_DATE == 'None' then
--            lastRewardWeek = 1
--        else
--            local lastDate = SCR_STRING_CUT(aObj.EVENT_1805_GUILD_WEEK_REWARD_DATE)
--            lastRewardWeek = SCR_DATE_TO_YWEEK_BASIC_2000(lastDate[1],lastDate[2],lastDate[3],5)
--        end
--        if lastRewardWeek ~= SCR_DATE_TO_YWEEK_BASIC_2000(year,month,day,5) then
--            local itemName = 'Ability_Point_Stone_500'
--            if aObj.EVENT_1805_GUILD_WEEK_REWARD_COUNT == 0 then
--                itemName = 'Ability_Point_Stone'
--            end
--            
--            local tx = TxBegin(pc)
--            TxSetIESProp(tx, aObj, 'EVENT_1805_GUILD_WEEK_REWARD_COUNT', aObj.EVENT_1805_GUILD_WEEK_REWARD_COUNT+1)
--            TxSetIESProp(tx, aObj, 'EVENT_1805_GUILD_WEEK_REWARD_DATE', nowDate)
--            TxGiveItem(tx, itemName, 1, 'EVENT_1805_GUILD_WEEK')
--            local ret = TxCommit(tx)
--        else
--            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1805_GUILD_MSG5"), 10);
--        end
--    else
--        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1805_GUILD_MSG4"), 10);
--    end
--end


function SCR_USE_EVENT_1805_GUILD_QUEST_MEDAL(self,argObj,argstr,arg1,arg2)
    AddBuff(self, self, 'EVENT_1805_GUILD_QUEST_BUFF', 1, 0, 1800000, 1);
end



function SCR_BUFF_ENTER_EVENT_1805_GUILD_QUEST_BUFF(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 1
    self.LootingChance_BM = self.LootingChance_BM + 200;
end
function SCR_BUFF_UPDATE_EVENT_1805_GUILD_QUEST_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end
function SCR_BUFF_LEAVE_EVENT_1805_GUILD_QUEST_BUFF(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 1
    self.LootingChance_BM = self.LootingChance_BM - 200;
end

--function EVENT_1805_GUILD_QUEST_SUCCESS_REWARD(pc)
--    local pcList, pcCount = GetLayerPCList(GetZoneInstID(pc), GetLayer(pc))
--    if pcCount > 0 then
--        local pcGuildObj = GetGuildObj(pc)
--        for i = 1, pcCount do
--            local guildPC = pcList[i]
--            if guildPC ~= nil then
--                local quildPCaObj = GetAccountObj(guildPC)
--                local quildPCGuildObj = GetGuildObj(guildPC)
--                if quildPCGuildObj ~= nil and IsSameObject(pcGuildObj, quildPCGuildObj) == 1 then
--                    if quildPCaObj ~= nil then
--                        local giveItemList = {{1,'Get_Wet_Card_Book',2},{5,'EVENT_1805_GUILD_QUEST_MEDAL',10},{10,'EVENT_1805_GUILD_QUEST_ACHIEVE_BOX',2}}
--                        local rewardIndex = 0
--                        for i2 = 1, #giveItemList do
--                            if quildPCaObj.EVENT_1805_GUILD_QUEST_SUCCESS_COUNT + 1 == giveItemList[i2][1] then
--                                rewardIndex = i2
--                            end
--                        end
--                        local tx = TxBegin(guildPC)
--                        TxSetIESProp(tx, quildPCaObj, 'EVENT_1805_GUILD_QUEST_SUCCESS_COUNT', quildPCaObj.EVENT_1805_GUILD_QUEST_SUCCESS_COUNT + 1)
--                        if rewardIndex > 0 then
--                            TxGiveItem(tx, giveItemList[rewardIndex][2], giveItemList[rewardIndex][3], 'EVENT_1805_GUILD_QUEST')
--                        end
--                        local ret = TxCommit(tx)
--                    end
--                end
--            end
--        end
--    end
--end
