function TOKEN_ON_INIT(addon, frame)

end

function BEFORE_APPLIED_TOKEN_OPEN(invItem)
	local frame = ui.GetFrame("token");
	if 0 == frame:IsVisible() then
		frame:ShowWindow(1)
	end
	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	for i = 0 , 4 do
		local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local str = GetCashTypeStr(ITEM_TOKEN, i)
		local prop = ctrlSet:GetChild("prop");
		prop:SetTextByKey("value", ClMsg(str)); 

		local normal = GetCashValue(0, str) 
		local value = GetCashValue(ITEM_TOKEN, str)
		local txt = "None"
		if str == "marketSellCom" then
			normal = normal + 0.01;
			value = value + 0.01;
			txt = math.floor(normal*100).. "% ->".. math.floor(value*100) .."%";
		elseif str == "marketUpCom" then
			txt = math.floor(normal*100).. "% ->".. math.floor(value*100) .."%";
		elseif str =="abilityMax"then
			txt = normal.. " -> +"..value;
		else
			txt = normal..ClMsg("Piece").." ->"..value .. ClMsg("Piece");
		end

		local value = ctrlSet:GetChild("value");
		value:SetTextByKey("value", txt); 
	end


	GBOX_AUTO_ALIGN(gBox, 0, 10, 0, true, false);
	local itemobj = GetIES(invItem:GetObject());
	local arg1 = itemobj.NumberArg1;
	if itemobj.ClassName == "PremiumToken" then
		arg1 = 2592000
	end
	local endTime = GET_TIME_TXT_D(arg1)
	local endTxt = frame:GetChild("endTime");
	endTxt:SetTextByKey("value", endTime); 

	local endTxt2 = frame:GetChild("endTime2");
	endTxt2:SetTextByKey("value", endTime); 

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