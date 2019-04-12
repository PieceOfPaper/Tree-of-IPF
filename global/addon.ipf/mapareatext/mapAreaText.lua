function MAPAREATEXT_ON_INIT(addon, frame)
	addon:RegisterMsg('MAP_AREA_TEXT', 'ON_MAP_AREA_TEXT');
end

function ON_MAP_AREA_TEXT(frame, msg, name, range)
	local mapText = frame:GetChild("mapName");
	local nameText = GET_CHILD(frame, "areaName", "ui::CRichText");
	local mapName = session.GetMapName();
	local mapCls = GetClass('Map', mapName);
	if mapCls == nil then
		return;
	end

	mapText:SetTextByKey('name', mapCls.Name);
	nameText:SetTextByKey('name', name);
end