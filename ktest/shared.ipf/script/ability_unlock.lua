-- ability_unlock.lua

function UNLOCK_ABIL_CIRCLE(pc, jobName, limitLevel, abilIES)

	local jobGrade = GetJobGradeByName(pc, jobName);
	if jobGrade >= limitLevel then
		return "UNLOCK";
	end

	return "LOCK_GRADE";
end

function UNLOCK_ABIL_SKILL(pc, sklName, limitLevel, abilIES)

	local skl = GetSkill(pc, sklName)
	if skl ~= nil and skl.LevelByDB >= limitLevel then
		return "UNLOCK";
	end

	return "LOCK_GRADE";
	
end

function UNLOCK_ABIL_LEVEL(pc, pcLevel, levelFix, abilIES)

	local abilLv = levelFix;
	if abilIES ~= nil then
		abilLv = abilLv + abilIES.Level;
	end

	if pc.Lv >= abilLv then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
	
end

function UNLOCK_ABIL_RANK(pc, strarg, limitRank, abilIES)

    local rank = GetTotalJobCount(pc);
	if rank >= limitRank then
		return "UNLOCK";
	end

	return "LOCK_GRADE";

end

function UNLOCK_PRIEST21(pc, sklName, limitLevel, abilIES)

	local jobGrade = GetJobGradeByName(pc, 'Char4_2');
	local skl = GetSkill(pc, sklName)
	if skl ~= nil and skl.LevelByDB >= limitLevel and jobGrade ~= nil and jobGrade >= 2 then
		return "UNLOCK";
	end

	return "LOCK_GRADE";

end

function UNLOCK_FEATHERFOOT_BLOOD(pc, sklName, limitLevel, abilIES)

	local bloodbathSkl = GetSkill(pc, "Featherfoot_BloodBath")
	local bloodsuckingSkl = GetSkill(pc, "Featherfoot_BloodSucking")
	if bloodbathSkl ~= nil and bloodbathSkl.LevelByDB >= limitLevel and bloodsuckingSkl ~= nil and bloodsuckingSkl.LevelByDB >= limitLevel then
		return "UNLOCK";
	end

	return "LOCK_GRADE";

end

function UNLOCK_MUSKETEER15(pc, sklName, limitLevel, abilIES)

	local jobGrade = GetJobGradeByName(pc, 'Char3_16');
	local skl = GetSkill(pc, sklName)
	if skl ~= nil and skl.LevelByDB >= 1 and jobGrade ~= nil and jobGrade >= 2 then
		return "UNLOCK";
	end

	return "LOCK_GRADE";

end

function UNLOCK_ELEMENTALIST25(pc, sklName, limitLevel, abilIES)

	local jobGrade = GetJobGradeByName(pc, 'Char2_11');
	local skl = GetSkill(pc, "Elementalist_Meteor")
	if skl ~= nil and skl.LevelByDB >= 10 and jobGrade ~= nil and jobGrade >= 3 then
		return "UNLOCK";
	end

	return "LOCK_GRADE";

end

function UNLOCK_FALCONER20(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char3_14');
	local sklCalling = GetSkill(pc, "Falconer_Calling")
	local sklBuildRoost = GetSkill(pc, "Falconer_BuildRoost")
	if sklCalling ~= nil and sklBuildRoost ~= nil and sklCalling.LevelByDB >= 1 and sklBuildRoost.LevelByDB >= 1 and jobGrade ~= nil and jobGrade >= 3 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end
