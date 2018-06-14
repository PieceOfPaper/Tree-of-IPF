function SOLODUNGEONRANKINGPAGE_ON_INIT(addon, frame)
    addon:RegisterMsg("DO_SOLODUNGEON_RANKINGPAGE_OPEN", "SOLODUNGEON_RANKINGPAGE_OPEN");
    addon:RegisterOpenOnlyMsg("SOLO_DUNGEON_RANKING_RESET", "ON_SOLO_DUNGEON_RANKING_RESET");
    
   

end


function SOLODUNGEON_RANKINGPAGE_OPEN()
 --   local weekList = {"last", "this"}
 --   local ctrlTypeList = {"All", "Warrior", "Wizard", "Archer", "Cleric"}
    ui.OpenFrame("solodungeonrankingpage")
    for i = 0, 1 do
        for j = 0, 4 do
            SOLODUNGEON_RANKINGPAGE_CLEAR(j, i);
            SOLODUNGEON_RANKINGPAGE_FILL_RANK_LISTS(j, i)
        end
    end


    SOLODUNGEON_RANKINGPAGE_SHOW_THIS_WEEK()
end

function SOLODUNGEON_RANKINGPAGE_CLOSE()
    ui.CloseFrame("solodungeonrankingpage")
end


function SOLODUNGEON_RANKINGPAGE_CLEAR(ctrlType, week)
    local frame = ui.GetFrame("solodungeonrankingpage")
    if frame == nil then 
        return
    end

    local rankGbox = GET_CHILD_RECURSIVELY(frame, "rankGbox_" .. ctrlType .. "_" .. week)

    if rankGbox == nil then
        return
    end

    rankGbox:RemoveAllChild()

end


function SOLODUNGEON_RANKINGPAGE_FILL_RANK_LISTS(ctrlType, week)
    local frame = ui.GetFrame("solodungeonrankingpage")
    if frame == nil then 
        return
    end

    if ctrlType == nil then
        return
    end

    if week == nil then
        return
    end

    local rankGbox = GET_CHILD_RECURSIVELY(frame, "rankGbox_" .. ctrlType .. "_" .. week)
    if rankGbox ~= nil then
        SOLODUNGEON_RANKINGPAGE_FILL_RANK_LIST(rankGbox, ctrlType, week)
    end

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
    for week = 0, 1 do
        for ctrlType = 0, 4 do
            local rankGbox = GET_CHILD_RECURSIVELY(frame, "rankGbox_" .. ctrlType .. "_" .. week)
            if rankGbox ~= nil then
                SOLODUNGEON_RANKINGPAGE_FILL_GUILD_EMBLEM(rankGbox, ctrlType, week, guildIdx)
            end
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
            scoreInfo = session.soloDungeon.GetPrevRankingByIndex(ctrlType, rank)
        elseif week == 1 then
            scoreInfo = session.soloDungeon.GetCurrentRankingByIndex(ctrlType, rank)
        end
        if scoreInfo ~= nil then
            if guildIdx == scoreInfo:GetGuildIDStr() then
                SOLODUNGEON_RANKINGPAGE_FILL_GUILD_EMBLEM_GBOX(rankGbox, scoreInfo)
            end
        end
    end
    
    local myScoreInfo = nil;
    if week == 0 then 
        myScoreInfo = session.soloDungeon.GetPrevMyScore(ctrlType)
    elseif week == 1 then
        myScoreInfo = session.soloDungeon.GetCurrentMyScore(ctrlType)
    end
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

function SOLODUNGEON_RANKINGPAGE_FILL_RANK_LIST(gbox, ctrlType, week)
    -- SOLODUNGEON_MAX_RANK = 10
    -- col = 2 row = 5
 --   local col = 2
 --   local row = SOLODUNGEON_MAX_RANK / col

    -- loader 에서 ctrltype 으로 데이터 각각 가져오자
    -- ctrlType == 'All' 일때 다른처리

    local totalPosY = 0
    for i = 0, SOLO_DUNGEON_MAX_RANK - 1 do
        local rank = i + 1
        local rankGbox = gbox:CreateOrGetControlSet('solodungeon_page_rank', 'rankGbox_'..rank, 0, 0);
        if i % 2 == 1 then
            rankGbox:SetSkinName("chat_window_2")
        end

        rankGbox:ShowWindow(1)
        rankGbox:Move(0, rankGbox:GetHeight() * i)
        totalPosY = totalPosY + rankGbox:GetHeight()
        SOLODUNGEON_RANKINGPAGE_FILL_RANK_CTRL(rankGbox, ctrlType, i, week)
    end

    local skipGbox = gbox:CreateOrGetControlSet('solodungeon_page_rank', 'skipGbox', 0, 0)
    skipGbox:Move(0, totalPosY)
    totalPosY = totalPosY + skipGbox:GetHeight()


    local myScoreInfo = nil
    local myRank = "-"
    if week == 0 then 
        myScoreInfo = session.soloDungeon.GetPrevMyScore(ctrlType)
        myRank = session.soloDungeon.GetPrevMyRank(ctrlType)
    elseif week == 1 then
        myScoreInfo = session.soloDungeon.GetCurrentMyScore(ctrlType)
        myRank = session.soloDungeon.GetCurrentMyRank(ctrlType)
    end


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
    local scoreInfo = nil

    if week == 0 then 
        scoreInfo = session.soloDungeon.GetPrevRankingByIndex(ctrlType, rank)
    elseif week == 1 then
        scoreInfo = session.soloDungeon.GetCurrentRankingByIndex(ctrlType, rank)
    end

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
        for i = 1 , 3 do
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
       frame = ui.GetFrame("solodungeonrankingpage")
 --   local weekList = {"last", "this"}
  --  local ctrlTypeList = {"All", "Warrior", "Wizard", "Archer", "Cleric"}

    for i = 0, 4 do
        local rankGbox_lastWeek = GET_CHILD_RECURSIVELY(frame, "rankGbox_" .. i .. "_0")
        local rankGbox_thisWeek = GET_CHILD_RECURSIVELY(frame, "rankGbox_" .. i .. "_1")
        if rankGbox_lastWeek ~= nil then
            rankGbox_lastWeek:ShowWindow(frame:GetUserIValue("SHOW_LAST_WEEK"))
        end
        if rankGbox_thisWeek ~= nil then
            rankGbox_thisWeek:ShowWindow(frame:GetUserIValue("SHOW_THIS_WEEK"))
        end
    end
end

function SOLODUNGEON_RANKINGPAGE_SHOW_LAST_WEEK()
    local frame = ui.GetFrame("solodungeonrankingpage")

    frame:SetUserValue("SHOW_LAST_WEEK", 1)
    frame:SetUserValue("SHOW_THIS_WEEK", 0)

    SOLODUNGEON_RANKINGPAGE_SHOW_RANK_PAGE(frame)
end


function SOLODUNGEON_RANKINGPAGE_SHOW_THIS_WEEK()
    local frame = ui.GetFrame("solodungeonrankingpage")

    frame:SetUserValue("SHOW_LAST_WEEK", 0)
    frame:SetUserValue("SHOW_THIS_WEEK", 1)

    SOLODUNGEON_RANKINGPAGE_SHOW_RANK_PAGE(frame)
end

function SOLODUNGEON_RANKINGPAGE_GET_REWARD()
    soloDungeonClient.ReqSoloDungeonReward()
end


function ON_SOLO_DUNGEON_RANKING_RESET(frame)
    soloDungeonClient.ReqSoloDungeonRankingPage()
end