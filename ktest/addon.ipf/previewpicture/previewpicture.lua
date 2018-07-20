local json = require "json"

function PREVIEW_PROMO_PIC_INIT()
    
    local guild = GET_MY_GUILD_INFO();
    if guild == nil then
        return;
    end
    myGuildID = guild.info:GetPartyID();

    GetIntroductionImage("SET_PROMOTION_IMAGE", myGuildID);
end

function SET_PROMOTION_IMAGE(code, ret_json)
    if code ~= 200 then
        if code ~= 400 then
            SHOW_GUILD_HTTP_ERROR(code, ret_json, "SET_PROMOTION_IMAGE")
        end
        return;
    end

    local frame = ui.GetFrame("previewpicture");
    local promoPic = GET_CHILD_RECURSIVELY(frame, "previewpic");

    promoPic = tolua.cast(promoPic, "ui::CPicture");

    local introPath = filefind.GetBinPath("GuildIntroImage"):c_str()
    introPath = introPath .. "\\" .. ret_json .. ".png"
    promoPic:SetImage("")
    promoPic:SetFileName(introPath)
    promoPic:Resize(promoPic:GetImageWidth(), promoPic:GetImageHeight())
end