function INDUN_REWARD_ON_INIT(addon, frame)
    addon:RegisterMsg('OPEN_INDUN_REWARD', 'INDUN_REWARD_OPEN')
    addon:RegisterMsg('INDUN_REWARD_RESULT', 'INDUN_REWARD_SET')
    addon:RegisterMsg('ENABLE_RETURN_BUTTON', 'ENABLE_RETURN_BUTTON')
end

-- 잠긴 돌아가기 버튼을 활성화
function ENABLE_RETURN_BUTTON(f, msg, argStr, argNum)
    local frame = ui.GetFrame('indun_reward')
    if frame ~= nil then
        local rtn_button = GET_CHILD_RECURSIVELY(frame, 'btnReturn')
        if rtn_button ~= nil then
            rtn_button:EnableHitTest(1)
            rtn_button:SetAlpha(100)
        end
    end
end

function INDUN_REWARD_OPEN(frame, msg, argStr, argNum)    
    frame:ShowWindow(1);
end

function INDUN_REWARD_SET(frame, msg, str, arg)    
	local msgList = StringSplit(str, '#');
	if #msgList < 1 then
		return;
	end
	
    frame:ShowWindow(1);

	local contribution = tonumber(msgList[1]);
	local silver = tonumber(msgList[2]);
	local cube = tonumber(msgList[3]);
	local exp = tonumber(msgList[4]);
	local jexp = tonumber(msgList[5]);
	local multipleRate = tonumber(msgList[6]);
	local rank = tonumber(msgList[7]);

	local textContribution_percent = GET_CHILD(frame, "textContribution_percent");
	textContribution_percent:SetText(string.format("{@st43}{s24}%d %%", contribution));
	
	local gboxRewardList = GET_CHILD(frame, "gboxRewardList");
	local gboxRewardList2 = GET_CHILD(gboxRewardList, "gboxRewardList2");

	local addMsg = ''
--	--EVENT_1806_WEEKEND
--	if IS_DAY_EVENT_1806_WEEKEND_INDUN_SILVER() == 'YES' then
--	    addMsg = ' '..ScpArgMsg('EVENT_1806_WEEKEND_MSG1')
--	end


	local textRewardSilver_value = GET_CHILD(gboxRewardList2, "textRewardSilver_value");
	textRewardSilver_value:SetText(GET_COMMAED_STRING(silver)..addMsg);

	local textRewardCube_value = GET_CHILD(gboxRewardList2, "textRewardCube_value");
	textRewardCube_value:SetText(GET_COMMAED_STRING(cube));

	local textRewardExp_value = GET_CHILD(gboxRewardList2, "textRewardExp_value");
	textRewardExp_value:SetText(GET_COMMAED_STRING(exp));
	
	local textRewardJobExp_value = GET_CHILD(gboxRewardList2, "textRewardJobExp_value");
	textRewardJobExp_value:SetText(GET_COMMAED_STRING(jexp));
	
	local textMultipleRate_value = GET_CHILD(frame, "textMultipleRate_value");
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
	
	local textReturn = GET_CHILD(frame, "textReturn");
    local rtn_button = GET_CHILD(frame, 'btnReturn'); -- 돌아가기 버튼을 잠근다.
    rtn_button:EnableHitTest(0)
    rtn_button:SetAlpha(50)

	textReturn:SetUserValue("CHALLENGE_MODE_START_TIME", tostring(imcTime.GetAppTimeMS()));

	textReturn:StopUpdateScript("SCR_INDUN_REWARD_WAIT_RETURN");
	textReturn:RunUpdateScript("SCR_INDUN_REWARD_WAIT_RETURN");
    AddLuaTimerFunc('ENABLE_RETURN_BUTTON', 10000, 0) -- 10초후에 자동활성화
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

function SCR_INDUN_REWARD_RETURN(frame)
	packet.ReqReturnOriginServer();
end

function SCR_INDUN_REWARD_CLOSE(frame)
    local frame = ui.GetFrame("indun_reward");
	frame:ShowWindow(0);
end