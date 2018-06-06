

function MAPNAME_ON_INIT()



end

function MAPNAME_FIRST_OPEN(frame)	
	local title = GET_CHILD(frame, "title", "ui::CRichText");
	local mapName= session.GetMapName();
	local name = GetClass("Map", mapName).Name;
	title:SetTextByKey("mapname", name);
	title:ShowWindow(1);
	local bg = GET_CHILD(frame, "bg", "ui::CPicture");
	local imgName = mapName .. "_mapname_bg";
	
	if ui.IsImageExist(imgName) == 0 then
		imgName = "localbackground";
	end

	bg:SetImage(imgName);
	bg:ShowWindow(1);
end


function CLOSE_MAPNAME(frame)

	ReserveScript("DESTROY_FRAME(\"mapname\")", 5.0);

end




