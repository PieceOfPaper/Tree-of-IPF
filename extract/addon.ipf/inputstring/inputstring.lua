function INPUTSTRING_ON_INIT(addon, frame)



end

function INPUTSTRING_ON_MSG(frame, msg, argStr, argNum)



end

function INPUT_STRING_EXEC(frame)

	local scpName = frame:GetSValue();
	local fromFrameName = frame:GetUserValue("FROM_FR");
	local execScp = _G[scpName];
	local resultString = GET_INPUT_STRING_TXT(frame);
	if fromFrameName == "NULL" then
		execScp(resultString, frame);
	else
		local fromFrame = ui.GetFrame(fromFrameName);
		execScp(fromFrame, resultString, frame);
	end

	frame:ShowWindow(0);
	

end
