--guildinfo_joint_inventory.lua
local json = require "json_imc"

function GUILDINFO_JOINT_INVENTORY_LOAD()
    local guildObj = GET_MY_GUILD_OBJECT();
    if guildObj ~= nil then
        local propertyValue = TryGetProp(guildObj, 'GUILD_QUEST_CLEAR_COUNT', 0)
        if guildObj.Level < 8 or propertyValue < 12 then
            addon.BroadMsg("NOTICE_Dm_scroll", ScpArgMsg("GUILD_INVENTORY_MSG1","NUM1",guildObj.Level,"NUM2",propertyValue), 10);
        end
    end
    control.CustomCommand("REQ_GUILD_JOINT_INV_LIST", 0);
    local curTime = geTime.GetServerSystemTime();

    curTime = imcTime.AddSec(curTime, -10800) -- 3시간
    local curSysTimeStr = string.format("%04d-%02d-%02d %02d:%02d:%02d", curTime.wYear, curTime.wMonth, curTime.wDay, curTime.wHour, curTime.wMinute, curTime.wSecond)
    GetGuildWareHouseLog("ON_GUILD_WAREHOUSE_GET", curSysTimeStr)

    local itemDateText = GET_CHILD_RECURSIVELY(ui.GetFrame("guildinfo"), "itemDateText")
    if GetServerNation() == 'GLOBAL' or GetServerNation() == 'THI' then
        itemDateText:SetText('Time')
    end

    local slotCnt = JOINT_INVENTORY_SLOT_COUNT()
   
    local frame = ui.GetFrame("guildinfo")
    local itemSlotSet = GET_CHILD_RECURSIVELY(frame, "guildItemSlotset")

    AUTO_CAST(itemSlotSet);
    local rowCount = slotCnt / itemSlotSet:GetCol();
    itemSlotSet:SetColRow(itemSlotSet:GetCol(), rowCount)
    itemSlotSet:RemoveAllChild()
    itemSlotSet:CreateSlots()

end

function JOINT_INVENTORY_SLOT_COUNT()
    local guildObj = GET_MY_GUILD_OBJECT();
    local slotCount = 40
    local level = guildObj.Level;
    
    if level >= 20 then
        slotCount = 70
    elseif level >= 15 then
        slotCount = 60
    elseif level >= 10 then
        slotCount = 50
    end
    
    if slotCount > GUILD_JOINT_INV_MAX_SLOT_COUNT then
       slotCount = GUILD_JOINT_INV_MAX_SLOT_COUNT
    end
    return slotCount;
end

function ON_GUILD_WAREHOUSE_GET(code, ret_json)
    if code ~= 200 then -- 400:사용한 내역이 없음
        if code ~= 400 then
            SHOW_GUILD_HTTP_ERROR(code, ret_json, "ON_GUILD_WAREHOUSE_GET")
        end
        return
    end

    local frame = ui.GetFrame("guildinfo")
    local itemLogBox = GET_CHILD_RECURSIVELY(frame, "itemLogBox")

    itemLogBox:RemoveAllChild()
    local parsed_json = json.decode(ret_json)
    local i=1;
    for i=1, #parsed_json do
        local element = parsed_json[#parsed_json - i + 1];

        local ctrlSet = itemLogBox:CreateOrGetControlSet("guild_joint_inventory_log", i, 0, 0)
        ctrlSet = AUTO_CAST(ctrlSet);

        local dateText = GET_CHILD_RECURSIVELY(ctrlSet, "dateText")
        dateText:SetTextByKey("date", element["reg_time"])

        if element["set_type"] == "take" then
            dateText:SetTextByKey("img", ctrlSet:GetUserConfig("WITHDRAW_IMG"))
            dateText:SetMargin(12, 8, 0, 0)
            ctrlSet:SetUserValue("type", "take")
        elseif element["set_type"] == "put" then
            dateText:SetTextByKey("img", ctrlSet:GetUserConfig("DEPOSIT_IMG"))
            dateText:SetMargin(0, 0, 0, 0)
            ctrlSet:SetUserValue("type", "put")
        end

        local teamName = GET_CHILD_RECURSIVELY(ctrlSet, "teamName")
        teamName:SetTextByKey("name", element["team_name"])

        local cls = GetClassByType("Item", element["item_class"])
        local itemName = GET_CHILD_RECURSIVELY(ctrlSet, "itemName")
        itemName:SetTextByKey("name", cls.Name)
        if itemName:IsTextOmitted() == true then
            itemName:SetTextTooltip(cls.Name)
        end
        local count = GET_CHILD_RECURSIVELY(ctrlSet, "itemCount")
        count:SetTextByKey("count", element["count"])
        ctrlSet:Resize(itemLogBox:GetWidth(), ctrlSet:GetHeight())
        ctrlSet:Invalidate()
    end

    GBOX_AUTO_ALIGN(itemLogBox, 0, 0, 0, true, false, true)
end

function ON_GUILD_JOINT_INV_ITEM_LIST_GET(frame, msg, strArg, numArg)
    local itemSlotSet = GET_CHILD_RECURSIVELY(frame, "guildItemSlotset")
    itemSlotSet:ClearIconAll()
    local itemList = session.GetEtcItemList(IT_GUILD_JOINT);
    FOR_EACH_INVENTORY(itemList, function(invItemList, invItem, itemSlotSet)
		local itemCls = GetIES(invItem:GetObject());
        local iconImg = GET_ITEM_ICON_IMAGE(itemCls);
        local slot = itemSlotSet:GetSlotByIndex(invItem.invIndex);
        if slot == nil then
            slot = GET_EMPTY_SLOT(itemSlotSet);
        end
        
        SET_SLOT_IMG(slot, iconImg);
        SET_SLOT_COUNT(slot, invItem.count);
        SET_SLOT_COUNT_TEXT(slot, invItem.count);
        SET_SLOT_IESID(slot, invItem:GetIESID());
        SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, itemCls, nil);        
        SET_ITEM_TOOLTIP_ALL_TYPE(slot:GetIcon(), invItem, itemCls.ClassName, 'guildwarehouse', itemCls.ClassID, invItem:GetIESID());        
        slot:ShowWindow(1)
    end, false, itemSlotSet);

    control.CustomCommand("REQ_GUILD_MILEAGE_AMOUNT", 0);
    
    local itemLogDate = GET_CHILD_RECURSIVELY(frame, "itemLogDate")
    ON_LOG_TIME_SET(nil, itemLogDate);
end

function ON_JOINT_INVENTORY_DROP(slotset, slot, argStr, argNum)
    tolua.cast(slotset, "ui::CSlotSet");
    local liftIcon 				= ui.GetLiftIcon();
	if liftIcon == nil then
		return;
    end
    local fromFrame = liftIcon:GetTopParentFrame();
    if fromFrame == nil then
        return
    end
    local iconInfo = liftIcon:GetInfo();
    local itemIES = iconInfo:GetIESID();

    if fromFrame:GetName() == "inventory" then

    local slotIndex = slot:GetSlotIndex();
        
        if iconInfo.count > 1 then
            local frame = ui.GetFrame("guildinfo")
            local titleText = ScpArgMsg("INPUT_CNT_D_D", "Auto_1", 1, "Auto_2", iconInfo.count);
            frame:SetUserValue("SLOT_INDEX", slotIndex)
            frame:SetUserValue("ITEM_IES", itemIES)
            INPUT_NUMBER_BOX(frame, titleText, "EXEC_ITEM_DROP_COUNT_JOINT_INVENTORY", 1, 1, iconInfo.count)
        else
            local argList = string.format("%d %d", iconInfo.count, slotIndex);
            pc.ReqExecuteTx_Item("PUT_GUILD_JOINT_INV", itemIES, argList);
        end
    elseif fromFrame:GetName() == "guildinfo" then
        local hoveredSlot = slot:GetIcon();
        if hoveredSlot == nil then
            pc.ReqExecuteTx_Item("SWAP_GUILD_JOINT_INV", itemIES, tostring(slot:GetSlotIndex()));
            return
        end
        hoveredSlot = hoveredSlot:GetInfo();
        if hoveredSlot ~= nil then
            if hoveredSlot == iconInfo then
                return
            end
            pc.ReqExecuteTx_Item("SWAP_GUILD_JOINT_INV", itemIES, tostring(slot:GetSlotIndex()));
        end
    end
end

function EXEC_ITEM_DROP_COUNT_JOINT_INVENTORY(frame, count)
    local slotIndex = frame:GetUserValue("SLOT_INDEX")
    local itemIES = frame:GetUserValue("ITEM_IES")
    local numberCount = tonumber(count)
    local argList = numberCount .. " " .. slotIndex-- string.format("%d %s", count, slotIndex);
    pc.ReqExecuteTx_Item("PUT_GUILD_JOINT_INV", itemIES, argList);
end

function ON_JOINT_ITEM_TAKE(parent, control)
    local frame = ui.GetFrame("guildinfo")
    local slotset = GET_CHILD_RECURSIVELY(frame, "guildItemSlotset")
    tolua.cast(slotset, "ui::CSlotSet")

    local slot = slotset:GetSelectedSlot(0);
    if slot == nil then
        return
    end
    local iconInfo = slot:GetIcon();
    if iconInfo ~= nil then
        iconInfo = iconInfo:GetInfo()
    else
        return
    end
    if iconInfo == nil then
        return
    end
    local itemIES = iconInfo:GetIESID();
    local argList = string.format("%d", iconInfo.count);

    if iconInfo.count > 1 then
        local frame = ui.GetFrame("guildinfo")
        local titleText = ScpArgMsg("INPUT_CNT_D_D", "Auto_1", 1, "Auto_2", iconInfo.count);
        frame:SetUserValue("SLOT_INDEX", slotIndex)
        frame:SetUserValue("ITEM_IES", itemIES)
        INPUT_NUMBER_BOX(frame, titleText, "EXEC_ITEM_TAKE_COUNT_JOINT_INVENTORY", 1, 1, iconInfo.count)

    else

        pc.ReqExecuteTx_Item("TAKE_GUILD_JOINT_INV", itemIES, argList);
    end
end

function EXEC_ITEM_TAKE_COUNT_JOINT_INVENTORY(frame, count)
    local slotIndex = frame:GetUserValue("SLOT_INDEX")
    local itemIES = frame:GetUserValue("ITEM_IES")
    local numberCount = tonumber(count)
    local argList = numberCount .. " " .. slotIndex
    pc.ReqExecuteTx_Item("TAKE_GUILD_JOINT_INV", itemIES, argList);
end

function FILTER_TRANSACTION_LOG(parent, control)

    local frame = ui.GetFrame("guildinfo")
    local itemLogBox = GET_CHILD_RECURSIVELY(frame, "itemLogBox")
    
    local depositOnlyBox = GET_CHILD_RECURSIVELY(frame, "showOnlyDeposit")
    depositOnlyBox = AUTO_CAST(depositOnlyBox);

    local showDeposit = depositOnlyBox:IsChecked()

    local showOnlyWithdraw = GET_CHILD_RECURSIVELY(frame, "showOnlyWithdraw")
    showOnlyWithdraw = AUTO_CAST(showOnlyWithdraw);

    local showWithdraw = showOnlyWithdraw:IsChecked();

    for i=0, itemLogBox:GetChildCount()-1 do
        local ctrlset = itemLogBox:GetChildByIndex(i);

        if ctrlset:GetClassString() == "ui::CControlSet" then

            if ctrlset:GetUserValue("type") == "put" then
                ctrlset:SetVisible(showDeposit)
            elseif ctrlset:GetUserValue("type") == "take" then
                ctrlset:SetVisible(showWithdraw)
            end
        end
			
    end

    GBOX_AUTO_ALIGN(itemLogBox, 0, 0, 0, true, false, true)
end

function ON_LOG_TIME_SET(parent, ctrl)
    ctrl = AUTO_CAST(ctrl);
    local curTime = geTime.GetServerSystemTime();

    local selectedTime = ctrl:GetSelItemValue();
    curTime = imcTime.AddSec(curTime, -selectedTime)
    
    local curSysTimeStr = string.format("%04d-%02d-%02d %02d:%02d:%02d", curTime.wYear, curTime.wMonth, curTime.wDay, curTime.wHour, curTime.wMinute, curTime.wSecond)
    GetGuildWareHouseLog("ON_GUILD_WAREHOUSE_GET", curSysTimeStr)

    local frame = ui.GetFrame("guildinfo");
    local showOnlyDeposit = GET_CHILD_RECURSIVELY(frame, "showOnlyDeposit")
    local showOnlyWithdraw = GET_CHILD_RECURSIVELY(frame, "showOnlyWithdraw")

    showOnlyDeposit = AUTO_CAST(showOnlyDeposit)
    showOnlyDeposit:SetCheck(1)

    showOnlyWithdraw = AUTO_CAST(showOnlyWithdraw)
    showOnlyWithdraw:SetCheck(1)

end

function ON_UPDATE_GUILD_MILEAGE(frame, msg, strArg, numArg)
    local mileageCount = GET_CHILD_RECURSIVELY(frame, "mileageCount");
    mileageCount:SetTextByKey('point', numArg)
	
	local guild = session.party.GetPartyInfo(PARTY_GUILD);
	if guild ~= nil then
		guild.info:SetMileage(numArg);
	end
end