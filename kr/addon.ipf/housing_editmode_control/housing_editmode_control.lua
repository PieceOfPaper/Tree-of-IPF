function EDITMODE_CONTROL_IMAGE_ATTACH_TO_MOUSE(frame)
	local mx, my = GET_MOUSE_POS();
	tolua.cast(frame, "ui::CFrame");
	local point = frame:ScreenPosToFramePos(mx+13, my);
	point.x = point.x - (frame:GetWidth() / 2);
	point.y = point.y + (frame:GetHeight() / 2);
	frame:SetPos(point.x, point.y);
	return 1;
end