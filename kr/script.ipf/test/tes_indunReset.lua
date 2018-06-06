-- test_indunReset.lua

-- //runscp TEST_INDUN_WEEKLY_RESET 39 3
function TEST_INDUN_WEEKLY_RESET(pc, indunType, numberOfDays)
	local year, month, day, hour, minute, second = GetLocalTime();
	
	print("================== TEST_INDUN_WEEKLY_RESET ==================");
	local indunCls = GetClassByType('Indun', indunType);

	for i = 1, numberOfDays do
		local timeStr = "";
		SetLocalTimeForTest(year, month, day + i - 1, hour);

		sleep(3000); -- for global setting

		timeStr = string.format("********** %d.%d.%d %d:00 **********", year, month, day + i - 1, hour);
		print(timeStr);
		TEST_INDUNWEEKLYRESET_UNIT_TEST(pc, indunCls, i);

		sleep(20000);
		print('--------------------------------');
	end
		
	print("=============================================================");
	
	--SetLocalTimeForTest(year, month, day, hour); -- 다시 오늘로 돌리고 싶으면 주석 해제하고 쓰심됨
end

function TEST_INDUNWEEKLYRESET_UNIT_TEST(pc, indunCls, day)
	local tokenState = IsPremiumState(pc, ITEM_TOKEN);
	local expectedEnterValue = 1;

	-- 첫번째 입장
	if day >= 5 then
		expectedEnterValue = 0;
	end
	TEST_INDUNWEEKLYRESET_SHOW_PC_STATE(pc, indunCls.PlayPerResetType);
	TEST_INDUNWEEKLYRESET_MOVE_TO_INDUN(pc, indunCls, expectedEnterValue);
	
	-- 두번째 입장
	expectedEnterValue = 1;
	if tokenState == 1 then
		if day >= 4 then
			expectedEnterValue = 0;		
		end
	elseif day >= 5 then
		expectedEnterValue = 0;
	end

	TEST_INDUNWEEKLYRESET_SHOW_PC_STATE(pc, indunCls.PlayPerResetType);
	TEST_INDUNWEEKLYRESET_MOVE_TO_INDUN(pc, indunCls, expectedEnterValue);
			
	-- 세번째 입장
	TEST_INDUNWEEKLYRESET_SHOW_PC_STATE(pc, indunCls.PlayPerResetType);
	TEST_INDUNWEEKLYRESET_MOVE_TO_INDUN(pc, indunCls, 0);
end

function TEST_INDUNWEEKLYRESET_SHOW_PC_STATE(pc, indunResetGroupID)
	local etc = GetETCObject(pc);
	local tokenState = IsPremiumState(pc, ITEM_TOKEN);
	local dailyEnteredCount = etc["InDunCountType_"..indunResetGroupID];
	local weeklyEnteredCount = 0;
	if TryGetProp(etc, "IndunWeeklyEnteredCount_"..indunResetGroupID) ~= nil then
		weeklyEnteredCount = etc["IndunWeeklyEnteredCount_"..indunResetGroupID];
	end
	local nextDailyResetTime = etc.Indun_ResetTime;
	local nextWeeklyResetTime = etc.IndunWeeklyResetTime;

	local printStr = "";
	printStr = string.format("pc- 토큰(%d), 일일횟수(%d), 주간횟수(%d), 다음 일일 초기화 시간(%d), 다음 주 초기화 시간(%d)", tokenState, dailyEnteredCount, weeklyEnteredCount, nextDailyResetTime, nextWeeklyResetTime);
	print(printStr);
end

function TEST_INDUNWEEKLYRESET_MOVE_TO_INDUN(pc, indunCls, expectedEnterValue)
	local indunResetGroupID = indunCls.PlayPerResetType;
	local etc = GetETCObject(pc);
	local isEnableMoveToIndun = IS_HAVE_INDUN_TICKET(pc, indunCls.ClassName);
	if expectedEnterValue ~= nil and expectedEnterValue ~= isEnableMoveToIndun then
		--print("----- assert fail: expected["..expectedEnterValue.."]");
	end	

	if isEnableMoveToIndun == 0 then		
		print("인던 입장: 실패");
		return;
	end

	local tx = TxBegin(pc);
	if tx == nil then
		print("TEST_INDUNWEEKLYRESET_MOVE_TO_INDUN: tx nil");
	end
	TxAddIESProp(tx, etc, "InDunCountType_"..indunResetGroupID, 1);	

	local weeklyEnteredCount = 0;
	if TryGetProp(etc, "IndunWeeklyEnteredCount_"..indunResetGroupID) ~= nil then
		TxAddIESProp(tx, etc, "IndunWeeklyEnteredCount_"..indunResetGroupID, 1);
	end

	local ret = TxCommit(tx);
	if ret == "SUCCESS" then
		print("인던 입장: 성공");
		return;
	end
	print("TEST_INDUNWEEKLYRESET_MOVE_TO_INDUN: tx fail");
end