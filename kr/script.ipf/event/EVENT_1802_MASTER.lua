function SCR_EVENT_1802_MASTER_IN_NPC1_DIALOG(self, pc)
    local cmd = GetMGameCmd(pc)
    local propName = 'BOSSGEN1'
    local curVal = cmd:GetUserValue(propName);
    if curVal == 1 then
        local select = ShowSelDlg(pc, 0, 'EVENT_1802_MASTER_IN_NPC1_DLG1', ScpArgMsg("EVENT_1802_MASTER_MSG1"), ScpArgMsg("Cancel"))
        if select == 1 then
            cmd:SetUserValue(propName, 2);
        end
    elseif curVal == 2 then
        ShowOkDlg(pc, 'EVENT_1802_MASTER_IN_NPC1_DLG2', 1)
    elseif curVal == 3 then
        ShowOkDlg(pc, 'EVENT_1802_MASTER_IN_NPC1_DLG3', 1)
    end
end

function SCR_EVENT_1802_MASTER_IN_NPC2_DIALOG(self, pc)
    local cmd = GetMGameCmd(pc)
    local propName = 'BOSSGEN2'
    local curVal = cmd:GetUserValue(propName);
    
    local checkVal = cmd:GetUserValue('BOSSGEN1');
    
    if checkVal ~= 3 then
        ShowOkDlg(pc, 'EVENT_1802_MASTER_IN_NPC2_DLG4', 1)
    else
        if curVal == 1 then
            local select = ShowSelDlg(pc, 0, 'EVENT_1802_MASTER_IN_NPC2_DLG1', ScpArgMsg("EVENT_1802_MASTER_MSG1"), ScpArgMsg("Cancel"))
            if select == 1 then
                cmd:SetUserValue(propName, 2);
            end
        elseif curVal == 2 then
            ShowOkDlg(pc, 'EVENT_1802_MASTER_IN_NPC2_DLG2', 1)
        elseif curVal == 3 then
            ShowOkDlg(pc, 'EVENT_1802_MASTER_IN_NPC2_DLG3', 1)
        end
    end
end

function SCR_EVENT_1802_MASTER_IN_NPC3_DIALOG(self, pc)
    local cmd = GetMGameCmd(pc)
    local propName = 'BOSSGEN3'
    local curVal = cmd:GetUserValue(propName);
    
    local checkVal = cmd:GetUserValue('BOSSGEN2');
    
    if checkVal ~= 3 then
        ShowOkDlg(pc, 'EVENT_1802_MASTER_IN_NPC3_DLG4', 1)
    else
        if curVal == 1 then
            local select = ShowSelDlg(pc, 0, 'EVENT_1802_MASTER_IN_NPC3_DLG1', ScpArgMsg("EVENT_1802_MASTER_MSG1"), ScpArgMsg("Cancel"))
            if select == 1 then
                cmd:SetUserValue(propName, 2);
            end
        elseif curVal == 2 then
            ShowOkDlg(pc, 'EVENT_1802_MASTER_IN_NPC3_DLG2', 1)
        elseif curVal == 3 then
            ShowOkDlg(pc, 'EVENT_1802_MASTER_IN_NPC3_DLG3', 1)
        end
    end
end

function SCR_EVENT_1802_MASTER_MISSION_STEP()
    local now_time = os.date('*t')
    local month = now_time['month']
    local year = now_time['year']
    local day = now_time['day']
    local wday = now_time['wday']
    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
    
    if nowbasicyday >= SCR_DATE_TO_YDAY_BASIC_2000(2018, 3, 15) then
        return 4
    elseif nowbasicyday >= SCR_DATE_TO_YDAY_BASIC_2000(2018, 3, 8) then
        return 3
    elseif nowbasicyday >= SCR_DATE_TO_YDAY_BASIC_2000(2018, 3, 1) then
        return 2
    end
    return 1
end


function SCR_EVENT_1802_MASTER_NPC_DIALOG(self,pc)
    local select = ShowSelDlg(pc, 0, 'EVENT_1802_MASTER_NPC_DLG1', ScpArgMsg('EVENT_1802_MASTER_MSG8'), ScpArgMsg("Cancel"))
    if select == 1 then
        local pieceCount = GetInvItemCount(pc, 'EVENT_1802_MASTER_REWARD_PIECE')
        if pieceCount < 5 then
            ShowOkDlg(pc, 'EVENT_1802_MASTER_NPC_DLG5', 1)
            return
        end
        local cubeCount = math.floor(pieceCount/5)
        if cubeCount > 0 then
            local tx = TxBegin(pc)
            TxTakeItem(tx, 'EVENT_1802_MASTER_REWARD_PIECE', cubeCount*5, 'EVENT_1802_MASTER')
            TxGiveItem(tx, 'EVENT_1802_MASTER_REWARD_CUBE', cubeCount, 'EVENT_1802_MASTER');
        	local ret = TxCommit(tx)
        end
    end
    
--    if pc.Lv < 100 then
--        SendAddOnMsg(pc, 'NOTICE_Dm_scroll',ScpArgMsg('EVENT_1801_ORB_MSG8','LV',100), 10)
--        return
--    end
--    
--    local aObj = GetAccountObj(pc)
--    local now_time = os.date('*t')
--    local month = now_time['month']
--    local year = now_time['year']
--    local day = now_time['day']
--    local wday = now_time['wday']
--    
--    local keyExchange
--    if SCR_EVENT_1802_MASTER_MISSION_STEP() >= 2 then
--        keyExchange = ScpArgMsg("EVENT_1802_MASTER_MSG9")
--    end
--    
--    local select = ShowSelDlg(pc, 0, 'EVENT_1802_MASTER_NPC_DLG1', ScpArgMsg("EVENT_1802_MASTER_MSG3"), ScpArgMsg('EVENT_1802_MASTER_MSG2'), ScpArgMsg('EVENT_1802_MASTER_MSG8'), keyExchange, ScpArgMsg("Cancel"))
--    
--    if select == 1 then
--        local sel1,sel2,sel3,sel4
--        sel1 = ScpArgMsg("EVENT_1802_MASTER_MSG4")
--        if SCR_EVENT_1802_MASTER_MISSION_STEP() >= 2 then
--            sel2 = ScpArgMsg("EVENT_1802_MASTER_MSG5")
--        end
--        if SCR_EVENT_1802_MASTER_MISSION_STEP() >= 3 then
--            sel3 = ScpArgMsg("EVENT_1802_MASTER_MSG6")
--        end
--        if SCR_EVENT_1802_MASTER_MISSION_STEP() >= 4 then
--            sel4 = ScpArgMsg("EVENT_1802_MASTER_MSG7")
--        end
----        if sel2 == nil and sel3 == nil and sel4 == nil then
----            print('GHGGGGGGGGGGGGGGG')
----            REQ_MOVE_TO_INDUN(pc, "EVENT_1802_MASTER_MISSION1", 1)
----            return
----        end
--        if pc.Lv < 100 then
--            ShowOkDlg(pc, 'EVENT_1802_MASTER_NPC_DLG9', 1)
--            return
--        end
--        local select2 = ShowSelDlg(pc, 0, 'EVENT_1802_MASTER_NPC_DLG2', sel1, sel2, sel3, sel4 , ScpArgMsg("Cancel"))
--        
--        local curCount = GetInvItemCount(pc, 'EVENT_1802_MASTER_KEY'..select2)
--        if curCount < 1 then
--            ShowOkDlg(pc, 'EVENT_1802_MASTER_NPC_DLG3', 1)
--            return
--        end
--        if select2 == 1 and sel1 ~= nil then
--            local missionID = OpenMissionRoom(pc, 'EVENT_1802_MASTER_MISSION1', "");
--            ReqMoveToMission(pc, missionID)
----            REQ_MOVE_TO_INDUN(pc, "EVENT_1802_MASTER_MISSION1", 1)
--        elseif select2 == 2 and sel2 ~= nil then
--            local missionID = OpenMissionRoom(pc, 'EVENT_1802_MASTER_MISSION2', "");
--            ReqMoveToMission(pc, missionID)
----            REQ_MOVE_TO_INDUN(pc, "EVENT_1802_MASTER_MISSION2", 1)
--        elseif select2 == 3 and sel3 ~= nil then
--            local missionID = OpenMissionRoom(pc, 'EVENT_1802_MASTER_MISSION3', "");
--            ReqMoveToMission(pc, missionID)
----            REQ_MOVE_TO_INDUN(pc, "EVENT_1802_MASTER_MISSION3", 1)
--        elseif select2 == 4 and sel4 ~= nil then
--            local missionID = OpenMissionRoom(pc, 'EVENT_1802_MASTER_MISSION4', "");
--            ReqMoveToMission(pc, missionID)
----            REQ_MOVE_TO_INDUN(pc, "EVENT_1802_MASTER_MISSION4", 1)
--        end
--    elseif select == 2 then
--        local nowDate = year..'/'..month..'/'..day
--        if aObj.EVENT_1802_MASTER_GIVE_DATE ~= nowDate then
--            local step = SCR_EVENT_1802_MASTER_MISSION_STEP()
--            local giveItem = 'EVENT_1802_MASTER_KEY1'
--            if step == 2 then
--                giveItem = 'EVENT_1802_MASTER_KEY2'
--            elseif step == 3 then
--                giveItem = 'EVENT_1802_MASTER_KEY3'
--            elseif step == 4 then
--                giveItem = 'EVENT_1802_MASTER_KEY4'
--            end
--            local tx = TxBegin(pc)
--            TxSetIESProp(tx, aObj, 'EVENT_1802_MASTER_GIVE_DATE', nowDate);
--            TxGiveItem(tx, giveItem, 3, 'EVENT_1802_MASTER');
--        	local ret = TxCommit(tx)
--        else
--            ShowOkDlg(pc, 'EVENT_1802_MASTER_NPC_DLG4', 1)
--        end
--    elseif select == 3 then
--        local pieceCount = GetInvItemCount(pc, 'EVENT_1802_MASTER_REWARD_PIECE')
--        if pieceCount < 5 then
--            ShowOkDlg(pc, 'EVENT_1802_MASTER_NPC_DLG5', 1)
--            return
--        end
--        local cubeCount = math.floor(pieceCount/5)
--        if cubeCount > 0 then
--            local tx = TxBegin(pc)
--            TxTakeItem(tx, 'EVENT_1802_MASTER_REWARD_PIECE', cubeCount*5, 'EVENT_1802_MASTER')
--            TxGiveItem(tx, 'EVENT_1802_MASTER_REWARD_CUBE', cubeCount, 'EVENT_1802_MASTER');
--        	local ret = TxCommit(tx)
--        end
--    elseif select == 4 then
--        local select3 = ShowSelDlg(pc, 0, 'EVENT_1802_MASTER_NPC_DLG6', ScpArgMsg("EVENT_1802_MASTER_MSG5"), ScpArgMsg("EVENT_1802_MASTER_MSG6"), ScpArgMsg("EVENT_1802_MASTER_MSG7"), ScpArgMsg("Cancel"))
--        local input = ShowTextInputDlg(pc, 0, 'EVENT_1802_MASTER_NPC_DLG7')
--        input = tonumber(input)
--        if input ~= nil then
--            if select3 == 1 then
--                local inputItemCount = GetInvItemCount(pc, 'EVENT_1802_MASTER_KEY2')
--                if inputItemCount >= input then
--                    local tx = TxBegin(pc)
--                    TxTakeItem(tx, 'EVENT_1802_MASTER_KEY2', input, 'EVENT_1802_MASTER_EXCHANG')
--                    TxGiveItem(tx, 'EVENT_1802_MASTER_KEY1', input, 'EVENT_1802_MASTER_EXCHANG');
--                	local ret = TxCommit(tx)
--                else
--                    ShowOkDlg(pc, 'EVENT_1802_MASTER_NPC_DLG8', 1)
--                end
--            elseif select3 == 2 then
--                local inputItemCount = GetInvItemCount(pc, 'EVENT_1802_MASTER_KEY3')
--                if inputItemCount >= input then
--                    local tx = TxBegin(pc)
--                    TxTakeItem(tx, 'EVENT_1802_MASTER_KEY3', input, 'EVENT_1802_MASTER_EXCHANG')
--                    TxGiveItem(tx, 'EVENT_1802_MASTER_KEY2', input, 'EVENT_1802_MASTER_EXCHANG');
--                	local ret = TxCommit(tx)
--                else
--                    ShowOkDlg(pc, 'EVENT_1802_MASTER_NPC_DLG8', 1)
--                end
--            elseif select3 == 3 then
--                local inputItemCount = GetInvItemCount(pc, 'EVENT_1802_MASTER_KEY4')
--                if inputItemCount >= input then
--                    local tx = TxBegin(pc)
--                    TxTakeItem(tx, 'EVENT_1802_MASTER_KEY4', input, 'EVENT_1802_MASTER_EXCHANG')
--                    TxGiveItem(tx, 'EVENT_1802_MASTER_KEY3', input, 'EVENT_1802_MASTER_EXCHANG');
--                	local ret = TxCommit(tx)
--                else
--                    ShowOkDlg(pc, 'EVENT_1802_MASTER_NPC_DLG8', 1)
--                end
--            end
--        end
--    end
end


function SCR_USE_EVENT_1802_MASTER_REWARD_CUBE(pc)
    local itemList = {{'Moru_Diamond_14d', 1,150},
                        {'Mic_bundle50', 1,150},
                        {'RestartCristal_bundle10', 1,150},
                        {'Moru_Gold_14d', 1,150},
                        {'Premium_item_transcendence_Stone', 1,200},
                        {'Ability_Point_Stone', 1,400},
                        {'misc_BlessedStone', 1,500},
                        {'ChallengeModeReset_14d', 1,500},
                        {'EVENT_1712_SECOND_CHALLENG_14d', 1,500},
                        {'Moru_Silver', 1,500},
                        {'Event_Reinforce_100000coupon', 1,500},
                        {'misc_gemExpStone_randomQuest4_14d', 1,650},
                        {'Premium_Enchantchip14', 1,650},
                        {'Event_Select_Acc_Box', 1,1000},
                        {'Ability_Point_Stone_500', 1,1000},
                        {'Event_Goddess_Statue', 1,1000},
                        {'Point_Stone_100', 1,2000}
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
	TxGiveItem(tx, itemList[targetIndex][1], itemList[targetIndex][2], 'EVENT_1802_MASTER_CUBE');
	local ret = TxCommit(tx);
	
	if ret == 'SUCCESS' then
	    SCR_SEND_NOTIFY_REWARD(pc, GetClassString('Item','EVENT_1802_MASTER_REWARD_CUBE','Name'), ScpArgMsg('LVUP_REWARD_MSG1','ITEM', GetClassString('Item', itemList[targetIndex][1],'Name'),'COUNT', itemList[targetIndex][2]))
	end
end