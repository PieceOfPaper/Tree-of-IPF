


function GET_GELE_MODELITEM(seedCls, obj)

	local age = obj:GetPropIValue("Age");
	local maxGrowTime = seedCls.FullGrowMin;
	local curState = CLAMP(age / maxGrowTime, 0, 1);
	if curState <= 0.5 then
		return "Default_Sprout";
	end

	return "food_014";

end

function GET_SEED002_MODELITEM(seedCls, obj)

	local age = obj:GetPropIValue("Age");
	local maxGrowTime = seedCls.FullGrowMin;
	local curState = CLAMP(age / maxGrowTime, 0, 1);
	if curState <= 0.5 then
		return "Default_Sprout";
	end

	return "food_007";

end

function GET_SEED003_MODELITEM(seedCls, obj)

	local age = obj:GetPropIValue("Age");
	local maxGrowTime = seedCls.FullGrowMin;
	local curState = CLAMP(age / maxGrowTime, 0, 1);
	if curState <= 0.5 then
		return "Default_Sprout";
	end

	return "food_011";

end

function GET_SEED004_MODELITEM(seedCls, obj)

	local age = obj:GetPropIValue("Age");
	local maxGrowTime = seedCls.FullGrowMin;
	local curState = CLAMP(age / maxGrowTime, 0, 1);
	if curState <= 0.5 then
		return "Default_Sprout";
	end

	return "food_008";

end

function GET_SEED005_MODELITEM(seedCls, obj)

	local age = obj:GetPropIValue("Age");
	local maxGrowTime = seedCls.FullGrowMin;
	local curState = CLAMP(age / maxGrowTime, 0, 1);
	if curState <= 0.5 then
		return "Default_Sprout";
	end

	return "food_009";

end

function GET_SEED006_MODELITEM(seedCls, obj)

	local age = obj:GetPropIValue("Age");
	local maxGrowTime = seedCls.FullGrowMin;
	local curState = CLAMP(age / maxGrowTime, 0, 1);
	if curState <= 0.5 then
		return "Default_Sprout";
	end

	return "food_036";

end

function GET_SEED007_MODELITEM(seedCls, obj)

	local age = obj:GetPropIValue("Age");
	local maxGrowTime = seedCls.FullGrowMin;
	local curState = CLAMP(age / maxGrowTime, 0, 1);
	if curState <= 0.5 then
		return "Default_Sprout";
	end

	return "food_037";

end

function GET_GUILDTOWER_NAME(arg)
	return ScpArgMsg("GuildTower_{Name}", "Name", arg);
end

function GET_GUILD_PET_NAME(seedCls, obj)
	local age = obj:GetPropIValue("Age");
	local maxGrowTime = seedCls.FullGrowMin;
	local curState = CLAMP(age / maxGrowTime, 0, 1);
	local monCls = GetClass("Monster", seedCls.MonsterName);
	local ownerName = obj:GetPropValue("Maker");
	
	local monName;
	if curState < 1 then
		monName = ScpArgMsg("Baby") ..  " " .. monCls.Name;
	else
		monName = monCls.Name;
	end

	return SofS(monName, ownerName);
end

function GET_GUINEA_PIG_TAMING_MODELMON(seedCls, obj)
	local age = obj:GetPropIValue("Age");
	local maxGrowTime = seedCls.FullGrowMin;
	local curState = CLAMP(age / maxGrowTime, 0, 1);
	local monCls = GetClass("Monster", seedCls.MonsterName);
	local ownerName = obj:GetPropValue("Maker");
	
	if curState < 1 then
		return "guineapig_baby";
	else
		return "Guineapig";
	end
end

function GET_LEASSERPANDA_TAMING_MODELMON(seedCls, obj)
	local age = obj:GetPropIValue("Age");
	local maxGrowTime = seedCls.FullGrowMin;
	local curState = CLAMP(age / maxGrowTime, 0, 1);
	local monCls = GetClass("Monster", seedCls.MonsterName);
	local ownerName = obj:GetPropValue("Maker");
	
	if curState < 1 then
		return "Lesser_panda_baby";
	else
		return "Lesser_panda";
	end
end

function GET_PIG_TAMING_MODELMON(seedCls, obj)
	local age = obj:GetPropIValue("Age");
	local maxGrowTime = seedCls.FullGrowMin;
	local curState = CLAMP(age / maxGrowTime, 0, 1);
	local monCls = GetClass("Monster", seedCls.MonsterName);
	local ownerName = obj:GetPropValue("Maker");
	
	if curState < 1 then
		return "Piggy";
	else
		return "Piggy_baby";
	end
end

function GET_TOUCAN_TAMING_MODELMON(seedCls, obj)
	local age = obj:GetPropIValue("Age");
	local maxGrowTime = seedCls.FullGrowMin;
	local curState = CLAMP(age / maxGrowTime, 0, 1);
	local monCls = GetClass("Monster", seedCls.MonsterName);
	local ownerName = obj:GetPropValue("Maker");
	
	if curState < 1 then
		return "Toucan";
	else
		return "Toucan";
	end
end

function GET_BARN_OWL_TAMING_MODELMON(seedCls, obj)
	local age = obj:GetPropIValue("Age");
	local maxGrowTime = seedCls.FullGrowMin;
	local curState = CLAMP(age / maxGrowTime, 0, 1);
	local monCls = GetClass("Monster", seedCls.MonsterName);
	local ownerName = obj:GetPropValue("Maker");
	
	if curState < 1 then
		return "barn_owl";
	else
		return "barn_owl";
	end
end

function GET_GUILD_EXPUP_ITEM_INFO()

	return "misc_talt", 20;

end

function GET_GUILD_LEVEL_BY_EXP(exp)
	local lv = 1;
	local clsList, cnt = GetClassList("GuildExp");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		if exp >= cls.Exp then
			lv = cls.ClassID;
		end
	end
	return lv;

end

function GET_GUILD_ABILITY_POINT(partyObj)

	return partyObj.Level;

end

function GET_GUILD_ABILITY_LEVEL(guildObj, abilName)
	return guildObj["AbilLevel_" .. abilName];
end

function GET_GUILD_MAKE_PRICE()

	return 500000;

end

function GET_REMAIN_TICKET_COUNT(guildObj)
	local guildLevel = guildObj.Level;
	return guildLevel - guildObj.UsedTicketCount;
end



