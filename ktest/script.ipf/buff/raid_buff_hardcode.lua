--누오다이 생성 시, 꽃가루 버프 걸어주기
function GRB_boss_nuodai_BORN_ATTRIBUTE(self)
	AddBuff(self, self, 'Pollen_Buff');
end

--누오다이 꽃가루 버프
function SCR_BUFF_ENTER_Pollen_Buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_Pollen_Buff(self, buff, arg1, arg2, over)
end

function SCR_BUFF_TAKEDMG_Pollen_Buff(self, buff, sklID, damage, attacker)

	if GetExProp(self, "Pollen_Buff_Tick") > imcTime.GetAppTime() then
		return 1;
	end

	SetExProp(self, "Pollen_Buff_Tick", imcTime.GetAppTime() + 1)

	local objList, objCount = SelectObject(self, 100, 'PC', 1);
	for i = 1, objCount do
		if objList[i].ClassName == "PC" then
			AddBuff(self, objList[i], 'Pollen_Debuff');
		end
	end
	return 1;
end


--누오다이 꽃가루 디버프
function SCR_BUFF_ENTER_Pollen_Debuff(self, buff, arg1, arg2, over)
	if over >= 50 then
		PlayEffect(self, "F_archer_explosiontrap_hit_explosion", 1, 1, 'BOT')
        
        local caster = GetBuffCaster(buff);
        local bombDamage = math.floor((caster.MINPATK + caster.MAXPATK) / IMCRandomFloat(2, 2.5)) * 5;
        local bombRange = 100;
        
	    local objList, objCount = SelectObjectNear(caster, self, bombRange, 'ENEMY', 1);
	    for i = 1, objCount do
		    local obj = objList[i];
			TakeDamage(caster, obj, "None", bombDamage, "Melee", "None", "Melee", HIT_BASIC, HITRESULT_BLOW);
			local x, y, z = GetPos(caster)
			local angle = GetAngleFromPos(obj, x, z);
			KnockDown(obj, caster, 100, angle, 40, 1, 1, 100)

			if IsSameObject(obj, self) ~= 1 then
				if IsBuffApplied(obj, 'Pollen_Debuff') == 'YES' then
					SetExProp(obj, "Pollen_Bomb", 1)
					SetExProp(obj, "Pollen_Bomb_Delay", imcTime.GetAppTime() + 1)
				end
			end
	    end
		RemoveBuff(self, "Pollen_Debuff");
	end
end

function SCR_BUFF_UPDATE_Pollen_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)
	if GetExProp(self, "Pollen_Bomb") == 1 then
		if GetExProp(obj, "Pollen_Bomb_Delay") < imcTime.GetAppTime() then
			DelExProp(self, "Pollen_Bomb")
			PlayEffect(self, "F_archer_explosiontrap_hit_explosion", 1, 1, 'BOT')
			local caster = GetBuffCaster(buff);
			local bombDamage = math.floor((caster.MINPATK + caster.MAXPATK) / IMCRandomFloat(2, 2.5)) * 5;
			local bombRange = 100;
			TakeDamage(caster, self, "None", bombDamage, "Melee", "None", "Melee", HIT_BASIC, HITRESULT_BLOW);
			KnockDown(self, caster, 100, angle, 40, 1, 1, 100)
			local objList, objCount = SelectObject(self, 100, 'PC', 1);
			for i = 1, objCount do
				if objList[i].ClassName == "PC" then
					TakeDamage(caster, objList[i], "None", bombDamage, "Melee", "None", "Melee", HIT_BASIC, HITRESULT_BLOW);
					local x, y, z = GetPos(caster)
					local angle = GetAngleFromPos(objList[i], x, z);
					KnockDown(objList[i], caster, 100, angle, 40, 1, 1, 100)
					

					if IsSameObject(objList[i], self) ~= 1 then
						if IsBuffApplied(objList[i], 'Pollen_Debuff') == 'YES' then
							SetExProp(objList[i], "Pollen_Bomb", 1)
							SetExProp(objList[i], "Pollen_Bomb_Delay", imcTime.GetAppTime() + 1)
						end
					end
				end
			end
		end
		RemoveBuff(self, "Pollen_Debuff");
	end
	return 1;
end

function SCR_BUFF_LEAVE_Pollen_Debuff(self, buff, arg1, arg2, over)
end


function SCR_BUFF_GIVEDMG_Pollen_Debuff(self, buff, sklID, damage, target, ret)
	
	local buffCaster = GetBuffCaster(buff);
	
	if IsSameObject(target, buffCaster) ~= 1 then
		SubBuffOver(self, buff.ClassName, 1)
	end

	return 1;
end




function SCR_BUFF_ENTER_Nuodai_Poison_Debuff(self, buff, arg1, arg2, over)
	SetExProp(self, "Nuodai_Poison_Debuff_Damage", self.HP / 10)
end

function SCR_BUFF_UPDATE_Nuodai_Poison_Debuff(self, buff, arg1, arg2, RemainTime, ret, over)

	local caster = GetBuffCaster(buff);
	
	local damage = GetExProp(self, "Nuodai_Poison_Debuff_Damage")


	TakeDamage(caster, self, "None", damage, "Ice", "None", "TrueDamage", HIT_ICE, HITRESULT_BLOW, 0, 0);
	return 1;
end

function SCR_BUFF_LEAVE_Nuodai_Poison_Debuff(self, buff, arg1, arg2, over)
end

--BlackGargoyle 침묵 디버프
function SCR_BUFF_ENTER_Mon_raid_Silence(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_LEAVE_Mon_raid_Silence(self, buff, arg1, arg2, over)
end

--BlackGargoyle 저주 디버프
--Rejuvenation의 반대.
function SCR_BUFF_ENTER_Mon_raid_Curse(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
	
end

function SCR_BUFF_UPDATE_Mon_raid_Curse(self, buff, arg1, arg2, RemainTime, ret, over)
	if self.HP < 1000 then
		return 0;
	end

	local rate = 0.05;
	local takeHP = self.HP * rate;
	local takeSP = self.SP * rate;

	if IS_PC(self) == true then
        AddSP(self, -takeSP);
        AddHP(self, -takeHP);
    end

	return 1;		    
end
    
function SCR_BUFF_LEAVE_Mon_raid_Curse(self, buff, arg1, arg2, over)

end

function SCR_BUFF_AFTERCALC_HIT_Mon_raid_Curse(self, from, skill, atk, ret, buff)
	if skill.ClassName == "Mon_Raid_boss_blackGargoyle_Skill_4" then
		ret.Damage = ret.Damage * 2;
	end
end

--BlackGargoyle 스턴 디버프
function SCR_BUFF_ENTER_Mon_raid_stun(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
end

function SCR_BUFF_LEAVE_Mon_raid_stun(self, buff, arg1, arg2, over)
end

--BlackGargoyle 레이지 버프
function SCR_BUFF_ENTER_Mon_raid_Rage(self, buff, arg1, arg2, over)
    SkillTextEffect(nil, self, GetBuffCaster(buff), "SHOW_BUFF_TEXT", buff.ClassID, nil);
	local atk = (self.MAXPATK + self.MINPATK) / 2;
	local atkUp = atk / 2;
	SetExProp(buff, "ATK_UP", atkUp);
	self.ATK_BM = self.ATK_BM + atkUp;
end

function SCR_BUFF_LEAVE_Mon_raid_Rage(self, buff, arg1, arg2, over)
	local atkUp = GetExProp(buff, "ATK_UP");
	self.ATK_BM = self.ATK_BM - atkUp;
end

--BlackGargoyle 보호의 단 버프 RaidGimmick
function SCR_BUFF_ENTER_Mon_RaidGimmick_Buff(self, buff, arg1, arg2, over)
	local addDefenced_BM  = 1;
	SetExProp(buff, 'DEFENCED_BM', addDefenced_BM);
	self.MaxDefenced_BM = self.MaxDefenced_BM + addDefenced_BM;
end

function SCR_BUFF_LEAVE_Mon_RaidGimmick_Buff(self, buff, arg1, arg2, over)
	local addDefenced_BM = GetExProp(buff, 'DEFENCED_BM');
	self.MaxDefenced_BM = self.MaxDefenced_BM - addDefenced_BM;
end

--BlackGargoyle 무적 버프--
function SCR_BUFF_ENTER_Mon_invincible(self, buff, arg1, arg2, over)
   	local addDefenced_BM  = 1;
	SetExProp(buff, 'DEFENCED_BM', addDefenced_BM);
	self.MaxDefenced_BM = self.MaxDefenced_BM + addDefenced_BM;
end

function SCR_BUFF_LEAVE_Mon_invincible(self, buff, arg1, arg2, over)
	local addDefenced_BM = GetExProp(buff, 'DEFENCED_BM');
	self.MaxDefenced_BM = self.MaxDefenced_BM - addDefenced_BM;
end