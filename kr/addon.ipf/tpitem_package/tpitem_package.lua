
-- tpitem_package.lua : (tp shop)

function TPITEM_PACKAGE_OPEN(parent, control, ItemClassIDstr, itemid)
		local frame = ui.GetFrame("tpitem");
		local screenbgTemp = frame:GetChild('screenbgTemp');	
		screenbgTemp:ShowWindow(1);	

		local tpitem_package = ui.GetFrame("tpitem_package");
		tpitem_package:ShowWindow(1);
		local stdBox = GET_CHILD(tpitem_package, "stdBox");
		TPITEM_PACKAGE_SETUI(stdBox, ItemClassIDstr);
		local puchaseBtn = GET_CHILD(stdBox,"puchaseBtn");
		puchaseBtn:SetEventScriptArgString(ui.LBUTTONUP, ItemClassIDstr);
		puchaseBtn:SetEventScriptArgNumber(ui.LBUTTONUP, itemid);
		local price = control:GetUserIValue("itemPrice");
		if price ~= nil then
			puchaseBtn:SetUserValue("itemPrice", price);
		end		
end

function TPITEM_PACKAGE_CLOSE(parent, control)
		local frame = ui.GetFrame("tpitem");
		local screenbgTemp = frame:GetChild('screenbgTemp');	
		screenbgTemp:ShowWindow(0);	

		local tpitem_package = ui.GetFrame("tpitem_package");
		tpitem_package:ShowWindow(0);
end

function TPSHOP_TRY_BUY_PACKAGE_BY_NEXONCASH(parent, control, ItemClassIDstr, itemid)
	local frame = ui.GetFrame("tpitem");
	local screenbgTemp = frame:GetChild('screenbgTemp');	
	screenbgTemp:ShowWindow(1);	

	ui.BuyIngameShopItem(itemid, 1);

	local tpitem_package = ui.GetFrame("tpitem_package");
	tpitem_package:ShowWindow(0);
end

function TPITEM_PACKAGE_SETUI(frame, clsid)		
		local cls = GetClassByType("Item", tonumber(clsid));
		if cls == nil  then
			return;
		end
		local itemTitle = GET_CHILD(frame, "itemTitle");
		itemTitle:SetTextByKey("name", cls.Name);

		local packageSlot = GET_CHILD(frame,"packageSlot");	
		SET_SLOT_IMG(packageSlot, cls.Icon);
		
		local bgBox = frame:CreateOrGetControl('groupbox', 'bgBox', 30, 370, 440, 220);
		bgBox = tolua.cast(bgBox, "ui::CGroupBox");
		bgBox:DeleteAllControl();
		bgBox:EnableDrawFrame(1);
		bgBox:EnableScrollBar(1);
		bgBox:SetScrollBar(220);
		bgBox:SetScrollPos(0);
		bgBox:SetSkinName("test_frame_midle_light");
		
		local innerBox = bgBox:CreateOrGetControl('groupbox', 'innerBox', 0, 0, bgBox:GetWidth(), 650);
		innerBox = tolua.cast(innerBox, "ui::CGroupBox");
		innerBox:DeleteAllControl();
		innerBox:EnableDrawFrame(0);
		innerBox:EnableScrollBar(0);
		innerBox:SetSkinName("None");

		local contents = innerBox:CreateControl("richtext", "contents", 20, 20, bgBox:GetWidth() - 40, 40);
		tolua.cast(contents, "ui::CRichText");
		contents:SetTextFixWidth(1);
		contents:SetFontName("black_16_b");
		contents:SetText(string.format("{@st43d}{s18}%s{/}",cls.Desc));

		innerBox:Resize(innerBox:GetWidth(), contents:GetHeight() + (contents:GetY() * 2));
end