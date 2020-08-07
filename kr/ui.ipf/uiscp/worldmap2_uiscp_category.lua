-- worldmap2_uiscp_category.lua

-- 월드맵 카테고리
function WORLDMAP2_CATEGORY_GET_SELECT1()
    return ui.GetFrame('worldmap2_mainmap'):GetUserValue("CATEGORY1")
end

function WORLDMAP2_CATEGORY_GET_SELECT2()
    return ui.GetFrame('worldmap2_mainmap'):GetUserValue("CATEGORY2")
end

function WORLDMAP2_CATEGORY_SET_SELECT1(arg)
    ui.GetFrame('worldmap2_mainmap'):SetUserValue("CATEGORY1", arg)
end

function WORLDMAP2_CATEGORY_SET_SELECT2(arg)
    ui.GetFrame('worldmap2_mainmap'):SetUserValue("CATEGORY2", arg)
end

function WORLDMAP2_CATEGORY_INIT(frame)
    local style = "  "

    local category1 = AUTO_CAST(frame:GetChild("category_1"))
    local category2 = AUTO_CAST(frame:GetChild("category_2"))
    local category3 = AUTO_CAST(frame:GetChild("category_3"))

    WORLDMAP2_DROPLIST_SET(category1)
    WORLDMAP2_DROPLIST_SET(category2)
    WORLDMAP2_DROPLIST_SET(category3)

    category1:ClearItems()
    category2:ClearItems()
    category3:ClearItems()

    category1:ShowWindow(1)
    category2:ShowWindow(0)
    category3:ShowWindow(0)

    category1:AddItem("None",       style..ScpArgMsg("select_your_choice"))
    category1:AddItem("worldmap",   style..ScpArgMsg("Worldmap"))
    category1:AddItem("favorite",   style..ScpArgMsg("favorite"))
    category1:AddItem("colony",     style..ScpArgMsg("colony"))
    category1:AddItem("warp",       style..ScpArgMsg("last_warp_area"))
    category1:AddItem("guildtower", style..ScpArgMsg("GuildTower"))

    _select1 = WORLDMAP2_CATEGORY_GET_SELECT1()
    _select2 = WORLDMAP2_CATEGORY_GET_SELECT2()

    if frame:GetName() == "worldmap2_submap" then
        -- case 1. 콜로니
        if _select1 == "colony" then
            category1:SelectItemByKey("colony")
            WORLDMAP2_CATEGORY1_SELECT(frame)

            category2:SelectItemByKey(_select2)

        -- case 2. 즐겨찾기
        elseif _select1 == "favorite" then
            category1:SelectItemByKey("favorite")
            WORLDMAP2_CATEGORY1_SELECT(frame)

            category2:SelectItemByKey(_select2)

        -- case 3. 마지막 워프 위치
        elseif _select1 == "warp" then
            category1:SelectItemByKey("warp")

        -- case 4. 길드 타워
        elseif _select1 == "guildtower" then
            category1:SelectItemByKey("guildtower")

        -- base. 월드맵
        else
            local episode = WORLDMAP2_SUBMAP_EPISODE()

            category1:SelectItemByKey("worldmap")
            WORLDMAP2_CATEGORY1_SELECT(frame)

            category2:SelectItemByKey(episode)
            WORLDMAP2_CATEGORY2_SELECT(frame)
        end

        WORLDMAP2_CATEGORY_INIT(ui.GetFrame("worldmap2_mainmap"))
    end
end

function WORLDMAP2_CATEGORY1_SELECT(frame)
    local style = "      "
    local maxLine = 8

    local category1 = AUTO_CAST(frame:GetChild("category_1"))
    local category2 = AUTO_CAST(frame:GetChild("category_2"))
    local category3 = AUTO_CAST(frame:GetChild("category_3"))

    local layer1 = category1:GetSelItemKey()
    local layer2 = category2:GetSelItemKey()
    local layer3 = category3:GetSelItemKey()

    category2:ClearItems()
    category3:ClearItems()

    category2:ShowWindow(0)
    category3:ShowWindow(0)

    WORLDMAP2_CATEGORY_SET_SELECT1(layer1)

    if layer1 == "None" then
        return
    end

    -- 월드맵
    if layer1 == "worldmap" then
        category2:ShowWindow(1)
        category2:AddItem("None", style..ScpArgMsg("select_your_choice"))

        local list, cnt = GetClassList("worldmap2_data")
        for i = 1, cnt do
            local cls = SCR_GET_XML_IES("worldmap2_data", "Ordinal", i)[1]

            category2:AddItem(cls.ClassName, style..cls.Name)
        end

        category2:SetVisibleLine(math.min(maxLine, cnt+1))

    -- 콜로니
    elseif layer1 == "colony" then
        category2:ShowWindow(1)
        category2:AddItem("None", style..ScpArgMsg("select_your_choice"))

        local colonyDataList = GET_COLONY_MAP_LIST()
        for i = 1, #colonyDataList do
            local colonyData = colonyDataList[i]
            
            local mapName = string.gsub(colonyData.ZoneClassName, "GuildColony_", "")
            local mapData = GetClass("Map", mapName)

            category2:AddItem(mapName, style..mapData.Name)
        end

        category2:SetVisibleLine(math.min(maxLine, #colonyDataList+1))

    -- 즐겨찾기
    elseif layer1 == "favorite" then
        category2:ShowWindow(1)
        category2:AddItem("None", style..ScpArgMsg("select_your_choice"))

        local favoriteMapList = GET_FAVORITE_MAP_LIST()
        for i = 1, #favoriteMapList do
            local mapName = favoriteMapList[i]
            local mapData = GetClass("Map", mapName)

            category2:AddItem(mapName, style..mapData.Name)
        end

        category2:SetVisibleLine(math.min(maxLine, #favoriteMapList+1))

    -- 마지막 워프 위치
    elseif layer1 == "warp" then
        local mapName = GET_MY_LAST_WARP_POSITION()
        local episode = GET_EPISODE_BY_MAPNAME(mapName)

        if mapName ~= nil and episode ~= nil then
            if ui.GetFrame('worldmap2_submap'):IsVisible() == 1 then
                WORLDMAP2_SUBMAP_CHANGE(episode)
            else
                WORLDMAP2_SUBMAP_OPEN_FROM_MAINMAP_BY_EPISODE(episode)
            end

            WORLDMAP2_SUBMAP_ZONE_CHECK(mapName)
        end

    -- 길드 타워
    elseif layer1 == "guildtower" then
        local mapName = GET_GUILD_TOWER_POSITION()
        local episode = GET_EPISODE_BY_MAPNAME(mapName)

        if mapName ~= nil and episode ~= nil then
            if ui.GetFrame('worldmap2_submap'):IsVisible() == 1 then
                WORLDMAP2_SUBMAP_CHANGE(episode)
            else
                WORLDMAP2_SUBMAP_OPEN_FROM_MAINMAP_BY_EPISODE(episode)
            end

            WORLDMAP2_SUBMAP_ZONE_CHECK(mapName)
        else
            ui.SysMsg(ScpArgMsg("NoGuildTowerToShow"))
        end
    end
end

function WORLDMAP2_CATEGORY2_SELECT(frame)
    local style = "      "
    local maxLine = 8

    local category1 = AUTO_CAST(frame:GetChild("category_1"))
    local category2 = AUTO_CAST(frame:GetChild("category_2"))
    local category3 = AUTO_CAST(frame:GetChild("category_3"))

    local layer1 = category1:GetSelItemKey()
    local layer2 = category2:GetSelItemKey()
    local layer3 = category3:GetSelItemKey()

    category3:ClearItems()
    category3:ShowWindow(0)

    WORLDMAP2_CATEGORY_SET_SELECT2(layer2)

    if layer2 == "None" then
        return
    end

    -- 월드맵
    if layer1 == "worldmap" then
        local episode = layer2

        -- 메인맵인 경우: 해당 서브맵으로 이동
        if frame:GetName() == "worldmap2_mainmap" then
            WORLDMAP2_SUBMAP_OPEN_FROM_MAINMAP_BY_EPISODE(episode)

        -- 서브맵인 경우
        else
            -- 타겟 서브맵이 여기인 경우: 맵 리스트 생성
            if WORLDMAP2_SUBMAP_EPISODE() == episode then
                category3:ShowWindow(1)
                category3:AddItem("None", style..ScpArgMsg("select_your_choice"))

                local list = SCR_GET_XML_IES("worldmap2_submap_data", "Episode", episode)
                local count = 0

                for i = 1, #list do
                    local mapData = GetClass("Map", list[i].MapName)
                    local isInEpisode = list[i].IsInEpisode

                    if isInEpisode == "YES" then
                        category3:AddItem(mapData.ClassName, style..mapData.Name)
                        count = count + 1
                    end
                end

                category3:SetVisibleLine(math.min(maxLine, count+1))

            -- 타겟 서브맵이 여기가 아닌 경우: 해당 서브맵으로 이동
            else
                WORLDMAP2_SUBMAP_CHANGE(episode)
            end
        end

    -- 콜로니
    elseif layer1 == "colony" then
        local mapName = layer2
        local episode = GET_EPISODE_BY_MAPNAME(mapName)

        if frame:GetName() == "worldmap2_mainmap" then
            WORLDMAP2_SUBMAP_OPEN_FROM_MAINMAP_BY_EPISODE(episode)
        else
            if WORLDMAP2_SUBMAP_EPISODE() ~= episode then
                WORLDMAP2_SUBMAP_CHANGE(episode)
            end
        end

        WORLDMAP2_SUBMAP_ZONE_CHECK(mapName)

    -- 즐겨찾기
    elseif layer1 == "favorite" then
        local mapName = layer2
        local episode = GET_EPISODE_BY_MAPNAME(mapName)

        if frame:GetName() == "worldmap2_mainmap" then
            WORLDMAP2_SUBMAP_OPEN_FROM_MAINMAP_BY_EPISODE(episode)
        else
            if WORLDMAP2_SUBMAP_EPISODE() ~= episode then
                WORLDMAP2_SUBMAP_CHANGE(episode)
            end
        end

        WORLDMAP2_SUBMAP_ZONE_CHECK(mapName)
    end
end

function WORLDMAP2_CATEGORY3_SELECT(frame)
    local category1 = AUTO_CAST(frame:GetChild("category_1"))
    local category2 = AUTO_CAST(frame:GetChild("category_2"))
    local category3 = AUTO_CAST(frame:GetChild("category_3"))

    local layer1 = category1:GetSelItemKey()
    local layer2 = category2:GetSelItemKey()
    local layer3 = category3:GetSelItemKey()

    if layer3 == "None" then
        return
    end

    if layer1 == "worldmap" then
        local episode = layer2
        local mapName = layer3

        if ui.GetFrame("worldmap2_minimap"):IsVisible() == 1 then
            if WORLDMAP2_MINIMAP_MAPNAME() ~= mapName then
                ui.CloseFrame("worldmap2_minimap")
            end
        end

        WORLDMAP2_OPEN_MINIMAP_FROM_SUBMAP_BY_MAPNAME(mapName)
    end
end
