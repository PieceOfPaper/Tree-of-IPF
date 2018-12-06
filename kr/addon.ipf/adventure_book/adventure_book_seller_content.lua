
ADVENTURE_BOOK_SELLER_CONTENT = {};

function ADVENTURE_BOOK_SELLER_CONTENT.SELLER_SKILL_LIST()
	local skilllist = GetAdventureBookClassIDList(ABT_AUTOSELLER)
	return skilllist;
end

function ADVENTURE_BOOK_SELLER_CONTENT.SELLER_EARNINGS_COUNT(skillID)
	local data = GetAdventureBookInstByClassID(ABT_AUTOSELLER, skillID)
	if data == nil then
		return 0;
	end
	data = tolua.cast(data, "ADVENTURE_BOOK_AUTOSELLER_DATA");
	return data:GetEarningPay();
end
function ADVENTURE_BOOK_SELLER_CONTENT.SELLER_TOTAL_EARNINGS_COUNT()
	local list = ADVENTURE_BOOK_SELLER_CONTENT.SELLER_SKILL_LIST()
	local totalCount = 0;
	for i=1, #list do
		local count = ADVENTURE_BOOK_SELLER_CONTENT.SELLER_EARNINGS_COUNT(list[i])
		totalCount = totalCount + count;
	end
	return totalCount;
end
function ADVENTURE_BOOK_SELLER_CONTENT.SKILL_INFO(skillID)
	local skillCls = GetClassByType("Skill", skillID)
	if skillCls == nil or TryGetProp(skillCls, "ClassName") == nil or TryGetProp(skillCls, "Icon") == nil then
		return;
	end

	local skillTableCls = geSkillTable.Get(skillCls.ClassName);
	if skillTableCls == nil then
		return;
	end

	local JobCls = GetClassByType("Job", skillTableCls:GetUseJobClassID())
	if JobCls == nil then
		return;
	end
	local retTable = {}

	retTable['skill_icon'] = "icon_" .. skillCls.Icon;
	retTable['skill_name'] = TryGetProp(skillCls, "Name");
	retTable['skill_class_name'] = skillCls.ClassName;
	retTable['skill_desc'] = TryGetProp(skillCls, "Caption");

	retTable['job_icon'] = TryGetProp(JobCls, "Icon");
	retTable['job_name'] = TryGetProp(JobCls, "Name");
	retTable['job_class_name'] = TryGetProp(JobCls, "ClassName");
	retTable['job_ctrl_type'] = TryGetProp(JobCls, "CtrlType");

	retTable['earnings_count'] = ADVENTURE_BOOK_SELLER_CONTENT.SELLER_EARNINGS_COUNT(skillID)

	return retTable;
end

function ADVENTURE_BOOK_SELLER_CONTENT.SKILL_ABILITY_LIST(skillID)
	local skillCls = GetClassByType("Skill", skillID)
	if skillCls == nil or TryGetProp(skillCls, "ClassName") == nil then
		return;
	end

	local retTable = {} 
	local list = GetSkillAbilityNameList(skillCls.ClassName)
	for i=1, #list do
		retTable[#retTable + 1] = list[i]
	end
	return retTable;
end

function ADVENTURE_BOOK_SELLER_CONTENT.ABILITY_INFO(abilityClassName)
	local abilityCls = GetClass("Ability", abilityClassName)
	if abilityCls == nil then
		return;
	end

	local retTable = {}
		retTable['icon'] = TryGetProp(abilityCls, "Icon")
		retTable['class_name'] = TryGetProp(abilityCls, "ClassName")
		retTable['name'] = TryGetProp(abilityCls, "Name")
		retTable['desc'] = TryGetProp(abilityCls, "Desc")

	return retTable;
end

function ADVENTURE_BOOK_SELLER_CONTENT.SORT_NAME_BY_CLASSID_ASC(a, b)
	return ADVENTURE_BOOK_SORT_PROP_BY_CLASSID_ASC('Skill', 'Name', a, b)
end

function ADVENTURE_BOOK_SELLER_CONTENT.SORT_NAME_BY_CLASSID_DES(a, b)
	return ADVENTURE_BOOK_SORT_PROP_BY_CLASSID_ASC('Skill', 'Name', b, a)
end

function ADVENTURE_BOOK_SELLER_CONTENT.FIND_SKILL_CTRL_TYPE(skillID, ctrlType)
	local skillInfo = ADVENTURE_BOOK_SELLER_CONTENT.SKILL_INFO(skillID)
	if skillInfo['job_ctrl_type'] == ctrlType then
		return true
	else
		return false
	end
end

function ADVENTURE_BOOK_SELLER_CONTENT.FILTER_LIST(list, sortOption, categoryOption)
	if categoryOption == 1 then
		list = ADVENTURE_BOOK_FILTER_ITEM(list, ADVENTURE_BOOK_SELLER_CONTENT['FIND_SKILL_CTRL_TYPE'], 'Warrior')
	elseif categoryOption == 2 then
		list = ADVENTURE_BOOK_FILTER_ITEM(list, ADVENTURE_BOOK_SELLER_CONTENT['FIND_SKILL_CTRL_TYPE'], 'Wizard')
	elseif categoryOption == 3 then
		list = ADVENTURE_BOOK_FILTER_ITEM(list, ADVENTURE_BOOK_SELLER_CONTENT['FIND_SKILL_CTRL_TYPE'], 'Archer')
	elseif categoryOption == 4 then
		list = ADVENTURE_BOOK_FILTER_ITEM(list, ADVENTURE_BOOK_SELLER_CONTENT['FIND_SKILL_CTRL_TYPE'], 'Cleric')
	elseif categoryOption == 5 then
		list = ADVENTURE_BOOK_FILTER_ITEM(list, ADVENTURE_BOOK_SELLER_CONTENT['FIND_SKILL_CTRL_TYPE'], 'Scout')
	end

	if sortOption == 0 then
        table.sort(list, ADVENTURE_BOOK_SELLER_CONTENT['SORT_NAME_BY_CLASSID_ASC']);
	elseif sortOption == 1 then
        table.sort(list, ADVENTURE_BOOK_SELLER_CONTENT['SORT_NAME_BY_CLASSID_DES']);
	end
	return list;
end

function ADVENTURE_BOOK_LIVING_INIT(parent, ctrl)
    local frame = ui.GetFrame('adventure_book');
    local bookmark_living = GET_CHILD_RECURSIVELY(frame, 'bookmark_living');
    local curSelectedTabName = bookmark_living:GetSelectItemName();
    if curSelectedTabName == 'tab_living_seller' then
        ADVENTURE_BOOK_RENEW_SELLER();
    elseif curSelectedTabName == 'tab_living_fishing' then
        ADVENTURE_BOOK_RENEW_FISHING();
    end
end

function ADVENTURE_BOOK_LIVING_SET_POINT()
    local adventure_book = ui.GetFrame('adventure_book');
    local page_living = adventure_book:GetChild('page_living');
    local total_score_text = page_living:GetChild('total_score_text');
    local totalScore = GET_ADVENTURE_BOOK_SHOP_POINT();
    total_score_text:SetTextByKey('value', totalScore);
end