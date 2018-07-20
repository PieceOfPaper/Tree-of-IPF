function SCR_EVENT_1805_WEDDING2_REWARD(cmd, curStage, eventInst, obj)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
		RunScript('SCR_EVENT_1805_WEDDING2_REWARD_SUB', list[i])
	end
end

function SCR_EVENT_1805_WEDDING2_REWARD_SUB(pc)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local wday = now_time['wday']
    local nowday = year..'/'..month..'/'..day
    
    local aObj = GetAccountObj(pc)
    if aObj ~= nil then
        if aObj.EVENT_1805_WEDDING2_REWARD_DATE ~= nowday or aObj.EVENT_1805_WEDDING2_REWARD_COUNT < 2 then
            local itemList = {{'Mic', 3, 500},
                                {'card_Xpupkit01_500_14d', 1, 750},
                                {'Ability_Point_Stone_500', 1, 1150},
                                {'Adventure_Reward_Seed', 1, 1000},
                                {'Moru_Silver', 1, 750},
                                {'misc_BlessedStone', 2, 1250},
                                {'Premium_Enchantchip14', 2, 750},
                                {'misc_gemExpStone_randomQuest4_14d', 1, 750},
                                {'Premium_dungeoncount_Event', 1, 1000},
                                {'Moru_Gold_14d', 1, 500},
                                {'Point_Stone_100', 1, 1350},
                                {'Ability_Point_Stone', 1, 250}
                }
                
            local maxRate = 0
            for i = 1, #itemList do
                maxRate = maxRate + itemList[i][3]
            end
            
            local rand1 = IMCRandom(1, maxRate)
            local targetIndex1 = 0
            local targetIndex2 = 0
            local accRate1 = 0
            
            for i = 1, #itemList do
                accRate1 = accRate1 + itemList[i][3]
                if rand1 <= accRate1 then
                    targetIndex1 = i
                    break
                end
            end
            
            if wday == 1 or wday == 7 or (month == 5 and day == 22) then
                local rand2 = IMCRandom(1, maxRate)
                local accRate2 = 0
                
                for i = 1, #itemList do
                    accRate2 = accRate2 + itemList[i][3]
                    if rand2 <= accRate2 then
                        targetIndex2 = i
                        break
                    end
                end
            end
            
            local tx = TxBegin(pc)
            local accCount = aObj.EVENT_1805_WEDDING2_ACC_COUNT + 1
            if aObj.EVENT_1805_WEDDING2_REWARD_DATE == nowday then
                TxSetIESProp(tx, aObj, 'EVENT_1805_WEDDING2_REWARD_COUNT', aObj.EVENT_1805_WEDDING2_REWARD_COUNT + 1)
            else
                TxSetIESProp(tx, aObj, 'EVENT_1805_WEDDING2_REWARD_DATE', nowday)
                TxSetIESProp(tx, aObj, 'EVENT_1805_WEDDING2_REWARD_COUNT', 1)
            end
            TxGiveItem(tx, itemList[targetIndex1][1], itemList[targetIndex1][2], 'EVENT_1805_WEDDING2');
            if targetIndex2 > 0 then
                TxGiveItem(tx, itemList[targetIndex2][1], itemList[targetIndex2][2], 'EVENT_1805_WEDDING2');
                accCount = accCount + 1
            end
            TxSetIESProp(tx, aObj, 'EVENT_1805_WEDDING2_ACC_COUNT', accCount)
            local ret = TxCommit(tx)
            if ret == 'SUCCESS' then
            end
        end
    end
end

function EVENT_1805_WEDDING2_INDUN_COUNT_SET(pc)
    local aObj = GetAccountObj(pc)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local nowday = year..'/'..month..'/'..day
    
    local pcEtc = GetETCObject(pc)
    local tx = TxBegin(pc)
    if aObj.EVENT_1805_WEDDING2_REWARD_DATE == nowday then
        if pcEtc.InDunCountType_8000 ~= aObj.EVENT_1805_WEDDING2_REWARD_COUNT then
            TxSetIESProp(tx, pcEtc, 'InDunCountType_8000', aObj.EVENT_1805_WEDDING2_REWARD_COUNT)
        end
    else
        if pcEtc.InDunCountType_8000 ~= 0 then
            TxSetIESProp(tx, pcEtc, 'InDunCountType_8000', 0)
        end
    end
    local ret = TxCommit(tx)
end

function SCR_EVENT_1805_WEDDING1_NPC_DIALOG(self, pc)
    EVENT_1805_WEDDING2_INDUN_COUNT_SET(pc)
    
    local aObj = GetAccountObj(pc)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local nowday = year..'/'..month..'/'..day
    
    local select = ShowSelDlg(pc, 0, 'EVENT_1805_WEDDING2_DLG1\\'..ScpArgMsg('EVENT_1805_WEDDING2_MSG1','COUNT',aObj.EVENT_1805_WEDDING2_ACC_COUNT), ScpArgMsg('EVENT_1804_ARBOR_MSG9'),ScpArgMsg('EVENT_1805_WEDDING2_MSG2'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
    if select == 1 then
        local partyObj = GetPartyObj(pc)
        if partyObj ~= nil then
            SendSysMsg(pc, 'CannotUseInParty')
            return
        end
        
        if aObj ~= nil then
            if aObj.EVENT_1805_WEDDING2_REWARD_DATE ~= nowday or aObj.EVENT_1805_WEDDING2_REWARD_COUNT < 2 then
                if pc.Lv >= 30 then
                    local missionID = OpenMissionRoom(pc, 'MISSION_EVENT_1805_WEDDING2', "");
                    ReqMoveToMission(pc, missionID)
                else
                    SendSysMsg(pc, 'NeedMorePcLevel')
                end
            else
                ShowOkDlg(pc, 'EVENT_1805_WEDDING2_DLG2', 1)
            end
        end
    elseif select == 2 then
        local item
        local saveReward = 0
        if aObj.EVENT_1805_WEDDING2_ACC_COUNT >= 5 and aObj.EVENT_1805_WEDDING2_ACC_REWARD < 5 then
            item = 'artefact_wedding04'
            saveReward = 5
        elseif aObj.EVENT_1805_WEDDING2_ACC_COUNT >= 20 and aObj.EVENT_1805_WEDDING2_ACC_REWARD < 20 then
            item = 'EVENT_1805_WEDDING2_COSTUME_BOX'
            saveReward = 20
        end
        if item ~= nil and saveReward > 0 then
            local tx = TxBegin(pc)
            TxGiveItem(tx, item, 1, 'EVENT_1805_WEDDING2');
            TxSetIESProp(tx, aObj, 'EVENT_1805_WEDDING2_ACC_REWARD', saveReward)
            local ret = TxCommit(tx)
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1805_WEDDING2_MSG3"), 10);
        end
    end
end

function GET_EVENT_1805_WEDDING2_LV_NORMAL(self, zoneObj, arg2, zone, layer)
	local maxLv = GetExProp(zoneObj, "MaxLv");
	local minLv = GetExProp(zoneObj, "MinLv");
	local aveLv = GetExProp(zoneObj, "AveLv");
	local pcCount = GetExProp(zoneObj, "PCCOUNT");
	return maxLv;
end

function GET_EVENT_1805_WEDDING2_MON_CHANGE(self, zoneObj, arg2, zone, layer)
    local now_time = os.date('*t')
    local hour = now_time['hour']
    local min = now_time['min']
    
    local minCount = hour*60 + min
    
    if minCount == 0 then
        minCount = 1
    end 
    
	local index = minCount % #UPHILL_NORMAL_LIST
	index = index + 1
	return UPHILL_NORMAL_LIST[index]
end

function SCR_USE_EVENT_1805_WEDDING2_COSTUME_BOX(pc)
    local select = ShowSelDlg(pc, 0, 'EVENT_1709_NEWFIELD_SEL', ScpArgMsg("OnlyMale"), ScpArgMsg("OnlyFemale"), ScpArgMsg("Cancel"))
    local itemSel
    if select == 1 then
        itemSel = 'costume_Com_102'
    elseif select == 2 then
        itemSel = 'costume_Com_103'
    end
    if itemSel ~= nil then
        local tx = TxBegin(pc);
        TxGiveItem(tx, itemSel, 1, "EVENT_1805_WEDDING2_COSTUME_BOX");
        local ret = TxCommit(tx);
    end
end