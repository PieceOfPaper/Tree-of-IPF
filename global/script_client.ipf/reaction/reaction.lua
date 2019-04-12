function REACTION1(MyHandle)

	SetLookAtReaction(MyHandle, 'TRUE', 10000);
end

function MON_DEAD_CLIENT(actor)

	local obj = actor;
	local monID = obj:GetType();
	if monID ~= 0 then
		local monCls = GetClassByType("Monster", monID);
		
		-- 보스는 따로 ShockWave가 셋팅되므로 return 시킴. 동진씨 요청
		if monCls.ClassName == "Missile" or monCls.MonRank == "Boss" then
			return;
		end
	end
		
	world.ShockWave(actor, 2, 700, 5, 0.7, 45, 0.8);

end

function C_SHOCKWAVE(actor, obj, intensity, time, freq, range)
	world.ShockWave(actor, 2, range, intensity, time, freq, 0);
end

function C_SKL_LOCK_MOVE(actor, obj, isOn)
	local key = "SKL_" .. obj.type;
	actor:LockMoveByKey(key, isOn);
	if isOn == 1 then
		actor:AddSkillLockMove(key);
	end
end

function C_SKL_LOCK_ROTATE(actor, obj, isOn)
	local key = "SKL_" .. obj.type;
	actor:LockRotateByKey(key, isOn);
	if isOn == 1 then
		actor:AddSkillLockRotate(key);
	end
end

function C_EFFECT(actor, obj, effectName, scale, nodeName, lifeTime)
	
	if lifeTime == nil then

		lifeTime = 0;

	end

	effect.PlayActorEffect(actor, effectName, nodeName, lifeTime, scale);

end

function C_EFFECT_USE_XYZ(actor, obj, effectName, scale, nodeName, x, y, z)

	effect.PlayActorEffect(actor, effectName, nodeName, lifeTime, scale,x,y,z);

end

function C_EFFECT_POS(actor, obj, eftName, scl, x, y, z, lifeTime, key)
	if key == nil then
		key = "None";
	end

	effect.PlayGroundEffect(actor, eftName, scl, x, y, z, lifeTime, key);
end

function C_EFFECT_ATTACH(actor, obj, eftName, scl, scl2, x, y, z, autoDetach)
	if x == nil then
		effect.AddActorEffect(actor, eftName, scl * scl2, 0, 0, 0);
	else
		effect.AddActorEffect(actor, eftName, scl * scl2, x, y, z);
	end

	-- 헬 파이어처럼 스킬에 따로 ScpArgMsg("Auto_iPegTeuTteKi")를 넣을수없을때 사용하면 됨
	if autoDetach == 1 then
		actor:GetEffect():AddAutoDetachEffect(eftName);
	end
end

function C_EFFECT_ATTACH_OOBE(actor, obj, eftName, scl, scl2, x, y, z, autoDetach)
	local oobeActor = actor:GetOOBEActor();
	if oobeActor ~= nil then
		if x == nil then
			effect.AddActorEffect(oobeActor, eftName, scl * scl2, 0, 0, 0);
		else
			effect.AddActorEffect(oobeActor, eftName, scl * scl2, x, y, z);
		end

		-- 헬 파이어처럼 스킬에 따로 ScpArgMsg("Auto_iPegTeuTteKi")를 넣을수없을때 사용하면 됨
		if autoDetach == 1 then
			oobeActor:GetEffect():AddAutoDetachEffect(eftName);
		end
	end
end


function C_EFFECT_DETACH_OOBE(actor, obj, eftName, scl, hideTime)
	local oobeActor = actor:GetOOBEActor();
	if oobeActor ~= nil then
		effect.DetachActorEffect(oobeActor, eftName, hideTime);
	end
end

function C_EFFECT_DETACH(actor, obj, eftName, scl, hideTime)
	effect.DetachActorEffect(actor, eftName, hideTime);
end

function C_EFFECT_DETACH_ALL(actor, obj, eftName, scl, hideTime)
	effect.DetachActorEffect_FindName(actor, eftName, hideTime);
end

function C_SOUND(actor, obj, soundName)
	actor:GetEffect():PlaySound(soundName);
end

function C_REMOVE_LINK(actor, obj, soundName)
	actor:RemoveLinkTexture();
end

function SKL_SEND_HEIGHT_C(actor, obj)
	hardSkill.SendHeight(actor);
end

function SKL_SYNC_EXEC_C(actor, obj)
	actor:ExecSkillSyncKeys();
end

function C_VOICE_SOUND(actor, obj, maleVoice, femaleVoice)

	if actor:GetObjType() == GT_MONSTER then
		return;
	end

	local gender = customize.GetGender( actor:GetHandleVal() );
	
	if gender == 0 then
		return;
	elseif gender == 1 then
		actor:GetEffect():PlaySound(maleVoice);
	else
		actor:GetEffect():PlaySound(femaleVoice);
	end
	
end

function MONSKL_C_PLAY_ANIM(actor, skill, animName, spd, freezeAnim)
	actor:GetAnimation():ResetAnim();
	actor:GetAnimation():PlayFixAnim(animName, spd, freezeAnim, 0);
end

function MONSKL_C_PLAY_ANIM_OOBE(actor, skill, animName, spd, freezeAnim)
	local oobeActor = actor:GetOOBEActor();
	if oobeActor ~= nil then
		oobeActor:GetAnimation():ResetAnim();
		oobeActor:GetAnimation():PlayFixAnim(animName, spd, freezeAnim, 0);
	end
end

function MONSKL_C_STOP_ANIM_OOBE(actor)
	local oobeActor = actor:GetOOBEActor();
	if oobeActor ~= nil then
		oobeActor:GetAnimation():StopFixAnim();
	end
end

function MONSKL_C_SET_TOOLTIME_ANIM(actor, skill, animName)
	actor:SetToolSkillAnim(animName);
end

function MONSKL_C_STOP_ANIM(actor)
	actor:GetAnimation():StopFixAnim();
end

function MONSKL_C_SET_ANIM_SPD(actor, skill, spd)

	actor:GetAnimation():SetAnimSpeed(spd);
end

function MONSKL_C_SET_ANIM_SPD_EX(actor, skill, startSpd, endSpd, time, ratio)
	actor:GetAnimation():SetAnimSpeedEx(startSpd, endSpd, time, ratio);
end    

function SKL_PLAY_ANI_TOTIME(actor, skill, animName, spd, freezeAnim, cancelByMove, fromTime, toTime)
	actor:GetAnimation():PlayAnimByFrame(animName, spd, freezeAnim, cancelByMove, fromTime, toTime);
end

function SKL_C_RESUME_ANI(actor)
	actor:GetAnimation():SetMaxAnimFrame(-1);
end

function C_CALL_MON_ANI(actor, skill, monName, yOffset, eft1, eft1Scale, eft2, eft2Scale)
	local mon = actor:GetAnimation():CreateSamePosMonster(monName, yOffset);
	if mon ~= nil then
		if eft1 ~= "None" then
			effect.AddActorEffect(mon, eft1, eft1Scale, 0, 0, 0);
		end

		if eft2 ~= "None" then
			effect.AddActorEffect(mon, eft2, eft2Scale, 0, 0, 0);
		end
	end
end

function C_PLAY_ANIMMON_ANI(actor, skill, monName, animName, spd, freezeAnim, cancelByMove, fromFrame, toFrame)
	local mon = actor:GetAnimation():GetAnimationMonster(monName);
	if mon ~= nil then
		mon:GetAnimation():PlayAnimByFrame(animName, spd, freezeAnim, cancelByMove, fromFrame, toFrame);
	end
end

function C_DESTROY_MON_ANI(actor, skill, monName)
	actor:GetAnimation():DestroyAnimMonster(monName);
end

function MONSKL_C_CLEAR_RESERVE_ANIM(actor, skill)
	actor:GetAnimation():ClearReservedAnim();
end

function MONSKL_C_RESERVE_ANIM(actor, skill, animName, spd, freezeAnim)
	actor:GetAnimation():ReserveAnim(animName, spd, freezeAnim);
end

function C_NEXT_SKILL_RESERVE_RESETANIM(actor)
	actor:GetAnimation():SetNextSkillReserveResetAnim(true);
end

function MONSKL_C_RESERVE_ANIM_OOBE(actor, skill, animName, spd, freezeAnim)
	local oobeActor = actor:GetOOBEActor();
	if oobeActor ~= nil then
		oobeActor:GetAnimation():ReserveAnim(animName, spd, freezeAnim);
	end
	
end

function MONSKL_C_CASTING_ANIM(actor, skill, animName, moveAnimName, spd, freezeAnim, buffName, buffAnimName)

	if buffName ~= nil and buffName ~= 'None' then
		local handle = actor:GetHandleVal();
		local buff = info.GetBuffByName(handle, buffName);
		if buff ~= nil then
			animName = buffAnimName;
		end
	end
	
	actor:GetAnimation():SetCastingAnim(animName, moveAnimName, spd, freezeAnim);	
end

function MONSKL_C_RESET_CASTING_ANIM(actor, skill)
	actor:GetAnimation():ResetCastingAnim();
end

function MONSKL_C_SET_ASTD_ANIM(actor, skill, animName)
	actor:GetAnimation():SetSTDAnim(animName);
end

function MONSKL_C_RESET_ASTD_ANIM(actor, skill)
	actor:GetAnimation():ResetSTDAnim();
end

function C_HOLD_SKL_ANI_CLIENT(actor)
	actor:GetAnimation():PauseAnim(3.0);
end

function C_RESUME_SKL_ANI(actor)
	actor:GetAnimation():ResumeAnim();
end

function C_HIDE_MODEL(actor, skill, isShow, blendTime)
	actor:GetAnimation():ShowModel(isShow, blendTime);
end

function C_SHOW_PARTS_MODEL(actor, obj, parts, isShow, refreshSklEnd)
	if refreshSklEnd == nil then
		refreshSklEnd = 1;
	end
	actor:ShowModelByPart(parts, isShow, refreshSklEnd);
end

function C_ATTACH_PARTS_MODEL(actor, obj, parts, nodeName)
	actor:GetAnimation():AttachXacToPart(parts, nodeName);
end

function C_SET_CAM_FIXHEIGHT(actor, obj, height)
	view.SetCamFixHeight(height);
end

function C_FIX_CAM_POSY(actor, obj, holdTime)
	if GetMyActor() == actor then
	view.SetLockCamPosY(holdTime);
end
end

function C_CAM_NOWAT_TIMERATIO(actor, obj, ratio)
	view.SetNowAtUpdateTimeRatio(ratio);
end


function C_SKL_SPIN_OBJ(actor, obj, delay, spinCount, spinSec)	
	actor:Spin(delay, spinCount, spinSec, 0);
end

function C_SKL_BLINK(actor, obj, x, y, z, angle)	
	-- 클라 연출용
	actor:SetPos(x, y, z);
	actor:SetRotate(angle);
end


function C_COLORBLEND_ACTOR(self, obj, actorType, isUse, color_R, color_G, color_B, colar_A, blendOption)

	local target = self;
	
	-- 1 : 스킬시전자, 2 : 스킬 타겟
	if actorType == 1 then
		target = self;
	elseif actorType == 2 then
		target = self:GetTargetObject();
	end
	
	if target ~= nil then	
		target:GetEffect():ActorColorBlend(isUse, color_R, color_G, color_B, colar_A, blendOption);
	end
end

function C_FORCE_EFT(actor, obj, eft, scale, snd, finEft, finEftScale, finSnd, destroy, fSpeed, easing, gravity, angle, hitIndex, collrange, createLength, radiusSpd, isLastForce, useHitEffect, linkTexName, dist, offSetAngle, height, delayStart, fixVerDir)


	if useHitEffect== nil then
		useHitEffect = 1;
	end

	if radiusSpd == nil then
		radiusSpd = 0.0;
	end

	if createLength == nil then
		createLength = 0.0;
	end

	if linkTexName == nil then
		linkTexName = 'None';
	end
		
	if customTarget == nil then
		customTarget = 0;
	end
	
	if delayStart == nil then
		delayStart = 0;
	end

	local addX = 0;
	local addY = 0;
	local addZ = 0;
	if dist == nil or offSetAngle == nil or height == nil then

	else
		if dist > 0 then
			offSetAngle = DegToRad(offSetAngle);
			addX = math.cos(offSetAngle) * dist;
			addY = height;
			addZ = math.sin(offSetAngle) * dist;
		end
	end

	if fixVerDir == nil then
		fixVerDir = 0;
	end
	
	local ret = actor:GetForce():PlayForce_Tool(eft, scale, snd, finEft, finEftScale, finSnd, destroy, fSpeed, easing, gravity, angle, hitIndex, collrange, createLength, radiusSpd, useHitEffect, customTarget, linkTexName, delayStart, addX, addY, addZ, fixVerDir);

	-- 마지막포스가 날라가면 스킬캔슬 가능하게 해준다.
	if isLastForce == 1 or isLastForce == nil then	-- nil도 체크하는이유는 값셋팅안된건 걍 무조건 마지막포스라고 생각함
		actor:EnableSkillCancel(1);
	end

	return ret;
end

-- 연출용 포스. 바닥에 날라가 떨어지는 포스
function C_SR_FORCE_DROP(self, target, sklLevel, hitInfo, hitIndex, eft, scale, snd, finEft, finEftScale, finSnd, destroy, fSpeed, easing, gravity, angle, hitIndex, collrange, createLength, radiusSpd)

	self:GetForce():PlayForce_Drop(eft, scale, snd, finEft, finEftScale, finSnd, destroy, fSpeed, easing, gravity, angle, hitIndex, collrange, createLength, radiusSpd);
end

function C_MON_KILL_TEXT_EFT(actor, atk_rate, targetActor)

	local obj = targetActor:GetFSMHandler();
	if obj:GetObjType() == GT_MONSTER then
		local type = obj:GetType();
		local monCls = GetClassByType("Monster", type);
		if monCls.Faction ~= "Monster" then
			return;
		end
	end


	local text;
	if atk_rate > 60 then 
		text = "Greeeeeat!!";
	elseif atk_rate > 30 then
		text = "Good!";
	elseif atk_rate > 0 then
		text = "Normal";
	else
		text = "Bad";
	end

	PlayEffect_SyncHit(actor, targetActor, 'I_SYS_damage_decision', 0.9, "MID", text);
end

function C_MON_KDBonus_TEXT_EFT(actor, addDamage, targetActor)

	local obj = targetActor:GetFSMHandler();
	if obj:GetObjType() == GT_MONSTER then
		local type = obj:GetType();
		local monCls = GetClassByType("Monster", type);
		if monCls.Faction ~= "Monster" then
			return;
		end
	end

	PlayEffect_SyncHit(actor, targetActor, 'I_SYS_damage_decision', 0.75, "TOP", ScpArgMsg("Auto_NeogBaeg_ChuKa_+")..math.floor(addDamage));
end


function C_SKL_MON_ATTACH_NODE(actor, obj, monName, nodeName, isAttach, monNodeName, scale, relation)
	local mon = actor:GetClientMonster():AttachMonsterToNode(monName, nodeName, isAttach, monNodeName);
	if mon == nil then	
		return;
	end
	
	if scale ~= 0 then
		mon:ChangeScale(scale, 0.0);
	end
	if nil ~= relation and relation == 1 then
		SetController(actor, mon);
	end
end

function C_SKL_MON_CRE_POS(actor, obj, monName, aniName, x, y, z, isGravity, isDelete)	
	actor:GetClientMonster():ClientMonsterToPos(monName, aniName, x, y, z, isGravity, isDelete);
end

function C_SKL_MON_MOVE(actor, obj, monName, x, y, z, easing, moveTime)
	actor:GetClientMonster():ClientMonsterMoveTo(monName, MakeVec3(x, y, z), easing, moveTime);
end

function C_SKL_MON_ANIM(actor, obj, monName, animName, spd, fixAnim)
	local mon = actor:GetClientMonster():GetClientMonsterByName(monName);
	mon:GetAnimation():PlayFixAnim(animName, spd, fixAnim);
end

function C_SKL_MON_SCALE(actor, obj, monName, scl, time)
	local mon = actor:GetClientMonster():GetClientMonsterByName(monName);
	if mon == nil then
		return;
	end

	mon:ChangeScale(scl, time);
end

function C_SKL_MON_BY_KEY(actor, obj, monName, key, x, y, z, angle, moveDestroy, attachNode)
	if attachNode == nil then
		attachNode = "None"
	end
	actor:GetClientMonster():CreateMonsterByKey(monName, x, y, z, angle, key, moveDestroy, attachNode);	
end

function C_SKL_MON_ANIM_KEY(actor, obj, key, animID, freezeAni)
	actor:GetClientMonster():PlayAnimByKey(key, animID, freezeAni);
end

function C_REMOVE_ANI_CLIENT_MON_KEY(actor, obj, key)
	actor:GetClientMonster():RemoveAniMonsterByKey(key);
end

function C_SKL_MON_EFT(actor, obj, monName, effectName, eftScale)
	local mon = actor:GetClientMonster():GetClientMonsterByName(monName);
	if mon == nil then
		return;
	end

	mon:GetEffect():PlayEffect(effectName, eftScale, EFTOFFSET_BOTTOM);
end

function C_SET_MOVEANIM(actor, obj, moveAnimName)
	actor:GetAnimation():SetMoveAnimName(moveAnimName);
end

function C_SET_STDANIM(actor, obj, stdAnimName)
	actor:GetAnimation():SetSTDAnim(stdAnimName);
end

function C_RESET_STDANIM(actor)
	actor:GetAnimation():ResetSTDAnim();
end


function C_SKL_CIRCLE_DAMAGE(actor, obj, range, hitType, hitDelay, isKdSafe, sklSR)

	-- hitdelay쓰면 멈춤. 버그있음 일단 0으로 고정.
	actor:DamageByClientDecisionOnCircle(obj.type, range, hitType, 0, isKdSafe, sklSR);
end

function C_SKL_CIRCLE_DAMAGE_SR(actor, obj, range, hitType, hitDelay, isKdSafe)

	-- hitdelay쓰면 멈춤. 버그있음 일단 0으로 고정.
	local sklSR = actor:GetMySkillSR(obj.type);
	if sklSR == 0 then
		return;
	end
	actor:DamageByClientDecisionOnCircle(obj.type, range, hitType, 0, isKdSafe, sklSR);
end

function SKL_FAST_FALL(actor, obj, fallRate)
	actor:SetSpecialFallSpeedRate(fallRate);
end

function SKL_SOARING(actor, obj, spd, height)
	actor:GetHardSkill():Soaring(height, spd);
end

function SKL_C_RESERVE_LANDANIM(actor, skill, animName, spd, freezeAnim, playAnimHeight)
	actor:GetAnimation():ReserveLandAnim(animName, spd, freezeAnim, playAnimHeight);
end