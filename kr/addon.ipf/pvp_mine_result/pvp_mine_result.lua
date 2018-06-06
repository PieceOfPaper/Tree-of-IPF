function PVP_MINE_RESULT_REQ_RETURN_CITY(frame)
    packet.ReqReturnOriginServer();
    ui.CloseFrame('pvp_mine_result');
end

function PVP_MINE_RESULT_OPEN(isWin)
    local frame = ui.GetFrame('pvp_mine_result');
    PVP_MINE_RESULT_INIT(frame, isWin, argStr);
    frame:ShowWindow(1);
end

function PVP_MINE_RESULT_INIT(frame, isWin)
    local WIN_EFFECT_NAME = frame:GetUserConfig('WIN_EFFECT_NAME');
    local LOSE_EFFECT_NAME = frame:GetUserConfig('LOSE_EFFECT_NAME');
    local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));

    local winBox = GET_CHILD_RECURSIVELY(frame, 'winBox');
    local loseBox = GET_CHILD_RECURSIVELY(frame, 'loseBox');
    local drawBox = GET_CHILD_RECURSIVELY(frame, 'drawBox');

    local aObj = GetMyAccountObj();
    local getpoint = aObj.PVP_MINE_MAX;

    if isWin == 1 then
        getpoint = getpoint + 500
    else
        getpoint = getpoint + 100
    end

    local GetPoint_Desc = GET_CHILD_RECURSIVELY(frame, 'GetPoint_Desc');
    GetPoint_Desc:SetTextByKey("point", getpoint);

    if isWin == 1 then
        winBox:ShowWindow(1);
        loseBox:ShowWindow(0);
        drawBox:ShowWindow(0);

        if config.GetServiceNation() == 'GLOBAL' then
            imcSound.PlayMusicQueueLocal('colonywar_win')
        elseif config.GetServiceNation() == 'KOR' then
            imcSound.PlayMusicQueueLocal('colonywar_win_k')
        end
        winBox:PlayUIEffect(WIN_EFFECT_NAME, EFFECT_SCALE, 'COLONY_WIN');
    else
        winBox:ShowWindow(0);
        loseBox:ShowWindow(1);
        drawBox:ShowWindow(0);

        if config.GetServiceNation() == 'GLOBAL' then
            imcSound.PlayMusicQueueLocal('colonywar_lose')
        elseif config.GetServiceNation() == 'KOR' then
            imcSound.PlayMusicQueueLocal('colonywar_lose_k')
        end
        loseBox:PlayUIEffect(LOSE_EFFECT_NAME, EFFECT_SCALE, 'COLONY_LOSE');
    end
end

-- target UI
function SET_TARGETINFO_TO_MINE_POS()

	TARGET_INFO_OFFSET_Y = 20;
	TARGET_INFO_OFFSET_X = 1050;

	local targetBuff = ui.GetFrame("targetbuff");
	targetBuff:MoveFrame(1350, targetBuff:GetY());

	local channel = ui.GetFrame("channel");
	channel:ShowWindow(0);

	local mapAreaText = ui.GetFrame("mapareatext");
	mapAreaText:ShowWindow(0);

	local bugreport = ui.GetFrame("bugreport");
	bugreport:ShowWindow(0);

	local mapAreaText = ui.GetFrame("minimizedalarm");
	mapAreaText:ShowWindow(0);
end