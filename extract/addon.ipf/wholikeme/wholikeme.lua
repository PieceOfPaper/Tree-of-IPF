
WHOLIKEME_openCount = 0;

function WHOLIKEME_ON_INIT(addon, frame)

	addon:RegisterMsg('LIKEIT_WHO_LIKE_ME', 'WHOLIKEME_ON_MSG');
	
end

function WHOLIKEME_ON_MSG(frame, msg, argStr, argNum)

	--ADD_WHOLIKEME_NOTICE(argStr) UI가 구려서 일단 뺌
end


function WHOLIKEME_OPEN(frame)

	local index = string.find(frame:GetName(), "WHOLIKEME_");
	local frameindex = string.sub(frame:GetName(), index + string.len("WHOLIKEME_"), string.len(frame:GetName()))
	local nowcount = tonumber(frameindex);

	for i = nowcount, 0, -1 do
		local beforeFrameName = "WHOLIKEME_"..tostring(i);
		local beforeframe = ui.GetFrame(beforeFrameName)
		if beforeframe == nil then
			break;
		end

		local PUSHUP_ANIM_NAME = frame:GetUserConfig("PUSHUP_ANIM_NAME")
		UI_PLAYFORCE(beforeframe, PUSHUP_ANIM_NAME);
	end

end

function WHOLIKEME_CLOSE(frame)

	ui.DestroyFrame(frame:GetName());

end

function ADD_WHOLIKEME_NOTICE(fname)

	WHOLIKEME_openCount = WHOLIKEME_openCount + 1;
	local frameName = "WHOLIKEME_"..tostring(WHOLIKEME_openCount);

	ui.DestroyFrame(frameName);

	local frame = ui.CreateNewFrame("wholikeme", frameName);
	if frame == nil then
		return nil;
	end

	local duration = tonumber(frame:GetUserConfig("POPUP_DURATION"))

	local contextTxt = GET_CHILD_RECURSIVELY(frame, 'context')
	contextTxt:SetTextByKey("fname",fname)
	
	frame:ShowWindow(1);
	frame:SetDuration(duration);
	frame:Invalidate();
end
