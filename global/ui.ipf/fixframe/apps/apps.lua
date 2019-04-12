-- apps.lua

function APPS_ON_INIT(addon, frame)
end

function APPS_LOSTFOCUS_SCP(frame, ctrl, argStr, argNum)
	local focusFrame = ui.GetFocusFrame();	
	if focusFrame ~= nil then
		local focusFrameName = focusFrame:GetName();		
		if focusFrameName == "apps" or focusFrameName == "sysmenu" then
			return;
		end
	end
	
	ui.CloseFrame("apps");	
end

function APPS_TRY_LEAVE(type)
    if type ~= "Channel" then
        local alertFrame = ui.GetFrame('expireditem_alert');
        local nearFutureSec = tonumber(alertFrame:GetUserConfig("NearFutureSec"));
        if nearFutureSec ~= nil then
            local list = GET_SCHEDULED_TO_EXPIRED_ITEM_LIST(nearFutureSec);
            local needToAskItem = (list ~= nil and #list > 0);
            local needToAskToken = IS_NEED_TO_ALERT_TOKEN_EXPIRATION(nearFutureSec);
            if needToAskItem or needToAskToken then
                addon.BroadMsg("EXPIREDITEM_ALERT_OPEN", type, 0);
                return;
            end
        end
    end
    RUN_GAMEEXIT_TIMER(type)
end

function APPS_TRY_MOVE_BARRACK()
    APPS_TRY_LEAVE("Barrack");
end

function APPS_TRY_LOGOUT()
    APPS_TRY_LEAVE("Logout");
end

function APPS_TRY_EXIT()
    APPS_TRY_LEAVE("Exit");
end

function APPS_INIT_BUTTONS(frame)    
    local attendanceBtn = GET_CHILD(frame, 'attendanceBtn');
    local EXITAPP = GET_CHILD(frame, 'EXITAPP');
    if ATTENDANCE_OPEN_CHECK() == true then
        local margin = EXITAPP:GetOriginalMargin();
        EXITAPP:SetMargin(margin.left, margin.top, margin.right, margin.bottom);
        attendanceBtn:ShowWindow(1);
    else
        local margin = attendanceBtn:GetOriginalMargin();
        EXITAPP:SetMargin(margin.left, margin.top, margin.right, margin.bottom);
        attendanceBtn:ShowWindow(0);        
    end
end