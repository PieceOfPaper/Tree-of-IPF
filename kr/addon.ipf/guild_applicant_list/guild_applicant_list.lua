
local json = require "json"
local applicant_list = {}
local selected_applicant = nil
local textBox = nil
local acceptBtn = nil
local declineBtn = nil
function GUILD_APPLICANT_INIT(addon, frame)
    local frame = ui.GetFrame("guild_applicant_list");
    textBox = GET_CHILD_RECURSIVELY(frame, "textBox");
    acceptBtn = GET_CHILD_RECURSIVELY(frame, "acceptBtn")
    declineBtn = GET_CHILD_RECURSIVELY(frame, "declineBtn")
    SET_ACCEPT_DECLINEBTN_ENABLE(0)
    local scrollPanel = GET_CHILD_RECURSIVELY(frame, "resumeList");
    scrollPanel:RemoveAllChild()
    GetGuildApplicationList("ON_GUILD_APPLICANT_GET")
end

function ON_GUILD_APPLICANT_GET(_code, ret_json)
    selected_applicant = nil
    local splitmsg = StringSplit(ret_json, " ");
    local errorCode = splitmsg[1];
    if _code ~= 200 then
        if tonumber(errorCode) == 1 then
            return;
        end
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "ON_GUILD_APPLICANT_GET")
        return
    end
    local parsed_json = json.decode(ret_json)
    local parsed_json = json.decode(ret_json)
    local frame = ui.GetFrame("guild_applicant_list");
    local scrollPanel = GET_CHILD_RECURSIVELY(frame, "resumeList");
    local i=0;
    local lastApplicant = nil
    for k, v in pairs(parsed_json) do
        for x, y in pairs(v) do
            if y['is_accept'] == 0 then
                local row = scrollPanel:CreateOrGetControlSet("selective_richtext", x, 0, 0);

                row = tolua.cast(row, 'ui::CControlSet');
                lastApplicant = row;
                row:SetEventScript(ui.LBUTTONUP, 'SHOW_APPLICANT_MESSAGE');
                row:SetUserValue("account_idx", y['account_idx'])
                row:SetUserValue("account_team_name", y['account_team_name'])
                local NOT_SELECTED_BOX_SKIN = row:GetUserConfig('NOT_SELECTED_BOX_SKIN');               
                local bg = GET_CHILD(row, "skinBox");
                if i % 2 == 0 then
                    bg:SetSkinName(NOT_SELECTED_BOX_SKIN);
                end
                local infoText = GET_CHILD(row, 'infoText')
                infoText:SetTextByKey("name", y['account_team_name'])
                GBOX_AUTO_ALIGN(scrollPanel, 0, 0, 0, true, false)
                local txtToJson = json.decode(y['msg_text']);
                textBox:SetTextByKey("teamlevel", txtToJson['team_lv'])
                textBox:SetTextByKey("charnum", txtToJson['character_count'])
                textBox:SetTextByKey("adventureRank", txtToJson['adventure_rank'])
                textBox:SetTextByKey("application_character_lv", txtToJson['application_character_lv'])

                local commentBox = GET_CHILD_RECURSIVELY(frame, "commentText")
                commentBox:SetText(txtToJson['msg_text']);
                applicant_list[y['account_idx']] = y['msg_text'];
                frame:ShowWindow(1);
                i = i + 1;
            end
        end
    end
    if lastAppliant ~= nil then
        local selectedSkin = lastAppliant:GetUserConfig("SELECTED_BOX_SKIN")
        local bg = GET_CHILD(lastAppliant, "skinBox");
        selected_applicant = lastAppliant;
        bg:SetSkinName(selectedSkin)
    end

end

function SHOW_APPLICANT_MESSAGE(parent, control)
    control =  tolua.cast(control, 'ui::CControlSet');
    local unselectedSkin = control:GetUserConfig("NOT_SELECTED_BOX_SKIN")
    local selectedSkin = control:GetUserConfig("SELECTED_BOX_SKIN")
    
    if selected_applicant ~= nil then
        previousSkinbox = GET_CHILD(selected_applicant, "skinBox")
        previousSkinbox:SetSkinName(unselectedSkin);
    end
    selected_applicant = control;
    if applicant_list ~= nil and textBox ~= nil then
        local skinBox = GET_CHILD(control, "skinBox")
        skinBox:SetSkinName(selectedSkin)
        local idx = control:GetUserValue('account_idx');
        local textToJson = json.decode(applicant_list[idx])
        textBox:SetTextByKey("teamlevel", textToJson['team_lv'])
        textBox:SetTextByKey("charnum", textToJson['character_count'])
        textBox:SetTextByKey("adventureRank", textToJson['adventure_rank'])
        textBox:SetTextByKey("application_character_lv", textToJson['application_character_lv'])
        local frame = ui.GetFrame("guild_applicant_list")
        local commentBox = GET_CHILD_RECURSIVELY(frame, "commentText")
        commentBox:SetText(textToJson['msg_text']);

        SET_ACCEPT_DECLINEBTN_ENABLE(1)
    end

end

function ACCEPT_APPLICANT(parent, control)
    if selected_applicant ~= nil then
        ApplicationUserGuildJoin(selected_applicant:GetUserValue('account_idx'), selected_applicant:GetUserValue('account_team_name'));
        REMOVE_APPLICANT_RESUME();
    end
end

function APPLICANT_ACCEPTED(code, ret_json)
    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "APPLICANT_ACCEPTED")
        return;
    end
   
    ui.MsgBox("길드 가입이 정상적으로 처리되었습니다.")
  
end

function DECLINE_APPLICANT(parent, control)
    if selected_applicant ~= nil then
        RefuseUserApplication("DECLINE_APPLICANT_CB", selected_applicant:GetUserValue('account_idx'));
    end
end

function DECLINE_APPLICANT_CB(code, ret_json)
    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "DECLINE_APPLICANT")
        return;
    end
    ui.MsgBox("정상적으로 삭제 처리되었습니다")
    REMOVE_APPLICANT_RESUME();
end

function REMOVE_APPLICANT_RESUME()

    local frame = ui.GetFrame("guild_applicant_list");
    local scrollPanel = GET_CHILD_RECURSIVELY(frame, "resumeList");
    scrollPanel:RemoveChild(selected_applicant:GetName());
    selected_applicant = nil;
    textBox:SetText("");
    
    SET_ACCEPT_DECLINEBTN_ENABLE(0)

    if scrollPanel:GetChildCount() == 1 then
        ui.CloseFrame("guild_applicant_list");
    end
end

function SET_ACCEPT_DECLINEBTN_ENABLE(enable)

    acceptBtn:SetEnable(enable)
    declineBtn:SetEnable(enable)
end
