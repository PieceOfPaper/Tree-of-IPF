function INDUN_REWARD_HUD_ON_INIT(addon, frame)
    addon:RegisterMsg('OPEN_INDUN_REWARD_HUD', 'INDUN_REWARD_HUD_OPEN')
end

function INDUN_REWARD_HUD_OPEN(frame, msg, argStr, argNum)
    INDUN_REWARD_HUD_SET_POINT(frame, argNum);
	frame:ShowWindow(1);
	if argStr ~= 'None' then
		frame:SetUserValue("IndunClassID", argStr)
	end
end

function INDUN_REWARD_HUD_SET_POINT(frame, point)
    local rewardGauge = GET_CHILD_RECURSIVELY(frame, 'rewardGauge');
    rewardGauge:SetPoint(point, 100);

    local percentText = GET_CHILD_RECURSIVELY(frame, 'percentText');
    percentText:SetTextByKey('percent', point);

    local DISABLE_REWARD_STYLE = frame:GetUserConfig('DISABLE_REWARD_STYLE');
    local ENABLE_REWARD_STYLE = frame:GetUserConfig('ENABLE_REWARD_STYLE');
    local enableCnt = point / 20;
    for i = 1, 5 do
        local rewardText = GET_CHILD_RECURSIVELY(frame, 'rewardText'..i);
        if i <= enableCnt then
            rewardText:SetTextByKey('style', ENABLE_REWARD_STYLE);
        else
            rewardText:SetTextByKey('style', DISABLE_REWARD_STYLE);
        end
    end
end