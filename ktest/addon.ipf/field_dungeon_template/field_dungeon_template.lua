function DIALOG_ACCEPT_FIELD_DUNGEON_TEMPLATE_REJOIN()
	ui.MsgBox(ClMsg("Rift_Dungeon_Accept_ReJoin"), "ACCEPT_FIELD_DUNGEON_TEMPLATE_REJOIN", "None");
end

function ACCEPT_FIELD_DUNGEON_TEMPLATE_REJOIN()
	packet.AcceptFieldDungeonRejoin();
end

function ON_FIELD_DUNGEON_START_TIMER(frame, msg, argStr, argNum)
	if argStr == "Start" then
		ui.OpenFrame("eventtimer");
		local frame = ui.GetFrame("eventtimer");
		TIMER_SET_EVENTTIMER(frame, argNum);
		frame:ShowWindow(1);
		frame:SetTextByKey("title", "");
		frame:SetGravity(ui.RIGHT, ui.TOP);
		frame:SetMargin(0, -20, 250, 0);
	elseif argStr == "End" then
		ui.CloseFrame("eventtimer");
	end
end

function UPDATE_FIELD_DUNGEON_MINIMAP_MARK(name, x, y, z, isAlive)
	if isAlive == 1 then
		session.minimap.AddIconInfo(name, "trasuremapmark", x, y, z, ClMsg(name), true, nil, 1.5);
	else
		session.minimap.RemoveIconInfo(name);
	end
end