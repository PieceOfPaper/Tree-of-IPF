function GET_FISHING_BAG_LIST(pc)
    -- 새로운 살림통 모델이 추가되면 여기에 추가 --
    local fishingBagList = { "fishingbox1", "fishingbox2" };
    return fishingBagList;
end

-- 낚시 시작 시 스크립트 --
function SCR_START_FISHING(pc, fishingPlace, fishingRod, pasteBait)
    local checkRet, errLog = SCR_FISHING_PRE_CHECK(pc);
    if checkRet ~= 'SUCCESS' then
        ExitFishingState(pc, errLog);
        return;
    end
    
    -- 미끼 아이템 검증, 미끼 아이템이 아니라면 낚시 중지 --
    if IS_PASTE_BAIT_ITEM(pasteBait.ClassID) ~= 1 then
        SendSysMsg(pc, 'ItsNotPasteBaitItem');
        ExitFishingState(pc, 'PasteBaitError');
        return;
    end
    
    -- 미끼 아이템이 인벤에 있는지 확인 --
    local pasteBaitInvItem = GetInvItemByType(pc, pasteBait.ClassID);
    if pasteBaitInvItem == nil then
        ExitFishingState(pc, 'PasteBaitError');
        return;
    end
    
    -- 미끼 아이템이 잠겨있는지 확인 --
    if IsFixedItem(pasteBaitInvItem) == 1 then
        SendSysMsg(pc, 'MaterialItemIsLock');
        ExitFishingState(pc, 'PasteBaitError');
        return;
    end
    
    -- 살림통 업그레이드 상태 확인 --
    local accountObj = GetAccountObj(pc);
    local fishingItemBagExpandCount = TryGetProp(accountObj, 'FishingItemBagExpandCount');
    if fishingItemBagExpandCount == nil then
        ExitFishingState(pc, 'FishingItemBagExpandCountError');
        return;
    end
    
    -- 낚시 애니를 위해서 낚싯대 xac 호출 --
    local xacClassName = TryGetProp(fishingRod, "StringArg");
    if xacClassName == nil or xacClassName == "None" then
        xacClassName = "fishingrod_basic";
    end
    
    local pasteBaitGUID = GetItemGuid(pasteBaitInvItem);
    
    -- 미끼 아이템 1개 소비 --
    local tx = TxBegin(pc);
    TxTakeItemByObject(tx, pasteBaitInvItem, 1, "Fishing");
    local ret = TxCommit(tx)
    
    if ret == "SUCCESS" then
        -- 낚시터 바라보기 --
--        LookAt(pc, fishingPlace)
        
        -- 낚시 시작 로그 남김 --
        FishingStartMongoLog(pc, fishingRod.ClassID, pasteBait.ClassID, pasteBaitGUID);
        
        -- 낚시 애니 시작 --
        local aniResult = PlayPairAnimation(pc, xacClassName, '#PC_Fishing', '#Monster_Fishing', 0, 'dummy_r_hand', "fishingrod_basic");
        if aniResult ~= 1 then -- 이쯤돼서 이게 걸리면 유저가 비정상적인 행위(막 동시에 앉기를 누른다든지)를 시도한 것임        
             ExitFishingState(pc, 'FishingAniFailStatus');
             return;
        end
        
        local fishingBagList = GET_FISHING_BAG_LIST(pc);
        local fishingBagName = fishingBagList[fishingItemBagExpandCount + 1];
        if fishingBagName == nil or fishingBagName == "None" then
            fishingBagName = fishingBagList[1];
        end
        
        -- 살림통 오브젝트를 소환 --
        local rx, ry, rz = GetRightPos(pc, -20);
        
        local fishingBag = CREATE_MONSTER_EX(pc, fishingBagName, rx, ry, rz, GetDir(pc), 'Neutral', nil, SCR_FISHING_BAG_SET);
        SetOwner(fishingBag, pc, 1);
        SetExArgObject(pc, "SummonFishingBag", fishingBag);
        
        -- 낚시 실행 좌표 저장 --
        local x, y, z = GetPos(pc);
        SetExProp_Pos(pc, "FishingPos", x, y, z);
        
        -- 낚시터 오브젝트 저장 --
        SetExArgObject(pc, "MyFishingPlace", fishingPlace)
        
        -- PC 무적 처리 --
        SetSafe(pc, 1);
        
        -- 떡밥이 뿌려져 있다면 PC에게 버프 --
--        if IsBuffApplied(fishingPlace, "Fishing_SpreadBait") == "YES" then
        local spreadBaitBuff = GetBuffByName(fishingPlace, "Fishing_SpreadBait")
        if spreadBaitBuff ~= nil then
            local remainTime = GetBuffRemainTime(spreadBaitBuff);
            AddBuff(fishingPlace, pc, "Fishing_SpreadBait_PC", 99, 0, remainTime, 1);
        end
    else
        -- 미끼 아이템 트랜젝션 실패 시 낚시 중지 --
        ExitFishingState(pc, 'PasteBaitTxFail');
    end

    ExecClientScp(pc, 'FISHING_ITEM_BAG_OPEN_UI()');    
end

-- 낚시 시작 후 5초마다 1회 업데이트 되는 스크립트 --
function SCR_UPDATE_FISHING(pc, fishingPlace, fishingRod, pasteBait)
    -- 낚시 성공 최대 횟수를 초과했습니다 --
    if CheckFishingSuccessCount(pc) == 0 then
        SendSysMsg(pc, 'ExceedFishingSuccessCount');
        ExitFishingState(pc, 'FishingSuccessCountIsFull');
        return;
    end
    
    -- 살림통이 가득 차면 낚시 종료 --
    if IsFullFishingItemBag(pc) == 1 then
        SendSysMsg(pc, 'FishingItemBagIsFull');
        ExitFishingState(pc, 'FishingItemBagFull');
        return;
    end
    
    -- 좌표 변경 시 낚시 종료 --
    local x, y, z = GetPos(pc);
    local fishingX, fishingY, fishingZ = GetExProp_Pos(pc, "FishingPos");
    if x ~= fishingX or z ~= fishingZ then
        ExitFishingState(pc, 'FishingCoordinatesChanged');
        return;
    end

    -- 현재 낚는 중이면 일단 리턴 --
    if GetExProp(pc, "NowFishing") == 1 then
        return;
    end
    
    -- 낚시 시간 체크 --
    local fishingTimeCount = GetExProp(pc, "FishingTimeCount");
    fishingTimeCount = fishingTimeCount + 1;
    
    local fishingTryTime = SCR_FISHING_UPDATE_INTERVAL_TIME_CALC(20); -- 20 sec
    
    -- 낚시 모닦불이 주변에 있어서 버프에 걸려있다면 낚시 주기 감소 --
    if IsBuffApplied(pc, 'Fishing_Fire') == "YES" then
        fishingTryTime = SCR_FISHING_UPDATE_INTERVAL_TIME_CALC(15); -- 15 sec
    end
    
    -- Only Test --
--    fishingTryTime = 1;

    local fishingCheat = false;
    if IsGM(pc) > 0 then
       fishingCheat = GetExProp(pc, 'CHEAT_FISHING_GOSU') > 0;
    end
    
    if fishingCheat == true or (fishingTimeCount >= fishingTryTime) then
        local defaultFishingRatio = 0;   -- 낚시 기본 확률 0%, 이벤트 등에서만 따로 조절 --
        local fishingRodRatio = TryGetProp(fishingRod, "NumberArg1");   -- 낚싯대 추가 확률 --
        if fishingRodRatio == nil then
            fishingRodRatio = 0;
        end
        
        local spreadBaitRatio = GetExProp(fishingPlace, "FishingSpreadBait");   -- 떡밥 추가 확률 --
        if spreadBaitRatio == nil then
            spreadBaitRatio = 0;
        end
        
        local fishingRatio = defaultFishingRatio + fishingRodRatio + spreadBaitRatio;    -- 최종 확률 계산 --
        
        local rate = IMCRandom(1, 10000);
        
        SetExProp(pc, "NowFishing", 1); -- 낚는 중 처리, 스크립트가 추가로 돌지 않도록 막음 --
        
        local xacClassName = TryGetProp(fishingRod, "StringArg");   -- 낚는 애니 처리를 위해서 낚시대 xac 호출 --
        if xacClassName == nil or xacClassName == "None" then
            xacClassName = "fishingrod_basic";
        end
        
        local fishingFailCount = GetExProp(pc, "FishingContinuousFailCount");   -- 확률 보정을 위한 연속 실패 횟수 호출 --
        if fishingFailCount == nil then
            fishingFailCount = 0;
        end
        
        -- 낚시 연속 실패 카운트는 낚시 확률의 평균 기대값 * 1.5 -- 따라서 10% 라면 10번 중 한 번은 성공하는 것을 기대하고 보정에 따라 15번에 한 번은 성공하도록 최소 보정 --
        local minProbability = (10000 / (1 + defaultFishingRatio + fishingRodRatio)) * 1.5; -- 확률 보정에는 기본 확률과 낚싯대 확률만 영향 --
        if minProbability < 5 then
            minProbability = 5; -- 확률 보정 최소한 5회 미만으로 내려가지 않도록 제한 --
        end
        
        if fishingCheat == true or (fishingRatio >= rate or fishingFailCount > minProbability) then
            -- 낚시 성공 시 처리 시작 --
            local pasteBaitTable = TryGetProp(pasteBait, "StringArg");  -- 미끼로 인한 추가 보상 테이블 호출 --
            
            local fishingReward, grade = SCR_GET_FISHING_ITEM(pc, pasteBaitTable);  -- 낚은 아이템 --
            if fishingReward ~= nil then
                
--                SetExProp(pc, "NowFishing", 1); -- 낚는 중 처리, 스크립트가 추가로 돌지 않도록 막음 --
--                
--                local xacClassName = TryGetProp(fishingRod, "StringArg");   -- 낚는 애니 처리를 위해서 낚시대 xac 호출 --
--                if xacClassName == nil or xacClassName == "None" then
--                    xacClassName = "fishingrod_basic";
--                end
                
                -- 낚는 애니 재생 --
                PlayAnim(pc, 'fishing_shot');
                PlayAttachModelAnim(pc, xacClassName, 'shot');
                
                sleep(3500);
                
                -- 낚시 성공 최대 횟수를 초과했습니다 --
                if CheckFishingSuccessCount(pc) == 0 then
                    SendSysMsg(pc, 'ExceedFishingSuccessCount');
                    ExitFishingState(pc, 'FishingSuccessCountIsFull');
                    return;
                end
                
                -- 살림통이 가득 차면 낚시 종료 --
                if IsFullFishingItemBag(pc) == 1 then
                    SendSysMsg(pc, 'FishingItemBagIsFull');
                    ExitFishingState(pc, 'FishingItemBagFull');
                    return;
                end
                
                -- 낚은 아이템을 살림통으로 지급 --
                PutFishingItemBag(pc, fishingReward, grade);
            end
        else
            -- 낚시 실패 시 처리 시작 --
            -- 확률로 실패 애니 및 이모티콘 재생 --
            local failAnimRatio = 2000; -- 20%
            local playFailAnim = 0;
            if failAnimRatio >= IMCRandom(1, 10000) then
                playFailAnim = 1;
                PlayAnim(pc, "fishing_shot_fail", nil, 1);
                PlayAttachModelAnim(pc, xacClassName, 'shot_fail');
                FishingFailMongoLog(pc, pasteBait.ClassID);
                sleep(3500);
                
                local emoticonList = { "I_emoticon004", "I_emoticon005", "I_emoticon006" };
                ShowEmoticon(pc, emoticonList[IMCRandom(1, #emoticonList)], 2000)
                
                sleep(1000);
            end
            
            -- 만약 낚시를 종료했다면 여기서 스크립트 종료 --
            if IsFishingState(pc) == 0 then
                return;
            end
            
            -- 낚시 성공 최대 횟수를 초과했습니다 --
            if CheckFishingSuccessCount(pc) == 0 then
                SendSysMsg(pc, 'ExceedFishingSuccessCount');
                ExitFishingState(pc, 'FishingSuccessCountIsFull');
                return;
            end
            
            -- 살림통이 가득 차면 낚시 종료 --
            if IsFullFishingItemBag(pc) == 1 then
                SendSysMsg(pc, 'FishingItemBagIsFull');
                ExitFishingState(pc, 'FishingItemBagFull');
                return;
            end
            
            -- 확률로 실패 애니 및 이모티콘 재생 --
            if playFailAnim == 1 then
                -- 낚시를 계속한다면 다시 던지는 애니 처리 --
                PlayAnim(pc, "fishing_ready")
                PlayAttachModelAnim(pc, xacClassName, 'ready');
            end
            
            -- 연속 실패 카운트 +1 --
            SetExProp(pc, "FishingContinuousFailCount", fishingFailCount + 1);
            
            -- 낚는 중 처리로 막은 스크립트 해제 --
            SetExProp(pc, "NowFishing", 0);
        end
        
        -- 낚시 시간 초기화 --
        fishingTimeCount = 0;
    end
    
    -- 낚시 시간 저장 --
    SetExProp(pc, "FishingTimeCount", fishingTimeCount);
    
    -- 미끼 시간 체크 --
    local pasteBaitTimeCount = GetExProp(pc, "PasteBaitTimeCount");
    if pasteBaitTimeCount == nil then
        pasteBaitTimeCount = 0;
    end
    
    pasteBaitTimeCount = pasteBaitTimeCount + 1;
    if pasteBaitTimeCount >= SCR_FISHING_UPDATE_INTERVAL_TIME_CALC(20) then -- 20 sec
        -- 미끼 소모 --
        local pasteBaitCount = GetInvItemCount(pc, pasteBait.ClassName)
        if pasteBaitCount >= 1 then
            local tx = TxBegin(pc);
            TxTakeItem(tx, pasteBait.ClassName, 1, "Fishing");
            local ret = TxCommit(tx)
            
            -- 트랜젝션에 실패하면 낚시 종료 --
            if ret ~= "SUCCESS" then
                ExitFishingState(pc, 'PasteBaitTxFail');
                return;
            end
        else
            -- 미끼가 없으면 낚시 종료 --
            ExitFishingState(pc, 'PasteBaitExhaust');
            return;
        end
        
        pasteBaitTimeCount = 0;
    end
    
    -- 미끼 시간 저장 --
    SetExProp(pc, "PasteBaitTimeCount", pasteBaitTimeCount);
    
end

-- 낚시 주기에 따른 시간 계산 --
-- 인자값은 1/1000 초 --
function SCR_FISHING_UPDATE_INTERVAL_TIME_CALC(sec)
    local intervalCount = sec * 1000;
    if intervalCount % FISHING_UPDATE_INTERVAL ~= 0 then
        print("Interval Time Calc Err!" .. intervalCount .. " " .. FISHING_UPDATE_INTERVAL);
    end
    
    intervalCount = (intervalCount / FISHING_UPDATE_INTERVAL);
    
    return math.floor(intervalCount);
end

-- 낚시 종료 시 스크립트 --
function SCR_END_FISHING(pc, fishingPlace, fishingRod, pasteBait)
    -- PC 무적 해제 --
    SetSafe(pc, 0);
    
    DelExProp(pc, "FishingTimeCount");
    DelExProp(pc, "PasteBaitTimeCount");
    DelExProp(pc, "NowFishing");
    DelExProp(pc, "FishingContinuousFailCount");
    
    ClearExArgObject(pc, "MyFishingPlace")
    
    RemoveBuff(pc, "Fishing_SpreadBait_PC")
    
    -- 살림통 오브젝트 제거 --
    local fishingBag = GetExArgObject(pc, "SummonFishingBag");
    if fishingBag ~= nil then
        Dead(fishingBag);
    end
    
    -- 낚시 애니 정지 --
    StopPairAnimation(pc);
end



-- 낚시 성공 시 (아이템이 살림통에 들어오기까지 완료된 뒤) 스크립트 --
function ON_PUT_FISHING_ITEM_BAG(pc, isSuccess, rewardItemClassName, rewardGrade, fishingPlace, fishingRod, pasteBait)
    if pc == nil then
        ExitFishingState(pc, 'FishingItemBagScriptPCnil');
        return;
    end
    
    if isSuccess ~= 'SUCCESS' then
        ExitFishingState(pc, 'FishingItemBagTxFail');
        return;
    end
    
    -- 황금 물고기(황금 어장) 판정 --
    -- 2시간의 쿨타임이 존재하며 10분간 유지 --
    local isGoldenFish, goldenFishTime = IsProgressWorldEvent('GoldenFish');
    if isGoldenFish ~= 1 then
        local goldenFishRatio = 500;   -- 0.5%
        if goldenFishRatio >= IMCRandom(1, 10000) then
            RunGoldenFishEvent(pc, 600);
        end
    end
    
    -- S와 A등급 아이템을 낚으면 추가 이펙트 --
    if rewardGrade == "S" then
        PlayEffect(pc, "F_fish01", 1.0, nil, 'BOT');
    elseif rewardGrade == "A" then
        PlayEffect(pc, "F_fish02", 1.0, nil, 'BOT');
    else
        PlayEffect(pc, "F_fish03", 1.0, nil, 'BOT');
    end
    
    local rewardItem = GetClass("Item", rewardItemClassName);
    if rewardItem ~= nil then
        if rewardGrade == "F" then
            -- 물고기를 낚았습니다! --
            SendAddOnMsg(pc, "NOTICE_Dm_Fishing", ScpArgMsg("CaughtAFish"), 5);
        else
            -- 물고기가 무언가를 뱉어내고 도망갔습니다! : 아이템 이름 --
            SendAddOnMsg(pc, "NOTICE_Dm_Fishing", ScpArgMsg("CaughtA{ItemName}", "ItemName", rewardItem.Name), 5);
        end
                
        -- 물고기인 경우 모험일지에 등록
        if TryGetProp(rewardItem, 'ClassType2') == 'Fishing' then
            if IsExistFishInAdevntureBook(pc, rewardItem.ClassID) == 'NO' then
                ALARM_ADVENTURE_BOOK_NEW(pc, rewardItem.Name);
            end
            AddAdventureBookFishingInfo(pc, rewardItem.ClassID, 1);
        end
    end
    
    ShowEmoticon(pc, "I_emoticon002", 2000)
    
    sleep(1000);
    
    -- 만약 낚시를 종료했다면 여기서 스크립트 종료 --
    if IsFishingState(pc) == 0 then
        return;
    end
    
    -- 낚시 성공 최대 횟수를 초과했습니다 --
    if CheckFishingSuccessCount(pc) == 0 then
        SendSysMsg(pc, 'ExceedFishingSuccessCount');
        ExitFishingState(pc, 'FishingSuccessCountIsFull');
        return;
    end
    
    -- 살림통이 가득 차면 낚시 종료 --
    if IsFullFishingItemBag(pc) == 1 then
        SendSysMsg(pc, 'FishingItemBagIsFull');
        ExitFishingState(pc, 'FishingItemBagFull');
        return;
    end
    
    local xacClassName = TryGetProp(fishingRod, "StringArg");   -- 낚는 애니 처리를 위해서 낚시대 xac 호출 --
    if xacClassName == nil or xacClassName == "None" then
        xacClassName = "fishingrod_basic";
    end
    
    -- 낚시를 계속 한다면 다시 던지는 애니 처리 --
    PlayAnim(pc, "fishing_ready")
    PlayAttachModelAnim(pc, xacClassName, 'ready');
    
    -- 연속 실패 카운트 0으로 초기화 --
    SetExProp(pc, "FishingContinuousFailCount", 0);
    
    -- 낚는 중 처리로 막은 스크립트 해제 --
    SetExProp(pc, "NowFishing", 0);    
end

-- Grade를 통해 랭킹 포인트를 계산 --
function GET_FISHING_RANK_POINT_BY_GRADE(grade)
    local rankPointGrade = { };
   rankPointGrade["S"] = 20;
   rankPointGrade["A"] = 10;
   rankPointGrade["B"] = 5;
   rankPointGrade["C"] = 2;
   rankPointGrade["F"] = 1;
               
   local rankPoint = 1;
   if rankPointGrade[grade] ~= nil then
       rankPoint = rankPointGrade[grade];
   end
   return rankPoint;
end



-- 아이템 획득 함수 --
function SCR_GET_FISHING_ITEM(self, pasteBaitTable)
    if pasteBaitTable == nil then
        pasteBaitTable = "None";
    end
    
    local eventTable = "None";
    
    -- 이벤트 때만 넣을 보상, 이벤트 때는 포함시킬 테이블을 추가요망. 안 쓸때는 주석 --
    eventTable = "fishing_event_1";
    -- 여기까지 이벤트 --
    
    -- 낚시 아이템에서 뽑을 등급을 우선 확률 계산 --
    local classList, cnt = GetClassList("reward_fishing");
    if classList ~= nil then
        local grade = nil;
        local gradeList = {
                            { "F", 5000 },
                            { "C", 5000 },
                            { "B", 1500 },
                            { "A", 500 },
                            { "S", 100 }
                          };
        
        -- 기본 미끼일 경우에는 F 확률 증가 --
        if pasteBaitTable == "None" then
            gradeList[1][2] = gradeList[1][2] * 4;
        end
        
        local gradeRatio = { };
        local totalGradeRatio = 0;
        for j = 1, #gradeList do
            totalGradeRatio = totalGradeRatio + gradeList[j][2];
            gradeRatio[j] = totalGradeRatio;
        end
        
        local gradeRate = IMCRandom(1, totalGradeRatio);
        for k = 1, #gradeList do
            if gradeRatio[k] >= gradeRate then
                grade = gradeList[k][1];
                break;
            end
        end
        
        if grade == nil then
            return;
        end
        
        local fishingReward = { };
        local totalRatio = 0;
        if cnt >= 1 then
            for i = 0, cnt - 1 do
                local fishingClass = GetClassByIndexFromList(classList, i)
                local rewardGroup = TryGetProp(fishingClass, "Group");
                
                if rewardGroup == "fishing_default" or rewardGroup == pasteBaitTable or rewardGroup == eventTable then
                    local rewardZone = TryGetProp(fishingClass, "Zone");
                    if rewardZone == nil then
                        rewardZone = "None";
                    end
                    
                    local rewardGrade = TryGetProp(fishingClass, "Grade");
                    if rewardGrade == nil then
                        rewardGrade = "None";
                    end
                    
                    local zoneName = GetZoneName(self);
                    
                    if (rewardZone == "None" or rewardZone == zoneName) and rewardGrade == grade then
                        local groupReward = { };
                        groupReward[1] = fishingClass.ItemName;
                        groupReward[2] = totalRatio + fishingClass.Ratio;
                        
                        fishingReward[#fishingReward + 1] = groupReward;
                        
                        totalRatio = totalRatio + fishingClass.Ratio;
                    end
                end
            end
            
            local rate = IMCRandom(1, totalRatio);
            
            for j = 1, #fishingReward do
                if rate <= fishingReward[j][2] then
                    return fishingReward[j][1], grade;
                end
            end
        end
    end
    
    return nil;
end



-- 살림통 오브젝트 세팅 --
function SCR_FISHING_BAG_SET(mon)
    mon.Dialog = "FISHING_BAG";
    mon.DialogRotate = 0;
end

-- 살림통 오브젝트 Dialog --
function SCR_FISHING_BAG_DIALOG(self, pc)
    local owner = GetOwner(self);
    if owner == nil then
        return;
    end
    
    --여기에 낚시인벤 오픈(owner)    
    ShowFishingItemBag(owner, pc);
end

-- 살림통 업그레이드 --
function TX_UPGRADE_FISHING_ITEM_BAG(pc)
    local currentMaxSlotCount = GetMaxFishingItemBagSlotCount(pc);
    if currentMaxSlotCount + FISHING_SLOT_EXPAND_UNIT > MAX_FISHING_ITEM_BAG_SLOT_COUNT then
        SendSysMsg(pc, 'ExceedMaxFishingItemBagSlotCount');
        return;
    end
    local accountObj = GetAccountObj(pc);
    local currentExpandCount = TryGetProp(accountObj, 'FishingItemBagExpandCount');
    if currentExpandCount == nil then
        return;
    end
    local costTP = GET_FISHING_ITEM_BAG_UPGRADE_COST(pc, currentExpandCount);
    if costTP < 1 then
        SendSysMsg(pc, 'ExceedMaxFishingItemBagSlotCount');
        return;
    end
    local prevSlotCount = GetMaxFishingItemBagSlotCount(pc);

    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end
    TxAddIESProp(tx, accountObj, 'Medal', -costTP, 'UpgradeFishingItemBag');
    TxSetIESProp(tx, accountObj, 'FishingItemBagExpandCount', currentExpandCount + 1);
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
        local curSlotCount = GetMaxFishingItemBagSlotCount(pc);        
        FishingItemBagUpgradeMongoLog(pc, prevSlotCount, curSlotCount);
        SendAddOnMsg(pc, 'FISHING_EXPAND_SLOT');
    end
end

-- 일일 낚시 횟수 초기화 --
function RESET_FISHING_SUCCESS_COUNT(pc)
    local accountObj = GetAccountObj(pc);
    local successCount = TryGetProp(accountObj, 'FishingSuccessCount');
    local curSettedResetTime = TryGetProp(accountObj, 'FishingResetTime');
    if successCount == nil or curSettedResetTime == nil then
        IMC_LOG('FATAL_ASSERT', 'RESET_FISHING_SUCCESS_COUNT: account property error! plz check account.xml or classkey!');
        return;
    end

    if IsRequiredFishingCountReset(curSettedResetTime) == 0 then
        return;
    end
    local nextResetTime = GetNextFishingCountResetTime();

    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end
    TxSetIESProp(tx, accountObj, 'FishingSuccessCount', 0);
    TxSetIESProp(tx, accountObj, 'FishingResetTime', nextResetTime);
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
        SendAddOnMsg(pc, 'FISHING_SUCCESS_COUNT', '0');
        return;
    end
    IMC_LOG('ERROR_TX_FAIL', 'Reset fishing success count is fail');
end



-- 황금 어장 --
function SCR_GOLDEN_FISH_START(eventName, self, argStr, argNum)

    local name = "Unknown";
    if self ~= nil then
        if IS_PC(self) == true then
            name = GetTeamName(self);
            
            local x, y, z = GetPos(self);
            PlayEffectToGround(self, "F_goldenfish", x, y + 100, z, 1.0);
            
--            PlayEffect(self, "F_goldenfish", 1.0, nil, 'BOT');
        end

        local time = 10;
        local exp = 50;    
    
        ToAll(ScpArgMsg("{Name}CaughtAGoldenfish", "Name", name, "Time", time, "Exp", exp));

        CustomMongoLog(self, "Fishing", "Type", "StartGoldenFishEvent");
    end
    
    AddBuffToAllServerPC(nil, 'GoldenFishEvent', 'UPDATE_EXP_UP');
end

function SCR_GOLDEN_FISH_END(eventName)
    --local eventCls = GetClass('EventTableProperty', eventName);
    RemoveBuffToAllServerPC('GoldenFishEvent', 'UPDATE_EXP_UP');
end

--탁본 동상 버프
function SCR_FISH_RUBBING_BUFF_100_START(eventName, self, argStr, argNum)
	
    local name = "Unknown";
	local buffName = "None";
    if self ~= nil then
        if IS_PC(self) == true then
            name = GetTeamName(self);
        end

		local time = 60;
		local LootingChance = 100;

        ToAll(ScpArgMsg("{Name}FishRubbingBuff", "Name", name, "Time", time, "LootingChance", LootingChance));
        --CustomMongoLog(self, "Fishing", "Type", "StartGoldenFishEvent");
    end
    
    AddBuffToAllServerPC(nil, 'STATUE_LOOTINGCHANCE_1');
end

function SCR_FISH_RUBBING_BUFF_100_END(eventName)
    --local eventCls = GetClass('EventTableProperty', eventName);
    RemoveBuffToAllServerPC('GoldenFishEvent', 'UPDATE_EXP_UP');
end

--탁본 동상 버프
function SCR_FISH_RUBBING_BUFF_300_START(eventName, self, argStr, argNum)
	
    local name = "Unknown";
	local buffName = "None";
    if self ~= nil then
        if IS_PC(self) == true then
            name = GetTeamName(self);
        end

		local time = 30;
		local LootingChance = 300;
        ToAll(ScpArgMsg("{Name}FishRubbingBuff", "Name", name, "Time", time, "LootingChance", LootingChance));
        --CustomMongoLog(self, "Fishing", "Type", "StartGoldenFishEvent");
    end
    
    AddBuffToAllServerPC(nil, 'STATUE_LOOTINGCHANCE_2');
end

function SCR_FISH_RUBBING_BUFF_300_END(eventName)
    --local eventCls = GetClass('EventTableProperty', eventName);
    RemoveBuffToAllServerPC('GoldenFishEvent');
end

--탁본 동상 버프
function SCR_FISH_RUBBING_BUFF_500_START(eventName, self, argStr, argNum)
	
    local name = "Unknown";
	local buffName = "None";
    if self ~= nil then
        if IS_PC(self) == true then
            name = GetTeamName(self);
        end

		local time = 10;
		local LootingChance = 500;

        ToAll(ScpArgMsg("{Name}FishRubbingBuff", "Name", name, "Time", time, "LootingChance", LootingChance));
        --CustomMongoLog(self, "Fishing", "Type", "StartGoldenFishEvent");
    end
    
    AddBuffToAllServerPC(nil, 'STATUE_LOOTINGCHANCE_3');
end

function SCR_FISH_RUBBING_BUFF_500_END(eventName)
    --local eventCls = GetClass('EventTableProperty', eventName);
    RemoveBuffToAllServerPC('GoldenFishEvent');
end



-------- 여기서부터 테스트 --------

-- 황금어장 실행 --
function GOLDENFISH_TEST(self)
    local isGoldenFish, goldenFishTime = IsProgressWorldEvent('GoldenFish');
    if isGoldenFish == 1 then
        Chat(self, 'Event Progress: time['..goldenFishTime..']', 5);
        return;
    end
    
    RunGoldenFishEvent(self, 600);
end

function TEST_GOLDEN_FISH_FORCELY(self)
    RunGoldenFishEvent(self, 600);
end

-- 일일 낚시 횟수 초기화(테스트용) --
function TEST_RESET_FISHING_SUCCESS_COUNT(pc)
    local accountObj = GetAccountObj(pc);
    if accountObj == nil then
        return;
    end
    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end
    TxSetIESProp(tx, accountObj, 'FishingSuccessCount', 0);
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
        SendAddOnMsg(pc, 'FISHING_SUCCESS_COUNT', '0');
        return;
    end
end

-- 낚시 보상 테스트 --
-- time에는 시간(분)을 입력하면 해당 시간만큼 낚시 시도 --
-- user에 수를 넣으면 해당 유저 수만큼 시도한다고 가정 --
function TEST_FISHING_REWARD(self, time, user)
    local totalTryCount = 0;
    
    local loop = 1;
    for i = 1, loop do
        if time == nil or time == 0 then
            time = 120; -- 시간 입력하지 않으면 2시간 기준 --
        end
        
        if user == nil or user == 0 then
            user = 1;
        end
        
        local fishingRate = 710;
        
        local gradeList = { }
        gradeList["F"] = 0;
        gradeList["C"] = 0;
        gradeList["B"] = 0;
        gradeList["A"] = 0;
        gradeList["S"] = 0;
        
        local fishingTry = 0;
        local fishingRet = 0;
        
        local eventItem1 = { "Servant_Black_Box", 0 };
        local eventItem2 = { "Servant_Red_Box", 0 };
        
        local fishingFailCount = 0;
        local minProbability = (10000 / (1 + fishingRate)) * 1.5;
        if minProbability < 5 then
            minProbability = 5;
        end
        
        for i = 1, math.floor(time * 1.5) * user do
            fishingTry = i;
            
--            if fishingRate >= IMCRandom(1, 10000) or fishingFailCount > minProbability then
            if fishingRate >= IMCRandom(1, 10000) then
                fishingFailCount = 0;
                
                fishingRet = fishingRet + 1;
--                local fishingItem, fishingGrade = SCR_GET_FISHING_ITEM(self, "fishing_default");  -- 새우 --
                local fishingItem, fishingGrade = SCR_GET_FISHING_ITEM(self, nil);  -- 지렁이 --
                
                if gradeList[fishingGrade] == nil then
                    print("Errrrrrr!!", fishingGrade);
                    return;
                end
                
                gradeList[fishingGrade] = gradeList[fishingGrade] + 1;
                
                if fishingItem == eventItem1[1] then
                    eventItem1[2] = eventItem1[2] + 1;
                end
                
                if fishingItem == eventItem2[1] then
                    eventItem2[2] = eventItem2[2] + 1;
                end
                --
                
                if fishingRet >= 10 * user then
                    break;
                end
            else
                fishingFailCount = fishingFailCount + 1;
            end
        end
        
        print("\n유저 수 : "..user.."\n시간 : "..time.."\n낚시 횟수(성공/시도) : "..fishingRet.."/"..fishingTry.."\nF : "..gradeList["F"].." ("..math.floor(gradeList["F"] / fishingRet * 10000) / 100 .."%%)".."\nC : "..gradeList["C"].." ("..math.floor(gradeList["C"] / fishingRet * 10000) / 100 .."%%)".."\nB : "..gradeList["B"].." ("..math.floor(gradeList["B"] / fishingRet * 10000) / 100 .."%%)".."\nA : "..gradeList["A"].." ("..math.floor(gradeList["A"] / fishingRet * 10000) / 100 .."%%)".."\nS : "..gradeList["S"].." ("..math.floor(gradeList["S"] / fishingRet * 10000) / 100 .."%%)")
        print("\n" .. eventItem1[1] .. " : " .. eventItem1[2] .. "개\n" .. eventItem2[1] .. " : " .. eventItem2[2] .. "개\n");
        
        totalTryCount = totalTryCount + fishingTry;
    end
    
    if loop > 1 then
        print(totalTryCount / loop);
    end
end

-- 낚시 무조건 성공용 치트 만들어 달라고 하셔서 만듬
function TEST_SET_FISHING_GOSU(pc)
    if IsGM(pc) == 0 then
        return;
    end
    SetExProp(pc, 'CHEAT_FISHING_GOSU', 1);
    Chat(pc, "낚시 고수가 되었습니다 ^ㅇ^)d"..pc.Name);
end