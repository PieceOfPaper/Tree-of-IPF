-- fulldark_legendcardslot_open.lua

function PLAY_LEGENDCARD_OPEN_EFFECT(pc)
	ui.OpenFrame("fulldark_legendcardslot_open")
	local frame = ui.GetFrame("fulldark_legendcardslot_open")

	local slot = GET_CHILD_RECURSIVELY(frame, "effectSlot");
	local screenWidth	= ui.GetSceneWidth();
	local screenHeight	= ui.GetSceneHeight();
	movie.PlayUIEffect(frame:GetUserConfig("LEGENDCARD_OPEN_EFFECT"), screenWidth/2, screenHeight/2, tonumber(frame : GetUserConfig("LEGENDCARD_OPEN_EFFECT_SCALE")))
	local duration = frame:GetUserConfig("FRAME_DURATION")
	frame:SetDuration(duration);
end