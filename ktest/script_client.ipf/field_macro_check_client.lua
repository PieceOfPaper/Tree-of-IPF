-- field_macro_check_client.lua

function UPDATE_REMOVE_AREA_MINIMAP_MARK(name, x, y, z, isAlive)
    if isAlive == 1 then
        session.minimap.AddIconInfo(name, "trasuremapmark", x, y, z, ClMsg('THORN21_RP_2_DO'), true, nil, 1.5);
	else
		session.minimap.RemoveIconInfo(name);
    end
end