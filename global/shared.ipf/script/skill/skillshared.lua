--- skillshared.lua

function SKILL_TARGET_ITEM_Swordman_Thrust(obj)
	
		
	return 1;	
end

function GET_NINJA_SKILLS()

	local retList = {};
	retList[#retList + 1] = "Shinobi_Kunai";
	retList[#retList + 1] = "Swordman_Thrust";
	retList[#retList + 1] = "Swordman_Bash";
	retList[#retList + 1] = "Swordman_DoubleSlash";
	retList[#retList + 1] = "Swordman_PommelBeat";
	retList[#retList + 1] = "Peltasta_UmboBlow";
	retList[#retList + 1] = "Peltasta_RimBlow";
	retList[#retList + 1] = "Highlander_Crown";
	retList[#retList + 1] = "Highlander_Moulinet";
	retList[#retList + 1] = "Hoplite_SynchroThrusting";
	retList[#retList + 1] = "Rodelero_ShootingStar";
	retList[#retList + 1] = "Rodelero_ShieldBash";
	return retList;

end

function GET_HOMUNCULUS_SKILLS()

	local retList = {};
	retList[#retList + 1] = "Wizard_Sleep";
	retList[#retList + 1] = "Wizard_Lethargy";
	retList[#retList + 1] = "Wizard_MagicMissile";
	retList[#retList + 1] = "Pyromancer_FireBall";
	retList[#retList + 1] = "Pyromancer_EnchantFire";
	retList[#retList + 1] = "Pyromancer_FirePillar";
	retList[#retList + 1] = "Cryomancer_IceBolt";	
	retList[#retList + 1] = "Cryomancer_IceWall";
	retList[#retList + 1] = "Cryomancer_IciclePike";
	retList[#retList + 1] = "Cryomancer_SubzeroShield";
	retList[#retList + 1] = "Cryomancer_Gust";
	retList[#retList + 1] = "Linker_JointPenalty";
	retList[#retList + 1] = "Linker_Physicallink";
	retList[#retList + 1] = "Psychokino_Swap";
	retList[#retList + 1] = "Psychokino_Teleportation";
	retList[#retList + 1] = "Psychokino_Raise";
	retList[#retList + 1] = "Psychokino_MagneticForce";
	retList[#retList + 1] = "Elementalist_StoneCurse";
	retList[#retList + 1] = "Elementalist_Rain";
	retList[#retList + 1] = "Chronomancer_Quicken";
	retList[#retList + 1] = "Chronomancer_Slow";
	retList[#retList + 1] = "Chronomancer_Stop";
	retList[#retList + 1] = "Thaumaturge_ShrinkBody";
	retList[#retList + 1] = "Thaumaturge_SwellBody";
	
	return retList;

end

function GET_ENCHANTARMOR_OPTION(sklLv)

	local retList = {};
	retList[#retList + 1] = "ENCHANTARMOR_SOLID";
	retList[#retList + 1] = "ENCHANTARMOR_HEALING";
	retList[#retList + 1] = "ENCHANTARMOR_PROTECTIVE";
	retList[#retList + 1] = "ENCHANTARMOR_BLESSING";
	retList[#retList + 1] = "ENCHANTARMOR_HOLY";
	retList[#retList + 1] = "ENCHANTARMOR_VOLITIVE";
	local maxCnt = math.min(sklLv+1, 6);
	local tempList = {}
	for i = 1, maxCnt do
		tempList[i] = retList[i];
	end

	return tempList;
end

function SAGE_PORTAL_SKL_PORTAL_COOLTIME(skill)
	return 1800 - (skill.Level - 1) * 60;
end

function GET_TEMPLAR_GUILD_SKIL_LIST()
	local sklList = {"Templer_BuildForge", "Templer_BuildShieldCharger"};

	return sklList;
end

function HAS_GUILDGROWTH_SKL_OBJ(guildObj, sklName, sklLv)

	local objName = 'None'
	if string.find(sklName, 'Forge') ~= nil then
		objName = 'Forge_';
	elseif string.find(sklName, 'ShieldCharger') ~= nil then
		objName = 'ShieldCharger_';
	end

	if objName == 'None' then
		return false;
	end

	local objCount = 0;
	local propName = 'BuildingLife_'..objName;
	for i = 1, 5 do
		local propValue = TryGetProp(guildObj, propName..i);
		if nil == propValue then
			return false;
		end

		if propValue ~= 'None' then
			objCount = objCount + 1;
		end
	end
	
	if sklLv < objCount then
		return false;
	end

	return true;
end