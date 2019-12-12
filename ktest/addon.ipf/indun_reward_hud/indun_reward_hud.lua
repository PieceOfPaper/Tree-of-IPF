function INDUN_REWARD_HUD_ON_INIT(addon, frame)
    addon:RegisterMsg('OPEN_INDUN_REWARD_HUD', 'INDUN_REWARD_HUD_OPEN')
    addon:RegisterMsg('REFRESH_INDUN_REWARD_HUD', 'INDUN_REWARD_HUD_REFRESH')
end

function INDUN_REWARD_HUD_OPEN(frame, msg, argStr, argNum)
    frame:ShowWindow(1);

    if argStr == nil then
        return
    end

    if argNum == nil then
        argNum = 0;
    end

    local indunCls = GetClass('Indun', argStr);
    if TryGetProp(indunCls, 'DungeonType', 'None') == 'MissionIndun' then
        for i = 1, 5 do
            local rewardPic = GET_CHILD_RECURSIVELY(frame, 'rewardPic' .. i);
            rewardPic:Resize(28, 14);
            local margin = rewardPic:GetMargin();
            rewardPic:SetMargin(margin.left + 9, margin.top, margin.right, margin.bottom);
            rewardPic:SetImage('test_indun_exp');

            local rewardTxt = GET_CHILD_RECURSIVELY(frame, 'rewardText' .. i);
            rewardTxt:ShowWindow(0);
        end
        INDUN_REWARD_HUD_SET_POINT(frame, argNum, false);
    else
        INDUN_REWARD_HUD_SET_POINT(frame, argNum, true);
    end
end

function INDUN_REWARD_HUD_REFRESH(frame, msg, argStr, argNum)
    if argStr == nil then
        return
    end

    if frame:IsVisible() == 0 then
        INDUN_REWARD_HUD_OPEN(frame, msg, argStr, argNum)
    else
        local indunCls = GetClass('Indun', argStr);
        if TryGetProp(indunCls, 'DungeonType', 'None') == 'MissionIndun' then
            INDUN_REWARD_HUD_SET_POINT(frame, argNum, false);
        else
            INDUN_REWARD_HUD_SET_POINT(frame, argNum, true);
        end
    end
end

function INDUN_REWARD_HUD_SET_POINT(frame, point, updateTxt)
    local rewardGauge = GET_CHILD_RECURSIVELY(frame, 'rewardGauge');
    rewardGauge:SetPoint(point, 100);

    local percentText = GET_CHILD_RECURSIVELY(frame, 'percentText');
    percentText:SetTextByKey('percent', point);

    if updateTxt == true then
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
end