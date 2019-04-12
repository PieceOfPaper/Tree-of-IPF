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

	retList[#retList + 1] = "Rodelero_ShieldBash";
	return retList;

end
