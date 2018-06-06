---- hardskill_warlock.lua
function DARKTHUERGE_RESET(self, skill)
	local darktheurgeList = GetScpObjectList(self, 'SKL_WARLOCK_DARKTHEURGE');
	if darktheurgeList ~= nil and #darktheurgeList >= 1 then
		for i = 1, #darktheurgeList do
			Kill(darktheurgeList[i]);
		end
	end
end

function DARKTHUERGE_HOVER(mon1, self, skl, index, cnt)
	HoldMonScp(mon1);
	local startAngle = (index / cnt) * 360;

	--------------------------- modify here -------------------------
	local hoverSpeed = 3.0;
	HoverAround(mon1, self, 15, 1, hoverSpeed, 1, startAngle);
	local effectName = "F_wizard_DarkTheurge_darkball_hit";
	local range = 10;
	local destructDelay = 2.0;
    
    local isAbilWarlock18 = 0;
    local abilWarlock18 = GetAbility(self, "Warlock18")
    if abilWarlock18 ~= nil and abilWarlock18.ActiveState == 1 then
        isAbilWarlock18 = 1;
    end
    
    SetExProp(mon1, "ABIL_WARLOCK18", isAbilWarlock18);
    
    AddScpObjectList(self, 'SKL_WARLOCK_DARKTHEURGE', mon1);
	------------------------------------------------------------------

	RunScript("SELF_DESTRUCT_NEAR", mon1, skl.ClassName, range, destructDelay,effectName);

end

function RUN_SELF_DESTRUCT(self, skillName, range, effectName, destructWithoutObj)
	if GetExProp(self, "DESTRUCTED") == 1 then
		return;
	end

	if GetExProp(self, "COOLDOWN_TIME") > imcTime.GetAppTime() then
		return
	end
    
	local objList, objCount = SelectObject(self, range, 'ENEMY');
	if objCount > 0 or destructWithoutObj == 1 then
		local owner = GetOwner(self);
		if owner == nil then
			owner = self;
		end
		local skill = GetSkill(owner, skillName);
		local damage = SCR_LIB_ATKCALC_RH(owner, skill);
        
		local buff = GetBuffByName(self, "Sabbath_Fluting");
		if buff ~= nil then
			local sklSabbath = GetSkill(owner, "Warlock_Sabbath");
			if sklSabbath ~= nil then
                SetExProp(owner, "sabbathBuff", 1)
			end
		end
		
		local applyCount = 0;
		for i = 1, objCount do
			local obj = objList[i];
			if IsDead(obj) == 0 then
				TakeDadak(owner, obj, skillName, damage);

				if self.ClassName == "pcskill_Warlock_DarkTheurge_red" then
					TakeDadak(owner, obj, skillName, damage, 0.05);
				end

				applyCount = applyCount + 1;

				local damageCount = GetExProp(self, "DAMAGE_COUNT") + 1
				SetExProp(self, "DAMAGE_COUNT", damageCount)
				SetExProp(self, "COOLDOWN_TIME", imcTime.GetAppTime() + 0.1)
			end
		end

        local maxDamageCount = 1;
        if GetExProp(self, "ABIL_WARLOCK18") == 1 then
            maxDamageCount = maxDamageCount * 2;
        end

        if GetExProp(self, "DAMAGE_COUNT") >= maxDamageCount or destructWithoutObj == 1 then 
			SetExProp(self, "DESTRUCTED", 1);
			PlayEffect(self, effectName, 1.5, 1, 'BOT')
			Dead(self);
			return 1;
		end
	end

	return 0;
end

function SELF_DESTRUCT_NEAR(self, skillName, range, destructDelay, effectName)

	sleep(destructDelay * 1000);

	while 1 do
		if IsDead(self) == 1 then
			Dead(self);
			return;
		end
		local owner = GetOwner(self);
		if owner == nil then
			Dead(self);
			return;
		end
	
		if 1 == RUN_SELF_DESTRUCT(self, skillName, range, effectName, 0) then
			return;
		end
        
		sleep(10);
	end
end

function SUMMON_INVOCATION_MONSTER(self, target, sklLv, range)
	local skillName = "Warlock_Invocation";
	local x, y, z = GetPos(target);
	if range ~= nil and 0 < range then
		x, y, z = GetActorRandomPos(target, range);
	end
	------------------ modify here --------------------
    
	local mon = nil
	if target.MonRank ~= "Material" and target.MonRank ~= "MISC" and target.MonRank ~= "None" then
    	if GetObjType(self) == OT_PC then
    		local Warlock14_abil = GetAbility(self, "Warlock14")
    		if Warlock14_abil ~= nil and Warlock14_abil.Level * 100 > IMCRandom(1, 10000)then
    		    mon = CREATE_MONSTER_EX(self, 'pcskill_Warlock_DarkTheurge_red', x, y, z, GetDirectionByAngle(self), 'Neutral', 1);
    		else
    		    mon = CREATE_MONSTER_EX(self, 'pcskill_Warlock_DarkTheurge', x, y, z, GetDirectionByAngle(self), 'Neutral', 1);
    		end
    	else
    		mon = CREATE_MONSTER_EX(self, self.ClassName, x, y, z, GetDirectionByAngle(self), 'Neutral', 1);
    	end
    end
	if nil == mon then
		return;
	end
    
	SetOwner(mon, self, 1);
	
	local lifeTime = 30;
	local Warlock12_abil = GetAbility(self, "Warlock12")
	if Warlock12_abil ~= nil then
	    lifeTime = lifeTime + Warlock12_abil.Level * 5
	end
	
	SetLifeTime(mon, lifeTime)
    
	local range = 20;
	local destructDelay = 1.0;
	local effectName = "F_wizard_DarkTheurge_darkball_hit";
	if Warlock14_abil ~= nil then
	    effectName= "F_wizard_DarkTheurge_darkball_hit";
	end
	
    local skill = GetSkill(self, "Warlock_Invocation")
    if skill == nil then
        return
    end
    
	local abil = GetAbility(self, "Warlock5")
    if abil ~= nil and skill.Level >= 5 then
	    RunSimpleAI(mon, 'Invocation_DARKATK_Abil');
	end
	-------------------------------------------------
	if nil ~= sklLv then
		SetExProp(mon, 'COPY_SKLLEVEL', sklLv);
	end
    
	RunScript("SELF_DESTRUCT_NEAR", mon, skillName, range, destructDelay, effectName);
	SetDeadScript(mon, "INVOCATION_DEAD_REMOVEEFFECT");
end

function INVOCATION_DEAD_REMOVEEFFECT(mon)
	ClearEffect(mon);
end

function WARLOCK_ORDER_INVOCATION(self, skl)

	local x, y, z = GetGizmoPos(self);
	local list, cnt = SelectObjectByClassName(self, 200, 'pcskill_Warlock_DarkTheurge')
	for i = 1 , cnt do
		local obj = list[i];
		HoverAround(obj, nil, 0, 0, 0, 0);

		local dist = GetDistFromPos(obj, x, y, z);
		local speed = 50;
		local time = dist / 150;
		
		MoveToMath(obj, x, y, z, 3.0, time);
		RunScript("DARKTHEURGE_ARRIVE_AUTO_DESTRUCT", obj, time, skl.ClassName);
	end
	
	local list, cnt = SelectObjectByClassName(self, 200, 'pcskill_Warlock_DarkTheurge_red')
	for i = 1 , cnt do
		local obj = list[i];
		HoverAround(obj, nil, 0, 0, 0, 0);

		local dist = GetDistFromPos(obj, x, y, z);
		local speed = 50;
		local time = dist / 150;
		
		MoveToMath(obj, x, y, z, 3.0, time);
		RunScript("DARKTHEURGE_ARRIVE_AUTO_DESTRUCT", obj, time, skl.ClassName);
	end
	
end

function DARKTHEURGE_ARRIVE_AUTO_DESTRUCT(self, time, skillName)
	sleep(time * 1000);
	if IsDead(self) == 1 then
		return;
	end

	local range = 20;
	local effectName = "F_wizard_DarkTheurge_darkball_hit";

	RUN_SELF_DESTRUCT(self, skillName, range, effectName, 1)
end


function WARLOCK_DRAIN(self, skl)

	local x, y, z = GetGizmoPos(self);
	local list, cnt = SelectObjectByClassName(self, 50, 'pcskill_Warlock_DarkTheurge')
	
    local count = 0
    
	if cnt > 0 then
		local maxcnt = skl.Level;
		cnt = math.min(cnt, maxcnt);
		
        AddBuff(self, self, 'Drain_Buff', 1, 0, 30000, 1);
		for i = 1 , cnt do
			local obj = list[i];
			Dead(obj);
            count = count + 1
            SetExProp(self, "DARKTHEURAGE_COUNT", count)
		end
	else
		return;
	end
end

