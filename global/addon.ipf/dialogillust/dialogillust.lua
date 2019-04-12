function DIALOGILLUST_ON_INIT(addon, frame)
	dialogelapsedTime = 0;

	addon:RegisterMsg('DIALOG_CHANGE_OK', 'DIALOGILLUST_ON_MSG');
	addon:RegisterMsg('DIALOG_CHANGE_NEXT', 'DIALOGILLUST_ON_MSG');
	addon:RegisterMsg('DIALOG_CHANGE_SELECT', 'DIALOGILLUST_ON_MSG');	
	addon:RegisterMsg('DIALOG_CLOSE', 'DIALOGILLUST_ON_MSG');
end

--ClassName을 받아, 그것을 Client의 데이터태이블에서, 값을 받아 오는 형식을 구성한다
function DIALOGILLUST_TEXTVIEW(frame, msg, argStr, argNum)
		
    local frame = ui.GetFrame('dialogillust');
	local DialogTable		= GetClass( 'DialogText', argStr);
	if DialogTable == nil then
		local dd = string.find(argStr, "\\");
		if dd ~= nil then
			argStr = string.sub(argStr, 1, dd - 1);
			DialogTable		= GetClass( 'DialogText', argStr);	
		end
	end
	
	local imgObject = frame:GetChild('dialogimage');
	if nil ~= imgObject then
		tolua.cast(imgObject, 'ui::CPicture');
		if DialogTable ~= nil and DialogTable.ImgName ~= 'None' then
			imgObject:SetImage(DialogTable.ImgName);	
		else
			imgObject:SetImage("");
		end
	end

	frame:ShowWindow(1);
end

function DIALOGILLUST_ON_MSG(frame, msg, argStr, argNum)

	frame:Invalidate();

	if  msg == 'DIALOG_CHANGE_OK'  then
		DIALOGILLUST_TEXTVIEW(frame, msg, argStr, argNum)
	end

	if  msg == 'DIALOG_CHANGE_NEXT'  then
		DIALOGILLUST_TEXTVIEW(frame, msg, argStr, argNum)
	end

    if  msg == 'DIALOG_CHANGE_SELECT'  then
		DIALOGILLUST_TEXTVIEW(frame, msg, argStr, argNum)
    end

	if  msg == 'DIALOG_CLOSE'  then
		ui.CloseFrame(frame:GetName());
		dialogelapsedTime = 0;
	end
end
