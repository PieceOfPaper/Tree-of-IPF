-- result UI
function SCR_PVP_MINE_END_UI_OPEN(pc)
    local aObj = GetAccountObj(pc)
    local zoneObj = GetLayerObject(pc);
    local TEAM_A_COUNT = GetMGameValue(pc, "TEAM_A_COUNT")
    local TEAM_B_COUNT = GetMGameValue(pc, "TEAM_B_COUNT")
    
    if TEAM_A_COUNT > TEAM_B_COUNT then
        if IsBuffApplied(pc, 'PVP_MINE_BUFF1') == 'YES' then
            ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(1)') -- win
        else
            ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(0)') -- lose
        end
    elseif TEAM_A_COUNT < TEAM_B_COUNT then
        if IsBuffApplied(pc, 'PVP_MINE_BUFF2') == 'YES' then
            ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(1)')
        else
            ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(0)')
        end
    else
        ExecClientScp(pc, 'PVP_MINE_RESULT_OPEN(0)')
    end
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
    -- elseif isWin == 3 then
    --     winBox:ShowWindow(0);
    --     loseBox:ShowWindow(0);
    --     drawBox:ShowWindow(1);
    end
end