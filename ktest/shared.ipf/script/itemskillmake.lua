
function GET_SKILL_MAT_PRICE(sklObj, level)
	return level * 500;
end

function GET_SKILL_MAT_ITEM(sklName, makeSklObj, level)
	if sklName == "Enchanter_CraftMagicScrolls" then
		return "misc_emptySpellBook", level;
	end
	return "misc_parchment", level;
end

function GET_SKILL_ITEM_MAKE_TIME(sklObj, count)
	return 3*count;
end

function CHECK_EQUAL_Scroll_SkillItem(invItem, otherItem)
	if invItem.SkillType == otherItem.SkillType 
	and invItem.SkillLevel == otherItem.SkillLevel then
		return 1;
	end

	return 0;
end

function GET_SKILL_SCROLL_ITEM_NAME_BY_SKILL(skill)
	if skill == nil then
		return 'None';
	end
	return 'Scroll_SkillItem'; --_'..skill.ClassName;
end

function IS_SKILL_SCROLL_ITEM_BYNAME(itemName)
	if itemName == nil then
		return false;
	end
	if string.find(itemName, 'Scroll_SkillItem') ~= nil then
		return true;
	end
	return false;
end

function IS_SKILL_SCROLL_ITEM(item)
	if item == nil then
		return 0;
	end
	if IS_SKILL_SCROLL_ITEM_BYNAME(TryGetProp(item, 'ClassName', 'None')) == true then
		return 1;
	end
	return 0;
end