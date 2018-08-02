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

function UNLOCK_SORCERER16(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char2_6');
	local sklSummoning = GetSkill(pc, "Sorcerer_Summoning")
	if sklSummoning ~= nil and sklSummoning.LevelByDB >= 11 and jobGrade ~= nil and jobGrade >= 3 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end


function UNLOCK_NECROMANCER24(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char2_9');
	local sklEnchantFire = GetSkill(pc, "Pyromancer_EnchantFire")
	if sklEnchantFire ~= nil and sklEnchantFire.LevelByDB >= 6 and jobGrade ~= nil and jobGrade >= 2 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end


function UNLOCK_NECROMANCER25(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char2_9');
	local sklIceBolt = GetSkill(pc, "Cryomancer_IceBolt")
	if sklIceBolt ~= nil and sklIceBolt.LevelByDB >= 6 and jobGrade ~= nil and jobGrade >= 3 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end

function UNLOCK_PELTASTA30(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char1_3');
	local sklIceBolt = GetSkill(pc, "Peltasta_SwashBuckling")
	if sklIceBolt ~= nil and sklIceBolt.LevelByDB >= 6 and jobGrade ~= nil and jobGrade >= 2 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end

function UNLOCK_WIZARD25(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char2_1');
	local skillSleep = GetSkill(pc, "Wizard_Sleep")
	if skillSleep ~= nil and skillSleep.LevelByDB >= 6 and jobGrade ~= nil and jobGrade >= 2 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end

function UNLOCK_ONMYOJI8(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char2_20');
	local skillWhiteTigerHowling = GetSkill(pc, "Onmyoji_WhiteTigerHowling")
	if skillWhiteTigerHowling ~= nil and skillWhiteTigerHowling.LevelByDB >= 6 and jobGrade ~= nil and jobGrade >= 2 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end

function UNLOCK_ONMYOJI17(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char2_20');
	local skillFireFoxShikigami = GetSkill(pc, "Onmyoji_FireFoxShikigami")
	if skillFireFoxShikigami ~= nil and skillFireFoxShikigami.LevelByDB >= 6 and jobGrade ~= nil and jobGrade >= 2 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end

function UNLOCK_ONMYOJI18(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char2_20');
	local skillFireFoxShikigami = GetSkill(pc, "Onmyoji_FireFoxShikigami")
	if skillFireFoxShikigami ~= nil and skillFireFoxShikigami.LevelByDB >= 6 and jobGrade ~= nil and jobGrade >= 2 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end

function UNLOCK_PELTASTA33(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char1_3');
	local skillGuardian = GetSkill(pc, "Peltasta_Guardian")
	if skillGuardian ~= nil and skillGuardian.LevelByDB >= 6 and jobGrade ~= nil and jobGrade >= 2 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end

function UNLOCK_PELTASTA34(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char1_3');
	local skillGuardian = GetSkill(pc, "Peltasta_Guardian")
	if skillGuardian ~= nil and skillGuardian.LevelByDB >= 11 and jobGrade ~= nil and jobGrade >= 3 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end

function UNLOCK_LANCER14(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char1_17');
	local skillPrevent = GetSkill(pc, "Rancer_Prevent")
	if skillPrevent ~= nil and skillPrevent.LevelByDB >= 6 and jobGrade ~= nil and jobGrade >= 3 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end

function UNLOCK_LANCER_RHONGOMIANT(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char1_17');
	local skillChage = GetSkill(pc, "Rancer_Chage")
	if skillChage ~= nil and skillChage.LevelByDB >= 6 and jobGrade ~= nil and jobGrade >= 3 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end

function UNLOCK_HACKAPELL14(pc, abilName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char3_7');
	local skillCavalry = GetSkill(pc, "Hackapell_CavalryCharge")
	if skillCavalry ~= nil and skillCavalry.LevelByDB >= 1 and jobGrade ~= nil and jobGrade >= 3 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end

function UNLOCK_ONMYOJI10(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char2_20');
	local skillWaterShikigami = GetSkill(pc, "Onmyoji_WaterShikigami")
	if skillWaterShikigami ~= nil and skillWaterShikigami.LevelByDB >= 11 and jobGrade ~= nil and jobGrade >= 3 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end

function UNLOCK_LANCER17(pc, sklName, limitLevel, abilIES)
	local jobGrade = GetJobGradeByName(pc, 'Char1_17');
	local skillSpillAttack = GetSkill(pc, "Rancer_SpillAttack")
	if skillSpillAttack ~= nil and skillSpillAttack.LevelByDB >= 6 and jobGrade ~= nil and jobGrade >= 3 then
		return "UNLOCK";
	end
	
	return "LOCK_GRADE";
end
