

function DEBUGMENU_ON_INIT(addon, frame)
	DEBUGMENU_ButtonHide	= 'On'
end 

function DEBUGMENU_OPENCLOSE(frame, data, argStr, argNum)
	--local JumpDebugBtnObj				= frame:GetChild('JumpTest');
	DEBUGMENU_JumpDebugBtn		= tolua.cast(JumpDebugBtnObj, "ui::CButton");
	local ItremCreateBtnObj				= frame:GetChild('ItemCreate');
	DEBUGMENU_ItremCreateBtn		= tolua.cast(ItremCreateBtnObj, "ui::CButton");
	local MonCreateBtnObj				= frame:GetChild('MonsterCreate');
	DEBUGMENU_MonCreateBtn		= tolua.cast(MonCreateBtnObj, "ui::CButton");
	local CheatListBtnObj					= frame:GetChild('CheatList');
	DEBUGMENU_CheatListBtn			= tolua.cast(CheatListBtnObj, "ui::CButton");
	
	if DEBUGMENU_ButtonHide	== 'On' then
		DEBUGMENU_JumpDebugBtn:ShowWindow(1)
		DEBUGMENU_ItremCreateBtn:ShowWindow(1);
		DEBUGMENU_MonCreateBtn:ShowWindow(1);
		DEBUGMENU_CheatListBtn:ShowWindow(1);
		
		DEBUGMENU_ButtonHide = 'Off'
	else
		DEBUGMENU_JumpDebugBtn:ShowWindow(0);
		DEBUGMENU_ItremCreateBtn:ShowWindow(0);
		DEBUGMENU_MonCreateBtn:ShowWindow(0);
		DEBUGMENU_CheatListBtn:ShowWindow(0);
		DEBUGMENU_JumpDebugBtn:ShowWindow(0);
		DEBUGMENU_ButtonHide = 'On'
	end
	
	ui.OpenFrame(frame:GetName());
end