
function DIRECTORMODE_ON_INIT(addon, frame)

	addon:RegisterMsg('DIRECTOR_CAPTION', 'SHOW_DIRECTOR_CAPTION');
	
end

function DIRECTORMODE_SIZE_UPDATE(frame)    
    if frame == nil then return end
    local width = option.GetClientWidth()
        if width < 1920 then width = 1920 end    
        local ratio = option.GetClientHeight() / option.GetClientWidth()
	    local height = width * ratio

    if frame:GetName() == 'screenmask' then        
        frame:Resize(width, height)  
    else
        frame:MoveFrame(0, 0)
	    frame:Resize(width, height)      
	    local screenmask = frame:GetChild('screenmask')
	    if screenmask ~= nil then
		    screenmask:Resize(width, height)  
	    end
    end
	frame:Invalidate();
end


function DIRECTORMODE_OPEN(frame)

  DIRECTORMODE_SIZE_UPDATE(frame)
	frame:Invalidate();
	local cap = frame:GetChild("caption");
	if cap == nil then
		return;
	end
	
	cap:ShowWindow(0);
	
end

function SHOW_DIRECTOR_CAPTION(frame, msg, argStr, argNum)

	local cap = frame:GetChild("caption");
	if cap == nil then
		return;
	end
	
	cap:SetText("{s20}" .. argStr );
	cap:ShowWindow(1);
	frame:Invalidate();

end