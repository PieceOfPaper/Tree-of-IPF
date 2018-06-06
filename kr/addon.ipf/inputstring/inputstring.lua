function INPUTSTRING_ON_INIT(addon, frame)



end

function INPUTSTRING_ON_MSG(frame, msg, argStr, argNum)



end

function UPDATE_TYPING_SCRIPT(frame, ctrl)
	local title = frame:GetUserValue("InputType");
	
	if title ~= "InputNameForChange" and title ~= "Family_Name" then
		return;
	end

	local nowlen = ui.GetCharNameLength( ctrl:GetText() );
	if nowlen > 16 then
		ctrl:SetText(frame:GetUserValue("BeforName"))
		return;
	
	end
	frame:SetUserValue("BeforName", ctrl:GetText());

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

	frame:SetUserValue("BeforName", "")
	frame:ShowWindow(0);
end
