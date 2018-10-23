local json = require "json_imc"
function COLONY_POINT_INFO_ON_INIT(addon, frame)
    addon:RegisterMsg('UPDATE_COLONY_POINT', 'ON_UPDATE_COLONY_POINT');
    addon:RegisterMsg('OPEN_COLONY_POINT', 'OPEN_COLONY_POINT_UI');
    addon:RegisterMsg('UPDATE_OTHER_GUILD_EMBLEM', 'COLONY_POINT_INFO_UPDATE_EMBLEM');
    addon:RegisterMsg('COLONY_OCCUPATION_INFO_UPDATE', 'COLONY_POINT_INFO_INIT_OCCUPATION');

    addon:RegisterMsg('COLONY_BUILD_ICON_UPDATE', 'COLONY_BUILD_ICON_UPDATE');
    addon:RegisterMsg('COLONY_BUILD_ICON_REMOVE', 'COLONY_BUILD_ICON_REMOVE');

    g_COLONY_BUILD_GROUPNAME_OCCUPY = {"Defense", "Interrupt"}
    g_COLONY_BUILD_GROUPNAME_NOT_OCCUPY = {"Offense", "Divine_Flag"}

    g_COLONY_BUILD_OFFENSE = {}
    g_COLONY_BUILD_DEFENSE = {}
    g_COLONY_BUILD_DIVINE_FLAG = {}
    g_COLONY_BUILD_INTERRUPT = {}

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
    COLONY_BUILD_ICON_UPDATE()
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
    COLONY_BUILD_ICON_UPDATE()
    frame:Resize(frame:GetWidth(), infoBox:GetY() + infoBox:GetHeight());
end

function COLONY_POINT_INFO_INIT_OCCUPATION(frame)
    local mapClassName = GetZoneName();
    local mapCls = GetClass('Map', mapClassName);
    local occupyInfo = session.colonywar.GetOccupationInfoByMapID(mapCls.ClassID);
    if occupyInfo ~= nil then
        local occupyGuildNameText = GET_CHILD_RECURSIVELY(frame, 'occupyGuildNameText');
        local guildID = occupyInfo:GetGuildID();
        GetGuildEmblemImage("COLONY_EMBLEM_IMAGE_GET", guildID)
        
        frame:SetUserValue('OCCUPATION_GUILD_ID', guildID);
        occupyGuildNameText:SetText(occupyInfo:GetGuildName());
    end
    COLONY_BUILD_ICON_UPDATE()
end

function COLONY_EMBLEM_IMAGE_GET(code, return_json)
    local frame = ui.GetFrame("colony_point_info")
    local occupyGuildEmblemPic = GET_CHILD_RECURSIVELY(frame, 'occupyGuildEmblemPic');
    occupyGuildEmblemPic:SetImage("");
    if code ~= 200 then
        if code == 400 or code == 404 then
            return
        else
            SHOW_GUILD_HTTP_ERROR(code, return_json, "COLONY_EMBLEM_IMAGE_GET")
            return
        end
    end
    local mapClassName = GetZoneName();
    local mapCls = GetClass('Map', mapClassName);
    local occupyInfo = session.colonywar.GetOccupationInfoByMapID(mapCls.ClassID);
    if occupyInfo ~= nil then
        
        local guildID = occupyInfo:GetGuildID();
        local worldID = session.party.GetMyWorldIDStr();
        local emblemImgName = guild.GetEmblemImageName(guildID,worldID);
      
        occupyGuildEmblemPic:SetFileName(emblemImgName);
        
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
            emblemPic:SetImage("")
            if emblemImgName ~= 'None' then
                emblemPic:SetFileName(emblemImgName);
            else
                GetGuildEmblemImage("OPEN_COLONY_POINT_EMBLEM_GET", guildID);
            end
            frame:SetUserValue('RANKING_GUILD_ID_'..i, guildID);
            rankingBox:ShowWindow(1);
        end
    end
    COLONY_POINT_INFO_INIT_MY_GUILD(frame, maxPoint);
end

function OPEN_COLONY_POINT_EMBLEM_GET(code, ret_json)
    if code ~= 200 then
        if code == 400 or code == 404 then
            return
        else
            SHOW_GUILD_HTTP_ERROR(code, return_json, "OPEN_COLONY_POINT_EMBLEM_GET")
            return
        end
    end
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
        emblemCtrl:SetImage("");
        if emblemImgName ~= 'None' then   
            emblemCtrl:SetFileName(emblemImgName);
        else
            GetGuildEmblemImage("COLONY_POINT_INFO_UPDATE_EMBLEM_GET_IMAGE", argStr)
        end
    end
     IMC_LOG("INFO_NORMAL", "COLONY_POINT_INFO_UPDATE_EMBLEM ED");
end
function COLONY_POINT_INFO_UPDATE_EMBLEM_GET_IMAGE(code, ret_json)
    if code ~= 200 then
        if code == 400 or code == 404 then
            return
        else
            SHOW_GUILD_HTTP_ERROR(code, return_json, "COLONY_POINT_INFO_UPDATE_EMBLEM_GET_IMAGE")
            return
        end
    end
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
    if session.colonywar.IsUpdatedEndTime() == false then
        session.colonywar.RequestColonyWarEndTime()
    end    
    local remainTimeText = GET_CHILD_RECURSIVELY(frame, 'remainTimeText');
    remainTimeText:RunUpdateScript('COLONY_POINT_INFO_UPDATE_TIMER', 0.5);
end

function COLONY_POINT_INFO_UPDATE_TIMER(remainTimeText)
    if session.colonywar.IsUpdatedEndTime() == false then
        session.colonywar.RequestColonyWarEndTime()
        return 1
    end    
    local endTime = session.colonywar.GetEndTime();
    local remainTime = -1 * imcTime.GetDiffSecFromNow(endTime.wHour, endTime.wMinute, 0);
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

function COLONY_POINT_INFO_TAB_LBTN_UP(frame, ctrl)
    COLONY_BUILD_ICON_UPDATE()
end

function COLONY_POINT_INFO_SET_SAVED_OFFSET(frame, msg, argStr, argNum)  
    if session.colonywar.GetIsColonyWarMap() == false then
        return;
    end

    local channel = ui.GetFrame('channel');
    local defaultX = channel:GetGlobalX();
    local savedX, savedY = GET_CONFIG_HUD_OFFSET(frame, defaultX, frame:GetOriginalY());    
    savedX, savedY = GET_OFFSET_IN_SCREEN(savedX, savedY, frame:GetWidth(), frame:GetHeight());
    frame:SetOffset(savedX, savedY);
end


function COLONY_POINT_INFO_DRAW_BUFF_ICON()
    local buffFrame = ui.GetFrame("buff")
    local colonyFrame = ui.GetFrame("colony_point_info")
    if buffFrame == nil or colonyFrame == nil then
        return
    end

    if buffFrame:IsVisible() ~= 1 or colonyFrame:IsVisible() ~= 1 then
        return
    end

    local buffSlotset = GET_CHILD_RECURSIVELY(buffFrame, "buffslot")
    local buffSlotCount = buffSlotset:GetSlotCount()

    local colonyBuffSlotset = GET_CHILD_RECURSIVELY(colonyFrame, "buffSlotset")
    if buffSlotset == nil or colonyBuffSlotset == nil then
        return
    end

    colonyBuffSlotset:ClearIconAll()
    local colonyBuffCount = 0
    for i = 0, buffSlotCount - 1 do
        local buffSlot = buffSlotset:GetSlotByIndex(i)
        if buffSlot ~= nil then
            local buffIcon = buffSlot:GetIcon()
            if buffIcon ~= nil and buffSlot:IsVisible() == 1 then
                local buffIconInfo = buffIcon:GetInfo()
                local buffType = buffIconInfo.type
                local buffClass = GetClassByType("Buff", buffType)
                local buffKeyWord = TryGetProp(buffClass, 'Keyword')
                if buffKeyWord ~= nil then
                    local keyWordList = SCR_STRING_CUT(buffKeyWord, ';');
                    local isColonyBuff = 0
                    for i = 1, #keyWordList do
                        local searchWord = keyWordList[i]
                        if tostring(searchWord) == "GuildColonyBuffMark" then
                            isColonyBuff = 1
                        end
                    end

                    if isColonyBuff == 1 then
                        local totalSlotCount = colonyBuffSlotset:GetSlotCount()
                        local slotIndex = totalSlotCount - colonyBuffCount - 1
                        if slotIndex < 0 then
                            slotIndex = 0 
                        end

                        local colonyBuffSlot = colonyBuffSlotset:GetSlotByIndex(slotIndex)
                        colonyBuffSlot:SetUserValue("buffType", buffType)    
                        local colonyBuffIcon = CreateIcon(colonyBuffSlot)
                        local imageName = 'icon_' .. buffClass.Icon;
            
                        local handle = session.GetMyHandle()
                        if tonumber(handle) == nil then
                            return; 
                        end

                        local buff = info.GetBuff(tonumber(handle), buffType);
                        if nil == buff then
                            return;
                        end
                        
                        if buff.over > 1 then
                            colonyBuffSlot:SetText('{s13}{ol}{b}'..buff.over, 'count', 'right', 'bottom', -5, -3);
                        else
                            colonyBuffSlot:SetText("");
                        end

                        colonyBuffIcon:SetTooltipType('buff');
                        colonyBuffIcon:SetTooltipArg(handle, buffType);
                        colonyBuffIcon:Set(imageName, 'BUFF', buffType, 0);

                        colonyBuffCount = colonyBuffCount + 1
                  --      colonyBuffSlot:Invalidate()
                    end
                end

            end
        end
    end
 --   colonyBuffSlotset:Invalidate()
end

function COLONY_BUILD_ICON_UPDATE()
    local colonyFrame = ui.GetFrame("colony_point_info")
    if colonyFrame == nil then
        return
    end

    local isOccupy = 0
    local myHandle = session.GetMyHandle()
    if myHandle == nil then
        return
    end

    local colonyHUD = ui.GetFrame("COLONY_HUD_" .. myHandle)
    if colonyHUD == nil then
        return
    end

    local occupationPic = GET_CHILD_RECURSIVELY(colonyHUD, "occupationPic")
    if occupationPic ~= nil and occupationPic:IsVisible() == 1 then
        isOccupy = 1
    end

    local viewBuildGroupList = {}
    if isOccupy == 0 then
        viewBuildGroupList = g_COLONY_BUILD_GROUPNAME_NOT_OCCUPY
    else
        viewBuildGroupList = g_COLONY_BUILD_GROUPNAME_OCCUPY
    end

    for i = 1, #viewBuildGroupList do

        local buildSlotsetName = "buildSlotset" .. isOccupy + 1 .. "_" .. i
        local buildSlotset = GET_CHILD_RECURSIVELY(colonyFrame, buildSlotsetName)
        buildSlotset:ClearIconAll()
        local myBuildBox = GET_CHILD_RECURSIVELY(colonyFrame, "occupynameBox" .. isOccupy + 3 .. "_" .. i)
        local hideBuildBox = GET_CHILD_RECURSIVELY(colonyFrame, "occupynameBox" .. 4 - isOccupy .. "_" .. i)
        if buildSlotset == nil or myBuildBox == nil or hideBuildBox == nil then
            return
        end
        
        myBuildBox:ShowWindow(1)
        hideBuildBox:ShowWindow(0)

        local groupName = "GuildColony_" .. viewBuildGroupList[i] .. "_Object"
        local cnt = session.guildbuilding.GetHandleCountByGroup(groupName);
        local slotIndex = 0

        local buildingList = {}
        for j = 0, cnt - 1 do
            local gbinfo = session.guildbuilding.GetHandleByGroup(groupName, j);
            if gbinfo ~= nil then
                local buildinginfo = session.guildbuilding.GetByHandle(gbinfo.handle);
                local guildID = buildinginfo:GetGuildID()
                local myGuild = GET_MY_GUILD_INFO();
                if myGuild ~= nil then
                    local myGuildID = myGuild.info:GetPartyID();
                    if guildID == myGuildID then
                        local isExistInList = 0
                        for classID, count in pairs(buildingList) do
                            if classID == gbinfo.classID then
                                table.insert(buildingList, gbinfo.classID, count + 1)
                                
                                isExistInList = 1
                            end
                        end

                        if isExistInList == 0 then
                            table.insert(buildingList, gbinfo.classID, 1)
                            
                        end
                    end
                end
            end
        end

        local totalBuildingCount = 0
        for gbClassID, count in pairs(buildingList) do
            if gbClassID ~= nil then
                local gbCls = GetClassByType("Monster", gbClassID)
                if gbCls ~= nil then
                    local slot = buildSlotset:GetSlotByIndex(slotIndex)
                    if slot ~= nil then
                        local icon = CreateIcon(slot)
                        icon:SetImage(gbCls.Icon)
                        slot:SetText(count, "count", "right", "bottom", 2, 1)
                        slotIndex = slotIndex + 1
                        totalBuildingCount = totalBuildingCount + count
                    end
                end
            end
        end

        local buildingCountValueName = "deploy" .. viewBuildGroupList[i] .. "_Value"
        local buildingCountValue = GET_CHILD_RECURSIVELY(colonyFrame, buildingCountValueName)

        local colonyRuleCls = GetClass("guild_colony_rule", "GuildColony_Rule_Default");
        local maxCountProp = "GuildColony_" .. viewBuildGroupList[i] .. "_Object_MaxCount"
        local maxCount = colonyRuleCls[maxCountProp];

        buildingCountValue:SetTextByKey("curCount", totalBuildingCount)
        buildingCountValue:SetTextByKey("maxCount", maxCount)
    end
end