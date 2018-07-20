function ADVENTURE_BOOK_RANK(adventureBookFrame, rankingPageFrame)
    ADVENTURE_BOOK_RANK_INIT(rankingPageFrame);
    ADVENTURE_BOOK_RANK_EDIT_TEXTTOOLTIP(rankingPageFrame);
    ADVENTURE_BOOK_RANKING_PAGE_SELECT(adventureBookFrame, nil, rankingPageFrame:GetName(), 0);
end

function ADVENTURE_BOOK_RANK_EDIT_TEXTTOOLTIP(rankingPageFrame)
    local rankingName = rankingPageFrame:GetName();
    local adventureBookRankSearchEdit = GET_CHILD_RECURSIVELY(rankingPageFrame, 'adventureBookRankSearchEdit');
    if rankingName == 'page_adventureBookRanking' then
        adventureBookRankSearchEdit:SetTextTooltip(ClMsg('InputTeamNameForSearch'));
    elseif rankingName == 'page_upHillRanking' then
        adventureBookRankSearchEdit:SetTextTooltip(ClMsg('InputCharacterNameForSearch'));
    end
end

function ADVENTURE_BOOK_RANK_INIT(pageFrame)
    if pageFrame == 'page_upHillRanking' then
        ADVENTURE_BOOK_UPHILL_UPDATE_POINT(pageFrame);
    end
end

function ADVENTURE_BOOK_RANKING_SEARCH_BTN(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local rankingTab = GET_CHILD(topFrame, 'rankingTab');
    local searchIndex = rankingTab:GetSelectItemIndex();
    local categoryName = 'Initialization_point';
    local rankSet = GET_CHILD_RECURSIVELY(topFrame, 'adventureBookRankingSet');    
    if searchIndex == 2 then
        categoryName = 'UpHill';
        rankSet = GET_CHILD_RECURSIVELY(topFrame, 'upHillRankingSet');
    end
    local adventureBookRankSearchEdit = GET_CHILD_RECURSIVELY(rankSet, 'adventureBookRankSearchEdit');
    local searchText = adventureBookRankSearchEdit:GetText();
    if searchText == nil or searchText == '' then
        if searchIndex == 2 then
            ADVENTURE_BOOK_UPHILL_RANK_SELECT_PAGE(rankSet, 0);
        else
            ADVENTURE_BOOK_RANKING_PAGE_SELECT(topFrame, nil, nil, 0);
        end
        return;
    end
    topFrame:SetUserValue('ADVENTURE_BOOK_RANK_SEARCH', searchText);
    ReqAdventureBookRankingBySearch(categoryName, searchText);
end

function ON_ADVENTURE_BOOK_RANK_SEARCH(frame, msg, argStr, argNum)
    local searchName = frame:GetUserValue('ADVENTURE_BOOK_RANK_SEARCH');
    if searchName == 'None' then
        return;
    end
    if msg == 'ADVENTURE_BOOK_UPHILL_RANK_SEARCH' then
        local argList = StringSplit(argStr, ';');
        ADVENTURE_BOOK_UPHILL_RANKING_SHOW_BY_SEARCH(frame, searchName, argList[1], argNum, argList[2]);
        return;
    end
    ADVENTURE_BOOK_RANKING_SHOW_BY_SEARCH(frame, searchName, argStr, argNum);
end

function ADVENTURE_BOOK_RANKING_PAGE_SELECT(parent, ctrl, argStr, pageNum)
    local categoryName = 'Initialization_point';
    if argStr == '' then
        local rankingPageFrame = parent:GetParent();
        local rankingPageFrameName = rankingPageFrame:GetName();        
        if rankingPageFrameName == 'upHillRankingSet' then
            categoryName = 'UpHill';
        elseif rankingPageFrameName == 'teamBattleRankSet' then
            local pvpCls = GET_TEAM_BATTLE_CLASS();            
            worldPVP.RequestPVPRanking(pvpCls.ClassID, 0, -1, pageNum + 1, 0, '');
            return;
        end
    elseif argStr == 'page_upHillRanking' then
        categoryName = 'UpHill';
    elseif argStr == 'TeamBattle' then    
        local pvpCls = GET_TEAM_BATTLE_CLASS();
        worldPVP.RequestPVPRanking(pvpCls.ClassID, 0, -1, pageNum, 0, '');
        return;
    end
    ReqAdventureBookRanking(categoryName, pageNum);
    ADVENTURE_BOOK_RANK_PAGE_INIT(parent);
end

function ADVENTURE_BOOK_RANKING_SHOW_PAGE(adventureBookFrame, page)    
    local adventureBookRankingSet = GET_CHILD_RECURSIVELY(adventureBookFrame, 'adventureBookRankingSet');
    local EACH_RANK_SET_HEIGHT = tonumber(adventureBookRankingSet:GetUserConfig('EACH_RANK_SET_HEIGHT'));
    local pageCtrl = GET_CHILD(adventureBookRankingSet, 'control');
    pageCtrl:SetCurPage(page);

    local advBookConstCls = GetClass('AdventureBookConst', 'ADVENTURE_BOOK_RANK_PER_PAGE');
    local numPerPage = advBookConstCls.Value;
    local startRank = page * numPerPage;
    
    -- left box
    local rankBox_left = adventureBookRankingSet:GetChild('rankBox_left');
    DESTROY_CHILD_BYNAME(rankBox_left, 'ADVENTURE_BOOK_RANK_');
    local width = rankBox_left:GetWidth();
    for i = 0, numPerPage / 2 - 1 do
        local rankInfo = GetAdventureBookRankInfo(startRank + i);
        if rankInfo ~= nil then
            local rankSet = rankBox_left:CreateOrGetControlSet('journal_rank_set', 'ADVENTURE_BOOK_RANK_'..i, 0, 0);
            local txt_score = rankSet:GetChild('txt_score');
            local txt_name = rankSet:GetChild('txt_name');
            local txt_rank = rankSet:GetChild('txt_rank');
            txt_score:SetTextByKey('value', rankInfo.score);
            txt_rank:SetTextByKey('value', startRank + i + 1);
            txt_name:SetTextByKey('value', rankInfo:GetFamilyName());
            rankSet:Resize(width, EACH_RANK_SET_HEIGHT);
        end
    end
    GBOX_AUTO_ALIGN(rankBox_left, 0, 0, 0, true, false);    

    -- right box
    local rankBox_right = adventureBookRankingSet:GetChild('rankBox_right');
    DESTROY_CHILD_BYNAME(rankBox_right, 'ADVENTURE_BOOK_RANK_');
    for i = numPerPage / 2, numPerPage - 1 do
        local rankInfo = GetAdventureBookRankInfo(startRank + i);
        if rankInfo ~= nil then
            local rankSet = rankBox_right:CreateOrGetControlSet('journal_rank_set', 'ADVENTURE_BOOK_RANK_'..i, 0, 0);
            local txt_score = rankSet:GetChild('txt_score');
            local txt_name = rankSet:GetChild('txt_name');
            local txt_rank = rankSet:GetChild('txt_rank');
            txt_score:SetTextByKey('value', rankInfo.score);
            txt_rank:SetTextByKey('value', startRank + i + 1);
            txt_name:SetTextByKey('value', rankInfo:GetFamilyName());
            rankSet:Resize(width, EACH_RANK_SET_HEIGHT);
        end
    end
    GBOX_AUTO_ALIGN(rankBox_right, 0, 0, 0, true, false);
end

function ADVENTURE_BOOK_RANK_PAGE_INIT(frame)
    local topFrame = frame:GetTopParentFrame();
    local adventureBookRankingSet = GET_CHILD_RECURSIVELY(topFrame, 'adventureBookRankingSet');
    local pageCtrl = GET_CHILD(adventureBookRankingSet, 'control');
    local advBookConstCls = GetClass('AdventureBookConst', 'ADVENTURE_BOOK_RANK_PER_PAGE');
    local numPerPage = advBookConstCls.Value;
    local maxPage = GetAdventureBookTotalRankCount() / numPerPage + 1;
    if maxPage > 2000 then
        maxPage = 2000;
    end
    pageCtrl:SetMaxPage(maxPage);
end

function ADVENTURE_BOOK_RANKING_SHOW_BY_SEARCH(adventureBookFrame, name, rank, score)    
    local adventureBookRankingSet = GET_CHILD_RECURSIVELY(adventureBookFrame, 'adventureBookRankingSet');    
    local EACH_RANK_SET_HEIGHT = tonumber(adventureBookRankingSet:GetUserConfig('EACH_RANK_SET_HEIGHT'));
    local pageCtrl = GET_CHILD(adventureBookRankingSet, 'control');
    pageCtrl:SetCurPage(1);

    -- left box
    local rankBox_left = adventureBookRankingSet:GetChild('rankBox_left');
    DESTROY_CHILD_BYNAME(rankBox_left, 'ADVENTURE_BOOK_RANK_');
    local width = rankBox_left:GetWidth();
    local rankSet = rankBox_left:CreateOrGetControlSet('journal_rank_set', 'ADVENTURE_BOOK_RANK_'..name, 0, 0);
    local txt_score = rankSet:GetChild('txt_score');
    local txt_name = rankSet:GetChild('txt_name');
    local txt_rank = rankSet:GetChild('txt_rank');
    txt_score:SetTextByKey('value', score);
    txt_rank:SetTextByKey('value', rank + 1);
    txt_name:SetTextByKey('value', name);
    rankSet:Resize(width, EACH_RANK_SET_HEIGHT);

    -- right box
    local rankBox_right = adventureBookRankingSet:GetChild('rankBox_right');
    DESTROY_CHILD_BYNAME(rankBox_right, 'ADVENTURE_BOOK_RANK_');
end