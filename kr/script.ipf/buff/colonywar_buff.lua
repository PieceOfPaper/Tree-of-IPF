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
        AddBuff(caster, self, 'Safe', 0, 0, 0, 1);
    end
    SetDiminishingImmune(self)
end


function SCR_BUFF_UPDATE_GuildColony_InvincibleBuff(self, buff, arg1, arg2, RemainTime, ret, over)
    local location_check = IsJoinColonyWarMap(self)
    if location_check == 0 then --내 위치가 콜로니전 진행 지역이 아니라면,
	    if IsBuffApplied(self, 'Safe') == "YES" then
	        RemoveBuff(self, 'Safe')
	    end
        return 0
    else    
        local caster = GetBuffCaster(buff)
        if caster == nil then
    	    if IsBuffApplied(self, 'Safe') == "YES" then
    	        RemoveBuff(self, 'Safe')
    	    end
    	    return 0
    	else
            if IsBuffApplied(self, 'Safe') == "NO" then
                AddBuff(caster, self, 'Safe', 0, 0, 0, 1);
            end
       	    return 1
        end
    end
end


function SCR_BUFF_LEAVE_GuildColony_InvincibleBuff(self, buff, arg1, arg2, over)
    if IsBuffApplied(self, 'Safe') == "YES" then
        RemoveBuff(self, 'Safe')
    end
    SetDiminishingDeimmune(self)
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
	local buff_name = 'GuildColony_InvincibleBuff'
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
