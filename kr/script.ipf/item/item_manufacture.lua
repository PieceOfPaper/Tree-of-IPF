-- item_manufacture.lua
function SCR_ITEM_MANUFACTURE_RECIPE(pc, argList, strArgList)

	if IsRest(pc) ~= 1 then
		SendSysMsg(pc, "AvailableOnlyWhileResting");	
		return;
	end
	SCR_ITEM_MANUFACTURE(pc, "Recipe", argList, strArgList)
end

function SCR_ITEM_MANUFACTURE_ALCHEMY(pc, argList, strArgList)
	SCR_ITEM_MANUFACTURE(pc, "Recipe_ItemCraft", argList, strArgList)
end

function TX_EARTH_TOWER_SHOP_TREAD(pc, argList, strArgList)
	TX_ITEM_TRADE_SHOP_THREAD(pc, argList, strArgList, 'EarthTower')
end

function TX_EARTH_TOWER_SHOP_TREAD2(pc, argList, strArgList)
	TX_ITEM_TRADE_SHOP_THREAD(pc, argList, strArgList, 'EarthTower2')
end

function TX_EVENT_ITEM_SHOP_TREAD(pc, argList, strArgList)
	TX_ITEM_TRADE_SHOP_THREAD(pc, argList, strArgList, 'EventShop')
end

function TX_EVENT_ITEM_SHOP_TREAD2(pc, argList, strArgList)
	TX_ITEM_TRADE_SHOP_THREAD(pc, argList, strArgList, 'EventShop2')
end

function TX_KEYQUESTSHOP1_SHOP_TREAD(pc, argList, strArgList)
	TX_ITEM_TRADE_SHOP_THREAD(pc, argList, strArgList, 'KeyQuestShop1')
end
function TX_KEYQUESTSHOP2_SHOP_TREAD(pc, argList, strArgList)
	TX_ITEM_TRADE_SHOP_THREAD(pc, argList, strArgList, 'KeyQuestShop2')
end
function TX_HALLOWEEN_SHOP_TREAD(pc, argList, strArgList)
	TX_ITEM_TRADE_SHOP_THREAD(pc, argList, strArgList, 'HALLOWEEN')
end

function TX_ITEM_TRADE_SHOP_THREAD(pc, argList, strArgList, shopType)

	local cls = GetClassByType("ItemTradeShop", argList[1]);
	if pc == nil or cls == nil then
		return;	
	end

	if cls.ShopType ~= shopType then
		return;
	end

	for index=1, 5 do
		local clsName = "Item_"..index.."_1";
		local itemName = cls[clsName];
		if "None" ~= itemName then
			local recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(cls, clsName);
			local itemCls = GetClass("Item", itemName)
			local count = GetInvItemCountByType(pc, itemCls.ClassID)
			
			if recipeItemCnt > count then
				return;
			end
		end
	end
	
	if cls.NeedProperty ~= 'None' then
		local sObj = GetSessionObject(pc, "ssn_shop");
		local sCount = TryGetProp(sObj, cls.NeedProperty); 
		if sCount <= 0 then
		    return
		end
	end
	
	if cls.AccountNeedProperty ~= 'None' then
		local aObj = GetAccountObj(pc)
		local nowCount = TryGetProp(aObj, cls.AccountNeedProperty)
		if nowCount <= 0 then
		    return
		end
	end
	
	local tx = TxBegin(pc);

	if cls.NeedProperty ~= 'None' then
		TxShopNeedProperty(tx, cls.NeedProperty, 1);
	end
	
	if cls.AccountNeedProperty ~= 'None' then
		local aObj = GetAccountObj(pc)
		local nowCount = TryGetProp(aObj, cls.AccountNeedProperty)
        TxSetIESProp(tx, aObj, cls.AccountNeedProperty, nowCount - 1)
	end

	for i=1, 5 do
		local clsName = "Item_"..i.."_1";
		local itemName = cls[clsName];
		if "None" ~= itemName then
			local recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(cls, clsName);
			local itemCls = GetClass("Item", itemName)
			local count = GetInvItemCountByType(pc, itemCls.ClassID)
			
			if recipeItemCnt > count then
				TxRollBack(tx);
				return;
			end

			TxTakeItem(tx, itemCls.ClassName, recipeItemCnt, shopType .. "Tread");
			if shopType == 'HALLOWEEN' then
			    local aObj = GetAccountObj(pc)
			    TxSetIESProp(tx, aObj, 'AGARIO_EVENT_WEEK', aObj.AGARIO_EVENT_WEEK + recipeItemCnt)
			end
		end
	end
	
	TxGiveItem(tx, cls.TargetItem, cls.TargetItemCnt, shopType .. "Tread");
	TxCommit(tx);
end

function SCR_ITEM_MANUFACTURE(pc, idSpace, argList, strArgList)
    if IsJoinColonyWarMap(pc) == 1 then
        return;
    end

	local recipeProp = geItemTable.GetRecipe(idSpace, argList[1]);

	if recipeProp == nil then
		SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", "", 0);
		return;
	end

	if idSpace ~= "Recipe" and idSpace ~= "Recipe_ItemCraft" then
			SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", "", 0);
		return;
	end
    
	local recipeName = recipeProp:GetName();
	local recipeCls = GetClass(idSpace, recipeName);

	local logType = "";
	if idSpace == "Recipe_ItemCraft" then
		logType = recipeCls.SklName;
	else
		logType = 'Manufacture'
	end
	
	local skillInfo = nil;
	local abil = nil;
	if idSpace == "Recipe_ItemCraft" then
		local needSklName = recipeCls.SklName;
		local needSklLevel = recipeCls.SklLevel;
		if recipeCls.IDSpc == "Skill" then
			local pcSkill = GetSkill(pc, needSklName);
			if pcSkill == nil or pcSkill.Level < needSklLevel then
						SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", "", 0);
				return;
			end	
			skillInfo = pcSkill
		elseif  recipeCls.IDSpc == 'Skill_Ability' then
			abil = GetAbility(pc, recipeCls.ClassName);
			if nil == abil or abil.Level < needSklLevel then
				SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", "", 0);
				return;
			end
		elseif recipeCls.IDSpc == "Ability" then
			local abil = GetAbility(pc, needSklName);
 			if abil == nil or abil.Level < needSklLevel then
				SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", "", 0);
				return;
			end	
		else
			SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", "", 0);
			return;
		end		
	end
	
	local itemList, itemCntList = GetDlgItemList(pc);
	local makeCnt = argList[2]; 

	if itemList == nil or #itemList < 1 then
		SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", recipeName, 0);
		return;
	end

    -- get material validation script
    local validRecipeMaterial = GET_MATERIAL_VALIDATION_SCRIPT(recipeCls);
    local IsValidRecipeMaterial = _G[validRecipeMaterial];

	local materialcnt = recipeProp.reqItemSize;
    local checkMaterial = {false, false, false, false, false}; -- itemList와 대응하여 이미 체크되었는지를 확인함
	for i = 0 , materialcnt - 1 do
		local item = recipeProp:GetReqItem(i);
		local count = GET_INV_ITEM_COUNT_BY_TYPE(pc, item.type, recipeCls);
		if item.count * makeCnt > count then
			SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", recipeName, 0);
			return;
		end

		for j = 1, #itemList do
			local targetitem = itemList[j];
			if targetitem == nil then
				SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", recipeName, 0);
				return;
			end

            if checkMaterial[j] == false then
                local materialCls = GetClassByType('Item', item.type);
                local materialClassName = TryGetProp(materialCls, 'ClassName');
			    if IsValidRecipeMaterial(materialClassName, targetitem, pc) == true then
				    checkMaterial[j] = true;
			    end
            end
		end
	end

    if IS_ALL_MATERIAL_CHECKED(checkMaterial, #itemList) == false then
        SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", recipeName, 0);
	    return;
    end

	local makingTime = TryGetProp(recipeCls, "RecipeTime");
	if makingTime == nil then
		makingTime = 15;
	end

	local buff = GetBuffByName(pc, 'ReduceCraftTime_Buff');	    
	if buff ~= nil then
		local buffLevel = GetBuffArg(buff);
		makingTime = makingTime * (1 - buffLevel * 0.05);
	end
	
	SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_START", recipeName, makingTime * makeCnt);
	
	local animName = recipeCls.Playanim;
	
	if idSpace == "Recipe_ItemCraft" then
		if recipeCls.SklName == "Alchemist_Tincturing" then
			animName = "#"..recipeCls.SklName;
		end
	end
	
	local result2 = DOTIMEACTION_R(pc, ScpArgMsg("ItemCraftProcess"), animName, makingTime * makeCnt);
	
	
	if result2 ~= 1 then
		SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", recipeName, 0);
		return;
	end
	
	if recipeProp.reqItemSize == 0 or makeCnt <= 0 then
		SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", argList[1], 0);
		return;
	end
	
    checkMaterial = {false, false, false, false, false}; -- itemList와 대응하여 이미 체크되었는지를 확인함
	for i = 0 , materialcnt - 1 do
		local item = recipeProp:GetReqItem(i);		
		local count = GET_INV_ITEM_COUNT_BY_TYPE(pc, item.type, recipeCls);
		if item.count * makeCnt > count then
			return;
		end
        
		for j = 1, #itemList do
			local targetitem = itemList[j]	
			if targetitem == nil then
				return;
			end

            if checkMaterial[j] == false then
                local materialCls = GetClassByType('Item', item.type);
                local materialClassName = TryGetProp(materialCls, 'ClassName');
			    if IsValidRecipeMaterial(materialClassName, targetitem, pc) == true then
                    checkMaterial[j] = true;
		        end
            end
        end
	end

     if IS_ALL_MATERIAL_CHECKED(checkMaterial, #itemList) == false then
        SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", recipeName, 0);
	    return;
    end
		
	local tx = TxBegin(pc);
	if tx == nil then
		SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", recipeName, 0);
		return;
	end

	local takecnt = 0;
	for i = 1, #itemList do
		local targetitem = itemList[i]
		if targetitem == nil or nil == tx then
			_TxRollBack(tx);
			result2 = 3;
		else
			local cnt = itemCntList[i]
			local maxStack = tonumber(targetitem.MaxStack);
			if nil == maxStack then
				_TxRollBack(tx);
				result2 = 3;
			else
				if maxStack > 1 then
					for j = 0 , materialcnt - 1 do
						local item = recipeProp:GetReqItem(j);
                        local materialCls = GetClassByType('Item', item.type);
                        local materialClassName = TryGetProp(materialCls, 'ClassName');
			            if IsValidRecipeMaterial(materialClassName, targetitem, pc) == true then
							local ret = TxTakeItemByObject(tx, targetitem, item.count * makeCnt, logType);
							
							if ret == -1 then
								_TxRollBack(tx);
							end

							takecnt = takecnt + 1
						end
					end
				else
					for j = 1, makeCnt do
						local ret = TxTakeItemByObject(tx, targetitem, 1, logType);

						if ret == -1 then
							_TxRollBack(tx);
						end

						takecnt = takecnt + 1
					end
				end
			end
		end	
	end

	if materialcnt ~= takecnt then
		_TxRollBack(tx);
	end
	
	local makeItemCls = GetClassByType("Item", recipeProp.makeItemID);
	local makeItemName = makeItemCls.ClassName
	
	if nil~= skillInfo and skillInfo.ClassName == "Alchemist_Tincturing" then
	    if skillInfo.LevelByDB > 1 then
	        makeItemName = makeItemName..skillInfo.LevelByDB
	    end
	end

	if nil ~= abil and recipeCls.SklName == "Alchemist_Tincturing" then
        if abil.Level > 1 then
		    makeItemName = makeItemName..abil.Level
		end
	end

	local itemID;
	local cmdIdx = -1;
    local makeItemCnt = recipeCls.TargetItemCnt;
	if makeItemCls.MaxStack > 1 then
		cmdIdx = TxGiveItem(tx, makeItemName, makeItemCnt * makeCnt, logType, 1, baseObj);
		itemID = TxGetGiveItemID(tx, cmdIdx);
		
		local recipeSkillName = TryGetProp(recipeCls, "SklName")
		
		if recipeSkillName ~= nil and recipeSkillName == "Alchemist_Tincturing" then
			makeCnt = makeItemCnt * makeCnt;
		end
	else
		for i = 1, makeCnt do
			cmdIdx = TxGiveItem(tx, makeItemName, makeItemCnt, logType, 1, baseObj);
			itemID = TxGetGiveItemID(tx, cmdIdx);
			local madeItem = GetInvItemByGuid(pc, itemID);

			if madeItem ~= nil then
				ShowItemBalloon(pc, "{@st43}", "ManfactureComplete!", "", madeItem, 5, 1, "reward_itembox");
			end

			if strArgList ~= nil and #strArgList == 2 then
				local customName = strArgList[1];
				local memo = strArgList[2];
			
				TxAppendProperty(tx, cmdIdx, "Maker", pc.Name);
				if customName ~= "" then
					
					if GetUTF8Len(customName) > RECIPE_ITEM_NAME_LEN or IsValidItemName(customName, 1) ~= 1 then
						_TxRollBack(tx);
						_TxEnd(tx);
						SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", recipeName, 0);
						return;
					end
					TxAppendProperty(tx, cmdIdx, "CustomName", customName);
				end
				if memo ~= "" then
					
					if GetUTF8Len(memo) > ITEM_MEMO_LEN or IsValidItemName(memo) ~= 1  then
						_TxRollBack(tx);
						_TxEnd(tx);
						SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", recipeName, 0);
						return;
					end
				
					TxAppendProperty(tx, cmdIdx, "Memo", memo);
				end
			end
		end
	end

	TxAddAchievePoint(tx, "ItemRecipe", 1);
	
	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
		SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_SUCCESS", recipeName, argList[2]);
	
		local customName = "None";
		local memo = "None"
		if strArgList ~= nil and #strArgList == 2 then
			customName = strArgList[1];
			memo = strArgList[2];
		end
		ItemCraftMongoLog(pc, logType, makeCnt, itemID, makeItemName, customName, memo);
        local madenItemCls = GetClass("Item", makeItemName);
        local madenItemClsID = TryGetProp(madenItemCls, "ClassID");
        local madenItemName = TryGetProp(madenItemCls, 'Name')
        if madenItemClsID ~= nil and madenItemName ~= nil then
            local makeItemClsJournal = TryGetProp(makeItemCls, 'Journal');
            local madenItemClsJournal = TryGetProp(madenItemCls, 'Journal');            
            if makeItemClsJournal ~= nil and makeItemClsJournal ~= 'FALSE' and madenItemClsJournal ~= nil and madenItemClsJournal  ~= 'FALSE' then
                if IsExistCraftInAdevntureBook(pc, madenItemClsID) == 'NO' then
                    ALARM_ADVENTURE_BOOK_NEW(pc, madenItemName);
                end
                AddAdventureBookCraftCount(pc, madenItemClsID, makeCnt);
            end
        end
	else
		SendAddOnMsg(pc, "JOURNAL_DETAIL_CRAFT_EXEC_FAIL", argList[1], 0);
	end	
end

function SCR_ITEM_APPRAISAL(pc)
	if IsRunningScript(pc, 'TX_ITEM_APPRAISAL') == 1 then
		SendSysMsg(pc, 'ItIsAlreadyInProcessAfter');
		return;
	end

	RunScript('TX_ITEM_APPRAISAL',pc);
end

function ITEM_APPRAISAL_DELETE_PROP(itemList)
	for i = 1, #itemList do
		local item = itemList[i]
		if item ~= nil then
			DelExProp(item, "APPRAISER_ADDPR")
			DelExProp(item, "APPRAISER_ADDSOKET")
			DelExProp(item, "APPRAISER_MaxPR")
		end
	end
end

-- 소켓
function GET_APPRAISAL_SOCKET_COUNT(item, soketCnt, skill)
	local addCnt = 0;

    local addRatio = TryGetProp(skill, 'Level');
    if addRatio == nil then
        addRatio = 0;
    else
        addRatio = addRatio * 2;    -- pc 감정사
    end
    
	for i = 1, soketCnt do
		local rand = IMCRandom(1, 100);
		if rand <= (20 + addRatio) then -- 20%(주석 다 깨졌어요.. 찾아보니까 처음부터 깨져있었어요...)
			addCnt = addCnt + 1;
		else
			return addCnt;
		end
	end

	return addCnt;
end

-- 포텐셜
function GET_APPRAISAL_PR_COUNT(item, itemPR, skill)
	local addCnt = 0;
    local sklRatio = TryGetProp(skill, 'Level');
    if sklRatio == nil then
        sklRatio = 0;
    end
    
    sklRatio = sklRatio * 300;
    
	for i = 1, itemPR do
	    local ratio = itemPR / (i + itemPR);
	    ratio = math.floor(ratio * 10000);
	    
	    if ratio < 1 then
	        ratio = 1;
	    elseif ratio > 9999 then
	        ratio = 9999;
        end
	    
	    if ratio >= IMCRandom(1, 10000) then
	        addCnt = addCnt + 1;
	    else
	        break;
	    end
	end
	
	if sklRatio >= IMCRandom(1, 10000) then
	    addCnt = addCnt + 1;
	end
	
	if addCnt > itemPR then
	    addCnt = itemPR;
	end
	
	return addCnt;
	
-- 기존 공식
--  for i = 1, itemPR do
--		local sum = (i+1) * i * 0.5
--		local maxRand = i;
--		local stop = false;
--
--		if sum == itemPR then
--			stop = true;
--		elseif sum > itemPR then
--			local diff = sum - itemPR;
--			maxRand = i - diff;
--			stop = true;
--		end
--        
--		local rand = IMCRandom(0, maxRand);
--        local sklRatio = TryGetProp(skill, 'Level');
--        if sklRatio ~= nil then
--            sklRatio = sklRatio * 5;
--            if rand < maxRand then
--                if sklRatio > IMCRandom(1, 100)then
--                    rand = rand + 1;
--                end
--            end
--        end
--		addCnt = addCnt + rand;
--
--		if true == stop then
--			break;
--		end
----	else -- pc 수식
----		addCnt = skill.Level;
----	end
--	end
--	return addCnt;
end

function TX_ITEM_APPRAISAL(pc, seller, itemList, price, skill)
	if IsPVPServer(pc) == 1 or (seller~= nil and IsPVPServer(seller) == 1) or (seller == nil and IS_VALID_POS_OPEN_UI(pc, "appraisal") ~= 1) then	
		return;
	end

	if itemList == nil then -- npc 상점의 경우 nil로 넘어옴. 이때는 npc 상점에서 선택한 다이얼로그 아이템 리스트를 가져오자
		itemList = GetDlgItemList(pc);
	end
	if itemList == nil then -- 그래도 없으면 리턴
		return;
	end

	-- 감정사 설정: npc or pc
	local sellerHandle = GetExProp(pc, 'APPRAISER_HANDLE');
	local targetHandle = GetHandle(pc);
	local npc = GetByHandle(pc, sellerHandle)
	if nil == npc and seller == nil then
		SendSysMsg(pc, "DataError");	
		return;
	end
	if seller ~= nil then -- 감정 상점 이용시 판매자가 npc 대신임
		npc = seller;
	end

	if seller == nil then -- npc가 있는 경우
		PlayAnimLocal(npc, pc, "LOOK");
        EnableControl(pc, 0, "APPRAISER");
		sleep(1500)
	end

	local totalPrice = 0;
	local needCnt = 0;
	local itemName = "";
	local prList = {};
	local socketList = {};
	local priceList = {};
	for i = 1, #itemList do
		local item = itemList[i]
		if item == nil then
			SendSysMsg(pc, "DataError");
			EnableControl(pc, 1, "APPRAISER");
			return;
		end
		

		-- 현재 기획엔 장비아이템만 가능하며, 감정 한번받은 아이템은 감정못함.
		if IS_NEED_APPRAISED_ITEM(item) == false  and IS_NEED_RANDOM_OPTION_ITEM(item) == false then 
			SendSysMsg(pc, "DataError");
			EnableControl(pc, 1, "APPRAISER");
            return;
		end

		local cnt = 1;
		if seller ~= nil then -- pc 상점인 경우 재료아이템 공식을 통해 개수를 가져옵니다
			itemName, cnt = ITEMBUFF_NEEDITEM_Appraiser_Apprise(seller, item);
			needCnt = needCnt + cnt;
		end
		local thisItemPrice = cnt * GET_APPRAISAL_PRICE(item, price);
		totalPrice = totalPrice + thisItemPrice;

		local itemCls = GetClass("Item", item.ClassName)
		if nil == itemCls then
			SendSysMsg(pc, "DataError");
			EnableControl(pc, 1, "APPRAISER");
			return;
		end
		
		priceList[#priceList + 1] = thisItemPrice;
	end

	-- 구매자의 돈 검사
	local pcMoney, cnt  = GetInvItemByName(pc, MONEY_NAME);
	if IsSameObject(seller, pc) == 0 and (pcMoney == nil or cnt < totalPrice or IsFixedItem(pcMoney) == 1) then
		SendSysMsg(pc, "NotEnoughMoney");
		EnableControl(pc, 1, "APPRAISER");
		return;
	end

	-- 상점 주인의 재료 아이템 검사
	if seller ~= nil then
		local needItem, sellerItemCnt = GetInvItemByName(seller, itemName);
		if sellerItemCnt < needCnt or IsFixedItem(needItem) == 1 then
			SendSysMsg(pc, "NotEnoughRecipe");
			EnableControl(pc, 1, "APPRAISER");
			return;
		end
	end

	-- pc 감정사인 경우 tx를 다른 함수에서 함. hardskill_appraisal.lua 참고
	if seller ~= nil then
		_TX_ITEM_APPRAISAL(pc, seller, itemList, price, skill, totalPrice, needCnt, itemName, prList, socketList, priceList);
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
	        prList[#prList + 1] = tempItem.MaxPR;
		    socketList[#socketList + 1] = tempItem.MaxSocket_COUNT;
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
    
    local tx = TxBegin(pc);
    -- (구) 감정 아이템 리스트 TX --
    if #appraisalItemList > 0 then
        for i = 1, #appraisalItemList do
            local appraisalItem = appraisalItemList[i]
            local addPR = GET_APPRAISAL_PR_COUNT(appraisalItem, prList[i], skill);
            local maxPR = prList[i] + addPR;
            local addSoket = GET_APPRAISAL_SOCKET_COUNT(appraisalItem, socketList[i], skill);
        
            -- 로그용임
            SetExProp(appraisalItem, "APPRAISER_MaxPR", maxPR)
            SetExProp(appraisalItem, "APPRAISER_ADDPR", addPR)
            SetExProp(appraisalItem, "APPRAISER_ADDSOKET", addSoket)
            SetExProp(appraisalItem, "APPRAISER_PRICE", priceList[i]);
        
            TxIsAppraisal(tx, appraisalItem, addPR, addSoket, maxPR);
        end
    end
    -- 아이템 랜덤 옵션 감정 아이템 리스트 TX --
    if #randomItemList > 0 then
        for i = 1, #randomItemList do
            local randomItem = randomItemList[i]
            for j = 1, optionCount[i] do
                local group = RandomOptionGroup[i][j];
                local option = RandomOption[i][j];
                local value = RandomOptionValue[i][j];

                TxSetIESProp(tx, randomItem, 'RandomOptionGroup_'..j, group);
               	TxSetIESProp(tx, randomItem, 'RandomOption_'..j, option);
               	TxSetIESProp(tx, randomItem, 'RandomOptionValue_'..j, value);

                -- 로그용
                SetExProp_Str(randomItem, 'RandomOptionGroup_'..j, group);
                SetExProp_Str(randomItem, 'RandomOption_'..j, option);
                SetExProp(randomItem, 'RandomOptionValue_'..j, value);
       	    end
       	    TxSetIESProp(tx, randomItem, "NeedRandomOption", 0);

            -- 로그용
            SetExProp(randomItem, 'RANDOM_OPTION_CNT', optionCount[i]);
        end
    end
    TxTakeItem(tx, MONEY_NAME, totalPrice, "Appraisal");
    
    local ret = TxCommit(tx);
    
	PlayAnimLocal(npc, pc, "STD");
	EnableControl(pc, 1, "APPRAISER");
	ITEM_APPRAISAL_DELETE_PROP(itemList);

	if ret ~= 'SUCCESS' then
		SendSysMsg(pc, "DataError");
		return;
	end
    
	ItemAppraisalMongoLog(pc, "NPC");

	SendAddOnMsg(pc, "SUCCESS_APPRALSAL", "", 0);
	SendAddOnMsg(pc, "UPDATE_ITEM_REPAIR", "", 0);

	local i = 1;
	local max = math.min(#itemList, 6);
	for i = 1, max do
		local item = itemList[i]
		if item ~= nil then
			ShowTargetItemBalloon(pc, sellerHandle, "{@st43}", "AppraisalSuccess", item, 3, delaySec);
		end
	end
end