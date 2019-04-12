
function  FULLDARK_DO_CLOSE(frame)
	frame:ShowWindow(0)
end

function FULLDARK_OPEN()

	ui.OpenFrame("hair_gacha_skip_btn")
	local frame = ui.GetFrame("hair_gacha_skip_btn")
	frame:ShowWindow(1)
end

function FULLDARK_CLOSE()


	local index = 1

	while index < 12  do 
		local smallframename = "HAIRGACHA_SMALL_"..tostring(index);
		HAIR_GACHA_SMALL_FRAME_SHOWICON(smallframename)
		ReserveScript( string.format("ui.CloseFrame(\"%s\")", smallframename) , 2);
		local bigframename = "HAIRGACHA_BIG_"..tostring(index);
		local eachbigframe = ui.GetFrame(bigframename)
		if eachbigframe ~= nil then
			eachbigframe:SetUserValue("GACHA_FRAME_INDEX",-1)
			ReserveScript( string.format("CLOSE_N_DESTROY_FRAME(\"%s\")", bigframename), 0.5);
		end
		index = index + 1
	end

	ui.CloseFrame("hair_gacha_skip_btn")

	ui.FlushGachaDelayPacket()
	
end


-------------------
function DARK_FRAME_DO_OPEN()

	local darkframe = ui.GetFrame("fulldark")
	darkframe:ShowWindow(1)

end

function DARK_FRAME_DO_CLOSE()

	local darkframe = ui.GetFrame("fulldark")
	darkframe:ShowWindow(0)

end

