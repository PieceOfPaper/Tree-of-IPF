function GUILDINFO_ON_INIT(addon, frame)
	addon:RegisterMsg("GUILD_NEUTRALITY_UPDATE", 'ON_GUILD_NEUTRALITY_UPDATE');
    addon:RegisterMsg('GUILD_UPDATE_PROFILE', 'ON_GUILD_UPDATE_PROFILE');
	addon:RegisterMsg("UPDATE_GUILD_ONE_SAY", "GUILDINFO_COMMUNITY_INIT_ONELINE");
    addon:RegisterMsg('UPDATE_GUILD_ASSET', 'ON_UPDATE_GUILD_ASSET');
    addon:RegisterMsg('GUILD_NEUTRALITY_ALARM_FAIL', 'GUILDINFO_WAR_INIT_CHECKBOX_ALARM');
	addon:RegisterMsg("GAME_START_3SEC", "GUILD_GAME_START_3SEC");
    addon:RegisterMsg("GUILD_WAREHOUSE_ITEM_ADD", "GUILDINFO_INVEN_UPDATE_INVENTORY");
    addon:RegisterMsg('GUILD_WAREHOUSE_ITEM_LIST', 'GUILDINFO_INVEN_UPDATE_INVENTORY');
    addon:RegisterMsg('GUILD_ASSET_LOG_UPDATE', 'ON_GUILD_ASSET_LOG');
    addon:RegisterMsg('GUILD_INFO_UPDATE', 'GUILDINFO_UPDATE_INFO');
	addon:RegisterMsg("GUILD_ENTER", "GUILDINFO_UPDATE_INFO");
	addon:RegisterMsg("GUILD_OUT", "GUILDINFO_CLOSE_UI");
    addon:RegisterMsg('MYPC_GUILD_JOIN', 'GUILDINFO_OPEN_UI');
    addon:RegisterMsg('GUILD_PROPERTY_UPDATE', 'GUILDINFO_UPDATE_PROPERTY');    
    addon:RegisterMsg("GUILD_EMBLEM_UPDATE", 'ON_UPDATE_GUILD_EMBLEM');
    addon:RegisterMsg('COLONY_ENTER_CONFIG_FAIL', 'GUILDINFO_COLONY_INIT_RADIO');
    addon:RegisterMsg('COLONY_OCCUPATION_INFO_UPDATE', 'GUILDINFO_COLONY_UPDATE_OCCUPY_INFO');
end

function UI_CHECK_GUILD_UI_OPEN(propname, propvalue)    
	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil then
		return 0;
	end
	return 1;
end

function GUILDINFO_OPEN_UI(frame)
    GUILDINFO_INIT_TAB(frame);
    GUILDINFO_INIT_PROFILE(frame); 
end

function GUILDINFO_INIT_PROFILE(frame)
    local guild = session.party.GetPartyInfo(PARTY_GUILD);
     if guild == nil then
        GUILDINFO_FORCE_CLOSE_UI()
        return
    end

    local guildObj = GET_MY_GUILD_OBJECT();
    local profileBox = GET_CHILD_RECURSIVELY(frame, 'profileBox');

    -- level and name
    local nameText = GET_CHILD_RECURSIVELY(profileBox, 'nameText');    
    nameText:SetTextByKey('level', guildObj.Level);
    nameText:SetTextByKey('name', guild.info.name);

    -- leader name
    local masterText = GET_CHILD_RECURSIVELY(profileBox, 'masterText');
    local leaderAID = guild.info:GetLeaderAID();
	local list = session.party.GetPartyMemberList(PARTY_GUILD);
	local count = list:Count();
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);
		if leaderAID == partyMemberInfo:GetAID() then
			leaderName = partyMemberInfo:GetName();
            masterText:SetTextByKey('name', leaderName);
            break;
		end
	end

    -- opening date
    local openText = GET_CHILD_RECURSIVELY(profileBox, 'openText');
    local openDate = imcTime.ImcTimeToSysTime(guild.info.createTime);
    local openDateStr = string.format('%04d.%02d.%02d', openDate.wYear, openDate.wMonth, openDate.wDay); -- yyyy.mm.dd
    openText:SetTextByKey('date', openDateStr);

    -- member
    local memberText = GET_CHILD_RECURSIVELY(profileBox, 'memberText');
    memberText:SetTextByKey('current', count);
    memberText:SetTextByKey('max',  guild:GetMaxGuildMemberCount());

    -- asset
   GUILDINFO_PROFILE_INIT_ASSET(frame);

    -- notice
    local notifyText = GET_CHILD_RECURSIVELY(profileBox, 'notifyText');
    notifyText:SetText(guild.info:GetNotice());

    -- introduce
    local introduceText = GET_CHILD_RECURSIVELY(profileBox, 'introduceText');
    introduceText:SetText(guild.info:GetProfile());

    -- embelem
    GUILDINFO_PROFILE_INIT_EMBLEM(frame);
end

function GUILDINFO_PROFILE_INIT_ASSET(frame)
    local profileBox = GET_CHILD_RECURSIVELY(frame, 'profileBox');
    local moneyText = GET_CHILD_RECURSIVELY(profileBox, 'moneyText');
    local guildObj = GET_MY_GUILD_OBJECT();
    local guildAsset = guildObj.GuildAsset;    
    if guildAsset == nil or guildAsset == 'None' then
        guildAsset = 0;
    end
    moneyText:SetTextByKey('money', GET_COMMAED_STRING(guildAsset));
end

function GUILDINFO_INIT_TAB(frame)
    local mainTab = GET_CHILD(frame, 'mainTab');
    mainTab:SelectTab(0);
end

function GET_MY_GUILD_INFO()
    return session.party.GetPartyInfo(PARTY_GUILD);
end

function GET_MY_GUILD_OBJECT()
    local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        GUILDINFO_FORCE_CLOSE_UI()
        return
    end

    local guildObj = GetIES(guild:GetObject());
    if guildObj == nil then
        return nil;
    end
    return guildObj;
end

function ON_GUILD_UPDATE_PROFILE(frame, msg, argStr, argNum)
    GUILDINFO_INIT_PROFILE(frame);
end

function ON_UPDATE_GUILD_ASSET(frame, msg, argStr, argNum)
    GUILDINFO_INIT_PROFILE(frame);
end

function GUILDINFO_UPDATE_INFO(frame, msg, argStr, argNum)    
    GUILDINFO_INIT_PROFILE(frame);
    GUILDINFO_INIT_MEMBER_TAB(frame);
end

function GUILDINFO_FORCE_CLOSE_UI()
    local frame = ui.GetFrame("guildinfo");
    if frame ~= nil then
        if frame:IsVisible() == 1 then
        
        GUILDINFO_CLOSE_UI(frame)
        end
    end
end

function GUILDINFO_CLOSE_UI(frame)    
    ui.CloseFrame('guildinven_send');
    ui.CloseFrame('guild_authority_popup');
    ui.CloseFrame('guildemblem_change');

    frame:ShowWindow(0);
end

function GUILDINFO_MOVE_START(frame)
    ui.CloseFrame('guild_authority_popup');
end

function GUILDINFO_UPDATE_PROPERTY(frame, msg, argStr, argNum)
    if argStr == 'EnableEnterColonyWar' then
        GUILDINFO_COLONY_INIT_RADIO(frame);
        return;
    elseif argStr == 'GuildOnlyAgit' then
        GUILDINFO_OPTION_INIT(frame, frame);
        return;
    elseif argStr == 'GuildAsset' then
        ON_UPDATE_GUILD_ASSET(frame, msg, argStr, argNum);
    end
end

function GUILDINFO_PROFILE_INIT_EMBLEM(frame)
    local guildInfo = GET_MY_GUILD_INFO();    
    local worldID = session.party.GetMyWorldIDStr();    
    local emblemImgName = guild.GetEmblemImageName(guildInfo.info:GetPartyID(),worldID);  
    local isRegisteredEmblem = session.party.IsRegisteredEmblem();
    DRAW_GUILD_EMBLEM(frame,false,  isRegisteredEmblem, emblemImgName)
    GUILDINFO_OPTION_UPDATE_EMBLEM(frame)
end 

function DRAW_GUILD_EMBLEM(frame, isPreView, isRegisteredEmblem, emblemName)
    local isOpenGuildInfoUI = false;
    local frame_guildInfo = ui.GetFrame("guildinfo");
    if frame_guildInfo ~= nil then
        if frame_guildInfo:IsVisible() == 1 then
            isOpenGuildInfoUI = true;
        end
    end

    if isOpenGuildInfoUI == true then
        local emblemFront = GET_CHILD_RECURSIVELY(frame_guildInfo, 'emblemPic_upload');
        local emblemBack = GET_CHILD_RECURSIVELY(frame_guildInfo, 'emblemPic');
        emblemFront:ShowWindow(0)
        emblemBack:ShowWindow(0);

        if isPreView == true then
            emblemFront:SetImage(""); -- clear clone image
            emblemFront:SetFileName(emblemName);
            emblemFront:ShowWindow(1); 
        else
            if isRegisteredEmblem == true and emblemName ~= 'None' then
                emblemBack:SetImage(emblemName); 
            else
                local default_emblem = frame_guildInfo:GetUserConfig("DEFAULT_EMBLEM_IMAGE");
                emblemBack:SetImage(default_emblem);
            end
            emblemBack:ShowWindow(1);
        end
        frame_guildInfo:Invalidate();
    end
end

function ON_UPDATE_GUILD_EMBLEM(frame,  msg, argStr, argNum)
   GUILDINFO_PROFILE_INIT_EMBLEM(frame)
end

function REGISTER_GUILD_EMBLEM(frame)
   GUILDEMBLEM_CHANGE_INIT(frame);
end

function UI_TOGGLE_GUILD()
    if app.IsBarrackMode() == true then
		return;
	end

	local guildinfo = session.GetGuildInfo();
	if guildinfo == nil then
		return;
	end
	ui.ToggleFrame('guildinfo');
end