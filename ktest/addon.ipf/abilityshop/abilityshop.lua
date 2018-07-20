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
	local abilGroupList, abilGroupListCnt = GetClassList(abilGroupName);

    if session.IsGM() == 1 and abilGroupName == 'Ability_Warrior' then
        IMC_NORMAL_INFO("GetClassList("..abilGroupName.."), count("..abilGroupListCnt..")");
    end

	for i = 0, abilGroupListCnt-1 do
		local groupClass = GetClassByIndexFromList(abilGroupList, i);
		if groupClass ~= nil then
			local abilClass = GetClass('Ability', groupClass.ClassName);
			if abilClass ~= nil then
				posY = MAKE_ABILITYSHOP_ICON(frame, pc, gbox, abilClass, groupClass, posY);
            else
                IMC_NORMAL_INFO("GetClass from Ability fail:className("..groupClass.ClassName..")");
			end
        else
            IMC_NORMAL_INFO("GetClass from Ability_[Group] fail: abilGroupName("..abilGroupName.."), index("..i..")");
		end
	end

	--grid:Resize(grid:GetOriginalWidth(),posY + 80)

	local invenZeny = GET_CHILD_RECURSIVELY(frame, 'invenZeny', 'ui::CRichText');
	invenZeny:SetText("{@st41b}".. GET_TOTAL_MONEY())

	local abilityshopGBox = GET_CHILD_RECURSIVELY(frame, 'abilityshopGBox');
	abilityshopGBox:UpdateData();
	frame:Invalidate();
end

function IS_ABILITY_MAX(pc, groupClass, abilClass)
	local abilIES = GetAbilityIESObject(pc, abilClass.ClassName);
	local curLv = 0;
	if abilIES ~= nil then
		curLv = abilIES.Level;
	end	

	local isMax = 0;	
	local maxLevel = tonumber(groupClass.MaxLevel)
	if curLv >= maxLevel then
		isMax = 1;
	end

	return isMax;
end

function GET_ABILITY_LEARN_COST(pc, groupClass, abilClass, destLv)

	local abilIES = GetAbilityIESObject(pc, abilClass.ClassName);
	local curLv = 0;
	if abilIES ~= nil then
		curLv = abilIES.Level;
	end	
	local funcName = groupClass.ScrCalcPrice;

	local price = 0;
	local totalTime = 0;
	local tempPrice = 0;
	local tempTotalTime = 0;

	if funcName ~= 'None' then
		for abilLv = curLv+1, destLv, 1 do
			local scp = _G[funcName];
			tempPrice, tempTotalTime = scp(pc, abilClass.ClassName, abilLv, groupClass.MaxLevel);

			tempPrice = GET_ABILITY_PRICE(tempPrice, groupClass, abilClass, abilLv)
			price = price + tempPrice;			
			tempTotalTime = math.floor(tempTotalTime);
			totalTime = totalTime + tempTotalTime;
		end
	else
		for abilLv = curLv+1, destLv, 1 do
			tempPrice = groupClass["Price" .. abilLv];
			tempTotalTime = groupClass["Time" .. abilLv];
			tempPrice = GET_ABILITY_PRICE(tempPrice, groupClass, abilClass, abilLv)
			price = price + tempPrice;			
			tempTotalTime = math.floor(tempTotalTime);
			totalTime = totalTime + tempTotalTime;	
		end
	end
				
	if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
		totalTime = 0;
	end
	
	return price, totalTime
end

function SET_ABILITY_PRICE_CTRL(classCtrl, priceCtrl, abilClass, price)
	priceCtrl:SetText("{img Silver 24 24} {@st42b}{s16}".. price);
	classCtrl:SetUserValue("PRICE_"..abilClass.ClassName, price);
end
	
function SET_ABILITY_MAX_LEVEL_CTRL(frame, maxLevelCtrl, abilGroupName, abilClass)
	local topframe = frame:GetTopParentFrame();
	local abilGroupName = topframe:GetUserValue("ABIL_GROUP_NAME")
	local abilGroupClass = GetClass(abilGroupName, abilClass.ClassName);
	maxLevelCtrl:SetText("Lv." .. abilGroupClass.MaxLevel);	
end
	
function SET_ABILITY_TIME_CTRL(timeCtrl, groupClass, totalTime)
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
end

--호출.
function SET_ABILITY_COST_CTRL(frame, classCtrl, pc, groupClass, abilClass, count)
	classCtrl:SetUserValue("COUNT_"..abilClass.ClassName, count);
	
	-- 레벨 출력 변경
	local levelCtrl = GET_CHILD(classCtrl, "abilLevel", "ui::CRichText");
	abilIES = GetAbilityIESObject(pc, abilClass.ClassName);
	local curLv = TryGetProp(abilIES, "Level");
	if curLv == nil then
		curLv = 0;
	end
	
	-- 특성 레벨
	local curLvMsg = ClMsg("NotLearnedYet")
	if abilIES ~= nil then
		curLvMsg = "Lv.".. curLv;
	end
	
	if count == 0 then
		levelCtrl:SetText(curLvMsg);
	else 
		levelCtrl:SetText(curLvMsg .. "{@st66d_y}" .. " (+" .. count .. ")");
	end

	local price = 0;
	local totalTime = 0;
	
	count = tonumber(count)
	if count > 0 then
		price, totalTime = GET_ABILITY_LEARN_COST(pc, groupClass, abilClass, curLv + count);
	end
	
	local priceCtrl = GET_CHILD(classCtrl, "abilPrice", "ui::CRichText");	
	local maxLevelCtrl = GET_CHILD(classCtrl, "abilLevelMax", "ui::CRichText");	
	local timeCtrl = GET_CHILD(classCtrl, "abilTime", "ui::CRichText");		

	SET_ABILITY_PRICE_CTRL(classCtrl, priceCtrl, abilClass, price)
	SET_ABILITY_MAX_LEVEL_CTRL(frame, maxLevelCtrl, abilGroupName, abilClass)
	SET_ABILITY_TIME_CTRL(timeCtrl, groupClass, totalTime)
	
	local unlockFuncName = groupClass.UnlockScr;
	if unlockFuncName ~= 'None' then
		local scp = _G[unlockFuncName];
		local ret = scp(pc, groupClass.UnlockArgStr, groupClass.UnlockArgNum, abilIES);
		if ret ~= 'UNLOCK' then
			if ret == 'LOCK_GRADE' then
				timeCtrl:SetText(groupClass.UnlockDesc);
			elseif ret == 'LOCK_LV' then
				timeCtrl:SetText(ScpArgMsg('NeedMorePcLevel'));
			end
		end
	end
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
	local abilLv = 0;
	if abilIES ~= nil then
		abilLv = abilIES.Level;
	end
	
	-- 특성 구입 버튼.  현재 배우는 특성이 있으면 다른 특성은 다 막기
	local maxLevel = tonumber(groupClass.MaxLevel)
	local isMax = IS_ABILITY_MAX(pc, groupClass, abilClass);	
	local onlyShowLearnable = GET_CHILD_RECURSIVELY(frame,"onlyShowLearnable")

	-- 배울 ????는 ??성????시
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
		local learnBtn = GET_CHILD(classCtrl, "abilLearn", "ui::CButton");
		learnBtn:SetEventScript(ui.LBUTTONUP, "REQUEST_BUY_ABILITY");
		learnBtn:SetEventScriptArgString(ui.LBUTTONUP, abilClass.ClassName);
		learnBtn:SetEventScriptArgNumber(ui.LBUTTONUP, abilClass.ClassID);
		learnBtn:SetOverSound('button_over');
		learnBtn:SetClickSound('button_click_big');

		local addBtn = GET_CHILD(classCtrl, "abilAdd", "ui::CButton");
		addBtn:SetEventScript(ui.LBUTTONUP, "ADD_ABILITY_COUNT");
		addBtn:SetEventScriptArgString(ui.LBUTTONUP, abilClass.ClassName);
		addBtn:SetEventScriptArgNumber(ui.LBUTTONUP, abilClass.ClassID);
		addBtn:SetEventScript(ui.RBUTTONUP, "ADD_TEN_ABILITY_COUNT");
		addBtn:SetEventScriptArgString(ui.RBUTTONUP, abilClass.ClassName);
		addBtn:SetEventScriptArgNumber(ui.RBUTTONUP, abilClass.ClassID);
		addBtn:SetOverSound('button_over');
		addBtn:SetClickSound('button_click_big');
		
		local revBtn = GET_CHILD(classCtrl, "abilRevert", "ui::CButton");
		revBtn:SetEventScript(ui.LBUTTONUP, "REVERT_ABILITY_COUNT");
		revBtn:SetEventScriptArgString(ui.LBUTTONUP, abilClass.ClassName);
		revBtn:SetEventScriptArgNumber(ui.LBUTTONUP, abilClass.ClassID);
		revBtn:SetOverSound('button_over');
		revBtn:SetClickSound('button_click_big');
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
	
	-- 특성 설명
	local descCtrl = GET_CHILD(classCtrl, "abilDesc", "ui::CRichText");
	local bg3 = GET_CHILD(classCtrl, "bg3", "ui::CGroupBox");
	descCtrl:SetText("{@st65}".. abilClass.Desc);
	bg3:Resize(bg3:GetOriginalWidth(), descCtrl:GetHeight()+10);
	
	-- groupClass관련 정보 셋팅, 실버/시간 비용 세팅
	local initialCnt = 1;
	if isMax == 1 then
		initialCnt = 0;
	end
	
	ABILITYSHOP_SHOW_PRICE(classCtrl, isMax);
	SET_ABILITY_COST_CTRL(frame, classCtrl, pc, groupClass, abilClass, initialCnt)

	local priceCtrl = GET_CHILD(classCtrl, "abilPrice", "ui::CRichText");
	for i = 0, RUN_ABIL_MAX_COUNT do
		local prop = "None";
		if 0 == i then
			prop = "LearnAbilityID";
		else
			prop = "LearnAbilityID_" ..i;
		end
		if pc[prop] ~= nil and pc[prop] > 0 then
			if pc[prop] == abilClass.ClassID then
				priceCtrl:SetText(ScpArgMsg("Auto_{@st}TeugSeong_HagSeup_Jung"));
			else
				if runCnt + 1 > maxCount then
				-- 특성을 배우는중이라면 배우는 스킬을 제외하고는 전부 회색으로 변경해야함.
					classCtrl:SetSkinName("test_skin_gary_01");
				end
			end
		end
	end
	
	if abilLv == 0 then
		classCtrl:SetSkinName("test_skin_gary_01");
	elseif isMax == 1 then
		classCtrl:SetSkinName("test_skin_01_btn_cursoron");
	end
	
	local timeCtrl = GET_CHILD(classCtrl, "abilTime", "ui::CRichText");	
	local levelCtrl = GET_CHILD(classCtrl, "abilLevel", "ui::CRichText");	

	local diffAbilTimeHeight = timeCtrl:GetHeight() - 20;
	if diffAbilTimeHeight > 0 then
		descCtrl:Move(0, diffAbilTimeHeight);
		bg3:Move(0, diffAbilTimeHeight);
	end

	if isMax == 1 then		
		timeCtrl:SetText(ScpArgMsg("Auto_{@st}_ChoeKo_LeBel_MaSeuTeo!"));
		levelCtrl:SetText("Lv.".. groupClass.MaxLevel);	
	end
	
	local priceSize = 60;
	if isMax == 1 then
		priceSize = 16;
	end
	classCtrl:Resize(classCtrl:GetOriginalWidth(), descCtrl:GetY() + descCtrl:GetHeight() + priceSize)
	if classCtrl:GetHeight() < classCtrl:GetOriginalHeight() then
		classCtrl:Resize(classCtrl:GetOriginalWidth(), classCtrl:GetOriginalHeight())
	end

	return posY + classCtrl:GetHeight();
end

function ABILITYSHOP_SHOW_PRICE(classCtrl, isMax)	
	local showPrice = 0;
	if isMax == 0 then 
		showPrice = 1;
	end

	local bg2 = GET_CHILD(classCtrl, "bg2", "ui::CGroupBox");
	local abilPrice = GET_CHILD(classCtrl, "abilPrice", "ui::CRichText");
	local abilAdd = GET_CHILD(classCtrl, "abilAdd", "ui::CButton");
	local abilRevert = GET_CHILD(classCtrl, "abilRevert", "ui::CButton");
	local abilLearn = GET_CHILD(classCtrl, "abilLearn", "ui::CButton");

	bg2:ShowWindow(showPrice);
	abilPrice:ShowWindow(showPrice);
	abilAdd:ShowWindow(showPrice);
	abilRevert:ShowWindow(showPrice);
	abilLearn:ShowWindow(showPrice);
end

function CHECK_LEARNING_ABILITY(pc, abilID)
	for i = 0, RUN_ABIL_MAX_COUNT do
		local prop = "None";
		if 0 == i then
			prop = "LearnAbilityID";
		else
			prop = "LearnAbilityID_" ..i;
		end
		if pc[prop] ~= nil and pc[prop] > 0 then
			if pc[prop] == abilID then
				ui.SysMsg(ScpArgMsg('LearningAbilityTime'));
				return 1;
			end
		end
	end
	return 0;
end

function REVERT_ABILITY_COUNT(frame, control, abilName, abilID)
	local pc = GetMyPCObject();
	if CHECK_LEARNING_ABILITY(pc, abilID) == 1 then
		return;
	end

	local topframe = frame:GetTopParentFrame();
	local abilGroupName = topframe:GetUserValue("ABIL_GROUP_NAME")
	local groupClass = GetClass(abilGroupName, abilName);
	local abilClass = GetClass("Ability", abilName);

	local isMax = IS_ABILITY_MAX(pc, groupClass, abilClass)
	local addCount = 1;
	if isMax == 1 then
		addCount = 0;
	end

	SET_ABILITY_COUNT(frame, control, abilName, abilID, addCount)
end

function ADD_ABILITY_COUNT(frame, control, abilName, abilID)
	local pc = GetMyPCObject();
	if CHECK_LEARNING_ABILITY(pc, abilID) == 1 then
		return;
	end

	local classCtrl = control:GetParent();
	local addCount = classCtrl:GetUserValue("COUNT_"..abilName);
		
	if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
		addCount = addCount + 1;
	else
		ui.SysMsg(ScpArgMsg("OnlyTokenUserAbilCount"));
		addCount = 1;
	end
	
	SET_ABILITY_COUNT(frame, control, abilName, abilID, addCount)
end

function ADD_TEN_ABILITY_COUNT(frame, control, abilName, abilID)
	local pc = GetMyPCObject();
	if CHECK_LEARNING_ABILITY(pc, abilID) == 1 then
		return;
	end

	local classCtrl = control:GetParent();  
	local addCount = classCtrl:GetUserValue("COUNT_"..abilName);
	
	if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
		addCount = addCount + 10;
	else
		ui.SysMsg(ScpArgMsg("OnlyTokenUserAbilCount"));
		addCount = 1;
	end
		
	SET_ABILITY_COUNT(frame, control, abilName, abilID, addCount)
end

function SET_ABILITY_COUNT(frame, control, abilName, abilID, count)
	local classCtrl = control:GetParent();

	--max level check	
	local topframe = frame:GetTopParentFrame();
	local abilGroupName = topframe:GetUserValue("ABIL_GROUP_NAME")	
	local abilClass = GetClass("Ability", abilName);	
	local groupClass = GetClass(abilGroupName, abilName);	
	local pc = GetMyPCObject();
	local abilIES = GetAbilityIESObject(pc, abilClass.ClassName);

	local unlockFuncName = groupClass.UnlockScr;
	if unlockFuncName ~= 'None' then
		local scp = _G[unlockFuncName];
		local ret = scp(pc, groupClass.UnlockArgStr, groupClass.UnlockArgNum, abilIES);
		if ret ~= 'UNLOCK' then
			return;
		end
	end
	
	--어빌 맥스 레벨보다 높게 못올린다.
	local curLevel = 0;
	local destLevel = count;
	if abilIES ~= nil then
		curLevel = abilIES.Level;
		destLevel = count + curLevel;
	end
	if destLevel > groupClass.MaxLevel then
		count = groupClass.MaxLevel - curLevel;
	end

	-- 코스트 가져오기
	SET_ABILITY_COST_CTRL(frame, classCtrl, pc, groupClass, abilClass, count);
end

s_buyAbilName = 'None';
s_buyAbilCount = 0;
function REQUEST_BUY_ABILITY(frame, control, abilName, abilID)	
	local pc = GetMyPCObject();
	if pc == nil then
		return;
	end
	if CHECK_LEARNING_ABILITY(pc, abilID) == 1 then
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

		if abilIES ~= nil then
		--어빌 맥스 레벨보다 높게 못올린다.
			if abilIES.Level >= abilClass.MaxLevel then
				ui.SysMsg(ScpArgMsg("AbilityLevelMax"));
				return;
			end
		end

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
	local ctrlSet = control:GetParent();
	local addBtn = GET_CHILD(ctrlSet, "abilAdd", "ui::CButton");
	local addCount = tonumber( ctrlSet:GetUserValue("COUNT_"..abilName) );
	local price = tonumber( ctrlSet:GetUserValue("PRICE_"..abilName) );
	s_buyAbilCount = addCount;
	
	if GET_TOTAL_MONEY() < price then
		ui.SysMsg(ScpArgMsg('Auto_SilBeoKa_BuJogHapNiDa.'));
		return;
	end

	local yesScp = string.format("EXEC_BUY_ABILITY()");
	ui.MsgBox(ClMsg('ExecLearnAbility'), yesScp, "None");

end

function GET_ABILITY_PRICE(price, groupClass, abilClass, abilLv)
    -- 랭크 초기화권 사용 전에 배웠던 특성은 0실버
    if GetBeforeAbilityLevel(nil, abilClass.ClassName) >= abilLv then
        price = 0
        return price
    end
    
	if IS_SEASON_SERVER(nil) == "YES" then
		price = price - (price * 0.4)
--	else
--	    price = price - (price * 0.2)
	end
	
  if (GetServerNation() == "KOR" and GetServerGroupID() == 9001) then --큐폴 서버
    price = price - (price * 0.8)
  end
  
	price = math.floor(price);
	
	return price;
end

function EXEC_BUY_ABILITY()
	ui.Chat("/learnpcabil " .. s_buyAbilName .. " " .. tostring(s_buyAbilCount));
end