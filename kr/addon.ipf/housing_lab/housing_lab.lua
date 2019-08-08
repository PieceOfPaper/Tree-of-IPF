function HOUSING_LAB_ON_INIT(addon, frame)
    addon:RegisterMsg('RECEIVE_GUILD_AGIT_WEAPON', 'OPEN_HOUSING_LAB_WEAPON');
    addon:RegisterMsg('RECEIVE_GUILD_AGIT_ARMOR', 'OPEN_HOUSING_LAB_ARMOR');
    addon:RegisterMsg('RECEIVE_GUILD_AGIT_ATTRIBUTE', 'OPEN_HOUSING_LAB_ATTRIBUTE');

    addon:RegisterMsg('REFRESH_GUILD_AGIT_WEAPON', 'SET_HOUSING_LAB_WEAPON');
    addon:RegisterMsg('REFRESH_GUILD_AGIT_ARMOR', 'SET_HOUSING_LAB_ARMOR');
    addon:RegisterMsg('REFRESH_GUILD_AGIT_ATTRIBUTE', 'SET_HOUSING_LAB_ATTRIBUTE');
end

local function SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, researchEnum, labClassName)
	local researchName = tos.housing.guild.lua.ToStringResearch(researchEnum);
	local level = guildAgit.researchLevels[researchEnum + 1];

	local frame = gbox:GetTopParentFrame();
	local labType = frame:GetUserValue("LabType");
	
	local class = nil;
	if level == 0 then
		class = GetClass("guild_housing", researchName .. "_" .. level + 1);
	else
		class = GetClass("guild_housing", researchName .. "_" .. level);
	end

	local ctrlSet = gbox:CreateControlSet("housing_lab_research", "HOUSING_LAB_RESEARCH_" .. researchName, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local research_title = GET_CHILD_RECURSIVELY(ctrlSet, "txt_research_title");
	
	local title = TryGetProp(class, "Name");
	research_title:SetTextByKey("type", title);
	research_title:SetTextByKey("level", tostring(level));

	local research = GET_CHILD_RECURSIVELY(ctrlSet, "pic_research");
	research:SetImage("icon_" .. researchName);

	local research_lv_up = GET_CHILD_RECURSIVELY(ctrlSet, "txt_research_lv_up");
	research_lv_up:SetTextByKey("value", tostring(level));
	
	local btn_research_lv_up = GET_CHILD_RECURSIVELY(ctrlSet, "btn_research_lv_up");
	btn_research_lv_up:SetUserValue("ResearchType", researchName);

	local isEnable = 0;

	local labLevel = guildAgit.labLevels[tos.housing.guild.lua.ToLabTypeByResearchType(researchEnum) + 1];
	if labLevel > 0 then
		local labClass = GetClass("guild_housing", labClassName .. labLevel);
		if labClass ~= nil then
			local maxPointByExtensionLevel = TryGetProp(labClass, "MaxPointByExtensionLevel");
			if level < maxPointByExtensionLevel then
				isEnable = 1;
			end
		end
	end
	
	btn_research_lv_up:SetEnable(isEnable);

	local txt_research_content = GET_CHILD_RECURSIVELY(ctrlSet, "txt_research_content");
	
	local caption1 = TryGetProp(class, "Caption1");
	txt_research_content:SetText("{@st66b}{s16}" .. caption1);

	local caption2 = TryGetProp(class, "Caption2");
	if labType == "Attribute" or string.find(researchName, "Armor_Cloth_Utility") ~= nil or string.find(researchName, "Armor_Leather_Utility") ~= nil or string.find(researchName, "Armor_Iron_Utility") ~= nil then
		local skillFactor1 = "0";
		local skillFactor2 = "0";

		if level > 0 then
			skillFactor1 = string.format("%.1f", TryGetProp(class, "SkillFactorBySkillLevel1"));
			skillFactor2 = string.format("%.1f", TryGetProp(class, "SkillFactorBySkillLevel2"));
		end

		txt_research_content:SetTextTooltip(string.format(caption2, skillFactor1, skillFactor2));
	else
		local skillFactor1 = "0";
		if level > 0 then
			skillFactor1 = string.format("%.1f", TryGetProp(class, "SkillFactorBySkillLevel1"));
		end

		txt_research_content:SetTextTooltip(string.format(caption2, skillFactor1));
	end

	local research_use_personal = GET_CHILD_RECURSIVELY(ctrlSet, "btn_research_use_personal");
	research_use_personal:SetUserValue("ResearchType", researchName);
    research_use_personal:SetTextTooltip(ScpArgMsg("HousingResearchUsePersonal"))
	if level <= 0 then
		research_use_personal:SetEnable(0);
		research_use_personal:SetImage("btn_use_buff_personal_off");
	else
		research_use_personal:SetImage("btn_use_buff_personal_on");
	end
	
	local research_use_guild = GET_CHILD_RECURSIVELY(ctrlSet, "btn_research_use_guild");
	research_use_guild:SetUserValue("ResearchType", researchName);
    research_use_guild:SetTextTooltip(ScpArgMsg("HousingResearchUseGuild"))
	if level <= 0 then
		research_use_guild:SetEnable(0);
		research_use_guild:SetImage("btn_use_buff_guild_off");
	else
		research_use_guild:SetImage("btn_use_buff_guild_on");
	end
end

local function SET_HOUSING_LAB_FRAME(frame, labType)
	frame:SetUserValue("LabType", labType);
	
	local title = GET_CHILD_RECURSIVELY(frame, "txt_title");
	title:SetTextByKey("value", ClMsg("Housing_" .. labType .. "_Lab_Title"));

	local question = GET_CHILD_RECURSIVELY(frame, "question");
	question:SetTextTooltip(ClMsg("Housing_" .. labType .. "_Lab_Tooltip"));
end

function OPEN_HOUSING_LAB_WEAPON()
	local guildAgit = housing.GetGuildAgitInfo();
	if guildAgit == nil then
		housing.RequestGuildAgitInfo("RECEIVE_GUILD_AGIT_WEAPON");
		return;
	end

	ui.OpenFrame("housing_lab");
	SET_HOUSING_LAB_WEAPON();
end

function SET_HOUSING_LAB_WEAPON()
	local guildAgit = housing.GetGuildAgitInfo();
	if guildAgit == nil then
		housing.RequestGuildAgitInfo("REFRESH_GUILD_AGIT_WEAPON");
		return;
	end

	local frame = ui.GetFrame("housing_lab");
	SET_HOUSING_LAB_FRAME(frame, "Weapon");

	local gbox = GET_CHILD_RECURSIVELY(frame, "gbox");
	gbox:RemoveAllChild();
	
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eWeapon_Forester, "guild_weapon_lab_extension");	--식물형
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eWeapon_Klaida, "guild_weapon_lab_extension");		--곤충형
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eWeapon_Widling, "guild_weapon_lab_extension");		--야수형
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eWeapon_Paramune, "guild_weapon_lab_extension");	--변이형
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eWeapon_Velnias, "guild_weapon_lab_extension");		--악마형

    GBOX_AUTO_ALIGN(gbox, 0, 3, 10, true, false);
end

function OPEN_HOUSING_LAB_ARMOR()
	local guildAgit = housing.GetGuildAgitInfo();
	if guildAgit == nil then
		housing.RequestGuildAgitInfo("RECEIVE_GUILD_AGIT_ARMOR");
		return;
	end

	ui.OpenFrame("housing_lab");
	SET_HOUSING_LAB_ARMOR();
end

function SET_HOUSING_LAB_ARMOR()
	local guildAgit = housing.GetGuildAgitInfo();
	if guildAgit == nil then
		housing.RequestGuildAgitInfo("REFRESH_GUILD_AGIT_ARMOR");
		return;
	end

	local frame = ui.GetFrame("housing_lab");
	SET_HOUSING_LAB_FRAME(frame, "Armor");

	local gbox = GET_CHILD_RECURSIVELY(frame, "gbox");
	gbox:RemoveAllChild();

	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eArmor_Cloth_Material, "guild_armor_lab_extension");	--천_재질
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eArmor_Leather_Material, "guild_armor_lab_extension");	--가죽_재질
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eArmor_Iron_Material, "guild_armor_lab_extension");		--판금_재질
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eArmor_Cloth_Utility, "guild_armor_lab_extension");		--천_기능
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eArmor_Leather_Utility, "guild_armor_lab_extension");	--가죽_기능
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eArmor_Iron_Utility, "guild_armor_lab_extension");		--판금_기능

    GBOX_AUTO_ALIGN(gbox, 0, 3, 10, true, false);
end

function OPEN_HOUSING_LAB_ATTRIBUTE()
	local guildAgit = housing.GetGuildAgitInfo();
	if guildAgit == nil then
		housing.RequestGuildAgitInfo("RECEIVE_GUILD_AGIT_ATTRIBUTE");
		return;
	end

	ui.OpenFrame("housing_lab");
	SET_HOUSING_LAB_ATTRIBUTE();
end

function SET_HOUSING_LAB_ATTRIBUTE()
	local guildAgit = housing.GetGuildAgitInfo();
	if guildAgit == nil then
		housing.RequestGuildAgitInfo("REFRESH_GUILD_AGIT_ATTRIBUTE");
		return;
	end

	local frame = ui.GetFrame("housing_lab");
	SET_HOUSING_LAB_FRAME(frame, "Attribute");

	local gbox = GET_CHILD_RECURSIVELY(frame, "gbox");
	gbox:RemoveAllChild();
	
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eAttribute_Fire, "guild_attribute_lab_extension");			-- 불
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eAttribute_Ice, "guild_attribute_lab_extension");			-- 얼음
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eAttribute_Lightning, "guild_attribute_lab_extension");		-- 전기
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eAttribute_Poison, "guild_attribute_lab_extension");		--독
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eAttribute_Dark, "guild_attribute_lab_extension");			--어둠
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eAttribute_Holy, "guild_attribute_lab_extension");			--신성
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eAttribute_Earth, "guild_attribute_lab_extension");			--땅
	SET_HOUSING_LAB_RESEARCH(guildAgit, gbox, tos.housing.guild.eAttribute_Soul, "guild_attribute_lab_extension");			--염

    GBOX_AUTO_ALIGN(gbox, 0, 3, 10, true, false);
end

function BTN_HOUSING_LAB_RESEARCH_LV_UP(gbox, btn)
	local guildAgit = housing.GetGuildAgitInfo();
	if guildAgit == nil then
		return;
	end

	local frame = gbox:GetTopParentFrame();
    local index = frame:GetUserIValue('ACCEPT_MSGBOX_INDEX');    
    ui.CloseMsgBoxByIndex(index);
	local labType = frame:GetUserValue("LabType");
	local researchTypeName = btn:GetUserValue("ResearchType");
	
	local researchType = tos.housing.guild.lua.ToResearchType(researchTypeName);
	local researchLevel = guildAgit.researchLevels[researchType + 1];
	if researchLevel >= 25 then
		local acceptMsgBox = ui.MsgBox(ClMsg("MaxSkillLevel"));
        acceptMsgBox = tolua.cast(acceptMsgBox, 'ui::CMessageBoxFrame');
        frame:SetUserValue('ACCEPT_MSGBOX_INDEX', acceptMsgBox:GetIndex());
		return;
	end

	local class = GetClass("guild_housing", researchTypeName .. "_" .. researchLevel + 1);
	local needSilver = TryGetProp(class, "SkillLevelUpNeedSilver");

    local clmsg = ScpArgMsg('Housing_Really_Lab_Research_Level_Up{RESEARCH}{LEVEL}{GUILD_MONEY}', 'RESEARCH', ClMsg("Housing_" .. researchTypeName .. "_Research"), 'LEVEL', researchLevel + 1, 'GUILD_MONEY', GET_COMMAED_STRING(needSilver));
	local yesScp = string.format("_BTN_HOUSING_LAB_RESEARCH_LV_UP(\"%s\")", researchTypeName);
	local acceptMsgBox = ui.MsgBox(clmsg, yesScp, "None");
    acceptMsgBox = tolua.cast(acceptMsgBox, 'ui::CMessageBoxFrame');
    frame:SetUserValue('ACCEPT_MSGBOX_INDEX', acceptMsgBox:GetIndex());
end

function _BTN_HOUSING_LAB_RESEARCH_LV_UP(researchTypeName)
	housing.RequestGuildLabResearchLevelUp(researchTypeName);
end

function BTN_HOUSING_LAB_RESEARCH_USE_PERSONAL(gbox, btn)
	local frame = gbox:GetTopParentFrame();
    local index = frame:GetUserIValue('ACCEPT_MSGBOX_INDEX');    
    ui.CloseMsgBoxByIndex(index);
	local labType = frame:GetUserValue("LabType");
	local researchType = btn:GetUserValue("ResearchType");

    local agit = housing.GetGuildAgitInfo()
    local researchTypeNumber = tos.housing.guild.lua.ToResearchType(researchType)
    local skillLv = agit.researchLevels[researchTypeNumber+1]
    local buffCls = GetClass("Buff", "Guild_"..researchType.."_Person_Buff")
    local buffName = buffCls.Name;
    local need_contribution = 2
    need_contribution = need_contribution * tonumber(skillLv)

    local clmsg
    local yesScp
    local noScp
    local aobjPropertyName

    if labType == "Weapon" then
        aobjPropertyName = "GuildHousingFacilityLastPersonBuff_Weapon"
    elseif labType == "Armor" then
        aobjPropertyName = "GuildHousingFacilityLastPersonBuff_Armor"
    elseif labType == "Attribute" then
        aobjPropertyName = "GuildHousingFacilityLastPersonBuff_Attribute"
    end

    local aObj = GetMyAccountObj();
    local lastBuff = TryGetProp(aObj, aobjPropertyName)
    if lastBuff ~= nil and lastBuff ~= "None" then
        local sList = StringSplit(lastBuff, '/');
        local lastBuffClsName = sList[1]
        if IsBuffApplied(GetMyPCObject(), lastBuffClsName) == "YES" then
            local lastBuffCls = GetClass("Buff", lastBuffClsName)
            local lastBuffName = lastBuffCls.Name;
            clmsg = ScpArgMsg('Guild_Housing_Research_Person_Buff_Apply_Over{ApplyName}{Name}{Level}{Contribution}', 'ApplyName', lastBuffName, 'Name', buffName, 'Level', skillLv, 'Contribution', need_contribution);
        else
            clmsg = ScpArgMsg('Guild_Housing_Research_Person_Buff_Apply{Name}{Level}{Contribution}', 'Name', buffName, 'Level', skillLv, 'Contribution', need_contribution);
        end
    else
        clmsg = ScpArgMsg('Guild_Housing_Research_Person_Buff_Apply{Name}{Level}{Contribution}', 'Name', buffName, 'Level', skillLv, 'Contribution', need_contribution);
    end

    yesScp = string.format('SCR_GUILD_HOUSING_RESEARCH_BUFF_PERSONAL_APPLY_CHECK("%d", "%s")', 1, researchType);
    noScp = string.format('SCR_GUILD_HOUSING_RESEARCH_BUFF_PERSONAL_APPLY_CHECK("%d")', 0);
	local acceptMsgBox = ui.MsgBox(clmsg, yesScp, noScp);
    acceptMsgBox = tolua.cast(acceptMsgBox, 'ui::CMessageBoxFrame');
    frame:SetUserValue('ACCEPT_MSGBOX_INDEX', acceptMsgBox:GetIndex());
end

function BTN_HOUSING_LAB_RESEARCH_USE_GUILD(gbox, btn)
	local frame = gbox:GetTopParentFrame();
    local index = frame:GetUserIValue('ACCEPT_MSGBOX_INDEX');    
    ui.CloseMsgBoxByIndex(index);
	local labType = frame:GetUserValue("LabType");
	local researchType = btn:GetUserValue("ResearchType");
	
    local agit = housing.GetGuildAgitInfo()
    local researchTypeNumber = tos.housing.guild.lua.ToResearchType(researchType)
    local skillLv = agit.researchLevels[researchTypeNumber+1]
    local buffCls = GetClass("Buff", "Guild_"..researchType.."_Group_Buff")
    local buffName = buffCls.Name;
    local need_silver = 1000000
    need_silver = need_silver * tonumber(skillLv)

    local clmsg
    local yesScp
    local noScp
    local gobjPropertyName

    if labType == "Weapon" then
        gobjPropertyName = "GuildHousingFacilityLastGroupBuff_Weapon"
    elseif labType == "Armor" then
        gobjPropertyName = "GuildHousingFacilityLastGroupBuff_Armor"
    elseif labType == "Attribute" then
        gobjPropertyName = "GuildHousingFacilityLastGroupBuff_Attribute"
    end
    local gObj = GET_MY_GUILD_OBJECT();
    local lastBuff = TryGetProp(gObj, gobjPropertyName)
    if lastBuff ~= nil and lastBuff ~= "None" then
        local sList = StringSplit(lastBuff, '/');
        local lastBuffClsName = sList[1]
        if IsBuffApplied(GetMyPCObject(), lastBuffClsName) == "YES" then
            local lastBuffCls = GetClass("Buff", lastBuffClsName)
            local lastBuffName = lastBuffCls.Name;
            clmsg = ScpArgMsg('Guild_Housing_Research_Group_Buff_Apply_Over{ApplyName}{Name}{Level}{Silver}', 'ApplyName', lastBuffName, 'Name', buffName, 'Level', skillLv, 'Silver', GET_COMMAED_STRING(need_silver));
        else
            clmsg = ScpArgMsg('Guild_Housing_Research_Group_Buff_Apply{Name}{Level}{Silver}', 'Name', buffName, 'Level', skillLv, 'Silver', GET_COMMAED_STRING(need_silver));
        end
    else
        clmsg = ScpArgMsg('Guild_Housing_Research_Group_Buff_Apply{Name}{Level}{Silver}', 'Name', buffName, 'Level', skillLv, 'Silver', GET_COMMAED_STRING(need_silver));
    end

    yesScp = string.format('SCR_GUILD_HOUSING_RESEARCH_BUFF_GUILD_APPLY_CHECK("%d", "%s")', 1, researchType);
    noScp = string.format('SCR_GUILD_HOUSING_RESEARCH_BUFF_GUILD_APPLY_CHECK("%d")', 0);

	local acceptMsgBox = ui.MsgBox(clmsg, yesScp, noScp);
    acceptMsgBox = tolua.cast(acceptMsgBox, 'ui::CMessageBoxFrame');
    frame:SetUserValue('ACCEPT_MSGBOX_INDEX', acceptMsgBox:GetIndex());
end

function SCR_GUILD_HOUSING_RESEARCH_BUFF_PERSONAL_APPLY_CHECK(flag, researchType)
    if tonumber(flag) == 1 then
        housing.RequestUseGuildLab(researchType, true);
    end
end

function SCR_GUILD_HOUSING_RESEARCH_BUFF_GUILD_APPLY_CHECK(flag, researchType)
    if tonumber(flag) == 1 then
	    housing.RequestUseGuildLab(researchType, false);
    end
end
