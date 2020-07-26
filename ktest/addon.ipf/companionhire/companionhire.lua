function COMPANIONHIRE_ON_INIT(addon, frame)
end

function OPEN_COMPANION_HIRE(clsName)
	
	local frame = ui.GetFrame("companionhire");
	frame:ShowWindow(1);

	frame:SetUserValue("CLSNAME", clsName);
	local cls = GetClass("Companion", clsName);
	
	local input = frame:GetChild("input");
	input:SetText("");

	local price = frame:GetChild("price");
	local sellPrice = cls.SellPrice;
	if sellPrice ~= "None" then
		sellPrice = _G[sellPrice];
		sellPrice = sellPrice(cls, pc);
		price:SetTextByKey("value", GET_MONEY_IMG(24) .. " " .. GetCommaedText(sellPrice));
	else
		price:SetTextByKey("value", "");
	end

	local monCls = GetClass("Monster", clsName);
	local pic = GET_CHILD(frame ,"pic", "ui::CPicture");
	pic:SetImage(monCls.Icon);
	
	local petname = frame:GetChild("petname");
	petname:SetTextByKey("value", monCls.Name);
end

function EXEC_BUY_CHARACTER_SLOT()
	local buySlot = session.loginInfo.GetBuySlotCount();
	local clmsg = ScpArgMsg("CurChar{CharCnt}CurSlot{SlotCnt}", "SlotCnt", GET_MY_AVAILABLE_CHARACTER_SLOT());
	local yesscp = "control.CustomCommand('BUY_CHARACTER_SLOT', 0)";
	ui.MsgBox(clmsg..'{nl}'..ScpArgMsg('{TP}ReqSlotBuy', 'TP', GetBarrackSlotPrice(session.loginInfo.GetPremiumState())), yesscp, 'None');
end

function TRY_COMPANION_HIRE(byShop)
	local accountInfo = session.barrack.GetMyAccount();	
	local barrackCls = GetClass("BarrackMap", accountInfo:GetThemaName());
	local myCharCont = accountInfo:GetPCCount();
	if myCharCont >= barrackCls.MaxCashPC + barrackCls.BaseSlot then
		ui.SysMsg(ClMsg('CanCreateCharCuzMaxSlot')); -- 구입할 슬롯이 없다는거
		return;
	end

	local petCnt = session.pet.GetPetTotalCount();
	local availableSlotCnt = GET_MY_AVAILABLE_CHARACTER_SLOT();
	if petCnt >= availableSlotCnt then
		EXEC_BUY_CHARACTER_SLOT();
		return;
	end

	-- 슬롯 산다는거
	local frame = ui.GetFrame("companionhire");
	if byShop == true then
		frame = ui.GetFrame('companionshop');
	end
	local eggGuid = frame:GetUserValue("EGG_GUID");

	if "None" ~= eggGuid  then
		pc.ReqExecuteTx_Item("SCR_USE_EGG_COMPANION", eggGuid);
		frame:SetUserValue("EGG_GUID", 'None');
		return;
	end

	local clsName = frame:GetUserValue("CLSNAME");
	local exchange = frame:GetUserIValue("EXCHANGE_TIKET");
	if 0 < exchange then
		frame:SetUserValue("EXCHANGE_TIKET", 0);
		TRY_CECK_BARRACK_SLOT_BY_COMPANION_EXCHANGE(exchange);
		return;
	end

	local cls = GetClass("Companion", clsName);
	if cls == nil then
		return;
	end
	local sellPrice = cls.SellPrice;
	if sellPrice == "None" then
		return;
	end

	sellPrice = _G[sellPrice];
	sellPrice = sellPrice(cls, pc);

	local name = nil;
	local nameText = nil;
	if byShop == true then
		name = GET_CHILD_RECURSIVELY(frame, 'compaNameEdit');
		nameText = name:GetText();
	else
		name = frame:GetChild("input");
		nameText = name:GetText();
	end

	if name == nil or nameText == nil then -- companionhire 또는 companionshop을 통하지 않은 경우
		return;
	end

	if string.find(nameText, ' ') ~= nil then
		ui.SysMsg(ClMsg("NameCannotIncludeSpace"));
		return;
	end

	if ui.IsValidCharacterName(nameText) == false then
		SysMsg(self, 'Instant', ScpArgMsg('CompanionNameIsInvalid'))
		return;
	end
	if IsGreaterThanForBigNumber(sellPrice, GET_TOTAL_MONEY_STR()) == 1 then
		ui.SysMsg(ClMsg('NotEnoughMoney'));
	else
		local scpString = string.format("EXEC_BUY_COMPANION(\"%s\", \"%s\")", clsName, nameText);
		ui.MsgBox(ScpArgMsg("ReallyBuyCompanion?"), scpString, "None");
	end
end

function GET_MY_AVAILABLE_CHARACTER_SLOT()
	local accountInfo = session.barrack.GetMyAccount();	
	local barrackCls = GetClass("BarrackMap", accountInfo:GetThemaName());
	local buySlot = session.loginInfo.GetBuySlotCount();
	return barrackCls.BaseSlot + buySlot;
end

function TRY_CECK_BARRACK_SLOT_BY_COMPANION_EXCHANGE(select)
	local petCnt = session.pet.GetPetTotalCount();
	local availableSlotCnt = GET_MY_AVAILABLE_CHARACTER_SLOT();
	if petCnt >= availableSlotCnt then
		local frame = ui.GetFrame("companionhire");
		frame:SetUserValue("EXCHANGE_TIKET", select);
		EXEC_BUY_CHARACTER_SLOT();
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
		itemCls = GetClass('Item', 'JOB_HOGLAN_COUPON')
		local item = session.GetInvItemByName("JOB_HOGLAN_COUPON");
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

function TRY_CHECK_BARRACK_SLOT(handle, isAgit, byShop)	
	local accountInfo = session.barrack.GetMyAccount();	
	local barrackCls = GetClass("BarrackMap", accountInfo:GetThemaName());
	local myCharCont = accountInfo:GetPCCount();
	if myCharCont >= barrackCls.MaxCashPC + barrackCls.BaseSlot then
		ui.SysMsg(ClMsg('CanCreateCharCuzMaxSlot')); -- 구입할 슬롯이 없다는거
		return;
	end
	
	local petCnt = session.pet.GetPetTotalCount();
	local availableSlotCnt = GET_MY_AVAILABLE_CHARACTER_SLOT();
	if petCnt >= availableSlotCnt then
		EXEC_BUY_CHARACTER_SLOT();
		return;
	end

	local isbutton = 1
	if 1 == tonumber(isAgit) then
		 isbutton = 0;
	end

	if nil == isAgit or 1 == isbutton then
		if nil ~= handle and nil == isAgit then
			local frame = ui.GetFrame("companionhire")
			if frame:GetUserValue("EGG_GUID") ~= 'None' then
				return;
			end
			frame:SetUserValue("EGG_GUID", handle:GetIESID());
		end
		TRY_COMPANION_HIRE(byShop);
		return 1;
	else
		GUILD_SEND_CLICK_TRIGGER(handle);
		return 1;
	end
	return 0;
end

function EXEC_BUY_COMPANION(clsName, inputName)
	local petCls = GetClass("Companion", clsName);
	local scpString = string.format("/pethire %d %s",  petCls.ClassID, inputName);
	ui.Chat(scpString);
end

function PET_ADOPT_SUC()
	ui.CloseFrame("companionhire");
	ui.CloseFrame("companionshop");

	ui.SysMsg(ClMsg("CompanionAdoptionSuccess"));

	local frame = ui.GetFrame("companionhire")
	frame:SetUserValue("EGG_GUID", 'None');
end

function PET_ADOPT_SUC_BARRACK()
	ui.CloseFrame("companionhire");
	ui.CloseFrame("companionshop");

	ui.SysMsg(ClMsg("CompanionAdoptionSuccessBarrack"));

	local frame = ui.GetFrame("companionhire")
	frame:SetUserValue("EGG_GUID", 'None');
end

function PET_ADOPT_FAIL()
	ui.CloseFrame("companionhire");
	ui.CloseFrame("companionshop");

	ui.SysMsg(ClMsg("HasFobiddenWord"));

	local frame = ui.GetFrame("companionhire")
	frame:SetUserValue("EGG_GUID", 'None');
end

