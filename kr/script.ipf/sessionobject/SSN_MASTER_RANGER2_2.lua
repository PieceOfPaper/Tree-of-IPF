function SCR_SSN_MASTER_RANGER2_2_BASIC_HOOK(self, sObj)
	RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonsterItem', 'NO')
	RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonsterItem_PARTY', 'NO')
end

function SCR_CREATE_SSN_MASTER_RANGER2_2(self, sObj)
	SCR_SSN_MASTER_RANGER2_2_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_MASTER_RANGER2_2(self, sObj)
	SCR_SSN_MASTER_RANGER2_2_BASIC_HOOK(self, sObj)
	ABANDON_TRACK_QUEST(self, sObj.QuestName, 'SYSTEMCANCEL', 'PROGRESS')
end

function SCR_DESTROY_SSN_MASTER_RANGER2_2(self, sObj)
end