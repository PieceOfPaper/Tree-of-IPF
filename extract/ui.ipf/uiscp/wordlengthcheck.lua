--- wordlengthcheck.lua --

function INIT_TEAMNAME_EDIT(edit, ctrlName)
	local minLen = geSharedConstTable.GetConstByName("TEAM_NAME_MIN");
	local maxLen = geSharedConstTable.GetConstByName("TEAM_NAME_MAX");
	SET_EDIT_LENGTH(edit, minLen, maxLen + 1, ctrlName);

end

