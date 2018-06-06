
function FULLBLACK_ON_INIT(addon, frame)
	addon:RegisterMsg('CHANGE_CLIENT_SIZE', 'FRAME_FULLSCREEN');
end

function FULLBLACK_FIRST_OPEN(frame)
	FULLBLACK_RESIZE(frame);
end

function FULLBLACK_RESIZE(frame)
	local width, height = FRAME_FULLSCREEN(frame);

	local picture = frame:GetChild('screenmask');
	if picture ~= nil then
		picture:Resize(width, height);
	end
	
	frame:Invalidate();
end

