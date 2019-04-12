
-- pump_collection.lua - 콜렉션에 등록할 아이템 습득시 팝업.

PUMP_COLLECTION_FIRST_UPDATE = false; 
PUMP_COLLECTION_INFO_LIST = {};
PUMP_COLLECTION_CURRENT_OPEN_LIST = {};
PUMP_COLLECTION_CURRENT_OPEN_ITEM = 0;

function PUMP_COLLECTION_ON_INIT(addon, frame)
	addon:RegisterMsg("ADD_COLLECTION", "ON_ADD_PUMP_COLLECTION");						-- 콜렉션이 추가되면.   -> Make
	addon:RegisterMsg("COLLECTION_ITEM_CHANGE", "ON_PUMP_COLLECTION_ITEM_CHANGE");		-- 콜렉션의 아이템이 갱신되면 -> Update/make
	addon:RegisterMsg("INV_ITEM_ADD", "ON_PUMP_COLLECTION_OPEN");						-- 인벤에 아이템이 들어오면. -> OpenView
	
	PUMP_COLLECTION_FIRST_UPDATE  = false;												-- 재접시에 초기화
end

-- 콜렉션이 등록될때
function ON_ADD_PUMP_COLLECTION(frame, msg)
	MAKE_PUMP_COLLECTION_LIST();
end

-- 콜렉션에 아이템이 등록될때
function ON_PUMP_COLLECTION_ITEM_CHANGE(frame, msg, str, type, removeType)
	MAKE_PUMP_COLLECTION_LIST();
end


-- 아이템 획득시
function ON_PUMP_COLLECTION_OPEN(frame, msg, str, itemType, removeType)
	
	PUMP_COLLECTIOn_CURRENT_OPEN_ITEM = 0;
	
	-- 콜렉션 리스트가 생성되어있는지 확인
	local isMake = PUMP_COLLECTION_FIRST_UPDATE;
	if isMake ~= nil or isMake ~= true then
		MAKE_PUMP_COLLECTION_LIST();
	end

	-- 아이템 타입을가지고 인벤에서 가져옴
	local invItem = session.GetInvItem(itemType);
	if invItem == nil then
		return;
	end

	local obj = GetIES(invItem:GetObject());
	local name = obj.ClassName;
	local itemID  = obj.ClassID;
	
	-- 현재 정보 제거
	for key, value in pairs(PUMP_COLLECTION_CURRENT_OPEN_LIST) do
		PUMP_COLLECTION_CURRENT_OPEN_LIST[key] = nil;
	end
	
	-- OPEN
	PUMP_COLLECTION_CURRENT_OPEN_LIST = GET_OPEN_PUMP_COLLECTION_LIST(itemID);
	if table.getn(PUMP_COLLECTION_CURRENT_OPEN_LIST) == 0 then
		return;
	end
	
	PUMP_COLLECTION_CURRENT_OPEN_ITEM =  itemID;

	for k,v in pairs(PUMP_COLLECTION_CURRENT_OPEN_LIST) do
		_PUMP_COLLECTION_OPEN(frame, k); 
	end
end

function _PUMP_COLLECTION_OPEN(frame, currentKey)
	if table.getn(PUMP_COLLECTION_CURRENT_OPEN_LIST) == 0 then
		return;
	end

	-- 이미떠있는지 검사.
	frame = tolua.cast(frame, "ui::CFrame");

	-- 레시피알람 UI검사 (레시피랑 겹쳐서 여기에서 검사한다)
	local isOpenRecipeUI = false;
	local frame_recipe = ui.GetFrame("pump_recipe");
	if frame_recipe ~= nil then
		if frame_recipe:IsVisible() == 1 then
			isOpenRecipeUI = true;
		end
	end
	-- 콜렉션 알람 UI 검사
	local beforeCollectionType = frame:GetUserIValue("COLLECTIONTYPE");
	local collectionType = PUMP_COLLECTION_CURRENT_OPEN_LIST[currentKey].collectionClassID;
	if frame:IsVisible() == 1 and beforeCollectionType ~= collectionType or isOpenRecipeUI == true then
		local duration = frame:GetDuration();
		frame:ReserveScript("_PUMP_COLLECTION_OPEN", duration + 1,  currentKey);
		frame:EnableHideProcess(1);
		return;
	end

	frame:Resize(frame:GetOriginalWidth(),frame:GetOriginalHeight())
	frame:SetUserValue("COLLECTIONTYPE", collectionType);
	frame:SetUserValue("EFFECT_ITEM_TYPE", 0);


	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	if timer == nil then
		return ;
	end
	timer:Stop();
	
	local itemID = PUMP_COLLECTION_CURRENT_OPEN_ITEM;
	local collectionInfoList = PUMP_COLLECTION_CURRENT_OPEN_LIST[currentKey].infoList;
	if collectionInfoList == nil then
		return ;
	end
	
	-- 콜렉션 이름을 설정
	local ctrlCollectionName = GET_CHILD(frame, "rt_collection_name", "ui::CRichText");
	if ctrlCollectionName == nil then
		return;
	end

	local collectionCls = GetClassByType('Collection', collectionType);
	if collectionCls == nil then
		return ;
	end

	local replaceName =  collectionCls.Name;
	replaceName = string.gsub(replaceName, ClMsg("CollectionReplace"), ""); -- "콜렉션:" 을 공백으로 치환한다.
	ctrlCollectionName:SetTextByKey("value", replaceName);
	
	-- 아이템 그룹박스 가져옴
	local gb_items = GET_CHILD(frame, "gb_item", "ui::CGroupBox");
	if gb_items == nil then
		return;
	end

	-- 이전에 이펙트가 종료되지 않았다면 여기서라도 꺼준다.
	DISABLE_EFFECT_ALL_SLOT(gb_items, "SLOT_");

	-- 아이템 업데이트 실패시 그냥 리턴. 업데이트가 정상처리되면 그려진 박스의 높이를 리턴한다.
	local height = UPDATE_PUMP_COLLECTION_ITEM(frame, gb_items, itemID, collectionInfoList);
	if  height == nil then
		return;
	end

	local imageMargin = frame:GetUserConfig("IMAGE_MARGIN");
	frame:Resize(frame:GetOriginalWidth(),gb_items:GetOriginalY() + height + imageMargin);

	local duration = frame:GetUserConfig("OPEN_DURATION"); 
	frame:ShowWindow(1);
	frame:SetDuration(duration);
	frame:Invalidate();

	timer:SetUpdateScript("UPDATE_PUMP_COLLECTION_EFFECT");
	timer:Start(duration,0); -- 설정한 시간(초) 후에 모든 이펙트를 꺼주는 스크립트를 호출하도록 타이머 설정
end

function UPDATE_PUMP_COLLECTION_ITEM(frame, canvas,  itemID, collectionInfoList)
	
	canvas = tolua.cast(canvas, "ui::CGroupBox");

	-- 이전에 생성된 데이터를 지움.
	DESTROY_CHILD_BYNAME(canvas, 'SLOT_');

	-- 아이템 그리기 정보를 가져옴
	local itemSlotLineCount			= frame:GetUserConfig("ITEM_SLOT_LINE_COUNT");  -- 한라인에 몇개나 그릴 것인지.
	local itemSlotLineTopMargin		= frame:GetUserConfig("LINE_TOP_MARGIN");	    -- 아이템들의 첫번째 행(가로)의 상단 공백
	local itemSlotLineBottomMargin	= frame:GetUserConfig("LINE_BOTTOM_MARGIN");	-- 아이템들의 마지막 행(가로)의 하단 공백
	local itemSlotLineLeftMargin	= frame:GetUserConfig("LINE_LEFT_MARGIN");	    -- 아이템들의 첫번째 열(세로)의 좌측 공백 
	local itemSlotLineRightMargin	= frame:GetUserConfig("LINE_RIGHT_MARGIN");	    -- 아이템들의 마지막 열(세로)의 우측 공백 
	local space						= frame:GetUserConfig("SLOT_SPACE");			-- 슬롯과 슬롯 사이의 공백
	

	-- 컬러
	local collectedColor			= frame:GetUserConfig("EXIST_COLLECT_COLOR");	-- 습득한 아이템 컬러
	local notCollectedColor			= frame:GetUserConfig("NOT_COLLECT_COLOR");		-- 미습득한 아이템 컬러
	local ableCollectColor			= frame:GetUserConfig("ABLE_COLLECT_COLOR");	-- 습득 가능한 아이템 컬러

	-- 그려질 공간의 Width를 게산 (그룹박스의 넓이를 가지고 계산함)
	local drawBoxWidth = canvas:GetOriginalWidth()-itemSlotLineRightMargin-itemSlotLineRightMargin;	-- 기본 넓이에 양쪽 마진을 빼줌.
	-- 한개의 슬롯 크기를 계산(가로/세로 크기가 동일)
	local slotSize =  math.floor( (drawBoxWidth / itemSlotLineCount) - (space*2));					-- 슬롯한개의 크기(가로, 세로 같음 정사각형)
	-- 그려질 라인을 계산
	local drawLineCount = math.ceil(table.getn(collectionInfoList) / itemSlotLineCount);				-- 넘어온 리스트의 크기/한라인에 들어갈 개수. 반올림.
	-- 그룹박스의 확장될 Height 계산
	local totalSlotHeight = slotSize * drawLineCount;
	local totalSlotYSpace = space * (drawLineCount - 1);
	local boxHeight = itemSlotLineTopMargin + totalSlotHeight + totalSlotYSpace + itemSlotLineBottomMargin ;  -- 상하 마진+슬롯사이즈총합+사이마진총합
	
	-- 아이템이 그려질 캔버스 크기를 갱신
	canvas:Resize(canvas:GetOriginalWidth(), boxHeight);
	
	-- 아이템 슬롯을 추가함.
	local slotIndex = 1;
	for k,v in pairs(collectionInfoList) do
		local row = math.floor((slotIndex - 1) /  itemSlotLineCount);
		local col = (slotIndex - 1) %  itemSlotLineCount;
		local x = itemSlotLineLeftMargin + col * (slotSize + space);
		local y = itemSlotLineTopMargin + row * (slotSize + space);
		
		local itemCls = GetClassByType("Item", v.itemID);
		if itemCls == nil then
			return nil;
		end
		local itemSlot = canvas:CreateOrGetControl('slot', "SLOT_" .. slotIndex, x, y, slotSize, slotSize);
		if itemSlot == nil then
			return nil;
		end

		itemSlot = tolua.cast(itemSlot, "ui::CSlot");
		itemSlot:ShowWindow(1);
		itemSlot:SetSkinName(frame:GetUserConfig("SLOT_SKIN_NAME"));
		itemSlot:EnableHitTest(0);
		local icon = CreateIcon(itemSlot);
		icon:SetImage(itemCls.Icon);

		if v.isCollected == true then
			icon:SetColorTone(collectedColor);
		elseif  v.isCollected == false and  v.itemID == itemID then
			icon:SetColorTone(ableCollectColor);
			local effectname = frame:GetUserConfig("SLOT_PLAY_EFFECT_NAME");
			local scale = tonumber(frame:GetUserConfig("SLOT_PLAY_EFFECT_SCALE"));
			itemSlot:PlayUIEffect(effectname, scale, "NeedEffect_SLOT_" .. slotIndex);  -- 이펙트 출력
		else
			icon:SetColorTone(notCollectedColor);
		end

		slotIndex = slotIndex + 1;
	end

	-- 습득 가능한 아이템을 표시함.
	return canvas:GetHeight();
end

-- 실제로 이펙트를 모두 정지 시키는 함수
function DISABLE_EFFECT_ALL_SLOT(canvas, searchname)
	local index = 0;
	while 1 do
		if index >= canvas:GetChildCount() then
			break;
		end

		local childObj = canvas:GetChildByIndex(index);
		local name = childObj:GetName();
		if string.find(name, searchname) ~= nil then
			local slot = tolua.cast(childObj, "ui::CSlot");
			if slot == nil then
				break;
			end
			slot:StopUIEffect("NeedEffect_" .. name, true, 0.0);
		end
		
		index = index + 1;
	end
end

-- 이전에 출력되었던 이펙트를 정지 시키는 업데이트 함수
function UPDATE_PUMP_COLLECTION_EFFECT(frame, ctrl, num, str, time)
	
	if frame == nil then
		return ;
	end
	
	-- 아이템 그룹박스 가져옴
	local gb_items = GET_CHILD(frame, "gb_item", "ui::CGroupBox");
	if gb_items == nil then
		return;
	end

	-- 슬롯에 있는 모든 이펙트를 꺼준다. 
	DISABLE_EFFECT_ALL_SLOT(gb_items, "SLOT_");

end

-- 아이템 습득 후 보여줄 콜렉션 리스트를 리턴한다
function GET_OPEN_PUMP_COLLECTION_LIST(itemType)

	local openCollectionList = {};
	local openCollectionCount = 1;

	for k,v in pairs(PUMP_COLLECTION_INFO_LIST) do
		for item_k,item_v in  pairs(v.infoList) do
			if item_v.itemID == itemType and item_v.isCollected == false then
				openCollectionList[openCollectionCount] = v;
				openCollectionCount = openCollectionCount +1;
				break;
			end
		end
	end

	return openCollectionList;
end

-- 완성/미완성된 콜렉션 리스트를 만든다. 
function MAKE_PUMP_COLLECTION_LIST()
	
	PUMP_COLLECTION_FIRST_UPDATE = false;
	
	-- 리스트 제거
	for key, value in pairs(PUMP_COLLECTION_INFO_LIST) do
		PUMP_COLLECTION_INFO_LIST[key] = nil;
	end

	-- 콜렉션 정보를 만듬
	local pc = session.GetMySession();
	if pc == nil then
		return false;
	end
	
	local collectionList = pc:GetCollection();
	if collectionList == nil then
		return false;
	end

	local collectionClassList, collectionClassCount= GetClassList("Collection");
	local collectionInfoIndex = 1;
	for i = 0, collectionClassCount - 1 do
		local collectionClass = GetClassByIndexFromList(collectionClassList, i);
		local collection = collectionList:Get(collectionClass.ClassID);
		local collectionInfo = GET_COLLECTION_ITEM_INFO(collectionClass, collection);
		if collectionInfo ~= nil then
			PUMP_COLLECTION_INFO_LIST[collectionInfoIndex] = { 
															   collectionClassID = collectionClass.ClassID,			-- 콜렉션 클래스ID
															   infoList = collectionInfo							    -- 아이템 정보(아이템 ClassID, 수집유무)
															 };
			collectionInfoIndex = collectionInfoIndex +1;
		end
	end
	
	PUMP_COLLECTION_FIRST_UPDATE = true;

	return true;
end

function GET_COLLECTION_ITEM_INFO(collectionClass, collection)
	-- 콜렉션이 nil이면 수집되지 않은 콜렉션임.
	if collection == nil then
		return nil;
	end

	local cls = GetClassByType("Collection", collectionClass.ClassID);
	local collectedItemSet = {};
	local resultItemDatas = {};
	local index = 1;
	while cls ~= nil do
		local itemName = TryGetProp(cls,"ItemName_" .. index);
			  
		if itemName == nil or itemName == "None" then
			break;
		end

		local itemCls = GetClass("Item", itemName);
		local itemData = GET_COLLECTION_DETAIL_ITEM_INFO(collection, itemCls , collectedItemSet);

		resultItemDatas[index] = itemData;
		index = index +1;
	end
	
	return resultItemDatas;
end

function GET_COLLECTION_DETAIL_ITEM_INFO(collection, itemCls , collectedItemSet)
	local showedcount = 0;
	if collectedItemSet[itemCls.ClassID] ~= nil then
		showedcount = collectedItemSet[itemCls.ClassID];
	end

	local collectedcount = collection:GetItemCountByType(itemCls.ClassID);
	-- 이미 수집한 아이템
	if collectedcount > showedcount then
		-- 갱신해주고
		if collectedItemSet[itemCls.ClassID] == nil then
			collectedItemSet[itemCls.ClassID] = 1
		else
			collectedItemSet[itemCls.ClassID] = collectedItemSet[itemCls.ClassID] + 1
		end

		-- 이미 수집한 아이템.
		return { 
				itemID = itemCls.ClassID,
				isCollected = true
			   };
	end

	-- 아직 수집하지 않은 아이템.
	return { 
				itemID = itemCls.ClassID,
				isCollected = false
			};
end
