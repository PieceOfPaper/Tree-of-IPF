---- barrack_context.lua

function B_MONSTER_CONTEXT(handle, type, idx)

	if 1 == session.IsGM() then
		local cls = GetClassByType("Monster", type);
		local viewName = string.format("%s", cls.Name);
		local context = ui.CreateContextMenu("MONSTER_CONTEXT", viewName, 0, 0, 100, 100);
	
		local strscp = string.format("MSGBOX_DELETE_B_OBJ(%d)", handle);
		ui.AddContextMenuItem(context, ScpArgMsg("Auto_JeKeo"), strscp);
	
		ui.OpenContextMenu(context);
	end
end

function MSGBOX_DELETE_B_OBJ(handle)
	local yesScp = string.format("EXEC_DELETE_B_OBJ(%d)", handle);
	ui.MsgBox(ScpArgMsg("Auto_JeongMal_SagJeHaSiKessSeupNiKka?"), yesScp, "None");
end

function EXEC_DELETE_B_OBJ(handle)
	barrackPlace.DeletePlace(handle);
end


