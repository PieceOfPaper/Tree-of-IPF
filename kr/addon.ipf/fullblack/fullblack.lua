
function FULLBLACK_ON_INIT(addon, frame)
	addon:RegisterMsg('CHANGE_CLIENT_SIZE', 'FRAME_FULLSCREEN');
end

function FULLBLACK_FIRST_OPEN(frame)
	FULLBLACK_RESIZE(frame);
end

function FULLBLACK_RESIZE(frame)
	DIRECTORMODE_SIZE_UPDATE(frame);
	local picture = frame:GetChild('screenmask');
	DIRECTORMODE_SIZE_UPDATE(picture);
end