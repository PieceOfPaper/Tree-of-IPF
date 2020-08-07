local json = require "json_imc";
local optioninfolist = {"all", "friend", "guild", "block"};

function HOUSING_PROMOTE_POST_ON_INIT(addon, frame)
	addon:RegisterMsg("GAME_START", "HOUSING_PROMOTE_POST_HOUSE_WARP_BTN_CHECK");
end

function HOUSING_PROMOTE_POST_OPEN(page_id, channelID)
    local frame = ui.GetFrame("housing_promote_post");

    HOUSING_PROMOTE_POST_CLOSE(frame)
    HOUSING_PROMOTE_POST_INIT(frame);

    if page_id == nil or channelID == nil or page_id == "" or channelID == "" then
        return;
    end

    GetHousingDetialPageInfo("HOUSING_PROMOTE_POST_UPDATE", channelID, page_id);
end

function HOUSING_PROMOTE_POST_CLOSE(frame)
    local writefrmae = ui.GetFrame("housing_promote_write");
    if writefrmae:IsVisible() == 1 then
        writefrmae:ShowWindow(0);
    end

    frame:ShowWindow(0);
end

function HOUSING_PROMOTE_POST_INIT(frame)
    frame:SetUserValue("TITLE", "None");

    local thumbnail = GET_CHILD_RECURSIVELY(frame, "thumbnail");
    thumbnail:SetImage("housingbanner");

    local edit_btn = GET_CHILD_RECURSIVELY(frame, "edit_btn");
    local edit_label = GET_CHILD_RECURSIVELY(frame, "edit_label");
    edit_btn:ShowWindow(0);
    edit_label:ShowWindow(0);
    
    local socialinfo = GET_CHILD(frame, "socialinfo");
    local socialinfo_1 = GET_CHILD(socialinfo, "socialinfo_1");
    socialinfo_1:SetTextByKey("value", 0);

    local socialinfo_2 = GET_CHILD(socialinfo, "socialinfo_2");
    socialinfo_2:SetTextByKey("value", 0);

    local socialinfo_3 = GET_CHILD(socialinfo, "socialinfo_3");
    socialinfo_3:SetTextByKey("value", 0);
    
    local desc = GET_CHILD(socialinfo, "desc");
    desc:SetTextByKey("value", " ");
    desc:Resize(desc:GetWidth(), desc:GetLineCount() * 22);

    local pointinfo = GET_CHILD(frame, "pointinfo");
    local pointinfo_1 = GET_CHILD(pointinfo, "pointinfo_1");
    pointinfo_1:SetTextByKey("value", 0);

    local pointinfo_2 = GET_CHILD(pointinfo, "pointinfo_2");
    pointinfo_2:SetTextByKey("value", 0);

    local pointinfo_3 = GET_CHILD(pointinfo, "pointinfo_3");
    pointinfo_3:SetTextByKey("value", 0);

    -- local URL = GET_CHILD_RECURSIVELY(frame, "URL");
    -- URL:SetTextByKey("value", "");
end

function HOUSING_PROMOTE_POST_HOUSE_WARP_BTN_CHECK()
	local mapprop = session.GetCurrentMapProp();
    local mapCls = GetClassByType("Map", mapprop.type);
    
    local frame = ui.GetFrame("housing_promote_post");
    local ctrl = GET_CHILD_RECURSIVELY(frame, "housing_warp_btn");
    if IS_BEAUTYSHOP_MAP(mapCls) == false then
        ctrl:ShowWindow(0);
    else
    	ctrl:ShowWindow(1);
    end
end

function HOUSING_PROMOTE_POST_UPDATE(code, ret_json)
    if code ~= 200 then
        return;
    end

    local parsed = json.decode(ret_json);

    if parsed["thumbnail_id"] ~= nil then
        GetHousingThumbnailImage("HOUSING_PROMOTE_POST_THUMNAIL_UPDATE", parsed["channel_id"], parsed["page_id"], parsed["thumbnail_id"], "None");
    end    

    local frame = ui.GetFrame("housing_promote_post");
    local title = GET_CHILD(frame, "title");
    title:SetTextByKey("value", "");
    title:SetTextByKey("value", parsed["title"]);

    local teamname = GET_CHILD_RECURSIVELY(frame, "teamname");
    teamname:SetTextByKey("value", parsed["team_name"]);
    
    HOUSING_PROMOTE_POST_MY_OPTION_TOGGLE(frame, 0);

    if parsed["socialInfo"] ~= nil then
        local socialInfo = GET_CHILD(frame, "socialInfo");
        HOUSING_PROMOTE_POST_SOCIAL_INFO(socialInfo, parsed["socialInfo"]);
    end

    local desc = GET_CHILD_RECURSIVELY(frame, "desc");
    if parsed["desc"] ~= "" then
        desc:SetTextByKey("value", parsed["desc"]);
    end
    desc:Resize(desc:GetWidth(), desc:GetLineCount() * 22);

    local optioninfo = GET_CHILD(frame, "optioninfo");
    optioninfo:ShowWindow(0);

    local pointinfo = GET_CHILD(frame, "pointinfo");
    pointinfo:ShowWindow(0);
    
    -- local URL = GET_CHILD_RECURSIVELY(frame, "URL");
    -- if parsed["url"] ~= nil then
    --     URL:SetTextByKey("value", parsed["url"]);
    -- end

    local housing_warp_btn = GET_CHILD_RECURSIVELY(frame, "housing_warp_btn");
    housing_warp_btn:SetEventScriptArgString(ui.LBUTTONUP, parsed["channel_id"]);

    frame:ShowWindow(1);

    session.housing.board.OpenPost(parsed["channel_id"]);
end

function HOUSING_PROMOTE_POST_THUMNAIL_UPDATE(code, pageID, filePath)
    if code ~= 200 then
        return;
    end
    
    local folderPath = filefind.GetBinPath("Housing"):c_str()
    local fullPath = folderPath .. "\\" .. filePath;

    local frame = ui.GetFrame("housing_promote_post");
    local thumbnail = GET_CHILD_RECURSIVELY(frame, "thumbnail");
    if filefind.FileExists(fullPath, true) == true then
        ui.SetImageByPath(fullPath, thumbnail);
        thumbnail:Invalidate();
    end

end

function HOUSING_PROMOTE_POST_SOCIAL_INFO(frame, table)
    local socialinfo_1 = GET_CHILD(frame, "socialinfo_1");
    socialinfo_1:SetTextByKey("value", table["total_visitors"]);

    local socialinfo_2 = GET_CHILD(frame, "socialinfo_2");
    socialinfo_2:SetTextByKey("value", table["today_visitors"]);

    local socialinfo_3 = GET_CHILD(frame, "socialinfo_3");
    socialinfo_3:SetTextByKey("value", table["good_point"]);
end

function HOUSING_PROMOTE_POST_POINT_INFO(frame, table)
    local pointinfo_1 = GET_CHILD(frame, "pointinfo_1");
    pointinfo_1:SetTextByKey("value", table["personalHousing_PlaceLV"]);

    local pointinfo_2 = GET_CHILD(frame, "pointinfo_2");
    pointinfo_2:SetTextByKey("value", table["personalHousing_PlacePoint"]);

    local pointinfo_3 = GET_CHILD(frame, "pointinfo_3");
    pointinfo_3:SetTextByKey("value", table["personalHousing_Point1"]);
end

function HOUSING_PROMOTE_POST_MY_OPTION_TOGGLE(frame, value)
    local edit_btn = GET_CHILD_RECURSIVELY(frame, "edit_btn");
    local edit_label = GET_CHILD_RECURSIVELY(frame, "edit_label");
    edit_btn:ShowWindow(value);
    edit_label:ShowWindow(value);

    local pointinfo = GET_CHILD_RECURSIVELY(frame, "pointinfo");
    pointinfo:ShowWindow(value);
end

function HOUSING_PROMOTE_POST_REPORT()
    local frame = ui.GetFrame("housing_promote_report");
    frame:SetUserValue("REPORT_TYPE", "POST");
    frame:ShowWindow(1);    
end

function HOUSING_PROMOTE_POST_URL_CLICK(parent, ctrl)
    local url = ctrl:GetTextByKey("value");
	if url == "None" or url == "" then
		return;
    end
    
    login.OpenURL(url);
end

function HOUSING_PROMOTE_POST_WARP_HOUSE(parent, ctrl, aidx)
    if aidx == "" or aidx == nil then
        return;
    end

    local yesscp = string.format("HOUSING_PROMOTE_POST_REQUEST_POST_HOUST_WARP('%s', 1)", aidx);
    ui.MsgBox(ScpArgMsg("ANSWER_JOIN_PH_1"), yesscp, "None");    
end

function HOUSING_PROMOTE_POST_REQUEST_POST_HOUST_WARP(aidx, type)
    
    housing.RequestPostHouseWarp(aidx, tonumber(type));
end

------------------ 마이 하우스 ------------------
function HOUSING_PROMOTE_POST_EDIT()
    local frame = ui.GetFrame("housing_promote_post");

    local title = frame:GetUserValue("TITLE");
    local team_name = frame:GetUserValue("TEAM_NAME");
    local thumbnail = GET_CHILD_RECURSIVELY(frame, "thumbnail");
    local desc = GET_CHILD_RECURSIVELY(frame, "desc");
    --local URL = GET_CHILD_RECURSIVELY(frame, "URL");

    HOUSING_PROMOTE_WRITE_OPEN(team_name, title, thumbnail:GetImageName(), desc:GetTextByKey("value"), "");
end

function IS_HAS_HOUSING_PROMOTE_POST()
	local housingPlaceClassList, count = GetClassList("Housing_Place");
	if housingPlaceClassList == nil then
		return;
    end	
    
	local accObj = GetMyAccountObj();
	for i = 0, count - 1 do
		local housingPlaceClass = GetClassByIndexFromList(housingPlaceClassList, i);
		local mapClass = GetClass("Map", housingPlaceClass.ClassName);
		local type = TryGetProp(housingPlaceClass, "Type");
        if mapClass ~= nil and type == "Personal" then
            local isHas = TryGetProp(accObj, "PersonalHousing_HasPlace_" .. tostring(mapClass.ClassID), "NO");
            if isHas == "YES" then
                return true;
            end
		end
    end

    return false;
end

function HOUSING_PROMOTE_POST_OPEN_MY_HOUSE()
    -- 하우징 잇는지 없는지 확인
    local ret = IS_HAS_HOUSING_PROMOTE_POST();
    if ret == false then
        ui.MsgBox(ScpArgMsg("PERSONAL_HOUSING_ACTIVE_CHECK_MSG"), "PERSONAL_HOUSING_CREATE_REQUEST", "None");
    else
        local frame = ui.GetFrame("housing_promote_post");

        HOUSING_PROMOTE_POST_CLOSE(frame)
        HOUSING_PROMOTE_POST_INIT(frame);

        local posY = 0;
        local optioninfo_list = GET_CHILD_RECURSIVELY(frame, "optioninfo_list");
        for k, v in pairs(optioninfolist) do
            local ctrl = optioninfo_list:CreateOrGetControlSet("simple_check_list", v, 0, posY);
    
            local text = GET_CHILD(ctrl, "text");
            text:SetTextByKey("value", ClMsg("Housing_Visit_Option_"..v));

            local checkbox = GET_CHILD(ctrl, "checkbox");
            checkbox:SetCheck(0);
            checkbox:SetEventScript(ui.LBUTTONUP, "HOUSING_PROMOTE_POST_VISIT_OPTION_CHANGE_REQUEST");

            posY = posY + ctrl:GetHeight();
        end
        
        local aidx = session.loginInfo.GetAID();
        GetMyHousingPageInfo("HOUSING_PROMOTE_POST_MY_HOUSE_UPDATE", aidx);
    end
end

function PERSONAL_HOUSING_CREATE_REQUEST()
    control.CustomCommand("REQ_CREATE_PERSONAL_HOUSING_DEFAULT", 0);
end

function HOUSING_PROMOTE_POST_MY_HOUSE_UPDATE(code, ret_json)
    if code ~= 200 then
        if code == 404 then
            HOUSING_PROMOTE_POST_MY_HOUSE_NONE_POST();
        end
        return;
    end

    local parsed = json.decode(ret_json);
    
    if parsed["thumbnail_id"] ~=  nil then
        GetHousingThumbnailImage("HOUSING_PROMOTE_POST_THUMNAIL_UPDATE", parsed["channel_id"], parsed["page_id"], parsed["thumbnail_id"], "None");
    end

    local frame = ui.GetFrame("housing_promote_post");
    frame:SetUserValue("TITLE", parsed["title"]);
    frame:SetUserValue("TEAM_NAME", parsed["team_name"]);

    local title = GET_CHILD(frame, "title");
    title:SetTextByKey("value", parsed["title"]);

    local teamname = GET_CHILD_RECURSIVELY(frame, "teamname");
    teamname:SetTextByKey("value", parsed["team_name"]);
    
    HOUSING_PROMOTE_POST_MY_OPTION_TOGGLE(frame, 1);

    if parsed["socialInfo"] ~= nil then
        local socialInfo = GET_CHILD(frame, "socialInfo");
        HOUSING_PROMOTE_POST_SOCIAL_INFO(socialInfo, parsed["socialInfo"]);
    end

    local desc = GET_CHILD_RECURSIVELY(frame, "desc");
    if parsed["desc"] ~= "" then
        desc:SetTextByKey("value", parsed["desc"]);
    end
    desc:Resize(desc:GetWidth(), desc:GetLineCount() * 22);
    
    local optioninfo = GET_CHILD(frame, "optioninfo");
    optioninfo:ShowWindow(1);

    local optioninfo_list = GET_CHILD(optioninfo, "optioninfo_list");
    for k, v in pairs(optioninfolist) do
        local ctrl = GET_CHILD(optioninfo_list, v);

        local checkbox = GET_CHILD(ctrl, "checkbox");
        if parsed["optionInfo"]["visitOptions"][v] == "yes" then
            checkbox:SetCheck(1);
        end
    end
    
    if parsed["pointInfo"] ~= nil then
        local pointinfoCtrl = GET_CHILD(frame, "pointinfo");
        HOUSING_PROMOTE_POST_POINT_INFO(pointinfoCtrl, parsed["pointInfo"]);
    end

    -- local URL = GET_CHILD_RECURSIVELY(frame, "URL");
    -- if parsed["url"] ~= nil then
    --     URL:SetTextByKey("value", parsed["url"]);
    -- end

    local housing_warp_btn = GET_CHILD_RECURSIVELY(frame, "housing_warp_btn");
    housing_warp_btn:SetEventScriptArgString(ui.LBUTTONUP, parsed["channel_id"]);

    frame:ShowWindow(1);
end

function HOUSING_PROMOTE_POST_MY_HOUSE_NONE_POST()
    local frame = ui.GetFrame("housing_promote_post");

    local team_name = info.GetFamilyName(session.GetMyHandle());
    
    local title = GET_CHILD(frame, "title");
    title:SetTextByKey("value", "");

    local teamname = GET_CHILD_RECURSIVELY(frame, "teamname");
    teamname:SetTextByKey("value", team_name);
    
    HOUSING_PROMOTE_POST_MY_OPTION_TOGGLE(frame, 1);

    local optioninfo = GET_CHILD(frame, "optioninfo");
    optioninfo:ShowWindow(1);
    frame:ShowWindow(1);
end

function HOUSING_PROMOTE_POST_VISIT_OPTION_CHANGE_REQUEST()
    local frame = ui.GetFrame("housing_promote_post");
	local timer = GET_CHILD(frame,"addontimer");
	tolua.cast(timer, "ui::CAddOnTimer");
	timer:Stop(); 
	timer:SetUpdateScript("_HOUSING_PROMOTE_POST_VISIT_OPTION_CHANGE_REQUEST");
    timer:Start(0.5, 0); 
end

function _HOUSING_PROMOTE_POST_VISIT_OPTION_CHANGE_REQUEST()
    local frame = ui.GetFrame("housing_promote_post");

    local optionlist = {};
    local optioninfo_list = GET_CHILD_RECURSIVELY(frame, "optioninfo_list");
    local cnt = optioninfo_list:GetChildCount();
	for i = 0, cnt - 1 do
        local ctrl = optioninfo_list:GetChildByIndex(i);
        if ctrl:GetClassName() == "controlset" then
            local checkbox = GET_CHILD(ctrl, "checkbox");
            local checkvalue = "no";
            if checkbox:IsChecked() == 1 then
                checkvalue = "yes";
            end

            optionlist[ctrl:GetName()] = checkvalue;
        end
    end
    
    local aidx = session.loginInfo.GetAID();
    SetHousingVisitOption("HOUSING_PROMOTE_POST_VISIT_OPTION_CHANGE", aidx, optionlist["all"], optionlist["friend"], optionlist["guild"], optionlist["block"])
end

function HOUSING_PROMOTE_POST_VISIT_OPTION_CHANGE(code, ret_json)
    if code ~= 200 then
        return;
    end
    
    local frame = ui.GetFrame("housing_promote_post");
    local timer = GET_CHILD(frame,"addontimer");
    tolua.cast(timer, "ui::CAddOnTimer");
    timer:Stop(); 

    ui.MsgBox(ClMsg("PERSONAL_HOUSING_VISIT_OPTION_SET_SUCCESS"));
end