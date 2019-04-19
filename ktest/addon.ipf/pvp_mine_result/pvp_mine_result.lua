function PVP_MINE_RESULT_REQ_RETURN_CITY(frame)
    control.CustomCommand('RETURN_FROM_PVP_MINE', 0);
    ui.CloseFrame('pvp_mine_result');
end

-- M = My Team, E = Enemy Team
function PVP_MINE_RESULT_OPEN(isWin, Team, Mkill1, Mkill2, Mkill3, Mkill4, Mkill5, Mscore1, Mscore2, Mscore3, Mscore4, Mscore5, Ekill1, Ekill2, Ekill3, Ekill4, Ekill5, Escore1, Escore2, Escore3, Escore4, Escore5, minekillinfo, minescoreinfo)
    local frame = ui.GetFrame('pvp_mine_result');
    frame:SetUserValue('SERVICE_NATION', config.GetServiceNation());
    if frame:GetUserValue('SERVICE_NATION') == 'KOR' then        
        COLONY_RESULT_SHOW_UI_MODE(frame, 0);
    else        
        COLONY_RESULT_SHOW_UI_MODE(frame, 1);
    end

    local M_kill_mvp_list = {};
    M_kill_mvp_list[1] = Mkill1;
    M_kill_mvp_list[2] = Mkill2;
    M_kill_mvp_list[3] = Mkill3;
    M_kill_mvp_list[4] = Mkill4;
    M_kill_mvp_list[5] = Mkill5;

    local M_score_mvp_list = {};
    M_score_mvp_list[1] = Mscore1;
    M_score_mvp_list[2] = Mscore2;
    M_score_mvp_list[3] = Mscore3;
    M_score_mvp_list[4] = Mscore4;
    M_score_mvp_list[5] = Mscore5;

    local E_kill_mvp_list = {};
    E_kill_mvp_list[1] = Ekill1;
    E_kill_mvp_list[2] = Ekill2;
    E_kill_mvp_list[3] = Ekill3;
    E_kill_mvp_list[4] = Ekill4;
    E_kill_mvp_list[5] = Ekill5;

    local E_score_mvp_list = {};
    E_score_mvp_list[1] = Escore1;
    E_score_mvp_list[2] = Escore2;
    E_score_mvp_list[3] = Escore3;
    E_score_mvp_list[4] = Escore4;
    E_score_mvp_list[5] = Escore5;

    PVP_MINE_RESULT_INIT(frame, isWin, Team, M_kill_mvp_list, M_score_mvp_list, E_kill_mvp_list, E_score_mvp_list, minekillinfo, minescoreinfo);
    frame:ShowWindow(1);
    end

function PVP_MINE_RESULT_INIT(frame, isWin, Team, M_kill_mvp_list, M_score_mvp_list, E_kill_mvp_list, E_score_mvp_list, minekillinfo, minescoreinfo)
    local WIN_EFFECT_NAME = frame:GetUserConfig('WIN_EFFECT_NAME');
    local LOSE_EFFECT_NAME = frame:GetUserConfig('LOSE_EFFECT_NAME');
    local EFFECT_SCALE = tonumber(frame:GetUserConfig('EFFECT_SCALE'));

    -- result animation, UI
    local winBox = GET_CHILD_RECURSIVELY(frame, 'winBox');
    local loseBox = GET_CHILD_RECURSIVELY(frame, 'loseBox');
    local winUIBox = GET_CHILD_RECURSIVELY(frame, 'winUIBox');
    local loseUIBox = GET_CHILD_RECURSIVELY(frame, 'loseUIBox');
    if isWin == 1 then
        winBox:ShowWindow(1);
        loseBox:ShowWindow(0);

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
    
    PVP_TEAM_TITLE_CREATE(frame, isWin, Team)

    local mykillrank = 0;
    local myscorerank = 0;

    local M_kill_mvp_list_gb = GET_CHILD_RECURSIVELY(frame, 'M_kill_mvp_list_gb');
    mykillrank = PVP_RESULT_LIST_CREATE(frame, M_kill_mvp_list_gb, M_kill_mvp_list, minekillinfo)
    
    local M_score_mvp_list_gb = GET_CHILD_RECURSIVELY(frame, 'M_score_mvp_list_gb');
    myscorerank = PVP_RESULT_LIST_CREATE(frame, M_score_mvp_list_gb, M_score_mvp_list, minescoreinfo)

    local E_kill_mvp_list_gb = GET_CHILD_RECURSIVELY(frame, 'E_kill_mvp_list_gb');
    PVP_RESULT_LIST_CREATE(frame, E_kill_mvp_list_gb, E_kill_mvp_list)

    local E_score_mvp_list_gb = GET_CHILD_RECURSIVELY(frame, 'E_score_mvp_list_gb');
    PVP_RESULT_LIST_CREATE(frame, E_score_mvp_list_gb, E_score_mvp_list)

    local getpoint, bouns = PVP_MINE_GET_POINT(isWin, mykillrank, myscorerank);
    local GetPoint_Desc = GET_CHILD_RECURSIVELY(frame, 'GetPoint_Desc');
    GetPoint_Desc:SetTextByKey("point", getpoint);

    local GetPoint_Bouns_Desc = GET_CHILD_RECURSIVELY(frame, 'GetPoint_Bouns_Desc');
    GetPoint_Bouns_Desc:SetTextByKey("point", bouns);
end

function PVP_TEAM_TITLE_CREATE(frame, isWin, Team)

    local M_result_bg = GET_CHILD_RECURSIVELY(frame, 'M_result_bg');
    local M_team_icon = GET_CHILD_RECURSIVELY(frame, 'M_team_icon');
    local M_team_name = GET_CHILD_RECURSIVELY(frame, 'M_team_name');

    local E_result_bg = GET_CHILD_RECURSIVELY(frame, 'E_result_bg');
    local E_team_icon = GET_CHILD_RECURSIVELY(frame, 'E_team_icon');
    local E_team_name = GET_CHILD_RECURSIVELY(frame, 'E_team_name');
    
    M_result_bg:ShowWindow(1);
    E_result_bg:ShowWindow(1);
    
    if isWin == 1 then
        M_result_bg:SetImage('title_frame_mine_pvp_win');
        E_result_bg:SetImage('title_frame_mine_pvp_lose');
    elseif isWin == 2 then
        M_result_bg:SetImage('title_frame_mine_pvp_lose');
        E_result_bg:SetImage('title_frame_mine_pvp_lose');
    else
        M_result_bg:SetImage('title_frame_mine_pvp_lose');
        E_result_bg:SetImage('title_frame_mine_pvp_win');
    end
    

    if Team == 1 then
        M_team_icon:SetImage('mine_pvp_teamicon_bladetryst_s')
        E_team_icon:SetImage('mine_pvp_teamicon_goldencroon_s')

        M_team_name:SetTextByKey("value", ClMsg('bladetryst'));
        E_team_name:SetTextByKey("value", ClMsg('goldencroon'));
    else
        M_team_icon:SetImage('mine_pvp_teamicon_goldencroon_s')
        E_team_icon:SetImage('mine_pvp_teamicon_bladetryst_s')
        
        M_team_name:SetTextByKey("value", ClMsg('goldencroon'));
        E_team_name:SetTextByKey("value", ClMsg('bladetryst'));
    end

end

function PVP_RESULT_LIST_CREATE(frame, listgb, mvplist, mineinfo)
    listgb:RemoveAllChild();    
    local rankmaxcount = frame:GetUserConfig("MVP_RANK_MAX_COUNT");
    local cnt = #mvplist;
    local mineteamname = "None";
    if mineinfo ~= nil then
        cnt = cnt + 1;
        local info = StringSplit(mineinfo, "#");
        mineteamname = info[3];
    end

    for i = 1, cnt do
        local controlsetname = "pvp_mine_mvp_list"
        if i == (rankmaxcount + 1) and mineinfo ~= nil then  -- my kill info   
            controlsetname = "pvp_mine_mvp_list_mine";
        end

        local mvpgb = listgb:CreateControlSet(controlsetname, "mvpgb"..i, 0, 0);
        if i % 2 == 1 and controlsetname == "pvp_mine_mvp_list" then
            mvpgb:SetSkinName("chat_window_2");
        end        
        mvpgb:Move(0, mvpgb:GetHeight() * (i-1))
        mvpgb:ShowWindow(1);        

        local infostr = "";
        local info = {};
        local strFind = "#"

        if i == (rankmaxcount + 1) and mineinfo ~= nil then  -- my kill info            
            local mvp_dot_gb = listgb:CreateControlSet("pvp_mine_mvp_pic_list", "mvpgb"..(i+1), 0, 0);
            mvp_dot_gb:Move(0, mvpgb:GetHeight() * (i-1))
            mvp_dot_gb:ShowWindow(1);    

            local offset = frame:GetUserConfig("MVP_LIST_RECT_OFFSET");
            local mvpgbrect = mvpgb:GetMargin();
            mvpgb:SetMargin(mvpgbrect.left, mvpgbrect.top + offset, mvpgbrect.right, mvpgbrect.bottom)
            
            infostr = mineinfo;
        else
            infostr = mvplist[i];
        end

        local info = StringSplit(infostr, "#");
        if info[1] ~= nil then
            local name = GET_CHILD(mvpgb, 'rank');
            local teamname = GET_CHILD(mvpgb, 'teamname');
            local score = GET_CHILD(mvpgb, 'score');
            
            if mineteamname == info[3] then
                if controlsetname == "pvp_mine_mvp_list" then
                    name:SetFormat("{@st66d_y}{s18}%s{/}");
                    teamname:SetFormat("{@st66d_y}{s18}%s{/}");                    
                    score:SetFormat("{@st66d_y}{s18}%s{/}");
                elseif controlsetname == "pvp_mine_mvp_list_mine" then
                    local gb = GET_CHILD(mvpgb, 'gb');
                    gb:SetBlink(0, 1, "66FFFFFF", 1);
                end                
            end

            if info[4] == '0' then
                name:SetTextByKey("value", "None");
                teamname:SetTextByKey("value", info[3]);                    
                score:SetTextByKey("value", info[4]);
            else
                name:SetTextByKey("value", info[2]);        
                teamname:SetTextByKey("value", info[3]);        
                score:SetTextByKey("value", info[4]);    
            end

            if i == rankmaxcount + 1 and mineinfo ~= nil and info[4] ~= '0' then
                return info[2];
            end
        end      

    end


end

function PVP_MINE_GET_POINT(isWin, killrank, scorerank)
    local MyPc = GetMyPCObject();
    local aObj = GetMyAccountObj();

    local mine_max = aObj.PVP_MINE_MAX
    if mine_max > 500 then
        mine_max = 500
    end

    -- Get Point
    local getpoint = mine_max * 3;
    local bouns = 0;

    -- killrank bouns
    if killrank == '1' then
        bouns = bouns + 450;
    elseif killrank == '2' then
        bouns = bouns + 250;
    elseif killrank == '3' then
        bouns = bouns + 150;
    elseif killrank == '4' then
        bouns = bouns + 100;
    elseif killrank == '5' then
        bouns = bouns + 50;
    end

    -- scorerank bouns
    if scorerank == '1' then
        bouns = bouns + 900;
    elseif scorerank == '2' then
        bouns = bouns + 500;
    elseif scorerank == '3' then
        bouns = bouns + 300;
    elseif scorerank == '4' then
        bouns = bouns + 200;
    elseif scorerank == '5' then
        bouns = bouns + 100;
    end
    
    if mine_max < 10 then
        getpoint = 0;
    end
    
    -- win, lose bouns
    if getpoint > 0 then
        if isWin == 1 then 
            getpoint = getpoint + 1500
        else
            getpoint = getpoint + 300
        end
    end
    
    return getpoint, bouns;
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