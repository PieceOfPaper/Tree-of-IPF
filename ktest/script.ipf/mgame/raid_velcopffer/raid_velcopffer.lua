--riad_velcopffer.lua

--벨코퍼 입장.
function SCR_VELLCOFFER_ENTER_01_DIALOG(self, pc)

    local pcLvCheck = pc.Lv
    if pcLvCheck >= 300 then
        AddHelpByName(pc, "TUTO_VELCOFFER_RAID")
    end

    local dialog_list ={}
    local dialog_ck = {}

    dialog_list[#dialog_list+1] = ScpArgMsg("StartGame")
    dialog_ck[#dialog_ck+1] = 'StartGame'


    local select = SCR_SEL_LIST(pc, dialog_list, 'RAID_VELLCOFFER_ENTER')
    local sel_dialog = dialog_ck[select]

    
    if sel_dialog == 'StartGame' then
        INDUN_ENTER_DIALOG_AND_UI(pc, 'RAID_VELLCOFFER_ENTER', 'Raid_Velcoffer_guard', 0, 0);
        return;
    end
end


function SCR_STAGE_ONE_STATUE_SUMMON(self)
    local x, y, z = GetPos(self)
    local followerList, followercnt = GetFollowerList(self);
    local limitCnt = 6;
    if followercnt < limitCnt then
        for i = 1, limitCnt - followercnt do
            RunScript('SCR_STAGE_ONE_STATUE_SUMMON_TIME', self, x, y, z)
        end
        PlayEffect(self, 'F_buff_basic023_red_fire', 1.5, 'BOT');
    elseif followercnt > limitCnt then
        for i = limitCnt + 1, followercnt do
            Kill(followerList[i]);
        end
    end
end

function SCR_STAGE_ONE_STATUE_SUMMON_TIME(self, x, y, z)
    local time = IMCRandom(0, 1500);
    sleep(time);
    local dPos = SCR_DOUGHNUT_RANDOM_POS(x, z, 50, 100)
    local angle = GetAngleFromPos(self, dPos['x'], dPos['z'])
    local summonMon = CREATE_MONSTER_EX(self, 'summon_velcoffer_guard_mini', dPos['x'], y, dPos['z'], angle, 'Monster', nil);
    DisableBornAni(summonMon)
    PlayEffectToGround(self, 'F_buff_basic001_violet', dPos['x'], y, dPos['z'], 0.7);
    SetOwner(summonMon,self,0)
end

function SCR_STAGE_TWO_MINIMAL_BOSS_SUMMON(self)
    local x, y, z = GetPos(self)
    RunScript('SCR_STAGE_TWO_MINIMAL_BOSS_SUMMON_TIME', self, x, y, z)
end

function SCR_STAGE_TWO_MINIMAL_BOSS_SUMMON_TIME(self, x, y, z)
    local time = GetExProp_Str(self, "NEXT_TIME");
    
    if time == nil or time == 'None' then
        time = GetAddDataFromCurrent(0);
    end
    
    if GetTimeDiff(time) < 0 then
        return;
    end
    
    local summonMonList = GetScpObjectList(self, 'SUMMON_MONSTER');
    
    local summonTable = { 'Raid_boss_Taumas_minimal', 'Raid_boss_Gremlin_minimal', 'Raid_boss_Malletwyvern_minimal', 'Raid_boss_Gaigalas_minimal' };
    
    local summonPhase = GetExProp(self, 'SUMMON_PHASE');
    
    if summonPhase ~= 0 and summonPhase == nil then
        summonPhase = 0;
    end
    if #summonTable <= math.ceil(#summonMonList/2) then
            return;
    end
    
    if summonPhase >= #summonTable then
        summonPhase = 0;
    end
    
    for i = 1, 2 do
        local dPos = SCR_DOUGHNUT_RANDOM_POS(x, z, 100, 200)
        local angle = GetAngleFromPos(self, dPos['x'], dPos['z'])
        local mon = CREATE_MONSTER_EX(self, summonTable[summonPhase + 1], dPos['x'], y, dPos['z'], angle, 'Monster', nil);
        AddScpObjectList(self, 'SUMMON_MONSTER', mon)
        PlayEffectToGround(self, 'F_buff_basic001_violet', dPos['x'], y, dPos['z'], 1.0);
    end
    local afterPhase = GetExProp(self, 'AFTER_PHASE')
    
    if afterPhase ~= 0 and afterPhase == nil then
        afterPhase = 0;
    end
    
    SetExProp(self, 'SUMMON_PHASE', summonPhase + 1);
    SetExProp(self, 'AFTER_PHASE', afterPhase + 1)
    

    local nextTime = GetAddDataFromCurrent(40 - (5 * summonPhase));
    if afterPhase > 4 then
        nextTime = GetAddDataFromCurrent(5);
    end
    SetExProp_Str(self, "NEXT_TIME", nextTime);
end

function SCR_STAGE_ONE_GIVE_BUFF_GIMMICK(self)
    local monList, monCnt = SelectObject(self, 3000, 'FRIEND');
    PlayEffect(self, 'F_buff_basic023_red_fire', 1.5, 'BOT');
    for i = 1, monCnt do
        local mon = monList[i]
        if mon.ClassName == 'summon_velcoffer_guard_mini' then
            if IsBuffApplied(mon, 'Mon_raid_Rage') == 'NO' then
                AddBuff(self, mon, 'Mon_raid_Rage', 1, 0, 15000, 1)
            end
        end
        
        if mon.ClassName == 'statue_velcofer' then
            Heal(mon, 200000, 0)
        end
    end
end

function SCR_TERAMON_THE_SUMMONS_MONSTER(self)
    local x, y, z = GetPos(self)
    local followerList, followercnt = GetFollowerList(self);
    local limitCnt = 3;
    if followercnt < limitCnt then
        for i = 1, limitCnt - followercnt do
            RunScript('SCR_TERAMON_THE_SUMMONS_MONSTER_TABLE', self, x, y, z)
        end
        PlayEffect(self, 'F_buff_basic023_red_fire', 1.5, 'BOT');
    elseif followercnt > limitCnt then
        for i = limitCnt + 1, followercnt do
            Kill(followerList[i]);
        end
    end
end

function SCR_TERAMON_THE_SUMMONS_MONSTER_TABLE(self, x, y, z)
    local phase = GetExProp(self, 'PHASE')
    if phase ~= 0 and phase == nil then
        phase = 0
    end
    if phase ~= 0 and phase <= 3 then
        return;
    end
    
    local time = IMCRandom(0, 1500);
    local randomDraw = IMCRandom(1, 3)
    sleep(time);
    local teraSummonTable = {'Raid_summon_tala_sorcerer','Raid_summon_tala_combat','Raid_summon_warleader_tala'}
    local dPos = SCR_DOUGHNUT_RANDOM_POS(x, z, 50, 100)
    local angle = GetAngleFromPos(self, dPos['x'], dPos['z'])
    local summonMon = CREATE_MONSTER_EX(self, teraSummonTable[randomDraw], dPos['x'], y, dPos['z'], angle, 'Monster', nil);
    DisableBornAni(summonMon)
    PlayEffectToGround(self, 'F_buff_basic001_violet', dPos['x'], y, dPos['z'], 0.7);
    SetOwner(summonMon,self,1)
    SetExProp(self, 'PHASE',phase + 1)
end

function SCR_DOTIMEACTION_SEALSTONE_DIALOG(self,pc)
    local HPcntMsg = GetExProp(self, 'HP_COUNT_MSG')
    if IsBuffApplied(pc, 'RAID_VELCOFFER_GIMMICK_BUFF') == 'NO' then
        local damage = 1000
        local angle = GetAngleTo(self, pc);
        PlayEffect(self, 'F_burstup005_dark', 3, 'TOP');
        TakeDamage(self, pc, 'None', damage, "None", "None", "AbsoluteDamage", HIT_REFLECT, HITRESULT_BLOW);
        KnockBack(pc, self, 200, angle, 10, 0)
        ShowBalloonText(pc, "Raid_VELCOFFER_SHOWBALLOON_MSG1", 5)
    end
    if IsBuffApplied(pc, 'RAID_VELCOFFER_GIMMICK_BUFF') == 'YES' then
        PlaySound(self, 'system_craft_bargauge')
        local sealClear = DOTIMEACTION_R(pc, ScpArgMsg("VelcofferSealStoneScrMsg"), "UDUMBARA_CAST", 10)
        if sealClear ==1 then 
            if HPcntMsg ~= 0 and HPcntMsg == nil or HPcntMsg == 'None' then
                HPcntMsg = 0;
            end
            
            local zoneID = GetZoneInstID(self)
            local layer = GetLayer(self);
            local list, cnt = GetLayerPCList(zoneID, layer);
            if cnt == 0 then
                return
            end
            for i = 1, cnt do
                local targetPC = list[i]
                if HPcntMsg == 0 or HPcntMsg <= 1 then
                    ShowBalloonText(targetPC, "Raid_VELCOFFER_SHOWBALLOON_MSG7", 5)
                elseif HPcntMsg > 1 and HPcntMsg <= 2 then
                    ShowBalloonText(targetPC, "Raid_VELCOFFER_SHOWBALLOON_MSG8", 5)
                elseif HPcntMsg > 2 and HPcntMsg <= 3 then
                    ShowBalloonText(targetPC, "Raid_VELCOFFER_SHOWBALLOON_MSG9", 5)
                elseif HPcntMsg == 4 then
                    ShowBalloonText(targetPC, "Raid_VELCOFFER_SHOWBALLOON_MSG10", 5)
                    Dead(self, 0.5)
                end
            end
            SetExProp(self, 'HP_COUNT_MSG', HPcntMsg + 1)
            RemoveBuff(pc, 'RAID_VELCOFFER_GIMMICK_BUFF');
        end
    end
end

function SCR_SEALSTONE_DEBUFF_PROTECTED_DIALOG(self, pc)
    if IsBuffApplied(self, 'VELCOPFFER_GIMMICK_TIMER_BUFF') == 'YES' then
        ShowBalloonText(pc, "Raid_VELCOFFER_SHOWBALLOON_MSG2", 5)
    end
    
    if IsBuffApplied(self, 'VELCOPFFER_GIMMICK_TIMER_BUFF') == 'NO' and IsBuffApplied(pc, 'VELCOPFFER_GIMMICK_SACRIFICE_BUFF') == 'NO' then
        ShowBalloonText(pc, "Raid_VELCOFFER_SHOWBALLOON_MSG3", 5)
    end
    
    if  IsBuffApplied(self, 'VELCOPFFER_GIMMICK_TIMER_BUFF') == 'NO' and IsBuffApplied(pc, 'VELCOPFFER_GIMMICK_SACRIFICE_BUFF') == 'YES' then
        local dialog = DOTIMEACTION_R(pc, ScpArgMsg("VelcofferBlessScrMsg"), "ABSORB_EVENT", 1.5)
        if dialog == 1 then
            AddBuff(self, self, 'VELCOPFFER_GIMMICK_TIMER_BUFF', 1, 0, 25000, 1)
            AddBuff(self, pc, 'RAID_VELCOFFER_GIMMICK_BUFF', 1, 0, 20000, 1)
            RemoveBuff(pc, 'VELCOPFFER_GIMMICK_SACRIFICE_BUFF');
            ShowBalloonText(pc, "Raid_VELCOFFER_SHOWBALLOON_MSG6", 5)
        end
    end
end

function SCR_DEAD_AFTER_SUMMON_CRYSTAL(self)
    local x, y, z = GetPos(self)
    local crystalSummon = CREATE_MONSTER_EX(self, 'd_raid_spell_crystal_red', x, y, z, 0, 'Trigger', nil);
    PlayEffectToGround(self, 'F_buff_basic001_violet', x, y, z, 0.7);
end

function SCR_RED_CRYSTAL_DIALOG(self, pc)
    if IsBuffApplied(pc, 'VELCOPFFER_GIMMICK_SACRIFICE_BUFF') == 'NO' then
        local crystalDialog = DOTIMEACTION_R(pc, ScpArgMsg("VelcofferTeraStoneScrMsg"), "ABSORB_EVENT", 1)
        if crystalDialog == 1 then
            AddBuff(self, pc, 'VELCOPFFER_GIMMICK_SACRIFICE_BUFF', 1, 0, 0, 1)
            ShowBalloonText(pc, "Raid_VELCOFFER_SHOWBALLOON_MSG5", 5)
        end
    else
        ShowBalloonText(pc, "Raid_VELCOFFER_SHOWBALLOON_MSG4", 5)
    end
end

function SCR_BORN_RED_CRYSTAL_LIFE_TIME(self)
    local myLifeTime = SetLifeTime(self,5)
    AttachEffect(self, 'F_light082_line_red', 1, 'BOT');
end

function SCR_DEAD_EXPROSION_VELCOFFER_GIMMICK(self)
    local range = 40
    local damage = IMCRandom(5000, 15000)
    local objList, objCount = SelectObject(self, range, 'ALL');
    PlayEffect(self, 'F_explosion016_red', 0.5, 'BOT');
    for i = 1, objCount do
        local obj = objList[i]
        local angle = GetAngleTo(self,obj)
        if obj ~= 0 and obj ~= nil then
            if IS_PC(obj) == true then
                TakeDamage(self, obj, 'None', damage, "None", "None", "AbsoluteDamage", HIT_REFLECT, HITRESULT_BLOW);
                KnockBack(obj, self, 150, angle, 45, 1);
            end
            if obj.ClassName == 'd_raid_velcoffer_fallen_statue_gray' then
                TakeDamage(obj, obj, 'None', damage, "None", "None", "AbsoluteDamage", HIT_REFLECT, HITRESULT_BLOW);
            end
        end
    end
end

function SCR_FOURTH_STAGE_MAGIC_SQUARE_SUMMON_MONSTER(self)
    local x, y, z = GetPos(self)
    local followerCnt = GetScpObjectList(self, 'CREATEMONSTER')
    local limitCnt = 1
    if #followerCnt < limitCnt then
        PlayEffect(self, 'F_buff_basic001_violet', 0.5, 'BOT');
        local summonMon = CREATE_MONSTER_EX(self, 'd_raid_velcoffer_Shardstatue', x, y, z, 0, 'Monster', nil);
        AddScpObjectList(self, 'CREATEMONSTER', summonMon)
    end
end

function SCR_VELCOFFER_ROOM_WARP_POTAL_MAKE(self)
    local x, y, z = GetPos(self)
    local warpPotalSummon = CREATE_MONSTER_EX(self, 'd_raid_Warp_maig_square', x, y, z, 0, 'MISC', nil);
end

function SCR_VELCOFFER_ROOM_WARP_POTAL_DIALOG(self, pc)
    local x, y, z = GetPos(self)
    local warpDialog = DOTIMEACTION_R(pc, ScpArgMsg("VelcofferWarpMsg"), "EVENT_WARP", 4)
    if warpDialog == 1 then
        SCR_SETPOS_FADEOUT(pc, 'd_raidboss_velcoffer', 1996, 137, -508)
    end
end

function SCR_VELCOFFER_NOTICE_ENTER(self, pc)
    local pcList = GetScpObjectList(self, "ENTER_PC_LIST")
    if #pcList >= 1 then
        for i = 1, #pcList do
            local enterPC = pcList[i];
            if IsSameActor(enterPC, pc) == 'YES' then
                return;
            end
        end
    end
    
    AddScpObjectList(self, "ENTER_PC_LIST", pc)
    ShowBalloonText(pc, "Raid_VELCOFFER_SHOWBALLOON_MSG11", 5)
end

function SCR_VELCOFFER_ENTER_NOTICE_ENTER(self, pc)
    local pcList = GetScpObjectList(self, "ENTER_PC_LIST")
    if #pcList >= 1 then
        for i = 1, #pcList do
            local enterPC = pcList[i];
            if IsSameActor(enterPC, pc) == 'YES' then
                return;
            end
        end
    end
    
    AddScpObjectList(self, "ENTER_PC_LIST", pc)
    ShowBalloonText(pc, "Raid_VELCOFFER_SHOWBALLOON_MSG12", 5)
end

function SCR_VELCOFFER_STAGE_FOUR_ENTER(self, pc)
    local pcList = GetScpObjectList(self, "ENTER_PC_LIST")
    if #pcList >= 1 then
        for i = 1, #pcList do
            local enterPC = pcList[i];
            if IsSameActor(enterPC, pc) == 'YES' then
                return;
            end
        end
    end
    
    AddScpObjectList(self, "ENTER_PC_LIST", pc)
    ShowBalloonText(pc, "Raid_VELCOFFER_SHOWBALLOON_MSG13", 5)
end

function SCR_VELCOFFR_RAID_DEBUFF_MON_HANDLE_SET(self)
    local casterHandle = GetHandle(self)
    SetMGameValue(self, 'casterHandle', casterHandle)
end

function SCR_VELCOFFR_RAID_PC_DEBUFF_CHECK(self)
    local casterHandler = GetMGameValue(self, 'casterHandle')
    local zoneInst = GetZoneInstID(self)
    local caster = GetByHandle(zoneInst, casterHandler)
    
    if IsBuffApplied(self, 'Raid_Velcofer_Cnt_Debuff') ~= 'NO' then
        return
    end

    if IsBuffApplied(self, 'Raid_Velcofer_Curse_Debuff') ~= 'NO' then
        return
    end
    
    if IsBuffApplied(self, 'Raid_Velcofer_Last_Curse_Debuff') ~= 'NO' then
        return
    end

    AddBuff(caster, self, 'Raid_Velcofer_Cnt_Debuff', 1, 0, 0, 1);
end

function MON_BORN_STAGE_TWO_ALTAR_EFFECT(self)
    AttachEffect(self, 'F_levitation006_loop', 1, 'BOT');
end

function SCR_VELCOFFER_STATUE_NOTICE_ENTER(self, pc)
    local pcList = GetScpObjectList(self, "ENTER_PC_LIST")
    if #pcList >= 1 then
        for i = 1, #pcList do
            local enterPC = pcList[i];
            if IsSameActor(enterPC, pc) == 'YES' then
                return;
            end
        end
    end
    
    AddScpObjectList(self, "ENTER_PC_LIST", pc)
    ShowBalloonText(pc, "Raid_VELCOFFER_SHOWBALLOON_MSG14", 5)
end

function SCR_VELCOFFR_RAID_PC_DEBUFF_REMOVE(self)
    RemoveBuff(self, 'Raid_Velcofer_Cnt_Debuff')
    RemoveBuff(self, 'Raid_Velcofer_Last_Curse_Debuff')
    RemoveBuff(self, 'Raid_Velcofer_Curse_Debuff')
end

function SCR_VELLCOFFER_SOUND_ENTER(self, pc)
    PlayMusicQueueLocal(pc, "boss_velcoffer")
end


function SCR_VELCOFFER_USING_SKILL_PROP_RESET(self)
    SetExProp(self, 'firsttime', 0)
end