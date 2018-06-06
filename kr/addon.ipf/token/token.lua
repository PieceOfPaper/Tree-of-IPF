function TOKEN_ON_INIT(addon, frame)

end

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

--local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 5,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
--local prop = ctrlSet:GetChild("prop");
--local imag = string.format("{img dealok_image %d %d}", 55, 45) 
--prop:SetTextByKey("value", imag..ClMsg("CantTradeAbility")); 
--local value = ctrlSet:GetChild("value");
--value:ShowWindow(0);

	GBOX_AUTO_ALIGN(gBox, 0, 3, 0, true, false);
	local itemobj = GetIES(invItem:GetObject());
	local arg1 = itemobj.NumberArg1;
	if itemobj.ClassName == "PremiumToken" then
		arg1 = 2592000 --30일
	elseif itemobj.ClassName == "PremiumToken_5d" then
		arg1 = 432000 -- 5일
	elseif itemobj.ClassName == "PremiumToken_1d" then
		arg1 = 604800 -- 7일
	elseif itemobj.ClassName == "PremiumToken_24h" then
		arg1 = 86400 -- 1일
	elseif itemobj.ClassName == "PremiumToken_3d" then
		arg1 = 259200 -- 3일
	elseif itemobj.ClassName == "PremiumToken_12h" then
		arg1 = 43200 -- 12시간
	elseif itemobj.ClassName == "PremiumToken_6h" then
		arg1 = 21600 -- 6시간
	elseif itemobj.ClassName == "PremiumToken_3h" then
		arg1 = 10800 -- 3시간
	end
	local endTime = GET_TIME_TXT(arg1, 1)
	local endTxt = frame:GetChild("endTime");
	endTxt:SetTextByKey("value", endTime); 

	local endTxt2 = frame:GetChild("endTime2");

	endTxt2:SetTextByKey("value2", endTime); 
	endTxt2:SetTextByKey("value", ClMsg(itemobj.ClassName)..ScpArgMsg("Premium_itemEun")); 
    endTxt2:SetTextByKey("value3", ScpArgMsg("Premium_team")); 
    
	local strTxt = frame:GetChild("str");
	strTxt:SetTextByKey("value", ClMsg(itemobj.ClassName)); 

	local strTxt = frame:GetChild("richtext_1");
	strTxt:SetTextByKey("value", ClMsg(itemobj.ClassName)); 

	local forToken = frame:GetChild("forToken");
	forToken:ShowWindow(1);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
	local bg2 = frame:GetChild("bg2");
	bg2:Resize(bg2:GetWidth(), 640);
	frame:Resize(frame:GetWidth(), 700);
end

function BEFORE_APPLIED_BOOST_TOKEN_OPEN(invItem)
	local frame = ui.GetFrame("token");
	if invItem.isLockState then 
		frame:ShowWindow(0)
		return;
	end

	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end

	local token_middle = GET_CHILD(frame, "token_middle", "ui::CPicture");
	token_middle:SetImage("expup_middle");

	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_0",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	local imag = string.format("{img 30percent_image %d %d}", 55, 45) 
	prop:SetTextByKey("value", imag .. ClMsg("token_expup")); 
	local value = ctrlSet:GetChild("value");
	value:SetTextByKey("value", string.format("{img 30percent_image2 %d %d}", 100, 45) ); 

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_1",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	imag = string.format("{img 2multiply_image %d %d}", 55, 45) 
	prop:SetTextByKey("value",imag .. ClMsg("token_staup")); 
	local value = ctrlSet:GetChild("value");
	value:SetTextByKey("value", string.format("{img 2multiply_image2 %d %d}", 100, 45) ); 

	GBOX_AUTO_ALIGN(gBox, 0, 3, 0, true, false);
	local itemobj = GetIES(invItem:GetObject());
	local arg1 = itemobj.NumberArg1 / 1000;
	local endTime = GET_TIME_TXT(arg1, 1)
	local endTxt = frame:GetChild("endTime");
	endTxt:SetTextByKey("value", endTime); 
	local endTxt2 = frame:GetChild("endTime2");
	endTxt2:SetTextByKey("value2", endTime); 
	endTxt2:SetTextByKey("value", ClMsg(itemobj.ClassName)..ScpArgMsg("Premium_itemEun"));
	endTxt2:SetTextByKey("value3", ScpArgMsg("Premium_character")); 

	local strTxt = frame:GetChild("str");
	strTxt:SetTextByKey("value", ClMsg(itemobj.ClassName)); 

	local strTxt = frame:GetChild("richtext_1");
	strTxt:SetTextByKey("value", ClMsg(itemobj.ClassName)); 

	local forToken = frame:GetChild("forToken");
	forToken:ShowWindow(0);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
	
	local bg2 = frame:GetChild("bg2");
	bg2:Resize(bg2:GetWidth(), 500);
	frame:Resize(frame:GetWidth(), 550);
end

function REQ_TOKEN_ITEM(frame, ctrl)
	TOKEN_SELEC_CANCLE(frame);
	
	local itemIES = frame:GetUserValue("itemIES");
	local argList = string.format("%s", frame:GetUserValue("ClassName"));
	local itemName = ClMsg(argList);
	local find = string.find(argList, "PremiumToken");
	if find ~= nil then
		local accountObj = GetMyAccountObj();
		if accountObj.TokenTime ~= "None" then
			ui.MsgBox(ClMsg("IsAppliedToken"));
			return;
		end
	elseif argList == "Premium_boostToken" then
		local etcObj = GetMyEtcObject();
		if tonumber(etcObj.BoostToken) > 0 then
			ui.MsgBox(ScpArgMsg("IsAppliedToken{NAME}","NAME", itemName));
			return;
		end
	end

	pc.ReqExecuteTx_Item("SCR_USE_ITEM_TOKEN", itemIES, argList);
end


function TOKEN_SELEC_CANCLE(frame, ctrl)
	frame:ShowWindow(0);
end