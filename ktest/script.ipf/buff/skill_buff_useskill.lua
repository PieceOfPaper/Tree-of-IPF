--skill_buff_useskill.lua
--OnEvent(BET_USE_SKILL, m_skill->GetClassID(), 0);
-- return 0 is removebuff

function EXIT_BUFF(self, buff)
	return 0;
end

-- buff
function SCR_BUFF_USESKILL_Burrow(self, buff, sklID, arg2)

	return EXIT_BUFF(self, buff);
end

function SCR_BUFF_USESKILL_QuickCast_After_Buff(self, buff, sklID, arg2)

	return EXIT_BUFF(self, buff);
end
