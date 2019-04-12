function UPDATE_REWARD_BID_POPUP(itemID, itemCount)

	local frame = ui.GetFrame("rewardbidpopup");
	frame:SetUserValue("RECEIVE_ITEMID", itemID);
	frame:SetUserValue("RECEIVE_ITEM_COUNT", itemCount);
	ON_UPDATE_REWARD_BID_POPUP(frame, itemID, itemCount);

end


function ON_UPDATE_REWARD_BID_POPUP(frame, itemID, itemCount)
	
	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil then
		frame:ShowWindow(0);
		return;
	end

	local partyObj = GetIES(pcparty:GetObject());

	frame:SetUserValue("STARTWAITSEC", 30);

	local sysTime = geTime.GetServerSystemTime();
	local endTime = imcTime.GetSysTimeByStr(partyObj.RewardBidStartTime);
	local difSec = imcTime.GetDifSec(sysTime, endTime);
	if difSec >= 30 then
	    difSec = 0;
		frame:ShowWindow(0);
	end

--	local isLeader = AM_I_LEADER(PARTY_GUILD);
--	if isLeader == 1 then
--		geClientGuildEvent.RunGuildEventBidLottery(true)
--	end

	frame:SetUserValue("ELAPSED_SEC", 0);
	frame:SetUserValue("START_SEC", imcTime.GetAppTime());

	frame:RunUpdateScript("REWARD_BID_UPDATE_WAITSEC", 0, 0, 0, 1)
	local item = GetClassByType("Item", itemID);
	local icon = GET_CHILD(frame, "ItemIcon", "ui::CPicture");
	icon:SetImage(item.Icon);
	icon:SetEnableStretch(1)
	icon:SetEventScriptArgString(ui.RBUTTONUP, item.ClassName);
	SET_ITEM_TOOLTIP_ALL_TYPE(icon, itemData, item.ClassName, '', item.ClassID, 0);

	local text = GET_CHILD(frame, "ItemName", "ui::CRichText");
	local count = GET_CHILD(frame, "itemCount", "ui::CRichText");
	text:SetTextByKey('value', item.Name);
	count:SetTextByKey('count', itemCount);
	
	local btn_join = GET_CHILD(frame, "btn_join");
	local btn_close = GET_CHILD(frame, "btn_close");

	btn_join:ShowWindow(1);
	btn_close:ShowWindow(1);
	frame:ShowWindow(1)

end

function REWARD_BID_UPDATE_WAITSEC(frame)
	local startWaitSec = frame:GetUserIValue("STARTWAITSEC");
	local elapsedSec = frame:GetUserIValue("ELAPSED_SEC");
	local startSec = frame:GetUserIValue("START_SEC");
	local curSec = imcTime.GetAppTime() -  startSec + elapsedSec;
	local remainSec = startWaitSec - curSec;
	remainSec = math.floor(remainSec);
	if remainSec < 0 then
		frame:ShowWindow(0);
		control.CustomCommand("REQUEST_BID_LOTTERY", 0);
		return 0;
	end

	local gauge = GET_CHILD(frame, "gauge");
	gauge:SetPoint(remainSec, startWaitSec);
	local txt_startwaittime = frame:GetChild("txt_startwaittime");	

	local remainMin = math.floor(remainSec / 60);
	local remainSec = remainSec % 60;
	local timeText = string.format("%d : %02d", remainMin, remainSec);
	txt_startwaittime:SetTextByKey("value", timeText);

	return 1;

end


function REQ_REWARD_BID(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local receiveItemID = frame:GetUserIValue("RECEIVE_ITEMID");
	control.CustomCommand("REQUEST_ITEM_BID", receiveItemID);
	local btn_join = GET_CHILD(frame, "btn_join");
	local btn_close = GET_CHILD(frame, "btn_close");
	btn_join:ShowWindow(0);
	btn_close:ShowWindow(0);

end

function REQ_ClOSE_REWARDBID(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	frame:ShowWindow(0);

end