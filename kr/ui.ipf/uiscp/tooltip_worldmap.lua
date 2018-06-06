--- tooltip_worldmap.lua --

function UPDATE_WORLDMAP_TOOLTIP(frame, mapName, numarg)

    local mapCls = GetClass('Map', mapName)
	local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);

	local drawList = {};
	drawList[#drawList + 1] = mapCls;
	
	local etc = GetMyEtcObject();

	local clsList, cnt = GetClassList('Map');	
	for i = 0, cnt-1 do
		local otherMap = GetClassByIndexFromList(clsList, i);
		if otherMap.ClassID ~= mapCls.ClassID and etc['HadVisited_' .. otherMap.ClassID] == 1 then
			local ox, oy, odir, oindex = GET_WORLDMAP_POSITION(otherMap.WorldMap);
			if ox == x and oy == y then
				drawList[#drawList + 1] = otherMap;
			end
		end
	end

	frame:RemoveAllChild();
	frame:Resize(ui.GetClientInitialWidth(), 512);
	for i = 1 , #drawList do
		local drawCls = drawList[i];
		local ctrlSet = frame:CreateControlSet("worldmap_tooltip", "MAP_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, 0);
		local mapNameFont = MAPNAME_FONT_CHECK(drawCls.QuestLevel)
		
		local mapnameCtrl = ctrlSet:GetChild("mapname");
		mapnameCtrl:SetTextByKey("text", mapNameFont..drawCls.Name);
		local drawMapName = drawCls.ClassName;
		local pic = GET_CHILD(ctrlSet, "map", "ui::CPicture");
		local mapimage = ui.GetImage(drawMapName .. "_fog");
		if mapimage == nil then
			world.PreloadMinimap(drawMapName);
		end
		pic:SetImage(drawMapName .. "_fog");

		UPDATE_MAP_BY_NAME(ctrlSet, drawMapName)
		pic:EnableCopyOtherImage(nil);
		MAKE_MAP_AREA_INFO(ctrlSet, drawMapName, "{s15}")
	
		local questlv = drawCls.QuestLevel
		local maptype = drawCls.MapType
		if questlv > 0 and (maptype == 'Field' or maptype == 'Dungeon') then
			ctrlSet:GetChild("monlv"):SetVisible(1)
			ctrlSet:GetChild("monlv"):SetTextByKey("text",tostring(questlv))
		else
			ctrlSet:GetChild("monlv"):SetVisible(0)
		end	
	end

	GBOX_AUTO_ALIGN_HORZ(frame, 10, 5, 0, true, true, 512, true);	

end

