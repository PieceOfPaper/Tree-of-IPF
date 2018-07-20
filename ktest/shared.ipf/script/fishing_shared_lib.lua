-- 낚시 사전 체크 --
function SCR_FISHING_PRE_CHECK(pc)
    local isWater = 0;
    for i = 1, 5 do
        local fx, fy, fz = GetFrontPos(pc, i * 5);
        local mapMaterial = GetMapMaterial(pc, fx, fy, fz);
        if mapMaterial == "water" then
            isWater = 1;
        end
    end
    
    if isWater ~= 1 then
        -- 물가를 향해서 사용해주세요. --
        SendAddOnMsg(pc, "NOTICE_Dm_Fishing", ScpArgMsg("PleaseUseItForTheWater"), 5);
        return "FAIL", "MapMaterialIsNotWater";
    end
    
    if IsBattleState(pc) ~= 0 then
        -- 전투상태에서는 불가능합니다 --
        SendSysMsg(pc, 'CanNotBattleState');
        return "FAIL", "BattleState";
    end
    
    if CheckFishingSuccessCount(pc) == 0 then
        -- 낚시 성공 최대 횟수를 초과했습니다 --
        SendSysMsg(pc, 'ExceedFishingSuccessCount');
        return "FAIL", "FishingSuccessCountIsFull";
    end
    
    if IsFullFishingItemBag(pc) == 1 then
        -- 살림통이 꽉 찼습니다 --
        SendSysMsg(pc, 'FishingItemBagIsFull');
        ExecClientScp(pc, 'FISHING_ITEM_BAG_OPEN_UI()');
        return "FAIL", "FishingItemBagFull";
    end
    
    -- 가까이에 다른 낚시꾼이 있어 사용할 수 없습니다 --
    local pcList, pcCount = GetWorldObjectList(pc, "PC", 30);
    if pcCount >= 1 then
        for k = 1, pcCount do
            if IS_PC(pcList[k]) == true then  -- 대상이 PC 고 --
                if IsSameActor(pc, pcList[k]) == "NO" then
                    if IsFishingState(pcList[k]) == 1 then    -- 낚시 중이라면 --
                        SendSysMsg(pc, 'TooCloseToSomeoneElseWhoIsFishing');
                        return "FAIL", "TooCloseFishingPC";
                    end
                end
            end
        end
    end
    
    return "SUCCESS", nil;
end


-- 낚싯대 --
function SCR_PRE_FISHING_ROD(self, argstring, argnum1, argnum2)
    -- 낚시 중이라면 사용 불가 --
    if IsFishingState(self) == 1 then
        return 0;
    end
    
--    local list, cnt = SelectObjectByClassName(self, 300, "FishingPlace");
    local list, cnt = GetWorldObjectList(self, "MON", 300);
    if cnt >= 1 then
        local fishingPlace = nil;
        for i = 1, cnt do
            if list[i].ClassName == "FishingPlace" then
                local distance = GetDistance(self, list[i]);
                local range = TryGetProp(list[i], "Range");
                if range == nil then
                    range = 0;
                end
                
                if distance <= range then
                    if fishingPlace == nil then
                        fishingPlace = list[i];
                    else
                        if distance < GetDistance(self, fishingPlace) then  -- 새로 검색된 낚시터와 기존 검색 낚시터의 거리를 비교해서 더 가까운 쪽으로 대체 --
                            fishingPlace = list[i];
                        end
                    end
                end
            end
        end
        
        if fishingPlace ~= nil then
            local isWater = 0;
            for j = 1, 5 do
                local fx, fy, fz = GetFrontPos(self, j * 5);
                local mapMaterial = GetMapMaterial(self, fx, fy, fz);
                if mapMaterial == "water" then
                    isWater = 1;
                end
            end
            
            if isWater ~= 1 then
                -- 물가를 향해서 사용해주세요. --
                SendAddOnMsg(self, "NOTICE_Dm_Fishing", ScpArgMsg("PleaseUseItForTheWater"), 5);
                return 0;
            end
            
            local checkRet, errLog = SCR_FISHING_PRE_CHECK(self);
            if checkRet ~= 'SUCCESS' then
                return 0;
            end
            
            return GetHandle(fishingPlace);
        end
        
        -- 조금 더 물가에 가까이 다가가 시도해주세요. --
        SendAddOnMsg(self, "NOTICE_Dm_Fishing", ScpArgMsg("PleaseComeALittleCloserAndTry"), 5);
        return 0;
    end
    
    -- 이곳은 낚시터가 아닙니다. 낚시터에서 사용해주세요. --
    SendAddOnMsg(self, "NOTICE_Dm_Fishing", ScpArgMsg("ThisIsNotAFishingSpotPleaseUseItAtTheFishingSpot"), 5);
    return 0;
end


function SCR_USE_FISHING_ROD(self, argObj, argstring, arg1, arg2, itemID)
    if IsFishingState(self) == 1 then
        return;
    end
    
    local fishingPlace = GetHandle(argObj);
    
    local scriptString = string.format("FISHING_OPEN_UI(%d, %d)", fishingPlace, itemID)
    
    ExecClientScp(self, scriptString)
end



-- 떡밥 --
function SCR_PRE_SPREAD_BAIT(self, argstring, argnum1, argnum2)
--    local list, cnt = SelectObjectByClassName(self, 300, "FishingPlace");
    local list, cnt = GetWorldObjectList(self, "MON", 300);
    if cnt >= 1 then
        local fishingPlace = nil;
        for i = 1, cnt do
            if list[i].ClassName == "FishingPlace" then
                local distance = GetDistance(self, list[i]);
                local range = TryGetProp(list[i], "Range");
                if range == nil then
                    range = 0;
                end
                
                if distance <= range then
                    if fishingPlace == nil then
                        fishingPlace = list[i];
                    else
                        if distance < GetDistance(self, fishingPlace) then  -- 새로 검색된 낚시터와 기존 검색 낚시터의 거리를 비교해서 더 가까운 쪽으로 대체 --
                            fishingPlace = list[i];
                        end
                    end
                end
            end
        end
        
        if fishingPlace ~= nil then
            if IsBuffApplied(list[i], "Fishing_SpreadBait") == "YES" then
                -- 낚시터에 이미 떡밥이 적용 중입니다. --
                SendAddOnMsg(self, "NOTICE_Dm_Fishing", ScpArgMsg("TheSpreadBaitIsAlreadyInTheFishingPlace"), 5);
                return 0;
            end
            
            return GetHandle(fishingPlace);
        end
        
        -- 조금 더 물가에 가까이 다가가 시도해주세요. --
        SendAddOnMsg(self, "NOTICE_Dm_Fishing", ScpArgMsg("PleaseComeALittleCloserAndTry"), 5);
        return 0;
    end
    
    -- 이곳은 낚시터가 아닙니다. 낚시터에서 사용해주세요. --
    SendAddOnMsg(self, "NOTICE_Dm_Fishing", ScpArgMsg("ThisIsNotAFishingSpotPleaseUseItAtTheFishingSpot"), 5);
    return 0;
end

function SCR_USE_SPREAD_BAIT(self, argObj, argstring, arg1, arg2, itemID)
    AddBuff(argObj, argObj, "Fishing_SpreadBait", 99, arg1, 600000, 1);
    
    local teamName = GetTeamName(self)
    SendAddOnMsg(self, "NOTICE_Dm_Fishing", ScpArgMsg("{TeamName}_SprinkledTheSpeadBait", "TeamName", teamName), 5);
    
--    local list, cnt = SelectObject(argObj, 300, "ALL");
    local list, cnt = GetWorldObjectList(self, "PC", 300);
    if cnt >= 1 then
        for i = 1, cnt do
            if IS_PC(list[i]) == true then  -- 대상이 PC 고 --
                if IsFishingState(list[i]) == 1 then    -- 낚시 중이면서 --
                    local fishingPlace = GetExArgObject(list[i], "MyFishingPlace")
                    if fishingPlace ~= nil then -- 현재 낚시터의 정보가 있고 --
                        if IsSameObject(argObj, fishingPlace) == 1 then -- 내가 떡밥을 뿌린 낚시터와 같은 낚시터라면 메시지 전송 --
                            -- xx님이 떡밥을 뿌렸습니다! --
                            SendAddOnMsg(list[i], "NOTICE_Dm_Fishing", ScpArgMsg("{TeamName}_SprinkledTheSpeadBait", "TeamName", teamName), 5);
                        end
                    end
                end
            end
        end
    end
end



-- 낚시 모닥불 --
function SCR_PRE_FISHING_FIRE(self, argstring, argnum1, argnum2)
--    local list, cnt = SelectObjectByClassName(self, 300, "FishingPlace");
    local list, cnt = GetWorldObjectList(self, "MON", 300);
    if cnt >= 1 then
        for i = 1, cnt do
            if list[i].ClassName == "FishingPlace" then
                local distance = GetDistance(self, list[i]);
                local range = TryGetProp(list[i], "Range");
                if range == nil then
                    range = 0;
                end
                
                if distance <= range + 50 then
                    local fireList, fireCnt = SelectObjectByProp(self, 80, "ClassName", "FishingFire_1", 1)
                    if fireCnt >= 1 then
                        -- 주변에 설치된 낚시 모닥불이 있습니다. 다른 곳에서 시도해주세요. --
                        SendAddOnMsg(self, "NOTICE_Dm_Fishing", ScpArgMsg("NearbyIsAFishingBonfirePleaseTryItElsewhere"), 5);
                        return 0;
                    end
                    
                    return 1;
                end
            end
        end
        
        -- 조금 더 물가에 가까이 다가가 시도해주세요. --
        SendAddOnMsg(self, "NOTICE_Dm_Fishing", ScpArgMsg("PleaseComeALittleCloserAndTry"), 5);
        return 0;
    end
    
    -- 이곳은 낚시터가 아닙니다. 낚시터에서 사용해주세요. --
    SendAddOnMsg(self, "NOTICE_Dm_Fishing", ScpArgMsg("ThisIsNotAFishingSpotPleaseUseItAtTheFishingSpot"), 5);
    return 0;
end

function SCR_USE_FISHING_FIRE(self, argObj, argstring, arg1, arg2, itemID)
    local className = argstring;
    local lifeTime = arg1;
    
    local x, y, z = GetRightPos(self, 30);
    local fishingFire = CREATE_MONSTER_EX(self, className, x, y, z, GetDir(self), 'Neutral', nil, SCR_FISHING_FIRE_SET, self);
--    SetFixAnim(fishingFire, "ON")
    
    AttachEffect(fishingFire, "F_fish_fire01", 1.0, 'BOT');
    SetLifeTime(fishingFire, lifeTime)
end

function SCR_FISHING_FIRE_SET(mon, pc)
    local teamName = GetTeamName(pc);
    mon.Name = ScpArgMsg("{TeamName}_bonfire", "TeamName", teamName);
    mon.Dialog = "None";
    mon.Enter = "FISHING_FIRE";
    mon.Leave = "FISHING_FIRE";
    mon.Range = 80;
end

function SCR_FISHING_FIRE_ENTER(self, pc)
    if IS_PC(pc) == true then
        if IsBuffApplied(pc, "Fishing_Fire") == "NO" then
            AddBuff(self, pc, "Fishing_Fire", 1, 0, 0, 1);
        end
    end
end

function SCR_FISHING_FIRE_LEAVE(self, pc)
    if IS_PC(pc) == true then
        if IsBuffApplied(pc, "Fishing_Fire") == "YES" then
            RemoveBuff(pc, "Fishing_Fire");
        end
    end
end



-- 물고기 --
function SCR_PRE_FISH_BASIC(self, argstring, argnum1, argnum2)
    if SCR_PRECHECK_CONSUME(self) == 0 then
        return 0;
    end
    
    if IsServerSection(self) == 1 then
        local list, cnt = SelectObject(self, 15, "ALL", 1);
        if cnt >= 1 then
            local fishingFire = nil;
            for i = 1, cnt do
                local target = list[i];
                if target.ClassName ~= "PC" then
                    if target.ClassName == "bonfire_1" or target.Enter == "FISHING_FIRE" then
                        fishingFire = target;
                        break;
                    end
                end
            end
            
            if fishingFire ~= nil then
                return GetHandle(fishingFire);
            end
        end
        
        SendAddOnMsg(self, "NOTICE_Dm_Fishing", ScpArgMsg("UseItAroundCampfires"), 5);
    end
    return 0;
end

function SCR_USE_FISH_BASIC(self, argObj, argstring, arg1, arg2, itemID)
--    -- fishing BBQ --
--    LookAt(self, argObj);
--    PlayAnim(self, 'fishing_BBQ');
--    
--    -- HP, SP 회복량 증가 버프 --
--    AddBuff(self, self, "FISH_RHP_RSP", 1, 0, 600000, 1);
    
    LookAt(self, argObj);
    local result1 = DOTIMEACTION_R(self, ScpArgMsg("GrillingFishAndEating"), 'fishing_BBQ', 5.0);
    if result1 == 1 then
        local invItem, count = GetInvItemByType(self, itemID)
        if count >= 1 then
            local tx = TxBegin(self);
            TxTakeItem(tx, invItem.ClassName, 1, "USE_ITEM_FISH_BASIC", packetDelay, cubeID)
            local ret = TxCommit(tx);
            if ret == "SUCCESS" then
                -- HP, SP 회복량 증가 버프 --
                AddBuff(self, self, "FISH_RHP_RSP", 1, 0, 600000, 1);
            end
        end
    end
end



-- 미끼 검사 --
function IS_PASTE_BAIT_ITEM(itemClassID)
    local itemClass = GetClassList("Item");
    local pasteBait = GetClassByTypeFromList(itemClass, itemClassID)
    if pasteBait ~= nil then
        if pasteBait.GroupName == "PasteBait" then
            return 1;
        end
    end
    
    return 0;
end



-- 최대 낚시 성공 횟수 --
function SCR_GET_MAX_FISHING_SUCCESS_COUNT(pc)
    local count = 0;
    if IsServerObj(pc) == 1 then -- for server
        count = GetMaxFishingItemBagSlotCount(pc);
    else -- for client
        local account = session.barrack.GetMyAccount();
        count = account:GetMaxFishingItemBagSlotCount();
    end
    return count;
end