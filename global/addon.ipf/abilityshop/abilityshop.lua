function ABILITYSHOP_ON_INIT(addon, frame)

	addon:RegisterMsg('ABILSHOP_OPEN', 'ON_ABILITYSHOP_OPEN');
	addon:RegisterMsg('RESET_ABILITY_UP', 'ON_RESET_ABILITY_UP');
end

function ON_ABILITYSHOP_OPEN(frame, msg, abilGroupName, argNum)

	frame:SetUserValue("ABIL_GROUP_NAME",abilGroupName)

	frame:ShowWindow(1);
	REFRESH_ABILITYSHOP(frame, msg);


	local abilityFrame = ui.GetFrame('skilltree');
	if abilityFrame:IsVisible() == 0 then
		abilityFrame:ShowWindow(1);
	end
end

function ABILITYSHOP_CLOSE(addon, frame)
	ui.CloseFrame('skilltree');
	ui.CloseFrame('abilityshop');
end

function ON_RESET_ABILITY_UP(frame, msg, abilGroupName, learnAbilID)

	frame:SetUserValue("ABIL_GROUP_NAME",abilGroupName)
	REFRESH_ABILITYSHOP(frame, msg);
end

function REFRESH_ABILITYSHOP(frame, msg)

	local frame = ui.GetFrame("abilityshop") -- 체크박스에서도 연동해서 쓰므로
	
	local abilGroupName = frame:GetUserValue("ABIL_GROUP_NAME")

	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end

	local gbox = GET_CHILD_RECURSIVELY(frame, 'abilityshopGBox');
	DESTROY_CHILD_BYNAME(gbox, 'ABILSHOP_');
	local posY = 5;

	-- abilGroupName으로 xml에서 해당되는 구입가능한 특성리스트 가져오기
	local abilList, abilListCnt = GetClassList("Ability");
	local abilGroupList, abilGroupListCnt = GetClassList(abilGroupName);

	for i = 0, abilGroupListCnt-1 do

		local groupClass = GetClassByIndexFromList(abilGroupList, i);
		if groupClass ~= nil then
			local abilClass = GetClassByNameFromList(abilList, groupClass.ClassName);
			if abilClass ~= nil then
				posY = MAKE_ABILITYSHOP_ICON(frame, pc, gbox, abilClass, groupClass, posY);
			end
		end
	end

	--grid:Resize(grid:GetOriginalWidth(),posY + 80)

	local invenZeny = GET_CHILD_RECURSIVELY(frame, 'invenZeny', 'ui::CRichText');
	invenZeny:SetText("{@st41b}".. GET_TOTAL_MONEY())

	local abilityshopGBox = GET_CHILD_RECURSIVELY(frame, 'abilityshopGBox');
	abilityshopGBox:UpdateData();
	frame:Invalidate();
end

function MAKE_ABILITYSHOP_ICON(frame, pc, grid, abilClass, groupClass, posY)

	local runCnt = 0;
	for i = 0, RUN_ABIL_MAX_COUNT do
		local prop = "None";
		if 0 == i then
			prop = "LearnAbilityID";
		else
			prop = "LearnAbilityID_" ..i;
		end
		if pc[prop] ~= nil and pc[prop] > 0 then
			runCnt = runCnt +1;
		end
	end
	local userType = session.loginInfo.GetPremiumState();
	local maxCount = GetCashValue(userType, "abilityMax");
	
	local abilIES = GetAbilityIESObject(pc, abilClass.ClassName);
	local abilLv = 1;
	if abilIES ~= nil then
		abilLv = abilIES.Level + 1;
	end

	local isMax = 0;
	-- 특성 구입 버튼.  현재 배우는 특성이 있으면 다른 특성은 다 막기
	local maxLevel = tonumber(groupClass.MaxLevel)
	if maxLevel < abilLv then
		isMax = 1;
	end

	
	local onlyShowLearnable = GET_CHILD_RECURSIVELY(frame,"onlyShowLearnable")

	-- 諛곗슱 ???덈뒗 ?뱀꽦留??쒖떆
	if onlyShowLearnable:IsChecked() == 1 then
	
		if isMax == 1 and runCnt + 1 > maxCount then
			return posY
		end

		local unlockFuncName = groupClass.UnlockScr;
		if unlockFuncName ~= 'None' then
			local scp = _G[unlockFuncName];
			local ret = scp(pc, groupClass.UnlockArgStr, groupClass.UnlockArgNum, abilIES);
			if ret ~= 'UNLOCK' then

				if ret == 'LOCK_GRADE' then
					return posY
				
				elseif ret == 'LOCK_LV' then
					return posY
			
				end
			end
		end

	end

	local classCtrl = grid:CreateOrGetControlSet('abilityshop_set', 'ABILSHOP_'..abilClass.ClassName, 20, posY);
	classCtrl:ShowWindow(1);
	

	if maxLevel >= abilLv then
		if runCnt + 1 > maxCount then
			classCtrl:EnableHitTest(0);
		end
		classCtrl:SetEventScript(ui.LBUTTONUP, "REQUEST_BUY_ABILITY");
		classCtrl:SetEventScriptArgString(ui.LBUTTONUP, abilClass.ClassName);
		classCtrl:SetEventScriptArgNumber(ui.LBUTTONUP, abilClass.ClassID);
		classCtrl:SetOverSound('button_over');
		classCtrl:SetClickSound('button_click_big');
	else
		abilLv = groupClass.MaxLevel;
	end

	-- abilClass관련 정보 셋팅
	-- 특성 아이콘
	local classSlot = GET_CHILD(classCtrl, "slot", "ui::CSlot");
	classSlot:EnableHitTest(0);
	local icon = CreateIcon(classSlot);	
	icon:SetImage(abilClass.Icon);

	-- 특성 이름
	local nameCtrl = GET_CHILD(classCtrl, "abilName", "ui::CRichText");
	nameCtrl:SetText("{@st42}".. abilClass.Name);

	-- 특성 레벨
	local levelCtrl = GET_CHILD(classCtrl, "abilLevel", "ui::CRichText");
	levelCtrl:SetText("Lv.".. abilLv);

	-- 특성 설명
	local descCtrl = GET_CHILD(classCtrl, "abilDesc", "ui::CRichText");
	descCtrl:SetText("{@st66b}".. abilClass.Desc);


	-- groupClass관련 정보 셋팅
	local price = 0;
	local totalTime = 0;
	local funcName = groupClass.ScrCalcPrice;
	if funcName ~= 'None' then
		local scp = _G[funcName];
		price, totalTime = scp(pc, abilClass.ClassName, abilLv, groupClass.MaxLevel);
	else
		abilLv = tonumber(abilLv)
		price = groupClass["Price" .. abilLv];
		totalTime = groupClass["Time" .. abilLv];
	end

--	if IS_SEASON_SERVER(nil) == "YES" then
--		price = price - (price * 0.4)
--	else
--		price = price - (price * 0.2)
--	end

	price = math.floor(price);

	local priceCtrl = GET_CHILD(classCtrl, "abilPrice", "ui::CRichText");	
	priceCtrl:SetText("{img Silver 24 24} {@st42b}{s16}".. price ..ScpArgMsg("Auto__{@st42b}SilBeo"));
	classCtrl:SetUserValue("PRICE_"..abilClass.ClassName, price);
	if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
		totalTime = 0;
	end
	
	local timeCtrl = GET_CHILD(classCtrl, "abilTime", "ui::CRichText");	
	local hour = math.floor( totalTime / 60 );
	local min = totalTime % 60;
	if hour > 0 then
		timeCtrl:SetText("".. hour ..ScpArgMsg("Auto_SiKan_") .. min .. ScpArgMsg("Auto_Bun_Soyo"));
	else
		if min < 1 then

			if min == 0 then
				timeCtrl:SetText(ScpArgMsg("AbilClicker"));
			else
				local sec = math.floor(min * 100);
				timeCtrl:SetText(sec .. ScpArgMsg("Auto_Cho_Soyo"));
			end
		else
			timeCtrl:SetText(min .. ScpArgMsg("Auto_Bun_Soyo"));
		end
	end


	if isMax == 1 then
		priceCtrl:ShowWindow(0);
		timeCtrl:SetText(ScpArgMsg("Auto_{@st}_ChoeKo_LeBel_MaSeuTeo!"));
		levelCtrl:SetText("Lv.".. groupClass.MaxLevel);
	end
	
	local unlockFuncName = groupClass.UnlockScr;
	if unlockFuncName ~= 'None' then
		local scp = _G[unlockFuncName];
		local ret = scp(pc, groupClass.UnlockArgStr, groupClass.UnlockArgNum, abilIES);
		if ret ~= 'UNLOCK' then

			if ret == 'LOCK_GRADE' then
				priceCtrl:ShowWindow(0);
				timeCtrl:SetText(groupClass.UnlockDesc);
				classCtrl:SetGrayStyle(1);
			elseif ret == 'LOCK_LV' then
				priceCtrl:ShowWindow(0);
				timeCtrl:SetText(ScpArgMsg('NeedMorePcLevel'));
				classCtrl:SetGrayStyle(1);
			end
		end
	end


	for i = 0, RUN_ABIL_MAX_COUNT do
		local prop = "None";
		if 0 == i then
			prop = "LearnAbilityID";
		else
			prop = "LearnAbilityID_" ..i;
		end
		if pc[prop] ~= nil and pc[prop] > 0 then
			if pc[prop] == abilClass.ClassID then
			classCtrl:SetGrayStyle(0);
			priceCtrl:SetText(ScpArgMsg("Auto_{@st}TeugSeong_HagSeup_Jung"));
				classCtrl:EnableHitTest(0);
		else
				if runCnt + 1 > maxCount then
				-- 특성을 배우는중이라면 배우는 스킬을 제외하고는 전부 회색으로 변경해야함.
			classCtrl:SetGrayStyle(1);
		end
	end
		end
	end
	classCtrl:Resize(classCtrl:GetOriginalWidth(), descCtrl:GetY() + descCtrl:GetHeight() + 50)

	if classCtrl:GetHeight() < classCtrl:GetOriginalHeight() then
		classCtrl:Resize(classCtrl:GetOriginalWidth(), classCtrl:GetOriginalHeight())
	end

	return posY + classCtrl:GetHeight();
end


s_buyAbilName = 'None';

function REQUEST_BUY_ABILITY(frame, control, abilName, abilID)
	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end

	local runCnt = 0;
	for i = 0, RUN_ABIL_MAX_COUNT do
		local prop = "None";
		if 0 == i then
			prop = "LearnAbilityID";
		else
			prop = "LearnAbilityID_" ..i;
		end
		if pc[prop] ~= nil and pc[prop] > 0 then
			runCnt = runCnt +1;
		end
	end

	local userType = session.loginInfo.GetPremiumState();
	local maxCount = GetCashValue(userType, "abilityMax");
	if runCnt+1 > maxCount then	
		return;
	end

	-- 살건지 확인창 띄우기
	s_buyAbilName = abilName;

	-- 서버에서 시스템 메시지를 보내는데 특성 확인전에서 뿌려주자.
	local topframe = frame:GetTopParentFrame();
	local abilGroupName = topframe:GetUserValue("ABIL_GROUP_NAME")
	local abilClass = GetClass(abilGroupName, s_buyAbilName);

	local unlockFuncName = abilClass.UnlockScr;
	if unlockFuncName ~= 'None' then
		local scp = _G[unlockFuncName];
		local abilIES = GetAbilityIESObject(pc, abilClass.ClassName);
		local ret = scp(pc, abilClass.UnlockArgStr, abilClass.UnlockArgNum, abilIES);
		if ret ~= 'UNLOCK' then
			if ret == 'LOCK_GRADE' then
				ui.SysMsg(ScpArgMsg("Auto__JoKeoneul_ManJogHaJi_MosHaesseum"));
				return;
			elseif ret == 'LOCK_LV' then
				ui.SysMsg(ScpArgMsg("NeedMorePcLevel"));
				return;
			end
		end
	end

	-- 구입가능한지 실버 체크하기
	local price = tonumber( control:GetUserValue("PRICE_"..abilName) );

--	if IS_SEASON_SERVER(nil) == "YES" then
--		price = price - (price * 0.4)
--	else
--		price = price - (price * 0.2)
--	end

	price = math.floor(price);

	if GET_TOTAL_MONEY() < price then
		ui.SysMsg(ScpArgMsg('Auto_SilBeoKa_BuJogHapNiDa.'));
		return;
	end

	local yesScp = string.format("EXEC_BUY_ABILITY()");
	ui.MsgBox(ClMsg('ExecLearnAbility'), yesScp, "None");

end

function EXEC_BUY_ABILITY()

	-- 일단은 특성 바로 배워지는걸로 셋팅. DB시간관련해서는 내일 작업예정.
	pc.ReqExecuteTx("SCR_TX_ABIL_REQUEST", s_buyAbilName);
end


