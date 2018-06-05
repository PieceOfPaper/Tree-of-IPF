
function DIRECTORMODE_ON_INIT(addon, frame)

	addon:RegisterMsg('DIRECTOR_CAPTION', 'SHOW_DIRECTOR_CAPTION');
	
end

function DIRECTORMODE_SIZE_UPDATE(frame)

	if ui.GetSceneHeight() / ui.GetSceneWidth() <= ui.GetClientInitialHeight() / ui.GetClientInitialWidth() then
		frame:Resize(ui.GetSceneWidth() * ui.GetClientInitialHeight() / ui.GetSceneHeight() ,ui.GetClientInitialHeight())
	end
	frame:Invalidate();
end


function DIRECTORMODE_OPEN(frame)

  DIRECTORMODE_SIZE_UPDATE(frame)
	frame:Invalidate();
	local cap = frame:GetChild("caption");
	if cap == nil then
		return;
	end
	
	cap:ShowWindow(0);
	
end

function SHOW_DIRECTOR_CAPTION(frame, msg, argStr, argNum)

	local cap = frame:GetChild("caption");
	if cap == nil then
		return;
	end
	
	cap:SetText("{s20}" .. argStr );
	cap:ShowWindow(1);
	frame:Invalidate();

end