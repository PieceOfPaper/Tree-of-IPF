
function EXCHANGEANTIQUE_ON_INIT(addon, frame)
	addon:RegisterMsg("MSG_EXCHANGE_ANTIQUE", "EXCHANGEANTIQUE_MSG");
	addon:RegisterMsg("MSG_CLEAR_EXCHANGE_ANTIQUE", "CLEAR_EXCHANGEANTIQUE_UI");
end

function EXCHANGEANTIQUE_MSG(frame, msg, argStr, argNum)
	if msg == "MSG_EXCHANGE_ANTIQUE" then
		CLEAR_EXCHANGEANTIQUE_UI();
		UPDATE_EXCHANGEANTIQUE_UI_BY_MSG(frame);
	end
end

function EXCHANGEANTIQUE_OPEN(frame)
	ui.OpenFrame("inventory");
	INVENTORY_SET_CUSTOM_RBTNDOWN("EXCHANGEANTIQUE_INV_RBTN");
	CLEAR_EXCHANGEANTIQUE_UI();
end

function EXCHANGEANTIQUE_CLOSE(frame)
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
end

local function _ADD_ITEM_TO_EXCHANGEANTIQUE_FROM_INV(frame, item)
	local mode = frame:GetUserIValue('CARE_MODE');
	if mode == 0 then
		if item.ItemGrade ~= 5 and item.GroupName ~= Armor then
			return;
		end
	else
		if TryGetProp(item, 'Rebuildchangeitem', 0) == 0 then			
			ui.SysMsg(ClMsg('WrongDropItem'));
			return;
		end
	end
	
	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end
	
	session.ResetItemList();

	local isAbleExchange = 1;
	local itemClass = GetClassByType("Item", item.ClassID);
	local exchangeAntique = GET_EXCHANGE_ANTIQUE_INFO(item.ClassName);
	if exchangeAntique == nil then
		return;
	end

	if item.ItemType ~= 'Equip' then
		ui.MsgBox(ScpArgMsg("IMPOSSIBLE_ITEM"))
		return;
	end

	local id = GetIESID(item);
	local invItem = session.GetInvItemByGuid(id);
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local frame = ui.GetFrame("exchangeantique");
	frame:SetUserValue("CURRENT_ITEM_GUID", id)
	local STAR_SIZE = frame:GetUserConfig("STAR_SIZE")
	local NEGATIVE_COLOR = frame:GetUserConfig("NEGATIVE_COLOR")
	local POSITIVE_COLOR = frame:GetUserConfig("POSITIVE_COLOR")

	local select_item_pic = GET_CHILD_RECURSIVELY(frame, "select_item_pic", "ui::CPicture");
	select_item_pic:SetImage(item.Icon)

	local select_item_text = GET_CHILD_RECURSIVELY(frame, "select_item_text", "ui::CRichText");
	select_item_text:SetText(GET_FULL_NAME(item));

	local bodyGbox_midle = GET_CHILD_RECURSIVELY(frame, 'bodyGbox_middle');
	local bodyGbox2 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2');
	
	local draw_division_arrow = bodyGbox2:CreateOrGetControlSet('draw_division_arrow', 'DIVISION_ARROW', 12, 0);
	local division_arrow = GET_CHILD_RECURSIVELY(draw_division_arrow, "division_arrow");

	local exchangeItemSlot = #exchangeAntique.ExchangeItemList;	
	
	local materialItemSlot = #exchangeAntique.MatItemList;
	for i = 1, #exchangeAntique.MatItemList do
		local materialClsCtrl = bodyGbox2:CreateOrGetControlSet('eachmaterial_in_exchangeantique', 'EXCHANGE_ANTIQUE_CSET_'..i, 20, (i - 1) * 40);
		local material_icon = GET_CHILD_RECURSIVELY(materialClsCtrl, "material_icon", "ui::CPicture");
		local material_questionmark = GET_CHILD_RECURSIVELY(materialClsCtrl, "material_questionmark", "ui::CPicture");
		local material_name = GET_CHILD_RECURSIVELY(materialClsCtrl, "material_name", "ui::CRichText");
		local material_count = GET_CHILD_RECURSIVELY(materialClsCtrl, "material_count", "ui::CRichText");
		local gradetext2 = GET_CHILD_RECURSIVELY(materialClsCtrl, "grade", "ui::CRichText");
	
		material_count:ShowWindow(1)

		local itemName = ScpArgMsg('NotDecidedYet')

		local itemIcon = 'question_mark'
		material_icon:ShowWindow(1)
		material_questionmark : ShowWindow(0)

		local materialCls = GetClass("Item", exchangeAntique.MatItemList[i].Name);		
		if materialCls ~= nil and exchangeAntique.MatItemList[i].Count > 0 then
			if i - 1 < materialItemSlot then
				materialClsCtrl : ShowWindow(1)
				itemIcon = materialCls.Icon;
				itemName = materialCls.Name;
				local itemCount = GetInvItemCount(pc, materialCls.ClassName)

				local type = item.ClassID;

				if itemCount < exchangeAntique.MatItemList[i].Count then
					material_count:SetTextByKey("color", "{#EE0000}");
					isAbleExchange = 0;
				else 
					material_count:SetTextByKey("color", nil);
				end
				material_count:SetTextByKey("curCount", itemCount);
				material_count:SetTextByKey("needCount", exchangeAntique.MatItemList[i].Count)
					
				session.AddItemID(materialCls.ClassID, exchangeAntique.MatItemList[i].Count);
	
				material_count: ShowWindow(1)
			else
				materialClsCtrl : ShowWindow(0)
			end
			material_icon : SetImage(itemIcon)
			material_name : SetText(itemName)
		end
	end

	local showCnt = 0;
	for i = 1, #exchangeAntique.ExchangeItemList do
		local itemCls = GetClass("Item", exchangeAntique.ExchangeItemList[i]);
		if IS_ENABLE_EXCHANGE_ANTIQUE(item, itemCls) == true then
			local itemClsCtrl = bodyGbox_midle:CreateOrGetControlSet('eachitem_in_exchangeantique', 'EXCHANGE_ANTIQUE_CSET_'..showCnt , 0, showCnt*90);
			local item_icon = GET_CHILD_RECURSIVELY(itemClsCtrl,"item_icon","ui::CPicture");
			local item_questionmark = GET_CHILD_RECURSIVELY(itemClsCtrl,"item_questionmark","ui::CPicture");
			local item_name = GET_CHILD_RECURSIVELY(itemClsCtrl,"item_name","ui::CRichText");
			local itemName = ScpArgMsg('NotDecidedYet')
			
			local itemIcon = 'question_mark'
			item_icon:ShowWindow(1)
			item_questionmark:ShowWindow(0)
			
			itemClsCtrl:SetUserValue('ITEM_ID', itemCls.ClassID);
			if showCnt < exchangeItemSlot then
				itemClsCtrl : ShowWindow(1)

				itemIcon = itemCls.Icon;
				itemName = GET_LEGEND_PREFIX_ITEM_NAME(itemCls, TryGetProp(item, 'LegendPrefix', 'None'));
				local radioBtn = GET_CHILD(itemClsCtrl, 'radioBtn', 'ui::CRadioButton');
				radioBtn:SetCheck(false);
				radioBtn:ShowWindow(1)
					
			else
				itemClsCtrl : ShowWindow(0)
			end
		
			item_icon:SetImage(itemIcon)
			item_name:SetText(itemName)
			showCnt = showCnt + 1;
		end
	end
	frame:SetUserValue('MAX_EXCHANGEITEM_CNT', showCnt);
	
	local button_exchange_antique = GET_CHILD_RECURSIVELY(frame, 'button_exchange_antique', 'ui::CButton')
	
	frame:SetUserValue("IS_ABLE_EXCHANGE", isAbleExchange);
	
	button_exchange_antique:SetEventScript(ui.LBUTTONUP, "CLICK_EXCHANGE_BUTTON");
end

function EXCHANGEANTIQUE_DROP(frame, icon, argStr, argNum)
	local liftIcon = ui.GetLiftIcon();
	local FromFrame = liftIcon:GetTopParentFrame();
	frame = frame:GetTopParentFrame();
	if FromFrame:GetName() == 'inventory' then
		local iconInfo = liftIcon:GetInfo();
		local guid = iconInfo:GetIESID();
		local invItem = GET_ITEM_BY_GUID(guid);
		local obj = GetIES(invItem:GetObject());
		_ADD_ITEM_TO_EXCHANGEANTIQUE_FROM_INV(frame, obj);
	end
end

function EXCHANGEANTIQUE_INV_RBTN(itemobj, slot)
	CLEAR_EXCHANGEANTIQUE_UI();
	_ADD_ITEM_TO_EXCHANGEANTIQUE_FROM_INV(ui.GetFrame('exchangeantique'), itemobj);
end

function CLEAR_EXCHANGEANTIQUE_UI()

	local frame = ui.GetFrame("exchangeantique");

	local select_item_pic = GET_CHILD_RECURSIVELY(frame, "select_item_pic", "ui::CPicture");
	select_item_pic:SetImage('socket_slot_bg')

	local select_item_text = GET_CHILD_RECURSIVELY(frame, "select_item_text", "ui::CRichText");
	select_item_text:SetText(ScpArgMsg('DropItemPlz'))

	local bodyGbox_midle = GET_CHILD_RECURSIVELY(frame, 'bodyGbox_middle');
	bodyGbox_midle:RemoveAllChild();

	local bodyGbox2 = GET_CHILD_RECURSIVELY(frame, 'bodyGbox2');
	bodyGbox2:RemoveAllChild();

	frame:SetUserValue("NOW_SELECT_ITEM_ID",0);
	frame:SetUserValue("IS_ABLE_EXCHANGE", 1);

	local button_exchange_antique = GET_CHILD_RECURSIVELY(frame, 'button_exchange_antique', 'ui::CButton')
end

function UPDATE_EXCHANGEANTIQUE_UI_BY_MSG(frame)
	local tempiesid = frame:GetUserValue("TEMP_IESID");	
	if tempiesid == nil then
		return;
	end

	local item = GetObjectByGuid(tempiesid);
	_ADD_ITEM_TO_EXCHANGEANTIQUE_FROM_INV(frame, item);
end

function CLICK_EXCHANGEANTIQUE_RADIOBTN(parent)
	local frame = ui.GetFrame("exchangeantique");
	local radioBtn = parent:GetChild('radioBtn');
	
	local MAX_EXCHANGEITEM_CNT = frame:GetUserIValue('MAX_EXCHANGEITEM_CNT');
	for i = 0, MAX_EXCHANGEITEM_CNT - 1 do
		local ctrlset = GET_CHILD_RECURSIVELY(frame, 'EXCHANGE_ANTIQUE_CSET_'..i);
		local _radioBtn = GET_CHILD(ctrlset, 'radioBtn', 'ui::CRadioButton');
		if _radioBtn ~= radioBtn then
			_radioBtn:SetCheck(false);
		else
			radioBtn:SetCheck(true);
			frame:SetUserValue('NOW_SELECT_ITEM_ID', ctrlset:GetUserIValue('ITEM_ID'));			
		end
	end
end

local function _GET_CHANGED_OPTION_STR(item, invItem)
	local str = '';
	local baseCls = GetClass('Item', item.ClassName);
	local checkPropList = GET_COPY_TARGET_OPTION_LIST();
	for i = 1, #checkPropList do
		if TryGetProp(baseCls, checkPropList[i]) ~= TryGetProp(item, checkPropList[i]) then
			if str ~= '' then
				str = str..', ';
			end
			if IsExistMsg(checkPropList[i]) == 1 then
				str = str..ClMsg(checkPropList[i]);
			end
		end
	end

	for i = 0, item.MaxSocket - 1 do
		if invItem:IsAvailableSocket(i) == true then
			if str ~= '' then
				str = str..', ';
			end
			str = str..ClMsg('Gem');
			break;
		end
	end
	if str ~= '' then
		str = '['..str..'] ';
	end	
	return str;
end

function CLICK_EXCHANGE_BUTTON()
	local frame = ui.GetFrame("exchangeantique");
	local tempSelectedItemIndex = frame:GetUserIValue('NOW_SELECT_ITEM_ID')
	local tempSelectedItemCount = tempSelectedItemIndex .. "_cnt"
	local isAbleExchange = frame:GetUserIValue("IS_ABLE_EXCHANGE")
			
	if tempSelectedItemIndex == 0 then
		ui.SysMsg(ScpArgMsg("SelectItem"))
		return;
	end
		
	if isAbleExchange == 0 then
		ui.SysMsg(ScpArgMsg("NotEnoughRecipe"))
		return;
	end
	
	local id = frame:GetUserValue("CURRENT_ITEM_GUID");
	local invItem = session.GetInvItemByGuid(id);
	if invItem == nil then
		return;
	end
	local targetItem = GetIES(invItem:GetObject());
	local str = ScpArgMsg('AntiqueExchange{OPTIONS}', 'OPTIONS', _GET_CHANGED_OPTION_STR(targetItem, invItem));
	if frame:GetUserIValue('CARE_MODE') == 1 then
		str = str..'{nl}'..ClMsg('CanExchangeOnlyOnce');		
	end
	local yesScp = string.format("CHECK_EXCHANGE_ANTIQUE")
	ui.MsgBox(str, yesScp, "None");
end

function CHECK_EXCHANGE_ANTIQUE()
	local frame = ui.GetFrame("exchangeantique");
	local id = frame:GetUserValue("CURRENT_ITEM_GUID");
	local selectedItemIndex = frame:GetUserIValue('NOW_SELECT_ITEM_ID')
	
	local invItem = session.GetInvItemByGuid(id);
	if invItem == nil then
		ui.SysMsg(ScpArgMsg("NotEnoughRecipe"))
		return
	end
	local itemCls = GetClassByType("Item", invItem.type)		
	local inputItemCls = GET_EXCHANGE_ANTIQUE_INFO(itemCls.ClassName);
	if inputItemCls == nil then
		return;
	end

	if #inputItemCls.MatItemList > 0 then
		for i = 1, #inputItemCls.MatItemList do
			if inputItemCls.MatItemList[i].Name ~= 'None' and inputItemCls.MatItemList[i].Count > 0 then
				local itemName = GetClass("Item", inputItemCls.MatItemList[i].Name);
				local myInvItemCnt = session.GetInvItemCountByType(itemName.ClassID);
				if myInvItemCnt < inputItemCls.MatItemList[i].Count then
					ui.SysMsg(ScpArgMsg("NotEnoughRecipe"))
					return;
				end
			end
		end
	end

	item.ExchangeAntique(id, selectedItemIndex);
end

function OPEN_EXCHANGE_ANTIQUE(careMode)
	local frame = ui.GetFrame('exchangeantique');
	frame:SetUserValue('CARE_MODE', careMode);

	local function _SET_TITLE(frame, careMode)
		local title = GET_CHILD_RECURSIVELY(frame, 'title');
		if careMode == 1 then
			title:SetTextByKey('title', ClMsg('ExchangeWeaponType'));
		else
			title:SetTextByKey('title', ClMsg('ExchangeAntique'));
		end
	end
	_SET_TITLE(frame, careMode);

	ui.OpenFrame('exchangeantique');
end