
function PERSONAL_SHOP_REGISTER_ON_INIT(addon, frame)


end

function UPDATE_PSSHOP_SLOT(ctrlSet, info)

	local slot = GET_CHILD(ctrlSet, "slot");
	local itemname = GET_CHILD(ctrlSet, "itemname");
	local price = GET_CHILD(ctrlSet, "price");
	local buycount = GET_CHILD(ctrlSet, "buycount");
	local itemCls = GetClassByType("Item", info.classID);
	itemname:SetTextByKey("value", itemCls.Name);
	SET_SLOT_ITEM_CLS(slot, itemCls);
	price:SetTextByKey("value", info.price);
	buycount:SetTextByKey("value", info.remainCount);
	
end

function PERSONAL_SHOP_REG_UPDATE_LIST(frame)

	local gbox = frame:GetChild("gbox");
	local selllist = gbox:GetChild("selllist");
	selllist:RemoveAllChild();

	local groupName = frame:GetUserValue("GroupName");
	local cnt = session.autoSeller.GetCount(groupName);
	for i = 0 , cnt - 1 do
		local info = session.autoSeller.GetByIndex(groupName, i);
		local ctrlSet = selllist:CreateControlSet("personalshop_reg", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		UPDATE_PSSHOP_SLOT(ctrlSet, info);
		ctrlSet:SetUserValue("ITEMINDEX", i);
	end

	local ctrlSet = selllist:CreateControlSet("personalshop_reg_new", "CTRLSET_NEW",  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	GBOX_AUTO_ALIGN(selllist, 10, 10, 10, true, false);
	local input_count = GET_CHILD(ctrlSet, "input_count");
	input_count:SetOverSound("chat_typing")
	local input_price = GET_CHILD(ctrlSet, "input_price");
	input_price:SetOverSound("chat_typing")
	local edit = GET_CHILD(ctrlSet,"edit")
	edit:SetOverSound("chat_typing")
end


function PS_SHOP_REG_CANCEL(frame)
	frame = frame:GetTopParentFrame();
	frame:ShowWindow(0);
end

function PERSONAL_SHOP_REG_OPEN(frame)

	frame:SetUserValue("GroupName", "PersonalShop");
	frame:SetUserValue("ServerGroupName", "PersonalShop");
	session.autoSeller.ClearGroup("PersonalShop");
	PERSONAL_SHOP_REG_UPDATE_LIST(frame);

end

function PS_SET_FINDED_ITEM(ctrl, itemCls)
	SET_ITEM_TOOLTIP_BY_TYPE(ctrl, itemCls.ClassID);
	ctrl:SetEventScript(ui.LBUTTONUP, "PS_SET_ITEM_TO_SLOT");
	ctrl:SetUserValue("ITEM_CLSID", itemCls.ClassID);
end

function PS_SET_ITEM_TO_SLOT(parent, ctrl)
	local itemType = ctrl:GetUserIValue("ITEM_CLSID");
	local ctrlSet = parent:GetParent();
	local slot = GET_CHILD(ctrlSet, "slot");
	local cls = GetClassByType("Item", itemType);
	SET_SLOT_ITEM_CLS(slot, cls);
	slot:SetUserValue("ITEM_CLSID", itemType);
end

function PS_FIND_ITEM_BY_NAME(parent, ctrl)
	local findText = ctrl:GetText();
	local detaillist = GET_CHILD(parent, "detaillist");
	detaillist:ClearBarInfo();
	detaillist:AddBarInfo("Icon", "", 48);
	detaillist:AddBarInfo("Name", "{@st40}" .. ClMsg("Name"), 300);
	detaillist:RemoveAllChild();	

	local cnt = FindClassesByProp("Item", "Name", findText, "IS_PERSONAL_SHOP_TRADABLE", true);
	cnt = math.min(cnt, 20);
	for i = 0 , cnt - 1 do
		local findedName = GetFindedClass(i);
		local itemCls = GetClass("Item", findedName);

		local key = itemCls.ClassName;		
		local imageName = itemCls.Icon;
		local pic = INSERT_PICTURE_DETAIL_LIST(detaillist, i, 0, imageName, 40);
		PS_SET_FINDED_ITEM(pic, itemCls);
		local text = INSERT_TEXT_DETAIL_LIST(detaillist, i, 1, "{@st41}" .. itemCls.Name, nil, nil, "{@st41}" .. itemCls.Name);
		PS_SET_FINDED_ITEM(text, itemCls);
	end	

	detaillist:RealignItems();
end

function PS_SHOP_CANCEL(parent, ctrl)
	local itemIndex = parent:GetUserIValue("ITEMINDEX");
	local frame = parent:GetTopParentFrame();
	local groupName = frame:GetUserValue("GroupName");
	session.autoSeller.RemoveByIndex(groupName, itemIndex);	
	PERSONAL_SHOP_REG_UPDATE_LIST(frame);
end

function PS_REGISTER_ITEM(parent, ctrl)

	local input_count = GET_CHILD(parent, "input_count");
	local input_price = GET_CHILD(parent, "input_price");
	if input_count:GetNumber() <= 0 or input_price:GetNumber() <= 0 then
		return;
	end

	local slot = GET_CHILD(parent, "slot");
	local itemType = slot:GetUserIValue("ITEM_CLSID");
	local itemCls = GetClassByType("Item", itemType);
	if itemCls == nil then
		return;
	end

	local groupName = parent:GetTopParentFrame():GetUserValue("GroupName");
	if session.autoSeller.GetByType(groupName, itemType) ~= nil then
		ui.SysMsg(ClMsg("CantRegisterSameTypeGoods"));
		return;
	end

	local info = session.autoSeller.CreateToGroup(groupName);
	info.classID = itemType;
	info.price = input_price:GetNumber();
	info.remainCount = input_count:GetNumber();
	local frame = parent:GetTopParentFrame();
	PERSONAL_SHOP_REG_UPDATE_LIST(frame);

	 
end

function OPEN_PERSONAL_SHOP_REGISTER()
	if true == session.loginInfo.IsPremiumState(ITEM_TOKEN) then
		ui.SysMsg(ClMsg("NeedPremiunState"));
		return;
	end

	if session.autoSeller.GetMyAutoSellerShopState(1) == true then
		ui.OpenFrame("buffseller_my");
	else
		local mapCls = GetClass("Map", session.GetMapName());
		if nil == mapCls then
			return;
		end
		if 'City' ~= mapCls.MapType then
			ui.SysMsg(ClMsg("AllowedInTown"));
			return;
		end
		ui.OpenFrame("personal_shop_register");
	end
end

