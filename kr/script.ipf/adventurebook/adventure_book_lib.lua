function ALARM_ADVENTURE_BOOK_NEW(pc, name)
    SendAddOnMsg(pc, 'ADVENTURE_BOOK_NEW', name);
end

function RESET_ADVENTURE_BOOK_REWARD_INFO(pc, forceReset) -- forceReset: 치트 제작해달라고 하셔서 만듬. 보통은 nil 옵니다
    local accountObj = GetAccountObj(pc);
    local successCount = TryGetProp(accountObj, 'AdventureBookRecvReward');
    local curSettedResetTime = TryGetProp(accountObj, 'AdventureBookReward_ResetTime');
    if successCount == nil or curSettedResetTime == nil then
        IMC_LOG('FATAL_ASSERT', 'RESET_ADVENTURE_BOOK_REWARD_INFO: account property error! plz check account.xml or classkey!');
        return;
    end

    if forceReset ~= 1 and IsRequiredAdventureBookReset(curSettedResetTime) == 0 then
        return;
    end
    local nextResetTime = GetNextAdventureBookResetTime();

    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end
    TxSetIESProp(tx, accountObj, 'AdventureBookRecvReward', 0);
    
    if curSettedResetTime ~= nextResetTime then
        TxSetIESProp(tx, accountObj, 'AdventureBookReward_ResetTime', nextResetTime);
    end
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
        return;
    end
    IMC_LOG('ERROR_TX_FAIL', 'Reset adventure book reward info success count is fail');
end

function SCR_GIVE_ADVENTURE_BOOK_REWARD(pc, rewardCategory, currentStep, lastStep)
    if pc == nil or currentStep <= lastStep then
        return;
    end

    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end

    -- give reward
    local totalMoney = 0;
    local rewardItemList = {};
    local achieveName = 'None';
    local achievePoint = 0;
    for i = lastStep + 1, currentStep do
        local giveMoney = GetAdventureBookRewardMoney(rewardCategory, i);
        if giveMoney > 0 then
            TxGiveItem(tx, MONEY_NAME, giveMoney, 'WIKI_REWARD'); -- WIKI_REWARD는 이전부터 사용하던거
            totalMoney = totalMoney + giveMoney;
        end

        -- item
        local totalItemCount = GetAdventureBookRewardItemTotalCount(rewardCategory, i);        
        for j = 0, totalItemCount - 1 do
            local giveItemName, giveCount = GetAdventureBookRewardItem(rewardCategory, i, j);
            local itemCls = GetClass('Item', giveItemName);
            if itemCls ~= nil and giveCount > 0 then
                TxGiveItem(tx, giveItemName, giveCount, 'WIKI_REWARD'); -- WIKI_REWARD는 이전부터 사용하던거
                rewardItemList[#rewardItemList + 1] = giveItemName;

                -- for log
                local count = GetExProp(pc, 'REWARD_'..giveItemName);
                SetExProp(pc, 'REWARD_'..giveItemName, count + giveCount);
            end
        end

        -- achieve
        achieveName, achievePoint = GetAdventureBookRewardAchieve(rewardCategory, i);        
        if achieveName ~= 'None' and achievePoint > 0 then
            TxAddAchievePoint(tx, achieveName, achievePoint);
        end
    end

    -- update reward step
    TxAdventureBookRewardStep(tx, rewardCategory, currentStep);

    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
        SendAddOnMsg(pc, 'UPDATE_ADVENTURE_BOOK_REWARD');
        AdventureBookRewardStepMongoLog(pc, rewardCategory, lastStep, currentStep, totalMoney, rewardItemList, achieveName, achievePoint);
        return;
    end
    IMC_LOG('ERROR_TX_FAIL', 'SCR_GIVE_ADVENTURE_BOOK_REWARD: aid['..GetPcAIDStr(pc)..'], rewardCategory['..rewardCategory..'], currentStep['..currentStep..'], lastStep['..lastStep..']');
end

-- 여기부턴 테스트용 함수입니다 ^ㅇ^d
function TEST_RESET_ADVENTURE_BOOK_SEASON(pc)
    TestResetAdventureBookSeason(pc);
end

function TEST_RESET_ADVENTURE_BOOK_REWARD_INFO(pc)
    RESET_ADVENTURE_BOOK_REWARD_INFO(pc, 1);
end

function TEST_GET_ADVENTURE_BOOK_OLD_RANKING(pc)
    local rank1, score1, totalCount1 = GetLastAdventureBookRank(pc, 'Initialization_point');
    Chat(pc, 'Old Initial Rank['..rank1..'], Score['..score1..']');
    print("TestGetOldRanking: pc["..pc.Name..'], Old Initial Rank['..rank1..'], Score['..score1..']')

    local rank2, score2, totalCount2 = GetLastAdventureBookRank(pc, 'Item_Consume_point');
    Chat(pc, 'Old Initial Rank['..rank2..'], Score['..score2..']');
    print("TestGetOldRanking: pc["..pc.Name..'], Old ItemConsume Rank['..rank2..'], Score['..score2..']')
end

--[[ 이거 이제 안먹게 해놨어요. 랭킹 매번 레디스에서 읽어올 거에요. 메모리에 캐싱해놓으니까 레디스 실패하는 경우 문제 존 입장 전까지 해결 방법이 없어서 그럼
function TEST_SET_OLD_INITIAL_RANK(pc, rank, score, totalCount)
    TestSetAdventureBookOldRanking(pc, 'Initialization_point_Old', rank, score, totalCount);
    local rank, score, totalCount = GetLastAdventureBookRank(pc, 'Initialization_point');
    local string = string.format('이전 랭킹 세팅: 초기화항목- 내 랭킹[%d], 내 점수[%d], 전체 랭커 숫자[%d]', rank, score, totalCount);
    Chat(pc, string);
end

function TEST_SET_OLD_ITEM_CONSUME_RANK(pc, rank, score, totalCount)
    TestSetAdventureBookOldRanking(pc, 'Item_Consume_point_Old', rank, score, totalCount);
    local rank, score, totalCount = GetLastAdventureBookRank(pc, 'Item_Consume_point');
    local string = string.format('이전 랭킹 세팅: 아이템 소모 항목- 내 랭킹[%d], 내 점수[%d], 전체 랭커 숫자[%d]', rank, score, totalCount);
    Chat(pc, string);
end
]]--

function TEST_RESET_DB_ADVENTURE_BOOK_RESETTIME() -- DB에 저장된 다음 모험일지 리셋시간을 다음 달 1일로 변경
    TestAdventureBookResetTime();
end

function TEST_RELOAD_ADVENTURE_BOOK_OLD_RANKING() -- 레디스에 캐싱된 이전 랭킹을 RDB의 값으로 리로드함
    TestReloadAdventureBookOldRanking()
end

function TEST_ADVENTURE_BOOK_FAIL(pc) -- 모험일지 RDB, 레디스 점수 갱신 스트레스 테스트
    for line in io.lines('c:/testAdventureBook.csv') do

        local strings = StringSplit(line, ',');
        local cmd = strings[1];
        local targetID = tonumber(strings[2]);
        if cmd == 'ItemGet' then
            AddAdventureBookItemObtainCount(pc, targetID, 'Drop', 30);
        elseif cmd == 'Craft' then
            AddAdventureBookCraftCount(pc, targetID, 1);
        elseif cmd == 'MonKill' then
            AddAdventureBookMonKillCount(pc, targetID, 30);
        elseif cmd == 'Fishing' then
            AddAdventureBookFishingInfo(pc, 1, 10);
        end

        local sleepTerm = {100, 200, 300};        
        --sleep(sleepTerm[IMCRandom(1, 3)]);
    end

    Chat(pc, 'TEST_ADVENTURE_BOOK_FAIL END!!')
end

function TEST_GET_CURRENT_RANKING_POINT(pc)
    local initial = INITIALIZATION_ADVENTURE_BOOK_POINT(pc);
    local consume = GET_ITEM_CONSUME_POINT(pc);

    local string = string.format('initial[%d], consume[%d]', initial, consume);
    print("GetPoint: "..string);
    Chat(pc, string);
end


function TEST_SIMULATE_ADVENTURE_BOOK(pc)
    for line in io.lines('c:/simulate_AdventureBook.csv') do

        local strings = StringSplit(line, ',');
        local cmd = strings[1];
        local targetID = tonumber(strings[2]);
        local count = tonumber(strings[3]);

        if count > 0 then
            if cmd == 'ItemGet' then
                AddAdventureBookItemObtainCount(pc, targetID, 'Drop', count);
            elseif cmd == 'Craft' then
                AddAdventureBookCraftCount(pc, targetID, count);
            elseif cmd == 'MonKill' then
                AddAdventureBookMonKillCount(pc, targetID, count);
            elseif cmd == 'Fishing' then
                AddAdventureBookFishingInfo(pc, targetID, count);
            elseif cmd == 'Indun' then
                local cmd = GetMGameCmd(pc);
                if cmd == nil then
                    Chat(pc, '인던 들어가서 써주세요');
                    return;
                end
                local indunCls = GetClassByType('Indun', targetID);
                cmd:GiveAdventureBookClearPointToAllPlayers(indunCls.ClassName);
            elseif cmd == 'AutoSeller' then
                AddAdventureBookAutoSellerInfo(pc, targetID, count);
            end
        end

        local sleepTerm = {100, 200, 300};        
        --sleep(sleepTerm[IMCRandom(1, 3)]);
    end

    Chat(pc, 'TEST_ADVENTURE_BOOK_FAIL END!!')
end

function TEST_ADVENTURE_BOOK_FISHING_CNT(pc, fishingCnt)
    for i = 1, fishingCnt do
        AddAdventureBookFishingInfo(pc, 730801, 1);
    end
end
--- 테스트함수 끝!