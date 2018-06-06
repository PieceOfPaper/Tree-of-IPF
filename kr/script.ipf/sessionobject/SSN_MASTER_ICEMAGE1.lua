function SCR_CREATE_SSN_MASTER_ICEMAGE1(self, sObj) 
	RegisterHookMsg(self, sObj, "KillMonster", "SCR_SSN_KillMonster", "NO")
	RegisterHookMsg(self, sObj, "KillMonster_PARTY", "SCR_SSN_KillMonster_PARTY", "NO")
end

function SCR_REENTER_SSN_MASTER_ICEMAGE1(self, sObj)
	SCR_CREATE_SSN_MASTER_ICEMAGE1(self, sObj)
    ABANDON_TRACK_QUEST(self, sObj.QuestName, 'SYSTEMCANCEL', 'PROGRESS')
end

function SCR_DESTROY_SSN_MASTER_ICEMAGE1(self, sObj)
end
