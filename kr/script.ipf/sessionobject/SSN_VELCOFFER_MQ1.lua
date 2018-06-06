function SCR_SSN_VELCOFFER_MQ1_BASIC_HOOK(self, sObj)
	RegisterHookMsg(self, sObj, 'KillMonster', 'SCR_SSN_KillMonster', 'YES')
	RegisterHookMsg(self, sObj, 'KillMonster_PARTY', 'SCR_SSN_KillMonster_PARTY', 'YES')
end
function SCR_CREATE_SSN_VELCOFFER_MQ1(self, sObj)
	SCR_SSN_VELCOFFER_MQ1_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_VELCOFFER_MQ1(self, sObj)
	SCR_SSN_VELCOFFER_MQ1_BASIC_HOOK(self, sObj)
end

function SCR_DESTROY_SSN_VELCOFFER_MQ1(self, sObj)
end