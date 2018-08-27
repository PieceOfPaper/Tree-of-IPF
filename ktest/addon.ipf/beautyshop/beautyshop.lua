-- beautyshop.lua

beautyShopInfo ={
	beautyshop_title = "none", 
	functionMap = {},
	gender = 2,					-- 1은 남성, 2는 여성
};

subItemInfo = {
	subItemList = {}, 		   -- 서브 아이템 목록
	subItemViewStartIndex = 1,  -- 서브 아이템 보여주기 시작 위치.
	maxControlCount = 4,		-- 서브 아이템의 한번에 보이는 갯수.
	currentSelectItemIndex = -1, -- 서브 아이템 선택 인덱스. 
};

previewConfig = {
	useEquipHairCostume = true,	-- 장착 헤어 코스튬 표시 유무
	visiblePreviewSlotList = {}, 	-- 프리뷰 슬롯의 보이기 안보이기 저장용.
};

function BEAUTYSHOP_ON_INIT(addon, frame)
	addon:RegisterMsg('BEAUTYSHOP_UI_OPEN', 'BEAUTYSHOP_DO_OPEN');
	addon:RegisterMsg('BEAUTYSHOP_PURCHASED_HAIR_LIST', 'ON_BEAUTYSHOP_PURCHASED_HAIR_LIST');
	addon:RegisterMsg('BEAUTYSHOP_DIRECTION_START', 'ON_BEAUTYSHOP_DIRECTION_START');
	addon:RegisterMsg('BEAUTYSHOP_DIRECTION_END', 'ON_BEAUTYSHOP_DIRECTION_END');
	addon:RegisterMsg('BEAUTYSHOP_PURCHASE_FAIL_LIMIT_PAYMENT', 'ON_BEAUTYSHOP_PURCHASE_FAIL_LIMIT_PAYMENT');

	
end

function ON_BEAUTYSHOP_DIRECTION_START(frame, msg, argString, argNum)	
	ui.SetHoldUI(true);
end

function ON_BEAUTYSHOP_DIRECTION_END(frame, msg, argString, argNum)	
	ui.SetHoldUI(false);
end

function ON_BEAUTYSHOP_PURCHASE_FAIL_LIMIT_PAYMENT(frame, msg, argString, argNum)	
	ui.MsgBox(argString);
end

function BEAUTYSHOP_INIT_FUNCTIONMAP()
	beautyShopInfo.functionMap["UPDATE_SUB_ITEMLIST"] = nil
	beautyShopInfo.functionMap["DRAW_ITEM_DETAIL"] = nil
	beautyShopInfo.functionMap["POST_SELECT_ITEM"]= nil
	beautyShopInfo.functionMap["SELECT_SUBITEM"]= nil
	beautyShopInfo.functionMap["POST_ITEM_TO_BASKET"] = nil
	beautyShopInfo.functionMap["POST_BASKETSLOT_REMOVE"] =nil
end

function BEAUTYSHOP_DO_OPEN(frame, msg, shopTypeName, genderNum)	
	local list ={
		{Type="HAIR", OpenFunc = HAIRSHOP_OPEN, IDSpace = 'Beauty_Shop_Hair'},
		{Type="COSTUME", OpenFunc = COSTUMESHOP_OPEN, IDSpace = 'Beauty_Shop_Costume'},
		{Type="WIG", OpenFunc = WIGSHOP_OPEN, IDSpace = 'Beauty_Shop_Wig'},
		{Type="ETC", OpenFunc = ETCSHOP_OPEN, IDSpace = 'Beauty_Shop_Lens'},
		{Type="PACKAGE", OpenFunc = PACKAGESHOP_OPEN, IDSpace = 'Beauty_Shop_Package_Cube'}, 
		{Type="PREVIEW", OpenFunc = PREVIEWSHOP_OPEN, IDSpace = 'Beauty_Shop_Preview'}, 
	};
	
	-- 상점 성별 설정.
	BEAUTYSHOP_SET_GENDER(genderNum)
	-- 상점에 해당하는 OPEN 함수 호출
	for k,v in pairs(list) do
		if v.Type == shopTypeName then
			v.OpenFunc()
			frame:SetUserValue('CURRENT_SHOP', shopTypeName);
			frame:SetUserValue('IDSPACE', v.IDSpace);
			BEAUTYSHOP_INIT_DROPLIST(frame);	
			BEAUTYSHOP_INIT_RIGHTTOP_BOX(frame);
			BEAUTYSHOP_UPDATE_PRICE_INFO(frame);
			ui.CloseFrame('beautyshop_simplelist');
			return;
		end
	end
end

function BEAUTYSHOP_OPEN(frame)
	BEAUTYSHOP_CLEAR_DATA(frame);
	BEAUTYSHOP_INIT_FUNCTIONMAP();
	BEAUTYSHOP_INIT(frame);	
end

function BEAUTYSHOP_CLOSE(frame)

	-- 미리보기 슬롯 검사.
	local isEmpty = BEAUTYSHOP_IS_PREIVEW_EMPTY(frame)
	-- 아무것도 없다면 입어보기 기능 제거하기.
	if isEmpty == true then
		session.beautyshop.SendCancelTryItOn();
	else
		-- 미리보기 목록이 있는데 끄는거면 간소화 목록 표시.
		local list = GET_CURRENT_TRY_ON_ITEM_LIST(frame);
		if #list < 1 then
			return
		end

		-- 인벤토리에서 헤어 악세서리 보이기/안보이기 확인.
		if BEAUTYSHOP_IS_HAIR_ACCESSORY_VISIBLE(frame) == false then
				ui.MsgBox(ClMsg('Hair_Accessory_Visible'));
		end

		SHOW_BEAUTYSHOP_SIMPLELIST(true, list, frame:GetUserValue('CURRENT_SHOP'));
		BEAUTYSHOP_SEND_TRY_IT_ON_LIST(list)
		ui.CloseFrame('packagelist'); 
	end
	
	-- 닫을 때 
	local showOnlyEnableEquipCheck = GET_CHILD_RECURSIVELY(frame, "showOnlyEnableEquipCheck");
	if showOnlyEnableEquipCheck ~= nil then
		showOnlyEnableEquipCheck:ShowWindow(0)
		showOnlyEnableEquipCheck:SetCheck(0)
	end
end

function BEAUTYSHOP_IS_PREIVEW_EMPTY(frame)
	
	local previewList = BEAUTYSHOP_GET_PREVIEW_NAME_LIST();
	for i = 1, #previewList do
		local slot = GET_CHILD_RECURSIVELY(frame, previewList[i]);
		if slot ~= nil then
			local className = slot:GetUserValue("CLASSNAME")
			if className ~= 'None' then
				return false
			end
		end
		
	end

	return true
end

-- 미리보기 슬롯에 헤어 악세서리가 있는지 확인하고, 보이기/안보이기를 확인함.
function BEAUTYSHOP_IS_HAIR_ACCESSORY_VISIBLE(frame)

	local checkList = {
		"slotPreview_hair_costume_1",
		"slotPreview_hair_costume_2",
		"slotPreview_hair_costume_3",
	}
	local isSlotItemExist = false
	-- 미리보기 슬롯에 아이템이 하나라도 있는 경우에만 확인.
	for i = 1, #checkList do
		local slot = GET_CHILD_RECURSIVELY(frame, checkList[i]);
		if slot ~= nil then
			local className = slot:GetUserValue("CLASSNAME")
			if className ~= 'None' then
				isSlotItemExist = true
				break
			end
		end
	end 

	if isSlotItemExist == false then
		return true
	end

	-- etc 확인.
	local myPCetc = GetMyEtcObject();
	if myPCetc == nil then
		return true
	end
	
	local hat_visible = myPCetc.HAT_Visible
	local hat_T_visible = myPCetc.HAT_T_Visible
	local hat_L_visible = myPCetc.HAT_L_Visible

	if hat_visible == 0 or hat_T_visible == 0 or hat_L_visible == 0 then
		return false
	end
	
	return true
end

-- 기존 데이터 날리기.
function BEAUTYSHOP_CLEAR_DATA(frame)

	-- 메인 아이템
	local gbItemList = GET_CHILD_RECURSIVELY(frame,"gbItemList");	
	if gbItemList ~= nil then
		local itemPrefix = "shopitem_"
		-- 그룹박스내의 "shopitem_"로 시작하는 항목들을 제거
		DESTROY_CHILD_BYNAME(gbItemList, itemPrefix);
		gbItemList:SetUserValue("SELECT","None");
	end

	local gbSubItemList = GET_CHILD_RECURSIVELY(frame,"gbSubItemList");	
	if gbSubItemList ~= nil then
		-- 서브아이템
		local subitemPrefix = "subitem_"
		DESTROY_CHILD_BYNAME(gbSubItemList, subitemPrefix);
    end
end


-- 미리보기 보이기/안보이기 초기화.
function BEAUTYSHOP_INIT_VISIBLE_PREVIEW_LIST()
	local list = BEAUTYSHOP_GET_PREVIEW_NAME_LIST()

	for i = 1, #list do
		local name = list[i]
		if previewConfig.visiblePreviewSlotList[name] == nil then
			previewConfig.visiblePreviewSlotList[name] = true
		end
	end
end

function BEAUTYSHOP_INIT(frame)
	frame:SetUserValue('SELECTED_CATEGORY', 'None');
	local gbox_title = GET_CHILD(frame,"gbTitle", "ui::CGroupBox")
    if gbox_title == nil then
        return
	end
	
    local text_title = GET_CHILD(gbox_title ,"rtTitle","ui::CRichText")
    if text_title == nil then
        return
    end
    
	text_title:SetTextByKey("title_name", beautyShopInfo.beautyshop_title)
	  
	BEAUTYSHOP_INIT_VISIBLE_PREVIEW_LIST()
	BEAUTYSHOP_SET_PREVIEW_APC_IMAGE(frame, 0)
end

function BEAUTYSHOP_SET_TITLE(titleName)
    beautyShopInfo.beautyshop_title = titleName
end

function BEAUTYSHOP_SET_GENDER(gender)
	beautyShopInfo.gender = gender
end

function BEAUTYSHOP_GET_GENDER()
	return beautyShopInfo.gender
end

function BEAUTYSHOP_UPDATE_SUB_ITEMLIST()
	-- 등록된 서브아이템 업데이트 함수를 호출함. 헤어나 패키지 아이템에서 등록한다.
	if beautyShopInfo.functionMap["UPDATE_SUB_ITEMLIST"]  ~= nil then
		beautyShopInfo.functionMap.UPDATE_SUB_ITEMLIST()
	end
end

function BEAUTYSHOP_DRAW_ITEM_DETAIL(itemInfo, itemObj, ctrlSet)
	if beautyShopInfo.functionMap["DRAW_ITEM_DETAIL"]  ~= nil then		
		beautyShopInfo.functionMap.DRAW_ITEM_DETAIL(itemInfo, itemObj, ctrlSet)
	end
end

function IS_ENABLE_EQUIP_AT_BEAUTYSHOP(item, beautyShopCls)
	if item == nil then
		return false;
	end

	if IS_EQUIP(item) == false then
		return true;
	end

	local lv = GETMYPCLEVEL();
    local job = GETMYPCJOB();
    local gender = GETMYPCGENDER();
	if beautyShopCls ~= nil then
		if beautyShopCls.Gender == 'M' and gender ~= 1 then			
			return false, 'Gender', 'MaleOnly';
		elseif beautyShopCls.Gender == 'F' and gender ~= 2 then			
			return false, 'Gender', 'FemaleOnly';
		end
		local jobOnly = beautyShopCls.JobOnly;
		local jobCls = GetClass('Job', jobOnly);		
		if jobOnly ~= 'None' and IS_EXIST_JOB_IN_HISTORY(jobCls.ClassID) == false then			
			return false, 'JOB';
		end

		return true;
	end

	local useGender = item.UseGender;
	if useGender == 'Male' and gender ~= 1 then
		return false, 'Gender', 'MaleOnly';
	elseif useGender == 'Female' and gender ~= 2 then
		return false, 'Gender', 'FemaleOnly';
	end
 
    local prop = geItemTable.GetProp(item.ClassID);
    local result = prop:CheckEquip(lv, job, gender);    
    if result ~= "OK" then
    	return false, result;
    end
    return true;
end

function GET_BEAUTYSHOP_EQUIP_TYPE(frame, gender, itemClassName)
	local shopName = frame:GetUserValue('CURRENT_SHOP');
	if shopName == 'HAIR' then
		return HAIRSHOP_GET_ITEM_EQUIPTYPE(gender, itemClassName);
	elseif shopName == 'COSTUME' then
		return 'costume';
	elseif shopName == 'WIG' then
		return WIGSHOP_GET_ITEM_EQUIPTYPE(gender, itemClassName);
	elseif shopName == 'ETC' then
		return 'lens';
	elseif shopName == 'PACKAGE' then
		return 'package';
	elseif shopName == 'PREVIEW' then
		return PREVIEWSHOP_GET_ITEM_EQUIPTYPE(itemClassName);
	end
	return nil;
end

function BEAUTYSHOP_GET_BUY_WARNING_CLIENT_MSG(itemClassName)
	local frame = ui.GetFrame('beautyshop');
	if frame == nil then
		return 'None'
	end
	local idSpace = frame:GetUserValue('IDSPACE');
	local beautyShopCls = GetClass(idSpace, itemClassName);
	if beautyShopCls == nil then
		return 'None'
	end

	local buyMessage = TryGetProp(beautyShopCls, 'BuyMessage')
	if buyMessage == nil then
		return 'None'
	end

	return buyMessage
end

function _BEAUTYSHOP_SELECT_ITEM_CHECK_BUY_MESSAGE(parentName, ctrlName)
	local frame = ui.GetFrame('beautyshop');
	local parent = GET_CHILD_RECURSIVELY(frame, parentName);
	local ctrl = GET_CHILD_RECURSIVELY(parent, ctrlName);	
	BEAUTYSHOP_SELECT_ITEM(parent, ctrl, 'NoCheckBuyMsg');
end

function _BEAUTYSHOP_SELECT_ITEM(parentName, ctrlName)
	local frame = ui.GetFrame('beautyshop');
	local parent = GET_CHILD_RECURSIVELY(frame, parentName);
	local ctrl = GET_CHILD_RECURSIVELY(parent, ctrlName);	
	BEAUTYSHOP_SELECT_ITEM(parent, ctrl, 'NoCheckDup');
end

-- 판매 아이템을 클릭 했을 때 동작.
function BEAUTYSHOP_SELECT_ITEM(parent, control, argStr, argNum)	
	local ctrlSet = control:GetParent()
	local name = ctrlSet:GetName()
	local frame = control:GetTopParentFrame(); -- beautyShop frame

	-- 프리뷰 슬롯의 정보 초기화.
	local gender = ctrlSet:GetUserIValue("GENDER");
	local itemClassName = ctrlSet:GetUserValue("ITEM_CLASS_NAME");
	local equipType = GET_BEAUTYSHOP_EQUIP_TYPE(frame, gender, itemClassName);
	if equipType == nil then		
		return false;
	end

	-- package 일 때는 장착 미리보기 슬롯 처리 안함.
	if equipType ~= "package"  then
		-- BuyMessage 확인.
		local buyMessage = BEAUTYSHOP_GET_BUY_WARNING_CLIENT_MSG(itemClassName)
		if argStr ~= 'NoCheckDup' and argStr ~= 'NoCheckBuyMsg'  and buyMessage ~= 'None' then
			local yesscp = string.format('_BEAUTYSHOP_SELECT_ITEM_CHECK_BUY_MESSAGE("%s", "%s")', parent:GetName(), control:GetName());
			ui.MsgBox(ClMsg(buyMessage), yesscp, 'None');
			return false;
		end
		
		local buyCaseClMsg, previewCaseClMsg = GET_ALLOW_DUPLICATE_ITEM_CLIENT_MSG(itemClassName);
		if argStr ~= 'NoCheckDup' and argStr ~= 'NoCheckBuyMsg' and previewCaseClMsg ~= '' then
		local yesscp = string.format('_BEAUTYSHOP_SELECT_ITEM("%s", "%s")', parent:GetName(), control:GetName());
			ui.MsgBox(ClMsg(previewCaseClMsg), yesscp, 'None');
			return false;
		end
		
		local slot = BEAUTYSHOP_GET_PREIVEW_SLOT(equipType, itemClassName)		
		if slot == nil then
			return false;
		end
		
		local itemCls = GetClass('Item', itemClassName);		
		local beautyShopCls = GetClass(ctrlSet:GetUserValue('IDSPACE'), ctrlSet:GetUserValue('SHOP_CLASSNAME'));
		local ret, reason = IS_ENABLE_EQUIP_AT_BEAUTYSHOP(itemCls, beautyShopCls);
		if ret == false then
			if reason == 'Gender' then
				ui.SysMsg(ClMsg('InvalidGender'));
			elseif reason == 'JOB' then
				ui.SysMsg(ClMsg('BEAUTY_SHOP_CLASS_CHECK'));
			end
			return false;
		end

		BEAUTYSHOP_CLEAR_SLOT(slot);
	end

	-- 선택 처리
	local select = frame:GetUserValue("SELECT");
	frame:SetUserValue('CLICKED_ITEM_CTRLSET_NAME', ctrlSet:GetName());    
	
	-- 기존에 선택되었던 것이 있으면 선택 해제.
	if "None" ~= select then
		local gbItemList = GET_CHILD_RECURSIVELY(frame,"gbItemList");	
		local ctrlSet_old = gbItemList:GetChild(select)
		if ctrlSet_old ~= nilt then
			local picCheck = ctrlSet_old:GetChild("picCheck")
			picCheck:SetVisible(0);
		end
	end
	
	-- 새로 선택된 항목 적용.
	frame:SetUserValue("SELECT", name);
	frame:SetUserValue("SUB_SELECT", "None") -- subitem 선택을 초기화 해줌.
	local picCheck_new = ctrlSet:GetChild("picCheck")
	picCheck_new:SetVisible(1)
	frame:Invalidate()
	
	-- 처리
	if beautyShopInfo.functionMap["POST_SELECT_ITEM"]  ~= nil then
		beautyShopInfo.functionMap.POST_SELECT_ITEM(frame, control)
	end
end

function BEAUTYSHOP_CLEAR_SLOT(slot)
	slot:ClearText();
	slot:ClearIcon();
	slot:SetUserValue("CLASSNAME", "None");
	slot:SetUserValue('TOTAL_PRICE', 0);
	slot:RemoveChild('HAIR_DYE_PALETTE');
	slot:SetUserValue('IDSPACE', 'None');
	slot:SetUserValue('SUB_ITEM_CLASS_NAME', 'None');
	slot:SetUserValue('PACKAGE_NAME', 'None')
	slot:SetUserValue('COLOR_NAME', 'None');
	slot:SetUserValue('COLOR_CLASS_NAME', 'None');
	slot:SetUserValue('GENDER', 0);
end

function BEAUTYSHOP_SELECT_SUBITEM(parent, control)
	if beautyShopInfo.functionMap["SELECT_SUBITEM"]  ~= nil then
		beautyShopInfo.functionMap.SELECT_SUBITEM(parent, control)
	end
end

function BEAUTYSHOP_PREV_SUBITEM_LIST(frame)
	subItemInfo.subItemViewStartIndex = subItemInfo.subItemViewStartIndex - 1
	if subItemInfo.subItemViewStartIndex < 1 then
		subItemInfo.subItemViewStartIndex = 1
	end

	BEAUTYSHOP_UPDATE_SUB_ITEMLIST()
end

function BEAUTYSHOP_NEXT_SUBITEM_LIST(frame)
	local maxControlCount = subItemInfo.maxControlCount
	local maxListCount = #subItemInfo.subItemList;
	subItemInfo.subItemViewStartIndex = subItemInfo.subItemViewStartIndex + 1
	if subItemInfo.subItemViewStartIndex + maxControlCount > maxListCount then
		subItemInfo.subItemViewStartIndex = maxListCount - maxControlCount  +1
		-- maxControlCount 보다 작을 떄 -로 가는 문제가 있다. 검사해서 1로 초기화.
		if subItemInfo.subItemViewStartIndex < 1 then
			subItemInfo.subItemViewStartIndex = 1
		end
	end

	BEAUTYSHOP_UPDATE_SUB_ITEMLIST()
end

function BEAUTYSHOP_PREV_ROT_CHARACTER(frame)
    BEAUTYSHOP_SET_PREVIEW_APC_IMAGE(frame, 2);
end

function BEAUTYSHOP_NEXT_ROT_CHARACTER(frame)
    BEAUTYSHOP_SET_PREVIEW_APC_IMAGE(frame, 1);
end

function BEAUTYSHOP_TOGGLE_HAIR_ACCESSORY(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local toggleHairAccessory = GET_CHILD_RECURSIVELY(frame, "btnToggleHairAccessory", "ui::CButton");
	if toggleHairAccessory == nil then
		return;
	end

	local TOGGLE_ON = frame:GetUserConfig('TOGGLE_ON');
	local TOGGLE_OFF = frame:GetUserConfig('TOGGLE_OFF');
	if previewConfig.useEquipHairCostume == false then
		previewConfig.useEquipHairCostume = true
		toggleHairAccessory:SetTextByKey("enable", "ON");
		ctrl:SetImage(TOGGLE_ON);
	else
		previewConfig.useEquipHairCostume = false
		toggleHairAccessory:SetTextByKey("enable", "OFF");
		ctrl:SetImage(TOGGLE_OFF);
	end
	BEAUTYSHOP_SET_PREVIEW_APC_IMAGE(frame, 99);
end

-- 입어보기
function BEAUTYSHOP_TRY_IT_ON(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local list = GET_CURRENT_TRY_ON_ITEM_LIST(frame);
	if #list < 1 then
		ui.SysMsg(ClMsg('EmptyPreviewSlot'));
		return;
	end

	-- 인벤토리에서 헤어 악세서리 보이기/안보이기 확인.
	if BEAUTYSHOP_IS_HAIR_ACCESSORY_VISIBLE(frame) == false then
		ui.MsgBox(ClMsg('Hair_Accessory_Visible'));
	end

	SHOW_BEAUTYSHOP_SIMPLELIST(true, list, frame:GetUserValue('CURRENT_SHOP'));
	BEAUTYSHOP_SEND_TRY_IT_ON_LIST(list)
	ui.CloseFrame('beautyshop');
	ui.CloseFrame('packagelist'); 
end

-- 입어보기 목록 전송.
function BEAUTYSHOP_SEND_TRY_IT_ON_LIST(list)
	-- 입어보기를 위해 목록을 클라로 입력해서 전송.
	session.beautyshop.ResetTryItOnItemList();
	for k,v in pairs(list) do
		local itemClassName = v['ItemClassName']
		local hairColorName = v['ColorName']
		local equipType = v['equipType']
		
		local visible = 1 -- wig 일 경우 검사해서 0/1 설정해야함.
		local slotName = BEAUTYSHOP_GET_PREIVEW_SLOT_NAME(equipType, itemClassName)

		if slotName ~= nil then
			if BEAUTYSHOP_GET_PREVIEW_VISIBLE(slotName) == false then
				visible = 0
			end
		
			session.beautyshop.AddTryItOnItem(itemClassName, hairColorName, equipType, visible );
		end
	end
	session.beautyshop.SendTryItOnItemList();
end


function BEAUTYSHOP_ITEMSEARCH_CLICK(parent, control, strArg, intArg)
	local editDiff = GET_CHILD(parent, "rtEditDiff");
	editDiff:SetVisible(0);
	control:ClearText();
end


function BEAUTYSHOP_ITEMSEARCH_ENTER(parent, control, strArg, intArg)
	local frame = parent:GetTopParentFrame();
	local editInput = GET_CHILD_RECURSIVELY(frame, 'editInput');
	local searchText = editInput:GetText();
	if searchText == nil or searchText == '' then
		BEAUTYSHOP_UPDATE_ITEM_LIST_BY_SHOP(frame);
		return;
	end
	
	BEAUTYSHOP_UPDATE_ITEM_LIST_BY_SHOP(frame);
end

-- 미리보기 버튼을 누를 때
function BEAUTYSHOP_ITEM_PREVIEW(parent, control, strArg, numArg)
	-- SELECT_ITEM과 동일한 효과
	BEAUTYSHOP_SELECT_ITEM(parent, control, strArg, numArg)
end

function _BEAUTYSHOP_ITEM_TO_BASKET_PREPROCESSOR(itemClassName, parentName, idSpace, shopClassName)
	local itemobj = GetClass("Item", itemClassName)
	if itemobj == nil then
		return;
	end

	local classid = itemobj.ClassID;
	local item = GetClassByType("Item", classid);
	if item == nil then
		return;
	end

	local yesscp = string.format('_BEAUTYSHOP_ITEM_TO_BASKET("%s", %d, "None", "%s", -1)', itemClassName, classid, parentName);
	local clmsg = GET_ALLOW_DUPLICATE_ITEM_CLIENT_MSG(itemClassName);

	local beautyShopCls = GetClass(idSpace, shopClassName);
	local ret, reason, argStr = IS_ENABLE_EQUIP_AT_BEAUTYSHOP(item, beautyShopCls);    
	if ret == false then
		if idSpace == 'Beauty_Shop_Hair' or idSpace == 'Hair_Dye_List' then
			return;
		end

		if reason == 'Gender' then		
			if argStr == 'MaleOnly' then
				clmsg = clmsg..'BEAUTY_SHOP_ONLY_MEN';
			else
				clmsg = clmsg..'BEAUTY_SHOP_ONLY_GIRL';
			end
		elseif reason == 'JOB' then
			clmsg = clmsg..'BEAUTY_SHOP_BUY_CLASS_CHECK';
		end
	end

	if clmsg ~= '' then
		ui.MsgBox(ClMsg(clmsg), yesscp, 'None');
		return;
	end

	local frame = ui.GetFrame('beautyshop');
	local parent = GET_CHILD_RECURSIVELY(frame, parentName);	
	BEAUTYSHOP_ITEM_TO_BASKET(itemClassName, classid, nil, parent);

end

-- 메인아이템에서 담기 버튼 누를때
function BEAUTYSHOP_ITEM_TO_BASKET_PREPROCESSOR(parent, control, strArg, numArg)
	local itemClassName = strArg

	local buyMessge = BEAUTYSHOP_GET_BUY_WARNING_CLIENT_MSG(itemClassName)
	local yesscp = string.format('_BEAUTYSHOP_ITEM_TO_BASKET_PREPROCESSOR("%s", "%s", "%s", "%s")', itemClassName, parent:GetName(), parent:GetUserValue('IDSPACE'),  parent:GetUserValue('SHOP_CLASSNAME'));
	if buyMessge ~= 'None' then
		ui.MsgBox(ClMsg(buyMessge), yesscp, 'None');
		return;
	end

	_BEAUTYSHOP_ITEM_TO_BASKET_PREPROCESSOR(itemClassName, parent:GetName(), parent:GetUserValue('IDSPACE'),  parent:GetUserValue('SHOP_CLASSNAME'));
	
end

-- 서브아이템에서 담기 버튼 누를 때
function BEAUTYSHOP_SUBITEM_TO_BASKET_PREPROCESSOR(parent, control, strArg, numArg)
	local itemClassName = parent:GetUserValue("SUB_ITEM_CLASS_NAME");	
	local itemobj = GetClass("Item", itemClassName);
	if itemobj == nil then
		return;
	end

	BEAUTYSHOP_ITEM_TO_BASKET(itemClassName, itemobj.ClassID, strArg, parent);
end

function _BEAUTYSHOP_ITEM_TO_BASKET(itemClassName, itemClassID, subItemStrArg, ctrlsetName, alreadySlotIndex)	
	local frame = ui.GetFrame('beautyshop');
	local slotsetBasket = GET_CHILD_RECURSIVELY(frame, 'slotsetBasket');

	if alreadySlotIndex >= 0 then
		local alreadySlot = slotsetBasket:GetSlotByIndex(alreadySlotIndex);	
		BEAUTYSHOP_CLEAR_SLOT(alreadySlot);
	end

	local ctrlset = GET_CHILD_RECURSIVELY(frame, ctrlsetName);	
	local _subItemStrArg = subItemStrArg;
	if _subItemStrArg == 'None' then
		_subItemStrArg = nil;
	end
	BEAUTYSHOP_ITEM_TO_BASKET(itemClassName, itemClassID, _subItemStrArg, ctrlset, true);
end


function BEAUTYSHOP_IS_CURRENT_HAIR(hairItemClassName, colorName)

	local pc = GetMyPCObject()
	local data ={
		ClassName = hairItemClassName,
		ColorEngName = colorName,
	}

	local isSameCurrentHair = IS_SAME_CURRENT_HAIR(pc, data)
	local isSameCurrentHairColor = IS_SAME_CURRENT_HAIR_COLOR(pc, data)
	if isSameCurrentHair == true and isSameCurrentHairColor == true then

		return true
	end

	return false
end

function BEAUTYSHOP_ITEM_TO_BASKET(ItemClassName, ItemClassID, SubItemStrArg, ctrlset, force)
	local item = GetClassByType("Item", ItemClassID)
	if item == nil then    
		return;
	end

    local colorName = SubItemStrArg;
    if colorName == nil then
    	colorName = 'None';
	end
	
	-- slotset을 순회하면서 비어있는 곳에 넣기.
	local topFrame = ui.GetFrame("beautyshop");
	local slotset = GET_CHILD_RECURSIVELY(topFrame,"slotsetBasket");

	-- hair나 hair color일 경우 검사.
	local idSpace = ctrlset:GetUserValue('IDSPACE');
	if idSpace == 'Beauty_Shop_Hair' or idSpace == 'Hair_Dye_List' then
		-- 현재 하고 있는 헤어인지 검사한다.
		local color = 'default'
		if colorName ~= 'None' then
			color = colorName
		end

		if BEAUTYSHOP_IS_CURRENT_HAIR(ItemClassName, color) == true then
			ui.MsgBox(ClMsg('Hair_Dye_Check'));
			return;
		end

		-- 이미 헤어가 장바구니에 있는지 검사
		local alreadySlot = IS_ALREAY_PUT_HAIR_IN_BASKET(topFrame, slotset);
		if force ~= true and alreadySlot ~= nil then
			local yesscp = string.format('_BEAUTYSHOP_ITEM_TO_BASKET("%s", %d, "%s", "%s", %d)', ItemClassName, ItemClassID, colorName, ctrlset:GetName(), alreadySlot:GetSlotIndex());
			ui.MsgBox(ClMsg('BEAUTY_SHOP_ONLY_ONE_HAIR'), yesscp, 'None');
			return;
		end
	end
	
	-- slotset을 순회하면서 비어있는 곳에 넣기.
	local slotCount = slotset:GetSlotCount();
	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);        
		if slotIcon == nil then
			local slot  = slotset:GetSlotByIndex(i);
			local name = TryGetProp(item, 'Name');

			slot:SetEventScript(ui.RBUTTONDOWN, 'BEAUTYSHOP_BASKETSLOT_REMOVE');
			slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, ItemClassID);
			slot:SetUserValue("CLASSNAME", item.ClassName);
			slot:SetUserValue("ITEM_CLASS_NAME", ItemClassName);

			local beautyShopClsName = ctrlset:GetUserValue('SHOP_CLASSNAME');
			local colorClassName = ctrlset:GetUserValue('COLOR_CLASS_NAME');
            slot:SetUserValue('IDSPACE', idSpace);
            slot:SetUserValue('SHOP_CLASSNAME', beautyShopClsName);
            slot:SetUserValue('COLOR_CLASS_NAME', colorClassName);
            slot:SetUserValue('SUB_ITEM_CLASS_NAME', ctrlset:GetUserValue('SUB_ITEM_CLASS_NAME'));
			slot:SetUserValue('GENDER', beautyShopInfo.gender);

            local pc = GetMyPCObject();
            local priceInfo = {
		      IDSpace = idSpace,
		      ClassName = beautyShopClsName,
		      ColorClassName = ctrlset:GetUserValue('COLOR_CLASS_NAME'),
		      ColorEngName = colorName,
		    };
		    if priceInfo.ColorClassName ~= 'None' then
		      priceInfo.IDSpace = 'Beauty_Shop_Hair';
		      priceInfo.ClassName = item.ClassName;
		    end
            slot:SetUserValue('COLOR_NAME', colorName);
		    local price, hairPrice, dyePrice = GET_BEAUTYSHOP_ITEM_PRICE(pc, priceInfo, nil, nil);		    
            slot:SetUserValue('TOTAL_PRICE', price);

			SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(item));
			local icon = slot:GetIcon();
			icon:SetTextTooltip(name);
			
			-- 후처리
			if beautyShopInfo.functionMap["POST_ITEM_TO_BASKET"]  ~= nil then
				-- Hair의 경우 염색일 때 이미지를 덧씌워 줘야 한다.
				beautyShopInfo.functionMap.POST_ITEM_TO_BASKET(ItemClassName, ItemClassID, slot, SubItemStrArg)  
			end
			BEAUTYSHOP_UPDATE_PRICE_INFO(topFrame);
			break;
		end
	end	
end

function  BEAUTYSHOP_BASKETSLOT_REMOVE(parent, control, strarg, numarg)	
	BEAUTYSHOP_CLEAR_SLOT(control);
	-- 후처리
	if beautyShopInfo.functionMap["POST_BASKETSLOT_REMOVE"]  ~= nil then
		-- Hair의 경우 염색일 때 이미지를 덧씌워 줘야 한다.
		beautyShopInfo.functionMap.POST_BASKETSLOT_REMOVE(parent, control, strarg, numarg)  
	end

	BEAUTYSHOP_UPDATE_PRICE_INFO(parent:GetTopParentFrame());
end

function BEAUTYSHOP_UPDATE_PRICE_INFO(frame)
	local rtHaveTP = GET_CHILD_RECURSIVELY(frame, 'rtHaveTP');	
	local haveTP = GET_TOTAL_TP(GetMyAccountObj());
	rtHaveTP:SetText(haveTP);

	local basketTP = GET_BEAUTYSHOP_BASKET_TOTAL_PRICE(frame);
	local rtBasketTP = GET_CHILD_RECURSIVELY(frame, 'rtBasketTP');
	rtBasketTP:SetText(basketTP);

	local rtRemainTP = GET_CHILD_RECURSIVELY(frame, 'rtRemainTP');
	rtRemainTP:SetText(haveTP - basketTP);
end

function GET_BEAUTYSHOP_BASKET_TOTAL_PRICE(frame)
	local price = 0;
	local slotsetBasket = GET_CHILD_RECURSIVELY(frame, 'slotsetBasket');
	local slotCount = slotsetBasket:GetSlotCount();
	for i = 0, slotCount - 1 do
		local slot = slotsetBasket:GetSlotByIndex(i);
		price = price + slot:GetUserIValue('TOTAL_PRICE');
	end

	return price;
end

------------------------------------------ main item -------------------------------------

g_beautyshopItemMap = {};
function BEAUTYSHOP_GET_ITEMID_BY_ITEM_NAME(idSpace, itemName)
	if g_beautyshopItemMap[idSpace] == nil then
		g_beautyshopItemMap[idSpace] = {}

		local clslist, cnt = GetClassList(idSpace);
		for i = 0, cnt - 1 do
			local cls = GetClassByIndexFromList(clslist, i);
			g_beautyshopItemMap[idSpace][cls.ItemClassName] = cls.ClassID;
		end
	end

	return g_beautyshopItemMap[idSpace][itemName];
end


function BEAUTYSHOP_UPDATE_ITEM_LIST(itemList, itemCount)
	local topFrame = ui.GetFrame("beautyshop");
	local gbItemList = GET_CHILD_RECURSIVELY(topFrame,"gbItemList");	
	if gbItemList == nil then
		return;
	end    

	local itemPrefix = "shopitem_"
	-- 그룹박스내의 "shopitem_"로 시작하는 항목들을 제거
	DESTROY_CHILD_BYNAME(gbItemList, itemPrefix);
	gbItemList:SetUserValue("SELECT","None");

	-- subItemList도 초기화.
	subItemInfo.subItemList = {}

	local x, y;
	local index = 0
	local width = ui.GetControlSetAttribute("beautyshop_item", "width");
	local height = ui.GetControlSetAttribute("beautyshop_item", "height")
		
	--착용 가능한 장비 보기 옵션 관련
	local showEnalbeEquip = false;
	local showOnlyEnableEquipCheck = GET_CHILD_RECURSIVELY(topFrame, "showOnlyEnableEquipCheck");
	if showOnlyEnableEquipCheck:IsVisible() == 1 and showOnlyEnableEquipCheck:IsChecked() == 1 then
		showEnalbeEquip = true;
	end   

	-- 목록 채우기
	for i = 1, itemCount  do
		local itemInfo = itemList[i]
		local itemObj = GetClass("Item", itemInfo.ItemClassName);
		if itemObj ~= nil and IS_NEED_TO_SHOW_BEAUTYSHOP_ITEM(topFrame, itemObj, itemInfo) == true then
			if showEnalbeEquip == false then
				--모두 보기
				index = index + 1
				x = ( (index-1) % 2) * width
				y = (math.ceil( (index / 2) ) - 1) * (height * 1)
				ctrlSet = gbItemList:CreateOrGetControlSet("beautyshop_item", itemPrefix..index, x, y);
				ctrlSet:SetUserValue("INDEX_NAME", itemPrefix..index);
				ctrlSet:SetUserValue("ITEM_CLASS_NAME", itemInfo.ItemClassName);
			    ctrlSet:SetUserValue('IDSPACE', itemInfo.IDSpace);
				ctrlSet:SetUserValue('SHOP_CLASSNAME', itemInfo.ClassName);
				ctrlSet:SetUserValue('GENDER', beautyShopInfo.gender);
				
				-- 패키지일 경우 미리보기 버튼이 살펴보기로 바껴야함
				if itemInfo.IDSpace == 'Beauty_Shop_Package_Cube' then
					if ctrlSet ~= nil then
						local previewBtn = ctrlSet:GetChild('previewBtn');
						if previewBtn ~= nil then
							previewBtn:SetTextByKey("name", ClMsg('PreviewBtn_Text_Discover'));
						end
					end
				end

				BEAUTYSHOP_DRAW_ITEM_DETAIL(itemInfo ,itemObj, ctrlSet);
			else
				--착용 가능한 것만 보이기
				local beautyShopCls = GetClass(itemInfo.IDSpace, itemObj.ClassName);
				local ret, reason = IS_ENABLE_EQUIP_AT_BEAUTYSHOP(itemObj, beautyShopCls);
				if ret == true then
					index = index + 1
					x = ( (index-1) % 2) * width
					y = (math.ceil( (index / 2) ) - 1) * (height * 1)
					ctrlSet = gbItemList:CreateOrGetControlSet("beautyshop_item", itemPrefix..index, x, y);
					ctrlSet:SetUserValue("INDEX_NAME", itemPrefix..index);
					ctrlSet:SetUserValue("ITEM_CLASS_NAME", itemInfo.ItemClassName);
				    ctrlSet:SetUserValue('IDSPACE', itemInfo.IDSpace);
					ctrlSet:SetUserValue('SHOP_CLASSNAME', itemInfo.ClassName);
					ctrlSet:SetUserValue('GENDER', beautyShopInfo.gender);
                                -- 패키지일 경우 미리보기 버튼이 살펴보기로 바껴야함
				if itemInfo.IDSpace == 'Beauty_Shop_Package_Cube' then
					if ctrlSet ~= nil then
						local previewBtn = ctrlSet:GetChild('previewBtn');
						if previewBtn ~= nil then
							previewBtn:SetTextByKey("name", ClMsg('PreviewBtn_Text_Discover'));
						end
					end
				end
					BEAUTYSHOP_DRAW_ITEM_DETAIL(itemInfo ,itemObj, ctrlSet);
				end
			end
		end
	end

	gbItemList:Invalidate()
	topFrame:Invalidate()
  end

  function IS_NEED_TO_SHOW_BEAUTYSHOP_ITEM(frame, item, beautyItemInfo)
	local beautyShopCls = GetClass(beautyItemInfo.IDSpace, beautyItemInfo.ClassName);
    if beautyShopCls.SellStartTime ~= 'None' and beautyShopCls.SellEndTime ~= 'None' then
    	if IS_CURREUNT_IN_PERIOD(beautyShopCls.SellStartTime, beautyShopCls.SellEndTime, true) == false then
    		return false;
    	end
    end

	local editInput = GET_CHILD_RECURSIVELY(frame, 'editInput');
	local searchText = editInput:GetText();
	if searchText ~= nil and searchText ~= '' then
		local itemName = dic.getTranslatedStr(item.Name);
		itemName = string.lower(itemName); -- 소문자로 변경
		searchText = string.lower(searchText); -- 소문자로 변경
		if string.find(itemName, searchText) == nil then
			return false;
		end
	end

	local selectedCategory = frame:GetUserValue('SELECTED_CATEGORY');
	if selectedCategory ~= 'None' then
		if beautyShopCls.Category ~= selectedCategory then
			return false;
		end
	end

  	return true;
  end

------------------------------------------ preview ---------------------------------------
-- 보이기/안보이기 클릭
function BEAUTYSHOP_SET_VISIBLE_STATE(parent)
	local name = parent:GetName() -- slot name
	if previewConfig.visiblePreviewSlotList[name] == true then
		previewConfig.visiblePreviewSlotList[name] = false
	else
		previewConfig.visiblePreviewSlotList[name] = true
	end

	-- Update Image
	local visible = previewConfig.visiblePreviewSlotList[name]
	local child = GET_CHILD(parent, "visible_"..name) -- 보이기 안보이기는 접두어로 visible_ 을 붙여야 한다.(주의)
	if visible == true then
		child:SetImage("inven_hat_layer_on");
	else
		child:SetImage("inventory_hat_layer_off");
	end
	
	-- preview refresh
	local topFrame = parent:GetTopParentFrame()
	BEAUTYSHOP_SET_PREVIEW_APC_IMAGE(topFrame, 0);
end

local function BEAUTYSHOP_GET_EQUIP_LIST()
	local equip_list = {}
	equip_list[ES_HAT] = "HAT"
	equip_list[ES_HAT_L] = "HAT_L"
	equip_list[ES_HAT_T] = "HAT_T"
	equip_list[ES_HAIR] = "HAIR"
	equip_list[ES_SHIRT] = "SHIRT"
	equip_list[ES_GLOVES] = "GLOVES"
	equip_list[ES_BOOTS] = "BOOTS"
	equip_list[ES_HELMET] = "HAIR"
	equip_list[ES_ARMBAND] = "ARMBAND"
	equip_list[ES_RH] = "RH"
	equip_list[ES_LH] = "LH"
	equip_list[ES_OUTER] = "OUTER"
	equip_list[ES_PANTS] = "PANTS"
	equip_list[ES_RING1] = "RING1"
	equip_list[ES_RING2] = "RING2"
	equip_list[ES_NECK] = "NECK"
	equip_list[ES_LENS] = "LENS"
	equip_list[ES_WING] = "WING"
	equip_list[ES_SPECIAL_COSTUME] = "SPECIAL_COSTUME"
	equip_list[ES_EFFECT_COSTUME] = "EFFECTCOSTUME"

	return equip_list
end 

local function BEAUTYSHOP_CHECK_EXCLUSION_ITEM(name)
	if previewConfig.useEquipHairCostume == false then
		if name == "HAT" or name == "HAT_L" or name == "HAT_T" then
			return true
		end
	end

	return false
end

local function BEAUTYSHOP_SET_PREVIEW_BASE_CHARACTER(apc, equip_list)

	-- 내 캐릭터의 가발 보이기/안보이기 설정에 따라 APC도 보이기/안보이기 설정을 해야 한다.
	local myPCetc = GetMyEtcObject();
	local hairWig_Visible = myPCetc.HAIR_WIG_Visible
	if hairWig_Visible == 1 then
		apc:SetHairWigVisible(true);
	else
		apc:SetHairWigVisible(false);
	end

	-- 기본 장착 아이템 설정
	local invframe = ui.GetFrame("inventory")
	local invSlot = nil;

	for i = 0, ES_LAST do
		local name = equip_list[i]
		invSlot = nil

		if name ~= nil then
			if BEAUTYSHOP_CHECK_EXCLUSION_ITEM(name) == false then
				invSlot = GET_CHILD_RECURSIVELY(invframe, name)
			end
		end

		local setClsID = 0
		if invSlot ~= nil then
			invSlot = tolua.cast(invSlot, "ui::CSlot")
			local icon = invSlot:GetIcon()
			if icon ~= nil then
				local info = icon:GetInfo()
				local invIteminfo = GET_PC_ITEM_BY_GUID(info:GetIESID())
				if invIteminfo ~= nil then
					local obj = GetIES(invIteminfo:GetObject())
					if obj ~= nil then
						local spotName = item.GetEquipSpotName(i)
						if spotName == obj.EqpType then
							setClsID = obj.ClassID
						end
					end
				end			
			end	
		end	
		apc:SetEquipItem(i, setClsID)
	end
	
end

local function BEAUTYSHOP_SET_PREVIEW_HAIR_COLOR(apc)
	local pc = GetMyPCObject()
	local nowheadindex = item.GetHeadIndex();

	local Rootclasslist = imcIES.GetClassList("HairType");
	local Selectclass   = Rootclasslist:GetClass(pc.Gender);
	local Selectclasslist = Selectclass:GetSubClassList();

	local nowhaircls = Selectclasslist:GetByIndex(nowheadindex-1);
	
	local nowengname = imcIES.GetString(nowhaircls, "EngName") 
	local nowcolor = imcIES.GetString(nowhaircls, "ColorE")
	
	local listCount = Selectclasslist:Count();
	
	for i=0, listCount do
		local cls = Selectclasslist:GetByIndex(i);
		if cls ~= nil then
			if nowengname == imcIES.GetString(cls, "EngName") and nowcolor == imcIES.GetString(cls, "ColorE") then
				apc:SetHeadType(i + 1);
				break;
			end
		end
	end
end

function BEAUTYSHOP_GET_PREVIEW_NAME_LIST()

	local slotNamelist = {
		"slotPreview_hair",
		"slotPreview_wig",
		"slotPreview_wig_dye",
		"slotPreview_hair_costume_1",
		"slotPreview_hair_costume_2",
		"slotPreview_hair_costume_3",
		"slotPreview_lens",
		"slotPreview_costume",
		"slotPreview_wing",
		"slotPreview_effect_costume",
		"slotPreview_armband",
		"slotPreview_lh", 
		"slotPreview_rh",
	}
	return slotNamelist
end


function BEAUTYSHOP_CHECK_TWOHAND_WEAPON(itemObj)
	local eqpType = TryGetProp(itemObj , "EqpType");
	if eqpType == nil then
		return nil
	end 

	if eqpType == "SH" then -- 한손무기일 경우
		return false
	elseif eqpType == "DH" then -- 양손 무기일 경우
		return true
	end
	return nil
end

function BEAUTYSHOP_GET_ITEM_WEAPON_EQUIPTYPE_BY_ITEMCLASSNAME(itemClassName)
	local retType = "None"

	-- itemClassName에 해당하는 item의 Eqp_Type을 가져와서 확인.
	local itemCls = GetClass("Item", itemClassName);
	if itemCls == nil then
		return retType
	end

	local checkTwoHandWeapon = BEAUTYSHOP_CHECK_TWOHAND_WEAPON(itemCls)
	if checkTwoHandWeapon == nil then
		return retType;
	end 

	if checkTwoHandWeapon == true then
		-- 양손 무기의 경우는 다른거 검사할 필요없음 그냥 LH, RH 둘다 변경.
		retType = "lh" -- lh를 주고 이큅할때 lh면 다시 검사한다.
	else
		-- 오른손 왼손 확인
		local defaultEqpSlot = TryGetProp(itemCls , "DefaultEqpSlot"); -- 장비슬롯 검사
		if defaultEqpSlot == nil then
			return retType
		end

		-- 왼손에 장착해야하는 경우 검사
		if defaultEqpSlot == "LH" then
			retType = "rh"  -- 데이터에 왼손은 코드의 오른손이다.
		else
			retType = "lh"
		end
	end

	return retType;
end

-- 무기 슬롯을 결정할 때 미리 왼손 오른손을 결정해주자. 
function BEAUTYSHOP_GET_EQUIPTYPE_BY_WEAPON_ABIL(equipType, itemClassName)
	
	if itemClassName == nil then
		return equipType
	end

	local itemCls = GetClass("Item", itemClassName);
	if itemCls == nil then
		return equipType
	end

	local propGroupName = TryGetProp(itemCls, "GroupName");
	local classType = TryGetProp(itemCls,"ClassType")

	local result = BEAUTYSHOP_CHECK_WEAPON_EQUIPABLE(itemCls.ClassID);
	if result == 'OK' then
		-- 착용이 가능하다면 왼손/오른손 어느쪽인지 확인.
		
		-- 한손검 보조장비 슬롯에 장착을 위한 검사.
		local propGroupName = TryGetProp(itemCls, "GroupName");
		local classType = TryGetProp(itemCls,"ClassType")
		local subSwordAbil = session.GetAbilityByName("SubSword");
		if subSwordAbil ~= nil and propGroupName == "Weapon" and classType == "Sword" then
			return "rh" -- 한손검을 보조장비에 장착.
		end
	else
		ui.SysMsg(ClMsg('BEAUTY_SHOP_EQUIPABLE_CHECK')); -- 경고문구.
		return "None"
	end

	return equipType
end


function BEAUTYSHOP_GET_ITEM_EQUIPTYPE_BY_ITEMCLASSNAME(equipType, itemClassName)
	if equipType == "None" then
		return equipType
	end

	if equipType == "weapon" then
		return BEAUTYSHOP_GET_ITEM_WEAPON_EQUIPTYPE_BY_ITEMCLASSNAME(itemClassName)
	end

	if equipType == "hair_costume" then
		-- itemClassName에 해당하는 item의 Eqp_Type을 가져와서 확인.
		local itemCls = GetClass("Item", itemClassName);
		if itemCls == nil then
			return equipType
		end

		local eqpType = TryGetProp(itemCls , "EqpType");
		if eqpType == nil then
			return equipType
		end
		local retType = "None"
		if eqpType == "HAT" then
			retType = "hair_costume_1"
		elseif eqpType == "HAT_T" then
			retType = "hair_costume_2"
		elseif eqpType == "HAT_L" then
			retType = "hair_costume_3"
		end

		return retType
	end
	
	return equipType
end 

function BEAUTYSHOP_GET_PREIVEW_SLOT_NAME(equipType, itemClassName)
	local matchList = {
			{previewEquipName = "hair" , 	slotName = "slotPreview_hair"},
			{previewEquipName = "wig" , 	slotName = "slotPreview_wig"},
			{previewEquipName = "wig_dye" , slotName = "slotPreview_wig_dye"},
			{previewEquipName = "hair_costume_1" , 	slotName = "slotPreview_hair_costume_1"},
			{previewEquipName = "hair_costume_2" , 	slotName = "slotPreview_hair_costume_2"},
			{previewEquipName = "hair_costume_3" , 	slotName = "slotPreview_hair_costume_3"},
			{previewEquipName = "lens" , 	slotName = "slotPreview_lens"},
			{previewEquipName = "costume" ,	slotName = "slotPreview_costume"},
			{previewEquipName = "wing",		slotName = "slotPreview_wing"},
			{previewEquipName = "effect_costume", slotName = "slotPreview_effect_costume"},
			{previewEquipName = "armband" , slotName = "slotPreview_armband"},
			{previewEquipName = "lh" , slotName = "slotPreview_lh"},
			{previewEquipName = "rh" , slotName = "slotPreview_rh"},
	}

	local _equipType = BEAUTYSHOP_GET_ITEM_EQUIPTYPE_BY_ITEMCLASSNAME(equipType,itemClassName )
	
	-- 무기일 경우 여기서 착용 가능 유무를 검사하고 rh/lh도 결정한다.
	if _equipType == "lh" or _equipType == "rh" then
		_equipType = BEAUTYSHOP_GET_EQUIPTYPE_BY_WEAPON_ABIL(_equipType, itemClassName)
	end
	
	for index = 1, #matchList do
		local data = matchList[index]
		if data.previewEquipName == _equipType then
			return data.slotName
		end
	end

	return nil
end

function BEAUTYSHOP_GET_PREVIEW_VISIBLE(name)
	local retVal =  previewConfig.visiblePreviewSlotList[name]
	if retVal == nil then
		retVal = true
	end

	return retVal
end

function BEAUTYSHOP_GET_HEADINDEX(gender, itemClassName, colorName)
	local hairEngName = ""
	local itemObj = GetClass("Item", itemClassName)
	if itemObj ~= nil then
		hairEngName = itemObj.StringArg;
	end

	local hairIndex = ui.GetHeadIndexByXML(gender, hairEngName, colorName);
	return hairIndex
end

function BEAUTYSHOP_SET_PREVIEW_HAIR_EQUIP_SLOT(apc, slot, existItem, classname)

	if apc == nil or slot == nil or existItem == nil or classname == nil then
		return
	end

	local defaultEqpSlot = TryGetProp(existItem,"DefaultEqpSlot")
	if defaultEqpSlot == nil then
		return
	end

	local colorName = slot:GetUserValue("COLOR_NAME")
	if colorName == nil or colorName == "None" then  -- 컬러 설정이 안될 경우 None이다. 디폴트로 바꿔줘야함.
		colorName = 'default'
	end
	apc:SetEquipItem(item.GetEquipSpotNum(defaultEqpSlot), 0);
	-- headindex 구해서 적용.
	local headIndex = BEAUTYSHOP_GET_HEADINDEX(apc:GetGender(), classname, colorName )
	apc:SetHeadType(headIndex);

end

function BEAUTYSHOP_SET_PREVIEW_WIG_EQUIP_SLOT(apc, existItem, classname)

	if apc == nil or existItem == nil or classname == nil then
		return
	end
	
	local defaultEqpSlot = TryGetProp(existItem,"DefaultEqpSlot")
	if defaultEqpSlot == nil then
		return
	end

	apc:SetHairWigVisible(true); -- 가발 보이기를 ON 해야 보인다.
	-- 헤드 타입을 바꾼다. (컬러 기본색으로 변경해야함.)
	local headIndex = BEAUTYSHOP_GET_HEADINDEX(apc:GetGender(), classname, 'default' )
	apc:SetHeadType(headIndex);
	-- 장착
	apc:SetEquipItem(item.GetEquipSpotNum(defaultEqpSlot), existItem.ClassID);	
end

function BEAUTYSHOP_SET_PREVIEW_WIG_DYE_EQUIP_SLOT(apc, topFrame, wigVisible, existItem)

	if apc == nil or topFrame == nil or wigVisible == nil or existItem == nil then
		return
	end

	local gbPreview = GET_CHILD_RECURSIVELY(topFrame,"gbPreview");	
	if gbPreview == nil then 
		return
	end

	if wigVisible ~= true then -- 가발보이기가 true일 때만 염색 적용
		return
	end

	-- 조건에 충족하면 현재 가발슬롯에 장착된 가발을 가져온다.
	local wigSlot = GET_CHILD_RECURSIVELY(gbPreview, 'slotPreview_wig');
	if wigSlot ~= nil then
		local wigClassName = wigSlot:GetUserValue("CLASSNAME");
		local wigCls = GetClass("Item", wigClassName)
		local colorName = existItem.StringArg
		
		local headIndex = BEAUTYSHOP_GET_HEADINDEX(apc:GetGender(), wigClassName, colorName )
		apc:SetHeadType(headIndex);
	end

end

function BEAUTYSHOP_SET_PREVIEW_WEAPON_EQUIP_SLOT(apc, slot, existItem, classname)
	
	if apc == nil or slot == nil or slot == nil or classname == nil then
		return
	end
	-- 선행 조건들 처리 (선행 조건에 해당하면 설정하고 리턴시켜야함)

	-- 장착 가능한 장비인지?
	local result = BEAUTYSHOP_CHECK_WEAPON_EQUIPABLE(existItem.ClassID);
	if result ~= 'OK' then
		return
	end
	
	local eqpType = TryGetProp(existItem , "EqpType");
	if eqpType ~= nil then
		-- slot의 이름을 확인한다. 좌/우 구분
		local slotName = slot:GetName();
		if slotName ~= nil then
			if slotName == "slotPreview_lh" then
				-- 왼손/오른손 상관없이 장비한다.
				apc:SetEquipItem(ES_RH, existItem.ClassID);
			elseif slotName == "slotPreview_rh" then
				-- 양손이라면 왼손과 똑같은 무기가 들어 있어야 한다.
				if eqpType == "SH" then -- 한손무기일 경우
					apc:SetEquipItem(ES_LH, existItem.ClassID);
				end
				-- 양손무기라면 그냥 리턴된다.
			end
			return
		end
	end

	-- 모든 선행조건을 통과하면 디폴트 슬롯의 정보를 이용해 설정한다.
	local defaultEqpSlot = TryGetProp(existItem,"DefaultEqpSlot")
	if defaultEqpSlot ~= nil then
		apc:SetEquipItem(item.GetEquipSpotNum(defaultEqpSlot), existItem.ClassID);
	end
end

function BEAUTYSHOP_SET_PREVIEW_SLOT_LIST(apc)

-- 리팩토링용 테스트 슬롯세팅. (리팩토링 전과 후가 같으면 통과.)
	--TEST_BEAUTYSHOP_SET_FORCE_PREVIEW_SLOT()

	local topFrame = ui.GetFrame("beautyshop");
    local gbPreview = GET_CHILD_RECURSIVELY(topFrame,"gbPreview");	
	if gbPreview == nil then
		return 
	end

	-- 미리보기 장착 : 미리보기 슬롯들을 이용해 덮어쓴다.
	local wigVisible = false -- 가발이 visible 상태인지 (염색약을 적용하려면 이게 visible 상태여야 한다.)
	local slotNameList = BEAUTYSHOP_GET_PREVIEW_NAME_LIST()
	for index = 1, #slotNameList do
		local name = slotNameList[index]
		local visible = BEAUTYSHOP_GET_PREVIEW_VISIBLE(name)
		local slot = GET_CHILD_RECURSIVELY(gbPreview, name);
		if visible == true then
			local classname = slot:GetUserValue("CLASSNAME");
			local type = slot:GetUserValue("TYPE")	-- 슬롯의 타입. hair, wig..
			local existItem = GetClass("Item",classname);
			if existItem ~= nil then
				-- type에 따른 처리 (hair, wig, wig_dye, weapon)
				if type == "hair" then -- hair
					BEAUTYSHOP_SET_PREVIEW_HAIR_EQUIP_SLOT(apc, slot, existItem, classname);
				elseif type == "wig" then -- wig 
					wigVisible = visible -- 가발 상태를 설정.
					BEAUTYSHOP_SET_PREVIEW_WIG_EQUIP_SLOT(apc, existItem, classname);
				elseif type == "wig_dye" then -- wig_dye
					BEAUTYSHOP_SET_PREVIEW_WIG_DYE_EQUIP_SLOT(apc, topFrame, wigVisible, existItem);
				elseif type == "weapon" or type == "rh" or type == "lh" then -- weapon (rh, lh)
					BEAUTYSHOP_SET_PREVIEW_WEAPON_EQUIP_SLOT(apc, slot, existItem, classname);
				else -- 그외
					local defaultEqpSlot = TryGetProp(existItem,"DefaultEqpSlot")
					if defaultEqpSlot ~= nil  then -- DefaultEqpSlot이 있는것만.
						apc:SetEquipItem(item.GetEquipSpotNum(defaultEqpSlot), existItem.ClassID);
					end
				end
			end			
		end
	end
end

function BEAUTYSHOP_CANCEL_SELECT_ITEM(frame, control)
	local topFrame = frame:GetTopParentFrame()
	if topFrame == nil then
		return
	end

	local gbItemList = GET_CHILD_RECURSIVELY(topFrame,"gbItemList");
	if gbItemList == nil then
		return
	end

	local savedIDSpace = control:GetUserValue('IDSPACE')
	local savedClassName = control:GetUserValue('CLASSNAME')
	
	-- 헤어샵 일 때는 캔슬하지 않음.
	if savedIDSpace == 'Beauty_Shop_Hair' then
		return
	end

	local childCnt = gbItemList:GetChildCount();	
	for i = 0, childCnt - 1 do
		local child = gbItemList:GetChildByIndex(i);
		if string.find(child:GetName(), 'item_') ~= nil then
			local idspace = child:GetUserValue('IDSPACE');
			local className = child:GetUserValue('ITEM_CLASS_NAME');
			if savedIDSpace == idspace and savedClassName == className then
				local picCheck = child:GetChild("picCheck")
				if picCheck ~= nil then
					picCheck:SetVisible(0);
				end
				break
			end
		end
	end
end

-- 미리보기에서 해당 슬롯만 제거(우클릭 제거)
function BEAUTYSHOP_PREVIEWSLOT_REMOVE(parent, control, strArg, numArg)
	BEAUTYSHOP_CANCEL_SELECT_ITEM(parent, control)
	
	-- 넘어온 장비가 양손무기면, 반대쪽 무기 슬롯도 해제.
	local itemClassName = control:GetUserValue("CLASSNAME");
	local itemCls = GetClass("Item", itemClassName);
	if itemCls ~= nil then
		local checkTwoHandWeapon = BEAUTYSHOP_CHECK_TWOHAND_WEAPON(itemCls)
		if checkTwoHandWeapon == true then
			BEAUTYSHOP_RESET_TWOHAND_WEAPON_SLOT(control)
		end
	end

	BEAUTYSHOP_CLEAR_SLOT(control);
	BEAUTYSHOP_SET_PREVIEW_APC_IMAGE(parent:GetTopParentFrame(), 99);
end

-- 미리보기에서 해당 슬롯에 장착
function BEAUTYSHOP_PREVIEWSLOT_EQUIP(frame, slot, itemObj)
    local clickedCtrlsetName = frame:GetUserValue('CLICKED_ITEM_CTRLSET_NAME');
	local ctrlset = GET_CHILD_RECURSIVELY(frame, clickedCtrlsetName);

	slot:SetEventScript(ui.RBUTTONDOWN, 'BEAUTYSHOP_PREVIEWSLOT_REMOVE');
	slot:SetUserValue("CLASSNAME", itemObj.ClassName);
	slot:SetUserValue('IDSPACE', ctrlset:GetUserValue('IDSPACE'));
	slot:SetUserValue('SHOP_CLASSNAME', ctrlset:GetUserValue('SHOP_CLASSNAME'));
	slot:SetUserValue('GENDER', beautyShopInfo.gender);

	SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(itemObj));
	local icon = slot:GetIcon();
	icon:SetTooltipType('wholeitem');
	icon:SetTooltipArg('', itemObj.ClassID, 0);

	-- hair일 경우 염색 확인
	local type = slot:GetUserValue("TYPE")
	if type == "hair" then
		local color = slot:GetUserValue("COLOR_NAME")
		if color ~= nil and color ~= "None" and color ~= "default" then		
			-- 팔레트 설정
			BEAUTYSHOP_ADD_PALLETE_IMAGE(slot);
		end
		
	elseif type =="weapon" or type == "rh" or type =="lh" then --무기일 경우 장착 가능한지 검사
		-- 양손 무기일 경우 lh슬롯이라면 rh도 세팅해준다. rh 덮어버림
		if BEAUTYSHOP_CHECK_TWOHAND_WEAPON(itemObj) == true then
			local idSpace = ctrlset:GetUserValue('IDSPACE')
			local shopClassName = ctrlset:GetUserValue('SHOP_CLASSNAME')
			BEAUTYSHOP_SET_TWOHAND_WEAPON_SLOT(itemObj, idSpace, shopClassName );
		else
			-- 기존에 양손무기를 끼고있었는데 한손무기로 바뀌면 반대쪽을 해제한다.
			BEAUTYSHOP_RESET_TWOHAND_WEAPON_SLOT(slot)
		end
	end

	
	BEAUTYSHOP_SET_PREVIEW_APC_IMAGE(frame, 99);
end

function BEAUTYSHOP_RESET_TWOHAND_WEAPON_SLOT(slot)
	if slot == nil then
		return 
	end

	local topFrame = ui.GetFrame("beautyshop");
    local gbPreview = GET_CHILD_RECURSIVELY(topFrame,"gbPreview");	
	if gbPreview == nil then
		return 
	end

	local slotName = slot:GetName()
	local otherSlotName = "slotPreview_lh";
	if slotName == "slotPreview_lh" then
		otherSlotName = "slotPreview_rh";
	end

	local otherSlot = GET_CHILD(gbPreview, otherSlotName)
	if otherSlot == nil then
		return
	end

	local className = otherSlot:GetUserValue("CLASSNAME");
	local itemCls = GetClass("Item", className);
	if itemCls == nil then
		return
	end

	-- 양손 무기라면 해제한다.
	if BEAUTYSHOP_CHECK_TWOHAND_WEAPON(itemCls) == true then
		BEAUTYSHOP_CLEAR_SLOT(otherSlot);
	end
end

function BEAUTYSHOP_SET_TWOHAND_WEAPON_SLOT(itemObj, idSpace, shopClassName)
	local topFrame = ui.GetFrame("beautyshop");
    local gbPreview = GET_CHILD_RECURSIVELY(topFrame,"gbPreview");	
	if gbPreview == nil then
		return 
	end

	local slot = GET_CHILD(gbPreview, "slotPreview_rh")
	if slot == nil then
		return
	end

	if itemObj == nil then
		return
	end

	-- 슬롯에 있는 정보를 날린다.
	slot:ClearText();
	slot:ClearIcon();
	slot:SetUserValue("CLASSNAME", "None");
	slot:RemoveChild('HAIR_DYE_PALETTE')	

	-- slot에 정보 넣기	
	slot:SetUserValue("TYPE", equipType)	
	slot:SetEventScript(ui.RBUTTONDOWN, 'BEAUTYSHOP_PREVIEWSLOT_REMOVE');
	slot:SetUserValue("CLASSNAME", itemObj.ClassName);
    slot:SetUserValue('IDSPACE',idSpace);
	slot:SetUserValue('SHOP_CLASSNAME', shopClassName);
	slot:SetUserValue('GENDER', beautyShopInfo.gender);

	SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(itemObj));
	local icon = slot:GetIcon();
	icon:SetTooltipType('wholeitem');
	icon:SetTooltipArg('', itemObj.ClassID, 0);

end

function BEAUTYSHOP_ADD_PALLETE_IMAGE(slot)
	local beautyshop = ui.GetFrame("beautyshop");
	local paletteImageName = beautyshop:GetUserConfig('HAIR_DYE_PALETTE_IMAGE_NAME')
	local pic = slot:CreateControl('picture', 'HAIR_DYE_PALETTE', 0,0, slot:GetWidth(), slot:GetHeight())
	pic = tolua.cast(pic, 'ui::CPicture');
	pic:SetImage(paletteImageName);
	pic:EnableHitTest(0);
	pic:SetEnableStretch(1);
	pic:ShowWindow(1);
end

-- 미리보기
function BEAUTYSHOP_SET_PREVIEW_APC_IMAGE(frame, rotDir)
	local pcSession = session.GetMySession()
	if pcSession == nil then
		return
	end
	
	local apc = pcSession:GetPCDummyApc()
	local equip_list = BEAUTYSHOP_GET_EQUIP_LIST() 

	-- 캐릭터 기본 장비 끼우기.
	BEAUTYSHOP_SET_PREVIEW_BASE_CHARACTER(apc, equip_list)

	-- 캐릭터 헤어 컬러 설정.
	BEAUTYSHOP_SET_PREVIEW_HAIR_COLOR(apc)
	
	-- 미리보기 물품 장착
	BEAUTYSHOP_SET_PREVIEW_SLOT_LIST(apc)

	-- 갱신
	local shihouette = GET_CHILD_RECURSIVELY(frame,"picSilhouette")
	local imgName = "None"
	-- rotDir은 1, 2 밖에 없고 0을 던질 경우 정면 이름을 반환한다. (1,2는 회전)
	-- 제자리를 그리려면 1로 넘겨서 이름을 받고 다시 2를 넘겨서 받아야 한다.
	-- rotDir이 99로 넘어오면 제자리를 보여주는 것으로 판단하고 두번 조작한다.
	if rotDir == 99 then
		imgName = ui.CaptureMyFullStdImageByAPC(apc, 1, 1);
		imgName = ui.CaptureMyFullStdImageByAPC(apc, 2, 1);
	else 
		imgName = ui.CaptureMyFullStdImageByAPC(apc, rotDir, 1);
	end

	shihouette:SetImage(imgName);
	frame:Invalidate();
end


-- 내 apc의 성별과 매개변수의 성별을 비교 (같으면 true)
function BEAUTYSHOP_CHECK_MY_GENDER(checkGender)
	local pcSession = session.GetMySession()
	if pcSession == nil then
		return false
	end
	
	local apc = pcSession:GetPCDummyApc()
	-- checkGender가 0 일경우 성별 제한이 없다.
	if checkGender ~= 0  and checkGender ~= apc:GetGender() then
		return false
	end

	return true
end

-- 뷰티샵 프리뷰의 슬롯 가져오기
function BEAUTYSHOP_GET_PREIVEW_SLOT(equipType, itemClassName)

	local topFrame = ui.GetFrame("beautyshop");
    local gbPreview = GET_CHILD_RECURSIVELY(topFrame,"gbPreview");	
	if gbPreview == nil then
		return nil
	end

	-- equiptype을 통해 슬롯 가져오기.
	local slotName = BEAUTYSHOP_GET_PREIVEW_SLOT_NAME(equipType, itemClassName) 
	if slotName == nil then
		return nil
	end

	local slot = GET_CHILD(gbPreview, slotName)
	if slot == nil then
		return nil
	end

	return slot
end

function BEAUTYSHOP_BUY_BASKET_BTN_CLICK(parent, ctrl)
    local frame = parent:GetTopParentFrame();
    local list = GET_CURRENT_BASKET_ITEM_LIST(frame);
    if #list < 1 then
    	ui.SysMsg(ClMsg('EmptyBasket'));
    	return;
    end
	SHOW_BEAUTYSHOP_SIMPLELIST(false, list);
end

function GET_CURRENT_TRY_ON_ITEM_LIST(frame)
	local equipTypeList = {'hair', 'wig', 'wig_dye', 'hair_costume_1', 'hair_costume_2', 'hair_costume_3', 'lens', 'costume', 'wing', 'effect_costume', 'armband', 'lh', 'rh'};
	local list = {};
	for i = 1, #equipTypeList do
		local slot = GET_CHILD_RECURSIVELY(frame, 'slotPreview_'..equipTypeList[i]);
		local clsName = slot:GetUserValue('CLASSNAME');
		if clsName ~= 'None' then
			list[#list + 1] = {};
            local listItem = list[#list];
            listItem['IDSpace'] = slot:GetUserValue('IDSPACE');
            listItem['ClassName'] = slot:GetUserValue('SHOP_CLASSNAME');
            listItem['ItemClassName'] = clsName;
            listItem['equipType'] = equipTypeList[i];
            listItem['ColorName'] = slot:GetUserValue('COLOR_NAME');
            listItem['ColorClassName'] = slot:GetUserValue('COLOR_CLASS_NAME');
			listItem['HairClassName'] = slot:GetUserValue('SUB_ITEM_CLASS_NAME');
			listItem['Gender'] = slot:GetUserValue('GENDER');
		end
	end
	return list;
end

function GET_CURRENT_BASKET_ITEM_LIST(frame)
    local list = {};
	local slotsetBasket = GET_CHILD_RECURSIVELY(frame, 'slotsetBasket');
    local slotCnt = slotsetBasket:GetSlotCount();
    for i = 0 , slotCnt - 1 do
        local slot = slotsetBasket:GetSlotByIndex(i);
        local clsName = slot:GetUserValue('CLASSNAME');
		if clsName ~= 'None' then
			list[#list + 1] = {};
            local listItem = list[#list];
            listItem['IDSpace'] = slot:GetUserValue('IDSPACE');
            listItem['ClassName'] = slot:GetUserValue('SHOP_CLASSNAME');
            listItem['ItemClassName'] = clsName;
            listItem['ColorName'] = slot:GetUserValue('COLOR_NAME');
            listItem['ColorClassName'] = slot:GetUserValue('COLOR_CLASS_NAME');
			listItem['HairClassName'] = slot:GetUserValue('SUB_ITEM_CLASS_NAME');
			listItem['Gender'] = slot:GetUserValue('GENDER');
		end
    end
	return list;
end

function BEAUTYSHOP_RESET_PREIVEWMODEL(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local previewList = BEAUTYSHOP_GET_PREVIEW_NAME_LIST();
	for i = 1, #previewList do
		local slot = GET_CHILD_RECURSIVELY(frame, previewList[i]);
		BEAUTYSHOP_CLEAR_SLOT(slot);
	end
	BEAUTYSHOP_SET_PREVIEW_APC_IMAGE(parent:GetTopParentFrame(), 99);
end

function IS_ALREAY_PUT_HAIR_IN_BASKET(frame, slotset)
	local slotCount = slotset:GetSlotCount();
	for i = 0, slotCount - 1 do
		local slot = slotset:GetSlotByIndex(i);		
		local idSpace = slot:GetUserValue('IDSPACE');
		if idSpace == 'Beauty_Shop_Hair' or idSpace == 'Hair_Dye_List' then
			return slot;
		end
	end
	return nil;
end

function BEAUTYSHOP_SELECT_DROPLIST(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	frame:SetUserValue('SELECTED_CATEGORY', ctrl:GetSelItemKey());
	BEAUTYSHOP_UPDATE_ITEM_LIST_BY_SHOP(frame);
end

function BEAUTYSHOP_CLICK_CHECKBOX(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	BEAUTYSHOP_UPDATE_ITEM_LIST_BY_SHOP(frame);
end

g_beautyshopCategory = {};
function GET_BEAUTYSHOP_CATEGORY_LIST(idSpace)
	if g_beautyshopCategory[idSpace] ~= nil then
		return g_beautyshopCategory[idSpace];
	end

	local list = {};
	local tempMap = {};
	local clslist, cnt = GetClassList(idSpace);
	for i = 0, cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		if tempMap[cls.Category] == nil then
			list[#list + 1] = cls.Category;			
			tempMap[cls.Category] = true;
		end
	end

	g_beautyshopCategory[idSpace] = list;
	return list;
end

function BEAUTYSHOP_INIT_DROPLIST(frame)
	local cateDrop = GET_CHILD_RECURSIVELY(frame, 'cateDrop');
	local shopTypeName = frame:GetUserValue('CURRENT_SHOP');
	if shopTypeName == 'HAIR' then
		cateDrop:ShowWindow(0);
		return;
	end

	local style = '{@st41b}{s16}';
	cateDrop:ClearItems();
	cateDrop:AddItem('None', style..ClMsg('Auto_MoDu_BoKi'));
	local cateList = GET_BEAUTYSHOP_CATEGORY_LIST(frame:GetUserValue('IDSPACE'));
	for i = 1, #cateList do
		cateDrop:AddItem(cateList[i], style..ClMsg(cateList[i]));
	end

	cateDrop:ShowWindow(1);
end

function BEAUTYSHOP_UPDATE_ITEM_LIST_BY_SHOP(frame)	
	local shopName = frame:GetUserValue('CURRENT_SHOP');
	if shopName == 'HAIR' then
		HAIRSHOP_INIT_FUNCTIONMAP();
		HAIRSHOP_GET_SHOP_ITEM_LIST(BEAUTYSHOP_GET_GENDER());
	elseif shopName == 'COSTUME' then
		COSTUMESHOP_INIT_FUNCTIONMAP();
		COSTUMESHOP_GET_SHOP_ITEM_LIST(BEAUTYSHOP_GET_GENDER());
	elseif shopName == 'WIG' then
		WIGSHOP_INIT_FUNCTIONMAP();
		WIGSHOP_GET_SHOP_ITEM_LIST(BEAUTYSHOP_GET_GENDER());
	elseif shopName == 'ETC' then
		ETCSHOP_INIT_FUNCTIONMAP();
		ETCSHOP_GET_SHOP_ITEM_LIST(BEAUTYSHOP_GET_GENDER());
	elseif shopName == 'PACKAGE' then
		PACKAGESHOP_INIT_FUNCTIONMAP();
		PACKAGESHOP_GET_SHOP_ITEM_LIST(BEAUTYSHOP_GET_GENDER());
	elseif shopName == 'PREVIEW' then
		PREVIEWSHOP_INIT_FUNCTIONMAP();
		PREVIEWSHOP_GET_SHOP_ITEM_LIST();
	end
end

----------- 구매
function  BEAUTYSHOP_EXEC_BUY_PURCHASE_ITEM(idSpaceList, classNameList, colorList, hairCouponGuid, dyeCouponGuid)
    if #idSpaceList ~= #classNameList or #idSpaceList ~= #colorList then
        IMC_LOG('ERROR_LOGIC', 'BEAUTYSHOP_EXEC_BUY_PURCHASE_ITEM: list count must be equal- idspace['..#idSpaceList..'], className['..#classNameList..'], color['..#colorList..']');
        return;
    end
 
	-- 구매를 위해 목록을 만들고 서버로 전달.
	session.beautyshop.ResetPurchaseItemList();
    for i = 1, #idSpaceList do
    	session.beautyshop.AddPurchaseItem(idSpaceList[i], classNameList[i], colorList[i]);
    end
	session.beautyshop.SendPurchaseItemList(hairCouponGuid, dyeCouponGuid);
	
	local frame = ui.GetFrame('beautyshop');
	BEAUTYSHOP_RESET_SLOT(frame);
	BEAUTYSHOP_UPDATE_PRICE_INFO(frame);
end

function BEAUTYSHOP_RESET_SLOT(frame)
	BEAUTYSHOP_RESET_SLOT_BASKET(frame);
	BEAUTYSHOP_RESET_PREIVEWMODEL(frame);
end

function BEAUTYSHOP_RESET_SLOT_BASKET(frame)
	local slotsetBasket = GET_CHILD_RECURSIVELY(frame, 'slotsetBasket');
	local slotCount = slotsetBasket:GetSlotCount();
	for i = 0, slotCount - 1 do
		local slot = slotsetBasket:GetSlotByIndex(i);		
		BEAUTYSHOP_CLEAR_SLOT(slot);
	end

	slotsetBasket:ClearIconAll();
end

function BEAUTYSHOP_INIT_RIGHTTOP_BOX(frame)
	local rtSubItemTitle = GET_CHILD_RECURSIVELY(frame, 'rtSubItemTitle');
	local gbSubItem = GET_CHILD_RECURSIVELY(frame, 'gbSubItem');
	local bannerPic = GET_CHILD_RECURSIVELY(frame, 'bannerPic');
	local infoText = GET_CHILD_RECURSIVELY(frame, 'infoText');

	local shopName = frame:GetUserValue('CURRENT_SHOP');
	if shopName == 'HAIR' then
		rtSubItemTitle:ShowWindow(1);
		gbSubItem:ShowWindow(1);
		infoText:ShowWindow(1);
		bannerPic:ShowWindow(0);
	else
		rtSubItemTitle:ShowWindow(0);
		gbSubItem:ShowWindow(0);
		infoText:ShowWindow(0);
		bannerPic:ShowWindow(1);
	end
end

function BEAUTYSHOP_DETAIL_PREMIUM(ctrlset, itemCls, beautyShopCls)
	local noneBtnPreSlot_1 = GET_CHILD(ctrlset, 'noneBtnPreSlot_1');
	local title = GET_CHILD(ctrlset, 'title');
	local premiumPic = GET_CHILD(ctrlset, 'premiumPic');
	if beautyShopCls.IsPremium ~= 'NO' then
		noneBtnPreSlot_1:ShowWindow(1);
		premiumPic:ShowWindow(1);
		title:SetFontName('white_16_b_ol')
	else --프리미엄이 아닐 경우
		noneBtnPreSlot_1:ShowWindow(0);
		premiumPic:ShowWindow(0);
		title:SetFontName('black_16_b')
	end
end

function BEAUTYSHOP_DETAIL_TAG(ctrlset, itemCls, beautyShopCls)
	local isNew_mark = GET_CHILD(ctrlset, 'isNew_mark');
	local isHot_mark = GET_CHILD(ctrlset, 'isHot_mark');
	local isRec_mark = GET_CHILD(ctrlset, 'isRec_mark');
	local isSale_mark = GET_CHILD(ctrlset, 'isSale_mark');
	local isLimit_mark = GET_CHILD(ctrlset, 'isLimit_mark');

	isNew_mark:ShowWindow(IS_NEED_TO_SHOW_BEAUTYSHOP_NEW_MARK(beautyShopCls));
	isHot_mark:ShowWindow(IS_NEED_TO_SHOW_BEAUTYSHOP_HOT_MARK(beautyShopCls));
	isRec_mark:ShowWindow(IS_NEED_TO_SHOW_BEAUTYSHOP_RECOMMEND_MARK(beautyShopCls));
	isSale_mark:ShowWindow(IS_NEED_TO_SHOW_BEAUTYSHOP_SALE_MARK(beautyShopCls));
	isLimit_mark:ShowWindow(IS_NEED_TO_SHOW_BEAUTYSHOP_LIMIT_MARK(beautyShopCls));
	BEAUTYSHOP_DETAL_TIME_LIMIT(ctrlset, isLimit_mark, beautyShopCls.SellEndTime);
end

function BEAUTYSHOP_DETAL_TIME_LIMIT(ctrlset, isLimit_mark, limitTimeStr)
	local time_limited_bg = GET_CHILD(ctrlset, 'time_limited_bg');
	local time_limited_text = GET_CHILD(ctrlset, 'time_limited_text');
	time_limited_bg:ShowWindow(isLimit_mark:IsVisible());
	time_limited_text:ShowWindow(isLimit_mark:IsVisible());

	if isLimit_mark:IsVisible() == 1 then
		local convertedTimestamp, runyear, runmonth, runday, runhour, runminute, runseconds = CONVERT_DATESTR_TO_TIME_STAMP(limitTimeStr);
		local targetTimeStr = string.format('%04d%02d0%02d%02d%02d%02d', runyear, runmonth, runday, runhour, runminute, runseconds);
		time_limited_text:SetUserValue('TARGET_TIME', targetTimeStr);		
		time_limited_text:RunUpdateScript('SHOW_REMAIN_BEAUTYSHOP_SALE_TIME');
	end
end

function SHOW_REMAIN_BEAUTYSHOP_SALE_TIME(ctrl)
	local targetTimeStr = ctrl:GetUserValue('TARGET_TIME');
	local targetSysTime = imcTime.GetSysTimeByStr(targetTimeStr);
	local curSysTime = GET_CURRENT_SYSTEMTIME(true);
	local remainEndTime = imcTime.GetDifSec(targetSysTime, curSysTime);		
	if remainEndTime == nil or 0 > remainEndTime then		
		BEAUTYSHOP_UPDATE_ITEM_LIST_BY_SHOP(ctrl:GetTopParentFrame());
		return 0;
	end

	local timeTxt = GET_TIME_TXT(remainEndTime);
	ctrl:SetTextByKey("remainTime", timeTxt);
	return 1;
end

LIMIT_NEW_ITEM_SEC = 60 * 60 * 24 * 14; -- 2주
function IS_NEED_TO_SHOW_BEAUTYSHOP_NEW_MARK(beautyShopCls)
	if beautyShopCls.TAG == 'New'then
		return 1;
	end
	local year, month, day, hour, minute, second = GET_DATE_BY_DATE_STRING(beautyShopCls.ItemAddDate);
	if year > 0 then
		local addTime = geTime.GetServerSystemTime();
		addTime.wYear = year;
		addTime.wMonth = month;
		addTime.wDay = day;
		addTime.wHour = hour;
		addTime.wMinute = minute;
		addTime.wSecond = second;
        local deltaTime = imcTime.GetDiffSecFromNow(addTime);
		if deltaTime > 0 and deltaTime < LIMIT_NEW_ITEM_SEC then
			return 1;
		end
	end

	return 0;
end

function IS_NEED_TO_SHOW_BEAUTYSHOP_HOT_MARK(beautyShopCls)
	if beautyShopCls.TAG == 'Hot'then
		return 1;
	end
	return 0;
end

function IS_NEED_TO_SHOW_BEAUTYSHOP_RECOMMEND_MARK(beautyShopCls)
	if beautyShopCls.TAG == 'Rec'then
		return 1;
	end
	return 0;
end

function IS_NEED_TO_SHOW_BEAUTYSHOP_SALE_MARK(beautyShopCls)
	if beautyShopCls.PriceRatio > 0 then
		return 1;
	end
	return 0;
end

function IS_NEED_TO_SHOW_BEAUTYSHOP_LIMIT_MARK(beautyShopCls)	
	if beautyShopCls.SellStartTime ~= 'None' and beautyShopCls.SellEndTime ~= 'None' and IS_CURREUNT_IN_PERIOD(beautyShopCls.SellStartTime, beautyShopCls.SellEndTime, true) == true then		
		return 1;
	end
	return 0;
end

function BEAUTYSHOP_DETAIL_SET_PRICE_TEXT(ctrlset, beautyShopCls)
	local nxp = GET_CHILD(ctrlset, 'nxp');

	if beautyShopCls.Price == -1 then
		nxp:SetText("{@st43}{s18}-{/}");
	else
		local discountRatio = beautyShopCls.PriceRatio;	
		if discountRatio > 0 then
			local frame = ctrlset:GetTopParentFrame();
			local DISCOUNT_COLOR = frame:GetUserConfig('DISCOUNT_COLOR');
			nxp:SetText(DISCOUNT_COLOR..'{cl}'..beautyShopCls.Price..'{/}{/}{/} {@st43}{s18}'..math.floor(beautyShopCls.Price / 100 * (100 -discountRatio)));
		else
			nxp:SetText("{@st43}{s18}"..beautyShopCls.Price.."{/}");
		end
	end
end

function GET_ALLOW_DUPLICATE_ITEM_CLIENT_MSG(itemClassName) -- return 'buy case client msg', 'preview case client msg'
	local itemCls = GetClass('Item', itemClassName);
	if itemCls.Script == 'SCR_USE_ITEM_HAIRCOLOR' then -- 염색약 처리
		local etc = GetMyEtcObject();		
		if TryGetProp(etc, 'HairColor_'..itemCls.StringArg, 0) == 1 then
			return 'AlreadyHaveWigDye', 'AlreadyHaveWigDyePreview';
		end
		if session.GetInvItemByType(itemCls.ClassID) ~= nil then
			return 'AlreadyHaveWigDye', 'AlreadyHaveWigDyePreview';
		end
		if session.GetWarehouseItemByType(itemCls.ClassID) ~= nil then
			return 'AlreadyHaveWigDye', 'AlreadyHaveWigDyePreview';
		end
	end

	if TryGetProp(itemCls, 'AllowDuplicate', 'None') ~= 'NO' then
		return '', '';
	end

	if session.GetInvItemByType(itemCls.ClassID) ~= nil then
		return 'AlearyHaveItemReallyBuy?', 'AlreadyHaveWannaRebuyFromPreview';
	end
	if session.GetEquipItemByType(itemCls.ClassID) ~= nil then
		return 'AlearyHaveItemReallyBuy?', 'AlreadyHaveWannaRebuyFromPreview';
	end
	if session.GetWarehouseItemByType(itemCls.ClassID) ~= nil then
		return 'AlearyHaveItemReallyBuy?', 'AlreadyHaveWannaRebuyFromPreview';
	end
	return '', '';
end


-- 기본 직업, 레벨,  성별 확인 후 어빌이 있는 경우에만 낄 수 있음.
function BEAUTYSHOP_CHECK_WEAPON_EQUIPABLE(itemClassID)
	local pc = GetMyPCObject();
	local lv = GETMYPCLEVEL();
	local job = GETMYPCJOB();
	local gender = GETMYPCGENDER();
	local prop = geItemTable.GetProp(itemClassID);
	
	local ret = prop:CheckEquip(lv, job, gender);
	local haveAbil =  session.IsEquipWeaponAbil(itemClassID);
	
	if ret == 'OK' then
		if 0 ~= haveAbil then
			return ret;
		else
			return 'ABIL'
		end
	else
		if ret == 'LV' or ret == 'GENDER' then
			return ret;
		elseif 2 == haveAbil then
			return 'OK'
		end
	end

	return ret;
end