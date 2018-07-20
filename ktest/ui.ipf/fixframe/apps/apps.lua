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
	메뉴 계속 활성화 되어있도록 해서 주석처리
	local sysmenuFrame = ui.GetFrame("sysmenu");
	if 1 == sysmenuFrame:GetUserIValue("DISABLE_L_FOCUS") then
		return;
	end
	
	sysmenuFrame:SetEffect("sysmenu_LostFocus", ui.UI_TEMP0);
	sysmenuFrame:StartEffect(ui.UI_TEMP0);
	]]
end

function APPS_TRY_MOVE_BARRACK()
	RUN_GAMEEXIT_TIMER("Barrack");
end

function APPS_TRY_LOGOUT()
	RUN_GAMEEXIT_TIMER("Logout");
end

function APPS_TRY_EXIT()
	RUN_GAMEEXIT_TIMER("Exit");
end