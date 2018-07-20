function ADVENTURE_BOOK_MAIN_INIT(parent, mainPage, showReward)
    ReqAdventureBookRankingForMainPage();

    ADVENTURE_BOOK_MAIN_INIT_MY_CHAR_INFO(mainPage);
    ADVENTURE_BOOK_MAIN_INIT_POINT_GAGUE(parent);

    if showReward ~= 'None' then
        mainPage:SetUserValue('SHOW_REWARD', showReward);
    end
    ADVENTURE_BOOK_MAIN_REWARD(parent);
end

function ADVENTURE_BOOK_MAIN_INIT_MY_CHAR_INFO(mainPage)
    -- job info
    local myHandle = session.GetMyHandle();
    local jobClassID = info.GetJob(myHandle);
    local jobCls = GetClassByType('Job', jobClassID);
    local jobIcon = TryGetProp(jobCls, 'Icon');
    if jobIcon == nil then
        return;
    end

    local mySession = session.GetMySession();
    local chariconPic = GET_CHILD_RECURSIVELY(mainPage, 'chariconPic');
    chariconPic:SetImage(jobIcon);
    if PARTY_JOB_TOOLTIP_BY_CID ~= nil then -- adventure book의 로드 시점이 partyinfo보다 빨라서 예외처리함
        PARTY_JOB_TOOLTIP_BY_CID(mySession:GetCID(), chariconPic, jobCls);
    end

    -- name
    local teamname_text = GET_CHILD_RECURSIVELY(mainPage, 'teamname_text');
    local charname_text = GET_CHILD_RECURSIVELY(mainPage, 'charname_text');
    teamname_text:SetTextByKey('value', info.GetFamilyName(myHandle));
    charname_text:SetTextByKey('value', info.GetName(myHandle));
end

function ADVENTURE_BOOK_MAIN_INIT_MY_RANK_INFO(mainPage)
    
end

function ADVENTURE_BOOK_MAIN_INIT_POINT_GAGUE(frame)
    local guage_monster = GET_CHILD_RECURSIVELY(frame, 'guage_monster');
    ADVENTURE_BOOK_SET_POINT_GAUGE_CTRLSET(guage_monster, 'Monster_point');

    local guage_item = GET_CHILD_RECURSIVELY(frame, 'guage_item');
    ADVENTURE_BOOK_SET_POINT_GAUGE_CTRLSET(guage_item, 'Item_point');

    local guage_making = GET_CHILD_RECURSIVELY(frame, 'guage_making');
    ADVENTURE_BOOK_SET_POINT_GAUGE_CTRLSET(guage_making, 'Recipe_point');

    local guage_living = GET_CHILD_RECURSIVELY(frame, 'guage_living');    
    ADVENTURE_BOOK_SET_POINT_GAUGE_CTRLSET(guage_living, 'Life_Total_point');

    local guage_indun = GET_CHILD_RECURSIVELY(frame, 'guage_indun');
    ADVENTURE_BOOK_SET_POINT_GAUGE_CTRLSET(guage_indun, 'Instantdungeon_point');

    local guage_grow = GET_CHILD_RECURSIVELY(frame, 'guage_grow');
    ADVENTURE_BOOK_SET_POINT_GAUGE_CTRLSET(guage_grow, 'Adventure_Growth_reward');

    local guage_explore = GET_CHILD_RECURSIVELY(frame, 'guage_explore');
    ADVENTURE_BOOK_SET_POINT_GAUGE_CTRLSET(guage_explore, 'Adventure_Exploration_reward');
end

function ADVENTURE_BOOK_SET_POINT_GAUGE_CTRLSET(ctrlSet, pointClassName)
    -- get info
    local pointCls = GetClass('AdventureBookPoint', pointClassName);
    if pointCls == nil then
        return;
    end

    -- name
    local pointName = pointCls.Name;
    if pointCls.UseInitialization == 'YES' then
        local INITIALIZATION_CATEGORY_IMG = ctrlSet:GetUserConfig('INITIALIZATION_CATEGORY_IMG');
        pointName = INITIALIZATION_CATEGORY_IMG..pointName;
    end
    local name_text = ctrlSet:GetChild('name_text');
    name_text:SetTextByKey('value', pointName);

    -- gauge
    local pc = GetMyPCObject();
    local curPoint, maxPoint = 0, 0;
    if pointCls.Script ~= 'None' then
        local getCurPointScript = _G[pointCls.Script];
        curPoint = getCurPointScript(pc);
    end
        
    if pointCls.MaxPointScript ~= 'None' then        
        maxPoint = GetAdventureBookMaxPoint(pointCls.ClassName);

        local levelText = ctrlSet:GetChild('levelText');
        if levelText ~= nil then
            levelText:ShowWindow(0);
        end
    else
        local curLv = 0;
        curLv = GET_ADVENTURE_BOOK_REWARD_STEP(pointCls.RewardCategory, curPoint);
        maxPoint = GetAdventureBookRewardScoreByStep(pointCls.RewardCategory, curLv + 1);

        local levelText = ctrlSet:GetChild('levelText');
        levelText:SetTextByKey('level', curLv);
        levelText:ShowWindow(1);
        ctrlSet:SetUserValue('REWARD_CATEGORY', pointCls.RewardCategory);
        ctrlSet:SetUserValue('CUR_REWARD_LEVEL', curLv);
    end
    local score_guage = GET_CHILD(ctrlSet, 'score_guage');
    score_guage:SetPoint(curPoint, maxPoint);
end 

function ON_ADVENTURE_BOOK_MAIN_RANKING(frame, msg, argStr, myRank)
    local ret = ADVENTURE_BOOK_MAIN_SET_MY_RANK_INFO(frame);

    -- top 3 ranker
    for i = 0, 2 do
        local top_ranking = GET_CHILD_RECURSIVELY(frame, 'top_ranking_'..(i+1));        
        local rankInfo = GetAdventureBookRankInfo(i);
        if rankInfo ~= nil then
            local team_name_text = top_ranking:GetChild('team_name_text');
            local score_text = top_ranking:GetChild('score_text');
            team_name_text:SetTextByKey('value', rankInfo:GetFamilyName());
            score_text:SetTextByKey('value', rankInfo.score);
            top_ranking:ShowWindow(1);
        else
            top_ranking:ShowWindow(0);
        end
    end

    -- top 3 ranker of me
    for i = 3, 1, -1 do
        local rankingCtrlSet = GET_CHILD_RECURSIVELY(frame, 'near_ranking_'..(i+1));
        if ret == true then
            local rankInfo = GetAdventureBookRankInfo(myRank - i);
            if rankInfo ~= nil then
                local rank_text = rankingCtrlSet:GetChild('rank_text');
                local score_text = rankingCtrlSet:GetChild('score_text');
                rank_text:SetTextByKey('value', rankInfo.rank + 1);
                score_text:SetTextByKey('value', rankInfo.score);
                rankingCtrlSet:ShowWindow(1);
            else
                rankingCtrlSet:ShowWindow(0);
            end
        else
            rankingCtrlSet:ShowWindow(0);
        end
    end

    -- bottom ranker of me
    local rankingCtrlSet = GET_CHILD_RECURSIVELY(frame, 'near_ranking_bottom');
    if ret == true then
        local rankInfo = GetAdventureBookRankInfo(myRank + 1);
        if rankInfo ~= nil then
            local rank_text = rankingCtrlSet:GetChild('rank_text');
            local score_text = rankingCtrlSet:GetChild('score_text');
            local rank = tostring(rankInfo.rank + 1);
            local score = tostring(rankInfo.score);        
            rank_text:SetTextByKey('value', rank);
            score_text:SetTextByKey('value', score);
            rankingCtrlSet:ShowWindow(1);
        else
            rankingCtrlSet:ShowWindow(0);
        end
    else
        rankingCtrlSet:ShowWindow(0);
    end
end

function ADVENTURE_BOOK_MAIN_SET_MY_RANK_INFO(frame)
    local near_ranking_my = GET_CHILD_RECURSIVELY(frame, 'near_ranking_my');
    local MY_RANK_FONT_STYLE = near_ranking_my:GetUserConfig('MY_RANK_FONT_STYLE');
    local myRankData = GetMyAdventureBookRankData();
    local rank_text = near_ranking_my:GetChild('rank_text');
    local score_text = near_ranking_my:GetChild('score_text');
    local totalRankerCount = GetAdventureBookTotalRankCount();

    local myscorerank_text = GET_CHILD_RECURSIVELY(frame, 'myscorerank_text');
    local myscore_text = GET_CHILD_RECURSIVELY(frame, 'myscore_text');
    local myRank = myRankData.rank;
    local existRank = true;
    if myRankData.rank < 0 then
        existRank = false;
        myRank = totalRankerCount;
        myscorerank_text:ShowWindow(0);
        myscore_text:ShowWindow(0);
        near_ranking_my:ShowWindow(0);
    else
        rank_text:SetTextByKey('value', MY_RANK_FONT_STYLE..(myRank + 1));
        score_text:SetTextByKey('value', MY_RANK_FONT_STYLE..myRankData.score);
        near_ranking_my:ShowWindow(1);

        myscorerank_text:SetTextByKey('value', myRank + 1);
        myscore_text:SetTextByKey('value', myRankData.score);
        myscorerank_text:ShowWindow(1);
        myscore_text:ShowWindow(1);
    end

    -- gauge
    local gauge_bg = GET_CHILD_RECURSIVELY(frame, 'gauge_bg');
    local gauge_fg = GET_CHILD_RECURSIVELY(frame, 'gauge_fg');
    local arrow_pic = GET_CHILD_RECURSIVELY(frame, 'arrow_pic');
    local myRankRatio = myRank / totalRankerCount;
    if totalRankerCount < 1 then
        myRankRatio = 1;
    end

    local height = gauge_bg:GetHeight() * (1 - myRankRatio) - 10;
    local FG_MARGIN = 10;
    gauge_fg:Resize(gauge_fg:GetWidth(), height);

    local arrowY = gauge_fg:GetOriginalHeight() - gauge_fg:GetHeight();
    arrow_pic:SetOffset(arrow_pic:GetX(), arrow_pic:GetOriginalY() + arrowY);

    return existRank;
end

function GET_ADVENTURE_BOOK_REWARD_STEP(category, curPoint)
    local stepCount = GetAdventureBookRewardStepCount(category);
    local stepScore, preStepScore = 0, 0;
    local curStep = 1;
    while curStep <= stepCount do
        preStepScore = stepScore;
        stepScore = GetAdventureBookRewardScoreByStep(category, curStep);        
        if curPoint < stepScore then
            break;
        end
        curStep = curStep + 1;
    end
    local calcedPoint = curPoint - preStepScore;
    local curMaxScore = stepScore - preStepScore;
    return curStep - 1, calcedPoint, curMaxScore;
end

function ADVENTURE_BOOK_MAIN_REWARD(frame)
    local mainPage = GET_CHILD_RECURSIVELY(frame, 'page_main');
    local page_main_left = GET_CHILD_RECURSIVELY(mainPage, 'page_main_left');
    local childCount = page_main_left:GetChildCount();
    for i = 0, childCount - 1 do
        local child = page_main_left:GetChildByIndex(i);
        if child ~= nil and string.find(child:GetName(), 'guage_') ~= nil then                        
            local rewardBtn = child:GetChild('rewardBtn');
            local rewardStepBox = child:GetChild('rewardStepBox');
            local rewardCategory = child:GetUserValue('REWARD_CATEGORY');
            if rewardStepBox ~= nil and rewardBtn ~= nil then
                rewardStepBox:ShowWindow(1);
                rewardBtn:ShowWindow(1);
                ADVENTURE_BOOK_MAIN_INIT_REWARD_BTN(child, rewardCategory);
            end
        end
    end
end

function ADVENTURE_BOOK_MAIN_SELECT(frame)
    local bookmark = GET_CHILD(frame, 'bookmark');
    bookmark:SelectTab(0);
end

function ADVENTURE_BOOK_MAIN_INIT_REWARD_BTN(ctrlSet, rewardCategory)
    local curStep = GetMyRewardStep(rewardCategory);
    local levelText = ctrlSet:GetChild('levelText');
    local curLevel = tonumber(levelText:GetTextByKey('level'));
    local rewardBtn = ctrlSet:GetChild('rewardBtn');
    local rewardStepBox = ctrlSet:GetChild('rewardStepBox');
    local diffStep = curLevel - curStep;
    if diffStep > 0 then
        local rewardStepBox = ctrlSet:GetChild('rewardStepBox');
        local rewardStepText = rewardStepBox:GetChild('rewardStepText');
        rewardStepText:SetTextByKey('step', diffStep);
        if SYSMENU_NOTICE_TEXT_RESIZE ~= nil then
            SYSMENU_NOTICE_TEXT_RESIZE(rewardStepBox, diffStep);
        end
    else        
        rewardStepBox:ShowWindow(0);
    end
end

function ADVENTURE_BOOK_SHOW_REWARD_INFO(ctrlSet, rewardBtn)
    local adventure_book = ctrlSet:GetTopParentFrame();
    local page_main = GET_CHILD_RECURSIVELY(adventure_book, 'page_main');
    local rewardCategory = ctrlSet:GetUserValue('REWARD_CATEGORY');
    local curLevel = ctrlSet:GetUserIValue('CUR_REWARD_LEVEL');
    ADVENTURE_BOOK_REWARD_OPEN(rewardCategory, curLevel, page_main:GetUserValue('SHOW_REWARD'));
end