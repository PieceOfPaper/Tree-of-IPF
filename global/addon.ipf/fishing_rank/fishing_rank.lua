function FISHING_RANK_ON_INIT(addon, frame)
   addon:RegisterMsg('FISHING_RANK_PAGE', 'ON_FISHING_RANK_PAGE');
end

function FISHING_RANK_OPEN()
    local frame = ui.GetFrame('fishing_rank');
    FISHING_RANK_COUNT(frame);
    frame:ShowWindow(1);
end

function FISHING_RANK_COUNT(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    topFrame:SetUserValue('RANK_CATEGORY', 'SuccessCount');
    FISHING_RANK_SELECT(topFrame, nil, nil, 0);
    FISHING_RANK_SHOW_PAGE(topFrame, 1, 0, 0);
end

function FISHING_RANK_GOLDEN_FISH(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    topFrame:SetUserValue('RANK_CATEGORY', 'GoldenFish');
    FISHING_RANK_SELECT(topFrame, nil, nil, 0);
    FISHING_RANK_SHOW_PAGE(topFrame, 0, 1, 0);
end

function FISHING_RANK_FISH_RUBBING(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    topFrame:SetUserValue('RANK_CATEGORY', 'FishRubbing');
    FISHING_RANK_SELECT(topFrame, nil, nil, 0);
    FISHING_RANK_SHOW_PAGE(topFrame, 0, 0, 1);
end

function FISHING_RANK_SHOW_PAGE(frame, showCount, showGoldenFish, showFishRubbing)
    local rankCount = frame:GetChild('rankCount');
    local rankGoldenFish = frame:GetChild('rankGoldenFish');    
    local rankFishRubbing = frame:GetChild('rankFishRubbing');    
    rankCount:ShowWindow(showCount);
    rankGoldenFish:ShowWindow(showGoldenFish);
    rankFishRubbing:ShowWindow(showFishRubbing);
end

function FISHING_RANK_SELECT(frame, page, str, num)
    local topFrame = frame:GetTopParentFrame();
    local rankType = topFrame:GetUserValue('RANK_CATEGORY');
    if rankType == 'None' then
        return;
    end
    Fishing.ReqFishingRank(rankType, num);
end

function ON_FISHING_RANK_PAGE(frame, msg, rankType, page)
    if rankType == 'SuccessCount' then
        FISHING_RANK_SHOW_COUNT_RANK(frame, page);
    elseif rankType == 'GoldenFish' then
        FISHING_RANK_SHOW_GOLDEN_FISH_RANK(frame, page);
    elseif rankType == 'FishRubbing' then
        FISHING_RANK_SHOW_FISH_RUBBING(frame, page);
    end
end

function FISHING_RANK_SHOW_COUNT_RANK(frame, page)
	local rankCount = GET_CHILD(frame, 'rankCount');
    local pageCtrl = GET_CHILD(rankCount, 'control');
    pageCtrl:SetCurPage(page);

    local startRank = page * WIKI_RANK_PER_PAGE;
    local bg_ctrls = GET_CHILD(rankCount, 'bg_ctrls');
    bg_ctrls:RemoveAllChild();
    
    for i = 0, WIKI_RANK_PER_PAGE - 1 do
        local rankInfo = FishingRank.GetCountRankInfo(startRank + i);
        if rankInfo ~= nil then
            local rankSet = bg_ctrls:CreateOrGetControlSet('journal_rank_set', 'FISHING_RANK_'..i, 0, 0);
            local txt_score = rankSet:GetChild('txt_score');
            local txt_name = rankSet:GetChild('txt_name');
            local txt_rank = rankSet:GetChild('txt_rank');
            txt_score:SetTextByKey('value', rankInfo.score);
            txt_rank:SetTextByKey('value', startRank + i + 1);
            txt_name:SetTextByKey('value', rankInfo:GetFamilyName());
        end
    end
    GBOX_AUTO_ALIGN(bg_ctrls, 0, 0, 0, true, false);    
end

function FISHING_RANK_SHOW_GOLDEN_FISH_RANK(frame, page)
    local rankGoldenFish = GET_CHILD(frame, 'rankGoldenFish');
    local pageCtrl = GET_CHILD(rankGoldenFish, 'control');
    pageCtrl:SetCurPage(page);

    local startRank = page * WIKI_RANK_PER_PAGE;
    local bg_ctrls = GET_CHILD(rankGoldenFish, 'bg_ctrls');
    bg_ctrls:RemoveAllChild();
    
    for i = 0, WIKI_RANK_PER_PAGE - 1 do
        local rankInfo = FishingRank.GetGoldenFishRankInfo(startRank + i);
        if rankInfo ~= nil then
            local rankSet = bg_ctrls:CreateOrGetControlSet('journal_rank_set', 'FISHING_RANK_'..i, 0, 0);
            local txt_score = rankSet:GetChild('txt_score');
            local txt_name = rankSet:GetChild('txt_name');
            local txt_rank = rankSet:GetChild('txt_rank');
            txt_score:SetTextByKey('value', rankInfo.score);
            txt_rank:SetTextByKey('value', startRank + i + 1);
            txt_name:SetTextByKey('value', rankInfo:GetFamilyName());            
        end
    end
    GBOX_AUTO_ALIGN(bg_ctrls, 0, 0, 0, true, false);	
end

function FISHING_RANK_SHOW_FISH_RUBBING(frame, page)
    local rankFishRubbing = GET_CHILD(frame, 'rankFishRubbing');
    local pageCtrl = GET_CHILD(rankFishRubbing, 'control');
    pageCtrl:SetCurPage(page);

    local startRank = page * WIKI_RANK_PER_PAGE;
    local bg_ctrls = GET_CHILD(rankFishRubbing, 'bg_ctrls');
    bg_ctrls:RemoveAllChild();
    
    for i = 0, WIKI_RANK_PER_PAGE - 1 do
        local rankInfo = FishingRank.GetFishRubbingRankInfo(startRank + i);
        if rankInfo ~= nil then
            local rankSet = bg_ctrls:CreateOrGetControlSet('journal_rank_set', 'FISHING_RANK_'..i, 0, 0);
            local txt_score = rankSet:GetChild('txt_score');
            local txt_name = rankSet:GetChild('txt_name');
            local txt_rank = rankSet:GetChild('txt_rank');
            txt_score:SetTextByKey('value', string.format("%.2f", rankInfo.score / 100));
            txt_rank:SetTextByKey('value', startRank + i + 1);
            txt_name:SetTextByKey('value', rankInfo:GetFamilyName());            
        end
    end
    GBOX_AUTO_ALIGN(bg_ctrls, 0, 0, 0, true, false);	
end

