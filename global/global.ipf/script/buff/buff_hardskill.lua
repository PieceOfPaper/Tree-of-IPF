function SET_LINK_ENEMY_COUNT(caster, buff)
	local sklLv = 1;
	local count = 0;
	
	if caster ~= nil then
		local skl = GetSkill(caster, 'Linker_JointPenalty');
		sklLv = skl.Level;
		count = skl.Level * 10;
	end

	SetLinkCmdArgByBuff(caster, buff, 'count', count);
end