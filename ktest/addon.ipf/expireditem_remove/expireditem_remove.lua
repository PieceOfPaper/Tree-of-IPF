
function EXPIREDITEM_REMOVE_ON_INIT(addon, frame)

	addon:RegisterMsg('EXPIREDITEM_REMOVE_INIT', 'EXPIREDITEM_REMOVE_ON_MSG');
	addon:RegisterMsg('EXPIREDITEM_REMOVE_OPEN', 'EXPIREDITEM_REMOVE_ON_MSG');

end

function EXPIREDITEM_REMOVE_ON_MSG(frame, msg, argStr, argNum)
	if msg == "EXPIREDITEM_REMOVE_INIT" then
		frame:ShowWindow(0);
		return;
	elseif msg == "EXPIREDITEM_REMOVE_OPEN" then
        EXPIREDITEM_REMOVE_OPEN(frame)
		return;
	end
end

function EXPIREDITEM_REMOVE_OPEN(frame)
    local itemlist = GET_CHILD(frame, 'itemlist', 'ui::CGroupBox');
    itemlist:RemoveAllChild();
    
    local criteriaTimeStr = GET_LATEST_ITEM_LIFE_TIME_OVERED();
    if criteriaTimeStr == nil then
        frame:SetUserValue("CriteriaTime", "None");
    else
        frame:SetUserValue("CriteriaTime", criteriaTimeStr);
    end
    local list = GET_EXPIRED_ITEM_LIST();
    local ypos = 0;
    for i=1, #list do
        local item = list[i];
        ypos = ADD_EXPIRED_ITEM(itemlist, item, i, ypos);
    end
    
    local maxItemPerPage = frame:GetUserConfig("MaxItemPerPage");
    local itemHeight = frame:GetUserConfig("ItemHeight");
    local itemlistHeight = math.min(maxItemPerPage, #list)*itemHeight;    
    itemlist:Resize(itemlist:GetWidth(), itemlist:GetOriginalHeight()+itemlistHeight);
    frame:Resize(frame:GetWidth(), frame:GetOriginalHeight()+itemlist:GetHeight());

	frame:ShowWindow(1);
end

function EXPIREDITEM_REMOVE_OK_BTN(frame)
    local criteriaTimeStr = frame:GetUserValue("CriteriaTime");
    if criteriaTimeStr == nil or criteriaTimeStr == "None" then
        ui.SysMsg(ScpArgMsg("NoTimeExpiredItem"));
    else
	    ReqDeleteExpiredItems(criteriaTimeStr);
    end
	frame:ShowWindow(0);
end

function EXPIREDITEM_REMOVE_CANCEL_BTN(frame)
	frame:ShowWindow(0);
end
