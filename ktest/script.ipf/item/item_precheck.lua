function SCR_PRECHECK_CONSUME(self)
    if OnKnockDown(self) == 'NO' then
        return 1;
    end
    
    return 0;
end

function SCR_PRECHECK_CONSUME_WARP(self)
    return SCR_PRECHECK_CONSUME(self);
--  local result = SCR_QUEST_CHECK(self, 'SIAUL_WEST_WOOD_SPIRIT')
--    if result == 'COMPLETE' then
--      return 1;
--    else
--        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_SyaulLei_SeoJjogSup_KweSeuTeu_JinHaengeul_wanLyoHaeya_DoepNiDa."), 3);
--    end
--    return 0;
end

function SCR_PRECHECK_NO(self)

    return 0;

end

function SCR_PRECHECK_CONSUME_CMINE(self)
    local currentZone = GetZoneName(self)
    if currentZone == "d_cmine_8" or currentZone == "d_cmine_9" then
        return SCR_PRECHECK_CONSUME(self);
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("use_in_cmine"), 3);
    end

    return 0;
end

function SCR_PRE_HiddenJobUnlock(self, argstring, argnum1, argnum2)
    if SCR_HIDDEN_JOB_IS_UNLOCK(self, argstring) == 'NO' then
        local nowjobIES = GetClass('Job', self.JobName)
        local itemjobIES = GetClass('Job', argstring)
        if nowjobIES.CtrlType == itemjobIES.CtrlType then
            return 1
        else
            SysMsg(self, "Instant", ScpArgMsg("HIDDEN_JOB_UNLOCK_VIEW_MSG3"))
        end
    else
        SysMsg(self, "Instant", ScpArgMsg("HIDDEN_JOB_UNLOCK_VIEW_MSG2"))
    end
    return 0
end

function SCR_PRECHECK_USEITEM_QUESTSTART(self, argstring, argnum1, argnum2)
    local questIES = GetClass('QuestProgressCheck', argstring)
    if questIES ~= nil then
        local sObj = GetSessionObject(self, 'ssn_klapeda')
        if sObj ~= nil then
            if sObj[questIES.QuestPropertyName] < CON_QUESTPROPERTY_MIN then
                local quest_state = SCR_QUEST_CHECK(self,argstring)
                if quest_state == 'POSSIBLE' then
                    return 1;
                else
                    return 0;
                end
            elseif sObj[questIES.QuestPropertyName] >= CON_QUESTPROPERTY_END then
                SendAddOnMsg(self, "NOTICE_Dm_Clear", questIES.Name..ScpArgMsg("Auto__KweSeuTeu_wanLyoSangTae!"), 3);
                return 0;
            else
                return 0;
            end
        else
            return 0;
        end
    end
end

function SCR_PRECHECK_USEITEM_InviteTheBishop_Box(self, argstring, argnum1, argnum2)
    local sObj = GetSessionObject(self,'ssn_klapeda')
    if sObj.KLAPEDA_BISHOP05 >= 300 then
        return 1;
    else
        SysMsg(self, "Instant", ScpArgMsg("Auto_SangJaLeul_yeoleoBoLyeoKo_HaessJiMan_yeolLiJi_anassDa."));
        return 0;
    end
end

function SCR_TAG_ICEORB(self, argstring, argnum1, argnum2)
    local tagger_ssn = GetSessionObject(self,'ssn_tag_tagger')
    local player_ssn = GetSessionObject(self,'ssn_tag_player')
    local tag_ice_buff = IsBuffApplied(self, 'TagIce')
    
    if player_ssn == nil then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_eoleum_Ttaeng_Jung_Sayong_KaNeung"), 3);
    elseif tagger_ssn == nil and tag_ice_buff == 'NO' then
        AddBuff(self,self,'TagIce',1,0,0,1)
    elseif tagger_ssn ~= nil then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_SulLaeNeun_Sayong_BulKa"), 3);
    elseif tag_ice_buff == 'YES' then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_HyeonJae_eoleum"), 3);
    end
end

function SCR_TAG_ICEHAMMER(self, argstring, argnum1, argnum2)
    local player_ssn = GetSessionObject(self,'ssn_tag_player')
    local tagger_ssn = GetSessionObject(self,'ssn_tag_tagger')
    
    if player_ssn ~= nil and tagger_ssn == nil then
        local self_ice_buff = IsBuffApplied(self, 'TagIce')
        
        if self_ice_buff == 'NO' or player_ssn.IceRecovery > 0 then
            if self_ice_buff == 'YES' then
                player_ssn.IceRecovery = player_ssn.IceRecovery - 1
            end
                
            local fndList, fndCount = SelectObject(self, 10, 'ALL');
            for i = 1, fndCount do
                if fndList[i].ClassName == 'PC' then
                    local target_ssn = GetSessionObject(fndList[i],'ssn_tag_player')
                    
                    if target_ssn ~= nil then
                        local tag_ice_buff = IsBuffApplied(fndList[i], 'TagIce')
                        
                        if tag_ice_buff == 'YES' then
                            RemoveBuff(fndList[i], 'TagIce')
                            PlayEffect(fndList[i], 'healing', 6.0, 1, "BOT", 1);
                        end
                    end
                end
            end
        end
    elseif player_ssn ~= nil and tagger_ssn ~= nil then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Auto_SulLaeNeun_Sayong_BulKa"), 3);
    end
end



function SCR_PRE_PetScroll_Haming(self, argstring, argnum1, argnum2)
    return 1
end

function SCR_PRECHECK_WARP_CITY(self, argstring)
    local currentZone = GetZoneName(self)
    
    if currentZone ~= argstring then
        return 1;
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CanNotUseInSameZone"), 3);
        return 0;
    end
end

function SCR_PRE_Event_ArborDay_Costume_Box(self)
    if OnKnockDown(self) ~= 'NO' then
        return 0
    end
    
    if IsIndun(self) ~= 1 and IsPVPServer(self) ~= 1 and IsMissionInst(self) ~= 1 then
        return 1
    end
    
    return 0
end

function SCR_PRECHECK_CONSUME_ADDDPARTS(self)
    local totalCount = 300;
    
    local abil = GetAbility(self, 'Necromancer21')
    if abil ~= nil then
        totalCount = totalCount + abil.Level * 100
    end
    
    local etc = GetETCObject(self);
    local curPartsCnt = etc.Necro_DeadPartsCnt;
    
    if curPartsCnt < totalCount then
        if OnKnockDown(self) == 'NO' then
            return 1;
        end
    end
    
    return 0;
end

function SCR_PRE_PopUpBook(self, argstring, argnum1, argnum2)
    local popupbookNPC =  GetExArgObject(self, 'POPUPBOOK_NPC')
    if popupbookNPC ~= nil then
        local orgelNPC = GetExArgObject(popupbookNPC, 'ORGEL_NPC')
        if orgelNPC ~= nil then
            Dead(orgelNPC)
        end
        SysMsg(self, 'Instant', ScpArgMsg('PopUpBook_MSG5'))
        Dead(popupbookNPC)
        SetExArgObject(self, 'POPUPBOOK_NPC', nil)
        SetExArgObject(popupbookNPC, 'POPUPBOOK_PC', nil)
        return 0
    end
    
    local nowLayer = GetLayer(self)
    if IsIndun(self) == 1 or IsPVPServer(self) == 1 or IsMissionInst(self) == 1 then
        SysMsg(self, 'Instant', ScpArgMsg('PopUpBook_MSG3'))
        return 0
    end
    if nowLayer > 0 then
        SysMsg(self, 'Instant', ScpArgMsg('PopUpBook_MSG4'))
        return 0
    end
    
    
    local pcx, pcy, pcz = GetPos(self)
    local centerx, centery, centerz
    local zoneID = GetZoneInstID(self)
    centerx = pcx -45
    centery = pcy
    centerz = pcz +45
    
--    local npc1 = CREATE_NPC(self, 'Onion', centerx, centery, centerz, 0, "Peaceful", GetLayer(self), nil, nil, nil, 1, 1, nil, 'MON_DUMMY')
--    local npc2 = CREATE_NPC(self, 'Onion', centerx - argnum1, centery, centerz -argnum2, 0, "Peaceful", GetLayer(self), nil, nil, nil, 1, 1, nil, 'MON_DUMMY')
--    local npc3 = CREATE_NPC(self, 'Onion', centerx + argnum2, centery, centerz + argnum1, 0, "Peaceful", GetLayer(self), nil, nil, nil, 1, 1, nil, 'MON_DUMMY')
--    local npc4 = CREATE_NPC(self, 'Onion', centerx - argnum2, centery, centerz -argnum1, 0, "Peaceful", GetLayer(self), nil, nil, nil, 1, 1, nil, 'MON_DUMMY')
--    local npc5 = CREATE_NPC(self, 'Onion', centerx + argnum1, centery, centerz + argnum2, 0, "Peaceful", GetLayer(self), nil, nil, nil, 1, 1, nil, 'MON_DUMMY')
--    Chat(npc1, 'Center')
--    Chat(npc2, '1111111')
--    Chat(npc3, '222222222')
--    Chat(npc4, '3333333')
--    Chat(npc5, '44444')
    
    if IsValidPos(zoneID, centerx, centery, centerz) == 'YES' and IsValidPos(zoneID, centerx - argnum1, centery, centerz -argnum2) == 'YES' and IsValidPos(zoneID, centerx + argnum2, centery, centerz + argnum1) == 'YES' and IsValidPos(zoneID, centerx - argnum2, centery, centerz -argnum1) == 'YES' and IsValidPos(zoneID, centerx + argnum1, centery, centerz + argnum2) == 'YES' then
    else
        SysMsg(self, 'Instant', ScpArgMsg('PopUpBook_MSG2'))
        return 0
    end
    
    local objList, objCnt = GetWorldObjectListByPos(zoneID, nowLayer, centerx, centery, centerz, 'MON', 88)
    for i = 1, objCnt do
        if GetPropType(objList[i], 'OBB') ~= nil then
            if string.upper(objList[i].OBB) ~= 'NO' and string.upper(objList[i].OBB) ~= 'NONE' and objList[i].OBBSize ~= "0;0;0" and IsDead(objList[i]) == 0 then
                SysMsg(self, 'Instant', ScpArgMsg('PopUpBook_MSG1'))
                return 0
            end
        end
    end
    
    local objListPop, objCntPop = GetWorldObjectListByPos(zoneID, nowLayer, centerx, centery, centerz, 'MON', 150)
    for i = 1, objCntPop do
        if IsDead(objListPop[i]) == 0 then
            local isPopUpBook = GetExArgObject(objListPop[i], 'POPUPBOOK_PC')
            if isPopUpBook ~= nil then
                SysMsg(self, 'Instant', ScpArgMsg('PopUpBook_MSG6'))
                return 0
            end
        end
    end
    
    return 1
end

function SCR_PRECHECK_CONSUME_SUMMONORB(self)
    local curMap = GetZoneName(self);
    local mapCls = GetClass("Map", curMap);
    
    if mapCls.MapType == 'City' then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("NotAllowedInTown"), 3);
        return 0;
    end
    
    if mapCls.ClassName == 'c_firemage_event' then -- steam event
        return 0;
    end

    if IsJoinColonyWarMap(self) == 1 then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("ThisLocalUseNot"), 3);
        return 0;
    end

    return 1;
end

function SCR_PRECHECK_CONSUME_ZOMBIECAPSUL(self)
    local curMap = GetZoneName(self);
    local mapCls = GetClass("Map", curMap);
    if mapCls.MapType == 'City' and mapCls.ClassName ~= 'pvp_Mine' then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("NotAllowedInTown"), 3);
        return 0;
    end
    
    if mapCls.ClassName == 'c_firemage_event' then -- steam event
        return 0;
    end
    
    local skl = GetSkill(self, "Bokor_Zombify");
    if skl == nil then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("NoHaveZombiefySkill"), 3);
        return 0;
    end
    
    local list, cnt = GetZombieSummonList(self)
    local maxZombieCount = GET_MAX_ZOMBIE_COUNT(self, skl.Level);
    if cnt >= maxZombieCount then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("IsMaxCountZombie"), 3);
        return 0;
    end
    
    return 1;
end

function SCR_PRECHECK_ISRANK_1(self)
    local rank = GetTotalJobCount(self);
    local jobLv = GetJobLv(self);
        
    if jobLv == 15 then 
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseInMaxLv"), 3);
        return 0;
    end
    
    if rank == 1 then
        return 1;
    elseif rank > 1 then
        ExecClientScp(self, 'RANKRESET_DELETE_RANK_CARD("jexpCard_UpRank2")');
        return 0;
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseRank","Rank",1), 3);
        return 0;
    end
    return 0;
    
end

function SCR_PRECHECK_ISRANK_2(self)
    local rank = GetTotalJobCount(self);
    local jobLv = GetJobLv(self);
        
    if jobLv == 15 then 
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseInMaxLv"), 3);
        return 0;
    end
        
    if rank == 2 then
        return 1;
    elseif rank > 2 then
        ExecClientScp(self, 'RANKRESET_DELETE_RANK_CARD("jexpCard_UpRank3")');
        return 0;
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseRank","Rank",2), 3);
        return 0;
    end
    return 0;
end

function SCR_PRECHECK_ISRANK_3(self)
    local rank = GetTotalJobCount(self);
    local jobLv = GetJobLv(self);
        
    if jobLv == 15 then 
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseInMaxLv"), 3);
        return 0;
    end
    
    if rank == 3 then
        return 1;
    elseif rank > 3 then
        ExecClientScp(self, 'RANKRESET_DELETE_RANK_CARD("jexpCard_UpRank4")');
        return 0;
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseRank","Rank",3), 3);
        return 0;
    end

    return 0;
end

function SCR_PRECHECK_ISRANK_4(self)
    local rank = GetTotalJobCount(self);
    local jobLv = GetJobLv(self);
    
    if jobLv == 15 then 
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseInMaxLv"), 3);
        return 0;
    end
    
    if rank == 4 then
        return 1;
    elseif rank > 4 then
        ExecClientScp(self, 'RANKRESET_DELETE_RANK_CARD("jexpCard_UpRank5")');
        return 0;
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseRank","Rank",4), 3);
        return 0;
    end

    return 0;
end

function SCR_PRECHECK_ISRANK_5(self)
    local rank = GetTotalJobCount(self);
    local jobLv = GetJobLv(self);
        
    if jobLv == 15 then 
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseInMaxLv"), 3);
        return 0;
    end
    
    if rank == 5 then
        return 1;
    elseif rank > 5 then
        ExecClientScp(self, 'RANKRESET_DELETE_RANK_CARD("jexpCard_UpRank6")');
        return 0;
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseRank","Rank",5), 3);
        return 0;
    end

    return 0;
end

function SCR_PRECHECK_ISRANK_6(self)
    local rank = GetTotalJobCount(self);
    local jobLv = GetJobLv(self);
        
    if jobLv == 15 then 
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseInMaxLv"), 3);
        return 0;
    end
        
    if rank == 6 then
        return 1;
    elseif rank > 6 then
        ExecClientScp(self, 'RANKRESET_DELETE_RANK_CARD("jexpCard_UpRank7")');
        return 0;
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseRank","Rank",6), 3);
        return 0;
    end

    return 0;
end

function SCR_PRECHECK_ISRANK_7(self)
    local rank = GetTotalJobCount(self);
    local jobLv = GetJobLv(self);
        
    if jobLv == 15 then 
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseInMaxLv"), 3);
        return 0;
    end
    
    if rank == 7 then
        return 1;
    elseif rank > 7 then
        ExecClientScp(self, 'RANKRESET_DELETE_RANK_CARD("jexpCard_UpRank8")');
        return 0;
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseRank","Rank",7), 3);
        return 0;
    end

    return 0;
end

function SCR_PRECHECK_ISRANK_8(self)
    local rank = GetTotalJobCount(self);
    local jobLv = GetJobLv(self);
        
    if jobLv == 15 then 
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseInMaxLv"), 3);
        return 0;
    end
    
    if rank == 8 then
        return 1;
    elseif rank > 8 then
        ExecClientScp(self, 'RANKRESET_DELETE_RANK_CARD("jexpCard_UpRank9")');
        return 0;
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseRank","Rank",8), 3);
        return 0;
    end
    
    return 0;
end

function SCR_PRECHECK_ISRANK_9(self)
    local rank = GetTotalJobCount(self);
    local jobLv = GetJobLv(self);
        
    if jobLv == 15 then 
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseInMaxLv"), 3);
        return 0;
    end
    
    if rank == 9 then
        return 1;
    elseif rank > 9 then
        ExecClientScp(self, 'RANKRESET_DELETE_RANK_CARD("jexpCard_UpRank9")');
        return 0;
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseRank","Rank",9), 3);
        return 0;
    end

    return 0;
end

function SCR_PRECHECK_IS_LAST_RANK(self)
    local etc = GetETCObject(self);    
    local curRank = GetTotalJobCount(self);
    local lastRank = TryGetProp(etc, 'LastRank');
    if lastRank == nil or lastRank < 1 then -- lastRank = 0: ??�� 초기?�하지 ?��? ?��???
        return 0;
    end

    if lastRank < curRank then
        ExecClientScp(self, 'RANKRESET_DELETE_RANK_CARD("jexpCard_RestoreLastRank")');
        return 0;
    end

    if lastRank ~= curRank then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("OnlyEnableUseAt{LAST_RANK}not{CUR_RANK}", "LAST_RANK", lastRank, "CUR_RANK", curRank), 3);
        return 0;
    end
    return 1;
end

function SCR_PRECHECK_TOY(self)

    if IsBuffApplied(self, 'Camouflage_Buff') == 'YES' or OnKnockDown(self) == 'YES' or IsBuffApplied(self, 'SitRest') == 'YES' then
        return 0;
    end

    return 1;

end

function SCR_PRECHECK_CONSUME_REPAIRPOTION(self)

    if OnKnockDown(self) == 'NO' then
        local equipSlot = {'RH', 'LH', 'GLOVES', 'BOOTS', 'PANTS', 'SHIRT', 'NECK', 'RING1', 'RING2'};

        for i = 1, #equipSlot do
            local item = GetEquipItemIgnoreDur(self, equipSlot[i]);
            if item ~= nil and item.Dur < item.MaxDur then
                return 1;
            end
        end

    end

    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantRepair"), 3);
    return 0;

end

function SCR_PRECHECK_EXPCARD(self)
    local rank = GetTotalJobCount(self);
    local jobLv = GetJobLv(self);
    
    if self.Lv < tonumber(PC_MAX_LEVEL) then 
        return 1;
    else
        if rank == 7 and jobLv == 15 then -- ?�래??경험�?만렙???�도 ?�용 못하게함
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseInMaxLv"), 3);
            return 0;
        elseif jobLv == 15 then 
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseInMaxLv"), 3);
            return 0;
        else
            return 1;
        end
    
    end
    return 0;

end

function SCR_PRECHECK_CONSUME_ENCHANTBOMB(self)
    local curMap = GetZoneName(self);
    
    if curMap == 'c_firemage_event' then
        return 0;
    end
    
    local objList, objCount = SelectObject(self, 100, 'ENEMY');
    
    if objList[1] ~= nil then
        return 1;
    end
    
    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseEnchantBomb"), 3);
    return 0;

end

function SCR_PRECHECK_CONSUME_100CUBE(self)
    local count = GetInvItemCount(self, 'Gacha_TP_100')
    
    if count < 100 then
        return 0;
    end
    
    if OnKnockDown(self) == 'NO' then
        return 1;
    end
    return 0;

end

function SCR_PRECHECK_CONSUME_EV1(self)
    local mapID = GetMapID(self);
    
    if mapID == 515 then
        return 0;
    end
    
    if OnKnockDown(self) == 'NO' then
        return 1;
    end

    return 0;
    
end

function SCR_PRE_CS_IndunReset_GTower_1(self)
    if IS_BASIC_FIELD_DUNGEON(self) == 'YES' or GetClassString('Map', GetZoneName(self), 'MapType') == 'City' then
        local pcetc = GetETCObject(self)
        if pcetc ~= nil then
            if pcetc.InDunCountType_400 > 0 then
                return 1
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CS_IndunReset_GTower_1_MSG2"), 10);
            end
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CS_IndunReset_GTower_1_MSG3"), 10);
    end
    
    return 0
end

function SCR_PRE_CS_IndunReset_Nunnery_1(self)
    if IS_BASIC_FIELD_DUNGEON(self) == 'YES' or GetClassString('Map', GetZoneName(self), 'MapType') == 'City' then
        local pcetc = GetETCObject(self)
        if pcetc ~= nil then
            if pcetc.InDunCountType_300 > 0 then
                return 1
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CS_IndunReset_Nunnery_1_MSG2"), 10);
            end
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CS_IndunReset_GTower_1_MSG3"), 10);
    end
    
    return 0
end
function SCR_PRE_CLASSMAJORQUESTCOUNT_5ADD(self)
    if OnKnockDown(self) ~= 'NO' then
        return 0
    end
    
    if IsIndun(self) ~= 1 and IsPVPServer(self) ~= 1 and IsMissionInst(self) ~= 1 then
        local list, cnt = GetClassList('ClassMajorQuest');  
        if cnt == 0 then
            return 0
        end
        local sObj = GetSessionObject(self, 'ssn_klapeda');
        local questList = {}
        for i=0, cnt-1 do
            local majorQuestIES = GetClassByIndexFromList(list, i);
            local questProperty = GetClassString('QuestProgressCheck',majorQuestIES.ClassName,'QuestPropertyName')
            local questJob = majorQuestIES.Job
            local jobCircle, jobRank = GetJobGradeByName(self, questJob);
            if jobCircle >= 1 then
                if sObj[questProperty..'_R'] >= 5 then
                    return 1
                else
                    if sObj[questProperty..'_R'] >= 0 then
                        questList[#questList + 1] = {GetClassString('QuestProgressCheck',majorQuestIES.ClassName,'Name'), sObj[questProperty..'_R']}
                    end
                end
            end
        end
        if #questList == 0 then
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CLASSMAJORQUESTCOUNT_5ADD_MSG1"), 10);
        else
            local msg = ScpArgMsg("CLASSMAJORQUESTCOUNT_5ADD_MSG1")
            for i = 1, #questList do
                msg = msg..ScpArgMsg("CLASSMAJORQUESTCOUNT_5ADD_MSG2","QUEST",questList[i][1],"COUNT",questList[i][2])
            end
            SendAddOnMsg(self, "NOTICE_Dm_scroll", msg, 10);
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("PopUpBook_MSG3"), 10);
    end
    
    return 0
end

function SCR_PRE_Event_USEABLE_MAINSERVER(self)
    if OnKnockDown(self) ~= 'NO' then
        return 0
    end
    
    if IsIndun(self) ~= 1 and IsPVPServer(self) ~= 1 and IsMissionInst(self) ~= 1 then
        return 1
    end
    
    return 0
end

function SCR_PRE_E_Balloon(self, argstring, argnum1, argnum2)
    if IsAttachedBalloon(self) == 1 then
        DetachBalloon(self)
        return 0
    end
    return 1
end

function SCR_CHECK_RANKRESET(self, rankResetItem)
    if IS_UNIQUE_TEMPLER_GUILD_MASTER(self) == true then
        return 0;
    end

    local curRank = GetTotalJobCount(self);
    local rankResetItemClassName = TryGetProp(rankResetItem, 'ClassName');
    if rankResetItemClassName == nil then
        return 0;
    end
    if rankResetItemClassName == '1706Event_RankReset' then -- 6??�� ?�하�??�용 가?�한 ??���
        if curRank > 6 then
            SendSysMsg(self, 'CantUseRankRest6Rank');
            return 0;
        end
    end

    return 1;
end



function SCR_PRE_FREE_EXTEND_TEAM_WAREHOUSE(self, string1, arg1, arg2, itemID)
--    local aObj = GetAccountObj(self);
--    local account_Warehouse_Cnt = GET_ACCOUNT_WAREHOUSE_SLOT_COUNT(self, aObj)
--    local currentCount = aObj.AccountWareHouseExtend;
--    if currentCount >= ACCOUNT_WAREHOUSE_MAX_EXTEND_COUNT then
--        return;
--    end
    return 1;
end

function SCR_PRE_ITEM_SUMMON_BOSS(self, string1, arg1, arg2, itemID)
	local mapcheck = GetClassString('Map', GetZoneName(self), 'MapType')
	if IsMyPCFriendlyFighting(self) == 0 then
    	if IsIndun(self) ~= 1 and IsPVPServer(self) ~= 1 and IsMissionInst(self) ~= 1 then
    	    if GetLayer(self) == 0 then
                if mapcheck == "Field" then
                    local bossobjList, bossobjCount = SelectObject(self, 400, 'ALL', 1)
                    if bossobjCount >= 1 then
                        for i = 1, bossobjCount do
                            if IS_PC(bossobjList[i]) == false then
                                if TryGetProp(bossobjList[i], 'ClassName') == 'statue_vakarine' then
                                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Card_Summon_Check_god"), 3);
                                    return 0;
                                end
                                
                                if TryGetProp(bossobjList[i], 'Faction') == 'Monster' and TryGetProp(bossobjList[i], 'MonRank') == 'Boss' then
                                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Card_Summon_check_Boss"), 3);
                                    return 0;
                                end
                            end
                        end
                        
                        local zObj = GetLayerObject(self);            
                        if zObj.SUMMON_BOSS_MONSTER_COUNT < MAX_CARDBOOKMONSTER_COUNT_IN_ZONE then
                            return 1;
                        else
                            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Card_Summon_check_BossCnt"), 3);
                            return 0;
                        end
                    end
                    
                    local zObj = GetLayerObject(self);   
                    if zObj.SUMMON_BOSS_MONSTER_COUNT < MAX_CARDBOOKMONSTER_COUNT_IN_ZONE then
                        return 1;
                    else
                        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Card_Summon_check_BossCnt"), 3);
                        return 0;
                    end
                else
                    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Card_Summon_check_Map"), 3);
                    return 0;
                end
            else
                SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Card_Summon_check_Map"), 3);
                return 0;
            end
        else
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Card_Summon_check_Map"), 3);
            return 0;
        end
    elseif IsMyPCFriendlyFighting(self) == 1 then
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("Card_Summon_check_PVP"), 3);
        return 0;
    end
end

function SCR_PRE_ChallengeModeReset(self)
    if IS_BASIC_FIELD_DUNGEON(self) == 'YES' or GetClassString('Map', GetZoneName(self), 'MapType') == 'City' then
        local isHasBuff = IsBuffApplied(self, 'ChallengeMode_Completed')
        if isHasBuff == 'YES' then
            return 1
        else
            SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("ChallengeModeReset_MSG1"), 10);
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CS_IndunReset_GTower_1_MSG3"), 10);
    end
    
    return 0
end

-- Key_Quest_Select Lv1
function SCR_PRE_KQ_SELECT_LV_1(self)	

	local map_check = SCR_KEY_QUEST_MAP_CHECK(self)
    if map_check == 0 then
        return 0
    end
    
    local pre_check = SCR_KEY_QUEST_PRECHECK_MEMBER(self, 1)
    if pre_check == 0 then
        return 0
    end
    
    local select_check = SCR_KEY_QUEST_PRECHECK_MEMBER(self, 1)
    if select_check == 0 then
        return 0
    end

    return 1
end

-- Key_Quest_Select Lv2
function SCR_PRE_KQ_SELECT_LV_2(self)

    local map_check = SCR_KEY_QUEST_MAP_CHECK(self)
    if map_check == 0 then
        return 0
    end
    
    local pre_check = SCR_KEY_QUEST_PRECHECK_MEMBER(self, 2)
    if pre_check == 0 then
        return 0
    end
    
    local select_check = SCR_KEY_QUEST_PRECHECK_MEMBER(self, 2)
    if select_check == 0 then
        return 0
    end
    
    return 1
end

function SCR_PRECHECK_HALOWEEN_2017_ACHIEVE1(self)
    if OnKnockDown(self) == 'NO' then
        local achieve_Point = GetAchievePoint(self, "2017_Halloween2_AP");
        if achieve_Point == 0 then
            return 1;
        else
            SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg("AGARIO_ACHIEVE"), 5)
            return 0;
        end
    end
    return 0;
end

function SCR_PRECHECK_HALOWEEN_2017_ACHIEVE2(self)
    if OnKnockDown(self) == 'NO' then
        local achieve_Point = GetAchievePoint(self, "2017_Halloween1_AP");
        if achieve_Point == 0 then
            return 1;
        else
            SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg("AGARIO_ACHIEVE"), 5)
            return 0;
        end
    end
    return 0;
end

function SCR_PRECHECK_ISRANK_9(self)
    local rank = GetTotalJobCount(self);
    local jobLv = GetJobLv(self);
        
    if rank == 9 then
        return 1;
    elseif rank > 8 then
        ExecClientScp(self, 'RANKRESET_DELETE_RANK_CARD("jexpCard_UpRank9")');
        return 0;
    else
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseRank","Rank",9), 3);
        return 0;
    end

    if jobLv == 15 then 
        SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CantUseInMaxLv"), 3);
        return 0;
    end
    
    return 0;
end


function SCR_PRE_RequestEnterCount_1add(self)
    if IS_BASIC_FIELD_DUNGEON(self) == 'YES' or GetClassString('Map', GetZoneName(self), 'MapType') == 'City' then
        local pcetc = GetETCObject(self)
        if pcetc ~= nil then
            if pcetc.InDunCountType_200 > 0 then
                return 1
            else
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CS_RequestEnterCount_1add_MSG1"), 10);
            end
        end
    else
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CS_IndunReset_GTower_1_MSG3"), 10);
    end
    
    return 0
end

function SCR_PRE_GuildQuestEnterCount_1add(self)
    if IsIndun(self) == 1 or IsPVPServer(self) == 1 or IsMissionInst(self) == 1 then
        SysMsg(self, 'Instant', ScpArgMsg('PopUpBook_MSG3'))
        return 0
    end

    local guildObj = GetGuildObj(self)
    if guildObj == nil then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CS_Guild_Ticket_add1_MSG1"), 10);
        return 0
    end
    local usedTicket = guildObj.UsedTicketCount
    if usedTicket == 0 then
        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CS_Guild_Ticket_add1_MSG2"), 10);
        return 0
    end
    if usedTicket >= 1 then
        return 1
    end 
end

function SCR_PRECHECK_CONSUME_PVP_MINE(self)
    local zone = GetZoneName(self)

    if zone == 'pvp_Mine' then
        return 1;
    elseif IsPVPServer(self) == 1 then
        return 0;
    end
   
    return 1;
end