-- worldmap2_colonymap.lua

function WORLDMAP2_COLONYMAP_ON_INIT(addon, frame)
    addon:RegisterMsg('UPDATE_OTHER_GUILD_EMBLEM', 'ON_UPDATE_OTHER_GUILD_EMBLEM_WORLDMAP2_COLONYMAP')
end

-- OPEN / CLOSE
function OPEN_WORLDMAP2_COLONYMAP(frame)
	WORLDMAP2_COLONYMAP_INIT(frame)
end

function CLOSE_WORLDMAP2_COLONYMAP(frame)

end

-- INIT
function WORLDMAP2_COLONYMAP_INIT(frame)
	local colonyDataList = GET_COLONY_MAP_LIST()
	local championsCount = 0
	local challengesCount = 0

	local colonyChampionsBox = AUTO_CAST(frame:GetChild("colonymap_champions_gb"))
	local colonyChallengesBox = AUTO_CAST(frame:GetChild("colonymap_challenges_gb"))

	colonyChampionsBox:RemoveAllChild()
	colonyChallengesBox:RemoveAllChild()

	-- 스크롤바 세팅 (챔)
	colonyChampionsBox:SetScrollBarOffset(2, 1)
	colonyChampionsBox:SetScrollBarBottomMargin(0)
	colonyChampionsBox:SetScrollBarSkinName("worldmap2_scrollbar")

	-- 스크롤바 세팅 (챌)
	colonyChallengesBox:SetScrollBarOffset(2, 1)
	colonyChallengesBox:SetScrollBarBottomMargin(0)
	colonyChallengesBox:SetScrollBarSkinName("worldmap2_scrollbar")

	for i = 1, #colonyDataList do
		local colonyData = colonyDataList[i]

		local mapName = string.gsub(colonyData.ZoneClassName, "GuildColony_", "")
		local mapData = GetClass("Map", mapName)

		if colonyData.ColonyLeague == 1 then
			WORLDMAP2_COLONYMAP_INIT_CHAMPIONS_LEAGUE(frame, colonyData, mapData, championsCount)
			championsCount = championsCount + 1
		else
			WORLDMAP2_COLONYMAP_INIT_CHALLENGES_LEAGUE(frame, colonyData, mapData, challengesCount)
			challengesCount = challengesCount + 1
		end
	end
end

function WORLDMAP2_COLONYMAP_INIT_CHAMPIONS_LEAGUE(frame, colonyData, mapData, count)
	local gb = AUTO_CAST(frame:GetChild("colonymap_champions_gb"))
	local set = gb:CreateOrGetControlSet("colonymap_champions_league_set", colonyData.ClassName, 3, 123*count)

	local titleText = AUTO_CAST(set:GetChild("title_text"))
    local spotImage = AUTO_CAST(set:GetChild("spot_img"))
    local backgroundBtn = AUTO_CAST(set:GetChild("background_btn"))

	titleText:SetText("{@st102_16}I "..mapData.Name)
	backgroundBtn:SetUserValue("MAP_NAME", mapData.ClassName)

	local guildInfoTextCtrl = AUTO_CAST(set:GetChild("guild_info_text"))
	local taxCityInfoTextCtrl = AUTO_CAST(set:GetChild("tax_city_info_text"))
	local taxRateInfoTextCtrl = AUTO_CAST(set:GetChild("tax_rate_info_text"))

	local guildInfoText = ""
	local taxCityInfoText = ""
	local taxRateInfoText = ""

	local style = "{@st104gold_14}:{/}{@st100white_14}"

	-- 콜로니전 진행중
	if session.colonywar.GetProgressState() == true then
        spotImage:SetImage("colonymap_in_progress")
        spotImage:EnableHitTest(0)

		guildInfoText = style..ClMsg('ProgressColonyWar')
		taxCityInfoText = style..ClMsg('ProgressColonyWar')
		taxRateInfoText = style..ClMsg('ProgressColonyWar')
	else
		local taxApplyMap = GetClass("Map", colonyData.TaxApplyCity)
		local taxRateInfo = session.colonytax.GetColonyTaxRate(taxApplyMap.ClassID)

		-- 점령 길드 존재
        if taxRateInfo ~= nil then
            local guildID = taxRateInfo:GetGuildID()
            local cityMapID = taxRateInfo:GetCityMapID()
            local cityMapCls = GetClassByType("Map", cityMapID)
            
            guildInfoText = style..taxRateInfo:GetGuildName()
            taxCityInfoText = style..cityMapCls.Name
            taxRateInfoText = style..taxRateInfo:GetTaxRate().."%"

            -- 길드 엠블렘
            emblemSet = set:CreateOrGetControlSet('guild_emblem_set', 'EMBLEM_'..guildID, ui.CENTER_HORZ, ui.CENTER_VERT, 135, 0, 0, 0)
            emblemSet:EnableHitTest(0)

            local emblemPic = GET_CHILD_RECURSIVELY(emblemSet, 'emblemPic')
            local emblemedgePic = GET_CHILD_RECURSIVELY(emblemSet, "emblemedgePic")
            local emblemedgebgPic = GET_CHILD_RECURSIVELY(emblemSet, "emblemedgebgPic")

            emblemedgePic:SetImage("colony_league_part1")
            emblemedgebgPic:Resize(64, 64)

            -- 길드 엠블렘 불러오기
            local worldID = session.party.GetMyWorldIDStr()
            local emblemImgName = guild.GetEmblemImageName(guildID, worldID)

            if emblemImgName ~= 'None' then
                emblemPic:SetFileName(emblemImgName)
            else
                guild.ReqEmblemImage(guildID, worldID)
            end
            
            -- 기존 이미지 제거
            set:RemoveChild("spot_img")

		-- 점령 길드 미존재
		else
            spotImage:SetImage("colonymap_unoccupation2")
            spotImage:EnableHitTest(0)

			guildInfoText = style..ClMsg('NotOccupiedSpot')
			taxCityInfoText = style..ClMsg('NotOccupiedSpot')
			taxRateInfoText = style..ClMsg('NotOccupiedSpot')
		end
	end

	guildInfoTextCtrl:SetText(guildInfoText)
	taxCityInfoTextCtrl:SetText(taxCityInfoText)
	taxRateInfoTextCtrl:SetText(taxRateInfoText)
end

function WORLDMAP2_COLONYMAP_INIT_CHALLENGES_LEAGUE(frame, colonyData, mapData, count)
	local gb = AUTO_CAST(frame:GetChild("colonymap_challenges_gb"))
	local set = gb:CreateOrGetControlSet("colonymap_challenges_league_set", colonyData.ClassName, 3, 101*count)

	local titleText = AUTO_CAST(set:GetChild("title_text"))
    local spotImage = AUTO_CAST(set:GetChild("spot_img"))
    local backgroundBtn = AUTO_CAST(set:GetChild("background_btn"))

	titleText:SetText("{@st102_16}I "..mapData.Name)
	backgroundBtn:SetUserValue("MAP_NAME", mapData.ClassName)

	local guildInfoTextCtrl = AUTO_CAST(set:GetChild("guild_info_text"))
	local guildInfoText = ""
	local style = "{@st104gold_14}:{/}{@st100white_14}"

	-- 콜로니전 진행중
	if session.colonywar.GetProgressState() == true then
        spotImage:SetImage("colonymap_in_progress")
        spotImage:EnableHitTest(0)

		guildInfoText = style..ClMsg('ProgressColonyWar')
	else
		local taxApplyMap = GetClass("Map", colonyData.TaxApplyCity)
		local taxRateInfo = session.colonytax.GetColonyTaxRate(taxApplyMap.ClassID)

		-- 점령 길드 존재
        if taxRateInfo ~= nil then
            local guildID = taxRateInfo:GetGuildID()
            local guildName = taxRateInfo:GetGuildName()

            guildInfoText = style..guildName

            -- 길드 엠블렘
            emblemSet = set:CreateOrGetControlSet('guild_emblem_set', 'EMBLEM_'..guildID, ui.CENTER_HORZ, ui.CENTER_VERT, 135, 0, 0, 0)
            emblemSet:EnableHitTest(0)

            local emblemPic = GET_CHILD_RECURSIVELY(emblemSet, 'emblemPic')
            local emblemedgePic = GET_CHILD_RECURSIVELY(emblemSet, "emblemedgePic")
            local emblemedgebgPic = GET_CHILD_RECURSIVELY(emblemSet, "emblemedgebgPic")

            emblemedgePic:SetImage("colony_league_part2")
            emblemedgebgPic:Resize(64, 64)

            -- 길드 엠블렘 불러오기
            local worldID = session.party.GetMyWorldIDStr()
            local emblemImgName = guild.GetEmblemImageName(guildID, worldID)

            if emblemImgName ~= 'None' then
                emblemPic:SetFileName(emblemImgName)
            else
                guild.ReqEmblemImage(guildID, worldID)
            end

            -- 기존 이미지 제거
            set:RemoveChild("spot_img")

		-- 점령 길드 미존재
		else
            spotImage:SetImage("colonymap_unoccupation")
            spotImage:EnableHitTest(0)

			guildInfoText = style..ClMsg('NotOccupiedSpot')
		end
	end

	guildInfoTextCtrl:SetText(guildInfoText)
end

function WORLDMAP2_COLONYMAP_SET_PREVIEW(mapName)
    local frame = ui.GetFrame("worldmap2_colonymap")
    if frame:IsVisible() == 0 then
        return
    end

    local mapData = GetClass("Map", mapName)
    if mapData == nil then
        return
    end

	-- 이름
	do
		local previewText = AUTO_CAST(frame:GetChild("colonymap_preview_text"))
		previewText:SetText("{@st101lightbrown_16}>> "..mapData.Name)
	end

	-- 이미지
	do
		local previewBox = AUTO_CAST(frame:GetChild("colonymap_preview_gb"))
		previewBox:RemoveAllChild()

		local mapWidth = previewBox:GetWidth()
		local mapHeight = previewBox:GetHeight()

        local pic = AUTO_CAST(previewBox:CreateOrGetControl('picture', "picture_"..mapName, ui.CENTER_HORZ, ui.CENTER_VERT, previewBox:GetWidth(), previewBox:GetHeight()))
        local picName = "worldmap2_Colony_"..mapName

		pic:SetEnableStretch(1)
		pic:SetImage(picName)
	end

	-- 버튼
	do
		local previewBtn = AUTO_CAST(frame:GetChild("colonymap_preview_btn"))
		previewBtn:SetUserValue("MAP_NAME", mapName)
	end
end

-- SCRIPT LIST

-- 버튼을 통한 프리뷰 세팅
function WORLDMAP2_COLONYMAP_SET_PREVIEW_BY_BTN(frame, ctrl)
    WORLDMAP2_COLONYMAP_SET_PREVIEW(ctrl:GetUserValue("MAP_NAME"))
end

-- 프리뷰 맵으로 이동
function WORLDMAP2_COLONYMAP_GO_PREVIEW(frame, ctrl)
	local submap = ui.GetFrame('worldmap2_submap')
	local minimap = ui.GetFrame('worldmap2_minimap')

	local mapName = ctrl:GetUserValue("MAP_NAME")
	local episode = GET_EPISODE_BY_MAPNAME(mapName)

	if episode == nil then
		return
	end

	-- 미니맵: 일단 닫고 시작
	if minimap:IsVisible() == 1 then
		ui.CloseFrame('worldmap2_minimap')
	end

	-- 서브맵이 열려있는 경우: 서브맵 변환
	if submap:IsVisible() == 1 then
		WORLDMAP2_SUBMAP_CHANGE(episode)

	-- 월드맵이 열려있는 경우: 서브맵 진입
	else
		WORLDMAP2_SUBMAP_OPEN_FROM_MAINMAP_BY_EPISODE(episode)
	end

	WORLDMAP2_SUBMAP_ZONE_CHECK(mapName)
end

-- 길드 엠블럼 업데이트
function ON_UPDATE_OTHER_GUILD_EMBLEM_WORLDMAP2_COLONYMAP(frame, msg, argStr, argNum)
    local worldID = session.party.GetMyWorldIDStr()
    local emblemImgName = guild.GetEmblemImageName(argStr, worldID)

    if emblemImgName == 'None' then
        return
    end

    local colonyDataList = GET_COLONY_MAP_LIST()

    for i = 1, #colonyDataList do
        local colonyData = colonyDataList[i]
        local controlName = colonyData.ClassName
        local targetControl = GET_CHILD_RECURSIVELY(frame, controlName)

        if targetControl == nil then
            return
        end

        -- 해당 길드의 엠블럼셋이 존재할 경우 이미지 부여
        local emblemSet = GET_CHILD_RECURSIVELY(targetControl, 'EMBELM_'..argStr)
        if emblemSet ~= nil then
            GET_CHILD_RECURSIVELY(emblemSet, 'emblemPic'):SetFileName(emblemImgName)
        end
    end
end