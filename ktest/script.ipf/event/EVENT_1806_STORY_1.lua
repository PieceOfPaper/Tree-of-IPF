function EVENT_1806_STORY_1_NPC_HIDE_CHECK(pc)
    if GetZoneName(pc) == 'c_Klaipe' then
        local now_time = os.date('*t')
        local year = now_time['year']
        local month = now_time['month']
        local day = now_time['day']
        local hour = now_time['hour']
        local min = now_time['min']
        local nowday = year..'/'..month..'/'..day
        local ishide = isHideNPC(pc, 'EVENT_1806_STORY_1_NPC')
        if ishide == 'NO' then
            if (min >= 11 and min <= 29) or (min >= 41 and min <= 59) then
                local aObj = GetAccountObj(pc)
                if aObj.EVENT_1806_STORY_1_KILLCOUNT == -1 then
                    HideNPC(pc, 'EVENT_1806_STORY_1_NPC')
                end
            end
        else
            local unhideflag = 0
            local aObj = GetAccountObj(pc)
            if ((min >= 0 and min <= 10) or (min >= 30 and min <= 40)) and aObj.EVENT_1806_STORY_1_DATE ~= nowday and pc.Lv >= 30 then
                unhideflag = 1
            elseif aObj.EVENT_1806_STORY_1_KILLCOUNT >= 0 then
                unhideflag = 1
            end
            
            if unhideflag == 1 then
                UnHideNPC(pc, 'EVENT_1806_STORY_1_NPC')
            end
        end
    end
end

function SCR_EVENT_1806_STORY_1_NPC_DIALOG(self, pc)
    if pc.Lv < 30 then
        ShowOkDlg(pc, 'EVENT_1806_STORY_1_DLG1\\'..ScpArgMsg('EVENT_1801_ORB_MSG8','LV',30), 1)
        return
    end
    
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    local nowday = year..'/'..month..'/'..day
    
    local aObj = GetAccountObj(pc)
    local dlgIndex = 0
    local dlgList = {{'EVENT_1806_STORY_1_DLG2','EVENT_1806_STORY_1_DLG5'},{'EVENT_1806_STORY_1_DLG10','EVENT_1806_STORY_1_DLG12'},{'EVENT_1806_STORY_1_DLG11','EVENT_1806_STORY_1_DLG13'}}
    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)

    if nowbasicyday <= SCR_DATE_TO_YDAY_BASIC_2000(2018, 7, 2) then
        dlgIndex = 1
    elseif nowbasicyday <= SCR_DATE_TO_YDAY_BASIC_2000(2018, 7, 7) then
        dlgIndex = 2
    else
        dlgIndex = 3
    end
    if aObj.EVENT_1806_STORY_1_KILLCOUNT >= 50 then
        if aObj.EVENT_1806_STORY_1_HELPHAWK >= 0 then
            if aObj.EVENT_1806_STORY_1_HELPHAWK >= 1 then
                local takeCount = GetInvItemCount(pc,'EVENT_1806_STORY_1_TRAINING_FLUTE')
                local tx = TxBegin(pc)
                TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_KILLCOUNT', -1)
                TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_HELPHAWK', -1)
                TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_HELPHAWK_POS', 'None')
                TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_KILLLV', 0)
                TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_REWARDCOUNT', aObj.EVENT_1806_STORY_1_REWARDCOUNT + 1)
                if takeCount > 0 then
                    TxTakeItem(tx, 'EVENT_1806_STORY_1_TRAINING_FLUTE', takeCount, 'EVENT_1806_STORY_1')
                end
                TxGiveItem(tx, 'Point_Stone_100', 2, 'EVENT_1806_STORY_1')
--                if aObj.EVENT_1806_STORY_1_REWARDCOUNT == 6 then
--                    TxGiveItem(tx, 'ABAND01_134', 1, 'EVENT_1806_STORY_1')
--                end
                TxGiveItem(tx, 'EVENT_1806_STORY_1_CUBE', 1, 'EVENT_1806_STORY_1')
                local ret = TxCommit(tx)
                if ret == 'SUCCESS' then
                    ShowOkDlg(pc, 'EVENT_1806_STORY_1_DLG6', 1)
                    ShowOkDlg(pc, dlgList[dlgIndex][2], 1)
                end
            elseif aObj.EVENT_1806_STORY_1_HELPHAWK == 0 then
                local select = ShowSelDlg(pc, 0, 'EVENT_1806_STORY_1_DLG7', ScpArgMsg('EVENT_1806_STORY_1_MSG3'), ScpArgMsg('EVENT_1806_STORY_1_MSG4'), ScpArgMsg('Auto_JongLyo'))
                if select == 2 then
                    local takeCount = GetInvItemCount(pc,'EVENT_1806_STORY_1_TRAINING_FLUTE')
                    local tx = TxBegin(pc)
                    TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_KILLCOUNT', -1)
                    TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_HELPHAWK', -1)
                    TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_HELPHAWK_POS', 'None')
                    TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_KILLLV', 0)
                    TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_REWARDCOUNT', aObj.EVENT_1806_STORY_1_REWARDCOUNT + 1)
                    if takeCount > 0 then
                        TxTakeItem(tx, 'EVENT_1806_STORY_1_TRAINING_FLUTE', takeCount, 'EVENT_1806_STORY_1')
                    end
                    TxGiveItem(tx, 'Point_Stone_100', 2, 'EVENT_1806_STORY_1')
--                    if aObj.EVENT_1806_STORY_1_REWARDCOUNT == 6 then
--                        TxGiveItem(tx, 'ABAND01_134', 1, 'EVENT_1806_STORY_1')
--                    end
                    local ret = TxCommit(tx)
                    if ret == 'SUCCESS' then
                        ShowOkDlg(pc, 'EVENT_1806_STORY_1_DLG8', 1)
                        ShowOkDlg(pc, dlgList[dlgIndex][2], 1)
                    end
                else
                    ShowOkDlg(pc, 'EVENT_1806_STORY_1_DLG9', 1)
                end
            end
        else
            local takeCount = GetInvItemCount(pc,'EVENT_1806_STORY_1_TRAINING_FLUTE')
            local tx = TxBegin(pc)
            TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_KILLCOUNT', -1)
            TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_KILLLV', 0)
            TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_REWARDCOUNT', aObj.EVENT_1806_STORY_1_REWARDCOUNT + 1)
            if takeCount > 0 then
                TxTakeItem(tx, 'EVENT_1806_STORY_1_TRAINING_FLUTE', takeCount, 'EVENT_1806_STORY_1')
            end
            TxGiveItem(tx, 'Point_Stone_100', 2, 'EVENT_1806_STORY_1')
--            if aObj.EVENT_1806_STORY_1_REWARDCOUNT == 6 then
--                TxGiveItem(tx, 'ABAND01_134', 1, 'EVENT_1806_STORY_1')
--            end
            local ret = TxCommit(tx)
            if ret == 'SUCCESS' then
                ShowOkDlg(pc, dlgList[dlgIndex][2], 1)
            end
        end
    elseif aObj.EVENT_1806_STORY_1_KILLCOUNT >= 0 and aObj.EVENT_1806_STORY_1_KILLCOUNT < 50 then
        local targetZone = EVENT_1806_STORY_1_TARGETZONE(aObj.EVENT_1806_STORY_1_KILLLV) 
        if targetZone ~= nil then
            local targetZoneKOR = EVENT_1806_STORY_1_TARGETZONE_KOR(targetZone)
            if targetZoneKOR ~= nil then
                ShowOkDlg(pc, 'EVENT_1806_STORY_1_DLG4', 1)
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG2",'ZONE',targetZoneKOR), 10);
            end
        end
    elseif aObj.EVENT_1806_STORY_1_KILLCOUNT < 0 then
        if aObj.EVENT_1806_STORY_1_DATE ~= nowday then
            local select = ShowSelDlg(pc, 0, 'EVENT_1806_STORY_1_DLG1', ScpArgMsg('EVENT_1806_STORY_1_MSG1'), ScpArgMsg('EVENT_1806_STORY_1_MSG14','COUNT',aObj.EVENT_1806_STORY_1_REWARDCOUNT), ScpArgMsg('Auto_JongLyo'))
            if select == 1 then
                local tx = TxBegin(pc)
                TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_DATE', nowday)
                TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_KILLCOUNT', 0)
                TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_KILLLV', pc.Lv)
                TxGiveItem(tx, 'EVENT_1806_STORY_1_TRAINING_FLUTE', 1, 'EVENT_1806_STORY_1')
                local ret = TxCommit(tx)
                if ret == 'SUCCESS' then
                    local targetZone = EVENT_1806_STORY_1_TARGETZONE(pc.Lv) 
                    if targetZone ~= nil then
                        local targetZoneKOR = EVENT_1806_STORY_1_TARGETZONE_KOR(targetZone)
                        if targetZoneKOR ~= nil then
                            ShowOkDlg(pc, dlgList[dlgIndex][1], 1)
                            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG2",'ZONE',targetZoneKOR), 10);
                        end
                    end
                end
            elseif select == 2 then
                if aObj.EVENT_1806_STORY_1_ACC_REWARD > 0 then
                    ShowOkDlg(pc, 'EVENT_1806_STORY_1_DLG14', 1)
                elseif aObj.EVENT_1806_STORY_1_REWARDCOUNT < 7 then
                    ShowOkDlg(pc, 'EVENT_1806_STORY_1_DLG15', 1)
                elseif aObj.EVENT_1806_STORY_1_ACC_REWARD == 0 and aObj.EVENT_1806_STORY_1_REWARDCOUNT >= 7 then
                    local tx = TxBegin(pc)
                    TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_ACC_REWARD', 1)
                    TxGiveItem(tx, 'ABAND01_134', 1, 'EVENT_1806_STORY_1')
                    local ret = TxCommit(tx)
                    if ret == 'SUCCESS' then
                        ShowOkDlg(pc, 'EVENT_1806_STORY_1_DLG16', 1)
                    end
                end
            end
        else
            ShowOkDlg(pc, 'EVENT_1806_STORY_1_DLG3', 1)
        end
    end
end

function SCR_USE_EVENT_1806_STORY_1_TRAINING_FLUTE(pc,argObj,argstr,arg1,arg2)
    local aObj = GetAccountObj(pc)
    PlaySoundLocal(pc,'skl_eff_whistle_4')
    if aObj ~= nil then
        if aObj.EVENT_1806_STORY_1_HELPHAWK == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG10"), 10)
        elseif aObj.EVENT_1806_STORY_1_HELPHAWK_POS ~= 'None' then
            local hawkPos = SCR_STRING_CUT(aObj.EVENT_1806_STORY_1_HELPHAWK_POS)
            if GetZoneName(pc) == hawkPos[1] then
                local x,y,z = GetPos(pc)
                local dist = SCR_POINT_DISTANCE(x,z,hawkPos[2],hawkPos[4])
                if dist >= 2000 then
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG6","DIST",dist), 10)
                elseif dist >= 1000 then
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG7","DIST",dist), 10)
                elseif dist >= 500 then
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG8","DIST",dist), 10)
                    PlaySoundLocal(pc,'mon_voice_pet_hawk_circling')
                elseif dist >= 50 then
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG9","DIST",dist), 10)
                    PlaySoundLocal(pc,'mon_voice_pet_hawk_circling')
                elseif dist < 50 then
                    local npc = CREATE_NPC(pc, 'npc_hawk', tonumber(hawkPos[2]),tonumber(hawkPos[3]),tonumber(hawkPos[4]), 0, 'Peaceful', GetLayer(pc))
                    if npc ~= nil then
                        LookAt(npc, pc)
                        PlaySoundLocal(pc,'mon_voice_pet_hawk_circling')
                        DisableBornAni(npc)
                        PlayAnim(npc, 'ASTD_TO_SIT',1)
                        SetLifeTime(npc,3)
                        local tx = TxBegin(pc)
                        TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_HELPHAWK', 1)
                        local ret = TxCommit(tx)
                        if ret == 'SUCCESS' then
                            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG10"), 10)
                        end
                    end
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG5"), 10)
            end
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG5"), 10)
        end
    end
end

function EVENT_1806_STORY_1_TARGETZONE_KOR(targetZone)
    local targetZoneKOR = nil
    for i = 1, #targetZone do
        if i == 1 then
            targetZoneKOR = GetClassString('Map',targetZone[i],'Name')
        else
            targetZoneKOR = targetZoneKOR..', '..GetClassString('Map',targetZone[i],'Name')
        end
    end
    return targetZoneKOR
end
function EVENT_1806_STORY_1_TARGETZONE(lv)
    local zoneList = {{'f_gele_57_4','f_rokas_30'},{'f_remains_38','f_siauliai_46_4'},{'f_tableland_28_2','f_maple_25_2'},{'f_whitetrees_21_2','f_maple_23_2'},{'f_whitetrees_21_2','f_whitetrees_22_3'}}
    local index = 0
    if lv >= 30 and lv <= 100 then
        index = 1
    elseif lv >= 101 and lv <= 200 then
        index = 2
    elseif lv >= 201 and lv <= 300 then
        index = 3
    elseif lv >= 301 and lv <= 350 then
        index = 4
    elseif lv >= 351 then
        index = 5
    end
    
    if index == 0 then
        return
    end
    
    return zoneList[index]
end

function EVENT_1806_STORY_1_KILL(pc, sObj, msg, argObj, argStr, argNum)
    if argObj.Faction ~= 'RootCrystal' then
        local aObj = GetAccountObj(pc)
        if aObj.EVENT_1806_STORY_1_KILLCOUNT >= 0 and aObj.EVENT_1806_STORY_1_KILLCOUNT < 50 then
            local targetZone = EVENT_1806_STORY_1_TARGETZONE(aObj.EVENT_1806_STORY_1_KILLLV)
            if table.find(targetZone, GetZoneName(pc)) > 0 then
                if aObj.EVENT_1806_STORY_1_KILLCOUNT >= 0 and aObj.EVENT_1806_STORY_1_KILLCOUNT < 49 then
                    RunScript('EVENT_1806_STORY_1_KILL_RUN_1',pc)
                elseif aObj.EVENT_1806_STORY_1_KILLCOUNT == 49 then
                    local aid = tonumber(GetPcAIDStr(pc))
                    local t = {{2,5,10},{3,7,9},{5,7,10},{4,9,11},{2,7,11},{3,8,9}}
                    local index = (aid % #t) + 1
                    if table.find(t[index], aObj.EVENT_1806_STORY_1_REWARDCOUNT) > 0 then
                        local x,y,z = GetPos(pc)
                        local result = SCR_GET_AROUND_MONGEN_ANCHOR(pc, GetZoneName(pc), x, y, z, 400, 800)
                        local hawkX, hawkY, hawkZ
                        local zoneID = GetZoneInstID(pc)
                        
                        if #result > 0 then
                            for i=1, 100 do
                                local rand = IMCRandom(1, #result)
                                if IsValidPos(zoneID, result[rand].PosX, result[rand].PosY, result[rand].PosZ) == 'YES' and FindPath(zoneID, 30 , x, y, z,result[rand].PosX, result[rand].PosY, result[rand].PosZ) == 'YES' then
                                    hawkX = math.floor(result[rand].PosX)
                                    hawkY = math.floor(result[rand].PosY)
                                    hawkZ = math.floor(result[rand].PosZ)
                                    break
                                end
                            end
                            
                            RunScript('EVENT_1806_STORY_1_KILL_RUN_2',pc, hawkX, hawkY, hawkZ)
                        end
                    else
                        RunScript('EVENT_1806_STORY_1_KILL_RUN_2',pc)
                    end
                elseif aObj.EVENT_1806_STORY_1_KILLCOUNT >= 50 and aObj.EVENT_1806_STORY_1_HELPHAWK == -1 then
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG12"), 10)
                elseif aObj.EVENT_1806_STORY_1_KILLCOUNT >= 50 and aObj.EVENT_1806_STORY_1_HELPHAWK == 0 then
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG13"), 10)
                elseif aObj.EVENT_1806_STORY_1_KILLCOUNT >= 50 and aObj.EVENT_1806_STORY_1_HELPHAWK == 1 then
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG12"), 10)
                end
            end
        end
    end
end

function EVENT_1806_STORY_1_KILL_RUN_1(pc)
    local aObj = GetAccountObj(pc)
    
    local tx = TxBegin(pc)
    TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_KILLCOUNT', aObj.EVENT_1806_STORY_1_KILLCOUNT + 1)
    local ret = TxCommit(tx)
    if ret == 'SUCCESS' then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG11",'KILL',aObj.EVENT_1806_STORY_1_KILLCOUNT), 10)
    end
end

function EVENT_1806_STORY_1_KILL_RUN_2(pc, hawkX, hawkY, hawkZ)
    local flag = GetExProp(pc, 'EVENT_1806_STORY_1_HAWK_GEN')
    if flag == 0 then
        SetExProp(pc, 'EVENT_1806_STORY_1_HAWK_GEN', 1)
        local aObj = GetAccountObj(pc)
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_KILLCOUNT', aObj.EVENT_1806_STORY_1_KILLCOUNT + 1)
        if hawkX ~= nil and hawkY ~= nil and hawkZ ~= nil then
            TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_HELPHAWK', 0)
            TxSetIESProp(tx, aObj, 'EVENT_1806_STORY_1_HELPHAWK_POS', GetZoneName(pc)..'/'..hawkX..'/'..hawkY..'/'..hawkZ)
        end
        local ret = TxCommit(tx)
        if ret == 'SUCCESS' then
            if hawkX ~= nil and hawkY ~= nil and hawkZ ~= nil then
                PlaySoundLocal(pc,'mon_voice_pet_hawk_shot')
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG13"), 10)
            else
                local x,y,z = GetPos(pc)
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1806_STORY_1_MSG12"), 10)
                local npc = CREATE_MONSTER(pc, 'npc_hawk', x - 50, y+150, z + 50, 0, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 100)
                if npc ~= nil then
                    SetLifeTime(npc, 5)
                    FlyMath(npc, 100,0,0)
                    sleep(1000)
                    PlaySoundLocal(pc,'mon_voice_pet_hawk_circling')
                    MoveEx(npc, x + 300, y, z - 300, 1)
                end
            end
        end
    end
end

function SCR_USE_EVENT_1806_STORY_1_CUBE(self, argObj, argStr, arg1, arg2)
    local itemList = {{'Moru_Gold_14d', 1, 500},
                        {'Moru_Silver', 1, 500},
                        {'Premium_item_transcendence_Stone', 1, 500},
                        {'misc_BlessedStone', 1, 1000},
                        {'Dungeon_Key01', 1, 500},
                        {'Premium_Enchantchip14', 1, 1500},
                        {'Ability_Point_Stone_500', 1, 1000},
                        {'Ability_Point_Stone', 1, 500},
                        {'Premium_boostToken_14d', 2, 2000},
                        {'Premium_dungeoncount_Event', 1, 1000},
                        {'Premium_indunReset_14d', 1, 1000}
                    }
    SCR_EVENT_RANDOM_BOX_REWARD_FUNC(self, 'EVENT_1806_STORY_1_CUBE', itemList, 'EVENT_1806_STORY_1_CUBE')
end
