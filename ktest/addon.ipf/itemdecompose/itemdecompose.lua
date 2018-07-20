
function ITEMDECOMPOSE_UI_OPEN(frame, msg, arg1, arg2)
    ui.EnableSlotMultiSelect(1);
    
    local arrowBox = GET_CHILD_RECURSIVELY(frame, "arrowBox", "ui::CGroupBox");
    arrowBox:ShowWindow(0)
    local decomposeSuccess = GET_CHILD_RECURSIVELY(frame, "decomposeSuccess", "ui::CPicture");
    decomposeSuccess:ShowWindow(0)
    local slotlist = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet");
    slotlist:ShowWindow(0)
    
    ITEM_DECOMPOSE_ITEM_LIST(frame)
    ITEMDECOMPOSE_CHECKBOX(frame)
end

function ITEMDECOMPOSE_UI_CLOSE(frame, ctrl)
	ui.EnableSlotMultiSelect(0);
	frame:ShowWindow(0)
end

function ITEMDECOMPOSE_CHECKBOX(frame)
    local normalCheckbox = GET_CHILD_RECURSIVELY(frame, 'normal');
    local magicCheckbox = GET_CHILD_RECURSIVELY(frame, 'magic');
    local rareCheckbox = GET_CHILD_RECURSIVELY(frame, 'rare');
    local uniqueCheckbox = GET_CHILD_RECURSIVELY(frame, 'unique');
    
    normalCheckbox:SetCheck(1);
    magicCheckbox:SetCheck(1);
    rareCheckbox:SetCheck(1);
    uniqueCheckbox:SetCheck(1);
end

function DECOMPOSE_ITEM_GRADE_SET(frame, isOpen)
    ITEM_DECOMPOSE_ALL_UNSELECT(frame);
    
    local normalCheckbox = GET_CHILD_RECURSIVELY(frame, "normal", "ui::CCheckBox");
    local magicCheckbox = GET_CHILD_RECURSIVELY(frame, "magic", "ui::CCheckBox");
    local rareCheckbox = GET_CHILD_RECURSIVELY(frame, "rare", "ui::CCheckBox");
    local uniqueCheckbox = GET_CHILD_RECURSIVELY(frame, "unique", "ui::CCheckBox");
    
    local itemGradeList = {};
    
    itemGradeList[#itemGradeList + 1] = normalCheckbox:IsChecked();
    itemGradeList[#itemGradeList + 1] = magicCheckbox:IsChecked();
    itemGradeList[#itemGradeList + 1] = rareCheckbox:IsChecked();
    itemGradeList[#itemGradeList + 1] = uniqueCheckbox:IsChecked();
    
    ITEM_DECOMPOSE_UPDATE_MONEY(frame);
    
    if isOpen ~= 1 then
        local itemdecomposeFrame = ui.GetFrame("itemdecompose");
        ITEM_DECOMPOSE_ITEM_LIST(itemdecomposeFrame, itemGradeList);
    end
    
    return itemGradeList;
end

function ITEM_DECOMPOSE_ITEM_LIST(frame, itemGradeList)
    if itemGradeList == nil then
        local itemTypeBoxFrame = GET_CHILD_RECURSIVELY(frame, "itemTypeBox", "ui::CGroupBox")
        itemGradeList = DECOMPOSE_ITEM_GRADE_SET(itemTypeBoxFrame, 1)
    end
    
    --슬롯 셋 및 전체 슬롯 초기화 해야됨
	local itemSlotSet = GET_CHILD_RECURSIVELY(frame, "itemSlotset", "ui::CSlotSet")
	local miscSlotSet = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet")
    
	itemSlotSet:ClearIconAll();
	miscSlotSet:ClearIconAll();
	
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
            
    		if itemobj.ItemType == 'Equip' and itemobj.DecomposeAble ~= nil and itemobj.DecomposeAble == "YES" and itemGradeList[itemGrade] == 1 then
    			local itemSlot = itemSlotSet:GetSlotByIndex(itemSlotCnt)
    			if itemSlot == nil then
    				break;
    			end
                
    			local icon = CreateIcon(itemSlot);
    			icon:Set(itemobj.Icon, 'Item', invItem.type, itemSlotCnt, invItem:GetIESID());
    			local class = GetClassByType('Item', invItem.type);
    			ICON_SET_INVENTORY_TOOLTIP(icon, invItem, nil, class);
                
    			itemSlotCnt = itemSlotCnt + 1;
            end
    	end
    	index = invItemList:Next(index);
	end
end


function ITEM_DECOMPOSE_SLOT_LBTDOWN(frame, ctrl)

	ui.EnableSlotMultiSelect(1);

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
    
	local mymoney = GET_COMMAED_STRING(GET_TOTAL_MONEY()-totalprice);
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

	for i = 0, slotSet:GetSelectedSlotCount() -1 do
		local slot = slotSet:GetSelectedSlot(i)
		local Icon = slot:GetIcon();
		local iconInfo = Icon:GetInfo();
        
		session.AddItemID(iconInfo:GetIESID());

		local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
		local itemobj = GetIES(invitem:GetObject());

		totalprice = totalprice + GET_DECOMPOSE_PRICE(itemobj);
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
	local msgBox = ui.MsgBox(msg, "ITEM_DECOMPOSE_EXECUTE_COMMIT", "None");
	
	
	msgBox:SetYesButtonSound("button_click_repair");
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
            
            if itemCount > 0 then
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