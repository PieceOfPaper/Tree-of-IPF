ADVENTURE_BOOK_MAP = {};
ADVENTURE_BOOK_MAP.SELECTED_REGION = "";
ADVENTURE_BOOK_MAP.SELECTED_MAP = "";
ADVENTURE_BOOK_MAP.LIST_POS_Y = 0;

function ADVENTURE_BOOK_MAP.RENEW()
	ADVENTURE_BOOK_MAP.CLEAR();
	ADVENTURE_BOOK_MAP.TOTAL_RATE_TEXT();
	ADVENTURE_BOOK_MAP.DROPDOWN_LIST_INIT();
    ADVENTURE_BOOK_MAP_SET_POINT();
	
	local region_list_func = ADVENTURE_BOOK_MAP_CONTENT["REGION_LIST"];
	local region_list = region_list_func();
	if #region_list < 1 then
		return;
	end
	ADVENTURE_BOOK_MAP.SELECTED_REGION = region_list[1]
	ADVENTURE_BOOK_MAP.FILL_REGION_LIST()


	local map_list_func = ADVENTURE_BOOK_MAP_CONTENT['MAP_LIST_BY_REGION_NAME']
	local map_list = map_list_func(ADVENTURE_BOOK_MAP.SELECTED_REGION);
	if #map_list < 1 then
		return;
	end

	ADVENTURE_BOOK_MAP.SELECTED_MAP = map_list[1]
	ADVENTURE_BOOK_MAP.FILL_MAP_INFO()
	ADVENTURE_BOOK_MAP.DRAW_MINIMAP(ADVENTURE_BOOK_MAP.SELECTED_MAP)
end

function ADVENTURE_BOOK_MAP.TOTAL_RATE_TEXT()
	local frame = ui.GetFrame('adventure_book');
	local page_explore = GET_CHILD(frame, "page_explore", "ui::CGroupBox");
	local total_rate_text = GET_CHILD(page_explore, "total_rate_text", "ui::CGroupBox");
    total_rate_text:ShowWindow(1);
	local total_rate_func = ADVENTURE_BOOK_MAP_CONTENT['TOTAL_MAP_REVEAL_RATE']
	local total_rate = total_rate_func();
	SET_TEXT(page_explore, "total_rate_text", "value", total_rate)
end

function ADVENTURE_BOOK_MAP.CLEAR()
	local frame = ui.GetFrame('adventure_book');
	local page_explore = GET_CHILD(frame, "page_explore", "ui::CGroupBox");
	local page = GET_CHILD(page_explore, "page_map", "ui::CGroupBox");
	local map_list = GET_CHILD(page, "map_list", "ui::CGroupBox");
	map_list:RemoveAllChild();
end

function ADVENTURE_BOOK_MAP.FILL_REGION_LIST()
	local frame = ui.GetFrame('adventure_book');
	local page_explore = GET_CHILD(frame, "page_explore", "ui::CGroupBox");
	local page = GET_CHILD(page_explore, "page_map", "ui::CGroupBox");
	local map_list_gb = GET_CHILD(page, "map_list", "ui::CGroupBox");
	local search_editbox = GET_CHILD(page, "search_editbox");
	map_list_gb:RemoveAllChild();

	local region_list_func = ADVENTURE_BOOK_MAP_CONTENT['REGION_LIST']
	local region_info_func = ADVENTURE_BOOK_MAP_CONTENT['REGION_INFO']

	local sizeofctrl = frame:GetUserConfig("REGION_ELEM_HEIGHT")

	local region_list = region_list_func();
	ADVENTURE_BOOK_MAP.LIST_POS_Y = 5;

	local searchText = search_editbox:GetText();
	for i=1, #region_list do
		local ctrlSet = map_list_gb:CreateOrGetControlSet('adventure_book_map_region', "region_" .. i, ui.LEFT, ui.TOP, 5, ADVENTURE_BOOK_MAP.LIST_POS_Y, 0, 0);
		ctrlSet = tolua.cast(ctrlSet, 'ui::CControlSet');
    	local ARROW_OPEN = ctrlSet:GetUserConfig('ARROW_OPEN');
    	local ARROW_CLOSE = ctrlSet:GetUserConfig('ARROW_CLOSE');

		local region_info = region_info_func(region_list[i])
		ctrlSet:SetUserValue('BtnArg', region_list[i]);
		SET_TEXT(ctrlSet, "name", "value", region_info['name'])
		SET_TEXT(ctrlSet, "percent", "value", ARROW_OPEN)

		ADVENTURE_BOOK_MAP.LIST_POS_Y = ADVENTURE_BOOK_MAP.LIST_POS_Y + sizeofctrl;

		if ADVENTURE_BOOK_MAP.SELECTED_REGION == region_list[i]  then
			ADVENTURE_BOOK_MAP.FILL_MAP_LIST(region_list[i], i)
			SET_TEXT(ctrlSet, "percent", "value", ARROW_CLOSE)
		elseif searchText ~= nil and searchText ~= '' then
			ADVENTURE_BOOK_MAP.FILL_MAP_LIST(region_list[i], i)
		end
	end
end

function ADVENTURE_BOOK_MAP.FILL_MAP_LIST(regionName, regionIndex)
	local frame = ui.GetFrame('adventure_book');
	local page_explore = GET_CHILD(frame, "page_explore", "ui::CGroupBox");
	local page = GET_CHILD(page_explore, "page_map", "ui::CGroupBox");
	local map_list_gb = GET_CHILD(page, "map_list", "ui::CGroupBox");
	local sort_opt_list = GET_CHILD(page, "sort_opt_list", "ui::CDropList");
	local state_opt_list = GET_CHILD(page, "state_opt_list", "ui::CDropList");
	local search_editbox = GET_CHILD(page, "search_editbox");

	local region_list_func = ADVENTURE_BOOK_MAP_CONTENT['REGION_LIST']
	local map_list_func = ADVENTURE_BOOK_MAP_CONTENT['MAP_LIST_BY_REGION_NAME']
	local map_info_func = ADVENTURE_BOOK_MAP_CONTENT['MAP_INFO']
	local filter_func = ADVENTURE_BOOK_MAP_CONTENT['FILTER_LIST']

	local map_list = map_list_func(regionName);
	map_list = filter_func(map_list, sort_opt_list:GetSelItemIndex(), state_opt_list:GetSelItemIndex(), search_editbox:GetText())

	if #map_list == 0 then
		return;
	end

	local sizeofctrl = frame:GetUserConfig("MAP_ELEM_HEIGHT")
	for i=1, #map_list do
		local ctrlSet = map_list_gb:CreateOrGetControlSet('adventure_book_map_map', "map_" .. regionIndex .. "_".. i, ui.LEFT, ui.TOP, 20, ADVENTURE_BOOK_MAP.LIST_POS_Y, 0, 0);
		local map_name_text = GET_CHILD(ctrlSet, "name", "ui::CRichText");
		local map_percent_text = GET_CHILD(ctrlSet, "percent", "ui::CRichText");
		local map_info = map_info_func(map_list[i]);
		local visited_font = frame:GetUserConfig('MAP_VISITED_FONT')
		local not_visited_font = frame:GetUserConfig('MAP_NOT_VISITED_FONT')
		
		if map_info['is_visited'] == 1 then
			map_name_text:SetFontName(visited_font);
			map_percent_text:SetFontName(visited_font);
		else
			map_name_text:SetFontName(not_visited_font);
			map_percent_text:SetFontName(not_visited_font);
		end
                
		SET_TEXT(ctrlSet, "name", "value", map_info['name'])
		SET_TEXT(ctrlSet, "percent", "value", map_info['rate_text'])
        SET_TEXT(ctrlSet, "percent", "reward", ADVENTURE_BOOK_MAP_GET_MAP_REWARD_STRING(frame, map_list[i]));
		ctrlSet:SetUserValue('BtnArg', map_list[i]);

		ADVENTURE_BOOK_MAP.LIST_POS_Y = ADVENTURE_BOOK_MAP.LIST_POS_Y + sizeofctrl;
	end
end

function ADVENTURE_BOOK_MAP.FILL_MAP_INFO()
	local frame = ui.GetFrame('adventure_book');
	local page_explore = GET_CHILD(frame, "page_explore", "ui::CGroupBox");
	local page = GET_CHILD(page_explore, "page_map", "ui::CGroupBox");
	local map_list_gb = GET_CHILD(page, "map_info_gb", "ui::CGroupBox");
	
	if ADVENTURE_BOOK_MAP.SELECTED_MAP == "" then
		return;
	end

	local map_info_func = ADVENTURE_BOOK_MAP_CONTENT['MAP_INFO']
	local map_info = map_info_func(ADVENTURE_BOOK_MAP.SELECTED_MAP)

	SET_TEXT(map_list_gb, "name_text", "value", map_info['name'])
	SET_TEXT(map_list_gb, "star_text", "value", map_info['difficulty'])
	SET_TEXT(map_list_gb, "level_text", "value", map_info['level'])
	SET_TEXT(map_list_gb, "rate_text", "value", map_info['rate'])

end

function ADVENTURE_BOOK_MAP.DROPDOWN_LIST_INIT()
	local frame = ui.GetFrame('adventure_book');
	local page_explore = GET_CHILD(frame, "page_explore", "ui::CGroupBox");
	local page = GET_CHILD(page_explore, "page_map", "ui::CGroupBox");
	local sort_opt_list = GET_CHILD(page, "sort_opt_list", "ui::CDropList");
	local state_opt_list = GET_CHILD(page, "state_opt_list", "ui::CDropList");
	
    if sort_opt_list:GetItemCount() > 0 then
        return;
    end
    sort_opt_list:ClearItems();
    sort_opt_list:AddItem(0, ClMsg('ALIGN_ITEM_TYPE_5'));
    sort_opt_list:AddItem(1, ClMsg('ALIGN_ITEM_TYPE_6'));
    
    state_opt_list:ClearItems();
    state_opt_list:AddItem(0, ClMsg('Auto_MoDu_BoKi'));
    state_opt_list:AddItem(1, ClMsg('Complete'));
    state_opt_list:AddItem(2, ClMsg('Auto_MiHwagin_'));
    state_opt_list:AddItem(3, ClMsg('NotComplete'));
end

function ADVENTURE_BOOK_MAP.DRAW_MINIMAP(selectedMapID)
    local mapCls = GetClassByType('Map', selectedMapID);
    if mapCls == nil then
        return;
    end

    local adventure_book = ui.GetFrame('adventure_book');
    local mappic_gb = GET_CHILD_RECURSIVELY(adventure_book, 'mappic_gb');
    local INDUN_DETAIL_MINIMAP_SKIN = adventure_book:GetUserConfig('INDUN_DETAIL_MINIMAP_SKIN');
	local MINIMAP_WIDTH = adventure_book:GetUserConfig('MINIMAP_WIDTH');
	local MINIMAP_HEIGHT = adventure_book:GetUserConfig('MINIMAP_HEIGHT');
    mappic_gb:RemoveAllChild();
	mappic_gb:SetSkinName(INDUN_DETAIL_MINIMAP_SKIN)

    local ctrlSet = mappic_gb:CreateControlSet("worldmap_tooltip", "MAP_" .. selectedMapID, ui.CENTER_HORZ, ui.CENTER_VERT, 0, 0, 0, 0);
    ctrlSet = AUTO_CAST(ctrlSet);
    ctrlSet:EnableHitTest(0);
    ctrlSet:Resize(MINIMAP_WIDTH, MINIMAP_HEIGHT);
    ctrlSet:SetSkinName("None");

	local ratestr = ""
	if 0 ~= MAP_USE_FOG(mapCls.ClassName) and session.GetMapFogRevealRate(mapCls.ClassName) >= 100 then
		ratestr = " {img minimap_complete 24 24}"
	end

	local mapnameCtrl = ctrlSet:GetChild("mapname");
    mapnameCtrl:ShowWindow(0);
		
	local drawMapName = mapCls.ClassName;
	local pic = GET_CHILD(ctrlSet, "map", "ui::CPicture");
    pic:SetOffset(0, 0);
    pic:Resize(ctrlSet:GetWidth(), ctrlSet:GetHeight());
	local mapimage = ui.GetImage(drawMapName .. "_fog");
	if mapimage == nil then
		world.PreloadMinimap(drawMapName);
	end
	pic:SetImage(drawMapName .. "_fog");
		
	local iconGroup = ctrlSet:CreateControl("groupbox", "MapIconGroup", 0, 0, mappic_gb:GetWidth(), mappic_gb:GetHeight());
	iconGroup:SetSkinName("None");
		
	local nameGroup = ctrlSet:CreateControl("groupbox", "RegionNameGroup", 0, 0, mappic_gb:GetWidth(), mappic_gb:GetHeight());
	nameGroup:SetSkinName("None");

	local mapWidth = pic:GetWidth();
	local mapHeight = pic:GetHeight();

	local offsetX = 450;
	local offsetY = 210;

	-- 여기서 npc 세팅해줌
    if MAKE_INDUN_ICON ~= nil then
	    MAKE_INDUN_ICON(iconGroup, drawMapName, indunCls, mapWidth, mapHeight, offsetX, offsetY);
    end
	pic:EnableCopyOtherImage(nil);
	
	local worldMapWidth = 0;
	local worldMapHeight = 0;
	local worldmapFrame =  ui.GetFrame("worldmap");
	if worldmapFrame ~= nil then
		worldMapWidth = worldmapFrame:GetWidth()
		worldMapHeight = worldmapFrame:GetHeight()
	end
		
	for i = 0, iconGroup:GetChildCount()-1 do
		local child = iconGroup:GetChildByIndex(i);
			
		child:Move( -1*worldMapWidth*(23/100), 0);
		child:Move( 0, -1*mapHeight*(40/100));
	end
		
	for i = 0, nameGroup:GetChildCount()-1 do
		local child = nameGroup:GetChildByIndex(i);	
			
		child:Move( -1*worldMapWidth*(23/100), 0);
		child:Move( 0, -1*mapHeight*(40/100));
	end

	ctrlSet:GetChild("monlv"):SetVisible(0)

    -- map fog
    MAKE_MAP_FOG_PICTURE(drawMapName, pic, true);
    if UPDATE_MAP_FOG_RATE ~= nil then
	    UPDATE_MAP_FOG_RATE(ctrlSet, drawMapName);
    end
end

function ADVENTURE_BOOK_MAP_SET_POINT()
    local adventure_book = ui.GetFrame('adventure_book');
    local page_explore = adventure_book:GetChild('page_explore');
    local total_rate_text = page_explore:GetChild('total_rate_text');
    local total_score_text = page_explore:GetChild('total_score_text');
    total_rate_text:ShowWindow(1);
    total_score_text:SetTextByKey('value', GET_ADVENTURE_BOOK_MAP_POINT());
end

function ADVENTURE_BOOK_MAP_GET_MAP_REWARD_STRING(frame, mapID)
    local str = '';
    local etc = GetMyEtcObject();    
    local mapCls = GetClassByType('Map', mapID);
    if mapCls ~= nil and etc ~= nil and GetPropType(etc, 'Reward_'..mapCls.ClassName) ~= nil then        
        local MAP_REWARD_OPEN = frame:GetUserConfig('MAP_REWARD_OPEN');
        local MAP_REWARD_CLOSE = frame:GetUserConfig('MAP_REWARD_CLOSE');
        local IMG_SIZE = 24;
        if etc['Reward_'..mapCls.ClassName] > 0 then
            str = string.format('{img %s %d %d} ', MAP_REWARD_OPEN, IMG_SIZE, IMG_SIZE);
        else
            str = string.format('{img %s %d %d} ', MAP_REWARD_CLOSE, IMG_SIZE, IMG_SIZE);
        end
    end
    return str;
end