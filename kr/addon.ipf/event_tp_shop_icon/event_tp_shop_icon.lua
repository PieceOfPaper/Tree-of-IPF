function EVENT_TP_SHOP_ICON_ON_INIT(addon, frame)
	addon:RegisterMsg("EVENT_TP_SHOP_1912_GACHA", "ON_EVENT_TP_SHOP_1912_GACHA");
end

function ON_EVENT_TP_SHOP_1912_GACHA(frame, msg, argStr, argNum)
    movie.PlayAnim(argNum, 'event_ani', 1.5, 1);
    
    local itemCls = GetClass("Item", argStr);
    local icon = GET_CHILD(frame, "icon", "ui::CPicture");
    icon:SetImage(itemCls.Icon)

    frame:SetUserValue("HANDLE", argNum);
    ReserveScript('ICON_POS_START()', 0.7);
    ReserveScript('ICON_POS_STOP()', 1.3);
    
    ICON_POS_UPDATE(frame)
end

function ICON_POS_UPDATE(frame)
    local frame = ui.GetFrame("event_tp_shop_icon");
    local handle = frame:GetUserIValue("HANDLE");

    local nodepos = customize.GetNodePos(handle, 'Dummy_item');
    if nodepos == nil then
        return 0;
    end

    local pos = world.ToScreenPosOriginal(nodepos.x, nodepos.y, nodepos.z);    
    local point = frame:ScreenPosToFramePos(pos.x, pos.y);
    frame:SetPos(point.x - 10, point.y - 40);

    return 1;
end

function ICON_POS_STOP()
    local frame = ui.GetFrame("event_tp_shop_icon");

    frame:StopUpdateScript("ICON_POS_UPDATE");
    frame:ShowWindow(0);
end

function ICON_POS_START()
    local frame = ui.GetFrame("event_tp_shop_icon");
    frame:RunUpdateScript("ICON_POS_UPDATE");
    frame:ShowWindow(1);
end
