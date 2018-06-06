-- GuildColony_OccupationBuff
function SCR_BUFF_ENTER_GuildColony_OccupationBuff(self, buff, arg1, arg2, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return
    else
        local two_OverTime = 300
        local three_OverTime = 600
        SetExProp(buff, "ADD_TWOOVERTIME", two_OverTime);
        SetExProp(buff, "ADD_THREEOVERTIME", three_OverTime);
        local caster = GetBuffCaster(buff);
        if caster ~= nil then
            local zoneClsName = GetZoneName(caster)
            SetExProp_Str(buff, "OCCUPATION_BUFF_APPLY_ZONE", zoneClsName);
            if over == 1 then --버프 중첩이 1회라면,
                SendAddOnMsg(self, 'NOTICE_Dm_GuildColony', ScpArgMsg("GUILD_COLONY_MSG_OCCUPATION_BUFF_1{over}{buff}", "over", over, "buff", buff.Name), 15)
            elseif over == 2 then --버프 중첩이 2회 이상이라면,
                SendAddOnMsg(self, 'NOTICE_Dm_GuildColony', ScpArgMsg("GUILD_COLONY_MSG_OCCUPATION_BUFF_2{over}{buff}", "over", over, "buff", buff.Name), 15)
            else
                SendAddOnMsg(self, 'NOTICE_Dm_GuildColony', ScpArgMsg("GUILD_COLONY_MSG_OCCUPATION_BUFF_2{over}{buff}", "over", over, "buff", buff.Name), 15)        
            end

        end

    end
end


function SCR_BUFF_UPDATE_GuildColony_OccupationBuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return 0
    else
        local zoneClsName = GetZoneName(self)
        local occupationGuild = GetColonyOccupationGuild(zoneClsName)
        if occupationGuild == nil or occupationGuild == "None" then --해당 지역의 점령길드가 없다면,
            return 0
        else
            local guildObj = GetGuildObj(self)
            if IsSameObject(occupationGuild, guildObj) == 0 then --해당 지역의 점령길드가 내 길드가 아니라면,
                return 0
            else
                local buffApplyZone = GetExProp_Str(buff, "OCCUPATION_BUFF_APPLY_ZONE");
                if buffApplyZone ~= zoneClsName then --버프 받은 지역이 현재 지역이 아니라면,
                    return 0
                else
                    local two_OverTime = GetExProp(buff, "ADD_TWOOVERTIME");
                    local three_OverTime = GetExProp(buff, "ADD_THREEOVERTIME");
                    local diff = GetColonyOccupationTimeDiff(zoneClsName)
                    if over == 1 then --버프 중첩이 1회라면,
                        if two_OverTime <= diff then --현재 시간이 점령한지 5분이 지난 시간이라면,
                            AddBuff(self, self, 'GuildColony_OccupationBuff', 1, 0, 0, 1)
                            PlayEffect(self, 'F_cleric_dodola_line', 0.8, 'BOT')
                            PlayEffect(self, 'F_lineup020_blue_mint', 0.6, 'BOT')
                        end
                    elseif over == 2 then --버프 중첩이 2회라면,
                        if three_OverTime <= diff then --현재 시간이 점령한지 10분이 지난 시간이라면,
                            AddBuff(self, self, 'GuildColony_OccupationBuff', 1, 0, 0, 1)
                            PlayEffect(self, 'F_cleric_dodola_line', 0.8, 'BOT')
                            PlayEffect(self, 'F_lineup020_blue_mint', 0.6, 'BOT')
                        end
                    end
                    return 1
                end
            end
        end
    end
end


function SCR_BUFF_LEAVE_GuildColony_OccupationBuff(self, buff, arg1, arg2, over)

end


-- GuildColony_BossMonsterBuff_DEF
function SCR_BUFF_ENTER_GuildColony_BossMonsterBuff_DEF(self, buff, arg1, arg2, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return
    else
        PlayEffect(self, 'F_levitation005_ice', 1.5, 'BOT')
        PlayEffect(self, 'F_buff_basic027_navy_line', 0.8, 'BOT')
    end
end


function SCR_BUFF_UPDATE_GuildColony_BossMonsterBuff_DEF(self, buff, arg1, arg2, RemainTime, ret, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return 0
    else
        local zoneClsName = GetZoneName(self)
        local bossKillGuild = GetColonyWarBossKillGuild(zoneClsName)
        local guildObj = GetGuildObj(self)
        if IsSameObject(bossKillGuild, guildObj) == 0 then --해당 지역의 보스몬스터를 죽인 길드가 내 길드가 아니라면,
            return 0
        else
            if IsBuffApplied(self, 'GuildColony_OccupationBuff') == 'YES' then --pc가 점령버프를 가지고 있다면,
                return 0
            else
                return 1
            end
        end
    end
end


function SCR_BUFF_LEAVE_GuildColony_BossMonsterBuff_DEF(self, buff, arg1, arg2, over)

end


-- GuildColony_enter_invincible_buff
function SCR_BUFF_ENTER_GuildColony_InvincibleBuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff)
    if caster ~= nil then
        if IsBuffApplied(self, 'GuildColony_InvincibleDeBuff') == 'NO' then
            local x, y, z = GetPos(self)
            SetExProp_Pos(self, "COLONY_ENTER_POS", x, y, z)
            AddBuff(caster, self, 'Safe', 0, 0, 0, 1);
            SetSafe(self, 1)
            SetDiminishingImmune(self)
            EnableIgnoreOBB(self, 1)
        end
    end
end


function SCR_BUFF_UPDATE_GuildColony_InvincibleBuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return 0
    else
        local pos_x, pos_y, pos_z = GetExProp_Pos(self, "COLONY_ENTER_POS")
        local x, y, z = GetPos(self)
        local dist = SCR_POINT_DISTANCE(x, z, pos_x, pos_z)
        if dist ~= 0 or
            IsJumping(self) == 1 or
            IsUsingNormalSkill(self) == 1 or
            IsUsingSkill(self) == 1 or
            IsChasingSkill(self) == 1 or
            GetUseSkillStartTime(self) / 1000 + 1 > imcTime.GetAppTime() then
            return 0
        else
            return 1
        end
    end
end


function SCR_BUFF_LEAVE_GuildColony_InvincibleBuff(self, buff, arg1, arg2, over)
    RemoveBuff(self, 'Safe')
    SetSafe(self, 0)
    SetDiminishingDeimmune(self)
    EnableIgnoreOBB(self, 0)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 1 then --내 위치가 콜로니전 진행 지역이라면,
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            if IsBuffApplied(self, 'GuildColony_InvincibleDeBuff') == 'NO' then
                AddBuff(caster, self, 'GuildColony_InvincibleDeBuff', 1, 0, 0, 1);
            end
        end
    end
end


-- GuildColony_enter_invincible_Debuff
function SCR_BUFF_ENTER_GuildColony_InvincibleDeBuff(self, buff, arg1, arg2, over)
    if IsBuffApplied(self, 'GuildColony_InvincibleBuff') == 'NO' then
        local safeRemainTime = 5
        SetExProp(buff, "SAFE_REMAIN_TIME", safeRemainTime);
        AddBuff(self, self, 'Safe', 1, 0, 5000, 1);
        SetInvincibleSec(self, 5);
        SetDiminishingImmune(self)
        EnableIgnoreOBB(self, 1)
    end
end


function SCR_BUFF_UPDATE_GuildColony_InvincibleDeBuff(self, buff, arg1, arg2, RemainTime, ret, over)

    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return 0
    else
        local safeRemainTime = GetExProp(buff, "SAFE_REMAIN_TIME")
        if safeRemainTime <= 5 and safeRemainTime > 1 then
            safeRemainTime = safeRemainTime - 1
            SetExProp(buff, "SAFE_REMAIN_TIME", safeRemainTime);
        elseif safeRemainTime <= 1 then
            safeRemainTime = 1000
            SetExProp(buff, "SAFE_REMAIN_TIME", safeRemainTime);
            SetDiminishingDeimmune(self)
            EnableIgnoreOBB(self, 0)
        end
        return 1
    end
end


function SCR_BUFF_LEAVE_GuildColony_InvincibleDeBuff(self, buff, arg1, arg2, over)
    RemoveBuff(self, 'Safe')
    SetSafe(self, 0)
    SetDiminishingDeimmune(self)
    EnableIgnoreOBB(self, 0)
end


function SCR_BUFF_ADDCHECKON_GuildColony_InvincibleBuff(self, buff, targetBuffName, from)
    if from == nil then 
        return 1;
    end
    
    if GetObjType(self) ~= OT_PC then
        return 1;
    end

    if GetHandle(self) == GetHandle(from) then
        return 1;
    end

    local targetBuffCls = GetClass("Buff", targetBuffName);
    if targetBuffCls == nil then
        return 1;
    end

    if targetBuffCls.Group1 == "Debuff" then
        return 0;
    end

    return 1;
end


function SCR_BUFF_RATETABLE_GuildColony_OccupationBuff(self, from, skill, atk, ret, rateTable, buff)
	local buff_name = 'GuildColony_OccupationBuff'
	if IsBuffApplied(self, buff_name) == "YES" then
        local over = GetBuffOver(self, buff_name)
        local reductionRate = 0.2
        if over == 2 then
            reductionRate = 0.25
        elseif over == 3 then
            reductionRate = 0.3
        end
		AddDamageReductionRate(rateTable, reductionRate)
	end
end


function SCR_BUFF_RATETABLE_GuildColony_BossMonsterBuff_DEF(self, from, skill, atk, ret, rateTable, buff)
	local buff_name = 'GuildColony_BossMonsterBuff_DEF'
	if IsBuffApplied(self, buff_name) == "YES" then
        local reductionRate = 0.3
		AddDamageReductionRate(rateTable, reductionRate)
	end
end

-- GuildColony_EnhancerDestroyBuff_1
function SCR_BUFF_ENTER_GuildColony_EnhancerDestroyBuff_1(self, buff, arg1, arg2, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return
    else
        local caster = GetBuffCaster(buff);
        if caster ~= nil then
            local zoneClsName = GetZoneName(caster)
            local occupationGuild = GetColonyOccupationGuild(zoneClsName)
            if occupationGuild == nil then
                SetExProp_Str(buff, "OCCUPATION_GUILD", "Not_Yet")
            else
                SetExProp_Str(buff, "OCCUPATION_GUILD", GetIESID(occupationGuild))
            end
            SetExProp_Str(buff, "ENHANCER_DESTROY_BUFF_APPLY_ZONE", zoneClsName);
        end
    end
end


function SCR_BUFF_UPDATE_GuildColony_EnhancerDestroyBuff_1(self, buff, arg1, arg2, RemainTime, ret, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return 0
    else
        local zoneClsName = GetZoneName(self)
        local buffApplyZone = GetExProp_Str(buff, "ENHANCER_DESTROY_BUFF_APPLY_ZONE");
        if buffApplyZone ~= zoneClsName then --버프 받은 지역이 현재 지역이 아니라면,
            return 0
        else
            local occupationGuildID = GetExProp_Str(buff, "OCCUPATION_GUILD");
            local nowOccupationGuild = GetColonyOccupationGuild(zoneClsName)
            local nowOccupationGuildID
            if nowOccupationGuild == nil then
                nowOccupationGuildID = "Not_Yet"
            else
                nowOccupationGuildID = GetIESID(nowOccupationGuild)
            end
            if occupationGuildID ~= nowOccupationGuildID then
                return 0
            else
                if IsBuffApplied(self, 'GuildColony_OccupationBuff') == 'YES' then --pc가 점령버프를 가지고 있다면,
                    return 0
                else
                    local list, cnt = GetEnhancerDestroyGuildList(zoneClsName)
            	    local over = 0
            	    for i = 1, cnt do
            	        if IsSameObject(list[i], GetGuildObj(self)) == 1 then
            	            over = over + 1
            	        end
            	    end
            	    if over < 1 then
                        return 0
                    else
                        return 1
                    end
                end
            end
        end
    end
end


function SCR_BUFF_LEAVE_GuildColony_EnhancerDestroyBuff_1(self, buff, arg1, arg2, over)
    DetachEffect(self, "F_buff_basic050_circle_loop")
end


-- GuildColony_EnhancerDestroyBuff_2
function SCR_BUFF_ENTER_GuildColony_EnhancerDestroyBuff_2(self, buff, arg1, arg2, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return
    else
        local caster = GetBuffCaster(buff);
        if caster ~= nil then
            local zoneClsName = GetZoneName(caster)
            local occupationGuild = GetColonyOccupationGuild(zoneClsName)
            if occupationGuild == nil then
                SetExProp_Str(buff, "OCCUPATION_GUILD", "Not_Yet")
            else
                SetExProp_Str(buff, "OCCUPATION_GUILD", GetIESID(occupationGuild))
            end
            SetExProp_Str(buff, "ENHANCER_DESTROY_BUFF_APPLY_ZONE", zoneClsName);
            
            local mspdadd = 5

            self.MSPD_BM = self.MSPD_BM + mspdadd;
            SetExProp(buff, "ADD_MSPD", mspdadd);
        end
    end
end


function SCR_BUFF_UPDATE_GuildColony_EnhancerDestroyBuff_2(self, buff, arg1, arg2, RemainTime, ret, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return 0
    else
        local zoneClsName = GetZoneName(self)
        local buffApplyZone = GetExProp_Str(buff, "ENHANCER_DESTROY_BUFF_APPLY_ZONE");
        if buffApplyZone ~= zoneClsName then --버프 받은 지역이 현재 지역이 아니라면,
            return 0
        else
            local occupationGuildID = GetExProp_Str(buff, "OCCUPATION_GUILD");
            local nowOccupationGuild = GetColonyOccupationGuild(zoneClsName)
            local nowOccupationGuildID
            if nowOccupationGuild == nil then
                nowOccupationGuildID = "Not_Yet"
            else
                nowOccupationGuildID = GetIESID(nowOccupationGuild)
            end
            if occupationGuildID ~= nowOccupationGuildID then
                return 0
            else
                if IsBuffApplied(self, 'GuildColony_OccupationBuff') == 'YES' then --pc가 점령버프를 가지고 있다면,
                    return 0
                else
                    local list, cnt = GetEnhancerDestroyGuildList(zoneClsName)
            	    local over = 0
            	    for i = 1, cnt do
            	        if IsSameObject(list[i], GetGuildObj(self)) == 1 then
            	            over = over + 1
            	        end
            	    end
            	    if over < 1 then
                        return 0
                    else
                        return 1
                    end
                end
            end
        end
    end
end


function SCR_BUFF_LEAVE_GuildColony_EnhancerDestroyBuff_2(self, buff, arg1, arg2, over)
    local mspdadd = GetExProp(buff, "ADD_MSPD");
    self.MSPD_BM = self.MSPD_BM - mspdadd;
end


function SCR_BUFF_RATETABLE_GuildColony_EnhancerDestroyBuff_2(self, from, skill, atk, ret, rateTable, buff)

	local increaseRate = 0.3

	local buff_name = 'GuildColony_EnhancerDestroyBuff_2'
	if IsBuffApplied(from, buff_name) == "YES" then
        rateTable.DamageRate = rateTable.DamageRate + increaseRate;
	end

end


-- GuildColony_rootcrystal_Buff_spd
function SCR_BUFF_ENTER_GuildColony_rootcrystal_Buff_spd(self, buff, arg1, arg2, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return
    else

        local moveSpeed = 60;

        SetExProp(buff, "SET_FIXMSPD", moveSpeed);
        self.FIXMSPD_BM = self.FIXMSPD_BM + moveSpeed;
    end
end


function SCR_BUFF_UPDATE_GuildColony_rootcrystal_Buff_spd(self, buff, arg1, arg2, RemainTime, ret, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return 0
    else
        return 1
    end
end


function SCR_BUFF_LEAVE_GuildColony_rootcrystal_Buff_spd(self, buff, arg1, arg2, over)
    local fixMSPD = GetExProp(buff, "SET_FIXMSPD");
    self.FIXMSPD_BM = self.FIXMSPD_BM - fixMSPD;
end


-- GuildColony_rootcrystal_Buff_hpsp
function SCR_BUFF_ENTER_GuildColony_rootcrystal_Buff_hpsp(self, buff, arg1, arg2, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return
    else

        local healCalc1 = 0.3
        local healCalc2 = 500

        local healHp = math.floor(self.MHP * healCalc1)
        local healSp = math.floor(self.MSP * healCalc1)
        Heal(self, healHp, 0);
        HealSP(self, healSp, 0);
        SetExProp(buff, "ADD_HPSP", healCalc2);
    end
end


function SCR_BUFF_UPDATE_GuildColony_rootcrystal_Buff_hpsp(self, buff, arg1, arg2, RemainTime, ret, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return 0
    else
        local healCalc2 = GetExProp(buff, "ADD_HPSP");
        Heal(self, healCalc2, 0);
        HealSP(self, healCalc2, 0);
        return 1
    end
end


function SCR_BUFF_LEAVE_GuildColony_rootcrystal_Buff_hpsp(self, buff, arg1, arg2, over)
end


-- GuildColony_rootcrystal_Buff_atk
function SCR_BUFF_ENTER_GuildColony_rootcrystal_Buff_atk(self, buff, arg1, arg2, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return
    end
end


function SCR_BUFF_UPDATE_GuildColony_rootcrystal_Buff_atk(self, buff, arg1, arg2, RemainTime, ret, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return 0
    else
        return 1
    end
end


function SCR_BUFF_LEAVE_GuildColony_rootcrystal_Buff_atk(self, buff, arg1, arg2, over)
end


function SCR_BUFF_RATETABLE_GuildColony_rootcrystal_Buff_atk(self, from, skill, atk, ret, rateTable, buff)

	local increaseRate = 0.5

	local buff_name = 'GuildColony_rootcrystal_Buff_atk'
	if IsBuffApplied(self, buff_name) == "YES" then
	    rateTable.DamageRate = rateTable.DamageRate + increaseRate;
	end

	if IsBuffApplied(from, buff_name) == "YES" then
	    rateTable.DamageRate = rateTable.DamageRate + increaseRate;
	end
end


-- GuildColony_rootcrystal_Buff_def
function SCR_BUFF_ENTER_GuildColony_rootcrystal_Buff_def(self, buff, arg1, arg2, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return
    end
end

function SCR_BUFF_UPDATE_GuildColony_rootcrystal_Buff_def(self, buff, arg1, arg2, RemainTime, ret, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
        return 0
    else
        return 1
    end
end

function SCR_BUFF_LEAVE_GuildColony_rootcrystal_Buff_def(self, buff, arg1, arg2, over)
end

function SCR_BUFF_RATETABLE_GuildColony_rootcrystal_Buff_def(self, from, skill, atk, ret, rateTable, buff)

	local reductionRate = 0.5

	local buff_name = 'GuildColony_rootcrystal_Buff_def'
	if IsBuffApplied(self, buff_name) == "YES" then
		AddDamageReductionRate(rateTable, reductionRate)
	end
	
	if IsBuffApplied(from, buff_name) == "YES" then
	    AddDamageReductionRate(rateTable, reductionRate)
	end
end
