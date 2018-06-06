

function MAPFOG_ON_INIT(addon, frame)



end

function MAPFOG_SET_CUR_MAP(frame)

	local pic = GET_CHILD(frame, "map", 'ui::CPicture');

	local mapClassName = session.GetMapName();
	local mapprop = geMapTable.GetMapProp(mapClassName);
	frame:SetTitleName('{@st41}'.. mapprop:GetName());
	pic:SetImage(mapClassName);

	local drag = GET_CHILD(frame, "drag", "ui::CPicture");
	drag:SetAlpha(50.0);

	INIT_MAPFOG_LIST(frame, mapClassName);
	--AUTO_MAPFOG(frame);

end

FOG_DRAG_X = 0;
FOG_DRAG_Y = 0;
FOG_DRAG_W = 0;
FOG_DRAG_H = 0;

function GET_MAPFOG_PIC_OFFSET(frame)
	local pic = GET_CHILD(frame, "map", 'ui::CPicture');
	return pic:GetOffsetX(), pic:GetOffsetY();
end

function GET_MOUSE_CAPTURE_POS(frame, ctrl)

	local x, y = GET_LOCAL_MOUSE_POS(ctrl);
	return x, y;

end

function MAPFOG_CONTEXT(frame, ctrl)

	local context = ui.CreateContextMenu("MAPFOG_CONTEXT", "MAPFOG", 0, 0, 100, 100);
	ui.AddContextMenuItem(context, ScpArgMsg("Auto_SeonTaegChoKiHwa"), "UNSELECT_ALL_FOG_EDIT()");
	ui.AddContextMenuItem(context, ScpArgMsg("Auto_KeuLupJeoJang"), "SAVE_FOG_SELECTED_GROUP()");
	ui.AddContextMenuItem(context, ScpArgMsg("Auto_KeuLupSagJe"), "DELETE_FOG_SELECTED_GROUP()");
	ui.AddContextMenuItem(context, ScpArgMsg("Auto_MeSeJiSeolJeong"), "SET_MSG_SELECTED_GROUP(1)");
	ui.AddContextMenuItem(context, ScpArgMsg("Auto_SaunDeuSeolJeong"), "SET_MSG_SELECTED_GROUP(2)");
	ui.AddContextMenuItem(context, ScpArgMsg("Auto_SeuKeuLipTeuSeolJeong"), "SET_MSG_SELECTED_GROUP(3)");
	ui.OpenContextMenu(context);

end

function UNSELECT_ALL_FOG_EDIT()

	local list = tools.GetMapFogList();
	for i = 0 , list:Count() - 1 do
		local info = list:PtrAt(i);
		info.selected = 0;
	end

	local frame = ui.GetFrame('mapfog');
	UPDATE_MAPFOG_EDIT(frame);

end

function SELECT_MAPFOG_GROUP(frame)

	local groupList = GET_CHILD(frame, "GroupList", "ui::CAdvListBox");
	local id = groupList:GetSelectedKey();
	id = tonumber(id);
	UNSELECT_ALL_FOG_EDIT();
	if id == 0 then
		return;
	end

	local list = tools.GetMapFogList();
	for i = 0 , list:Count() - 1 do
		local info = list:PtrAt(i);
		if info.group == id then
			info.selected = 1;
		end
	end

	UPDATE_MAPFOG_EDIT(frame);
end

function SET_FOG_ADVLIST_ITEM_TEXT(frame, row, col, txt)

	local id = GET_FOG_SELECTED_GROUP(frame);
	if id == 0 then
		return;
	end

	if txt == "" then
		txt = "None"
	end

	local eventInfo = tools.GetFogEventInfo(id);
	if col == 1 then
		eventInfo:SetMsg(txt);
	elseif col == 2 then
		eventInfo:SetSound(txt);
	else
		eventInfo:SetScript(txt);
	end

	UPDATE_MAPFOG_EDIT(frame);

end

function GET_FOG_SELECTED_GROUP(frame)

	local groupList = GET_CHILD(frame, "GroupList", "ui::CAdvListBox");
	local id = groupList:GetSelectedKey();
	id = tonumber(id);

	if id == 0 then
		ui.MsgBox(ScpArgMsg("Auto_KeuLupi_SeonTaegDoeJi_anassSeupNiDa."));
	end

	return id;

end

function SET_MSG_SELECTED_GROUP(col)

	local frame = ui.GetFrame('mapfog');
	local id = GET_FOG_SELECTED_GROUP(frame);
	if id == 0 then
		return;
	end

	INPUT_STRING_BOX(ScpArgMsg("Auto_MeSiJiLeul_ipLyeogHaSeyo"), "EXEC_SET_MSG_SELECTED_GROUP", "", col, 512);
end

function EXEC_SET_MSG_SELECTED_GROUP(inputframe, ctrl)

	if ctrl:GetName() == "inputstr" then
		inputframe = ctrl;
	end

	local col = inputframe:GetValue();

	local txt = GET_INPUT_STRING_TXT(inputframe);
	inputframe:ShowWindow(0);

	local frame = ui.GetFrame("mapfog");
	local group = GET_FOG_SELECTED_GROUP(frame);

	local item = SET_FOG_ADVLIST_ITEM_TEXT(frame, group, col, txt);

end

function SAVE_FOG_SELECTED_GROUP()

	local newID = tools.GetNewGroupID();

	local list = tools.GetMapFogList();
	for i = 0 , list:Count() - 1 do
		local info = list:PtrAt(i);
		if info.selected == 1 then
			info.group = newID;
		end
	end

	local frame = ui.GetFrame('mapfog');
	UPDATE_MAPFOG_EDIT(frame);

	local groupList = GET_CHILD(frame, "GroupList", "ui::CAdvListBox");
	groupList:SelectItemByKey(newID);

end

function DELETE_FOG_SELECTED_GROUP()

	local frame = ui.GetFrame('mapfog');
	local id = GET_FOG_SELECTED_GROUP(frame);
	if id == 0 then
		return;
	end

	local list = tools.GetMapFogList();
	for i = 0 , list:Count() - 1 do
		local info = list:PtrAt(i);
		if info.group == id then
			info.group = 0;
		end
	end

	UNSELECT_ALL_FOG_EDIT();
	UPDATE_MAPFOG_EDIT(frame);

end

function SELECT_MOUSEIN_CONTROL(frame, x, y)

	local changed = 0;
	local px, py = GET_MAPFOG_PIC_OFFSET(frame);
	x = x + px;
	y = y + py;

	local set = GET_FOG_SET();
	local list = tools.GetMapFogList();

	local cnt = frame:GetChildCount();
	for i = 0 , cnt - 1 do
		local ctrl = frame:GetChildByIndex(i);
		local name = ctrl:GetName();
		if ctrl:IsVisible() == set and string.find(name, "_SAMPLE_") ~= nil then
			local cx, cy, cw, ch = GET_XYWH(ctrl);
			if 1 == IS_IN_RECT(x, y, cx, cy, cw, ch) then
				local index = string.sub(name, string.len("_SAMPLE_") + 1, string.len(name));

				--if list:PtrAt(index).selected ~= set then
					list:PtrAt(index).selected = set;
					changed = 1;
				--end
			end
		end
	end

	return changed;
end

function GET_FOG_SET()
	local set = 1;
	if keyboard.IsPressed(KEY_SHIFT) == 1 then
		set = 0;
	end
	return set;
end

function START_DRAG_MAPFOG(frame, ctrl)

	local x, y = GET_MOUSE_CAPTURE_POS(frame, ctrl);

end

function END_DRAG_MAPFOG(frame, ctrl)

	if keyboard.IsPressed(KEY_CTRL) == 1 then
		AUTO_FILL_INRECT_IMAGES(frame);
	end

	UPDATE_MAPFOG_EDIT(frame);

end

function AUTO_FILL_INRECT_IMAGES(frame)

	local list = tools.GetMapFogList();
	local maxRow = tools.GetMaxFogRow();
	local maxCol = tools.GetMaxFogCol();
	for j = 0 , maxCol do
		local c_minR, c_maxR = GET_COL_MINMAX_ROW(j);
		SET_SELECTED_FOG_COL(c_minR, c_maxR, j);
	end
end

function SET_SELECTED_FOG_COL(c_minR, c_maxR, col)

	if c_minR == nil then
		return;
	end

	local maxRow = tools.GetMaxFogRow();
	for i = 0 , maxRow do
		local info = tools.GetMapFogByRowCol(i, col);
		if info ~= nil and info.row >= c_minR and info.row <= c_maxR then
			info.selected = GET_FOG_SET();
		end
	end
end

function GET_COL_MINMAX_ROW(col)

	local maxRow = tools.GetMaxFogRow();
	local c_minR = nil;
	local c_maxR = nil;
	for i = 0 , maxRow do
		local info = tools.GetMapFogByRowCol(i, col);
		if info ~= nil and info.selected == GET_FOG_SET() then
			local row = info.row;
			if c_minR == nil then
				c_minR = row;
			end

			if c_maxR == nil then
				c_maxR = row;
			end

			if row < c_minR then
				c_minR = row;
			end

			if row > c_maxR then
				c_maxR = row;
			end
		end
	end

	return c_minR, c_maxR;
end

function MOUSE_MOVE_MAPFOG(frame, ctrl, lbtnstate, dx, dy)

	if lbtnstate ~= 3 then
		return;
	end

	local x, y = GET_MOUSE_CAPTURE_POS(frame, ctrl);
	if 1 == SELECT_MOUSEIN_CONTROL(frame, x, y) then
		-- UPDATE_MAPFOG_EDIT(frame);
	end

end

function GET_DRAG_IMG(frame)

	return GET_CHILD(frame, "drag", "ui::CPicture");

end

function CLEAR_MAPFOG(frame)

	tools.ClearMapFogInfo();
	UPDATE_MAPFOG_EDIT(frame);

end

function GET_OPTIMIZE_FOGSLICE_CNT(frame, pic, cnt)

	local maxCnt = tools.GetMaxFogSliceCount();
	if cnt > maxCnt then
		cnt = maxCnt;
	end

	local sliceCnt = math.floor(math.pow(cnt, 0.5));
	local beforeCnt = sliceCnt;

	while 1 do
		local realCnt = GET_RESULT_SLICED_CNT(pic, sliceCnt);
		if realCnt > cnt or realCnt == 0 then
			return beforeCnt;
		end

		beforeCnt = sliceCnt
		sliceCnt = sliceCnt + 1;
	end

	return beforeCnt;

end

function GET_RESULT_SLICED_CNT_GROUP(pic, sliceCnt)

	local x, y, w, h = GET_XYWH(pic);
	local sliceWidth = math.floor( w / sliceCnt );
	local sliceHeight = math.floor( h / sliceCnt );

	tools.ClearMapFogInfo();
	for i = 0 , sliceCnt - 1 do
		for j = 0 , sliceCnt - 1 do
			local fog_x = i * sliceWidth;
			local fog_y = j * sliceHeight;

			local havePixel = pic:HavePixelInRect(fog_x, fog_y, sliceWidth, sliceHeight);
			if havePixel == 1 then
				local fx = fog_x - sliceWidth;
				local fy = fog_y - sliceHeight;
				tools.AddMapFogInfo(fx, fy, sliceWidth * 2, sliceHeight * 2, j, i);
			end

		end
	end

	tools.AutoGroupMapFogInfo();
	return tools.GetMapFogGroupCnt();
end

function GET_RESULT_SLICED_CNT(pic, sliceCnt)

	local x, y, w, h = GET_XYWH(pic);
	local sliceWidth = math.floor( w / sliceCnt );
	local sliceHeight = math.floor( h / sliceCnt );

	resultCnt =	0;
	for i = 0 , sliceCnt - 1 do
		for j = 0 , sliceCnt - 1 do
			local fog_x = i * sliceWidth;
			local fog_y = j * sliceHeight;

			local havePixel = pic:HavePixelInRect(fog_x, fog_y, sliceWidth * 2, sliceHeight * 2);
			if havePixel == 1 then
				resultCnt = resultCnt + 1;
			end

		end
	end

	return resultCnt;
end

function AUTO_MAPFOG(frame)

	local cnt = tools.GetMaxFogSliceCount();
	INPUT_STRING_BOX(ScpArgMsg("Auto_JoKagui_KaeSuLeul_ipLyeogHaSeyo."), "EXEC_AUTO_MAPFOG", cnt, 0, 512);

end


function EXEC_AUTO_MAPFOG(inputframe, ctrl)

	if ctrl:GetName() == "inputstr" then
		inputframe = ctrl;
	end

	local inputSlice = tonumber(GET_INPUT_STRING_TXT(inputframe));
	inputframe:ShowWindow(0);

	local frame = ui.GetFrame("mapfog");
	local pic = GET_CHILD(frame, "map", 'ui::CPicture');
	local x, y, w, h = GET_XYWH(pic);

	local sliceCnt = GET_OPTIMIZE_FOGSLICE_CNT(frame, pic, inputSlice);
	local sliceWidth = math.floor( w / sliceCnt );
	local sliceHeight = math.floor( h / sliceCnt );

	local mapName= session.GetMapName();
	local mapprop = geMapTable.GetMapProp(mapName);

	tools.ClearMapFogInfo();
	for i = 0 , sliceCnt - 1 do
		for j = 0 , sliceCnt - 1 do

			local fog_x = i * sliceWidth;
			local fog_y = j * sliceHeight;

			local havePixel = pic:HavePixelInRect(fog_x, fog_y, sliceWidth, sliceHeight);
			if havePixel == 1 then
				local fx = fog_x;
				local fy = fog_y;
				local validPos = IS_VALID_FOG_INFO(fx, fy, sliceWidth * 2, sliceHeight * 2, mapprop);
				tools.AddMapFogInfo(fx, fy, sliceWidth * 2, sliceHeight * 2, j, i, validPos);
			end

		end
	end

	TEST_MAP();
	UPDATE_MAPFOG_EDIT(frame);

end

function IS_VALID_FOG_INFO(x, y, w, h, mapprop)

	if IS_VALID_FOG_POS(x + w / 2, y + h / 2, mapprop) == 1 then
		return 1;
	end

	return 0;

end

function IS_VALID_FOG_POS(miniX, miniY, mapprop)

	local worldPos = GET_WORLD_POS(miniX, miniY, mapprop);
	local isValid = world.IsValidPos(worldPos.x, worldPos.y);
	return isValid;

end

function SAVE_MAPFOG(frame)

	local mapClassName = session.GetMapName();

	--[[tools.ClearFogEventInfo();
	local groupList = GET_CHILD(frame, "GroupList", "ui::CAdvListBox");
	for row = 1 , groupList:GetRowItemCnt()  do
		local msg = groupList:GetObjectXY(row, 1):GetText();
		local snd = groupList:GetObjectXY(row, 2):GetText();
		local scp = groupList:GetObjectXY(row, 3):GetText();
		tools.AddFogEventInfo(groupList:GetKeyByRow(row), msg, snd, scp);
	end]]

	tools.SaveMapFogToXML(mapClassName);
	INIT_MAPFOG_LIST(frame, mapClassName);

end

function INIT_MAPFOG_LIST(frame, mapname)

	tools.LoadMapFogFromXML(mapname);
	UPDATE_MAPFOG_EDIT(frame);

end

function UPDATE_MAPFOG_EDIT(frame)

	LOAD_MAPFOG_LIST(frame);
	LOAD_MAPFOG_GROUP_LIST(frame);
	DRAW_MAPFOG_LIST(frame);

end

function GET_WORLD_POS(miniX, miniY, mapprop)

	local worldPos = mapprop:MinimapPosToWorldPos(miniX, miniY);
	return worldPos;

end

function DRAW_MAPFOG_LIST(frame)

	HIDE_CHILD_BYNAME(frame, "_SAMPLE_");
	local px, py = GET_MAPFOG_PIC_OFFSET(frame);
	local mapPic = GET_CHILD(frame, "map", 'ui::CPicture');

	local list = tools.GetMapFogList();
	local cnt = list:Count();
	for i = 0 , cnt - 1 do

		local info = list:PtrAt(i);
		local name = string.format("_SAMPLE_%d", i);
		local pic = frame:CreateOrGetControl("picture", name, info.x + px, info.y + py, info.w, info.h);
		tolua.cast(pic, "ui::CPicture");
		pic:ShowWindow(1);
		pic:SetImage("fullblack");
		pic:SetEnableStretch(1);
		pic:SetAlpha(50.0);
		pic:EnableHitTest(0);

		if info.selected == 1 then
			pic:ShowWindow(0);
		end

	end

	frame:Invalidate();
end

function LOAD_MAPFOG_LIST(frame)

	local advBox = GET_CHILD(frame, "AdvBox", "ui::CAdvListBox");
	advBox:ClearUserItems();

	local list = tools.GetMapFogList();
	local cnt = list:Count();
	for i = 0 , cnt - 1 do
		local info = list:PtrAt(i);
		local text = string.format("{s14}%d %d %d %d", info.x, info.y, info.w, info.h);
		local item = advBox:SetItem(i, 0, text, "white_14");
	end

end

function LOAD_MAPFOG_GROUP_LIST(frame)

	local groupList = GET_CHILD(frame, "GroupList", "ui::CAdvListBox");
	groupList:ClearUserItems();
	groupList:SetItem(0, 0, "{s14}nil", "white_14");
	local cnt = tools.GetMapFogGroupCnt();
	for i = 0 , cnt - 1 do
		local group = tools.GetMapFogGroup(i);
		if group > 0 then
			local text = string.format("%d", group);
			groupList:SetItem(group, 0, text, "Black_14");

			local eventInfo = tools.GetFogEventInfo(group);
			groupList:SetItem(group, 1, eventInfo:GetMsg(), "white_14");
			groupList:SetItem(group, 2, eventInfo:GetSound(), "white_14");
			groupList:SetItem(group, 3, eventInfo:GetScript(), "white_14");
		end
	end

	groupList:SetTextTooltip(ScpArgMsg("Auto_DeoBeulKeulLigSi_KeuLup_SeonTaeg"));
end

function ADD_MAPFOG(frame, ctrl)

	tools.AddMapFogInfo(FOG_DRAG_X, FOG_DRAG_Y, FOG_DRAG_W, FOG_DRAG_H);
	UPDATE_MAPFOG_EDIT(frame);

end

function DELETE_MAPFOG(frame, ctrl)

	local advBox = GET_CHILD(frame, "AdvBox", "ui::CAdvListBox");
	local id = advBox:GetSelectedKey();
	if id == nil then
		return;
	end

	tools.RemoveMapFogInfo(id);
	tools.RemoveFogEventInfo(id);
	UPDATE_MAPFOG_EDIT(frame);

end






