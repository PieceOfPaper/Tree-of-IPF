VIDEOCAMERA_TEST = {}
curBtn = nil
function VIDEOCAMERA_ON_INIT(addon, frame)
    
    VIDEOCAMERA_TEST['toggle'] = 0
    VIDEOCAMERA_TEST['hide_mychar'] = 0
    VIDEOCAMERA_TEST['fog'] = 1
    VIDEOCAMERA_TEST['env_effect'] = 1
    VIDEOCAMERA_TEST['horzSpeed'] = 1000;
    VIDEOCAMERA_TEST['vertSpeed'] = 1000;
    VIDEOCAMERA_TEST['zoomSpeed'] = 1000;

    VIDEOCAMERA_TEST['freeCamHorzSpeed'] = 1000;
    VIDEOCAMERA_TEST['freeCamVertSpeed'] = 1000;
    VIDEOCAMERA_TEST['freeCamZoomSpeed'] = 1000;
    VIDEOCAMERA_TEST['freeCamArcHorzSpeed'] = 100;
    VIDEOCAMERA_TEST['freeCamArcVertSpeed'] = 100;

    frame:Resize(frame:GetUserConfig('TOGGLE_WIDTH_OFF'), frame:GetUserConfig('TOGGLE_HEIGHT_OFF'));
end

function VIDEOCAMERA_OPEN(frame)
    if 1 ~= session.IsGM() then
        ui.CloseFrame("videocamera");
    end
end

function VIDEOCAMERA_TOGGLE(frame)
    if VIDEOCAMERA_TEST['toggle'] == 0 then
        VIDEOCAMERA_TEST['toggle'] = 1;
        frame:Resize(frame:GetOriginalWidth(), frame:GetOriginalHeight());
        VIDEOCAMERA_INIT_CONFIG(frame)
    else
        VIDEOCAMERA_TEST['toggle'] = 0;
        frame:Resize(frame:GetUserConfig('TOGGLE_WIDTH_OFF'), frame:GetUserConfig('TOGGLE_HEIGHT_OFF'));
    end
end


function VIDEOCAMERA_SPEED_TO_SLIDER(value)
    return  value / 1000 * 255;
end

function VIDEOCAMERA_SLIDER_TO_SPEED(value)
    return  value / 255 * 1000;
end

function VIDEOCAMERA_INIT_CONFIG(frame)
    curBtn = nil;

    VIDEOCAMERA_TEST['horzSpeed'] = camera.GetVideoCamHorzSpeed();
    VIDEOCAMERA_TEST['vertSpeed'] = camera.GetVideoCamVertSpeed();
    VIDEOCAMERA_TEST['zoomSpeed'] = camera.GetVideoCamZoomSpeed();

    VIDEOCAMERA_TEST['freeCamHorzSpeed'] = camera.GetFreeCamHorzSpeed();
    VIDEOCAMERA_TEST['freeCamVertSpeed'] = camera.GetFreeCamVertSpeed();
    VIDEOCAMERA_TEST['freeCamZoomSpeed'] = camera.GetFreeCamZoomSpeed();
    VIDEOCAMERA_TEST['freeCamArcHorzSpeed'] = camera.GetFreeCamArcHorzSpeed();
    VIDEOCAMERA_TEST['freeCamArcVertSpeed'] = camera.GetFreeCamArcVertSpeed();

    SET_SLIDE_VAL(frame, "horzSpeedSlide", "horzSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetVideoCamHorzSpeed()));
	SET_SLIDE_VAL(frame, "vertSpeedSlide", "vertSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetVideoCamVertSpeed()));
    SET_SLIDE_VAL(frame, "zoomSpeedSlide", "zoomSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetVideoCamZoomSpeed()));
    
    SET_SLIDE_VAL(frame, "freeHorzSpeedSlide", "freeHorzSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetFreeCamHorzSpeed()));
	SET_SLIDE_VAL(frame, "freeVertSpeedSlide", "freeVertSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetFreeCamVertSpeed()));
	SET_SLIDE_VAL(frame, "freeZoomSpeedSlide", "freeZoomSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetFreeCamZoomSpeed()));
	SET_SLIDE_VAL(frame, "freeArcHorzSpeedSlide", "freeArcHorzSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetFreeCamArcHorzSpeed()));
    SET_SLIDE_VAL(frame, "freeArcVertSpeedSlide", "freeArcVertSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetFreeCamArcVertSpeed()));
    
end

function VIDEOCAMERA_CONFIG_HORZ(frame, ctrl, str, num)

    tolua.cast(ctrl, "ui::CSlideBar");
    local value = ctrl:GetLevel();
    VIDEOCAMERA_TEST['horzSpeed'] = VIDEOCAMERA_SLIDER_TO_SPEED(value)
    
    VIDEOCAMERA_SET_MOVE_SPEED()

    SET_SLIDE_VAL(frame, "horzSpeedSlide", "horzSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetVideoCamHorzSpeed()));
end

function VIDEOCAMERA_CONFIG_VERT(frame, ctrl, str, num)
    tolua.cast(ctrl, "ui::CSlideBar");
    local value = ctrl:GetLevel();
    VIDEOCAMERA_TEST['vertSpeed'] = VIDEOCAMERA_SLIDER_TO_SPEED(value)
    VIDEOCAMERA_SET_MOVE_SPEED()

    SET_SLIDE_VAL(frame, "vertSpeedSlide", "vertSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetVideoCamVertSpeed()));
end

function VIDEOCAMERA_CONFIG_ZOOM(frame, ctrl, str, num)
    tolua.cast(ctrl, "ui::CSlideBar");
    local value = ctrl:GetLevel();
    VIDEOCAMERA_TEST['zoomSpeed'] = VIDEOCAMERA_SLIDER_TO_SPEED(value)
    VIDEOCAMERA_SET_MOVE_SPEED()

    SET_SLIDE_VAL(frame, "zoomSpeedSlide", "zoomSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetVideoCamZoomSpeed()));
end

function VIDEOCAMERA_MYCHAR_HIDE(parent, btn)

    if VIDEOCAMERA_TEST['hide_mychar'] == 0  then
        VIDEOCAMERA_TEST['hide_mychar'] = 1
        debug.DisableRenderMyPC()
        btn:SetTextByKey("value", "ON");
    else
        VIDEOCAMERA_TEST['hide_mychar'] = 0
        debug.EnableRenderMyPC()
        btn:SetTextByKey("value", "OFF");    
    end 
end

function VIDEOCAMERA_MODEL_CAM_EXEC(parent, btn)
    
    if VIDEOCAMERA_TEST['mode'] == 0 or VIDEOCAMERA_TEST['mode'] == 2 then
        VIDEOCAMERA_TEST['mode'] = 1
        camera.ChangeCameraType(4); -- CT_VIDEO
        camera.SetCameraWorkingMode(true);
        btn:SetTextByKey("value", "ON");
        if curBtn == nil then
            curBtn = btn
        elseif curBtn ~= btn then
            curBtn:SetTextByKey("value", "OFF");    
            curBtn = btn
        end
    else
        VIDEOCAMERA_TEST['mode'] = 0
        camera.ChangeCameraType(0); -- CT_BIND
        camera.SetCameraWorkingMode(false);
        btn:SetTextByKey("value", "OFF");    
    end
end


function VIDEOCAMERA_FREE_CAM_EXEC(parent, btn)
    
    if VIDEOCAMERA_TEST['mode'] == 0 or VIDEOCAMERA_TEST['mode'] == 1 then
        VIDEOCAMERA_TEST['mode'] = 2
        camera.ChangeCameraType(5); -- CT_FREE
        camera.SetCameraWorkingMode(true);
        btn:SetTextByKey("value", "ON");
        if curBtn == nil then
            curBtn = btn
        elseif curBtn ~= btn then
            curBtn:SetTextByKey("value", "OFF");    
            curBtn = btn
        end
    else
        VIDEOCAMERA_TEST['mode'] = 0
        camera.ChangeCameraType(0); -- CT_BIND
        camera.SetCameraWorkingMode(false);
        btn:SetTextByKey("value", "OFF");    
        curBtn = btn;
    end
end

function VIDEOCAMERA_FOG(parent, btn)
    
    if VIDEOCAMERA_TEST['fog'] == 0  then
        VIDEOCAMERA_TEST['fog'] = 1
        debug.EnableGraphicOption(true);
        btn:SetTextByKey("value", "OFF");
    else
        VIDEOCAMERA_TEST['fog'] = 0
        debug.EnableGraphicOption(false);
        btn:SetTextByKey("value", "ON");    
    end
end

function VIDEOCAMERA_ENV_EFFECT(parent, btn)
    
    if VIDEOCAMERA_TEST['env_effect'] == 0  then
        VIDEOCAMERA_TEST['env_effect'] = 1
        debug.EnableEnvEffect(true);
        btn:SetTextByKey("value", "OFF");
    else
        VIDEOCAMERA_TEST['env_effect'] = 0
        debug.EnableEnvEffect(false);
        btn:SetTextByKey("value", "ON");    
    end
end

function VIDEOCAMERA_SET_MOVE_SPEED()
    local horz =  VIDEOCAMERA_TEST['horzSpeed'];
    local vert =  VIDEOCAMERA_TEST['vertSpeed'];
    local zoom =  VIDEOCAMERA_TEST['zoomSpeed'];
   
    camera.SetVideoCamMoveSpeed(horz, vert,zoom );
end

function VIDEOCAMERA_FREE_CONFIG_HORZ(frame, ctrl, str, num)
    tolua.cast(ctrl, "ui::CSlideBar");
    local value = ctrl:GetLevel();
    VIDEOCAMERA_TEST['freeCamHorzSpeed'] = VIDEOCAMERA_SLIDER_TO_SPEED(value)
    VIDEOCAMERA_SET_FREECAM_MOVE_SPEED()

    SET_SLIDE_VAL(frame, "freeHorzSpeedSlide", "freeHorzSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetFreeCamHorzSpeed()));
end


function VIDEOCAMERA_FREE_CONFIG_VERT(frame, ctrl, str, num)
    tolua.cast(ctrl, "ui::CSlideBar");
    local value = ctrl:GetLevel();
    VIDEOCAMERA_TEST['freeCamVertSpeed'] = VIDEOCAMERA_SLIDER_TO_SPEED(value)
    VIDEOCAMERA_SET_FREECAM_MOVE_SPEED()

    SET_SLIDE_VAL(frame, "freeVertSpeedSlide", "freeVertSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetFreeCamVertSpeed()));
end

function VIDEOCAMERA_FREE_CONFIG_ZOOM(frame, ctrl, str, num)
    tolua.cast(ctrl, "ui::CSlideBar");
    local value = ctrl:GetLevel();
    VIDEOCAMERA_TEST['freeCamZoomSpeed'] = VIDEOCAMERA_SLIDER_TO_SPEED(value)
    VIDEOCAMERA_SET_FREECAM_MOVE_SPEED()

    SET_SLIDE_VAL(frame, "freeZoomSpeedSlide", "freeZoomSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetFreeCamZoomSpeed()));
end

function VIDEOCAMERA_FREE_CONFIG_ARC_HORZ(frame, ctrl, str, num)
    tolua.cast(ctrl, "ui::CSlideBar");
    local value = ctrl:GetLevel();
    VIDEOCAMERA_TEST['freeCamArcHorzSpeed'] = VIDEOCAMERA_SLIDER_TO_SPEED(value)
    VIDEOCAMERA_SET_FREECAM_MOVE_SPEED()

    SET_SLIDE_VAL(frame, "freeArcHorzSpeedSlide", "freeArcHorzSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetFreeCamArcHorzSpeed()));
end

function VIDEOCAMERA_FREE_CONFIG_ARC_VERT(frame, ctrl, str, num)
    tolua.cast(ctrl, "ui::CSlideBar");
    local value = ctrl:GetLevel();
    VIDEOCAMERA_TEST['freeCamArcVertSpeed'] = VIDEOCAMERA_SLIDER_TO_SPEED(value)
    VIDEOCAMERA_SET_FREECAM_MOVE_SPEED()

    SET_SLIDE_VAL(frame, "freeArcVertSpeedSlide", "freeArcVertSpeed_text", VIDEOCAMERA_SPEED_TO_SLIDER(camera.GetFreeCamArcVertSpeed()));
end


function VIDEOCAMERA_SET_FREECAM_MOVE_SPEED()
    local horz =  VIDEOCAMERA_TEST['freeCamHorzSpeed'];
    local vert =  VIDEOCAMERA_TEST['freeCamVertSpeed'];
    local zoom =  VIDEOCAMERA_TEST['freeCamZoomSpeed'];

    local arcHorz =  VIDEOCAMERA_TEST['freeCamArcHorzSpeed'];
    local arcVert =  VIDEOCAMERA_TEST['freeCamArcVertSpeed'];
 
   camera.SetFreeCamMoveSpeed(horz, vert,zoom );
   camera.SetFreeCamArcSpeed(arcHorz, arcVert);
end
