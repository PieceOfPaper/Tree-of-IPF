
function DIALOG_ON_INIT(addon, frame)
    local screenWidth 	= ui.GetClientInitialWidth();
    --frame:Resize(frame:GetWidth(), frame:GetHeight());
    --frame:SetOffset( frame:GetX() - 200, 0);

	addon:RegisterMsg('DIALOG_CHANGE_OK', 'DIALOG_ON_MSG');
	addon:RegisterMsg('DIALOG_CHANGE_NEXT', 'DIALOG_ON_MSG');
	addon:RegisterMsg('DIALOG_CHANGE_SELECT', 'DIALOG_ON_MSG');
	addon:RegisterMsg('DIALOG_CLOSE', 'DIALOG_ON_MSG');
	addon:RegisterMsg('ESCAPE_PRESSED', 'DIALOG_ON_PRESS_ESCAPE');
	addon:RegisterMsg('DIALOG_SKIP', 'DIALOG_ON_SKIP');
	addon:RegisterMsg('DIALOG_DIRECT_SELECT_DLG_LIST', 'DIALOG_ON_DIRECT_SELECT_DLG_LIST');
	addon:RegisterMsg('DIALOG_ESCAPE', 'DIALOG_ON_ESCAPE');
	addon:RegisterMsg('LEAVE_TRIGGER', 'DIALOG_LEAVE_TRIGGER');
	addon:RegisterOpenOnlyMsg('UPDATE_COLONY_TAX_RATE_SET', 'ON_DIALOG_UPDATE_COLONY_TAX_RATE_SET');
end

g_lastClassName = nil;

function GET_LAST_DLG_CLS()

	if g_lastClassName == nil then
		return nil;
	end

	return GetClass("DialogText", g_lastClassName);
end

function EDIT_DLG_CONTEXT(frame)

	local cls = GET_LAST_DLG_CLS();
	if cls == nil then
		return;
	end

	

	if 1 == session.IsGM() then
	    local quest_ClassName = GetClassString('DialogText', cls.ClassID, 'ClassName')
        local questdocument = io.open('..\\release\\questauto\\InGameEdit_Dialog.txt','w')
        questdocument:write(quest_ClassName)
        io.close(questdocument)
    
        local path = debug.GetR1Path();
        path = path .. "questauto\\QuestAutoTool_v1.exe";
    
		debug.ShellExecute(path);
	end

--	local editFrame = ui.GetFrame('dialogedit');
--	editFrame:ShowWindow(1);
--	DIALOG_SELECTITEM(editFrame, cls.ClassID)

end

function DIALOG_SHOW_DIALOG_TEXT(frame, text, titleName, voiceName)
	
    local textObj		= GET_CHILD(frame, "textlist", "ui::CFlowText");

	textObj:SetText(" ");

	local dialogFrame = ui.GetFrame('dialog');
	tolua.cast(dialogFrame, "ui::CFrame");

	if titleName == nil then
		dialogFrame:ShowTitleBar(0);
	else
		dialogFrame:ShowTitleBar(1);
		dialogFrame:SetTitleName('{s20}{ol}{gr gradation2}  '..titleName..'  {/}');
	end


	local spaceObj		= GET_CHILD(dialogFrame, "space", "ui::CAnimPicture");
	spaceObj:PlayAnimation();

	local ViewText = string.format('{s20}{b}{#1f100b}' .. text);
	textObj:ClearText();
	textObj:SetText(ViewText);
	textObj:SetVoiceName(voiceName);
    textObj:SetFontName('dialog');
	textObj:SetNextPageFont(string.format('{s20}{b}{#1f100b}'));
	textObj:SetFlowSpeed(35);
	DIALOG_TEXT_VOICE(textObj);
end

function DIALOG_TEXTVIEW(frame, msg, argStr)

	local npcDialog 		= nil
	local DialogTable		= GetClass( 'DialogText', argStr)
	g_lastClassName = argStr;

	local text = "";
	local voiceName = "None";
	local titleName = nil;

	if DialogTable == nil then
		local dd        = string.find(argStr, "\\");
		if dd ~= nil then
			local npcName   = string.sub(argStr, 1, dd - 1);
			npcDialog = GetClass( 'DialogText', npcName);

			local dd = string.find(argStr, "\\");
			argStr = string.sub(argStr, dd + 1, string.len(argStr));
		end

		dd = string.find(argStr, "*@*");
		local tokenList  = TokenizeByChar(argStr, "*@*");
		if #tokenList == 2 then
			titleName = tokenList[1];
			argStr = tokenList[2];
		end
	end
	
	if DialogTable ~= nil then
		text = DialogTable.Text;
	else
		text = argStr;
	end
	
    text = SCR_TEXT_HIGHLIGHT(argStr,text)

	if DialogTable ~= nil then
		if DialogTable.Caption ~= 'None' then
			titleName = DialogTable.Caption;
		else
		    titleName = '';
		end

		voiceName = DialogTable.VoiceName
	elseif npcDialog ~= nil then

		if npcDialog.Caption ~= 'None' then
			titleName =  npcDialog.Caption;
		else
			titleName =  '';
		end
		voiceName = npcDialog.VoiceName
	end


	DIALOG_SHOW_DIALOG_TEXT(frame, text, titleName, voiceName);
end

function DIALOG_ON_MSG(frame, msg, argStr, argNum)
	frame:Invalidate();

	local appsFrame = ui.GetFrame('apps');
	if appsFrame ~= nil and appsFrame:IsVisible() == 1 then
		ui.CloseUI(1);
	end

    ui.ShowChatFrames(0);

	if  msg ~= 'DIALOG_CLOSE'  then
--		ui.CloseFrame('quickslotnexpbar');
--		ui.CloseFrame('minimap');
--		ui.ShowWindowByPIPType(frame:GetName(), ui.PT_LEFT, 1);
--		ui.ShowWindowByPIPType(frame:GetName(), ui.PT_RIGHT, 1);
	end

	if  msg == 'DIALOG_CHANGE_OK'  then

		DIALOG_TEXTVIEW(frame, msg, argStr, argNum)
		frame:ShowWindow(1);
		frame:SetUserValue("DialogType", 1);
	end

	if  msg == 'DIALOG_CHANGE_NEXT'  then
		DIALOG_TEXTVIEW(frame, msg, argStr, argNum)
		frame:ShowWindow(1);
		frame:SetUserValue("DialogType", 1);
	end

    if  msg == 'DIALOG_CHANGE_SELECT'  then
		DIALOG_TEXTVIEW(frame, msg, argStr, argNum);
		local showDialog = 1;
		if argNum > 0 then
			showDialog = 0;
		end
		frame:ShowWindow(showDialog);
		frame:SetUserValue("DialogType", 2);
    end

	if  msg == 'DIALOG_CLOSE'  then
        local textBoxObj	= frame:GetChild('textbox');
		local textObj		= frame:GetChild('textlist');
		textObj:ClearText();
        tolua.cast(textBoxObj, 'ui::CGroupBox')

		frame:ShowWindow(0);
		frame:SetUserValue("DialogType", 0);

		local uidirector = ui.GetFrame('directormode');
		if uidirector:IsVisible() == 1 then
			return;
		else
--			ui.OpenFrame('quickslotnexpbar');
--			ui.OpenFrame('minimap');
		end

	end
end

function DIALOG_LEAVE_TRIGGER(frame)

    --local uidirector = ui.GetFrame('directormode');
	--if uidirector:IsVisible() ~= 1 then

		--ui.OpenFrame('quickslotnexpbar'); 
		--ui.OpenFrame('minimap');
	--end
end

function ON_DIALOG_UPDATE_COLONY_TAX_RATE_SET(frame)
	local needTaxEscape = false;
	local clsName = TryGetProp(GET_LAST_DLG_CLS(), "ClassName");
	if clsName ~= nil then
		if string.find(clsName, "NPC_JUNK_SHOP") ~= nil then
			needTaxEscape = true;
		end
	end

	if needTaxEscape then
		if frame:IsVisible() == 1 then
			control.DialogCancel();
		end
	end
end

function DIALOG_ON_PRESS_ESCAPE(frame, msg, argStr, argNum)
	if frame:IsVisible() == 1 then
		control.DialogCancel();
	end
end

function DIALOG_ON_DIRECT_SELECT_DLG_LIST(frame, msg, argStr, argNum)

	local dialogType = frame:GetUserIValue("DialogType");
	if dialogType == 2 then
		session.SetSelectDlgList();
		ui.OpenFrame('dialogselect');
	end
end

function DIALOG_SEND_OK(frame)

	local clientScp = frame:GetUserValue("DIALOGOKSCRIPT");
	if clientScp == "None" then
		control.DialogOk();
	else
		local func = _G[clientScp]
		func();
		frame:ShowWindow(0);
		ui.CloseFrame("dialogillust");
		frame:SetUserValue("DIALOGOKSCRIPT", "None");
	end
	
end

function DIALOG_ON_SKIP(frame, msg, argStr, argNum)

	local textObj = GET_CHILD(frame, "textlist", "ui::CFlowText");

	local dialog_NewOpen = frame:GetUserIValue("DialogNewOpen");
	
	if dialog_NewOpen == 0 then
		if frame:IsVisible() == 1 then
			if textObj:IsFlowed() == 1 and textObj:IsNextPage() == 1 then
				textObj:SetNextPage(0);
			elseif textObj:IsFlowed() == 1 and textObj:IsNextPage() == 0 then
				textObj:SetNextPage(1);
				textObj:SetFlowSpeed(35);
				DIALOG_TEXT_VOICE(textObj);
			else
				local dialogType = frame:GetUserIValue("DialogType");
				if dialogType == 1 then
					frame:Invalidate();
					DIALOG_SEND_OK(frame);
				elseif dialogType == 2 then
					session.SetSelectDlgList();
					ui.OpenFrame('dialogselect');
				end
			end
		end
	else
		local illustFrame = ui.GetFrame('dialogillust');

		frame:Invalidate();
		frame:ShowWindow(0);
		illustFrame:ShowWindow(0);

		local dialog_NewOpenDuration = frame:GetUserValue("DialogNewOpenDuration");
		if dialog_NewOpenDuration == "None" then
			dialog_NewOpenDuration = 0;
		else
			dialog_NewOpenDuration = tonumber(dialog_NewOpenDuration);
		end

		frame:SetOpenDuration(dialog_NewOpenDuration);
		illustFrame:SetOpenDuration(dialog_NewOpenDuration);
	end
end

function DIALOG_OPEN(frame, ctrl, argStr, argNum)
	local textObj = frame:GetChild('textlist');
	tolua.cast(textObj, 'ui::CFlowText');
	frame:Invalidate();

	local dialog_NewOpen = frame:GetUserIValue("DialogNewOpen");
	if dialog_NewOpen == 1 then
		textObj:SetNextPage(1);
		textObj:SetFlowSpeed(15);
		frame:SetUserValue("DialogNewOpen", 0);
	end


end

function DIALOG_ON_ESCAPE(frame, msg, argStr, argNum)

	local textObj		= frame:GetChild('textlist');
    tolua.cast(textObj, 'ui::CFlowText');

	if frame:IsVisible() == 1 then
		local dialogType = frame:GetUserIValue("DialogType");
		if dialogType == 1 then
			frame:Invalidate();
			control.DialogEscape();
		elseif dialogType == 2 then
			textObj:PassAllText();
			session.SetSelectDlgList();
			ui.OpenFrame('dialogselect');
		end
	end
end

function DIALOG_CLOSE_OPEN(frame, ctrl, argStr, argNum)
	frame:SetUserValue("DialogNewOpen", 1);
	frame:SetUserValue("DialogNewOpenDuration", argNum);
end

