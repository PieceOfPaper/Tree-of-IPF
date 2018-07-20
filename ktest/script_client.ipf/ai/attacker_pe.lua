function SCR_ATTACKER_TS_CHASE_SKILL_PE(selfAi)

	while true do
		if false == selfAi:SkillChase_PE() then
			selfAi:ChangeTactics('TS_NONE');			
			return;
		end

		sleep(100);
	end

 end

