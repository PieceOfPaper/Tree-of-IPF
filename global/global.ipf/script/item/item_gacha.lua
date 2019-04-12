function SCR_ITEM_GACHA_TP(pc, rewGroup, gachaClassName, gachacnt, gachaLog, gachaType)

    local rewardID = 'reward_tp'
    local aObj = GetAccountObj(pc)

	if aObj == nil then
		return
	end

	if nil == rewGroup then
		return;
	end
	
	if gachaClassName == nil then
	    return;
	end

	local reason = 'HAIR_GACHA' -- 보상아이템 줄 때 남는 로그(이유)

	local tx = TxBegin(pc);	
	TxEnableInIntegrateIndun(tx);
	if gachaClassName == "Gacha_TP_100" then
        TxTakeItem(tx, gachaClassName, 100, gachaLog, 99999); -- 1 옆에는 없어질때 남는 로그
		reason = gachaLog
	elseif gachaClassName == 'GACHA_HAIRACC_BOUNS01' or gachaClassName == 'GACHA_HAIRACC_BOUNS02' or gachaClassName == 'GACHA_HAIRACC_BOUNS03' or gachaClassName == 'GACHA_HAIRACC_BOUNS04' or gachaClassName == 'GACHA_HAIRACC_BOUNS05' then
		TxSetIESProp(tx, aObj, 'GACHA_HAIRACC_BOUNS', aObj.GACHA_HAIRACC_BOUNS + 1)
		reason = 'GACHA_HAIRACC_BOUNS'
	elseif gachaClassName == 'GACHA_TP_BOUNS01' or gachaClassName == 'GACHA_TP_BOUNS02' or gachaClassName == 'GACHA_TP_BOUNS03' or gachaClassName == 'GACHA_TP_BOUNS04' or gachaClassName == 'GACHA_TP_BOUNS05' then
		TxSetIESProp(tx, aObj, 'GACHA_TP_BOUNS', aObj.GACHA_TP_BOUNS + 1)
		reason = 'GACHA_TP_BOUNS'
	else
        TxTakeItem(tx, gachaClassName, 1, gachaLog, 99999); -- 1 옆에는 없어질때 남는 로그
		reason = gachaLog
	end

	local sendrewardlist = {}
	local sendrewardcntlist = {}

	for i = 1, gachacnt do 
		local reward, rewardCount, rewardGroup = GET_HAIR_GACHA_REWARD(rewGroup, rewardID, gachaClassName)
		if reward == nil then		
			TxRollBack(tx)
			return;
		end

		TxGiveItem(tx, reward, rewardCount, reason, 0, nil, 99999);		
		sendrewardlist[#sendrewardlist+1] = reward		
		sendrewardcntlist[#sendrewardcntlist+1] = rewardCount		
	end

	-- override strat
	if gachaClassName == "Gacha_TP_001" then
		TxSetIESProp(tx, aObj, 'GACHA_TP_COUNT', aObj.GACHA_TP_COUNT + 1)
	elseif gachaClassName == "Gacha_TP_010" then
		TxSetIESProp(tx, aObj, 'GACHA_TP_COUNT', aObj.GACHA_TP_COUNT + 10)
	elseif gachaClassName == "Gacha_HairAcc_001" then
		TxSetIESProp(tx, aObj, 'GACHA_HAIRACC_COUNT', aObj.GACHA_HAIRACC_COUNT + 1)
	elseif gachaClassName == "Gacha_HairAcc_010" then
		TxSetIESProp(tx, aObj, 'GACHA_HAIRACC_COUNT', aObj.GACHA_HAIRACC_COUNT + 10)
	end
	-- override end

	local ret = TxCommit(tx);

	if ret == "SUCCESS" then	

		--break
		EnableControl(pc, 0, "ITEM_GACHA_TP");
        SetDirectionByAngle(pc, 90)

		local nowhp = pc.HP
		local sleeptime = 1
		
		if (gachacnt == 1 and gachaType == "hair") or (gachacnt == 1 and gachaType == "costume") then
			sleeptime = 105
			PlayAnim(pc, "gacha", 1)
		elseif (gachacnt == 11 and gachaType == "hair") or (gachacnt == 11 and gachaType == "costume") then -- 10 연차 애니 여기임
			sleeptime = 120
			PlayAnim(pc, "gacha2", 1)
		else
			sleeptime = 30
			PlayAnim(pc, "gacha_box", 1) -- 랜덤박스
		end

		for i = 1 , sleeptime do
			sleep(100)
			if nowhp ~= pc.HP then -- 애니 하다가 몹한테 맞으면 스킵한다. 전투로직에 밝으신 분 이거 좀 더 좋은 로직 없으려나?
				break;
			end
		end
		PlayAnim(pc, "std", 1)
		EnableControl(pc, 1, "ITEM_GACHA_TP");
		--break end
        
		
		if (gachacnt == 1 and gachaType == "hair") or (gachacnt == 1 and gachaType == "costume") then
			local cntandgrade = GET_GACHA_GRADE_BY_ITEMNAME(sendrewardlist[1],rewGroup)*1000 + sendrewardcntlist[1]
			SendAddOnMsg(pc, "HAIR_GACHA_POPUP", sendrewardlist[1], cntandgrade);

		elseif (gachacnt == 11 and gachaType == "hair") or (gachacnt == 11 and gachaType == "costume") then
			local rewardstring = "";
			for i = 1, #sendrewardlist do			
				rewardstring = rewardstring .. sendrewardlist[i] .. "&" .. tostring( (GET_GACHA_GRADE_BY_ITEMNAME(sendrewardlist[i],rewGroup)*1000) + sendrewardcntlist[i] ) .. "&"
			end

			SendAddOnMsg(pc, "HAIR_GACHA_POPUP_10", rewardstring, 0);
        elseif gachaType == "rbox" and gachacnt == 1  then

			local cntandgrade = GET_GACHA_GRADE_BY_ITEMNAME(sendrewardlist[1],rewGroup)*1000 + sendrewardcntlist[1]
			SendAddOnMsg(pc, "RBOX_GACHA_POPUP", sendrewardlist[1], cntandgrade);
			
			local ALLMSG = {'Recipe_315_Box'}
			
			for i = 1, table.getn(ALLMSG) do
			    if ALLMSG[i] == sendrewardlist[1] then
			        local itemName = GetClassString('Item', sendrewardlist[1], 'Name')
			        ToAll(ScpArgMsg("GACHA_SITEM_GET_ALLMSG","PC",GetTeamName(pc),"ITEMNAME", itemName))
			        break;
			    end
			end
		elseif gachaType == "rbox" then
		    local ALLMSG = {'Recipe_315_Box'}
			local rewardstring = "";
			local itemName;
			for i = 1, #sendrewardlist do
				rewardstring = rewardstring .. sendrewardlist[i] .. "&" .. tostring( (GET_GACHA_GRADE_BY_ITEMNAME(sendrewardlist[i], rewGroup)*1000) + sendrewardcntlist[i] ) .. "&"
				
				for j = 1, table.getn(ALLMSG) do
				    if ALLMSG[j] == sendrewardlist[i] then
    			        itemName = GetClassString('Item', sendrewardlist[i], 'Name')
    			        break;
    			    end
				end
			end

			SendAddOnMsg(pc, "RBOX_GACHA_POPUP_10", rewardstring, 0);
			
			if itemName ~= nil then
    			ToAll(ScpArgMsg("GACHA_SITEM_GET_ALLMSG","PC",GetTeamName(pc),"ITEMNAME", itemName))
			end
		end
	else
		SendSysMsg(pc, "TryLater");
	end

	sleep(2000) -- 가챠 연속 사용시의 UI 처리를 위해 5초 정도 있다 리턴. 

end