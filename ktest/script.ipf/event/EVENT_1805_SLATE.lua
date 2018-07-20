function SCR_SSN_KLAPEDA_EVENT_1805_SLATE(self, sObj, remainTime)
    local shovelFlag = GetExProp(self,'EVENT_1805_SLATE_SHOVEL')
    if shovelFlag == 1 then
        return
    end
    local eventPosList = EVENT_1805_SLATE_POS_LIST()
    if eventPosList ~= nil and #eventPosList > 0 then
        local aObj = GetAccountObj(self);
	    if aObj.EVENT_1805_SLATE_START_STATE == 1 then
	        local targetList = SCR_STRING_CUT(aObj.EVENT_1805_SLATE_START_TARGET_LIST)
	        local targetIndex = tonumber(targetList[#targetList])
	        if eventPosList[targetIndex][1] == GetZoneName(self) then
                local posx, posy, posz = GetPos(self)
                if SCR_POINT_DISTANCE(posx, posz, eventPosList[targetIndex][2], eventPosList[targetIndex][4]) <= 80 then
                    RunScript("SCR_SSN_KLAPEDA_EVENT_1805_SLATE_RUN", self, targetIndex)
                end
            end
	    end
    end
end

function SCR_SSN_KLAPEDA_EVENT_1805_SLATE_RUN(pc, targetIndex)
    SetExProp(pc,'EVENT_1805_SLATE_SHOVEL', 1)
    local select = ShowSelDlg(pc, 0, 'EVENT_1805_SLATE_DLG7', ScpArgMsg('EVENT_1805_SLATE_MSG5'), ScpArgMsg('Auto_JongLyo'))
    if select == 1 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_TamSaeg_Jung"), 'SKL_ASSISTATTACK_SHOVEL', 2)
        if result == 1 then
            local aObj = GetAccountObj(pc);
            local tx = TxBegin(pc)
            TxSetIESProp(tx, aObj, 'EVENT_1805_SLATE_START_STATE', 200)
            local ret = TxCommit(tx)
            if ret == 'SUCCESS' then
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1805_SLATE_MSG6"), 5);
                local sObj = GetSessionObject(pc, 'ssn_klapeda')
                SetTimeSessionObject(pc, sObj, 2, 1000, 'None','YES')
            end
        end
    end
    sleep(5000)
    SetExProp(pc,'EVENT_1805_SLATE_SHOVEL', 0)
end


function EVENT_1805_SLATE_LIST()
    local slateList = {'G','I','L','T','I','N','E','F','O','R','E','V','E','R'}
    return slateList
end
function EVENT_1805_SLATE_HINT_LIST()
    local hintList = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28}
    return hintList
end
function SCR_JOURNEY_SHOP_NORMAL_11(self, pc)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local nowDate = year..'/'..month..'/'..day
    
    local aObj = GetAccountObj(pc)
    local targetList = SCR_STRING_CUT(aObj.EVENT_1805_SLATE_START_TARGET_LIST)
    local targetSlateList = SCR_STRING_CUT(aObj.EVENT_1805_SLATE_START_SLATE_LIST)
    local hintList = EVENT_1805_SLATE_HINT_LIST()
    local slateList = EVENT_1805_SLATE_LIST()
    
    local accReward
    if (#targetList >= 15 or (#targetList >= 14 and aObj.EVENT_1805_SLATE_START_STATE == 0 )) and aObj.EVENT_1805_SLATE_ACC_REWARD == 0 then
        accReward = ScpArgMsg('EVENT_1805_SLATE_MSG4')
    end
    
    local select = ShowSelDlg(pc, 0, 'EVENT_1805_SLATE_DLG1', ScpArgMsg('EVENT_1805_SLATE_MSG1'), accReward, ScpArgMsg('Auto_DaeHwa_JongLyo'))
    
    if select == 1 then
        if aObj.EVENT_1805_SLATE_START_STATE == 0 and #targetList == 28 then
            ShowOkDlg(pc, 'EVENT_1805_SLATE_DLG6', 1)
        elseif aObj.EVENT_1805_SLATE_START_STATE == 1 then
            local index = targetList[#targetList]
            ShowOkDlg(pc, 'EVENT_1805_SLATE_DLG8', 1)
            ShowOkDlg(pc, 'EVENT_1805_SLATE_DLG2\\'..ScpArgMsg('EVENT_1805_SLATE_HINT'..index), 1)
        elseif aObj.EVENT_1805_SLATE_START_STATE == 200 then
            local tx = TxBegin(pc)
            TxSetIESProp(tx, aObj, 'EVENT_1805_SLATE_START_STATE', 0)
            TxGiveItem(tx, 'EVENT_1805_SLATE_CUBE', 1, 'EVENT_1805_SLATE')
            local ret = TxCommit(tx)
            if ret == 'SUCCESS' then
                if #targetList == 14 then
                    ShowOkDlg(pc, 'EVENT_1805_SLATE_DLG3\\'..ScpArgMsg('EVENT_1805_SLATE_MSG3','CHAR',targetSlateList[#targetSlateList]), 1)
                    ShowOkDlg(pc, 'EVENT_1805_SLATE_DLG3', 1)
                elseif #targetList < 14 then
                    ShowOkDlg(pc, 'EVENT_1805_SLATE_DLG3\\'..ScpArgMsg('EVENT_1805_SLATE_MSG3','CHAR',targetSlateList[#targetSlateList]), 1)
                    local addMsg = ''
                    for i = 1, #targetSlateList do
                        if i == 1 then
                            addMsg = targetSlateList[i]
                        else
                            addMsg = addMsg..', '..targetSlateList[i]
                        end
                    end
                    ShowOkDlg(pc, 'EVENT_1805_SLATE_DLG3\\'..ScpArgMsg('EVENT_1805_SLATE_MSG2')..addMsg, 1)
                else
                    ShowOkDlg(pc, 'EVENT_1805_SLATE_DLG4', 1)
                    if aObj.EVENT_1805_SLATE_ACC_REWARD == 0 then
                        ShowOkDlg(pc, 'EVENT_1805_SLATE_DLG9', 1)
                    end
                end
            end
        elseif aObj.EVENT_1805_SLATE_START_STATE == 0 then
            if aObj.EVENT_1805_SLATE_START_DATE == nowDate then
                ShowOkDlg(pc, 'EVENT_1805_SLATE_DLG5', 1)
                return
            end
            
            local targetIndex, targetSlate
            
            for i = 1, #targetList do
                table.remove(hintList, table.find(hintList,targetList[i]))
            end
            
            targetIndex = hintList[IMCRandom(1,#hintList)]
            
            if #targetSlateList < 14 then
                for i = 1, #targetSlateList do
                    table.remove(slateList, table.find(slateList,targetSlateList[i]))
                end
            end
            targetSlate = slateList[IMCRandom(1,#slateList)]
            local tx = TxBegin(pc)
            TxSetIESProp(tx, aObj, 'EVENT_1805_SLATE_START_DATE', nowDate)
            TxSetIESProp(tx, aObj, 'EVENT_1805_SLATE_START_STATE', 1)
            if targetIndex ~= nil and targetSlate ~= nil then
                if aObj.EVENT_1805_SLATE_START_TARGET_LIST == 'None' then
                    TxSetIESProp(tx, aObj, 'EVENT_1805_SLATE_START_TARGET_LIST', tostring(targetIndex))
                else
                    TxSetIESProp(tx, aObj, 'EVENT_1805_SLATE_START_TARGET_LIST', aObj.EVENT_1805_SLATE_START_TARGET_LIST..'/'..tostring(targetIndex))
                end
                if aObj.EVENT_1805_SLATE_START_SLATE_LIST == 'None' then
                    TxSetIESProp(tx, aObj, 'EVENT_1805_SLATE_START_SLATE_LIST', tostring(targetSlate))
                else
                    TxSetIESProp(tx, aObj, 'EVENT_1805_SLATE_START_SLATE_LIST', aObj.EVENT_1805_SLATE_START_SLATE_LIST..'/'..tostring(targetSlate))
                end
            end
            local ret = TxCommit(tx)
            if ret == 'SUCCESS' then
                targetList = SCR_STRING_CUT(aObj.EVENT_1805_SLATE_START_TARGET_LIST)
                if #targetList == 1 then
                    ShowOkDlg(pc, 'EVENT_1805_SLATE_DLG2', 1)
                else
                    ShowOkDlg(pc, 'EVENT_1805_SLATE_DLG8', 1)
                end
                ShowOkDlg(pc, 'EVENT_1805_SLATE_DLG2\\'..ScpArgMsg('EVENT_1805_SLATE_HINT'..targetList[#targetList]), 1)
            end
        end
    elseif select == 2 then
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'EVENT_1805_SLATE_ACC_REWARD', 300)
        TxGiveItem(tx, 'NECK99_107', 1, 'EVENT_1805_SLATE_ACC')
        TxGiveItem(tx, 'EVENT_1805_SLATE_ACHIEVE_BOX', 4, 'EVENT_1805_SLATE_ACC')
        TxGiveItem(tx, 'EVENT_1805_SLATE_CUBE', 10, 'EVENT_1805_SLATE_ACC')
        local ret = TxCommit(tx)
    end
end

function SCR_USE_EVENT_1805_SLATE_CUBE(self, argObj, argStr, arg1, arg2)
    local itemList = {{'Moru_Gold_14d', 1, 400},
                        {'Moru_Silver', 1, 800},
                        {'Premium_item_transcendence_Stone', 1, 400},
                        {'misc_BlessedStone', 1, 900},
                        {'Dungeon_Key01', 1, 600},
                        {'Premium_Enchantchip14', 1, 600},
                        {'Event_Select_Acc_Box', 1, 800},
                        {'Point_Stone_100', 1, 1000},
                        {'Ability_Point_Stone_500', 1, 900},
                        {'Ability_Point_Stone', 1, 400},
                        {'Premium_boostToken_14d', 1, 1000},
                        {'card_Xpupkit02_event', 1, 900},
                        {'misc_gemExpStone09_14d', 1, 400},
                        {'misc_gemExpStone_randomQuest4_14d', 1, 900}

                    }
    SCR_EVENT_RANDOM_BOX_REWARD_FUNC(self, 'EVENT_1805_SLATE_CUBE', itemList, 'EVENT_1805_SLATE_CUBE')
end


function EVENT_1805_SLATE_POS_LIST()
    local posList = {{'f_siauliai_west', -545, 260, -1396},
                        {'f_siauliai_west', 1654, 282, 411},
                        {'f_siauliai_out', 1990, 175, 676},
                        {'f_siauliai_out', -1897, 42, -1384},
                        {'f_gele_57_1', 612, 168, -281},
                        {'f_gele_57_1', -1476, 168, -922},
                        {'f_gele_57_2', 992, 503, -1200},
                        {'f_gele_57_2', -1307, 462, 580},
                        {'f_gele_57_3', -1015, 168, -334},
                        {'f_gele_57_3', 688, 29, -249},
                        {'f_gele_57_4', -1849, 8, -650},
                        {'f_gele_57_4', 1073, -78, 1860},
                        {'d_chapel_57_5', 250, 16, 1164},
                        {'d_chapel_57_5', -1072, 0, -269},
                        {'f_siauliai_16', -1219, 74, 1612},
                        {'f_siauliai_16', 596, 25, 349},
                        {'f_siauliai_15_re', -1169, 922, 1338},
                        {'f_siauliai_15_re', -352, 984, -630},
                        {'f_siauliai_11_re', 1698, 283, 559},
                        {'f_siauliai_11_re', 494, 209, 880},
                        {'f_bracken_63_1', -243, 1019, 2016},
                        {'f_bracken_63_1', -162, 544, 955},
                        {'f_bracken_63_2', -1699, -37, -596},
                        {'f_bracken_63_2', 6, 151, 1396},
                        {'f_bracken_63_3', 953, 189, -289},
                        {'f_bracken_63_3', 211, 5, 1387},
                        {'d_cmine_66_1', 1546, 414, -1478},
                        {'d_cmine_66_1', 228, 209, 2076}
                    }
    return posList
end