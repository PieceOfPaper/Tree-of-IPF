
function COLORSPRAY_ON_INIT(addon)

	--[[addon:RegisterMsg('VIEW_RBTN_DOWN', 'COLSPRAY_RBTN_DOWN');
	addon:RegisterMsg('VIEW_LBTN_DOWN', 'COLSPRAY_LBTN_DOWN');
	addon:RegisterMsg('VIEW_LBTN_UP', 'COLSPRAY_LBTN_UP');
	addon:RegisterMsg('VIEW_RBTN_UP', 'COLSPRAY_LBTN_UP');
	addon:RegisterMsg('SPRAY_CREATED', 'ON_SPRAY_CREATED');
	]]
	

end

function COLORSPRAY_FIRST_OPEN(addon, frame)
	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("COLORSPRAY_UPDATE_MOUSEMOVE");
	timer:Start(0.01);
end


function INIT_COLOR_SPRAY(frame)

	local colorList = GET_CHILD(frame, "colorList", "ui::CPicture");
	colorList:ClonePicture();
	
	local maxCol = itemutil.GetMaxSprayColor();
	local row_Cnt = 2;
	local colPerRow = maxCol / row_Cnt;
	
	local colWidth = colorList:GetWidth() / colPerRow;
	local rowHeight =  colorList:GetHeight() / row_Cnt;
	
	local colIndex = 1;
	for j = 0 , row_Cnt - 1 do
		for i = 0 , colPerRow - 1 do
			
			local startX = i * colWidth;
			local startY = j * rowHeight;
			
			local colItem = session.GetInvItemByName("ColorSpray_" .. colIndex);
			if colItem == nil then
				colorList:SetPixelColor(startX, startY, colWidth, rowHeight, 0);
			else
				local sprayColor = itemutil.GetSprayColor(colIndex);
				colorList:SetPixelColor(startX, startY, colWidth, rowHeight, sprayColor);
			end
			
			colIndex = colIndex + 1;
			
		end
		
		colIndex = colIndex + 1;
	end
	
	colorList:SetSValue("FF000000");
	colorList:SetValue(1);
	itemutil.ResetColCounts();
	UPDATE_CUR_COLOR_AMOUNT(frame);
	
end

function END_EDIT_SPRAY()

	itemutil.ReqDrawSpray();

end

function SAVE_EDIT_SPRAY()

	OPEN_FILE_FIND("spraysave", "EXEC_SAVE_SPRAY", 1);

end

function EXEC_SAVE_SPRAY(fileName)

	itemutil.SaveSprayFile(fileName);

end

function LOAD_EDIT_SPRAY()

	OPEN_FILE_FIND("spraysave", "EXEC_LOAD_SPRAY");

end

function EXEC_LOAD_SPRAY(fileName)

	itemutil.LoadSprayFile(fileName);
	UPDATE_CUR_COLOR_AMOUNT(ui.GetFrame("colorspray"));

end


function ON_SPRAY_CREATED(frame)

	frame:ShowWindow(0);

end

function SELECT_SPRAY_COLOR(frame, colorList)

	tolua.cast(colorList, "ui::CPicture");
	local x, y = GET_LOCAL_MOUSE_POS(colorList);
	local color = colorList:GetPixelColor(x, y);
	colorList:SetSValue(color);
	colorList:SetValue(itemutil.GetColIndex(color));
	UPDATE_CUR_COLOR_AMOUNT(frame);
	
end

function COLORSPRAY_UPDATE_MOUSEMOVE(frame)

	if keyboard.IsKeyDown("Z") == 1 and keyboard.IsKeyPressed("LCTRL") == 1 then
		itemutil.UndoSpray();
	end
	
	if keyboard.IsKeyDown("Y") == 1 and keyboard.IsKeyPressed("LCTRL") == 1 then
		itemutil.RedoSpray();
	end
	
	if frame:GetValue() == 0 then

		local pos = view.GetCursurScenePos();	
		itemutil.SetFramePos(pos);
		
	elseif frame:GetValue() == 1 then
	
		local pos = view.GetCursurScenePos();	
		itemutil.RotateFrameToPos(pos);
	
	elseif frame:GetValue() == 3 then
	
		local pos = view.GetCursurScenePos();
		itemutil.SetCurDrawPos(pos);
		UPDATE_COLSPRAY_AMOUNT(frame);
		
	end

end

function START_COLOR_SPRAY(frame)

	itemutil.StartLocationSpray();
	ui.GuideMsg("SelectGround");
	frame:SetValue(0);

end

function COLSPRAY_LBTN_DOWN(frame)

	if itemutil.IsEditingColorSpray() == 0 then
		return;
	end

	local pos = view.GetCursurScenePos();
	
	if frame:GetValue() == 0 then
	
		ui.RemoveGuideMsg("SelectGround");
		frame:SetValue(1);
		ui.GuideMsg("SelectAngleAndClickMouse");
	
	elseif frame:GetValue() == 1 then
	
		frame:SetValue(2);
		itemutil.StartEditSpray();		
		ui.RemoveGuideMsg("SelectAngleAndClickMouse");
		ui.AlarmMsg("SelectPenAndDrawImg");
		
	elseif frame:GetValue() == 2 then
	
		frame:SetValue(3);
		
		local color = GET_COLSPRAY_COLOR(frame);
		local size = GET_COLSPRAY_SIZE(frame);
		itemutil.StartDraw(color, size, pos);
		itemutil.SetCurDrawPos(pos);
	
	end

end

function COLSPRAY_RBTN_DOWN(frame)

	local pos = view.GetCursurScenePos();
	
	if frame:GetValue() == 2 then
	
		frame:SetValue(3);
		
		local size = GET_COLSPRAY_SIZE(frame);
		itemutil.StartDraw(0, size, pos);
		itemutil.SetCurDrawPos(pos);
	
	end

end


function GET_COLSPRAY_COLOR(frame)
	
	local colorList = GET_CHILD(frame, "colorList", "ui::CPicture");
	return imc.GetColorByString( colorList:GetSValue() );
	
end

function SELECT_SPRAY_BRUSH(frame, picture)

	tolua.cast(picture, "ui::CPicture");
	local brushName = picture:GetImageName();
	itemutil.SetBrushName(brushName);
	
end

function GET_COLSPRAY_SIZE(frame)

	return 1;
--	local dugge = GET_CHILD(frame, "dugge", "ui::CNumUpDown");
--	return dugge:GetNumber();
	
end

function COLSPRAY_LBTN_UP(frame)

	if frame:GetValue() == 3 then
	
		frame:SetValue(2);
		itemutil.EndDraw();
	
	end

end

function CLOSE_COLORSPRAY(frame)

	itemutil.EndColorSpray();
	frame:SetValue(0);

	ui.RemoveGuideMsg("SelectGround");
	ui.RemoveGuideMsg("SelectAngleAndClickMouse");
				
end

function UPDATE_COLSPRAY_AMOUNT(frame)

	local isExceeded = IS_EXCEEDED_AMOUNT();
	if isExceeded == 1 then
		itemutil.UndoNotSave();
		ui.AlarmMsg("NotEnoughSpray");
	end
	
	UPDATE_CUR_COLOR_AMOUNT(frame);
end

function UPDATE_CUR_COLOR_AMOUNT(frame)

	local colorList = GET_CHILD(frame, "colorList", "ui::CPicture");
	local curColIndex = colorList:GetValue();
	local hp = GET_CHILD(frame, "hp", "ui::CGauge");
	local hp_x = GET_CHILD(frame, "hp_x", "ui::CRichText");
		
	local colItem = session.GetInvItemByName("ColorSpray_" .. curColIndex);
	if colItem == nil then
		hp:SetPoint(0, MAX_COLSPRAY_PIXEL());
		hp_x:SetTextByKey("itemCnt", 0);
		return;
	end
	
	local obj = GetIES(colItem:GetObject());
	
	local curCnt = itemutil.GetColCount(curColIndex);
	curCnt = curCnt + GET_ADD_SPRAY_USE(curCnt, obj);
	local usable = GET_TOTAL_SPRAY_PIXEL(colItem.count, obj);
	usable = usable - curCnt - 1;
	
	local remainPercent	
	if usable > 0 then
		remainPercent = (usable)  % MAX_COLSPRAY_PIXEL();
	else
		remainPercent = 0;
	end
	
	local remainCnt = math.floor ( (usable) / MAX_COLSPRAY_PIXEL() ) + 1;
	remainCnt = math.abs(remainCnt);
	hp_x:SetTextByKey("itemCnt", remainCnt);
		
	hp:SetPoint(remainPercent, MAX_COLSPRAY_PIXEL());
	
	
end

function IS_EXCEEDED_AMOUNT()

	local maxCol = itemutil.GetMaxSprayColor();
	
	for i = 1 , itemutil.GetMaxSprayColor() do
		local curCnt = itemutil.GetColCount(i);
		if curCnt > 0 then
			local colItem = session.GetInvItemByName("ColorSpray_" .. i);
			if colItem == nil then
				return 1;
			else
				local obj = GetIES(colItem:GetObject());
				local usable = GET_TOTAL_SPRAY_PIXEL(colItem.count, obj);
				if curCnt > usable then
					return 1;
				end
			end
		end
	end
	
	return 0;

end





