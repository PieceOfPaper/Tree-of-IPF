function SCR_SSN_KLAPEDA_KillMonster_PARTY(self, party_pc, sObj, msg, argObj, argStr, argNum)
    if SHARE_QUEST_PROP(self, party_pc) == true then
        if GetLayer(self) ~= 0 then
            if GetLayer(self) == GetLayer(party_pc) then
                SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
            end
        else
            SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
        end
    end
---- WHITEDAY_EVENT
--    if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
--        SCR_EVENT_WHITEDAY(self, sObj, msg, argObj, argStr, argNum, "YES")
--    end    
---- ALPHABET_EVENT
--    if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
--        SCR_ALPHABET_EVENT(self, sObj, msg, argObj, argStr, argNum, "YES")
--    end
--   if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
--        SCR_CHUSEOK_EVENT(self, sObj, msg, argObj, argStr, argNum, "YES")
--    end
--  if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
--    DAYQUEST_TAGETMON_CHECK(self, sObj, msg, argObj, argStr, argNum)
--  end
------TODAY_NUMBER_EVENT
--    if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
--        SCR_EVENT_YOUR_CHOICE_CHECK(self, sObj, msg, argObj, argStr, argNum, "YES")
--    end
---- EVENT_1706_MONK
--SCR_SSN_EVENT_1706_MONK_KillMonster(self, sObj, msg, argObj, argStr, argNum)

----EVENT_STEAM_REWARD
--    if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
--        SCR_EVENT_STEAM_ELITE_CHECK(self, sObj, msg, argObj, argStr, argNum)
--    end
    if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
        SCR_EVENTITEM_DROP_BLUEORB(self, sObj, msg, argObj, argStr, argNum) 
    end
----TODAY_NUMBER_EVENT    
    if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
        SCR_EVENT_TODAY_NUMBER_DROPITEM(self, sObj, msg, argObj, argStr, argNum) 
    end
end

function SCR_SSN_KLAPEDA_KillMonster(self, sObj, msg, argObj, argStr, argNum)
	PC_WIKI_KILLMON(self, argObj, true);
	CHECK_SUPER_DROP(self);
	SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
    CHECK_CHALLENGE_MODE(self, argObj);
---- WHITEDAY_EVENT
--    SCR_EVENT_WHITEDAY(self, sObj, msg, argObj, argStr, argNum)
---- ALPHABET_EVENT
--	SCR_ALPHABET_EVENT(self, sObj, msg, argObj, argStr, argNum)
--    SCR_STEAM_OBSERVER_EVENT(self, sObj, msg, argObj, argStr, argNum)
--    SCR_EVENT_NUMBER_DROPITEM(self, sObj, msg, argObj, argStr, argNum)
--    SCR_CHUSEOK_EVENT(self, sObj, msg, argObj, argStr, argNum)
--  DAYQUEST_TAGETMON_CHECK(self, sObj, msg, argObj, argStr, argNum)
---- WHITEDAY_EVENT
--    SCR_EVENT_YOUR_CHOICE_CHECK(self, sObj, msg, argObj, argStr, argNum)
-- EVENT_1706_MONK
--SCR_SSN_EVENT_1706_MONK_KillMonster(self, sObj, msg, argObj, argStr, argNum)
---- TODAY_NUMBER_EVENT
--    SCR_EVENT_TODAY_NUMBER_DROPITEM(self, sObj, msg, argObj, argStr, argNum)
----EVENT_STEAM_REWARD
--    SCR_EVENT_STEAM_ELITE_CHECK(self, sObj, msg, argObj, argStr, argNum)
    SCR_EVENTITEM_DROP_BLUEORB(self, sObj, msg, argObj, argStr, argNum)

-- TODAY_NUMBER_EVENT    
    SCR_EVENT_TODAY_NUMBER_DROPITEM(self, sObj, msg, argObj, argStr, argNum)
end