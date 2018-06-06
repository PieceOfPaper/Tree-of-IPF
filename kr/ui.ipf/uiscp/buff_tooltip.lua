-- buff_tooltip.lua
function UPDATE_PREMIUM_TOOLTIP(tooltipframe, strarg, numarg1, numarg2)
	local type = tooltipframe:GetChild("richtext_1");
	local typeStr = "None";
	local token_expup = tooltipframe:GetChild("token_expup");
	local token_staup = tooltipframe:GetChild("token_staup");
	local token_tradecount = tooltipframe:GetChild("token_tradecount");

	local buffCls = GetClassByType('Buff', numarg1);
	local argNum = NONE_PREMIUM;
	if buffCls.ClassName == "Premium_Nexon" then
		argNum = NEXON_PC;
	elseif buffCls.ClassName =="Premium_Token" then
		argNum = ITEM_TOKEN;
	end

	if ITEM_TOKEN == argNum then
		type:SetTextByKey("value", ClMsg("tokenItem"));
		token_expup:SetTextByKey("value", ScpArgMsg("Token_ExpUp{PER}", "PER", "20%"));
		token_staup:SetTextByKey("value", ClMsg("AllowPremiumPose"));


		local accountObj = GetMyAccountObj();
		local tokenItemCls = GetClassByType("Item", numarg2);
		if tokenItemCls ~= nil then
			local tradeCountString = ScpArgMsg("AllowTradeByCount") .. " " .. string.format("(%d/%d)", accountObj.TradeCount, tokenItemCls.NumberArg2);
			token_tradecount:SetTextByKey("value", tradeCountString);
			token_tradecount:ShowWindow(1);
		else
			token_tradecount:ShowWindow(0);
		end

	elseif NEXON_PC == argNum then
		type:SetTextByKey("value", ClMsg("nexon")); 
		token_staup:SetTextByKey("value", ClMsg("token_setup"));
		token_expup:SetTextByKey("value", ClMsg("token_expup"));
		token_tradecount:ShowWindow(0);
	else
		token_tradecount:ShowWindow(0);
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
			elseif str =="abilityMax" or str == "speedUp"then
				txt = normal.. " -> +"..value;
				type:SetTextByKey("value", ScpArgMsg(str.."{COUNT}", "COUNT", value)); 
			else
				txt = normal..ClMsg("Piece").." ->"..value .. ClMsg("Piece");
				type:SetTextByKey("value", ScpArgMsg(str.."{COUNT}", "COUNT", value)); 
			end		
		end
	end
end


function UPDATE_BUFF_TOOLTIP(frame, handle, numarg1, numarg2)

	local buff 					= info.GetBuff(handle, numarg1);
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

	name:SetText("{@st41}"..nametxt);

	local comment = frame:GetChild("comment");

	local tooltipfunc = _G["BUFF_TOOLTIP_" .. cls.ClassName];
	local tooltip = "";
	if tooltipfunc == nil then
		tooltip = cls.ToolTip;
	else
		tooltip = tooltipfunc(buff, cls);
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

end

function BUFF_TOOLTIP_Rejuvenation(buff, cls)

	local heal = 5
	return string.format(ScpArgMsg("Auto_HPwa_SPLeul_HoeBogSiKipNiDa."), heal);

end

function BUFF_TOOLTIP_OgouVeve(buff, cls)

	return ScpArgMsg("Auto_HimKwa_JiNeungeul_olLyeoJupNiDa.");

end


