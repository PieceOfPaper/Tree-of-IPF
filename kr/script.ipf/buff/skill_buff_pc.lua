--skill_buff_pc.lua

function SCR_SKILL_BUFF(self, from, skill, splash, ret)    
    NO_HIT_RESULT(ret);
    local buffName = 'None';
    if skill.TargetBuff ~= 'None' then
        buffName = skill.TargetBuff;
    elseif skill.SelfBuff ~= 'None' then
        buffName = skill.SelfBuff;
        RemoveBuff(from, buffName);
    end
    
    if buffName == 'buffName' then
        return;
    end

    local ratioFuncName = 'SCR_GET_' .. buffName .. '_Ratio2';
    local over = 1;
    if IsFunc(ratioFuncName) == 1 then
        local func = _G[ratioFuncName];
        local MaxOver = func(skill, from);
        if 1 == IsOverBuff(from, buffName, MaxOver) then
            return;
        end
    end

    local applyTime = Get_SKill_BUFFTIME(from, self, buffName);
    local funcName = 'SCR_' .. skill.ClassName .. '_BUFFTIME';
    if IsFunc(funcName) == 1 then
        local func = _G[funcName];
        applyTime = func(from, self, skill);
    end

    applyTime = applyTime + GET_ADD_BUFFTIME(self, from, buffName);


    local buff = AddBuff(from, self, buffName, skill.Level, 0, applyTime, 1,skill.ClassID);
    
    if nil == buff then
        return;
    end
    
    if buff.LinkBuff == 'NO' or buff.LinkBuff == 'No' then
        return;
    end
    
    CHECK_SHAREBUFF_BUFF(self, buff, skill.Level, 0, applyTime, over, 100);

    local linkBuff = GetBuffByName(self, 'Link_Party');
    if linkBuff == nil then
        return;
    end

    local linkCaster =  GetBuffCaster(linkBuff);
    if linkCaster == nil then
        return;
    end
    
    local objList = GetLinkObjects(linkCaster, self, 'Link_Party');     
    if objList ~= nil then
        for i = 1, #objList do
            local partyMember = objList[i];
            ADDBUFF(self, partyMember, buffName, skill.Level, 0, applyTime, over, 100);
        end
    end
        
end

function CHECK_SHAREBUFF_BUFF(self, buff, arg1, arg2, time, over, rate)

    if buff == nil then
        return;
    end

    if buff.LinkBuff ~= 'YES' then
        return;
    end

    local range = 150;
    local partyBuff = GetBuffByName(self, 'ShareBuff_Buff');
    if partyBuff ~= nil then

        local shareBuffCaster = GetBuffCaster(partyBuff);
        if shareBuffCaster == nil then
            return;
        end

        local list, cnt = GetPartyMemberList(self, PARTY_NORMAL, range);
        for i = 1, cnt do
            local partyMember = list[i];
            local checkBuff = GetBuffByName(partyMember, 'ShareBuff_Buff');
            if checkBuff ~= nil then
                local checkCaster = GetBuffCaster(checkBuff);
                if IsSameActor(shareBuffCaster, checkCaster) == "YES" and IsSameActor(self, partyMember) == "NO"then
                    ADDBUFF(self, partyMember, buff.ClassName, arg1, arg2, time, over, rate);
                end
            end
        end

        local list, cnt = GetPartyMemberList(self, PARTY_GUILD, range)
        for i = 1, cnt do
            local partyMember = list[i];
            local checkBuff = GetBuffByName(partyMember, 'ShareBuff_Buff');
            if checkBuff ~= nil then
                local checkCaster = GetBuffCaster(checkBuff);
                if IsSameActor(shareBuffCaster, checkCaster) == "YES" and IsSameActor(self, partyMember) == "NO" then
                    ADDBUFF(self, partyMember, buff.ClassName, arg1, arg2, time, over, rate);
                end
            end
        end
    end
end

function Get_SKill_BUFFTIME(self, from, buffName)
    
    local time = 10000;     
    local buffCls = GetClass("Buff", buffName);
    if buffCls ~= nil then
        time = buffCls.ApplyTime;
    end

    return time;
end



function GET_ADD_BUFFTIME(self, from, buffName)
    if buffName == nil or buffName == 'None' then
        return 0;
    end
        
    local isDebuff = false;
    local bufCls = GetClass("Buff", buffName);      
    if bufCls ~= nill and bufCls.Group1 == "Debuff" then
        isDebuff = true;
    end


    local bonusTime = 0;
    if isDebuff == true then

        if IsSameActor(self, from) == 'NO' then
            bonusTime = bonusTime + GET_ABIL_LEVEL(from, "DebuffReduce") * (-2000);
        end
        
    end

    local warcryAbil = GetAbility(self, 'Barbarian2');
    if warcryAbil ~= nil and 'Warcry_Buff' == buffName then
        bonusTime = bonusTime + warcryAbil.Level * 2000;
    end
    return bonusTime;
end


function SCR_BUFF_ENTER_TeleCast(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_TeleCast(self, buff, arg1, arg2, over)  
    if over <= 1 then
        PlayAnim(self, "SKL_TELEKINESIS_RETURN", 0, 1, 0, 1);
    end
end



function SCR_BUFF_ENTER_TurnUndead_Debuff(self, buff, arg1, arg2, over)
    
end
function SCR_BUFF_UPDATE_TurnUndead_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    if self.Size == "XL" then
        return 0;
    end
    
    return 1;
    
end
function SCR_BUFF_LEAVE_TurnUndead_Debuff(self, buff, arg1, arg2, over)
    if (self.RaceType == "Velnias" or self.RaceType == "Paramune") and self.Size ~= "XL" then
        local caster = GetBuffCaster(buff);
        if GetSkill(caster, 'Paladin_TurnUndead') then
            TakeTrueDamage(caster, self, 'Paladin_TurnUndead', self.HP + 1, HIC_BASIC, HITRESULT_BLOW);
        else
            KillCountDead(self, caster, buff.ClassName)
        end
    end
end


function SCR_BUFF_ENTER_Dekatos_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Dekatos_Buff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster == nil then
        return;
    end
    
    if IS_PC(self) == true then
        return;
    end
    
    local rate = 10;
    
    local casterMNA = TryGetProp(caster, 'MNA');
    if casterMNA == nil then
        casterMNA = 1;
    end
    
    local enemyLv = TryGetProp(self, 'Lv');
    if enemyLv == nil then
        enemyLv = 1;
    end

    local addRate = (casterMNA / (enemyLv * 2)) * 10;
    addRate = math.min(math.max(0, addRate), rate);
    
    rate = rate + addRate;
    
    local random = IMCRandom(1, 100);
    if rate >= random then
        if self.MonRank ~= "Boss" then
            local skill = GetSkill(caster, 'Pardoner_Dekatos');
            if skill ~= nil then
                Dead(self, 0, caster);
--                TakeDamage(caster, self, skill.ClassName, self.HP + 1, skill.Attribute, skill.AttackType, 'AbsoluteDamage', HIC_BASIC, HITRESULT_NO_HITSCP);
            else
                KillCountDead(self, caster, buff.ClassName)
            end
        end
    end
end



function SCR_BUFF_ENTER_PainBarrier_Buff(self, buff, arg1, arg2, over)
    local abil = GetAbility(self, 'Doppelsoeldner3');
    if abil ~= nil then
        self.MSPD_BM = self.MSPD_BM + (abil.Level * 0.05);
        self.DR_BM = self.DR_BM - (abil.Level * 0.1);
    end
end

function SCR_BUFF_LEAVE_PainBarrier_Buff(self, buff, arg1, arg2, over)
    local abil = GetAbility(self, 'Doppelsoeldner3');
    if abil ~= nil then
        self.MSPD_BM = self.MSPD_BM - (abil.Level * 0.05);
        self.DR_BM = self.DR_BM + (abil.Level * 0.1);
    end
end



function SCR_Swordman_PainBarrier_BUFFTIME(self, from, skill)
    local abil = GetAbility(self, 'Swordman29')
    local time = 14000 + skill.Level * 1000
    if abil ~= nil then
        time = time + 5000
    end
    return time;
end


function SCR_Doppelsoeldner_DeedsOfValor_BUFFTIME(self, from, skill)
    
    local time = 20000 + skill.Level * 3000
    return time;
end


function SCR_Scout_Cloaking_BUFFTIME(self, from, skill)
    
    local time = 20000 + skill.Level * 3000
    return time;
end

function SCR_Barbarian_Frenzy_BUFFTIME(self, from, skill)
    
    local time = 30000 + skill.Level * 2000

    return time;
end


function SCR_Ranger_SteadyAim_BUFFTIME(self, from, skill)
    
    local time = 10000;

    return time;
end


function SCR_Cataphract_Trot_BUFFTIME(self, from, skill)
    
    local time = 20000 + skill.Level * 2000

    return time;
end

function SCR_Rancer_Commence_BUFFTIME(self, from, skill)
    
    local time = 10000 + skill.Level * 3000

    return time;
end

function SCR_Hackapell_HakkaPalle_BUFFTIME(self, from, skill)
    
    local time = 45000

    return time;
end

function SCR_Hackapell_HackapellCharge_BUFFTIME(self, from, skill)
    
    local time = 300000

    return time;
end

function SCR_Schwarzereiter_EvasiveAction_BUFFTIME(self, from, skill)
    
    local time = 300000

    return time;
end


function SCR_Thaumaturge_Transpose_BUFFTIME(self, from, skill)
    
    local time = 50000 + skill.Level * 10000

    return time;
end


function SCR_Archer_SwiftStep_BUFFTIME(self, from, skill)
    
    local time = 300000
    return time;
end

function SCR_QuarrelShooter_RunningShot_BUFFTIME(self, from, skill)
    local time = 300000
    return time;
end

function SCR_Rogue_SneakHit_BUFFTIME(self, from, skill)

    local time = skill.Level * 4000 + 30000;

    local Rogue1_abil = GetAbility(self, 'Rogue1');
    if Rogue1_abil ~= nil then
        time = time + 2000* Rogue1_abil.Level
    end
    
    return time;
end

function SCR_Rogue_Evasion_BUFFTIME(self, from, skill)
    
    local time = skill.Level * 1000 + 15000;
    return time;
end

function SCR_Barbarian_Savagery_BUFFTIME(self, from, skill)
    
    local time = 40000
    return time;
end

function SCR_Corsair_SubweaponCancel_BUFFTIME(self, from, skill)
    
    local time = 300000
    return time;
end

function SCR_Wizard_Surespell_BUFFTIME(self, from, skill)
    
    local time = 300000
    return time;
end

function SCR_Wizard_QuickCast_BUFFTIME(self, from, skill)
    
    local time = 300000
    return time;
end




function SCR_Warrior_Provoke_BUFFTIME(self, from, skill)
    
    local time = 2000
    return time;
end



function SCR_Barbarian_Aggressor_BUFFTIME(self, from, skill)
    
    local time = 20000 + skill.Level * 2000
    return time;
end



function SCR_Swordman_GungHo_BUFFTIME(self, from, skill)
--    local time = 60000 + skill.Level * 5000
    local time = 300000
    return time;
end

function SCR_Peltasta_Guardian_BUFFTIME(self, from, skill)
    local time = 17000 + skill.Level * 3000
    return time;
end


function SCR_Swordman_Restrain_BUFFTIME(self, from, skill)
    
  local time = 30000 + skill.Level * 3000
    
    return time
end



function SCR_Warrior_Parrying_BUFFTIME(self, from, skill)
    
    local time = 50000 + skill.Level * 10000
    return time;
    
end

function SCR_Ranger_SpiralArrow_BUFFTIME(self, from, skill)
    local time = 10000
    return time;
end

function SCR_Corsair_Looting_BUFFTIME(self, from, skill)
    local time = 9000 + skill.Level * 1000
    return time;
end

function SCR_Featherfoot_Levitation_BUFFTIME(self, from, skill)
    
    local time = 30000 + skill.Level * 2000

    return time;
end


-- FirePillar_Debuff
function SCR_BUFF_ENTER_FirePillar_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_FirePillar_Debuff(self, buff, arg1, arg2, over, isLastEnd)

end



function SCR_BUFF_ENTER_MagnusExorcismus_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);

    local skill = GET_MON_SKILL(caster, 'Chaplain_MagnusExorcismus');   
    local damage = GET_SKL_DAMAGE(caster, self, 'Chaplain_MagnusExorcismus');

    local divineAtkAdd = skill.SkillAtkAdd
    local addValue = 0
    
    local pad = GetPadByBuff(caster, buff);
    if pad ~= nil then
        addValue = GetPadArgNumber(pad, 1);
    end
    
    divineAtkAdd = addValue - divineAtkAdd
    
    if divineAtkAdd < 0 then
        divineAtkAdd = 0;
    end
    
    TakeDamage(caster, self, "Chaplain_MagnusExorcismus", damage + divineAtkAdd)
end

function SCR_BUFF_LEAVE_MagnusExorcismus_Debuff(self, buff, arg1, arg2, over, isLastEnd)

end



function SCR_BUFF_ENTER_GravityPole_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_GravityPole_Debuff(self, buff, arg1, arg2, over, isLastEnd)

end


function SCR_BUFF_ENTER_ReduceCraftTime_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_ReduceCraftTime_Buff(self, buff, arg1, arg2, over, isLastEnd)

end


function SCR_BUFF_ENTER_BattleOrders_Buff(self, buff, arg1, arg2, over)

    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

end

function SCR_BUFF_LEAVE_BattleOrders_Buff(self, buff, arg1, arg2, over, isLastEnd)
    
end




function SCR_BUFF_ENTER_Frenzy_Buff(self, buff, arg1, arg2, over)
    PlaySound(self, "skl_eff_frenzy_up")
    if over == 1 then
        ResetLastAttackTarget(self);
        SetExProp(buff, 'FRENZY_TARGET', 0);
    end
    
    local dgatk = 0.015;
    
    dgatk = dgatk * over;
    
    local atkSpd = 150 + (arg1 * 10)

    self.PATK_RATE_BM = self.PATK_RATE_BM + dgatk;
    SetExProp(buff, "ADD_ATK", dgatk);

    SET_NORMAL_ATK_SPEED(self, -atkSpd);
    SetExProp(buff, "ADD_ATKSPD", atkSpd);

    
    local skill = GetUsingSkill(self);
    if skill ~= nil and GetExProp(buff, 'BUFF_PARENT_SKILLID') == 0 then
        SetExProp(buff, 'BUFF_PARENT_SKILLID', skill.ClassID);
    end
end

function SCR_BUFF_LEAVE_Frenzy_Buff(self, buff, arg1, arg2, over)
    local dgatk = GetExProp(buff, "ADD_ATK")
    local atkSpd = GetExProp(buff, "ADD_ATKSPD")
    
    self.PATK_RATE_BM = self.PATK_RATE_BM - dgatk
    SET_NORMAL_ATK_SPEED(self, atkSpd)
end



-- Stop_Debuff
function SCR_BUFF_ENTER_Stop_Debuff(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_immobilize', 0)

    local defencedBM = 0;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local Chronomancer4_abil = GetAbility(caster, 'Chronomancer4');
        if self.Size == 'XL' then
            if GetExProp(self, 'USED_WIZ_STOP') == 0 and Chronomancer4_abil ~= nil then
                defencedBM = 1;
                SetExProp(self, 'USED_WIZ_STOP', 1)
            else
                SetExProp(self, 'STOP_REMOVE', 1)
                return ;
            end
        else
            defencedBM = 1;
        end
    end
    
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    SetExProp(buff, 'DEFENCED_BM', defencedBM);
    self.MaxDefenced_BM = self.MaxDefenced_BM + defencedBM;

    SetExProp(self, 'ImmuneBuff', 1);
end

function SCR_BUFF_UPDATE_Stop_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    if GetExProp(self, 'STOP_REMOVE') == 1 then
        DelExProp(self, 'STOP_REMOVE')
        return 0;
    end
    
    return 1;

end

function SCR_BUFF_LEAVE_Stop_Debuff(self, buff, arg1, arg2, over)

    DelExProp(self, 'ImmuneBuff');

   -- HideEmoticon(self, 'I_emo_immobilize')

    local defencedBM = GetExProp(buff, 'DEFENCED_BM');
    self.MaxDefenced_BM = self.MaxDefenced_BM - defencedBM;
end

-- Maze_Debuff
function SCR_BUFF_ENTER_Maze_Debuff(self, buff, arg1, arg2, over)
    --SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    SetExProp(self, 'ImmuneBuff', 1);
end

function SCR_BUFF_UPDATE_Maze_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    
    if caster ~= nil then
        local damage = GET_SKL_DAMAGE(caster, self, 'Sage_Maze');
        local skill = GET_MON_SKILL(caster, 'Sage_Maze');
        TakeDamage(caster, self, skill.ClassName, damage);
    end
    
    return 1;

end

function SCR_BUFF_LEAVE_Maze_Debuff(self, buff, arg1, arg2, over)
    DelExProp(self, 'ImmuneBuff');
    local caster = GetBuffCaster(buff);

    AddBuff(caster, self, "CarveAustrasKoks_Debuff", arg1, arg2, 400 + arg1 * 600);
end


function SCR_BUFF_ENTER_SubWeaponCancel_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_SubWeaponCancel_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_EsquiveToucher_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_EsquiveToucher_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_FireWall_Debuff(self, buff, arg1, arg2, over)
    local fireRes = 20
    
    if IS_PC(self) == true then
        self.ResFire_BM = self.ResFire_BM - fireRes;
    else
        self.Fire_Def_BM = self.Fire_Def_BM - fireRes;
    end
    
    SetExProp(buff, "ADD_FIRERES", fireRes)
end

function SCR_BUFF_LEAVE_FireWall_Debuff(self, buff, arg1, arg2, over)
    local fireRes = GetExProp(buff, "ADD_FIRERES")
    
    if IS_PC(self) == true then
        self.ResFire_BM = self.ResFire_BM + fireRes;
    else
        self.Fire_Def_BM = self.Fire_Def_BM + fireRes;
    end
end


function SCR_BUFF_ENTER_BrambleRage(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_BrambleRage(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_Vendetta_Buff(self, buff, arg1, arg2, over)


    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    local stradd = arg1 * 5
    self.STR_BM = self.STR_BM + stradd
        SetExProp(buff, "ADD_STR", stradd);

end

function SCR_BUFF_LEAVE_Vendetta_Buff(self, buff, arg1, arg2, over)


    local stradd = GetExProp(buff, "ADD_STR");
    self.STR_BM = self.STR_BM - stradd;

end







function SCR_BUFF_ENTER_Fade_Buff(self, buff, arg1, arg2, over)

    SKL_HATE_RESET(self)
    ObjectColorBlend(self, 255,255,255,150,1)

end

function SCR_BUFF_LEAVE_Fade_Buff(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255,255,255,255,1)
end


function SCR_BUFF_ENTER_OperHide(self, buff, arg1, arg2, over)

    SKL_HATE_RESET(self)
    ObjectColorBlend(self, 255,255,255,150,1)

end

function SCR_BUFF_LEAVE_OperHide(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255,255,255,255,1)
end




function SCR_BUFF_ENTER_Exorcise_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local damage = GET_SKL_DAMAGE(caster, self, 'Priest_Exorcise');
        local skill = GET_MON_SKILL(caster, 'Priest_Exorcise');
        if skill ~= nil then
            TakeDamage(caster, self, skill.ClassName, damage, "Holy", "Magic", "Magic", HIT_HOLY, HITRESULT_BLOW, 0, 0);
--          SetBuffArgs(buff, skill.SkillAtkAdd, caster.INT, 0);
            SetBuffArgs(buff, caster.MNA, caster.INT, 0);
        end
    end
end

function SCR_BUFF_UPDATE_Exorcise_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local skill = GetSkill(caster, "Priest_Exorcise")
        if skill ~= nil then 
            local damage = GET_SKL_DAMAGE(caster, self, 'Priest_Exorcise')
            TakeDamage(caster, self, skill.ClassName, damage, "Holy", "Magic", "Magic", HIT_HOLY, HITRESULT_BLOW, 0, 0);
        end
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_Exorcise_Debuff(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_Testudo_Buff(self, buff, arg1, arg2, over)

    local mspdadd = self.MSPD * 0.5
    
    local caster = GetBuffCaster(buff)
    local abil = GetAbility(caster, 'Centurion5')
    if abil ~= nil then
        mspdadd = self.MSPD * (0.5 - (abil.Level * 0.05))
    end
    
    self.MSPD_BM = self.MSPD_BM - mspdadd
    SetExProp(buff, "ADD_MSPD", mspdadd);
    self.Jumpable = self.Jumpable - 1;
    
end

function SCR_BUFF_UPDATE_Testudo_Buff(self, buff, arg1, arg2, RemainTime, ret, over)

    local buffOwner = GetBuffCaster(buff);

    if GetHandle(self) == GetHandle(buffOwner) then
        if self.SP > 0  then
            AddSP(self, -self.MSP * 0.01)
        else
            RunFormation(self, GetSkill(self, "Centurion_Testudo"), "None");
            return 0;
        end
    end

    return 1;

end

function SCR_BUFF_LEAVE_Testudo_Buff(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    self.Jumpable = self.Jumpable + 1;

end




function SCR_BUFF_ENTER_God_Finger_Flicking_Debuff(self, buff, arg1, arg2, over)


  local spadd = self.MSP * 0.5
    self.MSP_BM = self.MSP_BM - spadd
    SetExProp(buff, "ADD_MSP", spadd);

end

function SCR_BUFF_LEAVE_God_Finger_Flicking_Debuff(self, buff, arg1, arg2, over)

    local spadd = GetExProp(buff, "ADD_MSP");
    self.MSP_BM = self.MSP_BM + spadd;
end


function SCR_BUFF_ENTER_SneakHit_Buff(self, buff, arg1, arg2, over)
    
    local skill = GetSkill(self, "Rogue_SneakHit")
    SetExProp(buff, "Lv", skill.Level)
end

function SCR_BUFF_LEAVE_SneakHit_Buff(self, buff, arg1, arg2, over)


end





function SCR_BUFF_ENTER_JollyRoger_Buff(self, buff, arg1, arg2, over)

    
end

function SCR_BUFF_LEAVE_JollyRoger_Buff(self, buff, arg1, arg2, over)


end

-- Samsara_Buff
function SCR_BUFF_ENTER_Samsara_Buff(self, buff, arg1, arg2, over)
    if self.MonRank ~= 'Boss' then
        return;
    end
    
    local sklRate = 2;
    local caster = GetBuffCaster(buff);
    local party = GetPartyObj(caster, 0);
    
    if party ~= nil then
        local partyMemberCount = GetPartyAliveMemberCount(party) - 1;
        if partyMemberCount > 0 then
            sklRate = sklRate + 2 * partyMemberCount;
        end
    end
        
    local rate = IMCRandom(1, 100);
    SetExProp(self, "Samsara_rate", rate)
    SetExProp(self, "Samsara_sklRate", sklRate)

    if rate > sklRate then
        SetExProp(self, "Remove_Samsara_Buff", 1);
    else
        SetExProp(self, 'SAMSARA_APPLIED', 1);
    end
end

function SCR_BUFF_UPDATE_Samsara_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if IsBuffApplied(self, "SamsaraAfter_Buff") == "YES" then
        return 0;
    end
    
    if GetExProp(self, 'KABAL_COPIED') == 1 then
        return 0;
    end
    
    if GetExProp(self, "Remove_Samsara_Buff") == 1 then
        local caster = GetBuffCaster(buff);
        if caster ~= nil then
            local List, cnt = GetPartyMemberList(caster, PARTY_NORMAL, 500);    
            if cnt > 0 then
                for i = 1, cnt do
                    local obj = List[i];    
                    SendSysMsg(obj, "SkillSamsaraFail");
                end
            else
                SendSysMsg(caster, "SkillSamsaraFail");
            end
        end
        return 0
    end

    if GetExProp(buff, "Samsara_check") == 0 then
        SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
        SetExProp(buff, "Samsara_check", 1);
    end
    
    return 1;

end

function SCR_BUFF_LEAVE_Samsara_Buff(self, buff, arg1, arg2, over)
    if IsBuffApplied(self, "SamsaraAfter_Buff") == "YES" then
        return;
    end

    if GetExProp(self, "Remove_Samsara_Buff") == 1 or IsDead(self) ~= 1 then
        return;
    end

    local createCount = 1;
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local Chronomancer3_abil = GetAbility(caster, 'Chronomancer3');
        if Chronomancer3_abil ~= nil and IMCRandom(1, 100) < Chronomancer3_abil.Level then
            createCount = createCount + 1;
        end
    end
    
    for i=1, createCount do
        local x, y, z = GetActorRandomPos(self, 10)
        local iesObj = CreateGCIES('Monster', self.ClassName);
        iesObj.Lv = self.Lv
        local mon = CreateMonster(self, iesObj, x, y, z, 0, 0);
        local monHp = mon.MHP * 0.05;
        local subHp = mon.MHP - monHp;
        AddHP(mon, -subHp)
        AddBuff(caster, mon, "SamsaraAfter_Buff");
        SetExProp(mon, "CREATE_SAMSARA", 1)
    end
end
    
-- Archer_SteadyAim_Buff
function SCR_BUFF_ENTER_SteadyAim_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_SteadyAim_Buff(self, buff, arg1, arg2, over)

end


-- Quicken_Buff
function SCR_BUFF_ENTER_Quicken_Buff(self, buff, arg1, arg2, over)
    local atkspdadd = 0;
    local lv = arg1;
    
    local addCri = 0;
    local decreaseDR = 0;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        -- 정신계수 추가 --
        local casterMNA = TryGetProp(caster, "MNA");
        local baseLv = TryGetProp(self, "Lv");
        
        local addRate = casterMNA / baseLv;
        if addRate <= 0 then
            addRate = 0;
        elseif addRate >= 1 then
            addRate = 1;
        end
        
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
        
        atkspdadd = math.floor((15 + lv * 10) * (1 + addRate));
        
        local Chronomancer1_abil = GetAbility(caster, 'Chronomancer1');
        if Chronomancer1_abil ~= nil and Chronomancer1_abil.ActiveState == 1 then
            addCri = math.floor(Chronomancer1_abil.Level * 15 * (1 + addRate));
            decreaseDR = math.floor(Chronomancer1_abil.Level * 20 * (1 + addRate));
        end
    end
    
    self.CRTHR_BM = self.CRTHR_BM + addCri;
    SetExProp(buff, 'ADD_CRT_ABIL', addCri);
    
    self.DR_BM = self.DR_BM - decreaseDR;
    SetExProp(buff, 'DECREASE_DR_ABIL', decreaseDR);
    
    --self.AtkSpeed_BM = self.AtkSpeed_BM - atkspdadd 
    SetExProp(buff, "ADD_ATKSPD", atkspdadd);
    SET_NORMAL_ATK_SPEED(self, -atkspdadd);
    
    local Name = GetName(caster)
    if self.Name ~= Name then
        SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    end
end

function SCR_BUFF_LEAVE_Quicken_Buff(self, buff, arg1, arg2, over)
    local atkspdadd = GetExProp(buff, "ADD_ATKSPD");
    SET_NORMAL_ATK_SPEED(self, atkspdadd);
    --self.AtkSpeed_BM = self.AtkSpeed_BM + atkspdadd;
    
    local addCri = GetExProp(buff, 'ADD_CRT_ABIL');
    self.CRTHR_BM = self.CRTHR_BM - addCri;
    
    local decreaseDR = GetExProp(buff, 'DECREASE_DR_ABIL');
    self.DR_BM = self.DR_BM + decreaseDR;
end




function SCR_BUFF_ENTER_Warrior_Amolado_Buff(self, buff, arg1, arg2, over)

    local lv = arg1

    local kdpadd = 200
    
    self.KDPow_BM = self.KDPow_BM + kdpadd
    
    SetExProp(buff, "ADD_KDP", kdpadd);
    SetExProp(self, "KD_BM", self.KDPow_BM) 
    
end

function SCR_BUFF_LEAVE_Warrior_Amolado_Buff(self, buff, arg1, arg2, over)

    local kdpadd = GetExProp(buff, "ADD_KDP");

    self.KDPow_BM = self.KDPow_BM - kdpadd;
    DelExProp(buff, "KD_BM")

end

function SCR_BUFF_ENTER_ShieldCharge_Buff(self, buff, arg1, arg2, over)
    local lv = arg1
    
    local mspdadd = self.MSPD * 0.3
    self.MSPD_BM = self.MSPD_BM - mspdadd
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
    
    self.Jumpable = self.Jumpable - 1;
    self.DashRun = 0;
end

function SCR_BUFF_UPDATE_ShieldCharge_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    AddStamina(self, -500)
    return 1;
end

function SCR_BUFF_LEAVE_ShieldCharge_Buff(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;

    self.Jumpable = self.Jumpable + 1;
end


function SCR_BUFF_ENTER_Slithering_Buff(self, buff, arg1, arg2, over)

    --local lv = arg1
    
    local mspdadd = self.MSPD * 0.4
    self.MSPD_BM = self.MSPD_BM - mspdadd
    SetExProp(buff, "ADD_MSPD", mspdadd);
    self.Jumpable = self.Jumpable - 1;

    local caster = GetBuffCaster(buff);
    local Slitheringskl = GetSkill(caster, 'Rodelero_Slithering');
    if Slitheringskl ~= nil then
        SetBuffArgs(buff, Slitheringskl.Level, 0, 0);
    end
end

function SCR_BUFF_UPDATE_Slithering_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    AddStamina(self, -500)

    return 1;

end

function SCR_BUFF_LEAVE_Slithering_Buff(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    self.Jumpable = self.Jumpable + 1;
end

function SCR_BUFF_ENTER_Pouncing_Buff(self, buff, arg1, arg2, over)
    self.DashRun = 0;
    self.Jumpable = self.Jumpable - 1;
end

function SCR_BUFF_UPDATE_Pouncing_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    AddStamina(self, -200)
    return 1;
end

function SCR_BUFF_LEAVE_Pouncing_Buff(self, buff, arg1, arg2, over)
    self.Jumpable = self.Jumpable + 1;
end

function SCR_BUFF_ENTER_Trot_Buff(self, buff, arg1, arg2, over)
    local lv = arg1
    local mspdadd = 5 + arg1 * 1
    
    self.MSPD_BM = self.MSPD_BM + mspdadd
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
end

function SCR_BUFF_UPDATE_Trot_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if 1 ~= GetVehicleState(self) then
        RemoveBuff(self, "Trot_Buff");
    end
    return 1;
end

function SCR_BUFF_LEAVE_Trot_Buff(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM - mspdadd;
end

function SCR_BUFF_ENTER_SpeForceFom_Buff(self, buff, arg1, arg2, over)
    InvalidateSkillCoolDown(self);
end

function SCR_BUFF_LEAVE_SpeForceFom_Buff(self, buff, arg1, arg2, over)
    InvalidateSkillCoolDown(self);
end


-- Fluting_Buff
function SCR_BUFF_ENTER_Fluting_Buff(self, buff, arg1, arg2, over)

    local lv = arg1;
    local mspdadd = self.MSPD * 0.6;
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    SetExProp(buff, "ADD_MSPD", mspdadd);
    
    self.Jumpable = self.Jumpable - 1;
end

function SCR_BUFF_LEAVE_Fluting_Buff(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    self.Jumpable = self.Jumpable + 1;
end

--Sabbath_Fluting
function SCR_BUFF_ENTER_Sabbath_Fluting(self, buff, arg1, arg2, over)
    
    local moveSpeed = 100;
    local adddef = 0;
    
    local buffCaster = GetBuffCaster(buff);
    if buffCaster ~= nil then
        moveSpeed = GetCurMSPD(buffCaster)
    end
    
    SetExProp(buff, "BEFORE_FIXMSPD", moveSpeed);
    self.FIXMSPD_BM = moveSpeed;
    
    self.DEF_BM = self.DEF_BM + adddef;
    SetExProp(buff, "ADD_DEF", adddef);
end

function SCR_BUFF_UPDATE_Sabbath_Fluting(self, buff, arg1, arg2, RemainTime, ret, over)
    local beforeFixMSPD = GetExProp(buff, "BEFORE_FIXMSPD");
    self.FIXMSPD_BM = beforeFixMSPD;

    local moveSpeed = 100;
    local buffCaster = GetBuffCaster(buff);
    if buffCaster ~= nil then
        moveSpeed = GetCurMSPD(buffCaster);
    end

    if beforeFixMSPD ~= moveSpeed then
        SetExProp(buff, "BEFORE_FIXMSPD", moveSpeed);
        self.FIXMSPD_BM = moveSpeed;
        InvalidateMSPD(self);
    end
    return 1;
end

function SCR_BUFF_LEAVE_Sabbath_Fluting(self, buff, arg1, arg2, over)
    local beforeFixMSPD = GetExProp(buff, "BEFORE_FIXMSPD");
    self.FIXMSPD_BM = 0;
    StopMove(self);
    local adddef = GetExProp(buff, "ADD_DEF");
    self.DEF_BM = self.DEF_BM - adddef;

end

-- BwaKayiman_Fluting
function SCR_BUFF_ENTER_BwaKayiman_Fluting(self, buff, arg1, arg2, over)
    local moveSpeed = 80;
    local adddef = 0;
    
    local buffCaster = GetBuffCaster(buff);
    if buffCaster ~= nil then
        moveSpeed = GetCurMSPD(buffCaster)
        
        local bokor5_abil = GetAbility(buffCaster, 'Bokor5');
        if bokor5_abil ~= nil then
            adddef = bokor5_abil.Level * 0.02
        end
    end
    
    SetExProp(buff, "BEFORE_FIXMSPD", moveSpeed);
    self.FIXMSPD_BM = moveSpeed;
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + adddef;
    SetExProp(buff, "ADD_DEF", adddef);
    
    SkillCancel(self);
    BwakayZombieSummon(self)
end

function SCR_BUFF_UPDATE_BwaKayiman_Fluting(self, buff, arg1, arg2, RemainTime, ret, over)
    local beforeFixMSPD = GetExProp(buff, "BEFORE_FIXMSPD");
    
    self.FIXMSPD_BM = beforeFixMSPD;
    
    local moveSpeed = 80;
    local buffCaster = GetBuffCaster(buff);
    if buffCaster ~= nil then
        moveSpeed = GetCurMSPD(buffCaster);
    end
    
    if beforeFixMSPD ~= moveSpeed then
        SetExProp(buff, "BEFORE_FIXMSPD", moveSpeed);
        self.FIXMSPD_BM = moveSpeed;
        InvalidateMSPD(self);
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_BwaKayiman_Fluting(self, buff, arg1, arg2, over)
    local beforeFixMSPD = GetExProp(buff, "BEFORE_FIXMSPD");
    self.FIXMSPD_BM = 0;
    StopMove(self);
    EndBwakayZombieSummon(self)
    AttachEffect(self, "I_emo_exclamation", 3, "TOP");
    
    local adddef = GetExProp(buff, "ADD_DEF");
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - adddef;
end

-- Fluting_DeBuff
function SCR_BUFF_ENTER_Fluting_DeBuff(self, buff, arg1, arg2, over)
    
    local moveSpeed = 30;
    SetExProp(buff, "BEFORE_FIXMSPD", self.FIXMSPD_BM);
    self.FIXMSPD_BM = moveSpeed;
    HoldMonScp(self);
end

function SCR_BUFF_LEAVE_Fluting_DeBuff(self, buff, arg1, arg2, over)

    local beforeFixMSPD = GetExProp(buff, "BEFORE_FIXMSPD");
    self.FIXMSPD_BM = beforeFixMSPD;
    UnHoldMonScp(self);
    StopMove(self);
    AttachEffect(self, "I_emo_exclamation", 3, "TOP");

end


function SCR_BUFF_ENTER_Retrieve_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local defadd = 0;
    
    local pet = GetBuffCaster(buff);
    local caster = GetOwner(pet)
    if caster ~= nil then
        
        local Hunter3_abil = GetAbility(caster, "Hunter3")
        if Hunter3_abil ~= nil then
            defadd = 0.02 * Hunter3_abil.Level;
        end
    end
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd
    SetExProp(buff, "ADD_DEF", defadd);
    
end

function SCR_BUFF_UPDATE_Retrieve_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local pet = GetBuffCaster(buff);
    local caster = GetOwner(pet)
    local notApplyDiminishing = 1
    if caster ~= nil then
        local damage = GET_SKL_DAMAGE(caster, self, 'Hunter_Retrieve');
        local skill = GET_MON_SKILL(caster, 'Hunter_Retrieve');
        TAKE_SCP_DAMAGE(caster, self, damage, HIT_BASIC, HITRESULT_BLOW, 0, skill.ClassName, 1, 4, nil, pet, notApplyDiminishing);
    end

    return 1;

end

function SCR_BUFF_LEAVE_Retrieve_Debuff(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd

end


function SCR_BUFF_ENTER_Praise_Buff(self, buff, arg1, arg2, over)

    local lv = arg1
    local atkadd = 25 + (lv - 1) * 5
    local hradd = 25 + (lv - 1) * 5
    local crihradd = 25 + (lv - 1) * 5
    local mspdadd = 0;
    local time = lv * 300
    
    local caster = GetBuffCaster(buff);
    local Hunter5_abil = GetAbility(caster, "Hunter5")
    if Hunter5_abil ~= nil then
        mspdadd = mspdadd + Hunter5_abil.Level;
    end
    
    self.Stat_ATK_BM = self.Stat_ATK_BM + atkadd
    self.Stat_HR_BM = self.Stat_HR_BM + hradd
    self.Stat_CRTHR_BM = self.Stat_CRTHR_BM + crihradd
    self.MSPD_BM = self.MSPD_BM + mspdadd
    
    SetExProp(buff, "ADD_PATK", atkadd);
    SetExProp(buff, "ADD_HR", hradd);
    SetExProp(buff, "ADD_CRIHR", crihradd);
    SetExProp(buff, "ADD_MSPD", mspdadd);
    
    SetAddCoolTime(self, "Mon_Velhider_Skill_1", -(time));
end

function SCR_BUFF_LEAVE_Praise_Buff(self, buff, arg1, arg2, over)

    local atkadd = GetExProp(buff, "ADD_PATK");
    local hradd = GetExProp(buff, "ADD_HR");
    local crihradd = GetExProp(buff, "ADD_CRIHR");
    local mspdadd = GetExProp(buff, "ADD_MSPD");
    
    self.Stat_ATK_BM = self.Stat_ATK_BM - atkadd
    self.Stat_HR_BM = self.Stat_HR_BM - hradd
    self.Stat_CRTHR_BM = self.Stat_CRTHR_BM - crihradd
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetAddCoolTime(self, "Mon_Velhider_Skill_1", 0);
end

function SCR_BUFF_ENTER_Pointing_Buff(self, buff, arg1, arg2, over)
    RunSimpleAIOnly(self, "companion_pointing") 
end

function SCR_BUFF_LEAVE_Pointing_Buff(self, buff, arg1, arg2, over)
    ClearSimpleAI(self, "companion_pointing");
end

function SCR_BUFF_ENTER_Pointing_Debuff(self, buff, arg1, arg2, over)

    local default = 10
    local rate = arg1 * 6
    
    local dradd = default + rate
    local hradd = default + rate
    
    self.DR_BM = self.DR_BM - dradd;
    self.HR_BM = self.HR_BM - hradd;
    
    SetExProp(buff, "ADD_DR", dradd);
    SetExProp(buff, "ADD_HR", hradd);
    
    local pet = GetBuffCaster(buff);
    local caster = GetOwner(pet)
    local Hunter1_abil = GetAbility(caster, "Hunter1")
    if Hunter1_abil ~= nil then
        if Hunter1_abil.Level * 500 > IMCRandom(0,9999) then
            AddBuff(caster, self, 'UC_fear', Hunter1_abil.Level, 0, 3000, 1);
        end
    end

end


function SCR_BUFF_LEAVE_Pointing_Debuff(self, buff, arg1, arg2, over)

    local dradd = GetExProp(buff, "ADD_DR");
    local hradd = GetExProp(buff, "ADD_HR");

    self.DR_BM = self.DR_BM + dradd;
    self.HR_BM = self.HR_BM + hradd;

end


function SCR_BUFF_ENTER_Hounding_Buff(self, buff, arg1, arg2, over)
  SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local owner = GetOwner(self);
    local skl = GetSkill(owner, "Hunter_Hounding");
    SetExProp(self, "Hounding_Count", skl.Level);
    RunSimpleAIOnly(self, "companion_hounding") 
    
end

function SCR_BUFF_LEAVE_Hounding_Buff(self, buff, arg1, arg2, over)

    ClearSimpleAI(self, "companion_hounding");

end


function SCR_BUFF_ENTER_Growling_Buff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    RunSimpleAIOnly(self, "companion_growling") 
end

function SCR_BUFF_LEAVE_Growling_Buff(self, buff, arg1, arg2, over)
    ClearSimpleAI(self, "companion_growling");
end


function SCR_BUFF_ENTER_Growling_Return_Debuff(self, buff, arg1, arg2, over)

    if self.RaceType ~= 'Item' then
        HoldMonScp(self)
        self.MSPD_BM = self.MSPD_BM + 50
        CancelMonsterSkill(self)
        SetTendency(self, "None")
    
        MoveEx(self, self.CreateX, self.CreateY, self.CreateZ, 1);
        SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    end
end

function SCR_BUFF_UPDATE_Growling_Return_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local posX, posY, posZ = GetPos(self)
    if SCR_POINT_DISTANCE(self.CreateX, self.CreateZ, posX, posZ) < 30 then
        return 0;
    end

    return 1;

end

function SCR_BUFF_LEAVE_Growling_Return_Debuff(self, buff, arg1, arg2, over)
    
    UnHoldMonScp(self)
    self.MSPD_BM = self.MSPD_BM - 50

end


function SCR_BUFF_ENTER_Growling_fear_Debuff(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_fear', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    if IS_PC(self) == false then
        HoldMonScp(self)
        CancelMonsterSkill(self)
    end
    
    local patkadd = 0.3
    local matkadd = 0.3
    
    self.PATK_RATE_BM = self.PATK_RATE_BM - patkadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM - matkadd;
    
    SetExProp(buff, "ADD_PATK", patkadd);
    SetExProp(buff, "ADD_MATK", matkadd);
end

function SCR_BUFF_LEAVE_Growling_fear_Debuff(self, buff, arg1, arg2, over)
  --  HideEmoticon(self, 'I_emo_fear')
  
    if IS_PC(self) == false then
        UnHoldMonScp(self)
    end
    
    local patkadd = GetExProp(buff, "ADD_PATK");
    local matkadd = GetExProp(buff, "ADD_MATK");
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + patkadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM + matkadd;
    
    Invalidate(self, "MINPATK");
    Invalidate(self, "MAXPATK");
    Invalidate(self, "MINMATK");
    Invalidate(self, "MAXMATK");
end


function SCR_BUFF_ENTER_TimeBombArrow_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local caster = GetBuffCaster(buff)
    local skill = GET_MON_SKILL(caster, "Ranger_TimeBombArrow");
    local damage = GET_SKL_DAMAGE(caster, self, "Ranger_TimeBombArrow");
    
    SetExProp(buff, "DAMAGE", damage);

end

function SCR_BUFF_LEAVE_TimeBombArrow_Debuff(self, buff, arg1, arg2, over)
--    if IsBuffApplied(self, 'TimeBombArrow_Debuff') == 'NO' and self.HP > 0 then
    if self.HP > 0 then
        local damage = GetExProp(buff, "DAMAGE");
        if damage <= 0 then
            return 0;
        end
    
        local from = self;
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            from = caster;
        end
        
        local key = GenerateSyncKey(self)
        
        StartSyncPacket(self, key);

        PlayEffect(self, 'F_archer_explosiontrap_hit_explosion', 1);
        TakeDamage(caster, self, "Ranger_TimeBombArrow", damage, "Melee", "Strike", "Melee", HIT_FIRE, HITRESULT_NO_HITSCP);
        
        local angle = GetAngleTo(caster, self);
        if GetPropType(self, 'KDArmor') ~= nil and self.KDArmor < 900 then
            KnockDown(self, caster, 150, angle, 60, 3);
        end
        
        local list, cnt = SelectObjectNear(caster, self, 45, "ENEMY", 0, 0);
        
        local maxCount = 5;
        if maxCount > cnt then
            maxCount = cnt;
        end
        
        if maxCount >= 1 then
            for i = 1, maxCount do
                local obj = list[i];
                if IsSameObject(obj, self) == 0 then
                    TakeDamage(caster, obj, "Ranger_TimeBombArrow", damage, "Melee", "Strike", "Melee", HIT_FIRE, HITRESULT_NO_HITSCP);
                    
                    angle = GetAngleTo(self, obj);
                    if GetPropType(obj, 'KDArmor') ~= nil and obj.KDArmor < 900 then
                        KnockDown(obj, self, 150, angle, 60, 3)
                    end
                end
            end
        end
        
        EndSyncPacket(self, key, 0);
        ExecSyncPacket(self, key);
    end
end




function SCR_BUFF_ENTER_Singijeon_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local caster = GetBuffCaster(buff)
    local Fletcher7_abil = GetAbility(caster, "Fletcher7")
    
    if Fletcher7_abil ~= nil then
        AddBuff(caster, self, "UC_shock", Fletcher7_abil.Level, 0, 10000, 1);
    end
    
    local skill = GET_MON_SKILL(caster, "Fletcher_Singijeon");
    local damage = GET_SKL_DAMAGE(caster, self, "Fletcher_Singijeon")
    if damage == nil then
        damage = 0;
    end
    
    SetExProp(buff, "DAMAGE", damage);
end

function SCR_BUFF_LEAVE_Singijeon_Debuff(self, buff, arg1, arg2, over)
--    if IsBuffApplied(self, 'Singijeon_Debuff') == 'NO' and self.HP > 0 then
    if self.HP > 0 then
        local damage = GetExProp(buff, "DAMAGE");
        if damage <= 0 then
            return 0;
        end
        
        local from = self;
        local caster = GetBuffCaster(buff);
        if caster ~= nil then
            from = caster;
        end
        
        local key = GenerateSyncKey(self)
        StartSyncPacket(self, key);

        PlayEffect(self, 'F_archer_explosiontrap_hit_explosion', 1);
        local objList, cnt = SelectObjectNear(caster, self, 65, "ENEMY", 0, 0);
        TakeDamage(caster, self, "Fletcher_Singijeon", damage, "Melee", "Strike", "Melee", HIT_FIRE, HITRESULT_NO_HITSCP);
        --if GetPropType(self, 'KDArmor') ~= nil and self.KDArmor < 900 then
        --    KnockDown(self, caster, 150, 0, 60, 3)
        --end
        
        if cnt >= 9 then
            cnt = 9
        end
        for i = 1 , cnt do
            local angle = GetAngleTo(self, objList[i]);
            TakeDamage(caster, objList[i], "Fletcher_Singijeon", damage, "Melee", "Strike", "Melee", HIT_FIRE, HITRESULT_NO_HITSCP);
            --if GetPropType(objList[i], 'KDArmor') ~= nil and objList[i].KDArmor < 900 then
            --    KnockDown(objList[i], caster, 150, angle, 60, 3)
            --end
        end
        
        EndSyncPacket(self, key, 0);
        ExecSyncPacket(self, key);
    end
end

function SCR_BUFF_ENTER_SpiralArrow_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_SpiralArrow_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Monster_Poison(self, buff, arg1, arg2, over)
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.MINMATK, caster.MAXMATK, 0);
    end
end

function SCR_BUFF_UPDATE_Monster_Poison(self, buff, arg1, arg2, RemainTime, ret, over)


    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end
    
    local casterMINMATK, casterMAXMATK = GetBuffArgs(buff);
    TakeDamage(caster, self, "None", (casterMINMATK + casterMAXMATK) / 10, "Poison", "None", "Melee", HIT_POISON, HITRESULT_BLOW, 0, 0);    

    return 1;

end

function SCR_BUFF_LEAVE_Monster_Poison(self, buff, arg1, arg2, over)


end


function SCR_BUFF_ENTER_SpreadPoison(self, buff, arg1, arg2, over)

    self.ATK_BM = self.ATK_BM - arg1 * 3;

end

function SCR_BUFF_UPDATE_SpreadPoison(self, buff, arg1, arg2, RemainTime, ret, over)

    local faction = GetCurrentFaction(self);
    local objList, objCount = SelectObjectByFaction(self, 20, faction);
    if objCount > 0 then
        for index = 1, objCount do
            if GetBodyState(objList[index]) ~= 'BS_DEAD' and objList[index].SpecialDefType ~= 'DebuffProof' and IsBuffApplied(objList[index], 'SpreadPoison') ~= 'YES' and objList[index] ~= self then
                AddBuff(GetBuffCaster(buff), objList[index], 'SpreadPoison', arg1, arg2, RemainTime, over);
            end
        end
    end

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end

    TakeDamage(caster, self, "None", arg1, "Poison", "None", "Melee", HIT_POISON, HITRESULT_BLOW ,0, 0);
    

    return 1;

end

function SCR_BUFF_LEAVE_SpreadPoison(self, buff, arg1, arg2, over)

    self.ATK_BM = self.ATK_BM + arg1 * 3;

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end

    TakeDamage(caster, self, 3* arg1, "Poison", "None", "Melee", HIT_POISON, HITRESULT_BLOW, 0, 0); 

end


function SCR_BUFF_ENTER_Poison(self, buff, arg1, arg2, over)

    self.ATK_BM = self.ATK_BM - arg1 * 2;
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.MINMATK, caster.MAXMATK, 0);
    end
end

function SCR_BUFF_UPDATE_Poison(self, buff, arg1, arg2, RemainTime, ret, over)

    local casterMINMATK, casterMAXMATK = GetBuffArgs(buff);
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end
    
    TakeDamage(caster, self, "None", (casterMINMATK + casterMAXMATK) / IMCRandom(7, 10), "Poison", "None", "Melee", HIT_POISON, HITRESULT_BLOW, 0, 0);
    
    return 1;

end

function SCR_BUFF_LEAVE_Poison(self, buff, arg1, arg2, over)

    self.ATK_BM = self.ATK_BM + arg1 * 2;

end


function SCR_BUFF_ENTER_Revenge(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Revenge(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Aggressor_Buff(self, buff, arg1, arg2, over)
    local hradd = 50
    local ScudInstinct_Buff = GetBuffByName(self, 'ScudInstinct_Buff')
    if ScudInstinct_Buff ~= nil then
        local ScudInstinct_Over = GetOver(ScudInstinct_Buff);
        hradd = hradd + (ScudInstinct_Over * 10);
    end
    self.CRTHR_BM = self.CRTHR_BM + hradd
    SetExProp(buff, "ADD_HR", hradd);
end


function SCR_BUFF_LEAVE_Aggressor_Buff(self, buff, arg1, arg2, over)
    local hradd = GetExProp(buff, "ADD_HR");
    self.CRTHR_BM = self.CRTHR_BM - hradd;
end




function SCR_BUFF_ENTER_Cleric_Lada_Debuff(self, buff, arg1, arg2, over)

    local addDefenced_BM  = 1;
    SetExProp(buff, 'DEFENCED_BM', addDefenced_BM);
    self.MaxDefenced_BM = self.MaxDefenced_BM + addDefenced_BM;
end

function SCR_BUFF_LEAVE_Cleric_Lada_Debuff(self, buff, arg1, arg2, over)

    
    local addDefenced_BM = GetExProp(buff, 'DEFENCED_BM');
    self.MaxDefenced_BM = self.MaxDefenced_BM - addDefenced_BM;

end




function SCR_BUFF_ENTER_FoldingFan_Buff(self, buff, arg1, arg2, over)

SpinObject(self, 0, -1, 0.15, 3.5)


end

function SCR_BUFF_LEAVE_FoldingFan_Buff(self, buff, arg1, arg2, over)


SpinObject(self, 0, 0, 0, 0)

end



function SCR_BUFF_ENTER_Savagery_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Savagery_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_TAKEDMG_SAVAGERY(self)
return 0
end



function SCR_BUFF_ENTER_Blind(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_blind', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

    if self.ClassName ~= 'PC' then
        CancelMonsterSkill(self);
        StopMove(self);
        SetTendencysearchRange(self, 30);   
    end
    
--  local regadd = 10
--  self.ResDark_BM = self.ResDark_BM - regadd;
--  SetExProp(buff, "ADD_REG", regadd);
    
end

function SCR_BUFF_LEAVE_Blind(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_blind')
--    local regadd = GetExProp(buff, "ADD_REG");
--  self.ResDark_BM = self.ResDark_BM + regadd;

    if self.ClassName ~= 'PC' then
        SetTendencysearchRange(self, 0)
    end
end



function SCR_BUFF_ENTER_Bodkin_Debuff(self, buff, arg1, arg2, over)

    local abilLevel = 0
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local abil = GetAbility(caster, "Fletcher2")
        if abil ~= nil then
            abilLevel = abil.Level
        end
    end

    local defrate = arg1 * 0.01 + abilLevel * 0.005
--    local defadd = math.floor(self.DEF * (arg1 * 0.05 + abilLevel * 0.01))
--  self.DEF_BM = self.DEF_BM - defadd
    self.DEF_RATE_BM = self.DEF_RATE_BM - defrate
    SetExProp(buff, "ADD_DEF", defrate);
    
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

end

function SCR_BUFF_LEAVE_Bodkin_Debuff(self, buff, arg1, arg2, over)

    local defrate = GetExProp(buff,"ADD_DEF");
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + defrate

--  local defadd = GetExProp(buff, "ADD_DEF");
--
--  self.DEF_BM = self.DEF_BM + defadd;

end


function SCR_BUFF_ENTER_Warrior_Reward_Buff(self, buff, arg1, arg2, over)

    PlayEffect(self, 'F_warrior_reward_shot_lineup', 0.3);


    
end

function SCR_BUFF_UPDATE_Warrior_Reward_Buff(self, buff, arg1, arg2, RemainTime, ret, over)

    local objList, objCount = SelectObject(self, 200, 'ENEMY');
    local Money = GetInvItemCount(self, 'Vis')
    local AddHate = math.floor(50 + Money * 0.01)

    for i = 1, objCount do
        local obj = objList[i]; 
        local skill = GetSkill(self, "Warrior_Reward")

            InsertHate(obj, self, AddHate);
    end
    return 1;

end

function SCR_BUFF_LEAVE_Warrior_Reward_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Shockwave(self, buff, arg1, arg2, over)

    self.SPD_BM = self.SPD_BM - arg1 * 10;

end

function SCR_BUFF_LEAVE_Shockwave(self, buff, arg1, arg2, over)

    self.SPD_BM = self.SPD_BM + arg1 * 10;

end


function SCR_BUFF_ENTER_Cold(self, buff, arg1, arg2, over)

    self.SPD_BM = self.SPD_BM - 30;

end

function SCR_BUFF_LEAVE_Cold(self, buff, arg1, arg2, over)

    self.SPD_BM = self.SPD_BM + 30;

end

function SCR_BUFF_ENTER_Wizard_Wild_buff(self, buff, arg1, arg2, over)
    local lv = arg1

    local atkadd = ((self.MINMATK + self. MAXMATK) / 2) * (0.15 + (lv * 0.02))

    self.ATK_BM = self.ATK_BM + atkadd;

    SetExProp(buff, "ADD_MINMATK", atkadd);
    
    ObjectColorBlend(self, 255, 160, 150, 255, 1, 3)

end

function SCR_BUFF_LEAVE_Wizard_Wild_buff(self, buff, arg1, arg2, over)

    local atkadd = GetExProp(buff, "ADD_MINMATK");

    self.ATK_BM = self.ATK_BM - atkadd;
    
    ObjectColorBlend(self, 255, 255, 255, 255, 1, 2)

end


function SCR_BUFF_ENTER_Cleric_HolyBaptism_Buff(self, buff, arg1, arg2, over)

    local lv = arg1;
    local atkadd = self.STR + GetSumOfEquipItem(self, 'MAXMATK');
    atkadd = atkadd * set_LI(lv, 0.1, 0.5);

    self.ATK_BM = self.ATK_BM + atkadd;

    SetExProp(buff, "ADD_MINMATK", atkadd);
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end

    local Name = GetName(caster)
    if self.Name ~= Name then
        SkillTextEffect(nil, self, caster, "SHOW_HOLY_BAPTISM", buff.ClassID, nil, Name);
    end

end

function SCR_BUFF_LEAVE_Cleric_HolyBaptism_Buff(self, buff, arg1, arg2, over)

    local atkadd = GetExProp(buff, "ADD_MINMATK");

    self.ATK_BM = self.ATK_BM - atkadd;

end



-- Cleric_Limitation
function SCR_BUFF_ENTER_Cleric_Limitation_Buff(self, buff, arg1, arg2, over)

  local lv = arg1;
  local isdebuff = 1;
  
    if arg2 == 1 then
        isdebuff = -1;
    end
    
    local mhpadd = isdebuff * self.MHP * set_LI(lv, 0.1, 1) --(0.1 + lv * 0.009);

    self.MHP_BM = self.MHP_BM + mhpadd;

    if self.HP > self.MHP + self.MHP_BM then
        AddHP(self,self.MHP_BM);
    end

    SetExProp(buff, "ADD_MHPATK", mhpadd);
    
    
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end

    local Name = GetName(caster)
    if self.Name ~= Name then
        SkillTextEffect(nil, self, caster, "SHOW_LIMITATION", buff.ClassID, nil, Name);
    end

end

function SCR_BUFF_LEAVE_Cleric_Limitation_Buff(self, buff, arg1, arg2, over)

    local mhpadd = GetExProp(buff, "ADD_MHPATK");

    self.MHP_BM = self.MHP_BM - mhpadd;

end



--Ayin_sof_Buff
function SCR_BUFF_ENTER_Ayin_sof_Buff(self, buff, arg1, arg2, over)
    if GetObjType(self) ~= OT_PC then
        return;
    end
    
    local lv = arg1;
    local rate = 0.2
    if IsPVPServer(self) == 1 or IsJoinColonyWarMap(self) == 1 then
        rate = 0.1
    end
    
    local mhpadd = lv * rate
    local MHP = TryGetProp(self, "MHP")
    local mhpAddAbilValue = MHP * (lv * rate)
    
    local caster = GetBuffCaster(buff)
    if caster ~= nil then
        if caster.ClassName == 'PC' then
            local skill = GetSkill(caster, "Kabbalist_Ayin_sof")
            if skill == nil then
                return
            end
            
            local abil = GetAbility(caster, "Kabbalist10")
            if abil ~= nil and abil.ActiveState == 1 and skill.Level >= 3 then
        		mhpadd = mhpadd / 2;
                mhpAddAbilValue = mhpAddAbilValue / 2;
                HealSP(self, mhpAddAbilValue, 0);
    		end
    		
            local healBonus = 0;
            local Kabbalist18_abil = GetAbility(caster, "Kabbalist18");
            if Kabbalist18_abil ~= nil then
                healBonus = 1;
            end
            SetBuffArgs(buff, healBonus, 0, 0);
        end
    end
    
    self.MHP_RATE_BM = self.MHP_RATE_BM + mhpadd;
    
    SetExProp(buff, "ADD_MHP", mhpadd);
end

function SCR_BUFF_LEAVE_Ayin_sof_Buff(self, buff, arg1, arg2, over)

    local mhpadd = GetExProp(buff, "ADD_MHP");
    
    self.MHP_RATE_BM = self.MHP_RATE_BM - mhpadd;

end


function SCR_BUFF_ENTER_Kurdaitcha_Debuff(self, buff, arg1, arg2, over)

    local mspdadd = 15
    local abil = GetAbility(GetBuffCaster(buff), "Featherfoot14")
    if abil ~= nil then
        mspdadd = 5
    end
    
    self.MSPD_BM = self.MSPD_BM - mspdadd
    
    SetExProp(buff, "ADD_MSPD", mspdadd);

end

function SCR_BUFF_LEAVE_Kurdaitcha_Debuff(self, buff, arg1, arg2, over)

  local mspdadd = GetExProp(buff, "ADD_MSPD")
  
   self.MSPD_BM = self.MSPD_BM + mspdadd

end




function SCR_BUFF_ENTER_HeadShot_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local caster = GetBuffCaster(buff);
    
    local MINPATK = TryGetProp(caster, "MINPATK")
    local MAXPATK = TryGetProp(caster, "MAXPATK")
    local atk = (MINPATK + MAXPATK)/10
    
    local intadd = 0
    local mnaadd = 0
    
    if caster ~= nil then
        intadd = 5 * arg1;
        mnaadd = 5 * arg1;
        
        if IsPVPServer(self) == 1 then
            intadd = intadd + caster.HR * 0.1;
            mnaadd = mnaadd + caster.HR * 0.1;
        else
            intadd = intadd;
            mnaadd = mnaadd;
        end
    
        intadd = math.floor(intadd);
        mnaadd = math.floor(mnaadd);
    end
    
    self.INT_BM = self.INT_BM - intadd;
    self.MNA_BM = self.MNA_BM - mnaadd;
    
    SetExProp(buff, "ADD_INT", intadd);
    SetExProp(buff, "ADD_MNA", mnaadd);
    SetExProp(buff, "Debuff_Damage", atk);

end

function SCR_BUFF_UPDATE_HeadShot_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local atk = GetExProp(buff, "Debuff_Damage")

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end

    TakeDamage(caster, self, "None", atk, "None", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);

    return 1;
end

function SCR_BUFF_LEAVE_HeadShot_Debuff(self, buff, arg1, arg2, over)

    local intadd = GetExProp(buff, "ADD_INT")
    local mnaadd = GetExProp(buff, "ADD_MNA")
    
    self.INT_BM = self.INT_BM + intadd
    self.MNA_BM = self.MNA_BM + mnaadd
   
end


function SCR_BUFF_ENTER_Bloodbath_Debuff(self, buff, arg1, arg2, over)
SkillCancel(self);
end

function SCR_BUFF_UPDATE_Bloodbath_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)


    local lv = arg1;
    local caster = GetBuffCaster(buff);
    
    local damage = GET_SKL_DAMAGE(caster, self, 'Featherfoot_BloodBath');
    local skill = GET_MON_SKILL(caster, 'Featherfoot_BloodBath');

    TakeDamage(caster, self, skill.ClassName, damage, "Poison", "Magic", "Magic", HIT_POISON, HITRESULT_NO_HITSCP, 0, 0);

    return 1;

end

function SCR_BUFF_LEAVE_Bloodbath_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Bloodbath_Buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Bloodbath_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    local skill = GET_MON_SKILL(caster, 'Featherfoot_BloodBath');
    local damage = GET_SKL_DAMAGE(caster, self, 'Featherfoot_BloodBath')

    local AddValue = damage * arg1 * 0.01

  Heal(self, AddValue, 0)
    return 1;

end

function SCR_BUFF_LEAVE_Bloodbath_Buff(self, buff, arg1, arg2, over)

end



--RevengedSevenfold
function SCR_BUFF_ENTER_RevengedSevenfold_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_RevengedSevenfold_Buff(self, buff, arg1, arg2, over)

end

--Empowering_Buff
function SCR_BUFF_ENTER_Empowering_Buff(self, buff, arg1, arg2, over)

    SkillTextEffect(nil, self, GetBuffCaster(buff), "EMPOWERING_LEVEL_TEXT", arg1);
    if GetObjType(self) ~= OT_PC then
        return;
    end
    
    local lv = arg1;
    local selfMSP = TryGetProp(self, "MSP") - TryGetProp(self, "MSP_BM")
    local mspadd = selfMSP * (lv * 0.1)
    self.MSP_BM = self.MSP_BM + mspadd;
    SetExProp(buff, "ADD_MSP", mspadd); 
end

function SCR_BUFF_LEAVE_Empowering_Buff(self, buff, arg1, arg2, over)

    local mspadd = GetExProp(buff, "ADD_MSP");
    self.MSP_BM = self.MSP_BM - mspadd;
end

-- EnchantFire_Buff
function SCR_BUFF_ENTER_EnchantFire_Buff(self, buff, arg1, arg2, over)

    local fireAtk = 0;
    local lv = arg1
    local casterMATK = 0;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = math.max(lv, GetPadArgNumber(pad, 1));
        end
        
        local enchantFire = GetSkill(caster, 'Pyromancer_EnchantFire');
        if enchantFire ~= nil then
            lv = math.max(lv, enchantFire.Level);
        end
        
        local statINT = TryGetProp(caster, "INT")
        local statMNA = TryGetProp(caster, "MNA")

        fireAtk = 30 + ((lv - 1) * 5) + ((lv / 5) * (((statINT + statMNA) * 0.6) ^ 0.9))
        
--        local Pyromancer23_abil = GetAbility(caster, "Pyromancer23")    -- 2rank Skill Damage multiple
--        local Pyromancer24_abil = GetAbility(caster, "Pyromancer24")    -- 3rank Skill Damage multiple
--        if Pyromancer24_abil ~= nil then
--            fireAtk = fireAtk * 1.44
--        elseif Pyromancer24_abil == nil and Pyromancer23_abil ~= nil then
--            fireAtk = fireAtk * 1.38
--        end
        
        local Pyromancer16_abil = GetAbility(caster, 'Pyromancer16');
        if Pyromancer16_abil ~= nil then
            fireAtk = fireAtk + Pyromancer16_abil.Level
        end

        local casterMINMATK = TryGetProp(caster, "MINMATK");
        if casterMINMATK == nil then
            casterMINMATK = 0;
        end
        
        local casterMAXMATK = TryGetProp(caster, "MAXMATK");
        if casterMAXMATK == nil then
            casterMAXMATK = 0;
        end
        
        casterMATK = math.floor((casterMINMATK + casterMAXMATK) / 2);
    end
    
    fireAtk = math.floor(fireAtk)
    self.Fire_Atk_BM = self.Fire_Atk_BM + fireAtk

    SetExProp(buff, "ADD_FIRE", fireAtk);

    local Name = GetName(caster)
    if self.Name ~= Name then
        SkillTextEffect(nil, self, caster, "SHOW_FIRE_DETONATION", buff.ClassID, nil, Name);
    end

    SetBuffArgs(buff, lv, casterMATK, 0);
end

function SCR_BUFF_LEAVE_EnchantFire_Buff(self, buff, arg1, arg2, over)

    local fireAtk = GetExProp(buff, "ADD_FIRE");
    self.Fire_Atk_BM = self.Fire_Atk_BM - fireAtk
    
end

-- EnchantFire_Debuff
function SCR_BUFF_ENTER_EnchantFire_Debuff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end

    local resfireadd = 0;
    

    local pyromancer6_abil = GetAbility(caster, 'Pyromancer6')
    if pyromancer6_abil ~= nil then
        resfireadd = 10 * pyromancer6_abil.Level;
    end
    

    if IS_PC(self) == false then
        self.Fire_Def_BM = self.Fire_Def_BM - resfireadd;
    else
        self.ResFire_BM = self.ResFire_BM - resfireadd;
    end
    
    SetExProp(buff, "ADD_RESFIRE", resfireadd);

end

function SCR_BUFF_LEAVE_EnchantFire_Debuff(self, buff, arg1, arg2, over)

    local resfireadd = GetExProp(buff, "ADD_RESFIRE");
    
    if IS_PC(self) == false then
        self.Fire_Def_BM = self.Fire_Def_BM + resfireadd;
    else
        self.ResFire_BM = self.ResFire_BM + resfireadd;
    end
    
end

--Drain_Buff

function SCR_BUFF_ENTER_Drain_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Drain_Buff(self, buff, arg1, arg2, over)
     SetExProp(self, "DARKTHEURAGE_COUNT", 0)
end


-- EnchantLightning_Buff
function SCR_BUFF_ENTER_EnchantLightning_Buff(self, buff, arg1, arg2, over)

    local value = 0;
    local lv = arg1
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
--        local MINMATK = TryGetProp(caster, "MINMATK")
--        local lightAdd = 100 * lv
--        local AddByStat = MINMATK * lv/15
--        lightAtk = AddByStat + lightAdd
        local statINT = TryGetProp(caster, "INT")
        local statMNA = TryGetProp(caster, "MNA")
        value = 160 + ((arg1 - 1) * 60) + ((arg1 / 5) * (((statINT + statMNA) * 0.8) ^ 0.9))

        local enchantLightning = GetSkill(caster, 'Enchanter_EnchantLightning');
        if enchantLightning ~= nil then
            SetBuffArgs(buff, enchantLightning.Level, 0, 0);
        end
    end
    
    value = math.floor(value)
    self.Lightning_Atk_BM = self.Lightning_Atk_BM + value
    
    SetExProp(buff, "ADD_LIGHTNING", value);
end

function SCR_BUFF_LEAVE_EnchantLightning_Buff(self, buff, arg1, arg2, over)

    local value = GetExProp(buff, "ADD_LIGHTNING");
    self.Lightning_Atk_BM = self.Lightning_Atk_BM - value
    
end



-- Sacrament_Buff
function SCR_BUFF_ENTER_Sacrament_Buff(self, buff, arg1, arg2, over)
    local holyAddAttack = 0;
    local resdarkadd = 0;
    local lv = arg1;
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
        
        local Priest7_abil = GetAbility(caster, 'Priest7')
        if Priest7_abil ~= nil then
            resdarkadd = Priest7_abil.Level * 5 
        end
        
        local stat = TryGetProp(caster, 'MNA')
        if BuffFromWho(buff) == BUFF_FROM_AUTO_SELLER then
            local stat_BM = TryGetProp(caster, 'MNA_BM');
            local stat_ITEM_BM = TryGetProp(caster, 'MNA_ITEM_BM');
            stat = stat - (stat_BM + stat_ITEM_BM);
        end
        
        holyAddAttack = math.floor(180 + ((lv - 1) * 60) + ((lv / 3) * (stat ^ 0.9)));
        
        SetBuffArgs(buff, holyAddAttack, resdarkadd);
    else
        holyAddAttack, resdarkadd = GetBuffArgs(buff);
    end
    
    if BuffFromWho(buff) == BUFF_FROM_AUTO_SELLER then
        resdarkadd = math.floor(resdarkadd * 0.7);
    end

    self.ResDark_BM = self.ResDark_BM + resdarkadd

    SetExProp(buff, "ADD_DARK", resdarkadd);
end

function SCR_BUFF_LEAVE_Sacrament_Buff(self, buff, arg1, arg2, over)
    local resdarkadd = GetExProp(buff, "ADD_DARK");
    
    self.ResDark_BM = self.ResDark_BM - resdarkadd;
end

-- ColdDetonation
function SCR_BUFF_ENTER_ColdDetonation(self, buff, arg1, arg2, over)

    self.Ice_Bonus_BM = self.Ice_Bonus_BM + arg1 * over;

end

function SCR_BUFF_LEAVE_ColdDetonation(self, buff, arg1, arg2, over)

    self.Ice_Bonus_BM = self.Ice_Bonus_BM - arg1 * over;

end

-- CardCharm
function SCR_BUFF_ENTER_CardCharm(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);

    SetOwner(self, caster);
    SetTendency(self, "Attack")
    ResetHateAndAttack(self);
    BroadcastRelation(self);

end

function SCR_BUFF_LEAVE_CardCharm(self, buff, arg1, arg2, over)

    SetOwner(self, 0);
    ResetHateAndAttack(self);
    BroadcastRelation(self);

end

-- CriticalWound
function SCR_BUFF_ENTER_CriticalWound(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    local dmg = (caster.MINPATK + caster.MINPATK) / 10;
    SetExProp(self, 'CriticalWound_Damage', dmg)
end

function SCR_BUFF_UPDATE_CriticalWound(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end
    local dmg = GetExProp(self, 'CriticalWound_Damage')
    TakeDamage(caster, self, "None", dmg, "None", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);   
    return 1;

end

function SCR_BUFF_LEAVE_CriticalWound(self, buff, arg1, arg2, over)

end

-- CriticalWound_Mon
function SCR_BUFF_ENTER_CriticalWound_Mon(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.MINPATK, caster.MAXPATK, 0);
    end
end

function SCR_BUFF_UPDATE_CriticalWound_Mon(self, buff, arg1, arg2, RemainTime, ret, over)

    local casterMINPATK, casterMAXPATK = GetBuffArgs(buff);
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end

    TakeDamage(caster, self, "None", (casterMINPATK + casterMAXPATK) / 10, "None", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);  
    return 1;

end


function SCR_BUFF_LEAVE_CriticalWound_Mon(self, buff, arg1, arg2, over)

end

-- enchanted_poison
function SCR_BUFF_ENTER_enchanted_poison(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_enchanted_poison(self, buff, arg1, arg2, over)

end


-- BroadHead
function SCR_BUFF_ENTER_BroadHead_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    --ShowEmoticon(self, 'I_emo_infection', 0)
    local caster = GetBuffCaster(buff);
    
    local atk = 0
    if caster ~= nil then    
        atk = GET_SKL_DAMAGE(caster, self, "Fletcher_BroadHead");
    end
    
    SetBuffArgs(buff, atk, 0, 0);
end

function SCR_BUFF_UPDATE_BroadHead_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local atk = GetBuffArgs(buff);
    local caster = GetBuffCaster(buff);
    
    if caster ~= nil then
        local skill = GetSkill(caster, 'Fletcher_BroadHead')
        if skill ~= nil then
            TakeDamage(caster, self, skill.ClassName, atk, skill.Attribute, "Melee", "Melee", HIT_BLEEDING, HITRESULT_NO_HITSCP, 0, 0);
        end
    end
    
    return 1;
end


function SCR_BUFF_LEAVE_BroadHead_Debuff(self, buff, arg1, arg2, over)

end




-- Archer_BleedingToxin_Debuff
function SCR_BUFF_ENTER_Archer_BleedingToxin_Debuff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.MINMATK, caster.MAXMATK, 0);
    end
end

function SCR_BUFF_UPDATE_Archer_BleedingToxin_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local casterMINMATK, casterMAXMATK = GetBuffArgs(buff);
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end
    
    TakeDamage(caster, self, "None", ((casterMINMATK + casterMAXMATK) / (10 - arg1)) + 1 , "None", "None", "None", HIT_BASIC, HITRESULT_BLOW, 0, 0);
    return 1;

end

function SCR_BUFF_LEAVE_Archer_BleedingToxin_Debuff(self, buff, arg1, arg2, over)

end

-- Archer_NeuroToxin_Debuff
function SCR_BUFF_ENTER_Archer_NeuroToxin_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SetBuffArgs(buff, caster.MINPATK, caster.MAXPATK, 0);
    end
end

function SCR_BUFF_UPDATE_Archer_NeuroToxin_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local casterMINPATK, casterMAXPATK = GetBuffArgs(buff);
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end
        
    TakeDamage(caster, self, "None", ((casterMINPATK + casterMAXPATK) / (10 - arg1)) + 1, "None", "None", "None", HIT_BASIC, HITRESULT_BLOW, 0, 0);
    return 1;

end

function SCR_BUFF_LEAVE_Archer_NeuroToxin_Debuff(self, buff, arg1, arg2, over)

end


--function SCR_BUFF_ENTER_DeathVerdict_Buff(self, buff, arg1, arg2, over)
--    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
--    local caster = GetBuffCaster(buff);
--    if GetObjType(caster) == OT_MONSTERNPC then
--        SetExProp(buff, "AUTO_DELETE", 1);
--    end
--    
--    local mspdadd = 0;
--    local abil = GetAbility(caster, "Oracle8")
--    if abil ~= nil then
--        mspdadd = self.MSPD * 0.15 * abil.Level;
--    end
--    
--    self.MSPD_BM = self.MSPD_BM - mspdadd;
--    SetExProp(buff, "ADD_MSPD", mspdadd);
--    
--    AttachGauge(self, GetBuffRemainTime(buff) * 0.001, 1, 1, "gauge_barrack_attack");
--
--end
--
--function SCR_BUFF_UPDATE_DeathVerdict_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
--
--    local autoDelete = GetExProp(buff, "AUTO_DELETE");
--    
--    if autoDelete == 1 then
--        local caster = GetBuffCaster(buff);
--        if caster == nil or IsDead(caster) == 1 then
--            SetExProp(buff, "AUTO_DELETED", 1);
--            return 0;
--        end
--    end
--
--    return 1;
--
--end
--
--function SCR_BUFF_LEAVE_DeathVerdict_Buff(self, buff, arg1, arg2, over, isLastEnd)
--
--    if isLastEnd == 1 and GetExProp(buff, "AUTO_DELETED") == 0 and GetBuffRemainTime(buff) <= 0 then
--        local caster = GetBuffCaster(buff);
--        if caster ~= nil then
--            if GetSkill(caster, 'Oracle_DeathVerdict') then
--                TakeTrueDamage(caster, self, 'Oracle_DeathVerdict', self.HP + 1, HIC_BASIC, HITRESULT_BLOW);
--            else
--                KillCountDead(self, caster, buff.ClassName)
--            end
--        else
--            Dead(self)
--        end
--    end
--    
--    local mspdadd = GetExProp(buff, "ADD_MSPD");
--    self.MSPD_BM = self.MSPD_BM + mspdadd;
--    
--    AttachGauge(self, 0, 1, 0);
--
--end

function SCR_BUFF_ENTER_DeathVerdict_Buff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local skillLevel = arg1;
    local mspdadd = 0;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local skill = GetSkill(caster, 'Oracle_DeathVerdict');
        skillLevel = TryGetProp(skill, 'Level');
        if skillLevel == nil then
            skillLevel = arg1;
    end
    
    local abil = GetAbility(caster, "Oracle8")
    if abil ~= nil then
        mspdadd = self.MSPD * 0.15 * abil.Level;
    end
    end
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    SetExProp(buff, "ADD_MSPD", mspdadd);
    
    AttachGauge(self, GetBuffRemainTime(buff) * 0.001, 1, 1, "gauge_barrack_attack");

    local cumulativeDamage = GetBuffArgs(buff);
    if cumulativeDamage == nil then
        cumulativeDamage = 0;
end

    SetBuffArgs(buff, cumulativeDamage, 0, 0);

    local addDamageRate = 30 + (skillLevel * 5);
    SetExProp(buff, 'ADD_DAMAGE_RATE', addDamageRate);
    end

function SCR_BUFF_LEAVE_DeathVerdict_Buff(self, buff, arg1, arg2, over, isLastEnd)
    if IsDead(self) == 0 and isLastEnd == 1 then
        local caster = GetBuffCaster(buff);
        if caster ~= nil then
            local cumulativeDamage = GetBuffArgs(buff);
            if cumulativeDamage > 0 then
                local Oracle13_abil = GetAbility(caster, 'Oracle13')
                if Oracle13_abil ~= nil and 1 == Oracle13_abil.ActiveState then
                    cumulativeDamage = cumulativeDamage * (1 - (Oracle13_abil.Level * 0.1));
                end
                
                TakeDamage(self, caster, 'None', cumulativeDamage, 'Dark', 'Magic', 'AbsoluteDamage', HIT_DARK, HITRESULT_BLOW);
            end
        end
    end
    
    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    
    AttachGauge(self, 0, 1, 0);
end

function SCR_BUFF_ENTER_Circling_Buff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
	self.FixedMinSDR_BM = self.FixedMinSDR_BM + 1;
end

function SCR_BUFF_LEAVE_Circling_Buff(self, buff, arg1, arg2, over, isLastEnd)
	self.FixedMinSDR_BM = self.FixedMinSDR_BM - 1;
end

function SCR_BUFF_ENTER_CirclingIncreaseSR_Buff(self, buff, arg1, arg2, over)
    local increaseSR = 3
    SetExProp(buff, "CliclingAddSR", increaseSR)
    self.SR_BM = self.SR_BM + increaseSR
    
end

function SCR_BUFF_LEAVE_CirclingIncreaseSR_Buff(self, buff, arg1, arg2, over, isLastEnd)
    local increaseSR = GetExProp(buff, "CliclingAddSR")
    self.SR_BM = self.SR_BM - increaseSR
end

-- Archer_BlowGunPoison_Debuff
function SCR_BUFF_ENTER_Archer_BlowGunPoison_Debuff(self, buff, arg1, arg2, over)
    ShowEmoticon(self, 'I_emo_poison', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local caster = GetBuffCaster(buff);
    
    local atk = 0
    if caster ~= nil then
        atk = GET_SKL_DAMAGE(caster, self, "Wugushi_NeedleBlow");
    end
    
    SetBuffArgs(buff, atk, 0, 0);
end

function SCR_BUFF_UPDATE_Archer_BlowGunPoison_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local atk = GetBuffArgs(buff);
    local caster = GetBuffCaster(buff);
   
    if caster ~= nil then
        local skill = GetSkill(caster, 'Wugushi_NeedleBlow')
        if skill ~= nil then
            TakeDamage(caster, self, skill.ClassName, atk, "Poison", "Melee", "Melee", HIT_POISON_GREEN, HITRESULT_NO_HITSCP, 0, 0);
        end
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_Archer_BlowGunPoison_Debuff(self, buff, arg1, arg2, over)
   HideEmoticon(self, 'I_emo_poison')
end


function SCR_BUFF_ENTER_Zhendu_Buff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    local Zhenduskill = GetSkill(caster, 'Wugushi_Zhendu');
    if Zhenduskill ~= nil then
        SetExArgObject(self, "ZHENDU_OWNER", caster);
        SetBuffArgs(buff, Zhenduskill.Level, 0, 0);
    end

end

function SCR_BUFF_LEAVE_Zhendu_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Zhendu_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local caster = GetExArgObject(GetBuffCaster(buff), "ZHENDU_OWNER");
    local resposadd = 0;
    
    local abil = GetAbility(caster, "Wugushi7")
    if abil ~= nil then
        resposadd = resposadd + abil.Level * 7;
    end
    
    if IS_PC(self) == true then
        self.ResPoison_BM = self.ResPoison_BM - resposadd;
    else
        self.Poison_Def_BM = self.Poison_Def_BM - resposadd
    end
    
    local skill = GET_MON_SKILL(caster, "Wugushi_Zhendu")
    local damage = TryGetProp(skill, "SkillAtkAdd")
    if damage == nil then
        damage = 0;
    end
    
    local StrRate = TryGetProp(caster, "STR");
    if StrRate == nil then
        StrRate = 1;
    end

    StrRate = StrRate * 2
    if StrRate <= 1 then
        StrRate = 1
    end
    
    damage = math.floor(damage + StrRate);

    SetBuffArgs(buff, damage, 0, 0);
    SetExProp(buff, "ADD_POS", resposadd);
    
end

function SCR_BUFF_UPDATE_Zhendu_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local damage = GetBuffArgs(buff);
        if damage <= 0 then
        return 0;
    end

    local from = self;
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        from = caster;
  end

    TakeDamage(from, self, "None", damage, "Poison", "None", "TrueDamage", HIT_POISON_GREEN, HITRESULT_BLOW, 0, 0);

    return 1;
end

function SCR_BUFF_LEAVE_Zhendu_Debuff(self, buff, arg1, arg2, over)
    local resposadd = GetExProp(buff, "ADD_POS");
    
    if IS_PC(self) == true then
        self.ResPoison_BM = self.ResPoison_BM + resposadd;
    else
        self.Poison_Def_BM = self.Poison_Def_BM + resposadd
    end
    
end

function SCR_BUFF_ENTER_Bewitch_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    local debuffList, debuffCount = GetBuffListByProp(self, 'Keyword', 'Poison');
	
    if debuffList ~= nil and debuffCount >= 1 then
    	for i = 1, debuffCount do
    		local deBuff = debuffList[i];
    		if deBuff.Group1 == "Debuff" and deBuff.ClassName ~= 'Bewitch_Debuff' then
		        SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
		        RemoveBuff(self, 'Bewitch_Debuff');
		        PlayEffect(self, 'F_archer_wugu3_shot', 0.5, 1, 'BOT');
		        ActorVibrate(self, 1, 1, 30, 0);
		        AddBuff(caster, self, 'Confuse', arg1, 0, 10000, 1);
		        
		        break;
		    end
		end
    end
end

function SCR_BUFF_LEAVE_Bewitch_Debuff(self, buff, arg1, arg2, over)

end

-- Archer_VerminPot_Debuff
function SCR_BUFF_ENTER_Archer_VerminPot_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end
    
    local atk = GET_SKL_DAMAGE(caster, self, "Wugushi_ThrowGuPot");
    
    SetBuffArgs(buff, atk, 0, 0);
end

function SCR_BUFF_UPDATE_Archer_VerminPot_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local atk = GetBuffArgs(buff);
    if atk <= 0 then
        return 0;
    end
        
    local from = self;
    local caster = GetBuffCaster(buff);
    if caster ~= nil then    
        from = caster;
    end
    
    local skill = GetSkill(caster, 'Wugushi_ThrowGuPot')
    if skill ~= nil then
    TakeDamage(caster, self, skill.ClassName, atk, "Poison", "Melee", "Melee", HIT_POISON_GREEN, HITRESULT_NO_HITSCP, 0, 0);
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_Archer_VerminPot_Debuff(self, buff, arg1, arg2, over)
  --  HideEmoticon(self, 'I_emo_poison')
end


-- Archer_Detoxification_Buff
function SCR_BUFF_ENTER_Detoxify_Buff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end

    local debuff = GetBuffByProp(self, 'Keyword', 'Poison');

    if debuff ~= nil and debuff.Group1 == "Debuff" then
        --ObjectColorBlend(self, 50,80,60,255,0.5)
       
        if debuff.Lv <= arg1 then
            RemoveBuff(self, debuff.ClassName)
            
            local abil = GetAbility(caster, 'Wugushi1')
            if abil ~= nil then
                AddBuff(caster, self, 'Detoxify_After_Buff', abil.Level, 0, abil.Level * 4000, 1);
            end
        else
            local remainTime = GetBuffRemainTime(debuff);
            SetBuffRemainTime(self, debuff.ClassName, remainTime-3000);
        end
    end
    --ObjectColorBlend(self, 50,80,60,255,0.5)
    --RemoveBuffKeyword(self, 'Debuff', 'Poison', arg1, 1)  

end

function SCR_BUFF_LEAVE_Detoxify_Buff(self, buff, arg1, arg2, over)
    
    ObjectColorBlend(self, 255,255,255,255,1)
    
end


function SCR_BUFF_ENTER_Detoxify_After_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_Detoxify_After_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    RemoveBuffKeyword(self, 'Debuff', 'Poison', 99, 99)  
    return 1;
end

function SCR_BUFF_LEAVE_Detoxify_After_Buff(self, buff, arg1, arg2, over)

end


function SCR_ADD_CASTER_BUFF_REMAINTIME(self, fromBuffName, toBuffName, setReaminTime)

    local buff = GetBuffByName(self, fromBuffName);
    if buff ~= nil then
        local caster = GetBuffCaster(buff);
        if caster ~= nil then
            if "YES" == IsBuffApplied(caster, toBuffName) then
                SetBuffRemainTime(caster, toBuffName, setReaminTime);   
            end
        end
    end
end

function SCR_BUFF_ENTER_DiscernEvil_Buff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    local list, cnt = GetBuffList(self);
    for i = 1, cnt do
        local debuff = list[i]
        if debuff.Group1 == "Debuff" then
            if GetExProp(debuff, "DISCERNEVIL_DEBUFFTIME") == 1 then
                return
            end
            
            local remainTime = GetBuffRemainTime(debuff);
            local timeValue = remainTime * (0.25 + (arg1 * 0.05));
--            SetBuffRemainTime(self, debuff.ClassName, remainTime + timeValue);
            AddBuffRemainTime(self, debuff.ClassName, timeValue)
            
            SetExProp(debuff, "DISCERNEVIL_DEBUFFTIME", 1);
            
            if debuff.ClassName == "Hexing_Debuff" then
                SCR_ADD_CASTER_BUFF_REMAINTIME(self, "Hexing_Debuff", "Hexing_Buff", remainTime);
            end
        end
    end
end

function SCR_BUFF_LEAVE_DiscernEvil_Buff(self, buff, arg1, arg2, over)
    
    
end





-- TombLord_DEF
function SCR_BUFF_ENTER_TombLord_DEF(self, buff, arg1, arg2, over)

    local defadd = 0.05
  
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd
    
    SetExProp(buff, "ADD_DEF", defadd);
    
end

function SCR_BUFF_LEAVE_TombLord_DEF(self, buff, arg1, arg2, over)



    local defadd = GetExProp(buff, "ADD_DEF");

    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;

end



-- TombLord_ATK
function SCR_BUFF_ENTER_TombLord_ATK(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_TombLord_ATK(self, buff, arg1, arg2, over)

end




-- Fire
function SCR_BUFF_ENTER_Fire(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_flame', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_UPDATE_Fire(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    TakeDamage(caster, self, "None", arg1, "Fire", "Magic", "TrueDamage", HIT_FIRE, HITRESULT_BLOW, 0, 0);
    return 1;

end

function SCR_BUFF_LEAVE_Fire(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_flame')
end

-- Warning
function SCR_BUFF_ENTER_Warning(self, buff, arg1, arg2, over)



end

function SCR_BUFF_UPDATE_Warning(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    TakeDamage(caster, self, "None", IMCRandom(arg1/3, arg1/2), "None", "None", "None", HIT_BASIC, HITRESULT_BLOW, 0, 0);
    
    return 1;

end

function SCR_BUFF_LEAVE_Warning(self, buff, arg1, arg2, over)

end

-- Burn
function SCR_BUFF_ENTER_Burn(self, buff, arg1, arg2, over)


end

function SCR_BUFF_UPDATE_Burn(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    TakeDamage(caster, self, "None", arg2 / 5 * over, "None", "None", "None", HIT_BASIC, HITRESULT_BLOW, 0, 0);

    return 1;

end

function SCR_BUFF_LEAVE_Burn(self, buff, arg1, arg2, over)


end

-- Scud
function SCR_BUFF_ENTER_Scud(self, buff, arg1, arg2, over)

    local lv = arg1;

    local mspdadd = self.MSPD * 0.2
    
    --AddStamina(self, 3000);
    
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
    

end

function SCR_BUFF_LEAVE_Scud(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM - mspdadd;

end

-- Cure
function SCR_BUFF_ENTER_Cure_Buff(self, buff, arg1, arg2, over)
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end

  REMOVE_BUFF_BY_LEVEL(self, "Debuff", 2);
    
end

function SCR_BUFF_LEAVE_Cure_Buff(self, buff, arg1, arg2, over)


end


-- Cure_Debuff
function SCR_BUFF_ENTER_Cure_Debuff(self, buff, arg1, arg2, over)
    local lv = arg1;
    local caster = GetBuffCaster(buff);
    
    local damage = GET_SKL_DAMAGE(caster, self, 'Cleric_Cure');
    local skill = GET_MON_SKILL(caster, 'Cleric_Cure');
    
--  local divineAtkAdd = skill.SkillAtkAdd
    local addValue = 0
    
    local pad = GetPadByBuff(caster, buff);
    if pad ~= nil then
        addValue = GetPadArgNumber(pad, 1);
    end
    
--  divineAtkAdd = addValue - divineAtkAdd
--  
--  if divineAtkAdd < 0 then
--      divineAtkAdd = 0;
--  end

    TakeDamage(caster, self, "Cleric_Cure", damage)

end

function SCR_BUFF_LEAVE_Cure_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Lunge_Buff(self, buff, arg1, arg2, over)

--  local dradd = self.DR * (0.1 * arg1)
    local addlv = 20 * arg1;
    local dradd = 50 + addlv;

    self.DR_BM = self.DR_BM + dradd;
    
    SetExProp(buff, "ADD_DR", dradd);


end

function SCR_BUFF_LEAVE_Lunge_Buff(self, buff, arg1, arg2, over)

    local dradd = GetExProp(buff, "ADD_DR");

    self.DR_BM = self.DR_BM - dradd;

end

function SCR_BUFF_ENTER_Lunge_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Lunge_Debuff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_AttaqueCoquille_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_AttaqueCoquille_Debuff(self, buff, arg1, arg2, over)

end


--Warrior_ScarletMacaw_Debuff
function SCR_BUFF_ENTER_Warrior_ScarletMacaw_Debuff(self, buff, arg1, arg2, over)
    SetExProp(self, "isScarletMacaw_Debuff", 1)
end

function SCR_BUFF_LEAVE_Warrior_ScarletMacaw_Debuff(self, buff, arg1, arg2, over)
    DelExProp(self, "isScarletMacaw_Debuff")
end

-- FireWall_Buff
function SCR_BUFF_ENTER_FireWall_Buff(self, buff, arg1, arg2, over)

    local fireadd = 0;

    local caster =  GetBuffCaster(buff);
    local pyromancer2_abil = GetAbility(caster, 'Pyromancer2');
    if pyromancer2_abil ~= nil then
        local stat = caster.INT / 5
        fireadd = math.floor(pyromancer2_abil.Level * stat) 
--  AddBuff(self, target, 'FireWall_Debuff', arg1, arg2, 8000)
    end

    self.Fire_Atk_BM = self.Fire_Atk_BM + fireadd;
    SetExProp(buff, "ADD_FIREATK", fireadd);

end

function SCR_BUFF_LEAVE_FireWall_Buff(self, buff, arg1, arg2, over)

    local fireadd = GetExProp(buff, "ADD_FIREATK");
    self.Fire_Atk_BM = self.Fire_Atk_BM - fireadd;

end


--Warrior_Finestra_Buff
function SCR_BUFF_ENTER_Finestra_Buff(self, buff, arg1, arg2, over)

    local crtrate = 10 * arg1
    local blkrate = 15 * arg1
    local drarate = 15 * arg1
    
    local crtadd = 50 + crtrate
    local dradd = drarate
    local blkadd = 25 + blkrate
    local sradd = 0;
    
    local skill = GetSkill(self, "Hoplite_Finestra")
    if skill == nil then
        return
    end
    
    local abil = GetAbility(self, 'Hoplite9');
    if abil ~= nil and skill.Level >= 3 then
        dradd = dradd * 2;
        sradd = 3;
    end
    
    crtadd = math.floor(crtadd)
    dradd = math.floor(dradd)

    self.CRTHR_BM = self.CRTHR_BM + crtadd;
    self.DR_BM = self.DR_BM - dradd;
    self.BLK_BM = self.BLK_BM + blkadd
    self.SR_BM = self.SR_BM + sradd
    
    SetExProp(buff, "ADD_DR", dradd);
    SetExProp(buff, "ADD_CRT", crtadd);
    SetExProp(buff, "ADD_BLK", blkadd);
    SetExProp(buff, "ADD_SR", sradd);

    local abil = GetAbility(self, 'Hoplite4');
    if abil ~= nil then
        local addAtk = self.INT * 0.1;
        self.PATK_BM = self.PATK_BM + addAtk;
        SetExProp(buff, "ADD_ATK_ABIL", addAtk);
    end

    RunScript('SCR_FINESTRA_TEMP', self, caster)

end

function SCR_FINESTRA_TEMP(self)
    sleep(400);
    PlayAnim(self, "SKL_FINESTRA_ASTD", 1)
end


function SCR_BUFF_LEAVE_Finestra_Buff(self, buff, arg1, arg2, over)

    local dradd = GetExProp(buff, "ADD_DR");
    local crtadd = GetExProp(buff, "ADD_CRT");
    local blkadd = GetExProp(buff, "ADD_BLK");
    local sradd = GetExProp(buff, "ADD_SR");
    
    self.DR_BM = self.DR_BM + dradd;
    self.CRTHR_BM = self.CRTHR_BM - crtadd;
    self.BLK_BM = self.BLK_BM - blkadd;
    self.SR_BM = self.SR_BM - sradd;

    local addAtk = GetExProp(buff, "ADD_ATK_ABIL");
    self.PATK_BM = self.PATK_BM - addAtk;
    
    local skill = GetSkill(self, 'Normal_Attack')
    ChangeSkillAniNameImmediately(self, 'Normal_Attack', 'None');
    ChangeSkillAniNameImmediately(self, 'Normal_Attack_TH', 'None');
    
    Invalidate(self, "DR");
    Invalidate(self, "CRTHR");
    Invalidate(self, "BLK");
    Invalidate(self, "MINMATK");
    Invalidate(self, "MAXMATK");


    --PlayAnim(self, "ASTD", 1)
end


-- EpeeGarde_Buff
function SCR_BUFF_ENTER_EpeeGarde_Buff(self, buff, arg1, arg2, over)
    local lhItem = GetEquipItem(self, 'LH'); 
    if lhItem == nil then
        return;
    end

    if lhItem.DEF <= 0 then
        return;
    end

    self.DEF_BM = self.DEF_BM - lhItem.DEF
    SetExProp(buff, "ADD_DEF", lhItem.DEF);
    RunScript('SCR_EPEEGARDE_TEMP', self, caster)
end

function SCR_EPEEGARDE_TEMP(self)
    sleep(400);
    PlayAnim(self, "SKL_EPEEGARDE_ASTD", 1)
end

function SCR_BUFF_UPDATE_EpeeGarde_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    local ridingCompanion = GetRidingCompanion(self);
    if ridingCompanion ~= nil then
        return 0;
    end

    local lhItem = GetEquipItem(self, 'LH');
    

    if lhItem ~= nil then

        local defadd = GetExProp(buff, "ADD_DEF");

        if lhItem.DEF ~= defadd then
            self.DEF_BM = self.DEF_BM + defadd;
            self.DEF_BM = self.DEF_BM - lhItem.DEF;
            SetExProp(buff, "ADD_DEF", lhItem.DEF);
            Invalidate(self, "DEF");
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_EpeeGarde_Buff(self, buff, arg1, arg2, over)
    local defadd = GetExProp(buff, "ADD_DEF");
    if 0 < defadd then
        self.DEF_BM = self.DEF_BM + defadd;
        Invalidate(self, "DEF");
    end
    
    local skill = GetSkill(self, 'Normal_Attack')
    ChangeSkillAniNameImmediately(self, 'Normal_Attack', 'None');
    ChangeSkillAniNameImmediately(self, 'Normal_Attack_TH', 'None');
    
    --PlayAnim(self, "ASTD", 1)
end


--Rain_Debuff
function SCR_BUFF_ENTER_Rain_Debuff(self, buff, arg1, arg2, over)
  SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
  local mspdadd = self.MSPD * 0.1
    self.MSPD_BM = self.MSPD_BM - mspdadd
    SetExProp(buff, "ADD_MSPD", mspdadd);

end


function SCR_BUFF_UPDATE_Rain_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)


    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    
    local damage = GET_SKL_DAMAGE(caster, self, 'Elementalist_Rain');
    local skill = GET_MON_SKILL(caster, 'Elementalist_Rain');
    
    if self.Attribute == "Fire" then
        TakeDamage(caster, self, "Elementalist_Rain", damage, "None", "Magic", "Magic", HIT_BASIC, HITRESULT_BLOW, 0, 0);
    end
  
    return 1;

end

function SCR_BUFF_LEAVE_Rain_Debuff(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM + mspdadd;


end





--HIGHGUARD_Buff
function SCR_BUFF_ENTER_HighGuard_Buff(self, buff, arg1, arg2, over)
    RunScript('SCR_HIGHGUARD_TEMP', self, caster)
    
    local blkAddLv = 30
    local blkAdd = 100 + arg1 * blkAddLv
    
    self.BLK_BM = self.BLK_BM + blkAdd;
	
    SetExProp(buff, "ADD_HIGHGUARD_BLK", blkAdd);
end

function SCR_HIGHGUARD_TEMP(self)
    sleep(400);
    PlayAnim(self, "SKL_HIGHGUARD_ASTD", 1)
end


function SCR_BUFF_LEAVE_HighGuard_Buff(self, buff, arg1, arg2, over)
    local skill = GetSkill(self, 'Normal_Attack')
    ChangeSkillAniName(self, 'Normal_Attack', 'None');
    
    local blkAdd = GetExProp(buff, "ADD_HIGHGUARD_BLK")
    
    self.BLK_BM = self.BLK_BM - blkAdd;
end


--Yekub_skill2
function SCR_BUFF_ENTER_Yekub_skill2(self, buff, arg1, arg2, over)
    

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    TakeDamage(caster, self, "None", (caster.MINMATK + caster.MAXMATK) / 10, "None", "None", "None", HIT_BASIC, HITRESULT_BLOW, 0, 0);


end

function SCR_BUFF_LEAVE_Yekub_skill2(self, buff, arg1, arg2, over)


end

function SCR_BUFF_ENTER_SpearLunge_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_SpearLunge_Debuff(self, buff, arg1, arg2, over)

end


--Heal_Buff
function SCR_BUFF_ENTER_Heal_Buff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    
    local healValue = math.floor(self.MHP * 0.05);
    
    local minHealValue = 0;
    local maxHealValue = 0;
    
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            minHealValue = math.floor(GetPadArgNumber(pad, 1));
            maxHealValue = math.floor(GetPadArgNumber(pad, 2));
        end
    end
    
    if IsBuffApplied(self, 'Restoration_Buff') == 'YES' then
        minHealValue = minHealValue * 2;
        maxHealValue = maxHealValue * 2;
    end
    
    minHealValue = healValue + minHealValue;
    maxHealValue = healValue + maxHealValue;
    
    local healRnd = IMCRandom(minHealValue, maxHealValue);
    
    local Ayin_sof_buff = GetBuffByName(self, 'Ayin_sof_Buff')
    local Ayin_sof_arg3 = 0;
    if Ayin_sof_buff ~= nil then
        Ayin_sof_arg3 = GetBuffArgs(Ayin_sof_buff);
    end
    
    if IsSameActor(self, caster) == "NO" or Ayin_sof_arg3 == 0 then
        healRnd = healRnd + (healRnd * arg2);
    end
    Heal(self, healRnd, 0, nil, buff.ClassName);
end


function SCR_BUFF_LEAVE_Heal_Buff(self, buff, arg1, arg2, over)


end

-- Heal_Debuff
function SCR_BUFF_ENTER_Heal_Debuff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);

    if caster == nil then
        return
    end
    
    local damage = GET_SKL_DAMAGE(caster, self, 'Cleric_Heal');
    local skill = GET_MON_SKILL(caster, 'Cleric_Heal');
    
--  local divineAtkAdd = skill.SkillAtkAdd
    local addValue = 0
    
    local pad = GetPadByBuff(caster, buff);
    if pad ~= nil then
        addValue = GetPadArgNumber(pad, 1);
    end
    
    if IsBuffApplied(caster, 'Blessing_Buff') == "NO" then
        TakeDamage(caster, self, skill.ClassName, damage, "Holy", "Magic", "Magic", HIT_MOTION, HITRESULT_BLOW);
    else
        for i = 1 , 2 do
            local key = GenerateSyncKey(self);
            StartSyncPacket(self, key);
            TakeDamage(caster, self, skill.ClassName, damage, "Holy", "Magic", "Magic", HIT_MOTION, HITRESULT_BLOW);
            EndSyncPacket(self, key, i * 0.2);
            ExecSyncPacket(self, key);
        end
    end
end

function SCR_BUFF_LEAVE_Heal_Debuff(self, buff, arg1, arg2, over)


end




function SCR_BUFF_ENTER_Cleric_Venom_Debuff(self, buff, arg1, arg2, over)
    

end

function SCR_BUFF_UPDATE_Cleric_Venom_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local lv = arg1

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end

    local value = ((caster.MINMATK + caster.MAXMATK) * (0.5 + (lv * 0.1))) / IMCRandomFloat(1, 1.3)

    TakeDamage(caster, self, "None", math.min(value, self.MHP * 0.2), "None", "None", "None", HIT_BASIC, HITRESULT_BLOW, 0, 0);

    return 1;

end

function SCR_BUFF_LEAVE_Cleric_Venom_Debuff(self, buff, arg1, arg2, over)


end



function SCR_BUFF_ENTER_Gae_Bulg_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_Gae_Bulg_Debuff(self, buff, arg1, arg2, over)

end






function SCR_BUFF_ENTER_Warrior_GreatBearFormation_Buff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    local maxatk = GetExProp(caster, "MAX_ATK");
    local minatk = GetExProp(caster, "MIN_ATK");
    local maxdef = GetExProp(caster, "MAX_DEF");

    local atkadd = (maxatk - self.MAXPATK);
    local defadd = (maxdef - self.DEF);

    SetExProp(buff, "ADD_ATK", atkadd);
    SetExProp(buff, "ADD_DEF", defadd);

    self.ATK_BM = self.ATK_BM + atkadd;
    self.DEF_BM = self.DEF_BM + defadd;

end

function SCR_BUFF_LEAVE_Warrior_GreatBearFormation_Buff(self, buff, arg1, arg2, over)

    local addatk = GetExProp(buff, "ADD_ATK");
    local adddef = GetExProp(buff, "ADD_DEF");

    self.ATK_BM = self.ATK_BM - addatk;
    self.DEF_BM = self.DEF_BM - adddef;
    

end


function SCR_BUFF_ENTER_Warrior_Parrying_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Warrior_Parrying_Buff(self, buff, arg1, arg2, over)
end

-- Exchange

function SCR_BUFF_ENTER_Exchange(self, buff, arg1, arg2, over)
    local hp = self.SP - self.HP
    local sp = self.HP - self.SP

    AddHP(self, hp);
    AddSP(self, sp);

    local shieldValue = self.MHP / 4
    GIVE_BUFF_SHIELD(self, buff, shieldValue)   
end

function SCR_BUFF_UPDATE_Exchange(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_Exchange(self, buff, arg1, arg2, over)
    TAKE_BUFF_SHIELD(self, buff)
end

function SCR_BUFF_ENTER_spector_shield(self, buff, arg1, arg2, over)

    local shieldValue = self.MHP / 3
    GIVE_BUFF_SHIELD(self, buff, shieldValue)
end

function SCR_BUFF_UPDATE_spector_shield(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_spector_shield(self, buff, arg1, arg2, over)
    TAKE_BUFF_SHIELD(self, buff)
end


-- Rejuvenation
function SCR_BUFF_ENTER_Rejuvenation(self, buff, arg1, arg2, over)


end

function SCR_BUFF_UPDATE_Rejuvenation(self, buff, arg1, arg2, RemainTime, ret, over)
    local heal = self.MHP / 20
    local healsp = self.MSP / 20

    if heal < 5 then
        heal = 5;
    end
    if healsp < 3 then
        healsp = 3;
    end
  Heal(self, heal, 0);
  HealSP(self, healsp, 0);

        return 1;
        
end
    


function SCR_BUFF_LEAVE_Rejuvenation(self, buff, arg1, arg2, over)

end





function SCR_BUFF_ENTER_JincanGu_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local caster = GetBuffCaster(buff);
--  ChangeScale(self, 2, 60)
    ObjectColorBlend(self, 100, 100, 100, 255, 1, 10)
    SetExProp(self, 'JINCAN_COUNT', 1);
    SetExProp(buff, "Wugushi_JincanGu_COUNT", 0)
end

function SCR_BUFF_UPDATE_JincanGu_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local count = GetExProp(self, 'JINCAN_COUNT')
    SetExProp(self, 'JINCAN_COUNT', count + 1);
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
--      local damage = GET_SKL_DAMAGE(caster, self, 'Wugushi_JincanGu');
        local skill = GET_MON_SKILL(caster, 'Wugushi_JincanGu');
        local damage = TryGetProp(skill, "SkillAtkAdd")
        
        if damage == nil then
            damage = 0;
        end
        
        local baseLvRate = TryGetProp(caster, "Lv");
        if baseLvRate == nil then
            baseLvRate = 1;
        end
        
        baseLvRate = baseLvRate * 0.015
        
        damage = math.floor(damage * baseLvRate)
--        damage = math.floor(damage)
        
        TakeDamage(caster, self, "Wugushi_JincanGu", damage, "Poison", "None", "TrueDamage", HIT_POISON, HITRESULT_BLOW)
    end
    
    return 1; 
end
    


function SCR_BUFF_LEAVE_JincanGu_Debuff(self, buff, arg1, arg2, over)
  SetExProp(self, "Lv", arg1)
  SetExProp_Pos(self, "JINCANGU", GetPos(self))
  ObjectColorBlend(self, 255, 255, 255, 255, 1, 2)

    local caster = GetBuffCaster(buff);
    
    if IsDead(self) == 1 then
        local summonRate = IMCRandom(1, 100);
        local rate = 100;
        if rate > summonRate then
            --RunScript('SCR_SUMMON_JINCANGU', self, caster)
            local skl = GetSkill(caster, "Wugushi_JincanGu");
            if skl ~= nil then
                local x, y, z = GetPos(self)
                local createCount = GetExProp(buff, "Wugushi_JincanGu_COUNT");
                local loopCount = skl.Level - createCount;
                if loopCount >= 1 then
                    for i = 1, loopCount do
                        RunScript("SCR_WUGUSHI_JINCANGU", self, sklID, damage, caster, x, y, z);
                    end
                end
            end

        end
    --else
    --  ChangeScale(self, 0.5, 5)
    end

end



-- Rejuvenation
function SCR_BUFF_ENTER_Cleric_Ziva_Buff(self, buff, arg1, arg2, over)


end

function SCR_BUFF_UPDATE_Cleric_Ziva_Buff(self, buff, arg1, arg2, RemainTime, ret, over)

    local heal = self.MHP / 10

    if heal < 5 then
        heal = 5;
    end

  Heal(self, heal, 0);
  
        return 1;
        
end
    


function SCR_BUFF_LEAVE_Cleric_Ziva_Buff(self, buff, arg1, arg2, over)

end

-- Rejuvenation
function SCR_BUFF_ENTER_RoyalRumbleBoss(self, buff, arg1, arg2, over)


end

function SCR_BUFF_UPDATE_RoyalRumbleBoss(self, buff, arg1, arg2, RemainTime, ret, over)
    local heal = math.floor(self.MHP / 20)
    
    Heal(self, heal, 0);
    return 1;
        
end
    


function SCR_BUFF_LEAVE_RoyalRumbleBoss(self, buff, arg1, arg2, over)

end

-- monster self heal
function SCR_BUFF_ENTER_SelfHeal(self, buff, arg1, arg2, over)

end


function SCR_BUFF_UPDATE_SelfHeal(self, buff, arg1, arg2, RemainTime, ret, over)

    local heal = (arg1 + over + 1);
    Heal(self, heal, 0);

    return 1;

end

function SCR_BUFF_LEAVE_SelfHeal(self, buff, arg1, arg2, over)

      UnHoldMonScp(self);

end


function SCR_BUFF_ENTER_Den_Heal(self, buff, arg1, arg2, over)

end


function SCR_BUFF_UPDATE_Den_Heal(self, buff, arg1, arg2, RemainTime, ret, over)

    local heal = self.MHP / 20
    Heal(self, heal, 0);

    return 1;

end

function SCR_BUFF_LEAVE_Den_Heal(self, buff, arg1, arg2, over)


end

-- GuardImpact
function SCR_BUFF_ENTER_GuardImpact(self, buff, arg1, arg2, over)

    self.CRTDR_BM = self.CRTDR_BM - 10000;

end

function SCR_BUFF_LEAVE_GuardImpact(self, buff, arg1, arg2, over)

    self.CRTDR_BM = self.CRTDR_BM + 10000;

end

-- Provoke
function SCR_BUFF_ENTER_SwashBuckling_Buff(self, buff, arg1, arg2, over)
    local addHateCount = arg1 + 6
    self.MaxHateCount_BM = self.MaxHateCount_BM + addHateCount;
    SetExProp(buff, "ADD_HATE", addHateCount);
end

function SCR_BUFF_LEAVE_SwashBuckling_Buff(self, buff, arg1, arg2, over)
    self.MaxHateCount_BM = self.MaxHateCount_BM - GetExProp(buff, "ADD_HATE");
end


--Warrior_Provoke_Debuff
function SCR_BUFF_ENTER_SwashBuckling_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    ObjectColorBlend(self, 255, 160, 150, 255, 1, 1.5)
    local spdAdd = 10
    local buffCaster = GetBuffCaster(buff);
    if IS_PC(self) == false then
        SetFociblyHater(self, buffCaster);
        AddBuff(buffCaster, self, "ProvocationImmunity_Debuff", 0, 0, 30000, 1);
        if self.MonRank ~= "BOSS" then
            self.MSPD_BM = self.MSPD_BM + spdAdd
            SetExProp(self, "SWASHBUCKLING_SPD", spdAdd);
        end
    end
end

function SCR_BUFF_LEAVE_SwashBuckling_Debuff(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255, 255, 255, 255, 1, 1);
    local buffCaster = GetBuffCaster(buff);
    if buffCaster ~= nil then
        if IS_PC(self) == false then
            if self.MonRank ~= "BOSS" then
                self.MSPD_BM = self.MSPD_BM - GetExProp(self, "SWASHBUCKLING_SPD")
            end
            
            local currentTarget = GetFociblyHater(self)
            if currentTarget ~= nil then
                if IsSameActor(currentTarget, buffCaster) == "YES" then
                    RemoveFociblyHater(self)
                end
            end
        end
    end
end


-- SwashBuckling_AbilBuff
function SCR_BUFF_ENTER_SwashBuckling_AbilBuff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_SwashBuckling_AbilBuff(self, buff, arg1, arg2, over)

end


--Mastema_Debuff
function SCR_BUFF_ENTER_Mastema_Debuff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    
    local damage = GET_SKL_DAMAGE(caster, self, 'Warlock_Mastema');
    local skill = GET_MON_SKILL(caster, 'Warlock_Mastema');

    local divineAtkAdd = skill.SkillAtkAdd
    local addValue = 0
    
    local pad = GetPadByBuff(caster, buff);
    if pad ~= nil then
        addValue = GetPadArgNumber(pad, 1);
    end
    
    divineAtkAdd = addValue - divineAtkAdd
    
    if divineAtkAdd < 0 then
        divineAtkAdd = 0;
    end
    
    TakeDamage(caster, self, skill.ClassName, damage + divineAtkAdd, "Dark", "Magic", "Magic", HIT_MOTION, HITRESULT_BLOW, 0, 0);
    
    if GetObjType(self) == OT_MONSTERNPC then
        local addHate = (damage + skill.SkillAtkAdd) * 10
    
        local abil = GetAbility(caster, "Warlock10")
        if abil ~= nil then
            addHate = math.floor(addHate * (1 - abil.Level * 0.01))
        end

        InsertHate(self, caster, addHate);
    end

    local Warlock13 = GetAbility(caster, "Warlock13")
    if nil ~= Warlock13 then
        local stradd = Warlock13.Level * 10
        local intadd = Warlock13.Level * 10
        local mnaadd = Warlock13.Level * 10
        local adddex = Warlock13.Level * 10

        self.STR_BM = self.STR_BM - stradd;
        self.INT_BM = self.INT_BM - intadd;
        self.MNA_BM = self.MNA_BM - mnaadd;
        self.DEX_BM = self.DEX_BM - adddex;
    
        SetExProp(buff, "ADD_STR", stradd);
        SetExProp(buff, "ADD_INT", intadd);
        SetExProp(buff, "ADD_MNA", mnaadd);
        SetExProp(buff, "ADD_DEX", adddex);
    end
end

function SCR_BUFF_UPDATE_Mastema_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster == nil then
        return 1;
    end
    
    local Warlock13 = GetAbility(caster, "Warlock13")
    if Warlock13 == nil then
        return 1;
    end

    local damage = GET_SKL_DAMAGE(caster, self, 'Warlock_Mastema');
    local skill = GET_MON_SKILL(caster, 'Warlock_Mastema');

    local divineAtkAdd = skill.SkillAtkAdd
    local addValue = 0
    
    local pad = GetPadByBuff(caster, buff);
    if pad ~= nil then
        addValue = GetPadArgNumber(pad, 1);
    end
    
    divineAtkAdd = addValue - divineAtkAdd
    
    if divineAtkAdd < 0 then
        divineAtkAdd = 0;
    end

    damage = (damage + divineAtkAdd) * 0.5;

    TakeDamage(caster, self, skill.ClassName, damage, "Dark", "Magic", "Magic", HIT_MOTION, HITRESULT_NO_HITSCP, 0, 0);
    
    return 1;
end

function SCR_BUFF_LEAVE_Mastema_Debuff(self, buff, arg1, arg2, over)
    local stradd = GetExProp(buff, "ADD_STR")
    local intadd = GetExProp(buff, "ADD_INT")
    local mnaadd = GetExProp(buff, "ADD_MNA")
    local adddex = GetExProp(buff, "ADD_DEX")
    if 0 < stradd then
        self.STR_BM = self.STR_BM + stradd
    end
    if 0 < intadd then
        self.INT_BM = self.INT_BM + intadd;
    end
    if 0 < mnaadd then
        self.MNA_BM = self.MNA_BM + mnaadd;
    end
    if 0 < adddex then
        self.DEX_BM = self.DEX_BM + adddex;
    end

end

function SCR_BUFF_ENTER_Agony_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_Agony_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local damage = GET_SKL_DAMAGE(caster, self, 'Warlock_PoleofAgony');
        local skill = GET_MON_SKILL(caster, 'Warlock_PoleofAgony');
        
        if skill ~= nil then
            local damrate = RemainTime / (10000 + GET_ABIL_LEVEL(caster, "Warlock3") * 800)
            local abil = GetAbility(caster, "Warlock11")
            if abil ~= nil then
                local lowerlimit = abil.Level * 0.15;
                if lowerlimit > damrate then
                    damrate = lowerlimit
                end
            end
            damage = damage * damrate
            
            TakeDamage(caster, self, skill.ClassName, damage, "Dark", "Magic", "Magic", HIT_MOTION, HITRESULT_NO_HITSCP, 0, 0);
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_Agony_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Invocation_Debuff(self, buff, arg1, arg2, over)
    if GetExProp_Str(self, 'COPY_EFFECTNAME') ~= 'None' then
        local sklLevel = GetExProp(self, 'COPY_SKLLEVEL');
        SUMMON_INVOCATION_MONSTER(self, self, sklLevel, 20);
        RemoveBuff(self, 'Invocation_Debuff');
        SkillCancel(self);
    end
end

function SCR_BUFF_LEAVE_Invocation_Debuff(self, buff, arg1, arg2, over)

end

-- LevelUpBuff
function SCR_BUFF_ENTER_LevelUpBuff(self, buff, arg1, arg2, over)

    
end

function SCR_BUFF_LEAVE_LevelUpBuff(self, buff, arg1, arg2, over)


   local objList, objCount = SelectObject(self, 200, 'ENEMY');
   local x, y, z = GetPos(self);
      for i = 1, objCount do
        local obj = objList[i]; 
        if IS_PC(obj) == false then
            local dmg = (self.MAXPATK + self.MAXMATK) / 3
        
            if obj.HPCount > 0 then
                dmg = 1
            end
        
            TakeDamage(self, obj, "None", dmg, "None", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
--            local angle = GetAngleFromPos(obj, x, z);
--            if obj.MonRank ~= 'Boss' then
--                if obj.HPCount == 0 then
--                    if GetPropType(obj, 'MoveType') ~= nil and obj.MoveType ~= 'Holding' then
--                        KnockDown(obj, self, 100, angle, 40, 1, 1, 100)
--                    end
--                end
--            end
        end
    end
end

--Cleric_Flins
function SCR_BUFF_ENTER_Cleric_Flins_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Cleric_Flins_Buff(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_Cleric_Flins_Debuff(self, buff, arg1, arg2, over)

    Invalidate(self, "DEF");
    
    local dg = self.DEF *  (0.05 * over);
    
    self.DEF_BM = self.DEF_BM - dg; 
    
    SetExProp(buff, "TOTAL_DG", dg)

end

function SCR_BUFF_LEAVE_Cleric_Flins_Debuff(self, buff, arg1, arg2, over)



    local dg = GetExProp(buff, "TOTAL_DG")
    
    self.DEF_BM = self.DEF_BM + dg;

end




function SCR_BUFF_ENTER_Dodola_Buff(self, buff, arg1, arg2, over)
--local CoolList, cnt = GetClassList("CoolDown");
--   for i = 0 , cnt - 1 do
--   local cal = GetClassByIndexFromList(CoolList , i)
--   AddCoolDown(self, cal.ClassName, arg1 * -50000000)
--   end

end

function SCR_BUFF_LEAVE_Dodola_Buff(self, buff, arg1, arg2, over)


end

function SCR_BUFF_ENTER_Pass_Buff(self, buff, arg1, arg2, over)
    local sklList, cnt = GetPCSkillList(self);
    local downList = {};
    if cnt ~= nil then
        local skillCooldownList = { };
        local totalSkillCooldown = 0;
    for i = 1, cnt do
        local skl = sklList[i]
        local result = CAN_REMAINCOOL_TIME_FOR_PASS_BUFF(downList, skl);
        if result == "YES" then
            local cls = GetClass("CoolDown", skl.CoolDownGroup)
            if cls ~= nil then
                        local skillCooldown = GetCoolDown(self, cls.ClassName);
                        if skillCooldown >= (arg1 * 5000) then
                            skillCooldown = arg1 * 5000;
                        end
                        
                        skillCooldownList[#skillCooldownList + 1] = skillCooldown;
                        totalSkillCooldown = totalSkillCooldown + skillCooldown;
                        
                AddCoolDown(self, cls.ClassName, arg1 * -5000)
                    SetExProp(skl, "PASS_COOLDOWN", 1)
                downList[#downList + 1] = cls.ClassName;
            end
        end
    end
--        if totalSkillCooldown > 0 then
--            local myZoneName = GetZoneName(self);
--            if myZoneName == 'mission_groundtower_1' or myZoneName == 'mission_groundtower_2' then
--                local jobObj = GetJobObject(self);
--                local jobCtrlType = TryGetProp(jobObj, 'CtrlType');
--                if jobCtrlType == nil then
--                    jobCtrlType = 'None';
--                end
--                
--                IMC_LOG('INFO_SKILL_PASS_DECREASED_TIME', 'PassSkillLevel : ' .. arg1 .. ' / JobSeries : ' .. jobCtrlType .. ' / TotalSkillCooldown : ' .. totalSkillCooldown .. ' / TotalSkillCount : ' .. #skillCooldownList)
--            end
--        end
end
end

function CAN_REMAINCOOL_TIME_FOR_PASS_BUFF(downList, skl)
    if GetExProp(skl, "PASS_COOLDOWN") == 1 then
        return "NO"
    end
    
    if TryGetProp(skl, "CommonType") == "Item" then
        return "NO"
    end
    
    if skl.ClassName == "Chronomancer_Pass" or skl.ClassName == "Musketeer_PrimeAndLoad" then
        return "NO"
    end

    if IsCoolTime(skl) <= 0 then
        return "NO"
    end

    for i = 1, #downList do
        if downList[i] == skl.CoolDownGroup then
            return "NO"
        end
    end

    return "YES"
end

function SCR_BUFF_LEAVE_Pass_Buff(self, buff, arg1, arg2, over)


end


-- Daino_Buff

function SCR_BUFF_ENTER_Daino_Buff(self, buff, arg1, arg2, over)
--    local countadd = arg1 + 1;
--    self.LimitBuffCount_BM = self.LimitBuffCount_BM + countadd
--    SetExProp(buff, "ADD_COUNT", countadd)
    local addAttackSpeed = 0;
    
    local abil_Kriwi21 = GetAbility(self, "Kriwi21");
    if abil_Kriwi21 ~= nil and abil_Kriwi21.ActiveState == 1 then
        addAttackSpeed = 10 * arg1;
    end
    
    SetExProp(buff, "ADD_DAINO_ATKSPD", addAttackSpeed);
    
    SET_NORMAL_ATK_SPEED(self, -addAttackSpeed);
end

function SCR_BUFF_LEAVE_Daino_Buff(self, buff, arg1, arg2, over)
--    local countadd = GetExProp(buff, "ADD_COUNT")
--    self.LimitBuffCount_BM = self.LimitBuffCount_BM - countadd
    local addAttackSpeed = GetExProp(buff, "ADD_DAINO_ATKSPD");
    
    SET_NORMAL_ATK_SPEED(self, addAttackSpeed);
end



-- Resurrection_Buff
function SCR_BUFF_ENTER_Resurrection_Buff(self, buff, arg1, arg2, over)
    
    local caster = GetBuffCaster(buff);
    local healHP = arg1 * 5;

    if healHP > 100 then
        healHP = 100;
    end
    
    if IsDead(self) == 1 then 
        ResurrectPc(self, "Resurrection", 0, math.max(5, healHP));
        
        if IsPVPServer(self) == 1 then
            local count = GetExProp(self, "RESURRECTION_COUNT")
            SetExProp(self, "RESURRECTION_COUNT", count-1)
        end
    end

end

function SCR_BUFF_LEAVE_Resurrection_Buff(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_Cleric_Revival_Buff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local reviveSkl = GetSkill(caster, 'Priest_Revive')
        if reviveSkl ~= nil then
            SetBuffArgs(buff, reviveSkl.Level, 0, 0);
            
        end
    end
    
    if IsPVPServer(self) == 1 then
        local count = GetExProp(self, "REVIVE_COUNT")
        SetExProp(self, "REVIVE_COUNT", count-1)
    end
end

function SCR_BUFF_LEAVE_Cleric_Revival_Buff(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_Cleric_Revival_Leave_Buff(self, buff, arg1, arg2, over)

    RemoveBuff(self, "Cleric_Revival_Buff"); 
    self.MaxDefenced_BM = self.MaxDefenced_BM + 1;
    Heal(self, self.MHP*arg1*0.05, 0)
end

function SCR_BUFF_LEAVE_Cleric_Revival_Leave_Buff(self, buff, arg1, arg2, over)
    self.MaxDefenced_BM = self.MaxDefenced_BM - 1;
end





function SCR_BUFF_ENTER_Restoration_Buff(self, buff, arg1, arg2, over)
    local addrhp = 0;
    local addrsp = 0;
--    local rhprate = 0;
    local lv = arg1;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local skill = GetSkill(caster, "Paladin_Restoration");
        if skill ~= nil then
            addrhp = SCR_GET_Restoration_Ratio(skill);
            
            local Paladin7_abil = GetAbility(caster, "Paladin7")
            if Paladin7_abil ~= nil then
                addrsp = addrsp + Paladin7_abil.Level * 10
            end
        end
    end
    
    addrhp = math.floor(addrhp)
    
    self.RHP_BM = self.RHP_BM + addrhp
    self.RSP_BM = self.RSP_BM + addrsp
    
    SetExProp(buff, "ADD_RHP", addrhp);
    SetExProp(buff, "ADD_RSP", addrsp);
end


function SCR_BUFF_LEAVE_Restoration_Buff(self, buff, arg1, arg2, over)

    local addrhp = GetExProp(buff, "ADD_RHP")
    local addrsp = GetExProp(buff, "ADD_RSP")
    
    self.RHP_BM = self.RHP_BM - addrhp
    self.RSP_BM = self.RSP_BM - addrsp

end


-- Warrior_Once_Critical_Buff
function SCR_BUFF_ENTER_Warrior_Once_Critical_Buff(self, buff, arg1, arg2, over)
    local abil = GetAbility(from, 'Hoplite6');
    local addCri = self.CRTHR * abil.Level * 0.05
    self.CRTHR_BM = self.CRTHR_BM + addCri;
    SetExProp(buff, 'ADD_CRI_ABIL');
end

function SCR_BUFF_LEAVE_Warrior_Once_Critical_Buff(self, buff, arg1, arg2, over)
    local addCri = GetExProp(buff, 'ADD_CRI_ABIL');
    self.CRTHR_BM = self.CRTHR_BM - addCri;
end


-- Concentrate
function SCR_BUFF_ENTER_Concentrate_Buff(self, buff, arg1, arg2, over)
    local sklLv, value = GetBuffArg(buff);
    local statBonus = 0;
    local byAbilRate = 0;
    
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local Concentrate = GetSkill(caster, 'Swordman_Concentrate')
        if nil ~= Concentrate then
            sklLv = Concentrate.Level;
            statBonus = math.floor((caster.STR * 0.1 + caster.DEX * 0.2)*arg1)
        end
        
        local Swordman14_abil = GetAbility(caster, "Swordman14")
        if Swordman14_abil ~= nil and sklLv >= 3 then
            byAbilRate = Swordman14_abil.Level * 0.01;
        end
    else
    	caster = self;
    end
    
    value = 5 + (sklLv - 1) * 1.5 + statBonus;
    value = value + (value * byAbilRate);
    
    value = math.floor(value);
    
    SetExProp(buff, "ConcentrateValue", value);
	SetExProp(buff, "ConcentrateCount", sklLv * 2);
    
    SkillTextEffect(nil, self, caster, 'SHOW_SKILL_BONUS', value, nil, "skill_concentrate");
end

function SCR_BUFF_LEAVE_Concentrate_Buff(self, buff, arg1, arg2, over)
	
end

function SCR_TEST_BUFF_SKILL(self, buff, skillclsID)

  return 0;

end

-- SoulActivation
function SCR_BUFF_ENTER_SoulActivation(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_SoulActivation(self, buff, arg1, arg2, RemainTime, ret, over)

    AddSP(self, arg1);
    return 1;

end

function SCR_BUFF_LEAVE_SoulActivation(self, buff, arg1, arg2, over)

    AddSP(self, arg1);

end

-- CrossGuard_Buff
function SCR_BUFF_ENTER_CrossGuard_Buff(self, buff, arg1, arg2, over)
    local blkadd = self.STR + (50 * arg1)
    local defadd = 0
    
    local skill = GetSkill(self, "Highlander_CrossGuard")
    if skill == nil then
        return
    end
    
    local Highlander15_abil = GetAbility(self, 'Highlander15');
    if Highlander15_abil ~= nil and skill.Level >= 3 then
        defadd = defadd + Highlander15_abil.Level * 5;
    end

    defadd = math.floor(defadd)
    blkadd = math.floor(blkadd)

    self.BLK_BM = self.BLK_BM + blkadd;
    self.DEF_BM = self.DEF_BM + defadd;
    
    SetExProp(buff, "ADD_BLK", blkadd)
    SetExProp(buff, "ADD_DEF", defadd)

end

function SCR_BUFF_LEAVE_CrossGuard_Buff(self, buff, arg1, arg2, over)

    local blkadd = GetExProp(buff, "ADD_BLK")
    local defadd = GetExProp(buff, "ADD_DEF")
    
    self.BLK_BM = self.BLK_BM - blkadd;
    self.DEF_BM = self.DEF_BM - defadd;
    
end

function SCR_BUFF_GIVEDAMAGE_CrossGuard_Buff(self, buff, skillid, damage, target)

    local time = 6000
    local Highlander1_abil = GetAbility(self, "Highlander1")
    if Highlander1_abil ~= nil then
        time = time + Highlander1_abil.Level * 1000
    end
    AddBuff(self, from, 'CrossGuard_Debuff', 1, 0, time, 1);
end

-- CrossGuard_Debuff
function SCR_BUFF_ENTER_CrossGuard_Debuff(self, buff, arg1, arg2, over)

     local caster = GetBuffCaster(buff);
     local crossGuardSkl = GetSkill(caster, 'Highlander_CrossGuard');
     if crossGuardSkl ~= nil then
        SetBuffArgs(buff, crossGuardSkl.Level, 0, 0);
     end
end

function SCR_BUFF_LEAVE_CrossGuard_Debuff(self, buff, arg1, arg2, over)
    
end

-- Guard_Debuff
function SCR_BUFF_ENTER_Guard_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Guard_Debuff(self, buff, arg1, arg2, over)
    
end


--Cloaking
function SCR_BUFF_ENTER_Cloaking_Buff(self, buff, arg1, arg2, over)
    local zone = GetZoneName(self)
    if IsPVPServer(self) == 1 or IsJoinColonyWarMap(self) == 1 or zone == 'pvp_Mine' then
        SetCoolDown(self, "Cloaking", 0);
    end

    local addmspd = 0;
    
    local abil = GetAbility(self, "Scout9")
    if abil ~= nil then
        addmspd = addmspd + abil.Level
    end
    
    self.MSPD_BM = self.MSPD_BM + addmspd
    SetExProp(buff, "ADD_MSPD", addmspd)
end

function SCR_BUFF_LEAVE_Cloaking_Buff(self, buff, arg1, arg2, over)
    local zone = GetZoneName(self)
    local addmspd = GetExProp(buff, "ADD_MSPD")
    self.MSPD_BM = self.MSPD_BM - addmspd

    SetExProp(buffOwner, "ACT_TIME", actTime)
    
    if IsPVPServer(self) == 1 or IsJoinColonyWarMap(self) == 1 or zone == 'pvp_Mine' then
        StartCoolTimeAndSpendSP(self, "Scout_Cloaking");
    end
end

--Cover
function SCR_BUFF_ENTER_Cover_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_Cover_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Scan_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Scan_Buff(self, buff, arg1, arg2, over)



end

--Archer_Beprepared_Buff
function SCR_BUFF_ENTER_Beprepared_Buff(self, buff, arg1, arg2, over)

     local CoolList, cnt = GetClassList("CoolDown");
        for i = 0 , cnt - 1 do
        local cal = GetClassByIndexFromList(CoolList , i)
        AddCoolDown(self, cal.ClassName, arg1 * -5000)
        end

end

function SCR_BUFF_LEAVE_Beprepared_Buff(self, buff, arg1, arg2, over)

end

-- Rest
function SCR_BUFF_ENTER_Rest(self, buff, arg1, arg2, over)

    local levelfix = self.Lv;
    buff.Value = levelfix;

    local MHP = self.MHP;
    local MSP = self.MSP;
    
    SetEmoticon(self, 'I_emo_startuscharge')
    self.RHP_BM = self.RHP_BM + (levelfix * self.MHP * 0.096)/levelfix;
    self.RSP_BM = self.RSP_BM + (levelfix * self.MSP * 0.096)/levelfix;
    
    if "YES" == IsBuffApplied(self, 'StoupBuff') then
        RemoveEffect(self, 'F_pc_statue_buff', 1)
        AttachEffect(self, 'F_pc_statue_buff', 10, 'MID', 0, 0, 0, 1);
    end
end

function SCR_BUFF_UPDATE_Rest(self, buff, arg1, arg2, RemainTime, ret, over)
    local list, cnt = SelectObjectByFaction(self, 120,'Law')
    local i
    local pc_count = 1
    
    if cnt > 0 then
        for i = 1, cnt do
            if list[i].ClassName == 'PC' and IsBuffApplied(list[i], 'Rest') == 'YES' and IsSameActor(self,list[i]) == 'NO' then
                pc_count = pc_count + 1
            end
        end
    end
    if pc_count > 0 then
        local hpup = 0
        local spup = 0

        pc_count = 0.005 + pc_count * 0.005;

        if pc_count > 0.05 then
            pc_count = 0.05;
        end

        hpup = math.floor(self.MHP * pc_count)
        spup = math.floor(self.MSP * pc_count)

        if hpup < 1 then
            hpup = 1
        end

        if spup < 1 then
            spup = 1
        end

        AddHP(self, hpup)
        AddSP(self, spup)
    end

    return 1;

end

function SCR_BUFF_LEAVE_Rest(self, buff, arg1, arg2, over)

    local levelfix = buff.Value;

    local MHP = self.MHP;
    local MSP = self.MSP;
    
    SetEmoticon(self, 'None')
    self.RHP_BM = self.RHP_BM - (levelfix * self.MHP * 0.096)/levelfix;
    self.RSP_BM = self.RSP_BM - (levelfix * self.MSP * 0.096)/levelfix;

    if "YES" == IsBuffApplied(self, 'StoupBuff') then
        RemoveEffect(self, 'F_pc_statue_buff', 1)
        AttachEffect(self, 'F_pc_statue_buff', 10, 'TOP', 0, 0, 0, 1);
    end
end

-- Rest
function SCR_BUFF_ENTER_SitRest(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_SitRest(self, buff, arg1, arg2, over)

end

-- Sleep_Debuff
function SCR_BUFF_ENTER_Sleep_Debuff(self, buff, arg1, arg2, over)
	SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local lv = arg1;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
            
            if IsPVPServer(self) == 1 or IsJoinColonyWarMap(self) == 1 then
                if lv > 5 then
                    lv = 5
                end
            end
            
            local abilWizard25 = GetAbility(caster, "Wizard25")
            if abilWizard25 ~= nil then
            	lv = lv * 0.2
            end
            
            if lv <= 0 then
            	lv = 1
            end
        end
    end
    
    SetExProp(self, "TAKEDMG_COUNT", lv)
end

function SCR_BUFF_LEAVE_Sleep_Debuff(self, buff, arg1, arg2, over)

  --  HideEmoticon(self, 'I_emo_sleep')

    DelExProp(self, "TAKEDMG_COUNT")

end

-- FortitudeEndure
function SCR_BUFF_ENTER_FortitudeEndure(self, buff, arg1, arg2, over)

    self.DMG_MTPL_BM = self.DMG_MTPL_BM - 20;

end

function SCR_BUFF_LEAVE_FortitudeEndure(self, buff, arg1, arg2, over)

    self.DMG_MTPL_BM = self.DMG_MTPL_BM + 20;

end

-- TeacherEncouragment
function SCR_BUFF_ENTER_TeacherEncouragment(self, buff, arg1, arg2, over)

    self.REST_BM = self.REST_BM + 2000;

end

function SCR_BUFF_LEAVE_TeacherEncouragment(self, buff, arg1, arg2, over)

    self.REST_BM = self.REST_BM - 2000;

end
--ends

-- Determination
function SCR_BUFF_ENTER_SoPowerful(self, buff, arg1, arg2, over)

    self.PATK_BM = self.PATK_BM + 9999999;
    self.MATK_BM = self.MATK_BM + 9999999;
    self.HR_BM = self.HR_BM + 9999999;

end


function SCR_BUFF_LEAVE_SoPowerful(self, buff, arg1, arg2, over)

    self.PATK_BM = self.PATK_BM - 9999999;
    self.MATK_BM = self.MATK_BM - 9999999;
    self.HR_BM = self.HR_BM - 9999999;

end

--GungHo
function SCR_BUFF_ENTER_GungHo(self, buff, arg1, arg2, over)
    local abilDefAdd = 1;
    local abilAtkAdd = 1;
    local skill = GetSkill(self, "Swordman_GungHo")
    if skill == nil then
        return
    end
    
    local Swordman13_abil = GetAbility(self, "Swordman13")
    if Swordman13_abil ~= nil and skill.Level >= 3 then
        abilDefAdd = 1 + Swordman13_abil.Level * 0.01;
        abilAtkAdd = 1 + Swordman13_abil.Level * 0.01;
    end
    
--    local defadd = (2.5 + (1 * arg1)) * abilDefAdd
--    local defrate = (0.005 * arg1) * abilDefAdd
--    local atkadd = (8.2 + (2 * arg1)) * abilAtkAdd
--    local atkrate = (0.01 * arg1) * abilAtkAdd
    
    local stat = TryGetProp(self, "STR")
    local atkAdd = 10 + ((arg1 - 1) * 2) + ((arg1 / 5) * ((stat * 0.5) ^ 0.8))
    local defAdd = 5 + (arg1 - 1) + ((arg1 / 5) * ((stat * 0.3) ^ 0.5))

    atkAdd = atkAdd * abilAtkAdd
    defAdd = defAdd * abilDefAdd
    
    if defAdd > self.DEF then
        defAdd = self.DEF;
    end

    defAdd = math.floor(defAdd)
    atkAdd = math.floor(atkAdd)

    self.DEF_BM = self.DEF_BM - defAdd;
    self.PATK_BM = self.PATK_BM + atkAdd;
    SetExProp(buff, "ADD_DEF", defAdd);
    SetExProp(buff, "ADD_ATK", atkAdd);
end

function SCR_BUFF_UPDATE_GungHo(self, buff, arg1, arg2, RemainTime, ret, over)

--    PATK_RATE_BM = PATK_RATE_BM + 0.3;

end

function SCR_BUFF_LEAVE_GungHo(self, buff, arg1, arg2, over)
    local defAdd = GetExProp(buff, "ADD_DEF");
    local atkAdd = GetExProp(buff, "ADD_ATK");

    self.DEF_BM = self.DEF_BM + defAdd;
    self.PATK_BM = self.PATK_BM - atkAdd;
end


-- Guardian_Buff
function SCR_BUFF_ENTER_Guardian_Buff(self, buff, arg1, arg2, over)
    local defRate = 1
    local drAdd = 0
    
    local Peltasta23_abil = GetAbility(self, "Peltasta23")
    if Peltasta23_abil ~= nil then
        drAdd = 50 * Peltasta23_abil.Level;
    end
	
	local abilPeltasta34 = GetAbility(self, "Peltasta34")
	if abilPeltasta34 ~= nil and abilPeltasta34.ActiveState == 1 then
		defRate = 2
	end
	
    self.DEF_RATE_BM = self.DEF_RATE_BM + defRate
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + defRate
    self.DR_BM = self.DR_BM + drAdd;
	
    SetExProp(buff, "ADD_GUARDIAN_DR", drAdd);
    SetExProp(buff, "ADD_GUARDIAN_DEF", defRate);
end

function SCR_BUFF_LEAVE_Guardian_Buff(self, buff, arg1, arg2, over)
    local drAdd = GetExProp(buff, "ADD_GUARDIAN_DR");
    local defRate = GetExProp(buff, "ADD_GUARDIAN_DEF");
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defRate
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - defRate
    self.DR_BM = self.DR_BM - drAdd;
end


function SCR_BUFF_ENTER_Restrain_Buff(self, buff, arg1, arg2, over)

   local mhpadd = 50+(arg1 * 5) + (self.MHP * 0.01 * arg1) 
    
    if mhpadd > self.MHP * 0.9 then
        mhpadd = self.MHP * 0.9;
    end
    
    mhpadd = math.floor(mhpadd);
    
    self.MHP_BM = self.MHP_BM - mhpadd;
        
    SetExProp(buff, "ADD_MHP", mhpadd);
    
    InvalidateStates(self); 
end

function SCR_BUFF_LEAVE_Restrain_Buff(self, buff, arg1, arg2, over)
    
    local mhpadd = GetExProp(buff, "ADD_MHP");

    self.MHP_BM = self.MHP_BM + mhpadd;
      
    SetExProp(self, "REGEN_HP", mhpadd);
    
    InvalidateStates(self);
end

function SCR_BUFF_ENTER_Restrain_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Restrain_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    local abil = GetAbility(caster, "Swordman4")
    
    if abil ~= nil then
        AddBuff(caster, self, 'Slow_Debuff', 1, 0, abil.Level * 3000, 1);
    end
end

-- SafetyZone
function SCR_BUFF_ENTER_SafetyZone_Buff(self, buff, arg1, arg2, over)

    local addDefenced_BM  = 1;
    SetExProp(buff, 'DEFENCED_BM', addDefenced_BM);
    self.MaxDefenced_BM = self.MaxDefenced_BM + addDefenced_BM;
    

end

function SCR_BUFF_LEAVE_SafetyZone_Buff(self, buff, arg1, arg2, over)

    local addDefenced_BM = GetExProp(buff, 'DEFENCED_BM');
    self.MaxDefenced_BM = self.MaxDefenced_BM - addDefenced_BM;

end

-- Oil
function SCR_BUFF_ENTER_Archer_Oil_Debuff(self, buff, arg1, arg2, over)

    local lv = arg1;

    local mspdadd = self.MSPD * (0.2 + lv * 0.1);
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);

end


function SCR_BUFF_LEAVE_Archer_Oil_Debuff(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;


end


function SCR_BUFF_ENTER_SwiftStep_Buff(self, buff, arg1, arg2, over)
    local mspdadd = 0.05 + (arg1 - 1) * 0.01
--    local defadd = 10 - arg1
    local dradd = 10 * arg1
--    if defadd <= 0 then
--        defadd = 1;
--    end
--    if defadd > self.DEF then
--        defadd = self.DEF;
--    end
    
    self.MovingShot_BM = self.MovingShot_BM + mspdadd;
--    self.DEF_BM = self.DEF_BM - defadd;
    self.DR_BM = self.DR_BM + dradd
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
--    SetExProp(buff, "ADD_DEF", defadd);
    SetExProp(buff, "ADD_DR", dradd);

    local caster = GetBuffCaster(buff)
    if caster ~= nil then
        local abil = GetAbility(caster, "Archer8")
        if abil ~= nil and abil.ActiveState == 1 then
            local crthrAbil = abil.Level * 20
            local skill = GetSkill(caster, 'Archer_SwiftStep')
            local crthrSkill = skill.Level * 5
            
            self.CRTHR_BM = self.CRTHR_BM + (crthrAbil + crthrSkill)
            
            SetExProp(buff, "ADD_CRTHR_ABIL", crthrAbil);
            SetExProp(buff, "ADD_CRTHR_SKILL", crthrSkill);
        end
    end
end

function SCR_BUFF_LEAVE_SwiftStep_Buff(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");
--    local defadd = GetExProp(buff, "ADD_DEF")
    local dradd = GetExProp(buff, "ADD_DR")

    self.MovingShot_BM = self.MovingShot_BM - mspdadd;
--    self.DEF_BM = self.DEF_BM + defadd;
    self.DR_BM = self.DR_BM - dradd;
    
    local crthrAbil = GetExProp(buff, "ADD_CRTHR_ABIL");
    local crthrSkill = GetExProp(buff, "ADD_CRTHR_SKILL");

    self.CRTHR_BM = self.CRTHR_BM - (crthrAbil + crthrSkill)
end

-- RunningShot_Buff
function SCR_BUFF_ENTER_RunningShot_Buff(self, buff, arg1, arg2, over)
  local spdadd = 100
    self.MovingShot_BM = self.MovingShot_BM + 1.3
    SET_NORMAL_ATK_SPEED(self, -spdadd);
    SetExProp(buff, "ADD_ATKSPD", spdadd);
end

function SCR_BUFF_LEAVE_RunningShot_Buff(self, buff, arg1, arg2, over)

    local spdadd = GetExProp(buff, "ADD_ATKSPD");
    self.MovingShot_BM = self.MovingShot_BM - 1.3;
    SET_NORMAL_ATK_SPEED(self, spdadd);
    
end

-- Limacon_Buff
function SCR_BUFF_ENTER_Limacon_Buff(self, buff, arg1, arg2, over)
    local level = 1;
    local skl = GetSkill(self, 'Schwarzereiter_Limacon');
    if skl ~= nil then
        level = skl.Level;
    end

    AddInstSkill(self, 'Pistol_Attack2', level);
end


function SCR_BUFF_UPDATE_Limacon_Buff(self, buff, arg1, arg2, RemainTime, ret, over)

    local ridingCompanion = GetRidingCompanion(self);
    if ridingCompanion == nil then
        RemoveBuff(self, 'Limacon_Buff');
    end
    return 1;
end

function SCR_BUFF_LEAVE_Limacon_Buff(self, buff, arg1, arg2, over)

end




function SCR_BUFF_ENTER_Bloodletting_Buff(self, buff, arg1, arg2, over)
    local abil = GetAbility(GetBuffCaster(buff), "PlagueDoctor3")
    if abil ~= nil then
        SetBuffUpdateTime(buff, 300 + abil.Level * 30)
    end
end

function SCR_BUFF_UPDATE_Bloodletting_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    local value = (6 - arg1)
    if value <= 0 then
        value = 1
    end
    
--    local abil = GetAbility(GetBuffCaster(buff), "PlagueDoctor4")
    local caster = GetBuffCaster(buff)
    if caster ~= nil then
        local abil = GetAbility(caster, "PlagueDoctor4")
        if abil ~= nil and IMCRandom(1,9999) < abil.Level * 10000 then
            AddSP(self, -value)
        else
            AddHP(self, -value)
        end
        
        if self.HP < 1 then
            Dead(self)
        end
    else
        return
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_Bloodletting_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Incineration_Debuff(self, buff, arg1, arg2, over)
	local caster = GetBuffCaster(buff);
	if caster ~= nil then
		local abilPlagueDoctor15 = GetAbility(caster, 'PlagueDoctor15');
		if abilPlagueDoctor15 ~= nil and abilPlagueDoctor15.ActiveState == 1 then
			SetBuffUpdateTime(buff, 300);
		end
	end
end

function SCR_BUFF_UPDATE_Incineration_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local lv = arg1;
    local caster = GetBuffCaster(buff);
    local damage = GET_SKL_DAMAGE(caster, self, 'PlagueDoctor_Incineration');
    local skill = GET_MON_SKILL(caster, 'PlagueDoctor_Incineration');
    
    local divineAtkAdd = skill.SkillAtkAdd;
    local addValue = arg2;
    
    divineAtkAdd = addValue - divineAtkAdd;
    if divineAtkAdd < 0 then
        divineAtkAdd = 0;
    end
    
    TakeDamage(caster, self, skill.ClassName, damage + divineAtkAdd, "Fire", "Magic", "Magic", HIT_FIRE, HITRESULT_BLOW, 0, 0);
    
    return 1;
end

function SCR_BUFF_LEAVE_Incineration_Debuff(self, buff, arg1, arg2, over)

end





function SCR_BUFF_ENTER_Lachrymator_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    if self.ClassName ~= 'PC' then
        CancelMonsterSkill(self);
        StopMove(self);
        SetTendencysearchRange(self, 30);   
    end
end

function SCR_BUFF_UPDATE_Lachrymator_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff)
    if nil == caster then
        return;
    end
    
    local skill = GetSkill(caster, "Rogue_Lachrymator")
    if skill == nil then
        return
    end
    
    local Rogue13_abil = GetAbility(caster, "Rogue13")
    if Rogue13_abil ~= nil and skill.Level >= 3 then
        TakeDamage(caster, self, "None", Rogue13_abil.Level, "Melee", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_Lachrymator_Debuff(self, buff, arg1, arg2, over)
    if self.ClassName ~= 'PC' then
        SetTendencysearchRange(self, 0)
    end
end


function SCR_BUFF_ENTER_Evasion_Buff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    local evasionSkl = GetSkill(caster, 'Rogue_Evasion');
    if evasionSkl ~= nil then
        SetBuffArgs(buff, evasionSkl.Level, 0, 0);
    end
end


function SCR_BUFF_LEAVE_Evasion_Buff(self, buff, arg1, arg2, over)

end

-- Lethargy_Debuff
function SCR_BUFF_ENTER_Lethargy_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local lv = arg1;
    local patkAdd = 0
    local matkAdd = 0
    local drAdd = 0
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
        
		patkAdd = lv * 0.01
		matkAdd = lv * 0.01
		drAdd = lv * 5
		
        local skill = GetSkill(caster, "Wizard_Lethargy")
        if skill == nil then
            return
        end
        
        local Wizard7_abil = GetAbility(caster, 'Wizard7')
        if Wizard7_abil ~= nil then
            SetBuffArgs(buff, Wizard7_abil.Level, 0, 0);
        end
    end
    
    if drAdd > self.DR then
        drAdd = self.DR;
    end
    
    self.PATK_RATE_BM = self.PATK_RATE_BM - patkAdd;
    self.MATK_RATE_BM = self.MATK_RATE_BM - matkAdd;
    self.DR_BM = self.DR_BM - drAdd;
    
    SetExProp(buff, "ADD_PATK", patkAdd);
    SetExProp(buff, "ADD_MATK", matkAdd);
    SetExProp(buff, "ADD_DR", drAdd);
end

function SCR_BUFF_LEAVE_Lethargy_Debuff(self, buff, arg1, arg2, over)
    local patkAdd = GetExProp(buff, "ADD_PATK");
    local matkAdd = GetExProp(buff, "ADD_MATK");
    local drAdd = GetExProp(buff, "ADD_DR");
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + patkAdd;
    self.MATK_RATE_BM = self.MATK_RATE_BM + matkAdd;
    self.DR_BM = self.DR_BM + drAdd;
end



-- Slow_Debuff
function SCR_BUFF_ENTER_Slow_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local lv = arg1;

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
        
        local Chronomancer2_abil = GetAbility(caster, 'Chronomancer2');
        if Chronomancer2_abil ~= nil then
            local decreaseCRT = math.floor(caster.INT * 0.15);
            self.CRTDR_BM = self.CRTDR_BM - decreaseCRT;
            SetExProp(buff, 'DECREASE_CRT_ABIL', decreaseCRT);
        end
    end
    
    local mspdadd = math.floor(8 + arg1 * 1.5);
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    SetExProp(buff, "ADD_MSPD", mspdadd);
end


function SCR_BUFF_LEAVE_Slow_Debuff(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    
    local decreaseCRT = GetExProp(buff, 'DECREASE_CRT_ABIL');
    self.CRTDR_BM = self.CRTDR_BM + decreaseCRT;
    
end




-- Surespell_Buff
function SCR_BUFF_ENTER_Surespell_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Surespell_Buff(self, buff, arg1, arg2, over)
    
end


-- QuickCast_Buff
function SCR_BUFF_ENTER_QuickCast_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_QuickCast_Buff(self, buff, arg1, arg2, over)
    
end

-- QuickCast_After_Buff
function SCR_BUFF_ENTER_QuickCast_After_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_QuickCast_After_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Cleric_Zombie_Debuff(self, buff, arg1, arg2, over)


end

function SCR_BUFF_UPDATE_Cleric_Zombie_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local mhp = self.MHP;
    local remainHP = GetExProp(buff, "REMAIN_HP");
    local hp = mhp * 0.005 + remainHP;
    remainHP = hp - math.floor(hp);
    SetExProp(buff, "REMAIN_HP", remainHP);

    if hp >= 1 then
        AddHP(self, -hp);
    end

    if self.HP <= 0 then
        Dead(self)
    end

  return 1;
  
end

function SCR_BUFF_LEAVE_Cleric_Zombie_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        if 1 ~= IsZombie(caster) then
            ZombieDelete(caster, self);
        end
    end
end



function SCR_BUFF_ENTER_JincanGu_Mon_Debuff(self, buff, arg1, arg2, over)
self.MaxDefenced_BM = self.MaxDefenced_BM + 1

end


function SCR_BUFF_UPDATE_JincanGu_Mon_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    AddHP(self, -self.MHP / 20)
    if self.HP <= 0 then
        Dead(self)
    end

  return 1;
  
end

function SCR_BUFF_LEAVE_JincanGu_Mon_Debuff(self, buff, arg1, arg2, over)
    Dead(self)
    PlayEffect(self, "F_blood006_green", 0.7, 0, 0)
    self.MaxDefenced_BM = self.MaxDefenced_BM -1
end


function SCR_BUFF_ENTER_Feint_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local abil = GetAbility(caster, 'Rogue10');
        if abil ~= nil and abil.Level * 1500 > IMCRandom(1, 9999) and self.MonRank ~= 'Boss' then
            RunScript('SCR_FEINT_ABIL', self, caster)
        end

        local feintSkl = GetSkill(caster, 'Rogue_Feint');
        if feintSkl ~= nil then
            SetBuffArgs(buff, feintSkl.Level, 0, 0);
        end
    end
end

function SCR_FEINT_ABIL(self, caster)
	if TryGetProp(self, "MonRank") ~= "Boss" then
	    local casterx, casterz = GetDir(caster)
	    local casterDir = DirToAngle(casterx, casterz)
	    
	    sleep(300);
	
	    if IS_PC(self) == false then
	        HoldMonScp(self)
	    end
	    
	    SetDirectionByAngle(self, casterDir)
	    
	    if IS_PC(self) == false then
	        sleep(1500);
	        UnHoldMonScp(self)
	    end
	end
end


function SCR_BUFF_LEAVE_Feint_Debuff(self, buff, arg1, arg2, over)

end



-- Damballa_Debuff
function SCR_BUFF_ENTER_Damballa_Debuff(self, buff, arg1, arg2, over)
    ActorVibrate(self, 7, 1, 25, 0.1);
end

function SCR_BUFF_LEAVE_Damballa_Debuff(self, buff, arg1, arg2, over)
    SetExProp_Pos(self, "ZOMBIE_VEC3", GetPos(self))
    local caster = GetBuffCaster(buff);
    --TakeDamage(caster, self, "None", self.MHP, "None", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
    Dead(self)
    ActorVibrate(self, 0, 0, 0, 0);
    local objList, objCount = SelectObjectNear(caster, self, 50, "ENEMY");
    PlayEffect(self, 'F_explosion093_dark', 0.7);
    
    local damage = GET_SKL_DAMAGE(caster, self, 'Bokor_Damballa');
    local skill = GET_MON_SKILL(caster, 'Bokor_Damballa');  
    
    local divineAtkAdd = skill.SkillAtkAdd
    local addValue = 0
    
    local pad = GetPadByBuff(caster, buff);
    if pad ~= nil then
        addValue = GetPadArgNumber(pad, 1);
    end
    
    divineAtkAdd = addValue - divineAtkAdd
    
    if divineAtkAdd < 0 then
        divineAtkAdd = 0;
    end
    
    if objCount > skill.SkillSR then
        objCount = skill.SkillSR
    end
    
    if objCount ~= nil or objList ~= nil then
        for i = 1, objCount do
            local obj = objList[i];
            TakeDamage(caster, obj, skill.ClassName, damage + divineAtkAdd, "Dark", "Magic", "Magic", HIT_DARK, HITRESULT_BLOW, 0, 0);
            
            local abil = GetAbility(caster, "Bokor6")
            if abil == nil then
            SKL_TOOL_KD(self, obj, 4, 0, 150, 50, 0, 3, 5);
            end
        end
    end

    if IsDead(self) == 1 then
        local index = IMCRandom(1, 100);
        local summonRate = 50;
        
        local bokor4_abil = GetAbility(caster, 'Bokor4');
        if bokor4_abil ~= nil then
            summonRate = summonRate + bokor4_abil.Level * 2;
        end
        
        if index < summonRate then
            RunScript('SCR_SUMMON_ZOMBIE', self, caster)
            if IMCRandom(1,100) < 50 then
              RunScript('SCR_SUMMON_ZOMBIE', self, caster)
            end
        end
    end
end




function SCR_BUFF_ENTER_Zombify_Debuff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_LEAVE_Zombify_Debuff(self, buff, arg1, arg2, over)
    
    local lv = arg1;

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
    end
    
    SetExProp(self, "SkillLv", lv)

    if IsDead(self) == 1 then
        if GetExProp(self,"ZOMBIE_POS_FLAG") ~= 1 then
            local x, y, z = GetPos(self)
            SetExProp_Pos(self, "ZOMBIE_VEC3", x, y, z)
            SetExProp(self,"ZOMBIE_POS_FLAG", 1)
        end

        if GetExProp(self,"FLAG") ~= 1 then
            local caster = GetBuffCaster(buff); 
            RunScript('SCR_SUMMON_ZOMBIE', self, caster)

            if IS_PC(self) == false then
                SetExProp(self,"FLAG", 1)
            end
        end
    end
end



function SCR_BUFF_ENTER_Archer_EntangleSlow_Debuff(self, buff, arg1, arg2, over)


    local mspdadd = self.MSPD * 0.2
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);

end


function SCR_BUFF_LEAVE_Archer_EntangleSlow_Debuff(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;


end


-- Caltrop_Debuff
function SCR_BUFF_ENTER_ScatterCaltrop_Debuff(self, buff, arg1, arg2, over)

   -- local lv = 1;
    
   -- local caster = GetBuffCaster(buff);
   -- if caster ~= nil then
       -- local caltropSkill = GetSkill(caster, "QuarrelShooter_ScatterCaltrop")
      --  lv = caltropSkill.Level
  --  end

    local mspdadd = 10

    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);

end


function SCR_BUFF_LEAVE_ScatterCaltrop_Debuff(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;


end


-- Aukuras_Buff
function SCR_BUFF_ENTER_Aukuras_Buff(self, buff, arg1, arg2, over)
    local lv = arg1;
    local addHP = 39 + (19 * (lv - 1));
    local addResfire = 0;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local skill = GetSkill(caster, "Kriwi_Aukuras");
        if skill ~= nil then
            lv = skill.Level;
            addHP = 39 + (19 * (lv - 1));
            
            local abilKriwi14 = GetAbility(caster, 'Kriwi14');
            if abilKriwi14 ~= nil and lv >= 3 then
                addHP = addHP * (1 + abilKriwi14.Level * 0.01);
            end
            
            local abilKriwi6 = GetAbility(caster, "Kriwi6");
            if abilKriwi6 ~= nil then
                addResfire = abilKriwi6.Level * 14;
            end
        end
    end
    
    addHP = math.floor(addHP);
    addResfire = math.floor(addResfire);
    
    SetExProp(buff, "ADD_HP_VALUE", addHP);
    
    if IS_PC(self) == false then
        self.Fire_Def_BM = self.Fire_Def_BM + addResfire;
    else
        self.ResFire_BM = self.ResFire_BM + addResfire;
    end
    
    SetExProp(buff, "ADD_RES_FIRE", addResfire);
end

function SCR_BUFF_UPDATE_Aukuras_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local abilKriwi18 = GetAbility(caster, "Kriwi18");
        if abilKriwi18 ~= nil and abilKriwi18.ActiveState == 1 then
            return 1;
        end
    end

    local addHP = GetExProp(buff, "ADD_HP_VALUE");
    if addHP ~= nil and addHP ~= 0 then
        Heal(self, addHP, 0, ret, 'Kriwi_Aukuras');
    end

    return 1;
end

function SCR_BUFF_LEAVE_Aukuras_Buff(self, buff, arg1, arg2, over)
    local addResfire = GetExProp(buff, "ADD_RES_FIRE");

    if IS_PC(self) == false then
        self.Fire_Def_BM = self.Fire_Def_BM - addResfire;
    else
        self.ResFire_BM = self.ResFire_BM - addResfire;
    end
end


function SCR_BUFF_ENTER_Aukuras_Debuff(self, buff, arg1, arg2, over)
    local hraddrate = 10
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
        
        hraddrate = hraddrate + (lv - 1) * 1
    end
    
    if self.HR < hraddrate then
        hraddrate = self.HR - 1;
    end
    
    self.HR_BM = self.HR_BM - hraddrate;
    
    SetExProp(buff, "ADD_HR", hraddrate);
end


function SCR_BUFF_LEAVE_Aukuras_Debuff(self, buff, arg1, arg2, over)
    local hraddrate = GetExProp(buff, "ADD_HR");
    
    self.HR_BM = self.HR_BM + hraddrate;
end

function SCR_BUFF_ENTER_Aukuras_Buff_ReduceTime(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_Aukuras_Buff_ReduceTime(self, buff, arg1, arg2, RemainTime, ret, over)

    local list, cnt = GetBuffList(self);
    for i=1, cnt do
        local debuff = list[i]
        if debuff.Group1 == "Debuff" then
            local remainTime = GetBuffRemainTime(debuff);
            
            if remainTime > 0 then
                remainTime = remainTime - 50
                SetBuffRemainTime(self, debuff.ClassName, remainTime, 0);
            end
            
            if debuff.ClassName == "Hexing_Debuff" then
                SCR_ADD_CASTER_BUFF_REMAINTIME(self, "Hexing_Debuff", "Hexing_Buff", remainTime);
            end
        end
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_Aukuras_Buff_ReduceTime(self, buff, arg1, arg2, over)

end



-- Aukuras_Kriwi18_Buff
function SCR_BUFF_ENTER_Aukuras_Kriwi18_Buff(self, buff, arg1, arg2, over)
    local addFireDamage = 0;
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local lv = arg1;
        local skill = GetSkill(caster, 'Kriwi_Aukuras');
        local skillLevel = TryGetProp(skill, 'Level');
        if skillLevel ~= nil then
            lv = skillLevel;
        end
        
        local casterINT = TryGetProp(caster, 'INT');
        if casterINT == nil then
            casterINT = 1;
        end
        
        local casterMNA = TryGetProp(caster, 'MNA');
        if casterMNA == nil then
            casterMNA = 1;
        end
        
        addFireDamage = 215 + (((casterINT + casterMNA) ^ 0.9) * (1 + lv / 15)) + (lv * 43);
    end
    
    addFireDamage = math.floor(addFireDamage);
    
    SetBuffArgs(buff, addFireDamage, 0, 0);
end


function SCR_BUFF_LEAVE_Aukuras_Kriwi18_Buff(self, buff, arg1, arg2, over)
    
end


-- Impact
function SCR_BUFF_ENTER_Impact(self, buff, arg1, arg2, over)

    if GetPropType(self, "Runnable") ~= nil then
        if self.Runnable == 1 then
            self.Runnable = self.Runnable - 1;
        end
    end

    local mspdadd = self.MSPD * 0.5
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);

end


function SCR_BUFF_LEAVE_Impact(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;
    
    if GetPropType(self, "Runnable") ~= nil then
        if self.Runnable == 0 then
            self.Runnable = self.Runnable + 1;
        end
    end
    


end


-- honey_slow
function SCR_BUFF_ENTER_honey_slow(self, buff, arg1, arg2, over)
    
    --ShowEmoticon(self, 'I_emo_slowdown', 0)
    
    if GetPropType(self, "Runnable") ~= nil then
        self.Runnable = self.Runnable - 1;
    end

    local lv = arg1;

    local mspdadd = self.MSPD * 0.6
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);

end


function SCR_BUFF_LEAVE_honey_slow(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_slowdown')

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;
    
    if GetPropType(self, "Runnable") ~= nil then
        self.Runnable = self.Runnable + 1;
    end


end



--ElectricShock
function SCR_BUFF_ENTER_ElectricShock(self, buff, arg1, arg2, over)
    
    if IS_PC(self) == true then
        self.Jumpable = self.Jumpable - 1;
    end

    local lv = arg1;

    local mspdadd = self.MSPD * 0.5
    local defadd = self.DEF * 0.3
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    self.DEF_BM = self.DEF_BM - defadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
    SetExProp(buff, "ADD_DEF", defadd);
    

    
end


function SCR_BUFF_LEAVE_ElectricShock(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");
  local defadd = GetExProp(buff, "ADD_DEF");
  
  
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    self.DEF_BM = self.DEF_BM + defadd;
    
    if IS_PC(self) == true then
        self.Jumpable = self.Jumpable + 1;
    end


end

-- SPAndStaUP
function SCR_BUFF_ENTER_SPAndStaUP(self, buff, arg1, arg2, over)

    self.RSP_BM = self.RSP_BM + 2;
    self.RSPTIME_BM = self.RSPTIME_BM - 2500;
    self.RSta_BM = self.RSta_BM + 1000;
    ResetRSPTime(self);

end

function SCR_BUFF_LEAVE_SPAndStaUP(self, buff, arg1, arg2, over)

    self.RSP_BM = self.RSP_BM - 2;
    self.RSPTIME_BM = self.RSPTIME_BM + 2500;
    self.RSta_BM = self.RSta_BM - 1000;

end

-- Rage
function SCR_BUFF_ENTER_Rage(self, buff, arg1, arg2, over)

    local lv = arg1;

    local intsubtract = self.INT * (0.5 + lv * 0.25);
    local defsubtract = self.DEF * (0.5 + lv * 0.25);
    --local rrsubtract =  self.RR * (0.5 + lv * 0.25);
    local stradd = self.STR * (0.5 + lv * 0.25);
    local atkadd = self.MINMATK * (0.5 + lv * 0.25);
    local mspdadd = self.MSPD * (0.2 + lv * 0.1);
    
    self.INT_BM = self.INT_BM - intsubtract;
    self.DEF_BM = self.DEF_BM - defsubtract;
    --self.RR_BM = self.RR_BM - rrsubtract;
    self.STR_BM = self.STR_BM + stradd;
    self.ATK_BM = self.ATK_BM + atkadd;
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    
    SetExProp(buff, "SUBSTRACT_INT", intsubtract);
    SetExProp(buff, "SUBSTRACT_DEF", defsubtract);
    SetExProp(buff, "SUBSTRACT_RR", rrsubtract);
    SetExProp(buff, "ADD_STR", stradd);
    SetExProp(buff, "ADD_MINMATK", atkadd);
    SetExProp(buff, "ADD_MSPD", mspdadd);

end

function SCR_BUFF_LEAVE_Rage(self, buff, arg1, arg2, over)

    local intsubtract = GetExProp(buff, "SUBSTRACT_INT");
    local defsubtract = GetExProp(buff, "SUBSTRACT_DEF");
    local rrsubtract = GetExProp(buff, "SUBSTRACT_RR");
    local stradd = GetExProp(buff, "ADD_STR");
    local atkadd = GetExProp(buff, "ADD_MINMATK");
    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.INT_BM = self.INT_BM + intsubtract;
    self.DEF_BM = self.DEF_BM + defsubtract;
    --self.RR_BM = self.RR_BM + rrsubtract;
    self.STR_BM = self.STR_BM - stradd;
    self.ATK_BM = self.ATK_BM - atkadd;
    self.MSPD_BM = self.MSPD_BM - mspdadd;

end

-- Rage_stout
function SCR_BUFF_ENTER_Rage_stout(self, buff, arg1, arg2, over)

    local atkadd = 0.5
    
    self.MATK_RATE_BM = self.MATK_RATE_BM + atkadd;

    SetExProp(buff, "ADD_MINMATK", atkadd);

end

function SCR_BUFF_LEAVE_Rage_stout(self, buff, arg1, arg2, over)

    local atkadd = GetExProp(buff, "ADD_MINMATK");

    self.MATK_RATE_BM = self.MATK_RATE_BM - atkadd;

end

--AfterEffect
function SCR_BUFF_ENTER_AfterEffect(self, buff, arg1, arg2, over)
--  self.Runnable = self.Runnable - 1;
--  self.Jumpable = self.Jumpable - 1;

    local lv = arg1;
    local atkadd = 0.5
    local defadd = 0.5
    local matkadd = 0.5
    
    self.ATK_BM = self.ATK_BM - atkadd;
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM - matkadd;
    
    SetExProp(buff, "ADD_MINMATK", matkadd);
    SetExProp(buff, "ADD_ATK", atkadd);
    SetExProp(buff, "ADD_DEF", defadd);
    SetExProp(buff, "ADD_RR", rradd);
end

function SCR_BUFF_LEAVE_AfterEffect(self, buff, arg1, arg2, over)
    local atkadd = GetExProp(buff, "ADD_ATK");
    local defadd = GetExProp(buff, "ADD_DEF");
    local matkadd = GetExProp(buff, "ADD_MINMATK");
    local rradd = GetExProp(buff, "ADD_RR");
    
    self.ATK_BM = self.ATK_BM + atkadd;
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM + matkadd;
    --self.RR_BM = self.RR_BM + rradd;
    
--  self.Runnable = self.Runnable + 1;
--  self.Jumpable = self.Jumpable + 1;
end

-- Hexing_Buff
function SCR_BUFF_ENTER_Hexing_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Hexing_Buff(self, buff, arg1, arg2, over)



end

-- Hexing_Debuff
function SCR_BUFF_ENTER_Hexing_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local caster = GetBuffCaster(buff);
    local mdefadd = 0;
    local skill = GetSkill(caster, "Featherfoot_Kurdaitcha")
    if skill ~= nil and skill.ClassName == "Featherfoot_Kurdaitcha" then
        mdefadd = 0.04 + (arg1 * 0.005)
    else
        mdefadd = 0.03 + (arg1 * 0.005)
    end
    
    if caster ~= nil then
        local Bokor9_abil = GetAbility(caster, "Bokor9")
        if Bokor9_abil ~= nil then
            SetBuffArgs(buff, Bokor9_abil.Level, 0, 0);
        end
    end
    
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - mdefadd;
    
    SetExProp(buff, "ADD_MDEF", mdefadd);
end

function SCR_BUFF_LEAVE_Hexing_Debuff(self, buff, arg1, arg2, over)
    local mdefadd = GetExProp(buff, "ADD_MDEF");
    
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + mdefadd;
end

-- Effigy_Debuff
function SCR_BUFF_ENTER_Effigy_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Effigy_Debuff(self, buff, arg1, arg2, over)
    
end

-- SwellLeftArm_Buff
function SCR_BUFF_ENTER_SwellLeftArm_Buff(self, buff, arg1, arg2, over)
    local addValue = 0
    local patkadd = 0
    local matkadd = 0
    local item = GetEquipItem(self, 'RH');
    if item.ClassName ~= "NoWeapon" then
        local lv = arg1
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
            if pad ~= nil then
                lv = GetPadArgNumber(pad, 1);
            end
            
            local defaultAdd = 70
            
            local INT = TryGetProp(caster,"INT")
            local MNA = TryGetProp(caster,"MNA")
            
            addValue =  defaultAdd + ((lv - 1) * 12) + (lv / 5) * ((INT + MNA) * 0.6) ^ 0.9
            
            local SwellLeftArmSkill = GetSkill(caster, "Thaumaturge_SwellLeftArm")
            local SwellBodySkill = GetSkill(caster, "Thaumaturge_SwellBody")
            local ShrinkBodySkill = GetSkill(caster, "Thaumaturge_ShrinkBody")
            
            local Thaumaturge11_abil = GetAbility(caster, "Thaumaturge11")  -- 1rank Skill Damage add
            if Thaumaturge11_abil ~= nil and SwellLeftArmSkill.Level >= 3 then
                addValue = addValue * (1 + Thaumaturge11_abil.Level * 0.01)
            end
            
            local Thaumaturge6_abil = GetAbility(caster, "Thaumaturge6");
            local Thaumaturge7_abil = GetAbility(caster, "Thaumaturge7");
            local arg3, arg4 = 0, 0;
            if Thaumaturge6_abil ~= nil and ShrinkBodySkill ~= nil and ShrinkBodySkill.Level >= 2 then
                arg3 = Thaumaturge6_abil.Level;
            end
            if Thaumaturge7_abil ~= nil and SwellBodySkill ~= nil and SwellBodySkill.Level >= 2 then
                arg4 = Thaumaturge7_abil.Level;
            end
            SetBuffArgs(buff, arg3, arg4, 0);
        end
        
        patkadd = math.floor(addValue)
        matkadd = math.floor(addValue)
        
        self.PATK_MAIN_BM = self.PATK_MAIN_BM + patkadd;
        self.MATK_BM = self.MATK_BM + matkadd;
    end
    
    SetExProp(buff, "ADD_PATK", patkadd);
    SetExProp(buff, "ADD_MATK", matkadd);
end

function SCR_BUFF_LEAVE_SwellLeftArm_Buff(self, buff, arg1, arg2, over)

    local patkadd = GetExProp(buff, "ADD_PATK");
    local matkadd = GetExProp(buff, "ADD_MATK");
    self.PATK_MAIN_BM = self.PATK_MAIN_BM - patkadd;
    self.MATK_BM = self.MATK_BM - matkadd;

end


-- SwellRightArm_Buff
function UPDATE_USER_ADD_PROPERTY(self, buff, arg1)
    local hradd = 0
    local dradd = 0
    local addtype = 0;
    local abilLevel = 0;
    local addValue = 0
    local defualtAtkAdd = 45
    local defualtDefAdd = 90
    local caster = GetBuffCaster(buff)
    if nil ~= caster then
        local abil = GetAbility(caster, "Thaumaturge8")
        if abil ~= nil then
            abilLevel = abil.Level;
        end
    end
    
    local item = GetEquipItem(self, 'LH');
    if item.ClassName == 'NoWeapon' or (item.AttachType ~= 'Shield' and item.AttachType ~= 'dagger' and item.AttachType ~= 'Pistol' and item.AttachType ~= 'Sword' and item.AttachType ~= 'Cannon') then
        hradd = abilLevel * 30
        dradd = abilLevel * 30
        
        self.HR_BM = self.HR_BM + hradd
        self.DR_BM = self.DR_BM + dradd
        
        Invalidate(self, 'HR');
        Invalidate(self, 'DR');
    else
        local lv = arg1;
        local caster = GetBuffCaster(buff);
        if caster ~= nil then
            local pad = GetPadByBuff(caster, buff);
            if pad ~= nil then
                lv = GetPadArgNumber(pad, 1);
            end
            
            local INT = TryGetProp(caster,"INT")
            local MNA = TryGetProp(caster,"MNA")
            
            if item.AttachType == 'Shield' then
                addValue = defualtDefAdd + (lv - 1) * 20 + (lv / 5) * ((INT + MNA) * 0.7) ^ 0.9
            elseif item.AttachType == 'dagger' or item.AttachType == 'Pistol' or item.AttachType == 'Sword' or item.AttachType == 'Cannon' then
                addValue = defualtAtkAdd + (lv - 1) * 10 + (lv / 5) * ((INT + MNA) * 0.6) ^ 0.9
            end
            
            local skill = GetSkill(caster, "Thaumaturge_SwellRightArm")
            if skill == nil then
                return
            end
            
            local Thaumaturge14_abil = GetAbility(caster, "Thaumaturge14")  -- 1rank Skill Damage add
            if Thaumaturge14_abil ~= nil and skill.Level >= 3 then
                addValue = addValue * (1 + Thaumaturge14_abil.Level * 0.01)
            end
        end
        
        addValue = math.floor(addValue)
        
        if item.AttachType == 'Shield' then
            self.DEF_BM = self.DEF_BM + addValue;
            addtype = 1;
            Invalidate(self, 'DEF');
        elseif item.AttachType == 'dagger' or item.AttachType == 'Pistol' or item.AttachType == 'Sword' or item.AttachType == 'Cannon' then
            self.PATK_SUB_BM  = self.PATK_SUB_BM  + addValue;
            addtype = 2;
            Invalidate(self, 'MAXPATK');
            Invalidate(self, 'MINPATK');
            Invalidate(self, 'MAXMATK');
            Invalidate(self, 'MINMATK');
        end
    end
    
    SetExProp(buff, "ADD_TYPE", addtype);
    SetExProp(buff, "ADD_PHYSICAL", addValue);
    SetExProp(buff, "ADD_MAGICAL", addValue);
    SetExProp(buff, "ADD_PATK", addValue);
    SetExProp(buff, "ADD_MATK", addValue);
    SetExProp(buff, "ADD_HR", hradd);
    SetExProp(buff, "ADD_DR", dradd);
    SetExProp_Str(buff, "ItemGUID", GetItemGuid(item));
end

function UPDATE_USER_MINER_PROPERTY(self, buff)
    local addtype = GetExProp(buff, "ADD_TYPE");
    local addValue = GetExProp(buff, "ADD_PHYSICAL");
--    local addValue = GetExProp(buff, "ADD_MAGICAL");
    local addValue = GetExProp(buff, "ADD_PATK");
    local addValue = GetExProp(buff, "ADD_MATK");
    local hradd = GetExProp(buff, "ADD_HR");
    local dradd = GetExProp(buff, "ADD_DR");

    if addtype == 0 then
        self.HR_BM = self.HR_BM - hradd;
        self.DR_BM = self.DR_BM - dradd;    
        Invalidate(self, 'HR');
        Invalidate(self, 'DR'); 
    elseif addtype == 1 then
        self.DEF_BM = self.DEF_BM - addValue;
--        self.MDEF_BM = self.MDEF_BM - addValue;
        Invalidate(self, 'DEF');
--        Invalidate(self, 'MDEF');
    elseif addtype == 2 then
        self.PATK_SUB_BM  = self.PATK_SUB_BM  - addValue;
        Invalidate(self, 'MAXPATK');
        Invalidate(self, 'MINPATK');
        Invalidate(self, 'MAXMATK');
        Invalidate(self, 'MINMATK');
    end
    
    SetExProp_Str(buff, "ItemGUID", "None");
end

function SCR_BUFF_ENTER_SwellRightArm_Buff(self, buff, arg1, arg2, over)
    local item = GetEquipItem(self, 'LH');
    if nil == item then
        return;
    end
    
    local casterINT = 0;
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        casterINT = caster.INT;
    end
    SetBuffArgs(buff, casterINT, 0, 0);
    
    UPDATE_USER_ADD_PROPERTY(self, buff, arg1);
end

function SCR_BUFF_UPDATE_SwellRightArm_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    local item = GetEquipItem(self, 'LH');
    if nil == item then
--        UPDATE_USER_MINER_PROPERTY(self, buff);
        local caster = GetBuffCaster(buff);
        if caster == nil then
            return 0;
        end
        
        RemainTime = RemainTime - 1000;
        if RemainTime <= 0 then
            return 0;
        end
        
        AddBuff(caster, self, buff.ClassName, arg1, arg2, RemainTime, 1);
        
        return 1;
    end

    local nowGuid = GetItemGuid(item);
    local guid = GetExProp_Str(buff, "ItemGUID");

    if nowGuid ~= guid then
--        UPDATE_USER_MINER_PROPERTY(self, buff);
--        UPDATE_USER_ADD_PROPERTY(self, buff, arg1);
        local caster = GetBuffCaster(buff);
        if caster == nil then
            return 0;
        end
        
        RemainTime = RemainTime - 1000;
        if RemainTime <= 0 then
            return 0;
        end
        
        AddBuff(caster, self, buff.ClassName, arg1, arg2, RemainTime, 1);
        
        return 1;
    end
    return 1;
end

function SCR_BUFF_LEAVE_SwellRightArm_Buff(self, buff, arg1, arg2, over)
    UPDATE_USER_MINER_PROPERTY(self, buff);
end


function SCR_BUFF_ENTER_Mackangdal_Buff(self, buff, arg1, arg2, over)
    SetExProp(self, "isMackangdal_Buff", 1)
    SetExProp(self, "DamageConut", 0);
end

function SCR_BUFF_LEAVE_Mackangdal_Buff(self, buff, arg1, arg2, over)
    damage = GetExProp(self, "DamageConut");
    DelExProp(self, "DamageConut");
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local skill = GetSkill(caster, "Bokor_Mackangdal")
        if skill == nil then
            return
        end
        
        local bokor17_Abil = GetAbility(caster, 'Bokor17');
        if bokor17_Abil ~= nil and skill.Level >= 3 then
            damage = damage - (bokor17_Abil.Level * 2);
        end
        
        if damage <= 0 then
            DelExProp(self, "isMackangdal_Buff")
            return;
        end
    end
    
    DelExProp(self, "isMackangdal_Buff")
    TakeDamage(buff, self, "None", damage, "None", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
end

-- OgouVeve_Buff
function SCR_BUFF_ENTER_OgouVeve_Buff(self, buff, arg1, arg2, over)
    local stradd = 0;
    local sradd = 0;
    local lv = arg1;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
--        stradd = 2 + 1.2 * (lv - 1) + caster.INT * 0.5
        stradd = lv * 5
        sradd = 1 + lv * 0.5
    end
    
    stradd = math.floor(stradd)
    
    self.STR_BM = self.STR_BM + stradd;
    self.SR_BM = self.SR_BM + sradd
    
    SetExProp(buff, "ADD_STR", stradd);
    SetExProp(buff, "ADD_SR", sradd);
end

function SCR_BUFF_LEAVE_OgouVeve_Buff(self, buff, arg1, arg2, over)

    local stradd = GetExProp(buff, "ADD_STR")
    local sradd = GetExProp(buff, "ADD_SR")
    
    self.STR_BM = self.STR_BM - stradd;
    self.SR_BM = self.SR_BM - sradd;
end

-- Ogouveve_Debuff
function SCR_BUFF_ENTER_Ogouveve_Debuff(self, buff, arg1, arg2, over)

    local decreaseStr = arg2 * 2
    self.STR_BM = self.STR_BM - decreaseStr;
    SetExProp(buff, "DECREASE_STR_ABIL", decreaseStr)
end

function SCR_BUFF_LEAVE_Ogouveve_Debuff(self, buff, arg1, arg2, over)

    local decreaseStr = arg2 * 2
    local stradd = GetExProp(buff, "DECREASE_STR_ABIL")
    self.STR_BM = self.STR_BM + decreaseStr;
end


-- Samdiveve_Buff
function SCR_BUFF_ENTER_Samdiveve_Buff(self, buff, arg1, arg2, over)
    local mhpadd = 0;
    local mspdadd = 0;
    local lv = arg1;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
    end
    
    mhpadd = math.floor(298.6 + ((caster.MHP * (0.005 * lv))))
    mspdadd = 3 + lv * 1

    self.MHP_BM = self.MHP_BM + mhpadd;
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    
    SetExProp(buff, "ADD_MHP", mhpadd)
    SetExProp(buff, "ADD_MSPD", mspdadd)
end



function SCR_BUFF_LEAVE_Samdiveve_Buff(self, buff, arg1, arg2, over)

    local mhpadd = GetExProp(buff, "ADD_MHP")
    local mspdadd = GetExProp(buff, "ADD_MSPD")
    
    self.MHP_BM = self.MHP_BM - mhpadd;
    self.MSPD_BM = self.MSPD_BM - mspdadd;
end


-- Samdiveve_Buff
function SCR_BUFF_ENTER_SamdivevePc_Buff(self, buff, arg1, arg2, over)

    local mhpadd = 0;
    local mspdadd = 0;
    local lv = arg1;
    local caster = GetBuffCaster(buff)
    if caster ~= nil then
        mhpadd = math.floor((298.6 + ((caster.MHP * (0.005 * lv)))) / 2)
        mspdadd = (3 + lv * 1) / 2
        
        self.MHP_BM = self.MHP_BM + mhpadd;
        self.MSPD_BM = self.MSPD_BM + mspdadd;
        
        SetExProp(buff, "ADD_MHP", mhpadd)
        SetExProp(buff, "ADD_MSPD", mspdadd)
    end
end



function SCR_BUFF_LEAVE_SamdivevePc_Buff(self, buff, arg1, arg2, over)

    local mhpadd = GetExProp(buff, "ADD_MHP")
    local mspdadd = GetExProp(buff, "ADD_MSPD")
    
    self.MHP_BM = self.MHP_BM - mhpadd;
    self.MSPD_BM = self.MSPD_BM - mspdadd;
end

function SCR_BUFF_ENTER_Barrier_Buff(self, buff, arg1, arg2, over)
    local mdefadd = 0;
    local lv = arg1;
    local mdefrate = (self.MDEF-self.MDEF_BM) * (0.1 * arg1)
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
    end
    
    local defRate = 0
    local abil = GetAbility(caster, "Paladin20")
    local ActiveState = TryGetProp(abil, "ActiveState")
    local abilLevel = TryGetProp(abil, "Level")
    if abil ~= nil and ActiveState == 1 then
        defRate = abilLevel * 0.04
    end
    
    if IsSameActor(caster, self) == "YES" then
        self.DEF_RATE_BM = self.DEF_RATE_BM + defRate;
        
        SetExProp(buff, "ADD_DEF", defRate)
    end
    
    mdefadd = 30 + (lv * 20) + caster.MNA + mdefrate
    self.MDEF_BM = self.MDEF_BM + mdefadd;
    
    SetExProp(buff, "ADD_MDEF", mdefadd)
end

function SCR_BUFF_LEAVE_Barrier_Buff(self, buff, arg1, arg2, over)
    local mdefadd = GetExProp(buff, "ADD_MDEF")
    local defRate = GetExProp(buff, "ADD_DEF")
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defRate;
    self.MDEF_BM = self.MDEF_BM - mdefadd;
end

-- Freeze
function SCR_BUFF_ENTER_Freeze(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_freeze', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    LeaveEffect(self, GetBuffRemainTime(buff), 'Freeze',buff.ClassName);
end

function SCR_BUFF_LEAVE_Freeze(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_freeze')
end

-- Cryomancer_Freeze
function SCR_BUFF_ENTER_Cryomancer_Freeze(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_freeze', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    LeaveEffect(self, GetBuffRemainTime(buff), 'Freeze',buff.ClassName);
    
    local caster = GetBuffCaster(buff);
    local Cryomancer9_abil = GetAbility(caster, "Cryomancer9")
    if Cryomancer9_abil ~= nil then
        SetBuffArgs(buff, Cryomancer9_abil.Level, 0, 0);
    end
end

function SCR_BUFF_LEAVE_Cryomancer_Freeze(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_freeze')
end

-- Cryomancer_FrostPillar
function SCR_BUFF_ENTER_Cryomancer_FrostPillar(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_freeze', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    LeaveEffect(self, GetBuffRemainTime(buff), 'Freeze',buff.ClassName);
    
    local caster = GetBuffCaster(buff);
    local Cryomancer9_abil = GetAbility(caster, "Cryomancer9")
    if Cryomancer9_abil ~= nil then
        SetBuffArgs(buff, Cryomancer9_abil.Level, 0, 0);
    end
end

function SCR_BUFF_LEAVE_Cryomancer_FrostPillar(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_freeze')
end



function SCR_BUFF_ENTER_DeedsOfValor(self, buff, arg1, arg2, over)
--    PlaySound(self, "skl_eff_frenzy_up")
--  Invalidate(self, "DEF");
--  Invalidate(self, "MINPATK");
--  
----    if arg1 < over then 
----        over = arg1
----    end
----    
----    if over == 1 then
----        SetExProp(buff, 'SKL_LV', arg1)
----    end
--    
--  local dg = 0.05 + (0.01 * arg1);
----    local dg = 0.05 * over;
----    local dgatk = self.MINPATK * 0.1 * over;
--    local dgatk = 0.05 + (0.01 * arg1);
----    local atkspdadd = arg1 * 50
--  
----    if dg > self.DEF then
----        dg = self.DEF 
----    end
--  
--  self.DEF_RATE_BM = self.DEF_RATE_BM - dg;
--  self.PATK_RATE_BM = self.PATK_RATE_BM + dgatk;
----    SET_NORMAL_ATK_SPEED(self, -atkspdadd);
--
----    SetExProp(buff, "TOTAL_DG", dg)
--  SetExProp(buff, "ADD_MINPATK", dgatk);
----    SetExProp(buff, "ADD_ATKSPD", atkspdadd);
end

function SCR_BUFF_LEAVE_DeedsOfValor(self, buff, arg1, arg2, over)
--
----    local dg = GetExProp(buff, "TOTAL_DG")
--  local dgatk = GetExProp(buff, "ADD_MINPATK")
----    local atkspdadd = GetExProp(buff, "ADD_ATKSPD");
--  
----    self.DEF_RATE_BM = self.DEF_RATE_BM + dg;
--  self.PATK_RATE_BM = self.PATK_RATE_BM - dgatk
--
----    SET_NORMAL_ATK_SPEED(self, atkspdadd);
end


function SCR_BUFF_ENTER_Reflect(self, buff, arg1, arg2, over)

    self.STR_BM = self.STR_BM + arg1;
    self.INT_BM = self.INT_BM + arg1;

end

function SCR_BUFF_LEAVE_Reflect(self, buff, arg1, arg2, over)

    self.STR_BM = self.STR_BM - arg1;
    self.INT_BM = self.INT_BM - arg1;

end

-- ????--
function SCR_BUFF_ENTER_Sacrifice(self, buff, arg1, arg2, over)

    self.STR_BM = self.STR_BM + arg1;
    self.INT_BM = self.INT_BM + arg1;

end

function SCR_BUFF_LEAVE_Sacrifice(self, buff, arg1, arg2, over)

    self.STR_BM = self.STR_BM - arg1;
    self.INT_BM = self.INT_BM - arg1;

end


function SCR_BUFF_ENTER_ReflectShield_Buff(self, buff, arg1, arg2, over)
    local damratio = 50;
    local Name = ""
    local buffLv = arg1;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            buffLv = GetPadArgNumber(pad, 1);
        end
        
        Name = GetName(caster)
        
        local shieldLv = 0;
        local abilLv = 0;
        local shield = GetSkill(caster, 'Wizard_ReflectShield')
        if shield ~= nil then
            shieldLv = shield.Level;
        end
        
        local Wizard2_abil = GetAbility(caster, "Wizard2")
        if Wizard2_abil ~= nil and shieldLv >= 3 then
            abilLv = Wizard2_abil.Level;
        end
        
        SetBuffArgs(buff, shieldLv, abilLv, caster.MNA);
    end
    
    self.DamReflect = self.DamReflect + damratio;
    
    SetExProp(buff, "ADD_DAMREFLCET", damratio);
    SetExProp(buff, "ATTACKED_COUNT", 0);
    
    if self.Name ~= Name then
        SkillTextEffect(nil, self, caster, "SHOW_ICE_SHIELD", buff.ClassID, nil, Name);
    end
end

function SCR_BUFF_LEAVE_ReflectShield_Buff(self, buff, arg1, arg2, over)
    local damratio = GetExProp(buff, "ADD_DAMREFLCET");
    
    self.DamReflect = self.DamReflect - damratio;
	
    DetachEffect(self, 'I_sphere007_mash');
    PlayEffect(self, "F_wizard_reflect_shot_light", 1, 2, "BOT");
end


function SCR_BUFF_ENTER_todal_shield(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_todal_shield(self, buff, arg1, arg2, over)

end

-- ArmorBreak
function SCR_BUFF_ENTER_ArmorBreak(self, buff, arg1, arg2, over)
    local defadd = 0.5;
    local mdefadd = 0.5;
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - mdefadd;
    
    SetExProp(buff, "ADD_DEF", defadd);
    SetExProp(buff, "ADD_MDEF", defadd);
end

function SCR_BUFF_LEAVE_ArmorBreak(self, buff, arg1, arg2, over)
    local defadd = GetExProp(buff, "ADD_DEF");
    local mdefadd = GetExProp(buff, "ADD_MDEF");
    
    self.DEF_RATE_BM= self.DEF_RATE_BM + defadd;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + mdefadd;
end


function SCR_BUFF_ENTER_Destroy(self, buff, arg1, arg2, over)
    local defadd = 0.1;
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
    
    SetExProp(buff, "ADD_DEF", defadd);
end

function SCR_BUFF_LEAVE_Destroy(self, buff, arg1, arg2, over)
    local defadd = GetExProp(buff, "ADD_DEF");
    
    self.DEF_RATE_BM= self.DEF_RATE_BM + defadd;
end

function SCR_BUFF_ENTER_MissileHole_Buff(self, buff, arg1, arg2, over)
    SetExProp(buff, "MISSILEHOLE_ATTACKED_COUNT", 0)
end

function SCR_BUFF_LEAVE_MissileHole_Buff(self, buff, arg1, arg2, over)
end

-- Absorb
function SCR_BUFF_ENTER_Absorb(self, buff, arg1, arg2, over)

    
end

function SCR_BUFF_LEAVE_Absorb(self, buff, arg1, arg2, over)


end

-- TeleHold
function SCR_BUFF_ENTER_TeleHold(self, buff, arg1, arg2, over)
    --ActorVibrate(self, 7, 1, 25, 0.1);
end

function SCR_BUFF_UPDATE_TeleHold(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    if IsBuffApplied(caster, "TeleCast") == 'NO' then
        return 0;
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_TeleHold(self, buff, arg1, arg2, over)
    ActorVibrate(self, 0, 0, 0, 0);
        
    if over <= 1 or IsDead(self) == 1 then
        local caster = GetBuffCaster(buff);
        RemoveBuff(caster, 'TeleCast');
    end
end

function SCR_BUFF_ENTER_Conquest(self, buff, arg1, arg2, over)

    local defadd = self.DEF;
    self.DEF_BM = self.DEF_BM - defadd;
    SetExProp(buff, "ADD_DEF", defadd);

end

function SCR_BUFF_LEAVE_Conquest(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");
    self.DEF_BM= self.DEF_BM + defadd;

end

-- ShadowUmbrella
function SCR_BUFF_ENTER_ShadowUmbrella(self, buff, arg1, arg2, over)

    SetHideCheckScript(self, "HIDE_FROM_GOBLINE");

end

function SCR_BUFF_LEAVE_ShadowUmbrella(self, buff, arg1, arg2, over)

    SetHideCheckScript(self, "None");

end

function HIDE_FROM_GOBLINE(self, attacker)

    if attacker.RaceType == "Widling" then
        return 1;
    end
    
    return 0;

end

function SCR_BUFF_ENTER_FluFlu_Buff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    AddBuff(caster, self, "Fear", arg1, 0, 8000 + arg1 * 200, 1);
    AddBuff(caster, self, "Confuse", arg1, 0, 8000 + arg1 * 200, 1);
end

function SCR_BUFF_LEAVE_FluFlu_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_FluFlu_Debuff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end

    AddBuff(caster, self, "Fear", arg1, 0, 8000 + arg1 * 200, 1);
    
end

function SCR_BUFF_LEAVE_FluFlu_Debuff(self, buff, arg1, arg2, over)



end


function SCR_BUFF_ENTER_Ion(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Ion(self, buff, arg1, arg2, RemainTime, ret, over)
    
    local damage = GetExProp(self, "IonDamage");
    local range = 50;
    local count = 1 + arg1;     --arg1 == skill.Level
    local objList, objCount = SelectObjectNear(GetBuffCaster(buff), self, range, 'ENEMY');

    count = math.min(objCount, count);
    for i=1, count do
        local obj = objList[i];
        if IsSameActor(obj, self) == "NO" then

            local caster = GetBuffCaster(buff);
            if caster == nil then
                caster = buff;
            end
            TakeDamage(caster, obj, "None", IMCRandom(damage / 3, damage / 2), "None", "None", "None", HIT_BASIC, HITRESULT_BLOW, 0, 0);        
        end
    end
    return 1;
end

function SCR_BUFF_LEAVE_Ion(self, buff, arg1, arg2, over)
end

-- HeavyBleeding
function SCR_BUFF_ENTER_HeavyBleeding(self, buff, arg1, arg2, over)
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    local damage = (caster.MINPATK + caster.MAXPATK)/5
    SetBuffArgs(buff, damage, 0, 0);
end

function SCR_BUFF_UPDATE_HeavyBleeding(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    local damage = GetBuffArgs(buff);
    if GetObjType(self) == OT_MONSTERNPC then
        if self.MonRank == 'Boss' then
            TakeDamage(caster, self, "None", self.MHP/200, "None", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
        else
            TakeDamage(caster, self, "None", self.MHP/20, "None", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
        end
    elseif GetObjType(self) == OT_PC then
        RemoveBuffGroup(self, 'Debuff', 'Wound', 1, 5);
        TakeDamage(caster, self, "None", damage, "None", "None", "TrueDamage", HIT_BASIC, HITRESULT_BLOW, 0, 0);
    end
    
    
    return 1;

end

function SCR_BUFF_LEAVE_HeavyBleeding(self, buff, arg1, arg2, over)

end

-- GuardImpact
function SCR_BUFF_ENTER_SoldierDead(self, buff, arg1, arg2, over)

    SetHittable(self, 0);

end

function SCR_BUFF_UPDATE_SoldierDead(self, buff, arg1, arg2, RemainTime, ret, over)

    local remainSec = math.floor(RemainTime / 1000);
    if remainSec <= 0 then
        Chat(self, "", 0.01);
    else
        Chat(self, tostring(remainSec));
    end
    return 1;

end

function SCR_BUFF_LEAVE_SoldierDead(self, buff, arg1, arg2, over)

    AddHP(self, self.MHP);
    SendDummyPCHP(self);
    SetHittable(self, 1);

end


function SCR_BUFF_ENTER_mario(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_mario(self, buff, arg1, arg2, RemainTime, ret, over)

    local objList, objCount = SelectObject(self, 50, 'ENEMY');
    for i = 1, objCount do
        local obj = objList[i];
        if obj ~= nil then
                
            local x, y, z = GetPos(obj);

            local gold = obj.Level;
            local drop_classname = CalcVisSize(gold);
            local mon = GetClassByStrProp("Monster", "ClassName", drop_classname);

            if GetClassByType("Monster", mon.ClassID) ~= nil then
                local rdObj = CreateGCIESByID('Monster', mon.ClassID);
                rdObj.ItemCount = gold;
                local item = CREATE_ITEM(self, rdObj, self, x, y, z, 0, 1);
                if item ~= nil then
                    SetExProp(item, "KD_POWER_MAX", 270);
                    SetExProp(item, "KD_POWER_MIN", 120);
                end
            end
      
      PlayEffectToGround(self, 'F_light064_blue', x, y, z, 0.7, 1)
            Kill(obj);
        end     
    end

    return 1;

end

function SCR_BUFF_LEAVE_mario(self, buff, arg1, arg2, over)

  DetachEffect(self, 'F_levitation024_yellow')
end

function SCR_BUFF_ENTER_Rage_Rockto_spd(self, buff, arg1, arg2, over)

  local mspdadd = self.MSPD * 1.1
    
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);

end

function SCR_BUFF_LEAVE_Rage_Rockto_spd(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM - mspdadd;

end

function SCR_BUFF_ENTER_Rage_Rockto_spd_down(self, buff, arg1, arg2, over)

  local mspdadd = self.MSPD * 0.7
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);

end

function SCR_BUFF_LEAVE_Rage_Rockto_spd_down(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;

end


function SCR_BUFF_ENTER_Rage_Rockto_atk_down(self, buff, arg1, arg2, over)


    local atkadd = self.MINMATK * 0.5
    
    self.MATK_BM = self.MATK_BM - atkadd;
    
    SetExProp(buff, "ADD_MINMATK", atkadd);

end

function SCR_BUFF_LEAVE_Rage_Rockto_atk_down(self, buff, arg1, arg2, over)

    local atkadd = GetExProp(buff, "ADD_MINMATK");
    
    self.MATK_BM = self.MATK_BM + atkadd;

end

function SCR_BUFF_ENTER_Rage_Rockto_atk(self, buff, arg1, arg2, over)


    local atkadd = 0.5
    
    self.MATK_RATE_BM = self.MATK_RATE_BM + atkadd;
    
    SetExProp(buff, "ADD_MINMATK", atkadd);

end

function SCR_BUFF_LEAVE_Rage_Rockto_atk(self, buff, arg1, arg2, over)

    local atkadd = GetExProp(buff, "ADD_MINMATK");
    
    self.MATK_RATE_BM = self.MATK_RATE_BM - atkadd;

end

function SCR_BUFF_ENTER_Rage_Rockto_def(self, buff, arg1, arg2, over)

     local defadd = 0.6
  
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd
    
    SetExProp(buff, "ADD_DEF", defadd);

end

function SCR_BUFF_LEAVE_Rage_Rockto_def(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");

    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;

end



function SCR_BUFF_ENTER_Weaken(self, buff, arg1, arg2, over)

    local defadd = 0.5
    local atkadd = self.MINMATK * 0.5
  
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd
    self.ATK_BM = self.ATK_BM - atkadd;
        
    SetExProp(buff, "ADD_DEF", defadd);
    SetExProp(buff, "ADD_MINMATK", atkadd);

end

function SCR_BUFF_LEAVE_Weaken(self, buff, arg1, arg2, over)


    local defadd = GetExProp(buff, "ADD_DEF");
    local atkadd = GetExProp(buff, "ADD_MINMATK");
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;
    self.ATK_BM = self.ATK_BM + atkadd;


end

--PhalanxFormation_Buff
function SCR_BUFF_ENTER_PhalanxFormation_Buff(self, buff, arg1, arg2, over)

    local arg3, arg4, arg5 = GetBuffArgs(buff);
    if arg3 == 0 then
         local caster = GetBuffCaster(buff);
         local abil = GetAbility(caster, "Centurion1")
         if abil ~= nil then
            arg3 = abil.Level;
            SetBuffArgs(buff, arg3, arg4, arg5);
        end
    end

end

function SCR_BUFF_UPDATE_PhalanxFormation_Buff(self, buff, arg1, arg2, RemainTime, ret, over)

      local buffOwner = GetBuffCaster(buff);
      if GetHandle(self) == GetHandle(buffOwner) then
            if self.SP > 0  then
                AddSP(self, -self.MSP * 0.01)
            else
                RunFormation(self, GetSkill(self, "Centurion_PhalanxFormation"), "None");
                return 0;
            end
      end
    return 1;
end

function SCR_BUFF_LEAVE_PhalanxFormation_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_WedgeFormation_buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_WedgeFormation_buff(self, buff, arg1, arg2, RemainTime, ret, over)

    local buffOwner = GetBuffCaster(buff);

    if GetHandle(self) == GetHandle(buffOwner) then
        if self.SP > 0  then
            AddSP(self, -self.MSP * 0.01)
        else
            RunFormation(self, GetSkill(self, "Centurion_WedgeFormation"), "None");
            return 0;
        end
    end

    return 1;

end

function SCR_BUFF_LEAVE_WedgeFormation_buff(self, buff, arg1, arg2, over)

end

--CraneWing
function SCR_BUFF_ENTER_WingedFormation_Debuff(self, buff, arg1, arg2, over)

   local defadd = self.DEF * (0.5 + (0.03 * arg1))
     self.DEF_BM = self.DEF_BM - defadd 
     SetExProp(buff, "ADD_DEF", defadd);

end

function SCR_BUFF_LEAVE_WingedFormation_Debuff(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");
    self.DEF_BM = self.DEF_BM + defadd;

end

function SCR_BUFF_ENTER_TercioFormation_Buff(self, buff, arg1, arg2, over)


end


function SCR_BUFF_UPDATE_TercioFormation_Buff(self, buff, arg1, arg2, RemainTime, ret, over)

      local buffOwner = GetBuffCaster(buff);
    if GetHandle(self) == GetHandle(buffOwner) then
        if self.SP > 0  then
            AddSP(self, -self.MSP * 0.01)
        else
            RunFormation(self, GetSkill(self, "Centurion_TercioFormation"), "None");
            return 0;
        end
    end

    local propValue = GetExProp(buff, 'DEF_BM');
    if propValue > 0 then
        local objList, objCount = SelectObject(self, 100, 'ENEMY');
        for i = 1, objCount do
        local obj = objList[i];
        if obj ~= nil then
            local topAttacker = GetTopHatePointChar(obj)
            if topAttacker ~= nil then
                local atkerHate = GetHate(obj, topAttacker);
                local myHate = GetHate(obj, self);
                if atkerHate >= myHate then
                    local addHate = atkerHate + 500;
                    InsertHate(obj, self, addHate);
                end
            else
                InsertHate(obj, self, 500);
            end
        end
        end
    
    end
    return 1;
end


function SCR_BUFF_LEAVE_TercioFormation_Buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_WingedFormation_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_UPDATE_WingedFormation_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
      local buffOwner = GetBuffCaster(buff);

    if GetHandle(self) == GetHandle(buffOwner) then
        if self.SP > 0  then
            AddSP(self, -self.MSP * 0.01)
        else
            RunFormation(self, GetSkill(self, "Centurion_WingedFormation"), "None");
            return 0;
        end
    end

        local objList, objCount = SelectObject(self, 300, 'ENEMY');
        for i = 1, objCount do
        local obj = objList[i];
        if obj ~= nil then
            local topAttacker = GetTopHatePointChar(obj)
            if topAttacker ~= nil then
                local atkerHate = GetHate(obj, topAttacker);
                local myHate = GetHate(obj, self);
                if atkerHate >= myHate then
                    local addHate = atkerHate + 500;
                    InsertHate(obj, self, addHate);
                end
            else
                InsertHate(obj, self, 500);
            end
        end
        end

    return 1;
end


function SCR_BUFF_LEAVE_WingedFomation_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_SchiltronFormation_Buff(self, buff, arg1, arg2, over)

    
    local addrhptime = 0
    
    local caster = GetBuffCaster(buff)
    local abil = GetAbility(caster, "Centurion4")
    if abil ~= nil then
        addrhptime = addrhptime + abil.Level * 2000
    end
    
    self.RHPTIME_BM = self.RHPTIME_BM + addrhptime;
    SetExProp(buff, "ADD_RHPTIME", addrhptime);
    
end

function SCR_BUFF_UPDATE_SchiltronFormation_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
      local buffOwner = GetBuffCaster(buff);

    if GetHandle(self) == GetHandle(buffOwner) then
        if self.SP > 0  then
            AddSP(self, -self.MSP * 0.01)
        else
            RunFormation(self, GetSkill(self, "Centurion_SchiltronFormation"), "None");
            return 0;
        end
    end

    return 1;

end

function SCR_BUFF_LEAVE_SchiltronFormation_Buff(self, buff, arg1, arg2, over)

    local addrhptime = GetExProp(buff, "ADD_RHPTIME")
    self.RHPTIME_BM = self.RHPTIME_BM - addrhptime;
    
end



function SCR_BUFF_ENTER_Moldy_skill(self, buff, arg1, arg2, over)

    local mspdadd = self.MSPD * 0.5
    
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
    
    
    
    

end

function SCR_BUFF_UPDATE_Moldy_skill(self, buff, arg1, arg2, RemainTime, ret, over)

    AddSP(self, -self.MSP * 0.2)

    return 1;

end

function SCR_BUFF_LEAVE_Moldy_skill(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;

end




function SCR_BUFF_ENTER_Summoning_Buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Summoning_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
--    local caster = GetBuffCaster(buff);
--    if caster == nil then
--        return 0;
--    end
--    
--    local lv = TryGetProp(caster, "Lv")
--    if lv == nil then
--        lv = 1;
--    end
--    
--    local consumeSP = lv * 0.2
--    if consumeSP < 1 then
--        consumeSP = 1
--    end
--    
--    local nowSP = TryGetProp(self, "SP");
--    if nowSP >= consumeSP then
--        AddSP(self, -consumeSP)
--        return 1;
--    else
--        return 0;
--    end
    
    return 1;
end

function SCR_BUFF_LEAVE_Summoning_Buff(self, buff, arg1, arg2, over)
    local list , cnt  = GetFollowerList(self);
    local handle = GetExProp(self, 'SORCERER_SUMMONING');
    for i = 1 , cnt do
        local fol = list[i];
        if GetHandle(fol) == handle then
            Dead(fol);
            break;
        end
    end
end



function SCR_BUFF_ENTER_Moldy_skill_Debuff(self, buff, arg1, arg2, over)
    
    

end

function SCR_BUFF_UPDATE_Moldy_skill_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)


     local lv = arg1
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    local avgAtk = (caster.MINMATK + caster.MAXMATK) / 2;
    
    TakeDamage(caster, self, "None", ((caster.MINMATK + caster.MAXMATK) * (1 + (lv * 0.1))) / 10, "None", "None", "None", HIT_BASIC, HITRESULT_BLOW, 0, 0);


    return 1;

end


function SCR_BUFF_LEAVE_Moldy_skill_Debuff(self, buff, arg1, arg2, over)


end





function SCR_BUFF_ENTER_Moldy_skill_buff(self, buff, arg1, arg2, over)
    

end

function SCR_BUFF_LEAVE_Moldy_skill_buff(self, buff, arg1, arg2, over)


end

-- Melstis_Buff
function SCR_BUFF_ENTER_Melstis_Buff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    local skill = GetSkill(caster, "Kriwi_Melstis")
    if caster ~= nil then
        local buff_list, buff_cnt = GetBuffList(self)
        if buff_cnt >= 1 then
            for i = 1, buff_cnt do
                if TryGetProp(buff_list[i], "Premium") ~= "PC" then
                    if TryGetProp(buff_list[i], "Group1") == 'Buff' and TryGetProp(buff_list[i], "Keyword") ~= "IgnoreImmune" and TryGetProp(buff_list[i], "Keyword") ~= "Invincibility" then
                        local buff = buff_list[i];
                        local buffTime = GetBuffRemainTime(buff)
                        local timeValue = buffTime * (skill.Level * 0.2)
                        if timeValue > 20000 then
                            timeValue = 20000
                        end
                        
                        SetBuffRemainTime(self, buff.ClassName, buffTime + timeValue);
                    end
                end
            end
        end
    end
end

function SCR_BUFF_LEAVE_Melstis_Buff(self, buff, arg1, arg2, over)
    
end

--function SCR_BUFF_ENTER_Melstis_Buff(self, buff, arg1, arg2, over)
--    SetBuffTimeHold(self, 1)
--end
--
--function SCR_BUFF_LEAVE_Melstis_Buff(self, buff, arg1, arg2, over)
--    SetBuffTimeHold(self, 0)
--end

-- CarveLaima_Buff
function SCR_BUFF_ENTER_CarveLaima_Buff(self, buff, arg1, arg2, over)   
    InvalidateSkillCoolDown(self);
end

function SCR_BUFF_LEAVE_CarveLaima_Buff(self, buff, arg1, arg2, over)   
    InvalidateSkillCoolDown(self);
end

-- CarveLaima_Debuff
function SCR_BUFF_ENTER_CarveLaima_Debuff(self, buff, arg1, arg2, over)
    InvalidateSkillCoolDown(self);
end

function SCR_BUFF_LEAVE_CarveLaima_Debuff(self, buff, arg1, arg2, over)
    InvalidateSkillCoolDown(self);
end


function SCR_BUFF_ENTER_CarveLaima_MSPD_Debuff(self, buff, arg1, arg2, over)
    local lv = 1;
    local caster = GetBuffCaster(buff);
    if IS_PC(caster) == false then
        caster = GetOwner(caster)
    end
    
    if caster ~= nil then
        local skill = GetSkill(caster, "Dievdirbys_CarveLaima");
        
        lv = TryGetProp(skill, "Level");
        if lv == nil then
            lv = 1;
        end
    end
    
    local mspdadd = lv * 1;
    
    self.MSPD_BM = self.MSPD_BM - mspdadd
    SetExProp(buff, "ADD_MSPD", mspdadd);
end


function SCR_BUFF_LEAVE_CarveLaima_MSPD_Debuff(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM + mspdadd;

end


function SCR_BUFF_ENTER_CarveZemina_Buff(self, buff, arg1, arg2, over)
    local lv = 1;
    local caster = GetBuffCaster(buff);
    local msptime = 5000
    if caster ~= nil then
        lv = GetExProp(caster, "ZEMINA_SKILL_LV");
    end

    SetExProp(self, "ZEMINA_BUFF_LV", lv);
    self.RSPTIME_BM = self.RSPTIME_BM + msptime
    SetExProp(buff, "RSPTIME", msptime);
    Invalidate(self, "RSPTIME");
    InvalidateSkill(self, "ALL");
end

function SCR_BUFF_LEAVE_CarveZemina_Buff(self, buff, arg1, arg2, over)
    DelExProp(self, "ZEMINA_BUFF_LV")
    local msptime = GetExProp(buff, "RSPTIME")
    self.RSPTIME_BM = self.RSPTIME_BM - msptime
    Invalidate(self, "RSPTIME");
    InvalidateSkill(self, "ALL");
end

-- CarveAustrasKoks_Debuff
function SCR_BUFF_ENTER_CarveAustrasKoks_Debuff(self, buff, arg1, arg2, over)

    -- ShowEmoticon(self, 'I_emo_silence', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    if IS_PC(self) == false then
        AddBuff(self, self, 'Silence_Debuff', 1, 0, 0);
    else
        AddLimitationSkillList(self, "Normal_Attack");
        AddLimitationSkillList(self, "Normal_Attack_TH");
        AddLimitationSkillList(self, "Hammer_Attack");
        AddLimitationSkillList(self, "Common_DaggerAries");
        AddLimitationSkillList(self, "Common_StaffAttack");
        
        local abil = GetAbility(self, "QuarrelShooter7")
        if abil ~= nil then
            AddLimitationSkillList(self, "QuarrelShooter_Teardown")
        end
    end
    
    --local jobObj = GetJobObject(self);    
    --if jobObj.CtrlType == 'Warrior' or jobObj.CtrlType == 'Archer' then
    --    RemoveBuff(self, 'CarveAustrasKoks_Debuff')
    --end

end

function SCR_BUFF_LEAVE_CarveAustrasKoks_Debuff(self, buff, arg1, arg2, over)
    -- HideEmoticon(self, 'I_emo_silence')
    if IS_PC(self) == false then
        RemoveBuff(self, 'Silence_Debuff');
    else
        ClearLimitationSkillList(self);
    end
end


-- Bless
function SCR_BUFF_ENTER_Cleric_Bless_Buff(self, buff, arg1, arg2, over)

    local agi = self.DEX_JOB + self.DEX_STAT + GetSumOfEquipItem(self, 'DEX') 
    local agiAdd = math.floor((agi * (0.1 + arg1 * 0.02)) + 5);
    self.DEX_BM = self.DEX_BM + agiAdd;
    SetExProp(buff, "ADD_DEX", agiAdd);
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end

    local Name = GetName(caster)
    if self.Name ~= Name then
        SkillTextEffect(nil, self, caster, "SHOW_BLESS", buff.ClassID, nil, Name);
    end

end


function SCR_BUFF_LEAVE_Cleric_Bless_Buff(self, buff, arg1, arg2, over)

    local agiAdd = GetExProp(buff, "ADD_DEX");
    self.DEX_BM= self.DEX_BM - agiAdd;

end

-- Bless Debuff
function SCR_BUFF_ENTER_Cleric_Bless_Debuff(self, buff, arg1, arg2, over)
    
    local def = 0;
    
    if self.GroupName == "PC" then
        def = GetSumOfEquipItem(self, "DEF") + self.MAXDEF_Bonus
    elseif self.GroupName == "Monster" then
        def = GET_DEF_BY_LEVEL(self.Lv) + self.DEF
    end    
    
    local defadd = def * 0.2 + (arg1*0.003) --set_LI(arg1, 0.2, 0.5)
    self.DEF_BM = self.DEF_BM - defadd
    
    SetExProp(buff, "ADD_DEF", defadd);

end


function SCR_BUFF_LEAVE_Cleric_Bless_Debuff(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");

    self.DEF_BM = self.DEF_BM + defadd;

end

-- Zalciai_Buff
function SCR_BUFF_ENTER_Zalciai_Buff(self, buff, arg1, arg2, over)
    Invalidate(self, "CRTATK");
    
    local addCrtAtk = 0;
    local statbounus = 0;
    local addmhr = 0
    local lv = arg1;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
        statbonus =  caster.MNA * (lv * 0.1)
        addCrtAtk = 12 + (6 * lv) + statbonus
        
        local skill = GetSkill(caster, "Kriwi_Zalciai")
        if skill == nil then
            return
        end
        
        local abil = GetAbility(caster, "Kriwi8")
        if abil ~= nil then
            addmhr = abil.Level * 12
        end
        
        local Kriwi17_abil = GetAbility(caster, "Kriwi17")
        if Kriwi17_abil ~= nil and skill.Level >= 3 then
            addCrtAtk = addCrtAtk * (1 + Kriwi17_abil.Level * 0.01);
        end
    end
    
    addCrtAtk =  math.floor(addCrtAtk);
    
    SetExProp(buff, "ADD_CRTATK", addCrtAtk)
    SetExProp(buff, "ADD_MHR", addmhr)
    
    self.CRTATK_BM = self.CRTATK_BM + addCrtAtk;
    self.MHR_BM = self.MHR_BM + addmhr
end


function SCR_BUFF_LEAVE_Zalciai_Buff(self, buff, arg1, arg2, over)

    local addCrtAtk = GetExProp(buff, "ADD_CRTATK")
    local addmhr = GetExProp(buff, "ADD_MHR")
    
    self.CRTATK_BM = self.CRTATK_BM - addCrtAtk;
    self.MHR_BM = self.MHR_BM - addmhr;
    
end

-- Zalciai_Debuff
function SCR_BUFF_ENTER_Zalciai_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    Invalidate(self, "CRTDR");
    
    local addCrtDr = 0;
    local lv = arg1;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
        addCrtDr = arg1 * 10;
            if addCrtDr > self.CRTDR then
                addCrtDr = self.CRTDR 
            end
    end
    
    addCrtDr = math.floor(addCrtDr);
    
    self.CRTDR_BM = self.CRTDR_BM - addCrtDr;
    SetExProp(buff, "ADD_CRTDR", addCrtDr)
end

function SCR_BUFF_LEAVE_Zalciai_Debuff(self, buff, arg1, arg2, over)

    local addCrtDr = GetExProp(buff, "ADD_CRTDR")
    
    self.CRTDR_BM = self.CRTDR_BM + addCrtDr;

end


-- DeprotectedZone_Debuff
function SCR_BUFF_ENTER_DeprotectedZone_Debuff(self, buff, arg1, arg2, over)
    if self == nil then
        return
    end
    
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    Invalidate(self, "DEF");
    
    local defadd = 0;
    local lv = arg1;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
        
        local Cleric7_abil = GetAbility(caster, "Cleric7");
        if Cleric7_abil ~= nil then
            SetBuffArgs(buff, Cleric7_abil.Level, 0, 0);
        end
    end
    
    if over < 1 then
        over = 1;
    end
    
    local overRate = 0.003;
    
    defadd = overRate * over;
    
    local skill = GetSkill(caster, "Cleric_DeprotectedZone")
    if skill == nil then
        return
    end
    
    if caster ~= nil then
        local Cleric13_abil = GetAbility(caster, 'Cleric13')
        if Cleric13_abil ~= nil and skill.Level >= 3 then
            defadd = defadd * (1 + Cleric13_abil.Level * 0.01)
        end
    end
    if defadd > self.DEF then
        defadd = self.DEF;
    end
    
    SetExProp(buff, "ADD_DEF", defadd)
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
end


function SCR_BUFF_LEAVE_DeprotectedZone_Debuff(self, buff, arg1, arg2, over)
    local defadd = GetExProp(buff, "ADD_DEF")
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;
end

-- Monstrance_Debuff
function SCR_BUFF_ENTER_Monstrance_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    Invalidate(self, "DEF");
    Invalidate(self, "DR");
    
    local defadd = 0.1
    local dradd = 0
    local lv = arg1;

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
        
        dradd = 6.3 + (lv - 1) * 2.4 + caster.MNA * 0.4
    end
    
    dradd = math.floor(dradd)
    
    SetExProp(buff, "ADD_DEF", defadd)
    SetExProp(buff, "ADD_DR", dradd)
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
    self.DR_BM = self.DR_BM - dradd
end


function SCR_BUFF_LEAVE_Monstrance_Debuff(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF")
    local dradd = GetExProp(buff, "ADD_DR")
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;
    self.DR_BM = self.DR_BM + dradd;

end


-- Monstrance_Buff
function SCR_BUFF_ENTER_Monstrance_Buff(self, buff, arg1, arg2, over)
    local caster =  GetBuffCaster(buff);

    local adddex = math.floor(10 + self.DEX * 0.3)
    self.DEX_BM = self.DEX_BM + adddex;
    SetExProp(buff, "ADD_DEX", adddex);

    local abil = GetAbility(caster, "Priest4");
    if abil ~= nil then
        local addDR = abil.Level * 20
        self.DR_BM = self.DR_BM + addDR;
        SetExProp(buff, "ADD_DR_ABIL", addDR);

--      local addDef = self.DEF * abil.Level * 0.02;
--      self.DEF_BM = self.DEF_BM + addDef;
--      SetExProp(buff, "ADD_DEF_ABIL", addDef);
    end
end

function SCR_BUFF_LEAVE_Monstrance_Buff(self, buff, arg1, arg2, over)

    local adddex = GetExProp(buff, "ADD_DEX");
    self.DEX_BM = self.DEX_BM - adddex;
    
    local addDR = GetExProp(buff, "ADD_DR_ABIL");
    self.DR_BM = self.DR_BM - addDR;

    local addDef = GetExProp(buff, "ADD_DEF_ABIL");
    self.DEF_BM = self.DEF_BM - addDef;
end


-- DivineMight_Buff
function SCR_BUFF_ENTER_DivineMight_Buff(self, buff, arg1, arg2, over)
    local isBuff = GetExProp(self, "isDivineMight_Buff");
    if isBuff == 0 then
        local list, cnt = GetPCSkillList(self);
        for i = 1, cnt do
            if list[i].ClassID > 10000 and list[i].ClassName ~= "Cleric_DivineMight" then
				local skillcls = GetClass("Skill", list[i].ClassName)
				if skillcls ~= nil and TryGetProp(skillcls, 'CommonType', 'None') == "None" then
					list[i].Level_BM = list[i].Level_BM + 1;
					--UpdateProperty(list[i], "Level");
					InvalidateObjectProp(list[i], "Level");
					InvalidateObjectProp(list[i], "SkillAtkAdd");
					InvalidateObjectProp(list[i], "SkillFactor");
					SendSkillProperty(self, list[i]);
				end
            end
        end
        --InvalidateStates(self);
        SetExProp(self, "isDivineMight_Buff", 1)
        SetExProp(self, "DivineMight_Buff_Lv", arg1)
    end
end

function SCR_BUFF_LEAVE_DivineMight_Buff(self, buff, arg1, arg2, over)

    local isBuff = GetExProp(self, "isDivineMight_Buff");
    if isBuff == 1 then
        local list, cnt = GetPCSkillList(self);
        for i = 1, cnt do
            if list[i].ClassID > 10000 and list[i].ClassName ~= "Cleric_DivineMight" then
                local skillcls = GetClass("Skill", list[i].ClassName)
				if skillcls ~= nil and TryGetProp(skillcls, 'CommonType', 'None') == 'None' then
                    list[i].Level_BM = list[i].Level_BM - 1;
                    --UpdateProperty(list[i], "Level");
                    InvalidateObjectProp(list[i], "Level");
                    InvalidateObjectProp(list[i], "SkillAtkAdd");
                    SendSkillProperty(self, list[i]);
                end                
            end
        end
        
        --InvalidateStates(self);
        DelExProp(self, "isDivineMight_Buff")
        DelExProp(self, "DivineMight_Buff_Lv")
    end
end


-- DivineMight_Debuff
function SCR_BUFF_ENTER_DivineMight_Debuff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    if GetObjType(self) == OT_MONSTERNPC then
        if self.RaceType == 'Velnias' then
            TakeDamage(caster, self, "None", IMCRandom(caster.MINMATK, caster.MAXMATK), "Holy", "Magic", "Magic", HIT_HOLY, HITRESULT_BLOW, 0, 0);
        end
    end
    
    SetExProp(self, "isDivineMight_Debuff", 1)
end


function SCR_BUFF_LEAVE_DivineMight_Debuff(self, buff, arg1, arg2, over)

end


-- Aspersion_Buff
function SCR_BUFF_ENTER_Aspersion_Buff(self, buff, arg1, arg2, over)
    Invalidate(self, "DEF");
    local defValue = 0
    
    local caster = GetBuffCaster(buff)
    local stat = TryGetProp(caster, "MNA")
    if caster ~= nil then
        if BuffFromWho(buff) == BUFF_FROM_AUTO_SELLER then
            local stat_BM = TryGetProp(caster, 'MNA_BM');
            local stat_ITEM_BM = TryGetProp(caster, 'MNA_ITEM_BM');
            stat = stat - (stat_BM + stat_ITEM_BM);
        end
        
        SetBuffArgs(buff, stat);
    else
        stat = GetBuffArgs(buff);
    end
    
    defValue = math.floor(75 + ((arg1 - 1) * 25) + ((arg1 / 4) * (stat ^ 0.9)));
    
    if BuffFromWho(buff) == BUFF_FROM_AUTO_SELLER then
        defValue = math.floor(defValue * 0.7);
    end
    
    self.DEF_BM = self.DEF_BM + defValue
    SetExProp(buff, "ADD_DEF", defValue);
end

function SCR_BUFF_LEAVE_Aspersion_Buff(self, buff, arg1, arg2, over)
    local defValue = GetExProp(buff, "ADD_DEF");
    
    self.DEF_BM = self.DEF_BM - defValue;
end

-- Aspersion_DeBuff
function SCR_BUFF_ENTER_Aspersion_DeBuff(self, buff, arg1, arg2, over)
    
    Invalidate(self, "DEF");
    local caster = GetBuffCaster(buff);
    local priest1_abil = GetAbility(caster, 'Priest1')
    if priest1_abil ~= nil then
        local decreaseDef = self.DEF * priest1_abil.Level * 0.08;
        self.DEF_BM = self.DEF_BM - decreaseDef;
        SetExProp(buff, "DECREASE_DEF", decreaseDef);
    end
end

function SCR_BUFF_LEAVE_Aspersion_DeBuff(self, buff, arg1, arg2, over)
    local decreaseDef = GetExProp(buff, "DECREASE_DEF");
    self.DEF_BM = self.DEF_BM + decreaseDef;
end

-- Blessing_Buff
function SCR_BUFF_ENTER_Blessing_Buff(self, buff, arg1, arg2, over)
    local sklLv = GetBuffArg(buff);
    local caster = GetBuffCaster(buff);
    local stat = 0;
    local addAbil = 0;
    
    if caster ~= nil then
        local Blessing = GetSkill(caster, 'Priest_Blessing');
        if nil ~= Blessing then
            sklLv = Blessing.Level;
        end
        
        stat = TryGetProp(caster, "MNA");
        if stat == nil then
            stat = 1;
        end
        
        if BuffFromWho(buff) == BUFF_FROM_AUTO_SELLER then
            local stat_BM = TryGetProp(caster, 'MNA_BM');
            local stat_ITEM_BM = TryGetProp(caster, 'MNA_ITEM_BM');
            stat = stat - (stat_BM + stat_ITEM_BM);
        end
        
        local Priest13_abil = GetAbility(caster, "Priest13")
        if Priest13_abil ~= nil and sklLv >= 3 then
            addAbil = Priest13_abil.Level;
        end
        
        SetBuffArgs(buff, stat, addAbil, 0);
    else
        stat, addAbil = GetBuffArgs(buff);
        caster = self;
    end
    
    local value = math.floor(55 + ((sklLv - 1) * 25) + ((sklLv / 5) * (stat ^ 0.9)));
    value = value * (1 + (addAbil * 0.01));
    
    if BuffFromWho(buff) == BUFF_FROM_AUTO_SELLER then
        value = math.floor(value * 0.7);
    end
    
    value = math.floor(value);
    SetExProp(buff, "BlessingValue", value);
    
    SkillTextEffect(nil, self, caster, 'SHOW_SKILL_BONUS', value, nil, "skill_Blessing");
end

function SCR_BUFF_LEAVE_Blessing_Buff(self, buff, arg1, arg2, over)
	
end

-- Haste_Buff
function SCR_BUFF_ENTER_Haste_Buff(self, buff, arg1, arg2, over)

    local lv = arg1;
    
    local mspdAdd = 3 + lv * 0.5
    local dradd = 0;
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    local casterMNA = TryGetProp(caster, "MNA");
    local baseLv = TryGetProp(self, "Lv");
    
    local addRate = casterMNA / baseLv;
    if addRate <= 0 then
        addRate = 0;
    elseif addRate >= 1 then
        addRate = 1;
    end
    
    mspdAdd = math.floor(mspdAdd * (1 + addRate));
    
    self.MSPD_BM = self.MSPD_BM + mspdAdd;
    SetExProp(buff, "ADD_MSPD", mspdAdd);
    
    local abil = GetAbility(caster, "Chronomancer7");
    if abil ~= nil then
        dradd = dradd + abil.Level * 15
        dradd = math.floor(dradd * (1 + addRate));
    end
    
    self.DR_BM = self.DR_BM + dradd;
    SetExProp(buff, "ADD_DR", dradd);
    
    local Name = GetName(caster)
    if self.Name ~= Name then
        SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    end
    

end

function SCR_BUFF_LEAVE_Haste_Buff(self, buff, arg1, arg2, over)

    local mspdAdd = GetExProp(buff, "ADD_MSPD");
    local dradd = GetExProp(buff, "ADD_DR");

    self.MSPD_BM = self.MSPD_BM - mspdAdd;
    self.DR_BM = self.DR_BM - dradd;

end


function SCR_BUFF_ENTER_Archer_Entangle_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Archer_Entangle_Debuff(self, buff, arg1, arg2, over)


    AddBuff(self, self, 'Archer_EntangleSlow_Debuff', 1, 0, 5000, 1);

end






function SCR_BUFF_ENTER_Melstis(self, buff, arg1, arg2, over)

    local list, cnt = GetBuffList(self);
    SetExProp(buff, "START_BUFF_COUNT", cnt+1);


    local factionName = GetCurrentFaction(self);
    SetExProp_Str(buff, 'PREV_FACTION', factionName);
    SetCurrentFaction(self, 'FreeForAll');
end

function SCR_BUFF_UPDATE_Melstis(self, buff, arg1, arg2, RemainTime, ret, over)
    

    local startBuffCnt = GetExProp(buff, "START_BUFF_COUNT");
    local list, cnt = GetBuffList(self);
    
    if startBuffCnt < cnt then
        

        for index = 1, cnt - startBuffCnt do            
            local newBuff = list[cnt-index];
            if newBuff ~= nil then                      
                if newBuff.Group1 == 'Debuff' then

                    local objList, objCount = SelectObject(self, 100, "ENEMY");
                    if objCount > 1 then



                        for i=1, objCount-1 do
                            local target = objList[i];
                            AddBuff(self, target, newBuff.ClassName, 1, 0, 10000, 1);
                        end
                    end     
                end             
            end
        end

        SetExProp(buff, "START_BUFF_COUNT", cnt);
    end

    return 1;
end
function SCR_BUFF_LEAVE_Melstis(self, buff, arg1, arg2, over)

    -- ????faction???????????
    local factionName = GetExProp_Str(buff, 'PREV_FACTION');
    SetCurrentFaction(self, factionName);

    PlayAnim(self, "ASTD")
end



function SCR_BUFF_ENTER_Cleric_HolyAura_Buff(self, buff, arg1, arg2, over)

    local list, cnt = GetBuffList(self);    
    SetExProp(buff, "START_BUFF_COUNT", cnt+1);

end

function SCR_BUFF_UPDATE_Cleric_HolyAura_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    

    local startBuffCnt = GetExProp(buff, "START_BUFF_COUNT");
    local list, cnt = GetBuffList(self);
    
    if startBuffCnt < cnt then
        

        for index = 1, cnt - startBuffCnt do            
            local newBuff = list[cnt-index];
            if newBuff ~= nil and newBuff.Group1 == 'Buff' then

                local objList, objCount = SelectObject(self, 100, "FRIEND");
                if objCount > 1 then
                    
                    --PlayAnim(self, "REFLECT")
                    for i=1, objCount-1 do
                        local target = objList[i];
                        AddBuff(self, target, newBuff.ClassName);
                    end
                end             
            end
        end

        SetExProp(buff, "START_BUFF_COUNT", cnt);
    end

    return 1;
end
function SCR_BUFF_LEAVE_Cleric_HolyAura_Buff(self, buff, arg1, arg2, over)
end

-- DivineStigma_Debuff
function SCR_BUFF_ENTER_DivineStigma_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

    local arg3, arg4, arg5 = GetBuffArgs(buff);
    if arg3 == 0 then
        local caster = GetBuffCaster(buff);
        local skill = GetSkill(caster, 'Kriwi_DivineStigma');
        local abil = GetAbility(caster, "Kriwi9")
        if skill ~= nil then
            arg3 = skill.Level;
        end
        if abil ~= nil then
            arg4 = abil.Level;
        end

        SetBuffArgs(buff, arg3, arg4, arg5);
    end
end

function SCR_BUFF_UPDATE_DivineStigma_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local damage = GET_SKL_DAMAGE(caster, self, 'Kriwi_DivineStigma');
        TakeDamage(caster, self, 'Kriwi_DivineStigma', damage, 'Fire', 'Magic', 'Magic', HIT_FIRE, HITRESULT_BLOW);
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_DivineStigma_Debuff(self, buff, arg1, arg2, over)

end


-- DivineStigma_Buff
function SCR_BUFF_ENTER_DivineStigma_Buff(self, buff, arg1, arg2, over)
    Invalidate(self, "STR");
    Invalidate(self, "INT");
    
    local stradd = 15 + (arg1 - 1) * 8;
    local intadd = 15 + (arg1 - 1) * 8;
    
    SetExProp(buff, "ADD_STR", stradd)
    SetExProp(buff, "ADD_INT", intadd)
    
    self.STR_BM = self.STR_BM + stradd;
    self.INT_BM = self.INT_BM + intadd;
end

function SCR_BUFF_LEAVE_DivineStigma_Buff(self, buff, arg1, arg2, over)

    local stradd = GetExProp(buff, "ADD_STR")
    local intadd = GetExProp(buff, "ADD_INT")

    self.STR_BM = self.STR_BM - stradd;
    self.INT_BM = self.INT_BM - intadd;

end



function SCR_BUFF_ENTER_Isa_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_Isa_Buff(self, buff, arg1, arg2, over)


end



function SCR_BUFF_ENTER_Thurisaz_Buff(self, buff, arg1, arg2, over)
    ChangeScalePC(self, 2.0, 0, 1, 0, 1);
    SetRenderOption(self, "bigheadmode", 0);

    local mspdadd = 20;
    local defadd = 0.2
    local mdefadd = 0.2
    
    local MHP = TryGetProp(self, "MHP")
    local mhpadd = MHP * 0.2
    local caster = GetBuffCaster(buff)
    if caster ~= nil then
        local abil = GetAbility(caster, "RuneCaster4")
        if abil ~= nil then
            mhpadd = mhpadd + (math.floor(caster.CON * 0.2) * abil.Level * 60)
        end
    end
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + mdefadd
    self.MHP_BM = self.MHP_BM + mhpadd
    self.MSPD_BM = self.MSPD_BM + mspdadd
    
    SetExProp(buff, "ADD_DEF", defadd)
    SetExProp(buff, "ADD_MHP", mhpadd)
    SetExProp(buff, "ADD_MSPD", mspdadd)
    SetExProp(buff, "ADD_MDEF", mdefadd)
    self.Size = "L";
    
--    local sklTree, cnt = GetClassList('SkillTree')
--    if sklTree ~= nil then
--        for i = 0, cnt - 1 do
--            local scl = GetClassByIndexFromList(sklTree, i)
--            if scl ~= nil then
--                if string.find(scl.ClassName, "Char2") ~= nil then
--                    AddLimitationSkillList(self, scl.SkillName);
--                end
--            end
--        end
--    end
    
    local addLimitationSkillList = {};
    local list, cnt = GetClassList("Skill")
    if list ~= nil then
        for i = 1, cnt - 1 do
            local skill = GetClassByIndexFromList(list, i)
            if skill ~= nil then
                if skill.ValueType == "Buff" then
                    addLimitationSkillList[#addLimitationSkillList + 1] = skill.ClassName;
                end
            end
        end
    end
    
    for j = 1 , #addLimitationSkillList do
        local skillList = addLimitationSkillList[j];
        local addList = GetSkill(self, skillList);
        if addList ~= nil then
            InvalidateObjectProp(addList, "MaxR");
            SendSkillProperty(self, addList);
            AddLimitationSkillList(self, skillList);
        end
    end
    
    AddLimitationSkillList(self, "Normal_Attack");
    AddLimitationSkillList(self, "Bow_Attack");
    AddLimitationSkillList(self, "Hammer_Attack");
    AddLimitationSkillList(self, "Magic_Attack");
    AddLimitationSkillList(self, "Normal_Attack_TH");
    AddLimitationSkillList(self, "Magic_Attack_TH");
    AddLimitationSkillList(self, "CrossBow_Attack");
    AddLimitationSkillList(self, "Pistol_Attack");
    AddLimitationSkillList(self, "Musket_Attack");
    AddLimitationSkillList(self, "Peltasta_SwashBuckling");
    AddLimitationSkillList(self, "Common_DaggerAries");
    AddLimitationSkillList(self, "Common_StaffAttack");
    AddLimitationSkillList(self, "RuneCaster_Hagalaz");
    AddLimitationSkillList(self, "RuneCaster_Isa");
    AddLimitationSkillList(self, "RuneCaster_Thurisaz");
    AddLimitationSkillList(self, "RuneCaster_Tiwaz");
    AddLimitationSkillList(self, "RuneCaster_Algiz");
    AddLimitationSkillList(self, "Wizard_EnergyBolt");
    AddLimitationSkillList(self, "Wizard_Lethargy");
    AddLimitationSkillList(self, "Wizard_Sleep");
    AddLimitationSkillList(self, "Wizard_ReflectShield");
    AddLimitationSkillList(self, "Wizard_EarthQuake");
    AddLimitationSkillList(self, "Wizard_Surespell");
    AddLimitationSkillList(self, "Wizard_MagicMissile");
    AddLimitationSkillList(self, "Wizard_QuickCast");
    AddLimitationSkillList(self, "LightningHands_Attack");
end

function SCR_BUFF_UPDATE_Thurisaz_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    
    if IsOnGround(self) == "NO" then
        SetExProp(self, "JUMP_STATE", 1)
    end
    if GetExProp(self, "JUMP_STATE") == 1 and IsOnGround(self) == "YES" then
        SetExProp(self, "JUMP_STATE", 0)
        PlaySound(self, "skl_eff_thurisaz_landing")

        local x, y, z = GetPos(self)
        local skill = GetNormalSkill(self);
        if skill == nil then
            return 1;
        end

        local list, cnt = SelectObjectPos(self, x, y, z, 30, 'ENEMY');
        for i = 1, cnt do
            local target = list[i];
            local damage = SCR_LIB_ATKCALC_RH(self, skill);
            TakeDamage(self, target, skill.ClassName, damage);
            --local angle = GetAngleFromPos(target, x, z);
            --KnockDown(target, target, 30, angle, 45.0, 2, 1, 1);
        end
    end

    return 1;
    
end

function SCR_BUFF_LEAVE_Thurisaz_Buff(self, buff, arg1, arg2, over)
    local Aspersion_Buff = GetBuffByName(self, 'Aspersion_Buff')
    local AspersionArg1, AspersionArg2, AspersionRemainTime = 0, 0, 0;
    local AspersionCaster = nil;
    if nil ~= Aspersion_Buff then
        AspersionArg1, AspersionArg2 = GetBuffArg(Aspersion_Buff);
        AspersionRemainTime = GetBuffRemainTime(Aspersion_Buff);
        caster = GetBuffCaster(Aspersion_Buff);
    end

    RemoveBuff(self, 'Aspersion_Buff')

    ChangeScalePC(self, 1/2, 0)
    local defadd = GetExProp(buff, "ADD_DEF")
    local mhpadd = GetExProp(buff, "ADD_MHP")
    local mspdadd = GetExProp(buff, "ADD_MSPD")
    local mdefadd = GetExProp(buff, "ADD_MDEF")
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd
    self.MHP_BM = self.MHP_BM - mhpadd
    self.MSPD_BM = self.MSPD_BM - mspdadd
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - mdefadd
    self.Size = "M";
    ClearLimitationSkillList(self);
    
    if nil ~= Aspersion_Buff then
        AddBuff(AspersionCaster, self, 'Aspersion_Buff', AspersionArg1, AspersionArg2, AspersionRemainTime, 1);
    end
end



function SCR_BUFF_ENTER_Algiz_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_Algiz_Buff(self, buff, arg1, arg2, over)

end




function SCR_BUFF_ENTER_Wizard_Fog_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_Wizard_Fog_Debuff(self, buff, arg1, arg2, over)


    local random = IMCRandom(1,100);
    if 90 >= random then    

        if self.MonRank ~= 'Boss' then
            if IsBuffApplied(self, 'Confuse') == 'NO' then              

                AddBuff( GetBuffCaster(buff), self, 'Confuse', 1, 0, 10000, 1);
            end
        end
    end

    return 1;  
end

function SCR_BUFF_LEAVE_Wizard_Fog_Debuff(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_MagneticForce_Debuff_Hold(self, buff, arg1, arg2, over)
	if IS_PC(self) == true then
    	EnableControl(self, 0, "MAGNETIC_MOVE_LOCK");
    end
end

function SCR_BUFF_LEAVE_MagneticForce_Debuff_Hold(self, buff, arg1, arg2, over)    
    local caster = GetBuffCaster(buff);    
    if caster ~= nil then
        if(GetExProp(self, "diminishing_magneticForce") == 1) then
            SetExProp(self, "diminishing_magneticForce", 0)            
            local remainingTime = GetExProp(self, "diminishing_magneticForce_remainingTime")            
            if remainingTime ~= 0 then                
                AddBuff(self, self, "MagneticForceTemporaryImmune", 1, 1, remainingTime, 1)
            end            
        end
    end
	
	if IS_PC(self) == true then
    	EnableControl(self, 1, "MAGNETIC_MOVE_LOCK");
    end
end


function SCR_BUFF_ENTER_Camouflage_Buff(self, buff, arg1, arg2, over)
    
    local lv = arg1;

    --self.Runnable = self.Runnable - 1;
         self.Jumpable = self.Jumpable - 1;
    
    --ObjectColorBlend(self, 100, 100, 100, 0, 1)
    
    SKL_HATE_RESET(self);
    
    local spdrate = 1 - (arg1 * 0.1)
    local mspdadd = math.max(30 * spdrate, self.MSPD * spdrate)

    self.MSPD_BM = self.MSPD_BM - mspdadd;
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
    SetExProp(self, "IGNORE_MELEE_ATK", lv * 5);

    AddLimitationSkillList(self, "Scout_Camouflage");
    AddLimitationSkillList(self, "Bow_Attack");
    AddLimitationSkillList(self, "CrossBow_Attack");
    AddLimitationSkillList(self, "Pistol_Attack");
    AddLimitationSkillList(self, "Scout_Undistance");
    
end

function SCR_BUFF_LEAVE_Camouflage_Buff(self, buff, arg1, arg2, over)

   --ObjectColorBlend(self, 255, 255, 255, 255, 1)
    
    --PlayAnim(self, "archer_f_thb_unhide");
    
    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM + mspdadd;
    
    --self.Runnable = self.Runnable + 1;
    self.Jumpable = self.Jumpable + 1;
    
    ClearLimitationSkillList(self);

    local skillObj = GetSkill(GetBuffCaster(buff), 'Scout_Camouflage');
    if skillObj ~= nil then
        SKL_TOGGLE_ON(self, skillObj, 0);
    end
    DetachClientNodeMonster(self, "skill_HideBox", "Dummy_HideBox");

end

-- Undistance_Buff
function SCR_BUFF_ENTER_Undistance_Buff(self, buff, arg1, arg2, over)
    local patkadd = 0
    local caster = GetBuffCaster(buff)
    if caster ~= nil then
        local abil = GetAbility(caster, 'Scout3')
        if abil ~= nil then
            patkadd = abil.Level * 0.05
        end
    end
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + patkadd;
    SetExProp(buff, "ADD_PATK", patkadd)
end

function SCR_BUFF_LEAVE_Undistance_Buff(self, buff, arg1, arg2, over)
    local patkadd = GetExProp(buff, "ADD_PATK")
    self.PATK_RATE_BM = self.PATK_RATE_BM - patkadd;
end


function SCR_BUFF_ENTER_OOBE_Debuff(self, buff, arg1, arg2, over)

    local defadd = self.DEF
    local dradd = 0
    
    local abil = GetAbility(self, "Sadhu2")
    if abil ~= nil then
        dradd = abil.Level * 10
    end
    
    self.DEF_BM = self.DEF_BM - defadd
    self.DR_BM = self.DR_BM + dradd
    
    SetExProp(buff, "ADD_DEFADD", defadd);
    SetExProp(buff, "ADD_DR", dradd);
    
    self.Jumpable = self.Jumpable - 1;
    
    AddLockSkillList(self, 'Pardoner_Simony');
    AddLockSkillList(self, 'Pardoner_SpellShop');
    AddLockSkillList(self, 'Pardoner_Oblation');
    AddLockSkillList(self, 'Druid_Telepath');
    AddLockSkillList(self, 'Druid_ShapeShifting');
    AddLockSkillList(self, 'Druid_Transform');
    
end

function SCR_BUFF_LEAVE_OOBE_Debuff(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEFADD");
    local dradd = GetExProp(buff, "ADD_DR");
    
    self.DEF_BM = self.DEF_BM + defadd
    self.DR_BM = self.DR_BM - dradd
    
    self.Jumpable = self.Jumpable + 1;
    
    ClearLimitationSkillList(self);
end









-- Raid_buff_atk
function SCR_BUFF_ENTER_Raid_buff_atk(self, buff, arg1, arg2, over)
    local lv = over;

    local atkadd = self.MAXMATK * (0.2 + lv * 0.01);

    self.MATK_BM = self.MATK_BM + atkadd;

    SetExProp(buff, "ADD_MINMATK", atkadd);

end

function SCR_BUFF_LEAVE_Raid_buff_atk(self, buff, arg1, arg2, over)

    local atkadd = GetExProp(buff, "ADD_MINMATK");

    self.MATK_BM = self.MATK_BM - atkadd;

end


function SCR_BUFF_ENTER_Coursing_Debuff(self, buff, arg1, arg2, over)    
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local sklLevel = 1;
    local pet = GetBuffCaster(buff);
    local caster = GetOwner(pet)
    if caster ~= nil then
        local skl = GetSkill(caster, "Hunter_Coursing");
        if skl ~= nil then
            sklLevel = skl.Level;
        end
    end
    local defaultdef = 0.05
    local defBySkillLv = 0.005 * sklLevel
    local defadd = defaultdef + defBySkillLv

    local mdefadd = 0
    local pet = GetBuffCaster(buff);
    local caster = GetOwner(pet)
    if caster ~= nil then
        local abil = GetAbility(caster, "Hunter7")
        if abil ~= nil then
            mdefadd = 0.02 * abil.Level;
        end
    end

    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - mdefadd;
    
    SetExProp(buff, "ADD_DEF", defadd);
    SetExProp(buff, "ADD_MDEF", mdefadd);

end

function SCR_BUFF_UPDATE_Coursing_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local pet = GetBuffCaster(buff);
    local caster = GetOwner(pet)
    if caster ~= nil then
        local damage = GET_SKL_DAMAGE(caster, self, 'Hunter_Coursing');
        local skill = GET_MON_SKILL(caster, 'Hunter_Coursing');
        local notApplyDiminishing = 1
        TAKE_SCP_DAMAGE(caster, self, damage, HIT_BASIC, HITRESULT_BLOW, 0, skill.ClassName, 1, 4, nil, pet, notApplyDiminishing);
    end
       
    return 1;
end

function SCR_BUFF_LEAVE_Coursing_Debuff(self, buff, arg1, arg2, over)    
    local defadd = GetExProp(buff, "ADD_DEF");
    local mdefadd = GetExProp(buff, "ADD_MDEF");
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + mdefadd;

end



function SCR_BUFF_ENTER_TransmitPrana_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_TransmitPrana_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_ENTER_TransmitPrana_Buff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil and IsSameActor(caster, self) == "NO" then
        local casterINT = caster.INT - caster.INT_BM;
        local casterSTR = caster.STR - caster.STR_BM;
        local casterCON = caster.CON - caster.CON_BM;
        local casterMNA = caster.MNA - caster.MNA_BM;
        local casterDEX = caster.DEX - caster.DEX_BM;
        
        local intadd = math.floor(casterINT * (arg1 * 0.1))
        local stradd = math.floor(casterSTR * (arg1 * 0.1))
        local conadd = math.floor(casterCON * (arg1 * 0.1))
        local mnaadd = math.floor(casterMNA * (arg1 * 0.1))
        local dexadd = math.floor(casterDEX * (arg1 * 0.1))
        
        self.INT_BM = math.floor(self.INT_BM + intadd);
        SetExProp(buff, "ADD_INT", intadd);
        
        local Sadhu19_abil = GetAbility(caster, 'Sadhu19');
        if Sadhu19_abil ~= nil then
            self.STR_BM = self.STR_BM + stradd
            SetExProp(buff, "ADD_STR", stradd);
        end
        
        local Sadhu20_abil = GetAbility(caster, 'Sadhu20');
        if Sadhu20_abil ~= nil then
            self.CON_BM = self.CON_BM + conadd
            SetExProp(buff, "ADD_CON", conadd);
        end
        
        local Sadhu21_abil = GetAbility(caster, 'Sadhu21');
        if Sadhu21_abil ~= nil then
            self.MNA_BM = self.MNA_BM + mnaadd
            SetExProp(buff, "ADD_MNA", mnaadd);
        end
        
        local Sadhu22_abil = GetAbility(caster, 'Sadhu22');
        if Sadhu22_abil ~= nil then
            self.DEX_BM = self.DEX_BM + dexadd
            SetExProp(buff, "ADD_DEX", dexadd);
        end
--        AddBuff(self, caster, "TransmitPrana_Debuff", arg1, arg2, 0)
    end
end

function SCR_BUFF_LEAVE_TransmitPrana_Buff(self, buff, arg1, arg2, over)

--    local caster = GetBuffCaster(buff);
    local intadd = GetExProp(buff, "ADD_INT")
    local stradd = GetExProp(buff, "ADD_STR")
    local conadd = GetExProp(buff, "ADD_CON")
    local mnaadd = GetExProp(buff, "ADD_MNA")
    local dexadd = GetExProp(buff, "ADD_DEX")
    
    self.INT_BM = self.INT_BM - intadd
    
    if stradd ~= nil then
        self.STR_BM = self.STR_BM - stradd;
    end
    
    if conadd ~= nil then
        self.CON_BM = self.CON_BM - conadd
    end
    
    if mnaadd ~= nil then
        self.MNA_BM = self.MNA_BM - mnaadd
    end
    
    if dexadd ~= nil then
        self.DEX_BM = self.DEX_BM - dexadd
    end

--    RemoveBuffByCaster(caster, self, "TransmitPrana_Debuff");
end


function SCR_BUFF_ENTER_AstralBodyExplosion_Debuff(self, buff, arg1, arg2, over)
    local lv = arg1;
    local explosionDamage = arg2;
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local skill = GetSkill(caster, "Sadhu_AstralBodyExplosion");
        if skill ~= nil then
            lv = skill.Level;
        end
    end
    
    local damage = explosionDamage * (0.05 + (lv - 1) * 0.003);
    damage = math.floor(damage);
    SetBuffArgs(buff, damage, 0, 0);
end

function SCR_BUFF_UPDATE_AstralBodyExplosion_Debuff(self, buff, arg1, arg2, over)
    local damage = GetBuffArgs(buff);
    if damage <= 0 then
        return 0;
    end
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        return 0;
    end
    
    TakeDamage(caster, self, "None", damage, "Soul", "Magic", "TrueDamage", HIT_SOUL, HITRESULT_BLOW);
    return 1;
end

function SCR_BUFF_LEAVE_AstralBodyExplosion_Debuff(self, buff, arg1, arg2, over)
    
end



function SCR_BUFF_ENTER_Suppress_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local lv = arg1;
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
        
    end
    
    local stradd = lv * 5;
    local conadd = lv * 5;
    local intadd = lv * 5;
    local mnaadd = lv * 5;
    local dexadd = lv * 5;
    
    self.STR_BM = self.STR_BM - stradd
    self.CON_BM = self.CON_BM - conadd
    self.INT_BM = self.INT_BM - intadd
    self.MNA_BM = self.MNA_BM - mnaadd
    self.DEX_BM = self.DEX_BM - dexadd
    
    SetExProp(buff, "ADD_STR", stradd);
    SetExProp(buff, "ADD_CON", conadd);
    SetExProp(buff, "ADD_INT", intadd);
    SetExProp(buff, "ADD_MNA", mnaadd);
    SetExProp(buff, "ADD_DEX", dexadd);
end

function SCR_BUFF_LEAVE_Suppress_Debuff(self, buff, arg1, arg2, over)
    local stradd = GetExProp(buff, "ADD_STR");
    local conadd = GetExProp(buff, "ADD_CON");
    local intadd = GetExProp(buff, "ADD_INT");
    local mnaadd = GetExProp(buff, "ADD_MNA");
    local dexadd = GetExProp(buff, "ADD_DEX");
    
    self.STR_BM = self.STR_BM + stradd
    self.CON_BM = self.CON_BM + conadd
    self.INT_BM = self.INT_BM + intadd
    self.MNA_BM = self.MNA_BM + mnaadd
    self.DEX_BM = self.DEX_BM + dexadd
end

function SCR_BUFF_ENTER_Suppress_Confuse_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local skill = GetSkill(caster, "Sadhu_VashitaSiddhi")
        if skill == nil then
            return
        end
        
        local abil = GetAbility(caster, "Sadhu7")
        if abil ~= nil and skill.Level >= 3 and IMCRandom(1, 9999) < abil.Level * 200 then
            AddBuff(caster, self, "Confuse", 1, 0, 5000, 1);
        end
    end
end

function SCR_BUFF_LEAVE_Suppress_Confuse_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_SadhuBind_Debuff(self, buff, arg1, arg2, over)
  --SkillTextEffect(ret, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

end

function SCR_BUFF_LEAVE_SadhuBind_Debuff(self, buff, arg1, arg2, over)
   AddBuff(self, self, 'SadhuPossessionTemporaryImmune', 1, 0, 6500, 1);
end


function SCR_BUFF_ENTER_Raid_buff_def(self, buff, arg1, arg2, over)

    local defadd = over * 5
  
    self.DEF_BM = self.DEF_BM + defadd

    SetExProp(buff, "ADD_DEF", defadd);

end

function SCR_BUFF_LEAVE_Raid_buff_def(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");

    self.DEF_BM = self.DEF_BM - defadd;

end


function SCR_BUFF_ENTER_Double_pay_earn_Buff(self, buff, arg1, arg2, over)
    SetExProp(self, "DoublePayEarn", arg1)
end

function SCR_BUFF_LEAVE_Double_pay_earn_Buff(self, buff, arg1, arg2, over)
end


-- Crown_Buff
function SCR_BUFF_ENTER_Crown_Buff(self, buff, arg1, arg2, over)
SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
  --  ShowEmoticon(self, 'I_emo_lmpact', 0)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff; 
    end
    
    local intadd = math.floor((self.INT - self.INT_BM) * 0.5)
    local mnaadd = math.floor((self.MNA - self.MNA_BM) * 0.5)
    
    local Highlander4_abil = GetAbility(caster, 'Highlander4');
    
    if Highlander4_abil ~= nil then
        intadd = intadd + math.floor((self.INT - self.INT_BM) * (0.02 * Highlander4_abil.Level))
        mnaadd = mnaadd + math.floor((self.MNA - self.MNA_BM) * (0.02 * Highlander4_abil.Level))
    end

    self.INT_BM = self.INT_BM - intadd;
    self.MNA_BM = self.MNA_BM - mnaadd;

    SetExProp(buff, "ADD_INT", intadd);
    SetExProp(buff, "ADD_MNA", mnaadd);

end

function SCR_BUFF_LEAVE_Crown_Buff(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_lmpact')

    local intadd = GetExProp(buff, "ADD_INT");
    local mnaadd = GetExProp(buff, "ADD_MNA");
    
    self.INT_BM = self.INT_BM + intadd;
    self.MNA_BM = self.MNA_BM + mnaadd;

end

function GetDefAdd(self, arg1)
--    local defadd = 10 + (arg1-1) * 2.3
    local defadd = self.DEF * 0.1
    return math.floor(defadd);
end

function SCR_BUFF_ENTER_Warcry_Buff(self, buff, arg1, arg2, over)
    PlaySound(self, "skl_eff_warcry_up") 
    local Defsum = 0;
    local objList, objCount = SelectObject(self, 100, 'ENEMY');

    if objCount > 5 then
        local maxCount = 5;

        local abil = GetAbility(self, 'Barbarian1')
        if abil ~= nil then
            maxCount = maxCount + abil.Level;
        end

        objCount = math.min(objCount, maxCount);
    end
    
    for i = 1, objCount do
        local obj = objList[i];
        local defadd = GetDefAdd(obj, arg1)
        if defadd > obj.DEF then
            defadd = obj.DEF
        end
        
        Defsum = math.floor(Defsum + defadd);
        AddBuff(self, obj, 'Warcry_Debuff', 0, defadd, GetBuffRemainTime(buff), 1)
        
--        if IsBuffApplied(obj, 'Warcry_Debuff') then
--            local lv = obj.Level;
--        end
--        lv = math.min(obj.Level);
    end
    
--    local atkadd = Defsum + lv * objCount* 0.1;
--    local atkrate = 0.05 * objCount
    local atkadd = (arg1 * 4) * objCount
    local abilAtk = 1
    
    local Barbarian12_abil = GetAbility(self, "Barbarian12")    -- 2rank Skill Damage multiple
    local Barbarian13_abil = GetAbility(self, "Barbarian13")    -- 3rank Skill Damage multiple
    if Barbarian13_abil ~= nil then
        atkadd = atkadd * 2.26
    elseif Barbarian13_abil == nil and Barbarian12_abil ~= nil then
        atkadd = atkadd * 1.57
    end
    
    local skill = GetSkill(self, "Barbarian_Warcry")
    if skill == nil then
        return
    end
    
    local Barbarian11_abil = GetAbility(self, "Barbarian11")    -- Skill Damage add
    if Barbarian11_abil ~= nil and skill.Level >= 3 then
        abilAtk = 1 + Barbarian11_abil.Level * 0.01;
    end
    
    atkadd = atkadd * abilAtk;
    atkadd = math.floor(atkadd);
    
    self.PATK_BM = self.PATK_BM + atkadd
    SetExProp(buff, "ADD_ATK", atkadd);
--    SetExProp(buff, "ADD_ATK_RATE", atkrate);
    
end

function SCR_BUFF_LEAVE_Warcry_Buff(self, buff, arg1, arg2, over)

    --local defadd = GetExProp(buff, "ADD_DEF");
    local atkadd = GetExProp(buff, "ADD_ATK");
--    local atkrate = GetExProp(buff, "ADD_ATK_RATE")
    self.PATK_BM = self.PATK_BM - atkadd
--    self.PATK_RATE_BM = self.PATK_RATE_BM - atkrate
    --self.DEF_BM = self.DEF_BM + defadd


end


function SCR_BUFF_ENTER_Warcry_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    --ShowEmoticon(self, 'I_emo_deprotect', 0)
    
    local defadd = 0.1
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd
    SetExProp(buff, "ADD_DEF", defadd);
    
    if GetBuffByProp(self, 'Group1', 'Debuff') then
        local caster = GetBuffCaster(buff);
        if caster ~= nil then
            local abil = GetAbility(caster, 'Barbarian30')
            if abil ~= nil then
                local buff_list, buff_cnt = GetBuffList(self)
                if buff_cnt >= 1 then
                    for i = 1, buff_cnt do
                        if buff_list[i].Group1 == 'Debuff' then
                            local debuff = buff_list[i];
                            local caster_debuff = GetBuffCaster(debuff);
                            if caster_debuff ~= nil then
                                if IsSameActor(caster, caster_debuff) == "YES" then
                                    local buffTime = GetBuffRemainTime(debuff)
                                    local abil_time = 1000 * abil.Level;
                                    if IsPVPServer(self) == 1 then
                                        abil_time = math.floor(abil_time / 3)
                                    end
                                    SetBuffRemainTime(self, debuff.ClassName, buffTime + abil_time);
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function SCR_BUFF_LEAVE_Warcry_Debuff(self, buff, arg1, arg2, over)

    --HideEmoticon(self, 'I_emo_deprotect')

    local defadd = GetExProp(buff, "ADD_DEF");
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd

end


function SCR_BUFF_ENTER_SpDrain_Buff(self, buff, arg1, arg2, over)

    local debuff = GetBuffByProp(self, 'Group1', 'Debuff');
    if debuff ~= nil then
            RemoveBuff(self, debuff.ClassName)
  end


end

function SCR_BUFF_LEAVE_SpDrain_Buff(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_SpDrain_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_SpDrain_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

  AddSP(self, -50)
    return 1;

end

function SCR_BUFF_LEAVE_SpDrain_Debuff(self, buff, arg1, arg2, over)

end

-- SwellBody_Debuff
function SCR_BUFF_ENTER_SwellBody_Debuff(self, buff, arg1, arg2, over)
    local hpadd = self.MHP
    
    self.MHP_BM = self.MHP_BM + hpadd
    
    local addmspd = 0;
    local addpatk = 0;
    local addmatk = 0;
    
    SetExProp(self, "ADD_HP", hpadd);

    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local caster = GetBuffCaster(buff);

    if GetExProp(self, "ReSizeFlag") ~= 1 then
        SetExProp_Str(self, "DefaultSize", self.Size)
        SetExProp(self, "ReSizeFlag", 1)
    end

    if IsBuffApplied(self, 'ShrinkBody_Debuff') == 'YES' then
        RemoveBuff(self, 'ShrinkBody_Debuff')
    end
    
    local Thaumaturge1_abil = GetAbility(caster, 'Thaumaturge1');
    if Thaumaturge1_abil ~= nil and IS_PC(self) == false then
        addmspd = math.floor((self.MSPD * (Thaumaturge1_abil.Level * 0.15)))
        addpatk = Thaumaturge1_abil.Level * 0.1
        addmatk = Thaumaturge1_abil.Level * 0.1
        
        self.MSPD_BM = self.MSPD_BM - addmspd;
        self.PATK_RATE_BM = self.PATK_RATE_BM + addpatk;
        self.MATK_RATE_BM = self.MATK_RATE_BM + addmatk;
        
        SetExProp(buff, "ADD_MSPD", addmspd);
        SetExProp(buff, "ADD_PATK", addpatk);
        SetExProp(buff, "ADD_MATK", addmatk);
    end
    
    if  self.Size == 'L' then
--      local abil = GetAbility(caster, 'Thaumaturge3');
--      if abil == nil then
--          local ratio = 20 
--          if ratio >= IMCRandom(1, 100) then
--
--              SetExProp(self, "Kill", 1)
--              RunScript('SCR_SYNC_RESIZE', self, 2.0)
--          end 
--      else
--          --local dmg = (SCR_Get_MAXPATK(caster) * 0.1) * abil.Level
--          --TakeDamage(caster, self, "None", dmg);
--      end 
    elseif self.Size == 'M' then
        local Thaumaturge3_abil = GetAbility(caster, 'Thaumaturge3');
        if Thaumaturge3_abil ~= nil then
            local dmg = caster.MAXMATK * 0.2 * Thaumaturge3_abil.Level
            TakeDamage(caster, self, "None", dmg, "None", "None", "TrueDamage");
        end
        
        local remaintime = GetBuffRemainTime(buff)
        self.Size = 'L'
        RunScript('SCR_SYNC_RESIZE', self, 3/2)
    elseif self.Size == 'S' then
        local Thaumaturge3_abil = GetAbility(caster, 'Thaumaturge3');
        if Thaumaturge3_abil ~= nil then
            local dmg = caster.MAXMATK * 0.2 * Thaumaturge3_abil.Level
            TakeDamage(caster, self, "None", dmg, "None", "None", "TrueDamage");
        end     
        local remaintime = GetBuffRemainTime(buff)
        self.Size = 'M'
        RunScript('SCR_SYNC_RESIZE', self, 3/2)
    end
end

function SCR_BUFF_LEAVE_SwellBody_Debuff(self, buff, arg1, arg2, over)


    local hpadd = GetExProp(self, "ADD_HP");
    self.MHP_BM = self.MHP_BM - hpadd
    
    self.MSPD_BM = self.MSPD_BM + GetExProp(buff, "ADD_MSPD")
    self.PATK_RATE_BM = self.PATK_RATE_BM - GetExProp(buff, "ADD_PATK")
    self.MATK_RATE_BM = self.MATK_RATE_BM - GetExProp(buff, "ADD_MATK") 
    
    if GetBuffRemainTime(buff) > 0 then
        return 1
    end
    if GetBuffRemainTime(buff) < 0 then
        local default = GetExProp_Str(self, "DefaultSize")
        if default == 'S' then
            if self.Size == 'M' then
                ChangeScale(self, 2/3, 0.2)
            elseif self.Size == 'L' then
                ChangeScale(self, 4/9, 0.2)
            end
            self.Size = default;
        elseif default == 'M' then
            if self.Size == 'L' then
                ChangeScale(self, 2/3, 0.2)
            end
            self.Size = default;
        elseif default == 'L' then
            if self.Size == 'M' then
                ChangeScale(self, 3/2, 0.2)
            elseif self.Size == 'S' then
                ChangeScale(self, 9/4, 0.2)
            end
            self.Size = default;
        end
    end
    
    DelExProp(self, "ReSizeFlag") 
    DelExProp(self, 'ReSize')
end

-- ShrinkBody_Debuff
function SCR_BUFF_ENTER_ShrinkBody_Debuff(self, buff, arg1, arg2, over)

  SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local caster = GetBuffCaster(buff);
    if GetExProp(self, "ReSizeFlag") ~= 1 then
        SetExProp_Str(self, "DefaultSize", self.Size)
        SetExProp(self, "ReSizeFlag", 1)
    end
    
    local addmspd = 0;
    local addpatk = 0;
    local addmatk = 0;
    
    if IsBuffApplied(self, 'SwellBody_Debuff') == 'YES' then
        RemoveBuff(self, 'SwellBody_Debuff')
    end
    
    Thaumaturge2_abil = GetAbility(caster, 'Thaumaturge2');
    if Thaumaturge2_abil ~= nil and IS_PC(self) == false then
        addmspd = math.floor((self.MSPD * (Thaumaturge2_abil.Level * 0.1)))
        addpatk = Thaumaturge2_abil.Level * 0.15
        addmatk = Thaumaturge2_abil.Level * 0.15
        
        self.MSPD_BM = self.MSPD_BM + addmspd;
        self.PATK_RATE_BM = self.PATK_RATE_BM - addpatk;
        self.MATK_RATE_BM = self.MATK_RATE_BM - addmatk;
        
        SetExProp(buff, "ADD_MSPD", addmspd);
        SetExProp(buff, "ADD_PATK", addpatk);
        SetExProp(buff, "ADD_MATK", addmatk);
    end
    
    if self.Size == 'L' then
        local Thaumaturge4_abil = GetAbility(caster, 'Thaumaturge4');
        if Thaumaturge4_abil ~= nil then
            local dmg = caster.MAXMATK * 0.2 * Thaumaturge4_abil.Level
            TakeDamage(caster, self, "None", dmg, "None", "None", "TrueDamage");
        end
        local remaintime = GetBuffRemainTime(buff)
        self.Size = 'M'
        RunScript('SCR_SYNC_RESIZE', self, 2/3)
    elseif self.Size == 'M' or GetObjType(self) == OT_PC then 
        local Thaumaturge4_abil = GetAbility(caster, 'Thaumaturge4');
        if Thaumaturge4_abil ~= nil then
            local dmg = caster.MAXMATK * 0.2 * Thaumaturge4_abil.Level
            TakeDamage(caster, self, "None", dmg, "None", "None", "TrueDamage");
        end

        self.Size = 'S'
        RunScript('SCR_SYNC_RESIZE', self, 2/3)
    elseif GetExProp_Str(self, "ReSize") == 'S' or self.Size == 'S' then
        
--      local abil = GetAbility(caster, 'Thaumaturge4');
--  
--      if abil == nil then
--          --ChangeScale(self, 1/2, 0.2)
--          local ratio = 20
--          if ratio >= IMCRandom(1, 100) then 
--              SetExProp(self, "Kill", 1)
--              RunScript('SCR_SYNC_RESIZE', self, 1/2)
--              --Dead(self)
--              --PlayEffect(self, 'F_buff_explosion_burst');
--          end 
--      end
    end
end

function SCR_BUFF_LEAVE_ShrinkBody_Debuff(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - GetExProp(buff, "ADD_MSPD")
    self.PATK_RATE_BM = self.PATK_RATE_BM + GetExProp(buff, "ADD_PATK")
    self.MATK_RATE_BM = self.MATK_RATE_BM + GetExProp(buff, "ADD_MATK")
    
    if GetBuffRemainTime(buff) > 0 then
        return 1
    end
    if GetBuffRemainTime(buff) < 0 then
        local default = GetExProp_Str(self, "DefaultSize") 
        if default == 'L' then
            if self.Size == 'M' then
                ChangeScale(self, 3/2, 0.2)
            elseif self.Size == 'S' then
                ChangeScale(self, 9/4, 0.2)
            end
            self.Size = default;
        elseif default == 'M' or GetObjType(self) == OP_PC then
            if self.Size == 'S' then
                ChangeScale(self, 3/2, 0.2)
            end
            self.Size = default;
        elseif default == 'S' then
            if self.Size == 'M' then
                ChangeScale(self, 2/3, 0.2)
            elseif self.Size == 'L' then
                ChangeScale(self, 4/9, 0.2)
            end
            self.Size = default;
        end
    end
    
    DelExProp(self, "ReSizeFlag") 
    DelExProp(self, 'ReSize')

end


-- IceBlast_Debuff
function SCR_BUFF_ENTER_IceBlast_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    local damage = GET_SKL_DAMAGE(caster, self, 'Cryomancer_IceBlast');
    local skill = GET_MON_SKILL(caster, 'Cryomancer_IceBlast'); 
    
    
    if self.ClassName == 'pcskill_icewall' then
--        local x, y, z = GetPos(self)
--        UseMonsterSkillToGround(self, 'Mon_pcskill_icewall_Skill_2', x, y, z)
        TakeDamage(caster, self, skill.ClassName, damage, "Ice", "Magic", "Magic", HIT_ICE, HITRESULT_BLOW);
--      PlayEffect(self, 'F_spread_out018_ground', 0.4);
    else
        if GetBuffByProp(self, 'Group1', 'Debuff') ~= nil then
            if GetBuffByProp(self, 'Keyword', 'Freeze') ~= nil then
                local Cryomancer8_abil = GetAbility(caster, "Cryomancer8")
                if Cryomancer8_abil ~= nil then
                    SetExProp(self, "ADD_ICEBLAST_DAMAGE", Cryomancer8_abil.Level * 10)
                else
                    DelExProp(target, 'ADD_ICEBLAST_DAMAGE')
                end
            
                TakeDamage(caster, self, skill.ClassName, damage, "Ice", "Magic", "Magic", HIT_ICE, HITRESULT_BLOW);
                PlayEffect(self, 'F_spread_out018_ground', 0.4);
                if IMCRandom(1,100) < 50 then
                    RemoveBuffKeyword(self, 'Debuff', 'Freeze', 99, 99)
                end
                --SetExProp(self, "IS_ICEBLAST_HIT", 1)
            end
        end
    end
end

function SCR_BUFF_LEAVE_IceBlast_Debuff(self, buff, arg1, arg2, over)
    --DelExProp(self, "IS_ICEBLAST_HIT")
    DelExProp(self, "ADD_ICEBLAST_DAMAGE")
end

-- Flare_Debuff
function SCR_BUFF_ENTER_Flare_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    if GetBuffByProp(self, 'Group1', 'Debuff') ~= nil then
        if GetBuffByProp(self, 'Group2', 'Fire') ~= nil then
            local damage = GET_SKL_DAMAGE(caster, self, 'Pyromancer_Flare');
            local skill = GET_MON_SKILL(caster, 'Pyromancer_Flare');
            
            local Pyromancer9_abil = GetAbility(caster, "Pyromancer9")
            if Pyromancer9_abil ~= nil then
                SetExProp(self, "ADD_FLARE_DAMAGE", Pyromancer9_abil.Level * 10)
            end
            
            TakeDamage(caster, self, skill.ClassName, damage, "Fire", "Magic", "Magic", HIT_FIRE, HITRESULT_BLOW);
        end
    end
end

function SCR_BUFF_LEAVE_Flare_Debuff(self, buff, arg1, arg2, over)
    DelExProp(self, "ADD_FLARE_DAMAGE")
end


-- Transpose_Buff
function SCR_BUFF_ENTER_Transpose_Buff(self, buff, arg1, arg2, over)
    RemoveBuff(self, 'Link_Sacrifice')
    RemoveBuff(self, 'ShieldBash_Debuff')

    local beforeCon = self.CON;
    local beforeInt = self.INT;
    
    SetExProp(buff, 'BEFORE_CON', beforeCon);
    SetExProp(buff, 'BEFORE_INT', beforeInt);

    local afterCon = self.INT;
    local afterInt = self.CON;

    local caster = GetBuffCaster(buff)
    local abil = GetAbility(caster, "Thaumaturge9")
    if abil ~= nil then
        afterCon = (beforeCon + beforeInt) / 2
        afterInt = (beforeCon + beforeInt) / 2
    end
    
    SetExProp(buff, 'AFTER_CON', afterCon);
    SetExProp(buff, 'AFTER_INT', afterInt);

    self.CON_BM = self.CON_BM - beforeCon + afterCon;
    self.INT_BM = self.INT_BM - beforeInt + afterInt;
        
    --SetExProp(self, "ORIGINAL_HP", self.HP);
    --local hp = GetExProp(self, "CURRENT_HP");
    --local originalHP = GetExProp(self, "ORIGINAL_HP");
    --print(self.MHP, hp, originalHP)
    --if self.MHP < hp then
    --    local healHP = hp - self.MHP
    --    InvalidateStates(self);
    --    AddHP(self, healHP);
    --end
    --print(self.HP)
    
end

function SCR_BUFF_LEAVE_Transpose_Buff(self, buff, arg1, arg2, over)
    --print(GetBuffRemainTime(buff))
    --print(GetExProp(self, "CURRENT_HP"), GetExProp(self, "ORIGINAL_MHP"))
    --SetExProp(self, "CURRENT_HP", self.HP);
    
    local beforeCon = GetExProp(buff, 'BEFORE_CON');
    local beforeInt = GetExProp(buff, 'BEFORE_INT');
    local afterCon = GetExProp(buff, 'AFTER_CON');
    local afterInt = GetExProp(buff, 'AFTER_INT');
    
    self.CON_BM = self.CON_BM - afterCon + beforeCon;
    self.INT_BM = self.INT_BM - afterInt + beforeInt;

end



-- Raid_buff_spd
function SCR_BUFF_ENTER_Raid_buff_spd(self, buff, arg1, arg2, over)

    local lv = over;

    local mspdadd = self.MSPD * (lv * 0.1);
    
    --AddStamina(self, 3000);
    
    self.MSPD_BM = self.MSPD_BM + mspdadd;
--  print(self.MSPD_BM)
    SetExProp(buff, "ADD_MSPD", mspdadd);
    

end

function SCR_BUFF_LEAVE_Raid_buff_spd(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");

    self.MSPD_BM = self.MSPD_BM - mspdadd;

end


-- CountDown
function SCR_BUFF_ENTER_Wizard_CountDown_Debuff(self, buff, arg1, arg2, over)

    SetExProp(buff, 'CountDown_CheckTime', GetUseSkillStartTime(self));
    SetExProp(buff, 'CountDown_INDEX', 0);

    --print('start', GetUseSkillStartTime(self))
end

function SCR_BUFF_UPDATE_Wizard_CountDown_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local prevTime = GetExProp(buff, 'CountDown_CheckTime');
    local useSkillTime = GetUseSkillStartTime(self);

    if prevTime < useSkillTime then
    
        local count = GetExProp(buff, 'CountDown_INDEX');
        count = count + 1;
        SetExProp(buff, 'CountDown_INDEX', count);

        SetExProp(buff, 'CountDown_CheckTime', useSkillTime);

        --print('useSkill', count, useSkillTime)
    end

    
    return 1;

end

function SCR_BUFF_LEAVE_Wizard_CountDown_Debuff(self, buff, arg1, arg2, over)

    local count = GetExProp(buff, 'CountDown_INDEX');
    --print(ScpArgMsg('Auto_BeoPeuJunge_Chong_KongKyeogHan_KaunTeu_:'), count)
    
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    TakeDamage(caster, self, "None", (((caster.MINMATK + caster.MAXMATK) * IMCRandomFloat(0.2, 0.9)) / 2 ) * (count + 1));
    return 1;
    
    
end

-- MagneticForce_Debuff
function SCR_BUFF_ENTER_MagneticForce_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_MagneticForce_Debuff(self, buff, arg1, arg2, over)
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local Psychokino4_abil = GetAbility(caster, 'Psychokino4');
        if Psychokino4_abil ~= nil then
            if IMCRandom(1, 100) < Psychokino4_abil.Level * 5 then
                AddBuff(caster, self, 'Stun', 1, 0, 4000, 1);
            end
        end
    end

    if caster == nil then
        caster = buff;
    end 
    
    local MagneticDamage = 0;
    
    if(arg2 == HIT_STABDOLL) then
        MagneticDamage = arg1;
    else
        local damage = GET_SKL_DAMAGE(caster, self, 'Psychokino_MagneticForce');
        local skill = GET_MON_SKILL(caster, 'Psychokino_MagneticForce');    

        TakeDamage(caster, self, skill.ClassName, damage, "Melee", "Magic", "Magic", HIT_BASIC, HITRESULT_BLOW);
    end 

    RemoveBuff(self, 'MagneticForce_Debuff_Hold')
end


-- Stun
function SCR_BUFF_ENTER_Stun(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_stun', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_LEAVE_Stun(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_stun')
end


-- Petrification
function SCR_BUFF_ENTER_Petrification(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_petrify', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    PlaySound(self, 'skl_eff_debuff_stone')
    LeaveEffect(self, GetBuffRemainTime(buff), 'Stonize',buff.ClassName);
      if IS_PC(self) == true then
        self.Jumpable = self.Jumpable - 1;
      end
end

function SCR_BUFF_LEAVE_Petrification(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_petrify')
    if IS_PC(self) == true then
        self.Jumpable = self.Jumpable + 1;
    end
end



-- Fear
function SCR_BUFF_ENTER_Fear(self, buff, arg1, arg2, over)

    --ShowEmoticon(self, 'I_emo_fear', 0)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    if IS_PC(self) == false then
        AddBuff(caster, self, 'Stun', 1, 0, 1000, 1); 
    end
    
    local patkadd = 0.3
    local matkadd = 0.3
    local atkspdadd = 250
    
    self.PATK_RATE_BM = self.PATK_RATE_BM - patkadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM - matkadd;
    
    SET_NORMAL_ATK_SPEED(self, atkspdadd);
    
    SetExProp(buff, "ADD_PATK", patkadd);
    SetExProp(buff, "ADD_MATK", matkadd);
    SetExProp(buff, "ADD_ATKSPD", atkspdadd);
    
end

function SCR_BUFF_LEAVE_Fear(self, buff, arg1, arg2, over)

   -- HideEmoticon(self, 'I_emo_fear')

    local patkadd = GetExProp(buff, "ADD_PATK");
    local matkadd = GetExProp(buff, "ADD_MATK");  
    local atkspdadd = GetExProp(buff, "ADD_ATKSPD");
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + patkadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM + matkadd;
    SET_NORMAL_ATK_SPEED(self, -atkspdadd);
end

function SCR_BUFF_ENTER_Virus_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    --ShowEmoticon(self, 'I_emo_infection', 0)
    local caster = GetBuffCaster(buff);

    local atk = 0
    if caster ~= nil then
        atk = GET_SKL_DAMAGE(caster, self, "Wugushi_WugongGu");
    end
    
    SetBuffArgs(buff, atk, 0, 0);

    SetExProp(buff, 'VIRUS_MAX_COUNT', arg1);
    SetExProp(buff, 'VIRUS_SPREAD_COUNT', 0);
end

function SCR_BUFF_UPDATE_Virus_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local atk = GetBuffArgs(buff);
    local caster = GetBuffCaster(buff);

    if caster ~= nil then
        local skill = GetSkill(caster, 'Wugushi_WugongGu')
        if skill ~= nil then
            TakeDamage(caster, self, skill.ClassName, atk, "Poison", "Melee", "Melee", HIT_POISON_GREEN, HITRESULT_NO_HITSCP, 0, 0);
        end
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_Virus_Debuff(self, buff, arg1, arg2, over)
  --  HideEmoticon(self, 'I_emo_infection')
end

function SCR_BUFF_ENTER_Virus_Spread_Debuff(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_infection', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local caster = GetBuffCaster(buff);

    local atk = 0
    if caster ~= nil then
        atk = GET_SKL_DAMAGE(caster, self, "Wugushi_WugongGu");
    end
    
    SetBuffArgs(buff, atk, 0, 0);
end
    
function SCR_BUFF_UPDATE_Virus_Spread_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local atk = GetBuffArgs(buff);
    local caster = GetBuffCaster(buff);
    
    if caster ~= nil then
        local skill = GetSkill(caster, 'Wugushi_WugongGu')
        if skill ~= nil then
            TakeDamage(caster, self, skill.ClassName, atk,  "Poison", "Melee", "Melee", HIT_POISON_GREEN, HITRESULT_NO_HITSCP, 0, 0);
        end
    end
    
    return 1;
    
end

function SCR_BUFF_LEAVE_Virus_Spread_Debuff(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_infection')
end



function SCR_BUFF_ENTER_MSPDSteal(self, buff, arg1, arg2, over)
    
    self.ResDark_BM =   self.ResDark_BM + arg2
        
end

function SCR_BUFF_LEAVE_MSPDSteal(self, buff, arg1, arg2, over)

    self.ResDark_BM =   self.ResDark_BM - arg2

end

function SCR_BUFF_ENTER_LastRites_Buff(self, buff, arg1, arg2, over)
    local holyAddAttack = 0;
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local skillSacrament = GetSkill(caster, 'Priest_Sacrament');
        
        local sacramentLv = TryGetProp(skillSacrament, 'Level');
        if sacramentLv == nil then
            sacramentLv = 1;
    end
    
        local stat = TryGetProp(caster, 'MNA');
        if stat == nil then
            stat = 1;
end

        holyAddAttack = math.floor((180 + ((sacramentLv - 1) * 60) + ((sacramentLv / 3) * (stat ^ 0.9))) * 1.2);
        end
    
    SetBuffArgs(buff, holyAddAttack);
    end

--function SCR_BUFF_UPDATE_LastRites_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
--    local checkHP = self.MHP * 0.4
--    local HP = self.HP
--    
--    local caster = GetBuffCaster(buff);
--    if caster ~= nil then
--        local abil = GetAbility(caster, "Chaplain1")
--        if abil ~= nil then
--            checkHP = self.MHP * (0.4 + 0.02 * abil.Level)
--        end
--    
--        if HP <= checkHP and caster ~= nil then
--            RemoveBuff(self, "LastRites_Buff")
--            AddBuff(caster, self, 'LastRites_ActiveBuff', 1, 0, RemainTime, 1);
--        end
--    end
--
--    return 1;
--end

function SCR_BUFF_LEAVE_LastRites_Buff(self, buff, arg1, arg2, over)
--    local holyAtk = GetExProp(buff, "ADD_HOLY");
--    
--    self.Holy_Atk_BM = self.Holy_Atk_BM - holyAtk;
    end
    
    
    
--function SCR_BUFF_ENTER_LastRites_ActiveBuff(self, buff, arg1, arg2, over)
--    local holyAtk = 0;
--    
--    local caster = GetBuffCaster(buff);
--    if caster ~= nil then
--        local sacramentLevel = 1;
--        local sacrament = GetSkill(caster, 'Priest_Sacrament');
--        if sacrament ~= nil then
--            sacramentLevel = sacrament.Level
--        end
--       holyAtk = math.floor(((12.2 + 3.1 * (sacramentLevel - 1)) * 1.5) + caster.MNA)
--    end
--    
--    self.Holy_Atk_BM = self.Holy_Atk_BM + holyAtk
--    
--    SetExProp(buff, "ADD_HOLY", holyAtk);
--end
--
--function SCR_BUFF_LEAVE_LastRites_ActiveBuff(self, buff, arg1, arg2, over)
--    local holyAtk = GetExProp(buff, "ADD_HOLY");
--    
--    self.Holy_Atk_BM = self.Holy_Atk_BM - holyAtk;
--end


function SCR_BUFF_ENTER_Aspergillum_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_Aspergillum_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_card_Gaigalas_debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_card_Gaigalas_debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    TakeDamage(caster, self, "None", 15, "None", "None", "None", HIT_BASIC, HITRESULT_BLOW, 0, 0);

    return 1;

end

function SCR_BUFF_LEAVE_card_Gaigalas_debuff(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_card_Poata_buff(self, buff, arg1, arg2, over)

    self.DEF_BM = self.DEF_BM + 5;

end

function SCR_BUFF_LEAVE_card_Poata_buff(self, buff, arg1, arg2, over)
        self.DEF_BM = self.DEF_BM - 5;
end



function SCR_BUFF_ENTER_card_Sequoia_Blue_buff(self, buff, arg1, arg2, over)

    self.DEF_BM = self.DEF_BM + 15;

end

function SCR_BUFF_LEAVE_card_Sequoia_Blue_buff(self, buff, arg1, arg2, over)
        self.DEF_BM = self.DEF_BM - 15;
end



function SCR_BUFF_ENTER_card_Wood_Spirit_Green_buff(self, buff, arg1, arg2, over)

    self.ResPoison_BM = self.ResPoison_BM + 100;

end

function SCR_BUFF_LEAVE_card_Wood_Spirit_Green_buff(self, buff, arg1, arg2, over)

    self.ResPoison_BM = self.ResPoison_BM - 100;

end


function SCR_BUFF_ENTER_card_Chafer_buff(self, buff, arg1, arg2, over)

    self.MSPD_BM = self.MSPD_BM + 5;

end

function SCR_BUFF_LEAVE_card_Chafer_buff(self, buff, arg1, arg2, over)

    self.MSPD_BM = self.MSPD_BM - 5;

end



function SCR_BUFF_ENTER_card_Abomination_buff(self, buff, arg1, arg2, over)

    self.Paramune_Atk_BM = self.Paramune_Atk_BM + 20;

end

function SCR_BUFF_LEAVE_card_Abomination_buff(self, buff, arg1, arg2, over)

    self.Paramune_Atk_BM = self.Paramune_Atk_BM - 20;

end


function SCR_BUFF_ENTER_card_Wood_Spirit_buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_card_Wood_Spirit_buff(self, buff, arg1, arg2, RemainTime, ret, over)

    AddHP(self, 20);
    return 1;

end

function SCR_BUFF_LEAVE_card_Wood_Spirit_buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_card_MagBurk_buff(self, buff, arg1, arg2, over)

    self.ResFire_BM = self.ResFire_BM + 100;

end

function SCR_BUFF_LEAVE_card_MagBurk_buff(self, buff, arg1, arg2, over)

    self.ResFire_BM = self.ResFire_BM - 100;

end



function SCR_BUFF_ENTER_card_Deadborn_buff(self, buff, arg1, arg2, over)

    self.Paramune_Atk_BM = self.Paramune_Atk_BM + 120;

end

function SCR_BUFF_LEAVE_card_Deadborn_buff(self, buff, arg1, arg2, over)

    self.Paramune_Atk_BM = self.Paramune_Atk_BM - 120;

end



function SCR_BUFF_ENTER_card_Denoptic_buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_card_Denoptic_buff(self, buff, arg1, arg2, RemainTime, ret, over)

    AddHP(self, 24);
    return 1;

end

function SCR_BUFF_LEAVE_card_Denoptic_buff(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_card_Moldyhorn_buff(self, buff, arg1, arg2, over)

    self.DEF_BM = self.DEF_BM + 30;

end

function SCR_BUFF_LEAVE_card_Moldyhorn_buff(self, buff, arg1, arg2, over)
        self.DEF_BM = self.DEF_BM - 30;
end



function SCR_BUFF_ENTER_card_TombLord_buff(self, buff, arg1, arg2, over)
    if IS_PC(self) == true then
        self.ResFire_BM = self.ResFire_BM + 50;
        self.ResPoison_BM = self.ResPoison_BM + 50;
        self.ResLightning_BM = self.ResLightning_BM + 50;
        self.ResIce_BM = self.ResIce_BM + 50;
        self.ResHoly_BM = self.ResHoly_BM + 50;
        self.ResDark_BM = self.ResDark_BM + 50;
    end
end

function SCR_BUFF_LEAVE_card_TombLord_buff(self, buff, arg1, arg2, over)
    if IS_PC(self) == true then
        self.ResFire_BM = self.ResFire_BM - 50;
        self.ResPoison_BM = self.ResPoison_BM - 50;
        self.ResLightning_BM = self.ResLightning_BM - 50;
        self.ResIce_BM = self.ResIce_BM - 50;
        self.ResHoly_BM = self.ResHoly_BM - 50;
        self.ResDark_BM = self.ResDark_BM - 50;
    end
end



function SCR_BUFF_ENTER_card_Mushcaria_buff(self, buff, arg1, arg2, over)

    self.MSPD_BM = self.MSPD_BM + 8;

end

function SCR_BUFF_LEAVE_card_Mushcaria_buff(self, buff, arg1, arg2, over)

    self.MSPD_BM = self.MSPD_BM - 8;

end



function SCR_BUFF_ENTER_card_Ginklas_debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_card_Ginklas_debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    DamageReflect(caster, self, "None", 30, "None", "None", "None", HIT_BASIC, HITRESULT_BLOW, 0, 0);
--    TakeDamage(caster, self, "None", 30, "None", "None", "None", HIT_BASIC, HITRESULT_BLOW, 0, 0);
    return 1;

end

function SCR_BUFF_LEAVE_card_card_Ginklas_debuff(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_card_Velorchard_buff(self, buff, arg1, arg2, over)

    self.DR_BM = self.DR_BM + 75;

end

function SCR_BUFF_LEAVE_card_Velorchard_buff(self, buff, arg1, arg2, over)

    self.DR_BM = self.DR_BM - 75;

end



function SCR_BUFF_ENTER_JackO_lantern_buff(self, buff, arg1, arg2, over)

    self.Velnias_Atk_BM = self.Velnias_Atk_BM + 120;

end

function SCR_BUFF_LEAVE_JackO_lantern_buff(self, buff, arg1, arg2, over)

    self.Velnias_Atk_BM = self.Velnias_Atk_BM - 120;

end



function SCR_BUFF_ENTER_card_Sparnas_buff(self, buff, arg1, arg2, over)

    self.CRTATK_BM = self.CRTATK_BM + 100;

end

function SCR_BUFF_LEAVE_card_Sparnas_buff(self, buff, arg1, arg2, over)

    self.CRTATK_BM = self.CRTATK_BM - 100;

end


function SCR_BUFF_ENTER_card_spector_gh_buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_card_spector_gh_buff(self, buff, arg1, arg2, RemainTime, ret, over)

    AddSP(self, 20);
    return 1;

end

function SCR_BUFF_LEAVE_card_spector_gh_buff(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_card_Kerberos_buff(self, buff, arg1, arg2, over)

    self.Fire_Atk_BM = self.Fire_Atk_BM + over * 30;

end

function SCR_BUFF_LEAVE_card_Kerberos_buff(self, buff, arg1, arg2, over)

    self.Fire_Atk_BM = self.Fire_Atk_BM - over * 30;

end



function SCR_BUFF_ENTER_card_Carapace_defbuff(self, buff, arg1, arg2, over)

    local defAdd = self.DEF * 0.1;
    
    self.DEF_BM = self.DEF_BM - over * defAdd;
    SetExProp(buff, "ADD_DEF", defAdd);

end

function SCR_BUFF_LEAVE_card_Carapace_defbuff(self, buff, arg1, arg2, over)

    local defAdd = GetExProp(buff, "ADD_DEF");
    self.DEF_BM = self.DEF_BM + over * defAdd;

end



function SCR_BUFF_ENTER_card_Kerberos_buff(self, buff, arg1, arg2, over)

    self.Dark_Atk_BM = self.Dark_Atk_BM + 15;

end

function SCR_BUFF_LEAVE_card_Kerberos_buff(self, buff, arg1, arg2, over)

    self.Dark_Atk_BM = self.Dark_Atk_BM - 15;

end



function SCR_BUFF_ENTER_card_Onion_the_Great_debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_card_Onion_the_Great_debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    TakeDamage(caster, self, "None", 25, "None", "None", "None", HIT_BASIC, HITRESULT_BLOW, 0, 0);

    return 1;

end

function SCR_BUFF_LEAVE_card_Onion_the_Great_debuff(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_card_Zombieboss_buff(self, buff, arg1, arg2, over)

    self.UMBO_BM = self.UMBO_BM + 40;
    self.RIM_BM = self.RIM_BM + 40;

end

function SCR_BUFF_LEAVE_card_Zombieboss_buff(self, buff, arg1, arg2, over)

    self.UMBO_BM = self.UMBO_BM - 40;
    self.RIM_BM = self.RIM_BM - 40;

end



function SCR_BUFF_ENTER_AntiKD_buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_AntiKD_buff(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_card_Hydra_buff(self, buff, arg1, arg2, over)

    self.Widling_Atk_BM = self.Widling_Atk_BM + 50;

end

function SCR_BUFF_LEAVE_card_Hydra_buff(self, buff, arg1, arg2, over)

    self.Widling_Atk_BM = self.Widling_Atk_BM - 50;

end



function SCR_BUFF_ENTER_ResistElements_Buff(self, buff, arg1, arg2, over)
    local lv = arg1;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
    end
    
    local resadd = 24 + 6.3 * (lv - 1)
    local abilresadd = 1
    
    local skill = GetSkill(caster, "Paladin_ResistElements")
    if skill == nil then
        return
    end
    
    local Paladin18_abil = GetAbility(caster, 'Paladin18');
    if Paladin18_abil ~= nil and skill.Level >= 3 then
        abilresadd = abilresadd + Paladin18_abil.Level * 0.01
    end
    
    local resiceadd = (resadd + self.ResIce * 0.2) * abilresadd
    local resfireadd = (resadd + self.ResFire * 0.2) * abilresadd
    local reslightadd = (resadd + self.ResLightning * 0.2) * abilresadd
    local resposadd = (resadd + self.ResPoison * 0.2) * abilresadd
    local researthadd = (resadd + self.ResEarth * 0.2) * abilresadd
        
    
    if IS_PC(self) == true then
        self.ResIce_BM = self.ResIce_BM + resiceadd
        self.ResFire_BM = self.ResFire_BM + resfireadd
        self.ResLightning_BM = self.ResLightning_BM + reslightadd
        self.ResPoison_BM = self.ResPoison_BM + resposadd
        self.ResEarth_BM = self.ResEarth_BM + researthadd
    end
    
    SetExProp(buff, "ADD_ICE", resiceadd);
    SetExProp(buff, "ADD_FIRE", resfireadd);
    SetExProp(buff, "ADD_LIGHT", reslightadd);
    SetExProp(buff, "ADD_POS", resposadd);
    SetExProp(buff, "ADD_EARTH", researthadd);
end

function SCR_BUFF_LEAVE_ResistElements_Buff(self, buff, arg1, arg2, over)

    local resiceadd = GetExProp(buff, "ADD_ICE");
    local resfireadd = GetExProp(buff, "ADD_FIRE");
    local reslightadd = GetExProp(buff, "ADD_LIGHT");
    local resposadd = GetExProp(buff, "ADD_POS");
    local researthadd = GetExProp(buff, "ADD_EARTH");

    if IS_PC(self) == true then
        self.ResIce_BM = self.ResIce_BM - resiceadd
        self.ResFire_BM = self.ResFire_BM - resfireadd
        self.ResLightning_BM = self.ResLightning_BM - reslightadd
        self.ResPoison_BM = self.ResPoison_BM - resposadd
        self.ResEarth_BM = self.ResEarth_BM - researthadd
    end

end


-- ???????????????????
function SCR_BUFF_ENTER_collection_06003_debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_collection_06003_debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end
    
    local dotDmg = self.MHP * 0.02
    
    TakeDamage(caster, self, "None", dotDmg , "None", "None", "None", HIT_BASIC, HITRESULT_BLOW, 0, 0);

    return 1;

end

function SCR_BUFF_LEAVE_collection_06003_debuff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_collection_06004_buff(self, buff, arg1, arg2, over)
    
    if IS_PC(self) == true then
        self.ResFire_BM = self.ResFire_BM + 100;
        self.ResLightning_BM = self.ResLightning_BM + 100;
        self.ResPoison_BM = self.ResPoison_BM + 100;
        self.ResIce_BM = self.ResIce_BM + 100;
        self.ResHoly_BM = self.ResHoly_BM + 100;
        self.ResDark_BM = self.ResDark_BM + 100;
    end
end

function SCR_BUFF_LEAVE_collection_06004_buff(self, buff, arg1, arg2, over)
    if IS_PC(self) == true then
        self.ResFire_BM = self.ResFire_BM - 100;
        self.ResLightning_BM = self.ResLightning_BM - 100;
        self.ResPoison_BM = self.ResPoison_BM - 100;
        self.ResIce_BM = self.ResIce_BM - 100;
        self.ResHoly_BM = self.ResHoly_BM - 100;
        self.ResDark_BM = self.ResDark_BM - 100;
    end
end






-- Resizeing
function SCR_BUFF_ENTER_Resizeing(self, buff, arg1, arg2, over)

    if self.Size == 'S' then
        ChangeScale(self, 2.0, 0.2);
        SetExProp(self, "Resize", 1);
        self.Size = 'L';
    end

--  print(GetExProp(self, 'Resize'))

    if GetExProp(self, 'Resize') ~= 1 and self.Size == 'L'  then
        ChangeScale(self, 1/2, 0.2);
        SetExProp(self, "Resize", 1);
        self.Size = 'S';
    end

end

function SCR_BUFF_LEAVE_Resizeing(self, buff, arg1, arg2, over)

    if self.Size == 'S' and GetExProp(self, 'Resize') == 1 then
        ChangeScale(self, 2.0, 0.2);
        self.Size = 'L';
        SetExProp(self, "Resize", 0);
    end

    if self.Size == 'L' and GetExProp(self, 'Resize') == 1 then
        ChangeScale(self, 1/2, 0.2);
        self.Size = 'S';
    end


    return 1;
    
    
end




--Ironskin

function SCR_BUFF_ENTER_Ironskin_Buff(self, buff, arg1, arg2, over)

      --local addDefenced_BM  = 1;
    --SetExProp(buff, 'DEFENCED_BM', addDefenced_BM);
    --self.MaxDefenced_BM = self.MaxDefenced_BM + addDefenced_BM;
    
    local damratio = 100;
    self.DamReflect = self.DamReflect + damratio;
    SetExProp(buff, "ADD_DAMREFLCET", damratio);

    
end

function SCR_BUFF_LEAVE_Ironskin_Buff(self, buff, arg1, arg2, over)

    --local addDefenced_BM = GetExProp(buff, 'DEFENCED_BM');
    --self.MaxDefenced_BM = self.MaxDefenced_BM - addDefenced_BM;
    
    local damratio = GetExProp(buff, "ADD_DAMREFLCET");
    self.DamReflect = self.DamReflect - damratio;
    
end


--Ironskin_Debuff

function SCR_BUFF_ENTER_Ironskin_Debuff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_UPDATE_Ironskin_Debuff(self, buff, arg1, arg2, over)

  ticdamage = GetExProp(self, "AfterEffect") / 20;
    
  TakeDamage(self, self, "None", GetExProp(self, "AfterEffect") / 20, "None", "None", "None", HIT_BASIC, HITRESULT_BLOW, 0, 0);

  return 1;
  
end

function SCR_BUFF_LEAVE_Ironskin_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Golden_Bell_Shield_Buff(self, buff, arg1, arg2, over)
--    AttachEffect(self, 'F_cleric_Golden_Bell_Shield_loop#Dummy_emitter', 2.4, 'BOT');

    local addDefenced_BM  = 1;
    SetExProp(self, 'DEFENCED_BM', addDefenced_BM);
    self.MaxDefenced_BM = self.MaxDefenced_BM + addDefenced_BM;
end

function SCR_BUFF_LEAVE_Golden_Bell_Shield_Buff(self, buff, arg1, arg2, over, isLastEnd)
--    DetachEffect(self, 'F_cleric_Golden_Bell_Shield_loop');

    local addDefenced_BM = GetExProp(self, 'DEFENCED_BM');
    self.MaxDefenced_BM = self.MaxDefenced_BM - addDefenced_BM;

    local abilMonk7 = GetAbility(self, 'Monk7')
    if abilMonk7 ~= nil and isLastEnd == 1 then
        AddBuff(self, self, 'PainBarrier_Buff', 1, 0, 5000, 1);
    end
end

-- Golden_Bell_Shield_Safety
function SCR_BUFF_ENTER_Golden_Bell_Shield_Safety(self, buff, arg1, arg2, over)

    local addDefenced_BM  = 1;
    SetExProp(buff, 'DEFENCED_BM', addDefenced_BM);
    self.MaxDefenced_BM = self.MaxDefenced_BM + addDefenced_BM;

end

function SCR_BUFF_LEAVE_Golden_Bell_Shield_Safety(self, buff, arg1, arg2, over)

    local addDefenced_BM = GetExProp(buff, 'DEFENCED_BM');
    self.MaxDefenced_BM = self.MaxDefenced_BM - addDefenced_BM;

end


function SCR_BUFF_ENTER_Ausirine_Buff(self, buff, arg1, arg2, over)

    local addDefenced_BM  = 1;
    SetExProp(self, 'DEFENCED_BM', addDefenced_BM);
    self.MaxDefenced_BM = self.MaxDefenced_BM + addDefenced_BM;

end

function SCR_BUFF_LEAVE_Ausirine_Buff(self, buff, arg1, arg2, over)

    local addDefenced_BM = GetExProp(self, 'DEFENCED_BM');
    self.MaxDefenced_BM = self.MaxDefenced_BM - addDefenced_BM;

end



-- Warrior_ThrowItem_Debuff_RH/LH
function SCR_BUFF_ENTER_Warrior_ThrowItem_Debuff_RH(self, buff, arg1, arg2, over)
    SCR_THROWITEM_DEBUFF_ENTER(self, buff, "RH");
end
function SCR_BUFF_UPDATE_Warrior_ThrowItem_Debuff_RH(self, buff, arg1, arg2, RemainTime, ret, over)
    SCR_THROWITEM_DEBUFF_UPDATE(self, buff, "RH");
    return 1;
end
function SCR_BUFF_LEAVE_Warrior_ThrowItem_Debuff_RH(self, buff, arg1, arg2, over)   
    SCR_THROWITEM_DEBUFF_LEAVE(self, buff, "RH");
end
function SCR_BUFF_ENTER_Warrior_ThrowItem_Debuff_LH(self, buff, arg1, arg2, over)
    SCR_THROWITEM_DEBUFF_ENTER(self, buff, "LH");
end
function SCR_BUFF_UPDATE_Warrior_ThrowItem_Debuff_LH(self, buff, arg1, arg2, RemainTime, ret, over)
    SCR_THROWITEM_DEBUFF_UPDATE(self, buff, "LH");
    return 1;
end
function SCR_BUFF_LEAVE_Warrior_ThrowItem_Debuff_LH(self, buff, arg1, arg2, over)   
    SCR_THROWITEM_DEBUFF_LEAVE(self, buff, "LH");
end

function SCR_THROWITEM_DEBUFF_ENTER(self, buff, handType)
    SetExProp(buff, 'PICK_EQUIPITEM', 0);

    local equipItem = GetEquipItem(self, handType);
    if equipItem ~= nil then
        local itemGUID = GetItemGuid(equipItem);
        SetExProp_Str(buff, 'EQUIP_ITEM_ID', itemGUID);

        if handType == 'LH' then
            AddBuff(self, self, 'Warrior_LH_VisibleObject');                
        elseif handType == 'RH' then
            AddBuff(self, self, 'Warrior_RH_VisibleObject');                
        end     
    end
end

function SCR_THROWITEM_DEBUFF_UPDATE(self, buff, handType)
    local equipObj = GetExArgObject(self, "THROW_ITEM_OBJ_"..handType)
    if equipObj == nil then
        RemoveBuff(self, 'Warrior_ThrowItem_Debuff_'..handType);
        return;
    end

    local isDethroneSkl = GetExProp(buff, 'IS_DETHRONE_SKIL')
    if isDethroneSkl ~= 0 then
        local checkTime = GetExProp(buff, "DETHRONE_SKIL_CHECkTIME");
        if imcTime.GetAppTime() < checkTime then
            return;
        end
    end

    local list, Cnt = SelectObject(self, 50, 'ALL') -- 50
    for i = 1 , Cnt do
        if 1 == IsSameObject(list[i], equipObj) then
            Kill(equipObj);

            if handType == 'LH' then
                RemoveBuff(self, 'Warrior_LH_VisibleObject');               
            elseif handType == 'RH' then
                RemoveBuff(self, 'Warrior_RH_VisibleObject');               
            end

            RemoveBuff(self, 'Warrior_ThrowItem_Debuff_'..handType);
            return;
        end
    end
end

function SCR_THROWITEM_DEBUFF_LEAVE(self, buff, handType)
    local equipObj = GetExArgObject(self, "THROW_ITEM_OBJ_"..handType) 
    if equipObj ~= nil then
        Kill(equipObj);
    end
    
    ClearExArgObject(self, "THROW_ITEM_OBJ_"..handType);

    if handType == 'LH' then
        RemoveBuff(self, 'Warrior_LH_VisibleObject');               
    elseif handType == 'RH' then
        RemoveBuff(self, 'Warrior_RH_VisibleObject');               
    end
end

function SCR_THROWITEM_DELETE(self, handType)

    local equipItem = GetEquipItem(self, handType);
    if equipItem == nil then
        return;
    end

    local tx = TxBegin(self);
    TxTakeItemByObject(tx, equipItem, 1);   
    local ret = TxCommit(tx);
    
end


-- Impaler_Buff
function SCR_BUFF_ENTER_Impaler_Buff(self, buff, arg1, arg2, over)

    AddLimitationSkillList(self, 'Cataphract_Impaler');
    AddIgnoreSkillCoolTime(self, 'Cataphract_Impaler');
    self.Jumpable = self.Jumpable - 1;
end

function SCR_BUFF_LEAVE_Impaler_Buff(self, buff, arg1, arg2, over)
    
    ClearLimitationSkillList(self);
    ClearIgnoreSkillCoolTime(self);
    self.Jumpable = self.Jumpable + 1;
end

-- Impaler_Debuff
function SCR_BUFF_ENTER_Impaler_Debuff(self, buff, arg1, arg2, over)
    SkillCancel(self);
    local caster = GetBuffCaster(buff);
    local skill = GetSkill(caster, "Cataphract_Impaler")
    AddBuff(caster, caster, 'Impaler_Buff', arg1, arg2, 8000 + skill.Level * 1000, 1);  
end

function SCR_BUFF_LEAVE_Impaler_Debuff(self, buff, arg1, arg2, over)    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        DetachFromObject(self, caster);
        RemoveBuff(caster, 'Impaler_Buff');
        local x, y, z = GetFrontPos(caster, 10);
        SetPos(self, x, y, z);
    end
end

function SCR_BUFF_ENTER_Stabbing_Debuff(self, buff, arg1, arg2, over)

        AddLimitationSkillList(self, 'Hoplite_Stabbing');
        AddIgnoreSkillCoolTime(self, 'Hoplite_Stabbing');
    end

function SCR_BUFF_LEAVE_Stabbing_Debuff(self, buff, arg1, arg2, over)
    
        ClearLimitationSkillList(self);
        ClearIgnoreSkillCoolTime(self);
    end

--Archer_Kneelingshot
function SCR_BUFF_ENTER_Archer_Kneelingshot(self, buff, arg1, arg2, over)
    local ranadd = 0;
    local atkadd = 0;
    local criadd = 0;
    local atkspdadd = 0;
    local abil = GetAbility(self, 'Focusing')
    if abil ~= nil then
        criadd = abil.Level * 40;
    end
    
    local skill = GetSkill(self, 'Archer_Kneelingshot')
    if skill ~= nil then
        ranadd = skill.Level * 2.5 + 10;
        atkadd = 15.4 + (skill.Level - 1) * 4.1
        atkspdadd = skill.Level * 30;
        
        local Archer21_abil = GetAbility(self, "Archer21")    -- 2rank Skill Damage multiple
        local Archer22_abil = GetAbility(self, "Archer22")    -- 3rank Skill Damage multiple
        if Archer22_abil ~= nil then
            atkadd = atkadd * 1.44
        elseif Archer22_abil == nil and Archer21_abil ~= nil then
            atkadd = atkadd * 1.38
        end
        
        local DEX = TryGetProp(self, "DEX")
        local atkrate = DEX * (skill.Level * 0.2)
        atkadd = atkadd + atkrate
        
        local Archer14_abil = GetAbility(self, 'Archer14')
        if Archer14_abil ~= nil and skill.Level >= 3 then
            atkadd = atkadd * (1 + Archer14_abil.Level * 0.01)
        end
    end
    
    ranadd = math.floor(ranadd);
    atkadd = math.floor(atkadd);
    criadd = math.floor(criadd);
    atkspdadd = math.floor(atkspdadd);
    self.MaxR_BM = self.MaxR_BM + ranadd;
    self.PATK_BM = self.PATK_BM + atkadd;
    self.CRTHR_BM = self.CRTHR_BM + criadd;
    SET_NORMAL_ATK_SPEED(self, -atkspdadd);
    SetExProp(buff, "Kneelingshot_ADDRANGE", ranadd);
    SetExProp(buff, "Kneelingshot_ADDATK", atkadd);
    SetExProp(buff, "Kneelingshot_ADDCRI", criadd);
    SetExProp(buff, "Kneelingshot_ATKSPD", atkspdadd);
    
    local skl = GetSkill(self, "Archer_Kneelingshot");
    InvalidateObjectProp(skl, "MaxR");
    SendSkillProperty(self, skl);
    
    local normalAttackList = {};
    normalAttackList[#normalAttackList + 1] = "Archer_Kneelingshot";
    normalAttackList[#normalAttackList + 1] = "Bow_Attack";
    normalAttackList[#normalAttackList + 1] = "Bow_Attack2";
    normalAttackList[#normalAttackList + 1] = "CrossBow_Attack";
    normalAttackList[#normalAttackList + 1] = "Musket_Attack";
    if nil ~= GetAbility(self, 'Musketeer17') then
        normalAttackList[#normalAttackList + 1] = "Musketeer_PenetrationShot";
    end
    normalAttackList[#normalAttackList + 1] = "Cannoneer_ShootDown";
    normalAttackList[#normalAttackList + 1] = "Cannoneer_SiegeBurst";
    normalAttackList[#normalAttackList + 1] = "Cannoneer_CannonBlast";
    normalAttackList[#normalAttackList + 1] = "Cannoneer_CannonBarrage";
    normalAttackList[#normalAttackList + 1] = "Cannoneer_CannonShot";
    normalAttackList[#normalAttackList + 1] = "Cannoneer_SmokeGrenade";
    normalAttackList[#normalAttackList + 1] = "Musketeer_SnipersSerenity";
    normalAttackList[#normalAttackList + 1] = "Cannoneer_SweepingCannon";
    normalAttackList[#normalAttackList + 1] = "DoubleGun_Attack";
    
    for i = 1 , #normalAttackList do
        local norm = normalAttackList[i];
        local normalSkl = GetSkill(self, norm);
        if normalSkl ~= nil then
            InvalidateObjectProp(normalSkl, "MaxR");
            SendSkillProperty(self, normalSkl);
            AddLimitationSkillList(self, norm);
        end
    end 
end

function SCR_BUFF_LEAVE_Archer_Kneelingshot(self, buff, arg1, arg2, over)

    local ranadd = GetExProp(buff, "Kneelingshot_ADDRANGE");
    local atkadd = GetExProp(buff, "Kneelingshot_ADDATK");
    local criadd = GetExProp(buff, "Kneelingshot_ADDCRI");
    local atkspdadd = GetExProp(buff, "Kneelingshot_ATKSPD");
    
    self.MaxR_BM = self.MaxR_BM - ranadd;
    self.PATK_BM = self.PATK_BM - atkadd;
    self.CRTHR_BM = self.CRTHR_BM - criadd;
    SET_NORMAL_ATK_SPEED(self, atkspdadd);

    local skl = GetSkill(self, "Archer_Kneelingshot");
    InvalidateObjectProp(skl, "MaxR");
    SendProperty(self, skl);

    local normalAttackList = {};
    normalAttackList[#normalAttackList + 1] = "Archer_Kneelingshot";
    normalAttackList[#normalAttackList + 1] = "Bow_Attack";
    normalAttackList[#normalAttackList + 1] = "Bow_Attack2";
--    normalAttackList[#normalAttackList + 1] = "Pistol_Attack";
    normalAttackList[#normalAttackList + 1] = "CrossBow_Attack";
    normalAttackList[#normalAttackList + 1] = "Musket_Attack";
    normalAttackList[#normalAttackList + 1] = "Musketeer_PenetrationShot";
    normalAttackList[#normalAttackList + 1] = "Musketeer_SnipersSerenity";
    for i = 1 , #normalAttackList do
        local norm = normalAttackList[i];
        local normalSkl = GetSkill(self, norm);
        if normalSkl ~= nil then
            InvalidateObjectProp(normalSkl, "MaxR");
            SendSkillProperty(self, normalSkl);
        end
    end
    
    ClearLimitationSkillList(self);

end

--Bazooka_Buff
function SCR_BUFF_ENTER_Bazooka_Buff(self, buff, arg1, arg2, over)
    local addAttackSpeed = 0;
    local minRangeLimit = 50;
    
    local abil_Cannoneer16 = GetAbility(self, "Cannoneer16");
    if abil_Cannoneer16 ~= nil and abil_Cannoneer16.ActiveState == 1 then
        addAttackSpeed = 250;
        minRangeLimit = 0;
    end

    SetExProp(buff, "ADD_ATKSPD", addAttackSpeed);
    
    SET_NORMAL_ATK_SPEED(self, -addAttackSpeed);
    
    SetLimitMinTargetRange(self, minRangeLimit, "Cannon_Attack");
    self.Jumpable = self.Jumpable - 1;

    ChangeNormalAttack(self, "Cannon_Attack");

    local normalAttackList = {};
    normalAttackList[#normalAttackList + 1] = "Cannoneer_Bazooka";

    normalAttackList[#normalAttackList + 1] = "Cannon_Attack";
    ----------------------------------
    
    local skill = GetSkill(self, "Cannon_Attack")
    
    local ranadd = arg1 * 8;
    self.MaxR_BM = self.MaxR_BM + ranadd
    SetExProp(buff, "ADD_MAXR", ranadd)
    
    InvalidateObjectProp(skill, "MaxR");
    SendSkillProperty(self, skill);
    
    for i = 1 , #normalAttackList do
        local norm = normalAttackList[i];
        local normalSkl = GetSkill(self, norm);
        if normalSkl ~= nil then
            AddLimitationSkillList(self, norm);
        end
    end
    
--	local skillList, cnt = GetPCSkillList(self);
--	for i = 1, cnt do
--		if cnt > 0 then
--			if skillList[i].ClassName ~= "Archer_Kneelingshot" then
--				if skillList[i].ValueType == "Buff" then
--					AddLimitationSkillList(self, skillList[i].ClassName)
--				end
--			end
--		end
--	end
    
    AddLimitationSkillList(self, "Cannoneer_CannonShot");
    AddLimitationSkillList(self, "Cannoneer_ShootDown");
    AddLimitationSkillList(self, "Cannoneer_SiegeBurst");
    AddLimitationSkillList(self, "Cannoneer_CannonBlast");
    AddLimitationSkillList(self, "Cannoneer_CannonBarrage");
    AddLimitationSkillList(self, "Cannoneer_SmokeGrenade");
    AddLimitationSkillList(self, "Cannoneer_SweepingCannon");
end

function SCR_BUFF_LEAVE_Bazooka_Buff(self, buff, arg1, arg2, over)
    local addAttackSpeed = GetExProp(buff, "ADD_ATKSPD");
    
    SET_NORMAL_ATK_SPEED(self, addAttackSpeed);
    
    SetLimitMinTargetRange(self, 0, "Cannon_Attack");
    ClearLimitationSkillList(self);
    ChangeNormalAttack(self, "None");
    
    local ranadd = GetExProp(buff, "ADD_MAXR")
    self.MaxR_BM = self.MaxR_BM - ranadd;
    
    local skill = GetSkill(self, "Cannon_Attack")
    
    InvalidateObjectProp(skill, "MaxR");
    SendSkillProperty(self, skill);
    
    self.Jumpable = self.Jumpable + 1;
end

function SCR_BUFF_ENTER_LightningHands_Buff(self, buff, arg1, arg2, over)
    ChangeNormalAttack(self, "LightningHands_Attack");
    
    local normalAttackList = {};
    normalAttackList[#normalAttackList + 1] = "Enchanter_LightningHands";
    normalAttackList[#normalAttackList + 1] = "LightningHands_Attack";
end

function SCR_BUFF_LEAVE_LightningHands_Buff(self, buff, arg1, arg2, over)
    ChangeNormalAttack(self, "None");
    ChangeSkillAniNameImmediately(self, 'Magic_Attack', 'None');
    ChangeSkillAniNameImmediately(self, 'Magic_Attack_TH', 'None');
end

-- FireBall_Buff
function SCR_BUFF_ENTER_FireBall_Buff(self, buff, arg1, arg2, over)
    ChangeScale(self, 1.3)
    SetExProp(self, 'FIREBALL_HIT_COUNT', 1);
end

function SCR_BUFF_UPDATE_FireBall_Buff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster == nil then
        Kill(self);
        return 1;
    end
	
	local hitCount = GetExProp(self, 'FIREBALL_HIT_COUNT'); 
    local curTime = imcTime.GetAppTime();
    local isAttack = false;
    local objList, objCount = SelectObject(self, 25, 'ALL');
    for i = 1, objCount do
        local obj = objList[i];
        if obj ~= nil and GetRelation(caster, obj) == "ENEMY" and IsSameActor(obj, self) == "NO" then
            if obj.ClassName ~= "hidden_monster2" and hitCount > 0 then
                local time = GetExProp(obj, 'FIREBALL_HIT_TIME');
                if time + 1 < curTime then
                    local splashRange = 70;
                    local dmgRage = 1;
                    local sr = 15;
					
					isAttack = FIREBALL_SPLASH_DAMAGE(self, caster, 'Pyromancer_FireBall', splashRange, sr);
                    if isAttack == true then
                        PlayEffect(self, "F_wizard_fireball_hit_full_explosion", 2.0);
						hitCount = hitCount - 1;
                        SetExProp(self, 'FIREBALL_HIT_COUNT', hitCount);
                        break;
                    end
                end
            end
        end     
    end
	
    return 1;
end

function SCR_BUFF_LEAVE_FireBall_Buff(self, buff, arg1, arg2, over)

end

function FIREBALL_SPLASH_DAMAGE(fireMon, caster, skillName, range, sr)
    local isAttack = false;
    local skill = GET_MON_SKILL(caster, 'Pyromancer_FireBall');
    if skill ~= nil then
        local objList, objCount = SelectObjectNear(caster, fireMon, range, 'ENEMY');
        for i = 1, objCount do
            local obj = objList[i];
            if obj == fireMon then
            	return
            end
			
            if IsSameActor(obj, caster) == "NO" and IsSameActor(obj, fireMon) == "NO" then
                local damage = GET_SKL_DAMAGE(caster, obj, 'Pyromancer_FireBall');
				TakeDamage(caster, obj, skillName, damage, "Fire", "Magic", "Magic", HIT_FIRE, HITRESULT_BLOW);
                sr = sr - obj.SDR;
				
                isAttack = true;
                SetExProp(obj, 'FIREBALL_HIT_TIME', curTime);
				
                local pyromancer1_abil = GetAbility(caster, 'Pyromancer1')
                if pyromancer1_abil ~= nil then
                    local rand = pyromancer1_abil.Level * 1000;
                    if IMCRandom(1, 10000) < rand then
                        local dot = caster.MINMATK * 0.5;
                        AddBuff(caster, obj, "Fire", dot, 0, 5000, 1);
                    end
                end
	        end
        	
            if sr <= 0 then
                return isAttack;
            end
        end
    end
	
    return isAttack;
end

function SCR_BUFF_ENTER_Warrior_EnableMovingShot_Buff(self, buff, arg1, arg2, over)

    local addMovingShootSpd = arg1 * 1.5;   
    self.MovingShot_BM = self.MovingShot_BM + addMovingShootSpd
    SetExProp(buff, 'ADD_MOVINGSHOT_BM', addMovingShootSpd);

end

function SCR_BUFF_LEAVE_Warrior_EnableMovingShot_Buff(self, buff, arg1, arg2, over)

    local addMovingShotSpeed = GetExProp(buff, 'ADD_MOVINGSHOT_BM');
    self.MovingShot_BM = self.MovingShot_BM - addMovingShotSpeed
    
end


function SCR_BUFF_ENTER_ResistElements_Debuff(self, buff, arg1, arg2, over)
    
    local mdefrate = 0.08
--  local mdefadd = 25 + arg1 * 5
--  self.MDEF_BM = self.MDEF_BM - mdefadd;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - mdefrate
--  SetExProp(buff, 'ADD_MDEF_BM', mdefadd);
    SetExProp(buff, 'ADD_MDEF_BM2', mdefrate);

end

function SCR_BUFF_LEAVE_ResistElements_Debuff(self, buff, arg1, arg2, over)

--  local mdefadd = GetExProp(buff, 'ADD_MDEF_BM');
    local mdefrate = GetExProp(buff, 'ADD_MDEF_BM2');

--  self.MDEF_BM = self.MDEF_BM + mdefadd;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + mdefrate;

end



function SCR_BUFF_ENTER_Subzero_Buff(self, buff, arg1, arg2, over)
    

end

function SCR_BUFF_LEAVE_Subzero_Buff(self, buff, arg1, arg2, over)


end

-- Conversion_Debuff
function SCR_BUFF_ENTER_Conversion_Debuff(self, buff, arg1, arg2, over)
    local curHpPercent = GetHpPercent(self) * 100;
    
    SetExProp(buff, 'CUR_HP_PERCENT', curHpPercent);
end

function SCR_BUFF_LEAVE_Conversion_Debuff(self, buff, arg1, arg2, over)
    
end

-- Conversion_Buff
function SCR_BUFF_ENTER_Conversion_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_Conversion_Buff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff)
    if caster == nil then
        Kill(self)
    end
end

function SCR_BUFF_LEAVE_Conversion_Buff(self, buff, arg1, arg2, over)
--    local Btree = nil
--    Btree = self.BTree
--    SetOwner(self, nil);
--    RunSimpleAI(self, "self.SimpleAI")
--    SetCurrentFaction(self, "Monster")
end

-- Avoid
function SCR_BUFF_ENTER_Avoid(self, buff, arg1, arg2, over)

    local adddr = math.floor(arg1 * 50)
    local addmdef = arg1 * 0.05

    self.DR_BM = self.DR_BM + adddr;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + addmdef;
    
    SetExProp(buff, "ADD_DR", adddr)
    SetExProp(buff, "ADD_MDEF", addmdef)
end

function SCR_BUFF_LEAVE_Avoid(self, buff, arg1, arg2, over)
    
    local adddr = GetExProp(buff, "ADD_DR")
    local addmdef = GetExProp(buff, "ADD_MDEF")

    self.DR_BM = self.DR_BM - adddr;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - addmdef;
end



function SCR_BUFF_ENTER_ShieldPush_Debuff(self, buff, arg1, arg2, over)
    local defrate = 0.01 * arg1
  
--    if defadd > self.DEF then
--        defadd = self.DEF;
--    end
  
--    defadd = math.floor(defadd)
    self.DEF_RATE_BM = self.DEF_RATE_BM - defrate;
    SetExProp(buff, 'ADD_DEF_RATE', defrate);
end

function SCR_BUFF_LEAVE_ShieldPush_Debuff(self, buff, arg1, arg2, over)

    local defrate = GetExProp(buff, 'ADD_DEF_RATE');
    self.DEF_RATE_BM = self.DEF_RATE_BM + defrate;  

end


-- Warrior_GuardImpact_Buff
function SCR_BUFF_ENTER_Warrior_GuardImpact_Buff(self, buff, arg1, arg2, over)
    local addCrtATK = self.CRTATK * arg1 * 0.05;
    self.CRTATK_BM = self.CRTATK_BM + addCrtATK;
    SetExProp(buff, 'ADD_CRT_ABIL', addCrtATK);
end

function SCR_BUFF_LEAVE_Warrior_GuardImpact_Buff(self, buff, arg1, arg2, over)
    local addCrtAtk = GetExProp(buff, 'ADD_CRT_ABIL');
    self.CRTATK_BM = self.CRTATK_BM - addCrtAtk;
end


-- Cleric_Bwakaylman_ZombieDef
function SCR_BUFF_ENTER_Cleric_Bwakaylman_ZombieDef(self, buff, arg1, arg2, over)
    local addDef = arg1 * 3;        --arg1 = 'Bokor5' abil Level
    self.DEF_BM = self.DEF_BM + addDef;
    SetExProp(buff, 'ADD_DEF_ABIL', addDef);
end

function SCR_BUFF_LEAVE_Cleric_Bwakaylman_ZombieDef(self, buff, arg1, arg2, over)
    
    local addDef = GetExProp(buff, 'ADD_DEF_ABIL');
    self.DEF_BM = self.DEF_BM - addDef; 
end


function SCR_BUFF_LEAVE_DelayDamage(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        TakeDamage(caster, self, "Linker_HangmansKnot", arg1, "Melee", "Magic", "TrueDamage", HIT_BASIC, HITRESULT_BLOW);
    end
end

-- HangmansKnot_Debuff
function SCR_BUFF_ENTER_HangmansKnot_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_HangmansKnot_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    if IS_PC(self) == true then
        return 0;
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_HangmansKnot_Debuff(self, buff, arg1, arg2, over)

end


-- Hangmansknot_SDR_Debuff
function SCR_BUFF_ENTER_Hangmansknot_SDR_Debuff(self, buff, arg1, arg2, over)
	self.FixedMinSDR_BM = self.FixedMinSDR_BM + 1;
end

function SCR_BUFF_LEAVE_Hangmansknot_SDR_Debuff(self, buff, arg1, arg2, over)
	self.FixedMinSDR_BM = self.FixedMinSDR_BM - 1;
end

-- Wizard_SklCasting_Avoid
function SCR_BUFF_ENTER_Wizard_SklCasting_Avoid(self, buff, arg1, arg2, over)
    
    local addDR = arg2 * 50
    self.DR_BM = self.DR_BM + addDR;
    SetExProp(buff, 'ADD_DR_ABIL', addDR);
    Invalidate(self, "DR");
end

function SCR_BUFF_LEAVE_Wizard_SklCasting_Avoid(self, buff, arg1, arg2, over)

    local addDR = GetExProp(buff, 'ADD_DR_ABIL');
    self.DR_BM = self.DR_BM - addDR;
    Invalidate(self, "DR");
end

-- GravityPole_Def_Debuff
function SCR_BUFF_ENTER_GravityPole_Def_Debuff(self, buff, arg1, arg2, over)
    local addDef = arg2 * 0.04;
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - addDef;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - addDef;
    
    SetExProp(buff, 'ADD_DEF_ABIL', addDef);
    SetExProp(buff, 'ADD_MDEF_ABIL', addDef);
    
    Invalidate(self, "DEF");
    Invalidate(self, "MDEF");
end

function SCR_BUFF_LEAVE_GravityPole_Def_Debuff(self, buff, arg1, arg2, over)
    local addDef = GetExProp(buff, 'ADD_DEF_ABIL');
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + addDef;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + addDef;
    
    Invalidate(self, "DEF");
    Invalidate(self, "MDEF");
end

function SCR_BUFF_ENTER_GravityPolePVP_Debuff(self, buff, arg1, arg2, over)
local addmspd = 20;
    self.MSPD_BM = self.MSPD_BM - addmspd
    SetExProp(buff, "ADD_MSPD", addmspd)
end

function SCR_BUFF_LEAVE_GravityPolePVP_Debuff(self, buff, arg1, arg2, over)
    local addmspd = GetExProp(buff, "ADD_MSPD")
    self.MSPD_BM = self.MSPD_BM + addmspd
end


-- murmillo_helmet
function SCR_BUFF_ENTER_murmillo_helmet(self, buff, arg1, arg2, over)
    --RunScript('SCR_MURMILLO_HELMET_EQUIP', self);
    --SetZoneOutTxScp(self, 'SCR_MURMILLO_HELMET_UNEQUIP');
    
    EquipDummyItemSpot(self, self, 10001, 'HELMET', 0);
    
    local addmaspd = 5
    
    self.MSPD_BM = self.MSPD_BM - addmaspd
    
    SetExProp(buff, "ADD_MSPD", addmaspd)
end

function SCR_BUFF_LEAVE_murmillo_helmet(self, buff, arg1, arg2, over)
    --RemoveZoneOutTxScp(self, 'SCR_MURMILLO_HELMET_UNEQUIP');
    --RunScript('SCR_MURMILLO_HELMET_UNEQUIP', self);

    EquipDummyItemSpot(self, self, 0, 'HELMET', 0);
    ChangeSkillAniName(self, 'Normal_Attack', 'None');
    
    local addmaspd = GetExProp(buff, "ADD_MSPD")
    
    self.MSPD_BM = self.MSPD_BM + addmaspd
end

function SCR_MURMILLO_HELMET_EQUIP(self)
    local tx = TxBegin(self);
    local equipItem = GetEquipItem(self, 'HELMET'); 
    if equipItem ~= nil then
        if equipItem.ClassName == 'murmillo_helmet' then
            TxTakeItemByObject(tx, equipItem, 1);
        end
    end
    TxGiveEquipItem(tx, 'HELMET', 'murmillo_helmet', 0);
    local ret = TxCommit(tx);
    
end

function SCR_MURMILLO_HELMET_UNEQUIP(self)
    local equipItem = GetEquipItem(self, 'HELMET');
    if equipItem == nil then
        return;
    end

    if equipItem.ClassName == 'NoHelmet' then
        return;
    end

    local tx = TxBegin(self);
    TxTakeItemByObject(tx, equipItem, 1);   
    local ret = TxCommit(tx);
    
end



function SCR_BUFF_ENTER_BeakMask_Buff(self, buff, arg1, arg2, over)

    EquipDummyItemSpot(self, self, 10002, 'HELMET', 0);
    
    local resposadd = 0;
    
    local abil = GetAbility(self, "PlagueDoctor8")
    if abil ~= nil then
        resposadd = resposadd + abil.Level * 5;
    end
    
    self.ResPoison_BM = self.ResPoison_BM + resposadd;
    
    SetExProp(buff, "ADD_POS", resposadd);  
end

function SCR_BUFF_LEAVE_BeakMask_Buff(self, buff, arg1, arg2, over)

    EquipDummyItemSpot(self, self, 0, 'HELMET', 0);
    
    local resposadd = GetExProp(buff, "ADD_POS");
    
    self.ResPoison_BM = self.ResPoison_BM - resposadd;
end


-- BigHeadMode
function SCR_BUFF_ENTER_BigHeadMode(self, buff, arg1, arg2, over)
    if IsBuffApplied(self, 'Thurisaz_Buff') == 'NO' then
        SetRenderOption(self, "bigheadmode", 1);
    end
    
    local caster = GetBuffCaster(buff)
    local intAdd = 25 + (arg1 - 1) * 5
    local addValue = 60 + (arg1 - 1) * 10 + (arg1 / 3) * (caster.MNA * 0.7) ^ 0.9
    
    local skill = GetSkill(caster, "Thaumaturge_SwellBrain")
    if skill == nil then
        return
    end
    
    local Thaumaturge15_abil = GetAbility(caster, "Thaumaturge15")  -- 1rank Skill Damage add
    if Thaumaturge15_abil ~= nil and skill.Level >= 3 then
        addValue = addValue * (1 + Thaumaturge15_abil.Level * 0.01);
    end
    
    intAdd = math.floor(intAdd)
    
    self.INT_BM = self.INT_BM + intAdd
    self.MATK_BM = self.MATK_BM + addValue;
    
    SetExProp(buff, "ADD_INT", intAdd);
    SetExProp(buff, "ADD_MATK", addValue);
    
    local abilThaumaturge16 = GetAbility(caster, "Thaumaturge16")
    if abilThaumaturge16 ~= nil and abilThaumaturge16.ActiveState == 1 then
    	AddBuff(caster, caster, "QuickCast_Buff", skill.Level, 0, abilThaumaturge16.Level * 3000, 1)
    end
end

function SCR_BUFF_LEAVE_BigHeadMode(self, buff, arg1, arg2, over)
    SetRenderOption(self, "bigheadmode", 0);
    local intAdd = GetExProp(buff, "ADD_INT");
    local addValue = GetExProp(buff, "ADD_MATK");
    self.INT_BM = self.INT_BM - intAdd;
    self.MATK_BM = self.MATK_BM - addValue;
end


function SCR_BUFF_ENTER_R1MovieCharHide(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255.0, 255.0, 255.0, 0, 1, 1)
    SetShadowRender(self, 0);
end

function SCR_BUFF_LEAVE_R1MovieCharHide(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255.0, 255.0, 255.0, 255.0, 1, 1)
    SetShadowRender(self, 1);
end


function SCR_BUFF_ENTER_ArcaneEnergy_Buff(self, buff, arg1, arg2, over)
    local buffArg1, buffArg2 = GetBuffArg(buff);
    local selfMSP = TryGetProp(self, "MSP") - TryGetProp(self, "MSP_BM")
    local addsp = math.floor(selfMSP * (0.03 * buffArg1))
    local addsta = 5 + buffArg1 * 4
    
    self.MSP_BM = self.MSP_BM + addsp;
    self.MaxSta_BM = self.MaxSta_BM + addsta;
    
    SetExProp(buff, 'ADD_SP', addsp);
    SetExProp(buff, 'ADD_STA', addsta);
end

function SCR_BUFF_LEAVE_ArcaneEnergy_Buff(self, buff, arg1, arg2, over)

    local addsp = GetExProp(buff, 'ADD_SP');
    local addsta = GetExProp(buff, 'ADD_STA');

    self.MSP_BM = self.MSP_BM - addsp;
    self.MaxSta_BM = self.MaxSta_BM - addsta;

end

function SCR_BUFF_ENTER_ArcaneEnergy_Debuff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff)
    
    local Oracle1_abil = GetAbility(caster, "Oracle1");
    if Oracle1_abil ~= nil then
        TakeDamage(caster, self, "None", Oracle1_abil.Level, "Holy", "None", "TrueDamage", HIT_HOLY, HITRESULT_BLOW);
    end
end

function SCR_BUFF_LEAVE_ArcaneEnergy_Debuff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_CounterSpell_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_CounterSpell_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_HealingFactor_Buff(self, buff, arg1, arg2, over)
  SetExProp(buff, "HP", self.HP)
end

function SCR_BUFF_UPDATE_HealingFactor_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
   local nowHP = self.HP
   local addHP = arg1 * 10
   if nowHP < GetExProp(buff, 'HP') then
     AddHP(self, 50 + addHP)     
        
     return 1;
   end

    return 1;
end

function SCR_BUFF_LEAVE_HealingFactor_Buff(self, buff, arg1, arg2, over)

end

-- StereaTrofh_Buff
function SCR_BUFF_ENTER_StereaTrofh_Buff(self, buff, arg1, arg2, over)

    local addDefenced_BM = 1;
    SetExProp(buff, 'DEFENCED_BM', addDefenced_BM);
    self.MaxDefenced_BM = self.MaxDefenced_BM + addDefenced_BM;

end

function SCR_BUFF_UPDATE_StereaTrofh_Buff(self, buff, arg1, arg2, RemainTime, ret, over)

    local x, y, z = GetPos(self)
    local isGrassArea = IsGrassSurface(self, x, y, z)
    if isGrassArea == 1 then
        return 1;
    end
    
    return 0;

end

function SCR_BUFF_LEAVE_StereaTrofh_Buff(self, buff, arg1, arg2, over)
    
    local addDefenced_BM = GetExProp(buff, 'DEFENCED_BM');
    self.MaxDefenced_BM = self.MaxDefenced_BM - addDefenced_BM;

end

-- PlantGround_Debuff
function SCR_BUFF_ENTER_PlantGround_Debuff(self, buff, arg1, arg2, over)

    if IS_PC(self) == false and self.GroupName == "Monster" then
        SetExProp_Str(self, 'CHANGE_RACETYPE', self.RaceType)
        self.RaceType = "Forester"
    end

end

function SCR_BUFF_LEAVE_PlantGround_Debuff(self, buff, arg1, arg2, over)

    if IS_PC(self) == false and self.GroupName == "Monster" then
        local racetype = GetExProp_Str(self, 'CHANGE_RACETYPE')
        self.RaceType = racetype
    end

end


--1InchPunch_Debuff
function SCR_BUFF_ENTER_1InchPunch_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local caster = GetBuffCaster(buff);
        local Monk6_abil = GetAbility(caster, "Monk6")
        if Monk6_abil ~= nil then
            AddBuff(caster, self, "UC_silence", Monk6_abil.Level, 0, 5000, 1);
        end
        
        local damage = GET_SKL_DAMAGE(caster, self, 'Monk_1InchPunch');
        local skill = GET_MON_SKILL(caster, 'Monk_1InchPunch'); 
        SetBuffArgs(buff, damage, skill.SkillAtkAdd, 0);
        
end

function SCR_BUFF_UPDATE_1InchPunch_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    
    if IS_PC(self) == true then
        AddSP(self, -(self.MSP * 0.1 * arg1))
    end
    
    local damage, skillAtkAdd = GetBuffArgs(buff);
    if damage > 0 then
        if skillAtkAdd > 0 then
            damage = math.floor((damage + skillAtkAdd) / 2.3)
        end
        
        local from = self;
        local caster = GetBuffCaster(buff);
        if caster ~= nil then
            from = caster;
        end
        
        TakeDamage(from, self, 'None', damage, "Melee", "Melee", "Melee", HIT_BASIC, HITRESULT_NONE, 0, 0);
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_1InchPunch_Debuff(self, buff, arg1, arg2, over)



end

-- Indulgentia_Buff
function SCR_BUFF_ENTER_Indulgentia_Buff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = buff;
    end

    if self.ClassName ~= 'PC' then
        if self.GroupName == "Monster" and self.Faction == "Neutral" then
            return;
        end
    end

  REMOVE_BUFF_BY_LEVEL(self, "Debuff", 3);

end

function SCR_BUFF_LEAVE_Indulgentia_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Catacom_DEF_Debuff(self, buff, arg1, arg2, over)

  local defadd = 0.5
  
  self.DEF_RATE_BM = self.DEF_RATE_BM - defadd
  
  SetExProp(buff, "DEF_ADD", defadd)

end

function SCR_BUFF_LEAVE_Catacom_DEF_Debuff(self, buff, arg1, arg2, over)

  local defadd = GetExProp(buff, "DEF_ADD")
  
  self.DEF_RATE_BM = self.DEF_RATE_BM + defadd

end


function SCR_BUFF_ENTER_Catacom_MDEF_Debuff(self, buff, arg1, arg2, over)


  local mdefadd = 0.5
  
  self.MDEF_RATE_BM = self.MDEF_RATE_BM - mdefadd
  
  SetExProp(buff, "MDEF_ADD", mdefadd)

end

function SCR_BUFF_LEAVE_Catacom_MDEF_Debuff(self, buff, arg1, arg2, over)

  local mdefadd = GetExProp(buff, "MDEF_ADD")
  
  self.MDEF_RATE_BM = self.MDEF_RATE_BM + mdefadd

end


function SCR_BUFF_ENTER_Catacom_ATK_Debuff(self, buff, arg1, arg2, over)

  local atkadd = 0.5
  
  self.PATK_RATE_BM = self.PATK_RATE_BM - atkadd
  
  SetExProp(buff, "PATK_ADD", atkadd)


end

function SCR_BUFF_LEAVE_Catacom_ATK_Debuff(self, buff, arg1, arg2, over)

  local atkadd = GetExProp(buff, "PATK_ADD")
  
  self.PATK_RATE_BM = self.PATK_RATE_BM + atkadd

end


function SCR_BUFF_ENTER_Catacom_MATK_Debuff(self, buff, arg1, arg2, over)

  local matkadd = 0.5
  
  self.MATK_RATE_BM = self.MATK_RATE_BM - matkadd
  
  SetExProp(buff, "MATK_ADD", matkadd)

end

function SCR_BUFF_LEAVE_Catacom_MATK_Debuff(self, buff, arg1, arg2, over)

  local matkadd = GetExProp(buff, "MATK_ADD")
  
  self.MATK_RATE_BM = self.MATK_RATE_BM + matkadd

end


function SCR_BUFF_ENTER_Catacom_MSPD_Debuff(self, buff, arg1, arg2, over)

  local mspdadd = 7
  
  self.MSPD_BM = self.MSPD_BM - mspdadd
  
  SetExProp(buff, "MSPD_ADD", mspdadd)

end

function SCR_BUFF_LEAVE_Catacom_MSPD_Debuff(self, buff, arg1, arg2, over)

  local mspdadd = GetExProp(buff, "MSPD_ADD")
  
  self.MSPD_BM = self.MSPD_BM + mspdadd

end


-- ItemEquip_DummyRH
function SCR_BUFF_ENTER_ItemEquip_DummyRH(self, buff, arg1, arg2, over)
    EquipDummyItemSpot(self, self, arg1, 'RH', 0) 
end

function SCR_BUFF_LEAVE_ItemEquip_DummyRH(self, buff, arg1, arg2, over)
    EquipDummyItemSpot(self, self, 0, 'RH', 0)
end

-- ItemEquip_DummyLH
function SCR_BUFF_ENTER_ItemEquip_DummyLH(self, buff, arg1, arg2, over)
    EquipDummyItemSpot(self, self, arg1, 'LH', 0)
end

function SCR_BUFF_LEAVE_ItemEquip_DummyLH(self, buff, arg1, arg2, over)
    EquipDummyItemSpot(self, self, 0, 'LH', 0)
end




function SCR_BUFF_ENTER_Fumigate_Buff(self, buff, arg1, arg2, over)

  REMOVE_BUFF_BY_LEVEL(self, "Debuff", 4);
end

function SCR_BUFF_LEAVE_Fumigate_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Disenchant_Debuff(self, buff, arg1, arg2, over)
    REMOVE_BUFF_BY_LEVEL_AND_RANDOM(self, "Buff", 4, arg1 * 10, 1);
    PlaySound(self, 'skl_eff_debuff_disenchant')

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local PlagueDoctor11_abil = GetAbility(caster, "PlagueDoctor11");
        if PlagueDoctor11_abil ~= nil then
            local buffList, listCnt = GetBuffListByStringProp(self, "Group1", 'Debuff');
            for i = 1 , listCnt do
                local buff = buffList[i];
                local prop = GetExProp(buff, "Disenchant_Debuff");
                
                if buff.Lv < 3 and prop == 0 then
                    buff.Lv = buff.Lv + 1;
                    SetExProp(buff, "Disenchant_Debuff", 1);
                end
            end
        end
        
        local PlagueDoctor12_abil = GetAbility(caster, "PlagueDoctor12");
        if caster ~= nil and PlagueDoctor12_abil ~= nil then
            AddBuff(caster, self, 'Disenchant_Debuff_Abil', 1, 0, PlagueDoctor12_abil.Level * 5000, 1)
        end
    end
    

end

function SCR_BUFF_LEAVE_Disenchant_Debuff(self, buff, arg1, arg2, over)
--  local caster = GetBuffCaster(buff);
--  local abil = GetAbility(caster, "PlagueDoctor11");
--  if  abil ~= nil then
--      local buffList, listCnt = GetBuffListByStringProp(self, "Group1", 'Debuff');
--      for i = 1 , listCnt do
--          local buff = buffList[i];
--          local prop = GetExProp(buff, "Disenchant_Debuff");
--          if prop == 1 then
--              buff.Lv = buff.Lv - 1;
--          end
--      end
--  end
end

function SCR_BUFF_ENTER_Fumigate_Buff_ImmuneAbil(self, buff, arg1, arg2, over)
    SetExProp(self, "ADD_DEBUFF_IMMUNE", arg1 * 500)
end

function SCR_BUFF_LEAVE_Fumigate_Buff_ImmuneAbil(self, buff, arg1, arg2, over)
    DelExProp(self, "ADD_DEBUFF_IMMUNE")
end

function SCR_BUFF_ENTER_Fumigate_Buff_ResAbil(self, buff, arg1, arg2, over)
    local resposadd = math.floor(self.ResPoison * arg1 * 0.1);
    
    self.ResPoison_BM = self.ResPoison_BM + resposadd;
    
    SetExProp(buff, "ADD_POS", resposadd);
end

function SCR_BUFF_LEAVE_Fumigate_Buff_ResAbil(self, buff, arg1, arg2, over)
    local resposadd = GetExProp(buff, "ADD_POS");
    
    self.ResPoison_BM = self.ResPoison_BM - resposadd;
end

function SCR_BUFF_ENTER_Cyclone_Buff_ImmuneAbil(self, buff, arg1, arg2, over)
    local skill = GetSkill(self, "Doppelsoeldner_Cyclone")
    if skill == nil then
        return
    end
    
    if skill.Level >= 3 then
        SetExProp(self, "ADD_CYCLONE_IMMUNE", arg1 * 1500)
    end
end

function SCR_BUFF_LEAVE_Cyclone_Buff_ImmuneAbil(self, buff, arg1, arg2, over)
    DelExProp(self, "ADD_CYCLONE_IMMUNE")
end



--Looting buff
function SCR_BUFF_ENTER_Looting_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_Looting_Buff(self, buff, arg1, arg2, over)

end

-- DirtyWall_Debuff
function SCR_BUFF_ENTER_DirtyWall_Debuff(self, buff, arg1, arg2, over)
--    SetExProp(buff, "MAX_HP", self.MHP)
    SetExProp(buff, "REMOVE_MHP", 0)
end

function SCR_BUFF_UPDATE_DirtyWall_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    PlaySound(self, "skl_eff_debuff_rotten_s")
    
    local addMHP = math.floor(self.MHP * 0.02);
    
    if addMHP < 1 then
        addMHP = 1
    end
    
    if self.MHP > 10 and self.MHP > addMHP then
        if self.MHP - addMHP < 10 then
            addMHP = addMHP - (self.MHP - addMHP);
        end
        
        self.MHP_BM = self.MHP_BM - addMHP;
        local before = GetExProp(buff, "REMOVE_MHP");
        SetExProp(buff, "REMOVE_MHP", before + addMHP);
        
        InvalidateStates(self);
        AddHP(self, -1);
    end
    
    return 1
end

function SCR_BUFF_LEAVE_DirtyWall_Debuff(self, buff, arg1, arg2, over)
    local before = GetExProp(buff, "REMOVE_MHP");
    self.MHP_BM = self.MHP_BM + before;
    InvalidateStates(self);
--  local tmp = self.MHP;
end

-- HigherRotten_Debuff
function SCR_BUFF_ENTER_HigherRotten_Debuff(self, buff, arg1, arg2, over)
--    SetExProp(buff, "MAX_HP", self.MHP)
    SetExProp(buff, "REMOVE_MHP", 0)
end

function SCR_BUFF_UPDATE_HigherRotten_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    PlaySound(self, "skl_eff_debuff_rotten_l")
    local addMHP = math.floor(self.MHP * 0.025);
    
    if addMHP < 1 then
        addMHP = 1
    end
    
    if self.MHP > 10 and self.MHP > addMHP then
        if self.MHP - addMHP < 10 then
            addMHP = addMHP - (self.MHP - addMHP);
        end
        
        self.MHP_BM = self.MHP_BM - addMHP;
        local before = GetExProp(buff, "REMOVE_MHP");
        SetExProp(buff, "REMOVE_MHP", before + addMHP);
        
        InvalidateStates(self);
        AddHP(self, -1);
    end
    
    return 1

end

function SCR_BUFF_LEAVE_HigherRotten_Debuff(self, buff, arg1, arg2, over)
    local before = GetExProp(buff, "REMOVE_MHP");
    self.MHP_BM = self.MHP_BM + before;
    Invalidate(self, "MHP");
    local tmp = self.MHP;
end

function SCR_BUFF_ENTER_Ngadhundi_Debuff(self, buff, arg1, arg2, over)
--    SetExProp(buff, "MAX_HP", self.MHP)
    SetExProp(buff, "REMOVE_MHP", 0)
end

function SCR_BUFF_UPDATE_Ngadhundi_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    
    
    local addMHP = math.floor(self.MHP * 0.02);
    
    if addMHP < 1 then
        addMHP = 1
    end
    
    if self.MHP > 10 and self.MHP > addMHP then
        if self.MHP - addMHP < 10 then
            addMHP = addMHP - (self.MHP - addMHP);
        end
        
        self.MHP_BM = self.MHP_BM - addMHP;
        local before = GetExProp(buff, "REMOVE_MHP");
        SetExProp(buff, "REMOVE_MHP", before + addMHP);
        
        InvalidateStates(self);
        AddHP(self, -1);
    end
    
    return 1

end

function SCR_BUFF_LEAVE_Ngadhundi_Debuff(self, buff, arg1, arg2, over)
    local before = GetExProp(buff, "REMOVE_MHP");
    self.MHP_BM = self.MHP_BM + before;
    Invalidate(self, "MHP");
    local tmp = self.MHP;   -- ???????????
end

-- UnlockChest_Buff
function SCR_BUFF_ENTER_UnlockChest_Buff(self, buff, arg1, arg2, over)
    SetExProp(self, "UnlockChest_Buff", arg1)
end 

function SCR_BUFF_LEAVE_UnlockChest_Buff(self, buff, arg1, arg2, over)
    DelExProp(self, "UnlockChest_Buff", arg1)
end


--ServantSP_Buff
function SCR_BUFF_ENTER_ServantSP_Buff(self, buff, arg1, arg2, over)
    if GetObjType(self) ~= OT_PC then
        return;
    end

    local lv = 1;
    
    local caster = GetBuffCaster(buff)
    local owner = GetOwner(caster)
    if owner ~= nil then
        lv = GetExProp(owner, "SORCERER_SERVANTSKILLLV")
    end
    
    local addrsptime = 4000 + lv * 1000
    
    self.RSPTIME_BM = self.RSPTIME_BM + addrsptime
    
    SetExProp(buff, "ADD_RSPTIME", addrsptime)
    
end

function SCR_BUFF_LEAVE_ServantSP_Buff(self, buff, arg1, arg2, over)
    
    if GetObjType(self) ~= OT_PC then
        return;
    end

    local addrsptime = GetExProp(buff, "ADD_RSPTIME")

    self.RSPTIME_BM = self.RSPTIME_BM - addrsptime

end

--ServantSR_Buff
function SCR_BUFF_ENTER_ServantSR_Buff(self, buff, arg1, arg2, over)
    if GetObjType(self) ~= OT_PC then
        return;
    end

    local lv = 1
    
    local caster = GetBuffCaster(buff)
    local owner = GetOwner(caster)
    if owner ~= nil then
        lv = GetExProp(owner, "SORCERER_SERVANTSKILLLV")
    end
    
    local addsr = lv
    
    self.SR_BM = self.SR_BM + addsr
    
    SetExProp(buff, "ADD_SR", addsr)

end

function SCR_BUFF_LEAVE_ServantSR_Buff(self, buff, arg1, arg2, over)
    
    if GetObjType(self) ~= OT_PC then
        return;
    end

    local addsr = GetExProp(buff, "ADD_SR")

    self.SR_BM = self.SR_BM - addsr

end

--ServantSTA_Buff
function SCR_BUFF_ENTER_ServantSTA_Buff(self, buff, arg1, arg2, over)
    if GetObjType(self) ~= OT_PC then
        return;
    end
    local lv = 1
    
    local caster = GetBuffCaster(buff)
    local owner = GetOwner(caster)
    if owner ~= nil then
        lv = GetExProp(owner, "SORCERER_SERVANTSKILLLV")
    end
    
    SetExProp(buff, "SORCERER_SERVANTSKILLLV", lv)

end

function SCR_BUFF_UPDATE_ServantSTA_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if GetObjType(self) ~= OT_PC then
        return 0;
    end
    local lv = GetExProp(buff, "SORCERER_SERVANTSKILLLV")
    AddStamina(self, lv * 100)
    return 1;
end

function SCR_BUFF_LEAVE_ServantSTA_Buff(self, buff, arg1, arg2, over)

end

--ServantMDEF_Buff
function SCR_BUFF_ENTER_ServantMDEF_Buff(self, buff, arg1, arg2, over)
    if GetObjType(self) ~= OT_PC then
        return;
    end
    local lv = 1
    
    local caster = GetBuffCaster(buff)
    local owner = GetOwner(caster)
    if owner ~= nil then
        lv = GetExProp(owner, "SORCERER_SERVANTSKILLLV")
    end
    
    local addmdef = lv * 10
    
    self.MDEF_BM = self.MDEF_BM + addmdef
    
    SetExProp(buff, "ADD_MDEF", addmdef)

end

function SCR_BUFF_LEAVE_ServantMDEF_Buff(self, buff, arg1, arg2, over)
    
    if GetObjType(self) ~= OT_PC then
        return;
    end

    local addmdef = GetExProp(buff, "ADD_MDEF")

    self.MDEF_BM = self.MDEF_BM - addmdef

end

--ServantDARKATK_Buff
function SCR_BUFF_ENTER_ServantDARKATK_Buff(self, buff, arg1, arg2, over)
    
    if GetObjType(self) ~= OT_PC then
        return;
    end

    local lv = 1
    
    local caster = GetBuffCaster(buff)
    local owner = GetOwner(caster)
    if owner ~= nil then
        lv = GetExProp(owner, "SORCERER_SERVANTSKILLLV")
    end
    
    local adddarkatk = lv * 10
    
    self.Dark_Atk_BM = self.Dark_Atk_BM + adddarkatk
    
    SetExProp(buff, "ADD_DARKATK", adddarkatk)

end

function SCR_BUFF_LEAVE_ServantDARKATK_Buff(self, buff, arg1, arg2, over)

    if GetObjType(self) ~= OT_PC then
        return;
    end

    local adddarkatk = GetExProp(buff, "ADD_DARKATK")

    self.Dark_Atk_BM = self.Dark_Atk_BM - adddarkatk

end


function SCR_BUFF_ENTER_GM_Regenerate_Buff(self, buff, arg1, arg2, over)

    local addrhp = 100;
    local addrsp = 100;
    local addtime = 5000;

    if IS_PC(self) == true then
        self.RHP_BM = self.RHP_BM + addrhp;
        self.RSP_BM = self.RSP_BM + addrsp;
        self.RHPTIME_BM = self.RHPTIME_BM + addtime
        self.RSPTIME_BM = self.RSPTIME_BM + addtime
    end

    SetExProp(buff, "ADD_RHP", addrhp);
    SetExProp(buff, "ADD_RSP", addrhp);
    SetExProp(buff, "ADD_RTIME", addtime);

end

function SCR_BUFF_LEAVE_GM_Regenerate_Buff(self, buff, arg1, arg2, over)

    local addrhp = GetExProp(buff, "ADD_RHP");
    local addrsp = GetExProp(buff, "ADD_RSP");
    local addtime = GetExProp(buff, "ADD_RTIME")
    
    if IS_PC(self) == true then
        self.RHP_BM = self.RHP_BM - addrhp;
        self.RSP_BM = self.RSP_BM - addrsp;
        self.RHPTIME_BM = self.RHPTIME_BM - addtime
        self.RSPTIME_BM = self.RSPTIME_BM - addtime
    end

end

function SCR_BUFF_ENTER_GM_Stat_Buff(self, buff, arg1, arg2, over)

    local stradd = math.floor(5 + self.STR * 0.1)
    local conadd = math.floor(5 + self.CON * 0.1)
    local intadd = math.floor(5 + self.INT * 0.1)
    local mnaadd = math.floor(5 + self.MNA * 0.1)
    local dexadd = math.floor(5 + self.DEX * 0.1)
  
    self.STR_BM = self.STR_BM + stradd
    self.CON_BM = self.CON_BM + conadd
    self.INT_BM = self.INT_BM + intadd
    self.MNA_BM = self.MNA_BM + mnaadd
    self.DEX_BM = self.DEX_BM + dexadd

    SetExProp(buff, "ADD_STR", stradd);
    SetExProp(buff, "ADD_CON", conadd);
    SetExProp(buff, "ADD_INT", intadd);
    SetExProp(buff, "ADD_MNA", mnaadd);
    SetExProp(buff, "ADD_DEX", dexadd);

end

function SCR_BUFF_LEAVE_GM_Stat_Buff(self, buff, arg1, arg2, over)

    local stradd = GetExProp(buff, "ADD_STR");
    local conadd = GetExProp(buff, "ADD_CON");
    local intadd = GetExProp(buff, "ADD_INT");
    local mnaadd = GetExProp(buff, "ADD_MNA");
    local dexadd = GetExProp(buff, "ADD_DEX");

    self.STR_BM = self.STR_BM - stradd
    self.CON_BM = self.CON_BM - conadd
    self.INT_BM = self.INT_BM - intadd
    self.MNA_BM = self.MNA_BM - mnaadd
    self.DEX_BM = self.DEX_BM - dexadd

end

function SCR_BUFF_ENTER_GM_Cooldown_Buff(self, buff, arg1, arg2, over)
    InvalidateSkillCoolDown(self);
end

function SCR_BUFF_LEAVE_GM_Cooldown_Buff(self, buff, arg1, arg2, over)
    InvalidateSkillCoolDown(self);
end

function SCR_BUFF_ENTER_GM_ATK_Buff(self, buff, arg1, arg2, over)

    local patkadd = 0.1
    local matkadd = 0.1
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + patkadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM + matkadd;
    
    SetExProp(buff, "ADD_PATK", patkadd);
    SetExProp(buff, "ADD_MATK", matkadd);
    
end

function SCR_BUFF_LEAVE_GM_ATK_Buff(self, buff, arg1, arg2, over)

    local patkadd = GetExProp(buff, "ADD_PATK");
    local matkadd = GetExProp(buff, "ADD_MATK");
    
    self.PATK_RATE_BM = self.PATK_RATE_BM - patkadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM - matkadd;
    
end

function SCR_BUFF_ENTER_GM_DEF_Buff(self, buff, arg1, arg2, over)

    local defadd = 0.1
    local mdefadd = 0.1
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + mdefadd;
    
    SetExProp(buff, "ADD_DEF", defadd);
    SetExProp(buff, "ADD_MDEF", mdefadd);
    
end

function SCR_BUFF_LEAVE_GM_DEF_Buff(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");
    local mdefadd = GetExProp(buff, "ADD_MDEF");
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - mdefadd;

end

function SCR_BUFF_ENTER_GM_EXP_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_GM_EXP_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_ScullSwing_Debuff(self, buff, arg1, arg2, over)

    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    --ShowEmoticon(self, 'I_emo_armorbreak', 0)
    
    local defrate = 0.12
    local jumpadd = 0
    
    local caster = GetBuffCaster(buff)
    local abil = GetAbility(caster, "Highlander27")
    if abil ~= nil and IS_PC(self) == true then
        jumpadd = 1
        self.Jumpable = self.Jumpable - jumpadd;
    end
    
--  if self.DEF < defadd then
--      defadd = self.DEF
--  end
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defrate;
    SetExProp(buff, "ADD_DEF_RATE", defrate);
    SetExProp(buff, "ADD_JUMP", jumpadd);
    
end

function SCR_BUFF_LEAVE_ScullSwing_Debuff(self, buff, arg1, arg2, over)

    local defrate = GetExProp(buff, "ADD_DEF_RATE");
    local jumpadd = GetExProp(buff, "ADD_JUMP");
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + defrate;
    Invalidate(self, "DEF");
    
    if IS_PC(self) == true then
        self.Jumpable = self.Jumpable + jumpadd;
    end
    
end


--giantswing_Debuff

function SCR_BUFF_ENTER_giantswing_Debuff(self, buff, arg1, arg2, over)
    
    local hraddrate = 0.8;
    
    local hradd = math.floor(self.HR * hraddrate)
    
    self.HR_BM = self.HR_BM - hradd;
    
    SetExProp(buff, "ADD_HR", hradd);
    
end


function SCR_BUFF_LEAVE_giantswing_Debuff(self, buff, arg1, arg2, over)
    local hradd = GetExProp(buff, "ADD_HR");
    self.HR_BM = self.HR_BM + hradd;
end



function SCR_BUFF_ENTER_Arrest(self, buff, arg1, arg2, over)    
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local caster = GetBuffCaster(buff);
    local abil = GetAbility(caster, "Squire9")
    local defadd = 0;
    
    if abil ~= nil then

        defadd = abil.Level * 0.02
    end
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
    
    SetExProp(buff, "ADD_DEF", defadd);
    
end

function SCR_BUFF_LEAVE_Arrest(self, buff, arg1, arg2, over)    
    local defadd = GetExProp(buff, "ADD_DEF");
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SkillCancel(caster)
    end
end


-- DashRun
function SCR_BUFF_ENTER_DashRun(self, buff, arg1, arg2, over)
    self.DashRun = arg1;
    
    local is_barbarian = GetJobGradeByName(self, 'Char1_6')
    if is_barbarian >= 2 then
        local babaAbil_28 = GetAbility(self, 'Barbarian28');
        if babaAbil_28 ~= nil then
            RunScriptByOwnerProp(self, 'DashRun', arg1, 1000, 'ADD_BUFF', self, self, 'ScudInstinct_Buff', 1, 0, 0, 1);
        end
    end
end

function SCR_BUFF_LEAVE_DashRun(self, buff, arg1, arg2, over)
    self.DashRun = 0;
end



function SCR_BUFF_ENTER_Preparation_Buff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    local PrepaSklLv = GetSkill(caster, 'Fencer_Preparation');
    if PrepaSklLv ~= nil then
        SetBuffArgs(buff, PrepaSklLv.Level, 0, 0);
    end
end

function SCR_BUFF_LEAVE_Preparation_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_Preparation_Buff_End(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Preparation_Buff_End(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_Flanconnade_Buff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    local FlanconnadeSklLv = GetSkill(caster, 'Fencer_Flanconnade');
    if FlanconnadeSklLv ~= nil then
        SetBuffArgs(buff, FlanconnadeSklLv.Level, 0, 0);
    end
end

function SCR_BUFF_LEAVE_Flanconnade_Buff(self, buff, arg1, arg2, over)

end

-- ItemAwakening_ATK_Buff
function SCR_BUFF_ENTER_ItemAwakening_ATK_Buff(self, buff, arg1, arg2, over)
    local patkadd = 0.2 * arg1
    local matkadd = 0.2 * arg1
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + patkadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM + matkadd;
    
    SetExProp(buff, "ADD_PATK", patkadd);
    SetExProp(buff, "ADD_MATK", matkadd);
end

function SCR_BUFF_LEAVE_ItemAwakening_ATK_Buff(self, buff, arg1, arg2, over)

    local patkadd = GetExProp(buff, "ADD_PATK");
    local matkadd = GetExProp(buff, "ADD_MATK");
    
    self.PATK_RATE_BM = self.PATK_RATE_BM - patkadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM - matkadd;
    
end

-- CrossFire_Debuff
function SCR_BUFF_ENTER_CrossFire_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_UPDATE_CrossFire_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    
    if caster ~= nil then
        TakeDamage(caster, self, "None", arg1, "Fire", "None", "TrueDamage", HIT_FIRE, HITRESULT_BLOW, 0, 0);
        return 1;
    end
    
    return 0;

end

function SCR_BUFF_LEAVE_CrossFire_Debuff(self, buff, arg1, arg2, over)

end


-- Cleric_Collision_Debuff
function SCR_BUFF_ENTER_Cleric_Collision_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local adddef = 0.1

    self.DEF_RATE_BM = self.DEF_RATE_BM - adddef;
    SetExProp(buff, "ADD_DEF", adddef);
end

function SCR_BUFF_LEAVE_Cleric_Collision_Debuff(self, buff, arg1, arg2, over)

    local adddef = GetExProp(buff, "ADD_DEF");
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + adddef;

end


-- Web_FlyObject
function SCR_BUFF_ENTER_Web_FlyObject(self, buff, arg1, arg2, over)

    if IS_PC(self) == true then
        return 0;
    end
    if self.MoveType == "Flying" then
        SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
        local caster = GetBuffCaster(buff);
        if caster ~= nil then
            local owner = GetOwner(caster)
            if owner ~= nil then
                local Hunter4_abil = GetAbility(owner, "Hunter4")
                if Hunter4_abil ~= nil then
                    SetBuffArgs(buff, Hunter4_abil.Level, 0, 0);
                end
            end
        end
    end

end

function SCR_BUFF_UPDATE_Web_FlyObject(self, buff, arg1, arg2, RemainTime, ret, over)

    if IS_PC(self) == true or self.MoveType ~= "Flying" then
        return 0;
      end
      
      local caster = GetBuffCaster(buff);
    if caster ~= nil then
      local owner = GetOwner(caster)
      if owner ~= nil then
        local damage = GET_SKL_DAMAGE(owner, self, 'Hunter_Snatching');
        local skill = GET_MON_SKILL(owner, 'Hunter_Snatching');
        TakeDamage(owner, self, skill.ClassName, damage, "Melee", "Strike", "Melee", HIT_POISON, HITRESULT_BLOW, 0, 0);
      end
    end

    return 1;
end

function SCR_BUFF_LEAVE_Web_FlyObject(self, buff, arg1, arg2, over)

end

--ShootDown_Debuff
function SCR_BUFF_ENTER_ShootDown_Debuff(self, buff, arg1, arg2, over)
    if IS_PC(self) ~= true then
        if self.MoveType == "Flying" then
            SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
        end
    end
end

function SCR_BUFF_LEAVE_ShootDown_Debuff(self, buff, arg1, arg2, over)

end


-- ShieldShoving_Debuff
function SCR_BUFF_ENTER_ShieldShoving_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil and self.MonRank ~= 'Boss' then
        RunScript('SCR_SHIELDSHOVING', self, caster)
    end
end

function SCR_SHIELDSHOVING(self, caster)
    local casterx, casterz = GetDir(caster)
    local casterDir = DirToAngle(casterx, casterz)
    
    sleep(300);
    
    if IS_PC(self) == false then
        HoldMonScp(self)
    end
    
    SetDirectionByAngle(self, casterDir)
    
    if IS_PC(self) == false then
        sleep(1500);
        UnHoldMonScp(self)
    end
end

function SCR_BUFF_LEAVE_ShieldShoving_Debuff(self, buff, arg1, arg2, over)

end

-- ShieldBash_Debuff
function SCR_BUFF_ENTER_ShieldBash_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);

--  local beforeCon = self.CON;
    local beforeInt = self.INT;
    local beforeStr = self.STR;
    local beforeMna = self.MNA;
    local beforeDex = self.DEX;
    
--  SetExProp(buff, 'BEFORE_CON', beforeCon);
    SetExProp(buff, 'BEFORE_INT', beforeInt);
    SetExProp(buff, 'BEFORE_STR', beforeStr);
    SetExProp(buff, 'BEFORE_MNA', beforeMna);
    SetExProp(buff, 'BEFORE_DEX', beforeDex);
    
--    local afterCon = self.STR;
--    local afterInt = self.CON;
--    local afterStr = self.DEX;
--    local afterMna = self.INT;
--    local afterDex = self.MNA;
    
    local afterInt = self.STR;
    local afterStr = self.DEX;
    local afterMna = self.INT;
    local afterDex = self.MNA;
    
--  self.CON_BM = self.CON_BM - beforeCon + afterCon;
    self.INT_BM = self.INT_BM - beforeInt + afterInt;
    self.STR_BM = self.STR_BM - beforeStr + afterStr;
    self.MNA_BM = self.MNA_BM - beforeMna + afterMna;
    self.DEX_BM = self.DEX_BM - beforeDex + afterDex;
    
--  SetExProp(buff, 'AFTER_CON', afterCon);
    SetExProp(buff, 'AFTER_INT', afterInt);
    SetExProp(buff, 'AFTER_STR', afterStr);
    SetExProp(buff, 'AFTER_MNA', afterMna);
    SetExProp(buff, 'AFTER_DEX', afterDex);

end

function SCR_BUFF_LEAVE_ShieldBash_Debuff(self, buff, arg1, arg2, over)

    --local beforeCon = GetExProp(buff, 'BEFORE_CON');
    local beforeInt = GetExProp(buff, 'BEFORE_INT');
    local beforeStr = GetExProp(buff, 'BEFORE_STR');
    local beforeMna = GetExProp(buff, 'BEFORE_MNA');
    local beforeDex = GetExProp(buff, 'BEFORE_DEX');
    
    
    --local afterCon = GetExProp(buff, 'AFTER_CON');
    local afterInt = GetExProp(buff, 'AFTER_INT');
    local afterStr = GetExProp(buff, 'AFTER_STR');
    local afterMna = GetExProp(buff, 'AFTER_MNA');
    local afterDex = GetExProp(buff, 'AFTER_DEX');

    --self.CON_BM = self.CON_BM - afterCon + beforeCon;
    self.INT_BM = self.INT_BM - afterInt + beforeInt;
    self.STR_BM = self.STR_BM - afterStr + beforeStr;
    self.MNA_BM = self.MNA_BM - afterMna + beforeMna;
    self.DEX_BM = self.DEX_BM - afterDex + beforeDex;
    
end

function SCR_BUFF_ENTER_UmboBlow_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_UmboBlow_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_CrossCut_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_UPDATE_CrossCut_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local damage = GET_SKL_DAMAGE(caster, self, 'Highlander_CrossCut');
        local skill = GET_MON_SKILL(caster, 'Highlander_CrossCut');
        
        damage = math.floor((damage + skill.SkillAtkAdd) / 2.3)
        
        TakeDamage(caster, self, "None", damage, "None", "None", "TrueDamage", HIT_BLEEDING, HITRESULT_BLOW, 0, 0);
    end 
    
    return 1;
end

function SCR_BUFF_LEAVE_CrossCut_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_VerticalSlash_Debuff(self, buff, arg1, arg2, over)

    if self.Size ~= "M" and self.Size ~= "L" then
        return ;
    end
    
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local defadd = 0;
    
    if self.Size == 'M' then
--        defadd = math.floor(self.DEF * 0.8)
        defadd = 0.8
    elseif self.Size == 'L' then
--        defadd = math.floor(self.DEF)
        defadd = 1
    end
    
    SetExProp(buff, "ADD_DEF", defadd)
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
end

function SCR_BUFF_UPDATE_VerticalSlash_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    if self.Size ~= "M" and self.Size ~= "L" then
        return 0;
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_VerticalSlash_Debuff(self, buff, arg1, arg2, over)
    local defadd = GetExProp(buff, "ADD_DEF")
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;
end

function SCR_BUFF_ENTER_HighKick_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_HighKick_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Slithering_Debuff(self, buff, arg1, arg2, over)
    local lv = arg1;
    local addMSPD = lv * 4;
    local addDR = lv * 15;
    
    self.MSPD_BM = self.MSPD_BM - addMSPD;
    self.DR_BM = self.DR_BM - addDR;
    
    SetExProp(buff, "ADD_MSPD", addMSPD);
    SetExProp(buff, "ADD_DR", addDR);
    
--    Invalidate(self, "MSPD");
end

function SCR_BUFF_LEAVE_Slithering_Debuff(self, buff, arg1, arg2, over)
    local addMPSD = GetExProp(buff, "ADD_MSPD");
    local addDR = GetExProp(buff, "ADD_DR");
    
    self.MSPD_BM = self.MSPD_BM + addMPSD;
    self.DR_BM = self.DR_BM + addDR;
    
--    Invalidate(self, "MSPD");
end

function SCR_BUFF_ENTER_Conviction_Debuff(self, buff, arg1, arg2, over)

    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local resiceadd = 0;
    local resfireadd = 0;
    local reslightadd = 0;
    local resposadd = 0;
    local researthadd = 0;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        resiceadd = arg1 * 20;
        resfireadd = arg1 * 20;
        reslightadd = arg1 * 20;
        resposadd = arg1 * 20;
        researthadd = arg1 * 20;
    end
    
    if IS_PC(self) == true then
        self.ResIce_BM = self.ResIce_BM - resiceadd
        self.ResFire_BM = self.ResFire_BM - resfireadd
        self.ResLightning_BM = self.ResLightning_BM - reslightadd
        self.ResPoison_BM = self.ResPoison_BM - resposadd
        self.ResEarth_BM = self.ResEarth_BM - researthadd
    else
        self.Ice_Def_BM = self.Ice_Def_BM - resiceadd
        self.Fire_Def_BM = self.Fire_Def_BM - resfireadd
        self.Lightning_Def_BM = self.Lightning_Def_BM - reslightadd
        self.Poison_Def_BM = self.Poison_Def_BM - resposadd
        self.Earth_Def_BM = self.Earth_Def_BM - researthadd
    end
    
    SetExProp(buff, "ADD_ICE", resiceadd);
    SetExProp(buff, "ADD_FIRE", resfireadd);
    SetExProp(buff, "ADD_LIGHT", reslightadd);
    SetExProp(buff, "ADD_POS", resposadd);
    SetExProp(buff, "ADD_EARTH", researthadd);
end

function SCR_BUFF_LEAVE_Conviction_Debuff(self, buff, arg1, arg2, over)

    local resiceadd = GetExProp(buff, "ADD_ICE");
    local resfireadd = GetExProp(buff, "ADD_FIRE");
    local reslightadd = GetExProp(buff, "ADD_LIGHT");
    local resposadd = GetExProp(buff, "ADD_POS");
    local researthadd = GetExProp(buff, "ADD_EARTH");
    
    if IS_PC(self) == true then
        self.ResIce_BM = self.ResIce_BM + resiceadd
        self.ResFire_BM = self.ResFire_BM + resfireadd
        self.ResLightning_BM = self.ResLightning_BM + reslightadd
        self.ResPoison_BM = self.ResPoison_BM + resposadd
        self.ResEarth_BM = self.ResEarth_BM + researthadd
    else
        self.Ice_Def_BM = self.Ice_Def_BM + resiceadd
        self.Fire_Def_BM = self.Fire_Def_BM + resfireadd
        self.Lightning_Def_BM = self.Lightning_Def_BM + reslightadd
        self.Poison_Def_BM = self.Poison_Def_BM + resposadd
        self.Earth_Def_BM = self.Earth_Def_BM + researthadd
    end
end

function SCR_BUFF_ENTER_MassHeal_Buff(self, buff, arg1, arg2, over)

    local healrate = 0.1 + (arg1 - 1) * 0.02
    local addvalue = 0;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        addvalue = 100 + caster.INT + caster.MNA + (arg1 - 1) * 35;
    end 
    
    local healvalue = math.floor(self.MHP * healrate) + addvalue
    
    if IsBuffApplied(self, 'Restoration_Buff') == 'YES' then
        healvalue = math.floor(healvalue * 1.1)
    end
    
    -- Except GuildTower_PVP
    if self.ClassName ~= "GuildTower_PVP" then
        local Ayin_sof_buff = GetBuffByName(self, 'Ayin_sof_Buff')
        local Ayin_sof_arg3 = 0;
        if Ayin_sof_buff ~= nil then
            Ayin_sof_arg3 = GetBuffArgs(Ayin_sof_buff);
        end
        
        if IsSameActor(self, caster) == "NO" or Ayin_sof_arg3 == 0 then
            healvalue = healvalue + (healvalue * arg2);
        end
        
        Heal(self, healvalue, 0, nil, buff.ClassName);
    end
end

function SCR_BUFF_LEAVE_MassHeal_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_StoneSkin_Buff(self, buff, arg1, arg2, over)
    local lv = arg1;
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local skill = GetSkill(caster, "Priest_StoneSkin")
        local skillLv = TryGetProp(skill, "Level");
        if skillLv ~= nil then
            lv = skillLv;
        end
    end
    
    SetBuffArgs(buff, lv, 0, 0);
end

function SCR_BUFF_LEAVE_StoneSkin_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_IncreaseMagicDEF_Buff(self, buff, arg1, arg2, over)
    local mdefadd = 0
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local stat = TryGetProp(caster, "MNA")
        
        if BuffFromWho(buff) == BUFF_FROM_AUTO_SELLER then
            local stat_BM = TryGetProp(caster, 'MNA_BM');
            local stat_ITEM_BM = TryGetProp(caster, 'MNA_ITEM_BM');
            stat = stat - (stat_BM + stat_ITEM_BM);
        end
        
        mdefadd = math.floor(240 + ((arg1 - 1) * 80) + ((arg1 / 3) * (stat ^ 0.9)));
        
        SetBuffArgs(buff, mdefadd);
    else
        mdefadd = GetBuffArgs(buff);
    end
    
    if BuffFromWho(buff) == BUFF_FROM_AUTO_SELLER then
        mdefadd = math.floor(mdefadd * 0.7);
    end
    
    self.MDEF_BM = self.MDEF_BM + mdefadd;
    
    SetExProp(buff, "ADD_MDEF", mdefadd)
end

function SCR_BUFF_LEAVE_IncreaseMagicDEF_Buff(self, buff, arg1, arg2, over)
    local mdefadd = GetExProp(buff, "ADD_MDEF")
    
    self.MDEF_BM = self.MDEF_BM - mdefadd;
end


function SCR_BUFF_ENTER_QuarrelShooter8_Buff(self, buff, arg1, arg2, over)
    
    local lv = arg1
    local shieldDEF = arg2
    local patkadd = math.floor(shieldDEF * lv * 0.5)
    
    self.PATK_BM = self.PATK_BM + patkadd;
    
    SetExProp(buff, "ADD_PATK", patkadd)
end

function SCR_BUFF_LEAVE_QuarrelShooter8_Buff(self, buff, arg1, arg2, over)
    
    local patkadd = GetExProp(buff, "ADD_PATK")
    
    self.PATK_BM = self.PATK_BM - patkadd;
end

-- UnlockChest_After_Buff
function SCR_BUFF_ENTER_UnlockChest_After_Buff(self, buff, arg1, arg2, over)

    local mspdadd = 4;
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    SetExProp(buff, "ADD_MSPD", mspdadd);
    
end

function SCR_BUFF_LEAVE_UnlockChest_After_Buff(self, buff, arg1, arg2, over)

    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM - mspdadd;

end

function SCR_BUFF_ENTER_Gae_Bulg_ATK_Buff(self, buff, arg1, arg2, over)

    local patkadd = 0.08
    local matkadd = 0.08
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + patkadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM + matkadd;
    
    SetExProp(buff, "ADD_PATK", patkadd);
    SetExProp(buff, "ADD_MATK", matkadd);
    
end

function SCR_BUFF_LEAVE_Gae_Bulg_ATK_Buff(self, buff, arg1, arg2, over)

    local patkadd = GetExProp(buff, "ADD_PATK");
    local matkadd = GetExProp(buff, "ADD_MATK");
    
    self.PATK_RATE_BM = self.PATK_RATE_BM - patkadd;
    self.MATK_RATE_BM = self.MATK_RATE_BM - matkadd;
    
end

function SCR_BUFF_ENTER_Gae_Bulg_DEF_Buff(self, buff, arg1, arg2, over)

    local defadd = 0.08
    local mdefadd = 0.08
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + mdefadd;
    
    SetExProp(buff, "ADD_DEF", defadd);
    SetExProp(buff, "ADD_MDEF", mdefadd);
end

function SCR_BUFF_LEAVE_Gae_Bulg_DEF_Buff(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");
    local mdefadd = GetExProp(buff, "ADD_MDEF");
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - mdefadd;

end

-- InvocationAbil_Buff
function SCR_BUFF_ENTER_InvocationAbil_Buff(self, buff, arg1, arg2, over)
    
    local adddarkatk = self.Dark_Atk * arg1 * 0.05
    
    local owner = GetOwner(GetBuffCaster(buff))
    if IsSameObject(self, owner) == 1 then
        adddarkatk = adddarkatk * 2
    end
    
    adddarkatk = math.floor(adddarkatk)
    
    self.Dark_Atk_BM = self.Dark_Atk_BM + adddarkatk
    
    SetExProp(buff, "ADD_DARKATK", adddarkatk)

end

function SCR_BUFF_LEAVE_InvocationAbil_Buff(self, buff, arg1, arg2, over)

    local adddarkatk = GetExProp(buff, "ADD_DARKATK")

    self.Dark_Atk_BM = self.Dark_Atk_BM - adddarkatk

end


-- Archer_Def_Debuff
function SCR_BUFF_ENTER_Archer_Def_Debuff(self, buff, arg1, arg2, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end

    local buffover = over;
    if buffover <= 0 then
        buffover = 1
    end
    
    local defadd = math.floor(self.DEF * 0.1 * buffover)
    --local mdefadd = math.floor(self.MDEF * 0.1 * buffover)
    
    self.DEF_BM = self.DEF_BM - defadd;
    --self.MDEF_BM = self.MDEF_BM - mdefadd;
    
    SetExProp(buff, "ADD_DEF", defadd);
    --SetExProp(buff, "ADD_MDEF", mdefadd);
    
end

function SCR_BUFF_UPDATE_Archer_Def_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
--    if IsBuffApplied(self, "SaberAries_Debuff") == "YES" then
--        buff.OverBuff = 7
--    else
--        buff.OverBuff = 5
--    end
--  return 1;
end

function SCR_BUFF_LEAVE_Archer_Def_Debuff(self, buff, arg1, arg2, over)

    local defadd = GetExProp(buff, "ADD_DEF");
    --local mdefadd = SetExProp(buff, "ADD_MDEF");
    
    self.DEF_BM = self.DEF_BM + defadd;
    --self.MDEF_BM = self.MDEF_BM + mdefadd;

end

-- HighAnchoring_Debuff
function SCR_BUFF_ENTER_HighAnchoring_Debuff(self, buff, arg1, arg2, over)
    local addcrtdr = arg1 * 15;

    self.CRTDR_BM = self.CRTDR_BM - addcrtdr;
    
    SetExProp(buff, "ADD_CRTDR", addcrtdr)
end

function SCR_BUFF_LEAVE_HighAnchoring_Debuff(self, buff, arg1, arg2, over)
    local addcrtdr = GetExProp(buff, "ADD_CRTDR");
    
    self.CRTDR_BM = self.CRTDR_BM + addcrtdr;
end

-- RapidFire_Debuff
function SCR_BUFF_ENTER_RapidFire_Debuff(self, buff, arg1, arg2, over)
    
    local addcrtdr = 150
    self.CRTDR_BM = self.CRTDR_BM - addcrtdr;
    
    SetExProp(buff, "ADD_CRTDR", addcrtdr)
end

function SCR_BUFF_LEAVE_RapidFire_Debuff(self, buff, arg1, arg2, over)
    local addcrtdr = GetExProp(buff, "ADD_CRTDR");
    self.CRTDR_BM = self.CRTDR_BM + addcrtdr;
end

local function toint(n)
    local s = tostring(n)
    local i, j = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end

-- Raise_Debuff
function SCR_BUFF_ENTER_Raise_Debuff(self, buff, arg1, arg2, over)
    if IsPVPServer(self) == 1 then
        buff.Lv = 1;
    end
    
    ActorVibrate(self, 100, 1.5, 10, 0.1);
    FlyMath(self, 70, 0.5, 10);
    
    local dr = self.DR;

    if IS_PC(self) == false and self.GroupName == "Monster" then
        SetExProp_Str(self, "RAISE_MOVETYPE", self.MoveType);
        self.MoveType = "Flying"
    end

    self.DR_BM = self.DR_BM - dr;
    SetExProp(buff, "DEL_DR", dr);

    if IS_PC(self) then
        local remainingTime = GetExProp(self, "Psychokino_Raise_remainingTime")            
        remainingTime = GetDiminishingMSTime(self, self, remainingTime, buff.ClassID, 0, 1)
        SetExProp(self, "Psychokino_Raise_remainingTime", remainingTime)
    end    
end

function SCR_BUFF_UPDATE_Raise_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    if self.Size == 'S' or self.Size == 'M' or self.Size == 'L' then
        if IS_PC(self) then
            local remainingTime = GetExProp(self, "Psychokino_Raise_remainingTime")            
            --remainingTime = GetDiminishingMSTime(self, self, remainingTime, buff.ClassID, 0, 1)            
            local startTime = GetExProp(self, "Psychokino_Raise_startTime")
            local now = toint(imcTime.GetAppTimeMS())
            if now - startTime >= remainingTime then 
                if remainingTime == 0 then                    
                    PlayTextEffect(self, "I_SYS_Text_Effect_Skill", ScpArgMsg("Raise_Immune"))
                end               
                return 0
            end
        end
        return 1;
--  elseif self.Size == 'L' then
--      local caster = GetBuffCaster(buff);
--      if caster ~= nil then
--          local Psychokino6_abil = GetAbility(caster, 'Psychokino6')
--          if Psychokino6_abil ~= nil then
--              return 1;
--          end
--      end
    end
    
    return 0;
end

function SCR_BUFF_LEAVE_Raise_Debuff(self, buff, arg1, arg2, over)
    ActorVibrate(self, 0.1, 0, 0, 0);
    FlyMath(self, 0, 0.1, 0.5);
    
    local dr = GetExProp(buff, "DEL_DR");
    self.DR_BM = self.DR_BM + dr;
    
    if IS_PC(self) == false and self.GroupName == "Monster" then
        local movetype = GetExProp_Str(self, 'RAISE_MOVETYPE')
        self.MoveType = movetype
    end
    
    if IS_PC(self) then
        SetExProp(target, "Psychokino_Raise_remainingTime", 0)
        SetExProp(target, "Psychokino_Raise_startTime", 0)
        GetDiminishingMSTime(self, self, 10000, buff.ClassID, 0, 0)
    end
end

-- Blistering_Debuff_Abil
function SCR_BUFF_ENTER_Blistering_Debuff_Abil(self, buff, arg1, arg2, over)
    --ShowEmoticon(self, 'I_emo_confuse', 0)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local atkadd = 0.02 * arg1
    local defadd = 0.02 * arg1
    
    self.PATK_RATE_BM = self.PATK_RATE_BM + atkadd;
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
    
    SetExProp(buff, "ADD_PATK", atkadd)
    SetExProp(buff, "ADD_DEF", defadd)
    
    if GetObjType(self) ~= OT_MONSTERNPC then
        return;
    end

    local curFaction = GetCurrentFaction(self);
    SetExProp_Str(self, '_PREV_FACTION', curFaction);
    SetCurrentFaction(self, 'CrazyMonster');

    SetTendency(self, "Attack")

    
    local list, cnt = SelectObject(self, 100, "ENEMY");
    for i = 1, cnt do
        local obj = list[i];
        if IS_PC(obj) == false then
            if obj.MonRank ~= 'Boss' and obj.Faction ~= "Neutral" then
                ResetHateAndAttack(obj);
                InsertHate(obj, self, 10000);
            end
        end
    end

end

function SCR_BUFF_LEAVE_Blistering_Debuff_Abil(self, buff, arg1, arg2, over)
    --HideEmoticon(self, 'I_emo_confuse')
    
    local atkadd = GetExProp(buff, "ADD_PATK")
    local defadd = GetExProp(buff, "ADD_DEF")
    
    self.PATK_RATE_BM = self.PATK_RATE_BM - atkadd;
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;   
    
    local prevFaction = GetExProp_Str(self, '_PREV_FACTION');
    SetCurrentFaction(self, prevFaction);

    if IS_PC(self) == false then
        local list, cnt = SelectObject(self, 100, "FRIEND");
        for i = 1, cnt do
            local obj = list[i];
            if IS_PC(obj) == false then
                RemoveHate(obj, self)
            end
        end
        ResetHateAndAttack(self);
        InsertHate(self, GetBuffCaster(buff), 1);
    end
end


function SCR_BUFF_ENTER_Crush_Debuff(self, buff, arg1, arg2, over)
    
    local atkadd = 0;
    local defadd = 0;
    local mdefadd = 0;
    local abil = nil
    local factor = 1;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        abil = GetAbility(caster, "Lancer3");
        if abil ~= nil then
            factor = factor + abil.Level * 0.1;
        end
    end
    
    if IMCRandom(0, 1) == 0 then
        atkadd = (30 * arg1) * factor;
        
        if IS_PC(self) == true then
            if self.MINPATK >= self.MINPATK_SUB and atkadd >= self.MINPATK_SUB then
                atkadd = self.MINPATK_SUB
            elseif self.MINPATK_SUB >= self.MINPATK and atkadd >= self.MINPATK then
                atkadd = self.MINPATK
            end
        elseif IS_PC(self) ~= true and atkadd >= self.MINPATK then
            atkadd = self.MINPATK
        end
    else
        defadd = (30 * arg1) * factor;
        if abil ~= nil and IS_PC(self) == true then
            local EquipDef = GetSumOfEquipItem(self, 'DEF')
            local EquipMdef = GetSumOfEquipItem(self, 'MDEF')
            mdefadd = EquipMdef * 0.5
            defadd = defadd + EquipDef * 0.5
        end
    end

    if defadd >= self.DEF then
        defadd = self.DEF
    end
    
    self.PATK_BM = self.PATK_BM - atkadd;
    self.DEF_BM = self.DEF_BM - defadd;
    self.MDEF_BM = self.MDEF_BM - mdefadd;
    
    SetExProp(buff, "ADD_PATK", atkadd)
    SetExProp(buff, "ADD_DEF", defadd)
    SetExProp(buff, "ADD_MDEF", mdefadd)

end

function SCR_BUFF_LEAVE_Crush_Debuff(self, buff, arg1, arg2, over)

    local atkadd = GetExProp(buff, "ADD_PATK")
    local defadd = GetExProp(buff, "ADD_DEF")
    local mdefadd = GetExProp(buff, "ADD_MDEF")
    
    self.PATK_BM = self.PATK_BM + atkadd;
    self.DEF_BM = self.DEF_BM + defadd;
    self.MDEF_BM = self.MDEF_BM + mdefadd;

end


function SCR_BUFF_ENTER_Commence_Buff(self, buff, arg1, arg2, over)
    local blk_break = 300 + arg1 * 50
    self.BLK_BREAK_BM = self.BLK_BREAK_BM + blk_break

    SetExProp(buff, "BLK_BREAK", blk_break)

end

function SCR_BUFF_UPDATE_Commence_Buff(self, buff, arg1, arg2, RemainTime, ret, over)

    if 1 ~= GetVehicleState(self) then
        RemoveBuff(self, "Commence_Buff");
    end
    
    return 1;

end

function SCR_BUFF_LEAVE_Commence_Buff(self, buff, arg1, arg2, over)

    local blk_break = GetExProp(buff, "BLK_BREAK")
    self.BLK_BREAK_BM = self.BLK_BREAK_BM - blk_break;

end

function SCR_BUFF_ENTER_Commence_Debuff(self, buff, arg1, arg2, over)
    local blkadd = 300
    if self.BLK <= 300 then
        blkadd = self.BLK
    end
    
    self.BLK_BM = self.BLK_BM - blkadd;
    
    SetExProp(buff, "ADD_BLK", blkadd)
end

function SCR_BUFF_LEAVE_Commence_Debuff(self, buff, arg1, arg2, over)
    local blkadd = GetExProp(buff, "ADD_BLK")
    
    self.BLK_BM = self.BLK_BM + blkadd;
end

function SCR_BUFF_ENTER_Joust_Debuff(self, buff, arg1, arg2, over)

    local intadd = math.floor(self.INT * arg1 * 0.05);
    local mnaadd = math.floor(self.MNA * arg1 * 0.05);
    
    self.INT_BM = self.INT_BM - intadd;
    self.MNA_BM = self.MNA_BM - mnaadd;
    
    SetExProp(buff, "ADD_INT", intadd);
    SetExProp(buff, "ADD_MNA", mnaadd);
end

function SCR_BUFF_LEAVE_Joust_Debuff(self, buff, arg1, arg2, over)
    local intadd = GetExProp(buff, "ADD_INT");
    local mnaadd = GetExProp(buff, "ADD_MNA");
    
    self.INT_BM = self.INT_BM + intadd;
    self.MNA_BM = self.MNA_BM + mnaadd;
end

function SCR_BUFF_ENTER_JoustSilence_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_JoustSilence_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    if GetObjType(self) ~= OT_PC then
        return 0;
    end
    local jobObj = GetJobObject(self);
    
    if jobObj == nil then
        return 0;
    end
    
    if jobObj.CtrlType == 'Archer' or jobObj.CtrlType == 'Warrior' then
        return 0;
    end
    
    return 1;
    
end

function SCR_BUFF_LEAVE_JoustSilence_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_HackapellCharge_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_HackapellCharge_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_IronMaiden_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    ObjectColorBlend(self, 255,255,255,0,1)
end

function SCR_BUFF_UPDATE_IronMaiden_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        if self.RaceType == "Velnias" then
            local damage = self.MHP * 0.01
            local skill = GetSkill(caster, 'Inquisitor_IronMaiden');
            TakeDamage(caster, self, skill.ClassName, damage, skill.Attribute, skill.AttackType, 'AbsoluteDamage')
        end
        
        return 1;
    end
    
    return 0;
end

function SCR_BUFF_LEAVE_IronMaiden_Debuff(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255,255,255,255,1)
end

function SCR_BUFF_ENTER_HereticsFork_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    SkillTextEffect(nil, self, caster, "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local damage = GET_SKL_DAMAGE(caster, self, 'Inquisitor_HereticsFork');
    
    SetExProp(buff, "HERETICSFORK_DAMAGE", damage)
end

function SCR_BUFF_UPDATE_HereticsFork_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local damage = GetExProp(buff, "HERETICSFORK_DAMAGE")
        local skill = GET_MON_SKILL(caster, 'Inquisitor_HereticsFork');
        TakeDamage(caster, self, skill.ClassName, damage);
        
        return 1;
    end
    
    return 0;

end

function SCR_BUFF_LEAVE_HereticsFork_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_IronBoots_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local mspdadd = 10 + arg1
    
    self.MSPD_BM = self.MSPD_BM - mspdadd
    
    SetExProp(buff, "ADD_MSPD", mspdadd);
end

function SCR_BUFF_UPDATE_IronBoots_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local damage = GET_SKL_DAMAGE(caster, self, 'Inquisitor_IronBoots');
        local skill = GET_MON_SKILL(caster, 'Inquisitor_IronBoots');
        TakeDamage(caster, self, skill.ClassName, damage);
        
        return 1;
    end
    
    return 0;

end

function SCR_BUFF_LEAVE_IronBoots_Debuff(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");
    
    self.MSPD_BM = self.MSPD_BM + mspdadd;
end

function SCR_BUFF_ENTER_PearofAnguish_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_LEAVE_PearofAnguish_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local damage = GET_SKL_DAMAGE(caster, self, 'Inquisitor_PearofAnguish');
        local skill = GET_MON_SKILL(caster, 'Inquisitor_PearofAnguish');
        TakeDamage(caster, self, skill.ClassName, damage);
    end
end

function SCR_BUFF_ENTER_CatherineWheel_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_LEAVE_CatherineWheel_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_DarkSight_Buff(self, buff, arg1, arg2, over)

    SKL_HATE_RESET(self)
    RunScript('SCR_DARKSIGH_COLORBLEND', self)

end

function SCR_BUFF_LEAVE_DarkSight_Buff(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255,255,255,255,1)
end

function SCR_DARKSIGH_COLORBLEND(self)
    ObjectColorBlend(self, 255,255,255,150,1)
end

function SCR_BUFF_ENTER_Entrenchment_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_LEAVE_Entrenchment_Debuff(self, buff, arg1, arg2, over)

end

function SCR_SHOW_HIDDENPOTENTIAL_TEXT(ret, self, buff, patkadd, matkadd)
    sleep(400)
    SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_BONUS', math.floor(patkadd), nil, "Melee_Atk");
    sleep(400)
    SkillTextEffect(nil, self, GetBuffCaster(buff), 'SHOW_SKILL_BONUS', math.floor(matkadd), nil, "Magic_Atk");
end

function SCR_BUFF_ENTER_HiddenPotential_Buff(self, buff, arg1, arg2, over)
    
    local addmin = 0;
    
    local caster = GetBuffCaster(buff);
    local abil = GetAbility(caster, "Daoshi5")
    if abil ~= nil then
        addmin = abil.Level
    end
    
    local patkadd = IMCRandom((10 * arg1) + addmin, 50 * arg1)
    local matkadd = IMCRandom((10 * arg1) + addmin, 50 * arg1)
    
    self.PATK_BM = self.PATK_BM + patkadd;
    self.MATK_BM = self.MATK_BM + matkadd;
    
    SetExProp(buff, "ADD_PATK", patkadd);
    SetExProp(buff, "ADD_MATK", matkadd);
    
    RunScript('SCR_SHOW_HIDDENPOTENTIAL_TEXT', ret, self, buff, patkadd, matkadd)
end

function SCR_BUFF_LEAVE_HiddenPotential_Buff(self, buff, arg1, arg2, over)

    local patkadd = GetExProp(buff, "ADD_PATK");
    local matkadd = GetExProp(buff, "ADD_MATK");
    
    self.PATK_BM = self.PATK_BM - patkadd;
    self.MATK_BM = self.MATK_BM - matkadd;
    
end

function SCR_BUFF_ENTER_StormCalling_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    local damage = GET_SKL_DAMAGE(caster, self, 'Daoshi_StormCalling');
    local skill = GET_MON_SKILL(caster, 'Daoshi_StormCalling');
    
    local divineAtkAdd = skill.SkillAtkAdd
    local addValue = 0
    
    local pad = GetPadByBuff(caster, buff);
    if pad ~= nil then
        addValue = GetPadArgNumber(pad, 2);
    end
    
    divineAtkAdd = addValue - divineAtkAdd
    
    if divineAtkAdd < 0 then
        divineAtkAdd = 0;
    end
    
    TakeDamage(caster, self, skill.ClassName, damage + divineAtkAdd);
    
end

function SCR_BUFF_LEAVE_StormCalling_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_StormCalling_Buff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    local healValueBuff = 50

    local sklLevel = arg1
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            sklLevel = GetPadArgNumber(pad, 1);
        end
    end
    
    healValueBuff = healValueBuff + sklLevel * 100;
    
    local healMin = healValueBuff - math.floor(healValueBuff * 0.05)
    local healMax = healValueBuff + math.floor(healValueBuff * 0.05)
    
    Heal(self, IMCRandom(healMin, healMax), 0);
end

function SCR_BUFF_LEAVE_StormCalling_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_EvasiveAction_Buff(self, buff, arg1, arg2, over)

--    local mspdadd = 5

--    self.MSPD_BM = self.MSPD_BM - mspdadd

--    SetExProp(buff, "ADD_MSPD", mspdadd);

end

function SCR_BUFF_UPDATE_EvasiveAction_Buff(self, buff, arg1, arg2, RemainTime, ret, over)

    if 1 ~= GetVehicleState(self) then
        RemoveBuff(self, "EvasiveAction_Buff");
    end
    return 1;

end

function SCR_BUFF_LEAVE_EvasiveAction_Buff(self, buff, arg1, arg2, over)
--    local mspdadd = GetExProp(buff, "ADD_MSPD");

--    self.MSPD_BM = self.MSPD_BM + mspdadd;
end

function SCR_BUFF_ENTER_Savior_Buff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local shieldValue = 800 + 100 * arg1;
    GIVE_BUFF_SHIELD(self, buff, shieldValue)
end

function SCR_BUFF_LEAVE_Savior_Buff(self, buff, arg1, arg2, over)
    TAKE_BUFF_SHIELD(self, buff)
end

function SCR_BUFF_ENTER_Foretell_Buff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
--    local shieldValue = math.floor(self.MHP * 0.2 * arg1);
--    GIVE_BUFF_SHIELD(self, buff, shieldValue)
end

function SCR_BUFF_LEAVE_Foretell_Buff(self, buff, arg1, arg2, over)
--     TAKE_BUFF_SHIELD(self, buff)
end

function SCR_BUFF_ENTER_PlagueVapours_Debuff(self, buff, arg1, arg2, over)
	local caster = GetBuffCaster(buff);
	if caster ~= nil then
		local abilPlagueDoctor16 = GetAbility(caster, 'PlagueDoctor16');
		if abilPlagueDoctor16 ~= nil and abilPlagueDoctor16.ActiveState == 1 then
			SetBuffUpdateTime(buff, 400);
		end
	end
	
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_UPDATE_PlagueVapours_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local damage = GET_SKL_DAMAGE(caster, self, 'PlagueDoctor_PlagueVapours');
        local skill = GET_MON_SKILL(caster, 'PlagueDoctor_PlagueVapours');
        TakeDamage(caster, self, skill.ClassName, damage, skill.Attribute, skill.AttackType, skill.ClassType, HIT_POISON_GREEN, HITRESULT_BLOW);
        
        local faction = GetCurrentFaction(self);
        local objList, objCount = SelectObjectNear(caster, self, 60, 'ENEMY');
        if objCount > 0  and IMCRandom(1, 10000) < 1000  then
            local rand = IMCRandom(1, objCount)
            AddBuff(caster, objList[rand], 'PlagueVapours_Debuff', arg1, arg2, RemainTime, over);
        end
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_PlagueVapours_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_LegShot_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local rate = 0.5
    local caster = GetBuffCaster(buff)
    local abil = GetAbility(caster, "Hackapell5")
    if abil ~= nil then
        rate = rate + abil.Level * 0.01
    end
    
    local mspdadd = math.floor(self.MSPD * rate);
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    SetExProp(buff, "ADD_MSPD", mspdadd);
end

function SCR_BUFF_LEAVE_LegShot_Debuff(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM + mspdadd;
end

function SCR_BUFF_ENTER_Enchantment_Buff(self, buff, arg1, arg2, over)
    local equipItem = GetEquipItem(self, "RH");
    if equipItem.ClassName == "NoWeapon" then
        return;
    end

    SetExProp(equipItem, "Enchantment_Buff", 1)
    REFRESH_ITEM(self, equipItem);
        InvalidateItem(equipItem);

    SetExProp_Str(buff, "Enchantment_Buff", GetItemGuid(equipItem))
end

function SCR_BUFF_UPDATE_Enchantment_Buff(self, buff, arg1, arg2, over, isLastEnd)
    local equipItem = GetEquipItem(self, "RH");
    if equipItem.ClassName == "NoWeapon" then
        return 0;
    end

    if GetExProp_Str(buff, 'Enchantment_Buff') ~= GetItemGuid(equipItem) then
        return 0
    end

    return 1;
end

function SCR_BUFF_LEAVE_Enchantment_Buff(self, buff, arg1, arg2, over, isLastEnd)
    local bufIemGUID = GetExProp_Str(buff, 'Enchantment_Buff');
    local item, cnt = GetInvItemByGuid(self, bufIemGUID);
    if item == nil then
        return;
    end

    DelExProp(item, 'Enchantment_Buff');
    REFRESH_ITEM(self, item);
        InvalidateItem(item);
    end 

function SCR_BUFF_ENTER_Rewards_RH_Buff(self, buff, arg1, arg2, over)
    local equipItem = GetEquipItem(self, "RH");
    if equipItem.ClassName == "NoWeapon" then
        return;
    end

    SetExProp(equipItem, "Rewards_BuffValue", arg1 * 10)
    REFRESH_ITEM(self, equipItem);

    SetExProp_Str(buff, "Rewards_Buff", GetItemGuid(equipItem))
end

function SCR_BUFF_UPDATE_Rewards_RH_Buff(self, buff, arg1, arg2, over, isLastEnd)
    local equipItem = GetEquipItem(self, "RH");
    if equipItem.ClassName == "NoWeapon" then
    --  InvalidateStates(self)
        return 0;
    end

    if GetExProp_Str(buff, 'Rewards_Buff') ~= GetItemGuid(equipItem) then
    --  InvalidateStates(self)
        return 0
    end

    return 1;
end

function SCR_BUFF_LEAVE_Rewards_RH_Buff(self, buff, arg1, arg2, over, isLastEnd)
    local buffItem = GetExProp_Str(buff, 'Rewards_Buff');
    local item, cnt = GetEquipItemByGuid(self, buffItem);
    if item == nil then
        return;
    end

    DelExProp(item, 'Rewards_BuffValue');
    REFRESH_ITEM(self, item);
end

function SCR_BUFF_ENTER_Rewards_SHIRT_Buff(self, buff, arg1, arg2, over)
    local shirtEquip = GetEquipItem(self, "SHIRT");
    if shirtEquip.ClassName == "NoWeapon" then
        return;
    end

    SetExProp(shirtEquip, "Rewards_BuffValue", arg1 * 10)
    REFRESH_ITEM(self, shirtEquip);
    
    SetExProp_Str(buff, "Rewards_Buff2", GetItemGuid(shirtEquip))
end

function SCR_BUFF_UPDATE_Rewards_SHIRT_Buff(self, buff, arg1, arg2, over, isLastEnd)
    local shirtEquip = GetEquipItem(self, "SHIRT");
    if shirtEquip.ClassName == "NoWeapon" then
        return 0;
    end

    if GetExProp_Str(buff, 'Rewards_Buff2') ~= GetItemGuid(shirtEquip) then
        return 0
    end

    return 1;
end

function SCR_BUFF_LEAVE_Rewards_SHIRT_Buff(self, buff, arg1, arg2, over, isLastEnd)
    local bufIemGUID = GetExProp_Str(buff, 'Rewards_Buff2');
    local item, cnt = GetInvItemByGuid(self, bufIemGUID);
    if item == nil then 
        return;
    end

    DelExProp(item, 'Rewards_BuffValue');
    REFRESH_ITEM(self, item);   
end

function SCR_BUFF_ENTER_Agility_Buff(self, buff, arg1, arg2, over)
    local equipItem = GetEquipItem(self, "BOOTS");
    if equipItem.ClassName == "NoBoots" then
        return;
    end
    
    SetExProp(equipItem, "Agility_Buff", 1)
    REFRESH_ITEM(self, equipItem);
    
    SetExProp_Str(buff, "Agility_Buff", GetItemGuid(equipItem))
    
    local addsta = 5 * arg1;
    self.MaxSta_BM = self.MaxSta_BM + addsta;
    SetExProp(buff, 'ADD_STA', addsta); 
end

function SCR_BUFF_UPDATE_Agility_Buff(self, buff, arg1, arg2, over, isLastEnd)
    local equipItem = GetEquipItem(self, "BOOTS");
    if equipItem.ClassName == "NoBoots" then
        return 0;
    end
    
    if GetExProp_Str(buff, 'Agility_Buff') ~= GetItemGuid(equipItem) then
        return 0
    end

    return 1;
end

function SCR_BUFF_LEAVE_Agility_Buff(self, buff, arg1, arg2, over, isLastEnd)
    local addsta = GetExProp(buff, 'ADD_STA');  
    if 0 < addsta then
        self.MaxSta_BM = self.MaxSta_BM - addsta;   
    end
    local bufIemGUID = GetExProp_Str(buff, 'Agility_Buff');
    local item, cnt = GetInvItemByGuid(self, bufIemGUID);

    if item == nil then
        return;
    end

    DelExProp(item, 'Agility_Buff');

    REFRESH_ITEM(self, item);
    InvalidateItem(item);
end

function SCR_BUFF_ENTER_Blink_ColorBlned(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255, 180, 255, 150, 1);
end

function SCR_BUFF_LEAVE_Blink_ColorBlned(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255, 255, 255, 0, 1, 0.7);
end

function SCR_BUFF_ENTER_EnchantedPowder_Buff(self, buff, arg1, arg2, over)
    local mspdadd = math.floor(2 + arg1 * 0.1)
    self.MSPD_BM = self.MSPD_BM + mspdadd
    SetExProp(buff, "ADD_MSPD", mspdadd);
end

function SCR_BUFF_LEAVE_EnchantedPowder_Buff(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD")
    self.MSPD_BM = self.MSPD_BM - mspdadd
end

function SCR_BUFF_ENTER_Hamaya_TakeDamage(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    local skill = GET_MON_SKILL(caster, 'Miko_Hamaya');
    local damage = GET_SKL_DAMAGE(caster, self, 'Miko_Hamaya');
    
    local divineAtkAdd = skill.SkillAtkAdd
    local addValue = 0
    
    local pad = GetPadByBuff(caster, buff);
    if pad ~= nil then
        addValue = GetPadArgNumber(pad, 1);
    end
    
    divineAtkAdd = addValue - divineAtkAdd
    
    if divineAtkAdd < 0 then
        divineAtkAdd = 0;
    end
    
    local addHolyDamage = 0;
    if self.RaceType == "Velnias" then
        addHolyDamage = skill.SkillAtkAdd * 3
    end
    
    TakeDamage(caster, self, skill.ClassName, damage + divineAtkAdd + addHolyDamage)
end

function SCR_BUFF_LEAVE_Hamaya_TakeDamage(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Levitation_Buff(self, buff, arg1, arg2, over)
    FlyMath(self, 35, 0.3, 1, 1, 0);
    self.Jumpable = self.Jumpable - 1;
    
    AddLockSkillList(self, 'Cryomancer_SnowRolling');
    AddLockSkillList(self, 'Psychokino_PsychicPressure');
    AddLockSkillList(self, 'Psychokino_Swap');
    AddLockSkillList(self, 'Alchemist_Combustion');
    AddLockSkillList(self, 'Alchemist_Dig');
    AddLockSkillList(self, 'Alchemist_ItemAwakening');
    AddLockSkillList(self, 'Alchemist_Briquetting');
    AddLockSkillList(self, 'Alchemist_Tincturing');
    AddLockSkillList(self, 'Alchemist_MagnumOpus');
    AddLockSkillList(self, 'Featherfoot_Kurdaitcha');
    AddLockSkillList(self, 'Linker_SpiritualChain');
    AddLockSkillList(self, 'Necromancer_Disinter');
    AddLockSkillList(self, 'Alchemist_Roasting');
    AddLockSkillList(self, 'Sage_Portal');
    AddLockSkillList(self, 'Sage_Blink');
    AddLockSkillList(self, 'Enchanter_EnchantArmor');
    AddLockSkillList(self, 'Enchanter_CraftMagicScrolls');
    
    --SetShadowRender(self, 0);
end

function SCR_BUFF_UPDATE_Levitation_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    local hight = GetFlyHeight(self);
    local maxHight = 35

    if IsUsingSkill(self) == 1 then
        local lowHight = 34;
        if lowHight ~= hight then
            FlyMath(self, lowHight, 1, 0.5, 1, 0);
        elseif maxHight ~= hight then
            FlyMath(self, maxHight, 1, 0.5, 1, 0);
        end
    else
        if buffHight ~= hight then
            FlyMath(self, maxHight, 0.3, 1, 1, 0);
        end
    end
    return 1;   
end

function SCR_BUFF_LEAVE_Levitation_Buff(self, buff, arg1, arg2, over)
    PlayAnim(self, "SKL_LEVITATION_DOWN");
    FlyMath(self, 0, 0.2, 1);
    self.Jumpable = self.Jumpable + 1;
    
    ClearLimitationSkillList(self);
    --SetShadowRender(self, 1);
end

function SCR_BUFF_ENTER_HoukiBroom_Buff(self, buff, arg1, arg2, over)
    local mspdadd = 15
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    self.Jumpable = self.Jumpable - 1;
    SetExProp(buff, "ADD_MSPD", mspdadd);
    SetExProp(self, 'ImmuneBuff', 1);
end

function SCR_BUFF_LEAVE_HoukiBroom_Buff(self, buff, arg1, arg2, over)
    DelExProp(self, 'ImmuneBuff');
    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    self.Jumpable = self.Jumpable + 1;
end

function SCR_BUFF_ENTER_BloodCurse_Debuff(self, buff, arg1, arg2, over)
    if IS_PC(self) == true then
        local rspadd = self.RSP
        self.RSP_BM = self.RSP_BM - rspadd
        SetExProp(buff, "ADD_RSP", rspadd);
    end
end

function SCR_BUFF_UPDATE_BloodCurse_Debuff(self, buff, arg1, arg2, over)
    if self.MonRank == "Material" or self.MonRank == "MISC" or self.MonRank == "None" then
        return;
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_BloodCurse_Debuff(self, buff, arg1, arg2, over)
    if IS_PC(self) == true then
        local rspadd = GetExProp(buff, "ADD_RSP");
        self.RSP_BM = self.RSP_BM + rspadd;
    end
end

function SCR_BUFF_ENTER_DethroneBoss_Debuff(self, buff, arg1, arg2, over)
    local mspdadd = math.floor(self.MSPD * 0.5)
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    SetExProp(buff, "ADD_MSPD", mspdadd);
end

function SCR_BUFF_LEAVE_DethroneBoss_Debuff(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM + mspdadd;
end

function SCR_BUFF_ENTER_BalestraFente_Debuff(self, buff, arg1, arg2, over)
    local addcrtdr = math.floor(arg1 * 40)
    self.CRTDR_BM = self.CRTDR_BM - addcrtdr
    SetExProp(buff, "ADD_CRTDR", addcrtdr)
end

function SCR_BUFF_LEAVE_BalestraFente_Debuff(self, buff, arg1, arg2, over)
    local addcrtdr = GetExProp(buff, "ADD_CRTDR")
    self.CRTDR_BM = self.CRTDR_BM + addcrtdr
end

function SCR_BUFF_ENTER_Aiming_Buff(self, buff, arg1, arg2, over)
    EnablePreviewHitRadius(self, 1);
end

function SCR_BUFF_LEAVE_Aiming_Buff(self, buff, arg1, arg2, over, isLast)
    if isLast == 1 then
        EnablePreviewHitRadius(self, 0);
    end
end

function SCR_BUFF_ENTER_TriDisaster_Buff(self, buff, arg1, arg2, over)

    local lv = arg1
    local resice = 0;
    local resfire = 0;
    local reslight = 0;
    local addres = 200 + lv * 10
    
    
    if IS_PC(self) == true then
        resice = self.ResIce
        resfire = self.ResFire
        reslight = self.ResLightning
    else
        resice = self.Ice_Def
        resfire = self.Fire_Def
        reslight = self.Lightning_Def
    end
    
--    local resiceadd = math.floor(resice * arg1 * 0.1)
--    local resfireadd = math.floor(resfire * arg1 * 0.1)
--    local reslightadd = math.floor(reslight * arg1 * 0.1)

    local resiceadd = 0 + addres;
    local resfireadd = 0 + addres;
    local reslightadd = 0 + addres;
    
    if IS_PC(self) == true then
        self.ResIce_BM = self.ResIce_BM + resiceadd
        self.ResFire_BM = self.ResFire_BM + resfireadd
        self.ResLightning_BM = self.ResLightning_BM + reslightadd
    else
        self.Ice_Def_BM = self.Ice_Def_BM + resiceadd
        self.Fire_Def_BM = self.Fire_Def_BM + resfireadd
        self.Lightning_Def_BM = self.Lightning_Def_BM + reslightadd
    end
    
    SetExProp(buff, "ADD_ICE", resiceadd);
    SetExProp(buff, "ADD_FIRE", resfireadd);
    SetExProp(buff, "ADD_LIGHT", reslightadd);
end

function SCR_BUFF_LEAVE_TriDisaster_Buff(self, buff, arg1, arg2, over)
    local resiceadd = GetExProp(buff, "ADD_ICE")
    local resfireadd = GetExProp(buff, "ADD_FIRE")
    local reslightadd = GetExProp(buff, "ADD_LIGHT")
    
    if IS_PC(self) == true then
        self.ResIce_BM = self.ResIce_BM - resiceadd
        self.ResFire_BM = self.ResFire_BM - resfireadd
        self.ResLightning_BM = self.ResLightning_BM - reslightadd
    else
        self.Ice_Def_BM = self.Ice_Def_BM - resiceadd
        self.Fire_Def_BM = self.Fire_Def_BM - resfireadd
        self.Lightning_Def_BM = self.Lightning_Def_BM - reslightadd
    end
end

function SCR_BUFF_ENTER_MalleusMaleficarum_Debuff(self, buff, arg1, arg2, over)
    local addmna = math.floor(self.MNA / 2)
    local addint = math.floor(self.INT / 2)
    
    self.MNA_BM = self.MNA_BM - addmna;
    self.INT_BM = self.INT_BM - addint;
    
    SetExProp(buff, "ADD_MNA", addmna)
    SetExProp(buff, "ADD_INT", addint)
    
    local caster = GetBuffCaster(buff)
    if caster == nil then
        caster = self
    end
    
    local abil = GetAbility(caster, 'Inquisitor11')
    if abil ~= nil then
        if IS_PC(self) == true then
            AddSP(self, -math.floor(self.SP * abil.Level * 0.05))
        else
            AddBuff(caster, self, 'UC_silence', 1, 0, 5000, 1);
            --AddBuff(caster, self, 'MalleusMaleficarum_Debuff_Abil', 1, 0, 5000, 1);
        end
    end
end

function SCR_BUFF_LEAVE_MalleusMaleficarum_Debuff(self, buff, arg1, arg2, over)
    local addmna = GetExProp(buff, "ADD_MNA")
    local addint = GetExProp(buff, "ADD_INT")
    
    self.MNA_BM =  self.MNA_BM + addmna;
    self.INT_BM =  self.INT_BM + addint;
end

function SCR_BUFF_ENTER_HengeStone_Buff(self, buff, arg1, arg2, over)
    if GetObjType(self) ~= OT_PC then
        return;
    end
    
    local jobObj = GetJobObject(self);
    if jobObj == nil then
        return;
    end
    
    if jobObj.CtrlType ~= 'Cleric' then
        return;
    end
    
    local list, cnt = GetPCSkillList(self);
    for i = 1, cnt do
        if list[i].ClassID > 10000 and list[i].HitType == "Pad" then
            list[i].Level_BM = list[i].Level_BM + 1;
            InvalidateObjectProp(list[i], "Level");
            InvalidateObjectProp(list[i], "SkillAtkAdd");
            InvalidateObjectProp(list[i], "SkillFactor");
            SendSkillProperty(self, list[i]);
        end
    end

    local value = GetExProp(self, 'HENGE_STONE_SATE');
    SetExProp(self, 'HENGE_STONE_SATE', value + 1);
end

function SCR_BUFF_LEAVE_HengeStone_Buff(self, buff, arg1, arg2, over)
    if GetObjType(self) ~= OT_PC then
        return;
    end
    
    local jobObj = GetJobObject(self);
    if jobObj == nil then
        return;
    end
    
    if jobObj.CtrlType ~= 'Cleric' then
        return;
    end

    local list, cnt = GetPCSkillList(self);
    for i = 1, cnt do
        if list[i].ClassID > 10000 and list[i].HitType == "Pad" then
            list[i].Level_BM = list[i].Level_BM - 1;
            InvalidateObjectProp(list[i], "Level");
            InvalidateObjectProp(list[i], "SkillAtkAdd");
            SendSkillProperty(self, list[i]);
        end
    end

    local value = GetExProp(self, 'HENGE_STONE_SATE');
    SetExProp(self, 'HENGE_STONE_SATE', value - 1);
end

function SCR_BUFF_ENTER_HoukiBroomSkllvup_Buff(self, buff, arg1, arg2, over)
    local list, cnt = GetPCSkillList(self);
    for i = 1, cnt do
        if list[i].ClassID > 10000 and list[i].HitType == "Pad" then
            list[i].Level_BM = list[i].Level_BM + 1;
            InvalidateObjectProp(list[i], "Level");
--          InvalidateObjectProp(list[i], "SkillAtkAdd");
            InvalidateObjectProp(list[i], "SkillFactor");
            SendSkillProperty(self, list[i]);
        end
    end
end

function SCR_BUFF_LEAVE_HoukiBroomSkllvup_Buff(self, buff, arg1, arg2, over)
    local list, cnt = GetPCSkillList(self);
    for i = 1, cnt do
        if list[i].ClassID > 10000 and list[i].HitType == "Pad" then
            list[i].Level_BM = list[i].Level_BM - 1;
            InvalidateObjectProp(list[i], "Level");
            InvalidateObjectProp(list[i], "SkillAtkAdd");
            SendSkillProperty(self, list[i]);
        end
    end
end

function SCR_BUFF_ENTER_TwistOfFate_Debuff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_TwistOfFate_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff)
    local healValue = 1
  healValue = GetExProp(self, "TwistOfFate_DamageRate")
    Heal(self, healValue/30)

    return 1;
end

function SCR_BUFF_LEAVE_TwistOfFate_Debuff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_Merkabah_Buff(self, buff, arg1, arg2, over)
    local mdefRate = 0.1;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + mdefRate;
    
    SetExProp(buff, "ADD_MDEF", mdefRate);
end

function SCR_BUFF_LEAVE_Merkabah_Buff(self, buff, arg1, arg2, over)
    local mdefRate = GetExProp(buff, "ADD_MDEF")
    
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - mdefRate;
end

function SCR_BUFF_ENTER_indunTheEndSafe(self, buff, arg1, arg2, over)
    local addDefenced_BM  = 1;
    SetExProp(buff, 'DEFENCED_BM', addDefenced_BM);
    self.MaxDefenced_BM = self.MaxDefenced_BM + addDefenced_BM;
end

function SCR_BUFF_LEAVE_indunTheEndSafe(self, buff, arg1, arg2, over)
    local addDefenced_BM = GetExProp(buff, 'DEFENCED_BM');
    self.MaxDefenced_BM = self.MaxDefenced_BM - addDefenced_BM;
end

function SCR_BUFF_ENTER_ScudInstinct_Buff(self, buff, arg1, arg2, over)
    local timelimit = 50;
    
    if self.ClassName == 'PC' then
        local Barbarian29_abil = GetAbility(self, "Barbarian29")
        if Barbarian29_abil ~= nil then
            timelimit = timelimit + 50;
        end
    end
    
    SetBuffArgs(buff, 0, 0, timelimit)
end

function SCR_BUFF_UPDATE_ScudInstinct_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    if self.ClassName == 'PC' then
        local is_barbarian = GetJobGradeByName(self, 'Char1_6')
        if is_barbarian >= 2 then
            local stoptime, dashtime, timelimit = GetBuffArgs(buff)
            if self.DashRun == 0 then
                stoptime = stoptime + 1;
                if stoptime >= timelimit then
                    if over <= 1 then
                        return 0;
                    end
                    stoptime = 0;
                    AddBuff(self, self, 'ScudInstinct_Buff', 1, 0, 0, -1)
                end
                SetBuffArgs(buff, stoptime, 0, timelimit)
            else
                if over < 5 then
                    dashtime = dashtime + 1;
                    if dashtime >= 10 then
                        dashtime = 0;
                        AddBuff(self, self, 'ScudInstinct_Buff', 1, 0, 0, 1)
                    end
                end
                
                if stoptime > 0 then
                    stoptime = stoptime - 1;
                end
                
                SetBuffArgs(buff, stoptime, dashtime, timelimit)
            end
            
            if over >= 5 then
            	local healTimeCount = GetExProp(buff, "HEAL_TIME_COUNT");
            	if healTimeCount == nil then
            		healTimeCount = 0;
            	end
            	
            	if healTimeCount >= 20 then
					local healValue = 0;
					
					if is_barbarian == 2 then
						healValue = 50;
					elseif is_barbarian == 3 then
						healValue = 100;
					end
		            
		            Heal(self, healValue);
		            healTimeCount = 0;
		        else
		        	healTimeCount = healTimeCount + 1;
		        end
	            
		        SetExProp(buff, "HEAL_TIME_COUNT", healTimeCount);
	        end
        else
            return 0;
        end
    else
        return 0;
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_ScudInstinct_Buff(self, buff, arg1, arg2, over)
    
end



function SCR_BUFF_ENTER_FrostPillar_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_FrostPillar_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff)
    if caster == nil then
        return 0;
    end
    
    if IsDead(caster) == 1 then
        return 0;
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_FrostPillar_Debuff(self, buff, arg1, arg2, over)
    
end



function SCR_BUFF_ENTER_Sorcerer_Obey_Status_Buff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
    SendAddOnMsg(caster, "SORCERER_OBEY_BUFF", "None", add_value);
end
end

function SCR_BUFF_UPDATE_Sorcerer_Obey_Status_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff)
    if caster == nil then
        return 0;
    end
    
    if IsDead(caster) == 1 then
        return 0;
    end
    
    if caster.ClassName ~= 'PC' then
        return 0;
    end
    
    local ctrlTarget = GetControlTarget(caster);
    if ctrlTarget == nil or IsSameObject(ctrlTarget, self) == 0 then
        return 0;
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_Sorcerer_Obey_Status_Buff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        SendAddOnMsg(caster, "SORCERER_OBEY_BUFF", "None", 0);
end
end



function SCR_BUFF_ENTER_Sorcerer_Obey_PC_DEF_Buff(self, buff, arg1, arg2, over)
    local ctrlTarget = GetControlTarget(self);
    if ctrlTarget ~= nil then
    SetExArgObject(self, "Sorcerer_Obey_PC_DEF_Buff_Mon", ctrlTarget);
end
end

function SCR_BUFF_UPDATE_Sorcerer_Obey_PC_DEF_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    local ctrlTarget = GetControlTarget(self);
    local ObeyMon = GetExArgObject(self, "Sorcerer_Obey_PC_DEF_Buff_Mon");
    if ctrlTarget == nil or ObeyMon == nil then
        return 0;
    end
    if IsSameObject(ctrlTarget, ObeyMon) == 0 then
        return 0;
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_Sorcerer_Obey_PC_DEF_Buff(self, buff, arg1, arg2, over)
    ClearExArgObject(self, "Sorcerer_Obey_PC_DEF_Buff_Mon")
end

function SCR_BUFF_ENTER_CannonBlast_Debuff(self, buff, arg1, arg2, over)
    
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    
    local defadd = 0.5
    self.DEF_RATE_BM = self.DEF_RATE_BM + defadd;
    SetExProp(buff, "ADD_DEF", defadd);

end

function SCR_BUFF_LEAVE_CannonBlast_Debuff(self, buff, arg1, arg2, over)
    local defadd = GetExProp(buff, "ADD_DEF");    
    self.DEF_RATE_BM = self.DEF_RATE_BM - defadd;
end

function SCR_BUFF_ENTER_SnowRollingAttach(self, buff, arg1, arg2, over)    
end

function SCR_BUFF_LEAVE_SnowRollingAttach(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        if(GetExProp(self, "diminishing_snowRolling") == 1) then
            SetExProp(self, "diminishing_snowRolling", 0)
            DetachFromObject(self, caster);
            local remainingTime = GetExProp(self, "diminishing_snowRolling_remainingTime")            
            if remainingTime ~= 0 then
                AddBuff(self, self, "SnowRollingTemporaryImmune", 1, 1, remainingTime, 1)
            end
            local knockType = 4
            local isInverseAngle = 3
            local power = 150
            local vAngle = 40
            local hAngle = 0
            local bound = 1
            local kdRank = 2            
            SKL_TOOL_KD(caster, self, knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank);
        end
    end
end

function SCR_BUFF_ENTER_Firstblow_Buff(self, buff, arg1, arg2, over)
    if GetObjType(self) == OT_PC then
        PlayEffect(self, "F_pc_FirstBlow", 1.3, 'TOP');
    end
end

function SCR_BUFF_LEAVE_Firstblow_Buff(self, buff, arg1, arg2, over)
    if GetObjType(self) == OT_PC then
		local fistBlowMonID = GetExProp(self, "FirstBlowMonID");
		local fistBlowMonName = GetExProp(self, "FirstBlowMonName");

		print("Try BuffRemoveFirstblow Lob");

		CustomMongoLog(self, "FieldBoss", "Type", "BuffRemoveFirstblow", "MonClsID", fistBlowMonID, "MonClsName", fistBlowMonName);
	else
		CustomMongoLog(self, "FieldBoss", "Type", "BuffRemoveFirstblow");
    end
end

function SCR_BUFF_ENTER_GatherCorpse_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff)
    if caster ~= nil then
        local skill = GetSkill(caster, "Necromancer_GatherCorpse")
        if skill ~= nil then
            arg1 = skill.Level;
        end
        
        SetBuffArg(caster, buff, arg1)
    end
end

function SCR_BUFF_LEAVE_GatherCorpse_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_TeamBattle_GoldRanker(self, buff, arg1, arg2, over)
    REMOVE_WORLDPVP_REWARD_ACHIEVE(self);
end

function SCR_BUFF_UPDATE_TeamBattle_GoldRanker(self, buff, arg1, arg2, over)
    REMOVE_WORLDPVP_REWARD_ACHIEVE(self);

    return 1;
end

function SCR_BUFF_ENTER_TeamBattle_SilverRanker(self, buff, arg1, arg2, over)
    REMOVE_WORLDPVP_REWARD_ACHIEVE(self);
end

function SCR_BUFF_UPDATE_TeamBattle_SilverRanker(self, buff, arg1, arg2, over)
    REMOVE_WORLDPVP_REWARD_ACHIEVE(self);

    return 1;
end

function SCR_BUFF_ENTER_TeamBattle_BronzeRanker(self, buff, arg1, arg2, over)
    REMOVE_WORLDPVP_REWARD_ACHIEVE(self);
end

function SCR_BUFF_UPDATE_TeamBattle_BronzeRanker(self, buff, arg1, arg2, over)
    REMOVE_WORLDPVP_REWARD_ACHIEVE(self);

    return 1;
end

--ADVENTURE BOOK FIRST RANK REWARD
function SCR_BUFF_ENTER_Journal_AP1(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Journal_AP1(self, buff, arg1, arg2, over)
    return 1
end

function SCR_BUFF_LEAVE_Journal_AP1(self, buff, arg1, arg2, over)
    if GetBuffRemainTime(buff) <= 0 then
        RunScript("REMOVE_ADVENTURE_REWARD_ACHIEVE", self)
    end
end

--ADVENTURE BOOK ITEM FIRST RANK REWARD
function SCR_BUFF_ENTER_Journal_AP6(self, buff, arg1, arg2, over)
end

function SCR_BUFF_UPDATE_Journal_AP6(self, buff, arg1, arg2, over)
    return 1;
end

function SCR_BUFF_LEAVE_Journal_AP6(self, buff, arg1, arg2, over)
    if GetBuffRemainTime(buff) <= 0 then
        RunScript("REMOVE_ADVENTURE_REWARD_ITEM_ACHIEVE", self)
    end
end

function SCR_BUFF_ENTER_CavalryChargeAbil_Buff(self, buff, arg1, arg2, over)
    local AbilityDefence = 0
    local abil = GetAbility(self, "Hackapell8")
    local abilLevel = TryGetProp(abil, "Level")
    local ActiveState = TryGetProp(abil, "ActiveState")
    if abil ~= nil and ActiveState == 1 then
        AbilityDefence = abilLevel * 0.1
    end
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + AbilityDefence
    
    SetExProp(buff, "ABIL_DEF", AbilityDefence)
end

function SCR_BUFF_LEAVE_CavalryChargeAbil_Buff(self, buff, arg1, arg2, over)
    local AbilityDefence = GetExProp(buff, "ABIL_DEF")
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - AbilityDefence
end




function SCR_BUFF_ENTER_Sanctuary_Buff(self, buff, arg1, arg2, over)
    local skillLv = arg1;
    local addDEF = 0;
    local addMDEF = 0;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local casterBasicDEF = SCR_CALC_BASIC_DEF(caster);
        local casterBasicMDEF = SCR_CALC_BASIC_MDEF(caster);
        
        local casterSkill = GetSkill(caster, "Paladin_Sanctuary");
        if casterSkill ~= nil then
            skillLv = TryGetProp(casterSkill, "Level");
            if skillLv == nil then
                skillLv = arg1;
    end
end

        addDEF = casterBasicDEF * (arg1 * 0.1);
        addMDEF = casterBasicMDEF * (arg1 * 0.1);
end

    self.DEF_BM = self.DEF_BM + addDEF;
    self.MDEF_BM = self.MDEF_BM + addMDEF;
    
    SetExProp(buff, "ADD_DEF", addDEF);
    SetExProp(buff, "ADD_MDEF", addMDEF);
end

function SCR_BUFF_LEAVE_Sanctuary_Buff(self, buff, arg1, arg2, over)
    local addDEF = GetExProp(buff, "ADD_DEF");
    local addMDEF = GetExProp(buff, "ADD_MDEF");
    
    self.DEF_BM = self.DEF_BM - addDEF;
    self.MDEF_BM = self.MDEF_BM - addMDEF;
end

function SCR_BUFF_ENTER_Guild_ShieldCharger_buff(self, buff, arg1, arg2, over)
    local shieldOwner = GetBuffCaster(buff)
    if shieldOwner == nil then
        return
    end
    AddBuff(self, self, "ShieldCharger_Check_Buff",1,0,90000)

    local shieldOwnerMHP = TryGetProp(shieldOwner, "MHP") - TryGetProp(shieldOwner, "MHP_BM")
    local shieldValue = math.floor((shieldOwnerMHP)*(0.3 + (0.07 * arg1)))
    
    if shieldValue >= (self.MHP * 2) then
        shieldValue = (self.MHP * 2)
    end
    SetBuffArgs(buff, shieldValue)
    AddShield(self, shieldValue)
end

function SCR_BUFF_UPDATE_Guild_ShieldCharger_buff(self, buff, arg1, arg2)
    local shiedlValue = GetBuffArgs(buff)
    local currentShield = GetShield(self)
    local updateShiedlValue = shiedlValue * 0.03
    if (currentShield + updateShiedlValue) <= (shiedlValue/2) then
        AddShield(self, updateShiedlValue)
    end
    
    return 1
end

function SCR_BUFF_LEAVE_Guild_ShieldCharger_buff(self, buff, arg1, arg2, over)
    local currentShield = GetShield(self)
    AddShield(self, -currentShield)
end

function SCR_BUFF_ENTER_ShieldCharger_Check_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_ShieldCharger_Check_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_BattleOrders_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local lv = arg1;
    
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local pad = GetPadByBuff(caster, buff);
        if pad ~= nil then
            lv = GetPadArgNumber(pad, 1);
        end
    end
    
    local mspdadd =  math.floor(7 + arg1 * 1.5); 
    self.MSPD_BM = self.MSPD_BM - mspdadd;
    SetExProp(buff, "ADD_MSPD", mspdadd);
end


function SCR_BUFF_LEAVE_BattleOrders_Debuff(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM + mspdadd;
    
    local decreaseCRT = GetExProp(buff, 'DECREASE_CRT_ABIL');
    self.CRTDR_BM = self.CRTDR_BM + decreaseCRT;
    
end

function SCR_BUFF_ENTER_Judgment_Debuff(self, buff, arg1, arg2, over)
    SetExProp_Str(self, 'CHANGE_RACETYPE', self.RaceType)
    
    if IS_PC(self) == false then
        self.RaceType = "Velnias"
    end
end

function SCR_BUFF_LEAVE_Judgment_Debuff(self, buff, arg1, arg2, over)
    local raceType = GetExProp_Str(self, 'CHANGE_RACETYPE')
    
    self.RaceType = raceType
end

function SCR_BUFF_ENTER_SilverBullet_Buff(self, buff, arg1, arg2, over)
    local sklList, cnt = GetPCSkillList(self);
    for i = 1, cnt do
        if sklList[i].AttackType == 'Gun' then
            SetExProp_Str(buff, "GUN_ATTRIBUTE"..i, sklList[i].Attribute);
            sklList[i].Attribute = 'Holy'
        end
    end
end

function SCR_BUFF_LEAVE_SilverBullet_Buff(self, buff, arg1, arg2, over)
    local sklList, cnt = GetPCSkillList(self);
    for i = 1, cnt do
        if sklList[i].AttackType == 'Gun'then
            sklList[i].Attribute = GetExProp_Str(buff, "GUN_ATTRIBUTE"..i);
        end
    end
end

function SCR_BUFF_ENTER_DoubleGunStance_Buff(self, buff, arg1, arg2, over, skill)
    RunScript('SCR_DoubleGunStance_TEMP', self)
    ChangeNormalAttack(self, "DoubleGun_Attack");
end

function SCR_DoubleGunStance_TEMP(self)
    sleep(400);
    PlayAnim(self, "SKL_DOUBLEGUN_ASTD", 1)
end

function SCR_BUFF_UPDATE_DoubleGunStance_Buff(self, buff, arg1, arg2, over, skill)
    local ridingCompanion = GetRidingCompanion(self);
    if ridingCompanion ~= nil then
        return 0;
    end
    
    if IsBuffApplied(self, "HangingShot") == "YES" then
        return 0;
    end
    
    local weaponType = GetEquipItem(self, "LH")
    if weaponType.ClassType ~= "Pistol" then
        return 0;
    end
    
    return 1
end

function SCR_BUFF_LEAVE_DoubleGunStance_Buff(self, buff, arg1, arg2, over)
    ChangeNormalAttack(self, "None");
end



function SCR_BUFF_ENTER_Immolation_Buff(self, buff, arg1, arg2, over, skill)
    local abil_Zealot1 = GetAbility(self, "Zealot1")
    local abil_Zealot4 = GetAbility(self, "Zealot4")
    local fireATK = 0
    local fireRES = 0
    
    if abil_Zealot1 ~= nil and abil_Zealot1.ActiveState == 1 then
        fireATK = abil_Zealot1.Level * 100
    end
    
    if abil_Zealot4 ~= nil and abil_Zealot4.ActiveState == 1 then
        fireRES = abil_Zealot4.Level * 300
    end
    
    self.Fire_Atk_BM = self.Fire_Atk_BM + fireATK
    self.ResFire_BM = self.ResFire_BM + fireRES
    
    SetExProp(buff, "IMMOLATION_FIREATK", fireATK)
    SetExProp(buff, "IMMOLATION_FIRERES", fireRES)
end

function SCR_BUFF_LEAVE_Immolation_Buff(self, buff, arg1, arg2, over)
    local fireATK = GetExProp(buff, "IMMOLATION_FIREATK")
    local fireRES = GetExProp(buff, "IMMOLATION_FIRERES")
    
    self.Fire_Atk_BM = self.Fire_Atk_BM - fireATK
    self.ResFire_BM = self.ResFire_BM - fireRES
            end



function SCR_BUFF_ENTER_Immolation_Debuff(self, buff, arg1, arg2, over, skill)
    
        end

function SCR_BUFF_UPDATE_Immolation_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    if caster == nil then
        return 0;
    end
    
    local damage = GET_SKL_DAMAGE(caster, self, 'Zealot_Immolation');
    
    TakeDamage(caster, self, "Zealot_Immolation", damage, "Fire", "Melee", "Melee", HIT_BASIC_NOT_CANCEL_CAST, HITRESULT_NONE, 0, 0)
    
    return 1;
end



function SCR_BUFF_LEAVE_Immolation_Debuff(self, buff, arg1, arg2, over)
    
end



function SCR_BUFF_ENTER_Immolation_Self_Buff(self, buff, arg1, arg2, over, skill)

end

function SCR_BUFF_UPDATE_Immolation_Self_Buff(self, buff, arg1, arg2, over)
    local MHP = TryGetProp(self, "MHP");
    local HP = TryGetProp(self, "HP");
    local ImmolationHP = MHP * 0.01;
    
    if HP <= ImmolationHP then
        return 0;
    end
	
    AddHP(self, -ImmolationHP)
    
    return 1;
end

function SCR_BUFF_LEAVE_Immolation_Self_Buff(self, buff, arg1, arg2, over)
    
end


function SCR_BUFF_ENTER_Fanaticism_Buff(self, buff, arg1, arg2, over, skill)
    local caster = GetBuffCaster(buff);
    local FanaticismSklLv = GetSkill(caster, 'Zealot_Fanaticism');
    if FanaticismSklLv ~= nil then
        SetBuffArgs(buff, FanaticismSklLv.Level, 0, 0);
    end
end

function SCR_BUFF_UPDATE_Fanaticism_Buff(self, buff, arg1, arg2, over)
    if IsBuffApplied(self, 'HealingFactor_Buff') == "YES" then
        RemoveBuff(self, 'HealingFactor_Buff')
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_Fanaticism_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_ENTER_Sprint_Buff(self, buff, arg1, arg2, over, skill)
    local moveSpeed = 10
    local list, cnt = SelectObject(self, 200, 'ENEMY');
    if cnt == nil then
        return;
    end
    
    if cnt >= 5 then
        cnt = 5
    end
    
    moveSpeed = math.floor(moveSpeed + (moveSpeed * (cnt * 0.1)))
    
    self.MSPD_BM = self.MSPD_BM + moveSpeed
    SetExProp(buff, "ADD_MSPD", moveSpeed);
end

function SCR_BUFF_LEAVE_Sprint_Buff(self, buff, arg1, arg2, over)
    local moveSpeed = GetExProp(buff, "ADD_MSPD")
    
    self.MSPD_BM = self.MSPD_BM - moveSpeed
end

function SCR_BUFF_ENTER_DragoonHelmet_Buff(self, buff, arg1, arg2, over, skill)
    EquipDummyItemSpot(self, self, 10008, 'HELMET', 0);
end

function SCR_BUFF_LEAVE_DragoonHelmet_Buff(self, buff, arg1, arg2, over)
    EquipDummyItemSpot(self, self, 0, 'HELMET', 0);
end

function SCR_BUFF_ENTER_Prevent_Buff(self, buff, arg1, arg2, over, skill)
    
end

function SCR_BUFF_UPDATE_Prevent_Buff(self, buff, arg1, arg2, over)
    REMOVE_BUFF_BY_LEVEL(self, "Debuff", 99);
    
    return 1;
end

function SCR_BUFF_LEAVE_Prevent_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_ENTER_EnchantEarth_Buff(self, buff, arg1, arg2, over, skill)
    local caster = GetBuffCaster(buff);
    local EnchantEarthSklLv = GetSkill(caster, 'Enchanter_EnchantEarth');
    if EnchantEarthSklLv ~= nil then
        SetBuffArgs(buff, EnchantEarthSklLv.Level, 0, 0);
    end
end

function SCR_BUFF_LEAVE_EnchantEarth_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_ENTER_FanaticIllusion_Buff(self, buff, arg1, arg2, over, skill)
    local skl = GetSkill(self, "Zealot_FanaticIllusion")
    if skl == nil then
        return;
    end
    
    local x, y, z = GetPos(self)
    RunPad(self, "FanaticIllusion_pad", skl, x, y, z, 0, 1)
    
    local abilHR = 0
    local abil = GetAbility(self, "Zealot6")
    if abil ~= nil and abil.ActiveState == 1 then
        abilHR = abil.Level * 100
    end
    
    self.HR_BM = self.HR_BM + abilHR
    
    SetExProp(buff, "ABIL_FANATIC_HR", abilHR)
end

function SCR_BUFF_UPDATE_FanaticIllusion_Buff(self, buff, arg1, arg2, over)
	local skill = GetSkill(self, 'Zealot_FanaticIllusion');
	if skill == nil then
		return 0;
	end
	
	local spendSP = SCR_Get_SpendSP_FanaticIllusion(skill);
	
	local mySP = TryGetProp(self, 'SP');
	if mySP == nil then
		mySP = 0;
	end
	
	if mySP < spendSP then
		return 0;
	end
	
    AddSP(self, -spendSP)
    
    return 1;
end

function SCR_BUFF_LEAVE_FanaticIllusion_Buff(self, buff, arg1, arg2, over)
    local abilHR = GetExProp(buff, "ABIL_FANATIC_HR")
    
    self.HR_BM = self.HR_BM - abilHR
    
    RemovePad(self, "FanaticIllusion_pad")
end

function SCR_BUFF_ENTER_Methadone_Buff(self, buff, arg1, arg2, over, skill)
    
end

function SCR_BUFF_LEAVE_Methadone_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_ENTER_TracerBullet_Buff(self, buff, arg1, arg2, over, skill)
    local hrValue = 50 + (arg1 * 5)
    
    self.HR_BM = self.HR_BM + hrValue
    SetExProp(buff, "TRACER_HR", hrValue)
end

function SCR_BUFF_LEAVE_TracerBullet_Buff(self, buff, arg1, arg2, over)
    local hrValue = GetExProp(buff, "TRACER_HR")
    
    self.HR_BM = self.HR_BM - hrValue
end

function SCR_BUFF_ENTER_ShadowPool_Buff(self, buff, arg1, arg2, over, skill)
    SetShadowRender(self, 0);
    AddLimitationSkillList(self, "Shadowmancer_ShadowPool");
    
    self.Jumpable = self.Jumpable - 1;
end

function SCR_BUFF_UPDATE_ShadowPool_Buff(self, buff, arg1, arg2, over)
   local x, y, z = GetPos(self);    
    --PlayEffectToGround(self, "None", x, y, z, 1, 1);
    PlayEffectToGround(self, "F_wizard_ShadowPool_shot", x, y, z, 1, 1);
   
   return 1;
end

function SCR_BUFF_LEAVE_ShadowPool_Buff(self, buff, arg1, arg2, over)
    StartCoolTimeAndSpendSP(self, "Shadowmancer_ShadowPool");
    ClearLimitationSkillList(self);
    local x, y, z = GetPos(self);   
    PlayEffectToGround(self, "F_wizard_ShadowPool_end", x, y, z, 1, 1);
    SetShadowRender(self, 1);
    
    self.Jumpable = self.Jumpable + 1;
end

function SCR_BUFF_ENTER_Ole_Buff(self, buff, arg1, arg2, over, skill)
    local skillLevel = arg1
    
    SetExProp(buff, "OLE_LEVEL", skillLevel)
end

function SCR_BUFF_LEAVE_Ole_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_ENTER_Capote_Buff(self, buff, arg1, arg2, over, skill)
    local objList, objCount = SelectObject(self, 300, 'ENEMY');
    
    if objCount >= 1 then
        local monList = { };
        local normalMonList = { };
        for i = 1, objCount do
            local mon = objList[i];
            if TryGetProp(mon, 'MonRank') == 'Boss' then
                monList[#monList + 1] = mon;
            else
                normalMonList[#normalMonList + 1] = mon;
            end
        end
        
        for i = 1, #normalMonList do
            monList[#monList + 1] = normalMonList[i];
        end
        
        local tauntCount = 5;
        local abilMatador13 = GetAbility(self, "Matador13")
        if abilMatador13 ~= nil and abilMatador13.ActiveState == 1 then
        	tauntCount = tauntCount + abilMatador13.Level
        end
        
        if #monList < tauntCount then
            tauntCount = #monList;
        end
        
        for i = 1, tauntCount do
            local obj = monList[i]; 
            if obj ~= nil then
                local skill = GetSkill(self, "Matador_Capote")
                AddBuff(self, obj, 'Capote_Debuff', arg1, 0, 10000 + (skill.Level * 1000), 1)
            end
        end
    end
end

function SCR_BUFF_LEAVE_Capote_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Capote_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    ObjectColorBlend(self, 255, 160, 150, 255, 1, 1.5)
    
    local buffCaster = GetBuffCaster(buff);
    local spdAdd = 10
    if IS_PC(self) == false then
        if self.MonRank ~= "BOSS" then
            self.MSPD_BM = self.MSPD_BM + spdAdd
            SetExProp(self, "CAPOTE_SPD", spdAdd);
        end
        if IsBuffApplied(self, "ProvocationImmunity_Debuff") == "NO" then
            SetFociblyHater(self, buffCaster)
            AddBuff(buffCaster, self, "ProvocationImmunity_Debuff", 0, 0, 30000, 1);
        end
    end
    
    local HR = TryGetProp(self, "HR")
    local DR = TryGetProp(self, "DR")
    local hrRate = HR * 0.2
    local drRate = DR * 0.2
    
    local caster = GetBuffCaster(buff)
    local CrtDR = TryGetProp(self, "CRTDR")
    local CrtDRvalue = 0
    if caster ~= nil then
        local abil = GetAbility(caster, "Matador6")
        if abil ~= nil then
            CrtDRvalue = 50
        end
    end
    
    self.HR_BM = self.HR_BM - hrRate
    self.DR_BM = self.DR_BM - drRate
    self.CRTDR_BM = self.CRTDR_BM - CrtDRvalue
    
    SetExProp(buff, "CAPOTE_HR", hrRate)
    SetExProp(buff, "CAPOTE_DR", drRate)
    SetExProp(buff, "CAPOTE_CRTDR", CrtDRvalue)
end

function SCR_BUFF_LEAVE_Capote_Debuff(self, buff, arg1, arg2, over)
    ObjectColorBlend(self, 255, 255, 255, 255, 1, 1)
    
    local buffCaster = GetBuffCaster(buff)
    if IS_PC(self) == false then
        if self.MonRank ~= "BOSS" then
            self.MSPD_BM = self.MSPD_BM - GetExProp(self, "CAPOTE_SPD")
        end
        
        local currentTarget = GetFociblyHater(self)
        if IsSameActor(currentTarget, buffCaster) == "YES" then
            RemoveFociblyHater(self)
        end
    end
    
    local hrRate = GetExProp(buff, "CAPOTE_HR")
    local drRate = GetExProp(buff, "CAPOTE_DR")
    local CrtDRvalue = GetExProp(buff, "CAPOTE_CRTDR")
    
    self.HR_BM = self.HR_BM + hrRate
    self.DR_BM = self.DR_BM + drRate
    self.CRTDR_BM = self.CRTDR_BM + CrtDRvalue
end

function SCR_BUFF_ENTER_Tase_Debuff(self, buff, arg1, arg2, over, skill)
    local atkCount = 10
    local caster = GetBuffCaster(buff)
    local abil = GetAbility(caster, "Bulletmarker7")
    if abil ~= nil then
        atkCount = atkCount + abil.Level
    end
    
    SetExProp(buff, "TaseAttackCount", atkCount)
end

function SCR_BUFF_LEAVE_Tase_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_SmashBullet_Debuff(self, buff, arg1, arg2, over, skill)
    
end

function SCR_BUFF_UPDATE_SmashBullet_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local caster = GetBuffCaster(buff);
    local skill = GetSkill(caster, "Bulletmarker_SmashBullet")
    local atk = GET_SKL_DAMAGE(caster, self, 'Bulletmarker_SmashBullet');
    
--    TakeDamage(caster, self, skill.ClassName, atk, skill.Attribute, skill.AttackType, "TrueDamage", HIT_BLEEDING, HITRESULT_NO_HITSCP)
    TakeDamage(caster, self, skill.ClassName, atk, skill.Attribute, skill.AttackType, "AbsoluteDamage",HIT_BLEEDING, HITRESULT_NO_HITSCP);
    return 1;
end

function SCR_BUFF_LEAVE_SmashBullet_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_HakkaPalle_Buff(self, buff, arg1, arg2, over, skill)
    local atkspdadd = 10 + arg1
    SetExProp(buff, "HakkaPalle_AtkSpeedAdd", atkspadadd)
    SET_NORMAL_ATK_SPEED(self, -atkspdadd)
    
    local caster = GetBuffCaster(buff);
    local HakkaPalleSklLv = GetSkill(caster, 'Hackapell_HakkaPalle');
    if HakkaPalleSklLv ~= nil then
        SetBuffArgs(buff, HakkaPalleSklLv.Level, 0, 0);
    end
    
    local addMoveSTA = -0.3;
    
    self.MOVESTA_RATE_BM = self.MOVESTA_RATE_BM + addMoveSTA;
    SetExProp(buff, 'MOVE_STA_RATE', addMoveSTA);
end

function SCR_BUFF_UPDATE_HakkaPalle_Buff(self, buff, arg1, arg2, RemainTime, ret, over)

    if 1 ~= GetVehicleState(self) then
        RemoveBuff(self, "HakkaPalle_Buff");
    end
    return 1;

end

function SCR_BUFF_LEAVE_HakkaPalle_Buff(self, buff, arg1, arg2, over)
    local atkspdadd = GetExProp(buff, "HakkaPalle_AtkSpeedAdd")
    SET_NORMAL_ATK_SPEED(self, atkspdadd)
    
    local addMoveSTA = GetExProp(buff, 'MOVE_STA_RATE');
    
    self.MOVESTA_RATE_BM = self.MOVESTA_RATE_BM - addMoveSTA;
end

function SCR_BUFF_ENTER_SnipersSerenity_Buff(self, buff, arg1, arg2, over)
    local castTime, skillID, maxCastingTime, isLoopingCharge = GetDynamicCastingSkill(self);
    local chargingRate = castTime/maxCastingTime
    SetExProp(buff, "SNIPERS_CHARGE", chargingRate)
    
    local maxATK = TryGetProp(self, "MAXPATK");
    if maxATK == nil then
        maxATK = 0;
    end
    local minATK = TryGetProp(self, "MINPATK");
    if minATK == nil then
        minATK = 0;
    end
    
    local addATK = (maxATK - minATK) * chargingRate;
    addATK = math.floor(addATK);
    
    self.MINPATK_BM = self.MINPATK_BM + addATK;
    
    SetExProp(buff, 'SNIPERS_SERENITY_MINATK', addATK);
end

function SCR_BUFF_UPDATE_SnipersSerenity_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
--    if (GetMoveState(self)) == "MS_MOVE_DIR" then
--        return 0;
--    end

    local rItem = GetEquipItem(self, 'RH')
    if rItem == nil or rItem.AttachType ~= "Musket" then
        return 0;
    end
   
    return 1;
end

function SCR_BUFF_LEAVE_SnipersSerenity_Buff(self, buff, arg1, arg2, over, isLast)
    local addATK = GetExProp(buff, 'SNIPERS_SERENITY_MINATK');
    
    self.MINPATK_BM = self.MINPATK_BM - addATK;
    
    if isLast == 1 then
    	AddCoolDown(self, 'SnipersSerenity', 1000);
    end
end

function SCR_BUFF_ENTER_Enervation_Debuff(self, buff, arg1, arg2, over)
    local atkCount = 10
    SetExProp(buff, "EnervationAttackCount", atkCount)
end

function SCR_BUFF_LEAVE_Enervation_Debuff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_SeeRed_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff)
    local topAttacker = GetTopHatePointChar(self)
    local hatePoint = GetHate(self, topAttacker)
    
    hatePoint = hatePoint * 2
    InsertHate(self, caster, hatePoint)
    
    local minPATK = 0.5
    local maxPATK = 0.1
    
    self.MINPATK_RATE_BM = self.MINPATK_RATE_BM - minPATK
    self.MAXPATK_RATE_BM = self.MAXPATK_RATE_BM + maxPATK
    
    SetExProp(buff, "SEERED_MINPATK", minPATK)
    SetExProp(buff, "SEERED_MAXPATK", maxPATK)
    SetExProp(buff, "SEERED_HATE", hatePoint)
end

function SCR_BUFF_LEAVE_SeeRed_Debuff(self, buff, arg1, arg2, over)
    local hatePoint = GetExProp(buff, "SEERED_HATE")
    local minPATK = GetExProp(buff, "SEERED_MINPATK")
    local maxPATK = GetExProp(buff, "SEERED_MAXPATK")
    local caster = GetBuffCaster(buff)
    if caster ~= nil then
        InsertHate(self, caster, -hatePoint)
    end
    
    self.MINPATK_RATE_BM = self.MINPATK_RATE_BM + minPATK
    self.MAXPATK_RATE_BM = self.MAXPATK_RATE_BM - maxPATK
end

function SCR_BUFF_ENTER_DownFall_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_DownFall_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local buffCaster = GetBuffCaster(buff)
    if buffCaster == nil then
        return;
    end
    
    local skill = GetSkill(buffCaster, "Mergen_DownFall")
    if skill == nil then
        return;
    end
    
    local damage = GET_SKL_DAMAGE(buffCaster, self, "Mergen_DownFall");
    local range = GetDistance(buffCaster, self);
    local limitRange = skill.MaxRValue
    
    if range <= limitRange then
        AttachEffect(self, "I_archer_ArrowRain_hit_mash", 1, "BOT")
        TakeDamage(buffCaster, self, skill.ClassName, damage, skill.Attribute, skill.AttackType, skill.ClassType, hitType, resultType, attackerHitdelay, fixHitdelay)
    end
    return 1;
end

function SCR_BUFF_LEAVE_DownFall_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_ENTER_Hallucination_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_Hallucination_Buff(self, buff, arg1, arg2, over)
    CLEAR_DUMMYPC_FOR_EXPROP(self, "EXPROP_SHADOW_DUMMYPC")
end

function SCR_BUFF_ENTER_NonInvasiveArea_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_NonInvasiveArea_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_BlindFaith_Buff(self, buff, arg1, arg2, over)
    local SP = TryGetProp(self, "SP")
    local blindFaithSP = math.floor(SP * 0.5)
    local atkCount = 40
    SetExProp(buff, "BlindFaith_Count", atkCount)
    
    AddSP(self, -blindFaithSP)
    
    SetExProp(buff, "BLINDFAITH_REMAINSP", blindFaithSP)
end

function SCR_BUFF_UPDATE_BlindFaith_Buff(self, buff, arg1, arg2, over)
    PlayEffectNode(self, "F_cleric_blindfaith_buff", 1.0, "Dummy_L_HAND")
    
    return 1;
end

function SCR_BUFF_LEAVE_BlindFaith_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_ENTER_CantTakeExperience(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_CantTakeExperience(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_BeadyEyed_Buff(self, buff, arg1, arg2, over)
    local abil = GetAbility(self, "Zealot5")
    if abil ~= nil and abil.ActiveState == 1 then
        local abilCRTHR = abil.Level * 20
        
        self.CRTHR_BM = self.CRTHR_BM + abilCRTHR
        
        SetExProp(buff, "BEADTEYED_ABIL_CRTHR", abilCRTHR)
    end
end

function SCR_BUFF_LEAVE_BeadyEyed_Buff(self, buff, arg1, arg2, over)
    local abilCRTHR = GetExProp(buff, "BEADTEYED_ABIL_CRTHR")
    
    self.CRTHR_BM = self.CRTHR_BM - abilCRTHR
end

function SCR_BUFF_ENTER_ShadowConjuration_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_ShadowConjuration_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff)
    if caster == nil then
        return;
    end
    
    local skill = GetSkill(caster, "Shadowmancer_ShadowConjuration")
    if skill == nil then
        return;
    end
    
    local damage = GetExProp(self, "ConjurationDamage")
    damage = damage * 0.1
    
    if IS_PC(self) == false then
        if self.MoveType == "Flying" then
            return
        end
        
        if self.MoveType == "Normal" or self.MoveType == "Holding" then
            TakeDamage(caster, self, skill.ClassName, damage, skill.Attribute, skill.AttackType, "AbsoluteDamage", HIT_DARK, HITRESULT_NO_HITSCP)
        end
    else
        TakeDamage(caster, self, skill.ClassName, damage, skill.Attribute, skill.AttackType, "AbsoluteDamage", HIT_DARK, HITRESULT_NO_HITSCP)
    end
    
    return 1
end

function SCR_BUFF_LEAVE_ShadowConjuration_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_ENTER_BackSlide_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_BackSlide_Buff(self, buff, arg1, arg2, over)
    
end
function SCR_BUFF_ENTER_MicroDimension_Debuff(self, buff, arg1, arg2, over)
--    SetExProp(self, "SKILL_DIEMNSION_DEBUFF_APPLIED", 1)
end

function SCR_BUFF_LEAVE_MicroDimension_Debuff(self, buff, arg1, arg2, over)
    local buffCaster = GetBuffCaster(buff)
    if buffCaster == nil then
        return
    end
    
    local dimensionSkill = GetSkill(buffCaster, "Sage_MicroDimension")
    
    if dimensionSkill == nil then
        return
    end
    
    local list, cnt = SelectObjectNear(buffCaster, self, 80, "ENEMY")
    if cnt <= 0 then
        return
    end
    
    if cnt >= 10 then
        cnt = 10
    end
    
    local atk = 0
    
    local nextTime = GetAddDataFromCurrent(1);
    
    for i = 1, cnt do
        local saveTime = GetExProp_Str(list[i], 'ABIL_SAGE11_COOLTIME');
        local coolTime = 1;
        if saveTime ~= 'None' and saveTime ~= nil then
            coolTime = GetTimeDiff(saveTime);
        end
        
        if coolTime > 0 then
            atk = GET_SKL_DAMAGE(buffCaster, list[i], 'Sage_MicroDimension')
            TakeDamage(buffCaster, list[i], dimensionSkill.ClassName, atk, dimensionSkill.Attribute, dimensionSkill.AttackType, dimensionSkill.ClassType, HIT_DARK, HITRESULT_NO_HITSCP)
            SetExProp_Str(list[i], "ABIL_SAGE11_COOLTIME", nextTime);
        end
    end
end



function SCR_BUFF_ENTER_UltimateDimension_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_UltimateDimension_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local buffCaster = GetBuffCaster(buff)
    if buffCaster == nil then
        return 0;
    end
    
    local ultimateSkill = GetSkill(buffCaster, "Sage_UltimateDimension")
    if ultimateSkill == nil then
        return 0;
    end
    
    atk = GET_SKL_DAMAGE(buffCaster, self, 'Sage_UltimateDimension')
    TakeDamage(buffCaster, self, ultimateSkill.ClassName, atk, "None", ultimateSkill.AttackType, ultimateSkill.ClassType, HIT_BASIC, HITRESULT_NO_HITSCP)
    
    return 1;
end

function SCR_BUFF_LEAVE_UltimateDimension_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_LightningHands_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_LightningHands_Debuff(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_SteedCharge_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_SteedCharge_Buff(self, buff, arg1, arg2, over)
    if GetVehicleState(self) == 0 then
        RemoveBuff(self, "SteedCharge_Buff");
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_SteedCharge_Buff(self, buff, arg1, arg2, over)
	local skill = GetSkill(self, 'Cataphract_SteedCharge')
	if IsCoolTime(skill) == 0 then
		AddCoolDown(self, 'SteedCharge', 8000)
	end
end


function SCR_BUFF_ENTER_DoomSpike_Debuff(self, buff, arg1, arg2, over)
    local crtDR = 10 * arg1
    
    self.CRTDR_BM = self.CRTDR_BM - crtDR
    
    SetExProp(buff, "DOOMSPIKE_CRTDR", crtDR)
end

function SCR_BUFF_LEAVE_DoomSpike_Debuff(self, buff, arg1, arg2, over)
	local crtDR = GetExProp(buff, "DOOMSPIKE_CRTDR")
	
	self.CRTDR_BM = self.CRTDR_BM + crtDR
end


function SCR_BUFF_ENTER_AcrobaticMount_Buff(self, buff, arg1, arg2, over)
	local caster = GetBuffCaster(buff)
    local AcrobaticMountSklLv = GetSkill(caster, 'Cataphract_AcrobaticMount');
    if AcrobaticMountSklLv ~= nil then
        SetBuffArgs(buff, AcrobaticMountSklLv.Level, 0, 0);
    end
end

function SCR_BUFF_UPDATE_AcrobaticMount_Buff(self, buff, arg1, arg2, over)
    if GetVehicleState(self) == 0 then
        RemoveBuff(self, "AcrobaticMount_Buff");
    end
    
    local remainSP = TryGetProp(self, "SP")
    local AcrobaticMountSP = GetExProp(buff, "ACROBATICMOUNT_SPENDSP")
    
    if remainSP < AcrobaticMountSP then
    	RemoveBuff(self, "AcrobaticMount_Buff");
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_AcrobaticMount_Buff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_ENTER_BuildRoost_Buff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_LEAVE_BuildRoost_Buff(self, buff, arg1, arg2, over)
	
end


function SCR_BUFF_ENTER_RamMuay_Buff(self, buff, arg1, arg2, over, skill)
    
end

function SCR_BUFF_UPDATE_RamMuay_Buff(self, buff, arg1, arg2, over, skill)
    if IS_REAL_PC(self) == "YES" then
        if GetExProp(self, "BUNSIN") == 0 then
            local ridingCompanion = GetRidingCompanion(self);
            if ridingCompanion ~= nil then
                return 0;
            end
        	
            local rammuaySkill = GetSkill(self, "NakMuay_RamMuay")
            if rammuaySkill == nil then
                return 0;
            end
            
            local equipByLhand = GetEquipItem(self, "LH")
            if equipByLhand.ClassName == "NoWeapon" then
                ChangeLHandAttack(self, "None")
            else
                ChangeLHandAttack(self, "NakMuay_Attack")
            end
        end
    end
    
    ChangeNormalAttack(self, "NakMuay_Attack");
    return 1
end

function SCR_BUFF_LEAVE_RamMuay_Buff(self, buff, arg1, arg2, over)
    ChangeNormalAttack(self, "None");
    ChangeLHandAttack(self, "None")
end

function SCR_BUFF_ENTER_TeKha_Debuff(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
    local mspdAdd = TryGetProp(self, "MSPD") * 0.5;
    self.MSPD_BM = self.MSPD_BM - mspdAdd;
    SetExProp(buff, "TEKHA_ADD_MSPD", mspdAdd);
end


function SCR_BUFF_LEAVE_TeKha_Debuff(self, buff, arg1, arg2, over)
    local mspdAdd = GetExProp(buff, "TEKHA_ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM + mspdAdd;
end

function SCR_BUFF_ENTER_SokChiang_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    local dmg = (caster.MINPATK + caster.MINPATK) / 10;
    SetExProp(self, 'CriticalWound_Damage', dmg)
end

function SCR_BUFF_UPDATE_SokChiang_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local caster = GetBuffCaster(buff);
    if caster == nil then
        caster = self;
    end
    local dmg = GetExProp(self, 'CriticalWound_Damage')
    TakeDamage(caster, self, "None", dmg, "None", "None", "TrueDamage", HIT_BLEEDING, HITRESULT_BLOW, 0, 0);   
    return 1;

end

function SCR_BUFF_LEAVE_SokChiang_Debuff(self, buff, arg1, arg2, over)

end



function SCR_BUFF_ENTER_Muleta_Buff(self, buff, arg1, arg2, over)
	local skillLevel = arg1;
	
	local skill = GetSkill(self, 'Matador_Muleta')
	if skill ~= nil then
		local muletaLevel = TryGetProp(skill, 'Level');
		if muletaLevel ~= nil then
			skillLevel = muletaLevel;
		end
	end
	
	local addCRTHR = skillLevel * 10;
	
	SetExProp(buff, 'ADD_CRTHR', addCRTHR);
	
	self.CRTHR_BM = self.CRTHR_BM + addCRTHR;
end

function SCR_BUFF_LEAVE_Muleta_Buff(self, buff, arg1, arg2, over)
	local addCRTHR = GetExProp(buff, 'ADD_CRTHR');
	
	self.CRTHR_BM = self.CRTHR_BM - addCRTHR;
end



function SCR_BUFF_ENTER_Muleta_Cast_Buff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_LEAVE_Muleta_Cast_Buff(self, buff, arg1, arg2, over)
	
end



function SCR_BUFF_ENTER_Skill_NoDamage_Buff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_LEAVE_Skill_NoDamage_Buff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_ENTER_Skill_SuperArmor_Buff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_LEAVE_Skill_SuperArmor_Buff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_ENTER_Skill_MomentaryEvasion_Buff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_LEAVE_Skill_MomentaryEvasion_Buff(self, buff, arg1, arg2, over)
	
end


function SCR_BUFF_ENTER_GroovingMuzzle_Buff(self, buff, arg1, arg2, over)
	local addHR = 100;
	
	SetExProp(buff, 'ADD_HR', addHR);
	
	self.HR = self.HR + addHR;
end

function SCR_BUFF_UPDATE_GroovingMuzzle_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    local rItem = GetEquipItem(self, 'RH');
    if TryGetProp(rItem, "ClassType") ~= "Musket" then
    	return 0;
	end
	
	return 1;
end

function SCR_BUFF_LEAVE_GroovingMuzzle_Buff(self, buff, arg1, arg2, over)
	local addHR = GetExProp(buff, 'ADD_HR');
	
	self.HR = self.HR - addHR;
end




function SCR_BUFF_ENTER_MusketAttack_CoolDown_Buff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_LEAVE_MusketAttack_CoolDown_Buff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_ENTER_EquipDesrption_Debeff(self, buff, arg1, arg2, over)
    local equipAddDefRate = 0.25
    SetExProp(buff, "EQUIPDESRPTION_ADDDEF_RATE", equipAddDefRate);
    self.DEF_RATE_BM = self.DEF_RATE_BM - equipAddDefRate;
    
    if IS_PC(self) == true then
    	local caster = GetBuffCaster(buff)
    	if caster ~= nil then
    		local abilRetiarii7 = GetAbility(caster, "Retiarii7")
    		if abilRetiarii7 ~= nil and abilRetiarii7.ActiveState == 1 then
		        local buffList = GetBuffList(self);
		        for i = 1, #buffList do
		            local buffKeyword = TryGetProp(buffList[i], "Keyword");
		            if buffKeyword == "Helmet" then
		                RemoveBuff(self, buffList[i].ClassName);
		            end
		        end
		    end
	        
	        local DesrptionItem = GetEquipItem(self, "LH");
	        if DesrptionItem.ClassType == "Shield" then 
	            UnEquipItemSpot(self, "LH")
	            EnableEquipItemBySlot(self, "LH", 0);
	        end
	    end
    end
end

function SCR_BUFF_UPDATE_EquipDesrption_Debeff(self, buff, arg1, arg2, over)
    if IS_PC(self) == true then
        local DesrptionItem = GetEquipItem(self, "LH");
        if DesrptionItem.ClassType == "Shield" then
            UnEquipItemSpot(self, "LH")
            EnableEquipItemBySlot(self, "LH", 0);
        end
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_EquipDesrption_Debeff(self, buff, arg1, arg2, over)
    self.DEF_RATE_BM = self.DEF_RATE_BM + GetExProp(buff, "EQUIPDESRPTION_ADDDEF_RATE");
    if IS_PC(self) == true then
        EnableEquipItemBySlot(self, "LH", 1);
    end
end

function SCR_BUFF_ENTER_DaggerGuard_Buff(self, buff, arg1, arg2, over)
    SetExProp(self, "DAGGERGUARD_COUNT", 15)
end

function SCR_BUFF_UPDATE_DaggerGuard_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    local equipLH = GetEquipItem(self, "LH");
    if TryGetProp(equipLH, "GroupName") ~= "SubWeapon" then
        return 0;
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_DaggerGuard_Buff(self, buff, arg1, arg2, over)
    
end


function SCR_BUFF_ENTER_FlameGround_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff)
    if caster == nil then
    	return
    end
    
    local fireResist = 0
    local abilPyromancer27 = GetAbility(caster, "Pyromancer27")
    if abilPyromancer27 ~= nil and abilPyromancer27.ActiveState == 1 then
	    fireResist = abilPyromancer27.Level * 50
    end
    
    if IS_PC(self) == true then
    	self.ResFire_BM = self.ResFire_BM - fireResist
    end
    
    SetExProp(buff, "PYROMANCER27_FIRERESIST", fireResist)
end

function SCR_BUFF_LEAVE_FlameGround_Debuff(self, buff, arg1, arg2, over)
    local fireResist = GetExProp(buff, "PYROMANCER27_FIRERESIST")
    
    if IS_PC(self) == true then
    	self.ResFire_BM = self.ResFire_BM + fireResist
    end
end


function SCR_BUFF_ENTER_HeavyGravity_Debuff(self, buff, arg1, arg2, over)
	if IS_PC(self) == false then
    	SetExProp_Str(self, 'HEAVYGRAVITY_CHANGE_MOVETYPE', self.MoveType)
    	
    	self.MoveType = "Normal"
    end
    
    local abilMoveSpeed = 0
    local caster = GetBuffCaster(buff)
    if caster ~= nil then
    	local abilPsychokino22 = GetAbility(caster, "Psychokino22")
    	if abilPsychokino22 ~= nil and abilPsychokino22.ActiveState == 1 then
    		if IS_PC(self) == true then 
    			abilMoveSpeed = abilPsychokino22.Level * 10
    		elseif IS_PC(self) == false and self.Size == "S" or self.Size == "M" then
    			abilMoveSpeed = abilPsychokino22.Level * 10
    		end
    	end
    end
    
    self.MSPD_BM = self.MSPD_BM - abilMoveSpeed
	
    SetExProp(buff, "HEAVYGRAVITY_MOVESPEED", abilMoveSpeed)
end

function SCR_BUFF_LEAVE_HeavyGravity_Debuff(self, buff, arg1, arg2, over)
	if IS_PC(self) == false then
    	local moveType = GetExProp_Str(self, 'HEAVYGRAVITY_CHANGE_MOVETYPE')
    	
    	self.MoveType = moveType
    end
    
    local abilMoveSpeed = GetExProp(buff, "HEAVYGRAVITY_MOVESPEED")
    
    self.MSPD_BM = self.MSPD_BM + abilMoveSpeed
end

function SCR_BUFF_ENTER_Hagalaz_Debuff(self, buff, arg1, arg2, over)
    local addMdef = 0;
    local buffCaster = GetBuffCaster(buff);
    if buffCaster ~= nil then
        local abil = GetAbility(buffCaster, "RuneCaster8");
        if abil ~= nil and TryGetProp(abil, "ActiveState") == 1 then
            addMdef = TryGetProp(abil, "Level") * 0.03;
            SetExProp(buff, "ABIL_RUNECASTER8_ADDMEDF", addMdef);
        end
        
        self.MDEF_RATE_BM = self.MDEF_RATE_BM - addMdef;
    end
end

function SCR_BUFF_LEAVE_Hagalaz_Debuff(self, buff, arg1, arg2, over)
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + GetExProp(buff, "ABIL_RUNECASTER8_ADDMEDF");
end

function SCR_BUFF_ENTER_StormDust_Debuff(self, buff, arg1, arg2, over)
	local abilMoveSpeed = 0
	local caster = GetBuffCaster(buff)
	if caster ~= nil then
		local atk = GET_SKL_DAMAGE(caster, self, "Elementalist_StormDust");
		local abilElementalist28 = GetAbility(caster, "Elementalist28")
		if abilElementalist28 ~= nil and abilElementalist28.ActiveState == 1 then
			abilMoveSpeed = abilElementalist28.Level * 2
		end
		
		SetBuffArgs(buff, atk, 0, 0)
	end
	
	self.MSPD_BM = self.MSPD_BM - abilMoveSpeed
	
	SetExProp(buff, "STORMDUST_MOVESPEED", abilMoveSpeed)
end

function SCR_BUFF_UPDATE_StormDust_Debuff(self, buff, arg1, arg2, over)
    local atk = GetBuffArgs(buff);
    if atk <= 0 then
        return 0;
    end
        
    local from = self;
    local caster = GetBuffCaster(buff);
    if caster ~= nil then    
        from = caster;
    end
    
    local skill = GetSkill(caster, 'Elementalist_StormDust')
    if skill ~= nil then
        TakeDamage(caster, self, skill.ClassName, atk, "Earth", "Magic", "Magic");
    end
    
    return 1;
end

function SCR_BUFF_LEAVE_StormDust_Debuff(self, buff, arg1, arg2, over)
    local abilMoveSpeed = GetExProp(buff, "STORMDUST_MOVESPEED")
    
    self.MSPD_BM = self.MSPD_BM + abilMoveSpeed
end


function SCR_BUFF_ENTER_SpiritShock_Debuff(self, buff, arg1, arg2, over)
	local abilMdef = 0
	local caster = GetBuffCaster(buff)
	if caster ~= nil then
		local atk = GET_SKL_DAMAGE(caster, self, "Linker_SpiritShock");
		
		SetBuffArgs(buff, atk, 0, 0)
		
		local abilLinker14 = GetAbility(caster, "Linker14")
		if abilLinker14 ~= nil and IsSameActor(self, caster) == "NO" and (abilLinker14.Level * 5) > IMCRandom(1, 100) then
			AddBuff(caster, self, "Confuse", 1, 0, 10000, 1)
		end
		
		local abilLinker15 = GetAbility(caster, "Linker15")
		if abilLinker15 ~= nil and abilLinker15.ActiveState == 1 and IsSameActor(self, caster) == "NO" then
			abilMdef = 0.25
		end
	end
	
	self.MDEF_RATE_BM = self.MDEF_RATE_BM - abilMdef
	
	SetExProp(buff, "SPIRITSHOCK_MDEF", abilMdef)
end

function SCR_BUFF_UPDATE_SpiritShock_Debuff(self, buff, arg1, arg2, over)
    local atk = GetBuffArgs(buff);
    if atk <= 0 then
        return 0;
    end
	
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
	    local skill = GetSkill(caster, 'Linker_SpiritShock')
	    if skill ~= nil and IsSameActor(self, caster) == "NO" then
			TakeDamage(caster, self, skill.ClassName, atk, "Soul", "Magic", "Magic", HIT_BASIC, HITRESULT_BLOW);
	    end
	end
	
    return 1;
end

function SCR_BUFF_LEAVE_SpiritShock_Debuff(self, buff, arg1, arg2, over)
	local abilMdef = GetExProp(buff, "SPIRITSHOCK_MDEF")
	
	self.MDEF_RATE_BM = self.MDEF_RATE_BM + abilMdef
end

function SCR_BUFF_ENTER_Achieve_Possession_Buff(self, buff, arg1, arg2, over)
    local achieve_grade, cnt = GetClassList("AchieveStatReward")
    local AchieveStatReward_Grade_Value = 0
    
    --application grade check
    local grade_cnt = 0
    for i = 1, cnt -1 do
        local cls = GetClassByIndexFromList(achieve_grade, i);
        if cls.AchieveCount <= GetAchieveCount(self) then 
            grade_cnt = grade_cnt + 1
        else
            break;
        end
    end
    
    --application grade buff
    --print(grade_cnt)
    if grade_cnt >= 1 then
        local cls = GetClassByIndexFromList(achieve_grade, grade_cnt);
        AchieveStatReward_Grade_Value = grade_cnt
        local stradd = cls.STR_BM
        local conadd = cls.CON_BM
        local intadd = cls.INT_BM
        local mnaadd = cls.MNA_BM
        local dexadd = cls.DEX_BM
        
        local patkadd = cls.PATK_BM
        local matkadd = cls.MATK_BM
        local defadd = cls.DEF_BM
        local mdefkadd = cls.MDEF_BM
        local mspadd = cls.MSP_BM
            
        self.STR_BM = self.STR_BM + stradd
        self.CON_BM = self.CON_BM + conadd
        self.INT_BM = self.INT_BM + intadd
        self.MNA_BM = self.MNA_BM + mnaadd
        self.DEX_BM = self.DEX_BM + dexadd
        
        self.PATK_BM = self.PATK_BM + patkadd
        self.MATK_BM = self.MATK_BM + matkadd
        self.DEF_BM = self.DEF_BM + defadd
        self.MDEF_BM = self.MDEF_BM + mdefkadd
        self.MSP_BM = self.MSP_BM + mspadd
        
        SetExProp(buff, "ACHIEVE_ADD_STR", stradd);
        SetExProp(buff, "ACHIEVE_ADD_CON", conadd);
        SetExProp(buff, "ACHIEVE_ADD_INT", intadd);
        SetExProp(buff, "ACHIEVE_ADD_MNA", mnaadd);
        SetExProp(buff, "ACHIEVE_ADD_DEX", dexadd);
        
        SetExProp(buff, "ACHIEVE_ADD_PATK", patkadd);
        SetExProp(buff, "ACHIEVE_ADD_MATK", matkadd);
        SetExProp(buff, "ACHIEVE_ADD_DEF", defadd);
        SetExProp(buff, "ACHIEVE_ADD_MDEF", mdefkadd);
        SetExProp(buff, "ACHIEVE_ADD_MSP", mspadd);
        
            -- prop confirmation --
        print("SUM VALUE : "..stradd, conadd, intadd, mnaadd, dexadd, patkadd, matkadd, defadd, mdefkadd, mspadd)
--        print("BM VALUE : "..self.STR_BM, self.CON_BM, self.INT_BM, self.MNA_BM,self.DEX_BM, self.PATK_BM, self.MATK_BM , self.DEF_BM, self.MDEF_BM, self.MSP_BM)
        RunScript("ACHIEVE_POSSESSION_REWARD_FUNC", self, buff, AchieveStatReward_Grade_Value)
    end
end

function SCR_BUFF_LEAVE_Achieve_Possession_Buff(self, buff, arg1, arg2, over)
    local stradd = GetExProp(buff, "ACHIEVE_ADD_STR");
    local conadd = GetExProp(buff, "ACHIEVE_ADD_CON");
    local intadd = GetExProp(buff, "ACHIEVE_ADD_INT");
    local mnaadd = GetExProp(buff, "ACHIEVE_ADD_MNA");
    local dexadd = GetExProp(buff, "ACHIEVE_ADD_DEX");
    
    local patkadd = GetExProp(buff, "ACHIEVE_ADD_PATK");
    local matkadd = GetExProp(buff, "ACHIEVE_ADD_MATK");
    local defadd = GetExProp(buff, "ACHIEVE_ADD_DEF");
    local mdefkadd = GetExProp(buff, "ACHIEVE_ADD_MDEF");
    local mspadd = GetExProp(buff, "ACHIEVE_ADD_MSP");
    
--    print("buff over discount stat "..stradd, conadd, intadd, mnaadd, dexadd, patkadd, matkadd, defadd, mdefkadd, mspadd)
    self.STR_BM = self.STR_BM - stradd;
    self.CON_BM = self.CON_BM - conadd;
    self.INT_BM = self.INT_BM - intadd;
    self.MNA_BM = self.MNA_BM - mnaadd;
    self.DEX_BM = self.DEX_BM - dexadd;
    
    self.PATK_BM = self.PATK_BM - patkadd
    self.MATK_BM = self.MATK_BM - matkadd
    self.DEF_BM = self.DEF_BM - defadd
    self.MDEF_BM = self.MDEF_BM - mdefkadd
    self.MSP_BM = self.MSP_BM - mspadd
    
--    print("buff over "..self.STR_BM, self.CON_BM, self.INT_BM, self.MNA_BM, self.DEX_BM, self.PATK_BM, self.MATK_BM, self.DEF_BM, self.MDEF_BM, self.MSP_BM)
end

function ACHIEVE_POSSESSION_REWARD_FUNC(self, buff, AchieveStatReward_Grade_Value)
    local etc = GetETCObject(self);
    if etc ~= nil then
        if AchieveStatReward_Grade_Value > etc["AchieveStatReward_Grade"] then
            local tx = TxBegin(self);
            TxSetIESProp(tx, etc, "AchieveStatReward_Grade", AchieveStatReward_Grade_Value);
            local ret = TxCommit(tx);
            if ret == "SUCCESS" then
                --print("ACHIEVE_POSSESSION_REWARD_Count :"..AchieveStatReward_Grade_Value)
                SetExProp(self, "Achieve_Grade", AchieveStatReward_Grade_Value);
            else
                print("tx FAIL!")
            end
            --print(etc["AchieveStatReward_Grade"])
        end
        SetBuffArg(self, buff, AchieveStatReward_Grade_Value, 0, 0) --for BUFF_TOOLTIP
    end
end

function SCR_BUFF_ENTER_ProvocationImmunity_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_ProvocationImmunity_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_ProvocationImmunity_Debuff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_SwashBucklingReduceDamage_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_UPDATE_SwashBucklingReduceDamage_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    return 1;
end

function SCR_BUFF_LEAVE_SwashBucklingReduceDamage_Buff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_SwellLeftArm_Abil_Buff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_LEAVE_SwellLeftArm_Abil_Buff(self, buff, arg1, arg2, over)
	
end


function SCR_BUFF_ENTER_SwellRightArm_Abil_Buff(self, buff, arg1, arg2, over)
    local abilDefValue = 0
    local abilMdefValue = 0
    local caster = GetBuffCaster(buff)
    if caster ~= nil then
    	local abilThaumaturge18 = GetAbility(caster, "Thaumaturge18")
    	if abilThaumaturge18 ~= nil then
    		abilDefValue = abilThaumaturge18.Level * 0.05
    		abilMdefValue = abilThaumaturge18.Level * 0.05
    	end
    end
    
    self.DEF_RATE_BM = self.DEF_RATE_BM + abilDefValue
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + abilMdefValue
    
    SetExProp(buff, "RIGHTARM_ABIL_DEF", abilDefValue)
    SetExProp(buff, "RIGHTARM_ABIL_MDEF", abilMdefValue)
end

function SCR_BUFF_LEAVE_SwellRightArm_Abil_Buff(self, buff, arg1, arg2, over)
    local abilDefValue = GetExProp(buff, "RIGHTARM_ABIL_DEF")
    local abilMdefValue = GetExProp(buff, "RIGHTARM_ABIL_MDEF")
    
    self.DEF_RATE_BM = self.DEF_RATE_BM - abilDefValue
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - abilMdefValue
end

function SCR_BUFF_ENTER_sabath_buff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_LEAVE_sabath_buff(self, buff, arg1, arg2, over)
	
end


function SCR_BUFF_ENTER_ElevateMagicSquare_Buff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_LEAVE_ElevateMagicSquare_Buff(self, buff, arg1, arg2, over)
	
end


function SCR_BUFF_ENTER_GreenwoodShikigami_Debuff(self, buff, arg1, arg2, over)
	local moveSpeed = 0
	local caster = GetBuffCaster(buff)
	if caster ~= nil then
		moveSpeed = 10
		
		local abilOnmyoji5 = GetAbility(caster, "Onmyoji5")
		if abilOnmyoji5 ~= nil and abilOnmyoji5.ActiveState == 1 then
			local abilBuffUpdateTime = 1000 - (abilOnmyoji5.Level * 100)
			SetBuffUpdateTime(buff, abilBuffUpdateTime)
		end
	end
	
	self.MSPD_BM = self.MSPD_BM - moveSpeed
	
	SetExProp(buff, "GREENWOOD_MOVESPEED", moveSpeed)
end

function SCR_BUFF_UPDATE_GreenwoodShikigami_Debuff(self, buff, arg1, arg2, over)
	local caster = GetBuffCaster(buff)
	if caster ~= nil then
		local abilOnmyoji5 = GetAbility(caster, "Onmyoji5")
		if abilOnmyoji5 ~= nil and abilOnmyoji5.ActiveState == 1 then
			local damage = GET_SKL_DAMAGE(caster, self, "Onmyoji_GreenwoodShikigami")
			local skill = GetSkill(caster, "Onmyoji_GreenwoodShikigami")
			if skill ~= nil then
				TakeDamage(caster, self, skill.ClassName, damage, "Earth", "Magic", "Magic")
			end
		end
	end
	
	return 1;
end

function SCR_BUFF_LEAVE_GreenwoodShikigami_Debuff(self, buff, arg1, arg2, over)
	local moveSpeed = GetExProp(buff, "GREENWOOD_MOVESPEED")
	
	self.MSPD_BM = self.MSPD_BM + moveSpeed
end


function SCR_BUFF_ENTER_GenbuArmor_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_UPDATE_GenbuArmor_Buff(self, buff, arg1, arg2, over)
	local selfSP = TryGetProp(self, "SP")
	if selfSP <= 0 then
		return 0;
	end
	
    return 1;
end

function SCR_BUFF_LEAVE_GenbuArmor_Buff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_ENTER_WhiteTigerHowling_Buff(self, buff, arg1, arg2, over)
	local moveSpeed = 0
	local caster = GetBuffCaster(buff)
	if caster ~= nil then
		local abilOnmyoji8 = GetAbility(caster, "Onmyoji8")
		if abilOnmyoji8 ~= nil and abilOnmyoji8.ActiveState == 1 then
			 moveSpeed = 10
		end
	end
	
	self.MSPD_BM = self.MSPD_BM + moveSpeed
	
	SetExProp(buff, "WHITETIGER_MOVESPEED", moveSpeed)
end

function SCR_BUFF_LEAVE_WhiteTigerHowling_Buff(self, buff, arg1, arg2, over)
	local moveSpeed = GetExProp(buff, "WHITETIGER_MOVESPEED")
	
	self.MSPD_BM = self.MSPD_BM - moveSpeed
end


function SCR_BUFF_ENTER_Toyou_Debuff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_LEAVE_Toyou_Debuff(self, buff, arg1, arg2, over)
	
end

function SCR_BUFF_ENTER_VitalProtection_Buff(self, buff, arg1, arg2, over)
    local addCrtDr = 0;
    local skill = GetSkill(self, "Retiarii_VitalPointProtection");
    if skill ~= nil then
        addCrtDr = 50 + TryGetProp(skill, "Level") * 20;
        self.CRTDR_BM = self.CRTDR_BM + addCrtDr;
        SetExProp(buff, "VitalProtection_addCrtDr", addCrtDr);
    end
end

function SCR_BUFF_LEAVE_VitalProtection_Buff(self, buff, arg1, arg2, over)
	local addCrtDr = GetExProp(buff, "VitalProtection_addCrtDr");
	self.CRTDR_BM = self.CRTDR_BM - addCrtDr;
end

function SCR_BUFF_ENTER_FishingNetsDraw_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_FishingNetsDraw_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_ThrowingFishingNet_Debuff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_LEAVE_ThrowingFishingNet_Debuff(self, buff, arg1, arg2, over)

end


function SCR_BUFF_ENTER_FireFoxShikigami_Buff(self, buff, arg1, arg2, over)
	local skillPsychicPressure = GetSkill(self, "Psychokino_PsychicPressure")
	if skillPsychicPressure ~= nil then
		skillPsychicPressure.Attribute = "Fire"
	end
end

function SCR_BUFF_UPDATE_FireFoxShikigami_Buff(self, buff, arg1, arg2, over)
	local fireFoxList, fireFoxCnt = GetFollowerList(self)
	for i = 1, fireFoxCnt do
		if fireFoxList[i].ClassName == "pcskill_FireFoxShikigami" then
			if fireFoxList[i] == nil then
				return 0;
			end
		end
	end
	
	return 1;
end

function SCR_BUFF_LEAVE_FireFoxShikigami_Buff(self, buff, arg1, arg2, over)
	local skillPsychicPressure = GetSkill(self, "Psychokino_PsychicPressure")
	if skillPsychicPressure ~= nil then
		skillPsychicPressure.Attribute = "Soul"
	end
end

function SCR_BUFF_ENTER_VitalProtection_Leave_Buff(self, buff, arg1, arg2, over)
    RemoveBuff(self, "VitalProtection_Buff");
    self.MaxDefenced_BM = self.MaxDefenced_BM + 1;
end

function SCR_BUFF_LEAVE_VitalProtection_Leave_Buff(self, buff, arg1, arg2, over)
    self.MaxDefenced_BM = self.MaxDefenced_BM - 1;
end

function SCR_BUFF_ENTER_Sumazinti_Debuff(self, buff, arg1, arg2, over)
    local addMdefRate = 0.15;
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - addMdefRate;
    SetExProp(buff, "SUMAZINTI_REDUCE_MDEF", addMdefRate);
end

function SCR_BUFF_LEAVE_Sumazinti_Debuff(self, buff, arg1, arg2, over)
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + GetExProp(buff, "SUMAZINTI_REDUCE_MDEF");
end

function SCR_BUFF_ENTER_Tiksline_Debuff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_Tiksline_Debuff(self, buff, arg1, arg2, over)
    local buffCaster = GetBuffCaster(buff);
    local damage = GetExProp(buff, "Tiksline_accumulatedDamage");
    if buffCaster ~= nil then
        if damage > 1 then
            TakeDamage(buffCaster, self, "Velcoffer_Tiksline", damage, "Melee", "Magic", "AbsoluteDamage")
        end
    end
    SetExProp(buff, "Tiksline_accumulatedDamage", 0);
end

function SCR_BUFF_ENTER_Mergaite_Buff(self, buff, arg1, arg2, over)
    local addDefRate = 0;
    local itemStack = GetPrefixSetItemStack(self, "Set_Mergaite");
    if itemStack ~= nil then
        if itemStack == 4 then
            addDefRate = 0.4;
        elseif itemStack == 5 then
            addDefRate = 1;
        end
    end
    
    self.MDEF_RATE_BM = self.MDEF_RATE_BM + addDefRate;
    self.DEF_RATE_BM = self.DEF_RATE_BM + addDefRate;
    SetExProp(buff, "MERGAITE_ADDDEF_RATE", addDefRate);
end

function SCR_BUFF_LEAVE_Mergaite_Buff(self, buff, arg1, arg2, over)
    local addDefRate =  GetExProp(buff, "MERGAITE_ADDDEF_RATE");
    self.MDEF_RATE_BM = self.MDEF_RATE_BM - addDefRate;
    self.DEF_RATE_BM = self.DEF_RATE_BM - addDefRate;
end

function SCR_BUFF_ENTER_Kraujas_Buff(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_Kraujas_Buff(self, buff, arg1, arg2, over)

end

function SCR_BUFF_ENTER_Gyvenimas_Buff(self, buff, arg1, arg2, over)
    local shieldOwner = GetBuffCaster(buff)
    if shieldOwner == nil then
        return
    end

    local shieldOwnerMHP = TryGetProp(shieldOwner, "MHP")
    local shieldValue = shieldOwnerMHP * 0.5
    
    SetBuffArgs(buff, shieldValue)
    AddShield(self, shieldValue)
end

function SCR_BUFF_UPDATE_Gyvenimas_Buff(self, buff, arg1, arg2, RemainTime, ret, over)
    local shiedlValue = GetBuffArgs(buff);
    local currentShield = GetShield(self);
    if currentShield == 0 then
        return 0;
    end
    
    local updateShiedlValue = shiedlValue * 0.05;
    if (currentShield + updateShiedlValue) <= (shiedlValue/2) then
        AddShield(self, updateShiedlValue);
    end
    
    return 1
end

function SCR_BUFF_LEAVE_Gyvenimas_Buff(self, buff, arg1, arg2, over)
    local currentShield = GetShield(self)
    AddShield(self, -currentShield)
end

function SCR_BUFF_ENTER_Mergaite_Enter_Buff(self, buff, arg1, arg2, over)
    self.MaxDefenced_BM = self.MaxDefenced_BM + 1;
end

function SCR_BUFF_LEAVE_Mergaite_Enter_Buff(self, buff, arg1, arg2, over)
    self.MaxDefenced_BM = self.MaxDefenced_BM - 1;
end
