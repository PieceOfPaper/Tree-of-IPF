function GUILD_AGIT_INFO_INIT(parent, infoBox)
    local txt_my_contribution = GET_CHILD_RECURSIVELY(infoBox, 'txt_my_contribution');
	txt_my_contribution:SetTextByKey("value", GET_COMMAED_STRING(GET_MY_CONTRIBUTION()));
    control.CustomCommand("REQ_GUILD_MILEAGE_AMOUNT", 0);
	
	housing.RequestGuildAgitInfo("RECEIVE_GUILD_AGIT_INFO");
	INIT_GUILD_AGIT_FACILITY_INFO();
end

function RESET_GUILD_AGIT_FACILITY_INFO()
	housing.RequestGuildAgitInfo("RECEIVE_GUILD_AGIT_INFO");
	INIT_GUILD_AGIT_FACILITY_INFO();
end

function INIT_GUILD_AGIT_FACILITY_INFO()
	local extensionLevel = 1;

	local productionLevel = 0;
	local weaponResearchLevel = 0;
	local armorResearchLevel = 0;
	local attributeResearchLevel = 0;

	local housingPoint_Originality = 0;		-- 독창성
	local housingPoint_Functionality = 0;	-- 기능성
	local housingPoint_Artistry = 0;		-- 예술성
	local housingPoint_Economy = 0;			-- 경제성

	local guildAgit = housing.GetGuildAgitInfo();
	if guildAgit ~= nil then
		extensionLevel = guildAgit.extensionLevel;

		productionLevel = guildAgit.productionLevel;
		weaponResearchLevel = guildAgit.labLevels[tos.housing.guild.eWeapon + 1];
		armorResearchLevel = guildAgit.labLevels[tos.housing.guild.eArmor + 1];
		attributeResearchLevel = guildAgit.labLevels[tos.housing.guild.eAttribute + 1];

		housingPoint_Originality = guildAgit.points[tos.housing.guild.eOriginality + 1];		-- 독창성
		housingPoint_Functionality = guildAgit.points[tos.housing.guild.eFunctionality + 1];	-- 기능성
		housingPoint_Artistry = guildAgit.points[tos.housing.guild.eArtistry + 1];				-- 예술성
		housingPoint_Economy = guildAgit.points[tos.housing.guild.eEconomy + 1];				-- 경제성
	end

	local frame = ui.GetFrame("guildinfo");
	if frame == nil then
		return;
	end

	local infoBox = GET_CHILD_RECURSIVELY(frame, "agitinfo_");
	
	local pic_agit_level = GET_CHILD_RECURSIVELY(frame, "pic_agit_level");
	pic_agit_level:SetImage("housing_level_icon_0" .. extensionLevel);

	local txt_extension_level = GET_CHILD_RECURSIVELY(frame, "txt_extension_level");
	txt_extension_level:SetTextByKey("level", extensionLevel);
	
	local function SET_EXTENSION_LEVEL_INFO(frame, level)
		local txt_extension_level_info = GET_CHILD_RECURSIVELY(frame, "txt_extension_level_info_lv" .. level);

		local class = GetClass("guild_housing", "guild_agit_extension" .. level);
		local caption = TryGetProp(class, "Caption1");
		txt_extension_level_info:SetTextByKey("value", caption);
	end
	
	for i = 1, 5 do
		SET_EXTENSION_LEVEL_INFO(frame, i);
	end

	local facilityBox = GET_CHILD_RECURSIVELY(infoBox, 'gbox_agit_facility');
	DESTROY_CHILD_BYNAME(facilityBox, 'FACILITY_');
	
	local yPos = 50;

	local function _SET_INFO_CTRLSET(facilityBox, name, yPos, currentLevel, level, infoStr, imgConfigName)
		local towerCtrlSet = facilityBox:CreateOrGetControlSet('guild_benefit', name, 0, yPos);
		towerCtrlSet = AUTO_CAST(towerCtrlSet);
		local DISABLE_COLOR = towerCtrlSet:GetUserConfig('DISABLE_COLOR');
		towerCtrlSet = AUTO_CAST(towerCtrlSet);
		towerCtrlSet:SetGravity(ui.CENTER_HORZ, ui.TOP)
		local infoPic = GET_CHILD(towerCtrlSet, 'infoPic');
		local infoText = towerCtrlSet:GetChild('infoText');

        local caption = ""
		if name == "FACILITY_PRODUCTION" then
        	local class = GetClass("guild_housing", "guild_manufacture_workshop_extension" .. level);
        	caption = TryGetProp(class, "Caption1");
		elseif name == "FACILITY_WEAPON_RESEARCH" then
        	local class = GetClass("guild_housing", "guild_weapon_lab_extension" .. level);
        	caption = TryGetProp(class, "Caption1");
		elseif name == "FACILITY_ARMOR_RESEARCH" then
        	local class = GetClass("guild_housing", "guild_armor_lab_extension" .. level);
        	caption = TryGetProp(class, "Caption1");
		elseif name == "FACILITY_ATTRIBUTE_RESEARCH" then
        	local class = GetClass("guild_housing", "guild_attribute_lab_extension" .. level);
        	caption = TryGetProp(class, "Caption1");
		end
		local infoStr = string.format('Lv. %d %s : %s', currentLevel, infoStr, caption);

		infoPic:SetImage(imgConfigName);
		infoText:SetText(infoStr);
		if currentLevel < level then
			towerCtrlSet:SetColorTone(DISABLE_COLOR);
		end
		yPos = yPos + towerCtrlSet:GetHeight();
		return yPos;
	end
	
	yPos = _SET_INFO_CTRLSET(facilityBox, 'FACILITY_PRODUCTION', yPos, productionLevel, 1, ClMsg('Housing_ProductionLab'), 'icon_guild_housing_manufacture');
	yPos = _SET_INFO_CTRLSET(facilityBox, 'FACILITY_WEAPON_RESEARCH', yPos, weaponResearchLevel, 1, ClMsg('Housing_WeaponLab'), 'icon_guild_housing_lab_weapon');
	yPos = _SET_INFO_CTRLSET(facilityBox, 'FACILITY_ARMOR_RESEARCH', yPos, armorResearchLevel, 1, ClMsg('Housing_ArmorLab'), 'icon_guild_housing_lab_armor');
	yPos = _SET_INFO_CTRLSET(facilityBox, 'FACILITY_ATTRIBUTE_RESEARCH', yPos, attributeResearchLevel, 1, ClMsg('Housing_AttributeLab'), 'icon_guild_housing_lab_attribute');
	
	local function SET_HOUSING_POINT(infoBox, index, point, level)
		local gague_agit_housing_point = GET_CHILD_RECURSIVELY(infoBox, 'gague_agit_housing_point_0' .. index);
		gague_agit_housing_point:SetPoint(point, 500 + (level * 100));
		gague_agit_housing_point:SetUserValue("DefaultPoint", tostring(point));
	
		local btn_agit_housing_point = GET_CHILD_RECURSIVELY(infoBox, 'btn_agit_housing_point_0' .. index);
		if gague_agit_housing_point:GetCurPoint() >= gague_agit_housing_point:GetMaxPoint() then
			btn_agit_housing_point:SetEnable(0);
		else
			btn_agit_housing_point:SetEnable(1);
		end
	end

	SET_HOUSING_POINT(infoBox, 1, housingPoint_Originality, productionLevel);
	SET_HOUSING_POINT(infoBox, 2, housingPoint_Functionality, productionLevel);
	SET_HOUSING_POINT(infoBox, 3, housingPoint_Artistry, productionLevel);
	SET_HOUSING_POINT(infoBox, 4, housingPoint_Economy, productionLevel);
	
	local txt_guild_housing_point = GET_CHILD_RECURSIVELY(frame, 'txt_guild_housing_point_01');
	txt_guild_housing_point:SetTextByKey("value", tostring(0));
	
	txt_guild_housing_point = GET_CHILD_RECURSIVELY(frame, 'txt_guild_housing_point_02');
	txt_guild_housing_point:SetTextByKey("value", tostring(0));

	txt_guild_housing_point = GET_CHILD_RECURSIVELY(frame, 'txt_guild_housing_point_03');
	txt_guild_housing_point:SetTextByKey("value", tostring(0));

	txt_guild_housing_point = GET_CHILD_RECURSIVELY(frame, 'txt_guild_housing_point_04');
	txt_guild_housing_point:SetTextByKey("value", tostring(0));

	local txt_guild_housing_point_deduction = GET_CHILD_RECURSIVELY(frame, "txt_guild_housing_point_deduction");
	txt_guild_housing_point_deduction:SetTextByKey("value", 0);

	local txt_guild_housing_point_expected_residual_mileage = GET_CHILD_RECURSIVELY(frame, "txt_guild_housing_point_expected_residual_mileage");
	txt_guild_housing_point_expected_residual_mileage:SetTextByKey("value", 0);

	local btn_mileage_to_contribution = GET_CHILD_RECURSIVELY(frame, "btn_mileage_to_contribution");
	local btn_distribute_contribution = GET_CHILD_RECURSIVELY(frame, "btn_distribute_contribution");

	if AM_I_LEADER(PARTY_GUILD) == 1 then
		btn_mileage_to_contribution:SetEnable(1);
		btn_distribute_contribution:SetEnable(1);
	else
		btn_mileage_to_contribution:SetEnable(0);
		btn_distribute_contribution:SetEnable(0);
	end
	
	local btn_agit_housing_point_commit = GET_CHILD_RECURSIVELY(frame, "btn_agit_housing_point_commit");
    local btn_agit_housing_point_01 = GET_CHILD_RECURSIVELY(frame, "btn_agit_housing_point_01");
    local btn_agit_housing_point_02 = GET_CHILD_RECURSIVELY(frame, "btn_agit_housing_point_02");
    local btn_agit_housing_point_03 = GET_CHILD_RECURSIVELY(frame, "btn_agit_housing_point_03");
    local btn_agit_housing_point_04 = GET_CHILD_RECURSIVELY(frame, "btn_agit_housing_point_04");
	if extensionLevel > 1 then
		local time = tonumber(btn_agit_housing_point_commit:GetUserValue("Time"));
		if time == nil then
			btn_agit_housing_point_commit:SetEnable(1);
		else
			if time < imcTime.GetAppTime() then
	    			btn_agit_housing_point_commit:SetEnable(1);
			else
				btn_agit_housing_point_commit:SetEnable(0);
    			end
    		end

		btn_agit_housing_point_01:SetEnable(1);
		btn_agit_housing_point_02:SetEnable(1);
		btn_agit_housing_point_03:SetEnable(1);
		btn_agit_housing_point_04:SetEnable(1);
	else
		btn_agit_housing_point_commit:SetEnable(0);
		btn_agit_housing_point_01:SetEnable(0);
		btn_agit_housing_point_02:SetEnable(0);
		btn_agit_housing_point_03:SetEnable(0);
		btn_agit_housing_point_04:SetEnable(0);
	end
end

function BTN_CONTRIBUTION_TO_MILEAGE()
	INIT_CONTRIBUTION_TO_MILEAGE_POINT();
end

function BTN_MILEAGE_TO_CONTRIBUTION()
	INIT_MILEAGE_TO_CONTRIBUTION_POINT();
end

function BTN_DISTRIBUTE_CONTRIBUTION()
	ui.OpenFrame("guild_distribute_contribution");
end

function HOUSING_POINT_UP(gbox, index, upPoint)
	if upPoint <= 0 then
		return;
	end

	local gague_agit_housing_point = GET_CHILD_RECURSIVELY(gbox, 'gague_agit_housing_point_0' .. tostring(index));
	if gague_agit_housing_point == nil then
		return;
	end
	
	local txt_guild_housing_point = GET_CHILD_RECURSIVELY(gbox, 'txt_guild_housing_point_0' .. tostring(index));
	if txt_guild_housing_point == nil then
		return;
	end
	
	local mileage = 0;

	local frame = gbox:GetTopParentFrame();
	local guild_mileage = GET_CHILD_RECURSIVELY(frame, "txt_guild_mileage");
	if guild_mileage ~= nil then
		mileage = GET_NOT_COMMAED_NUMBER(guild_mileage:GetTextByKey("value"));
	end

	local defaultPoint = gague_agit_housing_point:GetUserValue("DefaultPoint");
	if defaultPoint == "None" then
		defaultPoint = 0;
	end

	local curPoint = gague_agit_housing_point:GetCurPoint();
	local maxPoint = gague_agit_housing_point:GetMaxPoint();

	if curPoint + upPoint > maxPoint then
		upPoint = maxPoint - curPoint;
	end

	if upPoint <= 0 then
		return;
	end
	
	local totalAddPoint = 0;
	for i = 1, 4 do
		local gague_agit_housing_point = GET_CHILD_RECURSIVELY(frame, 'gague_agit_housing_point_0' .. tostring(i));
		if gague_agit_housing_point ~= nil then
			local defaultPoint = gague_agit_housing_point:GetUserValue("DefaultPoint");
			if defaultPoint == "None" then
				defaultPoint = 0;
			end
			
			local curPoint = gague_agit_housing_point:GetCurPoint();
			totalAddPoint = totalAddPoint + (curPoint - defaultPoint);
		end
	end

	local ratio = HOUSING_GUILDMILEAGE_TO_HOUSING_POINT;
	if (totalAddPoint + upPoint) * ratio > mileage then
		return;
	end

	local point = curPoint + upPoint;
	txt_guild_housing_point:SetTextByKey("value", tostring(point - defaultPoint));
	gague_agit_housing_point:SetCurPoint(point);
	
	local txt_guild_housing_point_deduction = GET_CHILD_RECURSIVELY(frame, "txt_guild_housing_point_deduction");
	txt_guild_housing_point_deduction:SetTextByKey("value", (totalAddPoint + upPoint) * ratio);

	local txt_guild_housing_point_expected_residual_mileage = GET_CHILD_RECURSIVELY(frame, "txt_guild_housing_point_expected_residual_mileage");
	txt_guild_housing_point_expected_residual_mileage:SetTextByKey("value", mileage - ((totalAddPoint + upPoint) * ratio));
end

function BTN_HOUSING_POINT_UP_01(gbox)
	   HOUSING_POINT_UP(gbox, 1, 1);
end

function BTN_HOUSING_POINT_10UP_01(gbox)
	HOUSING_POINT_UP(gbox, 1, 10);
end

function BTN_HOUSING_POINT_UP_02(gbox)
	HOUSING_POINT_UP(gbox, 2, 1);
end

function BTN_HOUSING_POINT_10UP_02(gbox)
	HOUSING_POINT_UP(gbox, 2, 10);
end

function BTN_HOUSING_POINT_UP_03(gbox)
	HOUSING_POINT_UP(gbox, 3, 1);
end

function BTN_HOUSING_POINT_10UP_03(gbox)
	HOUSING_POINT_UP(gbox, 3, 10);
end

function BTN_HOUSING_POINT_UP_04(gbox)
	HOUSING_POINT_UP(gbox, 4, 1);
end

function BTN_HOUSING_POINT_10UP_04(gbox)
	HOUSING_POINT_UP(gbox, 4, 10);
end

function RESET_HOUSING_POINT(gbox, index)
	local gague_agit_housing_point = GET_CHILD_RECURSIVELY(gbox, 'gague_agit_housing_point_0' .. tostring(index));
	if gague_agit_housing_point == nil then
		return;
	end
	
	local txt_guild_housing_point = GET_CHILD_RECURSIVELY(gbox, 'txt_guild_housing_point_0' .. tostring(index));
	if txt_guild_housing_point == nil then
		return;
	end

	local defaultPoint = gague_agit_housing_point:GetUserValue("DefaultPoint");
	if defaultPoint == "None" then
		defaultPoint = 0;
	end
	
	txt_guild_housing_point:SetTextByKey("value", tostring(0));
	gague_agit_housing_point:SetCurPoint(defaultPoint);
end

function BTN_AGIT_HOUSING_POINT_CANCEL(frame)
	RESET_HOUSING_POINT(frame, 1);
	RESET_HOUSING_POINT(frame, 2);
	RESET_HOUSING_POINT(frame, 3);
	RESET_HOUSING_POINT(frame, 4);

	local txt_guild_housing_point_deduction = GET_CHILD_RECURSIVELY(frame, "txt_guild_housing_point_deduction");
	txt_guild_housing_point_deduction:SetTextByKey("value", 0);

	local txt_guild_housing_point_expected_residual_mileage = GET_CHILD_RECURSIVELY(frame, "txt_guild_housing_point_expected_residual_mileage");
	txt_guild_housing_point_expected_residual_mileage:SetTextByKey("value", 0);
end

function BTN_AGIT_HOUSING_POINT_COMMIT(gbox, btn)
	local frame = gbox:GetTopParentFrame();
	local function GET_ADD_HOUSING_POINT(frame, index)
		local gague_agit_housing_point = GET_CHILD_RECURSIVELY(frame, 'gague_agit_housing_point_0' .. tostring(index));
		if gague_agit_housing_point == nil then
			return 0;
		end
	
		local defaultPoint = gague_agit_housing_point:GetUserValue("DefaultPoint");
		if defaultPoint == "None" then
			defaultPoint = 0;
		end
	
		return gague_agit_housing_point:GetCurPoint() - defaultPoint;
	end

	local addOriginalityPoint = GET_ADD_HOUSING_POINT(frame, 1);
	local addFunctionalityPoint = GET_ADD_HOUSING_POINT(frame, 2);
	local addArtistryPoint = GET_ADD_HOUSING_POINT(frame, 3);
	local addEconomyPoint = GET_ADD_HOUSING_POINT(frame, 4);
	housing.RequestGuildHousingPointUp(addOriginalityPoint, addFunctionalityPoint, addArtistryPoint, addEconomyPoint, "RECEIVE_GUILD_AGIT_INFO");
	
	btn:SetEnable(0);
	btn:SetUserValue("Time", imcTime.GetAppTime() + 2);
	AddLuaTimerFunc("RESET_AGIT_HOUSING_POINT_BUTTON", 2000, 0);
end

function RESET_AGIT_HOUSING_POINT_BUTTON()
	local frame = ui.GetFrame("guildinfo");
	local button = GET_CHILD_RECURSIVELY(frame, "btn_agit_housing_point_commit");
	button:SetEnable(1);
end

function ON_UPDATE_GUILD_AGIT_INFO_GUILD_MILEAGE(frame, msg, strArg, numArg)
	local guild_mileage = GET_CHILD_RECURSIVELY(frame, 'txt_guild_mileage');
	guild_mileage:SetTextByKey("value", GET_COMMAED_STRING(numArg));
end

function ON_UPDATE_GUILD_AGIT_INFO_GUILD_CONTRIBUTION(frame, msg, strArg, numArg)
    local txt_my_contribution = GET_CHILD_RECURSIVELY(frame, 'txt_my_contribution');
	txt_my_contribution:SetTextByKey("value", GET_COMMAED_STRING(GET_MY_CONTRIBUTION()));
end