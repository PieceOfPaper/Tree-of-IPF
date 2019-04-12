
function EXPIREDITEM_ALERT_ON_INIT(addon, frame)
	addon:RegisterMsg('EXPIREDITEM_ALERT_OPEN', 'EXPIREDITEM_ALERT_ON_MSG');

end

function EXPIREDITEM_ALERT_ON_MSG(frame, msg, argStr, argNum)
	if msg == "EXPIREDITEM_ALERT_OPEN" then
        EXPIREDITEM_ALERT_OPEN(frame, argStr)
		return;
	end
end

function EXPIREDITEM_ALERT_OPEN(frame, argStr)
    frame:SetUserValue("TimerType", argStr);

    local itemlist = GET_CHILD(frame, 'itemlist', 'ui::CGroupBox');
    itemlist:RemoveAllChild();
    local nearFutureSec = frame:GetUserConfig("NearFutureSec");
    local list = GET_SCHEDULED_TO_EXPIRED_ITEM_LIST(nearFutureSec);
    if #list < 1 then        
        APPS_TRY_LEAVE(argStr)
        return;
    end

    list = SORT_ITEM_LIST_BY_LIFETIME(list);
    local ypos = 0;
    for i=1, #list do
        local item = list[i];
        ypos = ADD_EXPIRED_ITEM(itemlist, item, i, ypos);
    end

    local maxItemPerPage = frame:GetUserConfig("MaxItemPerPage");
    local itemHeight = frame:GetUserConfig("ItemHeight");
    local itemlistHeight = math.min(maxItemPerPage, #list)*itemHeight;
    frame:Resize(frame:GetWidth(), frame:GetOriginalHeight()+itemlist:GetHeight());

	frame:ShowWindow(1);
end

function EXPIREDITEM_ALERT_OK_BTN(frame)
    local timerType = frame:GetUserValue("TimerType");
    RUN_GAMEEXIT_TIMER(timerType)

	frame:ShowWindow(0);
end

function EXPIREDITEM_ALERT_CANCEL_BTN(frame)
	frame:ShowWindow(0);
end
