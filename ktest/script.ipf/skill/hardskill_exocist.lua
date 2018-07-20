function SCR_EXOSICT_ENTITY(self, skl, isDamage, applyTime)
    if isDamage == nil then
        isDamage = 1;
    end
    
    if applyTime == nil then
        applyTime = 3000;
    end
    
    local targetlist = GetHardSkillTargetList(self)
    local damageTarget = {};
    local abilExorcist5 = GetAbility(self, "Exorcist5");
    for i = 1 , #targetlist do
        local target = targetlist[i]
        if applyTime ~= 0 then
            if IsBuffApplied(target, "UC_Detected_Debuff") ~= 'YES' then
                AddBuff(self, target, 'UC_Detected_Debuff',1,1,10000)
            end
        end
        
        if IsBuffApplied(target, "Cloaking_Buff") == "YES" or IsBuffApplied(target, "Burrow_Rogue") == 'YES' then
            RemoveBuff(target, "Cloaking_Buff")
            RemoveBuff(target, "Burrow_Rogue")
            damageTarget[#damageTarget + 1] = target;
        elseif abilExorcist5 ~= nil and TryGetProp(abilExorcist5, "ActiveState") == 1 then
            local abilExorcist5Lv = TryGetProp(abilExorcist5, "Level");
            damageTarget[#damageTarget + 1] = target;
            SetExProp(target, "AbilExorcist5Lv", abilExorcist5Lv);
        end
    end
    
    for j = 1, #damageTarget do
        local target = damageTarget[j]
        local damage = GET_SKL_DAMAGE(self, target, skl.ClassName)
        TakeDamage(self, target, skl.ClassName, damage);
    end
end

function PAD_SEARCH_AND_CHANGE_TARGET(self, skl, padName, changePad, x, y, z, padCount, range)
	local targetList = GetHardSkillTargetList(self)
	local list = SelectPad(self, 'ALL', x, y, z, range);
	if #list == 0 then
		return;
	end

	local padKillCount = 0;
    for i = 1 , #list do
		local pad = list[i];
		if GetPadName(pad) == padName then
			KillPad(pad); 
		    padKillCount = padKillCount + 1
		end
	end
    
    if padCount >= #targetList then
        padCount = #targetList
    end
    
    if padKillCount >= 1 then
        for j = 1, padCount do
    		local skill = nil;
    		if changePad == "Chaplain_MagnusExorcismus" then
    		    skill = GetSkill(self,"Chaplain_MagnusExorcismus");
    		end
    		local x1, y1, z1 = GetPos(targetList[j])
    		RunPad(self, changePad, skill, x1,y1,z1, 0, 1);
        end
    end
end

-- inequalitySign : 0[미만], 1[이하], 2[같음], 3[이상], 4[초과]
function SCR_EXOSICT_KOINONIA_IS_ENABLE(self, skl, range, job, targetCount, inequalitySign, isIncludeNeutral)
	
--	local myJob = GetJobObject(self);
--	if myJob == nil or myJob.CtrlType ~= "Cleric" then
--		SendSysMsg(self, 'ThisSkillIsNotAvailable');
--		return;
--	end

	-- 자신 포함
	local targetObjCount = 1;

	local objList, objCount = SelectObjectNear(self, self, range, "FRIEND");
	for i = 1, objCount do
		if IsZombie(objList[i]) ~= 1 then
--			local targetJob = GetJobObject(objList[i]);
--			if targetJob ~= nil and targetJob.CtrlType == job then
				targetObjCount = targetObjCount + 1;
--			end
		end
	end
	
	if isIncludeNeutral == 1 then
		objList, objCount = SelectObjectNear(self, self, range, "NEUTRAL");
		for i = 1, objCount do
			if IsZombie(objList[i]) ~= 1 then
				local targetJob = GetJobObject(objList[i]);
				if targetJob ~= nil and targetJob.CtrlType == job then
					targetObjCount = targetObjCount + 1;
				end
			end
		end
	end
	
	SetExProp(self, "IsIncludeNeutral", isIncludeNeutral);
    
	local isValie = false;
	if inequalitySign == "0" then
		if targetObjCount < targetCount then
			return 1;
		end
	elseif inequalitySign == "1" then
		if targetObjCount <= targetCount then
			return 1;
		end
	elseif inequalitySign == "2" then
		if targetObjCount == targetCount then
			return 1;
		end
	elseif inequalitySign == "3" then
		if targetObjCount >= targetCount then
			return 1;
		end
	elseif inequalitySign == "4" then
		if targetObjCount > targetCount then
			return 1;
		end
	end
	
    SendSysMsg(self, 'ThisSkillIsNotAvailable');
	return 0;
end

function SCR_EXOSICT_KOINONIA_MAKE_LINK(self, skl, buffName, duration, linkEffectName, linkEffectScale, linkSoundName, linkHandleList)
	
	for i = 1, #linkHandleList do
		local obj = GetByHandle(self, linkHandleList[i]);
		
		RemoveLinkByBuffName(obj, buffName);
	end
	
    local cmd = CreateLink(self, "Koinonia", buffName, duration / 1000, 0, 1, skl.Level);
	
	for i = 1, #linkHandleList do
		local obj = GetByHandle(self, linkHandleList[i]);

		AddLinkObject(cmd, obj, #linkHandleList + 1);
	end
	
	StartLink(cmd, 0.25, "Koinonia", linkEffectScale, linkSoundName);
end

function SCR_EXOSICT_KOINONIA_RUN(self, skl, duration, updateTime, linkTargetCount, limitRange, attackTargetCount, linkEffectName, linkEffectScale, linkSoundName)
	
	if self == nil or skl == nil then
		return;
	end
	
	local isIncludeNeutral = GetExProp(self, "IsIncludeNeutral");

	local linkHandleList = {};
    local targetList = {};
    
	linkHandleList[#linkHandleList + 1] = GetHandle(self);
    targetList[#targetList + 1] = self;
    
	local objList, objCount = SelectObjectNear(self, self, limitRange, "FRIEND");
	for i = 1, objCount do
		if IsZombie(objList[i]) ~= 1 then
			linkHandleList[#linkHandleList + 1] = GetHandle(objList[i]);
			targetList[#targetList + 1] = objList[i];
		end

		if #linkHandleList >= linkTargetCount then
			break;
		end
	end
    
	if isIncludeNeutral == 1 and #linkHandleList < linkTargetCount then
		objList, objCount = SelectObjectNear(self, self, limitRange, "NEUTRAL");
		for i = 1, objCount do
			if IsZombie(objList[i]) ~= 1 then
				local targetJob = GetJobObject(objList[i]);
				if targetJob ~= nil and targetJob.CtrlType == "Cleric" then
					linkHandleList[#linkHandleList + 1] = GetHandle(objList[i]);
					targetList[#targetList + 1] = objList[i];
				end
			end

			if #linkHandleList >= linkTargetCount then
				break;
			end
		end
	end
    
	if #linkHandleList <= 0 then
		return;
	end
	
	SetExProp(self, "Exocist_Koinonia_LinkHandleCount", #linkHandleList);
    local clericCount = 0;
	for j = 1, #linkHandleList do
	    local target = GetJobObject(targetList[j]);
	    local targetJob = target.CtrlType;	    
	    if targetJob == "Cleric" then
	        clericCount = clericCount + 1;
	    end
		SetExProp(self, "Exocist_Koinonia_LinkHandle" .. tostring(j), linkHandleList[j]);
	end
	
    if clericCount >= 3 then
        SetExProp(self, "Koinonia_Condition_Satisfied", 1);
    end
    
	SCR_EXOSICT_KOINONIA_MAKE_LINK(self, skl, "Koinonia_Buff", duration, linkEffectName, linkEffectScale, linkSoundName, linkHandleList);
	
	StopRunScript(self, "SCR_EXOSICT_KOINONIA_DO_DAMAGE");
	RunScript("SCR_EXOSICT_KOINONIA_DO_DAMAGE", self, skl, updateTime, limitRange, attackTargetCount);
end

function SCR_EXOSICT_KOINONIA_IS_VALID_STATE(self, linkHandleList, limitRange)
	local linkCount = #linkHandleList;
	for i = 1, linkCount do
		local obj = GetByHandle(self, linkHandleList[i]);
		if IsZombie(obj) == 1 then
			return false;
		end
	end

	for i = 1, linkCount do
		for j = i + 1, linkCount do
			if i ~= j then
				local obj1 = GetByHandle(self, linkHandleList[i]);
				local obj2 = GetByHandle(self, linkHandleList[j]);

				local dist = GetDistance(obj1, obj2);
				if dist >= limitRange then
					return false;
				end
			end
		end
	end

	return true;
end

function SCR_EXOSICT_KOINONIA_DO_DAMAGE(self, skl, updateTime, limitRange, limitEnemyCount)
    sleep(1000)
	local skillName = skl.ClassName;

	local haventSkillPCList = {};
	local linkHandleList = {};
	local linkHandleCount = GetExProp(self, "Exocist_Koinonia_LinkHandleCount");

	for i = 1, linkHandleCount do
		local handle = GetExProp(self, "Exocist_Koinonia_LinkHandle" .. tostring(i));
		local obj = GetByHandle(self, handle);
		if obj ~= nil then
			linkHandleList[#linkHandleList + 1] = handle;

			local hasSkill = GetSkill(obj, skillName);
			if hasSkill == nil then
				AddInstSkill(obj, skillName);
				haventSkillPCList[#haventSkillPCList + 1] = handle;
			end
		end
	end

    while 1 do
		local cmd = GetLinkCmdByBuffName(self, "Koinonia_Buff");
		if cmd == nil then
			break;
		end

		if SCR_EXOSICT_KOINONIA_IS_VALID_STATE(self, linkHandleList, limitRange) == false then
			RemoveLink(cmd);
			break;
		end
		
		local posX = 0;
		local posY = 0;
		local posZ = 0;
		
		local pointList = math.CreatePointList();

		local linkCount = #linkHandleList;
		for i = 1, linkCount do
			local obj = GetByHandle(self, linkHandleList[i]);
			if obj ~= nil then
				local x, y, z = GetPos(obj);

				posX = posX + x;
				posY = posY + y;
				posZ = posZ + z;
			
				pointList:AddPoint(x, z);
			end
		end

		if pointList:GetPointCount() < 3 then
			break;
		end

		pointList:SortCCW();

		posX = posX / linkCount;
		posY = posY / linkCount;
		posZ = posZ / linkCount;

		local attackCount = 0;

		-- 마지막 인자가 1이면 타겟 리스트 셔플
		local enemyList, enemyCount = SelectObjectPos(self, posX, posY, posZ, 600, "ENEMY", 0, 1);
		for i = 1, enemyCount do
			local enemy = enemyList[i];
			local x, y, z = GetPos(enemy);

			if pointList:IsContains(x, z) == true then
				attackCount = attackCount + 1;
			    local damage = GET_SKL_DAMAGE(self, enemy, 'Exorcist_Koinonia');
                TakeDamage(self, enemy, skl.ClassName, damage, skl.Attribute, skl.AttackType, skl.ClassType)
				if attackCount > limitEnemyCount then
					break;
				end
			end
		end

		math.DesctroyPointList(pointList);

		sleep(updateTime);
	end

	for i = 1, #haventSkillPCList do
		local obj = GetByHandle(self, haventSkillPCList[i]);
		if obj ~= nil then
			RemoveInstSkill(obj, skillName);
		end	
	end
	
	DelExProp(self, "Koinonia_Condition_Satisfied")
	RemoveLinkByBuffName(self, "Koinonia_Buff");
end
