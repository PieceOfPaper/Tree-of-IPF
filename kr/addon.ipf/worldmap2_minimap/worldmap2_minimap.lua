-- worldmap2_minimap.lua

function WORLDMAP2_MINIMAP_ON_INIT(addon, frame)
    addon:RegisterMsg('REQUEST_TOKEN_WARP', 'ON_REQUEST_TOKEN_WARP')
    addon:RegisterMsg('TOGGLE_FAVORITE_MAP', 'ON_TOGGLE_FAVORITE_MAP')
end

-- TAB
local QUEST_TAB = 0
local NPC_TAB = 1
local MONSTER_TAB = 2

-- INFO
local CHECKBOX = nil
local EFFECT_LIST = {}

-- SETTING
function WORLDMAP2_MINIMAP_MAPNAME()
	return ui.GetFrame("worldmap2_minimap"):GetUserConfig("MAP_NAME")
end

function WORLDMAP2_MINIMAP_SET_MAPNAME(mapName)
	local minimapFrame = ui.GetFrame('worldmap2_minimap')
	minimapFrame:SetUserConfig("MAP_NAME", mapName)
end

-- OPEN / CLOSE
function OPEN_WORLDMAP2_MINIMAP(frame)
    WORLDMAP2_MINIMAP_DRAW(frame)
    WORLDMAP2_MINIMAP_DRAW_BASE(frame)

	WORLDMAP2_SUBMAP_EFFECT_OFF()
end

function CLOSE_WORLDMAP2_MINIMAP(frame)
	WORLDMAP2_SUBMAP_EFFECT_ON()
end

-- DRAW
function WORLDMAP2_MINIMAP_DRAW(frame)
	WORLDMAP2_MINIMAP_DRAW_FOGMAP(frame)
	WORLDMAP2_MINIMAP_INFO_SETTING(frame)
end

function WORLDMAP2_MINIMAP_DRAW_BASE(frame)
	local mapName = WORLDMAP2_MINIMAP_MAPNAME()
	local mapCls = GetClass("Map", mapName)

	-- 제목
	do
		local minimapTitleText = AUTO_CAST(frame:GetChild("minimap_title_text"))
        local minimapFogText = AUTO_CAST(frame:GetChild("minimap_fog_text"))

		local fogPercent = GET_ZONE_FOG_PERCENT(mapCls)
        local fogText = ""
        local taxInfo = nil

        if mapCls.MapType ~= "City" then
            fogText = "{@st100white_16}"..ClMsg("fog_rate")..": {/}"

            if fogPercent < 100 then
                fogText = fogText.."{@st100green_16}"
            else
                fogText = fogText.."{@st100gray_16}"
            end

            fogText = fogText..fogPercent.."%"
        else
            taxInfo = session.colonytax.GetColonyTaxRate(mapCls.ClassID)
            
            if taxInfo ~= nil then
                fogText = "{@st100white_16}"..ClMsg("TaxRate")..": {/}"..taxInfo:GetTaxRate().."%"
            end
        end

		minimapTitleText:SetText("{@st100cream_24}"..GET_ZONE_NAME(mapCls))
        minimapFogText:SetText(fogText)
    end

	-- 적정 레벨
	do
		local minimapLevelText = AUTO_CAST(frame:GetChild("minimap_level_text"))
		local levelText = "{@st100white_16}"..ClMsg("average_level").."{/} {@st105_y_16}"..GET_ZONE_QUEST_LEVEL(mapCls)

		minimapLevelText:SetText(levelText)
    end
    
    -- 챌린지 모드
	do
		local minimapChallengeText = AUTO_CAST(frame:GetChild("minimap_challenge_text"))
        local challengeText = "{@st100white_16}"
        
        if GET_CHALLGENE_MODE_ENABLE(mapCls) then
            local lv1, lv2 = GET_CHALLGENE_MODE_ENABLE_LEVEL(mapCls)
            challengeText = challengeText..ClMsg("challenge_level_enable").."{/} {@st105_y_16}"..lv1.." ~ "..lv2
        else
            challengeText = challengeText..ClMsg("challenge_level_disable")
        end

		minimapChallengeText:SetText(challengeText)
	end

	-- 별
	do
		local minimapStarRate = AUTO_CAST(frame:GetChild("minimap_star_rate"))
		local imageName = "worldmap2_icon_star_"..GET_STAR_RATE(mapCls)

		minimapStarRate:SetImage(imageName)
	end

	-- 토큰
	do
        local minimapTokenBtn = AUTO_CAST(frame:GetChild("minimap_token_btn"))
		local isTokenState = session.loginInfo.IsPremiumState(ITEM_TOKEN)
		local imageName = ""

		if isTokenState == true and GET_TOKEN_WARP_COOLDOWN() == 0 then
			imageName = "{img worldmap2_token_gold 38 38} {@st101lightbrown_16}"
		else
			imageName = "{img worldmap2_token_gray 38 38} {@st101lightbrown_16}"
		end

		minimapTokenBtn:SetText(imageName..ScpArgMsg("TokenWarp"))
    end
    
    -- 던전 리스트
    do
        local minimapDungeonList = AUTO_CAST(frame:GetChild("minimap_dungeon_list"))
        local minimapDungeonListPic = AUTO_CAST(frame:GetChild("minimap_dungeon_list_pic"))

        WORLDMAP2_DROPLIST_SET(minimapDungeonList)

        minimapDungeonList:ClearItems()

        local subMapData = nil
        local subMapDataList = SCR_GET_XML_IES("worldmap2_submap_data", "MapName", mapName)

        for i = 1, #subMapDataList do
            if subMapDataList[i].IsInEpisode == "YES" then
                subMapData = subMapDataList[i]
                break
            end
        end

        if subMapData.DungeonName ~= "None" then
            minimapDungeonList:ShowWindow(1)
            minimapDungeonListPic:ShowWindow(1)
            
            local dungeonList = SCR_GET_XML_IES("worldmap2_submap_data", "DungeonName", subMapData.DungeonName)
            for i = 1, #dungeonList do
                local dungeonName = dungeonList[i].MapName
                local dungeonData = GetClass('Map', dungeonName)
                
                minimapDungeonList:AddItem(dungeonName, "       "..dungeonData.Name)
            end

            minimapDungeonList:SetVisibleLine(#dungeonList)
            minimapDungeonList:SelectItemByKey(mapName)
        else
            minimapDungeonList:ShowWindow(0)
            minimapDungeonListPic:ShowWindow(0)
        end
    end

    -- 즐겨찾기
    do
        local minimapBookMark = AUTO_CAST(frame:GetChild("minimap_bookmark_btn"))
        local minimapTitleText = AUTO_CAST(frame:GetChild("minimap_title_text"))

        local length = minimapTitleText:GetWidth()
        local margin = minimapTitleText:GetMargin()

        minimapBookMark:SetMargin(margin.left - length/2 - 18, margin.top, margin.right, margin.bottom)

        if IS_FAVORITE_MAP(mapName) then
            minimapBookMark:SetCheck(1)
            minimapBookMark:SetTextTooltip(ScpArgMsg("RemoveBookMark"))
        else
            minimapBookMark:SetCheck(0)
            minimapBookMark:SetTextTooltip(ScpArgMsg("AddBookMark"))
        end
    end
end

function WORLDMAP2_MINIMAP_DRAW_FOGMAP(frame)
	local frame = AUTO_CAST(frame:GetChild("minimap_pic_bg"))
	frame:RemoveAllChild()

	local mapName = WORLDMAP2_MINIMAP_MAPNAME()
	local mapWidth = frame:GetWidth()
	local mapHeight = frame:GetHeight()

	local pic = AUTO_CAST(frame:CreateOrGetControl('picture', "picture_"..mapName, ui.CENTER_HORZ, ui.CENTER_VERT, mapWidth, mapHeight))
	pic:SetEnableStretch(1)

	local isValid = ui.IsImageExist(mapName .. "_fog")
	if isValid == false then
		world.PreloadMinimap(mapName)
	end

        pic:SetImage(mapName .. "_fog")

	local iconGroup = frame:CreateOrGetControl("groupbox", "MapIconGroup", ui.CENTER_HORZ, ui.CENTER_VERT, frame:GetWidth(), frame:GetHeight())
	iconGroup:SetSkinName("None")
	
	local nameGroup = frame:CreateOrGetControl("groupbox", "RegionNameGroup", ui.CENTER_HORZ, ui.CENTER_VERT, frame:GetWidth(), frame:GetHeight())
	nameGroup:SetSkinName("None")

	UPDATE_MAP_BY_NAME(iconGroup, mapName, pic, mapWidth, mapHeight, 0, 0)
	MAKE_MAP_AREA_INFO(nameGroup, mapName, "{s15}", mapWidth, mapHeight, -100, -30)
end

function WORLDMAP2_MINIMAP_INFO_SETTING(frame)
	local minimapInfoBox = AUTO_CAST(frame:GetChild("minimap_info_bg"))
	local minimapInfoTab = AUTO_CAST(frame:GetChild("minimap_info_tab"))
    local minimapInfoTabIndex = minimapInfoTab:GetSelectItemIndex()
    
    -- 이펙트 & 체크박스 초기화
    WORLDMAP2_MINIMAP_EFFECT_OFF()
    CHECKBOX = nil

	-- 스크롤바 상시표기용 더미
	minimapInfoBox:RemoveAllChild()
	minimapInfoBox:CreateOrGetControlSet("minimap_info_quest_set", "dummy", minimapInfoBox:GetWidth(), minimapInfoBox:GetHeight()-37)

	-- 스크롤바 세팅
	minimapInfoBox:SetScrollBarOffset(2, 1)
	minimapInfoBox:SetScrollBarBottomMargin(0)
	minimapInfoBox:SetScrollBarSkinName("worldmap2_scrollbar")

	-- 텍스트 세팅
	local questText = AUTO_CAST(frame:GetChild("minimap_quest_tab_text"))
	local npcText = AUTO_CAST(frame:GetChild("minimap_npc_tab_text"))
	local monsterText = AUTO_CAST(frame:GetChild("minimap_monster_tab_text"))

    questText:SetMargin(questText:GetMargin().left, -300, 0, 0)
    questText:EnableHitTest(0)

    npcText:SetMargin(npcText:GetMargin().left, -300, 0, 0)
    npcText:EnableHitTest(0)

    monsterText:SetMargin(monsterText:GetMargin().left, -300, 0, 0)
    monsterText:EnableHitTest(0)

	if minimapInfoTabIndex == QUEST_TAB then
		questText:SetMargin(questText:GetMargin().left, -303, 0, 0)
	elseif minimapInfoTabIndex == NPC_TAB then
		npcText:SetMargin(npcText:GetMargin().left, -303, 0, 0)
	elseif minimapInfoTabIndex == MONSTER_TAB then
		monsterText:SetMargin(monsterText:GetMargin().left, -303, 0, 0)
	end

	-- 정보 세팅
	if minimapInfoTabIndex == QUEST_TAB then
		WORLDMAP2_MINIMAP_QUEST_INFO(frame)
	elseif minimapInfoTabIndex == NPC_TAB then
		WORLDMAP2_MINIMAP_NPC_INFO(frame)
	elseif minimapInfoTabIndex == MONSTER_TAB then
		WORLDMAP2_MINIMAP_MONSTER_INFO(frame)
	end
end

function WORLDMAP2_MINIMAP_OPEN_INFO_BY_TEXT(frame, ctrl, argStr, argNum)
    local tab = frame:GetChild("minimap_info_tab")

    tab:SelectTab(argNum)
    imcSound.PlaySoundEvent("inven_arrange")

	WORLDMAP2_MINIMAP_INFO_SETTING(frame)
end

function WORLDMAP2_MINIMAP_QUEST_INFO(frame)
	local count = 0

	local pc = GetMyPCObject()
	local questClsList, questCnt = GetClassList('QuestProgressCheck')

	for i = 0, questCnt - 1 do
		local questIES = GetClassByIndexFromList(questClsList, i)

		local nowMap = WORLDMAP2_MINIMAP_MAPNAME()

		local cond1 = questIES.PossibleUI_Notify ~= 'NO'
		local cond2 = questIES.Level ~= 9999
		local cond3 = questIES.Lvup ~= -9999
		local cond4 = questIES.QuestStartMode ~= 'NPCENTER_HIDE'
		local cond5 = questIES.QuestMode ~= 'KEYITEM'
		
		if cond1 and cond2 and cond3 and cond4 and cond5 then
            local questProgress = SCR_QUEST_CHECK_C(pc, questIES.ClassName)

            -- 시작 가능
            if questProgress == "POSSIBLE" and questIES.StartMap == nowMap then
				WORLDMAP2_MINIMAP_QUEST_INFO_ADD(frame, questIES, count, questProgress)
                count = count + 1
            end

            -- 진행중
            if questProgress == "PROGRESS" and questIES.ProgMap == nowMap then
				WORLDMAP2_MINIMAP_QUEST_INFO_ADD(frame, questIES, count, questProgress)
                count = count + 1
            end

            -- 성공
            if questProgress == "SUCCESS" and questIES.EndMap == nowMap then
				WORLDMAP2_MINIMAP_QUEST_INFO_ADD(frame, questIES, count, questProgress)
                count = count + 1
            end
		end
    end
    
    -- 표시할 XXX가 없습니다.
    local noText = AUTO_CAST(frame:GetChild("minimap_nothing_text"))

    if count == 0 then
        noText:SetText("{@st100brown_16}"..ScpArgMsg("NoQuestToShow"))
        noText:ShowWindow(1)
    else
        noText:ShowWindow(0)
    end
end

function WORLDMAP2_MINIMAP_QUEST_INFO_ADD(frame, questIES, count, state)
	local minimapInfoBox = AUTO_CAST(frame:GetChild("minimap_info_bg"))
	local minimapQuestSet = minimapInfoBox:CreateOrGetControlSet("minimap_info_quest_set", questIES.ClassName, 0, 41*count)

	local spotImg = AUTO_CAST(minimapQuestSet:GetChild("spot_img"))
	local checkImg = AUTO_CAST(minimapQuestSet:GetChild("check_img"))
    local questBox = AUTO_CAST(minimapQuestSet:GetChild("quest_box"))
    local imageName = GET_QUESTINFOSET_ICON_BY_STATE_MODE(state, questIES)

    -- 퀘스트 표기
	if questIES.QuestMode == 'MAIN' then
		questBox:SetText(' {img '..imageName..' 28 28} {@st70_m_16}'..questIES.Name)
	elseif questIES.QuestMode == 'SUB' then
		questBox:SetText(' {img '..imageName..' 28 28} {@st70_s_16}'..questIES.Name)
	elseif questIES.QuestMode == 'REPEAT' then
		questBox:SetText(' {img '..imageName..' 28 28} {@st70_d_16}'..questIES.Name)

	-- 나머지는 서브퀘스트 취급
	else
		questBox:SetText(' {img '..imageName..' 28 28} {@st70_s_16}'..questIES.Name)
	end
    
    -- 위치보기 세팅
    spotImg:SetUserValue("QUEST_NAME", questIES.ClassName)
    
    -- 체크박스 세팅
    if quest.IsCheckQuest(questIES.ClassID) == true then
        checkImg:SetCheck(1)
    end

    checkImg:SetEventScript(ui.LBUTTONDOWN, "ADD_QUEST_INFOSET_CTRL");
    checkImg:SetEventScriptArgNumber(ui.LBUTTONDOWN, questIES.ClassID);
end

function WORLDMAP2_MINIMAP_QUEST_LOCATION(frame, ctrl)
	local mapName = WORLDMAP2_MINIMAP_MAPNAME()
	local questName = ctrl:GetUserValue("QUEST_NAME")
    local controlNameList = GET_QUEST_CONTROL_NAME_LIST(mapName, questName)

    WORLDMAP2_MINIMAP_LOCATION_MANAGER(questName, controlNameList)
end

function WORLDMAP2_MINIMAP_NPC_INFO(frame)
    local mapName = WORLDMAP2_MINIMAP_MAPNAME()
    local mapProp = geMapTable.GetMapProp(mapName)
    local monGens = mapProp.mongens

    local count = 0

    for i = 0, monGens:Count()-1 do
        local monProp = monGens:Element(i)
        local monDialog = monProp:GetDialog()
        local monGenType = GetNPCState(mapProp:GetClassName(), monProp.GenType)
        local hideNPCData = GetClass("HideNPC", monDialog)

        if monGenType ~= nil then
            if hideNPCData ~= nil then
                local cond1 = monProp.Minimap >= 1
                local cond2 = GetNPCState(mapProp:GetClassName(), monProp.GenType) > 0
                local cond3 = TryGetProp(GetMyEtcObject(), "Hide_"..hideNPCData.ClassID, 1) ~= 1
                local cond4 = monProp:GetName() ~= "UnvisibleName"

                if cond1 and cond2 and cond3 and cond4 then
                    WORLDMAP2_MINIMAP_NPC_INFO_ADD(frame, monProp, count)
                    count = count + 1
                end
            else
                local cond1 = monProp.Minimap >= 1
                local cond2 = GetNPCState(mapProp:GetClassName(), monProp.GenType) > 0
                local cond3 = monProp:GetName() ~= "UnvisibleName"

                if cond1 and cond2 and cond3 then
                    WORLDMAP2_MINIMAP_NPC_INFO_ADD(frame, monProp, count)
                    count = count + 1
                end
            end
        end
    end

    -- 표시할 XXX가 없습니다.
    local noText = AUTO_CAST(frame:GetChild("minimap_nothing_text"))

    if count == 0 then
        noText:SetText("{@st100brown_16}"..ScpArgMsg("NoNPCToShow"))
        noText:ShowWindow(1)
    else
        noText:ShowWindow(0)
    end
end

function WORLDMAP2_MINIMAP_NPC_INFO_ADD(frame, monProp, count)
	local minimapInfoBox = AUTO_CAST(frame:GetChild("minimap_info_bg"))
    local minimapNPCSet = minimapInfoBox:CreateOrGetControlSet("minimap_info_npc_set", monProp:GetClassName()..count, 0, 41*count)

    local npcBox = AUTO_CAST(minimapNPCSet:GetChild("npc_box"))
    local spotImg = AUTO_CAST(minimapNPCSet:GetChild("spot_img"))
    
    local npcName = string.gsub(monProp:GetName(), "{nl}", " ")
    local iconName = monProp:GetMinimapIcon()

    if iconName == nil or iconName == 'None' then
        iconName = 'minimap_0'
    end

    npcBox:SetText(' {img '..iconName..' 26 26} {@st100lg_16}'..npcName)

    spotImg:SetUserValue("NPC_NAME", GET_GENNPC_NAME(frame, monProp))
    spotImg:SetUserValue("CHECKBOX_NAME", monProp:GetClassName()..count)
end

function WORLDMAP2_MINIMAP_NPC_LOCATION(frame, ctrl)
    local npcName = ctrl:GetUserValue("NPC_NAME")
    local checkBoxName = ctrl:GetUserValue("CHECKBOX_NAME")
    local controlNameList = {}

    controlNameList[#controlNameList+1] = npcName

    WORLDMAP2_MINIMAP_LOCATION_MANAGER(checkBoxName, controlNameList)
end

function WORLDMAP2_MINIMAP_MONSTER_INFO(frame)
    local mapName = WORLDMAP2_MINIMAP_MAPNAME()
    local mapProp = geMapTable.GetMapProp(mapName)
    local monGens = mapProp.mongens

    local count = 0

    for i = 0, monGens:Count()-1 do
        local monProp = monGens:Element(i)
        local monName = monProp:GetName()
        local faction = monProp:GetFaction()

        if faction == "Monster" and monName ~= "UnvisibleName" then
            local className = monProp:GetClassType()
            local monster = GetClass("Monster", className)

            -- 동일한 몬스터 목록이 없는 경우 생성
            if GET_CHILD_RECURSIVELY(frame, monster.Name) == nil then
                WORLDMAP2_MINIMAP_MONSTER_INFO_ADD(frame, className, count)
                count = count + 1
            end
        end
    end

    -- 표시할 XXX가 없습니다.
    local noText = AUTO_CAST(frame:GetChild("minimap_nothing_text"))

    if count == 0 then
        noText:SetText("{@st100brown_16}"..ScpArgMsg("NoMonsterToShow"))
        noText:ShowWindow(1)
    else
        noText:ShowWindow(0)
    end
end

function WORLDMAP2_MINIMAP_MONSTER_INFO_ADD(frame, className, count)
    local monster = GetClass("Monster", className)

    local level = monster.Level
    local npcName = monster.Name
    local iconName = monster.Icon

    local minimapInfoBox = AUTO_CAST(frame:GetChild("minimap_info_bg"))
    local minimapMonsterSet = minimapInfoBox:CreateOrGetControlSet("minimap_info_monster_set", npcName, 0, 83*count)

    local monsterIcon = AUTO_CAST(minimapMonsterSet:GetChild("monster_icon"))
    local monsterIconFrame = AUTO_CAST(minimapMonsterSet:GetChild("monster_icon_frame"))

    monsterIcon:SetImage(iconName)
    monsterIcon:SetEnableStretch(1)
    monsterIconFrame:SetImage("worldmap2_monframe")

    local monsterBox = AUTO_CAST(minimapMonsterSet:GetChild("monster_box"))
    local monsterLevelText = AUTO_CAST(minimapMonsterSet:GetChild("level_text"))
    local fieldBossText = AUTO_CAST(minimapMonsterSet:GetChild("fieldboss_text"))

    monsterBox:SetTextOffset(90, 0)
    monsterBox:SetText('{@st100lg_16}'..npcName)
    monsterLevelText:SetText('{@st105_y_16}Lv.'..level)

    if string.find(className, "F_boss") ~= nil then
        fieldBossText:SetText("{@st100red_16}"..ScpArgMsg("FieldBoss"))
    end
end

function WORLDMAP2_MINIMAP_LOCATION_MANAGER(checkBoxName, controlNameList)
    
    WORLDMAP2_MINIMAP_EFFECT_OFF()

    -- 활성화된 체크박스가 없는 경우: 지정된 위치에 이펙트를 켜고 CHECKBOX에 등록
    if CHECKBOX == nil then
        WORLDMAP2_MINIMAP_EFFECT_ON(controlNameList)
        CHECKBOX = checkBoxName

    -- 활성화된 체크박스가 있는 경우
    else
        -- 클릭된 체크박스인 경우: CHECKBOX 초기화
        if CHECKBOX == checkBoxName then
            CHECKBOX = nil

        -- 다른 체크박스인 경우: 기존에 켜져있던 이펙트를 끔, 지정된 위치에 이펙트를 켜고 CHECKBOX에 등록
        else
            WORLDMAP2_MINIMAP_EFFECT_ON(controlNameList)

            local frame = ui.GetFrame('worldmap2_minimap')
            local nowOnChild = GET_CHILD_RECURSIVELY(frame, CHECKBOX)
            local nowOnCheckBox = AUTO_CAST(nowOnChild:GetChild("spot_img"))

            nowOnCheckBox:SetCheck(0)
            CHECKBOX = checkBoxName
        end
    end
end

function WORLDMAP2_MINIMAP_EFFECT_ON(controlNameList)
    local frame = ui.GetFrame('worldmap2_minimap')
    local picBox = AUTO_CAST(frame:GetChild('minimap_pic_bg'))

    for i = 1, #controlNameList do
        local controlName = controlNameList[i]
        local control = GET_CHILD_RECURSIVELY(picBox, controlName)

        if control ~= nil then
            local pos = control:GetMargin()
            local checkImg = AUTO_CAST(picBox:CreateControl('picture', controlName.."_check"..i, 0, 0, 44, 44))

            checkImg:SetGravity(ui.LEFT, ui.TOP)
            checkImg:SetEnableStretch(1)
            checkImg:ShowWindow(1)

            checkImg:SetMargin(pos.left-5, pos.top-5, pos.right, pos.bottom)
            checkImg:SetImage("worldmap2_map_zonecheck")

            EFFECT_LIST[#EFFECT_LIST+1] = controlName.."_check"..i
        end
    end
end

function WORLDMAP2_MINIMAP_EFFECT_OFF()
    local frame = ui.GetFrame('worldmap2_minimap')
    local picBox = AUTO_CAST(frame:GetChild('minimap_pic_bg'))
    
    for i = 1, #EFFECT_LIST do
        picBox:RemoveChild(EFFECT_LIST[i])
    end

    EFFECT_LIST = {}
end

function WORLDMAP2_MINIMAP_SELECT_DUNGEON(frame)
    local dungeonList = AUTO_CAST(frame:GetChild("minimap_dungeon_list"))
    local dungeonName = dungeonList:GetSelItemKey()

    if dungeonName == WORLDMAP2_MINIMAP_MAPNAME() then
        return
    end

    CLOSE_WORLDMAP2_MINIMAP(frame)
    WORLDMAP2_MINIMAP_SET_MAPNAME(dungeonName)
    OPEN_WORLDMAP2_MINIMAP(frame)

    dungeonList:SelectItemByKey(dungeonName)
end

-- Script List

-- 토큰 이동
function WORLDMAP2_MINIMAP_CLICK_TOKEN_BTN()
    WORLDMAP2_TOKEN_WARP(WORLDMAP2_MINIMAP_MAPNAME())
end

function ON_REQUEST_TOKEN_WARP(frame, msg, argStr, argNum)
    WORLDMAP2_TOKEN_WARP(argStr)
end

-- 즐겨찾기 (갱신)
function ON_TOGGLE_FAVORITE_MAP(frame, msg, argStr, argNum)
    local minimapBookMark = AUTO_CAST(frame:GetChild("minimap_bookmark_btn"))

    if IS_FAVORITE_MAP(WORLDMAP2_MINIMAP_MAPNAME()) then
        minimapBookMark:SetCheck(1)
        minimapBookMark:SetTextTooltip(ScpArgMsg("RemoveBookMark"))
    else
        minimapBookMark:SetCheck(0)
        minimapBookMark:SetTextTooltip(ScpArgMsg("AddBookMark"))
    end
end