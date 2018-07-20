-- Stoup_Exp
function SCR_BUFF_ENTER_Stoup_Exp(self, buff, arg1, arg2, over)
    self.BonusExp_BM = self.BonusExp_BM + 100

end

function SCR_BUFF_LEAVE_Stoup_Exp(self, buff, arg1, arg2, over)

    self.BonusExp_BM = self.BonusExp_BM - 100
end

-- Calm
function SCR_BUFF_ENTER_Calm(self, buff, arg1, arg2, over)

    self.MSPD_BM = self.MSPD_BM - 80
    InvalidateStates(self);

end

function SCR_BUFF_LEAVE_Calm(self, buff, arg1, arg2, RemainTime)

    self.MSPD_BM = self.MSPD_BM + 80
    InvalidateStates(self);

end


-- Bube_Holy1
function SCR_BUFF_ENTER_Bube_Holy1(self, buff, arg1, arg2, over)

    self.DEF_BM = self.DEF_BM - 5;

end

function SCR_BUFF_LEAVE_Bube_Holy1(self, buff, arg1, arg2, over)

    self.DEF_BM = self.DEF_BM + 5;

end

-- Bube_Holy2
function SCR_BUFF_ENTER_Bube_Holy2(self, buff, arg1, arg2, over)

    self.MSPD_BM = self.MSPD_BM - 10;

end

function SCR_BUFF_LEAVE_Bube_Holy2(self, buff, arg1, arg2, over)

    self.MSPD_BM = self.MSPD_BM + 10;

end

-- Bube_Holy4
function SCR_BUFF_ENTER_Bube_Holy4(self, buff, arg1, arg2, over)

    self.DEF_BM = self.DEF_BM - 7;
    self.ATK_BM = self.ATK_BM + 10;

end

function SCR_BUFF_LEAVE_Bube_Holy4(self, buff, arg1, arg2, over)

    self.DEF_BM = self.DEF_BM + 7;
    self.ATK_BM = self.ATK_BM - 10;

end

-- ATKUP
function SCR_BUFF_ENTER_ATKUP(self, buff, arg1, arg2, over)

    self.ATK_BM = self.ATK_BM + (arg1 * 5);

end

function SCR_BUFF_LEAVE_ATKUP(self, buff, arg1, arg2, over)

    self.ATK_BM = self.ATK_BM - (arg1 * 5);

end

---- QUEST_ATKUP
--function SCR_BUFF_ENTER_QUEST_ATKUP(self, buff, arg1, arg2, over)
--  self.ATK_BM = self.ATK_BM + (arg1 * 50);
--end
--
--function SCR_BUFF_LEAVE_QUEST_ATKUP(self, buff, arg1, arg2, over)
--
--  self.ATK_BM = self.ATK_BM - (arg1 * 50);
--
--end
--
--
---- QUEST_DEFUP
--function SCR_BUFF_ENTER_QUEST_DEFUP(self, buff, arg1, arg2, over)
--
--  self.DEF_BM = self.DEF_BM + (arg1 * 50);
--
--end
--
--function SCR_BUFF_LEAVE_QUEST_DEFUP(self, buff, arg1, arg2, over)
--
--  self.DEF_BM = self.DEF_BM - (arg1 * 50);
--
--end




-- ZACHA4F_MQ_05
function SCR_BUFF_ENTER_ZACHA4F_MQ_05(self, buff, arg1, arg2, over)
    local lv = over;

    local atkadd = self.MAXATK * (0.2 + lv * 0.01);

    self.ATK_BM = self.ATK_BM + atkadd;

    SetExProp(buff, "ADD_MINATK", atkadd);

end

function SCR_BUFF_UPDATE_ZACHA4F_MQ_05(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'd_zachariel_35' then
        return 1;
    else
        return 0;
    end

end

function SCR_BUFF_LEAVE_ZACHA4F_MQ_05(self, buff, arg1, arg2, over)

    local atkadd = GetExProp(buff, "ADD_MINATK");

    self.ATK_BM = self.ATK_BM - atkadd;

end








-- ZACHA1F_SQ_03
function SCR_BUFF_ENTER_ZACHA1F_SQ_03(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_ZACHA1F_SQ_03(self, buff, arg1, arg2, RemainTime, ret, over)
    local result_04 = SCR_QUEST_CHECK(self,'ZACHA1F_SQ_04')
    local result_05 = SCR_QUEST_CHECK(self,'ZACHA1F_SQ_05')
    if result_04 == 'PROGRESS' or result_05 == 'PROGRESS' then
        if GetZoneName(self) == 'd_zachariel_32' then
            return 1;
        end
    else
        return 0;
    end

end

function SCR_BUFF_LEAVE_ZACHA1F_SQ_03(self, buff, arg1, arg2, over)
end




-- ZACHA4F_SQ_01
function SCR_BUFF_ENTER_ZACHA4F_SQ_01(self, buff, arg1, arg2, over)
--    local jobclass = M_CHAPEL_JOB_SELECT(self)
--    local add = 10
--    if jobclass == 'Warrior' or jobclass == 'Archer' then
--      self.STR_BM = self.STR_BM + add
--    elseif jobclass == 'Wizard' or jobclass == 'Cleric' then
--        self.INT_BM = self.INT_BM + add
--    end
--  SetExProp(buff, "ZACHA4F_SQ_01", add)
--  InvalidateStates(self)

    self.PATK_BM = self.PATK_BM + 10;
    self.MATK_BM = self.MATK_BM + 10;
end

function SCR_BUFF_UPDATE_ZACHA4F_SQ_01(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'd_zachariel_35' then
        AttachEffect(self, 'I_cleric_skl_Ironskin_mash', 1, "BOT");
        return 1;
    else
        return 0;
    end
end

function SCR_BUFF_LEAVE_ZACHA4F_SQ_01(self, buff, arg1, arg2, over)
--  local add = GetExProp(buff, "ZACHA4F_SQ_01")
--    local jobclass = M_CHAPEL_JOB_SELECT(self)
--    if jobclass == 'Warrior' or jobclass == 'Archer' then
--      self.STR_BM = self.STR_BM - add
--    elseif jobclass == 'Wizard' or jobclass == 'Cleric' then
--        self.INT_BM = self.INT_BM - add
--    end
--  InvalidateStates(self)
    self.PATK_BM = self.PATK_BM - 10;
    self.MATK_BM = self.MATK_BM - 10;
end





-- SIAU15_R_MQ
function SCR_BUFF_ENTER_SIAU15_R_MQ(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_SIAU15_R_MQ(self, buff, arg1, arg2, RemainTime, ret, over)
    if self.HP < self.MHP then
        AddHP(self, self.MHP);
    end
    return 1;
end

function SCR_BUFF_LEAVE_SIAU15_R_MQ(self, buff, arg1, arg2, over)

end


-- SIAU15_R_MQ_PC
function SCR_BUFF_ENTER_SIAU15_R_MQ_PC(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_SIAU15_R_MQ_PC(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'f_siauliai_15_re' then
        return 1;
    end
    return 0;
end

function SCR_BUFF_LEAVE_SIAU15_R_MQ_PC(self, buff, arg1, arg2, over)

end



-- CHAPLE576_MQ_07_01

function SCR_BUFF_ENTER_CHAPLE576_MQ_07_01(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_CHAPLE576_MQ_07_01(self, buff, arg1, arg2, RemainTime, ret, over)

    if GetZoneName(self) == 'd_chapel_57_6' then
        if IsDead(self) == 0 then
            self.StrArg1 = 'd_chapel_57_6'
            AttachEffect(self, 'F_light048_blue', 1.5, "MID", 0);
            if RemainTime < 1000 then
                self.StrArg1 = 'None'
            else
                return 1;
            end
        end
    end
    DetachEffect(self, 'F_light048_blue');
    return 0;
end
 
function SCR_BUFF_LEAVE_CHAPLE576_MQ_07_01(self, buff, arg1, arg2, over)
--    self.StrArg1 = 'None'
end




-- CHAPLE577_MQ_06_01

function SCR_BUFF_ENTER_CHAPLE577_MQ_06_01(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_cleric_oobe_loop_follow', 2.5, "BOT", 0);
    ObjectColorBlend(self, 255.0, 255.0, 255.0, 105.0, 1, 1)
end

function SCR_BUFF_UPDATE_CHAPLE577_MQ_06_01(self, buff, arg1, arg2, RemainTime, ret, over)

    if GetZoneName(self) == 'd_chapel_57_7' then
        if IsDead(self) == 0 then
            if IsSafe(self) == 'NO' then
                SetSafe(self, 1)
                AttachEffect(self, 'I_cleric_oobe_loop_follow', 2.5, "BOT", 0);
                return 1;
            else 
                return 1;
            end
        end
    end
        DetachEffect(self, 'I_cleric_oobe_loop_follow');
        ObjectColorBlend(self, 255.0, 255.0, 255.0, 255.0, 1, 1)
    return 0;
end

function SCR_BUFF_LEAVE_CHAPLE577_MQ_06_01(self, buff, arg1, arg2, over)
    SetSafe(self, 0)
    DetachEffect(self, 'I_cleric_oobe_loop_follow');
    ObjectColorBlend(self, 255.0, 255.0, 255.0, 255.0, 1, 1)
end



-- FTOWER44_MQ_01
function SCR_BUFF_ENTER_FTOWER44_MQ_01(self, buff, arg1, arg2, over)
    self.ATK_BM = self.ATK_BM + arg1;
end

function SCR_BUFF_UPDATE_FTOWER44_MQ_01(self, buff, arg1, arg2, RemainTime, ret, over)
    local result = SCR_QUEST_CHECK(self, "FTOWER44_MQ_01")
    if GetZoneName(self) == 'd_firetower_44' then
        if result == "PROGRESS" then
            return 1;
        end
    else
        return 0;
    end

end

function SCR_BUFF_LEAVE_FTOWER44_MQ_01(self, buff, arg1, arg2, over)
    self.ATK_BM = self.ATK_BM - arg1;
end



--THORN21_MQ07_THORNDRUG
function SCR_BUFF_ENTER_THORN21_MQ07_THORNDRUG(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_THORN21_MQ07_THORNDRUG(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'd_thorn_21' then
        if IsDead(self) == 0 then
            local buff_Result = GetBuffByName(self, 'Rage_Rockto_spd_down')
            if buff_Result == nil then
                return 1;
            elseif buff_Result.ClassName == "Rage_Rockto_spd_down" then
                RemoveBuff(self, "Rage_Rockto_spd_down")
                return 1;
            end
        end
    end
    DetachEffect(self, 'I_sphere007_mash');
    return 0;
end
 
function SCR_BUFF_LEAVE_THORN21_MQ07_THORNDRUG(self, buff, arg1, arg2, over)
    DetachEffect(self, 'I_sphere007_mash');
end


--ZACHA2F_MQ04_MONSTER
function SCR_BUFF_ENTER_ZACHA2F_MQ04_MONSTER(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_ZACHA2F_MQ04_MONSTER(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'd_zachariel_33' then
        PlayEffect(self, 'F_smoke072_sviolet', 0.3, 1, "BOT");
        if self.ClassName == "Karas" then
            SetCurrentFaction(self, "Monster_Chaos1")
        elseif self.ClassName == "zinutekas" then
            SetCurrentFaction(self, "Monster_Chaos2")
        end
        return 1;
    end
    DetachEffect(self, 'F_smoke072_sviolet');
    return 0;
end
 
function SCR_BUFF_LEAVE_ZACHA2F_MQ04_MONSTER(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_smoke072_sviolet');
end





-- GELE574_MQ_04_BOSS
function SCR_BUFF_ENTER_GELE574_MQ_04_BOSS(self, buff, arg1, arg2, over)

    SetCurrentFaction(self, 'Monster')
end

function SCR_BUFF_UPDATE_GELE574_MQ_04_BOSS(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'f_gele_57_4' then
        if GetLayer(self) ~= 0 then
            if self.HP < self.MHP then
                local heal = self.MHP / 20
                Heal(self, heal, 0);
                return 1;
            else
                return 0;
            end
        end
    end
    return 0;
end

function SCR_BUFF_LEAVE_GELE574_MQ_04_BOSS(self, buff, arg1, arg2, over)
--    self.ATK_BM = self.ATK_BM - arg1;
end







-- JOB_WUGU4_1
function SCR_BUFF_ENTER_JOB_WUGU4_1(self, buff, arg1, arg2, over)
    local lv = arg1;

    local mspdadd = self.MSPD * (0.85 + lv * 0.02);
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
    
    SetEmoticon(self, 'I_emo_poison')
    
end

function SCR_BUFF_LEAVE_JOB_WUGU4_1(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;

    SetEmoticon(self, 'None')

end




-- JOB_SCOUT4_1
function SCR_BUFF_ENTER_JOB_SCOUT4_1(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_JOB_SCOUT4_1(self, buff, arg1, arg2, over)
    RunScript('JOB_SCOUT4_1_DEAD', self)

end

function JOB_SCOUT4_1_DEAD(self)
    if IsDead(self) == 0 then
        ObjectColorBlend(self, 255, 255, 255, 50, 1, 0.5)
        PlayEffect(self, 'F_burstup007_smoke1', 0.3)
        sleep(500)
        if IsDead(self) == 0 then
            Kill(self)
        end
    end
end



-- JOB_ROGUE4_1
function SCR_BUFF_ENTER_JOB_ROGUE4_1(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_smoke002_bluegreen', 1, 'TOP')
end

function SCR_BUFF_UPDATE_JOB_ROGUE4_1(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, 'F_smoke002_bluegreen', 1, 'TOP')
    RandomMove(self, 30)
    return 1;
end

function SCR_BUFF_LEAVE_JOB_ROGUE4_1(self, buff, arg1, arg2, over)

end


-- JOB_SQUIRE4_1
function SCR_BUFF_ENTER_JOB_SQUIRE4_1(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_JOB_SQUIRE4_1(self, buff, arg1, arg2, over)

end




-- M_GELE_START
function SCR_BUFF_ENTER_M_GELE_START(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_M_GELE_START(self, buff, arg1, arg2, over)

end




-- M_GELE_MAGI
function SCR_BUFF_ENTER_M_GELE_MAGI(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_M_GELE_MAGI(self, buff, arg1, arg2, over)

end





-- REQ_SEMPLE_04
function SCR_BUFF_ENTER_REQ_SEMPLE_04(self, buff, arg1, arg2, over)

    self.PATK_BM = self.PATK_BM + 150
    self.MATK_BM = self.MATK_BM + 150;
    self.HR_BM = self.HR_BM + 150;
    
end

function SCR_BUFF_LEAVE_REQ_SEMPLE_04(self, buff, arg1, arg2, over)

    self.PATK_BM = self.PATK_BM - 150;
    self.MATK_BM = self.MATK_BM - 150;
    self.HR_BM = self.HR_BM - 150;

end



-- REQ_SEMPLE_05
function SCR_BUFF_ENTER_REQ_SEMPLE_05(self, buff, arg1, arg2, over)

    self.DEF_BM = self.DEF_BM + 100;
    
end

function SCR_BUFF_LEAVE_REQ_SEMPLE_05(self, buff, arg1, arg2, over)

    self.DEF_BM = self.DEF_BM - 100;

end





-- JOB_ROGUE4_1_BUFF
function SCR_BUFF_ENTER_JOB_ROGUE4_1_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_JOB_ROGUE4_1_BUFF(self, buff, arg1, arg2, over)
end





-- JOB_ROGUE4_1_DEBUFF
function SCR_BUFF_ENTER_JOB_ROGUE4_1_DEBUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'E_buff_Stun', 3, 'TOP')
end

function SCR_BUFF_UPDATE_JOB_ROGUE4_1_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    RandomMove(self, 30)
--    ResetHated(self)
    return 1;
end

function SCR_BUFF_LEAVE_JOB_ROGUE4_1_DEBUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'E_buff_Stun');


end



--CHAPLE577_MQ_08
function SCR_BUFF_ENTER_CHAPLE577_MQ_08(self, buff, arg1, arg2, over)
    PlaySound(self, 'chapel_bell_sound_01')
    SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("CHAPLE577_MQ_08"), 3);
end

function SCR_BUFF_LEAVE_CHAPLE577_MQ_08(self, buff, arg1, arg2, over)

end




--GELE573_MQ_04
function SCR_BUFF_ENTER_GELE573_MQ_04(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Neutral')
    ClearBTree(self)
    self.NumArg1 = 1
end

function SCR_BUFF_LEAVE_GELE573_MQ_04(self, buff, arg1, arg2, over)
    local tobt = CreateBTree('BasicMonster')
    SetBTree(self, tobt)
    SetCurrentFaction(self, 'Monster')
    self.NumArg1 = 0
end




--GELE573_MQ_04_HOLY
function SCR_BUFF_ENTER_GELE573_MQ_04_HOLY(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_bg_pattern004')
    DetachEffect(self, 'F_smoke130_blue_loop2')
end

function SCR_BUFF_LEAVE_GELE573_MQ_04_HOLY(self, buff, arg1, arg2, over)
    PlayAnim(self,'ON', 1)
end


--THORN20_MQ_DEBUFF
function SCR_BUFF_ENTER_THORN20_MQ_DEBUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'E_buff_Stun', 2, 'TOP')
    PlayAnim(self, "STUN", 1)
end

function SCR_BUFF_LEAVE_THORN20_MQ_DEBUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'E_buff_Stun');
    PlayAnim(self, "ASTD", 1)
end





--CHAPLE575_MQ_06
function SCR_BUFF_ENTER_CHAPLE575_MQ_06(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Peaceful')
    AttachEffect(self, 'I_smoke038_blue', 1)
    ObjectColorBlend(self, 100, 100, 255, 180, 1, 3)
end

function SCR_BUFF_LEAVE_CHAPLE575_MQ_06(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Law')
    DetachEffect(self, 'I_smoke038_blue')
    ObjectColorBlend(self, 255, 255, 255, 255, 1, 1)
end



--CHAPLE575_MQ_06_BOMB
function SCR_BUFF_ENTER_CHAPLE575_MQ_06_BOMB(self, buff, arg1, arg2, over)
    AddBuff(self, self, 'COMMON_BUFF_DEAD', 1, 0, 6560, 1)
end

function SCR_BUFF_LEAVE_CHAPLE575_MQ_06_BOMB(self, buff, arg1, arg2, over)
    local list, cnt = SelectObjectByFaction(self, 120, 'Monster')
    local i
    local angle = {}
    if cnt ~= 0 then
        for i = 1, cnt do
            angle[i] = GetAngleTo(list[i], self);
            KnockDown(list[i], self, 100, angle[i]*2, 45, 0, 2, 3)
        end
    end
    PlayEffect(self, 'F_light016', 2)
    Dead(self)
end


--COMMON_BUFF_DEAD
function SCR_BUFF_ENTER_COMMON_BUFF_DEAD(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_COMMON_BUFF_DEAD(self, buff, arg1, arg2, over)
    Dead(self)
end



--CHAPLE575_MQ_07
function SCR_BUFF_ENTER_CHAPLE575_MQ_07(self, buff, arg1, arg2, over)
    SetExProp(buff, "CHAPLE575_MQ_07", self.MSPD);
    
end

function SCR_BUFF_UPDATE_CHAPLE575_MQ_07(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, cnt = SelectObjectByClassName(self, 100, 'Altarcrystal_N1')
    local i
    if cnt ~= 0 then
         
        if self.MSPD > 0 then
            local pc_mon = GetScpObjectList(self, 'CHAPLE575_MQ_07')
            if #pc_mon ~= 0 then
                if IsBuffApplied(self, 'CHAPLE575_MQ_07_01') == 'NO' then
--                    PlayEffect(self, 'F_smoke136', 1, 1, 'MID')
                    SCR_PARTY_QUESTPROP_ADD(pc_mon[1], 'SSN_CHAPLE575_MQ_07', 'QuestInfoValue1', 10)
                end
            end
            self.MSPD = self.MSPD - 2.5
            return 1;
        else
            if IsBuffApplied(self, 'CHAPLE575_MQ_07_01') == 'NO' then
                AttachEffect(self, 'F_ground017_loop', 1, 'BOT')
                AddBuff(self, self, 'CHAPLE575_MQ_07_01', 1, 0, 0, 1)
                RemoveBuff(self, 'CHAPLE575_MQ_07')
            end
        end
    else
        DetachEffect(self, 'F_ground017_loop')
        RemoveBuff(self, 'CHAPLE575_MQ_07')
    end
end

function SCR_BUFF_LEAVE_CHAPLE575_MQ_07(self, buff, arg1, arg2, over)
    self.MSPD = GetExProp(buff, "CHAPLE575_MQ_07")
end




--CHAPLE575_MQ_07_01
function SCR_BUFF_ENTER_CHAPLE575_MQ_07_01(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_CHAPLE575_MQ_07_01(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, cnt = SelectObjectByClassName(self, 100, 'Altarcrystal_N1')
    local i
    if cnt ~= 0 then
        return 1;
    else
        RemoveBuff(self, 'CHAPLE575_MQ_07_01')
    end
end

function SCR_BUFF_LEAVE_CHAPLE575_MQ_07_01(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_ground017_loop')
end




--HUEVILLAGE_58_2_SQ02_BUFF
function SCR_BUFF_ENTER_HUEVILLAGE_58_2_SQ02_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_smoke009_green', 1.0)
end

function SCR_BUFF_UPDATE_HUEVILLAGE_58_2_SQ02_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local fndList, fndCount = SelectObject(self, 180, 'ALL');
    local i
    
    for i = 1, fndCount do
        if fndList[i].ClassName == 'PC' then
            local result = SCR_QUEST_CHECK(fndList[i],'HUEVILLAGE_58_2_SQ02')
            if result == 'PROGRESS' then
                InsertHate(self, fndList[i], 1)
            end
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_HUEVILLAGE_58_2_SQ02_BUFF(self, buff, arg1, arg2, over)
    ClearEffect(self)
end



--CHAPLE577_HOLY_2
function SCR_BUFF_ENTER_CHAPLE577_HOLY_2(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_cleric_oobe_loop_levitation1', 1, 1, 'MID', 0)
end

function SCR_BUFF_LEAVE_CHAPLE577_HOLY_2(self, buff, arg1, arg2, over)
    DetachEffect(self, 'I_cleric_oobe_loop_levitation1')
end




-- CHAPLE576_MQ_08
function SCR_BUFF_ENTER_CHAPLE576_MQ_08(self, buff, arg1, arg2, over)
--  local curHpPercent = GetHpPercent(self) * 100;
--  SetExProp(buff, 'CUR_HP_PERCENT', curHpPercent);
end

function SCR_BUFF_LEAVE_CHAPLE576_MQ_08(self, buff, arg1, arg2, over)
    
end


--CHAPLE576_MQ_06
function SCR_BUFF_ENTER_CHAPLE576_MQ_06(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_CHAPLE576_MQ_06(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetLayer(self) ~= 0 then
        return 0
    end
    local result = SCR_QUEST_CHECK(self, 'CHAPLE576_MQ_06')
    if result ~= 'PROGRESS' then
        return 0
    end
    if GetZoneName(self) ~= 'd_chapel_57_6' then
        return 0
    end

    
    return 1;
end

function SCR_BUFF_LEAVE_CHAPLE576_MQ_06(self, buff, arg1, arg2, over)

end


--CHAPLE576_MQ_06_1
function SCR_BUFF_ENTER_CHAPLE576_MQ_06_1(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Peaceful')
end

function SCR_BUFF_UPDATE_CHAPLE576_MQ_06_1(self, buff, arg1, arg2, RemainTime, ret, over)
    AddStamina(self, 99999);
    if GetLayer(self) ~= 0 then
        return 0
    end
    local result = SCR_QUEST_CHECK(self, 'CHAPLE576_MQ_06')
    if result ~= 'PROGRESS' then
        return 0
    end
    if GetZoneName(self) ~= 'd_chapel_57_6' then
        return 0
    end
   
    return 1;
end

function SCR_BUFF_LEAVE_CHAPLE576_MQ_06_1(self, buff, arg1, arg2, over)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAPLE577_MQ_06_1_BUFFEND_MSG"), 10);
    PlayAnim(self, 'ASTD', 1)
    SetCurrentFaction(self, 'Law')
    TransformToMonster(self, "None", "None");
    ClearScpObjectList(self, 'CHAPLE576_MQ_06')
end



--HUEVILLAGE_58_3_MQ04_BUFF
function SCR_BUFF_ENTER_HUEVILLAGE_58_3_MQ04_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_archer_scarecrow_loop_ground', 1.0)
    
    local mspdadd = self.MSPD * 0.40
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    SetExProp(buff, "ADD_MSPD", mspdadd);
end

function SCR_BUFF_LEAVE_HUEVILLAGE_58_3_MQ04_BUFF(self, buff, arg1, arg2, over)
    ClearEffect(self)
    
    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM + mspdadd;
end






--REMAIN37_MQ05
function SCR_BUFF_ENTER_REMAIN37_MQ05(self, buff, arg1, arg2, over)
    self.WlkMSPD = 65
    AttachEffect(self, 'F_fire027_2', 0.6, 1, "MID", 1)
    ObjectColorBlend(self, 255, 100, 100, 255, 1, 1)
end

function SCR_BUFF_UPDATE_REMAIN37_MQ05(self, buff, arg1, arg2, RemainTime, ret, over)
    local _pc = GetTopHatePointChar(self)
    if _pc == nil then
        RandomMove(self, 50)
        return 1;
    end
    return 1;
end

function SCR_BUFF_LEAVE_REMAIN37_MQ05(self, buff, arg1, arg2, over)

end




--REMAIN37_SQ03_ITEM_02
function SCR_BUFF_ENTER_REMAIN37_SQ03_ITEM_02(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_REMAIN37_SQ03_ITEM_02(self, buff, arg1, arg2, RemainTime, ret, over)
    local _pc = GetTopHatePointChar(self)
    if _pc == nil then
        return 0
    end
    AddBuff(self, self, 'REMAIN37_SQ03_ITEM_02', 1, 0, 10000, 1)
    return 1;
end

function SCR_BUFF_LEAVE_REMAIN37_SQ03_ITEM_02(self, buff, arg1, arg2, over)

end






--REMAIN38_SQ03
function SCR_BUFF_ENTER_REMAIN38_SQ03(self, buff, arg1, arg2, over)
    AddBuff(self, self, 'HPLock', 10, 0, 60000, 1)
    AttachEffect(self, 'F_fire027_2', 0.6, 1, "MID", 1)
end

function SCR_BUFF_LEAVE_REMAIN38_SQ03(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_fire027_2')
    RemoveBuff(self, 'HPLock')
end



--REMAIN38_SQ04
function SCR_BUFF_ENTER_REMAIN38_SQ04(self, buff, arg1, arg2, over)
    AddBuff(self, self, 'HPLock', 10, 0, 60000, 1)
    AttachEffect(self, 'F_fire027_2', 0.6, 1, "MID", 1)
end

function SCR_BUFF_LEAVE_REMAIN38_SQ04(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_fire027_2')
    RemoveBuff(self, 'HPLock')
end



--REMAIN38_MQ03
function SCR_BUFF_ENTER_REMAIN38_MQ03(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_fire027_2', 1.5, 1, "MID", 1)
    ObjectColorBlend(self, 255, 100, 100, 255, 1, 1)
end

function SCR_BUFF_LEAVE_REMAIN38_MQ03(self, buff, arg1, arg2, over)
    Dead(self)
end



--FLASH59_SQ_12
function SCR_BUFF_ENTER_FLASH59_SQ_12(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_ground001_yellow_loop', 1.5, 1, "MID", 1)
end

function SCR_BUFF_LEAVE_FLASH59_SQ_12(self, buff, arg1, arg2, over)

end



--SIAULIAI_46_4_MQ_02_BUFF
function SCR_BUFF_ENTER_SIAULIAI_46_4_MQ_02_BUFF(self, buff, arg1, arg2, over)
    SetEmoticon(self, 'I_emo_honey')
--    AttachEffect(self, 'F_smoke092_orange', 8.0)
end

function SCR_BUFF_LEAVE_SIAULIAI_46_4_MQ_02_BUFF(self, buff, arg1, arg2, over)
    SetEmoticon(self, 'None')
--    ClearEffect(self)
end



--SIAULIAI_46_3_MQ_01_BUFF
function SCR_BUFF_ENTER_SIAULIAI_46_3_MQ_01_BUFF(self, buff, arg1, arg2, over)
    SetEmoticon(self, 'I_emo_smell')
end

function SCR_BUFF_LEAVE_SIAULIAI_46_3_MQ_01_BUFF(self, buff, arg1, arg2, over)
    SetEmoticon(self, 'None')
end

--CHATHEDRAL56_MQ07_DEBUFF
function SCR_BUFF_ENTER_CHATHEDRAL56_MQ07_DEBUFF(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 100, 120, 255, 180, 1)
end

function SCR_BUFF_UPDATE_CHATHEDRAL56_MQ07_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    local dam = math.floor(self.MHP / 100)
    TakeDamage(caster, self, "None", dam, "Melee", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW);
    return 1;
end

function SCR_BUFF_LEAVE_CHATHEDRAL56_MQ07_DEBUFF(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255, 255, 255, 255, 1)
end

--GIVEDAMAGE_DEBUFF
function SCR_BUFF_ENTER_GIVEDAMAGE_DEBUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_GIVEDAMAGE_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    local dam = math.floor(self.MHP / 10)
    TakeDamage(caster, self, "None", dam, "Melee", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW);
    return 1;
end

function SCR_BUFF_LEAVE_GIVEDAMAGE_DEBUFF(self, buff, arg1, arg2, over)
end

--MINE_1_CRYSTAL_2_BUFF
function SCR_BUFF_ENTER_MINE_1_CRYSTAL_2_BUFF(self, buff, arg1, arg2, over)
    SetEmoticon(self, 'I_quest_question_mark')
end

function SCR_BUFF_LEAVE_MINE_1_CRYSTAL_2_BUFF(self, buff, arg1, arg2, over)
    SetEmoticon(self, 'None')
end



--CATACOMB_01_PCSTACK_BUFF
function SCR_BUFF_ENTER_CATACOMB_01_PCSTACK_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_CATACOMB_01_PCSTACK_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'id_catacomb_01' then
        return 1;
    else
        return 0;
    end
end

function SCR_BUFF_LEAVE_CATACOMB_01_PCSTACK_BUFF(self, buff, arg1, arg2, over)
end



--CATACOMB_01_SPIRIT_01_BUFF
function SCR_BUFF_ENTER_CATACOMB_01_SPIRIT_01_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_CATACOMB_01_SPIRIT_01_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'id_catacomb_01' then
        return 1;
    else
        return 0;
    end
end

function SCR_BUFF_LEAVE_CATACOMB_01_SPIRIT_01_BUFF(self, buff, arg1, arg2, over)
end



--CATACOMB_01_SPIRIT_02_BUFF
function SCR_BUFF_ENTER_CATACOMB_01_SPIRIT_02_BUFF(self, buff, arg1, arg2, over)
    UnHideNPC(self, "CATACOMB_01_SPIRIT_03")
end

function SCR_BUFF_UPDATE_CATACOMB_01_SPIRIT_02_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'id_catacomb_01' then
        return 1;
    else
        return 0;
    end
end

function SCR_BUFF_LEAVE_CATACOMB_01_SPIRIT_02_BUFF(self, buff, arg1, arg2, over)
    HideNPC(self, "CATACOMB_01_SPIRIT_03")
end



--CATACOMB_01_EVILAURA_01_BUFF
function SCR_BUFF_ENTER_CATACOMB_01_EVILAURA_01_BUFF(self, buff, arg1, arg2, over)
    local defadd = math.floor(self.DEF * (over * 0.1));
    local mdefadd = math.floor(self.MDEF * (over * 0.1));
    
    self.DEF_BM = self.DEF_BM - defadd;
    self.MDEF_BM = self.MDEF_BM - mdefadd;
    
    SetExProp(buff, "ADD_DEF", defadd);
    SetExProp(buff, "ADD_MDEF", mdefadd);
end

function SCR_BUFF_LEAVE_CATACOMB_01_EVILAURA_01_BUFF(self, buff, arg1, arg2, over)
    local defadd = GetExProp(buff, "ADD_DEF");
    local mdefadd = GetExProp(buff, "ADD_MDEF");
    
    self.DEF_BM = self.DEF_BM + defadd;
    self.MDEF_BM = self.MDEF_BM + mdefadd;
end



--STARTOWER_60_1_REGRAVITY_BUFF
function SCR_BUFF_ENTER_STARTOWER_60_1_REGRAVITY_BUFF(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_STARTOWER_60_1_REGRAVITY_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'd_startower_60_1' then
        local list, cnt = SelectObject(self, 200, 'ALL', 1)
        local i
        for i = 1, cnt do
            if cnt >= 1 then
                if list[i].ClassName ~= 'PC' then
                    if list[i].Faction == 'Neutral' then
                        if list[i].Dialog == 'STARTOWER_60_1_DAILY_BOX' then
                            PlayEffectLocal(list[i], self, 'F_buff_basic011_green', 1.5, nil, 'BOT')
                        end
                    end
                end
            end
        end
        return 1;
    else
        return 0;
    end
end

function SCR_BUFF_LEAVE_STARTOWER_60_1_REGRAVITY_BUFF(self, buff, arg1, arg2, over)

end



--STARTOWER_60_1_AI_02_TIME_BUFF
function SCR_BUFF_ENTER_STARTOWER_60_1_AI_02_TIME_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_STARTOWER_60_1_AI_02_TIME_BUFF(self, buff, arg1, arg2, over)
    local my_Owner = GetOwner(self);
    if my_Owner ~= nil then
        SendAddOnMsg(my_Owner, "NOTICE_Dm_!", ScpArgMsg("STARTOWER_60_1_AI_02_TIME_BUFF_MSG1"), 5);
    end
end

--CATACOMB_38_2_SQ_05_BUFF
function SCR_BUFF_ENTER_CATACOMB_38_2_SQ_05_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_CATACOMB_38_2_SQ_05_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local hover = GetScpObjectList(self, 'CATACOMB_38_2_SQ_05_SCP_MON')
    if #hover ~= 0 then
        return 1;
    else
        return 0;
    end
end

function SCR_BUFF_LEAVE_CATACOMB_38_2_SQ_05_BUFF(self, buff, arg1, arg2, over)
    local hover = GetScpObjectList(self, 'CATACOMB_38_2_SQ_05_SCP_MON')
    if #hover ~= 0 then
        local i
--        local PC_Owner
        for i = 1, #hover do
            --PC_Owner = GetOwner(hover[i])
            local PC_Owner = GetScpObjectList(hover[i], 'CATACOMB_38_2_SQ_05_SCP_OWNER')
            if PC_Owner[1] ~= nil then
                AddScpObjectList(PC_Owner[1], 'CATACOMB_38_2_SQ_05_SCP_PC', self)
                HoverAround(hover[i], PC_Owner[1], 15, 1, 1.0, 1);
                SetNoDamage(hover[i], 1);
            end
            hover[i].NumArg1 = 0;
            ClearScpObjectList(self, 'CATACOMB_38_2_SQ_05_SCP_MON')
        end
    end
end



--CATACOMB_38_2_SQ_06_BUFF
function SCR_BUFF_ENTER_CATACOMB_38_2_SQ_06_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_CATACOMB_38_2_SQ_06_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, Cnt = SelectObject(self, 100, 'ALL');
    local i
    
    for i = 1, Cnt do
        if list[i].ClassName ~= 'PC' then
            if list[i].Enter == 'CATACOMB_38_2_SQ_06_TRUTHEYES' then
                SetNoDamage(self, 0)
                ObjectColorBlend(self, 255, 255, 255, 255, 1, 1)
                return 1;
            end
        end
    end
    
    SetNoDamage(self, 1)
    ObjectColorBlend(self, 10.0, 130.0, 255.0, 180.0, 1)
    return 1;
end

function SCR_BUFF_LEAVE_CATACOMB_38_2_SQ_06_BUFF(self, buff, arg1, arg2, over)

end



--CATACOMB_38_2_SQ_05_NO_BUFF
function SCR_BUFF_ENTER_CATACOMB_38_2_SQ_05_NO_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_CATACOMB_38_2_SQ_05_NO_BUFF(self, buff, arg1, arg2, over)
    self.NumArg2 = 0;
end



--CATACOMB_02_SQ_07_BUFF
function SCR_BUFF_ENTER_CATACOMB_02_SQ_07_BUFF(self, buff, arg1, arg2, over)
    local patkadd = math.floor(self.MINPATK * 0.5);
    local matkadd = math.floor(self.MINMATK * 0.5);
    local defadd = math.floor(self.DEF * 0.5);
    local mdefadd = math.floor(self.MDEF * 0.5);
    
    self.PATK_BM = self.PATK_BM - patkadd;
    self.MATK_BM = self.MATK_BM - matkadd;
    self.DEF_BM = self.DEF_BM - defadd;
    self.MDEF_BM = self.MDEF_BM - mdefadd;
    
    SetExProp(buff, "ADD_PATK", patkadd);
    SetExProp(buff, "ADD_MATK", matkadd);
    SetExProp(buff, "ADD_DEF", defadd);
    SetExProp(buff, "ADD_MDEF", mdefadd);
    
    AttachEffect(self, 'F_circle002', 5.0, "MID")
end

function SCR_BUFF_LEAVE_CATACOMB_02_SQ_07_BUFF(self, buff, arg1, arg2, over)
    local patkadd = GetExProp(buff, "ADD_PATK");
    local matkadd = GetExProp(buff, "ADD_MATK");
    local defadd = GetExProp(buff, "ADD_DEF");
    local mdefadd = GetExProp(buff, "ADD_MDEF");
    
    self.PATK_BM = self.PATK_BM + patkadd;
    self.MATK_BM = self.MATK_BM + matkadd;
    self.DEF_BM = self.DEF_BM + defadd;
    self.MDEF_BM = self.MDEF_BM + mdefadd;
    
    ClearEffect(self)
end



--STARTOWER_60_1_CANDLESTICK_BUFF
function SCR_BUFF_ENTER_STARTOWER_60_1_CANDLESTICK_BUFF(self, buff, arg1, arg2, over)
    local defadd = math.floor(self.DEF * 0.5);
    local mdefadd = math.floor(self.MDEF * 0.5);
    
    self.DEF_BM = self.DEF_BM - defadd;
    self.MDEF_BM = self.MDEF_BM - mdefadd;
    
    SetExProp(buff, "ADD_DEF", defadd);
    SetExProp(buff, "ADD_MDEF", mdefadd);
end

function SCR_BUFF_LEAVE_STARTOWER_60_1_CANDLESTICK_BUFF(self, buff, arg1, arg2, over)
    local defadd = GetExProp(buff, "ADD_DEF");
    local mdefadd = GetExProp(buff, "ADD_MDEF");
    
    self.DEF_BM = self.DEF_BM + defadd;
    self.MDEF_BM = self.MDEF_BM + mdefadd;
end



--JOB_ROGUE_6_1_BUFF
function SCR_BUFF_ENTER_JOB_ROGUE_6_1_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_JOB_ROGUE_6_1_BUFF(self, buff, arg1, arg2, over)
end



--Stun_Quest
function SCR_BUFF_ENTER_Stun_Quest(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_stun', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_LEAVE_Stun_Quest(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_stun')
end



--KATYN_10_MQ_05_BUFF
function SCR_BUFF_ENTER_KATYN_10_MQ_05_BUFF(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_KATYN_10_MQ_05_BUFF(self, buff, arg1, arg2, over)
    if self.NumArg1 == 1 then
        self.NumArg1 = 0;
        ClearEffect(self)
    end
end



--KATYN_10_MQ_06_BUFF
function SCR_BUFF_ENTER_KATYN_10_MQ_06_BUFF(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_KATYN_10_MQ_06_BUFF(self, buff, arg1, arg2, over)

end



--KATYN_12_MQ_07_BUFF
function SCR_BUFF_ENTER_KATYN_12_MQ_07_BUFF(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_KATYN_12_MQ_07_BUFF(self, buff, arg1, arg2, over)

end



--JOB_2_CRYOMANCER_3_1_BUFF
function SCR_BUFF_ENTER_JOB_2_CRYOMANCER_3_1_BUFF(self, buff, arg1, arg2, over)
    local resiceadd = 30;
    self.Ice_Def_BM = self.Ice_Def_BM + resiceadd;
    SetExProp(buff, "ADD_ICE", resiceadd);
    AttachEffect(self, 'F_light055_blue', 2.5, 'BOT')
end

function SCR_BUFF_LEAVE_JOB_2_CRYOMANCER_3_1_BUFF(self, buff, arg1, arg2, over)
    local resiceadd = GetExProp(buff, "ADD_ICE");
    self.Ice_Def_BM = self.Ice_Def_BM - resiceadd
    ClearEffect(self)
end



--JOB_2_PSYCHOKINO_3_1_BUFF
function SCR_BUFF_ENTER_JOB_2_PSYCHOKINO_3_1_BUFF(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_JOB_2_PSYCHOKINO_3_1_BUFF(self, buff, arg1, arg2, over)

end



--JOB_2_WUGUSHI_4_1_BUFF
function SCR_BUFF_ENTER_JOB_2_WUGUSHI_4_1_BUFF(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_JOB_2_WUGUSHI_4_1_BUFF(self, buff, arg1, arg2, over)

end



--JOB_WARLOCK_7_1_BUFF
function SCR_BUFF_ENTER_JOB_WARLOCK_7_1_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_spread_in008_dark', 0.7, 'TOP')
end

function SCR_BUFF_LEAVE_JOB_WARLOCK_7_1_BUFF(self, buff, arg1, arg2, over)
    ClearEffect(self)
end



--JOB_FEATHERFOOT_7_1_BUFF
function SCR_BUFF_ENTER_JOB_FEATHERFOOT_7_1_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_smoke019_dark_loop', 0.6, 'BOT')
end

function SCR_BUFF_LEAVE_JOB_FEATHERFOOT_7_1_BUFF(self, buff, arg1, arg2, over)
    ClearEffect(self)
end



--JOB_FENCER_7_1_BUFF
function SCR_BUFF_ENTER_JOB_FENCER_7_1_BUFF(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_JOB_FENCER_7_1_BUFF(self, buff, arg1, arg2, over)
    
end



--ORCHARD_34_1_SQ_4_BUFF_1
function SCR_BUFF_ENTER_ORCHARD_34_1_SQ_4_BUFF_1(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
--    SetCurrentFaction(self, 'Monster')
end

function SCR_BUFF_LEAVE_ORCHARD_34_1_SQ_4_BUFF_1(self, buff, arg1, arg2, over)
--    SetCurrentFaction(self, 'Neutral')
    self.Dialog = 'None'
    KILL_BLEND(self, 2, 1)
--    Kill(self)
end



--RUNECASTER_NPC_3_BUFF
function SCR_BUFF_ENTER_RUNECASTER_NPC_3_BUFF(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_RUNECASTER_NPC_3_BUFF(self, buff, arg1, arg2, over)

end



--PRISON_78_MQ_7_BUFF
function SCR_BUFF_ENTER_PRISON_78_MQ_7_BUFF(self, buff, arg1, arg2, over)
    SetNoDamage(self, 1)
    AttachEffect(self, 'I_sphere008_boss_barrier_mash_loop', 5.5, 'MID')
end

function SCR_BUFF_LEAVE_PRISON_78_MQ_7_BUFF(self, buff, arg1, arg2, over)
    SetNoDamage(self, 0)
    DetachEffect(self, 'I_sphere008_boss_barrier_mash_loop')
end



--PRISON_80_MQ_2_BUFF
function SCR_BUFF_ENTER_PRISON_80_MQ_2_BUFF(self, buff, arg1, arg2, over)
--    if 1 == TransformToMonster(self, 'Socket_mage_red', 'PRISON_80_MQ_2_BUFF') then
--        ObjectColorBlend(self, 100.0, 100.0, 100.0, 100.0, 1)
        AttachEffect(self, 'F_smoke011_blue', 2.0, 'MID')
        SetCurrentFaction(self, 'Peaceful')
--    end
end

function SCR_BUFF_UPDATE_PRISON_80_MQ_2_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    AddStamina(self, 99999);
    
    if GetZoneName(self) == 'd_prison_80' then
        if GetLayer(self) == 0 then
            local result = SCR_QUEST_CHECK(self, 'PRISON_80_MQ_2')
            if result == 'PROGRESS' then
                if GetCurrentFaction(self) == 'Law' then
                    SetCurrentFaction(self, 'Peaceful')
                end
                return 1
            end
        end
    end
    
    return 0;
end

function SCR_BUFF_LEAVE_PRISON_80_MQ_2_BUFF(self, buff, arg1, arg2, over)
--    PlayAnim(self, 'ASTD', 1)
--    ObjectColorBlend(self, 255.0, 255.0, 255.0, 255.0, 1)
    DetachEffect(self, 'F_smoke011_blue')
    SetCurrentFaction(self, 'Law')
--    TransformToMonster(self, "None", "None");
    ClearScpObjectList(self, 'PRISON_80_MQ_2_SCPMON')
    
    local _obj = GetScpObjectList(self, 'PRISON_80_MQ_2_SCPOBJ');
    if #_obj >= 1 then
        local i
        for i = 1, #_obj do
            Kill(_obj[i])
        end
    end
    PlayEffect(self, 'I_smoke058_violet', 2.0, nil, 'BOT')
end



--PRISON_80_MQ_7_BUFF
function SCR_BUFF_ENTER_PRISON_80_MQ_7_BUFF(self, buff, arg1, arg2, over)
    SetNoDamage(self, 1)
    AttachEffect(self, 'I_sphere008_boss_barrier_mash_loop', 5.5, 'MID')
end

function SCR_BUFF_UPDATE_PRISON_80_MQ_7_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    self.NumArg2 = self.NumArg2 + 1;
    
    if self.NumArg1 == 1 then
        if self.NumArg2 >= 15 then
            SetNoDamage(self, 1)
            AttachEffect(self, 'I_sphere008_boss_barrier_mash_loop', 5.5, 'MID')
            self.NumArg1 = 0;
            self.NumArg2 = 0;
            
            local _zoneID = GetZoneInstID(self)
            local list, cnt = GetLayerPCList(_zoneID, GetLayer(self))
            if cnt >= 1 then
                local i
                for i = 1, cnt do
                    if list[i].ClassName == 'PC' then
                        SendAddOnMsg(list[i], "NOTICE_Dm_!", ScpArgMsg("PRISON_80_MQ_7_TRACK_MSG2"), 2);
                    end
                end
            end
        end
    else
        if self.NumArg2 >= 7 then
            SetNoDamage(self, 0)
            DetachEffect(self, 'I_sphere008_boss_barrier_mash_loop')
            self.NumArg1 = 1;
            self.NumArg2 = 0;
            
            local _zoneID = GetZoneInstID(self)
            local list, cnt = GetLayerPCList(_zoneID, GetLayer(self))
            if cnt >= 1 then
                local i
                for i = 1, cnt do
                    if list[i].ClassName == 'PC' then
                        SendAddOnMsg(list[i], "NOTICE_Dm_scroll", ScpArgMsg("PRISON_80_MQ_7_TRACK_MSG3"), 2);
                    end
                end
            end
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_PRISON_80_MQ_7_BUFF(self, buff, arg1, arg2, over)
    SetNoDamage(self, 0)
    DetachEffect(self, 'I_sphere008_boss_barrier_mash_loop')
end



--PRISON_82_MQ_8_BUFF
function SCR_BUFF_ENTER_PRISON_82_MQ_8_BUFF(self, buff, arg1, arg2, over)
    local _effect_list = { { 8.0, 'BOT' }, { 4.0, 'MID' } }
    local _effect = { }
    if self.ClassName == 'Templeslave_sword_blue' or self.ClassName == 'Templeslave_mage_blue' then
        _effect = _effect_list[1];
    else
        _effect = _effect_list[2];
    end
    SetNoDamage(self, 1)
    AttachEffect(self, 'F_circle002', _effect[1], _effect[2])
    FlyMath(self, 50, 1.5, 1)
end

function SCR_BUFF_LEAVE_PRISON_82_MQ_8_BUFF(self, buff, arg1, arg2, over)
    SetNoDamage(self, 0)
    DetachEffect(self, 'F_circle002')
    PlayEffect(self, 'I_explosion014_white', 1.2, nil, 'MID')
    if self.Faction == 'Monster' then
        Kill(self)
    else
        Dead(self)
    end
--    KILL_BLEND(self, 1, 1)
end



--PRISON_78_MQ_3_ITEM_BUFF
function SCR_BUFF_ENTER_PRISON_78_MQ_3_ITEM_BUFF(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_PRISON_78_MQ_3_ITEM_BUFF(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_lineup020_blue_mint', 0.6, nil, 'BOT')
    KILL_BLEND(self, 1, 1)
end



--ORCHARD_34_3_SQ_13_BUFF
function SCR_BUFF_ENTER_ORCHARD_34_3_SQ_13_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_smoke009_green', 2.0, 'BOT')
    ObjectColorBlend(self, 155.0, 255.0, 155.0, 255.0, 1)
end

function SCR_BUFF_LEAVE_ORCHARD_34_3_SQ_13_BUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'I_smoke009_green')
    ObjectColorBlend(self, 255.0, 255.0, 255.0, 255.0, 1)
end



--CASTLE_20_3_OBJ_19_BUFF
function SCR_BUFF_ENTER_CASTLE_20_3_OBJ_19_BUFF(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_light028_blue', 1.2, nil, 'MID')
end

function SCR_BUFF_LEAVE_CASTLE_20_3_OBJ_19_BUFF(self, buff, arg1, arg2, over)
    
end



--CASTLE_20_1_SQ_2_BUFF
function SCR_BUFF_ENTER_CASTLE_20_1_SQ_2_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_light004_blue', 5.0, 'MID')
end

function SCR_BUFF_LEAVE_CASTLE_20_1_SQ_2_BUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'I_light004_blue')
end



--CASTLE_20_1_SQ_6_BUFF
function SCR_BUFF_ENTER_CASTLE_20_1_SQ_6_BUFF(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_CASTLE_20_1_SQ_6_BUFF(self, buff, arg1, arg2, over)
    local result1 = SCR_QUEST_CHECK(self,'CASTLE_20_1_SQ_6')
    if result1 == 'PROGRESS' then
        for i = 1, 4 do
            if isHideNPC(self, 'CASTLE_20_1_OBJ_6_'..i) == 'NO' then
                for j = 1, 4 do
                    UnHideNPC(self, 'CASTLE_20_1_OBJ_6_'..j)
                end
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CASTLE_20_1_SQ_2_BUFF_MSG1"), 5);
                return;
            end
        end
    end
end



--CASTLE_20_4_SQ_5_BUFF
function SCR_BUFF_ENTER_CASTLE_20_4_SQ_5_BUFF(self, buff, arg1, arg2, over)
    SetNoDamage(self, 1)
end

function SCR_BUFF_UPDATE_CASTLE_20_4_SQ_5_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local zon_Obj = GetLayerObject(self);
    if zon_Obj ~= nil then
        local zoneID = GetZoneInstID(self)
        local list, cnt = GetLayerAliveMonList(zoneID, GetLayer(self));
        if cnt >= 1 then
            for i = 1 , cnt do
                if list[i].ClassName == 'Shardstatue_black' then
                    return 1;
                end
            end
        end
    end
    return 0;
end

function SCR_BUFF_LEAVE_CASTLE_20_4_SQ_5_BUFF(self, buff, arg1, arg2, over)
    SetNoDamage(self, 0)
end



--CASTLE_20_4_SQ_7_BUFF_1
function SCR_BUFF_ENTER_CASTLE_20_4_SQ_7_BUFF_1(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_CASTLE_20_4_SQ_7_BUFF_1(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, 'F_smoke015_green', 1.0, nil, 'BOT')
    local list, cnt = SelectObject(self, 300, 'ALL', 1)
    if cnt >= 1 then
        for i = 1, cnt do
            if list[i].ClassName == 'PC' then
                local buff1 = GetBuffByName(list[i], 'CASTLE_20_4_SQ_7_BUFF_2')
                local buff2 = GetBuffByName(list[i], 'CASTLE_20_4_SQ_7_BUFF_3')
                if buff1 == nil and buff2 == nil then
                    AddBuff(list[i], list[i], 'CASTLE_20_4_SQ_7_BUFF_2', 1, 0, 10000, 1)
                end
            end
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_CASTLE_20_4_SQ_7_BUFF_1(self, buff, arg1, arg2, over)
    
end



--CASTLE_20_4_SQ_7_BUFF_2
function SCR_BUFF_ENTER_CASTLE_20_4_SQ_7_BUFF_2(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_CASTLE_20_4_SQ_7_BUFF_2(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetLayer(self) ~= 0  then
        if GetZoneName(self) == 'f_castle_20_4' then
            local result1 = SCR_QUEST_CHECK(self, 'CASTLE_20_4_SQ_7')
            if result1 == 'PROGRESS' then
                TakeDamage(self, self, "None", 289, "Poison", "None", "TrueDamage", HIT_POISON, HITRESULT_BLOW);
                return 1;
            end
        end
    end
end

function SCR_BUFF_LEAVE_CASTLE_20_4_SQ_7_BUFF_2(self, buff, arg1, arg2, over)
    
end



--CASTLE_20_4_SQ_7_BUFF_3
function SCR_BUFF_ENTER_CASTLE_20_4_SQ_7_BUFF_3(self, buff, arg1, arg2, over)
    local buff1 = GetBuffByName(self, 'CASTLE_20_4_SQ_7_BUFF_2')
    if buff1 ~= nil then
        RemoveBuff(self, 'CASTLE_20_4_SQ_7_BUFF_2')
    end
end

function SCR_BUFF_UPDATE_CASTLE_20_4_SQ_7_BUFF_3(self, buff, arg1, arg2, RemainTime, ret, over)
    local buff1 = GetBuffByName(self, 'CASTLE_20_4_SQ_7_BUFF_2')
    if buff1 ~= nil then
        RemoveBuff(self, 'CASTLE_20_4_SQ_7_BUFF_2')
    end
    return 1;
end

function SCR_BUFF_LEAVE_CASTLE_20_4_SQ_7_BUFF_3(self, buff, arg1, arg2, over)
    
end



--HIDDEN_MIKO_SIAULIAI_46_2_BUFF
function SCR_BUFF_ENTER_HIDDEN_MIKO_SIAULIAI_46_2_BUFF(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_light089_green', 1.0, nil, 'BOT')
end

function SCR_BUFF_LEAVE_HIDDEN_MIKO_SIAULIAI_46_2_BUFF(self, buff, arg1, arg2, over)
    
end



--FTOWER_69_2_G3_BUFF_RED
function SCR_BUFF_ENTER_FTOWER_69_2_G3_BUFF_RED(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_levitation005_dark_red_attach', 1.5, 'MID')
end

function SCR_BUFF_LEAVE_FTOWER_69_2_G3_BUFF_RED(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_levitation005_dark_red_attach')
end



--FTOWER_69_2_G3_BUFF_BLUE
function SCR_BUFF_ENTER_FTOWER_69_2_G3_BUFF_BLUE(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_levitation005_dark_blue_attach', 1.5, 'MID')
end

function SCR_BUFF_LEAVE_FTOWER_69_2_G3_BUFF_BLUE(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_levitation005_dark_blue_attach')
end



--FTOWER_69_2_G4_BUFF_1
function SCR_BUFF_ENTER_FTOWER_69_2_G4_BUFF_1(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_light104_yellow_loop', 3.0, 'BOT')
end

function SCR_BUFF_LEAVE_FTOWER_69_2_G4_BUFF_1(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_light104_yellow_loop')
end



--FTOWER_69_2_G4_BUFF_2
function SCR_BUFF_ENTER_FTOWER_69_2_G4_BUFF_2(self, buff, arg1, arg2, over)
    -- 버프 보상 --
    UnHideNPC(self, 'FTOWER_69_2_G4_3_GAP')
    AttachEffect(self, 'I_light017_yellow', 15.0, 'MID')
    self.PATK_BM = self.PATK_BM + 60;
    self.MATK_BM = self.MATK_BM + 60;
    self.DEF_BM = self.DEF_BM + 45;
end

function SCR_BUFF_LEAVE_FTOWER_69_2_G4_BUFF_2(self, buff, arg1, arg2, over)
    -- 버프 보상 ??�?--
    HideNPC(self, 'FTOWER_69_2_G4_3_GAP')
    DetachEffect(self, 'I_light017_yellow')
    self.PATK_BM = self.PATK_BM - 60;
    self.MATK_BM = self.MATK_BM - 60;
    self.DEF_BM = self.DEF_BM - 45;
end



--QUEST_HOLD_MOVE_BUFF
function SCR_BUFF_ENTER_QUEST_HOLD_MOVE_BUFF(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_QUEST_HOLD_MOVE_BUFF(self, buff, arg1, arg2, over)
    
end



--FLASH59_SQ_12_NPC
function SCR_BUFF_ENTER_FLASH59_SQ_12_NPC(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_levitation008_yellow', 2, 'MID')
end

function SCR_BUFF_UPDATE_FLASH59_SQ_12_NPC(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, 'F_levitation008_yellow', 2, 'MID')
    return 1;
end

function SCR_BUFF_LEAVE_FLASH59_SQ_12_NPC(self, buff, arg1, arg2, over)

end








--KILLING_PLACE_1
function SCR_BUFF_ENTER_KILLING_PLACE_1(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_KILLING_PLACE_1(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, cnt = SelectObjectByFaction(self, 150, 'Monster')
    local i
    if cnt > 0 then
        for i = 1 , cnt do
            PlayEffect(list[i], 'F_explosion023', 0.5)
            TakeDamage(self, list[i], "None", 99999, "Fire", "None", "Magic", HIT_FIRE, HITRESULT_BLOW);
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_KILLING_PLACE_1(self, buff, arg1, arg2, over)

end





--RUNAWAY_MONSTER
function SCR_BUFF_ENTER_RUNAWAY_MONSTER(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 10 * arg1;
    InvalidateStates(self);
end

function SCR_BUFF_LEAVE_RUNAWAY_MONSTER(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 10 * arg1;
    InvalidateStates(self);
end



--CHATHEDRAL56_MQ03_BUFF
function SCR_BUFF_ENTER_CHATHEDRAL56_MQ03_BUFF(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Peaceful')
end

function SCR_BUFF_UPDATE_CHATHEDRAL56_MQ03_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
--    local Quest_Result = SCR_QUEST_CHECK(self, "CHATHEDRAL56_MQ03")
--    if Quest_Result == "SUCCESS" then
--        return 0;
--    else 
--        return 1;
--    end
    
    
    
    AddStamina(self, 99999);
    if GetLayer(self) ~= 0 then
        return 0
    end
    local result = SCR_QUEST_CHECK(self, 'CHATHEDRAL56_MQ03')
    if result ~= 'PROGRESS' then
        return 0
    end
    if GetZoneName(self) ~= 'd_cathedral_56' then
        return 0
    end
   
    return 1;
end

function SCR_BUFF_LEAVE_CHATHEDRAL56_MQ03_BUFF(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Law')
    TransformToMonster(self, "None", "None");
end




--GELE574_MQ_05
function SCR_BUFF_ENTER_GELE574_MQ_05(self, buff, arg1, arg2, over)
    AddBuff(self, self, 'HPLock', 1, 0, 0, 1)
end

function SCR_BUFF_UPDATE_GELE574_MQ_05(self, buff, arg1, arg2, RemainTime, ret, over)
    if self.HP < 20 then
        AddBuff(self, self, 'Stun', 1, 0, 3000, 1)
        AddBuff(self, self, 'HPLock', 1, 0, 3000, 1)
        AddBuff(self, self, 'GELE574_MQ_05_2', 1, 0, 0, 1)
        AddHP(self, self.MHP/2);
        ClearBTree(self)
        RunSimpleAIOnly(self, 'GELE574_MQ_05_AI')
        self.NumArg4 = 1553
        return 0
    end
    return 1;
end

function SCR_BUFF_LEAVE_GELE574_MQ_05(self, buff, arg1, arg2, over)
    RemoveBuff(self, 'HPLock')
end

--PILGRIM51_SQ_1 : SPEED-UP
function SCR_BUFF_ENTER_PILGRIM51_SQ_1_SPEED(self, buff, arg1, arg2, over)
--  self.MSPD_BM = self.MSPD_BM + 10
--  InvalidateStates(self);
end

function SCR_BUFF_UPDATE_PILGRIM51_SQ_1_SPEED(self, buff, arg1, arg2, RemainTime, ret, over)
    self.MSPD_BM = self.MSPD_BM + 10
    InvalidateStates(self);
--    return 1;
end

function SCR_BUFF_LEAVE_PILGRIM51_SQ_1_SPEED(self, buff, arg1, arg2, over)
--  self.MSPD_BM = self.MSPD_BM - 10
--  InvalidateStates(self);
end



--THORN19_GATE1_DEBUFF
function SCR_BUFF_ENTER_THORN19_GATE1_DEBUFF(self, buff, arg1, arg2, over)
    local mspdadd = self.MSPD * 0.7
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
end

function SCR_BUFF_UPDATE_THORN19_GATE1_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    TakeDamage(self, self, "None", 70, "Melee", "None", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW)
    return 1;
end

function SCR_BUFF_LEAVE_THORN19_GATE1_DEBUFF(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;
end

--THORN19_GATE2_DEBUFF
function SCR_BUFF_ENTER_THORN19_GATE2_DEBUFF(self, buff, arg1, arg2, over)
    local mspdadd = self.MSPD * 0.7
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
end

function SCR_BUFF_UPDATE_THORN19_GATE2_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    TakeDamage(self, self, "None", 70, "Poison", "None", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW)
    return 1;
end

function SCR_BUFF_LEAVE_THORN19_GATE2_DEBUFF(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;
end


--THORN19_GATE3_DEBUFF
function SCR_BUFF_ENTER_THORN19_GATE3_DEBUFF(self, buff, arg1, arg2, over)
    local mspdadd = self.MSPD * 0.7
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
end

function SCR_BUFF_UPDATE_THORN19_GATE3_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    TakeDamage(self, self, "None", 70, "Dark", "None", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW)
    return 1;
end

function SCR_BUFF_LEAVE_THORN19_GATE3_DEBUFF(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;
end

--PILGRIM47_CRYST08
function SCR_BUFF_ENTER_PILGRIM47_CRYST08(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Neutral')
    ClearBTree(self)
    self.NumArg1 = 1
end

function SCR_BUFF_LEAVE_PILGRIM47_CRYST08(self, buff, arg1, arg2, over)
    local tobt = CreateBTree('BasicMonster')
    SetBTree(self, tobt)
    SetCurrentFaction(self, 'Monster')
    self.NumArg1 = 0
end




--PILGRIM47_SQ_090_EFF_DEL
function SCR_BUFF_ENTER_PILGRIM47_SQ_090_EFF_DEL(self, buff, arg1, arg2, over)
--    AttachEffect(self, 'F_bg_pattern004')
    AttachEffect(self, 'F_smoke130_blue_loop2')
end

function SCR_BUFF_LEAVE_PILGRIM47_SQ_090_EFF_DEL(self, buff, arg1, arg2, over)
--    DetachEffect(self, 'F_bg_pattern004')
    DetachEffect(self, 'F_smoke130_blue_loop2')
end


--PILGRIM50_SQ_028
function SCR_BUFF_ENTER_PILGRIM50_SQ_028(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Peaceful')
    AttachEffect(self, 'I_smoke038_blue', 1.5)
    ObjectColorBlend(self, 100, 100, 255, 180, 1)
end

function SCR_BUFF_LEAVE_PILGRIM50_SQ_028(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Law')
    DetachEffect(self, 'I_smoke038_blue')
    ObjectColorBlend(self, 255, 255, 255, 255, 1)
end



--PILGRIM50_SQ_028_BOOM
function SCR_BUFF_ENTER_PILGRIM50_SQ_028_BOOM(self, buff, arg1, arg2, over)
    AddBuff(self, self, 'PILGRIM50_SQ_028_BUFF_DEAD', 1, 0, 6560, 1)
end

function SCR_BUFF_LEAVE_PILGRIM50_SQ_028_BOOM(self, buff, arg1, arg2, over)
    local pc_mon = GetScpObjectList(self, 'PILGRIM50_SQ_028')
    if #pc_mon ~= 0 then
        
        KnockDown(self, pc_mon[1] , 250, GetAngleTo(self, pc_mon[1]), 45, 0.5)
        PlayEffect(self, 'F_light016', 1)
    else
        
        KnockDown(self, self, 250, 0, 45, 0.5)
        PlayEffect(self, 'F_light016', 1)
    end
end


--PILGRIM50_SQ_028_BUFF_DEAD
function SCR_BUFF_ENTER_PILGRIM50_SQ_028_BUFF_DEAD(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_PILGRIM50_SQ_028_BUFF_DEAD(self, buff, arg1, arg2, over)
    Dead(self)
end

-- GIMMICK_NEXTNUMBER
function SCR_BUFF_ENTER_GIMMICK_NEXTNUMBER(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_GIMMICK_NEXTNUMBER(self, buff, arg1, arg2, RemainTime, ret, over)
    AddHP(self, 50);
    return 1;
end

function SCR_BUFF_LEAVE_GIMMICK_NEXTNUMBER(self, buff, arg1, arg2, over)

end


--CHATHEDRAL56_SQ04_HEAL
function SCR_BUFF_ENTER_CHATHEDRAL56_SQ04_HEAL(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_CHATHEDRAL56_SQ04_HEAL(self, buff, arg1, arg2, RemainTime, ret, over)
    AddHP(self, 30);
    return 1;

end

function SCR_BUFF_LEAVE_CHATHEDRAL56_SQ04_HEAL(self, buff, arg1, arg2, over)

end

--CHATHEDRAL54_MQ04_PART2
function SCR_BUFF_ENTER_CHATHEDRAL54_MQ04_PART2(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_CHATHEDRAL54_MQ04_PART2(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, cnt = SelectObjectByClassName(self, 70, 'Altarcrystal_N1')
    local i
    if cnt ~= 0 then
    local pc_mon = GetScpObjectList(self, 'CHATHEDRAL54_MQ04_PART2')
        if #pc_mon ~= 0 then
            PlayEffect(self, 'F_archer_sightshoot_shot_light', 1, 1, 'MID')
        end
    else
        RemoveBuff(self, 'CHATHEDRAL54_MQ04_PART2')
    end
    return 0;
end

function SCR_BUFF_LEAVE_CHATHEDRAL54_MQ04_PART2(self, buff, arg1, arg2, over)
end

--CATHEDRAL54_SQ04
function SCR_BUFF_ENTER_CATHEDRAL54_SQ04_DEBUFF(self, buff, arg1, arg2, over)
    SetEmoticon(self, 'I_emo_stitch')
end

function SCR_BUFF_LEAVE_CATHEDRAL54_SQ04_DEBUFF(self, buff, arg1, arg2, over)
    HideEmoticon(self, 'I_emo_stitch')
end



--HAUBERK_HOVER
function SCR_BUFF_ENTER_HAUBERK_HOVER(self, buff, arg1, arg2, over)
    local hover = GetScpObjectList(self, 'HAUBERK_HOVER')
    if #hover == 0 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', 1);
        SetOwner(mon, self, 1)
        AddScpObjectList(self, 'HAUBERK_HOVER', mon)
        AttachEffect(mon, 'F_light055_black', 2, 'TOP')
        HoverAround(mon, self, 10, 1, 2, 1); 
    end
end

function SCR_BUFF_UPDATE_HAUBERK_HOVER(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetLayer(self) ~= 0 then
        return 0
    end
--    local hover = GetScpObjectList(self, 'HAUBERK_HOVER')
--    if #hover == 0 then
--        local x, y, z = GetPos(self)
--        local mon = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, VPRISON511_MQ_01_03_SCR_02_RUN);
--        AddScpObjectList(self, 'HAUBERK_HOVER', mon)
--        AttachEffect(mon, 'F_light055_violet', 4, 'TOP')
--        HoverAround(mon, self, 10, 1, 2, 1); 
--    end

    return 1;
end

function SCR_BUFF_LEAVE_HAUBERK_HOVER(self, buff, arg1, arg2, over)
    local hover = GetScpObjectList(self, 'HAUBERK_HOVER')
    if #hover ~= 0 then
        local i
        for i = 1,  #hover do
            Kill(hover[i])
        end
    end
end

function SCR_HAUBERK_HOVER_RERUN(self)
    local _pc = GetOwner(self)
    if _pc ~= nil then
        AddBuff(_pc, _pc, 'HAUBERK_HOVER', 1, 0 ,0,1)
    end
end



--VPRISON512_MQ_03_DEBUFF
function SCR_BUFF_ENTER_VPRISON512_MQ_03_DEBUFF(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_VPRISON512_MQ_03_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local _pc = GetBuffCaster(buff)
    if _pc ~= nil then
        if GetDistance(_pc, self) > 200 then
            return 0
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_VPRISON512_MQ_03_DEBUFF(self, buff, arg1, arg2, over)
    local _pc = GetBuffCaster(buff)
    if _pc ~= nil then
        if GetDistance(_pc, self) > 180 then
            return 0
        end
        local msg = {'VPRISON512_MQ_03_DEBUFF_1',
                    'VPRISON512_MQ_03_DEBUFF_2',
                    'VPRISON512_MQ_03_DEBUFF_3',
                    'VPRISON512_MQ_03_DEBUFF_4',
                    'VPRISON512_MQ_03_DEBUFF_5'
                    }
        local quest_ssn = GetSessionObject(_pc, 'SSN_VPRISON512_MQ_03')
        ShowBalloonText(_pc, msg[quest_ssn.QuestInfoValue1+1], 5)
        SCR_PARTY_QUESTPROP_ADD(_pc, 'SSN_VPRISON512_MQ_03', 'QuestInfoValue1', 1)
    end
end


--SIAULIAI_50_MON
function SCR_BUFF_ENTER_SIAULIAI_50_MON(self, buff, arg1, arg2, over)
    SetEmoticon(self, 'I_emo_infection')
end

function SCR_BUFF_LEAVE_SIAULIAI_50_MON(self, buff, arg1, arg2, over)
    HideEmoticon(self, 'I_emo_infection')
end



--VPRISON515_MQ_03_DEBUFF
function SCR_BUFF_ENTER_VPRISON515_MQ_03_DEBUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_cleric_bakarine_loop', 1.5, 'MID')
    AddBuff(self, self, 'HPLock', 10, 0, 60000, 1)
end

function SCR_BUFF_UPDATE_VPRISON515_MQ_03_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetHpPercent(self) < 0.4 then
        if self.NumArg1 == 0 then
            self.NumArg1 = 1553
            local _pc = GetBuffCaster(buff)
            if _pc ~= nil then
                SCR_PARTY_QUESTPROP_ADD(_pc, 'SSN_VPRISON515_MQ_03', 'QuestInfoValue1', 1)
                SetCurrentFaction(self, 'Neutral')
                ClearBTree(self)
                RunSimpleAIOnly(self, 'VPRISON515_MQ_03_AI')
            end
        end
        return 0
    end

    return 1;
end

function SCR_BUFF_LEAVE_VPRISON515_MQ_03_DEBUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_cleric_bakarine_loop')
    RemoveBuff(self, 'HPLock')
end





--VPRISON515_MQ_04_DEBUFF
function SCR_BUFF_ENTER_VPRISON515_MQ_04_DEBUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_cleric_bakarine_loop', 1.5, 'MID')
    AddBuff(self, self, 'HPLock', 10, 0, 60000, 1)
end

function SCR_BUFF_UPDATE_VPRISON515_MQ_04_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetHpPercent(self) < 0.2 then
        if self.NumArg1 == 0 then
            self.NumArg1 = 1553
            local _pc = GetBuffCaster(buff)
            if _pc ~= nil then
                SCR_PARTY_QUESTPROP_ADD(_pc, 'SSN_VPRISON515_MQ_04', 'QuestInfoValue1', 1)
                SetCurrentFaction(self, 'Peaceful')
                ClearBTree(self)
                StopMove(self)
                RunScript("VPRISON515_MQ_04_AI_1_RUN", self)
            end
        end
        return 0
    end

    return 1;
end

function SCR_BUFF_LEAVE_VPRISON515_MQ_04_DEBUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_cleric_bakarine_loop')
    RemoveBuff(self, 'HPLock')
end

--FARM47_1_SQ_030
function SCR_BUFF_ENTER_FARM47_1_SQ_030(self, buff, arg1, arg2, over)
    SetExProp(buff, "FARM47_1_SQ_030", self.MSPD);
    
end

function SCR_BUFF_UPDATE_FARM47_1_SQ_030(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, cnt = SelectObjectByClassName(self, 100, 'Skill_poison_pot')
    local i
    if cnt ~= 0 then
         
        if self.MSPD > 0 then
            local pc_mon = GetScpObjectList(self, 'FARM47_1_SQ_030')
            if #pc_mon ~= 0 then
                if IsBuffApplied(self, 'FARM47_1_SQ_030_01') == 'NO' then
                    --PlayEffect(self, 'F_smoke136', 1, 1, 'MID')
                    SCR_PARTY_QUESTPROP_ADD(pc_mon[1], 'SSN_FARM47_1_SQ_030', 'QuestInfoValue1', IMCRandom(10, 100))
                end
            end
            self.MSPD = self.MSPD - 2.5
            return 1;
        else
            if IsBuffApplied(self, 'FARM47_1_SQ_030_01') == 'NO' then
                AttachEffect(self, 'F_ground017_loop', 1, 'BOT')
                AddBuff(self, self, 'FARM47_1_SQ_030_01', 1, 0, 0, 1)
                RemoveBuff(self, 'FARM47_1_SQ_030')
            end
        end
    else
        DetachEffect(self, 'F_ground017_loop')
        RemoveBuff(self, 'FARM47_1_SQ_030')
    end
end

function SCR_BUFF_LEAVE_FARM47_1_SQ_030(self, buff, arg1, arg2, over)
    self.MSPD = GetExProp(buff, "FARM47_1_SQ_030")
end

--FARM47_1_SQ_030_01
function SCR_BUFF_ENTER_FARM47_1_SQ_030_01(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_FARM47_1_SQ_030_01(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, cnt = SelectObjectByClassName(self, 100, 'Skill_poison_pot')
    local i
    if cnt ~= 0 then
        return 1;
    else
        RemoveBuff(self, 'FARM47_1_SQ_030_01')
    end
end

function SCR_BUFF_LEAVE_FARM47_1_SQ_030_01(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_ground017_loop')
end

--FARM47_MAGIC_FAKE
function SCR_BUFF_ENTER_FARM47_MAGIC_FAKE(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Neutral')
    ClearBTree(self)
    self.NumArg1 = 1
end

function SCR_BUFF_LEAVE_FARM47_MAGIC_FAKE(self, buff, arg1, arg2, over)
    local tobt = CreateBTree('BasicMonster')
    SetBTree(self, tobt)
    SetCurrentFaction(self, 'Monster')
    self.NumArg1 = 0
end




--FARM47_2_SQ_060_EFF_DEL
function SCR_BUFF_ENTER_FARM47_2_SQ_060_EFF_DEL(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_smoke130_blue_loop2')
end

function SCR_BUFF_LEAVE_PILGRIM47_SQ_090_EFF_DEL(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_smoke130_blue_loop2')
end

--VELNIASP54_1_BOSS MONSTER BUFF
function SCR_BUFF_ENTER_BOSS_RAGE(self, buff, arg1, arg2, over)
    local atk_add = arg1 * 15
    local def_add = arg1 * 5
    
    self.PATK_BM = self.PATK_BM + atk_add;
    self.MATK_BM = self.MATK_BM + atk_add;
    self.MDEF_BM = self.MDEF_BM + def_add;
    self.DEF_BM = self.DEF_BM + def_add;
    
    SetExProp(buff, "BOSS_RAGE_ATK_ADD", atk_add)
    SetExProp(buff, "BOSS_RAGE_DEF_ADD", def_add)
    
    InvalidateStates(self)
end

function SCR_BUFF_LEAVE_BOSS_RAGE(self, buff, arg1, arg2, over)
    local atk_add = GetExProp(buff, "BOSS_RAGE_ATK_ADD")
    local def_add = GetExProp(buff, "BOSS_RAGE_DEF_ADD")
--  print("atk_add : "..atk_add..", def_add : "..def_add)
    self.PATK_BM = self.PATK_BM - atk_add;
    self.MATK_BM = self.MATK_BM - atk_add;
    self.MDEF_BM = self.MDEF_BM - def_add;
    self.DEF_BM = self.DEF_BM - def_add;
    
    InvalidateStates(self)
end

--VELNIASP54_1 MONSTER
function SCR_BUFF_ENTER_VELNIASP54_MON_RAGE(self, buff, arg1, arg2, over)
    SetNoDamage(self, 1);
end

function SCR_BUFF_LEAVE_VELNIASP54_MON_RAGEE(self, buff, arg1, arg2, over)
    SetNoDamage(self, 0);
end




--FD_UNDERF592_TYPEA_MONKILL
function SCR_BUFF_ENTER_FD_UNDERF592_TYPEA_MONKILL(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_FD_UNDERF592_TYPEA_MONKILL(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, 'F_circle020_light', 1)
    return 1;
end

function SCR_BUFF_LEAVE_FD_UNDERF592_TYPEA_MONKILL(self, buff, arg1, arg2, over)
    
end


--FD_UNDERF592_TYPEA_BUFF
function SCR_BUFF_ENTER_FD_UNDERF592_TYPEA_BUFF(self, buff, arg1, arg2, over)
    if self.MSPD_BM < 70 then
        local addSPD = 70 - self.MSPD_BM
        SetExProp(buff, "ADD_SPD", addSPD);
        self.MSPD_BM = self.MSPD_BM + addSPD
    end
    AttachEffect(self, 'I_cleric_oobe_loop_levitation1', 3)
    InvalidateStates(self);
    ObjectColorBlend(self, 255, 255, 255, 145, 1, 1)
    
end

function SCR_BUFF_LEAVE_FD_UNDERF592_TYPEA_BUFF(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255, 255, 255, 255, 1, 1)
    DetachEffect(self, 'I_cleric_oobe_loop_levitation1')
    self.MSPD_BM = self.MSPD_BM - GetExProp(buff, "ADD_SPD")
    InvalidateStates(self);
end




--FD_UNDERF592_TYPEC_FIRE_BUFF
function SCR_BUFF_ENTER_FD_UNDERF592_TYPEC_FIRE_BUFF(self, buff, arg1, arg2, over)
    local x, y, z = GetPos(self)
    local mon = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, FD_UNDERF592_TYPEC_FIRE_BUFF_RUN);
    SetOwner(mon, self, 1)
    AttachEffect(mon, 'F_light055_black', 2, 'TOP')
    HoverAround(mon, self, 10, 1, 2, 1); 
end

function SCR_BUFF_LEAVE_FD_UNDERF592_TYPEC_FIRE_BUFF(self, buff, arg1, arg2, over)

end

function FD_UNDERF592_TYPEC_FIRE_BUFF_RUN(mon)
    mon.SimpleAI = 'FD_UNDERF592_TYPEC_FIRE_BUFF_RUN'
    mon.Name = 'UnvisibleName'
end

function FD_UNDERF592_TYPEC_FIRE_BUFF_AI(self)
    local _pc = GetOwner(self)
    if _pc == nil then
        Kill(self)
    else
        if IsBuffApplied(_pc, 'FD_UNDERF592_TYPEC_FIRE_BUFF') == 'NO' then
            Kill(self)
        end
    end
end






--FD_UNDERF593_TYPEC_STONE
function SCR_BUFF_ENTER_FD_UNDERF593_TYPEC_STONE(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Neutral')

    
end

function SCR_BUFF_LEAVE_FD_UNDERF593_TYPEC_STONE(self, buff, arg1, arg2, over)
    local zon_Obj = GetLayerObject(self);
    if zon_Obj.UNDERF593_TOTAL_CONTROL == 0 then
        zon_Obj.UNDERF593_TOTAL_CONTROL = 1
    end
    SetRenderOption(self, "Freeze", 0);
    SetCurrentFaction(self, 'Monster')
    SCR_DUNGEON_NOTICE(self, 'scroll', 'UNDERF593_TYPED_EXIT', 5)
end






--FD_UNDERF593_TYPEA_ICEBLAST
function SCR_BUFF_ENTER_FD_UNDERF593_TYPEA_ICEBLAST(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_spread_in021_ice', 10)
    local x, y, z = GetPos(self)
    local range = SCR_POINT_DISTANCE(x, z, -270, -1066)
    Move3DByTime(self, -270, -72, -1066, (range/100)/1.5, 1, 1)
    
    SetRenderOption(self, "Freeze", 1);
end

function SCR_BUFF_LEAVE_FD_UNDERF593_TYPEA_ICEBLAST(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_spread_in021_ice')
    SetRenderOption(self, "Freeze", 0);
end



--SSN_UNDERF592_TYPEB_BUFF
function SCR_BUFF_ENTER_SSN_UNDERF592_TYPEB_BUFF(self, buff, arg1, arg2, over)
--    local ssn = GetSessionObject(self, 'SSN_UNDERF592_TYPEB')
--    if ssn == nil then
--        CreateSessionObject(self, 'SSN_UNDERF592_TYPEB', 1)
--    end
end

function SCR_BUFF_LEAVE_SSN_UNDERF592_TYPEB_BUFF(self, buff, arg1, arg2, over)
--    local ssn = GetSessionObject(self, 'SSN_UNDERF592_TYPEB')
--    if ssn ~= nil then
--        DestroySessionObject(self, ssn)
--    end
end




--UNDERF591_TYPEB_RUMBLE_BUFF
function SCR_BUFF_ENTER_UNDERF591_TYPEB_RUMBLE_BUFF(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Law')
end

function SCR_BUFF_UPDATE_UNDERF591_TYPEB_RUMBLE_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, cnt = SelectObjectByFaction(self, 500, 'Monster')
    local i
    if cnt > 0 then
        for i = 1, cnt do
            InsertHate(self, list[i], 50)
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_UNDERF591_TYPEB_RUMBLE_BUFF(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Neutral')

end






--UNDERF591_TYPEB_RUMBLE_SUCC
function SCR_BUFF_ENTER_UNDERF591_TYPEB_RUMBLE_SUCC(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_UNDERF591_TYPEB_RUMBLE_SUCC(self, buff, arg1, arg2, RemainTime, ret, over)
    if self.HP < self.MHP then
        Heal(self, (self.MHP/110), 0);
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_UNDERF591_TYPEB_RUMBLE_SUCC(self, buff, arg1, arg2, over)

end

--FARM47_3_SQ_050
function SCR_BUFF_ENTER_FARM47_3_SQ_050(self, buff, arg1, arg2, over)
    SetExProp(buff, "FARM47_3_SQ_050", self.MSPD);
    
end

function SCR_BUFF_UPDATE_FARM47_3_SQ_050(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, cnt = SelectObjectByClassName(self, 100, 'Skill_poison_pot')
    local i
    if cnt ~= 0 then
         
        if self.MSPD > 0 then
            local pc_mon = GetScpObjectList(self, 'FARM47_3_SQ_050')
            if #pc_mon ~= 0 then
                if IsBuffApplied(self, 'FARM47_3_SQ_050_01') == 'NO' then
                    --PlayEffect(self, 'F_smoke136', 1, 1, 'MID')
                    SCR_PARTY_QUESTPROP_ADD(pc_mon[1], 'SSN_FARM47_3_SQ_050', 'QuestInfoValue1', IMCRandom(10, 100))
                end
            end
            self.MSPD = self.MSPD - 2.5
            return 1;
        else
            if IsBuffApplied(self, 'FARM47_3_SQ_050_01') == 'NO' then
                AttachEffect(self, 'F_ground017_loop', 1, 'BOT')
                AddBuff(self, self, 'FARM47_3_SQ_050_01', 1, 0, 0, 1)
                RemoveBuff(self, 'FARM47_3_SQ_050')
            end
        end
    else
        DetachEffect(self, 'F_ground017_loop')
        RemoveBuff(self, 'FARM47_3_SQ_050')
    end
end

function SCR_BUFF_LEAVE_FARM47_3_SQ_050(self, buff, arg1, arg2, over)
    self.MSPD = GetExProp(buff, "FARM47_3_SQ_050")
end

--FARM47_3_SQ_050_01
function SCR_BUFF_ENTER_FARM47_3_SQ_050_01(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_FARM47_3_SQ_050_01(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, cnt = SelectObjectByClassName(self, 100, 'Skill_poison_pot')
    local i
    if cnt ~= 0 then
        return 1;
    else
        RemoveBuff(self, 'FARM47_3_SQ_050_01')
    end
end

function SCR_BUFF_LEAVE_FARM47_3_SQ_050_01(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_ground017_loop')
end

--CMINE8_ANTIPOISON
function SCR_BUFF_ENTER_CMINE8_ANTIPOISON(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_CMINE8_ANTIPOISON(self, buff, arg1, arg2, over)
end




--VPRISON513_MQ_03_HAUBERK
function SCR_BUFF_ENTER_VPRISON513_MQ_03_HAUBERK(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_light075_yellow_loop', 5, 'MID')
end

function SCR_BUFF_LEAVE_VPRISON513_MQ_03_HAUBERK(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_light075_yellow_loop')
end



--NPC_RETURN_CREATE_POS
function SCR_BUFF_ENTER_NPC_RETURN_CREATE_POS(self, buff, arg1, arg2, over)
    if IsBuffApplied(self, 'NPC_RETURN_CREATE_POS') == 'NO' then
        local addspd = self.MSPD + 30
        self.MSPD_BM = self.MSPD_BM + addspd;
        SetExProp(buff, "NPC_RETURN_CREATE_POS", addspd);
    end
end

function SCR_BUFF_UPDATE_NPC_RETURN_CREATE_POS(self, buff, arg1, arg2, RemainTime, ret, over)

    local x, y, z, angle = GetTacticsArgFloat(self, x, y, z, angle)
    if GetDistFromPos(self, self.CreateX, self.CreateY, self.CreateZ) > 10 then
        MoveEx(self, self.CreateX, self.CreateY, self.CreateZ, 1);
    else
        PlayAnim(self, 'STD', 1)
        SetDirectionByAngle(self, angle)
        
    end
    return 1
end

function SCR_BUFF_LEAVE_NPC_RETURN_CREATE_POS(self, buff, arg1, arg2, over)
    if IsBuffApplied(self, 'NPC_RETURN_CREATE_POS') == 'YES' then
        local addspd = GetExProp(self, 'NPC_RETURN_CREATE_POS')
        self.MSPD_BM = self.MSPD_BM - addspd;
    end
end



--FLASH60_SQ_05_DEBUFF
function SCR_BUFF_ENTER_FLASH60_SQ_05_DEBUFF(self, buff, arg1, arg2, over)
    local defadd = self.DEF * 0.7
    local spdadd = self.MSPD_BM + 20
    self.DEF_BM = self.DEF_BM - defadd
    self.MSPD_BM = self.MSPD_BM + spdadd
    SetExProp(buff, "FLASH60_SQ_05_DEF", defadd);
    SetExProp(buff, "FLASH60_SQ_05_SPD", spdadd);
    InvalidateStates(self);

end

function SCR_BUFF_LEAVE_FLASH60_SQ_05_DEBUFF(self, buff, arg1, arg2, over)
    local defadd = GetExProp(buff, "FLASH60_SQ_05_DEF");
    local spdadd = GetExProp(buff, "FLASH60_SQ_05_SPD");
    self.DEF_BM = self.DEF_BM + defadd;
    self.MSPD_BM = self.MSPD_BM - spdadd
    InvalidateStates(self);
end



--THORN39_2_SQ05_TARGET
function SCR_BUFF_ENTER_THORN39_2_SQ05_TARGET(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_sys_target_pc2', 5, 'BOT')
end

function SCR_BUFF_LEAVE_THORN39_2_SQ05_TARGET(self, buff, arg1, arg2, over)
end



--FLASH61_SQ_02_BUFF
function SCR_BUFF_ENTER_FLASH61_SQ_02_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_FLASH61_SQ_02_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff)
    if IsDead(caster) == 0 or caster ~= nil then
        return 1
    else
        return 0
    end
end

function SCR_BUFF_LEAVE_FLASH61_SQ_02_BUFF(self, buff, arg1, arg2, over)

end






--FLASH60_SQ_09_CK
function SCR_BUFF_ENTER_FLASH60_SQ_09_CK(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_FLASH60_SQ_09_CK(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, 'F_spark012_leaf', 2, 1,  'MID')
    return 1
end

function SCR_BUFF_LEAVE_FLASH60_SQ_09_CK(self, buff, arg1, arg2, over)

end





--FLASH63_SQ_02_CK
function SCR_BUFF_ENTER_FLASH63_SQ_02_CK(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_smoke008_red', 1, 'BOT')
end

function SCR_BUFF_UPDATE_FLASH63_SQ_02_CK(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, cnt = SelectObjectByClassName(self, 300, 'Silvertransporter_m_Quest')
    local i
    for i = 1, cnt do
        InsertHate(self, list[i],  1)
    end
    return 1
end

function SCR_BUFF_LEAVE_FLASH63_SQ_02_CK(self, buff, arg1, arg2, over)
    DetachEffect(self, 'I_smoke008_red')
end




--FD_FTOWER611_TYPE_A_DEBUFF
function SCR_BUFF_ENTER_FD_FTOWER611_TYPE_A_DEBUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_FD_FTOWER611_TYPE_A_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if IsBuffApplied(self, 'FD_FTOWER611_TYPE_A_BUFF') == 'NO' then
        if GetBuffOver(self, 'FD_FTOWER611_TYPE_A_DEBUFF') >= 10 then
            AddBuff(self, self, 'FD_FTOWER611_TYPE_A_FLASH', 1, 0, 0, 1)
        else
            ShowBalloonText(self, "FD_FTOWER611_TYPE_A_DEBUFF", 5)
        end
    end
    return 1
end

function SCR_BUFF_LEAVE_FD_FTOWER611_TYPE_A_DEBUFF(self, buff, arg1, arg2, over)
--    if GetBuffOver(self, 'FD_FTOWER611_TYPE_A_DEBUFF') >= 1 then
--        ShowBalloonText(self, "FD_FTOWER611_TYPE_A_REMOVE", 5)
--    end
end




--FD_FTOWER611_TYPE_A_FLASH
function SCR_BUFF_ENTER_FD_FTOWER611_TYPE_A_FLASH(self, buff, arg1, arg2, over)
    SetRenderOption(self, "Stonize", 1);
end

function SCR_BUFF_UPDATE_FD_FTOWER611_TYPE_A_FLASH(self, buff, arg1, arg2, RemainTime, ret, over)
    local buff_cnt = GetExProp(buff, "FD_FTOWER611_TYPE_A_FLASH");
    if buff_cnt <= 10 then
        SetExProp(buff, "FD_FTOWER611_TYPE_A_FLASH", buff_cnt + 1)
        return 1
    elseif buff_cnt > 10 then
        if IsDead(self) == 0 then
            RunScript('FD_FTOWER611_TYPE_A_FLASH_REMOVE', self)
        end
    end
    return 0
end

function SCR_BUFF_LEAVE_FD_FTOWER611_TYPE_A_FLASH(self, buff, arg1, arg2, over)
    SetRenderOption(self, "Stonize", 0);
end

function FD_FTOWER611_TYPE_A_FLASH_REMOVE(self)
    UIOpenToPC(self,'fullblack',1)
    sleep(1000)
    SetPos(self, -295, 177, -2160)
    UIOpenToPC(self,'fullblack',0)
end

--THORN_BUFF
function SCR_BUFF_ENTER_THORN_BUFF(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_THORN_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local buff = GetBuffByName(self, "THORN_BUFF");
    local buff_stack = GetOver(buff)
    local list, cnt = SelectObjectByFaction(self, 50, "Monster")
    for i = 1, cnt do
        if list[i].ClassName == "npc_bramble_root" or list[i].ClassName == "npc_bramble_root_s" or list[i].ClassName == "npc_bramble_root_m" then
            AddBuff(self, self, 'THORN_BUFF', 1, 0, 0, 1)
            return 1;
        end
    end
end

function SCR_BUFF_LEAVE_THORN_BUFF(self, buff, arg1, arg2, over)

end

--ROKAS_ICE_DEBUFF
function SCR_BUFF_ENTER_ROKAS_ICE_DEBUFF(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_freeze', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    SetRenderOption(self, "Freeze", 1);
end

function SCR_BUFF_LEAVE_ROKAS_ICE_DEBUFF(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_freeze')
    SetRenderOption(self, "Freeze", 0);
end

--PROOF_PRIST_BUFF
function SCR_BUFF_ENTER_PROOF_PRIST_BUFF(self, buff, arg1, arg2, over)
    SetNoDamage(self, 1);
end

function SCR_BUFF_LEAVE_PROOF_PRIST_BUFF(self, buff, arg1, arg2, over)
     SetNoDamage(self, 0);
end





--FD_FIRETOWER612_T01_NPC_BLUE
function SCR_BUFF_ENTER_FD_FIRETOWER612_T01_NPC_BLUE(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_FD_FIRETOWER612_T01_NPC_BLUE(self, buff, arg1, arg2, RemainTime, ret, over)
    local healsp = self.MSP / 100
    if healsp < 3 then
        healsp = 3;
    end
    HealSP(self, healsp, 0);
    return 1
end

function SCR_BUFF_LEAVE_FD_FIRETOWER612_T01_NPC_BLUE(self, buff, arg1, arg2, over)

end

--FD_FIRETOWER612_T01_NPC_RED
function SCR_BUFF_ENTER_FD_FIRETOWER612_T01_NPC_RED(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_FD_FIRETOWER612_T01_NPC_RED(self, buff, arg1, arg2, RemainTime, ret, over)
    local heal = self.MHP / 100
    if heal < 5 then
        heal = 5;
    end
    Heal(self, heal, 0);
    return 1
end

function SCR_BUFF_LEAVE_FD_FIRETOWER612_T01_NPC_RED(self, buff, arg1, arg2, over)

end

--FD_FIRETOWER612_T01_NPC_YLL
function SCR_BUFF_ENTER_FD_FIRETOWER612_T01_NPC_YLL(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_FD_FIRETOWER612_T01_NPC_YLL(self, buff, arg1, arg2, RemainTime, ret, over)
    if self.ClassName == 'PC' then
        local sta = self.MaxSta/100
        if sta < 2 then
            sta = 2
        end
        AddStamina(self, sta)
    end
    return 1
end

function SCR_BUFF_LEAVE_FD_FIRETOWER612_T01_NPC_YLL(self, buff, arg1, arg2, over)

end

--PARTY_Q8_CRYSTAL_BUFF
function SCR_BUFF_ENTER_PARTY_Q8_CRYSTAL_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_PARTY_Q8_CRYSTAL_BUFF(self, buff, arg1, arg2, over)

end

--PARTY_Q8_CRYSTAL_FIND
function SCR_BUFF_ENTER_PARTY_Q8_CRYSTAL_FIND(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_PARTY_Q8_CRYSTAL_FIND(self, buff, arg1, arg2, over)

end


--FD_FIRETOWER611_T02_ROMER_DEBUFF
function SCR_BUFF_ENTER_FD_FIRETOWER611_T02_ROMER_DEBUFF(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_FD_FIRETOWER611_T02_ROMER_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, 'F_smoke124_blue2', 0.2, 'TOP')
    return 1
end

function SCR_BUFF_LEAVE_FD_FIRETOWER611_T02_ROMER_DEBUFF(self, buff, arg1, arg2, over)

end



--FD_FIRETOWER611_T02_ROMER_CK
function SCR_BUFF_ENTER_FD_FIRETOWER611_T02_ROMER_CK(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_FD_FIRETOWER611_T02_ROMER_CK(self, buff, arg1, arg2, over)
end



--FD_FIRETOWER612_GEN_NORTH
function SCR_BUFF_ENTER_FD_FIRETOWER612_GEN_NORTH(self, buff, arg1, arg2, over)
    local list, cnt = SelectObjectByClassName(self, 300, 'PC')
    local pc_cnt
    local add
    local add_half
    if cnt <= 5 then
        pc_cnt = 1
    elseif cnt > 6 and cnt <= 10 then
        pc_cnt = 2
    elseif cnt > 10 then
        pc_cnt = 3
    end
    add = (10*over) + (10*pc_cnt)
    add_half = math.floor(add/4)
    --print(add, add_half)
    local i
    local mon = {}
    for i = 1, add do
        if add_half >= i then
            mon[i] = CREATE_MONSTER_EX(self, 'FD_Glyquare', -2055+IMCRandom(-100, 100), 205, 1567+IMCRandom(-100, 100), IMCRandom(-135, 180), 'Monster', IMCRandom(182, 185), FD_FIRETOWER612_T02_MONSTER_AI_RUN_1);
            SetLifeTime(mon[i], 600)
        elseif i > add_half and i <= (add_half*2) then
            mon[i] = CREATE_MONSTER_EX(self, 'FD_Glyquare', -2280+IMCRandom(-100, 100), 205, 1359+IMCRandom(-100, 100), IMCRandom(-135, 180), 'Monster', IMCRandom(182, 185), FD_FIRETOWER612_T02_MONSTER_AI_RUN_1);
            SetLifeTime(mon[i], 600)
        elseif i > (add_half*2) and i <= (add_half*3) then
            --print(i)
            mon[i] = CREATE_MONSTER_EX(self, 'FD_Glyquare', -2051+IMCRandom(-100, 100), 205, 1116+IMCRandom(-100, 100), IMCRandom(-135, 180), 'Monster', IMCRandom(182, 185), FD_FIRETOWER612_T02_MONSTER_AI_RUN_1);
            SetLifeTime(mon[i], 600)
        elseif i > (add_half*3) then
            mon[i] = CREATE_MONSTER_EX(self, 'FD_Glyquare', -1841+IMCRandom(-100, 100), 205, 1359+IMCRandom(-100, 100), IMCRandom(-135, 180), 'Monster', IMCRandom(182, 185), FD_FIRETOWER612_T02_MONSTER_AI_RUN_1);
            SetLifeTime(mon[i], 600)
        end
    end
end

function SCR_BUFF_UPDATE_FD_FIRETOWER612_GEN_NORTH(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetBuffOver(self, 'FD_FIRETOWER612_GEN_NORTH') >= 5 then
        return 0
    else
        if self.NumArg4 < 60 then
            self.NumArg4 = self.NumArg4 + 1
        else
            AddBuff(self, self, 'FD_FIRETOWER612_GEN_NORTH', 1, 0, 0, 1)
            self.NumArg4 = 0
        end
    end 
    return 1
end

function SCR_BUFF_LEAVE_FD_FIRETOWER612_GEN_NORTH(self, buff, arg1, arg2, over)

end



--FD_FIRETOWER612_GEN_SOUTH
function SCR_BUFF_ENTER_FD_FIRETOWER612_GEN_SOUTH(self, buff, arg1, arg2, over)
    local list, cnt = SelectObjectByClassName(self, 300, 'PC')
    local pc_cnt
    local add
    local add_half
    if cnt <= 5 then
        pc_cnt = 1
    elseif cnt > 6 and cnt <= 10 then
        pc_cnt = 2
    elseif cnt > 10 then
        pc_cnt = 3
    end
    add = (10*over) + (10*pc_cnt)
    add_half = math.floor(add/4)
    local i
    local mon = {}
    for i = 1, add do
        if add_half >= i then
            mon[i] = CREATE_MONSTER_EX(self, 'FD_Glyquare', 1698+IMCRandom(-100, 100), 205, -1328+IMCRandom(-100, 100), IMCRandom(-135, 180), 'Monster', IMCRandom(182, 185), FD_FIRETOWER612_T02_MONSTER_AI_RUN_1);
            SetLifeTime(mon[i], 600)
        elseif i > add_half and i <= (add_half*2) then
            mon[i] = CREATE_MONSTER_EX(self, 'FD_Glyquare', 1469+IMCRandom(-100, 100), 205, -1570+IMCRandom(-100, 100), IMCRandom(-135, 180), 'Monster', IMCRandom(182, 185), FD_FIRETOWER612_T02_MONSTER_AI_RUN_1);
            SetLifeTime(mon[i], 600)
        elseif i > (add_half*2) and i <= (add_half*3) then
            --print(i)
            mon[i] = CREATE_MONSTER_EX(self, 'FD_Glyquare', 1683+IMCRandom(-100, 100), 205, -1774+IMCRandom(-100, 100), IMCRandom(-135, 180), 'Monster', IMCRandom(182, 185), FD_FIRETOWER612_T02_MONSTER_AI_RUN_1);
            SetLifeTime(mon[i], 600)
        elseif i > (add_half*3) then
            mon[i] = CREATE_MONSTER_EX(self, 'FD_Glyquare', 1918+IMCRandom(-100, 100), 205, -1562+IMCRandom(-100, 100), IMCRandom(-135, 180), 'Monster', IMCRandom(182, 185), FD_FIRETOWER612_T02_MONSTER_AI_RUN_1);
            SetLifeTime(mon[i], 600)
        end
    end
end

function SCR_BUFF_UPDATE_FD_FIRETOWER612_GEN_SOUTH(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetBuffOver(self, 'FD_FIRETOWER612_GEN_SOUTH') >= 5 then
        return 0
    else
        if self.NumArg4 < 60 then
            self.NumArg4 = self.NumArg4 + 1
        else
            AddBuff(self, self, 'FD_FIRETOWER612_GEN_SOUTH', 1, 0, 0, 1)
            self.NumArg4 = 0
        end
    end 
    return 1
end

function SCR_BUFF_LEAVE_FD_FIRETOWER612_GEN_SOUTH(self, buff, arg1, arg2, over)

end



--FD_UNDERF591_TYPED_LAMP_BUFF
function SCR_BUFF_ENTER_FD_UNDERF591_TYPED_LAMP_BUFF(self, buff, arg1, arg2, over)
    SetFixAnim(self, 'ON')
end

function SCR_BUFF_UPDATE_FD_UNDERF591_TYPED_LAMP_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local mon_list = {
                    'FD_woodgoblin_black',
                    'FD_Bushspider_purple',
                    'FD_pappus_kepa_purple'
                    }
    local i
    local x = 1
    local y = 2
    local z = 3
    local mon = {}
    local list = GetCellCoord(self, 'cardinal_far', 0)
    local zoneID = GetZoneInstID(self)
    local mon_add = {}
    local mon_addp = {}
    for i = 1, 4 do
        if IsValidPos(zoneID, list[x], list[y], list[z]) == 'YES' then
            mon[i] = CREATE_MONSTER_EX(self, mon_list[IMCRandom(1,3)], list[x], list[y], list[z], 0, 'Monster', 0, FD_UNDERF591_TYPED_LAMP_BUFF_RUN);
            if mon[i] ~= nil then
                SetLifeTime(mon[i], 120, 1)
                if mon[i] ~= nil then
                    if IsBuffApplied(self, 'FD_UNDERF591_TYPED_LAMP_BUFF') == 'YES' then
--                        if GetBuffOver(self, 'FD_UNDERF591_TYPED_LAMP_BUFF') == 2 then
                        if arg1 == 2 then
                            mon_add[i] = CREATE_MONSTER_EX(self, mon_list[IMCRandom(1,3)], list[x]+10, list[y], list[z]+10, 0, 'Monster', 0, FD_UNDERF591_TYPED_LAMP_BUFF_RUN);
                            if mon_add[i] ~= nil then
                                SetLifeTime(mon_add[i], 120, 1)
                            end
--                        elseif GetBuffOver(self, 'FD_UNDERF591_TYPED_LAMP_BUFF') == 3 then
                        elseif arg1 == 3 then
                            mon_add[i] = CREATE_MONSTER_EX(self, mon_list[IMCRandom(1,3)], list[x]+10, list[y], list[z]+10, 0, 'Monster', 0, FD_UNDERF591_TYPED_LAMP_BUFF_RUN);
                            if mon_add[i] ~= nil then
                                SetLifeTime(mon_add[i], 120, 1)
                                mon_addp[i] = CREATE_MONSTER_EX(self, mon_list[IMCRandom(1,3)], list[x]-10, list[y], list[z]-10, 0, 'Monster', 0, FD_UNDERF591_TYPED_LAMP_BUFF_RUN);
                                SetLifeTime(mon_addp[i], 120, 1)
                            end
                        end
                    end
                end
            end
        end
--        print(IsValidPos(zoneID, list[x], list[y], list[z]))
        x = x + 3
        y = y + 3
        z = z + 3
    end
    
    return 1
end

function SCR_BUFF_LEAVE_FD_UNDERF591_TYPED_LAMP_BUFF(self, buff, arg1, arg2, over)
    SetFixAnim(self, 'OFF')
    DetachEffect(self,'F_fire007')
end

function FD_UNDERF591_TYPED_LAMP_BUFF_RUN(mon)
    mon.SimpleAI = 'FD_UNDERF591_TYPED_LAMP_BUFF'
    mon.BTree = 'None'
end

--UNDERFORTRESS_66_MQ060
function SCR_BUFF_ENTER_UNDER66_MQ6_DEBUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_UNDER66_MQ6_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    self.DEF_BM = self.DEF_BM - 50;
    --print(self.DEF_BM)
end

function SCR_BUFF_LEAVE_UNDER66_MQ6_DEBUFF(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM + 50;
    --print(self.DEF_BM)
end

--FLASH_58_SQ_010
function SCR_BUFF_ENTER_FLASH_58_COLLECTOR_DEBUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_light013_spark', 3, 'MID');
end

function SCR_BUFF_UPDATE_FLASH_58_COLLECTOR_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, 'F_smoke124_blue2', 0.5, 'BOT')
    AddStamina(self, -300)
    return 1
end

function SCR_BUFF_LEAVE_FLASH_58_COLLECTOR_DEBUFF(self, buff, arg1, arg2, over)
    AddStamina(self, 25000)
    RemoveEffect(self, 'F_smoke124_blue2', 1)
end

--FLASH_58_SQ_SVTRIGAILA
function SCR_BUFF_ENTER_FLASH_58_SQ_SVTRIGAILA(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_light013_spark_blue_2', 3, 'MID')
end

function SCR_BUFF_LEAVE_FLASH_58_SQ_SVTRIGAILA(self, buff, arg1, arg2, over)
    --RemoveEffect(self, 'F_light028_violet1', 1)
end

--HIDDEN_EVENT_MONSTER_DEBUFF01
function SCR_BUFF_ENTER_HIDDEN_EVENT_MONSTER_DEBUFF01(self, buff, arg1, arg2, over)
    local dam  = math.floor(self.MHP / 10)
    TakeDamage(self, self, "None", dam, "Poison", "None", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW)
    self.DEF_BM = self.DEF_BM - 20;
    self.MDEF_BM = self.MDEF_BM - 20;
--    print(self.DEF_BM)
end

function SCR_BUFF_LEAVE_HIDDEN_EVENT_MONSTER_DEBUFF01(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM + 20;
    self.MDEF_BM = self.MDEF_BM + 20;
--    print(self.DEF_BM)
end


--HIDDEN_EVENT_PC_BUFF01
function SCR_BUFF_ENTER_HIDDEN_EVENT_PC_BUFF01(self, buff, arg1, arg2, over)
    
    self.DEF_BM = self.DEF_BM + 30;
    self.MDEF_BM = self.MDEF_BM + 30;
    self.PATK_BM = self.PATK_BM + 30;
    self.MATK_BM = self.MATK_BM + 30;
    
--    SetExProp(buff, "ADD_PATK", 30)
--    print(self.DEF_BM)
end

function SCR_BUFF_LEAVE_HIDDEN_EVENT_PC_BUFF01(self, buff, arg1, arg2, over)
--    local patkadd = GetExProp(buff, "ADD_PATK")
    
    self.DEF_BM = self.DEF_BM - 30;
    self.MDEF_BM = self.MDEF_BM - 30
    self.PATK_BM = self.PATK_BM - 30;
    self.MATK_BM = self.MATK_BM - 30;
    
--    print(self.DEF_BM)
end

--HIHIDDEN_EVENT_MONSTER_DEBUFF02
function SCR_BUFF_ENTER_HIDDEN_EVENT_MONSTER_DEBUFF02(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_HIDDEN_EVENT_MONSTER_DEBUFF02(self, buff, arg1, arg2, RemainTime, ret, over)
    local dam  = math.floor(self.MHP / 10)
    TakeDamage(self, self, "None", dam, "Poison", "None", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW)
    return 1;
end

function SCR_BUFF_LEAVE_HIDDEN_EVENT_MONSTER_DEBUFF02(self, buff, arg1, arg2, over)
end

--HIHIDDEN_EVENT_PC_BUFF04
function SCR_BUFF_ENTER_HIDDEN_EVENT_PC_BUFF04(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM + 10;
    self.MDEF_BM = self.MDEF_BM + 10;
--    print(self.DEF_BM)
end

function SCR_BUFF_UPDATE_HIDDEN_EVENT_PC_BUFF04(self, buff, arg1, arg2, RemainTime, ret, over)
    local healHp = 10
    AddHP(self, healHp)
    return 1;
end

function SCR_BUFF_LEAVE_HIDDEN_EVENT_PC_BUFF04(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM - 10;
    self.MDEF_BM = self.MDEF_BM - 10;
--    print(self.DEF_BM)
end

--HIDDEN_EVENT_PC_BUFF02
function SCR_BUFF_ENTER_HIDDEN_EVENT_PC_BUFF02(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_HIDDEN_EVENT_PC_BUFF02(self, buff, arg1, arg2, RemainTime, ret, over)
    local healHp = 25
    AddHP(self, healHp)
    return 1;
end

function SCR_BUFF_LEAVE_HIDDEN_EVENT_PC_BUFF02(self, buff, arg1, arg2, over)
end

--HIDDEN_EVENT_PC_BUFF03
function SCR_BUFF_ENTER_HIDDEN_EVENT_PC_BUFF03(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM - 15;
    self.MDEF_BM = self.MDEF_BM - 15;
    self.PATK_BM = self.PATK_BM + 45;
    self.MATK_BM = self.MATK_BM + 45;
--    print(self.DEF_BM)
end

function SCR_BUFF_LEAVE_HIDDEN_EVENT_PC_BUFF03(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM + 15;
    self.MDEF_BM = self.MDEF_BM + 15;
    self.PATK_BM = self.PATK_BM - 45;
    self.MATK_BM = self.MATK_BM - 45;
--    print(self.DEF_BM)
end

--HIDDEN_EVENT_PC_BUFF05
function SCR_BUFF_ENTER_HIDDEN_EVENT_PC_BUFF05(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM + 70;
    self.MDEF_BM = self.MDEF_BM + 70;
--    print(self.DEF_BM)
end

function SCR_BUFF_LEAVE_HIDDEN_EVENT_PC_BUFF05(self, buff, arg1, arg2, over)
    self.DEF_BM = self.DEF_BM - 70;
    self.MDEF_BM = self.MDEF_BM - 70;
end




--FLASH64_SQ_07_BORNFIRE
function SCR_BUFF_ENTER_FLASH64_SQ_07_BORNFIRE(self, buff, arg1, arg2, over)
    PlayAnim(self, 'ON', 1)
end

function SCR_BUFF_LEAVE_FLASH64_SQ_07_BORNFIRE(self, buff, arg1, arg2, over)
    PlayAnim(self, 'STD', 1)
    DetachEffect(self, 'F_fire021')
end

--PILGRIM51_SQ_ATK_UP
function SCR_BUFF_ENTER_PILGRIM51_SQ_ATK_UP(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM + 30;
    self.MATK_BM = self.MATK_BM + 30;
end

function SCR_BUFF_LEAVE_PILGRIM51_SQ_ATK_UP(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM - 30;
    self.MATK_BM = self.MATK_BM - 30;

end







--M_CHAPEL_STR
function SCR_BUFF_ENTER_M_CHAPEL_STR(self, buff, arg1, arg2, over)
    local add = 20
    self.STR_BM = self.STR_BM + add
    SetExProp(buff, "M_CHAPEL_STR", add)
    InvalidateStates(self)
end

function SCR_BUFF_LEAVE_M_CHAPEL_STR(self, buff, arg1, arg2, over)
    local add = GetExProp(buff, "M_CHAPEL_STR")
    self.STR_BM = self.STR_BM - add
    InvalidateStates(self)
end


--M_CHAPEL_CON
function SCR_BUFF_ENTER_M_CHAPEL_CON(self, buff, arg1, arg2, over)
    local add = 30
    self.CON_BM = self.CON_BM + add
    SetExProp(buff, "M_CHAPEL_CON", add)
    InvalidateStates(self)
end

function SCR_BUFF_LEAVE_M_CHAPEL_CON(self, buff, arg1, arg2, over)
    local add = GetExProp(buff, "M_CHAPEL_CON")
    self.CON_BM = self.CON_BM - add
    InvalidateStates(self)
end

--M_CHAPEL_INT
function SCR_BUFF_ENTER_M_CHAPEL_INT(self, buff, arg1, arg2, over)
    local add = 20
    self.INT_BM = self.INT_BM + add
    SetExProp(buff, "M_CHAPEL_INT", add)
    InvalidateStates(self)
end

function SCR_BUFF_LEAVE_M_CHAPEL_INT(self, buff, arg1, arg2, over)
    local add = GetExProp(buff, "M_CHAPEL_INT")
    self.INT_BM = self.INT_BM - add
    InvalidateStates(self)
end

--M_CHAPEL_AGL
function SCR_BUFF_ENTER_M_CHAPEL_AGL(self, buff, arg1, arg2, over)
    local add = 20
    self.DEX_BM = self.DEX_BM + add
    SetExProp(buff, "M_CHAPEL_AGL", add)
    InvalidateStates(self)
end

function SCR_BUFF_LEAVE_M_CHAPEL_AGL(self, buff, arg1, arg2, over)
    local add = GetExProp(buff, "M_CHAPEL_AGL")
    self.DEX_BM = self.DEX_BM - add
    InvalidateStates(self)
end

--UNDER67_MAGIC_DEVICE_DEBUFF
function SCR_BUFF_ENTER_UNDER67_MAGIC_DEVICE_DEBUFF(self, buff, arg1, arg2, over)
    local mspdadd = self.MSPD * 0.7
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
end

function SCR_BUFF_LEAVE_UNDER67_MAGIC_DEVICE_DEBUFF(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;
end



--UNDERF592_TYPEC_DEFENCE
function SCR_BUFF_ENTER_UNDERF592_TYPEC_DEFENCE(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_UNDERF592_TYPEC_DEFENCE(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'd_underfortress_59_2' then
        if GetLayer(self) == 0 then
            local healsp = math.floor(self.MSP / 130)
            HealSP(self, healsp, 0);
            return 1
        else
            return 0
        end
    end
    return 0
end

function SCR_BUFF_LEAVE_UNDERF592_TYPEC_DEFENCE(self, buff, arg1, arg2, over)
end



--UNDERF593_TYPEF_DEFENCE
function SCR_BUFF_ENTER_UNDERF593_TYPEF_DEFENCE(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_UNDERF593_TYPEF_DEFENCE(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'd_underfortress_59_3' then
        if GetLayer(self) == 0 then
            local healsp = math.floor(self.MSP / 130)
            HealSP(self, healsp, 0);
            return 1
        else
            return 0
        end
    end
    return 0
end

function SCR_BUFF_LEAVE_UNDERF593_TYPEF_DEFENCE(self, buff, arg1, arg2, over)
end



--PILGRIM311_SQ_02_ITEM
function SCR_BUFF_ENTER_PILGRIM311_SQ_02_ITEM(self, buff, arg1, arg2, over)
    local _pc = GetBuffCaster(buff)
    if _pc ~= nil then
        local mon_ssn = GetSessionObject(self, 'SSN_PILGRIM311_SQ_02_MON')
        if mon_ssn == nil then
            CreateSessionObject(self, 'SSN_PILGRIM311_SQ_02_MON')
        end
        local pc_list = GetScpObjectList(self, 'PILGRIM311_SQ_02_ITEM')
        local i
        for i = 1, #pc_list do
            if IsSameActor(pc_list[i], _pc) == 'YES' then
                return
            end
        end
        AddScpObjectList(self, 'PILGRIM311_SQ_02_ITEM', _pc)
    end
end

function SCR_BUFF_LEAVE_PILGRIM311_SQ_02_ITEM(self, buff, arg1, arg2, over)
    local mon_ssn = GetSessionObject(self, 'SSN_PILGRIM311_SQ_02_MON')
    if mon_ssn ~= nil then
        DestroySessionObject(self, mon_ssn)
    end
--    local _pc = GetBuffCaster(buff)
--    if _pc ~= nil then
--        if IsSameActor(_pc, GetKiller(self)) == 'YES' then
--            SCR_PARTY_QUESTPROP_ADD(_pc, 'SSN_PILGRIM311_SQ_02', 'QuestInfoValue1', 1)
--            return
--        end
--    end
--    
--    if GetKiller(self) ~= nil then
--        local list, cnt =  GET_PARTY_ACTOR(GetKiller(self), 300)
--        local i
--        for i = 1, cnt do
--            
--        end
--    end
    

end

--UNDER65_DEBUFF
function SCR_BUFF_ENTER_UNDER65_DEBUFF(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_stun', 0)
    SetCurrentFaction(self, "Neutral");
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_LEAVE_UNDER65_DEBUFF(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_stun')
end

--UNDER_68_MQ030
function SCR_BUFF_ENTER_UNDER_68_MQ030(self, buff, arg1, arg2, over)
    SetExProp(buff, "UNDER_68_MQ030", self.MSPD);
end

function SCR_BUFF_UPDATE_UNDER_68_MQ030(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, cnt = SelectObjectByClassName(self, 100, 'npc_orb1_Q')
--    local list, cnt = SelectObject(self, 100, 'All')
    local i
    if cnt ~= 0 then
        for i = 1, cnt do
            local pc_mon = GetScpObjectList(self, 'UNDER_68_MQ030')
            if #pc_mon ~= 0 then
                if IsBuffApplied(self, 'UNDER_68_MQ030') == 'YES' then
                    SCR_PARTY_QUESTPROP_ADD(pc_mon[1], 'SSN_UNDERFORTRESS_68_MQ030', 'QuestInfoValue1', IMCRandom(5,10))
                    local skill = GetNormalSkill(self);
                    ForceDamage(self, skill, list[i], self, 0, 'HIT_REFLECT', 'HITRESULT_BLOW', 'I_force023_fire', 1, 'arrow_cast', nil, 1, 'arrow_blow', 'SLOW', 40, 1, 0, 0, 0, 1, 1)
                end
            end
        end
    end
end

function SCR_BUFF_LEAVE_UNDER_68_MQ030(self, buff, arg1, arg2, over)
    self.MSPD = GetExProp(buff, "UNDER_68_MQ030")
end

--UNDER_68_MQ030_01
function SCR_BUFF_ENTER_UNDER_68_MQ030_01(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_UNDER_68_MQ030_01(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, cnt = SelectObjectByClassName(self, 100, 'bones')
    local i
    if cnt ~= 0 then
        return 1;
    else
        RemoveBuff(self, 'UNDER_68_MQ030_01')
    end
end

function SCR_BUFF_LEAVE_UNDER_68_MQ030_01(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_ground017_loop')
end

--PILGRIM312_SQ_04_BUFF
function SCR_BUFF_ENTER_PILGRIM312_SQ_04_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_cleric_bakarine_loop', 1.5, 'MID')
    AddBuff(self, self, 'HPLock', 1, 0, 0, 1)
end

function SCR_BUFF_UPDATE_PILGRIM312_SQ_04_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetHpPercent(self) < 0.2 then
        if self.NumArg1 == 0 then
            self.NumArg1 = 1553
            SetBuffRemainTime(self, 'PILGRIM312_SQ_04_BUFF', 0)
            local _pc = GetBuffCaster(buff)
            if _pc ~= nil then
                ObjectColorBlend(self, 15, 15, 15, 255, 1, 3)
                SCR_PARTY_QUESTPROP_ADD(_pc, 'SSN_PILGRIM312_SQ_04', 'QuestInfoValue1', 1)
                SCR_SENDMSG_CNT(_pc, 'SSN_PILGRIM312_SQ_04', 'scroll', 'PILGRIM312_SQ_04_01_B01', 1, 2)
                AttachEffect(self, 'F_pattern007_dark_loop', 2)
                SetCurrentFaction(self, 'Peaceful')
                ClearBTree(self)
                SetLifeTime(self, 10, 1)
            end
        end
        return 1
    end

    return 1;
end

function SCR_BUFF_LEAVE_PILGRIM312_SQ_04_BUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_cleric_bakarine_loop')
    RemoveBuff(self, 'HPLock')
end

--PILGRIM_36_2_FIRELORD_HP
function SCR_BUFF_ENTER_PILGRIM_36_2_FIRELORD_HP(self, buff, arg1, arg2, over)
    local mhpadd = self.MHP / 10;
    self.MHP_BM = self.MHP_BM - mhpadd;
    SetExProp(buff, "ADD_MHP", mhpadd);
end

function SCR_BUFF_LEAVE_PILGRIM_36_2_FIRELORD_HP(self, buff, arg1, arg2, over)
    --RemoveEffect(self, 'F_light028_violet1', 1)
    local mhpadd = GetExProp(buff, "ADD_MHP");
    self.MHP_BM = self.MHP_BM + mhpadd;
end

--PILGRIM_48_SQ_030_BEGINNER
function SCR_BUFF_ENTER_PILGRIM_48_SQ_030_BEGINNER(self, buff, arg1, arg2, over)
--    local patkadd = math.floor(self.MAXPATK * 0.3);
--    local matkadd = math.floor(self.MAXMATK * 0.3);
--
--    self.PATK_BM = self.PATK_BM + patkadd;
--    self.MATK_BM = self.MATK_BM + matkadd;
--  AttachEffect(self, 'F_circle002', 1.0, "TOP")
--
--    SetExProp(buff, "ADD_PATK", patkadd);
--    SetExProp(buff, "ADD_MATK", matkadd);

    self.PATK_BM = self.PATK_BM + 7;
    self.MATK_BM = self.MATK_BM + 7;



end

function SCR_BUFF_LEAVE_PILGRIM_48_SQ_030_BEGINNER(self, buff, arg1, arg2, over)
--    local patkadd = GetExProp(buff, "ADD_PATK");
--    local matkadd = GetExProp(buff, "ADD_MATK");
--
--    self.PATK_BM = self.PATK_BM - patkadd;
--    self.MATK_BM = self.MATK_BM - matkadd;    
--  DetachEffect(self, 'F_circle002')

    self.PATK_BM = self.PATK_BM - 7;
    self.MATK_BM = self.MATK_BM - 7;

end


--TWO_HOUR_TIME_01
function SCR_BUFF_ENTER_TWO_HOUR_TIME_01(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_TWO_HOUR_TIME_01(self, buff, arg1, arg2, over)
end

--ORCHARD342_STUN
function SCR_BUFF_ENTER_ORCHARD342_STUN(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_ORCHARD342_STUN(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff)
    InsertHate(self, caster, 9999)
end

--ORCHARD342_TRANSFORM_BUFF
function SCR_BUFF_ENTER_ORCHARD342_TRANSFORM_BUFF(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Peaceful')
end

function SCR_BUFF_UPDATE_ORCHARD342_TRANSFORM_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    AddStamina(self, 99999)
    if GetLayer(self) ~= 0 then
        return 0
    end
    local result = SCR_QUEST_CHECK(self, 'ORCHARD_342_SQ_02')
    if result ~= 'PROGRESS' then
        return 0
    end
    if GetZoneName(self) ~= 'f_orchard_34_2' then
        return 0
    end
   
    return 1
end

function SCR_BUFF_LEAVE_ORCHARD342_TRANSFORM_BUFF(self, buff, arg1, arg2, over)
    local list, cnt = SelectObject(self, 200, 'ALL')
    local i
    PlayEffect(self, 'F_smoke037', 0.5, 'MID')
    PlayAnim(self, 'ASTD', 1)
    SetCurrentFaction(self, 'Law')
    TransformToMonster(self, "None", "None")
    for i = 1, cnt do
        if list[i].ClassName == 'ferret_folk' or list[i].ClassName == 'ferret_loader' then
            InsertHate(list[i], self, 9999)
        end
    end
end

--ORCHARD342_WOOD_BUFF
function SCR_BUFF_ENTER_ORCHARD342_WOOD_BUFF(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_buff_basic004_red', 1)
end

function SCR_BUFF_LEAVE_ORCHARD342_WOOD_BUFF(self, buff, arg1, arg2, over)
end

--JOB_2_CLERIC_CURED
function SCR_BUFF_ENTER_JOB_2_CLERIC_CURED(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_JOB_2_CLERIC_CURED(self, buff, arg1, arg2, over)
end

--JOB_2_SADHU_SOUL
function SCR_BUFF_ENTER_JOB_2_SADHU_SOUL(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_smoke009_green', 1, 'BOT')
end

function SCR_BUFF_LEAVE_JOB_2_SADHU_SOUL(self, buff, arg1, arg2, over)
    DetachEffect(self, 'I_smoke009_green')
    local _pc = GetBuffCaster(buff)
    if _pc ~= nil then
        local quest_ssn = GetSessionObject(_pc, 'SSN_JOB_2_SADHU4')
        quest_ssn.Step1 = 0
    end
end

--JOB_2_BARABARIAN_ACID
function SCR_BUFF_ENTER_JOB_2_BARBARIAN_ACID(self, buff, arg1, arg2, over)
--    AttachEffect(self, 'F_levitation036_smoke_dark_green', 0.2, 'MID')
    SetExProp(buff, 'BARBARIAN_ACID_ATK', self.Lv);
    self.PATK_BM = self.PATK_BM - self.Lv;
end

function SCR_BUFF_LEAVE_JOB_2_BARBARIAN_ACID(self, buff, arg1, arg2, over)
--    DetachEffect(self, 'F_levitation036_smoke_dark_green')
    local addAtk = GetExProp(buff, 'BARBARIAN_ACID_ATK');
    self.PATK_BM = self.PATK_BM + addAtk;
end

--FD_CASTLE671_DARK_BUFF
function SCR_BUFF_ENTER_FD_CASTLE671_DARK_BUFF(self, buff, arg1, arg2, over)
    local patkadd = math.floor(self.MAXPATK * 0.1)
    local matkadd = math.floor(self.MAXMATK * 0.1)
    self.PATK_BM = self.PATK_BM + patkadd
    self.MATK_BM = self.MATK_BM + matkadd
    SetExProp(buff, "ADD_PATK", patkadd)
    SetExProp(buff, "ADD_MATK", matkadd)
    PlayEffect(self, 'F_buff_basic004_red', 1)
end

function SCR_BUFF_LEAVE_FD_CASTLE671_DARK_BUFF(self, buff, arg1, arg2, over)
    local patkadd = GetExProp(buff, "ADD_PATK")
    local matkadd = GetExProp(buff, "ADD_MATK")
    self.PATK_BM = self.PATK_BM - patkadd
    self.MATK_BM = self.MATK_BM - matkadd
    AddBuff(self, self, 'FD_CASTLE671_DARK_BUFF_R', 1, 0, 1800000, 1)
end

--FD_CASTLE671_DARK_BUFF_R
function SCR_BUFF_ENTER_FD_CASTLE671_DARK_BUFF_R(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_FD_CASTLE671_DARK_BUFF_R(self, buff, arg1, arg2, over)
end

--FD_CASTLE671_STATUE_BUFF
function SCR_BUFF_ENTER_FD_CASTLE671_STATUE_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_ground017_loop', 1, 'BOT')
end

function SCR_BUFF_LEAVE_FD_CASTLE671_STATUE_BUFF(self, buff, arg1, arg2, over)
    ClearEffect(self)
end

--FD_CASTLE671_CONTROL_BUFF
function SCR_BUFF_ENTER_FD_CASTLE671_CONTROL_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_FD_CASTLE671_CONTROL_BUFF(self, buff, arg1, arg2, over)
end

--FD_CASTLE671_BOOK_BUFF
function SCR_BUFF_ENTER_FD_CASTLE671_BOOK_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_FD_CASTLE671_BOOK_BUFF(self, buff, arg1, arg2, over)
end

--FD_CASTLE671_DOLL_BUFF
function SCR_BUFF_ENTER_FD_CASTLE671_DOLL_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_sphere009_violet', 1)
    local defadd = math.floor(self.DEF * 0.5)
    local mdefadd = math.floor(self.MDEF * 0.5)
    self.DEF_BM = self.DEF_BM - defadd
    self.MDEF_BM = self.MDEF_BM - mdefadd
    SetExProp(buff, "ADD_DEF", defadd)
    SetExProp(buff, "ADD_MDEF", mdefadd)
end

function SCR_BUFF_LEAVE_FD_CASTLE671_DOLL_BUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'I_sphere009_violet')
    local defadd = GetExProp(buff, "ADD_DEF")
    local mdefadd = GetExProp(buff, "ADD_MDEF")
    self.DEF_BM = self.DEF_BM + defadd
    self.MDEF_BM = self.MDEF_BM + mdefadd
end




--SIAU15RE_SQ_03_ITEM_01
function SCR_BUFF_ENTER_SIAU15RE_SQ_03_ITEM_01(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'FreeForAll')
    ObjectColorBlend(self, 255, 100, 100, 255, 1, 2, 0, 1)
    local list, cnt = SelectObjectByFaction(self, 200, 'Monster')
    if cnt ~= 0 then
        AddScpObjectList(list[1], 'SIAU15RE_SQ_03_ITEM_01', self)
        InsertHate(self, list[1], 99999)
        return
    end
    
end

function SCR_BUFF_UPDATE_SIAU15RE_SQ_03_ITEM_01(self, buff, arg1, arg2, RemainTime, ret, over)
    local mon_list = GetScpObjectList(self, 'SIAU15RE_SQ_03_ITEM_01')
    if #mon_list == 0 then
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            if GetDistance(self, caster) <= 200 then
                InsertHate(self, caster, 1)
            else
                return 0
            end
        else
            return 0
        end
    else
        InsertHate(self, mon_list[1], 99999)
    end
    return 1
end

function SCR_BUFF_LEAVE_SIAU15RE_SQ_03_ITEM_01(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Monster')
    ObjectColorBlend(self, 255, 255, 255, 255, 1, 5, 0, 1)
end


--FD_CASTLE672_SOUL_RED
function SCR_BUFF_ENTER_FD_CASTLE672_SOUL_RED(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_buff_basic023_red_fire', 1)
end

function SCR_BUFF_UPDATE_FD_CASTLE672_SOUL_RED(self, buff, arg1, arg2, RemainTime, ret, over)
    local heal = self.MHP / 100
    if heal < 5 then
        heal = 5
    end
    Heal(self, heal, 0)
    return 1
end

function SCR_BUFF_LEAVE_FD_CASTLE672_SOUL_RED(self, buff, arg1, arg2, over)
end

--FD_CASTLE672_SOUL_BLUE
function SCR_BUFF_ENTER_FD_CASTLE672_SOUL_BLUE(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_buff_basic018_blue_fire', 1)
end

function SCR_BUFF_UPDATE_FD_CASTLE672_SOUL_BLUE(self, buff, arg1, arg2, RemainTime, ret, over)
    local healsp = self.MSP / 100
    if healsp < 3 then
        healsp = 3
    end
    HealSP(self, healsp, 0)
    return 1
end

function SCR_BUFF_LEAVE_FD_CASTLE672_SOUL_BLUE(self, buff, arg1, arg2, over)
end

--FD_CASTLE672_SOUL_YELLOW
function SCR_BUFF_ENTER_FD_CASTLE672_SOUL_YELLOW(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_buff_basic021_yellow_fire', 1)
end

function SCR_BUFF_UPDATE_FD_CASTLE672_SOUL_YELLOW(self, buff, arg1, arg2, RemainTime, ret, over)
    local sta = self.MaxSta/100
    if sta < 2 then
        sta = 2
    end
    AddStamina(self, sta)
    return 1
end

function SCR_BUFF_LEAVE_FD_CASTLE672_SOUL_YELLOW(self, buff, arg1, arg2, over)
end

--FD_CASTLE672_SOUL_ALL
function SCR_BUFF_ENTER_FD_CASTLE672_SOUL_ALL(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_buff_basic034_pink', 1)
end

function SCR_BUFF_UPDATE_FD_CASTLE672_SOUL_ALL(self, buff, arg1, arg2, RemainTime, ret, over)
    local heal = self.MHP / 100
    if heal < 5 then
        heal = 5
    end
    local healsp = self.MSP / 100
    if healsp < 3 then
        healsp = 3
    end
    local sta = self.MaxSta/100
    if sta < 2 then
        sta = 2
    end
    Heal(self, heal, 0)
    HealSP(self, healsp, 0)
    AddStamina(self, sta)
    return 1
end

function SCR_BUFF_LEAVE_FD_CASTLE672_SOUL_ALL(self, buff, arg1, arg2, over)
end

--FD_CASTLE672_SOUL_CONTROL
function SCR_BUFF_ENTER_FD_CASTLE672_SOUL_CONTROL(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_FD_CASTLE672_SOUL_CONTROL(self, buff, arg1, arg2, over)
end

--FD_CASTLE672_SOUL_BUFF
function SCR_BUFF_ENTER_FD_CASTLE672_SOUL_BUFF(self, buff, arg1, arg2, over)
    ShowBalloonText(self, 'FD_CASTLE672_SOUL_DLG', 3)
end

function SCR_BUFF_UPDATE_FD_CASTLE672_SOUL_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff)
    if caster == nil then
        return 0
    end
    return 1
end

function SCR_BUFF_LEAVE_FD_CASTLE672_SOUL_BUFF(self, buff, arg1, arg2, over)
end

--FD_CASTLE672_SOUL_STACK_CD
function SCR_BUFF_ENTER_FD_CASTLE672_SOUL_STACK_CD(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_FD_CASTLE672_SOUL_STACK_CD(self, buff, arg1, arg2, over)
end

--FD_CASTLE672_RED_GHOST
function SCR_BUFF_ENTER_FD_CASTLE672_RED_GHOST(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_FD_CASTLE672_RED_GHOST(self, buff, arg1, arg2, over)
end

--FD_CASTLE672_BLUE_GHOST
function SCR_BUFF_ENTER_FD_CASTLE672_BLUE_GHOST(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_FD_CASTLE672_BLUE_GHOST(self, buff, arg1, arg2, over)
end

--FD_CASTLE672_GHOST_COUNT
function SCR_BUFF_ENTER_FD_CASTLE672_GHOST_COUNT(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_FD_CASTLE672_GHOST_COUNT(self, buff, arg1, arg2, over)
end

--BRACKEN633_MQ4_BUFF
function SCR_BUFF_ENTER_BRACKEN633_MQ4_BUFF(self, buff, arg1, arg2, over)
    SetRenderOption(self, "Freeze", 1);
end

function SCR_BUFF_UPDATE_BRACKEN633_MQ4_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, 'F_explosion080_ice', 0.2, "MID")
    TakeDamage(self, self, "None", 10, "Ice", "None", "Magic", HIT_FIRE, HITRESULT_BLOW);
    return 1;
end

function SCR_BUFF_LEAVE_BRACKEN633_MQ4_BUFF(self, buff, arg1, arg2, over)
    SetRenderOption(self, "Freeze", 0);
end

--FD_CASTLE672_WARP_BUFF
function SCR_BUFF_ENTER_FD_CASTLE672_WARP_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_ground131_loop', 2, 'BOT')
end

function SCR_BUFF_LEAVE_FD_CASTLE672_WARP_BUFF(self, buff, arg1, arg2, over)
    AddBuff(self, self, 'FD_CASTLE672_WARP_BUFF_CD', 1, 0, 300000, 1)
end

--FD_CASTLE672_WARP_BUFF_CD
function SCR_BUFF_ENTER_FD_CASTLE672_WARP_BUFF_CD(self, buff, arg1, arg2, over)
    ClearEffect(self)
end

function SCR_BUFF_LEAVE_FD_CASTLE672_WARP_BUFF_CD(self, buff, arg1, arg2, over)
end

--FD_CASTLE672_WARP_ACCEPT
function SCR_BUFF_ENTER_FD_CASTLE672_WARP_ACCEPT(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_light006_blue', 2, 'TOP')
end

function SCR_BUFF_LEAVE_FD_CASTLE672_WARP_ACCEPT(self, buff, arg1, arg2, over)
    DetachEffect(self, 'I_light006_blue')
end

--FD_CASTLE672_BOX_REWARD
function SCR_BUFF_ENTER_FD_CASTLE672_BOX_REWARD(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_FD_CASTLE672_BOX_REWARD(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'd_castle_67_2' then
        return 1
    else
        return 0
    end
end

function SCR_BUFF_LEAVE_FD_CASTLE672_BOX_REWARD(self, buff, arg1, arg2, over)
end

--FD_CASTLE672_BOX_ALREADY
function SCR_BUFF_ENTER_FD_CASTLE672_BOX_ALREADY(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_FD_CASTLE672_BOX_ALREADY(self, buff, arg1, arg2, over)
end




--PRISON622_SQ_02_ITEM
function SCR_BUFF_ENTER_PRISON622_SQ_02_ITEM(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_light004_blue', 5, 'MID')
    if GetBuffCaster(buff) ~= nil then
    local list, cnt = SelectObjectByFaction(self, 200, 'Monster')
        if cnt >= 2 then
            local i
            local _pc = GetScpObjectList(GetBuffCaster(buff), 'PRISON622_SQ_02_ITEM')
            for i = 1 , cnt do
                if i < 3 then
                    if #_pc ~= 0 then
--                        SetOwner(list[i], self)
                        InsertHate(list[i], _pc[1], 1)
                    end
                else
                    break
                end
            end
        else
            local mon_cnt = 2 - cnt
            if mon_cnt == 0 then
                mon_cnt = 2
            end
            local mon_list = {
                            'Sec_goblin_archer_blue',
                            'Goblin_Spear_blue'                            
                            }
            local _list, _cnt = CREATE_MONSTER_CELL(self, mon_list[IMCRandom(1, 2)], pc, 'Siege1', mon_cnt, 20, 'Monster', PRISON622_SQ_02_ITEM_MON)
            if _cnt ~= nil then
                local i
                local _pc = GetScpObjectList(GetBuffCaster(buff), 'PRISON622_SQ_02_ITEM')
                if #_pc ~= nil then
                    for i = 1, _cnt do 
    --                    SetOwner(_list[i], self)
                        InsertHate(_list[i], _pc[1], 1)
                        SetLifeTime(_list[i], 120)
                        
                    end
                end
            end
        end
    end
end

function SCR_BUFF_LEAVE_PRISON622_SQ_02_ITEM(self, buff, arg1, arg2, over)
    DetachEffect(self, 'I_light004_blue')
end


function PRISON622_SQ_02_ITEM_MON(mon)
    mon.Lv = mon.Level
end

--FD_CASTLE671_VINE_PROTECT
function SCR_BUFF_ENTER_FD_CASTLE671_VINE_PROTECT(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_ground12_red', 3)
end

function SCR_BUFF_LEAVE_FD_CASTLE671_VINE_PROTECT(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_ground12_red')
end

--FD_CASTLE671_BOOK_PROTECT
function SCR_BUFF_ENTER_FD_CASTLE671_BOOK_PROTECT(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_ground12_red', 0.5)
end

function SCR_BUFF_LEAVE_FD_CASTLE671_BOOK_PROTECT(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_ground12_red')
end

--FD_CASTLE672_RED_EXPLOSION
function SCR_BUFF_ENTER_FD_CASTLE672_RED_EXPLOSION(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_levitation005_dark_red', 4)
end

function SCR_BUFF_LEAVE_FD_CASTLE672_RED_EXPLOSION(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_levitation005_dark_red')
end

--FD_CASTLE672_BLUE_EXPLOSION
function SCR_BUFF_ENTER_FD_CASTLE672_BLUE_EXPLOSION(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_levitation005_dark_blue', 4)
end

function SCR_BUFF_LEAVE_FD_CASTLE672_BLUE_EXPLOSION(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_levitation005_dark_blue')
end

--FD_CASTLE672_GHOST_ON
function SCR_BUFF_ENTER_FD_CASTLE672_GHOST_ON(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_FD_CASTLE672_GHOST_ON(self, buff, arg1, arg2, over)
end

--_F_3CMLAKE_83_MQ_04
function SCR_BUFF_ENTER_F_3CMLAKE_83_MQ_04_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_smoke008_red', 2, 'MID')
end

function SCR_BUFF_LEAVE_F_3CMLAKE_83_MQ_04_BUFF(self, buff, arg1, arg2, over)
    ClearEffect(self)
end

--FD_CASTLE672_BOX_BUFF
function SCR_BUFF_ENTER_FD_CASTLE672_BOX_BUFFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_FD_CASTLE672_BOX_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'd_castle_67_2' then
        return 1
    else
        return 0
    end
end 

function SCR_BUFF_LEAVE_FD_CASTLE672_BOX_BUFF(self, buff, arg1, arg2, over)
end

--ABBAY642_SQ2_BUFF
function SCR_BUFF_ENTER_ABBAY642_SQ2_BUFF(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_ABBAY642_SQ2_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'd_abbey_64_2' then
        TakeDamage(self, self, "None", 70, "Poison", "None", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW)
        PlayEffect(self, 'F_explosion009_green2', 0.6, "TOP")
        return 1
    else
        return 0
    end
end 

function SCR_BUFF_LEAVE_ABBAY642_SQ2_BUFF(self, buff, arg1, arg2, over)

end

--ABBAY643_MQ3_BUFF
function SCR_BUFF_ENTER_ABBAY643_MQ3_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, "I_sphere006_mash", 3)
end

function SCR_BUFF_UPDATE_ABBAY643_MQ3_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local Quest = SCR_QUEST_CHECK(self, "ABBAY_64_3_MQ030")
    if Quest == "PROGRESS" then
        if GetZoneName(self) == 'd_abbey_64_3' then
            return 1
        else
            return 0
        end
    else
        return 0
    end
end 

function SCR_BUFF_LEAVE_ABBAY643_MQ3_BUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, "I_sphere006_mash")
end

--UNDERFORTRESS_68_1
function SCR_BUFF_ENTER_UNDERFORTRESS_68_1_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_UNDERFORTRESS_68_1_BUFF(self, buff, arg1, arg2, over)
end

--UNDERFORTRESS_68_2_1
function SCR_BUFF_ENTER_UNDERFORTRESS_68_2_1_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_UNDERFORTRESS_68_2_1_BUFF(self, buff, arg1, arg2, over)
end

--UNDERFORTRESS_68_2_2
function SCR_BUFF_ENTER_UNDERFORTRESS_68_2_2_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_UNDERFORTRESS_68_2_2_BUFF(self, buff, arg1, arg2, over)
end

--ABBEY642_MQ2_BUFF
function SCR_BUFF_ENTER_ABBEY642_MQ2_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_ABBEY642_MQ2_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'd_abbey_64_2' then
        TakeDamage(self, self, "None", 70, "Poison", "None", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW)
        PlayEffect(self, 'F_fire018_purple', 1, "TOP")
        return 1
    else
        return 0
    end
end 

function SCR_BUFF_LEAVE_ABBEY642_MQ2_BUFF(self, buff, arg1, arg2, over)
end

--ABBEY642_MQ4_BUFF1
function SCR_BUFF_ENTER_ABBEY642_MQ4_BUFF1(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_ABBEY642_MQ4_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    local Quest = SCR_QUEST_CHECK(self, "ABBAY_64_2_MQ040")
    if Quest == 'PROGRESS' then
        return 1
    else
        return 0
    end
end 

function SCR_BUFF_LEAVE_ABBEY642_MQ4_BUFF1(self, buff, arg1, arg2, over)
end

--ABBEY642_MQ4_BUFF2
function SCR_BUFF_ENTER_ABBEY642_MQ4_BUFF2(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_ABBEY642_MQ4_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
    local Quest = SCR_QUEST_CHECK(self, "ABBAY_64_2_MQ040")
    if Quest == 'PROGRESS' then
        return 1
    else
        return 0
    end
end 

function SCR_BUFF_LEAVE_ABBEY642_MQ4_BUFF2(self, buff, arg1, arg2, over)
end

--CMINE66_1_MONWEAK
function SCR_BUFF_ENTER_CMINE66_1_MONWEAK(self, buff, arg1, arg2, RemainTime, ret, over)
    self.NumArg1 = self.Lv * 10
    self.DEF_BM = self.DEF_BM - (self.Lv * 10)
    if self.HP >= (self.MHP * 0.7) then
        self.HP = (self.MHP * 0.7)
    end
end

function SCR_BUFF_UPDATE_CMINE66_1_MONWEAK(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, 'I_smoke013_dark', 0.5, 'TOP')
    return 1
end

function SCR_BUFF_LEAVE_CMINE66_1_MONWEAK(self, buff, arg1, arg2, RemainTime, ret, over)
    self.DEF_BM = self.DEF_BM + self.NumArg1
end

--CATACOMB_33_DEADBODY
function SCR_BUFF_ENTER_CATACOMB_33_DEADBODY(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_CATACOMB_33_DEADBODY(self, buff, arg1, arg2, RemainTime, ret, over)
end



--GR_FD_UNDER_1_S9_BOSS
function SCR_BUFF_ENTER_GR_FD_UNDER_1_S9_BOSS(self, buff, arg1, arg2, over)
    SetRenderOption(self, "Stonize", 1);
end

function SCR_BUFF_LEAVE_GR_FD_UNDER_1_S9_BOSS(self, buff, arg1, arg2, over)
    SetRenderOption(self, "Stonize", 0);
end

--GR_KATYN_1_S7_BOX_BUFF
function SCR_BUFF_ENTER_GR_KATYN_1_S7_BOX_BUFF(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_GR_KATYN_1_S7_BOX_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetLayer(self) ~= 0 then
        if GetZoneName(self) == 'f_rokas_24' then
            return 1
        end
    end
    return 0
end

function SCR_BUFF_LEAVE_GR_KATYN_1_S7_BOX_BUFF(self, buff, arg1, arg2, over)

end


--UNDER301_GIMMICK_REWARD_BUFF
function SCR_BUFF_ENTER_UNDER301_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, over)
    local patkadd = math.floor(self.MAXPATK * 0.1);
    local matkadd = math.floor(self.MAXMATK * 0.1);

    self.PATK_BM = self.PATK_BM + patkadd;
    self.MATK_BM = self.MATK_BM + matkadd;
    AttachEffect(self, 'F_circle002', 1.0, "TOP")

    SetExProp(buff, "ADD_PATK", patkadd);
    SetExProp(buff, "ADD_MATK", matkadd);
end

function SCR_BUFF_UPDATE_UNDER301_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == "d_underfortress_30_1" then
        return 1
    else
        return 0
    end
end

function SCR_BUFF_LEAVE_UNDER301_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, over)
    local patkadd = GetExProp(buff, "ADD_PATK");
    local matkadd = GetExProp(buff, "ADD_MATK");

    self.PATK_BM = self.PATK_BM - patkadd;
    self.MATK_BM = self.MATK_BM - matkadd;  
    DetachEffect(self, 'F_circle002')
end

--TABLE70_GIMMICK_REWARD_BUFF
function SCR_BUFF_ENTER_TABLE70_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, over)
    local defadd = math.floor(self.DEF * 0.1)
    local mdefadd = math.floor(self.MDEF * 0.1)
    self.DEF_BM = self.DEF_BM + defadd
    self.MDEF_BM = self.MDEF_BM + mdefadd
    SetExProp(buff, "ADD_DEF", defadd)
    SetExProp(buff, "ADD_MDEF", mdefadd)
    PlayEffect(self, 'F_buff_basic034_pink', 1)
end

function SCR_BUFF_UPDATE_TABLE70_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == "f_tableland_70" then
        local heal = self.MHP / 100
        if heal < 5 then
            heal = 5
        end
        Heal(self, heal, 0)
        return 1
    else
        return 0
    end
end

function SCR_BUFF_LEAVE_TABLE70_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, over)
    local defadd = GetExProp(buff, "ADD_DEF")
    local mdefadd = GetExProp(buff, "ADD_MDEF")
    self.DEF_BM = self.DEF_BM - defadd
    self.MDEF_BM = self.MDEF_BM - mdefadd
end

--TABLE72_GIMMICK_REWARD_BUFF
function SCR_BUFF_ENTER_TABLE72_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, over)
    local defadd = math.floor(self.DEF * 0.1)
    local mdefadd = math.floor(self.MDEF * 0.1)
    self.DEF_BM = self.DEF_BM + defadd
    self.MDEF_BM = self.MDEF_BM + mdefadd
    SetExProp(buff, "ADD_DEF", defadd)
    SetExProp(buff, "ADD_MDEF", mdefadd)
    PlayEffect(self, 'F_buff_basic034_pink', 1)
end

function SCR_BUFF_UPDATE_TABLE72_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == "f_tableland_72" then
        return 1
    else
        return 0
    end
end

function SCR_BUFF_LEAVE_TABLE72_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, over)
    local defadd = GetExProp(buff, "ADD_DEF")
    local mdefadd = GetExProp(buff, "ADD_MDEF")
    self.DEF_BM = self.DEF_BM - defadd
    self.MDEF_BM = self.MDEF_BM - mdefadd
end

--TABLE73_GIMMICK_REWARD_BUFF
function SCR_BUFF_ENTER_TABLE73_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, over)
    local defadd = math.floor(self.DEF * 0.1)
    local mdefadd = math.floor(self.MDEF * 0.1)
    self.DEF_BM = self.DEF_BM + defadd
    self.MDEF_BM = self.MDEF_BM + mdefadd
    SetExProp(buff, "ADD_DEF", defadd)
    SetExProp(buff, "ADD_MDEF", mdefadd)
    PlayEffect(self, 'F_buff_basic034_pink', 1)
end

function SCR_BUFF_UPDATE_TABLE73_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == "f_tableland_73" then
        local healsp = self.MSP / 100
        if healsp < 3 then
            healsp = 3
        end
        local sta = self.MaxSta/100
        if sta < 2 then
            sta = 2
        end
        HealSP(self, healsp, 0)
        AddStamina(self, sta)
        return 1
    else
        return 0
    end
end

function SCR_BUFF_LEAVE_TABLE73_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, over)
    local defadd = GetExProp(buff, "ADD_DEF")
    local mdefadd = GetExProp(buff, "ADD_MDEF")
    self.DEF_BM = self.DEF_BM - defadd
    self.MDEF_BM = self.MDEF_BM - mdefadd
end

--TABLE74_GIMMICK_REWARD_BUFF
function SCR_BUFF_ENTER_TABLE74_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_buff_basic034_pink', 1)
end

function SCR_BUFF_UPDATE_TABLE74_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == "f_tableland_74" then
        local heal = self.MHP / 100
        if heal < 5 then
            heal = 5
        end
        local healsp = self.MSP / 100
        if healsp < 3 then
            healsp = 3
        end
        local sta = self.MaxSta/100
        if sta < 2 then
            sta = 2
        end
        Heal(self, heal, 0)
        HealSP(self, healsp, 0)
        AddStamina(self, sta)
        return 1
    else 
        return 0
    end
end

function SCR_BUFF_LEAVE_TABLE74_GIMMICK_REWARD_BUFF(self, buff, arg1, arg2, over)
end

--GIMMICK_TRANSFORM_BUFF
function SCR_BUFF_ENTER_GIMMICK_TRANSFORM_BUFF(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Peaceful')
    PlayAnim(self, 'ASTD', 0)
end

function SCR_BUFF_UPDATE_GIMMICK_TRANSFORM_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    AddStamina(self, 99999)
    if GetLayer(self) ~= 0 then
        return 0
    end
    local zone = GetZoneName(self)
    local city = GetClass("Map", zone)
    if city.MapType == 'City' or zone == 'guild_agit_1' then
        return 1
    else
        return 0
    end
    
    return 1
end

function SCR_BUFF_LEAVE_GIMMICK_TRANSFORM_BUFF(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_smoke037', 0.5, 'MID')
    PlayAnim(self, 'ASTD', 0)
    SetCurrentFaction(self, 'Law')
    TransformToMonster(self, "None", "None")
end

--TABLELAND_FORZEN_MANA
function SCR_BUFF_ENTER_TABLELAND_FORZEN_MANA(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_TABLELAND_FORZEN_MANA(self, buff, arg1, arg2, over)
end

--TABLE70_STUN_BUFF
function SCR_BUFF_ENTER_TABLE70_STUN_BUFF(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_stun', 0)
    SetCurrentFaction(self, "Neutral");
--    SkillCancel(self);
--    ClearBTree(self)
--    ResetStdAnim(self)
--    ResetLastAttackTarget(self);
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
--    PlayAnim(self, "EVENT_SIT_1")
    --SetNoDamage(self, 1);
end

function SCR_BUFF_LEAVE_TABLE70_STUN_BUFF(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_stun')
    --SetNoDamage(self, 0);
end

--TABLE71_SUBQ7ITEM2_BUFF
function SCR_BUFF_ENTER_TABLE71_SUBQ7ITEM2_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_TABLE71_SUBQ7ITEM2_BUFF(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_levitation014', 0.5, 'BOT')
    return 1
end

function SCR_BUFF_LEAVE_TABLE71_SUBQ7ITEM2_BUFF(self, buff, arg1, arg2, over)
end

--TABLE72_SUBQ6ITEM1_BUFF
function SCR_BUFF_ENTER_TABLE72_SUBQ6ITEM1_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_TABLE72_SUBQ6ITEM1_BUFF(self, buff, arg1, arg2, over)
    return 1
end

function SCR_BUFF_LEAVE_TABLE72_SUBQ6ITEM1_BUFF(self, buff, arg1, arg2, over)
end

--ABBEY_35_3_SUMMON
function SCR_BUFF_ENTER_ABBEY_35_3_SUMMON(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_ABBEY_35_3_SUMMON(self, buff, arg1, arg2, over)
end

--TABLE73_SUBQ5_ICE_BUFF
function SCR_BUFF_ENTER_TABLE73_SUBQ5_ICE_BUFF(self, buff, arg1, arg2, over)
    local mspdadd = self.MSPD * 0.5
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
end

function SCR_BUFF_UPDATE_TABLE73_SUBQ5_ICE_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)    
    if GetLayer(self) > 0 then
        TakeDamage(self, self, "None", 100, "Ice", "None", "TrueDamage", HIT_ICE, HITRESULT_BLOW);
        return 1
    end
    return 0
end

function SCR_BUFF_LEAVE_TABLE73_SUBQ5_ICE_BUFF(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;
end

--TABLE73_SUBQ6_BUFF
function SCR_BUFF_ENTER_TABLE73_SUBQ6_BUFF(self, buff, arg1, arg2, over)
    if IsBuffApplied(self, 'TABLE73_SUBQ5_ICE_BUFF') == 'YES' then
        RemoveBuff(self, "TABLE73_SUBQ5_ICE_BUFF")
    end
end

function SCR_BUFF_UPDATE_TABLE73_SUBQ6_BUFF(self, buff, arg1, arg2, over)
    return 1
end

function SCR_BUFF_LEAVE_TABLE73_SUBQ6_BUFF(self, buff, arg1, arg2, over)
end


--GT_STAGE_3_ATK_BUFF
function SCR_BUFF_ENTER_GT_STAGE_3_ATK_BUFF(self, buff, arg1, arg2, over)
    local list, cnt = GetLayerPCList(self)
    if cnt > 0 then
        local i
        for i = 1, cnt do
            SendAddOnMsg(list[i], "NOTICE_Dm_scroll", self.Name.." "..GetTeamName(self)..ScpArgMsg("GT_STAGE_3_ATK_BUFF"), 5);
        end
    end
    AddBuff(self, self, 'SoulDuel_ATK', 1, 0, 30000, 1)
end

function SCR_BUFF_UPDATE_GT_STAGE_3_ATK_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetLayer(self) == 0 then
        if GetZoneName(self) == 'mission_groundtower_1' then
            return 1
        end
    end
    return 0
end

function SCR_BUFF_LEAVE_GT_STAGE_3_ATK_BUFF(self, buff, arg1, arg2, over)
    RemoveBuff(self, 'SoulDuel_ATK')
end
--TABLE74_SUBQ7_BUFF
function SCR_BUFF_ENTER_TABLE74_SUBQ7_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_TABLE74_SUBQ7_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)    
    local obj_list, obj_cnt = SelectObject(self, 150, "ALL", 1)
    if obj_cnt >= 1 then
        for i = 1, obj_cnt do
        if obj_list[i].ClassName == "npc_rokas_6" then
            if obj_list[i].SimpleAI == "TABLE74_SUBQ7_NPC_AI" then
                local quest_r = SCR_QUEST_CHECK(self, "TABLELAND_74_SQ8")
                if quest_r ~= "COMPLETE" then
                    return 1
                end
            end
        end
        end
    end
    return 0
end

function SCR_BUFF_LEAVE_TABLE74_SUBQ7_BUFF(self, buff, arg1, arg2, over)
end

--KATYN_45_3_SQ_BUFF
function SCR_BUFF_ENTER_KATYN_45_3_SQ_BUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'E_light001_circle')
    AttachEffect(self, 'E_light001_circle', 3, 'Bottom')
end

function SCR_BUFF_UPDATE_KATYN_45_3_SQ_BUFF(self, buff, arg1, arg2, over)
    local result = SCR_QUEST_CHECK(self, 'KATYN_45_3_SQ_4')
    if GetZoneName(self) ~= 'f_katyn_45_3' then
        RemoveBuff(self, 'KATYN_45_3_SQ_BUFF')
    end
    if result == 'PROGRESS' then
        return 0;
    elseif result == 'SUCCESS' then
        return 0;
    elseif result == 'COMPLETE' then
        return 0;
    end
    return 1;
end

function SCR_BUFF_LEAVE_KATYN_45_3_SQ_BUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'E_light001_circle')
end

--TABLE74_SUBQ5_BUFF
function SCR_BUFF_ENTER_TABLE74_SUBQ5_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_TABLE74_SUBQ5_BUFF(self, buff, arg1, arg2, over)
    return 1
end

function SCR_BUFF_LEAVE_TABLE74_SUBQ5_BUFF(self, buff, arg1, arg2, over)
end

--TABLE71_SUBQ4_BUFF1
function SCR_BUFF_ENTER_TABLE71_SUBQ4_BUFF1(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_TABLE71_SUBQ4_BUFF1(self, buff, arg1, arg2, over)
    local obj_list, cnt = SelectObject(self, 200, "ALL")
    if cnt >= 1 then
        for i =1, cnt do
            if obj_list[i].ClassName == "HiddenTrigger4" then
                if obj_list[i].Dialog == "TABLE71_POINT1" then
                    PlayEffectLocal(obj_list[i], self, "F_circle019", 0.5)
                end
            end
        end
    end
    return 1
end

function SCR_BUFF_LEAVE_TABLE71_SUBQ4_BUFF1(self, buff, arg1, arg2, over)
end

--TABLE71_SUBQ4_BUFF2
function SCR_BUFF_ENTER_TABLE71_SUBQ4_BUFF2(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_TABLE71_SUBQ4_BUFF2(self, buff, arg1, arg2, over)
    local obj_list, cnt = SelectObject(self, 200, "ALL")
    if cnt >= 1 then
        for i =1, cnt do
            if obj_list[i].ClassName == "HiddenTrigger4" then
                if obj_list[i].Dialog == "TABLE71_POINT2" then
                    PlayEffectLocal(obj_list[i], self, "F_circle019", 0.5)
                end
            end
        end
    end
    return 1
end

function SCR_BUFF_LEAVE_TABLE71_SUBQ4_BUFF2(self, buff, arg1, arg2, over)
end

--TABLE71_SUBQ4_BUFF3
function SCR_BUFF_ENTER_TABLE71_SUBQ4_BUFF3(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_TABLE71_SUBQ4_BUFF3(self, buff, arg1, arg2, over)
    local obj_list, cnt = SelectObject(self, 200, "ALL")
    if cnt >= 1 then
        for i =1, cnt do
            if obj_list[i].ClassName == "HiddenTrigger4" then
                if obj_list[i].Dialog == "TABLE71_POINT3" then
                    PlayEffectLocal(obj_list[i], self, "F_circle019", 0.5)
                end
            end
        end
    end
    return 1
end

function SCR_BUFF_LEAVE_TABLE71_SUBQ4_BUFF3(self, buff, arg1, arg2, over)
end

--CORAL_35_2_BINDING
function SCR_BUFF_ENTER_CORAL_35_2_BINDING(self, buff, arg1, arg2, over)
    local count = GetScpObjectList(self, 'CORAL_35_2_BINDING')
    if #count == 0 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', nil) 
        AddScpObjectList(self, 'CORAL_35_2_BINDING', mon)
        AttachEffect(mon, 'F_ground007', 10, 'BOT')
    end
    AttachEffect(self, 'I_chain004_mash_loop', 4, 'BOT')
end

function SCR_BUFF_LEAVE_CORAL_35_2_BINDING(self, buff, arg1, arg2, over)
    local count = GetScpObjectList(self, 'CORAL_35_2_BINDING')
    local i
    if #count > 0 then
        for i = 1, #count do
            if count[i].ClassName == 'HiddenTrigger6' then
                DetachEffect(count[i], 'F_ground007')
                Kill(count[i])
            end
        end
    end
    local checkQ1 = SCR_QUEST_CHECK(self, 'CORAL_35_2_SQ_1')
    if checkQ1 == 'PROGRESS' then
        SCR_PARTY_QUESTPROP_ADD(self, "SSN_CORAL_35_2_SQ_1", "QuestInfoValue1", 1)
    end
    DetachEffect(self, 'I_chain004_mash_loop')
end

--CORAL_35_2_SUMMON
function SCR_BUFF_ENTER_CORAL_35_2_SUMMON(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_CORAL_35_2_SUMMON(self, buff, arg1, arg2, over)
end

--CORAL_35_2_BINDING_R
function SCR_BUFF_ENTER_CORAL_35_2_BINDING_R(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_chain004_mash_loop', 4, 'BOT')
end

function SCR_BUFF_LEAVE_CORAL_35_2_BINDING_R(self, buff, arg1, arg2, over)
    DetachEffect(self, 'I_chain004_mash_loop')
end

--PILGRIM41_2_DARKAURA
function SCR_BUFF_ENTER_PILGRIM41_2_DARKAURA(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, 'F_smoke019_dark_loop', 0.5, 1,'MID')
end

function SCR_BUFF_LEAVE_PILGRIM41_2_DARKAURA(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, 'F_smoke101_dark', 2, 'MID')
end

--PILGRIM41_4_MONWEAK
function SCR_BUFF_ENTER_PILGRIM41_4_MONWEAK(self, buff, arg1, arg2, RemainTime, ret, over)
    self.NumArg1 = self.Lv * 10
    self.DEF_BM = self.DEF_BM - (self.Lv * 10)
end

function SCR_BUFF_UPDATE_PILGRIM41_4_MONWEAK(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, 'I_smoke013_dark', 0.5, 'TOP')
    return 1
end

function SCR_BUFF_LEAVE_PILGRIM41_4_MONWEAK(self, buff, arg1, arg2, RemainTime, ret, over)
    self.DEF_BM = self.DEF_BM + self.NumArg1
end

--CORAL_32_2_SQ_6_BUFF
function SCR_BUFF_ENTER_CORAL_32_2_SQ_6_BUFF(self, buff, arg1, arg2, over)
    local patkadd = math.floor(self.MAXPATK * 0.1);
    local matkadd = math.floor(self.MAXMATK * 0.1);
    local defadd = math.floor(self.DEF * 0.1)
    local mdefadd = math.floor(self.MDEF * 0.1)

    self.PATK_BM = self.PATK_BM + patkadd;
    self.MATK_BM = self.MATK_BM + matkadd;
    self.DEF_BM = self.DEF_BM + defadd
    self.MDEF_BM = self.MDEF_BM + mdefadd

    SetExProp(buff, "ADD_PATK", patkadd);
    SetExProp(buff, "ADD_MATK", matkadd);
    SetExProp(buff, "ADD_DEF", defadd)
    SetExProp(buff, "ADD_MDEF", mdefadd)
end

function SCR_BUFF_UPDATE_CORAL_32_2_SQ_6_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == "f_coral_32_2" then
        if GetLayer(self) ~= 0 then
            return 1
        else
            return 0
        end
    else
        return 0
    end
end

function SCR_BUFF_LEAVE_CORAL_32_2_SQ_6_BUFF(self, buff, arg1, arg2, over)
    local patkadd = GetExProp(buff, "ADD_PATK");
    local matkadd = GetExProp(buff, "ADD_MATK");
    local defadd = GetExProp(buff, "ADD_DEF")
    local mdefadd = GetExProp(buff, "ADD_MDEF")

    self.PATK_BM = self.PATK_BM - patkadd;
    self.MATK_BM = self.MATK_BM - matkadd;  
    self.DEF_BM = self.DEF_BM - defadd
    self.MDEF_BM = self.MDEF_BM - mdefadd
end

--CORAL_32_2_SQ_8_BUFF
function SCR_BUFF_ENTER_CORAL_32_2_SQ_8_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_CORAL_32_2_SQ_8_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

--FD_UNDER30_2_BUFF
function SCR_BUFF_ENTER_FD_UNDER30_2_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_FD_UNDER30_2_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'd_underfortress_30_2' then
        local obj, cnt = SelectObjectByClassName(self, 190, "HiddenTrigger6")
        if cnt >= 1 then
            for i =1, cnt do
                if obj[i].ClassName == "HiddenTrigger6" then
                    if obj[i].Tactics == "UNDER302_EVENT1_MON" then
                        PlayEffect(self, "F_hit_poison_hit_green", 1, 0, nil, "MID")
                        TakeDamage(self, self,  "None", 100, "Poison", "None", "TrueDamage", HIT_REFLECT, HITRESULT_BLOW)
                        return 1
                    end
                end
           end
       end
    end
    return 0
    --RemoveBuff(pc, "FD_UNDER30_2_BUFF")
end

function SCR_BUFF_LEAVE_FD_UNDER30_2_BUFF(self, buff, arg1, arg2, over)
end

--FD_UNDER30_2_CHECK_BUFF
function SCR_BUFF_ENTER_FD_UNDER30_2_CHECK_BUFF(self, buff, arg1, arg2, over)
    local hover = GetScpObjectList(self, 'UNDER30_2_EVENT1_MON_BUFF')
    if #hover <= 0 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'HiddenTrigger2', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, UNDER30_2_EVENT1_HOVER_SET);
        AddScpObjectList(self, 'UNDER30_2_EVENT1_MON_BUFF', mon)
        AttachEffect(mon, 'F_circle002', 2.0, 'TOP')
        SetNoDamage(mon, 1);
        HoverAround(mon, self, 20, 1, 2.0, 1);
        SetOwner(mon, self, 1)
    end
end

function SCR_BUFF_UPDATE_FD_UNDER30_2_CHECK_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'd_underfortress_30_2' then
        if IsBuffApplied(self, "FD_UNDER30_2_BUFF") == 'YES' then
            RemoveBuff(self, "FD_UNDER30_2_BUFF")
        end
    end
    local hover = GetScpObjectList(self, 'UNDER30_2_EVENT1_MON_BUFF')
    if #hover <= 0 then
        return 0
    else
        local have_hover
        for i = 1, #hover do
            have_hover = hover[i]
        end
        local obj, cnt = SelectObjectByClassName(self, 300, "HiddenTrigger6")
        if cnt >= 1 then
            for i = 1, cnt do
                if obj[i].ClassName == "HiddenTrigger6" then
                    if obj[i].Tactics == "UNDER302_EVENT1_MON" then
                        if obj[i].NumArg2 < 1 then
                            obj[i].NumArg2 = obj[i].NumArg2 + 1
                            local skill = GetNormalSkill(have_hover);
                            DetachEffect(have_hover, 'F_circle002')
                            ForceDamage(have_hover, skill, obj[i], have_hover, 0, 'MOTION', 'BLOW', 'F_circle002', 0.3, 'arrow_cast', 'F_explosion004_mint', 1, 'arrow_blow', 'SLOW', 140, 1, 0, 0, 0, 1, 1)
                            --print(obj[i].ClassName)
                            SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("UNDER30_2_EVENT1_MSG1"), 5)
                            Kill(have_hover)
                        end
                    end
                end
            end
        end
    end
    return 1
end

function SCR_BUFF_LEAVE_FD_UNDER30_2_CHECK_BUFF(self, buff, arg1, arg2, over)
    local hover = GetScpObjectList(self, 'UNDER30_2_EVENT1_MON_BUFF')
    if #hover > 0 then
        for i = 1, #hover do
            DetachEffect(hover[i], 'F_circle002')
            Kill(hover[i])
        end
    end
end

function UNDER30_2_EVENT1_HOVER_SET(self)
    self.Name = "UnvisibleName"
    --self.SimpleAI = "UNDER30_2_EVENT1_HOVER_AI"
end


--FD_UNDER30_3_LIGHT_BUFF
function SCR_BUFF_ENTER_FD_UNDER30_3_LIGHT_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_FD_UNDER30_3_LIGHT_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end

function SCR_BUFF_LEAVE_FD_UNDER30_3_LIGHT_BUFF(self, buff, arg1, arg2, over)
end

--FD_UNDER302_DOLL_BUFF
function SCR_BUFF_ENTER_FD_UNDER302_DOLL_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_sphere009_violet', 1)
    local mspdadd
    if self.ClassName == "saltisdaughter_green" then
        mspdadd = 25
    end
    if self.ClassName == "Colifly_mage_black"  or self.ClassName == "Colifly_bow_black" then
        mspdadd = 15
    end
--  print("before DEF_BM : "..self.DEF_BM, "before MDEF_BM : "..self.MDEF_BM, "before MSPD_BM : "..self.MSPD_BM)
--  print(self.ClassName, "DEF : "..defadd, "MDEF : "..mdefadd)
    self.DEF_BM = self.DEF_BM - 75
    self.MDEF_BM = self.MDEF_BM - 100
    self.MSPD_BM = self.MSPD_BM - mspdadd
--  self.DEF = self.DEF - defadd
--  self.MDEF = self.MDEF - mdefadd
--  self.MSPD = self.MSPD - mspdadd
    SetExProp(buff, "ADD_DEF", defadd)
    SetExProp(buff, "ADD_MDEF", mdefadd)
    SetExProp(buff, "ADD_MSPD", mspdadd)
--  print("after DEF_BM : "..self.DEF_BM, "after MDEF_BM : "..self.MDEF_BM, "after MSPD_BM : "..self.MSPD_BM)
--  print("DEF : "..self.DEF, "MDEF : "..self.MDEF, "MSPD : "..self.MSPD)
end

function SCR_BUFF_LEAVE_FD_UNDER302_DOLL_BUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'I_sphere009_violet')
    
    local mspdadd = GetExProp(buff, "ADD_MSPD")
    self.DEF_BM = self.DEF_BM + 75
    self.MDEF_BM = self.MDEF_BM + 100
    self.MSPD_BM = self.MSPD_BM + mspdadd
--  self.DEF = self.DEF - defadd
--  self.MDEF = self.MDEF - mdefadd
--  self.MSPD = self.MSPD - mspdadd
end

--FD_UNDER303_EVENT2_BUFF
function SCR_BUFF_ENTER_FD_UNDER303_EVENT2_BUFF(self, buff, arg1, arg2, over)
    SetNoDamage(self, 1);
    local obj = GetScpObjectList(self, 'UNDER30_3_EVENT2_EFFECT_MON1')
    if #obj > 0 then
        for i = 1, #obj do
            AttachEffect(obj[i], "F_levitation032_red_loop", 3, 1, "BOT")
        end
    end
end

function SCR_BUFF_UPDATE_FD_UNDER303_EVENT2_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local mon = GetScpObjectList(self, 'UNDER30_3_EVENT2_MON_LIST')
    if #mon <= 0 then
        SetNoDamage(self, 0);
        local pc_list, cnt = SelectObject(self, 300, "ALL", 1)
        if cnt > 0 then
            for i = 1, cnt do
                if pc_list[i].ClassName == "PC" then
                    SendAddOnMsg(pc_list[i], "NOTICE_Dm_Clear", ScpArgMsg("UNDER30_3_EVENT2_BUFF_REMOVE"), 5);
                end
            end
        end
        return 0
    end
    return 1
end

function SCR_BUFF_LEAVE_FD_UNDER303_EVENT2_BUFF(self, buff, arg1, arg2, over)
    --self.NumArg1 : monstet gen Count
    self.NumArg1 = 0
    local obj = GetScpObjectList(self, 'UNDER30_3_EVENT2_EFFECT_MON1')
    if #obj > 0 then
        for i = 1, #obj do
            PlayEffect(self, "F_levitation032_red", 1, 1, "BOT")
            DetachEffect(obj[i], "F_levitation032_red_loop")
        end
    end
end

--FD_UNDER303_EVENT2_1_BUFF
function SCR_BUFF_ENTER_FD_UNDER303_EVENT2_1_BUFF(self, buff, arg1, arg2, over)
    SetNoDamage(self, 1);
    local obj = GetScpObjectList(self, 'UNDER30_3_EVENT2_EFFECT_MON2')
    if #obj > 0 then
        for i = 1, #obj do
            AttachEffect(obj[i], "F_levitation032_red_loop", 3, 1, "BOT")
        end
    end
end

function SCR_BUFF_UPDATE_FD_UNDER303_EVENT2_1_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local mon = GetScpObjectList(self, 'UNDER30_3_EVENT2_MON_LIST2')
    if #mon <= 0 then
        SetNoDamage(self, 0);
        local pc_list, cnt = SelectObject(self, 300, "ALL", 1)
        if cnt > 0 then
            for i = 1, cnt do
                if pc_list[i].ClassName == "PC" then
                    SendAddOnMsg(pc_list[i], "NOTICE_Dm_Clear", ScpArgMsg("UNDER30_3_EVENT2_BUFF_REMOVE"), 5);
                end
            end
        end
        return 0
    end
    return 1
end

function SCR_BUFF_LEAVE_FD_UNDER303_EVENT2_1_BUFF(self, buff, arg1, arg2, over)
    --self.NumArg1 : monstet gen Count
    self.NumArg1 = 0
    local obj = GetScpObjectList(self, 'UNDER30_3_EVENT2_EFFECT_MON2')
    if #obj > 0 then
        for i = 1, #obj do
            PlayEffect(self, "F_levitation032_red", 1, 1, "BOT")
            DetachEffect(obj[i], "F_levitation032_red_loop")
        end
    end
end

--MAPLE_25_3_SQ_90_BUFF1
function SCR_BUFF_ENTER_MAPLE_25_3_SQ_90_BUFF1(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_MAPLE_25_3_SQ_90_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end

function SCR_BUFF_LEAVE_MAPLE_25_3_SQ_90_BUFF1(self, buff, arg1, arg2, over)
end


--KATYN10_RP_1_MONBUFF
function SCR_BUFF_ENTER_KATYN10_RP_1_MONBUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_light080_blue_loop_attach', 1,1, 'TOP')
end

function SCR_BUFF_UPDATE_KATYN10_RP_1_MONBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local _pc = GetBuffCaster(buff)
    if _pc ~= nil then
        if GetDistance(self, _pc) < 200 then
            return 1
        end
    end
    return 0
end

function SCR_BUFF_LEAVE_KATYN10_RP_1_MONBUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_light080_blue_loop_attach')
end


--KATYN10_RP_1_PCBUFF
function SCR_BUFF_ENTER_KATYN10_RP_1_PCBUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_KATYN10_RP_1_PCBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local result = SCR_QUEST_CHECK(self, 'KATYN10_RP_1')
    if result == 'PROGRESS' then
        if GetZoneName(self) == 'f_katyn_10' then
            return 1
        else
            return 0
        end
    else
        return 0
    end
end

function SCR_BUFF_LEAVE_KATYN10_RP_1_PCBUFF(self, buff, arg1, arg2, over)
end

--FD_UNDER303_EVENT2_CHECK_BUFF
function SCR_BUFF_ENTER_FD_UNDER303_EVENT2_CHECK_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_FD_UNDER303_EVENT2_CHECK_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) ~= 'd_underfortress_30_1' then
        return 0
    end
    return 1
end

function SCR_BUFF_LEAVE_FD_UNDER303_EVENT2_CHECK_BUFF(self, buff, arg1, arg2, over)
end

--FD_UNDER303_EVENT2_REWARD
function SCR_BUFF_ENTER_FD_UNDER303_EVENT2_REWARD(self, buff, arg1, arg2, over)
    
    self.PATK_BM = self.PATK_BM + 85;
    self.MATK_BM = self.MATK_BM + 85;
    
    SetExProp(buff, "ADD_PATK", patkadd);
    SetExProp(buff, "ADD_MATK", matkadd);
    
    local hover = GetScpObjectList(self, 'UNDER30_3_EVENT2_BUFF_MON')
    if #hover <= 0 then
        local x, y, z = GetPos(self)
        local mon = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, GetDirectionByAngle(self), 'Neutral', 1, UNDER30_2_EVENT1_HOVER_SET);
        AddScpObjectList(self, 'UNDER30_3_EVENT2_BUFF_MON', mon)
        AttachEffect(mon, 'F_light055_orange', 2, 1, 'TOP')
        SetNoDamage(mon, 1);
        HoverAround(mon, self, 20, 1, 2.0, 1);
        SetOwner(mon, self, 1)
    end
    
end

function SCR_BUFF_UPDATE_FD_UNDER303_EVENT2_REWARD(self, buff, arg1, arg2, RemainTime, ret, over)
    local healsp = self.MSP / 100
    if self.SP < self.MSP then
        if healsp < 3 then
            healsp = 3;
        end
        HealSP(self, healsp, 0);
    end
    if GetZoneName(self) ~= 'd_underfortress_30_3' then
        return 0
    end
    return 1
end

function SCR_BUFF_LEAVE_FD_UNDER303_EVENT2_REWARD(self, buff, arg1, arg2, over)
    
    self.PATK_BM = self.PATK_BM - 85;
    self.MATK_BM = self.MATK_BM - 85;
    
    local hover = GetScpObjectList(self, 'UNDER30_3_EVENT2_BUFF_MON')
    if #hover >= 0 then
        for i = 1, #hover do
            DetachEffect(hover[i], "F_light055_orange")
            Kill(hover[i])
        end
    end
end

--FD_UNDER301_EVENT_FAIL_BUFF
function SCR_BUFF_ENTER_FD_UNDER301_EVENT_FAIL_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_FD_UNDER301_EVENT_FAIL_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, "F_explosion026_rize_red1", 1)
    TakeDamage(self, obj_list[i], "None", 50, "Melee", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW);
    return 1
end

function SCR_BUFF_LEAVE_FD_UNDER301_EVENT_FAIL_BUFF(self, buff, arg1, arg2, over)
end

--BRACKEN42_1_SOUL
function SCR_BUFF_ENTER_BRACKEN42_1_SOUL(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_UPDATE_BRACKEN42_1_SOUL(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, 'F_smoke026_blue', 0.3, 'BOT')
    return 1
end

function SCR_BUFF_LEAVE_BRACKEN42_1_SOUL(self, buff, arg1, arg2, RemainTime, ret, over)
end

--BRACKEN42_2_SLEEP
function SCR_BUFF_ENTER_BRACKEN42_2_SLEEP(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_BRACKEN42_2_SLEEP(self, buff, arg1, arg2, RemainTime, ret, over)
end

--LIMESTONE_52_1_STUN--
function SCR_BUFF_ENTER_LIMESTONE_52_1_STUN(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_LIMESTONE_52_1_STUN(self, buff, arg1, arg2, RemainTime, ret, over)
end

--CATACOMB_25_4_BUFF
function SCR_BUFF_ENTER_CATACOMB_25_4_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    DetachEffect(self, 'E_light001_circle')
    AttachEffect(self, 'E_light001_circle', 3, 'Bottom')
end

function SCR_BUFF_UPDATE_CATACOMB_25_4_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == "id_catacomb_25_4" then
        if GetLayer(self) ~= 0 then
            local heal = self.MHP / 100
            local healsp = self.MSP / 100
            local sta = self.MaxSta / 100
            
            if heal < 5 then
                heal = 5
            end
            Heal(self, heal, 0)
            
            if healsp < 3 then
                healsp = 3
            end
            HealSP(self, healsp, 0)
            
            if sta < 2 then
                sta = 2
            end
            AddStamina(self, sta)
            
            return 1
        else
            return 0
        end
    else
        return 0
    end
end

function SCR_BUFF_LEAVE_CATACOMB_25_4_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    DetachEffect(self, 'E_light001_circle')
end

--MAPLE_25_3_BUFF1
function SCR_BUFF_ENTER_MAPLE_25_3_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, 'F_buff_basic023_red_fire', 1)
end

function SCR_BUFF_UPDATE_MAPLE_25_3_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    local heal = self.MHP / 100
    if heal < 5 then
        heal = 5
    end
    Heal(self, heal, 0)
    return 1
end

function SCR_BUFF_LEAVE_MAPLE_25_3_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
end

--MAPLE_25_3_BUFF2
function SCR_BUFF_ENTER_MAPLE_25_3_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, 'F_buff_basic018_blue_fire', 1)
end

function SCR_BUFF_UPDATE_MAPLE_25_3_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
    local healsp = self.MSP / 100
    if healsp < 3 then
        healsp = 3
    end
    HealSP(self, healsp, 0)
    return 1
end

function SCR_BUFF_LEAVE_MAPLE_25_3_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
end

--MAPLE_25_3_BUFF3
function SCR_BUFF_ENTER_MAPLE_25_3_BUFF3(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, 'F_buff_basic021_yellow_fire', 1)
end

function SCR_BUFF_UPDATE_MAPLE_25_3_BUFF3(self, buff, arg1, arg2, RemainTime, ret, over)
    local sta = self.MaxSta/100
    if sta < 2 then
        sta = 2
    end
    AddStamina(self, sta)
    return 1
end

function SCR_BUFF_LEAVE_MAPLE_25_3_BUFF3(self, buff, arg1, arg2, RemainTime, ret, over)
end

--LIMESTONE_52_3_PROTECTION--
function SCR_BUFF_ENTER_LIMESTONE_52_3_PROTECTION(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, 'F_light055_blue', 4, 'MID')
end

function SCR_BUFF_LEAVE_LIMESTONE_52_3_PROTECTION(self, buff, arg1, arg2, RemainTime, ret, over)
    DetachEffect(self, 'F_light055_blue')
end

--LIMESTONE_52_4_HOLYCHARM--
function SCR_BUFF_ENTER_LIMESTONE_52_4_HOLYCHARM(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, 'F_light029_mint', 1, nil, 'MID')
    AttachEffect(self, 'I_sphere009_green', 1, 'BOT')
end

function SCR_BUFF_UPDATE_LIMESTONE_52_4_HOLYCHARM(self, buff, arg1, arg2, RemainTime, ret, over)
    local _pc = GetBuffCaster(buff)
    if _pc ~= nil then
        if GetDistance(_pc, self) > 200 then
            return 0
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_LIMESTONE_52_4_HOLYCHARM(self, buff, arg1, arg2, over)
    local _pc = GetBuffCaster(buff)
    if _pc ~= nil then
        if GetDistance(_pc, self) > 180 then
            return 0
        end
        local follower = GetScpObjectList(_pc, 'LIMESTONE_52_4_MQ_1')
        local i
        if #follower > 0 then
            for i = 1, #follower do
                if follower[i].ClassName == 'mon_kupole_4' then
                    LookAt(follower[i], self)
                    PlayAnim(follower[i], 'atk')
                    local skill = GetNormalSkill(self);
                    ForceDamage(self, skill, follower[i], self, 0, 'MOTION', 'BLOW', 'I_force013_dark', 1, 'arrow_cast', 'I_force080_green_blue', 1, 'arrow_blow', 'SLOW', 50, 1, 0, 0, 0, 1, 1)
                end
            end
        end
        local msg = {'LIMESTONE_52_4_MQ_5_DEBUFF_1',
                    'LIMESTONE_52_4_MQ_5_DEBUFF_2',
                    'LIMESTONE_52_4_MQ_5_DEBUFF_3',
                    'LIMESTONE_52_4_MQ_5_DEBUFF_4',
                    'LIMESTONE_52_4_MQ_5_DEBUFF_5'
                    }
        local quest_ssn = GetSessionObject(_pc, 'SSN_LIMESTONE_52_4_MQ_5')
        ShowBalloonText(_pc, msg[quest_ssn.QuestInfoValue1+1], 5)
        SCR_PARTY_QUESTPROP_ADD(_pc, 'SSN_LIMESTONE_52_4_MQ_5', 'QuestInfoValue1', 1)
    end
    DetachEffect(self, 'I_sphere009_green')
end

--MISSION_UPHILL_GIMMICK_BUFF1
function SCR_BUFF_ENTER_MISSION_UPHILL_GIMMICK_BUFF1(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_archer_scarecrow_loop_ground', 1.0)
    self.MSPD_BM = self.MSPD_BM - 30;
end

function SCR_BUFF_LEAVE_MISSION_UPHILL_GIMMICK_BUFF1(self, buff, arg1, arg2, over)
    ClearEffect(self)
    self.MSPD_BM = self.MSPD_BM + 30;
end

--MISSION_UPHILL_GIMMICK_BUFF2
function SCR_BUFF_ENTER_MISSION_UPHILL_GIMMICK_BUFF2(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_wizard_slow_shot_ground', 4, 1, "TOP")
end

function SCR_BUFF_LEAVE_MISSION_UPHILL_GIMMICK_BUFF2(self, buff, arg1, arg2, over)
    ClearEffect(self)
end





--GT24_POISON_DEBUFF
function SCR_BUFF_ENTER_GT24_POISON_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, 'I_smoke009_green', 1)
end

function SCR_BUFF_UPDATE_GT24_POISON_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff)
    local over = GetBuffOver(self, buff.ClassName)
    local damage = self.MHP*over*0.05
--    if caster.Faction == 'Monster' then
        TakeDamage(self, self, "None", damage, "Poison", "None", "TrueDamage", HIT_FIRE, HITRESULT_BLOW);
--    end
    if over > 5 then
        local list, cnt = SelectObjectByFaction(self, 150, 'Law')
        if cnt > 0 then
            local i
            for i = 1, cnt do
                if IsSameActor(self, list[i]) == 'NO' then
                    AddBuff(list[i], list[i], 'GT24_POISON_DEBUFF', 1, 0, 10000, 1)
--                    TakeDamage(list[i], list[i], "None", damage, "Poison", "None", "TrueDamage", HIT_FIRE, HITRESULT_BLOW);
                end
            end
        end
    end
    return 1
end

function SCR_BUFF_LEAVE_GT24_POISON_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    DetachEffect(self, 'I_smoke009_green')
end



--GT34_FROSTBITE_DEBUFF
function SCR_BUFF_ENTER_GT34_FROSTBITE_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local _buff = GetOver(buff)
    local red = 255-(_buff*2)
    local green = 255-_buff
    ObjectColorBlend(self, red, green, 255, 255, 1, 1)
    AttachEffect(self, 'F_hit_ice', 1, 'MID')
end

function SCR_BUFF_UPDATE_GT34_FROSTBITE_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local stack = 100
    local mon = GetBuffCaster(buff)
    if GetOver(buff) < stack then
        if mon ~= nil then
            if IsMoving(self) == 1 then
                AddBuff(self, self, 'GT34_FROSTBITE_DEBUFF', 100, 0, 30000, -2)
--            else
--                AddBuff(self, self, 'GT34_FROSTBITE_DEBUFF', 100, 0, 30000, 1)
            end
        end
    elseif GetOver(buff) >= stack then
        if mon ~= nil then
            AddBuff(mon, self, 'GT34_CRYSTALLIZATION_DEBUFF', 1, 0, 30000, 1)
        else
            AddBuff(self, self, 'GT34_CRYSTALLIZATION_DEBUFF', 1, 0, 30000, 1)
        end
        RemoveBuff(self, 'GT34_FROSTBITE_DEBUFF')
    end
    return 1
end

function SCR_BUFF_LEAVE_GT34_FROSTBITE_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    ObjectColorBlend(self, 255, 255, 255, 255, 1, 1)
--    DetachEffect(self, 'I_smoke009_green')
end


--GT34_CRYSTALLIZATION_DEBUFF
function SCR_BUFF_ENTER_GT34_CRYSTALLIZATION_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, 'F_explosion086_ice', 0.5, 'MID')
    SetRenderOption(self, "Freeze", 1);
end

function SCR_BUFF_UPDATE_GT34_CRYSTALLIZATION_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end

function SCR_BUFF_LEAVE_GT34_CRYSTALLIZATION_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    SetRenderOption(self, "Freeze", 0);
end



--GT39_ZOMBILIZATION_1
function SCR_BUFF_ENTER_GT39_ZOMBILIZATION_1(self, buff, arg1, arg2, RemainTime, ret, over)
    self.NumArg4 = 0
    ObjectColorBlend(self, 100, 100, 100, 200, 1, 1)
end

function SCR_BUFF_UPDATE_GT39_ZOMBILIZATION_1(self, buff, arg1, arg2, RemainTime, ret, over)
    local list = GetScpObjectList(self, 'GT39_ZOMBILIZATION_ARG')
    if #list ~= 0 then
        if self.NumArg4 < 7 then
            self.NumArg4 = self.NumArg4 + 1
        elseif self.NumArg4 >= 7 then
            local x, y, z = GetPos(self)
            local mon = CREATE_MONSTER_EX(self, 'Hiddennpc_move', x, y, z, GetDirectionByAngle(self), 'Monster', 1, GT39_MAKE_ZOMBIE_RUN);
            AddScpObjectList(mon, 'GT39_MAKE_ZOMBIE_ARG', list[1])
            Dead(self)
        end
    else
        return 0
    end
    return 1
end

function SCR_BUFF_LEAVE_GT39_ZOMBILIZATION_1(self, buff, arg1, arg2, RemainTime, ret, over)
    ObjectColorBlend(self, 255, 255, 255, 255, 1, 1)
end

function GT39_MAKE_ZOMBIE_RUN(mon)
    mon.Name = 'UnvisibleName'
    mon.SimpleAI = 'GT39_MAKE_ZOMBIE_AI'
    mon.HPCount = 5
    mon.MSPD_BM = 80
--    InvalidateMSPD(mon);
end

function GT39_MAKE_ZOMBIE_AI_1(self)
    local tgt_pc = GetScpObjectList(self, 'GT39_MAKE_ZOMBIE_ARG')
    if #tgt_pc == 0 then
        Kill(self)
    end
    local _pc = tgt_pc[1]
    if GetDistance(self, _pc) > 15 then
        MoveToTarget(self, _pc, 1)
        return 1
    else
        local damage = _pc.MHP*0.15
        PlayEffect(self, 'F_explosion026_rize_red2', 1, 'MID')
        KnockDown(_pc, self, 190, GetAngleTo(self, _pc), 45, 1)
        TakeDamage(self, _pc, "None", damage, "Dark", "None", "TrueDamage", HIT_FIRE, HITRESULT_BLOW);
        Kill(self)
    end
    return 1    
end



--GT23_SoulDuel_ATK
function SCR_BUFF_ENTER_GT23_SoulDuel_ATK(self, buff, arg1, arg2, RemainTime, ret, over)
    ObjectColorBlend(self, 155, 255, 155, 255, 1, 1)
    AddBuff(self, self, 'SoulDuel_ATK', 1, 0, 10000, 1)
    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("GTOWER23_DEAD_MSG_1"), 5);
end

function SCR_BUFF_UPDATE_GT23_SoulDuel_ATK(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end

function SCR_BUFF_LEAVE_GT23_SoulDuel_ATK(self, buff, arg1, arg2, RemainTime, ret, over)
    ObjectColorBlend(self, 255, 255, 255, 255, 1, 1)
    RemoveBuff(self, 'SoulDuel_ATK')
end

--BRACKEN432_SUBQ_MON_BUFF
function SCR_BUFF_ENTER_BRACKEN432_SUBQ_MON_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_BRACKEN432_SUBQ_MON_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

--BRACKEN433_SUBQ3_BUFF
function SCR_BUFF_ENTER_BRACKEN433_SUBQ3_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    --SetCurrentFaction(self, 'Peaceful')
    AttachEffect(self, "I_smoke007_green", 1, "MID", 0, 0, 0, 1)
end

function SCR_BUFF_UPDATE_BRACKEN433_SUBQ3_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)

    if GetLayer(self) ~= 0 then
        return 0
    end
    local result = SCR_QUEST_CHECK(self, 'BRACKEN43_3_SQ4')
    if result ~= 'PROGRESS' then
        return 0
    end
    if GetZoneName(self) ~= 'f_bracken_43_3' then
        return 0
    end
   
    return 1;

end


function SCR_BUFF_LEAVE_BRACKEN433_SUBQ3_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    --SetCurrentFaction(self, 'Law')
    DetachEffect(self, "I_smoke007_green")
end

--BRACKEN433_SUBQ4_BUFF
function SCR_BUFF_ENTER_BRACKEN433_SUBQ4_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_BRACKEN433_SUBQ4_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

--BRACKEN434_SUBQ_BUFF1
function SCR_BUFF_ENTER_BRACKEN434_SUBQ_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_UPDATE_BRACKEN434_SUBQ_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    local buff = GetBuffByName(self, "BRACKEN434_SUBQ_BUFF1");
    if buff ~= nil then
        local buff_stack = GetOver(buff)
        if buff_stack < 5 then
            PlayEffect(self, "F_light015_violet2", 1, "BOT")
            AddBuff(self, self, "BRACKEN434_SUBQ_BUFF1", 1, 0, 8000, 1)
        end
    end
    return 1
end

function SCR_BUFF_LEAVE_BRACKEN434_SUBQ_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
end

--BRACKEN431_SUBQ5_BUFF
function SCR_BUFF_ENTER_BRACKEN431_SUBQ5_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, "F_bg_light008_yellow2", 1, "BOT")
end

function SCR_BUFF_UPDATE_BRACKEN431_SUBQ5_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if self.NumArg2 < 4 then
        self.NumArg2 = self.NumArg2 + 1
    else
        PlayEffect(self, "F_bg_light008_yellow2", 1, "BOT")
        self.NumArg2 = 0
    end
    return 1
end

function SCR_BUFF_LEAVE_BRACKEN431_SUBQ5_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end


--DCAPITAL_20_5_SQ_60_BUFF
function SCR_BUFF_ENTER_DCAPITAL_20_5_SQ_60_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_DCAPITAL_20_5_SQ_60_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

--DCAPITAL_20_5_SQ_90_BUFF
function SCR_BUFF_ENTER_DCAPITAL_20_5_SQ_90_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_DCAPITAL_20_5_SQ_90_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

--DCAPITAL_20_6_SQ_80_BUFF
function SCR_BUFF_ENTER_DCAPITAL_20_6_SQ_80_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_DCAPITAL_20_6_SQ_80_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end


--DCAPITAL_20_6_SQ_100_BUFF
function SCR_BUFF_ENTER_DCAPITAL_20_6_SQ_100_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_DCAPITAL_20_6_SQ_100_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

--WHITETREES23_1_SQ06_IMPETUS
function SCR_BUFF_ENTER_WHITETREES23_1_SQ06_IMPETUS(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, 'I_smoke013_dark3', 1, "MID")
end

function SCR_BUFF_LEAVE_WHITETREES23_1_SQ06_IMPETUS(self, buff, arg1, arg2, RemainTime, ret, over)
    DetachEffect(self, "I_smoke013_dark3")
end

--WHITETREES23_1_SQ12_BOSSHP
function SCR_BUFF_ENTER_WHITETREES23_1_SQ12_BOSSHP(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_UPDATE_WHITETREES23_1_SQ12_BOSSHP(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetHpPercent(self) > 0.9 then
        d_hp = self.MHP/5 * 2
        AddHP(self, -d_hp)
    end
    return 1
end

function SCR_BUFF_LEAVE_WHITETREES23_1_SQ12_BOSSHP(self, buff, arg1, arg2, RemainTime, ret, over)
end

--JOB_NECROMANCER7_1_ITEM_BUFF
function SCR_BUFF_ENTER_JOB_NECROMANCER7_1_ITEM_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, 'I_force019_pink', 2, "BOT")
    AttachEffect(self, 'F_ground12_red', 2, "BOT")
    --F_ground013
end

function SCR_BUFF_LEAVE_JOB_NECROMANCER7_1_ITEM_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    DetachEffect(self, "I_force019_pink")
    DetachEffect(self, "F_ground12_red")
    
    Kill(self)
end

--JOB_NECROMANCER7_1_ITEM_BUFF1
function SCR_BUFF_ENTER_JOB_NECROMANCER7_1_ITEM_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, 'I_force036_green', 5, "MID")
    AttachEffect(self, 'F_ground008_green', 3, "BOT")
end

function SCR_BUFF_UPDATE_JOB_NECROMANCER7_1_ITEM_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end

function SCR_BUFF_LEAVE_JOB_NECROMANCER7_1_ITEM_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, "F_spread_out037_violet_ice_leaf", 2.5, 1, "MID", 1)
    DetachEffect(self, "I_force036_green")
    DetachEffect(self, "F_ground008_green")
end


-- Event_1705_Schwarzereiter_Potion_Buff
function SCR_BUFF_ENTER_Event_1705_Schwarzereiter_Potion_Buff(self, buff, arg1, arg2, over)
    local mhpadd = 3000
    self.MHP_BM = self.MHP_BM + mhpadd;
end

function SCR_BUFF_LEAVE_Event_1705_Schwarzereiter_Potion_Buff(self, buff, arg1, arg2, over)
    local mhpadd = 3000
    self.MHP_BM = self.MHP_BM - mhpadd;
end

-- Haste_Buff_Evnet
function SCR_BUFF_ENTER_Haste_Buff_Evnet(self, buff, arg1, arg2, over)
    local mspdadd = 8
    
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    SetExProp(buff, "ADD_MSPD_Haste_Buff_Evnet", mspdadd);
end

function SCR_BUFF_LEAVE_Haste_Buff_Evnet(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD_Haste_Buff_Evnet");
    self.MSPD_BM = self.MSPD_BM - mspdadd;
end

-- Event_1705_Corsair_Potion_Buff
function SCR_BUFF_ENTER_Event_1705_Corsair_Potion_Buff(self, buff, arg1, arg2, over)
    local mspdadd = 5
    
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    SetExProp(buff, "ADD_MSPD_Event_1705_Corsair_Potion_Buff", mspdadd);
end

function SCR_BUFF_LEAVE_Event_1705_Corsair_Potion_Buff(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD_Event_1705_Corsair_Potion_Buff");
    self.MSPD_BM = self.MSPD_BM - mspdadd;
end

-- AroundHealHP_Dot_Event
function SCR_BUFF_ENTER_AroundHealHP_Dot_Event(self, buff, arg1, arg2, over)
    if IsPVPServer(self) == 1 then
        return
    end
    SCR_AROUNDHEAL_BUFF_UPDATE(self, 50, 'HP', 600, 5)
end

function SCR_BUFF_UPDATE_AroundHealHP_Dot_Event(self, buff, arg1, arg2, over)
    if IsPVPServer(self) == 1 then
        return 1
    end
    SCR_AROUNDHEAL_BUFF_UPDATE(self, 50, 'HP', 600, 5)
    return 1
end

function SCR_BUFF_LEAVE_AroundHealHP_Dot_Event(self, buff, arg1, arg2, over)
end


-- AroundHealSP_Dot_Event
function SCR_BUFF_ENTER_AroundHealSP_Dot_Event(self, buff, arg1, arg2, over)
    if IsPVPServer(self) == 1 then
        return
    end
    SCR_AROUNDHEAL_BUFF_UPDATE(self, 50, 'SP', 200, 5)
end

function SCR_BUFF_UPDATE_AroundHealSP_Dot_Event(self, buff, arg1, arg2, over)
    if IsPVPServer(self) == 1 then
        return 1
    end
    SCR_AROUNDHEAL_BUFF_UPDATE(self, 50, 'SP', 200, 5)
    return 1
end

function SCR_BUFF_LEAVE_AroundHealSP_Dot_Event(self, buff, arg1, arg2, over)
end

function SCR_AROUNDHEAL_BUFF_UPDATE(self, dist, healtype, healValue, maxhealCount)
    
    local objList, objCnt = GetWorldObjectList(self, "PC", dist)
    if healtype == 'HP' then
        Heal(self, healValue, 0)
    elseif healtype == 'SP' then
        HealSP(self, healValue, 0)
    end
    if objCnt > 0 then
        local pcList = {}
        for i = 1, objCnt do
            local obj = objList[i]
            if obj.ClassName == 'PC' and IsSameActor(self, obj) == 'NO' then
                pcList[#pcList + 1] = obj
            end
        end
        
        if #pcList > 0 then
            local maxIndex = #pcList
            for i = 1, maxIndex -1 do
                for x = i + 1, maxIndex do
                    if pcList[i].HP / pcList[i].MHP > pcList[x].HP / pcList[x].MHP then
                        local obj = pcList[i]
                        pcList[i] = pcList[x]
                        pcList[x] = obj
                    end
                end
            end
            
            if #pcList > 0 then
                local pcCount = 0
                for i = 1, #pcList do
                    if pcCount < maxhealCount then
                        if healtype == 'HP' then
                            Heal(pcList[i], healValue, 0)
                        elseif healtype == 'SP' then
                            HealSP(pcList[i], healValue, 0)
                        end
                    else
                        break
                    end
                end
            end
        end
    end
end



--JOB_WARLOCK_8_1_ITEM_BUFF1
function SCR_BUFF_ENTER_JOB_WARLOCK_8_1_ITEM_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_JOB_WARLOCK_8_1_ITEM_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    if IsDead(self) == 0 then
        PlayEffect(self, "F_spread_in005_dark", 0.5, 0, "BOT")
    end
end

--JOB_FEATHERFOOT_8_DEBUFF1
function SCR_BUFF_ENTER_JOB_FEATHERFOOT_8_DEBUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
--    PlayEffect(self, "I_wizard_DarkTheurge_darkball_loop", 0.5, 0, "BOT")
    AttachEffect(self, "F_pattern007_dark_loop", 1.5, "BOT")
end

function SCR_BUFF_UPDATE_JOB_FEATHERFOOT_8_DEBUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end

function SCR_BUFF_LEAVE_JOB_FEATHERFOOT_8_DEBUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, "F_hit003_light_dark_blue", 0.7, 0, "BOT")
    DetachEffect(self, "F_pattern007_dark_loop")
end

--JOB_FEATHERFOOT_8_BUFF1
function SCR_BUFF_ENTER_JOB_FEATHERFOOT_8_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_UPDATE_JOB_FEATHERFOOT_8_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, "F_circle020_light", 2.5, 1, "BOT", 1)
    
    return 1
end

function SCR_BUFF_LEAVE_JOB_FEATHERFOOT_8_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
end

--JOB_1_DAOSHI_BUFF1
function SCR_BUFF_ENTER_JOB_1_DAOSHI_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, "F_ground008_red", 3, "BOT")
end

function SCR_BUFF_UPDATE_JOB_1_DAOSHI_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, "F_burstup027_fire1", 6, 1, "BOT", 1)
    TakeDamage(self, self, "None", 50, "Melee", "Melee", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
    return 1
end

function SCR_BUFF_LEAVE_JOB_1_DAOSHI_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    DetachEffect(self, "F_ground008_red")
end

--JOB_1_DAOSHI_BUFF2
function SCR_BUFF_ENTER_JOB_1_DAOSHI_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, "F_ground008_blue", 3, "BOT")
end

function SCR_BUFF_UPDATE_JOB_1_DAOSHI_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, "F_explosion080_ice", 1.9, 1, "BOT", 1)
    TakeDamage(self, self, "None", 50, "Melee", "Melee", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
    return 1
end

function SCR_BUFF_LEAVE_JOB_1_DAOSHI_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
    DetachEffect(self, "F_ground008_blue")
end

--JOB_1_DAOSHI_BUFF3
function SCR_BUFF_ENTER_JOB_1_DAOSHI_BUFF3(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, "F_ground008_yellow", 3, "BOT")
end

function SCR_BUFF_UPDATE_JOB_1_DAOSHI_BUFF3(self, buff, arg1, arg2, RemainTime, ret, over)
    PlayEffect(self, "F_rize012_green_water", 1, 1, "BOT", 1)
    TakeDamage(self, self, "None", 50, "Melee", "Melee", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
    return 1
end

function SCR_BUFF_LEAVE_JOB_1_DAOSHI_BUFF3(self, buff, arg1, arg2, RemainTime, ret, over)
    DetachEffect(self, "F_ground008_yellow")
end

--JOB_3_DRUID_BUFF
function SCR_BUFF_ENTER_JOB_3_DRUID_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, "F_smoke019_dark_loop", 0.5, "BOT")
end

function SCR_BUFF_LEAVE_JOB_3_DRUID_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    DetachEffect(self, "F_smoke019_dark_loop")
end

--JOB_ENCHANTER_8_1_BUFF
function SCR_BUFF_ENTER_JOB_ENCHANTER_8_1_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_JOB_ENCHANTER_8_1_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

--JOB_INQUGITOR_8_1_BUFF1
function SCR_BUFF_ENTER_JOB_INQUGITOR_8_1_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, "F_smoke143_dark_red_loop", 0.8, "BOT")
end

function SCR_BUFF_LEAVE_JOB_INQUGITOR_8_1_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    DetachEffect(self, "F_smoke143_dark_red_loop")
end


--JOB_MUSKETEER_8_1_BUFF
function SCR_BUFF_ENTER_JOB_MUSKETEER_8_1_BUFF_BUFF(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_JOB_MUSKETEER_8_1_BUFF_BUFF(self, buff, arg1, arg2, over)
    
end

--LIMESTONECAVE_52_1_BUFF
function SCR_BUFF_ENTER_LIMESTONECAVE_52_1_BUFF(self, buff, arg1, arg2, over)
    SetNoDamage(self, 1)
end

function SCR_BUFF_LEAVE_LIMESTONECAVE_52_1_BUFF(self, buff, arg1, arg2, over)
    SetNoDamage(self, 0)
end



--MFL_NODAMAGE_BUFF
function SCR_BUFF_ENTER_MFL_NODAMAGE_BUFF(self, buff, arg1, arg2, over)
    SetNoDamage(self, 1)
end

function SCR_BUFF_LEAVE_MFL_NODAMAGE_BUFF(self, buff, arg1, arg2, over)
    SetNoDamage(self, 0)
end

--HT
function SCR_BUFF_ENTER_HT_3CMLAKE_84_BUCKET2_DEBUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_light013_spark', 3, 'MID');
end

function SCR_BUFF_UPDATE_HT_3CMLAKE_84_BUCKET2_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, 'F_smoke124_blue2', 0.5, 'BOT')
    AddStamina(self, -500)
    return 1
end

function SCR_BUFF_LEAVE_HT_3CMLAKE_84_BUCKET2_DEBUFF(self, buff, arg1, arg2, over)
    RemoveEffect(self, 'F_smoke124_blue2', 1)
end

--HT KLAPEDA_CAT
function SCR_BUFF_ENTER_HT_KLAPEDA_CAT_EMOTION(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_emoticon002', 3, 'TOP');
end

function SCR_BUFF_UPDATE_HT_KLAPEDA_CAT_EMOTION(self, buff, arg1, arg2, RemainTime, ret, over)

    return 1
end

function SCR_BUFF_LEAVE_HT_KLAPEDA_CAT_EMOTION(self, buff, arg1, arg2, over)
    RemoveEffect(self, 'I_emoticon002', 1)
end

--HT CATACOMB_04_SKULL
function SCR_BUFF_ENTER_HT_CATACOMB_04_SKULL(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_emoticon006', 3, 'TOP');
end

function SCR_BUFF_UPDATE_HT_CATACOMB_04_SKULL(self, buff, arg1, arg2, RemainTime, ret, over)

    return 1
end

function SCR_BUFF_LEAVE_HT_CATACOMB_04_SKULL(self, buff, arg1, arg2, over)
    RemoveEffect(self, 'I_emoticon006', 1)
end

--LOWLV_EYEOFBAIGA_SQ_40
function SCR_BUFF_ENTER_LOWLV_EYEOFBAIGA_SQ_40_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_LOWLV_EYEOFBAIGA_SQ_40_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
end

--LOWLV_EYEOFBAIGA_SQ_50
function SCR_BUFF_ENTER_LOWLV_EYEOFBAIGA_SQ_50_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, 'I_smoke038_blue', 1)
    ObjectColorBlend(self, 100, 100, 255, 180, 1, 3)
end

function SCR_BUFF_UPDATE_LOWLV_EYEOFBAIGA_SQ_50_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local result = SCR_QUEST_CHECK(self, 'LOWLV_EYEOFBAIGA_SQ_50')
    local pc_layer = GetLayer(self)
    if result == 'PROGRESS' then
        if pc_layer ~= 0 then
            return 1
        else
            return 0
        end
    else
        return 0
    end
end

function SCR_BUFF_LEAVE_LOWLV_EYEOFBAIGA_SQ_50_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    DetachEffect(self, 'I_smoke038_blue')
    ObjectColorBlend(self, 255, 255, 255, 255, 1, 1)
end

--TABLE281_HIDDENQ1_BUFF1
function SCR_BUFF_ENTER_TABLE281_HIDDENQ1_BUFF1(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_TABLE281_HIDDENQ1_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end

function SCR_BUFF_LEAVE_TABLE281_HIDDENQ1_BUFF1(self, buff, arg1, arg2, over)
end

--TABLE281_HIDDENQ1_BUFF2
function SCR_BUFF_ENTER_TABLE281_HIDDENQ1_BUFF2(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_TABLE281_HIDDENQ1_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end

function SCR_BUFF_LEAVE_TABLE281_HIDDENQ1_BUFF2(self, buff, arg1, arg2, over)
end


--TABLE281_HIDDENQ1_BUFF3
function SCR_BUFF_ENTER_TABLE281_HIDDENQ1_BUFF3(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_TABLE281_HIDDENQ1_BUFF3(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end

function SCR_BUFF_LEAVE_TABLE281_HIDDENQ1_BUFF3(self, buff, arg1, arg2, over)
end






--GR_CHAPEL_1_S7_RN_BOSS_RAGE
function SCR_BUFF_ENTER_GR_CHAPEL_1_S7_RN_BOSS_RAGE(self, buff, arg1, arg2, over)

    
    local patk_add = self.PATK_BM * over * 0.02
    local matk_add = self.MATK_BM * over * 0.01
    local mdef_add = self.MDEF_BM * over * 0.01
    local def_add = self.DEF_BM * over * 0.02
    
    
    self.PATK_BM = self.PATK_BM + patk_add;
    self.MATK_BM = self.MATK_BM + matk_add;
    self.MDEF_BM = self.MDEF_BM + mdef_add;
    self.DEF_BM = self.DEF_BM + def_add;
    
    SetExProp(buff, "GR_CHAPEL_1_S7_RAGE_PATK", patk_add)
    SetExProp(buff, "GR_CHAPEL_1_S7_RAGE_MATK", matk_add)
    SetExProp(buff, "GR_CHAPEL_1_S7_RAGE_MDEF", mdef_add)
    SetExProp(buff, "GR_CHAPEL_1_S7_RAGE_DEF", def_add)
    
    InvalidateStates(self)
end

function SCR_BUFF_LEAVE_GR_CHAPEL_1_S7_RN_BOSS_RAGE(self, buff, arg1, arg2, over)
    local patk_add = GetExProp(buff, "GR_CHAPEL_1_S7_RAGE_PATK")
    local matk_add = GetExProp(buff, "GR_CHAPEL_1_S7_RAGE_MATK")
    local mdef_add = GetExProp(buff, "GR_CHAPEL_1_S7_RAGE_MDEF")
    local def_add = GetExProp(buff, "GR_CHAPEL_1_S7_RAGE_DEF")

    self.PATK_BM = self.PATK_BM - patk_add;
    self.MATK_BM = self.MATK_BM - matk_add;
    self.MDEF_BM = self.MDEF_BM - mdef_add;
    self.DEF_BM = self.DEF_BM - def_add;
    
    InvalidateStates(self)
end





--GR_CHAPEL_1_S7_RN_BOSS_HEAL
function SCR_BUFF_ENTER_GR_CHAPEL_1_S7_RN_BOSS_HEAL(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_GR_CHAPEL_1_S7_RN_BOSS_HEAL(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetHpPercent(self) < 1 then
        local healHp = self.MHP*0.04
        AddHP(self, healHp)
    end
    return 1
end

function SCR_BUFF_LEAVE_GR_CHAPEL_1_S7_RN_BOSS_HEAL(self, buff, arg1, arg2, over)
end


--GR_CHAPEL_1_S7_RN_BOSS_RECALL
function SCR_BUFF_ENTER_GR_CHAPEL_1_S7_RN_BOSS_RECALL(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_GR_CHAPEL_1_S7_RN_BOSS_RECALL(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, cnt = SelectObjectByClassName(self, 300, 'PC')
    if cnt > 0 then
        local i
        for i = 1, cnt do
            if i == 3 then
                return 1
            end
            local x, y, z = GetPos(list[i])
            local mon = CREATE_MONSTER_EX(self, 'HiddenTrigger6', x, y, z, 0, 'Neutral', 1, GR_CHAPEL_1_S7_RN_BOSS_RECALL_RUN)
            AddScpObjectList(self, 'BOSS_RECALL', mon)
            AddScpObjectList(mon, 'BOSS_RECALL', self)
        end
    end
    
    return 1
end

function SCR_BUFF_LEAVE_GR_CHAPEL_1_S7_RN_BOSS_RECALL(self, buff, arg1, arg2, over)
end


function GR_CHAPEL_1_S7_RN_BOSS_RECALL_RUN(mon)
    mon.SimpleAI = 'GR_CHAPEL_1_S7_RN_BOSS_RECALL_RUN_1'
end

function GR_CHAPEL_1_S7_RN_BOSS_RECALL_IN(self)
    local obj = GetScpObjectList(self, 'BOSS_RECALL')
    local boss = nil
    if #obj == 0 then
        Kill(self)
    else
        boss = obj[1]
    end
    
    if self.NumArg4 < 6 then
        self.NumArg4 = self.NumArg4 + 1
        return 0
    end
    
    local list, cnt = SelectObjectByClassName(self, 100, 'PC')
    local zoneID = GetZoneInstID(self)
    if cnt > 0 then
        local i
        for i = 1, cnt do
            local x, y, z = GetActorByDirAnglePos(self, GetDirectionByAngle(boss), 50)
            if IsValidPos(zoneID, x, y, z) == 'YES' then
                if list[i] ~= nil and IsDead(list[i]) ~= 1 then
                    SetPos(list[i], x, y+25, z)
                end
            end
        end
    end
    
    Kill(self)
    
end



--MISSION_GELE_01_S5_WHIRLWIND
function SCR_BUFF_ENTER_MISSION_GELE_01_S5_WHIRLWIND(self, buff, arg1, arg2, over)
    PlayAnim(self, 'HIT', 1)
    SpinObject(self, 0, -1, 0.15, 0.1)
end

function SCR_BUFF_LEAVE_MISSION_GELE_01_S5_WHIRLWIND(self, buff, arg1, arg2, over)
    PlayAnim(self, 'ASTD', 1)
    SpinObject(self, 0, 0, 0, 2)
end

--HT2_ORCHARD_32_3_FRUITS_DEBUFF01
function SCR_BUFF_ENTER_HT2_ORCHARD_32_3_FRUITS_DEBUFF01(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_emoticon004', 3, 'TOP');
    AddStamina(self, -2000)
end

function SCR_BUFF_UPDATE_HT2_ORCHARD_32_3_FRUITS_DEBUFF01(self, buff, arg1, arg2, RemainTime, ret, over)

    return 1
end

function SCR_BUFF_LEAVE_HT2_ORCHARD_32_3_FRUITS_DEBUFF01(self, buff, arg1, arg2, over)
    RemoveEffect(self, 'I_emoticon004', 1)
end

--HT2_MAPLE_25_1_BONFIRE_BUFF
function SCR_BUFF_ENTER_HT2_MAPLE_25_1_BONFIRE_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_emoticon00'..IMCRandom(2,6), 2, 'TOP');
end

function SCR_BUFF_UPDATE_HT2_MAPLE_25_1_BONFIRE_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1
end

function SCR_BUFF_LEAVE_HT2_MAPLE_25_1_BONFIRE_BUFF(self, buff, arg1, arg2, over)
    RemoveEffect(self, 'I_emoticon002', 1)
    RemoveEffect(self, 'I_emoticon003', 1)
    RemoveEffect(self, 'I_emoticon004', 1)
    RemoveEffect(self, 'I_emoticon005', 1)
    RemoveEffect(self, 'I_emoticon006', 1)
end





--GM_CASTLE_01_RN_STONE_1
function SCR_BUFF_ENTER_GM_CASTLE_01_RN_STONE_1(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_GM_CASTLE_01_RN_STONE_1(self, buff, arg1, arg2, RemainTime, ret, over)
    if IsBuffApplied(self, buff.ClassName) == 'YES' then
        local over = GetBuffOver(self, buff.ClassName)
        if over <= 1 then
            return 0
        end
        AddBuff(self, self, buff.ClassName, 1, 0, 0, -1)
    end
    return 1
end

function SCR_BUFF_LEAVE_GM_CASTLE_01_RN_STONE_1(self, buff, arg1, arg2, over)
end


--GM_CASTLE_01_RN_STONE_2
function SCR_BUFF_ENTER_GM_CASTLE_01_RN_STONE_2(self, buff, arg1, arg2, over)
    SetRenderOption(self, "Stonize", 1);
end

function SCR_BUFF_LEAVE_GM_CASTLE_01_RN_STONE_2(self, buff, arg1, arg2, over)
    SetRenderOption(self, "Stonize", 0);
end


--GM_CASTLE_01_RN_DETECTOR_1
function SCR_BUFF_ENTER_GM_CASTLE_01_RN_DETECTOR_1(self, buff, arg1, arg2, over)
    
    local switch = GetExProp(self, 'ON_TRG')
    if switch == 0 or switch == nil then
        AttachEffect(self, 'F_light055_green', 5, 'MID')
    elseif switch == '1' then
        AttachEffect(self, 'F_light055_red', 5, 'MID')
    end
    

end

function SCR_BUFF_LEAVE_GM_CASTLE_01_RN_DETECTOR_1(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_light055_red')
    DetachEffect(self, 'F_light055_green')
end


--THORN392_SQ07_BUFF
function SCR_BUFF_ENTER_THORN39_2_SQ07_DEBUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_smoke009_green', 1.0, 'BOT')
    ObjectColorBlend(self, 155.0, 255.0, 155.0, 255.0, 1)
end

function SCR_BUFF_UPDATE_THORN39_2_SQ07_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local over = GetBuffOver(self, buff.ClassName)
    local damage = self.MHP*over*0.05
    TakeDamage(self, self, "None", damage, "Poison", "None", "TrueDamage", HIT_FIRE, HITRESULT_BLOW);
        if over >= 5 then
        RemoveBuff(self, 'THORN39_2_SQ07_DEBUFF')
        AddBuff(self, self, 'THORN39_2_SQ07_DEBUFF', 1, 0, 20000, 1)
        return 1
        end
    return 1
end

function SCR_BUFF_LEAVE_THORN39_2_SQ07_DEBUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'I_smoke009_green')
    ObjectColorBlend(self, 255.0, 255.0, 255.0, 255.0, 1)
end

--THORN39_1_SQ04_STUN
function SCR_BUFF_ENTER_THORN39_1_SQ04_STUN(self, buff, arg1, arg2, RemainTime, ret, over)
end

function SCR_BUFF_LEAVE_THORN39_1_SQ04_STUN(self, buff, arg1, arg2, RemainTime, ret, over)
end

--CHATHEDRAL54_HQ1_UNLOCK_BUFF
function SCR_BUFF_ENTER_CHATHEDRAL54_HQ1_UNLOCK_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
--print("CHATHEDRAL54_HQ1_UNLOCK_BUFF ENTER")
end

function SCR_BUFF_UPDATE_CHATHEDRAL54_HQ1_UNLOCK_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if IsBuffApplied(self, "Cryomancer_Freeze") == "YES" then
        return 1
    end
    return 0
end

function SCR_BUFF_LEAVE_CHATHEDRAL54_HQ1_UNLOCK_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
--print("CHATHEDRAL54_HQ1_UNLOCK_BUFF LEAVE")
end

--CHATHEDRAL54_HQ1_PRE_BUFF1
function SCR_BUFF_ENTER_CHATHEDRAL54_HQ1_PRE_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    --print("CHATHEDRAL54_HQ1_PRE_BUFF1 ENTER")
    AttachEffect(self, "F_smoke011_blue", 1, "MID")
end

function SCR_BUFF_UPDATE_CHATHEDRAL54_HQ1_PRE_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    local pc_sObj = GetSessionObject(self, "SSN_CHATHEDRAL54_HQ1_UNLOCK")
    if IsBuffApplied(self, "campfire_Buff") == "YES" then
        if pc_sObj ~= nil then
            local obj, list = GetWorldObjectList(self, "MON", 100)
            if list >= 1 then
                for i = 1 , list do
                    if obj[i].ClassName == "npc_saule_female_1" then
                        if obj[i].Dialog == "CHATHEDRAL54_SQ01_PART1" then
                            pc_sObj.Goal1 = 1
                            SaveSessionObject(self, pc_sObj)
                            Chat(obj[i], ScpArgMsg('CHATHEDRAL54_HIDDENQ1_MSG2'))
                            ShowBalloonText(self, "CHATHEDRAL54_HIDDENQ1_DLG1", 5)
                            return 0
                        end
                    end
                end
                return 0
            end
        end
    end
    return 1
end

function SCR_BUFF_LEAVE_CHATHEDRAL54_HQ1_PRE_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
--print("CHATHEDRAL54_HQ1_PRE_BUFF1 LEAVE")
    DetachEffect(self, "F_smoke011_blue")
end


--CATACOMB382_HIDDEN_BUFF
function SCR_BUFF_ENTER_CATACOMB382_HIDDEN_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    --print("CHATHEDRAL54_HQ1_PRE_BUFF1 ENTER")
--    AttachEffect(self, "F_smoke011_blue", 1, "MID")
end

function SCR_BUFF_LEAVE_CATACOMB382_HIDDEN_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
--print("CHATHEDRAL54_HQ1_PRE_BUFF1 LEAVE")
--    DetachEffect(self, "F_smoke011_blue")
end

--HT3_SIAULIAI_46_4_DRUM_DEBUFF01
function SCR_BUFF_ENTER_HT3_SIAULIAI_46_4_DRUM_DEBUFF01(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_emoticon004', 3, 'TOP');
end

function SCR_BUFF_UPDATE_HT3_SIAULIAI_46_4_DRUM_DEBUFF01(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_HT3_SIAULIAI_46_4_DRUM_DEBUFF01(self, buff, arg1, arg2, over)
    RemoveEffect(self, 'I_emoticon004')
end

--UNDER68_MQ4_ITEM1_BUFF
function SCR_BUFF_ENTER_UNDER68_MQ4_ITEM1_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_UNDER68_MQ4_ITEM1_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_UNDER68_MQ4_ITEM1_BUFF(self, buff, arg1, arg2, over)
end










--RCG_RAVAGE_HOST_1
function SCR_BUFF_ENTER_RCG_RAVAGE_HOST_1(self, buff, arg1, arg2, over)
    if IsBuffApplied(self, 'SoulDuel_DEF') == 'NO' then
        AddBuff(self, self, 'SoulDuel_DEF', 100, 0, 15000, 1)
    end
    
    if IsBuffApplied(self, 'RCG_RAVAGE_HOST_2') == 'NO' then
        AddBuff(self, self, 'RCG_RAVAGE_HOST_2', 100, 0, 15000, 1)
    end
end

function SCR_BUFF_LEAVE_RCG_RAVAGE_HOST_1(self, buff, arg1, arg2, over)
    if IsBuffApplied(self, 'SoulDuel_DEF') == 'YES' then
        RemoveBuff(self, 'SoulDuel_DEF')
    end
end


--RCG_RAVAGE_HOST_2
function SCR_BUFF_ENTER_RCG_RAVAGE_HOST_2(self, buff, arg1, arg2, over)


    local list, cnt = SelectObjectByClassName(self, 250, 'PC')
        local _pc
    if cnt > 0 then

        local i
        for i = 1, cnt do
            if IsBuffApplied(list[i], 'RCG_RAVAGE_HOST_2') == 'NO' then
                AddBuff(self, list[i], 'RCG_RAVAGE_HOST_2', 100, 0, 10000, 1)
                _pc = list[i]
                break
            end
        end
    end
    
    if _pc ~= nil then
        local zoneID = GetZoneInstID(self)
        local l_list, l_cnt = GetLayerPCList(zoneID, GetLayer(self))
        if l_cnt > 0 then
            local i
            for i = 1, l_cnt do
                SendAddOnMsg(l_list[i], "NOTICE_Dm_scroll", _pc.Name..ScpArgMsg("RCG_RAVAGE_HOST_2_MSG"), 10);
            end
        end
    end
    
end

function SCR_BUFF_LEAVE_RCG_RAVAGE_HOST_2(self, buff, arg1, arg2, over)
    if IsBuffApplied(self, 'RCG_RAVAGE_HOST_2') == 'YES' then
        RemoveBuff(self, 'RCG_RAVAGE_HOST_2')
    end
end


--CASTLE203_KQ_1_CHARGE
function SCR_BUFF_ENTER_CASTLE203_KQ_1_CHARGE(self, buff, arg1, arg2, over)
    local cnt = GetOver(buff)
    SendAddOnMsg(self, 'NOTICE_Dm_scroll', cnt..' / 15 {nl}'..ScpArgMsg('KQ_BUFFGETHER_MSG_PRG_1'), 8)
end

function SCR_BUFF_UPDATE_CASTLE203_KQ_1_CHARGE(self, buff, arg1, arg2, RemainTime, ret, over)
    local result = SCR_QUEST_CHECK(self, 'CASTLE203_KQ_1')
    if result == 'PROGRESS' or result == 'SUCCESS' then
        return 1;
    end
    return 0
end

function SCR_BUFF_LEAVE_CASTLE203_KQ_1_CHARGE(self, buff, arg1, arg2, over)

end



--FTOWER691_KQ_1_CHARGE
function SCR_BUFF_ENTER_FTOWER691_KQ_1_CHARGE(self, buff, arg1, arg2, over)
    local cnt = GetOver(buff)
    SendAddOnMsg(self, 'NOTICE_Dm_scroll', cnt..' / 15 {nl}'..ScpArgMsg('KQ_BUFFGETHER_MSG_PRG_1'), 8)
end

function SCR_BUFF_UPDATE_FTOWER691_KQ_1_CHARGE(self, buff, arg1, arg2, RemainTime, ret, over)
    local result = SCR_QUEST_CHECK(self, 'FTOWER691_KQ_1')
    if result == 'PROGRESS' or result == 'SUCCESS' then
        return 1;
    end
    return 0
end

function SCR_BUFF_LEAVE_FTOWER691_KQ_1_CHARGE(self, buff, arg1, arg2, over)

end






--FANTASYLIB481_SQ_1_SIGN
function SCR_BUFF_ENTER_FANTASYLIB481_SQ_1_SIGN(self, buff, arg1, arg2, over)
    AttachEffect(self, 'I_smoke_red2_loop', 2, 'MID')
end

function SCR_BUFF_LEAVE_FANTASYLIB481_SQ_1_SIGN(self, buff, arg1, arg2, over)

end





--F_3CMLAKE_85_MQ_09_STUN
function SCR_BUFF_ENTER_F_3CMLAKE_85_MQ_09_STUN(self, buff, arg1, arg2, RemainTime, ret, over)
    SkillCancel(self)
end

function SCR_BUFF_LEAVE_F_3CMLAKE_85_MQ_09_STUN(self, buff, arg1, arg2, RemainTime, ret, over)
end

--F_3CMLAKE_85_SQ_02_STUN
function SCR_BUFF_ENTER_F_3CMLAKE_85_SQ_02_STUN(self, buff, arg1, arg2, RemainTime, ret, over)
    AttachEffect(self, 'F_light094_blue_loop2', 3, 'TOP');
end

function SCR_BUFF_LEAVE_F_3CMLAKE_85_SQ_02_STUN(self, buff, arg1, arg2, RemainTime, ret, over)
    DetachEffect(self, 'F_light094_blue_loop2');
end


--F_3CMLAKE_85_SQ_02_FRENZY
function SCR_BUFF_ENTER_F_3CMLAKE_85_SQ_02_FRENZY(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff)
    if caster ~= nil then
        InsertHate(self, caster, 99999)
    end
end

function SCR_BUFF_UPDATE_F_3CMLAKE_85_SQ_02_FRENZY(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff)
    if caster ~= nil then
        if GetDistance(self, caster) <= 200 then
            InsertHate(self, caster, 9999)
            return 1
        else
            return 0
        end
    else
        return 1
    end
end

function SCR_BUFF_LEAVE_F_3CMLAKE_85_SQ_02_FRENZY(self, buff, arg1, arg2, over)
end

--F_3CMLAKE_86_MQ_03_TRANSFORM
function SCR_BUFF_ENTER_F_3CMLAKE_86_MQ_03_TRANSFORM(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Peaceful')
end

function SCR_BUFF_UPDATE_F_3CMLAKE_86_MQ_03_TRANSFORM(self, buff, arg1, arg2, RemainTime, ret, over)
    AddStamina(self, 99999);
    if GetLayer(self) ~= 0 then
        return 0
    end
    local result = SCR_QUEST_CHECK(self, 'F_3CMLAKE_86_MQ_03')
    if result == 'IMPPOSIBLE' or result == 'POSSIBLE' or result == 'COMPLETE' then
        return 0
    end
    if GetZoneName(self) ~= 'f_3cmlake_86' then
        return 0
    end
    return 1;
end

function SCR_BUFF_LEAVE_F_3CMLAKE_86_MQ_03_TRANSFORM(self, buff, arg1, arg2, over)
    PlayAnim(self, 'ASTD', 1)
    SetCurrentFaction(self, 'Law')
    TransformToMonster(self, "None", "None");
end


--F_3CMLAKE_86_MQ_04_BUFF
function SCR_BUFF_ENTER_F_3CMLAKE_86_MQ_04_BUFF(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_F_3CMLAKE_86_MQ_04_BUFF(self, buff, arg1, arg2, over)

end

--F_3CMLAKE_86_MQ_04_TRANSFORM
function SCR_BUFF_ENTER_F_3CMLAKE_86_MQ_04_TRANSFORM(self, buff, arg1, arg2, over)
    SetCurrentFaction(self, 'Peaceful')
end

function SCR_BUFF_UPDATE_F_3CMLAKE_86_MQ_04_TRANSFORM(self, buff, arg1, arg2, RemainTime, ret, over)
    AddStamina(self, 99999);
    if GetLayer(self) ~= 0 then
        return 0
    end
    local result = SCR_QUEST_CHECK(self, 'F_3CMLAKE_86_MQ_04')
    if result == 'IMPPOSIBLE' or result == 'POSSIBLE' or result == 'COMPLETE' then
        return 0
    end
    if GetZoneName(self) ~= 'f_3cmlake_86' then
        return 0
    end
    return 1;
end

function SCR_BUFF_LEAVE_F_3CMLAKE_86_MQ_04_TRANSFORM(self, buff, arg1, arg2, over)
    PlayAnim(self, 'ASTD', 1)
    SetCurrentFaction(self, 'Law')
    TransformToMonster(self, "None", "None");
end

--D_CATACOMB_80_GIMMICK_BUFF
function SCR_BUFF_ENTER_CATACOMB_80_HASTE(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + arg1;
end

function SCR_BUFF_UPDATE_CATACOMB_80_HASTE(self, buff, arg1, arg2, RemainTime, ret, over)
    local ZoneNameCheck = GetZoneName(self)
    if ZoneNameCheck == 'd_catacomb_80_1' or ZoneNameCheck == 'd_catacomb_80_2' or ZoneNameCheck == 'd_catacomb_80_3' then
        return 1;
    end
    return 0;
end

function SCR_BUFF_LEAVE_CATACOMB_80_HASTE(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - arg1;
end

function SCR_BUFF_ENTER_CATACOMB_80_ATK(self, buff, arg1, arg2, over)
    self.CRTATK_BM = self.CRTATK_BM + arg1
end

function SCR_BUFF_UPDATE_CATACOMB_80_ATK(self, buff, arg1, arg2, RemainTime, ret, over)
    local ZoneNameCheck = GetZoneName(self)
    if ZoneNameCheck == 'd_catacomb_80_1' or ZoneNameCheck == 'd_catacomb_80_2' or ZoneNameCheck == 'd_catacomb_80_3' then
        return 1;
    end
    return 0;
end

function SCR_BUFF_LEAVE_CATACOMB_80_ATK(self, buff, arg1, arg2, over)
    self.CRTATK_BM = self.CRTATK_BM - arg1
end

function SCR_BUFF_ENTER_CATACOMB_80_MATK(self, buff, arg1, arg2, over)
    self.MHR_BM = self.MHR_BM + arg1
end

function SCR_BUFF_UPDATE_CATACOMB_80_MATK(self, buff, arg1, arg2, RemainTime, ret, over)
    local ZoneNameCheck = GetZoneName(self)
    if ZoneNameCheck == 'd_catacomb_80_1' or ZoneNameCheck == 'd_catacomb_80_2' or ZoneNameCheck == 'd_catacomb_80_3' then
        return 1;
    end
    return 0;
end

function SCR_BUFF_LEAVE_CATACOMB_80_MATK(self, buff, arg1, arg2, over)
    self.MHR_BM = self.MHR_BM - arg1
end

function SCR_BUFF_ENTER_Event_1706_Doppelsoeldner_Potion_Buff(self, buff, arg1, arg2, over)
	self.DEF_BM = self.DEF_BM + 100;
	self.MDEF_BM = self.MDEF_BM + 100;
end

function SCR_BUFF_LEAVE_Event_1706_Doppelsoeldner_Potion_Buff(self, buff, arg1, arg2, over)
	self.DEF_BM = self.DEF_BM - 100;
	self.MDEF_BM = self.MDEF_BM - 100;
end

function SCR_BUFF_ENTER_Event_1706_Monk_Potion_Buff(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM + 100
	self.MATK_BM = self.MATK_BM + 100
end

function SCR_BUFF_LEAVE_Event_1706_Monk_Potion_Buff(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM - 100
	self.MATK_BM = self.MATK_BM - 100
end


--F_3CMLAKE262_SQ11_BUFF
function SCR_BUFF_ENTER_3CMLAKE262_SQ11_BUFF(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 66.0, 252.0, 233.0, 255.0, 1, 1)
    self.DEF_BM = self.DEF_BM - 20;
    self.ATK_BM = self.ATK_BM - 20;
    AttachEffect(self, 'F_drop_water001_alpha', 1, 'BOT');
end


function SCR_BUFF_UPDATE_3CMLAKE262_SQ11_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
--    ObjectColorBlend(self, 88.0, 238.0, 223.0, 200.0, 1, 1)
    TakeDamage(self, self, "None", 100, "Melee", "None", "AbsoluteDamage", HIT_REFLECT, HITRESULT_BLOW)
    return 1  
end

function SCR_BUFF_LEAVE_3CMLAKE262_SQ11_BUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_drop_water001_alpha')
    self.DEF_BM = self.DEF_BM + 20;
    self.ATK_BM = self.ATK_BM + 20;
end



--F_CO_OP_FINAL_MSPD
function SCR_BUFF_ENTER_F_CO_OP_FINAL_MSPD(self, buff, arg1, arg2, over)
    local mspdadd = 100
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    SetExProp(buff, "ADD_MSPD", mspdadd);
    InvalidateStates(self);
end

function SCR_BUFF_LEAVE_F_CO_OP_FINAL_MSPD(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");
  	self.MSPD_BM = self.MSPD_BM - mspdadd;
  	InvalidateStates(self);
end



--FD_STARTOWER762_EVENT2_BUFF
function SCR_BUFF_ENTER_FD_STARTOWER762_EVENT2_BUFF(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_FD_STARTOWER762_EVENT2_BUFF(self, buff, arg1, arg2, over)

end



--FD_STARTOWER762_EVENT4_BUFF
function SCR_BUFF_ENTER_FD_STARTOWER762_EVENT4_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_FD_STARTOWER762_EVENT4_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
	if GetZoneName(self) ~= 'd_startower_76_2' then
        return 0;
    else
        return 1
    end
end

function SCR_BUFF_LEAVE_FD_STARTOWER762_EVENT4_BUFF(self, buff, arg1, arg2, over)
end


--FD_STARTOWER762_EVENT4_DEBUFF
function SCR_BUFF_ENTER_FD_STARTOWER762_EVENT4_DEBUFF(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_explosion026_rize_green', 0.5, 'TOP');
	local mspdadd = self.MSPD * 0.50
	local patkadd = (self.Lv/3);
	local matkadd = (self.Lv/3);
	
	self.MSPD_BM = self.MSPD_BM - mspdadd

	self.PATK_BM = self.PATK_BM - patkadd
	self.MATK_BM = self.MATK_BM - matkadd
	
	SetExProp(buff, "ADD_MSPD", mspdadd);
	SetExProp(buff, "ADD_PATK", patkadd);
	SetExProp(buff, "ADD_MATK", matkadd);
		
	InvalidateStates(self);
end

function SCR_BUFF_LEAVE_FD_STARTOWER762_EVENT4_DEBUFF(self, buff, arg1, arg2, over)

	local mspdadd = GetExProp(buff, "ADD_MSPD");
	local patkadd = GetExProp(buff, "ADD_PATK");
	local matkadd = GetExProp(buff, "ADD_MATK");
	
	self.MSPD_BM = self.MSPD_BM + mspdadd;

	self.PATK_BM = self.PATK_BM + patkadd
	self.MATK_BM = self.MATK_BM + matkadd
		
	InvalidateStates(self);
end

function SCR_BUFF_ENTER_WTREES22_1_SUBQ2_BUFF1(self, buff, arg1, arg2, over)
    --PlayAnim(self, "OPEN")
end

function SCR_BUFF_UPDATE_WTREES22_1_SUBQ2_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_WTREES22_1_SUBQ2_BUFF1(self, buff, arg1, arg2, over)
    KILL_BLEND(self,2, 1)
    PlayEffect(self, "I_smoke054_white", 2, 1, "BOT")
    --PlayAnim(self, "CLOSE")
end

function SCR_BUFF_ENTER_WTREES22_1_SUBQ6_BUFF1(self, buff, arg1, arg2, over)
    --PlayAnim(self, "OPEN")
end

function SCR_BUFF_UPDATE_WTREES22_1_SUBQ6_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_WTREES22_1_SUBQ6_BUFF1(self, buff, arg1, arg2, over)
    --PlayAnim(self, "CLOSE")
end

--WTREES22_3_SUBQ3_BUFF1
function SCR_BUFF_ENTER_WTREES22_3_SUBQ3_BUFF1(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_WTREES22_3_SUBQ3_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == "f_whitetrees_22_3" then
        return 1;
    end
    return 0;
end

function SCR_BUFF_LEAVE_WTREES22_3_SUBQ3_BUFF1(self, buff, arg1, arg2, over)
    local quest = SCR_QUEST_CHECK(self, "WTREES22_3_SQ3")
    local list, cnt = SelectObject(self, 300, "ALL")
    if cnt >= 1 then
        for i = 1, cnt do
            if list[i].ClassName == "npc_foot_hold" then
                if list[i].Dialog == "WTREES22_3_SUBQ3_NPC1" then
                    PlayAnimLocal(list[i], self, "pull", 1)
                end
            end
        end
    end
    --print(isHideNPC(self, "WTREES22_3_SUBQ3_SUBNPC1"))
    if quest == "PROGRESS" then
        UnHideNPC(self, "WTREES22_3_SUBQ3_SUBNPC1")
    end
end

--WTREES22_3_SUBQ3_BUFF2
function SCR_BUFF_ENTER_WTREES22_3_SUBQ3_BUFF2(self, buff, arg1, arg2, over)
   
end

function SCR_BUFF_UPDATE_WTREES22_3_SUBQ3_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == "f_whitetrees_22_3" then
        return 1;
    end
    return 0;
end

function SCR_BUFF_LEAVE_WTREES22_3_SUBQ3_BUFF2(self, buff, arg1, arg2, over)
    local quest = SCR_QUEST_CHECK(self, "WTREES22_3_SQ3")
    local list, cnt = SelectObject(self, 300, "ALL")
    if cnt >= 1 then
        for i = 1, cnt do
            if list[i].ClassName == "npc_foot_hold" then
                if list[i].Dialog == "WTREES22_3_SUBQ3_NPC2" then
                    PlayAnimLocal(list[i], self, "pull", 1)
                end
            end
        end
    end
    if quest == "PROGRESS" then
        UnHideNPC(self, "WTREES22_3_SUBQ3_SUBNPC2")
    end
end

--WTREES22_3_SUBQ3_BUFF3
function SCR_BUFF_ENTER_WTREES22_3_SUBQ3_BUFF3(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_WTREES22_3_SUBQ3_BUFF3(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == "f_whitetrees_22_3" then
        return 1;
    end
    return 0;
end

function SCR_BUFF_LEAVE_WTREES22_3_SUBQ3_BUFF3(self, buff, arg1, arg2, over)
    local quest = SCR_QUEST_CHECK(self, "WTREES22_3_SQ3")
    local list, cnt = SelectObject(self, 300, "ALL")
    if cnt >= 1 then
        for i = 1, cnt do
            if list[i].ClassName == "npc_foot_hold" then
                if list[i].Dialog == "WTREES22_3_SUBQ3_NPC3" then
                    PlayAnimLocal(list[i], self, "pull", 1)
                end
            end
        end
    end
    if quest == "PROGRESS" then
        UnHideNPC(self, "WTREES22_3_SUBQ3_SUBNPC3")
    end
end

--WTREES22_3_SUBQ3_BUFF4
function SCR_BUFF_ENTER_WTREES22_3_SUBQ3_BUFF4(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_WTREES22_3_SUBQ3_BUFF4(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == "f_whitetrees_22_3" then
        return 1;
    end
    return 0;
end

function SCR_BUFF_LEAVE_WTREES22_3_SUBQ3_BUFF4(self, buff, arg1, arg2, over)
    local quest = SCR_QUEST_CHECK(self, "WTREES22_3_SQ3")
    local list, cnt = SelectObject(self, 300, "ALL")
    if cnt >= 1 then
        for i = 1, cnt do
            if list[i].ClassName == "npc_foot_hold" then
                if list[i].Dialog == "WTREES22_3_SUBQ3_NPC4" then
                    PlayAnimLocal(list[i], self, "pull", 1)
                end
            end
        end
    end
    if quest == "PROGRESS" then
        UnHideNPC(self, "WTREES22_3_SUBQ3_SUBNPC4")
    end
end

--WTREES22_3_SUBQ3_BUFF5
function SCR_BUFF_ENTER_WTREES22_3_SUBQ3_BUFF5(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_WTREES22_3_SUBQ3_BUFF5(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == "f_whitetrees_22_3" then
        return 1;
    end
    return 0;
end

function SCR_BUFF_LEAVE_WTREES22_3_SUBQ3_BUFF5(self, buff, arg1, arg2, over)
    local quest = SCR_QUEST_CHECK(self, "WTREES22_3_SQ3")
    local list, cnt = SelectObject(self, 300, "ALL")
    if cnt >= 1 then
        for i = 1, cnt do
            if list[i].ClassName == "npc_foot_hold" then
                if list[i].Dialog == "WTREES22_3_SUBQ3_NPC5" then
                    PlayAnimLocal(list[i], self, "pull", 1)
                end
            end
        end
    end
    if quest == "PROGRESS" then
        UnHideNPC(self, "WTREES22_3_SUBQ3_SUBNPC5")
    end
end

--WTREES22_3_SUBQ5_BUFF1
function SCR_BUFF_ENTER_WTREES22_3_SUBQ5_BUFF1(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_WTREES22_3_SUBQ5_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_WTREES22_3_SUBQ5_BUFF1(self, buff, arg1, arg2, over)
end

--WTREES22_3_SUBQ7_DEVICE_BUFF
function SCR_BUFF_ENTER_WTREES22_3_SUBQ7_DEVICE_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_WTREES22_3_SUBQ7_DEVICE_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local quest = SCR_QUEST_CHECK(self, "WTREES22_3_SQ7")
    if quest == "PROGRESS" then
        local list, cnt = SelectObject(self, 200, "ALL", 1)
        if cnt > 0 then
            for i = 1, cnt do
                if list[i].ClassName == "prison_device_1" then
                    if list[i].Dialog == "WTREES22_3_SUBQ7_DEVICENPC" then
                       PlayEffectLocal(list[i], self, "F_light028_blue2", 1.5, nil, "TOP")
                    end
                end
            end
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_WTREES22_3_SUBQ7_DEVICE_BUFF(self, buff, arg1, arg2, over)
end

--ABBEY22_4_SUBQ4_BUFF
function SCR_BUFF_ENTER_ABBEY22_4_SUBQ4_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, "F_smoke019_dark_loop", 0.4, "MID")
end

function SCR_BUFF_UPDATE_ABBEY22_4_SUBQ4_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_ABBEY22_4_SUBQ4_BUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, "F_smoke019_dark_loop")
end

--ABBEY22_5_SUBQ2_BUFF
function SCR_BUFF_ENTER_ABBEY22_5_SUBQ2_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_ABBEY22_5_SUBQ2_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_ABBEY22_5_SUBQ2_BUFF(self, buff, arg1, arg2, over)
end

--ABBEY22_5_SUBQ5_BUFF
function SCR_BUFF_ENTER_ABBEY22_5_SUBQ5_BUFF(self, buff, arg1, arg2, over)
    AttachEffect(self, 'F_smoke011_blue', 2.0, 'MID')
    --SetCurrentFaction(self, 'Peaceful')
end

function SCR_BUFF_UPDATE_ABBEY22_5_SUBQ5_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    AddStamina(self, 99999);
    
    if GetZoneName(self) == 'd_abbey_22_5' then
        local result1 = SCR_QUEST_CHECK(self, 'ABBEY22_5_SQ5')
        local result2 = SCR_QUEST_CHECK(self, 'ABBEY22_5_SQ7')
        if result1 == 'PROGRESS' then
            if GetCurrentFaction(self) == 'Law' then
                SetCurrentFaction(self, 'Peaceful')
            end
            return 1
        elseif result2 == 'PROGRESS' then
            if GetCurrentFaction(self) == 'Law' then
                SetCurrentFaction(self, 'Peaceful')
            end
            return 1
        end
    end
    return 0;
end

function SCR_BUFF_LEAVE_ABBEY22_5_SUBQ5_BUFF(self, buff, arg1, arg2, over)
    DetachEffect(self, 'F_smoke011_blue')
    SetCurrentFaction(self, 'Law')
    
    local _obj = GetScpObjectList(self, 'ABBEY22_5_SUBQ5_SCPOBJ');
    if #_obj >= 1 then
        local i
        for i = 1, #_obj do
            Kill(_obj[i])
        end
    end
    PlayEffect(self, 'I_smoke058_violet', 2.0, nil, 'BOT')
end

--ABBEY22_5_SUBQ10_BUFF1
function SCR_BUFF_ENTER_ABBEY22_5_SUBQ10_BUFF1(self, buff, arg1, arg2, over)
    AttachEffect(self, "I_emo_confuse", 2,"TOP")
end

function SCR_BUFF_UPDATE_ABBEY22_5_SUBQ10_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_ABBEY22_5_SUBQ10_BUFF1(self, buff, arg1, arg2, over)
    DetachEffect(self, "I_emo_confuse")
    KILL_BLEND(self, 1, 1)
    StopMove(self)
    StopAnim(self)
end

--ABBEY22_5_SUBQ10_BUFF2
function SCR_BUFF_ENTER_ABBEY22_5_SUBQ10_BUFF2(self, buff, arg1, arg2, over)
    AttachEffect(self, "F_ground008_red", 2,"BOT")
end

function SCR_BUFF_UPDATE_ABBEY22_5_SUBQ10_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_ABBEY22_5_SUBQ10_BUFF2(self, buff, arg1, arg2, over)
    DetachEffect(self, "F_ground008_red")
end

--ABBEY22_5_SUBQ12_BUFF1
function SCR_BUFF_ENTER_ABBEY22_5_SUBQ12_BUFF1(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_ABBEY22_5_SUBQ12_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_ABBEY22_5_SUBQ12_BUFF1(self, buff, arg1, arg2, over)
    
end

--ABBEY22_5_SUBQ14_BUFF1
function SCR_BUFF_ENTER_ABBEY22_5_SUBQ14_BUFF1(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_ABBEY22_5_SUBQ14_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    if IsBuffApplied(self, "ABBEY22_5_SUBQ14_BUFF3") == "NO" then
        if IsBuffApplied(self, "ABBEY22_5_SUBQ14_BUFF2") == "NO" then
            if self.NumArg1 < 120 then
               self.NumArg1 = self.NumArg1 + 1
            elseif  self.NumArg1 >= 120 then
                AddBuff(self, self, "ABBEY22_5_SUBQ14_BUFF2", 1, 0, 0 ,1)
                self.NumArg1 = 0
            end
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_ABBEY22_5_SUBQ14_BUFF1(self, buff, arg1, arg2, over)
    
end

--ABBEY22_5_SUBQ14_BUFF2
function SCR_BUFF_ENTER_ABBEY22_5_SUBQ14_BUFF2(self, buff, arg1, arg2, over)
    local atkadd = 1.2
    local defadd = 1.2
    local mdefadd = 1.2
    
    self.ATKRate = self.ATKRate + atkadd;
    self.DEFRate = self.DEFRate + defadd
    self.MDEFRate = self.MDEFRate + mdefadd
    
    SetExProp(buff, "ADD_ATK", atkadd);
    SetExProp(buff, "ADD_DEF", defadd);
    SetExProp(buff, "ADD_MDEF", mdefadd);
    
end

function SCR_BUFF_UPDATE_ABBEY22_5_SUBQ14_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_ABBEY22_5_SUBQ14_BUFF2(self, buff, arg1, arg2, over)
    local atkadd = GetExProp(buff, "ADD_ATK");
    local defadd = GetExProp(buff, "ADD_DEF");
    local mdefadd = GetExProp(buff, "ADD_MDEF");
    
    self.ATKRate = self.ATKRate - atkadd;
    self.DEFRate = self.DEFRate - defadd;
    self.MDEFRate = self.MDEFRate - mdefadd;
end

--ABBEY22_5_SUBQ14_BUFF3
function SCR_BUFF_ENTER_ABBEY22_5_SUBQ14_BUFF3(self, buff, arg1, arg2, over)
    SkillCancel(self);
    PlayAnim(self, "stun")
    PlayEffect(self, "F_rize001", 1, nil, "BOT")
end

function SCR_BUFF_UPDATE_ABBEY22_5_SUBQ14_BUFF3(self, buff, arg1, arg2, RemainTime, ret, over)
    if IsBuffApplied(self, "ABBEY22_5_SUBQ14_BUFF2") == "YES" then
        RemoveBuff(self, "ABBEY22_5_SUBQ14_BUFF2")
    end
    return 1;
end

function SCR_BUFF_LEAVE_ABBEY22_5_SUBQ14_BUFF3(self, buff, arg1, arg2, over)
    
end

--ABBEY22_5_SUBQ14_BUFF4
function SCR_BUFF_ENTER_ABBEY22_5_SUBQ14_BUFF4(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_ABBEY22_5_SUBQ14_BUFF4(self, buff, arg1, arg2, RemainTime, ret, over)
    print(self.NumArg1)
    if self.NumArg1 < 180 then
        self.NumArg1 = self.NumArg1 + 1
    elseif self.NumArg1 >= 180 then
        if self.NumArg2 < 1 then
            AttachEffect(self, "F_light110_pink_ground_loop", 0.7, 1, "TOP")
            self.NumArg2 = 1
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_ABBEY22_5_SUBQ14_BUFF4(self, buff, arg1, arg2, over)
    
end

--ID_WHITETREES1_GIMMICK1_BUFF
function SCR_BUFF_ENTER_ID_WHITETREES1_GIMMICK1_BUFF(self, buff, arg1, arg2, over)
    local mspdadd = 3;
    
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    SetExProp(buff, "ADD_MSPD", mspdadd);
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
end

function SCR_BUFF_UPDATE_ID_WHITETREES1_GIMMICK1_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'id_whitetrees1' then
        return 1;
    else
        return 0;
    end
end

function SCR_BUFF_LEAVE_ID_WHITETREES1_GIMMICK1_BUFF(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM - mspdadd;

end

--ID_WHITETREES1_GIMMICK2_BUFF2
function SCR_BUFF_ENTER_ID_WHITETREES1_GIMMICK2_BUFF2(self, buff, arg1, arg2, over)
    local damage = 3000;
    SetBuffArgs(buff, damage, 0, 0)
end

function SCR_BUFF_UPDATE_ID_WHITETREES1_GIMMICK2_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'id_whitetrees1' then
        return 1;
    else
        return 0;
    end
end

function SCR_BUFF_LEAVE_ID_WHITETREES1_GIMMICK2_BUFF2(self, buff, arg1, arg2, over)

end

--ID_WHITETREES1_GIMMICK2_BUFF2
function SCR_BUFF_ENTER_ID_WHITETREES1_GIMMICK3_BUFF(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_ID_WHITETREES1_GIMMICK3_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == 'id_whitetrees1' then
        return 1;
    else
        return 0;
    end
end

function SCR_BUFF_LEAVE_ID_WHITETREES1_GIMMICK3_BUFF(self, buff, arg1, arg2, over)
end

-- JOB_SHADOWMANCER_SHADOW_TRAP

function SCR_BUFF_ENTER_JOB_SHADOWMANCER_SHADOW_TRAP(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_JOB_SHADOWMANCER_SHADOW_TRAP(self, buff, arg1, arg2, over)
end


-- JOB_SHADOWMANCER_CHANGE_SHADOW
function SCR_BUFF_ENTER_JOB_SHADOWMANCER_CHANGE_SHADOW(self, buff, arg1, arg2, over)
    SetShadowRender(self, 0);
    ObjectColorBlend(self, 255, 255, 255, 0)
    self.Jumpable = self.Jumpable -2;
end



function SCR_BUFF_UPDATE_JOB_SHADOWMANCER_CHANGE_SHADOW(self, buff, arg1, arg2, RemainTime, ret, over)
    local layer = GetLayer(self)
    if layer == 0 then
        return 0
    else
        local x, y, z = GetPos(self);    
        PlayEffectToGround(self, "F_wizard_ShadowPool_shot", x, y, z, 1, 1);
        return 1;
    end
end



function SCR_BUFF_LEAVE_JOB_SHADOWMANCER_CHANGE_SHADOW(self, buff, arg1, arg2, over)
    local x, y, z = GetPos(self);   
    PlayEffectToGround(self, "F_arcehr_Spoliation_spread_in2", x, y, z, 1, 1);
    SetShadowRender(self, 1);
    self.Jumpable = self.Jumpable +2;
    ObjectColorBlend(self, 255, 255, 255, 255)
end



--JOB_SHADOWMANCER_Q1_BUFF

function SCR_BUFF_ENTER_JOB_SHADOWMANCER_Q1_BUFF(self, buff, arg1, arg2, over)
    local sObj_main = GetSessionObject(self, 'ssn_klapeda')
    local failcount = sObj_main['JOB_SHADOWMANCER_Q1_FC']
    local mspdadd = 30 + math.floor(failcount / 10);
    self.FIXMSPD_BM = mspdadd;
    Invalidate(self, 'MSPD')
    SetBuffArgs(buff, mspdadd, 0, 0);
    EnableItemUse(self, 0)
end


function SCR_BUFF_UPDATE_JOB_SHADOWMANCER_Q1_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local layer = GetLayer(self)
    if layer ~= 0 then
--        print(self.MSPD_BM, self.FIXMSPD_BM)
--        local mspdadd = GetBuffArgs(buff);
--        if self.FIXMSPD_BM ~= mspdadd then
--            self.FIXMSPD_BM = 10;
--            Invalidate(self, 'MSPD');
--            print(self.MSPD_BM, self.FIXMSPD_BM)
--        end
        local sta = GetStamina(self)
        local maxsta = GetMaxStamina(self)
        if maxsta - 900 >= sta then
            AddStamina(self, maxsta)
        end
        return 1
    else
        return 0
    end
    return 1;
end


function SCR_BUFF_LEAVE_JOB_SHADOWMANCER_Q1_BUFF(self, buff, arg1, arg2, over)
    self.FIXMSPD_BM = 0
    Invalidate(self, 'MSPD')
    EnableItemUse(self, 1)
end

--CHAR318_MSETP3_1_EFFECT_BUFF1
function SCR_BUFF_ENTER_CHAR318_MSETP3_1_EFFECT_BUFF1(self, buff, arg1, arg2, over)
    AttachEffect(self, "F_light096_red_loop2", 5, 1, "TOP")
end

function SCR_BUFF_UPDATE_CHAR318_MSETP3_1_EFFECT_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_CHAR318_MSETP3_1_EFFECT_BUFF1(self, buff, arg1, arg2, over)
    DetachEffect(self, "F_light096_red_loop2")
end

--CHAR318_MSETP3_3_EFFECT_BUFF1
function SCR_BUFF_ENTER_CHAR318_MSETP3_3_EFFECT_BUFF1(self, buff, arg1, arg2, over)
    AttachEffect(self, "I_circle001", 11, 1, "BOT",1)
end

function SCR_BUFF_UPDATE_CHAR318_MSETP3_3_EFFECT_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetZoneName(self) == "f_katyn_45_1" then
        local obj, cnt = GetWorldObjectList(self, "MON", 60)
        local sObj = GetSessionObject(self, "SSN_BULLETMARKER_UNLOCK")
        if cnt >= 1 then
            for i = 1, cnt do
                if obj[i].ClassName == "Hiddennpc_Q5" then
                    for j = 1, 20 do
                        if obj[i].Dialog == "HIDDEN_STONE_KATYN451_"..j then
                            if sObj["Goal"..j] >= 1 then
                                local ston_Item = GetInvItemCount(self, "HIDDEN_BULLET_MSTEP3_3_1ITEM1")
                                PlayEffectLocal(obj[i],self, "I_rize010_orange", 2, 1, "MID", 1)
                                if ston_Item < 2 then
                                    sObj.Step10 = sObj.Step10 + 1
                                    if sObj.Step10 >= 5 then
                                        sObj.Step10 = 0
                                        SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("CHAR318_MSETP3_3_EFFECT_BUFF1_MSG"), 5)
                                        return 1;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        return 1
    end
    return 0;
end

function SCR_BUFF_LEAVE_CHAR318_MSETP3_3_EFFECT_BUFF1(self, buff, arg1, arg2, over)
    DetachEffect(self, "I_circle001")
end

--CHAR318_MSETP3_1_EFFECT_BUFF1
function SCR_BUFF_ENTER_CHAR318_MSETP3_1_EFFECT_BUFF1(self, buff, arg1, arg2, over)
    AttachEffect(self, "F_light096_red_loop2", 5, 1, "TOP")
end

function SCR_BUFF_UPDATE_CHAR318_MSETP3_1_EFFECT_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_CHAR318_MSETP3_1_EFFECT_BUFF1(self, buff, arg1, arg2, over)
    DetachEffect(self, "F_light096_red_loop2")
end

--JOB_MATADOR1_ITEM_BUFF1
function SCR_BUFF_ENTER_JOB_MATADOR1_ITEM_BUFF1(self, buff, arg1, arg2, over)
    SetEmoticon(self, 'I_emo_infection')
end

function SCR_BUFF_UPDATE_JOB_MATADOR1_ITEM_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_JOB_MATADOR1_ITEM_BUFF1(self, buff, arg1, arg2, over)
    HideEmoticon(self, 'I_emo_infection')
    BT_RETURN_TO_HOME(self)
end

--JOB_MATADOR1_TRAP1_BUFF
function SCR_BUFF_ENTER_JOB_MATADOR1_TRAP1_BUFF(self, buff, arg1, arg2, over)
    ResetHated(self)
    ResetHateAndAttack(self);
    CancelMonsterSkill(self);
    SetCurrentFaction(self, "Neutral");
    self.StrArg1 = "NEUTRAL"
end

function SCR_BUFF_UPDATE_JOB_MATADOR1_TRAP1_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    StopMove(self)
    PlayEffect(self, "F_sys_heart", 1, 1, "TOP", 1)
    return 1;
end

function SCR_BUFF_LEAVE_JOB_MATADOR1_TRAP1_BUFF(self, buff, arg1, arg2, over)
    self.BTree = "BasicMonster"
    BT_RETURN_TO_HOME(self)
end

--JOB_MATADOR1_TRAP2_BUFF
function SCR_BUFF_ENTER_JOB_MATADOR1_TRAP2_BUFF(self, buff, arg1, arg2, over)
    local mspdadd = self.MSPD * 0.7
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    SetExProp(buff, "ADD_MSPD", mspdadd);
end

function SCR_BUFF_UPDATE_JOB_MATADOR1_TRAP2_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_JOB_MATADOR1_TRAP2_BUFF(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM + mspdadd;
end

--JOB_MATADOR1_ITEM_BUFF2
function SCR_BUFF_ENTER_JOB_MATADOR1_ITEM_BUFF2(self, buff, arg1, arg2, over)
    local mspdadd = self.MSPD + 1
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    SetExProp(buff, "ADD_MSPD", mspdadd);
end

function SCR_BUFF_UPDATE_JOB_MATADOR1_ITEM_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
    AddStamina(self, 9999);
    return 1;
end

function SCR_BUFF_LEAVE_JOB_MATADOR1_ITEM_BUFF2(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM - mspdadd;
end

--JOB_MATADOR1_ITEM_BUFF3
function SCR_BUFF_ENTER_JOB_MATADOR1_ITEM_BUFF3(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_JOB_MATADOR1_ITEM_BUFF3(self, buff, arg1, arg2, RemainTime, ret, over)
    if self.ClassName == 'PC' then
        if GetLayer(self) < 1 then
            return 0;
        else
            TakeDamage(self, self, "None", 100, "Poison", "None", "TrueDamage", HIT_POISON, HITRESULT_BLOW, 0, 0);
        end
    elseif self.ClassName == "stub_tree" or self.ClassName == "TreeAmbulo" or self.ClassName == "Tama" then
        local pc_list, cnt = GetLayerPCList(self)
        if cnt > 0 then
    	    for i = 1, cnt do
                if pc_list[i].ClassName == "PC" then
                    SendAddOnMsg(pc_list[i], ScpArgMsg("JOB_MATADOR1_ITEM_MSG11"), 5)
                    break;
                end
            end
        end
        Dead(self)
    end
    return 1;
end

function SCR_BUFF_LEAVE_JOB_MATADOR1_ITEM_BUFF3(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_FRIGHT_DEBUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        if IS_PC(self) == true then
            PlayPose(self, 16);
        end
    end
end

function SCR_BUFF_ENTER_FRIGHT_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local i
        local list, cnt = SelectObject(self, 100, "ENEMY");
        for i = 1, cnt do
            local obj = list[i];
            if IS_PC(obj) == true then
                AddBuff(caster, obj, 'FRIGHT_DEBUFF', 1, 0, 1500, 1);
            end
        end
    end
end

--AGARIO_BUFF
function SCR_BUFF_ENTER_AGARIO_BUFF(self, buff, arg1, arg2, over)
    SendSkillQuickSlot(self, 1, 'Agario_CandyDash')
    ChangeNormalAttack(self, "Agario_Attack");

    SetCurrentFaction(self, "Pvp");
	BroadcastRelation(self);

    SetDeadScript(self, "SCR_AGARIO_DEAD")
    EnableResurrect(self, false);

    self.FIXMSPD_BM = 45
    Invalidate(self, 'MSPD');

    local normalAttackList = {};
    normalAttackList[#normalAttackList + 1] = "Agario_Attack";
    normalAttackList[#normalAttackList + 1] = "Agario_Attack2";
    normalAttackList[#normalAttackList + 1] = "Agario_Attack3";
    normalAttackList[#normalAttackList + 1] = "Agario_Attack4";
    normalAttackList[#normalAttackList + 1] = "Agario_CandyDash";
    normalAttackList[#normalAttackList + 1] = "Agario_Attack2";
    normalAttackList[#normalAttackList + 1] = "Agario_Attack3";
    normalAttackList[#normalAttackList + 1] = "Agario_Attack4";
    normalAttackList[#normalAttackList + 1] = "Agario_CandyDash";
    for i = 1 , #normalAttackList do
        local norm = normalAttackList[i];
        AddInstSkill(self, norm)
        local normalSkl = GetSkill(self, norm);
        if normalSkl ~= nil then
            AddLimitationSkillList(self, norm);
        end
    end
    
    EnableItemUse(self, 0)
    if IS_PC(self) == true then
        EnablePreviewSkillRange(self, 1);
    end
    
    AddBuff(self, self, 'Safe', 1, 0, 30000, 1);
    
    EquipDummyItemSpot(self, self, 633072, 'OUTER', 0, 1);
    EquipDummyItemSpot(self, self, 10009, 'HELMET', 0, 1);
end

function SCR_BUFF_UPDATE_AGARIO_BUFF(self, buff, arg1, arg2, RemainTime, ret, over)
    if IS_IN_EVENT_MAP(self) == true then
        local itemCount = GetInvItemCount(self, "AGARIO_CANDY_DUNGEON");
        if IsDead(self) ~= 1 then
            if itemCount > 30 then
                SetTitle(self, itemCount)
            else
                SetTitle(self, '')
            end
            if  itemCount <= 30 then
                if GetChangeNormalAttackName(self) ~= "Agario_Attack" then
                    ChangeNormalAttack(self, "Agario_Attack");
                    SetRenderOption(self, "bigheadmode", 0);
                end
            elseif itemCount >= 31 and itemCount < 100 then
                if GetChangeNormalAttackName(self) ~= "Agario_Attack2" then
                    ChangeNormalAttack(self, "Agario_Attack2");
                    AddLimitationSkillList(self, "Agario_Attack2");
                    SetRenderOption(self, "bigheadmode", 1);
                end
            elseif itemCount >= 100 and itemCount < 150 then
                if GetChangeNormalAttackName(self) ~= "Agario_Attack3" then
                    ChangeNormalAttack(self, "Agario_Attack3")
                    AddLimitationSkillList(self, "Agario_Attack3");
                    SetRenderOption(self, "bigheadmode", 1);
                end
            elseif itemCount >= 150 then
                if GetChangeNormalAttackName(self) ~= "Agario_Attack4" then
                    ChangeNormalAttack(self, "Agario_Attack4")
                    AddLimitationSkillList(self, "Agario_Attack4");
                    SetRenderOption(self, "bigheadmode", 1);
                end
            end
        end
        
        local addValue = 0
        if itemCount < 50 then
        elseif itemCount < 100 then
            addValue = 20
        elseif itemCount < 150 then
            addValue = 60
        else
            addValue = 120
        end
        local F_MSPD = math.floor(9200/(itemCount+200 + addValue))
        local F_MSPD_BUFF = 0
        if IsBuffApplied(self, 'Agario_Haste') == 'YES' then
            F_MSPD_BUFF = 10 - math.floor(addValue/15)
        end
        self.FIXMSPD_BM = F_MSPD + F_MSPD_BUFF
        Invalidate(self, 'MSPD');
        return 1;
    else
        return 0;
    end
end

function SCR_BUFF_LEAVE_AGARIO_BUFF(self, buff, arg1, arg2, over)
    SendSkillQuickSlot(self, 0)
    ChangeNormalAttack(self, "None");
    ClearLimitationSkillList(self);
    self.FIXMSPD_BM = 0
    Invalidate(self, 'MSPD');
    EnableItemUse(self, 1)
    if IS_PC(self) == true then
        EnablePreviewSkillRange(self, 0);
    end
    EquipDummyItemSpot(self, self, 0, 'OUTER', 0, 0)
    EquipDummyItemSpot(self, self, 0, 'HELMET', 0, 0)
end

function SCR_BUFF_ENTER_Agario_Haste(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Agario_Haste(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_Agario_silence(self, buff, arg1, arg2, over)
    ShowEmoticon(self, 'I_emo_silence', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_LEAVE_Agario_silence(self, buff, arg1, arg2, over)
    HideEmoticon(self, 'I_emo_silence')
end

--CHAR118_MSTEP2_ITEM1_BUFF1
function SCR_BUFF_ENTER_CHAR118_MSTEP2_ITEM1_BUFF1(self, buff, arg1, arg2, over)
    SendAddOnMsg(self, 'NOTICE_Dm_scroll',ScpArgMsg('RETIARII_STAMINA_CHARGE'), 5)
    SetExProp(self, "CHAR118_REST_TIME", 1);
end

function SCR_BUFF_UPDATE_CHAR118_MSTEP2_ITEM1_BUFF1(self, buff, arg1, arg2, over)
    local sObj = GetSessionObject(self, "SSN_RETIARII_UNLOCK")
    local sit_Buff = GetBuffByName(self, 'SitRest')
    local rest_Time = GetExProp(self, "CHAR118_REST_TIME")
    if sit_Buff ~= nil then
        rest_Time = rest_Time + 1
        SetExProp(self, "CHAR118_REST_TIME", rest_Time);
        PlayEffect(self, "F_light013", 1, 3, "BOT")
        print("rest_Time : "..rest_Time)
    end
    if GetBuffRemainTime(buff) > 0 then
        if rest_Time >= 60 then
            sObj.Step1 = 60
            PlayEffect(self, "F_light018", 1, 1, "BOT")
            sObj.Step22 = 1
            sObj.Step2 = sObj.Step2 + 1
            SaveSessionObject(self, sObj)
            return 0;
        end
    elseif GetBuffRemainTime(buff) <= 0 then
        if rest_Time >= 60 then
            sObj.Step1 = 60
            --Chat(self, sObj.Step1)
        else
            sObj.Step1 = 50
            --Chat(self, sObj.Step1)
        end
        sObj.Step22 = 1
        sObj.Step2 = sObj.Step2 + 1
        SaveSessionObject(self, sObj)
        return 0;
    end
    return 1;
end

function SCR_BUFF_LEAVE_CHAR118_MSTEP2_ITEM1_BUFF1(self, buff, arg1, arg2, over)
    local sObj = GetSessionObject(self, "SSN_RETIARII_UNLOCK")
    local rest_Time = GetExProp(self, "CHAR118_REST_TIME")
    if GetBuffRemainTime(buff) > 0 then
        if rest_Time >= 60 then
            sObj.Step1 = 60
        end
    elseif GetBuffRemainTime(buff) <= 0 then
        if rest_Time >= 60 then
            sObj.Step1 = 60
            --Chat(self, sObj.Step1)
        else
            sObj.Step1 = 50
            --Chat(self, sObj.Step1)
        end
        sObj.Step22 = 1
        sObj.Step2 = sObj.Step2 + 1
        SaveSessionObject(self, sObj)
    end
    PlayEffect(self, "F_light018", 1, 1, "BOT")
end

--CHAR118_MSTEP2_2_ITEM1_BUFF1
function SCR_BUFF_ENTER_CHAR118_MSTEP2_2_ITEM1_BUFF1(self, buff, arg1, arg2, over)
    local sObj = GetSessionObject(self, "SSN_RETIARII_UNLOCK")
    if sObj ~= nil then
        if sObj.Step2 == 1 then
            self.FIXMSPD_BM = 20
        elseif sObj.Step2 == 2 then
            self.FIXMSPD_BM = 23
        elseif sObj.Step2 == 3 then
            self.FIXMSPD_BM = 26
        elseif sObj.Step2 == 4 then
            self.FIXMSPD_BM = 30
        elseif sObj.Step2 >= 5 then
            self.FIXMSPD_BM = 35
        end
        InvalidateMSPD(self);
    end
end

function SCR_BUFF_UPDATE_CHAR118_MSTEP2_2_ITEM1_BUFF1(self, buff, arg1, arg2, over)
    if GetZoneName(self) == "f_farm_47_1" then
        local sObj = GetSessionObject(self, "SSN_RETIARII_UNLOCK")
        --print(sObj.Step7)
        local ridingCompanion = GetRidingCompanion(self);
        if ridingCompanion ~= nil then
            RideVehicle(self, ridingCompanion, 0)
            SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("RETIARII_TRAINING_COMPANION_NOT"), 6)
        end
        if sObj.Step6 == 0 then
            local goal_group = IMCRandom(1, 3)
            sObj.Step7 = goal_group
            sObj.Step6 = 1
            for i = 1, 3 do
                if isHideNPC(self, "RETIARII_ENDURANDE_TRAINING_GOAL"..goal_group.."_"..i) == "YES" then
                    UnHideNPC(self, "RETIARII_ENDURANDE_TRAINING_GOAL"..goal_group.."_"..i)
                end
            end
        end
        return 1
    else
        local sObj = GetSessionObject(self, "SSN_RETIARII_UNLOCK")
        if sObj ~= nil then
            sObj.Step6 = 0
            local goal_group = sObj.Step7
            SaveSessionObject(self, sObj)
            self.FIXMSPD_BM = 0
            InvalidateMSPD(self);
            for i = 1, 3 do
                if isHideNPC(self, "RETIARII_ENDURANDE_TRAINING_GOAL"..goal_group.."_"..i) == "NO" then
                    HideNPC(self, "RETIARII_ENDURANDE_TRAINING_GOAL"..goal_group.."_"..i)
                end
            end
            return 0
        end
    end
    return 0
end

function SCR_BUFF_LEAVE_CHAR118_MSTEP2_2_ITEM1_BUFF1(self, buff, arg1, arg2, over)
    local sObj = GetSessionObject(self, "SSN_RETIARII_UNLOCK")
    if sObj ~= nil then
        sObj.Step6 = 0
        local goal_group = sObj.Step7
        SaveSessionObject(self, sObj)
        for i = 1, 3 do
            if isHideNPC(self, "RETIARII_ENDURANDE_TRAINING_GOAL"..goal_group.."_"..i) == "NO" then
                HideNPC(self, "RETIARII_ENDURANDE_TRAINING_GOAL"..goal_group.."_"..i)
                --Chat(self, "RETIARII_ENDURANDE_TRAINING_GOAL"..goal_group.."_"..i, 1)
            end
        end
    end
    self.FIXMSPD_BM = 0
    InvalidateMSPD(self);
end

--CHAR118_AGILITY_TRAINING_BUFF
function SCR_BUFF_ENTER_CHAR118_AGILITY_TRAINING_BUFF(self, buff, arg1, arg2, over)
    SetEmoticon(self, 'I_emo_exclamation')
end

function SCR_BUFF_LEAVE_CHAR118_AGILITY_TRAINING_BUFF(self, buff, arg1, arg2, over)
    SetEmoticon(self, 'None')
end

--GM_WHITETREES_MON_BUFF1
function SCR_BUFF_ENTER_GM_WHITETREES_MON_BUFF1(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_GM_WHITETREES_MON_BUFF1(self, buff, arg1, arg2, over)
    return 1
end

function SCR_BUFF_LEAVE_GM_WHITETREES_MON_BUFF1(self, buff, arg1, arg2, over)

end

--GM_WHITETREES_MON_BUFF2
function SCR_BUFF_ENTER_GM_WHITETREES_MON_BUFF2(self, buff, arg1, arg2, over)
    local add = 1
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + add;
    self.MATK_RATE_BM = self.MATK_RATE_BM + add;
    
    SetExProp(buff, "ADD_ATK", add);
end


function SCR_BUFF_LEAVE_GM_WHITETREES_MON_BUFF2(self, buff, arg1, arg2, over)
    local add = GetExProp(buff, "ADD_ATK");
    
    self.PATK_RATE_BM = self.PATK_RATE_BM - add;
    self.MATK_RATE_BM = self.MATK_RATE_BM - add;
end

--GM_WHITETREES_MON_BUFF3
function SCR_BUFF_ENTER_GM_WHITETREES_MON_BUFF3(self, buff, arg1, arg2, over)

end


function SCR_BUFF_LEAVE_GM_WHITETREES_MON_BUFF3(self, buff, arg1, arg2, over)

end

--GM_WHITETREES_GIMMICK_MON1_BUFF1
function SCR_BUFF_ENTER_GM_WHITETREES_GIMMICK_MON1_BUFF1(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_GM_WHITETREES_GIMMICK_MON1_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff); 
    if caster == nil then
        local casterHandler = GetMGameValue(self, 'casterHandle')
        local zoneInst = GetZoneInstID(self)
        caster = GetByHandle(zoneInst, casterHandler)
    end
    if GetZoneName(self) == "mission_whitetrees_56_1" then
        if IsDead(self) == 0 then
            PlayEffect(self, "F_rize015_1_yellow_drop", 1, "BOT")
            local buff_stack = GetOver(buff)
            if self.ClassName == "GM_Obelisk" then
                if buff_stack < 3 then
                    TakeDamage(caster, self, "None", 200000*buff_stack, "Melee", "Melee", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
                else
                    TakeDamage(caster, self, "None", 700000, "Melee", "Melee", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
                end
            else
                if buff_stack < 3 then
                    TakeDamage(caster, self, "None", 10000*buff_stack, "Melee", "Melee", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
                else
                    TakeDamage(caster, self, "None", 150000, "Melee", "Melee", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
                end
            end
        elseif IsDead(self) == 1 then
            local obj, obj_Cnt = SelectObjectByClassName(self, 25, 'Link_stone_small')
            if obj_Cnt < 1 then
                return 0
            end
        end
        return 1
    end
end

function SCR_BUFF_LEAVE_GM_WHITETREES_GIMMICK_MON1_BUFF1(self, buff, arg1, arg2, over)
    
end

--GM_WHITETREES_DEFFENCE_OBJ_BUFF
function SCR_BUFF_ENTER_GM_WHITETREES_DEFFENCE_OBJ_BUFF(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_GM_WHITETREES_DEFFENCE_OBJ_BUFF(self, buff, arg1, arg2, over)
    
end

--GM_WHITETREES_MON_BUFF1_1
function SCR_BUFF_ENTER_GM_WHITETREES_MON_BUFF1_1(self, buff, arg1, arg2, over)
    self.ATK_BM = self.ATK_BM - arg1 * 2;
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.MINMATK, caster.MAXMATK, 0);
    end
end

function SCR_BUFF_UPDATE_GM_WHITETREES_MON_BUFF1_1(self, buff, arg1, arg2, over)
    if GetZoneName(self) == "mission_whitetrees_56_1" then
        local casterMINMATK, casterMAXMATK = GetBuffArgs(buff);
        local caster = GetBuffCaster(buff);
        if caster == nil then
            local casterHandler = GetMGameValue(self, 'casterHandle')
            local zoneInst = GetZoneInstID(self)
            caster = GetByHandle(zoneInst, casterHandler)
        end
        
        TakeDamage(caster, self, "None", (casterMINMATK + casterMAXMATK) / IMCRandom(7, 10), "Poison", "None", "TrueDamage", HIT_POISON, HITRESULT_BLOW, 0, 0, 1);
        
        return 1;
    end
end

function SCR_BUFF_LEAVE_GM_WHITETREES_MON_BUFF1_1(self, buff, arg1, arg2, over)
    self.ATK_BM = self.ATK_BM + arg1 * 2;
end

--GM_WHITETREES_BUFF1_1
function SCR_BUFF_ENTER_GM_WHITETREES_BUFF1_1(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_GM_WHITETREES_BUFF1_1(self, buff, arg1, arg2, over)
end