function GUILD_DISTRIBUTE_CONTRIBUTION_ON_INIT(addon, frame)
	addon:RegisterMsg('CALLBACK_DISTRIBUTE_CONTRIBUTION', 'ON_CALLBACK_DISTRIBUTE_CONTRIBUTION');
    addon:RegisterMsg('REFRESH_DISTRIBUTE_CONTRIBUTION', 'DISTRIBUTE_CONTRIBUTION_OPEN');
end

function INIT_DISTRIBUTE_CONTRIBUTION_GUILD_MEMBER(frame)
    local memberCtrlBox = GET_CHILD_RECURSIVELY(frame, 'gbox_guild_member_list');
    DESTROY_CHILD_BYNAME(memberCtrlBox, 'MEMBER_');
	
	local order = frame:GetUserIValue("ORDER")
	local orderStr = frame:GetUserConfig("ASC")
	if order == 1 then
		orderStr = frame:GetUserConfig("DESC")
	end

    local txt_member_name_title = GET_CHILD_RECURSIVELY(frame, 'txt_member_name_title');
	txt_member_name_title:SetTextByKey("arrow", orderStr);
	
	local func = function (lhs, rhs) return lhs["Name"] < rhs["Name"] end
	if order == 1 then
		func = function (lhs, rhs) return lhs["Name"] > rhs["Name"] end
	end
	
	local memberList = {};

    local list = session.party.GetPartyMemberList(PARTY_GUILD);
	local count = list:Count();
	for i = 0 , count - 1 do
        local partyMemberInfo = list:Element(i);                            
        local aid = partyMemberInfo:GetAID();
		if aid ~= session.loginInfo.GetAID() then
			memberList[#memberList + 1] = {};
			memberList[#memberList]["AID"] = aid;
			memberList[#memberList]["Name"] = partyMemberInfo:GetName();
		end
	end

	table.sort(memberList, func);

	for i = 1, #memberList do
		local aid = memberList[i]["AID"];
		local name = memberList[i]["Name"];

		local memberCtrlSet = memberCtrlBox:CreateOrGetControlSet('housing_distrubute_contribution_member', 'MEMBER_' .. i, 0, 0);
		memberCtrlSet = AUTO_CAST(memberCtrlSet);
		memberCtrlSet:SetUserValue('AID', aid);
		
		local txt_member_name = GET_CHILD_RECURSIVELY(memberCtrlSet, 'txt_member_name');
		txt_member_name:SetTextByKey('value', name);
	end

	frame:SetUserValue("MemberCount", #memberList);

	GBOX_AUTO_ALIGN(memberCtrlBox, 0, 0, 0, true, false, true);
end

function DISTRIBUTE_CONTRIBUTION_MEMBER_SORT(parent, ctrl)
	local frame = parent:GetTopParentFrame();

	local order = 1
	if frame:GetUserIValue("ORDER") == 1 then
		order = 0
	end
	frame:SetUserValue("ORDER", order);

	INIT_DISTRIBUTE_CONTRIBUTION_GUILD_MEMBER(frame);
end

function INIT_DISTRIBUTE_CONTRIBUTION_INFO(frame)
	local contribution = GET_MY_CONTRIBUTION();
	
    local contribution_value = GET_CHILD_RECURSIVELY(frame, 'txt_contribution_value');
	contribution_value:SetTextByKey("value", GET_COMMAED_STRING(contribution));
end

function DISTRIBUTE_CONTRIBUTION_OPEN(frame)
	INIT_DISTRIBUTE_CONTRIBUTION_GUILD_MEMBER(frame);
	INIT_DISTRIBUTE_CONTRIBUTION_INFO(frame);
	
	frame:SetUserValue("TotalUsePoint", "0");
	UPDATE_DISTRIBUTE_CONTRIBUTION(frame, 0);
end

function UPDATE_DISTRIBUTE_CONTRIBUTION(frame, totalUsePoint)
	local contribution = GET_MY_CONTRIBUTION();

    local distribution_value = GET_CHILD_RECURSIVELY(frame, 'txt_distribution_value');
	distribution_value:SetTextByKey("value", GET_COMMAED_STRING(totalUsePoint));
	
    local remain_value = GET_CHILD_RECURSIVELY(frame, 'txt_remain_value');
	remain_value:SetTextByKey("value", GET_COMMAED_STRING(contribution - totalUsePoint));
end

function INPUT_CONTRIBUTION(gbox, ctrl)
	local frame = gbox:GetTopParentFrame();

	local contribution = GET_MY_CONTRIBUTION();

	local prevValue = ctrl:GetUserValue("PrevValue");
	if prevValue == "None" then
		prevValue = 0;
	end
	prevValue = tonumber(prevValue);

	local curValue = ctrl:GetText();
	if curValue == nil or curValue == "" then
		curValue = 0;
	end
	curValue = tonumber(curValue);

	local totalUsePoint = frame:GetUserValue("TotalUsePoint");
	if totalUsePoint == "None" then
		totalUsePoint = 0;
	end
	totalUsePoint = tonumber(totalUsePoint);

	if contribution < totalUsePoint - prevValue + curValue then
		curValue = contribution - (totalUsePoint - prevValue);
		ctrl:SetText(tostring(curValue));
	end

	totalUsePoint = totalUsePoint - prevValue + curValue;

	ctrl:SetUserValue("PrevValue", tostring(curValue));
	frame:SetUserValue("TotalUsePoint", tostring(totalUsePoint));

	UPDATE_DISTRIBUTE_CONTRIBUTION(frame, totalUsePoint);
end

function DISTRIBUTE_CONTRIBUTION_COMMIT(gbox, btn)
	local frame = gbox:GetTopParentFrame();
	local memberCount = frame:GetUserValue("MemberCount");
	if memberCount == "0" or memberCount == "None" then
		return;
	end

	memberCount = tonumber(memberCount);

	housing.ClearGuildContributionDistributeTargets();

	for i = 1, memberCount do
		local memberCtrlSet = GET_CHILD_RECURSIVELY(frame, 'MEMBER_' .. i);
		local aid = memberCtrlSet:GetUserValue("AID");

		local edit_contribution = GET_CHILD_RECURSIVELY(memberCtrlSet, "edit_contribution");
		local curValue = edit_contribution:GetText();
		if curValue == nil or curValue == "" then
			curValue = 0;
		end
		curValue = tonumber(curValue);

		housing.AddGuildContributionDistributeTarget(aid, curValue);
	end

	housing.CommitGuildContributionDistributeTargets("CALLBACK_DISTRIBUTE_CONTRIBUTION");
	
	btn:SetEnable(0);
	AddLuaTimerFunc("RESET_DISTRIBUTE_CONTRIBUTION_BUTTON", 2000, 0);
end

function RESET_DISTRIBUTE_CONTRIBUTION_BUTTON()
	local frame = ui.GetFrame("guild_distribute_contribution");
	local button = GET_CHILD_RECURSIVELY(frame, "buyBtn");
	button:SetEnable(1);
end

function ON_CALLBACK_DISTRIBUTE_CONTRIBUTION(frame)
	housing.RequestGuildAgitInfo("REFRESH_DISTRIBUTE_CONTRIBUTION");
end

function DISTRIBUTE_CONTRIBUTION_CANCEL()
    ui.CloseFrame('guild_distribute_contribution');
end