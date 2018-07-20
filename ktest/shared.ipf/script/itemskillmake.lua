
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

