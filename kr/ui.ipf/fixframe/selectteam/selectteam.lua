function SELECTTEAM_ON_INIT(addon, frame)
--[[
	addon:RegisterMsg("BARRACK_ADDCHARACTER", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_NEWCHARACTER", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_CREATECHARACTER_BTN", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_DELETECHARACTER", "SELECTCHARINFO_DELETE_CTRL");
	addon:RegisterMsg("BARRACK_DELETEALLCHARACTER", "SELECTCHARINFO_DELETEALL_CTRL");
	addon:RegisterMsg("BARRACK_SELECTCHARACTER", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_SELECT_BTN", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_NAME", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("SET_BARRACK_MODE", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("NOT_HANDLED_ENTER", "SELECTTEAM_OPEN_CHAT");

	frame:SetUserValue("BarrackMode", "Barrack");
	SET_CHILD_USER_VALUE(frame, "upgrade", "Barrack", "YES");
	SET_CHILD_USER_VALUE(frame, "setting", "Barrack", "YES");
	SET_CHILD_USER_VALUE(frame, "delete_character", "Barrack", "YES");
	SET_CHILD_USER_VALUE(frame, "deleteall_character", "Barrack", "YES");
	SET_CHILD_USER_VALUE(frame, "start_game", "Barrack", "YES");
	SET_CHILD_USER_VALUE(frame, "barrackname", "Barrack", "YES");
	SET_CHILD_USER_VALUE(frame, "barrackVisit", "Barrack", "YES");

	SET_CHILD_USER_VALUE(frame, "barrackname", "Visit", "YES");
	SET_CHILD_USER_VALUE(frame, "returnHome", "Visit", "YES");

	SET_CHILD_USER_VALUE(frame, "end_preview", "Preview", "YES");
	SET_CHILD_USER_VALUE(frame, "upgrade", "Preview", "YES");

	SET_CHILD_USER_VALUE(frame, "barrackname", "Visit_Normal", "YES");
	SET_CHILD_USER_VALUE(frame, "returnHome", "Visit_Normal", "YES");
	SET_CHILD_USER_VALUE(frame, "goto_normalgame", "Visit_Normal", "YES");]]

end

function SELECTTEAM_ONLOAD(frame, msg, argStr, argNum)

end

