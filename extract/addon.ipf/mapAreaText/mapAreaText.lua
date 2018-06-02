function MAPAREATEXT_ON_INIT(addon, frame)

	addon:RegisterMsg('MAP_AREA_TEXT', 'ON_MAP_AREA_TEXT');
end

function ON_MAP_AREA_TEXT(frame, msg, name, range)

	local nameText = GET_CHILD(frame, "areaname", "ui::CRichText");
	nameText:SetText(name);

end