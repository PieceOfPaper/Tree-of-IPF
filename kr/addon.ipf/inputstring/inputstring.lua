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

	IMC_NORMAL_INFO("-- INPUT_STRING_EXEC: Begin");
	
	local scpName = frame:GetSValue();
	IMC_NORMAL_INFO("INPUT_STRING_EXEC: scpName("..scpName.. ")");

	local fromFrameName = frame:GetUserValue("FROM_FR");	
	IMC_NORMAL_INFO("INPUT_STRING_EXEC: fromFrameName("..fromFrameName.. ")");

	local execScp = _G[scpName];
	local resultString = GET_INPUT_STRING_TXT(frame);
	IMC_NORMAL_INFO("INPUT_STRING_EXEC: resultString("..resultString.. ")");

	if fromFrameName == "NULL" then
		execScp(resultString, frame);
	else
		local fromFrame = ui.GetFrame(fromFrameName);
		execScp(fromFrame, resultString, frame);
	end

	frame:SetUserValue("BeforName", "")
	frame:ShowWindow(0);
	IMC_NORMAL_INFO("-- INPUT_STRING_EXEC: End");
	

end
