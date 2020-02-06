-- sudden quest 
function SUDDENQUEST_ON_INIT(addon, frame)

end

function SUDDENQUEST_ON_RELOAD(frame)
    local mapId = session.GetMapID();
    local limitTime = 900000;
    local killCnt = 200;        -- Default Cond Kill Count
    local monNames = "Amacalf";
    local questType = "KillMon";
    if frame ~= nil then
        SUDDENQUEST_FILL_QUEST_INFO(frame, mapId, questType, monNames, killCnt, limitTime);
    end

    SUDDENQUEST_FRAME_RESIZE(frame, 0);
end

function SUDDENQUEST_OPEN(dataStr)
    if dataStr == nil then return end
    ui.OpenFrame("suddenquest");

    local frame = ui.GetFrame("suddenquest");
    if frame == nil then return end
    local datas = StringSplit(dataStr, ":");
    if datas ~= nil then
        local mapId = datas[1];
        local limitTime = tonumber(datas[2]);
        local killCnt = tonumber(datas[3]);
        local monNames = StringSplit(datas[4], ";");
        local questType = datas[5]; 
        local frame = ui.GetFrame("suddenquest");
        if frame ~= nil then
            frame:SetUserConfig("SOBJ_NAME", datas[6]);
            SUDDENQUEST_FILL_QUEST_INFO(frame, mapId, questType, monNames, killCnt, limitTime);
        end
    end  

    SUDDENQUEST_FRAME_RESIZE(frame, 0);
end

function SUDDENQUEST_FILL_QUEST_INFO(frame, mapId, questType, targetMonName, killCnt, limitTime)
    if frame == nil then return end

    -- quest infomation
    local gbox_questInfo = GET_CHILD_RECURSIVELY(frame, "gbox_quest_info");
    if gbox_questInfo ~= nil then
        local ctrlSet = gbox_questInfo:CreateOrGetControlSet("suddenquest_info", "CTRLSET_SUDDENQUEST_INFO", 0, 0);

        local monName = "";                
        --[[ local count = #targetMonName;
        if count > 1 then
            for i = 1, count do
                local monCls = GetClass("Monster", targetMonName[i]);
                if monCls ~= nil and i == 1 then
                    monName = monCls.Name;
                elseif monCls ~= nil and i > 1 then
                    monName = monName.." / "..monCls.Name;
                end
            end
        elseif count == 1 then
            local monCls = GetClass("Monster", targetMonName[1]);
            monName = monCls.Name;
        end ]]

        if ctrlSet ~= nil then
            local gbox_questDetailed = GET_CHILD_RECURSIVELY(ctrlSet, "gbox_quest_detailed");
            if gbox_questDetailed ~= nil then
                local detailedText =  GET_CHILD_RECURSIVELY(gbox_questDetailed, "quest_detailed_text");

                local mapName = GET_MAP_NAME(mapId);
                local questText = ClMsg("SuddenQuest_StartText");
                local missionText = "";
                if questType == "KillMon" then
                    missionText = ClMsg("SuddenQuest_KillMon_Detailed");
                    missionText = '{#ff4040}'..missionText..'{/}';
                end

                detailedText:SetTextByKey("mapName", mapName);
                detailedText:SetTextByKey("quest_text", questText);
                detailedText:SetTextByKey("quest_mission", missionText);
                detailedText:SetTextAlign("center", "center");
                
                local deatiledText_Notice = GET_CHILD_RECURSIVELY(gbox_questDetailed, "quest_notice_text");
                local noticeText_1 = ClMsg("SuddenQuest_NotIncludeChallengeMon");
                deatiledText_Notice:SetTextByKey("quest_notice1", noticeText_1);
                local noticeText_2 = ClMsg("SuddenQuest_DoNotZoneMove");
                deatiledText_Notice:SetTextByKey("quest_notice2", noticeText_2);
                deatiledText_Notice:SetTextAlign("center", "center");
            end

            local quest_object_text = GET_CHILD_RECURSIVELY(frame, "quest_object_text");
            quest_object_text:SetTextByKey("killText", ClMsg("SuddenQuest_KillText"));

            local killCntText = "0/"..killCnt;
            quest_object_text:SetTextByKey("killCount", tostring(killCntText));
            quest_object_text:SetUserValue("SUDDEN_QUEST_CONDKILLCOUNT", killCnt);
        end
    end

    -- quest timer
    local gbox_questtimer = GET_CHILD_RECURSIVELY(frame, "gbox_quest_timer");
    if gbox_questtimer ~= nil then
        local textTimer = GET_CHILD_RECURSIVELY(gbox_questtimer, "suddenquest_timer");
        textTimer:SetUserValue("SUDDEN_QUEST_START_TIME", tostring(imcTime.GetAppTimeMS()));
        textTimer:SetUserValue("SUDDEN_QUEST_LIMIT_TIME", limitTime);
        
        textTimer:StopUpdateScript("CHALLENGE_MODE_TIMER");
        textTimer:RunUpdateScript("SUDDENQUEST_TIMER");        
    end

    frame:Invalidate();
end

function SUDDENQUEST_TIMER(textTimer)
    local startTime = textTimer:GetUserValue("SUDDEN_QUEST_START_TIME");
    if startTime == nil then 
        return 0;
    end

    local limitTime = tonumber(textTimer:GetUserValue("SUDDEN_QUEST_LIMIT_TIME"));
    if limitTime == nil then
        return 0;
    end

    limitTime = limitTime / 1000;
    local nowTime = imcTime.GetAppTimeMS();
    local diffTime = (nowTime - startTime) / 1000;
    local remainTime = tonumber(limitTime) - diffTime;
    if remainTime < 0 then
        textTimer:SetTextByKey('time', "00:00");
        SUDDENQUEST_YESSCP_EXITMSGBOX();
        return 0;
    end

    local remainMin = math.floor(remainTime / 60);
    local remainSec = remainTime % 60;
    local remainTimeStr = string.format("%d:%02d", remainMin, remainSec);
    textTimer:SetTextByKey("time", remainTimeStr);

    local frame = ui.GetFrame("suddenquest");
    if frame ~= nil then
        local timeGauge = GET_CHILD_RECURSIVELY(frame, "suddenquest_timegauge");
        timeGauge:SetMaxPointWithTime(diffTime, limitTime, 0.1, 0.5);
    end

    return 1;
end

function SUDDENQUEST_MONCOUNT_UPDATE(killCnt)
    local frame = ui.GetFrame("suddenquest");
    if frame == nil then 
        return; 
    end

    local quest_object_text = GET_CHILD_RECURSIVELY(frame, "quest_object_text");
    local condCnt = tonumber(quest_object_text:GetUserValue("SUDDEN_QUEST_CONDKILLCOUNT"));

    if condCnt == nil then
        return;
    end

    if tonumber(killCnt) >= condCnt then
        -- quest Sucess reward
        control.CustomCommand("DPK_QUEST_REWARD_ITEM", 1);
        SUDDENQUEST_YESSCP_EXITMSGBOX();
        frame:Invalidate();
        return;
    end

    local killCntText = killCnt.."/"..condCnt;
    quest_object_text:SetTextByKey("killCount", killCntText);
    frame:Invalidate();
end

function SUDDENQUEST_MODE_CHANGE(frame)
    if frame == nil then return end
    local frameMode = tonumber(frame:GetUserConfig("FRAME_MODE"));
    if frameMode == 0 then
        -- min mode
        frame:SetUserConfig("FRAME_MODE", 1);
    else
        -- max mode
        frame:SetUserConfig("FRAME_MODE", 0);
    end

    SUDDENQUEST_FRAME_RESIZE(frame, frameMode);
end

function SUDDENQUEST_FRAME_RESIZE(frame, mode)
    if frame == nil then return end
    local gbox = GET_CHILD_RECURSIVELY(frame, "gbox");
    local gbox_quest_timer = GET_CHILD_RECURSIVELY(frame, "gbox_quest_timer");

    local gbox_questInfo = GET_CHILD_RECURSIVELY(frame, "gbox_quest_info");
    if gbox_questInfo == nil then return; end

    local ctrlSet = GET_CHILD_RECURSIVELY(gbox_questInfo, "CTRLSET_SUDDENQUEST_INFO");
    if ctrlSet == nil then return; end

    local gbox_quest_detailed = GET_CHILD_RECURSIVELY(ctrlSet, "gbox_quest_detailed");
    if mode == 0 then
       -- max
       local frame_width = tonumber(frame:GetUserConfig("FRAME_WIDTH"));
       local frame_height = tonumber(frame:GetUserConfig("FRAME_HEIGHT"));
       frame:Resize(frame:GetX(), frame:GetY(), frame_width, frame_height);

       local info_gbox_width = tonumber(frame:GetUserConfig("INFO_GBOX_WIDTH"));
       local info_gbox_height = tonumber(frame:GetUserConfig("INFO_GBOX_HEIGHT"));
       gbox_questInfo:Resize(0, 40, info_gbox_width, info_gbox_height);

       local deatiled_gbox_width = tonumber(frame:GetUserConfig("DETAILGBOX_WIDTH"));
       local deatiled_gbox_height = tonumber(frame:GetUserConfig("DETAILGBOX_HEIGHT"));
       gbox_quest_detailed:SetVisible(1);
       gbox_quest_detailed:Resize(0, 0, deatiled_gbox_width, deatiled_gbox_height);

       local ctrlSet_width = tonumber(frame:GetUserConfig("CTRLSET_WIDTH"));
       local ctrlSet_height = tonumber(frame:GetUserConfig("CTRLSET_HEIGHT"));
       ctrlSet:Resize(ctrlSet:GetX(), ctrlSet:GetY(), ctrlSet_width, ctrlSet_height);

       local timer_width = tonumber(frame:GetUserConfig("TIMER_GBOX_WIDTH"));
       local timer_height = tonumber(frame:GetUserConfig("TIMER_GBOX_HEIGHT"));
       gbox_quest_timer:Resize(gbox_quest_timer:GetX(), gbox_quest_timer:GetY(), timer_width, timer_height);

    elseif mode == 1 then
       -- min
       gbox_quest_detailed:SetVisible(0);
       gbox_quest_detailed:Resize(0, 0, 0, 0);

       local info_gbox_width = tonumber(frame:GetUserConfig("INFO_GBOX_WIDTH"));
       gbox_questInfo:Resize(0, 40, 0, 0);

       local frame_width = tonumber(frame:GetUserConfig("FRAME_WIDTH"));
       local frame_resize_height = tonumber(frame:GetUserConfig("FRAME_RESIZE_HEIGHT"));
       frame:Resize(frame:GetX(), frame:GetY(), frame_width, frame_resize_height);

       local timer_width = tonumber(frame:GetUserConfig("TIMER_GBOX_WIDTH"));
       local timer_height = tonumber(frame:GetUserConfig("TIMER_GBOX_HEIGHT"));
       gbox_quest_timer:Resize(gbox_quest_timer:GetX(), gbox_quest_timer:GetY(), timer_width, timer_height);
    end
    
    GBOX_AUTO_ALIGN(ctrlSet, 0, 0, 0, true, true, false);   
    GBOX_AUTO_ALIGN(gbox_questInfo, 0, 0, 0, true, true, false);
    GBOX_AUTO_ALIGN(gbox, 5, 2, 0, true, true, false);
    frame:Invalidate();
end

function SUDDENQUEST_CLOSE_BTN(frame)
    local yesScp = string.format("SUDDENQUEST_YESSCP_EXITMSGBOX()");
    ui.MsgBox(ScpArgMsg("SuddenQuest_Exit_Question"), yesScp, "None");
end

function SUDDENQUEST_YESSCP_EXITMSGBOX()
    local frame = ui.GetFrame("suddenquest");
    if frame ~= nil then
        local sObjName = frame:GetUserConfig("SOBJ_NAME");
        if sObjName ~= nil then
            quest.DPK_Quest_Destory_SessionObj(sObjName);
        end
    end
    
    SUDDENQUEST_RESET();
    ui.CloseFrame("suddenquest");
end

function SUDDENQUEST_RESET()
    local frame = ui.GetFrame("suddenquest");
    if frame == nil then return end

    local gbox_questInfo = GET_CHILD_RECURSIVELY(frame, "gbox_quest_info");
    if gbox_questInfo ~= nil then
        local cnt = gbox_questInfo:GetChildCount();
        for i = 0, cnt - 1 do
            local child = gbox_questInfo:GetChildByIndex(i);
            if child ~= nil and string.find(child:GetName(), "CTRLSET_") then
                frame:RemoveChild(child:GetName());
                frame:Invalidate();
            end
        end
    end 

    SUDDENQUEST_FRAME_RESIZE(frame, 0);

    frame:SetVisible(0);
    frame:SetUserConfig("FRAME_MODE", 0);
    frame:SetUserConfig("SOBJ_NAME", "");
    ui.CloseFrame("suddenquest");
end

