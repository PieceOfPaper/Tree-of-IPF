
function INTE_WARP_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg('INTE_WARP', 'ON_INTE_WARP');
	--addon:RegisterOpenOnlyMsg("GAME_START", "ON_INTE_WARP");
end


function INTE_WARP_ON_RELOAD(frame)
	
end

function INTE_WARP_SIZE_UPDATE(frame)
	
	if ui.GetSceneHeight() / ui.GetSceneWidth() <= ui.GetClientInitialHeight() / ui.GetClientInitialWidth() then
		frame:Resize(ui.GetSceneWidth() * ui.GetClientInitialHeight() / ui.GetSceneHeight() ,ui.GetClientInitialHeight())
	end
	frame:Invalidate();
end

function INTE_WARP_OPEN(frame)

	INTE_WARP_SIZE_UPDATE(frame);
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

	local x = config.GetConfigInt("WORLDMAP_X");
	local y = config.GetConfigInt("WORLDMAP_Y");
	WORLDMAP_SETOFFSET(frame, x, y);
	
	ON_INTE_WARP(frame)

	frame:Invalidate()

	local nowZoneName = GetZoneName(pc);
	LOCATE_WORLDMAP_POS(frame, nowZoneName);

	SetKeyboardSelectMode(1)
	

end

function INTE_WARP_CLOSE(frame)
	frame:SetUserValue('SCROLL_WARP', 'NO')
    frame:SetUserValue('SCROLL_WARP_IESID', '0')
	UNREGISTERR_LASTUIOPEN_POS(frame)
	SetKeyboardSelectMode(0)	
end

function ON_INTE_WARP(frame, changeDirection)
	local type = frame:GetUserValue("Type");
	frame:SetUserValue("Mode", "InteWarp");
	local pc = GetMyPCObject();
	local nowZoneName = GetZoneName(pc);
	local gbox = frame:GetChild("gbox");
	DESTROY_CHILD_BYNAME(gbox, "WARP_CTRLSET_");

	local makeWorldMapImage = session.mapFog.NeedUpdateWorldMap();
	local pic = GET_CHILD(frame, "pic" ,"ui::CPicture");
	if changeDirection == true then
		DESTROY_CHILD_BYNAME(pic, "ZONE_GBOX_");
	end

	local makeWorldMapImage = session.mapFog.NeedUpdateWorldMap();
	local currentDirection = config.GetConfig("INTEWARP_DIRECTION", "s");
	currentDirection = "s";

	if changeDirection == true or ui.IsImageExist("worldmap_" .. currentDirection .. "_current") == false then
		makeWorldMapImage = true;
	end

	WORLDMAP_UPDATE_PICSIZE(frame, currentDirection);	

	local picHeight = pic:GetHeight();
	local frameHeight = frame:GetHeight();
	local bottomY = picHeight;


	local imgSize = ui.GetSkinImageSize("worldmap_" .. currentDirection .. "_bg");
	local startX = - 80;
	local startY = bottomY - 0;
	local pictureStartY = imgSize.y - 15;

	local spaceX = 65.25;
	local spaceY = 65.25;

	local nowlocationtext =  GET_CHILD_RECURSIVELY(frame, "nowLocation", "ui::CRichText")
	local nowMapCls = GetClass("Map", nowZoneName);
	nowlocationtext:SetTextByKey("mapname", nowMapCls.Name)
	
	local etc = GetMyEtcObject();
	local mapCls = GetClassByType("Map", etc.ItemWarpMapID)

	ui.ClearBrush();

	local curMode = frame:GetUserValue("Mode");
	local imgName = "worldmap_" .. currentDirection .. "_bg";
	
	local curSize = config.GetConfigInt("WORLDMAP_SCALE");
	local sizeRatio = 1 + curSize * 0.25;

	if mapCls ~= nil and mapCls.WorldMap ~= "None" then		
		
		local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);

		if currentDirection == dir then

			local warpInfo = WARP_INFO_ZONE(mapCls.ClassName)
			local picX = startX + x * spaceX * sizeRatio;
			local picY = startY - y * spaceY * sizeRatio;
			local searchRate = session.GetMapFogSearchRate(mapCls.ClassName);
			local gBoxName = "ZONE_GBOX_" .. x .. "_" .. y;
			local gbox = nil;
			if changeDirection ~= true then
				gbox = pic:GetChild(gBoxName);
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
			local nameRechText = GET_CHILD(set, "areaname", "ui::CRichText");
			nameRechText:SetTextByKey("mapname","{#ffff00}"..ScpArgMsg('Auto_(woPeuJuMunSeo)'));
			set:SetEventScript(ui.LBUTTONUP, 'WARP_TO_AREA')
			if warpInfo ~= nil then --���Ż� �ִ� ������ ���.
				set:SetEventScriptArgString(ui.LBUTTONUP, warpInfo.ClassName);
			else
				set:SetEventScriptArgString(ui.LBUTTONUP, mapCls.ClassName);
			end

			set:SetEventScriptArgNumber(ui.LBUTTONUP, 1);

			local warpcost;
			warpcost = 0

			set:SetTooltipType('warpminimap');
			if warpInfo ~= nil then  --���Ż� �ִ� ������ ���.
				set:SetTooltipStrArg(warpInfo.ClassName);
			else
				set:SetTooltipStrArg(mapCls.ClassName);
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

	local result = GET_INTE_WARP_LIST();
	local mapList, mapCnt = GetClassList('Map')
	if result ~= nil then
		if type == 'Dievdirbys' then
			for index = 1, #result do
				local info = result[index];
				local mapCls = GetClass("Map", info.Zone);

				local warpcost = 0;

				if mapCls.WorldMap ~= "None" then
					local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);
				
					if currentDirection == dir then
						local picX = startX + x * spaceX * sizeRatio;
						local picY = startY - y * spaceY * sizeRatio;
						local searchRate = session.GetMapFogSearchRate(mapCls.ClassName);
						local gBoxName = "ZONE_GBOX_" .. x .. "_" .. y;

						if (warpcost < 1000000) then
							local brushX = startX + x * spaceX;
							local brushY = pictureStartY - y * spaceY;
							if pic:GetChild(gBoxName) == nil then 
								local gbox = pic:CreateOrGetControl("groupbox", gBoxName, picX, picY, 130, 24)
								gbox:SetSkinName("downbox");
								gbox:ShowWindow(1);
							end
							
							ON_INTE_WARP_SUB(frame, pic, index, gBoxName, nowZoneName, warpcost, false, makeWorldMapImage, mapCls, info, picX, picY, brushX, brushY, 1);

							local gbox = pic:GetChild(gBoxName)
							GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true, true);
						end				
					end
				end
			end
		else
			for index = 1, #result do
				local info = result[index];
				local mapCls = GetClass("Map", info.Zone);

				local warpcost = geMapTable.CalcWarpCostBind(AMMEND_NOW_ZONE_NAME(nowZoneName),info.Zone);
				
--                warpcost = 0      --EV161110
                
				if nowZoneName == 'infinite_map' then
					warpcost = 0;
				end
				if mapCls.WorldMap ~= "None" then
					local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);
				
					if currentDirection == dir then
						local picX = startX + x * spaceX * sizeRatio;
						local picY = startY - y * spaceY * sizeRatio;
						local searchRate = session.GetMapFogSearchRate(mapCls.ClassName);
						local gBoxName = "ZONE_GBOX_" .. x .. "_" .. y;

						if (warpcost < 1000000) then
							local calcOnlyPosition = false;
							if changeDirection ~= true then
								gbox = pic:GetChild(gBoxName);
								if gbox ~= nil then
									gbox:SetOffset(picX, picY);
									calcOnlyPosition = true;
								end
							end						
							local brushX = startX + x * spaceX;
							local brushY = pictureStartY - y * spaceY;
							if pic:GetChild(gBoxName) == nil then 
								local gbox = pic:CreateOrGetControl("groupbox", gBoxName, picX, picY, 130, 24)
								gbox:SetSkinName("downbox");
								gbox:ShowWindow(1);
							end

							ON_INTE_WARP_SUB(frame, pic, index, gBoxName, nowZoneName, warpcost, calcOnlyPosition, makeWorldMapImage, mapCls, info, picX, picY, brushX, brushY, 1)

							local gbox = pic:GetChild(gBoxName)
							GBOX_AUTO_ALIGN(gbox, 0, 0, 0, true, true);
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



	pic:SetImage("worldmap_" .. currentDirection .. "_current");

	frame:Invalidate()

end
--[[
function INTEWARP_CLICK_INFO(frame, slot, argStr, argNum)


	local xPos = frame:GetWidth() -50;
	INTE_WARP_DETAIL_INFO(argNum, argStr, xPos);
	return;

end
]]

function CREATE_WARP_CTRL(gbox, setName, info, warpcost)

end