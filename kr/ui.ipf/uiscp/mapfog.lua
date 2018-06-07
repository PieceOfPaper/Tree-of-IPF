--- mapfog.lua --

function DRAW_MAPFOG_TO_PICTURE(mapname)
	local frame = ui.GetTooltipFrame("texthelp");
	
	local width = ui.GetImageWidth(mapname .. "_fog");
	local height = ui.GetImageHeight(mapname .. "_fog");

	local pic = frame:CreateControl("picture", "MAPPICTURE_" ..mapname, 0, 0, width, height);
	pic = tolua.cast(pic, "ui::CPicture");
	pic:SetImage(mapname .. "_fog");
	MAKE_MAP_FOG_PICTURE(mapname, pic);
	frame:RemoveChild("MAPPICTURE_" .. mapname);
end

function MAKE_MAP_FOG_PICTURE(mapName, mapPicture, enableFog)
	ui.MakeMapFogPicture(mapName, mapPicture, enableFog);
end

function MAP_USE_FOG(mapName)
	
	local list = session.GetMapFogList(mapName);
	if list == nil  then
		return 0;
	end

	return 1;

end