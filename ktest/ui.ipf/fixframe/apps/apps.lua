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
	
	--[[
	�޴� ��� Ȱ��ȭ �Ǿ��ֵ��� �ؼ� �ּ�ó��
	local sysmenuFrame = ui.GetFrame("sysmenu");
	if 1 == sysmenuFrame:GetUserIValue("DISABLE_L_FOCUS") then
		return;
	end
	
	sysmenuFrame:SetEffect("sysmenu_LostFocus", ui.UI_TEMP0);
	sysmenuFrame:StartEffect(ui.UI_TEMP0);
	]]
end
function APPS_TRY_LEAVE(type)
    local alertFrame = ui.GetFrame('expireditem_alert');
    local nearFutureSec = alertFrame:GetUserConfig("NearFutureSec");
    if nearFutureSec ~= nil and nearFutureSec ~= "None" then
        if 1 == EnableExpiredItemAlert() then
            local list = GET_SCHEDULED_TO_EXPIRED_ITEM_LIST(nearFutureSec);
            if list ~= nil and #list > 0 then
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
