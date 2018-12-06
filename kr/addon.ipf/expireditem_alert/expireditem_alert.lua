
function EXPIREDITEM_ALERT_ON_INIT(addon, frame)
	addon:RegisterMsg('EXPIREDITEM_ALERT_OPEN', 'EXPIREDITEM_ALERT_ON_MSG');

end

function EXPIREDITEM_ALERT_ON_MSG(frame, msg, argStr, argNum)
	if msg == "EXPIREDITEM_ALERT_OPEN" then
        EXPIREDITEM_ALERT_OPEN(frame, argStr)
		return;
	end
end

function ASK_EXPIREDITEM_ALERT_LIFETIME(frame, itemlist, nearFutureSec, startIndex, ypos)
    local list = GET_SCHEDULED_TO_EXPIRED_ITEM_LIST(nearFutureSec);
    list = SORT_ITEM_LIST_BY_LIFETIME(list);
    for i=1, #list do
        local invitem = GET_ITEM_BY_GUID(list[i]);
        if invitem ~= nil then
            local itemObj = GetIES(invitem:GetObject());
            local difSec = GET_REMAIN_ITEM_LIFE_TIME(itemObj);
            local isOver = tonumber(TryGetProp(itemObj, "ItemLifeTimeOver", 0)) == 1;
            local imgName = GET_ITEM_ICON_IMAGE(itemObj);
            ypos = ADD_EXPIRED_ITEM(itemlist, itemObj.Name, imgName, startIndex+i, ypos, difSec, isOver, nil);
        end
    end
    return ypos;
end

function ASK_EXPIREDITEM_ALERT_TOKEN(frame, itemlist, startIndex, ypos)
    local tokenName = frame:GetUserConfig("TokenName");
    local tokenSkin = frame:GetUserConfig("TokenSkin");
    local buff = GetClass("Buff", "Premium_Token");
    local ypos = ADD_EXPIRED_ITEM(itemlist, tokenName, GET_BUFF_ICON_NAME(buff), startIndex+1, ypos, GET_REMAIN_TOKEN_SEC(), false, tokenSkin);
    return ypos;
end

function EXPIREDITEM_ALERT_OPEN(frame, argStr)
    local nearFutureSec = tonumber(frame:GetUserConfig("NearFutureSec"));

    local itemlist = GET_CHILD(frame, 'itemlist', 'ui::CGroupBox');
    itemlist:RemoveAllChild();

    local startIndex = 0;
    local ypos = 0;
    if IS_NEED_TO_ALERT_TOKEN_EXPIRATION(nearFutureSec, itemlist) then
        ypos = ASK_EXPIREDITEM_ALERT_TOKEN(frame, itemlist, startIndex, ypos);
        startIndex = startIndex + 1;
    end
    
    local list = GET_SCHEDULED_TO_EXPIRED_ITEM_LIST(nearFutureSec);
    if #list >= 1 then
        ypos = ASK_EXPIREDITEM_ALERT_LIFETIME(frame, itemlist, nearFutureSec, startIndex, ypos)
        startIndex = startIndex + #list;
    end

    frame:Resize(frame:GetWidth(), frame:GetOriginalHeight()+itemlist:GetHeight());
    frame:SetUserValue("TimerType", argStr);
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
