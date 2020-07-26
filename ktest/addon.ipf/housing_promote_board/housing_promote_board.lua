local json = require "json_imc";
local categoryY = 0;
local enableChangePage = false;
local ChangePageTime = 0;

local scrollPage = 1;
local scrolledTime = 0;
local enableScroll = false;

-- postIndex[filter_type][index] = post_id
-- index 해당 post의 고유 index 말고, 그냥 요청 받은 데이터 정보 순서 인덱스!
local postIndex = {};
-- postPropByID[post_id] = postProp
local postPropByID = {}; 

function HOUSING_PROMOTE_BOARD_ON_INIT(addon, frame)
    
end

function HOUSING_PROMOTE_BOARD_OPEN()
    local option = IsEnabledOption("HousingPromoteLock");
    if option == 1 then
        return;
    end    

    local frame = ui.GetFrame("housing_promote_board");
    local editDiff = GET_CHILD_RECURSIVELY(frame, "search_dif");
    editDiff:ShowWindow(1);

    HOUSING_PROMOTE_BOARD_INIT(frame);
    HOUSING_PROMOTE_BOARD_RECOMMEND(frame);
    
    local search_edit = GET_CHILD_RECURSIVELY(frame, "search_edit");
    search_edit:SetText("");

    frame:ShowWindow(1);
end

function HOUSING_PROMOTE_BOARD_CLOSE(frame)
    frame:ShowWindow(0);
end

function HOUSING_PROMOTE_BOARD_INIT(frame)
    categoryY = 0;
    enableChangePage = false;
    ChangePageTime = 0;

    scrollPage = 1;
    scrolledTime = 0;
    enableScroll = false;

    postIndex = {};
    postPropByID = {};

    local promote_gb = GET_CHILD(frame, "promote_gb");
    promote_gb:RemoveAllChild();
	promote_gb:SetScrollPos(0);
    promote_gb:ShowWindow(1);

    frame:SetUserValue("FILETER_TYPE", "Recommend");
end

function HOUSING_PROMOTE_BOARD_FILTER_UNFREEZE()
    local frame = ui.GetFrame("housing_promote_board");
    local filter_gb = GET_CHILD(frame, "filter_gb");
    filter_gb:EnableHitTest(1);
end

function HOUSING_PROMOTE_BOARD_FEATURED_FILTER(parent, ctrl, argStr)
    local frame = ui.GetFrame("housing_promote_board");

    local filter_gb = GET_CHILD(frame, "filter_gb");
    filter_gb:EnableHitTest(0);

    if argStr == "Refresh" then
        argStr = "Recommend";
    end

    HOUSING_PROMOTE_BOARD_INIT(frame);
    frame:SetUserValue("FILETER_TYPE", argStr);

    if argStr == "Recommend" then
        ReserveScript("HOUSING_PROMOTE_BOARD_FILTER_UNFREEZE()", 5);
        HOUSING_PROMOTE_BOARD_RECOMMEND(frame);
    else
        ReserveScript("HOUSING_PROMOTE_BOARD_FILTER_UNFREEZE()", 3);
        HOUSING_PROMOTE_BOARD_RECOMMEND_CREATE_FEATURED(argStr, ClMsg(argStr.."_house"), "desc", 0);
    end
end

function HOUSING_PROMOTE_BOARD_RECOMMEND(frame)
    local clsList, cnt = GetClassList("housing_featured_category");
    for i = 0, cnt - 1 do
        local cls = GetClassByIndexFromList(clsList, i);
        HOUSING_PROMOTE_BOARD_RECOMMEND_CREATE_FEATURED(cls.ClassName, cls.Name, cls.Sort, 1);
    end
end

function HOUSING_PROMOTE_BOARD_RECOMMEND_CREATE_FEATURED(filter, title, sort, btnToggle)
    local frame = ui.GetFrame("housing_promote_board");
    local promote_gb = GET_CHILD(frame, "promote_gb");

    local ctrl = promote_gb:CreateOrGetControlSet("featured_group", filter, 1, categoryY);
    ctrl = AUTO_CAST(ctrl);
    ctrl:SetUserValue("CURRENT_PAGE", 1);
    ctrl:SetUserValue("POST_COUNT", 0);
    ctrl:SetUserValue("MAX_VIEW_COUNT", 3);
    ctrl:SetUserValue("END_POST", 0);

    local title_text = GET_CHILD(ctrl, "title_text");
    title_text:SetTextByKey("value", title);

    postIndex[filter] = {};
    GetHousingList("HOUSING_PROMOTE_BOARD_FEATURED_REQUEST", 1, filter, sort);
    enableChangePage = false;
    categoryY = categoryY + ctrl:GetHeight();
end

function HOUSING_PROMOTE_BOARD_FEATURED_LEFT_BTN_CLICK(parent, ctrl, category)
    if enableChangePage == true then
        local now = imcTime.GetAppTime();
        local dif = now - ChangePageTime;

        if 1 < dif  then
            ChangePageTime = now;

            local frame = ui.GetFrame("housing_promote_board");
            local promote_gb = GET_CHILD(frame, "promote_gb");
            local featured_gb = GET_CHILD(promote_gb, category);
            if featured_gb == nil then return; end

            local curPage = featured_gb:GetUserValue("CURRENT_PAGE");
            local postCnt = featured_gb:GetUserIValue("POST_COUNT");
            local maxCnt = featured_gb:GetUserIValue("MAX_VIEW_COUNT");
            local prevPage = curPage - 1;
            if prevPage < 1 then
                prevPage = 1;
            end
            
            featured_gb:SetUserValue("CURRENT_PAGE", prevPage);

            HOUSING_PROMOTE_BOARD_FEATURED_UPDATE(category, prevPage);
        end
    end    
end

function HOUSING_PROMOTE_BOARD_FEATURED_RIGHT_BTN_CLICK(parent, ctrl, category)
    if enableChangePage == true then
        local now = imcTime.GetAppTime();
        local dif = now - ChangePageTime;

        if 1 < dif then
            ChangePageTime = now;

            local frame = ui.GetFrame("housing_promote_board");
            local promote_gb = GET_CHILD(frame, "promote_gb");
            local featured_gb = GET_CHILD(promote_gb, category);
            if featured_gb == nil then return; end

            local curPage = featured_gb:GetUserIValue("CURRENT_PAGE");
            local postCnt = featured_gb:GetUserIValue("POST_COUNT");
            local maxCnt = featured_gb:GetUserIValue("MAX_VIEW_COUNT");
            local endPost = featured_gb:GetUserIValue("END_POST");
            local value = math.ceil(postCnt / 3);
            local nextPage = curPage + 1;
            
            featured_gb:SetUserValue("CURRENT_PAGE", nextPage);

            if postCnt <= nextPage * maxCnt and endPost == 0 then
                local cls = GetClass("housing_featured_category", category);
                local requestPage = math.ceil(postCnt / 4) + 1;         -- 데이터는 4개씩 받아오기 때문에 page를 다르게 계산해야함
                GetHousingList("HOUSING_PROMOTE_BOARD_FEATURED_REQUEST", requestPage, category, cls.Sort);
                enableChangePage = false;
            else
                HOUSING_PROMOTE_BOARD_FEATURED_UPDATE(category, nextPage);
            end
        end
    end    
end

function HOUSING_PROMOTE_BOARD_FEATURED_REQUEST(code, ret_json)
    enableChangePage = true;
    if code ~= 200 then
        return;
    end

    local parsed = json.decode(ret_json);
    if #parsed == 0 then
        return;
    end

    local filter_type = parsed[1]["filter_type"];

    local frame = ui.GetFrame("housing_promote_board");
    local promote_gb = GET_CHILD(frame, "promote_gb");
    local featured_gb = GET_CHILD(promote_gb, filter_type);
    if featured_gb == nil then return; end

    local marginX = frame:GetUserConfig("POST_MARGIN_X");
    local marginY = frame:GetUserConfig("POST_MARGIN_Y");
    
    local curPage = featured_gb:GetUserIValue("CURRENT_PAGE");
    local postCnt = featured_gb:GetUserIValue("POST_COUNT");
    local nextpostCnt = postCnt;    

    local empty_text = GET_CHILD(featured_gb, "empty_text");
    if filter_type == "Friend" or filter_type == "Guild" or filter_type == "TeamName" then
        -- 피처드 카테고리가 나누어져 있지 않고 아래로 쭉 출력
        local value = 0;
        for i = 1, #parsed do
            local page_id = parsed[i]["page_id"];
            if page_id ~= "" then
                nextpostCnt = nextpostCnt + 1;
                featured_gb:SetUserValue("POST_COUNT", nextpostCnt);
    
                local postX = 48;
                if math.floor(nextpostCnt % 3) == 2 then
                    postX = postX + ui.GetControlSetAttribute("promote_post_list", "width");
                elseif math.floor(nextpostCnt % 3) == 0 then
                    postX = postX + ui.GetControlSetAttribute("promote_post_list", "width") * 2;
                end
    
                value = math.floor((nextpostCnt - 1) / 3);
    
                local postY = value * ui.GetControlSetAttribute("promote_post_list", "height") + marginY;
                postPropByID[page_id] = parsed[i];
                HOUSING_PROMOTE_BOARD_FEATURED_UPDATE_POST(promote_gb, filter_type, page_id, postX, postY , 0);
            end
        end

        if postCnt ~= nextpostCnt then
            featured_gb:SetUserValue("END_POST", 0);
            empty_text:ShowWindow(0);
        else
            featured_gb:SetUserValue("END_POST", 1);
        end

    else
        -- 피처드 카테고리가 나누어져 있고 카테고리별 3개씩 출력
        for i = 1, #parsed do
            local page_id = parsed[i]["page_id"];
            if page_id ~= "" and page_id ~= nil then
                local filterListCnt = #postIndex[filter_type];
    
                postIndex[filter_type][filterListCnt + 1] = page_id;
                postPropByID[page_id] = parsed[i];
    
                nextpostCnt = nextpostCnt + 1;
                featured_gb:SetUserValue("POST_COUNT", nextpostCnt);
            end
        end

        if (curPage == math.floor(nextpostCnt/3)) and (1 <= (nextpostCnt % 3)) then
            featured_gb:SetUserValue("END_POST", 0);
        else
            featured_gb:SetUserValue("END_POST", 1);
        end

        HOUSING_PROMOTE_BOARD_FEATURED_UPDATE(filter_type, curPage);    
    end
end

function HOUSING_PROMOTE_BOARD_FEATURED_UPDATE(filter_type, page)
    local frame = ui.GetFrame("housing_promote_board");
    if frame:IsVisible() == 0 then
        return
    end

    local marginX = frame:GetUserConfig("POST_MARGIN_X");
    local marginY = frame:GetUserConfig("POST_MARGIN_Y");

    local promote_gb = GET_CHILD(frame, "promote_gb");
    local featured_gb = GET_CHILD(promote_gb, filter_type);
    if featured_gb == nil then return; end

    local empty_text = GET_CHILD(featured_gb, "empty_text");

    local subitemPrefix = filter_type.."_"
    DESTROY_CHILD_BYNAME(promote_gb, subitemPrefix);

    local postCnt = featured_gb:GetUserIValue("POST_COUNT");
    local maxCnt = featured_gb:GetUserIValue("MAX_VIEW_COUNT");

    local startindex = ((page - 1) * maxCnt) + 1;
    for i = startindex, startindex + 2 do
        if i <= postCnt then
            local cls = GetClass("housing_featured_category", filter_type);

            local postX = 48;
            local postY = ((cls.ClassID - 1) * ui.GetControlSetAttribute("featured_group", "height"));
            if i % 3 == 2 then
                postX = postX + ui.GetControlSetAttribute("promote_post_list", "width");
            elseif i % 3 == 0 then
                postX = postX + ui.GetControlSetAttribute("promote_post_list", "width") * 2;
            end

            local page_id = postIndex[filter_type][i];
            HOUSING_PROMOTE_BOARD_FEATURED_UPDATE_POST(promote_gb, filter_type, page_id, postX, postY + marginY, i);
            
            empty_text:ShowWindow(0);
        end
    end

    HOUSING_PROMOTE_BOARD_FEATURED_BUTTON_TOGGLE(promote_gb, featured_gb, filter_type);
end

function HOUSING_PROMOTE_BOARD_FEATURED_UPDATE_POST(promote_gb, filter_type, page_id, postX, postY, post_index)
    local table = postPropByID[page_id];
    
    local ctrl = promote_gb:CreateOrGetControlSet("promote_post_list", filter_type.."_"..table["page_id"], postX, postY);
    ctrl = AUTO_CAST(ctrl);
    ctrl:SetUserValue("CHANNEL_ID", table["channel_id"]);
    ctrl:SetUserValue("PAGE_ID", table["page_id"]);

    local thumbnail = GET_CHILD_RECURSIVELY(ctrl, "thumbnail");
    thumbnail:SetImage("housingbanner");
    if table["thumbnail_id"] ~= nil then
        GetHousingThumbnailImage("HOUSING_PROMOTE_BOARD_POST_THUMNAIL_UPDATE", table["channel_id"], table["page_id"], table["thumbnail_id"], filter_type);
    end

    local title = GET_CHILD(ctrl, "title");
    title:SetTextByKey("value", table["title"]);

    local teamname = GET_CHILD(ctrl, "teamname");
    teamname:SetTextByKey("value", table["team_name"]);

    local pointinfo_pic = GET_CHILD(ctrl, "pointinfo_pic");    
	pointinfo_pic:SetEventScript(ui.LBUTTONUP, "HOUSING_PROMOTE_BOARD_POST_GOOD_POINT_UPDATE");
    pointinfo_pic:SetEventScriptArgString(ui.LBUTTONUP, filter_type);

    if table["my_favorite_page"] == "YES" then
        pointinfo_pic:SetImage("housing_like_clicked");
    end

    local total_visitors = 0;
    local good_point = 0;
    if table["socialInfo"] ~= nil then
        total_visitors = table["socialInfo"]["total_visitors"];
        good_point = table["socialInfo"]["good_point"];
    end

    local pointinfo = GET_CHILD(ctrl, "pointinfo");
    pointinfo:SetTextByKey("GoodPoint", good_point);
    pointinfo:SetTextByKey("visitor", total_visitors);

    local cls = GetClass("housing_featured_category", filter_type);
    if cls ~= nil and cls.Contest == "yes" then
        if post_index <= 3 then
            local icon = thumbnail:CreateControl("picture", "housing_contest_01", 42, 51, ui.LEFT, ui.TOP, 8, 7, 0, 0);
            icon = AUTO_CAST(icon);
            icon:SetImage("housing_contest_0"..post_index);
        end
    end
end

function HOUSING_PROMOTE_BOARD_FEATURED_BUTTON_TOGGLE(promote_gb, featured_gb, filter_type)
    DESTROY_CHILD_BYNAME(promote_gb, "btn_"..filter_type);

    local cls = GetClass("housing_featured_category", filter_type);
    local posY = ((cls.ClassID - 1) * ui.GetControlSetAttribute("featured_group", "height")) + 40;

    local ctrl = promote_gb:CreateOrGetControlSet("featured_btn", "btn_"..filter_type, 6, posY);
    ctrl = AUTO_CAST(ctrl);

    local left_btn = GET_CHILD(ctrl, "left_btn");    
    left_btn:ShowWindow(0);

    local right_btn = GET_CHILD(ctrl, "right_btn");
    right_btn:ShowWindow(0);

    left_btn:SetEventScriptArgString(ui.LBUTTONUP, filter_type);
    right_btn:SetEventScriptArgString(ui.LBUTTONUP, filter_type);
    
    local curPage = featured_gb:GetUserIValue("CURRENT_PAGE");
    if curPage == 1 then
        left_btn:ShowWindow(0);
    else
        left_btn:ShowWindow(1);
    end

    local postCnt = featured_gb:GetUserIValue("POST_COUNT");
    local curPage = featured_gb:GetUserIValue("CURRENT_PAGE");
    local nextpostCnt = postCnt - (curPage * 3);
    
    if 0 < nextpostCnt then
        right_btn:ShowWindow(1);
    else
        right_btn:ShowWindow(0);
    end
end

function HOUSING_PROMOTE_BOARD_TEAMNANE_SEARCH_CLICK(parent, ctrl)
	local editDiff = GET_CHILD_RECURSIVELY(parent, "search_dif");
	editDiff:ShowWindow(0);
end

function HOUSING_PROMOTE_BOARD_TEAMNANE_SEARCH(parent, ctrl)
    local edit = GET_CHILD(parent, "search_edit");
    local teamname = edit:GetText();

    if teamname == "" then
        return;
    end

    ReserveScript("HOUSING_PROMOTE_BOARD_FILTER_UNFREEZE()", 3);

    local frame = ui.GetFrame("housing_promote_board");

    local filter_gb = GET_CHILD(frame, "filter_gb");
    filter_gb:EnableHitTest(0);

    HOUSING_PROMOTE_BOARD_INIT(frame);
    frame:SetUserValue("FILETER_TYPE", "TeamName");

    HOUSING_PROMOTE_BOARD_RECOMMEND_CREATE_FEATURED("TeamName", ClMsg("SearchResult"), teamname, 0);
end

------------------------ 게시글 controlset 관련 시작 ------------------------
function HOUSING_PROMOTE_BOARD_POST_THUMNAIL_UPDATE(code, page_id, filePath, filter_type)
    if code ~= 200 then
        return;
    end
    
    local frame = ui.GetFrame("housing_promote_board");
    local promote_gb = GET_CHILD(frame, "promote_gb");
    local ctrl = GET_CHILD(promote_gb, filter_type.."_"..page_id);
    if ctrl == nil then return; end

    local thumbnail = GET_CHILD_RECURSIVELY(ctrl, "thumbnail");

    if thumbnail == nil then
        return;
    end
    
    local folderPath = filefind.GetBinPath("Housing"):c_str()
    local fullPath = folderPath .. "\\" .. filePath;

    if filefind.FileExists(fullPath, true) == true then
        ui.SetImageByPath(fullPath, thumbnail);
        thumbnail:Invalidate();
    end
end

function HOUSING_PROMOTE_BOARD_POST_CLICK(parent, ctrl)
    local page_id = parent:GetUserValue("PAGE_ID");
    local channel_id = parent:GetUserValue("CHANNEL_ID");

    HOUSING_PROMOTE_POST_OPEN(page_id, channel_id);
end

function HOUSING_PROMOTE_BOARD_POST_GOOD_POINT_UPDATE(parent, ctrl, argStr)
    local page_id = parent:GetUserValue("PAGE_ID");

    ClickHousingPageGood("HOUSING_PROMOTE_BOARD_POST_GOOD_POINT_REQUEST", page_id, argStr);
end

function HOUSING_PROMOTE_BOARD_POST_GOOD_POINT_REQUEST(code, ret_json)
    if code ~= 200 then
        return;
    end

    local parsed = json.decode(ret_json);
    local page_id = parsed["page_id"];

    local frame = ui.GetFrame("housing_promote_board");
    local promote_gb = GET_CHILD(frame, "promote_gb");
    local ctrl = GET_CHILD(promote_gb, parsed["filter"].."_"..page_id);
    if ctrl == nil then return; end

    local pointinfo_pic = GET_CHILD(ctrl, "pointinfo_pic");
    local pointinfo = GET_CHILD(ctrl, "pointinfo");
    local table = postPropByID[page_id];
    local good_point = table["socialInfo"]["good_point"];

    if parsed["favorite"] == "YES" then
        pointinfo_pic:SetImage("housing_like_clicked");
        good_point = good_point + 1;
        table["socialInfo"]["good_point"] = table["socialInfo"]["good_point"] + 1; 
        table["my_favorite_page"] = "YES";

        ui.SysMsg(ClMsg("Housing_Promote_Good_Point_On"));
    else
        pointinfo_pic:SetImage("housing_like");
        good_point = good_point - 1;
        table["socialInfo"]["good_point"] = table["socialInfo"]["good_point"] - 1; 
        table["my_favorite_page"] = "NO";

        ui.SysMsg(ClMsg("Housing_Promote_Good_Point_Off"));
    end

    pointinfo:SetTextByKey("GoodPoint", good_point);
end
------------------------ 포스트 controlset 관련 끝 ------------------------