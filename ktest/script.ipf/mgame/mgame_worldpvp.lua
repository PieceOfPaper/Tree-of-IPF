--- mgame_worldpvp.lua


function MGAME_WORLDPVP_INIT_TEAM(self)
	
	local etc = GetETCObject(self);
	local teamID = etc.Team_Mission;
	SET_MGAME_TEAM(self, teamID);

end

function INIT_WORLDPVP_PCLIST(cmd)
	SendUpdateLayerPCList(cmd:GetZoneInstID(), cmd:GetLayer(), 1);
end

function FLAGGAME_APPLY_RESULT(cmd, curStage, eventInst, obj)

	cmd:ApplyScoreBySObjValue("ssn_mission", "Point");

end

function MGAME_WORLDPVP_RESULT(cmd, curStage, eventInst, obj)

	local team1_score = cmd:GetUserValue("Team1_Score");
	local team2_score = cmd:GetUserValue("Team2_Score");

	if team1_score > team2_score then
		cmd:ApplyPVPScore(1);
		WORLDPVP_SEND_RESULT_UI(cmd, 1, 30);
	else
		cmd:ApplyPVPScore(2);
		WORLDPVP_SEND_RESULT_UI(cmd, 2, 30);
	end
	

end

function MGAME_WORLDPVP_RETURNTOZONE(cmd, curStage, eventInst, obj)
	cmd:ReturnToOriginalServer();
end

function MGAME_CHECK_ALL_PC_ENTER(cmd, curStage, eventInst, obj)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	if cnt > 0 then
        if cmd:GetMGameName() == 'battlefield' then
			local round = cmd:GetUserValue('Round');
			IMC_LOG('INFO_NORMAL', '[TBL_LOG] MGAME_CHECK_ALL_PC_ENTER CheckFlag6: stage['..curStage..'], cnt['..cnt..'], round['..round..']');
		end
		cmd:SetUserValue('CHECK_FLAG6', 1);
	end

    local checkFlag = math.floor(cmd:GetUserValue('CHECK_FLAG6'));
	if checkFlag == 0 then
		return 0;
	end

	local ret = cmd:AllPVPPCEntered();
	if ret == true then
        if cmd:GetMGameName() == 'battlefield' then
			local round = cmd:GetUserValue('Round');
			IMC_LOG('INFO_NORMAL', '[TBL_LOG] MGAME_CHECK_ALL_PC_ENTER: stage['..curStage..'], cnt['..cnt..'], round['..round..']');
		end
		return 1;
	end

	return 0;

end

function WORLDPVP_ALLPC_ENTERED(cmd, curStage, eventInst, obj, funcName)
	cmd:SendALLPCEnterToWorldPVP();
end

function MLIST_ST_FULLFIL_END_CONDITION(cmd, curStage, eventInst, obj)
	cmd:RemoveAllMonster();     -- ?�이?�볼??객체 ?�거
    cmd:StopCastingAllPlayer(); -- ?�전중인 캐스?�을 멈추?�록 ?�다.
end

function PVP_RESET_BATTLE_STATE(obj)
	local list , cnt  = GetFollowerList(obj);
	for i = 1 , cnt do
		local fol = list[i];
		local cls = GetClass("Companion", fol.ClassName);
		if cls ~= nil then
			AddHP(fol, fol.MHP);
		else
			Dead(fol);
		end
	end

	RemoveAllPad(obj);
	ResetCoolDown(obj, 1);
	AddHP(obj, obj.MHP);
	AddSP(obj, obj.MSP);
	AddStamina(obj, obj.MaxSta);
	RemoveAllBuff(obj);	
	RemoveAllDeBuffList(obj);	
	-- 리�??�션?�로 ?�한 부?��? 카운?�는 ?�운?�당 ?�번~!
	SetExProp(obj, "RESURRECTION_COUNT", 1)
	SetExProp(obj, "REVIVE_COUNT", 1)
	SetExProp(obj, "VITALPROTECTION_TBL_COUNT", 0)
    SetExProp(obj, "DURAHAN_CARD_COUNT", 1)
    
    local cmd = GetMGameCmd(obj);
    if cmd ~= nil then
        cmd:ResetAllInstallSkillUserValue(tostring(GetHandle(obj)));
        cmd:SetUserValue('CHECK_FLAG', 0);
        cmd:SetUserValue('CHECK_FLAG2', 0);
        cmd:SetUserValue('CHECK_FLAG3', 0);
        cmd:SetUserValue('CHECK_FLAG4', 0);
        cmd:SetUserValue('CHECK_FLAG5', 0);
        cmd:SetUserValue('CHECK_FLAG6', 0);
    end

end

function HIDE_FROM_PVP_PLAYERS(self, target)

	if GetObjType(target) == OT_PC then
		local etc = GetETCObject(target);
		local teamID = etc.Team_Mission;
		if teamID > 0 then
			return 1;
		end
	end

	return 0;
end

function INIT_PVP_SCRIPT(self)

	if IsDummyPC(self) == 1 then
		return;
	end

	local etc = GetETCObject(self);
	local teamID = etc.Team_Mission;
	
	if teamID > 0 then
		SetDeadScript(self, "PVP_PC_DEAD");
		SetTakeDamageScp(self, "PVP_TAKE_DAMGE")
		EnableObserverWhenDead(self, 1);
	else
		SetHideCheckScript(self, "HIDE_FROM_PVP_PLAYERS");
		SetCurrentFaction(self, "Peaceful");
		EnableObserverAllTeam(self, 1);
		UIOpenToPC(self, 't_pvp_score', 0);
		EnableAction(self, 0);
		EnableItemUse(self, 0);

	end

	SendUpdateLayerPCList(self, 1);
	PVPEnterMongoLog(self);

end

function PVP_PC_DEAD(self)

	local cmd = GetMGameCmd(self);
	cmd:AddUserValue("DEATH_COUNT_" .. GetPcAIDStr(self), 1, 0);

	local killer = GetKiller(self);
	killer = GetTopOwner(killer);
	if killer == nil or GetObjType(killer) ~= OT_PC then
		return;
	end
	
	local killerIcon = GetPCIconStr(killer);
	local selfIcon = GetPCIconStr(self);
	local argString = string.format("%s#%s#%s#%s#%d", killerIcon, selfIcon, killer.Name, self.Name, GetTeamID(killer));
	RunClientScriptToWorld(killer, "WORLDPVP_UI_MSG_KILL", argString);

	cmd:AddUserValue("KILL_COUNT_" .. GetPcAIDStr(killer), 1, 0);

	PVPMongoLogo(self, "Dead", "Killer",  killer);

end

function MGAME_PC_ENALBE_CONTROL(cmd, curStage, eventInst, obj, flag)
	local list, cnt = GetCmdPCList(cmd:GetThisPointer());
	for i = 1 , cnt do
		local pc = list[i];
		SkillCancel(pc);
		RemoveAllPad(pc);
		EnableControl(pc, flag, "PVP");
	end
end

function PVP_TAKE_DAMGE(self, from, skl, damage, ret)

	local topOwner = GetTopOwner(from);
	if topOwner == nil or GetObjType(topOwner) ~= OT_PC then
		return;
	end

	local cmd = GetMGameCmd(topOwner);
	cmd:AddUserValue("DEAL_AMOUNT_" .. GetPcAIDStr(topOwner), damage, 0);
	cmd:AddUserValue("SKILL_DEAL_AMOUNT_" .. GetPcAIDStr(topOwner) .. "_" .. skl.ClassName, damage, 0);
	
	if self.HP - damage <= 0 then
		PVPMongoLogo(topOwner, "Kill", "DeadPerson",  self);
	end

end

function GET_CMD_USERVALUES(cmd, findStr)

	local findStrLen = string.len(findStr);
	local valueList = GetMGameValueList(cmd:GetThisPointer());

	local skillNames = {};
	local skillDamages = {};
	for i = 1 , #valueList do
		local valueName = valueList[i];
		local findValue = string.find(valueName, findStr);
		if findValue == 1 then
			local skillName = string.sub(valueName, findStrLen + 2, string.len(valueName) );
			local skillDeal = cmd:GetUserValue(valueName);
			skillNames[#skillNames + 1] = skillName;
			skillDamages[#skillDamages + 1] = skillDeal;
		end	
	end

	local retStr = "";
	for i = 1 , 3 do
		local maxDamage = -1;
		local maxDamageIndex = -1;
		for j = 1 , #skillDamages do
			local dam = skillDamages[j];
			if dam ~= nil and dam > maxDamage then
				maxDamage = dam;
				maxDamageIndex = j;
			end
		end
		
		if maxDamageIndex ~= -1 then
			local skillName = skillNames[maxDamageIndex];
			retStr = retStr .. skillName .. "#" .. maxDamage.. "#";
			skillDamages[maxDamageIndex] = nil;
		end

	end

	return retStr;

end

function WORLDPVP_SEND_RESULT_UI(cmd, winTeam, autoExitTime)
	local aidList, infoList = GetAllPCIconInfo(cmd:GetThisPointer());

	local argString = winTeam .. "\\" .. autoExitTime .. "\\";
	for i = 1 , #aidList  do
		local aid = aidList[i];
		local pcInfo = infoList[i];
		
		local dealAmount = math.floor( cmd:GetUserValue("DEAL_AMOUNT_" .. aid, 0) );
		local killCount = math.floor( cmd:GetUserValue("KILL_COUNT_" .. aid, 0) );
		local deathCount = math.floor( cmd:GetUserValue("DEATH_COUNT_" .. aid, 0) );

		local skillDeals = GET_CMD_USERVALUES(cmd, "SKILL_DEAL_AMOUNT_" .. aid);
		argString = argString .. aid .. "\\" .. pcInfo .. "\\" .. killCount .. "\\" .. deathCount .. "\\" .. dealAmount .. "\\" .. skillDeals;
		argString = argString .. "\\";
	end

	local worldInstID = cmd:GetZoneInstID();
	RunClientScriptToWorld(worldInstID, "WORLDPVP_RESULT_UI", argString);
end


function WORLDPVP_ROUND_END(cmd, curStage, eventInst, obj)

	

end

function UPDATE_CUSTOM_LEVEL(pc)
	if GetExProp(pc, "PVP_FIXSTAT_MODE") == 1 then
		return;
	end
	SetExProp(pc, "PVP_FIXSTAT_MODE", 1);
	local level = pc.Lv;
	local stat = pc.StatByLevel;
	local cls = GetClassByType("Xp", level);
	local levelstat = cls.StatPts - 1;
	
	if levelstat > stat then
		local addStat = levelstat - stat;
		local totalStatCount = 0;
		local STR_STAT = pc.STR_STAT;
		local DEX_STAT = pc.DEX_STAT;
		local CON_STAT = pc.CON_STAT;
		local INT_STAT = pc.INT_STAT;
		local MNA_STAT = pc.MNA_STAT;
		totalStatCount = totalStatCount + STR_STAT;
		totalStatCount = totalStatCount + DEX_STAT;
		totalStatCount = totalStatCount + CON_STAT;
		totalStatCount = totalStatCount + INT_STAT;
		totalStatCount = totalStatCount + MNA_STAT;
		local addStr = 0;
		local addDex = 0;
		local addCon = 0;
		local addInt = 0;
		local addMna = 0;
		if totalStatCount == 0 then
			addCon = addStat;
		else
			addStr = addStat * STR_STAT / totalStatCount;
			addDex = addStat * DEX_STAT / totalStatCount;
			addCon = addStat * CON_STAT / totalStatCount;
			addInt = addStat * INT_STAT / totalStatCount;
			addMna = addStat * MNA_STAT / totalStatCount;
		end
		
		AddExProp(pc, "STR_TEMP", addStr);
		AddExProp(pc, "DEX_TEMP", addDex);
		AddExProp(pc, "CON_TEMP", addCon);
		AddExProp(pc, "INT_TEMP", addInt);
		AddExProp(pc, "MNA_TEMP", addMna);
	end
	InvalidateStates(pc);
	AddHP(pc, pc.MHP);
	AddSP(pc, pc.MSP);
end

function SET_LEVEL_FOR_PVP(pc, level)
	local etcObj = GetETCObject(pc);
	SetExProp(etcObj, "FIXED_LEVEL", level);
	UpdatePCLevelUp(pc);
	UPDATE_CUSTOM_LEVEL(pc);
	
end

function INIT_PVP_STAT(self)

	if IsDummyPC(self) == 1 then
		return;
	end

	local etc = GetETCObject(self);
	local teamID = etc.Team_Mission;
	if teamID > 0 then
		SET_LEVEL_FOR_PVP(self, 360);
	end
	
	AddLockSkillList(self, 'Dievdirbys_CarveVakarine');
end

function BATTLEFILD_WAIT_BUFF(cmd)
    local list, cnt = GetCmdPCList(cmd:GetThisPointer());
    for i = 1, cnt do
        local pc = list[i]
        AddBuff(pc, pc, "Silence_Debuff", 1, 0, 3000, 1)
        ClearDiminishingInfo(pc)
    end
end