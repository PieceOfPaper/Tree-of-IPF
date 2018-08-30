
function OBLATION_ON_INIT(addon, frame)
	addon:RegisterMsg("OBLATION_ITEM_LIST", "ON_OBLATION_ITEM_LIST");
end

function OBLATION_INIT(frame, skillName, skillLevel)
	frame:SetUserValue("SKILL_NAME", skillName);
	frame:SetUserValue("SKILL_LEVEL", skillLevel);
	OBLATION_TAB_CHANGE(frame);
	UPDATE_OBLATION_OPEN_STATE(frame);
	UPDATE_OBLATION_ITEM_LIST(frame);
	

end

function OBLATION_OPEN(frame)
	packet.RequestItemList(IT_OBLATION);
end

function OBLATION_TAB_CHANGE(parent)

	local frame = parent:GetTopParentFrame();
	local tabCtrl = GET_CHILD(frame, "itembox");
	local tabName = tabCtrl:GetSelectItemName();
	local gbox = frame:GetChild("gbox");
	local gbox_view = gbox:GetChild("gbox_view");
	local gbox_open = gbox:GetChild("gbox_open");
	if tabName == "tab_normal" then
		gbox_open:ShowWindow(1);
		gbox_view:ShowWindow(0);
	elseif tabName == "tab_view" then
		gbox_open:ShowWindow(0);
		gbox_view:ShowWindow(1);
	end
	
end

function OBLATION_EXEC(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local skillName = frame:GetUserValue("SKILL_NAME");
	local skillType = GetClass("Skill", skillName).ClassID;

	if GetMyPCObject() ~= nil then
        local pc = GetMyPCObject();
        local curMap = GetZoneName(pc)
        local mapCls = GetClass("Map", curMap)
        if mapCls.MapType == "City" then
            ui.SysMsg(ClMsg("YouCantUseOblationInCity"));
            return;
        end
        
    end
	
	local groupName = "Oblation";
	if session.autoSeller.GetMyAutoSellerShopState(AUTO_SELL_OBLATION) == true then
		session.autoSeller.Close(groupName);
	else
		local tabCtrl = GET_CHILD(frame, "itembox");
		local tabName = tabCtrl:GetSelectItemName();
		if tabName == "tab_normal" then
			local gbox = frame:GetChild("gbox");
			local gbox_open = gbox:GetChild("gbox_open");
			local inputname = gbox_open:GetChild("inputname");
			if "" == inputname:GetText() then
			    ui.SysMsg(ClMsg("OblationNameIsNone"));
				return;
			end

			session.autoSeller.ClearGroup(groupName);
			local info = session.autoSeller.CreateToGroup(groupName);
			info.classID = skillType;
			info.price = 1;

			session.autoSeller.RequestRegister(groupName, groupName, inputname:GetText(), skillName);
		else
			frame:ShowWindow(0);
		end
	end

end

function OPEN_OBLATION_UI(groupName, sellType, handle, totalItemCount)
	local myHandle = session.GetMyHandle();
	if handle == myHandle then
		local frame = ui.GetFrame("oblation");		
		local skillName = frame:GetUserValue("SKILL_NAME");
		if "None" == skillName then
			local skill = session.GetSkillByName("Pardoner_Oblation");
			if skill == nil then
				return;
			end	
			local obj = GetIES(skill:GetObject());
			OBLATION_INIT(frame, obj.ClassName, obj.Level);
		end
		UPDATE_OBLATION_INV_COUNT(frame);
		frame:ShowWindow(1);
	else
		local frame = ui.GetFrame("oblation_sell");
		OBLATION_SELL_INIT(frame, totalItemCount, handle);
		frame:ShowWindow(1);
	end

end

function AUTOSELL_OPEN_Oblation(isOpen)

	local frame = ui.GetFrame("oblation");
	UPDATE_OBLATION_OPEN_STATE(frame);

end

function UPDATE_OBLATION_OPEN_STATE(frame)

	local gbox = frame:GetChild("gbox");
	local reg = gbox:GetChild("regbtn");
	
	if session.autoSeller.GetMyAutoSellerShopState(AUTO_SELL_OBLATION) == true then
		reg:SetTextByKey("value", ClMsg("Close"));
	else
		reg:SetTextByKey("value", ClMsg("Confirm"));
	end

end

function UPDATE_OBLATION_ITEM_LIST(frame)
	local gbox = frame:GetChild("gbox");
	local gbox_view = gbox:GetChild("gbox_view");
	local gbox_slot = gbox_view:GetChild("gbox_slot");
	local slotset = GET_CHILD(gbox_slot, "slotset");
	UPDATE_ETC_ITEM_SLOTSET(slotset, IT_OBLATION, "oblation");
	UPDATE_OBLATION_INV_COUNT(frame);
end

function UPDATE_OBLATION_INV_COUNT(frame)

	local sklLevel = frame:GetUserIValue("SKILL_LEVEL");
	local ctrlset_box_count = frame:GetChild("ctrlset_box_count");
	local count = GET_CHILD(ctrlset_box_count, "count");
	local curCount = 0;
	local maxCount = GET_OBLATION_MAX_COUNT(sklLevel);
	count:SetTextByKey("maxcount", maxCount);
	
	local itemList = session.GetEtcItemList(IT_OBLATION);
	if itemList ~= nil then
		local givenPrice = 0;
		local expectedSilver = 0;
		local index = itemList:Head();
		while index ~= itemList:InvalidIndex() do
			local invItem = itemList:Element(index);
			
			curCount = curCount + 1
			local itemProp = geItemTable.GetProp(invItem.type);
			local sellPrice = geItemTable.GetSellPrice(itemProp);
			local givenSilver = math.floor(sellPrice * GET_OBLATION_PRICE_PERCENT());
			local getSilver = sellPrice - givenSilver;
			givenPrice = givenPrice + givenSilver * invItem.count;
			expectedSilver = expectedSilver + getSilver * invItem.count;

			index = itemList:Next(index);
		end

		local gbox = frame:GetChild("gbox");
		local consumesilver = gbox:GetChild("consumesilver");
		local expectsilver= gbox:GetChild("expectsilver");
		local mysilver = gbox:GetChild("mysilver");
		consumesilver:SetTextByKey("value", givenPrice);
		expectsilver:SetTextByKey("value", expectedSilver);
		mysilver:SetTextByKey("value", GET_COMMAED_STRING(GET_TOTAL_MONEY_STR()));
	end 

	count:SetTextByKey("curcount", curCount);
end

function ON_OBLATION_ITEM_LIST(frame)
	UPDATE_OBLATION_ITEM_LIST(frame);
end

function OBLATION_SELLTOSHOP_ALL(parent, ctrl)

	local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);
	if mapCls.MapType ~= "City" then
		ui.SysMsg(ClMsg("YouCanSellOblationItemOnlyInCity"));
		return;
	end

	session.autoSeller.SellMyShopItem(AUTO_SELL_OBLATION, nil);
	
end



