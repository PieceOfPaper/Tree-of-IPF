
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
	-- NPC이름 출력 관련 오브젝트
	
    local textObj		= GET_CHILD(frame, "textlist", "ui::CFlowText");

	--기존의 text테이블을 초기화
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

	--페이지를 출력해준다
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

	if DialogTable ~= nil then
		if DialogTable.Caption ~= 'None' then
			titleName = DialogTable.Caption;
		end

		voiceName = DialogTable.VoiceName
	elseif npcDialog ~= nil then

		if npcDialog.Caption ~= 'None' then
			titleName =  npcDialog.Caption;
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
		-- 복잡하다.. 이쪽저쪽에서 중요한 quickslot을 열고 닫고하니버그가 생길 수 밖에 없다.
		if uidirector:IsVisible() == 1 then
			return;
		else
--			ui.OpenFrame('quickslotnexpbar');
--			ui.OpenFrame('minimap');
		end

	end
end

function DIALOG_LEAVE_TRIGGER(frame)

	--전투 시에는 물약 창이 보여야 할 때도 있다. 뭔가 다시 정리가 필요. 연출에 의해서 끌 것인지 아님 레이어도 도는지
	--local uidirector = ui.GetFrame('directormode');
	--if uidirector:IsVisible() ~= 1 then

		--ui.OpenFrame('quickslotnexpbar'); -- 어차피 전투 시작하면 다시 다 켜지지 않나
		--ui.OpenFrame('minimap');
	--end
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

