function SOLODUNGEONSCOREBOARD_ON_INIT(addon, frame)
    addon:RegisterMsg("DO_SOLODUNGEON_SCOREBOARD_OPEN", "SOLODUNGEON_SCOREBOARD_OPEN");
end


function SOLODUNGEON_SCOREBOARD_OPEN(frame, msg, argStr, argNum)

    ui.OpenFrame("solodungeonscoreboard")
    
    SOLODUNGEON_SCOREBOARD_CLEAR();
    SOLODUNGEON_SCOREBOARD_SET_CUR_STAGE()
    SOLODUNGEON_SCOREBOARD_FILL_RANK_LISTS()
end

function SOLODUNGEON_SCOREBOARD_CLEAR()
    local frame = ui.GetFrame("solodungeonscoreboard")
    if frame == nil then 
        return
    end

    local rankGbox_all = GET_CHILD_RECURSIVELY(frame, "rankGbox_all")
    local rankGbox_warrior = GET_CHILD_RECURSIVELY(frame, "rankGbox_warrior")
    local rankGbox_wizard = GET_CHILD_RECURSIVELY(frame, "rankGbox_wizard")
    local rankGbox_archer = GET_CHILD_RECURSIVELY(frame, "rankGbox_archer")
    local rankGbox_cleric = GET_CHILD_RECURSIVELY(frame, "rankGbox_cleric")

    if rankGbox_all == nil or rankGbox_warrior == nil or rankGbox_wizard == nil or rankGbox_archer == nil or rankGbox_cleric == nil then
        return
    end

    rankGbox_all:RemoveAllChild()
    rankGbox_warrior:RemoveAllChild()
    rankGbox_wizard:RemoveAllChild()
    rankGbox_archer:RemoveAllChild()
    rankGbox_cleric:RemoveAllChild()

end

function SOLODUNGEON_SCOREBOARD_SET_CUR_STAGE()
    local frame = ui.GetFrame("solodungeonscoreboard")
    if frame == nil then 
        return
    end

    local stageScore = session.soloDungeon.GetStageScore()
    if stageScore == nil then
        return
    end

    local stage_max = GET_CHILD_RECURSIVELY(frame, "result_stage_max")
    local monster_max = GET_CHILD_RECURSIVELY(frame, "result_monster_max")
    local rank_max = GET_CHILD_RECURSIVELY(frame, "result_rank_max")
    local stage_now = GET_CHILD_RECURSIVELY(frame, "result_stage_now")
    local monster_now = GET_CHILD_RECURSIVELY(frame, "result_monster_now")
    local rank_now = GET_CHILD_RECURSIVELY(frame, "result_rank_now")

    stage_max:SetTextByKey("value", stageScore.highStage)
    monster_max:SetTextByKey("value", stageScore.highKillCount)
    rank_max:SetTextByKey("value", stageScore.highRanking)
    stage_now:SetTextByKey("value", stageScore.curStage)
    monster_now:SetTextByKey("value", stageScore.curKillCount)
    rank_now:SetTextByKey("value", stageScore.curRanking)

end


function SOLODUNGEON_SCOREBOARD_FILL_RANK_LISTS()
    local frame = ui.GetFrame("solodungeonscoreboard")
    if frame == nil then 
        return
    end

    local rankGbox_all = GET_CHILD_RECURSIVELY(frame, "rankGbox_all")
    local rankGbox_warrior = GET_CHILD_RECURSIVELY(frame, "rankGbox_warrior")
    local rankGbox_wizard = GET_CHILD_RECURSIVELY(frame, "rankGbox_wizard")
    local rankGbox_archer = GET_CHILD_RECURSIVELY(frame, "rankGbox_archer")
    local rankGbox_cleric = GET_CHILD_RECURSIVELY(frame, "rankGbox_cleric")
    local rankGbox_scout = GET_CHILD_RECURSIVELY(frame, "rankGbox_scout")
    if rankGbox_all ~= nil then
        --All
        SOLODUNGEON_SCOREBOARD_FILL_RANK_LIST(rankGbox_all, 0)
    end

    if rankGbox_warrior ~= nil then
        --Warrior
        SOLODUNGEON_SCOREBOARD_FILL_RANK_LIST(rankGbox_warrior, 1)
    end
    
    if rankGbox_wizard ~= nil then
        --wizard
        SOLODUNGEON_SCOREBOARD_FILL_RANK_LIST(rankGbox_wizard, 2)
    end
    
    if rankGbox_archer ~= nil then
        --archer
        SOLODUNGEON_SCOREBOARD_FILL_RANK_LIST(rankGbox_archer, 3)
    end
    
    if rankGbox_cleric ~= nil then
        --cleric
        SOLODUNGEON_SCOREBOARD_FILL_RANK_LIST(rankGbox_cleric, 4)
    end

    if rankGbox_scout ~= nil then
        --cleric
        SOLODUNGEON_SCOREBOARD_FILL_RANK_LIST(rankGbox_scout, 5)
    end

    -- tab item
    local tab_joblist = GET_CHILD_RECURSIVELY(frame, "tab_joblist");
    if tab_joblist ~= nil then
        tab_joblist:SetItemsFixWidth(120);
        tab_joblist:SetItemsAdjustFontSizeByWidth(120);
    end
end



function SOLODUNGEON_SCOREBOARD_FILL_RANK_LIST(gbox, ctrlType)
    -- SOLO_DUNGEON_MAX_RANK = 10
    -- col = 2 row = 5
    local col = 2
    local row = SOLO_DUNGEON_MAX_RANK / col
    for i = 0, col - 1 do
        for j = 0, row - 1 do
            local rank = i * row + j
            local rankGbox = gbox:CreateOrGetControlSet('solodungeon_result_rank', 'rankGbox_'..rank, 0, 0);
            rankGbox = tolua.cast(rankGbox, "ui::CControlSet")
            rankGbox:Move(rankGbox:GetWidth() * i, rankGbox:GetHeight() * j)

            local rankImage = GET_CHILD_RECURSIVELY(rankGbox, "rankImage")
            rankImage:SetImage(rankGbox:GetUserConfig("RANK_IMAGE_" .. rank + 1))

            local scoreInfo = session.soloDungeon.GetRankingByIndex(soloDungeonShared.ThisWeek, ctrlType, rank)
            if scoreInfo ~= nil then
                local teamNameText = GET_CHILD_RECURSIVELY(rankGbox, "teamNameText")
                local teamName = rank .. "team"
                
                local mySession = session.GetMyHandle()
                local myTeamName = info.GetFamilyName(mySession);
                if myTeamName == scoreInfo.familyName then
                    teamNameText:SetFontName(rankGbox:GetUserConfig("MYRANK_FONT"))
                end

                teamNameText:SetTextByKey("teamname", scoreInfo.familyName)
                local jobCount = scoreInfo:GetJobHistoryCount()
                local clearStageText = GET_CHILD_RECURSIVELY(rankGbox, "clearStageText")
                clearStageText:SetTextByKey("clearstage", scoreInfo.stage)
            end
        end
    end
end

function SOLODUNGEON_SCOREBOARD_MGAME_RETURN(frame)
    packet.ReqReturnOriginServer();
end
