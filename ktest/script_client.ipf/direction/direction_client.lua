

function DRT_C_PLAY_ANIM(actor, cmd, animName, fixAnim, duplicationPlay, delayTime, passedTime)

	if fixAnim == nil then
		fixAnim = 1;
	end
	if delayTime == nil then
		delayTime = 0.0;
	end
	
	local skipIfExist = 0;
	if duplicationPlay == 0 then
		skipIfExist = 1;
	end

	local startTime = 0;
	if passedTime ~= nil and passedTime > 0.0 then
		startTime = passedTime;
	end

	actor:GetAnimation():PlayFixAnim(animName, 1.0, fixAnim, 1, delayTime, skipIfExist, false, startTime);
end

function DRT_C_PLAY_ANIM_R(actor, cmd, ani1, ani2, ani3, fixAnim, duplicationPlay, delayTime)

	if ani2 == "" then
		DRT_C_PLAY_ANIM(actor, cmd, ani1, fixAnim, duplicationPlay, delayTime);
	elseif ani3 == "" then
		if IMCRandom(1, 2) == 1 then
			DRT_C_PLAY_ANIM(actor, cmd, ani1, fixAnim, duplicationPlay, delayTime);
		else
			DRT_C_PLAY_ANIM(actor, cmd, ani2, fixAnim, duplicationPlay, delayTime);
		end
	else
		local animName = "";
		local randValue = IMCRandom(1, 3);
		if randValue == 1 then
			animName = ani1;
		elseif randValue == 2 then
			animName = ani2;
		else
			animName = ani3;
		end

		DRT_C_PLAY_ANIM(actor, cmd, animName, fixAnim, duplicationPlay, delayTime);
	end
end

function DRT_C_PLAY_SKL_ANI(actor, cmd, targetHandle, skl, afterAnim)
	direct.PlaySkillAni(actor:GetHandleVal(), targetHandle, skl, afterAnim);
end

function DRT_CHAT_RUN_C(actor, cmd, chat, time)
	if time == nil then
		time = 2.0;
	end

	actor:GetTitle():Say(chat, time);
end

function DRT_SET_FACE_C(actor, cmd, state)
	actor:SetFaceState(state);
end

function DRT_C_CHANGE_CAM(actor, cmd, type, x, y, z, cameratime, motionratio)
	camera.ChangeCamera(1, 0, x, y, z, cameratime, motionratio, 0);
end

function DRT_C_TARGET_CAM(actor, cmd, tgtHandle, spd, accel)
	camera.ChangeCamera(2, tgtHandle, 0, 0, 0, 1, 0, 0);
end

function DRT_C_TARGET_CAM_BYTIME(actor, cmd, tgtHandle, time, easing)
	camera.ChangeCamera(2, tgtHandle, 0, 0, 0, time, easing, 1);
end

function DRT_C_SHOCKWAVE(actor, cmd, type, range, intensity, time, freq, angle)
	world.ShockWave(actor, type, range, intensity, time, freq, angle);
end

function DRT_C_CAM_ZOOM_NEW(actor, cmd, dist, time, easing)
	
	if false == cmd:UseCameraZoom() then
		return;
	end
	
	camera.CustomZoom(dist, time, easing);
end

function DRT_C_CAM_ZOOM(actor, cmd, index, time, easing)
	camera.ChangeCameraZoom(2, index, time, easing);
end

function DRT_C_CAM_FOV(actor, cmd, fov)
	camera.ChangeFov(fov);
end

function DRT_C_CHANGE_WORLD(actor, cmd, mapName)
	cmd:ChangeClientWorld(mapName);
end

function DRT_RUN_OTHER_DIRECTION(actor, cmd, mapName)
	cmd:RunOtherDirection(mapName);
end

function DRT_PLAY_EFT_C(pc, cmd, eftName, scl, x, y, z, lifeTime, delay)
	effect.PlayGroundEffect(pc, eftName, scl, x, y, z, lifeTime, "None", 0.0, delay);
end


function DRT_C_PLAYSOUND(actor, cmd, soundName, enableSkip)
	if enableSkip == nil then
		enableSkip = 0;
	end

	movie.PlayCenterSound(soundName);
	if enableSkip == 1 then
		cmd:EnableSkipSound(soundName);
	end
end

function DRT_C_FADEOUT(actor, cmd, isOut)
	ui.UIOpenByPacket("fullblack", isOut);
	ui.CloseUICmdByTime("fullblack", 0.5);	
end

function DRT_C_FADEOUT_TIME(actor, cmd, isOut, time)
    if time == nil or time == 0 then
        time = 1
    end
	ui.UIOpenByPacket("fullblack", isOut);
	ui.CloseUICmdByTime("fullblack", time);	
end



function DRT_KNOCKBACK_RUN_C(self, cmd, fromHandle, power, hAngle, vAngle, kdCount, speed, verticalPow)	
	self:KnockDown_C(fromHandle, power, hAngle, vAngle, kdCount, speed, verticalPow);
end

function DRT_JUMP_TO_POS_C(self, cmd, x, y, z, moveTime, jumpPower)
	self:ActorJump(jumpPower, 0);
	self:MoveMathPoint(x, y, z, moveTime, 1.0);
end

function DRT_KNOCKB_RUN_C(self, cmd, fromHandle, power, hAngle, vAngle, speed)	
	self:KnockBack_C(fromHandle, power, hAngle, vAngle, speed);
end

function DRT_CHANGE_COLOR_C(self, cmd, red, green, blue, alpha, isSwitch, blendTime)
	if blendTime == nil then 
		blendTime = 0.0; 
	end

	if isSwitch == nil or isSwitch == 0 then
		isSwitch = false;
	else
		isSwitch = true;
	end
	
	self:GetEffect():SetColorBlend('packetBlend', red, green, blue, alpha, isSwitch, blendTime);
end


function DRT_CHANGE_COLOR_OPT_C(self, cmd, s_red, s_green, s_blue, s_alpha, e_red, e_green, e_blue, e_alpha, blendtime)
    if blendTime == nil then 
        blendTime = 0.0; 
    end

    self:GetEffect():SetColorBlend('packetBlend', s_red, s_green, s_blue, s_alpha, true, 0);
    self:GetEffect():SetColorBlend('packetBlend', e_red, e_green, e_blue, e_alpha, true, blendtime);

end



function DRT_ALPHA_NPC_C(self, cmd, kill, aniname, s_red, s_green, s_blue, s_alpha, e_red, e_green, e_blue, e_alpha, blendtime)
    if blendTime == nil then 
        blendTime = 0.0; 
    end
    
	if aniname == nil then
	    aniname = 'STD'
	end
	
    self:GetAnimation():PlayFixAnim(aniname, 1.0, 1, 1);	
    self:GetEffect():SetColorBlend('packetBlend', s_red, s_green, s_blue, s_alpha, true, 0);
    self:GetEffect():SetColorBlend('packetBlend', e_red, e_green, e_blue, e_alpha, true, blendtime)
	--world.Leave(self:GetHandleVal(), 3.0);
	if kill == 2 then
    	world.DelayLeave(self:GetHandleVal(), blendtime);
    end
end

function DRT_KILL_C(self)
	world.Leave(self:GetHandleVal(), 0.0);
end

function DRT_DEAD_C(self)
	world.Dead(self:GetHandleVal());
end

function DRT_LOOKAT_C(self, cmd, targetHandle)
	local tgt = world.GetActor(targetHandle);
	if tgt ~= nil then
	    self:RotateToTarget(tgt, 0.0);
	end
end

function DRT_CHANGESCALE_OBJ_C(self, cmd, scale, blendTime)
	self:ChangeScale(scale, blendTime);
end


function DRT_ACTOR_PLAY_EFT_C(actor, cmd, eftName, scl, hOffset)
	actor:GetEffect():PlayEffect(eftName, scl, GetOffsetEnum(hOffset));
end

function DRT_ACTOR_NODE_PLAY_EFT_C(actor, cmd, eft, eftScale, nodeName)
	effect.PlayActorEffect(actor, eft, nodeName, 0.0, eftScale);
end

function DRT_C_CLEAR_EFT(self)
	self:GetEffect():StopAllEffect(1, 0.5);
end

function DRT_C_REMOVE_EFT(self, cmd, eftName, forceDestroy, blendTime)
	self:GetEffect():RemoveEffect(eftName, forceDestroy, blendTime);
end

function DRT_MOVE_TO_TARGET_C(self, cmd, tgtHandle, range, mspd)
	if mspd == nil then
		mspd = 0.0;
	end
	direct.MoveToTarget(self:GetHandleVal(), tgtHandle, range, mspd);
end


function DRT_C_GOTO_BARRACK(self)
	if GetBarrackPub():IsEnablePlayOpening() == 1 then
		GetBarrackPub():PlayOpening(true);
	else
		GetBarrackPub():GoToBarrack();
	end
end


function END_OPENING(actor, cmd)
	GetBarrackPub():PlayOpening(false);
	GetBarrackPub():GoToBarrack();
end


function DRT_SHAKE_C(self, cmd, time, power, freq, verticalSpeed)
    self:GetEffect():EnableVibrate(time, power, freq, verticalSpeed)

end

function DRT_ATTACH_TO_TARGET_C(self, cmd, tgtHandle, node, animName)
	direct.AttachToObject(self, tgtHandle, node, animName);
end

function DRT_DETACH_FROM_ALL(self, cmd, tgtHandle, node, animName)
	self:DetachAll();
end

function DRT_MOVE_BY_WMOVE_C(self, cmd, fileName)
	geClientWorldMoveByFile.RunFileMove(self, fileName);
end

g_cmdGuid = 0;

function RESUME_CLIENT_DIRECTION()
	
	local cmd = geClientDirection.GetDirectionCmdByGuid(g_cmdGuid);
	if cmd == nil then
		return;
	end

	cmd:ResumeDirection();

end

function DRT_OK_DLG_CLIENT(actor, cmd, dlg)
	if IsToolMode() == false then
		g_cmdGuid = cmd:GetGuid();
		cmd:PauseDirection();
		addon.BroadMsg("DIALOG_CHANGE_OK", dlg, 0);
		local frame = ui.GetFrame("dialog");
		frame:SetUserValue("DIALOGOKSCRIPT", "RESUME_CLIENT_DIRECTION");
	end

end

function DRT_ACTOR_ATTACH_EFFECT_CLIENT(actor, cmd, eftName, scl, hOffset)
	effect.AddActorEffectByOffset(actor, eftName, scl, hOffset);
end


function DRT_C_HIDE_MY_CHAR(pc, cmd, isHide)
	if isHide == 0 then
		movie.ShowModel(pc:GetHandleVal(), 1)
	else
		movie.ShowModel(pc:GetHandleVal(), 0)
	end;
	
end
function DRT_FUNC_RUNSCRIPT_C(pc, cmd, funcName)
	local func = _G[funcName];
	func(pc ,cmd);
end
