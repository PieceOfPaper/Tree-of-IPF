local g_guildName = nil;
local g_guildIdx = nil;
function GUILDINFO_DETAIL_ON_INIT(guildData, emblemPath, info, guild_idx)

    local frame = ui.GetFrame("guildinfo_detail");
    local promoBox = GET_CHILD_RECURSIVELY(frame, "promoBox");
    promoBox:SetScrollPos(0)
    local memberList = GET_CHILD_RECURSIVELY(frame, "memberList");
    memberList:RemoveAllChild();

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
        guildEmblem:SetFileName(emblemPath);


        local guildDesc = GET_CHILD_RECURSIVELY(frame, "guildText")
        guildDesc:SetText(introText);

        local introTextCtrl = GET_CHILD_RECURSIVELY(frame, "introText")
        introTextCtrl:SetText(introText)
        
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
            local level1 = GET_CHILD_RECURSIVELY(row, "leveltext1");
            level1:SetText(memberListJson[memberIndex]['lv']);
            memberIndex = memberIndex + 1;

            if memberIndex <= #memberListJson then
                local teamName2 = GET_CHILD_RECURSIVELY(row, "teamName2");
                teamName2:SetText(memberListJson[memberIndex]['name']);
                local level2 = GET_CHILD_RECURSIVELY(row, "leveltext2");
                level2:SetText(memberListJson[memberIndex]['lv']);
                memberIndex = memberIndex + 1;

            end
        end
        GetIntroductionImage("GET_INTRO_IMAGE", guild_idx);

        frame:ShowWindow(1)
    end
end

function GET_INTRO_IMAGE(code, ret_json)
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

    GetGuildIndex("ON_GUILDINDEX_GET")
    
end

function ON_GUILDINDEX_GET(code, guild_idx)
    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, guild_idx, "ON_GUILDINDEX_GET")
        return
    end
    local joinFrame = ui.GetFrame("guildinfo_detail");
    local btn = GET_CHILD_RECURSIVELY(joinFrame, "joinBtn");
    if guild_idx ~= "0" then
        btn:SetEnable(0)
    else
        btn:SetEnable(1)
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

    ui.CloseFrame("guild_join")
end