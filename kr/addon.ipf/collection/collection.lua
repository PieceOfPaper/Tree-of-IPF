-- collection.lua
REMOVE_ITEM_SKILL = 7

local collectionStatus = {
    isNormal = 0,			-- 기본
	isNew  = 1,				-- 새로등록됨
	isComplete = 2,			-- 완성
	isAddAble = 3			-- 수집가능
};

local collectionView = {
    isUnknown  = 0,			-- 미확인
	isIncomplete = 1,		-- 미완성
	isComplete = 2,			-- 완성
};

local collectionSortTypes = {
	default = 0,			-- 기본값: 기본 콜렉션 순서
	name = 1,				-- 이름순: 콜렉션의 이름순서
	status = 2				-- 상태  : 기본(0), 새로등록(1), 완성(2), 수집가능(3) << 수치가 높을수록 아래로감 >>
};

local collectionViewOptions = {
	showCompleteCollections = true,
	showUnknownCollections = false,
	showIncompleteCollections = true,
	sortType = collectionSortTypes.default
};

local collectionViewCount = {
	showCompleteCollections = 0,
	showUnknownCollections = 0,
	showIncompleteCollections = 0
};

function COLLECTION_ON_INIT(addon, frame)
	addon:RegisterMsg("ADD_COLLECTION", "ON_ADD_COLLECTION");
	addon:RegisterMsg("COLLECTION_ITEM_CHANGE", "ON_COLLECTION_ITEM_CHANGE");
	addon:RegisterOpenOnlyMsg("INV_ITEM_ADD", "ON_COLLECTION_ITEM_CHANGE");
	addon:RegisterOpenOnlyMsg("INV_ITEM_IN", "ON_COLLECTION_ITEM_CHANGE");
	addon:RegisterOpenOnlyMsg("INV_ITEM_POST_REMOVE", "ON_COLLECTION_ITEM_CHANGE");
	addon:RegisterOpenOnlyMsg("INV_ITEM_CHANGE_COUNT", "ON_COLLECTION_ITEM_CHANGE");
	addon:RegisterMsg("UPDATE_READ_COLLECTION_COUNT", "ON_COLLECTION_ITEM_CHANGE");
	addon:RegisterMsg('COLLECTION_UI_OPEN', 'COLLECTION_DO_OPEN');
end

function COLLECTION_DO_OPEN(frame)
    ui.ToggleFrame('collection')
	ui.ToggleFrame('inventory')
	RUN_CHECK_LASTUIOPEN_POS(frame)
end

function UI_TOGGLE_COLLECTION()

	if app.IsBarrackMode() == true then
		return;
	end
	ui.ToggleFrame('collection')
	ui.ToggleFrame('inventory')
end

function COLLECTION_ON_RELOAD(frame)
	COLLECTION_FIRST_OPEN(frame);
end

-- 콜렉션이 최초 열렸을때 드롭다운 리스트를 만든다.
function COLLECTION_FIRST_OPEN(frame)
	local showAlignTypeList = GET_CHILD_RECURSIVELY(frame,"alignTypeList");
	showAlignTypeList:ClearItems();
	showAlignTypeList:AddItem("0",  ClMsg("AlignDefault"), 0); -- ClMsg는 clientmessage.xml에 정의되어 있는 값을 가져온다.
	showAlignTypeList:AddItem("1",  ClMsg("AlignName"), 0);
	showAlignTypeList:AddItem("2",  ClMsg("AlignStatus"), 0);
	showAlignTypeList:SelectItem(0);

	UPDATE_COLLECTION_LIST(frame);
end

function ON_ADD_COLLECTION(frame, msg)

	UPDATE_COLLECTION_LIST(frame);
	local colls = session.GetMySession():GetCollection();
	if colls:Count() == 1 then
		SYSMENU_FORCE_ALARM("collection", "Collection");
	end
	imcSound.PlaySoundEvent('cllection_register');
	frame:Invalidate();

	end

function ON_COLLECTION_ITEM_CHANGE(frame, msg, str, type, removeType)
	UPDATE_COLLECTION_LIST(frame, str, removeType);
end

-- 콜렉션 정렬 드롭다운리스트 갱신
function COLLECTION_TYPE_CHANGE(frame, ctrl)
	
	local alignoption = tolua.cast(ctrl, "ui::CDropList");
	if alignoption ~= nil then
		collectionViewOptions.sortType  = alignoption:GetSelItemIndex();
	end
	
	local topFrame = frame:GetTopParentFrame();
	if topFrame ~= nil then
		UPDATE_COLLECTION_LIST(topFrame);
	end
end

function SET_COLLECTION_PIC(frame, slotSet, itemCls, coll, type,drawitemset)

	local colorTone = nil;
	local slot = GET_CHILD(slotSet,"slot","ui::CSlot");
	local btn = GET_CHILD(slotSet, "btn", "ui::CButton");
	local icon = CreateIcon(slot);
	slot:SetUserValue("COLLECTION_TYPE",type);
	icon:SetImage(itemCls.Icon);
	icon:SetTooltipOverlap(0);

	-- # 기본 아이템 툴팁을 넣음. 아래는 이전부터 있던 주석.
	-- 세션 콜렉션에 오브젝트 정보가 존재하고 이를 바탕으로 하면 item오브젝트의 옵션을 살린 툴팁도 생성 가능하다. 가령 박아넣은 젬의 경험치라던가.
	-- 허나 지금 슬롯 지정하여 꺼내는 기능이 없기 때문에 무의미. 정확한 툴팁을 넣으려면 COLLECTION_TAKE를 type이 아니라 guid 기반으로 바꿔야함
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, nil, itemCls.ClassName, 'collection', type, itemCls.ClassID);
	
	-- 우선 안보이도록 처리
	slot:ShowWindow(0);
	btn:ShowWindow(0);


	-- 공통 처리부분.
	local invcount = session.GetInvItemCountByType(itemCls.ClassID);
	local totalcount = invcount;
	local showedcount = 0

	if drawitemset[itemCls.ClassID] ~= nil then
		showedcount = drawitemset[itemCls.ClassID]
	end

	-- 콜렉션을 등록했을 경우
	if coll ~= nil then
		local collecount = coll:GetItemCountByType(itemCls.ClassID);

		-- 1. 내가 이미 모은 것들(콜렉션을 등록했을 때만)
		if collecount > showedcount then
			if drawitemset[itemCls.ClassID] == nil then
				drawitemset[itemCls.ClassID] = 1
			else
				drawitemset[itemCls.ClassID] = drawitemset[itemCls.ClassID] + 1
			end
			slot:ShowWindow(1);

			return ;
		end

		totalcount = invcount + collecount;
	end

	-- 공통 처리
	-- 2. 꼽으면 되는 것들
	if totalcount > showedcount then
		if drawitemset[itemCls.ClassID] == nil then
			drawitemset[itemCls.ClassID] = 1
		else
			drawitemset[itemCls.ClassID] = drawitemset[itemCls.ClassID] + 1
		end
		colorTone = frame:GetUserConfig("ITEM_EXIST_COLOR");
		slot:ShowWindow(1);

		if coll ~= nil then
			btn:ShowWindow(1);
			btn:SetTooltipOverlap(0);
			SET_ITEM_TOOLTIP_ALL_TYPE(btn, nil, itemCls.ClassName, 'collection', type, itemCls.ClassID); 
		end
	else
		colorTone = frame:GetUserConfig("BLANK_ITEM_COLOR");
		slot:ShowWindow(1);	
	end

	if colorTone ~= nil then
		icon:SetColorTone(colorTone);
	end
end

function GET_COLLECTION_COUNT(type, coll)

	local curCount = 0;
	if coll ~= nil then
		curCount = coll:GetItemCount();
	end

	local info = geCollectionTable.Get(type);
	local maxCount = info:GetTotalItemCount();

	return curCount, maxCount;
end

function COLLECTION_OPEN(frame)
	UPDATE_COLLECTION_LIST(frame);
end

function COLLECTION_CLOSE(frame)

	local inventory = ui.GetFrame("inventory")
	inventory:ShowWindow(0)
	
	COLLECTION_MAGIC_CLOSE();

	UNREGISTERR_LASTUIOPEN_POS(frame)
end

function GET_COLLECT_ABLE_ITEM_COUNT(coll, type)

-- 미확인콜렉션도 체크해야되니까 coll==nil일때도 처리.
--	if coll == nil then
--	 return 0;
--	end

	local cls = GetClassByType("Collection", type);
	local curCount, maxCount = GET_COLLECTION_COUNT(type, coll);
	local numCnt= 0;

	-- 한번돌면서 itemList를 채운다.
	local itemList = {};
	local itemCount = {};
	for i = 1 , maxCount do
		local itemName = TryGetProp(cls,"ItemName_" .. i);
		if itemName == nil or itemName == "None" then
			numCnt= 0;
			break;
		end

		local itemCls = GetClass("Item", itemName);
		if itemCls == nil then
			numCnt= 0;
			break;
		end

		local collecount = 0; -- coll이 nil일때의 기본값.
		if coll ~= nil then
			collecount = coll:GetItemCountByType(itemCls.ClassID);    -- 해당 아이템이 해당콜렉션에서 몇개가 들어있는지
		end
		local invcount = session.GetInvItemCountByType(itemCls.ClassID); -- 해당 아이템을 인벤에 몇개나 들고 있는지.
		
		-- 같은 ClassID의 아이템의 개수를 증가시킨다.
		if itemList[itemCls.ClassID] ~= nil then
			itemList[itemCls.ClassID] = itemList[itemCls.ClassID] +1;
		else
			itemList[itemCls.ClassID] = 1;
		end

		-- 모아진 콜렉션 아이템 개수보다 필요한 개수가 많을때
		if itemList[itemCls.ClassID] > collecount then
			-- 해당 아이템 클래스에 카운터가 nil이면 0으로 초기화
		    if itemCount[itemCls.ClassID] == nil then
				itemCount[itemCls.ClassID]  = 0;
			end

			-- 인벤개수 - 카운터가 0보다 크면 실제 총 필요개수를 증가하고, 사용의 의미로 해당 카운터는 증가
			if invcount - itemCount[itemCls.ClassID] > 0 then
				numCnt = numCnt +1;
				itemCount[itemCls.ClassID]  = itemCount[itemCls.ClassID] +1;
			end
		end
	end
	
	return numCnt;
end

function SET_COLLECTION_SET(frame, ctrlSet, type, coll, posY)
	-- 컨트롤을 입력하고 y값을 리턴함.
	ctrlSet:SetUserValue("COLLECTION_TYPE", type);
	local cls = GetClassByType("Collection", type);

	local isUnknown = coll == nil;
	-- 콜렉션의 기본 스킨을 설정한다.
	if isUnknown == false then -- 미확인된 콜렉션이 아닐때
		ctrlSet:SetSkinName(frame:GetUserConfig("ENABLE_SKIN"));
	else -- 미확인된 콜렉션일 때
		ctrlSet:SetSkinName(frame:GetUserConfig("DISABLE_SKIN"));
	end

	-- 카운트를 설정한다.
	local collec_count = GET_CHILD(ctrlSet, "collec_count", "ui::CRichText");
	local curCount, maxCount = GET_COLLECTION_COUNT(type, coll);
	collec_count:SetTextByKey("curcount", curCount);
	collec_count:SetTextByKey("maxcount", maxCount);
	if isUnknown == true then --미확인이면 보여주지않음
		collec_count:ShowWindow(0);
	end

	-- 아이콘을 설정한다
	local collec_num = GET_CHILD(ctrlSet, "collec_num", "ui::CRichText"); -- numicon_pic위에 그려질 숫자.
	local numicon_pic = GET_CHILD(ctrlSet, "numicon", "ui::CPicture");
	local newicon_pic = GET_CHILD(ctrlSet, "newicon", "ui::CPicture");
	local compicon_pic = GET_CHILD(ctrlSet, "compicon", "ui::CPicture");
	local gbox_complete = GET_CHILD(ctrlSet, "gb_complete", "ui::CGroupBox");  -- 완료시 테두리용

	
	-- 콜렉션 이름을 설정한다.
	local collec_name = GET_CHILD(ctrlSet, "collec_name", "ui::CRichText");
	local replaceName =  cls.Name;
	replaceName = string.gsub(replaceName, ClMsg("CollectionReplace"), ""); -- "콜렉션:" 을 공백으로 치환한다.
	-- 이름을 아래에서 설정. 완료/미확인/미완료시에 각각 텍스트가 틀림

	---- 우선 전부 hide
	newicon_pic:ShowWindow(0);
	compicon_pic:ShowWindow(0);
	numicon_pic:ShowWindow(0);
	collec_num:ShowWindow(0);
	gbox_complete:ShowWindow(0);

	-- 읽음 확인용 etcObj
	etcObj = GetMyEtcObject();
	local isread = TryGetProp(etcObj, 'CollectionRead_' .. cls.ClassID);
	local collectionNameFont = nil;
	local visibleAddNumFont = nil;
	local visibleAddNum = false;
	if isUnknown == false then -- 미확인된 콜렉션이 아닐때
		collectionNameFont = frame:GetUserConfig("ENABLE_DECK_TITLE_FONT");
		if curCount >= maxCount then	-- 컴플리트
			compicon_pic:ShowWindow(1);
			gbox_complete:ShowWindow(1);
			collectionNameFont = frame:GetUserConfig("COMPLETE_DECK_TITLE_FONT");	
		elseif isread == nil or isread == 0 then	-- 읽지 않음(new) etcObj의 항목에 1이 들어있으면 읽었다는 뜻.
			newicon_pic:ShowWindow(1);
		else -- 숫자표시 가능
			visibleAddNum = true;
			visibleAddNumFont = frame:GetUserConfig("ENABLE_DECK_NUM_FONT"); 
		end
	else -- 미확인일때 이름 설정
		collectionNameFont = frame:GetUserConfig("DISABLE_DECK_TITLE_FONT");
		visibleAddNumFont = frame:GetUserConfig("DISABLE_DECK_NUM_FONT"); 
		numicon_pic:SetColorTone(frame:GetUserConfig("NOT_HAVE_COLOR")); -- 비활성 컬러톤 설정
		visibleAddNum = true;
	end

	-- 등록가능 숫자 표시
	if visibleAddNum == true then
		local numCnt= GET_COLLECT_ABLE_ITEM_COUNT(coll,type);
		-- cnt가 0보다 크면 num아이콘활성화
		if numCnt > 0 then
			if visibleAddNumFont ~= nil then
				collec_num:SetTextByKey("value", visibleAddNumFont .. numCnt .. "{/}");
			else
				collec_num:SetTextByKey("value", numCnt);
			end
			collec_num:ShowWindow(1);
			numicon_pic:ShowWindow(1);
		end
	end

	-- 콜렉션 이름 설정
	if collectionNameFont ~= nil then
		collec_name:SetTextByKey("name", collectionNameFont .. replaceName .. "{/}");	
	else 
		collec_name:SetTextByKey("name", replaceName);	
	end


	-- 이름을기준으로 현재 y위치를 구함.
	local curPosY = ctrlSet:GetOriginalY() + collec_name:GetY()+  collec_name:GetHeight();
	
	local gbox_magic = GET_CHILD(ctrlSet, "gb_magic", "ui::CGroupBox");
	local img_btn_magic = GET_CHILD(gbox_magic, "iconMagic", "ui::CPicture");			-- 효과 버튼 이미지
	local txt_btn_magic = GET_CHILD(img_btn_magic, "richMagic", "ui::CRichText");		-- 효과 버튼 텍스트
	local txtmagic = GET_CHILD(gbox_magic, "magicList", "ui::CRichText");				-- 효과 내용 텍스트
	
	-- 효과를 기입한다. (이작업으로 height가 변할수있다)
	local desc = GET_COLLECTION_MAGIC_DESC(type);
	local desc_font = nil;
	local magic_font = nil;
	if isUnknown == true then -- 미확인 폰트
		desc_font = frame:GetUserConfig("DISABLE_MAGIC_LIST_FONT");
		magic_font = frame:GetUserConfig("DISABLE_MAGIC_FONT");
		img_btn_magic:SetColorTone(frame:GetUserConfig("NOT_HAVE_COLOR")); -- 효과 버튼 이미지 컬러톤 설정
	else -- 확인 폰트
		desc_font = frame:GetUserConfig("ENABLE_MAGIC_LIST_FONT")
		magic_font = frame:GetUserConfig("ENABLE_MAGIC_FONT");
	end

	-- 효과 버튼 텍스트 입력
	if magic_font ~= nil then
		txt_btn_magic:SetTextByKey("value", magic_font .. ClMsg("CollectionMagicText") .. "{/}");
	else
		txt_btn_magic:SetTextByKey("value", ClMsg("CollectionMagicText"));
	end
	
	-- 효과 입력
	if desc_font ~= nil then
		txtmagic:SetTextByKey("value", desc_font .. desc .. "{/}");
	else 
		txtmagic:SetTextByKey("value", desc);
	end

	

	-- 텍스트의 높이를 가져온다
	local txtHeight = txtmagic:GetHeight();
	
	-- gbox의 높이를 텍스트높이로 변경한다.
	gbox_magic:Resize(gbox_magic:GetWidth(),txtHeight);

	-- 현재 y위치를 갱신
	curPosY = curPosY + gbox_magic:GetHeight();
	
	-- 아이템이 들어갈 gb_times의 위치와 크기를 변경한다
	local gbox_items = GET_CHILD(ctrlSet, "gb_items", "ui::CGroupBox");
	
	-- Detial 갱신
	curPosY = DETAIL_UPDATE(frame, coll, gbox_items ,type, curPosY ,isUnknown);

	--마지막으로 컨트롤셋과 gbox_collection의 크기조절
	local gbox_collection = GET_CHILD(ctrlSet,"gb_collection","ui::CGroupBox");
	gbox_collection:Resize(gbox_collection:GetWidth(), curPosY); -- 이위치에서 리사이즈해야한다. 디테일뷰가 켜지면 그안에 +버튼을 눌러야하니까 히트는 나머지영역만으로 제한

	curPosY = curPosY + gbox_items:GetHeight() + tonumber(frame:GetUserConfig("SLOT_BOTTOM_MARGIN"));
	gbox_complete:Resize(ctrlSet:GetWidth(), curPosY);
	ctrlSet:Resize(ctrlSet:GetWidth(), curPosY);
	

	-- 리턴할 때는 y위치를 갱신해서.
	return posY + ctrlSet:GetHeight();
end

function UPDATE_COLLECTION_LIST(frame, addType, removeType)
	
	-- frame이 활성중이 아니면 return
	if frame:IsVisible() == 0 then
		return;
	end
	
	-- collection gbox
	local col = GET_CHILD_RECURSIVELY(frame, "gb_col", "ui::CGroupBox");
	if col == nil then
		return;
	end
	
	-- check box
	local gbox_status = GET_CHILD_RECURSIVELY(frame,"gb_status", "ui::CGroupBox");
	if gbox_status == nil then
		return;
	end
	
	local chkComplete = GET_CHILD(gbox_status, "optionComplete", "ui::CCheckBox");
	local chkUnknown = GET_CHILD(gbox_status, "optionUnknown", "ui::CCheckBox");
	local chkIncomplete = GET_CHILD(gbox_status, "optionIncomplete", "ui::CCheckBox");
	
	if chkComplete == nil or chkUnknown == nil or chkIncomplete == nil then
		return ;
	end
	
	-- 콜렉션 상태 Check
	chkComplete:SetCheck(BOOLEAN_TO_NUMBER(collectionViewOptions.showCompleteCollections));
	chkUnknown:SetCheck(BOOLEAN_TO_NUMBER(collectionViewOptions.showUnknownCollections));
	chkIncomplete:SetCheck(BOOLEAN_TO_NUMBER(collectionViewOptions.showIncompleteCollections));

	---- 초기화
	-- 그룹박스내의 DECK_로 시작하는 항목들을 제거
	DESTROY_CHILD_BYNAME(col, 'DECK_');

	-- 콜렉션 VIEW 카운터 초기화
	collectionViewCount.showCompleteCollections = 0 ;
	collectionViewCount.showUnknownCollections = 0 ;
	collectionViewCount.showIncompleteCollections = 0;


	-- 콜렉션 정보를 만듬
	local pc = session.GetMySession();
	local collectionList = pc:GetCollection();
	local collectionClassList, collectionClassCount= GetClassList("Collection");
	local searchText = GET_COLLECTION_SEARCH_TEXT(frame);
	local etcObject = GetMyEtcObject();


	-- 보여줄 콜렉션 리스트를 만듬
	local collectionCompleteMagicList ={}; -- 완료된 총 효과 리스트.
	local collectionInfoList = {};
	local collectionInfoIndex = 1;
	for i = 0, collectionClassCount - 1 do
		local collectionClass = GetClassByIndexFromList(collectionClassList, i);
		local collection = collectionList:Get(collectionClass.ClassID);
		local collectionInfo = GET_COLLECTION_INFO(collectionClass, collection,etcObject, collectionCompleteMagicList);
		if CHECK_COLLECTION_INFO_FILTER(collectionInfo, searchText, collectionClass, collection) == true then
		    -- data input
		    if collectionClass.Journal == 'TRUE' then
    			collectionInfoList[collectionInfoIndex] = {cls = collectionClass, 
    													   coll = collection, 
    													   info = collectionInfo };
    			collectionInfoIndex = collectionInfoIndex +1;
    		end
		end
	end
	
	-- 콜렉션 효과 목록을 날려줌.
	SET_COLLECTION_MAIGC_LIST(frame, collectionCompleteMagicList, collectionViewCount.showCompleteCollections ) -- 활성화되어 있지 않다면 그냥반환.
	
	-- 콜렉션 상태 카운터 적용
	chkComplete:SetTextByKey("value", collectionViewCount.showCompleteCollections);
	chkUnknown:SetTextByKey("value", collectionViewCount.showUnknownCollections);
	chkIncomplete:SetTextByKey("value", collectionViewCount.showIncompleteCollections);

	-- sort option 적용
	if collectionViewOptions.sortType == collectionSortTypes.name then
		table.sort(collectionInfoList, SORT_COLLECTION_BY_NAME);
	elseif collectionViewOptions.sortType == collectionSortTypes.status then
		table.sort(collectionInfoList, SORT_COLLECTION_BY_STATUS);
	end
	
	-- 콜렉션 항목 입력
	local posY = 0;
	for index , v in pairs(collectionInfoList) do
		local ctrlSet = col:CreateOrGetControlSet('collection_deck', "DECK_" .. index, 0, posY );
		ctrlSet:ShowWindow(1);
		posY = SET_COLLECTION_SET(frame, ctrlSet, v.cls.ClassID, v.coll, posY) 
		posY = posY -tonumber(frame:GetUserConfig("DECK_SPACE")); -- 가까이 붙이기 위해 좀더 위쪽으로땡김
	end

	if addType ~= "UNEQUIP" and REMOVE_ITEM_SKILL ~= 7 then
		imcSound.PlaySoundEvent("quest_ui_alarm_2");
	end
end

-- 콜렉션 view를 카운트하고 필터도 검사한다.
function CHECK_COLLECTION_INFO_FILTER(collectionInfo,  searchText,  collectionClass, collection)

	-- view counter
	local checkOption = 0;
	if collectionInfo.view == collectionView.isUnknown then	
		-- 미확인
		collectionViewCount.showUnknownCollections = collectionViewCount.showUnknownCollections +1;
		checkOption = 1;
	elseif collectionInfo.view == collectionView.isComplete then 
		-- 완성
		collectionViewCount.showCompleteCollections = collectionViewCount.showCompleteCollections +1;
		checkOption = 2;
	else
		-- 미완성
		collectionViewCount.showIncompleteCollections = collectionViewCount.showIncompleteCollections +1;
		checkOption = 3;
	end
	
	-- option filter
	---- unknown
	if collectionViewOptions.showUnknownCollections == false and  checkOption == 1 then
		return false;
	end
	---- complete
	if collectionViewOptions.showCompleteCollections == false and  checkOption == 2 then
		return false;
	end
	---- incomplete
	if collectionViewOptions.showIncompleteCollections == false and  checkOption == 3 then
		return false;
	end


	-- text filter
	--- 검색문자열이 없거나 길이가 0이면 true리턴
	if searchText == nil or string.len(searchText) == 0 then
		return true;
	end

	-- 콜렉션 이름을 가져온다
	local collectionName = collectionInfo.name;
	collectionName = dic.getTranslatedStr(collectionName)
	collectionName = string.lower(collectionName); -- 소문자로 변경
	-- 콜렉션 효과에서도 필터링한다.
	local desc = GET_COLLECTION_MAGIC_DESC(collectionClass.ClassID);
	desc = dic.getTranslatedStr(desc)
	desc = string.lower(desc); -- 소문자로 변경

	-- 검색문자열 검색해서 nil이면 false
	if string.find(collectionName, searchText) == nil and string.find(desc, searchText) == nil then
		 return false;
	end 
	
	return true;
end

function OPEN_DECK_DETAIL(parent, ctrl)
	local topFrame = parent:GetTopParentFrame();
	if topFrame:GetName() == 'adventure_book' then
		ADVENTURE_BOOK_COLLECTION_DETAIL(parent, ctrl);
		return;
	end

	imcSound.PlaySoundEvent('cllection_inven_open');
	local type = parent:GetUserValue("COLLECTION_TYPE");
	local cls = GetClassByType("Collection", type);

	local frame = parent:GetTopParentFrame();
	if frame == nil then
	 return 
	end

	if cls ~= nil then
		local curDetailCollectionType = frame:GetUserIValue("DETAIL_VIEW_TYPE");
		if curDetailCollectionType ~= cls.ClassID then
			-- DetailView를 설정
			frame:SetUserValue("DETAIL_VIEW_TYPE", cls.ClassID);
			
			local pc = session.GetMySession();
			local collectionList = pc:GetCollection();
			local coll = collectionList:Get(cls.ClassID);

			-- 콜렉션이 등록되어있을때만.
			if coll ~= nil then 
				-- 오픈된다면 확인하기위해 누른것임. 여기서 확인처리
				etcObj = GetMyEtcObject();
				local isread = TryGetProp(etcObj,"CollectionRead_" .. cls.ClassID);
				if isread == nil or isread == 0 then -- 한번이라도 읽은 콜렉션은 new 표시 안생기도록.
					local scpString = string.format("/readcollection %d", type);
					ui.Chat(scpString);
				end
			end
		else
			frame:SetUserValue("DETAIL_VIEW_TYPE", nil);
		end
	else
			frame:SetUserValue("DETAIL_VIEW_TYPE", nil);
	end

	UPDATE_COLLECTION_LIST(frame);
end


function ATTACH_TEXT_TO_OBJECT(ctrl, objName, text, x, y, width, height, alignX, alignY, enableFixWIdth, textAlignX, textAlignY, textOmitByWidth)

	local title = ctrl:CreateControl('richtext', objName, x, y, width, height);
	title = tolua.cast(title, "ui::CRichText");
	title:SetGravity(alignX, alignY);
	title:EnableResizeByText(1);
	if textOmitByWidth ~= nil then
		title:EnableTextOmitByWidth(textOmitByWidth);
	end

	if enableFixWIdth ~= nil then
		title:SetTextFixWidth(enableFixWIdth);
	end

	if textAlignX ~= nil then
		title:SetTextAlign(textAlignX, textAlignY);
	end

	title:SetText(text);
	
	if enableFixWIdth ~= nil then
		if (ctrl:GetWidth() < title:GetTextWidth()) then		
			title:SetTextFixWidth(1);
			title:SetTextMaxWidth(title:GetTextWidth() - 40);

			ctrl:Resize(ctrl:GetWidth(), title:GetLineCount() * 34);
			return (y + ctrl:GetHeight()), title;
		end
	end

	return (y + title:GetHeight()), title;
end

function GET_COLLECTION_MAGIC_DESC(type)

	local info = geCollectionTable.Get(type);
	local ret = "";
	local propCnt = info:GetPropCount();
	local isAccountColl = false;
	if 0 == propCnt then
		 propCnt = info:GetAccPropCount();
		isAccountColl = true;
	end

	for i = 0 , propCnt - 1 do
		
		local prop = nil;
		if false == isAccountColl then
			prop = info:GetProp(i);
		else
			prop = info:GetAccProp(i);
		end

		if i >= 1 then
			ret = ret .. "{nl}";
		end

		if nil ~= prop then
		if prop.value > 0 then
			ret = ret ..  string.format("%s +%d", ClMsg(prop:GetPropName()), prop.value);
		elseif prop.value == 0 then
			ret = ret ..  string.format("%s", ClMsg(prop:GetPropName()), prop.value);
		else
			ret = ret ..  string.format("%s %d", ClMsg(prop:GetPropName()), prop.value);
		end
	end
	end
	local cls = GetClassByType('Collection', type)
	local itemList = TryGetProp(cls, 'AccGiveItemList', 'None')
	if itemList ~= 'None' then
	    local itemList = SCR_STRING_CUT(itemList)
	    local aObj = GetMyAccountObj()
	    if aObj[itemList[1]] < itemList[2] then
	        local count = itemList[2] - aObj[itemList[1]]
    	    if #itemList >= 4 then
    			ret = ret .. "{nl}"..ScpArgMsg('COLLECTION_REWARD_ITEM_MSG1','COUNT',count)..'{nl}'
    	        for i = 2, #itemList/2 do
    	            local item = GetClassString('Item',itemList[i*2 - 1],'Name')
    	            ret = ret..ScpArgMsg('COLLECTION_REWARD_ITEM_MSG2','ITEM',item,'COUNT',itemList[i*2])
    	        end
    	    end
    	end
	end
	return ret;
end

-- draw detail 
function DETAIL_UPDATE(frame, coll, detailView ,type, posY ,playEffect, isUnknown)

	-- 디테일뷰가 있을지 모르니까 지운다.
	DESTROY_CHILD_BYNAME(detailView, 'SLOT_');
	
	-- 액티브상태면 디테일뷰를 그린다.
	local topParentFrame = detailView:GetTopParentFrame()
	local curDetailCollectionType = frame:GetUserIValue("DETAIL_VIEW_TYPE");
	if curDetailCollectionType == type and topParentFrame:GetName() ~= 'adventure_book' then
		local curCount, maxCount = GET_COLLECTION_COUNT(type, coll);

		posY = posY + frame:GetUserConfig("MAGIC_DETAIL_MARGIN"); -- 효과텍스트랑 붙어있는 공간을 띄운다.

		-- 디테일 뷰에 그려질 라인을 구한다.
		local lineCnt = math.ceil(maxCount / 7); -- 첫째자리에서 올림한다.
		-- 뷰의 크기를 결정한다
		detailView:SetOffset(detailView:GetX(),posY);
		detailView:Resize(detailView:GetWidth(),math.floor(detailView:GetHeight() * lineCnt));
		detailView:ShowWindow(1);

		-- 엑티브설정된 타입과 같으니 DETAILVIEW를 만들어줌
		local cls = GetClassByType("Collection", type);

		local marginX =  frame:GetUserConfig("DETAIL_MARGIN_X");  -- 첫번째 그림이 시작되는위치. 계산으로 해야하지만 우선 10으로
		local marginY  = frame:GetUserConfig("DETAIL_MARGIN_Y");  -- 천장과의 간격
		local boxWidth = detailView:GetWidth() - (marginX * 2);   -- 박스의 넓이 : 뷰의 넓이에서 양쪽 마진을빼줌.
		local picInBox = frame:GetUserConfig("DETAIL_ITEM_COUNT");  -- 한줄에 들어가는 아이템수        (콘피그로빼자)
		local space  = frame:GetUserConfig("DETAIL_ITEM_SPACE");   -- 아이템과 아이템사이의 X축 간격
		local slotWidth =  math.floor( (boxWidth / picInBox) - (space*2)); -- 슬롯한개의 넓이
		local slotHeight = slotWidth; -- 슬롯한개의 높이
		
		local num = 1;
		local brk = 0;
		local drawitemset = {}
		for i = 1 , lineCnt do -- 
			for j= 1, 7 do -- 1줄에 7개그림
				local itemName = TryGetProp(cls,"ItemName_" .. num);
			  
				if itemName == nil or itemName == "None" then
					brk = 1;
					break;
				end
				
				local itemCls = GetClass("Item", itemName);
				local row = i;
				local col = (j - 1)  % picInBox;
				local x = marginX + col * (slotWidth + space);
				local y = marginY + (row - 1) * (slotHeight + space);


				local slotSet = detailView:CreateOrGetControlSet('collection_slot', "SLOT_" .. num, x,y );

				SET_COLLECTION_PIC(frame, slotSet, itemCls, coll,type,drawitemset);

				num = num+1;
			end -- loop j

			if brk == 1 then
				break;
			end
		end -- loop i
	else
		-- deactive면 슬롯칸을 없앤다.
		detailView:SetOffset(detailView:GetX(),posY);
		detailView:Resize(detailView:GetWidth(),0);
		detailView:ShowWindow(0);
	end

	return posY;
end

-- 검색 텍스트를 가져옴
function GET_COLLECTION_SEARCH_TEXT(frame)
	-- collection search edit
	local searchEdit = GET_CHILD_RECURSIVELY(frame, "collectionSearch", "ui::CEditBox");
	if searchEdit == nil then
		return;
	end

	local searchText = searchEdit:GetText();

	if searchText ~= nil then
		return string.lower(searchText);
	end
	
	return nil;
end

function EXEC_PUT_COLLECTION(itemID, type)

	session.ResetItemList();
	session.AddItemID(itemID);
	local resultlist = session.GetItemIDList();
	item.DialogTransaction("PUT_COLLECTION", resultlist, type);
	imcSound.PlaySoundEvent("cllection_weapon_epuip");

end

function COLLECTION_ADD(collectionType, itemType, itemIesID)
	if collectionType == nil or itemType == nil or itemIesID == nil then
		return;
	end

	local colls = session.GetMySession():GetCollection();
	local coll = colls:Get(collectionType);
	local nowcnt = coll:GetItemCountByType(itemType)
	local colinfo = geCollectionTable.Get(collectionType);
	local needcnt = colinfo:GetNeedItemCount(itemType)

	if nowcnt < needcnt then
		imcSound.PlaySoundEvent('sys_popup_open_1');
		local yesScp = string.format("EXEC_PUT_COLLECTION(\"%s\", %d)", itemIesID, collectionType);
		ui.MsgBox(ScpArgMsg("CollectionIsSharedToTeamAndCantTakeBackItem_Continue?"), yesScp, "None");
	end
end

-- + 버튼을 눌러서 등록
function COLLECTION_TAKE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	if frame == nil then
	 return 
	end

	local slot = GET_CHILD(parent, "slot", "ui::CSlot");
	
	if slot == nil then
		return 
	end
	
	local collectionType = slot:GetUserIValue("COLLECTION_TYPE");
	local icon = slot:GetIcon();
	local itemType = icon:GetTooltipIESID(); -- icon에 입력된 클래스 ID를 가져옴(문자열)

	-- 가장 가치가 없는 아이템을 가져옴.
	local invItemlist = GET_ONLY_PURE_INVITEMLIST(tonumber(itemType));
	if #invItemlist < 1 or invItemlist == nil then
		return;
	end

	local iesID = invItemlist[1]:GetIESID();

	COLLECTION_ADD(collectionType,itemType,iesID);

end

-- 아이템 드롭으로 등록
function COLLECTION_DROP(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	if frame == nil then
	 return 
	end

	local slot = GET_CHILD(parent, "slot", "ui::CSlot");
	
	if slot == nil then
		return 
	end

	local liftIcon = ui.GetLiftIcon():GetInfo();
	local iesID = liftIcon:GetIESID();
	local itemType = liftIcon.type;
	local collectionType = slot:GetUserIValue("COLLECTION_TYPE");

	COLLECTION_ADD(collectionType,itemType,iesID);
end

function SEARCH_COLLECTION_NAME(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	if frame == nil then
	 return 
	end

	UPDATE_COLLECTION_LIST(frame);
end

-- 옵션체크
function UPDATE_COLLECTION_OPTION(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	if frame == nil then
	 return 
	end
	
	-- check box
	local gbox_status = GET_CHILD_RECURSIVELY(frame,"gb_status", "ui::CGroupBox");
	if gbox_status == nil then
		return;
	end

	local chkComplete = GET_CHILD(gbox_status, "optionComplete", "ui::CCheckBox");
	local chkUnknown = GET_CHILD(gbox_status, "optionUnknown", "ui::CCheckBox");
	local chkIncomplete = GET_CHILD(gbox_status, "optionIncomplete", "ui::CCheckBox");
	
	if chkComplete == nil or chkUnknown == nil or chkIncomplete == nil then
		return ;
	end

	collectionViewOptions.showCompleteCollections = NUMBER_TO_BOOLEAN(chkComplete:IsChecked());
	collectionViewOptions.showUnknownCollections = NUMBER_TO_BOOLEAN(chkUnknown:IsChecked());
	collectionViewOptions.showIncompleteCollections = NUMBER_TO_BOOLEAN(chkIncomplete:IsChecked());

	UPDATE_COLLECTION_LIST(frame);
end

-- 검색중 엔터누르면 갱신
function SEARCH_COLLECTION_ENTER(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	if frame == nil then
	 return 
	end

	UPDATE_COLLECTION_LIST(frame);
end

function BOOLEAN_TO_NUMBER(value)
	if value == true then
	   return 1;
	end
	return 0;
end

function NUMBER_TO_BOOLEAN(value)
	if value == 0 or value == nil then
	   return false;
	end
	return true;
end

function SORT_COLLECTION_BY_STATUS(a, b)
	local aStatus = a.info.status;
	local bStatus = b.info.status;

	if aStatus ~= bStatus then
		return aStatus > bStatus;
	end

	-- status 비교후 view 상태 비교
	local aView = a.info.view;
	local bView = b.info.view;
	
	if aView ~= bView then
		return aView > bView;
	end 

	--view 상태 비교 후 이름비교
	local aName = a.info.name;
	local bName = b.info.name;

	return aName < bName;
end

function SORT_COLLECTION_BY_NAME(a,b)
	local aName = a.info.name;
	local bName = b.info.name;

	return aName < bName;
end

-- 콜렉션 정보를 리턴.
function GET_COLLECTION_INFO(collectionClass, collection, etcObject, collectionCompleteMagicList)
	-- view 
	local curCount, maxCount = GET_COLLECTION_COUNT(collectionClass.ClassID, collection);
	local collView = collectionView.isIncomplete;
	if collection == nil then
		collView = collectionView.isUnknown;
	elseif curCount >= maxCount then 
		collView = collectionView.isComplete;
	end

	-- status
	local cls = GetClassByType("Collection", collectionClass.ClassID);	
	local isread = TryGetProp(etcObject, 'CollectionRead_' .. cls.ClassID);
	local addNumCnt= GET_COLLECT_ABLE_ITEM_COUNT(collection,collectionClass.ClassID);
	local collStatus = collectionStatus.isNormal;

	if curCount >= maxCount then	-- 컴플리트
		collStatus = collectionStatus.isComplete;
		-- complete 상태면 magicList에 추가해줌.
		ADD_MAGIC_LIST(collectionClass.ClassID, collection, collectionCompleteMagicList );
	elseif isread == nil or isread == 0 then	-- 읽지 않음(new) etcObj의 항목에 1이 들어있으면 읽었다는 뜻.		
		if collection ~= nil then -- 미확인 상태가 아닐때만 new를 입력
			collStatus = collectionStatus.isNew;
		end
	end

	-- 위에 new/complete를 체크했는데 기본값이며 추가가능한지 확인. 이렇게 안하면 미확인에서 정렬 제대로 안됨.
	if collStatus == collectionStatus.isNormal then
		-- cnt가 0보다 크면 num아이콘활성화
		if addNumCnt > 0 then
			collStatus = collectionStatus.isAddAble;
		end
	end

	
	-- name
	local collectionName =  cls.Name;
	collectionName = string.gsub(collectionName, ClMsg("CollectionReplace"), ""); -- "콜렉션:" 을 공백으로 치환한다.
	
	
	return { 
			 name = collectionName,		-- "콜렉션:" 이 제거된 이름
			 status = collStatus,		-- 콜렉션 상태
			 view = collView,			-- 콜랙션 보여주기 상태
			 addNum = addNumCnt			-- 추가 가능한 아이템 개수.
			};
end

-- 테이블에 효과 목록을 담아준다.
function ADD_MAGIC_LIST(type, collection, collectionCompleteMagicList)
	local info = geCollectionTable.Get(type);
	local propCnt = info:GetPropCount();
	local isAccountColl = false;
	if 0 == propCnt then
		 propCnt = info:GetAccPropCount();
		isAccountColl = true;
	end

	for i = 0 , propCnt - 1 do
		local prop = nil;
		if false == isAccountColl then
			prop = info:GetProp(i);
		else
			prop = info:GetAccProp(i);
		end

		if nil ~= prop then
			local propName = ClMsg(prop:GetPropName());
			if collectionCompleteMagicList[propName] == nil then
				collectionCompleteMagicList[propName] = 0 ;
			end

			if prop.value > 0 then
				collectionCompleteMagicList[propName] =  collectionCompleteMagicList[propName] + prop.value;
			elseif prop.value == 0 then
				collectionCompleteMagicList[propName] =  0;
			else
				collectionCompleteMagicList[propName] =  prop.value;
			end
		end
	end
end

-- 총 효과보기 버튼 클릭시.
function VIEW_COLLECTION_ALL_STATUS(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	if frame == nil then
	 return 
	end
	
	-- 콜렉션 VIEW 카운터 초기화
	collectionViewCount.showCompleteCollections = 0 ;
	collectionViewCount.showUnknownCollections = 0 ;
	collectionViewCount.showIncompleteCollections = 0;

	-- 콜렉션 정보를 만듬
	local pc = session.GetMySession();
	local collectionList = pc:GetCollection();
	local collectionClassList, collectionClassCount= GetClassList("Collection");
	local etcObject = GetMyEtcObject();


	-- 효과 리스트를 갱신
	local collectionCompleteMagicList ={}; -- 완료된 총 효과 리스트.
	for i = 0, collectionClassCount - 1 do
		local collectionClass = GetClassByIndexFromList(collectionClassList, i);
		local collection = collectionList:Get(collectionClass.ClassID);
		local collectionInfo = GET_COLLECTION_INFO(collectionClass, collection,etcObject, collectionCompleteMagicList);
		CHECK_COLLECTION_INFO_FILTER(collectionInfo, "", collectionClass,collection); -- 콜렉션 완료 개수를 카운트하기 위해 호출
	end
	
	-- 콜렉션 효과 목록을 날려줌.
	SET_COLLECTION_MAIGC_LIST(frame, collectionCompleteMagicList, collectionViewCount.showCompleteCollections) -- 활성화되어 있지 않다면 그냥반환.

	COLLECTION_MAGIC_OPEN(frame);
end