function BEFORE_GLOBAL_PRE_ITEM_OPEN(invItem)
	local frame = ui.GetFrame("globalitem");
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

	local middle = GET_CHILD(frame, "middle", "ui::CPicture");
	middle:SetImage("pizza_middle");

	local gBox = frame:GetChild("gBox");
	gBox:RemoveAllChild();
	
	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 1,  ui.CENTER_HORZ, ui.TOP, 10, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	local img;
	if GetServerNation() == 'KOR' then
		img = string.format("{img icon_pizza %d %d}", 45, 45);
	else 
		img = string.format("   {img icon_pizza %d %d}", 45, 45);
	end
	prop:SetTextByKey("value", img); 
	local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
	value:ShowWindow(0);
	
	local bg = frame:GetChild("bg");
	local propTxt1 = frame:GetChild("propTxt1");
	propTxt1:SetTextByKey("value", ClMsg('STM_SAVIOR_BUFF_PROP')); 

	local ctrlSet = gBox:CreateControlSet("tokenDetail", "CTRLSET_" .. 2,  ui.CENTER_HORZ, ui.TOP, 10, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
	local img;
	if GetServerNation() == 'KOR' then
		img = string.format("{img icon_delivery_man %d %d}", 45, 45);
	else 
		img = string.format("   {img icon_delivery_man %d %d}", 45, 45);
	end
	prop:SetTextByKey("value", img); 
	local value = GET_CHILD_RECURSIVELY(ctrlSet, "value");
	value:ShowWindow(0);
	
	local propTxt2 = frame:GetChild("propTxt2");
	propTxt2:SetTextByKey("value", ClMsg('STM_SAVIOR_BUFF_PROP2')); 
	
	GBOX_AUTO_ALIGN(gBox, 0, 2, 0, true, false);
	
	local itemobj = GetIES(invItem:GetObject());
	local strTxt = frame:GetChild("richtext_1");
	strTxt:SetTextByKey("value", GetClassString('Item', itemobj.ClassName, 'Name')); 

	local indunStr = bg:GetChild("indunStr");
	indunStr:SetTextByKey("value", GetClassString('Item', itemobj.ClassName, 'Name')..ScpArgMsg("Premium_itemEun")); 
    indunStr:SetTextByKey("value2", ScpArgMsg("Premium_character")); 
    indunStr:ShowWindow(1);

	local strTxt = bg:GetChild("str");
	strTxt:SetTextByKey("value", GetClassString('Item', itemobj.ClassName, 'Name')); 
	
	local tips = bg:GetChild("tips");
	tips:ShowWindow(1);
		
	frame:SetUserValue("itemIES", invItem:GetIESID());
	frame:SetUserValue("ClassName", itemobj.ClassName);
	bg:Resize(bg:GetWidth(), 500);
	frame:Resize(frame:GetWidth(), 600);
	
end
function REQ_GLOBAL_ITEM(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	TOKEN_SELEC_CANCLE(frame);
	local PcObj = GetMyPCObject()
	local itemIES = frame:GetUserValue("itemIES");
	local argList = string.format("%s", frame:GetUserValue("ClassName"));
	local itemName = ClMsg(argList);
	local str = ScpArgMsg("IsApplied_STM_SAVIOR_BUFF");
	if IsBuffApplied(PcObj, 'STM_PREMIUM_PIZZA_BUFF') == 'YES' then
	local yesScp = string.format("pc.ReqExecuteTx_Item(\"%s\",\"%s\",\"%s\")", "SCR_USE_STM_ITEM", itemIES, argList);
		ui.MsgBox(str, yesScp, "None");
		return;
	end
	pc.ReqExecuteTx_Item("SCR_USE_STM_ITEM", itemIES, argList);
end
