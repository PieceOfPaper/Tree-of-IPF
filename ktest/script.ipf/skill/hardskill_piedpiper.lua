--- hardskill_piedpiper.lua

function GET_FOLLOWER_LIST_BY_NAME(pc, name)
	local mouseList = {}
	local list, cnt = GetFollowerList(pc)
	for i = 1, cnt do 
        local obj = list[i];
        if obj.ClassName == name then
            mouseList[#mouseList + 1] = obj;
		end
	end

    return mouseList;
end

function UPDATE_PIEDPIPER_MOUSE(pc, mon)

end

function MOVE_TO_ATTACK_NEAR_ENEMY(mon, monSkillName, x, y, z, enemy)
    local nearDist = 10;
    ClearSimpleAI(mon, "ALL");
    local dist = Get2DDistFromPos(mon, x, z);
    if dist > nearDist then
        local moveRet = MoveEx(mon, x, y, z, nearDist, "RUN");
        if moveRet ~= "YES" then
            return;
        end
    end

    while dist > nearDist do
        dist = GetDistFromMoveDest(mon);
        sleep(500);
    end

    local skillRet = UseMonsterSkill(mon, enemy, monSkillName);

    sleep(500);

    if skillRet == nil then
        return;
    end

    while 1 do
        if IsSkillUsing(mon) == 0 then
            break;
        end
        sleep(500);
    end
    
    PlayEffect(mon, "F_smoke063", 0.5)
    Dead(mon, 1);
end

function MAKE_PIEDPIPER_MOUSE(pc)
	sleep(500)
	
    local buff = GetBuffByName(pc, "HamelnNagetier_Buff");
    if buff == nil then
        return;
    end
    local cnt = GetExProp(buff, "MOUSE_COUNT");
    if cnt >= 5 then
        return;
    end

    local abilLv = 0;
    local abil = GetAbility(pc, "PiedPiper13");
    if abil ~= nil then
        abilLv = abil.Level;
    end

    local mouseName = "piedpiper_mouse";
    if abilLv > 0 then
        local rand = IMCRandom(1, 100);
        if rand <= abilLv * 2 then
            mouseName = "piedpiper_mouse_white";
        end
    end

    local enter = "None";
    local simpleAI = "alchmist_homunclus";

	local iesObj = CreateGCIES("Monster", mouseName);
	if nil == iesObj then
		return nil;
	end
    
	iesObj.Faction = GetCurrentFaction(pc);
	iesObj.Enter = enter;
    iesObj.Name = SofS(iesObj.Name, pc.Name)
    
    iesObj.Lv = 1;
    local sklObj = GetSkill(pc, "PiedPiper_HamelnNagetier");
    if sklObj ~= nil then
        iesObj.Lv = sklObj.Level;
    end
    
	local x, y, z = GetFrontRandomPos(pc, 10);
	local mon = CreateMonster(pc, iesObj, x, y, z, 0, 0);
	if nil == mon then
		return nil;
	end

	SetOwner(mon, pc);
	RunSimpleAI(mon, simpleAI);

	SetExProp(buff, "MOUSE_COUNT", cnt+1);
	SetDeadScript(mon, "PIEDPIPER_MOUSE_DEAD")

	UPDATE_PIEDPIPER_MOUSE(pc, mon)
	PlayEffect(mon, "F_smoke063", 0.5)
	SetLifeTime(mon, 60)
	return mon;
end

function PIEDPIPER_MOUSE_DEAD(mon)
    local pc = GetOwner(mon);
    if pc == nil then
        return;
    end
    local buff = GetBuffByName(pc, "HamelnNagetier_Buff");
    if buff == nil then
        return;
    end

    local cnt = GetExProp(buff, "MOUSE_COUNT");
    if cnt > 1 then
        SetExProp(buff, "MOUSE_COUNT", cnt-1);
    else
        SetExProp(buff, "MOUSE_COUNT", 0);
        RemoveBuff(pc, "HamelnNagetier_Buff");
    end

end

function RAMDOM_POS_IN_RANGE(x, y, z, moveRange)
    local randX = IMCRandom(x-moveRange, x+moveRange);
    local randZ = IMCRandom(z-moveRange, z+moveRange);
    return randX, y, randZ;
end

function FOLLOWERS_MOVE_TO_ATTACK_NEAR_ENEMY(pc, skl, monName, monSkillName, x, y, z, moveRange, findRange)
    local foundEnemyCnt = 0;
    local list = GET_FOLLOWER_LIST_BY_NAME(pc, monName);
    for i=1, #list do
        local mon = list[i];
        local mx, my, mz = RAMDOM_POS_IN_RANGE(x, y, z, moveRange);
        local enemyList, enemyCnt = SelectObjectPos(pc, mx, my, mz, findRange, "ENEMY");
        if enemyCnt > 0 then
            local enemy = enemyList[1];
            foundEnemyCnt = foundEnemyCnt + 1;
            RunScript("MOVE_TO_ATTACK_NEAR_ENEMY", mon, monSkillName, mx, my, mz, enemy);
        end
    end
    
    if #list > 0 and foundEnemyCnt <= 0 then
        SendSysMsg(pc, "NoAttackableEnemy");
    end
end

function SCR_BUFF_ENTER_HamelnNagetier_Buff(self, buff, arg1, arg2, over)
	RunScript("MAKE_PIEDPIPER_MOUSE", self)
end

function SCR_BUFF_LEAVE_HamelnNagetier_Buff(self, buff, arg1, arg2, over)
	
end

function BUFF_ADD_CHECK_HamelnNagetier_Buff(target, caster)
	local hamelnSkill = GetSkill(target, "PiedPiper_HamelnNagetier")
	if hamelnSkill == nil then
		return 0;
	end
	
    local buff = GetBuffByName(target, "HamelnNagetier_Buff");
    local over = 0;
    if buff ~= nil then
    	over = GetOver(buff);
    end
    
    if over < 5 then
        return 1;
    end
    
    return 0;
end

function SCR_HYPNOTISCHEFLOTE_MON_LIMITATION(self, pad, target)
    if IS_PC(target) == false then
		if TryGetProp(target, "MoveType") == "Holding" or TryGetProp(target, "MonRank") == "Boss" then
			return 0;
		end
    end
    
    return 1;
end

function SCR_SNOWROLLING_LIMITATION(self, pad, target)
	if IsBuffApplied(target, 'SnowRolling_Buff') == 'YES' or TryGetProp(target, "MonRank") == "Boss" then
		return 0;
    end
    
    return 1;
end

function SCR_DISSONANZ_DETECTING(self, skl, isDamage, applyTime)
    local targetlist = GetHardSkillTargetList(self)
    for i = 1 , #targetlist do
        local target = targetlist[i]
        if IsBuffApplied(target, "UC_Detected_Debuff") == 'NO' then
            AddBuff(self, target, 'UC_Detected_Debuff', 1, 1, 1000)
        end
        
        if IsBuffApplied(target, "Cloaking_Buff") == "YES" or IsBuffApplied(target, "Burrow_Rogue") == 'YES' then
            RemoveBuff(target, "Cloaking_Buff")
            RemoveBuff(target, "Burrow_Rogue")
        end
    end
end

function STOP_PLAY_FLUTING_ALL(pc)
    RunScript("_STOP_PLAY_FLUTING_ALL", pc, 200)
end

function _STOP_PLAY_FLUTING_ALL(pc, ms)
    sleep(ms);
    StopFlutingAll(pc);
end
