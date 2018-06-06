function TOKEN_ON_INIT(addon, frame)

end

function BEFORE_APPLIED_TOKEN_OPEN(invItem)
	local frame = ui.GetFrame("token");
	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end

	local token_middle = frame:GetChild("token_middle");
	token_middle:ShowWindow(1);
	local expup_middle = frame:GetChild("expup_middle");
	expup_middle:ShowWindow(0);

	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	for i = 0 , 3 do
		local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local str = GetCashTypeStr(ITEM_TOKEN, i)
		local prop = ctrlSet:GetChild("prop");

		local normal = GetCashValue(0, str) 
		local value = GetCashValue(ITEM_TOKEN, str)
		local txt = "None"
		if str == "marketSellCom" then
			normal = normal + 0.01;
			value = value + 0.01;
			local img = string.format("{img 67percent_image %d %d}",55, 45) 
			prop:SetTextByKey("value", img..ClMsg(str)); 
			txt = string.format("{img 67percent_image2 %d %d}", 100, 45) 
		elseif str =="abilityMax" then
			local img = string.format("{img 2plus_image %d %d}", 55, 45) 
			prop:SetTextByKey("value", img..ClMsg(str)); 
			txt = string.format("{img 2plus_image2 %d %d}", 100, 45) 
		elseif str == "speedUp"then
			local img = string.format("{img 3plus_image %d %d}", 55, 45) 
			prop:SetTextByKey("value",img.. ClMsg(str)); 
			txt = string.format("{img 3plus_image2 %d %d}", 100, 45) 
		else
			local img = string.format("{img 4plus_image %d %d}", 55, 45) 
			prop:SetTextByKey("value", img..ClMsg(str)); 
			txt = string.format("{img 4plus_image2 %d %d}", 100, 45) 
		end

		local value = ctrlSet:GetChild("value");
		value:SetTextByKey("value", txt); 
	end

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 5,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	local imag = string.format("{img dealok_image %d %d}", 55, 45) 
	prop:SetTextByKey("value", imag..ClMsg("CantTradeAbility")); 
	local value = ctrlSet:GetChild("value");
	value:ShowWindow(0);

	GBOX_AUTO_ALIGN(gBox, 0, 3, 0, true, false);
	local itemobj = GetIES(invItem:GetObject());
	local arg1 = itemobj.NumberArg1;
	if itemobj.ClassName == "PremiumToken" then
		arg1 = 2592000
	end
	local endTime = GET_TIME_TXT(arg1, 1)
	local endTxt = frame:GetChild("endTime");
	endTxt:SetTextByKey("value", endTime); 

	local endTxt2 = frame:GetChild("endTime2");
	endTxt2:SetTextByKey("value", endTime); 

	local strTxt = frame:GetChild("str");
	strTxt:SetTextByKey("value", ClMsg("UseToken")); 

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
end

function BEFORE_APPLIED_BOOST_TOKEN_OPEN(invItem)
	local frame = ui.GetFrame("token");
	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end

	local token_middle = frame:GetChild("token_middle");
	token_middle:ShowWindow(0);
	local expup_middle = frame:GetChild("expup_middle");
	expup_middle:ShowWindow(1);

	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_0",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	prop:SetTextByKey("value", ClMsg("token_expup")); 
	local value = ctrlSet:GetChild("value");
	value:ShowWindow(0);

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_1",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	prop:SetTextByKey("value", ClMsg("toekn_staup")); 
	local value = ctrlSet:GetChild("value");
	value:ShowWindow(0);

	GBOX_AUTO_ALIGN(gBox, 0, 3, 0, true, false);
	local itemobj = GetIES(invItem:GetObject());
	local arg1 = itemobj.NumberArg1 / 1000;
	local endTime = GET_TIME_TXT(arg1, 1)
	local endTxt = frame:GetChild("endTime");
	endTxt:SetTextByKey("value", endTime); 
	local endTxt2 = frame:GetChild("endTime2");
	endTxt2:SetTextByKey("value", endTime); 

	local strTxt = frame:GetChild("str");
	strTxt:SetTextByKey("value", ClMsg("UseBoost")); 


	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
end

function REQ_TOKEN_ITEM(frame, ctrl)
	TOKEN_SELEC_CANCLE(frame);
	
	local itemIES = frame:GetUserValue("itemIES");
	local argList = string.format("%s", frame:GetUserValue("ClassName"));
	pc.ReqExecuteTx_Item("SCR_USE_ITEM_TOKEN", itemIES, argList);
end


function TOKEN_SELEC_CANCLE(frame, ctrl)
	frame:ShowWindow(0);
end