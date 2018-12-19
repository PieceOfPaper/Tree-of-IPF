
function COLONY_TAX_DISTRIBUTE_ON_INIT(addon, frame)
end

function CREATE_COLONY_TAX_DISTRIBUTE_GUILD_MEMBER_LIST(frame)
	local receiverlist_gb = GET_CHILD_RECURSIVELY(frame, "receiverlist_gb")
	receiverlist_gb:RemoveAllChild()

	local partyMemberList = session.party.GetPartyMemberList(PARTY_GUILD)
	if partyMemberList ~= nil then
		local count = partyMemberList:Count()
		for i = 0 , count - 1 do
			local info = partyMemberList:Element(i)
			local aid = info:GetAID()
			local name = info:GetName()
			local ctrlset = receiverlist_gb:CreateOrGetControlSet("colony_tax_distribute_team", "team_"..(i+1), 0, 0)
			ctrlset:SetUserValue("Type", "TeamCtrl")
			ctrlset:SetUserValue("AID", aid)
			ctrlset:SetUserValue("Name", name)
			local receiver_text = GET_CHILD_RECURSIVELY(ctrlset, "receiver_text")
			receiver_text:SetTextByKey("value", name)
		end
	end
end

function GET_COLONY_TAX_CHEQUE_BY_USER_VALUE(ctrl)
	local criterionTime = ctrl:GetUserValue("CriterionTime")
	local cityMapID = ctrl:GetUserIValue("CityMapID")
	local cheque = session.colonytax.GetTaxCheque(imcTime.GetSysTimeByStr(criterionTime), cityMapID)
	return cheque
end
function ON_OPEN_COLONY_TAX_DISTRIBUTE(frame)
	local cheque = GET_COLONY_TAX_CHEQUE_BY_USER_VALUE(frame)
	if cheque == nil then
		ui.OpenFrame("colony_tax_distribute")
		return
	end
	CREATE_COLONY_TAX_DISTRIBUTE_GUILD_MEMBER_LIST(frame)
	UPDATE_COLONY_TAX_DISTRIBUTE_NAME_ORDER(frame)
	UPDATE_COLONY_TAX_DISTRIBUTE_AMOUNT(frame)
end

function UPDATE_COLONY_TAX_DISTRIBUTE_AMOUNT(frame)
	local cheque = GET_COLONY_TAX_CHEQUE_BY_USER_VALUE(frame)
	local cur_amount_text = GET_CHILD_RECURSIVELY(frame, "cur_amount_text")
	local send_amount_text = GET_CHILD_RECURSIVELY(frame, "send_amount_text")
	local remain_amount_text = GET_CHILD_RECURSIVELY(frame, "remain_amount_text")

	local cityAmount = cheque:GetCityAmount();
	local marketAmount = cheque:GetMarketAmount();
	local totalAmount = SumForBigNumberInt64(cityAmount, marketAmount);
    local curAmount = SumForBigNumberInt64(totalAmount, '-'..cheque:GetSentAmount());
	local sendAmount = GET_SUM_COLONY_TAX_DISTRIBUTING_AMOUNT(frame); -- sum of.. 
	local remainAmount = SumForBigNumberInt64(curAmount, '-'..sendAmount)

	cur_amount_text:SetTextByKey("value", GET_COMMAED_STRING(curAmount))
	send_amount_text:SetTextByKey("value", GET_COMMAED_STRING(sendAmount))
	remain_amount_text:SetTextByKey("value", GET_COMMAED_STRING(remainAmount))
end

function GET_SUM_COLONY_TAX_DISTRIBUTING_AMOUNT(frame)
	local totalAmount = '0'
	local list = GET_COLONY_TAX_DISTRIBUTING_LIST(frame)
	for i=1, #list do
		local ctrlset = list[i]
		local receive_check = GET_CHILD_RECURSIVELY(ctrlset, "receive_check")
		local amount_edit = GET_CHILD_RECURSIVELY(ctrlset, "amount_edit")
		if receive_check:IsChecked() == 1 then
			local amount = GET_NOT_COMMAED_NUMBER(amount_edit:GetText())
			totalAmount = SumForBigNumberInt64(totalAmount, amount)
		end
	end
	return totalAmount
end

function ON_COLONY_TAX_DISTRIBUTE_RECEIVER_AMOUNT_TYPE(parent, editctrl)
	local receive_check = GET_CHILD(parent, "receive_check")
	receive_check:SetCheck(1)
	UPDATE_MONEY_COMMAED_STRING(parent, editctrl)
	local frame = parent:GetTopParentFrame()
	UPDATE_COLONY_TAX_DISTRIBUTE_AMOUNT(frame)
end

function ON_COLONY_TAX_DISTRIBUTE_RECEIVER_CHECK(parent, ctrl)
	local frame = parent:GetTopParentFrame()
	UPDATE_COLONY_TAX_DISTRIBUTE_AMOUNT(frame)
end

function UPDATE_COLONY_TAX_AMOUNT_MIN_MAX(parent, ctrl)
	-- for each edit control except this. 
	--rate_edit:SetMinNumber(GetColonyTaxRateMin());
	--rate_edit:SetMaxNumber(GetColonyTaxRateMax());
end

function FIND_COLONY_TAX_DISTRIBUTE_TEAMNAME(frame, editctrl)
	local findStr = editctrl:GetText()
	local receiverlist_gb = GET_CHILD_RECURSIVELY(frame, "receiverlist_gb")

	local cnt = GET_CHILD_COUNT_BY_USERVALUE(receiverlist_gb, "Type", "TeamCtrl")
	for i=1, cnt do
		local child = GET_CHILD(receiverlist_gb, "team_"..i)
		local isVisible = 0
		if string.find(child:GetUserValue("Name"), findStr) ~= nil then
			isVisible = 1
		end
		child:SetVisible(isVisible)
	end
	UPDATE_COLONY_TAX_DISTRIBUTE_NAME_ORDER(frame)
end

function ON_COLONY_TAX_DISTRIBUTE_TEAMNAME_TYPE(parent, editctrl)
	local frame = parent:GetTopParentFrame()
	FIND_COLONY_TAX_DISTRIBUTE_TEAMNAME(frame, editctrl)
end

function GET_COLONY_TAX_DISTRIBUTING_LIST(frame)
	local receiverlist_gb = GET_CHILD_RECURSIVELY(frame, "receiverlist_gb")
	local cnt = GET_CHILD_COUNT_BY_USERVALUE(receiverlist_gb, "Type", "TeamCtrl")
	local list = {}
	for i=1, cnt do
		local ctrlset = GET_CHILD(receiverlist_gb, "team_"..i)
		list[i] = ctrlset;
	end
	return list
end

function ON_COLONY_TAX_DISTRIBUTE_ALL_CHECK(parent, ctrl)
	local isChecked = ctrl:IsChecked()
	local frame = parent:GetTopParentFrame()

	local list = GET_COLONY_TAX_DISTRIBUTING_LIST(frame)
	for i=1, #list do
		local ctrlset = list[i]
		local receive_check = GET_CHILD_RECURSIVELY(ctrlset, "receive_check")
		receive_check:SetCheck(isChecked)
	end
	UPDATE_COLONY_TAX_DISTRIBUTE_AMOUNT(frame)
end

function ON_COLONY_TAX_DISTRIBUTE_TEAMNAME_FIND_BTN(parent, ctrl)
	local frame = parent:GetTopParentFrame()
	local find_edit = GET_CHILD_RECURSIVELY(frame, "find_edit")
	FIND_COLONY_TAX_DISTRIBUTE_TEAMNAME(frame, find_edit)
end

function ON_COLONY_TAX_DISTRIBUTE_SEND_BTN(parent, ctrl)
	local frame = parent:GetTopParentFrame()
	local cheque = GET_COLONY_TAX_CHEQUE_BY_USER_VALUE(frame)
	local sendAmount = GET_SUM_COLONY_TAX_DISTRIBUTING_AMOUNT(frame);

	local totalAmount = SumForBigNumberInt64(cheque:GetCityAmount(), cheque:GetMarketAmount());
    local curAmount = SumForBigNumberInt64(totalAmount, '-'..cheque:GetSentAmount());
	if IsGreaterThanForBigNumber(sendAmount, curAmount) == 1 then
		ui.SysMsg(ScpArgMsg('ColonyTax_Cheque_NotEnoughAmount'))
		return;
	end

	local sendList = GET_COLONY_TAX_DISTRIBUTE_SEND_LIST(frame)
	session.colonytax.ClearSendList();
	for i=1, #sendList do
		local send = sendList[i];
		session.colonytax.AddSendList(send["AID"], send["AMOUNT"]);
	end
	session.colonytax.ReqTaxChequeSend(cheque:GetCityMapID(), cheque:GetCriterionTime())
	CLEAR_COLONY_TAX_DISTRIBUTE_GUILD_MEMBER_LIST(frame)
	session.colonytax.ClearSendList();
end

function CLEAR_COLONY_TAX_DISTRIBUTE_GUILD_MEMBER_LIST(frame)
	local list = GET_COLONY_TAX_DISTRIBUTING_LIST(frame)
	for i=1, #list do
		local ctrlset = list[i]
		local receive_check = GET_CHILD_RECURSIVELY(ctrlset, "receive_check")
		local amount_edit = GET_CHILD_RECURSIVELY(ctrlset, "amount_edit")
		receive_check:SetCheck(0)
		amount_edit:SetText(0);
	end
end

function GET_COLONY_TAX_DISTRIBUTE_SEND_LIST(frame)
	local sendList = {}
	local list = GET_COLONY_TAX_DISTRIBUTING_LIST(frame)
	for i=1, #list do
		local ctrlset = list[i]
		local receive_check = GET_CHILD_RECURSIVELY(ctrlset, "receive_check")
		local amount_edit = GET_CHILD_RECURSIVELY(ctrlset, "amount_edit")
		if receive_check:IsChecked() == 1 then
			local aid = ctrlset:GetUserValue("AID");
			local amount = GET_NOT_COMMAED_NUMBER(amount_edit:GetText())
			sendList[#sendList+1] = {};
			sendList[#sendList]["AID"] = aid;
			sendList[#sendList]["AMOUNT"] = amount;
		end
	end
	return sendList;
end

function ON_COLONY_TAX_DISTRIBUTE_NAME_ORDER(parent, ctrl)
	local frame = parent:GetTopParentFrame()

	local order = 1
	if frame:GetUserIValue("ORDER") == 1 then
		order = 0
	end
	frame:SetUserValue("ORDER", order)
	
	UPDATE_COLONY_TAX_DISTRIBUTE_NAME_ORDER(frame)
end

function UPDATE_COLONY_TAX_DISTRIBUTE_NAME_ORDER(frame)
	local receiverlist_gb = GET_CHILD_RECURSIVELY(frame, "receiverlist_gb")
	local order = frame:GetUserIValue("ORDER")
	local orderStr = frame:GetUserConfig("ASC")
	if order == 1 then
		orderStr = frame:GetUserConfig("DESC")
	end

	local name_text = GET_CHILD_RECURSIVELY(frame, "name_text")
	name_text:SetTextByKey("value", orderStr)

	local func = function (lhs, rhs) return lhs["name"] < rhs["name"] end
	if order == 1 then
		func = function (lhs, rhs) return lhs["name"] > rhs["name"] end
	end

	local pair_list = {}
	local cnt = GET_CHILD_COUNT_BY_USERVALUE(receiverlist_gb, "Type", "TeamCtrl")
	for i=1, cnt do
		local child = GET_CHILD(receiverlist_gb, "team_"..i)
		pair_list[#pair_list+1] = {}
		pair_list[#pair_list]["ctrl"] = child:GetName()
		pair_list[#pair_list]["name"] = child:GetUserValue("Name")
	end
	table.sort(pair_list, func)

	local height = ui.GetControlSetAttribute("colony_tax_distribute_team", "height");
	local visibleCount = 0;
	for i=1, #pair_list do
		local pair = pair_list[i]
		local child = GET_CHILD(receiverlist_gb, pair["ctrl"])
		if child:IsVisible() == 1 then
			child:SetOffset(child:GetOriginalX(), visibleCount*height)
			visibleCount = visibleCount + 1
		end
	end
end