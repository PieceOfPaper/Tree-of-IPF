function INDUNINFO_PVPREWARD_UI_OPEN(frame)
end

function INDUNINFO_PVPREWARD_UI_CLOSE(frame)
    frame:ShowWindow(0)
end

function INIT_INDUNINFO_PVPREWARD(frame,argStr)
	local rewardInfoText = GET_CHILD_RECURSIVELY(frame,"rewardInfoText")
	local msg = ScpArgMsg(argStr)
	rewardInfoText:SetText(msg)
end