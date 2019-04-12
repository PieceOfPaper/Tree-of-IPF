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

    --TODAY_NUMBER_EVENT    
    if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
        SCR_EVENT_TODAY_NUMBER_DROPITEM(self, sObj, msg, argObj, argStr, argNum) 
    end

    --upgrade buff    
    if IsSameActor(self, party_pc) ~= "YES" and GetDistance(self, party_pc) < PARTY_SHARE_RANGE then
        SCR_DROP_LVUPBUFF(self, sObj, msg, argObj, argStr, argNum)
    end
end

function SCR_SSN_KLAPEDA_KillMonster(self, sObj, msg, argObj, argStr, argNum)
	PC_WIKI_KILLMON(self, argObj, true);
	CHECK_SUPER_DROP(self);
	SCR_SSN_KLAPEDA_KillMonster_Sub(self, sObj, msg, argObj, argStr, argNum)
    CHECK_CHALLENGE_MODE(self, argObj);

-- TODAY_NUMBER_EVENT    
    SCR_EVENT_TODAY_NUMBER_DROPITEM(self, sObj, msg, argObj, argStr, argNum)

    --upgrade buff
    SCR_DROP_LVUPBUFF(self, sObj, msg, argObj, argStr, argNum)
end