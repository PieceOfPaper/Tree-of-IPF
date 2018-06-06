function SCR_CREATE_SSN_MASTER_RANGER1(self, sObj)
	RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonsterItem', 'NO')
	RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonsterItem_PARTY', 'NO')
end

function SCR_REENTER_SSN_MASTER_RANGER1(self, sObj)
	RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonsterItem', 'NO')
	RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonsterItem_PARTY', 'NO')
end

function SCR_DESTROY_SSN_MASTER_RANGER1(self, sObj)
end