-- item_option_create.lua

function CREATE_ITEM_SOCKET(item, mon, baseItem)
	-- Make Default Socket Base
	if item.ItemType == 'Equip' then
		
		-- 무조건 base소켓 만큼 소켓 뚫어서 드랍
		local socketCnt = item.BaseSocket;
		for i = 0 , socketCnt-1 do
			local randomsocket = DECIDE_SOCKET_TYPE();
			item["Socket_" .. i] = randomsocket;				--  모양 랜덤 결정
		end
	end
	
end

function CREATE_ITEM_LIFE_TIME(item)
	if item.ItemType == 'Equip' or item.ItemType == 'Consume' or item.ItemType == 'Etc' then
		if item.LifeTime > 0 then 
			local limitTime = GetAddDataFromCurrent(item.LifeTime)
			item.ItemLifeTime = limitTime;
		end
	end
end

function CALC_ITEM_LIFE_TIME(itemType)
	local item = GetClassByType("Item", itemType)
	if item.ItemType == 'Equip' or item.ItemType == 'Consume' or item.ItemType == 'Etc' then
		if item.LifeTime > 0 then
			local limitTime = GetAddDataFromCurrent(item.LifeTime)
			return limitTime;
		end
	end
	return "None";
end


function SET_ITEM_LIFE_TIME(pc, tx)
	local itemList = GetInvItemList(pc)

	local useTx = false;
	if tx == nil then
		tx = TxBegin(pc);
		useTx = true;	
	end

    local invItemList = GetInvItemList(pc);
    for i = 1, #invItemList do
        if invItemList[i].ItemType == "Equip" or invItemList[i].ItemType == "Consume" then
            --아이템의 LifeTime이 0보다 크면 기간제 아이템이라는 것.
			--아이템의 ItemLifeTimeOver가 0이면 아직 시간이 지나지 않은 아이템
			--위에 둘다 참인데
			--아이템의 ItemLifeTime 값이 None라면 아이템의 기간이 셋팅 안된거임. 현재 시간으로 셋팅을 해주자.

			local lifeTime = TryGetProp(invItemList[i], 'LifeTime');
			local itemLifeTimeOver = TryGetProp(invItemList[i], 'ItemLifeTimeOver');
			local itemLifeTime = TryGetProp(invItemList[i], 'ItemLifeTime');

			if lifeTime ~= nil and itemLifeTimeOver ~= nil and itemLifeTime ~= nil then

				if lifeTime > 0 and itemLifeTimeOver == 0 and itemLifeTime == "None" then
					local limitTime = GetAddDataFromCurrent(invItemList[i].LifeTime)
					TxSetIESProp(tx, invItemList[i], "ItemLifeTime", limitTime);
				end

			end
        end
    end

	if useTx == true then
		TxEnableInIntegrate(tx);
	    local ret = TxCommit(tx);
	end
end

-----------------------------------------------------------------
--------------------- 룬/보석 옵션 스크립트들 -------------------
-----------------------------------------------------------------

-- 종족관련 룬옵션
function SCR_RUNE_Widling(item, runeArg1, runeArg2)	
	
	--item.ADD_WIDLING = item.ADD_WIDLING + runeArg1 + IMCRandom(0, runeArg2);
end

function SCR_RUNE_Paramune(item, runeArg1, runeArg2)

	--item.ADD_PARAMUNE = item.ADD_PARAMUNE + runeArg1 + IMCRandom(0, runeArg2);
end

function SCR_RUNE_Forester(item, runeArg1, runeArg2)
	
	--item.ADD_FORESTER = item.ADD_FORESTER + runeArg1 + IMCRandom(0, runeArg2);
end

function SCR_RUNE_Velnias(item, runeArg1, runeArg2)

	--item.ADD_VELIAS = item.ADD_VELIAS + runeArg1 + IMCRandom(0, runeArg2);
end

-- 방어타입관련 룬옵션
function SCR_RUNE_Cloth(item, runeArg1, runeArg2)

	--item.ADD_CLOTH = item.ADD_CLOTH + runeArg1 + IMCRandom(0, runeArg2);
end

function SCR_RUNE_Leather(item, runeArg1, runeArg2)

	--item.ADD_LEATHER = item.ADD_LEATHER + runeArg1 + IMCRandom(0, runeArg2);
end

function SCR_RUNE_Chain(item, runeArg1, runeArg2)

	--item.ADD_CHAIN = item.ADD_CHAIN + runeArg1 + IMCRandom(0, runeArg2);
end

function SCR_RUNE_Iron(item, runeArg1, runeArg2)

	--item.ADD_IRON = item.ADD_IRON + runeArg1 + IMCRandom(0, runeArg2);
end

-- 사이즈관련 룬옵션
function SCR_RUNE_SmallSize(item, runeArg1, runeArg2)

	--item.ADD_SMALLSIZE = item.ADD_SMALLSIZE + runeArg1 + IMCRandom(0, runeArg2);
end

function SCR_RUNE_MiddleSize(item, runeArg1, runeArg2)

	--item.ADD_MIDDLESIZE = item.ADD_MIDDLESIZE + runeArg1 + IMCRandom(0, runeArg2);
end

function SCR_RUNE_LargeSize(item, runeArg1, runeArg2)

	--item.ADD_LARGESIZE = item.ADD_LARGESIZE + runeArg1 + IMCRandom(0, runeArg2);
end

function SCR_ITEM_TIME_OVER(pc)
    local itemCount = GetTimeOverItemCount(pc);
    if itemCount < 1 then
    	return;
    end

	local tx = TxBegin(pc);	
	if tx == nil then
		return;
	end

    local needInvalidateItem = {};
	for i = 0, itemCount - 1 do
		local itemObj = GetTimeOverItemByIndex(pc, i);
		if itemObj ~= nil then
			if itemObj.ClassName == 'Premium_dungeoncount_Event' and IsFixedItem(itemObj) ~= 1 then
				TxTakeItemByObject(tx, itemObj, 1, "ItemLifeTimeOver");                
			else
				TxSetIESProp(tx, itemObj, "ItemLifeTimeOver", 1);
                needInvalidateItem[i] = true;
			end
		end
	end

	local ret = TxCommit(tx);

	if ret == "SUCCESS" then
		for i = 0, itemCount - 1 do
			if needInvalidateItem[i] == true then
                local itemObj = GetTimeOverItemByIndex(pc, i);
				InvalidateItem(itemObj);
			end
		end
		ClearTimeOverItemList(pc)
		InvalidateStates(pc);
	end
end


function CREATE_ITEM_OPTION_COPY(item, baseItem)
    --trade--
--	item.BelongingCount = baseItem.BelongingCount
	
	--reinforce--
	item.Reinforce_2 = baseItem.Reinforce_2
	
	--transcend--
	item.Transcend = baseItem.Transcend;
	item.Transcend_MatCount = baseItem.Transcend_MatCount;
	item.Transcend_SucessCount = baseItem.Transcend_SucessCount;
	
	--duration -- 	
	item.Dur = baseItem.Dur
	
	--potential--
	item.PR = baseItem.PR;
	
	--socket--
	item.Socket_Match = baseItem.Socket_Match
	
	for i = 0 , 9 do
		item['Socket_'..i] = baseItem['Socket_'..i]
		item['SocketItemExp_'..i] = baseItem['SocketItemExp_'..i]
		item['Socket_Equip_'..i] = baseItem['Socket_Equip_'..i]
		item['Socket_JamLv_'..i] = baseItem['Socket_JamLv_'..i]
	end
	
	--IsAwaken--
	item.IsAwaken = baseItem.IsAwaken;
	item.HiddenProp = baseItem.HiddenProp;
	item.HiddenPropValue = baseItem.HiddenPropValue;
	
end

