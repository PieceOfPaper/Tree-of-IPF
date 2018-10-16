--- tooltip_worldmap.lua --

function UPDATE_WORLDMAP_TOOLTIP(frame, mapName, numarg)
    local mapCls = GetClass('Map', mapName)
	local x, y, dir, index = GET_WORLDMAP_POSITION(mapCls.WorldMap);

	local drawList = {};
	drawList[#drawList + 1] = mapCls;
	local accObj = GetMyAccountObj();

	local clsList, cnt = GetClassList('Map');	
	for i = 0, cnt-1 do
		local otherMap = GetClassByIndexFromList(clsList, i);
		if otherMap.ClassID ~= mapCls.ClassID and accObj['HadVisited_' .. otherMap.ClassID] == 1 then
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

		local ratestr = ""
		if 0 ~= MAP_USE_FOG(drawCls.ClassName) and session.GetMapFogRevealRate(drawCls.ClassName) >= 100 then
			ratestr = " {img minimap_complete 24 24}"
		end

		local mapnameCtrl = GET_CHILD_RECURSIVELY(ctrlSet, "mapname");
		mapnameCtrl:SetTextByKey("text", mapNameFont..drawCls.Name..ratestr);
		

		local drawMapName = drawCls.ClassName;
		local pic = GET_CHILD_RECURSIVELY(ctrlSet, "map", "ui::CPicture");
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

		UPDATE_MAP_BY_NAME(iconGroup, drawMapName, pic, mapWidth, mapHeight, offsetX, offsetY)
		pic:EnableCopyOtherImage(nil);
		offsetX = 340;
		offsetY = 180;
		MAKE_MAP_AREA_INFO(nameGroup, drawMapName, "{s15}", mapWidth, mapHeight, offsetX, offsetY)

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
		
		local questlv = drawCls.QuestLevel
		local maptype = drawCls.MapType
		if questlv > 0 and (maptype == 'Field' or maptype == 'Dungeon') then
			GET_CHILD_RECURSIVELY(ctrlSet, "monlv"):SetVisible(1)
			GET_CHILD_RECURSIVELY(ctrlSet, "monlv"):SetTextByKey("text",tostring(questlv))
		else
			GET_CHILD_RECURSIVELY(ctrlSet, "monlv"):SetVisible(0)
		end	
		WORLDMAP_TOOLTIP_POSSIBLE_QUESTLIST(frame, mapName, numarg, ctrlSet, drawCls);
	end
	GBOX_AUTO_ALIGN_HORZ(frame, 10, 5, 0, true, true, 512, true);	
end

function WORLDMAP_TOOLTIP_POSSIBLE_QUESTLIST(frame, mapName, numarg, ctrlSet, drawCls)
    local questClsList, questCnt = GetClassList('QuestProgressCheck');	
	local subX = 15
	local subY = 55
	local viewCount = 1
	local pc = GetMyPCObject();
    for index = 0, questCnt-1 do
    	local questIES = GetClassByIndexFromList(questClsList, index);
    	if questIES.StartMap == drawCls.ClassName and questIES.PossibleUI_Notify ~= 'NO' and questIES.QuestMode == 'MAIN' and questIES.Level ~= 9999 and questIES.Lvup ~= -9999 and questIES.QuestStartMode ~= 'NPCENTER_HIDE' then
    		local result = SCR_QUEST_CHECK_C(pc, questIES.ClassName)
    		if result == 'POSSIBLE' then
    		    local picture = ctrlSet:CreateOrGetControl('picture', "questListBoxIcon"..viewCount, subX, subY + (viewCount - 1)*20, 20, 20);
                tolua.cast(picture, "ui::CPicture");
                picture:SetImage(GET_QUESTINFOSET_ICON_BY_STATE_MODE(result, questIES));
                picture:SetEnableStretch(1);
        		local questListBox = ctrlSet:CreateControl('richtext', "questListBox"..viewCount, subX + 20, subY + (viewCount - 1)*20, 20, 100);
                questListBox:SetText('{@st70_m}'..questIES.Name..'{/}');
                viewCount = viewCount + 1
            end
    	end
    end
    for index = 0, questCnt-1 do
    	local questIES = GetClassByIndexFromList(questClsList, index);
    	if questIES.StartMap == drawCls.ClassName and questIES.PossibleUI_Notify ~= 'NO' and questIES.QuestMode ~= 'MAIN' and questIES.QuestMode ~= 'KEYITEM' and questIES.Level ~= 9999 and questIES.Lvup ~= -9999 and questIES.QuestStartMode ~= 'NPCENTER_HIDE' then
    		local result = SCR_QUEST_CHECK_C(pc, questIES.ClassName)
    		if result == 'POSSIBLE' then
    		    local picture = ctrlSet:CreateOrGetControl('picture', "questListBoxIcon"..viewCount, subX, subY + (viewCount - 1)*20, 20, 20);
                tolua.cast(picture, "ui::CPicture");
                picture:SetImage(GET_QUESTINFOSET_ICON_BY_STATE_MODE(result, questIES));
                picture:SetEnableStretch(1);
        		local questListBox = ctrlSet:CreateControl('richtext', "questListBox"..viewCount, subX + 20, subY + (viewCount - 1)*20, 20, 100);
        		if questIES.QuestMode == 'SUB' then
                    questListBox:SetText('{@st70_s}'..questIES.Name);
                elseif questIES.QuestMode == 'REPEAT' then
                    questListBox:SetText('{@st70_d}'..questIES.Name);
                else
                    questListBox:SetText('{@st70_s}'..questIES.Name);
                end
                viewCount = viewCount + 1
            end
    	end
    end
end