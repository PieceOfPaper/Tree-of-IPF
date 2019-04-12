first_click_x = nil  -- 월드맵에서 드래그를 위해서 클릭할 때, 최초 좌표를 기억한다.
first_click_y = nil


function WORLDMAP_ON_INIT(addon, frame)


end


function UI_TOGGLE_WORLDMAP()
	if app.IsBarrackMode() == true then
		return;
	end
	ui.ToggleFrame('worldmap')
end

function CLAMP_WORLDMAP_POS(frame, cx, cy)

	local maxY = frame:GetUserIValue("MAX_Y");
	local minX = frame:GetUserIValue("MIN_X");
	cx = CLAMP(cx, minX, 0);
	cy = CLAMP(cy, 0, maxY);
	if maxY < 0 then
		cy = maxY;
	end

	return cx, cy;	

end

function WORLDMAP_SIZE_UPDATE(frame)
	
	if ui.GetSceneHeight() / ui.GetSceneWidth() <= ui.GetClientInitialHeight() / ui.GetClientInitialWidth() then
		frame:Resize(ui.GetSceneWidth() * ui.GetClientInitialHeight() / ui.GetSceneHeight() ,ui.GetClientInitialHeight())
	end
	frame:Invalidate();
end

function WORLDMAP_UPDATE_PICSIZE(frame, currentDirection)

	local curMode = frame:GetUserValue("Mode");

	local imgName = "worldmap_" .. currentDirection .. "_bg";
	local pic = GET_CHILD(frame, "pic");
	local size = ui.GetSkinImageSize(imgName);

	local curSize = config.GetConfigInt("WORLDMAP_SCALE");
	local sizeRatio = 1 + curSize * 0.25;
	local t_scale = frame:GetChild("t_scale");
	t_scale:SetTextByKey("value", string.format("%.2f", sizeRatio));

	local picWidth = size.x * sizeRatio;
	local picHeight = size.y * sizeRatio;
	
	pic:Resize(picWidth, picHeight);
	local frameWidth = frame:GetWidth();
	local frameHeight = frame:GetHeight();
	local horzAlign;
	local vertAlign;
	if picWidth < frameWidth then
		horzAlign = ui.CENTER_HORZ;
	else
		horzAlign = ui.LEFT;
	end

	if picHeight < frameHeight then
		vertAlign = ui.CENTER_VERT;
	else
		vertAlign = ui.TOP;
	end

	pic:SetGravity(horzAlign, vertAlign);
	
	local gbox = pic:CreateOrGetControl("groupbox", "GBOX_".. curMode, 0, 0, picWidth, picHeight);
	gbox:SetSkinName("None");
	gbox:Resize(picWidth, picHeight);
	gbox:EnableHitTest(1);
	gbox = AUTO_CAST(gbox);
	gbox:EnableScrollBar(0);
	gbox:EnableHittestGroupBox(false);	

	WORLDMAP_UPDATE_CLAMP_MINMAX(frame);

	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");

	cx, cy = CLAMP_WORLDMAP_POS(frame, cx, cy);
	
	WORLDMAP_SETOFFSET(frame, cx, cy);

end

function OPEN_WORLDMAP(frame)

	frame:SetUserValue("Mode", "WorldMap");
	_OPEN_WORLDMAP(frame);

end

function WORLDMAP_UPDATE_CLAMP_MINMAX(frame)

	local pic = frame:GetChild("pic");
	local frameHeight = frame:GetHeight();
	local picHeight = pic:GetHeight();
	local maxY = picHeight - frameHeight;
	frame:SetUserValue("MAX_Y", maxY);

	local frameWidth = frame:GetWidth();
	local picWidth = pic:GetWidth();

	local minX = picWidth - frameWidth;
	if minX < 0 then
		minX = 0;
	end

 	frame:SetUserValue("MIN_X", -minX);

end

function _OPEN_WORLDMAP(frame)

	WORLDMAP_SIZE_UPDATE(frame);
	frame:Invalidate();
	
	local pic = frame:GetChild("pic");

	UPDATE_WORLDMAP_CONTROLS(frame);
	
	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");

	cx, cy = CLAMP_WORLDMAP_POS(frame, cx, cy);	

	WORLDMAP_SETOFFSET(frame, cx, cy);
	
end

function UPDATE_WORLDMAP_CONTROLS(frame, changeDirection)

	if frame:GetName() == "worldmap" then
		CREATE_ALL_ZONE_TEXT(frame, changeDirection);
	else
		ON_INTE_WARP(frame, changeDirection);		
	end

end

function PRELOAD_WORLDMAP()

	local frame = ui.GetFrame("worldmap");
	OPEN_WORLDMAP(frame);

end

function CREATE_ALL_ZONE_TEXT(frame, changeDirection)

	local clsList, cnt = GetClassList('Map');	
	if cnt == 0 then
		return;
	end

	local makeWorldMapImage = session.mapFog.NeedUpdateWorldMap();
		
	local currentDirection = config.GetConfig("WORLDMAP_DIRECTION", "s");
	currentDirection = "s";

	if changeDirection == true or ui.GetImage("worldmap_" .. currentDirection .. "_current") == nil then
		makeWorldMapImage = true;
	end

	WORLDMAP_UPDATE_PICSIZE(frame, currentDirection);
	
	local pic = GET_CHILD(frame, "pic" ,"ui::CPicture");
	
	local picHeight = pic:GetHeight();
	local frameHeight = frame:GetHeight();
	local bottomY = picHeight;
	
	local imgSize = ui.GetSkinImageSize("worldmap_" .. currentDirection .. "_bg");

	local startX = - 120;
	local startY = bottomY - 40;
	local pictureStartY = imgSize.y - 15;

	local spaceX = 65.25;
	local spaceY = 65.25;

	local mapName = session.GetMapName();
	
	ui.ClearBrush();
	
	local curMode = frame:GetUserValue("Mode");
	local imgName = "worldmap_" .. currentDirection .. "_bg";
	local parentGBox = pic:GetChild("GBOX_".. curMode);
	if changeDirection == true then
		DESTROY_CHILD_BYNAME(parentGBox, "ZONE_GBOX_");
	end

	CREATE_ALL_WORLDMAP_CONTROLS(frame, parentGBox, makeWorldMapImage, changeDirection, mapName, currentDirection, spaceX, startX, spaceY, startY, pictureStartY);

	if makeWorldMapImage == true then
		ui.CreateCloneImageSkin("worldmap_" .. currentDirection .. "_fog", "worldmap_" .. currentDirection .. "_current");
		ui.DrawBrushes("worldmap_" .. currentDirection .. "_current", "worldmap_" .. currentDirection .. "_bg")
	end

	pic:SetImage("worldmap_" .. currentDirection .. "_current");

end

function GET_WORLDMAP_GROUPBOX(frame)
	if frame:GetName() == "worldmap" then
		local curMode = frame:GetUserValue("Mode");
		local pic = GET_CHILD(frame, "pic" ,"ui::CPicture");
		return pic:GetChild("GBOX_".. curMode);
	end

	return GET_CHILD(frame, "pic" ,"ui::CPicture");
end

function CREATE_ALL_WORLDMAP_CONTROLS(frame, parentGBox, makeWorldMapImage, changeDirection, mapName, currentDirection, spaceX, startX, spaceY, startY, pictureStartY)

	local clsList, cnt = GetClassList('Map');	
	if cnt == 0 then
		return;
	end

	local nowMapIES = GetClass('Map',mapName)
	local nowMapWorldPos = SCR_STRING_CUT(nowMapIES.WorldMap)

	local sObj = session.GetSessionObjectByName("ssn_klapeda");
	local questPossible = {}
	if sObj ~= nil then
		sObj = GetIES(sObj:GetIESObject());
		if sObj.MQ_POSSIBLE_LIST ~= 'None' then
		    questPossible = SCR_STRING_CUT(sObj.MQ_POSSIBLE_LIST)
		end
	end

	for i=0, cnt-1 do
		local mapCls = GetClassByIndexFromList(clsList, i);
		if mapCls.WorldMap ~= "None" then

			local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);
			
			if currentDirection == dir then
			
				local etc = GetMyEtcObject();
            
				if etc['HadVisited_' .. mapCls.ClassID] == 1 or FindCmdLine("-WORLDMAP") > 0 then
                
					local gBoxName = "ZONE_GBOX_" .. x .. "_" .. y;
				
					if changeDirection ~= true or parentGBox:GetChild(gBoxName) == nil then
				    
						CREATE_WORLDMAP_MAP_CONTROLS(parentGBox, makeWorldMapImage, changeDirection, nowMapIES, mapCls, questPossible, nowMapWorldPos, gBoxName, x, spaceX, startX, y, spaceY, startY, pictureStartY);

					end
				end
			end
		end
	end


end

function MAPNAME_FONT_CHECK(mapLvValue)
    local pc = GetMyPCObject();
    local pcLv = pc.Lv
    local mapNameFont = ''

	-- 검정
	if mapLvValue > pcLv + 80 then 
	    mapNameFont = '{@st66e}{#646464}{b}'
	-- 빨강
	elseif mapLvValue > pcLv + 60 then 
	    mapNameFont = '{@st66e}{#e72100}{b}'
	-- 노랑
	elseif mapLvValue > pcLv + 40 then 
	    mapNameFont = '{@st66e}{#ffc000}{b}'
	-- 초록
	elseif mapLvValue > pcLv + 20 then
	    mapNameFont = '{@st66e}{#00c01b}{b}'
	-- 파랑
	elseif mapLvValue > pcLv then 
	    mapNameFont = '{@st66e}{#00a2ff}{b}'
	else
	    mapNameFont = '{@st66e}{#ffffff}{b}'
	end
	
	return mapNameFont
end

function CREATE_WORLDMAP_MAP_CONTROLS(parentGBox, makeWorldMapImage, changeDirection, nowMapIES, mapCls, questPossible, nowMapWorldPos, gBoxName, x, spaceX, startX, y, spaceY, startY, pictureStartY)
	local curSize = config.GetConfigInt("WORLDMAP_SCALE");
	local sizeRatio = 1 + curSize * 0.25;

	local picX = startX + x * spaceX * sizeRatio;
	local picY = startY - y * spaceY * sizeRatio;

	if picX < 0 then
		picX = 0
	end

	if changeDirection == false then
		local gbox = parentGBox:GetChild(gBoxName);
		if gbox ~= nil then
			gbox:SetOffset(picX, picY);
			return;
		end
	end
	local gbox = parentGBox:CreateOrGetControl("groupbox", gBoxName, picX, picY, 200, 120)
	gbox:SetEventScript(ui.MOUSEWHEEL, "WORLDMAP_MOUSEWHEEL");
	gbox:SetSkinName("None");
	gbox:ShowWindow(1);
	gbox = AUTO_CAST(gbox);
	gbox:EnableScrollBar(0);
	local ctrlSet = gbox:CreateOrGetControlSet('worldmap_zone', "ZONE_CTRL_" .. mapCls.ClassID, ui.LEFT, ui.TOP, 0, 0, 0, 0);
	ctrlSet:ShowWindow(1);
	local text = ctrlSet:GetChild("text");
	if mapName == mapCls.ClassName then
		text:SetTextByKey("font", "{@st57}");
	end
			        
	local mainName = mapCls.MainName;
	local mapLv = mapCls.QuestLevel
	local nowGetTypeIES = SCR_GET_XML_IES('camp_warp','Zone', nowMapIES.ClassName)
	local warpGoddessIcon_now = ''
	local questPossibleIcon = ''
					
	if #questPossible > 0 then
		if table.find(questPossible, tostring(mapCls.ClassID)) > 0 then
			questPossibleIcon = '{img minimap_1_MAIN 24 24}'
		end
	end
					
        if #nowGetTypeIES > 0 then
		warpGoddessIcon_now = '{img minimap_goddess 24 24}'
	end
	
	local getTypeIES = SCR_GET_XML_IES('camp_warp','Zone', mapCls.ClassName)
	local warpGoddessIcon = ''
    if #getTypeIES > 0 then
		warpGoddessIcon = '{img minimap_goddess 24 24}'
	end
	
	local mapType = TryGetProp(mapCls, 'MapType');
	local dungeonIcon = ''
    if mapType == 'Dungeon' then
		dungeonIcon = '{img minimap_dungeon 30 30}'
	end
	
	local mapLvValue = mapLv
	if mapLv == nil or mapLv == 'None' or mapLv == '' or mapLv == 0 then
		mapLv = ''
	else
		mapLv = 'Lv.'..mapLv
	end

	local recoverRate = 0
	if 0 ~= MAP_USE_FOG(mapCls.ClassName) then
		recoverRate = session.GetMapFogRevealRate(mapCls.ClassName);
	end

	local mapratebadge = ""
	
	if recoverRate >= 100 then
		mapratebadge = "{img minimap_complete 24 24}"
	end
	
	local mapNameFont = MAPNAME_FONT_CHECK(mapLvValue)

	if mainName ~= "None" then
		text:SetTextByKey("value", dungeonIcon..'{nl}'..mapNameFont..mainName..'{nl}'..warpGoddessIcon..questPossibleIcon..mapLv..mapratebadge..'{/}{nl}'..GET_STAR_TXT(20,mapCls.MapRank));
	else
		if mapName ~= mapCls.ClassName and nowMapWorldPos[1] == x and nowMapWorldPos[2] == y then
			local nowmapLv = nowMapIES.QuestLevel
			if nowmapLv == nil or nowmapLv == 'None' or nowmapLv == '' or nowmapLv == 0 then
        		nowmapLv = ''
        	else
        		nowmapLv = '{nl}Lv.'..nowmapLv
        	end
			text:SetTextByKey("value", dungeonIcon..'{nl}'..mapNameFont..mapCls.Name..'{nl}'..warpGoddessIcon..questPossibleIcon..mapLv..mapratebadge..'{nl}'..warpGoddessIcon_now..questPossibleIcon..'{@st57}'..nowMapIES.Name..nowmapLv..'{/}'.."{nl}"..GET_STAR_TXT(20,mapCls.MapRank))
		else
    		text:SetTextByKey("value", dungeonIcon..'{nl}'..mapNameFont..mapCls.Name..'{nl}'..warpGoddessIcon..questPossibleIcon..mapLv..mapratebadge.."{nl}"..GET_STAR_TXT(20,mapCls.MapRank));						
    	end
	end
					
--	local gbox_bg = ctrlSet:GetChild("gbox_bg");
--	gbox_bg:Resize(text:GetWidth() + 10, text:GetHeight() + 10);
	ctrlSet:SetEventScript(ui.LBUTTONDOWN, "WORLDMAP_LBTNDOWN");
	ctrlSet:SetEventScript(ui.LBUTTONUP, "WORLDMAP_LBTNUP");
	ctrlSet:SetEventScript(ui.MOUSEWHEEL, "WORLDMAP_MOUSEWHEEL");
				
	ctrlSet:SetTooltipType('worldmap');
	ctrlSet:SetTooltipArg(mapCls.ClassName);

	local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local count = list:Count();
	local memberIndex = 0;
	local suby = text:GetY() + text:GetHeight();
	
	DESTROY_CHILD_BYNAME(ctrlSet, "WMAP_PMINFO_");

	for j = 0 , count - 1 do
				
		local partyMemberInfo = list:Element(j);
		local partyMemberName = partyMemberInfo:GetName();

		if partyMemberInfo:GetMapID() == mapCls.ClassID and partyMemberName ~= info.GetFamilyName(session.GetMyHandle()) then
					
			local memberctrlSet = ctrlSet:CreateOrGetControlSet('worldmap_partymember_iconset', "WMAP_PMINFO_" .. partyMemberName, 0, suby );
		
			local pm_namertext = GET_CHILD(memberctrlSet,'pm_name','ui::CRichText')
			pm_namertext:SetTextByKey('pm_fname',partyMemberName)

			if suby > ctrlSet:GetHeight() then
				ctrlSet:Resize(ctrlSet:GetOriginalWidth(),suby)
			end

			memberIndex = memberIndex + 1;
			suby = suby + (memberIndex+1 * 25)
						
		end
	end	

	if makeWorldMapImage == true then

		local brushX = startX + x * spaceX;
		local brushY = pictureStartY - y * spaceY;

		ui.AddBrushArea(brushX + ctrlSet:GetWidth() / 2, brushY + ctrlSet:GetHeight() / 2, ctrlSet:GetWidth() + WORLDMAP_ADD_SPACE);
	end
	 
	GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true, false);

end

function WORLDMAP_SETOFFSET(frame, x, y)

	local pic = frame:GetChild("pic");
	local frameHeight = frame:GetHeight();
	local picHeight = pic:GetHeight();
	local startY = frameHeight - picHeight;

	pic:SetOffset(x, startY + y);

end

function WORLDMAP_MOUSEWHEEL(parent, ctrl, s, n)
	
	if keyboard.IsPressed(KEY_CTRL) == 1 then
		local frame = parent:GetTopParentFrame();
		if n > 0 then
			WORLDMAP_CHANGESIZE(frame, nil, nil, 1);
		else
			WORLDMAP_CHANGESIZE(frame, nil, nil, -1);
		end
	else
		local dx = 0;
		local dy = n;
		local cx = config.GetConfigInt("WORLDMAP_X");
		local cy = config.GetConfigInt("WORLDMAP_Y");
		cx = cx + dx;
		cy = cy + dy;

		cx, cy = CLAMP_WORLDMAP_POS(ctrl:GetTopParentFrame(), cx, cy);

		config.SetConfig("WORLDMAP_X", cx);	
		config.SetConfig("WORLDMAP_Y", cy);
		WORLDMAP_SETOFFSET(ctrl:GetTopParentFrame(), cx, cy);
	
	end
end

function WORLDMAP_LBTNDOWN(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local pic = frame:GetChild("pic");
	local x, y = GET_MOUSE_POS();
	pic:SetUserValue("MOUSE_X", x);
	pic:SetUserValue("MOUSE_Y", y);
	
	first_click_x = x	-- 드래그할 때, 클릭한 좌표를 기억한다.
	first_click_y = y
	
	ui.EnableToolTip(0);
	mouse.ChangeCursorImg("MOVE_MAP", 1);
	pic:RunUpdateScript("WORLDMAP_PROCESS_MOUSE");
end

function WORLDMAP_LBTNUP(parent, ctrl)
	-- 워프 위치에서 마우스를 떼지 않았다면 클릭한 좌표를 리셋한다.
	first_click_x = nil		
	first_click_y = nil
end

function WORLDMAP_PROCESS_MOUSE(ctrl)

	if mouse.IsLBtnPressed() == 0 then
		mouse.ChangeCursorImg("BASIC", 0);
		ui.EnableToolTip(1);
		return 0;
	end
	
	local mx, my = GET_MOUSE_POS();
	local x = ctrl:GetUserIValue("MOUSE_X");
	local y = ctrl:GetUserIValue("MOUSE_Y");
	local dx = mx - x;
	local dy = my - y;
	dx = dx * 2;
	dy = dy * 2;

	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");
	cx = cx + dx;
	cy = cy + dy;

	cx, cy = CLAMP_WORLDMAP_POS(ctrl:GetTopParentFrame(), cx, cy);

	config.SetConfig("WORLDMAP_X", cx);	
	config.SetConfig("WORLDMAP_Y", cy);
	WORLDMAP_SETOFFSET(ctrl:GetTopParentFrame(), cx, cy);
	

	ctrl:SetUserValue("MOUSE_X", mx);
	ctrl:SetUserValue("MOUSE_Y", my);

	return 1;
end

function WORLDMAP_SHOW_DIRECTION(frame, ctrl, str, num)

	config.SetConfig("WORLDMAP_DIRECTION", str);
	UPDATE_WORLDMAP_CONTROLS(frame, true);

end

function WORLDMAP_CHANGESIZE(frame, ctrl, str, isAmplify)

	local curSize = config.GetConfigInt("WORLDMAP_SCALE");
	local sizeRatio = 1 + curSize * 0.25;
	curSize = curSize + isAmplify;
	curSize = CLAMP(curSize, -3, 12);
	config.SetConfig("WORLDMAP_SCALE", curSize);
	local afterSizeRatio = 1 + curSize * 0.25;
	if sizeRatio == afterSizeRatio then
		return;
	end

	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");
	local multiPlyRatio = afterSizeRatio / sizeRatio;
	cx = cx * multiPlyRatio;
	cy = cy * multiPlyRatio;
	config.SetConfig("WORLDMAP_X", cx);
	config.SetConfig("WORLDMAP_Y", cy);

	UPDATE_WORLDMAP_CONTROLS(frame);
	

end

function WORLDMAP_LOCATE_LASTWARP(parent, ctrl)

	local etcObj = GetMyEtcObject();
	local mapCls = GetClassByType("Map", etcObj.LastWarpMapID);
	if mapCls ~= nil then
		LOCATE_WORLDMAP_POS(parent:GetTopParentFrame(), mapCls.ClassName);
	end
	
end

function WORLDMAP_LOCATE_NOWPOS(parent, ctrl)
	local mapName= session.GetMapName();
	LOCATE_WORLDMAP_POS(parent:GetTopParentFrame(), mapName);
end

function GET_DUNGEON_LIST(below, above)
    local pc = GetMyPCObject();
    local pcLv = pc.Lv
	local maxLevel = pc.Lv + above;
	local minLevel = pc.Lv + below;

	local recommendlist = {};
	local clslist, cnt = GetClassList("Map");
				
	local etc = GetMyEtcObject();
	for i = 0, cnt - 1 do
		local mapCls = GetClassByIndexFromList(clslist, i);
		if etc['HadVisited_' .. mapCls.ClassID] == 1 or FindCmdLine("-WORLDMAP") > 0 then
			if mapCls.MapType == 'Dungeon' and mapCls.QuestLevel >= minLevel and mapCls.QuestLevel <= maxLevel then
				recommendlist[#recommendlist + 1] = mapCls;
			end	
		end
	end
	return recommendlist;
end

function GET_RECOMMENDDED_DUNGEON(dungeonlist)
    local pc = GetMyPCObject();
    local pcLv = pc.Lv;
	
	local dungeon = dungeonlist[1];
	if dungeon == nil then
		return;
	end
	local dungeonDiff = math.abs(dungeon.QuestLevel - pcLv);
	for i=1, #dungeonlist do
		local newDiff = dungeonlist[i].QuestLevel - pcLv;
		if math.abs(newDiff) < dungeonDiff then
			dungeon = dungeonlist[i];
			dungeonDiff = math.abs(dungeon.QuestLevel - pcLv);
		end
	end
	return dungeon;
end


function WORLDMAP_LOCATE_RECOMMENDDED_DUNGEON(parent, ctrl)
	local recommendlist = GET_DUNGEON_LIST(-10, 3)
	local recommendded = GET_RECOMMENDDED_DUNGEON(recommendlist);

	if TryGetProp(recommendded, "ClassName") ~= nil then
		LOCATE_WORLDMAP_POS(parent:GetTopParentFrame(), recommendded.ClassName);
	end
end

function LOCATE_WORLDMAP_POS(frame, mapName)

	local gBox = GET_WORLDMAP_GROUPBOX(frame);
	local mapCls = GetClass("Map", mapName);
	if mapCls == nil then
		
		return
	end
	if mapCls.WorldMap == "None" then
		return;
	end

	local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);	
	local gBoxName = "ZONE_GBOX_" .. x .. "_" .. y;

	local childCtrl = gBox:GetChild(gBoxName);

	if childCtrl == nil then
		return; -- ��ϵ�?���Ż��� ������ nil�ΰ�?
	end

	local x = childCtrl:GetX();
	local y = childCtrl:GetY();

	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");
	local pic = GET_CHILD(frame, "pic");

	local curSize = config.GetConfigInt("WORLDMAP_SCALE");
	local sizeRatio = 1 + curSize * 0.25;

	local destX = - x + frame:GetWidth() / 2;
	local destY = pic:GetHeight() - (frame:GetHeight() / 2)  - y;

	destX, destY = CLAMP_WORLDMAP_POS(frame, destX, destY);	
	WORLDMAP_SETOFFSET(frame, destX, destY);
	
	config.SetConfig("WORLDMAP_X", destX);	
	config.SetConfig("WORLDMAP_Y", destY);
	
	x = x + 0.5 * childCtrl:GetWidth() + 5;
	y = y + 0.5 * childCtrl:GetHeight() + 5;
	
	local emphasize = gBox:CreateOrGetControlSet('worldmap_emphasize', "EMPHASIZE", x, y);
	emphasize:EnableHitTest(0);
	x = x - emphasize:GetWidth() / 2;
	y = y - emphasize:GetHeight() / 2;

	emphasize:SetOffset(x, y);
	emphasize:MakeTopBetweenChild();
	emphasize:ShowWindow(1);
	local animpic = GET_CHILD(emphasize, "animpic");
	animpic:ShowWindow(1);
	animpic:PlayAnimation();

end

function WORLDMAP_SEARCH_BY_NAME(frame, ctrl)

	local inputSearch = frame:GetChild('input_search')
	local searchText = inputSearch:GetText()
	local oldSearchText = frame:GetUserValue('SEARCH_TEXT')
	local oldSearchIdx = frame:GetUserValue('SEARCH_IDX')

	if searchText == "" then
		return
	end

	local etc = GetMyEtcObject();    
	local mapList, cnt = GetClassList('Map')
	if etc == nil or mapList == nil or cnt < 1 then -- valid check
		return
	end

    local targetMap = {}
	local targetCnt = 0
	for i=0, cnt-1 do
		local mapCls = GetClassByIndexFromList(mapList, i);
		if mapCls ~= nil and mapCls.WorldMap ~= "None" and (etc['HadVisited_' .. mapCls.ClassID] == 1 or FindCmdLine("-WORLDMAP") > 0)then
			local tempname = string.lower(dictionary.ReplaceDicIDInCompStr(mapCls.Name));		
			local tempinputtext = string.lower(searchText)
			if tempinputtext == "" or true == ui.FindWithChosung(tempinputtext, tempname) then
				targetMap[targetCnt] = mapCls.ClassName
				targetCnt = targetCnt + 1
			end
		end
	end

	local showIdx = 0
	if oldSearchText == searchText then
		showIdx = tonumber(oldSearchIdx) + 1
		if showIdx >= targetCnt then
			showIdx = showIdx - targetCnt
		end
	else
		frame:SetUserValue('SEARCH_TEXT', searchText)
	end
	frame:SetUserValue('SEARCH_IDX', tostring(showIdx))
	LOCATE_WORLDMAP_POS(frame, targetMap[showIdx]);
end


