function MISSION_SURVIVAL_EVENT2_ZONEENTER(pc)
    MISSION_SURVIVAL_EVENT2_INDUN_COUNT_SET(pc)
    if GetZoneName(pc) == 'c_Klaipe' or GetZoneName(pc) == 'c_orsha' then
        Heal(pc, pc.MHP, 0)
    end
end

function MISSION_SURVIVAL_EVENT2_INDUN_COUNT_SET(pc)
    local aObj = GetAccountObj(pc)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local nowday = year..'/'..month..'/'..day
    
    local pcEtc = GetETCObject(pc)
    local tx = TxBegin(pc)
    if aObj.MISSION_SURVIVAL_EVENT2_REWARD_DATE == nowday then
        if pcEtc.InDunCountType_8000 ~= aObj.MISSION_SURVIVAL_EVENT2_REWARD_COUNT then
            TxSetIESProp(tx, pcEtc, 'InDunCountType_8000', aObj.MISSION_SURVIVAL_EVENT2_REWARD_COUNT)
        end
    else
        if pcEtc.InDunCountType_8000 ~= 0 then
            TxSetIESProp(tx, pcEtc, 'InDunCountType_8000', 0)
        end
    end
    local ret = TxCommit(tx)
end

function SCR_MISSION_SURVIVAL_EVENT2_START_NPC_DIALOG(self, pc)
    MISSION_SURVIVAL_EVENT2_INDUN_COUNT_SET(pc)
    
    local aObj = GetAccountObj(pc)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local nowday = year..'/'..month..'/'..day
    
    local select = ShowSelDlg(pc, 0, 'MISSION_SURVIVAL_EVENT2_DLG1', ScpArgMsg('EVENT_1804_ARBOR_MSG9'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
    if select == 1 then
        
        if aObj ~= nil then
            if aObj.MISSION_SURVIVAL_EVENT2_REWARD_DATE ~= nowday or aObj.MISSION_SURVIVAL_EVENT2_REWARD_COUNT < 2 then
                local pet = GetSummonedPet(pc);
                if pet == nil or pet == "None" then 
                else 
                    SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('MISSION_SURVIVAL_EVENT2_MSG3'), 5);
                    return
                end
                if pc.Lv >= 30 then
                    local missionID = OpenMissionRoom(pc, 'MISSION_SURVIVAL_EVENT2', "");
                    ReqMoveToMission(pc, missionID)
                else
                    SendSysMsg(pc, 'NeedMorePcLevel')
                end
--                REQ_MOVE_TO_INDUN(pc, "MISSION_SURVIVAL_EVENT2", 1)
--                AUTOMATCH_INDUN_DIALOG(pc, nil, 'MISSION_SURVIVAL_EVENT2')
            else
                ShowOkDlg(pc, 'MISSION_SURVIVAL_EVENT2_DLG2', 1)
            end
        end
    end
end

function SCR_MISSION_SURVIVAL_EVENT2_BOX_DIALOG(self, pc)
    SetHide(pc, 1)
    AddBuff(self, pc, 'Safe', 1, 0, 600000, 1)
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local nowday = year..'/'..month..'/'..day
    
    for i = 1, 10 do
        local openPC = GetExArgObject(self, 'OPEN_PC_'..i)
        if openPC ~= nil then
            if IsSameActor(pc, openPC) == 'YES' then
                local select = ShowSelDlg(pc, 0, 'MISSION_SURVIVAL_EVENT2_DLG5', ScpArgMsg('MISSION_SURVIVAL_EVENT2_MSG2'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
                if select == 1 then
                    RemoveBuff(pc, 'MISSION_SURVIVAL_EVENT2')
                    Heal(pc, pc.MHP * 3, 0)
                    MoveZone(pc, 'c_Klaipe', 21, 149, 344)
                end
                return
            end
        end
    end
    
    local aObj = GetAccountObj(pc)
    if aObj ~= nil then
        if aObj.MISSION_SURVIVAL_EVENT2_REWARD_DATE ~= nowday or aObj.MISSION_SURVIVAL_EVENT2_REWARD_COUNT < 2 then
            local select = ShowSelDlg(pc, 0, 'MISSION_SURVIVAL_EVENT2_DLG3', ScpArgMsg('MISSION_SURVIVAL_EVENT2_MSG1'), ScpArgMsg('Auto_JongLyo'))
            if select == 1 then
                local tx = TxBegin(pc)
                if aObj.MISSION_SURVIVAL_EVENT2_REWARD_DATE == nowday then
                    TxSetIESProp(tx, aObj, 'MISSION_SURVIVAL_EVENT2_REWARD_COUNT', aObj.MISSION_SURVIVAL_EVENT2_REWARD_COUNT + 1)
                else
                    TxSetIESProp(tx, aObj, 'MISSION_SURVIVAL_EVENT2_REWARD_DATE', nowday)
                    TxSetIESProp(tx, aObj, 'MISSION_SURVIVAL_EVENT2_REWARD_COUNT', 1)
                end
                
                TxGiveItem(tx, 'MISSION_SURVIVAL_EVENT2_CUBE', 1, 'MISSION_SURVIVAL_EVENT2')
                local ret = TxCommit(tx)
                if ret == 'SUCCESS' then
                    local cmd = GetMGameCmd(pc)
                    cmd:SetUserValue("MISSION_END_CHECK", 300)
                    for i = 1, 10 do
                        local openPC = GetExArgObject(self, 'OPEN_PC_'..i)
                        if openPC == nil then
                            SetExArgObject(self, 'OPEN_PC_'..i, pc)
                            break
                        end
                    end
                    PlayAnimLocal(self, pc, 'OPEN', 1)
                end
            end
        else
            ShowOkDlg(pc, 'MISSION_SURVIVAL_EVENT2_DLG4', 1)
            return
        end
    end
end

function INIT_MISSION_SURVIVAL_EVENT2(pc)
    if pc ~= nil then
        AddBuff(pc, pc, 'MISSION_SURVIVAL_EVENT2')
    end
end

function GET_MISSION_SURVIVAL_EVENT2_MON1(self, zoneObj, arg2, zone, layer)
    local MISSION_SURVIVAL_EVENT2_MON1_MONLIST = GET_MISSION_SURVIVAL_EVENT2_MON1_MONLIST()
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    local nowAddHour = SCR_DATE_TO_YHOUR_BASIC_2000(year,month,day,hour)
    
	local index = (nowAddHour+min) % #MISSION_SURVIVAL_EVENT2_MON1_MONLIST
	
	index = index + 1
	return MISSION_SURVIVAL_EVENT2_MON1_MONLIST[index]
end

function GET_MISSION_SURVIVAL_EVENT2_MON3(self, zoneObj, arg2, zone, layer)
    local MISSION_SURVIVAL_EVENT2_MON1_MONLIST = GET_MISSION_SURVIVAL_EVENT2_MON1_MONLIST()
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    local nowAddHour = SCR_DATE_TO_YHOUR_BASIC_2000(year,month,day,hour)
    
	local index = (nowAddHour * 2+min) % #MISSION_SURVIVAL_EVENT2_MON1_MONLIST
	
	index = index + 1
	return MISSION_SURVIVAL_EVENT2_MON1_MONLIST[index]
end

function GET_MISSION_SURVIVAL_EVENT2_MON1_MONLIST()
    local MISSION_SURVIVAL_EVENT2_MON1_MONLIST = {'Spion_red','defender_spider_red','Minos_green','Dumaro_yellow','Repusbunny_purple','Nuka_brown','rondo_red','Rubabos_red','Lizardman','operor','Beetle'}
    return MISSION_SURVIVAL_EVENT2_MON1_MONLIST
end

function GET_MISSION_SURVIVAL_EVENT2_MON2_MONLIST()
    local MISSION_SURVIVAL_EVENT2_MON2_MONLIST = {'aclis_angel','claro','atti','jelly_belly','lapindion','lapinel'}
    return MISSION_SURVIVAL_EVENT2_MON2_MONLIST
end

function GET_MISSION_SURVIVAL_EVENT2_MON2(self, zoneObj, arg2, zone, layer)
    local MISSION_SURVIVAL_EVENT2_MON2_MONLIST = GET_MISSION_SURVIVAL_EVENT2_MON2_MONLIST()
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local day = now_time['day']
    local hour = now_time['hour']
    local min = now_time['min']
    local nowAddHour = SCR_DATE_TO_YHOUR_BASIC_2000(year,month,day,hour)
    
	local index = (nowAddHour * 2+min) % #MISSION_SURVIVAL_EVENT2_MON2_MONLIST
	
	index = index + 1
	return MISSION_SURVIVAL_EVENT2_MON2_MONLIST[index]
end

function SCR_MISSION_SURVIVAL_EVENT2_CRYSTAL_ENTER(self,pc)
    TakeDamage(self, pc, "None", 1000, 'Melee', 'None', 'AbsoluteDamage', HIT_FIRE, HITRESULT_BLOW, 0, 0);
end

function SCR_BUFF_ENTER_MISSION_SURVIVAL_EVENT2(self, buff, arg1, arg2, over)
    SetExProp(buff, "ADD_FIXMSPD", self.FIXMSPD_BM)
    SetExProp(buff, "ADD_MHP", self.MHP_BM)
    SetExProp(buff, "ADD_DR", self.DR_BM)
    SetExProp(buff, "ADD_BLK", self.BLK_BM)
    
    SetExProp(buff, "ADD_MHP_BM", -(self.MHP - 1))
    
    self.FIXMSPD_BM = 40
    self.MHP_BM = -(self.MHP - 1)
    self.DR_BM = -(self.DR)
    self.BLK_BM = -(self.BLK)
    EnableItemUse(self, 0)
    
    
--    if IS_PC(self) == true then
--        EnablePreviewSkillRange(self, 1);
--    end
end

function SCR_BUFF_UPDATE_MISSION_SURVIVAL_EVENT2(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) ~= 'f_pilgrimroad_41_1_event' then
        return 0;
    end
    
    if self.MHP > 1 then
        local mhp = GetExProp(buff, "ADD_MHP_BM")
        local add = mhp -( self.MHP - 1)
        self.MHP_BM = add
        SetExProp(buff, "ADD_MHP_BM", add)
        Invalidate(self, "MHP_BM")
        Invalidate(self, "MHP")
    end
    
    return 1
end

function SCR_BUFF_LEAVE_MISSION_SURVIVAL_EVENT2(self, buff, arg1, arg2, over)
    local fixmspd = GetExProp(buff, "ADD_FIXMSPD")
    local mhp = GetExProp(buff, "ADD_MHP")
    local dr = GetExProp(buff, "ADD_DR")
    local blk = GetExProp(buff, "ADD_BLK")
    
    self.FIXMSPD_BM = fixmspd
    self.MHP_BM = mhp
    self.DR_BM = dr
    self.BLK_BM = blk
    EnableItemUse(self, 1)
--    self.FIXMSPD_BM = 0
--    Invalidate(self, 'MSPD');
--    EnableItemUse(self, 1)
--    if IS_PC(self) == true then
--        EnablePreviewSkillRange(self, 0);
--    end
end



function SCR_USE_MISSION_SURVIVAL_EVENT2_ACHIEVE_BOX(self,argObj,BuffName,arg1,arg2)
    local tx = TxBegin(self);
    TxAddAchievePoint(tx, 'MISSION_SURVIVAL_EVENT2_ACHIEVE', 1)
    local ret = TxCommit(tx);
end

function SCR_PRE_MISSION_SURVIVAL_EVENT2_ACHIEVE_BOX(self)
    local value = GetAchievePoint(self, 'MISSION_SURVIVAL_EVENT2_ACHIEVE')
    if value == 0 then
        return 1
    else
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1802_NEWYEAR_MSG2"), 5);
    end
    
    return 0;
end

function SCR_USE_MISSION_SURVIVAL_EVENT2_CUBE(self, argObj, argStr, arg1, arg2)
    local itemList = {{'Moru_Diamond_14d', 1, 50},
                        {'Moru_Gold_14d', 1, 500},
                        {'Moru_Silver', 1, 1000},
                        {'misc_gemExpStone09_14d', 1, 500},
                        {'misc_gemExpStone_randomQuest4_14d', 1, 1000},
                        {'Premium_Enchantchip14', 1, 550},
                        {'RestartCristal', 1, 900},
                        {'MISSION_SURVIVAL_EVENT2_ACHIEVE_BOX', 1, 700},
                        {'Drug_MSPD2_1h_NR', 1, 1000},
                        {'Premium_dungeoncount_Event', 1, 1000},
                        {'Premium_indunReset_14d', 1, 600},
                        {'EVENT_1712_SECOND_CHALLENG_14d', 1, 1000},
                        {'ChallengeModeReset_14d', 1, 600},
                        {'Premium_boostToken_14d', 1, 600}
                    }
    SCR_EVENT_RANDOM_BOX_REWARD_FUNC(self, 'MISSION_SURVIVAL_EVENT2_CUBE', itemList, 'MISSION_SURVIVAL_EVENT2_CUBE')
end
