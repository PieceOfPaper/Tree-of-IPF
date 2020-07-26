-- buff_tooltip.lua
function UPDATE_PREMIUM_TOOLTIP(tooltipframe, strarg, numarg1, numarg2)
	local type = tooltipframe:GetChild("richtext_1");
	local typeStr = "None";
	local token_expup = tooltipframe:GetChild("token_expup");
	local token_staup = tooltipframe:GetChild("token_staup");
	local marketFastGet = tooltipframe:GetChild("marketFastGet");
	local marketMinMax = tooltipframe:GetChild("marketMinMax");
--	local token_buffCountUp = tooltipframe:GetChild("token_buffCountUp");
	local token_teamwarehouse = tooltipframe:GetChild("token_teamwarehouse");
	local token_icormultiple = tooltipframe:GetChild("token_icormultiple");
--	local mission_reward = tooltipframe:GetChild("mission_reward");
--	local RaidStance = tooltipframe:GetChild("RaidStance");
	local token_remaintime = tooltipframe:GetChild("token_remaintime");
    
	local token_tradecount = tooltipframe:GetChild("token_tradecount");
	
	local pcbangPartyExpUp = tooltipframe:GetChild("pcbangPartyExpUp");
	pcbangPartyExpUp:ShowWindow(0);
	
	local pcbangChallengeCount = tooltipframe:GetChild("challengeCount");
	pcbangChallengeCount:ShowWindow(0);
	
	local pcbangItemRental = tooltipframe:GetChild("pcbangItemRental");
	pcbangItemRental:ShowWindow(0);
	


	local buffCls = GetClassByType('Buff', numarg1);
	local argNum = NONE_PREMIUM;
	if buffCls.ClassName == "Premium_Nexon" then
		argNum = NEXON_PC;
	elseif buffCls.ClassName =="Premium_Token" then
		argNum = ITEM_TOKEN;
	end

	if ITEM_TOKEN == argNum then
		type:SetTextByKey("value", ClMsg("tokenItem"));
		
        marketFastGet:ShowWindow(1);
        marketMinMax:ShowWindow(1);
		token_teamwarehouse:ShowWindow(1);
		token_icormultiple:ShowWindow(1);
--        token_buffCountUp:ShowWindow(1);
		token_expup:SetTextByKey("value", ScpArgMsg("Token_ExpUp{PER}", "PER", "20%"));
		token_staup:SetTextByKey("value", ClMsg("AllowPremiumPose"));
		token_staup:ShowWindow(1);
		if IS_MYPC_EXCHANGE_BENEFIT_STATE() == true then
			local tradeCountString = ScpArgMsg("AllowTradeByCount")-- .. " " .. tostring(accountObj.TradeCount)
--			token_tradecount:SetTextByKey("value", tradeCountString);
			token_tradecount:ShowWindow(1);
		else
			token_tradecount:ShowWindow(0);
		end
--        mission_reward:ShowWindow(1);
--        RaidStance:ShowWindow(1);

		local difSec = GET_REMAIN_TOKEN_SEC();
		if 0 < difSec then
			token_remaintime:SetUserValue("REMAINSEC", difSec);
			token_remaintime:SetUserValue("STARTSEC", imcTime.GetAppTime());
			SHOW_TOKEN_REMAIN_TIME_IN_BUFF_TOOLTIP(token_remaintime);
			token_remaintime:RunUpdateScript("SHOW_TOKEN_REMAIN_TIME_IN_BUFF_TOOLTIP");
			token_remaintime:ShowWindow(1);
		else
			token_remaintime:StopUpdateScript("SHOW_TOKEN_REMAIN_TIME_IN_BUFF_TOOLTIP");
			token_remaintime:ShowWindow(0);
		end
	elseif NEXON_PC == argNum then
		type:SetTextByKey("value", ClMsg("nexon")); 
		token_staup:ShowWindow(0);
		token_expup:SetTextByKey("value", ClMsg("token_expup"));
		token_tradecount:ShowWindow(0);
--		token_buffCountUp:ShowWindow(0);
        marketFastGet:ShowWindow(0);
        marketMinMax:ShowWindow(0);
        token_teamwarehouse:ShowWindow(0);
--        mission_reward:ShowWindow(0);
--        RaidStance:ShowWindow(0);
		
		local pcbangChallengeCountString = ScpArgMsg("PcbangChallengeCount{COUNT}", "COUNT", 1)
		pcbangChallengeCount:SetTextByKey("value", pcbangChallengeCountString);
		pcbangChallengeCount:ShowWindow(1);
		
		pcbangPartyExpUp:SetTextByKey("value", ScpArgMsg("PcbangPartyExpUp"));
		pcbangPartyExpUp:ShowWindow(1);
		
		pcbangItemRental:SetTextByKey("value", ScpArgMsg("PcbangItemRental"));
		pcbangItemRental:ShowWindow(1);
		
		token_remaintime:StopUpdateScript("SHOW_TOKEN_REMAIN_TIME_IN_BUFF_TOOLTIP");
		token_remaintime:ShowWindow(0);
	else
		token_tradecount:ShowWindow(0);
        marketFastGet:ShowWindow(0);
		marketMinMax:ShowWindow(0);
		
		token_remaintime:StopUpdateScript("SHOW_TOKEN_REMAIN_TIME_IN_BUFF_TOOLTIP");
		token_remaintime:ShowWindow(0);
	end
	
	for i = 0, 3 do 
		local str, value = GetCashInfo(argNum, i)
		if nil ~= str then
			type = tooltipframe:GetChild(str);
			local normal = GetCashValue(0, str);
			local txt = "None"
			if str == "marketSellCom" then
				normal = normal + 0.01;
				value = value + 0.01;
				txt = math.floor(normal*100).. "% ->".. math.floor(value*100) .."%";
				type:SetTextByKey("value", ClMsg(str));
			elseif str == 'abilityMax' then
				type:SetTextByKey("value", '');
			else
				txt = normal..ClMsg("Piece").." ->"..value .. ClMsg("Piece");
				type:SetTextByKey("value", ScpArgMsg(str.."{COUNT}", "COUNT", value)); 
			end		
		end
	end

	local cnt = tooltipframe:GetChildCount();
	local y = 45;
	for i = 0, cnt - 1 do
		local ctrl = tooltipframe:GetChildByIndex(i);
		
		-- 증정용 토큰일 경우 '개인 거래 무제한' text 안보이도록		
		local itemcls = GetClassByType("Item", numarg2);
		if itemcls ~= nil then
			if ctrl:GetName() == 'TradeFreeCom' then
				if itemcls.NumberArg2 == 0 then
					ctrl:ShowWindow(0);
				else
					ctrl:ShowWindow(1);
				end
			end
		end

		if ctrl:IsVisible() == 1 and ctrl:GetClassString() == "ui::CRichText" and ctrl:GetName() ~= "richtext_1" then
			ctrl:SetOffset(ctrl:GetX(), y);
			y = y + ctrl:GetHeight();
		end	
	end

	local gbox = tooltipframe:GetChild("gbox");
	gbox:Resize(gbox:GetWidth(), y + 10);
	tooltipframe:Resize(tooltipframe:GetWidth(), gbox:GetHeight() + 20);
end

function SHOW_TOKEN_REMAIN_TIME_IN_BUFF_TOOLTIP(ctrl)
    local elapsedSec = imcTime.GetAppTime() - ctrl:GetUserIValue("STARTSEC");
    local startSec = ctrl:GetUserIValue("REMAINSEC");
    startSec = startSec - elapsedSec;
    if 0 > startSec then
        ctrl:SetTextByKey("value", "");
        return 0;
    end
    local timeTxt = GET_TIME_TXT(startSec);
    ctrl:SetTextByKey("value", timeTxt);
    return 1;
end

function UPDATE_BUFF_TOOLTIP(frame, handle, numarg1, numarg2)	
	local buff = nil;    
    if tonumber(numarg2) > 0 then
        buff = info.GetBuff(handle, numarg1, numarg2);
    else
        buff = info.GetBuff(handle, numarg1);
    end

	local buffOver;
	local buffTime;
	if buff ~= nil then
		buffOver = buff.over;
		buffTime = buff.time;
	else
		buffOver = 0;
		buffTime = 0.0;
	end

	local cls = GetClassByType('Buff', numarg1);
	local name = frame:GetChild("name");
	local nametxt = cls.Name;
	if buffOver > 1 then
		nametxt = nametxt .. " X " .. buffOver;
	end

	local comment = frame:GetChild("comment");

	local tooltipfunc = _G["BUFF_TOOLTIP_" .. cls.ClassName];	
	local tooltip = "";
	if tooltipfunc == nil then
		tooltip = cls.ToolTip;
	else
		local newName;
		tooltip, newName = tooltipfunc(buff, cls);		
		if newName ~= nil then
			nametxt = newName;
		end
	end
	
	if buffTime == 0.0 then
		comment:SetText("{@st59}"..tooltip);		
	else
		local txt = tooltip
		..
		"{nl}"
		.. ScpArgMsg("Auto_NameunSiKan_:_") .. GET_BUFF_TIME_TXT(buffTime, 1);

		comment:SetText("{@st59}"..txt);		
	end
	
	frame:Resize(frame:GetOriginalWidth(), frame:GetOriginalHeight());

	name:SetText("{@st41}"..nametxt);	

end

function BUFF_TOOLTIP_Rejuvenation(buff, cls)

	local heal = 5
	return string.format(ScpArgMsg("Auto_HPwa_SPLeul_HoeBogSiKipNiDa."), heal), nil;

end

function BUFF_TOOLTIP_OgouVeve(buff, cls)

	return ScpArgMsg("Auto_HimKwa_JiNeungeul_olLyeoJupNiDa."), nil;

end


function BUFF_TOOLTIP_TeamLevel(buff, cls)

	local advantageText = "";
	local expBonus = GET_TEAM_LEVEL_EXP_BONUS(buff.arg1);
	advantageText = advantageText .. ScpArgMsg("ExpGetAmount") .. " + " .. expBonus .. "%";	

	return advantageText, ScpArgMsg("TeamLevel") .. " " .. buff.arg1;

end

function BUFF_TOOLTIP_DecreaseHeal_Debuff(buff, cls)
	local name = cls.Name
	local percentage = buff.arg2 / 1000
	local tooltip = cls.ToolTip
	tooltip = tooltip .. '(' .. string.format("%.1f", percentage) .. '%' .. ')'
	return tooltip, name
end

function BUFF_TOOLTIP_DRUG_LOOTINGCHANCE(buff, cls)

	local advantageText = "";
	local buffArg1 = buff.arg1;
	advantageText = advantageText .. ScpArgMsg("DrugLootingChance") .. " + " .. buffArg1;

	return advantageText, ScpArgMsg("DrugLootingChance") .. " " .. buff.arg1;

end

function BUFF_TOOLTIP_StartUp_Buff(buff, cls)

	local tooltip = cls.ToolTip
	local addDamageRate = buff.arg2
	tooltip = tooltip .. '(' .. string.format("%d", addDamageRate) .. '%' .. ')'
	return tooltip

end

function GET_TEAM_LEVEL_EXP_BONUS(teamLevel)
    local expBonus = 0;
    local xpCls = GetClassByType("XP_TeamLevel", teamLevel);
	local xpAmount = TryGetProp(xpCls, 'ExpBonus');
    if xpAmount ~= nil and xpAmount > 0 then
        expBonus = xpAmount;
    end
    return expBonus;
end

function BUFF_TOOLTIP_Event_CharExpRate(buff, cls)
	local advantageText = "";
	if buff ~= nil then
		advantageText = advantageText .. ScpArgMsg("ExpGetAmount") .. " + " .. math.floor(buff.arg1) .. "%";	
	end
	return advantageText, cls.ToolTip;
end


function BUFF_TOOLTIP_Achieve_Possession_Buff(buff, cls)

	local advantageText = "";
	local grade_Num = buff.arg1
	advantageText = ScpArgMsg("ACHIEVE_GRADE_EXP"..grade_Num);
	return advantageText, ScpArgMsg("ACHIEVE_GRADE", "num", grade_Num);
end
-- EVENT_2006_SUMMER
function BUFF_TOOLTIP_EVENT_2006_SUMMER_brochette(buff, cls)
	if buff == nil then
		return ""
	end
	local buffList = EVENT_2006_SUMMER_BUFF_TABLE('brochette')
	local buffArgList = EVENT_2006_SUMMER_BUFF_ARG_TABLE()

	local buffType = buffList[buff.arg1]
	local buffArgNum = buffArgList[buffType]

	return ScpArgMsg("EVENT_2006_SUMMER_brochette").."{nl}"..ScpArgMsg("EVENT_2006_SUMMER_"..buffType, "ARG", buffArgNum)
end

function BUFF_TOOLTIP_EVENT_2006_SUMMER_mojito(buff, cls)
	if buff == nil then
		return ""
	end
	local buffList = EVENT_2006_SUMMER_BUFF_TABLE('mojito')
	local buffArgList = EVENT_2006_SUMMER_BUFF_ARG_TABLE()

	local buffType = buffList[buff.arg1]
	local buffArgNum = buffArgList[buffType]

	return ScpArgMsg("EVENT_2006_SUMMER_mojito").."{nl}"..ScpArgMsg("EVENT_2006_SUMMER_"..buffType, "ARG", buffArgNum)
end

function BUFF_TOOLTIP_EVENT_2006_SUMMER_coconut(buff, cls)
	if buff == nil then
		return ""
	end
	local buffList = EVENT_2006_SUMMER_BUFF_TABLE('coconut')
	local buffArgList = EVENT_2006_SUMMER_BUFF_ARG_TABLE()

	local buffType = buffList[buff.arg1]
	local buffArgNum = buffArgList[buffType]

	return ScpArgMsg("EVENT_2006_SUMMER_coconut").."{nl}"..ScpArgMsg("EVENT_2006_SUMMER_"..buffType, "ARG", buffArgNum)
end

function BUFF_TOOLTIP_EVENT_2006_SUMMER_bingsu(buff, cls)
	if buff == nil then
		return ""
	end
	local buffList = EVENT_2006_SUMMER_BUFF_TABLE('bingsu')
	local buffArgList = EVENT_2006_SUMMER_BUFF_ARG_TABLE()

	local buffType = buffList[buff.arg1]
	local buffArgNum = buffArgList[buffType]

	return ScpArgMsg("EVENT_2006_SUMMER_bingsu").."{nl}"..ScpArgMsg("EVENT_2006_SUMMER_"..buffType, "ARG", buffArgNum)
end

function BUFF_TOOLTIP_EVENT_2006_SUMMER_softice(buff, cls)
	if buff == nil then
		return ""
	end
	local buffList = EVENT_2006_SUMMER_BUFF_TABLE('softice')
	local buffArgList = EVENT_2006_SUMMER_BUFF_ARG_TABLE()

	local buffType = buffList[buff.arg1]
	local buffArgNum = buffArgList[buffType]

	return ScpArgMsg("EVENT_2006_SUMMER_softice").."{nl}"..ScpArgMsg("EVENT_2006_SUMMER_"..buffType, "ARG", buffArgNum)
end