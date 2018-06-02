--- likeit.lua --

function UPDATE_LIKE_IT_THROW_UI(throwMonhandle, throwMon_x, throwMon_y)

	local makeFrameName = "THROW_UI_"..throwMonhandle;

	local frame = ui.GetFrame(makeFrameName)
	
	if frame == nil then
		frame = ui.CreateNewFrame("likeit_throw", makeFrameName);
	end
	
	local picture = GET_CHILD_RECURSIVELY(frame,"titlepicture")
	local scale = 0.75 + ( throwMon_y * (1.25-0.75) / ui.GetClientInitialHeight()) 
	picture:ShowWindow(1)
	picture:Resize(picture:GetOriginalWidth()*scale,picture:GetOriginalHeight()*scale)

	frame:SetOffset(throwMon_x-15, throwMon_y-150)
	frame:Invalidate()
end

function END_LIKE_IT_THROW_UI(throwMonhandle, targetHandle)

	local makeFrameName = "THROW_UI_"..throwMonhandle;
	
	local throwframe = ui.GetFrame(makeFrameName)
	throwframe:ShowWindow(0)
	ui.DestroyFrame(makeFrameName)
	

	local OhmakeFrameName = "THROW_UI_OH_"..throwMonhandle;

	local funcStr = string.format("POPOP_OH_UI(%d,\"%s\")", targetHandle, OhmakeFrameName);
	
	ReserveScript(funcStr, 0.05);
end


function POPOP_OH_UI(targetHandle,OhmakeFrameName)

	local Ohframe = ui.GetFrame(OhmakeFrameName)
	
	if Ohframe == nil then
		Ohframe = ui.CreateNewFrame("likeit_oh", OhmakeFrameName);
	end
	Ohframe:RunUpdateScript("UPDATE_OH_UI",0,0.3,0,1);
	Ohframe:SetUserValue("TARGET_HANDLE", targetHandle);
	Ohframe:ShowWindow(1);
	Ohframe:SetDuration(0.3);
end

function UPDATE_OH_UI(frame)

	local targetHandle = frame:GetUserValue("TARGET_HANDLE")
	local point = info.GetPositionInUI(targetHandle, 2);

	local picture = GET_CHILD_RECURSIVELY(frame,"defpicture")
	local scale = 0.75 + ( point.y * (1.25-0.75) / ui.GetClientInitialHeight()) 
	picture:Resize(picture:GetOriginalWidth()*scale,picture:GetOriginalHeight()*scale)
	
	frame:SetOffset(point.x,point.y-45)
	frame:Invalidate()

	return 1
end


function UPDATE_LIKE_IT_THROW_UI_SEND(throwMonhandle, throwMon_x, throwMon_y)

	local makeFrameName = "THROW_UI_"..throwMonhandle;

	local frame = ui.GetFrame(makeFrameName)
	
	if frame == nil then
		frame = ui.CreateNewFrame("likeit_throw", makeFrameName);
		local picture = GET_CHILD_RECURSIVELY(frame,"titlepicture")
		picture:ShowWindow(0)
		frame:SetUserValue("BeforeY",99999)
		
	end

	local BeforeY = frame:GetUserIValue("BeforeY")
	local picture = GET_CHILD_RECURSIVELY(frame,"titlepicture")

	if BeforeY > throwMon_y + 10 then
		picture:ShowWindow(1)
	else
		picture:ShowWindow(0)
	end

	frame:SetUserValue("BeforeY",throwMon_y)
	frame:SetOffset(throwMon_x-15, throwMon_y-150)
	frame:Invalidate()

end


function END_LIKE_IT_THROW_UI_SEND(throwMonhandle, targetHandle)

	local makeFrameName = "THROW_UI_"..throwMonhandle;
	
	local throwframe = ui.GetFrame(makeFrameName)
	throwframe:ShowWindow(0)
	ui.DestroyFrame(makeFrameName)
	
end


function UPDATE_LIKE_IT_THROW_UI_RECEIVE(throwMonhandle, throwMon_x, throwMon_y)

	local makeFrameName = "THROW_UI_"..throwMonhandle;

	local frame = ui.GetFrame(makeFrameName)
	
	if frame == nil then
		frame = ui.CreateNewFrame("likeit_throw", makeFrameName);
		local picture = GET_CHILD_RECURSIVELY(frame,"titlepicture")
		picture:ShowWindow(0)
		frame:SetUserValue("BeforeY",99999)
		
	end

	local BeforeY = frame:GetUserIValue("BeforeY")
	local picture = GET_CHILD_RECURSIVELY(frame,"titlepicture")

	if BeforeY + 10 < throwMon_y then
		picture:ShowWindow(1)
	else
		picture:ShowWindow(0)
	end

	frame:SetUserValue("BeforeY",throwMon_y)
	frame:SetOffset(throwMon_x-15, throwMon_y-150)
	frame:Invalidate()

end


function END_LIKE_IT_THROW_UI_RECEIVE(throwMonhandle, targetHandle)

	local makeFrameName = "THROW_UI_"..throwMonhandle;
	
	local throwframe = ui.GetFrame(makeFrameName)
	throwframe:ShowWindow(0)
	ui.DestroyFrame(makeFrameName)

	local OhmakeFrameName = "THROW_UI_OH_"..throwMonhandle;

	local funcStr = string.format("POPOP_OH_UI(%d,\"%s\")", targetHandle, OhmakeFrameName);
	
	ReserveScript(funcStr, 0.05);
	
end