--guildinfo_detail.lua
local json = require "json_imc"
local g_guildName = nil;
local g_guildIdx = nil;
function GUILDINFO_DETAIL_ON_INIT(guildData, emblemPath, info, guild_idx)

    local frame = ui.GetFrame("guildinfo_detail");
    local promoBox = GET_CHILD_RECURSIVELY(frame, "promoBox");
    promoBox:SetScrollPos(0)
    local memberList = GET_CHILD_RECURSIVELY(frame, "memberList");
    memberList:RemoveAllChild();
    local tabCtrl = GET_CHILD_RECURSIVELY(frame, "itembox");
    tabCtrl:SelectTab(0)
    if guild_idx ~= nil and guildData ~= nil then
        g_guildIdx = guild_idx;
        local name = guildData['name']
        local level = guildData['level']
        local introText = guildData['shortDesc']
        local memberListJson = info['memberList']
        local avgLevel = info['avgLv']
        local createdDate = info['createdTime']
        local leaderName = info['leaderName']

        local guildName = GET_CHILD_RECURSIVELY(frame, "name");
        guildName:SetText("{s18}" .. name);
        g_guildName = name;
        local guildlevel = GET_CHILD_RECURSIVELY(frame, "level")
        guildlevel:SetText("{s18}" .. level);

        local guildEmblem = GET_CHILD_RECURSIVELY(frame, "emblem")
        guildEmblem:SetImage("")


        if emblemPath == "None" then
            guildEmblem:SetImage('guildmark_slot')
        else
            guildEmblem:SetFileName(emblemPath);
        end

        local checkbox = GET_CHILD_RECURSIVELY(frame, "showMemberWithAccept")
        tolua.cast(checkbox, "ui::CCheckBox")
        checkbox:SetCheck(0)
        local guildDesc = GET_CHILD_RECURSIVELY(frame, "guildText")
        guildDesc:SetText(introText);
        
        local memberNum = GET_CHILD_RECURSIVELY(frame, "memberNumText")
        memberNum:SetText(#memberListJson);

        local avgTeamLv = GET_CHILD_RECURSIVELY(frame, "avgTeamLvlText")
        avgTeamLv:SetText(avgLevel);

        local date = GET_CHILD_RECURSIVELY(frame, "date")
        date:SetText(createdDate);

        local leader = GET_CHILD_RECURSIVELY(frame, "leader")
        leader:SetText(leaderName)

        local rowIndex = tostring(math.ceil(#memberListJson/2))
        local i=1
        local scrollPanel = GET_CHILD_RECURSIVELY(frame, "memberList")
        local memberIndex = 1;
        for i=1, rowIndex do
            local row = scrollPanel:CreateOrGetControlSet("guild_member_row", tostring(i), 0, 0);
            row:Resize(scrollPanel:GetWidth(), 50)
            
            local teamName1 = GET_CHILD_RECURSIVELY(row, "teamName1");
            teamName1:SetText(memberListJson[memberIndex]['name']);
            teamName1:SetUserValue("aid", memberListJson[memberIndex]['aid'])
            teamName1:SetUserValue("name",memberListJson[memberIndex]['name'])

            local level1 = GET_CHILD_RECURSIVELY(row, "team_lv1");
            level1:SetText(memberListJson[memberIndex]['team_lv']);
            level1:SetUserValue("team_lv", memberListJson[memberIndex]['team_lv']);

            local lv1 = GET_CHILD_RECURSIVELY(row, "lv1");
            lv1:SetText(memberListJson[memberIndex]['lv']);
            lv1:SetUserValue("lv", memberListJson[memberIndex]['lv'])
            memberIndex = memberIndex + 1;

            if memberIndex <= #memberListJson then
                local teamName2 = GET_CHILD_RECURSIVELY(row, "teamName2");
                teamName2:SetText(memberListJson[memberIndex]['name']);
                teamName2:SetUserValue("aid", memberListJson[memberIndex]['aid'])
                teamName2:SetUserValue("name", memberListJson[memberIndex]['name'])
                
                local level2 = GET_CHILD_RECURSIVELY(row, "team_lv2");
                level2:SetText(memberListJson[memberIndex]['team_lv']);
                level2:SetUserValue("team_lv", memberListJson[memberIndex]['team_lv']);
                
                local lv2 = GET_CHILD_RECURSIVELY(row, "lv2");
                lv2:SetText(memberListJson[memberIndex]['lv']);
                lv2:SetUserValue("lv", memberListJson[memberIndex]['lv'])
                memberIndex = memberIndex + 1;

            end
            --row:Invalidate()
        end
        GetIntroductionImage("GET_INTRO_IMAGE", guild_idx);

        frame:ShowWindow(1)
    end
end

function GET_INTRO_IMAGE(code, ret_json)
    if ret_json ~= "" and ret_json ~= g_guildIdx then
        return -- 이전 길드 페이지 요청하자마자 페이지 닫고
    end        -- 다른 길드를 보는중에 응답이 와서 배경에 깔리는 일이 있음.
    local frame = ui.GetFrame("guildinfo_detail");
    local tabCtrl = GET_CHILD_RECURSIVELY(frame, "itembox");
    local promoPic = GET_CHILD_RECURSIVELY(frame, "promoPicture");
    promoPic:SetImage("")
    if code ~= 200 then
        if code == 400 then
            tabCtrl:SetTabVisible(1, false);
            tabCtrl:SelectTab(0)
        else
            SHOW_GUILD_HTTP_ERROR(code, ret_json, "GET_INTRO_IMAGE")
        end
        return
    end 
    tabCtrl:SetTabVisible(1, true);
    tabCtrl:SelectTab(1);
    local introPath = filefind.GetBinPath("GuildIntroImage"):c_str()
    introPath = introPath .. "\\" .. ret_json .. ".png"
    promoPic:SetFileName(introPath)
    promoPic:Resize(promoPic:GetImageWidth(), promoPic:GetImageHeight())

end

function GUILDINFO_DETAIL_OPEN(addon, frame)
    local parentFrame = ui.GetFrame("guild_rank_info")
    if parentFrame:IsVisible() == 0 then
        return;
    end
    local detail = ui.GetFrame("guildinfo_detail");
  
    local tabCtrl = GET_CHILD_RECURSIVELY(detail, "itembox")
    tabCtrl:SelectTab(0);

    local intro = GET_CHILD_RECURSIVELY(detail, "intro");
    intro:ShowWindow(1)
    local btn = GET_CHILD_RECURSIVELY(detail, "joinBtn");

	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
    if pcparty == nil then
        btn:SetEnable(1)
    else
        btn:SetEnable(0)
    end
   
    
end

function OPEN_REQUEST_GUILDJOIN()
    local appliedGuildList = GET_GUILD_APPLICATION_LIST_JSONDATA();
    local resume = appliedGuildList[g_guildIdx];
    if resume ~= nil and resume == 1 then
        ui.MsgBox(ClMsg("GuildDeclined"))
        return;
    end

    local joinFrame = ui.GetFrame("guild_join");
    joinFrame:ShowWindow(1);
    local txtCtrl = GET_CHILD_RECURSIVELY(joinFrame, "input");
    txtCtrl:SetText("")
    local btn = GET_CHILD_RECURSIVELY(joinFrame, "sendBtn");
    local guildLabel =  GET_CHILD_RECURSIVELY(joinFrame, "guildText");
    guildLabel:SetText(g_guildName);
    btn:SetEventScript(ui.LBUTTONUP, "SEND_JOIN_REQ")
end

function SEND_JOIN_REQ(frame, control)
    local joinFrame = ui.GetFrame("guild_join");
    local txtCtrl = GET_CHILD_RECURSIVELY(joinFrame, "input");

	local account = session.barrack.GetCurrentAccount();
    local teamLvl = account:GetTeamLevel();
    local charList = GetCharacterNameList();
    local charCount = #charList;
    local mylevel = info.GetLevel(session.GetMyHandle());
    local badword = IsBadString(txtCtrl:GetText());
    if badword ~= nil then
		ui.MsgBox(ScpArgMsg('{Word}_FobiddenWord','Word',badword, "None", "None"));
		return;
	end
    PutGuildApplicationRequest('ON_GUILDJOIN_REQUEST_SUCCESS', g_guildIdx,tostring(teamLvl), tostring(charCount), tostring(GetAdventureBookMyRank()), tostring(mylevel), txtCtrl:GetText())
    joinFrame:ShowWindow(0)
end
function ON_GUILDJOIN_REQUEST_SUCCESS(code, ret_json)
    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "ON_GUILDJOIN_REQUEST_SUCCESS")
        return
    end
    ui.MsgBox(ClMsg("GuildJoined"))
end

function GUILDINFO_DETAIL_CLOSE(frame)
    local frame = ui.GetFrame("guildinfo_detail");
    local promoPic = GET_CHILD_RECURSIVELY(frame, "promoPicture");
    promoPic:SetImage("")
    
    local tabCtrl = GET_CHILD_RECURSIVELY(frame, "itembox")
    tabCtrl:SelectTab(0);
    
    local guildEmblem = GET_CHILD_RECURSIVELY(frame, "emblem")
    guildEmblem:SetImage("")

    ui.CloseFrame("guild_join")
end

function SHOW_GUILD_MEMBER_WITH_ACCEPT_AUTH(parent, control)
    if g_guildIdx == nil then
        return
    end
    local frame = ui.GetFrame("guildinfo_detail");
    local scrollPanel = GET_CHILD_RECURSIVELY(frame, "memberList")
    local rowIndex = scrollPanel:GetChildCount();
    tolua.cast(control, "ui::CCheckBox")
    if control:IsChecked() == 1 then
        GetOnlineInvitationClaimMembers("ON_ONLINE_GUILDMEMBER_GET", g_guildIdx);
    else
        for i=1, rowIndex do
            local row = scrollPanel:GetControlSet("guild_member_row", tostring(i));
            if row ~= nil then
                SET_ENABLE_GUILDINFO_DETAIL_ROW(row, 1, 0)
                SET_ENABLE_GUILDINFO_DETAIL_ROW(row, 2, 0)
            end
        end
    end
end


function ON_ONLINE_GUILDMEMBER_GET(code, ret_json)
    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "ON_ONLINE_GUILDMEMBER_GET")
        return
    end
    
    local frame = ui.GetFrame("guildinfo_detail");
    local parsedJson = json.decode(ret_json)
    local jsonIndex=1
    local i=1
    local guildMemberAuthTable ={}
    for i=1, #parsedJson do
        guildMemberAuthTable[tostring(parsedJson[i]["aid"])] = true
    end


    local scrollPanel = GET_CHILD_RECURSIVELY(frame, "memberList")
    local rowIndex = scrollPanel:GetChildCount();
    for i=1, rowIndex do
        local row = scrollPanel:GetControlSet("guild_member_row", tostring(i));
        if row ~= nil then
            local teamName1 = GET_CHILD_RECURSIVELY(row, "teamName1")
            if guildMemberAuthTable[tostring(teamName1:GetUserValue("aid"))] == true then
                SET_ENABLE_GUILDINFO_DETAIL_ROW(row, 1, 1)

            else
                SET_ENABLE_GUILDINFO_DETAIL_ROW(row, 1, 0)
            end

            local teamName2 = GET_CHILD_RECURSIVELY(row, "teamName2")
            if guildMemberAuthTable[tostring(teamName2:GetUserValue("aid"))] == true then
                SET_ENABLE_GUILDINFO_DETAIL_ROW(row, 2, 1)
            else
                SET_ENABLE_GUILDINFO_DETAIL_ROW(row, 2, 0)
            end
        end
    end
    
    local checkBox = GET_CHILD_RECURSIVELY(frame, "showMemberWithAccept")
    checkBox = AUTO_CAST(checkBox)

    if checkBox:IsChecked() == 1 and #parsedJson == 0 then
        ui.MsgBox(ClMsg("NoOneIsOnline"))
        checkBox:SetCheck(0)
end

end


function SET_ENABLE_GUILDINFO_DETAIL_ROW(row, index, enable)
    --local labelText =

    local teamName = GET_CHILD_RECURSIVELY(row, "teamName" .. index);
   -- teamName:SetEnable(enable)

    local team_lv = GET_CHILD_RECURSIVELY(row, "team_lv" .. index)
    --team_lv:SetEnable(enable)
        
    local lv = GET_CHILD_RECURSIVELY(row, "lv" .. index)
    --lv:SetEnable(enable)
    if teamName:GetUserValue("name") == "None" then
        return
    end
    local teamNameLabel = teamName:GetUserValue("name");
    local team_lvLabel = team_lv:GetUserValue("team_lv");
    local lvLabel = lv:GetUserValue("lv")
    if enable == 1 then
        team_lv:SetText("{@st66d_y}" .. team_lv:GetUserValue("team_lv"));

        teamNameLabel = "{@st66d_y}" .. teamNameLabel;
        team_lvLabel = "{@st66d_y}" .. team_lvLabel;
        lvLabel =  "{@st66d_y}" .. lvLabel;

    end
    teamName:SetText(teamNameLabel)
    team_lv:SetText(team_lvLabel)
    lv:SetText(lvLabel)
end