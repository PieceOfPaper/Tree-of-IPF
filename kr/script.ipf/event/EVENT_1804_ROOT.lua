function SMARTGEN_EVENT_ZONE_TABLE()
    local eventZone = {'f_siauliai_11_re', 'f_gele_57_4', 'f_huevillage_58_3', 'f_katyn_12', 'f_rokas_31', 'f_orchard_34_2', 'f_katyn_13', 'd_startower_60_1', 'd_velniasprison_54_1', 'd_abbey_39_4', 'f_flash_64', 'f_coral_32_2', 'f_katyn_45_1', 'f_tableland_74', 'f_castle_20_3', 'f_maple_25_2', 'id_catacomb_25_4', 'f_bracken_43_2', 'f_maple_23_2', 'f_whitetrees_21_2', 'f_whitetrees_56_1', 'f_rokas_24', 'f_farm_47_3', 'f_siauliai_50_1', 'f_remains_40', 'f_pilgrimroad_46'}
    return eventZone
end

function SCR_SMARTGEN_TIMER_STRIGGER_EVENT(self, sObj, remainTime)
    local aObj = GetAccountObj(self)
    local now_time = os.date('*t')
    local month = now_time['month']
    local year = now_time['year']
    local day = now_time['day']
    local nowday = year..'/'..month..'/'..day
    
    if aObj.EVENT_1804_ROOT_DATE == nowday then
        SetTimeSessionObject(self, sObj, 3, 3000, "None")
        return
    end
    
    local timeMin = 270
    local timeMax = 360
--    local timeMin = 5
--    local timeMax = 5
    
    if GetLayer(self) ~= 0 then
        return
    end
    
    
    local sTriggerTimeBasic_Event = GetClassNumber('SessionObject', sObj.ClassName, 'EVENT_STrigger_Time')
    
    if sObj.EVENT_CurrentZone ~= GetZoneName(self) then
        sObj.EVENT_STrigger_Time = sTriggerTimeBasic_Event
        sObj.EVENT_CurrentZone = GetZoneName(self)
    end
    
    if sTriggerTimeBasic_Event >= sObj.EVENT_STrigger_Time then
        sObj.EVENT_STrigger_Time = IMCRandom(timeMin, timeMax)
    end
    --time counting
    if IsBattleState(self) == 1 then
        sObj.EVENT_STrigger_Time  = sObj.EVENT_STrigger_Time - 3
    end
    if sObj.EVENT_STrigger_Time > sTriggerTimeBasic_Event and sObj.EVENT_STrigger_Time <= 0 then
        --create summon trigger
        sObj.EVENT_STrigger_Time = sTriggerTimeBasic_Event
        
        local pos_list = SCR_CELLGENPOS_LIST(self, 'Front1', 0)
        local mon = CREATE_NPC(self, 'rootcrystal_05', pos_list[1][1], pos_list[1][2], pos_list[1][3], 315, 'Monster', 0, ScpArgMsg('EVENT_1804_ROOT_MSG1'), nil, nil, nil, nil, nil, 'EVENT_TORCH', nil, nil, nil, nil, nil, nil)
        if mon ~= nil then
            ChangeScale(mon, 1.2, 0)
            SetLifeTime(mon, 300)
            
            AttachEffect(mon, 'I_warrior_gungho_loop_light', 2, "MID", 10,12,0,0)
            AttachEffect(mon, 'I_warrior_buff_warcry_loop', 1, "BOT")
        end
    end
end




function SCR_EVENT_TORCH_TS_BORN_ENTER(self)
end

function SCR_EVENT_TORCH_TS_BORN_UPDATE(self)
end

function SCR_EVENT_TORCH_TS_BORN_LEAVE(self)
end

function SCR_EVENT_TORCH_TS_DEAD_ENTER(self)
--PlayAnim(self, 'on', 0);
    local lastAttacker = GetLastAttacker(self)
    if lastAttacker ~= nil then
        local partyMemberList, partyMemberCnt = GetPartyMemberList(lastAttacker, PARTY_NORMAL, 300)
        RunScript('EVENT_TORCH_REWARD',lastAttacker)
        if partyMemberCnt > 0 then
            for i = 1, partyMemberCnt do
                if IsSameActor(partyMemberList[i], lastAttacker) == 'NO' then
                    RunScript('EVENT_TORCH_REWARD',partyMemberList[i])
                end
            end
        end
    end
end

function SCR_EVENT_TORCH_TS_DEAD_UPDATE(self)

end

function SCR_EVENT_TORCH_TS_DEAD_LEAVE(self)
end

function EVENT_TORCH_REWARD(pc)
    local now_time = os.date('*t')
    local month = now_time['month']
    local year = now_time['year']
    local day = now_time['day']
    local nowday = year..'/'..month..'/'..day
    local aObj = GetAccountObj(pc)
    
    if aObj.EVENT_1804_ROOT_DATE ~= nowday then
        local rand = IMCRandom(1,10000)
        local rewardIndex = 1
        if rand <= 5000 then
            rewardIndex = 1
        elseif rand <= 9000 then
            rewardIndex = 2
        elseif rand <= 9750 then
            rewardIndex = 3
        else
            rewardIndex = 4
        end
        local rewardList = {'buff','Point_Stone_100','Ability_Point_Stone_500','Ability_Point_Stone'}
        
        local rand2 = IMCRandom(1,10000)
        
        local tx = TxBegin(pc)
        TxSetIESProp(tx, aObj, 'EVENT_1804_ROOT_DATE', nowday)
        if rewardIndex >= 2 and rewardIndex <= 4 then
            TxGiveItem(tx, rewardList[rewardIndex], 1, 'EVENT_1804_ROOT')
        end
        if rand2 <= 3000 then
            TxGiveItem(tx, 'EVENT_1804_ROOT_BONUS_CUBE', 1, 'EVENT_1804_ROOT')
        end
        local ret = TxCommit(tx)
        if ret == 'SUCCESS' then
            local msg =''
            if rewardIndex >= 2 and rewardIndex <= 4 then
                msg = ScpArgMsg('LVUP_REWARD_MSG1','ITEM', GetClassString('Item', rewardList[rewardIndex],'Name'),'COUNT', 1)
            else
                AddBuff(pc, pc, 'EVENT_1804_ROOT_BUFF_1', 1, 0, 1800000, 1);
                msg = ScpArgMsg('GM_BUFF_MSG1','BUFF', GetClassString('Buff', 'EVENT_1804_ROOT_BUFF_1','Name'))
            end
            if rand2 <= 3000 then
                msg = msg..', '..ScpArgMsg('LVUP_REWARD_MSG1','ITEM', GetClassString('Item', 'EVENT_1804_ROOT_BONUS_CUBE','Name'),'COUNT', 1)
            end
            SCR_SEND_NOTIFY_REWARD(pc, ScpArgMsg('EVENT_1804_ROOT_MSG1'), msg)
        end
    else
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1804_ROOT_MSG2"), 5);
    end
end




function SCR_BUFF_ENTER_EVENT_1804_ROOT_BUFF_1(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 2;
end

function SCR_BUFF_UPDATE_EVENT_1804_ROOT_BUFF_1(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_EVENT_1804_ROOT_BUFF_1(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 2;
end




function SCR_USE_EVENT_1804_ROOT_ACHIEVE_BOX(self,argObj,BuffName,arg1,arg2)
    local tx = TxBegin(self);
    TxAddAchievePoint(tx, 'EVENT_1804_ROOT_ACHIEVE', 1)
    local ret = TxCommit(tx);
end

function SCR_PRE_EVENT_1804_ROOT_ACHIEVE_BOX(self)
    local value = GetAchievePoint(self, 'EVENT_1804_ROOT_ACHIEVE')
    if value == 0 then
        return 1
    else
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_1802_NEWYEAR_MSG2"), 5);
    end
    
    return 0;
end