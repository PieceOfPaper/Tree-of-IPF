
function TRY_CECK_BARRACK_SLOT_BY_COMPANION_EXCHANGE(select)
	
	local accountInfo = session.barrack.GetMyAccount();
	local petCnt = session.pet.GetPetTotalCount();
	local myCharCont = accountInfo:GetPCCount() + petCnt;
	local buySlot = session.loginInfo.GetBuySlotCount();
	local barrackCls = GetClass("BarrackMap", accountInfo:GetThemaName());
	
	if myCharCont > barrackCls.MaxCashPC + barrackCls.BaseSlot then
		ui.SysMsg(ClMsg('CanCreateCharCuzMaxSlot')); -- 구입할 슬롯이 없다는거
		return;
	end

		-- 슬롯 산다는거
	if myCharCont >= barrackCls.BaseSlot + buySlot then
		local frame = ui.GetFrame("companionhire");
		frame:SetUserValue("EXCHANGE_TIKET", select);
		control.ReqCharSlotTPPrice();
		return;
	end

	local itemIES = "None"
	local itemCls = nil;
	
	if 1 == select then
		itemCls = GetClass('Item', 'JOB_VELHIDER_COUPON')
		local item = session.GetInvItemByName("JOB_VELHIDER_COUPON");
		if nil == item then
			return;
		end
		itemIES = item:GetIESID();
	elseif 2 == select then
		itemCls = GetClass('Item', 'JOB_HAWK_COUPON')
		local item = session.GetInvItemByName("JOB_HAWK_COUPON");
		if nil == item then
			return;
		end
		itemIES = item:GetIESID();
	elseif 3 == select then
		itemCls = GetClass('Item', 'steam_JOB_HOGLAN_COUPON')
		local item = session.GetInvItemByName("steam_JOB_HOGLAN_COUPON");
		if nil == item then
			return;
		end
		itemIES = item:GetIESID();
	end

	if nil == itemCls then
		return;
	end

	local monCls =	GetClass("Monster", itemCls.StringArg);
	local argList = string.format("%d", monCls.ClassID);
	pc.ReqExecuteTx_Item("SCR_USE_ITEM_COMPANION", itemIES, argList);
end
