-- bokor_shared.lua

function GET_SUMMON_ZOMBIE_NAME(typeNum)

	if typeNum == 2 then
		return 'Zombie_hoplite';
	elseif typeNum == 3 then
		return 'Zombie_Overwatcher';
	end

	return 'summons_zombie';
end

function GET_SUMMON_ZOMBIE_TYPE(typeName)

	if typeName == 'Zombie_hoplite' then
		return 2;
	elseif typeName == 'Zombie_Overwatcher' then
		return 3;
	end

	return 1;
end