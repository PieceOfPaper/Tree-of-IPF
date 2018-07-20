function ADVENTURE_BOOK_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg("UPDATE_ADVENTURE_BOOK", "ADVENTURE_BOOK_ON_MSG");   
         
    addon:RegisterMsg('ADVENTURE_BOOK_MAIN_RANKING', 'ON_ADVENTURE_BOOK_MAIN_RANKING');
    addon:RegisterMsg('ADVENTURE_BOOK_ITEM_RANKING', 'ADVENTURE_BOOK_ITEM_CONSUME_RANKING');
    addon:RegisterMsg('ADVENTURE_BOOK_RANKING_PAGE', 'ON_ADVENTURE_BOOK_RANKING_PAGE');
    addon:RegisterMsg('ADVENTURE_BOOK_MY_RANK_UPDATE', 'ADVENTURE_BOOK_RANK_PAGE_INIT');
    addon:RegisterMsg('ADVENTURE_BOOK_RANK_SEARCH', 'ON_ADVENTURE_BOOK_RANK_SEARCH');
    addon:RegisterMsg('UPHILL_RANK_PAGE', 'ON_UPHILL_RANK_PAGE');
    addon:RegisterMsg('ADVENTURE_BOOK_UPHILL_RANK_SEARCH', 'ON_ADVENTURE_BOOK_RANK_SEARCH');
    addon:RegisterMsg('PVP_PC_INFO', 'ADVENTURE_BOOK_TEAM_BATTLE_COMMON_UPDATE');
    addon:RegisterMsg('WORLDPVP_RANK_PAGE', 'ADVENTURE_BOOK_TEAM_BATTLE_RANK_UPDATE');    
	addon:RegisterMsg("PVP_STATE_CHANGE", "ADVENTURE_BOOK_TEAM_BATTLE_STATE_CHANGE");
	addon:RegisterMsg("PVP_PROPERTY_UPDATE", "ADVENTURE_BOOK_UPDATE_PVP_PROPERTY");	
    addon:RegisterMsg('UPDATE_ADVENTURE_BOOK_REWARD', 'ADVENTURE_BOOK_MAIN_REWARD');
    addon:RegisterMsg('UPDATE_ADVENTURE_BOOK_CONTENTS_POINT', 'ADVENTURE_BOOK_QUEST_ACHIEVE_INIT_POINT');
    addon:RegisterMsg('UPDATE_WORLDPVP_GAME_LIST', 'WORLDPVP_PUBLIC_GAME_LIST');
end

function ADVENTURE_BOOK_BTN_CLOSE(ctrl , btn)
   CLOSE_ADVENTURE_BOOK();
end

function ADVENTURE_BOOK_RENEW_SELECTED_TAB()
	local frame = ui.GetFrame('adventure_book')
    local bookmark = GET_CHILD(frame, 'bookmark');
	local selectedTabName = bookmark:GetSelectItemName();
	
	if selectedTabName == "tab_monster" then
		ADVENTURE_BOOK_RENEW_MONSTER()
	elseif selectedTabName == "tab_item" then
		ADVENTURE_BOOK_RENEW_ITEM()
	elseif selectedTabName == "tab_craft" then
		ADVENTURE_BOOK_RENEW_CRAFT()
	elseif selectedTabName == "tab_living" then
		ADVENTURE_BOOK_LIVING_INIT()
	elseif selectedTabName == "tab_indun" then
		ADVENTURE_BOOK_RENEW_INDUN()
	elseif selectedTabName == "tab_grow" then
		ADVENTURE_BOOK_RENEW_GROW()
	elseif selectedTabName == "tab_explore" then
		ADVENTURE_BOOK_RENEW_QUEST_ACHIEVE()
	end
end

function ADVENTURE_BOOK_ON_MSG(frame, msg, argStr, argNum)
    local bookmark = GET_CHILD(frame, 'bookmark');
	local selectedTabName = bookmark:GetSelectItemName();
	if msg == "UPDATE_ADVENTURE_BOOK" then  
        ADVENTURE_BOOK_MAIN_INIT(frame, frame);
          
		if argNum == ABT_MON_KILL_COUNT then
			if selectedTabName == "tab_monster" then
				ADVENTURE_BOOK_RENEW_SELECTED_TAB()
			end
		elseif argNum == ABT_INDUN then
			if selectedTabName == "tab_indun" then
				ADVENTURE_BOOK_RENEW_SELECTED_TAB()
			end
		elseif argNum == ABT_CRAFT then
			if selectedTabName == "tab_craft" then
				ADVENTURE_BOOK_RENEW_SELECTED_TAB()
			end
		elseif argNum == ABT_FISHING then
			if selectedTabName == "tab_living" then
				ADVENTURE_BOOK_RENEW_SELECTED_TAB()
			end
		elseif argNum == ABT_MON_DROP_ITEM then
			if selectedTabName == "tab_monster" or  selectedTabName == "tab_item" then
				ADVENTURE_BOOK_RENEW_SELECTED_TAB()
			end
		elseif argNum == ABT_ITEM_COUNTABLE then
			if selectedTabName == "tab_item" then
				ADVENTURE_BOOK_RENEW_SELECTED_TAB()
			end
		elseif argNum == ABT_ITEM_PERMANENT then
			if selectedTabName == "tab_item" then
				ADVENTURE_BOOK_RENEW_SELECTED_TAB()
			end
		elseif argNum == ABT_ACHIEVE then
			if selectedTabName == "tab_explore" then
				ADVENTURE_BOOK_RENEW_SELECTED_TAB()
			end
		elseif argNum == ABT_AUTOSELLER then
			if selectedTabName == "tab_living" then
				ADVENTURE_BOOK_RENEW_SELECTED_TAB()
			end
		elseif argNum == ABT_CHARACTER then
			if selectedTabName == "tab_grow" then
				ADVENTURE_BOOK_RENEW_SELECTED_TAB()
			end
		end
	end
end

function ADVENTURE_BOOK_BTN_SELECT_REGION(ctrl , btn)
	local value = GET_USER_VALUE(ctrl, "BtnArg");
	ADVENTURE_BOOK_MAP.SELECTED_REGION = value;
	ADVENTURE_BOOK_MAP.FILL_DATA()
end

function ADVENTURE_BOOK_RENEW_GROW()
	ADVENTURE_BOOK_GROW.RENEW();
end

function ADVENTURE_BOOK_RENEW_MONSTER()
	ADVENTURE_BOOK_MONSTER.RENEW();
end

function ADVENTURE_BOOK_RENEW_ITEM_CATEGORY()
	ADVENTURE_BOOK_ITEM.DROPDOWN_LIST_UPDATE_SUB()
	ADVENTURE_BOOK_ITEM.RENEW();
end

function ADVENTURE_BOOK_RENEW_ITEM()
	ADVENTURE_BOOK_ITEM.RENEW();
end

function ADVENTURE_BOOK_RENEW_CRAFT_CATEGORY()
	ADVENTURE_BOOK_CRAFT.DROPDOWN_LIST_UPDATE_SUB()
	ADVENTURE_BOOK_CRAFT.RENEW();
end

function ADVENTURE_BOOK_RENEW_CRAFT()
	ADVENTURE_BOOK_CRAFT.RENEW();
end

function ADVENTURE_BOOK_RENEW_SELLER()
	ADVENTURE_BOOK_SELLER.RENEW();
end

function ADVENTURE_BOOK_RENEW_FISHING()
	ADVENTURE_BOOK_FISHING.RENEW();
end

function ADVENTURE_BOOK_RENEW_INDUN()
	ADVENTURE_BOOK_INDUN.RENEW();
end

function ADVENTURE_BOOK_RENEW_MAP()
    ADVENTURE_BOOK_RENEW_QUEST_ACHIEVE();
end

function ADVENTURE_BOOK_RENEW_QUEST_ACHIEVE()
    local frame = ui.GetFrame('adventure_book');
    local bookmark_explore = GET_CHILD_RECURSIVELY(frame, 'bookmark_explore');
    local curTabName = bookmark_explore:GetSelectItemName();
    if curTabName == 'tab_explore_quest' then
	    ADVENTURE_BOOK_QUEST_ACHIEVE.RENEW();
    elseif curTabName == 'tab_explore_map' then
        ADVENTURE_BOOK_MAP.RENEW();
    elseif curTabName == 'tab_explore_collection' then        
        ADVENTURE_BOOK_COLLECTION_TAB(frame, frame);
    end
end

function ADVENTURE_BOOK_TOOLTIP_GROW_JOB(frame, jobType)
	ADVENTURE_BOOK_GROW.TOOLTIP_JOB(frame, jobType);
end

function ON_ADVENTURE_BOOK_RANKING_PAGE(frame, msg, argStr, argNum)
    if argStr == 'Initialization_point' then
        ADVENTURE_BOOK_RANKING_SHOW_PAGE(frame, argNum);
    elseif argStr == 'Item_Consume_point' then

    end
end

function ADVENTURE_BOOK_BTN_SELECT_MONSTER(ctrl , btn)
	local value = ctrl:GetUserValue("BtnArg");
	ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER = value;
	ADVENTURE_BOOK_MONSTER.FILL_MONSTER_INFO()
end

function ADVENTURE_BOOK_BTN_SELECT_ITEM(ctrl , btn)
	local value = ctrl:GetUserValue("BtnArg");
	ADVENTURE_BOOK_ITEM.SELECTED_ITEM = value;
	ADVENTURE_BOOK_ITEM.FILL_ITEM_INFO()
end

function ADVENTURE_BOOK_BTN_SELECT_CRAFT(ctrl , btn)
	local value = ctrl:GetUserValue("BtnArg");
	if ADVENTURE_BOOK_CRAFT.SELECTED_ITEM == value then
		ADVENTURE_BOOK_CRAFT.SELECTED_ITEM = "";
		ADVENTURE_BOOK_CRAFT.SELECTED_CTRL = "";
	else
		ADVENTURE_BOOK_CRAFT.SELECTED_ITEM = value;
		ADVENTURE_BOOK_CRAFT.SELECTED_CTRL = ctrl:GetName();
	end
	ADVENTURE_BOOK_CRAFT.FILL_CRAFT_LIST();
	ADVENTURE_BOOK_CRAFT.FILL_CRAFT_INFO()
end

function ADVENTURE_BOOK_BTN_SELECT_SELLER(ctrl , btn)
	local value = ctrl:GetUserValue("BtnArg");
	ADVENTURE_BOOK_SELLER.SELECTED_SKILL = value;
	ADVENTURE_BOOK_SELLER.FILL_SKILL_INFO()
	ADVENTURE_BOOK_SELLER.FILL_ABILITY_INFO()
end

function ADVENTURE_BOOK_BTN_SELECT_FISH(ctrl , btn)
	local value = ctrl:GetUserValue("BtnArg");
	ADVENTURE_BOOK_FISHING.SELECTED_FISH = value;
	ADVENTURE_BOOK_FISHING.FILL_FISH_INFO()
end

function ADVENTURE_BOOK_BTN_SELECT_INDUN(ctrl , btn)
	local value = ctrl:GetUserValue("BtnArg");
	ADVENTURE_BOOK_INDUN.SELECTED_INDUN = value;
	ADVENTURE_BOOK_INDUN.FILL_INDUN_INFO()
end
function ADVENTURE_BOOK_BTN_SELECT_REGION(ctrl , btn)
	local value = ctrl:GetUserValue("BtnArg");
	
	if ADVENTURE_BOOK_MAP.SELECTED_REGION == value then
		ADVENTURE_BOOK_MAP.SELECTED_REGION = "";
	else
		ADVENTURE_BOOK_MAP.SELECTED_REGION = value;
	end
	ADVENTURE_BOOK_MAP.FILL_REGION_LIST()
end
function ADVENTURE_BOOK_BTN_SELECT_MAP(ctrl , btn)
	local value = ctrl:GetUserValue("BtnArg");
	ADVENTURE_BOOK_MAP.SELECTED_MAP = value;
	ADVENTURE_BOOK_MAP.FILL_MAP_INFO();
    ADVENTURE_BOOK_MAP.DRAW_MINIMAP(ADVENTURE_BOOK_MAP.SELECTED_MAP);
end
function ADVENTURE_BOOK_BTN_MORE_CRAFT(ctrl , btn)
	local maxIndex = ADVENTURE_BOOK_CRAFT.MAX_GROUP_INDEX()
	if ADVENTURE_BOOK_CRAFT.SHOW_GROUP_INDEX < maxIndex then
		ADVENTURE_BOOK_CRAFT.SHOW_GROUP_INDEX = ADVENTURE_BOOK_CRAFT.SHOW_GROUP_INDEX + 1;
		ADVENTURE_BOOK_CRAFT.FILL_CRAFT_LIST();
	end
end

function ADVENTURE_BOOK_BTN_MORE_ITEM(ctrl , btn)
	local maxIndex = ADVENTURE_BOOK_ITEM.MAX_GROUP_INDEX()
	if ADVENTURE_BOOK_ITEM.SHOW_GROUP_INDEX < maxIndex then
		ADVENTURE_BOOK_ITEM.SHOW_GROUP_INDEX = ADVENTURE_BOOK_ITEM.SHOW_GROUP_INDEX + 1;
		ADVENTURE_BOOK_ITEM.FILL_ITEM_LIST();
	end
end

function ADVENTURE_BOOK_BTN_MORE_MONSTER(ctrl , btn)
	local maxIndex = ADVENTURE_BOOK_MONSTER.MAX_GROUP_INDEX()
	if ADVENTURE_BOOK_MONSTER.SHOW_GROUP_INDEX < maxIndex then
		ADVENTURE_BOOK_MONSTER.SHOW_GROUP_INDEX = ADVENTURE_BOOK_MONSTER.SHOW_GROUP_INDEX + 1;
		ADVENTURE_BOOK_MONSTER.FILL_MONSTER_LIST();
	end
end

function ADVENTURE_BOOK_BTN_SLOT_LEFT(ctrl, btn, argStr, argNum)
	if argStr == "Monster" then
		ADVENTURE_BOOK_MONSTER['INFO_SLOT_INDEX'] = ADVENTURE_BOOK_MONSTER['INFO_SLOT_INDEX'] - 1
		ADVENTURE_BOOK_MONSTER['ADJUST_SLOT_INDEX']()
		ADVENTURE_BOOK_MONSTER['FILL_MONSTER_INFO_SLOT'](ctrl, ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER)
	elseif argStr == "Item" then
		ADVENTURE_BOOK_ITEM['INFO_SLOT_INDEX'] = ADVENTURE_BOOK_ITEM['INFO_SLOT_INDEX'] - 1
		ADVENTURE_BOOK_ITEM['ADJUST_SLOT_INDEX'](ctrl, ADVENTURE_BOOK_ITEM.SELECTED_ITEM)
		ADVENTURE_BOOK_ITEM['FILL_ITEM_INFO_SLOT'](ctrl, ADVENTURE_BOOK_ITEM.SELECTED_ITEM)
	elseif argStr == "Craft" then

	end	
end

function ADVENTURE_BOOK_BTN_SLOT_RIGHT(ctrl, btn, argStr, argNum)
	if argStr == "Monster" then
		ADVENTURE_BOOK_MONSTER['INFO_SLOT_INDEX'] = ADVENTURE_BOOK_MONSTER['INFO_SLOT_INDEX'] + 1
		ADVENTURE_BOOK_MONSTER['ADJUST_SLOT_INDEX']()
		ADVENTURE_BOOK_MONSTER['FILL_MONSTER_INFO_SLOT'](ctrl, ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER)
	elseif argStr == "Item" then
		ADVENTURE_BOOK_ITEM['INFO_SLOT_INDEX'] = ADVENTURE_BOOK_ITEM['INFO_SLOT_INDEX'] + 1
		ADVENTURE_BOOK_ITEM['ADJUST_SLOT_INDEX'](ctrl, ADVENTURE_BOOK_ITEM.SELECTED_ITEM)
		ADVENTURE_BOOK_ITEM['FILL_ITEM_INFO_SLOT'](ctrl, ADVENTURE_BOOK_ITEM.SELECTED_ITEM)
	elseif argStr == "Craft" then

	end
end

function ON_ADVENTURE_BOOK_SLOT_MONSTER_TO_ITEM(frame, msg, argStr, argNum)
	local frame = ui.GetFrame('adventure_book');
	bookmark = GET_CHILD(frame, "bookmark")
	ADVENTURE_BOOK_ITEM['SELECTED_ITEM'] = argNum
	bookmark:SelectTab(2);
end

function ON_ADVENTURE_BOOK_SLOT_ITEM_TO_MONSTER(frame, msg, argStr, argNum)
	local frame = ui.GetFrame('adventure_book');
	bookmark = GET_CHILD(frame, "bookmark")
	ADVENTURE_BOOK_MONSTER['SELECTED_MONSTER'] = argNum
	bookmark:SelectTab(1);
end

function ADVENTURE_BOOK_SORT_ASC(a, b)
	return a < b
end

function ADVENTURE_BOOK_SORT_PROP_BY_CLASSID_ASC(idSpace, propName, a, b)
	local clsA = GetClassByType(idSpace, a)
	local clsB = GetClassByType(idSpace, b)
	local nameA = TryGetProp(clsA, propName)
	local nameB = TryGetProp(clsB, propName)

	if nameA == nil then
		return true;
	end
	if nameB == nil then
		return false;
	end

	return nameA < nameB
end

function ADVENTURE_BOOK_FILTER_ITEM(list, func, arg1, arg2, arg3)
	local i=1;
    while i <= (#list) do
		local ret = func(list[i], arg1, arg2, arg3)
		if ret == false then
			list[i]=list[#list]
			list[#list]=nil
        else
            i=i+1;
		end
	end
	return list;
end

function ADVENTURE_BOOK_SEARCH_PROP_BY_CLASSID_FUNC(clsID, idSpace, propName, searchText)
    if searchText == nil or searchText == '' then
		return true;
	end

	local cls = GetClassByType(idSpace, clsID)
	local prop = TryGetProp(cls, propName);

	if prop == nil then
		return false;
	end

	if propName == "Name" then
		if config.GetServiceNation() ~= "KOR" then
			prop = dic.getTranslatedStr(prop);				
		end
	end

	prop = string.lower(prop);
	searchText = string.lower(searchText);
	
	if string.find(prop, searchText) == nil then
		return false;
	else
		return true;
	end
end

function ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FUNC(clsID, idSpace, propName, targetPropValue)
	local cls = GetClassByType(idSpace, clsID)
	local prop = TryGetProp(cls, propName);
	if prop == targetPropValue then
		return true
	else
		return false
	end
end

function ADVENTURE_BOOK_SEARCH_PROP_BY_CLASSID_FROM_LIST(list, idSpace, propName, searchText)
	return ADVENTURE_BOOK_FILTER_ITEM(list, ADVENTURE_BOOK_SEARCH_PROP_BY_CLASSID_FUNC, idSpace, propName, searchText)
end

function ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FROM_LIST(list, idSpace, propName, targetPropValue)
	return ADVENTURE_BOOK_FILTER_ITEM(list, ADVENTURE_BOOK_EQUAL_PROP_BY_CLASSID_FUNC, idSpace, propName, targetPropValue)
end

function UI_TOGGLE_JOURNAL()
	if app.IsBarrackMode() == true then
		return;
	end
	ui.ToggleFrame('adventure_book')
	local frame = ui.GetFrame("adventure_book");
	ADVENTURE_BOOK_RENEW_SELECTED_TAB()
end

function OPEN_DO_JOURNAL(frame)
	if nil == frame then
		frame = ui.GetFrame("adventure_book");
	end

	frame:SetUserValue("IS_OPEN_BY_NPC", "YES");
	OPEN_ADVENTURE_BOOK(frame, "YES");
	REGISTERR_LASTUIOPEN_POS(frame);
end

function OPEN_ADVENTURE_BOOK(frame, isopenbynpc)
    if frame == nil then
        frame = ui.GetFrame('adventure_book');
    end
	if isopenbynpc == "YES" then
		ui.OpenFrame("adventure_book");
        ADVENTURE_BOOK_MAIN_SELECT(frame);
    else
        if frame:GetUserValue('SHOW_REWARD') == 'None' then
            isopenbynpc = 'NO';        
        end
	end
    ADVENTURE_BOOK_MAIN_SELECT(frame);
    ADVENTURE_BOOK_MAIN_INIT(frame, frame:GetChild('page_main'), isopenbynpc);
end

function CLOSE_ADVENTURE_BOOK(frame)
    if frame == nil then
        frame = ui.GetFrame('adventure_book');
    end
    ui.CloseFrame("adventure_book");
    ui.CloseFrame('adventure_book_reward');
	frame:SetUserValue("IS_OPEN_BY_NPC","NO");
	UNREGISTERR_LASTUIOPEN_POS(frame);
end

function ADVENTURE_BOOK_UPDATE_PVP_PROPERTY(frame, msg, argStr, argNum)
	ADVENTURE_BOOK_TEAM_BATTLE_COMMON_UPDATE(frame, msg, argStr, argNum);
	ADVENTURE_BOOK_UPHILL_UPDATE_POINT(frame);
end