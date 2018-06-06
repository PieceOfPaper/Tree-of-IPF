
function STEAMTPINVENTORY_ON_INIT(addon, frame)

		addon:RegisterMsg("UPDATE_INGAME_SHOP_ITEM_LIST", "STEAMTPINVENTORY_ON_UPDATE_INGAME_SHOP_ITEM_LIST");
		addon:RegisterMsg("CLOSE_INGAMESHOP_UI", "STEAMTPINVENTORY_ON_CLOSE_INGAMESHOP_UI");
		addon:RegisterMsg("UPDATE_INGAME_SHOP_REMAIN_CASH", "STEAMTPINVENTORY_ON_UPDATE_INGAME_SHOP_REMAIN_CASH");
		addon:RegisterMsg("INGAMESHOP_STATE_MSG", "STEAMTPINVENTORY_ON_INGAMESHOP_STATE_MSG");
end

function STEAMTPINVENTORY_ON_INGAMESHOP_STATE_MSG(frame, msg, argStr, argNum)
    


    if argStr == "LoadFailTPItemList" then

        local errCode = ""

        if argNum ~= nil then
            errCode = tostring(argNum)
        else 
            errCode = "0"
        end

        ui.MsgBox_NonNested(ScpArgMsg("LoadFailTPItemList","Code",errCode),0x00000000)

        ui.Chat("/ingameuilog "..argStr.."|"..errCode)

    elseif argStr == "DontHaveAnyItems" then

        ui.MsgBox_NonNested(ScpArgMsg("DontHaveAnyItems"),0x00000000)

        ui.Chat("/ingameuilog "..argStr)

    elseif argStr == "NotOwnedItem" then

        ui.MsgBox_NonNested(ScpArgMsg("NotOwnedItem"),0x00000000)

        ui.Chat("/ingameuilog "..argStr)

    elseif argStr == "BuyTPItemFailPlzRetry" then

        local errCode = ""

        if argNum ~= nil then
            errCode = tostring(argNum)
        else 
            errCode = "0"
        end

        ui.MsgBox_NonNested(ScpArgMsg("BuyTPItemFailPlzRetry","Code",errCode),0x00000000)

        ui.Chat("/ingameuilog "..argStr.."|"..errCode)

    elseif argStr == "BuyTPItemFailPlzWait" then
        
        ui.MsgBox_NonNested(ScpArgMsg("BuyTPItemFailPlzWait"),0x00000000)

        ui.Chat("/ingameuilog "..argStr)

    elseif argStr == "TpChargeFail" then
        
        ui.MsgBox_NonNested(ScpArgMsg("TpChargeFail"),0x00000000)

        ui.Chat("/ingameuilog "..argStr)

    elseif argStr == "TpChargeSuccess" then
        
        ui.MsgBox_NonNested(ScpArgMsg("TpChargeSuccess"),0x00000000)

    elseif argStr == "StillProcessingTryLater" then

        ui.MsgBox_NonNested(ScpArgMsg("StillProcessingTryLater"),0x00000000)

        ui.Chat("/ingameuilog "..argStr)

    elseif argStr == "TPItemProcessFail" then

        local errCode = ""

        if argNum ~= nil then
            errCode = tostring(argNum)
        else 
            errCode = "0"
        end

        ui.MsgBox_NonNested(ScpArgMsg("TPItemProcessFail","Code",errCode),0x00000000)

        ui.Chat("/ingameuilog "..argStr.."|"..errCode)

    else
        ui.MsgBox_NonNested(argStr,0x00000000)

    end



    
end

function numWithCommas(n)
  return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
                                :gsub(",(%-?)$","%1"):reverse()
end

function STEAMTPINVENTORY_ON_CLOSE_INGAMESHOP_UI()
	ui.CloseFrame("steamtpinventory");
end

function STEAMTPINVENTORY_OPEN(frame)

	local listbox = GET_CHILD_RECURSIVELY(frame, "itemlist");
	listbox:RemoveAllChild();

    local status = GET_CHILD_RECURSIVELY(frame, "status");
    status:SetText(ScpArgMsg("LoadingTPItemList"));
	
    frame:Invalidate()

	ui.OpenIngameShopUI();

    frame:CancelReserveScript("STEAMTPINVENTORY_RECEIVE_LIST_ERROR");
	frame:ReserveScript("STEAMTPINVENTORY_RECEIVE_LIST_ERROR", 5, 0, "");

    ui.Chat("/ingameuilog OPEN")
end

function STEAMTPINVENTORY_RECEIVE_LIST_ERROR(frame)

    local status = GET_CHILD_RECURSIVELY(frame, "status");
    status:SetText(ScpArgMsg("LoadFailTPItemList","Code","001"));
    SendSystemLog()

    ui.Chat("/ingameuilog RECEIVE_LIST_ERROR")

end

function STEAMTPINVENTORY_ON_UPDATE_INGAME_SHOP_ITEM_LIST(frame)
	
    ui.Chat("/ingameuilog UPDATE_INGAME_SHOP_ITEM_LIST")

	local listbox = GET_CHILD_RECURSIVELY(frame, "itemlist");
	listbox:RemoveAllChild();

	local cnt = session.ui.GetIngameShopItemListSize();
    ui.Chat("/ingameuilog itemCnt:"..tostring(cnt))

	for i = 0 , cnt-1 do

		local iteminfo = session.ui.GetIngameShopItemInfo(i)

        if iteminfo == nil then
            ui.Chat("/ingameuilog iteminfo nil")
        end

        ui.Chat("/ingameuilog iteminfo:"..tostring(i))
		
		local ctrlSet = listbox:CreateControlSet('steamptinventory_item', "INGAMESHOP_ITEM_" .. i, (i % 2) * ui.GetControlSetAttribute("steamptinventory_item", "width") , math.floor(i / 2) * ui.GetControlSetAttribute("steamptinventory_item", "height"));
        ui.Chat("/ingameuilog createcontril:"..ctrlSet:GetName())

		local btn = GET_CHILD_RECURSIVELY(ctrlSet, "buyBtn");
        btn:SetUserValue("ITEMGUID", iteminfo:GetItemGuid());
        ui.Chat("/ingameuilog btnSet:"..iteminfo:GetItemGuid())

		local title = GET_CHILD_RECURSIVELY(ctrlSet, "title");
        title:SetText(iteminfo:GetName())
        ui.Chat("/ingameuilog titleSet:")

		local tpicon_change = GET_CHILD_RECURSIVELY(ctrlSet, "tpicon_change");
        tpicon_change:SetImage(iteminfo:GetImgName())
        ui.Chat("/ingameuilog imageSet:"..iteminfo:GetImgName())

		local nxp = GET_CHILD_RECURSIVELY(ctrlSet, "nxp");
		nxp:SetText(tostring(iteminfo.addtp))
		ui.Chat("/ingameuilog nxpSet:"..tostring(iteminfo.addtp))
	end

    local status = GET_CHILD_RECURSIVELY(frame, "status");
    status:SetText(ScpArgMsg("LoadedTPItemList"));
    ui.Chat("/ingameuilog statusSet")

	frame:Invalidate()
    
    frame:CancelReserveScript("STEAMTPINVENTORY_RECEIVE_LIST_ERROR");
    SendSystemLog()

    ui.Chat("/ingameuilog UPDATE_INGAME_SHOP_ITEM_LIST_END")

end

function STEAMTPINVENTORY_ITEM_PURCHASE(parent, control, tpitemname, classid)	

	local itemguid = control:GetUserValue("ITEMGUID");

	local yesScp = string.format("EXEC_STEAMTPINVENTORY_ITEM_PURCHASE(\"%s\")", itemguid);
	local txt = ScpArgMsg("AreYouSureToUse");
	ui.MsgBox(txt, yesScp, "None");

end

function EXEC_STEAMTPINVENTORY_ITEM_PURCHASE(itemguid)

	ui.BuyIngameShopItem(itemguid);
end

function STEAM_TP_REFRESH_BTN_CLICK()
    ui.OpenIngameShopUI();
end

function STEAM_TP_RETRIEVE_ALL_BTN_CLICK()
    ui.Chat("/retrieveAllItems")
end