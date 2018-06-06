-- test_indunReset.lua

function TEST_PRINT_MY_INDUN_CNT(pc)

	Chat(pc, "내 인던 횟수 출력 함수")

	local clslist, cnt = GetClassList("Indun");
	if nil == clslist then
		return;
	end

	local etcObj = GetETCObject(pc);
	if nil == etcObj then
		return;
	end

	for i = 0, cnt - 1 do
		local pCls = GetClassByIndexFromList(clslist, i);
		local countType = "InDunCountType_" ..pCls.PlayPerResetType;
		Chat(pc, "현재 내 인던 횟수 : " ..countType .. " " ..etcObj[countType])
	end

--	local indunResetTimeList, cnt = GetClassList("IndunResetTime");
--	if nil == indunResetTimeList then
--		return;
--	end

--	local IndunResetTime = GetClassByProp

	Chat(pc, "현재 내 다음 리셋 타임 : " ..etcObj.Indun_ResetTime)

end

function TEST_RESET_INDUN_TIME(pc)

	Chat(pc, "인던  시간 초기화 함수")

	local etcObj = GetETCObject(pc);
	if nil == etcObj then
		return;
	end

	local tx = TxBegin(pc);

	if nil == tx then
		return;
	end

--		etcObj.Indun_ResetTime = 100;
--	TxSetIESProp(tx, etcObj, "Indun_ResetTime", 4);

	TxCommit(tx);

		Chat(pc, "현재 내 다음 리셋 타임s : " ..etcObj.Indun_ResetTime)

	Chat(pc, "리셋 타임이 0으로 초기화 되었으므로 다음 존 입장 시에 모든 인던 입장 횟수가 0으로 초기화 되어야 합니다")

end

function TEST_SET_INDUN_COUNT(pc)

	Chat(pc, "이 pc의 전체 인던 입장 횟수를 2로 세팅합니다")

	local clslist, cnt = GetClassList("Indun");
	if nil == clslist then
		return;
	end

	local etcObj = GetETCObject(pc);
	if nil == etcObj then
		return;
	end

	local tx = TxBegin(pc);

	if nil == tx then
		return;
	end

	for i = 0, cnt - 1 do
		local pCls = GetClassByIndexFromList(clslist, i);
		local countType = "InDunCountType_" ..pCls.PlayPerResetType;
		TxSetIESProp(tx, etcObj, countType, 2);
	end


	TxCommit(tx);

	for i = 0, cnt - 1 do
		local pCls = GetClassByIndexFromList(clslist, i);
		local countType = "InDunCountType_" ..pCls.PlayPerResetType;
		Chat(pc, "현재 내 인던 횟수 : " ..countType .. " " ..etcObj[countType])
	end

end


function SET_INDUN_COUNT(pc)

Chat(pc, "이 pc의 전체 인던 입장 횟수를 2로 세팅합니다")

local clslist, cnt = GetClassList("Indun");
		if nil == clslist then
			return;
		end

			local etcObj = GetETCObject(pc);
		if nil == etcObj then
			return;
		end

			local tx = TxBegin(pc);

		if nil == tx then
			return;
		end

			for i = 0, cnt - 1 do
				local pCls = GetClassByIndexFromList(clslist, i);
		local countType = "InDunCountType_" ..pCls.PlayPerResetType;
		TxSetIESProp(tx, etcObj, countType, 2);
		end
			TxCommit(tx);

		end