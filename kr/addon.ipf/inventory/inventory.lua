-- inventory.lua


g_invenTypeStrList = {"Equip", "Item"};

function INVENTORY_ON_INIT(addon, frame)

	addon:RegisterMsg('ITEM_LOCK_FAIL', 'INV_ITEM_LOCK_SAVE_FAIL');
	addon:RegisterMsg('MYPC_CHANGE_SHAPE','INVENTORY_MYPC_CHANGE_SHAPE');
    addon:RegisterMsg('GAME_START', 'INVENTORY_ON_MSG');
	addon:RegisterMsg('EQUIP_ITEM_LIST_GET', 'INVENTORY_ON_MSG');
    addon:RegisterOpenOnlyMsg('INV_ITEM_LIST_GET', 'INVENTORY_ON_MSG');
	addon:RegisterMsg('INV_ITEM_ADD', 'INVENTORY_ON_MSG');
	addon:RegisterMsg('INV_ITEM_REMOVE', 'INVENTORY_ON_MSG');
	addon:RegisterMsg('INV_DRAW_MONEY_TEXT', 'INVENTORY_ON_MSG');
	addon:RegisterOpenOnlyMsg('INV_ITEM_CHANGE_COUNT', 'INVENTORY_ON_MSG', 1);
	addon:RegisterOpenOnlyMsg('LEVEL_UPDATE', 'INVENTORY_ON_MSG');
	addon:RegisterOpenOnlyMsg('ITEM_PROP_UPDATE', 'INVENTORY_ITEM_PROP_UPDATE', 1);
	addon:RegisterMsg('CHANGE_INVINDEX', 'ON_CHANGE_INVINDEX');
	addon:RegisterMsg('ACCOUNT_UPDATE', 'INVENTORY_ON_MSG');
	addon:RegisterMsg('JUNGTAN_SLOT_UPDATE', 'JUNGTAN_SLOT_INVEN_ON_MSG');
	addon:RegisterOpenOnlyMsg('WEIGHT_UPDATE', 'INVENTORY_WEIGHT_UPDATE');
	
	addon:RegisterMsg('UPDATE_ITEM_REPAIR', 'INVENTORY_ON_MSG');
	addon:RegisterMsg('SWITCH_GENDER_SUCCEED', 'INVENTORY_ON_MSG');
    addon:RegisterMsg('RESET_ABILITY_UP', 'INVENTORY_ON_MSG');
	addon:RegisterMsg('APPRAISER_FORGERY', 'INVENTORY_ON_APPRAISER_FORGERY');

	addon:RegisterOpenOnlyMsg('REFRESH_ITEM_TOOLTIP', 'ON_REFRESH_ITEM_TOOLTIP');
	addon:RegisterMsg('TOGGLE_EQUIP_ITEM_TOOLTIP_DESC', 'ON_TOGGLE_EQUIP_ITEM_TOOLTIP_DESC');

	addon:RegisterOpenOnlyMsg('ABILITY_LIST_GET', 'MAKE_WEAPON_SWAP_BUTTON');

	SLOTSET_NAMELIST = {};
	GROUP_NAMELIST = {};
	
	SHOP_SELECT_ITEM_LIST = {};

	--검색 용 변수
	searchEnterCount = 1
	beforekeyword = "None"

	frame:SetUserValue("MONCARDLIST_OPENED", 0);
	local dropscp = frame:GetUserConfig("TREE_SLOT_DROPSCRIPT");
	frame:SetEventScript(ui.DROP, dropscp);
	INVENTORY_LIST_GET(frame);
end

function UI_TOGGLE_INVENTORY()
	if app.IsBarrackMode() == true then
		return;
	end
	ui.ToggleFrame('inventory');
end

function IS_SLOTSET_NAME(name)

	for i = 1 , #SLOTSET_NAMELIST do
		if SLOTSET_NAMELIST[i] == name then
			return 1
		end
	end

	return 0
end

function HIDE_EMPTY_SLOT(slotset)
	if slotset == nil then
		return;
	end
	local slotCount = slotset:GetSlotCount();
	for i = 0, slotCount - 1 do
		local slot		= slotset:GetSlotByIndex(i );
		local icon = slot:GetIcon()
		if icon == nil then
			slot:ShowWindow(0)
		end
	end	
end

function UPDATE_INVENTORY_SLOT(slot, invItem, itemCls)

		INIT_INVEN_SLOT(slot)						

		--거래목록 또는 상점 판매목록에서 올려놓은 아이템(슬롯) 표시 기능
		local remainInvItemCount = GET_REMAIN_INVITEM_COUNT(invItem);
		if remainInvItemCount ~= invItem.count then
			slot:Select(1)
		else
			slot:Select(0)
		end		
end

function INSERT_ITEM_TO_TREE(frame, tree, invItem, itemCls, baseidcls)

	--그룹 없으면 만들기
	local treegroupname = baseidcls.TreeGroup

	local treegroup = tree:FindByValue(treegroupname);
	if tree:IsExist(treegroup) == 0 then
		treegroup = tree:Add(baseidcls.TreeGroupCaption, baseidcls.TreeGroup);
		local treeNode = tree:GetNodeByTreeItem(treegroup);
		treeNode:SetUserValue("BASE_CAPTION", baseidcls.TreeGroupCaption);
		GROUP_NAMELIST[#GROUP_NAMELIST + 1] = treegroupname
	end

	--슬롯셋 없으면 만들기
	local slotsetname = GET_SLOTSET_NAME(invItem.invIndex)
	local slotsetnode = tree:FindByValue(treegroup, slotsetname);
	if tree:IsExist(slotsetnode) == 0 then
		MAKE_INVEN_SLOTSET_AND_TITLE(tree, treegroup, slotsetname, baseidcls);
	end
					
	slotset = GET_CHILD(tree,slotsetname,'ui::CSlotSet')	

	local slotCount = slotset:GetSlotCount();

	local slotindex = invItem.invIndex - GET_BASE_SLOT_INDEX(invItem.invIndex) - 1;

	--검색 기능
	local slot = nil;
	if cap == "" then
		slot = slotset:GetSlotByIndex(slotindex);
	else
		local cnt = GET_SLOTSET_COUNT(tree, baseidcls.ClassName);
		-- 저장된 템의 최대 인덱스에 따라 자동으로 늘어나도록. 예를들어 해당 셋이 10000부터 시작하는데 10500 이 오면 500칸은 늘려야됨
		while slotCount <= cnt  do 
			slotset:ExpandRow()
			slotCount = slotset:GetSlotCount();
		end

		slot = slotset:GetSlotByIndex(cnt);
		cnt = cnt + 1;
		slotset:SetUserValue("SLOT_ITEM_COUNT", cnt)
	end
							
	slot:ShowWindow(1)							
	UPDATE_INVENTORY_SLOT(slot, invItem, itemCls);
							
	INV_ICON_SETINFO(frame, slot, invItem, customFunc, scriptArg, remainInvItemCount);
	SET_SLOTSETTITLE_COUNT(tree, baseidcls, 1)
											
	slotset:MakeSelectionList();
end

function MAKE_INVEN_SLOTSET_AND_TITLE(tree, treegroup, slotsetname, baseidcls)
	local slotsettitle = 'ssettitle_'..baseidcls.ClassName;
	local newSlotsname = MAKE_INVEN_SLOTSET_NAME(tree, slotsettitle, baseidcls.TreeSSetTitle)
	local newSlots = MAKE_INVEN_SLOTSET(tree, slotsetname)
	tree:Add(treegroup, newSlotsname, slotsettitle);
	local slotHandle = tree:Add(treegroup, newSlots, slotsetname);
	local slotNode = tree:GetNodeByTreeItem(slotHandle);
	slotNode:SetUserValue("IS_ITEM_SLOTSET", 1);
end

function MAKE_INVEN_SLOTSET(tree, name)
	
	local frame = ui.GetFrame('inventory');
	local slotsize = frame:GetUserConfig("TREE_SLOT_SIZE");
	local colcount = frame:GetUserConfig("TREE_COL_COUNT");

	local newslotset = tree:CreateOrGetControl('slotset',name,0,0,0,0) 
	tolua.cast(newslotset, "ui::CSlotSet");
	
	newslotset:EnablePop(1)
	newslotset:EnableDrag(1)
	newslotset:EnableDrop(1)
	newslotset:SetMaxSelectionCount(999)
	newslotset:SetSlotSize(slotsize,slotsize);
	newslotset:SetColRow(colcount,1)
	newslotset:SetSpc(0,0)
	newslotset:SetSkinName('invenslot')
	newslotset:EnableSelection(0)
	newslotset:CreateSlots()
	SLOTSET_NAMELIST[#SLOTSET_NAMELIST + 1] = name
	return newslotset;
end


function MAKE_INVEN_SLOTSET_NAME(tree, name, titletext)

	local frame = ui.GetFrame('inventory');
	local width = frame:GetUserConfig("TREE_SLOTSETTEXT_WIDTH");
	local height = frame:GetUserConfig("TREE_SLOTSETTEXT_HEIGHT");
	local font = frame:GetUserConfig("TREE_SLOTSETTEXT_FONT");

	local newtext = tree:CreateOrGetControl('richtext',name,0,0,width,height) 
	tolua.cast(newtext, "ui::CRichText");

	newtext:EnableResizeByText(0);
	newtext:SetFontName(font);
	newtext:SetUseOrifaceRect(true);
	newtext:SetText(titletext..'(0)');
	newtext:SetTextAlign('left','bottom');

	return newtext;
end

function INVENTORY_MYPC_CHANGE_SHAPE(frame)
	UPDATE_SHIHOUETTE_IMAGE(frame);
end

function UPDATE_SHIHOUETTE_IMAGE(frame)

	local equipgroup = GET_CHILD(frame, 'equip', 'ui::CGroupBox')
	local shihouette = GET_CHILD(equipgroup, 'shihouette', "ui::CPicture");
	local shihouette_imgname = ui.CaptureMyFullStdImage();
	shihouette:SetImage(shihouette_imgname);
	frame:Invalidate()

	local genderFrame = ui.GetFrame('switchgender');
	if nil ~= genderFrame and genderFrame:IsVisible() == 1 then
		SWITCHGENDER_DRAW_CHANGE_STATE(genderFrame);
	end
end


function INVENTORY_OPEN(frame)

	frame:SetUserValue("MONCARDLIST_OPENED", 0);

	ui.Chat("/requpdateequip"); -- 내구도 회복 유료템 때문에 정확한 값을 지금 알아야 함.

	local invGbox			= frame:GetChild('inventoryGbox');
	
	local savedPos = frame:GetUserValue("INVENTORY_CUR_SCROLL_POS");
		
	if savedPos == 'None' then
		savedPos = '0'
	end
				
	local tree_box = GET_CHILD_RECURSIVELY(frame, 'treeGbox_Equip')
	tree_box:SetScrollPos( tonumber(savedPos) );

	session.CheckOpenInvCnt();
	ui.CloseFrame('layerscore');
	MAKE_WEAPON_SWAP_BUTTON()
	local questInfoSetFrame = ui.GetFrame('questinfoset_2');
	if questInfoSetFrame:IsVisible() == 1 then
		questInfoSetFrame:ShowWindow(0);
	end

	local minimapFrame = ui.GetFrame('minimap');
	minimapFrame:ShowWindow(0)

	INV_HAT_VISIBLE_STATE(frame)
	frame:Invalidate()
end

function INVENTORY_CLOSE()
	local frame = ui.GetFrame("inventory");
	frame:SetUserValue("MONCARDLIST_OPENED", 1);		-- 바로 다음에 있는 OPEN_MANAGED_CARDINVEN 함수에서 0으로 만들어준다.	
	CHECK_BTN_OPNE_CARDINVEN(frame:GetChild('moncardGbox'));
	EQUIP_CARDSLOT_BTN_CANCLE();

	local tree_box = GET_CHILD_RECURSIVELY(frame, 'treeGbox_Equip','ui::CGroupBox')

	local curpos = tree_box:GetScrollCurPos();
	frame:SetUserValue("INVENTORY_CUR_SCROLL_POS", curpos);

	local questInfoSetFrame = ui.GetFrame('questinfoset_2');
	questInfoSetFrame:ShowWindow(1);

	local minimapFrame = ui.GetFrame('minimap');
	minimapFrame:ShowWindow(1);

	item.RemoveTargetItem();
	ui.CloseFrame("inventory");
end

function INVENTORY_FRONT_IMAGE_CLEAR(frame)

	for j = 1 , #SLOTSET_NAMELIST do

		local group = GET_CHILD(frame, 'inventoryGbox', 'ui::CGroupBox')
		
		for typeNo = 1, #g_invenTypeStrList do
			local tree_box = GET_CHILD(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
			local tree = GET_CHILD(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')

			local slotSet = GET_CHILD(tree,SLOTSET_NAMELIST[i],'ui::CSlotSet');
			
			if slotSet ~= nil then
		local slotCount = slotSet:GetSlotCount();

		for i = 0, slotCount - 1 do
			local slot		= slotSet:GetSlotByIndex(i );
			slot:SetFrontImage("None");
		end	
	end
end
	end
end

function _SLOT_RESET_GRAY_BLINK(slot)
	if slot:GetIcon() ~= nil then
		slot:GetIcon():SetGrayStyle(0);
		slot:ReleaseBlink();
	end
end

function SET_INV_LBTN_FUNC(frame, funcName)
	frame:SetUserValue("LBTN_SCP", funcName);
end

function SET_SLOT_APPLY_FUNC(frame, funcName, slotSetName)
	frame:SetUserValue("SLOT_APPLY_FUNC", funcName);
	if funcName == "None" then
		INV_APPLY_TO_ALL_SLOT(_SLOT_RESET_GRAY_BLINK);
	end

	UPDATE_INV_LIST(frame, slotSetName);
end

function UPDATE_INV_LIST(frame, slotSetName)
	INVENTORY_LIST_GET(frame, nil, slotSetName);
end

function INVENTORY_WEIGHT_UPDATE(frame)
	local bottomgroup = GET_CHILD(frame, 'bottomGbox', 'ui::CGroupBox')
	local weightPicture = GET_CHILD(bottomgroup, 'inventory_weight','ui::CPicture')
	local pc = GetMyPCObject();
	local newwidth =  math.floor( pc.NowWeight * weightPicture:GetOriginalWidth() / pc.MaxWeight )
	local weightscptext = ScpArgMsg("Weight{All}{Max}","All", tostring(pc.NowWeight),"Max",tostring(pc.MaxWeight))
	local weightratetext = ScpArgMsg("Weight{Rate}","Rate", tostring(math.floor(pc.NowWeight*100/pc.MaxWeight)))

	if newwidth > weightPicture:GetOriginalWidth() then
		newwidth = weightPicture:GetOriginalWidth();
	end

	weightPicture:Resize(newwidth,weightPicture:GetOriginalHeight())
	
	local weightGbox = GET_CHILD(bottomgroup, 'weightGbox','ui::CGroupBox')
	weightGbox:SetTextTooltip(weightscptext)

	local arrowPicture = GET_CHILD(bottomgroup, 'inventory_arrow','ui::CPicture')
	arrowPicture:SetOffset(newwidth + weightPicture:GetX() - 7 ,arrowPicture:GetOriginalY() )

	local weighttext = GET_CHILD(bottomgroup, 'invenweight','ui::CRichText')
	weighttext:SetText(weightratetext)	
end


function INVITEM_INVINDEX_CHANGE(itemGuid)

	local frame = ui.GetFrame("inventory");
	local invSlot = INVENTORY_GET_SLOT_BY_IESID(frame, itemGuid)
	if invSlot == nil then
		return;
	end

	ONUPDATE_SLOT_INVINDEX(invSlot);

end

function ONUPDATE_SLOT_INVINDEX(slot)

	if slot:GetIcon() == nil then
		return;
	end

	local invItem = GET_SLOT_ITEM(slot);
	local iconInfo = slot:GetIcon():GetInfo();
	iconInfo.ext = invItem.invIndex;
	slot:SetEventScriptArgNumber(ui.LBUTTONDOWN, invItem.invIndex);
	slot:SetEventScriptArgNumber(ui.RBUTTONDBLCLICK, invItem.invIndex);
	slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, invItem.invIndex);

end

function TEMP_INV_ADD(frame,invIndex)
	
	local invItem = session.GetInvItem(invIndex);
	if invItem ~= nil then
		local obj = GetIES(invItem:GetObject());
		local name = obj.ClassName;
		if name == "Vis" or name == "Feso" then
			DRAW_TOTAL_VIS(frame, 'invenZeny');
			return;
		end
	end	

	local baseidcls = GET_BASEID_CLS_BY_INVINDEX(invIndex)
	local invItem = session.GetInvItem(invIndex);	
	local itemCls = GetClassByType("Item", invItem.type);

	local beforeSlotSetCount = #SLOTSET_NAMELIST;
	local beforeGroupCount = #GROUP_NAMELIST;

	local typeStr = "Item"	
	if itemCls.ItemType == "Equip" then
		typeStr = itemCls.ItemType; 
	end
	local tree = GET_CHILD_RECURSIVELY(frame, 'inventree_' .. typeStr);
	INSERT_ITEM_TO_TREE(frame, tree, invItem, itemCls, baseidcls);
		
	--아이템 없는 빈 슬롯은 숨겨라
	for i = 1 , #SLOTSET_NAMELIST do
		local slotset = GET_CHILD(tree,SLOTSET_NAMELIST[i],'ui::CSlotSet')	
		HIDE_EMPTY_SLOT(slotset)
	end
	
	ADD_GROUP_BOTTOM_MARGIN(frame,tree)

	local treegroupname = baseidcls.TreeGroup;
	local treegroup = tree:FindByValue(treegroupname);

	if beforeSlotSetCount ~= #SLOTSET_NAMELIST then
		tree:SortTreeChildByFunc(treegroup, "GET_SLOTSET_SORT_SCORE");
	end

	if beforeGroupCount ~= #GROUP_NAMELIST then
		tree:SortTreeChildByFunc(tree:GetRootItem(), "GET_GROUP_SORT_SCORE");
	end

	local treeNode = tree:GetNodeByTreeItem(treegroup);
	tree:OpenNode(treeNode, true, true);
	tree:UpdateSurface();	

	--검색결과 스크롤 세팅은 여기서 하자. 트리 업데이트 후에 위치가 고정된 다음에.
	for i = 1 , #SLOTSET_NAMELIST do
		slotset = GET_CHILD(tree,SLOTSET_NAMELIST[i],'ui::CSlotSet')

		local slotsetnode = tree:FindByValue(SLOTSET_NAMELIST[i]);
		if setpos == 'setpos' then

			local savedPos = frame:GetUserValue("INVENTORY_CUR_SCROLL_POS");
		
			if savedPos == 'None' then
				savedPos = 0
			end
				
			local tree_box = GET_CHILD_RECURSIVELY(frame, 'treeGbox_'.. typeStr)
			tree_box:SetScrollPos( tonumber(savedPos) )
		end
		
	end

	frame:Invalidate()
end

function GET_GROUP_SORT_SCORE(value)
	local baseCls = GetClassByStrProp("inven_baseid", "TreeGroup", value);
	return (100 - baseCls.ClassID) * 100;
end

function GET_SLOTSET_SORT_SCORE(value)

	if string.find(value, "margin") ~= nil then
		return -1;
	end

	local baseClassName;
	local baseScore = 0;
	if string.find(value, "ssettitle_") ~= nil then
		baseScore = 10;
		local stringLen = string.len("ssettitle_");
		baseClassName = string.sub(value, stringLen + 1, string.len(value));
	elseif string.find(value, "sset_") ~= nil then
		baseScore = 0;
		local stringLen = string.len("sset_");
		baseClassName = string.sub(value, stringLen + 1, string.len(value));
	else
		IMC_LOG("INFO_NORMAL", "Inven sort fail " .. value);
		return 1;
	end

	local baseCls = GetClass("inven_baseid", baseClassName);
	if baseCls == nil then
		IMC_LOG("INFO_NORMAL", "Baseclass does not exist" .. baseClassName);
		return 1;
	end

	return baseScore + (100 - baseCls.ClassID) * 100;

end

function TEMP_INV_REMOVE(frame, itemGuid)

	local invItem = session.GetInvItemByGuid(itemGuid);
	if invItem == nil then
		return;
	end

	local itemCls = GetClassByType("Item", invItem.type);
	local name = itemCls.ClassName;
	if name == "Vis" or name == "Feso" then
		DRAW_TOTAL_VIS(frame, 'invenZeny', 1);
		return;
	end

	local invIndex = invItem.invIndex;
	local baseidcls = GET_BASEID_CLS_BY_INVINDEX(invIndex)

	local treegroupname = baseidcls.TreeGroup;

	local typeStr = "Item"	
	if itemCls.ItemType == "Equip" then
		typeStr = itemCls.ItemType; 
	end	
	local tree = GET_CHILD_RECURSIVELY(frame, 'inventree_'..typeStr)
	local treegroup = tree:FindByValue(treegroupname);
	if tree:IsExist(treegroup) == 0 then
		return;
	end

	local treeNode = tree:GetNodeByTreeItem(treegroup);
	local slotsetname = GET_SLOTSET_NAME(invItem.invIndex)
	local slotsetnode = tree:FindByValue(treegroup, slotsetname);
	local slotset = GET_CHILD(tree,slotsetname,'ui::CSlotSet')	

	local slot = GET_SLOT_FROMSLOTSET_BY_IESID(slotset, itemGuid);
	if slot == nil then
		return;
	end
	slot:SetText('{s18}{ol}{b}', 'count', 'right', 'bottom', -2, 1);
	local slotIndex = slot:GetSlotIndex();
	slotset:ClearSlotAndPullNextSlots(slotIndex, "ONUPDATE_SLOT_INVINDEX");
	
	local cnt = GET_SLOTSET_COUNT(tree, baseidcls.ClassName);
	cnt = cnt - 1;
	slotset:SetUserValue("SLOT_ITEM_COUNT", cnt)

	-- 아이템 없는 빈 슬롯은 숨겨라
	for i = 1 , #SLOTSET_NAMELIST do
		local slotset = GET_CHILD(tree,SLOTSET_NAMELIST[i],'ui::CSlotSet')	
		if slotset ~= nil then
			HIDE_EMPTY_SLOT(slotset)
		end
	end

	SET_SLOTSETTITLE_COUNT(tree, baseidcls, -1);	

	if cnt == 0 then
		local titleName = "ssettitle_" .. baseidcls.ClassName;
		local hTitle = tree:FindByValue(titleName);

		REMOVE_FROM_SLOTSET(slotsetname);

		tree:Delete(hTitle);
		tree:Delete(slotsetnode);

		if treeNode:GetChildNodeCount() == 1 then
			tree:Delete(treegroup);

			REMOVE_FROM_TREEGROUP(treegroupname);
			
		end
	end
		
end

function REMOVE_FROM_SLOTSET(slotsetname)

	local tempSlotSet = {};
	for i = 1 , #SLOTSET_NAMELIST do
		if SLOTSET_NAMELIST[i] ~= slotsetname then
			tempSlotSet[#tempSlotSet + 1] = SLOTSET_NAMELIST[i];
		end
	end
	SLOTSET_NAMELIST = tempSlotSet;

end

function REMOVE_FROM_TREEGROUP(treegroupname)

	local tempSlotSet = {};
	for i = 1 , #GROUP_NAMELIST do
		if GROUP_NAMELIST[i] ~= treegroupname then
			tempSlotSet[#tempSlotSet + 1] = GROUP_NAMELIST[i];
		end
	end
	GROUP_NAMELIST = tempSlotSet;

end

function GET_SLOT_FROMSLOTSET_BY_IESID(slotset, itemGuid)

	local count = slotset:GetChildCount();
	for i = 0 , count - 1 do
		local slot = slotset:GetChildByIndex(i);
		AUTO_CAST(slot);
		local tooltipIESID = slot:GetIcon():GetInfo():GetIESID();
		if tooltipIESID == itemGuid then
			return slot;
		end
	end

	return nil;

end

function INVENTORY_ON_MSG(frame, msg, argStr, argNum)
    if msg == 'INV_ITEM_LIST_GET' or msg == 'UPDATE_ITEM_REPAIR' or msg == 'RESET_ABILITY_UP' then
        INVENTORY_LIST_GET(frame)
		STATUS_EQUIP_SLOT_SET(frame);
    end
	
    if msg == 'INV_ITEM_ADD' then
        TEMP_INV_ADD(frame, argNum)
    end
	if  msg == 'EQUIP_ITEM_LIST_GET' then		
		STATUS_EQUIP_SLOT_SET_ANIM(frame);
		STATUS_EQUIP_SLOT_SET(frame);
	end

    if msg == 'GAME_START' then
		UPDATE_SHIHOUETTE_IMAGE(frame);
        -- INVENTORY_LIST_GET(frame)
		STATUS_EQUIP_SLOT_SET(frame);
		DRAW_MEDAL_COUNT(frame)
		INVENTORY_WEIGHT_UPDATE(frame);
    end

	if msg == 'INV_ITEM_CHANGE_COUNT' then
		INVENTORY_UPDATE_ITEM_BY_GUID(frame, argStr);
	end

	if msg == 'INV_ITEM_REMOVE' then
		TEMP_INV_REMOVE(frame, argStr);
	end

	if msg == 'ACCOUNT_UPDATE' then
		DRAW_MEDAL_COUNT(frame)
	end

	if msg == 'INV_DRAW_MONEY_TEXT' then
		DRAW_TOTAL_VIS(frame, 'invenZeny');
	end

	if msg == 'SWITCH_GENDER_SUCCEED' then
		SLOTSET_UPDATE_ICONS_BY_NAME(frame, "Outer");
	end
end

function INVENTORY_ITEM_PROP_UPDATE(frame, msg, itemGuid)
	
	local itemSlot = INV_GET_SLOT_BY_ITEMGUID(itemGuid);
	if itemSlot ~= nil then
		local invItem = GET_PC_ITEM_BY_GUID(itemGuid);
		INV_SLOT_UPDATE(frame, invItem, itemSlot); 
		frame:Invalidate();
		return;
	end
	
	itemSlot = GET_PC_EQUIP_SLOT_BY_ITEMID(itemGuid);
	if itemSlot ~= nil then
		local invItem = GET_PC_ITEM_BY_GUID(itemGuid);
		AUTO_CAST(itemSlot);
		local eqpItemList = session.GetEquipItemList();
		SET_EQUIP_SLOT_BY_SPOT(frame, invItem, eqpItemList, _INV_EQUIP_LIST_SET_ICON);
		frame:Invalidate();
		return;
	end
end

function INV_SLOT_UPDATE(frame, invItem, itemSlot)
	local customFunc = nil;
	local scriptName = frame:GetUserValue("CUSTOM_ICON_SCP");
	local scriptArg = nil;
	if scriptName ~= nil then
		customFunc = _G[scriptName];
		local getArgFunc = _G[frame:GetUserValue("CUSTOM_ICON_ARG_SCP")];
		if getArgFunc ~= nil then
			scriptArg = getArgFunc();
		end
	end

	local remainInvItemCount = GET_REMAIN_INVITEM_COUNT(invItem);
	INV_ICON_SETINFO(frame, itemSlot, invItem, customFunc, scriptArg, remainInvItemCount);	
end

function INVENTORY_UPDATE_ITEM_BY_GUID(frame, itemGuid)

	local invItem = session.GetInvItemByGuid(itemGuid);
	if invItem == nil then
		return;
	end
	
	local obj = GetIES(invItem:GetObject());
	local name = obj.ClassName;
	if name == "Vis" or name == "Feso" then
		DRAW_TOTAL_VIS(frame, 'invenZeny');
		return;
	end

	local itemSlot = INV_GET_SLOT_BY_ITEMGUID(itemGuid, frame)
	if itemSlot ~= nil then
		INV_SLOT_UPDATE(frame, invItem, itemSlot);
	end
	
	
end

----- 아이템 조합 컨텐츠 (inventory_mix.lua에서 복사해옴)
function SET_INVENTORY_MODE(frame, modeName)
	
	local curMode = frame:GetUserValue("Mode");
	if curMode == modeName then
		return;
	end

	frame:SetUserValue("Mode", modeName);
	local parent = frame:GetChild("inventoryGbox");

	if modeName == "Mixing" then
		SHOW_CHILD(parent, "throwawayslottext", 0);
		SHOW_CHILD(parent, "throwawayslotlist", 0);
		SHOW_CHILD(parent, "invthrow", 0);
		SHOW_CHILD_BYNAME(parent, "mix_", 1);
		ui.EnableSlotMultiSelect(1);

		INV_MIX_HELPTEXT(frame);
		MIX_UPDATE_TOTAL_MATERIAL_EXP(frame);
	else
		SHOW_CHILD(parent, "throwawayslottext", 1);
		SHOW_CHILD(parent, "throwawayslotlist", 1);
		SHOW_CHILD(parent, "invthrow", 1);
		SHOW_CHILD_BYNAME(parent, "mix_", 0);
		ui.EnableSlotMultiSelect(0);
	end
end

function INVENTORY_GET_SLOT_BY_IESID(frame, itemGuid)

	local invItem = session.GetInvItemByGuid(itemGuid);
	if invItem == nil then
		return nil;
	end

	return INVENTORY_GET_SLOT_BY_INVITEM(frame, invItem);

end

function INVENTORY_GET_SLOT_BY_INVITEM(frame, changeTargetItem)

	local group = GET_CHILD(frame, 'inventoryGbox', 'ui::CGroupBox')
	
	for typeNo = 1, #g_invenTypeStrList do
		local tree_box = GET_CHILD(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
		local tree = GET_CHILD(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')

	for i = 1 , #SLOTSET_NAMELIST do
		local slotSet = GET_CHILD(tree,SLOTSET_NAMELIST[i],'ui::CSlotSet')	
		if slotSet ~= nil then
			for j = 0 , slotSet:GetChildCount() - 1 do
				local slot = slotSet:GetChildByIndex(j);
				local invItem = GET_SLOT_ITEM(slot); 
				if invItem == changeTargetItem then
					return slot;
				end
			end
		end
	end
	end

	return nil;

end

function INVENTORY_UPDATE_ICON_BY_INVITEM(frame, changeTargetItem)

	local slot = INVENTORY_GET_SLOT_BY_INVITEM(frame, changeTargetItem);
	if slot ~= nil then
		local itemCls = GetIES(changeTargetItem:GetObject());
		UPDATE_INVENTORY_SLOT(slot, changeTargetItem, itemCls)
	end

end

function SLOTSET_UPDATE_ICONS_BY_NAME(frame, slotSetName)
	local group = GET_CHILD(frame, 'inventoryGbox', 'ui::CGroupBox')

	
	for typeNo = 1, #g_invenTypeStrList do
		local tree_box = GET_CHILD(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
		local tree = GET_CHILD(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')

	local slotSet = nil;
	for i = 1 , #SLOTSET_NAMELIST do
		if string.find(SLOTSET_NAMELIST[i], slotSetName) ~= nil then
				slotSet = GET_CHILD(tree , SLOTSET_NAMELIST[i],'ui::CSlotSet')	
			break;
		end
	end
	end
	
	if slotSet ~= nil then
		SLOTSET_UPDATE_ICONS_BY_SLOTSET(frame, slotSet)
	end
end

function SLOTSET_UPDATE_ICONS_BY_SLOTSET(frame, slotSet)
	if slotSet == nil then
		return;
	end

	for j = 0 , slotSet:GetChildCount() - 1 do
		local slot = slotSet:GetChildByIndex(j);
		local invItem = GET_SLOT_ITEM(slot); 
		if invItem ~= nil then
			local itemCls = GetIES(invItem:GetObject());
			UPDATE_INVENTORY_SLOT(slot, invItem, itemCls)
			INV_SLOT_UPDATE(frame, invItem, slot); 
		end
	end
end

function INVENTORY_UPDATE_ICONS(frame)
	local group = GET_CHILD(frame, 'inventoryGbox', 'ui::CGroupBox')
	
	for typeNo = 1, #g_invenTypeStrList do
		local tree_box = GET_CHILD(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
		local tree = GET_CHILD(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')

	for i = 1 , #SLOTSET_NAMELIST do
			local slotSet = GET_CHILD(tree, SLOTSET_NAMELIST[i],'ui::CSlotSet')	
		SLOTSET_UPDATE_ICONS_BY_SLOTSET(frame, slotSet)
	end
end
end

--특정 경우에서 모든 아이템 리스트를 돌 필요는 없기 떄문에
--특정 슬롯셋의 리스트만 가져올 때, slotSetName 값을 넣는다.
function INVENTORY_LIST_GET(frame, setpos, slotSetName)
	SET_INVENTORY_MODE(frame, "Normal");
	
	--이미 인벤토리의 리스트는 만들어져 있는데, slotSetName 이부분 갱신해주고 싶어서
	--모든 리스트를 다 불러올 필요는 없다.

	if slotSetName == nil then
		INVENTORY_TOTAL_LIST_GET(frame, setpos);
	end
	
	DRAW_TOTAL_VIS(frame, 'invenZeny');

	local funcStr = frame:GetUserValue("SLOT_APPLY_FUNC");
	if funcStr ~= "None" then
		for i = 1 , #SLOTSET_NAMELIST do

			local group = GET_CHILD(frame, 'inventoryGbox', 'ui::CGroupBox')
			for typeNo = 1, #g_invenTypeStrList do
				local tree_box = GET_CHILD(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
				local tree = GET_CHILD(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')
				local slotSet = GET_CHILD(tree,SLOTSET_NAMELIST[i],'ui::CSlotSet');			
				if slotSet ~= nil then
			if slotSetName ~= nil then
				if string.find(slotSet:GetName(), slotSetName) then
					local func = _G[funcStr];
					APPLY_TO_ALL_ITEM_SLOT(slotSet, func);
				end
			else
				local func = _G[funcStr];
				APPLY_TO_ALL_ITEM_SLOT(slotSet, func);
			end
		end
	end
		end
	end

end

function INVENTORY_SLOTSET_INIT(frame, slotSet, slotCount)	

	for i = 0, slotCount-1 do
		
		local slot		= slotSet:GetSlotByIndex(i);
		INIT_INVEN_SLOT(slot)
		slot:SetText('', 'count', 'right', 'bottom', -2, 1);
		slot:SetOverSound('button_cursor_over_3');
		slot:ClearIcon()
		
	end
end

-- 거래슬롯에 올려두었으면 인벤토리에 카운트 차이만큼만 표시되도록 체크 
function CHECK_EXCHANGE_ITEM_LIST(invItem, remaincount)

	local itemCount = exchange.GetExchangeItemCount(0);	
	
	for  i = 0, itemCount-1 do 		
		local itemData = exchange.GetExchangeItemInfo(0,i);
		if itemData ~= nil then

			if tostring(itemData:GetGUID() ) == tostring(invItem:GetIESID()) then
				return remaincount - itemData.count;
			end
		end
	end
	return remaincount;
end

function GET_SLOTSET_NAME(invIndex)

	local clslist, cnt  = GetClassList("inven_baseid");

	for i = 0 , cnt - 1 do

		local cls = GetClassByIndexFromList(clslist, i);

		if i ~= cnt - 1 then
			
			local nextcls = GetClassByIndexFromList(clslist, i+1);

			if cls.BaseID <= invIndex and invIndex < nextcls.BaseID then
				return 'sset_'..cls.ClassName
			end

		else
			
			if cls.BaseID <= invIndex then
				return 'sset_'..cls.ClassName
			end
		end
	end

	print('error')
	return 'error'

end

function GET_BASEID_CLS_BY_INVINDEX(invIndex)

	local clslist, cnt  = GetClassList("inven_baseid");

	for i = 0 , cnt - 1 do

		local cls = GetClassByIndexFromList(clslist, i);

		if i ~= cnt - 1 then
			
			local nextcls = GetClassByIndexFromList(clslist, i+1);

			if cls.BaseID <= invIndex and invIndex < nextcls.BaseID then
				return cls
			end

		else
			
			if cls.BaseID <= invIndex then
				return cls
			end
		end
	end

	print('error')
	return 'error'

end

function GET_INVTREE_GROUP_NAME(invIndex)

	local clslist, cnt  = GetClassList("inven_baseid");

	for i = 0 , cnt - 1 do

		local cls = GetClassByIndexFromList(clslist, i);

		if i ~= cnt - 1 then
			
			local nextcls = GetClassByIndexFromList(clslist, i+1);

			if cls.BaseID <= invIndex and invIndex < nextcls.BaseID then
				return cls.TreeGroup
			end

		else
			
			if cls.BaseID <= invIndex then
				return cls.TreeGroup
			end
		end
	end

	print('error')
	return 'error'

end

function GET_SLOTSET_COUNT(tree, baseIDClsName)
	local titlestr = "ssettitle_" .. baseIDClsName;
	local textcls = GET_CHILD(tree, titlestr, 'ui::CRichText');
	local curCount = textcls:GetUserIValue("TOTAL_COUNT");

	return curCount;
end

function SET_SLOTSETTITLE_COUNT(tree, basdidcls, addCount)

	local clslist, cnt  = GetClassList("inven_baseid");
	local titlestr = "ssettitle_" .. basdidcls.ClassName;

	local textcls = GET_CHILD(tree, titlestr, 'ui::CRichText');
	local curCount = textcls:GetUserIValue("TOTAL_COUNT");
	curCount = curCount + addCount;
	textcls:SetUserValue("TOTAL_COUNT", curCount);
	textcls:SetText(basdidcls.TreeSSetTitle..' (' .. curCount .. ')' )
	
	local hGroup = tree:FindByValue(basdidcls.TreeGroup);
	if hGroup ~= nil then
		local treeNode = tree:GetNodeByTreeItem(hGroup);

		--[[
		-- 아래꺼 버그있으면 이거로 대체하자
		local totalItemCount = 0;
		for j = 0 , treeNode:GetChildNodeCount() - 1 do
			local childNode = treeNode:GetChildNodeByIndex(j);
			if childNode:GetUserIValue("IS_ITEM_SLOTSET") == 1 then
				local ctrlSet = childNode:GetObject();
				totalItemCount = totalItemCount + ctrlSet:GetChildCount();
			end
			-- INVEN_SLOTSET
		end
		]]		

		local newCaption = treeNode:GetUserValue("BASE_CAPTION");
		local totalCount = treeNode:GetUserIValue("TOTAL_ITEM_COUNT");
		totalCount = totalCount + addCount;		
		treeNode:SetUserValue("TOTAL_ITEM_COUNT", totalCount);

		tree:SetItemCaption(hGroup,newCaption..' ('..totalCount..')')

	end
	
		

end

function ADD_GROUP_BOTTOM_MARGIN(frame, tree)

	local bottommargin = frame:GetUserConfig("TREE_GROUP_BOTTOM_MARGIN");

	for i = 1, #GROUP_NAMELIST do

		local treegroup = tree:FindByValue(GROUP_NAMELIST[i]);
		if tree:IsExist(treegroup) == 1 then

				local margin = tree:CreateOrGetControl('richtext','margin'..GROUP_NAMELIST[i],0,0,400,bottommargin)
				tolua.cast(margin, "ui::CRichText");
				margin:EnableResizeByText(0);
				margin:SetFontName('white_22_ol');
				margin:SetText('');	
				margin:SetTextAlign('left','bottom');
				tree:Add(treegroup, margin, 'margin'..GROUP_NAMELIST[i]);
		
		end

	end

end

function GET_BASE_SLOT_INDEX(invIndex)

	return math.floor(invIndex / (item.GetMaxInvSlotCount() + 1))* (item.GetMaxInvSlotCount() + 1);

end


function INIT_INVEN_SLOT(slot)

	local frame = ui.GetFrame('inventory');
	local picksound = frame:GetUserConfig("TREE_SLOT_PICKSOUND");
	local dropsound = frame:GetUserConfig("TREE_SLOT_DROPSOUND");
	local dropscp = frame:GetUserConfig("TREE_SLOT_DROPSCRIPT");
	local popscp = frame:GetUserConfig("TREE_SLOT_POPSCRIPT");

	local shopframe     = ui.GetFrame("shop");
	local exchangeframe     = ui.GetFrame("exchange");
	local companionshop = ui.GetFrame('companionshop');

	if shopframe:IsVisible() == 1 or exchangeframe:IsVisible() == 1 or companionshop:IsVisible() == 1 then
		slot:SetSelectedImage('socket_slot_check')  -- 거래시에만 체크 셀렉 아이콘 사용
	else
		--slot:SetSelectedImage('socket_slot_check') -- 지금은 기본 스킨 사용
	end
	
	slot:EnableHideInDrag(true)
	slot:SetPickSound(picksound)
	slot:SetDropSound(dropsound)
	slot:SetEventScript(ui.DROP, dropscp);
	slot:SetEventScript(ui.POP, popscp);

end

function SEARCH_ITEM_INVENTORY_KEY()
	local frame = ui.GetFrame('inventory')
	frame:CancelReserveScript("SEARCH_ITEM_INVENTORY");
	frame:ReserveScript("SEARCH_ITEM_INVENTORY", 0.3, 1);
end

function REMOVE_ITEM_INVENTORY()
    local list = GET_EXPIRED_ITEM_LIST();
    if list ~= nil and #list > 0 then
        addon.BroadMsg("EXPIREDITEM_REMOVE_OPEN", "", 0);
    else
        ui.SysMsg(ScpArgMsg("NoTimeExpiredItem"));
    end
end

function SEARCH_ITEM_INVENTORY(a,b,c)
	local frame = ui.GetFrame('inventory')
	local group = GET_CHILD(frame, 'inventoryGbox', 'ui::CGroupBox')
	local searchGbox = group:GetChild('searchGbox');
	local searchSkin = GET_CHILD(searchGbox, "searchSkin",'ui::CGroupBox');
	local edit = GET_CHILD(searchSkin, "ItemSearch", "ui::CEditControl")

	local nowkeyword = edit:GetText();
	
	if nowkeyword == beforekeyword then
		searchEnterCount = searchEnterCount + 1;
	else
		searchEnterCount = 1
		beforekeyword = nowkeyword
	end
	
	INVENTORY_TOTAL_LIST_GET(frame)

end

function GET_REMAIN_INVITEM_COUNT(invItem)

	local remainInvItemCount = invItem.count
	remainInvItemCount = CHECK_EXCHANGE_ITEM_LIST(invItem, remainInvItemCount);	 
	for iesid, selllistcount in pairs(SHOP_SELECT_ITEM_LIST) do
		local item = GetObjectByGuid(iesid);
			if item.ClassID == invItem.type then
				remainInvItemCount = remainInvItemCount - selllistcount
			end
	end
	return remainInvItemCount;
end

function INVENTORY_TOTAL_LIST_GET(frame, setpos, isIgnorelifticon)

	local liftIcon 				= ui.GetLiftIcon();
	if nil == isIgnorelifticon then
		isIgnorelifticon = "NO";
	end
	
	if isIgnorelifticon ~= "NO" and liftIcon ~= nil then
		return
	end

	local blinkcolor = frame:GetUserConfig("TREE_SEARCH_BLINK_COLOR");

	local group = GET_CHILD(frame, 'inventoryGbox', 'ui::CGroupBox')
	for typeNo = 1, #g_invenTypeStrList do
		local tree_box = GET_CHILD(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
		local tree = GET_CHILD(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')

	local groupfontname = frame:GetUserConfig("TREE_GROUP_FONT");
	local tabwidth = frame:GetUserConfig("TREE_TAB_WIDTH");

	tree:Clear();
	tree:EnableDrawFrame(false)
	tree:SetFitToChild(true,60)
	tree:SetFontName(groupfontname);
	tree:SetTabWidth(tabwidth);

	for i = 1 , #SLOTSET_NAMELIST do
		SLOTSET_NAMELIST[i] = nil
	end

	for i = 1 , #GROUP_NAMELIST do
		GROUP_NAMELIST[i] = nil
	end

	local customFunc = nil;
	local scriptName = frame:GetUserValue("CUSTOM_ICON_SCP");
	local scriptArg = nil;
	if scriptName ~= nil then
		customFunc = _G[scriptName];
		local getArgFunc = _G[frame:GetUserValue("CUSTOM_ICON_ARG_SCP")];
		if getArgFunc ~= nil then
			scriptArg = getArgFunc();
		end
	end
	end

	local baseidclslist, baseidcnt  = GetClassList("inven_baseid");
	session.BuildInvItemSortedList();
	local sortedList = session.GetInvItemSortedList();

				
	local searchGbox = group:GetChild('searchGbox');
	local searchSkin = GET_CHILD(searchGbox, "searchSkin",'ui::CGroupBox');
	local edit = GET_CHILD(searchSkin, "ItemSearch", "ui::CEditControl");
	local cap = edit:GetText();
	if cap ~= "" then
		for i = 1 , #SLOTSET_NAMELIST do
			local slotset = GET_CHILD(tree,SLOTSET_NAMELIST[i],'ui::CSlotSet')	
			slotset:RemoveAllChild();
			slotset:SetUserValue("SLOT_ITEM_COUNT", 0);
		end
	end

	for h= 0 , baseidcnt - 1 do
		local outerbaseidcls = GetClassByIndexFromList(baseidclslist, h);
		local invItemCount = sortedList:size();
		for j = 0 , invItemCount - 1 do
			local invItem			= sortedList:at(j);
			if invItem ~= nil then
					local itemCls = GetIES(invItem:GetObject());	
				local typeStr = "Item"	
				if itemCls.ItemType == "Equip" then
					typeStr = itemCls.ItemType; 
				end

				if itemCls ~= nil then
					local makeSlot = true;
					if cap ~= "" then
						local itemname = string.lower(dictionary.ReplaceDicIDInCompStr(itemCls.Name));		
						local tempcap = string.lower(cap);
						
						local a = string.find(itemname, cap);
						if a == nil then
							makeSlot = false;
						end

					end				

					if makeSlot == true then
						local baseidcls = GET_BASEID_CLS_BY_INVINDEX(invItem.invIndex)
				
						if invItem.count > 0 and baseidcls.ClassName ~= 'Unused' then -- Unused로 설정된 것은 안보임
							if outerbaseidcls.ClassName == baseidcls.ClassName then
								local tree_box = GET_CHILD(group, 'treeGbox_'.. typeStr,'ui::CGroupBox')
								local tree = GET_CHILD(tree_box, 'inventree_'.. typeStr,'ui::CTreeControl')
								INSERT_ITEM_TO_TREE(frame, tree, invItem, itemCls, baseidcls);
							end
						end
					else
						if customFunc ~= nil then
							local slot 			    = slotSet:GetSlotByIndex(i);
							if slot ~= nil then
								customFunc(slot, scriptArg, invItem, nil);
							end
						end
					end
			end
		end
	end
	end

	for typeNo = 1, #g_invenTypeStrList do
		local tree_box = GET_CHILD(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
		local tree = GET_CHILD(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')
	--아이템 없는 빈 슬롯은 숨겨라
	for i = 1 , #SLOTSET_NAMELIST do
			slotset = GET_CHILD(tree,SLOTSET_NAMELIST[i],'ui::CSlotSet');
			if slotset ~= nil then
				HIDE_EMPTY_SLOT(slotset);
			end			
	end

	ADD_GROUP_BOTTOM_MARGIN(frame,tree)

	tree:OpenNodeAll();
	tree:UpdateSurface();	

	--검색결과 스크롤 세팅은 여기서 하자. 트리 업데이트 후에 위치가 고정된 다음에.
	for i = 1 , #SLOTSET_NAMELIST do
		slotset = GET_CHILD(tree,SLOTSET_NAMELIST[i],'ui::CSlotSet')

		local slotsetnode = tree:FindByValue(SLOTSET_NAMELIST[i]);
		if setpos == 'setpos' then

			local savedPos = frame:GetUserValue("INVENTORY_CUR_SCROLL_POS");
		
			if savedPos == 'None' then
				savedPos = 0
			end
				
			tree_box:SetScrollPos( tonumber(savedPos) )
		end
		end		
	end
end




function CHECK_INV_LBTN(frame, object, argStr, argNum)

	local frame		 = ui.GetFrame('inventory');
	local targetItem = item.HaveTargetItem();

	local curLBtn = frame:GetUserValue("LBTN_SCP");
	if curLBtn ~= "None" then
		local invitem = session.GetInvItem(argNum);
		if invitem ~= nil then
			local func = _G[curLBtn];
			func(frame, invitem, object);
			ui.CancelLiftIcon();
			return;
		end
	end
	
	local curMode = frame:GetUserValue("Mode");
	if curMode == "Mixing" then
		local mixItem = GET_MIX_TARGET_ITEM(frame);
		if mixItem ~= nil then
			ui.CancelLiftIcon();
		end

		MIX_LBTN(frame, object);
		return;
	end
	
	if targetItem == 1 then
		local luminItemIndex = item.GetTargetItem();

		local luminItem = session.GetInvItem(luminItemIndex);
		if luminItem ~= nil then
			local itemobj = GetIES(luminItem:GetObject());
			
			if itemobj.GroupName == 'Gem' then
				if itemobj.Usable == 'ITEMTARGET' then
					local fromItem = session.GetInvItem(argNum);
					SCR_GEM_ITEM_SELECT(argNum, luminItem, 'inventory');
					return;
				end
			end
		end
	end
	local warpFrame = ui.GetFrame('cardbattle');
	if warpFrame:IsVisible() == 1 then
		local carditem = session.GetInvItem(argNum)
		local card = GetIES(carditem:GetObject())
		if card.GroupName == 'Card' then
			imcSound.PlaySoundEvent("sys_card_battle_icon_drag");
		end
	end
	

	--[[ 아이템 나누기 기능. 지금은 작동하지 않는다.
	if keyboard.IsPressed(KEY_SHIFT) == 1 then
		local invitem = session.GetInvItem(argNum);
		if invitem ~= nil and invitem.count > 1 then
			SHOW_ITEMDIVISION_FRAME(invitem, object:GetGlobalX(), object:GetGlobalY());
		end
		return;
	end]]
	
	if keyboard.IsPressed(KEY_CTRL) == 1 then
		local invitem = session.GetInvItem(argNum);
		LINK_ITEM_TEXT(invitem);
		return;
	end
	
	local havetg = item.HaveTargetItem();
	if havetg == 0 then
		return;
	end
	
	item.UseTargetItem(argNum);

end

function SLOT_ITEMUSE_BY_TYPE(frame, object, argStr, type)

	local item = session.GetInvItemByType(type);
	local cls = GetClassByType("Item", type);
	tolua.cast(object, "ui::CSlot");
	object:GetIcon():SetTooltipIESID(item:GetIESID());
	INVENTORY_RBDC_ITEMUSE(frame, object, cls.Icon, item.invIndex);

end

function TRY_TO_USE_WARP_ITEM(invitem, itemobj)
	local pc = GetMyPCObject();
	if pc == nil or IsPVPServer(pc) == 1 then
		local isEnableUseInPVPMap = TryGetProp(itemobj, "PVPMap");
		if isEnableUseInPVPMap ~= "YES" then
			ui.SysMsg(ScpArgMsg("CannotUseThieInThisMap"));
			return 0;
		end
	end
	
	if IsBuffApplied(pc, 'Event_Penalty') == 'YES' and (itemobj.ClassID == 640022 or itemobj.ClassID == 640022 or itemobj.ClassID == 640079 or itemobj.ClassID == 490006 or itemobj.ClassID == 490110)then
		ui.SysMsg(ScpArgMsg("CannotUseThieInThisMap"));
		return 0;
	end
	
	-- 워프 주문서 예외처리. 실제 워프가 이루어질때 아이템이 소비되도록.
	local warpscrolllistcls = GetClass("warpscrolllist", itemobj.ClassName);
	if warpscrolllistcls ~= nil then
		if itemobj.LifeTime > 0 and itemobj.ItemLifeTimeOver > 0 then
			ui.SysMsg(ScpArgMsg("LessThanItemLifeTime"));
			return 1;
		end
		
		if true == invitem.isLockState then
			ui.SysMsg(ClMsg("MaterialItemIsLock"));
			return 1;
		end
		
		local pc = GetMyPCObject();
		local warpFrame = ui.GetFrame('worldmap');
		warpFrame:SetUserValue('SCROLL_WARP', itemobj.ClassName)
		warpFrame:ShowWindow(1);
		return 1;
	end
	
	return 0;

end

function IS_TEMP_LOCK(invFrame, invitem)
	if invFrame:GetUserValue('ITEM_GUID_IN_MORU') == invitem:GetIESID()
		or invitem:GetIESID() == invFrame:GetUserValue("ITEM_GUID_IN_AWAKEN") 
		or invitem:GetIESID() == invFrame:GetUserValue("STONE_ITEM_GUID_IN_AWAKEN") then
			return true;
	end

	return false;
end

--아이템의 사용
function INVENTORY_RBDC_ITEMUSE(frame, object, argStr, argNum)
	local invitem = GET_SLOT_ITEM(object);
    if invitem == nil then
		return;
	end
	
	if keyboard.IsPressed(KEY_CTRL) == 1 then
		local obj = GetIES(invitem:GetObject());
		IES_MAN_IESID(invitem:GetIESID());
		return;
	end
	
	local itemobj = GetIES(invitem:GetObject());
	
	local customRBtnScp = frame:GetTopParentFrame():GetUserValue("CUSTOM_RBTN_SCP");

	if customRBtnScp == "None" then
		customRBtnScp = nil;
	else
		customRBtnScp = _G[customRBtnScp];
	end

	if customRBtnScp ~= nil then
		customRBtnScp(itemobj, object);
		imcSound.PlaySoundEvent("icon_get_down");
		return;
	end
	
	local market_sell     = ui.GetFrame("market_sell");
	if market_sell:IsVisible() == 1 then
		MARKET_SELL_RBUTTON_ITEM_CLICK(market_sell, invitem);
		return;
	end

	local invFrame = ui.GetFrame("inventory");	
	invFrame:SetUserValue("INVITEM_GUID", invitem:GetIESID());


	local frame     = ui.GetFrame("shop");
	local companionshop = ui.GetFrame('companionshop');
	if companionshop:IsVisible() == 1 then
		frame = companionshop:GetChild('foodBox');
	end	
	if frame:IsVisible() == 1 then
		local groupName = itemobj.GroupName;
		if groupName == 'Money' then
			return;
		end
		
		local invFrame     	= ui.GetFrame("inventory");
		local invGbox		= invFrame:GetChild('inventoryGbox');
		if true == IS_TEMP_LOCK(invFrame, invitem) then
			return;
		end
		local Itemclass		= GetClassByType("Item", invitem.type);
		local ItemType		= Itemclass.ItemType;
		local typeStr = "Item"	
		if Itemclass.ItemType == "Equip" then
			typeStr = Itemclass.ItemType; 
		end		
		
		local tree_box 		= invGbox:GetChild('treeGbox_'.. typeStr);
		local tree		    = tree_box:GetChild('inventree_'.. typeStr);
		local slotsetname	= GET_SLOTSET_NAME(argNum)
		local slotSet		= GET_CHILD(tree,slotsetname,"ui::CSlotSet")

		local itemProp = geItemTable.GetPropByName(Itemclass.ClassName);
		if itemProp:IsEnableShopTrade() == true then
				if IS_SHOP_SELL(invitem, Itemclass.MaxStack, frame) == 1 then
					if keyboard.IsPressed(KEY_SHIFT) == 1 then
						local sellableCount = invitem.count;
						local titleText = ScpArgMsg("INPUT_CNT_D_D", "Auto_1", 1, "Auto_2", sellableCount);
						INPUT_NUMBER_BOX(invFrame, titleText, "EXEC_SHOP_SELL", 1, 1, sellableCount);
						invFrame:SetUserValue("SELL_ITEM_GUID", invitem:GetIESID());
						return;
					end
					
					-- 상점 Sell Slot으로 넘긴다.
					SHOP_SELL(invitem, 1, frame);
					return;
				end
			end

		return;
	end	

	local mixerFrame = ui.GetFrame("mixer");
	if mixerFrame:IsVisible() == 1 then

		local slotSet			= INV_GET_SLOTSET_BY_INVINDEX(argNum-1)
		local slot		        = slotSet:GetSlotByIndex(argNum-1);
		MIXER_INVEN_RBOTTUNDOWN(itemobj, argNum);
		return;
	end

	if TRY_TO_USE_WARP_ITEM(invitem, itemobj) == 1 then
		return;
	end

	local equip = IS_EQUIP(itemobj);
	if equip == true then
		ui.SetHideToolTip();
		imcSound.PlaySoundEvent('inven_equip');
		if itemobj.EqpType == 'RING' then
			EQUIP_RING(itemobj, argNum)			
		else
			ITEM_EQUIP(argNum);
		end
	else			
		if itemobj.Script == 'SCR_SUMMON_MONSTER_FROM_CARDBOOK' then
			local textmsg = string.format("[ %s ]{nl}%s", itemobj.Name, ScpArgMsg("Card_Summon_check_Use"));
			ui.MsgBox_NonNested(textmsg, itemobj.Name, "REQUEST_SUMMON_BOSS_TX", "None");
			return
		end

		if true == RUN_CLIENT_SCP(invitem) then
            return;
        end
		local groupName = itemobj.ItemType;
		if groupName == 'Consume' or groupName == 'Quest' or groupName == 'Cube' then
			if itemobj.Usable == 'ITEMTARGET' then
				local invFrame = ui.GetFrame('inventory');
				USE_ITEMTARGET_ICON(invFrame, itemobj, argNum);
			else
				local invItem	= session.GetInvItem(argNum);
				INV_ICON_USE(invItem);
			end
		elseif groupName == 'Gem' then
			if itemobj.Usable == 'ITEMTARGET' then
				local invFrame = ui.GetFrame('inventory');
				USE_ITEMTARGET_ICON(invFrame, itemobj, argNum);
			end
		end
	end

	-- 오른쪽 클릭으로 몬스터 카드를 인벤토리의 카드 장착 슬롯에 장착하게 함.
	local moncardFrame = ui.GetFrame("monstercardslot");
	
	if moncardFrame:IsVisible() == 1 and itemobj.GroupName == "Card" then
		local groupNameStr = itemobj.CardGroupName
		local moncardGbox = GET_CHILD_RECURSIVELY(moncardFrame, groupNameStr .. 'cardGbox');
		if itemobj.GroupName ~= "Card" then		
			return;
		end;
		
		local card_slotset = GET_CHILD_RECURSIVELY(moncardGbox, groupNameStr .. "card_slotset");

		if card_slotset ~= nil then
			local slotIndex = 0;
			if groupNameStr == 'ATK' then
				slotIndex = 0
			elseif groupNameStr == 'DEF' then
				slotIndex = 3
			elseif groupNameStr == 'UTIL' then
				slotIndex = 6
			elseif groupNameStr == 'STAT' then
				slotIndex = 9
			end

			for i = 0, 2 do							
				local slot = card_slotset:GetSlotByIndex(i);
				if slot == nil then
					return;
				end	
				local icon = slot:GetIcon();		
				if icon == nil then		
					CARD_SLOT_EQUIP(slot, invitem, groupNameStr);
					return;
				end;				
			end;
			ui.SysMsg(ClMsg("CantEquipMonsterCard"));
		end;
	end
end

function REQUEST_SUMMON_BOSS_TX()
	local invFrame = ui.GetFrame("inventory");
	local itemGuid = invFrame:GetUserValue("INVITEM_GUID");
	local invItem = session.GetInvItemByGuid(itemGuid)
	INV_ICON_USE(invItem)
end

--아이템의 사용
function INVENTORY_RBDOUBLE_ITEMUSE(frame, object, argStr, argNum)
	
	local invitem = GET_SLOT_ITEM(object);
    if invitem == nil then
		return;
	end

	local itemobj = GetIES(invitem:GetObject());
	local customRDBtnScp = frame:GetTopParentFrame():GetUserValue("CUSTOM_RDBTN_SCP");

	if customRDBtnScp == "None" then
		customRDBtnScp = nil;
	else
		customRDBtnScp = _G[customRDBtnScp];
	end

	if customRDBtnScp ~= nil then
		customRDBtnScp(itemobj, object);
		return;
	end
	
	local frame     = ui.GetFrame("shop");
	local companionshop = ui.GetFrame('companionshop');
	if companionshop:IsVisible() == 1 then
		frame = companionshop:GetChild('foodBox');
	end	
	if frame:IsVisible() == 0 then
		return;
	end
	local groupName = itemobj.GroupName;
	if groupName == 'Money' then
		return;
	end

	local invFrame     	= ui.GetFrame("inventory");

	if true == IS_TEMP_LOCK(invFrame, invitem) then
		return;
	end

	local Itemclass		= GetClassByType("Item", invitem.type);
	local ItemType		= Itemclass.ItemType;
	
	local typeStr = "Item"	
	if Itemclass.ItemType == "Equip" then
		typeStr = Itemclass.ItemType; 
	end

	local invGbox		= invFrame:GetChild('inventoryGbox');
	local tree_box 		= invGbox:GetChild('treeGbox_'..typeStr);
	local tree		    = tree_box:GetChild('inventree_'..typeStr);
	local slotsetname	= GET_SLOTSET_NAME(argNum)
	local slotSet		= GET_CHILD(tree,slotsetname,"ui::CSlotSet")

	local slot		    = slotSet:GetSlotByIndex(argNum-1);
	
	local itemProp = geItemTable.GetPropByName(Itemclass.ClassName);
	if itemProp:IsEnableShopTrade() == true then
		if IS_SHOP_SELL(invitem, Itemclass.MaxStack, frame) == 1 then
			-- 상점 Sell Slot으로 다 넘긴다.
			SHOP_SELL(invitem, invitem.count, frame);
			return;
		end
	end

	ui.SysMsg(ClMsg("CannoTradeToNPC"));
	return;
end

function EXEC_SHOP_SELL(frame, cnt)

	cnt = tonumber(cnt);
	local itemGuid = frame:GetUserValue("SELL_ITEM_GUID");
	local invItem = session.GetInvItemByGuid(itemGuid);
	SHOP_SELL(invItem, cnt, GET_SHOP_FRAME(), true);

end

--크론에 대한 텍스트 출력하도록 한다
function DRAW_TOTAL_VIS(frame, childname, remove)

	local Cron = GET_TOTAL_MONEY();
	if remove == 1 then
		Cron = 0;
	end
	
	local bottomGbox				= frame:GetChild('bottomGbox');
	local moneyGbox				= bottomGbox:GetChild('moneyGbox');
	local INVENTORY_CronCheck	= GET_CHILD(moneyGbox, childname, 'ui::CRichText');
    INVENTORY_CronCheck:SetText('{@st41b}'.. GetCommaedText(Cron))

end

function DRAW_MEDAL_COUNT(frame)
	local bottomGbox			= frame:GetChild('bottomGbox');
	local medalGbox				= bottomGbox:GetChild('medalGbox');
	local medalText				= GET_CHILD(medalGbox, 'medalText', 'ui::CRichText');
	local medalFreeTime			= GET_CHILD(medalGbox, 'medalFreeTime', 'ui::CRichText');
	local medalGbox_2				= bottomGbox:GetChild('medalGbox_2');
	local premiumTP			= GET_CHILD(medalGbox_2, 'premiumTP', 'ui::CRichText');
	
	local accountObj = GetMyAccountObj();
    medalText:SetTextByKey("medal", tostring(accountObj.Medal));
	premiumTP:SetTextByKey("medal", tostring(accountObj.GiftMedal + accountObj.PremiumMedal));

	if "None" ~= accountObj.Medal_Get_Date then
		local sysTime = geTime.GetServerSystemTime();
		local endTime = imcTime.GetSysTimeByStr(accountObj.Medal_Get_Date);
		local difSec = imcTime.GetDifSec(endTime, sysTime);
		medalFreeTime:SetUserValue("REMAINSEC", difSec);
		medalFreeTime:SetUserValue("STARTSEC", imcTime.GetAppTime());
		SHOW_REMAIN_NEXT_TP_GET_TIME(medalFreeTime);
		medalFreeTime:RunUpdateScript("SHOW_REMAIN_NEXT_TP_GET_TIME", 0.1);
	else
		medalFreeTime:SetUserValue("REMAINSEC", 0);
		medalFreeTime:SetUserValue("STARTSEC", 0);
		medalFreeTime:StopUpdateScript("SHOW_REMAIN_NEXT_TP_GET_TIME");
		medalFreeTime:SetTextByKey("medal", "{s16}{b}{#ff9900}MAX");
	end

	local tpText = ScpArgMsg("TPText{Premium}and{Event}","Premium", tostring(accountObj.PremiumMedal),"Event",tostring(accountObj.GiftMedal))
	medalGbox_2:SetTextTooltip(tpText)
end

function SHOW_REMAIN_NEXT_TP_GET_TIME(ctrl)
	local elapsedSec = imcTime.GetAppTime() - ctrl:GetUserIValue("STARTSEC");
	local startSec = ctrl:GetUserIValue("REMAINSEC");
	startSec = startSec - elapsedSec;
	
	if 0 >= startSec then		
		ctrl:SetTextByKey("medal", "{s16}{#ffffcc}");
		ctrl:StopUpdateScript("SHOW_REMAIN_NEXT_TP_GET_TIME");
		return;
	end
	local timeTxt = GET_TIME_TXT_NO_LANG(startSec);
	ctrl:SetTextByKey("medal", "{s16}{#ffffcc}(" .. timeTxt..")");
	return 1;
end

function DRAW_TOTAL_VIS_OTHER_FRAME(frame, childname)

	local Cron = GET_TOTAL_MONEY();
	
	local INVENTORY_CronCheck	= GET_CHILD(frame, childname, 'ui::CRichText');

    INVENTORY_CronCheck:SetText('{@st43}'.. GetCommaedText(Cron))

end

function ON_CHANGE_INVINDEX(frame, msg, fromInvIndex, toInvIndex)
	local shopFrame     = ui.GetFrame("shop");
	local companionshop = ui.GetFrame('companionshop');
	if companionshop:IsVisible() == 1 then
		shopFrame = companionshop:GetChild('foodBox');
	end	
	if shopFrame:IsVisible() == 1 then
		local groupbox  = shopFrame:GetChild('sellitemslot');
		local slotSet   = tolua.cast(groupbox, 'ui::CSlotSet');
		local slotCount = slotSet:GetSlotCount();

		for i = 0, slotCount - 1 do
			local slot = slotSet:GetSlotByIndex(i);
			if slot:GetIcon() ~= nil and slot:GetSlotIndex() == toInvIndex then
				slot:SetSlotIndex(fromInvIndex);
			end
		end
	end
end

function GET_SLOT_INDEX_BY_INVINDEX(parentSlotSet, invIndex)

	local count = parentSlotSet:GetChildCount();
	for i = 0 , count - 1 do
		local slot = parentSlotSet:GetChildByIndex(i);
		AUTO_CAST(slot);
		local invItem = GET_SLOT_ITEM(slot);
		if invItem ~= nil and invItem.invIndex == invIndex then
			return slot:GetSlotIndex();
		end
	end

	return nil;
end

function INVENTORY_ON_DROP(frame, control, argStr, argNum)


	local liftIcon 				= ui.GetLiftIcon();
	if liftIcon == nil then
		return;
	end

	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();
	
	toFrame:SetValue(1);
		
	if	FromFrame == toFrame then
		local parentSlot = liftIcon:GetParent();
		local parentSlotSet = parentSlot:GetParent();
		local frominfo			= liftIcon:GetInfo();

		local slot 				= tolua.cast(control, 'ui::CSlot');
		local toParentSlotSet = slot:GetParent();

		if IS_SLOTSET_NAME(parentSlotSet:GetName()) == 1 then
			if parentSlotSet:GetName() == toParentSlotSet:GetName() then

	
				local toicon = slot:GetIcon();

				local fromInvIndex = frominfo.ext;
				local toItem = GET_SLOT_ITEM(slot);
				local toInvIndex = toItem.invIndex;
				
				AUTO_CAST(parentSlotSet);
				local fromSlotIndex = GET_SLOT_INDEX_BY_INVINDEX(parentSlotSet, fromInvIndex);
				local toSlotIndex = GET_SLOT_INDEX_BY_INVINDEX(parentSlotSet, toInvIndex);
				
				if fromSlotIndex == toSlotIndex then
					return;
				end
				
				item.SwapSlotIndex(IT_INVENTORY, fromInvIndex, toInvIndex);
				ON_CHANGE_INVINDEX(toFrame, nil, fromInvIndex, toInvIndex);

				
				parentSlotSet:SwapSlot(fromSlotIndex, toSlotIndex, "ONUPDATE_SLOT_INVINDEX");
				QUICKSLOT_ON_CHANGE_INVINDEX(fromInvIndex, toInvIndex);
			end
		else
			if true == BEING_TRADING_STATE() then
				return;
			end

			local iconInfo = liftIcon:GetInfo();
			item.UnEquip(iconInfo.ext);
		end
		
	elseif FromFrame:GetName() == 'status' then
		if true == BEING_TRADING_STATE() then
			return;
		end
		local iconInfo = liftIcon:GetInfo();
		item.UnEquip(iconInfo.ext);
	elseif FromFrame:GetName() == "party" then
		local iconInfo = liftIcon:GetInfo();
		local iesID = liftIcon:GetTooltipIESID();
		local argList = "0";
		local strScp = string.format("pc.ReqExecuteTx_Item(\"PARTY_ITEM_GET\", \"%s\", \"%s\")", iesID, argList);
		RunStringScript(strScp);
	elseif FromFrame:GetName() == "camp_ui" or FromFrame:GetName() == "warehouse" then
		local iconInfo = liftIcon:GetInfo();
		local iesID = iconInfo:GetIESID();

		if iconInfo.count > 1 then	
			toFrame:SetUserValue("HANDLE", FromFrame:GetUserIValue("HANDLE"));
			INPUT_NUMBER_BOX(toFrame, ScpArgMsg("InputCount"), "EXEC_TAKE_ITEM_FROM_WAREHOUSE", iconInfo.count, 1, iconInfo.count, nil, iesID);
		else
			item.TakeItemFromWarehouse(IT_WAREHOUSE, iesID, iconInfo.count, FromFrame:GetUserIValue("HANDLE"));
		end
	end

	-- 전체 다 그리면 안된다. 이거 때문에 버그 생기면 하나만 업데이트 하게 처리
	-- INVENTORY_TOTAL_LIST_GET(toFrame,nil,"NO")
end

function EXEC_TAKE_ITEM_FROM_WAREHOUSE(frame, count, inputframe, fromFrame)
	inputframe:ShowWindow(0);
	local iesid = inputframe:GetUserValue("ArgString");
	item.TakeItemFromWarehouse(IT_WAREHOUSE, iesid, tonumber(count), frame:GetUserIValue("HANDLE"));
end


function INVENTORY_THROW_ITEM_AWAY(frame, control, argStr, argNum)
	
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();

	if FromFrame == toFrame then
		local invGbox 			= toFrame:GetChild('inventoryGbox');
		local itembox_tab 		= GET_CHILD(invGbox, 'itembox', "ui::CTabControl");
		local curtabIndex	    = itembox_tab:GetSelectItemIndex();
		local slotSet			= GET_CHILD(invGbox, 'throwawayslotlist', 'ui::CSlotSet');

		if curtabIndex == 0 then
			local frominfo			= liftIcon:GetInfo();
			local slot 				= tolua.cast(control, 'ui::CSlot');
			local toicon 			= slot:GetIcon();
			local fromInvIndex 		= frominfo.ext;

			local invItem		= session.GetInvItem(fromInvIndex);
			if invItem ~= nil then
				if toicon == nil then
					local icon = CreateIcon(slot);
					icon:Set(frominfo.imageName, 'THROWITEM', invItem.type, invItem.count, invItem:GetIESID(), invItem.count);

					slot:SetSlotIndex(invItem.type);
					SET_ITEM_TOOLTIP_TYPE(icon, invItem.type);

					icon:SetTooltipArg('buy', invItem.type, invItem:GetIESID());
					
					local liftSlot = liftIcon:GetParent();
					liftSlot:SetFrontImage('removed_item');

					slot:SetEventScript(ui.RBUTTONDOWN, "INVENTORY_DELETE_ITEM_CANCEL");
					slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, slot:GetSlotIndex());
					slot:SetText('{s18}{ol}{b}'..invItem.count, 'count', 'right', 'bottom', -2, 1);
					local slotSet			= INV_GET_SLOTSET_BY_INVINDEX(invItem.invIndex-1)
					local slot				= slotSet:GetSlotByIndex(invItem.invIndex - 1);
					local icon				= slot:GetIcon();
					icon:SetColorTone("FF666666");
					slot:EnableDrag(0);
					slot:EnableDrop(0);
				end
			end
		end
	end
end

--이거 쓰는건가?
function INVENTORY_THROW(frame, ctrl)
	local msg = ScpArgMsg("Auto_{s22}JeongMalLo_BeoLiSiKessSeupNiKka?");
	local StrScript = string.format("INVENTORY_DELETE()", -1);
	ui.MsgBox(msg, StrScript, "None");
	
end

function INVENTORY_DELETE_ITEM_CANCEL(frame, ctrl, argStr, argNum)
	ctrl:ClearText();
	ctrl:ClearIcon();
end

function INVENTORY_DELETE_ITEM_LIST(frame, invItem)
	local invGbox			= frame:GetChild('inventoryGbox');
	local slotSet			= GET_CHILD(invGbox, 'throwawayslotlist', 'ui::CSlotSet');
	local slotCount 		= 0;	--slotSet:GetSlotCount();	-- 휴지통 제거되었음. 슬롯 생성 안하도록 0셋팅

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		local icon = slot:GetIcon();
		if icon ~= nil then
			local iconInfo = icon:GetInfo();

			if iconInfo:GetIESID() == invItem:GetIESID() then
				return 1;
			end
		end
	end

	return 0;
end

function GET_ICON_PROP(icon)

	local iconInfo = icon:GetInfo();
	return geItemTable.GetProp(iconInfo.type);

end

function GET_SLOT_PROP(slot)

	slot = tolua.cast(slot, "ui::CSlot");
	local icon = slot:GetIcon();
	if icon == nil then
		return nil;
	end

	return GET_ICON_PROP(icon);

end

function INVENTORY_OP_POP(frame, slot, str, num)
	frame = frame:GetTopParentFrame();
	frame:SetValue(0);
	--INVENTORY_TOTAL_LIST_GET(frame);
	-- 전체 다 그리면 안된다. 이거 때문에 버그 생기면 하나만 업데이트 하게 처리

end

function INV_ICON_SETINFO(frame, slot, invItem, customFunc, scriptArg, count)	
	local icon 			 	= CreateIcon(slot);
	local class 			= GetClassByType('Item', invItem.type);
	if class == nil then		
		return;
	end

	local itemobj = GetIES(invItem:GetObject());	
	local imageName = GET_EQUIP_ITEM_IMAGE_NAME(itemobj, 'Icon')
	local itemType = invItem.type;
	ICON_SET_ITEM_COOLDOWN(icon, itemType);	

	icon:Set(imageName, 'Item', itemType, invItem.invIndex, invItem:GetIESID(), invItem.count);

	ICON_SET_INVENTORY_TOOLTIP(icon, invItem, nil, class);
	
	if class.ItemType == 'Equip' then
		local resultLifeTimeOver = IS_LIFETIME_OVER(itemobj);
		local result = CHECK_EQUIPABLE(itemType);
		if (result ~= "OK") or (resultLifeTimeOver == 1) then
			icon:SetColorTone("FFFF0000");		
		end
			
		if IS_NEED_APPRAISED_ITEM(itemobj) then
			icon:SetColorTone("FFFF0000");		
		end
	end	
	
	SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, itemobj, count);
	
	--아이템이 선택되었을 때의 스크립트를 선택한다
	slot:SetEventScript(ui.RBUTTONDOWN, 'INVENTORY_RBDC_ITEMUSE');
	slot:SetEventScriptArgString(ui.RBUTTONDOWN, imageName);
	slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, invItem.invIndex);

	--상점용 더블 클릭
	slot:SetEventScript(ui.RBUTTONDBLCLICK, 'INVENTORY_RBDOUBLE_ITEMUSE');
	slot:SetEventScriptArgString(ui.RBUTTONDBLCLICK, imageName);
	slot:SetEventScriptArgNumber(ui.RBUTTONDBLCLICK, invItem.invIndex);

	slot:SetEventScript(ui.LBUTTONDOWN, 'CHECK_INV_LBTN');
	slot:SetEventScriptArgNumber(ui.LBUTTONDOWN, invItem.invIndex);
	slot:SetEventScriptArgString(ui.LBUTTONDOWN, class.Name);

	slot:SetOverSound('button_over');

	slot:EnablePop(1)
	slot:EnableDrag(1)
	slot:EnableDrop(1)

	if customFunc ~= nil then
		customFunc(slot, scriptArg, invItem, itemobj);
	end

	if itemobj.GroupName == 'Quest' then		
		slot:SetFrontImage('quest_indi_icon');
	elseif invItem.isLockState == true then
		local controlset = slot:CreateOrGetControlSet('inv_itemlock', "itemlock", -5, slot:GetWidth() - 35);
	elseif true == IS_TEMP_LOCK(frame, invItem) then
		slot:SetFrontImage('item_Lock');
    elseif invItem.hasLifeTime == true  then
        ICON_SET_ITEM_REMAIN_LIFETIME(icon)
        slot:SetFrontImage('clock_inven');
	else
		slot:SetFrontImage('None');
	end
	
	if invItem.isNew == true  then
		slot:SetHeaderImage('new_inventory_icon');
	elseif IS_EQUIPPED_WEAPON_SWAP_SLOT(invItem) then
		slot:SetHeaderImage('equip_inven');
	else
		slot:SetHeaderImage('None');
	end
end
	
function IS_EQUIPPED_WEAPON_SWAP_SLOT(invItem)
	if invItem == nil then		
		return;
	end

	local slot1 = session.GetWeaponQuicSlot(0)
	local slot2 = session.GetWeaponQuicSlot(1)	
	local slot3 = session.GetWeaponQuicSlot(2)
	local slot4 = session.GetWeaponQuicSlot(3)

	return invItem : GetIESID() == slot1 or invItem : GetIESID() == slot2 or invItem : GetIESID() == slot3 or invItem : GetIESID() == slot4
end

function STATUS_SLOT_DROP(frame, icon, argStr, argNum)
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	local toFrame				= frame:GetTopParentFrame();
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		ITEM_EQUIP(iconInfo.ext, icon:GetName());
		STATUS_EQUIP_SLOT_SET(toFrame);
	end
end

function STATUS_DUMP_SLOT_SET(a,s,d)
	STATUS_EQUIP_SLOT_SET(ui.GetFrame('inventory'));
end

function _INV_EQUIP_LIST_SET_ICON(slot, icon, equipItem)
	local frame = slot:GetTopParentFrame();
	ICON_SET_EQUIPITEM_TOOLTIP(icon, equipItem, frame:GetName());
	if frame:GetName() ~= "compare" then
		icon:SetDumpScp('STATUS_DUMP_SLOT_SET');
		slot:SetEventScript(ui.LBUTTONDOWN, 'CHECK_EQP_LBTN');
		slot:SetEventScriptArgNumber(ui.LBUTTONDOWN, equipItem.equipSpot);

		slot:SetEventScript(ui.RBUTTONDOWN, 'STATUS_SLOT_RBTNDOWN');
		slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, equipItem.equipSpot);
		slot:Select(0);
	end

	slot:SetOverSound('button_over');

	local itemObj = GetIES(equipItem:GetObject());
	
	local refreshScp = itemObj.RefreshScp;
	if refreshScp ~= "None" then
		refreshScpfun = _G[refreshScp];
		refreshScpfun(itemObj);
	end	

	local lv = itemObj.Level;
	if lv > 1 then
		slot:SetText('{s20}{ol}{#FFFFFF}{b}'..lv, 'count', 'left', 'top', 8, 2);
	else
		slot:ClearText();
	end
end

function SET_EQUIP_SLOT_BY_SPOT(frame, equipItem, eqpItemList, iconFunc, ...)

	local spotName = item.GetEquipSpotName(equipItem.equipSpot);
	if  spotName  ==  nil  then
		return;
	end
	
	if spotName == "HELMET" then
		if equipItem.type ~= item.GetNoneItem(equipItem.equipSpot) then
			spotName = "HAIR";
		end
	end

	local child = frame:GetChild(spotName);			
	if  child  ==  nil  then
		return;
	end

	local gender = tonumber(frame:GetTopParentFrame():GetUserIValue('COMPARE_PC_GENDER'));
	local slot = tolua.cast(child, 'ui::CSlot');
	local controlset = slot:CreateOrGetControlSet('inv_itemlock', "itemlock", -5, slot:GetWidth() - 35);
	controlset:ShowWindow(0);
	
	if  equipItem.type  ~=  item.GetNoneItem(equipItem.equipSpot)  then
		local icon = CreateIcon(slot);
		local obj = GetIES(equipItem:GetObject());
		local imageName = ""

		if gender > 0 then
			imageName = GET_EQUIP_ITEM_IMAGE_NAME(obj, 'Icon', gender);
		else
			imageName = GET_EQUIP_ITEM_IMAGE_NAME(obj, 'Icon');
		end

		if IS_DUR_ZERO(obj) == true  then
			icon:SetColorTone("FF990000");
		elseif IS_DUR_UNDER_10PER(obj) == true  then
			icon:SetColorTone("FF999900");
		else
			icon:SetColorTone("FFFFFFFF");
		end
		
		
		icon:Set(imageName, 'Item', equipItem.type, equipItem.equipSpot, equipItem:GetIESID());
		iconFunc(slot, icon, equipItem, ...);

	else
		slot:ClearIcon();
		slot:SetEventScript(ui.RBUTTONDOWN, 'None');
		slot:SetOverSound('button_cursor_over_3');
		slot:SetText("");
	end
		

	-- LH아이콘은 RH에 양손무기가 장착중인지 확인후 아이콘 셋팅
	if spotName == 'LH' then		
		local checkRH = frame:GetChild('RH');
		if checkRH ~= nil then
			local slotNum = item.GetEquipSpotNum("RH");	

			local rhItem = eqpItemList:GetEquipItem(slotNum);
			local obj = GetIES(rhItem:GetObject());

			if obj.DBLHand == 'YES' then
				local icon = CreateIcon(slot);
				if IS_DUR_ZERO(obj) == true  then
					icon:SetColorTone("FF990000");
				elseif IS_DUR_UNDER_10PER(obj) == true  then
					icon:SetColorTone("FF999900");
				else
					icon:SetColorTone("FFFFFFFF");
				end


                local iconImage = GET_EQUIP_ITEM_IMAGE_NAME(obj, 'Icon');
				icon:Set(iconImage, 'Item', rhItem.type, rhItem.equipSpot, rhItem:GetIESID());
				iconFunc(slot, icon, rhItem, ...);

				if rhItem.isLockState == true then
					controlset:ShowWindow(1);
				end
			end
		end
	end
		
	if session.GetWeaponCurrentSlotLine() == 0 then
		frame:SetUserValue('CURRENT_WEAPON_INDEX', 1)
	else
		frame:SetUserValue('CURRENT_WEAPON_INDEX', 2)
	end
	
	if spotName == 'RH' then
--		print("slotline :"..session.GetWeaponCurrentSlotLine())
--		print("currentWeapon :"..frame : GetUserIValue('CURRENT_WEAPON_INDEX'))

		if frame : GetUserIValue('CURRENT_WEAPON_INDEX') == 2 then
			session.SetWeaponQuicSlot(0, equipItem : GetIESID());
			
			if equipItem ~= nil then
				frame:SetUserValue('CURRENT_WEAPON_RH', equipItem.type)
			else
				frame:SetUserValue('CURRENT_WEAPON_RH', 0)
			end
		elseif frame : GetUserIValue('CURRENT_WEAPON_INDEX') == 1 then
			session.SetWeaponQuicSlot(2, equipItem : GetIESID());
					
			if equipItem ~= nil then
				frame:SetUserValue('CURRENT_WEAPON_RH', equipItem.type)
			else
				frame:SetUserValue('CURRENT_WEAPON_RH', 0)
			end
		end
	end

	if spotName == 'LH' then
		
		if frame : GetUserIValue('CURRENT_WEAPON_INDEX') == 2 then
			session.SetWeaponQuicSlot(1, equipItem : GetIESID());
			
			if equipItem ~= nil then
				frame:SetUserValue('CURRENT_WEAPON_LH', equipItem.type)
			else
				frame:SetUserValue('CURRENT_WEAPON_LH', 0)
			end
		elseif frame : GetUserIValue('CURRENT_WEAPON_INDEX') == 1 then
			session.SetWeaponQuicSlot(3, equipItem : GetIESID());
			if equipItem ~= nil then
				frame:SetUserValue('CURRENT_WEAPON_LH', equipItem.type)
			else
				frame:SetUserValue('CURRENT_WEAPON_LH', 0)
			end
		end
	end
	

	if equipItem:GetIESID() == frame:GetUserValue('ITEM_GUID_IN_MORU') then
		slot:SetFrontImage('item_Lock');
	elseif equipItem.isLockState == true then
		controlset:ShowWindow(1);			
	else
		slot:SetFrontImage('None');
	end
end

function SET_EQUIP_SLOT(frame, i, equipItemList, iconFunc, ...)
	
	if equipItemList == nil then
		equipItemList = session.GetEquipItemList();
	end

	local equipItem = equipItemList:Element(i);
	SET_EQUIP_SLOT_BY_SPOT(frame, equipItem, equipItemList, iconFunc, ...);
	
	frame:Invalidate();
end

function SET_EQUIP_LIST_ANIM(frame, equipItemList, iconFunc, ...)

	for i = 0, equipItemList:Count() - 1 do
		local equipItem = equipItemList:Element(i);
		local spotName = item.GetEquipSpotName(equipItem.equipSpot);
		if equipItem.isChangeItem == true then

			if  spotName  ~=  nil  then
				local child = frame:GetChild(spotName.."ANIM");			
				if  child  ~=  nil  then			
					local slot = tolua.cast(child, 'ui::CAnimPicture');
					slot:PlayAnimation();
				end
			end		
		end
	end
	frame:Invalidate();
end

function SET_EQUIP_LIST(frame, equipItemList, iconFunc, ...)
	for i = 0, equipItemList:Count() - 1 do
		local equipItem = equipItemList:Element(i);
		
		local spotName = item.GetEquipSpotName(equipItem.equipSpot);
		if  spotName  ~=  nil  then
			if SET_EQUIP_ICON_FORGERY(frame, spotName) == false then
				SET_EQUIP_SLOT(frame, i, equipItemList, _INV_EQUIP_LIST_SET_ICON);
			end
		end		
	end
	frame:Invalidate();
end

function STATUS_EQUIP_SLOT_SET(frame)

	local curChildIndex = 0;

	SET_EQUIP_LIST(frame, session.GetEquipItemList(), _INV_EQUIP_LIST_SET_ICON);
	
end

function STATUS_EQUIP_SLOT_SET_ANIM(frame)
	SET_EQUIP_LIST_ANIM(frame, session.GetEquipItemList(), _INV_EQUIP_LIST_SET_ICON);
end

function GET_SLOT_BY_ITEMID(slotSet, itemID)
	
	for i = 0 , slotSet:GetSlotCount() - 1 do
		local slot = slotSet:GetSlotByIndex(i );
		local icon = slot:GetIcon();
		if icon ~= nil then
			local iconInfo = icon:GetInfo();
			
			if iconInfo:GetIESID() == tostring(itemID) then
				return slot;
			end
		end
	end

	return nil;
end


function GET_SLOT_BY_ITEMTYPE(slotSet, itemtype)
	for i = 0 , slotSet:GetSlotCount() - 1 do
		local slot = slotSet:GetSlotByIndex( i );
		local icon = slot:GetIcon();
		if icon ~= nil then
			local iconInfo = icon:GetInfo();

			if iconInfo.type == itemtype then
				return slot;
			end
		end
	end

	return nil;

end


s_dropDeleteItemIESID = '';

function INVENTORY_DELETE(itemIESID, itemType)
	if true == BEING_TRADING_STATE() then
		return;
	end

	local invframe = ui.GetFrame("inventory");
	if ui.GetPickedFrame() ~= nil then
		return;
	end

	local invItem = session.GetInvItemByGuid(itemIESID);
	if nil == invItem then
		return;
	end

	if true == invItem.isLockState or true == IS_TEMP_LOCK(invframe, invItem) then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local cls = GetClassByType("Item", itemType);
	if nil == cls then
		return;
	end

	local itemProp = geItemTable.IsDestroyable(itemType);
	if cls.Destroyable == 'NO' or geItemTable.IsDestroyable(itemType) == false then
		local obj = GetIES(invItem:GetObject());
		if obj.ItemLifeTimeOver == 0 then
			ui.AlarmMsg("ItemIsNotDestroy");
			return;
		end
	end

	--if cls.UserTrade == 'YES' or cls.ShopTrade == 'YES' then
		s_dropDeleteItemIESID = itemIESID;
		local yesScp = string.format("EXEC_DELETE_ITEMDROP()");
		ui.MsgBox(ScpArgMsg("Auto_JeongMal_[")..cls.Name..ScpArgMsg("Auto_]_eul_BeoLiSiKessSeupNiKka?"), yesScp, "None");
	--end
end

function EXEC_DELETE_ITEMDROP()
	item.DropDelete(s_dropDeleteItemIESID);
	s_dropDeleteItemIESID = '';
end

function JUNGTAN_SLOT_INVEN_ON_MSG(frame, msg, str, itemType)	
	if str == 'JUNGTAN_OFF' then

		frame:SetUserValue("JUNGTAN_EFFECT", 0);
		local timer = GET_CHILD(frame, "jungtantimer", "ui::CAddOnTimer");
		timer:Stop();		

	elseif str == 'JUNGTAN_ON' then
		local invItem = session.GetInvItemByType(itemType);
		if invItem == nil then
			return;
		end
		frame:SetUserValue("JUNGTAN_EFFECT", invItem:GetIESID());
		local timer = GET_CHILD(frame, "jungtantimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_INVENTORY_JUNGTAN");
		timer:Start(1);		

	elseif str == 'JUNGTANDEF_OFF' then

		frame:SetUserValue("JUNGTANDEF_EFFECT", 0);
		local timer = GET_CHILD(frame, "jungtandeftimer", "ui::CAddOnTimer");
		timer:Stop();		

	elseif str == 'JUNGTANDEF_ON' then

		frame:SetUserValue("JUNGTANDEF_EFFECT", itemType);
		local timer = GET_CHILD(frame, "jungtandeftimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_INVENTORY_JUNGTANDEF");
		timer:Start(1);		
	end
end

function UPDATE_INVENTORY_JUNGTAN(frame, ctrl, num, str, time)
	if frame:IsVisible() == 0 then
		return;
	end
	local jungtanID = frame:GetUserIValue("JUNGTAN_EFFECT");
	if jungtanID == 0 then
		return;
	end
	local slotSet = INV_GET_SLOTSET_BY_ITEMID(jungtanID)

	local slot = GET_SLOT_BY_ITEMTYPE(slotSet, jungtanID);
	if slot == nil then
		return;
	end
	local posX, posY = GET_SCREEN_XY(slot);

	movie.PlayUIEffect('I_sys_item_slot', posX, posY, 1.2);
end

function UPDATE_INVENTORY_JUNGTANDEF(frame, ctrl, num, str, time)
	if frame:IsVisible() == 0 then
		return;
	end
	local jungtanID = tonumber( frame:GetUserValue("JUNGTANDEF_EFFECT") );
	if jungtanID == 0 then
		return;
	end

	local slotSet = INV_GET_SLOTSET_BY_ITEMID(jungtanID)
	local slot = GET_SLOT_BY_ITEMTYPE(slotSet, jungtanID);
	if(slot == nil ) then
		return;
	end
	local posX, posY = GET_SCREEN_XY(slot);

	movie.PlayUIEffect('I_sys_item_slot', posX, posY, 1.2);

end

-- slotanim
function INVENTORY_SLOTANIM_CHANGEIMG(frame, key, str, cnt)
	if cnt < 4 then
		return;
	end
	
	local subStr = string.sub(str, 0, string.len(str) - 4);
	local spot = item.GetEquipSpotNum(subStr);
		
	local child = frame:GetChild(str);
	if  child  ~=  nil  then			
		local slot = tolua.cast(child, 'ui::CAnimPicture');
		slot:ForcePlayAnimationReverse();		
		SET_EQUIP_SLOT(frame, spot, nil, _INV_EQUIP_LIST_SET_ICON)
		
		local equipSound = "sys_armor_equip_new";
		imcSound.PlaySoundEvent(equipSound);
	end
end

function EQUIP_RING(itemobj, argNum)
	local ring1 = session.GetEquipItemBySpot(item.GetEquipSpotNum("RING1"));
	local ring2 = session.GetEquipItemBySpot(item.GetEquipSpotNum("RING2"));
	
	local equipItem1 = GetIES(ring1:GetObject())
	local equipItem2 = GetIES(ring2:GetObject())

	if IS_NO_EQUIPITEM(equipItem1) == 1 then
		ITEM_EQUIP(argNum, "RING1");
		return;
	end
	if IS_NO_EQUIPITEM(equipItem2) == 1 then
		ITEM_EQUIP(argNum, "RING2");
		return;
	end

	if keyboard.IsPressed(KEY_ALT) == 1 then
		ITEM_EQUIP(argNum, "RING2");
		return;
	else
		ITEM_EQUIP(argNum, "RING1");
		return;
	end
end

function SORT_ITEM_INVENTORY()
	local context = ui.CreateContextMenu("CONTEXT_INV_SORT", "", 0, 0, 170, 100);
	local scpScp = string.format("REQ_INV_SORT(%d, %d)",IT_INVENTORY, BY_PRICE);
	ui.AddContextMenuItem(context, ScpArgMsg("SortByPrice"), scpScp);	
	scpScp = string.format("REQ_INV_SORT(%d, %d)",IT_INVENTORY, BY_LEVEL);
	ui.AddContextMenuItem(context, ScpArgMsg("SortByLevel"), scpScp);	
	scpScp = string.format("REQ_INV_SORT(%d, %d)",IT_INVENTORY, BY_WEIGHT);
	ui.AddContextMenuItem(context, ScpArgMsg("SortByWeight"), scpScp);	
	scpScp = string.format("REQ_INV_SORT(%d, %d)",IT_INVENTORY, BY_NAME);
	ui.AddContextMenuItem(context, ScpArgMsg("SortByName"), scpScp);	
	ui.OpenContextMenu(context);
end

function REQ_INV_SORT(invType, sortType)
	item.SortInvIndex(invType, sortType);
end

function LOCK_ITEM_INVENTORY(frame)
	for i = 0, AUTO_SELL_COUNT-1 do
		-- 뭐하나라도 true면
		if session.autoSeller.GetMyAutoSellerShopState(i) == true then
			ui.MsgBox(ScpArgMsg("CannotDoAction"));
			return;
		end
	end

	if true == BEING_TRADING_STATE() then
		return;
	end

	if true == IS_TRANSCENDING_STATE() then
		return;
	end

	session.inventory.SetInventoryLock();
	if false == session.inventory.GetInventoryLock() then
		_CANCEL_INV_ITEM_LOCK(1)
		return;
	end
	
	local invframe = frame:GetTopParentFrame();
	if nil == invframe then
		return;
	end

	ui.GuideMsg("SelectItem");
	local scpScp = string.format("_CANCEL_INV_ITEM_LOCK(%d)",0);
	ui.SetEscapeScp(scpScp);
	SET_INV_LBTN_FUNC(invframe, "INV_ITEM_LOCK_LBTN_CLICK");
	CHANGE_MOUSE_CURSOR("MORU", "Lock", "CURSOR_CHECK_IN_LOCK");
end

function _CANCEL_INV_ITEM_LOCK(isChange)
	if 0 == isChange then
		session.inventory.SetInventoryLock();
	end
	
	if true == session.inventory.GetInventoryLock() then
		return;
	end

	ui.RemoveGuideMsg("SelectItem");
	ui.SetEscapeScp("");
	local frame = ui.GetFrame("inventory");
	SET_INV_LBTN_FUNC(frame, "None");
	RESET_MOUSE_CURSOR();
end

function CURSOR_CHECK_IN_LOCK(slot)
	local item = GET_SLOT_ITEM(slot);
	if item == nil then
		return 0;
	end
	
	local obj = GetIES(item:GetObject());
	if obj.ItemType ~= "Quest" then
		return 1;
	end
	
	return 0;
end

function INV_ITEM_LOCK_LBTN_CLICK(frame, selectItem, object)
	
	local itemType = object.ItemType;
	if nil == itemType then
		local obj = GetIES(selectItem:GetObject());
		itemType = obj.ItemType;
	end

	if itemType == "Quest" then
		return;
	end

	local invframe = ui.GetFrame("inventory");
	if selectItem:GetIESID() == invframe:GetUserValue("ITEM_GUID_IN_AWAKEN") 
		or selectItem:GetIESID() == invframe:GetUserValue("STONE_ITEM_GUID_IN_AWAKEN") then
			ui.SysMsg(ClMsg("selectItemUsed"));
			return;
	end
	
	--디스펠러, 오마모리 관련 처리
	local obj = GetIES(selectItem:GetObject());
	if obj.ClassName == "Dispeller_1" or obj.ClassName == 'Bujeok_1' then
		if false == selectItem.isLockState then
			if true == item.useToggleDispelDebuff() then
				ui.SysMsg(ClMsg("selectItemUsed"));
				return;
			end
		end
	end

	local state = 1;
	local slot = tolua.cast(object, "ui::CSlot");
	slot:Select(0)
	local controlset = slot:CreateOrGetControlSet('inv_itemlock', "itemlock", -5, slot:GetWidth() - 35);
	if true == selectItem.isLockState then
		state = 0;
		controlset:ShowWindow(0);
	else
		controlset:ShowWindow(1);
	end
	
	session.inventory.SendLockItem(selectItem:GetIESID(), state);
end

function INV_ITEM_LOCK_SAVE_FAIL(frame, msg, argStr, agrNum)
	for typeNo = 1, #g_invenTypeStrList do
		local tree = GET_CHILD_RECURSIVELY(frame, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')
	for i = 1 , #SLOTSET_NAMELIST do
		local slotset = GET_CHILD(tree,SLOTSET_NAMELIST[i],'ui::CSlotSet')
		if nil ~= slotset then
			local slotCount = slotset:GetSlotCount();
			for i = 0, slotCount - 1 do
				local slot		= slotset:GetSlotByIndex(i );
				AUTO_CAST(slot);
				local invItem = GET_SLOT_ITEM(slot);
				if invItem ~= nil and invItem:GetIESID() == argStr then
					invItem.isLockState = argNum;
					ui.SysMsg(ClMsg("ItemLockSaveFail"));
					local controlset = slot:CreateOrGetControlSet('inv_itemlock', "itemlock", -5, slot:GetWidth() - 35);
					if 1 == agrNum then
						controlset:ShowWindow(1);
					else
						controlset:ShowWindow(0);
					end
				end

			end	
		end
		end
	end
end

function INV_HAT_VISIBLE_STATE(frame)

	if frame == nil then
		frame = ui.GetFrame("inventory");
	end
	
	local myPCetc = GetMyEtcObject();

	local hat_Visible = myPCetc.HAT_Visible
	local hat_t_Visible = myPCetc.HAT_T_Visible
	local hat_l_Visible = myPCetc.HAT_L_Visible

	local hat = GET_CHILD_RECURSIVELY(frame, 'HAT_Visible')
	local hat_t = GET_CHILD_RECURSIVELY(frame, 'HAT_T_Visible')
	local hat_l = GET_CHILD_RECURSIVELY(frame, 'HAT_L_Visible')
	
	if hat_Visible == 1 then
		hat:SetImage("inven_hat_layer_on");
		hat:SetTextTooltip(ScpArgMsg('HAT_ON'))
	else
		hat:SetImage("inventory_hat_layer_off");
		hat:SetTextTooltip(ScpArgMsg('HAT_OFF'))
	end

	if hat_t_Visible == 1 then
		hat_t:SetImage("inven_hat_layer_on");
		hat_t:SetTextTooltip(ScpArgMsg('HAT_ON'))
	else
		hat_t:SetImage("inventory_hat_layer_off");
		hat_t:SetTextTooltip(ScpArgMsg('HAT_OFF'))

	end

	if hat_l_Visible == 1 then
		hat_l:SetImage("inven_hat_layer_on");
		hat_l:SetTextTooltip(ScpArgMsg('HAT_ON'))

	else
		hat_l:SetImage("inventory_hat_layer_off");
		hat_l:SetTextTooltip(ScpArgMsg('HAT_OFF'))
	end

	local equipgroup = GET_CHILD(frame, 'equip', 'ui::CGroupBox')
	local shihouette = GET_CHILD(equipgroup, 'shihouette', "ui::CPicture");
	local shihouette_imgname = ui.CaptureMyFullStdImage();
	shihouette:SetImage(shihouette_imgname);

	frame:Invalidate()
end

function INV_HAT_VISIBLE_STEATE_SET(frame)
	
	if frame:GetUserIValue("CLICK_COOL_TIME") > imcTime.GetAppTime() then
		return;	
	end

	frame:SetUserValue("CLICK_COOL_TIME", imcTime.GetAppTime() + 1);

	local slotName = frame:GetName()
	local topFrame = frame:GetTopParentFrame()

	local myPCetc = GetMyEtcObject();

	local visibleState = myPCetc[slotName.."_Visible"]

	if visibleState == 1 then
		myPCetc[slotName.."_Visible"] = 0;
	else
		myPCetc[slotName.."_Visible"] = 1
	end

	local visibleBtnInfo = GET_CHILD_RECURSIVELY(frame, slotName.."_Visible")

	if visibleState == 1 then
		visibleBtnInfo:SetImage("inven_hat_layer_on");
		ui.ChangeTooltipText(ScpArgMsg('HAT_OFF'))
	else
		visibleBtnInfo:SetImage("inventory_hat_layer_off");
		ui.ChangeTooltipText(ScpArgMsg('HAT_ON'))
	end

	local index = 0;

	if slotName == "HAT" then
		index = 0
	elseif slotName == "HAT_T" then
		index = 1
	elseif slotName == "HAT_L" then
		index = 2
	end

	control.CustomCommand("HAT_VISIBLE_STATE", index);
end

-- 기간제 아이템 판별 함수
function IS_LIFETIME_OVER(itemobj)

	if itemobj.LifeTime == nil then
		return 0;

	elseif 0 ~= itemobj.LifeTime then		

		-- 기간에 따라 정하기
		local sysTime = geTime.GetServerSystemTime();
		local endTime = imcTime.GetSysTimeByStr(itemobj.ItemLifeTime);
		local difSec = imcTime.GetDifSec(endTime, sysTime);		
		
		-- 기간만료 일 경우에
		if 0 > difSec then
			return 1;
		end;
		
		-- ItemLifeTimeOver으로 검사하는 함수		
		--[[
		if 0 ~= itemobj.ItemLifeTimeOver then
			return 1;
		end;
		]]
	end;
	return 0;
end

function INVENTORY_ON_APPRAISER_FORGERY(frame, msg, argStr, argNum)
	frame:SetUserValue('FORGERY_BUFF_TIME', argNum);
	STATUS_EQUIP_SLOT_SET(frame);
end

function GET_WEAPON_SWAP_INDEX()
	local curIndex = 0
	for i = 0, 3 do
		local guid = session.GetWeaponQuicSlot(i);
		if nil ~= guid then
			local item = session.GetEquipItemByGuid(guid);
			if nil ~= item then
				curIndex = i
			end
		end
	end

	return curIndex
end

function MAKE_WEAPON_SWAP_BUTTON()
	
	local frame = ui.GetFrame("inventory");
	

	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end

	local weaponSwap1 = GET_CHILD_RECURSIVELY(frame, "weapon_swap_1")
	local weaponSwap2 = GET_CHILD_RECURSIVELY(frame, "weapon_swap_2")
	
	local abil = GetAbility(pc, "SwapWeapon");
	
	if abil ~= nil then
		weaponSwap1 : ShowWindow(1)
		weaponSwap2 : ShowWindow(1)
	else
		weaponSwap1 : ShowWindow(0)
		weaponSwap2 : ShowWindow(0)

		return;
	end


	local curIndex = 0
	curIndex = GET_WEAPON_SWAP_INDEX()
				
	local WEAPONSWAP_UP_IMAGE = frame:GetUserConfig('WEAPONSWAP_UP_IMAGE')
	local WEAPONSWAP_DOWN_IMAGE = frame : GetUserConfig('WEAPONSWAP_DOWN_IMAGE')

	if frame : GetUserIValue('CURRENT_WEAPON_INDEX') == 0 then
		if curIndex == 0 or curIndex == 1 then
			frame : SetUserValue('CURRENT_WEAPON_INDEX', 1)
			weaponSwap1 : SetImage(WEAPONSWAP_UP_IMAGE);
			weaponSwap2:SetImage(WEAPONSWAP_DOWN_IMAGE);
		elseif curIndex == 2 or curIndex == 3 then
			frame : SetUserValue('CURRENT_WEAPON_INDEX', 2)
			weaponSwap2 : SetImage(WEAPONSWAP_UP_IMAGE);
			weaponSwap1:SetImage(WEAPONSWAP_DOWN_IMAGE);
		end
	elseif frame : GetUserIValue('CURRENT_WEAPON_INDEX') == 1 then
		DO_WEAPON_SWAP(frame, 1)
	elseif frame : GetUserIValue('CURRENT_WEAPON_INDEX') == 2 then
		DO_WEAPON_SWAP(frame, 2)
	end
end

function WEAPONSWAP_HOTKEY_ENTERED()
		--제작시에는 무기스왑 안되게 끔..
	if GetCraftState() == 1 then
		ui.SysMsg(ClMsg("prosessItemCraft"));
		return;
	end
	local frame = ui.GetFrame("inventory");
	

	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end

	local abil = GetAbility(pc, "SwapWeapon");
	
	if abil == nil then
		return;
	end

	local curIndex = 0
	curIndex = GET_WEAPON_SWAP_INDEX()

	if frame:GetUserIValue('CURRENT_WEAPON_INDEX') == 1 then
		DO_WEAPON_SWAP(frame, 2)
	elseif frame:GetUserIValue('CURRENT_WEAPON_INDEX') == 2 then
		DO_WEAPON_SWAP(frame, 1)
	elseif frame:GetUserIValue('CURRENT_WEAPON_INDEX') == 0 then
		if curIndex == 0 or curIndex == 1 then
			DO_WEAPON_SWAP(frame, 2)
		elseif curIndex == 2 or curIndex == 3 then
			DO_WEAPON_SWAP(frame, 1)
		end
	end
end

--index = 1 일때 1번창으로 스왑하는 함수. 2일때 2번창으로 스왑하는 함수
function DO_WEAPON_SWAP(frame, index)
	if frame == nil then
		frame = ui.GetFrame("inventory");
	end

	if index == nil then
		index = 1
	end

	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end
	
	local weaponSwap1 = GET_CHILD_RECURSIVELY(frame, "weapon_swap_1")
	local weaponSwap2 = GET_CHILD_RECURSIVELY(frame, "weapon_swap_2")

	local WEAPONSWAP_UP_IMAGE = frame:GetUserConfig('WEAPONSWAP_UP_IMAGE')
	local WEAPONSWAP_DOWN_IMAGE = frame : GetUserConfig('WEAPONSWAP_DOWN_IMAGE')

	if index == 1 then
		weaponSwap1:SetImage(WEAPONSWAP_UP_IMAGE);
		weaponSwap2:SetImage(WEAPONSWAP_DOWN_IMAGE);
	elseif index == 2 then
		weaponSwap1 : SetImage(WEAPONSWAP_DOWN_IMAGE);
		weaponSwap2:SetImage(WEAPONSWAP_UP_IMAGE);
	end

	if frame:GetUserIValue('CURRENT_WEAPON_INDEX') == index then
		return;
	end

	frame : SetUserValue('CURRENT_WEAPON_INDEX', index)
	session.SetWeaponSwap(1);

	local abil = GetAbility(pc, "SwapWeapon");

	if abil ~= nil then
		weaponSwap1 : ShowWindow(1)
		weaponSwap2 : ShowWindow(1)
	else
		weaponSwap1 : ShowWindow(0)
		weaponSwap2 : ShowWindow(0)
	end

	local tempIndex = 0;
	if index == 1 then
		tempIndex = 2
	elseif index == 2 then
		tempIndex = 0
	end

	SHOW_WEAPON_SWAP_TEMP_IMAGE(frame:GetUserIValue('CURRENT_WEAPON_RH'), frame : GetUserIValue('CURRENT_WEAPON_LH'), tempIndex)
end

function DO_WEAPON_SWAP_1(frame)
	if frame == nil then
		frame = ui.GetFrame("inventory");
	end

	DO_WEAPON_SWAP(frame, 1)
end

function DO_WEAPON_SWAP_2(frame)
	if frame == nil then
		frame = ui.GetFrame("inventory");
	end

	DO_WEAPON_SWAP(frame, 2)
end