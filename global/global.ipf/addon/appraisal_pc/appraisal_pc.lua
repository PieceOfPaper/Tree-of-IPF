function APPRAISAL_PC_UPDATE_HISTORY(frame)
	local groupName = frame:GetUserValue("GroupName");	
	local cnt = session.autoSeller.GetHistoryCount(groupName);
	local gboxctrl = frame:GetChild("historyBox");
	local historyStrBox = gboxctrl:GetChild("historyStrBox");
	historyStrBox:RemoveAllChild();

	for i = cnt -1 , 0, -1 do
		local info = session.autoSeller.GetHistoryByIndex(groupName, i);
		local ctrlSet = historyStrBox:CreateControlSet("squire_rpair_history", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);

		local sList = StringSplit(info:GetHistoryStr(), "#");
		local userName = sList[1];
		local property = ctrlSet:GetChild("UserName");
		property:SetTextByKey("value", userName .. ClMsg("AppraisedItemFor"));
		
		local itemStr = "";
		local priceStr = "";

		for i = 2, #sList do
			if i % 2 == 0 then
				local itemCls = GetClassByType("Item", sList[i]);
				if nil ~= itemCls then
					itemStr = itemStr.. itemCls.Name.."{nl}" ;
				end
			else
				priceStr = priceStr .. ClMsg("AppraisalCost") .. "" .. sList[i].."{nl}";
			end

		end

		local itemname = ctrlSet:GetChild("itemName");
		itemname:SetTextByKey("value", itemStr);
		local price = ctrlSet:GetChild("Price");
		price:SetTextByKey("value", priceStr);
		ctrlSet:Resize(historyStrBox:GetWidth() - 40, price:GetY() + price:GetHeight()); -- 40: SCROLL_WIDTH
		ctrlSet:Invalidate();
	end

	GBOX_AUTO_ALIGN(historyStrBox, 20, 3, 10, true, false);
end