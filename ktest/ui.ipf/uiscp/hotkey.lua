-- hotkey.lua

function HOTKEY_AUTO_MOVE()
	local isStart = convenience.IsAutoMove() == false;
	convenience.AutoMove(isStart);
end

function HOTKEY_ZOOM_IN()
	camera.HotkeyZoomIn();
end

function HOTKEY_ZOOM_OUT()
	camera.HotkeyZoomOut();
end