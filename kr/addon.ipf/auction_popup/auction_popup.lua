

function AUCTION_POPUP_ON_INIT(addon, frame)
	addon:RegisterMsg("NPC_AUCTION_BID", "ON_NPC_AUCTION_POP_BID");
	addon:RegisterMsg("NPC_AUCTION_DEL", "ON_NPC_AUCTION_DEL");
	addon:RegisterMsg("NPC_AUCTION_LIST", "ON_NPC_AUCTION_LIST_POPUP")
end

function ON_NPC_AUCTION_LIST_POPUP(frame)
	if frame:IsVisible() == 0 then
		return;
	end

	local item = AUC_POPUP_GET_ITEM(frame);
	if item == nil then
		AUCTION_POP_DISABLE(frame, ClMsg("AuctionIsEnded"));
	end
end

function ON_NPC_AUCTION_POP_BID(frame, msg, guid)
	local auctionName = frame:GetUserValue("AUCTIONNAME");
	local _guid = frame:GetUserValue("GUID");
	if _guid ~= guid then
		return;
	end

	local auction = geNPCAuction.Create(auctionName);
	local aucItem = auction:GetItemList():GetItemByID(guid);
	if aucItem ~= nil then
		AUCTION_POPUP_UPDATE(frame, aucItem);
	end
end

function AUCTION_POP_DISABLE(frame, msg)
	local inputmoney = GET_CHILD(frame, "inputmoney", "ui::CEditControl");
	local bid = frame:GetChild("bid");
	local buynow = frame:GetChild("buynow");

	inputmoney:SetText(msg);
	inputmoney:SetEnable(0);
	bid:SetEnable(0);
	buynow:SetEnable(0);
end

function ON_NPC_AUCTION_DEL(frame)
	if frame:IsVisible() == 0 then
		return;
	end

	local item = AUC_POPUP_GET_ITEM(frame);
	if item == nil then
		AUCTION_POP_DISABLE(frame, ClMsg("AuctionItemSoldOut"));
	end
end

function AUCTION_POPUP_UPDATE(frame, aucItem)

	local mySession = session.GetMySession();
	local isMyAuction = false;
	if aucItem:GetCID() == mySession:GetCID() then
		isMyAuction = true;
	end

	local itemCls = GetClassByType("Item", aucItem.itemType);
	local slot = GET_CHILD(frame, "slot_1", "ui::CSlot");
	SET_SLOT_ITEM_CLS(slot, itemCls);

	local gradeString = GET_ITEM_GRADE_TXT(itemCls, 24);
	local nameStr = GET_FULL_NAME(itemCls)  .. "{nl}" .. gradeString;
	local buynow = frame:GetChild("buynow");
	frame:GetChild("itemname"):SetTextByKey("value", nameStr);
	buynow:SetTextByKey("value", GetCommaedText(aucItem.buyPrice));
	frame:GetChild("budcount"):SetTextByKey("value", aucItem.bidCount);
	frame:GetChild("curprice"):SetTextByKey("value", GetCommaedText(aucItem.curPrice));
	frame:GetChild("startprice"):SetTextByKey("value", GetCommaedText(aucItem.startPrice));
	local minMoney = math.max(aucItem.startPrice, aucItem.curPrice) + aucItem.unitPrice;
	frame:GetChild("ablemoney"):SetTextByKey("value", GetCommaedText(minMoney));
	local bid = frame:GetChild("bid");
	local inputmoney = GET_CHILD(frame, "inputmoney", "ui::CEditControl");
	if isMyAuction then
		bid:SetEnable(0);
		inputmoney:SetNumberMode(0);
		inputmoney:SetText(ClMsg("AlreadyBiddedTopPrice"));
		inputmoney:SetEnable(0);
		buynow:SetEnable(1);
	else
		bid:SetEnable(1);
		inputmoney:SetNumberMode(1);
		inputmoney:SetText(minMoney);
		inputmoney:SetEnable(1);
		buynow:SetEnable(1);
	end
	
	frame:RunUpdateScript("AUC_POPUP_UPDATE_TIME",0,0,0,1);
	AUC_POPUP_UPDATE_TIME(frame);

end

function AUCTION_POPUP_SET(frame, auctionName, guid, aucItem, npcHandle)

	frame:SetUserValue("NPCHANDLE", npcHandle);
	frame:SetUserValue("AUCTIONNAME", auctionName);
	frame:SetUserValue("GUID", guid);

	AUCTION_POPUP_UPDATE(frame, aucItem);
end

function AUC_POPUP_GET_ITEM(frame)
	local auctionName = frame:GetUserValue("AUCTIONNAME");
	local guid = frame:GetUserValue("GUID");
	local auction = geNPCAuction.Create(auctionName);
	return auction:GetItemList():GetItemByID(guid);
end

function AUC_POPUP_UPDATE_TIME(frame)

	local aucItem = AUC_POPUP_GET_ITEM(frame);
	if aucItem == nil then
		return 1;
	end

	local endTime = aucItem:GetEndSysTime();
	local curTime = geTime.GetServerSystemTime();
	local difSec = imcTime.GetIntDifSec(endTime, curTime);
	local timeString = GET_DHMS_STRING(difSec);
	frame:GetChild("remaintime"):SetTextByKey("value", timeString);
	return 1;
end

function AUC_POP_BID(frame)
end

function EXEC_AUC_POP_BID()
	local frame = ui.GetFrame("auction_popup");
	local auctionName = frame:GetUserValue("AUCTIONNAME");
	local guid = frame:GetUserValue("GUID");
	local handle = frame:GetUserIValue("NPCHANDLE");
	local silver = tonumber(frame:GetChild("inputmoney"):GetText());
		
	npcAuction.ReqNPCAuctionCmd(0, handle, guid, silver);
end

function AUC_POP_BUY(frame)
end

function EXEC_AUC_POP_BUY()
	local frame = ui.GetFrame("auction_popup");
	local handle = frame:GetUserIValue("NPCHANDLE");
	local guid = frame:GetUserValue("GUID");
	npcAuction.ReqNPCAuctionCmd(1, handle, guid, 0);
end




