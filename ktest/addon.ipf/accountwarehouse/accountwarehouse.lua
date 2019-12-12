local max_slot_per_tab = account_warehouse.get_max_slot_per_tab()
local current_tab_index = 0

function ACCOUNTWAREHOUSE_ON_INIT(addon, frame)
    addon:RegisterMsg("OPEN_DLG_ACCOUNTWAREHOUSE", "ON_OPEN_ACCOUNTWAREHOUSE");
    addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_LIST", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");
    addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_ADD", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");
    addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_REMOVE", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");
    addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_CHANGE_COUNT", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");
    addon:RegisterMsg("ACCOUNT_WAREHOUSE_ITEM_IN", "ON_ACCOUNT_WAREHOUSE_ITEM_LIST");
    addon:RegisterOpenOnlyMsg("ACCOUNT_WAREHOUSE_VIS", "ACCOUNT_WAREHOUSE_UPDATE_VIS_LOG");
    addon:RegisterMsg("UPDATE_COLONY_TAX_RATE_SET", "ON_ACCOUNT_WAREHOUSE_UPDATE_COLONY_TAX_RATE_SET");
end

local new_add_item = { }
local new_stack_add_item = { }

local function get_valid_index()    
    local itemList = session.GetEtcItemList(IT_ACCOUNT_WAREHOUSE);
    local guidList = itemList:GetGuidList();
    local sortedGuidList = itemList:GetSortedGuidList();    
    local sortedCnt = sortedGuidList:Count();    
    
    local start_index = (current_tab_index * max_slot_per_tab)
    local last_index =(start_index + max_slot_per_tab) -1
    
    local __set = {}
    for i = 0, sortedCnt - 1 do
        local guid = sortedGuidList:Get(i)
        if tostring(guid) ~= '0' then
            local invItem = itemList:GetItemByGuid(guid)        
            if start_index <= invItem.invIndex and invItem.invIndex <= last_index and __set[invItem.invIndex] == nil then
                __set[invItem.invIndex] = 1            
            end
        end
    end

    local index = start_index    
    for k, v in pairs(__set) do        
        if __set[index] ~= 1 then
            break
        else
            index = index + 1
        end    
    end
    
    return index
end


local function get_tab_index(item_inv_index)
    if item_inv_index < 0 then
        item_inv_index = 0
    end
    local index = math.floor(item_inv_index / max_slot_per_tab)
    return index
end

local function is_new_item(id)
    for k, v in pairs(new_add_item) do
        if v == id then
            return true
        end
    end
    return false
end

local function is_stack_new_item(class_id)
    for k, v in pairs(new_stack_add_item) do
        if v == class_id then
            return true
        end
    end
    return false
end

function ON_OPEN_ACCOUNTWAREHOUSE(frame)
    new_add_item = { }
    new_stack_add_item = { }
    ui.OpenFrame("accountwarehouse");
end

function ACCOUNTWAREHOUSE_OPEN(frame)
    ui.OpenFrame("inventory");
    packet.RequestItemList(IT_ACCOUNT_WAREHOUSE);
    ui.EnableSlotMultiSelect(1);
    INVENTORY_SET_CUSTOM_RBTNDOWN("ACCOUNT_WAREHOUSE_INV_RBTN")
    packet.RequestAccountWareVisLog();
    session.inventory.ReqAccountWareHouseLimitAmount();
    new_add_item = { }
    new_stack_add_item = { }

    ACCOUNT_WAREHOUSE_MAKE_TAB(frame);

end
   
function ACCOUNTWAREHOUSE_CLOSE(frame)
    ui.EnableSlotMultiSelect(0);
    ui.CloseFrame("inventory");
    INVENTORY_SET_CUSTOM_RBTNDOWN("None");
    TRADE_DIALOG_CLOSE();
    new_add_item = { }
    new_stack_add_item = { }
end

function ON_ACCOUNT_WAREHOUSE_UPDATE_COLONY_TAX_RATE_SET(frame)
    CLOSE_MSGBOX_BY_NON_NESTED_KEY("EXTEND_ACCOUNT_WAREHOUSE");
end

local function _CHECK_ACCOUNT_WAREHOUSE_SLOT_COUNT_TO_PUT(insertItem)    
    local index = get_valid_index()    
    local account = session.barrack.GetMyAccount();
    local slotCount = account:GetAccountWarehouseSlotCount();
    local itemList = session.GetEtcItemList(IT_ACCOUNT_WAREHOUSE);
    local itemCnt = 0;
    local guidList = itemList:GetGuidList();
    local cnt = guidList:Count();
    for i = 0, cnt - 1 do
        local guid = guidList:Get(i);
        local invItem = itemList:GetItemByGuid(guid);
        local obj = GetIES(invItem:GetObject());
        if insertItem == nil then
            if obj.ClassName ~= MONEY_NAME and invItem.invIndex < max_slot_per_tab then
                itemCnt = itemCnt + 1;
            end
        else
            if obj.ClassName ~= MONEY_NAME and insertItem.ClassName ~= obj.ClassName and invItem.invIndex < max_slot_per_tab then
                itemCnt = itemCnt + 1;
            end
        end
    end
    
    if slotCount <= index and index < max_slot_per_tab then
        ui.SysMsg(ClMsg('CannotPutBecauseMasSlot'));
        return false;
    end
    return true;
end

function GET_WAREHOUSE_INDEX(invItem)
    local insertItem = GetIES(invItem:GetObject())
    local account = session.barrack.GetMyAccount();
    local slotCount = account:GetAccountWarehouseSlotCount();
    local itemList = session.GetEtcItemList(IT_ACCOUNT_WAREHOUSE);
    local itemCnt = 0;
    local guidList = itemList:GetGuidList();
    local cnt = guidList:Count();

    for i = 0, cnt - 1 do
        local guid = guidList:Get(i);
        local invItem = itemList:GetItemByGuid(guid);
        local obj = GetIES(invItem:GetObject());
        if insertItem == nil then
            if obj.ClassName ~= MONEY_NAME then
                itemCnt = itemCnt + 1;
            end
        else
            if obj.ClassName ~= MONEY_NAME then
                itemCnt = itemCnt + 1;
            end
        end
    end

    return itemCnt + 1
end

function PUT_ACCOUNT_ITEM_TO_WAREHOUSE_BY_INVITEM(frame, invItem, slot, fromFrame)
    local obj = GetIES(invItem:GetObject())
    if _CHECK_ACCOUNT_WAREHOUSE_SLOT_COUNT_TO_PUT(obj) == false then
        return;
    end

    if CHECK_EMPTYSLOT(frame, obj) == 1 then
        return
    end

    if true == invItem.isLockState then
        ui.SysMsg(ClMsg("MaterialItemIsLock"));
        return;
    end

    local itemCls = GetClassByType("Item", invItem.type);
    if itemCls.ItemType == 'Quest' then
        ui.MsgBox(ScpArgMsg("IT_ISNT_REINFORCEABLE_ITEM"));
        return;
    end

    local enableTeamTrade = TryGetProp(itemCls, "TeamTrade");
    if enableTeamTrade ~= nil and enableTeamTrade == "NO" then
        ui.SysMsg(ClMsg("ItemIsNotTradable"));
        return;
    end

    if fromFrame:GetName() == "inventory" then
        local maxCnt = invItem.count;
        if TryGetProp(obj, "BelongingCount") ~= nil then
            maxCnt = invItem.count - obj.BelongingCount;
            if maxCnt <= 0 then
                maxCnt = 0;
            end
        end

        if invItem.count > 1 then
            INPUT_NUMBER_BOX(frame, ScpArgMsg("InputCount"), "EXEC_PUT_ITEM_TO_ACCOUNT_WAREHOUSE", maxCnt, 1, maxCnt, nil, tostring(invItem:GetIESID()));
        else
            if maxCnt <= 0 then
                ui.SysMsg(ClMsg("ItemIsNotTradable"));
                return;
            end

            local slotset = GET_CHILD_RECURSIVELY(frame, 'slotset');
            local goal_index = get_valid_index()                  
            if invItem.hasLifeTime == true then
                local yesscp = string.format('item.PutItemToWarehouse(%d, "%s", "%s", %d, %d)', IT_ACCOUNT_WAREHOUSE, invItem:GetIESID(), tostring(invItem.count), frame:GetUserIValue('HANDLE'), goal_index);
                ui.MsgBox(ScpArgMsg('PutLifeTimeItemInWareHouse{NAME}', 'NAME', itemCls.Name), yesscp, 'None');
                return;
            end

            -- 여기서 아이템 입고 요청
            item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, invItem:GetIESID(), tostring(invItem.count), frame:GetUserIValue("HANDLE"), goal_index)
            new_add_item[#new_add_item + 1] = invItem:GetIESID()

            if geItemTable.IsStack(obj.ClassID) == 1 then
                new_stack_add_item[#new_stack_add_item + 1] = obj.ClassID
            end
        end
    else
        if slot ~= nil then
            AUTO_CAST(slot);
            local iconSlot = liftIcon:GetParent();
            AUTO_CAST(iconSlot);
            item.SwapSlotIndex(IT_ACCOUNT_WAREHOUSE, slot:GetSlotIndex(), iconSlot:GetSlotIndex());
            ON_ACCOUNT_WAREHOUSE_ITEM_LIST(frame);
        end
    end
end

-- 창고에 드래그 앤 드랍
function PUT_ACCOUNT_ITEM_TO_WAREHOUSE(parent, slot)
    local frame = parent:GetTopParentFrame();
    local liftIcon = ui.GetLiftIcon();
    local iconInfo = liftIcon:GetInfo();
    local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
    if invItem == nil then
        return;
    end

    local fromFrame = liftIcon:GetTopParentFrame();
    PUT_ACCOUNT_ITEM_TO_WAREHOUSE_BY_INVITEM(frame, invItem, slot, fromFrame);
end

function EXEC_PUT_ITEM_TO_ACCOUNT_WAREHOUSE(frame, count, inputframe)
    inputframe:ShowWindow(0);
    local iesid = inputframe:GetUserValue("ArgString");
    local insertItem = GetObjectByGuid(iesid);
    if _CHECK_ACCOUNT_WAREHOUSE_SLOT_COUNT_TO_PUT(insertItem) == false then
        return;
    end

    local slotset = GET_CHILD_RECURSIVELY(frame, 'slotset');
    local goal_index = get_valid_index()    
    item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, iesid, tostring(count), frame:GetUserIValue("HANDLE"), goal_index);
    new_add_item[#new_add_item + 1] = iesid
    if geItemTable.IsStack(insertItem.ClassID) == 1 then
        new_stack_add_item[#new_stack_add_item + 1] = insertItem.ClassID
    end
end

function ACCOUNT_WAREHOUSE_SLOT_RESET(frame, slot)
    slot:SelectBySlotset(false);
end

function ON_ACCOUNT_WAREHOUSE_ITEM_LIST(frame, msg, argStr, argNum, tab_index)    
    if tab_index == nil then
        tab_index = current_tab_index
    end

    if msg == 'ACCOUNT_WAREHOUSE_ITEM_ADD' then
        tab_index = get_tab_index(argNum)
        if argNum == 0 and tab_index == 0 then
            tab_index = current_tab_index
        end
    end

    current_tab_index = tab_index

    if frame:IsVisible() == 0 then
        new_add_item = { }
        new_stack_add_item = { }
        return
    end

    local slotset = GET_CHILD_RECURSIVELY(frame, 'slotset');
    local gbox_warehouse = GET_CHILD_RECURSIVELY(frame, "gbox_warehouse");
	if slotset == nil then
        slotset = GET_CHILD_RECURSIVELY(frame, "slotset");
    end

    AUTO_CAST(slotset);
    slotset:ClearIconAll();
    slotset:SetSkinName('accountwarehouse_slot');

    local function _DRAW_ITEM(invItem, slotset, saveMoney)
        local obj = GetIES(invItem:GetObject());
        if obj.ClassName == MONEY_NAME then
            saveMoney:SetTextByKey('value', GetCommaedText(invItem.count))
        else
            local slotIndx = imcSlot:GetEmptySlotIndex(slotset);
            local slot = slotset:GetSlotByIndex(slotIndx)
            if slot == nil then
                slot = GET_EMPTY_SLOT(slotset, current_tab_index, max_slot_per_tab);
            end

            slot:SetSkinName('invenslot2')
            local itemCls = GetIES(invItem:GetObject());
            local iconImg = GET_ITEM_ICON_IMAGE(itemCls);

            if is_new_item(invItem:GetIESID()) == true or is_stack_new_item(obj.ClassID) then
                slot:SetHeaderImage('new_inventory_icon')
            else
                slot:SetHeaderImage('None')
            end

            SET_SLOT_IMG(slot, iconImg)
            SET_SLOT_COUNT(slot, invItem.count)

            SET_SLOT_STYLESET(slot, itemCls)
            SET_SLOT_IESID(slot, invItem:GetIESID())
            SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, obj, nil)
            slot:SetMaxSelectCount(invItem.count);
            local icon = slot:GetIcon();
            icon:SetTooltipArg("accountwarehouse", invItem.type, invItem:GetIESID());
            SET_ITEM_TOOLTIP_TYPE(icon, itemCls.ClassID, itemCls, "accountwarehouse");

            if invItem.hasLifeTime == true then
                ICON_SET_ITEM_REMAIN_LIFETIME(icon, IT_ACCOUNT_WAREHOUSE);
                slot:SetFrontImage('clock_inven');
            else
                CLEAR_ICON_REMAIN_LIFETIME(slot, icon);
            end
        end
    end

    local itemList = session.GetEtcItemList(IT_ACCOUNT_WAREHOUSE);
    local guidList = itemList:GetGuidList();
    local sortedGuidList = itemList:GetSortedGuidList();
    local isShowMap = { };
    local sortedCnt = sortedGuidList:Count();
    local saveMoney = GET_CHILD_RECURSIVELY(frame, "saveMoney");
    saveMoney:SetTextByKey('value', 0);

    local start_index = (tab_index * max_slot_per_tab)
    local last_index =(start_index + max_slot_per_tab) -1
    for i = 0, sortedCnt - 1 do
        local guid = sortedGuidList:Get(i);
        local invItem = itemList:GetItemByGuid(guid);
        -- 현재 탭이 몇번이냐에 따라 그려주는 index의 번호를 선택해야 한다.            
        if start_index <= invItem.invIndex and invItem.invIndex <= last_index then
            _DRAW_ITEM(invItem, slotset, saveMoney);
            isShowMap[guid] = true;
        end
    end

    -- 아이템이 없어도 사용가능한 슬롯이면 스킨 변경
    local slotIndx = imcSlot:GetEmptySlotIndex(slotset);
    
    local is_item_full = false
    if current_tab_index > 0 then
        local slot_1 = GET_EMPTY_SLOT(slotset, current_tab_index, max_slot_per_tab);
        if slot_1 == nil then
            is_item_full = true
        end        
    end
    
    local itemCnt = slotIndx;    
    local account = session.barrack.GetMyAccount();
    local slotCount = account:GetAccountWarehouseSlotCount();
    local availableTakeCount = math.max(slotCount, slotIndx);
    
    -- 추가 슬롯 음영 관련
    local pc = GetMyPCObject()
    if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) and current_tab_index >= 1 then
        availableTakeCount = max_slot_per_tab
        slotCount = max_slot_per_tab
--    elseif IsBuffApplied(pc, 'light_account_warehouse_ticket') == 'YES' and current_tab_index > 0 and current_tab_index <= account_warehouse.get_max_tab() then
--        availableTakeCount = max_slot_per_tab
--        slotCount = max_slot_per_tab
    elseif current_tab_index >= 1 then
        for i = slotIndx, availableTakeCount - 1 do
            local slot = slotset:GetSlotByIndex(i);
            if slot ~= nil then
                slot:RemoveAllChild();
            end
        end
        availableTakeCount = 0
        slotCount = 0
    end

    for i = slotIndx, availableTakeCount - 1 do
        local slot = slotset:GetSlotByIndex(i);
        if slot ~= nil then
            slot:SetSkinName('invenslot2');
            slot:RemoveAllChild();
        end
    end

    local itemcnt = GET_CHILD_RECURSIVELY(frame, "itemcnt");

    if is_item_full == true and itemCnt == 0 then
        itemCnt = max_slot_per_tab
    end

    local currentItemCnt = string.format('%d', itemCnt);    
    if itemCnt > slotCount then
        local EXCEED_SLOT_FONT_COLOR = frame:GetUserConfig('EXCEED_SLOT_FONT_COLOR');
        currentItemCnt = '{#' .. EXCEED_SLOT_FONT_COLOR .. '}' .. currentItemCnt .. '{/}';
    end

    itemcnt:SetTextByKey('cnt', currentItemCnt);
    itemcnt:SetTextByKey('slotmax', slotCount);

    if gbox_warehouse ~= nil then
        gbox_warehouse:UpdateData();
        gbox_warehouse:SetCurLine(0);
        gbox_warehouse:InvalidateScrollBar();
        frame:Invalidate();
    end

    ACCOUNT_WAREHOUSE_UPDATE_VIS_LOG(frame)
end

function ACCOUNT_WAREHOUSE_UPDATE_VIS_LOG(frame)
    local gbox = GET_CHILD_RECURSIVELY(frame, 'visgBox')
    gbox:RemoveAllChild();
    local cnt = session.AccountWarehouse.GetCount();

    for i = cnt - 1, 0, -1 do
        local log = session.AccountWarehouse.GetByIndex(i);
        local ctrlSet = gbox:CreateControlSet("AccountVisLog", "CTRLSET_" .. i, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
        local sTime = imcTime.GetStringSysTimeYYMMDD(log.regTime);
        local regTime = ctrlSet:GetChild('regTime')
        regTime:SetTextByKey('value', sTime);
        local withdrawVis = ctrlSet:GetChild('withdrawVis')
        local inputVis = ctrlSet:GetChild('inputVis')
        local inputPic = GET_CHILD(ctrlSet, "input", "ui::CPicture");
        if log.takeout == false then
            withdrawVis:ShowWindow(0);
            inputVis:SetTextByKey('value', log:GetAmount());
            inputPic:SetImage('in_arrow');
        else
            inputVis:ShowWindow(0);
            withdrawVis:SetTextByKey('value', log:GetAmount());
            inputPic:SetImage('chul_arrow');
        end

        local result = ctrlSet:GetChild('result')
        result:SetTextByKey('value', log:GetTotalAmount());
    end

    GBOX_AUTO_ALIGN(gbox, 0, 3, 10, true, false);
end

function ACCOUNT_WAREHOUSE_RECEIVE_ITEM(parent, slot)
    local frame = parent:GetTopParentFrame();
    local slotset = GET_CHILD_RECURSIVELY(frame, "slotset");
    if slotset == nil then
        local gbox_warehouse = GET_CHILD_RECURSIVELY(frame, "gbox_warehouse");
        slotset = GET_CHILD_RECURSIVELY(frame, "slotset");
    end
    session.ResetItemList();
    AUTO_CAST(slotset);
    for i = 0, slotset:GetSelectedSlotCount() -1 do
        local slot = slotset:GetSelectedSlot(i)
        local Icon = slot:GetIcon();
        local iconInfo = Icon:GetInfo();

        session.AddItemID(iconInfo:GetIESID(), slot:GetSelectCount());

    end

    if session.GetItemIDList():Count() == 0 then
        ui.MsgBox(ScpArgMsg("SelectItemByMouseLeftButton"));
        return;
    end

    DISABLE_BUTTON_DOUBLECLICK("accountwarehouse", "receiveitem")
    local str = ScpArgMsg("TradeCountWillBeConsumedBy{Value}_Continue?", "Value", "1");
    ui.MsgBox(str, "_EXEC_ACCOUNT_WAREHOUSE_RECEIVE_ITEM", "None");

end

function _EXEC_ACCOUNT_WAREHOUSE_RECEIVE_ITEM()
    local frame = ui.GetFrame("accountwarehouse");
    item.TakeItemFromWarehouse_List(IT_ACCOUNT_WAREHOUSE, session.GetItemIDList(), frame:GetUserIValue("HANDLE"));
end

function ACCOUNT_WAREHOUSE_WITHDRAW(frame, slot)
    frame = frame:GetTopParentFrame();
    local moneyInput = GET_CHILD_RECURSIVELY(frame, 'moneyInput');
    local price = GET_NOT_COMMAED_NUMBER(moneyInput:GetText());
    AUTO_CAST(moneyInput);
    if price <= 0 then
        moneyInput:SetText('0');
        ui.MsgBox(ClMsg("InputPriceMoreThanOne"));
        return;
    end

    local itemList = session.GetEtcItemList(IT_ACCOUNT_WAREHOUSE);
    local cnt, visItemList = GET_INV_ITEM_COUNT_BY_PROPERTY( { { Name = 'ClassName', Value = MONEY_NAME } }, false, itemList);
    local visItem = visItemList[1];
    if visItem == nil then
        moneyInput:SetText('0');
        ui.MsgBox(ClMsg("NotEnoughStoredMoney"));
        return;
    end

    if IsGreaterThanForBigNumber(price, visItem:GetAmountStr()) == 1 then
        moneyInput:SetText('0');
        ui.MsgBox(ClMsg("NotEnoughStoredMoney"));
        return;
    end
    session.ResetItemList();
    session.AddItemIDWithAmount(visItem:GetIESID(), tostring(price));
    item.TakeItemFromWarehouse_List(IT_ACCOUNT_WAREHOUSE, session.GetItemIDList(), frame:GetUserIValue("HANDLE"));
    moneyInput:SetText('0');
    DISABLE_BUTTON_DOUBLECLICK("accountwarehouse", "Withdraw")
end

function ACCOUNT_WAREHOUSE_DEPOSIT(frame, slot)
    frame = frame:GetTopParentFrame();
    local moneyInput = GET_CHILD_RECURSIVELY(frame, 'moneyInput');
    local price = GET_NOT_COMMAED_NUMBER(moneyInput:GetText());
    AUTO_CAST(moneyInput);
    if price <= 0 then
        moneyInput:SetText('0');
        ui.MsgBox(ClMsg("InputPriceMoreThanOne"));
        return;
    end

    local visItem = session.GetInvItemByName(MONEY_NAME)
    if visItem == nil then
        moneyInput:SetText('0');
        ui.MsgBox(ClMsg("NOT_ENOUGH_MONEY"));
        return;
    end

    if IsGreaterThanForBigNumber(price, GET_TOTAL_MONEY_STR()) == 1 then
        moneyInput:SetTempText('0');
        ui.MsgBox(ClMsg("NOT_ENOUGH_MONEY"));
        return;
    end

    item.PutItemToWarehouse(IT_ACCOUNT_WAREHOUSE, visItem:GetIESID(), tostring(price), frame:GetUserIValue("HANDLE"));
    moneyInput:SetText('0');
    DISABLE_BUTTON_DOUBLECLICK("accountwarehouse", "Deposit")
end

function ACCOUNT_WAREHOUSE_EXTEND(parent, slot)
    local frame = parent:GetTopParentFrame();
    local STYLE_TAX_RATE = frame:GetUserConfig("STYLE_TAX_RATE");
    local START_TAX_RATE = frame:GetUserConfig("START_TAX_RATE");
    local END_TAX_RATE = frame:GetUserConfig("END_TAX_RATE");
    local TAX_ICON_WIDTH = frame:GetUserConfig("TAX_ICON_WIDTH");
    local TAX_ICON_HEIGHT = frame:GetUserConfig("TAX_ICON_HEIGHT");

    local aObj = GetMyAccountObj();
    if nil == aObj then
        return;
    end

    local price = GET_ACCOUNT_WAREHOUSE_EXTEND_PRICE(aObj, GET_COLONY_TAX_RATE_CURRENT_MAP())
    if price == nil then -- 추가 창고 슬롯 맥스
        ui.SysMsg(ScpArgMsg("ExceedAdditionalAccountwarehouse"))
        return
    end
    
    local str = ScpArgMsg("ExtendWarehouseSlot{Silver}{SLOT}", "Silver", GetCommaedText(price), "SLOT", 1);

    if session.colonytax.IsEnabledColonyTaxShop() == true then
    	local curMapID = session.GetMapID()
    	local cityMapID = session.colonytax.GetColonyCityID(curMapID)
    	local taxRateInfo = session.colonytax.GetColonyTaxRate(cityMapID)
    	if taxRateInfo ~= nil then
            str = str .. string.format("%s%s%s%s%s", STYLE_TAX_RATE, START_TAX_RATE, GET_COLONY_TAX_APPLIED_STRING(true, TAX_ICON_WIDTH, TAX_ICON_HEIGHT), END_TAX_RATE, "{/}");
        end
    end
    local yesScp = string.format("CHECK_USER_MEDAL_FOR_EXTEND_ACCOUNT_WAREHOUSE(%d)", price)
    local msgBox = ui.MsgBox_NonNested(str, "EXTEND_ACCOUNT_WAREHOUSE", yesScp, "None");

    DISABLE_BUTTON_DOUBLECLICK("accountwarehouse", "extend")

end

function CHECK_USER_MEDAL_FOR_EXTEND_ACCOUNT_WAREHOUSE(price)
    if IsGreaterThanForBigNumber(price, GET_TOTAL_MONEY_STR()) == 1 then
        ui.SysMsg(ScpArgMsg("NotEnoughMoney"))
        return;
    end

    item.ExtendWareHouse(IT_ACCOUNT_WAREHOUSE);
end

function ACCOUNT_WAREHOUSE_INV_RBTN(itemObj, slot)
    local frame = ui.GetFrame("accountwarehouse");
    local icon = slot:GetIcon();
    local iconInfo = icon:GetInfo();
    local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
    local obj = GetIES(invItem:GetObject());
    if CHECK_EMPTYSLOT(frame, obj) == 1 then
        return
    end

    local fromFrame = slot:GetTopParentFrame();
    if fromFrame:GetName() == "inventory" then
        PUT_ACCOUNT_ITEM_TO_WAREHOUSE_BY_INVITEM(frame, invItem, nil, fromFrame)
    end
end

-------------- 팀 창고 탭 기능 추가

-- 탭 생성
function ACCOUNT_WAREHOUSE_MAKE_TAB(frame)
    local accountwarehouse_tab = GET_CHILD_RECURSIVELY(frame, "accountwarehouse_tab");
    if accountwarehouse_tab == nil then
        return;
    end

    local tab_width = frame:GetUserConfig("WAREHOUSE_TAB_WIDTH");
    local tab_height = frame:GetUserConfig("WAREHOUSE_TAB_HEIGHT");
    local tab_x = frame:GetUserConfig("WAREHOUSE_TAB_X");
    local tab_y = frame:GetUserConfig("WAREHOUSE_TAB_Y");
    local width = frame:GetUserConfig("TAB_WIDTH");

    local addTabInfoList = ACCOUNT_WAREHOUSE_GET_TAB_INFO_LIST();

    local gblist = UI_LIB_TAB_ADD_TAB_LIST(frame, accountwarehouse_tab, addTabInfoList, tab_width, tab_height, ui.CENTER_HORZ, ui.TOP, tab_x, tab_y, "account_warehouse_tab_box", "true", tab_width, "tab_name");
    for i = 1, #gblist do
        local gb = gblist[i];
        gb:SetTabChangeScp("ACCOUNT_WAREHOUSE_ON_CHANGE_TAB");
    end

    ACCOUNT_WAREHOUSE_ON_CHANGE_TAB(frame);
    frame:SetUserValue("CLICK_ACCOUNT_WAREHOUSE_ACTIVE_TIME", imcTime.GetAppTime());
end

-- 팀 창고 정보 리스트 설정
function ACCOUNT_WAREHOUSE_GET_TAB_INFO_LIST()
    local list = { }

    -- 기본 창고
    list[#list + 1] = UI_LIB_TAB_GET_ADD_TAB_INFO("tab_0", "gb_0", "{@st66b}" .. ClMsg('BasicAccountWarehouse'), ClMsg('BasicAccountWarehouse'), false);

    -- 추가 창고
    local cnt = account_warehouse.get_max_tab()
    -- 계정에 접근해서 갯수 받아오기
    for i = 1, cnt do
        list[#list + 1] = UI_LIB_TAB_GET_ADD_TAB_INFO("tab_" .. i, "gb_" .. i, "{@st66b}" .. ClMsg('AdditionalAccountWarehouse') .. tostring(i), ClMsg('AdditionalAccountWarehouse') .. tostring(i), false);
    end

    return list;
end

-- 탭 체인지
function ACCOUNT_WAREHOUSE_ON_CHANGE_TAB(frame)
    local accountwarehouse_tab = GET_CHILD_RECURSIVELY(frame, "accountwarehouse_tab");
    if accountwarehouse_tab == nil then
        return;
    end

    local gb, tab_index = ACCOUNT_WAREHOUSE_GET_SELECTED_TAB_GROUPBOX(frame);
    local tab_name = gb:GetUserValue("tab_name");
    ACCOUNT_WAREHOUSE_GET_FILL_GB(gb, tab_name, tab_index)
end

-- 선택한 탭의 그룹박스 
function ACCOUNT_WAREHOUSE_GET_SELECTED_TAB_GROUPBOX(frame)
    local accountwarehouse_tab = GET_CHILD_RECURSIVELY(frame, "accountwarehouse_tab");
    if accountwarehouse_tab == nil or accountwarehouse_tab:GetItemCount() <= 0 then
        return;
    end

    local tab_index = accountwarehouse_tab:GetSelectItemIndex();
    local gb = GET_CHILD_RECURSIVELY(frame, "gb_" .. tab_index);

    return gb, tab_index;
end

-- 선택한 탭과 관련된 내용 수정 함수
function ACCOUNT_WAREHOUSE_GET_FILL_GB(gb, tab_name, tab_index)
    local frame = ui.GetFrame("accountwarehouse")

    local richtext_1 = GET_CHILD_RECURSIVELY(frame, "richtext_1");
    richtext_1:SetTextByKey("tab_name", tab_name);

    -- 아이템 갯수 변경
    ON_ACCOUNT_WAREHOUSE_ITEM_LIST(frame, nil, nil, 0, tab_index)
    -- 버튼 클릭 이벤트 함수 변경

    -- slotset 내용 변경
end