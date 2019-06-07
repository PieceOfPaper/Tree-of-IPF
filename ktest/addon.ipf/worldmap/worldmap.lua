first_click_x = nil  -- 월드맵에서 드래그를 위해서 클릭할 때, 최초 좌표를 기억한다.
first_click_y = nil


function WORLDMAP_ON_INIT(addon, frame)
    addon:RegisterMsg('UPDATE_OTHER_GUILD_EMBLEM', 'ON_UPDATE_OTHER_GUILD_EMBLEM');
    addon:RegisterMsg('COLONY_OCCUPATION_INFO_UPDATE', 'UPDATE_WORLDMAP_CONTROLS');
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

	local curMode = 'WorldMap';

	local imgName = "worldmap_" .. currentDirection .. "_bg";
	local pic = GET_CHILD_RECURSIVELY(frame, "pic");
	local size = ui.GetSkinImageSize(imgName);

	local curSize = config.GetConfigInt("WORLDMAP_SCALE", 6);
	local sizeRatio = 1 + curSize * 0.25;
	local t_scale = GET_CHILD_RECURSIVELY(frame, "t_scale");
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
	if frame:GetUserValue('Type') ~= 'None' or frame:GetUserValue('SCROLL_WARP') ~= 'None' then
		local nowZoneName = GetZoneName(pc);
		LOCATE_WORLDMAP_POS(frame, nowZoneName);
		frame:SetUserValue("Mode", "Warp");
	else
		frame:SetUserValue("Mode", "WorldMap");
	end
	--frame:SetUserValue("isShowAllMap", 0)
	_OPEN_WORLDMAP(frame);
end

function CLOSE_WORLDMAP(frame)
	frame:SetUserValue('Type', 'None');
	frame:SetUserValue('SCROLL_WARP', 'None');
	UNREGISTERR_LASTUIOPEN_POS(frame);
	mouse.ChangeCursorImg("BASIC", 0);
	ui.EnableToolTip(1);
	
end

function WORLDMAP_UPDATE_CLAMP_MINMAX(frame)

	local pic = GET_CHILD_RECURSIVELY(frame, "pic");
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
	
	local pic = GET_CHILD_RECURSIVELY(frame, "pic");

	UPDATE_WORLDMAP_CONTROLS(frame);
	
	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");

	cx, cy = CLAMP_WORLDMAP_POS(frame, cx, cy);	

	WORLDMAP_SETOFFSET(frame, cx, cy);
	
end

function UPDATE_WORLDMAP_CONTROLS(frame, changeDirection)
	CREATE_ALL_ZONE_TEXT(frame, changeDirection);
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

	if changeDirection == true or ui.IsImageExist("worldmap_" .. currentDirection .. "_current") == false then
		makeWorldMapImage = true;
	end

	WORLDMAP_UPDATE_PICSIZE(frame, currentDirection);
	
	local pic = GET_CHILD_RECURSIVELY(frame, "pic" ,"ui::CPicture");
	
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
	
	local worldMapBox = GET_CHILD_RECURSIVELY(pic, "GBOX_WorldMap");
	DESTROY_CHILD_BYNAME(worldMapBox, "ZONE_GBOX_");
	DESTROY_CHILD_BYNAME(pic, "ZONE_GBOX_");
	DESTROY_CHILD_BYNAME(pic, "_ZONE_GBOX_");

	if frame:GetUserValue('Mode') == 'Warp' then
		CREATE_ALL_WARP_CONTROLS(frame, warpBox, makeWorldMapImage, changeDirection, mapName, currentDirection, spaceX, startX, spaceY, startY, pictureStartY);
	else
		CREATE_ALL_WORLDMAP_CONTROLS(frame, worldMapBox, makeWorldMapImage, changeDirection, mapName, currentDirection, spaceX, startX, spaceY, startY, pictureStartY);
	end

	if makeWorldMapImage == true then
		ui.CreateCloneImageSkin("worldmap_" .. currentDirection .. "_fog", "worldmap_" .. currentDirection .. "_current");
		ui.DrawBrushes("worldmap_" .. currentDirection .. "_current", "worldmap_" .. currentDirection .. "_bg")
	end

	pic:SetImage("worldmap_" .. currentDirection .. "_current");

end

function GET_WORLDMAP_GROUPBOX(frame)
	if frame:GetUserValue('Mode') == "WorldMap" then
		local curMode = frame:GetUserValue("Mode");
		local pic = GET_CHILD_RECURSIVELY(frame, "pic" ,"ui::CPicture");
		return GET_CHILD_RECURSIVELY(pic, "GBOX_".. curMode);
	end

	return GET_CHILD_RECURSIVELY(frame, "pic" ,"ui::CPicture");
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

	local open_map = GET_CHILD_RECURSIVELY(frame, "open_map")
	open_map:ShowWindow(1)
	local showAllWorldMapCheckBox = GET_CHILD_RECURSIVELY(frame, "showAllWorldMap")
	showAllWorldMapCheckBox:ShowWindow(0)
	for i=0, cnt-1 do
		local mapCls = GetClassByIndexFromList(clsList, i);
		if mapCls.WorldMap ~= "None" then
			

			local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);
			
			if currentDirection == dir then
				local accObj = GetMyAccountObj();
				if accObj['HadVisited_' .. mapCls.ClassID] == 1 or FindCmdLine("-WORLDMAP") > 0 then
					local gBoxName = "ZONE_GBOX_" .. x .. "_" .. y;
					
					if changeDirection ~= true or GET_CHILD_RECURSIVELY(parentGbox, gBoxName) == nil then
						if index == '0' or index == '1' then
							CREATE_WORLDMAP_MAP_CONTROLS(parentGBox, makeWorldMapImage, changeDirection, nowMapIES, mapCls, questPossible, nowMapWorldPos, gBoxName, x, spaceX, startX, y, spaceY, startY, pictureStartY);
						end
					end
				end
			end
		end
	end


end

function CREATE_ALL_WARP_CONTROLS(frame, parentGBox, makeWorldMapImage, changeDirection, mapName, currentDirection, spaceX, startX, spaceY, startY, pictureStartY)	    
    local result = GET_INTE_WARP_LIST();
	if result == nil then
		return;
	end

    local predraw_class_name = nil

	local clsList, cnt = GetClassList('Map');	
	if cnt == 0 then
		return;
	end
	
	local pic = GET_CHILD_RECURSIVELY(frame, "pic" ,"ui::CPicture");
	local type = frame:GetUserValue('Type');
	local pc = GetMyPCObject();
	local nowZoneName = GetZoneName(pc);
	local curSize = config.GetConfigInt("WORLDMAP_SCALE", 6);
	local sizeRatio = 1 + curSize * 0.25;
	
	local etc = GetMyEtcObject();
	local lobbyMapCls = GetClassByType("Map", etc.ItemWarpMapID)

	local open_map = GET_CHILD_RECURSIVELY(frame, "open_map")
	open_map:ShowWindow(0)
	local showAllWorldMap = frame:GetUserIValue("isShowAllMap")
	local showAllWorldMapCheckBox = GET_CHILD_RECURSIVELY(frame, "showAllWorldMap")
	showAllWorldMapCheckBox:SetCheck(showAllWorldMap)
	showAllWorldMapCheckBox:ShowWindow(1)
	if showAllWorldMap == 1 then
		for i=0, cnt-1 do
			local mapCls = GetClassByIndexFromList(clsList, i);
			if mapCls.WorldMap ~= "None" and mapCls.WorldMapPreOpen == "YES" then
		

				local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);
			
				if currentDirection == dir then
					local accObj = GetMyAccountObj();
					local gBoxName = "_ZONE_GBOX_" .. x .. "_" .. y;
					local picX = startX + x * spaceX * sizeRatio + 60;
            		local picY = startY - y * spaceY * sizeRatio + 30;
					if picX < 0 then
						picX = 0
					end

					local set = pic:GetControlSet('warpAreaName', gBoxName);
					if set == nil then
						set = pic:CreateControlSet('warpAreaName', gBoxName, picX, picY);
						set = tolua.cast(set, "ui::CControlSet");
						set:SetEnableSelect(1);

						local nameRichText = GET_CHILD_RECURSIVELY(set, "areaname", "ui::CRichText");
						nameRichText:SetTextByKey("mapname",mapCls.Name);
					end
				end
			end
		end
	end

	-- draw lobby map
	if lobbyMapCls ~= nil and lobbyMapCls.WorldMap ~= "None" then        
        local x, y, dir, index = GET_WORLDMAP_POSITION(lobbyMapCls.WorldMap);
        if currentDirection == dir then
            local warpInfo = WARP_INFO_ZONE(lobbyMapCls.ClassName)
            local picX = startX + x * spaceX * sizeRatio + 60;
            local picY = startY - y * spaceY * sizeRatio + 30;
            local searchRate = session.GetMapFogSearchRate(lobbyMapCls.ClassName);
            local gBoxName = "ZONE_GBOX_" .. x .. "_" .. y;
            local gbox = nil;
            if changeDirection ~= true then
                gbox = GET_CHILD_RECURSIVELY(pic, gBoxName);
                if gbox ~= nil then
                    gbox:SetOffset(picX, picY);
                end
            end

            if gbox == nil then
                gbox = pic:CreateOrGetControl("groupbox", gBoxName, picX, picY, 130, 24)
                gbox:SetEventScript(ui.MOUSEWHEEL, "WORLDMAP_MOUSEWHEEL");
                gbox:SetEventScript(ui.LBUTTONDOWN, "WORLDMAP_LBTNDOWN");
                gbox:SetEventScript(ui.LBUTTONUP, "WORLDMAP_LBTNUP");
                gbox:SetSkinName("downbox");
                gbox = tolua.cast(gbox, "ui::CGroupBox");
                gbox:EnableScrollBar(0)
                gbox:ShowWindow(1);
               
            end            
            
            local setName = "WARP_CTRLSET_0"
            local set = gbox:CreateOrGetControlSet('warpAreaName', setName, 0, 0);
            set = tolua.cast(set, "ui::CControlSet");
            set:SetEventScript(ui.MOUSEWHEEL, "WORLDMAP_MOUSEWHEEL");
            set:SetEnableSelect(1);
            set:SetOverSound('button_over');
            set:SetClickSound('button_click_stats');
            local nameRechText = GET_CHILD_RECURSIVELY(set, "areaname", "ui::CRichText");
            nameRechText:SetTextByKey("mapname","{#ffff00}"..ScpArgMsg('Auto_(woPeuJuMunSeo)'));
            set:SetEventScript(ui.LBUTTONUP, 'WARP_TO_AREA')
            if warpInfo ~= nil then
                set:SetEventScriptArgString(ui.LBUTTONUP, warpInfo.ClassName);
            else
                set:SetEventScriptArgString(ui.LBUTTONUP, lobbyMapCls.ClassName);
            end

            set:SetEventScriptArgNumber(ui.LBUTTONUP, 1);            

            local warpcost;
            warpcost = 0
            			
            set:SetTooltipType('warpminimap');
            if warpInfo ~= nil then
                set:SetTooltipStrArg(warpInfo.ClassName);   
                predraw_class_name = lobbyMapCls.ClassName                
            else
                set:SetTooltipStrArg(lobbyMapCls.ClassName);                
            end
            set:SetTooltipNumArg(warpcost)
            if nameRechText:GetWidth() > 130 then
                nameRechText:SetTextFixWidth(1);
                nameRechText:Resize(125 , set:GetHeight())
            end
            if makeWorldMapImage == true then
                
                local brushX = startX + x * spaceX;
                local brushY = pictureStartY - y * spaceY;
                ui.AddBrushArea(brushX + set:GetWidth() / 2, brushY + set:GetHeight() / 2, set:GetWidth() + WORLDMAP_ADD_SPACE);
            end
        end
    end

	-- draw text
	if type == 'Dievdirbys' or type == 'Normal' then        
		for index = 1, #result do
			local info = result[index];
            if predraw_class_name ~= info.Zone then
                local mapCls = GetClass("Map", info.Zone);
			    local warpcost = 0;
			    if mapCls.WorldMap ~= "None" then
				    local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);
				
				    if currentDirection == dir then
					    local picX = startX + x * spaceX * sizeRatio + 60;
					    local picY = startY - y * spaceY * sizeRatio + 30;
					    local searchRate = session.GetMapFogSearchRate(mapCls.ClassName);
					    local gBoxName = "ZONE_GBOX_" .. x .. "_" .. y;

					    if (warpcost < 1000000) then
						    local brushX = startX + x * spaceX;
						    local brushY = pictureStartY - y * spaceY;
						    if GET_CHILD_RECURSIVELY(pic, gBoxName) == nil then 
							    local gbox = pic:CreateOrGetControl("groupbox", gBoxName, picX, picY, 130, 24)
							    gbox:SetSkinName("downbox");
							    gbox:ShowWindow(1);
						    end
							
						    ON_INTE_WARP_SUB(frame, pic, index, gBoxName, nowZoneName, warpcost, false, makeWorldMapImage, mapCls, info, picX, picY, brushX, brushY, 1);

						    local gbox = GET_CHILD_RECURSIVELY(pic, gBoxName)
						    GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true, true);
					    end				
				    end
			    end
            end			
		end
	else        
		for index = 1, #result do
			local info = result[index];
            if predraw_class_name ~= info.Zone then
                local mapCls = GetClass("Map", info.Zone);
			    local warpcost = geMapTable.CalcWarpCostBind(AMMEND_NOW_ZONE_NAME(nowZoneName),info.Zone);            
			    if nowZoneName == 'infinite_map' then
				    warpcost = 0;
			    end
			    if mapCls.WorldMap ~= "None" then
				    local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);
				    if currentDirection == dir then
					    local picX = startX + x * spaceX * sizeRatio + 60;
					    local picY = startY - y * spaceY * sizeRatio + 30;
					    local searchRate = session.GetMapFogSearchRate(mapCls.ClassName);
					    local gBoxName = "ZONE_GBOX_" .. x .. "_" .. y;

	                    local zoneGbox = GET_CHILD_RECURSIVELY(pic, "_" .. gBoxName)
	                    if zoneGbox ~= nil then
        	        	    zoneGbox:ShowWindow(0)
            	        end

					    if (warpcost < 1000000) then
						    local calcOnlyPosition = false;
						    if changeDirection ~= true then
							    gbox = GET_CHILD_RECURSIVELY(pic, gBoxName);
							    if gbox ~= nil then
								    gbox:SetOffset(picX, picY);
								    calcOnlyPosition = true;
							    end
						    end						
						    local brushX = startX + x * spaceX;
						    local brushY = pictureStartY - y * spaceY;
						    if GET_CHILD_RECURSIVELY(pic, gBoxName) == nil then 
							    local gbox = pic:CreateOrGetControl("groupbox", gBoxName, picX, picY, 130, 24)
							    gbox:SetSkinName("downbox");
							    gbox:ShowWindow(1);
						    end
                            
                            ON_INTE_WARP_SUB(frame, pic, index, gBoxName, nowZoneName, warpcost, calcOnlyPosition, makeWorldMapImage, mapCls, info, picX, picY, brushX, brushY, 1)                        

                            local gbox = GET_CHILD_RECURSIVELY(pic, gBoxName)
						    GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true, true);
					    end				
				    end
			    end
            end			
		end
	end

	if makeWorldMapImage == true then
		ui.CreateCloneImageSkin("worldmap_" .. currentDirection .."_fog", "worldmap_" .. currentDirection .."_current");
		ui.DrawBrushes("worldmap_" .. currentDirection .."_current", "worldmap_" .. currentDirection .."_bg")
	end
end

function CREATE_WORLDMAP_MAP_CONTROLS(parentGBox, makeWorldMapImage, changeDirection, nowMapIES, mapCls, questPossible, nowMapWorldPos, gBoxName, x, spaceX, startX, y, spaceY, startY, pictureStartY)
	local curSize = config.GetConfigInt("WORLDMAP_SCALE", 6);
	local sizeRatio = 1 + curSize * 0.25;

	local picX = startX + x * spaceX * sizeRatio;
	local picY = startY - y * spaceY * sizeRatio;

	if picX < 0 then
		picX = 0
	end

	if changeDirection == false then
		local gbox = GET_CHILD_RECURSIVELY(parentGBox, gBoxName);
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
    
    local totalCtrlHeight = 0;
    local maxCtrlWidth = 0;

	-- colony occupation info    
	
	if session.world.IsIntegrateServer() == false then
		if IS_COLONY_SPOT(mapCls.ClassName) == true then
			local check_word = "GuildColony_"
			local colonyMapCls = GetClassByStrProp("Map", "ClassName", check_word..mapCls.ClassName)
			if colonyMapCls ~= nil then
				local topFrame = ctrlSet:GetTopParentFrame();
				local COLONY_IMG_SIZE = tonumber(topFrame:GetUserConfig('COLONY_IMG_SIZE'));
		
				local colonyText = '';
				local occupyTextTooltip = '';
				local occupyText = ctrlSet:CreateControl('richtext', 'occupyText', 0, 0, 30, 30);        
				local emblemSet = nil;
				SET_WORLDMAP_RICHTEXT(occupyText, 1);

 				local colonyLeague = GetClassByStrProp("guild_colony", "ClassName", check_word..mapCls.ClassName);
                if session.colonywar.GetProgressState() == true then -- 콜로니전 중일 때
					local COLONY_PROGRESS_IMG = topFrame:GetUserConfig('COLONY_PROGRESS_IMG');
					colonyText = string.format('{img %s %d %d}', COLONY_PROGRESS_IMG, COLONY_IMG_SIZE, COLONY_IMG_SIZE);
					occupyTextTooltip = ClMsg('ProgressColonyWar');
				else -- 콜로니전 진행 중이 아닐 때
                    local COLONY_NOT_OCCUPIED_IMG = nil
                    if colonyLeague ~= nil then
                        if colonyLeague.ColonyLeague == 1 then
                            COLONY_NOT_OCCUPIED_IMG = topFrame:GetUserConfig('COLONY_LEAGUE1_NOT_OCCUPIED_IMG');
                        elseif colonyLeague.ColonyLeague == 2 then
                            COLONY_NOT_OCCUPIED_IMG = topFrame:GetUserConfig('COLONY_LEAGUE2_NOT_OCCUPIED_IMG');
                        end
                    end

                    local cityMap = GetClassString('guild_colony', check_word..mapCls.ClassName, 'TaxApplyCity')
                    if cityMap ~= "None" then
                        local cityMapID = GetClassNumber('Map', cityMap, 'ClassID')
                        local taxRateInfo = session.colonytax.GetColonyTaxRate(cityMapID)
                        if taxRateInfo == nil then
                            colonyText = string.format('{img %s %d %d}', COLONY_NOT_OCCUPIED_IMG, COLONY_IMG_SIZE, COLONY_IMG_SIZE);
                            occupyTextTooltip = ClMsg('NotOccupiedSpot');
                        else
                            ctrlSet:RemoveChild('occupyText');
                            occupyText = nil;
                            local guildID = taxRateInfo:GetGuildID()
                            emblemSet = ctrlSet:CreateOrGetControlSet('guild_emblem_set', 'EMBLEM_'..guildID, 0, 0);
                            emblemSet:SetGravity(ui.CENTER_HORZ, ui.TOP);
                        
                            -- emblem pic set
                            local emblemedgePic = GET_CHILD_RECURSIVELY(emblemSet, "emblemedgePic");
							local emblemedgebgPic = GET_CHILD_RECURSIVELY(emblemSet, "emblemedgebgPic");
							if emblemedgePic ~= nil and emblemedgebgPic ~= nil then
								if colonyLeague.ColonyLeague == 1 then
									emblemedgePic:SetImage("colony_league_part1");
									emblemedgebgPic:Resize(64, 64);
									emblemedgebgPic:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);
								elseif colonyLeague.ColonyLeague == 2 then
									emblemedgePic:SetImage("colony_league_part2");
									emblemedgebgPic:Resize(64, 64);
								end
							end
							
							local emblemPic = GET_CHILD_RECURSIVELY(emblemSet, 'emblemPic');
                            local worldID = session.party.GetMyWorldIDStr();            
                            local emblemImgName = guild.GetEmblemImageName(guildID, worldID); 
                            if emblemImgName ~= 'None' then
                                emblemPic:SetFileName(emblemImgName);
								emblemSet:SetSkinName("None");
                            else            
                                local worldID = session.party.GetMyWorldIDStr();    
                                guild.ReqEmblemImage(guildID,worldID);
								emblemSet:SetSkinName("test_frame_midle");
                            end

                        	local taxGuildName = taxRateInfo:GetGuildName()
                        	local taxCityMapID = taxRateInfo:GetCityMapID();
                            local taxCityName = TryGetProp(GetClassByType("Map", taxCityMapID), "Name")
                            local taxRate = taxRateInfo:GetTaxRate();
                            if colonyLeague.ColonyLeague == 1 then
                                occupyTextTooltip = "["..ClMsg('ColonyLeague_World_map_1st').."]".."{nl}"..ClMsg('ColonyTax_Guild_World_map')..taxGuildName.."{nl}"..ClMsg('ColonyTax_City_World_map')..taxCityName.."{nl}"..ClMsg('ColonyTax_Rate_World_map')..taxRate..ClMsg('PercentSymbol')
                            elseif colonyLeague.ColonyLeague == 2 then
                                occupyTextTooltip = "["..ClMsg('ColonyLeague_World_map_2nd').."]".."{nl}"..ClMsg('ColonyTax_Guild_World_map')..taxGuildName
                            end
                        end
                    end
				end

				if occupyText ~= nil then
					occupyText:SetTextTooltip(occupyTextTooltip);
					occupyText:SetText(colonyText);
					totalCtrlHeight = totalCtrlHeight + occupyText:GetHeight();
					maxCtrlWidth = GET_MAX_WIDTH(maxCtrlWidth, occupyText:GetWidth());
				elseif emblemSet ~= nil then
					emblemSet:SetTextTooltip(occupyTextTooltip);            
					totalCtrlHeight = totalCtrlHeight + emblemSet:GetHeight();
					maxCtrlWidth = GET_MAX_WIDTH(maxCtrlWidth, emblemSet:GetWidth());
				end
			end
		end
	end
	
    -- dungeon info
	local mapType = TryGetProp(mapCls, 'MapType');
	local dungeonIcon = ''
    if mapType == 'Dungeon' then
		dungeonIcon = '{img minimap_dungeon 30 30}'
        local dungeonText = ctrlSet:CreateControl('richtext', 'dungeonText', 0, 0, 30, 30);
        SET_WORLDMAP_RICHTEXT(dungeonText);
        dungeonText:SetText(dungeonIcon);
        totalCtrlHeight = totalCtrlHeight + dungeonText:GetHeight();
        maxCtrlWidth = GET_MAX_WIDTH(maxCtrlWidth, dungeonText:GetWidth());
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
		if mapName ~= mapCls.ClassName and nowMapWorldPos[1] == x and nowMapWorldPos[2] == y then
			local nowmapLv = nowMapIES.QuestLevel
			if nowmapLv == nil or nowmapLv == 'None' or nowmapLv == '' or nowmapLv == 0 then
        		nowmapLv = ''
        	else
        		nowmapLv = '{nl}Lv.'..nowmapLv
        	end
			text:SetText(mapNameFont..mapCls.Name);
            totalCtrlHeight = totalCtrlHeight + text:GetHeight();
            maxCtrlWidth = GET_MAX_WIDTH(maxCtrlWidth, text:GetWidth());

            infoText:SetText(warpGoddessIcon..questPossibleIcon..mapNameFont..mapLv..'{/}'..mapratebadge..'{nl}'..warpGoddessIcon_now..questPossibleIcon..'{@st57}'..nowMapIES.Name..nowmapLv..'{/}');            
            totalCtrlHeight = totalCtrlHeight + infoText:GetHeight();
            maxCtrlWidth = GET_MAX_WIDTH(maxCtrlWidth, infoText:GetWidth());
		else
    		text:SetText(mapNameFont..mapCls.Name);
            totalCtrlHeight = totalCtrlHeight + text:GetHeight();
            maxCtrlWidth = GET_MAX_WIDTH(maxCtrlWidth, text:GetWidth());

            infoText:SetText(warpGoddessIcon..questPossibleIcon..mapNameFont..mapLv..'{/}'..mapratebadge);
            totalCtrlHeight = totalCtrlHeight + infoText:GetHeight();
            maxCtrlWidth = GET_MAX_WIDTH(maxCtrlWidth, infoText:GetWidth());
    	end
	end

    local starText = ctrlSet:CreateControl('richtext', 'starText', 0, 0, 30, 30);
    SET_WORLDMAP_RICHTEXT(starText);
    starText:SetText(GET_STAR_TXT(20,mapCls.MapRank));
    totalCtrlHeight = totalCtrlHeight + starText:GetHeight();
    maxCtrlWidth = GET_MAX_WIDTH(maxCtrlWidth, starText:GetWidth());
					
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
		
			local pm_namertext = GET_CHILD_RECURSIVELY(memberctrlSet,'pm_name','ui::CRichText')
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
	
    GBOX_AUTO_ALIGN(ctrlSet, 0, 0, 0, true, false);
	GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true, false); 
    
    -- 사이즈를 최대한 fit하게 해야지
    ctrlSet:Resize(maxCtrlWidth, totalCtrlHeight);
    gbox:Resize(ctrlSet:GetWidth(), ctrlSet:GetHeight());
    
    -- 위치를 보정하자, picX, picY는 200, 120 기준으로 left top 앵커 포인트
    local amendOffsetX = math.floor((200 - maxCtrlWidth) / 2);
    local amendOffsetY = math.floor((120 - totalCtrlHeight) / 2);
    gbox:SetOffset(picX + amendOffsetX, picY + amendOffsetY);

end

function SET_WORLDMAP_RICHTEXT(textCtrl, hittest)
    if hittest == nil then
        hittest = 0;
    end
    textCtrl:SetGravity(ui.CENTER_HORZ, ui.TOP);
    textCtrl = AUTO_CAST(textCtrl);
    textCtrl:EnableResizeByText(1);
    textCtrl:EnableHitTest(hittest);    
end

function GET_MAX_WIDTH(currentWidth, nextWidth)
    if currentWidth > nextWidth then
        return currentWidth;
    end
    return nextWidth;
end

function WORLDMAP_SETOFFSET(frame, x, y)

	local pic = GET_CHILD_RECURSIVELY(frame, "pic");
	local frameHeight = frame:GetHeight();
	local picHeight = pic:GetHeight();
	local startY = frameHeight - picHeight;

	pic:SetOffset(x, startY + y);

end

function WORLDMAP_MOUSEWHEEL(parent, ctrl, s, n)
	
	if keyboard.IsKeyPressed("LCTRL") == 1 then
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
	local pic = GET_CHILD_RECURSIVELY(frame, "pic");
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

	local curSize = config.GetConfigInt("WORLDMAP_SCALE", 6);
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
	local isColonyMap = session.colonywar.GetIsColonyWarMap();
	if isColonyMap == true then
        local check_word = "GuildColony_"
        local sStart, sEnd = string.find(mapName, check_word)
        if sStart ~= nil then
            local sLength = string.len(mapName)
            mapName = string.sub(mapName, sEnd+1, sLength)
        end
	end
	LOCATE_WORLDMAP_POS(parent:GetTopParentFrame(), mapName);
end

function GET_DUNGEON_LIST(below, above)
    local pc = GetMyPCObject();
    local pcLv = pc.Lv
	local maxLevel = pc.Lv + above;
	local minLevel = pc.Lv + below;

	local recommendlist = {};
	local clslist, cnt = GetClassList("Map");
				
	local accObj = GetMyAccountObj();
	for i = 0, cnt - 1 do
		local mapCls = GetClassByIndexFromList(clslist, i);
		if accObj['HadVisited_' .. mapCls.ClassID] == 1 or FindCmdLine("-WORLDMAP") > 0 then
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
		return false;
	end
	if mapCls.WorldMap == "None" then
		return false;
	end

	local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);	
	local gBoxName = "ZONE_GBOX_" .. x .. "_" .. y;

	local childCtrl = GET_CHILD_RECURSIVELY(gBox, gBoxName);

	if childCtrl == nil then
		return false;
	end

	local x = childCtrl:GetX();
	local y = childCtrl:GetY();

	local cx = config.GetConfigInt("WORLDMAP_X");
	local cy = config.GetConfigInt("WORLDMAP_Y");
	local pic = GET_CHILD_RECURSIVELY(frame, "pic");

	local curSize = config.GetConfigInt("WORLDMAP_SCALE", 6);
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
	local animpic = GET_CHILD_RECURSIVELY(emphasize, "animpic");
	animpic:ShowWindow(1);
	animpic:PlayAnimation();

	return true;
end

function WORLDMAP_SEARCH_BY_NAME(frame, ctrl)

	local inputSearch = GET_CHILD_RECURSIVELY(frame, 'input_search')
	local searchText = inputSearch:GetText()
	local oldSearchText = frame:GetUserValue('SEARCH_TEXT')
	local oldSearchIdx = frame:GetUserValue('SEARCH_IDX')

	if searchText == "" then
		return
	end

	local accObj = GetMyAccountObj();
	
	-- search map
	local mapList, cnt = GetClassList('Map')
	if accObj == nil or mapList == nil or cnt < 1 then -- valid check
		return
	end
	
    local targetMap = {}
	local targetCnt = 0
	for i=0, cnt-1 do
		local mapCls = GetClassByIndexFromList(mapList, i);
		if mapCls ~= nil and mapCls.WorldMap ~= "None" and (accObj['HadVisited_' .. mapCls.ClassID] == 1 or FindCmdLine("-WORLDMAP") > 0)then
			local tempname = string.lower(dictionary.ReplaceDicIDInCompStr(mapCls.Name));		
			local tempinputtext = string.lower(searchText)
			if tempinputtext == "" or true == ui.FindWithChosung(tempinputtext, tempname) then
				targetMap[targetCnt] = mapCls.ClassName
				targetCnt = targetCnt + 1
			end
		end
	end
	
	-- search npc
	local npcStateMaps = GetNPCStateMaps();
	for i = 1, #npcStateMaps do
		local mapName = npcStateMaps[i];
		local mapCls = GetClass("Map", mapName);
		if mapCls ~= nil then
			local npcGenTypes = GetNPCStateGenTypes(mapName);
			for j = 1, #npcGenTypes do
				local genType = npcGenTypes[j];

				local genCls = GetGenTypeClass(mapName, genType);			
				if genCls ~= nil then
					if TryGetProp(genCls, "ClassType") ~= "Warp_arrow" then -- 워프 제외한 npc
						local name = GET_GENCLS_NAME(genCls);
						local tempname = string.lower(dictionary.ReplaceDicIDInCompStr(name));		
						local tempinputtext = string.lower(searchText);
						if string.find(tempname, tempinputtext) ~= nil and IS_ITEM_IN_LIST(targetMap, mapCls.ClassName) == false then
							targetMap[targetCnt] = mapCls.ClassName;
							targetCnt = targetCnt + 1;
						end
					end
				end;
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
	local ret = LOCATE_WORLDMAP_POS(frame, targetMap[showIdx]);
	if ret == false then
		frame:SetUserValue('SEARCH_TEXT', "");
		frame:SetUserValue('SEARCH_IDX', 0);
	end
end

function INTE_WARP_OPEN_BY_NPC()

   	local frame = ui.GetFrame('worldmap');
	
	frame:SetUserValue("Type", "NPC");

	frame:ShowWindow(1);
	frame:Invalidate();

	RUN_CHECK_LASTUIOPEN_POS(frame)
	

end

function INTE_WARP_OPEN_NORMAL()
   	local frame = ui.GetFrame('worldmap');	
	frame:SetUserValue("Type", "Normal");
	frame:ShowWindow(1);
	frame:Invalidate();	
end

function INTE_WARP_OPEN_DIB()

   	local frame = ui.GetFrame('worldmap');
	
	frame:SetUserValue("Type", "Dievdirbys");

	frame:ShowWindow(1);
	frame:Invalidate();

end

function INTE_WARP_OPEN_FOR_QUICK_SLOT()
   	local frame = ui.GetFrame('worldmap');
	frame:SetUserValue('SCROLL_WARP', 'YES')
	frame:ShowWindow(1);
	frame:Invalidate()
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

function GET_INTE_WARP_LIST()
	local sObj_main = GET_MAIN_SOBJ();
	if sObj_main == nil then
		return nil;
	end
	
	local gentype_classcount = GetClassCount('camp_warp')
    local result = {}
    if gentype_classcount > 0 then
        for i = 0 , gentype_classcount-1 do
            local cls = GetClassByIndex('camp_warp', i);
    		if sObj_main[cls.ClassName] == 300 then
                result[#result + 1] = cls
            end
        end
    end
    
    return result
end

function AMMEND_NOW_ZONE_NAME(nowZoneName)
	local nowMapCls = GetClass('Map', nowZoneName)
	local mapList, mapCnt = GetClassList('Map')
	local etc = GetMyEtcObject()

	if nowMapCls ~= nil and TryGetProp(nowMapCls, 'PhysicalLinkZone') ~= nil then
		if nowMapCls.PhysicalLinkZone == 'None' then
						
			for i = 0, mapCnt - 1 do
				local cls = GetClassByIndexFromList(mapList, i)
				if cls.ClassID == etc.LobbyMapID then 
							
					return cls.ClassName

				end
			end
		end
	end
	return nowZoneName
end

function ON_INTE_WARP_SUB(frame, pic, index, gBoxName, nowZoneName, warpcost, calcOnlyPosition, makeWorldMapImage, mapCls, info, picX, picY, brushX, brushY, bySkill)
	local gbox = pic:CreateOrGetControl("groupbox", gBoxName, picX, picY, 130, 24)
	local setName = "WARP_CTRLSET_" .. index;

	if calcOnlyPosition == false or GET_CHILD_RECURSIVELY(gbox, setName) == nil then
		local set = gbox:CreateOrGetControlSet('warpAreaName', setName, 0, 0);
		set = tolua.cast(set, "ui::CControlSet");
		set:SetEnableSelect(1);
		set:SetOverSound('button_over');
		set:SetClickSound('button_click_stats');
		local nameRechText = GET_CHILD_RECURSIVELY(set, "areaname", "ui::CRichText");
		nameRechText:SetTextByKey("mapname",GET_WARP_NAME_TEXT(mapCls, info, nowZoneName));
		set:SetEventScript(ui.LBUTTONUP, 'WARP_TO_AREA')
		set:SetEventScriptArgString(ui.LBUTTONUP, info.ClassName);
		set:SetTooltipType('warpminimap');
		set:SetTooltipStrArg(info.ClassName);
		set:SetTooltipNumArg(warpcost)
		if nameRechText:GetWidth() > 130 then
			nameRechText:SetTextFixWidth(1);
			nameRechText:Resize(125 , set:GetHeight())
		end
		if makeWorldMapImage == true then
			ui.AddBrushArea(brushX + set:GetWidth() / 2, brushY + set:GetHeight() / 2, set:GetWidth() + WORLDMAP_ADD_SPACE);
		end
	else
		local set = gbox:CreateOrGetControlSet('warpAreaName', setName, 0, 0);
		set = tolua.cast(set, "ui::CControlSet");
		set:SetTooltipNumArg(warpcost)        
	end
end

function GET_WARP_NAME_TEXT(mapCls, info, nowZoneName)

	if mapCls.ClassName == nowZoneName then
		return "{#FFFF00}" .. info.Name;
	end

	return info.Name;

end

function UPDATE_WARP_MINIMAP_TOOLTIP(tooltipframe, strarg, strnum)        
	local warpFrame = ui.GetFrame('worldmap');
	local warpitemname = warpFrame:GetUserValue('SCROLL_WARP');
	local costRichText = GET_CHILD_RECURSIVELY(tooltipframe, "richtext_cost", "ui::CRichText");
	local etc = GetMyEtcObject();

	if (warpitemname == 'NO' or warpitemname == 'None')  then
		costRichText:ShowWindow(1);
	else
		costRichText:ShowWindow(0);
	end
	local camp_warp_class = GetClass('camp_warp', strarg)
	local pc = GetMyPCObject();
	if camp_warp_class ~= nil and (GetZoneName(pc) == 'c_Klaipe' or GetZoneName(pc) == 'c_orsha') then
	    if GetZoneName(pc) == 'c_Klaipe' then
	        if camp_warp_class.Zone == 'c_orsha' then
	            strnum = 0
	        end
	    else
	        if camp_warp_class.Zone == 'c_Klaipe' then
	            strnum = 0                
	        end
	    end
	end

	-- 여신상
	if camp_warp_class ~= nil then
		local nameRichText = GET_CHILD_RECURSIVELY(tooltipframe, "richtext_mapname", "ui::CRichText");
		nameRichText:SetTextByKey("mapname",camp_warp_class.Name);

		world.PreloadMinimap(camp_warp_class.Zone);
		local pic = GET_CHILD_RECURSIVELY(tooltipframe, "picture_minimap", "ui::CPicture");
		pic:SetImage(camp_warp_class.Zone);
		
		local mapprop = geMapTable.GetMapProp(camp_warp_class.Zone);

		if mapprop == nil then
			return;
		end
        
		local costRichText = GET_CHILD_RECURSIVELY(tooltipframe, "richtext_cost", "ui::CRichText");
		if mapprop.type == etc.ItemWarpMapID then
			costRichText:SetTextByKey("costname",0);
		else
			costRichText:SetTextByKey("costname",strnum);
		end

		local genList = mapprop.mongens;
		local genCnt = genList:Count()

		local worldPos;

		for i = 0,  genCnt - 1 do
			local element = genList:Element(i)            
			if	string.find(element:GetClassName(), "statue_vakarine") ~= nil then
				local genPointlist = element.GenList;
				worldPos = genPointlist:Element(0)
				break;
			end
		end

		if worldPos == nil then
			local statuePic = GET_CHILD(tooltipframe, "picture_statue");
			statuePic:ShowWindow(0);            
			return;
		end

		local offsetX = pic:GetX();
		local offsetY = pic:GetY();

		local width = pic:GetWidth();
		local height = pic:GetHeight();

		local mapPos = mapprop:WorldPosToMinimapPos(worldPos.x, worldPos.z, width, height);
	
		local XC = offsetX + mapPos.x - iconW / 2;	
		local YC = offsetY + mapPos.y - iconH / 2;

		local statuePic = tooltipframe:CreateOrGetControl('picture', "picture_statue", XC, YC, iconW, iconH);
		tolua.cast(statuePic, "ui::CPicture");
		statuePic:SetImage("minimap_goddess")
		statuePic:ShowWindow(1)
	end
	
	-- 이전에 워프한 장소
	camp_warp_class = GetClass("Map", strarg)    
	if camp_warp_class ~= nil then         
		local nameRichText = GET_CHILD_RECURSIVELY(tooltipframe, "richtext_mapname", "ui::CRichText");
		nameRichText:SetTextByKey("mapname",camp_warp_class.Name);

		world.PreloadMinimap(camp_warp_class.ClassName);
		local pic = GET_CHILD_RECURSIVELY(tooltipframe, "picture_minimap", "ui::CPicture");
		pic:SetImage(camp_warp_class.ClassName);

		local costRichText = GET_CHILD_RECURSIVELY(tooltipframe, "richtext_cost", "ui::CRichText");
		costRichText:SetTextByKey("costname",strnum);

		local mapprop = geMapTable.GetMapProp(camp_warp_class.ClassName);

		if mapprop == nil then
			return;
		end

		local etc = GetMyEtcObject();

		local genList = mapprop.mongens;
		local genCnt = genList:Count()

		local offsetX = pic:GetX();
		local offsetY = pic:GetY();
		local width = pic:GetWidth();
		local height = pic:GetHeight();

		local mapPos = mapprop:WorldPosToMinimapPos( etc.ItemWarpPosX, etc.ItemWarpPosZ, width, height);
		local XC = offsetX + mapPos.x - iconW/2;	
		local YC = offsetY + mapPos.y - iconH/2;

		local statuePic = tooltipframe:CreateOrGetControl('picture', "picture_statue", XC, YC, iconW, iconH);
		tolua.cast(statuePic, "ui::CPicture");
		statuePic:ShowWindow(0)
		--statuePic:SetImage("minimap_goddess")
	end
	
	tooltipframe:Invalidate()
end

function WARP_TO_AREA(frame, cset, argStr, argNum)  
	local warpFrame = ui.GetFrame('worldmap');
	local test = frame:GetTopParentFrame();
	local x, y = GET_MOUSE_POS();
	
	if first_click_x ~= nil and first_click_y ~= nil then	-- 클릭 좌표점이 존재한다면 마우스를 클릭하고 드래그 했다가, 워프 지점으로 도달했다는 경우다.
		if math.abs(first_click_x - x) > 5 or math.abs(first_click_y - y) > 5 then	-- 마우스 다운과 업의 좌표의 차이가 각각 5초과라는 소리는 드래그하다 여기 들어왔다는 소리
			first_click_x = nil		-- 워프시키지 않고 좌표를 리셋하고 끝냄
			fifst_click_y = nil
			return;
		end
	end

	first_click_x = nil	-- 정상적으로 클릭해서 워프를 해도 좌표를 리셋
	first_click_y = nil

	local camp_warp_class = GetClass('camp_warp', argStr)

	local pc = GetMyPCObject();
	local nowZoneName = GetZoneName(pc);

	local warpcost = 0;
	local targetMapName = 0;	
	local type = warpFrame:GetUserValue("Type");
	if camp_warp_class ~= nil then
		targetMapName = camp_warp_class.Zone;        
    	warpcost = geMapTable.CalcWarpCostBind(AMMEND_NOW_ZONE_NAME(nowZoneName), camp_warp_class.Zone);        
	elseif argStr ~= nil then        
		warpcost = geMapTable.CalcWarpCostBind(AMMEND_NOW_ZONE_NAME(nowZoneName), argStr);    
		targetMapName = argStr;    
	end
	
	if targetMapName == nowZoneName then
		ui.SysMsg(ScpArgMsg("ThatCurrentPosition"));
		return;
	end	

	if warpcost < 0 then
		warpcost = 0
	end
		
	local etc = GetMyEtcObject();
	local prevWarpZone = GetClassByType("Map", etc.ItemWarpMapID)

	if prevWarpZone ~= nil then
		if targetMapName == TryGetProp(prevWarpZone, "ClassName") then
			warpcost = 0
		end	
	end
	
	if type == "Dievdirbys" or type == 'Normal' then
		warpcost = 0
	end
	
	local warpitemname = warpFrame:GetUserValue('SCROLL_WARP');
	if (warpitemname == 'NO' or warpitemname == 'None') and IsGreaterThanForBigNumber(warpcost, GET_TOTAL_MONEY_STR()) == 1 then
		ui.SysMsg(ScpArgMsg('Auto_SilBeoKa_BuJogHapNiDa.'));
		return;
	end
    
    local dest_mapClassID
    if camp_warp_class ~= nil then
	    dest_mapClassID = camp_warp_class.ClassID
	else
	    local mapcls = GetClass('Map',argStr)
		if mapcls ~= nil then
			dest_mapClassID = mapcls.ClassID
		end
	end
	local cheat = string.format("/intewarp %d %d", dest_mapClassID, argNum);
	if warpitemname ~= 'NO' and warpitemname ~= 'None' then
        local warp_item_ies_id = warpFrame:GetUserValue('SCROLL_WARP_IESID')		
        cheat = string.format("/intewarpByItem %d %d %s", dest_mapClassID, argNum, warp_item_ies_id);
	end
	movie.InteWarp(session.GetMyHandle(), cheat);
	packet.ClientDirect("InteWarp");    
    if warpFrame:IsVisible() == 1 then
		ui.CloseFrame('worldmap')
	end
end

function RUN_INTE_WARP(actor)

	movie.InteWarp(actor:GetHandleVal(), 'None');

	packet.ClientDirect("InteWarp");
end

function INTEWARP_SHOW_DIRECTION(frame, ctrl, str, num)
	config.SetConfig("INTEWARP_DIRECTION", str);
	UPDATE_WORLDMAP_CONTROLS(frame, true);
end

function WARP_INFO_ZONE(zoneName)
	local gentype_classcount = GetClassCount('camp_warp')
	if gentype_classcount > 0 then
		for i = 0 , gentype_classcount-1 do
			local cls = GetClassByIndex('camp_warp', i);
			if cls.Zone == zoneName then
				return cls;
			end
		end
	end
end

function ON_UPDATE_OTHER_GUILD_EMBLEM(frame, msg, argStr, argNum)
    local pic = GET_CHILD_RECURSIVELY(frame, 'pic');
    local emblemSet = GET_CHILD_RECURSIVELY(pic, 'EMBELM_'..argStr);    
    if emblemSet ~= nil then
        local emblemPic = GET_CHILD_RECURSIVELY(emblemSet, 'emblemPic');
        local worldID = session.party.GetMyWorldIDStr();
        local emblemImgName = guild.GetEmblemImageName(argStr,worldID);
        if emblemImgName ~= 'None' then
            emblemPic:SetFileName(emblemImgName);
        end
    end
end

function UPDATE_SHOW_ALL_WORLDMAP(frame)
	local showAllWorldMap = frame:GetUserIValue("isShowAllMap")
	if showAllWorldMap == 0 then
		frame:SetUserValue("isShowAllMap", 1)
	else
		frame:SetUserValue("isShowAllMap", 0)
	end

	UPDATE_WORLDMAP_CONTROLS(frame);

end