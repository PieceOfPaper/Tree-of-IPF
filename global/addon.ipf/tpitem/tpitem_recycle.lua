
function RECYCLE_SHOW_TO_MEDAL()

	local frame = ui.GetFrame('tpitem')
	local rcycle_basketbuyslotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketbuyslotset");
	local rcycle_basketsellslotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketsellslotset");
	rcycle_basketbuyslotset:ShowWindow(0)
	rcycle_basketsellslotset:ShowWindow(1)

	local rcycle_tomedalBtn = GET_CHILD_RECURSIVELY(frame,"rcycle_tomedalBtn");
	local rcycle_toitemBtn = GET_CHILD_RECURSIVELY(frame,"rcycle_toitemBtn");
	rcycle_tomedalBtn:ShowWindow(1)
	rcycle_toitemBtn:ShowWindow(0)

	local rcycle_mainBuyText = GET_CHILD_RECURSIVELY(frame,"rcycle_mainBuyText");
	local rcycle_mainSellText = GET_CHILD_RECURSIVELY(frame,"rcycle_mainSellText");
	rcycle_mainBuyText:ShowWindow(0)
	rcycle_mainSellText:ShowWindow(1)

	UPDATE_RECYCLE_BASKET_MONEY(frame,"sell")
	RECYCLE_CREATE_SELL_LIST()
end

function RECYCLE_SHOW_TO_ITEM()

	local frame = ui.GetFrame('tpitem')
	local rcycle_basketbuyslotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketbuyslotset");
	local rcycle_basketsellslotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketsellslotset");
	rcycle_basketbuyslotset:ShowWindow(1)
	rcycle_basketsellslotset:ShowWindow(0)

	local rcycle_tomedalBtn = GET_CHILD_RECURSIVELY(frame,"rcycle_tomedalBtn");
	local rcycle_toitemBtn = GET_CHILD_RECURSIVELY(frame,"rcycle_toitemBtn");
	rcycle_tomedalBtn:ShowWindow(0)
	rcycle_toitemBtn:ShowWindow(1)

	local rcycle_mainBuyText = GET_CHILD_RECURSIVELY(frame,"rcycle_mainBuyText");
	local rcycle_mainSellText = GET_CHILD_RECURSIVELY(frame,"rcycle_mainSellText");
	rcycle_mainBuyText:ShowWindow(1)
	rcycle_mainSellText:ShowWindow(0)

	UPDATE_RECYCLE_BASKET_MONEY(frame,"buy")	
	RECYCLE_CREATE_BUY_LIST()
end

function RECYCLE_CREATE_BUY_LIST()

	local frame = ui.GetFrame('tpitem')
	local rcycle_mainSubGbox = GET_CHILD_RECURSIVELY(frame,"rcycle_mainSubGbox");
	DESTROY_CHILD_BYNAME(rcycle_mainSubGbox, "eachitem_");

	local mainSubGbox = GET_CHILD_RECURSIVELY(frame,"rcycle_mainSubGbox");

	local clsList, cnt = GetClassList('recycle_shop');	
	if cnt == 0 or clsList == nil then
		return;
	end

	local x, y;
	local showitemcnt = 1
	for i = 0, cnt - 1 do
		local obj = GetClassByIndexFromList(clsList, i);

		if obj.BuyPrice ~= 0 then

			local itemobj = GetClass("Item", obj.ClassName)

			x = ( (showitemcnt-1) % 3) * ui.GetControlSetAttribute("tpshop_recycle", 'width')
			y = (math.ceil( (showitemcnt / 3) ) - 1) * (ui.GetControlSetAttribute("tpshop_recycle", 'height') * 1)
			local itemcset = mainSubGbox:CreateOrGetControlSet('tpshop_recycle', 'eachitem_'..showitemcnt, x, y);
			RECYCLE_DRAW_ITEM_DETAIL(obj, itemobj, itemcset, "buy");

			showitemcnt = showitemcnt + 1
		end
	end

end


function RECYCLE_CREATE_SELL_LIST()

	local frame = ui.GetFrame('tpitem')
	local rcycle_mainSubGbox = GET_CHILD_RECURSIVELY(frame,"rcycle_mainSubGbox");
	DESTROY_CHILD_BYNAME(rcycle_mainSubGbox, "eachitem_");

	local mainSubGbox = GET_CHILD_RECURSIVELY(frame,"rcycle_mainSubGbox");


	local invItemList = session.GetInvItemList();
	local index = invItemList:Head();
	local itemCount = session.GetInvItemList():Count();
	local x, y;
	local showitemcnt = 1
	for i = 0, itemCount - 1 do
		
		local invItem = invItemList:Element(index);
		local itemobj = GetIES(invItem:GetObject());			
		if invItem ~= nil then
			local obj = GetClass("recycle_shop", itemobj.ClassName)
			if obj ~= nil then
				if obj.SellPrice ~= 0 then
				
					x = ( (showitemcnt-1) % 3) * ui.GetControlSetAttribute("tpshop_recycle", 'width')
					y = (math.ceil( (showitemcnt / 3) ) - 1) * (ui.GetControlSetAttribute("tpshop_recycle", 'height') * 1)
					local itemcset = mainSubGbox:CreateOrGetControlSet('tpshop_recycle', 'eachitem_'..invItem:GetIESID(), x, y);
					RECYCLE_DRAW_ITEM_DETAIL(obj, itemobj, itemcset, "sell", invItem:GetIESID());

					showitemcnt = showitemcnt + 1

				end

			end
		end

		index = invItemList:Next(index);
	end
end


function RECYCLE_DRAW_ITEM_DETAIL(obj, itemobj, itemcset, type, itemguid)

	local title = GET_CHILD_RECURSIVELY(itemcset,"title");
	local subtitle = GET_CHILD_RECURSIVELY(itemcset,"subtitle");
	local nxp = GET_CHILD_RECURSIVELY(itemcset,"nxp")
	local slot = GET_CHILD_RECURSIVELY(itemcset, "icon");
	local pre_Line = GET_CHILD_RECURSIVELY(itemcset,"noneBtnPreSlot_1");
	local pre_Box = GET_CHILD_RECURSIVELY(itemcset,"noneBtnPreSlot_2");
	local pre_Text = GET_CHILD_RECURSIVELY(itemcset,"noneBtnPreSlot_3");
	local staticBuyMedalbox = GET_CHILD_RECURSIVELY(itemcset,"staticBuyMedalbox"); 
	local staticSellMedalbox = GET_CHILD_RECURSIVELY(itemcset,"staticSellMedalbox");
	local remaincnt = GET_CHILD_RECURSIVELY(itemcset,"remaincnt");
	

	local itemName = itemobj.Name;
	local itemclsID = itemobj.ClassID;
	local tpitem_clsName = obj.ClassName;
	local tpitem_clsID = obj.ClassID;

	local price;
	if type == "sell" then
		price = obj.SellPrice
		staticBuyMedalbox:ShowWindow(0)
		staticSellMedalbox:ShowWindow(1)
		remaincnt:ShowWindow(0)
		if itemobj.MaxStack > 1 then
			TPSHOP_ITEM_RECYCLE_SELL_UPDATE_REMAINCNT(itemguid)
			remaincnt:ShowWindow(1)
		end
	else
		price = obj.BuyPrice
		staticBuyMedalbox:ShowWindow(1)
		staticSellMedalbox:ShowWindow(0)
		remaincnt:ShowWindow(0)
	end

	title:SetText(itemName);
	pre_Line:SetVisible(0);
	pre_Box:SetVisible(0);
	pre_Text:SetVisible(0);
				
	--itemcset:SetUserValue("RCITEM_CLSID", tpitem_clsID); -- ?�거 ?�요??지  ?�인??�?
	nxp:SetText("{@st43}{s18}"..price.."{/}");
			
	subtitle:SetVisible(0);	

	SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(itemobj));
			
	local icon = slot:GetIcon();
	icon:SetTooltipType('wholeitem');
	icon:SetTooltipArg('', itemclsID, 0);

	local desc = GET_CHILD_RECURSIVELY(itemcset,"desc")
	local tradeable = GET_CHILD_RECURSIVELY(itemcset,"tradeable")

	if type == "buy" then
		local lv = GETMYPCLEVEL();
		local job = GETMYPCJOB();
		local gender = GETMYPCGENDER();
		local prop = geItemTable.GetProp(itemclsID);
		local result = prop:CheckEquip(lv, job, gender);

		
		if result == "OK" then
			desc:SetText(GET_USEJOB_TOOLTIP(itemobj))
		else
			desc:SetText("{#990000}"..GET_USEJOB_TOOLTIP(itemobj).."{/}")
		end

		
		local itemProp = geItemTable.GetPropByName(itemobj.ClassName);
		if itemProp:IsExchangeable() == true then
			tradeable:ShowWindow(0)
		else
			tradeable:ShowWindow(1)
		end
	else
		desc:ShowWindow(0)
		tradeable:ShowWindow(0)
	end
			
	local buyBtn = GET_CHILD_RECURSIVELY(itemcset, "buyBtn");
	local sellBtn = GET_CHILD_RECURSIVELY(itemcset, "sellBtn");
	
	local sucValue = string.format("");	
	local isBuyPossible = 1;

	local previewbtn = GET_CHILD_RECURSIVELY(itemcset, "previewBtn");

	if type == "buy" then
		buyBtn:SetEventScriptArgNumber(ui.LBUTTONUP, tpitem_clsID);
		buyBtn:SetEventScriptArgString(ui.LBUTTONUP, tpitem_clsName);
		buyBtn:ShowWindow(1)
		sellBtn:ShowWindow(0)
		local clstype = TryGetProp(itemobj, "ClassType");	
		if clstype == "Hat" then
			previewbtn:SetEventScriptArgNumber(ui.LBUTTONUP, tpitem_clsID);		
			previewbtn:SetEventScriptArgString(ui.LBUTTONUP, tpitem_clsName);
			previewbtn:ShowWindow(1);
		else
			previewbtn:ShowWindow(0);
		end
	else
		buyBtn:ShowWindow(0)
		sellBtn:ShowWindow(1)
		sellBtn:SetEventScriptArgString(ui.LBUTTONUP, itemguid);
		previewbtn:ShowWindow(0);
	end

	buyBtn:SetSkinName("test_red_button");	
	buyBtn:EnableHitTest(1);

end


function TPSHOP_ITEM_RECYCLE_SELL_UPDATE_REMAINCNT(itemguid)

	local frame = ui.GetFrame("tpitem")
	local slotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketsellslotset")
	local slotCount = slotset:GetSlotCount();
	local invItem = session.GetInvItemByGuid(itemguid);
	if invItem == nil then
		return
	end
	local itemobj = GetClassByType("Item",invItem.type)

	local retcount = nil

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);
		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local alreadyguid = slot:GetUserValue("SELLITEMGUID");

			if itemobj.MaxStack > 1 then
				if alreadyguid == itemguid then
					local nowcnt = tonumber(slot:GetUserValue("COUNT"))
					
					retcount =  invItem.count - nowcnt;
				end

			end

			
		end
	end

	if retcount == nil then
		retcount = invItem.count
	end

	local itemcset = GET_CHILD_RECURSIVELY(frame,"eachitem_"..itemguid)
	itemcset:SetTextByKey("cnt",tostring(retcount))
end

function TPSHOP_ITEM_TO_RECYCLE_SELL_BASKET_PREPROCESSOR(parent, control, itemguid)
	
	local invItem = session.GetInvItemByGuid(itemguid);
	
	if invItem == nil then
		return;
	end

	local itemobj = GetClassByType("Item", invItem.type)
	
	if itemobj == nil then
		return;
	end

	local obj = GetClass("recycle_shop", itemobj.ClassName)
	if obj == nil then
		return;
	end

	local addcnt = 1
	if 1 == keyboard.IsPressed(KEY_SHIFT) then
		addcnt = 10
	end
	TPSHOP_ITEM_TO_RECYCLE_SELL_BASKET(itemguid, addcnt)
	

end

function TPSHOP_ITEM_TO_RECYCLE_SELL_BASKET(itemguid, addcnt)

	local invItem = session.GetInvItemByGuid(itemguid);

	if invItem == nil then
		return;
	end

	local itemobj = GetClassByType("Item", invItem.type)

	if itemobj == nil then
		return;
	end

	
	local obj = GetClass("recycle_shop", itemobj.ClassName)
	if obj == nil then
		return;
	end

	
	local frame = ui.GetFrame("tpitem")
	local slotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketsellslotset")
	local slotCount = slotset:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local alreadyguid = slot:GetUserValue("SELLITEMGUID");

			if itemobj.MaxStack > 1 then
				if alreadyguid == itemguid then
					local nowcnt = tonumber(slot:GetUserValue("COUNT"))
					
					local invItem = session.GetInvItemByGuid(alreadyguid);
					if invItem == nil then
						return;
					end

					local remaincnt = invItem.count - nowcnt

					if remaincnt <= 0 then
						ui.MsgBox(ScpArgMsg("CanNotSellDuplicateItem"))
						return;
					end

					if addcnt > remaincnt then
						 addcnt = remaincnt;
					end

					nowcnt = nowcnt + addcnt

					slot:SetUserValue("COUNT",tostring(nowcnt));
					slot:SetText("{s20}{b}{ol}"..tostring(nowcnt), 'count', 'right', 'bottom', -2, 1);

					TPSHOP_ITEM_RECYCLE_SELL_UPDATE_REMAINCNT(itemguid)
					UPDATE_RECYCLE_BASKET_MONEY(frame,"sell")	
					return;
				end
			else
			if alreadyguid == itemguid then
				ui.MsgBox(ScpArgMsg("CanNotSellDuplicateItem"))
				return;
			end
		end

			
		end
	end


	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon == nil then

			local slot  = slotset:GetSlotByIndex(i);

			slot:SetEventScript(ui.RBUTTONDOWN, 'TPSHOP_RECYCLE_BASKETSLOT_SELL_REMOVE');
			slot:SetUserValue("CLASSNAME", item.ClassName);
			slot:SetUserValue("TPITEMNAME", obj.ClassName);
			slot:SetUserValue("SELLITEMGUID", itemguid);
			slot:SetUserValue("COUNT", tostring(addcnt));

			SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(itemobj));
			local icon = slot:GetIcon();
			icon:SetTooltipType('wholeitem');
			icon:SetTooltipArg('', itemobj.ClassID, 0);

			break;

		end
	end
	TPSHOP_ITEM_RECYCLE_SELL_UPDATE_REMAINCNT(itemguid)
	UPDATE_RECYCLE_BASKET_MONEY(frame,"sell")	
	
end

function TPSHOP_ITEM_TO_RECYCLE_BUY_BASKET_PREPROCESSOR(parent, control, tpitemname, tpitem_clsID)

	local obj = GetClassByType("recycle_shop", tpitem_clsID)
	if obj == nil then
		return;
	end
	
	local itemobj = GetClass("Item", obj.ClassName)
	if itemobj == nil then
		return;
	end

	local classid = itemobj.ClassID;
	local item = GetClassByType("Item", classid)

	if item == nil then
		return;
	end

	local allowDup = TryGetProp(item,'AllowDuplicate')
	
	local isHave = false;
				
	if allowDup == "NO" then
		if session.GetInvItemByType(classid) ~= nil then
			isHave = true;
		end
		if session.GetEquipItemByType(classid) ~= nil then
			isHave = true;
		end
		if session.GetWarehouseItemByType(classid) ~= nil then
			isHave = true;
		end
	end
	
	if isHave == true then
		ui.MsgBox(ClMsg("AlearyHaveItemReallyBuy?"), string.format("TPSHOP_ITEM_TO_RECYCLE_BASKET('%s', %d)", tpitemname, classid), "None");
	else
		TPSHOP_ITEM_TO_RECYCLE_BUY_BASKET(tpitemname, classid)
	end
end

function TPSHOP_ITEM_TO_RECYCLE_BUY_BASKET(tpitemname, classid)	

	local item = GetClassByType("Item", classid)

	if item == nil then
		return;
	end

	local tpitem = GetClass("recycle_shop", item.ClassName)
	if tpitem == nil then
		ui.MsgBox(ScpArgMsg("DataError"))
		return
	end
	
	if IS_EQUIP(item) == true then
		local lv = GETMYPCLEVEL();
		local job = GETMYPCJOB();
		local gender = GETMYPCGENDER();
		local prop = geItemTable.GetProp(classid);
		local result = prop:CheckEquip(lv, job, gender);

		if result ~= "OK" then
			ui.MsgBox(ScpArgMsg("CanNotEquip"))
			return;
		end	
		local pc = GetMyPCObject();
		if pc == nil then
			return;
		end
		
		local useGender = TryGetProp(item,'UseGender')

		if useGender =="Male" and pc.Gender ~= 1 then
			ui.MsgBox(ScpArgMsg("CanNotEquip"))
			return;
		end

		if useGender =="Female" and pc.Gender ~= 2 then
			ui.MsgBox(ScpArgMsg("CanNotEquip"))
			return;
		end
	end

	local frame = ui.GetFrame("tpitem")
	local slotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketbuyslotset")
	local slotCount = slotset:GetSlotCount();

	local nodupliItems = {}
	nodupliItems[tpitemname] = true;

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local classname = slot:GetUserValue("TPITEMNAME");
			local alreadyItem = GetClass("recycle_shop",classname)

			if alreadyItem ~= nil then

				local item = GetClass("Item", alreadyItem.ClassName)
				local allowDup = TryGetProp(item,'AllowDuplicate')

				if allowDup == "NO" then
		
					if nodupliItems[classname] == nil then
						nodupliItems[classname] = true
					else
						ui.MsgBox(ScpArgMsg("CanNotBuyDuplicateItem"))
						return;
					end
				end
			
			end

		end
	end


	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon == nil then

			local slot  = slotset:GetSlotByIndex(i);

			slot:SetEventScript(ui.RBUTTONDOWN, 'TPSHOP_RECYCLE_BASKETSLOT_BUY_REMOVE');
			slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, classid);
			slot:SetUserValue("CLASSNAME", item.ClassName);
			slot:SetUserValue("TPITEMNAME", tpitemname);

			SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(item));
			local icon = slot:GetIcon();
			icon:SetTooltipType('wholeitem');
			icon:SetTooltipArg('', item.ClassID, 0);

			break;

		end
	end

	UPDATE_RECYCLE_BASKET_MONEY(frame,"buy")	
	
end

function TPSHOP_RECYCLE_BASKETSLOT_BUY_REMOVE(parent, control, strarg, classid)	

	control:ClearText();
	control:ClearIcon();

	control:SetUserValue("CLASSNAME", "None");
	control:SetUserValue("TPITEMNAME", "None");

	UPDATE_RECYCLE_BASKET_MONEY(parent:GetTopParentFrame(),"buy")

end

function TPSHOP_RECYCLE_BASKETSLOT_SELL_REMOVE(parent, control, strarg, classid)	

	control:ClearText();
	control:ClearIcon();

	local itemguid = control:GetUserValue("SELLITEMGUID")
	TPSHOP_ITEM_RECYCLE_SELL_UPDATE_REMAINCNT(itemguid)
	control:SetUserValue("SELLITEMGUID", "None");

	UPDATE_RECYCLE_BASKET_MONEY(parent:GetTopParentFrame(),"sell")

end

function UPDATE_RECYCLE_BASKET_MONEY(frame, type) -- buy? sell?

	local slotset = nil
	if type == "buy" then
		slotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketbuyslotset")
	else
		slotset = GET_CHILD_RECURSIVELY(frame,"rcycle_basketsellslotset")
	end
	
	
	local slotCount = slotset:GetSlotCount();

	local allprice = 0

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local classname = slot:GetUserValue("TPITEMNAME");
			local alreadyItem = GetClass("recycle_shop",classname)

			if alreadyItem ~= nil then

				if type == "buy" then
					allprice = allprice + alreadyItem.BuyPrice
				else
					local cnt = slot:GetUserValue("COUNT");
					allprice = allprice + (alreadyItem.SellPrice * cnt)
				end
				
			
			end

		end
	end

	local basketTP = GET_CHILD_RECURSIVELY(frame,"rcycle_basketTP")
	if allprice == 0 then
		basketTP:SetText("0")
	elseif type == "sell" then
		basketTP:SetText("+"..tostring(allprice))
	else
		basketTP:SetText("-"..tostring(allprice))
	end

	local accountObj = GetMyAccountObj();

	local havemedalcnt = 0
	local medal = session.GetInvItemByName("Recycle_Shop_Medal");
	if medal ~= nil then
		havemedalcnt = medal.count
	end

	local haveTP = GET_CHILD_RECURSIVELY(frame,"rcycle_haveTP")
	haveTP:SetText(tostring(havemedalcnt))

	local remainTP = GET_CHILD_RECURSIVELY(frame,"rcycle_remainTP")
	if type == "sell" and allprice > 0 then
		remainTP:SetText(tostring(havemedalcnt + allprice))
	else
		remainTP:SetText(tostring(havemedalcnt - allprice))
	end

	frame:Invalidate();

end


function TPSHOP_ITEM_RECYCLE_PREVIEW_PREPROCESSOR(parent, control, tpitemname, tpitem_clsID)
	
	local frame = ui.GetFrame("tpitem");
	local slotset = nil;
	
	local obj = GetClassByType("recycle_shop", tpitem_clsID)
	if obj == nil then
		return;
	end
	
	local itemobj = GetClass("Item", obj.ClassName)
	if itemobj == nil then
		return;
	end
	
	-- 무조�??�어 ?�세?�고 가??
	TPSHOP_PREVIEWSLOT_EQUIP(frame, GET_CHILD_RECURSIVELY(frame,"previewslotset1"), 0, tpitemname, itemobj);
end

function TPSHOP_RECYCLE_ITEM_BASKET_BUY(parent, control)

	local ret = RECYCLESHOP_POPUPMSG_MAKE_ITEMLIST("buy")
	if ret == true then
		ui.OpenFrame("recycleshop_popupmsg")
	end
end

function TPSHOP_RECYCLE_ITEM_BASKET_BUY_CANCEL()

	ui.CloseFrame("recycleshop_popupmsg")
	local frame = ui.GetFrame("tpitem");
	local btn = GET_CHILD_RECURSIVELY(frame,"rcycle_toitemBtn");
end

function TPSHOP_RECYCLE_ITEM_BASKET_SELL(parent, control)

	local ret = RECYCLESHOP_POPUPMSG_MAKE_ITEMLIST("sell")
	if ret == true then
		ui.OpenFrame("recycleshop_popupmsg")
	end
end

function TPSHOP_RECYCLE_ITEM_BASKET_SELL_CANCEL()
	
	ui.CloseFrame("recycleshop_popupmsg")
	local frame = ui.GetFrame("tpitem");
	local btn = GET_CHILD_RECURSIVELY(frame,"rcycle_tomedalBtn");	
end

function EXEC_BUY_RECYCLE_ITEM()

	local slotsetname = nil
	local itemListStr = ""
	
	slotsetname = "rcycle_basketbuyslotset"

	local frame = ui.GetFrame("tpitem")
	local btn = GET_CHILD_RECURSIVELY(frame,"rcycle_toitemBtn");
	local slotset = GET_CHILD_RECURSIVELY(frame,slotsetname)
	if slotset == nil then

		return;
	end
	local slotCount = slotset:GetSlotCount();

	local allprice = 0

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local tpitemname = slot:GetUserValue("TPITEMNAME");
			local tpitem = GetClass("recycle_shop",tpitemname)

			if tpitem ~= nil then
							
				allprice = allprice + tpitem.BuyPrice

				if itemListStr == "" then
					itemListStr = tostring(tpitem.ClassID)
				else
					itemListStr = itemListStr .." " .. tostring(tpitem.ClassID)
				end
				
			else
				
				return
			end

		end
	end

	if allprice == 0 then
		
		return
	end

	local medal = session.GetInvItemByName("Recycle_Shop_Medal");
	if medal == nil then
		ui.MsgBox(ScpArgMsg("MoreNeedRecycleMedal"))
		return
	end

	if medal.count < allprice then 
		ui.MsgBox(ScpArgMsg("MoreNeedRecycleMedal"))
		return;
	end

	pc.ReqExecuteTx_NumArgs("SCR_TX_RECYCLE_BUY", itemListStr);	
	
	local frame = ui.GetFrame("tpitem");
	frame:ShowWindow(0);
	TPITEM_CLOSE(frame);
end

function EXEC_SELL_RECYCLE_ITEM()

	session.ResetItemList();
	
	local slotsetname = nil
	local itemListStr = ""
	
	slotsetname = "rcycle_basketsellslotset"

	local frame = ui.GetFrame("tpitem")
	local btn = GET_CHILD_RECURSIVELY(frame,"rcycle_tomedalBtn");
	local slotset = GET_CHILD_RECURSIVELY(frame,slotsetname)
	if slotset == nil then
		return;
	end
	local slotCount = slotset:GetSlotCount();

	local allprice = 0

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local tpitemname = slot:GetUserValue("TPITEMNAME");
			local itemguid = slot:GetUserValue("SELLITEMGUID");
			local cnt = tonumber(slot:GetUserValue("COUNT"));
			local tpitem = GetClass("recycle_shop",tpitemname)

			if tpitem ~= nil then
							
				allprice = allprice + (tpitem.SellPrice * cnt)

				session.AddItemID(itemguid, cnt);
				
			else
				return
			end

		end
	end

	if allprice == 0 then
		return
	end

	local resultlist = session.GetItemIDList();
	item.DialogTransaction("RECYCLE_SHOP_SELL", resultlist);
	
	local frame = ui.GetFrame("tpitem");
	frame:ShowWindow(0);
	TPITEM_CLOSE(frame);
end
