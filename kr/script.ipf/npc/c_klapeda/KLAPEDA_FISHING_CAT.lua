
function SCR_KLAPEDA_FISHING_CAT_DIALOG(self, pc)
    local fishItemName = "Silver_Fish";
    local fishItem, fishCnt = GetInvItemByName(pc, fishItemName)
    if fishCnt >= 1 then
        LookAt(self, pc);
        local selectMenu = ShowSelDlg(pc, 0, 'KLAPEDA_FISHING_CAT_dlg1', ScpArgMsg("KLAPEDA_FISHING_CAT_Yes"), ScpArgMsg("KLAPEDA_FISHING_CAT_No"));
        if selectMenu == 1 then
            local tx = TxBegin(pc);
            TxTakeItem(tx, fishItemName, 1, "FISHING_CAT");
            local ret = TxCommit(tx);
            
            if ret == "SUCCESS" then
--                local lovePower = GetExProp(pc, "LOVE_POWER");
--                if lovePower == nil then
--                    lovePower = 0;
--                end
--                
--                SetExProp(pc, "LOVE_POWER", lovePower + 1);
                
                local sObj = GetSessionObject(pc, "ssn_klapeda");
                if sObj == nil then
                    return;
                end
                
                if sObj.KLAPEDA_FISHING_CAT < 100000000 then    -- 1억까지만 오르도록 제한, 추가 조치로 은빛 물고기를 주지 않도록 해야 함 --
                    sObj.KLAPEDA_FISHING_CAT = sObj.KLAPEDA_FISHING_CAT + 1;
                end
                
                AddBuff(pc, self, 'HT_KLAPEDA_CAT_EMOTION', 1, 0, 3000, 1)
                AddBuff(pc, pc, 'HT_KLAPEDA_CAT_EMOTION', 1, 0, 3000, 1)
                
                if IsMoving(self) == 0 then
                    local aniList = { "PUB_IDLE", "PUB_IDLE2", "PUB_IDLE3" };
                    PlayAnim(self, aniList[IMCRandom(1, #aniList)], nil, 1)
                end
                
                SCR_KLAPEDA_FISHING_CAT_RUN(self, pc);
            end
        elseif selectMenu == 2 then
            RemoveBuff(self, 'HT_KLAPEDA_CAT_EMOTION');
            ShowEmoticon(self, 'I_emo_angrycat', 3000)
        end
    end
end

function SCR_KLAPEDA_FISHING_CAT_ENTER(self, pc)
    SCR_KLAPEDA_FISHING_CAT_RUN(self, pc);
end



function SCR_KLAPEDA_FISHING_CAT_RUN(self, pc)
    if pc ~= nil then
        AddScpObjectList(self, "CAT_MOM", pc);
    end
    
    local catMomList = GetScpObjectList(self, "CAT_MOM");
    if catMomList ~= nil and #catMomList >= 1 then
        local topLover = nil;
        local tempValue = 0;
        for i = 1, #catMomList do
            local catMom = catMomList[i];
            if topLover == nil then
                topLover = catMom;
--                tempValue = GetExProp(catMom, "LOVE_POWER");
                
                local sObj = GetSessionObject(catMom, 'ssn_klapeda');
                tempValue = TryGetProp(sObj, "KLAPEDA_FISHING_CAT");
                
                if tempValue == nil then
                    tempValue = 0;
                end
            else
--                local loveValue = GetExProp(catMom, "LOVE_POWER");
                
                local sObj = GetSessionObject(catMom, 'ssn_klapeda');
                local loveValue = TryGetProp(sObj, "KLAPEDA_FISHING_CAT");
                
                if loveValue == nil then
                    loveValue = 0;
                end
                
                if loveValue > tempValue then
                    topLover = catMom;
                    tempValue = loveValue;
                end
            end
        end
        
        local nowLover = GetExArgObject(self, "NOW_LOVER");
        if nowLover ~= nil then
            if IsSameActor(nowLover, topLover) == "YES" then
                return;
            end
        end
        
        SetExArgObject(self, "NOW_LOVER", topLover)
    end
end



function FOLLOW_KLAPEDA_FISHING_CAT(self, range)
    local owner = GetExArgObject(self, "NOW_LOVER");
    if owner == nil then
        SCR_KLAPEDA_FISHING_CAT_RUN(self);
        owner = GetExArgObject(self, "NOW_LOVER");
        if owner == nil then
            SCR_KLAPEDA_FISHING_CAT_RETURN_HOME(self);
            return 0;
        end
    end
    
--    local lovePower = GetExProp(owner, "LOVE_POWER");
    
    local sObj = GetSessionObject(owner, "ssn_klapeda");
    local lovePower = TryGetProp(sObj, "KLAPEDA_FISHING_CAT");
    
    if lovePower == nil then
        SCR_KLAPEDA_FISHING_CAT_RETURN_HOME(self);
        return 0;
    end
    
    if lovePower <= 10 then
        SCR_KLAPEDA_FISHING_CAT_RETURN_HOME(self);
        return 0;
    end
    
    -- 고양이 채팅 --
    local chatTimeCount = GetExProp(self, "CHAT_TIME_COUNT");
    if chatTimeCount > 0 then
        chatTimeCount = chatTimeCount - 1;
        SetExProp(self, "CHAT_TIME_COUNT", chatTimeCount);
    end
    
    if chatTimeCount == 0 then
        if IMCRandom(1, 100) <= 5 then
            Chat(self, ScpArgMsg("KLAPEDA_FISHING_CAT_Chat" .. IMCRandom(1, 2)), 3);
            SetExProp(self, "CHAT_TIME_COUNT", 10 * 2);    -- 500ms 마다 작동하므로 *2 를 하면 1이 1초가 됨 --
        end
    end
    
    -- 고양이 애니 --
    local animTimeCount = GetExProp(self, "ANIM_TIME_COUNT");
    if animTimeCount > 0 then
        animTimeCount = animTimeCount - 1;
        SetExProp(self, "ANIM_TIME_COUNT", animTimeCount);
    end
    
    local dist = GetDistance(self, owner);
    if dist <= range then
        if animTimeCount == 0 then
            if IMCRandom(1, 100) <= 10 then
                local aniList = { "PUB_IDLE", "PUB_IDLE2", "PUB_IDLE3" };
                PlayAnim(self, aniList[IMCRandom(1, #aniList)], nil, 1)
                SetExProp(self, "ANIM_TIME_COUNT", 5 * 2); -- 500ms 마다 작동하므로 *2 를 하면 1이 1초가 됨 --
            end
        end
        
        return 0;
    end
    
    CancelMonsterSkill(self);
    ResetHate(self);
    
    local moveType = TryGetProp(self, "MoveType");
--    ChangeMoveSpdType(self, "RUN");
    owner = GetExArgObject(self, "NOW_LOVER");
    if owner == nil then
        return 0;
    end
    
    if moveType ~= nil and moveType ~= 'Holding' then
        StopAnim(self);
        MoveToTarget(self, owner, 30)
    end
    
    local distance = GetDistance(self, owner);
    if distance <= 30 then
        return 1;
    end
    
    return 1;
end

function SCR_KLAPEDA_FISHING_CAT_RETURN_HOME(self)
    local x, y, z = -77.6, 150, -142.2;
    
    local range = GetDistFromPos(self, x, y, z)
    
    if range >= 100 then
        StopMove(self);
        SetPos(self, x, y, z);
        CancelMonsterSkill(self)
    end
end



function SCR_KLAPEDA_FISHING_CAT_TS_BORN_ENTER(self)
    ChangeMoveSpdType(self, "WLK");
end

function SCR_KLAPEDA_FISHING_CAT_TS_BORN_UPDATE(self)
    RunScript("FOLLOW_KLAPEDA_FISHING_CAT", self, 40);
end

function SCR_KLAPEDA_FISHING_CAT_TS_BORN_LEAVE(self)
end

function SCR_KLAPEDA_FISHING_CAT_TS_DEAD_ENTER(self)
end

function SCR_KLAPEDA_FISHING_CAT_TS_DEAD_UPDATE(self)
end

function SCR_KLAPEDA_FISHING_CAT_TS_DEAD_LEAVE(self)
end



function SCR_KLAPEDA_FISHING_BOARD_DIALOG(self, pc)
    ExecClientScp(pc, 'FISHING_RANK_OPEN()');
end



function SCR_KLAPEDA_FISHING_MANAGER_DIALOG(self, pc)
    COMMON_QUEST_HANDLER(self,pc)
end

function SCR_KLAPEDA_FISHING_MANAGER_NORMAL_1(self, pc)
    LookAt(self, pc);
    local selectMenu = ShowSelDlg(pc, 0, 'Fish_Shop_Klapead_Dlg5', ScpArgMsg("FISH_RUBBING_YES"), ScpArgMsg("FISH_RUBBING_NO"));
    if selectMenu == 1 then
        local rubbingItemName = "Silver_Fish";  -- 은빛 물고기 --
        local fishItem, fishCnt = GetInvItemByName(pc, rubbingItemName)
        if fishCnt >= 1 then
        	local fishItemID = TryGetProp(fishItem, 'ClassID');
        	local fishItemGUIDStr = GetItemGuid(fishItem);
        	
            local tx = TxBegin(pc);
            TxTakeItem(tx, rubbingItemName, 1, "FISH_RUBBING");
            local ret = TxCommit(tx);
            
            if ret == "SUCCESS" then
                local minScore = 10000;
                local maxScore = 99999;
                local topRankScore = GetFishRubbingScoreFirst();
                local lowRankScore = GetFishRubbingScoreLast();
                if maxScore < topRankScore then -- 만약 최대치보다 현재 1등 점수가 높다면? --
                    maxScore = topRankScore + 100;  -- 현재 1등 점수 + 100까지가 최대치로 변경 --
                end
                
                local rubbingScore = IMCRandom(minScore, maxScore);
                if rubbingScore >= 90000 then   -- 90,000 이상이면 다시 돌린다 --
                    rubbingScore = IMCRandom(minScore, maxScore);
                end
                
                if rubbingScore == topRankScore then    -- 내 점수가 1등의 점수와 같다면? --
                    local addScore = IMCRandom(-10, 9); -- -10 ~ +10 까지 랜덤 (0을 제외하기 위해 랜덤함수는 9까지만하고 +1 처리 --
                    if addScore >= 0 then
                        addScore = addScore + 1;
                    end
                    
                    rubbingScore = rubbingScore + addScore;
                end
                
                local myRankingScore = GetFishRubbingScoreByPC(pc);
                if myRankingScore ~= nil and myRankingScore ~= 0 then
                    if rubbingScore > myRankingScore then    -- 자신이 랭킹에 있는 경우, 랭킹에 있는 크기보다 크다면 멘트 --
                        ShowOkDlg(pc, 'Fish_Shop_Klapead_Dlg6', 1);
                    end
                end
                
                if myRankingScore == nil then   -- 아래쪽에서 랭킹에 넣을 지 말지 확인을 위해 0처리 --
                    myRankingScore = 0;
                end
                
                -- 여기에 탁본 UI 호출 --
                local msgIndex = IMCRandom(1, 10);   -- 메시지 종류, clientmessage.xml 의 510600 ~ 추가 --
                SendAddOnMsg(pc, 'FISH_RUBBING_PAPER_FISH', ScpArgMsg("FishRubbingMSG" .. msgIndex), rubbingScore);
                
                if rubbingScore > myRankingScore then
                    SetFishRubbingScore(pc, rubbingScore, fishItemID, fishItemGUIDStr);
                    ShowOkDlg(pc, 'Fish_Shop_Klapead_Dlg6', 1);
                    if rubbingScore > topRankScore then -- 1등일 때 --
                        PlayEffect(pc, "F_fish01", 1.0, nil, 'BOT');
                        SendAddOnMsg(pc, "NOTICE_Dm_Fishing", ScpArgMsg("FishRubbingScoreTopRankin"), 5);
                        ShowOkDlg(pc, 'Fish_Shop_Klapead_Dlg7', 1);
                    elseif rubbingScore > lowRankScore then	-- 1등은 아니지만 랭킹에 들어갔을 때 --
                        PlayEffect(pc, "F_fish02", 1.0, nil, 'BOT');
                        SendAddOnMsg(pc, "NOTICE_Dm_Fishing", ScpArgMsg("FishRubbingScoreRankin"), 5);
                        ShowOkDlg(pc, 'Fish_Shop_Klapead_Dlg8', 1);
                    else
                    	ShowOkDlg(pc, 'Fish_Shop_Klapead_Dlg9', 1);
                    end
                else
                    ShowOkDlg(pc, 'Fish_Shop_Klapead_Dlg11', 1);
                end
            end
        else
            ShowOkDlg(pc, 'Fish_Shop_Klapead_Dlg10', 1);    -- 탁본은 은빛 물고기가 있어야 할 수 있어요 --
        end
    end
end

function SCR_KLAPEDA_FISHING_MANAGER_NORMAL_2(self,pc)
    ShowTradeDlg (pc, 'Fish_Shop_Manager', 5)
end

function SCR_KLAPEDA_FISHING_MANAGER_NORMAL_3_PRE(pc)
    local aObj = GetAccountObj(pc)
    if aObj.TUTO_FISHING_ITEM_GIVE == 1 then
        return 'YES'
    end
end

function SCR_KLAPEDA_FISHING_MANAGER_NORMAL_3(self,pc)
    local aObj = GetAccountObj(pc)
    local tx = TxBegin(pc)
    TxSetIESProp(tx, aObj, 'TUTO_FISHING_ITEM_GIVE', 300)
    TxGiveItem(tx, 'Paste_Bait_basic_2', 1000, "TUTO_FISHING_ITEM_GIVE")
    TxGiveItem(tx, 'Fishing_Rod_Quest_1', 1, "TUTO_FISHING_ITEM_GIVE")
    local ret = TxCommit(tx)
end

function SCR_TUTO_FISHING_SUCCESS_TX_FUNC(pc,tx)
    local aObj = GetAccountObj(pc);
    if aObj.TUTO_FISHING_ITEM_GIVE == 0 then
        TxSetIESProp(tx, aObj, 'TUTO_FISHING_ITEM_GIVE', 1)
    end
end
