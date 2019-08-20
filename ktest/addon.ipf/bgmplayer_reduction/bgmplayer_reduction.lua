--bgm music player reduciton ui
function BGMPLAYER_REDUCTION_ON_INIT(addon, frame)
	BGMPLAYER_REDUCTION_SET_TITLE("");
end

function BGMPLAYER_REDUCTION_OPEN_UI(preFrame, btn)
	if IsNotPlayArea() == false then
        ui.OpenFrame("bgmplayer_reduction"); 
    elseif IsNotPlayArea() == true then
        ui.SysMsg(ClMsg("IsNotPlayBgmPlayerArea"));
    end

	if preFrame ~= nil then
        preFrame:SetVisible(0);
	end
end

function BGMPLAYER_REDUCTION_MAXIMIZE_UI()
	if IsNotPlayArea() == false then
        local bgmplayer_frame = ui.GetFrame("bgmplayer");
        if bgmplayer_frame ~= nil then 
            bgmplayer_frame:SetVisible(1);
        end 
    elseif IsNotPlayArea() == true then
        ui.SysMsg(ClMsg("IsNotPlayBgmPlayerArea"));
    end

    local frame = ui.GetFrame("bgmplayer_reduction");
    if frame ~= nil then
        frame:SetVisible(0);
    end
end

function BGMPLAYER_REDUCTION_CLOSE_UI()
	ui.CloseFrame("bgmplayer_reduction");
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

    local maximize_btn = GET_CHILD_RECURSIVELY(frame, "maximize_btn");
    if maximize_btn == nil then return; end

    local close_btn = GET_CHILD_RECURSIVELY(frame, "close_btn");
    if close_btn == nil then return; end

    if isChange == false then
        gb:Resize(simple_width, simple_height);
        gb:SetGravity(ui.LEFT, ui.TOP);    

        local maximizebtn_margin = maximize_btn:GetMargin();
        maximize_btn:SetMargin(maximizebtn_margin.left, maximizebtn_margin.top + top_margin, maximizebtn_margin.right, maximizebtn_margin.bottom);

        local closebtn_margin = close_btn:GetMargin();
        close_btn:SetMargin(closebtn_margin.left, closebtn_margin.top + top_margin, closebtn_margin.right, closebtn_margin.bottom);
    else
        gb:Resize(classic_width, classic_height);
        gb:SetGravity(ui.LEFT, ui.TOP);

        local maximizebtn_margin = maximize_btn:GetMargin();
        maximize_btn:SetMargin(maximizebtn_margin.left, maximizebtn_margin.top - top_margin, maximizebtn_margin.right, maximizebtn_margin.bottom);

        local closebtn_margin = close_btn:GetMargin();
        close_btn:SetMargin(closebtn_margin.left, closebtn_margin.top - top_margin, closebtn_margin.right, closebtn_margin.bottom);
    end

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