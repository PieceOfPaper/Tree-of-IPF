-- test_client.lua

function SCR_CLIENTTESTSCP(handle)
    session.friends.TestAddManyFriend(FRIEND_LIST_COMPLETE, 200);
    session.friends.TestAddManyFriend(FRIEND_LIST_BLOCKED, 100);
end

function SCR_OPER_RELOAD_HOTKEY(handle)
	ReloadHotKey();
end