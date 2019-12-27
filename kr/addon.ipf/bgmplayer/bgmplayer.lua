-- bgm music player UI
function BGMPLAYER_ON_INIT(addon, frame)
    --ReloadBgmPlayer();
    local frame = ui.GetFrame("bgmplayer");
    if frame == nil then return end
    if IsBgmPlayerBasicFrameVisible() == 1 then
        BGMPLAYER_OPEN_UI();
        BGMPLAYER_FRAME_SET_POS(frame);
    end
end

function BGMPLAYER_FRAME_SET_POS(frame)
    if frame ~= nil then
        local x, y = 0, 0;
        if frame:GetName() == "bgmplayer" then
            x, y = GetBgmPlayerMoveFrmaePos(0);
        elseif frame:GetName() == "bgmplayer_reduction" then
            x, y = GetBgmPlayerMoveFrmaePos(1);
        end
        
        if x ~= 0 and y ~= 0 then
            frame:MoveFrame(x, y);
        end
    end
end

function BGMPLAYER_PRE_CHECK_CTRL(frame)
    if frame == nil then return; end

    local title = GET_CHILD_RECURSIVELY(frame, "title");
    if title == nil then return; end
    title:SetTextByKey("value", ClMsg("BGMPlayer_Title"));

    local allList_btn = GET_CHILD_RECURSIVELY(frame, "playerAllList_btn");
    if allList_btn == nil then return; end

    local allList_txt = string.format("{@st42b}{s18}%s{/}", ClMsg("BGMPlayer_AllListBtn"));
    allList_btn:SetText(allList_txt);
    allList_btn:SetTextAlign("center", "center");

    local favoritesList_btn = GET_CHILD_RECURSIVELY(frame, "playerFavoritesList_btn");
    if favoritesList_btn == nil then return; end

    local favorites_txt = string.format("{@st42b}{s18}%s{/}", ClMsg("BGMPlayer_FavoritesListBtn"));
    favoritesList_btn:SetText(favorites_txt);
    favoritesList_btn:SetTextAlign("center", "center");

    local gauge = GET_CHILD_RECURSIVELY(frame, "bgmplayer_timegauge");
    if gauge == nil then return; end

    local barImgName = frame:GetUserConfig("GAUGE_BAR_IMGNAME");
    if barImgName ~= nil then
        gauge:SetBarImageName(barImgName);
    end

    local bgmType, bgmOption = GetBgmPlayerListModeOption();
    if bgmType == 2 and bgmOption == 2 then
        bgmType = 1; bgmOption = 0;
    end
    frame:SetUserValue("MODE_ALL_LIST", bgmType);
    frame:SetUserValue("MODE_FAVO_LIST", bgmOption);

    local playRandom, playRepeat = GetRandomRepeatState();
    frame:SetUserConfig("PLAY_RANDOM", playRandom);
    frame:SetUserConfig("PLAY_REPEAT", playRepeat);

    local mode = tonumber(frame:GetUserValue("MODE_ALL_LIST"));
    local option = tonumber(frame:GetUserValue("MODE_FAVO_LIST"));
    BGMPLAYER_SET_ACTIVATION_LIST_TAB(frame, mode, option);
    BGMPLAYER_MUSIC_SET_ALL_LIST(frame, mode, option);
end

function BGMPLAYER_INIT_SELECTCTRLSET(frame)
    local selectCtrlSetName = GetCurControlSetName();
    if selectCtrlSetName ~= nil and selectCtrlSetName ~= "None" then
        local gb = GET_CHILD_RECURSIVELY(frame, "musicAllList_gb");
        local selectCtrlSet = GET_CHILD_RECURSIVELY(gb, selectCtrlSetName);
        if selectCtrlSet ~= nil then
            local parent = selectCtrlSet:GetParent();
            BGMPLAYER_SELECT_CLEAER(parent);
            local select_gb = GET_CHILD_RECURSIVELY(selectCtrlSet, "musicselect_gbox");
            if select_gb == nil then return; end
            select_gb:SetVisible(1);
            frame:SetUserValue("CTRLSET_NAME_SELECTED", selectCtrlSet:GetName());

            local btn = GET_CHILD_RECURSIVELY(frame, "playStart_btn");
            if btn == nil then return; end
            local imageName = btn:GetImageName();
            if imageName ~= nil and string.find(imageName, "play_") ~= nil then
                local haltImageName = frame:GetUserConfig("PLAY_HALT_BTN_IMAGE_NAME");
                btn:SetImage(haltImageName);
                btn:SetTooltipArg(ScpArgMsg('BgmPlayer_StartBtnToolTip'));
            end
        end
    end
end 

function BGMPLAYER_FIND_CTRLSET_BY_NAME(frame, name)
    if frame == nil then return; end
    if name == nil then return; end

    local musicinfo_gb = GET_CHILD_RECURSIVELY(frame, "musicinfo_gb");
    local child_cnt = musicinfo_gb:GetChildCount();
    for i = 1, child_cnt do
        local child = musicinfo_gb:GetChildByIndex(i - 1);
        if child:GetName() == name then
            return child;
        end
    end

    return nil;
end

function BGMPLAYER_FIND_CTRLSET_BY_TITLENAME(frame, name)
    if frame == nil then return; end
    if name == nil then return; end

    local musicinfo_gb = GET_CHILD_RECURSIVELY(frame, "musicinfo_gb");
    local child_cnt = musicinfo_gb:GetChildCount();
    for i = 1, child_cnt do
        local child = musicinfo_gb:GetChildByIndex(i - 1);
        if child ~= nil then
            local title = GET_CHILD_RECURSIVELY(child, "musictitle_text");
            if title ~= nil then
                local txt 
            end
        end
    end

    return nil;
end

function BGMPLAYER_NOT_PLAYED_AREA_CHECK(frame)
    if IsNotPlayArea() == true then
        local bgmMusicTitle_text = GET_CHILD_RECURSIVELY(frame, "bgm_mugic_title");
        if bgmMusicTitle_text ~= nil then
            local title = bgmMusicTitle_text:GetTextByKey("value");
            StopBgm(title);
            return 0;
        end
    end
    return 1;
end

function BGMPLAYER_OPEN_UI(frame, btn)
    ReloadBgmPlayer();
    LoadFavoritesBgmList();
    SaveFavoritesBgmList();
    if IsBgmPlayerReductionFrameVisible() == 1 then
        return;
    end

    if IsNotPlayArea() == false then
        ui.OpenFrame("bgmplayer"); 
        SetBgmPlayerBasicFrameVisible(1);

        local bgmPlayer_frame = ui.GetFrame("bgmplayer");
        if bgmPlayer_frame == nil then 
            return; 
        end

        BGMPLAYER_PRE_CHECK_CTRL(bgmPlayer_frame);
        BGMPLAYER_INIT_SELECTCTRLSET(bgmPlayer_frame);
        if frame == nil and btn == nil then
            BGMPLAYER_SKIN_INIT(bgmPlayer_frame);
        end
    elseif IsNotPlayArea() == true then
        ui.SysMsg(ClMsg("IsNotPlayBgmPlayerArea"));
    end
end

function BGMPLAYER_CLOSE_UI()
    ui.CloseFrame("bgmplayer");

    local frame = ui.GetFrame("bgmplayer");
    if frame == nil then return end

    local timeText = GET_CHILD_RECURSIVELY(frame, "bgm_mugic_playtime");
    if timeText == nil then return end

    timeText:StopUpdateScript("TEST_BGM_PLAYER_TIME");
    SaveFavoritesBgmList();
    SetBgmPlayerBasicFrameVisible(0);
end

function BGMPLAYER_SKIN_INIT(frame)
    local skin_mode = GetBgmPlayerSkinMode();
    frame:SetUserConfig("SKIN_MODE", skin_mode);
    local isChange = false;
    if skin_mode == 0 then
        isChange = true;
    elseif skin_mode == 1 then
        isChange = false;
    end
        
    BGMPLAYER_CHANGE_SKIN_GROUP(frame, isChange);
    BGMPLAYER_CHANGE_SKIN_TITLE_GROUP(frame, isChange);
    BGMPLAYER_CHANGE_SKIN_SET_USERVALUE(frame, isChange);
    BGMPLAYER_CHANGE_SKIN_RESET_CONTROL(frame, isChange);
    BGMPLAYER_CHANGE_SKIN_SELECTCTRLSET(frame);
end

function BGMPLAYER_SINGULAR_SELECTION_LISTINDEX(ctrlset)
    if ctrlset == nil then return; end

    local parent = ctrlset:GetParent();
    BGMPLAYER_SELECT_CLEAER(parent);
    
    local select_gb = GET_CHILD_RECURSIVELY(ctrlset, "musicselect_gbox");
    if select_gb == nil then return; end
    select_gb:SetVisible(1);
    SetCurControlSetName(ctrlset:GetName());

    local topFrame = parent:GetTopParentFrame();
    if topFrame == nil then return; end
    topFrame:SetUserValue("CTRLSET_NAME_SELECTED", ctrlset:GetName());
    BGMPLAYER_PLAYBTN_RESET(topFrame); 

    local musictitle_txt = GET_CHILD_RECURSIVELY(ctrlset, "musictitle_text");
    if musictitle_txt ~= nil then
        musictitle_txt = AUTO_CAST(musictitle_txt);
        if musictitle_txt:IsTextOmitted() == true then
            musictitle_txt:EnableTextOmitByWidth(false);
            
            local txt = musictitle_txt:GetTextByKey("value");
            musictitle_txt:SetTextByKey("value", "");
            musictitle_txt:SetTextByKey("value", txt);
            musictitle_txt:Invalidate();
            
            musictitle_txt:SetCompareTextWidthBySlideShow(true);
            musictitle_txt:EnableSlideShow(1);
        end
    end
end

function BGMPLAYER_SET_MUSIC_TITLE(frame, parent, ctrlset)
    local minIndex = tonumber(frame:GetUserConfig("TITLE_MIN_INDEX"));
    local maxIndex = tonumber(frame:GetUserConfig("TITLE_MAX_INDEX"));
    local titleText = GET_CHILD_RECURSIVELY(ctrlset, "musictitle_text");
    if titleText == nil then return; end

    local musicTitle = titleText:GetTextByKey("value");
    if musicTitle ~= nil then
        musicTitle = StringSplit(musicTitle, " ");
        local spaceStr = "%s";
        local formatStr = "";
        for i = minIndex, maxIndex do
            if musicTitle[i] ~= nil then
                musicTitle[i] = musicTitle[i - 1].." "..musicTitle[i];
                formatStr = string.format(spaceStr, musicTitle[i]);
                musicTitle[2] = formatStr;
            end
        end

        frame:SetUserValue("MUSIC_TITLE", parent:GetName().."/"..musicTitle[2]);
        local bgmMusicTitle_text = GET_CHILD_RECURSIVELY(frame, "bgm_mugic_title");
        if bgmMusicTitle_text ~= nil then
            bgmMusicTitle_text:SetTextByKey("value", musicTitle[2]);
        end
    end
end

function BGMPLAYER_SET_ZONE_BGM_TITLE(titleName)
    local frame = ui.GetFrame("bgmplayer");
    if frame == nil then return; end

    local title = GET_CHILD_RECURSIVELY(frame, "bgm_mugic_title");
    if title ~= nil then
        title:SetTextByKey("value", titleName);
    end

    BGMPLAYER_REDUCTION_SET_TITLE(titleName);
end

function BGMPLAYER_SELECT_CLEAER(parent)
    if parent == nil then return; end
    local topFrame = parent:GetTopParentFrame();
    if topFrame == nil then return; end

    local findText = nil; local anotherFindText = nil; local anotherParent = nil;
    if parent:GetName() == "musicinfo_gb" then
        findText = "MUSICINFO_";
    end

    local cnt = parent:GetChildCount();
    for i = 1, cnt do
        local child = parent:GetChildByIndex(i - 1);
        if child ~= nil and string.find(child:GetName(), findText) ~= nil then
            local select_gb = GET_CHILD_RECURSIVELY(child, "musicselect_gbox");
            if select_gb ~= nil then
                if select_gb:IsVisible() == 1 then
                    topFrame:SetUserValue("BEFORE_SELECT_CTRLSET_NAME", child:GetName());
                end
                select_gb:SetVisible(0);
            end
        end
    end

    if topFrame:GetUserValue("BEFORE_SELECT_CTRLSET_NAME") ~= "None" then
        local beforeSelectCtrlSet = GET_CHILD_RECURSIVELY(parent, topFrame:GetUserValue("BEFORE_SELECT_CTRLSET_NAME"));
        if beforeSelectCtrlSet ~= nil then
            local musictitle_txt = GET_CHILD_RECURSIVELY(beforeSelectCtrlSet, "musictitle_text");
            if musictitle_txt ~= nil then
                if musictitle_txt:IsTextOmitted() == false then
                    musictitle_txt:EnableTextOmitByWidth(true);
                    
                    local txt = musictitle_txt:GetTextByKey("value");
                    musictitle_txt:SetTextByKey("value", "");
                    musictitle_txt:SetTextByKey("value", txt);
                    musictitle_txt:Invalidate();

                    musictitle_txt:SetCompareTextWidthBySlideShow(false);
                    musictitle_txt:EnableSlideShow(0);
                end
            end
        end
    end
end

function BGMPLAYER_MUSIC_SET_ALL_LIST(frame, mode, option, isChange)
    if frame == nil then return; end
    local musicinfo_gb = GET_CHILD_RECURSIVELY(frame, "musicinfo_gb");
    if musicinfo_gb == nil then return; end
    local bgmTitleList = GetBgmTitleList(mode, option);
    local favoTitleList = GetFavoritesTitleList(mode, option);
    
    local start_x = 3;
    if mode == 1 and option == 0 then
        if bgmTitleList == nil then return; end
        listCnt = #bgmTitleList;

        for i = 1, listCnt do
            local musicInfoCtrlSet = musicinfo_gb:CreateOrGetControlSet("bgmplayer_musicinfo", "MUSICINFO_"..i, start_x, (i - 1) * 25);
            if musicInfoCtrlSet ~= nil then
                local musicselect_gb = GET_CHILD_RECURSIVELY(musicInfoCtrlSet, "musicselect_gbox");
                musicselect_gb:SetVisible(0);
                    
                if (isChange ~= nil and isChange == true) or isChange == nil then
                    if i % 2 ~= 0 then
                        musicInfoCtrlSet:SetSkinName("chat_window_2");
                    end
                elseif isChange ~= nil and isChange == false then
                    if i % 2 ~= 0 then
                        musicInfoCtrlSet:SetSkinName("simple_title_divide");
                    end
                end

                local btn = GET_CHILD_RECURSIVELY(musicInfoCtrlSet, "heart_btn");
                if btn ~= nil then
                    if isChange ~= nil and isChange == false then
                        local simple_image = frame:GetUserConfig("HEARTBTN_SIMPLE_IMG_NAME");
                        btn:SetImage(simple_image);
                    elseif isChange == nil or (isChange ~= nil and isChange == true) then
                        local classic_image = frame:GetUserConfig("HEARTBTN_CALSSIC_IMG_NAME");
                        btn:SetImage(classic_image);
                    end

                    local prvImageName = btn:GetImageName();
                    if IsFavoritesedByTitle(bgmTitleList[i]) == 1 then 
                        local imageName = "";
                        if string.find(prvImageName, "_clicked") ~= nil then
                            imageName = prvImageName;
                        else
                            imageName = prvImageName.."_clicked";
                        end
                        btn:SetImage(imageName);
                    end
                end
                
                local musictitle_txt = GET_CHILD_RECURSIVELY(musicInfoCtrlSet, "musictitle_text");
                if musictitle_txt ~= nil and btn ~= nil then
                    local titletxt = "";
                    titletxt = string.format("%d. %s", i, bgmTitleList[i]);
                    musictitle_txt:SetTextByKey("value", titletxt);
                end

                local musictime_txt = GET_CHILD_RECURSIVELY(musicInfoCtrlSet, "musictotaltime_text");
                if musictime_txt ~= nil then
                    local totalTime = GetBgmTotalTimeByTitleName(bgmTitleList[i]);
                    musictime_txt:SetTextByKey("value", totalTime);
                end

                musicInfoCtrlSet:SetUserValue("CTRLSET_NAME", "MUSICINFO_"..i);
            end
        end
    elseif mode == 0 and option == 1 then
        if favoTitleList == nil then return; end
        listCnt = #favoTitleList;

        for i = 1, listCnt do
            local musicInfoCtrlSet = musicinfo_gb:CreateOrGetControlSet("bgmplayer_musicinfo", "MUSICINFO_"..i, start_x, (i - 1) * 25);
            if musicInfoCtrlSet ~= nil then
                local musicselect_gb = GET_CHILD_RECURSIVELY(musicInfoCtrlSet, "musicselect_gbox");
                musicselect_gb:SetVisible(0);
                    
                if (isChange ~= nil and isChange == true) or isChange == nil then
                    if i % 2 ~= 0 then
                        musicInfoCtrlSet:SetSkinName("chat_window_2");
                    end
                elseif isChange ~= nil and isChange == false then
                    if i % 2 ~= 0 then
                        musicInfoCtrlSet:SetSkinName("simple_title_divide");
                    end
                end

                local btn = GET_CHILD_RECURSIVELY(musicInfoCtrlSet, "heart_btn");
                if btn ~= nil then
                    if isChange ~= nil and isChange == false then
                        local simple_image = frame:GetUserConfig("HEARTBTN_SIMPLE_IMG_NAME");
                        btn:SetImage(simple_image);
                    elseif isChange == nil or (isChange ~= nil and isChange == true) then
                        local classic_image = frame:GetUserConfig("HEARTBTN_CALSSIC_IMG_NAME");
                        btn:SetImage(classic_image);
                    end

                    local prvImageName = btn:GetImageName();
                    if IsFavoritesedByTitle(favoTitleList[i]) == 1 then 
                        local imageName = "";
                        if string.find(prvImageName, "_clicked") ~= nil then
                            imageName = prvImageName;
                        else
                            imageName = prvImageName.."_clicked";
                        end
                        btn:SetImage(imageName);
                    end
                end
                
                local musictitle_txt = GET_CHILD_RECURSIVELY(musicInfoCtrlSet, "musictitle_text");
                if musictitle_txt ~= nil and btn ~= nil then
                    local titletxt = "";
                    titletxt = string.format("%d. %s", i, favoTitleList[i]);
                    musictitle_txt:SetTextByKey("value", titletxt);
                end

                local musictime_txt = GET_CHILD_RECURSIVELY(musicInfoCtrlSet, "musictotaltime_text");
                if musictime_txt ~= nil then
                    local totalTime = GetBgmTotalTimeByTitleName(bgmTitleList[i]);
                    musictime_txt:SetTextByKey("value", totalTime);
                end

                musicInfoCtrlSet:SetUserValue("CTRLSET_NAME", "MUSICINFO_"..i);
            end
        end
    end
end

function BGMPLAYER_FAVORITESLIST_SELECT(frame, btn)
    if frame == nil then return; end
    local topFrame = frame:GetTopParentFrame();
    if topFrame == nil then return; end

    local minIndex = tonumber(topFrame:GetUserConfig("TITLE_MIN_INDEX"));
    local maxIndex = tonumber(topFrame:GetUserConfig("TITLE_MAX_INDEX"));

    local index = GetFavoritesBgmListSize() + 1;
    if index == nil then return; end

    local allList_gb = GET_CHILD_RECURSIVELY(topFrame, "musicinfo_gb");
    if allList_gb == nil then return; end

    local ctrlSet = btn:GetParent();
    if ctrlSet ~= nil then
        local titleTxt = GET_CHILD_RECURSIVELY(ctrlSet, "musictitle_text");
        if titleTxt == nil then return; end
        
        local musicName = titleTxt:GetTextByKey("value");
        if musicName ~= nil then
            musicName = StringSplit(musicName, " ");
            local spaceStr = "%s";
            local formatStr = "";
            for i = minIndex, maxIndex do
                if musicName[i] ~= nil then
                    musicName[i] = musicName[i - 1].." "..musicName[i];
                    formatStr = string.format(spaceStr, musicName[i]);
                    musicName[2] = formatStr;
                else
                    break;
                end
            end
           
            local skin_mode = tonumber(topFrame:GetUserConfig("SKIN_MODE"));
            if skin_mode ~= nil and skin_mode == 1 then
                local simple_image = topFrame:GetUserConfig("HEARTBTN_SIMPLE_IMG_NAME");
                btn:SetImage(simple_image);
            elseif skin_mode ~= nil and skin_mode == 0 then
                local classic_image = topFrame:GetUserConfig("HEARTBTN_CALSSIC_IMG_NAME");
                btn:SetImage(classic_image);
            end

            local prvImageName = btn:GetImageName();
            if IsFavoritesedByTitle(musicName[2]) == 1 then
                local imageName = StringSplit(prvImageName, "_");
                local imageName_ret = imageName[1].."_"..imageName[2];
                btn:SetImage(imageName_ret);
                RemoveFavoritesInfo(musicName[2]);
            elseif IsFavoritesedByTitle(musicName[2]) == 0 then
                local imageName = prvImageName.."_clicked";
                btn:SetImage(imageName);
                AddFavoritesInfo(musicName[2]);
            end
        end
    end

    GBOX_AUTO_ALIGN(allList_gb, 0, 0, 0, false, false, false);
    allList_gb:Invalidate();
end

function BGMPLAYER_SEARCH_TITLE_KEY(frame, edit)
    if frame == nil then return; end
    if edit == nil then return; end
    edit:SetTextFixWidth(1);
    edit:SetOffsetXForDraw(20);

    local topFrame = frame:GetTopParentFrame();
    if topFrame == nil then return; end

    local mode = tonumber(topFrame:GetUserValue("MODE_ALL_LIST"));
    local option = tonumber(topFrame:GetUserValue("MODE_FAVO_LIST"));

    local keyWord = edit:GetText();
    if string.find(edit:GetName(), "AllList") ~= nil then
        if keyWord == "" then
            BGMPLAYER_LIST_RESET(topFrame, mode, option);
            SetBgmPlayerSearchState(0);
            return;
        end

        local isChange = false;
        local skin_mode = tonumber(topFrame:GetUserConfig("SKIN_MODE"));
        if skin_mode == 0 then
            isChange = true;
        elseif skin_mode == 1 then
            isChange = false;
        end

        SetBgmPlayerSearchState(1);
        SearchBgmListByType(keyWord, mode, option);
        BGMPLAYER_SEARCH_BY_MODE(topFrame, mode, option, isChange)
    end
end

function BGMPLAYER_SEARCH_BY_MODE(frame, mode, option, isChange)
    if frame == nil then return; end

    local musicinfo_gb = GET_CHILD_RECURSIVELY(frame, "musicinfo_gb");
    if musicinfo_gb == nil then return; end
    musicinfo_gb:RemoveAllChild();

    local searchList = GetSearchList(mode, option);
    if searchList == nil then return; end

    local start_x = 3;
    local listCnt = #searchList;
    for i = 1, listCnt do
        local musicInfoCtrlSet = musicinfo_gb:CreateOrGetControlSet("bgmplayer_musicinfo", "MUSICINFO_"..i, start_x, (i - 1) * 25);
        if musicInfoCtrlSet ~= nil then
            local musicselect_gb = GET_CHILD_RECURSIVELY(musicInfoCtrlSet, "musicselect_gbox");
            musicselect_gb:SetVisible(0);
            
            if (isChange ~= nil and isChange == true) or isChange == nil then
                if i % 2 ~= 0 then
                    musicInfoCtrlSet:SetSkinName("chat_window_2");
                end
            elseif isChange ~= nil and isChange == false then
                if i % 2 ~= 0 then
                    musicInfoCtrlSet:SetSkinName("simple_title_divide");
                end
            end

            local btn = GET_CHILD_RECURSIVELY(musicInfoCtrlSet, "heart_btn");
            if btn ~= nil then
                if isChange ~= nil and isChange == false then
                    local simple_image = frame:GetUserConfig("HEARTBTN_SIMPLE_IMG_NAME");
                    btn:SetImage(simple_image);
                elseif isChange == nil or (isChange ~= nil and isChange == true) then
                    local classic_image = frame:GetUserConfig("HEARTBTN_CALSSIC_IMG_NAME");
                    btn:SetImage(classic_image);
                end

                local prvImageName = btn:GetImageName();
                if IsFavoritesedByTitle(searchList[i]) == 1 then 
                    local imageName = "";
                    if string.find(prvImageName, "_clicked") ~= nil then
                        imageName = prvImageName;
                    else
                        imageName = prvImageName.."_clicked";
                    end
                    btn:SetImage(imageName);
                end
            end

            local musictitle_txt = GET_CHILD_RECURSIVELY(musicInfoCtrlSet, "musictitle_text");
            if musictitle_txt ~= nil then
                local titletxt = string.format("%d. %s", i, searchList[i]);
                musictitle_txt:SetTextByKey("value", titletxt);
            end

            local musictime_txt = GET_CHILD_RECURSIVELY(musicInfoCtrlSet, "musictotaltime_text");
            if musictime_txt ~= nil then
                local totalTime = GetBgmTotalTimeByTitleName(searchList[i]);
                musictime_txt:SetTextByKey("value", totalTime);
            end
        end
    end
end

function BGMPLAYER_LIST_RESET(frame, mode, option, isChange)
    if frame == nil then return; end
    local musicinfo_gb = GET_CHILD_RECURSIVELY(frame, "musicinfo_gb");
    if musicinfo_gb == nil then return; end
    musicinfo_gb:RemoveAllChild();
    BGMPLAYER_MUSIC_SET_ALL_LIST(frame, mode, option, isChange);
end

function BGMPLAYER_PLAYBTN_RESET(frame)
     local topFrame = frame:GetTopParentFrame();
     if topFrame == nil then return; end

     local minIndex = tonumber(topFrame:GetUserConfig("TITLE_MIN_INDEX"));
     local maxIndex = tonumber(topFrame:GetUserConfig("TITLE_MAX_INDEX"));

     local btn = GET_CHILD_RECURSIVELY(topFrame, "playStart_btn");
     if btn == nil then return; end

     local title = frame:GetUserValue("MUSIC_TITLE");
     if title ~= "None" then
        title = StringSplit(title, '/');
     end

     local selectBgmClsName = "";
     local selectCtrlSetName = topFrame:GetUserValue("CTRLSET_NAME_SELECTED");
     local selectCtrlSet = GET_CHILD_RECURSIVELY(topFrame, selectCtrlSetName);
     if selectCtrlSet ~= nil then
        local select_titleTxt = GET_CHILD_RECURSIVELY(selectCtrlSet, "musictitle_text");
        if select_titleTxt == nil then return; end
        
        local select_titleMusicName = select_titleTxt:GetTextByKey("value");
        if select_titleMusicName ~= nil then
            select_titleMusicName = StringSplit(select_titleMusicName, " ");
            select_titleMusicName[2] = GET_BGMPLAYER_MUSIC_TITLE(minIndex, maxIndex, select_titleMusicName);
        end

        selectBgmClsName = select_titleMusicName[2];
     end

     local haltImageName = topFrame:GetUserConfig("PLAY_HALT_BTN_IMAGE_NAME");
     local startImageName = topFrame:GetUserConfig("PLAY_START_BTN_IMAGE_NAME");
     if title[2] == selectBgmClsName then
        btn:SetImage(haltImageName);
        btn:SetTooltipArg(ScpArgMsg('BgmPlayer_StartBtnToolTip'));
        BGMPLAYER_REDUCTION_SET_PLAYBTN(true);
     elseif title[2] ~= nil and title[2] ~= selectBgmClsName then
        btn:SetImage(startImageName);
        btn:SetTooltipArg(ScpArgMsg('BgmPlayer_StartBtnToolTip'));
        SetPause(0);
        SetPauseTime(0);
        BGMPLAYER_REDUCTION_SET_PLAYBTN(false);
     end
end

function BGMPLAYER_PLAY(frame, btn)
    if frame == nil then return; end
    if btn == nil then return; end
    local topFrame = frame:GetTopParentFrame();
    if topFrame == nil then return; end

    local mode = tonumber(topFrame:GetUserValue("MODE_ALL_LIST"));
    local option = tonumber(topFrame:GetUserValue("MODE_FAVO_LIST"));
    local delayTime = tonumber(topFrame:GetUserConfig("DELAY_TIME"));
    local playRandom = tonumber(topFrame:GetUserConfig("PLAY_RANDOM"));

    local bgmMusicTitle_text = GET_CHILD_RECURSIVELY(topFrame, "bgm_mugic_title");
    if bgmMusicTitle_text ~= nil then
        local title = bgmMusicTitle_text:GetTextByKey("value");
        if title ~= nil then 
            local haltImageName = topFrame:GetUserConfig("PLAY_HALT_BTN_IMAGE_NAME");
            local startImageName = topFrame:GetUserConfig("PLAY_START_BTN_IMAGE_NAME");
            if btn:GetImageName() == haltImageName then
                StopBgm(title, delayTime);
                BGMPLAYER_REDUCTION_SET_PLAYBTN(false);
            else
                local selectCtrlSetName = topFrame:GetUserValue("CTRLSET_NAME_SELECTED");
                local selectCtrlSet = GET_CHILD_RECURSIVELY(topFrame, selectCtrlSetName);
                local titleText = nil;
                local parent = nil;
                if selectCtrlSet ~= nil then
                    parent = selectCtrlSet:GetParent();
                    if parent ~= nil then
                        BGMPLAYER_SET_MUSIC_TITLE(topFrame, parent, selectCtrlSet);
                    end
                    titleText = GET_CHILD_RECURSIVELY(selectCtrlSet, "musictitle_text");
                end
                if titleText == nil then return; end

                local musicTitle = titleText:GetTextByKey("value");
                if musicTitle ~= nil then
                    musicTitle = StringSplit(musicTitle, '. ');
                    local index = tonumber(musicTitle[1]);
                    local bgmType = GET_BGMPLAYER_MODE(topFrame, mode, option);
                    if bgmType == 1 then
                        SetBgmCurIndex(index, playRandom);
                    elseif bgmType == 0 then
                        SetBgmCurFVIndex(index, playRandom);
                    end
                end
                
                title = bgmMusicTitle_text:GetTextByKey("value");
                PlayBgm(title, selectCtrlSetName);
                BGMPLAYER_REDUCTION_SET_PLAYBTN(true);

                local totalTime = GetPlayBgmTotalTime();
                totalTime = totalTime / 1000;
                local startTime = 0;
                if GetBgmPauseTime() > 0 then
                    startTime = GetBgmPauseTime() / 1000;
                    SetPauseTime(0);
                end
                BGMPLAYER_PLAYTIME_GAUGE(startTime, totalTime);
            end

            if btn:GetImageName() == startImageName then
                btn:SetImage(haltImageName);
                btn:SetTooltipArg(ScpArgMsg('BgmPlayer_HaltBtnToolTip'));
            else
                btn:SetImage(startImageName);
                btn:SetTooltipArg(ScpArgMsg('BgmPlayer_StartBtnToolTip'));
            end
        end
    end
end

function BGMPLAYER_REPLAY(argStr, argNum, argValue)
    if argStr == nil then return; end
    if argNum == nil then return; end
    local frame = ui.GetFrame("bgmplayer");
    if frame == nil then return; end

    local titleName = argStr;
    local ctrlSetName = argValue; 
    local gb = GET_CHILD_RECURSIVELY(frame, "musicinfo_gb"); 
    if gb == nil then return; end

    local bgmMusicTitle_text = GET_CHILD_RECURSIVELY(frame, "bgm_mugic_title");
    if bgmMusicTitle_text ~= nil then
        bgmMusicTitle_text:SetTextByKey("value", titleName);
        frame:SetUserValue("MUSIC_TITLE", gb:GetName().."/"..titleName);
    end

    BGMPLAYER_REDUCTION_SET_PLAYBTN(true);
    
    local totalTime = GetPlayBgmTotalTime();
    totalTime = totalTime / 1000;
    local startTime = 0;
    if GetBgmPauseTime() > 0 then
        startTime = GetBgmPauseTime() / 1000;
        SetPauseTime(0);
    end

    BGMPLAYER_PLAYTIME_GAUGE(startTime, totalTime);
end

function BGMPLAYER_PLAYTIME_GAUGE(curtime, maxtime)
    local frame = ui.GetFrame("bgmplayer");
    if frame == nil then return end

    local gauge = GET_CHILD_RECURSIVELY(frame, "bgmplayer_timegauge");
    if gauge == nil then return end

    gauge:SetMaxPointWithTime(curtime, maxtime, 0.1, 0.5);
    gauge:ShowWindow(1);
end

function BGMPLAYER_SEQUENCE_PLAY(type, curIndex)
    local frame = ui.GetFrame("bgmplayer");
    if frame == nil then return; end

    local playRandom = tonumber(frame:GetUserConfig("PLAY_RANDOM"));
    local parent = GET_CHILD_RECURSIVELY(frame, "musicinfo_gb"); 
    local findText = "MUSICINFO_";
    if type == 1 then   -- AllList
        SetBgmCurIndex(curIndex, playRandom);
        curIndex = GetBgmCurIndex();
    elseif type == 0 then -- FvList
        SetBgmCurFVIndex(curIndex, playRandom);
        curIndex = GetBgmCurFVIndex();
    end

    if parent == nil then return; end
    local childCnt = parent:GetChildCount();
    if childCnt == nil or childCnt == 0 then return; end

    local minIndex = tonumber(frame:GetUserConfig("TITLE_MIN_INDEX"));
    local maxIndex = tonumber(frame:GetUserConfig("TITLE_MAX_INDEX"));
    for i = 1, childCnt do
        local child = parent:GetChildByIndex(i - 1);
        if child ~= nil and string.find(child:GetName(), findText) ~= nil then
            local titleText = GET_CHILD_RECURSIVELY(child, "musictitle_text");
            if titleText ~= nil then
                local musicIndex = titleText:GetTextByKey("value");
                musicIndex = StringSplit(musicIndex, '. ');
                if tonumber(musicIndex[1]) == tonumber(curIndex) then
                    local musicTitle = titleText:GetTextByKey("value");
                    musicTitle = StringSplit(musicTitle, " ");
                    musicTitle[2] = GET_BGMPLAYER_MUSIC_TITLE(minIndex, maxIndex, musicTitle);

                    local success = PlayBgm(musicTitle[2], child:GetName());
                    if success == false then
                        local index = 0;
                        if playRandom == 1 then
                            local option = frame:GetUserValue("MODE_FAVO_LIST");
                            if option == nil then option = 0; end
                            SetRandomPlay(1, type, option);

                            if type == 1 then
                                index = GetBgmCurIndex();
                            elseif type == 0 then
                                index = GetBgmCurFVIndex();
                            end
                        end

                        if playRandom == 0 then
                            index = curIndex + 1;
                        end

                        BGMPLAYER_SEQUENCE_PLAY(type, index);
                        return;
                    end
                    
                    local startTime = 0;
                    local totalTime = GetPlayBgmTotalTime();
                    totalTime = totalTime / 1000;
                    BGMPLAYER_PLAYTIME_GAUGE(startTime, totalTime);
                    BGMPLAYER_SET_MUSIC_TITLE(frame, parent, child);
                    BGMPLAYER_SINGULAR_SELECTION_LISTINDEX(child);
                    BGMPLAYER_REDUCTION_SET_PLAYBTN(true);
                    break;
                end
            end
        end
    end
end

function BGMPLAYER_PLAY_RANDOM(frame, curIndex)
    if frame == nil then return; end
    local mode = tonumber(frame:GetUserValue("MODE_ALL_LIST"));
    local option = tonumber(frame:GetUserValue("MODE_FAVO_LIST"));
    local bgmType = GET_BGMPLAYER_MODE(frame, mode, option);
    local minIndex = tonumber(frame:GetUserConfig("TITLE_MIN_INDEX"));
    local maxIndex = tonumber(frame:GetUserConfig("TITLE_MAX_INDEX"));

    local parent = GET_CHILD_RECURSIVELY(frame, "musicinfo_gb"); 
    if parent == nil then return; end
    local findText = "MUSICINFO_"; 

    local cnt = parent:GetChildCount();
    if cnt == nil or cnt == 0 then return; end

    for i = 1, cnt do
        local child = parent:GetChildByIndex(i - 1);
        if child ~= nil and string.find(child:GetName(), findText) ~= nil then
            local title_txt = GET_CHILD_RECURSIVELY(child, "musictitle_text");
            if title_txt == nil then break; end

            local index = title_txt:GetTextByKey("value");
            index = StringSplit(index, '. ');
            if tonumber(index[1]) == curIndex then
                if bgmType == 1 then 
                    SetBgmCurIndex(curIndex, 1);
                elseif bgmType == 0 then
                    SetBgmCurFVIndex(curIndex, 1);
                end

                local musicTitle = title_txt:GetTextByKey("value");
                musicTitle = StringSplit(musicTitle, " ");
                musicTitle[2] = GET_BGMPLAYER_MUSIC_TITLE(minIndex, maxIndex, musicTitle);
                PlayBgm(musicTitle[2], child:GetName());

                local startTime = 0;
                local totalTime = GetPlayBgmTotalTime();
                totalTime = totalTime / 1000;
                BGMPLAYER_PLAYTIME_GAUGE(startTime, totalTime);
                BGMPLAYER_SET_MUSIC_TITLE(frame, parent, child);
                BGMPLAYER_REDUCTION_SET_TITLE(musicTitle[2]);
                BGMPLAYER_SINGULAR_SELECTION_LISTINDEX(child);
                BGMPLAYER_REDUCTION_SET_PLAYBTN(true);
            end
        end
    end
end

function BGMPLAYER_PLAY_PREVIOUS_BGM(frame, btn)
    if frame == nil then return; end
    if btn == nil then return; end
    local topFrame = frame:GetTopParentFrame();
    if topFrame == nil then return; end

    local mode = tonumber(topFrame:GetUserValue("MODE_ALL_LIST"));
    local option = tonumber(topFrame:GetUserValue("MODE_FAVO_LIST"));
    local bgmType = GET_BGMPLAYER_MODE(topFrame, mode, option);
    local minIndex = tonumber(topFrame:GetUserConfig("TITLE_MIN_INDEX"));
    local maxIndex = tonumber(topFrame:GetUserConfig("TITLE_MAX_INDEX"));

    local curIndex = 0;
    local playRandom = tonumber(topFrame:GetUserConfig("PLAY_RANDOM"));
    if playRandom == 1 then
        SetRandomPlay(playRandom, bgmType, option);
        if bgmType == 1 then   
            curIndex = GetBgmCurIndex();
        elseif bgmType == 0 then 
            curIndex = GetBgmCurFVIndex();
        end
        BGMPLAYER_PLAY_RANDOM(topFrame, curIndex);
        return;
    end

    local parent = GET_CHILD_RECURSIVELY(topFrame, "musicinfo_gb"); 
    local findText = "MUSICINFO_"; 
    if bgmType == 1 then   
        curIndex = GetBgmCurIndex();
    elseif bgmType == 0 then 
        curIndex = GetBgmCurFVIndex();
    end

    if parent == nil then return; end
    local childCnt = parent:GetChildCount();
    if childCnt == nil or childCnt == 0 then return; end
    for i = 1, childCnt do
        local child = parent:GetChildByIndex(i - 1);
        if child ~= nil and string.find(child:GetName(), findText) ~= nil then
            local titleText = GET_CHILD_RECURSIVELY(child, "musictitle_text");
            if titleText == nil then break end

            local musicIndex = titleText:GetTextByKey("value");
            musicIndex = StringSplit(musicIndex, '. ');

            if curIndex - 1 == 0 then
                curIndex = childCnt;
            end

            if tonumber(musicIndex[1]) == curIndex - 1 then
                if bgmType == 1 then 
                    SetBgmCurIndex(curIndex - 1, playRandom);
                elseif bgmType == 0 then
                    SetBgmCurFVIndex(curIndex - 1, playRandom); 
                end

                local musicTitle = titleText:GetTextByKey("value");
                musicTitle = StringSplit(musicTitle, " ");
                musicTitle[2] = GET_BGMPLAYER_MUSIC_TITLE(minIndex, maxIndex, musicTitle);
                PlayBgm(musicTitle[2], child:GetName());
                    
                local startTime = 0;
                local totalTime = GetPlayBgmTotalTime();
                totalTime = totalTime / 1000;
                BGMPLAYER_PLAYTIME_GAUGE(startTime, totalTime);
                BGMPLAYER_SET_MUSIC_TITLE(topFrame, parent, child);
                BGMPLAYER_REDUCTION_SET_TITLE(musicTitle[2]);
                BGMPLAYER_SINGULAR_SELECTION_LISTINDEX(child);
                BGMPLAYER_REDUCTION_SET_PLAYBTN(true);
            end
        end
    end
end

function BGMPLAYER_PLAY_NEXT_BGM(frame, btn)
    if frame == nil then return; end
    if btn == nil then return; end
    local topFrame = frame:GetTopParentFrame();
    if topFrame == nil then return; end

    local mode = tonumber(topFrame:GetUserValue("MODE_ALL_LIST"));
    local option = tonumber(topFrame:GetUserValue("MODE_FAVO_LIST"));
    local bgmType = GET_BGMPLAYER_MODE(topFrame, mode, option);
    local minIndex = tonumber(topFrame:GetUserConfig("TITLE_MIN_INDEX"));
    local maxIndex = tonumber(topFrame:GetUserConfig("TITLE_MAX_INDEX"));

    local playRandom = tonumber(topFrame:GetUserConfig("PLAY_RANDOM"));
    if playRandom == 1 then
        SetRandomPlay(playRandom, bgmType, option);
        if bgmType == 1 then   
            curIndex = GetBgmCurIndex();
        elseif bgmType == 0 then 
            curIndex = GetBgmCurFVIndex();
        end
        BGMPLAYER_PLAY_RANDOM(topFrame, curIndex);
        return;
    end

    local parent = GET_CHILD_RECURSIVELY(topFrame, "musicinfo_gb"); 
    local findText = "MUSICINFO_"; 
    local curIndex = 0;
    if bgmType == 1 then   
        curIndex = GetBgmCurIndex();
    elseif bgmType == 0 then 
        curIndex = GetBgmCurFVIndex();
    end

    if parent == nil then return; end
    local childCnt = parent:GetChildCount();
    if childCnt == nil or childCnt == 0 then return; end
    for i = 1, childCnt do
        local child = parent:GetChildByIndex(i - 1);
        if child ~= nil and string.find(child:GetName(), findText) ~= nil then
            local titleText = GET_CHILD_RECURSIVELY(child, "musictitle_text");
            if titleText == nil then break end

            local musicIndex = titleText:GetTextByKey("value");
            musicIndex = StringSplit(musicIndex, '. ');
            
            if curIndex + 1 == childCnt then
                curIndex = 0;
            end

            if tonumber(musicIndex[1]) == curIndex + 1 then
                if bgmType == 1 then 
                    SetBgmCurIndex(curIndex + 1, playRandom);
                elseif bgmType == 0 then 
                    SetBgmCurFVIndex(curIndex + 1, playRandom);
                end

                local musicTitle = titleText:GetTextByKey("value");
                musicTitle = StringSplit(musicTitle, " ");
                musicTitle[2] = GET_BGMPLAYER_MUSIC_TITLE(minIndex, maxIndex, musicTitle);
                PlayBgm(musicTitle[2], child:GetName());
                
                local startTime = 0;
                local totalTime = GetPlayBgmTotalTime();
                totalTime = totalTime / 1000;
                BGMPLAYER_PLAYTIME_GAUGE(startTime, totalTime);
                BGMPLAYER_SET_MUSIC_TITLE(topFrame, parent, child);
                BGMPLAYER_REDUCTION_SET_TITLE(musicTitle[2]);
                BGMPLAYER_SINGULAR_SELECTION_LISTINDEX(child);
                BGMPLAYER_REDUCTION_SET_PLAYBTN(true);
            end
        end
    end
end

function BGMPLAYER_DOUBLECLICK_PLAY_BGM(ctrlset)
    if ctrlset == nil then return; end

    local frame = ctrlset:GetTopParentFrame();
    if frame == nil then return; end

    local btn = GET_CHILD_RECURSIVELY(frame, "playStart_btn");
    if btn == nil then return; end

    BGMPLAYER_SINGULAR_SELECTION_LISTINDEX(ctrlset);
    BGMPLAYER_PLAY(frame, btn)
end

function BGMPLAYER_PLAY_RANDOM_BGM(frame, btn)
    if frame == nil then return; end
    if btn == nil then return; end

    local topFrame = frame:GetTopParentFrame();
    if topFrame == nil then return; end

    local playRandom = tonumber(topFrame:GetUserConfig("PLAY_RANDOM"));
    local randomBtn_Image = topFrame:GetUserConfig("RANDOM_BTN_IMAGE_NAME");
    local active_randomBtn_Image = topFrame:GetUserConfig("ACTIVE_RANDOM_BTN_IMAGE_NAME");
    
    local repeatBtn_Image = topFrame:GetUserConfig("REPEAT_BTN_IMAGE_NAME");
    local repeatBtn = GET_CHILD_RECURSIVELY(topFrame, "playerRepeat_btn");
    if repeatBtn == nil then return; end    

    if playRandom == 0 then
        topFrame:SetUserConfig("PLAY_RANDOM", 1);
        topFrame:SetUserConfig("PLAY_REPEAT", 0);
        btn:SetImage(active_randomBtn_Image);
        repeatBtn:SetImage(repeatBtn_Image);
    elseif playRandom == 1 then
        topFrame:SetUserConfig("PLAY_RANDOM", 0);
        btn:SetImage(randomBtn_Image);
    end

    local mode = tonumber(topFrame:GetUserValue("MODE_ALL_LIST"));
    local option = tonumber(topFrame:GetUserValue("MODE_FAVO_LIST"));
    playRandom = tonumber(topFrame:GetUserConfig("PLAY_RANDOM"));
    SetRandomPlay(playRandom, mode, option);

    local playRepeat = tonumber(topFrame:GetUserConfig("PLAY_REPEAT"));
    SetRepeatPlay(playRepeat);

    if playRandom == 0 then
        local selectCtrlSetName = topFrame:GetUserValue("CTRLSET_NAME_SELECTED");
        local selectCtrlSet = GET_CHILD_RECURSIVELY(topFrame, selectCtrlSetName);
        local selectindex = 0;
        if selectCtrlSet ~= nil then
            selectindex = StringSplit(selectCtrlSetName, "_");
            selectindex = selectindex[2];
        end 
        
        if mode == 1 and option == 0 then
            SetBgmCurIndex(selectindex, playRandom);
        elseif mode == 0 and option == 1 then
            curIndex = GetBgmCurFVIndex();
            SetBgmCurFVIndex(selectindex, playRandom);
        end
    end
end

function BGMPLAYER_PLAY_REPEAT_BGM(frame, btn)
    if frame == nil then return; end
    if btn == nil then return; end

    local topFrame = frame:GetTopParentFrame();
    if topFrame == nil then return; end

    local playRepeat = tonumber(topFrame:GetUserConfig("PLAY_REPEAT"));
    local repeatBtn_Image = topFrame:GetUserConfig("REPEAT_BTN_IMAGE_NAME");
    local active_repeatBtn_Image = topFrame:GetUserConfig("ACTIVE_REPEAT_BTN_IMAGE_NAME");

    local randomBtn_Image = topFrame:GetUserConfig("RANDOM_BTN_IMAGE_NAME");
    local randomBtn = GET_CHILD_RECURSIVELY(topFrame, "playerRandom_btn");
    if randomBtn == nil then return; end    

    if playRepeat == 0 then
        topFrame:SetUserConfig("PLAY_REPEAT", 1);
        topFrame:SetUserConfig("PLAY_RANDOM", 0);
        btn:SetImage(active_repeatBtn_Image);
        randomBtn:SetImage(randomBtn_Image);
    elseif playRepeat == 1 then
        topFrame:SetUserConfig("PLAY_REPEAT", 0);
        btn:SetImage(repeatBtn_Image);
    end

    local mode = tonumber(topFrame:GetUserValue("MODE_ALL_LIST"));
    local option = tonumber(topFrame:GetUserValue("MODE_FAVO_LIST"));
    local playRandom = tonumber(topFrame:GetUserConfig("PLAY_RANDOM"));
    SetRandomPlay(playRandom, mode, option);

    playRepeat = tonumber(topFrame:GetUserConfig("PLAY_REPEAT"));
    SetRepeatPlay(playRepeat);
end

function BGMPLAYER_HOTKEY_PLAYBTN()
    local frame = ui.GetFrame("bgmplayer");
    if frame == nil then return; end

    local play_btn = GET_CHILD_RECURSIVELY(frame, "playStart_btn");
    if play_btn == nil then return; end

    local parent = play_btn:GetParent();
    if parent == nil then return; end

    BGMPLAYER_PLAY(parent, play_btn);
end

function BGMPLAYER_HOTKEY_NEXT_BGM_PLAYBTN()
    local frame = ui.GetFrame("bgmplayer");
    if frame == nil then return; end

    local play_nextBtn = GET_CHILD_RECURSIVELY(frame, "playerAfter_btn");
    if play_nextBtn == nil then return; end

    local parent = play_nextBtn:GetParent();
    if parent == nil then return; end

    BGMPLAYER_PLAY_NEXT_BGM(parent, play_nextBtn);
end

function BGMPLAYER_HOTKEY_PREVIOUS_BGM_PLAYBTN()
    local frame = ui.GetFrame("bgmplayer");
    if frame == nil then return; end

    local play_prvBtn = GET_CHILD_RECURSIVELY(frame, "playerBefore_btn");
    if play_prvBtn == nil then return; end

    local parent = play_prvBtn:GetParent();
    if parent == nil then return; end

    BGMPLAYER_PLAY_PREVIOUS_BGM(parent, play_prvBtn);
end

function BGMPLAYER_HOTKEY_RANDOM_BGM_PLAYBTN()
    local frame = ui.GetFrame("bgmplayer");
    if frame == nil then return; end

    local play_randomBtn = GET_CHILD_RECURSIVELY(frame, "playerRandom_btn");
    if play_randomBtn == nil then return; end

    local parent = play_randomBtn:GetParent();
    if parent == nil then return; end

    BGMPLAYER_PLAY_RANDOM_BGM(parent, play_randomBtn);
end

function BGMPLAYER_HOTKEY_REPEAT_BGM_PLAYBTN()
    local frame = ui.GetFrame("bgmplayer");
    if frame == nil then return; end

    local play_repeatBtn = GET_CHILD_RECURSIVELY(frame, "playerRepeat_btn");
    if play_repeatBtn == nil then return; end

    local parent = play_repeatBtn:GetParent();
    if parent == nil then return; end

    BGMPLAYER_PLAY_REPEAT_BGM(parent, play_repeatBtn);    
end

function BGMPLAYER_CHANGE_SKIN(frame, btn)
    if frame == nil then return; end
    if btn == nil then return; end

    local topFrame = frame:GetTopParentFrame();
    if topFrame == nil then return; end
    local frameName = topFrame:GetName();

    local isChange = false;
    local skin_mode = tonumber(topFrame:GetUserConfig("SKIN_MODE"));
    if skin_mode == 0 then
        isChange = false;
    elseif skin_mode == 1 then
        isChange = true;
    end
    
    BGMPLAYER_CHANGE_SKIN_GROUP(topFrame, isChange);
    BGMPLAYER_CHANGE_SKIN_TITLE_GROUP(topFrame, isChange);
    BGMPLAYER_CHANGE_SKIN_SET_USERVALUE(topFrame, isChange);
    BGMPLAYER_CHANGE_SKIN_RESET_CONTROL(topFrame, isChange);
    BGMPLAYER_CHANGE_SKIN_SELECTCTRLSET(frame);
    BGMPLAYER_REDUCTION_CHANGE_SKIN(isChange);
end

function BGMPLAYER_CHANGE_SKIN_GROUP(frame, isChange)
    if frame == nil then return; end
    local frameName = frame:GetName();

    local cnt = frame:GetChildCount();
    BGMPLAYER_CHANGE_SKIN_DETAIL(frame, frameName, cnt, isChange);

    local playerctrler_gb = GET_CHILD_RECURSIVELY(frame, "playercontroler_gb");
    if playerctrler_gb == nil then return; end
    local ctrler_gb_ctn = playerctrler_gb:GetChildCount();
    BGMPLAYER_CHANGE_SKIN_DETAIL(playerctrler_gb, frameName, ctrler_gb_ctn, isChange);

    local playermusicinfo_gb = GET_CHILD_RECURSIVELY(frame, "playermusicinfo_gb");
    if playermusicinfo_gb == nil then return; end
    local playermusicinfo_gb_cnt = playermusicinfo_gb:GetChildCount();
    BGMPLAYER_CHANGE_SKIN_DETAIL(playermusicinfo_gb, frameName, playermusicinfo_gb_cnt, isChange);

    local musicAllList_gb = GET_CHILD_RECURSIVELY(frame, "musicAllList_gb");
    if musicAllList_gb == nil then return; end
    local musicAllList_gb_cnt = musicAllList_gb:GetChildCount();
    BGMPLAYER_CHANGE_SKIN_DETAIL(musicAllList_gb, frameName, musicAllList_gb_cnt, isChange);

    local musicbutton_gb = GET_CHILD_RECURSIVELY(frame, "musicbutton_gb");
    if musicbutton_gb == nil then return; end
    local musicbutton_gb_cnt = musicbutton_gb:GetChildCount();
    BGMPLAYER_CHANGE_SKIN_DETAIL(musicbutton_gb, frameName, musicbutton_gb_cnt, isChange);

    local musicinfo_gb = GET_CHILD_RECURSIVELY(frame, "musicinfo_gb");
    if musicinfo_gb == nil then return; end
    local musicinfo_gb_cnt = musicinfo_gb:GetChildCount();
    BGMPLAYER_CHANGE_SKIN_DETAIL(musicinfo_gb, frameName, musicinfo_gb_cnt, isChange);
end

function BGMPLAYER_CHANGE_SKIN_TITLE_GROUP(frame, isChange)
    if frame == nil then return; end

    local title_pic = GET_CHILD_RECURSIVELY(frame, "title_pic");
    if title_pic ~= nil then 
        if isChange == false then
            title_pic:SetVisible(0);
        elseif isChange == true then
            local title_pic_imageName = frame:GetUserConfig("TITLEPIC_CALSSIC_IMAGENAME");
            title_pic:SetImage(title_pic_imageName);
            title_pic:SetVisible(1);
        end
    end

    local title_gb = GET_CHILD_RECURSIVELY(frame, "title_gb");
    if title_gb ~= nil then
        if isChange == false then
            title_gb:SetVisible(0);
        elseif isChange == true then
            local title_gb_skinName = frame:GetUserConfig("TITLEGB_CLASSIC_SKINNAME");
            title_gb:SetSkinName(title_gb_skinName);
            title_gb:SetVisible(1);
        end
    end

    local title_txt = GET_CHILD_RECURSIVELY(frame, "bgm_mugic_title");
    if title_txt ~= nil then
        local changeFormat = "";
        if isChange == false then
            changeFormat = frame:GetUserConfig("TITLETXT_SIMPLE_FORMAT");
            title_txt:SetFormat(changeFormat);
        else
            changeFormat = frame:GetUserConfig("TITLETXT_CLASSIC_FORMAT");
            title_txt:SetFormat(changeFormat);
        end
        title_txt:Invalidate();

        local title_str = title_txt:GetTextByKey("value");
        if title_str ~= nil then
            title_txt:SetTextByKey("value", "");
            title_txt:SetTextByKey("value", title_str);
        end
    end
end

function BGMPLAYER_CHANGE_SKIN_SELECTCTRLSET(frame)
    if frame == nil then return; end
    local selectCtrlSetName = frame:GetUserValue("CTRLSET_NAME_SELECTED");
    local selectCtrlSet = GET_CHILD_RECURSIVELY(frame, selectCtrlSetName);
    if selectCtrlSet ~= nil then
        local gb = selectCtrlSet:GetParent();
        if gb ~= nil then
            local title_txt = GET_CHILD_RECURSIVELY(selectCtrlSet, "musictitle_text");
            local txt = title_txt:GetTextByKey("value");
            local titleName = StringSplit(txt, '. ');
            titleName = titleName[2];
            frame:SetUserValue("MUSIC_TITLE", gb:GetName().."/"..titleName);
        end
        BGMPLAYER_SINGULAR_SELECTION_LISTINDEX(selectCtrlSet);
    end
end

function BGMPLAYER_CHANGE_SKIN_RESET_CONTROL(frame, isChange)
    if frame == nil then return; end
    local mode = tonumber(frame:GetUserValue("MODE_ALL_LIST"));
    local option = tonumber(frame:GetUserValue("MODE_FAVO_LIST"));
    frame:SetUserValue("MODE_ALL_LIST", mode);
    frame:SetUserValue("MODE_FAVO_LIST", option);
    BGMPLAYER_LIST_RESET(frame, mode, option, isChange);
    BGMPLAYER_MODE_OPTION_BTN_RESET(frame, mode, option);
    BGMPLAYER_PALYTYPE_BTN_RESET(frame);
end

function BGMPLAYER_CHANGE_SKIN_SET_USERVALUE(frame, isChange)
    if frame == nil then return; end
    if isChange == false then
        frame:SetUserConfig("SKIN_MODE", 1);
        frame:SetUserConfig("RANDOM_BTN_IMAGE_NAME", "random_simple");
        frame:SetUserConfig("ACTIVE_RANDOM_BTN_IMAGE_NAME", "random_simple_cursoron");
        frame:SetUserConfig("REPEAT_BTN_IMAGE_NAME", "repeat_simple");
        frame:SetUserConfig("ACTIVE_REPEAT_BTN_IMAGE_NAME", "repeat_simple_cursoron");
    else
        frame:SetUserConfig("SKIN_MODE", 0);
        frame:SetUserConfig("RANDOM_BTN_IMAGE_NAME", "random_classic_cursoron");
        frame:SetUserConfig("ACTIVE_RANDOM_BTN_IMAGE_NAME", "random_classic");
        frame:SetUserConfig("REPEAT_BTN_IMAGE_NAME", "repeat_classic_cursoron");
        frame:SetUserConfig("ACTIVE_REPEAT_BTN_IMAGE_NAME", "repeat_classic");
    end    
    local skin_mode = tonumber(frame:GetUserConfig("SKIN_MODE"));
    SetBgmPlayerSkinMode(skin_mode);
end

function BGMPLAYER_CHANGE_SKIN_DETAIL(parent, frameName, childCnt, isChange)
    if parent == nil then return; end
    if childCnt == nil or childCnt <= 0 then return; end

    local gb_width = 0;
    local gb_height = 0;
    if parent:GetName() == frameName then
        if isChange == false then
            gb_width = tonumber(parent:GetUserConfig("SIMPLE_GB_WIDTH"));
            gb_height = tonumber(parent:GetUserConfig("SIMPLE_GB_HEIGHT"));
        else    
            gb_width = tonumber(parent:GetUserConfig("CLASSIC_GB_WIDTH"));
            gb_height = tonumber(parent:GetUserConfig("CLASSIC_GB_HEIGHT"));
        end
    end

    for i = 1, childCnt do
        local child = parent:GetChildByIndex(i - 1);
        if child ~= nil then
            local childName = child:GetName();
            local changeSkinName = child:GetSkinChangeImageNameList(frameName, childName, isChange);
            if changeSkinName ~= nil then
                local classType = child:GetClassString();
                child = AUTO_CAST(child);
                if classType == "ui::CButton" or classType == "ui::CPicture" then
                    child:SetImage(changeSkinName);
                else
                    if childName == "gb" then
                        if isChange == false then
                            child:SetSkinName("None");
                            child:SetImageName(changeSkinName);
                        else
                            child:ClearImageName();
                            child:SetSkinName(changeSkinName);
                        end
                        child:Resize(gb_width, gb_height);
                        child:SetGravity(ui.CENTER_HORZ, ui.BOTTOM);
                    else
                        child:SetSkinName(changeSkinName);
                    end
                end
            end
            child:Invalidate();
        end
    end
end

function BGMPLAYER_MODE_ALL_LIST(frame, btn)
    if frame == nil then return; end
    if btn == nil then return; end

    local topFrame = frame:GetTopParentFrame();
    if topFrame == nil then return; end

    local prvImageName = btn:GetImageName();
    local mode = tonumber(topFrame:GetUserValue("MODE_ALL_LIST"));
    if mode == nil or mode == 0 then
        local imageName = prvImageName.."_clicked";
        btn:SetImage(imageName);
        topFrame:SetUserValue("MODE_ALL_LIST", 1);
        topFrame:SetUserValue("MODE_FAVO_LIST", 0);
    elseif mode == 1 then
        local imageName = StringSplit(prvImageName, "_");
        local imageName_ret = imageName[1].."_"..imageName[2];
        btn:SetImage(imageName_ret);
        topFrame:SetUserValue("MODE_ALL_LIST", 0);
        topFrame:SetUserValue("MODE_FAVO_LIST", 1);
    end

    local skin_mode = tonumber(topFrame:GetUserConfig("SKIN_MODE"));
    local isChange = true;
    if skin_mode == 1 then
        isChange = false;
    else
        isChange = true;
    end

    mode = tonumber(topFrame:GetUserValue("MODE_ALL_LIST"));
    local option = tonumber(topFrame:GetUserValue("MODE_FAVO_LIST"));
    BGMPLAYER_SET_ACTIVATION_LIST_TAB(topFrame, mode, option);
    BGMPLAYER_LIST_RESET(topFrame, mode, option, isChange);
    BGMPLAYER_INIT_SELECTCTRLSET(topFrame);
    SetBgmPlayerListModeOption(mode, option);
end

function BGMPLAYER_MODE_FAVO_LIST(frame, btn)
    if frame == nil then return; end
    if btn == nil then return; end

    local topFrame = frame:GetTopParentFrame();
    if topFrame == nil then return; end

    local prvImageName = btn:GetImageName();
    local option = tonumber(topFrame:GetUserValue("MODE_FAVO_LIST"));
    if option == nil or option == 0 then
        local imageName = prvImageName.."_clicked";
        btn:SetImage(imageName);
        topFrame:SetUserValue("MODE_ALL_LIST", 0);
        topFrame:SetUserValue("MODE_FAVO_LIST", 1);
    elseif option == 1 then
        local imageName = StringSplit(prvImageName, "_");
        local imageName_ret = imageName[1].."_"..imageName[2];
        btn:SetImage(imageName_ret);
        topFrame:SetUserValue("MODE_ALL_LIST", 1);
        topFrame:SetUserValue("MODE_FAVO_LIST", 0);
    end

    local skin_mode = tonumber(topFrame:GetUserConfig("SKIN_MODE"));
    local isChange = true;
    if skin_mode == 1 then
        isChange = false;
    else
        isChange = true;
    end

    local mode = tonumber(topFrame:GetUserValue("MODE_ALL_LIST"));
    option = tonumber(topFrame:GetUserValue("MODE_FAVO_LIST"));
    BGMPLAYER_SET_ACTIVATION_LIST_TAB(topFrame, mode, option);
    BGMPLAYER_LIST_RESET(topFrame, mode, option, isChange);
    BGMPLAYER_INIT_SELECTCTRLSET(topFrame);
    SetBgmPlayerListModeOption(mode, option);
end

function BGMPLAYER_MODE_OPTION_BTN_RESET(frame, mode, option)
    local modeBtn = GET_CHILD_RECURSIVELY(frame, "playerAllList_btn");
    if modeBtn ~= nil then
        local prvImageName = modeBtn:GetImageName();
        if mode == nil or mode == 0 then
            local imageName = StringSplit(prvImageName, "_");
            local imageName_ret = imageName[1].."_"..imageName[2];
            modeBtn:SetImage(imageName_ret);
        elseif mode == 1 then
            local imageName = prvImageName.."_clicked";
            modeBtn:SetImage(imageName);
        end
    end

    local optionBtn = GET_CHILD_RECURSIVELY(frame, "playerFavoritesList_btn");
    if optionBtn ~= nil then
        local prvImageName = optionBtn:GetImageName();
        if option == nil or option == 0 then
            local imageName = StringSplit(prvImageName, "_");
            local imageName_ret = imageName[1].."_"..imageName[2];
            optionBtn:SetImage(imageName_ret);
        elseif option == 1 then
            local imageName = prvImageName.."_clicked";
            optionBtn:SetImage(imageName);
        end
    end
end

function BGMPLAYER_PALYTYPE_BTN_RESET(frame)
    local playRandom = tonumber(frame:GetUserConfig("PLAY_RANDOM"));
    local playRepeat = tonumber(frame:GetUserConfig("PLAY_REPEAT"));
    local randomBtn = GET_CHILD_RECURSIVELY(frame, "playerRandom_btn");
    local repeatBtn = GET_CHILD_RECURSIVELY(frame, "playerRepeat_btn");

    local randomBtn_Image = frame:GetUserConfig("RANDOM_BTN_IMAGE_NAME");
    local active_randomBtn_Image = frame:GetUserConfig("ACTIVE_RANDOM_BTN_IMAGE_NAME");
    local repeatBtn_Image = frame:GetUserConfig("REPEAT_BTN_IMAGE_NAME");
    local active_repeatBtn_Image = frame:GetUserConfig("ACTIVE_REPEAT_BTN_IMAGE_NAME");

    if randomBtn ~= nil and repeatBtn ~= nil then
        if playRepeat == 0 and playRandom == 1 then
            randomBtn:SetImage(active_randomBtn_Image);
            repeatBtn:SetImage(repeatBtn_Image);
        elseif playRepeat == 1 and playRandom == 0 then
            randomBtn:SetImage(randomBtn_Image);
            repeatBtn:SetImage(active_repeatBtn_Image);
        elseif playRepeat == 0 and playRandom == 0 then
            randomBtn:SetImage(randomBtn_Image);
            repeatBtn:SetImage(repeatBtn_Image);
        end
    end
end

function BGMPLAYER_SET_ACTIVATION_LIST_TAB(frame, mode, option)
    if mode == nil then return; end
    if option == nil then return; end
    
    local mode_btn = GET_CHILD_RECURSIVELY(frame, "playerAllList_btn");
    local option_btn = GET_CHILD_RECURSIVELY(frame, "playerFavoritesList_btn");
    if mode_btn ~= nil and option_btn ~= nil then
        local mode_image = mode_btn:GetImageName();
        local option_image = option_btn:GetImageName();

        if mode == 1 and option == 0 then
            if string.find(mode_image, "_clicked") == nil then
                mode_image = mode_image.."_clicked";
                mode_btn:SetImage(mode_image);
            else
                mode_btn:SetImage(mode_image);
            end

            if string.find(option_image, "_clicked") == nil then
                option_btn:SetImage(option_image);
            else
                local image = StringSplit(option_image, "_");
                image = image[1].."_"..image[2];
                option_btn:SetImage(image);
            end
        elseif mode == 0 and option == 1 then
            if string.find(mode_image, "_clicked") == nil then
                mode_btn:SetImage(mode_image);
            else
                local image = StringSplit(mode_image, "_");
                image = image[1].."_"..image[2];
                mode_btn:SetImage(image);
            end

            if string.find(option_image, "_clicked") == nil then
                option_image = option_image.."_clicked";
                option_btn:SetImage(option_image);
            else
                option_btn:SetImage(option_image);
            end
        end
    end
end

function GET_BGMPLAYER_MODE(frame, mode, option)
    if mode == nil then return; end
    if option == nil then return; end

    if mode == 1 and option == 0 then
        return 1;
    elseif mode == 0 and option == 1 then
        return 0;
    end

    return 0;
end

function GET_BGMPLAYER_MUSIC_TITLE(minIndex, maxIndex, musicTitle)
    local spaceStr = "%s";
    local formatStr = "";
    for j = minIndex, maxIndex do
        if musicTitle[j] ~= nil then
            musicTitle[j] = musicTitle[j - 1].." "..musicTitle[j];
            formatStr = string.format(spaceStr, musicTitle[j]);
            musicTitle[2] = formatStr;
        end
    end

    return musicTitle[2];
end