--- hardskill_corsair.lua

function CORSAIR_MAKE_HOOK(self, skl, eft, eftScale, eftNode, linkTexture, actorNode, targetNode, speed, easing, x, y, z, limitTime) 
 
	local tgtList = GetHardSkillTargetList(self);
	if #tgtList == 0 then
		ShowHookEffect(self, eft, eftScale, linkTexture, actorNode, speed, easing, x, y, z);	
		return;
	end

	local tgt = tgtList[1];	
	if tgt == nil or tgt.Size == "XL" then
		return;
	end
	
	if TryGetProp(tgt, "MoveType") == "Holding" or tgt.MonRank == "MISC" or tgt.MonRank == "NPC" then
	  return;
	end
	InsertHate(tgt, self, 1);
	MakeHookEffect(self, tgt, eft, eftScale, linkTexture, actorNode, targetNode, speed, easing);
	local time = 4000 + skl.Level * 1000
	if IsPVPServer(self) == 1 or IsJoinColonyWarMap(self) == 1 then
	    if time >= 10000 then
	        time = 10000
	    end
	end
	local buff = AddBuff(self, self, "IronHook", skl.Level, 1, 0, 1);    
    
	SetExArgObject(self, "IRON_HOOK_TGT_1", tgt);
	local tgt_buff = AddBuff(self, tgt, "IronHooked", skl.Level, 1, time, 1);
    SetExArgObject(tgt, 'CASTER_OF_IRON_HOOK', self)    
    if tgt_buff == nil then        
        RemoveBuff(self, 'IronHook')
        RemoveHookEffect(self, 0);        
    end

    SetExProp(buff, "TIME", imcTime.GetAppTime());
	SetExProp_Str(tgt, "IRONHOOK_EFFECT", eft)
	SetExProp(tgt, "IRONHOOK_SCALE", eftScale)
	SetExProp_Str(tgt, "IRONHOOK_NODE", eftNode)
end

function CORSAIR_MAKE_HOOK_FOR_ABIL(self, skl, eft, eftScale, eftNode, linkTexture, actorNode, targetNode, speed, easing, x, y, z, limitTime)
	local tgtList = GetLinkObjectsByCmdIndex(self,'IronHook', 0);
	if nil == tgtList then
		return;
	end

	if #tgtList == 0 then
		ShowHookEffect(self, eft, eftScale, linkTexture, actorNode, speed, easing, x, y, z);	
		return;
	end

    local time = limitTime * 1000
	if IsPVPServer(self) == 1 or IsJoinColonyWarMap(self) == 1 then
	    if time >= 10000 then
	        time = 10000
	    end
	end

	local buff = AddBuff(self, self, "IronHook", skl.Level, 1, 0, 1);
	SetExProp(buff, "TIME", imcTime.GetAppTime());

	for i = 1, 3 do
		local tgt = tgtList[i];	
		if tgt == nil or tgt.Size == "XL" then
			return;
		end

		if i == 1 then
			MakeHookEffect(self, tgt, eft, eftScale, linkTexture, actorNode, targetNode, speed, easing);
		end
        
		InsertHate(tgt, self, 1);		
		SetExArgObject(self, "IRON_HOOK_TGT_"..i, tgt);

		local tgt_buff = AddBuff(self, tgt, "IronHooked", skl.Level, 1, time, 1);
        SetExArgObject(tgt, 'CASTER_OF_IRON_HOOK', self)    
        if tgt_buff == nil then        
            RemoveBuff(self, 'IronHook')
            RemoveHookEffect(self, 0);        
        end

		SetExProp_Str(tgt, "IRONHOOK_EFFECT", eft)
		SetExProp(tgt, "IRONHOOK_SCALE", eftScale)
		SetExProp_Str(tgt, "IRONHOOK_NODE", eftNode)
	end
end

function SCR_BUFF_ENTER_IronHooked(self)    
  local eftName = GetExProp_Str(self, "IRONHOOK_EFFECT", eft)        
  local eftScale = GetExProp(self, "IRONHOOK_SCALE", eftScale)
  local eftNode = GetExProp_Str(self, "IRONHOOK_NODE", eftNode)
  
  PlayEffectNode(self, eftName, eftScale, eftNode)
  --AttachEffect(self, 'F_warrior_IronHook', 1, 'TOP') 
  PlayEffectNode(self, 'F_warrior_IronHook', 1, 'Bip01 Spine2')

end

function SCR_BUFF_LEAVE_IronHooked(self)    
    DetachEffect(self, 'F_warrior_IronHook')
    
    local caster = GetExArgObject(self, 'CASTER_OF_IRON_HOOK')
    if caster ~= nil then
        RemoveBuff(caster, 'IronHook')
        RemoveHookEffect(caster, 0);
    end
    
end

function SCR_BUFF_ENTER_IronHook(self)    
end

function SCR_BUFF_LEAVE_IronHook(self)    
	RemoveHookEffect(self, 0);
	for i=1, 3 do
		local tgt = GetExArgObject(self, "IRON_HOOK_TGT_"..i);
		if tgt ~= nil then
			RemoveBuff(tgt, "IronHooked");
			--ClearExArgObject(self, "IRON_HOOK_TGT_"..i);
		end
	end
end

function CORSAIR_HOOK_PULL_READY(self)
	RemoveHookEffect(self, 1);
	return 1;
end

function END_HOOK_PULL(self)
	local tgt = GetExArgObject(self, "IRON_HOOK_TGT_1");
	if nil == tgt then
		return;
	end

	ClearDisableActionForMS(tgt);
end

function CORSAIR_HOOK_PULL(self, skl, x, y, z, speed, easing, damRate, atkCount, atkTerm)
	RemoveHookEffect(self, 1);
	local tgt = GetExArgObject(self, "IRON_HOOK_TGT_1");
	RemoveBuff(self, "IronHook");
	--PlayEffectNode(tgt, 'F_warrior_IronHook_hold', 1, 'Bip01 Spine2')

	if nil == tgt then
		return;
	end

	if IsDead(tgt) == 1 then
		SkillCancel(self);
		return;
	end

	DisableActionForMS(tgt, 1000);
	local remainDist = Get2DDistFromPos(tgt, x, z)
	if remainDist <= 15 then
		SkillCancel(self);
		local Corsair4 = GetAbility(self, 'Corsair4');
		if Corsair4 ~= nil then
	        AddBuff(self, tgt, 'UC_bleed', Corsair4.Level, 0, 4000 + Corsair4.Level * 1000, 1);
		end
		return;
	end
	
	local moveLength = 30;
	local advDist = math.min(remainDist, moveLength);
	x, y, z = GetUnobstructedPosWithLimitDist(tgt, x, y, z, advDist);
	Move3D(tgt, x, y, z, speed, 0, 1, 1);

	for i = 1 , atkCount do
		local syncKey = GenerateSyncKey(self);
		StartSyncPacket(self, syncKey );
		local damage = SCR_LIB_ATKCALC_RH(self, skl)
		TakeDamage(self, tgt, skl.ClassName, damage);
					
		EndSyncPacket(self, syncKey, (i - 1) * atkTerm + 0.1);
		ExecSyncPacket(self, syncKey);
					
	end
end

function CORSAIR_PARTY_BUFF_PROCESS(leader, self, isEnter) -- self는 파티장인 커세어 여야만 한다.\
	-- verify param
	if leader == nil or self == nil then
		return;
	end
	local party = GetPartyObj(leader);
	if party == nil then
		return;
	end

	if GetAbility(leader, 'Corsair18') == nil then
		return;
	end

	local members, cnt = GetPartyMemberList(leader, PARTY_NORMAL);
	if members == nil then
		return;
	end
	local leaderMap = GetMapProperty(leader);
	local myMap = GetMapProperty(self);
	if leaderMap == nil or myMap == nil then
		return;
	end

	-- Add / Remove Buff
	for i = 1, cnt do
		if isEnter == 1 and leaderMap.ClassID == myMap.ClassID then
			if IsBuffApplied(members[i], 'CorsairParty_Buff') ~= 'YES' then
				AddBuff(leader, members[i], 'CorsairParty_Buff');
			end			
		elseif isEnter == 0 and IsSameObject(leader, self) == 1 then
			RemoveBuff(members[i], 'CorsairParty_Buff');
		end
	end
	if isEnter == 0  and leader ~= self then
		RemoveBuff(self, 'CorsairParty_Buff');
	end
end

function SCR_BUFF_ENTER_CorsairParty_Buff(self, buff, arg1, arg2, over)
	local caster = GetBuffCaster(buff);
	if caster == nil then
		return 0;
	end
	
	if GetDistance(self, caster) <= 500 and IsBuffApplied(self, 'Looting_Buff') ~= 'YES' then
		AddBuff(caster, self, 'Looting_Buff', 1, 0, 0, 1, 100, 0);
	end
end

function SCR_BUFF_UPDATE_CorsairParty_Buff(self, buff, arg1, arg2, remainTime, ret, over)
	local caster = GetBuffCaster(buff);
	if caster == nil then
		return 0;
	end
	if IsDead(caster) == 1 or IsDead(self) == 1 or GetDistance(self, caster) > 500 then
		if IsBuffApplied(self, 'Looting_Buff') == 'YES' then
    		RemoveBuff(self, 'Looting_Buff');
    	end
	elseif GetExProp(self, 'RESURRECT') ~= 1 then
		if IsBuffApplied(self, 'Looting_Buff') ~= 'YES' then
			AddBuff(caster, self, 'Looting_Buff', 1, 0, 0, 1);
		end
	end
	return 1;
end

function SCR_BUFF_LEAVE_CorsairParty_Buff(self, buff, arg1, arg2, over)
	RemoveBuff(self, 'Looting_Buff');
end

function PAD_TGT_BUFF_REMOVE_JOLLYROGER(self, skl, pad, target, tgtRelation, consumeLife, useCount, buffName, delOwerBuff)
	if delOwerBuff == nil then
		delOwerBuff = 0;
	end

	local monHandle = GetPadUserValue(pad, 'PAD_MON_HANDLE');
	local buff = GetBuffByName(target, buffName);
	if buff~= nil then
		local buffMonHandle = GetBuffArgs(buff);
		if monHandle ~= buffMonHandle then
			return;
		end
	end

	if IS_APPLY_RELATION(self, target, tgtRelation) then
		if delOwerBuff == 0 then
			RemoveBuff(target, buffName);
		else
			RemoveBuffByCaster(target, self, buffName);
		end
		AddPadLife(pad, consumeLife);
		AddPadUseCount(pad, useCount);
	end
end

function SCR_BUFF_TAKEDMG_JollyRoger_Enemy_Debuff(self, buff, sklID, damage, attacker, ret)
	local monHandle = GetBuffArgs(buff);
	local caster = GetBuffCaster(buff);
	local pad = GetPadByBuff(caster, buff);

	if IsBuffApplied(attacker, 'JollyRoger_Buff') ~= 'YES' then
		return 1;
	end

	local jollyRoger = GetByHandle(attacker, monHandle);	
	if jollyRoger == nil then
		return 1;
	end

	if GetExProp(jollyRoger, 'FEVER_BUFF') == 1 then -- 이미 피버가 걸렸던 졸리로저면 콤보효과 ㄴㄴ해
		return 0;
	end

	-- process fever count
	local multiHitCount = GetMultipleHitCount(ret);
	for i = 0, multiHitCount do 		
		AddFeverCombo(attacker, jollyRoger, SCR_FEVERCOMBO(jollyRoger, attacker));
	end

	return 1;
end

-- 업데이트인데 이미 버프가 걸려있으면 안 덮어씌우는 용도임. 졸리로저에서 쓸거에여 ㅠㅠ
function PAD_BUFF_ENEMY_JOLLYROGER(self, skl, pad, tgtRelation, consumeLife, useCount, buffName, lv, arg2, applyTime, over, rate)

	local objList, cnt = GetPadObjectList(pad);
	if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
		return;
	end

	for i = 1 , cnt do
		local target = objList[i];
		if IS_APPLY_RELATION(self, target, tgtRelation) and IsBuffApplied(target, buffName) ~= 'YES' then
			ADDPADBUFF(self, target, pad, buffName, lv, arg2, applyTime, over, rate);			
			AddPadLife(pad, consumeLife);
			AddPadUseCount(pad, useCount);
			if GetPadLife(pad) <= 0 or GetPadUseCount(pad) <= 0 then
				return;
			end
		end
	end

end