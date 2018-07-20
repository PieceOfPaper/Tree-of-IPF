
function HAIR_GACHA_FULLSCREEN_INIT(addon, frame)
	
end

function HAIR_GACHA_FULLSCREEN_OPEN(frame)

end

function HAIR_GACHA_FULLSCREEN_DO_CLOSE(frame)
	frame:ShowWindow(0)
	
end

function HAIR_GACHA_FULLSCREEN_CLOSE(frame)
	
	local nextframeno = tonumber(frame:GetUserValue("GACHA_FRAME_INDEX") + 1)
	local nextframetype = frame:GetUserValue("GACHA_FRAME_TYPE")

	if nextframeno == 0 then
		return
	end

	if nextframeno <= 11 then
		HAIR_GACHA_POP_BIG_FRAME(nextframeno, nextframetype)
	else
		DARK_FRAME_DO_CLOSE()
	end 
	
end