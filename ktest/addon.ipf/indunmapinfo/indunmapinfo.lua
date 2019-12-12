function INDUNMAPINFO_ON_INIT(addon, frame)
    SIZE_RATIO_INDUN_MAP_INFO = 1; -- 확대 배율 기본 적용
end

function OPEN_INDUN_MAP_INFO(indunClassID, selectedMapID, resetGroupID)
    local frame = ui.GetFrame('indunmapinfo');
	frame:SetUserValue('INDUN_CLASS_ID', indunClassID);
	if resetGroupID ~= nil then
		frame:SetUserValue('RESET_GROUP_ID', resetGroupID);
	end
    local worldMapPic = INDUNMAPINFO_SET_PICTURE(frame);
    local mustShowMapCtrl = INDUNMAPINFO_RESET_MAP_CTRL(frame, worldMapPic, tonumber(selectedMapID));
    INDUNMAPINFO_SET_INDUN_POS(frame, worldMapPic, mustShowMapCtrl, selectedMapID);
    frame:ShowWindow(1);
end

function INDUNMAPINFO_SET_PICTURE(frame)
    local worldMapPic = GET_CHILD_RECURSIVELY(frame, 'worldMapPic');
    local imageName = worldMapPic:GetImageName();
    local size = ui.GetSkinImageSize(imageName);    
    worldMapPic:Resize(size.x * SIZE_RATIO_INDUN_MAP_INFO, size.y * SIZE_RATIO_INDUN_MAP_INFO);
    return worldMapPic;
end

function INDUNMAPINFO_RESET_MAP_CTRL(frame, worldMapPic, mustShowID)	
    local mapClsList, cnt = GetClassList('Map');
    local accObj = GetMyAccountObj();
    if mapClsList == nil or cnt < 1 or accObj == nil then    	
        return nil;
    end
    worldMapPic:RemoveAllChild();
    local mustShowCtrl = nil;
    for i = 0, cnt - 1 do
        local mapCls = GetClassByIndexFromList(mapClsList, i);
        if mapCls ~= nil and mapCls.WorldMap ~= 'None' then
            local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);            
			if mustShowID == mapCls.ClassID then				
				local gBoxName = INDUNMAPINFO_GET_MAP_INFO_CTRL_NAME(x, y);
				local ctrl = worldMapPic:GetChild(gBoxName);							
				if ctrl == nil then
                    ctrl = INDUNMAPINFO_CREATE_MAP_CTRL(worldMapPic, mapCls, x, y, true);                    
                else
                	local ctrlSet = nil;
                	local childCnt = ctrl:GetChildCount();
                	for j = 0, childCnt - 1 do
                		local child = ctrl:GetChildByIndex(j);
                		if string.find(child:GetName(), 'ZONE_CTRL_') ~= nil then
                			ctrlSet = child;
                		end
                	end
                	
                	if ctrlSet ~= nil then
        				INDUNMAPINFO_SET_TOOLTIP(frame, ctrl, ctrlSet, mapCls);
        			end
				end
				mustShowCtrl = ctrl;
            elseif accObj['HadVisited_' .. mapCls.ClassID] == 1 then
                local gBoxName = INDUNMAPINFO_GET_MAP_INFO_CTRL_NAME(x, y);
                local ctrl = worldMapPic:GetChild(gBoxName);
                if ctrl == nil then
					ctrl = INDUNMAPINFO_CREATE_MAP_CTRL(worldMapPic, mapCls, x, y, false);                    
				end
				if mustShowCtrl == nil then
                    mustShowCtrl = ctrl;
                end
			end
        end
    end    
    return mustShowCtrl;
end

function INDUNMAPINFO_GET_MAP_INFO_CTRL_NAME(x, y)
    return "ZONE_GBOX_" .. x .. "_" .. y;
end

function INDUNMAPINFO_CREATE_MAP_CTRL(parentGBox, mapCls, x, y, needTooltip)
    local startX = -120;
	local startY = parentGBox:GetHeight() - 40;	
	local spaceX = 65.25;
	local spaceY = 65.25;

	local picX = math.max(0, startX + x * spaceX * SIZE_RATIO_INDUN_MAP_INFO);
	local picY = startY - y * spaceY * SIZE_RATIO_INDUN_MAP_INFO;
    local gBoxName = INDUNMAPINFO_GET_MAP_INFO_CTRL_NAME(x, y);
	local gbox = parentGBox:CreateOrGetControl("groupbox", gBoxName, picX, picY, 200, 120);
	gbox:SetSkinName("None");
	gbox:ShowWindow(1);
	gbox = AUTO_CAST(gbox);
	gbox:EnableScrollBar(0);
	local ctrlSet = gbox:CreateOrGetControlSet('worldmap_zone', "ZONE_CTRL_" .. mapCls.ClassID, ui.LEFT, ui.TOP, 0, 0, 0, 0);
	ctrlSet:ShowWindow(1);
        
	local mainName = mapCls.MainName;
	local mapLv = mapCls.QuestLevel;
	local warpGoddessIcon_now = '';
	local getTypeIES = SCR_GET_XML_IES('camp_warp','Zone', mapCls.ClassName);
	local warpGoddessIcon = '';
    if #getTypeIES > 0 then
		warpGoddessIcon = '{img minimap_goddess 24 24}';
	end
	
    local totalCtrlHeight = 0;
    local maxCtrlWidth = 0;
	local mapType = TryGetProp(mapCls, 'MapType');
	local dungeonIcon = '';
    if mapType == 'Dungeon' then
		dungeonIcon = '{img minimap_dungeon 30 30}';
        local dungeonText = ctrlSet:CreateControl('richtext', 'dungeonText', 0, 0, 30, 30);
        SET_WORLDMAP_RICHTEXT(dungeonText);
        dungeonText:SetText(dungeonIcon);
        totalCtrlHeight = totalCtrlHeight + dungeonText:GetHeight();
        maxCtrlWidth = GET_MAX_WIDTH(maxCtrlWidth, dungeonText:GetWidth());
	end
	
	local mapLvValue = mapLv;
	if mapLv == nil or mapLv == 'None' or mapLv == '' or mapLv == 0 then
		mapLv = '';
	else
		mapLv = 'Lv.'..mapLv;
	end

	local recoverRate = 0
	if 0 ~= MAP_USE_FOG(mapCls.ClassName) then
		recoverRate = session.GetMapFogRevealRate(mapCls.ClassName);
	end
    	
	local mapNameFont = MAPNAME_FONT_CHECK(mapLvValue);
    local text = ctrlSet:CreateControl('richtext', 'text', 0, 0, 30, 30);
    SET_WORLDMAP_RICHTEXT(text);

    local infoText = ctrlSet:CreateControl('richtext', 'infoText', 0, 0, 30, 30);
    SET_WORLDMAP_RICHTEXT(infoText);

	if mainName ~= "None" then
		text:SetText(mapNameFont..mainName);
        totalCtrlHeight = totalCtrlHeight + text:GetHeight();
        maxCtrlWidth = GET_MAX_WIDTH(maxCtrlWidth, text:GetWidth());
	else
    	text:SetText(mapNameFont..mapCls.Name);
        totalCtrlHeight = totalCtrlHeight + text:GetHeight();
        maxCtrlWidth = GET_MAX_WIDTH(maxCtrlWidth, text:GetWidth());

        infoText:SetText(warpGoddessIcon..mapNameFont..mapLv..'{/}');
        totalCtrlHeight = totalCtrlHeight + infoText:GetHeight();
        maxCtrlWidth = GET_MAX_WIDTH(maxCtrlWidth, infoText:GetWidth());
	end

    local starText = ctrlSet:CreateControl('richtext', 'starText', 0, 0, 30, 30);
    SET_WORLDMAP_RICHTEXT(starText);
    starText:SetText(GET_STAR_TXT(20,mapCls.MapRank));
    totalCtrlHeight = totalCtrlHeight + starText:GetHeight();
    maxCtrlWidth = GET_MAX_WIDTH(maxCtrlWidth, starText:GetWidth());    

    if needTooltip == true then
        local topFrame = gbox:GetTopParentFrame();
        INDUNMAPINFO_SET_TOOLTIP(topFrame, gbox, ctrlSet, mapCls);
    else
        gbox:EnableHitTest(0);
    end

    GBOX_AUTO_ALIGN(ctrlSet, 0, 0, 0, true, false);
	GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true, false); 
    
    -- 사이즈를 최대한 fit하게 해야지
    ctrlSet:Resize(maxCtrlWidth, totalCtrlHeight);
    gbox:Resize(ctrlSet:GetWidth(), ctrlSet:GetHeight());
    
    -- 위치를 보정하자, picX, picY는 200, 120 기준으로 left top 앵커 포인트
    local amendOffsetX = math.floor((200 - maxCtrlWidth) / 2);
    local amendOffsetY = math.floor((120 - totalCtrlHeight) / 2);    
    gbox:SetOffset(picX + amendOffsetX, picY + amendOffsetY);

    if needTooltip == true then
        return gbox;
    end
    return nil;
end

function INDUNMAPINFO_SET_TOOLTIP(frame, gbox, ctrlSet, mapCls)
	local indunClassID = frame:GetUserIValue('INDUN_CLASS_ID');
    gbox:EnableHitTest(1);
	ctrlSet:SetTooltipType('indun_tooltip');
	ctrlSet:SetTooltipStrArg(mapCls.ClassName);
	local resetGroupID = frame:GetUserIValue('RESET_GROUP_ID');
	if resetGroupID ~= nil and resetGroupID < 0 then
		ctrlSet:SetTooltipNumArg(-indunClassID);
	else
		ctrlSet:SetTooltipNumArg(indunClassID);
	end
    ctrlSet:SetTooltipOverlap(1);
end

function INDUNMAPINFO_SET_INDUN_POS(frame, pic, mustShowMapCtrl, selectedMapID)	
    -- set offset
    local worldMapBox = pic:GetParent();
    local x = mustShowMapCtrl:GetX() + mustShowMapCtrl:GetWidth() - frame:GetWidth() / 2;
    local y = mustShowMapCtrl:GetY() + mustShowMapCtrl:GetHeight() - frame:GetHeight() / 2;    
    x, y = CLAMP_OFFSET_BY_FRAME_SIZE(frame, pic, -x, -y);
    pic:SetOffset(x, y);

    -- emphasize effect
    local mapCls = GetClassByType('Map', selectedMapID);
    local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);
	local gBoxName = INDUNMAPINFO_GET_MAP_INFO_CTRL_NAME(x, y);
	local childCtrl = GET_CHILD_RECURSIVELY(pic, gBoxName);
    x = childCtrl:GetX() + childCtrl:GetWidth() / 2;
    y = childCtrl:GetY() + childCtrl:GetHeight() / 2;
	    
	local emphasize = pic:CreateOrGetControlSet('indunmap_emphasize', "EMPHASIZE", x, y);
	emphasize:EnableHitTest(0);
	x = x - emphasize:GetWidth() / 2;
	y = y - emphasize:GetHeight() / 2;

	emphasize:SetOffset(x, y);
	emphasize:MakeTopBetweenChild();
	emphasize:ShowWindow(1);
	local animpic = GET_CHILD(emphasize, "animpic");
    animpic:SetWaitAnimEndTime(1);
	animpic:ShowWindow(1);
	animpic:PlayAnimation();
end

function INDUNMAPINFO_WORLDMAP_LBTN_DOWN(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local x, y = GET_LOCAL_MOUSE_POS(topFrame);
    INDUNMAPINFO_WORLDMAP_SET_DOWN_POS(topFrame, x, y);
    topFrame:RunUpdateScript("INDUNMAPINFO_WORLDMAP_DRAG_PROCESS", 0.01, 10, 0, 1);
end

function INDUNMAPINFO_WORLDMAP_SET_DOWN_POS(frame, x, y)
    frame:SetUserValue('WORLDMAP_DOWN_X', x);
    frame:SetUserValue('WORLDMAP_DOWN_Y', y);
end

function INDUNMAPINFO_WORLDMAP_DRAG_PROCESS(frame, totalTime)
    local THRESHOLD_RATIO = 0.05;

    local worldMapPic = GET_CHILD_RECURSIVELY(frame, 'worldMapPic');
    local preX = frame:GetUserIValue('WORLDMAP_DOWN_X');
    local preY = frame:GetUserIValue('WORLDMAP_DOWN_Y');
    local x, y = GET_LOCAL_MOUSE_POS(frame);
    local deltaX = THRESHOLD_RATIO * (x - preX);
    local deltaY = THRESHOLD_RATIO * (y - preY);
    local offsetX, offsetY = CLAMP_OFFSET_BY_FRAME_SIZE(worldMapPic:GetTopParentFrame(), worldMapPic, worldMapPic:GetX() + deltaX, worldMapPic:GetY() + deltaY);
    worldMapPic:SetOffset(offsetX, offsetY);

    INDUNMAPINFO_CHECK_CURSOR(frame, x, y);
    return 1;
end

function INDUNMAPINFO_WORLDMAP_LBTN_UP(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    INDUNMAPINFO_WORLDMAP_SET_DOWN_POS(topFrame, 0, 0);
    topFrame:StopUpdateScript('INDUNMAPINFO_WORLDMAP_DRAG_PROCESS');
end

function INDUNMAPINFO_CHECK_CURSOR(frame, x, y)
    local THRESHOLD_PIXEL = 5;
    if x <= THRESHOLD_PIXEL or x > frame:GetWidth() - THRESHOLD_PIXEL or y < THRESHOLD_PIXEL or y > frame:GetHeight() - THRESHOLD_PIXEL then
        local topFrame = frame:GetTopParentFrame();
        topFrame:StopUpdateScript('INDUNMAPINFO_WORLDMAP_DRAG_PROCESS');        
    end
end

function CLAMP_OFFSET_BY_FRAME_SIZE(topFrame, pic, x, y)
    x = math.min(0, x);
    x = math.max(x, topFrame:GetWidth() - pic:GetWidth());
    y = math.min(0, y);
    y = math.max(y, topFrame:GetHeight() - pic:GetHeight());
    return x, y;
end

function INDUNMAPINFO_UI_CLOSE(frame)
    frame = ui.GetFrame('indunmapinfo');
    frame:StopUpdateScript('INDUNMAPINFO_WORLDMAP_DRAG_PROCESS');
    ui.CloseFrame('indunmapinfo');
end


function DRAW_NPC_ICON(frame, MonProp, mapprop, mapWidth, mapHeight, offsetX, offsetY)
	local GenList = MonProp.GenList;
	local GenCnt = GenList:Count();
	for j = 0 , GenCnt - 1 do
		local WorldPos = GenList:Element(j);
		local MapPos = mapprop:WorldPosToMinimapPos(WorldPos.x, WorldPos.z, mapWidth, mapHeight);
		local XC = offsetX + MapPos.x - 12;
		local YC = offsetY + MapPos.y - 12;

		local ctrlname = GET_GENNPC_NAME(frame, MonProp);
		local PictureC = frame:CreateOrGetControl('picture', ctrlname, XC, YC, iconW, iconH);
		tolua.cast(PictureC, "ui::CPicture");

		local iconName = MonProp:GetMinimapIcon()
		if iconName == nil or iconName == 'None' then
			iconName = 'minimap_0' -- default icon
		end
		PictureC:SetImage(iconName)
		PictureC:SetEnableStretch(1)
		PictureC:ShowWindow(1)
	end
end

function MAKE_INDUN_ICON(frame, mapName, indunCls, mapWidth, mapHeight, offsetX, offsetY)
	-- param check
	if frame == nil or mapName == nil or indunCls == nil then
		return
	end	
	DESTORY_MAP_PIC(frame)

	-- get indun gate map property
	local mapprop = geMapTable.GetMapProp(mapName)
	if mapprop == nil then
		return
	end

	-- get generated npc
	local mongens = mapprop.mongens
	local monGenCnt = mongens:Count()
	local iconW = 24
	local iconH = 24

	for i = 0 , monGenCnt - 1 do
		local MonProp = mongens:Element(i);		
		if MonProp ~= nil then
			local startNPCDialog = TryGetProp(indunCls, 'StartNPCDialog')
			if startNPCDialog ~= nil and startNPCDialog ~= 'None' and startNPCDialog == MonProp:GetDialog() then
				DRAW_NPC_ICON(frame, MonProp, mapprop, mapWidth, mapHeight, offsetX, offsetY)
			end
		end
	end


end

function MAKE_CONTENTS_ICON(frame, mapName, contentsCls, mapWidth, mapHeight, offsetX, offsetY)
	-- param check
	if frame == nil or mapName == nil or contentsCls == nil then
		return
	end	
	DESTORY_MAP_PIC(frame)

	-- get indun gate map property
	local mapprop = geMapTable.GetMapProp(mapName)
	if mapprop == nil then
		return
	end

	local startPos = contentsCls.StartPos
	local posList = SCR_STRING_CUT(startPos, '/')

	local WorldPos = { x = tonumber(posList[1]), z = tonumber(posList[2]) }
	local MapPos = mapprop:WorldPosToMinimapPos(WorldPos.x, WorldPos.z, mapWidth, mapHeight);
	local XC = offsetX + MapPos.x - 12;
	local YC = offsetY + MapPos.y - 12;

	local ctrlname = '_NPC_GEN_' .. contentsCls.ClassID
	local PictureC = frame:CreateOrGetControl('picture', ctrlname, XC, YC, iconW, iconH);
	tolua.cast(PictureC, "ui::CPicture");

	local iconName = 'None'
	if iconName == nil or iconName == 'None' then
		iconName = 'minimap_0' -- default icon
	end
	PictureC:SetImage(iconName)
	PictureC:SetEnableStretch(1)
	PictureC:ShowWindow(1)
end

function UPDATE_INDUN_TOOLTIP(frame, argStr, argNum)
	------------- param check ----------------
	if frame == nil or argStr == nil or argNum == nil then
		return
	end

	local argList = StringSplit(argStr, '/')
	if #argList < 1 then -- argStr must be "startmap1/startmap2/.../startmapN' (N >= 1)
		return
	end

	local drawList = {};
	for i = 1, #argList do
		local mapCls = GetClass('Map', argList[i])
		if mapCls == nil then -- not exist map
			return
		end

		local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);
		drawList[#drawList + 1] = mapCls;
	end

	local indunCls = GetClassByType('Indun', argNum)
	if argNum < 0 then
		indunCls = GetClassByType('contents_info', -argNum)
	end
	if #drawList < 1 or indunCls == nil then -- some param error
		return
	end

	------------- draw tooltip ----------------
	frame:RemoveAllChild();
	frame:Resize(ui.GetClientInitialWidth(), 512);
	for i = 1 , #drawList do
		local drawCls = drawList[i];
		local ctrlSet = frame:CreateControlSet("worldmap_tooltip", "MAP_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, 0);
		local mapNameFont = MAPNAME_FONT_CHECK(drawCls.QuestLevel)

		local ratestr = ""
		if 0 ~= MAP_USE_FOG(drawCls.ClassName) and session.GetMapFogRevealRate(drawCls.ClassName) >= 100 then
			ratestr = " {img minimap_complete 24 24}"
		end

		local mapnameCtrl = ctrlSet:GetChild("mapname");
		mapnameCtrl:SetTextByKey("text", mapNameFont..drawCls.Name..ratestr);
		
		local drawMapName = drawCls.ClassName;
		local pic = GET_CHILD(ctrlSet, "map", "ui::CPicture");
		local isValid = ui.IsImageExist(drawMapName .. "_fog");
		if isValid == false then
			world.PreloadMinimap(drawMapName);
		end
		pic:SetImage(drawMapName .. "_fog");
		
		local worldMapWidth = ui.GetFrame("worldmap"):GetWidth()
		local worldMapHeight = ui.GetFrame("worldmap"):GetHeight()

		local iconGroup = ctrlSet:CreateControl("groupbox", "MapIconGroup", 0, 0, frame:GetWidth(), frame:GetHeight());
		iconGroup:SetSkinName("None");
		
		local nameGroup = ctrlSet:CreateControl("groupbox", "RegionNameGroup", 0, 0, frame:GetWidth(), frame:GetHeight());
		nameGroup:SetSkinName("None");

		local mapWidth = pic:GetWidth();
		local mapHeight = pic:GetHeight();

		local offsetX = 450;
		local offsetY = 210;

		-- 여기서 npc 세팅해줌
		if argNum < 0 then
			MAKE_CONTENTS_ICON(iconGroup, drawMapName, indunCls, mapWidth, mapHeight, offsetX, offsetY)
		else
			MAKE_INDUN_ICON(iconGroup, drawMapName, indunCls, mapWidth, mapHeight, offsetX, offsetY)
		end
		pic:EnableCopyOtherImage(nil);
		
		for i = 0, iconGroup:GetChildCount()-1 do
			local child = iconGroup:GetChildByIndex(i);
			
			child:Move( -1*worldMapWidth*(23/100), 0);
			child:Move( 0, -1*mapHeight*(40/100));
		end
		
		for i = 0, nameGroup:GetChildCount()-1 do
			local child = nameGroup:GetChildByIndex(i);	
			
			child:Move( -1*worldMapWidth*(23/100), 0);
			child:Move( 0, -1*mapHeight*(40/100));
		end

		ctrlSet:GetChild("monlv"):SetVisible(0)
	end
	GBOX_AUTO_ALIGN_HORZ(frame, 10, 5, 0, true, true, 512, true);	
end