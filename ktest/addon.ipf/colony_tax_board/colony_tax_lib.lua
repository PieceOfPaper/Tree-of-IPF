
function GET_COLONY_TAX_EXPIRE_TEXT(remainSec)
	local remainTimeStr = ""
	if remainSec < 86400 then
		local hour = math.floor(remainSec/3600)
		local min = math.floor(remainSec%3600/60)
		hour = string.format("%02d", hour)
		min = string.format("%02d", min)
		remainTimeStr = ScpArgMsg("ColonyTaxRemain{Hour}{Min}", "Hour", hour, "Min", min)
	else
		local days = math.floor(remainSec/86400)
		remainTimeStr = ScpArgMsg("ColonyTaxRemain{Date}", "Date", days)
	end
	return remainTimeStr
end

function SET_COLONY_TAX_RATE_LIST_SKIN(listgb, width, height, count, oddSkin, evenSkin)
	local gbHeight = listgb:GetHeight();
	local stripeCount = math.ceil(gbHeight/height);
	stripeCount = math.max(stripeCount, count);

	local skinList = {}
	skinList[0] = evenSkin;
	skinList[1] = oddSkin;

    for i=0, stripeCount-1 do
        local gb = listgb:CreateOrGetControl("groupbox", "stripe_"..i, 0, i*height, width, height)
		AUTO_CAST(gb);
		gb:EnableHitTest(0);
		gb:SetSkinName(skinList[i%2]);
	end
end

function SET_COLONY_TAX_PAYMENT_LIST_SKIN(ctrlList, oddSkin, evenSkin)
    for i=1, #ctrlList do
        local skinName = oddSkin
        if i%2 == 0 then
            skinName = evenSkin
        end
        ctrlList[i]:SetSkinName(skinName)
    end
end


function GET_COLONY_TAX_CURRENT_CITY_NAME()
	if session.colonytax.IsEnabledColonyTaxShop() ~= true then
		return;
	end

	local curMapID = session.GetMapID()
	local cityMapID = session.colonytax.GetColonyCityID(curMapID)
	local taxRateInfo = session.colonytax.GetColonyTaxRate(cityMapID)
	if taxRateInfo == nil then
		return;
	end

	local cityMapCls = GetClassByType("Map", cityMapID)
	if cityMapCls == nil then
		return;
	end

	return cityMapCls.ClassName;
end

function GET_COLONY_TAX_RATE_CURRENT_MAP()
	if session.colonytax.IsEnabledColonyTaxShop() ~= true then
		return
	end

	local curMapID = session.GetMapID()
	local cityMapID = session.colonytax.GetColonyCityID(curMapID)
	local taxRateInfo = session.colonytax.GetColonyTaxRate(cityMapID)
	if taxRateInfo == nil then
		return
	end

	if taxRateInfo:IsStarted() == false then
		return
	end

    local myGuild = session.party.GetPartyInfo(PARTY_GUILD);
	if myGuild ~= nil then
		local myGuildID = myGuild.info:GetPartyID();
		if taxRateInfo:GetGuildID() == myGuildID then
			return COLONY_TAX_RATE_MEMBER
		end
	end

    local rate = taxRateInfo:GetTaxRate()
	return rate
end

function SET_COLONY_TAX_RATE_TEXT(ctrl, textKey, isEnabled) 
	local currentRate = GET_COLONY_TAX_RATE_CURRENT_MAP()

	-- isEnabled: true or false or nil.
	if isEnabled ~= false then
		isEnabled = session.colonytax.IsEnabledColonyTaxShop() == true and currentRate ~= nil;
	end

	ctrl:EnableHitTest(1)
	if isEnabled then
		local currentCity = GET_COLONY_TAX_CURRENT_CITY_NAME()
		local cityMapCls = GetClass("Map", currentCity)
		local cityName = cityMapCls.Name;
		local curMapID = session.GetMapID()
		local cityMapID = session.colonytax.GetColonyCityID(curMapID)
		local taxRateInfo = session.colonytax.GetColonyTaxRate(cityMapID)
		local currentGuildName = taxRateInfo:GetGuildName();
		ctrl:SetTextByKey(textKey, ScpArgMsg("ColonyTaxIconWith{Rate}", "Rate", currentRate))
		ctrl:SetTextTooltip(ScpArgMsg("ColonyTaxCurrentMap{City}{Rate}{GuildName}", "City", cityName, "Rate", currentRate, "GuildName", currentGuildName))
	else
		ctrl:SetTextByKey(textKey, "")
		ctrl:SetTooltipType("None")
	end
end

function GET_COLONY_TAX_APPLIED_STRING(isWithIcon, iconWidth, iconHeight)
	local taxStr = "";
	if GET_COLONY_TAX_RATE_CURRENT_MAP() then
		local currentCity = GET_COLONY_TAX_CURRENT_CITY_NAME()
		local cityMapCls = GetClass("Map", currentCity)
		local cityName = cityMapCls.Name;
    	local curMapID = session.GetMapID()
    	local cityMapID = session.colonytax.GetColonyCityID(curMapID)
        local taxRateInfo = session.colonytax.GetColonyTaxRate(cityMapID)
        local currentGuildName = taxRateInfo:GetGuildName();
		local iconStr = ""
		if isWithIcon then
			iconStr = ScpArgMsg("ColonyTaxIcon{Width}{Height}", "Width", iconWidth, "Height", iconHeight);
		end
		taxStr = iconStr .. ScpArgMsg("ColonyTaxCurrentMap{City}{Rate}{GuildName}", "City", cityName, "Rate", GET_COLONY_TAX_RATE_CURRENT_MAP(), "GuildName", currentGuildName);
	end
	return taxStr;
end
