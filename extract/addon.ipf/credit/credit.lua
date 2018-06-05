
function CREDIT_ON_INIT(addon, frame)

end


function CREDIT_OPEN(frame)

	frame:RunUpdateScript("START_CREDIT_SCENE", 0.005);
	local credit_flow = GET_CHILD_RECURSIVELY(frame,'credit_flow')
	credit_flow:SetOffset(credit_flow:GetOriginalX(),credit_flow:GetOriginalY())

	local context = GET_CHILD_RECURSIVELY(frame,'context')
	context:SetUseOrifaceRect(true)

end


function CREDIT_CLOSE(frame)
	frame:StopUpdateScript("START_CREDIT_SCENE");
end

function START_CREDIT_SCENE(frame, totalElapsedTime)

	local credit_flow = GET_CHILD_RECURSIVELY(frame,'credit_flow')
	credit_flow:SetOffset(credit_flow:GetOriginalX(),credit_flow:GetY() - 1)

	if credit_flow:GetY() + credit_flow:GetHeight() < 0 then
		return 0
	end

	return 1

end