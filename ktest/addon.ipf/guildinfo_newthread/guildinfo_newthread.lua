

function guildinfo_newthread_ON_INIT(addon, frame)
end


function ADD_NEW_ONELINE_BOARD(parent, control)
    
    local frame = ui.GetFrame("guildinfo_newthread");

    local inputText = GET_CHILD_RECURSIVELY(frame, "input");
    local text = inputText:GetText()
    if text == "" then 
        return
    end

    local badword = IsBadString(text)
    if badword ~= nil then
        ui.MsgBox(ScpArgMsg('{Word}_FobiddenWord','Word',badword, "None", "None"));
        return
    end     
    if WriteOnelineBoard("RECV_NEW_ONELINE_BOARD", text) == false then
        ui.SysMsg(ClMsg('NotYetExcute'))
    end
end

function RECV_NEW_ONELINE_BOARD(code, ret_json)
	if code ~= 200 then
		SHOW_GUILD_HTTP_ERROR(code, ret_json, "RECV_NEW_ONELINE_BOARD");
        return;
    end
    REFRESH_BOARD()
    ui.SysMsg(ClMsg('UploadSuccess'))

    local frame = ui.GetFrame("guildinfo_newthread");

    local inputText = GET_CHILD_RECURSIVELY(frame, "input");
    inputText:SetText("")
    ui.CloseFrame("guildinfo_newthread")
end

function UPDATE_THREAD_LENGTH()
    local frame = ui.GetFrame("guildinfo_newthread");

    local inputText = GET_CHILD_RECURSIVELY(frame, "input");
    local length = ui.GetPaperLength(inputText:GetText())

    local stringLen = GET_CHILD_RECURSIVELY(frame, "stringLen");
    stringLen:SetTextByKey("len", length);
end

function GUILDINFO_NEWTHREAD_OPEN()
    local frame = ui.GetFrame("guildinfo_newthread");

    local inputText = GET_CHILD_RECURSIVELY(frame, "input");
    inputText:SetText("")

    local stringLen = GET_CHILD_RECURSIVELY(frame, "stringLen");
    stringLen:SetTextByKey("len", "0");
end