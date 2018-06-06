--- skillshared.lua

function SKILL_TARGET_ITEM_Swordman_Thrust(obj)
	
		
	return 1;	
end

function GET_NINJA_SKILLS()

	local retList = {};
	retList[#retList + 1] = "Shinobi_Kunai";
	retList[#retList + 1] = "Shinobi_Mijin_no_jutsu";
	retList[#retList + 1] = "Swordman_Thrust";
	retList[#retList + 1] = "Swordman_Bash";
	retList[#retList + 1] = "Swordman_DoubleSlash";
	retList[#retList + 1] = "Swordman_PommelBeat";
	return retList;

end
