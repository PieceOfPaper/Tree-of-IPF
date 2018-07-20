function ADVENTURE_BOOK_COLLECTION_TAB(parent, ctrl)
    ADVENTURE_BOOK_DROPLIST_INIT(ctrl);
    ADVENTURE_BOOK_COLLECTION_LIST(ctrl);
    ADVENTURE_BOOK_COLLECTION_POINT(parent);
end

function ADVENTURE_BOOK_COLLECTION_POINT(frame)
    local topFrame = frame:GetTopParentFrame();
    local total_score_text = GET_CHILD_RECURSIVELY(frame, 'total_score_text');
    local pc = GetMyPCObject();
    local totalScore = GET_ADVENTURE_BOOK_COLLECTION_POINT(pc);
    total_score_text:SetTextByKey('value', totalScore);

    local page_explore = topFrame:GetChild('page_explore');
    local total_rate_text = page_explore:GetChild('total_rate_text');
    total_rate_text:ShowWindow(0);
end

function ADVENTURE_BOOK_DROPLIST_INIT(frame)
    local collectionSortDropList = GET_CHILD_RECURSIVELY(frame, 'collectionSortDropList');
    if collectionSortDropList:GetItemCount() > 0 then
        return;
    end
    collectionSortDropList:ClearItems();
    collectionSortDropList:AddItem(0, ClMsg('ALIGN_ITEM_TYPE_5'));
    collectionSortDropList:AddItem(1, ClMsg('ALIGN_ITEM_TYPE_6'));
    
    local collectionStateDropList = GET_CHILD_RECURSIVELY(frame, 'collectionStateDropList');
    collectionStateDropList:ClearItems();
    collectionStateDropList:AddItem(0, ClMsg('Auto_MoDu_BoKi'));
    collectionStateDropList:AddItem(1, ClMsg('Complete'));
    collectionStateDropList:AddItem(2, ClMsg('Auto_MiHwagin_'));
    collectionStateDropList:AddItem(3, ClMsg('NotComplete'));
end

function ADVENTURE_BOOK_COLLECTION_LIST(frame)
     -- 콜렉션 정보를 만듬
	local pc = session.GetMySession();
	local collectionList = pc:GetCollection();
	local collectionClassList, collectionClassCount= GetClassList("Collection");    
	local etcObject = GetMyEtcObject();

    -- get search text
    local topFrame = frame:GetTopParentFrame();
    local collectionSearchEdit = GET_CHILD_RECURSIVELY(topFrame, 'collectionSearchEdit');
    local searchText = collectionSearchEdit:GetText();
    
	-- 보여줄 콜렉션 리스트를 만듬
	local collectionCompleteMagicList ={}; -- 완료된 총 효과 리스트.
	local collectionInfoList = {};
	local collectionInfoIndex = 1;
	for i = 0, collectionClassCount - 1 do
		local collectionClass = GetClassByIndexFromList(collectionClassList, i);
		local collection = collectionList:Get(collectionClass.ClassID);
		local collectionInfo = GET_COLLECTION_INFO(collectionClass, collection,etcObject, collectionCompleteMagicList);        
		local collectionJournal = TryGetProp(collectionClass,'Journal')
		if collectionJournal == 'TRUE' then
    		if ADVENTURE_BOOK_CHECK_STATE_FILTER(topFrame, collectionInfo, searchText, collectionClass, collection) == true then
    		    -- data input
    			collectionInfoList[collectionInfoIndex] = {cls = collectionClass, 
    													   coll = collection, 
    													   info = collectionInfo };
    			collectionInfoIndex = collectionInfoIndex +1;
    		end
    	end
	end
    
    local posY = 0;
    local collectListBox = GET_CHILD_RECURSIVELY(frame, 'collectListBox');
    DESTROY_CHILD_BYNAME(collectListBox, 'COLLECTION_ITEM_');
    local collectionFrame = ui.GetFrame('collection');
    local SCROLL_SIZE = 20;
	for index , v in pairs(collectionInfoList) do
		local ctrlSet = collectListBox:CreateOrGetControlSet('collection_deck', "COLLECTION_ITEM_" .. index, 0, posY);        
		ctrlSet:ShowWindow(1);
		posY = SET_COLLECTION_SET(collectionFrame, ctrlSet, v.cls.ClassID, v.coll, posY) 
		posY = posY -tonumber(collectionFrame:GetUserConfig("DECK_SPACE")); -- 가까이 붙이기 위해 좀더 위쪽으로땡김        
        ctrlSet:SetEventScript(ui.LBUTTONUP, 'ADVENTURE_BOOK_COLLECTION_DETAIL');
        ctrlSet:SetUserValue('COLLECTION_ID', v.cls.ClassID);
        ctrlSet:SetUserValue('COLLECTION_NAME', ADVENTURE_BOOK_COLLECTION_REPLACE_NAME(v.cls.Name));
	end
    collectListBox:ShowWindow(1);

    ADVENTURE_BOOK_COLLECTION_ITEM_SORT(collectListBox);
end

function ADVENTURE_BOOK_COLLECTION_ITEM_SORT(frame)
    local topFrame = frame:GetTopParentFrame();
    local collectionSortDropList = GET_CHILD_RECURSIVELY(topFrame, 'collectionSortDropList');
    ADVENTURE_BOOK_COLLECTION_DROPLIST_SORT(collectionSortDropList:GetParent(), collectionSortDropList);
end

function ADVENTURE_BOOK_COLLECTION_DETAIL(parent, ctrl)
    local collectionID = parent:GetUserIValue('COLLECTION_ID');
    local topFrame = parent:GetTopParentFrame();
    local collectionCls = GetClassByType('Collection', collectionID);
    if collectionCls == nil then
        return;
    end

    -- name
    local collectionNameText = GET_CHILD_RECURSIVELY(topFrame, 'collectionNameText');    
    local replaceName = ADVENTURE_BOOK_COLLECTION_REPLACE_NAME(collectionCls.Name); -- "콜렉션:" 을 공백으로 치환한다.
    collectionNameText:SetTextByKey('name', replaceName);

    -- count
    local pc = session.GetMySession();
    local collectionList = pc:GetCollection();
    local collection = collectionList:Get(collectionID);
    local curCount, maxCount = GET_COLLECTION_COUNT(collectionID, collection);
    local collectionCountText = GET_CHILD_RECURSIVELY(topFrame, 'collectionCountText');
    collectionCountText:SetTextByKey('current', curCount);
    collectionCountText:SetTextByKey('total', maxCount);

    -- item
    local collectionItemBox = GET_CHILD_RECURSIVELY(topFrame, 'collectionItemBox');
    DESTROY_CHILD_BYNAME(collectionItemBox, 'COLLECTION_DETAIL_ITEM_');
    local itemNeedCount = {};
    local itemPutCount = {};
    local posY = 0;
    for i = 1, 9 do
        local miscCls = GetClass('Item', collectionCls['ItemName_'..i]);
        if miscCls ~= nil then
            if itemNeedCount[miscCls.ClassName] == nil then
                itemNeedCount[miscCls.ClassName] = 1;
            else
                itemNeedCount[miscCls.ClassName] = itemNeedCount[miscCls.ClassName] + 1;
            end
            local collectionDetailItem = collectionItemBox:CreateOrGetControlSet('advbook_collection_detail', 'COLLECTION_DETAIL_ITEM_'..i, 0, posY);
            local itemPic = GET_CHILD(collectionDetailItem, 'itemPic');
            itemPic:SetImage(miscCls.Icon);
            SET_ITEM_TOOLTIP_ALL_TYPE(itemPic, nil, miscCls.ClassName, 'collection', collectionID, miscCls.ClassID);
            -- gray tone
            if collection == nil or collection:GetItemCountByType(miscCls.ClassID) < itemNeedCount[miscCls.ClassName] then               
               itemPic:SetColorTone('88000000');
            end
            local itemNameText = GET_CHILD(collectionDetailItem, 'itemNameText');
            itemNameText:SetTextByKey('name', miscCls.Name);
                        posY = posY + collectionDetailItem:GetHeight() + 5;
            collectionDetailItem:ShowWindow(1);
        end
    end

    -- effect
    local collectionEffectText = GET_CHILD_RECURSIVELY(topFrame, 'collectionEffectText');
    local effectText = GET_COLLECTION_MAGIC_DESC(collectionID);
    collectionEffectText:SetTextByKey('effect', effectText);
end

function ADVENTURE_BOOK_COLLECTION_DROPLIST_SORT(parent, ctrl)    
    local collectListBox = GET_CHILD_RECURSIVELY(parent, 'collectListBox');
    local collectionNameTable = {};
    local collectionIndexTable = {};
    local childCount = collectListBox:GetChildCount();
    for i = 0, childCount - 1 do
        local ctrlSet = collectListBox:GetChildByIndex(i);
        local collectionName = ctrlSet:GetUserValue('COLLECTION_NAME');
        collectionNameTable[#collectionNameTable + 1] = collectionName;
        collectionIndexTable[collectionName] = ctrlSet;
    end

    local selectIndex = ctrl:GetSelItemIndex();
    if selectIndex == 0 then -- 오름차순
        table.sort(collectionNameTable, ADVENTURE_BOOK_SORT);
    elseif selectIndex == 1 then -- 내림차순
        table.sort(collectionNameTable, ADVENTURE_BOOK_SORT_REVERSE);
    end

    -- realign
    local posY = 0;
    for i = 1, #collectionNameTable do
        local ctrlSet = collectionIndexTable[collectionNameTable[i]];
        if string.find(ctrlSet:GetName(), 'COLLECTION_ITEM_') ~= nil then
            ctrlSet:SetOffset(ctrlSet:GetX(), posY);
            posY = posY + ctrlSet:GetHeight() - 3;
        end
    end
end

function ADVENTURE_BOOK_COLLECTION_REPLACE_NAME(originName)
    local replacedName = string.gsub(originName, ClMsg("CollectionReplace"), "");
    return replacedName;
end

function ADVENTURE_BOOK_SORT(a, b)
    return a < b;
end

function ADVENTURE_BOOK_SORT_REVERSE(a, b)
    return a > b;
end

function ADVENTURE_BOOK_CHECK_STATE_FILTER(frame, collectionInfo, searchText, collectionClass, collection)    
    local collectionStateDropList = GET_CHILD_RECURSIVELY(frame, 'collectionStateDropList');
    local stateIndex = collectionStateDropList:GetSelItemIndex();
    if stateIndex == 1 and collectionInfo.view ~= 2 then -- 완성
        return false;
    elseif stateIndex == 2 and collectionInfo.view ~= 0 then -- 미확인
        return false;
    elseif stateIndex == 3 and collectionInfo.view ~= 1 then -- 미완성
        return false;
    end

    if searchText ~= nil and searchText ~= '' then
        local collectionName = ADVENTURE_BOOK_COLLECTION_REPLACE_NAME(collectionInfo.name);
        searchText = string.lower(searchText);
        collectionName = string.lower(collectionName);
        if string.find(collectionName, searchText) == nil then
            return false;
        end
    end

    return true;
end

function ADVENTURE_BOOK_COLLECTION_DROPLIST_STATE(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    ADVENTURE_BOOK_COLLECTION_LIST(topFrame);
end

function ADVENTURE_BOOK_COLLECTION_SEARCH(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    ADVENTURE_BOOK_COLLECTION_LIST(topFrame);
end
