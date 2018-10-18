
function GUILD_VEHICLE_ON_INIT(addon, frame)
	addon:RegisterMsg('UPDATE_GUILD_VEHICLE', 'ON_UPDATE_GUILD_VEHICLE');
end

function ON_UPDATE_GUILD_VEHICLE(frame, msg, strarg, numarg)

end

function ON_OPEN_GUILD_VEHICLE(frame)
end

function UPDATE_GUILD_VEHICLE_RIDER_LIST(frame, list, listcnt)
    local w = frame:GetUserConfig("SeatWidth");
    local h = frame:GetUserConfig("SeatHeight");

    local bg = GET_CHILD(frame, "bg");
    for i=1, listcnt do
        local handle = list[i];
        local imgName = GET_GUILD_VEHICLE_SEAT_IMG_NAME(frame, i, handle)
        local pic = bg:CreateOrGetControl("picture", "pic_seat_"..i, (i-1)*w, 0, w, h);
        AUTO_CAST(pic);
        pic:SetImage(imgName);
        pic:SetEnableStretch(1);
    end
    print(w, listcnt)
    bg:Resize(w*listcnt, bg:GetOriginalHeight())
    frame:Resize(w*listcnt, frame:GetOriginalHeight())
    frame:Invalidate()
end

--static function 
function GET_GUILD_VEHICLE_FRAME_NAME(handle)
    local frameName = "guild_vehicle_"..tostring(handle);
    return frameName;
end

function CREATE_GUILD_VEHICLE_FRAME(handle, list, listcnt)
	local actor = world.GetActor(handle);
    if actor == nil then
        return;
	end
    
    local frameName = GET_GUILD_VEHICLE_FRAME_NAME(handle)
    local frame = ui.GetFrame(frameName);
    if frame == nil then
        frame = ui.CreateNewFrame("guild_vehicle", frameName);
        local offsetY = tonumber(frame:GetUserConfig("OffsetY"));
        actor:GetTitle():AddBuffSellerBalloonFrame(frameName, "TOP", offsetY);
        --frame:SetVisible(1);
    end
    UPDATE_GUILD_VEHICLE_RIDER_LIST(frame, list, listcnt);
end

function DESTROY_GUILD_VEHICLE_FRAME(handle)
    local frameName = GET_GUILD_VEHICLE_FRAME_NAME(handle)
    local frame = ui.GetFrame(frameName);
    if nil ~= frame then
        --frame:SetVisible(0);
        ui.CloseFrame(frameName)
        ui.DestroyFrame(frameName);
    end
end

function GET_GUILD_VEHICLE_SEAT_IMG_NAME(frame, index, handle)
    local cfgName = "";
    if index == 1 then
        cfgName = "ImgHandle";
    else
        cfgName = "ImgAttack";
    end
    if handle == 0 then
        cfgName = cfgName .. "Nobody";
    elseif handle == session.GetMyHandle() then
        cfgName = cfgName .. "Me";
    else
        cfgName = cfgName .. "Another";
    end
    return frame:GetUserConfig(cfgName);
end

function GET_GUILD_VEHICLE_RIDE_STATE(monHandle)
	local actor = world.GetActor(monHandle);
    if actor == nil then
        return 0;
	end
    
    local frameName = GET_GUILD_VEHICLE_FRAME_NAME(monHandle)
    local frame = ui.GetFrame(frameName);
    if frame == nil then
        return 0;
    end
    
    local bg = GET_CHILD(frame, "bg");
    local listcnt = GET_CHILD_CNT_BYNAME(bg, "pic_seat_");
    for i=1, listcnt do
        local imgName = GET_GUILD_VEHICLE_SEAT_IMG_NAME(frame, i, session.GetMyHandle())
        local pic = GET_CHILD(bg, "pic_seat_"..i);
        if pic:GetImageName() == imgName then
            return 1;
        end
    end
    return 0;
end
