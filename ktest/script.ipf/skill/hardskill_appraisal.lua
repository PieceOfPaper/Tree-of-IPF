---- hardskill_appraisal.lua

function SCR_BUFF_ENTER_Blindside_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    local skl = GetSkill(caster, 'Appraiser_Blindside');
    if skl == nil then
        return 0;
    end 
    ShowEmoticon(self, 'I_emo_Blindside', 0); --약점 공격 당했을때 이모티콘 나올 부분
    SetBuffArgs(buff, skl.Level, 0, 0)
--  self.CRTDR_BM = self.CRTDR_BM - skl.Level * 50;
    InvalidateStates(self);
end

function SCR_BUFF_LEAVE_Blindside_Debuff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    local skl = GetSkill(caster, 'Appraiser_Blindside');
    if skl == nil then
        return 0;
    end
    
    HideEmoticon(self, 'I_emo_Blindside'); 
--  self.CRTDR_BM = self.CRTDR_BM + skl.Level * 50;
    InvalidateStates(self);
end

function SCR_BUFF_RATETABLE_Blindside_Debuff(self, from, skill, atk, ret, rateTable, buff)
    if IsBuffApplied(self, 'Blindside_Debuff') == 'YES' then 
        if skill.ClassType == 'Magic' or skill.ClassType == 'TrueDamage' or skill.ClassType == 'AbsoluteDamage' then
            return 0;
        end
        
        if ret.Damage >= 1 then
            local abil = GetAbility(from, 'Appraiser3')
            if abil ~= nil and abil.ActiveState == 1 then
                rateTable.AddCrtAtkRate = rateTable.AddCrtAtkRate + (abil.Level * 0.05)
            end
            local maxRatio = IMCRandom(1, 100);
            local SkillLv = GetBuffArgs(buff)
            local ratio = SkillLv * 5;
            if ratio >= maxRatio then
--                rateTable.AddCrtAtk = rateTable.AddCrtAtk + 500;
--                rateTable.AddCrtAtkRate = rateTable.AddCrtAtkRate + 1.0;
--                rateTable.AddCrtDamageRate = rateTable.AddCrtDamageRate + 1.0
                SetExProp(self, "IS_TAKE_CRITICAL", 1)
            end
        end
    end
end 

function SCR_BUFF_ENTER_OverEstimate_Buff(self, buff, arg1, arg2, over)
    local caster = GetBuffCaster(buff);
    local skl = GetSkill(caster, 'Appraiser_Overestimate');
    if skl == nil then
        return 0;
    end
    self.BonusReinforce = skl.Level;
    local subWeapon = GetEquipItem(self, 'LH');
    if TryGetProp(subWeapon, 'EquipGroup') == 'SubWeapon' then
        REFRESH_ITEM(self, subWeapon);
        InvalidateStates(self);
    end
end

function SCR_BUFF_LEAVE_OverEstimate_Buff(self, buff, arg1, arg2, over)
    local subWeapon = GetEquipItem(self, 'LH');
    self.BonusReinforce = 0;
    if TryGetProp(subWeapon, 'EquipGroup') == 'SubWeapon' then
        REFRESH_ITEM(self, subWeapon);
    end
    InvalidateStates(self);
end

function SCR_BUFF_ENTER_Devaluation_Debuff(self, buff, arg1, arg2, over)
    if GetObjType(self) == OT_PC then
        self.IgnoreReinforce = 1;
        REFRESH_ALL_EQUIPED_ITEM(self);
        InvalidateStates(self);
    else
        local caster = GetBuffCaster(buff)
        if caster ~= nil then
            local skl = GetSkill(caster, 'Appraiser_Devaluation')
            if skl ~= nil then
                local ratio = skl.Level * 0.03
                if self.MonRank == 'Boss' then
                    ratio = ratio / 2
                end
                local patk = ratio
                local matk = ratio
                local def = ratio
                local mdef = ratio
                self.PATK_RATE_BM = self.PATK_RATE_BM - patk
                self.MATK_RATE_BM = self.MATK_RATE_BM - matk
                self.DEF_RATE_BM = self.DEF_RATE_BM - def
                self.MDEF_RATE_BM = self.MDEF_RATE_BM - mdef
                SetExProp(buff, 'ADDPATK', patk)
                SetExProp(buff, 'ADDMATK', matk)
                SetExProp(buff, 'ADDDEF', def)
                SetExProp(buff, 'ADDMDEF', mdef)
            end
        end
    end
end

function SCR_BUFF_LEAVE_Devaluation_Debuff(self, buff, arg1, arg2, over)
    if GetObjType(self) == OT_PC then
        self.IgnoreReinforce = 0;
        REFRESH_ALL_EQUIPED_ITEM(self);
        InvalidateStates(self);
    else
        local patk = GetExProp(buff, 'ADDPATK')
        local matk = GetExProp(buff, 'ADDMATK')
        local def = GetExProp(buff, 'ADDDEF')
        local mdef = GetExProp(buff, 'ADDMDEF')
        self.PATK_RATE_BM = self.PATK_RATE_BM + patk
        self.MATK_RATE_BM = self.MATK_RATE_BM + matk
        self.DEF_RATE_BM = self.DEF_RATE_BM + def
        self.MDEF_RATE_BM = self.MDEF_RATE_BM + mdef
    end
end

function REFRESH_ALL_EQUIPED_ITEM(pc)
    REFRESH_EQUIPED_ITEM(pc, 'SHIRT');
    REFRESH_EQUIPED_ITEM(pc, 'GLOVES');
    REFRESH_EQUIPED_ITEM(pc, 'BOOTS');
    REFRESH_EQUIPED_ITEM(pc, 'RH');
    REFRESH_EQUIPED_ITEM(pc, 'LH');
    REFRESH_EQUIPED_ITEM(pc, 'PANTS');
    REFRESH_EQUIPED_ITEM(pc, 'RING1');
    REFRESH_EQUIPED_ITEM(pc, 'RING2');
    REFRESH_EQUIPED_ITEM(pc, 'NECK');
end

function REFRESH_EQUIPED_ITEM(pc, part)
    local equipItem = GetEquipItem(pc, part);
    if equipItem == nil then
        return;
    end
    REFRESH_ITEM(pc, equipItem);
end

function REFRESH_ITEM(pc, item)
    if pc == nil or item == nil then
        return;
    end

    -- 인챈트아머
    local enchantUpdate = 0;
    if GetExProp(item, 'Rewards_BuffValue') > 0 then -- 인챈터 버프걸려있으면 그것도 같이 처리해야 함
        enchantUpdate = 1;
    end

    -- 과대평가
    local bonusReinf = pc.BonusReinforce;
    if item.EquipGroup ~= 'SubWeapon' then
        bonusReinf = 0;
    end
    
    -- refresh scp
    local refreshScpStr = TryGetProp(item, 'RefreshScp');
    if refreshScpStr ~= nil and refreshScpStr ~= 'None' then
        local refreshScp = _G[refreshScpStr];
        refreshScp(item, enchantUpdate, pc.IgnoreReinforce, bonusReinf);
    end
end

function SCR_SUMMON_FORGERY(mon, self, skl)
    local tableMon = GetExArgObject(self, 'FORGERY_TABLE_OBJ')
    if tableMon ~= nil then
        Dead(tableMon);
    end
    SetExProp(mon, 'OWNER_HANDLE', GetHandle(self));
--  SetExProp(mon, 'ENABLE_FORGERY', 1);
    SetExArgObject(self, 'FORGERY_TABLE_OBJ', mon);

    -- get accessory items of owner
    local ring1Item = GetEquipItem(self, 'RING1');
    local ring2Item = GetEquipItem(self, 'RING2');
    local neckItem = GetEquipItem(self, 'NECK');
    
    local ring1ID = 0;
    if ring1Item ~= nil and ring1Item.ClassName ~= 'NoRing' then
        ring1ID = ring1Item.ClassID;
    end
    local ring1Str = '0';
    if ring1ID > 0 then
        ring1Str = GetModifiedPropertiesString(ring1Item);
    end

    local ring2ID = 0;
    if ring2Item ~= nil and ring2Item.ClassName ~= 'NoRing' then
        ring2ID = ring2Item.ClassID;
    end
    local ring2Str = '0';
    if ring2ID > 0 then
        ring2Str = GetModifiedPropertiesString(ring2Item);
    end

    local neckID = 0;
    if neckItem ~= nil and neckItem.ClassName ~= 'NoNeck' then
        neckID = neckItem.ClassID;
    end
    local neckStr = '0';
    if neckID > 0 then
        neckStr = GetModifiedPropertiesString(neckItem);
    end

    -- set forgery item info into table
    SetExProp(mon, 'FORGERY_RING1_ID', ring1ID);
    SetExProp(mon, 'FORGERY_RING2_ID', ring2ID);
    SetExProp(mon, 'FORGERY_NECK_ID', neckID);
    SetExProp_Str(mon, 'FORGERY_RING1', ring1Str);
    SetExProp_Str(mon, 'FORGERY_RING2', ring2Str);
    SetExProp_Str(mon, 'FORGERY_NECK', neckStr);

    SCR_SUMMON_SET_EXPROP(mon, self, skl);
    SetDeadScript(mon, "DEAD_SCRIPT_FORGERY_TABLE");
end

function DEAD_SCRIPT_FORGERY_TABLE(table)
    local ownerHandle = tonumber(GetExProp(table, 'OWNER_HANDLE'));
    local owner = GetByHandle(table, ownerHandle);
    if owner == nil then
        return;
    end
    local members, cnt = GetPartyMemberList(owner, PARTY_NORMAL);
    if members == nil then
        return;
    end
    for i = 1, cnt do
        SendAddOnMsg(members[i], 'ADDON_CLOSE_MSG');
    end
end

function SCR_APPRAISER_FORGERY_DIALOG(table, pc)
    local ownerHandle = tonumber(GetExProp(table, 'OWNER_HANDLE'));
    local owner = GetByHandle(pc, ownerHandle);
    if owner == nil then
        return;
    end
    if IsSameObject(pc, owner) == 1 then
        return;
    end
    local skl = GetSkill(owner, 'Appraiser_Forgery');
    if skl == nil then
        return;
    end
    if IS_APPLY_RELATION(owner, pc, "PARTY") == true then
        ShowForgeryItems(table, owner, pc);
    end
end

function CHECK_EQUIPED_ACCESSORY(self, skl)
    local ring1 = GetEquipItem(self, 'RING1');
    local ring2 = GetEquipItem(self, 'RING2');
    local neck = GetEquipItem(self, 'NECK');

    if (ring1 == nil or ring1.ClassName == 'NoRing') and (ring2 == nil or ring2.ClassName == 'NoRing') and (neck == nil or neck.ClassName == 'NoNeck') then
        SendSysMsg(self, 'NotExistEquippedAccessory');
        return 0;
    end
    return 1;
end

function SCR_BUFF_ENTER_Forgery_Buff(self, buff, arg1, arg2, over)
    local ring1ID = GetExProp(self, 'FORGERY_RING1_ID');
    local ring2ID = GetExProp(self, 'FORGERY_RING2_ID');
    local neckID = GetExProp(self, 'FORGERY_NECK_ID');
    local ring1Str = GetExProp_Str(self, 'FORGERY_RING1');
    local ring2Str = GetExProp_Str(self, 'FORGERY_RING2');
    local neckStr = GetExProp_Str(self, 'FORGERY_NECK');

    -- equip forgery items
    local ring1IES, ring2IES, neckIES = nil;
    if ring1ID > 0 then
        ring1IES = CreateGCIESByID('Item', ring1ID);
    end
    if ring2ID > 0 then
        ring2IES = CreateGCIESByID('Item', ring2ID);
    end
    if neckID > 0 then
        neckIES = CreateGCIESByID('Item', neckID);
    end

    -- set modified property string
    if ring1IES ~= nil and ring1Str ~= '0' then
        SetModifiedPropertiesString(ring1IES, ring1Str);
    end
    if ring2IES ~= nil and ring2Str ~= '0' then
        SetModifiedPropertiesString(ring2IES, ring2Str);
    end
    if neckIES ~= nil and neckStr ~= '0' then
        SetModifiedPropertiesString(neckIES, neckStr);
    end

    if ring1IES ~= nil then
        EquipForgeryItem(self, ring1IES, 'RING1');
    end
    if ring2IES ~= nil then
        EquipForgeryItem(self, ring2IES, 'RING2');
    end 
    if neckIES ~= nil then
        EquipForgeryItem(self, neckIES, 'NECK');
    end 

    UpdateEquipment(self);
    SendForgeryItems(self, 0);

    local buffTime = GetExProp(self, 'FORGERY_BUFF_TIME');
    SendAddOnMsg(self, 'APPRAISER_FORGERY', '', buffTime);
end

function SCR_BUFF_LEAVE_Forgery_Buff(self, buff, arg1, arg2, over)
    -- unequip forgery items
    UnEquipForgeryItem(self, 'RING1');
    UnEquipForgeryItem(self, 'RING2');
    UnEquipForgeryItem(self, 'NECK');

    -- del equip item info
    DelExProp(self, 'FORGERY_RING1_ID');
    DelExProp(self, 'FORGERY_RING2_ID');
    DelExProp(self, 'FORGERY_NECK_ID');
    DelExProp_Str(self, 'FORGERY_RING1');
    DelExProp_Str(self, 'FORGERY_RING2');
    DelExProp_Str(self, 'FORGERY_NECK');
    
    DelExProp(self, 'FORGERY_BUFF_TIME');
    
    UpdateEquipment(self);
    SendForgeryItems(self, 1);
    SendAddOnMsg(self, 'APPRAISER_FORGERY', '', 0);
end

function ON_REQ_FORGERY(owner, target, table, ring1, ring2, neck)
    if owner == nil or target == nil or table == nil then
        return;
    end
    local skl = GetSkill(owner, 'Appraiser_Forgery');
    if skl == nil then
        return;
    end
--  if GetExProp(table, 'ENABLE_FORGERY') ~= 1 then
--      return;
--  end

    RemoveBuff(target, 'Forgery_Buff');

    local ring1ID = GetExProp(table, 'FORGERY_RING1_ID');
    local ring2ID = GetExProp(table, 'FORGERY_RING2_ID');
    local neckID = GetExProp(table, 'FORGERY_NECK_ID');
    local ring1Str = GetExProp_Str(table, 'FORGERY_RING1');
    local ring2Str = GetExProp_Str(table, 'FORGERY_RING2');
    local neckStr = GetExProp_Str(table, 'FORGERY_NECK');
    
    if ring1 == 1 then
        SetExProp(target, 'FORGERY_RING1_ID', ring1ID);
        SetExProp_Str(target, 'FORGERY_RING1', ring1Str);
    end
    if ring2 == 1 then
        SetExProp(target, 'FORGERY_RING2_ID', ring2ID);
        SetExProp_Str(target, 'FORGERY_RING2', ring2Str);
    end
    if neck == 1 then
        SetExProp(target, 'FORGERY_NECK_ID', neckID);
        SetExProp_Str(target, 'FORGERY_NECK', neckStr);
    end

    if ring1 == 0 and ring2 == 0 and neck == 0 then -- 모두 선택 안했다면 버프 걸어주지 않도록 함
        return;
    end
    
    local bufftime = 150000 + (skl.Level * 30000);
    SetExProp(target, 'FORGERY_BUFF_TIME', bufftime);
    AddBuff(owner, target, 'Forgery_Buff', 99, 0, bufftime); -- 지속시간 공식 수정한 후에 여기서 시간 세팅 부탁드려여
--  DelExProp(table, 'ENABLE_FORGERY');
--  Dead(table);
end

function CHECK_NOT_REINFORCE_STATE(self, skl)
    if GetExProp(self, 'MoruInstall') > 0 or IsRunningScript(self, 'SCR_ITEM_REINFORCE_131014') == 1 then
        SendSysMsg(self, 'CannotUseInReinforceState');
        return 0;
    end
    return 1;
end

function CHECK_COLONY_WAR_MAP(self, skl)
    if IsJoinColonyWarMap(self) == 1 then
        SendSysMsg(self, 'ThisLocalUseNot');
        return 0;
    end
    return 1;
end

function _TX_ITEM_APPRAISAL(target, seller, itemList, price, skill, totalPrice, needCnt, needItemName, prList, socketList, priceList)
    if target == nil or seller == nil then
        return;
    end
    
    -- 구/신 감정 리스트 분류 -- 
	local randomItemList = {}
	local appraisalItemList = {}
	
    for i = 1, #itemList do
	    local tempItem = itemList[i]
	    local needRandomoption = TryGetProp(tempItem, "NeedRandomOption")
	    local needAppraisal = TryGetProp(tempItem, "NeedAppraisal")
	    
	    if needRandomoption == 1 then
	        randomItemList[#randomItemList + 1] = tempItem
	    elseif needAppraisal == 1 then
	        appraisalItemList[#appraisalItemList + 1] = tempItem
	    end
	end
	
	local RandomOptionGroup = {};
	local RandomOption = {};
	local RandomOptionValue = {};
	local optionCount = {}
	
	-- 아이템 랜덤 옵션 옵션 획득 --
	if #randomItemList > 0 then
        for i = 1, #randomItemList do
            local item = randomItemList[i];
            local itemGroupList, optionNameList, optionCnt, optionStateList = FIRST_RANDOM_OPTION_ITEM(pc, item, skill);
            if itemGroupList== nil or  optionNameList== nil or optionCnt== nil or optionStateList == nil then
                EnableControl(pc, 1, "APPRAISER");
                return;
            end
            RandomOptionGroup[i] = itemGroupList;
        	RandomOption[i] = optionNameList;
        	RandomOptionValue[i] = optionStateList;
        	optionCount[i] = optionCnt;
        end
    end
    
    local tx = nil;
    local tx1, tx2 = nil;   
    local historyStr = "";
    local sellerHandle = GetHandle(seller);
    local targetHandle = GetHandle(target);

    PlayAnimLocal(seller, target, "LOOK");
    EnableControl(target, 0, "APPRAISER_PC");
    sleep(1500)
    
    -- TxBegin
    if sellerHandle == targetHandle then
        tx = TxBegin(seller);
    else
        tx1, tx2 = TxBeginDouble(seller, target);
        historyStr = string.format("%s#", GetTeamName(target));
    end

    -- Tx가 잘 만들어졌나
    if sellerHandle == targetHandle then 
        if nil == tx then
            SET_SELLER_FLAG(seller, target, 0);
            return;
        end
    else
        if nil == tx1 or nil == tx2 then
            EnableControl(target, 1, "APPRAISER_PC");
            SET_SELLER_FLAG(seller, target, 0);
            return;
        end
    end

    -- (구) 감정 아이템 리스트 TX --
    if #appraisalItemList > 0 then
    	for i = 1, #appraisalItemList do
	        local item = appraisalItemList[i]
	        if item == nil then         
	            EnableControl(target, 1, "APPRAISER_PC");
	            SET_SELLER_FLAG(seller, target, 0);
	            return;
	        end
	
	        local addPR = GET_APPRAISAL_PR_COUNT(item, prList[i], skill);
	        local maxPR = prList[i] + addPR;
	        local addSoket = GET_APPRAISAL_SOCKET_COUNT(item, socketList[i], skill);
	        
	        -- 로그용임
	        SetExProp(item, "APPRAISER_MaxPR", maxPR)
	        SetExProp(item, "APPRAISER_ADDPR", addPR)
	        SetExProp(item, "APPRAISER_ADDSOKET", addSoket)
	        
	        if sellerHandle == targetHandle then
	            TxIsAppraisal(tx, item, addPR, addSoket, maxPR);
	            AppraisalPCMongoLog(seller, target, item, 0, skill.Level);
	        else
	            TxIsAppraisal(tx2, item, addPR, addSoket, maxPR);
	
	            -- 기록용
	            local name, cnt = ITEMBUFF_NEEDITEM_Appraiser_Apprise(seller, item);
	            local thisItemPrice = priceList[i];            
	            AppraisalPCMongoLog(seller, target, item, thisItemPrice, skill.Level);
	
	            historyStr = historyStr .. string.format("%d#%d#", item.ClassID, thisItemPrice);
	        end
	    end
    end
    
    -- 아이템 랜덤 옵션 감정 아이템 리스트 TX --
    if #randomItemList > 0 then
        for i = 1, #randomItemList do
            local randomItem = randomItemList[i];
            -- 로그용
            SetExProp(randomItem, 'RANDOM_OPTION_CNT', optionCount[i]);

            for j = 1, optionCount[i] do
                local group = RandomOptionGroup[i][j];
                local option = RandomOption[i][j];
                local value = RandomOptionValue[i][j];
                
                 -- 로그용
                SetExProp_Str(randomItem, 'RandomOptionGroup_'..j, group);
                SetExProp_Str(randomItem, 'RandomOption_'..j, option);
                SetExProp(randomItem, 'RandomOptionValue_'..j, value);

                -- 치트
                if IsGM(target) == 1 and GetExProp(target, 'ERROR_RANDOM_OPTION_FORCELY') == 1 then                 
                    group = 'STAT';
                    option = 'ADD_FIRE';
                    value = IMCRandom(1, 2000);
                end

                if sellerHandle == targetHandle then
                    TxSetIESProp(tx, randomItem, 'RandomOptionGroup_'..j, group);
                    TxSetIESProp(tx, randomItem, 'RandomOption_'..j, option);
                    TxSetIESProp(tx, randomItem, 'RandomOptionValue_'..j, value);
                else
                    TxSetIESProp(tx2, randomItem, 'RandomOptionGroup_'..j, group);
                    TxSetIESProp(tx2, randomItem, 'RandomOption_'..j, option);
                    TxSetIESProp(tx2, randomItem, 'RandomOptionValue_'..j, value);                          
                end
            end
            if sellerHandle == targetHandle then
                TxSetIESProp(tx, randomItem, "NeedRandomOption", 0);
                AppraisalPCMongoLog(seller, target, randomItem, 0, skill.Level);
            else
                TxSetIESProp(tx2, randomItem, "NeedRandomOption", 0);
                AppraisalPCMongoLog(seller, target, randomItem, thisItemPrice, skill.Level);
            end
        end        
    end
    
    -- 뺏을거다
    local ret = "";
    local giveMoney = 0;
    if sellerHandle == targetHandle then
        TxTakeItem(tx, needItemName, needCnt, skill.ClassName);
        ret = TxCommit(tx);
    else
        TxTakeItem(tx1, needItemName, needCnt, skill.ClassName);
        TxTakeItem(tx2, MONEY_NAME, totalPrice, skill.ClassName);
        giveMoney = math.floor(totalPrice * tonumber(AUTOSELLER_SILVER_FEE) / 100);
        if giveMoney > 0 then
            TxGiveItem(tx1, MONEY_NAME, giveMoney, skill.ClassName);
        end
        ret = TxCommit(tx1);
    end
    
    PlayAnimLocal(seller, target, "STD");
    EnableControl(target, 1, "APPRAISER_PC");
    SET_SELLER_FLAG(seller, target, 0);

    local guidList = {};
    for i = 1, #itemList do
        guidList[#guidList + 1] = GetItemGuid(itemList[i]);
    end

    local errorGuidList, errorInfoStrList = {}, {};
    if ret ~= 'SUCCESS' then
        ITEM_APPRAISAL_DELETE_PROP(itemList);
        SaveAppraisalPCMongoLog(target, guidList, 0, errorGuidList, errorInfoStrList);
        SendSysMsg(target, "DataError");
        return;
    end

    local wrongItemList = SCR_RANDOM_SETIESPROP_LOG(randomItemList);
    errorGuidList, errorInfoStrList = GET_RANDOM_OPTION_ERROR_LOG_PARAM(wrongItemList);
    SaveAppraisalPCMongoLog(target, guidList, 1, errorGuidList, errorInfoStrList);

    if giveMoney > 0 then
        if IsExistAutoSellerInAdevntureBook(seller, skill.ClassID) == 'NO' then
            ALARM_ADVENTURE_BOOK_NEW(seller, skill.Name);
        end
        AddAdventureBookAutoSellerInfo(seller, skill.ClassID, giveMoney);
    end

    local max = math.min(#itemList, 6);
    for i = 1, max do
        local item = itemList[i]
        if item ~= nil then
            ShowTargetItemBalloon(target, sellerHandle, "{@st43}", "AppraisalSuccess", item, 3);
        end
    end

    if sellerHandle ~= targetHandle then -- 남의 거는 기록으로 남겨줌
        local needItemType = GetClass("Item", needItemName).ClassID;
        AddAutoSellHistory(seller, AUTO_SELL_APPRAISE, needItemType, needCnt, totalPrice, historyStr);
    end

    SendAddOnMsg(seller, "SUCCESS_APPRALSAL_PC", "", 0);
    SendAddOnMsg(target, "SUCCESS_APPRALSAL_PC", "", 0);
    SendAddOnMsg(target, "UPDATE_ITEM_REPAIR", "", 0);

    ITEM_APPRAISAL_DELETE_PROP(itemList);
end

function TEST_SEND_TOO_MANY_HISTROY(pc)    
    local historyStr = "111111#";
    for i = 1, 10000 do
        historyStr = historyStr.."22";
    end
    historyStr = historyStr.."#";

    for i = 1, 500 do
        AddAutoSellHistory(pc, AUTO_SELL_APPRAISE, 1, 1, 1, historyStr);
    end
end