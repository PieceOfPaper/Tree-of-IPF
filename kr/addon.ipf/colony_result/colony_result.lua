function COLONY_RESULT_ON_INIT(addon, frame)
    addon:RegisterMsg('UPDATE_OTHER_GUILD_EMBLEM', 'ON_UPDATE_WINNER_INFO_EMBLEM');
end

function COLONY_RESULT_REQ_RETURN_CITY(frame)
    local infoText = GET_CHILD_RECURSIVELY(frame, 'infoText');
	infoText:StopUpdateScript("COLONY_RESULT_UPDATE_TIMER");

    session.colonywar.ReqReturnToCity();
    ui.CloseFrame('colony_result');
end

function COLONY_RESULT_OPEN(isWin, argStr)
    local frame = ui.GetFrame('colony_result');
    frame:SetUserValue('SERVICE_NATION', config.GetServiceNation());

    if frame:GetUserValue('SERVICE_NATION') == 'KOR' then        
        COLONY_RESULT_SHOW_UI_MODE(frame, 0);
    else        
        COLONY_RESULT_SHOW_UI_MODE(frame, 1);
    end

    COLONY_RESULT_INIT(frame, isWin, argStr);
    COLONY_RESULT_INIT_TIMER(frame);
    frame:ShowWindow(1);
end

function COLONY_RESULT_INIT(frame, isWin, argStr)
    local WIN_EFFECT_NAME = frame:GetUserConfig('WIN_EFFECT_NAME');
    local LOSE_EFFECT_NAME = frame:GetUserConfig('LOSE_EFFECT_NAME');
    local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));

    local winBox = GET_CHILD_RECURSIVELY(frame, 'winBox');
    local loseBox = GET_CHILD_RECURSIVELY(frame, 'loseBox');
    local winUIBox = GET_CHILD_RECURSIVELY(frame, 'winUIBox');
    local loseUIBox = GET_CHILD_RECURSIVELY(frame, 'loseUIBox');
    if isWin == 1 then
        winBox:ShowWindow(1);
        loseBox:ShowWindow(0);

        if frame:GetUserValue('SERVICE_NATION') == 'KOR' then
            imcSound.PlayMusicQueueLocal('colonywar_win_k')
        else
            imcSound.PlayMusicQueueLocal('colonywar_win')
        end

        if frame:GetUserValue('SERVICE_NATION') == 'KOR' then
            winBox:PlayUIEffect(WIN_EFFECT_NAME, EFFECT_SCALE, 'COLONY_WIN');
        else
            winUIBox:ShowWindow(1);
            loseUIBox:ShowWindow(0);
        end
    else
        local winnerInfoBox = GET_CHILD_RECURSIVELY(loseBox, 'winnerInfoBox');
        if argStr ~= 'None' then
            local guildInfo = StringSplit(argStr, '#');
            local guildID = guildInfo[1];
            local winnerNameText = GET_CHILD_RECURSIVELY(loseBox, 'winnerNameText');
            winnerNameText:SetText(guildInfo[2]);

            local winnerEmblemPic = GET_CHILD(winnerInfoBox, 'winnerEmblemPic');
            local worldID = session.party.GetMyWorldIDStr();
            local emblemImgName = guild.GetEmblemImageName(guildID,worldID);
            if emblemImgName ~= 'None' then
                winnerEmblemPic:SetImage(emblemImgName);
            else
                local worldID = session.party.GetMyWorldIDStr();
                guild.ReqEmblemImage(guildID,worldID);
            end
            winnerInfoBox:ShowWindow(1);
        else
            winnerInfoBox:ShowWindow(0);
        end
        winBox:ShowWindow(0);
        loseBox:ShowWindow(1);

        if frame:GetUserValue('SERVICE_NATION') == 'KOR' then
            imcSound.PlayMusicQueueLocal('colonywar_lose_k')
        else
            imcSound.PlayMusicQueueLocal('colonywar_lose')
        end

        if frame:GetUserValue('SERVICE_NATION') == 'KOR' then            
            loseBox:PlayUIEffect(LOSE_EFFECT_NAME, EFFECT_SCALE, 'COLONY_LOSE');
        else
            winUIBox:ShowWindow(0);
            loseUIBox:ShowWindow(1);
        end
    end
end

function COLONY_RESULT_INIT_TIMER(frame)
    local infoText = GET_CHILD_RECURSIVELY(frame, 'infoText');
    infoText:SetUserValue('CLOSE_SEC', 30);
    infoText:SetUserValue('START_SEC', math.floor(imcTime.GetAppTime()));
    infoText:RunUpdateScript('COLONY_RESULT_UPDATE_TIMER', 0.2);
end

function COLONY_RESULT_UPDATE_TIMER(infoText)
    local elapsedSec = imcTime.GetAppTime() - infoText:GetUserIValue("START_SEC");
	local closeSec = infoText:GetUserIValue("CLOSE_SEC");
	local remainSec = math.floor(closeSec - elapsedSec);
	if 0 > remainSec then
        ui.CloseFrame('colony_result');
		return 0;
	end
	infoText:SetTextByKey("time", remainSec);
	return 1;
end

function ON_UPDATE_WINNER_INFO_EMBLEM(frame, msg, argStr, argNum)
    if frame == nil or frame:IsVisible() == 0 then
        return;
    end    
    local winnerInfoBox = GET_CHILD_RECURSIVELY(frame, 'winnerInfoBox');
    if winnerInfoBox:IsVisible() == 0 then
        return;
    end

    local winnerEmblemPic = GET_CHILD(winnerInfoBox, 'winnerEmblemPic');
    local worldID = session.party.GetMyWorldIDStr();
    local emblemImgName = guild.GetEmblemImageName(argStr,worldID);
    if emblemImgName ~= 'None' then
        winnerEmblemPic:SetImage(emblemImgName);
    end
end

function COLONY_RESULT_SHOW_UI_MODE(frame, isOn)
    local winUIBox = GET_CHILD_RECURSIVELY(frame, 'winUIBox');
    local loseUIBox = GET_CHILD_RECURSIVELY(frame, 'loseUIBox');
    winUIBox:ShowWindow(isOn);
    loseUIBox:ShowWindow(isOn);
end