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
		local str, value = GetCashInfo(ITEM_TOKEN, i)
		local prop = ctrlSet:GetChild("prop");

		local normal = GetCashValue(0, str) 
		local txt = "None"
		if str == "marketSellCom" then
			normal = normal + 0.01;
			value = value + 0.01;
			local img = string.format("{img 67percent_image %d %d}",55, 45) 
			prop:SetTextByKey("value", img..ClMsg(str)); 
			txt = string.format("{img 67percent_image2 %d %d}", 100, 45) 
		elseif str =="abilityMax" then
			local img = string.format("{img paid_immed_image %d %d}", 55, 45) 
			prop:SetTextByKey("value", img..ClMsg(str)); 
			txt = string.format("{img 2plus_image2 %d %d}", 100, 45) 
		elseif str == "speedUp"then
			local img = string.format("{img 3plus_image %d %d}", 55, 45) 
			prop:SetTextByKey("value",img.. ClMsg(str)); 
			txt = string.format("{img 3plus_image2 %d %d}", 100, 45) 
		else
			local img = string.format("{img 9plus_image %d %d}", 55, 45) 
			prop:SetTextByKey("value", img..ClMsg(str)); 
			txt = string.format("{img 9plus_image2 %d %d}", 100, 45) 
		end

		local value = ctrlSet:GetChild("value");
		if str =="abilityMax" then
			value:ShowWindow(0);
		else
			value:SetTextByKey("value", txt); 
		end
	end

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 4,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format(TOKEN_GET_IMGNAME1(), 55, 45) 
	prop:SetTextByKey("value", imag.. ScpArgMsg("Token_ExpUp{PER}", "PER", " ")); 
    local value = ctrlSet:GetChild("value");
	imag = string.format(TOKEN_GET_IMGNAME2(), 100, 45) 
    value:SetTextByKey("value", imag);

	local itemobj = GetIES(invItem:GetObject());
	if itemobj.NumberArg2 > 0 then
		local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_TOKEN_TRADECOUNT",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local prop = GET_CHILD(ctrlSet, "prop");
		local value = GET_CHILD(ctrlSet, "value");
		local img = string.format("{img dealok_image %d %d}", 55, 45) 
		prop:SetTextByKey("value", img .. ScpArgMsg("AllowTradeByCount"));

		img = string.format("{img dealok30_image2 %d %d}", 100, 45) 
		value:SetTextByKey("value", img);
	else
		gBox:RemoveChild("CTRLSET_TOKEN_TRADECOUNT");	
	end	

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 6,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img 1plus_image %d %d}", 55, 45) 
    prop:SetTextByKey("value", imag..ClMsg("CanGetMoreBuff")); 
    local value = ctrlSet:GetChild("value");
    value:ShowWindow(0);

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 7,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img paid_pose_image %d %d}", 55, 45) 
    prop:SetTextByKey("value", imag..ClMsg("AllowPremiumPose")); 
    local value = ctrlSet:GetChild("value");
    value:ShowWindow(0);

	ADD_2PLUS_IMAGE(gBox)

	GBOX_AUTO_ALIGN(gBox, 0, 2, 0, true, true);
	
	local arg1 = itemobj.NumberArg1;
	if itemobj.ClassName == "PremiumToken" then
		arg1 = 2592000
	elseif itemobj.ClassName == "PremiumToken_5d" then
		arg1 = 432000
	elseif itemobj.ClassName == "PremiumToken_1d" then
		arg1 = 604800
	elseif itemobj.ClassName == "PremiumToken_24h" then
		arg1 = 86400
	elseif itemobj.ClassName == "PremiumToken_3d" then
		arg1 = 259200
	elseif itemobj.ClassName == "PremiumToken_12h" then
		arg1 = 43200 
	elseif itemobj.ClassName == "PremiumToken_6h" then
		arg1 = 21600 
	elseif itemobj.ClassName == "PremiumToken_3h" then
		arg1 = 10800 
	elseif itemobj.ClassName == "PremiumToken_15d" then
		arg1 = 1296000 
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

function ADD_2PLUS_IMAGE(gBox)
	--do nothing : for override
end

function TOKEN_GET_IMGNAME1()
	return "{img 20percent_image %d %d}"
end

function TOKEN_GET_IMGNAME2()
	return "{img 20percent_image2 %d %d}"
end

function BEFORE_APPLIED_BOOST_TOKEN_OPEN(invItem)
	
	local obj = GetIES(invItem:GetObject());
	
	if obj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ScpArgMsg('LessThanItemLifeTime'));
		return;
	end
	
	
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
	local itemobj = GetIES(invItem:GetObject());
	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_0",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	local imag = string.format("{img 30percent_image %d %d}", 55, 45);
	if itemobj.ClassName == "Premium_boostToken02" or itemobj.ClassName == "Premium_boostToken02_event01" then
	    imag = string.format("{img 120percent_image %d %d}", 55, 45);
	elseif itemobj.ClassName == "Premium_boostToken03" or itemobj.ClassName == "Premium_boostToken03_event01" then
	    imag = string.format("{img 240percent_image %d %d}", 55, 45);
	elseif itemobj.ClassName == "Premium_boostToken04" then
        imag = string.format("{img 50percent_image_1 %d %d}", 55, 45);
    else
        imag = string.format("{img 30percent_image %d %d}", 55, 45);
    end
	prop:SetTextByKey("value", imag .. ClMsg("token_expup")); 
	local value = ctrlSet:GetChild("value");

	if itemobj.ClassName == "Premium_boostToken02" or itemobj.ClassName == "Premium_boostToken02_event01" then
    	value:SetTextByKey("value", string.format("{img 120percent_image2 %d %d}", 100, 45) );
	elseif itemobj.ClassName == "Premium_boostToken03" or itemobj.ClassName == "Premium_boostToken03_event01" then
    	value:SetTextByKey("value", string.format("{img 240percent_image2 %d %d}", 100, 45) );
	elseif itemobj.ClassName == "Premium_boostToken04" then
    	value:SetTextByKey("value", string.format("{img 50percent_image3 %d %d}", 100, 45) );
	else
	value:SetTextByKey("value", string.format("{img 30percent_image2 %d %d}", 100, 45) ); 
    end
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_1",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	if itemobj.ClassName == "Premium_boostToken02" or itemobj.ClassName == "Premium_boostToken02_event01" then
    	imag = string.format("{img 5multiply_image %d %d}", 55, 45);
	elseif itemobj.ClassName == "Premium_boostToken03" or itemobj.ClassName == "Premium_boostToken03_event01" then
    	imag = string.format("{img 9multiply_image %d %d}", 55, 45) 
	else
	imag = string.format("{img 2multiply_image %d %d}", 55, 45) 
    end	
	prop:SetTextByKey("value",imag .. ClMsg("token_staup")); 
	local value = ctrlSet:GetChild("value");
	local itemobj = GetIES(invItem:GetObject());
	if itemobj.ClassName == "Premium_boostToken02" or itemobj.ClassName == "Premium_boostToken02_event01" then
    	value:SetTextByKey("value", string.format("{img 4plus_image2 %d %d}", 100, 45) );
	elseif itemobj.ClassName == "Premium_boostToken03" or itemobj.ClassName == "Premium_boostToken03_event01" then
    	value:SetTextByKey("value", string.format("{img 9multiply_image2 %d %d}", 100, 45) );
	else
	value:SetTextByKey("value", string.format("{img 2plus_image2 %d %d}", 100, 45) ); 
    end

	GBOX_AUTO_ALIGN(gBox, 0, 2, 0, true, false);
	local itemobj = GetIES(invItem:GetObject());
	local arg1 = itemobj.NumberArg1 / 1000;
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
	endTxt2:SetTextByKey("value3", ScpArgMsg("Premium_character")); 
	endTxt2:ShowWindow(1);

	local indunStr = bg2:GetChild("indunStr");
	indunStr:ShowWindow(0);

	local forToken = bg2:GetChild("forToken");
	forToken:ShowWindow(0);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
	
	bg2:Resize(bg2:GetWidth(), 500);
	frame:Resize(frame:GetWidth(), 550);
end

function BEFORE_APPLIED_INDUNRESET_OPEN(invItem)
	local frame = ui.GetFrame("token");
	if invItem.isLockState then 
		frame:ShowWindow(0)
		return;
	end

	local obj = GetIES(invItem:GetObject());
	
	if obj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ScpArgMsg('LessThanItemLifeTime'));
		return;
	end

	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end

	local token_middle = GET_CHILD(frame, "token_middle", "ui::CPicture");
	token_middle:SetImage("indunFreeEnter_middle");

	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_INDUNFREE",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	prop:SetTextByKey("value", ClMsg('IndunRestText'));
	local value = ctrlSet:GetChild("value");
	value:ShowWindow(0);
	

	GBOX_AUTO_ALIGN(gBox, 0, 2, 0, true, false);
	local itemobj = GetIES(invItem:GetObject());
	local endTxt = frame:GetChild("endTime");
	endTxt:ShowWindow(0);

	local strTxt = frame:GetChild("richtext_1");
	strTxt:SetTextByKey("value", ClMsg(itemobj.ClassName)); 

	local bg2 = frame:GetChild("bg2");
	local indunStr = bg2:GetChild("indunStr");
	indunStr:SetTextByKey("value", ClMsg(itemobj.ClassName)..ScpArgMsg("Premium_itemEun")); 
    indunStr:SetTextByKey("value2", ScpArgMsg("Premium_character")); 
    indunStr:ShowWindow(1);

	local endTime2 = bg2:GetChild("endTime2");
	endTime2:ShowWindow(0);
    
	local strTxt = bg2:GetChild("str");
	strTxt:SetTextByKey("value", ClMsg(itemobj.ClassName)); 
    
	local forToken = bg2:GetChild("forToken");
	forToken:ShowWindow(0);

	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
	bg2:Resize(bg2:GetWidth(), 440);
	frame:Resize(frame:GetWidth(), 500);
end

function BEFORE_APPLIED_INDUNFREE_OPEN(invItem)
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
	
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_INDUNFREE",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	prop:SetTextByKey("value", ClMsg('IndunFreeTImeText'));
	local value = ctrlSet:GetChild("value");
	value:ShowWindow(0);
	

	GBOX_AUTO_ALIGN(gBox, 0, 3, 0, true, false);
	local itemobj = GetIES(invItem:GetObject());
	local arg1 = 259200 
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
	bg2:Resize(bg2:GetWidth(), 440);
	frame:Resize(frame:GetWidth(), 500);
end

function REQ_TOKEN_ITEM(parent, ctrl)
	local frame				= parent:GetTopParentFrame();
	TOKEN_SELEC_CANCLE(frame);
	
	local itemIES = frame:GetUserValue("itemIES");
	local argList = string.format("%s", frame:GetUserValue("ClassName"));
	local itemName = ClMsg(argList);
	
	if argList == 'Premium_indunFreeEnter' then
		local etcObj = GetMyEtcObject();
		if etcObj.IndunFreeTime ~= 'None' then
			ui.MsgBox(ScpArgMsg("IsAppliedIndunFreeEnter"));
			return;
		end

		pc.ReqExecuteTx_Item("SCR_USE_ITEM_INDUN_FREE", itemIES, argList);
		return;
	end
	
	if argList == 'Premium_indunReset' or argList == 'Premium_indunReset_14d' or argList == 'Premium_indunReset_14d_test' then

		local etcObj = GetMyEtcObject();
		local countType1 = "InDunCountType_100";
		local countType2 = "InDunCountType_200";
		if etcObj[countType1] == 0 and etcObj[countType2] == 0 then
			ui.MsgBox(ScpArgMsg("IsApplied_indunReset"));
			return;
		end

		pc.ReqExecuteTx_Item("SCR_USE_ITEM_INDUN_RESET", itemIES, argList);
		return;
	end

	local find = string.find(argList, "PremiumToken");
	if find ~= nil then
		if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
			local str = ScpArgMsg("IsAppliedToken");
			local yesScp = string.format("pc.ReqExecuteTx_Item(\"%s\",\"%s\",\"%s\")", "SCR_USE_ITEM_TOKEN", itemIES, argList);
			ui.MsgBox(str, yesScp, "None");
			return;
		end
	elseif argList == "Premium_boostToken" or argList == "Premium_boostToken_14d" or argList == "Premium_boostToken_14d_test" then
		local myHandle = session.GetMyHandle();
		local buff = info.GetBuffByName(myHandle, 'Premium_boostToken');
		if buff ~= nil then
			ui.MsgBox(ScpArgMsg("IsAppliedToken{NAME}","NAME", itemName));
			return;
		end
	elseif argList == "Premium_boostToken02" then
		local myHandle = session.GetMyHandle();
		local buff = info.GetBuffByName(myHandle, 'Premium_boostToken02');
		if buff ~= nil then
			ui.MsgBox(ScpArgMsg("IsAppliedToken{NAME}","NAME", itemName));
			return;
		end
	elseif argList == "Premium_boostToken03" then
		local myHandle = session.GetMyHandle();
		local buff = info.GetBuffByName(myHandle, 'Premium_boostToken03');
		if buff ~= nil then
			ui.MsgBox(ScpArgMsg("IsAppliedToken{NAME}","NAME", itemName));
			return;
		end
	elseif argList == "Premium_boostToken04" then
		local myHandle = session.GetMyHandle();
		local buff = info.GetBuffByName(myHandle, 'Premium_boostToken04');
		if buff ~= nil then
			ui.MsgBox(ScpArgMsg("IsAppliedToken{NAME}","NAME", itemName));
			return;
		end
	end

	pc.ReqExecuteTx_Item("SCR_USE_ITEM_TOKEN", itemIES, argList);
end


function TOKEN_SELEC_CANCLE(parent, ctrl)
	local frame				= parent:GetTopParentFrame();
	frame:ShowWindow(0);
end