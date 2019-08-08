local json = require "json_imc"

local firstOpen = true;
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
    addon:RegisterMsg('GUILD_MEMBER_INFO_UPDATE', 'GUILDINFO_UPDATE_INFO');
	addon:RegisterMsg("GUILD_ENTER", "GUILDINFO_UPDATE_INFO");
	addon:RegisterMsg("GUILD_OUT", "ON_GUILD_OUT");
    addon:RegisterMsg('MYPC_GUILD_JOIN', 'GUILDINFO_OPEN_UI');
    addon:RegisterMsg('GUILD_PROPERTY_UPDATE', 'GUILDINFO_UPDATE_PROPERTY');    
    addon:RegisterMsg("GUILD_EMBLEM_UPDATE", 'ON_UPDATE_GUILD_EMBLEM');
    addon:RegisterMsg('COLONY_ENTER_CONFIG_FAIL', 'GUILDINFO_COLONY_INIT_RADIO');
    addon:RegisterMsg('COLONY_OCCUPATION_INFO_UPDATE', 'GUILDINFO_COLONY_UPDATE_OCCUPY_INFO');
    addon:RegisterMsg("GUILD_MASTER_REQUEST", "ON_GUILD_MASTER_REQUEST");
    addon:RegisterMsg("GUILD_JOINT_INV_ITEM_LIST", "ON_GUILD_JOINT_INV_ITEM_LIST_GET");
    addon:RegisterMsg("UPDATE_GUILD_MILEAGE", "ON_UPDATE_GUILD_MILEAGE");
    addon:RegisterMsg("UPDATE_GUILD_MILEAGE", "ON_UPDATE_GUILD_AGIT_INFO_GUILD_MILEAGE");
    addon:RegisterMsg("TOGGLEON_GUILD_NEUTRALITY", "GUILDINFO_WAR_INIT_CHECKBOX");
    addon:RegisterMsg('RECEIVE_GUILD_AGIT_INFO', 'INIT_GUILD_AGIT_FACILITY_INFO');
	addon:RegisterMsg("GUILD_MEMBER_PROP_UPDATE", "ON_UPDATE_GUILD_AGIT_INFO_GUILD_CONTRIBUTION");
	addon:RegisterMsg('START_GUILD_HOUSING_SHOP', 'RESET_GUILD_AGIT_FACILITY_INFO');
    firstOpen = true;
    g_ENABLE_GUILD_MEMBER_SHOW = false;
end

function UI_CHECK_GUILD_UI_OPEN(propname, propvalue)    
	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil then
		return 0;
	end
	return 1;
end


function GUILDINFO_OPEN_UI(frame)
    local myActor = GetMyActor();
    if myActor == nil or myActor:IsGuildExist() == false then
        return;
    end

    local frame = ui.GetFrame("guildinfo");
 
    GetClaimList("ON_CLAIM_GET")

    local mainTab = GET_CHILD_RECURSIVELY(frame, 'maintab');
    if firstOpen == true then

        --todo여기에 처음 로드할때만 요청할 바인드함수 추가
        GUILDINFO_OPTION_INIT(frame, frame);
        mainTab:SelectTab(0);
        firstOpen = false    
    end
	
	housing.RequestGuildAgitInfo("RECEIVE_GUILD_AGIT_INFO");

    GUILDINFO_COLONY_INIT(frame, frame)
    INIT_UI_BY_CLAIM();

    GUILDINFO_INIT_PROFILE(frame); 
    GUILDINFO_OPTION_INIT_SETTING_CLAIM_TAB();
    
	GetGuildInfo("GUILDINFO_GET");

    GUILD_APPLICANT_INIT()

    session.party.ReqGuildAsset();
    session.party.ReqMemberLogoutTime();

    GetGuildNotice("GUILDNOTICE_GET")
    
    local guildObj = GET_MY_GUILD_OBJECT();
    if guildObj.Level == nil or guildObj.Level < 8 then
        mainTab:SetTabVisible(6, false)
    else
        mainTab:SetTabVisible(6, true)
    end

end

function GUILDNOTICE_GET(code, ret_json)
    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "GUILDNOTICE_GET")
    end

    local frame = ui.GetFrame("guildinfo")
    local notifyText = GET_CHILD_RECURSIVELY(frame, 'noticeEdit');
    if notifyText:IsHaveFocus() == 0 then
        notifyText:SetText(ret_json)
        notifyText:Invalidate()
    end

end


function GUILDINFO_INIT_PROFILE(frame)
    local guild = session.party.GetPartyInfo(PARTY_GUILD);
     if guild == nil then
        GUILDINFO_FORCE_CLOSE_UI()
        return
    end

    local guildObj = GET_MY_GUILD_OBJECT();
    local guildInfoTab = GET_CHILD_RECURSIVELY(frame, "guildinfo_");
    local guildName = GET_CHILD_RECURSIVELY(frame, "guildname");
    guildName:SetTextByKey("name", guild.info.name);

    local guildLvl = GET_CHILD_RECURSIVELY(guildInfoTab, "guildLvl");
    guildLvl:SetTextByKey('level', guildObj.Level);
    

    -- leader name
    local masterText = GET_CHILD_RECURSIVELY(guildInfoTab, 'guildMasterName');
    local leaderAID = guild.info:GetLeaderAID();
	local list = session.party.GetPartyMemberList(PARTY_GUILD);
	local count = list:Count();
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);
		if leaderAID == partyMemberInfo:GetAID() then
			leaderName = partyMemberInfo:GetName();
            masterText:SetText("{@st66b}" .. leaderName .. "{/}");
            break;
		end
	end

    -- opening date
    local openText = GET_CHILD_RECURSIVELY(guildInfoTab, 'foundtxt');
    local openDate = imcTime.ImcTimeToSysTime(guild.info.createTime);
    local openDateStr = string.format('%04d.%02d.%02d', openDate.wYear, openDate.wMonth, openDate.wDay); -- yyyy.mm.dd
    openText:SetTextByKey('date', openDateStr);

    -- member
    local memberText = GET_CHILD_RECURSIVELY(guildInfoTab, 'memberNum');
    memberText:SetTextByKey('current', count);
    memberText:SetTextByKey('max',  guild:GetMaxGuildMemberCount());

    -- asset
   GUILDINFO_PROFILE_INIT_ASSET(guildInfoTab);

    -- emblem
    GUILDINFO_PROFILE_INIT_EMBLEM(frame);
end

function GUILDINFO_PROFILE_INIT_ASSET(frame)    
    local moneyText = GET_CHILD_RECURSIVELY(frame, 'guildFund');
    local guild = session.party.GetPartyInfo(PARTY_GUILD);    
    moneyText:SetText("{@st66b}" .. GET_COMMAED_STRING(guild.info:GetAssetAmount()) .. "{/}");
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
    _GUILDINFO_INIT_MEMBER_TAB(frame);
end

function GUILDINFO_FORCE_CLOSE_UI()
    local frame = ui.GetFrame("guildinfo");
    if frame ~= nil then
        if frame:IsVisible() == 1 then
            GUILDINFO_CLOSE_UI(frame)
        end
    end
end

function ON_GUILD_OUT(frame)
	frame:ShowWindow(0);
    ui.CloseFrame('guildinfo');

	local sysMenuFrame = ui.GetFrame("sysmenu");
	SYSMENU_CHECK_HIDE_VAR_ICONS(sysMenuFrame);
end

function GUILDINFO_CLOSE_UI(frame)    
    ui.CloseFrame('guildinven_send');
    ui.CloseFrame('guildemblem_change');
    ui.CloseFrame("loadimage")
    ui.CloseFrame("previewpicture")
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
    end
end

function GUILDINFO_PROFILE_INIT_EMBLEM(frame)
    local guildInfo = GET_MY_GUILD_INFO();
    local worldID = session.party.GetMyWorldIDStr();    
    local emblemImgName = guild.GetEmblemImageName(guildInfo.info:GetPartyID(),worldID);  
    local isRegisteredEmblem = session.party.IsRegisteredEmblem();
    DRAW_GUILD_EMBLEM(frame, false, isRegisteredEmblem, emblemImgName)
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
        local default_emblem = frame_guildInfo:GetUserConfig("DEFAULT_EMBLEM_IMAGE");
        
        local emblemBack = GET_CHILD_RECURSIVELY(frame_guildInfo, "emblem");

        local previewEmblem = GET_CHILD_RECURSIVELY(frame_guildInfo, 'emblemPreview');

        if isPreView == true then
            previewEmblem:SetImage("")
            previewEmblem:SetFileName(emblemName);
        else
            --길드 엠블렘 변경중. 창을 닫으면 자동으로 기존엠블렘으로 업데이트됨.
            local frame_emblemChange = ui.GetFrame("guildemblem_change");
            if frame_emblemChange ~= nil and frame_emblemChange:IsVisible() == 1 then
                return
            end
            emblemBack:SetImage("")
            previewEmblem:SetImage("")
            if emblemName ~= 'None' and isRegisteredEmblem == true then
                emblemBack:SetFileName(emblemName); 
                previewEmblem:SetFileName(emblemName);
            else          
                emblemBack:SetImage(default_emblem);
                previewEmblem:SetImage(default_emblem);
            end
            emblemBack:ShowWindow(1);
        end
        frame_guildInfo:Invalidate();
    end
end

function ON_UPDATE_GUILD_EMBLEM(frame,  msg, argStr, argNum)
   GUILDINFO_PROFILE_INIT_EMBLEM(frame)
end


function UI_TOGGLE_GUILD()
    if app.IsBarrackMode() == true then
		return;
    end
    if session.world.IsIntegrateServer() == true then
        ui.SysMsg(ScpArgMsg("CantUseThisInIntegrateServer"));
        return;
    end

    local guildinfo = session.GetGuildInfo();
    if guildinfo == nil then
        return;
    end
    g_ENABLE_GUILD_MEMBER_SHOW = true;
	ui.ToggleFrame('guildinfo');
end

function ON_GUILD_MASTER_REQUEST(frame, msg, argStr)
	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if nil == pcparty then
		return;
	end
	local leaderAID = pcparty.info:GetLeaderAID();
	local list = session.party.GetPartyMemberList(PARTY_GUILD);
	local count = list:Count();
	local leaderName = 'None'
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);
		if leaderAID == partyMemberInfo:GetAID() then
			leaderName = partyMemberInfo:GetName();
		end
	end

	local yesScp = string.format("ui.Chat('/agreeGuildMasterByWeb')");
	local noScp = string.format("ui.Chat('/disagreeGuildMaster')");
	ui.MsgBox(ScpArgMsg("DoYouWantGuildLeadr{N1}{N2}",'N1',leaderName,'N2', pcparty.info.name), yesScp, noScp);
end