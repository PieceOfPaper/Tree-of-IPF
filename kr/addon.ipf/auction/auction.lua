
function AUCTION_ON_INIT(addon, frame)

	addon:RegisterMsg("NPC_AUCTION_LIST", "ON_NPC_AUCTION_LIST")
	addon:RegisterMsg("NPC_AUCTION_BID", "ON_NPC_AUCTION_BID")
	addon:RegisterOpenOnlyMsg("NPC_AUCTION_MYINFO", "ON_NPC_AUCTION_MYINFO")

end

function AUCTION_SET_CTRLSET_LOSE(ctrlSet, loseItem)
	ctrlSet:SetUserValue("GUID", loseItem:GetGuid());
	ctrlSet:SetUserValue("SEQ", loseItem.bidSeq);
	ctrlSet:SetUpdateTopParent(1);
	local itemCls = GetClassByType("Item", loseItem.itemType);
	local slot = GET_CHILD(ctrlSet, "slot_1", "ui::CSlot");
	SET_SLOT_ITEM_CLS(slot, itemCls);
	ctrlSet:GetChild("itemname"):SetTextByKey("value", itemCls.Name);
	ctrlSet:GetChild("curprice"):SetTextByKey("value", GetCommaedText(loseItem.money));
end

function AUCTION_SET_CTRLSET_MY(ctrlSet, aucItem)
	ctrlSet:SetUserValue("GUID", aucItem:GetGuid());
	ctrlSet:SetUpdateTopParent(1);
	local itemCls = GetClassByType("Item", aucItem.itemType);
	local slot = GET_CHILD(ctrlSet, "slot_1", "ui::CSlot");
	SET_SLOT_ITEM_CLS(slot, itemCls);
	ctrlSet:GetChild("itemname"):SetTextByKey("value", itemCls.Name);
	ctrlSet:GetChild("curbid"):SetTextByKey("value", aucItem.bidCount);
	ctrlSet:GetChild("curprice"):SetTextByKey("value", GetCommaedText(aucItem.curPrice));
end

function AUCTION_SET_CTRLSET(ctrlSet, aucItem)

	ctrlSet:SetUserValue("GUID", aucItem:GetGuid());
	ctrlSet:EnableHitTestSet(1);
	ctrlSet:SetUpdateTopParent(1);
	ctrlSet:SetEventScript(ui.LBUTTONDOWN, 'POPUP_NPC_AUCTION')
	local itemCls = GetClassByType("Item", aucItem.itemType);
	local slot = GET_CHILD(ctrlSet, "slot_1", "ui::CSlot");
	SET_SLOT_ITEM_CLS(slot, itemCls);
	ctrlSet:GetChild("itemname"):SetTextByKey("value", itemCls.Name);
	ctrlSet:GetChild("buynow"):SetTextByKey("value", GetCommaedText(aucItem.buyPrice));
	ctrlSet:GetChild("curbid"):SetTextByKey("value", aucItem.bidCount);
	ctrlSet:GetChild("curprice"):SetTextByKey("value", GetCommaedText(aucItem.curPrice));

end

function AUCTION_BUYNOW(ctrlSet, ctrl)
end

function AUCTION_GET_LOSE_MONEY(ctrlSet, ctrl)
	local guid = ctrlSet:GetUserValue("GUID");
	local bidSeq = ctrlSet:GetUserIValue("SEQ");
	local frame = ctrlSet:GetTopParentFrame();
	local handle = frame:GetUserIValue("NPCHANDLE");
	npcAuction.ReqNPCAuctionCmd(3, handle, guid, bidSeq);
end

function AUCTION_GET_WIN_ITEM(ctrlSet, ctrl)
	local guid = ctrlSet:GetUserValue("GUID");
	local frame = ctrlSet:GetTopParentFrame();
	local handle = frame:GetUserIValue("NPCHANDLE");
	npcAuction.ReqNPCAuctionCmd(2, handle, guid, 0);
end

function POPUP_NPC_AUCTION(frame, ctrl)
	frame = frame:GetTopParentFrame();
	local auctionName = frame:GetUserValue("AUCTION_NAME");
	local guid = ctrl:GetUserValue("GUID");
	local auction = geNPCAuction.Create(auctionName);
	local aucItem = auction:GetItemList():GetItemByID(guid);
	local npcHandle = frame:GetUserIValue("NPCHANDLE");

	local popupFrame = ui.GetFrame("auction_popup");
	popupFrame:ShowWindow(1);
	AUCTION_POPUP_SET(popupFrame, auctionName, guid, aucItem, npcHandle);
end

function ON_NPC_AUCTION_BID(frame, msg, guid)
	local ctrlSet = AUCTION_GET_CTRLSET(frame, guid);
	if ctrlSet == nil then
		return;
	end

	local auctionName = frame:GetUserValue("AUCTION_NAME");
	local auction = geNPCAuction.Create(auctionName);
	local aucItem = auction:GetItemList():GetItemByID(guid);
	if aucItem == nil then
		return;
	end

	AUCTION_SET_CTRLSET(ctrlSet, aucItem);
end

function AUCTION_GET_CTRLSET(frame, guid)

	local gbox = frame:GetChild("gbox");
	local index = 0;
	while 1 do
		local ctrlsetName = "AUCITEM_" .. index;
		local ctrl = gbox:GetChild(ctrlsetName);
		if ctrl == nil then
			break;
		end

		local _guid = ctrl:GetUserValue("GUID");
		if _guid == guid then
			return tolua.cast(ctrl, "ui::CControlSet");
		end

		index = index + 1;
	end

	return nil;
end

function ON_NPC_AUCTION_MYINFO(frame, msg, auctionName)
	local auction = geNPCAuction.Create(auctionName);

	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local winList = auction:GetWinItemList(cid);
	local myCount = 0;
	if winList ~= nil then
		myCount = winList:GetItemCount();
	end

	local loseList = auction:GetLosePC(cid);
	local loseCount = loseList:GetCount();
	local text = frame:GetChild("text");
	text:SetTextByKey("winCount", myCount);
	text:SetTextByKey("loseMoney", loseCount);

end

function AUCTION_ITEM_LIST_UPDATE(frame)
	local auctionName = frame:GetUserValue("AUCTION_NAME");
	local auction = geNPCAuction.Create(auctionName)
	local itemList = auction:GetItemList();
	local cnt = itemList:GetItemCount();
	AUCTION_SET_CONTROLSET_COUNT(frame, cnt, "auctionitem");

	local gbox = frame:GetChild("gbox");
	for i = 0 , cnt - 1 do
		local aucItem = itemList:GetItem(i);
		local ctrlsetName = "AUCITEM_" .. i;
		local ctrlSet = GET_CHILD(gbox, ctrlsetName, "ui::CControlSet");
		AUCTION_SET_CTRLSET(ctrlSet, aucItem);
	end

	frame:RunUpdateScript("AUC_UPDATE_TIME",0,0,0,1);
	AUC_UPDATE_TIME(frame);
end

function AUCTION_MY_PAGE_UPDATE(frame)
	local auctionName = frame:GetUserValue("AUCTION_NAME");
	local auction = geNPCAuction.Create(auctionName)
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	local itemList = auction:GetWinItemList(cid);
	local cnt = itemList:GetItemCount();

	local gbox = frame:GetChild("gbox");
	DESTROY_CHILD_BYNAME(gbox, "AUCITEM_");

	local index = 0;
	local x = 35;
	local y = 40;
	for i = 0 , cnt - 1 do
		local aucItem = itemList:GetItem(i);
		local ctrlsetName = "AUCITEM_" .. index;
		local ctrlSetType = "auctionmyitem";
		
		local ctrlSet = gbox:CreateControlSet(ctrlSetType, ctrlsetName, x, y);
		if ctrlSet ~= nil then
			ctrlSet = tolua.cast(ctrlSet, "ui::CControlSet");
			AUCTION_SET_CTRLSET_MY(ctrlSet, aucItem);
			y = y + ui.GetControlSetAttribute(ctrlSetType, 'height');
			index = index + 1;
		end
	end

	local loseList = auction:GetLosePC(cid);
	if loseList ~= nil then
		cnt = loseList:GetCount();
		for i = 0 , cnt - 1 do
			local loseItem = loseList:Get(i);
			local ctrlsetName = "AUCITEM_" .. index;
			local ctrlSetType = "auctionloseItem";
			
			local ctrlSet = gbox:CreateControlSet(ctrlSetType, ctrlsetName, x, y);
			if ctrlSet ~= nil then
				ctrlSet = tolua.cast(ctrlSet, "ui::CControlSet");
				AUCTION_SET_CTRLSET_LOSE(ctrlSet, loseItem);
				y = y + ui.GetControlSetAttribute(ctrlSetType, 'height');
				index = index + 1;
			end
		end
	end

	frame:RunUpdateScript("AUC_UPDATE_TIME",0,0,0,1);
	AUC_UPDATE_TIME(frame);
end

function AUCTION_LIST_UPDATE(frame)

	if frame:GetUserValue("MODE") == "MYPAGE" then
		AUCTION_MY_PAGE_UPDATE(frame);
	else
		AUCTION_ITEM_LIST_UPDATE(frame);
	end
end

function ON_NPC_AUCTION_LIST(frame, msg, auctionName, npcHandle)

	if npcHandle ~= 0 then
		frame:SetUserValue("NPCHANDLE", npcHandle);
	end

	frame:ShowWindow(1);
	frame:SetUserValue("AUCTION_NAME", auctionName);

	AUCTION_LIST_UPDATE(frame);

end

function AUC_UPDATE_TIME(frame)

	if frame:GetUserValue("MODE") == "MYPAGE" then
		return;
	end

	local auctionName = frame:GetUserValue("AUCTION_NAME");
	local auction = geNPCAuction.Create(auctionName);

	local gbox = frame:GetChild("gbox");
	local index = 0;
	while 1 do
		local ctrlsetName = "AUCITEM_" .. index;
		local ctrl = gbox:GetChild(ctrlsetName);
		if ctrl == nil then
			break;
		end

		local guid = ctrl:GetUserValue("GUID");
		local aucItem = auction:GetItemList():GetItemByID(guid);

		local endTime = aucItem:GetEndSysTime();
		local curTime = geTime.GetServerSystemTime();
		local difSec = imcTime.GetIntDifSec(endTime, curTime);
		local timeString = GET_DHMS_STRING(difSec);
		ctrl:GetChild("curtime"):SetTextByKey("value", timeString);


		index = index + 1;
	end

	return 1;
end

function AUCTION_CTRLSET_POS(index, ctrlSetName)

	local x = 35;
	local y = 40;
	local ctrlheight = ui.GetControlSetAttribute(ctrlSetName, 'height') + 10;
	return x, y + ctrlheight * index;
end

function AUCTION_SET_CONTROLSET_COUNT(frame, cnt, ctrlSetName)

	local gbox = frame:GetChild("gbox");
	for i = 0 , cnt - 1 do
		local ctrlsetName = "AUCITEM_" .. i;
		if gbox:GetChild(ctrlsetName) == nil then
			local x, y = AUCTION_CTRLSET_POS(i, ctrlSetName);
			gbox:CreateControlSet(ctrlSetName, ctrlsetName, x, y);
		end
	end

	local idx = cnt;
	while 1 do
		local childName =  "AUCITEM_" .. idx;
		if gbox:GetChild(childName) == nil then
			break;
		end

		gbox:RemoveChild(childName);
		idx = idx + 1;
	end

end

function AUCTION_TOGGLE_MODE(frame, btn)

	btn:SetOverSound('button_over');
	btn:SetClickSound('button_click_2');

	if frame:GetUserValue("MODE") == "MYPAGE" then
		frame:SetUserValue("MODE", "None");
	else
		frame:SetUserValue("MODE", "MYPAGE");
	end

	local frameHeight = frame:GetHeight();
	local gbox = GET_CHILD(frame, "gbox", "ui::CGroupBox");

	local curMode = frame:GetUserValue("MODE");
	if curMode == "MYPAGE" then
		btn:SetTextByKey("text", ScpArgMsg("Auto_KyeongMae_JinHaeng_MogLog"));
	else
		btn:SetTextByKey("text", ScpArgMsg("Auto_NagChalMulPum_BoKwanHam"));
	end

	DESTROY_CHILD_BYNAME(gbox, "AUCITEM_");
	AUCTION_LIST_UPDATE(frame);

end

function NOTICE_AUCTION_NEW_ITEM(mapType, itemType)
	local mapCls = GetClassByType("Map", mapType);
	local itemCls = GetClassByType("Item", itemType);
	local msg = ScpArgMsg("In{MapName}AuctionItem{ItemName}Registered", "MapName", mapCls.Name, "ItemName", itemCls.Name);
	NOTICE_ITEM(itemCls, "{@st43}" .. msg, 7);
end

function NOTICE_AUCTION_GET_ITEM(name, itemType)
	local itemCls = GetClassByType("Item", itemType);
	local msg = ScpArgMsg("{PC}GetAuctionItem{ItemName}", "PC", name, "ItemName", itemCls.Name);
	NOTICE_ITEM(itemCls, "{@st43}" .. msg, 7);
end

