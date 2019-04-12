function CRAFT_UPDATE_PAGE(page, cls, haveMaterial, item)

	page:SetUserValue("CLASSID", cls.ClassID);
	if item == nil then
		item = GetClass('Item', cls.TargetItem);
	end

	local app = page:CreateOrGetControlSet(g_craftRecipe, cls.ClassName, 10, 10);
	local titleText = GET_CHILD(app, "name", "ui::CRichText");

	local font = "{@st42_yellow}{s20}";
	local ableText = ScpArgMsg('craft_able')
	if haveMaterial ~= 1 then
		font = "{@st66b}{s20}";
		ableText = ""
	end

    local pc = GetMyPCObject()
	
	local skill = GetSkill(pc, "Alchemist_Tincturing")
	local Level = 0;
	if nil ~= skill and g_itemCraftFrameName ~= "itemcraft" then
		Level= skill.Level;
		local abil = session.GetAbilityByName(cls.ClassName);
		if cls.IDSpc == 'Skill_Ability' and nil ~= abil then
			local abilObj =  GetIES(abil:GetObject());
			Level = abilObj.Level;
		end
	end
	
    local DrugItemName = dictionary.ReplaceDicIDInCompStr(item.Name);
    local len = string.len(DrugItemName)
    local itmeName = string.sub(DrugItemName, 4, len)
    if skill ~= nil then
	    titleText:SetText(font ..itmeName.." LV"..Level.. ableText .."{/}");
    else
        titleText:SetText(font ..DrugItemName.. ableText .."{/}");
    end
	local difficulty = GET_CHILD(app, "difficulty", "ui::CRichText");
	local difficultyText = GET_ITEM_GRADE_TXT(item, 24);
	difficulty:SetText(difficultyText);

	local icon = GET_CHILD(app, "icon", "ui::CPicture");
	icon:SetImage(item.Icon);
	icon:SetEnableStretch(1)
	--UI_ANIM(icon, "ItemCraftIconInit");
	icon:SetEventScript(ui.RBUTTONUP, 'CRAFT_BEFORE_START_CRAFT');
	icon:SetEventScriptArgString(ui.RBUTTONUP, cls.ClassName);
--T_ITEM_TOOLTIP_TYPE(icon, item.ClassID, item);
--on:SetTooltipArg('', item.ClassID, 0);
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, itemData, item.ClassName, '', item.ClassID, 0);

	app:SetEventScript(ui.LBUTTONUP, 'CRAFT_RECIPE_FOCUS');	
	app:SetOverSound('button_cursor_over_3');
	app:SetClickSound('button_click_big_2');

	page:Resize(page:GetWidth(), app:GetY() + app:GetHeight() + 20);

end