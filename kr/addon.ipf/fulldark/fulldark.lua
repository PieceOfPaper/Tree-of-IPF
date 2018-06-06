
function  FULLDARK_DO_CLOSE(frame)
	frame:ShowWindow(0)
end

function FULLDARK_OPEN()

	ui.OpenFrame("hair_gacha_skip_btn")
	local frame = ui.GetFrame("hair_gacha_skip_btn")
	frame:ShowWindow(1)
end

function FULLDARK_CLOSE()

	HAIR_GACHA_FRAME_CANCEL_COUNT = HAIR_GACHA_FRAME_COUNT

	local index = HAIR_GACHA_FRAME_COUNT - 10
	if index < 0 then
		index = 0
	end

	while index <= HAIR_GACHA_FRAME_COUNT  do 
		local smallframename = "HAIRGACHA_SMALL_"..tostring(index);
		SMALL_FRAME_SHOWICON(smallframename)
		ReserveScript( string.format("ui.CloseFrame(\"%s\")", smallframename) , 3);
		index = index + 1
	end

	ui.CloseFrame("hair_gacha_skip_btn")
	
end