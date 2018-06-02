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

function GAME_TO_BARRACK() --3랭 이하면 그냥 되도록 해야함

--local totalJobGrade = session.GetPcTotalJobGrade();
--if totalJobGrade < 3 then
--	app.GameToBarrack(false)
--	return
--end
	session.SaveQuickSlot(true);
	for i = 0, AUTO_SELL_COUNT-1 do
	-- 뭐하나라도 true면
		if session.autoSeller.GetMyAutoSellerShopState(i) == true then
			app.GameToBarrack(true)
			return;
		end
	end
	app.GameToBarrack(false)
--local logoutinfoframe = ui.GetFrame("logoutinfo");
--
--local explaintext = GET_CHILD_RECURSIVELY(logoutinfoframe, "explaintext")
--explaintext:SetText(ScpArgMsg("DoBackToBarrack"))
--
--local remainbtn = GET_CHILD_RECURSIVELY(logoutinfoframe, "remainbtn")
--remainbtn:SetTextByKey("value",GET_DPC_REMAIN_PC_PRICE())
--
--logoutinfoframe:SetUserValue("LOGOUT_TYPE","tobarrack")
--logoutinfoframe:ShowWindow(1)
end

function GAME_TO_LOGIN()

--local totalJobGrade = session.GetPcTotalJobGrade();
--if totalJobGrade < 3 then
--	app.GameToLogin(false)
--	return
--end

	session.SaveQuickSlot(true);
	for i = 0, AUTO_SELL_COUNT-1 do
	-- 뭐하나라도 true면
		if session.autoSeller.GetMyAutoSellerShopState(i) == true then
			app.GameToLogin(true)
			return;
		end
	end
	app.GameToLogin(false)
--local logoutinfoframe = ui.GetFrame("logoutinfo");
--
--local explaintext = GET_CHILD_RECURSIVELY(logoutinfoframe, "explaintext")
--explaintext:SetText(ScpArgMsg("DoBackToLogin"))
--
--local remainbtn = GET_CHILD_RECURSIVELY(logoutinfoframe, "remainbtn")
--remainbtn:SetTextByKey("value",GET_DPC_REMAIN_PC_PRICE())
--
--logoutinfoframe:SetUserValue("LOGOUT_TYPE","tologin")
--logoutinfoframe:ShowWindow(1)
end

function DO_QUIT_GAME()

--local totalJobGrade = session.GetPcTotalJobGrade();
--if totalJobGrade < 3 then
--	app.Quit(false)
--	return
--end

	session.SaveQuickSlot(true);
	for i = 0, AUTO_SELL_COUNT-1 do
	-- 뭐하나라도 true면
		if session.autoSeller.GetMyAutoSellerShopState(i) == true then
			app.Quit(true)
			return;
		end
	end
	app.Quit(false)
--local logoutinfoframe = ui.GetFrame("logoutinfo");
--
--local explaintext = GET_CHILD_RECURSIVELY(logoutinfoframe, "explaintext")
--explaintext:SetText(ScpArgMsg("DoGameExit"))
--
--local remainbtn = GET_CHILD_RECURSIVELY(logoutinfoframe, "remainbtn")
--remainbtn:SetTextByKey("value",GET_DPC_REMAIN_PC_PRICE())
--
--logoutinfoframe:SetUserValue("LOGOUT_TYPE","quit")
--logoutinfoframe:ShowWindow(1)
end