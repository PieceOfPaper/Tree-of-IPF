-- inuninfo.lua
function INDUNINFO_ON_INIT(addon, frame)
    addon:RegisterMsg('CHAT_INDUN_UI_OPEN', 'INDUNINFO_CHAT_OPEN');    
    addon:RegisterMsg('WEEKLY_BOSS_UI_UPDATE', 'WEEKLY_BOSS_UI_UPDATE');
    addon:RegisterMsg('BORUTA_RANKING_UI_UPDATE', 'BORUTA_RANKING_UI_UPDATE');
	addon:RegisterMsg("PVP_STATE_CHANGE", "INDUNINFO_TEAM_BATTLE_STATE_CHANGE");

    g_selectedIndunTable = {};
end

local NOT_SELECTED_BOX_SKIN = "chat_window_2";

g_indunCategoryList = {100, 10000, 10002, 400, 800, 500};
g_pvpIndunCategoryList = {600, 700, 900};

--[[
    프던 보스 카운트 및 챌린지 모드 정보 표시하려고 추가함
    contents_info.xml 데이터 중에서 ResetGroupID임
    indun.xml의 PlayPerResetType과 중복을 피하기 위해 음수로 추가해보았음
]] 
g_contentsCategoryList = { -100, -200 }

g_weeklyBossCategory = 804

function INDUNINFO_PUSH_BACK_TABLE(list,cateType)
    if table.find(list,cateType) == 0 then
        list[#list + 1] = cateType;
    end
end

function UI_TOGGLE_INDUN()
    if app.IsBarrackMode() == true then
        return;
    end
    ui.ToggleFrame('induninfo');
end

function INDUNINFO_CHAT_OPEN(frame, msg, argStr, argNum)
    if nil ~= frame then
        frame:ShowWindow(1);
    else
        ui.OpenFrame("induninfo");
    end
end

function INDUNINFO_UI_OPEN(frame)
    if session.GetWasBarrack() == true then
        session.barrack.RequestCharacterIndunInfo();
    end

    local now_time = geTime.GetServerSystemTime()
    local weekly_boss_endtime = session.weeklyboss.GetWeeklyBossEndTime()
    if session.weeklyboss.GetNowWeekNum() == 0 then
        weekly_boss.RequestWeeklyBossNowWeekNum();                  -- 현재 week_num 요청
    elseif imcTime.IsLaterThan(now_time,weekly_boss_endtime) ~= 0 then
        weekly_boss.RequestWeeklyBossNowWeekNum();                  -- 현재 week_num 요청
    end

    local boruta_endtime = session.boruta_ranking.GetBorutaEndTime();
    if session.boruta_ranking.GetNowWeekNum() == 0 then
        boruta.RequestBorutaNowWeekNum();
    elseif imcTime.IsLaterThan(now_time, boruta_endtime) ~= 0 then
        boruta.RequestBorutaNowWeekNum();
    end
    
    local tab = GET_CHILD_RECURSIVELY(frame, "tab");
	if tab ~= nil then
		tab:SelectTab(0);
	end
    
    INDUNINFO_RESET_USERVALUE(frame);
	INDUNINFO_CREATE_CATEGORY(frame);
	local tab = GET_CHILD(frame, "tab");
	local index = tab:GetSelectItemIndex();
	TOGGLE_INDUNINFO(frame,index)
end

function SET_WEEKLYBOSS_INDUN_COUNT(frame)
    local button = GET_CHILD_RECURSIVELY(frame,"joinenter")
    local indunCls = GetClassByNumProp("Indun","PlayPerResetType",g_weeklyBossCategory)
    local acc_obj = GetMyAccountObj()
    button:SetTextByKey('cur', acc_obj['IndunWeeklyEnteredCount_'..g_weeklyBossCategory]);
    button:SetTextByKey('max', indunCls.PlayPerReset);
end

function TOGGLE_INDUNINFO(frame,type)
	--indun
	do
		local isShow = BoolToNumber(0 == type)
		local indunbox = GET_CHILD_RECURSIVELY(frame,'indunbox')
		indunbox:ShowWindow(isShow)
		local lvAscendRadio = GET_CHILD_RECURSIVELY(frame,'lvAscendRadio')
		lvAscendRadio:ShowWindow(isShow)
		local lvDescendRadio = GET_CHILD_RECURSIVELY(frame,'lvDescendRadio')
		lvDescendRadio:ShowWindow(isShow)
		local bottomBox = GET_CHILD_RECURSIVELY(frame, 'bottomBox')
		bottomBox:ShowWindow(isShow)
	end
	--weeklyboss rank
	do
		local isShow = BoolToNumber(1 == type)
		local WeeklyBossbox = GET_CHILD_RECURSIVELY(frame, 'WeeklyBossbox')
		WeeklyBossbox:ShowWindow(isShow)
	end
	--raid rank
	do
		local isShow = BoolToNumber(2 == type)
		local raidrankingBox = GET_CHILD_RECURSIVELY(frame, 'raidrankingBox');
		raidrankingBox:ShowWindow(isShow);
	end
	--boruta rank
	do
		local isShow = BoolToNumber(3 == type)
		local boruta_box = GET_CHILD_RECURSIVELY(frame, 'boruta_box')
		boruta_box:ShowWindow(isShow)
	end
	--pvp
	do
		local isShow = BoolToNumber(4 == type)
		local pvpBox = GET_CHILD_RECURSIVELY(frame,'pvpbox')
		pvpBox:ShowWindow(isShow)
	end
	--pvp and indun common
	do
		local isShow = BoolToNumber(4 == type or 0 == type)
		local categoryBox = GET_CHILD_RECURSIVELY(frame, 'categoryBox')
		categoryBox:ShowWindow(isShow)
		local contentBox = GET_CHILD_RECURSIVELY(frame, 'contentBox')
		contentBox:ShowWindow(isShow)
	end
end

function INDUNINFO_UI_CLOSE(frame)
    INDUNMAPINFO_UI_CLOSE();
    ui.CloseFrame('induninfo');
    ui.CloseFrame('indun_char_status');
    ui.CloseFrame('weeklyboss_patterninfo');
    ui.CloseFrame('induninfo_pvpreward');
end

function INDUNINFO_ADD_COUNT(table,index)
    if table[index] == nil then
        table[index] = 1
    else
        table[index] = table[index] + 1
    end
end

function INDUNINFO_CREATE_CATEGORY(frame)
    local categoryBox = GET_CHILD_RECURSIVELY(frame, 'categoryBox');
    categoryBox:RemoveAllChild();
    local cycleCtrlPic = GET_CHILD_RECURSIVELY(frame, 'cycleCtrlPic')
    cycleCtrlPic:ShowWindow(0);
    
    local SCROLL_WIDTH = 20;
    local categoryBtnWidth = categoryBox:GetWidth() - SCROLL_WIDTH;
    local firstBtn = nil;
    resetGroupTable = {};
    local missionIndunSet = {};

    local createCategory = function(resetGroupID,cls)
        local categoryCtrl = categoryBox:GetChild('CATEGORY_CTRL_'..resetGroupID);
        if categoryCtrl ~= nil then
            return nil
        end
        local category = cls.Category;
        categoryCtrl = categoryBox:CreateOrGetControlSet('indun_cate_ctrl', 'CATEGORY_CTRL_'..resetGroupID, 0, 0);
        local name = categoryCtrl:GetChild("name");
        local btn = categoryCtrl:GetChild("button");
        local countText = categoryCtrl:GetChild('countText');

        btn:Resize(categoryBtnWidth, categoryCtrl:GetHeight());
        name:SetTextByKey("value", category);
        if resetGroupID == -101 then
            countText:SetText(ScpArgMsg('ChallengeMode_HardMode_Count', 'Count', GET_CURRENT_ENTERANCE_COUNT(resetGroupID)))
        else
            countText:SetTextByKey('current', GET_CURRENT_ENTERANCE_COUNT(resetGroupID));
            countText:SetTextByKey('max', GET_INDUN_MAX_ENTERANCE_COUNT(resetGroupID));
        end
        
        local cyclePicImg = GET_CHILD_RECURSIVELY(categoryCtrl, 'cycleCtrlPic')   --주/일 표시 이미지
        INDUNINFO_SET_CYCLE_PIC(cyclePicImg,cls,'_s')

        categoryCtrl:SetUserValue('RESET_GROUP_ID', resetGroupID);
        if firstBtn == nil then
            firstBtn = btn
        end
    end

    local indunClsList, cnt = GetClassList('Indun');
    for i = 0, cnt - 1 do
        local indunCls = GetClassByIndexFromList(indunClsList, i);
        if indunCls ~= nil and indunCls.Category ~= 'None' then            
            local resetGroupID = indunCls.PlayPerResetType;
            if indunCls.DungeonType == 'MissionIndun' then
                INDUNINFO_ADD_COUNT(missionIndunSet,resetGroupID)
            else
                INDUNINFO_ADD_COUNT(resetGroupTable,resetGroupID)
            end
            INDUNINFO_PUSH_BACK_TABLE(g_indunCategoryList,resetGroupID);
            createCategory(resetGroupID,indunCls)
        end
    end
    for key,_ in pairs(missionIndunSet) do
        INDUNINFO_ADD_COUNT(resetGroupTable,key)
    end
    -- 인던 외 컨텐츠 표시를 일단 인던과 같이 하는데, 나중에 탭 형식으로 변경 필요함
    local contentsClsList, count = GetClassList('contents_info')
    for i = 0, count - 1 do
        local contentsCls = GetClassByIndexFromList(contentsClsList, i)
        if contentsCls ~= nil and contentsCls.Category ~='None' then
            local resetGroupID = contentsCls.ResetGroupID
            INDUNINFO_ADD_COUNT(resetGroupTable,resetGroupID)
            
            INDUNINFO_PUSH_BACK_TABLE(g_contentsCategoryList,resetGroupID);
            local function contents_sort(a, b)
                return a > b
            end
            table.sort(g_contentsCategoryList, contents_sort)
            createCategory(resetGroupID,contentsCls)
        end
    end
    -- set the number of indun
    for resetGroupID, numIndun in pairs(resetGroupTable) do        
        local categoryCtrl = categoryBox:GetChild('CATEGORY_CTRL_'..resetGroupID);
        local name = categoryCtrl:GetChild('name');
        name:SetTextByKey('cnt', numIndun);
    end

    INDUNINFO_CATEGORY_ALIGN_DEFAULT(categoryBox);
    -- default select
    INDUNINFO_CATEGORY_LBTN_CLICK(firstBtn:GetParent(), firstBtn);
end

function INDUNINFO_CATEGORY_ALIGN_DEFAULT(categoryBox)
    local frame = categoryBox:GetTopParentFrame();
    local selectedGroupID = frame:GetUserIValue('SELECT');
    local y = 0;
    local spacey = -6;
    for i = 1, #g_indunCategoryList do
        local resetGroupID = g_indunCategoryList[i];
        local categoryCtrl = GET_CHILD_RECURSIVELY(categoryBox, 'CATEGORY_CTRL_'..resetGroupID);
        if categoryCtrl ~= nil then
            categoryCtrl:SetOffset(categoryCtrl:GetX(), y);            
            y = y + categoryCtrl:GetHeight() + spacey;
        end

        if resetGroupID == selectedGroupID then
            local indunListBox = GET_CHILD(categoryBox, 'INDUN_LIST_BOX');
            if indunListBox ~= nil then
                indunListBox:SetOffset(indunListBox:GetX(), y);                
                y = y + indunListBox:GetHeight() + spacey;
            end
        end
    end
    for i = 1,#g_pvpIndunCategoryList do
        local resetGroupID = g_pvpIndunCategoryList[i];
        local categoryCtrl = GET_CHILD_RECURSIVELY(categoryBox, 'CATEGORY_CTRL_'..resetGroupID);
        if categoryCtrl ~= nil then
            categoryCtrl:SetOffset(categoryCtrl:GetX(), y);            
            y = y + categoryCtrl:GetHeight() + spacey;
        end

        if resetGroupID == selectedGroupID then
            local indunListBox = GET_CHILD(categoryBox, 'INDUN_LIST_BOX');
            if indunListBox ~= nil then
                indunListBox:SetOffset(indunListBox:GetX(), y);                
                y = y + indunListBox:GetHeight() + spacey;
            end
        end
    end

    for i = 1, #g_contentsCategoryList do
        local resetGroupID = g_contentsCategoryList[i]
        local categoryCtrl = GET_CHILD_RECURSIVELY(categoryBox, 'CATEGORY_CTRL_'..resetGroupID);
        if categoryCtrl ~= nil then
            categoryCtrl:SetOffset(categoryCtrl:GetX(), y);
            y = y + categoryCtrl:GetHeight() + spacey;
        end

        if resetGroupID == selectedGroupID then
            local indunListBox = GET_CHILD(categoryBox, 'INDUN_LIST_BOX');
            if indunListBox ~= nil then
                indunListBox:SetOffset(indunListBox:GetX(), y);
                y = y + indunListBox:GetHeight() + spacey;
            end
        end
    end
end

function INDUNINFO_RESET_USERVALUE(frame)
    frame:SetUserValue('SELECT', 'None');
end

function INDUNINFO_DRAW_CATEGORY_DETAIL_LIST(indunListBox, cls, is_weekly_reset)
    local indunDetailCtrl = indunListBox:CreateOrGetControlSet('indun_detail_ctrl', 'DETAIL_CTRL_' .. cls.ClassID, 0, 0);
    indunDetailCtrl = tolua.cast(indunDetailCtrl, 'ui::CControlSet');
    indunDetailCtrl:SetUserValue('INDUN_CLASS_ID', cls.ClassID);
    indunDetailCtrl:SetEventScript(ui.LBUTTONUP, 'INDUNINFO_DETAIL_LBTN_CLICK');
    indunDetailCtrl:SetEventScriptArgString(ui.LBUTTONUP, "click");

    local infoText = indunDetailCtrl:GetChild('infoText');
    local nameText = indunDetailCtrl:GetChild('nameText');

    local onlinePic = GET_CHILD(indunDetailCtrl,'onlinePic')
    if TryGetProp(cls,"DungeonType","None") == "Ancient" then
        onlinePic:ShowWindow(1)
        local acc_obj = GetMyAccountObj()
        if TryGetProp(acc_obj,"ANCIENT_SOLO_STAGE_WEEK",0) >= GET_ANCIENT_STAGE_OF_CLASS(cls) then
            onlinePic:SetImage('guild_online')
        end
    else
        onlinePic:ShowWindow(0)
    end
    
    infoText:SetTextByKey('level', cls.Level);
    nameText:SetTextByKey('name', cls.Name);
    if #g_selectedIndunTable == 0 then -- 디폴트는 리스트의 첫번째
        indunListBox:SetUserValue('FIRST_INDUN_ID', cls.ClassID)
        INDUNINFO_DETAIL_LBTN_CLICK(indunListBox, indunDetailCtrl);
    end
    table.insert(g_selectedIndunTable,cls)
    -- 주간 입장 텍스트 설정
    local topFrame = indunListBox:GetTopParentFrame()
    local resetInfoText = GET_CHILD_RECURSIVELY(topFrame, 'resetInfoText');             --"입장 횟수는 매일 %s시에 초기화 됩니다."
    local resetInfoText_Week = GET_CHILD_RECURSIVELY(topFrame, 'resetInfoText_Week');   --"입장 횟수는 매주 월요일 %s시에 초기화 됩니다."

    local resetTime = INDUN_RESET_TIME % 12;
    local ampm = ClMsg('AM');
    if INDUN_RESET_TIME > 12 then
        ampm = ClMsg('PM');
    end
    --event 예외처리
    if TryGetProp(cls,"DungeonType","None") == "Event" then
        if cls.ResetTime > 12 then
            ampm = ClMsg('PM');
        end
        resetTime = cls.ResetTime % 12;
    end

    if TryGetProp(cls, 'DungeonType', 'None') == 'ChallengeMode_HardMode' then
        resetInfoText:ShowWindow(0)
        resetInfoText_Week:ShowWindow(0)
        return
    end
            
    if is_weekly_reset == true then
        --주간
        local resetText_wkeely = string.format('%s %s', ampm, resetTime);
        resetInfoText_Week:SetTextByKey('resetTime', resetText_wkeely);
        resetInfoText:ShowWindow(0);
        resetInfoText_Week:ShowWindow(1);
    else
        --일간
        local resetText = string.format('%s %s', ampm, resetTime);
        resetInfoText:SetTextByKey('resetTime', resetText);
        resetInfoText_Week:ShowWindow(0);
        resetInfoText:ShowWindow(1);
    end
end

function INDUNINFO_CATEGORY_LBTN_CLICK(categoryCtrl, ctrl)
    -- set button skin
    local topFrame = categoryCtrl:GetTopParentFrame();
    local preSelectType = topFrame:GetUserIValue('SELECT');
    local selectedResetGroupID = categoryCtrl:GetUserIValue('RESET_GROUP_ID');
    if preSelectType == selectedResetGroupID then
        return;
    end

    categoryCtrl = tolua.cast(categoryCtrl, 'ui::CControlSet');
    INDUNINFO_CHANGE_CATEGORY_BUTTON_SKIN(topFrame,categoryCtrl)

    -- make indunlist
    local categoryBox = GET_CHILD_RECURSIVELY(topFrame, 'categoryBox');
    local SCROLL_WIDTH = 20;
    local listBoxWidth = categoryBox:GetWidth() - SCROLL_WIDTH;

    categoryBox:RemoveChild('INDUN_LIST_BOX');
    g_selectedIndunTable = {};
    local indunListBox = INDUNINFO_RESET_INDUN_LISTBOX(categoryBox)

    if selectedResetGroupID < 0 then
        local contentsClsList, count = GetClassList('contents_info')
        for i = 0, count - 1 do
            local contentsCls = GetClassByIndexFromList(contentsClsList, i)
            if contentsCls ~= nil and contentsCls.ResetGroupID == selectedResetGroupID and contentsCls.Category ~= 'None' then
                local is_weekly_reset = BoolToNumber(contentsCls.ResetPer == 'WEEK')
                INDUNINFO_DRAW_CATEGORY_DETAIL_LIST(indunListBox, contentsCls, is_weekly_reset)
            end
        end
    else
        local indunClsList, cnt = GetClassList('Indun');    
        local missionIndunCnt = 0; -- 신규 레벨던전 7곳의 로테이션은 해당 인던의 클래스가 indun.xml에 들어 있는 순서대로 일 ~ 토로 배정됨
        for i = 0, cnt - 1 do
            local indunCls = GetClassByIndexFromList(indunClsList, i);
            local add_flag = false;
            if indunCls.PlayPerResetType == selectedResetGroupID and indunCls.Category ~= 'None' then
                local dungeonType = TryGetProp(indunCls, 'DungeonType')
                if dungeonType == 'MissionIndun' then
                    local sysTime = geTime.GetServerSystemTime();
                    -- 오늘 요일의 던전만 세부항목에 추가한다
                    if missionIndunCnt == sysTime.wDayOfWeek then
                        add_flag = true;
                    end
                    missionIndunCnt = missionIndunCnt + 1;
                else
                    add_flag = true;
                end
            end
            if add_flag == true then
				local is_weekly_reset = (indunCls.WeeklyEnterableCount ~= nil and indunCls.WeeklyEnterableCount > 0)
				if indunCls.DungeonType == "Solo_dungeon" then
					is_weekly_reset = true
				end
                INDUNINFO_DRAW_CATEGORY_DETAIL_LIST(indunListBox, indunCls, is_weekly_reset)
            end
        end
    end
    GBOX_AUTO_ALIGN(indunListBox, 0, 2, 0, true, true);

    -- category box align
    INDUNINFO_CATEGORY_ALIGN_DEFAULT(categoryBox);
    INDUNINFO_SORT_BY_LEVEL(topFrame);
end
    
function GET_CURRENT_ENTERANCE_COUNT(resetGroupID)
    local etc = GetMyEtcObject();
    local acc_obj = GetMyAccountObj()
    if etc == nil or acc_obj == nil then
        return 0;
    end

    if resetGroupID < 0 then
        local contentsClsList, count = GetClassList('contents_info')
        local contentsCls = nil
        for i = 0, count - 1 do
            contentsCls = GetClassByIndexFromList(contentsClsList, i)
            if contentsCls ~= nil and contentsCls.ResetGroupID == resetGroupID and contentsCls.Category ~= 'None' then
                break
            end
        end

        if contentsCls.UnitPerReset == 'PC' then
            return etc[contentsCls.ResetType]
        else
            return acc_obj[contentsCls.ResetType]
        end
    end
    
    local indunClsList, cnt = GetClassList('Indun');
    local indunCls = nil;
    for i = 0, cnt - 1 do
        indunCls = GetClassByIndexFromList(indunClsList, i);
        if indunCls ~= nil and indunCls.PlayPerResetType == resetGroupID and indunCls.Category ~= 'None' then
            break;
        end
    end
    if indunCls.WeeklyEnterableCount ~= nil and indunCls.WeeklyEnterableCount ~= "None" and indunCls.WeeklyEnterableCount ~= 0 then
        if indunCls.UnitPerReset == 'PC' then
            return(etc['IndunWeeklyEnteredCount_'..resetGroupID])   --매주 남은 횟수
        else     
            return(acc_obj['IndunWeeklyEnteredCount_'..resetGroupID])   --매주 남은 횟수
        end        
    else
        if indunCls.UnitPerReset == 'PC' then
            return etc['InDunCountType_'..resetGroupID];            --매일 남은 횟수
        else
            return acc_obj['InDunCountType_'..resetGroupID];            --매일 남은 횟수
        end
    end
end

function GET_INDUN_MAX_ENTERANCE_COUNT(resetGroupID)
    local etc = GetMyEtcObject();
    if etc == nil then
        return 0;
    end

    if resetGroupID < 0 then
        local contentsClsList, count = GetClassList('contents_info')
        local contentsCls = nil
        for i = 0, count - 1 do
            contentsCls = GetClassByIndexFromList(contentsClsList, i)
            if contentsCls ~= nil and contentsCls.ResetGroupID == resetGroupID and contentsCls.Category ~= 'None' then
                break
            end
        end
        local ret = contentsCls.EnterableCount
        if ret == 0 then
            ret = "{img infinity_text 20 10}"
        end
        return ret
    else
        local indunClsList, cnt = GetClassList('Indun');
        local indunCls = nil;
        for i = 0, cnt - 1 do
            indunCls = GetClassByIndexFromList(indunClsList, i);
            if indunCls ~= nil and indunCls.PlayPerResetType == resetGroupID and indunCls.Category ~= 'None' then
                break;
            end
        end
        
        local infinity = TryGetProp(indunCls, 'EnableInfiniteEnter', 'NO')
        if indunCls.AdmissionItemName ~= "None" or infinity == 'YES' then
            local a = "{img infinity_text 20 10}"
            if indunCls.DungeonType == "Raid" or indunCls.DungeonType == "GTower" then
                if indunCls.WeeklyEnterableCount > TryGetProp(etc, "IndunWeeklyEnteredCount_"..tostring(TryGetProp(indunCls, "PlayPerResetType"))) then
                    return indunCls.WeeklyEnterableCount;
                end
            end
            
            return a;
        end
        
        if indunCls.WeeklyEnterableCount ~= nil and indunCls.WeeklyEnterableCount ~= "None" and indunCls.WeeklyEnterableCount ~= 0 then
            return indunCls.WeeklyEnterableCount;  --매주 max
        else
            return indunCls.PlayPerReset;          --매일 max
        end
    end
end

function INDUNINFO_SET_CYCLE_PIC(ctrl,cls,postFix)
    local imageName = GET_RESET_CYCLE_PIC_TYPE(cls,postFix)
    if imageName == 'None' then
        ctrl:ShowWindow(0);
        return
    end
    ctrl:SetImage(GET_INDUN_ICON_NAME(imageName,postFix))
    if imageName == 'event' then
        local margin = ctrl:GetOriginalMargin();
        ctrl:SetMargin(margin.left, margin.top, margin.right - 6, margin.bottom);
        ctrl:Resize(ctrl:GetOriginalWidth() + 11, ctrl:GetOriginalHeight());
    end
    ctrl:ShowWindow(1)
end

function GET_RESET_CYCLE_PIC_TYPE(cls,postFix)
    local idSpace = GetIDSpace(cls)
    local cyclePicType = 'None';  --week, day, event, None
    if idSpace == 'contents_info' then
        local contentsCls = cls
        if contentsCls.ResetPer == 'WEEK' then
            cyclePicType = 'week'
        elseif contentsCls.ResetPer == 'DAY' then
            cyclePicType = 'day'
        else
            cyclePicType = 'None'
        end
    elseif idSpace == "Indun" then
        local indunCls = cls

        local etc = nil
        do
            if indunCls.UnitPerReset == 'ACCOUNT' then
                etc = GetMyAccountObj()
            else
                etc = GetMyEtcObject();
            end
            if etc == nil then
                return 0;
            end
        end
        
        local enterableCount = tonumber(indunCls.WeeklyEnterableCount)
        if INDUNINFO_IS_EVENT_CATEGORY(indunCls) then
            cyclePicType = 'event'
        elseif  enterableCount ~= nil and enterableCount > 0 then
			cyclePicType = 'week';
		elseif indunCls.DungeonType == "Solo_dungeon" then
			cyclePicType = 'week';
        else
            cyclePicType = 'day';
        end
        local dungeonType = TryGetProp(indunCls, "DungeonType");
        if dungeonType == 'MissionIndun' then
            local sysTime = geTime.GetServerSystemTime();
            local dayOfWeekStr = string.lower(GET_DAYOFWEEK_STR(sysTime.wDayOfWeek));
            cyclePicType = dayOfWeekStr
        elseif dungeonType == "UniqueRaid" then
            cyclePicType = 'None'
        end
    elseif idSpace == 'PVPIndun' then
        local indunCls = cls
        cyclePicType = indunCls.Day
    end
    
    return cyclePicType;
end

function INDUNINFO_IS_EVENT_CATEGORY(indunCls)
    if indunCls.DungeonType == 'UniqueRaid' then
        local pc = GetMyPCObject()
        if IsBuffApplied(pc, "Event_Unique_Raid_Bonus") == "YES" then
            return true
        elseif IsBuffApplied(pc, "Event_Unique_Raid_Bonus_Limit") == "YES" then
            local accountObject = GetMyAccountObj(pc)
            if TryGetProp(accountObject ,"EVENT_UNIQUE_RAID_BONUS_LIMIT") > 0 then
                return true
            end
        end
    elseif indunCls.DungeonType == "Event" then
        return true
    end
    return false
end

function GET_INDUN_ICON_NAME(name,postFix)
    if ui.IsImageExist(name) == false then
        name = 'indun_icon_'..name
        if ui.IsImageExist(name) == false and postFix ~= nil then
            name = name .. postFix
        end
    end
    if config.GetServiceNation() ~= 'KOR' then
        name = name..'_eng'
    end
    return name
end

function INDUNINFO_DETAIL_LBTN_CLICK(parent, detailCtrl, clicked)
    local indunClassID = detailCtrl:GetUserIValue('INDUN_CLASS_ID');
    local preSelectedDetail = parent:GetUserIValue('SELECTED_DETAIL');
    if indunClassID == preSelectedDetail then
        return;
    end

    if clicked == "click" then
        imcSound.PlaySoundEvent("button_click_7");        
    end
    
    -- set skin
    local SELECTED_BOX_SKIN = detailCtrl:GetUserConfig('SELECTED_BOX_SKIN');
    local preSelectedCtrl = parent:GetChild('DETAIL_CTRL_'..preSelectedDetail);
    if preSelectedCtrl ~= nil then
        local index = 0
        for i = 1,#g_selectedIndunTable do
            if g_selectedIndunTable[i].ClassID == preSelectedDetail then
                index = i
                break
            end
        end
        INDUNINFO_DETAIL_SET_SKIN(preSelectedCtrl,index)
    end
    local skinBox = GET_CHILD(detailCtrl, 'skinBox');
    skinBox:SetSkinName(SELECTED_BOX_SKIN);
    parent:SetUserValue('SELECTED_DETAIL', indunClassID);
    
    local topFrame = parent:GetTopParentFrame();
    local tab = GET_CHILD_RECURSIVELY(topFrame,"tab")
    local index = tab:GetSelectItemIndex();

    -- 인스턴스 던전 정보 처리를 위한 임시 처리 시작 --
    -- INDUNINFO_DROPBOX_ITEM_LIST 에서 parent의 SELECTED_DETAIL 값을 불러올 수 있도록 같은 프레임을 호출하도록 변경해야 함 --
    local categoryBox = GET_CHILD_RECURSIVELY(topFrame,'categoryBox')
    local indunListBox = GET_CHILD_RECURSIVELY(categoryBox, 'INDUN_LIST_BOX');
    indunListBox:SetUserValue('SELECTED_DETAIL', indunClassID);
    -- 인스턴스 던전 정보 처리를 위한 임시 처리 끝 --
    local resetGroupID = topFrame:GetUserIValue('SELECT')
    if index ~= 0 then
        PVP_INDUNINFO_MAKE_DETAIL_INFO_BOX(topFrame, indunClassID);
    elseif resetGroupID < 0 then
        INDUNINFO_MAKE_DETAIL_INFO_BOX_OTHER(topFrame, indunClassID)
    elseif indunClassID > 0 then
        INDUNINFO_MAKE_DETAIL_INFO_BOX(topFrame, indunClassID);
    end
end

-- induninfo와 indunenter에서 보상 드랍박스 만드는 데 완전 동일한 로직 사용중이고 또 너무 길어보여서 리스트에 아이템 채우는 부분만 분리했음
function CHECK_AND_FILL_REWARD_DROPBOX(list, itemName)
    local item = GetClass('Item', itemName);
    if item ~= nil then   -- 있다면 아이템 --
        local itemType = TryGetProp(item, 'GroupName');
        local itemClassType = TryGetProp(item, 'ClassType');
        if itemType == 'Recipe' then
            local recipeItemCls = GetClass('Recipe', item.ClassName);
            local targetItem = TryGetProp(recipeItemCls, 'TargetItem');
            if targetItem ~= nil then
                local targetItemCls = GetClass('Item', targetItem);
                if targetItemCls ~= nil then
                    itemType = TryGetProp(targetItemCls, 'GroupName');
                    itemClassType = TryGetProp(targetItemCls, 'ClassType');
                end
            end
        end
        if itemType ~= nil then
            if itemType == 'Weapon' then
                if IS_EXIST_CLASSNAME_IN_LIST(list['weaponBtn'],item.ClassName) == false and IS_EXIST_CLASSNAME_IN_LIST(list['subweaponBtn'],item.ClassName) == false then
                    list['weaponBtn'][#list['weaponBtn'] + 1] = item;
                end
            elseif itemType == 'SubWeapon' then
                if itemClassType == 'Armband' then
                    if IS_EXIST_CLASSNAME_IN_LIST(list['accBtn'],item.ClassName) == false then
                        list['accBtn'][#list['accBtn'] + 1] = item;
                    end
                else 
                    if IS_EXIST_CLASSNAME_IN_LIST(list['subweaponBtn'],item.ClassName) == false then
                        list['subweaponBtn'][#list['subweaponBtn'] + 1] = item;
                    end
                end
            elseif itemType == 'Armor' then
                if itemClassType == 'Neck' or itemClassType == 'Ring' then
                    if IS_EXIST_CLASSNAME_IN_LIST(list['accBtn'],item.ClassName) == false then
                        list['accBtn'][#list['accBtn'] + 1] = item;
                    end
                elseif itemClassType == 'Shield' then
                    if IS_EXIST_CLASSNAME_IN_LIST(list['subweaponBtn'],item.ClassName) == false then
                        list['subweaponBtn'][#list['subweaponBtn'] + 1] = item;
                    end
                else
                    if IS_EXIST_CLASSNAME_IN_LIST(list['armourBtn'],item.ClassName) == false then
                        list['armourBtn'][#list['armourBtn'] + 1] = item;
                    end
                end
            else
                if IS_EXIST_CLASSNAME_IN_LIST(list['materialBtn'],item.ClassName) == false then
                    list['materialBtn'][#list['materialBtn'] + 1] = item;
                end
            end
        end
    end
end

function INDUNINFO_DROPBOX_ITEM_LIST(parent, control)
    local topFrame = parent:GetTopParentFrame();
    local selectType = topFrame:GetUserIValue('SELECT');
    local categoryBox = GET_CHILD_RECURSIVELY(topFrame,'categoryBox')
    local indunListBox = GET_CHILD_RECURSIVELY(categoryBox, 'INDUN_LIST_BOX');
    local indunClassID = indunListBox:GetUserIValue('SELECTED_DETAIL');
    local preSelectedCtrl = indunListBox:GetChild('DETAIL_CTRL_'..indunClassID);
    
    local controlName = control:GetName();
    -- 여기서 부터
    local indunCls = nil
    local dungeonType = nil
    local indunRewardItem = nil
    local groupList = nil
    if selectType < 0 then
        indunCls = GetClassByType('contents_info', indunClassID)
        indunRewardItem = TryGetProp(indunCls, 'RewardItem')
    else
        indunCls = GetClassByType('Indun', indunClassID);
        dungeonType = TryGetProp(indunCls, 'DungeonType')
        indunRewardItem = TryGetProp(indunCls, 'Reward_Item')
    end
    
    if indunRewardItem ~= nil and indunRewardItem ~= 'None' then
        groupList = SCR_STRING_CUT(indunRewardItem, '/')
    end
    
    local indunRewardItemList = { };
    indunRewardItemList['weaponBtn'] = { };
    indunRewardItemList['subweaponBtn'] = { };
    indunRewardItemList['armourBtn'] = { };
    indunRewardItemList['accBtn'] = { };
    indunRewardItemList['materialBtn'] = { };
    
    local allIndunRewardItemList, allIndunRewardItemCount = GetClassList('reward_indun');
    
    if groupList ~= nil then
        for i = 1, #groupList do
            -- 신규 레벨던전의 경우 'ClassName;1'의 형식으로 보상 이름이 들어가있을 수 있어서 ';'으로 파싱 한번 더해줌
            local strList = SCR_STRING_CUT(groupList[i], ';')
            local itemName = strList[1]
            local itemCls = GetClass('Item', itemName)
            local itemGroupName = TryGetProp(itemCls, 'GroupName')
            if itemGroupName == 'Cube' then
                -- 큐브 재개봉 시스템 개편에 따른 변경사항으로 보상 아이템 목록 보여주는 부분 큐브 대신 구성품으로 풀어서 보여주도록 변경함
                local itemStringArg = TryGetProp(itemCls, 'StringArg')
                for j = 0, allIndunRewardItemCount - 1  do
                    local indunRewardItemClass = GetClassByIndexFromList(allIndunRewardItemList, j);
                    if indunRewardItemClass ~= nil and TryGetProp(indunRewardItemClass, 'Group') == itemStringArg then
                        CHECK_AND_FILL_REWARD_DROPBOX(indunRewardItemList, indunRewardItemClass.ItemName)
                    end
                end
            else
                CHECK_AND_FILL_REWARD_DROPBOX(indunRewardItemList, itemName)
            end
        end
    end

    if #indunRewardItemList[controlName] == 0 then
        local dropListFrame = ui.MakeDropListFrame(control, 0, 0, 300, 600, 1, ui.LEFT, "INDUNINFO_DROPBOX_AFTER_BTN_DOWN",nil,nil);
        ui.AddDropListItem(ClMsg('IndunRewardItem_Empty'))
        return;
    elseif #indunRewardItemList[controlName] ~= 0 and #indunRewardItemList[controlName] < 10 then
        local dropListSize = #indunRewardItemList[controlName] * 1
        local dropListFrame = ui.MakeDropListFrame(control, 0, 0, 300, 600, dropListSize, ui.LEFT, "GET_INDUNINFO_DROPBOX_LIST_TOOLTIP_VIEW","GET_INDUNINFO_DROPBOX_LIST_MOUSE_OVER","GET_INDUNINFO_DROPBOX_LIST_MOUSE_OUT");
    else
        local dropListFrame = ui.MakeDropListFrame(control, 0, 0, 300, 600, 10, ui.LEFT, "GET_INDUNINFO_DROPBOX_LIST_TOOLTIP_VIEW","GET_INDUNINFO_DROPBOX_LIST_MOUSE_OVER","GET_INDUNINFO_DROPBOX_LIST_MOUSE_OUT");
    end
    
    if #indunRewardItemList[controlName] >= 1 then
        for l = 1, #indunRewardItemList[controlName] do
            local dropBoxItem = indunRewardItemList[controlName][l];
            ui.AddDropListItem(dropBoxItem.Name, nil, dropBoxItem.ClassName)
        end
    end
    
    local itemFrame = ui.GetFrame("wholeitem_link");
    if itemFrame == nil then
        itemFrame = ui.GetNewToolTip("wholeitem_link", "wholeitem_link");
    end
    itemFrame:SetUserValue('MouseClickedCheck','NO')
    -- 여기까지
end

function INDUNINFO_MAKE_DROPBOX(parent, control)
    local frame = ui.GetFrame('induninfo');
    local rewardBox = GET_CHILD_RECURSIVELY(frame, 'rewardBox');
    local controlName = control:GetName();

    local btnList, imgList = GET_INDUNINFO_MAKE_DROPBOX_BTN_LIST();
    for i = 1, #btnList do
        local btnName = btnList[i];
        local imgName = imgList[i];
        
        if controlName == btnName then
            if control:GetUserValue(btnName) == 'NO' then
                control:SetImage(imgName .. '_clicked');
                control:SetUserValue(btnName, 'YES');
            else
                control:SetImage(imgName);
                control:SetUserValue(btnName, 'NO');
            end
        else
            local btn = GET_CHILD_RECURSIVELY(rewardBox, btnName);
            btn:SetImage(imgName);
            btn:SetUserValue(btnName, 'NO');
        end
        if control:GetUserValue(btnName) == 'NO' then
            return ;
        end
    end
    INDUNINFO_DROPBOX_ITEM_LIST(parent, control)
end

function GET_INDUNINFO_MAKE_DROPBOX_BTN_LIST()
    local btnList = {
                        'weaponBtn',
                        'subweaponBtn',
                        'armourBtn',
                        'accBtn',
                        'materialBtn'
                    };
    
    local imgList = {
                        'indun_weapon',
                        'indun_shield',
                        'indun_armour',
                        'indun_acc',
                        'indun_material'
                    };
    
    return btnList, imgList;
end

function INDUNINFO_DROPBOX_AFTER_BTN_DOWN(index, classname)
    local frame = ui.GetFrame('induninfo');
    local rewardBox = GET_CHILD_RECURSIVELY(frame, 'rewardBox');
    local weaponBtn = GET_CHILD_RECURSIVELY(rewardBox, 'weaponBtn');
    local materialBtn = GET_CHILD_RECURSIVELY(rewardBox, 'materialBtn');
    local accBtn = GET_CHILD_RECURSIVELY(rewardBox, 'accBtn');
    local armourBtn = GET_CHILD_RECURSIVELY(rewardBox, 'armourBtn');
    local subweaponBtn = GET_CHILD_RECURSIVELY(rewardBox, 'subweaponBtn');
    
    weaponBtn:SetImage("indun_weapon")
    frame:SetUserValue('weaponBtn','NO')
    materialBtn:SetImage("indun_material") 
    frame:SetUserValue('materialBtn','NO')
    accBtn:SetImage("indun_acc")
    frame:SetUserValue('accBtn','NO')
    armourBtn:SetImage("indun_armour")
    frame:SetUserValue('armourBtn','NO')
    subweaponBtn:SetImage("indun_shield")
    frame:SetUserValue('subweaponBtn','NO')
end

function GET_INDUNINFO_DROPBOX_LIST_MOUSE_OVER(index, classname)
    local induninfoFrame = ui.GetFrame("induninfo")
    local itemFrame = ui.GetFrame("wholeitem_link");
    if itemFrame == nil then
        itemFrame = ui.GetNewToolTip("wholeitem_link", "wholeitem_link");
    end
    tolua.cast(itemFrame, 'ui::CTooltipFrame');

    local newobj = CreateIES('Item', classname);
    itemFrame:SetTooltipType('wholeitem');
    newobj = tolua.cast(newobj, 'imcIES::IObject');
    itemFrame:SetToolTipObject(newobj);

    currentFrame = itemFrame;
    currentFrame:RefreshTooltip();
    currentFrame:ShowWindow(1);
    currentFrame:SetLayerLevel(102);

    if induninfoFrame ~= nil then
        itemFrame:SetOffset(induninfoFrame:GetX()+1090,induninfoFrame:GetY())
    end
    INDUNINFO_DROPBOX_AFTER_BTN_DOWN(index, classname)
end

function GET_INDUNINFO_DROPBOX_LIST_TOOLTIP_VIEW(index, classname)
    local induninfoFrame = ui.GetFrame("induninfo")
    local itemFrame = ui.GetFrame("wholeitem_link");
    if itemFrame == nil then
        itemFrame = ui.GetNewToolTip("wholeitem_link", "wholeitem_link");
    end
    tolua.cast(itemFrame, 'ui::CTooltipFrame');

    local newobj = CreateIES('Item', classname);
    itemFrame:SetTooltipType('wholeitem');
    newobj = tolua.cast(newobj, 'imcIES::IObject');
    itemFrame:SetToolTipObject(newobj);

    currentFrame = itemFrame;
    currentFrame:RefreshTooltip();
    currentFrame:ShowWindow(1);
    
    if induninfoFrame ~= nil then
        itemFrame:SetOffset(induninfoFrame:GetX()+1090,induninfoFrame:GetY())
    end
    INDUNINFO_DROPBOX_AFTER_BTN_DOWN(index, classname)
    itemFrame:SetUserValue('MouseClickedCheck','YES')
    
end

function GET_INDUNINFO_DROPBOX_LIST_MOUSE_OUT()
    local induninfoframe = ui.GetFrame('induninfo');
    local itemFrame = ui.GetFrame("wholeitem_link");
    if itemFrame == nil then
        itemFrame = ui.GetNewToolTip("wholeitem_link", "wholeitem_link");
    end
    if itemFrame:GetUserValue('MouseClickedCheck') == 'NO' then
        itemFrame:ShowWindow(0)
    end
    if  itemFrame:GetUserValue('MouseClickedCheck') == 'YES' then
        itemFrame:ShowWindow(1)
        itemFrame:SetUserValue('MouseClickedCheck','NO')
    end
end

function INDUNINFO_MAKE_DETAIL_INFO_BOX(frame, indunClassID)
    local indunCls = GetClassByType('Indun', indunClassID);
    if indunCls == nil then
        return;
    end
    local resetGroupID = indunCls.PlayPerResetType;

    INDUNINFO_MAKE_DETAIL_COMMON_INFO(frame,indunCls,resetGroupID)

    INDUNINFO_SET_ENTERANCE_COUNT(frame,resetGroupID)
    INDUNINFO_SET_RESTRICT_SKILL(frame,indunCls)
    INDUNINFO_SET_ADMISSION_ITEM(frame,indunCls)
    INDUNENTER_MAKE_MONLIST(frame, indunCls);
end

function INDUNINFO_MAKE_DETAIL_INFO_BOX_OTHER(frame, indunClassID)
    local contentsCls = GetClassByType('contents_info', indunClassID)
    if contentsCls == nil then
        return;
    end
    local resetGroupID = contentsCls.ResetGroupID

    INDUNINFO_MAKE_DETAIL_COMMON_INFO(frame,contentsCls,resetGroupID)
    
    INDUNINFO_SET_ENTERANCE_COUNT(frame,resetGroupID)
    INDUNINFO_SET_RESTRICT_SKILL(frame,contentsCls)
    INDUNINFO_SET_ADMISSION_ITEM(frame,contentsCls)
    INDUNENTER_MAKE_MONLIST(frame, contentsCls);
end

function PVP_INDUNINFO_MAKE_DETAIL_INFO_BOX(frame, indunClassID)
    local indunCls = GetClassByType('PVPIndun', indunClassID);
    if indunCls == nil then
        return;
    end

    local resetGroupID = indunCls.GroupID;       
    INDUNINFO_MAKE_DETAIL_COMMON_INFO(frame,indunCls,resetGroupID)

    INDUNINFO_SET_ENTERANCE_TIME(frame,indunCls)
    --pvp info
    local pvpInfoSet = GET_CHILD_RECURSIVELY(frame, 'pvpInfoBox');
    pvpInfoSet:ShowWindow(0)
    if TryGetProp(indunCls,'WorldPVPType',0) ~= 0 then
        local pvpCls = GetClassByType('WorldPVPType',indunCls.WorldPVPType)
        INDUNINVO_SET_PVP_RESULT(frame,pvpCls)
    end

    frame:SetUserValue("INDUN_NAME",indunCls.ClassName)
end

---------------start draw indun tab detail ui---------------------
function INDUNINVO_SET_PVP_RESULT(frame,pvpCls)
	local pvpObj = GET_PVP_OBJECT_FOR_TYPE(pvpCls)
	local pvpInfoSet = GET_CHILD_RECURSIVELY(frame, 'pvpInfoBox');
	if pvpObj ~= nil then
		local pvpInfo = GET_CHILD(pvpInfoSet,'pvpInfoValue')
		local pvpScore = GET_CHILD(pvpInfoSet,'pvpScoreValue')

		local win = pvpObj:GetPropValue(pvpCls.ClassName..'_WIN', 0);
		pvpInfo:SetTextByKey('win',win)
		
		local lose = pvpObj:GetPropValue(pvpCls.ClassName..'_LOSE', 0);
		pvpInfo:SetTextByKey('lose',lose)
		
		local propValue = win+lose
		pvpInfo:SetTextByKey('total',propValue)
		
		propValue = pvpObj:GetPropValue(pvpCls.ClassName .. "_RP", 0);
		pvpScore:SetTextByKey('score',propValue)
	end
	pvpInfoSet:ShowWindow(1)
end

function INDUNINFO_MAKE_DETAIL_COMMON_INFO(frame,indunCls,resetGroupID)
    -- name
    local nameBox = GET_CHILD_RECURSIVELY(frame, 'nameBox');
    local nameText = nameBox:GetChild('nameText');    
    nameText:SetTextByKey('name', indunCls.Name);
    
    -- picture
    local indunPic = GET_CHILD_RECURSIVELY(frame, 'indunPic');
    indunPic:SetImage(indunCls.MapImage);

    -- level
    local lvData = GET_CHILD_RECURSIVELY(frame, 'lvData');
    lvData:SetText(indunCls.Level);

    local posBox = GET_CHILD_RECURSIVELY(frame, 'posBox');
    DESTROY_CHILD_BYNAME(posBox, 'MAP_CTRL_');
    local mapList = StringSplit(TryGetProp(indunCls,"StartMap",""), '/');
    -- 챌린지 분열 특이점 모드 예외처리
    if resetGroupID == -101 then
        local sysTime = geTime.GetServerSystemTime();
        -- 오늘 요일의 맵만 표시
        local curMapName = mapList[sysTime.wDayOfWeek + 1]
        mapList = { curMapName }
    end
    for i = 1, #mapList do
        local mapCls = GetClass('Map', mapList[i]);        
        if mapCls ~= nil then
            local mapCtrlSet = posBox:CreateOrGetControlSet('indun_pos_ctrl', 'MAP_CTRL_'..mapCls.ClassID, 0, 0);            
            local mapNameText = mapCtrlSet:GetChild('mapNameText');
            mapCtrlSet:SetGravity(ui.RIGHT, ui.TOP);
            mapCtrlSet:SetOffset(0, 10 + (10 + mapCtrlSet:GetHeight()) * (i-1));
            mapCtrlSet:SetUserValue('INDUN_CLASS_ID', indunClassID);
            mapCtrlSet:SetUserValue('INDUN_START_MAP_ID', mapCls.ClassID);
            mapNameText:SetText(mapCls.Name);
        end
    end
    INDUNINFO_SET_BUTTONS(frame,indunCls)
end

function INDUNINFO_SET_ENTERANCE_TIME(frame,indunCls)
    local pvpbox = GET_CHILD_RECURSIVELY(frame, 'pvpbox');
    --time
    local timeData = GET_CHILD_RECURSIVELY(pvpbox,'timeData')
    local startTime = string.format("%02d:%02d",TryGetProp(indunCls,"StartHour",0),TryGetProp(indunCls,"StartMin",0))
    local endTime = string.format("%02d:%02d",TryGetProp(indunCls,"EndHour",0),TryGetProp(indunCls,"EndMin",0))
    timeData:SetTextByKey('start', startTime);
    timeData:SetTextByKey('end', endTime);

    local dayPic = GET_CHILD_RECURSIVELY(frame,'dayPic')
    dayPic:ShowWindow(1)
    INDUNINFO_SET_CYCLE_PIC(dayPic,indunCls,'_l')
end

function INDUNINFO_SET_ENTERANCE_COUNT(frame,resetGroupID)
    --todo
    local countData = GET_CHILD_RECURSIVELY(frame, 'countData');
    local countData2 = GET_CHILD_RECURSIVELY(frame, 'countData2');
    if resetGroupID == -101 then
        countData2:SetTextByKey('now', GET_CURRENT_ENTERANCE_COUNT(resetGroupID))
        countData:ShowWindow(0)
        countData2:ShowWindow(1)
    else
        countData:SetTextByKey('now', GET_CURRENT_ENTERANCE_COUNT(resetGroupID));
        countData:SetTextByKey('max', GET_INDUN_MAX_ENTERANCE_COUNT(resetGroupID));
        countData2:ShowWindow(0)
        countData:ShowWindow(1)
    end
    INDUNENTER_MAKE_MONLIST(frame, indunCls);
end

function INDUNINFO_SET_RESTRICT_SKILL(frame,indunCls)
    -- skill restriction
    local restrictBox = GET_CHILD_RECURSIVELY(frame, 'restrictBox');
    restrictBox:ShowWindow(0);

    local mapName = TryGetProp(indunCls, "MapName");
    local dungeonType = TryGetProp(indunCls, "DungeonType");
    local isLegendRaid = BoolToNumber(dungeonType == "Raid" or dungeonType == "GTower");

    if mapName ~= nil and mapName ~= "None" then
        local indunMap = GetClass("Map", mapName);
        local mapKeyword = TryGetProp(indunMap, "Keyword");
        if string.find(mapKeyword, "IsRaidField") ~= nil then
            restrictBox:ShowWindow(1);
            restrictBox:SetTooltipOverlap(1);
            local TOOLTIP_POSX = frame:GetUserConfig("TOOLTIP_POSX");
            local TOOLTIP_POSY = frame:GetUserConfig("TOOLTIP_POSY");
            restrictBox:SetPosTooltip(TOOLTIP_POSX, TOOLTIP_POSY);
            restrictBox:SetTooltipType("skillRestrictList");
            restrictBox:SetTooltipArg("IsRaidField", isLegendRaid);
        end
    end
end

function INDUNINFO_SET_BUTTONS(frame,indunCls)
    local buttonBox = GET_CHILD_RECURSIVELY(frame, 'buttonBox');
    local btnInfoCls = GetClass("IndunInfoButton",indunCls.DungeonType)
    if btnInfoCls == nil then
        local redButton = GET_CHILD_RECURSIVELY(buttonBox,'RedButton')
        redButton:ShowWindow(0)
        for i = 1,3 do
            local button = GET_CHILD_RECURSIVELY(buttonBox,'Button'..i)
            button:ShowWindow(0)
        end
        INDUNINFO_RESIZE_BY_BUTTONS(frame,0)
        return;
    end
    local type = 0
    local redButtonScp = TryGetProp(btnInfoCls,"RedButtonScp")
    local redButton = GET_CHILD_RECURSIVELY(buttonBox,'RedButton')
    if redButtonScp ~= 'None' then
        redButton:SetEventScript(ui.LBUTTONUP,redButtonScp)
        redButton:SetTextByKey("btnText",btnInfoCls.RedButtonText)
		redButton:SetUserValue('MOVE_INDUN_CLASSID', indunCls.ClassID);
		redButton:ShowWindow(1)
		redButton:SetEnable(1)
        type = 1
    else
        redButton:ShowWindow(0)
    end
    for i = 1,3 do
        local button = GET_CHILD_RECURSIVELY(buttonBox,'Button'..i)
        local buttonScp = TryGetProp(btnInfoCls,"Button"..i.."Scp")
        if buttonScp ~= 'None' then
            local text = TryGetProp(btnInfoCls,"Button"..i.."Text","None")
            button:SetEventScript(ui.LBUTTONUP,buttonScp)
			button:SetTextByKey("btnText",text)
			button:SetEventScriptArgString(ui.LBUTTONUP,indunCls.ClassName)
            button:ShowWindow(1)
            type = math.max(BoolToNumber(i<=2)+1,type)
        else
            button:ShowWindow(0)
        end
    end
    -- if config.GetServiceNation() == 'GLOBAL' then
    --     moveBtn:SetTextByKey('btnText', 'Warp')
    -- end
	INDUNINFO_RESIZE_BY_BUTTONS(frame,type)
	if indunCls.ClassName == "Indun_teamBattle" then
		INDUNINFO_TEAM_BATTLE_STATE_CHANGE(frame,redButton,argStr,argNum)
	end
end

function INDUNINFO_SET_ADMISSION_ITEM(frame,indunCls)
    -- count
    local countItemData = GET_CHILD_RECURSIVELY(frame, 'countItemData');
    local countBox = GET_CHILD_RECURSIVELY(frame, 'countBox');
    local countText = GET_CHILD_RECURSIVELY(countBox, 'countText');
    local cycleCtrlPic = GET_CHILD_RECURSIVELY(countBox, 'cycleCtrlPic');
    local countData = GET_CHILD_RECURSIVELY(frame, 'countData');
    local countData2 = GET_CHILD_RECURSIVELY(frame, 'countData2');
    local cycleImage = GET_CHILD_RECURSIVELY(frame, 'cyclePic');
    local nowAdmissionItemCount = GET_INDUN_ADMISSION_ITEM_COUNT(indunCls)
    if nowAdmissionItemCount <= 0 then
        countText:SetText(ScpArgMsg("IndunAdmissionItemReset"))
        if indunCls.DungeonType == 'ChallengeMode_HardMode' then
            countData:ShowWindow(0);
            countData2:ShowWindow(1);
        else
            countData2:ShowWindow(0);
            countData:ShowWindow(1);
        end
        countItemData:ShowWindow(0);
        INDUNINFO_SET_CYCLE_PIC(cycleImage,indunCls,'_l')
        cycleCtrlPic:ShowWindow(0)
    else
        countText:SetText(ScpArgMsg("IndunAdmissionItem"))
        countData:ShowWindow(0);
        countItemData:ShowWindow(1);
        INDUNINFO_SET_CYCLE_PIC(cycleCtrlPic,indunCls,'_l')
        cycleImage:ShowWindow(0)

        local admissionItemName = TryGetProp(indunCls, "AdmissionItemName");
        local admissionItemCls = GetClass('Item', admissionItemName);
        local admissionItemIcon = TryGetProp(admissionItemCls, "Icon");
        countItemData:SetTextByKey('admissionitem', '  {img '..admissionItemIcon..' 30 30}  '..nowAdmissionItemCount..'')
    end
end

function GET_INDUN_ADMISSION_ITEM_COUNT(indunCls)
    local etc = GetMyEtcObject();
    if TryGetProp(indunCls,"UnitPerReset","None") == 'ACCOUNT' then
        etc = GetMyAccountObj()
    end
    local admissionItemName = TryGetProp(indunCls, "AdmissionItemName");
    if admissionItemName == nil or admissionItemName == "None" then
        return 0;
    end
    local resetGroupID = indunCls.PlayPerResetType;
    if ((indunCls.DungeonType == "Raid" or indunCls.DungeonType == "GTower") and (indunCls.WeeklyEnterableCount > GET_CURRENT_ENTERANCE_COUNT(resetGroupID))) then
        return 0
    end
    local admissionPlayAddItemCount = TryGetProp(indunCls, "AdmissionPlayAddItemCount");
    local addCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
    if indunCls.WeeklyEnterableCount ~= 0 then
        addCount = GET_CURRENT_ENTERANCE_COUNT(resetGroupID) - indunCls.WeeklyEnterableCount;
        if addCount < 0 then
            addCount = 0;
        end
    end
    addCount = math.floor(addCount * admissionPlayAddItemCount)

    local pc = GetMyPCObject()
    local accountObject = GetMyAccountObj()
    local admissionItemCount = TryGetProp(indunCls, "AdmissionItemCount",0);
    local nowAdmissionItemCount = admissionItemCount + addCount
    if indunCls.DungeonType == 'UniqueRaid' then
        if IsBuffApplied(pc, "Event_Unique_Raid_Bonus") == "YES" then
            nowAdmissionItemCount  = admissionItemCount
        elseif IsBuffApplied(pc, "Event_Unique_Raid_Bonus_Limit") == "YES" and TryGetProp(accountObject,"EVENT_UNIQUE_RAID_BONUS_LIMIT") > 0 then
            nowAdmissionItemCount  = admissionItemCount
        end
    end
    return nowAdmissionItemCount;
end

function INDUNINFO_RESIZE_BY_BUTTONS(frame,type)
    local resizeHeight = 0
    --set resize height
    if type > 0 then
        resizeHeight = tonumber(frame:GetUserConfig('HEIGHT_RESIZE_FOR_BUTTON'));
    end
    --resize
    local posBox = GET_CHILD_RECURSIVELY(frame, 'posBox');
    posBox:Resize(posBox:GetWidth(), posBox:GetOriginalHeight() - resizeHeight);

    local monBox = GET_CHILD_RECURSIVELY(frame, 'monBox');
    local mon_margin = monBox:GetOriginalMargin();
    monBox:SetMargin(mon_margin.left, mon_margin.top - resizeHeight, mon_margin.right, mon_margin.bottom);
    local rewardBox = GET_CHILD_RECURSIVELY(frame, 'rewardBox');
    local reward_margin = rewardBox:GetOriginalMargin();
    rewardBox:SetMargin(reward_margin.left, reward_margin.top - resizeHeight, reward_margin.right, reward_margin.bottom);

    rewardBox:ShowWindow(BoolToNumber(type ~= 2))
end
---------------end draw indun tab detail ui---------------------

function INDUNINFO_SORT_BY_LEVEL(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local resetGroupID = topFrame:GetUserIValue('SELECT')
    local radioBtn = GET_CHILD_RECURSIVELY(topFrame, 'lvAscendRadio');
    local selectedBtn = radioBtn:GetSelectedButton();
    if selectedBtn:GetName() == 'lvAscendRadio' then
        table.sort(g_selectedIndunTable, SORT_BY_LEVEL_BASE_NAME);
    else
        table.sort(g_selectedIndunTable, SORT_BY_LEVEL_REVERSE);
    end
    local tab = GET_CHILD(topFrame, "tab");
    local index = tab:GetSelectItemIndex();
    local SCROLL_WIDTH = 20 * (1-index)
    local MARGIN = 18
    local indunListBox = GET_CHILD_RECURSIVELY(topFrame, 'INDUN_LIST_BOX');    
    local firstChild = indunListBox:GetChild('DETAIL_CTRL_'..indunListBox:GetUserValue('FIRST_INDUN_ID'));
    firstChild = tolua.cast(firstChild, 'ui::CControlSet');
    local startY = firstChild:GetY();    
    for i = 1, #g_selectedIndunTable do
        local indunCls = g_selectedIndunTable[i];        
        local detailCtrl = indunListBox:GetChild('DETAIL_CTRL_'..indunCls.ClassID);        
        if detailCtrl ~= nil then
            detailCtrl:SetOffset(detailCtrl:GetX(), startY + detailCtrl:GetHeight()*(i-1));                
            INDUNINFO_DETAIL_SET_SKIN(detailCtrl,i)
            local skinBox = GET_CHILD(detailCtrl, 'skinBox');
            skinBox:Resize(detailCtrl:GetWidth() - SCROLL_WIDTH - MARGIN, skinBox:GetHeight());

            if i == 1 then
                indunListBox:SetUserValue('FIRST_INDUN_ID', indunCls.ClassID)
            end
        end
    end
    
    local firstSelectedID = indunListBox:GetUserIValue('FIRST_INDUN_ID');


    if resetGroupID < 0 then
        INDUNINFO_MAKE_DETAIL_INFO_BOX_OTHER(topFrame, firstSelectedID)
    else
        INDUNINFO_MAKE_DETAIL_INFO_BOX(topFrame, firstSelectedID);
    end
    indunListBox:SetUserValue('SELECTED_DETAIL', firstSelectedID);
end

function SORT_BY_LEVEL_BASE_NAME(a, b)
    if TryGetProp(a, "Level") == nil or TryGetProp(b, "Level") == nil then
        return false;
    end

    -- Legend Raid Glacier : Easy / Noraml / Hard
    if string.find(a.ClassName, "Legend_Raid_Glacier") ~= nil and string.find(b.ClassName, "Legend_Raid_Glacier") ~= nil then
        return false;
    end

    if tonumber(a.Level) < tonumber(b.Level) then
        return true
    elseif tonumber(a.Level) == tonumber(b.Level) then
        return a.Name < b.Name
    else
        return false
    end
end

function SORT_BY_LEVEL(a, b)
    if TryGetProp(a, "Level") == nil or TryGetProp(b, "Level") == nil then
        return false;
    end
    return tonumber(a.Level) < tonumber(b.Level)
end

function SORT_BY_LEVEL_REVERSE(a, b)
    if TryGetProp(a, "Level") == nil or TryGetProp(b, "Level") == nil then
        return false;
    end
    if tonumber(a.Level) == tonumber(b.Level) then
        return a.Name < b.Name
    end
    return tonumber(a.Level) > tonumber(b.Level)
end

function INDUNINFO_OPEN_INDUN_MAP(parent, ctrl)
    local mapID = parent:GetUserValue('INDUN_START_MAP_ID');
    local indunClassID = parent:GetUserValue('INDUN_CLASS_ID');
    local topFrame = parent:GetTopParentFrame()
    local resetGroupID = topFrame:GetUserIValue('SELECT')
    if resetGroupID < 0 then
        OPEN_INDUN_MAP_INFO(indunClassID, mapID, resetGroupID);
    else
        OPEN_INDUN_MAP_INFO(indunClassID, mapID);
    end
end

function INDUN_CANNOT_YET(msg)
    ui.SysMsg(ScpArgMsg(msg));
    ui.OpenFrame("party");
end

function INDUNINFO_TAB_CHANGE(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local tab = GET_CHILD(frame, "tab");
	local index = tab:GetSelectItemIndex();
	if index == 0 then
		INDUNINFO_UI_OPEN(frame);
    elseif index == 1 then
        WEEKLYBOSSINFO_UI_OPEN(frame);
    elseif index == 2 then
        RAID_RANKING_UI_OPEN(frame);
	elseif index == 3 then
        BORUTA_RANKING_UI_OPEN(frame);
    elseif index == 4 then
        PVP_INDUNINFO_UI_OPEN(frame);
	end
	TOGGLE_INDUNINFO(frame,index)
end

function PVP_INDUNINFO_UI_OPEN(frame)
	INDUNINFO_RESET_USERVALUE(frame);
	worldPVP.RequestPVPInfo();
	local categoryBox = GET_CHILD_RECURSIVELY(frame, 'categoryBox');
	categoryBox:RemoveAllChild();


    local categoryBtnWidth = categoryBox:GetWidth();
    local resetGroupTable = {};
    local indunClsList, cnt = GetClassList('PVPIndun');
    local firstBtn = nil
    for i = 0, cnt - 1 do
        local indunCls = GetClassByIndexFromList(indunClsList, i);
        if indunCls ~= nil and TryGetProp(indunCls,"Category","None") ~= 'None' then
            local groupID = indunCls.GroupID;
            local categoryCtrl = categoryBox:GetChild('CATEGORY_CTRL_'..groupID);      
            if categoryCtrl == nil then
                categoryCtrl = categoryBox:CreateOrGetControlSet('pvp_indun_cate_ctrl', 'CATEGORY_CTRL_'..groupID, 0, i * 50);
                local btn = categoryCtrl:GetChild("button");
                btn:Resize(categoryBtnWidth, categoryCtrl:GetHeight());
                local name = categoryCtrl:GetChild("name");
                local category = indunCls.Category;
                name:SetTextByKey("value", category);
                categoryCtrl:SetUserValue('RESET_GROUP_ID', groupID);
                if firstBtn == nil then
                    firstBtn = GET_CHILD(categoryCtrl,"button")
                end
            end
            INDUNINFO_ADD_COUNT(resetGroupTable,groupID)
            do --time setting
                local timeText = categoryCtrl:GetChild("timeText")
                local startTime = string.format("%02d:%02d",indunCls.StartHour,indunCls.StartMin)
                if startTime < timeText:GetTextByKey("start") then
                    timeText:SetTextByKey("start",startTime)
                end
                local endTime = string.format("%02d:%02d",indunCls.EndHour,indunCls.EndMin)
                if endTime > timeText:GetTextByKey("end") then
                    timeText:SetTextByKey("end",endTime)
                end
            end
        end
    end
    INDUNINFO_CATEGORY_ALIGN_DEFAULT(categoryBox);
    -- set the number of indun
    for resetGroupID, numIndun in pairs(resetGroupTable) do
        local categoryCtrl = categoryBox:GetChild('CATEGORY_CTRL_'..resetGroupID);
        local name = categoryCtrl:GetChild('name');
        name:SetTextByKey('cnt', numIndun);
    end
    -- default select
    PVP_INDUNINFO_CATEGORY_LBTN_CLICK(firstBtn:GetParent(), firstBtn);
end

function PVP_INDUNINFO_CATEGORY_LBTN_CLICK(categoryCtrl, ctrl)
    local topFrame = categoryCtrl:GetTopParentFrame();
    local preSelectType = topFrame:GetUserIValue('SELECT');
    local selectedResetGroupID = categoryCtrl:GetUserIValue('RESET_GROUP_ID');
    if preSelectType == selectedResetGroupID then    
        return;
    end
    -- set button skin
    INDUNINFO_CHANGE_CATEGORY_BUTTON_SKIN(topFrame,categoryCtrl)

    -- make indunlist
    local categoryBox = GET_CHILD_RECURSIVELY(topFrame, 'categoryBox');
    local indunListBox = INDUNINFO_RESET_INDUN_LISTBOX(categoryBox)
    local indunClsList, cnt = GetClassList('PVPIndun');    
    local firstBtn = nil
    for i = 0, cnt - 1 do
        local indunCls = GetClassByIndexFromList(indunClsList, i);
        if indunCls.GroupID == selectedResetGroupID and indunCls.Category ~= 'None' then
            local indunDetailCtrl = indunListBox:CreateOrGetControlSet('indun_detail_ctrl', 'DETAIL_CTRL_'..indunCls.ClassID, 0, 0);
            indunDetailCtrl = tolua.cast(indunDetailCtrl, 'ui::CControlSet');
            indunDetailCtrl:SetUserValue('INDUN_CLASS_ID', indunCls.ClassID);
            indunDetailCtrl:SetEventScript(ui.LBUTTONUP, 'INDUNINFO_DETAIL_LBTN_CLICK');

            local infoText = indunDetailCtrl:GetChild('infoText');
            local nameText = indunDetailCtrl:GetChild('nameText');
            local infoTextrect = infoText:GetMargin();
            nameText:SetMargin(infoTextrect.left,infoTextrect.top,infoTextrect.right,infoTextrect.bottom)
            nameText:SetTextByKey('name', indunCls.Name);
            indunDetailCtrl:RemoveChild('infoText')

            PVP_INDUNINFO_DETAIL_SET_ONLINE_PIC(indunDetailCtrl)

            INDUNINFO_PUSH_BACK_TABLE(g_selectedIndunTable,indunCls)
            INDUNINFO_DETAIL_SET_SKIN(indunDetailCtrl,#g_selectedIndunTable)
            if firstBtn == nil then
                firstBtn = indunDetailCtrl
            end
        end
    end
    GBOX_AUTO_ALIGN(indunListBox, 0, 2, 0, true, true);

    -- category box align
    INDUNINFO_CATEGORY_ALIGN_DEFAULT(categoryBox);
    INDUNINFO_DETAIL_LBTN_CLICK(firstBtn:GetParent(),firstBtn);
end 

function PVP_INDUNINFO_DETAIL_SET_ONLINE_PIC(indunDetailCtrl)
    local indunClsID = indunDetailCtrl:GetUserValue('INDUN_CLASS_ID');
	local indunCls = GetClassByType("PVPIndun",indunClsID)

	local startTime = geTime.GetServerSystemTime()
	startTime.wHour = indunCls.StartHour
	startTime.wMinute = indunCls.StartMin
	startTime.wSecond = 0

	local endTime = geTime.GetServerSystemTime()
	endTime.wHour = indunCls.EndHour
	if indunCls.EndHour >= 24 then
		endTime.wDay = endTime.wDay + 1
		endTime.wHour = endTime.wHour - 24
	elseif indunCls.EndHour < indunCls.StartHour then
		endTime.wDay = endTime.wDay + 1
	elseif indunCls.EndHour == indunCls.StartHour and indunCls.EndMin < indunCls.StartMin then
		endTime.wDay = endTime.wDay + 1
	end
	endTime.wMinute = indunCls.EndMin
	endTime.wSecond = 0

    if imcTime.GetDiffSecFromNow(startTime) >= 0 then
        if imcTime.GetDiffSecFromNow(endTime) < 0 then
            local onlinePic = indunDetailCtrl:GetChild('onlinePic');
            AUTO_CAST(onlinePic)
            onlinePic:SetImage('guild_online')
        end
    end
end

function INDUNINFO_CHANGE_CATEGORY_BUTTON_SKIN(frame,categoryCtrl)
    local preSelectType = frame:GetUserIValue('SELECT');
    local selectedResetGroupID = categoryCtrl:GetUserIValue('RESET_GROUP_ID');
    categoryCtrl = tolua.cast(categoryCtrl, 'ui::CControlSet');

    local SELECTED_BTN_SKIN = categoryCtrl:GetUserConfig('SELECTED_BTN_SKIN');
    local NOT_SELECTED_BTN_SKIN = categoryCtrl:GetUserConfig('NOT_SELECTED_BTN_SKIN');
    local preSelect = GET_CHILD_RECURSIVELY(frame, "CATEGORY_CTRL_" .. preSelectType);
    if nil ~= preSelect then
        local button = preSelect:GetChild("button");
        button:SetSkinName(NOT_SELECTED_BTN_SKIN);
    end
    frame:SetUserValue('SELECT', selectedResetGroupID);
    local ctrl = categoryCtrl:GetChild("button");
    ctrl:SetSkinName(SELECTED_BTN_SKIN);
end

function INDUNINFO_RESET_INDUN_LISTBOX(categoryBox)
    local listBoxWidth = categoryBox:GetWidth() - 20;
    categoryBox:RemoveChild('INDUN_LIST_BOX');
    g_selectedIndunTable = {};
    local indunListBox = categoryBox:CreateControl('groupbox', 'INDUN_LIST_BOX', 5, 0, listBoxWidth, 30);
    indunListBox = tolua.cast(indunListBox, 'ui::CGroupBox');
    indunListBox:EnableDrawFrame(0);
    indunListBox:EnableScrollBar(0);
    return indunListBox
end

function INDUNINFO_DETAIL_SET_SKIN(indunDetailCtrl,index)
    local skinBox = GET_CHILD(indunDetailCtrl, 'skinBox');
    if index % 2 == 0 then
        skinBox:SetSkinName(NOT_SELECTED_BOX_SKIN);
    else
        skinBox:SetSkinName('None');
    end
end

function ON_PVPMINE_HELP(parent,ctrl,argStr,argNum)
    local piphelp = ui.GetFrame("piphelp");
	PIPHELP_MSG(piphelp, "FORCE_OPEN", argStr,  551)
end

function ON_TEAMBATTLE_HELP(parent,ctrl,argStr,argNum)
    local piphelp = ui.GetFrame("piphelp");
	PIPHELP_MSG(piphelp, "FORCE_OPEN", argStr,  19)
end

function ON_JOIN_PVP_MINE(parent,ctrl,argStr,argNum)
	local classID = ctrl:GetUserValue('MOVE_INDUN_CLASSID')
	local yesScp = string.format("_ON_JOIN_PVP_MINE(%d)",classID)
    ui.MsgBox(ClMsg('EnterRightNow'), yesScp, 'None');
end

function _ON_JOIN_PVP_MINE(classID)
	local cls = GetClassByType("PVPIndun",classID)
	pc.ReqExecuteTx("SCR_PVP_MINE_ENTER",cls.ClassName)
end

function ON_JOIN_TEAM_BATTLE(parent,ctrl)
	if IS_TEAM_BATTLE_ENABLE() == 0 then
		ctrl:SetEnable(0)
		return
	end
    local adventure_book = ui.GetFrame('adventure_book')
    local adventure_book_btn = GET_CHILD_RECURSIVELY(adventure_book,"teamBattleMatchingBtn")
	ADVENTURE_BOOK_JOIN_WORLDPVP(adventure_book_btn:GetParent(),adventure_book_btn)
end

function INDUNINFO_TEAM_BATTLE_STATE_CHANGE(frame,ctrl,argStr,argNum)
	local state = session.worldPVP.GetState();
	local stateText = GetPVPStateText(state);
	local viewText = ClMsg( "PVP_State_".. stateText );
	local join = GET_CHILD_RECURSIVELY(frame, 'RedButton');
	join:SetTextByKey("btnText", viewText);
	join:SetEnable(IS_TEAM_BATTLE_ENABLE())
end

function INDUNINFO_MOVE_TO_ENTER_NPC(frame, ctrl)
    local pc = GetMyPCObject();
    
    -- 매칭 던전중이거나 pvp존이면 이용 불가
    if session.world.IsIntegrateServer() == true or IsPVPField(pc) == 1 or IsPVPServer(pc) == 1 then
        ui.SysMsg(ScpArgMsg('ThisLocalUseNot'));
        return;
    end

    -- 퀘스트나 챌린지 모드로 인해 레이어 변경되면 이용 불가
    if world.GetLayer() ~= 0 then
        ui.SysMsg(ScpArgMsg('ThisLocalUseNot'));
        return;
    end

    -- 프리던전 맵에서 이용 불가
    local curMap = GetClass('Map', session.GetMapName());
    local mapType = TryGetProp(curMap, 'MapType');
    if mapType == 'Dungeon' then
        ui.SysMsg(ScpArgMsg('ThisLocalUseNot'));
        return;
    end

    -- 레이드 지역에서 이용 불가
    local zoneKeyword = TryGetProp(curMap, 'Keyword', 'None')
    local keywordTable = StringSplit(zoneKeyword, ';')
    if table.find(keywordTable, 'IsRaidField') > 0 or table.find(keywordTable, 'WeeklyBossMap') > 0 then
        ui.SysMsg(ScpArgMsg('ThisLocalUseNot'))
        return
    end

    local indunClsID = ctrl:GetUserValue('MOVE_INDUN_CLASSID');
    control.CustomCommand('MOVE_TO_ENTER_NPC', indunClsID, 0, 0);
end

function INDUNINFO_MOVE_TO_SOLO_DUNGEON(parent,ctrl)
    local indunClsID = ctrl:GetUserValue('MOVE_INDUN_CLASSID');
    local yesScp = string.format("_INDUNINFO_MOVE_TO_DUNGEON(%d,0)",indunClsID)
    ui.MsgBox(ClMsg('EnterRightNow'), yesScp, 'None');
end

function INDUNINFO_MOVE_TO_ANCIENT_DUNGEON(parent,ctrl)
    local cls = GetClass("Indun","Ancient_Solo_dungeon")
    local indunClsID = ctrl:GetUserValue('MOVE_INDUN_CLASSID');
    local indunCls = GetClassByType('contents_info',indunClsID)
    local selectStage = GET_ANCIENT_STAGE_OF_CLASS(indunCls)
    local yesScp = string.format("_INDUNINFO_MOVE_TO_DUNGEON(%d,%d)",cls.ClassID,selectStage)
    ui.MsgBox(ClMsg('EnterRightNow'), yesScp, 'None');
end

function GET_ANCIENT_STAGE_OF_CLASS(indunCls)
    local strList = StringSplit(indunCls.ClassName,'_')
    local stage = tonumber(strList[#strList])
    local selectStage = 1 + (stage-1)*5
    return selectStage
end

function _INDUNINFO_MOVE_TO_DUNGEON(type,argNum)
    ReqEnterSoloIndun(type,argNum)
    ui.CloseFrame('induninfo')
end

function SCR_OPEN_OBSERVE_TEAMBATTLE()
    ui.OpenFrame('adventure_book')
    ON_EVENTBANNER_DETAIL_BTN_TEAMBATTLE()
    ui.CloseFrame('induninfo')
end

function REQ_OPEN_SOLO_DUNGEON_RANKING_UI()
    pc.ReqExecuteTx("SEND_SOLO_DUNGEON_RANKING_FULL","None")
    ui.CloseFrame('induninfo')
end

function SCR_OPEN_INDUNINFO_PVPREWARD(parent,ctrl,argStr,argNum)
    local frame = parent:GetTopParentFrame()
    local x = frame:GetX() + frame:GetWidth()
    local y = frame:GetY()

	local rewardFrame = ui.GetFrame('induninfo_pvpreward')
	local typeTable = {
		Ancient_Solo_dungeon="Ancient_Dungeon_Reward_Info",
		pvp_Mine="PVP_Mine_Reward_Info",
		teamBattle="TEAM_BATTLE_Reward_Info"}
	for key,val in pairs(typeTable) do
		if string.find(argStr,key) ~= nil then
			INIT_INDUNINFO_PVPREWARD(rewardFrame,val)
			break
		end
	end
    rewardFrame:ShowWindow(1)
    rewardFrame:SetOffset(x,y)
end

function INDUNINFO_SELECT_CATEGORY(index)
	local frame = ui.GetFrame('induninfo')
    local categoryBox = GET_CHILD_RECURSIVELY(frame, 'categoryBox');
	local ctrl = categoryBox:GetChildByIndex(index)
	local button = GET_CHILD(ctrl,"button")
    PVP_INDUNINFO_CATEGORY_LBTN_CLICK(button:GetParent(), button);
end
--------------------------------- 주간 보스 레이드 --------------------------------- 
function  WEEKLYBOSSINFO_UI_OPEN(frame)
    WEEKLY_BOSS_DATA_REUQEST();

    local frame = ui.GetFrame('induninfo');
    
	SET_WEEKLYBOSS_INDUN_COUNT(frame)
end

function WEEKLY_BOSS_SEASON_SELECT(frame,ctrl)

end

function WEEKLY_BOSS_DATA_REUQEST()
    local frame = ui.GetFrame("induninfo")
    local rank_gb = GET_CHILD_RECURSIVELY(frame, "rank_gb");
    rank_gb:EnableHitTest(0);
    ReserveScript("HOLD_RANKUI_UNFREEZE()", 1);

    local week_num =  WEEKLY_BOSS_RANK_WEEKNUM_NUMBER();
    if week_num < 1 then
        return;
    end
    weekly_boss.RequestWeeklyBossAbsoluteRewardList(week_num);  -- 누적대미지 보상 목록 요청
    weekly_boss.RequestWeeklyBossRankingRewardList(week_num);   -- 랭킹 보상 목록 요청
    weekly_boss.RequestGetReceiveAbsoluteReward(week_num);      -- 내가 수령한 누적대미지 보상 정보 요청
    weekly_boss.RequestGetReceiveRankingReward(week_num);       -- 내가 수령한 랭킹 보상 정보 요청

    -- 랭킹 정보
    local jobID = WEEKLY_BOSS_RANK_JOBID_NUMBER();
    weekly_boss.RequestWeeklyBossRankingInfoList(week_num, jobID);

    -- 보스 정보
    weekly_boss.RequestWeeklyBossStartTime(week_num);           -- 해당 주간 보스 시작 시간 정보 요청
    weekly_boss.RequestWeeklyBossEndTime(week_num);             -- 해당 주간 보스 종료 시간 정보 요청
    weekly_boss.RequestWeeklyBossPatternInfo(week_num);             -- 해당 주간 보스 종료 시간 정보 요청
    
    local rankListBox = GET_CHILD_RECURSIVELY(frame, "rankListBox", "ui::CGroupBox");
	rankListBox:RemoveAllChild();
end

function HOLD_RANKUI_UNFREEZE()
    local frame = ui.GetFrame("induninfo");    
    local rank_gb = GET_CHILD_RECURSIVELY(frame, "rank_gb");
    rank_gb:EnableHitTest(1);
end

-- 갱신된 정보에 맞게 UI 수정 
function WEEKLY_BOSS_UI_UPDATE()
    local frame = ui.GetFrame("induninfo")
    local week_num = WEEKLY_BOSS_RANK_WEEKNUM_NUMBER();

    -- 몬스터 정보
    local weeklybossPattern = session.weeklyboss.GetPatternInfo();
    local monClsName = weeklybossPattern.MonsterClassName
    local monCls = GetClass("Monster",monClsName)
    if monCls ~= nil then
        local monster_icon_pic = GET_CHILD_RECURSIVELY(frame, 'monster_icon_pic');
        monster_icon_pic:SetImage(monCls.Icon);
        
        local monster_attr1 = GET_CHILD_RECURSIVELY(frame, "monster_attr1", "ui::CControlSet");
        local monster_attr2 = GET_CHILD_RECURSIVELY(frame, "monster_attr2", "ui::CControlSet");
        local monster_attr3 = GET_CHILD_RECURSIVELY(frame, "monster_attr3", "ui::CControlSet");
        local monster_attr4 = GET_CHILD_RECURSIVELY(frame, "monster_attr4", "ui::CControlSet");
        local monster_attr5 = GET_CHILD_RECURSIVELY(frame, "monster_attr5", "ui::CControlSet");
        local monster_attr6 = GET_CHILD_RECURSIVELY(frame, "monster_attr6", "ui::CControlSet");
        
        SET_TEXT(monster_attr1, "attr_name_text", "value", ScpArgMsg('Name'));
        SET_TEXT(monster_attr2, "attr_name_text", "value", ScpArgMsg('RaceType'));
        SET_TEXT(monster_attr3, "attr_name_text", "value", ScpArgMsg('Attribute'));
        SET_TEXT(monster_attr4, "attr_name_text", "value", ScpArgMsg('MonInfo_ArmorMaterial'));
        SET_TEXT(monster_attr5, "attr_name_text", "value", ScpArgMsg('Level'));
        SET_TEXT(monster_attr6, "attr_name_text", "value", ScpArgMsg('Area'));

        SET_TEXT(monster_attr1, "attr_value_text", "value", monCls.Name);
        SET_TEXT(monster_attr2, "attr_value_text", "value", ScpArgMsg(weeklybossPattern.RaceType));
        SET_TEXT(monster_attr3, "attr_value_text", "value", ScpArgMsg("MonInfo_Attribute_"..weeklybossPattern.Attribute));
        SET_TEXT(monster_attr4, "attr_value_text", "value", ScpArgMsg(weeklybossPattern.ArmorMaterial));
        SET_TEXT(monster_attr5, "attr_value_text", "value", monCls.Level);
        local attr5_value_text = GET_CHILD_RECURSIVELY(monster_attr6,"attr_value_text")
        local mapCls = GetClassByType("Map",weeklybossPattern.mapClassID)
        if mapCls ~= nil then
            SET_TEXT(monster_attr6, "attr_value_text", "value", mapCls.Name);
        end
    end
    
    -- 전투 정보
    local myrank = session.weeklyboss.GetMyRankInfo(week_num);          -- 계열 등수
    local totalcnt = session.weeklyboss.GetTotalRankCount(week_num);    -- 계열별 전체 도전 유저
    local myrank_p = (myrank/totalcnt) * 100;
    myrank_p = string.format("%.2f",myrank_p)
    if totalcnt <= 0 then
        myrank_p = 0;
    end
    local mydamage = session.weeklyboss.GetMyDamageInfoToString(week_num);                  -- 도전 1회 최고 점수
    local accumulateDamage = session.weeklyboss.GetWeeklyBossAccumulatedDamage(week_num);   -- 누적 대미지
    
    local battle_info_attr = GET_CHILD_RECURSIVELY(frame, "battle_info_attr", "ui::CControlSet");
    SET_TEXT(battle_info_attr, "attr_value_text_1", "rank", myrank);
    SET_TEXT(battle_info_attr, "attr_value_text_1", "rank_p", myrank_p);
    SET_TEXT(battle_info_attr, "attr_value_text_2", "value", STR_KILO_CHANGE(mydamage));
    SET_TEXT(battle_info_attr, "attr_value_text_3", "value", STR_KILO_CHANGE(accumulateDamage));
    
    -- 제한 시간     
    local starttime = session.weeklyboss.GetWeeklyBossStartTime();
    local endtime = session.weeklyboss.GetWeeklyBossEndTime();
    local durtime = imcTime.GetDifSec(endtime, starttime);
    local systime = geTime.GetServerSystemTime();
    local difsec = imcTime.GetDifSec(endtime, systime);

    local gauge = GET_CHILD_RECURSIVELY(frame, "gauge", "ui::CGauge");
    local battle_info_time_text = GET_CHILD_RECURSIVELY(frame, "battle_info_time_text", "ui::CRichText");
    
    if 0 < difsec then
        gauge:SetPoint(durtime - difsec, durtime);
        
        local textstr = GET_TIME_TXT(difsec) .. ClMsg("After_Exit");
        battle_info_time_text:SetTextByKey("value", textstr);
        
        battle_info_time_text:SetUserValue("REMAINSEC", difsec);
        battle_info_time_text:SetUserValue("STARTSEC", imcTime.GetAppTime());
        battle_info_time_text:RunUpdateScript("WEEKLY_BOSS_REMAIN_END_TIME");
    elseif difsec < 0 then
        gauge:SetPoint(1, 1);
        
        local textstr = ClMsg("Already_Exit_Raid");
        battle_info_time_text:SetTextByKey("value", textstr);
        battle_info_time_text:StopUpdateScript("WEEKLY_BOSS_REMAIN_END_TIME");
    end

    -- 입장 횟수
    -- 입장 제한
    local joinButton = GET_CHILD_RECURSIVELY(frame,"joinenter")
    if week_num ~= session.weeklyboss.GetNowWeekNum() then
        joinButton:SetEnable(0)
    else
        joinButton:SetEnable(1)
    end
    --시즌 갱신
    WEEKLY_BOSS_SEASON_UPDATE();
    -- 랭킹 LIST 갱신
    WEEKLY_BOSS_RANK_UPDATE();

end

function WEEKLY_BOSS_SEASON_UPDATE()
    local weekNum = session.weeklyboss.GetNowWeekNum();
    local frame = ui.GetFrame("induninfo")
    local tabControl = GET_CHILD_RECURSIVELY(frame, "season_tab", "ui::CTabControl");
    local cnt = tabControl:GetItemCount()
    for i = 0,cnt-1 do
        if weekNum - i > 0 then
            tabControl:ChangeCaption(i,"{@st42b}{s16}"..tostring(weekNum - i), false)
        else
            tabControl:ChangeCaption(i,"{@st42b}{s16}-", false)
        end
    end
end

-- 주간 보스 남은시간 표시
function WEEKLY_BOSS_REMAIN_END_TIME(ctrl)
	local elapsedSec = imcTime.GetAppTime() - ctrl:GetUserIValue("STARTSEC");
	local startSec = ctrl:GetUserIValue("REMAINSEC");
    startSec = startSec - elapsedSec;
	if 0 > startSec then
		ctrl:SetFontName("red_18");
        ctrl:StopUpdateScript("WEEKLY_BOSS_REMAIN_END_TIME");
        ctrl:ShowWindow(0);
        return 0;
	end 
    
	local timeTxt = GET_TIME_TXT(startSec);
    ctrl:SetTextByKey("value", timeTxt);
    
	return 1;
end

-- rank list 
function WEEKLY_BOSS_RANK_UPDATE()
    local frame = ui.GetFrame("induninfo")
    local rankListBox = GET_CHILD_RECURSIVELY(frame, "rankListBox", "ui::CGroupBox");
    rankListBox:RemoveAllChild();

    local cnt = session.weeklyboss.GetRankInfoListSize();
    if cnt == 0 then
        return;
    end

    local Width = frame:GetUserConfig("SCROLL_BAR_TRUE_WIDTH");
    if cnt < 6 then
        Width = frame:GetUserConfig("SCROLL_BAR_FALSE_WIDTH");
    end
    
    for i = 1, cnt do
        local ctrlSet = rankListBox:CreateControlSet("content_status_board_rank_attribute", "CTRLSET_" .. i,  ui.LEFT, ui.TOP, 0, (i - 1) * 73, 0, 0);
        ctrlSet:Resize(Width, ctrlSet:GetHeight());
        local attr_bg = GET_CHILD(ctrlSet, "attr_bg");
        attr_bg:Resize(Width, attr_bg:GetHeight());

        local rankpic = GET_CHILD(ctrlSet, "attr_rank_pic");
        local attr_rank_text = GET_CHILD(ctrlSet, "attr_rank_text");

        if i <= 3 then
            rankpic:SetImage('raid_week_rank_0'..i)
            rankpic:ShowWindow(1);

            attr_rank_text:ShowWindow(0);
        else
            rankpic:ShowWindow(0);

            attr_rank_text:SetTextByKey("value", i);
            attr_rank_text:ShowWindow(1);
        end

        local damage = session.weeklyboss.GetRankInfoDamage(i - 1);
        local teamname = session.weeklyboss.GetRankInfoTeamName(i - 1);
        local guildID = session.weeklyboss.GetRankInfoGuildID(i - 1)
        if guildID ~= "0" then
            ctrlSet:SetUserValue("GUILD_IDX",guildID)
            GetGuildEmblemImage("WEEKLY_BOSS_EMBLEM_IMAGE_SET",guildID)
        end

        local name = GET_CHILD(ctrlSet, "attr_name_text", "ui::CRichText");
        name:SetTextByKey("value", teamname);

        local value = GET_CHILD(ctrlSet, "attr_value_text", "ui::CRichText");
        value:SetTextByKey("value", STR_KILO_CHANGE(damage));
    
    end

end

function WEEKLY_BOSS_EMBLEM_IMAGE_SET(code, return_json)
    if code ~= 200 then
        if code == 400 or code == 404 then
            return
        else
            SHOW_GUILD_HTTP_ERROR(code, return_json, "WEEKLY_BOSS_EMBLEM_IMAGE_SET")
            return
        end
    end
    
    local guild_idx = return_json
    emblemFolderPath = filefind.GetBinPath("GuildEmblem"):c_str()
    local emblemPath = emblemFolderPath .. "\\" .. guild_idx .. ".png";

    local frame = ui.GetFrame('induninfo')
    local rankListBox = GET_CHILD_RECURSIVELY(frame, "rankListBox", "ui::CGroupBox");
    for i = 0,rankListBox:GetChildCount()-1 do
        local controlset = rankListBox:GetChildByIndex(i)
        if controlset:GetUserValue("GUILD_IDX") == guild_idx then
            local picture = tolua.cast(controlset:GetChildRecursively("attr_emblem_pic"), "ui::CPicture");
            ui.SetImageByPath(emblemPath, picture);        
        end
    end
end

-- 페이지 컨트롤 page
function WEEKLY_BOSS_RANK_WEEKNUM_NUMBER()
    local frame = ui.GetFrame('induninfo');
    local tabcontrol = GET_CHILD_RECURSIVELY(frame, "season_tab", "ui::CTabControl");
	if tabcontrol == nil then
		return 0;
    end
    
    local tabidx = tabcontrol:GetSelectItemIndex();
	return session.weeklyboss.GetNowWeekNum() - tabidx;
end

-- 계열 탭 jobid 
function WEEKLY_BOSS_RANK_JOBID_NUMBER()
    local frame = ui.GetFrame('induninfo');
    local classtype_tab = GET_CHILD_RECURSIVELY(frame, "classtype_tab", "ui::CTabControl");
    local index = classtype_tab:GetSelectItemIndex();

    jobID = string.format('%s001', index+1);
    return tonumber(jobID);
end

function WEEKLY_BOSS_PATTERN_UI_OPEN()
    ui.ToggleFrame("weeklyboss_patterninfo");
end

-- 누적 대미지 보상 버튼 클릭
function WEEKLY_BOSS_TOTAL_DAMAGE_REWARD_CLICK()
    local week_num = WEEKLY_BOSS_RANK_WEEKNUM_NUMBER();
    WEEKLYBOSSREWARD_SHOW(1);
end

-- 계열 순위 보상 버튼 클릭
function WEEKLY_BOSS_RANK_REWARD_CLICK()
    local week_num = WEEKLY_BOSS_RANK_WEEKNUM_NUMBER();
    WEEKLYBOSSREWARD_SHOW(0);
end

-- 입장하기 버튼 클릭
function WEEKLY_BOSS_JOIN_ENTER_CLICK(parent,ctrl)
    ui.MsgBox(ClMsg('EnterRightNow'), 'WEEKLY_BOSS_JOIN_ENTER_CLICK_MSG(0)', 'None');
end     

-- 연습모드 버튼 클릭
function WEEKLY_BOSS_JOIN_PRACTICE_ENTER_CLICK(parent,ctrl)
    ui.MsgBox(ClMsg('EnterRightNow'), 'WEEKLY_BOSS_JOIN_ENTER_CLICK_MSG(1)', 'None');
end     


function WEEKLY_BOSS_JOIN_ENTER_CLICK_MSG(type)
    local frame = ui.GetFrame("induninfo");
    local ctrl = GET_CHILD_RECURSIVELY(frame,"joinenter")
    if type == 1 then
        ReqEnterWeeklyBossIndun(type)
    elseif ctrl:GetTextByKey('cur') < ctrl:GetTextByKey('max') or session.weeklyboss.GetNowWeekNum() == 1 or session.weeklyboss.GetNowWeekNum() == 2 then
        ReqEnterWeeklyBossIndun(type)
    else
        ui.SysMsg(ScpArgMsg('IRREDIAN1131_DLG_LANG_1_CANT'));
    end
end
--------------------------------- 주간 보스 레이드 ---------------------------------

--------------------------------- 레이드 랭킹 ---------------------------------
local json = require "json_imc";
local curPage = 1;
local infolistY = 0;
local finishedLoading = false;
local scrolledTime = 0;
local raidrankingcategory = {};

function RAID_RANKING_UI_OPEN(frame)
    RAID_RANKING_CATEGORY_INIT(frame);
end

function RAID_RANKING_CATEGORY_SORT_BY_LEVEL()
    raidrankingcategory = {}

    local clsList, cnt = GetClassList("raid_ranking_category");
    for i = 0, cnt - 1 do
        local cls = GetClassByIndexFromList(clsList, i);
        raidrankingcategory[#raidrankingcategory + 1] = cls;
    end

    --table.sort(raidrankingcategory, SORT_BY_LEVEL_BASE_NAME);
end

function RAID_RANKING_CATEGORY_INIT(frame)
    frame:SetUserValue('SELECTED_DETAIL', 0);

    local raidcategoryBox = GET_CHILD_RECURSIVELY(frame, 'raidcategoryBox');
    raidcategoryBox:RemoveAllChild();
    raidcategoryBox:EnableHitTest(1);
    
    local raidrankinglist = GET_CHILD_RECURSIVELY(frame, 'raidrankinglist');
    raidrankinglist:RemoveAllChild();
    raidrankinglist:SetScrollPos(0);
    raidrankinglist:SetEventScript(ui.SCROLL, "RAID_RANKING_INFO_SCROLL");

    infolistY = 0;
    curPage = 1;
    scrolledTime = 0;

    RAID_RANKING_CATEGORY_SORT_BY_LEVEL();
    local clsList, cnt = GetClassList("raid_ranking_category");

    local y = 0;
    local width = 350;
    if 8 < cnt then 
        width = 330; 
    end

    for i = 1, #raidrankingcategory do
        local cls = raidrankingcategory[i]
        local ctrl = raidcategoryBox:CreateOrGetControlSet("raid_ranking_category_info", "RAID_RANKING_CTRL"..cls.ClassID, 0, y);

        local btnctrl = GET_CHILD(ctrl, "button");
        btnctrl:SetUserValue('RAID_RANKING_CLASS_ID', cls.ClassID);
        btnctrl:SetEventScript(ui.LBUTTONUP, 'RAID_RANKING_CATEGORY_CLICK');

        local levelctrl = GET_CHILD(ctrl, "level");
        local namectrl = GET_CHILD(ctrl, "name");

        levelctrl:SetTextByKey("value", cls.Level);
        namectrl:SetTextByKey("value", ClMsg(cls.ClassName));  -- 콘텐츠 이름
        namectrl:SetUserValue('RAID_RANKING_CLASS_ID', cls.ClassID);
        namectrl:SetEventScript(ui.LBUTTONUP, 'RAID_RANKING_CATEGORY_CLICK');

        y = y + ctrl:GetHeight() - 5;
    end

end

function RAID_RANKING_CATEGORY_CLICK(parent, detailCtrl)
    local frame = parent:GetTopParentFrame();

    local indunClassID = detailCtrl:GetUserIValue('RAID_RANKING_CLASS_ID');
    local preSelectedDetail = frame:GetUserIValue('SELECTED_DETAIL');
    if indunClassID == preSelectedDetail then
        return;
    end
    
    local raidcategoryBox = GET_CHILD_RECURSIVELY(frame, 'raidcategoryBox');
    raidcategoryBox:EnableHitTest(0);
    ReserveScript("RAID_RANKING_CATEGORY_UI_UNFREEZE()", 1.0);
    
    local raidrankinglist = GET_CHILD_RECURSIVELY(frame, 'raidrankinglist');
    raidrankinglist:RemoveAllChild();
    raidrankinglist:SetScrollPos(0);

    -- set skin
    local preSelectedCtrl = GET_CHILD_RECURSIVELY(frame, 'RAID_RANKING_CTRL'..preSelectedDetail);
    if preSelectedCtrl ~= nil then
        local preBtnCtrl = GET_CHILD(preSelectedCtrl, "button");
        preBtnCtrl:SetSkinName("base_btn");
    end

    detailCtrl:SetSkinName("baseyellow_btn");
    frame:SetUserValue('SELECTED_DETAIL', indunClassID);

    infolistY = 0;
    curPage = 1;
    scrolledTime = imcTime.GetAppTime();

    local rankCls = GetClassByType("raid_ranking_category", indunClassID);
    GetRaidRanking('RAID_RANKING_INFO_UPDATE', rankCls.ClassName, curPage, TryGetProp(rankCls, "Order", "asc"));
end

function RAID_RANKING_INFO_UPDATE(code, ret_json)    
    finishedLoading = true;
    
    if code ~= 200 then
        if code == 500 then
            ui.SysMsg(ScpArgMsg('CantExecInThisArea'));
        end
        
        local frame = ui.GetFrame("induninfo");
        RAID_RANKING_CATEGORY_INIT(frame);
        return;
    end

    local parsed = json.decode(ret_json);
    local count = parsed['count'];
    if tonumber(count) == 0 then
        return;
    end

    local list = parsed['list'];
    for k, v in pairs(list) do
        local rank = v['rank'];
        local time = v['score'];
        local member = v['member'];

        if 100 < rank then
            return;
        end

        infolistY = RAID_RANKING_INFO_DETAIL(infolistY, rank, time, member);
    end
end

function RAID_RANKING_INFO_DETAIL(y, rank, time, member)
    local frame = ui.GetFrame("induninfo");
    local myParty = false;

    local gb = GET_CHILD_RECURSIVELY(frame, 'raidrankinglist');
    
    local ctrl = gb:CreateOrGetControlSet("raid_ranking_info", "RAID_RANKING_DETAIL_"..rank, 5, y);

    local rankCtrl = GET_CHILD(ctrl, 'rank');
    rankCtrl:SetTextByKey("value", rank);

    local timetext = GET_RAID_RANKING_TIME_TXT(time);
    local timeCtrl = GET_CHILD(ctrl, 'time');
    timeCtrl:SetTextByKey("value", timetext);

    local membergb = GET_CHILD(ctrl, 'membergb');
    membergb:RemoveAllChild();

    local pic = GET_CHILD(ctrl, 'pic');

    if rank <= 3 then
        pic:SetImage('raid_week_rank_0'..rank)
        pic:ShowWindow(1);

        rankCtrl:ShowWindow(0);
    else
        pic:ShowWindow(0);
        rankCtrl:ShowWindow(1);
    end

    local memberstrlist = StringSplit(member, ', ');
    local memberCnt = #memberstrlist;
    
    local membery = 20;
    for i = 1, memberCnt do
        local infostrlist = StringSplit(memberstrlist[i], ' ');
        local teamname = "";
        local guildname = "";
        local memberCtrl = membergb:CreateOrGetControlSet("raid_ranking_info_member", "member_"..i, 0, membery);
        if 1 < #infostrlist then
            guildname = infostrlist[1];
            teamname = infostrlist[2];

            local guildCtrl = GET_CHILD(memberCtrl, "guild");
            guildCtrl:SetText(guildname);
        else
            teamname = infostrlist[1];
        end
        
        local teamCtrl = GET_CHILD(memberCtrl, "team");
        teamCtrl:SetText(teamname);

        local myHandle = session.GetMyHandle();
        if teamname == info.GetFamilyName(myHandle) then
            myParty = true;
        end

        membery = membery + (memberCtrl:GetHeight() * 1.5);
    end
   

    membergb:Resize(membergb:GetWidth(), membery + 15);
    local height = ctrl:GetHeight();
    
    if ctrl:GetHeight() < membergb:GetHeight() then
        height = membergb:GetHeight();
    end
    
    ctrl:Resize(ctrl:GetWidth(), height);

    if myParty == true then
        ctrl:SetSkinName("guildbattle_win_bg");
    end

    y = y + ctrl:GetHeight();
    return y;
end

function GET_RAID_RANKING_TIME_TXT(time)
	if time == 0.0 then
		return "";
	end

    local sec = time / 1000;
    
	local hour = math.floor(sec / 3600);
	if hour < 0 then
		hour = 0;
	end

	sec = sec - hour * 3600;

	local min = math.floor(sec / 60);
	if min < 0 then
		min = 0;
	end

	sec = math.floor(sec - min * 60);
	if sec < 0 then
		sec = 0;
	end

    local hourtext = hour;
    if hour < 10 then
        hourtext = string.format("0%s", hour);
	end

    local mintext = min;
    if min < 10 then
        mintext = string.format("0%s", min);
    end
    
    local sectext = sec;
    if sec < 10 then
        sectext = string.format("0%s", sec);
    end
    
    local final_text = ''
    
    if hourtext ~= '00' then
        final_text = hourtext..ScpArgMsg("Auto_SiKan").." "..mintext..ScpArgMsg("Auto_Bun").." "..sectext..ScpArgMsg("Auto_Cho");
    elseif mintext ~= '00' then
        final_text = mintext..ScpArgMsg("Auto_Bun").." "..sectext..ScpArgMsg("Auto_Cho")
    else
        final_text = sectext..ScpArgMsg("Auto_Cho")
    end

    return final_text
end

function RAID_RANKING_INFO_SCROLL(parent, ctrl)
    local frame = ui.GetFrame("induninfo");

    if ctrl:IsScrollEnd() == true and finishedLoading == true then       
        local classID = frame:GetUserIValue('SELECTED_DETAIL');

        local rankCls = GetClassByType("raid_ranking_category", classID);
        if rankCls == nil then
            return;
        end

        local now = imcTime.GetAppTime();
        local dif = now - scrolledTime;

        if 2 < dif then
            curPage = curPage + 1;
            GetRaidRanking('RAID_RANKING_INFO_UPDATE', rankCls.ClassName, curPage, TryGetProp(rankCls, 'Order', 'asc'));
            scrolledTime = now
            finishedLoading = false;
        end
    end
end

function RAID_RANKING_CATEGORY_UI_UNFREEZE()
    local frame = ui.GetFrame("induninfo");

    local raidcategoryBox = GET_CHILD_RECURSIVELY(frame, 'raidcategoryBox');
    raidcategoryBox:EnableHitTest(1);    
end

--------------------------------- 레이드 랭킹 ---------------------------------

--------------------------------- 봉쇄전 랭킹 ---------------------------------
function BORUTA_RANKING_UI_OPEN(frame)
    BORUTA_RANKING_DATA_REQUEST();

    local move_btn = GET_CHILD_RECURSIVELY(frame, 'boruta_move_btn')
    if move_btn ~= nil then
        local indunCls = GetClass('GuildEvent', 'GM_BorutosKapas_1')
        if indunCls ~= nil then
            move_btn:SetUserValue('MOVE_INDUN_CLASSID', TryGetProp(indunCls, 'ClassID', 0))
        end
    end

    -- 보스 정보
    local monClsName = 'Guild_boss_Boruta'
    local monCls = GetClass("Monster", monClsName)
    if monCls ~= nil then
        local boss_icon_pic = GET_CHILD_RECURSIVELY(frame, 'boss_icon_pic')
        boss_icon_pic:SetImage(monCls.Icon)
        
        local boss_attr1 = GET_CHILD_RECURSIVELY(frame, "boss_attr1", "ui::CControlSet")
        local boss_attr2 = GET_CHILD_RECURSIVELY(frame, "boss_attr2", "ui::CControlSet")
        local boss_attr3 = GET_CHILD_RECURSIVELY(frame, "boss_attr3", "ui::CControlSet")
        local boss_attr4 = GET_CHILD_RECURSIVELY(frame, "boss_attr4", "ui::CControlSet")
        local boss_attr5 = GET_CHILD_RECURSIVELY(frame, "boss_attr5", "ui::CControlSet")
        local boss_attr6 = GET_CHILD_RECURSIVELY(frame, "boss_attr6", "ui::CControlSet")
        
        SET_TEXT(boss_attr1, "attr_name_text", "value", ScpArgMsg('Name'))
        SET_TEXT(boss_attr2, "attr_name_text", "value", ScpArgMsg('RaceType'))
        SET_TEXT(boss_attr3, "attr_name_text", "value", ScpArgMsg('Attribute'))
        SET_TEXT(boss_attr4, "attr_name_text", "value", ScpArgMsg('MonInfo_ArmorMaterial'))
        SET_TEXT(boss_attr5, "attr_name_text", "value", ScpArgMsg('Level'))
        SET_TEXT(boss_attr6, "attr_name_text", "value", ScpArgMsg('Area'))

        SET_TEXT(boss_attr1, "attr_value_text", "value", monCls.Name)
        SET_TEXT(boss_attr2, "attr_value_text", "value", ScpArgMsg(monCls.RaceType))
        SET_TEXT(boss_attr3, "attr_value_text", "value", ScpArgMsg("MonInfo_Attribute_"..monCls.Attribute))
        SET_TEXT(boss_attr4, "attr_value_text", "value", ScpArgMsg(monCls.ArmorMaterial))
        SET_TEXT(boss_attr5, "attr_value_text", "value", monCls.Level)
        local attr5_value_text = GET_CHILD_RECURSIVELY(boss_attr6,"attr_value_text")
        local mapCls = GetClass("Map", "d_limestonecave_70_1_guild")
        if mapCls ~= nil then
            SET_TEXT(boss_attr6, "attr_value_text", "value", mapCls.Name)
        end
    end
end

function BORUTA_RANKING_SEASON_SELECT(frame,ctrl)

end

function BORUTA_RANKING_DATA_REQUEST()
    local frame = ui.GetFrame("induninfo")
    local ranking_gb = GET_CHILD_RECURSIVELY(frame, "ranking_gb")
    ranking_gb:EnableHitTest(0)
    ReserveScript("HOLD_BORUTA_RANKING_UI_UNFREEZE()", 1)

    local week_num = BORUTA_RANKING_WEEKNUM_NUMBER()
    if week_num < 1 then
        return
    end
    
    -- 시간 정보
    boruta.RequestBorutaStartTime(week_num) -- 시작 시간 정보 요청
    boruta.RequestBorutaEndTime(week_num) -- 종료 시간 정보 요청

    boruta.RequestBorutaRankList(week_num) -- 랭킹 정보 요청
    boruta.RequestBorutaAcceptedRewardInfo(week_num) -- 랭킹 보상 수령 여부 요청
    
    local rankingBox = GET_CHILD_RECURSIVELY(frame, "ranking", "ui::CGroupBox")
    rankingBox:RemoveAllChild()
end

function HOLD_BORUTA_RANKING_UI_UNFREEZE()
    local frame = ui.GetFrame("induninfo")
    local ranking_gb = GET_CHILD_RECURSIVELY(frame, "ranking_gb")
    ranking_gb:EnableHitTest(1)
end

function BORUTA_RANKING_UI_UPDATE()
    local frame = ui.GetFrame("induninfo")
    local guild_info_attr = GET_CHILD_RECURSIVELY(frame, "guild_info_attr", "ui::CControlSet")

    local week_num = BORUTA_RANKING_WEEKNUM_NUMBER()
    local guild_id = 0
    local guild_rank = 0
    local guild_info = GET_MY_GUILD_INFO()
    if guild_info ~= nil then
        guild_id = guild_info.info:GetPartyID()   -- 길드 랭킹 정보
        guild_rank = session.boruta_ranking.GetGuildRank(guild_id)    -- 순위
    end

    if guild_rank > 0 then
        local clear_time_str = session.boruta_ranking.GetRankInfoClearTime(guild_rank - 1)
        local clear_time_ms = tonumber(clear_time_str)
        local clear_hour = math.floor(clear_time_ms / (60 * 60 * 1000))
        local clear_min = math.floor(clear_time_ms / (60 * 1000)) - (clear_hour * 60)
        local clear_sec = math.floor(clear_time_ms / 1000) - ((clear_hour * 60 + clear_min) * 60)
        local clear_ms = math.fmod(clear_time_ms, 1000)
        if clear_ms < 0 then
            clear_ms = 0
        end
        local time_txt = "-"
        if clear_hour > 0 then
            time_txt = string.format("%d:%02d:%02d.%03d", clear_hour, clear_min, clear_sec, clear_ms)
        else
            time_txt = string.format("%02d:%02d.%03d", clear_min, clear_sec, clear_ms)
        end
        
        SET_TEXT(guild_info_attr, "rank_value_text", "rank", guild_rank)
		SET_TEXT(guild_info_attr, "time_value_text", "value", time_txt)
    else
        SET_TEXT(guild_info_attr, "rank_value_text", "rank", "0")
		SET_TEXT(guild_info_attr, "time_value_text", "value", ClMsg("HaveNoClearInfo"))
	end
	--번역 문제 수정
	if config.GetServiceNation() == 'GLOBAL' then
		SET_TEXT(guild_info_attr, "time_text", "value", "Time")
    end
    
    -- 제한 시간
    local starttime = session.boruta_ranking.GetBorutaStartTime()
    local endtime = session.boruta_ranking.GetBorutaEndTime()
    local durtime = imcTime.GetDifSec(endtime, starttime)
    local systime = geTime.GetServerSystemTime()
    local difsec = imcTime.GetDifSec(endtime, systime)

    local gauge = GET_CHILD_RECURSIVELY(frame, "time_gauge", "ui::CGauge")
    local guild_info_time_text = GET_CHILD_RECURSIVELY(frame, "guild_info_time_text", "ui::CRichText")
    
    if 0 < difsec then
        gauge:SetPoint(durtime - difsec, durtime)
        
        local textstr = GET_TIME_TXT(difsec) .. ClMsg("After_Exit")
        guild_info_time_text:SetTextByKey("value", textstr)
        
        guild_info_time_text:SetUserValue("REMAINSEC", difsec)
        guild_info_time_text:SetUserValue("STARTSEC", imcTime.GetAppTime())
        guild_info_time_text:RunUpdateScript("BORUTA_RANKING_REMAIN_END_TIME")
    elseif difsec < 0 then
        gauge:SetPoint(1, 1)
        
        local textstr = ClMsg("Already_Exit_Raid")
        guild_info_time_text:SetTextByKey("value", textstr)
        guild_info_time_text:StopUpdateScript("BORUTA_RANKING_REMAIN_END_TIME")
    end

    local now_week_num = session.boruta_ranking.GetNowWeekNum()
    local reward_btn = GET_CHILD_RECURSIVELY(frame, 'boruta_reward_btn')
    if week_num < now_week_num and guild_rank > 0 and session.boruta_ranking.RewardAccepted(week_num) == 0 then
        reward_btn:SetEnable(1)
    else
        reward_btn:SetEnable(0)
    end

    --시즌 갱신
    BORUTA_RANKING_SEASON_UPDATE()
    -- 랭킹 LIST 갱신
    BORUTA_RANKING_UPDATE()
end

function BORUTA_RANKING_SEASON_UPDATE()
    local weekNum = session.boruta_ranking.GetNowWeekNum()
    local frame = ui.GetFrame("induninfo")
    local tabControl = GET_CHILD_RECURSIVELY(frame, "boruta_season_tab", "ui::CTabControl")
    local cnt = tabControl:GetItemCount()
    for i = 0, cnt - 1 do
        if weekNum - i > 0 then
            tabControl:ChangeCaption(i,"{@st42b}{s16}"..tostring(weekNum - i), false)
        else
            tabControl:ChangeCaption(i,"{@st42b}{s16}-", false)
        end
    end
end

-- 봉쇄전 종료까지 남은시간 표시
function BORUTA_RANKING_REMAIN_END_TIME(ctrl)
	local elapsedSec = imcTime.GetAppTime() - ctrl:GetUserIValue("STARTSEC")
	local startSec = ctrl:GetUserIValue("REMAINSEC")
    startSec = startSec - elapsedSec
	if 0 > startSec then
		ctrl:SetFontName("red_18")
        ctrl:StopUpdateScript("BORUTA_RANKING_REMAIN_END_TIME")
        ctrl:ShowWindow(0)
        return 0
	end 
    
	local timeTxt = GET_TIME_TXT(startSec)
    ctrl:SetTextByKey("value", timeTxt)
    
	return 1
end

-- rank list 
function BORUTA_RANKING_UPDATE()
    local frame = ui.GetFrame("induninfo")
    local rankingBox = GET_CHILD_RECURSIVELY(frame, "ranking", "ui::CGroupBox")
    rankingBox:RemoveAllChild()

    local cnt = session.boruta_ranking.GetRankInfoListSize()
    if cnt == 0 then
        return
    end

    local Width = frame:GetUserConfig("SCROLL_BAR_FALSE_WIDTH")
    
    for i = 1, cnt do
        local ctrlSet = rankingBox:CreateControlSet("boruta_ranking_attribute", "CTRLSET_" .. i, ui.LEFT, ui.TOP, 0, (i - 1) * 73 + 36, 0, 0)
        ctrlSet:Resize(Width, ctrlSet:GetHeight())
        local attr_bg = GET_CHILD(ctrlSet, "attr_bg")
        attr_bg:Resize(Width, attr_bg:GetHeight())

        local rankpic = GET_CHILD(ctrlSet, "attr_rank_pic")
        local attr_rank_text = GET_CHILD(ctrlSet, "attr_rank_text")

        if i <= 3 then
            rankpic:SetImage('raid_week_rank_0'..i)
            rankpic:ShowWindow(1)

            attr_rank_text:ShowWindow(0)
        else
            rankpic:ShowWindow(0)

            attr_rank_text:SetTextByKey("value", i)
            attr_rank_text:ShowWindow(1)
        end

        local clear_time_str = session.boruta_ranking.GetRankInfoClearTime(i - 1)
        local clear_time_ms = tonumber(clear_time_str)
        local clear_hour = math.floor(clear_time_ms / (60 * 60 * 1000))
        local clear_min = math.floor(clear_time_ms / (60 * 1000)) - (clear_hour * 60)
        local clear_sec = math.floor(clear_time_ms / 1000) - ((clear_hour * 60 + clear_min) * 60)
        local clear_ms = math.fmod(clear_time_ms, 1000)
        if clear_ms < 0 then
            clear_ms = 0
        end
        local time_txt = "-"
        if clear_hour > 0 then
            time_txt = string.format("%d:%02d:%02d.%03d", clear_hour, clear_min, clear_sec, clear_ms)
        else
            time_txt = string.format("%02d:%02d.%03d", clear_min, clear_sec, clear_ms)
        end
        local guild_name = session.boruta_ranking.GetRankInfoGuildName(i - 1)
        local guildID = session.boruta_ranking.GetRankInfoGuildID(i - 1)
        if guildID ~= "0" then
            ctrlSet:SetUserValue("GUILD_IDX", guildID)
            GetGuildEmblemImage("BORUTA_RANKING_EMBLEM_IMAGE_SET", guildID)
        end

        local name = GET_CHILD(ctrlSet, "attr_name_text", "ui::CRichText")
        name:SetTextByKey("value", guild_name)

        local value = GET_CHILD(ctrlSet, "attr_value_text", "ui::CRichText")
        value:SetTextByKey("time", time_txt)
    end
end

function BORUTA_RANKING_EMBLEM_IMAGE_SET(code, return_json)
    if code ~= 200 then
        if code == 400 or code == 404 then
            return
        else
            SHOW_GUILD_HTTP_ERROR(code, return_json, "BORUTA_RANKING_EMBLEM_IMAGE_SET")
            return
        end
    end
    
    local guild_idx = return_json
    emblemFolderPath = filefind.GetBinPath("GuildEmblem"):c_str()
    local emblemPath = emblemFolderPath .. "\\" .. guild_idx .. ".png"

    local frame = ui.GetFrame('induninfo')
    local rankListBox = GET_CHILD_RECURSIVELY(frame, "ranking", "ui::CGroupBox")
    for i = 0,rankListBox:GetChildCount()-1 do
        local controlset = rankListBox:GetChildByIndex(i)
        if controlset:GetUserValue("GUILD_IDX") == guild_idx then
            local picture = tolua.cast(controlset:GetChildRecursively("attr_emblem_pic"), "ui::CPicture")
            ui.SetImageByPath(emblemPath, picture)
        end
    end
end

-- 페이지 컨트롤 page
function BORUTA_RANKING_WEEKNUM_NUMBER()
    local frame = ui.GetFrame('induninfo')
    local tabcontrol = GET_CHILD_RECURSIVELY(frame, "boruta_season_tab", "ui::CTabControl")
	if tabcontrol == nil then
		return 0
    end
    
    local tabidx = tabcontrol:GetSelectItemIndex()
	return session.boruta_ranking.GetNowWeekNum() - tabidx
end

-- 보상 버튼 클릭
function BORUTA_RANKING_REWARD_CLICK()
    local week_num = BORUTA_RANKING_WEEKNUM_NUMBER()
    boruta.RequestBorutaReward(week_num)
end

-- 이동하기 버튼 클릭
function BORUTA_ZONE_MOVE_CLICK(parent, ctrl)
    local indunClsID = ctrl:GetUserValue('MOVE_INDUN_CLASSID')
    ui.MsgBox(ClMsg('Auto_JiyeogeuLo{nl}_iDongHaSiKessSeupNiKka?'), '_BORUTA_ZONE_MOVE_CLICK('.. indunClsID ..')', 'None')
end

function _BORUTA_ZONE_MOVE_CLICK(indunClsID)
    local pc = GetMyPCObject()
    
    -- 매칭 던전중이거나 pvp존이면 이용 불가
    if session.world.IsIntegrateServer() == true or IsPVPField(pc) == 1 or IsPVPServer(pc) == 1 then
        ui.SysMsg(ScpArgMsg('ThisLocalUseNot'))
        return
    end

    -- 퀘스트나 챌린지 모드로 인해 레이어 변경되면 이용 불가
    if world.GetLayer() ~= 0 then
        ui.SysMsg(ScpArgMsg('ThisLocalUseNot'))
        return
    end

    -- 프리던전 맵에서 이용 불가
    local curMap = GetClass('Map', session.GetMapName())
    local mapType = TryGetProp(curMap, 'MapType')
    if mapType == 'Dungeon' then
        ui.SysMsg(ScpArgMsg('ThisLocalUseNot'))
        return;
    end

    -- 레이드 지역에서 이용 불가
    local zoneKeyword = TryGetProp(curMap, 'Keyword', 'None')
    local keywordTable = StringSplit(zoneKeyword, ';')
    if table.find(keywordTable, 'IsRaidField') > 0 or table.find(keywordTable, 'WeeklyBossMap') > 0 then
        ui.SysMsg(ScpArgMsg('ThisLocalUseNot'))
        return
    end
    
    control.CustomCommand('MOVE_TO_ENTER_NPC', indunClsID, 1, 0);
end
--------------------------------- 봉쇄전 랭킹 ---------------------------------