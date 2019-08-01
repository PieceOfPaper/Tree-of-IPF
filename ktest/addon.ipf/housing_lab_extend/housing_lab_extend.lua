function HOUSING_LAB_EXTEND_ON_INIT(addon, frame)
	addon:RegisterMsg("HOUSING_LAB_EXTEND_OPEN", "ON_HOUSING_LAB_EXTEND_OPEN");
	addon:RegisterMsg("RECEIVE_HOUSING_LAB_EXTEND_WEAPON", "HOUSING_LAB_EXTEND_WEAPON");
	addon:RegisterMsg("RECEIVE_HOUSING_LAB_EXTEND_ARMOR", "HOUSING_LAB_EXTEND_ARMOR");
	addon:RegisterMsg("RECEIVE_HOUSING_LAB_EXTEND_ATTRIBUTE", "HOUSING_LAB_EXTEND_ATTRIBUTE");
	addon:RegisterMsg("RECEIVE_HOUSING_LAB_EXTEND_PRODUCTION", "HOUSING_LAB_EXTEND_PRODUCTION");
end

function ON_HOUSING_LAB_EXTEND_OPEN(labName)	
	local func;
	if labName == tos.housing.guild.lua.ToStringLab(tos.housing.guild.eWeapon) then
		func = "REQUEST_HOUSING_LAB_EXTEND_OPEN_WEAPON";
	elseif labName == tos.housing.guild.lua.ToStringLab(tos.housing.guild.eArmor) then
		func = "REQUEST_HOUSING_LAB_EXTEND_OPEN_ARMOR";
	elseif labName == tos.housing.guild.lua.ToStringLab(tos.housing.guild.eAttribute) then
		func = "REQUEST_HOUSING_LAB_EXTEND_OPEN_ATTRIBUTE";
	elseif labName == "Production" then
		func = "REQUEST_HOUSING_LAB_EXTEND_OPEN_PRODUCTION"
	else
		return
	end
	
    control.CustomCommand("REQ_GUILD_MILEAGE_AMOUNT", 0);
	session.party.ReqGuildAsset();

	AddLuaTimerFunc(func, 500, 0);
end

function REQUEST_HOUSING_LAB_EXTEND_OPEN_WEAPON()
	housing.RequestGuildAgitInfo("RECEIVE_HOUSING_LAB_EXTEND_WEAPON");
end

function REQUEST_HOUSING_LAB_EXTEND_OPEN_ARMOR()
	housing.RequestGuildAgitInfo("RECEIVE_HOUSING_LAB_EXTEND_ARMOR");
end

function REQUEST_HOUSING_LAB_EXTEND_OPEN_ATTRIBUTE()
	housing.RequestGuildAgitInfo("RECEIVE_HOUSING_LAB_EXTEND_ATTRIBUTE");
end

function REQUEST_HOUSING_LAB_EXTEND_OPEN_PRODUCTION()
	housing.RequestGuildAgitInfo("RECEIVE_HOUSING_LAB_EXTEND_PRODUCTION");
end

function SET_HOUSING_LAB_EXTEND(guildAgit, labName, level, extensionName)
	if level >= 5 then
		ui.MsgBox(ClMsg("MaxSkillLevel"));
		return;
	end

	local beforeLevelName = extensionName .. tostring(level);
	local afterLevelName = extensionName .. tostring(level + 1);

	local class_before = GetClass("guild_housing", beforeLevelName);
	local class_after = GetClass("guild_housing", afterLevelName);

	if class_before == nil or class_after == nil then
		return;
	end

	ui.OpenFrame("housing_lab_extend");
	local frame = ui.GetFrame("housing_lab_extend");

	frame:SetUserValue("LabType", labName);
	
	local mileage = 0;
	local guild = session.party.GetPartyInfo(PARTY_GUILD);
	if guild ~= nil then
		mileage = guild.info:GetMileage();
	end

	local assetAmount = guild.info:GetAssetAmount();
	
	local beforeMaxLevel = TryGetProp(class_before, "MaxPointByExtensionLevel", 0);
	local afterMaxLevel = TryGetProp(class_after, "MaxPointByExtensionLevel", 0);

	local name = ClMsg("Housing_" .. labName .. "Lab");

	local txt_lab_before_name = GET_CHILD_RECURSIVELY(frame, "txt_lab_before_name");
	txt_lab_before_name:SetTextByKey("name", name);
	txt_lab_before_name:SetTextByKey("level", level);

	local txt_lab_before_memo = GET_CHILD_RECURSIVELY(frame, "txt_lab_before_memo");
	txt_lab_before_memo:SetTextByKey("level", beforeMaxLevel);

	local txt_lab_after_name = GET_CHILD_RECURSIVELY(frame, "txt_lab_after_name");
	txt_lab_after_name:SetTextByKey("name", name);
	txt_lab_after_name:SetTextByKey("level", level + 1);
	
	local txt_lab_after_memo = GET_CHILD_RECURSIVELY(frame, "txt_lab_after_memo");
	txt_lab_after_memo:SetTextByKey("level", afterMaxLevel);

	local txt_has_guild_money = GET_CHILD_RECURSIVELY(frame, "txt_has_guild_money");
	txt_has_guild_money:SetTextByKey("money", GET_COMMAED_STRING(assetAmount));

	local txt_need_guild_money = GET_CHILD_RECURSIVELY(frame, "txt_need_guild_money");
	txt_need_guild_money:SetTextByKey("money", GET_COMMAED_STRING(TryGetProp(class_after, "ExtensionNeedSilver", 0)));

	local txt_has_guild_mileage = GET_CHILD_RECURSIVELY(frame, "txt_has_guild_mileage");
	txt_has_guild_mileage:SetTextByKey("mileage", GET_COMMAED_STRING(mileage));

	local txt_need_guild_mileage = GET_CHILD_RECURSIVELY(frame, "txt_need_guild_mileage");
	txt_need_guild_mileage:SetTextByKey("mileage", GET_COMMAED_STRING(TryGetProp(class_after, "ExtensionNeedMileage", 0)));
end

function HOUSING_LAB_EXTEND_WEAPON()
	local guildAgit = housing.GetGuildAgitInfo();
	if guildAgit == nil then
		return;
	end

	local labName = tos.housing.guild.lua.ToStringLab(tos.housing.guild.eWeapon);
	local level = guildAgit.labLevels[tos.housing.guild.lua.ToLabType(labName) + 1];
	SET_HOUSING_LAB_EXTEND(guildAgit, labName, level, "guild_weapon_lab_extension");
end

function HOUSING_LAB_EXTEND_ARMOR()
	local guildAgit = housing.GetGuildAgitInfo();
	if guildAgit == nil then
		return;
	end

	local labName = tos.housing.guild.lua.ToStringLab(tos.housing.guild.eArmor);
	local level = guildAgit.labLevels[tos.housing.guild.eArmor + 1];
	SET_HOUSING_LAB_EXTEND(guildAgit, labName, level, "guild_armor_lab_extension");
end

function HOUSING_LAB_EXTEND_ATTRIBUTE()
	local guildAgit = housing.GetGuildAgitInfo();
	if guildAgit == nil then
		return;
	end

	local labName = tos.housing.guild.lua.ToStringLab(tos.housing.guild.eAttribute);
	local level = guildAgit.labLevels[tos.housing.guild.eAttribute + 1];
	SET_HOUSING_LAB_EXTEND(guildAgit, labName, level, "guild_attribute_lab_extension");
end

function HOUSING_LAB_EXTEND_PRODUCTION()
	local guildAgit = housing.GetGuildAgitInfo();
	if guildAgit == nil then
		return;
	end

	SET_HOUSING_LAB_EXTEND(guildAgit, "Production", guildAgit.productionLevel, "guild_manufacture_workshop_extension");
end

function BTN_HOUSING_LAB_EXTEND_YES(gbox, btn)
	local frame = btn:GetTopParentFrame();
	local labName = frame:GetUserValue("LabType");
	if labName == "Production" then
		housing.RequestGuildProductionLevelUp();
	else
		housing.RequestGuildLabLevelUp(labName);
	end
	ui.CloseFrame("housing_lab_extend");
end

function BTN_HOUSING_LAB_EXTEND_NO(gbox, btn)
	ui.CloseFrame("housing_lab_extend");
end