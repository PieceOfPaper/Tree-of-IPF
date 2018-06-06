function EVENT_1804_ARBOR_TREE_STEP_COUNT()
    local EVENT_1804_ARBOR_TREE_STEP_COUNT = 28000
    return EVENT_1804_ARBOR_TREE_STEP_COUNT
end
function EVENT_1804_ARBOR_TREE_BONUS_REWARD_COUNT()
    local EVENT_1804_ARBOR_TREE_BONUS_REWARD_COUNT = 1000
    return EVENT_1804_ARBOR_TREE_BONUS_REWARD_COUNT
end

function EVENT_1804_ARBOR_TREE_NOW_STEP(nowCount)
    local stepCount = EVENT_1804_ARBOR_TREE_STEP_COUNT()
    local ret = 0
    if nowCount < stepCount then
        ret = 1
    elseif nowCount < stepCount *2 then
        ret = 2
    elseif nowCount < stepCount *3 then
        ret = 3
    elseif nowCount < stepCount *4 then
        ret = 4
    elseif nowCount < stepCount *5 then
        ret = 5
    elseif nowCount < stepCount *6 then
        ret = 6
    else
        ret = 7
    end
    
    return ret
end

function EVENT_1804_ARBOR_NOW_TIME()
    local now_time = os.date('*t')
    local month = now_time['month']
    local year = now_time['year']
    local day = now_time['day']

    local nowbasicyday = SCR_DATE_TO_YDAY_BASIC_2000(year, month, day)
    local index = 0
    
    if nowbasicyday < SCR_DATE_TO_YDAY_BASIC_2000(2018, 3, 22) then
        index = 1
    elseif nowbasicyday < SCR_DATE_TO_YDAY_BASIC_2000(2018, 3, 29) then
        index = 1
    elseif nowbasicyday < SCR_DATE_TO_YDAY_BASIC_2000(2018, 4, 5) then
        index = 2
    elseif nowbasicyday < SCR_DATE_TO_YDAY_BASIC_2000(2018, 4, 12) then
        index = 3
    elseif nowbasicyday < SCR_DATE_TO_YDAY_BASIC_2000(2018, 4, 19) then
        index = 4
    elseif nowbasicyday < SCR_DATE_TO_YDAY_BASIC_2000(2018, 4, 26) then
        index = 5
    elseif nowbasicyday <= SCR_DATE_TO_YDAY_BASIC_2000(2018, 5, 3) then
        index = 6
    else
        index = 0
    end
    
    return index
end



function SCR_EVENT_1804_ARBOR_TREE_DIALOG(self, pc)
    local zoneID = GetZoneInstID(self)
    local zoneObj = GetLayerObject(zoneID, 0)
    local timeIndex = EVENT_1804_ARBOR_NOW_TIME()
    local nowStep = EVENT_1804_ARBOR_TREE_NOW_STEP(zoneObj.EVENT_1804_ARBOR_TREE_INPUT_COUNT)
    local stepCount = EVENT_1804_ARBOR_TREE_STEP_COUNT()
    
    local now_time = os.date('*t')
    local month = now_time['month']
    local year = now_time['year']
    local day = now_time['day']
    local nowday = year..'/'..month..'/'..day
    local aObj = GetAccountObj(pc)
    
    local selMsg3
--    zoneObj.EVENT_1804_ARBOR_TREE_INPUT_COUNT = 0
--    print('DDDDDDDDDDDDDDDDDDDDDDD',zoneObj.EVENT_1804_ARBOR_TREE_INPUT_COUNT)
    
    if timeIndex >= 3 and (aObj.EVENT_1804_ARBOR_WEEKREWARD3 == 1 or aObj.EVENT_1804_ARBOR_WEEKREWARD4 == 1 or aObj.EVENT_1804_ARBOR_WEEKREWARD5 == 1 or aObj.EVENT_1804_ARBOR_WEEKREWARD6 == 1) then
        selMsg3 = ScpArgMsg('EVENT_1804_ARBOR_MSG7')
    end
    
    local buffKor = GetClassString('Buff','EVENT_1804_ARBOR_BUFF_'..nowStep,'Name')
    local nowarbor = ScpArgMsg('EVENT_1804_ARBOR_MSG14')
    if nowStep > timeIndex then
        nowarbor = ScpArgMsg('EVENT_1804_ARBOR_MSG15')
    end
    
    local maxBuffCount = 4
    
    local nowBuffCount = aObj.EVENT_1804_ARBOR_BUFF_COUNT
    if nowday ~= aObj.EVENT_1804_ARBOR_BUFF_DATE then
        nowBuffCount = 0
    end
    
    local maxExchangeCount = 5
    local nowExchangeCount = aObj.EVENT_1804_ARBOR_INPUT_COUNT
    if nowday ~= aObj.EVENT_1804_ARBOR_INPUT_DATE then
        nowExchangeCount = 0
    end
    
    local nameType
    if nowStep <= 2 then
        nameType = ScpArgMsg('EVENT_1804_ARBOR_MSG16')
    elseif nowStep <= 4 then
        nameType = ScpArgMsg('EVENT_1804_ARBOR_MSG17')
    else
        nameType = ScpArgMsg('EVENT_1804_ARBOR_MSG18')
    end
    
    local select = ShowSelDlg(pc, 0, 'EVENT_1804_ARBOR_DLG1\\'..ScpArgMsg('EVENT_1804_ARBOR_MSG13','STEP',nowStep)..nameType..' '..nowarbor..']', ScpArgMsg('EVENT_1804_ARBOR_MSG3','COUNT',nowExchangeCount,'MAX',maxExchangeCount), ScpArgMsg('EVENT_1804_ARBOR_MSG4','BUFF',buffKor,'COUNT',nowBuffCount,'MAX',maxBuffCount), selMsg3, ScpArgMsg('Auto_DaeHwa_JongLyo'))
    if select == 1 then
        if nowday ~= aObj.EVENT_1804_ARBOR_INPUT_DATE or aObj.EVENT_1804_ARBOR_INPUT_COUNT < 5 then
            if nowStep <= timeIndex then
                local inputItemList = {'EVENT_1804_ARBOR_GROW_CRYSTAL_1_2','EVENT_1804_ARBOR_GROW_CRYSTAL_1_2','EVENT_1804_ARBOR_GROW_CRYSTAL_3_4','EVENT_1804_ARBOR_GROW_CRYSTAL_3_4','EVENT_1804_ARBOR_GROW_CRYSTAL_5_6','EVENT_1804_ARBOR_GROW_CRYSTAL_5_6'}
                local inputItemCount = {3, 3, 3, 3, 3, 3}
                local giveItemList = {{{'EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_1_2',1}},{{'EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_1_2',1}},{{'EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_3_4',1}},{{'EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_3_4',1}},{{'EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_5_6',1}},{{'EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_5_6',1}}}
                local invItemCount = GetInvItemCount(pc, inputItemList[nowStep])
                if invItemCount >= inputItemCount[nowStep] then
                    local tx = TxBegin(pc)
                    if nowday ~= aObj.EVENT_1804_ARBOR_INPUT_DATE then
                        TxSetIESProp(tx, aObj, 'EVENT_1804_ARBOR_INPUT_COUNT', 1)
                    else
                        TxSetIESProp(tx, aObj, 'EVENT_1804_ARBOR_INPUT_COUNT', aObj.EVENT_1804_ARBOR_INPUT_COUNT+1)
                    end
                    TxSetIESProp(tx, aObj, 'EVENT_1804_ARBOR_INPUT_DATE', nowday)
                    TxTakeItem(tx, inputItemList[nowStep], inputItemCount[nowStep], 'EVENT_1804_ARBOR_TREE')
                    if zoneObj.EVENT_1804_ARBOR_TREE_INPUT_COUNT ~= 0 and (zoneObj.EVENT_1804_ARBOR_TREE_INPUT_COUNT + 1 - (timeIndex-1)*stepCount) % EVENT_1804_ARBOR_TREE_BONUS_REWARD_COUNT() == 0 then
                        TxGiveItem(tx, 'Point_Stone_100', 10, 'EVENT_1804_ARBOR_TREE')
                    end
                    for i = 1, #giveItemList[nowStep] do
                        TxGiveItem(tx, giveItemList[nowStep][i][1], giveItemList[nowStep][i][2], 'EVENT_1804_ARBOR_TREE')
                    end
                    if timeIndex == 3 and aObj.EVENT_1804_ARBOR_WEEKREWARD3 == 0 then
                        TxSetIESProp(tx, aObj, 'EVENT_1804_ARBOR_WEEKREWARD3', 1)
                    elseif timeIndex == 4 and aObj.EVENT_1804_ARBOR_WEEKREWARD4 == 0 then
                        TxSetIESProp(tx, aObj, 'EVENT_1804_ARBOR_WEEKREWARD4', 1)
                    elseif timeIndex == 5 and aObj.EVENT_1804_ARBOR_WEEKREWARD5 == 0 then
                        TxSetIESProp(tx, aObj, 'EVENT_1804_ARBOR_WEEKREWARD5', 1)
                    elseif timeIndex == 6 and aObj.EVENT_1804_ARBOR_WEEKREWARD6 == 0 then
                        TxSetIESProp(tx, aObj, 'EVENT_1804_ARBOR_WEEKREWARD6', 1)
                    end
                    
                    local ret = TxCommit(tx)
                    if ret == 'SUCCESS' then
                        zoneObj.EVENT_1804_ARBOR_TREE_INPUT_COUNT = zoneObj.EVENT_1804_ARBOR_TREE_INPUT_COUNT + 1
                    end
                else
                    local itemKor = GetClassString('Item',inputItemList[nowStep],'Name')
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1804_ARBOR_MSG1","ITEM",itemKor), 10)
                end
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1804_ARBOR_MSG2"), 10)
            end
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1804_ARBOR_MSG5"), 10)
        end
    elseif select == 2 then
        if nowday ~= aObj.EVENT_1804_ARBOR_BUFF_DATE or aObj.EVENT_1804_ARBOR_BUFF_COUNT < maxBuffCount then
            local tx = TxBegin(pc)
            if nowday ~= aObj.EVENT_1804_ARBOR_BUFF_DATE then
                TxSetIESProp(tx, aObj, 'EVENT_1804_ARBOR_BUFF_COUNT', 1)
            else
                TxSetIESProp(tx, aObj, 'EVENT_1804_ARBOR_BUFF_COUNT', aObj.EVENT_1804_ARBOR_BUFF_COUNT+1)
            end
            TxSetIESProp(tx, aObj, 'EVENT_1804_ARBOR_BUFF_DATE', nowday)
            local ret = TxCommit(tx)
            if ret == 'SUCCESS' then
                AddBuff(self, pc, 'EVENT_1804_ARBOR_BUFF_'..nowStep, 1, 0, 3600000, 1)
                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("EVENT_1804_ARBOR_MSG6","BUFF", buffKor), 10)
            end
        end
    elseif select == 3 then
        if timeIndex >= 3 and (aObj.EVENT_1804_ARBOR_WEEKREWARD3 == 1 or aObj.EVENT_1804_ARBOR_WEEKREWARD4 == 1 or aObj.EVENT_1804_ARBOR_WEEKREWARD5 == 1 or aObj.EVENT_1804_ARBOR_WEEKREWARD6 == 1) then
            local weekmsg3, weekmsg4, weekmsg5, weekmsg6
            if aObj.EVENT_1804_ARBOR_WEEKREWARD3 == 1 then
                weekmsg3 = ScpArgMsg('EVENT_1804_ARBOR_MSG8','WEEK',3)
            end
            if aObj.EVENT_1804_ARBOR_WEEKREWARD4 == 1 then
                weekmsg4 = ScpArgMsg('EVENT_1804_ARBOR_MSG8','WEEK',4)
            end
            if aObj.EVENT_1804_ARBOR_WEEKREWARD5 == 1 then
                weekmsg5 = ScpArgMsg('EVENT_1804_ARBOR_MSG8','WEEK',5)
            end
            if aObj.EVENT_1804_ARBOR_WEEKREWARD6 == 1 then
                weekmsg6 = ScpArgMsg('EVENT_1804_ARBOR_MSG8','WEEK',6)
            end
            
            local select2 = ShowSelDlg(pc, 0, 'EVENT_1804_ARBOR_DLG13', weekmsg3, weekmsg4, weekmsg5, weekmsg6, ScpArgMsg('Auto_DaeHwa_JongLyo'))
            if select2 == 1 then
                local tx = TxBegin(pc)
                TxGiveItem(tx, 'EVENT_1804_ARBOR_COSTUME_M', 1, 'EVENT_1804_ARBOR_TREE')
                TxGiveItem(tx, 'EVENT_1804_ARBOR_COSTUME_F', 1, 'EVENT_1804_ARBOR_TREE')
                TxSetIESProp(tx, aObj, 'EVENT_1804_ARBOR_WEEKREWARD3', 300)
                local ret = TxCommit(tx)
            elseif select2 == 2 then
                local select3 = ShowSelDlg(pc, 0, 'EVENT_1804_ARBOR_DLG14', ScpArgMsg('Yes'), ScpArgMsg('No'))
                if select3 == 1 then
                    local tx = TxBegin(pc)
                    TxGiveItem(tx, 'Premium_RankReset_60d', 1, 'EVENT_1804_ARBOR_TREE')
                    TxGiveItem(tx, 'Premium_StatReset_60d', 1, 'EVENT_1804_ARBOR_TREE')
                    TxSetIESProp(tx, aObj, 'EVENT_1804_ARBOR_WEEKREWARD4', 300)
                    local ret = TxCommit(tx)
                end
            elseif select2 == 3 then
                local tx = TxBegin(pc)
                TxGiveItem(tx, 'EVENT_1804_ARBOR_ACHIEVE_BOX', 4, 'EVENT_1804_ARBOR_TREE')
                TxSetIESProp(tx, aObj, 'EVENT_1804_ARBOR_WEEKREWARD5', 300)
                local ret = TxCommit(tx)
            elseif select2 == 4 then
                local tx = TxBegin(pc)
                TxGiveItem(tx, 'Ability_Point_Stone', 5, 'EVENT_1804_ARBOR_TREE')
                TxSetIESProp(tx, aObj, 'EVENT_1804_ARBOR_WEEKREWARD6', 300)
                local ret = TxCommit(tx)
            end
        end
    end
end

function SCR_EVENT_1804_ARBOR_TREE_TS_BORN_ENTER(self)
    local zoneID = GetZoneInstID(self)
    local zoneObj = GetLayerObject(zoneID, 0)
    local timeIndex = EVENT_1804_ARBOR_NOW_TIME()
    local stepCount = EVENT_1804_ARBOR_TREE_STEP_COUNT()
    local nowStep = EVENT_1804_ARBOR_TREE_NOW_STEP(zoneObj.EVENT_1804_ARBOR_TREE_INPUT_COUNT)
    local modelChangeFlag = 0
    if nowStep < timeIndex then
        zoneObj.EVENT_1804_ARBOR_TREE_INPUT_COUNT = (timeIndex-1) * stepCount
    end
    local x,y,z = GetPos(self)
    
    local treeModelList = {'treeday_1','treeday_2','treeday_3','treeday_4','treeday_5','treeday_6','treeday_7'}
    local modelStep = self.NumArg1
--    print('DDDDDDDDDDDD',nowStep,self.NumArg1)
    if nowStep >= 1 and nowStep <= 7  and self.NumArg1 ~= nowStep then
        PlayEffect(self, 'F_light146_leaf', 2.5+ nowStep*0.3, 1, 'TOP')
        local npc = CREATE_NPC(self, treeModelList[nowStep], x, y, z, 315, nil, nil, self.Name, 'EVENT_1804_ARBOR_TREE', nil, nil, nil, nil, 'None')
        if npc ~= nil then
            local beforeNPC = GetExArgObject(self, 'EVENT_1804_ARBOR_TREE_NPC')
--            print('AAAAAAAAAAA',beforeNPC)
            if beforeNPC ~= nil then
                Kill(beforeNPC)
--                print('BBBBBBBBBBBBB', npc)
            end
            SetExArgObject(self, 'EVENT_1804_ARBOR_TREE_NPC', npc)
            self.NumArg1 = nowStep
        end
    end
--    elseif nowStep == 2 and self.NumArg1 ~= nowStep then
--        PlayEffect(self, ' F_light146_leaf')
----        ChangeModel(self, treeModelList[2])
--        self.NumArg1 = 2
--    elseif nowStep == 3 and self.NumArg1 ~= nowStep then
--        PlayEffect(self, ' F_light146_leaf')
----        ChangeModel(self, treeModelList[3])
--        self.NumArg1 = 3
--    elseif nowStep == 4 and self.NumArg1 ~= nowStep then
--        PlayEffect(self, ' F_light146_leaf')
----        ChangeModel(self, treeModelList[4])
--        self.NumArg1 = 4
--    elseif nowStep == 5 and self.NumArg1 ~= nowStep then
--        PlayEffect(self, ' F_light146_leaf')
----        ChangeModel(self, treeModelList[5])
--        self.NumArg1 = 5
--    elseif nowStep == 6 and self.NumArg1 ~= nowStep then
--        PlayEffect(self, ' F_light146_leaf')
----        ChangeModel(self, treeModelList[6])
--        self.NumArg1 = 6
--    elseif nowStep == 7 and self.NumArg1 ~= nowStep then
--        PlayEffect(self, ' F_light146_leaf')
----        ChangeModel(self, treeModelList[7])
--        self.NumArg1 = 7
--    end
end

function SCR_EVENT_1804_ARBOR_TREE_TS_BORN_UPDATE(self)
    SCR_EVENT_1804_ARBOR_TREE_TS_BORN_ENTER(self)
end

function SCR_EVENT_1804_ARBOR_TREE_TS_BORN_LEAVE(self)
end

function SCR_EVENT_1804_ARBOR_TREE_TS_DEAD_ENTER(self)
end

function SCR_EVENT_1804_ARBOR_TREE_TS_DEAD_UPDATE(self)
end

function SCR_EVENT_1804_ARBOR_TREE_TS_DEAD_LEAVE(self)
end



function SCR_EVENT_1804_ARBOR_DROP(self, sObj, msg, argObj, argStr, argNum)
    if IMCRandom(1, 100) <= 9 then
        local timeIndex = EVENT_1804_ARBOR_NOW_TIME()
        if timeIndex == 1 or timeIndex == 2 then
            local curMap = GetZoneName(self);
            local mapCls = GetClass("Map", curMap);
            
            if self.Lv >= 30 and (mapCls.WorldMap ~= 'None' and mapCls.MapType ~= 'City' and IsPlayingDirection(self) ~= 1 and IsIndun(self) ~= 1 and IsPVPServer(self) ~= 1 and IsMissionInst(self) ~= 1) and argObj.MonRank == 'Normal' then
                if self.Lv <= argObj.Lv + 20 then
                    RunScript('GIVE_ITEM_TX',self, 'EVENT_1804_ARBOR_GROW_CRYSTAL_1_2', 1, 'EVENT_1804_ARBOR_DROP')
                end
            end
        end
    end
end


function SCR_BUFF_ENTER_EVENT_1804_ARBOR_BUFF_1(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM + 200
    self.MATK_BM = self.MATK_BM + 200
end

function SCR_BUFF_LEAVE_EVENT_1804_ARBOR_BUFF_1(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM - 200
    self.MATK_BM = self.MATK_BM - 200
end

function SCR_BUFF_ENTER_EVENT_1804_ARBOR_BUFF_2(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM + 200;
    self.MDEF_BM = self.MDEF_BM + 200;
end

function SCR_BUFF_LEAVE_EVENT_1804_ARBOR_BUFF_2(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM - 200;
    self.MDEF_BM = self.MDEF_BM - 200;
end

function SCR_BUFF_ENTER_EVENT_1804_ARBOR_BUFF_3(self, buff, arg1, arg2, over)
    self.INT_BM = self.INT_BM + 20;
    self.STR_BM = self.STR_BM + 20;
    self.CON_BM = self.CON_BM + 20;
    self.DEX_BM = self.DEX_BM + 20;
    self.MNA_BM = self.MNA_BM + 20;
end

function SCR_BUFF_LEAVE_EVENT_1804_ARBOR_BUFF_3(self, buff, arg1, arg2, over)
    self.INT_BM = self.INT_BM - 20;
    self.STR_BM = self.STR_BM - 20;
    self.CON_BM = self.CON_BM - 20;
    self.DEX_BM = self.DEX_BM - 20;
    self.MNA_BM = self.MNA_BM - 20;
end

function SCR_BUFF_ENTER_EVENT_1804_ARBOR_BUFF_4(self, buff, arg1, arg2, over)
    self.MHP_BM = self.MHP_BM + 3000
    self.MSP_BM = self.MSP_BM + 2000
end

function SCR_BUFF_LEAVE_EVENT_1804_ARBOR_BUFF_4(self, buff, arg1, arg2, over)
    self.MHP_BM = self.MHP_BM - 3000
    self.MSP_BM = self.MSP_BM - 2000
end

function SCR_BUFF_ENTER_EVENT_1804_ARBOR_BUFF_5(self, buff, arg1, arg2, over)
    self.LootingChance_BM = self.LootingChance_BM + 500;
end

function SCR_BUFF_LEAVE_EVENT_1804_ARBOR_BUFF_5(self, buff, arg1, arg2, over)
    self.LootingChance_BM = self.LootingChance_BM - 500;
end

function SCR_BUFF_ENTER_EVENT_1804_ARBOR_BUFF_6(self, buff, arg1, arg2, over)
end
function SCR_BUFF_UPDATE_EVENT_1804_ARBOR_BUFF_6(self, buff, arg1, arg2, RemainTime, ret, over)
    Heal(self, 500, 0)
    HealSP(self, 300, 0)
    return 1
end
function SCR_BUFF_LEAVE_EVENT_1804_ARBOR_BUFF_6(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_EVENT_1804_ARBOR_BUFF_7(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_EVENT_1804_ARBOR_BUFF_7(self, buff, arg1, arg2, over)
end

function SCR_EVENT_1804_ARBOR_NPC_DUMMY_ENTER(self, pc)
    
end

function EVENT_1804_ARBOR_NPCEnter(self, sObj, msg, argObj, argStr, argNum)
    if GetZoneName(self) == 'c_Klaipe' then
        local npcList = {'npc_tool_merchants','npc_equipment_dealers','npc_accessary_merchant','npc_knight','npc_blacksmith','npc_combat_transport_section_1_market','npc_kristina','npc_rena','npc_henrika','npc_warehouse','npc_letizia'}
        local npcIndex = table.find(npcList,argObj.ClassName)
        if npcIndex > 0 then
            local now_time = os.date('*t')
            local month = now_time['month']
            local year = now_time['year']
            local day = now_time['day']
            local nowday = year..'/'..month..'/'..day
            
            local npcDlg = {'EVENT_1804_ARBOR_DLG2','EVENT_1804_ARBOR_DLG3','EVENT_1804_ARBOR_DLG4','EVENT_1804_ARBOR_DLG5','EVENT_1804_ARBOR_DLG6','EVENT_1804_ARBOR_DLG7','EVENT_1804_ARBOR_DLG8','EVENT_1804_ARBOR_DLG9','EVENT_1804_ARBOR_DLG10','EVENT_1804_ARBOR_DLG11','EVENT_1804_ARBOR_DLG12'}
            local sObj = GetSessionObject(self, 'ssn_klapeda')
            local timeIndex = EVENT_1804_ARBOR_NOW_TIME()
            
            if timeIndex >= 3 and timeIndex <= 4 and sObj.EVENT_1804_ARBOR_BALLOON1_DATE == 'None' then
                ShowOkDlg(self, npcDlg[npcIndex], 1)
                RunScript('GIVE_TAKE_SOBJ_ACHIEVE_TX', self, 'E_Balloon_1/1/E_Balloon_2/1/E_Balloon_3/1/E_Balloon_4/1/E_Balloon_5/1',nil,nil,nil,'EVENT_1804_ARBOR_BALLOON1','ssn_klapeda/EVENT_1804_ARBOR_BALLOON1_DATE/'..nowday)
            elseif timeIndex >= 5 and timeIndex <= 6 and sObj.EVENT_1804_ARBOR_BALLOON2_DATE == 'None'  then
                ShowOkDlg(self, npcDlg[npcIndex], 1)
                RunScript('GIVE_TAKE_SOBJ_ACHIEVE_TX', self, 'E_Balloon_7/1/E_Balloon_8/1/E_Balloon_9/1/E_Balloon_10/1',nil,nil,nil,'EVENT_1804_ARBOR_BALLOON2','ssn_klapeda/EVENT_1804_ARBOR_BALLOON2_DATE/'..nowday)
            end
        end
    end
end




function SCR_EVENT_1804_ARBOR_NPC_GEN_TS_BORN_ENTER(self)
end

function SCR_EVENT_1804_ARBOR_NPC_GEN_TS_BORN_UPDATE(self)
    local retflag = GetExProp(self, 'EVENT_1804_ARBOR_NPC_GEN_FLAG')
    if retflag ~= 1 then
        local timeIndex = EVENT_1804_ARBOR_NOW_TIME()
--        timeIndex = 0
        if timeIndex >= 3 then
            local x,y,z = GetPos(self)
            local npc =CREATE_NPC(self, 'NPC_GM2', x, y, z, 315, nil, GetLayer(self), self.Name, 'EVENT_1804_ARBOR_NPC')
            if npc ~= nil then
                SetExProp(self, 'EVENT_1804_ARBOR_NPC_GEN_FLAG', 1)
            end
        end
    end
end

function SCR_EVENT_1804_ARBOR_NPC_GEN_TS_BORN_LEAVE(self)
end

function SCR_EVENT_1804_ARBOR_NPC_GEN_TS_DEAD_ENTER(self)
end

function SCR_EVENT_1804_ARBOR_NPC_GEN_TS_DEAD_UPDATE(self)
end

function SCR_EVENT_1804_ARBOR_NPC_GEN_TS_DEAD_LEAVE(self)
end

function SCR_EVENT_1804_ARBOR_NPC_DIALOG(self, pc)
    local select = ShowSelDlg(pc, 0, 'EVENT_1804_ARBOR_DLG15', ScpArgMsg('EVENT_1804_ARBOR_MSG9'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
    local timeIndex = EVENT_1804_ARBOR_NOW_TIME()
--    timeIndex = 3
    if select == 1 then
        if timeIndex >= 3 and timeIndex <= 4 then
            local point = 200
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1804_ARBOR_MSG10","POINT",point), 10)
            SCR_GIMMICK_QUICKNESS_TEST1_START(pc)
        elseif timeIndex >= 5 and timeIndex <= 6 then
            SCR_MOLE_BINGO_START(pc)
        end
    end
    
end

function EVENT_1804_ARBOR_NPC_GIMMICK_REWARD_1(pc)
    RunScript('GIVE_ITEM_TX',pc, 'EVENT_1804_ARBOR_GROW_CRYSTAL_3_4', 3, 'EVENT_1804_ARBOR_DROP')
end
function EVENT_1804_ARBOR_NPC_GIMMICK_REWARD_2(pc)
    RunScript('GIVE_ITEM_TX',pc, 'EVENT_1804_ARBOR_GROW_CRYSTAL_5_6', 3, 'EVENT_1804_ARBOR_DROP')
end


function SCR_USE_EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_1_2(pc)
    local itemList = {{'misc_BlessedStone', 1, 1000},
                        {'Premium_item_transcendence_Stone', 1, 500},
                        {'Premium_Enchantchip14', 1, 1500},
                        {'Drug_MSPD2_1h_NR', 1, 1500},
                        {'Premium_boostToken_14d', 1, 1500},
                        {'Premium_boostToken02_event01', 1, 1000},
                        {'Premium_boostToken03_event01', 1, 500},
                        {'Event_Goddess_Statue', 1, 1000},
                        {'Adventure_Reward_Seed', 1, 1500}
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
	TxGiveItem(tx, itemList[targetIndex][1], itemList[targetIndex][2], 'EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_1_2');
	local ret = TxCommit(tx);
	
	if ret == 'SUCCESS' then
	    SCR_SEND_NOTIFY_REWARD(pc, GetClassString('Item','EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_1_2','Name'), ScpArgMsg('LVUP_REWARD_MSG1','ITEM', GetClassString('Item', itemList[targetIndex][1],'Name'),'COUNT', itemList[targetIndex][2]))
	end
end


function SCR_USE_EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_3_4(pc)
    local itemList = {{'misc_BlessedStone', 1, 1000},
                        {'Premium_item_transcendence_Stone', 1, 500},
                        {'Premium_Enchantchip14', 1, 1000},
                        {'Drug_MSPD2_1h_NR', 1, 1000},
                        {'Event_Reinforce_100000coupon', 1, 1500},
                        {'Moru_Silver', 1, 500},
                        {'Moru_Gold_14d', 1, 300},
                        {'Moru_Diamond_14d', 1, 100},
                        {'legend_reinforce_card_lv2', 1, 200},
                        {'legend_reinforce_card_lv1', 1, 400},
                        {'card_Xpupkit01_500_14d', 1, 2000},
                        {'misc_gemExpStone_randomQuest4_14d', 1, 1500}
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
	TxGiveItem(tx, itemList[targetIndex][1], itemList[targetIndex][2], 'EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_3_4');
	local ret = TxCommit(tx);
	
	if ret == 'SUCCESS' then
	    SCR_SEND_NOTIFY_REWARD(pc, GetClassString('Item','EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_3_4','Name'), ScpArgMsg('LVUP_REWARD_MSG1','ITEM', GetClassString('Item', itemList[targetIndex][1],'Name'),'COUNT', itemList[targetIndex][2]))
	end
end


function SCR_USE_EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_5_6(pc)
    local itemList = {{'misc_BlessedStone', 1, 1000},
                        {'Premium_item_transcendence_Stone', 1, 500},
                        {'Premium_Enchantchip14', 1, 1000},
                        {'Drug_MSPD2_1h_NR', 1, 1000},
                        {'Point_Stone_100', 1, 3000},
                        {'Ability_Point_Stone_500', 1, 2000},
                        {'Ability_Point_Stone', 1, 1500}
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
	TxGiveItem(tx, itemList[targetIndex][1], itemList[targetIndex][2], 'EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_5_6');
	local ret = TxCommit(tx);
	
	if ret == 'SUCCESS' then
	    SCR_SEND_NOTIFY_REWARD(pc, GetClassString('Item','EVENT_1804_ARBOR_GROW_CRYSTAL_CUBE_5_6','Name'), ScpArgMsg('LVUP_REWARD_MSG1','ITEM', GetClassString('Item', itemList[targetIndex][1],'Name'),'COUNT', itemList[targetIndex][2]))
	end
end


function SCR_USE_EVENT_1804_ARBOR_ACHIEVE_BOX(self,argObj,BuffName,arg1,arg2)
    local tx = TxBegin(self);
    TxAddAchievePoint(tx, 'EVENT_1804_ARBOR_ACHIEVE', 1)
    local ret = TxCommit(tx);
end

function SCR_PRE_EVENT_1804_ARBOR_ACHIEVE_BOX(self)
    local value = GetAchievePoint(self, 'EVENT_1804_ARBOR_ACHIEVE')
    if value == 0 then
        return 1
    else
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1802_NEWYEAR_MSG2"), 5);
    end
    
    return 0;
end
