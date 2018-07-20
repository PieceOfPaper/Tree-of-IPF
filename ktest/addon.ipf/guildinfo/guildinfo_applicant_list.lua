
local json = require "json"
local applicant_list = {}
local selected_applicant = nil
function GUILD_APPLICANT_INIT(addon, frame)
    local frame = ui.GetFrame("guildinfo")
    applicant_list = {}
    selected_applicant = nil
    local scrollPanel = GET_CHILD_RECURSIVELY(frame, "applicantMemberListBox");
    scrollPanel:RemoveAllChild()
    GetGuildApplicationList("ON_GUILD_APPLICANT_GET")

end

function ON_GUILD_APPLICANT_GET(_code, ret_json)
    applicant_list = {}
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
    local frame = ui.GetFrame("guildinfo");
    local scrollPanel = GET_CHILD_RECURSIVELY(frame, "applicantMemberListBox");


    for k, v in pairs(parsed_json) do
        for x, y in pairs(v) do
            if y['is_accept'] == 0 then
                local txtToJson = json.decode(y['msg_text']);
                
                local row = scrollPanel:CreateOrGetControlSet("guild_applicant_info", x, 0, 0);
                row:SetUserValue('account_idx', y['account_idx'])
                row:SetUserValue('account_team_name', y['account_team_name'])
            
                local teamName = GET_CHILD_RECURSIVELY(row, 'applicant_name_text');
                teamName:SetTextByKey('name', y['account_team_name'])

                local charlevel = GET_CHILD_RECURSIVELY(row, 'charLevelText');
                charlevel:SetTextByKey("charlevel", txtToJson['application_character_lv']);

                local teamLevel = GET_CHILD_RECURSIVELY(row, 'teamLevelText');
                teamLevel:SetTextByKey("teamlvl", txtToJson['team_lv'])
                
                local teamLevel = GET_CHILD_RECURSIVELY(row, 'charNumText');
                teamLevel:SetTextByKey("charnum", txtToJson['character_count'])

                local teamLevel = GET_CHILD_RECURSIVELY(row, 'adventureRankText');
                teamLevel:SetTextByKey("adventureRank", txtToJson['adventure_rank'])

                local teamLevel = GET_CHILD_RECURSIVELY(row, 'commentText');
                teamLevel:SetTextByKey("comment", txtToJson['msg_text'])
                teamLevel:SetTextTooltip(txtToJson['msg_text'])

                local acceptBtn = GET_CHILD_RECURSIVELY(row, 'acceptJoinBtn')
                acceptBtn:SetUserValue('account_idx', y['account_idx'])
                acceptBtn:SetUserValue('account_team_name', y['account_team_name'])
                local declineBtn = GET_CHILD_RECURSIVELY(row, 'refuseJoinBtn')
                declineBtn:SetUserValue('account_idx', y['account_idx'])
                declineBtn:SetUserValue('account_team_name', y['account_team_name'])
            end
        end
    end

    GBOX_AUTO_ALIGN(scrollPanel, 0, 0, 45, true, false, true)
end


function ACCEPT_APPLICANT(parent, control)
    selected_applicant = control:GetAboveControlset();
    ApplicationUserGuildJoin(control:GetUserValue('account_idx'), control:GetUserValue('account_team_name'));
    ui.MsgBox("길드 가입이 정상적으로 처리되었습니다.")
    REMOVE_APPLICANT_RESUME();
end

function DECLINE_APPLICANT(parent, control)
    selected_applicant = control:GetAboveControlset();
    RefuseUserApplication("DECLINE_APPLICANT_CB", control:GetUserValue('account_idx'));
end
function DECLINE_APPLICANT_CB(code, ret_json)
    if code ~= 200 then
        SHOW_GUILD_HTTP_ERROR(code, ret_json, "DECLINE_APPLICANT")
        return;
    end
    REMOVE_APPLICANT_RESUME();
end
function REMOVE_APPLICANT_RESUME()
    local frame = ui.GetFrame("guildinfo");
    local scrollPanel = GET_CHILD_RECURSIVELY(frame, "applicantMemberListBox");
    scrollPanel:RemoveChild(selected_applicant:GetName());
    selected_applicant = nil;
end

function ACCEPT_SELECTED_USER()
    local frame = ui.GetFrame("guildinfo");
    local scrollPanel = GET_CHILD_RECURSIVELY(frame, "applicantMemberListBox");
    
    local childCount = scrollPanel:GetChildCount();
    local removingIndex = {}
    for i = 0, childCount - 1 do
        local ctrlSet = scrollPanel:GetChildByIndex(i);
        if ctrlSet:GetClassName() == "controlset" then
            local checkbox = GET_CHILD_RECURSIVELY(ctrlSet, "selectCheckbox");
            checkbox = tolua.cast(checkbox, "ui::CCheckBox")
            if checkbox:IsChecked() == 1 then
                ApplicationUserGuildJoin(ctrlSet:GetUserValue('account_idx'), ctrlSet:GetUserValue('account_team_name'));
                removingIndex[i] = ctrlSet:GetName();
            end
        end
    end
    for k, v in pairs(removingIndex) do
        scrollPanel:RemoveChild(v);
    end

    GBOX_AUTO_ALIGN(scrollPanel, 0, 0, 45, true, false, true)

end

function DECLINE_SELECTED_USER()
    local frame = ui.GetFrame("guildinfo");
    local scrollPanel = GET_CHILD_RECURSIVELY(frame, "applicantMemberListBox");
    
    local childCount = scrollPanel:GetChildCount();
    local removingIndex = {}
    for i = 0, childCount - 1 do
        local ctrlSet = scrollPanel:GetChildByIndex(i);
        if ctrlSet:GetClassName() == "controlset" then
            local checkbox = GET_CHILD_RECURSIVELY(ctrlSet, "selectCheckbox");
            checkbox = tolua.cast(checkbox, "ui::CCheckBox")
            if checkbox:IsChecked() == 1 then
                RefuseUserApplication("None", ctrlSet:GetUserValue('account_idx'));
                removingIndex[i] = ctrlSet:GetName();
            end
        end
    end
    for k, v in pairs(removingIndex) do
        scrollPanel:RemoveChild(v);
    end
    GBOX_AUTO_ALIGN(scrollPanel, 0, 0, 45, true, false, true)
end