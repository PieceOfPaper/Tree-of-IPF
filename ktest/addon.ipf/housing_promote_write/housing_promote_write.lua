local thumnail_tempfilePath = "";

function HOUSING_PROMOTE_WRITE_ON_INIT(addon, frame)
    local frame = ui.GetFrame("housing_promote_write");
    frame:SetUserValue("IS_MY_HOUSE", "NO");
    frame:SetUserValue("EDIT_MODE", 0);

    addon:RegisterMsg("ENTER_PERSONAL_HOUSE", "ENTER_MY_PERSONAL_HOUSE_CHECK");
    addon:RegisterMsg("HOUSING_PROMOTE_THUMBNAIL_CREATE_SUCCESS", "HOUSING_PROMOTE_THUMBNAIL_CREATE_SUCCESS");
end

function HOUSING_PROMOTE_WRITE_OPEN(team_name, title, imgname, url)
    local frame = ui.GetFrame("housing_promote_write");
    HOUSING_PROMOTE_WRITE_INIT(frame);
    
    local posttitle_text = GET_CHILD(frame, "posttitle_text");
	local posttitle_def = GET_CHILD(frame, "posttitle_def");
    if title ~= nil and title ~= "" then
        posttitle_def:ShowWindow(0);
        posttitle_text:SetText(title);
    else
        posttitle_def:ShowWindow(1);
    end

    if imgname ~= nil and imgname ~= "housingbanner" then
        local ctrl = GET_CHILD(frame, "thumbnail_pic");
        ctrl:SetImage(imgname);
    end

    local url_ctrl = GET_CHILD(frame, "url_text");
	local url_def = GET_CHILD(frame, "url_def");
    if url ~= nil and url ~= "" then
        url_def:ShowWindow(0);
        url_ctrl:SetText(url);
    else
        url_def:ShowWindow(1);
    end

    local is_myHouse = frame:GetUserValue("IS_MY_HOUSE");
    local thumbnail_create = GET_CHILD(frame, "thumbnail_create");
    if is_myHouse == "YES" then
        thumbnail_create:ShowWindow(1);
    else
        thumbnail_create:ShowWindow(0);
    end
    
    frame:ShowWindow(1);
end

function HOUSING_PROMOTE_WRITE_CLOSE()
    ui.CloseFrame("housing_promote_write");
end

function HOUSING_PROMOTE_WRITE_INIT(frame)
    local thumbnail_pic = GET_CHILD(frame, "thumbnail_pic");
    thumbnail_pic:SetImage("housingbanner");

    local posttitle_text = GET_CHILD(frame, "posttitle_text");
    posttitle_text:SetText("");
    
    thumnail_tempfilePath = "";
end

function ENTER_MY_PERSONAL_HOUSE_CHECK(parent, msg, argStr)
    local frame = ui.GetFrame("housing_promote_write");
    frame:SetUserValue("IS_MY_HOUSE", argStr);
end

function HOUSING_PROMOTE_WRITE_TITLE_CLICK(parent)
	local ctrl = GET_CHILD(parent, "posttitle_def");
	ctrl:ShowWindow(0);
end

function HOUSING_PROMOTE_WRITE_URL_CLICK(parent)
	local ctrl = GET_CHILD(parent, "url_def");
	ctrl:ShowWindow(0);
end


------------------- 홍보 썸네일 시작 -------------------
housingframelist = {"housing_promote_board", "housing_promote_post", "housing_promote_write"};
function HOUSING_PROMOTE_WRITE_THUMBNAIL_CREATE(parent, ctrl)
    local frame = parent:GetTopParentFrame();

    local rectframe = ui.GetFrame("screenshot_rect");
    
    local checkBtn = GET_CHILD(rectframe, "checkBtn");
    checkBtn:SetEventScript(ui.LBUTTONUP, "HOUSING_THUMBNAIL_CAPTURE_SCREEN");
    
    local closeBtn = GET_CHILD(rectframe, "closeBtn");
    closeBtn:SetEventScript(ui.LBUTTONUP, "HOUSING_THUMBNAIL_CAPTURE_SCREEN_CANCLE");

    rectframe:ShowWindow(1);

    for k, v in pairs(housingframelist) do
        local checkframe = ui.GetFrame(v);

        if checkframe:IsVisible() == 1 then
            checkframe:ShowWindow(0);
        end
    end
    
    if housing.IsEditMode() == true then
        frame:SetUserValue("EDIT_MODE", 1);
        housing.CloseEditMode();

        closeBtn:SetEnable(0);
        ReserveScript("RESET_SCREENSHOT_RECT_BUTTON()", 3);
    end
    
    filefind.GetBinPath("UploadThumnail");
end

function HOUSING_PROMOTE_WRITE_THUMBNAIL_ADD(parent, ctrl)
    local selectorFrame = ui.GetFrame("loadimage");
    
	local acceptBtn = GET_CHILD_RECURSIVELY(selectorFrame, "acceptBtn");
    acceptBtn:SetEventScript(ui.LBUTTONUP, "REG_HOUSING_THUMBNAIL_CHECK_FORMAT")
    
	LOAD_IMAGE_INIT("UploadThumnail", "png");
end

function REG_HOUSING_THUMBNAIL_CHECK_FORMAT(parent, ctrl)
    local fullPath = ctrl:GetUserValue("fullPath")
    local orgPath = ctrl:GetUserValue("orgPath");
    local fileName = ctrl:GetUserValue("fileName");
    local tempPath = filefind.GetBinPath("tempfiles"):c_str();
    local result = RemoveInterlaceFromThumbnail(orgPath, fileName, tempPath); --srcPath에 있는 srcFileName배너의 인터레이스를 제거하고 targetPath에 저장
    if result == false then
        ui.MsgBox(ClMsg("ImageInterlaceException"));
        ui.CloseFrame('loadimage');
        return;
    end

    thumnail_tempfilePath = tempPath .. "\\" .. fileName;

    local frame = ui.GetFrame("housing_promote_write");
    local thumbnail_pic = GET_CHILD(frame, "thumbnail_pic");
    thumbnail_pic:SetImage("housingbanner");

	if filefind.FileExists(thumnail_tempfilePath, true) == true then
		thumbnail_pic:SetImage("");
        thumbnail_pic:SetFileName(thumnail_tempfilePath);
	end

    ui.CloseFrame('loadimage');
end

function HOUSING_PROMOTE_THUMBNAIL_CREATE_SUCCESS(frame, msg, fullPath)
    local frame = ui.GetFrame("housing_promote_write");
    local thumbnail_pic = GET_CHILD(frame, "thumbnail_pic");
    thumbnail_pic:SetImage("housingbanner");

    if filefind.FileExists(fullPath, true) == true then
        thumnail_tempfilePath = fullPath;
		thumbnail_pic:SetImage("");
        thumbnail_pic:SetFileName(fullPath);
	end

    HOUSING_THUMBNAIL_CAPTURE_SCREEN_CANCLE();
end

------------------- 글 등록 시작 -------------------
function HOUSING_PROMOTE_WRITE_REG_POST(parent, ctrl)
    local frame = parent:GetTopParentFrame();
    
	local account = session.barrack.GetCurrentAccount();
    local teamLv = account:GetTeamLevel();
    if teamLv < 10 then
        ui.SysMsg(ClMsg("PERSONAL_HOUSING_PROMOTE_LV_LIMIT"));
        return;
    end

    local title_ctrl = GET_CHILD(frame, "posttitle_text");
    local title_text = title_ctrl:GetText();

    if title_text == "" then
        ui.MsgBox(ClMsg("InputTitlePlease"));
        return;
    end
    
    local url_ctrl = GET_CHILD(frame, "url_text");
    local url_text = url_ctrl:GetText();

    if url_text ~= "" then
        if string.find(url_text, "http:") ~= nil or string.find(url_text, "https:") ~= nil then
            if string.find(url_text, "www.youtube.com/") == nil and string.find(url_text, "www.twitch.tv/") == nil then
                ui.MsgBox(ClMsg("Housing_Promote_URL_error"));
                return;
            end
        else
            ui.MsgBox(ClMsg("Housing_Promote_URL_error"));
            return;
        end
    end

    -- 게시글 등록
    local aidx = session.loginInfo.GetAID();
    PostHousingPage("HOUSING_PROMOTE_WRITE_REG_POST_UPDATE", aidx, title_text, url_text, thumnail_tempfilePath);
end

function HOUSING_PROMOTE_WRITE_REG_POST_UPDATE(code, ret_String)
    if code == 400 then
        if string.find(ret_String, 201) ~= nil then
            ui.MsgBox(ClMsg("OverMaxPostCount"));
        end

        if string.find(ret_String, 206) ~= nil then
            ui.MsgBox(ClMsg("Housing_Promote_URL_error"));
        end

        return;
    end

    if code ~= 200 then
        return;
    end
    
    ui.MsgBox(ClMsg("UploadSuccess"));
    HOUSING_PROMOTE_WRITE_CLOSE();
    HOUSING_PROMOTE_POST_OPEN_MY_HOUSE();
end