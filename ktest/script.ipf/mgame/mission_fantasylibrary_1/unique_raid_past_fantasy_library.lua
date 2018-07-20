---- UNIQUE_RAID_FAST_FANTASY_LIBRARY


-- Boss Skill and Pattern
function SCR_SPECTOR_PATTERN_ONE(self)
    local range = 150
    local list, cnt = SelectObject(self, range, 'MON')
    PlayEffect(self, 'F_ground139_light_green', 2.3, 'BOT');
    for i = 1, cnt do
        if list[i].ClassName == 'uniq_id_boss_Spector_F' then
            local addHP = list[i].MHP * 0.02
            Heal(list[i], addHP, 0)
            PlayEffect(list[i], 'F_monster_heal_Buff', 5.5, 'BOT');
        end
    end
end


function SCR_SPECTOR_SOMMON_MONSTER_BORN(self)
    PlayEffect(self, 'F_lineup010_ground', 0.8, 'BOT');
    AddBuff(self, self, 'SPECTOR_PATTERN_ONE_BUFF', 1, 0, 20000, 1)
end


function SCR_SPECTOR_PATTERN_TWO(self)
    RunSimpleAI(self,'SPECTOR_SOMMON_MONSTER')
end


function SCR_SPECTOR_SOMMON_MONSTER(self)
    local x, y, z = GetPos(self)
    local followerList = GetScpObjectList(self, 'SPECTOR_POWER_BALL')
    local limitCnt = 11;
    local list = {}
    if #followerList < limitCnt then
        for i = 1, limitCnt - #followerList do
            
            RunScript('SCR_SPECTOR_SUMMON_DOUGHNUT', self, x, y, z)
        end
        PlayEffect(self, 'F_buff_basic023_red_fire', 1.5, 'BOT');
    elseif followercnt > limitCnt - 3 then
        for j = 1, #followerList do
            if followerList[j].ClassName == 'magictrap_core_fantasylib' then
                list[#list + 1] = followerList[j]
            end
        end
        for k = limitCnt + 2, #list do
            Kill(list[k])
        end
    end
end

function SCR_SPECTOR_SUMMON_DOUGHNUT(self,  x, y, z)
    local time = IMCRandom(0, 1500);
    sleep(time);
    local dPos = SCR_DOUGHNUT_RANDOM_POS(x, z, 50, 200)
    local angle = GetAngleFromPos(self, dPos['x'], dPos['z'])
    local summonMon = CREATE_MONSTER_EX(self, 'magictrap_core_fantasylib', dPos['x'], y, dPos['z'], angle, 'Monster', nil, SCR_SPECTOR_ORB_SETTING);
    AddScpObjectList(self, 'SPECTOR_POWER_BALL', summonMon)
    ObjectColorBlend(summonMon, 74, 0, 62, 255)
    summonMon.MSPD_BM = summonMon.MSPD_BM +2
    DisableBornAni(summonMon)
    PlayEffectToGround(self, 'F_buff_basic001_violet', dPos['x'], y, dPos['z'], 0.7);
    SetOwner(summonMon,self,1)
end


function SCR_SPECTOR_ORB_SETTING(summonMon)
    summonMon.SimpleAI = "SPECTOR_SPEC_UP_AI"
end


function SCR_SPECTOR_SPEC_UP_AI(self)
    local owner = GetOwner(self)
    if owner ~= nil then
        MoveToTarget(self, owner, 10)
    elseif owner == nil then
        Kill(self)
    end
    
    local range = 30
    local list, cnt = SelectObject(self, range, 'MON')
    for i = 1, cnt do
        if list[i].ClassName == 'uniq_id_boss_Spector_F' then
            list[i].MINPATK = list[i].MINPATK + 50
            list[i].MAXPATK = list[i].MAXPATK + 50
            list[i].MINMATK = list[i].MINMATK + 50
            list[i].MAXMATK = list[i].MAXMATK + 50
            list[i].DEF = list[i].DEF + 100
            list[i].MDEF = list[i].MDEF + 100
            Dead(self)
        end
    end
end

-- VALDOVAS SKILL SETTING

function SCR_VALDOVAS_PATTERN_ONE(self)
    local list, cnt = GetWorldObjectList(self, 'PC', 300)
    for i = 1, cnt do
        if IS_PC(list[i]) == true then
            AddBuff(self, list[i], 'VALDOVAS_DEBUFF', 1, 0, 0, 1)
        end
    end
end


function SCR_VALDOVAS_PATTERN_RUN(self)
    RunSimpleAI(self,'VALDOVAS_PATTERN_ONE')
end


function SCR_FANTASY_LIBRARY_SUMMON_AMPLE_AI(self)
    local objectCheck = GetScpObjectList(self, "SCR_AMPOULE_SETTING_CHECK")
    if #objectCheck ~= nil and #objectCheck ~= 0 then
        self.NumArg2 = self.NumArg2 +1
        if self.NumArg2 == 2 then
            PlayEffect(self, "F_buff_basic002_violet", 1, "BOT")
            self.NumArg2 = 0
        end
    elseif #objectCheck == nil or #objectCheck == 0 then
        self.NumArg4 = self.NumArg4 +1
        if self.NumArg4 > 10 and self.NumArg4 < 20 then
            if self.NumArg3 == 0 then
                AttachEffect(self, "F_bubble002_red_loop", 2, "MID")
                self.NumArg3 = 1
            end
        elseif self.NumArg4 >= 20 then
            DetachEffect(self, "F_bubble002_red_loop")
            local x, y, z = GetPos(self)
            local buffAmpoule = CREATE_MONSTER_EX(self, 'supplemants_fantasylib', x, y, z, 0, 'Neutral', nil)
            PlayEffectToGround(buffAmpoule, 'F_buff_basic033_orange_line', x, y, z, 1);
            AddScpObjectList(self, "SCR_AMPOULE_SETTING_CHECK", buffAmpoule)
            self.NumArg4 = 0
            self.NumArg3 = 0
            self.NumArg2 = 0
        end
    end
end


function SCR_STAGE7_MAGICSQUARE_DIALOG(self, pc)
    local objectCheck = GetScpObjectList(self, "SCR_AMPOULE_SETTING_CHECK")
    if #objectCheck ~= nil and #objectCheck ~= 0 then
        local dialogCheck = DOTIMEACTION_R(pc, ScpArgMsg("STAGE7_AMPUL_ACTIVE"), "HANDLING_LEFT", 1)
        if dialogCheck == 1 then
            if IsBuffApplied(pc, 'VALDOVAS_DEBUFF') == 'YES' then
                RemoveBuff(pc,'VALDOVAS_DEBUFF')
            else
                if IsBuffApplied(pc, 'SEQUELA_AMPOULE') == 'NO' then
                    AddBuff(self, pc, 'ABUSE_AMPOULE', 1, 0, 15000, 1)
                else
                    RemoveBuff(pc,'SEQUELA_AMPOULE')
                    AddBuff(self, pc, 'SEQUELA_AMPOULE_DENGENERATE', 1, 0, 10000, 1)
                end
            end
            for i = 1, #objectCheck do
                Kill(objectCheck[i])
            end
        end
    end
end


function SCR_VALDOVAS_2ND_SKILL_AI(self)
    local ampulList = GetScpObjectList(self, "VALDOVAS_SKILL_AMPUL")
    if #ampulList == 0 or #ampulList == nil then
        local pcList, pcCount = GetLayerPCList(GetZoneInstID(self), GetLayer(self))
        if pcCount ~= nil and pcCount ~= 0 then
        
            for i = 1, pcCount+4 do
                local x, y, z = GetPos(self)
                local mon = CREATE_MONSTER_EX(self, 'maple_25_supplemants', x+IMCRandom(-150, 150), y, z+IMCRandom(-150, 150), nil, 'Monster', nil, SCR_VALDOVAS_SKILL_AMPUL)
                AddScpObjectList(self, "VALDOVAS_SKILL_AMPUL", mon)
            end
            
        end
    end
end


function SCR_VALDOVAS_SKILL_AMPUL(mon)
    mon.SimpleAI = "VALDOVAS_SKILL_AMPUL"
    mon.NumArg1 = IMCRandom(1, 4)
    mon.Range = 100
    mon.Name = ScpArgMsg("PAST_FANTASY_LIBRARY_VALDOVAS_AMPUL")
end


function SCR_VALDOVAS_SKILL_AMPUL_AI(self)
    if IsDead(self) == 0 then

        PlayEffect(self, "F_circle011_dark", 1.5, "BOT")
        
    -- COLOR_BLEND_SETTING
        if self.NumArg3 == 0 or self.NumArg3 == nil then
            if self.NumArg1 == 1 then
                ObjectColorBlend(self, 51, 204, 255, 255)
            elseif self.NumArg1 == 2 then
                ObjectColorBlend(self, 153, 0, 204, 255)
            elseif self.NumArg1 == 3 then
                ObjectColorBlend(self, 204, 0, 51, 255)
            elseif self.NumArg1 == 4 then
                ObjectColorBlend(self, 255, 204, 0, 255)
            end
            self.NumArg3 = 0
        end
        
        
    -- OBJECT_EXPLOSION_SETTING
        self.NumArg2 = self.NumArg2 +1
        if self.NumArg2 >= 7 then
    
            local pcList, pcCount = GetWorldObjectList(self, "PC", 100)
            if pcCount ~= nil and pcCount ~= 0 then
    
                for i = 1, pcCount do
                    if IsDummyPC(pcList[i]) == 0 then
                        if self.NumArg1 == 1 then
                            AddBuff(self, pcList[i], "Freeze", 1, 0, 10000, 1)
                        elseif self.NumArg1 == 2 then
                            AddBuff(self, pcList[i], "Poison", 1, 0, 15000, 1)
                        elseif self.NumArg1 == 3 then
                            TakeDamage(self, pcList[i], "None", 10000); -- please modify int for give damage to pc
                        elseif self.NumArg1 == 4 then
                            AddBuff(self, pcList[i], "Blind", 1, 0, 15000, 1)
                        end
                    end
                end
                
                PlayEffect(self, "F_explosion020_water", 2, "BOT")
                Dead(self)
            end
            
        end
        
    end
end

function SCR_FROSTER_ROAD_ICE_STONE_BORN(self)
    AddBuff(self, self, 'FREEZE_EFFECT', 1, 0, 0, 1)
end

function SCR_FROSTER_ROAD_ICE_STONE_SUMMON(self)
    local x, y, z = GetPos(self)
    local followList = GetScpObjectList(self, 'ICESTONE')
    
--    if #followList == nil then
--        #followList = 0;
--    end
    
    local limitCnt = 28
    if limitCnt > #followList then
        for i = 1, 5 do
            --SCR_ICE_STONE_CREATE_DOUGHNUT_POS(self, x, y, z)
            RunScript('SCR_ICE_STONE_CREATE_DOUGHNUT_POS', self, x, y, z)
        end
    end
    
end

function SCR_ICE_STONE_CREATE_DOUGHNUT_POS(self, x, y, z)
    local time = IMCRandom(1, 500)
    sleep(time)
    local pos = GetExProp(self, "POSCNT")
    
    if pos== 0 or pos > 5 then
        pos = 1
    end
    
    SetExProp(self, "POSCNT", pos+1)
    
    if pos == 1 then
        x, y, z = 1433, -8, 819
    elseif pos == 2 then
        x, y, z = 1320, -8, 909
    elseif pos == 3 then
        x, y, z = 1343, -8, 1051
    elseif pos == 4 then
        x, y, z = 1485, -8, 1068
    else
        x, y, z = 1565, -8, 958
    end
    
    local iceStone = CREATE_MONSTER_EX(self, 'd_fantasylibrary_monument', x, y, z, 0, 'Monster', nil);
    
    AddBuff(self, iceStone, 'D_UNIQ_ATTRACK_TREE_TIMER', 1, 0, 30000, 1)
    AddScpObjectList(self, 'ICESTONE', iceStone)
    DisableBornAni(iceStone)
    PlayEffectToGround(self, 'I_ground014_ice', x, y, z, 1.2);
    PlayEffectToGround(self, 'I_ground012_ice4', x, y, z, 1.2);
    SetOwner(iceStone,self,1)
end

function SCR_ICE_STONE_COLLISION_SIMPLE_AI(self)
--SimpleAI Name D_FANTAS_LIB_ICE_STONE_COLLISION_AI--
    local targetList, targetCnt = GetWorldObjectList(self, 'PC', -1)
    local owner= GetOwner(self)
    for i = 1, targetCnt do
        if IS_PC(targetList[i]) == true then
            if GetDistance(self, targetList[i]) <= 40 then
                AddBuff(owner, targetList[i], 'FORST_OVER', 1, 0, 30000, 1)
            end
        end
    end
    
    if IsBuffApplied(self, 'D_UNIQ_ATTRACK_TREE_TIMER') == 'NO' then
        if IsDead(self) == 0 then
            RunScript('SCR_FROSTER_ROAD_ALTER_EGO_SUMMON', self)
            Dead(self)
        end
    end
    
end


function SCR_SUMMON_ICE_BALL(self)
    local x, y, z = GetPos(self)
    local time = IMCRandom(1, 500)
    sleep(time)
    
    local dPos = SCR_DOUGHNUT_RANDOM_POS(x, z, 40, 150)
    local angle = GetAngleFromPos(self, dPos['x'], dPos['z'])
    
    
    local iceBall = CREATE_MONSTER_EX(self, 'd_uniq_froster_tree_fruit', dPos['x'], y, dPos['z'], 0, 'Monster', nil);
    
    AddScpObjectList(self, 'ICEBALL', iceBall)
    SetOwner(iceBall, self, 1)
    PlayEffectToGround(iceBall, 'F_hit_ice', dPos['x'], y, dPos['z'], 1);
    AttachEffect(iceBall, 'F_ground143_violet_ice', 0.5, 'BOT');
    ObjectColorBlend(iceBall, 25, 120, 255, 200)
    RunSimpleAI(iceBall, 'ICE_BALL')
end

function SCR_FROST_TREE_AI(self)
    if IsBuffApplied(self, 'D_UNIQ_ATTRACK_TREE_TIMER') == 'NO' then
        local limitCnt = 15
        local list = GetScpObjectList(self, 'ICEBALL')
        if limitCnt > #list then
            if #list < 10 then
                for i = 1, 5 do
                    RunScript('SCR_SUMMON_ICE_BALL', self)
                end
            else
                for i = 1, limitCnt - #list do
                    RunScript('SCR_SUMMON_ICE_BALL', self)
                end
            end
        end
        if  limitCnt <= #list then
            for j = 1, #list do
                    SetExProp(list[j], 'SELF_BOOM', 1)
            end
        end
        if IsDead(self) == 0 then
            AddBuff(self, self, 'D_UNIQ_ATTRACK_TREE_TIMER', 1, 0, 6000, 1)
        end
    end

end

function SCR_ICE_BALL(self)
    local targetList, targetCnt = GetWorldObjectList(self, 'PC', -1)
    local owner= GetOwner(self)
    local damage = 15000
    local prop = GetExProp(self, 'SELF_BOOM')
    local aiSet = GetExProp(self, 'AI_SET')
        
    if aiSet == 0 then
        local num = IMCRandom(1, targetCnt)
        SetExProp(self, 'AI_SET', num)
    end
    
    if aiSet ~= 0 then
        if IsDead(self) == 0 then
            MoveToTarget(self, targetList[aiSet], 10)
        end
    end
    
    
    for i = 1, targetCnt do
        if IS_PC(targetList[i]) == true then
            if IsDead(self) == 0 then
                if GetDistance(self, targetList[i]) <= 15 then
                    TakeDamage(self, targetList[i], "None", damage, "Ice", "Magic", "TrueDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0, 0);
                    AddBuff(self, targetList[i], 'RAID_FREEZING', 1, 0, 2000, 1)
                    Dead(self)
                end
            end
        end
    end
    
    if  prop == 1 then
        for j = 1, targetCnt do
            local deadDmg = 15000
            local target = targetList[j]
            RunScript('SCR_ICE_BALL_TURN_DEAD', self, deadDmg, target)
        end
    end
end

function SCR_ICE_BALL_TURN_DEAD(self, deadDmg, target)
    local x, y, z = GetPos(self)
    local time = IMCRandom(1, 1500)
    
    sleep(time)
    if IsDead(self) == 0 then
        if GetDistance(self, target) <= 30 then
            TakeDamage(self, target, "None", deadDmg, "Ice", "Magic", "TrueDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0, 0);
            AddBuff(self, target, 'RAID_FREEZING', 1, 0, 3000, 1)
        end
        
        PlayEffect(self, 'F_buff_ice_spread', 0.45, 'BOT')
    end
    Dead(self)
end

function SCR_ICE_TREE_BORN(self)
    AddBuff(self, self, 'D_UNIQ_ATTRACK_TREE_TIMER', 1, 0, 6000, 1)
end

function SCR_FROSTER_ROAD_SUMMONPILLRA(self)
    local x, y, z = GetPos(self)
    local frosterPillra = CREATE_MONSTER_EX(self, 'd_uniq_attract_pillar', 1444, -8, 949, 0, 'Monster', nil);
    SetOwner(frosterPillra, self, 1)
    ObjectColorBlend(frosterPillra, 250, 140, 200, 255)
end

function SCR_FROSTER_ROAD_ALTER_EGO_SUMMON(self)
    local list, cnt = GetWorldObjectList(self, "MON", -1)
    local owner = 0
    
    for i = 1, cnt do
        if list[i].ClassName == 'boss_froster_lord' then
            owner = list[i]
        end
    end
    
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'summon_boss_froster_lord', x, y, z, 0, 'Monster', nil);
    SetLifeTime(mon, 120)
    SetOwner(mon, owner, 1)
    ObjectColorBlend(mon, 85, 140, 180, 180)
end
-- Stage Gimmick




-- UNIQUE_RAID_FAST_FANTASY_LIBRARY


--INTRO


-- AGAILA




function SCR_AGAILA_APPEARENCE_TRIGGER_01(self)
    sleep(2500)
    PlayEffect(self, 'F_spread_in023_blue', 1)
    DetachEffect(self, 'F_magic_prison_line_orange')
end


function SCR_AGAILA_APPEARENCE_TRIGGER_02(self)
    DetachEffect(self, 'F_wizard_stop_shot_loop')
    DetachEffect(self, 'F_ground141_light_blue_loop')
    PlayEffect(self, 'F_spread_out032_2', 1)
end


function SCR_AGAILA_APPEARENCE_INTRO(self)
    local pcList, pcCount = GetLayerPCList(GetZoneInstID(self), GetLayer(self))
    if pcCount > 0 then
        if self.NumArg4 == 0 then
            LookAt(self, pcList[IMCRandom(1,pcCount)])
            self.NumArg4 = 1
        elseif self.NumArg4 == 1 then
            LookAt(self, pcList[IMCRandom(1,pcCount)])
            Chat(self, ScpArgMsg('MFEG_INIT_FLURRY_NPC_AI_1'), 5)
            self.NumArg4 = 2
        elseif self.NumArg4 == 2 then
            LookAt(self, pcList[IMCRandom(1,pcCount)])
            Chat(self, ScpArgMsg('MFEG_INIT_FLURRY_NPC_AI_2'), 5)
            self.NumArg4 = 3
        elseif self.NumArg4 == 3 then
            LookAt(self, pcList[IMCRandom(1,pcCount)])
            Chat(self, ScpArgMsg('MFEG_INIT_FLURRY_NPC_AI_3'), 5)
            self.NumArg4 = 4
        elseif self.NumArg4 == 4 then
            LookAt(self, pcList[IMCRandom(1,pcCount)])
            Chat(self, ScpArgMsg('MFEG_INIT_FLURRY_NPC_AI_3_1'), 5)
            self.NumArg4 = 5
        elseif self.NumArg4 == 5 then
            self.NumArg4 = 6
            SetMGameValue(self, "AGAILA_APPEAR", 2)
            if pcCount ~= 0 and pcCount ~= nil then
                for i = 1, pcCount do
                   SendAddOnMsg(pcList[i], "NOTICE_Dm_Clear", ScpArgMsg("PAST_FANTASY_LIBRARY_INTRO_AGAILA"), 5)
                end
            end
        end
    end
end


function SCR_FAST_FANTASTYLIB_AGAILA_01_DIALOG(self, pc)
    local miniGameValue = GetMGameValue(self, "AGAILA_APPEAR") -- Appearing AGAILA Check
    if miniGameValue == 0 or miniGameValue == 1 then -- if not appearing AGAILA then
        return
        
    elseif miniGameValue == 2 then -- if appearing AGAILA then
        local pcList, pcCount = GetWorldObjectList(self, "PC", 300)
        if pcCount ~= nil and pcCount ~= 0 then

            local distractor = ShowSelDlg(pc, 0, "MFL_FLURRY_NPC_SELECT_2", ScpArgMsg("MFL_FLURRY_NPC_SEL_1"), ScpArgMsg("MFL_FLURRY_NPC_SEL_2"), ScpArgMsg("MFL_FLURRY_NPC_SEL_START"))
            if distractor == 1 then
                SCR_FAST_FANTASTYLIB_AGAILA_01_SUB01(self, pc)
            elseif distractor == 2 then
                SCR_FAST_FANTASTYLIB_AGAILA_01_SUB02(self, pc)
            elseif distractor == 3 then
                if GetExProp(pc, "StartCheck") < 1 then
                    if self.NumArg2 < pcCount then
                        self.NumArg2 = self.NumArg2 + 1
                        SetExProp(pc, "StartCheck", 1)
                        if self.NumArg2 >= pcCount then
                            if GetMGameValue(self, "AGAILA_APPEAR") < 3 then
                                ShowOkDlg(pc, 'MFL_FLURRY_NPC_SEL_AGREE', 1)
                                SetMGameValue(self, "AGAILA_APPEAR", 3)
                                SetMGameValue(self, "HAUBERK_APPEAR", 1)
                            end
                        else
                            ShowOkDlg(pc, "FANTASY_LIBRARY_NOT_READY",1)
                        end
                    end
                elseif GetExProp(pc, "StartCheck") >= 1 then
                    if self.NumArg2 >= pcCount then
                        if GetMGameValue(self, "AGAILA_APPEAR") < 3 then
                            ShowOkDlg(pc, 'MFL_FLURRY_NPC_SEL_AGREE', 1)
                            SetMGameValue(self, "AGAILA_APPEAR", 3)
                            SetMGameValue(self, "HAUBERK_APPEAR", 1)
                        end
                    end
                end
            end
        end
        
    end
end


function SCR_FAST_FANTASTYLIB_AGAILA_01_SUB01(self, pc)
    local subDistractor = ShowSelDlg(pc, 0, 'MFL_FLURRY_NPC_SEL_1_TXT_1', ScpArgMsg('MFL_FLURRY_NPC_SEL_1_TXT_SEL_1_1'), ScpArgMsg('MFL_FLURRY_NPC_SEL_SELECT_CLOSE'))
    if subDistractor == 1 then
        ShowOkDlg(pc, 'MFL_FLURRY_NPC_SEL_1_TXT_3', 1)
    else
        return
    end
end


function SCR_FAST_FANTASTYLIB_AGAILA_01_SUB02(self, pc)
    local subDistractor = ShowSelDlg(pc, 0, 'MFL_FLURRY_NPC_SEL_1_TXT_2', ScpArgMsg('MFL_FLURRY_NPC_SEL_1_TXT_SEL_1_2'), ScpArgMsg('MFL_FLURRY_NPC_SEL_SELECT_CLOSE'))
    if subDistractor == 1 then
        ShowOkDlg(pc, 'MFL_FLURRY_NPC_SEL_1_TXT_4', 1)
    else
        return
    end
end




-- HAUBERK




function SCR_HAUBERK_APPEARENCE_TRIGGER_01(self)
    AttachEffect(self, 'F_light055_black', 15, 'TOP')
end


function SCR_HAUBERK_APPEARENCE_TRIGGER_02(self)
    PlayEffect(self, 'F_explosion098_dark_mint', 2)
    DetachEffect(self, 'F_light055_black')
    sleep(300)
    Kill(self)
end


function SCR_HAUBERK_APPEARENCE_INTRO(self)
    local agaila
    local objectList, objectCount = GetWorldObjectList(self, "MON", 300)
    if objectCount > 0 then
        for i = 1, objectCount do
            if objectList[i].ClassName == 'npc_agailla_flurry' then
                agaila = objectList[i]
                break
            end
        end
    end
    if agaila ~= nil then
        if self.NumArg4 == 0 then
            LookAt(self, agaila)
            LookAt(agaila, self)
            self.NumArg4 = 1
        elseif self.NumArg4 == 1 then
            LookAt(self, agaila)
            LookAt(agaila, self)
            MoveEx(self, -1030, 480, 1)
            Chat(agaila, ScpArgMsg('MFEG_INIT_FLURRY_NPC_AI_4'), 5)
            self.NumArg4 = 2
        elseif self.NumArg4 == 2 then
            StopMove(self)
            SetDirectionByAngle(self, -90)
            SetDialogRotate(self, -90)
            SetDirectionByAngle(agaila, 90)
            SetDialogRotate(agaila, 90)
            Chat(self, ScpArgMsg('MFEG_INIT_HAUBERK_NPC_AI_1'), 5)
            self.NumArg4 = 3
        elseif self.NumArg4 == 3 then
            Chat(self, ScpArgMsg('MFEG_INIT_HAUBERK_NPC_AI_2'), 5)
            SetDirectionByAngle(self, -90)
            SetDialogRotate(self, -90)
            SetDirectionByAngle(agaila, 90)
            SetDialogRotate(agaila, 90)
            self.NumArg4 = 4
        elseif self.NumArg4 == 4 then
            SetDirectionByAngle(agaila, 90)
            SetDialogRotate(agaila, 90)
            Chat(agaila, ScpArgMsg('MFEG_INIT_FLURRY_NPC_AI_5'), 5)
            self.NumArg4 = 5
        elseif self.NumArg4 == 5 then
            SetDirectionByAngle(agaila, 90)
            SetDialogRotate(agaila, 90)
            Chat(self, ScpArgMsg('MFEG_INIT_HAUBERK_NPC_AI_3'), 5)
            self.NumArg4 = 6
        elseif self.NumArg4 == 6 then
            SetDirectionByAngle(agaila, 90)
            SetDialogRotate(agaila, 90)
            Chat(agaila, ScpArgMsg('MFEG_INIT_FLURRY_NPC_AI_6'), 5)
            self.NumArg4 = 7
        elseif self.NumArg4 == 7 then
            SetDirectionByAngle(agaila, 90)
            SetDialogRotate(agaila, 90)
            Chat(self, ScpArgMsg('MFEG_INIT_HAUBERK_NPC_AI_4'), 5)
            self.NumArg4 = 8
        elseif self.NumArg4 == 8 then
            SetDirectionByAngle(agaila, 90)
            SetDialogRotate(agaila, 90)
            Chat(agaila, ScpArgMsg('MFEG_INIT_FLURRY_NPC_AI_7'), 5)
            self.NumArg4 = 9
        elseif self.NumArg4 == 9 then
            SetDirectionByAngle(agaila, -90)
            SetDialogRotate(agaila, -90)
            Chat(agaila, ScpArgMsg('MFEG_INIT_FLURRY_NPC_AI_8_1'), 5)
            self.NumArg4 = 10
        elseif self.NumArg4 == 10 then
            SetDirectionByAngle(agaila, -90)
            SetDialogRotate(agaila, -90)
            Chat(agaila, ScpArgMsg('MFEG_INIT_FLURRY_NPC_AI_9_1'), 5)
            self.NumArg4 = 11
        elseif self.NumArg4 == 11 then
            SetDirectionByAngle(agaila, -90)
            SetDialogRotate(agaila, -90)
            Chat(agaila, ScpArgMsg('MFEG_INIT_FLURRY_NPC_AI_10_1'), 5)
            self.NumArg4 = 12
        elseif self.NumArg4 == 12 then
            SetDirectionByAngle(agaila, -90)
            SetDialogRotate(agaila, -90)
            self.NumArg4 = 13
            SetMGameValue(self, "HAUBERK_APPEAR", 2)
        end
    end
end




-- 2ND_STAGE




-- 3RD_STAGE




function SCR_STAGE3_AGAILA_DIALOG(self, pc)
    local stageClearCheck = GetMGameValue(self, "2ND_CLEAR")
    if stageClearCheck == 1 then
        if self.NumArg2 == 0 then
            ShowOkDlg(pc, "MFL_STAGE3_AGAILA_EXPLAIN")
            self.NumArg2 = 1
            SetMGameValue(self, "3RD_CLEAR", 1)
        end
    end
    return
end


function SCR_STAGE3_AGAILA_DESK_DIALOG(self, pc)
    local stageProgressCheck = GetMGameValue(self, "3RD_CLEAR")
    if stageProgressCheck == 1 then
        local distractor = ShowSelDlg(pc, 0, "MFL_STAGE3_DESK_DISTRACTOR", ScpArgMsg("MFL_DOWN_ROOM_EXPLAIN"), ScpArgMsg("MFL_RIGHT_ROOM_EXPLAIN"), ScpArgMsg("MFL_THIS_PLACE_EXPLAIN"))
        if distractor == 1 then
            ShowOkDlg(pc, "MFL_DOWN_ROOM_EXPLAIN")
        elseif distractor == 2 then
            ShowOkDlg(pc, "MFL_RIGHT_ROOM_EXPLAIN")
        elseif distractor == 3 then
            ShowOkDlg(pc, "MFL_THIS_PLACE_EXPLAIN")
        end
    end
end


function SCR_STAGE3_AGAILA_AI(self)
    local mgameValueCheck = GetMGameValue(self, "3RD_CLEAR")
    if mgameValueCheck >= 1 then
        if self.NumArg4 == 0 or self.NumArg4 == nil then
            AttachEffect(self, 'F_wizard_stop_shot_loop', 2, "BOT")
            AttachEffect(self, 'F_ground141_light_blue_lop', 2, "BOT")
            PlayEffect(self, 'F_spread_in023_blue', 1)
            Chat(self, ScpArgMsg('MFL_STAGE3_AGAILA_END'), 5)
            self.NumArg4 = 1
        elseif self.NumArg4 == 1 then
            Kill(self)
            DetachEffect(self, 'F_wizard_stop_shot_loop')
            DetachEffect(self, 'F_ground141_light_blue_loop')
            PlayEffect(self, 'F_spread_out032_2', 2)
        end
    end
end


function SCR_STAGE3_GIMMICK_SETTING(self)


-- BOOKCASE GIMMICK ANSWER


    local puzzleIndex = {}
    local bookcaseMatrix = {}
    
    local numberSetting
    
    repeat
    
        for i = 1, 8 do
            local numberSet = IMCRandom(1,5)
            puzzleIndex[i] = numberSet
        end
        
        for j = 1, 4 do
            bookcaseMatrix[j] = tonumber(puzzleIndex[(2*j)-1]..puzzleIndex[(2*j)])
            SetMGameValue(self, "matrixAnswer"..j, bookcaseMatrix[j])
        end
        
        if bookcaseMatrix[1] ~= bookcaseMatrix[2] and
            bookcaseMatrix[1] ~= bookcaseMatrix[3] and
            bookcaseMatrix[1] ~= bookcaseMatrix[4] and
            bookcaseMatrix[2] ~= bookcaseMatrix[3] and
            bookcaseMatrix[2] ~= bookcaseMatrix[4] and
            bookcaseMatrix[3] ~= bookcaseMatrix[4] then
            
            numberSetting = 1
        end
        
    until(numberSetting == 1)


-- PASSWORD HEADSTONE ANSWER


    local headstoneMatrix = {}
    
    local stoneNumberSetting 
    
    repeat

        for k = 1, 4 do
            local answerNumber = IMCRandom(1, 4)
            headstoneMatrix[k] = answerNumber
            SetMGameValue(self, "bookmarkColor"..k, answerNumber)
        end
        
        if headstoneMatrix[1] ~= headstoneMatrix[2] and
            headstoneMatrix[1] ~= headstoneMatrix[3] and
            headstoneMatrix[1] ~= headstoneMatrix[4] and
            headstoneMatrix[2] ~= headstoneMatrix[3] and
            headstoneMatrix[2] ~= headstoneMatrix[4] and
            headstoneMatrix[3] ~= headstoneMatrix[4] then
            
            stoneNumberSetting = 1
        end
        
    until(stoneNumberSetting == 1)
    
    for l = 1, 4 do
        SetMGameValue(self, "passwordAnswer"..l, tonumber(l..headstoneMatrix[l]))
    end
    
end




  -- BOOKCASE GIMMICK (3RD-01 STAGE)


function SCR_STAGE3_READING_DESK_DIALOG(self,pc)
    local mgameValueCheck = GetMGameValue(self, "3RD_CLEAR")
    if mgameValueCheck == 1 then
        Chat(self, ScpArgMsg("STAGE3_THIS_TIME_PASSWORD_IS_THIS").." : "..GetMGameValue(self, "matrixAnswer1")..", "..GetMGameValue(self, "matrixAnswer2")..", "..GetMGameValue(self, "matrixAnswer3")..", "..GetMGameValue(self, "matrixAnswer4"), 10)
    end
end



function SCR_STAGE3_BOOKCASE_11_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 11)
end


function SCR_STAGE3_BOOKCASE_12_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 12)
end


function SCR_STAGE3_BOOKCASE_13_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 13)
end


function SCR_STAGE3_BOOKCASE_14_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 14)
end


function SCR_STAGE3_BOOKCASE_15_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 15)
end


function SCR_STAGE3_BOOKCASE_21_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 21)
end


function SCR_STAGE3_BOOKCASE_22_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 22)
end


function SCR_STAGE3_BOOKCASE_23_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 23)
end


function SCR_STAGE3_BOOKCASE_24_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 24)
end


function SCR_STAGE3_BOOKCASE_25_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 25)
end


function SCR_STAGE3_BOOKCASE_31_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 31)
end


function SCR_STAGE3_BOOKCASE_32_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 32)
end


function SCR_STAGE3_BOOKCASE_33_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 33)
end


function SCR_STAGE3_BOOKCASE_34_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 34)
end


function SCR_STAGE3_BOOKCASE_35_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 35)
end


function SCR_STAGE3_BOOKCASE_41_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 41)
end


function SCR_STAGE3_BOOKCASE_42_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 42)
end


function SCR_STAGE3_BOOKCASE_43_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 43)
end


function SCR_STAGE3_BOOKCASE_44_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 44)
end


function SCR_STAGE3_BOOKCASE_45_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 45)
end


function SCR_STAGE3_BOOKCASE_51_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 51)
end


function SCR_STAGE3_BOOKCASE_52_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 52)
end


function SCR_STAGE3_BOOKCASE_53_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 53)
end


function SCR_STAGE3_BOOKCASE_54_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 54)
end


function SCR_STAGE3_BOOKCASE_55_DIALOG(self, pc)
    SCR_STAGE3_BOOKCASE_CHECK(self, pc, 55)
end


function SCR_STAGE3_BOOKCASE_CHECK(self, pc, num)
    AddScpObjectList(self, 'DIALOG_CHECK', pc)
    local mgameValueCheck = GetMGameValue(self, "3RD_CLEAR")
    if mgameValueCheck == 1 then
    
        if self.NumArg1 == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("PAST_FANTASY_LIBRARY_YOU_ALREADY_TAKE_ITEM"), 5)
            return
        end
    
        local numberCheckTable = {}
    
        for i = 1, 4 do
            numberCheckTable[i] = GetMGameValue(self, "matrixAnswer"..i)
        end
        
        if num == numberCheckTable[1] then
            if GetInvItemCount(pc, "UNIQUE_RAID_GIMMICK_ITEM_01") < 1 then
                local tx = TxBegin(pc)
                TxGiveItem(tx, "UNIQUE_RAID_GIMMICK_ITEM_01", 1, "UNIQUE_RAID_PAST_FANTASY_LIBRARY")
                local ret = TxCommit(tx)
                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PAST_FANTASY_LIBRARY_YOU_FIND_BOOKMARK"), 5)
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("PAST_FANTASY_LIBRARY_YOU_ALREADY_TAKE_THIS"), 5)
            end
    
        elseif num == numberCheckTable[2] then
            if GetInvItemCount(pc, "UNIQUE_RAID_GIMMICK_ITEM_02") < 1 then
                local tx = TxBegin(pc)
                TxGiveItem(tx, "UNIQUE_RAID_GIMMICK_ITEM_02", 1, "UNIQUE_RAID_PAST_FANTASY_LIBRARY")
                local ret = TxCommit(tx)
                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PAST_FANTASY_LIBRARY_YOU_FIND_BOOKMARK"), 5)
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("PAST_FANTASY_LIBRARY_YOU_ALREADY_TAKE_THIS"), 5)
            end
    
        elseif num == numberCheckTable[3] then
            if GetInvItemCount(pc, "UNIQUE_RAID_GIMMICK_ITEM_03") < 1 then
                local tx = TxBegin(pc)
                TxGiveItem(tx, "UNIQUE_RAID_GIMMICK_ITEM_03", 1, "UNIQUE_RAID_PAST_FANTASY_LIBRARY")
                local ret = TxCommit(tx)
                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PAST_FANTASY_LIBRARY_YOU_FIND_BOOKMARK"), 5)
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("PAST_FANTASY_LIBRARY_YOU_ALREADY_TAKE_THIS"), 5)
            end
            
        elseif num == numberCheckTable[4] then
            if GetInvItemCount(pc, "UNIQUE_RAID_GIMMICK_ITEM_04") < 1 then
                local tx = TxBegin(pc)
                TxGiveItem(tx, "UNIQUE_RAID_GIMMICK_ITEM_04", 1, "UNIQUE_RAID_PAST_FANTASY_LIBRARY")
                local ret = TxCommit(tx)
                SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("PAST_FANTASY_LIBRARY_YOU_FIND_BOOKMARK"), 5)
            else
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("PAST_FANTASY_LIBRARY_YOU_ALREADY_TAKE_THIS"), 5)
            end
            
        else
            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("PAST_FANTASY_LIBRARY_NOT_IN_HERE"), 5)
        end
        
    end
    return
end


function SCR_STAGE3_02_BOOKCASE_AI(self)
    local pcCheck = GetScpObjectList(self, "DIALOG_CHECK")
    if #pcCheck == nil and #pcCheck == 0 then
        return
    elseif #pcCheck ~= nil and #pcCheck ~= 0 then
        if self.NumArg3 > 0 then
            self.NumArg3 = self.NumArg3 +1
            if self.NumArg3 >= 3 then
                self.NumArg3 = 0
            end
        elseif self.NumArg3 == 0 then
            for i = 1, #pcCheck do
                PlayEffectLocal(self, pcCheck[i], "E_circle001", 0.4, nil, "TOP")
                self.NumArg3 = 1
            end
        end
    end
end




-- FOOTHOLD GIMMICK (3RD-02 STAGE)


function SCR_STAGE3_FOOTHOLD_MONSTER_CHECK_AI(self)
    local mgameValueCheck = GetMGameValue(self, "3RD_CLEAR")
    if mgameValueCheck == 1 then
        self.NumArg3 = self.NumArg3 +1
        if self.NumArg3 >= 5 then
            PlayEffect(self, "F_spread_out033_ground_light", 0.6, nil, "BOT")
            self.NumArg3 = 0
        end

        local monsterList, monsterCount = GetWorldObjectList(self, "MON", 30)
        if monsterCount ~= nil and monsterCount ~= 0 then
            for i = 1, monsterCount do
                if monsterList[i].SimpleAI == "STAGE3_02_MONSTER_AI" then
                    if self.NumArg2 < 10 then
                        self.NumArg2 = self.NumArg2 +1
                        Kill(monsterList[i])
                        monsterList[i].SimpleAI = "None"
                        PlayEffect(monsterList[i], "F_explosion128_dark_burst", 1, nil, "BOT")
                        if self.NumArg2 >= 10 then
                            PlayEffect(self, "F_lineup014_yellow", 3, nil, "BOT")
                        end
                    end
                end
            end
        end
    end
end


function SCR_STAGE3_FOOTHOLD_01_ENTER(self, pc)
    SCR_STAGE3_FOOTHOLD_CHECK(self, pc, 1)
end


function SCR_STAGE3_FOOTHOLD_02_ENTER(self, pc)
    SCR_STAGE3_FOOTHOLD_CHECK(self, pc, 2)
end


function SCR_STAGE3_FOOTHOLD_03_ENTER(self, pc)
    SCR_STAGE3_FOOTHOLD_CHECK(self, pc, 3)
end


function SCR_STAGE3_FOOTHOLD_04_ENTER(self, pc)
    SCR_STAGE3_FOOTHOLD_CHECK(self, pc, 4)
end


function SCR_STAGE3_FOOTHOLD_CHECK(self, pc, num)
    local mgameValueCheck = GetMGameValue(self, "3RD_CLEAR")
    if mgameValueCheck == 1 then
        if self.NumArg2 >= 10 then
            Chat(self, num..ScpArgMsg("PAST_FANTASY_LIBRARY_FOOTHOLD"..GetMGameValue(self, "bookmarkColor"..num)), 5)
        end
        
    end
    return
end




-- FOOTHOLD MONSTER SETTING




-- PASSWORD_HEADSTONE




function SCR_STAGE3_HEADSTONE_01_DIALOG(self, pc)
    SCR_STAGE3_HEADSTONE_CHECK(self, pc, 1)
end


function SCR_STAGE3_HEADSTONE_02_DIALOG(self, pc)
    SCR_STAGE3_HEADSTONE_CHECK(self, pc, 2)
end


function SCR_STAGE3_HEADSTONE_03_DIALOG(self, pc)
    SCR_STAGE3_HEADSTONE_CHECK(self, pc, 3)
end


function SCR_STAGE3_HEADSTONE_04_DIALOG(self, pc)
    SCR_STAGE3_HEADSTONE_CHECK(self, pc, 4)
end


function SCR_STAGE3_HEADSTONE_CHECK(self, pc, num)
    local mgameValueCheck = GetMGameValue(self, "3RD_CLEAR")
    if mgameValueCheck == 1 then
        if self.NumArg1 ~= 1 then
            if self.NumArg4 == 0 then
                local answerCheck = GetMGameValue(self, "bookmarkColor"..num)
                local distractor = ShowSelDlg(pc, 0, "PAST_FANTASY_LIBRARY_HEADSTONE", ScpArgMsg("PAST_FANTASY_LIBRARY_RED"), ScpArgMsg("PAST_FANTASY_LIBRARY_YELLOW"), ScpArgMsg("PAST_FANTASY_LIBRARY_GREEN"), ScpArgMsg("PAST_FANTASY_LIBRARY_BLUE"))
                if distractor == answerCheck then
                
                    local itemCheck1 = GetInvItemCount(pc, "UNIQUE_RAID_GIMMICK_ITEM_01")
                    local itemCheck2 = GetInvItemCount(pc, "UNIQUE_RAID_GIMMICK_ITEM_02")
                    local itemCheck3 = GetInvItemCount(pc, "UNIQUE_RAID_GIMMICK_ITEM_03")
                    local itemCheck4 = GetInvItemCount(pc, "UNIQUE_RAID_GIMMICK_ITEM_04")
                    
                    if distractor == 1 then
                        if itemCheck1 >= 1 then
                            local tx = TxBegin(pc)
                            TxTakeItem(tx, "UNIQUE_RAID_GIMMICK_ITEM_01", itemCheck1, "UNIQUE_RAID_PAST_FANTASY_LIBRARY")
                            local ret = TxCommit(tx)
                            SCR_STAGE3_HEADSTONE_CORRECT(self, pc)
    
                        elseif itemCheck1 < 1 then
                            PlayEffect(self, "F_buff_basic029_red_line", 1, nil, "BOT")
                            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("STAGE3_YOUR_ANSWER_IS_WRONG"), 5)
                        end
    
                    elseif distractor == 2 then
                        if itemCheck2 >= 1 then
                            local tx = TxBegin(pc)
                            TxTakeItem(tx, "UNIQUE_RAID_GIMMICK_ITEM_02", 1, "UNIQUE_RAID_PAST_FANTASY_LIBRARY")
                            local ret = TxCommit(tx)
                            SCR_STAGE3_HEADSTONE_CORRECT(self, pc)
    
                        elseif itemCheck2 < 1 then
                            PlayEffect(self, "F_buff_basic029_red_line", 1, nil, "BOT")
                            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("STAGE3_YOUR_ANSWER_IS_WRONG"), 5)
                        end
    
                    elseif distractor == 3 then
                        if itemCheck3 >= 1 then
                            local tx = TxBegin(pc)
                            TxTakeItem(tx, "UNIQUE_RAID_GIMMICK_ITEM_03", 1, "UNIQUE_RAID_PAST_FANTASY_LIBRARY")
                            local ret = TxCommit(tx)
                            SCR_STAGE3_HEADSTONE_CORRECT(self, pc)
    
                        elseif itemCheck3 < 1 then
                            PlayEffect(self, "F_buff_basic029_red_line", 1, nil, "BOT")
                            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("STAGE3_YOUR_ANSWER_IS_WRONG"), 5)
                        end
    
                    elseif distractor == 4 then
                        if itemCheck4 >= 1 then
                            local tx = TxBegin(pc)
                            TxTakeItem(tx, "UNIQUE_RAID_GIMMICK_ITEM_04", 1, "UNIQUE_RAID_PAST_FANTASY_LIBRARY")
                            local ret = TxCommit(tx)
                            SCR_STAGE3_HEADSTONE_CORRECT(self, pc)
    
                        elseif itemCheck4 < 1 then
                            PlayEffect(self, "F_buff_basic029_red_line", 1, nil, "BOT")
                            SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("STAGE3_YOUR_ANSWER_IS_WRONG"), 5)
                        end
    
                    end
                    
                elseif distractor ~= answerCheck then
    
                    PlayEffect(self, "F_buff_basic029_red_line", 1, nil, "BOT")
                    SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("STAGE3_YOUR_ANSWER_IS_WRONG"), 5)

                end
            elseif self.NumArg4 == 1 then
                SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("STAGE3_OBJECT_TRY_AFTER_FEW_SECONDS"), 5)
            end
        elseif self.NumArg1 == 1 then
            SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("STAGE3_YOU_ALREADY_SET_THIS_STONE"), 5)
        end
        
    elseif mgameValueCheck == 0 then
        SendAddOnMsg(pc, "NOTICE_Dm_scroll", ScpArgMsg("STAGE3_OBJECT_ACTIVE_NOT_YET"), 5)
    end
end


function SCR_STAGE3_HEADSTONE_CORRECT(self, pc)
    SendAddOnMsg(pc, "NOTICE_Dm_Clear", ScpArgMsg("STAGE3_YOUR_ANSWER_IS_CORRECT"), 5)
    PlayEffect(self, "F_buff_basic032_blue_line", 1, nil, "BOT")
    AttachEffect(self, "F_bg_statu_blue", 1, "BOT")
    self.NumArg1 = 1
    
    local answerPointCheck = GetMGameValue(self, "3RD_ANSWER_POINT")
    answerPointCheck = answerPointCheck +1
    SetMGameValue(self, "3RD_ANSWER_POINT", answerPointCheck)
end


function SCR_STAGE3_PORTAL_DIALOG(self, pc)
    UIOpenToPC(pc, 'fullblack', 1)
    SetPos(pc, 991, -64, 235)
    sleep(1000)
    UIOpenToPC(pc, 'fullblack', 0)

    local mgameValue = GetMGameValue(self, "4TH_CLEAR")
    if mgameValue ~= 1 then
        SetMGameValue(self, "4TH_CLEAR", 1)
    end
    
end




function SCR_STAGE3_BOOKMARK_WITHDRAW(self)
    local itemCheck1 = GetInvItemCount(self, "UNIQUE_RAID_GIMMICK_ITEM_01")
    local itemCheck2 = GetInvItemCount(self, "UNIQUE_RAID_GIMMICK_ITEM_02")
    local itemCheck3 = GetInvItemCount(self, "UNIQUE_RAID_GIMMICK_ITEM_03")
    local itemCheck4 = GetInvItemCount(self, "UNIQUE_RAID_GIMMICK_ITEM_04")

    if itemCheck1 == 1 then
        RunScript("TAKE_ITEM_TX", self, "UNIQUE_RAID_GIMMICK_ITEM_01", 1, "UNIQUE_RAID_PAST_FANTASY_LIBRARY")
    end
    
    if itemCheck2 == 1 then
        RunScript("TAKE_ITEM_TX", self, "UNIQUE_RAID_GIMMICK_ITEM_02", 1, "UNIQUE_RAID_PAST_FANTASY_LIBRARY")
    end
    
    if itemCheck3 == 1 then
        RunScript("TAKE_ITEM_TX", self, "UNIQUE_RAID_GIMMICK_ITEM_03", 1, "UNIQUE_RAID_PAST_FANTASY_LIBRARY")
    end
    
    if itemCheck4 == 1 then
        RunScript("TAKE_ITEM_TX", self, "UNIQUE_RAID_GIMMICK_ITEM_04", 1, "UNIQUE_RAID_PAST_FANTASY_LIBRARY")
    end
    
end




-- 4TH STAGE




function STAGE4_TRAP_TARGET_SETTING_AI(self)
    
    local target = GetScpObjectList(self, 'STAGE4_TRAP_TARGET')
    if #target == 0 then

        local pcList, pcCount = GetWorldObjectList(self, "PC", 300)
        if pcCount > 0 then
            for i = 1, pcCount do
                AddScpObjectList(self, 'STAGE4_TRAP_TARGET', pcList[i])
                return 1
            end
        end
--            for i = 1, pcCount do
--                if pcList[i].ClassName ~= 'PC' then
--                    AddScpObjectList(self, 'MFL_STAGE4_OBJ', list[i])
--                    return 1
--                end
--            end
    elseif #target ~= 0 then
    
        if GetHpPercent(target[1]) > 0.3 then
            MoveToTarget(self, target[1], 1)
        else
            ClearScpObjectList(self, 'STAGE4_TRAP_TARGET')
        end
    end
    
    local pc_List, pc_Count = GetWorldObjectList(self, "PC", 50)
    if pc_Count > 0 then
        for j = 1, pc_Count do
            TakeDamage(self, pc_List[j], "None", 1000, "Poison", "None", "TrueDamage", HIT_POISON, HITRESULT_BLOW);
        end
    end
    
end


function STAGE4_AGAILA_SETTING_AI(self)
    if GetMGameValue(self, "4TH_CLEAR") == 1 then
        SetDirectionByAngle(self, 90)
        PlayAnim(self, "event_loop2")
    elseif GetMGameValue(self, "4TH_CLEAR") == 2 then
        SetDirectionByAngle(self, -90)
        ResetStdAnim(self)
        if self.NumArg4 == 0 or self.NumArg4 == nil then
            StopAnim(self)
            Chat(self, ScpArgMsg('PAST_FANTASY_LIBRARY_STAGE4_AGAILA_01'), 5)
            self.NumArg4 = 1
        elseif self.NumArg4 == 1 then
            StopAnim(self)
            self.NumArg4 = 2
        elseif self.NumArg4 == 2 then
            AttachEffect(self, 'F_wizard_stop_shot_loop', 2, "BOT")
            AttachEffect(self, 'F_ground141_light_blue_lop', 2, "BOT")
            PlayEffect(self, 'F_spread_in023_blue', 1)
            Chat(self, ScpArgMsg('PAST_FANTASY_LIBRARY_STAGE4_AGAILA_02'), 5)
            self.NumArg4 = 3
        elseif self.NumArg4 == 3 then
            Kill(self)
            DetachEffect(self, 'F_wizard_stop_shot_loop')
            DetachEffect(self, 'F_ground141_light_blue_loop')
            PlayEffect(self, 'F_spread_out032_2', 2)
            self.NumArg4 = 4
        end
    end
end




-- 5TH STAGE




function STAGE5_HAUBERK_SETTING_AI(self)
    local hauberkActiveStep = GetMGameValue(self, 'HAUBERK_ACTIVE')
    
    if hauberkActiveStep == 0 then -- if hauberk escape stage is started then
        SetFixAnim(self, 'STUN')
        SetMGameValue(self, 'HAUBERK_ACTIVE', 1)
        
        
    elseif hauberkActiveStep == 1 then -- if hauberk escape stage is doing then
        if self.NumArg3 == 0 then
            Chat(self, ScpArgMsg('MFL_STAGE5_NPC_HAUBERK_1_0'), 8)
            self.NumArg3 = 1
        elseif self.NumArg3 == 1 then
            self.NumArg3 = 2
        elseif self.NumArg3 == 2 then
            self.NumArg3 = 0
        end
        return 1
        
        
    elseif hauberkActiveStep == 2 then -- if hauberk escape stage is cleared 
        if self.NumArg4 == 0 then
            SetFixAnim(self, 'ASTD')
            Chat(self, ScpArgMsg('MFL_STAGE5_NPC_HAUBERK_1_1'), 4)
            self.NumArg4 = 1
        elseif self.NumArg4 == 1 then
            Chat(self, ScpArgMsg('MFL_STAGE5_NPC_HAUBERK_1_2'), 4)
            self.NumArg4 = 2
            SetMGameValue(self, 'HAUBERK_ACTIVE', 3)
        end
        
        
    elseif hauberkActiveStep == 3 then -- if 6 stage isn't started then
        local x, y, z = GetPos(self)
        local dis_from = SCR_POINT_DISTANCE(x, z, 4, 872)
        if dis_from > 10 then
            MoveEx(self, 4, 872, 1)
        else -- if hauberk moved near object then
            Chat(self, ScpArgMsg('MFL_STAGE5_NPC_HAUBERK_1_4'), 4)
            SetMGameValue(self, 'HAUBERK_ACTIVE', 4)
            self.NumArg4 = 0
            return 1
        end
        Chat(self, ScpArgMsg('MFL_STAGE5_NPC_HAUBERK_1_3'), 4)
        
        
    elseif hauberkActiveStep == 4 then -- if 6 stage is doing then
        SetDirectionByAngle(self, 90)
        PlayAnim(self, 'EVENT_SKL', 0)
        return 1
        
        
    elseif hauberkActiveStep == 5 then -- if 6 stage clear then
        if self.NumArg4 == 0 then
            SetFixAnim(self, 'ASTD')
            Chat(self, ScpArgMsg('MFL_STAGE5_NPC_HAUBERK_1_5'), 4)
            self.NumArg4 = 1
        elseif self.NumArg4 == 1 then
            SetMGameValue(self, 'HAUBERK_ACTIVE', 6)
            self.NumArg4 = 2
        end
        
        
    elseif hauberkActiveStep == 6 then -- if 6 stage is ended then
        local x, y, z = GetPos(self)
        local dis_from = SCR_POINT_DISTANCE(x, z, -347, 747)
        if dis_from > 10 then
            MoveEx(self, -347, 747, 1)
        else
            SetMGameValue(self, 'HAUBERK_ACTIVE', 7)
            self.NumArg4 = 0
            return 1
        end
        
        
    elseif hauberkActiveStep == 7 then -- if 7 stage is doing then
        return 0
        
    elseif hauberkActiveStep == 8 then -- if 7 stage is doing then
        S_AI_ATTACK_NEAR_WITH(self, 1000)
    
    elseif hauberkActiveStep == 9 then --if kill boss in 8th stage then
        if self.NumArg4 == 0 then
            SetFixAnim(self, 'ASTD')
            Chat(self, ScpArgMsg('MFL_STAGE5_NPC_HAUBERK_1_6'), 4)
            self.NumArg4 = 1
        elseif self.NumArg4 == 1 then
            SetMGameValue(self, 'HAUBERK_ACTIVE', 10)
        end
        
    elseif hauberkActiveStep == 10 then
        if self.NumArg4 == 1 then
            AttachEffect(self, 'F_light055_black', 15, 'TOP')
            self.NumArg4 = 2
        elseif self.NumArg4 == 2 then
            PlayEffect(self, 'F_explosion098_dark_mint', 2)
            Kill(self)
        end
    end
    
    return 1
end




-- 6TH STAGE




function SCR_STAGE6_OBJECT_CHANGE_FACTION_HAUBERK(self)
    self.Faction = "FreeForAll"
end


function SCR_STAGE6_MONSTER_DEAD(self, killer)
    local objectList, objectCount = GetWorldObjectList(self, "MON", 200)
    local hauberk
    if objectCount > 0 then
        for i = 1, objectCount do
            if objectList[i].ClassName == 'MFL_boss_hauberk' then
                hauberk = objectList[i]
            end
        end
    end
    local skill = GetNormalSkill(self);
    ForceDamage(self, skill, hauberk, self, 0, 'MOTION', 'BLOW', 'I_force072_darkgreen', 1, 'arrow_cast', 'F_buff_basic031_green_line', 1, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1)
end


function SCR_STAGE7_LAYER_SAVE(self)
    local layer = GetLayer(self)
    SetMGameValue(self, "Layer", layer)
end


function SCR_STAGE7_PREVIOUS_DIRECTION_START_ENTER(self, pc)
    if self.NumArg1 == 0 or self.NumArg1 == nil then
        local pcList, pcCount = GET_PARTY_ACTOR(pc, 0) -- Party Member Check
        PlayDirection(pc, 'PAST_FANTASY_LIBRARY_STAGE7_PREVIOUS', 0, 1)
        
        for i = 1, pcCount do
            if IsSameActor(pcList[i], pc) == 'NO' then -- If that member isn't same pc then
                if GetLayer(pc) == GetLayer(pcList[i]) then -- If that member in same layer with you then
                    AddDirectionPC(pc, pcList[i])
                    ReadyDirectionPC(pc, pcList[i]);
                end
            end
        end

        if self.NumArg1 == 0 or self.NumArg1 == nil then -- Check One more time
            StartDirection(pc)
            self.NumArg1 = 1
        else
            return
        end
        
    end
end


function SCR_STAGE7_PREVIOUS_DIRECTION_END(self)
    local layer = GetMGameValue(self, "Layer")
    SetLayer(self, layer)
    SetMGameValue(self, "SUMMON_VALDOVAS", 1)
    SetMGameValue(self, 'HAUBERK_ACTIVE', 8)
    SetMGameValue(self, 'BOSS_EVENT', 1)
    SetMGameValue(self, '7TH_CLEAR', 1)
end




-- 7TH STAGE




function SCR_STAGE7_PORTAL_DIALOG(self, pc)
    UIOpenToPC(pc, 'fullblack', 1)
    SetPos(pc, 1598, -83, 138)
    sleep(1000)
    UIOpenToPC(pc, 'fullblack', 0)

    local mgameValue = GetMGameValue(self, "7TH_CLEAR")
    if mgameValue ~= 3 then
        SetMGameValue(self, "7TH_CLEAR", 3)
    end
    
end




-- 8TH STAGE




function SCR_STAGE8_AGAILA_DIALOG(self, pc)
    local agailaActiveStep = GetMGameValue(self, '8TH_CLEAR')
    if agailaActiveStep == 2 then
        if self.NumArg4 == 3 then
            local distractor = ShowSelDlg(pc, 0,"MFL_STAGE8_NPC_1", ScpArgMsg("MFL_STAGE8_NPC_1_SEL_1"), ScpArgMsg("MFL_STAGE8_NPC_1_SEL_START"))
    
            if distractor == 1 then
                ShowOkDlg(pc, 'MFL_STAGE8_NPC_1_SEL_1_TXT_1', 1)
    
            elseif distractor == 2 then
    
                local dialogCheck = GetExProp(pc, "dialogCheck")
                local pcList, pcCount = GetWorldObjectList(self, "PC", 350)

                if pcCount ~= nil and pcCount ~= 0 then
                    if dialogCheck ~= nil and dialogCheck ~= 0 then -- if you already checking to agaila then
                    
                        if self.NumArg1 < pcCount then
                            ShowOkDlg(pc, 'MFL_STAGE8_NPC_READY', 1) -- please ready to other member is ready
                        elseif self.NumArg1 >= pcCount then
                            SCR_STAGE9_IN_DIRECTION_SETTING(self, pc)
                        end
                        
                    elseif dialogCheck == nil or dialogCheck == 0 then -- if you don't checking to agaila then
                        SetExProp(pc, "dialogCheck", 1)
                        self.NumArg1 = self.NumArg1 +1
                        
                        if self.NumArg1 >= pcCount then -- if all member ready to go final stage then
                            SCR_STAGE9_IN_DIRECTION_SETTING(self, pc)
                        else
                            ShowOkDlg(pc, 'MFL_STAGE8_NPC_READY', 1)
                        end
                        
                    end
                end
            end
        end
    elseif agailaActiveStep ~= 1 then
        return
    end
    return
end




function SCR_STAGE9_IN_DIRECTION_SETTING(self, pc)
    local pcList, pcCount = GetWorldObjectList(self, "PC", 350)
    PlayDirection(pc, 'M_FLIBRAY_BOSS_BEFORE', 0, 1)
    if pcCount > 0 then
        for i = 1, pcCount do
            if IsSameActor(pcList[i], pc) == 'NO' then
                if GetLayer(pc) == GetLayer(pcList[i]) then
                    AddDirectionPC(pc, pcList[i])
                    ReadyDirectionPC(pc, pcList[i]);
                end
            end
        end
    end
    StartDirection(pc)
    SetMGameValue(self, '8TH_CLEAR', 3)
end




function SCR_STAGE8_AGAILA_ACTIVE_AI(self)
    local agailaActiveStep = GetMGameValue(self, "8TH_CLEAR")
    if agailaActiveStep == 1 then
        if self.NumArg4 == 0 or self.NumArg4 == nil then
            SetDirectionByAngle(self, -45)
            PlayAnim(self, "event_loop2")
            Chat(self, ScpArgMsg("PAST_FANTASY_LIBRARY_STAGE9_AGAILA_01"), 4)
            self.NumArg4 = 1
        elseif self.NumArg4 == 1 then
            SetDirectionByAngle(self, -45)
            PlayAnim(self, "event_loop2")
        end

    elseif agailaActiveStep == 2 then
        if self.NumArg4 == 1 then
            StopAnim(self)
            Chat(self, ScpArgMsg("PAST_FANTASY_LIBRARY_STAGE9_AGAILA_02"), 4)
            self.NumArg4 = 2
        elseif self.NumArg4 == 2 then
            StopAnim(self)
            SetMGameValue(self, "AGAILA_ACTIVE", 1)
            self.NumArg4 = 3
        end
    end
end




function SCR_STAGE8_HAUBERK_ACTIVE_AI(self)
    local hauberkActiveStep = GetMGameValue(self, "8TH_CLEAR")
    if hauberkActiveStep == 1 then
        SetDirectionByAngle(self, 45)
        PlayAnim(self, 'EVENT_SKL', 45)
    elseif hauberkActiveStep == 2 then
        StopAnim(self)
    end
end




function SCR_STAGE8_PORTAL_AI(self)
    local portalActiveStep = GetMGameValue(self, "8TH_CLEAR")
    if portalActiveStep == 2 then
        if self.NumArg3 == 0 or self.NumArg3 == nil then
            AttachEffect(self, "F_item_drop_line_loop_white", 5, "BOT")
            self.NumArg3 = 1
        end
    elseif portalActiveStep == 3 then
        if self.NumArg3 == 1 then
            AttachEffect(self, "F_circle25_blue", 4, "BOT")
            self.NumArg3 = 2
        end
    end
end



function SCR_adgasdklhasklgas(self)
    PlayDirection(self, "M_FLIBRAY_BOSS_BEFORE")
end



function SCR_STAGE8_PORTAL_DIALOG(self)
    local mgameCheck = GetMGameValue(self, "9TH_CLEAR")
    if mgameCheck == 1 then
        UIOpenToPC(pc, 'fullblack', 1)
        SetPos(pc, 1436, -8, 729)
        sleep(1000)
        UIOpenToPC(pc, 'fullblack', 0)
    end
end



-- 9TH STAGE




function SCR_STAGE9_PREVIOUS_DIRECTION_END(self)
    local layer = GetMGameValue(self, "Layer")
    SetLayer(self, layer)
    SetMGameValue(self, '9TH_CLEAR', 1)
end




function SCR_INTRO_STAGE_GO_TO_STAGE9_PORTAL_DIALOG(self, pc)
    local mgameCheck = GetMGameValue(self, "9TH_CLEAR")
    if mgameCheck == 1 then
        UIOpenToPC(pc, 'fullblack', 1)
        SetPos(pc, 1436, -8, 729)
        sleep(1000)
        UIOpenToPC(pc, 'fullblack', 0)
    end
end




function SCR_STAGE9_BOSS_DEAD_SCRIPT_SETTING(self)
    SetDeadScript(self, "SCR_STAGE9_BOSS_DEAD")
end




function SCR_STAGE9_BOSS_DEAD(self)
    SetMGameValue(self, "MFL_STAGE9_BOSS_1", 1)
    SetMGameValue(self, "9TH_CLEAR", 2)
end


function SCR_CHEAT_NumCheck_CHECK(self, num)
    Chat(self, num, 1)
end
