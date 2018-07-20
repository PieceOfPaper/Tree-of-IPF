-- item_consume.lua


function SCR_UES_ITEM_BOOK(self,argObj, argstring, argnum1, argnum2)
    --ShowOkDlg(self,argstring, 1);
	ShowBookItem(self, argstring);
end

function SCR_USE_ITEM_MaxSTAUP(self,argObj, argstring, argnum1, argnum2)
    local value = self.MAXSTA_Bonus + argnum1;
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'MAXSTA_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_MaxHPUP(self,argObj, argstring, argnum1, argnum2)
    local value = self.MHP_Bonus + argnum1
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'MHP_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_MaxSPUP(self,argObj, argstring, argnum1, argnum2)
    local value = self.MSP_Bonus + argnum1
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'MSP_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_MaxATKUP(self,argObj, argstring, argnum1, argnum2)
    local value = self.MATK_Bonus + argnum1
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'MATK_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_MaxSkillPowerUP(self,argObj, argstring, argnum1, argnum2)
    local value = self.MSKILL_Bonus + argnum1
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'MSKILL_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_MaxDEFUP(self,argObj, argstring, argnum1, argnum2)
    local value = self.MAXDEF_Bonus + argnum1
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'MAXDEF_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_MaxRRUP(self,argObj, argstring, argnum1, argnum2)
    local value = self.MAXRR_Bonus + argnum1
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'MAXRR_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_MaxHRUP(self,argObj, argstring, argnum1, argnum2)
    local value = self.MAXHR_Bonus + argnum1
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'MAXHR_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_MaxDRUP(self,argObj, argstring, argnum1, argnum2)
    local value = self.MAXDR_Bonus + argnum1
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'MAXDR_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_MaxWeightUP(self,argObj, argstring, argnum1, argnum2)
    local value = self.MaxWeight_Bonus + argnum1
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'MaxWeight_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_STRUP(self,argObj, argstring, argnum1, argnum2)
    PlayEffect(self, 'F_pc_status_str_up', 6, 1, "BOT", 1);
    local value = self.STR_Bonus + argnum1
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'STR_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_DEXUP(self,argObj, argstring, argnum1, argnum2)
    PlayEffect(self, 'F_pc_status_dex_up', 6, 1, "BOT", 1);
    local value = self.DEX_Bonus + argnum1
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'DEX_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_CONUP(self,argObj, argstring, argnum1, argnum2)
    PlayEffect(self, 'F_pc_status_con_up', 6, 1, "BOT", 1);
    local value = self.CON_Bonus + argnum1
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'CON_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_INTUP(self,argObj, argstring, argnum1, argnum2)
    PlayEffect(self, 'F_pc_status_int_up', 6, 1, "BOT", 1);
    local value = self.INT_Bonus + argnum1
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'INT_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_MNAUP(self,argObj, argstring, argnum1, argnum2)
    PlayEffect(self, 'F_pc_status_mna_up', 6, 1, "BOT", 1);
    local value = self.MNA_Bonus + argnum1
    local tx = TxBegin(self);
    TxSetIESProp(tx, self, 'MNA_Bonus', value);
	local ret = TxCommit(tx);
	
	InvalidateStates(self);
end

function SCR_USE_ITEM_STATUP(self,argObj, argstring, argnum1, argnum2)
    PlayEffect(self, 'F_pc_StatPoint_up', 4, 1, "BOT", 1);
    local beforeValue = self.StatByBonus
    local tx = TxBegin(self);
    TxAddIESProp(tx, self, 'StatByBonus', 1)
    local ret = TxCommit(tx);
    local afterValue = self.StatByBonus
    CustomMongoLog(self, "StatByBonusADD", "Layer", GetLayer(self), "beforeValue", beforeValue, "afterValue", afterValue, "addValue", 1, "Way", "SCR_USE_ITEM_STATUP", "Type", "USE_ITEM")
    SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("STATUE_STAT_01"), 3)
end

function SCR_USE_ITEM_Truffle(self, argObj, BuffName, arg1, arg2)

    local value = IMCRandom(arg1, arg2);
	HealSP(self, value, 0);
	
	local feel = IMCRandom(1, 3);
	if feel == 1 then
	    Chat(self, ScpArgMsg("Auto_taste1"))
	elseif feel == 2 then
	    Chat(self, ScpArgMsg("Auto_taste2"))
	elseif feel == 3 then
	    Chat(self, ScpArgMsg("Auto_taste3"))
	end
end

function SCR_USE_ITEM_Dilgele(self, argObj, BuffName, arg1, arg2)
	local spPoint = IMCRandom(arg1, arg2);
	AddSP(self, spPoint);
end

function SCR_USE_ITEM_Raudonelis(self, argObj, BuffName, arg1, arg2)
	local hpPoint = IMCRandom(arg1, arg2);
	AddHP(self, hpPoint);
end

function SCR_USE_ITEM_Poison(self, argObj, BuffName, arg1, arg2)
	local poisonDmg = IMCRandom(arg1, arg2);
	TakeDamage(self, self, "None", poisonDmg, "Poison", "None", "Melee", HIT_POSION, HITRESULT_BLOW);
end

function SCR_TAKE_NO_TRADE_CNT(self, classID, removeCnt)
	if nil == self then
		return;
	end

	local invItem, invCnt = GetInvItemByType(self, classID);
	local wareItem, wareCnt = GetWareInvItemByType(self, classID);
	if nil == invItem and wareItem == nil then
		return;
	end

	if nil ~= wareItem and wareItem.MaxStack <= 1 then
		 wareItem = nil;
		 wareCnt = 0;
	end
	local invCount = TryGetProp(invItem, "BelongingCount");
	local wareCount = TryGetProp(wareItem, "BelongingCount");

	local noTradeCnt = 0;
	if nil ~= invCount then
		invCount = tonumber(invCount);
		noTradeCnt = invCount;
	else
		invCount = 0;
	end

	if nil ~= wareCount then
		wareCount = tonumber(wareCount);
		noTradeCnt = wareCount;
	else
		wareCount = 0;
	end

	local totalCnt = invCnt + wareCnt;
	local remainCnt = totalCnt - removeCnt;
	
	noTradeCnt = noTradeCnt - removeCnt;

	if 0 >= noTradeCnt then
		noTradeCnt = 0
	elseif totalCnt < noTradeCnt then
		noTradeCnt = totalCnt
	end

	if nil ~= invItem and nil ~= invCount and invCount ~= noTradeCnt then
		if 0 < invCnt - removeCnt then
			RunScript("SCR_TX_NO_TRADE_CNT", self, invItem, noTradeCnt, 0)
		end
	end

	if nil ~= wareItem and nil ~= wareCount and wareCount ~= noTradeCnt then
		RunScript("SCR_TX_NO_TRADE_CNT", self, wareItem, noTradeCnt, 1)
	end
end


function SCR_GIVE_NO_TRADE_CNT(self, invItem, wareItem, addCnt)
	if nil == self then
		return;
	end

	local invNoTrade = TryGetProp(invItem, "BelongingCount");
	local wareNoTrade = TryGetProp(wareItem, "BelongingCount");

	local reset = invNoTrade;
	if nil ~= invNoTrade and nil ~= wareNoTrade then
		local invNo = tonumber(invNoTrade);
		local wareNo = tonumber(wareNoTrade);
		if invNo < wareNo then
			invNoTrade = nil;
		end
	end

	local resultCnt = 0;
	if nil ~= invItem and nil ~= invNoTrade then
		invNoTrade = tonumber(invNoTrade)
		resultCnt = invNoTrade + addCnt;
	elseif nil ~= wareItem and nil ~= wareNoTrade then
		wareNoTrade = tonumber(wareNoTrade)
		resultCnt = wareNoTrade + addCnt;
		if nil ~= reset and nil == invNoTrade then
			invNoTrade = reset;
		end
	else
		resultCnt = addCnt;
	end

	if nil ~= invItem and nil ~= invNoTrade and invNoTrade ~= resultCnt then
		RunScript("SCR_TX_NO_TRADE_CNT", self, invItem, resultCnt, 0)
	end

	if nil ~= wareItem and nil ~= wareNoTrade and wareNoTrade ~= resultCnt then
		RunScript("SCR_TX_NO_TRADE_CNT", self, wareItem, resultCnt, 1)
	end
end


function SCR_TX_NO_TRADE_CNT(self, item, value, isWareHouse)
	if item == nil then
		return;
	end

	local tx = TxBegin(self);
	if nil == tx then
		return;
	end

	TxEnableInIntegrateIndun(tx);
    TxSetIESProp(tx, item, 'BelongingCount', value);
	local ret = TxCommit(tx);

	if ret == "SUCCESS" and 1 == isWareHouse then
		SendWareHouseItemProp(self, item);
	end
end

function SCR_USE_EXTEND_ACCOUNT_WAREHOUSE(self, aObj)
    local aObj = GetAccountObj(self);
	if nil == aObj then
		return;
	end

	local slotDiff = aObj.AccountWareHouseExtend;
	local price = ACCOUNT_WAREHOUSE_EXTEND_PRICE;
	if slotDiff > 0 then
		if slotDiff >= tonumber(ACCOUNT_WAREHOUSE_MAX_EXTEND_COUNT) then
			return;
		end
		if slotDiff < 4 then
		    price = price*(math.pow(2, slotDiff))
		else
		    --Form the fifth slot, it will be fixde at 2000000 silver
		    price = price * 10
		end
	end

	local count = GetInvItemCount(self, 'Vis')
	if price > count then
		return
	end

	local tx = TxBegin(self);
	if nil == tx then
		return;
	end
	
	local currentCount = aObj.AccountWareHouseExtend;
	if currentCount >= ACCOUNT_WAREHOUSE_MAX_EXTEND_COUNT then
		TxRollBack(tx);
		return;
	end
	TxAddIESProp(tx, aObj, 'AccountWareHouseExtend', 1);
	TxTakeItem(tx, MONEY_NAME, price, 'EXTEND_ACCOUNT_WAREHOUSE_'..currentCount + 1);
	
	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
		SendProperty(self, aObj);
		SendAddOnMsg(self, "ACCOUNT_WAREHOUSE_ITEM_LIST");
		SendAddOnMsg(self, "ACCOUNT_UPDATE");
	end
end

function SCR_USE_FREE_EXTEND_ACCOUNT_WAREHOUSE(self,string1, arg1, arg2, itemID)
    local aObj = GetAccountObj(self);
	local tx = TxBegin(self);
	if nil == tx then
		return;
	end
	
    local account_Warehouse_Cnt = GET_ACCOUNT_WAREHOUSE_SLOT_COUNT(self, aObj)
    local add_Warehouse = arg2
    if account_Warehouse_Cnt < 0 or account_Warehouse_Cnt == nil then
        if  add_Warehouse == nil then
            TxRollBack(tx);
            return;
        end
    end

    TxAddIESProp(tx, aObj, 'AccountWareHouseExtendByItem', add_Warehouse);
	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
		SendProperty(self, aObj);
		SendAddOnMsg(self, "ACCOUNT_WAREHOUSE_ITEM_LIST");
		SendAddOnMsg(self, "ACCOUNT_UPDATE");
		if add_Warehouse == 1 then
		    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ACCOUNT_UPDATE1"), 5);
		elseif add_Warehouse == 2 then
		    SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("ACCOUNT_UPDATE2"), 5);
		end
	end
end

function SCR_USE_EXTEND_WAREHOUSE(self, etcObj, aObj, price, extendCnt)
	local tx = TxBegin(self);
	if nil == tx then
		return;
	end
	
	TxAddIESProp(tx, etcObj, 'MaxWarehouseCount', tonumber(WAREHOUSE_EXTEND_SLOT_COUNT));
	TxAddIESProp(tx, aObj, 'Medal', -price, 'EXTEND_WAREHOUSE_'..extendCnt);
	
	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
		SendProperty(self, etcObj);
		SendAddOnMsg(self, "WAREHOUSE_ITEM_LIST");
		SendAddOnMsg(self, "ACCOUNT_UPDATE");
	end
end

function RESET_INDUN_FREE_TIME(self, etc)
	local tx = TxBegin(self)
	if nil == tx then
		return;
	end

	TxSetIESProp(tx, etc, 'IndunFreeTime', 'None');
	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
		RemoveBuff(self, 'Premium_indunFreeEnter');
		PremiumItemMongoLog(self, "IndunFreeTime", "End", 0);
	end
end

function SCR_USE_ITEM_INDUN_COUNT_RESET(self, itemGUID, argList)

	local invItem = GetInvItemByGuid(self, itemGUID);
	if nil == invItem then
		return
	end

	if invItem.ClassName ~= 'Premium_indunReset' and invItem.ClassName ~= 'Premium_indunReset_14d' and invItem.ClassName ~= 'Premium_indunReset_14d_test' and invItem.ClassName ~= 'Premium_indunReset_1add' and invItem.ClassName ~= 'Premium_indunReset_1add_14d' and invItem.ClassName ~= 'indunReset_1add_14d_NoStack' and invItem.ClassName ~= 'Event_1704_Premium_indunReset_1add' and invItem.ClassName ~= 'Event_1704_Premium_indunReset' and invItem.ClassName ~= 'Premium_indunReset_TA' then 
		-- 이거 차후 위험요소 있음. 
		-- Premium_indunReset 아이템을 소모해서 Premium_indunReset_14d_test 한 것과 같은 효과를 낼 수 있다.
		return;
	end

	if IsFixedItem(invItem) == 1 then
		return;
	end
	local pcetc = GetETCObject(self);

	local countType1 = "InDunCountType_100";
	local countType2 = "InDunCountType_200";

	if pcetc[countType1] == 0 and pcetc[countType2] == 0 then
		return;
	end

	local tx = TxBegin(self);
	if tx == nil then
		return;
	end

	TxTakeItemByObject(tx, invItem, 1, "use");
	if pcetc[countType1] > 0 then
		local countRewardType = "InDunRewardCountType_100";
	    if invItem.ClassName == 'Premium_indunReset_1add' or invItem.ClassName == 'Premium_indunReset_1add_14d' or invItem.ClassName == 'indunReset_1add_14d_NoStack' or invItem.ClassName == 'Event_1704_Premium_indunReset_1add' then
	        TxSetIESProp(tx, pcetc, countType1, pcetc[countType1] - 1);
			TxSetIESProp(tx, pcetc, countRewardType, pcetc[countRewardType] - 1);
	    else
	        TxSetIESProp(tx, pcetc, countType1, 0);
			TxSetIESProp(tx, pcetc, countRewardType, 0);
	    end
	end

	if pcetc[countType2] > 0 then
	    if invItem.ClassName == 'Premium_indunReset_1add' or invItem.ClassName == 'Premium_indunReset_1add_14d' or invItem.ClassName == 'indunReset_1add_14d_NoStack' or invItem.ClassName == 'Event_1704_Premium_indunReset_1add' then
	        TxSetIESProp(tx, pcetc, countType2, pcetc[countType2] - 1);
	    else
	        TxSetIESProp(tx, pcetc, countType2, 0);
	    end
	end

	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		PremiumItemMongoLog(self, "IndunReset", "Use", 0);
		PlayEffect(self, 'F_sys_TOKEN_open', 2.5, 1, "BOT", 1);
		-- SendAddOnMsg(self, "INDUN_COUNT_RESET", '', 0) -- 쓰지도 않는데 왜 메세지 뿌리지.
	end
end

function SCR_USE_ITEM_INDUN_FREE_TIME(self, itemGUID, argList)
	local invItem = GetInvItemByGuid(self, itemGUID);
	if nil == invItem then
		return
	end

	if IsFixedItem(invItem) == 1 then
		return;
	end

	if invItem.ClassName ~= "Premium_indunFreeEnter" then
		return;
	end

	local pcetc = GetETCObject(self);
	local time = tonumber(invItem.NumberArg1);
	local expiry = GetAddDataFromCurrent(time);
	
	if pcetc.IndunFreeTime ~= 'None' then
		return;
	end

	local tx = TxBegin(self);
	if tx == nil then
		return;
	end

	TxTakeItemByObject(tx, invItem, 1, "use");
	TxSetIESProp(tx, pcetc, 'IndunFreeTime', expiry);
		
	local ret = TxCommit(tx);
	if ret == 'SUCCESS' then
		PremiumItemMongoLog(self, "IndunFreeTime", "Start", time);
		PlayEffect(self, 'F_sys_TOKEN_open', 2.5, 1, "BOT", 1);
		AddBuff(self, self, 'Premium_indunFreeEnter', 0, 0, time * 1000, 1);
	end
end


function TX_SCR_USE_SKILL_STAT_RESET(self, itemGUID, argList)
	local invItem = GetInvItemByGuid(self, itemGUID);
	if nil == invItem then
		return
	end

	if invItem.ClassName ~= "Premium_SkillReset" and invItem.ClassName ~= "steam_Premium_SkillReset" and invItem.ClassName ~= "steam_Premium_SkillReset_1" and invItem.ClassName ~= "Premium_SkillReset_14d" and invItem.ClassName ~= "Premium_SkillReset_1d" and invItem.ClassName ~= "Premium_SkillReset_60d" and invItem.ClassName ~= "Premium_SkillReset_Trade" then
		return;
	end

	if invItem.ItemLifeTimeOver == 1 then
		return;
	end

	if IsFixedItem(invItem) == 1 then
		return;
	end

	local guildObj = GetGuildObj(self);
	local templar = false;
	if guildObj ~= nil and IsPartyLeaderPc(guildObj, self) == 1 then
		local jobHistory = GetJobHistoryString(self)
		local sList = StringSplit(jobHistory, ";");
		for i = 1, #sList do
			local jobCls = GetClass("Job", sList[i])
			if jobCls ~= nil and jobCls.EngName == 'Templar' then
				templar = true;
				break;
			end
		end
	end

	local tx = TxBegin(self);
	if tx == nil then
		return;
	end
	
	TxResetSkill(tx, 0, 0)
	TxTakeItemByObject(tx, invItem, 1, "use");

	local ret = TxCommit(tx);
	if ret ~= 'SUCCESS' then
		return;
	end

    -- 여기서 pc 모든 특성을 가져와서 전부 오프로 바꿔주자...
    local abilList = GetAbilityNames(self);
    if abilList ~= nil then
        for i = 1, #abilList do            
            SCR_TX_PROPERTY_ACTIVE_TOGGLE(self, abilList[i])
        end
    end

	if true == templar then
		ChangePartyProp(self, PARTY_GUILD, 'Templer_BuildForge_Lv', 0);
		ChangePartyProp(self, PARTY_GUILD, 'Templer_BuildShieldCharger_Lv', 0);
	end
end


function TX_SCR_USE_STAT_RESET(self, itemGUID, argList)
	local invItem = GetInvItemByGuid(self, itemGUID);
	if nil == invItem then
		return
	end

	if invItem.ClassName ~= "Premium_StatReset" and invItem.ClassName ~= "steam_Premium_StatReset" and invItem.ClassName ~= "Premium_StatReset14" and invItem.ClassName ~= "steam_Premium_StatReset_1" and invItem.ClassName ~= "Premium_StatReset_TA" and invItem.ClassName ~= "Premium_StatReset_1d" and invItem.ClassName ~= "Premium_StatReset_60d" and invItem.ClassName ~= "Premium_StatReset_Trade" and invItem.ClassName ~= "Premium_StatReset_30d" then
		return;
	end

	if invItem.ItemLifeTimeOver == 1 then
		return;
	end

	if IsFixedItem(invItem) == 1 then
		return;
	end

	local PRE_STR = self.STR
	local PRE_CON = self.CON
	local PRE_INT = self.INT
	local PRE_MNA = self.MNA
	local PRE_DEX = self.DEX

	local tx = TxBegin(self);
	if tx == 0 then
		return;
	end
	
	TxResetStat(tx, 0, 0)
	TxTakeItemByObject(tx, invItem, 1, "use");

	local ret = TxCommit(tx);
	if ret ~= 'SUCCESS' then
		return;
	end

	InvalidateStates(self);
	ReserveAddOnMsg(self, "RESET_STAT_UP", "", 0);
	local pcPoint = GET_STAT_POINT(self);
	StatPointMongoLog(self, "Init", pcPoint, "STR", 0, PRE_STR, self.STR);
	StatPointMongoLog(self, "Init", pcPoint, "CON", 0, PRE_CON, self.CON);
	StatPointMongoLog(self, "Init", pcPoint, "INT", 0, PRE_INT, self.INT);
	StatPointMongoLog(self, "Init", pcPoint, "MNA", 0, PRE_MNA, self.MNA);
	StatPointMongoLog(self, "Init", pcPoint, "DEX", 0, PRE_DEX, self.DEX);
end

function SCR_USE_ITEM_PREMIUM_TOKEN(self, itemGUID, argList)
	local invItem = GetInvItemByGuid(self, itemGUID);
	if nil == invItem then
		return
	end

	if IsFixedItem(invItem) == 1 then
		return;
	end
	
	local pcetc = GetETCObject(self);
	local time = tonumber(invItem.NumberArg1);
	local itemName = invItem.ClassName;
	local itemType = invItem.ClassID;
	local tradeCnt = tonumber(invItem.NumberArg2);
	local find = string.find(itemName, "PremiumToken");

	if find == nil then
		if GetBuffByName(self, "Premium_boostToken") ~= nil then
		SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("IsAppliedTokenSame"), 2);
			return;
		elseif GetBuffByName(self, "Premium_boostToken02") ~= nil then
		SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("IsAppliedTokenSame"), 2);
			return;
		elseif GetBuffByName(self, "Premium_boostToken03") ~= nil then
		SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("IsAppliedTokenSame"), 2);
			return;
		elseif GetBuffByName(self, "Premium_boostToken04") ~= nil then
		SendAddOnMsg(self, "NOTICE_Dm_!", ScpArgMsg("IsAppliedTokenSame"), 2);
			return;
		end
	end

	local buffName = nil;
	if itemName == "Premium_boostToken" or itemName == "Premium_boostToken_14d" or itemName == "Premium_boostToken_14d_test" or itemName == "Premium_boostToken_10m" then
		buffName = "Premium_boostToken";
	elseif itemName == "Premium_boostToken_test1min" then
		buffName = "Premium_boostToken";	
	elseif itemName == "Premium_boostToken02" or itemName == "Premium_boostToken02_event01" or itemName == "Premium_boostToken02_1d" then
		buffName = "Premium_boostToken02";
	elseif itemName == "Premium_boostToken03" or itemName == "Premium_boostToken03_event01" then
		buffName = "Premium_boostToken03";
	elseif itemName == "Premium_boostToken04" then
		buffName = "Premium_boostToken04";
	else
		if find == nil then
			return;
		end
	end

	local tx = TxBegin(self);
	if nil == tx then
		return;
	end
	
	TxEnableInIntegrate(tx);

	if find ~= nil then
		TxSetTokenTime(tx, time, itemGUID, itemType, tradeCnt);
	else
		TxTakeItemByObject(tx, invItem, 1, "use");
		TxAddPremiumAmountBuff(tx, buffName, time);
	end

	local ret = TxCommit(tx);
	if ret ~= "SUCCESS" then
		return;
	end

	PlayEffect(self, 'F_sys_TOKEN_open', 2.5, 1, "BOT", 1); --F_sys_expcard_great

	if find ~= nil then
		SendSysMsg(self, "TokenApplied");
		local aobj = GetAccountObj(self);
		PremiumItemMongoLog(self, "TokenTime", "Start", time, aobj.TradeCount);
	else
		--SetPremiumState(self, 1, ITEM_BOOST_TOKEN);
		PremiumItemMongoLog(self, "BoostToken", "Start", time/1000);	
	end

	ADD_PREMIUM_BENEFIT(self);
end


function RESET_ITEM_PREMIUM_TOKEN(self)	
	REMOVE_PREMIUM_BENEFIT(self, ITEM_TOKEN);
	SetPremiumState(self, 0, ITEM_TOKEN);
	PremiumItemMongoLog(self, "TokenTime", "End", 0);
end

function ADD_FREE_TP(self, aObj)

	local diff = GetTimeDiff(aObj.Medal_Get_Date);
    local defFreeTP = 1
	local giveMedal = defFreeTP;
	local nextTime = "";
		
	for i=1, tonumber(MAX_FREE_TP) do
		if tonumber(CHARGE_FREE_TP_TIME) > diff then

			nextTime = GetAddDataFromCurrent(tonumber(CHARGE_FREE_TP_TIME) - diff);
			break;
		end
	
		diff = diff - tonumber(CHARGE_FREE_TP_TIME);
		giveMedal = giveMedal + defFreeTP;
	end
		
	if tonumber(MAX_FREE_TP) <= aObj.Medal + giveMedal  then
		giveMedal = tonumber(MAX_FREE_TP) - aObj.Medal;
		nextTime = "None";
	end
	
	if 0 >= giveMedal or tonumber(MAX_FREE_TP) < giveMedal then
		return;
	end
		
	local tx = TxBegin(self);
	if nil == tx then
		return;
	end
			
	TxEnableInIntegrate(tx);

	TxSetIESProp(tx, aObj, 'Medal_Get_Date', nextTime);	
	TxAddIESProp(tx, aObj, 'Medal', giveMedal, "Free");
	TxCommit(tx);

end

function SCR_TAKE_ITEM(pc, classID)
    if IsRunningScript(pc, 'TX_TAKE_ITEM') == 1 then
        return;
    end
	RunScript("TX_TAKE_ITEM", pc, classID);
end

function TX_TAKE_ITEM(pc, classID)
    if pc == nil or classID == nil then
        return;
    end
    local itemCls = GetClassByType('Item', classID);
    if itemCls == nil then
        return;
    end

    local tx = TxBegin(pc);
    if tx == nil then
        return;
    end
    TxTakeItem(tx, itemCls.ClassName, 1, 'ChangeJob');

    local ret = TxCommit(tx);
    if ret ~= 'SUCCESS' then
        IMC_LOG('ERROR_TX_FAIL', 'TX_TAKE_ITEM: fail- className('..itemCls.ClassName..')');
    end    
end