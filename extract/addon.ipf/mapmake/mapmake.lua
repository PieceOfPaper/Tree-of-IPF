

function MAPMAKE_ON_INIT(addon, frame)



end


function UPDATE_MAP_MAKE_TOOL(frame)

	local mapClassName = session.GetMapName();
	local cls = GetClass("Map", mapClassName);

	UPDATE_MAP_MAKE_PROP(frame, cls, "MinimapWidth");
	UPDATE_MAP_MAKE_PROP(frame, cls, "MinimapHeight");
	UPDATE_MAP_MAKE_PROP(frame, cls, "MinimapCenterX");
	UPDATE_MAP_MAKE_PROP(frame, cls, "MinimapCenterZ");

end

function APPLY_CHANGE_MAP(frame)

	local mapClassName = session.GetMapName();
	local cls = GetClass("Map", mapClassName);

	APPLY_MAK_MAKE_PROP(frame, cls, "MinimapWidth");
	APPLY_MAK_MAKE_PROP(frame, cls, "MinimapHeight");
	APPLY_MAK_MAKE_PROP(frame, cls, "MinimapCenterX");
	APPLY_MAK_MAKE_PROP(frame, cls, "MinimapCenterZ");


	debug.RM();
	TEST_MAP();


end

function UPDATE_MAP_MAKE_PROP(frame, cls, propName)

	local iValue = cls[propName];
	local edit = GET_CHILD(frame, propName, "ui::CEditControl");
	edit:SetText(iValue);

end

function APPLY_MAK_MAKE_PROP(frame, cls, propName)

	local edit = GET_CHILD(frame, propName, "ui::CEditControl");
	local iValue = tonumber(edit:GetText());
	if iValue == nil then
		iValue = 0;
	end

	debug.SaveXMLValue("Map", cls.ClassID, propName, iValue, "xml\\map.xml");


end



