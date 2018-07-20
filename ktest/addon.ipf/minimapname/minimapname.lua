

function MINIMAPNAME_ON_INIT()



end


function MINIMAPNAME_FIRST_OPEN(frame)

	local title = GET_CHILD(frame, "title", "ui::CRichText");
	local mapName= session.GetMapName();
	local name = GetClass("Map", mapName).Name;
	title:SetTextByKey("mapname", name);

end







