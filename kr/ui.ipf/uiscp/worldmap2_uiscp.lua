-- worldmap2_uiscp.lua

-- HOTKEY BINDING
function UI_TOGGLE_WORLDMAP()
	if app.IsBarrackMode() == true then
        return
    end
    
    if ui.GetFrame('worldmap2_mainmap'):IsVisible() == 1 then
        WORLDMAP2_CLOSE()
    else
        ui.OpenFrame('worldmap2_mainmap')
    end
end

-- 해상도 보정
function GET_SCENE_OFFSET_HEIGHT()
    local X = ui.GetSceneWidth()
    local Y = ui.GetSceneHeight()

    if X / Y > 1920 / 1080 then
        return 0
    else
        return (1920 * Y / X - 1080) / 2
    end
end

function GET_SCENE_OFFSET_WIDTH()
    local X = ui.GetSceneWidth()
    local Y = ui.GetSceneHeight()

    if X / Y > 1920 / 1080 then
        return (1080 * X / Y - 1920) / 2
    else
        return 0
    end
end

-- 맵 데이터 서치함수

-- 별
function GET_STAR_RATE(mapCls)
    return mapCls.MapRank
end

-- 이름
function GET_ZONE_NAME(mapCls)
	return mapCls.Name
end

-- 레벨
function GET_ZONE_QUEST_LEVEL(mapCls)
	return mapCls.QuestLevel
end

-- 탐사율
function GET_ZONE_FOG_PERCENT(mapCls)
	return math.floor(session.GetMapFogRevealRate(mapCls.ClassName))
end

-- 던전 여부
function GET_ZONE_DUNGEON_TYPE(mapCls)
	return mapCls.MapType == "Dungeon"
end

-- 챌린지 가능 여부
function GET_CHALLGENE_MODE_ENABLE(mapCls)
    return mapCls.ChallengeMode == "YES"
end

-- 챌린지 레벨 범위
function GET_CHALLGENE_MODE_ENABLE_LEVEL(mapCls)
    return math.max(100, mapCls.QuestLevel-30), math.min(PC_MAX_LEVEL, mapCls.QuestLevel+80)
end

-- 여신상 여부
function GET_ZONE_GODDESS_STATUE(mapCls)
	return GetClassByStrProp('camp_warp', 'Zone', mapCls.ClassName) ~= nil
end

-- 여신상 활성화 여부 (2: 활성화, 1: 비활성화, 0: 존재하지 않음) (로비맵도 일시적인 여신상 활성화로 간주함)
function GET_ZONE_GODDESS_STATUE_TYPE(mapCls)
    local lobbyMap = GET_MY_LAST_WARP_POSITION()
    if lobbyMap ~= nil and lobbyMap == mapCls.ClassName then
        return 2
    end

    local sObj_main = GET_MAIN_SOBJ()
	if sObj_main == nil then
		return 0
    end
    
    local cls = GetClassByStrProp('camp_warp', 'Zone', mapCls.ClassName)
    if cls == nil then
        return 0
    end

    if TryGetProp(sObj_main, cls.ClassName) == 0 then
        return 1
    end

    if TryGetProp(sObj_main, cls.ClassName) == 300 then
        return 2
    end

    return 0
end

-- 콜로니맵 목록
function GET_COLONY_MAP_LIST()
	return SCR_GET_XML_IES('guild_colony', 'ID', 1)
end

-- 내 위치 체크 함수 (In 월드맵, 즉 복층구조면 대표존 리턴)
function GET_MY_POSITION()
	local pc = GetMyPCObject()
    local mapName = string.gsub(GetZoneName(pc), "GuildColony_", "")

    local episode = GET_EPISODE_BY_MAPNAME(mapName)
    local dungeon = GET_DUNGEON_BY_MAPNAME(mapName)

    -- 던전 처리
    if dungeon ~= "None" then
        return dungeon, episode
    else
        return mapName, episode
    end
end

-- 로비맵 (내 마지막 워프 위치) 체크 함수
function GET_MY_LAST_WARP_POSITION()
    local etcObj = GetMyEtcObject()
    local mapCls = GetClassByType("Map", etcObj.ItemWarpMapID)
    
    if mapCls ~= nil then
        return mapCls.ClassName
    end

    return nil
end

function GET_MY_LAST_WARP_EPISODE()
    local mapName = GET_MY_LAST_WARP_POSITION()

    if mapName ~= nil then
        return GET_EPISODE_BY_MAPNAME(mapName)
    else
        return nil
    end
end

-- 길드 타워 위치 체크 함수
function GET_GUILD_TOWER_POSITION()
    local guildObj = GET_MY_GUILD_OBJECT()
    if guildObj == nil then
        return nil
    end

    local towerPosition = guildObj.HousePosition
    local towerInfo = StringSplit(towerPosition, "#")

    if #towerInfo ~= 6 then
        return nil
    else
        local mapData = GetClassByType("Map", towerInfo[1])
        local mapName = TryGetProp(mapData, "ClassName")

        return mapName
    end
end

-- 월드맵 드랍리스트 세팅 함수
function WORLDMAP2_DROPLIST_SET(ctrl)
    ctrl:SetFrameOffset(GET_SCENE_OFFSET_WIDTH(), GET_SCENE_OFFSET_HEIGHT())
    ctrl:SetFrameScrollBarOffset(-3, 0)
    ctrl:SetFrameScrollBarSkinName("worldmap2_scrollbar")
end

-- 월드맵 드랍리스트 세팅 함수 (by UI Manager)
function WORLDMAP2_DROPLIST_SET_BY_UI_MANAGER(alpha)

    -- 드랍리스트 세팅 (색)
    ui.SetDropListBorderColor(0, 0, 0, 0)
    ui.SetDropListSelectColor(alpha, 29, 17, 9)
    ui.SetDropListBodyColor(alpha, 0, 0, 0)

    -- 드랍리스트 세팅 (스크롤바)
    ui.SetDropListScrollBarSkinName("worldmap2_scrollbar")
    ui.SetDropListScrollBarOffset(-3, 0)
    ui.InvalidateDropListScrollBarSkin()
end

-- 맵 UI 접근 함수

-- 메인맵 -> 서브맵
function OPEN_WORLDMAP2_SUBMAP_FROM_MAINMAP(frame, ctrl, argStr, argNum)
	WORLDMAP2_SUBMAP_SET_EPISODE(ctrl:GetUserValue("EPISODE"))
	ui.OpenFrame("worldmap2_submap")
end

function WORLDMAP2_SUBMAP_OPEN_FROM_MAINMAP_BY_EPISODE(episode)
	WORLDMAP2_SUBMAP_SET_EPISODE(episode)
	ui.OpenFrame("worldmap2_submap")
end

-- 서브맵 -> 미니맵
function OPEN_WORLDMAP2_MINIMAP_FROM_SUBMAP(frame, ctrl, argStr, argNum)
    if GET_WARP_MAP_TYPE() == "None" then
        WORLDMAP2_MINIMAP_SET_MAPNAME(ctrl:GetUserValue("MAP_NAME"))
        ui.OpenFrame("worldmap2_minimap")
    else
        WARP_TO_AREA(ctrl:GetUserValue("MAP_NAME"))
    end
end

function WORLDMAP2_OPEN_MINIMAP_FROM_SUBMAP_BY_MAPNAME(mapName)
    if GET_WARP_MAP_TYPE() == "None" then
        WORLDMAP2_MINIMAP_SET_MAPNAME(mapName)
        ui.OpenFrame("worldmap2_minimap")
    else
        WARP_TO_AREA(mapName)
    end
end

-- 맵 이름 -> 에피소드 서치 함수
function GET_EPISODE_BY_MAPNAME(mapName)
	local mapDataList = SCR_GET_XML_IES("worldmap2_submap_data", "MapName", mapName)
        
	for i = 1, #mapDataList do
		if mapDataList[i].IsInEpisode == "YES" then
			return mapDataList[i].Episode
		end
	end

	return nil
end

-- 맵 이름 -> 던전 이름 서치 함수
function GET_DUNGEON_BY_MAPNAME(mapName)
    local mapDataList = SCR_GET_XML_IES("worldmap2_submap_data", "MapName", mapName)
        
	for i = 1, #mapDataList do
		if mapDataList[i].IsInEpisode == "YES" then
			return mapDataList[i].DungeonName
		end
	end

	return "None"
end

-- 월드맵 종료 함수
function WORLDMAP2_CLOSE()
	ui.CloseFrame("worldmap2_colonymap")
	ui.CloseFrame("worldmap2_minimap")
	ui.CloseFrame("worldmap2_mainmap")
	ui.CloseFrame("worldmap2_submap")
end

-- 퀘스트 서치 함수
function GET_QUEST_CONTROL_NAME_LIST(mapName, questName)
	local nameList = {}
    local npcList, stateList, questIESList, questPropList = GetQuestNpcNames(mapName)

	for i = 1, #questIESList do
        if questName == questIESList[i].ClassName then

            local npcName = npcList[i]
			local questIES = questIESList[i]
			local stateidx = STATE_NUMBER(stateList[i])
            local questProp = geQuestTable.GetPropByIndex(questPropList[i])

            local mapprop = geMapTable.GetMapProp(mapName)
            local questMonList = mapprop.questmonster
            local sessionObject = GetClass("SessionObject", questIES.Quest_SSN)

			-- 1. 표기 대상이 NPC인 경우
			if npcName ~= "None" then
				if mapprop.mongens ~= nil then
                    local mongens = mapprop.mongens
                    local cnt = mongens:Count()
    
                    for j = 0, cnt-1 do
                        local MonProp = mongens:Element(j)
                        if MonProp:GetDialog() == npcName then
                            nameList[#nameList + 1] = GET_GENNPC_NAME(frame, MonProp)
                            break
                        end
                    end
				end
            end

            -- 2. 표기 대상이 지역인 경우 (QuestProgressCheck)
            if questProp ~= nil and stateidx ~= -1 then
                local locationList = questProp:GetLocation(stateidx)
                if locationList ~= nil then
                    for j = 0 , locationList:Count() - 1 do
                        nameList[#nameList + 1] = '_NPC_LOC_MARK'..i..stateidx..j
                    end
                end
            end

            -- 3. 표기 대상이 지역인 경우 (SessionObject)
            if sessionObject ~= nil then
                for j = 1, SESSION_MAX_MAP_POINT_GROUP do
                    nameList[#nameList + 1] = '_NPC_LOC_MARK'..i..stateidx..'group'..j
                end
            end

            break
		end
    end

	return nameList
end

-- 토큰이동 쿨타임
function GET_TOKEN_WARP_COOLDOWN()
    local aObj = GetMyAccountObj()
    local savedTime = TryGetProp(aObj, "LAST_TOKEN_WARP_TIME", "None")
    local serverTime = geTime.GetServerSystemTime()

    if savedTime == "None" then
        return 0
    else
        savedTime = imcTime.GetSysTimeByStr(savedTime)
    end

    return math.max(TOKEN_WARP_COOLTIME - imcTime.GetDifSec(serverTime, savedTime), 0)
end

-- 토큰이동 로직
function WORLDMAP2_TOKEN_WARP(mapName)
    if session.loginInfo.IsPremiumState(ITEM_TOKEN) == false then
        return
    end

    -- 유효성 검사
    local mapData = GetClass("Map", mapName)
    if mapData == nil then
        return
    end

    -- 서브맵 존재 여부 검사
    local submapData = GetClassByStrProp("worldmap2_submap_data", "MapName", mapName)
    if submapData == nil then
        return
    end

    -- 같은 맵 검사
    if GetZoneName() == mapName then
        ui.SysMsg(ScpArgMsg("ThatCurrentPosition"))
        return
    end

    if GET_TOKEN_WARP_COOLDOWN() == 0 then
        ui.MsgBox(ScpArgMsg("TokenWarpTo{MAPNAME}", "MAPNAME", mapData.Name), string.format("WORLDMAP2_TOKEN_WARP_REQUEST(\"%s\")", mapName), "None")
    else
        addon.BroadMsg("NOTICE_Dm_!", ScpArgMsg("TokenWarpDisable{TIME}", "TIME", GET_TOKEN_WARP_COOLDOWN()), 5)
    end
end

function WORLDMAP2_TOKEN_WARP_REQUEST(mapName)
    RequestTokenWarp(mapName)
end

-- 즐겨찾기 목록
function GET_FAVORITE_MAP_LIST()
    local aObj = GetMyAccountObj()
    local list = {}

    for i = 1, 5 do
        local mapName = TryGetProp(aObj, "FavoriteMap_"..i)
        if mapName ~= "None" then
            list[#list+1] = mapName
        end
    end

    return list
end

function IS_FAVORITE_MAP(mapName)
    local list = GET_FAVORITE_MAP_LIST()

    for i = 1, #list do
        if mapName == list[i] then
            return true
        end
    end

    return false
end

-- 즐겨찾기 로직
function WORLDMAP2_TOGGLE_BOOKMARK()
    local mapName = WORLDMAP2_MINIMAP_MAPNAME()

    -- 유효성 검사
    local mapData = GetClass("Map", mapName)
    if mapData == nil then
        return
    end

    if IS_FAVORITE_MAP(mapName) then
        WORLDMAP2_UNREGISTER_FAVORITE_MAP(mapName)
    else
        WORLDMAP2_REGISTER_FAVORITE_MAP(mapName)
    end
end

function WORLDMAP2_REGISTER_FAVORITE_MAP(mapName)
    RegisterFavoriteMap(mapName)
end

function WORLDMAP2_UNREGISTER_FAVORITE_MAP(mapName)
    UnRegisterFavoriteMap(mapName)
end

-- 도움말 목록
function WORLDMAP2_HELPLIST(frame, ctrl)
    local count = 6

    ui.MakeDropListFrame(ctrl, GET_SCENE_OFFSET_WIDTH() + 5, GET_SCENE_OFFSET_HEIGHT() - 8, 200, 1000, count, ui.LEFT, "WORLDMAP2_HELPLIST_OPEN", nil, nil)
    
    WORLDMAP2_DROPLIST_SET_BY_UI_MANAGER(255)

    for i = 1, count do
        local helpClass = GetClass("Help", "TUTO_WORLDMAP2_0"..i)
        ui.AddDropListItem(" {@st102_14}"..helpClass.Title, nil, helpClass.ClassID)
    end
end

function WORLDMAP2_HELPLIST_OPEN(index, type)
    PIPHELP_MSG(ui.GetFrame("piphelp"), "FORCE_OPEN", argStr, type)
end