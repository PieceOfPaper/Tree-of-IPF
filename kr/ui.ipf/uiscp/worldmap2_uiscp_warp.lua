-- worldmap2_uiscp_warp.lua

-- 워프 타입
function GET_WARP_MAP_TYPE()
    local frame = ui.GetFrame("worldmap2_mainmap")
    local warpType = frame:GetUserValue("WARP_TYPE")

    if warpType == "None" or warpType == nil then
        return "None"
    end

    return warpType
end

-- 워프 가격
function GET_WARP_COST(mapName)
    local warpCost = math.max(geMapTable.CalcWarpCostBind(AMMEND_NOW_ZONE_NAME(GetZoneName()), mapName), 0)

    -- 토큰 사용중일 경우 무료
    if session.loginInfo.IsPremiumState(ITEM_TOKEN) then
        warpCost = 0
    end

    -- 마을 대상일 경우 무료
    local mapData = GetClass("Map", mapName)
    if mapData.MapType == "City" then
        warpCost = 0
    end

    -- 마지막 워프 지점(로비맵)일 경우 무료
    local lobbyMap = GET_MY_LAST_WARP_POSITION()
    if lobbyMap ~= nil and lobbyMap == mapName then
        warpCost = 0
    end

    return warpCost
end

-- 워프 툴팁
function GET_WARP_COST_TOOLTIP(mapName)
    local warpCost = math.max(geMapTable.CalcWarpCostBind(AMMEND_NOW_ZONE_NAME(GetZoneName()), mapName), 0)

    -- 워프맵 인자들 전달
    local warpFrame = ui.GetFrame("worldmap2_mainmap")
    local warpType = warpFrame:GetUserValue("Type")
    local warpItem = warpFrame:GetUserValue('SCROLL_WARP')

    -- 조각상 or 아이템일 경우 툴팁 없음
    if warpType == "Dievdirbys" or warpType == 'Normal' then
        return nil
    end
    
    -- 워프 아이템이 존재할 경우 툴팁 없음
    if warpItem ~= 'NO' and warpItem ~= 'None' then
        return nil
    end
    
    -- 마을 대상일 경우 무료
    local mapData = GetClass("Map", mapName)
    if mapData.MapType == "City" then
        return "0"
    end

    -- 마지막 워프 지점(로비맵)일 경우 무료
    local lobbyMap = GET_MY_LAST_WARP_POSITION()
    if lobbyMap ~= nil and lobbyMap == mapName then
        return "0"
    end

    -- 토큰 사용중일 경우 할인가격 표기
    if session.loginInfo.IsPremiumState(ITEM_TOKEN) then
        return "{cl}"..warpCost.."{/} 0"
    end
        
    return tostring(warpCost)
end

-- 워프맵 접근 함수
function INTE_WARP_OPEN_BY_NPC()
    local frame = ui.GetFrame('worldmap2_mainmap')
    frame:SetUserValue("WARP_TYPE", "NPC")
    frame:ShowWindow(1)
    frame:Invalidate()
end

function INTE_WARP_OPEN_NORMAL()
    local frame = ui.GetFrame('worldmap2_mainmap')
    frame:SetUserValue("WARP_TYPE", "Normal")
    frame:ShowWindow(1)
    frame:Invalidate()
end

function INTE_WARP_OPEN_DIB()
    local frame = ui.GetFrame('worldmap2_mainmap')
    frame:SetUserValue("WARP_TYPE", "Dievdirbys")
    frame:ShowWindow(1)
    frame:Invalidate()
end

function INTE_WARP_OPEN_FOR_QUICK_SLOT()

    -- 현재 폐기된 로직, 워프 스크롤 관련 로직은 TRY_TO_USE_WARP_ITEM 참조

    -- local frame = ui.GetFrame('worldmap2')
    -- frame:SetUserValue("SCROLL_WARP", 'YES')
    -- frame:ShowWindow(1)
    -- frame:Invalidate()
end

-- 워프 로직
function WARP_TO_AREA(mapName)
    local subMapData = nil
    local subMapDataList = SCR_GET_XML_IES("worldmap2_submap_data", "MapName", mapName)

    for i = 1, #subMapDataList do
        if subMapDataList[i].IsInEpisode == "YES" then
            subMapData = subMapDataList[i]
            break
        end
    end

    if subMapData.DungeonName == "None" then
        REQUEST_WARP_TO_AREA(mapName)
    else
        WARP_TO_DUNGEON_AREA(subMapData.DungeonName)
    end
end

function WARP_TO_DUNGEON_AREA(dungeonName)
    local frame = ui.GetFrame('worldmap2_submap')
    local zoneSet = AUTO_CAST(frame:GetChild(dungeonName))

    local dungeonList = SCR_GET_XML_IES("worldmap2_submap_data", "DungeonName", dungeonName)
    local dungeonCount = 0

    for i = 1, #dungeonList do
        local mapName = dungeonList[i].MapName
        local mapData = GetClass("Map", mapName)

        if GET_ZONE_GODDESS_STATUE_TYPE(mapData) == 2 then
            dungeonCount = dungeonCount + 1
        end
    end

    if dungeonCount == 0 then
        return
    end

    ui.MakeDropListFrame(zoneSet, GET_SCENE_OFFSET_WIDTH() + 25, GET_SCENE_OFFSET_HEIGHT() - 40, 230, 600, dungeonCount, ui.LEFT, "WARP_TO_DUNGEON_AREA_SELECT", nil, nil)
    
    WORLDMAP2_DROPLIST_SET_BY_UI_MANAGER(200)

    for i = 1, #dungeonList do
        local mapName = dungeonList[i].MapName
        local mapData = GetClass("Map", mapName)

        if GET_ZONE_GODDESS_STATUE_TYPE(mapData) == 2 then
            local warpText = "{@st102_14} "..mapData.Name
            local warpCostText = GET_WARP_COST_TOOLTIP(mapName)

            if warpCostText ~= nil then
                warpText = warpText.." ({img Silver 16 16} "..warpCostText..")"
            end

            ui.AddDropListItem(warpText, nil, mapName)
        end
    end
end

function WARP_TO_DUNGEON_AREA_SELECT(index, mapName)
    REQUEST_WARP_TO_AREA(mapName)
end

function REQUEST_WARP_TO_AREA(targetZoneName)
	local pc = GetMyPCObject()
    local nowZoneName = GetZoneName(pc)
    local prevWarpZone = GET_MY_LAST_WARP_POSITION()

    local isLobbyMap = 0
    if prevWarpZone ~= nil and targetZoneName == prevWarpZone then
        isLobbyMap = 1
    end

    -- 유효성 검사
    if targetZoneName == nowZoneName then
        ui.SysMsg(ScpArgMsg("ThatCurrentPosition"))
        return
    end

    local mapCls = GetClass('Map', targetZoneName)
    if mapCls == nil then
        return
    end

    if GET_ZONE_GODDESS_STATUE_TYPE(mapCls) ~= 2 then
        return
    end

    local warpFrame = ui.GetFrame("worldmap2_mainmap")
    local warpType = warpFrame:GetUserValue("Type")
    local warpItem = warpFrame:GetUserValue('SCROLL_WARP')
    local warpCost = GET_WARP_COST(targetZoneName)

    -- 조각상 or 아이템일 경우 무료
    if warpType == "Dievdirbys" or warpType == 'Normal' then
        warpCost = 0
    end
    
    -- 워프 아이템이 존재할 경우 무료
    if warpItem ~= 'NO' and warpItem ~= 'None' then
        warpCost = 0
    end

    -- 가격 검사
    if IsGreaterThanForBigNumber(warpCost, GET_TOTAL_MONEY_STR()) == 1 then
        ui.SysMsg(ScpArgMsg('Auto_SilBeoKa_BuJogHapNiDa.'))
        return
    end

    local warpClass = GetClassByStrProp("camp_warp", "Zone", targetZoneName)
    local warpClassID = nil

    if warpClass == nil then
        warpClassID = mapCls.ClassID
    else
        warpClassID = warpClass.ClassID
    end

    local chatString = "None"
    if warpItem ~= 'NO' and warpItem ~= 'None' then
        chatString = string.format("/intewarpByItem %d %d %s", warpClassID, isLobbyMap, warpFrame:GetUserValue('SCROLL_WARP_IESID'))
    else
        chatString = string.format("/intewarp %d %d", warpClassID, isLobbyMap)
    end
    
	movie.InteWarp(session.GetMyHandle(), chatString)
    packet.ClientDirect("InteWarp")
    
    if warpFrame:IsVisible() == 1 then
		WORLDMAP2_CLOSE()
	end
end