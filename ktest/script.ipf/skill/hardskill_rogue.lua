---- hardskill_rogue.lua

function SKL_ROGUE_CAPTURE_PAD(self, skl, x, y, z, range, relationBit, eftName, eftScale)

    local abil = GetAbility(self, "Rogue19")
    if abil ~= nil then 
        relationBit = 3
    end

	local list = SelectPad(self, "ALL", x, y, z, range, "ALL", relationBit);
	if #list == 0 then
		return;
	end

	CapturePad(self, eftName, eftScale, list, skl.Level);

end

function SKL_ROGUE_PUT_CAPTURE_PAD(self, skl, x, y, z)
	PutCapturedPad(self, x, y, z);
end

function SKL_CHECK_CAPTURE_PAD_COUNT(self, skl)
	local cnt = GetCapturePadCount(self);
	if cnt > 0 then
		return 1;
	else
		return 0;
	end
end

function SCR_BUFF_ENTER_Burrow_Rogue(self, buff, arg1, arg2, over)

	local caster = GetBuffCaster(buff);
	local BurrowSklLv = GetSkill(caster, 'Rogue_Burrow');
	if BurrowSklLv ~= nil then
		SetBuffArgs(buff, BurrowSklLv.Level, 0, 0);
	end

	SetShadowRender(self, 0);

	if IS_PC(self) == true then
		AddLimitationSkillList(self, "Rogue_Burrow");
		AddLimitationSkillList(self, "Bow_Attack");
		AddLimitationSkillList(self, "CrossBow_Attack");
		AddLimitationSkillList(self, "Archer_Multishot");
		AddLimitationSkillList(self, "Archer_ObliqueShot");
		AddLimitationSkillList(self, "Archer_HeavyShot");
		AddLimitationSkillList(self, "Archer_TwinArrows")
		AddLimitationSkillList(self, "Ranger_Barrage")
		AddLimitationSkillList(self, "Ranger_CriticalShot")
		AddLimitationSkillList(self, "Ranger_BounceShot")
		AddLimitationSkillList(self, "Ranger_SpiralArrow")
		AddLimitationSkillList(self, "QuarrelShooter_ScatterCaltrop")
		AddLimitationSkillList(self, "QuarrelShooter_StoneShot")
		AddLimitationSkillList(self, "Wugushi_NeedleBlow")
		AddLimitationSkillList(self, "Wugushi_WugongGu")
		AddLimitationSkillList(self, "Scout_FluFlu")
		AddLimitationSkillList(self, "Scout_FlareShot")
		AddLimitationSkillList(self, "Scout_SplitArrow")
		AddLimitationSkillList(self, "DoubleGun_Attack")
		AddIgnoreSkillCoolTime(self, 'Rogue_Burrow');
			
	    self.Jumpable = self.Jumpable - 1;
	end
end

function SCR_BUFF_LEAVE_Burrow_Rogue(self, buff, arg1, arg2, over)
    
	SetShadowRender(self, 1);
	
	if IS_PC(self) == true then
		ClearLimitationSkillList(self);
		ClearIgnoreSkillCoolTime(self);
	    self.Jumpable = self.Jumpable + 1;

		local abil = GetAbility(self, "Rogue8")
		if abil ~= nil then
			local objList, objCount = SelectObjectNear(self, self, 30, 'ENEMY');
			for i = 1, objCount do
				local obj = objList[i];
				TakeDamage(self, obj, "None", self.MINPATK, "Melee", "Strike", "Melee", HIT_BASIC, HITRESULT_BLOW);
			end
		end
	end
	
	
end
