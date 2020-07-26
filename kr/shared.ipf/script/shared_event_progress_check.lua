-- 이벤트 진행 확인 UI 설정 lua
--  type =   1 : 정규 여신의 룰렛 
--           2 : 시즌 서버 여신의 룰렛
--           3 : 메데이나 flex box

function GET_EVENT_PROGRESS_CHECK_TITLE(type)
    local table = 
    {
        [1] = "GODDESS_ROULETTE",
        [2] = "GODDESS_ROULETTE",
        [3] = "EVENT_2007_FLEX_BOX_DESC",
    }

    return table[type];
end

function GET_EVENT_PROGRESS_CHECK_ITEM(type)
    local table = 
    {
        [1] = "Event_Roulette_Coin_2",
        [2] = "Event_Roulette_Coin",
        [3] = "EVENT_Flex_Gold_Moneybag",
    }

    return table[type];
end

function GET_EVENT_PROGRESS_CHECK_NOTE_BTN(type)
    local table = 
    {
        [1] = "ON_EVENT_STAMP_TOUR_UI_OPEN_COMMAND",
        [2] = "ON_EVENT_STAMP_TOUR_UI_OPEN_COMMAND",
        [3] = "ON_EVENT_STAMP_TOUR_UI_OPEN_COMMAND_SUMMER",
    }

    return table[type];
end

function GET_EVENT_PROGRESS_CHECK_TAB_TITLE(type)
    local table = 
    {
        [1] = {"Acquire_State", "STAMP_TOUR", "Auto_KeonTenCheu"},
        [2] = {"Acquire_State", "STAMP_TOUR", "Auto_KeonTenCheu"},
        [3] = {"Acquire_State", "TOS_VACANCE", "Auto_KeonTenCheu"},
    }

    return table[type];
end

function GET_EVENT_PROGRESS_CHECK_CUR_VALUE(type, accObj)
    local table = 
    {
        [1] = {TryGetProp(accObj, "GODDESS_ROULETTE_COIN_ACQUIRE_COUNT", 0), TryGetProp(accObj, "GODDESS_ROULETTE_DAILY_PLAY_TIME_MINUTE", 0), GET_EVENT_PROGRESS_STAMP_TOUR_CLEAR_COUNT(), TryGetProp(accObj, "GODDESS_ROULETTE_DAILY_CONTENTS_ACQUIRE_COUNT", 0), TryGetProp(accObj, "GODDESS_ROULETTE_USE_ROULETTE_COUNT", 0)},
        [2] = {TryGetProp(accObj, "EVENT_NEW_SEASON_SERVER_COIN_ACQUIRE_COUNT", 0), TryGetProp(accObj, "EVENT_NEW_SEASON_SERVER_DAY_PLAY_TIME_MINUTE", 0), GET_EVENT_PROGRESS_STAMP_TOUR_CLEAR_COUNT(), CREATE_EVENT_PROGRESS_CHECK_CONTENTS_MISSION_CLEAR_COUNT(), TryGetProp(accObj, "EVENT_NEW_SEASON_SERVER_USE_ROULETTE_COUNT", 0)},
        [3] = {TryGetProp(accObj, "EVENT_FLEX_BOX_ACQUIRE_CONSUME_COUNT", 0), TryGetProp(accObj, "EVENT_FLEX_BOX_DAILY_PLAY_CONSUME_COUNT", 0), GET_EVENT_PROGRESS_STAMP_TOUR_CLEAR_COUNT(), TryGetProp(accObj, "EVENT_FLEX_BOX_DAILY_CONTENTS_CONSUME_COUNT", 0), TryGetProp(accObj, "EVENT_FLEX_BOX_OPEN_COUNT", 0)},
    }

    return table[type];
end

function GET_EVENT_PROGRESS_CHECK_TIP_TEXT(type)
    local table = 
    {
        [1] = {"EVENT_NEW_SEASON_SERVER_stamp_tour_tip_text", "EVENT_NEW_SEASON_SERVER_stamp_tour_tip_text", "None"},
        [2] = {"EVENT_NEW_SEASON_SERVER_stamp_tour_tip_text", "EVENT_NEW_SEASON_SERVER_stamp_tour_tip_text", "None"},
        [3] = {"EVENT_2007_FLEX_BOX_CHECK_TIP_TEXT_1", "EVENT_2007_FLEX_BOX_CHECK_TIP_TEXT_1", "None"},
    }

    return table[type];
end

-- pre : 이벤트 전, end : 이벤트 종료, cur : 이벤트 중
function GET_EVENT_PROGRESS_CHECK_EVENT_STATE(type)
    local table = 
    {
        [1] = {"cur", "cur", "cur", "pre", "pre"},
        [2] = {"cur", "cur", "cur", "cur", "pre"},
        [3] = {"cur", "cur", "cur", "cur", "cur"},
    }

    return table[type];
end

------------------- 획득 현황 -------------------
function GET_EVENT_PROGRESS_CHECK_ACQUIRE_STATE_ICON(type)
    local table = 
    {
        [1] = {"stamp_coin_mark", "stamp_watch_mark", "stamp_stamp_mark", "stamp_flag_mark", "stamp_roulette_mark"},
        [2] = {"stamp_coin_mark", "stamp_watch_mark", "stamp_stamp_mark", "stamp_flag_mark", "stamp_roulette_mark"},
        [3] = {"stamp_coin_mark", "stamp_watch_mark", "stamp_stamp_mark", "stamp_flag_mark", "stamp_flex_box_mark"},
    }

    return table[type];
end

function GET_EVENT_PROGRESS_CHECK_ACQUIRE_STATE_TEXT(type)
    local table = 
    {
        [1] = {ClMsg("EVENT_NEW_SEASON_SERVER_COIN_CHECK_STATE_1"), ClMsg("EVENT_NEW_SEASON_SERVER_COIN_CHECK_STATE_2"), ClMsg("EVENT_NEW_SEASON_SERVER_COIN_CHECK_STATE_3"), ClMsg("DailyContentMissionAcquireCount"), ClMsg("EVENT_NEW_SEASON_SERVER_COIN_CHECK_STATE_5")},
        [2] = {ClMsg("EVENT_NEW_SEASON_SERVER_COIN_CHECK_STATE_1"), ClMsg("EVENT_NEW_SEASON_SERVER_COIN_CHECK_STATE_2"), ClMsg("EVENT_NEW_SEASON_SERVER_COIN_CHECK_STATE_3"), ClMsg("EVENT_NEW_SEASON_SERVER_COIN_CHECK_STATE_4"), ClMsg("EVENT_NEW_SEASON_SERVER_COIN_CHECK_STATE_5")},
        [3] = {ClMsg("EVENT_2007_FLEX_BOX_CHECK_STATE_1"), ClMsg("EVENT_2007_FLEX_BOX_CHECK_STATE_2"), ClMsg("EVENT_2007_FLEX_BOX_CHECK_STATE_3"), ClMsg("EVENT_2007_FLEX_BOX_CHECK_STATE_4"), ClMsg("EVENT_2007_FLEX_BOX_CHECK_STATE_5")},
    }

    return table[type];
end

function GET_EVENT_PROGRESS_CHECK_ACQUIRE_STATE_TOOLTIP(type)
    local table = 
    {
        [1] = {ClMsg("GoddessRouletteTexttooltip_1"), ClMsg("GoddessRouletteTexttooltip_2"), ClMsg("GoddessRouletteTexttooltip_3"), ClMsg("GoddessRouletteTexttooltip_4"), ClMsg("GoddessRouletteTexttooltip_5")},
        [2] = {ClMsg("NEW_SEASON_SERVER_COIN_CHECK_TOOLTIP_1"), ClMsg("NEW_SEASON_SERVER_COIN_CHECK_TOOLTIP_2"), ClMsg("NEW_SEASON_SERVER_COIN_CHECK_TOOLTIP_3"), ClMsg("NEW_SEASON_SERVER_COIN_CHECK_TOOLTIP_4"), ClMsg("NEW_SEASON_SERVER_COIN_CHECK_TOOLTIP_5")},
        [3] = {ClMsg("EVENT_2007_FLEX_BOX_CHECK_TOOLTIP_1"), ClMsg("EVENT_2007_FLEX_BOX_CHECK_TOOLTIP_2"), ClMsg("EVENT_2007_FLEX_BOX_CHECK_TOOLTIP_3"), ClMsg("EVENT_2007_FLEX_BOX_CHECK_TOOLTIP_4"), ClMsg("EVENT_2007_FLEX_BOX_CHECK_TOOLTIP_5")},
    }

    return table[type];
end

-- maxvalue가 0이면 제한 없다는 뜻
function GET_EVENT_PROGRESS_CHECK_ACQUIRE_STATE_MAX_VALUE(type)
    local table = 
    {
        [1] = {1000, 10, 33, 10, 100},
        [2] = {600, 2, 33, 36, 60},
        [3] = {0, GET_EVENT_FLEX_BOX_DAILY_PLAY_TIME_MAX_CONSUME_COUNT(), 24, GET_EVENT_FLEX_BOX_DAILY_CONTENTS_MAX_CONSUME_COUNT(), GET_EVENT_FLEX_BOX_MAX_OPEN_COUNT()},
    }

    return table[type];
end

function GET_EVENT_PROGRESS_CHECK_ACQUIRE_STATE_NPC(type)
    -- contectmanu name(ClMsg)/mapname/x/z;
    local table = 
    {
        [1] = {"None", "None", "Klapeda/c_Klaipe/-292/291;c_orsha/c_orsha/-985/415;", "None", "None"},
        [2] = {"None", "None", "Klapeda/c_Klaipe/-292/291;c_orsha/c_orsha/-985/415;", "None", "None"},
        [3] = {"None", "None", "Klapeda/c_Klaipe/-679/581;c_fedimian/c_fedimian/-532/-180;c_orsha/c_orsha/184/246;", "None", "Klapeda/c_Klaipe/-679/581;c_fedimian/c_fedimian/-532/-180;c_orsha/c_orsha/184/246;"},
    }

    return table[type];
end

function GET_EVENT_PROGRESS_CHECK_ACQUIRE_STATE_CLEAR_TEXT(type)
    local table = 
    {
        [1] = {"None", "GoddessRouletteDailyPlayTimeClearText", "None", "GoddessRouletteDailyPlayTimeClearText", "Goddess_Roulette_Max_Rullet_count"},
        [2] = {"None", "GoddessRouletteDailyPlayTimeClearText", "None", "None", "Goddess_Roulette_Max_Rullet_count"},
        [3] = {"None", "GoddessRouletteDailyPlayTimeClearText", "None", "GoddessRouletteDailyPlayTimeClearText", "Event_Flex_box_Open_Max_Count"},
    }

    return table[type];
end

function GET_EVENT_PROGRESS_DAILY_PLAY_TIME_TYPE(type)
    -- min = 접속 시간 분 표시, count = 일일 획득 주화 표시 
    local table = 
    {
        [1] = "min",
        [2] = "min",
        [3] = "count",
    }

    return table[type];
end

------------------- 스탬프 투어 -------------------
function GET_EVENT_PROGRESS_CHECK_STAMP_GROUP(type)
    -- note_eventlist.xml Group 
    local table = 
    {
        [1] = "REGULAR_EVENT_STAMP_TOUR",
        [2] = "REGULAR_EVENT_STAMP_TOUR",
        [3] = "EVENT_STAMP_TOUR_SUMMER",
    }

    return table[type];
end

function GET_EVENT_PROGRESS_CHECK_NOTE_NAME(type)
    local table = 
    {
        [1] = "Note",
        [2] = "Note",
        [3] = "TOS_VACANCE_EVNET",
    }

    return table[type];
end

function GET_EVENT_PROGRESS_STAMP_TOUR_CLEAR_COUNT()
	local accObj = GetMyAccountObj();
	local curCount = 0;
	for i = 1, GODDESS_ROULETTE_STAMP_TOUR_MAX_COUNT do
		local propname = "None";
		if i < 10 then
			propname = "REGULAR_EVENT_STAMP_TOUR_CHECK0"..i;
		else
			propname = "REGULAR_EVENT_STAMP_TOUR_CHECK"..i;
		end

		local curvalue = TryGetProp(accObj, propname);
		
		if curvalue == "true" then
			curCount = curCount + 1;
		end
	end

	return curCount;
end

------------------- 콘텐츠 -------------------
function GET_EVENT_PROGRESS_CONTENTS_MAX_CONSUME_COUNT(type)
    -- first : 첫 클리어 시에만 보상 제공, daily: 매일 획득 가능 수량 초기화
    local table = 
    {
        [1] = "daily",
        [2] = "first",
        [3] = "daily",
    }

    return table[type];
end

function CREATE_EVENT_PROGRESS_CHECK_CONTENTS_MISSION_CLEAR_COUNT()
	local accObj = GetMyAccountObj();
	if accObj == nil then return 0;	end

	local curCount = 0;
	for i = 1, EVENT_NEW_SEASON_SERVER_CONTENT_MISSION_MAX_COUNT do
		local propname = "EVENT_NEW_SEASON_SERVER_CONTENT_FIRST_CLEAR_CHECK_"..i;
		local curvalue = TryGetProp(accObj, propname);
		
		if curvalue == 1 then
			curCount = curCount + 1;
		end
	end

	return curCount;
end