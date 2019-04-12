
function PCBANG_SHOP_ON_INIT(addon, frame)
    addon:RegisterMsg("PCBANG_SHOP_TOGGLE", "ON_PCBANG_SHOP_TOGGLE_MSG");
    addon:RegisterMsg("UPDATE_PCBANG_SHOP_POINT", "ON_UPDATE_PCBANG_SHOP_POINT");
    addon:RegisterMsg("UPDATE_PCBANG_SHOP_ACCUMULATING_TIME", "ON_UPDATE_PCBANG_SHOP_POINT");
    addon:RegisterOpenOnlyMsg("UPDATE_PCBANG_SHOP_MAIN_PAGE", "ON_UPDATE_PCBANG_SHOP_MAIN_PAGE");
    addon:RegisterOpenOnlyMsg("UPDATE_PCBANG_SHOP_POINTSHOP_LIST", "ON_UPDATE_PCBANG_SHOP_POINTSHOP_LIST");
    addon:RegisterOpenOnlyMsg("UPDATE_PCBANG_SHOP_POINTSHOP_BUY_COUNT", "ON_UPDATE_PCBANG_SHOP_POINTSHOP_BUY_COUNT");
    addon:RegisterOpenOnlyMsg("UPDATE_PCBANG_SHOP_RENTAL_LIST", "ON_UPDATE_PCBANG_SHOP_RENTAL_LIST");
    addon:RegisterOpenOnlyMsg("UPDATE_PCBANG_SHOP_GUIDE_PAGE", "ON_UPDATE_PCBANG_SHOP_GUIDE_PAGE");
    addon:RegisterOpenOnlyMsg("UPDATE_PCBANG_SHOP_REWARD", "ON_UPDATE_PCBANG_SHOP_REWARD");
    addon:RegisterOpenOnlyMsg("PCBANG_SHOP_REWARD_RECV", "ON_PCBANG_SHOP_REWARD_RECV");
    addon:RegisterOpenOnlyMsg("PCBANG_SHOP_TOTAL_REWARD_RECV", "ON_PCBANG_SHOP_TOTAL_REWARD_RECV");
    addon:RegisterOpenOnlyMsg("PCBANG_SHOP_POINT_CHANGED", "ON_PCBANG_SHOP_POINT_CHANGED");
    addon:RegisterOpenOnlyMsg("PCBANG_SHOP_BOUGHTCOUNT_CHANGED", "ON_PCBANG_SHOP_BOUGHTCOUNT_CHANGED");
    
    PCBANG_SHOP_TABLE = {}
    PCBANG_SHOP_TABLE["POINTSHOP_CATEGORY"] = "Common";
    PCBANG_SHOP_TABLE["RENTAL_CATEGORY"] = "Weapon";
end

function ON_PCBANG_SHOP_TOGGLE_MSG(frame, msg, argstr, argnum)
    frame:ShowWindow(argnum);
end

function ON_PCBANG_SHOP_OPEN(frame)
    local tab = GET_CHILD_RECURSIVELY(frame, "tab")
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

function ON_PCBANG_SHOP_CLOSE(frame)
    
end

function ON_PCBANG_SHOP_CLOSE_BTN(frame)
    frame:ShowWindow(0);
end

function ON_PCBANG_SHOP_HELP_BTN(frame)

end

function ON_PCBANG_SHOP_REFRESH_BTN(frame)
    pcBang.ReqPCBangShopPage("COMMON");
    pcBang.ReqPCBangShopRefresh();
end

function ON_PCBANG_SHOP_TAB_MAIN(frame)
    pcBang.ReqPCBangShopPage("MAIN");
    pcBang.ReqPCBangShopPage("REWARD");    
end

function ON_PCBANG_SHOP_TAB_POINTSHOP(parent, groupbox)
    local frame = parent:GetTopParentFrame();

    pcBang.ReqPCBangShopPage("POINTSHOP_CATALOG");
    pcBang.ReqPCBangShopPage("POINTSHOP_HISTORY");
end

function ON_PCBANG_SHOP_TAB_RENTAL(parent, groupbox)    
    local frame = parent:GetTopParentFrame();    
    pcBang.ReqPCBangShopPage("RENTAL");
end

function ON_PCBANG_SHOP_TAB_GUIDE(frame)
    pcBang.ReqPCBangShopPage("GUIDE");
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
    
	point_timer_text:RunUpdateScript("UPDATE_PCBANG_SHOP_POINT_TIMER_TEXT", 60);
	total_time_text:RunUpdateScript("UPDATE_PCBANG_SHOP_TOTAL_TIME_TEXT", 60);
end

function SET_PCBANG_SHOP_TOTAL_TIME_TEXT(total_time_text, totalSec)
    local lastSec = total_time_text:GetUserValue("total_sec")
    lastSec = tonumber(lastSec);
    local totalHour = math.floor(totalSec / 3600)
    local totalMin = math.floor((totalSec % 3600) / 60)
    total_time_text:SetTextByKey("hour", totalHour);
    total_time_text:SetTextByKey("min", totalMin);
    total_time_text:SetUserValue("total_sec", totalSec)
end

function UPDATE_PCBANG_SHOP_TOTAL_TIME_TEXT(ctrl, elapsedTime)
    local totalSec = session.pcBang.GetTime("Total") + elapsedTime;

    SET_PCBANG_SHOP_TOTAL_TIME_TEXT(ctrl, totalSec)
    return 1;
end

function SET_PCBANG_SHOP_RESET_TIME_TEXT(point_timer_text, remainSec)
    local day = math.floor(remainSec / 86400);
    local remainder  = remainSec % 86400;
    local hour = math.floor(remainder  / 3600);
    remainder  = remainder  % 3600;
    local min = math.floor(remainder  / 60);

    point_timer_text:SetTextByKey("day", day);
    point_timer_text:SetTextByKey("hour", hour);
    point_timer_text:SetTextByKey("min", min);
end

function UPDATE_PCBANG_SHOP_POINT_TIMER_TEXT(ctrl, elapsedTime)    
    local resetTime = session.pcBang.GetQuarterResetTime()
    local now  = geTime.GetServerSystemTime();
    local dif = imcTime.GetDifSec(resetTime, now) - elapsedTime;
    SET_PCBANG_SHOP_RESET_TIME_TEXT(ctrl, dif)
    return 1;
end

function ON_UPDATE_PCBANG_SHOP_GUIDE_PAGE(frame)
    local guide_text = GET_CHILD_RECURSIVELY(frame, "guide_text");
    local guideText = session.pcBang.GetGuideText();
    guide_text:SetText(guideText);
end

function ON_UPDATE_PCBANG_SHOP_REWARD(frame)
    local myAccount = GetMyAccountObj()
    
    local isDaily = 0;
    if myAccount.PCBANG_REWARD_DAILY == "None" then
        isDaily = 1;
    else
        local lastDaily = imcTime.GetSysTimeByStr(myAccount.PCBANG_REWARD_DAILY);
        if IS_ALREADY_RECEIVED_PCBANG_REWARD_DAILY(lastDaily, geTime.GetServerSystemTime()) == 0 then
            isDaily = 1;
        end
    end
    
    local isMonthly = 0;
    if myAccount.PCBANG_REWARD_MONTHLY == "None" then
        isMonthly = 1;
    else
        local lastMonthly = imcTime.GetSysTimeByStr(myAccount.PCBANG_REWARD_MONTHLY);
        if IS_ALREADY_RECEIVED_PCBANG_REWARD_MONTHLY(lastMonthly, geTime.GetServerSystemTime()) == 0 then
            isMonthly = 1;
        end
    end

    local receivedTotalHour = myAccount.PCBANG_REWARD_TOTAL_HOUR;
    local curTotalSeconds = session.pcBang.GetTime("Total");
    local curTotalHours = math.floor(curTotalSeconds / 3600);

    PCBANG_SHOP_MAIN_FILL_REWARD_BOX(frame, "reward_daily", ScpArgMsg("PCBangDailyReward"), "Daily", isDaily);
    PCBANG_SHOP_MAIN_FILL_REWARD_BOX(frame, "reward_monthly", ScpArgMsg("PCBangMonthlyReward"), "Monthly", isMonthly);
    PCBANG_SHOP_MAIN_FILL_TOTAL_REWARD_BOX(frame, "reward_total", receivedTotalHour, curTotalHours);
end

function ON_PCBANG_SHOP_CHECK_SHOW_TIMER(frame, ctrl, str, num)
    if ctrl:IsChecked() == 1 then
        ui.OpenFrame("pcbang_point_timer");
    else
        ui.CloseFrame("pcbang_point_timer");
    end
end

function ON_PCBANG_SHOP_REWARD_RECV(frame, msg, argstr, argnum)
    if argstr == "Daily" then
        PCBANG_SHOP_MAIN_FILL_REWARD_BOX(frame, "reward_daily", ScpArgMsg("PCBangDailyReward"), "Daily", 0);
    elseif argstr == "Monthly" then
        PCBANG_SHOP_MAIN_FILL_REWARD_BOX(frame, "reward_monthly", ScpArgMsg("PCBangMonthlyReward"), "Monthly", 0);
    end
end

function ON_PCBANG_SHOP_TOTAL_REWARD_RECV(frame, msg, argstr, receivedTotalHour)
    local totalSeconds = session.pcBang.GetTime("Total")
    local totalHours = math.floor(totalSeconds / 3600);

    PCBANG_SHOP_MAIN_FILL_TOTAL_REWARD_BOX(frame, "reward_total", receivedTotalHour, totalHours);
end

function PCBANG_SHOP_CHECK_OPEN()
    if session.loginInfo.IsPremiumState(NEXON_PC) == true then
        return 1;
    elseif ENABLE_USE_PCBANG_POINT_SHOP_EVERYBODY == 1 then
        return 1;
    else
        return 0;
    end
end

function ON_PCBANG_SHOP_POINT_CHANGED(frame, msg, argstr, argnum)
    pcBang.ReqPCBangShopPage("MAIN");
end

function ON_PCBANG_SHOP_BOUGHTCOUNT_CHANGED(frame, msg, argstr, argnum)
    pcBang.ReqPCBangShopPage("POINTSHOP_HISTORY");
end