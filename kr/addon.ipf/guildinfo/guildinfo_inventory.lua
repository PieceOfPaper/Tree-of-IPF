function GUILDINFO_INVENTORY_DEPOSIT_CLICK(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local balanceEdit = GET_CHILD_RECURSIVELY(topFrame, 'balanceEdit');
    local depositMoney = GET_NOT_COMMAED_NUMBER(balanceEdit:GetText());
    local myMoney = GET_TOTAL_MONEY();
    if depositMoney > myMoney or myMoney < 1 then
        ui.SysMsg(ClMsg('Auto_SilBeoKa_BuJogHapNiDa.'));
        return;
    end

	local guild = session.party.GetPartyInfo(PARTY_GUILD);
	if guild == nil then
		return;
	end

	local guildObj = GET_MY_GUILD_OBJECT();
	local nowGuildAsset = TryGetProp(guildObj, "GuildAsset");
	if nowGuildAsset == nil then
		return;
	end
    if nowGuildAsset == 'None' then
        nowGuildAsset = 0;
    end
    local sumStr = SumForBigNumber(depositMoney, nowGuildAsset);    
	if IsGreaterThanForBigNumber(sumStr, MONEY_MAX_STACK) == 1 then
		ui.SysMsg(ScpArgMsg("Money{MAX}OverAtAcc", "MAX", GET_COMMAED_STRING(MONEY_MAX_STACK)));
		return;
	end

    control.CustomCommand('DEPOSIT_GUILD_ASSET', depositMoney);
    balanceEdit:SetText('0');
end

function GUILDINFO_INVEN_INIT(parent, invenBox)
    local logCount = session.guildState.GetGuildAssetLogCount();
    if logCount == 0 then
        ON_GUILD_ASSET_LOG(parent);
    end

    session.guildState.ReqGuildAssetLog();
    party.RequestLoadInventory(PARTY_GUILD);
    ui.CloseFrame('guild_authority_popup');
end

function GUILDINFO_INVEN_UPDATE_INVENTORY(frame, msg, argStr, argNum)
    local slotset = GET_CHILD_RECURSIVELY(frame, 'itemSlotset');
    slotset:ClearIconAll();

	local itemList = session.GetEtcItemList(IT_GUILD);
	local index = itemList:Head();			
	while itemList:InvalidIndex() ~= index do
		local invItem = itemList:Element(index);
		local slot = slotset:GetSlotByIndex(invItem.invIndex);
		if slot == nil then
			slot = GET_EMPTY_SLOT(slotset);
		end
		local itemCls = GetIES(invItem:GetObject());
		local iconImg = GET_ITEM_ICON_IMAGE(itemCls);
		
		SET_SLOT_IMG(slot, iconImg)
		SET_SLOT_COUNT(slot, invItem.count)
		SET_SLOT_COUNT_TEXT(slot, invItem.count);
		SET_SLOT_IESID(slot, invItem:GetIESID())
        SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, itemCls, nil)
		slot:SetMaxSelectCount(invItem.count);
		local icon = slot:GetIcon();
		icon:SetTooltipArg('guildinfo', invItem.type, invItem:GetIESID());
        icon:SetTooltipOverlap(1);
        SET_ITEM_TOOLTIP_TYPE(icon, itemCls.ClassID, itemCls, 'guildinfo');

        slot:SetUserValue('ITEM_CLASS_NAME', itemCls.ClassName);        
        slot:SetUserValue('ITEM_COUNT', invItem.count);
        slot:SetUserValue('ITEM_ID', invItem:GetIESID());
        slot:SetEventScript(ui.LBUTTONUP, 'GUILDINFO_INVEN_ITEM_CLICK');        

		index = itemList:Next(index);
	end
end

function GUILDINFO_INVEN_ITEM_CLICK(parent, slot)
    local isLeader = AM_I_LEADER(PARTY_GUILD);
	if 0 == isLeader then
		ui.SysMsg(ScpArgMsg("OnlyLeaderAbleToDoThis"));
		return;
	end

    local itemClassName = slot:GetUserValue('ITEM_CLASS_NAME');
    local itemCount = slot:GetUserIValue('ITEM_COUNT');
    local itemID = slot:GetUserValue('ITEM_ID');
    GUILDINVEN_SEND_INIT(itemClassName, itemCount, itemID);
end

function ON_GUILD_ASSET_LOG(frame, msg, argStr, argNum)
    local logBox = GET_CHILD_RECURSIVELY(frame, 'logBox');
    logBox:RemoveAllChild();

    local logCount = session.guildState.GetGuildAssetLogCount();
    for i = 0, logCount - 1 do
        local guildLog = session.guildState.GetGuildAssetLogByIndex(i);
        if guildLog ~= nil then
            local ctrlSet = logBox:CreateOrGetControlSet('guild_asset_log', 'ASSET_LOG_'..i, 0, 0);
            ctrlSet = AUTO_CAST(ctrlSet);

            local line = ctrlSet:GetChild('line');
            if i == 0 then -- 첫번째는 라인 안그려줌
                line:ShowWindow(0);
            end

            local dateText = ctrlSet:GetChild('dateText');
            local regTime = imcTime.ImcTimeToSysTime(guildLog.registerTime);
            local dateStr = string.format('%04d/%02d/%02d', regTime.wYear, regTime.wMonth, regTime.wDay); -- yyyy/mm/dd
            dateText:SetTextByKey('date', dateStr);

            local DEPOSIT_IMG = ctrlSet:GetUserConfig('DEPOSIT_IMG');
            local WITHDRAW_IMG = ctrlSet:GetUserConfig('WITHDRAW_IMG');
            local depositText = ctrlSet:GetChild('depositText');
            local useText = ctrlSet:GetChild('useText');
            local descText = ctrlSet:GetChild('descText');
            if guildLog.isDeposit == true then
                dateText:SetTextByKey('img', DEPOSIT_IMG);
                depositText:SetTextByKey('amount', GET_COMMAED_STRING(guildLog:GetAmount()));
                useText:ShowWindow(0);

                local desc = guildLog:GetDesc();
                local text = desc;
                if desc == 'Neutrality' or desc == 'ColonyReward' or desc == 'EmblemChange' then                
                    text = ClMsg('GuildAssetLog_'..desc);
                end
                descText:SetText(text);
            else
                dateText:SetTextByKey('img', WITHDRAW_IMG);
                depositText:ShowWindow(0);
                useText:SetTextByKey('amount', GET_COMMAED_STRING(guildLog:GetAmount()));
                descText:SetText(ClMsg('GuildAssetLog_'..guildLog:GetDesc()));
            end

            local balanceText = ctrlSet:GetChild('balanceText');
            balanceText:SetTextByKey('amount', GET_COMMAED_STRING(guildLog:GetTotalAmount()));
        end
    end
    GBOX_AUTO_ALIGN(logBox, 0, 0, 0, true, false);
    logBox:SetScrollPos(logBox:GetHeight());

    GUILDINFO_PROFILE_INIT_ASSET(frame);
end