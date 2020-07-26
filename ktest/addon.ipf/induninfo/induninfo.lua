-- inuninfo.lua
function INDUNINFO_ON_INIT(addon, frame)
    addon:RegisterMsg('CHAT_INDUN_UI_OPEN', 'INDUNINFO_CHAT_OPEN');
	addon:RegisterMsg('WEEKLY_BOSS_UI_UPDATE', 'WEEKLY_BOSS_UI_UPDATE');

    g_selectedIndunTable = {};
end

g_indunCategoryList = nil;

--[[
    프던 보스 카운트 및 챌린지 모드 정보 표시하려고 추가함
    contents_info.xml 데이터 중에서 ResetGroupID임
    indun.xml의 PlayPerResetType과 중복을 피하기 위해 음수로 추가해보았음
]] 
g_contentsCategoryList = nil

g_weeklyBossCategory = 804

function PUSH_BACK_UNIQUE_INTO_INDUN_CATEGORY_LIST(cateType)
    if g_indunCategoryList == nil then        
        g_indunCategoryList ={100, 10000, 10002, 400, 800, 801, 500};
    end
    for i = 1, #g_indunCategoryList do
        if g_indunCategoryList[i] == cateType then
            return;
        end
    end
    g_indunCategoryList[#g_indunCategoryList + 1] = cateType;
end

function PUSH_BACK_CONTENTS_INFO_CONTENTS_CATEGORY_LIST(cateType)
    if g_contentsCategoryList == nil then
        g_contentsCategoryList = { -100, -200 }
    end

    for i = 1, #g_contentsCategoryList do
        if g_contentsCategoryList[i] == cateType then
            return
        end
    end

    g_contentsCategoryList[#g_contentsCategoryList + 1] = cateType
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

    
    local tab = GET_CHILD_RECURSIVELY(frame, "tab");
	if tab ~= nil then
		tab:SelectTab(0);
	end
    
    INDUNINFO_RESET_USERVALUE(frame);
    INDUNINFO_CREATE_CATEGORY(frame);

    TOGGLE_INDUNINFO(frame,0)
end

function TOGGLE_WEEKLYBOSSINFO(frame, type)
    local WeeklyBossbox = GET_CHILD_RECURSIVELY(frame, 'WeeklyBossbox');
    WeeklyBossbox:ShowWindow(type);

    local contentBox = GET_CHILD_RECURSIVELY(frame, 'contentBox');
    contentBox:ShowWindow(1 - type);
    local categoryBox = GET_CHILD_RECURSIVELY(frame, 'categoryBox');
    categoryBox:ShowWindow(1 - type);
    local bottomBox = GET_CHILD_RECURSIVELY(frame, 'bottomBox');
    bottomBox:ShowWindow(1 - type);
    local raidrankingBox = GET_CHILD_RECURSIVELY(frame, 'raidrankingBox');
    raidrankingBox:ShowWindow(0);
end

function SET_WEEKLYBOSS_INDUN_COUNT(frame)
    local button = GET_CHILD_RECURSIVELY(frame,"joinenter")
    local indunCls = GetClassByNumProp("Indun","PlayPerResetType",g_weeklyBossCategory)
    local acc_obj = GetMyAccountObj()
    button:SetTextByKey('cur', acc_obj['IndunWeeklyEnteredCount_'..g_weeklyBossCategory]);
    button:SetTextByKey('max', indunCls.PlayPerReset);
end

function TOGGLE_INDUNINFO(frame,type)
    TOGGLE_WEEKLYBOSSINFO(frame, 0);

    local indunbox = GET_CHILD_RECURSIVELY(frame,'indunbox')
    indunbox:ShowWindow(1 - type)
    local lvAscendRadio = GET_CHILD_RECURSIVELY(frame,'lvAscendRadio')
    lvAscendRadio:ShowWindow(1 - type)
    local lvDescendRadio = GET_CHILD_RECURSIVELY(frame,'lvDescendRadio')
    lvDescendRadio:ShowWindow(1 - type)
    local raidrankingBox = GET_CHILD_RECURSIVELY(frame, 'raidrankingBox');
    raidrankingBox:ShowWindow(0);
    if type == 1 then
        local resetInfoText = GET_CHILD_RECURSIVELY(frame, 'resetInfoText'); 
        resetInfoText:ShowWindow(0)
        local resetInfoText_Week = GET_CHILD_RECURSIVELY(frame, 'resetInfoText_Week');
        resetInfoText_Week:ShowWindow(0)
    end
end

function INDUNINFO_UI_CLOSE(frame)
    INDUNMAPINFO_UI_CLOSE();
    ui.CloseFrame('induninfo');
    ui.CloseFrame('indun_char_status');
    ui.CloseFrame('weeklyboss_patterninfo');
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
    local missionIndunAdded = false;
    local indunClsList, cnt = GetClassList('Indun');
    for i = 0, cnt - 1 do
        local indunCls = GetClassByIndexFromList(indunClsList, i);
        if indunCls ~= nil then            
            local resetGroupID = indunCls.PlayPerResetType;
            local category = indunCls.Category;
            local categoryCtrl = categoryBox:GetChild('CATEGORY_CTRL_'..resetGroupID);
            if categoryCtrl == nil and category ~= 'None' then
                PUSH_BACK_UNIQUE_INTO_INDUN_CATEGORY_LIST(resetGroupID);

                resetGroupTable[resetGroupID] = 1;
                categoryCtrl = categoryBox:CreateOrGetControlSet('indun_cate_ctrl', 'CATEGORY_CTRL_'..resetGroupID, 0, i * 50);

                local name = categoryCtrl:GetChild("name");
                local btn = categoryCtrl:GetChild("button");
                local countText = categoryCtrl:GetChild('countText');
                local cyclePicImg = GET_CHILD_RECURSIVELY(categoryCtrl, 'cycleCtrlPic')   --주/일 표시 이미지

                btn:Resize(categoryBtnWidth, categoryCtrl:GetHeight());
                name:SetTextByKey("value", category);
                countText:SetTextByKey('current', GET_CURRENT_ENTERANCE_COUNT(resetGroupID));
                countText:SetTextByKey('max', GET_MAX_ENTERANCE_COUNT(resetGroupID));
                if GET_RESET_CYCLE(resetGroupID) == true then
                    cyclePicImg:SetImage(GET_INDUN_ICON_NAME('week_s'))
                else
                    if indunCls.DungeonType == "Raid" or indunCls.DungeonType == "GTower" then
                        cyclePicImg:ShowWindow(0);
                    else
                        cyclePicImg:SetImage(GET_INDUN_ICON_NAME('day_s'))
                    end
                end

                --유니크 레이드의 경우 cyclePic을 숨긴다
                if indunCls.DungeonType == 'UniqueRaid' then

                    local pc = GetMyPCObject()
                    if IsBuffApplied(pc, "Event_Unique_Raid_Bonus") == "YES" then
--                    if SCR_RAID_EVENT_20190102(nil, false) then
                        cyclePicImg:SetImage(GET_INDUN_ICON_NAME('event_s'))
                        local margin = cyclePicImg:GetOriginalMargin();
                        cyclePicImg:SetMargin(margin.left, margin.top, margin.right - 6, margin.bottom);
                        cyclePicImg:Resize(cyclePicImg:GetOriginalWidth() + 11, cyclePicImg:GetOriginalHeight());
                    elseif IsBuffApplied(pc, "Event_Unique_Raid_Bonus_Limit") == "YES" then
                        local accountObject = GetMyAccountObj(pc)
                        if TryGetProp(accountObject ,"EVENT_UNIQUE_RAID_BONUS_LIMIT") > 0 then
                            cyclePicImg:SetImage(GET_INDUN_ICON_NAME('event_s'))
                            local margin = cyclePicImg:GetOriginalMargin();
                            cyclePicImg:SetMargin(margin.left, margin.top, margin.right - 6, margin.bottom);
                            cyclePicImg:Resize(cyclePicImg:GetOriginalWidth() + 11, cyclePicImg:GetOriginalHeight());
                        else
                            cyclePicImg:ShowWindow(0);
                        end
                    else
                        cyclePicImg:ShowWindow(0);
                    end
                end

                if indunCls.DungeonType == "Event" then
                    cyclePicImg:SetImage(GET_INDUN_ICON_NAME('event_s'))

                    local margin = cyclePicImg:GetOriginalMargin()
                    cyclePicImg:SetMargin(margin.left, margin.top, margin.right - 6, margin.bottom)
                    cyclePicImg:Resize(cyclePicImg:GetOriginalWidth() + 11, cyclePicImg:GetOriginalHeight())
                end

                categoryCtrl:SetUserValue('RESET_GROUP_ID', resetGroupID);
                if firstBtn == nil then -- 디폴트는 첫번째가 클릭되게 함
                    firstBtn = btn;
                end

                if indunCls.DungeonType == 'MissionIndun' then
                    missionIndunAdded = true;
                end
            elseif categoryCtrl ~= nil and category ~= 'None' then
                local add_flag = true;
                if indunCls.DungeonType == 'MissionIndun' and missionIndunAdded == true then
                    add_flag = false;
                end

                if add_flag == true then
                    resetGroupTable[resetGroupID] = resetGroupTable[resetGroupID] + 1;

                    if indunCls.DungeonType == 'MissionIndun' then
                        missionIndunAdded = true;
                    end
                end
            end
        end
    end

    -- 인던 외 컨텐츠 표시를 일단 인던과 같이 하는데, 나중에 탭 형식으로 변경 필요함
    local contentsClsList, count = GetClassList('contents_info')
    for i = 0, count - 1 do
        local contentsCls = GetClassByIndexFromList(contentsClsList, i)
        if contentsCls ~= nil then
            local resetGroupID = contentsCls.ResetGroupID
            local category = contentsCls.Category
            local categoryCtrl = categoryBox:GetChild('CATEGORY_CTRL_'..resetGroupID)
            if categoryCtrl == nil and category ~= 'None' then
                PUSH_BACK_CONTENTS_INFO_CONTENTS_CATEGORY_LIST(resetGroupID);
                resetGroupTable[resetGroupID] = 1;
                categoryCtrl = categoryBox:CreateOrGetControlSet('indun_cate_ctrl', 'CATEGORY_CTRL_'..resetGroupID, 0, i * 50);

                local name = categoryCtrl:GetChild("name");
                local btn = categoryCtrl:GetChild("button");
                local countText = categoryCtrl:GetChild('countText');
                local cyclePicImg = GET_CHILD_RECURSIVELY(categoryCtrl, 'cycleCtrlPic')   --주/일 표시 이미지

                btn:Resize(categoryBtnWidth, categoryCtrl:GetHeight());
                name:SetTextByKey("value", category);
                countText:SetTextByKey('current', GET_CURRENT_ENTERANCE_COUNT(resetGroupID));
                countText:SetTextByKey('max', GET_MAX_ENTERANCE_COUNT(resetGroupID));
                if contentsCls.ResetPer == 'WEEK' then
                    cyclePicImg:SetImage(GET_INDUN_ICON_NAME('week_s'))
                elseif contentsCls.ResetPer == 'DAY' then
                    cyclePicImg:SetImage(GET_INDUN_ICON_NAME('day_s'))
                else
                    cyclePicImg:ShowWindow(0);
                end

                categoryCtrl:SetUserValue('RESET_GROUP_ID', resetGroupID);
                if firstBtn == nil then -- 디폴트는 첫번째가 클릭되게 함
                    firstBtn = btn;
                end
            elseif categoryCtrl ~= nil and category ~= 'None' then
                resetGroupTable[resetGroupID] = resetGroupTable[resetGroupID] + 1;
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

function INDUNINFO_CATEGORY_LBTN_CLICK(categoryCtrl, ctrl)
    -- set button skin
    local topFrame = categoryCtrl:GetTopParentFrame();
    local preSelectType = topFrame:GetUserIValue('SELECT');
    local selectedResetGroupID = categoryCtrl:GetUserIValue('RESET_GROUP_ID');
    if preSelectType == selectedResetGroupID then
        return;
    end

    categoryCtrl = tolua.cast(categoryCtrl, 'ui::CControlSet');
    local SELECTED_BTN_SKIN = categoryCtrl:GetUserConfig('SELECTED_BTN_SKIN');
    local NOT_SELECTED_BTN_SKIN = categoryCtrl:GetUserConfig('NOT_SELECTED_BTN_SKIN');
    local preSelect = GET_CHILD_RECURSIVELY(topFrame, "CATEGORY_CTRL_" .. preSelectType);
    if nil ~= preSelect then
        local button = preSelect:GetChild("button");
        button:SetSkinName(NOT_SELECTED_BTN_SKIN);
    end
    topFrame:SetUserValue('SELECT', selectedResetGroupID);    
    ctrl:SetSkinName(SELECTED_BTN_SKIN);

    -- make indunlist
    local categoryBox = GET_CHILD_RECURSIVELY(topFrame, 'categoryBox');
    local listBoxWidth = categoryBox:GetWidth() - SCROLL_WIDTH;
    categoryBox:RemoveChild('INDUN_LIST_BOX');
    g_selectedIndunTable = {};
        
    local indunListBox = categoryBox:CreateControl('groupbox', 'INDUN_LIST_BOX', 5, 0, listBoxWidth, 30);
    indunListBox = tolua.cast(indunListBox, 'ui::CGroupBox');
    indunListBox:EnableDrawFrame(0);
    indunListBox:EnableScrollBar(0);

    if selectedResetGroupID < 0 then
        local contentsClsList, count = GetClassList('contents_info')
        local showCnt = 0
        for i = 0, count - 1 do
            local contentsCls = GetClassByIndexFromList(contentsClsList, i)
            if contentsCls ~= nil and contentsCls.ResetGroupID == selectedResetGroupID and contentsCls.Category ~= 'None' then
                local indunDetailCtrl = indunListBox:CreateOrGetControlSet('indun_detail_ctrl', 'DETAIL_CTRL_' .. contentsCls.ClassID, 0, 0);
                indunDetailCtrl = tolua.cast(indunDetailCtrl, 'ui::CControlSet');
                indunDetailCtrl:SetUserValue('INDUN_CLASS_ID', contentsCls.ClassID);
                indunDetailCtrl:SetEventScript(ui.LBUTTONUP, 'INDUNINFO_DETAIL_LBTN_CLICK');
        
                local infoText = indunDetailCtrl:GetChild('infoText');
                local nameText = indunDetailCtrl:GetChild('nameText');
                indunDetailCtrl:RemoveChild('onlinePic')
                
                infoText:SetTextByKey('level', contentsCls.Level);
                nameText:SetTextByKey('name', contentsCls.Name);
                if showCnt == 0 then -- 디폴트는 리스트의 첫번째
                    indunListBox:SetUserValue('FIRST_INDUN_ID', contentsCls.ClassID)
                    INDUNINFO_DETAIL_LBTN_CLICK(indunListBox, indunDetailCtrl);
                end
                showCnt = showCnt + 1;
                g_selectedIndunTable[showCnt] = contentsCls;
                -- 주간 입장 텍스트 설정
                local resetInfoText = GET_CHILD_RECURSIVELY(topFrame, 'resetInfoText');             --"입장 횟수는 매일 %s시에 초기화 됩니다."
                local resetInfoText_Week = GET_CHILD_RECURSIVELY(topFrame, 'resetInfoText_Week');   --"입장 횟수는 매주 월요일 %s시에 초기화 됩니다."
        
                local resetTime = INDUN_RESET_TIME % 12;
                local ampm = ClMsg('AM');
                if INDUN_RESET_TIME > 12 then
                    ampm = ClMsg('PM');
                end
        
                --주간 입장인지, 일간 입장인지
                if contentsCls.ResetPer == 'WEEK' then
                    --주간
                    local resetText_wkeely = string.format('%s %s', ampm, resetTime);
                    resetInfoText_Week:SetTextByKey('resetTime', resetText_wkeely);
                    resetInfoText:ShowWindow(0);
                    resetInfoText_Week:ShowWindow(1);
                elseif contentsCls.ResetPer == 'DAY' then
                    --일간
                    local resetText = string.format('%s %s', ampm, resetTime);
                    resetInfoText:SetTextByKey('resetTime', resetText);
                    resetInfoText_Week:ShowWindow(0);
                    resetInfoText:ShowWindow(1);
                end
            end
        end
    else
        local indunClsList, cnt = GetClassList('Indun');    
        local showCnt = 0;
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
                local indunDetailCtrl = indunListBox:CreateOrGetControlSet('indun_detail_ctrl', 'DETAIL_CTRL_'..indunCls.ClassID, 0, 0);
                indunDetailCtrl = tolua.cast(indunDetailCtrl, 'ui::CControlSet');
                indunDetailCtrl:SetUserValue('INDUN_CLASS_ID', indunCls.ClassID);
                indunDetailCtrl:SetEventScript(ui.LBUTTONUP, 'INDUNINFO_DETAIL_LBTN_CLICK');

                local infoText = indunDetailCtrl:GetChild('infoText');
                local nameText = indunDetailCtrl:GetChild('nameText');
                
                infoText:SetTextByKey('level', indunCls.Level);
                nameText:SetTextByKey('name', indunCls.Name);                
                if showCnt == 0 then -- 디폴트는 리스트의 첫번째
                    indunListBox:SetUserValue('FIRST_INDUN_ID', indunCls.ClassID)
                    INDUNINFO_DETAIL_LBTN_CLICK(indunListBox, indunDetailCtrl);
                end
                showCnt = showCnt + 1;
                g_selectedIndunTable[showCnt] = indunCls;
                -- 주간 입장 텍스트 설정
                local resetInfoText = GET_CHILD_RECURSIVELY(topFrame, 'resetInfoText');             --"입장 횟수는 매일 %s시에 초기화 됩니다."
                local resetInfoText_Week = GET_CHILD_RECURSIVELY(topFrame, 'resetInfoText_Week');   --"입장 횟수는 매주 월요일 %s시에 초기화 됩니다."

                local resetTime = INDUN_RESET_TIME % 12;
                local ampm = ClMsg('AM');
                if indunCls.DungeonType == "Event" then     
                    if indunCls.ResetTime > 12 then
                        ampm = ClMsg('PM');
                    end
                    resetTime = indunCls.ResetTime % 12;
                else
                    if INDUN_RESET_TIME > 12 then
                        ampm = ClMsg('PM');
                    end
                end

                --주간 입장인지, 일간 입장인지 
                if indunCls.WeeklyEnterableCount ~= nil then
                    if indunCls.WeeklyEnterableCount ~= 0 and indunCls.WeeklyEnterableCount > 0 then    --주간
                        local resetText_wkeely = string.format('%s %s', ampm, resetTime);
                        resetInfoText_Week:SetTextByKey('resetTime', resetText_wkeely);
                        resetInfoText:ShowWindow(0);
                        resetInfoText_Week:ShowWindow(1);
                    else    --일간
                        local resetText = string.format('%s %s', ampm, resetTime);
                        resetInfoText:SetTextByKey('resetTime', resetText);
                        resetInfoText_Week:ShowWindow(0);
                        resetInfoText:ShowWindow(1);
                    end
                end
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

function GET_MAX_ENTERANCE_COUNT(resetGroupID)
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

        return contentsCls.EnterableCount
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
        
        local bonusCount = 0;
        -- local isTokenState = session.loginInfo.IsPremiumState(ITEM_TOKEN);    
        -- if isTokenState == true then
        --     bonusCount = indunCls.PlayPerReset_Token
        -- end
        --bonus는 빼버려도 될듯
        if indunCls.WeeklyEnterableCount ~= nil and indunCls.WeeklyEnterableCount ~= "None" and indunCls.WeeklyEnterableCount ~= 0 then
            return indunCls.WeeklyEnterableCount + bonusCount;  --매주 max
        else
            return indunCls.PlayPerReset + bonusCount;          --매일 max
        end
    end
end

function GET_RESET_CYCLE(resetGroupID)
    local etc = GetMyEtcObject();
    if etc == nil then
        return 0;
    end
    
    local isWeekCycle = false;  --주단위로 리셋되면 true, 일단위로 리셋되면 false

    if resetGroupID < 0 then
        local contentsClsList, count = GetClassList('contents_info')
        local contentsCls = nil
        for i = 0, cnt - 1 do
            contentsCls = GetClassByIndexFromList(contentsClsList, i)
            if contentsCls ~= nil and contentsCls.ResetGroupID == resetGroupID and contentsCls.Category ~= 'None' then
                break
            end
        end

        if contentsCls.ResetPer == 'WEEK' then
            isWeekCycle = true
        else
            isWeekCycle = false
        end
    else
        local indunClsList, cnt = GetClassList('Indun');
        local indunCls = nil;
        for i = 0, cnt - 1 do
            indunCls = GetClassByIndexFromList(indunClsList, i);
            if indunCls ~= nil and indunCls.PlayPerResetType == resetGroupID and indunCls.Category ~= 'None' then
                break;
            end
        end

        if indunCls.UnitPerReset == 'ACCOUNT' then
            etc = GetMyAccountObj()
        end
        
        local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
        
        if indunCls.WeeklyEnterableCount ~= nil and indunCls.WeeklyEnterableCount ~= "None" and indunCls.WeeklyEnterableCount ~= 0 then
            nowCount = TryGetProp(etc, "IndunWeeklyEnteredCount_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
            if indunCls.DungeonType == "Raid" or indunCls.DungeonType == "GTower" then
                if nowCount < indunCls.WeeklyEnterableCount then
                    isWeekCycle = true;
                else
                    isWeekCycle = false;
                end
            else
            --return 'token_on'   --횟수가 매주 리셋되는 던전
            isWeekCycle = true;
            end
        else
            --return 'token_off'  --횟수가 매일 리셋되는 던전
            isWeekCycle = false;
        end
    end
    return isWeekCycle;
end

function GET_INDUN_ICON_NAME(name)
    name = 'indun_icon_'..name
    if config.GetServiceNation() ~= 'KOR' then
        name = name..'_eng'
    end
    return name
end

function INDUNINFO_DETAIL_LBTN_CLICK(parent, detailCtrl)
    local indunClassID = detailCtrl:GetUserIValue('INDUN_CLASS_ID');
    local preSelectedDetail = parent:GetUserIValue('SELECTED_DETAIL');
    if indunClassID == preSelectedDetail then
        return;
    end
    
    -- set skin
    local SELECTED_BOX_SKIN = detailCtrl:GetUserConfig('SELECTED_BOX_SKIN');
    local NOT_SELECTED_BOX_SKIN = detailCtrl:GetUserConfig('NOT_SELECTED_BOX_SKIN');    
    local preSelectedCtrl = parent:GetChild('DETAIL_CTRL_'..preSelectedDetail);
    if preSelectedCtrl ~= nil then
        local preSkinBox = GET_CHILD(preSelectedCtrl, 'skinBox');
        if preSkinBox:GetUserValue('DEFAULT_SKIN_2') == 'YES' then
            preSkinBox:SetSkinName(NOT_SELECTED_BOX_SKIN);
        else
            preSkinBox:SetSkinName('None');
        end
    end
    local skinBox = GET_CHILD(detailCtrl, 'skinBox');
    skinBox:SetSkinName(SELECTED_BOX_SKIN);
    parent:SetUserValue('SELECTED_DETAIL', indunClassID);
    
    local topFrame = parent:GetTopParentFrame();
    
    -- 인스턴스 던전 정보 처리를 위한 임시 처리 시작 --
    -- INDUNINFO_DROPBOX_ITEM_LIST 에서 parent의 SELECTED_DETAIL 값을 불러올 수 있도록 같은 프레임을 호출하도록 변경해야 함 --
    local categoryBox = GET_CHILD_RECURSIVELY(topFrame,'categoryBox')
    local indunListBox = GET_CHILD_RECURSIVELY(categoryBox, 'INDUN_LIST_BOX');
    indunListBox:SetUserValue('SELECTED_DETAIL', indunClassID);
    -- 인스턴스 던전 정보 처리를 위한 임시 처리 끝 --
    
    local resetGroupID = topFrame:GetUserIValue('SELECT')
    if resetGroupID < 0 then
        INDUNINFO_MAKE_DETAIL_INFO_BOX_OTHER(topFrame, indunClassID)
    else
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
    local etc = GetMyEtcObject();
    if indunCls == nil or etc == nil then
        return;
    end

    -- name
    local nameBox = GET_CHILD_RECURSIVELY(frame, 'nameBox');
    local nameText = nameBox:GetChild('nameText');    
    nameText:SetTextByKey('name', indunCls.Name);
    
    -- picture
    local indunPic = GET_CHILD_RECURSIVELY(frame, 'indunPic');
    indunPic:SetImage(indunCls.MapImage);

    -- count
    local countData = GET_CHILD_RECURSIVELY(frame, 'countData');
    local cycleImage = GET_CHILD_RECURSIVELY(frame, 'cyclePic');

    -- skill restriction
    local restrictBox = GET_CHILD_RECURSIVELY(frame, 'restrictBox');
    restrictBox:ShowWindow(0);

    local mapName = TryGetProp(indunCls, "MapName");
    local dungeonType = TryGetProp(indunCls, "DungeonType");
    local isLegendRaid = 0;
    if dungeonType == "Raid" or dungeonType == "GTower" then
        isLegendRaid = 1;
    end

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
    
    -- local tokenStatePic = GET_CHILD_RECURSIVELY(frame, 'tokenStatePic');
    local resetGroupID = indunCls.PlayPerResetType;    
    -- local isTokenState = session.loginInfo.IsPremiumState(ITEM_TOKEN);
    -- local TOKEN_STATE_IMAGE = frame:GetUserConfig('TOKEN_STATE_IMAGE');
    -- local NOT_TOKEN_STATE_IMAGE = frame:GetUserConfig('NOT_TOKEN_STATE_IMAGE');
    
    local countItemData = GET_CHILD_RECURSIVELY(frame, 'countItemData');
    local admissionItemName = TryGetProp(indunCls, "AdmissionItemName");
    local admissionItemCount = TryGetProp(indunCls, "AdmissionItemCount");
    local admissionPlayAddItemCount = TryGetProp(indunCls, "AdmissionPlayAddItemCount");
    local admissionItemCls = GetClass('Item', admissionItemName);
    local admissionItemIcon = TryGetProp(admissionItemCls, "Icon");
    local indunAdmissionItemImage = admissionItemIcon
    local etc = GetMyEtcObject();
    local nowCount = TryGetProp(etc, "InDunCountType_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
    local addCount = math.floor(nowCount * admissionPlayAddItemCount);

    if admissionItemCount == nil then
        admissionItemCount = 0;
    end

    admissionItemCount = math.floor(admissionItemCount);
    
    if indunCls.UnitPerReset == 'ACCOUNT' then
        etc = GetMyAccountObj()
    end
    
    if indunCls.WeeklyEnterableCount ~= 0 then
        nowCount = TryGetProp(etc, "IndunWeeklyEnteredCount_"..tostring(TryGetProp(indunCls, "PlayPerResetType")));
        addCount = math.floor((nowCount - indunCls.WeeklyEnterableCount) * admissionPlayAddItemCount);
        if addCount < 0 then
            addCount = 0;
        end
    end

    if admissionItemName == "None" or admissionItemName == nil then
        -- if isTokenState == true then
        --     tokenStatePic:SetImage(TOKEN_STATE_IMAGE);
        --     tokenStatePic:SetTextTooltip(ScpArgMsg('YouCanMorePlayIndunWithToken', 'COUNT', indunCls.PlayPerReset_Token, 'TOKEN_STATE', ClMsg('Auto_HwalSeong')));
        -- else
        --     tokenStatePic:SetImage(NOT_TOKEN_STATE_IMAGE);
        --     tokenStatePic:SetTextTooltip(ScpArgMsg('YouCanMorePlayIndunWithToken', 'COUNT', indunCls.PlayPerReset_Token, 'TOKEN_STATE', ClMsg('NotApplied')));
        -- end

        countData:SetTextByKey('now', GET_CURRENT_ENTERANCE_COUNT(resetGroupID));
        countData:SetTextByKey('max', GET_MAX_ENTERANCE_COUNT(resetGroupID));

        if dungeonType == 'MissionIndun' then
            -- 로테이션식 레벨던전은 해당 요일을 표시한다
            -- 이미 세부카테고리에서 해당 요일 로테이션 던전만 표시하도록 해놔서, 여기에선 요일별 처리를 해줄 필요는 없다
            local sysTime = geTime.GetServerSystemTime();
            local dayOfWeekStr = string.lower(GET_DAYOFWEEK_STR(sysTime.wDayOfWeek));
            cycleImage:SetImage(GET_INDUN_ICON_NAME(dayOfWeekStr))
            cycleImage:ShowWindow(1);
        elseif GET_RESET_CYCLE(resetGroupID) == true then
            cycleImage:SetImage(GET_INDUN_ICON_NAME('week_l'))
            cycleImage:ShowWindow(1);
        else
            if indunCls.DungeonType == "Raid" or indunCls.DungeonType == "GTower" then
                cycleImage:ShowWindow(0);
            else
                cycleImage:SetImage(GET_INDUN_ICON_NAME('day_l'));
                cycleImage:ShowWindow(1);
            end
        end

        local countBox = GET_CHILD_RECURSIVELY(frame, 'countBox');
        local countText = GET_CHILD_RECURSIVELY(countBox, 'countText');
        local cycleCtrlPic = GET_CHILD_RECURSIVELY(countBox, 'cycleCtrlPic');

        countText:SetText(ScpArgMsg("IndunAdmissionItemReset"))
        countData:ShowWindow(1);
        countItemData:ShowWindow(0);
        cycleCtrlPic:ShowWindow(0);

        if indunCls.DungeonType == "Event" then
            cycleImage:SetImage(GET_INDUN_ICON_NAME('event_l'))
            cycleImage:ShowWindow(1)
        end
    

    else
        -- if isTokenState == true then
        --     isTokenState = TryGetProp(indunCls, "PlayPerReset_Token")
        --     tokenStatePic:SetImage(TOKEN_STATE_IMAGE);
        --     tokenStatePic:SetTextTooltip(ScpArgMsg('YouCanLittleIndunAdmissionItemWithToken', 'COUNT', indunCls.PlayPerReset_Token, 'TOKEN_STATE', ClMsg('Auto_HwalSeong')));
        -- else
        --     isTokenState = 0
        --     tokenStatePic:SetImage(NOT_TOKEN_STATE_IMAGE);
        --     tokenStatePic:SetTextTooltip(ScpArgMsg('YouCanLittleIndunAdmissionItemWithToken', 'COUNT', indunCls.PlayPerReset_Token, 'TOKEN_STATE', ClMsg('NotApplied')));
        -- end
        -- local nowAdmissionItemCount = admissionItemCount + addCount - isTokenState

        local nowAdmissionItemCount = admissionItemCount

--        if SCR_RAID_EVENT_20190102(nil, false) == true and admissionItemName == 'Dungeon_Key01' then
        local pc = GetMyPCObject()
        if IsBuffApplied(pc,"Event_Steam_New_World_Buff") == "YES" and admissionItemName == "Dungeon_Key01" then
            nowAdmissionItemCount = 1
        elseif IsBuffApplied(pc, "Event_Unique_Raid_Bonus") == "YES" and admissionItemName == "Dungeon_Key01" then
            nowAdmissionItemCount  = admissionItemCount
        elseif IsBuffApplied(pc, "Event_Unique_Raid_Bonus_Limit") == "YES" and admissionItemName == "Dungeon_Key01" then
            local accountObject = GetMyAccountObj(pc)
            if TryGetProp(accountObject,"EVENT_UNIQUE_RAID_BONUS_LIMIT") > 0 then
                nowAdmissionItemCount  = admissionItemCount
            else
                nowAdmissionItemCount  = admissionItemCount + addCount
            end
        else
            nowAdmissionItemCount  = admissionItemCount + addCount
        end

        countItemData:SetTextByKey('admissionitem', '  {img '..indunAdmissionItemImage..' 30 30}  '..nowAdmissionItemCount..'')

        local countBox = GET_CHILD_RECURSIVELY(frame, 'countBox');
        local countText = GET_CHILD_RECURSIVELY(countBox, 'countText');
        local cycleCtrlPic = GET_CHILD_RECURSIVELY(countBox, 'cycleCtrlPic');

        if GET_RESET_CYCLE(resetGroupID) == true then
            cycleImage:SetImage(GET_INDUN_ICON_NAME('week_l'))
            cycleImage:ShowWindow(1);
        else
            if indunCls.DungeonType == "Raid" or indunCls.DungeonType == "GTower" then
                cycleImage:ShowWindow(0);
            else
                cycleImage:SetImage(GET_INDUN_ICON_NAME('day_l'))
                cycleImage:ShowWindow(1);
            end
        end

        if indunCls.DungeonType == "Raid" or indunCls.DungeonType == "GTower" then
            if indunCls.WeeklyEnterableCount > nowCount then
                countText:SetText(ScpArgMsg("IndunAdmissionItemReset"))
                cycleCtrlPic:ShowWindow(0);

                countData:SetTextByKey('now', nowCount);
                countData:SetTextByKey('max', indunCls.WeeklyEnterableCount);

                countData:ShowWindow(1);
                countItemData:ShowWindow(0);
            else
                countText:SetText(ScpArgMsg("IndunAdmissionItem"))
                cycleCtrlPic:ShowWindow(0);

                countData:ShowWindow(0);
                countItemData:ShowWindow(1);
            end
        else
            countText:SetText(ScpArgMsg("IndunAdmissionItem"))
            cycleCtrlPic:ShowWindow(0);

            countData:ShowWindow(0);
            countItemData:ShowWindow(1);
        end
        
        if indunCls.DungeonType == 'UniqueRaid' then
--            if SCR_RAID_EVENT_20190102(nil, false) and admissionItemName == 'Dungeon_Key01' then -- 별의 탑 폐쇄 구역 제외 조건 걸어주기
            if IsBuffApplied(pc, "Event_Unique_Raid_Bonus") == "YES" and admissionItemName == "Dungeon_Key01" then
                cycleCtrlPic:SetImage(GET_INDUN_ICON_NAME('event_l'))
                cycleCtrlPic:ShowWindow(1);
            elseif IsBuffApplied(pc, "Event_Unique_Raid_Bonus_Limit") == "YES" and admissionItemName == "Dungeon_Key01" then
                local accountObject = GetMyAccountObj(pc)
                if TryGetProp(accountObject,"EVENT_UNIQUE_RAID_BONUS_LIMIT") > 0 then
                    cycleCtrlPic:SetImage(GET_INDUN_ICON_NAME('event_l'))
                    cycleCtrlPic:ShowWindow(1);
                end
            end
        
            cycleImage:ShowWindow(0);
        end

        if indunCls.DungeonType == "Event" then
            cycleCtrlPic:SetImage(GET_INDUN_ICON_NAME('event_l'))
            cycleCtrlPic:ShowWindow(1)
        end

--        if indunCls.MGame == 'MISSION_EVENT_BLUEORB' then
--            local isTokenState = session.loginInfo.IsPremiumState(ITEM_TOKEN);
--            if isTokenState == true then
--                isTokenStateCount = TryGetProp(indunCls, "PlayPerReset_Token");
--                nowAdmissionItemCount = nowAdmissionItemCount - isTokenStateCount
--            end
--            countItemData:SetTextByKey('admissionitem', '  {img '..indunAdmissionItemImage..' 30 30}  '..nowAdmissionItemCount..'')
--            cycleImage:ShowWindow(0);
--        end
    end    

    -- level
    local lvData = GET_CHILD_RECURSIVELY(frame, 'lvData');
    lvData:SetText(indunCls.Level);

    -- star
--    local starData = GET_CHILD_RECURSIVELY(frame, 'starData');
--    local STAR_IMAGE = frame:GetUserConfig('STAR_IMAGE');
--    local starText = '';
--    local numStar = (indunCls.Level - 1) / 100;
--    for i = 0, numStar do
--        starText = starText .. string.format('{img %s %d %d}', STAR_IMAGE, 20, 20);
--    end
--    starData:SetText(starText);

    -- map
    local posBox = GET_CHILD_RECURSIVELY(frame, 'posBox');
    local monBox = GET_CHILD_RECURSIVELY(frame, 'monBox');
    local rewardBox = GET_CHILD_RECURSIVELY(frame, 'rewardBox');
    local resizeHeight = tonumber(frame:GetUserConfig('HEIGHT_RESIZE_FOR_BUTTON'));
    local originHeight = tonumber(frame:GetUserConfig('POSBOX_ORIGIN_HEIGHT'));
    local mon_origin_top = tonumber(frame:GetUserConfig('MON_ORIGIN_TOP'));
    local reward_origin_top = tonumber(frame:GetUserConfig('REWARD_ORIGIN_TOP'));
    local moveBox = GET_CHILD_RECURSIVELY(frame, 'moveBox');

    if TryGetProp(indunCls, 'DungeonType') == 'UniqueRaid' then
        if posBox:GetHeight() == originHeight then
            posBox:Resize(posBox:GetWidth(), posBox:GetHeight() - resizeHeight);
        end
        local mon_margin = monBox:GetMargin();
        
        if mon_margin.top == mon_origin_top then
            monBox:SetMargin(mon_margin.left, mon_margin.top - resizeHeight, mon_margin.right, mon_margin.bottom);
        end
        local reward_margin = rewardBox:GetMargin();
        
        if reward_margin.top == reward_origin_top then
            rewardBox:SetMargin(reward_margin.left, reward_margin.top - resizeHeight, reward_margin.right, reward_margin.bottom);
        end

        moveBox:ShowWindow(1);
        local moveBtn = GET_CHILD_RECURSIVELY(moveBox, 'moveBtn');
        if config.GetServiceNation() == 'GLOBAL' then
            moveBtn:SetTextByKey('btnText', 'Warp')
        end
        moveBtn:SetUserValue('MOVE_INDUN_CLASSID', indunCls.ClassID);
    else
        if posBox:GetHeight() ~= originHeight then
            posBox:Resize(posBox:GetWidth(), originHeight);
        end

        local mon_margin = monBox:GetMargin();
        if mon_margin.top ~= mon_origin_top then
            monBox:SetMargin(mon_margin.left, mon_origin_top, mon_margin.right, mon_margin.bottom);
        end

        local reward_margin = rewardBox:GetMargin();
        if reward_margin.top ~= reward_origin_top then
            rewardBox:SetMargin(reward_margin.left, reward_origin_top, reward_margin.right, reward_margin.bottom);
        end

        moveBox:ShowWindow(0);
    end

    DESTROY_CHILD_BYNAME(posBox, 'MAP_CTRL_');
    local mapList = StringSplit(indunCls.StartMap, '/');
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

    INDUNENTER_MAKE_MONLIST(frame, indunCls);
end

function INDUNINFO_MAKE_DETAIL_INFO_BOX_OTHER(frame, indunClassID)
    local contentsCls = GetClassByType('contents_info', indunClassID)
    if contentsCls == nil then
        return;
    end

    local etc = GetMyEtcObject();
    if contentsCls.UnitPerReset == 'ACCOUNT' then
        etc = GetMyAccountObj()
    end

    if etc == nil then
        return
    end

    -- name
    local nameBox = GET_CHILD_RECURSIVELY(frame, 'nameBox');
    local nameText = nameBox:GetChild('nameText');    
    nameText:SetTextByKey('name', contentsCls.Name);
    
    -- picture
    local indunPic = GET_CHILD_RECURSIVELY(frame, 'indunPic');
    indunPic:SetImage(contentsCls.MapImage)

    -- count
    local countData = GET_CHILD_RECURSIVELY(frame, 'countData');
    local cycleImage = GET_CHILD_RECURSIVELY(frame, 'cyclePic');

    -- skill restriction
    local restrictBox = GET_CHILD_RECURSIVELY(frame, 'restrictBox');
    restrictBox:ShowWindow(0);
    
    local countItemData = GET_CHILD_RECURSIVELY(frame, 'countItemData');
    local resetGroupID = contentsCls.ResetGroupID
    
    countData:SetTextByKey('now', GET_CURRENT_ENTERANCE_COUNT(resetGroupID));
    countData:SetTextByKey('max', GET_MAX_ENTERANCE_COUNT(resetGroupID));

    if contentsCls.ResetPer == 'WEEK' then
        cycleImage:SetImage(GET_INDUN_ICON_NAME('week_l'))
        cycleImage:ShowWindow(1);
    elseif contentsCls.ResetPer == 'DAY' then
        cycleImage:SetImage(GET_INDUN_ICON_NAME('day_l'));
        cycleImage:ShowWindow(1);
    else
        cycleImage:ShowWindow(0);
    end

    local countBox = GET_CHILD_RECURSIVELY(frame, 'countBox');
    local countText = GET_CHILD_RECURSIVELY(countBox, 'countText');
    local cycleCtrlPic = GET_CHILD_RECURSIVELY(countBox, 'cycleCtrlPic');

    countText:SetText(ScpArgMsg("IndunAdmissionItemReset"))
    countData:ShowWindow(1);
    countItemData:ShowWindow(0);
    cycleCtrlPic:ShowWindow(0);

    -- level
    local lvData = GET_CHILD_RECURSIVELY(frame, 'lvData');
    lvData:SetText(contentsCls.Level);

    -- map
    local posBox = GET_CHILD_RECURSIVELY(frame, 'posBox');
    local monBox = GET_CHILD_RECURSIVELY(frame, 'monBox');
    local rewardBox = GET_CHILD_RECURSIVELY(frame, 'rewardBox');
    posBox:ShowWindow(1)
    monBox:ShowWindow(1)
    rewardBox:ShowWindow(1)
    local resizeHeight = tonumber(frame:GetUserConfig('HEIGHT_RESIZE_FOR_BUTTON'));
    local originHeight = tonumber(frame:GetUserConfig('POSBOX_ORIGIN_HEIGHT'));
    local mon_origin_top = tonumber(frame:GetUserConfig('MON_ORIGIN_TOP'));
    local reward_origin_top = tonumber(frame:GetUserConfig('REWARD_ORIGIN_TOP'));
    local moveBox = GET_CHILD_RECURSIVELY(frame, 'moveBox');
    moveBox:ShowWindow(0);

    if posBox:GetHeight() ~= originHeight then
        posBox:Resize(posBox:GetWidth(), originHeight);
    end

    local mon_margin = monBox:GetMargin();
    if mon_margin.top ~= mon_origin_top then
        monBox:SetMargin(mon_margin.left, mon_origin_top, mon_margin.right, mon_margin.bottom);
    end

    local reward_margin = rewardBox:GetMargin();
    if reward_margin.top ~= reward_origin_top then
        rewardBox:SetMargin(reward_margin.left, reward_origin_top, reward_margin.right, reward_margin.bottom);
    end

    DESTROY_CHILD_BYNAME(posBox, 'MAP_CTRL_');
    local mapList = StringSplit(contentsCls.StartMap, '/');
    for i = 1, #mapList do
        local mapCls = GetClass('Map', mapList[i]);        
        if mapCls ~= nil then
            local mapCtrlSet = posBox:CreateOrGetControlSet('indun_pos_ctrl', 'MAP_CTRL_'..mapCls.ClassID, 0, 0);            
            local mapNameText = mapCtrlSet:GetChild('mapNameText');
            mapCtrlSet:SetGravity(ui.RIGHT, ui.TOP);
            mapCtrlSet:SetOffset(0, 10 + (10 + mapCtrlSet:GetHeight()) * (i - 1));
            mapCtrlSet:SetUserValue('INDUN_CLASS_ID', indunClassID);
            mapCtrlSet:SetUserValue('INDUN_START_MAP_ID', mapCls.ClassID);
            mapNameText:SetText(mapCls.Name);
        end
    end

    INDUNENTER_MAKE_MONLIST(frame, contentsCls);
end

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

    local indunListBox = GET_CHILD_RECURSIVELY(topFrame, 'INDUN_LIST_BOX');    
    local firstChild = indunListBox:GetChild('DETAIL_CTRL_'..indunListBox:GetUserValue('FIRST_INDUN_ID'));
    firstChild = tolua.cast(firstChild, 'ui::CControlSet');
    local startY = firstChild:GetY();    
    local NOT_SELECTED_BOX_SKIN = firstChild:GetUserConfig('NOT_SELECTED_BOX_SKIN');
    for i = 1, #g_selectedIndunTable do
        local indunCls = g_selectedIndunTable[i];        
        local detailCtrl = indunListBox:GetChild('DETAIL_CTRL_'..indunCls.ClassID);        
        if detailCtrl ~= nil then
            detailCtrl:SetOffset(detailCtrl:GetX(), startY + detailCtrl:GetHeight()*(i-1));                
            local skinBox = GET_CHILD(detailCtrl, 'skinBox');
            if i % 2 == 0 then
                skinBox:SetSkinName(NOT_SELECTED_BOX_SKIN);
                skinBox:SetUserValue('DEFAULT_SKIN_2', 'YES');
            else
                skinBox:SetSkinName('None');
                skinBox:SetUserValue('DEFAULT_SKIN_2', 'NO');
            end

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
	end
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

    local indunClsID = ctrl:GetUserValue('MOVE_INDUN_CLASSID');
    control.CustomCommand('MOVE_TO_ENTER_NPC', indunClsID, 0, 0);
end

--------------------------------- 주간 보스 레이드 --------------------------------- 
function  WEEKLYBOSSINFO_UI_OPEN(frame)
    WEEKLY_BOSS_DATA_REUQEST();

    TOGGLE_WEEKLYBOSSINFO(frame, 1);
    
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
    return jobID;
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
    TOGGLE_RAID_RANKING_UI(frame);
    RAID_RANKING_CATEGORY_INIT(frame);
end

function TOGGLE_RAID_RANKING_UI(frame)
    local raidrankingBox = GET_CHILD_RECURSIVELY(frame, 'raidrankingBox');
    raidrankingBox:ShowWindow(1);

    local WeeklyBossbox = GET_CHILD(frame, 'WeeklyBossbox');
    WeeklyBossbox:ShowWindow(0);
    local categoryBox = GET_CHILD(frame, 'categoryBox');
    categoryBox:ShowWindow(0);
    local contentBox = GET_CHILD(frame, 'contentBox');
    contentBox:ShowWindow(0);
    local bottomBox = GET_CHILD(frame, 'bottomBox');
    bottomBox:ShowWindow(0);
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