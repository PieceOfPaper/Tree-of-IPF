function ON_PCBANG_SHOP_OPEN(frame)
    local tab = GET_CHILD_RECURSIVELY(frame, "tab")
    tab:SetTabVisible(tab:GetIndexByName("main_tab"), false);
    tab:SetTabVisible(tab:GetIndexByName("rental_tab"), false);
    tab:SetTabVisible(tab:GetIndexByName("guide_tab"), false);
    tab:SelectTab(tab:GetIndexByName("pointshop_tab"));    
    local tabName = tab:GetSelectItemName();

    pcBang.ReqPCBangShopPage("COMMON");

    if tabName == "main_tab" then
        ON_PCBANG_SHOP_TAB_MAIN(frame);
    elseif tabName == "pointshop_tab" then
        ON_PCBANG_SHOP_TAB_POINTSHOP(frame);
    elseif tabName == "rental_tab" then
        ON_PCBANG_SHOP_TAB_RENTAL(frame);
    elseif tabName == "guide_tab" then
        ON_PCBANG_SHOP_TAB_GUIDE(frame);
    end
end

function ON_UPDATE_PCBANG_SHOP_POINT(frame)
    local point_text = GET_CHILD_RECURSIVELY(frame, "point_text");
    local point_gauge = GET_CHILD_RECURSIVELY(frame, "point_gauge");
    local today_point_text = GET_CHILD_RECURSIVELY(frame, "today_point_text");
    local total_time_text = GET_CHILD_RECURSIVELY(frame, "total_time_text");
    local point_timer_text = GET_CHILD_RECURSIVELY(frame, "point_timer_text");
    
    local pcBangPoint = session.pcBang.GetPCBangPoint();
    point_text:SetTextByKey("value", pcBangPoint);
    point_gauge:SetPoint(pcBangPoint, PCBANG_POINT_MAX_VALUE);
    
    local todayPoint = session.pcBang.GetPCBangTodayPoint();
    today_point_text:SetTextByKey("value", todayPoint);
    
    local resetTime = session.pcBang.GetQuarterResetTime();
    local now  = geTime.GetServerSystemTime();
    local dif = imcTime.GetDifSec(resetTime, now);
    SET_PCBANG_SHOP_RESET_TIME_TEXT(point_timer_text, dif)
    SET_PCBANG_SHOP_TOTAL_TIME_TEXT(total_time_text, session.pcBang.GetTime("Total"))
    
	--point_timer_text:RunUpdateScript("UPDATE_PCBANG_SHOP_POINT_TIMER_TEXT", 60);
	total_time_text:RunUpdateScript("UPDATE_PCBANG_SHOP_TOTAL_TIME_TEXT", 60);
end

function SET_PCBANG_SHOP_RESET_TIME_TEXT(point_timer_text, remainSec)
    local day = math.floor(remainSec / 86400);
    local remainder  = remainSec % 86400;
    local hour = math.floor(remainder  / 3600);
    remainder  = remainder  % 3600;
    local min = math.floor(remainder  / 60);

    -- point_timer_text:SetTextByKey("day", day);
    -- point_timer_text:SetTextByKey("hour", hour);
    -- point_timer_text:SetTextByKey("min", min);
end