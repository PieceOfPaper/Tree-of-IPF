function ITEMDECOMPOSE_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg('UPDATE_COLONY_TAX_RATE_SET', 'ON_ITEMDECOMPOSE_UPDATE_COLONY_TAX_RATE_SET');
end

local function _ITEM_DECOMPOSE_ITEM_LIST(frame, itemGradeList)
    if itemGradeList == nil then
        local itemTypeBoxFrame = GET_CHILD_RECURSIVELY(frame, "itemTypeBox", "ui::CGroupBox")
		itemGradeList = DECOMPOSE_ITEM_GRADE_SET(itemTypeBoxFrame, 0)		
	end

    --슬롯 셋 및 전체 슬롯 초기화 해야됨
	local itemSlotSet = GET_CHILD_RECURSIVELY(frame, "itemSlotset", "ui::CSlotSet")
	local miscSlotSet = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet")
	local miscSlotSet2 = GET_CHILD_RECURSIVELY(frame, "slotlist2", "ui::CSlotSet")
    
	itemSlotSet:ClearIconAll();
	miscSlotSet:ClearIconAll();
	miscSlotSet2:ClearIconAll();

	local itemSlotSetCnt = itemSlotSet:GetSlotCount();
	itemSlotSet:SetSkinName("invenslot2")
	for i = 0, itemSlotSetCnt - 1 do
		local tempSlot = itemSlotSet:GetSlotByIndex(i)
		DESTROY_CHILD_BYNAME(tempSlot, "styleset_")		
	end
	
	local invItemList = session.GetInvItemList();
	FOR_EACH_INVENTORY(invItemList, function(invItemList, invItem, itemGradeList, itemSlotSet)		
		if invItem ~= nil then
    		local itemobj = GetIES(invItem:GetObject());
    		local itemGrade = TryGetProp(itemobj, 'ItemGrade');
            if itemGrade == nil then
                itemGrade = 0;
            end

            local needToShow = true;
			for j = 1, #itemGradeList do
				if itemGradeList[j] == 0 and itemGrade == j then
            		needToShow = false;
            		break;
				end
				
            	--가공된 장비 체크 추가 --
				if itemGradeList[5] == 0 and itemGrade == j and IS_MECHANICAL_ITEM(itemobj) == true then					
        	        needToShow = false;
        	        break;
            	end
            end
            
            if needToShow == true then
				if itemobj.ItemType == 'Equip' and itemobj.DecomposeAble ~= nil and itemobj.DecomposeAble == "YES" and itemobj.ItemType == 'Equip' and itemobj.UseLv >= 75 and invItem.isLockState == false and itemGrade <= 4 then
					local itemSlotCnt = imcSlot:GetEmptySlotIndex(itemSlotSet);
	    			local itemSlot = itemSlotSet:GetSlotByIndex(itemSlotCnt)
	    			if itemSlot == nil then
	    				return 'break';
	    			end
				
	    			local icon = CreateIcon(itemSlot);
	    			icon:Set(itemobj.Icon, 'Item', invItem.type, itemSlotCnt, invItem:GetIESID());
	    			local class = GetClassByType('Item', invItem.type);
	    			SET_SLOT_STYLESET(itemSlot, itemobj)
	    			ICON_SET_INVENTORY_TOOLTIP(icon, invItem, nil, class);	                
	            end
        	end
    	end
	end, false, itemGradeList, itemSlotSet);
	RESET_SUCCESS(frame)
end

function ON_ITEMDECOMPOSE_UPDATE_COLONY_TAX_RATE_SET(frame)
	local decomposeCostText = GET_CHILD_RECURSIVELY(frame, "decomposeCostText")
	SET_COLONY_TAX_RATE_TEXT(decomposeCostText, "tax_rate")

    _ITEM_DECOMPOSE_ITEM_LIST(frame)
end

function ITEMDECOMPOSE_UI_OPEN(frame, msg, arg1, arg2)
    ui.EnableSlotMultiSelect(1);
    RESET_SUCCESS(frame)
    ITEMDECOMPOSE_CHECKBOX(frame)
    _ITEM_DECOMPOSE_ITEM_LIST(frame)
	local decomposeCostText = GET_CHILD_RECURSIVELY(frame, "decomposeCostText")
	SET_COLONY_TAX_RATE_TEXT(decomposeCostText, "tax_rate")
end

function ITEMDECOMPOSE_UI_CLOSE(frame, ctrl)
	ui.EnableSlotMultiSelect(0);
	frame:ShowWindow(0)
end

function RESET_SUCCESS(frame)
    local frame = frame:GetTopParentFrame();
    local arrowBox = GET_CHILD_RECURSIVELY(frame, "arrowBox", "ui::CGroupBox");
    arrowBox:ShowWindow(0)
    local decomposeSuccess = GET_CHILD_RECURSIVELY(frame, "decomposeSuccess", "ui::CPicture");
    decomposeSuccess:ShowWindow(0)
    local slotlist = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet");
    slotlist:ShowWindow(0)
    local slotlist2 = GET_CHILD_RECURSIVELY(frame, "slotlist2", "ui::CSlotSet");
    slotlist2:ShowWindow(0);
    local slotgb = GET_CHILD_RECURSIVELY(frame, "slotgb", "ui::CGroupBox");
    slotgb:ShowWindow(0);
end

function ITEMDECOMPOSE_CHECKBOX(frame)
    local normalCheckbox = GET_CHILD_RECURSIVELY(frame, 'normal');
    local magicCheckbox = GET_CHILD_RECURSIVELY(frame, 'magic');
    local rareCheckbox = GET_CHILD_RECURSIVELY(frame, 'rare');
    local uniqueCheckbox = GET_CHILD_RECURSIVELY(frame, 'unique');
    local mechanicalCheckbox = GET_CHILD_RECURSIVELY(frame, 'mechanical');
    
    normalCheckbox:SetCheck(1);
    magicCheckbox:SetCheck(1);
    rareCheckbox:SetCheck(1);
    uniqueCheckbox:SetCheck(0);
    mechanicalCheckbox:SetCheck(0);
end

function DECOMPOSE_ITEM_GRADE_SET(frame, isOpen)
    ITEM_DECOMPOSE_ALL_UNSELECT(frame);
    
    local normalCheckbox = GET_CHILD_RECURSIVELY(frame, "normal", "ui::CCheckBox");
    local magicCheckbox = GET_CHILD_RECURSIVELY(frame, "magic", "ui::CCheckBox");
    local rareCheckbox = GET_CHILD_RECURSIVELY(frame, "rare", "ui::CCheckBox");
    local uniqueCheckbox = GET_CHILD_RECURSIVELY(frame, "unique", "ui::CCheckBox");
    local mechanicalCheckbox = GET_CHILD_RECURSIVELY(frame, 'mechanical', "ui::CCheckBox");
    
    local itemGradeList = {};
    
    itemGradeList[#itemGradeList + 1] = normalCheckbox:IsChecked();
    itemGradeList[#itemGradeList + 1] = magicCheckbox:IsChecked();
    itemGradeList[#itemGradeList + 1] = rareCheckbox:IsChecked();
    itemGradeList[#itemGradeList + 1] = uniqueCheckbox:IsChecked();
    itemGradeList[#itemGradeList + 1] = mechanicalCheckbox:IsChecked();
    
    ITEM_DECOMPOSE_UPDATE_MONEY(frame);

    if isOpen ~= 1 then
        local itemdecomposeFrame = ui.GetFrame("itemdecompose");
        _ITEM_DECOMPOSE_ITEM_LIST(itemdecomposeFrame, itemGradeList);
    end
    return itemGradeList;
end

function DECOMPOSE_ITEM_MECHANICAL_SET(frame, isOpen)
    ITEM_DECOMPOSE_ALL_UNSELECT(frame);
    
    local normalCheckbox = GET_CHILD_RECURSIVELY(frame, "normal", "ui::CCheckBox");
    local magicCheckbox = GET_CHILD_RECURSIVELY(frame, "magic", "ui::CCheckBox");
    local rareCheckbox = GET_CHILD_RECURSIVELY(frame, "rare", "ui::CCheckBox");
    local uniqueCheckbox = GET_CHILD_RECURSIVELY(frame, "unique", "ui::CCheckBox");
    local mechanicalCheckbox = GET_CHILD_RECURSIVELY(frame, 'mechanical', "ui::CCheckBox");
    
    local itemGradeList = {};
    
    itemGradeList[#itemGradeList + 1] = normalCheckbox:IsChecked();
    itemGradeList[#itemGradeList + 1] = magicCheckbox:IsChecked();
    itemGradeList[#itemGradeList + 1] = rareCheckbox:IsChecked();
    itemGradeList[#itemGradeList + 1] = uniqueCheckbox:IsChecked();
    itemGradeList[#itemGradeList + 1] = mechanicalCheckbox:IsChecked();
    
    ITEM_DECOMPOSE_UPDATE_MONEY(frame);

    if itemGradeList[5] == 1 then
        ui.MsgBox(ScpArgMsg("IS_MechanicalItem_Decompose"));
    end

    if isOpen ~= 1 then
        local itemdecomposeFrame = ui.GetFrame("itemdecompose");
        _ITEM_DECOMPOSE_ITEM_LIST(itemdecomposeFrame, itemGradeList);
	end
    return itemGradeList;
end

function ITEM_DECOMPOSE_SLOT_LBTDOWN(frame, ctrl)
	ui.EnableSlotMultiSelect(1);
    RESET_SUCCESS(frame)
--	local slotSet = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "itemSlotset", "ui::CSlotSet")
    ITEM_DECOMPOSE_UPDATE_MONEY(frame)

end

function ITEM_DECOMPOSE_UPDATE_MONEY(frame)
	local frame = frame:GetTopParentFrame();
	local slotSet = GET_CHILD_RECURSIVELY(frame, "itemSlotset", "ui::CSlotSet")
	local totalprice = 0;
    
	local groupName = frame:GetUserValue("GroupName");
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	local handle = frame:GetUserIValue('HANDLE');
    
	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();
        
		local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
		local itemobj = GetIES(invitem:GetObject());
        
		if groupInfo == nil then -- npc 상점의 경우
		    totalprice = totalprice + GET_DECOMPOSE_PRICE(itemobj, GET_COLONY_TAX_RATE_CURRENT_MAP());
		end
	end
    
	local repairprice = GET_CHILD_RECURSIVELY_AT_TOP(frame, "decomposeCost", "ui::CRichText")
	repairprice:SetText(GET_COMMAED_STRING(totalprice))
    
	local calcprice = GET_CHILD_RECURSIVELY_AT_TOP(frame, "remainSilver", "ui::CRichText")
	if totalprice <= 0 then
		calcprice:SetText(GET_COMMAED_STRING(GET_TOTAL_MONEY_STR()))
		return;
	end
    
	local mymoney = GET_COMMAED_STRING(SumForBigNumberInt64(GET_TOTAL_MONEY_STR(), -1 * totalprice));
	calcprice:SetText(mymoney)
    
	frame:SetUserValue('TOTAL_MONEY', totalprice);
end

function ITEM_DECOMPOSE_ALL_SELECT(frame, ctrl)
	local isselected =  ctrl:GetUserValue("SELECTED");

	local slotSet = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "itemSlotset", "ui::CSlotSet")
	
	local slotCount = slotSet:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			if isselected == "selected" then
				slot:Select(0)
			else
				slot:Select(1)
			end
		end
	end
	slotSet:MakeSelectionList()

	if isselected == "selected" then
		ctrl:SetUserValue("SELECTED", "notselected");
	else
		ctrl:SetUserValue("SELECTED", "selected");
	end
	
	ITEM_DECOMPOSE_UPDATE_MONEY(frame)
--전체 선택시 비용 산정해야겠지..?
end

function ITEM_DECOMPOSE_ALL_UNSELECT(frame)
    
	local slotSet = GET_CHILD_RECURSIVELY_AT_TOP(frame, "itemSlotset", "ui::CSlotSet")
	local slotCount = slotSet:GetSlotCount();
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
--		if slot:GetIcon() ~= nil then
			slot:Select(0)
--		end
	end
	
	slotSet:MakeSelectionList()
    
    local selectAllBtn = GET_CHILD_RECURSIVELY_AT_TOP(frame, "selectAll", "ui::CButton")
	selectAllBtn:SetUserValue("SELECTED", "notselected");
end



function ITEM_DECOMPOSE_EXECUTE(frame)
	session.ResetItemList();

	local totalprice = 0;

	local slotSet = GET_CHILD_RECURSIVELY(frame, "itemSlotset", "ui::CSlotSet")
	
	if slotSet:GetSelectedSlotCount() < 1 then
		ui.MsgBox(ScpArgMsg("DON_T_HAVE_ITEM_TO_DECOMPOSE"))
		return;
	end
	
	local itemCheckProp = { }
	itemCheckProp['Reinforce'] = 0;
	itemCheckProp['Transcend'] = 0;
	itemCheckProp['Awaken'] = 0;
	itemCheckProp['Socket_Equip'] = 0;
	itemCheckProp['Socket_Add'] = 0;
	itemCheckProp['EnchantOption'] = 0;
	
	local groupName = frame:GetUserValue("GroupName");
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	local taxRate = nil
	if groupInfo == nil then -- if not pc shop
		taxRate = GET_COLONY_TAX_RATE_CURRENT_MAP()
	end

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();
        
		session.AddItemID(iconInfo:GetIESID());

		local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
		local itemobj = GetIES(invitem:GetObject());
		totalprice = totalprice + GET_DECOMPOSE_PRICE(itemobj, taxRate);
		
		local itemReinforce = TryGetProp(itemobj, 'Reinforce_2');
		if itemReinforce ~= nil and itemReinforce > 0 then
			itemCheckProp['Reinforce'] = itemCheckProp['Reinforce'] + 1;
		end
		
		local itemTranscend = TryGetProp(itemobj, 'Transcend');
		if itemTranscend ~= nil and itemTranscend > 0 then
			itemCheckProp['Transcend'] = itemCheckProp['Transcend'] + 1;
		end
		
		local itemAwaken = TryGetProp(itemobj, 'IsAwaken');
		if itemAwaken ~= nil and itemAwaken > 0 then
			itemCheckProp['Awaken'] = itemCheckProp['Awaken'] + 1;
		end
		
		local itemRareOption = TryGetProp(itemobj, 'RandomOptionRare');
		local itemRareOptionValue = TryGetProp(itemobj, 'RandomOptionRareValue');
		if itemRareOption ~= nil and itemRareOption ~= 'None' and itemRareOptionValue > 0 then
		    itemCheckProp['EnchantOption'] = itemCheckProp['EnchantOption'] + 1
		end
		
		for j = 0, 4 do
    		if invitem:GetEquipGemID(j) > 0 then
    			itemCheckProp['Socket_Equip'] = itemCheckProp['Socket_Equip'] + 1;
    			break;
    		end
    		    		
    		if invitem:IsAvailableSocket(j) == true then
    			itemCheckProp['Socket_Add'] = itemCheckProp['Socket_Add'] + 1;
    			break;
    		end
    	end
	end

	if totalprice == 0 then
		ui.MsgBox(ScpArgMsg("DON_T_HAVE_ITEM_TO_DECOMPOSE"));
		return;
	end
	
	if IsGreaterThanForBigNumber(totalprice, GET_TOTAL_MONEY_STR()) == 1 then
		ui.MsgBox(ScpArgMsg("NOT_ENOUGH_MONEY"))
		return;
	end

	local txtPrice = GET_COMMAED_STRING(totalprice)
	local msg = ScpArgMsg('ItemDecomposePrice',"Price", txtPrice)
	
	local checkPropList = { 'Reinforce', 'Transcend', 'Awaken', 'Socket_Equip', 'Socket_Add', 'EnchantOption' };
	local warningPropList = { };
	for j = 1, #checkPropList do
		local checkProp = checkPropList[j];
		if itemCheckProp[checkProp] > 0 then
			warningPropList[#warningPropList + 1] = ScpArgMsg('ItemDecomposeWarningProp_' .. checkProp);
		end
	end
	
	if #warningPropList > 0 then
		local warningProp = table.concat(warningPropList, ", ")
		msg = ScpArgMsg('ItemDecomposeWarningPropMessage', 'WARNINGPROP', warningProp, 'DEFAULTMSG', msg);
	end
	
	local msgBox = WARNINGMSGBOX_FRAME_OPEN(msg, "ITEM_DECOMPOSE_EXECUTE_COMMIT", "None")
	local msgBoxFrame = ui.GetFrame("warningmsgbox")
	if msgBoxFrame == nil then
		return;
	end
	
	local yesBtn = GET_CHILD_RECURSIVELY(msgBoxFrame, "yes")
	yesBtn:SetClickSound("button_click_repair");
end

function ITEM_DECOMPOSE_EXECUTE_COMMIT()
	local resultlist = session.GetItemIDList()
	item.DialogTransaction("ITEM_DECOMPOSE_TX", resultlist);
end

function ITEM_DECOMPOSE_COMPLETE(...)
    local frame = ui.GetFrame("itemdecompose");
    if frame:IsVisible() == 1 then
        _ITEM_DECOMPOSE_ITEM_LIST(frame)
        
        local arrowBox = GET_CHILD_RECURSIVELY(frame, "arrowBox", "ui::CGroupBox");
        arrowBox:ShowWindow(1);
        local decomposeSuccess = GET_CHILD_RECURSIVELY(frame, "decomposeSuccess", "ui::CPicture");
        decomposeSuccess:ShowWindow(1);
        local slotlist = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet");
		slotlist:ShowWindow(1);
		local slotlist2 = GET_CHILD_RECURSIVELY(frame, "slotlist2", "ui::CSlotSet");
		slotlist2:ShowWindow(1);
		local slotgb = GET_CHILD_RECURSIVELY(frame, "slotgb", "ui::CGroupBox");
		slotgb:ShowWindow(1);
    end
    
    local itemList = {...};
    if itemList ~= nil and #itemList > 0 then        
    	local miscSlotSet = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet")
    	local miscSlotSet2 = GET_CHILD_RECURSIVELY(frame, "slotlist2", "ui::CSlotSet")
        
    	miscSlotSet:ClearIconAll();
    	miscSlotSet2:ClearIconAll();
    	
        local itemName = { };
        local itemCount = { };
        local miscSlotCnt = 0;
        
		for i = 1, #itemList do
			local item = ITEMDECOMPOSE_STRING_CUT(itemList[i]);
            local itemName = item[1];					-- 획득 아이템 이름
			local itemCount = item[2];
			local itemCount2 = 0;
			if i < 3 then 								-- 뉴클 가루, 시에라 가루 일 때만
				itemCount = itemCount - item[3];		-- 기본 획득 량
				itemCount2 = item[3];					-- 초월 장비 보너스 
			end
			
			local itemCls = GetClass('Item', itemName);
            if itemCount > 0 and IS_ENCHANT_JEWELL_ITEM(itemCls) == false then
        		local miscSlot = miscSlotSet:GetSlotByIndex(miscSlotCnt)
				local miscSlot2 = miscSlotSet:GetSlotByIndex(miscSlotCnt + 1)
        		if miscSlot == nil or miscSlot2 == nil then
        			break;
				end

				local invItem = session.GetInvItemByName(itemName)
                if invItem ~= nil then
                    local itemobj = GetIES(invItem:GetObject());
        			local class = GetClassByType('Item', invItem.type);                    
					
					SET_SLOT_ITEM_INFO(miscSlot, class, itemCount,'{s16}{ol}{b}{ds}');			-- 기본 획득
					if 0 < itemCount2 then
						SET_SLOT_ITEM_INFO(miscSlot2, class, itemCount2,'{s16}{ol}{b}{ds}');	-- 초월 장비 보너스
					end

					local miscSlotAll = miscSlotSet2:GetSlotByIndex(i-1);
					if miscSlotAll == nil then
						break;
					end
					SET_SLOT_ITEM_INFO(miscSlotAll, class, item[2],'{s16}{ol}{b}{ds}'); -- 총 획득
                    
        			miscSlotCnt = miscSlotCnt + 2;
            	end
            end
        end
    end
end

function ITEMDECOMPOSE_STRING_CUT(string)
	local temp_table = { };	
	local strlist = StringSplit(string, "/");

	for k, v in pairs(strlist) do
		if tonumber(v) ~= nil then
			temp_table[k] = tonumber(v);
		else
			temp_table[k] = v;
		end
	end

	return temp_table
end