
function COLONY_POINT_INFO_ON_INIT(addon, frame)
    addon:RegisterMsg('UPDATE_COLONY_POINT', 'ON_UPDATE_COLONY_POINT');
    addon:RegisterMsg('OPEN_COLONY_POINT', 'OPEN_COLONY_POINT_UI');
    addon:RegisterMsg('UPDATE_OTHER_GUILD_EMBLEM', 'COLONY_POINT_INFO_UPDATE_EMBLEM');
    addon:RegisterMsg('COLONY_OCCUPATION_INFO_UPDATE', 'COLONY_POINT_INFO_INIT_OCCUPATION');

    g_COLONY_POINT_THRESHOLD = nil;
    g_COLONY_POINT_SYTLE = nil;
end

function OPEN_COLONY_POINT_UI(frame, msg)
    ui.CloseFrame('questinfoset_2');
    COLONY_POINT_INFO_INIT(frame);
    COLONY_POINT_INFO_INIT_OCCUPATION(frame);
    COLONY_POINT_INFO_RESET(frame);
    COLONY_POINT_INFO_INIT_TIMER(frame);
    COLONY_POINT_INFO_SET_SAVED_OFFSET(frame, msg, argStr, argNum);
    frame:ShowWindow(1);
end

function COLONY_POINT_INFO_INIT(frame)
    COLONY_POINT_INFO_EXPAND_CLICK(frame);
end

function COLONY_POINT_INFO_MINIMIZE_CLICK(parent, ctrl)
    local frame = parent:GetTopParentFrame();
    local expandBtn = GET_CHILD_RECURSIVELY(frame, 'expandBtn');
    local infoBox = GET_CHILD_RECURSIVELY(frame, 'infoBox');
    expandBtn:ShowWindow(1);
    infoBox:ShowWindow(0);

    frame:Resize(frame:GetWidth(), expandBtn:GetY() + expandBtn:GetHeight());
end

function COLONY_POINT_INFO_EXPAND_CLICK(parent, ctrl)
    local frame = parent:GetTopParentFrame();
    local expandBtn = GET_CHILD_RECURSIVELY(frame, 'expandBtn');
    local infoBox = GET_CHILD_RECURSIVELY(frame, 'infoBox');
    expandBtn:ShowWindow(0);
    infoBox:ShowWindow(1);

    frame:Resize(frame:GetWidth(), infoBox:GetY() + infoBox:GetHeight());
end

function COLONY_POINT_INFO_INIT_OCCUPATION(frame)
    local mapClassName = GetZoneName();
    local mapCls = GetClass('Map', mapClassName);

    local occupyInfo = session.colonywar.GetOccupationInfoByMapID(mapCls.ClassID);
    if occupyInfo ~= nil then
        local occupyGuildNameText = GET_CHILD_RECURSIVELY(frame, 'occupyGuildNameText');
    local occupyGuildEmblemPic = GET_CHILD_RECURSIVELY(frame, 'occupyGuildEmblemPic');
        local guildID = occupyInfo:GetGuildID();
        local worldID = session.party.GetMyWorldIDStr();
        local emblemImgName = guild.GetEmblemImageName(guildID,worldID);
        if emblemImgName ~= 'None' then
            occupyGuildEmblemPic:SetImage(emblemImgName);
        else
            local worldID = session.party.GetMyWorldIDStr();
            guild.ReqEmblemImage(guildID,worldID);
        end
        frame:SetUserValue('OCCUPATION_GUILD_ID', guildID);
        occupyGuildNameText:SetText(occupyInfo:GetGuildName());
    end
end

function COLONY_POINT_INFO_RESET(frame)
     for i = 1, 3 do
        local rankingBox = GET_CHILD_RECURSIVELY(frame, 'rankingBox'..i);
        rankingBox:ShowWindow(0);
    end
end

function ON_UPDATE_COLONY_POINT(frame, msg, argStr, argNum)
    local curZone = GetZoneName();
    local mapCls = GetClass('Map', curZone);
    local colonyRuleCls = GetClass('guild_colony_rule', 'GuildColony_Rule_Default');
    local maxPoint = colonyRuleCls.MaxPoint;

    for i = 1, 3 do
        local rankingBox = GET_CHILD_RECURSIVELY(frame, 'rankingBox'..i);
        local pointInfo = session.colonywar.GetPointInfoByIndex(i - 1);        
        if pointInfo == nil or pointInfo:GetLocationID() ~= mapCls.ClassID then
            rankingBox:ShowWindow(0);
        else
            local nameText = rankingBox:GetChild('nameText');
            local pointText = rankingBox:GetChild('pointText');
            nameText:SetText(pointInfo:GetGuildName());            
            pointText:SetTextByKey('cur', pointInfo.locationPoint);
            pointText:SetTextByKey('max', maxPoint);

            local guildID = pointInfo:GetGuildID();
            local worldID = session.party.GetMyWorldIDStr();
            local emblemPic = GET_CHILD(rankingBox, 'emblemPic');
            local emblemImgName = guild.GetEmblemImageName(guildID,worldID);
            if emblemImgName ~= 'None' then
                emblemPic:SetImage(emblemImgName);
            else
                local worldID = session.party.GetMyWorldIDStr();
                guild.ReqEmblemImage(guildID,worldID);
            end
            frame:SetUserValue('RANKING_GUILD_ID_'..i, guildID);
            rankingBox:ShowWindow(1);
        end
    end
    COLONY_POINT_INFO_INIT_MY_GUILD(frame, maxPoint);
end

function COLONY_POINT_INFO_UPDATE_EMBLEM(frame, msg, argStr, argNum)
    local emblemCtrl = nil;
    local rankingBox = nil;
    if frame:GetUserValue('OCCUPATION_GUILD_ID') == argStr then
        emblemCtrl = GET_CHILD_RECURSIVELY(frame, 'occupyGuildEmblemPic');
    elseif frame:GetUserValue('RANKING_GUILD_ID_1') == argStr then
        rankingBox = GET_CHILD_RECURSIVELY(frame, 'rankingBox1');
    elseif frame:GetUserValue('RANKING_GUILD_ID_2') == argStr then
        rankingBox = GET_CHILD_RECURSIVELY(frame, 'rankingBox2');
    elseif frame:GetUserValue('RANKING_GUILD_ID_3') == argStr then
        rankingBox = GET_CHILD_RECURSIVELY(frame, 'rankingBox3');
    end
    if rankingBox ~= nil then
        emblemCtrl = GET_CHILD(rankingBox, 'emblemPic');
    end

     IMC_LOG("INFO_NORMAL", "COLONY_POINT_INFO_UPDATE_EMBLEM ST");
    if emblemCtrl ~= nil then
        local worldID = session.party.GetMyWorldIDStr();
        local emblemImgName = guild.GetEmblemImageName(argStr,worldID);
         IMC_LOG("INFO_NORMAL", "COLONY_POINT_INFO_UPDATE_EMBLEM info" .. "imageName:" .. emblemImgName);
        if emblemImgName ~= 'None' then   
            emblemCtrl:SetImage(emblemImgName);
        end
    end
     IMC_LOG("INFO_NORMAL", "COLONY_POINT_INFO_UPDATE_EMBLEM ED");
end

function COLONY_POINT_INFO_INIT_MY_GUILD(frame, maxPoint)
    if g_COLONY_POINT_THRESHOLD == nil then
        COLONY_POINT_INFO_INIT_STYLE(frame);
    end

    local TOTAL_STEP_COUNT = tonumber(frame:GetUserConfig('TOTAL_STEP_COUNT'));
    local mapBox = GET_CHILD_RECURSIVELY(frame, 'mapBox');    
    local myGuildPointText = mapBox:GetChild('myGuildPointText');
    local myGuildPointInfo = session.colonywar.GetMyGuildPointInfo();
    if myGuildPointInfo == nil then
        myGuildPointText:SetTextByKey('cur', 0);
    else
        local myPoint = myGuildPointInfo.locationPoint;
        for i = 1, TOTAL_STEP_COUNT do            
            if myPoint <= g_COLONY_POINT_THRESHOLD[i] then
                myGuildPointText:SetTextByKey('style', g_COLONY_POINT_SYTLE[i]);
                break;
            end
        end
        myGuildPointText:SetTextByKey('cur', myPoint);
    end
    myGuildPointText:SetTextByKey('max', maxPoint);
end

function COLONY_POINT_INFO_INIT_STYLE(frame)
    if g_COLONY_POINT_THRESHOLD ~= nil then
        return;
    end
    g_COLONY_POINT_THRESHOLD = {};
    g_COLONY_POINT_SYTLE = {};

    local TOTAL_STEP_COUNT = tonumber(frame:GetUserConfig('TOTAL_STEP_COUNT'));
    for i = 1, TOTAL_STEP_COUNT do
        local MY_GUILD_STEP = tonumber(frame:GetUserConfig('MY_GUILD_STEP'..i));
        local MY_GUILD_STEP_STYLE = frame:GetUserConfig('MY_GUILD_STEP_STYLE'..i);
        g_COLONY_POINT_THRESHOLD[i] = MY_GUILD_STEP;
        g_COLONY_POINT_SYTLE[i] = MY_GUILD_STEP_STYLE;
    end
end

function COLONY_POINT_INFO_INIT_TIMER(frame)
    local remainTimeText = GET_CHILD_RECURSIVELY(frame, 'remainTimeText');
    remainTimeText:RunUpdateScript('COLONY_POINT_INFO_UPDATE_TIMER', 0.2);
end

function COLONY_POINT_INFO_UPDATE_TIMER(remainTimeText)
    local ruleCls = GetClass('guild_colony_rule', 'GuildColony_Rule_Default');
    local remainTime = -1 * imcTime.GetDiffSecFromNow(ruleCls.ColonyEndHour, ruleCls.ColonyEndMin, 0);
    if remainTime <= 0 then
        return 0;
    end

    local remainMin = math.floor(remainTime / 60);
    local remainSec = remainTime % 60;
    local remainTimeStr = string.format('%d:%02d', remainMin, remainSec);
    remainTimeText:SetTextByKey('time', remainTimeStr);
    return 1;
end

function COLONY_POINT_INFO_LBTN_UP(frame, ctrl)
    if session.colonywar.GetIsColonyWarMap() == false then
        return;
    end
    SET_CONFIG_HUD_OFFSET(frame);
end

function COLONY_POINT_INFO_SET_SAVED_OFFSET(frame, msg, argStr, argNum)    
    if session.colonywar.GetIsColonyWarMap() == false then
        return;
    end
    local oriMargin = frame:GetOriginalMargin(); 
    local savedX, savedY = GET_CONFIG_HUD_OFFSET(frame, option.GetClientWidth() - oriMargin.right, frame:GetOriginalY());    
    savedX, savedY = GET_OFFSET_IN_SCREEN(savedX, savedY, frame:GetWidth(), frame:GetHeight());    
    frame:SetOffset(savedX, savedY);
end