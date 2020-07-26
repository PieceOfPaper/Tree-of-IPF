-- inventory.lua
g_lock_state_item_guid = 0
lock_state_check = {}
g_weapon_swap_request_index = nil

local item_grade = 5

lock_state_check.can_lock = function(item_guid)
    if g_lock_state_item_guid == item_guid then return false
    else return true end
end

lock_state_check.clear_lock_state = function()
    g_lock_state_item_guid = 0
end

-- 특정아이템의 락을 막는다.
lock_state_check.disable_lock_state = function(item_guid)
    g_lock_state_item_guid = item_guid
end

-- 특정아이템의 락을 허용한다.
lock_state_check.enable_lock_state = function(item_guid)
    if g_lock_state_item_guid == item_guid then
        g_lock_state_item_guid = 0
    end
end

local invenTitleName = nil
local clickedLockItemSlot = nil

g_shopList = {"companionshop", "housing_shop", "shop", "exchange", "oblation_sell"};
g_invenTypeStrList = {"All", "Equip", "Consume", "Recipe", "Card", "Etc", "Gem", "Premium", "Housing"};

local _invenCatOpenOption = {}; -- key: cid, value: {key: CategoryName, value: IsToggle}
local _invenTreeOpenOption = {}; -- key: cid, value: {key: TreegroupName, value: IsToggle}
local _invenSortTypeOption = {}; -- key: cid, value: SortType

function CHECK_INVENTORY_OPTION_EQUIP(itemCls)
	if itemCls == nil then
		return 0
	end

	local itemGrade = itemCls.ItemGrade
	local optionConfig = 1
	if itemGrade == 1 then
		optionConfig = config.GetXMLConfig("InvOption_Equip_Normal")
	elseif itemGrade == 2 then
		optionConfig = config.GetXMLConfig("InvOption_Equip_Magic")
	elseif itemGrade == 3 then
		optionConfig = config.GetXMLConfig("InvOption_Equip_Rare")
	elseif itemGrade == 4 then
		optionConfig = config.GetXMLConfig("InvOption_Equip_Unique")
	elseif itemGrade == 5 then
		optionConfig = config.GetXMLConfig("InvOption_Equip_Legend")
	end

	if config.GetXMLConfig("InvOption_Equip_All") == 1 then
		optionConfig = 1
	end

	if optionConfig == 0 then
		return
	end

	local itemTranscend = TryGetProp(itemCls, "Transcend")
	local itemReinforce = TryGetProp(itemCls, "Reinforce_2")
	local itemAppraisal = TryGetProp(itemCls, "NeedAppraisal")
	local itemRandomOption = TryGetProp(itemCls, "NeedRandomOption")

	if config.GetXMLConfig("InvOption_Equip_Upgrade") == 1 then
		if itemTranscend ~= nil and itemTranscend == 0 and itemReinforce ~= nil and itemReinforce == 0 then
			optionConfig = 0
		end
	end

	if config.GetXMLConfig("InvOption_Equip_Random") == 1 then
		if itemAppraisal ~= nil and itemAppraisal == 0 and itemRandomOption ~= nil and itemRandomOption == 0 then
			optionConfig = 0
		end
	end

	return optionConfig
end

function CHECK_INVENTORY_OPTION_CARD(itemCls)
	if config.GetXMLConfig("InvOption_Card_All") == 1 then
		return 1
	end

	if itemCls == nil then
		return 0
	end

	local cardGroup = itemCls.MarketCategory
	local optionConfig = 1
	if cardGroup == "Card_CardRed" then
		optionConfig = config.GetXMLConfig("InvOption_Card_Red")
	elseif cardGroup == "Card_CardBlue" then
		optionConfig = config.GetXMLConfig("InvOption_Card_Blue")
	elseif cardGroup == "Card_CardGreen" then
		optionConfig = config.GetXMLConfig("InvOption_Card_Green")
	elseif cardGroup == "Card_CardPurple" then
		optionConfig = config.GetXMLConfig("InvOption_Card_Purple")
	elseif cardGroup == "Card_CardLeg" then
		optionConfig = config.GetXMLConfig("InvOption_Card_Legend")
	elseif cardGroup == "Card_CardAddExp" then
		optionConfig = config.GetXMLConfig("InvOption_Card_Etc")
	end

	return optionConfig
end

function CHECK_INVENTORY_OPTION_ETC(itemCls)
	if config.GetXMLConfig("InvOption_Etc_All") == 1 then
		return 1
	end

	if itemCls == nil then
		return 0
	end

	local itemCategory = itemCls.MarketCategory
	local optionConfig = 0
	if itemCategory == "Misc_Usual" or itemCategory == "Misc_MiscSkill" then
		optionConfig = config.GetXMLConfig("InvOption_Etc_Usual")
	elseif itemCategory == "Misc_Quest" then
		optionConfig = config.GetXMLConfig("InvOption_Etc_Quest")
	elseif itemCategory == "Misc_Special" or itemCategory == "OPTMisc_IcorWeapon" or itemCategory == "OPTMisc_IcorArmor" then
		optionConfig = config.GetXMLConfig("InvOption_Etc_Special")
	elseif itemCategory == "Misc_Collect" then
		optionConfig = config.GetXMLConfig("InvOption_Etc_Collect")
	elseif itemCategory == "Misc_Etc" then
		optionConfig = config.GetXMLConfig("InvOption_Etc_Etc")
	elseif itemCategory == "Misc_Mineral" then
		optionConfig = config.GetXMLConfig("InvOption_Etc_Mineral")
	end

	return optionConfig
end

function CHECK_INVENTORY_OPTION_GEM(itemCls)
	if config.GetXMLConfig("InvOption_Gem_All") == 1 then
		return 1
	end

	if itemCls == nil then
		return 0
	end

	local cardGroup = itemCls.MarketCategory
	local optionConfig = 1
	if cardGroup == "Gem_GemRed" then
		optionConfig = config.GetXMLConfig("InvOption_Gem_Red")
	elseif cardGroup == "Gem_GemBlue" then
		optionConfig = config.GetXMLConfig("InvOption_Gem_Blue")
	elseif cardGroup == "Gem_GemGreen" then
		optionConfig = config.GetXMLConfig("InvOption_Gem_Green")
	elseif cardGroup == "Gem_GemYellow" then
		optionConfig = config.GetXMLConfig("InvOption_Gem_Yellow")
	elseif cardGroup == "Gem_GemLegend" then
		optionConfig = config.GetXMLConfig("InvOption_Gem_Legend")
	elseif cardGroup == "Gem_GemSkill" then
		optionConfig = config.GetXMLConfig("InvOption_Gem_Skill")
	elseif cardGroup == "Gem_GemWhite" then
		optionConfig = config.GetXMLConfig("InvOption_Gem_White")
	end
	
	return optionConfig
end

function INVENTORY_ON_INIT(addon, frame)
	addon:RegisterMsg('ITEM_LOCK_FAIL', 'INV_ITEM_LOCK_SAVE_FAIL');
	addon:RegisterMsg('MYPC_CHANGE_SHAPE','INVENTORY_MYPC_CHANGE_SHAPE');
    addon:RegisterMsg('GAME_START', 'INVENTORY_ON_MSG');
	addon:RegisterMsg('EQUIP_ITEM_LIST_GET', 'INVENTORY_ON_MSG');
	addon:RegisterMsg('EQUIP_ITEM_LIST_UPDATE', 'INVENTORY_ON_MSG');
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
	addon:RegisterMsg('EXP_ORB_ITEM_ON', 'EXP_ORB_SLOT_INVEN_ON_MSG');
	addon:RegisterMsg('EXP_ORB_ITEM_OFF', 'EXP_ORB_SLOT_INVEN_ON_MSG');
	addon:RegisterMsg('EXP_SUB_ORB_ITEM_ON', 'EXP_SUB_ORB_SLOT_INVEN_ON_MSG');
	addon:RegisterMsg('EXP_SUB_ORB_ITEM_OFF', 'EXP_SUB_ORB_SLOT_INVEN_ON_MSG');
	addon:RegisterMsg('TOGGLE_ITEM_SLOT_ON', 'TOGGLE_ITEM_SLOT_INVEN_ON_MSG');
	addon:RegisterMsg('TOGGLE_ITEM_SLOT_OFF', 'TOGGLE_ITEM_SLOT_INVEN_ON_MSG');
	addon:RegisterOpenOnlyMsg('WEIGHT_UPDATE', 'INVENTORY_WEIGHT_UPDATE');
	
	addon:RegisterMsg('UPDATE_ITEM_REPAIR', 'INVENTORY_ON_MSG');
	addon:RegisterMsg('UPDATE_ITEM_APPRAISAL', 'INVENTORY_ON_MSG');
	addon:RegisterMsg('SWITCH_GENDER_SUCCEED', 'INVENTORY_ON_MSG');
    addon:RegisterMsg('RESET_ABILITY_UP', 'INVENTORY_ON_MSG');
	addon:RegisterMsg('APPRAISER_FORGERY', 'INVENTORY_ON_APPRAISER_FORGERY');
    addon:RegisterMsg('LOCK_FAIL', 'INV_ITEM_LOCK_SAVE_FAIL');

	addon:RegisterOpenOnlyMsg('REFRESH_ITEM_TOOLTIP', 'ON_REFRESH_ITEM_TOOLTIP');
	addon:RegisterMsg('TOGGLE_EQUIP_ITEM_TOOLTIP_DESC', 'ON_TOGGLE_EQUIP_ITEM_TOOLTIP_DESC');

	addon:RegisterOpenOnlyMsg('ABILITY_LIST_GET', 'MAKE_WEAPON_SWAP_BUTTON');
	addon:RegisterMsg('UPDATE_LOCK_STATE', 'ON_UPDATE_LOCK_STATE');
	addon:RegisterMsg('UPDATE_TRUST_POINT', 'ON_UPDATE_TRUST_POINT');

	SHOP_SELECT_ITEM_LIST = {};
	INVENTORY_TOGGLE_ITEM_LIST = {};

	--검색 용 변수
	searchEnterCount = 1
	beforekeyword = "None"

	frame:SetUserValue("MONCARDLIST_OPENED", 0);
	local dropscp = frame:GetUserConfig("TREE_SLOT_DROPSCRIPT");
	frame:SetEventScript(ui.DROP, dropscp);
	INVENTORY_LIST_GET(frame);    
	RESET_INVENTORY_ICON();
end

function IS_SHOP_FRAME_OPEN()
	for i = 1, #g_shopList do
		if ui.GetFrame(g_shopList[i]):IsVisible() == 1 then
			return true;
		end
	end

	return false;
end

function UI_TOGGLE_INVENTORY()
	if app.IsBarrackMode() == true then
		return;
	end
	ui.ToggleFrame('inventory');
end

function IS_SLOTSET_NAME(name)
	local isSlotSetName = ui.inventory.HaveInventorySlotSetName(name);
	if isSlotSetName == true then
		return 1;
	end

	return 0
end

function UPDATE_INVENTORY_SLOT(slot, invItem, itemCls)
	INIT_INVEN_SLOT(slot);

	--거래목록 또는 상점 판매목록에서 올려놓은 아이템(슬롯) 표시 기능
	if IS_SHOP_FRAME_OPEN() then
		local remainInvItemCount = GET_REMAIN_INVITEM_COUNT(invItem);
		if remainInvItemCount ~= invItem.count then
			slot:Select(1);
		else
			slot:Select(0);
		end
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
		ui.inventory.AddInvenGroupName(treegroupname);
	end

	--슬롯셋 없으면 만들기
	local slotsetname = GET_SLOTSET_NAME(invItem.invIndex)
	local slotsetnode = tree:FindByValue(treegroup, slotsetname);
	if tree:IsExist(slotsetnode) == 0 then
		MAKE_INVEN_SLOTSET_AND_TITLE(tree, treegroup, slotsetname, baseidcls);
		INVENTORY_CATEGORY_OPENOPTION_CHECK(tree:GetName(), baseidcls.ClassName);
	end					
	slotset = GET_CHILD_RECURSIVELY(tree,slotsetname,'ui::CSlotSet');
	local slotCount = slotset:GetSlotCount();
	local slotindex = invItem.invIndex - GET_BASE_SLOT_INDEX(invItem.invIndex) - 1;

	--검색 기능
	local slot = nil;
	if cap == "" then
		slot = slotset:GetSlotByIndex(slotindex);
	else
		local cnt = GET_SLOTSET_COUNT(tree, baseidcls);
		-- 저장된 템의 최대 인덱스에 따라 자동으로 늘어나도록. 예를들어 해당 셋이 10000부터 시작하는데 10500 이 오면 500칸은 늘려야됨
		while slotCount <= cnt  do 
			slotset:ExpandRow(true)
			slotCount = slotset:GetSlotCount();
		end

		slot = slotset:GetSlotByIndex(cnt);
		cnt = cnt + 1;
		slotset:SetUserValue("SLOT_ITEM_COUNT", cnt)
	end

	slot:ShowWindow(1);	
	UPDATE_INVENTORY_SLOT(slot, invItem, itemCls);
	INV_ICON_SETINFO(frame, slot, invItem, customFunc, scriptArg, remainInvItemCount);
	SET_SLOTSETTITLE_COUNT(tree, baseidcls, 1)

	slotset:MakeSelectionList();
end

function MAKE_INVEN_SLOTSET_AND_TITLE(tree, treegroup, slotsetname, baseidcls)
	local slotsettitle = 'ssettitle_'..baseidcls.ClassName;
	if baseidcls.MergedTreeTitle ~= "NO" then
		slotsettitle = 'ssettitle_'..baseidcls.MergedTreeTitle
	end

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
	newslotset:CreateSlots();
	ui.inventory.AddInvenSlotSetName(name);
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

	local equipgroup = GET_CHILD_RECURSIVELY(frame, 'equip', 'ui::CGroupBox')
	local shihouette = GET_CHILD_RECURSIVELY(equipgroup, 'shihouette', "ui::CPicture");
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
	session.inventory.ReqTrustPoint();

	local savedPos = frame:GetUserValue("INVENTORY_CUR_SCROLL_POS");		
	if savedPos == 'None' then
		savedPos = '0'
	end
				
	local tree_box = GET_CHILD_RECURSIVELY(frame, 'treeGbox_All')
	tree_box:SetScrollPos( tonumber(savedPos) );

	session.CheckOpenInvCnt();
	ui.CloseFrame('layerscore');
	MAKE_WEAPON_SWAP_BUTTON();
	local questInfoSetFrame = ui.GetFrame('questinfoset_2');
	if questInfoSetFrame:IsVisible() == 1 then
		questInfoSetFrame:ShowWindow(0);
	end

	INV_HAT_VISIBLE_STATE(frame);
	INV_HAIR_WIG_VISIBLE_STATE(frame);

	local minimapFrame = ui.GetFrame('minimap');
	minimapFrame:ShowWindow(0);
end

function INVENTORY_CLOSE()
	local frame = ui.GetFrame("inventory");
	frame:SetUserValue("MONCARDLIST_OPENED", 1);		-- 바로 다음에 있는 OPEN_MANAGED_CARDINVEN 함수에서 0으로 만들어준다.
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

	ui.CloseFrame("inventoryoption")
end

function INVENTORY_FRONT_IMAGE_CLEAR(frame)
	local slotSetNameListCnt = ui.inventory.GetInvenSlotSetNameCount();
	for j = 1, slotSetNameListCnt do
		local group = GET_CHILD_RECURSIVELY(frame, 'inventoryGbox', 'ui::CGroupBox')
		for typeNo = 1, #g_invenTypeStrList do
			local tree_box = GET_CHILD_RECURSIVELY(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
			local tree = GET_CHILD_RECURSIVELY(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')

			local slotSetName = ui.inventory.GetInvenSlotSetNameByIndex(i - 1);
			local slotSet = GET_CHILD_RECURSIVELY(tree, slotSetName, 'ui::CSlotSet');
			if slotSet ~= nil then
				local slotCount = slotSet:GetSlotCount();
				for i = 0, slotCount - 1 do
					local slot = slotSet:GetSlotByIndex(i );
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

function SET_SLOT_APPLY_FUNC(frame, funcName, slotSetName, invenTypeStr)
	frame:SetUserValue("SLOT_APPLY_FUNC", funcName);
	if funcName == "None" then
		INV_APPLY_TO_ALL_SLOT(_SLOT_RESET_GRAY_BLINK);
	end

	if invenTypeStr == nil then
		local tab = GET_CHILD_RECURSIVELY(frame, "inventype_Tab")
		if tab ~= nil then
			local tabIndex = tab:GetSelectItemIndex()
			UPDATE_INV_LIST(frame, slotSetName, g_invenTypeStrList[tabIndex + 1]);
		end
	else
		UPDATE_INV_LIST(frame, slotSetName, invenTypeStr);
	end
end

function UPDATE_INV_LIST(frame, slotSetName, invenTypeStr)
	INVENTORY_LIST_GET(frame, nil, slotSetName, invenTypeStr);
end

function INVENTORY_WEIGHT_UPDATE(frame)
	local bottomgroup = GET_CHILD_RECURSIVELY(frame, 'bottomGbox', 'ui::CGroupBox')
	local weightPicture = GET_CHILD_RECURSIVELY(bottomgroup, 'inventory_weight','ui::CPicture')
	local pc = GetMyPCObject();
	local newwidth = 0;			
	local rate = 0;				
	if pc.MaxWeight ~= 0 then
		newwidth =  math.floor( pc.NowWeight * weightPicture:GetOriginalWidth() / pc.MaxWeight )
		rate = math.floor(pc.NowWeight * 100 / pc.MaxWeight)
	end
	weightPicture:Resize(weightPicture:GetOriginalWidth(), weightPicture:GetOriginalHeight())
		
	local weightscptext = ScpArgMsg("Weight{All}{Max}", "All", string.format("%.1f", pc.NowWeight), "Max", string.format("%.1f", pc.MaxWeight))
	local weightratetext = ScpArgMsg("Weight{Rate}", "Rate", tostring(rate))

	if newwidth > weightPicture:GetOriginalWidth() then
		newwidth = weightPicture:GetOriginalWidth();
	end

	local weightGbox = GET_CHILD_RECURSIVELY(bottomgroup, 'weightGbox','ui::CGroupBox')
	weightGbox:SetTextTooltip(weightscptext)

	local weighttext = GET_CHILD_RECURSIVELY(bottomgroup, 'invenweight','ui::CRichText')
	weighttext:SetText(weightratetext)	

	--Ruler Resize
	local arrowPicture = GET_CHILD_RECURSIVELY(bottomgroup, 'inventory_arrow','ui::CPicture')
	
	local rulerTextureWidth = frame:GetUserConfig("WEIGHT_PIC_WIDTH");	--Texture Widht
	local rulerWidth = arrowPicture:GetOriginalWidth();					--Origin Width
	local rulerRate = rulerTextureWidth / rulerWidth;					--rate
	local arrowPictureWidth = rulerTextureWidth - 124;		
	local arrowPictureRate = arrowPictureWidth / rulerWidth;

	arrowPicture:Resize(arrowPicture:GetOriginalWidth() * rulerRate, arrowPicture:GetOriginalHeight())

	if rate >= 100 then
		SYSMENU_INVENTORY_WEIGHT_NOTICE();
	else
		SYSMENU_INVENTORY_WEIGHT_NOTICE_CLOSE();
	end

	if rate > 100 then	
		arrowPicture:SetOffset(-489, arrowPicture:GetOriginalY())
		return;
	end

	--SetOffset : rate에 맞춘 offset 움직임 값
	local arrowPictureOffSetX = rate * arrowPicture:GetOriginalWidth() * 3.65 * 0.01;	
	arrowPicture:SetOffset((arrowPictureOffSetX) * -1, arrowPicture:GetOriginalY())

end

function INVITEM_INVINDEX_CHANGE(itemGuid)

	local frame = ui.GetFrame("inventory");

	local invSlot = INVENTORY_GET_SLOT_BY_IESID(frame, itemGuid)
	local invSlot_All = INVENTORY_GET_SLOT_BY_IESID(frame, itemGuid, 1)

	if invSlot == nil or invSlot_All == nil then
		return;
	end

	ONUPDATE_SLOT_INVINDEX(invSlot);
	ONUPDATE_SLOT_INVINDEX(invSlot_All);

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

function TEMP_INV_ADD(frame, invIndex)
	ui.inventory.InventoryTempItemAdd(frame:GetName(), invIndex);
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
		local baseClsList, cnt = GetClassList("inven_baseid")
		for i = 0, cnt - 1 do
			if baseCls == nil then
				local tempCls = GetClassByIndexFromList(baseClsList, i)
				if tempCls.MergedTreeTitle == baseClassName then
					baseCls = tempCls
				end
			end
		end

		if baseCls == nil then
			IMC_LOG("INFO_NORMAL", "Baseclass does not exist" .. baseClassName);
			return 1;
		end
	end

	return baseScore + (100 - baseCls.ClassID) * 100;

end

function TEMP_INV_REMOVE(frame, itemGuid)
	ui.inventory.InventoryTempItemRemove(frame:GetName(), itemGuid);
end

function REMOVE_FROM_SLOTSET(slotsetname)
	ui.inventory.RemoveInvenSlotSetName(slotsetname);
end

function REMOVE_FROM_TREEGROUP(treegroupname)
	ui.inventory.RemoveInvenGroupName(treegroupname);
end

function INVENTORY_ON_MSG(frame, msg, argStr, argNum)
	if msg == 'INV_ITEM_LIST_GET' or msg == 'RESET_ABILITY_UP' then
        INVENTORY_LIST_GET(frame)
		STATUS_EQUIP_SLOT_SET(frame);
	end
	
	if msg == 'UPDATE_ITEM_REPAIR' or msg == 'UPDATE_ITEM_APPRAISAL' then
    	INVENTORY_LIST_GET(frame, nil, nil, argStr)
		STATUS_EQUIP_SLOT_SET(frame);
	end

	if msg == "UPDATE_ITEM_TRANSCEND_SCROLL" then
		INVENTORY_UPDATE_ITEM_BY_GUID(frame, argStr);
		STATUS_EQUIP_SLOT_SET(frame);
	end
	
	if msg == 'INV_ITEM_ADD' then
		TEMP_INV_ADD(frame, argNum);
	end
	
	if  msg == 'EQUIP_ITEM_LIST_GET' then
		STATUS_EQUIP_SLOT_SET_ANIM(frame);
		STATUS_EQUIP_SLOT_SET(frame);
		SET_VISIBLE_DYE_BTN_BY_ITEM_EQUIP(frame);	--염색버튼 숨기기/보이기
	end

	if  msg == 'EQUIP_ITEM_LIST_UPDATE' then		
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
		INV_SLOT_UPDATE(frame, invItem, itemSlot)
		local itemSlot_All = INV_GET_SLOT_BY_ITEMGUID(itemGuid, nil, 1)
		if itemSlot_All ~= nil then
			local invItem_All = GET_PC_ITEM_BY_GUID(itemGuid)
			INV_SLOT_UPDATE(frame, invItem_All, itemSlot_All)
		end

		frame:Invalidate();
		return;
	end
	
	itemSlot = GET_PC_EQUIP_SLOT_BY_ITEMID(itemGuid);
	if itemSlot ~= nil then
		local invItem = GET_PC_ITEM_BY_GUID(itemGuid);
		AUTO_CAST(itemSlot);
		local eqpItemList = session.GetEquipItemList();        
		SET_EQUIP_SLOT_BY_SPOT(frame, invItem, eqpItemList, "_INV_EQUIP_LIST_SET_ICON");
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
		local itemSlot_All = INV_GET_SLOT_BY_ITEMGUID(itemGuid, frame, 1)
		if itemSlot_All ~= nil then
			INV_SLOT_UPDATE(frame, invItem, itemSlot_All)
		end
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

function INVENTORY_GET_SLOT_BY_IESID(frame, itemGuid, isAll)
	local invItem = session.GetInvItemByGuid(itemGuid);
	if invItem == nil then
		return nil;
	end
	return INVENTORY_GET_SLOT_BY_INVITEM(frame, invItem, isAll);
end

function INVENTORY_GET_SLOT_BY_INVITEM(frame, changeTargetItem, isAll)
	local group = GET_CHILD_RECURSIVELY(frame, 'inventoryGbox', 'ui::CGroupBox')
	local slotSetNameListCnt = ui.inventory.GetInvenSlotSetNameCount();

	if isAll ~= nil and isAll == 1 then
		local tree_box = GET_CHILD_RECURSIVELY(group, 'treeGbox_All','ui::CGroupBox')
		local tree = GET_CHILD_RECURSIVELY(tree_box, 'inventree_All','ui::CTreeControl')
		for i = 1, slotSetNameListCnt do
			local slotSetName = ui.inventory.GetInvenSlotSetNameByIndex(i - 1);
			local slotSet = GET_CHILD_RECURSIVELY(tree, slotSetName, 'ui::CSlotSet');	
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

	for typeNo = 2, #g_invenTypeStrList do
		local tree_box = GET_CHILD_RECURSIVELY(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
		local tree = GET_CHILD_RECURSIVELY(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')
		for i = 1, slotSetNameListCnt do
			local slotSetName = ui.inventory.GetInvenSlotSetNameByIndex(i - 1);
			local slotSet = GET_CHILD_RECURSIVELY(tree, slotSetName, 'ui::CSlotSet');	
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
	local slot_All = INVENTORY_GET_SLOT_BY_INVITEM(frame, changeTargetItem, 1);
	if slot ~= nil and slot_All ~= nil then
		local itemCls = GetIES(changeTargetItem:GetObject());		
		UPDATE_INVENTORY_SLOT(slot, changeTargetItem, itemCls)
		UPDATE_INVENTORY_SLOT(slot_All, changeTargetItem, itemCls)
	end
end

function SLOTSET_UPDATE_ICONS_BY_NAME(frame, slotSetName)
	local group = GET_CHILD_RECURSIVELY(frame, 'inventoryGbox', 'ui::CGroupBox')
	for typeNo = 1, #g_invenTypeStrList do
		local tree_box = GET_CHILD_RECURSIVELY(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
		local tree = GET_CHILD_RECURSIVELY(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')

		local slotSet = nil;
		local slotSetNameListCnt = ui.inventory.GetInvenSlotSetNameCount();
		for i = 1, slotSetNameListCnt do
			local getSlotSetName = ui.inventory.GetInvenSlotSetNameByIndex(i - 1);
			if string.find(getSlotSetName, slotSetName) ~= nil then
				slotSet = GET_CHILD_RECURSIVELY(tree, getSlotSetName, 'ui::CSlotSet');	
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
		local slot = slotSet:GetChildByIndex(j)
		local invItem = GET_SLOT_ITEM(slot)        
		if invItem ~= nil then
			local itemCls = GetIES(invItem:GetObject())            
			UPDATE_INVENTORY_SLOT(slot, invItem, itemCls)
			INV_SLOT_UPDATE(frame, invItem, slot)
		end
	end
end

function INVENTORY_UPDATE_ICONS(frame)
	local group = GET_CHILD_RECURSIVELY(frame, 'inventoryGbox', 'ui::CGroupBox')
	for typeNo = 1, #g_invenTypeStrList do
		local tree_box = GET_CHILD_RECURSIVELY(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
		local tree = GET_CHILD_RECURSIVELY(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')
		
		local slotSetNameListCnt = ui.inventory.GetInvenSlotSetNameCount();
		for i = 1, slotSetNameListCnt do
			local getSlotSetName = ui.inventory.GetInvenSlotSetNameByIndex(i - 1);
			local slotSet = GET_CHILD_RECURSIVELY(tree, getSlotSetName, 'ui::CSlotSet');	
			SLOTSET_UPDATE_ICONS_BY_SLOTSET(frame, slotSet)
		end
	end
end

--특정 경우에서 모든 아이템 리스트를 돌 필요는 없기 떄문에
--특정 슬롯셋의 리스트만 가져올 때, slotSetName 값을 넣는다.
function INVENTORY_LIST_GET(frame, setpos, slotSetName, invenTypeStr)
	SET_INVENTORY_MODE(frame, "Normal");
	
	--이미 인벤토리의 리스트는 만들어져 있는데, slotSetName 이부분 갱신해주고 싶어서
	--모든 리스트를 다 불러올 필요는 없다.
	if slotSetName == nil then
		INVENTORY_TOTAL_LIST_GET(frame, setpos, nil, invenTypeStr);
	end
	
	DRAW_TOTAL_VIS(frame, 'invenZeny');
	local funcStr = frame:GetUserValue("SLOT_APPLY_FUNC");
	if funcStr ~= "None" then
		local slotSetNameListCnt = ui.inventory.GetInvenSlotSetNameCount();
		for i = 1, slotSetNameListCnt do
			local group = GET_CHILD_RECURSIVELY(frame, 'inventoryGbox', 'ui::CGroupBox')
			local getSlotSetName = ui.inventory.GetInvenSlotSetNameByIndex(i - 1);
			if invenTypeStr == nil then
				for typeNo = 1, #g_invenTypeStrList do
					local tree_box = GET_CHILD_RECURSIVELY(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
					local tree = GET_CHILD_RECURSIVELY(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')
					
					local slotSet = GET_CHILD_RECURSIVELY(tree, getSlotSetName, 'ui::CSlotSet');			
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
			else
				local tree_box = GET_CHILD_RECURSIVELY(group, 'treeGbox_'.. invenTypeStr,'ui::CGroupBox')
				local tree = GET_CHILD_RECURSIVELY(tree_box, 'inventree_'.. invenTypeStr,'ui::CTreeControl')
				local slotSet = GET_CHILD_RECURSIVELY(tree, getSlotSetName, 'ui::CSlotSet');			

				local tree_box_all = GET_CHILD_RECURSIVELY(group, 'treeGbox_All','ui::CGroupBox')
				local tree_all = GET_CHILD_RECURSIVELY(tree_box_all, 'inventree_All','ui::CTreeControl')
				local slotSet_all = GET_CHILD_RECURSIVELY(tree_all, getSlotSetName, 'ui::CSlotSet');			
				
				if slotSet ~= nil and slotSet_all ~= nil then
					if slotSetName ~= nil then
						if string.find(slotSet:GetName(), slotSetName) then
							local func = _G[funcStr];
							APPLY_TO_ALL_ITEM_SLOT(slotSet, func);
							APPLY_TO_ALL_ITEM_SLOT(slotSet_all, func);
						end
					else
						local func = _G[funcStr];
						APPLY_TO_ALL_ITEM_SLOT(slotSet, func);
						APPLY_TO_ALL_ITEM_SLOT(slotSet_all, func);
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
		slot:SetText(' ', 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
		slot:SetOverSound('button_cursor_over_3');
		slot:ClearIcon()
		DESTROY_CHILD_BYNAME(slot, "styleset_")
	end
end

function GET_SLOTSET_NAME(invIndex)
	local cls = GET_BASEID_CLS_BY_INVINDEX(invIndex)
	if cls == nil then
		return 'error'
	else
		local className = cls.ClassName
		if cls.MergedTreeTitle ~= "NO" then
			className = cls.MergedTreeTitle
		end
		return 'sset_'..className
	end
end

function GET_BASEID_CLS_BY_INVINDEX(invIndex)
	local clslist, cnt  = GetClassList("inven_baseid");
	local classID = math.floor((invIndex - 1 ) / 5000)
	if classID > cnt then
		return nil
	end
	return GetClassByIndexFromList(clslist, classID - 1)
end

function GET_INVTREE_GROUP_NAME(invIndex)
	local cls = GET_BASEID_CLS_BY_INVINDEX(invIndex)
	if cls == nil then
		return 'error'
	else
		return cls.TreeGroup
	end
end

function GET_SLOTSET_COUNT(tree, baseIDCls)
	local titlestr = "ssettitle_" .. baseIDCls.ClassName;
	if baseIDCls.MergedTreeTitle ~= "NO" then
		titlestr = 'ssettitle_'..baseIDCls.MergedTreeTitle
	end
	local textcls = GET_CHILD_RECURSIVELY(tree, titlestr, 'ui::CRichText');
	local curCount = textcls:GetUserIValue("TOTAL_COUNT");

	return curCount;
end

function SET_INVENTORY_SLOTSET_OPEN(parent, ctrl, strarg, numarg)
	if ctrl == nil then
		return;
	end

	local slotset = GET_CHILD_RECURSIVELY(parent, "sset_" .. strarg)
	if slotset == nil then
		return;
	end

	local width = slotset:GetWidth();
	local height = slotset:GetHeight();
	if height ~= 0 then
		slotset:SetUserValue("width", width)
		slotset:SetUserValue("height", height)
		slotset:Resize(0, 0)
		local title = ctrl:GetText()
		local changeTitle = string.gsub(title, "btn_minus", "btn_plus")
		ctrl:SetText(changeTitle)
	else
		local originWidth = slotset:GetUserIValue("width")
		local originHeight = slotset:GetUserIValue("height")
		slotset:Resize(originWidth, originHeight)
		local title = ctrl:GetText()
		local changeTitle = string.gsub(title, "btn_plus", "btn_minus")
		ctrl:SetText(changeTitle)
	end
	
	INVENTORY_CATEGORY_OPENOPTION_CHANGE(parent, '', strarg);
end

function CHECK_INVENTORY_OPTION_APPLIED(baseidcls)
	if baseidcls == nil then
		return 0;
	end

	local configName = ""
	local typeStr = GET_INVENTORY_TREEGROUP(baseidcls)

	local viewOptionCheck = 1
	if typeStr == "Equip" then
		viewOptionCheck = config.GetXMLConfig("InvOption_Equip_All")
		if viewOptionCheck == 1 then
			if config.GetXMLConfig("InvOption_Equip_Upgrade") == 1 or config.GetXMLConfig("InvOption_Equip_Random") == 1 then
				viewOptionCheck = 0;
			end
		end
	elseif typeStr == "Card" then
		viewOptionCheck = config.GetXMLConfig("InvOption_Card_All")
	elseif typeStr == "Etc" then
		viewOptionCheck = config.GetXMLConfig("InvOption_Etc_All")					
	elseif typeStr == "Gem" then
		viewOptionCheck = config.GetXMLConfig("InvOption_Gem_All")
	end		

	if viewOptionCheck == 1 then
		return 0;
	else
		return 1;
	end

end

function SET_SLOTSETTITLE_COUNT(tree, baseidcls, addCount)
	local clslist, cnt  = GetClassList("inven_baseid");
	local className = baseidcls.ClassName
	if baseidcls.MergedTreeTitle ~= "NO" then
		className = baseidcls.MergedTreeTitle
	end
	
	local titlestr = "ssettitle_" .. className;
	local textcls = GET_CHILD_RECURSIVELY(tree, titlestr, 'ui::CRichText');
	textcls:SetEventScript(ui.LBUTTONUP, "SET_INVENTORY_SLOTSET_OPEN")
	textcls:SetEventScript(ui.DROP, "INVENTORY_ON_DROP")
	textcls:SetEventScriptArgString(ui.LBUTTONUP, className)
	local curCount = textcls:GetUserIValue("TOTAL_COUNT");
	curCount = curCount + addCount;
	textcls:SetUserValue("TOTAL_COUNT", curCount);
	textcls:SetText('{img btn_minus 20 20} ' .. baseidcls.TreeSSetTitle..' (' .. curCount .. ')' )

	local hGroup = tree:FindByValue(baseidcls.TreeGroup);
	if hGroup ~= nil then
		local treeNode = tree:GetNodeByTreeItem(hGroup);
		local newCaption = treeNode:GetUserValue("BASE_CAPTION");
		local totalCount = treeNode:GetUserIValue("TOTAL_ITEM_COUNT");
		totalCount = totalCount + addCount;		
		treeNode:SetUserValue("TOTAL_ITEM_COUNT", totalCount);

		local isOptionApplied = CHECK_INVENTORY_OPTION_APPLIED(baseidcls)
		local isOptionAppliedText = ""
		if isOptionApplied == 1 then
			isOptionAppliedText = ClMsg("ApplyOption")
		end

		tree:SetItemCaption(hGroup,newCaption..' ('..totalCount..') '.. isOptionAppliedText)
	end
end

function ADD_GROUP_BOTTOM_MARGIN(frame, tree)
	local bottommargin = frame:GetUserConfig("TREE_GROUP_BOTTOM_MARGIN");
	local groupNameListCnt = ui.inventory.GetInvenGroupNameCount();
	for i = 1, groupNameListCnt do
		local groupName = ui.inventory.GetInvenGroupNameByIndex(i - 1);
		local treegroup = tree:FindByValue(groupName);
		if tree:IsExist(treegroup) == 1 then
			local margin = tree:CreateOrGetControl('richtext', 'margin'..groupName, 0, 0, 400, bottommargin);
			tolua.cast(margin, "ui::CRichText");
			margin:EnableResizeByText(0);
			margin:SetFontName('white_22_ol');
			margin:SetText('');	
			margin:SetTextAlign('left','bottom');
			tree:Add(treegroup, margin, 'margin'..groupName);
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

	if IS_SHOP_FRAME_OPEN() then
		slot:SetSelectedImage('socket_slot_check') -- 거래시에만 체크 셀렉 아이콘 사용	
	end

	slot:EnableHideInDrag(true)
	slot:SetPickSound(picksound)
	slot:SetDropSound(dropsound)
	slot:SetEventScript(ui.DROP, dropscp);
	slot:SetEventScript(ui.POP, popscp);
end

function INVENTORY_SLOT_UNCHECK(frame, itemID)
	--Inventory Slot Uncheck Setting
	local group = GET_CHILD_RECURSIVELY(frame, 'inventoryGbox', 'ui::CGroupBox');
	for typeNo = 1, #g_invenTypeStrList do
		local tree_box = GET_CHILD_RECURSIVELY(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox');
		local tree = GET_CHILD_RECURSIVELY(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl');

		local slotSetNameListCnt = ui.inventory.GetInvenSlotSetNameCount();
		for i = 1, slotSetNameListCnt do
			local slotSetName = ui.inventory.GetInvenSlotSetNameByIndex(i - 1);
			local slotSet = GET_CHILD_RECURSIVELY(tree, slotSetName, 'ui::CSlotSet');
			if slotSet == nil then
				return;
			end

			for j = 0, slotSet:GetChildCount() - 1 do
				local slot = slotSet:GetChildByIndex(j);
				local slotItem = GET_SLOT_ITEM(slot);
				if slotItem ~= nil then
					if IS_SHOP_FRAME_OPEN() and ui.GetFrame('housing_shop'):IsVisible() ~= 1 then
						if slotItem:GetIESID() == itemID then
							slot:Select(0);
						end
					end
				end
				
				if slotItem ~= nil then
					INV_SLOT_UPDATE(frame, slotItem, slot);
				end
			end
		end
	end
end

function SEARCH_ITEM_INVENTORY_KEY()
	local frame = ui.GetFrame('inventory')
	frame:CancelReserveScript("SEARCH_ITEM_INVENTORY");
	frame:ReserveScript("SEARCH_ITEM_INVENTORY", 0.3, 1);
end

function SEARCH_ITEM_INVENTORY(a,b,c)
	local frame = ui.GetFrame('inventory')
	local group = GET_CHILD_RECURSIVELY(frame, 'inventoryGbox', 'ui::CGroupBox')
	local searchGbox = group:GetChild('searchGbox');
	local searchSkin = GET_CHILD_RECURSIVELY(searchGbox, "searchSkin",'ui::CGroupBox');
	local edit = GET_CHILD_RECURSIVELY(searchSkin, "ItemSearch", "ui::CEditControl")

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
	local remainInvItemCount = invItem.count;
	for iesid, selllistcount in pairs(SHOP_SELECT_ITEM_LIST) do
		local item = GetObjectByGuid(iesid);
		if item ~= nil then
			if item.ClassID == invItem.type then
				remainInvItemCount = remainInvItemCount - selllistcount
			end
		end
	end
	return remainInvItemCount;
end

function INVENTORY_SORT_BY_GRADE(a, b)
	local itemCls_a = GetIES(a:GetObject());
	local itemCls_b = GetIES(b:GetObject());

	local a_grade = 0
	local b_grade = 0

	if itemCls_a.ItemType == "Equip" then
		a_grade = itemCls_a.ItemGrade
	end
	if itemCls_b.ItemType == "Equip" then
		b_grade = itemCls_b.ItemGrade
	end

	if itemCls_a.GroupName == "Recipe" then
		local recipe_a = GetClass("Recipe", itemCls_a.ClassName)
		if recipe_a ~= nil then
			local targetItem_a = GetClass("Item", recipe_a.TargetItem)
			a_grade = targetItem_a.ItemGrade
		end
	end

	if itemCls_b.GroupName == "Recipe" then
		local recipe_b = GetClass("Recipe", itemCls_b.ClassName)
		if recipe_b ~= nil then
			local targetItem_b = GetClass("Item", recipe_b.TargetItem)
			b_grade = targetItem_b.ItemGrade
		end
	end

	if itemCls_a.GroupName == "Card" then
		a_grade = TryGetProp(itemCls_a, "ItemExp", 0);
	end

	if itemCls_b.GroupName == "Card" then
		b_grade = TryGetProp(itemCls_b, "ItemExp", 0);
	end

	if itemCls_a.GroupName == "Gem" then
		if a.GemLevel ~= nil then
			a_grade = a.GemLevel
		end
	end

	if itemCls_b.GroupName == "Gem" then
		if b.GemLevel ~= nil then
			b_grade = b.GemLevel
		end
	end
	
	return a_grade > b_grade
end

function INVENTORY_SORT_BY_WEIGHT(a, b)
	local itemCls_a = GetIES(a:GetObject());
	local itemCls_b = GetIES(b:GetObject());

    return itemCls_a.Weight * a.count > itemCls_b.Weight * b.count;
end


function INVENTORY_SORT_BY_NAME(a, b)
	local itemCls_a = GetIES(a:GetObject());
	local itemCls_b = GetIES(b:GetObject());
	local itemName_a = dic.getTranslatedStr(itemCls_a.Name);
	local itemName_b = dic.getTranslatedStr(itemCls_b.Name);

    return itemName_a < itemName_b;
end


function INVENTORY_SORT_BY_COUNT(a, b)
	return a.count > b.count
end

function INVENTORY_TOTAL_LIST_GET(frame, setpos, isIgnorelifticon, invenTypeStr)
	local frame = ui.GetFrame("inventory")
	if frame == nil then return; end

	local liftIcon = ui.GetLiftIcon();
	if nil == isIgnorelifticon then
		isIgnorelifticon = "NO";
	end
	
	if isIgnorelifticon ~= "NO" and liftIcon ~= nil then 
		return; 
	end

	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local sortType = _invenSortTypeOption[cid];
	session.BuildInvItemSortedList();
	local sortedList = session.GetInvItemSortedList();
	local invItemCount = sortedList:size();

	if sortType == nil then
		sortType = 0;
	end

	local blinkcolor = frame:GetUserConfig("TREE_SEARCH_BLINK_COLOR");
	local group = GET_CHILD_RECURSIVELY(frame, 'inventoryGbox', 'ui::CGroupBox')

	for typeNo = 1, #g_invenTypeStrList do
		if invenTypeStr == nil or invenTypeStr == g_invenTypeStrList[typeNo] or typeNo == 1 then
			local tree_box = GET_CHILD_RECURSIVELY(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
			local tree = GET_CHILD_RECURSIVELY(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')

			local groupfontname = frame:GetUserConfig("TREE_GROUP_FONT");
			local tabwidth = frame:GetUserConfig("TREE_TAB_WIDTH");

			tree:Clear();
			tree:EnableDrawFrame(false)
			tree:SetFitToChild(true,60)
			tree:SetFontName(groupfontname);
			tree:SetTabWidth(tabwidth);

			local slotSetNameListCnt = ui.inventory.GetInvenSlotSetNameCount();
			for i = 1, slotSetNameListCnt do
				local slotSetName = ui.inventory.GetInvenSlotSetNameByIndex(i - 1);
				ui.inventory.RemoveInvenSlotSetName(slotSetName);
			end

			local groupNameListCnt = ui.inventory.GetInvenGroupNameCount();
			for i = 1, groupNameListCnt do
				local groupName = ui.inventory.GetInvenGroupNameByIndex(i - 1);
				ui.inventory.RemoveInvenGroupName(groupName);
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
	end
	
	local baseidclslist, baseidcnt  = GetClassList("inven_baseid");
	local searchGbox = group:GetChild('searchGbox');
	local searchSkin = GET_CHILD_RECURSIVELY(searchGbox, "searchSkin",'ui::CGroupBox');
	local edit = GET_CHILD_RECURSIVELY(searchSkin, "ItemSearch", "ui::CEditControl");
	local cap = edit:GetText();
	if cap ~= "" then
		local slotSetNameListCnt = ui.inventory.GetInvenSlotSetNameCount();
		for i = 1, slotSetNameListCnt do
			local getSlotSetName = ui.inventory.GetInvenSlotSetNameByIndex(i - 1);
			local slotset = GET_CHILD_RECURSIVELY(tree, getSlotSetName, 'ui::CSlotSet');
			slotset:RemoveAllChild();
			slotset:SetUserValue("SLOT_ITEM_COUNT", 0);
		end
	end

	local invItemList = {}
	local index_count = 1
	for i = 0, invItemCount - 1 do
		local invItem = sortedList:at(i);
		if invItem ~= nil then
			invItemList[index_count] = invItem
			index_count = index_count + 1
		end
	end

	--1 등급순 / 2 무게순 / 3 이름순 / 4 소지량순
	if sortType == 1 then
		table.sort(invItemList, INVENTORY_SORT_BY_GRADE)
	elseif sortType == 2 then
		table.sort(invItemList, INVENTORY_SORT_BY_WEIGHT)
	elseif sortType == 3 then
		table.sort(invItemList, INVENTORY_SORT_BY_NAME)
	elseif sortType == 4 then
		table.sort(invItemList, INVENTORY_SORT_BY_COUNT)
	else
		table.sort(invItemList, INVENTORY_SORT_BY_NAME)
	end
	
	if invenTitleName == nil then
		invenTitleName = {}	
		for i = 1, baseidcnt do
			local baseidcls = GetClassByIndexFromList(baseidclslist, i-1)
			local tempTitle = baseidcls.ClassName
			if baseidcls.MergedTreeTitle ~= "NO" then
				tempTitle = baseidcls.MergedTreeTitle
			end

			if table.find(invenTitleName, tempTitle) == 0 then
				invenTitleName[#invenTitleName + 1] = tempTitle
			end
		end
	end

	local cls_inv_index = {}		
	local i_cnt = 0	
	for i = 1, #invenTitleName do
		local category = invenTitleName[i]
		for j = 1 , #invItemList do			
			local invItem = invItemList[j];
			if invItem ~= nil then
				local itemCls = GetIES(invItem:GetObject())
				if itemCls.MarketCategory ~= "None" then
					local baseidcls = nil
					if cls_inv_index[invItem.invIndex] == nil then
						baseidcls = GET_BASEID_CLS_BY_INVINDEX(invItem.invIndex)						
						cls_inv_index[invItem.invIndex] = baseidcls						
					else
						baseidcls = cls_inv_index[invItem.invIndex]						
					end
					
					local titleName = baseidcls.ClassName
					if baseidcls.MergedTreeTitle ~= "NO" then
						titleName = baseidcls.MergedTreeTitle
					end

					if category == titleName then
						local typeStr = GET_INVENTORY_TREEGROUP(baseidcls)
						if itemCls ~= nil then
							local makeSlot = true;
							if cap ~= "" then
								--인벤토리 안에 있는 아이템을 찾기 위한 로직
								local itemname = string.lower(dictionary.ReplaceDicIDInCompStr(itemCls.Name));
								--접두어도 포함시켜 검색해야되기 때문에, 접두를 찾아서 있으면 붙여주는 작업
								local prefixClassName = TryGetProp(itemCls, "LegendPrefix")
								if prefixClassName ~= nil and prefixClassName ~= "None" then
									local prefixCls = GetClass('LegendSetItem', prefixClassName)
									local prefixName = string.lower(dictionary.ReplaceDicIDInCompStr(prefixCls.Name));
									itemname = prefixName .. " " .. itemname;
								end

								local tempcap = string.lower(cap);
								local a = string.find(itemname, tempcap);
								if a == nil then
									makeSlot = false;
								end			
							end				

							local viewOptionCheck = 1
							if typeStr == "Equip" then
								viewOptionCheck = CHECK_INVENTORY_OPTION_EQUIP(itemCls)
							elseif typeStr == "Card" then
								viewOptionCheck = CHECK_INVENTORY_OPTION_CARD(itemCls)
							elseif typeStr == "Etc" then
								viewOptionCheck = CHECK_INVENTORY_OPTION_ETC(itemCls)					
							elseif typeStr == "Gem" then
								viewOptionCheck = CHECK_INVENTORY_OPTION_GEM(itemCls)
							end						

							if makeSlot == true and viewOptionCheck == 1 then
								
						
								if invItem.count > 0 and baseidcls.ClassName ~= 'Unused' then -- Unused로 설정된 것은 안보임
									if invenTypeStr == nil or invenTypeStr == typeStr then
										local tree_box = GET_CHILD_RECURSIVELY(group, 'treeGbox_'.. typeStr,'ui::CGroupBox')
										local tree = GET_CHILD_RECURSIVELY(tree_box, 'inventree_'.. typeStr,'ui::CTreeControl')								
										INSERT_ITEM_TO_TREE(frame, tree, invItem, itemCls, baseidcls);
									end

									local tree_box_all = GET_CHILD_RECURSIVELY(group, 'treeGbox_All','ui::CGroupBox')
									local tree_all = GET_CHILD_RECURSIVELY(tree_box_all, 'inventree_All','ui::CTreeControl')	
									INSERT_ITEM_TO_TREE(frame, tree_all, invItem, itemCls, baseidcls);
								end
							else
								if customFunc ~= nil then
									local slot = slotSet:GetSlotByIndex(i);
									if slot ~= nil then
										customFunc(slot, scriptArg, invItem, nil);
									end
								end
							end
						end
					end
				end
			end
		end
	end

	for typeNo = 1, #g_invenTypeStrList do
		local tree_box = GET_CHILD_RECURSIVELY(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox');
		local tree = GET_CHILD_RECURSIVELY(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl');

		--아이템 없는 빈 슬롯은 숨겨라
		local slotSetNameListCnt = ui.inventory.GetInvenSlotSetNameCount();
		for i = 1, slotSetNameListCnt do
			local getSlotSetName = ui.inventory.GetInvenSlotSetNameByIndex(i - 1);
			slotset = GET_CHILD_RECURSIVELY(tree, getSlotSetName, 'ui::CSlotSet');
			if slotset ~= nil then
				ui.InventoryHideEmptySlotBySlotSet(slotset);
			end			
		end

		ADD_GROUP_BOTTOM_MARGIN(frame,tree)
		tree:OpenNodeAll();
		tree:SetEventScript(ui.LBUTTONDOWN, "INVENTORY_TREE_OPENOPTION_CHANGE");
		INVENTORY_CATEGORY_OPENCHECK(frame, tree);

		--검색결과 스크롤 세팅은 여기서 하자. 트리 업데이트 후에 위치가 고정된 다음에.
		for i = 1, slotSetNameListCnt do
			local getSlotSetName = ui.inventory.GetInvenSlotSetNameByIndex(i - 1);
			slotset = GET_CHILD_RECURSIVELY(tree, getSlotSetName, 'ui::CSlotSet');

			local slotsetnode = tree:FindByValue(getSlotSetName);
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
	local frame = ui.GetFrame('inventory');
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
	
	if keyboard.IsKeyPressed("LCTRL") == 1 then
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
	-- 워프 주문서 아니면 리턴
	if itemobj.ClassID ~= 640022 and itemobj.ClassID ~= 640079 and itemobj.ClassID ~= 490006 and itemobj.ClassID ~= 490110 then
		return 0;
	end

	local pc = GetMyPCObject();
	if pc == nil or IsPVPServer(pc) == 1 then
		local isEnableUseInPVPMap = TryGetProp(itemobj, "PVPMap");
		if isEnableUseInPVPMap ~= "YES" then
			ui.SysMsg(ScpArgMsg("CannotUseThieInThisMap"));
			return 0;
		end
	end
	
	if IsBuffApplied(pc, 'WEEKLY_BOSS_RAID_BUFF') == 'YES' or IsBuffApplied(pc, 'Event_Penalty') == 'YES' or IsBuffApplied(pc, 'PVP_MINE_BUFF1') == 'YES' or IsBuffApplied(pc, 'PVP_MINE_BUFF2') == 'YES' then
		ui.SysMsg(ScpArgMsg("CannotUseThieInThisMap"));
		return 0;
	end
	
	-- 워프 주문서 예외처리. 실제 워프가 이루어질때 아이템이 소비되도록.
	local warpscrolllistcls = GetClass("warpscrolllist", itemobj.ClassName);
	if warpscrolllistcls ~= nil then
		if tonumber(itemobj.LifeTime) > 0 and tonumber(itemobj.ItemLifeTimeOver) > 0 then
			ui.SysMsg(ScpArgMsg("LessThanItemLifeTime"));
			return 1;
		end

        if session.colonywar.GetIsColonyWarMap() == true then
            ui.SysMsg(ClMsg('ThisLocalUseNot'));
            return 0;
        end
		
		if true == invitem.isLockState then
			ui.SysMsg(ClMsg("MaterialItemIsLock"));
			return 1;
		end
		
		local pc = GetMyPCObject();
		local warpFrame = ui.GetFrame('worldmap');
		warpFrame:SetUserValue('SCROLL_WARP', itemobj.ClassName)
        warpFrame:SetUserValue('SCROLL_WARP_IESID', tostring(invitem:GetIESID()))        
		warpFrame:ShowWindow(1);
		return 1;
	end
	
	return 0;
end

function IS_TEMP_LOCK(invFrame, invitem)	
	if invFrame:GetUserValue('ITEM_GUID_IN_MORU') == invitem:GetIESID()
		or invitem:GetIESID() == invFrame:GetUserValue("ITEM_GUID_IN_TRANSCEND")
		or invitem:GetIESID() == invFrame:GetUserValue("ITEM_GUID_IN_TRANSCEND_SCROLL") then		
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

	if keyboard.IsKeyPressed("LCTRL") == 1 then
		local obj = GetIES(invitem:GetObject());
		IES_MAN_IESID(invitem:GetIESID());
		return;
	end

	local itemobj = GetIES(invitem:GetObject());

    -- custom
	local customRBtnScp = frame:GetTopParentFrame():GetUserValue("CUSTOM_RBTN_SCP");	
	if customRBtnScp == "None" then
		customRBtnScp = nil;
	else
		customRBtnScp = _G[customRBtnScp];
	end

	if customRBtnScp ~= nil then
		customRBtnScp(itemobj, object, invitem:GetIESID());
		imcSound.PlaySoundEvent("icon_get_down");
		return;
	end

	if INVENTORY_RBTN_LEGENDPREFIX(invitem) == true then
		return;
	end

	if INVENTORY_RBTN_LEGENDDECOMPOSE(invitem) == true then
		return;
	end

    if INVENTORY_RBTN_MARKET_SELL(invitem) == true then
    	return;
    end
	
	local invFrame = ui.GetFrame("inventory");	
	invFrame:SetUserValue("INVITEM_GUID", invitem:GetIESID());

    -- shop
	local frame = ui.GetFrame("shop");
	local companionshop = ui.GetFrame('companionshop');
	local housingShopFrame = ui.GetFrame("housing_shop");
	if companionshop:IsVisible() == 1 then
		frame = companionshop:GetChild('foodBox');
	elseif housingShopFrame:IsVisible() == 1 then
		frame = GET_CHILD_RECURSIVELY(housingShopFrame, "gbox_bottom");
	end

	if frame:IsVisible() == 1 then
		local groupName = itemobj.GroupName;
		if groupName == 'Money' then
			return;
		end

		local invFrame = ui.GetFrame("inventory");
		local invGbox = invFrame:GetChild('inventoryGbox');
		if true == IS_TEMP_LOCK(invFrame, invitem) then
			return;
		end

		local Itemclass = GetClassByType("Item", invitem.type);
		local ItemType = Itemclass.ItemType;

		local invIndex = invitem.invIndex;
		local baseidcls = GET_BASEID_CLS_BY_INVINDEX(invIndex)
		local typeStr = GET_INVENTORY_TREEGROUP(baseidcls)
	
		local tree_box = invGbox:GetChild('treeGbox_'.. typeStr);
		local tree = tree_box:GetChild('inventree_'.. typeStr);
		local slotsetname = GET_SLOTSET_NAME(argNum)
		local slotSet = GET_CHILD_RECURSIVELY(tree,slotsetname,"ui::CSlotSet")
		local itemProp = geItemTable.GetPropByName(Itemclass.ClassName);
		if itemProp:IsEnableShopTrade() == true then
			if IS_SHOP_SELL(invitem, Itemclass.MaxStack, frame) == 1 then
				if keyboard.IsKeyPressed("LSHIFT") == 1 then
					local sellableCount = invitem.count;
					local titleText = ScpArgMsg("INPUT_CNT_D_D", "Auto_1", 1, "Auto_2", sellableCount);
					if housingShopFrame:IsVisible() == 1 then
						INPUT_NUMBER_BOX(invFrame, titleText, "EXEC_HOUSING_SHOP_SELL", 1, 1, sellableCount);
					else
						INPUT_NUMBER_BOX(invFrame, titleText, "EXEC_SHOP_SELL", 1, 1, sellableCount);
					end
					invFrame:SetUserValue("SELL_ITEM_GUID", invitem:GetIESID());
					return;
				end
					
				-- 상점 Sell Slot으로 넘긴다.
				if housingShopFrame:IsVisible() == 1 then
					HOUSING_SHOP_SELL(invitem, 1, frame);
				else
					SHOP_SELL(invitem, 1, frame);
				end
				return;
			else
	        	ui.SysMsg(ClMsg("CannotSellMore"));
			end
		end

		return;
	end	

    -- mixer
	local mixerFrame = ui.GetFrame("mixer");
	if mixerFrame:IsVisible() == 1 then
		local slotSet = INV_GET_SLOTSET_BY_INVINDEX(argNum-1)
		local slot = slotSet:GetSlotByIndex(argNum-1);
		MIXER_INVEN_RBOTTUNDOWN(itemobj, argNum);
		return;
	end

    -- warp
	if TRY_TO_USE_WARP_ITEM(invitem, itemobj) == 1 then
		return;
	end

    -- equip
	local equip = IS_EQUIP(itemobj);
	if equip == true then
		ui.SetHideToolTip();
		imcSound.PlaySoundEvent('inven_equip');
		if itemobj.EqpType == 'RING' then
			EQUIP_RING(itemobj, argNum)			
		else
			ITEM_EQUIP(argNum);
		end
	else -- non-equip item use        
		if true == RUN_CLIENT_SCP(invitem) then        
            return;
		end
		local groupName = itemobj.GroupName;
		local itemType = itemobj.ItemType;
		if itemType == 'Consume' or itemType == 'Quest' or itemType == 'Cube' or groupName == 'ExpOrb' or groupName == 'SubExpOrb' then
			if itemobj.Usable == 'ITEMTARGET' then
				local invFrame = ui.GetFrame('inventory');
				USE_ITEMTARGET_ICON(invFrame, itemobj, argNum);
			else
				local invItem	= session.GetInvItem(argNum);
				local invItemAllowReopen = ''
				if itemobj ~= nil then
					invItemAllowReopen = TryGetProp(itemobj, 'AllowReopen')
				end
				local gachaCubeFrame = ui.GetFrame('gacha_cube')
				if itemType == 'Consume' and gachaCubeFrame ~= nil and gachaCubeFrame:IsVisible() == 1 and invItemAllowReopen == 'YES' then
					return
				end
				
				INV_ICON_USE(invItem);
			end
		elseif itemType == 'Gem' then
			if itemobj.Usable == 'ITEMTARGET' then
				local invFrame = ui.GetFrame('inventory');
				USE_ITEMTARGET_ICON(invFrame, itemobj, argNum);
			end
		end
	end

    -- card equip
	-- 오른쪽 클릭으로 몬스터 카드를 인벤토리의 카드 장착 슬롯에 장착하게 함.
	local moncardFrame = ui.GetFrame("monstercardslot");
	local legendcardupgradeFrame = ui.GetFrame("legendcardupgrade")

	if moncardFrame == nil or legendcardupgradeFrame == nil then
		return
	end

	if moncardFrame:IsVisible() == 1 and itemobj.GroupName == "Card" then
		imcSound.PlaySoundEvent("icon_get_down");
		local groupNameStr = itemobj.CardGroupName
		if groupNameStr == "REINFORCE_CARD" then
			ui.SysMsg(ClMsg("LegendReinforceCard_Not_Equip"));
			return
		end

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
			elseif groupNameStr == 'LEG' then
				slotIndex = 12
			end

			for i = 0, 2 do		
				local slot = card_slotset:GetSlotByIndex(i);
				if slot == nil then
					if groupNameStr == 'LEG' then
						ui.SysMsg(ClMsg("LegendCard_Only_One"));
					end
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
	elseif legendcardupgradeFrame : IsVisible() == 1 and (itemobj.GroupName == "Card" or itemobj.ItemType == 'Etc') then
		imcSound.PlaySoundEvent("icon_get_down");
		-- 4를 sharedconst 값으로 빼야함 . 최대 재료 카드 개수
		if itemobj.CardGroupName ~= nil and itemobj.CardGroupName == 'LEG' then
			local slot = GET_CHILD_RECURSIVELY(legendcardupgradeFrame, "LEGcard_slot")
			local icon = slot:GetIcon()
			if icon == nil then
				LEGENDCARD_SET_SLOT(slot, invitem)
				return;
			end

			if icon ~= nil then
				local iconInfo = icon:GetInfo()
				if iconInfo == nil then
					return
				end

				local slotInvItem = session.GetInvItem(iconInfo.ext);
				if slotInvItem ~= nil and slotInvItem ~= invitem then
					LEGENDCARD_SET_SLOT(slot, invitem)
					return;
				end
			end
		end

		local slot = GET_CHILD_RECURSIVELY(legendcardupgradeFrame, "LEGcard_slot")
		local icon = slot:GetIcon()
		local needReinforceItem = "";
		if itemobj.ItemType == 'Etc' then
			if icon == nil then
				return
			end

			local iconInfo = icon:GetInfo();
			if iconInfo == nil then
				return
			end

			local legendCardIconInfo = iconInfo:GetIESID()
			if legendCardIconInfo == nil then
				return
			end

			local legendCardInvItem = GET_ITEM_BY_GUID(legendCardIconInfo)
			if legendCardInvItem == nil then
				return
			end

			local legendCardObj = GetIES(legendCardInvItem : GetObject());
			if legendCardObj == nil then
				return
			end

			local legendCardReinforceList, cnt = GetClassList("legendCardReinforce")
			local legendCardLv = GET_ITEM_LEVEL(legendCardObj)
			for i = 0, cnt - 1 do
				local cls = GetClassByIndexFromList(legendCardReinforceList,i);
				local cardLv = TryGetProp(cls, "CardLevel");
					
				if cardLv == legendCardLv and legendCardObj.CardGroupName ~= nil and legendCardObj.CardGroupName == 'LEG' then
					local needReinforceItem = TryGetProp(cls, 'NeedReinforceItem')
					local needReinforceItemCount = TryGetProp(cls, 'NeedReinforceItemCount')
					local needItemSlot = GET_CHILD_RECURSIVELY(legendcardupgradeFrame, "materialItem_slot")
					local needItemCls = GetClass("Item", needReinforceItem)
					if needItemCls ~= nil and itemobj.ClassName == needReinforceItem then
						SET_SLOT_INVITEM_NOT_COUNT(needItemSlot, invitem)
					end
				end
			end
		end

		--4자리가 꽉찬거니까 메세지 띄우자
		for i = 1, 4 do
			local slot = GET_CHILD_RECURSIVELY(legendcardupgradeFrame, "material_slot"..i)
			local icon = slot:GetIcon()
			if icon == nil then
				LEGENDCARD_MATERIAL_SET_SLOT(slot, invitem);
				return;
			end
		end
	end
end

function REQUEST_SUMMON_BOSS_TX()
	local invFrame = ui.GetFrame("inventory");
	local itemGuid = invFrame:GetUserValue("REQ_USE_ITEM_GUID");
	local invItem = session.GetInvItemByGuid(itemGuid)
	
	if nil == invItem then
		return;
	end
	
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	local stat = info.GetStat(session.GetMyHandle());		
	if stat.HP <= 0 then
		return;
	end
	
	local itemtype = invItem.type;
	local curTime = item.GetCoolDown(itemtype);
	if curTime ~= 0 then
		imcSound.PlaySoundEvent("skill_cooltime");
		return;
	end
	
	item.UseByGUID(invItem:GetIESID());
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
	
	local frame = ui.GetFrame("shop");
	local companionshop = ui.GetFrame('companionshop');
	local housingShopFrame = ui.GetFrame("housing_shop");
	if companionshop:IsVisible() == 1 then
		frame = companionshop:GetChild('foodBox');
	elseif housingShopFrame:IsVisible() == 1 then
		frame = GET_CHILD_RECURSIVELY(housingShopFrame, "gbox_bottom");
	end	

	if frame:IsVisible() == 0 then
		return;
	end

	local groupName = itemobj.GroupName;
	if groupName == 'Money' then
		return;
	end

	local invFrame = ui.GetFrame("inventory");

	if true == IS_TEMP_LOCK(invFrame, invitem) then
		return;
	end

	local Itemclass = GetClassByType("Item", invitem.type);
	local ItemType = Itemclass.ItemType;
	
	local invIndex = invitem.invIndex;
	local baseidcls = GET_BASEID_CLS_BY_INVINDEX(invIndex)
	local typeStr = GET_INVENTORY_TREEGROUP(baseidcls)

	local invGbox = invFrame:GetChild('inventoryGbox');
	local tree_box = invGbox:GetChild('treeGbox_'..typeStr);
	local tree = tree_box:GetChild('inventree_'..typeStr);
	local slotsetname = GET_SLOTSET_NAME(argNum)
	local slotSet = GET_CHILD_RECURSIVELY(tree,slotsetname,"ui::CSlotSet")
	local slot = slotSet:GetSlotByIndex(argNum-1);
	
	local itemProp = geItemTable.GetPropByName(Itemclass.ClassName);
	if itemProp:IsEnableShopTrade() == true then
		if IS_SHOP_SELL(invitem, Itemclass.MaxStack, frame) == 1 then
			-- 상점 Sell Slot으로 다 넘긴다.
			
			if housingShopFrame:IsVisible() == 1 then
				HOUSING_SHOP_SELL(invitem, invitem.count, frame);
			else
				SHOP_SELL(invitem, invitem.count, frame);
			end

			return;
		else
	        ui.SysMsg(ClMsg("CannotSellMore"));
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

function DRAW_TOTAL_VIS(frame, childname, remove)
	local silverAmountStr = GET_TOTAL_MONEY_STR();
	if remove == 1 then
		silverAmountStr = '0';
	end

	local bottomGbox = frame:GetChild('bottomGbox');
	local moneyGbox = bottomGbox:GetChild('moneyGbox');
	local INVENTORY_CronCheck = GET_CHILD_RECURSIVELY(moneyGbox, childname, 'ui::CRichText');
    INVENTORY_CronCheck:SetText('{@st41b}'..GET_COMMAED_STRING(silverAmountStr))
end

function DRAW_MEDAL_COUNT(frame)
	local bottomGbox = frame:GetChild('bottomGbox');
	local medalGbox = bottomGbox:GetChild('medalGbox');
	local medalText = GET_CHILD_RECURSIVELY(medalGbox, 'medalText', 'ui::CRichText');
	local medalFreeTime = GET_CHILD_RECURSIVELY(medalGbox, 'medalFreeTime', 'ui::CRichText');
	local medalGbox_2 = bottomGbox:GetChild('medalGbox_2');
	local premiumTP = GET_CHILD_RECURSIVELY(medalGbox_2, 'premiumTP', 'ui::CRichText');
	
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
	local INVENTORY_CronCheck	= GET_CHILD_RECURSIVELY(frame, childname, 'ui::CRichText');
    INVENTORY_CronCheck:SetText('{@st43}'.. GET_COMMAED_STRING(GET_TOTAL_MONEY_STR()));
end

function ON_CHANGE_INVINDEX(frame, msg, fromInvIndex, toInvIndex)
	local shopFrame = ui.GetFrame("shop");
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
	local liftIcon = ui.GetLiftIcon();
	if liftIcon == nil then
		return;
	end

	local FromFrame	= liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();
	toFrame:SetValue(1);
	if FromFrame == toFrame then
		local parentSlot = liftIcon:GetParent();
		local parentSlotSet = parentSlot:GetParent();
		local frominfo = liftIcon:GetInfo();
		local slot = tolua.cast(control, 'ui::CSlot');
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
			if iconInfo ~= nil and iconInfo.count ~= nil then
				item.TakeItemFromWarehouse(IT_WAREHOUSE, iesID, 1, FromFrame:GetUserIValue("HANDLE"));
			end
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
	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();

	if FromFrame == toFrame then
		local invGbox = toFrame:GetChild('inventoryGbox');
		local itembox_tab = GET_CHILD_RECURSIVELY(invGbox, 'itembox', "ui::CTabControl");
		local curtabIndex = itembox_tab:GetSelectItemIndex();
		local slotSet = GET_CHILD_RECURSIVELY(invGbox, 'throwawayslotlist', 'ui::CSlotSet');
		if curtabIndex == 0 then
			local frominfo = liftIcon:GetInfo();
			local slot = tolua.cast(control, 'ui::CSlot');
			local toicon = slot:GetIcon();
			local fromInvIndex = frominfo.ext;
			local invItem = session.GetInvItem(fromInvIndex);
			if invItem ~= nil then
				if toicon == nil then
					local icon = CreateIcon(slot);
					icon:Set(frominfo:GetImageName(), 'THROWITEM', invItem.type, invItem.count, invItem:GetIESID(), invItem.count);

					slot:SetSlotIndex(invItem.type);
					SET_ITEM_TOOLTIP_TYPE(icon, invItem.type);

					icon:SetTooltipArg('buy', invItem.type, invItem:GetIESID());
					
					local liftSlot = liftIcon:GetParent();
					liftSlot:SetFrontImage('removed_item');

					slot:SetEventScript(ui.RBUTTONDOWN, "INVENTORY_DELETE_ITEM_CANCEL");
					slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, slot:GetSlotIndex());
					slot:SetText('{s18}{ol}{b}'..invItem.count, 'count', ui.RIGHT, ui.BOTTOM, -2, 1);
					local slotSet = INV_GET_SLOTSET_BY_INVINDEX(invItem.invIndex-1)
					local slot = slotSet:GetSlotByIndex(invItem.invIndex - 1);
					local icon = slot:GetIcon();
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
	local invGbox = frame:GetChild('inventoryGbox');
	local slotSet = GET_CHILD_RECURSIVELY(invGbox, 'throwawayslotlist', 'ui::CSlotSet');
	local slotCount = 0; -- 휴지통 제거되었음. 슬롯 생성 안하도록 0셋팅

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
	-- 전체 다 그리면 안된다. 이거 때문에 버그 생기면 하나만 업데이트 하게 처리
	--INVENTORY_TOTAL_LIST_GET(frame);
end

function INV_ICON_SETINFO(frame, slot, invItem, customFunc, scriptArg, count)
	local icon = CreateIcon(slot);
	local class = GetClassByType('Item', invItem.type);
	if class == nil then		
		return;
	end

	local itemobj = GetIES(invItem:GetObject());	
	local imageName = GET_EQUIP_ITEM_IMAGE_NAME(itemobj, 'Icon');
	local itemType = invItem.type;
	ICON_SET_ITEM_COOLDOWN(icon, itemType);	

	local iconImgName  = GET_ITEM_ICON_IMAGE(itemobj);
	icon:Set(iconImgName, 'Item', itemType, invItem.invIndex, invItem:GetIESID(), invItem.count);

	ICON_SET_INVENTORY_TOOLTIP(icon, invItem, nil, class);
	
	local resultLifeTimeOver = IS_LIFETIME_OVER(itemobj);
	if resultLifeTimeOver == 1 then
		icon:SetColorTone("FFFF0000");	
	end
	
	if class.ItemType == 'Equip' then
		local result = CHECK_EQUIPABLE(itemType);
		if result ~= "OK" then
			icon:SetColorTone("FFFF0000");		
		end
			
		if IS_NEED_APPRAISED_ITEM(itemobj) or IS_NEED_RANDOM_OPTION_ITEM(itemobj) then
			icon:SetColorTone("FFFF0000");		
		end
	end	

	SET_SLOT_STYLESET(slot, itemobj, nil, nil, nil, nil, 1)
	local slotFont = frame:GetUserConfig("TREE_SLOT_TEXT_FONT")

	if ui.GetFrame("oblation_sell"):IsVisible() == 1 then
		SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, itemobj, invItem.count, slotFont);
	else
		SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, itemobj, count, slotFont);
	end
	
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
		local controlset = slot:CreateOrGetControlSet('inv_itemlock', "itemlock", 0, 0);
		controlset:SetGravity(ui.RIGHT, ui.TOP)
	elseif true == IS_TEMP_LOCK(frame, invItem) then		
		slot:SetFrontImage('item_Lock');    
	else
		slot:SetFrontImage('None');
		DESTROY_CHILD_BYNAME(slot, "itemlock")
	end

    if invItem.hasLifeTime == true  then
        ICON_SET_ITEM_REMAIN_LIFETIME(icon)
        slot:SetFrontImage('clock_inven');
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

	local slot1 = quickslot.GetSwapWeaponGuid(0);
	local slot2 = quickslot.GetSwapWeaponGuid(1);	
	local slot3 = quickslot.GetSwapWeaponGuid(2);
	local slot4 = quickslot.GetSwapWeaponGuid(3);

	return invItem:GetIESID() == slot1 or invItem:GetIESID() == slot2 or invItem:GetIESID() == slot3 or invItem:GetIESID() == slot4;
end

function STATUS_SLOT_DROP(frame, icon, argStr, argNum)
	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	local toFrame = frame:GetTopParentFrame();
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		ITEM_EQUIP(iconInfo.ext, icon:GetName());
		STATUS_EQUIP_SLOT_SET(toFrame);
	end
end

--머리 보이기/안보이기 아이콘에 의한 염색 버튼 보이기/안보이기
function SET_VISIBLE_DYE_BTN_BY_VISIBLE(frame, IsVisible)	
	local hairColorBtn = GET_CHILD_RECURSIVELY(frame:GetTopParentFrame(), "HAIR_COLOR");
	if hairColorBtn == nil then
		return;
	end

	local pcSession = session.GetMySession()
	if pcSession == nil then
		return
	end
	local apc = pcSession:GetPCDummyApc()

	--뷰티샵 헤어인가
    local etc = GetMyEtcObject();
	local isBeautyshopHair = TryGetProp(etc, "BeautyshopStartHair");

	if IsVisible == 1 then	--보이기 상태
		local Icon = frame:GetIcon();
		if Icon ~= nil then	--무언가 착용중
			hairColorBtn:ShowWindow(1);

			--HAIR slot의 아이템 오브젝트의 카테고리 알아냄
			if apc:GetEquipItem(ES_HELMET) ~= 10000 then	-- Name == Helmet인 헬맷 착용중
				hairColorBtn:ShowWindow(0);
			else		-- Name == Hair인 무언가 착용중
				local slot = tolua.cast(frame, "ui::CSlot");
				local icon = slot:GetIcon();
				local iconInfo = icon:GetInfo();
				local invIteminfo = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
				if invIteminfo ~= nil then
					local itemObj = GetIES(invIteminfo:GetObject())
					if itemObj.MarketCategory == "Look_Helmet" then
						hairColorBtn:ShowWindow(0);
					elseif itemObj.MarketCategory == "Look_Wig" then
						hairColorBtn:ShowWindow(1);
					end
				end
			end
		else --미착용중
			if isBeautyshopHair == "Yes" then
				hairColorBtn:ShowWindow(0);		--뷰티샵
			else
				hairColorBtn:ShowWindow(1);		--기본헤어
			end
		end
	else --안보이기 상태
		if isBeautyshopHair == "Yes" then
			hairColorBtn:ShowWindow(0);		--뷰티샵
		else
			hairColorBtn:ShowWindow(1);		--기본헤어
		end
	end
end

--아이템 착용에 의한 염색 버튼 보이기/안보이기
function SET_VISIBLE_DYE_BTN_BY_ITEM_EQUIP(frame)
	local hairColorBtn = GET_CHILD_RECURSIVELY(frame, "HAIR_COLOR");
	if hairColorBtn == nil then
		return;
	end

	local etc = GetMyEtcObject();
	local hairFrame = GET_CHILD_RECURSIVELY(frame, "HAIR")
	local slot = tolua.cast(hairFrame, "ui::CSlot");
	local icon = slot:GetIcon();
	if icon == nil then	--헤어 미착용중
		local isBeautyshopHair = TryGetProp(etc, "BeautyshopStartHair");
		if isBeautyshopHair == "Yes" then
			hairColorBtn:ShowWindow(0); --뷰티샵
		else
			hairColorBtn:ShowWindow(1); --기본헤어
		end
	else --헤어 착용중
		local iconInfo = icon:GetInfo();
		local invIteminfo = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
		if invIteminfo ~= nil then
			local itemObj = GetIES(invIteminfo:GetObject());
			if itemObj.MarketCategory == "Look_Helmet" then
				hairColorBtn:ShowWindow(0);
			elseif itemObj.MarketCategory == "Look_Wig" then
				hairColorBtn:ShowWindow(1);
			end
			SET_VISIBLE_DYE_BTN_BY_VISIBLE(hairFrame, etc.HAIR_WIG_Visible);
		end
	end
end

--현재 가지고 있는 염색의 종류를 haveHairColorList에 넣음
function CHANGE_HAIR_COLOR(frame)
	local hairColorBtn = GET_CHILD_RECURSIVELY(frame, "HAIR_COLOR");
	if hairColorBtn == nil then
		return;
	end

	local pc = GetMyPCObject()
    local etc = GetMyEtcObject();

	local haveHairColorList = {}
	local haveHairColorEList = {}
	
	local PartClass = imcIES.GetClass("CreatePcInfo", "Hair");
	local GenderList = PartClass:GetSubClassList();
	local Selectclass   = GenderList:GetClass(pc.Gender);
	local Selectclasslist = Selectclass:GetSubClassList();

    local nowHeadIndex = item.GetHeadIndex()
	local nowHairCls = Selectclasslist:GetClass(nowHeadIndex);
	local nowPCHairEngName = imcIES.GetString(nowHairCls, 'EngName'); --현재 내가 '헤어'슬롯에 착용한 아이템

	for i = 0, Selectclasslist:Count() do
		local eachcls = Selectclasslist:GetByIndex(i);
		if eachcls ~= nil then
			local eachHairEngName = imcIES.GetString(eachcls, 'EngName');
			if eachHairEngName == nowPCHairEngName then
				-- eachColor, eachColorE : 게임 내 전체 헤어 컬러(한글이름, 영어이름)
				local eachColor = imcIES.GetString(eachcls, 'Color');	
				local eachColorE = imcIES.GetString(eachcls, 'EngColor');	
				eachColorE = string.lower(eachColorE);
				-- 전체 헤어 컬러 목록에서 유저가 가진 헤어 컬러 목록을 드롭 리스트에 넣음
				if TryGetProp(etc, "HairColor_" .. eachColorE) == 1 then
					haveHairColorList[#haveHairColorList + 1] = eachColor;
					haveHairColorEList[#haveHairColorEList + 1] = eachColorE;
				end
			end
		end
	end	

	SORT_HAIR_COLORLIST(hairColorBtn, haveHairColorList, haveHairColorEList)
	CREATE_HAIR_DYE_DROPLIST(hairColorBtn, haveHairColorList, haveHairColorEList);
end

function IS_CONTAIN_ITEM(tbl, item)
    for key, value in pairs(tbl) do
        if value == item then 
			return key 
		end
    end
    return false
end

--코카트리스 헤드같은 경우 염색 리스트가 바뀌는 버그가 있어 재정렬하고 droplist에 넣어줘야 한다.
function SORT_HAIR_COLORLIST(ctrl, colorKList, colorEList)
	if colorEList == nil then
		return;
	end

	local hairOrder = {"default", "black", "blue", "pink", "white", "blond", "red", "green", "gray", "lightsalmon", "purple", "orange", "brown", "midnightblue"};
	local curPosColorEList = 1;
	local curPosHairOrder = 1;
	while curPosHairOrder < #hairOrder + 1 do
		local idx = IS_CONTAIN_ITEM(colorEList, hairOrder[curPosHairOrder]);

		if idx ~= false then
			if colorEList[curPosColorEList] == hairOrder[curPosHairOrder] then
				curPosColorEList = curPosColorEList + 1;
			else
				if idx ~= curPosColorEList then
					colorEList[curPosColorEList], colorEList[idx] = colorEList[idx], colorEList[curPosColorEList]
					colorKList[curPosColorEList], colorKList[idx] = colorKList[idx], colorKList[curPosColorEList]
					curPosHairOrder = curPosHairOrder - 1;
				end
			end
		end
		curPosHairOrder = curPosHairOrder + 1;
	end
end

function CREATE_HAIR_DYE_DROPLIST(control, colorList, colorEList)
	local dropListFrame = ui.MakeDropListFrame(control, 0, 0, 150, 600, #colorList, ui.LEFT, "SELECT_HAIR_DYE_IN_DROPLIST", nil, nil);
	for i = 0, #colorList do
		ui.AddDropListItem(colorList[i + 1], nil, colorEList[i + 1]);
	end
end

function SELECT_HAIR_DYE_IN_DROPLIST(select, color)
    item.ReqChangeHead(color);
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
		slot:SetText('{s20}{ol}{#FFFFFF}{b}'..lv, 'count', ui.LEFT, ui.TOP, 8, 2);
	else
		slot:ClearText();
	end
end

function SET_EQUIP_SLOT_ITEMGRADE_BG(frame, slot, obj)
	local slotSkinName = ""
	local slot_bg_name = slot:GetName() .. "_bg"
	local slot_bg = GET_CHILD_RECURSIVELY(frame, slot_bg_name)
	local topParent = frame:GetTopParentFrame();
	if topParent:GetName() == "compare" then
		topParent = frame
	end
	local itemgrade = obj.ItemGrade
	if itemgrade ~= nil and itemgrade ~= 0 and itemgrade ~= 1 and itemgrade ~= "None" then
		if itemgrade == 2 then
			slotSkinName = topParent:GetUserConfig("EQUIPSLOT_PIC_MAGIC")
		elseif itemgrade == 3 then
			slotSkinName = topParent:GetUserConfig("EQUIPSLOT_PIC_RARE")
		elseif itemgrade == 4 then
			slotSkinName = topParent:GetUserConfig("EQUIPSLOT_PIC_UNIQUE")
		elseif itemgrade == 5 then
			slotSkinName = topParent:GetUserConfig("EQUIPSLOT_PIC_LEGEND")
		end
		slot_bg:ShowWindow(1)
		slot:SetSkinName(slotSkinName)
	else
		slot:SetSkinName(slot_bg:GetSkinName())
		slot_bg:ShowWindow(0)
	end
end

function SET_EQUIP_SLOT_BY_SPOT(frame, equipItem, eqpItemList, iconFunc, ...) 
	if frame ~= nil then
		frame = frame:GetTopParentFrame();
	end
	
	ui.inventory.InventorySetEquipSlotBySpot(frame:GetName(), equipItem, eqpItemList, iconFunc);
end

function SET_EQUIP_SLOT(frame, i, equipItemList, iconFunc, ...)
	if equipItemList == nil then
		equipItemList = session.GetEquipItemList();
	end

	local equipItem = equipItemList:GetEquipItemByIndex(i);
	SET_EQUIP_SLOT_BY_SPOT(frame, equipItem, equipItemList, iconFunc, ...);	
	
	frame:Invalidate();
end

function SET_EQUIP_LIST_ANIM(frame, equipItemList, iconFunc, ...)
	for i = 0, equipItemList:Count() - 1 do
		local equipItem = equipItemList:GetEquipItemByIndex(i);
		local spotName = item.GetEquipSpotName(equipItem.equipSpot);
		if equipItem.isChangeItem == true then

			if  spotName  ~=  nil  then
			
				if spotName == "HELMET" then
					spotName = "HAIR"
				end

				local child = GET_CHILD_RECURSIVELY(frame, spotName.."ANIM");	

				if  child  ~=  nil  then	
					local slot = tolua.cast(child, 'ui::CAnimPicture');
					local slotGbox = slot:GetParent()
					local tabIndex = 0
					if slotGbox:GetName() == "gbox_Dressed" then
						tabIndex = 1
					end

					local equipTab = GET_CHILD_RECURSIVELY(frame, "equiptype_Tab")
					equipTab:SelectTab(tabIndex)

					slot:PlayAnimation();
				end
			end		
		end
	end
	frame:Invalidate();
end

function SET_EQUIP_LIST(frame, equipItemList, iconFunc, ...)
	local cnt = equipItemList:Count();	
	for i = 0, cnt - 1 do
		local equipItem = equipItemList:GetEquipItemByIndex(i);
		local spotName = item.GetEquipSpotName(equipItem.equipSpot);
		if  spotName  ~=  nil  then		
			if SET_EQUIP_ICON_FORGERY(frame, spotName) == false then
				SET_EQUIP_SLOT(frame, i, equipItemList, "_INV_EQUIP_LIST_SET_ICON");
			end
		end
	end
	frame:Invalidate();
end

function STATUS_EQUIP_SLOT_SET(frame)
	local curChildIndex = 0;
	SET_EQUIP_LIST(frame, session.GetEquipItemList(), "_INV_EQUIP_LIST_SET_ICON");
end

function STATUS_EQUIP_SLOT_SET_ANIM(frame)
	SET_EQUIP_LIST_ANIM(frame, session.GetEquipItemList(), _INV_EQUIP_LIST_SET_ICON);
end

function GET_SLOT_BY_ITEMID(slotSet, itemID, isAll)
	if slotSet == nil then
		slotSet = INV_GET_SLOTSET_BY_ITEMID(itemID, isAll);
	end

	if slotSet == nil then
		return nil;
	end

	return _GET_SLOT_BY_ITEMID(slotSet, itemID);
end

function _GET_SLOT_BY_ITEMID(slotSet, itemID)	
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
s_dropDeleteItemCount = 0;
s_dropDeleteItemName = '';

function INVENTORY_DELETE(itemIESID, itemType)
	if GetCraftState() == 1 then
		return;
	end

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
	if invItem.count > 1 then        
		local titleText = ScpArgMsg("INPUT_CNT_D_D", "Auto_1", 1, "Auto_2", invItem.count);
		s_dropDeleteItemIESID = itemIESID;
		s_dropDeleteItemName = cls.Name;
		local inputstringframe = ui.GetFrame("inputstring");
		inputstringframe:SetUserValue("ITEM_CLASSNAME", cls.ClassName)        
        item_grade = GetIES(invItem:GetObject()).ItemGrade
		INPUT_NUMBER_BOX(invFrame, titleText, "CHECK_EXEC_DELETE_ITEMDROP", 1, 1, invItem.count);
			
	else
		s_dropDeleteItemIESID = itemIESID;
		s_dropDeleteItemCount = 1;
		s_dropDeleteItemName = cls.Name;
        item_grade = GetIES(invItem:GetObject()).ItemGrade
		local yesScp = string.format("EXEC_DELETE_ITEMDROP");
        local clmsg = ScpArgMsg('ReallyDestroy{ITEM}', 'ITEM', s_dropDeleteItemName);
        if item_grade >= 3 then
            clmsg = ScpArgMsg('HighItemGradeReallyDestroy{ITEM}', 'ITEM', s_dropDeleteItemName);
        end
		--ui.MsgBox(clmsg, yesScp, "None");
		WARNINGMSGBOX_FRAME_OPEN(clmsg, yesScp, "None", itemIESID)
	end
	--end
end

function CHECK_EXEC_DELETE_ITEMDROP(count, className)    
	s_dropDeleteItemCount = tonumber(count);
	local yesScp = string.format("EXEC_DELETE_ITEMDROP");
    local clmsg = ScpArgMsg('ReallyDestroy{ITEM}{COUNT}', 'ITEM', s_dropDeleteItemName, 'COUNT', s_dropDeleteItemCount);
    if item_grade >= 3 then
        clmsg = ScpArgMsg('HighItemGradeReallyDestroy{ITEM}{COUNT}', 'ITEM', s_dropDeleteItemName, 'COUNT', s_dropDeleteItemCount);
    end

	--ui.MsgBox(clmsg, yesScp, "None");
	local inputstringframe = ui.GetFrame("inputstring");
	local itemGuid = s_dropDeleteItemIESID
	WARNINGMSGBOX_FRAME_OPEN(clmsg, yesScp, "None", itemGuid)
end

function EXEC_DELETE_ITEMDROP()
	IMC_LOG("INFO_NORMAL", "EXEC_DELETE_ITEMDROP")
	item.DropDelete(s_dropDeleteItemIESID, s_dropDeleteItemCount);
	s_dropDeleteItemIESID = '';
	s_dropDeleteItemCount = 0;
end

function EXP_ORB_SLOT_INVEN_ON_MSG(frame, msg, str, itemType)	
	local timer = GET_CHILD_RECURSIVELY(frame, "exporbtimer", "ui::CAddOnTimer");
	if msg == "EXP_ORB_ITEM_OFF" then
		frame:SetUserValue("EXP_ORB_EFFECT", 0);
		timer:Stop();
		imcSound.PlaySoundEvent('sys_booster_off');
		STOP_INVENTORY_EXP_ORB(frame);
	elseif msg == "EXP_ORB_ITEM_ON" then
		frame:SetUserValue("EXP_ORB_EFFECT", str);
		timer:SetUpdateScript("UPDATE_INVENTORY_EXP_ORB");
		timer:Start(1);
		imcSound.PlaySoundEvent('sys_atk_booster_on');
	end
end

function EXP_SUB_ORB_SLOT_INVEN_ON_MSG(frame, msg, str, itemType)
	local timer = GET_CHILD_RECURSIVELY(frame, "expsuborbtimer", "ui::CAddOnTimer");
	if msg == "EXP_SUB_ORB_ITEM_OFF" then
		frame:SetUserValue("EXP_SUB_ORB_EFFECT", 0);
		timer:Stop();
		imcSound.PlaySoundEvent('sys_booster_off');
		STOP_INVENTORY_EXP_SUB_ORB(frame);
	elseif msg == "EXP_SUB_ORB_ITEM_ON" then
		frame:SetUserValue("EXP_SUB_ORB_EFFECT", str);
		timer:SetUpdateScript("UPDATE_INVENTORY_EXP_SUB_ORB");
		timer:Start(1);
		imcSound.PlaySoundEvent('sys_atk_booster_on');
	end
end

--토글.
function TOGGLE_ITEM_SLOT_INVEN_ON_MSG(frame, msg, argstr, argnum)
	if msg == "TOGGLE_ITEM_SLOT_ON" then
		INVENTORY_TOGGLE_ITEM_LIST[argnum] = 1;
	elseif msg == "TOGGLE_ITEM_SLOT_OFF" then
		INVENTORY_TOGGLE_ITEM_LIST[argnum] = nil;
	end

	local cnt = 0;
	for k, v in pairs(INVENTORY_TOGGLE_ITEM_LIST) do
		cnt = cnt + 1;
	end

	if cnt > 0 then
		local timer = GET_CHILD_RECURSIVELY(frame, "invenontimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_INVENTORY_TOGGLE_ITEM");
		timer:Start(1);
	else
		local timer = GET_CHILD_RECURSIVELY(frame, "invenontimer", "ui::CAddOnTimer");
		timer:Stop();
	end
end

--업데이트.
function UPDATE_INVENTORY_TOGGLE_ITEM(frame)
	if frame:IsVisible() == 0 then
		return;
	end

	local invenTab = GET_CHILD_RECURSIVELY(frame, "inventype_Tab")
	if invenTab == nil then
		return;
	end

	local tabIndex = invenTab:GetSelectItemIndex()
	for type, v in pairs(INVENTORY_TOGGLE_ITEM_LIST) do
		local slot = INV_GET_SLOT_BY_TYPE(type);
		if tabIndex == 0 then
			slot = INV_GET_SLOT_BY_TYPE(type, nil, 1)
		end	
		if slot ~= nil and slot:IsVisible() == 1 then
			local slotset = slot:GetParent();
			if slotset:GetHeight() == 0 then
				return 1;
			end

			local inventoryGbox = GET_CHILD_RECURSIVELY(frame, "inventoryGbox");
			local offset = frame:GetUserConfig("EFFECT_DRAW_OFFSET");
			if slot:GetDrawY() <= invenTab:GetDrawY() or invenTab:GetDrawY() + inventoryGbox:GetHeight() - offset <= slot:GetDrawY() then
				return 1;
			end

			if slot:IsVisibleRecursively() == true then
				slot:PlayUIEffect("I_sys_item_slot", 2.2, "Inventory_TOGGLE_ITEM", true);
			end
		end
	end
	return 1;
end

function JUNGTAN_SLOT_INVEN_ON_MSG(frame, msg, str, itemType)
	if str == 'JUNGTAN_OFF' then
		frame:SetUserValue("JUNGTAN_EFFECT", 0);
		local timer = GET_CHILD_RECURSIVELY(frame, "jungtantimer", "ui::CAddOnTimer");
		timer:Stop();		
	elseif str == 'JUNGTAN_ON' then
		local invItem = session.GetInvItemByType(itemType);
		if invItem == nil then
			return;
		end
		frame:SetUserValue("JUNGTAN_EFFECT", invItem:GetIESID());
		local timer = GET_CHILD_RECURSIVELY(frame, "jungtantimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_INVENTORY_JUNGTAN");
		timer:Start(1);		
	elseif str == 'JUNGTANDEF_OFF' then
		frame:SetUserValue("JUNGTANDEF_EFFECT", 0);
		local timer = GET_CHILD_RECURSIVELY(frame, "jungtandeftimer", "ui::CAddOnTimer");
		timer:Stop();		
	elseif str == 'JUNGTANDEF_ON' then
		frame:SetUserValue("JUNGTANDEF_EFFECT", itemType);
		local timer = GET_CHILD_RECURSIVELY(frame, "jungtandeftimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_INVENTORY_JUNGTANDEF");
		timer:Start(1);		
	elseif str == 'DISPELDEBUFF_ON' then
		frame:SetUserValue("DISPELDEBUFF_EFFECT", itemType);
		local timer = GET_CHILD(frame, "dispeldebufftimer", "ui::CAddOnTimer");
		timer:SetUpdateScript("UPDATE_INVENTORY_DISPEL_DEBUFF");
		timer:Start(1);
		imcSound.PlaySoundEvent('sys_def_booster_on');
	elseif str == 'DISPELDEBUFF_OFF' then
		frame:SetUserValue("DISPELDEBUFF_EFFECT", 0);
		local timer = GET_CHILD(frame, "dispeldebufftimer", "ui::CAddOnTimer");
		timer:Stop();
		imcSound.PlaySoundEvent('sys_booster_off');
	end
end

function UPDATE_INVENTORY_DISPEL_DEBUFF(frame, ctrl, num, str, time)
	if frame:IsVisible() == 0 then
		return;
	end

	local dispelID = tonumber( frame:GetUserValue("DISPELDEBUFF_EFFECT") );
	if dispelID == 0 then
		return;
	end

	local invenTab = GET_CHILD_RECURSIVELY(frame, "inventype_Tab")
	if invenTab == nil then
		return
	end

	local tabIndex = invenTab:GetSelectItemIndex()
	local slot = INV_GET_SLOT_BY_TYPE(dispelID)
	if tabIndex == 0 then
		slot = INV_GET_SLOT_BY_TYPE(dispelID, nil, 1)
	end	
	
	if(slot == nil ) then
		return;
	end

	local slotset = slot:GetParent();
	if slotset:GetHeight() == 0 then
		return;
	end

	local inventoryGbox = GET_CHILD_RECURSIVELY(frame, "inventoryGbox");
	local offset = frame:GetUserConfig("EFFECT_DRAW_OFFSET");
	if slot:GetDrawY() <= invenTab:GetDrawY() or invenTab:GetDrawY() + inventoryGbox:GetHeight() - offset <= slot:GetDrawY() then
		return;
	end	
	
	if slot:IsVisibleRecursively() == true then
		slot:PlayUIEffect("I_sys_item_slot", 2.2, "Inventory_DISPEL_DEBUFF", true);	
	end
end

function UPDATE_INVENTORY_EXP_ORB(frame, ctrl, num, str, time)
	if frame:IsVisible() == 0 then
		return;
	end

	local itemGuid = frame:GetUserValue("EXP_ORB_EFFECT");
	if itemGuid == "None" then
		return;
	end
	
	local invenTab = GET_CHILD_RECURSIVELY(frame, "inventype_Tab")
	if invenTab == nil then
		return
	end

	local tabIndex = invenTab:GetSelectItemIndex()
	local slot = INV_GET_SLOT_BY_ITEMGUID(itemGuid);
	if tabIndex == 0 then
		slot = INV_GET_SLOT_BY_ITEMGUID(itemGuid, nil, 1)
	end	

	if slot == nil then
		return;
	end

	local slotset = slot:GetParent();
	if slotset:GetHeight() == 0 then
		return;
	end

	local inventoryGbox = GET_CHILD_RECURSIVELY(frame, "inventoryGbox");
	local offset = frame:GetUserConfig("EFFECT_DRAW_OFFSET");
	if slot:GetDrawY() <= invenTab:GetDrawY() or invenTab:GetDrawY() + inventoryGbox:GetHeight() - offset <= slot:GetDrawY() then
		return;
	end
	
	if slot:IsVisibleRecursively() == true then
		slot:PlayUIEffect("I_sys_item_slot", 2.2, "Inventory_Exp_ORB", true);	
	end
end

function UPDATE_INVENTORY_EXP_SUB_ORB(frame, ctrl, num, str, time)
	if frame:IsVisible() == 0 then
		return;
	end

	local itemGuid = frame:GetUserValue("EXP_SUB_ORB_EFFECT");
	if itemGuid == "None" then
		return;
	end
	
	local invenTab = GET_CHILD_RECURSIVELY(frame, "inventype_Tab")
	if invenTab == nil then
		return
	end

	local tabIndex = invenTab:GetSelectItemIndex()
	local slot = INV_GET_SLOT_BY_ITEMGUID(itemGuid);
	if tabIndex == 0 then
		slot = INV_GET_SLOT_BY_ITEMGUID(itemGuid, nil, 1)
	end	

	if slot == nil then
		return;
	end

	local slotset = slot:GetParent();
	if slotset:GetHeight() == 0 then
		return;
	end

	local inventoryGbox = GET_CHILD_RECURSIVELY(frame, "inventoryGbox");
	local offset = frame:GetUserConfig("EFFECT_DRAW_OFFSET");
	if slot:GetDrawY() <= invenTab:GetDrawY() or invenTab:GetDrawY() + inventoryGbox:GetHeight() - offset <= slot:GetDrawY() then
		return;
	end
	
	if slot:IsVisibleRecursively() == true then
		slot:PlayUIEffect("I_sys_item_slot", 2.2, "Inventory_Exp_Sub_ORB", true);	
	end
end

function STOP_INVENTORY_EXP_ORB(frame)
	if frame:IsVisible() == 0 then
		return;
	end 

	local itemGuid = frame:GetUserValue("EXP_ORB_EFFECT");
	if itemGuid == "None" then
		return;
	end

	local invenTab = GET_CHILD_RECURSIVELY(frame, "inventype_Tab")
	if invenTab == nil then
		return
	end

	local tabIndex = invenTab:GetSelectItemIndex()
	local slot = INV_GET_SLOT_BY_ITEMGUID(itemGuid);
	if tabIndex == 0 then
		slot = INV_GET_SLOT_BY_ITEMGUID(itemGuid, nil, 1)
	end	

	if slot == nil then
		return;
	end
	
	if slot:IsVisibleRecursively() == true then
		slot:StopUIEffect("Inventory_Exp_ORB", true, 0.0);
	end
end

function STOP_INVENTORY_EXP_SUB_ORB(frame)
	if frame:IsVisible() == 0 then
		return;
	end 

	local itemGuid = frame:GetUserValue("EXP_SUB_ORB_EFFECT");
	if itemGuid == "None" then
		return;
	end

	local invenTab = GET_CHILD_RECURSIVELY(frame, "inventype_Tab")
	if invenTab == nil then
		return
	end

	local tabIndex = invenTab:GetSelectItemIndex()
	local slot = INV_GET_SLOT_BY_ITEMGUID(itemGuid);
	if tabIndex == 0 then
		slot = INV_GET_SLOT_BY_ITEMGUID(itemGuid, nil, 1)
	end	

	if slot == nil then
		return;
	end
	
	if slot:IsVisibleRecursively() == true then
		slot:StopUIEffect("Inventory_Exp_Sub_ORB", true, 0.0);
	end
end

function UPDATE_INVENTORY_JUNGTAN(frame, ctrl, num, str, time)
	if frame:IsVisible() == 0 then
		return;
	end

	local jungtanID = frame:GetUserValue("JUNGTAN_EFFECT");
	if jungtanID == 0 then
		return;
	end

	local invenTab = GET_CHILD_RECURSIVELY(frame, "inventype_Tab")
	if invenTab == nil then
		return
	end

	local tabIndex = invenTab:GetSelectItemIndex()
	local slotSet = INV_GET_SLOTSET_BY_ITEMID(jungtanID)
	if tabIndex == 0 then
		slotSet = INV_GET_SLOTSET_BY_ITEMID(jungtanID, 1)
	end	

	local slot = GET_SLOT_BY_IESID(slotSet, jungtanID);
	if slot == nil then
		return;
	end
	
	local slotset = slot:GetParent();
	if slotset:GetHeight() == 0 then
		return;
	end

	local inventoryGbox = GET_CHILD_RECURSIVELY(frame, "inventoryGbox");
	local offset = frame:GetUserConfig("EFFECT_DRAW_OFFSET");
	if slot:GetDrawY() <= invenTab:GetDrawY() or invenTab:GetDrawY() + inventoryGbox:GetHeight() - offset <= slot:GetDrawY() then
		return;
	end

	if slot:IsVisibleRecursively() == true then
		slot:PlayUIEffect("I_sys_item_slot", 2.2, "Inventory_JUNGTAN", true);	
	end
end

function UPDATE_INVENTORY_JUNGTANDEF(frame, ctrl, num, str, time)
	if frame:IsVisible() == 0 then
		return;
	end

	local jungtanID = tonumber( frame:GetUserValue("JUNGTANDEF_EFFECT") );
	if jungtanID == 0 then
		return;
	end

	local invenTab = GET_CHILD_RECURSIVELY(frame, "inventype_Tab")
	if invenTab == nil then
		return
	end

	local tabIndex = invenTab:GetSelectItemIndex()
	local slot = INV_GET_SLOT_BY_TYPE(jungtanID)
	if tabIndex == 0 then
		slot = INV_GET_SLOT_BY_TYPE(jungtanID, nil, 1)
	end	

	if slot == nil then
		return;
	end

	local slotset = slot:GetParent();
	if slotset:GetHeight() == 0 then
		return;
	end

	local inventoryGbox = GET_CHILD_RECURSIVELY(frame, "inventoryGbox");
	local offset = frame:GetUserConfig("EFFECT_DRAW_OFFSET");
	if slot:GetDrawY() <= invenTab:GetDrawY() or invenTab:GetDrawY() + inventoryGbox:GetHeight() - offset <= slot:GetDrawY() then
		return;
	end
	
	if slot:IsVisibleRecursively() == true then
		slot:PlayUIEffect("I_sys_item_slot", 2.2, "Inventory_JUNGTANDEF", true);	
	end
end

-- slotanim
function INVENTORY_SLOTANIM_CHANGEIMG(frame, key, str, cnt)
	if cnt < 4 then
		return;
	end

	local subStr = string.sub(str, 0, string.len(str) - 4);
	local spot = item.GetEquipSpotNum(subStr);
		
	local child = GET_CHILD_RECURSIVELY(frame, str);
	if  child  ~=  nil  then			
		local slot = tolua.cast(child, 'ui::CAnimPicture');
		slot:ForcePlayAnimationReverse();
		SET_EQUIP_SLOT(frame, spot, nil, "_INV_EQUIP_LIST_SET_ICON")
		
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

	if keyboard.IsKeyPressed("LALT") == 1 then
		ITEM_EQUIP(argNum, "RING2");
		return;
	else
		ITEM_EQUIP(argNum, "RING1");
		return;
	end
end

function SORT_ITEM_INVENTORY()
	local context = ui.CreateContextMenu("CONTEXT_INV_SORT", "", 0, 0, 170, 100);
	local scpScp = "";

	local invFrame = ui.GetFrame("inventory")
	if invFrame == nil then
		return
	end

	local invTab = GET_CHILD_RECURSIVELY(invFrame, "inventype_Tab")
	if invTab == nil then
		return
	end

	if invTab:GetSelectItemName() == "tab_Equip" then
		scpScp = string.format("REQ_INV_SORT(%d, %d)",IT_INVENTORY, BY_LEVEL);
		ui.AddContextMenuItem(context, ScpArgMsg("SortByGrade"), scpScp);	
	elseif invTab:GetSelectItemName() == "tab_Recipe" then
		scpScp = string.format("REQ_INV_SORT(%d, %d)",IT_INVENTORY, BY_LEVEL);
		ui.AddContextMenuItem(context, ScpArgMsg("SortByGrade"), scpScp);	
	elseif invTab:GetSelectItemName() == "tab_Card" then
		scpScp = string.format("REQ_INV_SORT(%d, %d)",IT_INVENTORY, BY_LEVEL);
		ui.AddContextMenuItem(context, ScpArgMsg("SortByLevel"), scpScp);	
	elseif invTab:GetSelectItemName() == "tab_Gem" then
		scpScp = string.format("REQ_INV_SORT(%d, %d)",IT_INVENTORY, BY_LEVEL);
		ui.AddContextMenuItem(context, ScpArgMsg("SortByLevel"), scpScp);	
	elseif invTab:GetSelectItemName() == "tab_Etc" or invTab:GetSelectItemName() == "tab_All" or invTab:GetSelectItemName() == "tab_Consume" then
		scpScp = string.format("REQ_INV_SORT(%d, %d)",IT_INVENTORY, BY_COUNT);
		ui.AddContextMenuItem(context, ScpArgMsg("SortByCount"), scpScp);			
	end

	scpScp = string.format("REQ_INV_SORT(%d, %d)",IT_INVENTORY, BY_WEIGHT);
	ui.AddContextMenuItem(context, ScpArgMsg("SortByWeight"), scpScp);	
	scpScp = string.format("REQ_INV_SORT(%d, %d)",IT_INVENTORY, BY_NAME);
	ui.AddContextMenuItem(context, ScpArgMsg("SortByName"), scpScp);	
	ui.OpenContextMenu(context);
end

function REQ_INV_SORT(invType, sortType)
	local invFrame = ui.GetFrame("inventory")

	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	_invenSortTypeOption[cid] = sortType +1;

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
    if lock_state_check.can_lock(selectItem:GetIESID()) == false then
        ui.SysMsg(ClMsg('selectItemUsed'))
        return
    end

    if reinforce_by_mix.is_reinforce_state() == true then
        ui.SysMsg(ClMsg('CannotUseInReinforceState'))
        return
    end    
    
    clickedLockItemSlot = nil
    local briquetting = ui.GetFrame('briquetting');
    if briquetting:IsVisible() == 1 then
        ui.SysMsg(ScpArgMsg('CannotLock{UI}VisibleState', 'UI', ClMsg('Briquetting')));
        return;
    end

	local itemType = object.ItemType;
	if nil == itemType then
		local obj = GetIES(selectItem:GetObject());
		itemType = obj.ItemType;
	end

	if itemType == "Quest" then
		return;
	end

	local invframe = ui.GetFrame("inventory");
	
	--디스펠러, 오마모리 관련 처리
	local obj = GetIES(selectItem:GetObject());
	if obj.ClassName == "Dispeller_1" or obj.ClassName == 'Bujeok_1' then
		if false == selectItem.isLockState then
			if true == item.UseToggleDispelDebuff() then
				ui.SysMsg(ClMsg("selectItemUsed"));
				return;
			end
		end
	end

    if TryGetProp(obj, 'DisableContents', 0) == 1 then
        ui.SysMsg(ClMsg('CannotReleaseLockByDisableContents'));
        return;
    end

    if IS_TEMP_LOCK(invframe, selectItem) == true then
    	ui.SysMsg(ClMsg('CannotUseInReinforceState'));    	
    	return;
    end

	local state = 1;
	local slot = tolua.cast(object, "ui::CSlot");
    local parent = slot:GetParent();
	local grandParent = parent:GetParent();

	if grandParent ~= nil then
		invframe:SetUserValue('LOCK_SLOT_GRANDPARENT_NAME', grandParent:GetName());	
	end

    invframe:SetUserValue('LOCK_SLOT_PARENT_NAME', parent:GetName());
    invframe:SetUserValue('LOCK_SLOT_NAME', slot:GetName());
	if true == selectItem.isLockState then
		state = 0;
	end
	
	clickedLockItemSlot = slot
	session.inventory.SendLockItem(selectItem:GetIESID(), state);
end

function INV_ITEM_LOCK_SAVE_FAIL(frame, msg, argStr, agrNum)
    local found = false;
	for typeNo = 1, #g_invenTypeStrList do
		local tree = GET_CHILD_RECURSIVELY(frame, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')
		local slotSetNameListCnt = ui.inventory.GetInvenSlotSetNameCount();
		for i = 1, slotSetNameListCnt do
			local getSlotSetName = ui.inventory.GetInvenSlotSetNameByIndex(i - 1);
		    local slotset = GET_CHILD_RECURSIVELY(tree, getSlotSetName, 'ui::CSlotSet');
		    if nil ~= slotset then
			    local slotCount = slotset:GetSlotCount();
			    for i = 0, slotCount - 1 do
				    local slot = slotset:GetSlotByIndex(i );
				    AUTO_CAST(slot);
				    local invItem = GET_SLOT_ITEM(slot);
				    if invItem ~= nil and invItem:GetIESID() == argStr then					    
					    local controlset = slot:CreateOrGetControlSet('inv_itemlock', "itemlock", 0, 0);
					    controlset:SetGravity(ui.RIGHT, ui.TOP);
                        found = true;
					    if 1 == invItem.isLockState then
						    controlset:ShowWindow(1);
					    else
						    controlset:ShowWindow(0);
					    end
				    end

			    end	
		    end
		end
	end

    if found == true then
        ui.SysMsg(ClMsg("ItemLockSaveFail"));
    end
end

function INV_INVENTORY_OPTION_OPEN(frame, msg, argStr, argNum)
	local frame = ui.GetFrame("inventory")
	if frame == nil then
		return
	end

	ui.OpenFrame("inventoryoption")
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

	local equipgroup = GET_CHILD_RECURSIVELY(frame, 'equip', 'ui::CGroupBox')
	local shihouette = GET_CHILD_RECURSIVELY(equipgroup, 'shihouette', "ui::CPicture");
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


function INV_HAIR_WIG_VISIBLE_STATE(frame)
	if frame == nil then
		frame = ui.GetFrame("inventory");
	end
	local hairSlot = GET_CHILD_RECURSIVELY(frame, 'HAIR');
	
	local myPCetc = GetMyEtcObject();

	local hairWig_Visible = myPCetc.HAIR_WIG_Visible
	local hairWig = GET_CHILD_RECURSIVELY(frame, 'HAIR_WIG_Visible')

	if hairWig_Visible == 1 then
		SET_VISIBLE_DYE_BTN_BY_VISIBLE(hairSlot, 1)
		hairWig:SetImage("inven_hat_layer_on");
		hairWig:SetTextTooltip(ScpArgMsg('HAT_ON'))
	else
		SET_VISIBLE_DYE_BTN_BY_VISIBLE(hairSlot, 0)
		hairWig:SetImage("inventory_hat_layer_off");
		hairWig:SetTextTooltip(ScpArgMsg('HAT_OFF'))
	end

	local equipgroup = GET_CHILD_RECURSIVELY(frame, 'equip', 'ui::CGroupBox')
	local shihouette = GET_CHILD_RECURSIVELY(equipgroup, 'shihouette', "ui::CPicture");
	local shihouette_imgname = ui.CaptureMyFullStdImage();
	shihouette:SetImage(shihouette_imgname);

	frame:Invalidate()
end

function INV_HAIR_WIG_VISIBLE_STATE_SET(frame)
	if frame:GetUserIValue("CLICK_COOL_TIME") > imcTime.GetAppTime() then
		return;	
	end

	frame:SetUserValue("CLICK_COOL_TIME", imcTime.GetAppTime() + 1);

	local slotName = frame:GetName()
	local topFrame = frame:GetTopParentFrame()

	local myPCetc = GetMyEtcObject();

	local visibleState = myPCetc["HAIR_WIG_Visible"]
	if visibleState == 1 then
		myPCetc["HAIR_WIG_Visible"] = 0;
	else
		myPCetc["HAIR_WIG_Visible"] = 1
	end

	local visibleBtnInfo = GET_CHILD_RECURSIVELY(frame, "HAIR_WIG_Visible")

	if visibleState == 1 then
		SET_VISIBLE_DYE_BTN_BY_VISIBLE(frame, 0);	--염색 버튼 보이기/숨기기
		visibleBtnInfo:SetImage("inven_hat_layer_on");
		ui.ChangeTooltipText(ScpArgMsg('HAT_OFF'))
	else
		SET_VISIBLE_DYE_BTN_BY_VISIBLE(frame, 1);	--염색 버튼 보이기/숨기기
		visibleBtnInfo:SetImage("inventory_hat_layer_off");
		ui.ChangeTooltipText(ScpArgMsg('HAT_ON'))
	end

	control.CustomCommand("HAIR_WIG_VISIBLE_STATE",0);
end

-- 기간제 아이템 판별 함수
function IS_LIFETIME_OVER(itemobj)
	if itemobj.LifeTime == nil then
		return 0;
	elseif 0 ~= tonumber(itemobj.LifeTime) then		
		-- 기간에 따라 정하기
		local sysTime = geTime.GetServerSystemTime();
		local endTime = imcTime.GetSysTimeByStr(itemobj.ItemLifeTime);
		local difSec = imcTime.GetDifSec(endTime, sysTime);		
		
		-- 기간만료 일 경우에
		if 0 > difSec then
			return 1;
		end;
		
		-- ItemLifeTimeOver으로 검사하는 함수		
		if 0 ~= itemobj.ItemLifeTimeOver then
			return 1;
		end;
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
		local guid = quickslot.GetSwapWeaponGuid(i);
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

	if frame:GetUserIValue('CURRENT_WEAPON_INDEX') == 0 then
		if curIndex == 0 or curIndex == 1 then
			frame : SetUserValue('CURRENT_WEAPON_INDEX', 1)
			weaponSwap1 : SetImage(WEAPONSWAP_UP_IMAGE);
			weaponSwap2:SetImage(WEAPONSWAP_DOWN_IMAGE);
		elseif curIndex == 2 or curIndex == 3 then
			frame : SetUserValue('CURRENT_WEAPON_INDEX', 2)
			weaponSwap2 : SetImage(WEAPONSWAP_UP_IMAGE);
			weaponSwap1:SetImage(WEAPONSWAP_DOWN_IMAGE);
		end
	elseif frame:GetUserIValue('CURRENT_WEAPON_INDEX') == 1 then
		DO_WEAPON_SWAP(frame, 1)
	elseif frame:GetUserIValue('CURRENT_WEAPON_INDEX') == 2 then
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
    if quickslot.IsDoingWeaponSwap() == true then
        return
    end

	if index == nil then
		index = 1
	end

	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end
    g_weapon_swap_request_index = index    	

    local frame = ui.GetFrame("inventory");
    local weaponSwap1 = GET_CHILD_RECURSIVELY(frame, "weapon_swap_1")
	local weaponSwap2 = GET_CHILD_RECURSIVELY(frame, "weapon_swap_2")
	local WEAPONSWAP_UP_IMAGE = frame:GetUserConfig('WEAPONSWAP_UP_IMAGE')
	local WEAPONSWAP_DOWN_IMAGE = frame:GetUserConfig('WEAPONSWAP_DOWN_IMAGE')

	if index == 1 then
		weaponSwap1:SetImage(WEAPONSWAP_UP_IMAGE);
		weaponSwap2:SetImage(WEAPONSWAP_DOWN_IMAGE);
	elseif index == 2 then
		weaponSwap1:SetImage(WEAPONSWAP_DOWN_IMAGE);
		weaponSwap2:SetImage(WEAPONSWAP_UP_IMAGE);
	end

	if frame:GetUserIValue('CURRENT_WEAPON_INDEX') == index then
		return;
	end

	frame:SetUserValue('CURRENT_WEAPON_INDEX', index);

    quickslot.SwapWeapon()    

    local abil = GetAbility(pc, "SwapWeapon");

	if abil ~= nil then
		weaponSwap1:ShowWindow(1);
		weaponSwap2:ShowWindow(1);
	else
		weaponSwap1:ShowWindow(0);
		weaponSwap2:ShowWindow(0);
	end
    
	local tempIndex = 0;
	if index == 1 then
		tempIndex = 2
	elseif index == 2 then
		tempIndex = 0
	end

	SHOW_WEAPON_SWAP_TEMP_IMAGE(frame:GetUserIValue('CURRENT_WEAPON_RH'), frame:GetUserIValue('CURRENT_WEAPON_LH'), tempIndex)
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

function INVENTORY_RBTN_LEGENDPREFIX(invItem)
	local legendprefix = ui.GetFrame('legendprefix');
	if legendprefix ~= nil and legendprefix:IsVisible() == 0 then
		return false;
	end
	LEGENDPREFIX_SET_ITEM(legendprefix, invItem:GetIESID());
	return true;
end

function INVENTORY_RBTN_MARKET_SELL(invitem)
	local market_sell = ui.GetFrame('market_sell');
	if market_sell ~= nil and market_sell:IsVisible() == 0  then
		return false;		
	end
	MARKET_SELL_RBUTTON_ITEM_CLICK(market_sell, invitem);
	return true;
end

function INVENTORY_RBTN_LEGENDDECOMPOSE(invItem)
	local legenddecompose = ui.GetFrame('legenddecompose');
	if legenddecompose ~= nil and legenddecompose:IsVisible() == 0 then
		return false;
	end
	_LEGENDDECOMPOSE_SET_TARGET(legenddecompose, invItem:GetIESID());
	return true;
end

local function _UPDATE_LOCK_STATE(guid, slot, lockState)	
	local frame = ui.GetFrame("inventory")
	local function _SET_LOCK_IMAGE(slot, lockState)
		local controlset = slot:CreateOrGetControlSet('inv_itemlock', "itemlock", 0, 0);		
		controlset:SetGravity(ui.RIGHT, ui.TOP)
		controlset:ShowWindow(lockState);
	end

	if slot ~= nil then
		_SET_LOCK_IMAGE(slot, lockState);
	else
		local invSlot = INVENTORY_GET_SLOT_BY_IESID(frame, guid)
		local invSlot_All = INVENTORY_GET_SLOT_BY_IESID(frame, guid, 1)	
		if invSlot == nil or invSlot_All == nil then		
			return;
		end
		_SET_LOCK_IMAGE(invSlot, lockState);
		_SET_LOCK_IMAGE(invSlot_All, lockState);
	end
end

function ON_UPDATE_LOCK_STATE(frame, msg, itemGuid, lockState)
	local equipSlot = GET_PC_EQUIP_SLOT_BY_ITEMID(itemGuid);
	_UPDATE_LOCK_STATE(itemGuid, equipSlot, lockState);
end

function ON_UPDATE_TRUST_POINT(frame, msg, argStr, trustPoint)
	local frame = ui.GetFrame("inventory")
	if frame == nil then
		return
	end

	local trustPointGbox = GET_CHILD_RECURSIVELY(frame, 'trustPointGbox');
	local trustPointImg = GET_CHILD_RECURSIVELY(trustPointGbox, "trustPointImg");
	local trustPointText = GET_CHILD_RECURSIVELY(trustPointGbox, "trustPointText");
	if trustPointImg == nil or trustPointText == nil then
		return
	end

	trustPoint = math.min(trustPoint + 1, 6);
	trustPointImg:SetImage("icon_credit_grade_" .. trustPoint);
	trustPointText:SetTextByKey("trustPoint", trustPoint - 1);
	trustPointGbox:SetTooltipType('trust_point');
	trustPointGbox:SetTooltipOverlap(1);
end

function SELECT_INVENTORY_TAB(frame, tabIndex)
	local inventype_Tab = GET_CHILD_RECURSIVELY(frame, 'inventype_Tab');
	inventype_Tab:SelectTab(tabIndex);
end

function INVENTORY_CLEAR_SELECT(frame)
	if frame == nil then
		frame = ui.GetFrame('inventory');
	end
	
	local slotSetNameListCnt = ui.inventory.GetInvenSlotSetNameCount();
	for i = 1, slotSetNameListCnt do
		local group = GET_CHILD_RECURSIVELY(frame, 'inventoryGbox', 'ui::CGroupBox')		
		for typeNo = 1, #g_invenTypeStrList do
			local tree_box = GET_CHILD_RECURSIVELY(group, 'treeGbox_'.. g_invenTypeStrList[typeNo],'ui::CGroupBox')
			local tree = GET_CHILD_RECURSIVELY(tree_box, 'inventree_'.. g_invenTypeStrList[typeNo],'ui::CTreeControl')
			
			local slotSetName = ui.inventory.GetInvenSlotSetNameByIndex(i - 1);
			local slotSet = GET_CHILD_RECURSIVELY(tree, slotSetName, 'ui::CSlotSet');		
			if slotSet ~= nil then
				slotSet:ClearSelectedSlot();				
			end
		end
	end
end


function INVENTORY_CATEGORY_OPENCHECK(frame, tree)
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();

	if _invenCatOpenOption[cid] then
		for key, value in pairs(_invenCatOpenOption[cid]) do
			local strFind = ":"
			local strFindStart, strFindEnd = string.find(key, strFind)
			local treename = string.sub(key, 0, strFindStart - 1) 

			if treename == tree:GetName() then			
				local strSub = string.sub(key, strFindStart + 1, string.len(key)) 
				local groupName = 'sset_'..strSub;
				local treegroup = tree:FindByName(groupName);
				if treegroup == 0 then
					return;
				end
		
				if value == 0 then
					local tab = GET_CHILD_RECURSIVELY(frame, treename)
		
					local sloatName = 'ssettitle_'..strSub;
					local ctrl = GET_CHILD_RECURSIVELY(tab, sloatName);	
					if ctrl == nil then
						return;
					end
		
					local slotset = GET_CHILD_RECURSIVELY(tab, groupName)
					if slotset == nil then
						return
					end
			
					local width = slotset:GetWidth();
					local height = slotset:GetHeight();
		
					if width ~= 0 and height ~= 0 then		
						slotset:SetUserValue("width", width)
						slotset:SetUserValue("height", height)
						slotset:Resize(0, 0)
						local title = ctrl:GetText()
						local changeTitle = string.gsub(title, "btn_minus", "btn_plus")
						ctrl:SetText(changeTitle)
					end
				end
			end
		end
	end

	local groupNameListCnt = ui.inventory.GetInvenGroupNameCount();
	for i = 1, groupNameListCnt do
		local groupName = ui.inventory.GetInvenGroupNameByIndex(i - 1);
		local treegroup = tree:FindByValue(groupName);
		if treegroup ~= nil then
			local treenode = tree:GetNodeByTreeItem(treegroup)
			
			if treenode ~= nil then
				local OptionName = tree:GetName()..":"..treenode:GetValue();

				if _invenTreeOpenOption[cid] then
					if _invenTreeOpenOption[cid][OptionName] == false then
						tree:OpenNode(treenode, false, true);
					end
				end
			end
		end
	end	
end

function INVENTORY_CATEGORY_OPENOPTION_CHECK(treename, strarg)
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local OptionName = treename..":"..strarg;

	if _invenCatOpenOption[cid] == nil then
		_invenCatOpenOption[cid] = {};
	end

	return _invenCatOpenOption[cid][OptionName];
end

function INVENTORY_CATEGORY_OPENOPTION_CHANGE(parent, ctrl, strarg, numarg)
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local OptionName = parent:GetName()..":"..strarg;

	if _invenCatOpenOption[cid] == nil then
		_invenCatOpenOption[cid] = {};
	end

	if _invenCatOpenOption[cid][OptionName] == 1 or _invenCatOpenOption[cid][OptionName] == nil then
		_invenCatOpenOption[cid][OptionName] = 0;
	else
		_invenCatOpenOption[cid][OptionName] = 1;
	end
end

function INVENTORY_TREE_OPENOPTION_CHANGE(parent, ctrl, strarg, numarg)
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();

	local groupNameListCnt = ui.inventory.GetInvenGroupNameCount();
	for i = 1, groupNameListCnt do
		local groupName = ui.inventory.GetInvenGroupNameByIndex(i - 1);
		local treegroup = ctrl:FindByValue(groupName);
		if treegroup == nil then
			return;
		end

		local treenode = ctrl:GetNodeByTreeItem(treegroup)
		if treenode ~= nil then
			local openoption = treenode:GetIsOpen();

			local OptionName = ctrl:GetName()..":"..treenode:GetValue();

			if _invenTreeOpenOption[cid] == nil then
				_invenTreeOpenOption[cid] = {};
			end
			_invenTreeOpenOption[cid][OptionName] = openoption;
		end
	end
end

function BEFORE_APPLIED_NON_EQUIP_ITEM_OPEN(invItem)	
	if invItem == nil then
		return;
	end

	local invFrame = ui.GetFrame("inventory");	
	local itemobj = GetIES(invItem:GetObject());
	if itemobj == nil then
		return;
	end
	invFrame:SetUserValue("REQ_USE_ITEM_GUID", invItem:GetIESID());
	
	if itemobj.Script == 'SCR_SUMMON_MONSTER_FROM_CARDBOOK' then
		local textmsg = string.format("[ %s ]{nl}%s", itemobj.Name, ScpArgMsg("Card_Summon_check_Use"));
		ui.MsgBox_NonNested(textmsg, itemobj.Name, "REQUEST_SUMMON_BOSS_TX", "None");
		return;
	elseif itemobj.Script == 'SCR_QUEST_CLEAR_LEGEND_CARD_LIFT' then
		local textmsg = string.format("[ %s ]{nl}%s", itemobj.Name, ScpArgMsg("Use_Item_LegendCard_Slot_Open2"));
		ui.MsgBox_NonNested(textmsg, itemobj.Name, "REQUEST_SUMMON_BOSS_TX", "None");
		return;
	end
end

function BEFORE_APPLIED_YESSCP_OPEN(invItem)
	if invItem == nil then
		return;
	end
	
	local invFrame = ui.GetFrame("inventory");	
	local itemobj = GetIES(invItem:GetObject());
	if itemobj == nil then
		return;
	end
	invFrame:SetUserValue("REQ_USE_ITEM_GUID", invItem:GetIESID());
	
	local strLang = TryGetProp(itemobj , 'StringArg')
	if strLang ~='None' then
    	local textmsg = string.format("[ %s ]{nl}%s", itemobj.Name, ScpArgMsg(strLang));
    	ui.MsgBox_NonNested(textmsg, itemobj.Name, 'REQUEST_SUMMON_BOSS_TX', "None");
    end
	return;
end

function REQUEST_USE_ITEM_TX()
	local invFrame = ui.GetFrame("inventory");
	local itemGuid = invFrame:GetUserValue("REQ_USE_ITEM_GUID");
	local invItem = session.GetInvItemByGuid(itemGuid)
	
	if nil == invItem then
		return;
	end
	
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	local stat = info.GetStat(session.GetMyHandle());		
	if stat.HP <= 0 then
		return;
	end
	
	local itemtype = invItem.type;
	local curTime = item.GetCoolDown(itemtype);
	if curTime ~= 0 then
		imcSound.PlaySoundEvent("skill_cooltime");
		return;
	end
	
	item.UseByGUID(invItem:GetIESID());
end

function BEFORE_APPLIED_GESTURE_YESSCP_OPEN(invItem)
	if invItem == nil then
		return;
	end
	
	local invFrame = ui.GetFrame("inventory");	
	local itemobj = GetIES(invItem:GetObject());
	if itemobj == nil then
		return;
	end
	invFrame:SetUserValue("REQ_USE_ITEM_GUID", invItem:GetIESID());
	
	local strLang = TryGetProp(itemobj , 'StringArg')
	if strLang ~='None' then
    	local textmsg = string.format("[ %s ]{nl}%s", itemobj.Name, ScpArgMsg("Gesture_"..strLang));
    	ui.MsgBox_NonNested(textmsg, itemobj.Name, 'REQUEST_SUMMON_BOSS_TX', "None");
    end
	return;
end

function BEFORE_APPLIED_CAHT_BALLOON_YESSCP_OPEN(invItem)
	if invItem == nil then
		return;
	end
	
	local invFrame = ui.GetFrame("inventory");	
	local itemobj = GetIES(invItem:GetObject());
	if itemobj == nil then
		return;
	end
	invFrame:SetUserValue("REQ_USE_ITEM_GUID", invItem:GetIESID());
	
	local strLang = TryGetProp(itemobj , 'StringArg')
	local numLang = TryGetProp(itemobj , 'NumberArg1')
	if strLang ~='None' then
		local textmsg = string.format("[ %s ]{nl}", itemobj.Name);
		
		local skinData = session.chatballoonskin.GetChatBalloonSkinDataByClassName(strLang);
		if skinData ~= nil then
			if skinData.endTime.wYear ~= 2999 then
				-- 기간제인 해당 말풍선 스킨 보유
				if numLang ~= 0 then
					-- 기간제 아이템 사용
					textmsg = textmsg .. ScpArgMsg("ChatBalloon_YESSCP_message2");
				else
					-- 무제한 아이템 사용
					textmsg = textmsg .. ScpArgMsg("ChatBalloon_YESSCP_message4");
				end
			else
				-- 무제한인 해당 말풍선 스킨 보유
				ui.SysMsg(ScpArgMsg("ChatBalloon_YESSCP_message3"));
				return;
			end
		else
			-- 보유하지 않은 말풍선 스킨 아이템 사용
			textmsg = textmsg .. ScpArgMsg("ChatBalloon_YESSCP_message1");
		end
		
		textmsg = textmsg .. ScpArgMsg("ChatBalloon_YESSCP_message5");
    	ui.MsgBox_NonNested(textmsg, itemobj.Name, 'REQUEST_SUMMON_BOSS_TX', "None");
    end
	return;
end