function INDUN_REWARD_ON_INIT(addon, frame)
	addon:RegisterMsg('OPEN_INDUN_REWARD', 'INDUN_REWARD_OPEN')
	addon : RegisterMsg('INDUN_REWARD_RESULT_FIRST', 'INDUN_REWARD_SET_FIRST')
	addon:RegisterMsg('INDUN_REWARD_RESULT', 'INDUN_REWARD_SET')
	addon:RegisterMsg('INDUN_REWARD_RESULT_FINAL', 'INDUN_REWARD_SET_FINAL')
end

function INDUN_REWARD_OPEN(frame, msg, argStr, argNum)
    frame:ShowWindow(1);
end

function INDUN_REWARD_SET_FIRST(frame, msg, str, data)
	local frame = ui.GetFrame("indun_reward")
	if frame == nil then
        return;
    end
	local textReturn = GET_CHILD(frame, "textReturn");
	textReturn:SetUserValue("CHALLENGE_MODE_START_TIME", tostring(imcTime.GetAppTimeMS()));

	textReturn:StopUpdateScript("SCR_INDUN_REWARD_WAIT_RETURN");
	textReturn:RunUpdateScript("SCR_INDUN_REWARD_WAIT_RETURN");

	INDUN_REWARD_SET(frame, msg, str, data)
end

function INDUN_REWARD_SET(frame, msg, str, data)
	local msgList = StringSplit(str, '#');
	print('INDUN_REWARD_SET 1')
	if #msgList < 1 then
		return;
	end
	
	local multiEdit = GET_CHILD_RECURSIVELY(frame, "multiEdit")
	
	local inputMultiple = multiEdit:GetNumber()

	frame:SetUserValue("IndunMultipleCount", inputMultiple);

	--현재 내가 인던을 돈 횟수
	--현재 내가 최대로 인던을 돌 수 있는 횟수

	frame : SetUserValue("rewardStr", str)
    frame:ShowWindow(1);
	local contribution = tonumber(msgList[1]);
	local silver = tonumber(msgList[2]) * (1 + inputMultiple);
	local cube = tonumber(msgList[3]) * (1 + inputMultiple);
	local exp_default = tonumber(msgList[4]) * (1 + inputMultiple);
	local jexp_default = tonumber(msgList[5]) * (1 + inputMultiple);
	local exp_bonus = tonumber(msgList[6]) * (1 + inputMultiple);
	local jexp_bonus = tonumber(msgList[7]) * (1 + inputMultiple);

	local multipleRate = tonumber(msgList[8]) + inputMultiple;
	local rank = tonumber(msgList[9]);

	frame : SetUserValue("contribution", contribution)
	frame : SetUserValue("multipleRate", multipleRate)
	frame : SetUserValue("rank", rank)


	local textContribution_percent = GET_CHILD(frame, "textContribution_percent");
	textContribution_percent:SetText(string.format("{@st43}{s24}%d %%", contribution));
	
	local gboxRewardList = GET_CHILD(frame, "gboxRewardList");
	local gboxRewardList2 = GET_CHILD(gboxRewardList, "gboxRewardList2");

	local textMultipleRate_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textMultipleRate_value");
	textMultipleRate_value:SetText(string.format("{@st66d_y}%s", GET_COMMAED_STRING(multipleRate)));

	local textRewardSilver_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardSilver_value");
	textRewardSilver_value:SetText(GET_COMMAED_STRING(silver));

	local textRewardCube_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardCube_value");
	textRewardCube_value:SetText(GET_COMMAED_STRING(cube));

	local textRewardExp_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardExp_value");
	textRewardExp_value:SetText(GET_COMMAED_STRING(exp_default));
	local textRewardBonusExp_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardBonusExp_value");
	textRewardBonusExp_value:SetText(GET_COMMAED_STRING(exp_bonus));
	local textRewardTotalExp_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardTotalExp_value");
	local exp_total = exp_default + exp_bonus
	textRewardTotalExp_value:SetText(string.format("{@st66d_y}%s", GET_COMMAED_STRING(exp_total)));
	
	local textRewardJobExp_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardJobExp_value");
	textRewardJobExp_value:SetText(GET_COMMAED_STRING(jexp_default));
	local textRewardJobBonusExp_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardJobBonusExp_value");
	textRewardJobBonusExp_value:SetText(GET_COMMAED_STRING(jexp_bonus));
	local textRewardJobTotalExp_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardJobTotalExp_value");
	local jexp_total = jexp_default + jexp_bonus
	textRewardJobTotalExp_value:SetText(string.format("{@st66d_y}%s", GET_COMMAED_STRING(jexp_total)));
	
	
	local btnReturn = GET_CHILD_RECURSIVELY(frame, "btnReturn")
	btnReturn:SetEnable(0)

	local picRank = GET_CHILD(frame, "picRanking");

	local picRankName = "test_indun_S";
	if rank == 1 then
		picRankName = "test_indun_A";
	elseif rank == 2 then
		picRankName = "test_indun_B";
	elseif rank == 3 then
		picRankName = "test_indun_C";
	elseif rank == 4 then
		picRankName = "test_indun_D";
	elseif rank == 5 then
		picRankName = "test_indun_E";
	end
	
	picRank:SetImage(picRankName);
	print('INDUN_REWARD_SET2')
end

function INDUN_REWARD_SET_FINAL(frame, msg, str, data)
	local msgList = StringSplit(str, '#');
	if #msgList < 1 then
		return;
	end

    frame:ShowWindow(1);

	local contribution = tonumber(msgList[1]);
	local silver = tonumber(msgList[2]);
	local cube = tonumber(msgList[3]);
	local exp_default = tonumber(msgList[4]);
	local jexp_default = tonumber(msgList[5]);
	local exp_bonus = tonumber(msgList[6]);
	local jexp_bonus = tonumber(msgList[7]);

	local multipleRate = tonumber(msgList[8]);
	local rank = tonumber(msgList[9]);

	frame : SetUserValue("contribution", contribution)
	frame : SetUserValue("multipleRate", multipleRate)
	frame : SetUserValue("rank", rank)

	local textContribution_percent = GET_CHILD(frame, "textContribution_percent");
	textContribution_percent:SetText(string.format("{@st43}{s24}%d %%", contribution));
	
	local gboxRewardList = GET_CHILD(frame, "gboxRewardList");
	local gboxRewardList2 = GET_CHILD(gboxRewardList, "gboxRewardList2");

	local textRewardSilver_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardSilver_value");
	textRewardSilver_value:SetText(GET_COMMAED_STRING(silver));

	local textRewardCube_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardCube_value");
	textRewardCube_value:SetText(GET_COMMAED_STRING(cube));


	local textRewardExp_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardExp_value");
	textRewardExp_value:SetText(GET_COMMAED_STRING(exp_default));
	local textRewardBonusExp_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardBonusExp_value");
	textRewardBonusExp_value:SetText(GET_COMMAED_STRING(exp_bonus));
	local textRewardTotalExp_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardTotalExp_value");
	local exp_total = exp_default + exp_bonus
	textRewardTotalExp_value:SetText(string.format("{@st66d_y}%s", GET_COMMAED_STRING(exp_total)));
	
	local textRewardJobExp_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardJobExp_value");
	textRewardJobExp_value:SetText(GET_COMMAED_STRING(jexp_default));
	local textRewardJobBonusExp_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardJobBonusExp_value");
	textRewardJobBonusExp_value:SetText(GET_COMMAED_STRING(jexp_bonus));
	local textRewardJobTotalExp_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textRewardJobTotalExp_value");
	local jexp_total = jexp_default + jexp_bonus
	textRewardJobTotalExp_value:SetText(string.format("{@st66d_y}%s", GET_COMMAED_STRING(jexp_total)));

		
	local textMultipleRate_value = GET_CHILD_RECURSIVELY(gboxRewardList2, "textMultipleRate_value");
	textMultipleRate_value:SetText(string.format("{@st66d_y}%s", GET_COMMAED_STRING(multipleRate)));

	local picRank = GET_CHILD(frame, "picRanking");

	local picRankName = "test_indun_S";
	if rank == 1 then
		picRankName = "test_indun_A";
	elseif rank == 2 then
		picRankName = "test_indun_B";
	elseif rank == 3 then
		picRankName = "test_indun_C";
	elseif rank == 4 then
		picRankName = "test_indun_D";
	elseif rank == 5 then
		picRankName = "test_indun_E";
	end
	
	picRank:SetImage(picRankName);

	local multiEditBox = GET_CHILD_RECURSIVELY(frame, "multiEditBox")
	multiEditBox:ShowWindow(0)
	local btnGetReward = GET_CHILD_RECURSIVELY(frame, "btnGetReward")
	btnGetReward:ShowWindow(0)
	local indunTokenImage = GET_CHILD_RECURSIVELY(frame, "indunTokenImage")
	indunTokenImage : ShowWindow(0)

	local btnReturn = GET_CHILD_RECURSIVELY(frame, "btnReturn")
	btnReturn : SetEnable(1)
end


function SCR_INDUN_REWARD_WAIT_RETURN(textReturn)
	local startTime = textReturn:GetUserValue("CHALLENGE_MODE_START_TIME");
	if startTime == nil then
		return 0;
	end
	
	local nowTime = imcTime.GetAppTimeMS();
	local diffTime = (nowTime - startTime) / 1000;
	local remainTime = 60 - diffTime;
	if remainTime < 0 then
		textReturn:SetText(ScpArgMsg("Wait{Sec}ReturnOringinServer", "Sec", 0));
		return 0;
	end
	local remainSec = math.floor(remainTime % 60);
	
	textReturn:SetText(ScpArgMsg("Wait{Sec}ReturnOringinServer", "Sec", remainSec));
	return 1;
end

function SCR_INDUN_GET_REWARD(frame)
	local frame = ui.GetFrame("indun_reward")
	if frame == nil then
        return;
    end
    local multiEdit = GET_CHILD_RECURSIVELY(frame, 'multiEdit');
	local indunMultipleRate = multiEdit:GetNumber();

	local argStr = string.format("%d#", indunMultipleRate)
	local multipleCount = frame:GetUserIValue("IndunMultipleCount");
	print('GEt ReWARD MULTIPLE CNT : ' .. tostring(multipleCount))

	pc.ReqExecuteTx("SCR_TX_INDUN_CONTRIBUTION_REWARD", multipleCount);
end

function SCR_INDUN_REWARD_RETURN(frame)
	packet.ReqReturnOriginServer();
end

function SCR_INDUN_REWARD_CLOSE(frame)
    local frame = ui.GetFrame("indun_reward");
	frame:ShowWindow(0);
end


function INDUN_REWARD_MULTI_UP(frame, ctrl)
IMC_LOG("INFO_NORMAL", "MULTI_UP 0")
    if frame == nil or ctrl == nil then
        return;
    end
    local multiEdit = GET_CHILD(frame, 'multiEdit');
    local nowCnt = multiEdit:GetNumber();
    local topFrame = frame:GetTopParentFrame();
    local maxCnt = INDUN_MULTIPLE_USE_MAX_COUNT;
    
    local multipleItemList = GET_INDUN_MULTIPLE_ITEM_LIST();
	IMC_LOG("INFO_NORMAL", "MULTI_UP 1")
    for i = 1, #multipleItemList do
        local itemName = multipleItemList[i];
        local invItem = session.GetInvItemByName(itemName);
        if invItem ~= nil and invItem.isLockState then
            ui.SysMsg(ClMsg("MaterialItemIsLock"));
            return;
        end
    end
			IMC_LOG("INFO_NORMAL", "MULTI_UP 2")
    local itemCount = GET_MY_INDUN_MULTIPLE_ITEM_COUNT();    
    if itemCount == 0 then
        return;
    end
		IMC_LOG("INFO_NORMAL", "MULTI_UP 3")
    nowCnt = nowCnt + 1;

    local etc = GetMyEtcObject();
	
	local indunRewardHUD = ui.GetFrame("indun_reward_hud")
	if indunRewardHUD == nil then
		IMC_LOG("INFO_NORMAL", "IndunRewardHUD is nil")
		return
	end
	local indunClassID = indunRewardHUD:GetUserValue("IndunClassID")
	
    local indunType = topFrame:GetUserValue('INDUN_TYPE');

    local indunCls = GetClassByType('Indun', indunClassID);
    if indunCls == nil then
		IMC_LOG("INFO_NORMAL", "indunCls is nil")
        return;
    end

    local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
	nowCount = nowCount - 1
		IMC_LOG("INFO_NORMAL", "nowCnt : " .. tostring(nowCount))
    local maxCount = TryGetProp(indunCls, 'PlayPerReset');
    if session.loginInfo.IsPremiumState(ITEM_TOKEN) == true then
        maxCount = maxCount + TryGetProp(indunCls, 'PlayPerReset_Token')
    end
    if session.loginInfo.IsPremiumState(NEXON_PC) == true then
        maxCount = maxCount + TryGetProp(indunCls, 'PlayPerReset_NexonPC')
    end
		IMC_LOG("INFO_NORMAL", "maxCnt : " ..tostring(maxCount))
    local remainCount = maxCount - nowCount;
	IMC_LOG("INFO_NORMAL", "remainCnt : " ..tostring(remainCount))
    if nowCnt >= remainCount then
        nowCnt = remainCount - 1;
        ui.SysMsg(ScpArgMsg('NotEnoughIndunEnterCount'));
    elseif nowCnt == maxCnt then
        ui.SysMsg(ScpArgMsg('IndunMultipleMAX'));
        return
    end
    
    if nowCnt - 1 >= itemCount then
        ui.SysMsg(ScpArgMsg('NotEnoughIndunMultipleItem'));
        return;
    end
		IMC_LOG("INFO_NORMAL", "MULTI_UP 5")
    if nowCnt < 0 then
		IMC_LOG("INFO_NORMAL", "nowCnt : "..nowCnt)
        return;
    end

	multiEdit:SetText(tostring(nowCnt));
	local str = topFrame: GetUserValue("rewardStr")
		IMC_LOG("INFO_NORMAL", "MULTI_UP 6")
	INDUN_REWARD_SET(topFrame, msg, str, data)
end

function INDUN_REWARD_MULTI_DOWN(frame, ctrl)
IMC_LOG("INFO_NORMAL", "MULTI_down 1")
    if frame == nil or ctrl == nil then
        return;
    end
    local multiEdit = GET_CHILD(frame, 'multiEdit');
    local nowCnt = multiEdit:GetNumber();
    local topFrame = frame:GetTopParentFrame();
    local minCnt = topFrame:GetUserIValue('MIN_MULTI_CNT');

    nowCnt = nowCnt - 1;
    if nowCnt < minCnt then
        nowCnt = minCnt;
    end
		IMC_LOG("INFO_NORMAL", "MULTI_down 2")
	multiEdit:SetText(tostring(nowCnt));
	local str = topFrame: GetUserValue("rewardStr")
	INDUN_REWARD_SET(topFrame, msg, str, data)
end