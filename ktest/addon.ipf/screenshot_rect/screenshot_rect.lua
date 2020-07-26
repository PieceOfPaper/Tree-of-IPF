function SCREENSHOT_RECT_UI_CLOSE(frame)
    local checkBtn = GET_CHILD(frame, "checkBtn");
    checkBtn:SetEventScript(ui.LBUTTONUP, "");

    local closeBtn = GET_CHILD(frame, "closeBtn");
    closeBtn:SetEventScript(ui.LBUTTONUP, "SCREENSHOT_RECT_CLOSE_BTN_CLICK");
end

function SCREENSHOT_RECT_CLOSE_BTN_CLICK(parent, ctrl)
    local frame = parent:GetTopParentFrame();

    frame:ShowWindow(0);
end

---------------------- 개인 하우징 게시판 시작 ----------------------
function HOUSING_THUMBNAIL_CAPTURE_SCREEN()
    housing.RequestHousingThumbnailScreenshot();
end

function HOUSING_THUMBNAIL_CAPTURE_SCREEN_CANCLE(parent, ctrl)
    local frame = ui.GetFrame("screenshot_rect");

    local writeframe = ui.GetFrame("housing_promote_write");
    if writeframe:GetUserIValue("EDIT_MODE") == 1 then
        writeframe:SetUserValue("EDIT_MODE", 0);
        housing.OpenEditMode();

        local thumbnail_create = GET_CHILD(writeframe, "thumbnail_create");
        thumbnail_create:SetEnable(0);

        ReserveScript("RESET_HOUSING_THUMBNAIL_CREATE_BUTTON()", 4);
    end

    for k, v in pairs(housingframelist) do
        local checkframe = ui.GetFrame(v);

        if checkframe:IsVisible() == 0 then
            checkframe:ShowWindow(1);
        end
    end
    
    frame:ShowWindow(0);
end

function RESET_HOUSING_THUMBNAIL_CREATE_BUTTON()
    local frame = ui.GetFrame("housing_promote_write");
    
	local thumbnail_create = GET_CHILD(frame, "thumbnail_create");
	thumbnail_create:SetEnable(1);
end

function RESET_SCREENSHOT_RECT_BUTTON()
    local frame = ui.GetFrame("screenshot_rect");
    
	local closeBtn = GET_CHILD(frame, "closeBtn");
	closeBtn:SetEnable(1);
end
---------------------- 개인 하우징 게시판 끝 ----------------------