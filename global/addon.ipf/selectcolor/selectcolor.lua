
function SELECTCOLOR_ON_INIT(addon, frame)

end

function SELECTCOLOR_FIRST_OPEN(addon, frame)

	local selectedColor = GET_CHILD(frame, "selectedColor", "ui::CPicture");
	selectedColor:ClonePicture();

end

function SEL_EXEC_SAMPLE_COLOR(frame, ctrl, str, num)

	SEL_SAMPLE_COLOR(frame, ctrl, str, num);
	EXEC_SELECT_COLOR(frame);

end

function SEL_SAMPLE_COLOR(frame, ctrl, str, num)

	tolua.cast(ctrl, "ui::CPicture");
	local x, y = GET_LOCAL_MOUSE_POS(ctrl);
	local color = ctrl:GetPixelColor(x, y);
	
	local selectedColor = GET_CHILD(frame, "selectedColor", "ui::CPicture");
	selectedColor:FillClonePicture(color);
	frame:Invalidate();
	
end

function EXEC_SELECT_COLOR(frame, ctrl, str, num)

	local scpName = frame:GetSValue();
	RunStringScript(scpName);
	frame:ShowWindow(0);

end








