function SCR_EVENT_1806_NUMBER_GAMES_NPC_DIALOG(self, pc, gimmickName)
    local sObj = GetSessionObject(pc, "ssn_klapeda")
    local aObj = GetAccountObj(pc)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local nowDate = year..'/'..month..'/'..day
    
    local select = ShowSelDlg(pc, 0, 'EVENT_1806_NUMBER_GAMES_DLG1', ScpArgMsg('EVENT_1806_NUMBER_GAMES_MSG2'), ScpArgMsg('EVENT_1806_SOCCER_MSG6'), ScpArgMsg('EVENT_1806_SOCCER_MSG15'),ScpArgMsg('Auto_DaeHwa_JongLyo'))
    
    if select == 1 then
        if pc.Lv < 50 then
            ShowOkDlg(pc, 'EVENT_1806_NUMBER_GAMES_DLG1\\'..ScpArgMsg('EVENT_1801_ORB_MSG8','LV',50), 1)
            return
        end
        local accRewardMsg
        local accRewardList = {{5, 'Artefact_630010',1},{10, 'Gacha_HairAcc_001_event14d',2},{15, 'Premium_boostToken03_event01',1},{20, 'ABAND01_133',1}}
        local accIndex
        for i = 1, #accRewardList do
            if aObj.EVENT_1806_NUMBER_GAMES_ACC_COUNT >= accRewardList[i][1] and aObj.EVENT_1806_NUMBER_GAMES_ACC_REWARD < accRewardList[i][1] then
                accIndex = i
                accRewardMsg = ScpArgMsg('EVENT_1806_NUMBER_GAMES_MSG6')
                break
            end
        end
        
        local select2 = ShowSelDlg(pc, 0, 'EVENT_1806_NUMBER_GAMES_DLG1\\'..ScpArgMsg('EVENT_1806_NUMBER_GAMES_MSG10'), ScpArgMsg('EVENT_1806_NUMBER_GAMES_MSG5'), accRewardMsg, ScpArgMsg('Auto_DaeHwa_JongLyo'))
        
        if select2 == 1 then
            local takeItemCount = 4
            local maxCount = math.floor(GetInvItemCount(pc, 'EVENT_1806_NUMBER_GAMES_HINT')/takeItemCount)
            if maxCount <= 0 then
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_NUMBER_GAMES_MSG3"), 10);
                return
            end
            if aObj.EVENT_1806_NUMBER_GAMES_NUMBER == 0 and aObj.EVENT_1806_NUMBER_GAMES_DATE ~= nowDate then
                local tx = TxBegin(pc);
                TxSetIESProp(tx, aObj, 'EVENT_1806_NUMBER_GAMES_DATE', nowDate)
                TxSetIESProp(tx, aObj, 'EVENT_1806_NUMBER_GAMES_NUMBER', IMCRandom(1, 100))
               	local ret = TxCommit(tx);
            
            	if ret ~= "SUCCESS" then
            	    return
            	end
            elseif aObj.EVENT_1806_NUMBER_GAMES_NUMBER == 0 and aObj.EVENT_1806_NUMBER_GAMES_DATE == nowDate then
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1705_CORSAIR_MSG4"), 10);
                return
            end
            
            local count = 0
            local value = aObj.EVENT_1806_NUMBER_GAMES_NUMBER
            local txt
            local input
            local dlgNPC = 'EVENT_1806_NUMBER_GAMES_DLG1\\'
            
            local result
            
            while 1 do
                maxCount = math.floor(GetInvItemCount(pc, 'EVENT_1806_NUMBER_GAMES_HINT')/takeItemCount)
                if maxCount <= 0 then
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_NUMBER_GAMES_MSG3"), 10);
                    return
                end
                
                txt = dlgNPC..ScpArgMsg("EVENT_1806_NUMBER_GAMES_MSG4")
                input = nil
                while 1 do
                    input = ShowTextInputDlg(pc, 0, txt)
                    if input == nil then
                        return
                    end
                    if tonumber(input) ~= nil then
                        input = math.floor(tonumber(input))
                        break
                    else
                        ShowOkDlg(pc, dlgNPC..ScpArgMsg("NUMBER_HI_LOW_ERROR1"), 1)
                    end
                end
                
                
                
                if input ~= nil then
                    if input == value then
                        local itemList = {{'Adventure_Reward_Seed', 1, 1250},
                                            {'food_022', 2, 1000},
                                            {'ChallengeModeReset_14d', 1, 1000},
                                            {'EVENT_1712_SECOND_CHALLENG_14d', 1, 1000},
                                            {'Premium_Enchantchip14', 1, 500},
                                            {'Premium_boostToken_14d', 1, 1050},
                                            {'Premium_WarpScroll', 5, 1000},
                                            {'Event_drug_steam_1h_DLC', 3, 1000},
                                            {'Point_Stone_100', 3, 1200},
                                            {'misc_BlessedStone', 2, 500},
                                            {'Moru_Gold_14d', 1, 500}
                                            }
                        local maxRate = 0
                        for i = 1, #itemList do
                            maxRate = maxRate + itemList[i][3]
                        end
                        
                        local rand = IMCRandom(1, maxRate)
                        local targetIndex = 0
                        local accRate = 0
                        
                        for i = 1, #itemList do
                            accRate = accRate + itemList[i][3]
                            if rand <= accRate then
                                targetIndex = i
                                break
                            end
                        end
                        local tx = TxBegin(pc);
                    	TxGiveItem(tx, itemList[targetIndex][1], itemList[targetIndex][2], 'EVENT_1806_NUMBER_GAMES');
                        TxTakeItem(tx, 'EVENT_1806_NUMBER_GAMES_HINT', 4, 'EVENT_1806_NUMBER_GAMES')
                        TxSetIESProp(tx, aObj, 'EVENT_1806_NUMBER_GAMES_NUMBER', 0)
                        TxSetIESProp(tx, aObj, 'EVENT_1806_NUMBER_GAMES_ACC_COUNT', aObj.EVENT_1806_NUMBER_GAMES_ACC_COUNT + 1)
                    	local ret = TxCommit(tx);
                    	
                    	if ret == 'SUCCESS' then
                    	    ShowOkDlg(pc, dlgNPC..ScpArgMsg("EVENT_1806_NUMBER_GAMES_MSG11", "NUM",input), 1)
                	        SCR_SEND_NOTIFY_REWARD(pc, ScpArgMsg('EVENT_1806_NUMBER_GAMES_MSG2'), ScpArgMsg('LVUP_REWARD_MSG1','ITEM', GetClassString('Item', itemList[targetIndex][1],'Name'),'COUNT', GET_COMMA_SEPARATED_STRING(itemList[targetIndex][2])))
                    	end
                    	return
                    else
                        local tx = TxBegin(pc);
                        TxTakeItem(tx, 'EVENT_1806_NUMBER_GAMES_HINT', 4, 'EVENT_1806_NUMBER_GAMES')
                       	local ret = TxCommit(tx);
                        if input < value then
                            ShowOkDlg(pc, dlgNPC..ScpArgMsg("NUMBER_HI_LOW_RESULT1", "INPUT",input), 1)
                        elseif input > value then
                            ShowOkDlg(pc, dlgNPC..ScpArgMsg("NUMBER_HI_LOW_RESULT2", "INPUT",input), 1)
                        end
                    end
                end
            end
        elseif select2 == 2 then
            local rewardItemIES = GetClass('Item',accRewardList[accIndex][2])
            local addmsg = ''
            if rewardItemIES.TeamTrade ~= 'YES' then
                addmsg = ScpArgMsg('EVENT_1806_NUMBER_GAMES_MSG8')
            end
            local select3 = ShowSelDlg(pc, 0, 'EVENT_1806_NUMBER_GAMES_DLG1\\'..ScpArgMsg('EVENT_1806_NUMBER_GAMES_MSG7','ACC', aObj.EVENT_1806_NUMBER_GAMES_ACC_COUNT,'TARGET', accRewardList[accIndex][1],'ITEM', rewardItemIES.Name)..addmsg, ScpArgMsg('EVENT_1806_NUMBER_GAMES_MSG9'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
            if select3 == 1 then
                local tx = TxBegin(pc);
            	TxGiveItem(tx, accRewardList[accIndex][2], accRewardList[accIndex][3], 'EVENT_1806_NUMBER_GAMES');
                TxSetIESProp(tx, aObj, 'EVENT_1806_NUMBER_GAMES_ACC_REWARD', accRewardList[accIndex][1])
            	local ret = TxCommit(tx);
            end
        end
    elseif select == 2 then
        SCR_EVENT_1806_SOCCER_NPC_START(self, pc)
    elseif select == 3 then
        SCR_EVENT_1806_SOCCER_NPC_RANK(self, pc)
    end
end


function SCR_EVENT_1806_NUMBER_GAMES_DROP(self, sObj, msg, argObj, argStr, argNum)
    if IMCRandom(1, 100) <= 9 then
        if EVENT_1806_NUMBER_GAMES_NOW_TIME() == 'YES' then
            local curMap = GetZoneName(self);
            local mapCls = GetClass("Map", curMap);
            
            if self.Lv >= 50 and mapCls.WorldMap ~= 'None' and mapCls.MapType ~= 'City' and IsPlayingDirection(self) ~= 1 and IsIndun(self) ~= 1 and IsPVPServer(self) ~= 1 and IsMissionInst(self) ~= 1 then
                if self.Lv - 30 <= argObj.Lv and self.Lv + 30 >= argObj.Lv then
                    RunScript('GIVE_ITEM_TX',self, 'EVENT_1806_NUMBER_GAMES_HINT', 1, 'EVENT_1806_NUMBER_GAMES')
                end
            end
        end
    end
end

function EVENT_1806_NUMBER_GAMES_NOW_TIME()
    local now_time = os.date('*t')
    local month = now_time['month']
    local year = now_time['year']
    local day = now_time['day']

    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
    local index = 0
    
    if nowbasicyday <= SCR_DATE_TO_YDAY_BASIC_2000(2018, 7, 12) then
        return 'YES'
    end
    
    return 'NO'
end

