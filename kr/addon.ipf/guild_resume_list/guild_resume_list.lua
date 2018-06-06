
local json = require "json"
local appliedGuildList = {}
function GUILD_RESUME_ON_INIT(addon, frame)
    appliedGuildList = {}
    GetUserApplicationList("ON_GUILD_RESUME_GET")
end

function ON_GUILD_RESUME_GET(_code, ret_json)
    if _code ~= 200 then
        ui.MsgBox('error : ' .. _code .. "msg:" .. ret_json);
        return
    end
    local parsed_json = json.decode(ret_json)
    parsed_json = json.decode(ret_json)
    local frame = ui.GetFrame("guild_resume_list");
    local scrollPanel = GET_CHILD_RECURSIVELY(frame, "resumeList");
    scrollPanel:RemoveAllChild();
    local i=0;
    local ret = ""
    for k, v in pairs(parsed_json) do

        local row = scrollPanel:CreateOrGetControlSet("guild_join_sent", k, 0, 0);
        row:Resize(scrollPanel:GetWidth(), 50)

        local guildName = GET_CHILD_RECURSIVELY(row, "column1");
        guildName:SetText(v['guild_name'])

        local date = GET_CHILD_RECURSIVELY(row, "column2");
        date:SetText(v['reg_time']);

        local hasRead = GET_CHILD_RECURSIVELY(row, "column3");
        local read = "읽음"
        local result = v['is_accept']
        if result == 0 then
            read = "읽지않음"
        elseif result == 1 then
            read = "거절"
        elseif result == 2 then
            read = "수락"
        end
        hasRead:SetText(read);

        appliedGuildList[v['guild_idx']] = result;
    end
end

function GET_GUILD_APPLICATION_LIST_JSONDATA()
    return appliedGuildList;
end