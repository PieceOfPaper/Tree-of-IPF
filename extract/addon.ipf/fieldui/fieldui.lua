


function FIELDUI_ON_INIT(addon, frame)

	addon:RegisterMsg('CHANGE_CLIENT_SIZE', 'UIEFFECT_CHANGE_CLIENT_SIZE');
	UIEFFECT_CHANGE_CLIENT_SIZE(frame);
	frame:ShowWindow(1);

end
