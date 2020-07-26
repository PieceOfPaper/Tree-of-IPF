function HOUSING_SHOP_PAYMENT_ON_INIT(addon, frame)
	--addon:RegisterMsg('PERSONAL_HOUSING_SHOP', 'ON_PERSONAL_HOUSING_SHOP');
end

function OPEN_HOUSING_SHOP_PAYMENT(frame)
	local gbox_coupon = GET_CHILD_RECURSIVELY(frame, "gbox_coupon");
	gbox_coupon:RemoveAllChild();
	
	local txt_coupon_none = GET_CHILD_RECURSIVELY(frame, "txt_coupon_none");

	-- 종류가 늘어나면 그만큼 gbox_coupon 크기랑, 판매 정보 위치 조절 필요함
	local isHasCoupon = false;
	local couponList = HOUSING_SHOP_PAYMENT_COUPON_LIST();
	for i = 1, #couponList do
		local isHas = HOUSING_SHOP_PAYMENT_ADD_COUPON(frame, gbox_coupon, couponList[i]);
		if isHas == true then
			isHasCoupon = isHas;
		end
	end

	GBOX_AUTO_ALIGN(gbox_coupon, 0, 5, 0, true, false);

	if isHasCoupon == true then
		txt_coupon_none:ShowWindow(0);
	else
		txt_coupon_none:ShowWindow(1);
	end
	
	local txt_sellPrice = GET_CHILD_RECURSIVELY(frame, "txt_sellPrice");
	txt_sellPrice:ResetParamInfo();

	local format = "{@st42}{s20}";

	for i = 1, #couponList do
		local itemClass = GetClass("Item", couponList[i]);
		if itemClass ~= nil then
			format = format .. string.format("{img %s 40 40}", TryGetProp(itemClass, "Icon"));
			format = format .. "  %s";

			if i ~= #couponList then
				format = format .. "    ";
			end
		end
	end
	
	format = format .. "{/}{/}";

	txt_sellPrice:SetFormat(format);

	for i = 1, #couponList do
		txt_sellPrice:AddParamInfo(couponList[i] .. "_count", 0);
		txt_sellPrice:SetTextByParamIndex(0, 0);
	end
end

function CLOSE_HOUSING_SHOP_PAYMENT()
end

function HOUSING_SHOP_PAYMENT_INITIALIZE(buyPrice, previewPrice, sellPrice)
	ui.OpenFrame("housing_shop_payment");
	local frame = ui.GetFrame("housing_shop_payment");

	local txt_buyFurniturePrice = GET_CHILD_RECURSIVELY(frame, "txt_buyFurniturePrice");
	local txt_buyPreviewPrice = GET_CHILD_RECURSIVELY(frame, "txt_buyPreviewPrice");
	local txt_coupon = GET_CHILD_RECURSIVELY(frame, "txt_coupon");
	local txt_sellPrice = GET_CHILD_RECURSIVELY(frame, "txt_sellPrice");

	txt_buyFurniturePrice:SetTextByKey("price", GetCommaedText(buyPrice));
	txt_buyFurniturePrice:SetUserValue("Price", buyPrice);

	txt_buyPreviewPrice:SetTextByKey("price", GetCommaedText(previewPrice));
	txt_buyPreviewPrice:SetUserValue("Price", previewPrice);

	local couponList = HOUSING_SHOP_PAYMENT_COUPON_LIST();
	local sortedCoupon, couponCount = HOUSING_SHOP_PAYMENT_AUTO_COUPON_COUNT(couponList, sellPrice, nil);

	for i = 1, #sortedCoupon do
		txt_sellPrice:SetTextByKey(sortedCoupon[i] .. "_count", couponCount[i]);
		txt_sellPrice:SetUserValue(sortedCoupon[i] .. "_count", couponCount[i]);
	end

	HOUSING_SHOP_PAYMENT_SET_BUY_PRICE(frame, buyPrice, previewPrice, 0);
end

function HOUSING_SHOP_PAYMENT_SET_BUY_PRICE(frame, buyPrice, previewPrice, discount)
	if buyPrice == nil then
		buyPrice = 0;
	end

	if previewPrice == nil then
		previewPrice = 0;
	end

	local txt_buyPrice = GET_CHILD_RECURSIVELY(frame, "txt_buyPrice");
	local price = buyPrice + previewPrice - discount;
	price = CLAMP(price, 0, price);
	txt_buyPrice:SetTextByKey("price", GetCommaedText(price));
	
	local txt_couponDiscount = GET_CHILD_RECURSIVELY(frame, "txt_couponDiscount");
	txt_couponDiscount:SetTextByKey("price", GetCommaedText(discount));
end

function HOUSING_SHOP_PAYMENT_ADD_COUPON(frame, gbox_coupon, couponItemName)
	local itemClass = GetClass("Item", couponItemName);
	if itemClass == nil then
		return false;
	end

	local pc = GetMyPCObject();
	local couponItemCount = GetInvItemCount(pc, couponItemName);
	if couponItemCount <= 0 then
		return false;
	end
	
	local invItem = session.GetInvItemByName(couponItemName);
	if invItem == nil or invItem.isLockState == true then
		return false;
	end
	
	local coupon = gbox_coupon:CreateControlSet("personal_housing_shop_coupon", "COUPON_" .. couponItemName, 0, 0);
	coupon:SetUserValue("ItemClassName", couponItemName);
	
	local slot = GET_CHILD_RECURSIVELY(coupon, "slot");
	local icon = CreateIcon(slot);
	icon:Set(TryGetProp(itemClass, "Icon"), "PersonalHousingShopCoupon", itemClass.ClassID, 0);

	icon:SetTooltipType('wholeitem');
	icon:SetTooltipArg('sell', itemClass.ClassID, 0);

	slot:SetEventScript(ui.LBUTTONDOWN, "HOUSING_SHOP_PAYMENT_COUPON_UP");
	slot:SetEventScript(ui.RBUTTONDOWN, "HOUSING_SHOP_PAYMENT_COUPON_DOWN");

	local hasCount = GET_CHILD_RECURSIVELY(coupon, "hasCount");
	hasCount:SetTextByKey("count", couponItemCount);

	return true;
end

function HOUSING_SHOP_PAYMENT_COUPON_UP(controlset, slot)
	local housing_shop_payment = controlset:GetTopParentFrame();
	local couponItemName = controlset:GetUserValue("ItemClassName");
	
	local itemClass = GetClass("Item", couponItemName);
	if itemClass == nil then
		return;
	end

	local pc = GetMyPCObject();
	local couponItemCount = GetInvItemCount(pc, couponItemName);
	if couponItemCount <= 0 then
		return;
	end
	
	local itemCount = GET_CHILD_RECURSIVELY(controlset, "itemCount");
	local count = tonumber(itemCount:GetText());
	if count == nil then
		count = 0;
	end

	local buyPrice = HOUSING_SHOP_PAYMENT_BUY_FURNITURE_PRICE();
	local previewPrice = HOUSING_SHOP_PAYMENT_PREVIEW_FURNITURE_PRICE();
	local totalDiscountSilver = 0;

	local couponList = HOUSING_SHOP_PAYMENT_COUPON_LIST();
	for i = 1, #couponList do
		if couponList[i] ~= couponItemName then
			totalDiscountSilver = totalDiscountSilver + HOUSING_SHOP_PAYMENT_COUPON_DISCOUNT(housing_shop_payment, couponList[i]);
		end
	end
	
	local discountSilver = count * TryGetProp(itemClass, "NumberArg1", 0);
	if buyPrice + previewPrice <= totalDiscountSilver + discountSilver then
		return;
	end
	
	count = CLAMP(count + 1, 0, couponItemCount);
	itemCount:SetText(count);

	discountSilver = count * TryGetProp(itemClass, "NumberArg1", 0);
	totalDiscountSilver = totalDiscountSilver + discountSilver;

	local discount = GET_CHILD_RECURSIVELY(controlset, "discount");
	discount:SetTextByKey("price", GetCommaedText(discountSilver));

	local frame = controlset:GetTopParentFrame();
	local txt_buyFurniturePrice = GET_CHILD_RECURSIVELY(frame, "txt_buyFurniturePrice");
	local txt_buyPreviewPrice = GET_CHILD_RECURSIVELY(frame, "txt_buyPreviewPrice");
	HOUSING_SHOP_PAYMENT_SET_BUY_PRICE(frame, tonumber(txt_buyFurniturePrice:GetUserValue("Price")), tonumber(txt_buyPreviewPrice:GetUserValue("Price")), totalDiscountSilver);
end

function HOUSING_SHOP_PAYMENT_COUPON_DOWN(controlset, slot)
	local housing_shop_payment = controlset:GetTopParentFrame();
	local couponItemName = controlset:GetUserValue("ItemClassName");

	local itemClass = GetClass("Item", couponItemName);
	if itemClass == nil then
		return;
	end

	local pc = GetMyPCObject();
	local couponItemCount = GetInvItemCount(pc, couponItemName);
	if couponItemCount <= 0 then
		return;
	end
	
	local itemCount = GET_CHILD_RECURSIVELY(controlset, "itemCount");
	local count = tonumber(itemCount:GetText());
	if count == nil then
		count = 0;
	end

	count = CLAMP(count - 1, 0, couponItemCount);
	itemCount:SetText(count);
	
	local discount = GET_CHILD_RECURSIVELY(controlset, "discount");
	local discountSilver = count * TryGetProp(itemClass, "NumberArg1", 0);
	discount:SetTextByKey("price", GetCommaedText(discountSilver));
	
	local buyPrice = HOUSING_SHOP_PAYMENT_BUY_FURNITURE_PRICE();
	local previewPrice = HOUSING_SHOP_PAYMENT_PREVIEW_FURNITURE_PRICE();
	local totalDiscountSilver = discountSilver;

	local couponList = HOUSING_SHOP_PAYMENT_COUPON_LIST();
	for i = 1, #couponList do
		if couponList[i] ~= couponItemName then
			totalDiscountSilver = totalDiscountSilver + HOUSING_SHOP_PAYMENT_COUPON_DISCOUNT(housing_shop_payment, couponList[i]);
		end
	end
	
	local frame = controlset:GetTopParentFrame();
	local txt_buyFurniturePrice = GET_CHILD_RECURSIVELY(frame, "txt_buyFurniturePrice");
	local txt_buyPreviewPrice = GET_CHILD_RECURSIVELY(frame, "txt_buyPreviewPrice");
	HOUSING_SHOP_PAYMENT_SET_BUY_PRICE(frame, tonumber(txt_buyFurniturePrice:GetUserValue("Price")), tonumber(txt_buyPreviewPrice:GetUserValue("Price")), totalDiscountSilver);
end

function HOUSING_SHOP_PAYMENT_COUPON_COUNT_CHANGE(controlset, edit)
	local housing_shop_payment = controlset:GetTopParentFrame();
	local couponItemName = controlset:GetUserValue("ItemClassName");

	local itemClass = GetClass("Item", couponItemName);
	if itemClass == nil then
		return;
	end

	local pc = GetMyPCObject();
	local couponItemCount = GetInvItemCount(pc, couponItemName);
	if couponItemCount <= 0 then
		return;
	end
	
	local count = tonumber(edit:GetText());
	if count == nil then
		count = 0;
	end
	
	count = CLAMP(count, 0, couponItemCount);

	local buyPrice = HOUSING_SHOP_PAYMENT_BUY_FURNITURE_PRICE();
	local previewPrice = HOUSING_SHOP_PAYMENT_PREVIEW_FURNITURE_PRICE();
	local totalDiscountSilver = 0;

	local couponList = HOUSING_SHOP_PAYMENT_COUPON_LIST();
	for i = 1, #couponList do
		if couponList[i] ~= couponItemName then
			totalDiscountSilver = totalDiscountSilver + HOUSING_SHOP_PAYMENT_COUPON_DISCOUNT(housing_shop_payment, couponList[i]);
		end
	end

	local leftSilver = (buyPrice + previewPrice) - totalDiscountSilver;
	local enableUseCouponCount = math.ceil(CLAMP((leftSilver - 1), 0, (leftSilver - 1)) / TryGetProp(itemClass, "NumberArg1", 0));

	count = CLAMP(count, 0, enableUseCouponCount);

	edit:SetText(count);

	local discount = GET_CHILD_RECURSIVELY(controlset, "discount");
	local discountSilver = count * TryGetProp(itemClass, "NumberArg1", 0);
	discount:SetTextByKey("price", GetCommaedText(discountSilver));

	totalDiscountSilver = totalDiscountSilver + discountSilver;

	local frame = controlset:GetTopParentFrame();
	local txt_buyFurniturePrice = GET_CHILD_RECURSIVELY(frame, "txt_buyFurniturePrice");
	local txt_buyPreviewPrice = GET_CHILD_RECURSIVELY(frame, "txt_buyPreviewPrice");
	HOUSING_SHOP_PAYMENT_SET_BUY_PRICE(frame, tonumber(txt_buyFurniturePrice:GetUserValue("Price")), tonumber(txt_buyPreviewPrice:GetUserValue("Price")), totalDiscountSilver);
end

function PERSONAL_HOUSING_PAYMENT_CANCEL()
	housing.PersonalHousingShopPaymentClear();
	ui.CloseFrame("housing_shop_payment");
end

function PERSONAL_HOUSING_PAYMENT(parent, btn)
	local housing_shop_payment = ui.GetFrame("housing_shop_payment");
	if housing_shop_payment == nil then
		return;
	end

	if housing_shop_payment:IsVisible() == 0 then
		return;
	end

	local housing_shop = ui.GetFrame("housing_shop");
	if housing_shop == nil then
		return;
	end

	if housing_shop:IsVisible() == 0 then
		return;
	end
	
	housing.PersonalHousingShopPaymentClear();

	local chk_previewItem_arrangement = GET_CHILD_RECURSIVELY(housing_shop_payment, 'chk_previewItem_arrangement');
	if chk_previewItem_arrangement == nil then
		return;
	end
	
	local isEnablePreviewArrangement = chk_previewItem_arrangement:IsChecked() ~= 0;
	
	local discountSilver = 0;
	
	local couponList = HOUSING_SHOP_PAYMENT_COUPON_LIST();
	for i = 1, #couponList do
		discountSilver = discountSilver + HOUSING_SHOP_PAYMENT_COUPON_DISCOUNT(housing_shop_payment, couponList[i]);
	end

	local buyPrice = 0;
	local previewPrice = 0;

	local groupbox = GET_CHILD_RECURSIVELY(housing_shop, 'buyitemslot');
	local slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();
	
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			local slotItemClassID = GET_SHOP_SLOT_CLSID(slot);
			local shopItem = geShopTable.GetByClassID(slotItemClassID);
			if shopItem ~= nil then
				local itemClass = GET_SHOP_ITEM_CLS(shopItem);
				
				local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM(itemClass.ClassName);
				if furnitureClass ~= nil and furnitureClass.Type == "Personal" then
					local itemCount = slot:GetUserValue("BuyCount");
					if itemCount == nil or itemCount == "None" then
						itemCount = 0;
					else
						itemCount = tonumber(itemCount);
					end

					if itemCount > 0 then
						buyPrice = buyPrice + TryGetProp(itemClass, "Price") * itemCount;
						housing.PersonalHousingShopPaymentAddBuyItem(slotItemClassID, itemCount);
					end
				end
			end
		end
	end
	
	groupbox = GET_CHILD_RECURSIVELY(housing_shop, 'preview_furniture_slot');
	slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	slotCount = slotSet:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			local itemClassID = tonumber(slot:GetUserValue("ItemClassID"));
			local itemClass = GetClassByType("Item", itemClassID);
			if itemClass ~= nil then
				local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM(itemClass.ClassName);
				if furnitureClass ~= nil and furnitureClass.Type == "Personal" then
					local itemCount = slot:GetUserValue("BuyCount");
					if itemCount == nil or itemCount == "None" then
						itemCount = 0;
					else
						itemCount = tonumber(itemCount);
					end

					if itemCount > 0 then
						previewPrice = previewPrice + TryGetProp(itemClass, "Price") * itemCount;
					end
				end
			end
		end
	end
	
	groupbox = GET_CHILD_RECURSIVELY(housing_shop, 'sellitemslot');
	slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	slotCount = slotSet:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			local itemID = slot:GetUserValue("SLOT_ITEM_ID");
			local invitem = session.GetInvItemByGuid(itemID);
			if invitem ~= nil then
				local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM_CLASSID(invitem.type);
				if furnitureClass ~= nil then
					local itemCount = slot:GetUserValue("SellCount");
					if itemCount == nil or itemCount == "None" then
						itemCount = 0;
					else
						itemCount = tonumber(itemCount);
					end

					if itemCount > 0 then
						housing.PersonalHousingShopPaymentAddSellItem(itemID, itemCount);
					end
				end
			end
		end
	end
	
	local hasSilver = 0;
	local invItem = session.GetInvItemByName('Vis');
	if invItem ~= nil then
		hasSilver = tonumber(invItem:GetAmountStr());
	end
	
	if (buyPrice + previewPrice - discountSilver) > hasSilver then
		ui.SysMsg(ClMsg("NOT_ENOUGH_MONEY"));
		return;
	end

	local leftCouponMoney = discountSilver - (buyPrice + previewPrice);

	local msg;
	if leftCouponMoney > 0 then
		msg = ScpArgMsg("Personal_Housing_Really_Payment_LeftCouponMoney", "LeftCouponMoney", GetCommaedText(leftCouponMoney));
	else
		msg = ClMsg("Personal_Housing_Really_Payment");
	end

	local isEnable_num = 0;
	if isEnablePreviewArrangement == true then
		isEnable_num = 1;
	end

	ui.MsgBox(msg, string.format("PERSONAL_HOUSING_PAYMENT_COMMIT(%d)", isEnable_num), "PERSONAL_HOUSING_PAYMENT_COMMIT_CANCEL()");
end

function PERSONAL_HOUSING_PAYMENT_COMMIT(isEnable_num)
	local isEnablePreviewArrangement = false;
	if isEnable_num == 1 then
		isEnablePreviewArrangement = true;
	end
	housing.PersonalHousingShopPaymentCommit(isEnablePreviewArrangement);

	ui.CloseFrame("housing_shop_payment");
	OPEN_HOUSING_SHOP(ui.GetFrame("housing_shop"));
end

function PERSONAL_HOUSING_PAYMENT_COMMIT_CANCEL()
	housing.PersonalHousingShopPaymentClear();
end

function HOUSING_SHOP_PAYMENT_COUPON_DISCOUNT(housing_shop_payment, couponItemName)
	local couponControlset = GET_CHILD_RECURSIVELY(housing_shop_payment, "COUPON_" .. couponItemName);
	
	local pc = GetMyPCObject();
	local couponItemCount = GetInvItemCount(pc, couponItemName);
	if couponItemCount < 0 then
		return 0;
	end

	local invItem = session.GetInvItemByName(couponItemName);
	if invItem == nil or invItem.isLockState == true then
		return 0;
	end

	local itemCount = GET_CHILD_RECURSIVELY(couponControlset, "itemCount");
	local itemClass = GetClass("Item", couponItemName);
	if itemClass == nil then
		return 0;
	end

	local useCouponCount = tonumber(itemCount:GetText());
	if useCouponCount == nil then
		useCouponCount = 0;
	end
	
	useCouponCount = CLAMP(useCouponCount, 0, couponItemCount);
	if useCouponCount == 0 then
		return 0;
	end

	housing.PersonalHousingShopPaymentAddCoupon(invItem:GetIESID(), useCouponCount);
	
	return useCouponCount * TryGetProp(itemClass, "NumberArg1", 0);
end

function HOUSING_SHOP_PAYMENT_BUY_FURNITURE_PRICE()
	local housing_shop = ui.GetFrame("housing_shop");

	local buyPrice = 0;

	local groupbox = GET_CHILD_RECURSIVELY(housing_shop, 'buyitemslot');
	local slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();
	
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			local slotItemClassID = GET_SHOP_SLOT_CLSID(slot);
			local shopItem = geShopTable.GetByClassID(slotItemClassID);
			if shopItem ~= nil then
				local itemClass = GET_SHOP_ITEM_CLS(shopItem);
				
				local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM(itemClass.ClassName);
				if furnitureClass ~= nil and furnitureClass.Type == "Personal" then
					local itemCount = slot:GetUserValue("BuyCount");
					if itemCount == nil or itemCount == "None" then
						itemCount = 0;
					else
						itemCount = tonumber(itemCount);
					end

					if itemCount > 0 then
						buyPrice = buyPrice + TryGetProp(itemClass, "Price") * itemCount;
					end
				end
			end
		end
	end

	return buyPrice;
end

function HOUSING_SHOP_PAYMENT_PREVIEW_FURNITURE_PRICE()
	local housing_shop = ui.GetFrame("housing_shop");

	local previewPrice = 0;

	local groupbox = GET_CHILD_RECURSIVELY(housing_shop, 'preview_furniture_slot');
	local slotSet = tolua.cast(groupbox, 'ui::CSlotSet');
	local slotCount = slotSet:GetSlotCount();
	
	for i = 0, slotCount - 1 do
		local slot = slotSet:GetSlotByIndex(i);
		if slot:GetIcon() ~= nil then
			local itemClassID = tonumber(slot:GetUserValue("ItemClassID"));
			local itemClass = GetClassByType("Item", itemClassID);
			if itemClass ~= nil then
				local furnitureClass = GET_FURNITURE_CLASS_BY_ITEM(itemClass.ClassName);
				if furnitureClass ~= nil and furnitureClass.Type == "Personal" then
					local itemCount = slot:GetUserValue("BuyCount");
					if itemCount == nil or itemCount == "None" then
						itemCount = 0;
					else
						itemCount = tonumber(itemCount);
					end

					if itemCount > 0 then
						previewPrice = previewPrice + TryGetProp(itemClass, "Price") * itemCount;
					end
				end
			end
		end
	end
	
	return previewPrice;
end

function PERSONAL_HOUSING_PAYMENT_AUTO_APPLY_COUPON(parent, btn)
	local buyPrice = HOUSING_SHOP_PAYMENT_BUY_FURNITURE_PRICE();
	local previewPrice = HOUSING_SHOP_PAYMENT_PREVIEW_FURNITURE_PRICE();
	local totalPrice = buyPrice + previewPrice;

	local couponList = HOUSING_SHOP_PAYMENT_COUPON_LIST();
	local pc = GetMyPCObject();

	local hasCouponCount = {};
	for i = 1, #couponList do
		local couponItemCount = GetInvItemCount(pc, couponList[i]);
		hasCouponCount[couponList[i]] = couponItemCount;
	end

	local sortedCoupon, couponCount = HOUSING_SHOP_PAYMENT_AUTO_COUPON_COUNT(couponList, totalPrice, hasCouponCount);

	local housing_shop_payment = ui.GetFrame("housing_shop_payment");

	local totalDiscountSilver = 0;

	for i = 1, #sortedCoupon do
		local itemClassA = GetClass("Item", sortedCoupon[i]);
		local discountSilver = TryGetProp(itemClassA, "NumberArg1", 0);
		
		local couponControlset = GET_CHILD_RECURSIVELY(housing_shop_payment, "COUPON_" .. sortedCoupon[i]);
		if couponControlset ~= nil then
			local edit = GET_CHILD_RECURSIVELY(couponControlset, "itemCount");
			edit:SetText(couponCount[i]);

			local discount = GET_CHILD_RECURSIVELY(couponControlset, "discount");
			discount:SetTextByKey("price", GetCommaedText(discountSilver * couponCount[i]));

			totalDiscountSilver = totalDiscountSilver + discountSilver * couponCount[i];
		end
	end
	
	local txt_buyFurniturePrice = GET_CHILD_RECURSIVELY(housing_shop_payment, "txt_buyFurniturePrice");
	local txt_buyPreviewPrice = GET_CHILD_RECURSIVELY(housing_shop_payment, "txt_buyPreviewPrice");
	HOUSING_SHOP_PAYMENT_SET_BUY_PRICE(housing_shop_payment, tonumber(txt_buyFurniturePrice:GetUserValue("Price")), tonumber(txt_buyPreviewPrice:GetUserValue("Price")), totalDiscountSilver);
end