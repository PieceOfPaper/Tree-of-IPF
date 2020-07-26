function INGAMEALERT_ON_INIT(addon, frame)
	addon:RegisterMsg("INGAME_PRIVATE_ALERT", "INGAMEALERT_SHOW")
	addon:RegisterMsg("INDUN_ASK_PARTY_MATCH", "ON_INDUN_ASK_PARTY_MATCH")
	addon:RegisterMsg("SOLD_ITEM_NOTICE", "ON_SOLD_ITEM_NOTICE")
	addon:RegisterMsg("RECEIVABLE_SILVER_NOTICE", "ON_RECEIVABLE_SILVER_NOTICE")
	addon:RegisterMsg("RECEIVABLE_TAX_PAYMENT_NOTICE", "ON_RECEIVABLE_TAX_PAYMENT_NOTICE")
	addon:RegisterMsg("FIELD_BOSS_WORLD_EVENT_RECEIVABLE_ITEM_NOTICE", "ON_FIELD_BOSS_WORLD_EVENT_RECEIVABLE_ITEM_NOTICE")	
	addon:RegisterMsg("FIELD_BOSS_WORLD_EVENT_RECEIVABLE_SILVER_NOTICE", "ON_FIELD_BOSS_WORLD_EVENT_RECEIVABLE_SILVER_NOTICE")	
	
	INGAMEALERT_CREATE_ELEM_BY_TYPE(frame, "Private")
	INGAMEALERT_CREATE_ELEM_BY_TYPE(frame, "Party")
	INGAMEALERT_CREATE_ELEM_BY_TYPE(frame, "SoldItem")
	INGAMEALERT_CREATE_ELEM_BY_TYPE(frame, "ReceivableSilver")
	INGAMEALERT_CREATE_ELEM_BY_TYPE(frame, "TaxPayment")
	INGAMEALERT_CREATE_ELEM_BY_TYPE(frame, "WorldEventReceivableItem")
	INGAMEALERT_CREATE_ELEM_BY_TYPE(frame, "WorldEventReceivableSilver")
	INGAMEALERT_SET_SCRIPT_YESNO(frame, "TaxPayment", "INGAMEALERT_TAX_PAYMENT_SCP_YES", "None")

end

function INGAMEALERT_GET_CHILD_NAME_BY_TYPE(type)
	local childName = "elem_"..type
	return childName
end

function INGAMEALERT_CREATE_ELEM_BY_TYPE(frame, type)
	local width = ui.GetControlSetAttribute("ingamealert_elem", "width")
	local height = ui.GetControlSetAttribute("ingamealert_elem", "height")
	local list_gb = GET_CHILD(frame, "list_gb")
	local childName = INGAMEALERT_GET_CHILD_NAME_BY_TYPE(type)
	local ctrlset = list_gb:CreateOrGetControlSet("ingamealert_elem", childName, ui.LEFT, ui.BOTTOM, 0, 0, width, height)
	AUTO_CAST(ctrlset)
	ctrlset:Resize(width, height)
	ctrlset:SetAnimation("openAnim", ctrlset:GetUserConfig("OPEN_ANIM"));
	ctrlset:SetAnimation("closeAnim", ctrlset:GetUserConfig("CLOSE_ANIM"));
	ctrlset:ShowWindow(0)

	local isShowCloseBtn = 1
	local closeBtn = GET_CHILD(ctrlset, "closeBtn")
	closeBtn:ShowWindow(isShowCloseBtn)

	local isShowYesNoBtn = 0
	local yesBtn = GET_CHILD(ctrlset, "yesBtn")
	local noBtn = GET_CHILD(ctrlset, "noBtn")
	yesBtn:ShowWindow(isShowYesNoBtn)
	noBtn:ShowWindow(isShowYesNoBtn)
	return ctrlset
end

function INGAMEALERT_SET_SCRIPT_YESNO(frame, type, yesScp, noScp)
	local list_gb = GET_CHILD(frame, "list_gb")
	local childName = INGAMEALERT_GET_CHILD_NAME_BY_TYPE(type)
	local ctrlset = list_gb:GetControlSet("ingamealert_elem", childName)

	local isShowCloseBtn = 0
	local closeBtn = GET_CHILD(ctrlset, "closeBtn")
	closeBtn:ShowWindow(isShowCloseBtn)

	local isShowYesNoBtn = 1
	local yesBtn = GET_CHILD(ctrlset, "yesBtn")
	local noBtn = GET_CHILD(ctrlset, "noBtn")
	yesBtn:ShowWindow(isShowYesNoBtn)
	noBtn:ShowWindow(isShowYesNoBtn)
	
	ctrlset:SetUserValue("SCRIPT_YES", yesScp)
	ctrlset:SetUserValue("SCRIPT_NO", noScp)
end

function INGAMEALERT_GET_ELEM_BY_TYPE(frame, type)
	local list_gb = GET_CHILD(frame, "list_gb")
	local childName = INGAMEALERT_GET_CHILD_NAME_BY_TYPE(type)
	local num = frame:GetUserIValue("MaxNum")
	local ctrlset = GET_CHILD(list_gb, childName)
	if ctrlset:IsVisible() == 1 then
		ctrlset:ShowWindow(0)
	end
	ctrlset:SetUserValue("Num", num)
	frame:SetUserValue("MaxNum", num + 1)
	ctrlset:ShowWindow(1)
	return ctrlset
end

function INGAMEALERT_SET_MARGIN_BY_CHAT_FRAME(frame)
	local chatFrame = ui.GetFrame("chatframe")
	if chatFrame ~= nil and chatFrame:IsVisible() == 1 then
		frame:SetMargin(5, 0, 0, config.GetXMLConfig("ChatFrameSizeHeight") + 20)
	end
	INGAMEALERT_ALIGN_ELEM(frame)
	frame:ShowWindow(1)
end

function INGAMEALERT_ALIGN_ELEM(frame)
	local list_gb = GET_CHILD(frame, "list_gb")

	local list = {}
	for i=0, list_gb:GetChildCount()-1 do
		list[#list+1] = list_gb:GetChildByIndex(i)
	end

	table.sort(list, function(a, b) return a:GetUserIValue("Num") < b:GetUserIValue("Num") end)

	local y = 0
	for i=1, #list do
		local ctrlset = list[i]
		ctrlset:SetOffset(0, y)
		if ctrlset:IsVisible() == 1 then
			y = y + ctrlset:GetHeight()
		end
	end

	local PADDING_TOP = tonumber(frame:GetUserConfig("PADDING_TOP"))
	list_gb:Resize(list_gb:GetOriginalWidth(), y+PADDING_TOP)
	frame:Resize(frame:GetOriginalWidth(), y+PADDING_TOP)
end

function INGAMEALERT_REMOVE_ELEM_BY_OBJECT(obj)
	local frame = obj:GetTopParentFrame()
	local list_gb = GET_CHILD(frame, "list_gb")
	obj:ShowWindow(0)
end

function ON_INGAMEALERT_ELEM_CLOSE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	INGAMEALERT_REMOVE_ELEM_BY_OBJECT(parent)
	INGAMEALERT_ALIGN_ELEM(frame)

	local count = 0; 
	local list_gb = GET_CHILD(frame, "list_gb")
	for i=0, list_gb:GetChildCount()-1 do
		local ctrl = list_gb:GetChildByIndex(i);
		if ctrl:IsVisible() == 1 then
			count = count + 1;
		end
	end

	if count <= 0 then
		frame:ShowWindow(0);
	end
end

function ON_INGAMEALERT_ELEM_NO(parent, ctrl)
	INGAMEALERT_REMOVE_ELEM_BY_OBJECT(parent)
	INGAMEALERT_ALIGN_ELEM(parent:GetTopParentFrame())
	
	local scpNo = parent:GetUserValue("SCRIPT_NO")
	if scpNo ~= "None" then
		local func = _G[scpNo]
		func(parent)
	end
end

function ON_INGAMEALERT_ELEM_YES(parent, ctrl)
	INGAMEALERT_REMOVE_ELEM_BY_OBJECT(parent)
	INGAMEALERT_ALIGN_ELEM(parent:GetTopParentFrame())

	local scpYes = parent:GetUserValue("SCRIPT_YES")
	if scpYes ~= "None" then
		local func = _G[scpYes]
		func(parent)
	end
end

function INGAMEALERT_SHOW(frame, msg, argStr, argNum)
	local ctrlset = INGAMEALERT_GET_ELEM_BY_TYPE(frame, "Private")
	
	local text = GET_CHILD(ctrlset, "text")
	text:SetText(argStr)

	INGAMEALERT_RESIZE_ELEM(ctrlset)
	INGAMEALERT_SET_MARGIN_BY_CHAT_FRAME(frame)	
end

function ON_INDUN_ASK_PARTY_MATCH(frame, msg, argStr, argNum)
	local ctrlset = INGAMEALERT_GET_ELEM_BY_TYPE(frame, "Party")
	local argList = StringSplit(argStr, "/")
	if #argList ~= 2 then
		INGAMEALERT_REMOVE_ELEM_BY_OBJECT(ctrlset)
		INGAMEALERT_ALIGN_ELEM(frame)
		return
	end
	
	local text = GET_CHILD(ctrlset, "text")
	local askMsg = ScpArgMsg("PartyMatching", "MEMBER", argList[1], "INDUN", argList[2])
	text:SetText(askMsg)

	INGAMEALERT_RESIZE_ELEM(ctrlset)
	INGAMEALERT_SET_MARGIN_BY_CHAT_FRAME(frame)	
end

function ON_SOLD_ITEM_NOTICE(frame, msg, argStr, argNum)	
	local ctrlset = INGAMEALERT_GET_ELEM_BY_TYPE(frame, "SoldItem")
	local argList = StringSplit(argStr, "/")
	if #argList ~= 3 then
		INGAMEALERT_REMOVE_ELEM_BY_OBJECT(ctrlset)
		INGAMEALERT_ALIGN_ELEM(frame)
		return
	end

	local text = GET_CHILD(ctrlset, "text")
	local askMsg = ScpArgMsg("SoldItemNotice", "SELLER", argList[1], "ITEM", argList[2], "COUNT", argList[3])
	text:SetText(askMsg)

	INGAMEALERT_RESIZE_ELEM(ctrlset)
	INGAMEALERT_SET_MARGIN_BY_CHAT_FRAME(frame)
end

function ON_RECEIVABLE_SILVER_NOTICE(frame, msg, argStr, argNum)
	local ctrlset = INGAMEALERT_GET_ELEM_BY_TYPE(frame, "ReceivableSilver")
	
	local text = GET_CHILD(ctrlset, "text")
	local askMsg = ScpArgMsg("ReceivableSilverNotice")
	text:SetText(askMsg)

	INGAMEALERT_RESIZE_ELEM(ctrlset)
	INGAMEALERT_SET_MARGIN_BY_CHAT_FRAME(frame)
end

function ON_RECEIVABLE_TAX_PAYMENT_NOTICE(frame, msg, argStr, argNum)
	local ctrlset = INGAMEALERT_GET_ELEM_BY_TYPE(frame, "TaxPayment")
	
	local text = GET_CHILD(ctrlset, "text")
	local askMsg = ScpArgMsg("ColonyTaxPaymentReceivable")
	text:SetText(askMsg)
	
	INGAMEALERT_RESIZE_ELEM(ctrlset)
	INGAMEALERT_SET_MARGIN_BY_CHAT_FRAME(frame)
end

function INGAMEALERT_RESIZE_ELEM(ctrlset)
	AUTO_CAST(ctrlset)
	local text = GET_CHILD(ctrlset, "text")
	local yesBtn = GET_CHILD(ctrlset, "yesBtn")
	local noBtn = GET_CHILD(ctrlset, "noBtn")
	local textOffsetY = text:GetY() + text:GetHeight()
	local btnOffset = 0;
	if yesBtn:IsVisible() == 1 or noBtn:IsVisible() == 1 then
		btnOffset = math.max(yesBtn:GetHeight(), noBtn:GetHeight())
	end
	local MARGIN_BOTTOM = tonumber(ctrlset:GetUserConfig("MARGIN_BOTTOM"))
	ctrlset:Resize(ctrlset:GetOriginalWidth(), textOffsetY + btnOffset + MARGIN_BOTTOM)
end

function INGAMEALERT_TAX_PAYMENT_SCP_YES(ctrlset)
	ui.OpenFrame("colony_tax_payment")
end

function ON_FIELD_BOSS_WORLD_EVENT_RECEIVABLE_ITEM_NOTICE(frame, msg, argStr, argNum)
	local ctrlset = INGAMEALERT_GET_ELEM_BY_TYPE(frame, "WorldEventReceivableItem")
	
	local text = GET_CHILD(ctrlset, "text")
	local askMsg = ScpArgMsg("WorldEventReceivableItemNotice")
	text:SetText(askMsg)

	INGAMEALERT_RESIZE_ELEM(ctrlset)
	INGAMEALERT_SET_MARGIN_BY_CHAT_FRAME(frame)
end

function ON_FIELD_BOSS_WORLD_EVENT_RECEIVABLE_SILVER_NOTICE(frame, msg, argStr, argNum)
	local ctrlset = INGAMEALERT_GET_ELEM_BY_TYPE(frame, "WorldEventReceivableSilver")
	
	local text = GET_CHILD(ctrlset, "text")
	local askMsg = ScpArgMsg("WorldEventReceivableSilverNotice")
	text:SetText(askMsg)

	INGAMEALERT_RESIZE_ELEM(ctrlset)
	INGAMEALERT_SET_MARGIN_BY_CHAT_FRAME(frame)
end
