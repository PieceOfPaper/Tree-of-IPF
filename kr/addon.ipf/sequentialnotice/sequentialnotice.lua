
SEQUENTIALNOTICE_openCount = 0;

function SEQUENTIALNOTICE_ON_INIT(addon, frame)

end

function SEQUENTIALNOTICE_OPEN(frame)

	local index = string.find(frame:GetName(), "SEQUENTIAL_NOTICE_");
	local frameindex = string.sub(frame:GetName(), index + string.len("SEQUENTIAL_NOTICE_"), string.len(frame:GetName()))
	local nowcount = tonumber(frameindex);

	for i = nowcount, 0, -1 do
		local beforeFrameName = "SEQUENTIAL_NOTICE_"..tostring(i);
		local beforeframe = ui.GetFrame(beforeFrameName)
		if beforeframe == nil then
			break;
		end

		local PUSHUP_ANIM_NAME = frame:GetUserConfig("PUSHUP_ANIM_NAME")
		UI_PLAYFORCE(beforeframe, PUSHUP_ANIM_NAME);
	end

end

function SEQUENTIALNOTICE_CLOSE(frame)

	ui.DestroyFrame(frame:GetName());

end

function ADD_SEQUENTIAL_NOTICE(type)

	if type == nil then
		return nil;
	end

	SEQUENTIALNOTICE_openCount = SEQUENTIALNOTICE_openCount + 1;
	local frameName = "SEQUENTIAL_NOTICE_"..tostring(SEQUENTIALNOTICE_openCount);

	ui.DestroyFrame(frameName);

	local frame = ui.CreateNewFrame("sequentialnotice", frameName);
	if frame == nil then
		return nil;
	end

	local duration = tonumber(frame:GetUserConfig("POPUP_DURATION"))


	local mainbox = GET_CHILD_RECURSIVELY(frame, "mainbox");

	-- 타입별 UI세팅
	if type == "havefunparty" then
		mainbox:CreateOrGetControlSet('havefunparty', 'havefunpartyCset', 0, 0);
	end


	
	frame:ShowWindow(1);
	frame:SetDuration(duration);
	frame:Invalidate();
end

-- 파티 매칭 결과에 만족 하는지?
function HAVE_FUN_PARTY_YES()
	party.ResponseHaveFunParty(1)
end

function HAVE_FUN_PARTY_NO()
	party.ResponseHaveFunParty(0)
end
