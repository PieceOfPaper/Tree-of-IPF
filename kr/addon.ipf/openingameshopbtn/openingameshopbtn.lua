function OPENINGAMESHOPBTN_ON_INIT(addon, frame)

    addon:RegisterMsg("UPDATE_OPEN_INGAMESHOP_BTN", "OPENINGAMESHOPBTN_ON_UPDATE");

end

function OPENINGAMESHOPBTN_ON_UPDATE(frame, msg, argStr, itemCnt)
    if itemCnt > 0 and frame:GetUserValue("UPDATE") ~= "DONE" then
        local helpBalloon = MAKE_BALLOON_FRAME(ScpArgMsg('remain_TP'), 0, 0, nil, nil)
        helpBalloon:ShowWindow(1);

        local margin = frame:GetMargin();
        local x = margin.top;
        local y = margin.right;

        helpBalloon:SetGravity(ui.RIGHT, ui.TOP);
        helpBalloon:SetMargin(0, x, y + 80, 0);
        helpBalloon:SetDuration(10);
        helpBalloon:SetLayerLevel(105);

        ui.MsgBox_NonNested(ScpArgMsg("remain_TP_exists"), frame:GetName(), "OPENINGAMESHOPBTN_CLICK", "None");
        frame:SetUserValue("UPDATE", "DONE")
    end
end

function OPENINGAMESHOPBTN_CLICK()
    ui.OpenFrame('steamtpinventory')
end