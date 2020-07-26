local folderPath = nil
local folderName = nil
local selectPngName = nil
local bindfuncName = nil
local extension = nil
local selectedCtrl = nil
function LOAD_IMAGE_ON_INIT(addon, frame)

end
--SetUserValue
function LOAD_IMAGE_INIT(path, ext)
    folderPath = nil
    folderName = nil
    selectPngName = nil
    bindfuncName = nil

    extension = ext;
    selectedCtrl = nil

    local frame = ui.GetFrame('loadimage')
    if frame ~= nil then
        selectPngName = nil
        folderName = path;
        if folderName == nil then
            ui.MsgBox("프레임 로드할때 패스를 추가해주세요")
            return;
        end
        folderPath = filefind.GetBinPath(folderName):c_str()

        LOAD_IMAGE_LOAD_UPLOAD_LIST(frame)
    
        frame:ShowWindow(1)
    end
end

function LOAD_IMAGE_LOAD_UPLOAD_LIST(frame)

    -- body gbox
	local body = GET_CHILD_RECURSIVELY(frame, "gb_body", "ui::CGroupBox")
    if body == nil then
		return
	end    

    -- 그룹박스내의 DECK_로 시작하는 항목들을 제거
	DESTROY_CHILD_BYNAME(body, 'DECK_')
	local fileList = filefind.FindDirWithConstraint(folderPath, '[a-zA-Z0-9]+',extension)
    local cnt = fileList:Count()
    
    -- 정렬
    local sortList = {};
    local sortListIndex = 1;
    for index = cnt -1 , 0, -1 do
        sortList[sortListIndex] = { fullPathName = folderPath .. '//' .. fileList:Element(index):c_str(), 
                                    fileName = fileList:Element(index):c_str()};
		sortListIndex = sortListIndex +1;
    end
	filefind.DeleteFileList(fileList);

    table.sort(sortList, SORT_BY_NAME);
    -- 정렬된 리스트 중 비정상 파일 필터하고 10개 출력
    local posY = 0
    local count = 0
    for index , v in pairs(sortList) do
        local ctrlSet = body:CreateOrGetControlSet('guild_emblem_deck', "DECK_" .. index, 0, posY)
        local bg = GET_CHILD_RECURSIVELY(ctrlSet, "gb_items")
        bg:SetEventScript(ui.LBUTTONDOWN, "CTRLSET_SELECTED") -- 매개변수로 빼는것이 좋을까..?
        ctrlSet:ShowWindow(1)
            
        posY = SET_PRIVIEW_ITEM(frame, ctrlSet, v.fileName, posY)
        posY = posY -tonumber(frame:GetUserConfig("DECK_SPACE")) -- 가까이 붙이기 위해 좀더 위쪽으로땡김
        count = count + 1
        if count >= 10 then
            break
        end
    end    
end

function SORT_BY_NAME(a,b)
	local aName = a.fileName;
	local bName = b.fileName;
    return aName < bName;
end


function CTRLSET_SELECTED(parent, control)
    if selectedCtrl ~= nil then
        selectedCtrl:SetSkinName("test_skin_01_btn");
    end
    selectedCtrl = control
    control:SetSkinName("bg")

    local gb_items = GET_CHILD(parent,"gb_items", "ui::CGroupBox")
	if gb_items == nil then
		return 
	end
	
	local fileName = gb_items:GetUserValue("FILE_NAME")
    selectPngName = nil
    if fileName ~= nil then
        selectPngName = fileName
    end

    if folderPath ~= nil and selectPngName ~= nil then
        local frame = parent:GetTopParentFrame()
        local fullPath = folderPath .. "\\" .. selectPngName
        local acceptBtn = GET_CHILD_RECURSIVELY(frame, "acceptBtn");
        acceptBtn:SetUserValue("orgPath", folderPath);
        acceptBtn:SetUserValue("fileName", selectPngName);
        acceptBtn:SetUserValue("fullPath", fullPath);
    end
end

function LOAD_IMAGE_OPEN_SAVE_FOLDER(frame)
    OpenUploadEmblemFolder(folderPath)
end

function LOAD_IMAGE_RELOAD()
    LOAD_IMAGE_INIT(folderName)
end

function SET_PRIVIEW_ITEM(frame, ctrlSet, fileName, posY)
    local pngFullPath =  folderPath .. "\\" .. fileName
    
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

function LOAD_IMAGE_CANCEL(frame)
    ui.CloseFrame("loadimage")
end