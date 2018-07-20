--- item_gacha.lua
--[[
큐브 뽑기 시스템의 서버측 처리 부분.
UI창의 gacha_cube.lua 와 연동
]]--
-- 실버 비용 지불하기 전에 실버량 확인하기
function CHECK_PC_MONEY_FOR_PAY(pc, Price)
	if Price == 0 then
		return 1;
	end

	local pcMoney, cnt = GetInvItemByName(pc, MONEY_NAME);
	if pcMoney == nil or cnt < Price then
		SendSysMsg(pc, "NotEnoughMoney");	-- 돈이 부족한 경우, 메세지.
		return 0;
	end
	return 1;
end

-- 큐브 첫번째 뽑기일때의 Tx 및 소비템 처리 후 작동 
-- Item.xml의 CT_Consumable은 TX로 설정하고 CT_Script에 이 함수를 설정해야 됌.
function SCR_FIRST_USE_GHACHA_CUBE(pc, argObj, rewardGroupClsName, arg1, arg2, clsId)
	local cubeCls = GetClassByType("Item", clsId);
	if cubeCls == nil then
		return;
	end
	local enableDuplicate = TryGetProp(cubeCls, "CubeDuplicate")
	if enableDuplicate == "NO" then
		enableDuplicate = 0
	else -- YES 이거나 프로퍼티가 없는 경우 default 값은 중복 허용
		enableDuplicate = 1
	end	

	-- 시작시 cmd 도 시작
	local check = StartGachaCube(pc, clsId, enableDuplicate);

	-- 이미 cmd가 있다면 실패
	if check == 0 then
		return;
	end

	-- 뽑기(첫번째)
    SendAddOnMsg(pc, 'CLOSE_GACHA_CUBE', 'NO'); -- 이전에 있는 UI 있으면 닫아야 함
	SCR_ITEM_GACHA(pc, rewardGroupClsName, clsId, 1, enableDuplicate)
end

function CHECK_GACHA_DUPLICATE(pc, bEnableDuplicate, itemName)
	if bEnableDuplicate == 1 then
		return true;
	end
	if IsDuplicateReward(pc, itemName) == 1 then
		return false;
	end
	return true;
end

function CLEAR_GACHA_COMMAND(pc, isFirst)
	if isFirst ~= nil then -- UI가 한 번도 안뜬 상태에서 그냥 종료하면 커맨드가 남아서 다음부터 큐브를 사용할 수가 없다.
		ClearGachaCmd(pc);
	end
end

-- 뽑기 기능 함수 
-- (첫번째 뽑기에는  Group 인자가 nil이 아니다.)
-- 참고 : function GIVE_REWARD(self, group, giveway, tx)
function SCR_ITEM_GACHA(pc, Group, cubeID, btnVisible, bEnableDuplicate, reopenCount)
    local rewardID = 'reward_freedungeon'
    
    if reopenCount == nil then
        reopenCount = -1;
    end
    if cubeID == 642501 then
        rewardID = 'reward_tp'
    end
    
    local rewardList = {};
    local rewardCnt = {};
    local ratioList = {};
	local rewardGroupName = {};
    local listIndex = 0;
    local totalRatio = 0;										-- 처음에는 비용이 0이다.
    local clslist, cnt = GetClassList(rewardID);	-- 보상 리스트 얻어온다. 
	local totalPrice = 0;

	local rewGroup = nil;
	local cubeItem = GetClassByType("Item", cubeID);
	if nil ~= Group then	-- 무료 뽑기	
		rewGroup = Group;
	else					-- 유료 뽑기 (Group이 nil이다.)
		rewGroup = TryGetProp(cubeItem, "StringArg");		-- 보상그룹 알아내기
		totalPrice = TryGetProp(cubeItem, "NumberArg1");	-- 비용 알아내기		
	end
		
	if nil == rewGroup then
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end
	
	if IS_SEASON_SERVER(pc) == 'YES' then
	    totalPrice = math.floor(totalPrice/2)
	end

	if reopenCount == 1 then
	
	    local discountRatio = TryGetProp(cubeItem, 'ReopenDiscountRatio')
	    if discountRatio ~= nil and discountRatio > 0 then
    	    discountRatio = 1 -  (discountRatio / 100)
	    else
	        discountRatio = 1;
	    end
	    
	    totalPrice = SyncFloor(totalPrice * discountRatio)
	    
	end
				
	if CHECK_PC_MONEY_FOR_PAY(pc, totalPrice) == 0 then 
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end

    for i = 0, cnt do	-- 보상리스트에서 확률로 보상 계산
        local rewardcls = GetClassByIndexFromList(clslist, i);			
        if TryGetProp(rewardcls, "Group") == rewGroup and CHECK_GACHA_DUPLICATE(pc, bEnableDuplicate, rewardcls.ItemName ) == true then
            rewardList[listIndex] = rewardcls.ItemName;
			local cls = GetClass("Item", rewardcls.ItemName);
			if nil ~= cls then
				rewardGroupName[listIndex] = cls.GroupName;
			else
				rewardGroupName[listIndex] = "None";
			end
            rewardCnt[listIndex] = rewardcls.Count;
            ratioList[listIndex] = rewardcls.Ratio;
            listIndex = listIndex + 1;
            totalRatio = totalRatio + rewardcls.Ratio;	-- 전체 확률
        end
    end
    		
    -- get reward
	if listIndex <= 0 then
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end
    local reward = nil;	
    local rewardCount;
    local rewardGroup;
	local checkTime = imcTime.GetAppTime() + 1;
    while reward == nil do
		if checkTime < imcTime.GetAppTime() then
			CLEAR_GACHA_COMMAND(pc, Group);
			return;
		end
    	reward = nil;
    	local result = IMCRandom(1, totalRatio)	-- 보상 뽑기용 랜덤수
	    for i = 0, #ratioList do
	        if result <= ratioList[i] then
				reward = rewardList[i]
				rewardCount = rewardCnt[i]
				rewardGroup = rewardGroupName[i]
				break;
	        else
	            ratioList[i+1] = ratioList[i+1] + ratioList[i];
	        end
	    end

	    if reward ~= nil then
			break;
		end
    end    

    -- give reward
    if reward ~= nil then
    	--Tx 구간
		local tx = TxBegin(pc);	
		TxEnableInIntegrateIndun(tx);
					
		if totalPrice > 0 then
			TxTakeItem(tx, MONEY_NAME, totalPrice, "GACHA_CUBE", 0, cubeID);
		end
		TxGiveItem(tx, reward, rewardCount, 'GACHA_CUBE');
		local ret = TxCommit(tx);
		--Tx 구간 끝

		if ret == "SUCCESS" then
			if nil ~= Group then
                if TryGetProp(cubeItem, 'AllowReopen') == 'NO' then
                    ClearGachaCmd(pc);
                    btnVisible = 0;
                end
				local sucScp = string.format("GACHA_CUBE_SUCEECD(\'%s\', \'%s\', \'%d\',%d)", cubeID, reward, btnVisible, reopenCount);
				ExecClientScp(pc, sucScp);		--성공여부를 클라이언트에 알린다.	(창 만들기)

			else
			    local sucScp = string.format("GACHA_CUBE_SUCEECD_EX(\'%s\', \'%s\', \'%d\',%d)", cubeID, reward, btnVisible, reopenCount);
				ExecClientScp(pc, sucScp);		--성공여부를 클라이언트에 알린다.	(창 요소만 바꾸기)							
				UpdateCubeCmd(pc, reward); -- 큐브의 뽑기 횟수를 업데이트하기 위한 함수
			end		

			-- update reward list
			if bEnableDuplicate == 0 then
				UpdateCubeReward(pc, reward)
			end			
		end
    end
end



------------------------- 헤어악세사리 및 랜덤박스 로직 -------------------------
function SCR_USE_GHACHA_TPCUBE(pc, gachaClassName)
  
	if pc == nil then
		return
	end

	local ride = GetVehicleState(pc);
	if 1 == ride then
		SendSysMsg(pc, "DonUseItemOnRIde");
		return;
	end
	if IsBuffApplied(pc, 'SwellLeftArm_Buff') == 'YES' then
		SendSysMsg(pc, "DonUseItemOnRIde");
		return;
	end

	if IsBuffApplied(pc, 'SwellRightArm_Buff') == 'YES' then
		SendSysMsg(pc, "DonUseItemOnRIde");
		return;
	end

	local gachaClass = GetClass("GachaDetail", gachaClassName)
	if gachaClass == nil then
		return;
	end

	local haveCount = GetInvItemCount(pc, gachaClassName)
	if haveCount == nil then
		return;
	end

	if haveCount < 1 then
	    return
	end

--양재성씨가 고쳐줘야함. 눈부신 큐브 조각
	if gachaClassName == "Gacha_TP_100"then
		if haveCount < 100 then
			SendSysMsg(pc, "NeedItemCount",0,"Cnt","100");
			return
		end
	end
--여기까지	
    local now = pc.NowWeight	
	if pc.MaxWeight <= now then
		SendSysMsg(pc, "MAXWEIGHTMSG");
	    return;
	end
	

	if 1 == GetExProp(pc, "DOING_HAIR_GACHA") then
		SendSysMsg(pc, "Auto_aJig_SayongHal_Su_eopSeupNiDa");
		return
	end
	
	SetExProp(pc, "DOING_HAIR_GACHA", 1)
    	
	local rewardGroupClsName = gachaClass.RewardGroup;
	SCR_ITEM_GACHA_TP(pc, rewardGroupClsName, gachaClassName, gachaClass.Count, gachaClass.GachaLog, gachaClass.GachaType)
	
	SetExProp(pc, "DOING_HAIR_GACHA", 0)
	
end

function GET_HAIR_GACHA_REWARD(rewGroup, rewardID)

	local rewardList = {};
    local rewardCnt = {};
    local ratioList = {};
	local rewardGroupName = {};
    local listIndex = 0;
    local totalRatio = 0;										-- 처음에는 비용이 0이다.
    local clslist, cnt = GetClassList(rewardID);	-- 보상 리스트 얻어온다. 	

    for i = 0, cnt - 1 do	-- 보상리스트에서 확률로 보상 계산
        local rewardcls = GetClassByIndexFromList(clslist, i);			

        if TryGetProp(rewardcls, "Group") == rewGroup then
            rewardList[listIndex] = rewardcls.ItemName;
			local cls = GetClass("Item", rewardcls.ItemName);
			if nil ~= cls then
				rewardGroupName[listIndex] = cls.GroupName;
			else
				rewardGroupName[listIndex] = "None";
			end
            rewardCnt[listIndex] = rewardcls.Count;
            ratioList[listIndex] = rewardcls.Ratio;
            listIndex = listIndex + 1;
            totalRatio = totalRatio + rewardcls.Ratio;	-- 전체 확률
        end
    end
    		
    -- get reward
    local reward = nil;	
    local rewardCount;
    local rewardGroup;
    while reward == nil do
    	reward = nil;
    	local result = IMCRandom(1, totalRatio)	-- 보상 뽑기용 랜덤수
    	local tmpList = ratioList
		
	    for i = 0, #tmpList do			
			
	        if result <= tmpList[i] then
				reward = rewardList[i]
				rewardCount = rewardCnt[i]
				rewardGroup = rewardGroupName[i]
				break;
	        else
	            tmpList[i+1] = tmpList[i+1] + tmpList[i];
	        end
	    end

	    if reward ~= nil then
	    	break;
	    end
    end    

	return reward, rewardCount, rewardGroup;

end


function GET_GACHA_GRADE_BY_ITEMNAME(itemname, rewardGroup)

    local gachaCls = GetClass('Item', itemname);
	local grade = 3;
	local rewardlist, rewardlistcnt =  GetClassList("reward_tp")
	for j = 0 , rewardlistcnt - 1 do
		local rewardcls = GetClassByIndexFromList(rewardlist, j);
		if rewardcls.ItemName == itemname and (rewardGroup ~= nil and rewardGroup == rewardcls.Group) then

			if rewardcls.Rank == "A" then
				grade = 1
			elseif rewardcls.Rank == "B" then
				grade = 2
			elseif rewardcls.Rank == "C" then
				grade = 3
			end

			break;
		end
	end

	return grade;

end


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
	else
        TxTakeItem(tx, gachaClassName, 1, gachaLog, 99999); -- 1 옆에는 없어질때 남는 로그
		reason = gachaLog
	end

	local sendrewardlist = {}
	local sendrewardcntlist = {}

	for i = 1, gachacnt do 
		local reward, rewardCount, rewardGroup = GET_HAIR_GACHA_REWARD(rewGroup, rewardID)
		if reward == nil then		
			TxRollBack(tx)
			return;
		end

		TxGiveItem(tx, reward, rewardCount, reason, 0, nil, 99999);		
		sendrewardlist[#sendrewardlist+1] = reward		
		sendrewardcntlist[#sendrewardcntlist+1] = rewardCount		
	end

--	if gachaClassName == "Gacha_TP_001" then
--		TxGiveItem(tx, "Gacha_TP_100", 1, 'HAIR_GACHA', 0, nil, 99999);	-- 100개 모으면 사용 가능한 가챠 템 지급
--	elseif gachaClassName == "Gacha_TP_010" then
--		TxGiveItem(tx, "Gacha_TP_100", 11, 'HAIR_GACHA', 0, nil, 99999);
--	end

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


-- 큐브 첫번째 뽑기일때의 Tx 및 소비템 처리 후 작동 
-- Item.xml의 CT_Consumable은 TX로 설정하고 CT_Script에 이 함수를 설정해야 됌.
function SCR_FIRST_USE_GHACHA_CUBE_ID_WHITETREES(pc, argObj, rewardGroupClsName, arg1, arg2, clsId)
	local cubeCls = GetClassByType("Item", clsId);
	if cubeCls == nil then
		return;
	end
	local enableDuplicate = TryGetProp(cubeCls, "CubeDuplicate")
	if enableDuplicate == "NO" then
		enableDuplicate = 0
	else -- YES 이거나 프로퍼티가 없는 경우 default 값은 중복 허용
		enableDuplicate = 1
	end	

	-- 시작시 cmd 도 시작
	local check = StartGachaCube(pc, clsId, enableDuplicate);

	-- 이미 cmd가 있다면 실패
	if check == 0 then
		return;
	end

	-- 뽑기(첫번째)
    SendAddOnMsg(pc, 'CLOSE_GACHA_CUBE', 'NO'); -- 이전에 있는 UI 있으면 닫아야 함
	SCR_ITEM_GACHA_ID_WHITETREES(pc, rewardGroupClsName, clsId, 1, enableDuplicate)
end

-- 뽑기 기능 함수 
-- (첫번째 뽑기에는  Group 인자가 nil이 아니다.)
-- 참고 : function GIVE_REWARD(self, group, giveway, tx)
function SCR_ITEM_GACHA_ID_WHITETREES(pc, Group, cubeID, btnVisible, bEnableDuplicate)
    local rewardID = 'reward_freedungeon'
    local rewardList = {};
    local rewardCnt = {};
    local ratioList = {};
    local expProp = {};
	local rewardGroupName = {};
    local listIndex = 0;
    local totalRatio = 0;										-- o=¿¡´ º???0L´?
    local clslist, cnt = GetClassList(rewardID);	-- º¸≫??½º? ¾??´? 
	local totalPrice = 0;
	local rewGroup = nil;
	local cubeItem = GetClassByType("Item", cubeID);
--	local gradeTotalRatio = 10000
--	local cRatio = 8500
--	local bRatio = 9500
--	local rand = IMCRandom(1, gradeTotalRatio);
	
	-- 가챠 Grade 우선 확률 계산 시작 --
	local basicGradeList = {
	                        { "C", 7730    },
    	                    { "B", 1000    },
	                        { "A", 1200    },
	                        { "S", 50      },
	                        { "LegCard", 20}
	                       };
    
    local gradeList = { };
    local totalGradeRatio = 0;
    for i = 1, #basicGradeList do
        local gradeTemp = basicGradeList[i];
        local gradeName = gradeTemp[1]
        local gradeRatio = totalGradeRatio + gradeTemp[2]
        totalGradeRatio = totalGradeRatio + gradeTemp[2];
        gradeList[#gradeList + 1] = { gradeName, gradeRatio };
    end

    local grade = 'C';
    local gradeRandom = IMCRandom(1, totalGradeRatio);

    for i = 1, #gradeList do
        local gradeTemp = gradeList[i];
        if gradeTemp[2] >= gradeRandom then
            grade = gradeTemp[1];
            break;
        end
    end
	-- 가챠 Grade 우선 확률 계산 끝 --
	

    if nil ~= Group then
		rewGroup = Group;
	else
		local cubeItem = GetClassByType("Item", cubeID);
		rewGroup = TryGetProp(cubeItem, "StringArg");
	end

	if nil ~= Group then	-- 무료 뽑기	
		rewGroup = Group;
	else					-- 유료 뽑기 (Group이 nil이다.)
		rewGroup = TryGetProp(cubeItem, "StringArg");
		totalPrice = TryGetProp(cubeItem, "NumberArg1");
	end

	if nil == rewGroup then
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end
    
	if IS_SEASON_SERVER(pc) == 'YES' then
	    totalPrice = math.floor(totalPrice/2)
	end
    
	if CHECK_PC_MONEY_FOR_PAY(pc, totalPrice) == 0 then 
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end
    
    for i = 0, cnt - 1 do	-- 보상리스트에서 확률로 보상 계산
        local rewardcls = GetClassByIndexFromList(clslist, i);
        if TryGetProp(rewardcls, "Group") == rewGroup and TryGetProp(rewardcls, "Grade") == grade and CHECK_GACHA_DUPLICATE(pc, bEnableDuplicate, rewardcls.ItemName ) == true then
            rewardList[listIndex] = rewardcls.ItemName;
			local cls = GetClass("Item", rewardcls.ItemName);
			if nil ~= cls then
				rewardGroupName[listIndex] = cls.GroupName;
			else
				rewardGroupName[listIndex] = "None";
			end
            rewardCnt[listIndex] = rewardcls.Count;
            ratioList[listIndex] = rewardcls.Ratio;
            listIndex = listIndex + 1;
            totalRatio = totalRatio + rewardcls.Ratio;	-- 전체 확률
        end
    end

    -- get reward
	if listIndex <= 0 then
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end
	
    local reward = nil;	
    local rewardCount;
    local rewardGroup;
	local checkTime = imcTime.GetAppTime() + 1;
    while reward == nil do
		if checkTime < imcTime.GetAppTime() then
			CLEAR_GACHA_COMMAND(pc, Group);
			return;
		end
    	reward = nil;
    	local result = IMCRandom(1, totalRatio)	-- 보상 뽑기용 랜덤수
	    for i = 0, #ratioList do
	        if result <= ratioList[i] then
				reward = rewardList[i]
				rewardCount = rewardCnt[i]
				rewardGroup = rewardGroupName[i]
				break;
	        else
	            ratioList[i+1] = ratioList[i+1] + ratioList[i];
	        end
	    end

	    if reward ~= nil then
			break;
		end
    end   

    -- give reward
    if reward ~= nil then
    	--Tx 구간
		local tx = TxBegin(pc);	
		TxEnableInIntegrateIndun(tx);

		if totalPrice > 0 then
			TxTakeItem(tx, MONEY_NAME, totalPrice, "GACHA_CUBE", 0, cubeID);
		end
		TxGiveItem(tx, reward, rewardCount, 'GACHA_CUBE');
		local ret = TxCommit(tx);
		--Tx 구간 끝

		if ret == "SUCCESS" then
			if nil ~= Group then
                if TryGetProp(cubeItem, 'AllowReopen') == 'NO' then
                    ClearGachaCmd(pc);
                    btnVisible = 0;
                end
				local sucScp = string.format("GACHA_CUBE_SUCEECD(\'%s\', \'%s\', \'%d\')", cubeID, reward, btnVisible);
				ExecClientScp(pc, sucScp);		--성공여부를 클라이언트에 알린다.	(창 만들기)

			else						
				local sucScp = string.format("GACHA_CUBE_SUCEECD_EX(\'%s\', \'%s\', \'%d\')", cubeID, reward, btnVisible);
				ExecClientScp(pc, sucScp);		--성공여부를 클라이언트에 알린다.	(창 요소만 바꾸기)							
				UpdateCubeCmd(pc, reward); -- 큐브의 뽑기 횟수를 업데이트하기 위한 함수
			end		

			-- update reward list
			if bEnableDuplicate == 0 then
				UpdateCubeReward(pc, reward)
			end			
		end
    end
end


function SCR_FIRST_USE_GHACHA_CUBE_CHALLENGE(pc, argObj, rewardGroupClsName, arg1, arg2, clsId)
	local cubeCls = GetClassByType("Item", clsId);
	if cubeCls == nil then
		return;
	end
	local enableDuplicate = TryGetProp(cubeCls, "CubeDuplicate")
	if enableDuplicate == "NO" then
		enableDuplicate = 0
	else -- YES 이거나 프로퍼티가 없는 경우 default 값은 중복 허용
		enableDuplicate = 1
	end	

	-- 시작시 cmd 도 시작
	local check = StartGachaCube(pc, clsId, enableDuplicate);

	-- 이미 cmd가 있다면 실패
	if check == 0 then
		return;
	end

	-- 뽑기(첫번째)
    SendAddOnMsg(pc, 'CLOSE_GACHA_CUBE', 'NO'); -- 이전에 있는 UI 있으면 닫아야 함
	SCR_ITEM_GACHA_CHALLENGE(pc, rewardGroupClsName, clsId, 1, enableDuplicate)
end

-- 뽑기 기능 함수 
-- (첫번째 뽑기에는  Group 인자가 nil이 아니다.)
-- 참고 : function GIVE_REWARD(self, group, giveway, tx)
function SCR_ITEM_GACHA_CHALLENGE(pc, Group, cubeID, btnVisible, bEnableDuplicate)
    local rewardID = 'reward_freedungeon'
    local rewardList = {};
    local rewardCnt = {};
    local ratioList = {};
    local expProp = {};
	local rewardGroupName = {};
    local listIndex = 0;
    local totalRatio = 0;										-- o=¿¡´ º???0L´?
    local clslist, cnt = GetClassList(rewardID);	-- º¸≫??½º? ¾??´? 
	local totalPrice = 0;
	local rewGroup = nil;
	local cubeItem = GetClassByType("Item", cubeID);
--	local gradeTotalRatio = 10000
--	local cRatio = 8500
--	local bRatio = 9500
--	local rand = IMCRandom(1, gradeTotalRatio);
	
	-- 가챠 Grade 우선 확률 계산 시작 --
	local basicGradeList = {
	                        { "C", 7000 },
    	                    { "B", 2000 },
	                        { "A", 1000 }
	                       };
    
    local gradeList = { };
    local totalGradeRatio = 0;
    for i = 1, #basicGradeList do
        local gradeTemp = basicGradeList[i];
        local gradeName = gradeTemp[1]
        local gradeRatio = totalGradeRatio + gradeTemp[2]
        totalGradeRatio = totalGradeRatio + gradeTemp[2];
        gradeList[#gradeList + 1] = { gradeName, gradeRatio };
    end

    local grade = 'C';
    local gradeRandom = IMCRandom(1, totalGradeRatio);

    for i = 1, #gradeList do
        local gradeTemp = gradeList[i];
        if gradeTemp[2] >= gradeRandom then
            grade = gradeTemp[1];
            break;
        end
    end
	-- 가챠 Grade 우선 확률 계산 끝 --
	

    if nil ~= Group then
		rewGroup = Group;
	else
		local cubeItem = GetClassByType("Item", cubeID);
		rewGroup = TryGetProp(cubeItem, "StringArg");
	end

	if nil ~= Group then	-- 무료 뽑기	
		rewGroup = Group;
	else					-- 유료 뽑기 (Group이 nil이다.)
		rewGroup = TryGetProp(cubeItem, "StringArg");
		totalPrice = TryGetProp(cubeItem, "NumberArg1");
	end

	if nil == rewGroup then
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end
    
	if IS_SEASON_SERVER(pc) == 'YES' then
	    totalPrice = math.floor(totalPrice/2)
	end
    
	if CHECK_PC_MONEY_FOR_PAY(pc, totalPrice) == 0 then 
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end
    
    for i = 0, cnt - 1 do	-- 보상리스트에서 확률로 보상 계산
        local rewardcls = GetClassByIndexFromList(clslist, i);
        if TryGetProp(rewardcls, "Group") == rewGroup and TryGetProp(rewardcls, "Grade") == grade and CHECK_GACHA_DUPLICATE(pc, bEnableDuplicate, rewardcls.ItemName ) == true then
            rewardList[listIndex] = rewardcls.ItemName;
			local cls = GetClass("Item", rewardcls.ItemName);
			if nil ~= cls then
				rewardGroupName[listIndex] = cls.GroupName;
			else
				rewardGroupName[listIndex] = "None";
			end
            rewardCnt[listIndex] = rewardcls.Count;
            ratioList[listIndex] = rewardcls.Ratio;
            listIndex = listIndex + 1;
            totalRatio = totalRatio + rewardcls.Ratio;	-- 전체 확률
        end
    end

    -- get reward
	if listIndex <= 0 then
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end
	
    local reward = nil;	
    local rewardCount;
    local rewardGroup;
	local checkTime = imcTime.GetAppTime() + 1;
    while reward == nil do
		if checkTime < imcTime.GetAppTime() then
			CLEAR_GACHA_COMMAND(pc, Group);
			return;
		end
    	reward = nil;
    	local result = IMCRandom(1, totalRatio)	-- 보상 뽑기용 랜덤수
	    for i = 0, #ratioList do
	        if result <= ratioList[i] then
				reward = rewardList[i]
				rewardCount = rewardCnt[i]
				rewardGroup = rewardGroupName[i]
				break;
	        else
	            ratioList[i+1] = ratioList[i+1] + ratioList[i];
	        end
	    end

	    if reward ~= nil then
			break;
		end
    end   

    -- give reward
    if reward ~= nil then
    	--Tx 구간
		local tx = TxBegin(pc);	
		TxEnableInIntegrateIndun(tx);

		if totalPrice > 0 then
			TxTakeItem(tx, MONEY_NAME, totalPrice, "GACHA_CUBE", 0, cubeID);
		end
		TxGiveItem(tx, reward, rewardCount, 'GACHA_CUBE');
		local ret = TxCommit(tx);
		--Tx 구간 끝

		if ret == "SUCCESS" then
			if nil ~= Group then
                if TryGetProp(cubeItem, 'AllowReopen') == 'NO' then
                    ClearGachaCmd(pc);
                    btnVisible = 0;
                end
				local sucScp = string.format("GACHA_CUBE_SUCEECD(\'%s\', \'%s\', \'%d\')", cubeID, reward, btnVisible);
				ExecClientScp(pc, sucScp);		--성공여부를 클라이언트에 알린다.	(창 만들기)

			else						
				local sucScp = string.format("GACHA_CUBE_SUCEECD_EX(\'%s\', \'%s\', \'%d\')", cubeID, reward, btnVisible);
				ExecClientScp(pc, sucScp);		--성공여부를 클라이언트에 알린다.	(창 요소만 바꾸기)							
				UpdateCubeCmd(pc, reward); -- 큐브의 뽑기 횟수를 업데이트하기 위한 함수
			end		

			-- update reward list
			if bEnableDuplicate == 0 then
				UpdateCubeReward(pc, reward)
			end			
		end
    end
end


function SCR_FIRST_USE_GHACHA_CUBE_VELCOFFER(pc, argObj, rewardGroupClsName, arg1, arg2, clsId)
	local cubeCls = GetClassByType("Item", clsId);
	if cubeCls == nil then
		return;
	end
	local enableDuplicate = TryGetProp(cubeCls, "CubeDuplicate")
	if enableDuplicate == "NO" then
		enableDuplicate = 0
	else -- YES 이거나 프로퍼티가 없는 경우 default 값은 중복 허용
		enableDuplicate = 1
	end	

	-- 시작시 cmd 도 시작
	local check = StartGachaCube(pc, clsId, enableDuplicate);

	-- 이미 cmd가 있다면 실패
	if check == 0 then
		return;
	end

	-- 뽑기(첫번째)
    --SendAddOnMsg(pc, 'CLOSE_GACHA_CUBE', 'NO'); -- 이전에 있는 UI 있으면 닫아야 함
	SCR_ITEM_GACHA_VELCOFFER(pc, rewardGroupClsName, clsId, 1, enableDuplicate)
end

-- 뽑기 기능 함수 
-- (첫번째 뽑기에는  Group 인자가 nil이 아니다.)
-- 참고 : function GIVE_REWARD(self, group, giveway, tx)
function SCR_ITEM_GACHA_VELCOFFER(pc, Group, cubeID, btnVisible, bEnableDuplicate)

    local rewardID = 'reward_freedungeon'
    local rewardList = {};
    local rewardCnt = {};
    local ratioList = {};
    local expProp = {};
	local rewardGroupName = {};
    local listIndex = 0;
    local totalRatio = 0;
    local clslist, cnt = GetClassList(rewardID);	
	local totalPrice = 0;
	local rewGroup = nil;
	local cubeItem = GetClassByType("Item", cubeID);

	
	-- 가챠 Grade 우선 확률 계산 시작 --
	local basicGradeList = {
	                        { "MISC_1", 7980 },
    	                    { "MISC_2", 1000 },
    	                    { "MISC_3", 600 },
    	                    { "MISC_4", 100 },
    	                    { "WEAPON", 100 },
	                        { "ARMOR", 100 },
	                        { "COSTUME", 20},
	                        { "ACC", 90 },
	                        { "CARD", 10}
	                       };
    
    local gradeList = { };
    local totalGradeRatio = 0;
    for i = 1, #basicGradeList do
        local gradeTemp = basicGradeList[i];
        local gradeName = gradeTemp[1]
        local gradeRatio = totalGradeRatio + gradeTemp[2]
        totalGradeRatio = totalGradeRatio + gradeTemp[2];
        gradeList[#gradeList + 1] = { gradeName, gradeRatio };
    end

    local grade = 'MISC_1';
    local gradeRandom = IMCRandom(1, totalGradeRatio);

    for i = 1, #gradeList do
        local gradeTemp = gradeList[i];
        if gradeTemp[2] >= gradeRandom then
            grade = gradeTemp[1];
            break;
        end
    end
	-- 가챠 Grade 우선 확률 계산 끝 --
	

    if nil ~= Group then
		rewGroup = Group;
	else
		local cubeItem = GetClassByType("Item", cubeID);
		rewGroup = TryGetProp(cubeItem, "StringArg");

	end

	if nil ~= Group then	-- 무료 뽑기	
		rewGroup = Group;
	else					-- 유료 뽑기 (Group이 nil이다.)
		rewGroup = TryGetProp(cubeItem, "StringArg");
		totalPrice = TryGetProp(cubeItem, "NumberArg1");
	end

	if nil == rewGroup then
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end
    
	if IS_SEASON_SERVER(pc) == 'YES' then
	    totalPrice = math.floor(totalPrice/2)
	end
    
	if CHECK_PC_MONEY_FOR_PAY(pc, totalPrice) == 0 then 
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end
    
    for i = 0, cnt - 1 do	-- 보상리스트에서 확률로 보상 계산
        local rewardcls = GetClassByIndexFromList(clslist, i);
        if TryGetProp(rewardcls, "Group") == rewGroup and TryGetProp(rewardcls, "Grade") == grade and CHECK_GACHA_DUPLICATE(pc, bEnableDuplicate, rewardcls.ItemName ) == true then
            rewardList[listIndex] = rewardcls.ItemName;
			local cls = GetClass("Item", rewardcls.ItemName);
			if nil ~= cls then
				rewardGroupName[listIndex] = cls.GroupName;
			else
				rewardGroupName[listIndex] = "None";
			end
            rewardCnt[listIndex] = rewardcls.Count;
            ratioList[listIndex] = rewardcls.Ratio;
            listIndex = listIndex + 1;
            totalRatio = totalRatio + rewardcls.Ratio;	-- 전체 확률
        end
    end

    -- get reward
	if listIndex <= 0 then
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end
	
    local reward = nil;	
    local rewardCount;
    local rewardGroup;
	local checkTime = imcTime.GetAppTime() + 1;
    while reward == nil do
		if checkTime < imcTime.GetAppTime() then
			CLEAR_GACHA_COMMAND(pc, Group);
			return;
		end
    	reward = nil;
    	local result = IMCRandom(1, totalRatio)	-- 보상 뽑기용 랜덤수
	    for i = 0, #ratioList do
	        if result <= ratioList[i] then
				reward = rewardList[i]
				rewardCount = rewardCnt[i]
				rewardGroup = rewardGroupName[i]
				break;
	        else
	            ratioList[i+1] = ratioList[i+1] + ratioList[i];
	        end
	    end

	    if reward ~= nil then
			break;
		end
    end   

    -- give reward
    if reward ~= nil then
    	--Tx 구간
		local tx = TxBegin(pc);	
		TxEnableInIntegrateIndun(tx);

		if totalPrice > 0 then
			TxTakeItem(tx, MONEY_NAME, totalPrice, "GACHA_CUBE", 0, cubeID);
		end
		TxGiveItem(tx, reward, rewardCount, 'GACHA_CUBE');
		local ret = TxCommit(tx);
		--Tx 구간 끝

		if ret == "SUCCESS" then
			if nil ~= Group then
                if TryGetProp(cubeItem, 'AllowReopen') == 'NO' then
                    ClearGachaCmd(pc);
                    btnVisible = 0;
                end
				local sucScp = string.format("GACHA_CUBE_SUCEECD(\'%s\', \'%s\', \'%d\')", cubeID, reward, btnVisible);
				ExecClientScp(pc, sucScp);		--성공여부를 클라이언트에 알린다.	(창 만들기)

			else						
				local sucScp = string.format("GACHA_CUBE_SUCEECD_EX(\'%s\', \'%s\', \'%d\')", cubeID, reward, btnVisible);
				ExecClientScp(pc, sucScp);		--성공여부를 클라이언트에 알린다.	(창 요소만 바꾸기)							
				UpdateCubeCmd(pc, reward); -- 큐브의 뽑기 횟수를 업데이트하기 위한 함수
			end		

			-- update reward list
			if bEnableDuplicate == 0 then
				UpdateCubeReward(pc, reward)
			end			
		end
    end
end

---------------------------

-- 큐브 첫번째 뽑기일때의 Tx 및 소비템 처리 후 작동 
-- Item.xml의 CT_Consumable은 TX로 설정하고 CT_Script에 이 함수를 설정해야 됌.
function SCR_FIRST_USE_GHACHA_CUBE_ID_SAUSIS_9TH(pc, argObj, rewardGroupClsName, arg1, arg2, clsId)
	local cubeCls = GetClassByType("Item", clsId);
	if cubeCls == nil then
		return;
	end
	local enableDuplicate = TryGetProp(cubeCls, "CubeDuplicate")
	if enableDuplicate == "NO" then
		enableDuplicate = 0
	else -- YES 이거나 프로퍼티가 없는 경우 default 값은 중복 허용
		enableDuplicate = 1
	end	

	-- 시작시 cmd 도 시작
	local check = StartGachaCube(pc, clsId, enableDuplicate);

	-- 이미 cmd가 있다면 실패
	if check == 0 then
		return;
	end

	-- 뽑기(첫번째)
    SendAddOnMsg(pc, 'CLOSE_GACHA_CUBE', 'NO'); -- 이전에 있는 UI 있으면 닫아야 함
	SCR_ITEM_GACHA_ID_SAUSIS_9TH_2(pc, rewardGroupClsName, clsId, 1, enableDuplicate)
end

-- 뽑기 기능 함수 
-- (첫번째 뽑기에는  Group 인자가 nil이 아니다.)
-- 참고 : function GIVE_REWARD(self, group, giveway, tx)
function SCR_ITEM_GACHA_ID_SAUSIS_9TH_2(pc, Group, cubeID, btnVisible, bEnableDuplicate)

    local rewardID = 'reward_freedungeon'
    local rewardList = {};
    local rewardCnt = {};
    local ratioList = {};
    local expProp = {};
	local rewardGroupName = {};
    local listIndex = 0;
    local totalRatio = 0;										-- o=¿¡´ º???0L´?
    local clslist, cnt = GetClassList(rewardID);
    local totalPrice = 0;
	local rewGroup = nil;
	local cubeItem = GetClassByType("Item", cubeID);

	
	-- 가챠 Grade 우선 확률 계산 시작 --
	local basicGradeList = {
	                        { "C", 9000  },
    	                    { "B", 500    },
	                        { "A", 480    },
	                        { "LegCard", 20}
	                       };
    
    local gradeList = { };
    local totalGradeRatio = 0;
    for i = 1, #basicGradeList do
        local gradeTemp = basicGradeList[i];
        local gradeName = gradeTemp[1]
        local gradeRatio = totalGradeRatio + gradeTemp[2]
        totalGradeRatio = totalGradeRatio + gradeTemp[2];
        gradeList[#gradeList + 1] = { gradeName, gradeRatio };
    end

    local grade = 'C';
    local gradeRandom = IMCRandom(1, totalGradeRatio);

    for i = 1, #gradeList do
        local gradeTemp = gradeList[i];
        if gradeTemp[2] >= gradeRandom then
            grade = gradeTemp[1];
            break;
        end
    end
	-- 가챠 Grade 우선 확률 계산 끝 --
	

    if nil ~= Group then
		rewGroup = Group;
	else
		local cubeItem = GetClassByType("Item", cubeID);
		rewGroup = TryGetProp(cubeItem, "StringArg");
	end

	if nil ~= Group then	-- 무료 뽑기	
		rewGroup = Group;
	else					-- 유료 뽑기 (Group이 nil이다.)
		rewGroup = TryGetProp(cubeItem, "StringArg");
		totalPrice = TryGetProp(cubeItem, "NumberArg1");
	end

	if nil == rewGroup then
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end
    
	if IS_SEASON_SERVER(pc) == 'YES' then
	    totalPrice = math.floor(totalPrice/2)
	end
    
	if CHECK_PC_MONEY_FOR_PAY(pc, totalPrice) == 0 then 
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end
    
    for i = 0, cnt - 1 do	-- 보상리스트에서 확률로 보상 계산
        local rewardcls = GetClassByIndexFromList(clslist, i);
       
        if TryGetProp(rewardcls, "Group") == rewGroup and TryGetProp(rewardcls, "Grade") == grade and CHECK_GACHA_DUPLICATE(pc, bEnableDuplicate, rewardcls.ItemName ) == true then
            rewardList[listIndex] = rewardcls.ItemName;
			local cls = GetClass("Item", rewardcls.ItemName);
			if nil ~= cls then
				rewardGroupName[listIndex] = cls.GroupName;
			else
				rewardGroupName[listIndex] = "None";
			end
            rewardCnt[listIndex] = rewardcls.Count;
            ratioList[listIndex] = rewardcls.Ratio;
            listIndex = listIndex + 1;
            totalRatio = totalRatio + rewardcls.Ratio;	-- 전체 확률
        end
    end

    -- get reward
	if listIndex <= 0 then
		CLEAR_GACHA_COMMAND(pc, Group);
		return;
	end
	
    local reward = nil;	
    local rewardCount;
    local rewardGroup;
	local checkTime = imcTime.GetAppTime() + 1;
    while reward == nil do
		if checkTime < imcTime.GetAppTime() then
			CLEAR_GACHA_COMMAND(pc, Group);
			return;
		end
    	reward = nil;
    	local result = IMCRandom(1, totalRatio)	-- 보상 뽑기용 랜덤수
	    for i = 0, #ratioList do
	        if result <= ratioList[i] then
				reward = rewardList[i]
				rewardCount = rewardCnt[i]
				rewardGroup = rewardGroupName[i]
				break;
	        else
	            ratioList[i+1] = ratioList[i+1] + ratioList[i];
	        end
	    end

	    if reward ~= nil then
			break;
		end
    end   

    -- give reward
    if reward ~= nil then
    	--Tx 구간
		local tx = TxBegin(pc);	
		TxEnableInIntegrateIndun(tx);

		if totalPrice > 0 then
			TxTakeItem(tx, MONEY_NAME, totalPrice, "GACHA_CUBE", 0, cubeID);
		end
		TxGiveItem(tx, reward, rewardCount, 'GACHA_CUBE');
		local ret = TxCommit(tx);
		--Tx 구간 끝

		if ret == "SUCCESS" then
			if nil ~= Group then
                if TryGetProp(cubeItem, 'AllowReopen') == 'NO' then
                    ClearGachaCmd(pc);
                    btnVisible = 0;
                end
				local sucScp = string.format("GACHA_CUBE_SUCEECD(\'%s\', \'%s\', \'%d\')", cubeID, reward, btnVisible);
				ExecClientScp(pc, sucScp);		--성공여부를 클라이언트에 알린다.	(창 만들기)

			else						
				local sucScp = string.format("GACHA_CUBE_SUCEECD_EX(\'%s\', \'%s\', \'%d\')", cubeID, reward, btnVisible);
				ExecClientScp(pc, sucScp);		--성공여부를 클라이언트에 알린다.	(창 요소만 바꾸기)							
				UpdateCubeCmd(pc, reward); -- 큐브의 뽑기 횟수를 업데이트하기 위한 함수
			end		

			-- update reward list
			if bEnableDuplicate == 0 then
				UpdateCubeReward(pc, reward)
			end			
		end
    end
end
