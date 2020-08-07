-- worldmap2_submap.lua

function WORLDMAP2_SUBMAP_ON_INIT(addon, frame)
    addon:RegisterMsg('UPDATE_FIELDBOSS_INFO', 'ON_UPDATE_SUBMAP_FIELDBOSS_INFO')
end

-- SETTING
function WORLDMAP2_SUBMAP_EPISODE()
	return ui.GetFrame("worldmap2_submap"):GetUserConfig("SUBMAP_NAME")
end

function WORLDMAP2_SUBMAP_SET_EPISODE(episode)
	local submapFrame = ui.GetFrame('worldmap2_submap')
	submapFrame:SetUserConfig("SUBMAP_NAME", episode)
end

-- OPEN / CLOSE
function OPEN_WORLDMAP2_SUBMAP(frame)
    WORLDMAP2_SUBMAP_DRAW(frame)
    WORLDMAP2_SUBMAP_DRAW_BASE(frame)
    WORLDMAP2_SUBMAP_INIT(frame)
end

function CLOSE_WORLDMAP2_SUBMAP(frame)
    WORLDMAP2_SUBMAP_EXIT(frame)
    WORLDMAP2_SUBMAP_CLEANUP(frame)
end

-- INIT/EXIT
function WORLDMAP2_SUBMAP_INIT(frame)
    -- 검색창
    WORLDMAP2_SUBMAP_SEARCH_INIT()

    -- 워프맵
    WORLDMAP2_SUBMAP_WARP_OPTION_INIT()

    -- 이펙트
    WORLDMAP2_MAINMAP_EFFECT_OFF()
    WORLDMAP2_SUBMAP_EFFECT_ON()

    -- 카테고리
    WORLDMAP2_CATEGORY_INIT(frame)

    -- 필드보스
    WORLDMAP2_SUBMAP_FIELDBOSS(frame)

    frame:RunUpdateScript("WORLDMAP2_SUBMAP_UPDATE", 0, 0, 0, 1)
end

function WORLDMAP2_SUBMAP_EXIT(frame)
    -- 검색창
    WORLDMAP2_SUBMAP_SEARCH_EXIT()

    -- 이펙트
    WORLDMAP2_SUBMAP_EFFECT_OFF()
    WORLDMAP2_MAINMAP_EFFECT_ON()
end

-- EFFECT
function WORLDMAP2_SUBMAP_EFFECT_ON()
    local frame = ui.GetFrame('worldmap2_submap')
    
    WORLDMAP2_SUBMAP_EFFECT_ON_MY_POS(frame)
    WORLDMAP2_SUBMAP_EFFECT_ON_ZONE_CHECK(frame)
end

function WORLDMAP2_SUBMAP_EFFECT_OFF()
    local frame = ui.GetFrame('worldmap2_submap')

    WORLDMAP2_SUBMAP_EFFECT_OFF_MY_POS(frame)
    WORLDMAP2_SUBMAP_EFFECT_OFF_ZONE_CHECK(frame)
end

function WORLDMAP2_SUBMAP_EFFECT_ON_MY_POS(frame)
    local myPos = frame:GetUserValue("MY_POS")

    if myPos ~= nil and myPos ~= "None" then
        local myPosSet = frame:GetChild(myPos)
        local myPosArrow = myPosSet:GetChild("zone_pc_pos")
        local myPosMargin = myPosArrow:GetMargin()
    
        myPosArrow:PlayUIEffect("UI_worldmap_pos_01_loop", 8, "MY_POS")
    end
end

function WORLDMAP2_SUBMAP_EFFECT_OFF_MY_POS(frame)
    local myPos = frame:GetUserValue("MY_POS")

    if myPos ~= nil and myPos ~= "None" then
        local myPosSet = frame:GetChild(myPos)
        local myPosArrow = myPosSet:GetChild("zone_pc_pos")
        
        myPosArrow:StopUIEffect("MY_POS", true, 0)
    end
end

function WORLDMAP2_SUBMAP_EFFECT_ON_ZONE_CHECK(frame)
    local nowCheckMap = frame:GetUserConfig("ZONE_CHECK")
    local nowCheckSet = frame:GetChild(nowCheckMap)
    
    if nowCheckSet ~= nil then
        nowCheckSet:GetChild("zone_btn"):PlayUIEffect("UI_worldmap_pos_02_loop", 12, "ZONE_CHECK")
    end
end

function WORLDMAP2_SUBMAP_EFFECT_OFF_ZONE_CHECK(frame)
    local nowCheckMap = frame:GetUserConfig("ZONE_CHECK")
    local nowCheckSet = frame:GetChild(nowCheckMap)
    
    if nowCheckSet ~= nil then
        nowCheckSet:GetChild("zone_btn"):StopUIEffect("ZONE_CHECK", true, 0)
    end
end

-- UPDATE
function WORLDMAP2_SUBMAP_UPDATE(frame)
    if AUTO_CAST(frame:GetChild("search_edit")):IsHaveFocus() == 1 then
        return 1
    end

    if mouse.IsRBtnDown() == 1 then
        if ui.GetFrame("worldmap2_minimap"):IsVisible() == 1 then
            ui.CloseFrame('worldmap2_minimap')
            return 1
        else
            ui.CloseFrame('worldmap2_submap')
            return 0
        end
    end

	if imcinput.HotKey.IsDown("MoveLeft") == true then
		WORLDMAP2_SUBMAP_LBTN(frame)
    end
    
    if imcinput.HotKey.IsDown("MoveRight") == true then
		WORLDMAP2_SUBMAP_RBTN(frame)
    end

	return 1
end

function WORLDMAP2_SUBMAP_LBTN(frame)
	if ui.GetFrame("worldmap2_minimap"):IsVisible() == 1 then
		return
	end

	local episode = WORLDMAP2_SUBMAP_EPISODE()
	local ordinal = GetClass("worldmap2_data", episode).Ordinal
	local leftCls = GetClassByNumProp("worldmap2_data", "Ordinal", ordinal - 1)

	if leftCls == nil then
		return
    end
    
	WORLDMAP2_SUBMAP_CHANGE(leftCls.ClassName)
end

function WORLDMAP2_SUBMAP_RBTN(frame)
	if ui.GetFrame("worldmap2_minimap"):IsVisible() == 1 then
		return
	end

	local episode = WORLDMAP2_SUBMAP_EPISODE()
	local ordinal = GetClass("worldmap2_data", episode).Ordinal
	local rightCls = GetClassByNumProp("worldmap2_data", "Ordinal", ordinal + 1)

	if rightCls == nil then
		return
    end
    
    WORLDMAP2_SUBMAP_CHANGE(rightCls.ClassName)
end

function WORLDMAP2_SUBMAP_BACK(frame)
	ui.CloseFrame("worldmap2_minimap")
	ui.CloseFrame("worldmap2_submap")
end

-- CLEANUP
function WORLDMAP2_SUBMAP_CLEANUP(frame)
	local episode = WORLDMAP2_SUBMAP_EPISODE()
	local list = SCR_GET_XML_IES("worldmap2_submap_data", "Episode", episode)
	for i = 1, #list do
		frame:RemoveChild(list[i].MapName)
	end

	frame:SetUserValue("MY_POS", "None")
    frame:SetUserConfig("ZONE_CHECK", "None")
end

-- SEARCH
function WORLDMAP2_SUBMAP_SEARCH_INIT()
    local mainFrame = ui.GetFrame('worldmap2_mainmap')
    local subFrame = ui.GetFrame('worldmap2_submap')

    local mainEdit = AUTO_CAST(mainFrame:GetChild("search_edit"))
    local subEdit = AUTO_CAST(subFrame:GetChild("search_edit"))

    subEdit:SetText(mainEdit:GetText())
end

function WORLDMAP2_SUBMAP_SEARCH_EXIT()
    local mainFrame = ui.GetFrame('worldmap2_mainmap')
    local subFrame = ui.GetFrame('worldmap2_submap')

    local mainEdit = AUTO_CAST(mainFrame:GetChild("search_edit"))
    local subEdit = AUTO_CAST(subFrame:GetChild("search_edit"))
    
    mainEdit:SetText(subEdit:GetText())
end

-- DRAW
function WORLDMAP2_SUBMAP_DRAW_BASE(frame)
	local mapName = WORLDMAP2_SUBMAP_EPISODE()
	local mapData = GetClass("worldmap2_data", mapName)

	local submapPic = AUTO_CAST(frame:GetChild("submap_pic"))
	local submapIcon = AUTO_CAST(frame:GetChild("submap_icon"))
	local submapSbarEP = AUTO_CAST(frame:GetChild("submap_sbar_ep"))
	local submapSbarSubQ = AUTO_CAST(frame:GetChild("submap_sbar_subq"))
    local submapSbarSubQText = AUTO_CAST(frame:GetChild("submap_sbar_subq_text"))
    local submapShowOption = AUTO_CAST(frame:GetChild("submap_show_option_gb"))
    local submapTip = AUTO_CAST(frame:GetChild("submap_tip"))

	submapPic:SetImage(mapData.SubmapImageName)

	local x = frame:GetUserConfig("SUBMAP_ICON_X")
	local y = frame:GetUserConfig("SUBMAP_ICON_Y")

	-- 메인 에피소드(아이콘 O)
	if mapData.SubmapIconName ~= "None" then
		submapIcon:ShowWindow(1)
		submapSbarEP:ShowWindow(1)
		submapSbarSubQ:ShowWindow(0)
		submapSbarSubQText:ShowWindow(0)

		local submapIconSize = ui.GetSkinImageSize(mapData.SubmapIconName)

		submapIcon:SetMargin(x, y - submapIconSize.y/2, 0, 0)
		submapIcon:SetImage(mapData.SubmapIconName)

		submapSbarEP:SetMargin(x, y, 0, 0)
        submapSbarEP:SetText('{@st100white_24}'..mapData.Name)
        submapSbarEP:AdjustFontSizeByWidth(140)

	-- 서브 에피소드(아이콘 X)
	else
		submapIcon:ShowWindow(0)
		submapSbarEP:ShowWindow(0)
		submapSbarSubQ:ShowWindow(1)
		submapSbarSubQText:ShowWindow(1)

		submapSbarSubQ:SetMargin(x, y - 95, 0, 0)

		submapSbarSubQText:SetText('{@st100white_24}'..mapData.Name)
        submapSbarSubQText:SetMargin(x, y - 107, 0, 0)
        submapSbarSubQText:AdjustFontSizeByWidth(140)
    end

    -- 워프맵 표기 옵션
    if GET_WARP_MAP_TYPE() ~= "None" then
        submapShowOption:ShowWindow(1)
    else
        submapShowOption:ShowWindow(0)
    end

    -- 좌우버튼 툴팁
    do
        local episode = WORLDMAP2_SUBMAP_EPISODE()
        local nowOrdinal = GetClass("worldmap2_data", episode).Ordinal

        local submapLBtn = AUTO_CAST(frame:GetChild("submap_left_btn"))
        local submapRBtn = AUTO_CAST(frame:GetChild("submap_right_btn"))

        local leftCls = GetClassByNumProp("worldmap2_data", "Ordinal", nowOrdinal - 1)
        local rightCls = GetClassByNumProp("worldmap2_data", "Ordinal", nowOrdinal + 1)

        if leftCls ~= nil then
            submapLBtn:SetTextTooltip(ScpArgMsg("MoveTo{EPISODE}", "EPISODE", leftCls.Name))
        else
            submapLBtn:SetTextTooltip("")
        end

        if rightCls ~= nil then
            submapRBtn:SetTextTooltip(ScpArgMsg("MoveTo{EPISODE}", "EPISODE", rightCls.Name))
        else
            submapRBtn:SetTextTooltip("")
        end

        ui.UpdatePickTooltip()
    end

    -- 토큰이동 안내문 표기 옵션
    if session.loginInfo.IsPremiumState(ITEM_TOKEN) then
        submapTip:ShowWindow(1)
    else
        submapTip:ShowWindow(0)
    end
end

function WORLDMAP2_SUBMAP_DRAW(frame)
	local episode = WORLDMAP2_SUBMAP_EPISODE()
	local list = SCR_GET_XML_IES("worldmap2_submap_data", "Episode", episode)
	for i = 1, #list do
		WORLDMAP2_SUBMAP_DRAW_ZONE(frame, list[i])
	end
end

function WORLDMAP2_SUBMAP_DRAW_ZONE(frame, cls)

	-- 던전 존이면서 대표존이 아닌 경우 리턴
	if cls.DungeonName ~= "None" and cls.DungeonName ~= cls.MapName then
		return
	end

	local mapName = cls.MapName
	local x = cls.Coordinate_X
	local y = cls.Coordinate_Y

	local mapCls = GetClass("Map", mapName)
    local zoneSet = nil
    local iconName = nil
    local direction = cls.TooltipDirection

    -- 툴팁 방향 / 컨트롤셋 버튼 크기에 따른 컨트롤셋 선택
    if cls.IsInEpisode == "NO" then
        zoneSet = frame:CreateOrGetControlSet("submap_gray_"..direction.."_set", mapName, ui.CENTER_HORZ, ui.CENTER_VERT, 0, 0, 0, 0)
    else
        if mapCls.MapType == "City" then
            zoneSet = frame:CreateOrGetControlSet("submap_city_"..direction.."_set", mapName, ui.CENTER_HORZ, ui.CENTER_VERT, 0, 0, 0, 0)
        else
            zoneSet = frame:CreateOrGetControlSet("submap_zone_"..direction.."_set", mapName, ui.CENTER_HORZ, ui.CENTER_VERT, 0, 0, 0, 0)
        end
    end

	local zoneBtn = AUTO_CAST(zoneSet:GetChild("zone_btn"))
	local zoneTextTop = AUTO_CAST(zoneSet:GetChild("zone_text_top"))
    local zoneTextBot = AUTO_CAST(zoneSet:GetChild("zone_text_bottom"))

	-- 버튼 (이미지)
    if mapCls.MapType == "City" then
        if cls.IsInEpisode == "YES" then
            iconName = "worldmap2_map_town_btn"
		else
			iconName = "worldmap2_map_submap2"
		end
	else
		if cls.IsInEpisode == "YES" then
			iconName = "worldmap2_map_zone_btn"
		else
			iconName = "worldmap2_map_submap"
		end
    end

    zoneBtn:SetImage(iconName)

    -- 버튼 크기에 따른 마진값 조정
    if direction == "left" then
        zoneSet:SetMargin(x - zoneSet:GetWidth()/2 + ui.GetSkinImageSize(iconName).x/2, y, 0, 0)
    else
        zoneSet:SetMargin(x + zoneSet:GetWidth()/2 - ui.GetSkinImageSize(iconName).x/2, y, 0, 0)
    end
    
    -- 버튼 (클릭 이벤트)
	zoneBtn:SetUserValue("MAP_NAME", mapName)
    zoneBtn:SetUserValue("IN_EPISODE", cls.IsInEpisode)
    
    -- 버튼 (워프맵 설정)
    if GET_WARP_MAP_TYPE() ~= "None" then
        zoneBtn:SetOverSound("button_cursor_over_3")
        zoneBtn:SetClickSound("button_click_big")

        if GET_ZONE_GODDESS_STATUE_TYPE(mapCls) == 2 then
            if GET_WARP_COST_TOOLTIP(mapName) ~= nil then
                zoneBtn:SetTextTooltip("{img Silver 20 20} "..GET_WARP_COST_TOOLTIP(mapName))
            end
        end
    end

	local textTop = ""
	local textBot = ""

	-- 상단 텍스트
	do
        local name = GET_ZONE_NAME(mapCls)
        local lobbyMap = GET_MY_LAST_WARP_POSITION()
        local fogPercent = GET_ZONE_FOG_PERCENT(mapCls)

		-- 맵이름
		textTop = textTop.."{@st100white_16}"..name.."{/}"

		-- 탐사율
		if fogPercent < 100 then
			textTop = textTop.."{@st100green_14}"
		else
			textTop = textTop.."{@st100gray_14}"
        end
        
        textTop = textTop.."("..fogPercent.."%"..")"
        
        -- 로비맵
        if lobbyMap ~= nil and lobbyMap == mapName then
            if cls.TooltipDirection == "left" then
                textTop = "{img worldmap2_scroll_icon 18 22}"..textTop
            else
                textTop = textTop.."{img worldmap2_scroll_icon 18 22}"
            end
        end
	end

	-- 하단 텍스트
	do
        local level = GET_ZONE_QUEST_LEVEL(mapCls)
		local isGoddess = GET_ZONE_GODDESS_STATUE(mapCls)
        local isDungeon = GET_ZONE_DUNGEON_TYPE(mapCls)
        
        local pcLevel = info.GetLevel(session.GetMyHandle())

        -- 레벨
        if level > pcLevel + 50 then
            textBot = textBot.."{@st100red_16}".."Lv."..level.."{/}"
        elseif level < pcLevel - 80 then
            textBot = textBot.."{@st100gray_16}".."Lv."..level.."{/}"
        else
            textBot = textBot.."{@st100white_16}".."Lv."..level.."{/}"
        end

		-- 여신상
		if isGoddess then
			textBot = textBot .. '{img minimap_goddess 24 24}'
		end

		-- 던전
		if isDungeon then
			textBot = textBot .. '{img minimap_dungeon 24 24}'
		end
	end

	zoneTextTop:SetText(textTop)
	zoneTextBot:SetText(textBot)

	-- 내 위치 표기
    local myPosImg = AUTO_CAST(zoneSet:GetChild("zone_pc_pos"))
    local myPosMargin = myPosImg:GetMargin()
	local myMapName, myEpisode = GET_MY_POSITION()

    if myMapName == mapName then
        frame:SetUserValue("MY_POS", mapName)
        myPosImg:SetMargin(myPosMargin.left -2, myPosMargin.top -4, myPosMargin.right, myPosMargin.bottom)
	else
		myPosImg:ShowWindow(0)
    end
end

-- FIELDBOSS
function WORLDMAP2_SUBMAP_FIELDBOSS(frame)
    local count = session.world.GetExistFieldBossCount()

    for i = 1, count do
        local mapName = session.world.GetFieldBossMapNameByIndex(i)
        local bossName = session.world.GetFieldBossNameByIndex(i)

        local episode = GET_EPISODE_BY_MAPNAME(mapName)
        local bossData = GetClass("Monster", bossName)

        if episode == WORLDMAP2_SUBMAP_EPISODE() then
            local zoneSet = AUTO_CAST(frame:GetChild(mapName))
            local fieldBossText = AUTO_CAST(zoneSet:GetChild("zone_text_fieldboss"))

            fieldBossText:SetText('{@st100red_16}'..bossData.Name)
            fieldBossText:ShowWindow(1)
        end
    end
end

-- WARP_OPTION
function WORLDMAP2_SUBMAP_WARP_OPTION_INIT()
    if GET_WARP_MAP_TYPE() == "None" then
        return
    end

    WORPDMAP2_SUBMAP_TOGGLE_SHOW_OPTION()
end

-- SCRIPT LIST

-- 필드보스 업데이트 함수
function ON_UPDATE_SUBMAP_FIELDBOSS_INFO(frame, msg, argStr, argNum)
    if frame:IsVisible() == 0 then
        return
    end

    WORLDMAP2_SUBMAP_FIELDBOSS(frame)
end

-- 서브맵 변경
function WORLDMAP2_SUBMAP_CHANGE(episode)
	local frame = ui.GetFrame('worldmap2_submap')

	-- 동일 서브맵일 경우 리턴
	if WORLDMAP2_SUBMAP_EPISODE() == episode then
		return
	end

	CLOSE_WORLDMAP2_SUBMAP(frame)
	WORLDMAP2_SUBMAP_SET_EPISODE(episode)
    OPEN_WORLDMAP2_SUBMAP(frame)
    
    ui.CloseFrame('worldmap2_minimap')
end

-- 존 버튼 좌클릭
function WORLDMAP2_SUBMAP_ZONE_BTN_CLICK(frame, ctrl, argStr, argNum)
    local mapName = ctrl:GetUserValue("MAP_NAME")
    local episode = GET_EPISODE_BY_MAPNAME(mapName)

    if episode == nil then
        return
    end

    -- 컨트롤 좌클릭: 존 체크
    if keyboard.IsKeyPressed("LCTRL") == 1 then
        WORLDMAP2_SUBMAP_ZONE_CHECK(mapName)

    -- 쉬프트 좌클릭: 토큰 이동
    elseif keyboard.IsKeyPressed("LSHIFT") == 1 then
        if GET_WARP_MAP_TYPE() ~= "None" then
            return
        end

        WORLDMAP2_TOKEN_WARP(mapName)
    
    -- 그 외: 미니맵 오픈
    else
        if ctrl:GetUserValue("IN_EPISODE") == "YES" then
            OPEN_WORLDMAP2_MINIMAP_FROM_SUBMAP(frame, ctrl, argStr, argNum)
        else
            WORLDMAP2_SUBMAP_CHANGE(episode)
            WORLDMAP2_SUBMAP_ZONE_CHECK(mapName)
        end
    end
end

-- 존 체크
function WORLDMAP2_SUBMAP_ZONE_CHECK(mapName)
    local frame = ui.GetFrame('worldmap2_submap')
    
    -- 복층일 경우 복층 대표맵으로 대체
    if GET_DUNGEON_BY_MAPNAME(mapName) ~= "None" then
        mapName = GET_DUNGEON_BY_MAPNAME(mapName)
    end

	-- 현재 체크 제거
    local nowCheckMap = frame:GetUserConfig("ZONE_CHECK")
    local nowCheckSet = frame:GetChild(nowCheckMap)

    if nowCheckSet ~= nil then
        nowCheckSet:GetChild("zone_btn"):StopUIEffect("ZONE_CHECK", true, 0)
	end

	-- 동일 맵일 경우 리턴
	if nowCheckMap == mapName then
		frame:SetUserConfig("ZONE_CHECK", "None")
		return
	end

    -- 체크 부여
    local checkSet = frame:GetChild(mapName)
    local checkImage = checkSet:GetChild("zone_btn")
    local checkImageMargin = checkImage:GetMargin()
    
	checkImage:SetMargin(checkImageMargin.left, checkImageMargin.top, checkImageMargin.right, checkImageMargin.bottom)
    checkImage:PlayUIEffect("UI_worldmap_pos_02_loop", 12, "ZONE_CHECK")

    imcSound.PlaySoundEvent("inven_equip")

	frame:SetUserConfig("ZONE_CHECK", mapName)
end

-- 워프맵 옵션 갱신
function WORPDMAP2_SUBMAP_TOGGLE_SHOW_OPTION()
    local frame = ui.GetFrame('worldmap2_submap')
    local showAll = GET_CHILD_RECURSIVELY(frame, "submap_show_all"):IsChecked()
    local showUndefined = GET_CHILD_RECURSIVELY(frame, "submap_show_undefined"):IsChecked()

    local episode = WORLDMAP2_SUBMAP_EPISODE()
    local list = SCR_GET_XML_IES("worldmap2_submap_data", "Episode", episode)

    for i = 1, #list do
        local mapData = GetClass("Map", list[i].MapName)
        local mapType = GET_ZONE_GODDESS_STATUE_TYPE(mapData)

        local zoneSet = nil
        
        if list[i].DungeonName ~= "None" then
            zoneSet = AUTO_CAST(frame:GetChild(list[i].DungeonName))
        else
            zoneSet = AUTO_CAST(frame:GetChild(list[i].MapName))
        end

        local show = 0
        local changeColor = 0

        -- case 1. 모든 맵 표시 & 미확인 여신상
        if showAll == 1 and showUndefined == 1 then
            show = 1

            if list[i].DungeonName ~= "None" then
                local dungeonList = SCR_GET_XML_IES("worldmap2_submap_data", "DungeonName", list[i].DungeonName)

                for i = 1, #dungeonList do
                    local dungeonData = GetClass("Map", dungeonList[i].MapName)
                    local dungeonType = GET_ZONE_GODDESS_STATUE_TYPE(dungeonData)

                    if dungeonType == 1 then
                        changeColor = 1
                    end
                end
            else
                if mapType == 1 then
                    changeColor = 1
                end
            end
        end

        -- case 2. 모든 맵 표시
        if showAll == 1 and showUndefined == 0 then
            show = 1
        end

        -- case 3. 미확인 여신상
        if showAll == 0 and showUndefined == 1 then
            if list[i].DungeonName ~= "None" then
                local dungeonList = SCR_GET_XML_IES("worldmap2_submap_data", "DungeonName", list[i].DungeonName)

                for i = 1, #dungeonList do
                    local dungeonData = GetClass("Map", dungeonList[i].MapName)
                    local dungeonType = GET_ZONE_GODDESS_STATUE_TYPE(dungeonData)

                    if dungeonType == 1 then
                        changeColor = 1
                        show = 1
                    end

                    if dungeonType == 2 then
                        show = 1
                    end
                end
            else
                if mapType == 1 then
                    changeColor = 1
                    show = 1
                end

                if mapType == 2 then
                    show = 1
                end
            end
        end

        -- case 4. 둘 다 체크하지 않음
        if showAll == 0 and showUndefined == 0 then
            if list[i].DungeonName ~= "None" then
                local dungeonList = SCR_GET_XML_IES("worldmap2_submap_data", "DungeonName", list[i].DungeonName)

                for i = 1, #dungeonList do
                    local dungeonData = GetClass("Map", dungeonList[i].MapName)
                    local dungeonType = GET_ZONE_GODDESS_STATUE_TYPE(dungeonData)

                    if dungeonType == 2 then
                        show = 1
                    end
                end
            else
                if mapType == 2 then
                    show = 1
                end
            end
        end

        -- show
        zoneSet:ShowWindow(show)

        -- change color
        local zoneTextTop = AUTO_CAST(zoneSet:GetChild("zone_text_top"))
        local text = zoneTextTop:GetText()

        if changeColor == 1 then
            text = string.gsub(text, "{@st100white_16}", "{@st100orange_16}")
        else
            text = string.gsub(text, "{@st100orange_16}", "{@st100white_16}")
        end

        zoneTextTop:SetText(text)
	end
end