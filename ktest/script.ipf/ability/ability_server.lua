function SCR_TX_PROPERTY_ACTIVE_TOGGLE(pc, abilName)
    local abilObj = GetAbilityIESObject(pc, abilName);
    if abilObj == nil then        
        return;
    end
    
    if abilObj.AlwaysActive == 'YES' then        
        return;
    end
    
    if abilName == 'Corsair7' then
        for i=1, 3 do
            local tgt = GetExArgObject(pc, "IRON_HOOK_TGT_"..i);
            if nil ~= tgt and "YES" == IsBuffApplied(tgt, "IronHooked") then
                return;
            end
        end
    end
    
    if abilName == 'Sadhu5' then
        if nil ~= pc and "YES" == IsBuffApplied(pc, "OOBE_Debuff") then
            return;
        end
    end 
    
    local isrunning = GetExProp(pc, "ACTIVE_ABIL_TOGGLE");
    if isrunning == 1 then                
        return;
    end
    
    SetExProp(pc, "ACTIVE_ABIL_TOGGLE", 1);
    
    local tx = TxBegin(pc);
    TxEnableInIntegrate(tx);

    local IsActiveState = GetIESProp(abilObj, "ActiveState");
    
    if IsActiveState == 1 then
        IsActiveState = 0;
    else
        IsActiveState = 1;
    end
    
    -- 특성 on/off 시에 조건을 만족하지 않는다면 강제 off 시킨다.
    if CHECK_ABILITY_LOCK(pc, abilObj) ~= 'UNLOCK' then
        IsActiveState = 0;
    end
    
    TxSetIESProp(tx, abilObj, "ActiveState", IsActiveState);
    local ablCls = GetClass("Ability", abilName)
    if ablCls ~= nil then        
        local txScpName = TryGetProp(ablCls, 'ScriptTX')
        if nil ~= txScpName and 'None' ~= ablCls.ScriptTX then            
            local func = _G[ablCls.ScriptTX];            
            if false == func(pc, tx, IsActiveState) then    -- 스킬이 없어도 아무것도 하지 않고 정상처리 되도록 수정함.(TX_SCR_SET_ABIL_HEADSHOT_OPTION)
                TxRollBack(tx)
                SetExProp(pc, "ACTIVE_ABIL_TOGGLE", 0);                
                return            
            end
        end
    end
    local ret = TxCommit(tx);
    
    if ret == 'SUCCESS' then        
        SetAbilityActiveState(pc, abilName, IsActiveState);
        local AbilityIES = GetClass("Ability", abilName);
        if AbilityIES ~= nil then
            local skillProp = GetClass("Skill", AbilityIES.SkillCategory);
            if skillProp ~= nil then
                UpdateSkillPropertyBySkillID(pc, skillProp.ClassID)
                UpdateSkillSpendItemBySkillID(pc, skillProp.ClassID)
            end
        end
        
        SendAddOnMsg(pc, "RESET_ABILITY_ACTIVE", abilName, IsActiveState);
        InvalidateStates(pc);       

        if abilName == "Barbarian22" then
            RemoveBuff(pc, 'Frenzy_Buff');
        end
    end 
    SetExProp(pc, "ACTIVE_ABIL_TOGGLE", 0);
end

function GET_REAMIN_ABILTIME(pc)
    
    for i = 1, RUN_ABIL_MAX_COUNT do
        local prop = "LearnAbilityTime_" ..i;
        local propValue = "None"
        if pc[prop] ~= nil and pc[prop] ~= "None" then
            propValue = pc[prop];
        end
        local learnAbilTime = imcTime.GetSysTimeByStr(propValue);
        local sysTime = GetDBTime();
    
        if imcTime.IsLaterThan(learnAbilTime, sysTime) == 1 then
            return imcTime.GetDifSec(sysTime, learnAbilTime);
        end
    end
    return 0;
end

-- 특성배우기 요청
function SCR_TX_ABIL_REQUEST(pc, abilName, count)
    count = math.floor(count);
    if count < 0 then
        return;
    end
    
    local runCnt = 0;
    local maxCount = GetCashValue(pc, "abilityMax");
    -- LearnAbilityID도 포함하기때문에 maxCount가 5라면  LearnAbilityID, LearnAbilityID_1~4 까지만 계산해야됨.
    maxCount = maxCount -1; 

    for i = 0, maxCount do
        local prop = "None";
        if 0 == i then
            prop = "LearnAbilityID";
        else
            prop = "LearnAbilityID_" ..i;
        end

        if pc[prop] > 0 then
            runCnt = runCnt+1;
        end
    end

    if runCnt > maxCount then   
        return;
    end

    local abilClass = GetClass('Ability', abilName);
    if abilClass == nil then
        return;
    end

    -- 어빌 구입그룹이 겹치지 않은지 체크
    local canBuy = CheckBuyAbilityGroup(pc, abilName);
    if canBuy == 0 then
        SendSysMsg(pc, "NoBuyAbilityForBuyGroup");
        return;
    end

    local oriLevel = 0;
    local abilLevel = count;
    local abilObj = GetAbilityIESObject(pc, abilName);  
    if abilObj ~= nil then
        oriLevel = abilObj.Level;
        abilLevel = abilObj.Level + count;
    end
        
    local shopName = GetExProp_Str(pc, "ABILSHOP_OPEN");    
    local abilGroupClass = GetClass(shopName, abilName);
    if abilGroupClass == nil then
        IMC_LOG("INFO_NORMAL", shopName, abilName .. " GetClass is nil");        
        return;
    end

    if abilGroupClass.MaxLevel <= oriLevel then
        return;
    end
    if abilGroupClass.MaxLevel < abilLevel then
        return;
    end

    local unlockFuncName = abilGroupClass.UnlockScr;
    if unlockFuncName ~= 'None' then
        local scp = _G[unlockFuncName];
        local ret = scp(pc, abilGroupClass.UnlockArgStr, abilGroupClass.UnlockArgNum, abilObj);
        if ret ~= 'UNLOCK' then
            if ret == "LOCK_GRADE" then
                return;
            elseif ret == 'LOCK_LV' then
                return;
            end
        end
    end
    
    local abilPrice = 0;
    local abilTime = 0; -- 분 단위
    local tempAbilPrice = 0;
    local tempAbilTime = 0;

    for lv=oriLevel+1, abilLevel, 1 do  
        -- 스크립트 가격 함수있으면 우선 적용
        local funcName = abilGroupClass.ScrCalcPrice;
        if funcName ~= 'None' then
            local scp = _G[funcName];
            tempAbilPrice, tempAbilTime = scp(pc, abilName, lv, abilGroupClass.MaxLevel); 
        else
            tempAbilPrice = abilGroupClass["Price" .. lv];
            tempAbilTime = abilGroupClass["Time"..lv];
        end

        if IS_SEASON_SERVER(pc) == "YES" then
            tempAbilPrice = tempAbilPrice - (tempAbilPrice * 0.4)
--      else
--          tempAbilPrice = tempAbilPrice - (tempAbilPrice * 0.2)
        end
    
        tempAbilPrice = math.floor(tempAbilPrice);
        tempAbilTime = math.floor(tempAbilTime);
        
        abilPrice = abilPrice + tempAbilPrice;
        abilTime = abilTime + tempAbilTime; 
    end
    
    -- 토큰 썼으면 즉시 습득.
    if IsPremiumState(pc,ITEM_TOKEN) == 1 then
        abilTime = 0;
    else
        -- 토큰 안썼으면 한번에 1렙씩만. 그래도 즉시 습득은 바로 배우게 해주자
        if count > 1 and abilTime > 0 then
            return;
        end
    end

    -- 어빌 구입가능한지 특성 포인트 체크
    local myAbilityPoint = TryGetProp(pc, 'AbilityPoint');
    if myAbilityPoint == nil then
        return;
    end
    if myAbilityPoint == 'None' then
        myAbilityPoint = 0;
    end
    myAbilityPoint = tonumber(myAbilityPoint);
    local resultAbilityPoint = myAbilityPoint - abilPrice;
    if abilPrice < 0 or resultAbilityPoint < 0 then
        SendSysMsg(pc, "NotEnoughAbilityPoint");
        return;
    end
    
    -- 습득 중인 특성은 못배움. 
    -- 같은특성은 1개씩만
    for i = 0, runCnt do
        if i == 0 then
            if pc["LearnAbilityID"] == abilClass.ClassID then
                SendSysMsg(pc, "LearningAbilityTime");
                return;
            end
        else
            if pc["LearnAbilityID_"..i] == abilClass.ClassID then
                SendSysMsg(pc, "LearningAbilityTime");
                return;
            end
        end
    end

    if abilLevel > 0 then
        local jobHistory = GetJobHistoryString(pc)
        local maxLevel = 0;
        local sList = StringSplit(jobHistory, ";");

        for i = 1, #sList do
            local jobCls = GetClass("Job", sList[i])

            if jobCls ~= nil then
                local abilGroupClass = GetClass("Ability_"..jobCls.EngName, abilName);
                if abilGroupClass ~= nil then
                    maxLevel = abilGroupClass.MaxLevel
                    break;
                end
            end
        end

        if maxLevel == 0 then
            IMC_LOG("ERROR_ABILITY_MAX_LEVEL_GREATER_ZERO", "abilGroupClass is nil!!!! JobHistory : "..jobHistory.." ".." AbilName : "..abilName);
        end

        if maxLevel < abilLevel then
            return;
        end
    end
    
    if abilTime == 0 then
        -- 즉시 배우기
        SCR_TX_PROPERTY_UP(pc, abilName, abilPrice, nil, count, "learnnow");
    else
        local sysTime = GetDBTime();
        local learnAbilTime = imcTime.AddSec(sysTime, abilTime * 60);

        local time = "None";
        local id = "None";
        for i = 0, runCnt do
            if i == 0 then
                if pc["LearnAbilityID"] == 0 then
                    time = "LearnAbilityTime";
                    id = "LearnAbilityID";
                    break;
                end
            else
                if pc["LearnAbilityID_"..i] == 0 then
                    time = "LearnAbilityTime_"..i
                    id = "LearnAbilityID_"..i
                    break;
                end
            end
        end

        if id == "None" then
            return;
        end
        
        local infoMsg = "set abil 2 "..GetPcCIDStr(pc).." ["..time.."] ["..imcTime.GetStringSysTime(learnAbilTime).."]".."["..id.."] ["..abilClass.ClassID.."]".."["..count.."]"
        
        local tx = TxBegin(pc);     
        TxSetIESProp(tx, pc, time, imcTime.GetStringSysTime(learnAbilTime));
        TxSetIESProp(tx, pc, id, abilClass.ClassID);
        TxSetIESProp(tx, pc, 'AbilityPoint', resultAbilityPoint);
        local ret = TxCommit(tx);
        if ret == 'SUCCESS' then
            SendAddOnMsg(pc, "RESET_ABILITY_UP", shopName, abilClass.ClassID);
            AbilityMongoLog(pc, abilName, abilPrice, "Training", oriLevel, oriLevel, abilTime);
            AbilityPointMongoLog(pc, abilPrice, resultAbilityPoint, 0, 'Training');
        end

        --IMC_NORMAL_INFO(infoMsg .. " " .. ret);
    end
end

function SCR_TX_BUY_ABILITY_POINT(pc, requestCount)
    if requestCount < 0 then
        return;
    end
    
    local exchangeRate = SILVER_BY_ONE_ABILITY_POINT;
    -- Test Server Spec : 80% Sale --
    if (GetServerNation() == "KOR" and (GetServerGroupID() == 9001 or GetServerGroupID() == 9501)) then
        exchangeRate = math.floor(exchangeRate * 0.2);
    end
    
    if exchangeRate < 1 then
        exchangeRate = 1;
    end
    
    local price = requestCount * exchangeRate;
    local money = GetInvItemCount(pc, 'Vis');
    if price > money then
        SendSysMsg(pc, 'NotEnoughMoney');
        return;
    end

    local currentPoint = TryGetProp(pc, 'AbilityPoint');
    if currentPoint == nil then        
        return;
    end
    if currentPoint == 'None' then
        currentPoint = 0;
    end
    currentPoint = tonumber(currentPoint);
    local resultPoint = currentPoint + requestCount;
    if resultPoint > MAX_ABILITY_POINT then
        SendSysMsg(pc, 'ExceedMaxAbilityPoint');
        return;
    end

    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end
    TxTakeItem(tx, 'Vis', price, "AbilityPoint");
    TxSetIESProp(tx, pc, 'AbilityPoint', resultPoint);

    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
        SendAddOnMsg(pc, 'SUCCESS_BUY_ABILITY_POINT');
        AbilityPointMongoLog(pc, requestCount, resultPoint, price, 'Buy');
    end
end

function SCR_TX_CHECK_WRONG_ABIL(pc)

    if pc ~= nil then

        local maxCount = string.format("%d", RUN_ABIL_MAX_COUNT);

        for i = 0, maxCount do
            local prop1 = "None";
            local prop2 = "None";
            if 0 == i then
                prop1 = "LearnAbilityID";
                prop2 = "LearnAbilityTime";
            else
                prop1 = "LearnAbilityID_" ..i;
                prop2 = "LearnAbilityTime_" ..i;
            end

            if pc[prop1] == 0 and pc[prop2] ~= "None" then -- 믿을 수 없지만 개발 DB에 이렇게 들어간 걸 본 적이 있다.

                local infoMsg = "wrong abil 67 "..GetPcCIDStr(pc).." "..pc[prop1].." "..pc[prop2];
                
                local tx = TxBegin(pc);
                if tx == nil then
                    return
                end
                TxSetIESProp(tx, pc, prop1, 0);
                TxSetIESProp(tx, pc, prop2, "None");
                local ret = TxCommit(tx);

                IMC_LOG("INFO_NORMAL", infoMsg.. " " .. ret);

                return
            end

            if pc[prop1] ~= 0 and pc[prop2] == "None" then
                
                IMC_LOG("INFO_NORMAL", "wrong abil 68 "..GetPcCIDStr(pc).." "..pc[prop1]..""..pc[prop2] )

                local abilClass = GetClassByType('Ability', pc[prop1]);

                if abilClass ~= nil then

                    local sysTime = GetDBTime();
                    local learnAbilTime = imcTime.AddSec(sysTime, 1);

                    local tx = TxBegin(pc);
                    if tx == nil then
                        return
                    end
                    TxSetIESProp(tx, pc, prop1, pc[prop1]);
                    TxSetIESProp(tx, pc, prop2, imcTime.GetStringSysTime(learnAbilTime));
                    TxCommit(tx);

                    return
                else
                    IMC_LOG("INFO_NORMAL", "wrong abil 69 "..GetPcCIDStr(pc).." "..pc[prop1]..pc[prop2] )

                    local tx = TxBegin(pc);
                    if tx == nil then
                        return
                    end
                    TxSetIESProp(tx, pc, prop1, 0);
                    TxSetIESProp(tx, pc, prop2, "None");
                    TxCommit(tx);

                    return
                end
                
            end
        end

    end
end

-- 특성 렙업
g_logCount = 0;
function SCR_TX_PROPERTY_UP(pc, abilName, abilPrice, abilityID, count, learnnow)
    if count == nil or count < 1 then 
        return;
    end

    local lvUpUpdateFlag = false

    local runCnt = 0;
    if 0 == abilPrice and learnnow == nil then 
        local maxCount = string.format("%d", RUN_ABIL_MAX_COUNT);

        for i = 0, maxCount do
            local prop = "None";
            if 0 == i then
                prop = "LearnAbilityID";
            else
                prop = "LearnAbilityID_" ..i;
            end

            if pc[prop] ~= nil and pc[prop] == abilityID then
                runCnt = i;
            end
        end

        if runCnt == 0 then
            if pc.LearnAbilityID == 0 or pc.LearnAbilityTime == "None"then
                return;
            end
        else
            if pc["LearnAbilityID_"..runCnt] == 0 or pc["LearnAbilityTime_"..runCnt]  == "None" then
                return;
            end
        end
    end

    local oriLevel = 0; 
    local abilLevel = count;
    local abilObj = GetAbilityIESObject(pc, abilName);  
    if abilObj ~= nil then
        oriLevel = abilObj.Level;
        abilLevel = oriLevel + count;
    end

    local jobHistory = GetJobHistoryString(pc)
    if jobHistory == nil then
        if pc ~= nil and g_logCount < 10 then
            g_logCount = g_logCount + 1;
            IMC_LOG('INFO_NORMAL', '[AbilityErrorLog] SCR_TX_PROPERTY_UP: cid['..GetPcCIDStr(pc)..']');
        end
        return;
    end
    
    if abilName == 'Pardoner5' then
        AddAchievePoint(pc, 'PardonerAbility', count);
    end
    
    if abilName == 'TaxPayment' then
        AddAchievePoint(pc, 'TaxAbility', count);
    end 

    local maxLevel = 0;
    local sList = StringSplit(jobHistory, ";");

    for i = 1, #sList do
        local jobCls = GetClass("Job", sList[i])

        if jobCls ~= nil then
            local abilGroupClass = GetClass("Ability_"..jobCls.EngName, abilName);
            if abilGroupClass ~= nil then
                maxLevel = abilGroupClass.MaxLevel
                break;
            end
        end
    end


    if maxLevel < abilLevel then
        return;
    end 

    -- 한번더 특성 포인트 가지고 있나 체크
    local curAbilityPoint = TryGetProp(pc, 'AbilityPoint');
    if curAbilityPoint == nil then
        return;
    end
    if curAbilityPoint == 'None' then
        curAbilityPoint = 0;
    end
    curAbilityPoint = tonumber(curAbilityPoint);
    local resultAbilityPoint = curAbilityPoint - abilPrice;
    if abilPrice < 0 or resultAbilityPoint < 0 then -- abilPrice가 음수면 무조건 안되지..;;
        return;
    end

    local tx = TxBegin(pc);

    if abilObj == nil then      
        local idx = TxAddAbility(tx, abilName);     
        TxAppendProperty(tx, idx, "Level", count);
        lvUpUpdateFlag = true;
        local ablCls = GetClass("Ability", abilName)
        if ablCls ~= nil then
            local txScpName = TryGetProp(ablCls, 'ScriptTX')
            if nil ~= txScpName and 'None' ~= ablCls.ScriptTX then
                local func = _G[ablCls.ScriptTX];
                if false == func(pc, tx, 1) then
                    TxRollBack(tx)
                    return;
                end
            end
        end
        
    else
        TxSetIESProp(tx, abilObj, "Level", abilLevel);
        lvUpUpdateFlag = true;
    end
    
    if learnnow ~= nil then
        if abilPrice > 0 then
            TxSetIESProp(tx, pc, 'AbilityPoint', resultAbilityPoint);
        end
    else
        local time = "LearnAbilityTime"
        local id = "LearnAbilityID"
        if 0 < runCnt then
            time = "LearnAbilityTime_"..runCnt;
            id  = "LearnAbilityID_"..runCnt;
        end

        TxSetIESProp(tx, pc, time, "None");
        TxSetIESProp(tx, pc, id, 0);
        
    end
        
    local ret = TxCommit(tx);
    
    if ret ~= 'SUCCESS' then
        return;
    end

    InvalidateStates(pc);
        
    local shopName = GetExProp_Str(pc, "ABILSHOP_OPEN");
    SendAddOnMsg(pc, "RESET_ABILITY_UP", shopName, 0);

    AbilityMongoLog(pc, abilName, abilPrice, "Learn", oriLevel, abilLevel, 0);
    AbilityPointMongoLog(pc, abilPrice, resultAbilityPoint, 0, 'Training');
    
    if lvUpUpdateFlag == false then
        return;
    end

    local AbilityProp = GetClass("Ability", abilName);
    if AbilityProp == nil then  
        return;
    end

    local skillList = AbilityProp.SkillCategory
    local sList = StringSplit(skillList, ";");
    for i = 1, #sList do
        local skillProp = GetClass("Skill", sList[i]);
        if skillProp ~= nil then
            UpdateSkillPropertyBySkillID(pc, skillProp.ClassID)
            UpdateSkillSpendItemBySkillID(pc, skillProp.ClassID)
        end
    end

    lvUpUpdateFlag = false;
end

function SCR_REQUEST_CANCEL_LEARNING_ABIL(pc, propIndex)
    
    local prop = 'None';
    local time = 'None';
    if 0 == propIndex then
        prop = "LearnAbilityID";
        time = "LearnAbilityTime"
    else
        prop = "LearnAbilityID_" ..propIndex;
        time = "LearnAbilityTime_"..propIndex;
    end

    local abilID = pc[prop];
    if pc[prop] ~= nil and abilID > 0 then

        local abilClass = GetClassByType('Ability', abilID);
        if abilClass == nil then
            return;
        end

        if pc[time] == "None" or pc[prop] == 0 then
            IMC_LOG("INFO_NORMAL", "wrong abil 66 "..GetPcCIDStr(pc).." "..pc[time]..pc[prop] )
        end

        local tx = TxBegin(pc);
        --IMC_LOG("INFO_NORMAL", "set abil 3"..GetPcCIDStr(pc).." ["..time.."] [".."None".."]".."["..prop.."] [".."0".."]" )
        TxSetIESProp(tx, pc, time, "None");
        TxSetIESProp(tx, pc, prop, 0);
        local ret = TxCommit(tx);

        InvalidateStates(pc);

        if ret == 'SUCCESS' then
            
            local shopName = GetExProp_Str(pc, "ABILSHOP_OPEN");
            SendAddOnMsg(pc, "RESET_ABILITY_UP", shopName, 0);
            SendSysMsg(pc, "CANCEL_LEARING_ABIL");
            AbilityMongoLog(pc, abilClass.ClassName, 0, "Cancel", 0, 0, 0);
        end
    end
end

-- 특성 초기화 포션
function SCR_ABILITY_POINT_RESET(pc, itemGuid, argList)    
    local item = GetInvItemByGuid(pc, itemGuid);
    if IS_ABILITY_POINT_RESET_ITEM(item) == false then
        return;
    end

    if IsFixedItem(item) == 1 or item.ItemLifeTimeOver == 1 then
        return;
    end

    if IsLearnAbilityState(pc) == 1 then
        SendSysMsg(pc, 'YouareLearningAbil');
        return;
    end

    local mapClsName = GetZoneName(pc);
    local mapCls = GetClass('Map', mapClsName);
    if TryGetProp(mapCls, 'MapType', 'None') ~= 'City' then
        SendSysMsg(pc, 'AllowedInTown');
        return;
    end

    if IsBattleState(pc) == 1 then
        SendSysMsg(pc, 'CanNotBattleState');
        return;
    end

    if IsAutoSellerState(pc) == 1 then
        SendSysMsg(pc, 'StateOpenAutoSeller');
        return;
    end

    if GetVehicleState(pc) == 1 then
        SendSysMsg(pc, 'Orgel_MSG3');
        return;
    end

    if IsTimeActionState(pc) == 1 then
        SendSysMsg(pc, 'CannotInCurrentState');
        return;
    end

    if IsItemEquipState(pc) == 1 then
        SendSysMsg(pc, 'CannotEquipState');
        return;
    end

    if GetTotalAbilityPoint(pc) < 1 then
        SendSysMsg(pc, 'NotExistRefundAbilityPoint');
        return;
    end

    if IsRunningScript(pc, 'TX_RESET_ABILITY_POINT') ~= 1 then
        TX_RESET_ABILITY_POINT(pc, item);
    end
end

function IS_ABILITY_POINT_RESET_ITEM(item)
    if item == nil then
        return false;
    end 

    if item.StringArg ~= 'AbilityPointReset' then
        return false;
    end

    return true;
end

function GET_DEFAULT_HAVE_ABILITY_LIST(pc)
    local abilList = {};
    local jobHistoryStr = GetJobHistoryString(pc);
    local jobList = StringSplit(jobHistoryStr, ';');
    for j = 1, #jobList do
        local jobObj = GetClass("Job", jobList[j]);
        local defaultAbilList = StringSplit(jobObj.DefHaveAbil, '#');
        for k = 1 , #defaultAbilList do
            local abilName = defaultAbilList[k];
            if abilName ~= 'None' then
                if abilList[abilName] == nil then
                    abilList[abilName] = true;
                end
            end
        end
    end
    return abilList;
end

function TX_RESET_ABILITY_POINT(pc, item)
    local abilList = GetAbilityNames(pc);
    if #abilList == 0 then        
        return;
    end

    local defHaveAbilMap = GET_DEFAULT_HAVE_ABILITY_LIST(pc);

    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end

    TxTakeItemByObject(tx, item, 1, 'AbilityPointReset');
    
    for i = 1, #abilList do
        local abilName = abilList[i];
        if defHaveAbilMap[abilName] == nil then
            TxRemoveAbility(tx, abilName);
            TX_RESET_ABILITY_PROPERTY(tx, pc, abilName); -- 특성 관련된 프로퍼티도 초기화 해야 하는 경우
        end
    end

    TxRefundAbilityPoint(tx);

    local ret = TxCommit(tx);
    if ret ~= 'SUCCESS' then
        IMC_LOG('ERROR_TX_FAIL', 'TX_RESET_ABILITY_POINT: cid['..GetPcCIDStr(pc)..'], item['..item.ClassName..']');
        return;
    end

    InvalidateStates(pc);
    local shopName = GetExProp_Str(pc, "ABILSHOP_OPEN");
    SendAddOnMsg(pc, "RESET_ABILITY_UP", shopName);
    AbilityPointRefundLog(pc, 'AbilityPointReset');
end

function TX_RESET_ABILITY_PROPERTY(tx, pc, abilName)
    if abilName == 'Sage1' then
        TX_RESET_ABILITY_PROPERTY_SAGE(tx, pc);
    end
end

function TX_RESET_ABILITY_PROPERTY_SAGE(tx, pc)    
    local abil = GetAbility(pc, 'Sage1');
    if abil == nil then
        return;
    end
    local etc = GetETCObject(pc);
    local baseCnt = SAGE_PORTAL_BASE_CNT;
    local addCnt = abil.Level;
    for i = 1, addCnt do
        local propName = string.format('Sage_Portal_%d', i + baseCnt);
        if etc[propName] ~= 'None' then
            TxSetIESProp(tx, etc, propName, 'None');
        end
    end
end