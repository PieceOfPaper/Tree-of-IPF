
function MAP_ON_INIT(addon, frame)
	map_offsetx = 0;
	map_offsety = 0;

	map_normalmode = 1;

	map_maxscale = 10;

	addon:RegisterOpenOnlyMsg('MAP_CHARACTER_ADD', 'MAP_ON_MSG');
	addon:RegisterMsg('MAP_CHARACTER_UPDATE', 'MAP_CHAR_UPDATE');
	addon:RegisterOpenOnlyMsg('MAP_CHARACTER_REMOVE', 'MAP_ON_MSG');
	addon:RegisterOpenOnlyMsg('ANGLE_UPDATE', 'UPT_ANGLE');

	addon:RegisterOpenOnlyMsg('WIDEAREA_ENTER', 'MAP_ON_MSG');
	addon:RegisterOpenOnlyMsg('WIDEAREA_LEAVE', 'MAP_ON_MSG');
	addon:RegisterOpenOnlyMsg('LOCALAREA_ENTER', 'MAP_ON_MSG');
	addon:RegisterOpenOnlyMsg('LOCALAREA_LEAVE', 'MAP_ON_MSG');

	addon:RegisterMsg('GAME_START', 'FIRST_UPDATE_MAP');
	addon:RegisterOpenOnlyMsg('QUEST_UPDATE', 'UPDATE_MAP');
	addon:RegisterOpenOnlyMsg('GET_NEW_QUEST', 'UPDATE_MAP');
	addon:RegisterMsg('REVEAL_ALL', 'UPDATE_MAP');

	-- addon:RegisterOpenOnlyMsg('PC_PROPERTY_UPDATE', 'UPDATE_MAP');
	addon:RegisterMsg('NPC_STATE_UPDATE', 'UPDATE_MAP_NPC_STATE');

	addon:RegisterOpenOnlyMsg('PARTY_INST_UPDATE', 'MAP_UPDATE_PARTY_INST');
	addon:RegisterOpenOnlyMsg('PARTY_UPDATE', 'MAP_UPDATE_PARTY');
	addon:RegisterOpenOnlyMsg('GUILD_INFO_UPDATE', 'MAP_UPDATE_GUILD');

	addon:RegisterMsg('MON_MINIMAP_START', 'MAP_MON_MINIMAP_START');
	addon:RegisterMsg('MON_MINIMAP', 'MAP_MON_MINIMAP');
	addon:RegisterMsg('MON_MINIMAP_END', 'ON_MON_MINIMAP_END');
			
	addon:RegisterMsg('CHANGE_CLIENT_SIZE', 'FIRST_UPDATE_MAP');
    addon:RegisterMsg('COLONY_MONSTER', 'MAP_COLONY_MONSTER');
    addon:RegisterMsg('OPEN_COLONY_POINT', 'UPDATE_MAP');

	frame = ui.GetFrame("map");
	INIT_MAPUI_INFO(frame);
	local mapClassName = session.GetMapName();
	local mapprop = geMapTable.GetMapProp(mapClassName);
	frame:SetTitleName('{ds}'.. mapprop:GetName());

	map_frame = frame;
	frame:EnableHideProcess(1);

	INIT_MAP_UI_COMMON(frame, mapClassName);

end

function MAP_OPEN(frame)
	local ratio = option.GetClientHeight()/option.GetClientWidth();
	local width = frame:GetWidth();
	local beforeWidth = width;
	frame:Resize(width,width*ratio);

	if ui.GetSceneHeight() / ui.GetSceneWidth() <= ui.GetClientInitialHeight() / ui.GetClientInitialWidth() then
		frame:Resize(ui.GetSceneWidth() * ui.GetClientInitialHeight() / ui.GetSceneHeight() ,ui.GetClientInitialHeight())
	end
	
	if beforeWidth ~= frame:GetWidth() then
		UPDATE_MAP(frame);
	end

end

-- 해상도 변경되면 실행시켜줘야됨.
function INIT_MAPUI_INFO(frame)
	
	local width = frame:GetWidth();
	local ratio = option.GetClientHeight()/option.GetClientWidth();
	frame:Resize(width,width*ratio);
	frame:SetAngle(0);

	myposition = frame:GetChild('my');
	tolua.cast(myposition, "ui::CPicture");

	INIT_MAPUI_PTR(frame);
	local mapClassName = session.GetMapName();
	MAKE_MAP_AREA_INFO(frame, mapClassName)
	
    
end

function INIT_MAPUI_PTR(frame)
	if frame:GetName() == "map" then
		map_picture = frame:GetChild('map');
		tolua.cast(map_picture, "ui::CPicture");

		frame:UpdateData();
		frame:Update();

		m_offsetX = map_picture:GetX();
		m_offsetY = map_picture:GetY();
		m_mapWidth = map_picture:GetWidth();
		m_mapHeight = map_picture:GetHeight();

		MAP_CHAR_UPDATE(frame, msg, argStr, session.GetMyHandle());
	end

end

function MAP_CLOSE(frame)
end

function MAKE_MAP_AREA_INFO(frame, mapClassName, font, mapWidth, mapHeight, offsetX, offsetY)

	INIT_MAPUI_PTR(frame);
	DESTROY_CHILD_BYNAME(frame, 'MAP_AREA_');

	local clsList, cnt = GetClassList("Map_Area");
	for i = 0, cnt -1 do
		local cls = GetClassByIndexFromList(clsList, i);
		if cls ~= nil and mapClassName == cls.ZoneClassName then

			local centerX, centerY, centerZ, posCnt = 0, 0, 0, 0;
			
			for j = 1, 5 do				
				if cls['Pos'..j..'_X'] == 0 and cls['Pos'..j..'_Y'] == 0 and cls['Pos'..j..'_Z'] == 0 then
					break;
				end
				
				centerX = centerX + cls['Pos'..j..'_X'];
				centerY = centerY + cls['Pos'..j..'_Y'];
				centerZ = centerZ + cls['Pos'..j..'_Z'];
				posCnt = posCnt + 1;
			end

			if posCnt == 0 then
				return;
			end
			
			centerX = centerX / posCnt;
			centerY = centerY / posCnt;
			centerZ = centerZ / posCnt;
			
			if mapWidth == nil then
				mapWidth = m_mapWidth;
			end
			if mapHeight == nil then
				mapHeight = m_mapHeight;
			end	

			if offsetX == nil then
				offsetX = m_offsetX - 100;
			end
			if offsetY == nil then
				offsetY = m_offsetY - 30;
			end

			local mapPos = info.GetPositionInMap(centerX, centerY, centerZ, mapWidth, mapHeight);

			mapPos.x = mapPos.x + offsetX;
			mapPos.y = mapPos.y + offsetY;
			
			local areaNameCtrlSet = frame:CreateOrGetControlSet('mapAreaName', 'MAP_AREA_'.. cls.ClassName, mapPos.x, mapPos.y);
			local nameRechText = GET_CHILD(areaNameCtrlSet, "areaname", "ui::CRichText");
			if font == nil then
				nameRechText:SetText(cls.Name);
			else
				nameRechText:SetText(font .. cls.Name);
			end
		end
	end
end

function CUSTOM_MAP_INIT(frame, MapName)

	DESTORY_MAP_PIC(frame);

	local mapprop = geMapTable.GetMapProp(MapName);
	local KorName = GetClassString('Map', MapName, 'Name');
	frame:SetTitleName('{ds}'..KorName);

	local myctrl = frame:GetChild('my');
	tolua.cast(myctrl, "ui::CPicture");
	myctrl:ShowWindow(0);

	INIT_MAP_UI_COMMON(frame, MapName);

	local mapname = mapprop:GetClassName();
	UPDATE_MAP_BY_NAME(frame, mapname, GET_CHILD(frame, "map"));

	ui.SetTopMostFrame(frame);
    
end

function INIT_MAP_UI_COMMON(frame, mapName)

	local pictureui  =	frame:GetChild('map');
	local mappicture = tolua.cast(pictureui, 'ui::CPicture');
	mappicture:SetImage(mapName .. "_fog");

	INIT_MAP_PICTURE_UI(mappicture, mapName, 1);
	if 0 == MAP_USE_FOG(mapName) then
		local rate = GET_CHILD(frame, "rate", "ui::CRichText");
		rate:ShowWindow(0);
	end

	local mapCls = GetClass("Map", mapName);
	local title = GET_CHILD(frame, "title", "ui::CRichText");
	title:SetTextByKey("mapname", mapCls.Name);
    
    local questlv = mapCls.QuestLevel
    local maptype = mapCls.MapType
    if questlv > 0 and (maptype == 'Field' or maptype == 'Dungeon') then
        frame:GetChild("map"):GetChild("monlv"):SetVisible(1)
        frame:GetChild("map"):GetChild("monlv"):SetTextByKey("text",tostring(questlv))
    else
        frame:GetChild("map"):GetChild("monlv"):SetVisible(0)
    end
	local mapRankObj = GET_CHILD_RECURSIVELY(frame,"mapRank")

	mapRankObj:SetText(GET_STAR_TXT(20,mapCls.MapRank))
end



function MAP_LBTN_DOWN(parent, ctrl)

	if keyboard.IsPressed(KEY_CTRL) ~= 1 then
		return;
	end

	local x, y = GET_LOCAL_MOUSE_POS(ctrl);
	local mapName = ctrl:GetUserValue("MAP_NAME");
	local mapprop = geMapTable.GetMapProp(mapName);
	local worldPos = mapprop:MinimapPosToWorldPos(x, y, ctrl:GetWidth(), ctrl:GetHeight());
	LINK_MAP_POS(mapName, worldPos.x ,worldPos.y);
			
end

function CHECK_MAP_ICON(frame, object, argStr, argNum)
	frame = frame:GetTopParentFrame();

	local myctrl = frame:GetChild('check');
	tolua.cast(myctrl, "ui::CPicture");
	myctrl:SetImage("questmap");
	myctrl:SetAlpha(30);

	local pNpcIcon = frame:GetChild(object:GetName() .. "_0");
	if pNpcIcon == nil then
		myctrl:ShowWindow(0);
		return;
	end

	tolua.cast(pNpcIcon, "ui::CPicture");

	local x = pNpcIcon:GetOffsetX() + pNpcIcon:GetImageWidth() / 2 - myctrl:GetWidth() / 2;
	local y = pNpcIcon:GetOffsetY() +  pNpcIcon:GetImageHeight() / 2 - myctrl:GetWidth() / 2;
	myctrl:SetOffset(x, y);
	myctrl:ShowWindow(1);

end

function UI_TOGGLE_MAP()
	if app.IsBarrackMode() == true then
		return;
	end

	if session.DontUseMinimap() == true then
		return;
	end

	local curmapname = session.GetMapName();
	if ui.IsImageExist(curmapname) == 0 then
		return;
	end

	ui.ToggleFrame('map');

end


function GET_QUEST_IDX(questmoncls, questlist)

	local type = questmoncls.QuestType;
	local cnt = #questlist;
	for i = 1 , cnt do
		local cls = questlist[i];
		if type == cls.ClassID then
			return i;
		end
	end
	return -1
end






function SHOW_QUEST_NPC(mapname, npcname)

	local mapprop = geMapTable.GetMapProp(mapname);
	local monnpcprop = mapprop:GetNPCPropByDialog(npcname);
	local coorlist = monnpcprop.GenList;
	if coorlist:Count() == 0 then
		return;
	end

	local frame = ui.CreateNewFrame('map', 'Map_Custom');
	frame:ShowWindow(1);
	frame:EnableHide(1);
	frame:EnableCloseButton(1);
	frame:SetLayerLevel(91);
	local monlv = GET_CHILD_RECURSIVELY(frame,"monlv")
	if monlv ~= nil then
		monlv:ShowWindow(0);
	end

	CUSTOM_MAP_INIT(frame, mapname);

	local closeBtn = frame:GetChild('colse');
	closeBtn:SetEventScript(ui.LBUTTONUP, 'ui.CloseFrame("Map_Custom")', true);

	local pNpcIcon = frame:GetChild("_NPC_"..  monnpcprop:GetType() .. "_0");
	if pNpcIcon == nil then
		return;
	end

	tolua.cast(pNpcIcon, "ui::CPicture");

	local myctrl = frame:GetChild('check');
	tolua.cast(myctrl, "ui::CPicture");
	myctrl:SetImage("minimap_check");

	local x = pNpcIcon:GetOffsetX() + pNpcIcon:GetImageWidth() / 2 - myctrl:GetImageWidth() / 2;
	local y = pNpcIcon:GetOffsetY() +  pNpcIcon:GetImageHeight() / 2 - myctrl:GetImageHeight() / 2;
	myctrl:SetOffset(x, y);
	myctrl:ShowWindow(1);

end

function DESTORY_MAP_PIC(mapframe)

	DESTROY_CHILD_BYNAME(mapframe, "_NPC_");
	--[[local count = mapframe:GetChildCount();
	for  i = 0, count-1 do
		local child = mapframe:GetChildByIndex(i);
		if  string.find(child:GetName(), "_NPC_")  ~=  nil  then
			child:ShowWindow(0);
		 end
	 end
	 ]]

end

function FIRST_UPDATE_MAP(frame, msg)
	
	if msg == 'CHANGE_CLIENT_SIZE' then
		INIT_MAPUI_INFO(frame);
	end

	UPDATE_MAP(frame);

	local nameframe = ui.GetFrame("mapname");
	nameframe:SetOpenDuration(2);
	nameframe:SetDuration(0.1);
end

function UPDATE_MAP(frame)

	local curmapname = session.GetMapName()
	UPDATE_MAP_BY_NAME(frame, curmapname, GET_CHILD(frame, "map"));
	RUN_REVEAL_CHECKER(frame, curmapname);

end

function MAKE_MAP_NPC_ICONS(frame, mapname, mapWidth, mapHeight, offsetX, offsetY)
	local mapprop = geMapTable.GetMapProp(mapname);
	if mapprop.mongens == nil then
		return;
	end

	local npclist = {};
	local statelist = {};
	local questIESlist  = {};
	local questPropList = {};

	GET_QUEST_NPC_NAMES(mapname, npclist, statelist, questIESlist, questPropList);
	MAP_MAKE_NPC_LIST(frame, mapprop, npclist, statelist, questIESlist, questPropList, mapWidth, mapHeight, offsetX, offsetY);
	MAKE_TOP_QUEST_ICONS(frame);
	MAKE_MY_CURSOR_TOP(frame);
end

function UPDATE_MAP_BY_NAME(frame, mapname, pic, mapWidth, mapHeight, offsetX, offsetY)
	INIT_MAPUI_PTR(frame);

	MAKE_MAP_FOG_PICTURE(mapname, pic, true)
	UPDATE_MAP_FOG_RATE(frame, mapname);
	MAKE_MAP_NPC_ICONS(frame, mapname, mapWidth, mapHeight, offsetX, offsetY)
end

function UPDATE_NPC_STATE_COMMON(frame)
	local mapprop = session.GetCurrentMapProp();
	local mapNpcState = session.GetMapNPCState(mapprop:GetClassName());
	local mongens = mapprop.mongens;
	local cnt = mongens:Count();
	
	local typeCount = {};
	-- MONGEN을 통한 퀘스트 정보 출력
	for i = 0 , cnt - 1 do
	local MonProp = mongens:Element(i);
		if MonProp.Minimap >= 1 then
			local GenList = MonProp.GenList;
			local GenCnt = GenList:Count();
			for j = 0 , GenCnt - 1 do
				local type = MonProp:GetType();
				local idx = 0;
				if typeCount[type] == nil then
					typeCount[type] = 1;
				else
					idx = typeCount[type];
					typeCount[type] = typeCount[type] + 1;
				end

				local ctrlname = GET_GENNPC_NAME(frame, MonProp);
				local picture = GET_CHILD(frame, ctrlname, "ui::CPicture");

				if picture ~= nil then
					SET_MONGEN_NPC_VISIBLE(picture, mapprop, mapNpcState, MonProp);
				end
			end
		end
	end
end

function UPDATE_MAP_NPC_STATE(frame)
	UPDATE_NPC_STATE_COMMON(frame);	
end

function SET_PICTURE_QUESTMAP(PictureC, alpha)

	PictureC:SetEnable(1);
	PictureC:SetEnableStretch(1);
	PictureC:SetAlpha(60);
	PictureC:SetImage("questmap");
	PictureC:ShowWindow(1);
	PictureC:SetAngleLoop(-3);
	
end

function SET_MAP_CTRLSET_TXT(qstctrl, CurState, Icon, iconW, iconH, mylevel, questIES)

	SET_MAP_CTRLSET_TXT_BY_NAME(qstctrl, CurState, Icon, iconW, iconH, mylevel, questIES.Name, questIES.Level);

end

function SET_MAP_CTRLSET_TXT_BY_NAME(qstctrl, CurState, Icon, iconW, iconH, mylevel, name, level)

	local srtext = GET_QUEST_STATE_TXT(CurState);
	local txt = string.format("{img %s %d %d}{/}{@st45tw}%s{/}", Icon, iconW, iconH, name);
	tolua.cast(qstctrl, "ui::CControlSet");

	qstctrl:SetLBtnUpScp("CHECK_MAP_ICON");
	qstctrl:SetImage("all_trans", "all_red", "all_red");
	qstctrl:SetStretch(1);
	qstctrl:EnableHitTest(1);
	qstctrl:SetSelectGroupName('MM_Q')
	qstctrl:EnableToggle(1);
	qstctrl:SetTextByKey("text", txt);

end

	

function SET_RIGHT_QUESTLIST(groupCtrl, idx, MonProp, list_y, statelist, questIESlist, Icon, iconW, iconH, mylevel)

	local CurState = statelist[idx];
	if IS_STATE_PRINT(CurState) == 1 then
		local ctrlname = "_NPC_GEN_" .. MonProp:GetType();
		if groupCtrl:GetChild(ctrlname) == nil then
			local qstctrl		= groupCtrl:CreateControlSet('richtxt', ctrlname, 10, list_y);
			list_y = list_y + 20;
			local questIES = questIESlist[idx];
			if questIES ~= nil then
				SET_MAP_CTRLSET_TXT(qstctrl, CurState, Icon, iconW, iconH, mylevel, questIES);
			end
		end
	end

	return list_y;
end

function MAP_MAKE_NPC_LIST(frame, mapprop, npclist, statelist, questIESlist, questPropList, mapWidth, mapHeight, offsetX, offsetY)

	local mylevel = info.GetLevel(session.GetMyHandle());
	DESTORY_MAP_PIC(frame);

	local list_y = 10 + 18;
	local mapNpcState = session.GetMapNPCState(mapprop:GetClassName());
	local mongens = mapprop.mongens;
	local cnt = mongens:Count();
	local WorldPos;
	local minimapPos;
	
	if mapWidth == nil then
		mapWidth = m_mapWidth;
	end
	if mapHeight == nil then
		mapHeight = m_mapHeight;
	end
	if offsetX == nil then
		offsetX = m_offsetX;
	end
	if offsetY == nil then
		offsetY = m_offsetY;
	end

	-- MONGEN을 통한 퀘스트 정보 출력
    local isColonyMap = session.colonywar.GetIsColonyWarMap();
	for i = 0 , cnt - 1 do
		local MonProp = mongens:Element(i);
		
		if MonProp.Minimap >= 1 then
			local GenList = MonProp.GenList;
			local GenCnt = GenList:Count();
			for j = 0 , GenCnt - 1 do
				WorldPos = GenList:Element(j);
				local MapPos = mapprop:WorldPosToMinimapPos(WorldPos.x, WorldPos.z, mapWidth, mapHeight);
				local XC = offsetX + MapPos.x - iconW / 2;
				local YC = offsetY + MapPos.y - iconH / 2;

				local ctrlname = GET_GENNPC_NAME(frame, MonProp);
				local PictureC = frame:CreateOrGetControl('picture', ctrlname, XC, YC, iconW, iconH);                
				tolua.cast(PictureC, "ui::CPicture");
				local idx, Icon = SET_MAP_MONGEN_NPC_INFO(PictureC, mapprop, WorldPos, MonProp, mapNpcState, npclist, statelist, questIESlist);
                if isColonyMap == true and MonProp:GetClassName() == 'Warp_arrow' then
                    PictureC:ShowWindow(1);
                end
			end
		end
	end

	-- questprogress의 Location 정보
	local quemon = mapprop.questmonster;
	if quemon ~= nil then

		local quemoncnt = quemon:Count();

		local WorldPos = nil;
		for i = 0 , quemoncnt - 1 do
			local quemoninfo = quemon:Element(i);
			local idx = GET_QUEST_IDX(quemoninfo, questIESlist);

			if idx ~= -1 and statelist[idx] == 'PROGRESS'then
				local cls = questIESlist[idx];
				WorldPos = quemoninfo.Pos;
				local MapPos = mapprop:WorldPosToMinimapPos(WorldPos, m_mapWidth, m_mapHeight);


				local Range = quemoninfo.GenRange * MINIMAP_LOC_MULTI * m_mapWidth / WORLD_SIZE;
				local XC = m_offsetX + MapPos.x - Range / 2;
				local YC = m_offsetY + MapPos.y - Range / 2;
				local ctrlname = "_NPC_MON_MARK" .. quemoninfo.QuestType.. "_" .. i .. "_" ..quemoninfo.MonsterType;
				local PictureC = frame:CreateOrGetControl('picture', ctrlname, XC, YC, Range, Range);
				tolua.cast(PictureC, "ui::CPicture");
				SET_PICTURE_QUESTMAP(PictureC, 0);

				XC = m_offsetX + MapPos.x - iconW / 2;
				YC = m_offsetY + MapPos.y - iconH / 2;

				ctrlname = "_NPC_MON_" .. quemoninfo.QuestType.. "_" .. i .. "_" .. quemoninfo.MonsterType;
				PictureC = frame:CreateOrGetControl('picture', ctrlname, XC, YC, iconW, iconH);
				tolua.cast(PictureC, "ui::CPicture");
				SET_PICTURE_BUTTON(PictureC);

				SET_MINIMAP_NPC_ICON(PictureC, WorldPos, idx, statelist, questIESlist);

				local CurState = statelist[idx];
				ctrlname = "_NPC_MAP" .. idx;
				if GroupCtrl:GetChild(ctrlname) == nil then
					local qstctrl		= GroupCtrl:CreateControlSet('richtxt', ctrlname, 10, list_y);
					list_y = list_y + 20;
					local questIES = questIESlist[idx];
					if questIES ~= nil then
						SET_MAP_CTRLSET_TXT(qstctrl, CurState, Icon, iconW, iconH, mylevel, questIES)
					end

				end


			end
		end
	end

	-- Location을 통한 퀘스트 정보 출력
	local allmaptxt = "";

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
										local MapPos = mapprop:WorldPosToMinimapPos(WorldPos, m_mapWidth, m_mapHeight);
										local XC, YC, RangeX, RangeY = GET_MAP_POS_BY_MAPPOS(MapPos, locinfo, mapprop, minimapw, minimaph);
										MAKE_LOC_CLICK_ICON(frame, i, stateidx, k, XC, YC, RangeX, RangeY, 30);
										XC = m_offsetX + MapPos.x - iconW / 2;
										YC = m_offsetY + MapPos.y - iconH / 2;

										MAKE_LOC_ICON(frame, cls, i, stateidx, k, XC, YC, iconW, iconH, WorldPos, statelist, questIESlist, MapPos);
									end
								end
							else
								allmaptxt = string.format("%s%s{nl}", allmaptxt, cls.Name);
							end
						else
							local MapPos = mapprop:WorldPosToMinimapPos(WorldPos, m_mapWidth, m_mapHeight);
							local XC, YC, RangeX, RangeY = GET_MAP_POS_BY_MAPPOS(MapPos, locinfo, mapprop, minimapw, minimaph);

							MAKE_LOC_CLICK_ICON(frame, i, stateidx, k, XC, YC, RangeX, RangeY, 30);

							XC = m_offsetX + MapPos.x - iconW / 2;
							YC = m_offsetY + MapPos.y - iconH / 2;
							MAKE_LOC_ICON(frame, cls, i, stateidx, k, XC, YC, iconW, iconH, WorldPos, statelist, questIESlist);

						end

					end
				end
			end
		end
	end

	-- QuestMapPointGroup을 통한 퀘스트 정보 출력
	local cnt = #questIESlist;
	for i = 1 , cnt do
		local cls = questIESlist[i];
		local stateidx = STATE_NUMBER(statelist[i]);

		local s_obj = GetClass("SessionObject", cls.Quest_SSN);
		if s_obj ~= nil then
			local sobjinfo = session.GetSessionObject(s_obj.ClassID);
			if sobjinfo ~= nil then
				local obj = GetIES(sobjinfo:GetIESObject());
				for k = 1, SESSION_MAX_MAP_POINT_GROUP do
					local mapPointGroupStr = obj["QuestMapPointGroup" .. k];
					local mapPointGroupView = obj["QuestMapPointView" .. k];
					if mapPointGroupStr ~= "None" and mapPointGroupView == 1 then
						local roundCount = 0;
						local count = 0;
						local genName = "None";
						local genType = 0;
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
										local MapPos = mapprop:WorldPosToMinimapPos(WorldPos, m_mapWidth, m_mapHeight);
										local XC, YC, RangeX, RangeY = GET_MAP_POS_BY_SESSIONOBJ(MapPos, range);

										MAKE_LOC_CLICK_ICON(frame, i, 'group'..roundCount, k, XC, YC, RangeX, RangeY, 30);
										XC = m_offsetX + MapPos.x - iconW / 2;
										YC = m_offsetY + MapPos.y - iconH / 2;
										MAKE_LOC_ICON(frame, cls, i, stateidx, 'group'..roundCount, XC, YC, iconW, iconH, WorldPos, statelist, questIESlist);

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
								local MapPos = mapprop:WorldPosToMinimapPos(x, z, m_mapWidth, m_mapHeight);

								local XC, YC, RangeX, RangeY = GET_MAP_POS_BY_SESSIONOBJ(MapPos, range);
								MAKE_LOC_CLICK_ICON(frame, i, stateidx, 'group'..roundCount, XC, YC, RangeX, RangeY, 30);

								XC = m_offsetX + MapPos.x - iconW / 2;
								YC = m_offsetY + MapPos.y - iconH / 2;
								MAKE_LOC_ICON(frame, cls, i, stateidx, 'group'..roundCount, XC, YC, iconW, iconH, nil, statelist, questIESlist);
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

	frame:Invalidate();
end

function GET_MONGEN_NPCPOS(mapprop, npcFuncName)
	local mongens = mapprop.mongens;
	if mongens == nil then
		return nil;
	end
	local cnt = mongens:Count();
	local WorldPos;
	local minimapPos;

	-- MONGEN을 통한 퀘스트 정보 출력
	for i = 0 , cnt - 1 do
		local MonProp = mongens:Element(i);

		if MonProp:IsHaveDialog(npcFuncName) == true then
			return MonProp.GenList;
		end
	end

	return nil;
end

function SET_MINIMAP_NPC_ICON(PictureC, WorldPos, idx, statelist, questIESlist)

	local Icon, state, questclsid, iconState = GET_NPC_ICON(idx, statelist, questIESlist);
	SET_NPC_STATE_ICON(PictureC, Icon, state, questclsid, WorldPos);
	PictureC:ShowWindow(1);
	PictureC:SetValue2(iconState);

	SET_MINIMAP_TOOLTIP(PictureC, questclsid);
	PictureC:SetLBtnUpScp("SHOW_QUEST_BY_ID");
	PictureC:SetLBtnUpArgNum(questclsid);

end

function SET_MINIMAP_TOOLTIP(ctrl, questclsid)

	ctrl:SetTooltipType('texthelp');
	local txt = GET_QUEST_TOOLTIP_TXT(questclsid);
	ctrl:SetTooltipArg(txt);

end

function GET_ICON_POS_BY_MAPPOS(x, y, iconW, iconH)
	local XC = m_offsetX + x - iconW / 2;
	local YC = m_offsetY + y - iconH / 2;
	return XC, YC;
end

function GET_MAP_POS_BY_MAPPOS(MapPos, locinfo)
	local RangeX = locinfo.Range * MINIMAP_LOC_MULTI * m_mapWidth / WORLD_SIZE;
	local RangeY = locinfo.Range * MINIMAP_LOC_MULTI * m_mapHeight / WORLD_SIZE;
	local XC = m_offsetX + MapPos.x - RangeX / 2;
	local YC = m_offsetY + MapPos.y - RangeY / 2;

	return XC, YC, RangeX, RangeY;
end

function GET_MAP_POS_BY_SESSIONOBJ(MapPos, range)
	local RangeX = range * MINIMAP_LOC_MULTI * m_mapWidth / WORLD_SIZE;
	local RangeY = range * MINIMAP_LOC_MULTI * m_mapHeight / WORLD_SIZE;
	local XC = m_offsetX + MapPos.x - RangeX / 2;
	local YC = m_offsetY + MapPos.y - RangeY / 2;

	return XC, YC, RangeX, RangeY;
end

function GET_QUEST_INFO_TXT(questcls)
	local txt = "";
	local pc = GetMyPCObject();
    local result = SCR_QUEST_CHECK_C(pc, questcls.ClassName)
    if result == 'PROGRESS' then
    	for i = 1 , QUEST_MAX_INVITEM_CHECK do
    		local InvItemName = questcls["Succ_InvItemName" .. i];
    		local itemclass = GetClass("Item", InvItemName);
    		if itemclass ~= nil then
        		local item = session.GetInvItemByName(InvItemName);
        		local itemcount = 0;
        		if item ~= nil then
        			itemcount = item.count;
        		end
        
        		local needcnt = questcls["Succ_InvItemCount" .. i];
        		if itemcount < needcnt then
        			local itemtxt = string.format("%s (%d/%d)", itemclass.Name, itemcount, needcnt);
        			txt = string.format("%s{nl}%s", txt, itemtxt);
        		end
        	end
    	end
    	
    	if questcls.Quest_SSN ~= 'None' then
    	    local pc = GetMyPCObject();
            local sObj_quest = GetSessionObject(pc, questcls.Quest_SSN)
            if sObj_quest ~= nil and sObj_quest.SSNInvItem ~= 'None' then
                local itemList = SCR_STRING_CUT(sObj_quest.SSNInvItem, ':')
                local maxCount = math.floor(#itemList/3)
                for i = 1, maxCount do
                    local InvItemName = itemList[i*3 - 2]
            		local itemclass = GetClass("Item", InvItemName);
            		if itemclass ~= nil then
            		    local item = session.GetInvItemByName(InvItemName);
                		local itemcount = 0;
                		if item ~= nil then
                			itemcount = item.count;
                		end
                
                		local needcnt = itemList[i*3 - 1]
                		if itemcount < needcnt then
                			local itemtxt = string.format("%s (%d/%d)", itemclass.Name, itemcount, needcnt);
                			txt = string.format("%s{nl}%s", txt, itemtxt);
                		end
                	end
                end
            end
        end
    end

	return txt;

end

function UPDATE_MINIMAP_TOOLTIP(tooltipframe, strarg, questclassID, numarg1, monprop)

	if monprop == nil then
		return;
	end

	local mongenprop = tolua.cast(monprop, "geMapTable::MAP_NPC_PROPERTY");

	if mongenprop == nil then
		return;
	end

	local monname = mongenprop:GetName();

	tooltipframe:ShowFrame(0);

	local txt = tooltipframe:GetChild("name");
	local tooltiptxt = '';

	local divCount = 0;
	local divTempStr = strarg;
	local divQuestState = "None";
	local divQuestClassID = 0;
	local divQuestInfo = '';
	while 1 do
		local divStart, divEnd = string.find(divTempStr, "/");

		if divStart == nil then
			break;
		end

		divQuestState = string.sub(divTempStr, 1, divStart-1);
		divQuestInfo = string.sub(divTempStr, divEnd +1, string.len(divTempStr));
		
		divStart, divEnd = string.find(divQuestInfo, "/");
		if divStart == nil then
			divQuestClassID = tonumber(divQuestInfo);			
			divTempStr = 'None';
		else
			divQuestClassID = tonumber(string.sub(divQuestInfo, 1, divStart-1));

			divTempStr = string.sub(divQuestInfo, divEnd+1, string.len(divQuestInfo));
		end

		local questcls = GetClassByType("QuestProgressCheck", divQuestClassID);
		if questcls == nil then
			txt:SetText("{s18}{ol}{ds}" .. monname .. "{/}{/}{/}");
		else
			local mylevel = info.GetLevel(session.GetMyHandle());
			local color = GET_LEVEL_COLOR(mylevel, questcls.Level)
			if divQuestState ~= 'COMPLETE' then
							
				-- 이거 왜 죄다 4255로 들어옴?? 일단 questclassID가 0인건 출력안되게 막음.
				if questclassID ~= 0 then
					local questIconImgName = GET_ICON_BY_STATE_MODE(divQuestState, questcls);
					local questInfoText = "{img ".. questIconImgName .." 20 20}"..color .. "{ol}{ds}{s16}" ..  questcls.Name .."{/}{/}{nl}";
					tooltiptxt = tooltiptxt..questInfoText;
				end
			end
		end
	end
    if monname ~= "UnvisibleName" then
    	txt:SetText("{ol}{ds}{s18}" .. monname .. "{/}{/}{/}{nl}"..tooltiptxt);
    else
        txt:SetText("")
    end
	txt:SetOffset(0, 5);
	tooltipframe:Resize(txt:GetWidth() + 20 , txt:GetHeight() + 10);

end



function MAP_CHAR_UPDATE(frame, msg, argStr, argNum)

	-- argNum 는 오브젝트 ID -> 오브젝트의 Relation, 위치와 방향 등 참조.
	local objHandle = argNum;
	--local pos = info.GetPositionInMap(objHandle, m_mapWidth, m_mapHeight);
	
	local actorPos = world.GetActorPos(objHandle);	
	local mapprop = session.GetCurrentMapProp();
	local pos = mapprop:WorldPosToMinimapPos(actorPos.x, actorPos.z, m_mapWidth, m_mapHeight);	
	myposition:SetOffset(pos.x + m_offsetX - myposition:GetImageWidth() / 2, pos.y + m_offsetY - myposition:GetImageHeight() / 2);

	

	local treasureMap = ui.GetFrame('Map_TreasureMark');
	if treasureMap ~= nil and treasureMap:IsVisible() == 1 then
		local myCtrl = treasureMap:GetChild('my');
		local mapprop = session.GetCurrentMapProp();
		local angle = info.GetAngle(objHandle) - mapprop.RotateAngle;
		myCtrl:SetAngle(angle);
		myCtrl:SetOffset(pos.x + m_offsetX - myposition:GetImageWidth() / 2, pos.y + m_offsetY - myposition:GetImageHeight() / 2);
		treasureMap:Invalidate();
	end

	frame:Invalidate();
end

function MAP_ON_MSG(frame, msg, argStr, argNum)

	if frame == nil then
		return;
	end

	if msg == 'WIDEAREA_ENTER' then

	  elseif msg == 'WIDEAREA_LEAVE' then

	  elseif msg == 'LOCALAREA_ENTER' then

	  elseif msg == 'LOCALAREA_LEAVE' then

	  elseif msg == 'MAP_CHARACTER_ADD' then

    elseif msg == 'MAP_CHARACTER_REMOVE' then
		-- argStr 오브젝트 네임 -> 이미지 아이템 삭제

	 end
     frame:Invalidate();
 end

function UPT_ANGLE(frame, msg, argStr, argNum)
	local objHandle = argNum;
	local mapprop = session.GetCurrentMapProp();
	local angle = info.GetAngle(objHandle) - mapprop.RotateAngle;
	myposition:SetAngle(angle);
	frame:Invalidate();
end

 function MAP_ON_CHECKBLEND(frame, obj, argStr, argNum)

	local alpha = argNum;
	frame:SetBlend(alpha);
  end

function SET_MAP_CIRCLE_MARK_UI(PictureC)

	tolua.cast(PictureC, "ui::CPicture");
	PictureC:SetEnable(0);
	PictureC:SetEnableStretch(1);
	PictureC:SetAlpha(30);
	PictureC:SetImage("questmap");
	PictureC:ShowWindow(1);
	PictureC:SetSValue("PROGRESS");
end


function CREATE_PM_PICTURE(frame, pcInfo, type, mapprop)

	local myInfo = session.party.GetMyPartyObj(type);
	if nil == myInfo then
		return;
	end
	if myInfo == pcInfo then
		return;
	end
	
	if myInfo:GetMapID() ~= pcInfo:GetMapID() or myInfo:GetChannel() ~= pcInfo:GetChannel() then
		return;
	end

	local header = "PM_";
	if type == PARTY_GUILD then
		header = "GM_";
	end

	local name = header .. pcInfo:GetAID();
	if pcInfo:GetMapID() == 0 then
		frame:RemoveChild(name);
		return;
	end

	if type == PARTY_GUILD then
		if frame:GetChild("PM_" .. pcInfo:GetAID()) ~= nil then
			return;
		end
	else
		if frame:GetChild("GM_" .. pcInfo:GetAID()) ~= nil then
			return;
		end
	end

	local instInfo = pcInfo:GetInst();
	local map_partymember_iconset = frame:CreateOrGetControlSet('map_partymember_iconset', name, 0, 0);
	map_partymember_iconset:SetTooltipType("partymap");
	map_partymember_iconset:SetTooltipArg(pcInfo:GetName(), type);

	local pm_name_rtext = GET_CHILD(map_partymember_iconset,"pm_name","ui::CRichText")
	pm_name_rtext:SetTextByKey("pm_fname",pcInfo:GetName())

	local iconinfo = pcInfo:GetIconInfo();
	SET_PM_MINIMAP_ICON(map_partymember_iconset, instInfo.hp, iconinfo.job);
	SET_PM_MAPPOS(frame, map_partymember_iconset, instInfo, mapprop);

end

function SET_PM_MINIMAP_ICON(map_partymember_iconset, pcHP, pcJobID)
	local jobCls = GetClassByType("Job", pcJobID);
	local pm_icon = GET_CHILD(map_partymember_iconset,"pm_icon","ui::CPicture")
	if pcHP > 0 then
		if nil ~= jobCls then
			pm_icon:SetImage(jobCls.CtrlType.."_party");
		else
			pm_icon:SetImage('die_party');
		end
	else
		pm_icon:SetImage('die_party');
	end
end
function SET_PM_MAPPOS(frame, controlset, instInfo, mapprop)
	local worldPos = instInfo:GetPos();
	SET_MINIMAP_CTRLSET_POS(frame, controlset, worldPos, mapprop);
end


function MAP_UPDATE_PARTY_INST(frame, msg, str, partyType)

	local mapprop = session.GetCurrentMapProp();
	local myInfo = session.party.GetMyPartyObj(partyType);

	local list = session.party.GetPartyMemberList(partyType);
	local count = list:Count();

	local header = "PM_";
	if partyType == PARTY_GUILD then
		header = "GM_";
	end

	for i = 0 , count - 1 do
		local pcInfo = list:Element(i);
		if myInfo ~= pcInfo then
			local instInfo = pcInfo:GetInst();
			local name = header .. pcInfo:GetAID();
			local pic = frame:GetChild(name);
			if pic ~= nil then
				local iconinfo = pcInfo:GetIconInfo();
				SET_PM_MINIMAP_ICON(pic, instInfo.hp, iconinfo.job);
				tolua.cast(pic, "ui::CControlSet");
				SET_PM_MAPPOS(frame, pic, instInfo, mapprop);
			else
				local mapFrame = ui.GetFrame('map');
				if partyType == PARTY_GUILD then
					MAP_UPDATE_GUILD(mapFrame, "GUILD_UPDATE", nil, 0);
				else
					MAP_UPDATE_PARTY(mapFrame, "PARTY_UPDATE", nil, 0);
				end
				return;							
			end
		end
	end

end

function _MINIMAP_ICON_REMOVE(parent, key)
	local ctrlName = "CUSTOM_ICON_" .. key;
	parent:RemoveChild(ctrlName);
end

function MINIMAP_ICON_REMOVE(key)

	local frame = ui.GetFrame("map");
	_MINIMAP_ICON_REMOVE(frame, key);
	
	frame = ui.GetFrame("minimap");
	local npcList = frame:GetChild('npclist');
	_MINIMAP_ICON_REMOVE(npcList, key);

end

function _MINIMAP_ICON_ADD(parent, key, info)
	local ctrlName = "CUSTOM_ICON_" .. key;

	local resize = parent:GetChild(ctrlName);
	local ctrlSet = parent:CreateOrGetControlSet('map_customicon', ctrlName, 0, 0);
	ctrlSet:SetUserValue("EXTERN", "YES");
	local text = GET_CHILD(ctrlSet, "name");
	text:SetTextByKey("value", info:GetName());

	local icon = GET_CHILD(ctrlSet, "icon");
	icon:SetImage(info:GetImage());
	
	if info:IsBlink() == true then
		icon:SetBlink(0.0, 1.0, "FFFF5555");
	end

	local worldPos = info:GetPos();
	local mapprop = session.GetCurrentMapProp();

	if resize == nil and info.scale ~= 1.0 then
		ctrlSet:Resize(ctrlSet:GetWidth() * info.scale, ctrlSet:GetHeight() * info.scale);
		icon:Resize(icon:GetWidth() * info.scale, icon:GetHeight() * info.scale);
		text:Resize(text:GetWidth() * info.scale, text:GetHeight() * info.scale);
		local textScale = math.pow(info.scale, 0.5);
		text:SetScale(textScale, textScale);
	end

	SET_MINIMAP_CTRLSET_POS(parent, ctrlSet, worldPos, mapprop);

end

function MINIMAP_ICON_ADD(key, info)
	info = tolua.cast(info, "session::minimap::MINIMAP_ICON_INFO");

	local frame = ui.GetFrame("map");
	_MINIMAP_ICON_ADD(frame, key, info);

	frame = ui.GetFrame("minimap");
	local npcList = frame:GetChild('npclist');
	_MINIMAP_ICON_ADD(npcList, key, info);
	
end

function MINIMAP_ICON_UPDATE(key, info)
	MINIMAP_ICON_ADD(key, info);
end

function SET_MINIMAP_CTRLSET_POS(parent, ctrlSet, worldPos, mapprop)

	if parent:GetValue2() == 1 then
		local cursize = GET_MINIMAPSIZE();
		local minimapw = m_mapWidth * (100 + cursize) / 100;
		local minimaph = m_mapHeight * (100 + cursize) / 100;
		local pos = mapprop:WorldPosToMinimapPos(worldPos, minimapw, minimaph);

		pos.x = pos.x - ctrlSet:GetWidth() / 2;
		pos.y = pos.y - ctrlSet:GetHeight() / 2 + 10;
		ctrlSet:SetOffset(pos.x, pos.y);
		return;
	end

	local cursize = GET_MINIMAPSIZE();
	local minimapw = m_mapWidth;
	local minimaph = m_mapHeight;
	local pos = mapprop:WorldPosToMinimapPos(worldPos, minimapw, minimaph);

	local x = m_offsetX + pos.x - ctrlSet:GetWidth() / 2;
	local y = m_offsetY + pos.y - ctrlSet:GetHeight() / 2 + 10;
	ctrlSet:SetOffset(x, y);

end

function SCR_SHOW_LOCAL_MAP(zoneClassName, useMapFog, showX, showZ)
	local newframe = ui.CreateNewFrame('map', 'Map_TreasureMark');
	newframe:ShowWindow(1);
	newframe:EnableHide(1);
	newframe:EnableCloseButton(1);
	newframe:SetLayerLevel(100);
	
	local originCloseBtn = GET_CHILD(newframe, "close_map");
	originCloseBtn:ShowWindow(0);

	DESTORY_MAP_PIC(newframe);
	local mapprop = geMapTable.GetMapProp(zoneClassName);
	local KorName = GetClassString('Map', zoneClassName, 'Name');

	local title = GET_CHILD(newframe, "title", "ui::CRichText");
	title:SetText('{@st46}'..KorName);

	local rate = newframe:GetChild('rate');
	rate:ShowWindow(0);
	local mapPicture = newframe:GetChild("map");
	local monlv = mapPicture:GetChild("monlv");
	MAKE_MAP_NPC_ICONS(newframe, zoneClassName);
	if monlv ~= nil then
		monlv:ShowWindow(0);
	end

	local myctrl = newframe:GetChild('my');
	myctrl:ShowWindow(0);

	world.PreloadMinimap(zoneClassName, false, false);
	local mappicturetemp = GET_CHILD(newframe,'map','ui::CPicture')	
	if useMapFog == true then
		mappicturetemp:SetImage(zoneClassName .. "_fog");
	else
		mappicturetemp:SetImage(zoneClassName);
	end

	local treasureMarkPic = newframe:CreateOrGetControl('picture', 'treasuremark', 0, 0, 64, 64);
	tolua.cast(treasureMarkPic, "ui::CPicture");
	treasureMarkPic:SetImage('trasuremapmark');
	local MapPos = mapprop:WorldPosToMinimapPos(showX, showZ, 1024, 1024);
	treasureMarkPic:SetEnableStretch(1);
	
	local offsetX = mappicturetemp:GetX();
	local offsetY = mappicturetemp:GetY();
	
	local x = offsetX + MapPos.x - treasureMarkPic:GetWidth() / 2;
	local y = offsetY + MapPos.y - treasureMarkPic:GetHeight() / 2;

	treasureMarkPic:SetOffset(x, y);

	treasureMarkPic:SetBlink(0.0, 1.0, "FFFF5555");
		
end

function GET_COLONY_MONSTER_POS(posStr)
    local list = StringSplit(posStr, '#');
    return list[1], list[2];
end

function GET_COLONY_MONSTER_IMG(frame, monID)
    if IS_COLONY_MONSTER(monID) == true then
        return frame:GetUserConfig('COLONY_MON_IMG');
    end
    return frame:GetUserConfig('COLONY_TOWER_IMG');
end

function MAP_COLONY_MONSTER(frame, msg, posStr, monID)        
    frame:RemoveChild('colonyMonPic_'..monID);

    local mapFrame = ui.GetFrame('map');
    local COLONY_MON_IMG = GET_COLONY_MONSTER_IMG(mapFrame, monID);
    local MONSTER_SIZE = tonumber(mapFrame:GetUserConfig('COLONY_MON_SIZE'));
    local MONSTER_EFFECT_SIZE = tonumber(mapFrame:GetUserConfig('COLONY_MON_EFFECT_SIZE'));

    local x, z = GET_COLONY_MONSTER_POS(posStr);    
    local colonyMonPic = frame:CreateControl('picture', 'colonyMonPic_'..monID, 0, 0, MONSTER_SIZE, MONSTER_SIZE);    
    colonyMonPic = AUTO_CAST(colonyMonPic);    
    colonyMonPic:SetImage(COLONY_MON_IMG);

    local zoneClassName = GetZoneName();
    local mapprop = geMapTable.GetMapProp(zoneClassName);
    local MapPos = mapprop:WorldPosToMinimapPos(x, z, 1024, 1024);
    local mappicturetemp = GET_CHILD(frame, 'map', 'ui::CPicture');
    local offsetX = mappicturetemp:GetX();
	local offsetY = mappicturetemp:GetY();
    local _x = offsetX + MapPos.x - MONSTER_SIZE / 2;
	local _y = offsetY + MapPos.y - MONSTER_SIZE / 2;
    colonyMonPic:SetOffset(_x, _y);
	colonyMonPic:SetEnableStretch(1);

    if IS_COLONY_MONSTER(monID) == true then
        frame:RemoveChild('colonyMonEffectPic');
        local colonyMonEffectPic = frame:CreateControl('picture', 'colonyMonEffectPic', 0, 0, MONSTER_EFFECT_SIZE, MONSTER_EFFECT_SIZE);
        colonyMonEffectPic = AUTO_CAST(colonyMonEffectPic);
        _x = offsetX + MapPos.x - MONSTER_EFFECT_SIZE / 2;
	    _y = offsetY + MapPos.y - MONSTER_EFFECT_SIZE / 2;
        colonyMonEffectPic:SetOffset(_x, _y);
        SET_PICTURE_QUESTMAP(colonyMonEffectPic);
    end
end