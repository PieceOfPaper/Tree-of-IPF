-- floatinglocationmap.lua

function FLOATINGLOCATIONMAP_ON_INIT(addon, frame)
    SIZE_RATIO_FLOATINGLOCATIONMAP_INFO = 1; -- 확대 배율 기본 적용
end

function OPEN_FLOATINGLOCATIONMAP_INFO(mapName)
	local frame = ui.GetFrame('floatinglocationmap');
	
	local mapCls = GetClass("Map", mapName)
	if mapCls == nil then
		return
	end

	local worldMapPic = FLOATINGLOCATIONMAP_SET_PICTURE(frame);
	local mustShowMapCtrl = FLOATINGLOCATIONMAP_RESET_MAP_CTRL(frame, worldMapPic, tonumber(mapCls.ClassID));
	FLOATINGLOCATIONMAP_SET_POS(frame, worldMapPic, mustShowMapCtrl, tonumber(mapCls.ClassID));
    frame:ShowWindow(1);
end

function FLOATINGLOCATIONMAP_SET_PICTURE(frame)
	local worldMapPic = GET_CHILD_RECURSIVELY(frame, 'worldMapPic');
    local imageName = worldMapPic:GetImageName();
    local size = ui.GetSkinImageSize(imageName); 
    worldMapPic:Resize(size.x * SIZE_RATIO_FLOATINGLOCATIONMAP_INFO, size.y * SIZE_RATIO_FLOATINGLOCATIONMAP_INFO);
    return worldMapPic;
end

function FLOATINGLOCATIONMAP_RESET_MAP_CTRL(frame, worldMapPic, mustShowID)	
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
				local gBoxName = FLOATINGLOCATIONMAP_GET_MAP_INFO_CTRL_NAME(x, y);
				local ctrl = worldMapPic:GetChild(gBoxName);							
				if ctrl == nil then
                    ctrl = FLOATINGLOCATIONMAP_CREATE_MAP_CTRL(worldMapPic, mapCls, x, y, true);                    
                else
                	local ctrlSet = nil;
                	local childCnt = ctrl:GetChildCount();
                	for j = 0, childCnt - 1 do
                		local child = ctrl:GetChildByIndex(j);
                		if string.find(child:GetName(), 'ZONE_CTRL_') ~= nil then
                			ctrlSet = child;
                		end
                	end
				end
				mustShowCtrl = ctrl;
            elseif accObj['HadVisited_' .. mapCls.ClassID] == 1 then
                local gBoxName = FLOATINGLOCATIONMAP_GET_MAP_INFO_CTRL_NAME(x, y);
                local ctrl = worldMapPic:GetChild(gBoxName);
                if ctrl == nil then
					ctrl = FLOATINGLOCATIONMAP_CREATE_MAP_CTRL(worldMapPic, mapCls, x, y, false);                    
				end
				if mustShowCtrl == nil then
                    mustShowCtrl = ctrl;
                end
			end
        end
    end    
    return mustShowCtrl;
end

function FLOATINGLOCATIONMAP_GET_MAP_INFO_CTRL_NAME(x, y)
    return "ZONE_GBOX_" .. x .. "_" .. y;
end

function FLOATINGLOCATIONMAP_CREATE_MAP_CTRL(parentGBox, mapCls, x, y, needTooltip)
    local startX = -120;
	local startY = parentGBox:GetHeight() - 40;	
	local spaceX = 65.25;
	local spaceY = 65.25;

	local picX = math.max(0, startX + x * spaceX * SIZE_RATIO_INDUN_MAP_INFO);
	local picY = startY - y * spaceY * SIZE_RATIO_INDUN_MAP_INFO;
    local gBoxName = FLOATINGLOCATIONMAP_GET_MAP_INFO_CTRL_NAME(x, y);
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


function FLOATINGLOCATIONMAP_SET_POS(frame, pic, mustShowMapCtrl, selectedMapID)
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

function FLOATINGLOCATIONMAP_WORLDMAP_LBTN_DOWN(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local x, y = GET_LOCAL_MOUSE_POS(topFrame);
    FLOATINGLOCATIONMAP_WORLDMAP_SET_DOWN_POS(topFrame, x, y);
    topFrame:RunUpdateScript("FLOATINGLOCATIONMAP_WORLDMAP_DRAG_PROCESS", 0.01, 10, 0, 1);
end

function FLOATINGLOCATIONMAP_WORLDMAP_SET_DOWN_POS(frame, x, y)
    frame:SetUserValue('WORLDMAP_DOWN_X', x);
    frame:SetUserValue('WORLDMAP_DOWN_Y', y);
end

function FLOATINGLOCATIONMAP_WORLDMAP_DRAG_PROCESS(frame, totalTime)
    local THRESHOLD_RATIO = 0.05;

    local worldMapPic = GET_CHILD_RECURSIVELY(frame, 'worldMapPic');
    local preX = frame:GetUserIValue('WORLDMAP_DOWN_X');
    local preY = frame:GetUserIValue('WORLDMAP_DOWN_Y');
    local x, y = GET_LOCAL_MOUSE_POS(frame);
    local deltaX = THRESHOLD_RATIO * (x - preX);
    local deltaY = THRESHOLD_RATIO * (y - preY);
    local offsetX, offsetY = CLAMP_OFFSET_BY_FRAME_SIZE(worldMapPic:GetTopParentFrame(), worldMapPic, worldMapPic:GetX() + deltaX, worldMapPic:GetY() + deltaY);
    worldMapPic:SetOffset(offsetX, offsetY);

    FLOATINGLOCATIONMAP_CHECK_CURSOR(frame, x, y);
    return 1;
end

function FLOATINGLOCATIONMAP_WORLDMAP_LBTN_UP(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    FLOATINGLOCATIONMAP_WORLDMAP_SET_DOWN_POS(topFrame, 0, 0);
    topFrame:StopUpdateScript('FLOATINGLOCATIONMAP_WORLDMAP_DRAG_PROCESS');
end

function FLOATINGLOCATIONMAP_CHECK_CURSOR(frame, x, y)
    local THRESHOLD_PIXEL = 5;
    if x <= THRESHOLD_PIXEL or x > frame:GetWidth() - THRESHOLD_PIXEL or y < THRESHOLD_PIXEL or y > frame:GetHeight() - THRESHOLD_PIXEL then
        local topFrame = frame:GetTopParentFrame();
        topFrame:StopUpdateScript('FLOATINGLOCATIONMAP_WORLDMAP_DRAG_PROCESS');        
    end
end

function CLAMP_OFFSET_BY_FRAME_SIZE(topFrame, pic, x, y)
    x = math.min(0, x);
    x = math.max(x, topFrame:GetWidth() - pic:GetWidth());
    y = math.min(0, y);
    y = math.max(y, topFrame:GetHeight() - pic:GetHeight());
    return x, y;
end

function FLOATINGLOCATIONMAP_UI_CLOSE(frame)
	frame = ui.GetFrame('floatinglocationmap');
	frame:StopUpdateScript('FLOATINGLOCATIONMAP_WORLDMAP_DRAG_PROCESS');
	ui.CloseFrame('floatinglocationmap');
end

