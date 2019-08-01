function GUILD_MILEAGE_CHANGE_ON_INIT(addon, frame)
    addon:RegisterMsg('GUILD_MEMBER_PROP_UPDATE', 'REFRESH_CONTRIBUTION_MILEAGE');
end

function INIT_MILEAGE_CONTRIBUTION_POINT(frame, myPointText, targetPointText)
    local title = GET_CHILD_RECURSIVELY(frame, 'headerText');
    title:SetTextByKey('value', targetPointText);
	
    local myPoint = GET_CHILD_RECURSIVELY(frame, 'moneyInfoText');
    myPoint:SetTextByKey('value', myPointText);
	
    local changeablePoint = GET_CHILD_RECURSIVELY(frame, 'enableInfoText');
    changeablePoint:SetTextByKey('value', targetPointText);
	
    local changeTargetPoint = GET_CHILD_RECURSIVELY(frame, 'buyPointInfoText');
    changeTargetPoint:SetTextByKey('value', targetPointText);

	local consumePoint = GET_CHILD_RECURSIVELY(frame, 'consumeMoneyInfoText');
	consumePoint:SetTextByKey('value', myPointText);

	local remainPoint = GET_CHILD_RECURSIVELY(frame, 'remainMoneyInfoText');
	remainPoint:SetTextByKey('value', myPointText);
	
	MILEAGE_CONTRIBUTION_POINT_BUY_RESET(frame);
end

function INIT_CONTRIBUTION_TO_MILEAGE_POINT()
    ui.OpenFrame("guild_mileage_change");

	local frame = ui.GetFrame("guild_mileage_change");
	frame:SetUserValue("LogicType", "C2M");

	local guildMileageText = ClMsg("Housing_Guild_Mileage");
	local contributionText = ClMsg("Housing_Contribution");
	
	INIT_MILEAGE_CONTRIBUTION_POINT(frame, contributionText, guildMileageText);
end

function INIT_MILEAGE_TO_CONTRIBUTION_POINT(frame)
    ui.OpenFrame("guild_mileage_change");

	local frame = ui.GetFrame("guild_mileage_change");
	frame:SetUserValue("LogicType", "M2C");

	local guildMileageText = ClMsg("Housing_Guild_Mileage");
	local contributionText = ClMsg("Housing_Contribution");
	
	INIT_MILEAGE_CONTRIBUTION_POINT(frame, guildMileageText, contributionText);
end

function MILEAGE_CONTRIBUTION_POINT_BUY_OPEN(frame)
    MILEAGE_CONTRIBUTION_POINT_BUY_RESET(frame);
end

function GET_MY_CONTRIBUTION()
	local myPC = GetMyPCObject();
    local list = session.party.GetPartyMemberList(PARTY_GUILD);
	
    local count = list:Count();
	for i = 0, count - 1 do
        local guildMemberInfo = list:Element(i);
		if guildMemberInfo:GetAID() == session.loginInfo.GetAID() then
            local myObj = GetIES(guildMemberInfo:GetObject());
			return myObj.Contribution;
		end
	end

	return 0;
end

function GET_MY_GUILD_MILEAGE()
	local guild = session.party.GetPartyInfo(PARTY_GUILD);
	if guild ~= nil then
		return guild.info:GetMileage();
	end

	return 0;
end

function MILEAGE_CONTRIBUTION_POINT_BUY_RESET(frame)
	local logicType = frame:GetUserValue("LogicType");
    local enableValueText = GET_CHILD_RECURSIVELY(frame, 'enableValueText');
    local buyPointEdit = GET_CHILD_RECURSIVELY(frame, 'buyPointEdit');
	
	local point = 0;
	local ratio = 0;
	if logicType == "C2M" then
		point = GET_MY_CONTRIBUTION();
		ratio = HOUSING_CONTRIBUTION_TO_GUILDMILEAGE_CONVERSION_RATIO;
	else
		point = GET_MY_GUILD_MILEAGE();
		ratio = HOUSING_GUILDMILEAGE_TO_CONTRIBUTION_CONVERSION_RATIO;
	end
	
    local ratioValueText = GET_CHILD_RECURSIVELY(frame, 'ratioValueText');
    ratioValueText:SetTextByKey('ratio', GET_COMMAED_STRING(ratio));

    local enableCount = math.floor(point / ratio);
    
    enableValueText:SetTextByKey('count', GET_COMMAED_STRING(enableCount));
    frame:SetUserValue('ENABLE_COUNT', enableCount);

    MILEAGE_CONTRIBUTION_POINT_BUY_SET_EDIT(buyPointEdit, 0);
    MILEAGE_CONTRIBUTION_POINT_BUY_UPDATE(frame);
end

function MILEAGE_CONTRIBUTION_POINT_BUY_DOWN(parent, ctrl)
    local buyPointEdit = parent:GetChild('buyPointEdit');
    local topFrame = parent:GetTopParentFrame();
    local currentPoint = topFrame:GetUserIValue('POINT_COUNT');
    MILEAGE_CONTRIBUTION_POINT_BUY_SET_EDIT(buyPointEdit, math.max(0, tonumber(currentPoint) - 1));
    MILEAGE_CONTRIBUTION_POINT_BUY_UPDATE(parent:GetTopParentFrame());
end

function MILEAGE_CONTRIBUTION_POINT_BUY_UP(parent, ctrl)
    local buyPointEdit = parent:GetChild('buyPointEdit');
    local topFrame = parent:GetTopParentFrame();
    local currentPoint = topFrame:GetUserIValue('POINT_COUNT');
    MILEAGE_CONTRIBUTION_POINT_BUY_SET_EDIT(buyPointEdit, tonumber(currentPoint) + 1);
    MILEAGE_CONTRIBUTION_POINT_BUY_UPDATE(parent:GetTopParentFrame());
end

function MILEAGE_CONTRIBUTION_POINT_BUY_UPDATE(frame)
	local logicType = frame:GetUserValue("LogicType");
    local buyPointEdit = GET_CHILD_RECURSIVELY(frame, 'buyPointEdit');
    local consumeMoneyText = GET_CHILD_RECURSIVELY(frame, 'consumeMoneyText');
    local remainMoneyText = GET_CHILD_RECURSIVELY(frame, 'remainMoneyText');
    local moneyValueText = GET_CHILD_RECURSIVELY(frame, 'moneyValueText');
	
	local point = 0;
	if logicType == "C2M" then
		point = GET_MY_CONTRIBUTION();
	else
		point = GET_MY_GUILD_MILEAGE();
	end

    local consumeMoney = MILEAGE_CONTRIBUTION_POINT_BUY_GET_CONSUME_MONEY(frame);    
    local remainMoney = point - consumeMoney;
    local consumeMoneyStr = GET_COMMAED_STRING(consumeMoney);
    local remainMoneyStr = "";
    if tonumber(consumeMoney) > 0 then
        consumeMoneyStr = '-'..consumeMoneyStr;
    end
    if tonumber(remainMoney) >= 0 then
        remainMoneyStr = GET_COMMAED_STRING(remainMoney);
    else
        local EXCEED_MONEY_STYLE = frame:GetUserConfig('EXCEED_MONEY_STYLE');
        remainMoneyStr = EXCEED_MONEY_STYLE..'-'..GET_COMMAED_STRING(-remainMoney)..'{/}';
    end

    moneyValueText:SetTextByKey('money', GET_COMMAED_STRING(point));
    consumeMoneyText:SetTextByKey('money', consumeMoneyStr);
    remainMoneyText:SetTextByKey('money', remainMoneyStr);
end

function MILEAGE_CONTRIBUTION_POINT_BUY_GET_CONSUME_MONEY(frame)
    local pointCount = frame:GetUserIValue('POINT_COUNT');
	local ratio = 0;
	
	local logicType = frame:GetUserValue("LogicType");
	if logicType == "C2M" then
		ratio = HOUSING_CONTRIBUTION_TO_GUILDMILEAGE_CONVERSION_RATIO;
	else
		ratio = HOUSING_GUILDMILEAGE_TO_CONTRIBUTION_CONVERSION_RATIO;
	end
	
    local consumeMoney = MultForBigNumberInt64(pointCount, ratio);
    return consumeMoney;
end

function MILEAGE_CONTRIBUTION_POINT_BUY_TYPE(parent, ctrl)
    MILEAGE_CONTRIBUTION_POINT_BUY_SET_EDIT(ctrl, ctrl:GetText());
    MILEAGE_CONTRIBUTION_POINT_BUY_UPDATE(parent:GetTopParentFrame());
end

function MILEAGE_CONTRIBUTION_POINT_BUY_SET_EDIT(edit, count)
    local topFrame = edit:GetTopParentFrame();
    local enableCount = topFrame:GetUserIValue('ENABLE_COUNT');
    count = tonumber(count)
    if count == nil then
        count = 0;
        edit:SetText('0');
    end

    if count > enableCount then
        local EXCEED_POINT_STYLE = topFrame:GetUserConfig('EXCEED_POINT_STYLE');
        edit:SetText(EXCEED_POINT_STYLE..count..'{/}');
        edit:SetValue(count)
    else
        edit:SetText(count);
        edit:SetValue(count)
    end
    topFrame:SetUserValue('POINT_COUNT', count);
end

function CONTRIBUTION_MILEAGE_POINT_CHANGE(parent, button)
	local frame = ui.GetFrame("guild_mileage_change");
	local logicType = frame:GetUserValue("LogicType");

	local point = GET_CHILD_RECURSIVELY(frame, "buyPointEdit");
	
	if logicType == "C2M" then
	    local nowContribution = GET_MY_CONTRIBUTION();
    	local useContribution = point:GetValue()
	    local exchangeRate = HOUSING_CONTRIBUTION_TO_GUILDMILEAGE_CONVERSION_RATIO;
    	useContribution = math.floor(useContribution * exchangeRate);

		if nowContribution < useContribution then
			ui.SysMsg(ClMsg('Housing_Not_Enough_Contribution'));
		else
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
			housing.RequestChangeContributionToMileage(point:GetText());
		end
	elseif logicType == "M2C" then
	    local nowMileage = GET_MY_GUILD_MILEAGE();
    	local useMileage = point:GetValue()
	    local exchangeRate = HOUSING_GUILDMILEAGE_TO_CONTRIBUTION_CONVERSION_RATIO;
    	useMileage = math.floor(useMileage * exchangeRate);

	    if nowMileage < useMileage then
	       	ui.SysMsg(ClMsg('Housing_Not_Enough_Mileage'));
    	else
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
			housing.RequestChangeMileageToContribution(point:GetText());
		end
	end

	point:ClearText();
	
	button:SetEnable(0);
	AddLuaTimerFunc("RESET_CONTRIBUTION_MILEAGE_POINT_BUTTON", 2000, 0);
end

function RESET_CONTRIBUTION_MILEAGE_POINT_BUTTON()
	local frame = ui.GetFrame("guild_mileage_change");
	local button = GET_CHILD_RECURSIVELY(frame, "buyBtn");
	button:SetEnable(1);
end

function CONTRIBUTION_TO_MILEAGE_POINT_CANCEL(parent, ctrl)
    ui.CloseFrame('guild_mileage_change');
end

function REFRESH_CONTRIBUTION_MILEAGE()
	local frame = ui.GetFrame("guild_mileage_change");
	if frame == nil then
		return;
	end

	local logicType = frame:GetUserValue("LogicType");

	if logicType == "C2M" then
		local guildMileageText = ClMsg("Housing_Guild_Mileage");
		local contributionText = ClMsg("Housing_Contribution");
	
		INIT_MILEAGE_CONTRIBUTION_POINT(frame, contributionText, guildMileageText);
	elseif logicType == "M2C" then
		local guildMileageText = ClMsg("Housing_Guild_Mileage");
		local contributionText = ClMsg("Housing_Contribution");
	
		INIT_MILEAGE_CONTRIBUTION_POINT(frame, guildMileageText, contributionText);
	end
end