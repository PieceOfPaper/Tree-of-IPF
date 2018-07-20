-- item_buff_server.lua

-->>> 판매스킬 공통
function SET_ENDABLE_CONTROL(self, type, sklType)
    SCR_SELLER_BUYER_CENCLE(self, sklType, nil);
    EnableControl(self, type, "AUTOSELLER");
end

function SCR_SELLER_IS_DOING(target)
    SendSysMsg(target, "IsDoingAction");
end

function SET_SELLER_FLAG(self, target, flag)
    if nil ~= self then
        SetExProp(self, "SELLER_SKILL_FLAG", flag);
    end
    
    if nil ~= target then
        SetExProp(target, "SELLER_SKILL_FLAG", flag);
    end
end

function SCR_SELLER_BUYER_CENCLE(target, skillID, seller)
    if GetHandle(seller) ~= GetHandle(target) then
        EnableControl(target, 1, "AUTOSELLER");
    end

    local skill = GetClassByType("Skill", skillID);
    if nil == skill then
        return;
    end

    if 'Squire_Repair' == skill.ClassName then --리페어 스킬 창 닫기
        ExecClientScp(target, "SQIORE_REPAIR_CENCEL()");
    elseif 'Squire_EquipmentTouchUp' == skill.ClassName or 'Alchemist_Roasting' == skill.ClassName then
        if nil ~= seller and GetExProp(target, "SELLER_SKILL_FLAG") == 1 then
            local scp = string.format("SQUIRE_TARGET_BUFF_CENCEL(%d)", GetHandle(seller));
            ExecClientScp(target, scp);
            AttachGaugeToTarget(seller, target, 0, 0);
            EquipDummyItemSpot(seller, target, 0, "LH", 1);

        else
            if 'Alchemist_Roasting' == skill.ClassName then
                ExecClientScp(target, "GEMROASTING_TARGET_UI_CENCEL()");
            else
                ExecClientScp(target, "SQIORE_TARGET_UI_CLOSE()");
            end
        end
    elseif 'Enchanter_EnchantArmor' == skill.ClassName then
        local scp = 'ENCHANTAROMOROPEN_UI_CLOSE()';
        if nil ~= seller and GetExProp(target, "SELLER_SKILL_FLAG") == 1 then
            scp = 'ENCHANTAROMOROPEN_TARGET_BUFF_CENCEL()'
        end

        ExecClientScp(target, scp);     
    elseif skill.ClassName == 'Appraiser_Apprise' then
        ExecClientScp(target, "APPRAISAL_PC_UI_CLOSE()");
    elseif skill.ClassName == 'Sage_PortalShop' then
        ExecClientScp(target, "PORTAL_SELLER_UI_CLOSE()");
    else
        ExecClientScp(target, "SQIORE_BUFF_CENCEL()");
    end

end
--<<< 공통 함수 끝

-->>> 스콰이어 리페어 
function SCR_ITEM_REPAIR(seller, target,  itemList, price, skill)
    local itemCount = #itemList;
    local needItem = "";
    local needCnt=0 ;
    local sklObj = skill;
    local priceList = {};

    for i = 1, #itemList do
        needItem, cnt = ITEMBUFF_NEEDITEM_Squire_Repair(seller, itemList[i]);
        needCnt = needCnt + cnt;
        priceList[i] = price * cnt;
    end
    
    local myNeedItem, materialCount = GetInvItemByName(seller, needItem);
    if IsFixedItem(myNeedItem) == 1 then
        return;
    end

    if materialCount < needCnt then
        SendSysMsg(target, "NotEnoughRecipe");
        return
    end

    local sellerhandle = GetHandle(seller);
    local targethandle = GetHandle(target);
    local totalPrice = price * needCnt;

    local pcMoney, cnt  = GetInvItemByName(target, MONEY_NAME);
    if sellerhandle ~= targethandle then
        if pcMoney == nil or cnt < totalPrice then
            SendSysMsg(target, "NotEnoughMoney");
            return;
        end
    end
        
    if IsFixedItem(pcMoney) == 1 then
        return;
    end
    
    SET_SELLER_FLAG(seller, target, 1);
    
    -- 혼자일때
    local tx = nil;
    -- 상대방이 왔을 때
    local tx1, tx2 = nil;
    
    local historyStr = "";

    if sellerhandle == targethandle then    
        tx = TxBegin(seller);
    else
        EnableControl(target, 0, "AUTOSELLER");
        tx1, tx2 = TxBeginDouble(seller, target);
        historyStr = string.format("%s#", GetTeamName(target));
    end
    
    if sellerhandle == targethandle then 
        if nil == tx then
            SET_SELLER_FLAG(seller, target, 0);
            return;
        end
    else
        if nil == tx1 or nil == tx2 then
            EnableControl(target, 1, "AUTOSELLER");
            SET_SELLER_FLAG(seller, target, 0);
            return;
        end
    end
    
    local itemCnt = #itemList;
    for i = 1, #itemList do
        local repairItem = itemList[i];
        if nil == repairItem then
            return;
        end
        
        local value = ITEMBUFF_VALUE_Squire_Repair(seller, repairItem, sklObj);
        
        if sellerhandle == targethandle then
            RepairMongoLog(target, repairItem, 0, repairItem.Dur, value, 'Squire', seller, i);
            
            if repairItem.Dur ~= value then
                TxSetIESProp(tx, repairItem, 'Dur', value)
            end
        else
            local needItemType = GetClass("Item", needItem).ClassID;
            local cloneItem = CloneIES(repairItem);
            cloneItem.Dur = value;
            
            local refreshScp = cloneItem.RefreshScp;
            if refreshScp ~= "None" then
                refreshScp = _G[refreshScp];
                refreshScp(cloneItem);
            end
            DestroyIES(cloneItem);
            RepairMongoLog(target, repairItem, priceList[i], repairItem.Dur, value, 'Squire', seller, i);
            if repairItem.Dur ~= value then
                TxSetIESProp(tx2, repairItem, 'Dur', value);
            end
            local itemName  = string.format("%d#%d#", repairItem.ClassID, priceList[i]);
            historyStr = historyStr .. itemName;
        end
    end
    
    if sellerhandle == targethandle then    
        TxTakeItem(tx, needItem, needCnt, sklObj.ClassName);
        local ret = TxCommit(tx);
        
        SET_SELLER_FLAG(seller, target, 0);
        if ret == "SUCCESS" then
            for i = 1, #itemList do
                RunUpdateItemBuffCheck(seller, itemList[i]);
            end
            ExecClientScp(seller, "SQUIRE_ITEM_REPAIR_SUCCEED()");
            InvalidateStates(seller);
            SaveRepaireMongoLog(target, itemCnt, 1);
        else
            SaveRepaireMongoLog(target, itemCnt, 0);
        end
    else
        TxTakeItem(tx1, needItem, needCnt, sklObj.ClassName);
        local giveMoney = math.floor(totalPrice * tonumber(AUTOSELLER_SILVER_FEE) / 100); -- AUTOSELLER_SILVER_FEE를 소수점으로 해두니까 정확하지가 않다.
        if giveMoney > 0 then
            TxGiveItem(tx1, MONEY_NAME, giveMoney, sklObj.ClassName);
        end
        TxTakeItem(tx2, MONEY_NAME, totalPrice, sklObj.ClassName);

        local ret = TxCommit(tx1);
        
        EnableControl(target, 1, "AUTOSELLER");
        SET_SELLER_FLAG(seller, target, 0);
        if ret == "SUCCESS" then            
            for i = 1, #itemList do
                RunUpdateItemBuffCheck(target, itemList[i]);
            end
            ExecClientScp(seller, "SQUIRE_ITEM_REPAIR_SUCCEED()");
            ExecClientScp(target, "SQUIRE_ITEM_REPAIR_SUCCEED()");
            InvalidateStates(target);
            SendSysMsg(target, "ItemRepairFinished");           
            AddAutoSellHistory(seller, AUTO_SELL_SQUIRE_BUFF, needItemType, needCnt, totalPrice, historyStr);   
            SaveRepaireMongoLog(target, itemCnt, 1);

            if IsExistAutoSellerInAdevntureBook(seller, sklObj.ClassID) == 'NO' then
                ALARM_ADVENTURE_BOOK_NEW(seller, sklObj.Name);
            end
            AddAdventureBookAutoSellerInfo(seller, sklObj.ClassID, giveMoney)
        else
            SaveRepaireMongoLog(target, itemCnt, 0);
        end
    end
end
--<<<스콰이어 리페어 함수 끝

-->>> 스콰이어 장비,무기 손질 
function SCR_SQUIRE_STORE_CLOSE(self)
    local result = GetTimeActionResult(self, 1);

    StopRunScript(self, "SCR_TX_ITEMBUFF");
    StopRunScript(self, "SCR_GEM_ROASTING"); 
    SET_SELLER_FLAG(nil, self, 0);
end

function SCR_ITEM_BUFF(seller, target, slotItem, skillType, price)
    if IsRunningScript(target, 'SCR_TX_ITEMBUFF') ~= 1 then
        RunScript("SCR_TX_ITEMBUFF", seller, target, slotItem, skillType, price);
    end
end

function SCR_TX_ITEMBUFF(seller, target, slotItem, skillType, price)    
    if GetExProp(target, "SELLER_SKILL_FLAG") == 1 then
        SendSysMsg(target, "ItIsAlreadyInProcess");
        return;
    end

    if slotItem.Dur <= 0 then
        SendSysMsg(target, "DurUnder0");
        return;
    end

    local sklCls = GetClassByType("Skill", skillType);
    if sklCls == nil then
        return;
    end

    local skillName = sklCls.ClassName;

    local skl = GetSkill(seller, skillName);
    if skl == nil then
        return;
    end

    local checkFunc = _G["ITEMBUFF_CHECK_" .. skillName];    
    if 0 == checkFunc(seller, slotItem) then
        return;
    end

    local needFunc = _G["ITEMBUFF_NEEDITEM_" .. skillName];
    local needItem, needCnt  = needFunc(seller, slotItem);
    local myNeedItem, materialCount = GetInvItemByName(seller, needItem);
    if IsFixedItem(myNeedItem) == 1 then
        return;
    end

    local needObj = CloneIES(myNeedItem);
    if materialCount < needCnt then
        SendSysMsg(target, "NotEnoughRecipe");
        return
    end

    local sellerhandle = GetHandle(seller);
    local targethandle = GetHandle(target);

    local totalPrice = needCnt * price;
    local pcMoney, cnt  = GetInvItemByName(target, MONEY_NAME);
    if sellerhandle ~= targethandle then
        if pcMoney == nil or cnt < totalPrice then
            SendSysMsg(target, "NotEnoughMoney");
            return;
        end
    end
        
    if IsFixedItem(pcMoney) == 1 then
        return;
    end

    -- 모든 예외가 끝나면 판매자 자가 액션 중이라는 플레그를 남김
    if sellerhandle ~= targethandle then
        EnableControl(target, 0, "AUTOSELLER");
    end

    SET_SELLER_FLAG(nil, target, 1);

    local valueFunc = _G["ITEMBUFF_VALUE_" .. skillName];
    local value, sec, count = valueFunc(seller, slotItem, skl.LevelByDB);    
    local touchUpDuration = 5;
    if sellerhandle ~= targethandle then
        AttachGaugeToTarget(seller, target, touchUpDuration, 0, "gauge");
    else
        AttachGaugeToTarget(seller, target, touchUpDuration, 1, "gauge");
    end

    EquipDummyItemSpot(seller, target, slotItem.ClassID, "LH", 1);        
    local result = DOTIMEACTION_ONLY_TARGET(seller, target, ScpArgMsg("GivingBuffToWeapon"), '#Squire_ArmorTouchUp', touchUpDuration, skillType)
    EquipDummyItemSpot(seller, target, 0, "LH", 1);
    AttachGaugeToTarget(seller, target, 0, 0);

    if 1 ~= result then
        EnableControl(target, 1, "AUTOSELLER");
        SET_SELLER_FLAG(nil, target, 0);
        return;
    end

    local sysTime = GetDBTime();
    sysTime = imcTime.AddSec(sysTime, sec); 
    local strValue = imcTime.GetStringSysTime(sysTime);

    local needItemType = GetClass("Item", needItem).ClassID;
    local cloneItem = CloneIES(slotItem);
    cloneItem.BuffValue = value;
    local refreshScp = cloneItem.RefreshScp;
    if refreshScp ~= "None" then
        refreshScp = _G[refreshScp];
        refreshScp(cloneItem);
    end             

    local refreshScp = slotItem.RefreshScp;
    if refreshScp ~= "None" then
        refreshScp = _G[refreshScp];
        refreshScp(slotItem);
    end 

    local basicTooltipPropList = StringSplit(slotItem.BasicTooltipProp, ';');
    local propertyHistory = "";
    for i = 1, #basicTooltipPropList do
        local basicTooltipProp = basicTooltipPropList[i];
        local prop1, prop2 = GET_ITEM_PROPERT_STR(slotItem, basicTooltipProp);

        if slotItem.GroupName == "Weapon" then
            if basicTooltipProp == "ATK" then -- 최대, 최소 공격력
                propDifString =  string.format("%s@%s@%s@", 'MAXATK', slotItem.MAXATK, cloneItem.MAXATK); 
                propDifString =  propDifString .. string.format("%s@%s@%s@", 'MINATK', slotItem.MINATK, cloneItem.MINATK); 
            elseif basicTooltipProp == "MATK" then -- 마법공격력
                propDifString =  string.format("%s@%s@%s@", basicTooltipProp, slotItem.MATK, cloneItem.MATK); 
            end
        elseif slotItem.GroupName == "SubWeapon" then
            if basicTooltipProp == "ATK" then -- 최대, 최소 공격력
                propDifString =  string.format("%s@%s@%s@", 'MAXATK', slotItem.MAXATK, cloneItem.MAXATK); 
                propDifString =  propDifString .. string.format("%s@%s@%s@", 'MINATK', slotItem.MINATK, cloneItem.MINATK); 
            elseif basicTooltipProp == "MATK" then -- 마법공격력
                propDifString =  string.format("%s@%s@%s@", basicTooltipProp, slotItem.MATK, cloneItem.MATK); 
            end
        else
            if basicTooltipProp == "DEF" then -- 방어
                propDifString =  string.format("%s@%s@%s@", basicTooltipProp, slotItem.DEF, cloneItem.DEF); 
            elseif basicTooltipProp == "MDEF" then -- 악세사리
                propDifString =  string.format("%s@%s@%s@", basicTooltipProp, slotItem.MDEF, cloneItem.MDEF); 
            elseif  basicTooltipProp == "HR" then -- 명중
                propDifString =  string.format("%s@%s@%s@", basicTooltipProp, slotItem.HR, cloneItem.HR); 
            elseif  basicTooltipProp == "DR" then -- 회피
                propDifString =  string.format("%s@%s@%s@", basicTooltipProp, slotItem.DR, cloneItem.DR); 
            elseif  basicTooltipProp == "MHR" then -- 마법관통
                propDifString =  string.format("%s@%s@%s@", basicTooltipProp, slotItem.MHR, cloneItem.MHR);  
            elseif  basicTooltipProp == "ADD_FIRE" then -- 화염
                propDifString =  string.format("%s@%s@%s@", basicTooltipProp, slotItem.FIRE, cloneItem.FIRE);
            elseif  basicTooltipProp == "ADD_ICE" then -- 빙한
                propDifString =  string.format("%s@%s@%s@", basicTooltipProp, slotItem.ICE, cloneItem.ICE);
            elseif  basicTooltipProp == "ADD_LIGHTNING" then -- 전격
                propDifString =  string.format("%s@%s@%s@", basicTooltipProp, slotItem.LIGHTNING, cloneItem.LIGHTNING);
            end
        end
        propertyHistory = propertyHistory..propDifString;
    end
    DestroyIES(cloneItem);

    if sellerhandle == targethandle then
        local tx = TxBegin(seller);
        TxTakeItem(tx, needItem, needCnt, sklCls.ClassName);
        if value ~= slotItem.BuffValue then
            TxSetIESProp(tx, slotItem, "BuffValue", value);
        end

        if slotItem.BuffCount ~= count then
        TxSetIESProp(tx, slotItem, "BuffCount", count);
        end
        if slotItem.BuffUseCount ~= count then
        TxSetIESProp(tx, slotItem, "BuffUseCount", count);
        end

        TxSetIESProp(tx, slotItem, "BuffEndTime", strValue);
        if slotItem.BuffCaster ~= GetTeamName(seller) then
        TxSetIESProp(tx, slotItem, "BuffCaster", GetTeamName(seller));
        end

        if slotItem.BuffSkillType ~= sklCls.ClassID then
            TxSetIESProp(tx, slotItem, "BuffSkillType", sklCls.ClassID);
        end
        local ret = TxCommit(tx);
        
        SET_SELLER_FLAG(nil, target, 0);

        if ret == "SUCCESS" then
            RunUpdateItemBuffCheck(seller, slotItem);
            ExecClientScp(seller, "SQUIRE_ITEM_SUCCEED()");
            local historyStr = string.format("%s#%d#", GetTeamName(target), slotItem.ClassID);
            historyStr = historyStr .. propertyHistory;

            ItemBuffMongoLog(seller, target, "Squire", skl, slotItem, historyStr, needObj, needCnt, totalPrice);
        end
    else
        local tx1, tx2 = TxBeginDouble(seller, target);
        TxTakeItem(tx1, needItem, needCnt, skillName);

        if value ~= slotItem.BuffValue then
        TxSetIESProp(tx2, slotItem, "BuffValue", value);
        end

        if slotItem.BuffCount ~= count then
        TxSetIESProp(tx2, slotItem, "BuffCount", count);
        end
        if slotItem.BuffUseCount ~= count then
        TxSetIESProp(tx2, slotItem, "BuffUseCount", count);
        end

        TxSetIESProp(tx2, slotItem, "BuffEndTime", strValue);

        if slotItem.BuffCaster ~= GetTeamName(seller) then
        TxSetIESProp(tx2, slotItem, "BuffCaster", GetTeamName(seller));
        end

        if slotItem.BuffSkillType ~= sklCls.ClassID then
            TxSetIESProp(tx2, slotItem, "BuffSkillType", sklCls.ClassID);
        end

        local giveMoney = math.floor(totalPrice * tonumber(AUTOSELLER_SILVER_FEE) / 100);
        if giveMoney > 0 then
            TxGiveItem(tx1, MONEY_NAME, giveMoney, skillName);
        end
        
        TxTakeItem(tx2, MONEY_NAME, totalPrice, skillName);

        local ret = TxCommit(tx1);
        
        EnableControl(target, 1, "AUTOSELLER");
        SET_SELLER_FLAG(nil, target, 0);
        if ret == "SUCCESS" then            
            RunUpdateItemBuffCheck(target, slotItem);
            ExecClientScp(target, "SQUIRE_ITEM_SUCCEED()");
            ExecClientScp(seller, "SQUIRE_ITEM_SUCCEED()");
            SendSysMsg(target, "ItemMendingFinished");          
            InvalidateStates(target);
            local historyStr = string.format("%s#%d#", GetTeamName(target), slotItem.ClassID);
            historyStr = historyStr .. propertyHistory;
            AddAutoSellHistory(seller, AUTO_SELL_SQUIRE_BUFF, needItemType, needCnt, totalPrice, historyStr);
            ItemBuffMongoLog(seller, target, "Squire", skl, slotItem, historyStr, needObj, needCnt, totalPrice);

            if IsExistAutoSellerInAdevntureBook(seller, sklCls.ClassID) == 'NO' then
                ALARM_ADVENTURE_BOOK_NEW(seller, sklCls.Name);
            end
            AddAdventureBookAutoSellerInfo(seller, sklCls.ClassID, giveMoney);
        end
    end

    DestroyIES(needObj);
    StopScript();
end
--<<<스콰이어 장비,무기 손질 

-- 알케미스트 젬 로스팅
function SCR_GEM_ROASTING(seller, target, skillType, skl, targetItem, price)

    if nil == targetItem then
        return;
    end

    local beforLv = targetItem.GemRoastingLv;
    if skl.LevelByDB <= beforLv then
        return;
    end

    local needItem, needCnt = ITEMBUFF_NEEDITEM_Alchemist_Roasting(seller, targetItem); 
    local myNeedItem, materialCount = GetInvItemByName(seller, needItem);
    if IsFixedItem(myNeedItem) == 1 then
        return;
    end

    local needObj = CloneIES(myNeedItem);

    if materialCount < needCnt then
        SendSysMsg(target, "NotEnoughRecipe");          
        return
    end

    local sellerhandle = GetHandle(seller);
    local targethandle = GetHandle(target);
    local totalPrice = price * needCnt;

    local pcMoney, cnt  = GetInvItemByName(target, MONEY_NAME);
    if sellerhandle ~= targethandle then
        if pcMoney == nil or cnt < totalPrice then
            SendSysMsg(target, "NotEnoughMoney");
            return;
        end
    end
        
    if IsFixedItem(pcMoney) == 1 then
        return;
    end


    -- 몬스터 젬인지 체크.
    local gemProp = geItemTable.GetProp(targetItem.ClassID);
    local socketPenaltyProp = gemProp:GetSocketPropertyByLevel(0);
    local propPenaltyAdd = socketPenaltyProp:GetPropPenaltyAddByIndex(0, 0);
    if nil == propPenaltyAdd then
        return;
    end

    if sellerhandle ~= targethandle then
        EnableControl(target, 0, "AUTOSELLER");
    end

    SET_SELLER_FLAG(nil, target, 1);

    if sellerhandle ~= targethandle then
        AttachGaugeToTarget(seller, target, 30, 0, "gauge");
    else
        AttachGaugeToTarget(seller, target, 30, 1, "gauge");
    end

    local result = DOTIMEACTION_ONLY_TARGET(seller, target, ScpArgMsg("ProcessingGemRoasting"), '#Alchemist_Roasting', 30, skillType)
    
    AttachGaugeToTarget(seller, target, 0, 0);

    if 1 ~= result then
        EnableControl(target, 1, "AUTOSELLER");
        SET_SELLER_FLAG(nil, target, 0);
        return;
    end

    -- 혼자일때
    local tx = nil;
    -- 상대방이 왔을 때
    local tx1, tx2 = nil;
    
    local historyStr = string.format("%s#%d#", GetTeamName(target), targetItem.ClassID);

    if sellerhandle == targethandle then    
        tx = TxBegin(seller);
    else
        tx1, tx2 = TxBeginDouble(seller, target);
    end
    
    if sellerhandle == targethandle then 
        if nil == tx then
            return;
        end
    else
        if nil == tx1 or nil == tx2 then
            return;
        end
    end

    historyStr = historyStr .. string.format("%s@%d@%d@", targetItem.GroupName, targetItem.GemRoastingLv, skl.LevelByDB);

    if sellerhandle == targethandle then
        TxSetIESProp(tx, targetItem, 'GemRoastingLv', skl.LevelByDB)
    else
        TxSetIESProp(tx2, targetItem, 'GemRoastingLv', skl.LevelByDB);
    end
    
    if sellerhandle == targethandle then    
        TxTakeItem(tx, needItem, needCnt, skl.ClassName);
        local ret = TxCommit(tx);
        
        SET_SELLER_FLAG(nil, target, 0);

        if ret == "SUCCESS" then
            ExecClientScp(seller, "GEMROASTING_SUCCEED()");
            InvalidateStates(seller);
            ItemBuffMongoLog(seller, target, "Alchemist", skl, targetItem, historyStr, needObj, needCnt, totalPrice);
        end
    else

        TxTakeItem(tx1, needItem, needCnt, skl.ClassName);
        local giveMoney = math.floor(totalPrice * tonumber(AUTOSELLER_SILVER_FEE) / 100);
        if giveMoney > 0 then
            TxGiveItem(tx1, MONEY_NAME, giveMoney, skl.ClassName);       
        end

        TxTakeItem(tx2, MONEY_NAME, totalPrice, skl.ClassName);

        local ret = TxCommit(tx1);
        
        EnableControl(target, 1, "AUTOSELLER");

        SET_SELLER_FLAG(nil, target, 0);

        if ret == "SUCCESS" then
            ExecClientScp(target, "GEMROASTING_SUCCEED()");
            ExecClientScp(seller, "GEMROASTING_SUCCEED()");
            InvalidateStates(target);
            SendSysMsg(target, "ItemMendingFinished");          
            AddAutoSellHistory(seller, AUTO_SELL_GEM_ROASTING, needItemType, needCnt, totalPrice, historyStr);
            ItemBuffMongoLog(seller, target, "Alchemist", skl, targetItem, historyStr, needObj, needCnt, totalPrice);

            if IsExistAutoSellerInAdevntureBook(seller, skl.ClassID) == 'NO' then
                ALARM_ADVENTURE_BOOK_NEW(seller, skl.Name);
            end
            AddAdventureBookAutoSellerInfo(seller, skl.ClassID, giveMoney);
        end
    end
    DestroyIES(needObj);
    StopScript();
end

function SCR_ENCHATN_ARMOR(seller, target, slotItem, skillType, price, selectName)
    local pcMoney, cnt  = GetInvItemByName(target, MONEY_NAME);
    local sellerhandle = GetHandle(seller);
    local targethandle = GetHandle(target);
    if sellerhandle ~= targethandle then
        if pcMoney == nil or cnt < price then
            SendSysMsg(target, "NotEnoughMoney");
            return;
        end
    end
        
    if IsFixedItem(pcMoney) == 1 then
        return;
    end
    
    local sklCls = GetClassByType("Skill", skillType);
    if sklCls == nil then
        return;
    end

    local skillName = sklCls.ClassName;
    local skl = GetSkill(seller, skillName);
    if skl == nil then
        return;
    end

    if 'None' ~= selectName then
        local optionList = GET_ENCHANTARMOR_OPTION(skl.Level);
        local hasList = false;
        for i = 1, #optionList do 
            if selectName == optionList[i] then
                hasList= true;
                break;
            end
        end

        if false == hasList then 
            SendSysMsg(target, "NeedMoreSkillLevel");
            return;
        end
    end

    if IsRunningScript(target, 'SCR_TX_ENCHANT_ARMOR') == 1 then
        return;
    end

    RunScript("SCR_TX_ENCHANT_ARMOR", seller, target, slotItem, skl, price, selectName);
end

function SCR_TX_ENCHANT_ARMOR(seller, target, slotItem, skl, price, selectName)
    local needFunc = _G["ITEMBUFF_NEEDITEM_" .. skl.ClassName];
    local needItem, needCnt  = needFunc(seller, slotItem);
    local matObj, matCnt= GetInvItemByName(seller, needItem);
    local needItemType = 0;
    local cls = GetClass("Item", needItem);
    if nil ~= cls then
        needItemType = cls.ClassID
    end

    if nil == matObj or matCnt < needCnt then
        SendSysMsg(target, "NotEnoughRecipe");
        return
    end

    if IsFixedItem(matObj) == 1 then
        return;
    end
    
    local sellerhandle = GetHandle(seller);
    local targethandle = GetHandle(target);

    if sellerhandle ~= targethandle then
        EnableControl(target, 0, "AUTOSELLER");
    end
    SET_SELLER_FLAG(nil, target, 1);

    if sellerhandle ~= targethandle then
        AttachGaugeToTarget(seller, target, 30, 0, "gauge");
    else
        AttachGaugeToTarget(seller, target, 30, 1, "gauge");
    end
    
    local result = DOTIMEACTION_ONLY_TARGET(seller, target, ScpArgMsg("ProcessingGemRoasting"), '#Enchanter_EnchantArmor', 30, skl.ClassID)
    AttachGaugeToTarget(seller, target, 0, 0);
    if  1 ~= result then
        EnableControl(target, 1, "AUTOSELLER");
        SET_SELLER_FLAG(nil, target, 0);
        return;
    end
    
    local needObj = CloneIES(matObj);
    local sysTime = GetDBTime();
    sysTime = imcTime.AddSec(sysTime, 86400);   
    local strValue = imcTime.GetStringSysTime(sysTime);

    local ret= "";
    local giveMoney = 0;
    if sellerhandle == targethandle then
        local tx = TxBegin(seller);
        TxTakeItem(tx, needItem, needCnt, skl.ClassName);
        if selectName ~= slotItem.EnchanterBuffValue then
            TxSetIESProp(tx, slotItem, "EnchanterBuffValue", selectName);
        end
        if strValue ~= slotItem.EnchanterBuffEndTime then
            TxSetIESProp(tx, slotItem, "EnchanterBuffEndTime", strValue);
        end
        ret = TxCommit(tx);
    
    else
        local tx1, tx2 = TxBeginDouble(target, seller);
        TxTakeItem(tx2, needItem, needCnt, skl.ClassName);

        TxTakeItem(tx1, MONEY_NAME, price, skl.ClassName);
    
        giveMoney = math.floor(price * tonumber(AUTOSELLER_SILVER_FEE) / 100);
        if giveMoney > 0 then
            TxGiveItem(tx2, MONEY_NAME, giveMoney, skl.ClassName);
        end

        if selectName ~= slotItem.EnchanterBuffValue then
            TxSetIESProp(tx1, slotItem, "EnchanterBuffValue", selectName);
        end
        if strValue ~= slotItem.EnchanterBuffEndTime then
            TxSetIESProp(tx1, slotItem, "EnchanterBuffEndTime", strValue);
        end
        
        ret = TxCommit(tx1);
    end
    
    SET_SELLER_FLAG(nil, target, 0);
    if sellerhandle ~= targethandle then
        EnableControl(target, 1, "AUTOSELLER");
    end
    
    if ret ~= "SUCCESS" then
        return;
    end
    
    local propDifString = selectName .. "@" .. strValue;
    RunUpdateItemBuffCheck(target, slotItem);
    local historyStr = string.format("%s#%d#%s", GetTeamName(target), slotItem.ClassID, propDifString);
    
    if sellerhandle ~= targethandle then
        SendSysMsg(target, "ItemMendingFinished");
        AddAutoSellHistory(seller, AUTO_SELL_ENCHANTERARMOR, needItemType, needCnt, price, historyStr);        

        if IsExistAutoSellerInAdevntureBook(seller, skl.ClassID) == 'NO' then
            ALARM_ADVENTURE_BOOK_NEW(seller, skl.Name);
        end
        AddAdventureBookAutoSellerInfo(seller, skl.ClassID, giveMoney);
    end
    ItemBuffMongoLog(seller, target, skl.ClassName, skl, slotItem, historyStr, needObj, needCnt, price);
    
    DestroyIES(needObj);
    StopScript();
end