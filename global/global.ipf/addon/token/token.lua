function BEFORE_APPLIED_TOKEN_OPEN(invItem)
	local frame = ui.GetFrame("token");
	if invItem.isLockState then 
		frame:ShowWindow(0)
		return;
	end

	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end
	local token_middle = GET_CHILD(frame, "token_middle", "ui::CPicture");
	token_middle:SetImage("token_middle");

	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
		for i = 0 , 3 do
		local str, value = GetCashInfo(ITEM_TOKEN, i);
		if str ~= 'abilityMax' then
			local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);		
			local prop = ctrlSet:GetChild("prop");

			local normal = GetCashValue(0, str) 
			local txt = "None"
			if str == "marketSellCom" then
				normal = normal + 0.01;
				value = value + 0.01;
				local img = string.format("{img 67percent_image %d %d}",55, 45) 
				prop:SetTextByKey("value", img..ClMsg(str)); 
				txt = string.format("{img 67percent_image2 %d %d}", 100, 45) 
			elseif str == "speedUp"then
				local img = string.format("{img 3plus_image %d %d}", 55, 45) 
				prop:SetTextByKey("value",img.. ClMsg(str)); 
				txt = string.format("{img 3plus_image2 %d %d}", 100, 45) 
			else
				local img = string.format("{img 9plus_image %d %d}", 55, 45) 
				prop:SetTextByKey("value", img..ClMsg(str)); 
				txt = string.format("{img 9plus_image2 %d %d}", 100, 45) 
			end

			local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
			value:SetTextByKey("value", txt); 
		end
	end

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 4,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	local imag = string.format(TOKEN_GET_IMGNAME1(), 55, 45) 
	prop:SetTextByKey("value", imag.. ScpArgMsg("Token_ExpUp{PER}", "PER", " ")); 
	local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
	imag = string.format(TOKEN_GET_IMGNAME2(), 100, 45) 
	value:SetTextByKey("value", imag); 
	
	local itemobj = GetIES(invItem:GetObject());
	if itemobj.NumberArg2 > 0 then
		local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_TOKEN_TRADECOUNT",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local prop = GET_CHILD(ctrlSet, "prop");
		local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
		local img = string.format("{img dealok_image %d %d}", 55, 45) 
		prop:SetTextByKey("value", img .. ScpArgMsg("AllowTradeByCount"));
        value:SetTextByKey("value", '');
	else
		gBox:RemoveChild("CTRLSET_TOKEN_TRADECOUNT");	
	end	

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 5,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img paid_pose_image %d %d}", 55, 45) 
    prop:SetTextByKey("value", imag..ClMsg("AllowPremiumPose")); 
    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
    value:ShowWindow(0);

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 6,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img paid_pose_image %d %d}", 55, 45)
    prop:SetTextByKey("value", imag..ClMsg("CanGetMoneyByMarketImmediately")); 
    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
    value:ShowWindow(0);

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 7,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img MarketLimitedRM_image %d %d}", 55, 45)
    prop:SetTextByKey("value", imag..ClMsg("CanRegisterMarketRegradlessOfLimit")); 
    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
    value:ShowWindow(0);

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 8,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img teamcabinet_image %d %d}", 55, 45)
    prop:SetTextByKey("value", imag..ClMsg("TeamWarehouseEnable")); 
    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
    value:ShowWindow(0);

--    local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 9,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
--    local prop = ctrlSet:GetChild("prop");
--    local imag = string.format("{img 1plus_image %d %d}", 55, 45)
--    prop:SetTextByKey("value", imag..ClMsg("Mission_Reward")); 
--    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
--    value:ShowWindow(0);

--    local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 10,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
--    local prop = ctrlSet:GetChild("prop");
--    local imag = string.format("{img 2minus_image %d %d}", 55, 45)
--    prop:SetTextByKey("value", imag..ClMsg("RaidStance")); 
--    local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
--    value:ShowWindow(0);

	ADD_2PLUS_IMAGE(gBox)

	GBOX_AUTO_ALIGN(gBox, 0, 2, 0, true, false);
  -- 혹시나 저처럼 고생하시는 분이 생길가 적습니다. 해당 부분은 토큰의 실제 적용 시간에 여유분을 두기 때문에 UI 상 출력시간을 보정하는 곳입니다.
  -- 여기 작성 안하면 계속 시간이 이상하게 나올거에요
	local arg1 = itemobj.NumberArg1;
	if itemobj.ClassName == "PremiumToken" or itemobj.ClassName == "PremiumToken_event" or itemobj.ClassName == "PremiumToken_New_Return" then
		arg1 = 2592000 --30일
	elseif itemobj.ClassName == "PremiumToken_5d" or itemobj.ClassName == "PremiumToken_5d_Steam" or itemobj.ClassName == "PremiumToken_5d_event" then
		arg1 = 432000 -- 5일
	elseif itemobj.ClassName == "PremiumToken_1d" or itemobj.ClassName == "PremiumToken_7d_Steam" then
		arg1 = 604800 -- 7일
	elseif itemobj.ClassName == "PremiumToken_24h" then
		arg1 = 86400 -- 1일
	elseif itemobj.ClassName == "PremiumToken_3d" or itemobj.ClassName == "PremiumToken_3d_Steam" or itemobj.ClassName == "PremiumToken_3d_event" then
		arg1 = 259200 -- 3일
	elseif itemobj.ClassName == "PremiumToken_12h" then
		arg1 = 43200 -- 12시간
	elseif itemobj.ClassName == "PremiumToken_6h" then
		arg1 = 21600 -- 6시간
	elseif itemobj.ClassName == "PremiumToken_3h" or itemobj.ClassName == "PremiumToken_3h_event" then
		arg1 = 10800 -- 3시간
	elseif itemobj.ClassName == "PremiumToken_15d" or itemobj.ClassName == "PremiumToken_15d_Steam" or itemobj.ClassName == "PremiumToken_15d_vk" then
		arg1 = 1296000 -- 15일
        elseif itemobj.ClassName == "PremiumToken_30d" then
		arg1 = 2592000 -- 30O
	elseif itemobj.ClassName == "PremiumToken_60d" then
		arg1 = 5184000 -- 60O
	elseif itemobj.ClassName == "steam_PremiumToken_30day" then
		arg1 = 2592000 -- 30O
	elseif itemobj.ClassName == "steam_PremiumToken_60d" then
		arg1 = 5184000 -- 60O
        elseif itemobj.ClassName == "steam_PremiumToken_7d" then
		arg1 = 604800 -- 70
	end
	local endTime = GET_TIME_TXT(arg1, 1)
	local endTxt = frame:GetChild("endTime");
	endTxt:SetTextByKey("value", endTime); 

	local strTxt = frame:GetChild("richtext_1");
	strTxt:SetTextByKey("value", ClMsg(itemobj.ClassName)); 

	local bg2 = frame:GetChild("bg2");

	local strTxt = bg2:GetChild("str");
	strTxt:SetTextByKey("value", ClMsg(itemobj.ClassName)); 

	local endTxt2 = bg2:GetChild("endTime2");
	endTxt2:SetTextByKey("value2", endTime); 
	endTxt2:SetTextByKey("value", ClMsg(itemobj.ClassName)..ScpArgMsg("Premium_itemEun")); 
    endTxt2:SetTextByKey("value3", ScpArgMsg("Premium_team")); 
    endTxt2:ShowWindow(1);

	local indunStr = bg2:GetChild("indunStr");
	indunStr:ShowWindow(0);

	local forToken = bg2:GetChild("forToken");
	forToken:ShowWindow(1);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
	GBOX_AUTO_ALIGN(bg2, 10, 3, 10, true, true);
	bg2:Resize(bg2:GetWidth(), 800);
	frame:Resize(frame:GetWidth(), 830);
end