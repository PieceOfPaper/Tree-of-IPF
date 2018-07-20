function GUILDWAREHOUSE_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg("GUILD_WAREHOUSE_ITEM_LIST", "ON_GUILD_WAREHOUSE_ITEM_LIST");
	addon:RegisterMsg("GUILD_WAREHOUSE_ITEM_ADD", "ON_GUILD_WAREHOUSE_ITEM_LIST");
	

end

function GUILDWAREHOUSE_OPEN(frame)
	
	party.RequestLoadInventory(PARTY_GUILD);
end
   
function GUILDWAREHOUSE_CLOSE(frame)
	TRADE_DIALOG_CLOSE();
end

function TOGGLE_GUILD_WAREHOUSE()

	ui.ToggleFrame("guildwarehouse");

end

function GUILDWAREHOUSE_REFRESH_BTN(frame, ctrl)
	party.RequestReloadInventory(PARTY_GUILD);
	DISABLE_BUTTON_DOUBLECLICK("guildwarehouse",ctrl:GetName());
end

function ON_GUILD_WAREHOUSE_ITEM_LIST(frame)
	local gbox = frame:GetChild("gbox");
	local slotset = GET_CHILD(gbox, "slotset");
	UPDATE_ETC_ITEM_SLOTSET(slotset, IT_GUILD, "guildwarehouse");

end

function RBTN_GUILDWAREHOUSE(parent, ctrl)

	local isLeader = AM_I_LEADER(PARTY_GUILD);
	if isLeader == 0 then
		return;
	end
	
	local slot = AUTO_CAST(ctrl);
	local icon = slot:GetIcon();
	if icon == nil then
		return;
	end
	local iconInfo = icon:GetInfo();
	local iesID = iconInfo:GetIESID();
	local invItem = session.GetEtcItemByGuid(IT_GUILD, iesID);
	if invItem == nil then
		return;
	end

	local itemObj = GetIES(invItem:GetObject());
	local frame = ui.GetFrame("guildware_itemgive");
	local txt_itemname = frame:GetChild("txt_itemname");
	local slot_item = GET_CHILD(frame, "slot_item");
	local numupdown = GET_CHILD(frame, "numupdown");
	txt_itemname:SetTextByKey("value", GET_FULL_NAME(itemObj));
	SET_SLOT_ITEM_OBJ(slot_item, itemObj);

	local icon = slot_item:GetIcon();
	SET_ITEM_TOOLTIP_TYPE(icon, itemObj.ClassID, itemObj);
	icon:SetTooltipArg("guildwarehouse", invItem.type, invItem:GetIESID());

	numupdown:SetMinValue(1);
	numupdown:SetMaxValue(invItem.count);
	numupdown:SetNumberValue(invItem.count);
	

	frame:SetUserValue("ITEM_ID", iesID);
	local txt = frame:GetChild("txt");
	txt:SetTextByKey("value", ScpArgMsg("SelectGuildMemberToGetItem"));
	local gbox_charlist = frame:GetChild("gbox_charlist");
	gbox_charlist:RemoveAllChild();
	frame:SetUserValue("EXECSCRIPT", "EXEC_GIVEITEM_TO_GUILDMEMBER");

	local list = session.party.GetPartyMemberList(PARTY_GUILD);
	local count = list:Count();
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);
		local ctrlSet = gbox_charlist:CreateControlSet("guildware_itemget", "PIC_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, 0);
		ctrlSet:SetUserValue("AID", partyMemberInfo:GetAID());
		ctrlSet:SetOverSound('button_cursor_over_3');
		ctrlSet:SetClickSound('button_click_big');
		local jobIcon = GET_JOB_ICON(partyMemberInfo:GetIconInfo().job)
		local pic = GET_CHILD(ctrlSet, "pic");
		pic:SetImage(jobIcon);
		pic:ShowWindow(0);
		local name = GET_CHILD(ctrlSet, "name");
		name:SetTextByKey("value", partyMemberInfo:GetName());
		ctrlSet:ShowWindow(1);

		ctrlSet:SetEventScript(ui.LBUTTONUP, "MSGBOX_GIVEITEM_TO_GUILDMEMBER");
		ctrlSet:EnableHitTest(1);
	end

	GBOX_AUTO_ALIGN(gbox_charlist, 0, 1, 0, true, false);
	frame:ShowWindow(1);

end


function MSGBOX_GIVEITEM_TO_GUILDMEMBER(parent, ctrl)

	local aid = ctrl:GetUserValue("AID");
	local memberInfo = session.party.GetPartyMemberInfoByAID(PARTY_GUILD, aid);
	if memberInfo == nil then
		return;
	end

	local msgBoxString = ScpArgMsg("ReallyGiveItemTo{PC}", "PC", memberInfo:GetName());
	local frame = parent:GetTopParentFrame();
	local iesID = frame:GetUserValue("ITEM_ID");
	local numupdown = GET_CHILD(frame, "numupdown");
	local count = numupdown:GetNumber();
	local execScript = frame:GetUserValue("EXECSCRIPT");
	local scpString = string.format("%s(\"%s\", \"%s\", %d)", execScript, aid, iesID, count);
	ui.MsgBox(msgBoxString, scpString, "None");

end

function EXEC_GIVEITEM_TO_GUILDMEMBER(aid, iesID, count)	
end