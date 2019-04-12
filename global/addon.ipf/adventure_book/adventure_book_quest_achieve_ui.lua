ADVENTURE_BOOK_QUEST_ACHIEVE = {};
ADVENTURE_BOOK_QUEST_ACHIEVE.SELECTED_QUEST = "";
ADVENTURE_BOOK_QUEST_ACHIEVE.SELECTED_ACHIEVE = "";

function ADVENTURE_BOOK_QUEST_ACHIEVE.RENEW()
	ADVENTURE_BOOK_QUEST_ACHIEVE.CLEAR();
	ADVENTURE_BOOK_QUEST_ACHIEVE.FILL_QUEST_LIST();
	ADVENTURE_BOOK_QUEST_ACHIEVE.FILL_ACHIEVE_LIST();
    ADVENTURE_BOOK_QUEST_ACHIEVE_INIT_POINT();
end

function ADVENTURE_BOOK_QUEST_ACHIEVE.CLEAR()
	local frame = ui.GetFrame('adventure_book');
	local page_explore = GET_CHILD(frame, "page_explore", "ui::CGroupBox");
	local page = GET_CHILD(page_explore, "page_quest_and_achieve", "ui::CGroupBox");
	local page_quest = GET_CHILD(page, "page_quest", "ui::CGroupBox");
	local page_achieve = GET_CHILD(page, "page_achieve", "ui::CGroupBox");
	local quest_list_box = GET_CHILD_RECURSIVELY(page_quest, "quest_list", "ui::CGroupBox");
	local achieve_list_box = GET_CHILD(page_achieve, "achieve_list", "ui::CGroupBox");
	quest_list_box:RemoveAllChild();
	achieve_list_box:RemoveAllChild();
end

function ADVENTURE_BOOK_QUEST_ACHIEVE.FILL_QUEST_LIST()
	local frame = ui.GetFrame('adventure_book');
	local page_explore = GET_CHILD(frame, "page_explore", "ui::CGroupBox");
	local page = GET_CHILD(page_explore, "page_quest_and_achieve", "ui::CGroupBox");
	local page_quest = GET_CHILD(page, "page_quest", "ui::CGroupBox");
    ADVENTURE_BOOK_QUEST_INIT_REGION(page_quest);
    ADVENTURE_BOOK_QUEST_DROPLIST_INIT(page_quest);
    ADVENTURE_BOOK_QUEST_INIT_POINT(page_quest);
end

function ADVENTURE_BOOK_QUEST_ACHIEVE.FILL_ACHIEVE_LIST()
	local frame = ui.GetFrame('adventure_book');
	local page_explore = GET_CHILD(frame, "page_explore", "ui::CGroupBox");
	local page = GET_CHILD(page_explore, "page_quest_and_achieve", "ui::CGroupBox");
	local page_achieve = GET_CHILD(page, "page_achieve", "ui::CGroupBox");
	local achieve_list_box = GET_CHILD(page_achieve, "achieve_list", "ui::CGroupBox");
	achieve_list_box:RemoveAllChild();
	
	local list_func = ADVENTURE_BOOK_QUEST_ACHIEVE_CONTENT["ACHIEVE_LIST"];
	local info_func = ADVENTURE_BOOK_QUEST_ACHIEVE_CONTENT["ACHIEVE_INFO"];

	local list = list_func();
	local y = 0;
	local height = frame:GetUserConfig("QUEST_ELEM_HEIGHT")
    local showCount = math.min(5, #list);
	for i = 1, showCount do
		local clsID = list[i]
		local info =  info_func(clsID)
		if info['is_valid_achieve'] == 1 then
			local ctrlSet = achieve_list_box:CreateOrGetControlSet("adventure_book_text_elem", "list_achieve_" .. i, ui.LEFT, ui.TOP, 0, y, 0, 0);
            local timeStr = string.format("%04d.%02d.%02d", info['year'], info['month'], info['day']); -- yyyy.mm.dd
			SET_TEXT(ctrlSet, "text", "value", info['name']);
            SET_TEXT(ctrlSet, 'timeText', 'time', timeStr);
			ctrlSet:SetUserValue('BtnArg', clsID);
			y = y + height;            
		end
	end
end

function ADVENTURE_BOOK_QUEST_ACHIEVE_INIT_POINT()
    local adventure_book = ui.GetFrame('adventure_book');
    local page_quest = GET_CHILD_RECURSIVELY(adventure_book, 'page_quest');
    local page_achieve = GET_CHILD_RECURSIVELY(adventure_book, 'page_achieve');
    ADVENTURE_BOOK_CONTENTS_SET_POINT(adventure_book);
    ADVENTURE_BOOK_QUEST_INIT_POINT(page_quest);
    ADVENTURE_BOOK_ACHIEVE_INIT_POINT(page_achieve);
end

function ADVENTURE_BOOK_CONTENTS_SET_POINT(adventure_book)
    local page_explore = adventure_book:GetChild('page_explore');
    local total_rate_text = page_explore:GetChild('total_rate_text');
    local total_score_text = page_explore:GetChild('total_score_text');
    total_rate_text:ShowWindow(0);
    total_score_text:SetTextByKey('value', GET_ADVENTURE_BOOK_CONTENTS_POINT());
end

function ADVENTURE_BOOK_ACHIEVE_INIT_POINT(page_achieve)
    local score_text = GET_CHILD_RECURSIVELY(page_achieve, 'score_text');
    score_text:SetTextByKey('value', GET_ADVENTURE_BOOK_ACHIEVE_POINT());
end

function ADVENTURE_BOOK_QUEST_INIT_REGION(page_quest)
    local frame = page_quest:GetTopParentFrame();
    local quest_list = GET_CHILD_RECURSIVELY(frame, 'quest_list');
    local region_list_func = ADVENTURE_BOOK_MAP_CONTENT['REGION_LIST'];
	local region_info_func = ADVENTURE_BOOK_MAP_CONTENT['REGION_INFO'];
	local sizeofctrl = frame:GetUserConfig("REGION_ELEM_HEIGHT");
	local region_list = region_list_func();
    quest_list:RemoveAllChild();
    
    
    local questzoneList = SCR_QUEST_SHOW_ZONE_LIST(page_quest)
    local map_list_func = ADVENTURE_BOOK_MAP_CONTENT['MAP_LIST_BY_REGION_NAME'];
	for i=1, #region_list do
        local regionName = region_list[i];
        
        local map_list = map_list_func(regionName);	
        local flag = 0
        for i = 1, #map_list do
            local mapID = map_list[i];
            local mapCls = GetClassByType('Map', mapID); 
            if table.find(questzoneList, mapCls.ClassName) ~= 0 then
                flag = 1
                break
            end
        end
        
        if flag == 1 then
    		local region_info = region_info_func(regionName);
    		local ctrlSet = quest_list:CreateOrGetControlSet('adventure_book_map_region', "QUEST_REGION_" .. regionName, 0, 0);
    		ADVENTURE_BOOK_QEUST_INIT_REGION_CTRLSET(ctrlSet, regionName);
    	end
	end
    GBOX_AUTO_ALIGN(quest_list, 0, 0, 0, true, false);
end

function ADVENTURE_BOOK_QEUST_INIT_REGION_CTRLSET(ctrlSet, regionName, isSearchMode)
    ctrlSet = tolua.cast(ctrlSet, 'ui::CControlSet');
    local ARROW_OPEN = ctrlSet:GetUserConfig('ARROW_OPEN');
	ctrlSet:SetUserValue('REGION_NAME', regionName);                

	SET_TEXT(ctrlSet, "name", "value", regionName);
    if isSearchMode == true then
        local ARROW_CLOSE = ctrlSet:GetUserConfig('ARROW_CLOSE');
	    SET_TEXT(ctrlSet, "percent", "value", ARROW_CLOSE);
    else
        local gb = ctrlSet:GetChild('gb');
        gb:SetEventScript(ui.LBUTTONUP, 'ADVENTURE_BOOK_QEUST_CLICK_REGION');
	    SET_TEXT(ctrlSet, "percent", "value", ARROW_OPEN);
    end
end

function ADVENTURE_BOOK_QEUST_CLICK_REGION(parent, gb)
    local ctrlSet = gb:GetParent();
    ctrlSet = AUTO_CAST(ctrlSet);
    local regionName = ctrlSet:GetUserValue('REGION_NAME');

    -- select style
    local topFrame = parent:GetTopParentFrame();
    local preSelectRegion = topFrame:GetUserValue('SELECTED_QUEST_REGION');    
    local ARROW_OPEN = ctrlSet:GetUserConfig('ARROW_OPEN');
    local ARROW_CLOSE = ctrlSet:GetUserConfig('ARROW_CLOSE');
    local prevCtrlSet = GET_CHILD_RECURSIVELY(topFrame, 'QUEST_REGION_'..preSelectRegion);
    if prevCtrlSet ~= nil then
        SET_TEXT(prevCtrlSet, "percent", "value", ARROW_OPEN)        
    end
    topFrame:SetUserValue('SELECTED_QUEST_REGION', regionName);
    if regionName ~= preSelectRegion then
        SET_TEXT(ctrlSet, "percent", "value", ARROW_CLOSE);
    end

    -- make map
    local quest_list = GET_CHILD_RECURSIVELY(topFrame, 'quest_list');
    if quest_list:GetChild('questMapBox') ~= nil then
        quest_list:RemoveChild('questMapBox');
    end
    GBOX_AUTO_ALIGN(quest_list, 0, 0, 0, true, false);
    if regionName == preSelectRegion then
        topFrame:SetUserValue('SELECTED_QUEST_REGION', 'None');
        return;
    end
    ADVENTURE_BOOK_QUEST_INIT_MAP(quest_list, ctrlSet, regionName);    
end

function SCR_QUEST_SHOW_ZONE_LIST(nowframe)
    local questList, cnt = GetClassList('QuestProgressCheck');
    local topFrame = nowframe:GetTopParentFrame();
    local questSearchEdit = GET_CHILD_RECURSIVELY(topFrame, 'questSearchEdit');
    local searchText = questSearchEdit:GetText();
    local zoneList = {}
    
    for index = 0, cnt - 1 do
        local questCls = GetClassByIndexFromList(questList, index);
        if table.find(zoneList, questCls.StartMap) == 0 then
            if questCls.Level ~= 9999 then
                if questCls.Lvup ~= -9999 then
                    if questCls.PeriodInitialization == 'None' then
                        local questMode = questCls.QuestMode;
                        if questMode ~= 'KEYITEM' and questMode ~= 'PARTY' then
                            local questCateDrop = GET_CHILD_RECURSIVELY(topFrame, 'questCateDrop');
                            local cateIndex = questCateDrop:GetSelItemIndex();
                            if cateIndex == 0 or (cateIndex == 1 and questCls.QuestMode == 'MAIN') or (cateIndex == 2 and questCls.QuestMode == 'SUB') or (cateIndex == 3 and questCls.QuestMode ~= 'MAIN' and questCls.QuestMode ~= 'SUB') then
                                local questLevelDrop = GET_CHILD_RECURSIVELY(topFrame, 'questLevelDrop');
                                local lvIndex = questLevelDrop:GetSelItemIndex();    
                                if math.floor(questCls.Level / 100) == lvIndex then
                                    if searchText == '' or string.find(dic.getTranslatedStr(questCls.Name), searchText) ~= nil then
                                        zoneList[#zoneList + 1] = questCls.StartMap
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    return zoneList
end

function ADVENTURE_BOOK_QUEST_INIT_MAP(quest_list, ctrlSet, regionName)
    local map_list_func = ADVENTURE_BOOK_MAP_CONTENT['MAP_LIST_BY_REGION_NAME'];
	local map_list = map_list_func(regionName);	
    local mapCount = #map_list;
    if mapCount < 1 then
        return;
    end

    local width = ctrlSet:GetWidth();
    
    local questMapBox = ADVENTURE_BOOK_QUEST_CREATE_MAP_BOX(quest_list, width, 'questMapBox');    
    
    local questzoneList = SCR_QUEST_SHOW_ZONE_LIST(questMapBox)
    
    
    
    for i = 1, mapCount do
        local mapID = map_list[i];
        local mapCls = GetClassByType('Map', mapID); 
        if table.find(questzoneList, mapCls.ClassName) ~= 0 then
            local quest_tree = ADVENTURE_BOOK_QUEST_CREATE_MAP_QUEST_TREE(questMapBox, mapCls);
        end
    end
    ADVENTURE_BOOK_QUEST_REALIGN(quest_list:GetTopParentFrame(), ctrlSet);
end

function ADVENTURE_BOOK_QUEST_CREATE_MAP_QUEST_TREE(questMapBox, mapCls, isSearchMode)
    local quest_tree = questMapBox:CreateOrGetControlSet('quest_tree', 'QUEST_MAP_'..mapCls.ClassID, 0, 0);      
    local text = quest_tree:GetChild('text');
    text:SetText(mapCls.Name);
    if isSearchMode == true then
        quest_tree = AUTO_CAST(quest_tree);
        local EXPAND_ON_IMG = quest_tree:GetUserConfig('EXPAND_ON_IMG');
        local expandBtn = GET_CHILD(quest_tree, 'expandBtn');
        expandBtn:SetImage(EXPAND_ON_IMG);
    else
        quest_tree:SetUserValue('QUEST_MAP_CLASS_NAME', mapCls.ClassName);
    end
    return quest_tree;
end

function ADVENTURE_BOOK_QUEST_CREATE_MAP_BOX(quest_list, width, name)
    local questMapBox = quest_list:CreateControl('groupbox', name, 0, 0, width, 0);    
    questMapBox = tolua.cast(questMapBox, 'ui::CGroupBox');
    questMapBox:EnableDrawFrame(0);
    questMapBox:EnableScrollBar(0);
    return questMapBox;
end

function QUEST_TREE_CLICK(ctrlSet, ctrl)    
    local mapClassName = ctrlSet:GetUserValue('QUEST_MAP_CLASS_NAME');
    -- expand toggle
    ctrlSet = AUTO_CAST(ctrlSet);
    local EXPAND_ON_IMG = ctrlSet:GetUserConfig('EXPAND_ON_IMG');
    local EXPAND_OFF_IMG = ctrlSet:GetUserConfig('EXPAND_OFF_IMG');
    local expandBtn = GET_CHILD(ctrlSet, 'expandBtn');
    local isExpand = ctrlSet:GetUserIValue('IS_EXPAND');    
    if isExpand == 0 then -- 닫혀 있던 경우
        local expandBox = ADVENTURE_BOOK_QUEST_CREATE_QUEST_EXPAND_BOX(ctrlSet, expandBtn);
        ADVENTURE_BOOK_QUEST_FILL_QUEST_BY_MAP(expandBox, mapClassName);        
        ctrlSet:Resize(ctrlSet:GetWidth(), expandBox:GetY() + expandBox:GetHeight());

        expandBtn:SetImage(EXPAND_ON_IMG);
        ctrlSet:SetUserValue('IS_EXPAND', 1);
    else -- 열려 있던 경우
        ctrlSet:RemoveChild('EXPAND_BOX');
        ctrlSet:Resize(ctrlSet:GetWidth(), ctrlSet:GetOriginalHeight());

        expandBtn:SetImage(EXPAND_OFF_IMG);
        ctrlSet:SetUserValue('IS_EXPAND', 0);
    end
    ADVENTURE_BOOK_QUEST_REALIGN(ctrlSet:GetTopParentFrame());
end

function ADVENTURE_BOOK_QUEST_CREATE_QUEST_EXPAND_BOX(ctrlSet, expandBtn)
    local expandBox = ctrlSet:CreateControl('groupbox', 'EXPAND_BOX', 20, expandBtn:GetY() + expandBtn:GetHeight(), ctrlSet:GetWidth() - 20, 100);
    expandBox = AUTO_CAST(expandBox);
    expandBox:EnableDrawFrame(0);
    expandBox:EnableHitTest(1);
    expandBox:EnableScrollBar(0);
    return expandBox;
end

function ADVENTURE_BOOK_QUEST_REALIGN(frame, ctrlSet)
    local questMapBox = GET_CHILD_RECURSIVELY(frame, 'questMapBox');
    if questMapBox == nil then
        return;
    end

    -- realign
    GBOX_AUTO_ALIGN(questMapBox, 0, 0, 0, false, true);    
    local regionName = frame:GetUserValue('SELECTED_QUEST_REGION');
    if ctrlSet == nil then
        ctrlSet = GET_CHILD_RECURSIVELY(frame, 'QUEST_REGION_'..regionName);
    end    
    if ctrlSet == nil then
        return;
    end

    local regionCtrlSetHeight = ctrlSet:GetHeight();
    questMapBox:SetOffset(ctrlSet:GetX(), ctrlSet:GetY() + regionCtrlSetHeight);    
    local quest_list = GET_CHILD_RECURSIVELY(frame, 'quest_list');
    local addOffsetY = questMapBox:GetHeight();
    local childIndex = quest_list:GetChildIndex('QUEST_REGION_'..regionName);
    local childCount = quest_list:GetChildCount();
    for i = childIndex + 1, childCount - 1 do
        local child = quest_list:GetChildByIndex(i);
        if string.find(child:GetName(), 'QUEST_REGION_') ~= nil then
            child:SetOffset(child:GetX(), regionCtrlSetHeight * (i - 1) + addOffsetY);        
        end
    end
end

function ADVENTURE_BOOK_QUEST_FILL_QUEST_BY_MAP(expandBox, mapClassName)    
    if mapClassName == 'None' then
        return;
    end
    expandBox:RemoveAllChild();
    local topFrame = expandBox:GetTopParentFrame();
    local QUEST_EVEN_BG_SKIN = topFrame:GetUserConfig('QUEST_EVEN_BG_SKIN');
    local questSearchEdit = GET_CHILD_RECURSIVELY(topFrame, 'questSearchEdit');
    local searchText = questSearchEdit:GetText();

    local showCnt = 0;
    local questList, cnt = GetClassList('QuestProgressCheck');
    for i = 0, cnt - 1 do
        local questCls = GetClassByIndexFromList(questList, i);
        if IS_QUEST_NEED_TO_SHOW(topFrame, questCls, mapClassName, searchText) == true then
            local questID = questCls.ClassID;
            local ctrlSet = ADVENTURE_BOOK_QUEST_CREATE_QUEST_CTRLSET(expandBox, questCls);

            -- skin
            showCnt = showCnt + 1;
            if showCnt % 2 == 0 then
                local bg = ctrlSet:GetChild('bg');
                bg:SetSkinName(QUEST_EVEN_BG_SKIN);
            end
        end
    end
    GBOX_AUTO_ALIGN(expandBox, 0, 0, 0, false, true);
end

function ADVENTURE_BOOK_QUEST_CREATE_QUEST_CTRLSET(expandBox, questCls)
    local ctrlSet = expandBox:CreateOrGetControlSet('adventure_book_quest', 'QUEST_'..questCls.ClassID, 0, 0);
    local name = ctrlSet:GetChild('name');
    name:SetText(GET_QUEST_NAME(questCls));

    local questIconImgName = GET_ICON_BY_STATE_MODE('POSSIBLE', questCls);    
    local pic = GET_CHILD(ctrlSet, 'pic');
    pic:SetImage(questIconImgName);

    ctrlSet:SetUserValue('QUEST_CLASS_ID', questCls.ClassID);    
    return ctrlSet;
end


function GET_QUEST_NAME(questIES)
    local nametext = '';
    local questMode = questIES.QuestMode;
    if questMode == 'MAIN' then
		nametext = QUEST_TITLE_FONT..'{#FF6600}'..questIES.Name;
    elseif questMode == 'SUB' then
        nametext = QUEST_TITLE_FONT..'{#0066FF}'..questIES.Name;    
	else
		nametext = QUEST_TITLE_FONT..questIES.Name;
	end
    return nametext;
end

function IS_QUEST_NEED_TO_SHOW(frame, questCls, mapName, searchText)
    if mapName ~= nil and questCls.StartMap ~= mapName then
        return false;
    end 
    if questCls.Level == 9999 then
        return false;
    end
    if questCls.Lvup == -9999 then
        return false;
    end

    if questCls.PeriodInitialization ~= 'None' then
        return false;
    end

    local questMode = questCls.QuestMode;
    if questMode == 'KEYITEM' or questMode == 'PARTY' then
        return false;
    end

    local questCateDrop = GET_CHILD_RECURSIVELY(frame, 'questCateDrop');
    local cateIndex = questCateDrop:GetSelItemIndex();
    if cateIndex == 1 and questCls.QuestMode ~= 'MAIN' then -- main
        return false;
    elseif cateIndex == 2 and questCls.QuestMode ~= 'SUB' then -- sub
        return false;
    elseif cateIndex == 3 and (questCls.QuestMode == 'MAIN' or questCls.QuestMode == 'SUB') then -- etc
        return false;
    end

    local questLevelDrop = GET_CHILD_RECURSIVELY(frame, 'questLevelDrop');
    local lvIndex = questLevelDrop:GetSelItemIndex();    
    if math.floor(questCls.Level / 100) ~= lvIndex then
        return false;
    end

    if searchText ~= '' and string.find(dic.getTranslatedStr(questCls.Name), searchText) == nil then
        return false;
    end

    return true;
end

function ADVENTURE_BOOK_QUEST_REQUEST(ctrlSet, bg)
    local questClassID = ctrlSet:GetUserIValue('QUEST_CLASS_ID');
    ADVENTURE_BOOK_QUEST_INIT_DETAIL(questClassID);
    ReqQuestCompleteCharacterList(questClassID);
end

function ADVENTURE_BOOK_QUEST_DROPLIST_INIT(page_quest)
     local questCateDrop = GET_CHILD_RECURSIVELY(page_quest, 'questCateDrop');
    if questCateDrop:GetItemCount() > 0 then
        return;
    end
    questCateDrop:ClearItems();
    questCateDrop:AddItem(0, ClMsg('PartyShowAll'));
    questCateDrop:AddItem(1, ClMsg('MAIN'));
    questCateDrop:AddItem(2, ClMsg('SUB'));
    questCateDrop:AddItem(3, ClMsg('WCL_Etc'));
    
    local questLevelDrop = GET_CHILD_RECURSIVELY(page_quest, 'questLevelDrop');
    questLevelDrop:ClearItems();
    questLevelDrop:AddItem(0, 'Lv.1 ~ Lv.99');
    questLevelDrop:AddItem(1, 'Lv.100 ~ Lv.199');
    questLevelDrop:AddItem(2, 'Lv.200 ~ Lv.299');
    questLevelDrop:AddItem(3, 'Lv.300 ~ Lv.330');
end

function ADVENTURE_BOOK_QUEST_DROPLIST(parent, ctrl)
     ADVENTURE_BOOK_QUEST_INIT_REGION(parent);
end

function ADVENTURE_BOOK_QUEST_INIT_POINT(page_quest)
    local pointText = GET_CHILD_RECURSIVELY(page_quest, 'pointText');
    pointText:SetTextByKey('point', GET_ADVENTURE_BOOK_QUEST_POINT());
end

function ADVENTURE_BOOK_QEUST_SEARCH(questSearchBg, ctrl)
    local questSearchEdit = questSearchBg:GetChild('questSearchEdit');
    local searchText = questSearchEdit:GetText();
    if searchText == nil or searchText == '' then
        ADVENTURE_BOOK_QUEST_INIT_REGION(questSearchBg);
        return;
    end
    ADVENTURE_BOOK_QUEST_SEARCH_SHOW(questSearchBg:GetTopParentFrame(), searchText);
end

	if propName == "Name" then
		if config.GetServiceNation() ~= "KOR" then
			prop = dic.getTranslatedStr(prop);				
		end
	end


function ADVENTURE_BOOK_QUEST_SEARCH_SHOW(frame, searchText)
    local quest_list = GET_CHILD_RECURSIVELY(frame, 'quest_list');
    quest_list:RemoveAllChild();

    local questRegionTable = {};
    local questClsList, cnt = GetClassList('QuestProgressCheck');        
    for i = 0, cnt - 1 do
        local questCls = GetClassByIndexFromList(questClsList, i);
        if IS_QUEST_NEED_TO_SHOW(frame, questCls, nil, searchText) == true then
            local startMap = questCls.StartMap;
            if startMap ~= 'None' then
                local mapCls = GetClass('Map', startMap);
                local region = mapCls.CategoryName;
                local mapTable = questRegionTable[region];            
                if mapTable == nil then
                    mapTable = {};
                end
                local questList = mapTable[startMap];
                if questList == nil then
                    questList = {};
                end
                questList[#questList + 1] = questCls;
                mapTable[startMap] = questList;
                questRegionTable[region] = mapTable;
            end
        end
    end

    local y = 0; -- region offset
    local QUEST_EVEN_BG_SKIN = frame:GetUserConfig('QUEST_EVEN_BG_SKIN');
    for regionName, mapTable in pairs(questRegionTable) do            
        local regionCtrlSet = quest_list:CreateOrGetControlSet('adventure_book_map_region', 'QUEST_REGION_'..regionName, 0, y);        
        ADVENTURE_BOOK_QEUST_INIT_REGION_CTRLSET(regionCtrlSet, regionName, true);
        y = y + regionCtrlSet:GetHeight();
                
        local mapBox = ADVENTURE_BOOK_QUEST_CREATE_MAP_BOX(quest_list, regionCtrlSet:GetWidth(), 'questMapBox_'..regionName);        
        mapBox:SetOffset(mapBox:GetX(), y);

        local mapY = 0; -- mapNameCtrl offset
        for mapClassName, questList in pairs(mapTable) do            
            local mapCls = GetClass('Map', mapClassName);            
            local mapNameCtrl = ADVENTURE_BOOK_QUEST_CREATE_MAP_QUEST_TREE(mapBox, mapCls, true);
            mapNameCtrl:SetOffset(mapNameCtrl:GetX(), mapY);
            mapY = mapY + mapNameCtrl:GetHeight();

            local expandBtn = GET_CHILD(mapNameCtrl, 'expandBtn');
            local questBox = ADVENTURE_BOOK_QUEST_CREATE_QUEST_EXPAND_BOX(mapNameCtrl, expandBtn);
            local questY = 0; -- questBox offset
            for i = 1, #questList do            
                local questCls = questList[i];
                local questCtrl = ADVENTURE_BOOK_QUEST_CREATE_QUEST_CTRLSET(questBox, questCls);                
                questCtrl:SetOffset(questCtrl:GetX(), questY);
                
                if i % 2 == 0 then
                    local bg = questCtrl:GetChild('bg');
                    bg:SetSkinName(QUEST_EVEN_BG_SKIN);
                end   
                questY = questY + questCtrl:GetHeight();
            end
            questBox:Resize(questBox:GetWidth(), questY);
            mapNameCtrl:Resize(mapNameCtrl:GetWidth(), mapNameCtrl:GetHeight() + questY);
            mapY = mapY + questBox:GetHeight();
            mapBox:Resize(mapBox:GetWidth(), mapY);
            y = y + mapNameCtrl:GetHeight();
        end
    end
end