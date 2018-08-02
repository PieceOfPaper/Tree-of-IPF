local emblemFolderPath = nil
local selectPngName = nil

function GUILDEMBLEM_CHANGE_ON_INIT(addon, frame)

end

function GUILDEMBLEM_CHANGE_INIT(frame)
    local frame = ui.GetFrame('guildemblem_change')
    if frame ~= nil then
    
        selectPngName = nil
        emblemFolderPath = filefind.GetBinPath("UploadEmblem"):c_str()

        GUILDEMBLEM_CHANGE_UPDATE_TITLE(frame)
        GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST(frame) -- 컨테이너에 로드
    
        frame:ShowWindow(1)
    end
end

function GUILDEMBLEM_CHANGE_UPDATE_TITLE(frame)
   if frame ~= nil then
        local gb_top = GET_CHILD_RECURSIVELY(frame, 'gb_top'); 
        local tilte_text = GET_CHILD_RECURSIVELY(gb_top, 'title_text'); 
        local isRegisteredEmblem = session.party.IsRegisteredEmblem();
        if isRegisteredEmblem == true then
            tilte_text:SetTextByKey('register', ClMsg("GuildEmblemChange"));
        else
            tilte_text:SetTextByKey('register', ClMsg("GuildEmblemRegister"));
        end
    end	 
end

function GUILDEMBLEM_CHANGE_LOAD_UPLOAD_LIST(frame)

    -- body gbox
	local body = GET_CHILD_RECURSIVELY(frame, "gb_body", "ui::CGroupBox")
	if body == nil then
		return
	end    

    -- 그룹박스내의 DECK_로 시작하는 항목들을 제거
	DESTROY_CHILD_BYNAME(body, 'DECK_')

	local fileList = filefind.FindDirWithConstraint(emblemFolderPath, '[a-zA-Z0-9]+','png')
    local cnt = fileList:Count()
    
    -- 정렬
    local sortList = {};
    local sortListIndex = 1;
    for index = cnt -1 , 0, -1 do
        sortList[sortListIndex] = { fullPathName = emblemFolderPath .. '//' .. fileList:Element(index):c_str(), 
                                    fileName = fileList:Element(index):c_str()};
		sortListIndex = sortListIndex +1;
    end
    table.sort(sortList, SORT_BY_NAME);

    -- 정렬된 리스트 중 비정상 파일 필터하고 10개 출력
    local posY = 0
    local count = 0
    for index , v in pairs(sortList) do
        -- 정상 이미지만 넣는다.
        if session.party.IsValidGuildEmblemImage(v.fullPathName) == true then
            local ctrlSet = body:CreateOrGetControlSet('guild_emblem_deck', "DECK_" .. index, 0, posY)
            ctrlSet:ShowWindow(1)
            posY = _SET_PRIVIEW_ITEM(frame, ctrlSet, v.fileName, posY)
            posY = posY -tonumber(frame:GetUserConfig("DECK_SPACE")) -- 가까이 붙이기 위해 좀더 위쪽으로땡김
            count = count + 1
            if count >= 10 then
                break
            end
        end
    end    
end

function SORT_BY_NAME(a,b)
	local aName = a.fileName;
	local bName = b.fileName;
	return aName < bName;
end

function GUILDEMBLEM_CHANGE_SELECT(parent, ctrl)
    local frame = parent:GetTopParentFrame()
	if frame == nil then
	 return 
	end

    local gb_items = GET_CHILD(parent,"gb_items", "ui::CGroupBox")
	if gb_items == nil then
		return 
	end
	
	local fileName = gb_items:GetUserValue("FILE_NAME")
    selectPngName = nil
    if fileName ~= nil then
        selectPngName = fileName
    end

    if emblemFolderPath ~= nil and selectPngName ~= nil then
        local fullPath = emblemFolderPath .. "\\" .. selectPngName
        GUILDEMBLEM_CHANGE_PREVIEW(frame, fullPath)
    end
end

function GUILDEMBLEM_CHANGE_PREVIEW(frame, emblemName)
    GUILDEMBLEM_LIST_UPDATE(frame)
    DRAW_GUILD_EMBLEM(frame, true, false, emblemName)
end

function GUILDEMBLEM_CHANGE_EXCUTE(isNewRegist, useItem)
    local fullPath = emblemFolderPath .. "\\" .. selectPngName
    local result = session.party.RegisterGuildEmblem(fullPath,false)        
    if result == EMBLEM_RESULT_ABNORMAL_IMAGE then
        ui.SysMsg(ClMsg("AbnormalImageData"))    
        ui.CloseFrame('guildemblem_change')
    end
    GUILDEMBLEM_CHANGE_CANCEL(frame)
end

function GUILDEMBLEM_CHANGE_ACCEPT(frame)
    if selectPngName == nil then
        ui.SysMsg(ClMsg("NoImagesAvailable"))
        GUILDEMBLEM_CHANGE_CANCEL(frame)
        return
    end

    -- 최초 길드 엠블럼 등록.
    GUILDEMBLEM_CHANGE_EXCUTE(true,false)
end

function GUILDEMBLEM_CHANGE_CANCEL(frame)
    local guildinfo = ui.GetFrame('guildinfo');
    GUILDINFO_PROFILE_INIT_EMBLEM(guildinfo);
    ui.CloseFrame('guildemblem_change')
end

function GUILDEMBLEM_CHANGE_OPEN_SAVE_FOLDER(frame)
    OpenUploadEmblemFolder(emblemFolderPath)
end

function GUILDEMBLEM_CHANGE_RELOAD(frame)
    GUILDEMBLEM_CHANGE_INIT(frame)
end


function GUILDEMBLEM_LIST_UPDATE(frame)
    
    if frame == nil then
	 return 
	end

    local gb_body = GET_CHILD(frame, "gb_body", "ui::CGroupBox")
    if gb_body == nil then
	 return 
	end

    -- 업데이트 목록 작성
    local update_list_cnt = 0
    local update_list = {}
    local cnt = gb_body:GetChildCount()
    for i = 0 , cnt - 1 do
        local ctrlSet = gb_body:GetChildByIndex(i)
        local name = ctrlSet:GetName()
        if string.find(name, "DECK_") ~= nil then
           update_list[update_list_cnt] = ctrlSet
           update_list_cnt = update_list_cnt +1
        end 
    end

    -- 갱신
    for index , v in pairs(update_list) do
        local gb_items = GET_CHILD(v, "gb_items", "ui::CGroupBox")
        if gb_items ~= nil then
            local name =  gb_items:GetUserValue("FILE_NAME")
            if(selectPngName == name ) then
                gb_items:SetSkinName(frame:GetUserConfig("SELECT_IMAGE_NAME"))
            else
                gb_items:SetSkinName(frame:GetUserConfig("NOT_SELECT_IMAGE_NAME"))
            end
        end
	end
    
end

function _SET_PRIVIEW_ITEM(frame, ctrlSet, fileName, posY)
    local pngFullPath =  emblemFolderPath .. "\\" .. fileName
    -- 아이콘을 설정한다
	local gb_items = GET_CHILD(ctrlSet, "gb_items", "ui::CGroupBox") 
    local rich_fileName = GET_CHILD(gb_items, "file_name", "ui::CRichText")
	local pic_icon = GET_CHILD(gb_items, "preview_icon", "ui::CPicture")

    -- 선택 이벤트에 사용할 파일 이름 설정
    gb_items:SetUserValue("FILE_NAME",fileName)
        
    -- 이미지 로드 
    pic_icon:SetImage("") -- clear clone image
    pic_icon:SetFileName(pngFullPath)

    -- 텍스트 설정
    rich_fileName:SetTextByKey("value", fileName)
	
    return posY + ctrlSet:GetHeight()
end