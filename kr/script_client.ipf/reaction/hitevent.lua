

function C_SR_EFT(self, target, sklLevel, hitInfo, hitIndex, eft, scl, x, y, z, lifeTime, delayTime)

	if delayTime == nil then
		delayTime = 0;
	end
	local key = "None"
	local radAngle = 0;
	effect.PlayGroundEffect(self, eft, scl, x, y, z, lifeTime, key, radAngle, delayTime);	
end

function C_SR_EFT2(self, target, sklLevel, hitInfo, hitIndex, effectName,  scale, nodeName, lifeTime)

	if lifeTime == nil then

		lifeTime = 0;

	end

	effect.PlayActorEffect(self, effectName, nodeName, lifeTime, scale);

end

function C_SR_EFT_DEFAULT(self, target, sklLevel, hitInfo, hitIndex, selfEeffectName, selfScale, selfOffset, targetEeffectName, targetScale, targetOffset)
	if selfEeffectName ~= nil and selfEeffectName ~= 'None' and selfEeffectName ~= '' then
		self:GetEffect():PlayEffect(selfEeffectName, selfScale, GetOffsetEnum(selfOffset));
	end
	
	if targetEeffectName ~= nil and targetEeffectName ~= 'None' and targetEeffectName ~= '' then
		local isMyEffect = self:GetHandleVal() == GetMyActor():GetHandleVal();
		local isBoss = false;
		if self:GetObjType() == GT_MONSTER then
			if self.MonRank == "Boss" then
				isBoss = true;
			end
		end
		
		target:GetEffect():PlayEffect(isMyEffect, isBoss, targetEeffectName, targetScale, GetOffsetEnum(targetOffset));
	end
end

function C_SR_SHOCKWAVE(self, target, sklLevel, hitInfo, hitIndex, intensity, time, freq, range)

	if hitIndex ~= 0 then
		return;
	end

	world.ShockWave(target, 2, range, intensity, time, freq, 0);

end

function C_SR_VIBRATE(self, target, sklLevel, hitInfo, hitIndex, delay, time, power, freq)

	target:GetEffect():EnableVibrate(1, time, power, freq, delay);

end

function C_DEADPARTSEFFECT(self, target, sklLevel, hitInfo, hitIndex, eftName, eftSize)

	target:SetDeadPartsInfo(eftName, eftSize);

end

function C_DEADPARTS_DIST(self, target, sklLevel, hitInfo, hitIndex, addDist)

	target:SetDeadPartsAddDist(addDist);

end

function C_SR_SOUND(self, target, sklLevel, hitInfo, hitIndex, soundName)
	target:GetEffect():PlaySound(soundName);

end

--[[
struct HIT_INFO
{
	int				damage;
	int				hp;
	int				hitType;
	int				resultType;
};


]]

-- void ShockWave(CFSMActor* actor = NULL, int type = 2, float range = 999, float intensity = 5, float time = 1, float frequency = 40, float angle = 0);

function HIT_EVENT_FIREBALL(hitInfo, actor, hitIndex)

 -- ¿ⓒ·?¸렸¾?≫ ¶§ ?¸? Lº￥?
	if hitIndex ~= 0 then
		return;
	end
	
	local intensity = 1.3;
	world.ShockWave(actor, 2, 999, intensity, 1, 50, 0);
		
end

function HIT_EVENT_EARTHTREMOR(hitInfo, actor, hitIndex)
	
	if hitIndex ~= 0 then
		return;
	end
	
	local intensity = 4.0;
	world.ShockWave(actor, 2, 700, intensity, 0.7, 45, 0.8);
		
end

function HIT_EVENT_VERTICALBREAK(hitInfo, actor, hitIndex)
	
	if hitIndex ~= 0 then
		return;
	end
	
	local intensity = 5.0;
	world.ShockWave(actor, 2, 999, intensity, 1, 40, 0);
		
end

function HIT_EVENT_INCINERATION(hitInfo, actor, hitIndex)
	
	if hitIndex ~= 0 then
		return;
	end
	
	local intensity = 6.0;
	world.ShockWave(actor, 2, 700, intensity, 0.7, 45, 0.8);
		
end

function HIT_EVENT_Blow(hitInfo, actor, hitIndex)
	
	if hitIndex ~= 0 then
		return;
	end
	
	local intensity = 5.0;
	world.ShockWave(actor, 2, 999, intensity, 1, 40, 0);
		
end

function HIT_EVENT_Bramble_Normal_Attack(hitInfo, actor, hitIndex)

 -- ¿ⓒ·?¸렸¾?≫ ¶§ ?¸? Lº￥?
	if hitIndex ~= 0 then
		return;
	end
	
	local intensity = 5.3;
	world.ShockWave(actor, 2, 999, intensity, 0.5, 70, 0);
		
end

function HIT_EVENT_Dionia_Normal_Attack(hitInfo, actor, hitIndex)

 -- ¿ⓒ·?¸렸¾?≫ ¶§ ?¸? Lº￥?
	if hitIndex ~= 0 then
		return;
	end
	
	local intensity = 5.3;
	world.ShockWave(actor, 2, 999, intensity, 0.5, 70, 0);
		
end

function HIT_EVENT_Molich_Normal_Attack(hitInfo, actor, hitIndex)

 -- ¿ⓒ·?¸렸¾?≫ ¶§ ?¸? Lº￥?
	if hitIndex ~= 0 then
		return;
	end
	
	local intensity = 5.3;
	world.ShockWave(actor, 2, 999, intensity, 0.5, 70, 0);
		
end
--[[function HITEVENT_ICESHATTER(hitInfo, actor, hitIndex)

	actor:GetEffect():EnableVibrate(1, 0.5, 1, 50.0);

end 
]]--


function C_SR_COLORBLEND(self, target, sklLevel, hitInfo, hitIndex, isUse, color_R, color_G, color_B, colar_A, blendOption)

	target:GetEffect():ActorColorBlend(isUse, color_R, color_G, color_B, colar_A, blendOption);
end