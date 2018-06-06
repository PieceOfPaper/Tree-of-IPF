function SCR_SSN_JOB_ONMYOJI_Q1_BASIC_HOOK(self, sObj)
end

function SCR_CREATE_SSN_JOB_ONMYOJI_Q1(self, sObj)
	SCR_SSN_JOB_ONMYOJI_Q1_BASIC_HOOK(self, sObj)
end

function SCR_REENTER_SSN_JOB_ONMYOJI_Q1(self, sObj)
	SCR_SSN_JOB_ONMYOJI_Q1_BASIC_HOOK(self, sObj)
	ABANDON_TRACK_QUEST(self, sObj.QuestName, 'SYSTEMCANCEL', 'PROGRESS')
end

function SCR_DESTROY_SSN_JOB_ONMYOJI_Q1(self, sObj)
end

function SCR_TIMEOUT_SSN_JOB_ONMYOJI_Q1(self, sObj)
    
    local maxRewardIndex = SCR_QUEST_CHECK_MODULE_STEPREWARD_FUNC(self, sObj.QuestName)
    if maxRewardIndex ~= nil and maxRewardIndex > 0 then
    	SCR_SSN_TIMEOUT_PARTY_SUCCESS(self, sObj.QuestName, nil, nil)
    else
        RunZombieScript('ABANDON_Q_BY_NAME',self, sObj.QuestName, 'FAIL')
    end
end

function SCR_SSN_JOB_ONMYOJI_Q1_COUNTTIME(self, sObj, remainTime)
	SCR_DIE_DIRECTION_CHECK(self, sObj, remainTime)
end
