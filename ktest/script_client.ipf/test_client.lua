-- test_client.lua

function SCR_CLIENTTESTSCP(handle)
    session.friends.TestAddManyFriend(FRIEND_LIST_COMPLETE, 200);
    session.friends.TestAddManyFriend(FRIEND_LIST_BLOCKED, 100);
end

function SCR_OPER_RELOAD_HOTKEY(handle)
	ReloadHotKey();
end

function TEST_CLIENT_CHAT_PET_EXP()
    local summonedPet = GET_SUMMONED_PET();
    if summonedPet == nil then
	ui.SysMsg(ClMsg("SummonedPetDoesNotExist"));
	return;
    end

    local pet = GET_SUMMONED_PET()
    local petInfo = session.pet.GetPetByGUID(summonedPet:GetStrGuid());
    local curTotalExp = petInfo:GetExp();
    local xpInfo = gePetXP.GetXPInfo(gePetXP.EXP_PET, curTotalExp);
    local totalExp = xpInfo.totalExp - xpInfo.startExp;
    local curExp = curTotalExp - xpInfo.startExp;
    local say = curExp..'/'..totalExp;
    ui.Chat(say);
end
