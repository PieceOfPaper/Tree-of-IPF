--- mcc_ai.lua
function MCC_SCRIPT(actor, mccIndex)

	local myActor = GetMyActor();
	local forpos = actor:GetFormationPos(-1, 25.0);
	local distFromActor = imcMath.Vec3Dist(actor:GetPos(), myActor:GetPos());
	local tgt = geMCC.GetLastAttackObject(5.0);
	if tgt ~= nil then
		if distFromActor <= 80 then
			local skillType = geMCC.GetRandomSkill(actor);	
			MCC_ATTACK_ACTOR(actor, tgt, skillType);
		else
			geMCC.MoveTo(actor, forpos);
		end
	else
		if distFromActor >= 50 then
			geMCC.MoveTo(actor, forpos);
		end
	end
end

function MCC_ATTACK_ACTOR(actor, tgt, skillType)
	
	if tgt == nil then
		geMCC.UseSkill(actor, tgt, skillType);
		return;
	end
	
	local isAble = geMCC.IsAbleToUseSkill(actor, tgt, skillType);
	if 0 == isAble then
		local sklUsePos = geMCC.GetSkillUsablePos(actor, tgt, skillType);
		geMCC.MoveTo(actor, sklUsePos);
	else
		geMCC.UseSkill(actor, tgt, skillType);
	end

end

function MCC_SCRIPT_NINJA(actor, mccIndex)

	if actor:IsSkillState() == true then
		return;
	end

	local myActor = GetMyActor();
	if myActor:IsSkillState() == true then

		local skillID = myActor:GetUseSkill();
		local sklName = GetClassByType("Skill", skillID).ClassName;
		local skills = GET_NINJA_SKILLS();
		local useSkill = false;
		for i = 1 , #skills do
			local ninjaSklName = skills[i];
			if ninjaSklName == sklName then
				useSkill = true;
			end
		end

		if false == useSkill then
			local sklProp = geSkillTable.Get(sklName);
			if sklProp.isNormalAttack then
				useSkill = true;
			end
		end

		if useSkill == true then
		
			local tgt = geMCC.GetLastAttackObject(5.0);
			geMCC.UseSkill(actor, tgt, skillID);
			return;
		end
	end


	local forpos = actor:GetFormationPos(mccIndex, 25.0);			
	local distFromActor = imcMath.Vec3Dist(actor:GetPos(), myActor:GetPos());
	if distFromActor >= 30 then
		geMCC.MoveTo(actor, forpos);
	end
end

function MCC_SCRIPT_MCC(actor, mccIndex)

	local myActor = GetMyActor();
	local forpos = actor:GetMCCPos(mccIndex, 25.0);			
	local distFromActor = imcMath.Vec3Dist(actor:GetPos(), forpos);
	local tgt = geMCC.GetLastAttackObject(5.0);
	if tgt ~= nil then
		if distFromActor <= 80 then
			local skillType = geMCC.GetRandomSkill(actor);	
			MCC_ATTACK_ACTOR(actor, tgt, skillType);
		else
			geMCC.MoveTo(actor, forpos);
		end
	else
		if distFromActor >= 10 then
			geMCC.MoveTo(actor, forpos);
		end
	end
end

