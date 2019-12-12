
function COLONY_TAX_BOARD_ON_INIT(addon, frame)
	addon:RegisterMsg('UPDATE_COLONY_TAX_CHEQUE_LIST', 'ON_UPDATE_COLONY_TAX_BOARD_CHEQUE_LIST');
	addon:RegisterMsg('UPDATE_COLONY_TAX_RATE_SET', 'ON_UPDATE_COLONY_TAX_BOARD_RATE_SET');
	addon:RegisterMsg('UPDATE_COLONY_TAX_HISTORY_LIST', 'ON_UPDATE_COLONY_TAX_HISTORY_LIST');
	addon:RegisterMsg('COLONY_TAX_CHEQUE_SEND_SUCCESS', 'ON_COLONY_TAX_CHEQUE_SEND_SUCCESS');
	addon:RegisterMsg('COLONY_TAX_CHEQUE_RECV', 'ON_COLONY_TAX_CHEQUE_RECV');
	addon:RegisterOpenOnlyMsg('UPDATE_COLONY_TAX_CHEQUE', 'ON_UPDATE_COLONY_TAX_CHEQUE');
end

function ON_OPEN_COLONY_TAX_BOARD(frame)
	local rewardboardUI = ui.GetFrame("colony_reward_board");
	if rewardboardUI ~= nil and rewardboardUI:IsVisible() == 1 then
		ui.CloseFrame("colony_reward_board");
	end

	local taxratewarning_text = GET_CHILD_RECURSIVELY(frame, "taxratewarning_text");
	local contents_text = GET_CHILD_RECURSIVELY(frame, "contents_text");
	local chequewarning_text = GET_CHILD_RECURSIVELY(frame, "chequewarning_text");
	local rateDetailMsg = ScpArgMsg("ColonyTaxRateDetail{Default}{Min}{Max}{ModifyDelay}{DisableModifyDelay1}{DisableModifyDelay2}", "Default", COLONY_TAX_RATE_DEFAULT, "Min", COLONY_TAX_RATE_MIN, "Max", COLONY_TAX_RATE_MAX, "ModifyDelay", (COLONY_TAX_RATE_MODIFY_AFTER_DELAY_MIN/60), "DisableModifyDelay1", (DISABLE_COLONY_TAX_RATE_MODIFY_DELAY_MIN/60), "DisableModifyDelay2", (COLONY_TAX_LORD_DEALY_MIN));
	local contentsDetailMsg = ScpArgMsg("ColonyTaxRateContents");
	local chequeDetailMsg = ScpArgMsg("ColonyTaxChequeDetail{TaxLoadDelay}{TaxDistributeTime}{TaxReceiveTime}", "TaxLoadDelay", (COLONY_TAX_DISTRIBUTE_DELAY_MIN/60), "TaxDistributeTime", (COLONY_TAX_DISTRIBUTE_PERIOD_MIN/1440), "TaxReceiveTime", (COLONY_TAX_RECEIVE_PERIOD_MIN/1440));

	taxratewarning_text:SetTextByKey("value", rateDetailMsg);
	contents_text:SetTextByKey("value", contentsDetailMsg);
	chequewarning_text:SetTextByKey("value", chequeDetailMsg);

	session.colonytax.ReqTaxChequeList();
	session.colonytax.ReqTaxHistoryList();

	local taxrate_list_gb = GET_CHILD_RECURSIVELY(frame, "taxrate_list_gb");
	CREATE_COLONY_TAX_RATE_LIST(taxrate_list_gb)
	local cheque_list_gb = GET_CHILD_RECURSIVELY(frame, "cheque_list_gb");
	CREATE_COLONY_TAX_CHEQUE_LIST(cheque_list_gb)
	local history_list_gb = GET_CHILD_RECURSIVELY(frame, "history_list_gb");
	CREATE_COLONY_TAX_HISTORY_LIST(history_list_gb)

	if session.colonytax.IsEnabledColonyTaxShop() ~= 1 then
		local maintab = GET_CHILD_RECURSIVELY(frame, "maintab");
		local maintab_cheque = maintab:GetIndexByName("maintab_cheque");
		local maintab_taxrate = maintab:GetIndexByName("maintab_taxrate");
		maintab:SelectTab(maintab_cheque);
		maintab:DeleteTab(maintab_taxrate);
	end
end

function ON_UPDATE_COLONY_TAX_BOARD_CHEQUE_LIST(frame, msg, strarg, numarg)
	local totalTaxStr = strarg;
	local cheque_list_gb = GET_CHILD_RECURSIVELY(frame, "cheque_list_gb");
	CREATE_COLONY_TAX_CHEQUE_LIST(cheque_list_gb)

	local distFrame = ui.GetFrame('colony_tax_distribute')	
	if distFrame:IsVisible() == 1 then
		UPDATE_COLONY_TAX_DISTRIBUTE_AMOUNT(distFrame)
	end
end

function ON_UPDATE_COLONY_TAX_HISTORY_LIST(frame, msg, argstr, argnum)
	local history_list_gb = GET_CHILD_RECURSIVELY(frame, "history_list_gb");
	CREATE_COLONY_TAX_HISTORY_LIST(history_list_gb)
end

function CREATE_COLONY_TAX_HISTORY_LIST(listgb)
	if listgb == nil then return; end
	listgb:RemoveAllChild();
	local height = ui.GetControlSetAttribute("colony_tax_cheque_history", "height");
	local count = session.colonytax.GetTaxHistoryCount();
	for i=0, count-1 do
		local historyInfo = session.colonytax.GetTaxHistoryByIndex(i);
		if historyInfo ~= nil then 
			local ctrlset = listgb:CreateOrGetControlSet("colony_tax_cheque_history", "history_" .. i, ui.LEFT, ui.TOP, 0, i*height, 0, 0);
			AUTO_CAST(ctrlset);
			FILL_COLONY_TAX_HISTORY_ELEM(ctrlset, historyInfo)
		end
	end
end

function GET_COLONY_TAX_HISTORY_COMMENT(commentType)
	if commentType == ColonyTax.SendStartTime then
		return ScpArgMsg("ColonyTaxHistory_SendStartTime")
	elseif commentType == ColonyTax.SendTime then
		return ScpArgMsg("ColonyTaxHistory_SendTime")
	end
	return ""
end

function FILL_COLONY_TAX_HISTORY_ELEM(ctrlset, historyInfo)
	local date_text = GET_CHILD_RECURSIVELY(ctrlset, "date_text");
	local sender_text = GET_CHILD_RECURSIVELY(ctrlset, "sender_text");
	local receiver_text = GET_CHILD_RECURSIVELY(ctrlset, "receiver_text");
	local amount_text = GET_CHILD_RECURSIVELY(ctrlset, "amount_text");
	local comment_text = GET_CHILD_RECURSIVELY(ctrlset, "comment_text");

	local date = historyInfo:GetTime()
	date_text:SetTextByKey("year", date.wYear)
	date_text:SetTextByKey("month", date.wMonth)
	date_text:SetTextByKey("day", date.wDay)

	sender_text:SetTextByKey("value", historyInfo:GetSender())
	receiver_text:SetTextByKey("value", historyInfo:GetReceiver())
	amount_text:SetTextByKey("value", GET_COMMAED_STRING(historyInfo:GetAmount()))
	comment_text:SetTextByKey("value", GET_COLONY_TAX_HISTORY_COMMENT(historyInfo:GetComment()))
	
end

function ON_UPDATE_COLONY_TAX_BOARD_RATE_SET(frame, msg, argstr, argnum)
	local taxrate_list_gb = GET_CHILD_RECURSIVELY(frame, "taxrate_list_gb");
	CREATE_COLONY_TAX_RATE_LIST(taxrate_list_gb)

	local taxRateInfo = session.colonytax.GetColonyTaxRate(argnum)
	if taxRateInfo == nil then
		return
	end

	local cityMapCls = GetClassByType("Map", argnum)
	if cityMapCls == nil then
		return;
	end
	
	local cityName = TryGetProp(cityMapCls, "Name")
    local rate = taxRateInfo:GetTaxRate()

    addon.BroadMsg("NOTICE_Dm_Global_Shout", ScpArgMsg("ColonyTaxModifiedNoticeMsg", "city", cityName, "rate", rate), 10)
    CHAT_SYSTEM("{#FF0000}" ..ScpArgMsg("ColonyTaxModifiedNoticeMsg", "city", cityName, "rate", rate).."{/}", "FFFF00")

end

function GET_COLONY_TAX_RATE_INDEX_LIST()
	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil or pcparty.info == nil then
		return {};
	end

	local cnt = session.colonytax.GetTaxRateCount();
	local list = {}
	for i=0, cnt-1 do
		local taxRateInfo = session.colonytax.GetTaxRateByIndex(i);
		if taxRateInfo ~= nil then 
			if pcparty.info:GetPartyID() == taxRateInfo:GetGuildID() then
				list[#list+1] = i;
			end
		end
	end
	return list;
end

function CREATE_COLONY_TAX_RATE_LIST(listgb)
	local frame = listgb:GetTopParentFrame()
	listgb:RemoveAllChild();

	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil or pcparty.info == nil then
		return;
	end

	local list = GET_COLONY_TAX_RATE_INDEX_LIST();
	local SKIN_ODD = frame:GetUserConfig("SKIN_ODD")
	local SKIN_EVEN = frame:GetUserConfig("SKIN_EVEN")
	local width = ui.GetControlSetAttribute("colony_tax_rate_elem", "width")
	local height = ui.GetControlSetAttribute("colony_tax_rate_elem", "height")
	SET_COLONY_TAX_RATE_LIST_SKIN(listgb, width, height, #list, SKIN_ODD, SKIN_EVEN)

	local firstLeagueList = {};
	for i = 1, #list do
		local index = list[i];
		local taxRateInfo = session.colonytax.GetTaxRateByIndex(index);
		if taxRateInfo ~= nil then 
			local cityMapID = taxRateInfo:GetCityMapID();
            local cityMapCls = GetClassByType("Map", cityMapID);
            local colonyCls = GetClassByStrProp("guild_colony", "TaxApplyCity", cityMapCls.ClassName);
			local colonyLeague = TryGetProp(colonyCls, "ColonyLeague");
			if colonyLeague == 1 then
				firstLeagueList[#firstLeagueList + 1] = taxRateInfo;
			end
		end
	end

	for i = 1, #firstLeagueList do
		local taxRateInfo = firstLeagueList[i];
		if taxRateInfo ~= nil then
			local cityMapID = taxRateInfo:GetCityMapID();
			local ctrlset = listgb:CreateOrGetControlSet("colony_tax_rate_elem", "tax_rate_" .. i, ui.LEFT, ui.TOP, 0, (i-1)*height, 0, 0);
			AUTO_CAST(ctrlset);
			ctrlset:SetUserValue("CityMapID", cityMapID);
			FILL_COLONY_TAX_RATE_ELEM(ctrlset, taxRateInfo)
		end
	end
end

function FILL_COLONY_TAX_RATE_ELEM(ctrlset, taxRateInfo)
	local citymap_text = GET_CHILD_RECURSIVELY(ctrlset, "citymap_text");
	local colonymap_text = GET_CHILD_RECURSIVELY(ctrlset, "colonymap_text");
	local rate_edit = GET_CHILD_RECURSIVELY(ctrlset, "rate_edit");

	local cityMapID = taxRateInfo:GetCityMapID();
	local colonyMapID = taxRateInfo:GetColonyMapID();
	local taxRate = taxRateInfo:GetTaxRate();

	citymap_text:SetTextByKey("value", TryGetProp(GetClassByType("Map", cityMapID), "Name"))
	colonymap_text:SetTextByKey("value", TryGetProp(GetClassByType("Map", colonyMapID), "Name"))
    rate_edit:SetText(taxRate);

	rate_edit:SetMinNumber(GetColonyTaxRateMin());
	rate_edit:SetMaxNumber(GetColonyTaxRateMax());
end

function ON_COLONY_TAX_RATE_TYPE(parent, editctrl)
	local cityMapID = parent:GetUserValue("CityMapID");
end

function ON_COLONY_TAX_RATE_DOWN(parent, ctrl)
	local rate_edit = GET_CHILD_RECURSIVELY(parent, "rate_edit");
	local rate = tonumber(rate_edit:GetText());
	if rate ~= nil then
		rate = rate - 1;
	else
		rate = COLONY_TAX_RATE_DEFAULT;
	end
	if rate <= GetColonyTaxRateMin() then
	    rate = GetColonyTaxRateMin()
	end
	rate_edit:SetText(rate)
end

function ON_COLONY_TAX_RATE_UP(parent, ctrl)
	local rate_edit = GET_CHILD_RECURSIVELY(parent, "rate_edit");
	local rate = tonumber(rate_edit:GetText());
	if rate ~= nil then
		rate = rate + 1;
	else
		rate = COLONY_TAX_RATE_DEFAULT;
	end
	if rate >= GetColonyTaxRateMax() then
	    rate = GetColonyTaxRateMax()
	end
	rate_edit:SetText(rate)
end

function ON_COMMIT_COLONY_TAX_RATE(parent, ctrl)
	local ctrlset = parent:GetAboveControlset();
	local rate_edit = GET_CHILD_RECURSIVELY(parent, "rate_edit");
	local cityMapID = ctrlset:GetUserIValue("CityMapID");
	local rate = tonumber(rate_edit:GetText());
	if rate == nil then
		return;
	end
	session.colonytax.ReqTaxRateSet(cityMapID, rate);
end
-------------------
function CREATE_COLONY_TAX_CHEQUE_LIST(listgb)
	if listgb == nil then return; end
	listgb:RemoveAllChild();

	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil or pcparty.info == nil then
		return;
	end

	local firstLeagueList = {};
	local height = ui.GetControlSetAttribute("colony_tax_cheque_elem", "height")
	local cnt = session.colonytax.GetTaxChequeCount();
	for i = 0, cnt - 1 do
		local chequeInfo = session.colonytax.GetTaxChequeByIndex(i);
		if chequeInfo ~= nil then 
			local cityMapID = chequeInfo:GetCityMapID();
			local cityMapCls = GetClassByType("Map", cityMapID);
            local colonyCls = GetClassByStrProp("guild_colony", "TaxApplyCity", cityMapCls.ClassName);
			local colonyLeague = TryGetProp(colonyCls, "ColonyLeague");
			if colonyLeague == 1 then
				firstLeagueList[#firstLeagueList + 1] = chequeInfo;
			end
		end
	end

	for i = 0, #firstLeagueList - 1 do
		local chequeInfo = firstLeagueList[i + 1];
		if chequeInfo ~= nil then
			local ctrlset = listgb:CreateOrGetControlSet("colony_tax_cheque_elem", "tax_cheque_" .. i, ui.LEFT, ui.TOP, 0, i * height, 0, 0);
			AUTO_CAST(ctrlset);

			local criterionTime = imcTime.GetStringSysTime(chequeInfo:GetCriterionTime())
			ctrlset:SetUserValue("CriterionTime", criterionTime);
			local cityMapID = chequeInfo:GetCityMapID();
			ctrlset:SetUserValue("CityMapID", cityMapID);
			FILL_COLONY_TAX_CHEQUE_ELEM(ctrlset, chequeInfo);
		end
	end
end

function FILL_COLONY_TAX_CHEQUE_ELEM(ctrlset, chequeInfo)
	local date_text = GET_CHILD_RECURSIVELY(ctrlset, "date_text");
	local colonymap_text = GET_CHILD_RECURSIVELY(ctrlset, "colonymap_text")
	local citymap_text = GET_CHILD_RECURSIVELY(ctrlset, "citymap_text")
	local expire_text = GET_CHILD_RECURSIVELY(ctrlset, "expire_text")
	local taxamount_text = GET_CHILD_RECURSIVELY(ctrlset, "taxamount_text")
	local recv_btn = GET_CHILD_RECURSIVELY(ctrlset, "recv_btn")

	local cityAmount = chequeInfo:GetCityAmount();
	local marketAmount = chequeInfo:GetMarketAmount();
	local sentAmount = chequeInfo:GetSentAmount();
	local totalAmount = SumForBigNumberInt64(cityAmount, marketAmount);
	local remainAmount = SumForBigNumberInt64(totalAmount, '-'..sentAmount);
	cityAmount = GET_COMMAED_STRING(cityAmount)
	marketAmount = GET_COMMAED_STRING(marketAmount)
	remainAmount = GET_COMMAED_STRING(remainAmount)
	totalAmount = GET_COMMAED_STRING(totalAmount)
	local cityMapID = chequeInfo:GetCityMapID();
	local colonyMapID = chequeInfo:GetColonyMapID();
	local provideTime = chequeInfo:GetProvideTime();
	local endTime = chequeInfo:GetEndTime();
	local remainSec = imcTime.GetDifSec(endTime, geTime.GetServerSystemTime());
	local remainTimeStr = GET_COLONY_TAX_EXPIRE_TEXT(remainSec)

	date_text:SetTextByKey("year", provideTime.wYear);
	date_text:SetTextByKey("month", provideTime.wMonth);
	date_text:SetTextByKey("day", provideTime.wDay);

	colonymap_text:SetTextByKey("value", TryGetProp(GetClassByType("Map", colonyMapID), "Name"));
	citymap_text:SetTextByKey("value", TryGetProp(GetClassByType("Map", cityMapID), "Name"));
	expire_text:SetTextByKey("value", remainTimeStr)
	taxamount_text:SetTextByKey("value", remainAmount);
	
	local taxAmountText = ScpArgMsg('ColonyTaxCollectedDate{Year}{Month}{Day}', 'Year', provideTime.wYear, 'Month', provideTime.wMonth, 'Day', provideTime.wDay)
	taxAmountText = taxAmountText .. '{nl}' .. ScpArgMsg('ColonyTaxCollectedMarket{Amount}', 'Amount', marketAmount)
	taxAmountText = taxAmountText .. '{nl}' .. ScpArgMsg('ColonyTaxCollectedCity{Amount}', 'Amount', cityAmount)
	taxAmountText = taxAmountText .. '{nl}' .. ScpArgMsg('ColonyTaxCollectedTotal{Amount}', 'Amount', totalAmount)

	taxamount_text:SetTextTooltip(taxAmountText);
end

function REQ_COLONY_TAX_CHEQUE_PAY(parent, ctrl)
	parent = parent:GetParent();
	parent = parent:GetParent();
	local criterionTime = parent:GetUserValue("CriterionTime")
	local cityMapID = parent:GetUserValue("CityMapID")
	local chequeInfo = session.colonytax.GetTaxCheque(imcTime.GetSysTimeByStr(criterionTime), cityMapID)
	if chequeInfo == nil then
		return;
	end

	local cityAmount = chequeInfo:GetCityAmount();
	local marketAmount = chequeInfo:GetMarketAmount();
	local sentAmount = chequeInfo:GetSentAmount();
	local totalAmount = SumForBigNumberInt64(cityAmount, marketAmount);
	local remainAmount = SumForBigNumberInt64(totalAmount, '-'..sentAmount);
	if 1 ~= IsGreaterThanForBigNumber(remainAmount, 0) then
		ui.SysMsg(ClMsg("ColonyTax_ChequeExhausted"));
		return;
	end

	ui.CloseFrame("colony_tax_distribute")
	
	local frame = ui.GetFrame("colony_tax_distribute");
	frame:SetUserValue("CriterionTime", criterionTime);
	frame:SetUserValue("CityMapID", cityMapID);
	ui.OpenFrame("colony_tax_distribute")
end

function ON_COLONY_TAX_CHEQUE_SEND_SUCCESS(frame, msg, argstr, argnum)
	ui.SysMsg(ScpArgMsg("ColonyTax_Cheque_SendSuccess"));
end

function ON_COLONY_TAX_CHEQUE_RECV(frame, msg, argstr, argnum)
    argstr = GET_COMMAED_STRING(argstr);
	ui.SysMsg(ScpArgMsg("ColonyTax_Cheque_Recv{Tax}", "Tax", argstr));
	session.colonytax.ReqTaxPaymentList();
end

function ON_UPDATE_COLONY_TAX_CHEQUE(frame, msg, argstr, argnum)
	if frame:IsVisible() == 1 then
		ON_OPEN_COLONY_TAX_BOARD(frame)
		session.colonytax.ReqTaxHistoryList();
	end
end
