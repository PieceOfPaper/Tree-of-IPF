--bgm music player reduciton ui
function BGMPLAYER_REDUCTION_ON_INIT(addon, frame)
	BGMPLAYER_REDUCTION_SET_TITLE("");

    if IsBgmPlayerReductionFrameVisible() == 1 then
        ui.OpenFrame("bgmplayer_reduction"); 
        BGMPLAYER_REDUCTION_INIT_SKIN(frame);
        BGMPLAYER_FRAME_SET_POS(frame);
        
        local bgmplayer_frame = ui.GetFrame("bgmplayer");
        if bgmplayer_frame ~= nil then
            BGMPLAYER_PRE_CHECK_CTRL(bgmplayer_frame);
            BGMPLAYER_INIT_SELECTCTRLSET(bgmplayer_frame);
            BGMPLAYER_REDUCTION_INIT_SET_TITLE(bgmplayer_frame);
            LoadFavoritesBgmList();
            SaveFavoritesBgmList();
        end
    end
end

function BGMPLAYER_REDUCTION_INIT_SET_TITLE(frame)
    if frame == nil then return; end
    local title = GET_CHILD_RECURSIVELY(frame, "bgm_mugic_title");
    if title ~= nil then
        local title_txt = title:GetTextByKey("value");
        if title_txt == "" or title_txt == nil then
            local ctrlSetName = frame:GetUserValue("CTRLSET_NAME_SELECTED");
            if ctrlSetName ~= nil then
                local ctrlSet = GET_CHILD_RECURSIVELY(frame, ctrlSetName);
                if ctrlSet ~= nil then
                    local ctrlset_title = GET_CHILD_RECURSIVELY(ctrlSet, "musictitle_text");
                    if ctrlset_title ~= nil then
                        local ctrlset_txt = ctrlset_title:GetTextByKey("value");
                        ctrlset_txt = StringSplit(ctrlset_txt, '. ');
                        title_txt = ctrlset_txt[2];
                    end
                end
            end
        end
        BGMPLAYER_REDUCTION_SET_TITLE(title_txt);
    end 
end

function BGMPLAYER_REDUCTION_INIT_SKIN(frame)
    local skin_mode = GetBgmPlayerSkinMode();
    local bgmplayer_frame = ui.GetFrame("bgmplayer");
    if bgmplayer_frame ~= nil then
        bgmplayer_frame:SetUserConfig("SKIN_MODE", skin_mode);
    end

    local isChange = false;
    if skin_mode == 0 then
        isChange = true;
    else
        isChange = false;
    end
    BGMPLAYER_REDUCTION_CHANGE_SKIN(isChange);
end

function BGMPLAYER_REDUCTION_OPEN_UI(preFrame, btn)
	if IsNotPlayArea() == false then
        ui.OpenFrame("bgmplayer_reduction"); 
        SetBgmPlayerReductionFrameVisible(1);
        SaveFavoritesBgmList();

        local frame = ui.GetFrame("bgmplayer_reduction");
        if frame ~= nil then
            BGMPLAYER_REDUCTION_INIT_SKIN(frame);
            BGMPLAYER_FRAME_SET_POS(frame);
        end
    elseif IsNotPlayArea() == true then
        ui.SysMsg(ClMsg("IsNotPlayBgmPlayerArea"));
        SetBgmPlayerBasicFrameVisible(0);
        SetBgmPlayerReductionFrameVisible(0);
    end

    if preFrame == nil then
        preFrame = ui.GetFrame("bgmplayer");
    end

	if preFrame ~= nil then
        preFrame:SetVisible(0);
        SetBgmPlayerBasicFrameVisible(0);

        local title = GET_CHILD_RECURSIVELY(preFrame, "bgm_mugic_title");
        if title ~= nil then
            local title_txt = title:GetTextByKey("value");
            BGMPLAYER_REDUCTION_SET_TITLE(title_txt);
        end
	end
end

function BGMPLAYER_REDUCTION_MAXIMIZE_UI()
	if IsNotPlayArea() == false then
        local bgmplayer_frame = ui.GetFrame("bgmplayer");
        if bgmplayer_frame ~= nil then 
            BGMPLAYER_REDUCTION_CLOSE_UI();
            BGMPLAYER_OPEN_UI();
        end 
    elseif IsNotPlayArea() == true then
        ui.SysMsg(ClMsg("IsNotPlayBgmPlayerArea"));
        SetBgmPlayerBasicFrameVisible(0);
        SetBgmPlayerReductionFrameVisible(0);
    end
end

function BGMPLAYER_REDUCTION_CLOSE_UI()
	ui.CloseFrame("bgmplayer_reduction");
    SetBgmPlayerReductionFrameVisible(0);
end

function BGMPLAYER_REDUCTION_CHANGE_SKIN(isChange)
    local frame = ui.GetFrame("bgmplayer_reduction");
    if frame == nil then return; end

    local childCnt = frame:GetChildCount();
    if childCnt == nil or childCnt <= 0 then return; end

    for i = 1, childCnt do
        local child = frame:GetChildByIndex(i - 1);
        if child ~= nil then
            local changeSkinName = child:GetSkinChangeImageNameList(frame:GetName(), child:GetName(), isChange);
            if changeSkinName ~= nil then
                child = AUTO_CAST(child);

                local classType = child:GetClassString();
                if classType == "ui::CButton" or classType == "ui::CPicture" then
                    child:SetImage(changeSkinName);
                else
                    if child:GetName() == "gb" then
                        if isChange == false then
                            child:SetSkinName("None");
                            child:SetImageName(changeSkinName);
                        else
                            child:ClearImageName();
                            child:SetSkinName(changeSkinName);
                        end
                    end

                    child:SetSkinName(changeSkinName);
                end
            end
            child:Invalidate();
        end
    end

    BGMPLAYER_REDUCTION_SET_CONTROL_INFO(frame, isChange);
end

function BGMPLAYER_REDUCTION_SET_CONTROL_INFO(frame, isChange)
    if frame == nil then return; end
    local simple_width = tonumber(frame:GetUserConfig("SIMPLE_WIDTH"));
    local simple_height = tonumber(frame:GetUserConfig("SIMPLE_HEIGHT"));
    local classic_width = tonumber(frame:GetUserConfig("CLASSIC_WIDTH"));
    local classic_height = tonumber(frame:GetUserConfig("CLASSIC_HEIGHT"));
    local top_margin = tonumber(frame:GetUserConfig("SIMPLE_TITLEBAR_BTN_MARGIN"));

    local gb = GET_CHILD_RECURSIVELY(frame, "gb");
    if gb == nil then return; end

    if isChange == false then
        frame:SetUserValue("SKIN_MODE", 0);
    else
        frame:SetUserValue("SKIN_MODE", 1);
    end
end 

function BGMPLAYER_REDUCTION_SET_TITLE(title)
    local frame = ui.GetFrame("bgmplayer_reduction");
    if frame == nil then return; end

    local format = "";
    local skin_mode = tonumber(frame:GetUserValue("SKIN_MODE"));
    if skin_mode == 0 then
        format = frame:GetUserConfig("TITLETXT_SIMPLE_FORAMT");
    else
        format = frame:GetUserConfig("TITLETXT_CLASSIC_FORAMT");
    end
    
    local title_txt = GET_CHILD_RECURSIVELY(frame, "bgm_mugic_title");
    if title_txt ~= nil then
       title_txt:SetFormat(format);
       title_txt:SetTextByKey("value", "");
       title_txt:SetTextByKey("value", title);
    end
end

function BGMPLAYER_REDUCTION_SET_PLAYBTN(isPlay)
    local frame = ui.GetFrame("bgmplayer_reduction");
    if frame == nil then return; end

    local playBtn = GET_CHILD_RECURSIVELY(frame, "playStart_btn");
    if playBtn == nil then return; end
    
    local skin_mode = tonumber(frame:GetUserValue("SKIN_MODE"));
    if isPlay == true then
        if skin_mode == 0 then
            playBtn:SetImage("m_stop_simple");
        else
            playBtn:SetImage("m_stop_classic");
        end

        local title_txt = GET_CHILD_RECURSIVELY(frame, "bgm_mugic_title");
        if title_txt ~= nil then
            title_txt:SetCompareTextWidthBySlideShow(true);
            title_txt:EnableSlideShow(1);
        end
    else
        if skin_mode == 0 then
            playBtn:SetImage("m_play_simple");
        else
            playBtn:SetImage("m_play_classic");
        end

        local title_txt = GET_CHILD_RECURSIVELY(frame, "bgm_mugic_title");
        if title_txt ~= nil then
            title_txt:SetTextAlign("center", "center");            
            title_txt:SetCompareTextWidthBySlideShow(false);
            title_txt:EnableSlideShow(0);
        end
    end
end

function BGMPLAYER_REDUCTION_PLAY(frame, btn)
    local max_frame = ui.GetFrame("bgmplayer");
    if max_frame == nil then return; end

    local play_btn = GET_CHILD_RECURSIVELY(max_frame, "playStart_btn");
    if play_btn == nil then return; end
    BGMPLAYER_PLAY(max_frame, play_btn);
end

function BGMPLAYER_REDUCTION_PREVIOUS_PLAY(frame, btn)
    local max_frame = ui.GetFrame("bgmplayer");
    if max_frame == nil then return; end

    local before_btn = GET_CHILD_RECURSIVELY(max_frame, "playerBefore_btn");
    if before_btn == nil then return; end
    BGMPLAYER_PLAY_PREVIOUS_BGM(max_frame, before_btn);
end

function BGMPLAYER_REDUCTION_NEXT_PLAY(frame, btn)
    local max_frame = ui.GetFrame("bgmplayer");
    if max_frame == nil then return; end

    local after_btn = GET_CHILD_RECURSIVELY(max_frame, "playerAfter_btn");
    if after_btn == nil then return; end
    BGMPLAYER_PLAY_NEXT_BGM(max_frame, after_btn);
end