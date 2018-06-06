-- test_client.lua

function SCR_CLIENTTESTSCP(handle)
    local pc = GetMyPCObject();
    local result    = SCR_QUEST_CHECK_C(pc, 'PARTY_Q_070');
    print('SSSSSSS',result)
end

function SCR_OPER_RELOAD_HOTKEY(handle)
	ReloadHotKey();
end
