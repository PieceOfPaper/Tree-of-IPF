
function COMPANIONHIRE_ON_INIT(addon, frame)
	addon:RegisterMsg('BUY_SLOT', 'REQ_CHAR_SLOT_BUY');
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

function TRY_COMPANION_HIRE(byShop)
	local accountInfo = session.barrack.GetMyAccount();
	local petCnt = session.pet.GetPetTotalCount();
	local myCharCont = accountInfo:GetPCCount() + petCnt;
	local buySlot = session.loginInfo.GetBuySlotCount();
	local barrackCls = GetClass("BarrackMap", accountInfo:GetThemaName());

	if myCharCont >= barrackCls.MaxCashPC + barrackCls.BaseSlot then
		ui.SysMsg(ClMsg('CanCreateCharCuzMaxSlot')); -- 더 이상 구입할 슬롯이 없다는거
		return;
	end

	if myCharCont >= barrackCls.BaseSlot + buySlot then
		ui.SysMsg(ScpArgMsg("CurChar{CharCnt}CurSlot{SlotCnt}", "CharCnt", myCharCont, "SlotCnt", barrackCls.BaseSlot + buySlot));
		control.ReqCharSlotTPPrice();
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
		return;
	end
	if GET_TOTAL_MONEY() < sellPrice then
		ui.SysMsg(ClMsg('NotEnoughMoney'));
	else
		local scpString = string.format("EXEC_BUY_COMPANION(\"%s\", \"%s\")", clsName, nameText);
		ui.MsgBox(ScpArgMsg("ReallyBuyCompanion?"), scpString, "None");
	end
end

function TRY_CECK_BARRACK_SLOT_BY_COMPANION_EXCHANGE(select)
	local accountInfo = session.barrack.GetMyAccount();
	local petCnt = session.pet.GetPetTotalCount();
	local myCharCont = accountInfo:GetTotalSlotCount();
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

function EXEC_CANCLE_BUY_SLOT()
	local frame = ui.GetFrame("companionhire")
	frame:SetUserValue("EGG_GUID", 'None');
end

function TRY_CHECK_BARRACK_SLOT(handle, isAgit, byShop)
	local accountInfo = session.barrack.GetMyAccount();
	local myCharCont = accountInfo:GetTotalSlotCount();
	local buySlot = session.loginInfo.GetBuySlotCount();
	local barrackCls = GetClass("BarrackMap", accountInfo:GetThemaName());

	if myCharCont >= barrackCls.MaxCashPC + barrackCls.BaseSlot then
		ui.SysMsg(ClMsg('CanCreateCharCuzMaxSlot')); -- 구입할 슬롯이 없다는거
		return;
	end
	
	local isbutton = 1
	if 1 == tonumber(isAgit) then
		 isbutton = 0;
	end

	if myCharCont < barrackCls.BaseSlot + buySlot then
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
	else
		if nil == isAgit and nil ~= handle then
			local frame = ui.GetFrame("companionhire")
			if frame:GetUserValue("EGG_GUID") ~= 'None' then
				return;
			end
			frame:SetUserValue("EGG_GUID", handle:GetIESID());
		end

		if IS_SEASON_SERVER(nil) == "YES" then
			ui.SysMsg(ClMsg('SeasonServerNotBuySlot'));
			return;
		end

		control.ReqCharSlotTPPrice();
		return 0;
	end
end

function REQ_CHAR_SLOT_BUY(frame, msg, argStr, argNum)
	local str = ScpArgMsg('{TP}ReqSlotBuy', "TP", argNum);
	if nil == str then
		return;
	end

	if IS_SEASON_SERVER(nil) == "YES" then
		return;
	end

	local yesScp = string.format("control.ReqCharSlotToZone()");
	ui.MsgBox(ClMsg("DontHaveSlot")..str, yesScp, "EXEC_CANCLE_BUY_SLOT()");
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

