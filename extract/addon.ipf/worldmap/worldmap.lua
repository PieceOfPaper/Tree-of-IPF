
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
	if cy < 0 then
		cy = 0;
	end
	if cy > maxY then
		cy = maxY;
	end

	local minX = frame:GetUserIValue("MIN_X");
	if cx > 0 then
		cx = 0;
	end

	if cx < minX then
		cx = minX;
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
	pic:Resize(size.x, size.y);
	local gbox = pic:CreateOrGetControl("groupbox", "GBOX_".. curMode, 0, 0, size.x, size.y);
	gbox:SetSkinName("None");
	gbox:Resize(size.x, size.y);
	gbox:EnableHitTest(1);
	gbox = AUTO_CAST(gbox);
	gbox:EnableHittestGroupBox(false);	

	local frameHeight = frame:GetHeight();
	local picHeight = pic:GetHeight();
	local maxY = picHeight  - frameHeight;
	frame:SetUserValue("MAX_Y", maxY);

	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");

	cx, cy = CLAMP_WORLDMAP_POS(frame, cx, cy);
	
	WORLDMAP_SETOFFSET(frame, cx, cy);

end

function OPEN_WORLDMAP(frame)

	frame:SetUserValue("Mode", "WorldMap");
	_OPEN_WORLDMAP(frame);

end

function _OPEN_WORLDMAP(frame)

	WORLDMAP_SIZE_UPDATE(frame);
	frame:Invalidate();
	
	local pic = frame:GetChild("pic");
	local frameHeight = frame:GetHeight();
	local picHeight = pic:GetHeight();
	local maxY = picHeight  - frameHeight;
	frame:SetUserValue("MAX_Y", maxY);

	local frameWidth = frame:GetWidth();
	local picWidth = pic:GetWidth();

	local minX = picWidth - frameWidth;
 	frame:SetUserValue("MIN_X", -minX);

	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");

	cx, cy = CLAMP_WORLDMAP_POS(frame, cx, cy);	

	WORLDMAP_SETOFFSET(frame, cx, cy);
	
	CREATE_ALL_ZONE_TEXT(frame);

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

	if changeDirection == true or ui.GetImage("worldmap_" .. currentDirection .. "_current") == nil then
		makeWorldMapImage = true;
	end

	WORLDMAP_UPDATE_PICSIZE(frame, currentDirection);
	
	local pic = GET_CHILD(frame, "pic" ,"ui::CPicture");
	
	local picHeight = pic:GetHeight();
	local frameHeight = frame:GetHeight();
	local bottomY = picHeight;
	
	local startX = - 80;
	local startY = bottomY - 30;
	local spaceX = 130.5;
	local spaceY = 130.5;

	local mapName = session.GetMapName();
	
	ui.ClearBrush();
	
	local curMode = frame:GetUserValue("Mode");
	local imgName = "worldmap_" .. currentDirection .. "_bg";
	local parentGBox = pic:GetChild("GBOX_".. curMode);
	DESTROY_CHILD_BYNAME(parentGBox, "ZONE_GBOX_");

	CREATE_ALL_WORLDMAP_CONTROLS(frame, parentGBox, makeWorldMapImage, mapName, currentDirection, spaceX, startX, spaceY, startY);
						--  createControlFunc(parentGBox, nowMapIES, mapCls, questPossible, nowMapWorldPos, gBoxName, x, spaceX, startX, y, spaceY, startY);

	if makeWorldMapImage == true then
		ui.CreateCloneImageSkin("worldmap_" .. currentDirection .. "_fog", "worldmap_" .. currentDirection .. "_current");
		ui.DrawBrushes("worldmap_" .. currentDirection .. "_current", "worldmap_" .. currentDirection .. "_bg")
	end

	pic:SetImage("worldmap_" .. currentDirection .. "_current");

end

function CREATE_ALL_WORLDMAP_CONTROLS(frame, parentGBox, makeWorldMapImage, mapName, currentDirection, spaceX, startX, spaceY, startY)

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
				
					if parentGBox:GetChild(gBoxName) == nil then
				    
						CREATE_WORLDMAP_MAP_CONTROLS(parentGBox, makeWorldMapImage, nowMapIES, mapCls, questPossible, nowMapWorldPos, gBoxName, x, spaceX, startX, y, spaceY, startY);

					end
				end
			end
		end
	end


end

function CREATE_WORLDMAP_MAP_CONTROLS(parentGBox, makeWorldMapImage, nowMapIES, mapCls, questPossible, nowMapWorldPos, gBoxName, x, spaceX, startX, y, spaceY, startY)

	local picX = startX + x * spaceX;
	local picY = startY - y * spaceY;
	local gbox = parentGBox:CreateOrGetControl("groupbox", gBoxName, picX, picY, 130, 120)
	gbox:SetEventScript(ui.MOUSEWHEEL, "WORLDMAP_MOUSEWHEEL");
	gbox:SetSkinName("None");
	gbox:ShowWindow(1);
	local ctrlSet = gbox:CreateControlSet('worldmap_zone', "ZONE_CTRL_" .. mapCls.ClassID, ui.LEFT, ui.TOP, 0, 0, 0, 0);
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
					
	if mapLv == nil or mapLv == 'None' or mapLv == '' or mapLv == 0 then
		mapLv = ''
	else
		mapLv = '{nl}LV : '..mapLv
	end
	if mainName ~= "None" then
		text:SetTextByKey("value", warpGoddessIcon..questPossibleIcon..mainName..mapLv..'{/}');
	else
		if mapName ~= mapCls.ClassName and nowMapWorldPos[1] == x and nowMapWorldPos[2] == y then
			local nowmapLv = nowMapIES.QuestLevel
			if nowmapLv == nil or nowmapLv == 'None' or nowmapLv == '' or nowmapLv == 0 then
        		nowmapLv = ''
        	else
        		nowmapLv = '{nl}LV : '..nowmapLv
        	end
			text:SetTextByKey("value", warpGoddessIcon..questPossibleIcon..mapCls.Name..mapLv..'{nl}'..warpGoddessIcon_now..questPossibleIcon..'{@st57}'..nowMapIES.Name..nowmapLv..'{/}'.."{nl}"..GET_STAR_TXT(20,mapCls.MapRank))
		else
    		text:SetTextByKey("value", warpGoddessIcon..questPossibleIcon..mapCls.Name..mapLv.."{nl}"..GET_STAR_TXT(20,mapCls.MapRank));						
    	end
	end
					
	ctrlSet:SetEventScript(ui.LBUTTONDOWN, "WORLDMAP_LBTNDOWN");
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
					
			local memberctrlSet = ctrlSet:CreateControlSet('worldmap_partymember_iconset', "WMAP_PMINFO_" .. partyMemberName, 0, suby );
		
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
		local addSpace = 40;
		ui.AddBrushArea(picX + ctrlSet:GetWidth() / 2, picY + ctrlSet:GetHeight() / 2, ctrlSet:GetWidth() + addSpace);
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

function WORLDMAP_LBTNDOWN(parent, ctrl)
		
	local frame = parent:GetTopParentFrame();
	local pic = frame:GetChild("pic");
	local x, y = GET_MOUSE_POS();
	pic:SetUserValue("MOUSE_X", x);
	pic:SetUserValue("MOUSE_Y", y);
	
	pic:RunUpdateScript("WORLDMAP_PROCESS_MOUSE");

end

function WORLDMAP_PROCESS_MOUSE(ctrl)

	if mouse.IsLBtnPressed() == 0 then
		return;
	end

	local mx, my = GET_MOUSE_POS();
	local x = ctrl:GetUserIValue("MOUSE_X");
	local y = ctrl:GetUserIValue("MOUSE_Y");
	local dx = mx - x;
	local dy = my - y;

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
	CREATE_ALL_ZONE_TEXT(frame, true);

end


