
local json = require "json_imc"
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
                
                local charNumText = GET_CHILD_RECURSIVELY(row, 'charNumText');
                charNumText:SetTextByKey("charnum", txtToJson['character_count'])

                local adventureRankText = GET_CHILD_RECURSIVELY(row, 'adventureRankText');
                local rankNumber = tonumber(txtToJson['adventure_rank'])
                rankNumber = rankNumber + 1;

                if rankNumber == 0 then -- 실제 순위보다 1 작은 값이 뜸. ex. 순위에 없을 경우 -1

                    rankNumber = ClMsg("NONE")
                end
                adventureRankText:SetTextByKey("adventureRank", rankNumber) 

                local commentText = GET_CHILD_RECURSIVELY(row, 'commentText');
                commentText:SetTextByKey("comment", txtToJson['msg_text'])
                commentText:SetTextTooltip(txtToJson['msg_text'])

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

function GUILDINFO_APPLICANT_GUILD_ON_WAR()
    local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        return false
    end
    local enemyParty = guild.info:GetEnemyPartyCount();
    if enemyParty ~= 0 then
        return true
    else 
        return false
    end
end

function ACCEPT_APPLICANT(parent, control)
    if GUILDINFO_APPLICANT_GUILD_ON_WAR() == true then
        ui.SysMsg(ClMsg('CannotJoinWhileGuildWar'))
        return;
    end
    selected_applicant = control:GetAboveControlset();
    ApplicationUserGuildJoin(control:GetUserValue('account_idx'), control:GetUserValue('account_team_name'));
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
    GBOX_AUTO_ALIGN(scrollPanel, 0, 0, 45, true, false, true)
end

function ACCEPT_SELECTED_USER()
    if GUILDINFO_APPLICANT_GUILD_ON_WAR() == true then
        ui.SysMsg(ClMsg('CannotJoinWhileGuildWar'))
        return;
    end
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