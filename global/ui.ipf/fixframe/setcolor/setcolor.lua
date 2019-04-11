function SETCOLOR_ON_INIT(addon, frame)
	
end

function SETCOLOR_ONLOAD(frame, object, argStr, argNum)
	local ScreenWidth			=  ui.GetClientInitialWidth();
	local ScreenHeight		=  ui.GetClientInitialHeight();
	
	-- 백그라운드 이미지를 변경한다
	local BackgroundObj		= frame:GetChild('background');
	local BackgroundCtrl		= tolua.cast(BackgroundObj, "ui::CPicture");
	BackgroundCtrl:Resize( ScreenWidth,  ScreenHeight );
end