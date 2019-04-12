function GUILDINFO_COLONY_INIT(frame, colonyBox)   
    GUILDINFO_COLONY_INIT_RADIO(colonyBox);
    --GUILDINFO_COLONY_INIT_INFO(colonyBox);
    GUILDINFO_COLONY_UPDATE_OCCUPY_INFO(frame);

    local showRewardBtn = 0;
    if session.colonytax.IsEnabledColonyTaxReward() == true then
        showRewardBtn = 1;
    end
    local colonyRewardBtn = GET_CHILD_RECURSIVELY(colonyBox, "colonyRewardBtn");
    colonyRewardBtn:ShowWindow(showRewardBtn);
end

function GUILDINFO_COLONY_HELP_CLICK(parent, ctrl)
    local piphelp = ui.GetFrame("piphelp");
	PIPHELP_MSG(piphelp, "FORCE_OPEN", 'None', 550);
end

function GUILDINFO_COLONY_ENTER_CONFIG(parent, ctrl)
    local isLeader = AM_I_LEADER(PARTY_GUILD);
	if 0 == isLeader then
		ui.SysMsg(ScpArgMsg("OnlyLeaderAbleToDoThis"));
        GUILDINFO_COLONY_INIT_RADIO(parent);
		return;
	end

--    local templerCls = GetClass('Job', 'Char1_16');
--    if IS_EXIST_JOB_IN_HISTORY(templerCls.ClassID) == false then
--        ui.SysMsg(ClMsg('TgtDonHaveTmpler'));
--        GUILDINFO_COLONY_INIT_RADIO(parent);
--        return;
--    end

    local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        GUILDINFO_COLONY_INIT_RADIO(parent);
        return;
    end

    local changeValue = GET_RADIOBTN_NUMBER(ctrl);
    if changeValue == 0 and session.colonywar.GetOccupationInfoByGuildID(guild.info:GetPartyID()) ~= nil then
        ui.SysMsg(ClMsg('CannotChangeConfigBecauseOccupation'));
        GUILDINFO_COLONY_INIT_RADIO(parent);
        return;
    end

    local yesscp = string.format('control.CustomCommand("CHANGE_COLONY_CONFIG", %d)', changeValue);
    local clmsg = '';
    if changeValue == 1 then
        clmsg = ScpArgMsg('ReallyChangeColonyEnterConfigTo{VALUE}', 'VALUE', ClMsg('Auto_ChamKa'));
    else
        clmsg = ScpArgMsg('ReallyChangeColonyEnterConfigTo{VALUE}', 'VALUE', ClMsg('NotJoin'));
    end
    ui.MsgBox(clmsg, yesscp, 'GUILDINFO_COLONY_INIT_RADIO()');
end

function GUILDINFO_COLONY_INIT_RADIO(colonyBox)
    local guildObj = GET_MY_GUILD_OBJECT();
    if guildObj == nil then
        return;
    end    

       colonyBox = ui.GetFrame('guildinfo');

    local currentConfigValue = guildObj.EnableEnterColonyWar;
    local radioBtn = GET_CHILD_RECURSIVELY(colonyBox, 'joinRadio_'..currentConfigValue);
    radioBtn:Select();
end

function GUILDINFO_COLONY_UPDATE_OCCUPY_INFO(frame, msg, argStr, argNum)
    local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        return;
    end
	local cls = GetClass("SharedConst", "COLONY_WAR_OPEN");
	local curValue = TryGetProp(cls, "Value")
	if curValue == 0 then
	    return;
	end

    GUILDINFO_COLONY_CHECK_COLUMN_NAME(frame)
    local colonizedCityText = GET_CHILD_RECURSIVELY(frame, 'colonizedCityText')

    local marketPercentList = GET_COLONY_MARKET_PERCENTAGE_LIST()
    local citiesByOccupiedzoneText = ''
    for i=1, #marketPercentList do
        local info = marketPercentList[i]
        citiesByOccupiedzoneText = citiesByOccupiedzoneText .. ScpArgMsg('ColonyTaxCity{Colony}{City}', 'Colony', info['MapName'], 'City', info['CityName'])
        if i < #marketPercentList then
            citiesByOccupiedzoneText = citiesByOccupiedzoneText .. ', '
        end
    end
    local occupationText = ScpArgMsg('ColonyTaxCityDetail', 'Cities', citiesByOccupiedzoneText)
    colonizedCityText:SetTextTooltip(occupationText)
    
    local colonizedCityTaxText = GET_CHILD_RECURSIVELY(frame, 'colonizedCityTaxText')
    colonizedCityTaxText:SetTextTooltip(ScpArgMsg('ColonyTaxCityTaxDetail'))
    local colonizedMarketTaxText = GET_CHILD_RECURSIVELY(frame, 'colonizedMarketTaxText')
    
    local citiesText = ''
    for i=1, #marketPercentList do
        local info = marketPercentList[i]
        citiesText = citiesText .. ScpArgMsg('ColonyTaxCityMarket{Colony}{Percent}', 'Colony', info['MapName'], 'Percent', info['Percent'])
        if i < #marketPercentList then
            citiesText = citiesText .. ', '
        end
    end

    local marketText = ScpArgMsg('ColonyTaxMarketTaxDetail{Cities}', 'Cities', citiesText)
    colonizedMarketTaxText:SetTextTooltip(marketText)
    local occupyInfoBox = GET_CHILD_RECURSIVELY(frame, 'occupyInfoBox');
    occupyInfoBox:RemoveAllChild();
    
    if session.colonywar.GetProgressState() then
        GUILDINFO_COLONY_UPDATE_OCCUPY_INFO_BY_COLONY_OCCUPATION(occupyInfoBox)
    else
        GUILDINFO_COLONY_UPDATE_OCCUPY_INFO_BY_COLONY_TAX(occupyInfoBox)
    end
    GBOX_AUTO_ALIGN(occupyInfoBox, 0, 0, 0, true, false);
end

function GUILDINFO_COLONY_CHECK_COLUMN_NAME(frame)
    local colonizedCityText = GET_CHILD_RECURSIVELY(frame, 'colonizedCityText')
    local colonizedTaxRateText = GET_CHILD_RECURSIVELY(frame, 'colonizedTaxRateText')
    local colonizedCityTaxText = GET_CHILD_RECURSIVELY(frame, 'colonizedCityTaxText')
    local colonizedMarketTaxText = GET_CHILD_RECURSIVELY(frame, 'colonizedMarketTaxText')
    local colonyBetaTextSection = GET_CHILD_RECURSIVELY(frame, 'colonyBetaTextSection')
    local colonyInfoText = GET_CHILD_RECURSIVELY(colonyBetaTextSection, 'colonyInfoText')

    local showTaxText = 0;
    if session.colonytax.IsEnabledColonyTaxReward() == true then
        showTaxText = 1;
    end
    colonizedTaxRateText:ShowWindow(showTaxText);
    colonizedCityTaxText:ShowWindow(showTaxText);
    colonizedMarketTaxText:ShowWindow(showTaxText);

    if showTaxText == 0 then
        colonizedCityText:SetText(ClMsg("ColonyTax_ColumnMapGrade"))
        colonyInfoText:SetText(ClMsg("ColonyTax_InfoMapGrade"))
    else
        colonizedCityText:SetText(ClMsg("ColonyTax_ColumnColonyCity"))
        colonyInfoText:SetText(ClMsg("ColonyTax_InfoColonyCity"))
    end
end

function GUILDINFO_COLONY_UPDATE_OCCUPY_INFO_BY_COLONY_OCCUPATION(occupyInfoBox)
    local frame = occupyInfoBox:GetTopParentFrame();
    local COLONY_EVEN_SKIN = frame:GetUserConfig('COLONY_EVEN_SKIN');
    local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        return;
    end
    local myGuildID = guild.info:GetPartyID();

    local occupyCount = session.colonywar.GetOccupationInfoCount();    
    for i = 0, occupyCount - 1 do
        local occupyInfo = session.colonywar.GetOccupationInfoByIndex(i);
        if occupyInfo ~= nil then
            local mapID = occupyInfo:GetLocationID();
            local mapCls = GetClassByType('Map', mapID);
            if occupyInfo:GetGuildID() == myGuildID and mapCls ~= nil then
                local infoCtrlSet = occupyInfoBox:CreateOrGetControlSet('colony_occupy_info', 'OCCUPY_'..mapID, 0, 0);         
                GUILDINFO_COLONY_SET_OCCUPY_INFO_CTRLSET(infoCtrlSet, mapCls, true)
                if i % 2 == 1 then
                    local bgBox = infoCtrlSet:GetChild('bgBox');
                    bgBox:SetSkinName(COLONY_EVEN_SKIN);
                end
            end
        end
    end   
end

function GUILDINFO_COLONY_UPDATE_OCCUPY_INFO_BY_COLONY_TAX(occupyInfoBox)
    local frame = occupyInfoBox:GetTopParentFrame();
    local COLONY_EVEN_SKIN = frame:GetUserConfig('COLONY_EVEN_SKIN');
    local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        return;
    end
    local myGuildID = guild.info:GetPartyID();

    local count = session.colonytax.GetTaxRateCount();    
    for i = 0, count - 1 do
        local taxInfo = session.colonytax.GetTaxRateByIndex(i);
        if taxInfo ~= nil then
            local mapID = taxInfo:GetColonyMapID();
            local mapCls = GetClassByType('Map', mapID);
            if taxInfo:GetGuildID() == myGuildID and mapCls ~= nil then
                local infoCtrlSet = occupyInfoBox:CreateOrGetControlSet('colony_occupy_info', 'OCCUPY_'..mapID, 0, 0);         
                GUILDINFO_COLONY_SET_OCCUPY_INFO_CTRLSET(infoCtrlSet, mapCls, false)
                if i % 2 == 1 then
                    local bgBox = infoCtrlSet:GetChild('bgBox');
                    bgBox:SetSkinName(COLONY_EVEN_SKIN);
                end
            end
        end
    end 
end

function GUILDINFO_COLONY_SET_OCCUPY_INFO_CTRLSET(infoCtrlSet, mapCls, isColonyWarState)
    AUTO_CAST(infoCtrlSet)
    local mapNameText = infoCtrlSet:GetChild('mapNameText');
    mapNameText:SetText(mapCls.Name);
    local grade, rewardPercentage = GET_COLONY_MAP_GRADE_AND_PERCENTAGE(mapCls.QuestLevel);
    local gradeText = infoCtrlSet:GetChild('gradeText');
    gradeText:SetText(grade);

    local cityMapName = GET_COLONY_MAP_CITY(mapCls.ClassName)
    local cityMapCls = GetClass("Map", cityMapName)

    local cityText = infoCtrlSet:GetChild('cityText');
    cityText:SetText(cityMapCls.Name);
    
    local NO_VALUE = infoCtrlSet:GetUserConfig("NO_VALUE")
    local PERCENT = infoCtrlSet:GetUserConfig("PERCENT")
    local SILVER_ICON = infoCtrlSet:GetUserConfig("SILVER_ICON")
    local TAX_RATE_ICON = infoCtrlSet:GetUserConfig("TAX_RATE_ICON")

    local taxRateText = infoCtrlSet:GetChild('taxRateText');
    local cityTaxText = infoCtrlSet:GetChild('cityTaxText');
    local marketTaxText = infoCtrlSet:GetChild('marketTaxText');

    local taxRateStr = NO_VALUE
    local percentStr = ""
    local silverIconStr = ""
    local taxRateIconStr = ""
    local totalAmountStr = NO_VALUE
    local marketTaxStr = NO_VALUE
    
    if isColonyWarState == false then
        local taxRateInfo = session.colonytax.GetColonyTaxRate(cityMapCls.ClassID)
        if taxRateInfo ~= nil then
            taxRateStr = taxRateInfo:GetTaxRate()
            percentStr = PERCENT
            silverIconStr = SILVER_ICON
            taxRateIconStr = TAX_RATE_ICON
            totalAmountStr = GET_COMMAED_STRING(taxRateInfo:GetCachedTotalTax())
            local colonyCls = GET_COLONY_CLASS(mapCls.ClassName)
            marketTaxStr = ScpArgMsg('ColonyTaxCityMarketWeekly{Percent}', 'Percent', taxRateInfo:GetMarketRate())
        end
    end
    taxRateText:SetTextByKey("icon", taxRateIconStr);
    taxRateText:SetTextByKey("value", taxRateStr);
    taxRateText:SetTextByKey("percent", percentStr);
    cityTaxText:SetTextByKey("icon", silverIconStr);
    cityTaxText:SetTextByKey("value", totalAmountStr);
    marketTaxText:SetTextByKey("value", marketTaxStr);
    
    local showTaxText = 0;
    if session.colonytax.IsEnabledColonyTaxReward() == true then
        showTaxText = 1;
    end

    taxRateText:ShowWindow(showTaxText);
    cityTaxText:ShowWindow(showTaxText);
    marketTaxText:ShowWindow(showTaxText);

    if showTaxText == 0 then
        cityText:SetText(grade);
    end
end

function GUILDINFO_COLONY_INIT_INFO(colonyBox)
    local colonyBenefitInfoText = GET_CHILD_RECURSIVELY(colonyBox, 'colonyBenefitInfoText');
    local timeText = string.format('%s %02d:00', ClMsg('ClMsgDay_'..COLONY_REWARD_DAY), COLONY_REWARD_HOUR);
    colonyBenefitInfoText:SetTextByKey('time', timeText);
    colonyBenefitInfoText:SetTextByKey('maxReward', MAX_COLONY_REWARD_SILVER);
end