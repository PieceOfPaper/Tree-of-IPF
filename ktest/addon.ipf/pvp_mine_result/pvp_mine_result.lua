function PVP_MINE_RESULT_REQ_RETURN_CITY(frame)
    packet.ReqReturnOriginServer();
    ui.CloseFrame('pvp_mine_result');
end

function PVP_MINE_RESULT_OPEN(isWin, Team, killCount, killName, mineCount, mineName)
    local frame = ui.GetFrame('pvp_mine_result');
    frame:SetUserValue('SERVICE_NATION', config.GetServiceNation());
    if frame:GetUserValue('SERVICE_NATION') == 'KOR' then        
        COLONY_RESULT_SHOW_UI_MODE(frame, 0);
    else        
        COLONY_RESULT_SHOW_UI_MODE(frame, 1);
    end
    PVP_MINE_RESULT_INIT(frame, isWin, Team, killCount, killName, mineCount, mineName);
    frame:ShowWindow(1);
end

function PVP_MINE_RESULT_INIT(frame, isWin, Team, killCount, killName, mineCount, mineName)
    local WIN_EFFECT_NAME = frame:GetUserConfig('WIN_EFFECT_NAME');
    local LOSE_EFFECT_NAME = frame:GetUserConfig('LOSE_EFFECT_NAME');
    local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));

    local drawBox = GET_CHILD_RECURSIVELY(frame, 'drawBox');
    local MyPc = GetMyPCObject();
    local aObj = GetMyAccountObj();
    local mine_max = aObj.PVP_MINE_MAX

    if mine_max > 500 then
        mine_max = 500
    end

    local getpoint = mine_max * 3;
    local bouns = 0

    if MyPc.Name == killName then
        bouns = 450
    end

    if MyPc.Name == mineName then
        bouns = bouns + 900
    end

    if isWin == 1 then -- win, lose
        getpoint = getpoint + 1500 + bouns
    else
        getpoint = getpoint + 300 + bouns
    end

    if killName == nil then
        killName = 'None'
    elseif mineName == nil then
        mineName = 'None'
    end

    local GetPoint_Desc = GET_CHILD_RECURSIVELY(frame, 'GetPoint_Desc');
    GetPoint_Desc:SetTextByKey("point", getpoint);

    local Kill_MVP_Desc = GET_CHILD_RECURSIVELY(frame, 'Kill_MVP_Desc');
    Kill_MVP_Desc:SetTextByKey("KillName", killName);

    local Kill_MVP_Point = GET_CHILD_RECURSIVELY(frame, 'Kill_MVP_Point');
    Kill_MVP_Point:SetTextByKey("KillCount", killCount);

    local Point_MVP_Desc = GET_CHILD_RECURSIVELY(frame, 'Point_MVP_Desc');
    Point_MVP_Desc:SetTextByKey("PointName", mineName);

    local Point_MVP_Point = GET_CHILD_RECURSIVELY(frame, 'Point_MVP_Point');
    Point_MVP_Point:SetTextByKey("PointCount", mineCount);

    if killCount == 0 then
        Kill_MVP_Desc:ShowWindow(0);
    end

    if mineCount == 0 then
        Point_MVP_Desc:ShowWindow(0);
    end

    local winBox = GET_CHILD_RECURSIVELY(frame, 'winBox');
    local loseBox = GET_CHILD_RECURSIVELY(frame, 'loseBox');
    local winUIBox = GET_CHILD_RECURSIVELY(frame, 'winUIBox');
    local loseUIBox = GET_CHILD_RECURSIVELY(frame, 'loseUIBox');
    if isWin == 1 then
        winBox:ShowWindow(1);
        loseBox:ShowWindow(0);
        drawBox:ShowWindow(0);

        if config.GetServiceNation() == 'GLOBAL' then
            imcSound.PlayMusicQueueLocal('colonywar_win')
        elseif config.GetServiceNation() == 'KOR' then
            imcSound.PlayMusicQueueLocal('colonywar_win_k')
        end

        if frame:GetUserValue('SERVICE_NATION') == 'KOR' then
            winBox:PlayUIEffect(WIN_EFFECT_NAME, EFFECT_SCALE, 'COLONY_WIN');
        else
            winUIBox:ShowWindow(1);
            loseUIBox:ShowWindow(0);
        end
    else
        winBox:ShowWindow(0);
        loseBox:ShowWindow(1);
        drawBox:ShowWindow(0);

        if config.GetServiceNation() == 'GLOBAL' then
            imcSound.PlayMusicQueueLocal('colonywar_lose')
        elseif config.GetServiceNation() == 'KOR' then
            imcSound.PlayMusicQueueLocal('colonywar_lose_k')
        end

        if frame:GetUserValue('SERVICE_NATION') == 'KOR' then            
            loseBox:PlayUIEffect(LOSE_EFFECT_NAME, EFFECT_SCALE, 'COLONY_LOSE');
        else
            winUIBox:ShowWindow(0);
            loseUIBox:ShowWindow(1);
        end
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