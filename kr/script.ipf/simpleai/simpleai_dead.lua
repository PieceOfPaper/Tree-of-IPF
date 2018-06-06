-- simpleai_dead.lua

function SAI_DEAD_SOBJ(self, killer, sObjName, propName, propValue)

	if killer == nil then
		return;
	end

	local fromsObj = GetSessionObject(killer, sObjName);
	if fromsObj == nil then
		return;
	end

	fromsObj[propName] = fromsObj[propName] + propValue;
end

function SAI_DEAD_SOBJ_TEAM(self, killer, sObjName, propName, propValue)
	local fromsObj = GetSessionObject(killer, sObjName);
	if fromsObj == nil then
		return;
	end

	fromsObj[propName] = fromsObj[propName] + propValue;
end

function SAI_DEAD_ZOBJ(self, killer, propName, addValue)
	local zoneObj = GetLayerObject(self);	
	zoneObj[propName] = zoneObj[propName] + addValue;
	BroadLayerObjectProp(self, propName);
end

function SAI_DEAD_UI_FORCE(self, from, objType, tgtType, forceName, image, imgSize, addon, child, cnt)

	if objType ~= 0 and GetObjType(from) ~= objType then
		return;
	end

	local tgt = GET_SAI_DAM_TARGET(self, from, tgtType);

	local key = GetSkillSyncKey(from, ret);
	SendSyncPacket(from, key);
	PlayUIForce(tgt, self, forceName, image, imgSize, addon, child, cnt);
	SendEndSyncPacket(from, key);	

end

function S_AI_DEAD_EFFECT(self, killer, tgtType, eftName, scl, offset)
	local tgt = GET_SAI_TARGET(self, killer, tgtType);
	PlayEffect(tgt, eftName, scl, offset);
	return 0;
end

function S_AI_ENTER_BUFF(self, killer, tgtType, buffName, lv, arg2, applyTime, over, rate)
	S_AI_DEAD_BUFF(self, killer, tgtType, buffName, lv, arg2, applyTime, over, rate);
end

function S_AI_ENTER_REMOVE_BUFF(self, killer, tgtType, buffName)
	local tgt = GET_SAI_TARGET(self, killer, tgtType);
	RemoveBuff(tgt, buffName);
end

function S_AI_DEAD_BUFF(self, killer, tgtType, buffName, lv, arg2, applyTime, over, rate)
	local tgt = GET_SAI_TARGET(self, killer, tgtType);
	ADDBUFF(self, tgt, buffName, lv, arg2, applyTime, over, rate);
end

function S_AI_DEAD_ADD_BUFF(self, killer, buffName, lv, arg2, applyTime, over, rate)
	ADDBUFF(self, killer, buffName, lv, arg2, applyTime, over, rate);
end

function S_AI_DEAD_GTOWER_DM(self, killer, MgameClassName, valuecnt, txt, icon, time)
    if time <= 0 then
        time = 1
    end
    

    
    if MgameClassName == 'None' or MgameClassName == nil then
        print('Cant find MgameClassName')
        return
    end
    local msg_int = "NOTICE_Dm_"..icon;
    
    if MgameClassName == 'DIRECT' then
        local list, cnt = GetLayerPCList(self)
        if cnt > 0  then
            local i
            for i = 1, cnt  do
                SendAddOnMsg(list[i], msg_int, txt, time)
            end
        end
    end

    local val = GetMGameValue(self, MgameClassName)
    if val <= 0 then
        return
    end
    if val >= valuecnt then
        return
    end
    

    
    local list, cnt = GetLayerPCList(self)
    if cnt > 0  then
        local i
        for i = 1, cnt  do
            SendAddOnMsg(list[i], msg_int, txt..'{nl}( '..val..' / '..valuecnt..' )', time)
        end
    end
end

function S_AI_DEAD_GTOWER_DM_NAME(self, killer, FlleName, MgameClassName, valuecnt, txt, icon, time)
    if killer == nil then
        return
    end
    if time <= 0 then
        time = 1
    end
    
    if FlleName == 'None' or FlleName == nil then
        print('Cant find FlleName')
        return
    end
    
    if MgameClassName == 'None' or MgameClassName == nil then
        print('Cant find MgameClassName')
        return
    end

    local msg_int = "NOTICE_Dm_"..icon;

    if MgameClassName == 'DIRECT' then
        local list, cnt = GetLayerPCList(self)
        if cnt > 0  then
            local i
            for i = 1, cnt  do
                SendAddOnMsg(list[i], msg_int, txt, time)
            end
        end
    end

    local val = GetMGameValueByMGameName(self, FlleName, MgameClassName)
    if val <= 0 then
        return
    end
    
    if val >= valuecnt then
        return
    end
    

    
    local list, cnt = GetLayerPCList(self)
    if cnt > 0  then
        local i
        for i = 1, cnt  do
            SendAddOnMsg(list[i], msg_int, txt..'{nl}( '..val..' / '..valuecnt..' )', time)
        end
    end
end





function S_AI_DEAD_REMOVE_BUFF(self, killer, tgtType, buffName)
	local tgt = GET_SAI_TARGET(self, killer, tgtType);
	RemoveBuff(tgt, buffName);
end

function S_AI_DEAD_CHAT(self, killer, tgtType, msg, lifeTime)
	local tgt = GET_SAI_TARGET(self, killer, tgtType);
	Chat(tgt, msg, lifeTime);
end

function S_AI_DEAD_KILL_FOL(self, killer, tgtType)
	local tgt = GET_SAI_TARGET(self, killer, tgtType);
	SCR_KILL_ALL_FOLLOWER(tgt);
end

function S_AI_DETACH_OBJ(self, killer, monName, actorScp)
	local han = GET_FOLLOW_BY_NAME(self, monName);
	if han == nil then
		return;
	end

	SET_ATTACH_OWNER(han, nil, "None");
	if actorScp ~= "None" then
		RunActorScp(self, actorScp);
	end

end

function S_AI_TOSS_ATTACHED(self, killer, monName, nodeName)

	if killer == nil then 
		return;
	end

	local han = GET_FOLLOW_BY_NAME(self, monName);
	if han == nil then
		return;
		end
		
	SET_ATTACH_OWNER(han, killer, nodeName);
end

function S_AI_DEAD_SAFE_HIDE(self, killer, tgtType, isOn)

	local tgt = GET_SAI_TARGET(self, killer, tgtType);	
	if isOn == 1 then
		SET_INVIN(tgt, nil, 1);
		ShowModel(tgt, 0);
	else
		SET_INVIN(tgt, nil, 0);
		ShowModel(tgt, 1);
	end

	return 0;
		
end

function S_AI_DEAD_FLY(self, killer ,tgtType, height)
	local tgt = GET_SAI_TARGET(self, killer, tgtType);
	Fly(tgt, height);
end

function S_AI_DEAD_DROP_ITEM(self, killer, itemName, itemCount, probability)
    if probability == nil or probability > 10000 then
        probability = 10000
    end
    local random_item = IMCRandom(0, 10000)
    if random_item >= 0  and random_item <= probability then
    	for i = 1 , itemCount do
    		CREATE_DROP_ITEM(self, itemName, killer)
    	end
    end

end

function S_AI_DEAD_ZONEMSG(self, killer, msg)
	if msg == "" or msg == nil then
		return;
	end

	AddoOnMsgToZone(self, "NOTICE_Dm_!", msg, 3);
end


function S_AI_DEAD_CRE_MON_IND(self, killer, className, x, y, z, angle, range, monProp, lifeTime)
    local q,w,e =GetPos(self)
    if killer == nil then
        return
    end

	local mon1obj = CreateGCIES('Monster', className);
	if mon1obj == nil then
		return nil;
	end

	ApplyPropList(mon1obj, monProp);

	local mon1 = CreateMonster(killer, mon1obj, x, y, z, angle, range, 0, GetLayer(killer));

	
	if mon1 == nil then
		return nil;
	end
    
	if lifeTime > 0 then
		SetLifeTime(mon1, lifeTime);
	end

	return mon1;

end



function S_AI_DEAD_CRE_MON(self1, killer1, className, x, y, z, angle, name, lvFix, lifeTime, simpleAi, monProp)
	local mon = killer1;

	local mon1obj = CreateGCIES('Monster', className);
	if mon1obj == nil then
		return nil;
	end

	if name ~= "" and name ~= mon1obj.Name then
		mon1obj.Name = name;
	end

	local lv = self1.Lv;
	lv = lv + lvFix;
	mon1obj.Lv = lv;

	ApplyPropList(mon1obj, monProp);

	local range = 1;
	local layer = GetLayer(mon);
	local mon1 = CreateMonster(mon, mon1obj, x, y, z, angle, range, 0, layer);
	if mon1 == nil then
		return nil;
	end

	SetOwner(mon1, mon, 1);
	SetCurrentFaction(mon1, GetCurrentFaction(mon));	
	if lifeTime > 0 then
		SetLifeTime(mon1, lifeTime);
	end

	if simpleAi ~= nil and simpleAi ~= "None" then
		RunSimpleAI(mon1, simpleAi);
	end

	return mon1;

end

function S_AI_DEAD_SETPOS(self, killer, tgtType, x, y, z)
	local tgt = GET_SAI_TARGET(self, killer, tgtType);
	SetPos(tgt, x, y, z);
	return 0;
end

function S_AI_DEAD_SILMIDO(self, killer, tgtType, isOn, blendTime)
	local tgt = GET_SAI_TARGET(self, killer, tgtType);
	SET_SILMIDO(tgt, isOn, blendTime);
end

function S_AI_AUTO_REVIVE(self, killer, x, y, z, reviveTime, invinTime)
	AUTO_REVIVE_VIEW(self, x, y, z, reviveTime, invinTime);
end

function SAI_DEAD_ACTORSCP(self, killer, tgtType, scp)
	local tgt = GET_SAI_TARGET(self, killer, tgtType);
	RunActorScp(tgt, scp);
end

function S_AI_DEAD_SHOW_VALUE(self, killer, tgtType, sobjName, propname, text)
	local tgt = GET_SAI_TARGET(self, killer, tgtType);
	local sobj = GetSessionObject(tgt, sobjName);
	if sobj == nil then
		return;
	end

	local killCnt = sobj[propname];
	local key = GetSkillSyncKey(from, ret);
	SendAddOnMsg(tgt, "MCY_MY_KILL", text, killCnt)

end

function S_AI_DEAD_KILL_NOTICE(self, killer, textFormat)
	local teamID = GetTeamID(killer);
	if IS_PC(killer) then
		local nameText = textFormat .. "\\" ..  killer.Job ..  "\\" .. killer.Gender .. "\\" .. killer.Name .. "\\" .. self.Name;
		AddoOnMsgToZone(self, "MCY_KILL_NOTICE", nameText, teamID);
	else
		local nameText = textFormat .. "\\" .. "M\\M\\" .. killer.Name .. "\\" .. self.Name;
		AddoOnMsgToZone(self, "MCY_KILL_NOTICE", nameText, teamID);
	end

end

function SAI_DEAD_ADD_VALUE_NOTICE(self, killer, FileName, valueName, value, valuecnt, txt, icon, time)
    if killer == nil then
        return
    end
    if time <= 0 then
        time = 1
    end
    

    if FileName == nil or FileName == 'None' then
        print("Cant Finde MiniGame File")
        return 0
    end

    if valueName == 'None' or valueName == nil then
        print('Cant find MgameClassName')
        return
    end

    local mgame_value = GetMGameValueByMGameName(self, FileName, valueName)
    local cul_value = mgame_value + value
	SetMGameValueByMGameName(self, FileName, valueName, cul_value);




    local msg_int = "NOTICE_Dm_"..icon;

    if valueName == 'DIRECT' then
        local list, cnt = GetLayerPCList(self)
        if cnt > 0  then
            local i
            for i = 1, cnt  do
                SendAddOnMsg(list[i], msg_int, txt, time)
            end
        end
    end

    local val = GetMGameValueByMGameName(self, FileName, valueName)
    
    if val <= 0 then
        return
    end
    
    if val >= valuecnt then
        return
    end
    

    
    local list, cnt = GetLayerPCList(self)
    if cnt > 0  then
        local i
        for i = 1, cnt  do
            SendAddOnMsg(list[i], msg_int, txt..'{nl}( '..val..' / '..valuecnt..' )', time)
        end
    end


end

function SAI_DEAD_ADD_MGAME_V_NAME(self, killer, FileName, valueName, value)

    if FileName == nil or FileName == 'None' then
        print("Cant Finde MiniGame File")
        return 0
    end

    local mgame_value = GetMGameValueByMGameName(self, FileName, valueName)
    local cul_value = mgame_value + value
	SetMGameValueByMGameName(self, FileName, valueName, cul_value);
end

function SAI_DEAD_DISCNT_MGAME_V_NAME(self, killer, FileName, valueName, value)

    if FileName == nil or FileName == 'None' then
        print("Cant Finde MiniGame File")
        return 0
    end
    --print(killer.Name, FileName, valueName)
    local mgame_value = GetMGameValueByMGameName(killer, FileName, valueName)
    --print(mgame_value)
    if mgame_value > 0 then
        local cul_value = mgame_value - value
        if cul_value < 0 then
    	    cul_value = 0
    	end
    	SetMGameValueByMGameName(killer, FileName, valueName, cul_value);
    end
end

function SAI_DEAD_SET_MGAME_V_NAME(self, killer, FileName, valueName, value)
    if FileName == nil or FileName == 'None' then
        print("Cant Finde MiniGame File")
        return 0
    end
    SetMGameValueByMGameName(self, FileName, valueName, value);
end



function SAI_DEAD_ADD_MGAME_V(self, killer, valueName, value)
	local val = GetMGameValue(self, valueName);
	SetMGameValue(self, valueName, val + value);
end

function SAI_DEAD_SET_MGAME_V(self, killer, valueName, value)

	SetMGameValue(self, valueName, value);
end


function S_AI_RUN_SIMPLEAI_DEAD(self, killer, aiName, stopAllAI)
	if stopAllAI == 1 then
		RunSimpleAIOnly(self, aiName);
	else
		RunSimpleAI(self, aiName);
	end
	return 1;
end





function S_AI_DEAD_SSN_LAYER_ACTOR(self, killer, sObj_name, script)
    local list, cnt = GetLayerPCList(self);
    local i
    for i = 1, cnt do
        local quest_ssn = GetSessionObject(list[i], sObj_name)
        if quest_ssn ~= nil then
            RunScript(script, list[i], quest_ssn)
        end
    end
	return 0;
end


function S_AI_DEAD_FUNC_LAYER_ACTOR(self, killer, script)
    local l ist, cnt = GetLayerPCList(self);
    local i
    for i = 1, cnt do
        RunScript(script, self, list[i])
    end
	return 0;
end

function SAI_DEAD_CRE_PAD(self, killer, x, y, z, angle, padName)
	RunPad(self, padName, nil, x, y, z, angle, 1);
end

function SAI_DEAD_REMOVE_PAD(self, killer, tgtType, padName)

    local tgt = GET_SAI_TARGET(self, killer, tgtType);
	RemovePad(tgt, padName);
end


function SAI_DEAD_FUNC2_DIRECT(self, killer, script)
    local _func = _G[script]
	if nil ~= _func then
		return _func(self, killer)	
	end

	DumpCPP();
	print(script, "script error");
	return nil;
end


function SAI_DEAD_ZONEOBJ_VALUE(self, killer, classname, value)
    local zoneObj = GetLayerObject(self);
    if zoneObj[classname] == nil and zoneObj[classname] ~= 0 then
        return 0
    else
        zoneObj[classname] = value
    end
    return 0
end

function SAI_DEAD_ZONEOBJ_VALUE_ADD(self, killer, classname, value)
    local zoneObj = GetLayerObject(self);
    if zoneObj[classname] == nil and zoneObj[classname] ~= 0 then
        return 0
    else
        zoneObj[classname] = zoneObj[classname] + value
    end
    return 0
end



function SAI_LEAVE_RETURN_HOME(self, killer)
    local list, cnt = SelectObjectByFaction(self, 300, 'Neutral')
    local x, y, z = GetPos(self)
    if cnt > 0 then
        return 0
    else
        self.CreateX = x
        self.CreateY = y
        self.CreateZ = z
        MoveEx(self, x, z, 10)
        return 0
    end
end


function S_AI_DEAD_PLAY_FORCE(self, target, damage, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, collRange, createLength, radiusSpd, searchType, searchRange)
	local skill = GetNormalSkill(self);
	ForceDamage(self, skill, target, self, damage, hitType, resultType, eft, scale, snd, finEft, finScale, finSnd, destroy, fSpeed, easing, gravity, angle, 0, collRange, createLength, radiusSpd)
end

function S_AI_DEAD_BUFF_RANGE(self, killer, tgtType, buffName, lv, arg2, applyTime, over, rate)
    local objList, objCount = SelectObjectNear(self, self, 1000, 'ENEMY');
    for i = 1, objCount do
	    local obj = objList[i];
	    if IsBuffApplied(obj, 'Event_RedOrb_GM') == 'YES' then
	        ADDBUFF(self, obj, 'Event_RedOrb_GM', 0, 0, 3600000, 1);
	    else
	        ADDBUFF(self, obj, 'Event_RedOrb_GM', 0, 0, 1800000, 1);
	    end
	end	 
end