function ITEMDECOMPOSE_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg('UPDATE_COLONY_TAX_RATE_SET', 'ON_ITEMDECOMPOSE_UPDATE_COLONY_TAX_RATE_SET');
end

local MAX_SELECT = 60

function ITEMDECOMPOSE_UI_CLOSE(frame, ctrl)
	frame = frame:GetTopParentFrame()
	ui.EnableSlotMultiSelect(0);
	frame:ShowWindow(0)
end
--open
function ITEMDECOMPOSE_UI_OPEN(frame, msg, arg1, arg2)
    ui.EnableSlotMultiSelect(1);
	local decomposeCostText = GET_CHILD_RECURSIVELY(frame, "decomposeCostText")
	SET_COLONY_TAX_RATE_TEXT(decomposeCostText, "tax_rate")
	LOAD_ITEM_DECOMPOSE_ITEM_LIST(frame)
	TOGGLE_DECOMPOSE_RESULT(frame,0)
	ITEMDECOMPOSE_UI_RESIZE(frame)
end

function ITEMDECOMPOSE_UI_RESIZE(frame)
	if frame:GetHeight() < 1360 then
		local slotgb = GET_CHILD_RECURSIVELY(frame,"slotgb")
		local margin = slotgb:GetMargin()
		slotgb:SetMargin(margin.left,150,margin.right,margin.bottom)
		local decomposeCompleteBtn = GET_CHILD_RECURSIVELY(slotgb,"decomposeCompleteBtn")
		decomposeCompleteBtn:ShowWindow(1)
	else
		local slotgb = GET_CHILD_RECURSIVELY(frame,"slotgb")
		local margin = slotgb:GetMargin()
		slotgb:SetMargin(margin.left,740,margin.right,margin.bottom)
		local decomposeCompleteBtn = GET_CHILD_RECURSIVELY(slotgb,"decomposeCompleteBtn")
		decomposeCompleteBtn:ShowWindow(0)
	end
end

function ON_ITEMDECOMPOSE_UPDATE_COLONY_TAX_RATE_SET(frame)
	local decomposeCostText = GET_CHILD_RECURSIVELY(frame, "decomposeCostText")
	SET_COLONY_TAX_RATE_TEXT(decomposeCostText, "tax_rate")
	LOAD_ITEM_DECOMPOSE_ITEM_LIST(frame)
	TOGGLE_DECOMPOSE_RESULT(frame,0)
end

function LOAD_ITEM_DECOMPOSE_ITEM_LIST(frame)
	frame:SetUserValue("ENABLE_SLOT","1")
	--슬롯 셋 및 전체 슬롯 초기화 해야됨
	local slotlist_bg = GET_CHILD_RECURSIVELY(frame, "slotlist_bg", "ui::CGroupBox")
	local miscSlotSet = GET_CHILD_RECURSIVELY(frame, "slotlist", "ui::CSlotSet")
	local miscSlotSet2 = GET_CHILD_RECURSIVELY(frame, "slotlist2", "ui::CSlotSet")
    
	miscSlotSet:ClearIconAll();
	miscSlotSet2:ClearIconAll();
	for i = 1,4 do
		local ctrlSet = GET_CHILD_RECURSIVELY(slotlist_bg, "itemSlotset"..i, "ui::CControlSet")
		local itemSlotSet = GET_CHILD_RECURSIVELY(ctrlSet,'itemSlotset',"ui::CSlotSet")
		itemSlotSet:ClearIconAll();
		local itemSlotSetCnt = itemSlotSet:GetSlotCount();
		itemSlotSet:SetSkinName("invenslot2")
		for i = 0, itemSlotSetCnt - 1 do
			local tempSlot = itemSlotSet:GetSlotByIndex(i)
			tempSlot:RemoveAllChild()
			tempSlot:SetEnable(1)
		end

		local text = ctrlSet:GetUserConfig("GRADE_"..i)
		local itemSlotSetText = GET_CHILD_RECURSIVELY(ctrlSet,'itemSlotsetText')
		itemSlotSetText:SetText(text)
	end
	
	local mechanical = GET_CHILD_RECURSIVELY(frame,"mechanical","ui::CCheckBox")
	local showAll = mechanical:IsChecked()
	local invItemList = session.GetInvItemList();
	local decomposibleList = {{},{},{},{}}
	FOR_EACH_INVENTORY(invItemList, function(invItemList, invItem, showAll)
		if invItem ~= nil then
    		local itemobj = GetIES(invItem:GetObject());
			local decomposible = TryGetProp(itemobj,'DecomposeAble','None')
			if itemobj.ItemType == 'Equip' and decomposible == "YES" and  IS_EQUIPPED_WEAPON_SWAP_SLOT(invItem) == false and
				itemobj.UseLv >= 75 and invItem.isLockState == false then
				if showAll == 1 or IS_MECHANICAL_ITEM(itemobj) == false then
					local itemGrade = TryGetProp(itemobj, 'ItemGrade',0)
					if itemGrade <= 4 then
						table.insert(decomposibleList[itemGrade],invItem)
					end
				end
			end
    	end
	end, false, showAll);

	local heightMargin = 0;
	for i = 1,4 do
		local ctrlSet = GET_CHILD_RECURSIVELY(slotlist_bg, "itemSlotset"..i, "ui::CControlSet")
		local itemSlotSet = GET_CHILD_RECURSIVELY(ctrlSet, "itemSlotset", "ui::CSlotSet")
		
		local col = itemSlotSet:GetCol()
		local row = itemSlotSet:GetRow()
		
		local new_row = math.max(2,math.floor((#decomposibleList[i])/col)+BoolToNumber(#decomposibleList[i]%10~=0))
		itemSlotSet:SetSlotCount(col*new_row)
		itemSlotSet:AutoAdjustRow()
		itemSlotSet:SetSlotCount(MAX_SELECT)
		local margin = ctrlSet:GetMargin()
		ctrlSet:Resize(margin.left,margin.top+heightMargin, ctrlSet:GetWidth(),ctrlSet:GetHeight()+(itemSlotSet:GetRow()-row)*52)
		heightMargin = heightMargin + (itemSlotSet:GetRow()-row)*52;

		for j = 1,#decomposibleList[i] do
			local invItem = decomposibleList[i][j]
			local itemobj = GetIES(invItem:GetObject());
			local itemGrade = TryGetProp(itemobj, 'ItemGrade',0);
			if itemGrade > 0 and itemGrade < 5 then
				local itemSlotCnt = j-1;
				local itemSlot = itemSlotSet:GetSlotByIndex(itemSlotCnt)
				if itemSlot ~= nil then
					local icon = CreateIcon(itemSlot);
					icon:Set(itemobj.Icon, 'Item', invItem.type, itemSlotCnt, invItem:GetIESID());
					local class = GetClassByType('Item', invItem.type);
					SET_SLOT_STYLESET(itemSlot, itemobj)
					ICON_SET_INVENTORY_TOOLTIP(icon, invItem, nil, class);
				end
			end
		end
	end
	local selectAllBox = GET_CHILD_RECURSIVELY(frame,"selectAll")
	ITEM_DECOMPOSE_ALL_SELECT_BTN_DOWN(frame,selectAllBox,"",0)
end

function TOGGLE_DECOMPOSE_RESULT(frame,isShow)
    local frame = frame:GetTopParentFrame();
    local slotgb = GET_CHILD_RECURSIVELY(frame, "slotgb", "ui::CGroupBox");
	slotgb:ShowWindow(isShow);
	
	if frame:GetHeight() < 1360 then
		local decompose_bg = GET_CHILD_RECURSIVELY(frame, "decompose_bg", "ui::CGroupBox")
		decompose_bg:ShowWindow(1-isShow);
	end
end

--select
function ITEM_DECOMPOSE_SLOT_LBTDOWN(frame, ctrl)
	frame = frame:GetTopParentFrame()
	TOGGLE_DECOMPOSE_RESULT(frame,0)
	ITEM_DECOMPOSE_UPDATE(frame)
end

function ITEM_DECOMPOSE_ALL_SELECT_BTN_DOWN(frame, ctrl, argStr,isselected)
	if isselected == 1 then
		ITEM_DECOMPOSE_SELECT_ALL(frame, ctrl)
	else
		ITEM_DECOMPOSE_DESELECT_ALL(frame, ctrl)
	end
	ITEM_DECOMPOSE_UPDATE(frame)
	ITEM_DECOMPOSE_SET_ALL_SELECT_STATE(ctrl,isselected)
end

function ITEM_DECOMPOSE_SET_ALL_SELECT_STATE(ctrl,isselected)
	isselected = 1 - isselected
	ctrl:SetEventScriptArgNumber(ui.LBUTTONDOWN,isselected)
	local font = "{@st66}"
	if isselected == 1 then
		ctrl:SetText(font..ScpArgMsg("SelectAll"))
	else
		ctrl:SetText(font..ScpArgMsg("UnselectAll"))
	end
end

function ITEM_DECOMPOSE_SELECT_ALL(frame,ctrl)
	local cnt = ITEM_DECOMPOSE_GET_SELECT_COUNT(frame);
	if cnt > MAX_SELECT then
		return
	end
	for i = 1,4 do
		local checkBox = GET_CHILD_RECURSIVELY(frame, "check_grade"..i, "ui::CCheckBox") 
		if checkBox:IsChecked() == 1 then
			local ctrlSet = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "itemSlotset"..i, "ui::CControlSet")
			local slotSet = GET_CHILD_RECURSIVELY(ctrlSet, "itemSlotset", "ui::CSlotSet")
			local slotCount = slotSet:GetSlotCount();
			for j = 0, slotCount - 1 do 
				if cnt >= MAX_SELECT then
					break
				end
				local slot = slotSet:GetSlotByIndex(j);
				if slot:GetIcon() ~= nil and slot:IsSelected() == 0 then
					cnt = cnt + 1
					slot:Select(1)
				end
			end
			slotSet:MakeSelectionList()
		end
	end
end

function ITEM_DECOMPOSE_DESELECT_ALL(frame,ctrl)
	for i = 1,4 do
		local checkBox = GET_CHILD_RECURSIVELY(frame, "check_grade"..i, "ui::CCheckBox") 
		local ctrlSet = GET_CHILD_RECURSIVELY_AT_TOP(ctrl, "itemSlotset"..i, "ui::CControlSet")
		local slotSet = GET_CHILD_RECURSIVELY(ctrlSet, "itemSlotset", "ui::CSlotSet")
		local slotCount = slotSet:GetSlotCount();
		for j = 0, slotCount - 1 do 
			local slot = slotSet:GetSlotByIndex(j);
			if slot:GetIcon() ~= nil then
				slot:Select(0)
			end
		end
		slotSet:MakeSelectionList()
	end
end

function ITEM_DECOMPOSE_UPDATE_MONEY(frame)
	local frame = frame:GetTopParentFrame();
	local totalprice = 0;
    
	local groupName = frame:GetUserValue("GroupName");
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	
	local slotlist_bg = GET_CHILD_RECURSIVELY(frame, "slotlist_bg", "ui::CGroupBox")
	for i = 1,4 do
		local ctrlSet = GET_CHILD_RECURSIVELY(slotlist_bg, "itemSlotset"..i, "ui::CControlSet")
		local slotSet = GET_CHILD_RECURSIVELY(ctrlSet, "itemSlotset", "ui::CSlotSet")
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
	end
    
	local decomposeCost = GET_CHILD_RECURSIVELY_AT_TOP(frame, "decomposeCost", "ui::CRichText")
	decomposeCost:SetText(GET_COMMAED_STRING(totalprice))
    
	local calcprice = GET_CHILD_RECURSIVELY_AT_TOP(frame, "remainSilver", "ui::CRichText")
	if totalprice <= 0 then
		calcprice:SetText(GET_COMMAED_STRING(GET_TOTAL_MONEY_STR()))
		return;
	end
    
	local mymoney = GET_COMMAED_STRING(SumForBigNumberInt64(GET_TOTAL_MONEY_STR(), -1 * totalprice));
	calcprice:SetText(mymoney)
    
	frame:SetUserValue('TOTAL_MONEY', totalprice);
end

function DECOMPOSE_ITEM_MECHANICAL_SET(frame,ctrl)
	frame = frame:GetTopParentFrame()
	LOAD_ITEM_DECOMPOSE_ITEM_LIST(frame)
end

function ITEM_DECOMPOSE_GET_SELECT_COUNT(frame)
	local cnt = 0
	for i = 1,4 do
		local ctrlSet = GET_CHILD_RECURSIVELY_AT_TOP(frame, "itemSlotset"..i, "ui::CControlSet")
		local slotSet = GET_CHILD_RECURSIVELY(ctrlSet, "itemSlotset", "ui::CSlotSet")
		cnt = cnt + slotSet:GetSelectedSlotCount();
	end
	return cnt
end

function ITEM_DECOMPOSE_UPDATE(frame)
	ITEM_DECOMPOSE_UPDATE_MONEY(frame)
	local total = ITEM_DECOMPOSE_GET_SELECT_COUNT(frame)
	ITEM_DECOMPOSE_UPDATE_COUNT_TEXT(frame,total)
	if frame:GetUserValue("ENABLE_SLOT") == tostring(enable) then
		return
	end
	local enable = BoolToNumber(total < MAX_SELECT)
	for i = 1,4 do
		local ctrlSet = GET_CHILD_RECURSIVELY(frame, "itemSlotset"..i, "ui::CControlSet")
		local slotSet = GET_CHILD_RECURSIVELY(ctrlSet, "itemSlotset", "ui::CSlotSet")
		local slotCount = slotSet:GetSlotCount();
		for j = 0, slotCount - 1 do
			local slot = slotSet:GetSlotByIndex(j);
			if slot:IsSelected() == 0 or enable == 1 then
				slot:SetEnable(enable)
			end
		end
	end
	frame:SetUserValue("ENABLE_SLOT",tostring(enable))
end

function ITEM_DECOMPOSE_UPDATE_COUNT_TEXT(frame,total)
	local decomposecnt = GET_CHILD_RECURSIVELY(frame,'decomposecnt')
	decomposecnt:SetTextByKey('cnt',total)
	decomposecnt:SetTextByKey('max',MAX_SELECT)
end

--execute
function ITEM_DECOMPOSE_EXECUTE(frame)
	session.ResetItemList();

	local totalprice = 0;
	local totalCount = ITEM_DECOMPOSE_GET_SELECT_COUNT(frame);

	if totalCount < 1 then
		ui.MsgBox(ScpArgMsg("DON_T_HAVE_ITEM_TO_DECOMPOSE"))
		return;
	elseif totalCount > MAX_SELECT then
		ui.MsgBox(ScpArgMsg("EXCEED_SELECT_COUNT"))
		return
	end
	
	
	local itemCheckProp = { }
	itemCheckProp['Reinforce'] = false;
	itemCheckProp['Transcend'] = false;
	itemCheckProp['Awaken'] = false;
	itemCheckProp['EnchantOption'] = false;
	itemCheckProp['Socket_Equip'] = false;
	itemCheckProp['Socket_Add'] = false;
	
	local groupName = frame:GetUserValue("GroupName");
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	local taxRate = nil
	if groupInfo == nil then -- if not pc shop
		taxRate = GET_COLONY_TAX_RATE_CURRENT_MAP()
	end
	for slotsetidx = 1,4 do
		local ctrlSet = GET_CHILD_RECURSIVELY(frame, "itemSlotset"..slotsetidx, "ui::CControlSet")
		local slotSet = GET_CHILD_RECURSIVELY(ctrlSet, "itemSlotset", "ui::CSlotSet")
		for i = 0, slotSet:GetSelectedSlotCount() -1 do
			local slot = slotSet:GetSelectedSlot(i)
			local Icon = slot:GetIcon();
			local iconInfo = Icon:GetInfo();

			session.AddItemID(iconInfo:GetIESID());

			local invitem = GET_ITEM_BY_GUID(iconInfo:GetIESID());
			local itemobj = GetIES(invitem:GetObject());
			totalprice = totalprice + GET_DECOMPOSE_PRICE(itemobj, taxRate);
			
			do
				local itemReinforce = TryGetProp(itemobj, 'Reinforce_2',0);
				itemCheckProp['Reinforce'] = itemCheckProp['Reinforce'] or (itemReinforce > 0)
				
				local itemTranscend = TryGetProp(itemobj, 'Transcend',0);
				itemCheckProp['Transcend'] = itemCheckProp['Transcend'] or (itemTranscend > 0)
				
				local itemAwaken = TryGetProp(itemobj, 'IsAwaken',0);
				itemCheckProp['Awaken'] = itemCheckProp['Awaken'] or (itemAwaken > 0)
				
				local itemRareOption = TryGetProp(itemobj, 'RandomOptionRare','None');
				local itemRareOptionValue = TryGetProp(itemobj, 'RandomOptionRareValue');
				if itemRareOption ~= 'None' and itemRareOptionValue > 0 then
					itemCheckProp['EnchantOption'] = true
				end
				
				for j = 0, 4 do
					if invitem:GetEquipGemID(j) > 0 then
						itemCheckProp['Socket_Equip'] = true
						break;
					end
								
					if invitem:IsAvailableSocket(j) == true then
						itemCheckProp['Socket_Add'] = true
						break;
					end
				end
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
	
	local warningPropList = { };
	for key,val in pairs(itemCheckProp) do
		if val == true then
			warningPropList[#warningPropList + 1] = ScpArgMsg('ItemDecomposeWarningProp_' .. key);
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

--complete
function ITEM_DECOMPOSE_COMPLETE(...)
    local frame = ui.GetFrame("itemdecompose");
    if frame:IsVisible() == 1 then
        LOAD_ITEM_DECOMPOSE_ITEM_LIST(frame)
		TOGGLE_DECOMPOSE_RESULT(frame,1)
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

function ITEM_DECOMPOSE_RESULT_UI_OFF(ctrl,parent)
	TOGGLE_DECOMPOSE_RESULT(ctrl:GetTopParentFrame(),0)
end