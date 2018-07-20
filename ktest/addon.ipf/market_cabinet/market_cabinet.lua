
function MARKET_CABINET_ON_INIT(addon, frame)
		addon:RegisterMsg("CABINET_ITEM_LIST", "ON_CABINET_ITEM_LIST");
end

function MARKET_CABINET_OPEN(frame)
	market.ReqCabinetList();
end

function SHOW_REMAIN_NEXT_TIME_GET_CABINET(ctrl)
	if nil == ctrl then
		return 0;
	end
	local elapsedSec = imcTime.GetAppTime() - ctrl:GetUserIValue("STARTSEC");
	local startSec = ctrl:GetUserIValue("REMAINSEC");
	startSec = startSec - elapsedSec;

	if 0 >= startSec then
		local frame = ctrl:GetParent();
		local btn = frame:GetChild("btn");
		btn:SetEnable(1);
		ctrl:SetTextByKey("value", ClMsg("Receieve"));
		ctrl:StopUpdateScript("SHOW_REMAIN_NEXT_TIME_GET_CABINET");
		return 0;
	end
	local timeTxt = GET_TIME_TXT(startSec);
	ctrl:SetTextByKey("value", "{s16}{#ffffcc}(" .. timeTxt..")");
	return 1;
end

function ON_CABINET_ITEM_LIST(frame)
	local itemGbox = GET_CHILD(frame, "itemGbox");
	local itemlist = GET_CHILD(itemGbox, "itemlist", "ui::CDetailListBox");
	itemlist:RemoveAllChild();

	local cnt = session.market.GetCabinetItemCount();
	local sysTime = geTime.GetServerSystemTime();		
	for i = 0 , cnt - 1 do
		local cabinetItem = session.market.GetCabinetItemByIndex(i);
		local itemID = cabinetItem:GetItemID();
		local itemObj = GetIES(cabinetItem:GetObject());
		local registerTime = cabinetItem:GetRegSysTime();
		local difSec = imcTime.GetDifSec(registerTime, sysTime);
		if 0 >= difSec then
			difSec =0;
		end
		local timeString = GET_TIME_TXT(difSec);

		local refreshScp = itemObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(itemObj);
		end	

		local ctrlSet = INSERT_CONTROLSET_DETAIL_LIST(itemlist, i, 0, "market_cabinet_item_detail");
		ctrlSet:Resize(1350, ctrlSet:GetHeight());

		local pic = GET_CHILD(ctrlSet, "pic", "ui::CPicture");
		pic:SetImage(itemObj.Icon);
		local name = ctrlSet:GetChild("name");
		name:SetTextByKey("value", GET_FULL_NAME(itemObj));
		name:SetOffset(name:GetX() + 10, name:GetY());
		local itemCount = ctrlSet:GetChild("count");
		itemCount:ShowWindow(0);
		local totalPrice = ctrlSet:GetChild("totalPrice");
		totalPrice:SetTextByKey("value", GetCommaedText(cabinetItem.count));
		totalPrice:SetOffset(totalPrice:GetX() - 25, totalPrice:GetY());
		SET_ITEM_TOOLTIP_ALL_TYPE(ctrlSet, cabinetItem, itemObj.ClassName, "cabinet", cabinetItem.itemType, cabinetItem:GetItemID());
		local endTime = ctrlSet:GetChild("endTime");
		endTime:SetTextByKey("value", timeString);
		if 0 == difSec then
			endTime:SetTextByKey("value", ClMsg("Receieve"));
		else
			endTime:SetUserValue("REMAINSEC", difSec);
			endTime:SetUserValue("STARTSEC", imcTime.GetAppTime());
			SHOW_REMAIN_NEXT_TIME_GET_CABINET(medalFreeTime);
			endTime:RunUpdateScript("SHOW_REMAIN_NEXT_TIME_GET_CABINET");
		end
		
		local btn = GET_CHILD(ctrlSet, "btn");
		btn:SetTextByKey("value", ClMsg("Receieve"));
		btn:UseOrifaceRectTextpack(true)
		btn:SetEventScript(ui.LBUTTONUP, "CABINET_ITEM_BUY");
		btn:SetEventScriptArgString(ui.LBUTTONUP,cabinetItem:GetItemID());
		if 0 >= difSec then
			btn:SetEnable(1);
		else
			btn:SetEnable(0);
		end
		
	end
	GBOX_AUTO_ALIGN(itemlist, 10, 0, 0, true, true);
	itemlist:RealignItems();
end

function CABINET_GET_ALL_ITEM(parent, ctrl)
    local pc = GetMyPCObject();
    local now = pc.NowWeight
    local flag = 0
	for i = 0 , session.market.GetCabinetItemCount() - 1 do
		local cabinetItem = session.market.GetCabinetItemByIndex(i);
		local itemObj = GetIES(cabinetItem:GetObject());
		if pc.MaxWeight < now + (itemObj.Weight * cabinetItem.count) then
		    flag = 1
		else
		    market.ReqGetCabinetItem(cabinetItem:GetItemID());
		    now  = now + (itemObj.Weight * cabinetItem.count)
		end
	end
	if flag == 1 then
	    addon.BroadMsg("NOTICE_Dm_!", ScpArgMsg("MAXWEIGHTMSG"), 10);
	end
	market.ReqCabinetList();
end

function CABINET_ITEM_BUY(frame, ctrl, guid)
	market.ReqGetCabinetItem(guid);
end


