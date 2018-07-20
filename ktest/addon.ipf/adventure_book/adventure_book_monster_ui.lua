ADVENTURE_BOOK_MONSTER = {};
ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER = "";
ADVENTURE_BOOK_MONSTER.SHOW_GROUP_INDEX = 1;
ADVENTURE_BOOK_MONSTER.INFO_SLOT_INDEX = 1;
ADVENTURE_BOOK_MONSTER.CUR_LIST_COUNT = 0;

function ADVENTURE_BOOK_MONSTER.RENEW()
	ADVENTURE_BOOK_MONSTER.CLEAR();
	ADVENTURE_BOOK_MONSTER.FILL_MONSTER_LIST();
	ADVENTURE_BOOK_MONSTER.DROPDOWN_LIST_INIT();
    ADVENTURE_BOOK_MONSTER_SET_POINT();
	
	local monster_list_func = ADVENTURE_BOOK_MONSTER_CONTENT["MONSTER_LIST_ALL"];
	local monster_list = monster_list_func();
	if #monster_list < 1 then
		return;
	end
	if ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER == "" then
		ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER = monster_list[1];
	end
	ADVENTURE_BOOK_MONSTER.FILL_MONSTER_INFO();
	ADVENTURE_BOOK_MONSTER.SHOW_GROUP_INDEX = 1;
end

function ADVENTURE_BOOK_MONSTER.CLEAR()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_monster", "ui::CGroupBox");
	local list_box = GET_CHILD(page, "monster_list", "ui::CGroupBox");
	local info_box = GET_CHILD(page, "monster_info_gb", "ui::CGroupBox");
	
	list_box:RemoveAllChild();
end

function ADVENTURE_BOOK_MONSTER.FILL_MONSTER_LIST()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_monster", "ui::CGroupBox");
	local list_box = GET_CHILD(page, "monster_list", "ui::CGroupBox");
	local sort_opt_list = GET_CHILD(page, "sort_opt_list", "ui::CDropList");
	local grade_opt_list = GET_CHILD(page, "grade_opt_list", "ui::CDropList");
	local race_opt_list = GET_CHILD(page, "race_opt_list", "ui::CDropList");
	local search_editbox = GET_CHILD(page, "search_editbox");
	local searchText = search_editbox:GetText();

	local monster_list_func = ADVENTURE_BOOK_MONSTER_CONTENT["MONSTER_LIST_ALL"];
	local filter_func = ADVENTURE_BOOK_MONSTER_CONTENT['FILTER_LIST']
	local monster_info_func = ADVENTURE_BOOK_MONSTER_CONTENT["MONSTER_INFO"];

	local monster_list = monster_list_func();
	monster_list = filter_func(monster_list, sort_opt_list:GetSelItemIndex(), grade_opt_list:GetSelItemIndex(), race_opt_list:GetSelItemIndex(), search_editbox:GetText())
	ADVENTURE_BOOK_MONSTER.CUR_LIST_COUNT = (#monster_list)
	local firstIndex, lastIndex = ADVENTURE_BOOK_MONSTER.CUR_GROUP_INDICES()
	for i=1, lastIndex do
		local clsID = monster_list[i]
		local info =  monster_info_func(clsID);
		local height = frame:GetUserConfig("MONSTER_ELEM_HEIGHT")
		local ctrlSet = list_box:CreateOrGetControlSet("adventure_book_monster_elem", "list_mon_" .. i, ui.LEFT, ui.TOP, 0, (i-1)*height, 0, 0);
		local icon = GET_CHILD(ctrlSet, "icon_pic", "ui::CPicture");
		icon:SetImage(info['icon']);
		if info['is_found'] == 0 then
            local SIHOUETTE_COLOR_TONE = frame:GetUserConfig('SIHOUETTE_COLOR_TONE');
			ctrlSet:SetColorTone(SIHOUETTE_COLOR_TONE);
		end
		SET_TEXT(ctrlSet, "name_text", "value", info['name'])        
		ctrlSet:SetUserValue('BtnArg', clsID);
        ADVENTURE_BOOK_MONSTER_SET_GAUGE_AND_POINT(ctrlSet);
	end
end
function ADVENTURE_BOOK_MONSTER.INCREASE_GROUP_INDEX()
	local maxIndex = ADVENTURE_BOOK_MONSTER.MAX_GROUP_INDEX()
	if ADVENTURE_BOOK_MONSTER.SHOW_GROUP_INDEX < maxIndex then
		ADVENTURE_BOOK_MONSTER.SHOW_GROUP_INDEX = ADVENTURE_BOOK_MONSTER.SHOW_GROUP_INDEX + 1;
	end
end
function ADVENTURE_BOOK_MONSTER.MAX_GROUP_INDEX()
	local frame = ui.GetFrame('adventure_book');
	local count = frame:GetUserConfig("LIST_ELEM_COUNT")
	local ret = math.ceil(ADVENTURE_BOOK_MONSTER.CUR_LIST_COUNT / count)
	return ret;
end
function ADVENTURE_BOOK_MONSTER.CUR_GROUP_INDICES()
	local frame = ui.GetFrame('adventure_book');
	local count = frame:GetUserConfig("LIST_ELEM_COUNT")
	local firstIndex = 1+count*(ADVENTURE_BOOK_MONSTER.SHOW_GROUP_INDEX-1);
	local lastIndex = 1+count*(ADVENTURE_BOOK_MONSTER.SHOW_GROUP_INDEX);
	firstIndex = math.min(firstIndex, ADVENTURE_BOOK_MONSTER.CUR_LIST_COUNT)
	lastIndex = math.min(lastIndex, ADVENTURE_BOOK_MONSTER.CUR_LIST_COUNT)
	return firstIndex, lastIndex
end

function ADVENTURE_BOOK_MONSTER.FILL_MONSTER_INFO()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_monster", "ui::CGroupBox");
	local info_box = GET_CHILD(page, "monster_info_gb", "ui::CGroupBox");
	local monster_icon_pic = GET_CHILD(info_box, "monster_icon_pic", "ui::CPicture");
	local monster_attr1 = GET_CHILD(info_box, "monster_attr1", "ui::CControlSet");
	local monster_attr2 = GET_CHILD(info_box, "monster_attr2", "ui::CControlSet");
	local monster_attr3 = GET_CHILD(info_box, "monster_attr3", "ui::CControlSet");
	local kill_count_gauge = GET_CHILD(info_box, "kill_count_gauge", "ui::CGauge");
	local monster_info_place_gb = GET_CHILD(info_box, "monster_info_place_gb");
	
	if ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER == "" then
		return;
	end

	local monster_info_func = ADVENTURE_BOOK_MONSTER_CONTENT["MONSTER_INFO"]
	local place_func = ADVENTURE_BOOK_MONSTER_CONTENT['MONSTER_PLACES']
	local exist_in_history = ADVENTURE_BOOK_MONSTER_CONTENT['EXIST_IN_HISTORY']
	local is_preview_monster = ADVENTURE_BOOK_MONSTER_CONTENT['IS_PREVIEW_MONSTER']

	if exist_in_history(ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER) == 0 then
		if is_preview_monster(ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER) == 1 then
			return;
		end
	end

	local info = monster_info_func(ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER)
	local placeList = place_func(ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER)

	monster_icon_pic:SetImage(info['icon']);
	SET_TEXT(info_box, "monster_name_text", "value", info['name'])

	SET_TEXT(monster_attr1, "attr_name_text", "value", ScpArgMsg('RaceType'))
	SET_TEXT(monster_attr2, "attr_name_text", "value", ScpArgMsg('Attribute'))
	SET_TEXT(monster_attr3, "attr_name_text", "value", ScpArgMsg('MonInfo_ArmorMaterial'))
	monster_info_place_gb:RemoveAllChild();

    local monClassID = ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER;
	if exist_in_history(monClassID) == 1 then
		if NEED_SHOW_ZONE_IN_ADVENTURE_BOOK(monClassID) == true then
			local monGenMapIDList = GetMonGenTypeList(ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER);
			if #monGenMapIDList < 1 then
				for i=1, #placeList do
					local height = frame:GetUserConfig("MONSTER_PLACE_HEIGHT")
					local map_set = monster_info_place_gb:CreateOrGetControlSet("adventure_book_monster_place", "list_map_" .. i, ui.LEFT, ui.TOP, 0, 20+i*height, 0, 0);
					SET_TEXT(map_set, 'map_name_text', 'value', placeList[i])
				end
			else
				for i=1, #monGenMapIDList do
					local height = frame:GetUserConfig("MONSTER_PLACE_HEIGHT")
					local map_set = monster_info_place_gb:CreateOrGetControlSet("adventure_book_monster_place", "list_map_" .. i, ui.LEFT, ui.TOP, 0, 20+i*height, 0, 0);
					local mapCls = GetClassByType('Map', monGenMapIDList[i]);
					if mapCls ~= nil then
						SET_TEXT(map_set, 'map_name_text', 'value', mapCls.Name);
					end
				end
			end
		end
		SET_TEXT(monster_attr1, "attr_value_text", "value", ScpArgMsg(info['race_type']));
		SET_TEXT(monster_attr2, "attr_value_text", "value", ScpArgMsg(info['attribute']))
		SET_TEXT(monster_attr3, "attr_value_text", "value", ScpArgMsg(info['armor_material']))
		
		SET_TEXT(info_box, "monster_info_desc_text", "value", info['desc'])
	else
		SET_TEXT(monster_attr1, "attr_value_text", "value", "")
		SET_TEXT(monster_attr2, "attr_value_text", "value", "")
		SET_TEXT(monster_attr3, "attr_value_text", "value", "")

		SET_TEXT(info_box, "monster_info_desc_text", "value", "")
	end
	ADVENTURE_BOOK_MONSTER_DETAIL_GUAGE_AND_POINT(info_box, ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER);
	ADVENTURE_BOOK_MONSTER.INFO_SLOT_INDEX = 1
	ADVENTURE_BOOK_MONSTER.FILL_MONSTER_INFO_SLOT()
end

function ADVENTURE_BOOK_MONSTER.FILL_MONSTER_INFO_SLOT()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_monster", "ui::CGroupBox");
	local info_box = GET_CHILD(page, "monster_info_gb", "ui::CGroupBox");
	local drop_item_slotset = GET_CHILD(info_box, "drop_item_slotset");
	local left_btn = GET_CHILD(drop_item_slotset, "left_btn");
	local right_btn = GET_CHILD(drop_item_slotset, "right_btn");
	local slotset = GET_CHILD(drop_item_slotset, "slotset");

	left_btn:SetEventScriptArgString(ui.LBUTTONUP, "Monster");    
	right_btn:SetEventScriptArgString(ui.LBUTTONUP, "Monster");

	local drop_item_func = ADVENTURE_BOOK_MONSTER_CONTENT["MONSTER_DROP_ITEM"];
	local dropInfo = drop_item_func(ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER)

	local slotCount = slotset:GetSlotCount();
	local startIndex = (ADVENTURE_BOOK_MONSTER.INFO_SLOT_INDEX-1) * slotCount + 1
	for i = 0, slotCount - 1 do
		local slot = slotset:GetSlotByIndex(i);
		local drop = dropInfo[startIndex+i]
		if drop ~= nil then
			SET_SLOT_IMG(slot, drop['icon'])
			slot:EnableHitTest(1)
			slot:SetEventScript(ui.LBUTTONDOWN, "ON_ADVENTURE_BOOK_SLOT_MONSTER_TO_ITEM");
			slot:SetEventScriptArgNumber(ui.LBUTTONDOWN, drop['item_id']);
		else
			slot:ClearIcon()
		end
	end
end

function ADVENTURE_BOOK_MONSTER.ADJUST_SLOT_INDEX()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_monster", "ui::CGroupBox");
	local info_box = GET_CHILD(page, "monster_info_gb", "ui::CGroupBox");
	local drop_item_slotset = GET_CHILD(info_box, "drop_item_slotset");
	local slotset = GET_CHILD(drop_item_slotset, "slotset");
	local slotCount = slotset:GetSlotCount();

	local drop_item_func = ADVENTURE_BOOK_MONSTER_CONTENT["MONSTER_DROP_ITEM"];
	local dropInfo = drop_item_func(ADVENTURE_BOOK_MONSTER.SELECTED_MONSTER)

	local infoCount = #dropInfo
	local startIndex = (ADVENTURE_BOOK_MONSTER.INFO_SLOT_INDEX-1) * slotCount + 1

	if startIndex > infoCount then
		ADVENTURE_BOOK_MONSTER.INFO_SLOT_INDEX = ADVENTURE_BOOK_MONSTER.INFO_SLOT_INDEX - 1;
	end

	if ADVENTURE_BOOK_MONSTER.INFO_SLOT_INDEX < 1 then
		ADVENTURE_BOOK_MONSTER.INFO_SLOT_INDEX  = 1;
	end
end

function ADVENTURE_BOOK_MONSTER.DROPDOWN_LIST_INIT()
	local frame = ui.GetFrame('adventure_book');
	local page = GET_CHILD(frame, "page_monster", "ui::CGroupBox");
	local sort_opt_list = GET_CHILD(page, "sort_opt_list", "ui::CDropList");
	local grade_opt_list = GET_CHILD(page, "grade_opt_list", "ui::CDropList");
	local race_opt_list = GET_CHILD(page, "race_opt_list", "ui::CDropList");
	
    if sort_opt_list:GetItemCount() > 0 then
        return;
   	end
    sort_opt_list:ClearItems();
    sort_opt_list:AddItem(0, ClMsg('AlignName'));
    sort_opt_list:AddItem(1, ClMsg('ALIGN_ITEM_TYPE_5'));
    sort_opt_list:AddItem(2, ClMsg('ALIGN_ITEM_TYPE_6'));
    
    grade_opt_list:ClearItems();
    grade_opt_list:AddItem(0, ClMsg('Auto_MoDu_BoKi'));
    grade_opt_list:AddItem(1, ClMsg('MonInfo_MonRank_Normal'));
    grade_opt_list:AddItem(2, ClMsg('MonInfo_MonRank_Elite'));
    grade_opt_list:AddItem(3, ClMsg('MonInfo_MonRank_Boss'));

    race_opt_list:ClearItems();
    race_opt_list:AddItem(0, ClMsg('Auto_MoDu_BoKi'));
    race_opt_list:AddItem(1, ClMsg('MonInfo_RaceType_Paramune'));
    race_opt_list:AddItem(2, ClMsg('MonInfo_RaceType_Widling'));
    race_opt_list:AddItem(3, ClMsg('MonInfo_RaceType_Velnias'));
    race_opt_list:AddItem(4, ClMsg('MonInfo_RaceType_Forester'));
    race_opt_list:AddItem(5, ClMsg('MonInfo_RaceType_Klaida'));
end

function ADVENTURE_BOOK_MONSTER_SET_POINT()
    local adventure_book = ui.GetFrame('adventure_book');
    local page_monster = adventure_book:GetChild('page_monster');
    local total_score_text = page_monster:GetChild('total_score_text');
    local totalScore = GET_ADVENTURE_BOOK_MONSTER_POINT();
    total_score_text:SetTextByKey('value', totalScore);
end

function ADVENTURE_BOOK_MONSTER_SET_GAUGE_AND_POINT(ctrlSet)
    local monClsID = ctrlSet:GetUserIValue('BtnArg');
    local monKillCount = GetMonKillCount(pc, monClsID);
    local monCls = GetClassByType('Monster', monClsID);
    if monCls == nil then
        return;
    end

    -- kill count guage
    local curLv, curPoint, curMaxPoint = 0, 0, 0;
    local curScore, maxScore = 0, 0;
    if monCls.MonRank == 'Boss' then    
        curLv, curPoint, curMaxPoint = GET_ADVENTURE_BOOK_MONSTER_KILL_COUNT_INFO(true, monKillCount);
        curScore, maxScore = _GET_ADVENTURE_BOOK_MONSTER_POINT(true, monKillCount);
    else
        curLv, curPoint, curMaxPoint = GET_ADVENTURE_BOOK_MONSTER_KILL_COUNT_INFO(false, monKillCount);
        curScore, maxScore = _GET_ADVENTURE_BOOK_MONSTER_POINT(false, monKillCount);
    end
    local levelText = ctrlSet:GetChild('levelText');
    local score_guage = GET_CHILD(ctrlSet, 'score_guage');
    levelText:SetTextByKey('level', curLv);
    score_guage:SetPoint(curPoint, curMaxPoint);

    -- kill count point
    local score_text = ctrlSet:GetChild('score_text');
    score_text:SetTextByKey('value', curScore);
    score_text:SetTextByKey('maxvalue', maxScore);
end

function ADVENTURE_BOOK_MONSTER_DETAIL_GUAGE_AND_POINT(parentBox, monsterID)    
    local monKillCount = GetMonKillCount(pc, monsterID);
    local monCls = GetClassByType('Monster', monsterID);
    if monCls == nil then
        return;
    end

    -- kill count guage
    local curLv, curPoint, curMaxPoint = 0, 0, 0;
    local curScore, maxScore = 0, 0;
    if monCls.MonRank == 'Boss' then    
        curLv, curPoint, curMaxPoint = GET_ADVENTURE_BOOK_MONSTER_KILL_COUNT_INFO(true, monKillCount);
        curScore, maxScore = _GET_ADVENTURE_BOOK_MONSTER_POINT(true, monKillCount);
    else
        curLv, curPoint, curMaxPoint = GET_ADVENTURE_BOOK_MONSTER_KILL_COUNT_INFO(false, monKillCount);
        curScore, maxScore = _GET_ADVENTURE_BOOK_MONSTER_POINT(false, monKillCount);
    end
    
    local my_score_text = parentBox:GetChild('my_score_text');
    local kill_count_gauge = GET_CHILD(parentBox, 'kill_count_gauge');
    my_score_text:SetTextByKey('value', curScore);
    my_score_text:SetTextByKey('maxValue', maxScore);
    kill_count_gauge:SetPoint(curPoint, curMaxPoint);
end

function NEED_SHOW_ZONE_IN_ADVENTURE_BOOK(monsterClassID)
    local monCls = GetClassByType('Monster', monsterClassID);
    if monCls ~= nil and monCls.Boss_UseZone == 'NotZone' then
        return false;
    end
    return true;
end