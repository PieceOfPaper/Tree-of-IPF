-- lib_skillicon.lua --

function SET_SLOT_SKILL(slot, sklCls)

	local type = sklCls.ClassID;
	local icon = CreateIcon(slot);
	local imageName = 'icon_' .. sklCls.Icon;
	icon:Set(imageName, "Skill", type, 0);
	icon:SetEnableUpdateScp('ICON_UPDATE_SKILL_ENABLE');
	SET_SKILL_TOOLTIP_BY_TYPE(icon, type);
	icon:ClearText();

	
	icon:SetEventScript(ui.LBUTTONUP, "SLOT_USE_SKL");
	icon:SetEventScriptArgNumber(ui.LBUTTONUP, type);

	icon:SetEventScript(ui.RBUTTONUP, "SLOT_USE_SKL");
	icon:SetEventScriptArgNumber(ui.LBUTTONUP, type);

	--slot:EnableDrag(0);
end

function SET_SKILL_TOOLTIP_BY_TYPE(icon, skillType)

	local iesID = "0";
	local skl = session.GetSkill(skillType);
	icon:SetTooltipType('skill');
	if skl ~= nil then
		iesID = skl:GetIESID();
	end

	icon:SetTooltipNumArg(skillType);
	icon:SetTooltipIESID(iesID);

end

function SET_SLOT_SKILL_BY_LEVEL(slot, type, level)

	local icon = CreateIcon(slot);
	SET_SKILL_TOOLTIP_BY_TYPE_LEVEL(icon, type, level);
	local sklCls = GetClassByType("Skill", type);
	local imageName = 'icon_' .. sklCls.Icon;
	icon:Set(imageName, "Skill", type, 0);
	--SET_SKILL_TOOLTIP_BY_TYPE(icon, type);
	icon:ClearText();
end


function SET_SKILL_TOOLTIP_BY_TYPE_LEVEL(icon, skillType, level)
	icon:SetTooltipType('skill');
	icon:SetTooltipArg("Level", skillType, level);
end




