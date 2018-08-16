
function ITEMDECOMPOSE_UI_OPEN(frame, msg, arg1, arg2)
    ui.EnableSlotMultiSelect(1);
    RESET_SUCCESS(frame)
    ITEMDECOMPOSE_CHECKBOX(frame)
    ITEM_DECOMPOSE_ITEM_LIST(frame)
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
    
    if itemGradeList[5] == 1 then
        ui.MsgBox(ScpArgMsg("IS_MechanicalItem_Decompose"));
    end

    if isOpen ~= 1 then
        local itemdecomposeFrame = ui.GetFrame("itemdecompose");
        ITEM_DECOMPOSE_ITEM_LIST(itemdecomposeFrame, itemGradeList);
    end
    return itemGradeList;
end

function ITEM_DECOMPOSE_ITEM_LIST(frame, itemGradeList)
    if itemGradeList == nil then
        local itemTypeBoxFrame = GET_CHILD_RECURSIVELY(frame, "itemTypeBox", "ui::CGroupBox")
        itemGradeList = DECOMPOSE_ITEM_GRADE_SET(itemTypeBoxFrame, 0)
    end
    
    --슬롯 셋 및 전체 슬롯 초기화 해야됨
	local itemSlotSet = GET_CHILD_RECURSIVELY(frame, "itemSlotset", "ui::CSlotSet")
	local miscSlotSet = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet")
    
	itemSlotSet:ClearIconAll();
	miscSlotSet:ClearIconAll();
	
	local itemSlotSetCnt = itemSlotSet:GetSlotCount();
	itemSlotSet:SetSkinName("invenslot2")
	for i = 0, itemSlotSetCnt - 1 do
		local tempSlot = itemSlotSet:GetSlotByIndex(i)
		DESTROY_CHILD_BYNAME(tempSlot, "styleset_")		
	end
	
	local itemSlotCnt = 0
	
	local invItemList = session.GetInvItemList();
    local itemCount = session.GetInvItemList():Count();
    local index = invItemList:Head();
	for i = 0, itemCount - 1 do
    	local invItem = invItemList:Element(index);
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
    		if itemobj.ItemType == 'Equip' and itemobj.DecomposeAble ~= nil and itemobj.DecomposeAble == "YES" and itemobj.ItemType == 'Equip' and itemobj.UseLv >= 75 and invItem.isLockState == false  and itemGrade <= 4 then
    			local itemSlot = itemSlotSet:GetSlotByIndex(itemSlotCnt)
    			if itemSlot == nil then
    				break;
    			end
                
    			local icon = CreateIcon(itemSlot);
    			icon:Set(itemobj.Icon, 'Item', invItem.type, itemSlotCnt, invItem:GetIESID());
    			local class = GetClassByType('Item', invItem.type);
	    			SET_SLOT_STYLESET(itemSlot, itemobj)
    			ICON_SET_INVENTORY_TOOLTIP(icon, invItem, nil, class);
                
    			itemSlotCnt = itemSlotCnt + 1;
            end
    	end
    	end
    	index = invItemList:Next(index);
	end
	RESET_SUCCESS(frame)
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
		    totalprice = totalprice + GET_DECOMPOSE_PRICE(itemobj);
		end
	end
    
	local repairprice = GET_CHILD_RECURSIVELY_AT_TOP(frame, "decomposeCost", "ui::CRichText")
	repairprice:SetText(GET_COMMAED_STRING(totalprice))
    
	local calcprice = GET_CHILD_RECURSIVELY_AT_TOP(frame, "remainSilver", "ui::CRichText")
	if totalprice <= 0 then
		calcprice:SetText(GET_COMMAED_STRING(GET_TOTAL_MONEY()))
		return;
	end
    
	local mymoney = GET_COMMAED_STRING(SumForBigNumberInt64(GET_TOTAL_MONEY(), -1 * totalprice));
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
	
	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();
        
		session.AddItemID(iconInfo:GetIESID());

		local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
		local itemobj = GetIES(invitem:GetObject());

		totalprice = totalprice + GET_DECOMPOSE_PRICE(itemobj);
		
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
		
		for j = 0, 9 do
    		local itemSocketEquip = TryGetProp(itemobj, 'Socket_Equip_' .. j);
    		if itemSocketEquip ~= nil and itemSocketEquip > 0 then
    			itemCheckProp['Socket_Equip'] = itemCheckProp['Socket_Equip'] + 1;
    			break;
    		end
    		
    		local itemSocketAdd = TryGetProp(itemobj, 'Socket_' .. j);
    		if itemSocketAdd ~= nil and itemSocketAdd > 0 then
    			itemCheckProp['Socket_Add'] = itemCheckProp['Socket_Add'] + 1;
    			break;
    		end
    	end
	end

	if totalprice == 0 then
		ui.MsgBox(ScpArgMsg("DON_T_HAVE_ITEM_TO_DECOMPOSE"));
		return;
	end
	
	if GET_TOTAL_MONEY() < totalprice then
		ui.MsgBox(ScpArgMsg("NOT_ENOUGH_MONEY"))
		return;
	end

	local txtPrice = GET_COMMAED_STRING(totalprice)
	local msg = ScpArgMsg('ItemDecomposePrice',"Price", txtPrice)
	
	local checkPropList = { 'Reinforce', 'Transcend', 'Awaken', 'Socket_Equip', 'Socket_Add' };
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
        ITEM_DECOMPOSE_ITEM_LIST(frame)
        
        local arrowBox = GET_CHILD_RECURSIVELY(frame, "arrowBox", "ui::CGroupBox");
        arrowBox:ShowWindow(1);
        local decomposeSuccess = GET_CHILD_RECURSIVELY(frame, "decomposeSuccess", "ui::CPicture");
        decomposeSuccess:ShowWindow(1);
        local slotlist = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet");
        slotlist:ShowWindow(1);
    end
    
    local itemList = {...};
    if itemList ~= nil and #itemList > 0 then        
    	local miscSlotSet = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet")
        
    	miscSlotSet:ClearIconAll();
    	
        local itemName = { };
        local itemCount = { };
        local miscSlotCnt = 0;
        
        for i = 1, #itemList do
            local item = SCR_STRING_CUT(itemList[i]);
            local itemName = item[1];
			local itemCount = item[2];
			local itemCls = GetClass('Item', itemName);            
            if itemCount > 0 and IS_ENCHANT_JEWELL_ITEM(itemCls) == false then
        		local miscSlot = miscSlotSet:GetSlotByIndex(miscSlotCnt)
        		if miscSlot == nil then
        			break;
        		end
                
                ------------------------------------------------------
                local invItem = session.GetInvItemByName(itemName)
                if invItem ~= nil then
                    local itemobj = GetIES(invItem:GetObject());
        			local class = GetClassByType('Item', invItem.type);
                    
            		SET_SLOT_ITEM_INFO(miscSlot, class, itemCount,'{s16}{ol}{b}{ds}');
                    
        			miscSlotCnt = miscSlotCnt + 1;
            	end
            end
        end
    end
end