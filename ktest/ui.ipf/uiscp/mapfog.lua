--- mapfog.lua --

function DRAW_MAPFOG_TO_PICTURE(mapname)
	local frame = ui.GetTooltipFrame("texthelp");
	local pic = frame:CreateControl("picture", "MAPPICTURE_" ..mapname, 0, 0, 1024, 1024);
	pic = tolua.cast(pic, "ui::CPicture");
	pic:SetImage(mapname .. "_fog");
	MAKE_MAP_FOG_PICTURE(mapname, pic);
	frame:RemoveChild("MAPPICTURE_" .. mapname);
end

function MAKE_MAP_FOG_PICTURE(mapName, mapPicture, enableFog)
	if 0 == MAP_USE_FOG(mapName) then
		return;
	end

	if mapPicture == nil then
		return;
	end
	
	mapPicture:EnableCopyOtherImage(mapName);
	if 0 == mapPicture:LockClonePicture() then
		return;
	end

	local mapRevealRate = session.GetMapFogSearchRate(mapName);
	
	local borderOffset = 3;
	local offsetX = mapPicture:GetOffsetX();
	local offsetY = mapPicture:GetOffsetY();
	local mapZoom = math.abs((config.GetXMLConfig("MinimapSize") + 100) / 100);
	if mapPicture:GetParent() == ui.GetFrame("map") then
		mapZoom = 1;
	end

	local parentFrame = mapPicture:GetParent();

	local list = session.GetMapFogList(mapName);
	local cnt = list:Count();
	for i = 0 , cnt - 1 do
		local info = list:PtrAt(i);
		if info.validPos == 1 then
			if info.revealed == 1 or mapRevealRate >= 100 then
				local x = info.x;
				local y = info.y;
				local w = info.w;
				local h = info.h;
			
				mapPicture:WriteRectToClonePIcture(x - (w * 2 / 3), y - (h * 2 / 3), w * 7 / 3, h * 7 / 3);

				local name = string.format("_SAMPLE_%d", i);
				local child = parentFrame:GetChild(name);
				if child ~= nil then
					child:SetAlpha(0, 30, 0, 0.5, "None", 0);
					child:SetLifeTime(1);
				end
			elseif enableFog == true then
				local name = string.format("_SAMPLE_%d", i);
				local x = (info.x * mapZoom) + offsetX;
				local y = (info.y * mapZoom) + offsetY;
				local w = math.ceil(info.w * mapZoom) + borderOffset;
				local h = math.ceil(info.h * mapZoom) + borderOffset;

				local pic = parentFrame:CreateOrGetControl("picture", name, x, y, w, h);
				tolua.cast(pic, "ui::CPicture");
				pic:ShowWindow(1);
				pic:SetImage("fullwhite");
				pic:SetEnableStretch(1);
				pic:SetAlpha(30.0);
				pic:EnableHitTest(0);
			end
		end
	end
	
	mapPicture:UnLockClonePicture();
	mapPicture:Invalidate();

end

function MAP_USE_FOG(mapName)
	
	local list = session.GetMapFogList(mapName);
	if list == nil  then
		return 0;
	end

	return 1;

end