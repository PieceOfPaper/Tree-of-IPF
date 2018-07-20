
function SPRAY_ON_INIT(addon, frame)

	

end
--[[
function SPRAY_FIRST_OPEN(addon, frame)
	local draw_pad = GET_CHILD(frame, "draw_pad", "ui::CPicture");
	draw_pad:CreateInstTexture();
	draw_pad:FillClonePicture("00000000");
	itemutil.SaveTextureUndo(draw_pad); 
	
	local cur_brush_bg = frame:GetChild("cur_brush_bg");
	local cur_brush = GET_CHILD(cur_brush_bg, "cur_brush", "ui::CPicture");
	frame:SetUserValue("BRUSH_NAME", cur_brush:GetImageName());

	frame:RunUpdateScript("UPDATE_SPRAY", 0, 0, 0, 1);
end

function UPDATE_SPRAY(frame)

	local sprayMode = frame:GetUserIValue("TOOLMODE");
	if sprayMode == 1 then

		local pos = view.GetCursurScenePos();	
		itemutil.SetFramePos(pos);
		if mouse.IsLBtnDown() == 1 then
			ui.RemoveGuideMsg("SelectGround");
			ui.GuideMsg("SelectAngleAndClickMouse");
			frame:SetUserValue("TOOLMODE", 2);
		end
		
	elseif sprayMode == 2 then
	
		local pos = view.GetCursurScenePos();	
		itemutil.RotateFrameToPos(pos);

		if mouse.IsLBtnDown() == 1 then
			frame:SetUserValue("TOOLMODE", 3);
			ui.RemoveGuideMsg("SelectAngleAndClickMouse");
			itemutil.ReqDrawSpray();
			frame:ShowWindow(0);
			return 1;
		end
	
	elseif sprayMode == 3 then
	
				
	end


	if keyboard.IsKeyDown("Z") == 1 and keyboard.IsPressed(KEY_CTRL) == 1 then
		local draw_pad = GET_CHILD(frame, "draw_pad", "ui::CPicture");
		itemutil.RedoTexture(draw_pad, -1); 
	end
	
	if keyboard.IsKeyDown("Y") == 1 and keyboard.IsPressed(KEY_CTRL) == 1 then
		local draw_pad = GET_CHILD(frame, "draw_pad", "ui::CPicture");
		itemutil.RedoTexture(draw_pad, 1); 
	end
	
	return 1;
end

function SELECT_SPRAY_COLOR_INDEX(frame, colorList, index)

	tolua.cast(colorList, "ui::CPicture");
	local x, y = GET_LOCAL_MOUSE_POS(colorList);
	local color = colorList:GetPixelColor(x, y);
	frame:SetUserValue("SEL_COLOR_" .. index, color);
	local colIndex = itemutil.GetColIndex(color);
	colorList:SetUserValue("SEL_COLOR_INDEX_"  .. index, colIndex);
	UPDATE_CUR_COLOR_AMOUNT(frame);

	local current_color = GET_CHILD(frame, "current_color_" .. index, "ui::CPicture");
	current_color:ClonePicture();
	current_color:FillClonePicture(color);

end

function SELECT_SPRAY_COLOR_L(frame, colorList)
	SELECT_SPRAY_COLOR_INDEX(frame, colorList, 1);
end

function SELECT_SPRAY_COLOR_R(frame, colorList)
	SELECT_SPRAY_COLOR_INDEX(frame, colorList, 2);
end

function SPRAY_PAD_DOWN(frame, ctrl)
	ctrl:SetUserValue("BTN_DOWN", 1);
	ctrl:SetUserValue("MODIFIED", 0);
end

function SPRAY_PAD_MOVE(frame, ctrl)

	if mouse.IsLBtnPressed() == 0 then
		return;
	end

	tolua.cast(ctrl, "ui::CPicture");
	local x, y = GET_LOCAL_MOUSE_POS(ctrl);
	local col = frame:GetUserValue("SEL_COLOR_1");
	if col == "None" then
		return;
	end

	local brushName = frame:GetUserValue("BRUSH_NAME");
	local brushSize = 1;
	if ctrl:GetUserIValue("BTN_DOWN") == 1 then
		ctrl:DrawBrush(x, y, x, y, brushName, col);
		ctrl:SetUserValue("BTN_DOWN", 0);
	else
		local lastX = ctrl:GetUserIValue("LAST_X");
		local lastY = ctrl:GetUserIValue("LAST_Y");
	
		ctrl:DrawBrush(x ,y, lastX, lastY, brushName, col);
	end

	ctrl:SetUserValue("LAST_X", x);
	ctrl:SetUserValue("LAST_Y", y);	
	ctrl:SetUserValue("MODIFIED", 1);

end

function SPRAY_PAD_UP(frame, ctrl)
	local modified = ctrl:GetUserIValue("MODIFIED");
	if modified == 1 then
		itemutil.SaveTextureUndo(ctrl); 
	end
end

function SELECT_SPRAY_BRUSH_R(frame, picture)

	tolua.cast(picture, "ui::CPicture");
	local brushName = picture:GetImageName();
	frame:SetUserValue("BRUSH_NAME", brushName);
	
	local cur_brush_bg = frame:GetChild("cur_brush_bg");
	local cur_brush = GET_CHILD(cur_brush_bg, "cur_brush", "ui::CPicture");
	cur_brush:SetImage(brushName);

end

function SPRAY_SET_POS(frame, ctrl)
	local draw_pad = GET_CHILD(frame, "draw_pad", "ui::CPicture");
	itemutil.StartLocationSprayByPicture(draw_pad);
	ui.GuideMsg("SelectGround");
	frame:SetUserValue("TOOLMODE", 1);
	frame:RunUpdateScript("UPDATE_SPRAY", 0, 0, 0, 1);

end

]]