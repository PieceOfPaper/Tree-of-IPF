
minimapw = 0;
minimaph = 0;

function GET_MINIMAPSIZE()
	return config.GetXMLConfig("MinimapSize");
end

function SET_MINIMAPSIZE(cursize)
	config.ChangeXMLConfig("MinimapSize", cursize);
end

MAX_MINIMAP_RATE = 160;
MIN_MINIMAP_RATE = -80;

function SET_MINIMAP_SIZE(amplify)

	local cursize = GET_MINIMAPSIZE();
	
	if amplify == 1 then
		cursize = cursize + 20;
		if cursize == MAX_MINIMAP_RATE then
			return;
		end
	else
		cursize = cursize - 20;
		if cursize == MIN_MINIMAP_RATE then
			return;
		end
	end

	SET_MINIMAPSIZE(cursize);

	local frame = ui.GetFrame('minimap');
	UPDATE_MINIMAP(frame);
	MINIMAP_CHAR_UDT(frame);
end

function MINIMAP_MOUSEWHEEL(frame, ctrl, argStr, argNum)
	local cursize = GET_MINIMAPSIZE();
	
	if argNum > 0 then
		SET_MINIMAP_SIZE(1);
	else
		SET_MINIMAP_SIZE(0);
	end
	
end

mini_pos = nil;
mini_frame_g_x = 0;
mini_frame_g_y = 0;
mini_frame_hw = 0;
mini_frame_hh = 0;

function MINIMAP_ON_RELOAD(frame)
	mini_pos = GET_CHILD(frame, "my");
end

function MINIMAP_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg('MAP_CHARACTER_UPDATE', 'MINIMAP_CHAR_UDT');
	addon:RegisterOpenOnlyMsg('ANGLE_UPDATE', 'M_UPT_ANGLE');

	addon:RegisterOpenOnlyMsg('GAME_START', 'UPDATE_MINIMAP');
	addon:RegisterOpenOnlyMsg('QUEST_UPDATE', 'UPDATE_MINIMAP_SOBJ');
	addon:RegisterOpenOnlyMsg('GET_NEW_QUEST', 'UPDATE_MINIMAP_SOBJ');

	addon:RegisterOpenOnlyMsg('NPC_STATE_UPDATE', 'UPDATE_MINIMAP_NPC_STATE');
	addon:RegisterMsg('PARTY_INST_UPDATE', 'M_MAP_UPDATE_PARTY_INST');
	addon:RegisterMsg('PARTY_UPDATE', 'M_MAP_UPDATE_PARTY');
	addon:RegisterMsg('GUILD_INFO_UPDATE', 'M_MAP_UPDATE_GUILD');
	
	addon:RegisterMsg('MON_MINIMAP', 'MAP_MON_MINIMAP');
	addon:RegisterMsg('MON_MINIMAP_END', 'ON_MON_MINIMAP_END');
    addon:RegisterMsg('COLONY_MONSTER', 'MINIMAP_COLONY_MONSTER');

	mini_pos = GET_CHILD(frame, "my");
	mini_pos:SetOffset(frame:GetWidth() / 2 - mini_pos:GetImageWidth() / 2 , frame:GetHeight() / 2 - mini_pos:GetImageHeight() / 2);

	local pictureui  =	GET_CHILD(frame, 'map', 'ui::CPicture');
	local mapName= session.GetMapName();
	INIT_MAP_PICTURE_UI(pictureui , mapName, 0);
	pictureui:SetImage(mapName .. "_fog");

	local map_bg = GET_CHILD(frame, "map_bg", "ui::CPicture");
	map_bg:SetImage(mapName .. "_fog");

	mini_frame_g_x = frame:GetGlobalX();
	mini_frame_g_y = frame:GetGlobalY();
	mini_frame_hw = frame:GetWidth() / 2;
	mini_frame_hh = frame:GetHeight() / 2;

	local npcList = frame:GetChild('npclist')
	npcList:SetValue2(1);
	
	frame:SetEventScript(ui.MOUSEWHEEL, "MINIMAP_MOUSEWHEEL");

end

function MINIMAP_FIRST_OPEN(frame)

	UPDATE_MINIMAP(frame, 1);

end

function UPDATE_MINIMAP_SOBJ(frame)

	DESTROY_CHILD_BYNAME(frame, "_INDIC_");
	UPDATE_MINIMAP(frame);

end

function UPDATE_MINIMAP_NPC_STATE(frame)
	local npcList = GET_CHILD(frame, 'npclist', 'ui::CGroupBox');
	UPDATE_NPC_STATE_COMMON(npcList);
end

function UPDATE_MINIMAP(frame, isFirst)

	if session.DontUseMinimap() == true then
		frame:ShowWindow(0);
		return;
	end

	local mylevel = info.GetLevel(session.GetMyHandle());

	local cursize = GET_MINIMAPSIZE();
	local zoominfo = frame:GetChild("ZOOM_INFO");
	local percent = (100 + cursize) / 100;
	zoominfo:SetText(string.format("x{b}%1.1f", percent));

	local curmapname = session.GetMapName();
	local imgfilename = curmapname;
	if ui.IsImageExist(imgfilename) == 0 then
		frame:ShowWindow(0);
		return;
	end

	local mapprop = geMapTable.GetMapProp(curmapname);

	local pictureui  = GET_CHILD(frame, "map", "ui::CPicture");	
	
	minimapw = pictureui:GetImageWidth() * (100 + cursize) / 100;
	minimaph = pictureui:GetImageHeight() * (100 + cursize) / 100;

	pictureui:Resize(minimapw, minimaph);
	local map_bg = GET_CHILD(frame, "map_bg", "ui::CPicture");
	map_bg:Resize(minimapw, minimaph);
	
	local mapname = mapprop:GetClassName();
	local npclist = {};
	local statelist = {};
	local questIESlist  = {};
	local questPropList = {};

	GET_QUEST_NPC_NAMES(mapname, npclist, statelist, questIESlist, questPropList);

	local npcList = frame:GetChild('npclist')
	tolua.cast(npcList, 'ui::CGroupBox');
	DESTROY_CHILD_BY_USERVALUE(npcList, "EXTERN", "None");
	npcList:Resize(minimapw, minimaph);

	local mongens = mapprop.mongens;
	if mongens ~= nil then
		local mapNpcState = session.GetMapNPCState(mapprop:GetClassName());
		local cnt = mongens:Count();
		local WorldPos;
		local minimapPos;

		for i = 0 , cnt - 1 do
			local MonProp = mongens:Element(i);

			if MonProp.Minimap >= 1 then
				local GenList = MonProp.GenList;
				local GenCnt = GenList:Count();
				for j = 0 , GenCnt - 1 do
					WorldPos = GenList:Element(j);
					local MapPos = mapprop:WorldPosToMinimapPos(WorldPos, minimapw, minimaph);

					local miniX = MapPos.x - iconW / 2;
					local miniY = MapPos.y - iconH / 2;
					local ctrlname = GET_GENNPC_NAME(npcList, MonProp);
					local PictureC = npcList:CreateOrGetControl('picture', ctrlname , miniX, miniY, iconW, iconH);
					tolua.cast(PictureC, "ui::CPicture");		
				
					PictureC:SetUserValue("GlobalX", PictureC:GetGlobalX());
					PictureC:SetUserValue("GlobalY", PictureC:GetGlobalY());
				
					SET_MAP_MONGEN_NPC_INFO(PictureC, mapprop, WorldPos, MonProp, mapNpcState, npclist, statelist, questIESlist);				

					if PictureC:GetUserIValue("IsHide") == 1 then
						PictureC:ShowWindow(0);
					end

				end
			end
		end
	end

	local quemon = mapprop.questmonster;
	if quemon ~= nil then
		local quemoncnt = quemon:Count();

		local WorldPos = nil;
		for i = 0 , quemoncnt - 1 do
			local quemoninfo = quemon:Element(i);
			local idx = GET_QUEST_IDX(quemoninfo, questIESlist);

			if idx ~= -1 and statelist[idx] == 'PROGRESS' then
				local cls = questIESlist[idx];
				WorldPos = quemoninfo.Pos;
				local MapPos = mapprop:WorldPosToMinimapPos(WorldPos, minimapw, minimaph);

				local cursize = GET_MINIMAPSIZE();
				local RangeX = quemoninfo.GenRange * MINIMAP_LOC_MULTI * minimapw / WORLD_SIZE;
				local RangeY = quemoninfo.GenRange * MINIMAP_LOC_MULTI * minimaph / WORLD_SIZE;

				local miniX = MapPos.x - RangeX / 2;
				local miniY = MapPos.y - RangeY / 2;
                
				local ctrlname = "_NPC_MON_MARK" .. quemoninfo.QuestType.. "_" .. i .. "_" ..quemoninfo.MonsterType;
				local PictureC = npcList:CreateOrGetControl('picture', ctrlname, miniX, miniY, miniX, miniY);
				SET_MAP_CIRCLE_MARK_UI(PictureC);
				PictureC:SetValue(quemoninfo.QuestType);

				XC = MapPos.x - iconW / 2;
				YC = MapPos.y - iconH / 2;

				ctrlname = "_NPC_MON_" .. quemoninfo.QuestType.. "_" .. i .. "_" .. quemoninfo.MonsterType;
				PictureC = npcList:CreateOrGetControl('picture', ctrlname, XC, YC, iconW, iconH);
				tolua.cast(PictureC, "ui::CPicture");
				SET_PICTURE_BUTTON(PictureC);

				SET_MINIMAP_NPC_ICON(PictureC, WorldPos, idx, statelist, questIESlist)
			end
		end

	end

	local mapname = mapprop:GetClassName();
	local cnt = #questPropList;
	for i = 1 , cnt do
		local questprop = questPropList[i];
		local cls = questIESlist[i];
		local stateidx = STATE_NUMBER(statelist[i]);

		if stateidx ~= -1 then
			local locationlist = questprop:GetLocation(stateidx);
			if locationlist ~= nil then
				local loccnt = locationlist:Count();
				for k = 0 , loccnt - 1 do
					local locinfo = locationlist:Element(k);
					if mapname == locinfo:GetMapName() then

						WorldPos = locinfo.point;
						if WorldPos == nil then
							local npcFuncName = locinfo:GetNpcName();
							if npcFuncName ~= "None" then
								local GenList = GET_MONGEN_NPCPOS(mapprop, npcFuncName);
								if GenList ~= nil then
									local GenCnt = GenList:Count();
									for j = 0 , GenCnt - 1 do
										WorldPos = GenList:Element(j);
										local MapPos = mapprop:WorldPosToMinimapPos(WorldPos, minimapw, minimaph);
										local XC, YC, RangeX, RangeY = GET_MINIMAP_POS_BY_MAPPOS(MapPos, locinfo, mapprop, minimapw, minimaph);

										MAKE_LOC_CLICK_ICON(npcList, i, stateidx, k, XC, YC, RangeX, RangeY, 30);
										XC, YC = GET_MINI_ICON_POS_BY_MAPPOS(MapPos.x, MapPos.y, iconW, iconH);
										MAKE_LOC_ICON(npcList, cls, i, stateidx, k, XC, YC, iconW, iconH, WorldPos, statelist, questIESlist);
									end
								end
							end
						else
							local MapPos = mapprop:WorldPosToMinimapPos(WorldPos, minimapw, minimaph);
							local XC, YC, RangeX, RangeY = GET_MINIMAP_POS_BY_MAPPOS(MapPos, locinfo, mapprop, minimapw, minimaph);

							MAKE_LOC_CLICK_ICON(npcList, i, stateidx, k, XC, YC, RangeX, RangeY, 30)
							XC, YC = GET_MINI_ICON_POS_BY_MAPPOS(MapPos.x, MapPos.y, iconW, iconH);
							MAKE_LOC_ICON(npcList, cls, i, stateidx, k, XC, YC, iconW, iconH, WorldPos, statelist, questIESlist)

						end

					end
				end
			end
		end
	end

	local cnt = #questIESlist;
	for i = 1 , cnt do
		local cls = questIESlist[i];
		local stateidx = STATE_NUMBER(statelist[i]);

		local s_obj = GetClass("SessionObject", cls.Quest_SSN);
		if s_obj ~= nil then
			local sobjinfo = session.GetSessionObject(s_obj.ClassID);
			if sobjinfo ~= nil then
				local obj = GetIES(sobjinfo:GetIESObject());
				local roundCount = 0;
				for k = 1, SESSION_MAX_MAP_POINT_GROUP do
					local mapPointGroupStr = obj["QuestMapPointGroup" .. k];
					local mapPointGroupView = obj["QuestMapPointView" .. k];
					if mapPointGroupStr ~= "None" and mapPointGroupView == 1 then
						local genName = "None";
						local genType = 0;
						local count = 0;
						local checkMapName = "None";
						local x, y, z, range = 0;

						for locationMapName in string.gfind(mapPointGroupStr, "%S+") do
							if count == 0 and locationMapName ~= mapname then
								count = 0;
								roundCount = roundCount + 1;
								break;
							elseif count == 0 and locationMapName == mapname then
								checkMapName = locationMapName;
							end

							if count == 1 then
								local GenList = GET_MONGEN_NPCPOS(mapprop, locationMapName);
								if GenList == nil then
									x = tonumber(locationMapName);
								else
									genType = 1;
									genName = locationMapName;
								end
							elseif count == 2 then
								if genType == 0 then
									y = tonumber(locationMapName);
								else
									range = tonumber(locationMapName);
									local GenList = GET_MONGEN_NPCPOS(mapprop, genName);
									local GenCnt = GenList:Count();
									for j = 0 , GenCnt - 1 do
										local WorldPos = GenList:Element(j);
										local MapPos = mapprop:WorldPosToMinimapPos(WorldPos, minimapw, minimaph);
										local XC, YC, RangeX, RangeY = GET_MINIMAP_POS_BY_SESSIONOBJ(MapPos, range, mapprop, minimapw, minimaph);
										MAKE_LOC_CLICK_ICON(npcList, i, stateidx, 'minimapgroup'..roundCount, XC, YC, RangeX, RangeY, 30);

										XC, YC = GET_MINI_ICON_POS_BY_MAPPOS(MapPos.x, MapPos.y, iconW, iconH);
										MAKE_LOC_ICON(npcList, cls, i, stateidx, 'minimapgroup'..roundCount, XC, YC, iconW, iconH, WorldPos, statelist, questIESlist);
										roundCount = roundCount+1;
									end

									genName = "None";
									genType = 0;
									count = 5;
								end
							elseif count == 3 then
								z = tonumber(locationMapName);
							elseif count == 4 then
								range = tonumber(locationMapName);

								local MapPos = mapprop:WorldPosToMinimapPos(x, z,minimapw, minimaph);
								local XC, YC, RangeX, RangeY = GET_MINIMAP_POS_BY_SESSIONOBJ(MapPos, range, mapprop, minimapw, minimaph);
								MAKE_LOC_CLICK_ICON(npcList, i, stateidx, 'minimapgroup'..roundCount, XC, YC, RangeX, RangeY, 30);

								XC, YC = GET_MINI_ICON_POS_BY_MAPPOS(MapPos.x, MapPos.y, iconW, iconH);
								MAKE_LOC_ICON(npcList, cls, i, stateidx, 'minimapgroup'..roundCount, XC, YC, iconW, iconH, nil, statelist, questIESlist);
								roundCount = roundCount + 1;
							end

							if count < 4 then
								count = count + 1;
							else
								count = 0;
							end
						end
					end
				end
			end
		end
	end

	RUN_FUNC_BY_USRVALUE(npcList, "EXTERN_PIC", "YES", _MONPIC_AUTOUPDATE);
	MAKE_TOP_QUEST_ICONS(npcList);
	frame:SetValue(1);

	M_MAP_UPDATE_PARTY(frame, nil, nil, 0);
	M_MAP_UPDATE_GUILD(frame, nil, nil, 0);
	MAKE_MY_CURSOR_TOP(frame);

	frame:Invalidate();
	
end

function GET_MINI_ICON_POS_BY_MAPPOS(x, y, iconW, iconH)

	local XC = x - iconW / 2;
	local YC = y - iconH / 2;
	return XC, YC;
	
end

function MAKE_LOC_CLICK_ICON(parent, i, stateidx, k, XC, YC, RangeX, RangeY, alpha)	
	local ctrlname = "_NPC_LOC_CIR" .. i..stateidx..k;
	local PictureC = parent:CreateOrGetControl('picture', ctrlname, XC, YC, RangeX, RangeY);
	tolua.cast(PictureC, "ui::CPicture");
	SET_PICTURE_QUESTMAP(PictureC, alpha);
end

function GET_MINIMAP_POS_BY_MAPPOS(MapPos, locinfo, mapprop, minimapw, minimaph)

	local cursize = GET_MINIMAPSIZE();
	local RangeX = locinfo.Range * MINIMAP_LOC_MULTI * minimapw / WORLD_SIZE;
	local RangeY = locinfo.Range * MINIMAP_LOC_MULTI * minimaph / WORLD_SIZE;
	local XC = MapPos.x - RangeX / 2;
	local YC = MapPos.y - RangeY / 2;

	return XC, YC, RangeX, RangeY;
end

function GET_MINIMAP_POS_BY_SESSIONOBJ(MapPos, range, mapprop, minimapw, minimaph)

	local cursize = GET_MINIMAPSIZE();
	local RangeX = range * MINIMAP_LOC_MULTI * minimapw / WORLD_SIZE;
	local RangeY = range* MINIMAP_LOC_MULTI * minimaph / WORLD_SIZE;
	local XC = MapPos.x - RangeX / 2;
	local YC = MapPos.y - RangeY / 2;

	return XC, YC, RangeX, RangeY;

end

function MAKE_LOC_ICON(parent, cls, i, stateidx, k, XC, YC, iconW, iconH, worldPos, statelist, questIESlist, MapPos)

	local IconName, state = GET_NPC_ICON(i, statelist, questIESlist);
	local level = cls.Level;
	local name = cls.Name;
	local classID = cls.ClassID;
	local MonsterConditionTxt = GET_QUEST_INFO_TXT(cls);
	MAKE_LOC_ICON_BY_ICON_NAME(parent, i, stateidx, k, XC, YC, iconW, iconH, IconName, state, level, name, classID, MonsterConditionTxt, worldPos, MapPos);

end

function MAKE_LOC_ICON_BY_ICON_NAME(parent, i, stateidx, k, XC, YC, iconW, iconH, IconName, state, level, name, classID, text, worldPos, MapPos)

	local mylevel = info.GetLevel(session.GetMyHandle());

	local ctrlname = "_NPC_LOC_MARK" .. i..stateidx..k;
	local PictureC = parent:CreateOrGetControl('picture', ctrlname, XC, YC, iconW, iconH);
	tolua.cast(PictureC, "ui::CPicture");
	SET_PICTURE_BUTTON(PictureC);

	SET_NPC_STATE_ICON(PictureC, IconName, state, classID, worldPos);

	-- ?�라 ?�운?�는 ?�상???�어???�전 방식?�로 롤백?�니??
	-- ?�인 : UPDATE_MINIMAP_TOOLTIP()??보면 'minimap' ?�팁?�의 UserData??MonProp?�어???�나 ?�기?�는 MapPos�??�용 �?

	--[[
	PictureC:ShowWindow(1);
	PictureC:SetTooltipType('minimap');
	local color = GET_LEVEL_COLOR(mylevel, level);
	PictureC:SetTooltipArg(state..'/'..classID, classID, "", MapPos);
	PictureC:SetEventScript(ui.LBUTTONUP, "SHOW_QUEST_BY_ID");
	PictureC:SetEventScriptArgNumber(ui.LBUTTONUP, classID);
	]]


	PictureC:ShowWindow(1);
	PictureC:SetTooltipType('texthelp');
	local color = GET_LEVEL_COLOR(mylevel, level);
	local tooltipText = color .. name .. "{/}" .. text;
	PictureC:SetTooltipArg(tooltipText);
	PictureC:SetEventScript(ui.LBUTTONUP, "SHOW_QUEST_BY_ID");
	PictureC:SetEventScriptArgNumber(ui.LBUTTONUP, classID);


end

function MINIMAP_CHAR_UDT(frame, msg, argStr, argNum)

	local objHandle = session.GetMyHandle();
	local mapprop = session.GetCurrentMapProp();

	local pictureui = GET_CHILD(frame, "map", "ui::CPicture");	
	local cursize = GET_MINIMAPSIZE();

	local minimapw = pictureui:GetImageWidth() * (100 + cursize) / 100;
	local minimaph = pictureui:GetImageHeight() * (100 + cursize) / 100;
	local pos = info.GetPositionInMap(objHandle, minimapw, minimaph);

	local miniX = pos.x;
	local miniY = pos.y;
	local bx = frame:GetUserIValue("MBEFORE_X");
	local by = frame:GetUserIValue("MBEFORE_Y");
	if miniX == bx and miniY == by then
		return;
	end

	frame:SetUserValue("MBEFORE_X", miniX);
	frame:SetUserValue("MBEFORE_Y", miniY);

	miniX = miniX - mini_pos:GetOffsetX() - mini_pos:GetImageWidth() / 2;
	miniY = miniY - mini_pos:GetOffsetY() - mini_pos:GetImageHeight() / 2;
	miniX = math.floor(miniX);
	miniY = math.floor(miniY);
	
	pictureui:SetOffset(-miniX, - miniY);
	local map_bg = GET_CHILD(frame, "map_bg", "ui::CPicture");
	map_bg:SetOffset(-miniX, - miniY);

	local npcList = frame:GetChild('npclist')
	npcList:SetOffset(-miniX, - miniY);

	UPDATE_QUEST_INDICATOR(frame);
	
end

function UPDATE_QUEST_INDICATOR(frame)

	local myPcX = mini_pos:GetGlobalX() - mini_frame_g_x - mini_frame_hw;
	local myPcY = mini_pos:GetGlobalY() - mini_frame_g_y - mini_frame_hh;

	local npcList = frame:GetChild('npclist')
	local cnt = npcList:GetChildCount();
	for i = 0, cnt - 1 do
		local ctrl = npcList:GetChildByIndex(i);
		local x, y = GET_POS_FROM_CENTER(ctrl);

	end
	for i = 0 , cnt - 1 do
		local ctrl = npcList:GetChildByIndex(i);
		local state = ctrl:GetSValue();
		local questID = ctrl:GetValue();
		if state ~= "" and ctrl:GetValue() > 0 then
			UPDATE_CTRL_INDICATOR(frame, ctrl);
		end
	end
	
end

function GET_POS_FROM_CENTER(ctrl)

	local x = ctrl:GetGlobalX() - mini_frame_g_x - mini_frame_hw;
	local y = ctrl:GetGlobalY() - mini_frame_g_y - mini_frame_hh;
	return x, y;
	
end

indic_size = 24;

function GET_INDICATOR_POS(x, y)

	local len = GET_LEN(x, y);
	x = x / len * 0.8;
	y = y / len * 0.8;
	return (x + 1) * mini_frame_hw - indic_size / 2, (y + 1) * mini_frame_hh - indic_size / 2;

end

function CREATE_INDIC(frame, ctrl, ix, iy)

	local clsID = ctrl:GetValue();

	local childName = "_INDIC_" .. ctrl:GetName();
	local indic = frame:GetChild(childName);
	if indic == nil then
		indic = frame:CreateOrGetControl('picture', childName, ix, iy, indic_size, indic_size);
		tolua.cast(indic, "ui::CPicture");

		local cls = GetClassByType("QuestProgressCheck", ctrl:GetValue());
		local questTab = cls.QuestMode;
		local state = ctrl:GetSValue();

		indic:SetImage(GET_ICON_BY_STATE_MODE(state, cls));
		indic:EnableHitTest(1);
		indic:SetEnableStretch(1);

		SET_MINI_QUEST_TOOLTIP(indic, clsID);
	else
		indic:SetOffset(ix, iy);
		tolua.cast(indic, "ui::CPicture");
	end

	return indic;
	
end

function SET_MINI_QUEST_TOOLTIP(ctrl, clsID)

	ctrl:SetTooltipType('minimapquest');
	ctrl:SetTooltipNumArg(clsID);

end

function GET_POS_FROM_CENTER_TEST(ctrl)			
	local x = ctrl:GetGlobalX() - mini_frame_g_x - mini_frame_hw;
	local y = ctrl:GetGlobalY() - mini_frame_g_y - mini_frame_hh;
	return x, y;
	
end

function UPDATE_CTRL_INDICATOR(frame, ctrl)

	
	local x, y = GET_POS_FROM_CENTER(ctrl);

	local is_in_ellipse = math.pow( (x / mini_frame_hw) , 2)
				+ math.pow( (y / mini_frame_hh) , 2);

	local ix, iy = GET_INDICATOR_POS(x, y);
	local indic = CREATE_INDIC(frame, ctrl, ix, iy);

	if is_in_ellipse < 1.1 then
		indic:ShowWindow(0);
		return;
	end

	indic:ShowWindow(1);
	local angle = DirToAngle(x, y) - 90;
	tolua.cast(indic, "ui::CPicture");
	indic:SetAngle(angle);

	
end

function UPDATE_CTRL_INDICATOR_SORT_POS(x, y)

	local devX = 0;
	local devY = 0;
	if x < -mini_frame_hw and x < 0 then
		devX = -x - mini_frame_hw;
	elseif x > mini_frame_hw and x > 0 then
		devX = -(x - mini_frame_hw);
	end
	
	if y < mini_frame_hh and y < 0 then
		devY = -y - mini_frame_hh;
	elseif y > mini_frame_hh and y > 0 then
		devY = -(y - mini_frame_hh);
	end
	
	return devX, devY;
	
end

function M_UPT_ANGLE(frame, msg, argStr, argNum)	

	local objHandle = argNum;
	local mapprop = session.GetCurrentMapProp();
	local angle = info.GetAngle(objHandle) - mapprop.RotateAngle;
	mini_pos:SetAngle(angle);

end

minimapNameOpen = 0;

function M_MAP_UPDATE_PARTY_INST(frame, msg, a, b, c)

	local npcList = frame:GetChild('npclist')
	tolua.cast(npcList, 'ui::CGroupBox');
	MAP_UPDATE_PARTY_INST(npcList, msg, a, b, c);
	
end

function M_MAP_UPDATE_PARTY(frame, msg, a, b, c)

	if a == 'RELATIONGRADE' then
		return;
	end
		
	local npcList = frame:GetChild('npclist')
	tolua.cast(npcList, 'ui::CGroupBox');
	MAP_UPDATE_PARTY(npcList, msg, a, b, c);
	
end

function M_MAP_UPDATE_GUILD(frame, msg, a, b, c)

	local npcList = frame:GetChild('npclist')
	tolua.cast(npcList, 'ui::CGroupBox');
	MAP_UPDATE_GUILD(npcList, msg, a, b, c);

end

function MINIMAP_COLONY_MONSTER(frame, msg, posStr, monID)
    local mappicturetemp = GET_CHILD(frame, 'npclist', 'ui::CPicture');  
    mappicturetemp:RemoveChild('colonyMonPic_'..monID);

    local mapFrame = ui.GetFrame('map');
    local COLONY_MON_IMG = GET_COLONY_MONSTER_IMG(mapFrame, monID);
    local MONSTER_SIZE = tonumber(mapFrame:GetUserConfig('COLONY_MON_SIZE'));
    local MONSTER_EFFECT_SIZE = tonumber(mapFrame:GetUserConfig('COLONY_MON_EFFECT_SIZE'));

    local x, z = GET_COLONY_MONSTER_POS(posStr);  
    local colonyMonPic = mappicturetemp:CreateControl('picture', 'colonyMonPic_'..monID, 0, 0, MONSTER_SIZE, MONSTER_SIZE);    
    colonyMonPic = AUTO_CAST(colonyMonPic);    
    colonyMonPic:SetImage(COLONY_MON_IMG);

    local zoneClassName = GetZoneName();
    local mapprop = geMapTable.GetMapProp(zoneClassName);    
    local MapPos = mapprop:WorldPosToMinimapPos(x, z, minimapw, minimaph);    
    local _x = MapPos.x - MONSTER_SIZE / 2;
	local _y = MapPos.y - MONSTER_SIZE / 2;

    colonyMonPic:SetOffset(_x, _y);
	colonyMonPic:SetEnableStretch(1);

    if IS_COLONY_MONSTER(monID) == true then
        frame:RemoveChild('colonyMonEffectPic');
        local colonyMonEffectPic = frame:CreateControl('picture', 'colonyMonEffectPic', 0, 0, MONSTER_EFFECT_SIZE, MONSTER_EFFECT_SIZE);
        colonyMonEffectPic = AUTO_CAST(colonyMonEffectPic);
        _x = MapPos.x - MONSTER_EFFECT_SIZE / 2;
	    _y = MapPos.y - MONSTER_EFFECT_SIZE / 2;
        colonyMonEffectPic:SetOffset(_x, _y);
        SET_PICTURE_QUESTMAP(colonyMonEffectPic);
    end
end