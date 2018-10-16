
function MON_GUILD_HUD_ON_INIT(addon, frame)
	addon:RegisterMsg('UPDATE_MON_GUILD_HUD', 'ON_UPDATE_MON_GUILD_HUD');
end

function ON_UPDATE_MON_GUILD_HUD(frame, msg, strarg, numarg)
    local pic = GET_CHILD(frame, "emblemPic");
    -- change color?
end

--static function 
function GET_MON_GUILD_HUD_FRAME_NAME(handle)
    local frameName = "mon_guild_hud_"..tostring(handle);
    return frameName;
end

function CREATE_MON_GUILD_HUD(handle)
	local actor = world.GetActor(handle);
    if actor == nil then
        return;
	end
    
    local frameName = GET_MON_GUILD_HUD_FRAME_NAME(handle)
    local frame = ui.GetFrame(frameName);
    if frame == nil then
        frame = ui.CreateNewFrame("mon_guild_hud", frameName);
    else
        actor:GetTitle():RemoveBuffSellerBalloonFrame(frameName);
    end
    local offsetY = tonumber(frame:GetUserConfig("OffsetY"));
    actor:GetTitle():AddBuffSellerBalloonFrame(frameName, "TOP", offsetY);
end

function DESTROY_MON_GUILD_HUD(handle)
    local frameName = GET_MON_GUILD_HUD_FRAME_NAME(handle)
    local frame = ui.GetFrame(frameName);
    if nil ~= frame then
        ui.CloseFrame(frameName)
        ui.DestroyFrame(frameName);
    end
end