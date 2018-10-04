function SOLODUNGEONRANKINGPAGE_ON_INIT(addon, frame)
    addon:RegisterMsg("DO_SOLODUNGEON_RANKINGPAGE_OPEN", "SOLODUNGEON_RANKINGPAGE_OPEN");
    addon:RegisterOpenOnlyMsg("SOLO_DUNGEON_RANKING_RESET", "ON_SOLO_DUNGEON_RANKING_RESET");
end

function ON_SOLODUNGEON_RANKINGPAGE_CHANGE_TAB(parent, groupbox)
    local frame = parent:GetTopParentFrame();
    SOLODUNGEON_RANKINGPAGE_SHOW_RANK_PAGE(frame)
end

function SOLODUNGEON_RANKINGPAGE_OPEN(frame)
    SOLODUNGEON_RANKINGPAGE_SHOW_PERMANENT(frame)
    ui.OpenFrame("solodungeonrankingpage")
end

function SOLODUNGEON_RANKINGPAGE_CLOSE()
    ui.CloseFrame("solodungeonrankingpage")
end

function SOLODUNGEON_RANKINGPAGE_CLEAR(ctrlType)
    local frame = ui.GetFrame("solodungeonrankingpage")
    if frame == nil then 
        return
    end

    local rankGbox = GET_CHILD_RECURSIVELY(frame, "rankGbox_" .. ctrlType)
    if rankGbox == nil then
        return
    end

    rankGbox:RemoveAllChild()
end

function SOLODUNGEON_UPDATE_GUILD_EMBLEM_IMAGE(code, return_json)
    if code ~= 200 then
        if code == 400 or code == 404 then
            return
        else
            SHOW_GUILD_HTTP_ERROR(code, return_json, "SOLODUNGEON_UPDATE_GUILD_EMBLEM_IMAGE")
            return
        end
    end
    
    local guildIdx = return_json;
    local frame = ui.GetFrame("solodungeonrankingpage")
    local week = tonumber(frame:GetUserValue("Week"));
    for ctrlType = 0, 4 do
        local rankGbox = GET_CHILD_RECURSIVELY(frame, "rankGbox_" .. ctrlType)
        if rankGbox ~= nil then
            SOLODUNGEON_RANKINGPAGE_FILL_GUILD_EMBLEM(rankGbox, ctrlType, week, guildIdx)
        end
    end
    --update image 
    
end

function SOLODUNGEON_RANKINGPAGE_FILL_GUILD_EMBLEM(gbox, ctrlType, week, guildIdx)
    for i = 0, SOLO_DUNGEON_MAX_RANK - 1 do
        local rank = i + 1
        local rankGbox = gbox:GetControlSet('solodungeon_page_rank', 'rankGbox_'..rank);
        local scoreInfo = nil;
        if week == 0 then 
            scoreInfo = session.soloDungeon.GetRankingByIndex(soloDungeonShared.PrevWeek, ctrlType, rank)
        elseif week == 1 then
            scoreInfo = session.soloDungeon.GetRankingByIndex(soloDungeonShared.ThisWeek, ctrlType, rank)
        end
        if scoreInfo ~= nil then
            if guildIdx == scoreInfo:GetGuildIDStr() then
                SOLODUNGEON_RANKINGPAGE_FILL_GUILD_EMBLEM_GBOX(rankGbox, scoreInfo)
            end
        end
    end
    
    local myScoreInfo = session.soloDungeon.GetMyScore(week, ctrlType)
    local myrankGbox = gbox:GetControlSet('solodungeon_page_rank', 'myrankGbox')
    if myScoreInfo ~= nil then
        if guildIdx == myScoreInfo:GetGuildIDStr() then
            SOLODUNGEON_RANKINGPAGE_FILL_GUILD_EMBLEM_GBOX(myRankGBox, myScoreInfo)
        end
    end
end

function SOLODUNGEON_RANKINGPAGE_FILL_GUILD_EMBLEM_GBOX(rankGBox, scoreInfo)
    local emblemCtrl = GET_CHILD_RECURSIVELY(rankGBox, "guildEmblem")
    if emblemCtrl ~= nil then
        local worldID = session.party.GetMyWorldIDStr();
        local emblemImgName = guild.GetEmblemImageName(scoreInfo:GetGuildIDStr(), worldID);
        emblemCtrl:SetImage("");
        if emblemImgName ~= 'None' then           
            emblemCtrl:SetFileName(emblemImgName);
            emblemCtrl:Invalidate();
        end
    end
end

function GET_SOLODUNGEON_RANKINGPAGE_MAX_RANK(week)
    if week == soloDungeonShared.Permanent then
        return SOLO_DUNGEON_PERMANENT_MAX_RANK
    end
    return SOLO_DUNGEON_MAX_RANK
end

function GET_SOLODUNGEON_RANKINGPAGE_CTRL_WIDTH_DIFF(week)
    if week == soloDungeonShared.Permanent then
        local frame = ui.GetFrame("solodungeonrankingpage")
        return tonumber(frame:GetUserConfig("SCROLL_WIDTH"))
    end
    return 0
end

function ON_SCROLL_SOLODUNGEON_RANKINGPAGE(gbox, topGbox, str, wheel)
    local frame = gbox:GetTopParentFrame();
    local tab_joblist = GET_CHILD_RECURSIVELY(frame, "tab_joblist");
    local ctrlType = tab_joblist:GetSelectItemIndex();
    local week = tonumber(frame:GetUserValue("Week"));
    local eachHeight = ui.GetControlSetAttribute("solodungeon_page_rank", "height");

    local countPerPage = tonumber(frame:GetUserConfig("COUNT_PER_PAGE"));
    local weekMaxRank = GET_SOLODUNGEON_RANKINGPAGE_MAX_RANK(week)
    local wheelLoc = math.floor(wheel/eachHeight)+1
    local minRank = math.min(wheelLoc, weekMaxRank-countPerPage)
    local maxRank = minRank+countPerPage
    
    for i=1, weekMaxRank do
        local child = GET_CHILD(topGbox, "rankGbox_"..i)
        if child ~= nil then
            if i < minRank or i > maxRank then
                topGbox:RemoveChild("rankGbox_"..i)
            end
        end
    end
    SOLODUNGEON_RANKINGPAGE_FILL_RANKER_RANK(gbox, topGbox, ctrlType, week, minRank, maxRank)
end

function SOLODUNGEON_RANKINGPAGE_FILL_RANK_LIST(frame, ctrlType, week)
    local gbox = GET_CHILD_RECURSIVELY(frame, "rankGbox_" .. ctrlType)
    if gbox == nil then
        return;
    end

    local countPerPage = tonumber(frame:GetUserConfig("COUNT_PER_PAGE"));
    local eachHeight = ui.GetControlSetAttribute("solodungeon_page_rank", "height");
    local topGbox = gbox:CreateOrGetControl("groupbox", "top_rank_gbox", 0, 0, gbox:GetWidth(), eachHeight*countPerPage)
    AUTO_CAST(topGbox);
    topGbox:SetSkinName("none");

    local innerGbox = topGbox:CreateOrGetControl("groupbox", "inner_gbox", 0, 0, topGbox:GetWidth(), eachHeight*GET_SOLODUNGEON_RANKINGPAGE_MAX_RANK(week))
    AUTO_CAST(innerGbox);
    innerGbox:SetSkinName("none");
    innerGbox:EnableHitTest(0);
	innerGbox:EnableHittestGroupBox(false);

    if week == soloDungeonShared.Permanent then
        topGbox:SetScrollBarBottomMargin(0)
        topGbox:SetEventScript(ui.SCROLL, "ON_SCROLL_SOLODUNGEON_RANKINGPAGE");
    end

    local minRank = 1
    local countPerPage = tonumber(frame:GetUserConfig("COUNT_PER_PAGE"));
    SOLODUNGEON_RANKINGPAGE_FILL_RANKER_RANK(gbox, topGbox, ctrlType, week, minRank, countPerPage)
    SOLODUNGEON_RANKINGPAGE_FILL_SKIP_RANK(gbox, topGbox)
    SOLODUNGEON_RANKINGPAGE_FILL_MY_RANK(gbox, ctrlType, week);
end

function SOLODUNGEON_RANKINGPAGE_FILL_RANKER_RANK(gbox, topGbox, ctrlType, week, minRank, maxRank)
    local ctrlWidthDiff = GET_SOLODUNGEON_RANKINGPAGE_CTRL_WIDTH_DIFF(week);

    for i = minRank, maxRank do
        local rankGbox = topGbox:GetControlSet("solodungeon_page_rank", "rankGbox_"..i);
        if rankGbox == nil then
            rankGbox = topGbox:CreateControlSet("solodungeon_page_rank", "rankGbox_"..i, 0, 0);
            if i % 2 == 1 then
                rankGbox:SetSkinName("chat_window_2")
            end

            rankGbox:ShowWindow(1)
            rankGbox:Move(0, rankGbox:GetHeight() * (i-1))
            rankGbox:Resize(rankGbox:GetOriginalWidth()-ctrlWidthDiff, rankGbox:GetHeight())
            SOLODUNGEON_RANKINGPAGE_FILL_RANK_CTRL(rankGbox, ctrlType, i-1, week)
        end
    end
end

function SOLODUNGEON_RANKINGPAGE_FILL_SKIP_RANK(gbox, topGbox)
    local skipGbox = gbox:CreateOrGetControlSet("solodungeon_page_rank", "skipGbox", 0, 0)
    skipGbox:Move(0, skipGbox:GetHeight()*11)
end

function SOLODUNGEON_RANKINGPAGE_FILL_MY_RANK(gbox, ctrlType, week)
    local eachHeight = ui.GetControlSetAttribute("solodungeon_page_rank", "height");
    local totalPosY = eachHeight*11
    local myScoreInfo = session.soloDungeon.GetMyScore(week, ctrlType)
    local myRank = session.soloDungeon.GetMyRank(week, ctrlType)

    local myTeamName = GETMYFAMILYNAME()
    local myCharLv = "-"
    local cnt = 0
    local myStage = "-"
    local myKillCount = "-"
    if myScoreInfo ~= nil and myRank ~= 0 then
        myTeamName = myScoreInfo.familyName
        myCharLv = myScoreInfo.level
        cnt = myScoreInfo:GetJobHistoryCount()
        myStage = myScoreInfo.stage
        myKillCount = myScoreInfo.killCount
    end

    local myrankGbox = gbox:CreateOrGetControlSet('solodungeon_page_rank', 'myrankGbox', 0, 0)
    myrankGbox:Move(0, totalPosY)
    myrankGbox:SetSkinName("none")
    local rankText = GET_CHILD_RECURSIVELY(myrankGbox, "rankText")
    rankText:SetTextByKey("rank", myRank)

    local teamNameText = GET_CHILD_RECURSIVELY(myrankGbox, "teamNameText")    
    teamNameText:SetTextByKey("teamname", myTeamName)

    local charLevelText = GET_CHILD_RECURSIVELY(myrankGbox, "charLevelText")
    charLevelText:SetTextByKey("charlevel", myCharLv)

    local guildNameText = GET_CHILD_RECURSIVELY(myrankGbox, "guildNameText")
    guildNameText:SetTextByKey("guildname", myScoreInfo.guildName);

    local emblemCtrl = GET_CHILD_RECURSIVELY(myrankGbox, "guildEmblem")
    if emblemCtrl ~= nil then
        local worldID = session.party.GetMyWorldIDStr();
        local emblemImgName = guild.GetEmblemImageName(myScoreInfo:GetGuildIDStr(), worldID);
        emblemCtrl:SetImage("");
        if emblemImgName ~= 'None' then           
            emblemCtrl:SetFileName(emblemImgName);
            emblemCtrl:Invalidate();
        else
            if myScoreInfo:GetGuildIDStr() ~= "0" then
                GetGuildEmblemImage("SOLODUNGEON_UPDATE_GUILD_EMBLEM_IMAGE", myScoreInfo:GetGuildIDStr())
            end
        end
    end

    local jobTreeGbox = GET_CHILD_RECURSIVELY(myrankGbox, "jobTreeGbox")
    for i = 0, cnt - 1 do
        local jobID = myScoreInfo:GetJobHistoryByIndex(i)
        local jobCls = GetClassByType("Job", jobID)
        if jobCls ~= nil then
            local icon = jobCls.Icon
            if icon ~= nil then
                local rankImage = jobTreeGbox:CreateOrGetControl("picture", "rankImage_" .. i + 1, 35 * i, 0, 35, 35)
                rankImage = tolua.cast(rankImage, "ui::CPicture")
                rankImage:SetImage(icon)
                rankImage:SetEnableStretch(1);
            end
        end
    end

    local maxStageText = GET_CHILD_RECURSIVELY(myrankGbox, "maxStageText")
    maxStageText:SetTextByKey("maxstage", myStage)

    local killMonsterText = GET_CHILD_RECURSIVELY(myrankGbox, "killMonsterText")
    killMonsterText:SetTextByKey("killmonster", myKillCount)
end

function SOLODUNGEON_RANKINGPAGE_FILL_RANK_CTRL(rankGbox, ctrlType, rank, week)
    AUTO_CAST(rankGbox)
    local emblemSlotImageName = rankGbox:GetUserConfig("GUILD_EMBLEM_SLOT");
    local scoreInfo = session.soloDungeon.GetRankingByIndex(week, ctrlType, rank)

    if scoreInfo == nil then
        return
    end
    
    local rankText = GET_CHILD_RECURSIVELY(rankGbox, "rankText")
    rankText:SetTextByKey("rank", rank + 1)

    local teamNameText = GET_CHILD_RECURSIVELY(rankGbox, "teamNameText")
    teamNameText:SetTextByKey("teamname", scoreInfo.familyName)

    local charLevelText = GET_CHILD_RECURSIVELY(rankGbox, "charLevelText")
    charLevelText:SetTextByKey("charlevel", scoreInfo.level)

    local guildNameText = GET_CHILD_RECURSIVELY(rankGbox, "guildNameText")
    guildNameText:SetTextByKey("guildname", scoreInfo.guildName);

    local emblemCtrl = GET_CHILD_RECURSIVELY(rankGbox, "guildEmblem")
    if emblemCtrl ~= nil then
        local worldID = session.party.GetMyWorldIDStr();
        local emblemImgName = guild.GetEmblemImageName(scoreInfo:GetGuildIDStr(), worldID);
        emblemCtrl:SetImage(emblemSlotImageName);
        if emblemImgName ~= 'None' then           
            emblemCtrl:SetFileName(emblemImgName);
            emblemCtrl:Invalidate();
        else
            if scoreInfo:GetGuildIDStr() ~= "0" then
                GetGuildEmblemImage("SOLODUNGEON_UPDATE_GUILD_EMBLEM_IMAGE", scoreInfo:GetGuildIDStr())
            end
        end
    end

    local cnt = scoreInfo:GetJobHistoryCount()

    local jobTreeList = {}
    local jobTreeGbox = GET_CHILD_RECURSIVELY(rankGbox, "jobTreeGbox")
    for i = 0, cnt - 1 do
        local jobID = scoreInfo:GetJobHistoryByIndex(i)
        local jobCls = GetClassByType("Job", jobID)
        if jobCls ~= nil then
            local icon = jobCls.Icon
            if icon ~= nil then
                local rankImage = jobTreeGbox:CreateOrGetControl("picture", "rankImage_" .. i + 1, 35 * i, 0, 35, 35)
                rankImage = tolua.cast(rankImage, "ui::CPicture")
                rankImage:SetImage(icon)
                rankImage:SetEnableStretch(1);
                rankImage:EnableHitTest(0)

                if jobTreeList[jobID] == nil then
                    jobTreeList[jobID] = 1
                else
                    jobTreeList[jobID] = jobTreeList[jobID] + 1
                end
            end
        end
    end

    local startext = "";
    for jobid, grade in pairs(jobTreeList) do
        -- 클래스 이름{@st41}
        local jobCls = GetClassByType("Job", jobid)

        local jobName = TryGetProp(jobCls, "Name")
        startext = startext .. ("{@st41}").. jobName
        
        -- 클래스 레벨 (★로 표시)               
        local maxCircle = GET_JOB_MAX_CIRCLE(jobCls);
        for i = 1 , maxCircle do
            if i <= grade then
                startext = startext ..('{img star_in_arrow 20 20}');
            else
                startext = startext ..('{img star_out_arrow 20 20}');
            end
        end
        startext = startext ..('{nl}');
    end

    jobTreeGbox:SetTextTooltip(startext);


    local maxStageText = GET_CHILD_RECURSIVELY(rankGbox, "maxStageText")
    maxStageText:SetTextByKey("maxstage", scoreInfo.stage)

    local killMonsterText = GET_CHILD_RECURSIVELY(rankGbox, "killMonsterText")
    killMonsterText:SetTextByKey("killmonster", scoreInfo.killCount)
end

function SOLODUNGEON_RANKINGPAGE_SHOW_RANK_PAGE(frame)
    local tab_joblist = GET_CHILD_RECURSIVELY(frame, "tab_joblist");
    local tabIndex = tab_joblist:GetSelectItemIndex();
    SOLODUNGEON_RANKINGPAGE_CLEAR(tabIndex);
    SOLODUNGEON_RANKINGPAGE_FILL_RANK_LIST(frame, tabIndex, tonumber(frame:GetUserValue("Week")))
end

function SOLODUNGEON_RANKINGPAGE_SHOW_PERMANENT(parent, btn)
    local frame = parent:GetTopParentFrame();
    frame:SetUserValue("Week", soloDungeonShared.Permanent)
    SOLODUNGEON_RANKINGPAGE_SHOW_RANK_PAGE(frame)
end

function SOLODUNGEON_RANKINGPAGE_SHOW_PREV_WEEK(parent, btn)
    local frame = parent:GetTopParentFrame();
    frame:SetUserValue("Week", soloDungeonShared.PrevWeek)
    SOLODUNGEON_RANKINGPAGE_SHOW_RANK_PAGE(frame)
end


function SOLODUNGEON_RANKINGPAGE_SHOW_THIS_WEEK(parent, btn)
    local frame = parent:GetTopParentFrame();
    frame:SetUserValue("Week", soloDungeonShared.ThisWeek)
    SOLODUNGEON_RANKINGPAGE_SHOW_RANK_PAGE(frame)
end

function SOLODUNGEON_RANKINGPAGE_GET_REWARD()
    soloDungeonClient.ReqSoloDungeonReward()
end


function ON_SOLO_DUNGEON_RANKING_RESET(frame)
    soloDungeonClient.ReqSoloDungeonRankingPage()
end