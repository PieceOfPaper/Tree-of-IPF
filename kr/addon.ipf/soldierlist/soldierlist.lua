

function SOLDIERLIST_ON_INIT(addon, frame)

	addon:RegisterMsg("DUMMYPC_LIST", "SOLLIST_ON_DUMMYPC_LIST");
	addon:RegisterMsg("MAIN_PC_CHANGE", "SOLLLIST_MAIN_PC_CHANGE");
	addon:RegisterMsg("ACCOUNT_UPDATE", "SOLLIST_UPDATE_MEDAL");
	
end

g_MaxSoldierCount = 4;

function SOLDIERLIST_FIRST_OPEN(frame)
	SOLLIST_UPDATE_MEDAL(frame);
end

function SOLLIST_UPDATE_PC(frame, index, cid)

	local dpcObj = nil;
	local pcSession = nil;
	if cid == nil then
		pcSession = session.GetMySession();
	else
		local info = dummyPC.GetByCID(cid);
		dpcObj = GetIES(info:GetObject());
		pcSession = info:GetSession();
	end
	
	local gBox = frame:GetChild("Char_" .. index + 1);
	gBox:SetUserValue("HANDLE", pcSession:GetHandle());

	local pic = GET_CHILD(gBox, "pic", "ui::CPicture");
	local apc = pcSession:GetPCApc();
	local job = apc:GetJob();
	local gender = apc:GetGender();
	local imgName = ui.CaptureModelHeadImageByApperance(apc);
	pic:SetImage(imgName);
	--pic:ShowWindow(1);
	pic:ShowWindow(0);

	local i_medal  = GET_CHILD(gBox, "i_medal", "ui::CPicture");
	if i_medal ~= nil then
		--i_medal:ShowWindow(1);
		i_medal:ShowWindow(0);
	end

	local retMedal = 0;
	local pc = GetCommanderPC();
	local t_medal  = GET_CHILD(gBox, "t_medal", "ui::CRichText");
	if t_medal ~= nil then
		--t_medal:ShowWindow(1);
		t_medal:ShowWindow(0);
		local price = GET_DPC_HIRE_PRICE(pc, dpcObj);
		t_medal:SetTextByKey("Medal", price);
		retMedal = price;
	end

	return retMedal;
end

function SOOLIST_CLEAR_PC(frame, i)

	local gBox = frame:GetChild("Char_" .. i + 1);
	SHOW_CHILD_LIST(gBox, 0);

end

function SOLLIST_ON_DUMMYPC_LIST(frame, msg, str, num)

	local isVisible = frame:IsVisible();
	local cnt = dummyPC.GetHiredCount();
	if cnt == 0 then
		frame:ShowWindow(0);
		return;
	end

	local realCount = 0;
	local endIndex = math.min(g_MaxSoldierCount - 1, cnt);
	for i = 0 , endIndex - 1 do
		local cid = dummyPC.GetHiredCIDByIndex(i);
		local info = dummyPC.GetByCID(cid);
		if info:IsEnableSession() == true then
			realCount = realCount + 1;
		end
	end

	if realCount == 0 then
		frame:ShowWindow(0);
		return;
	end
	
	--frame:ShowWindow(1);
	frame:ShowWindow(0);
	for i = 1 , g_MaxSoldierCount - 1 do
		SOOLIST_CLEAR_PC(frame, i);
	end

	local totalMedal = 0;
	SOLLIST_UPDATE_PC(frame, 0);
	for i = 0 , endIndex - 1 do
		local cid = dummyPC.GetHiredCIDByIndex(i);
		local info = dummyPC.GetByCID(cid);
		if info:IsEnableSession() == true then
			totalMedal = totalMedal + SOLLIST_UPDATE_PC(frame, i + 1, cid);
		end
	end

	SET_CHILD_TEXT_BY_KEY(frame, "t_medalpermin", "perMin", totalMedal);

	if isVisible == 0 then
		SOLLLIST_UPDATE_MAINPC(frame);
	end

	frame:Invalidate();

end

function SOLLLIST_UPDATE_MAINPC(frame)

	local mains = session.GetMainSession();
	local mys = session.GetMySession();
	local mypcMain = 0;
	local showHireUI = 1;
	if mys == mains then
		mypcMain = 1;
		showHireUI = 0;
	end
	
	SHOW_CHILD_BY_NAME(frame, "t_mainCharMedal", showHireUI);
	SHOW_CHILD_BY_NAME(frame, "t_mainCharHireTime_t", showHireUI);
	SHOW_CHILD_BY_NAME(frame, "t_mainCharHireTime", showHireUI);
	SHOW_CHILD_BY_NAME(frame, "b_mainCharFire", showHireUI);

	local apc = mains:GetPCApc();
	frame:GetChild("t_mainCharName"):SetTextByKey("MainName", apc:GetName());
	frame:GetChild("t_mainCharJob"):SetTextByKey("MainName", apc:GetJobName());
	frame:GetChild("t_mainCharLevel"):SetTextByKey("MainLv", apc:GetLv());	

	if mypcMain == 0 then
		local comPc = GetCommanderPC();
		local info = dummyPC.GetByCID(mains:GetCID());
		local dpcObj = GetIES(info:GetObject());
		local price = GET_DPC_HIRE_PRICE(comPc, dpcObj);
		SET_CHILD_TEXT_BY_KEY(frame, "t_mainCharMedal", "MainMedal", price);
		
		local hiredTime = info:GetHiredTime();
		local timeString = GET_DHMS_STRING(hiredTime);		
		SET_CHILD_TEXT_BY_KEY(frame, "t_mainCharHireTime", "MainCharHireTime", timeString);
		frame:RunUpdateScript("UPDATE_HIRE_TIME", 0.25, 0);
	else
		frame:StopUpdateScript("UPDATE_HIRE_TIME");
	end

	local mainIndex = 1;
	if mypcMain ~= 1 then
		local cnt = dummyPC.GetHiredCount();
		for i = 0 , cnt - 1 do
			local cid = dummyPC.GetHiredCIDByIndex(i);
			local info = dummyPC.GetByCID(cid);
			if info:GetSession() == mains then
				mainIndex = i + 2;
			end
		end
	end

	local mainSkin = frame:GetUserConfig("MainPCBoxSkin");
	local subSkin = frame:GetUserConfig("SubPCBoxSkin");
	for i = 1 , g_MaxSoldierCount do
		local gBox = frame:GetChild("Char_" .. i);
		if i == mainIndex then
			gBox:SetSkinName(mainSkin);
		else
			gBox:SetSkinName(subSkin);
		end
	end
end

function SOL_FIRE(frame)

	local mains = session.GetMainSession();
	local mys = session.GetMySession();
	local mypcMain = 0;
	local showHireUI = 1;
	if mys ~= mains then
		dummyPC.Fire(mains:GetHandle());
	end
end

function UPDATE_HIRE_TIME(frame, totalElapsedTime)

	local mains = session.GetMainSession();
	local info = dummyPC.GetByCID(mains:GetCID());
	local hiredTime = info:GetHiredTime();
	local d = totalElapsedTime - math.floor(totalElapsedTime);
	local timeString = GET_DHMS_STRING(hiredTime);
	SET_CHILD_TEXT_BY_KEY(frame, "t_mainCharHireTime", "MainCharHireTime", timeString);

	frame:Invalidate();
	
	return 1;
end

function SOL_DPC_CONTROL(frame, ctrl)
--[[
	local gBoxName = frame:GetName();
	local handle = frame:GetUserIValue("HANDLE");
	gBoxName = string.sub(gBoxName, string.len(gBoxName), string.len(gBoxName));
	frame = frame:GetTopParentFrame();

	dummyPC.ToMainPC(handle);
	]]
end

function SOLLLIST_MAIN_PC_CHANGE(frame, msg, str, num)

	SOLLLIST_UPDATE_MAINPC(frame);
	frame:Invalidate();

end

function SOLLIST_UPDATE_MEDAL(frame)
	
	local aobj = GetMyAccountObj();
	SET_CHILD_TEXT_BY_KEY(frame, "t_medalpermin", "curMedal", GET_CASH_TOTAL_POINT_C());

end








