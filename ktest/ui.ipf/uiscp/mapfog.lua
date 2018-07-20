--- mapfog.lua --

function DRAW_MAPFOG_TO_PICTURE(mapname)
	local frame = ui.GetTooltipFrame("texthelp");
	local pic = frame:CreateControl("picture", "MAPPICTURE_" ..mapname, 0, 0, 1024, 1024);
	pic = tolua.cast(pic, "ui::CPicture");
	pic:SetImage(mapname .. "_fog");
	MAKE_MAP_FOG_PICTURE(mapname, pic);
	frame:RemoveChild("MAPPICTURE_" .. mapname);
end

function MAKE_MAP_FOG_PICTURE(mapName, mapPicture)

	if 0 == MAP_USE_FOG(mapName) then
		return;
	end

	mapPicture:EnableCopyOtherImage(mapName);
	if 0 == mapPicture:LockClonePicture() then
		return;
	end

	local list = session.GetMapFogList(mapName);
	local cnt = list:Count();
	local revealCount = 0;
	for i = 0 , cnt - 1 do
		local info = list:PtrAt(i);
		if info.revealed ~= 0 then
			revealCount = revealCount+ 1;
			WRITE_RECT_CLONE_PICTURE(mapPicture, info);
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

function WRITE_RECT_CLONE_PICTURE(pic, info)

 -- 양쪽으로 2/3 만큼 더 칠한다.
	pic:WriteRectToClonePIcture(info.x - info.w * 2 / 3, info.y - info.h * 2 / 3, info.w * 7 / 3, info.h * 7 / 3);

end

