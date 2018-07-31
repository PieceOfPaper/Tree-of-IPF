
function PCBANG_POINT_TIMER_ON_INIT(addon, frame)
    addon:RegisterMsg("UPDATE_PCBANG_SHOP_POINT", "ON_PCBANG_POINT_TIMER_START_MSG");
    addon:RegisterMsg("UPDATE_PCBANG_SHOP_ACCUMULATING_TIME", "ON_PCBANG_POINT_TIMER_START_MSG");
end


function PCBANG_POINT_TIMER_SET_MARGIN(timerFrame)
    local sysFrame = ui.GetFrame("sysmenu");
    local timerRect = timerFrame:GetMargin();
    local pcbang_shop = GET_CHILD_RECURSIVELY(sysFrame, "pcbang_shop");
    if pcbang_shop ~= nil then
        local sysRect = pcbang_shop:GetMargin();
        local offset = timerFrame:GetUserConfig("TIMER_RIGHT_MARGIN_OFFSET");
        timerFrame:SetMargin(timerRect.left, timerRect.top, sysRect.right-offset, timerRect.bottom)
    end
end

function ON_PCBANG_POINT_TIMER_OPEN(timerFrame)
    PCBANG_POINT_TIMER_SET_MARGIN(timerFrame)
    if session.pcBang.GetTime("Accumulating") >= 0 and session.pcBang.GetTime("MaxAccumulating") > 0 then
        PCBANG_POINT_TIMER_SET(timerFrame, session.pcBang.GetTime("Accumulating"), session.pcBang.GetTime("MaxAccumulating"), session.pcBang.GetPCBangPoint());
    else
        PCBANG_POINT_TIMER_SET(timerFrame, 0, 1, 0);
    end
end

function PCBANG_POINT_TIMER_SET(timerFrame, accumulatingSec, totalSec, point)
    local time_gauge = GET_CHILD_RECURSIVELY(timerFrame, "time_gauge");
    if point >= PCBANG_POINT_MAX_VALUE then
        time_gauge:SetPoint(totalSec, totalSec);
        time_gauge:SetSkinName("pcbang_point_gauge_max");
        time_gauge:ShowStat(0, false);
        time_gauge:ShowStat(1, true);
    elseif accumulatingSec >= 0 then
        time_gauge:SetPoint(accumulatingSec, totalSec);
        time_gauge:SetSkinName("pcbang_point_gauge_s");
        time_gauge:SetText("Max")
        time_gauge:ShowStat(0, true);
        time_gauge:ShowStat(1, false);
    end
end

function ON_PCBANG_POINT_TIMER_START_MSG(timerFrame, msg, argstr, argnum)
    PCBANG_POINT_TIMER_SET(timerFrame, session.pcBang.GetTime("Accumulating"), session.pcBang.GetTime("MaxAccumulating"), session.pcBang.GetPCBangPoint());
end

function IS_PCBANG_POINT_TIMER_CHECKED()
    local pcbang_shop = ui.GetFrame("pcbang_shop");
    local show_timer_checkbox = GET_CHILD_RECURSIVELY(pcbang_shop, "show_timer_checkbox");
    return show_timer_checkbox:IsChecked();
end
