function TPITEM_INIT_WING_STORE_TAB(parent, wingStoreBox)
	local frame = parent:GetTopParentFrame();
	TPITEM_WING_INIT_BASKET(frame);

	local listBox = GET_CHILD_RECURSIVELY(frame, 'listBox');
	DESTROY_CHILD_BYNAME(listBox, "WINGITEM_");
	local NUM_COL = 3;	
	local clsList, cnt = GetClassList('WingStore');
	for i = 0, cnt - 1 do
		local colOffset = i % NUM_COL;
		local rowOffset = math.floor(i / NUM_COL);
		local ctrlSet = listBox:CreateOrGetControlSet('tpshop_recycle', 'WINGITEM_'..i, 0, 0);
		ctrlSet:SetOffset(colOffset * ctrlSet:GetWidth(), rowOffset * ctrlSet:GetHeight());
		ctrlSet:SetUserValue('WING_ITEM', 'YES');

		TPITEM_WING_INIT_VISIBLE_SETTING(ctrlSet);

		local wingStoreItem = GetClassByIndexFromList(clsList, i);
		local itemCls = GetClass('Item', wingStoreItem.ItemClassName);
		local title = GET_CHILD(ctrlSet, 'title');
		title:SetText(itemCls.Name);

		TPITEM_WING_INIT_ITEM(ctrlSet, itemCls);
        TPITEM_WING_INIT_PRICE(ctrlSet, wingStoreItem);
        TPITEM_WING_INIT_EQUIP_PROP(ctrlSet, wingStoreItem, itemCls);
        TPITEM_WING_INIT_BUY_BTN(ctrlSet, wingStoreItem, itemCls);
	end

	TPITEM_WING_UPDATE_WINGITEM(frame);
end

function TPITEM_HIDE_WING_STORE(frame, curTabIndex)	
	if curTabIndex == 3 then
		return;
	end
	local wing_basketgbox = GET_CHILD_RECURSIVELY(frame, 'wing_basketgbox');
	wing_basketgbox:ShowWindow(0);
end

function TPITEM_WING_INIT_BASKET(frame)
	local rcycle_basketgbox = GET_CHILD_RECURSIVELY(frame, 'rcycle_basketgbox');
	local basketgbox = GET_CHILD_RECURSIVELY(frame, 'basketgbox');
	local wing_basketgbox = GET_CHILD_RECURSIVELY(frame, 'wing_basketgbox');
	rcycle_basketgbox:ShowWindow(0);
	basketgbox:ShowWindow(0);
	wing_basketgbox:ShowWindow(1);
end

function TPITEM_WING_INIT_VISIBLE_SETTING(ctrlSet)
	local staticSellMedalbox = GET_CHILD(ctrlSet, 'staticSellMedalbox');				
	local noneBtnPreSlot_1 = GET_CHILD(ctrlSet, 'noneBtnPreSlot_1');
	local noneBtnPreSlot_2 = GET_CHILD(ctrlSet, 'noneBtnPreSlot_2');
	local noneBtnPreSlot_3 = GET_CHILD(ctrlSet, 'noneBtnPreSlot_3');		
	local remaincnt = GET_CHILD(ctrlSet, 'remaincnt');
	local subtitle = GET_CHILD(ctrlSet, 'subtitle');
	local sellBtn = GET_CHILD(ctrlSet, 'sellBtn');
	staticSellMedalbox:ShowWindow(0);
	noneBtnPreSlot_1:ShowWindow(0);
	noneBtnPreSlot_2:ShowWindow(0);
	noneBtnPreSlot_3:ShowWindow(0);		
	remaincnt:ShowWindow(0);
	subtitle:ShowWindow(0);
	sellBtn:ShowWindow(0);
end

function TPITEM_WING_INIT_ITEM(ctrlSet, itemCls)	
	local slot = GET_CHILD(ctrlSet, 'icon');
	SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(itemCls));			
	local icon = slot:GetIcon();
	SET_ITEM_TOOLTIP_BY_NAME(icon, itemCls.ClassName);
    icon:SetTooltipOverlap(1);
end

function TPITEM_WING_INIT_PRICE(ctrlSet, wingStoreItem)
	local frame = ctrlSet:GetTopParentFrame();
    local wingItem = GetClass('Item', 'Wing_Shop_Coupon'); -- hs_comment: 재성씨 여기 두번째 인자에 깃털 아이템 클래스 네임 적어주세여	    
    local staticBuyMedalbox = GET_CHILD(ctrlSet, 'staticBuyMedalbox');
    local nxp = GET_CHILD(ctrlSet, 'nxp');
    staticBuyMedalbox:SetTextByKey('type', ClMsg('Wing'));
    staticBuyMedalbox:SetTextByKey('img', wingItem.Icon);
    nxp:SetText('{@st43}{s18}'..wingStoreItem.Price);
end

function TPITEM_WING_INIT_EQUIP_PROP(ctrlSet, wingStoreItem, itemCls)
	-- desc
    local desc = GET_CHILD(ctrlSet, 'desc');
    local lv = GETMYPCLEVEL();
	local job = GETMYPCJOB();
	local gender = GETMYPCGENDER();
	local prop = geItemTable.GetProp(itemCls.ClassID);
	local result = prop:CheckEquip(lv, job, gender);
	if result == "OK" then
		desc:SetText(GET_USEJOB_TOOLTIP(itemCls))
	else
		desc:SetText("{#990000}"..GET_USEJOB_TOOLTIP(itemCls).."{/}")
	end

	-- preview
	local previewBtn = GET_CHILD(ctrlSet, 'previewBtn');
	local previewable = false;
	if IS_EQUIP(itemCls) == true then
		previewable = true;

		if result ~= "OK" then
			previewable = false;
		end	

		local useGender = TryGetProp(itemCls, 'UseGender');
		if useGender =="Male" and gender ~= 1 then
			previewable = false;
		end

		if useGender =="Female" and gender ~= 2 then
			previewable = false;
		end
	end

	local clstype = TryGetProp(itemCls, "ClassType");
	if previewable == true and (clstype == "Hat" or clstype == "Outer" or clstype == 'Wing') then
		previewBtn:SetEventScriptArgNumber(ui.LBUTTONUP, itemCls.ClassID);
		previewBtn:SetEventScriptArgString(ui.LBUTTONUP, wingStoreItem.ClassName);
	else
		previewBtn:ShowWindow(0);
	end
end

function TPITEM_WING_INIT_BUY_BTN(ctrlSet, wingStoreItem, itemCls)
	local buyBtn = GET_CHILD(ctrlSet, 'buyBtn');
	buyBtn:SetEventScriptArgNumber(ui.LBUTTONUP, itemCls.ClassID);
	buyBtn:SetEventScriptArgString(ui.LBUTTONUP, wingStoreItem.ClassName);
end

function TPITEM_WING_PUSH_INTO_BASKET(ctrlSet, itemClassName, itemClassID)
	local item = GetClassByType("Item", itemClassID)
	if item == nil then
		return;
	end

	local wingitem = GetClass("WingStore", itemClassName);
	if wingitem == nil then
		ui.MsgBox(ScpArgMsg("DataError"));
		return;
	end
	
	local frame = ctrlSet:GetTopParentFrame();
	local slotset = GET_CHILD_RECURSIVELY(frame, "wing_basketbuyslotset");
	local slotCount = slotset:GetSlotCount();
	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);
		if slotIcon == nil then
			local slot  = slotset:GetSlotByIndex(i);
			slot:SetEventScript(ui.RBUTTONDOWN, 'TPITEM_WING_REMOVE_BASKETSLOT');
			slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, itemClassID);
			slot:SetUserValue("CLASSNAME", item.ClassName);
			slot:SetUserValue("TPITEMNAME", itemClassName);			
			SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(item));

			local icon = slot:GetIcon();
			icon:SetTooltipType('wholeitem');
			icon:SetTooltipArg('', item.ClassID, 0);
			break;
		end
	end

	TPITEM_WING_UPDATE_WINGITEM(frame);
end

function TPITEM_WING_UPDATE_WINGITEM(frame)
	local pc = GetMyPCObject();
	local haveCount = GetInvItemCount(pc, 'Wing_Shop_Coupon'); -- hs_comment: 재성씨! 깃털 아이템 클래스 네임 적어주세요
	local basketCount = 0;
	local slotset = GET_CHILD_RECURSIVELY(frame, "wing_basketbuyslotset");
	local slotCount = slotset:GetSlotCount();
	for i = 0, slotCount - 1 do
		local slot = slotset:GetSlotByIndex(i);		
		local wingItemClassName = slot:GetUserValue('TPITEMNAME');
		local wingItem = GetClass('WingStore', wingItemClassName);		
		if wingItem ~= nil then
			basketCount = basketCount + wingItem.Price;
		end
	end

	local wing_haveTP = GET_CHILD_RECURSIVELY(frame, 'wing_haveTP');
	local wing_basketTP = GET_CHILD_RECURSIVELY(frame, 'wing_basketTP');
	local wing_remainTP = GET_CHILD_RECURSIVELY(frame, 'wing_remainTP');
	wing_haveTP:SetText(haveCount);
	if basketCount > 0 then
		wing_basketTP:SetText(-basketCount);
	else
		wing_basketTP:SetText(basketCount);
	end
	wing_remainTP:SetText(haveCount - basketCount);
end

function TPITEM_WING_REMOVE_BASKETSLOT(parent, control, strarg, classid)	
	control:ClearText();
	control:ClearIcon();
	control:SetUserValue("CLASSNAME", "None");
	control:SetUserValue("TPITEMNAME", "None");

	TPITEM_WING_UPDATE_WINGITEM(parent:GetTopParentFrame());
end

function TPITEM_WING_BUY(parent, ctrl)
    local frame = parent:GetTopParentFrame();
    local wing_basketTP = GET_CHILD_RECURSIVELY(frame, 'wing_basketTP');
    local basketTP = tonumber(wing_basketTP:GetText());
    if basketTP == 0 then
        return;
    end

    local wing_remainTP = GET_CHILD_RECURSIVELY(frame, 'wing_remainTP');
    local remainTP = tonumber(wing_remainTP:GetText());
    if remainTP < 0 then
        ui.MsgBox(ClMsg('LackOfWing'));
        return;
    end

    RECYCLESHOP_POPUPMSG_MAKE_ITEMLIST('wingStore');
end

function TPITEM_WING_BUY_EXECUTE(parent, ctrl)
    local itemListStr = '';
    local frame = ui.GetFrame('tpitem');
    local slotset = GET_CHILD_RECURSIVELY(frame, "wing_basketbuyslotset");
	local slotCount = slotset:GetSlotCount();
	for i = 0, slotCount - 1 do
		local slot = slotset:GetSlotByIndex(i);		
		local wingItemClassName = slot:GetUserValue('TPITEMNAME');
		local wingItem = GetClass('WingStore', wingItemClassName);		
		if wingItem ~= nil then
			if itemListStr == "" then
				itemListStr = tostring(wingItem.ClassID)
			else
				itemListStr = itemListStr.." "..tostring(wingItem.ClassID);
			end
		end
	end
    pc.ReqExecuteTx_NumArgs("SCR_TX_WING_STORE_BUY", itemListStr);
    slotset:ClearIconAll();

    local frame = ui.GetFrame("tpitem");
	frame:ShowWindow(0);
	TPITEM_CLOSE(frame);
end