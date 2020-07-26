-- recordscrollread.lua

function RECORDSCROLLREAD_ON_INIT(addon, frame)
	addon:RegisterMsg('READ_RECORD_SCROLL', 'ON_READ_RECORD_SCROLL')
end

function ON_READ_RECORD_SCROLL(frame, msg, dialog, argNum)
    local maxPage = RECORD_SCROLL_MAX_PAGE(dialog)

    frame:ShowWindow(1)
    frame:SetUserValue("DIALOG", dialog)
    frame:SetUserValue("MAXPAGE", maxPage)

    control.EnableControl(0,1)
    RECORD_SCROLL_VIEW_PAGE(frame, 1)
end

-- UI PART

function RECORD_SCROLL_UI_INIT(frame)
    frame:SetUserValue("PAGE", 1)
    frame:SetUserValue("MAXPAGE", 0)
end

function RECORD_SCROLL_UI_OPEN(frame)
    frame:RunUpdateScript("RECORD_SCROLL_UPDATE", 0, 0, 0, 1)

    RECORD_SCROLL_UI_INIT(frame)
end

function RECORD_SCROLL_UI_CLOSE(frame)
	frame:ShowWindow(0)
    control.EnableControl(1)
    
    RECORD_SCROLL_UI_INIT(frame)
end

function RECORD_SCROLL_UPDATE(frame)
    if imcinput.HotKey.IsDown("MoveRight") == true then
		RECORD_SCROLL_NEXT_PAGE(frame)
    end
    
    if imcinput.HotKey.IsDown("MoveLeft") == true then
		RECORD_SCROLL_PREV_PAGE(frame)
	end

	return 1;
end

function RECORD_SCROLL_MAX_PAGE(dialogName)
    local dialogTable = GetClass('DialogText', dialogName)
	if dialogTable == nil then
		return
    end

    local text = dialogTable.Text
    local count = 1

    while 1 do
        local index = BookTextFind(text, "{np}")

        if index == -1 then
            break
        else
            text = BookTextSubString(text, index + 4, string.len(text))
            count = count + 1
        end
    end

    return count
end

function RECORD_SCROLL_PREV_PAGE(frame)
    local topFrame = frame:GetTopParentFrame()
    local page = topFrame:GetUserValue("PAGE") - 1
    
    if page < 1 then
        ui.SysMsg(ScpArgMsg("ShowBookItemFirstPage"))
		return
    end
    
	RECORD_SCROLL_VIEW_PAGE(topFrame, page)
end

function RECORD_SCROLL_NEXT_PAGE(frame)
    local topFrame = frame:GetTopParentFrame()
    local page = topFrame:GetUserValue("PAGE") + 1
    local maxPage = tonumber(topFrame:GetUserValue("MAXPAGE"))

    if maxPage > 0 and maxPage < page then
        ui.SysMsg(ScpArgMsg("ShowBookItemLastPage"))
		return
    end

	RECORD_SCROLL_VIEW_PAGE(topFrame, page)
end

function RECORD_SCROLL_VIEW_PAGE(frame, page)
    local maxPage = frame:GetUserValue("MAXPAGE")
    local dialogName = frame:GetUserValue("DIALOG")
    local dialogTable = GetClass('DialogText', dialogName)

	if dialogTable == nil then
		RECORD_SCROLL_UI_CLOSE(frame)
		return
    end

    local text = dialogTable.Text

    for i = 1, page do
        local index = BookTextFind(text, "{np}")

        if i == page then
            if index == -1 then
                text = BookTextSubString(text, 0, string.len(text))
            else
                text = BookTextSubString(text, 0, index + 4)
            end
        else
            text = BookTextSubString(text, index + 4, string.len(text))
        end
    end

    local textObj = GET_CHILD(frame, "text", "ui::CFlowText");
    local pageObj = GET_CHILD(frame, "page", "ui::CRichText");

    textObj:SetText(text)
    textObj:SetFontName('bookfont')
    textObj:SetFlowSpeed(200)
    
    pageObj:SetTextByKey("value", page.."/"..maxPage)

    frame:SetUserValue("PAGE", page)
end