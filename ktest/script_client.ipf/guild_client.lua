---- guild_lua.lua

function CLIENT_GUILD_GOTO_SKILL(skillType)

	local frame = ui.GetFrame("guildmembergo");
	frame:ShowWindow(1);
	GUILDMEMBER_GO_UPDATE_MEMBERLIST(frame, skillType);

end

function CLIENT_GUILD_CALL_SKILL(skillType)

	local frame = ui.GetFrame("guildmembercall");
	frame:ShowWindow(1);
	GUILDMEMBER_GO_UPDATE_MEMBERLIST(frame, skillType);

end

