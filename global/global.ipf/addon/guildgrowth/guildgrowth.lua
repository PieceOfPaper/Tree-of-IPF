function DROP_GUILDGROWTH_TALT(parent, ctrl)

	local invItem = GET_DRAG_INVITEM_INFO();
	
	local itemName = GET_GUILD_EXPUP_ITEM_INFO();
	local dropItemCls = GetClassByType("Item", invItem.type);
	if dropItemCls.ClassName == 'misc_talt_event' then
        itemName = GET_GUILD_EXPUP_ITEM_INFO2();
	end

	local taltCls = GetClass("Item", itemName);

	if itemName ~= dropItemCls.ClassName then
		local text = ScpArgMsg("DropItem{Name}ForGuildExpUp", "Name", taltCls.Name);
		ui.SysMsg(text);
		return;
	end

	local frame = parent:GetTopParentFrame();
	INPUT_NUMBER_BOX(frame, ScpArgMsg("InputCount"), "EXEC_DROP_GUILDTALT", invItem.count, 1, invItem.count);
	frame:SetUserValue("IES_ID", invItem:GetIESID());
	

end