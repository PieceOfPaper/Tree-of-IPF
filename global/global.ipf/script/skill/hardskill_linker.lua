function ADDBUFF_HANGMANSKNOT_DEBUFF(self, actor, skl)
    AddBuff(self, actor, 'HangmansKnot_Debuff', 1, 0, 1000 + skl.Level * 200, 1);	
end

function TAKE_DMG_LINK_ENEMY_COUNTCHECK(caster, buff)
	local arg = GetLinkCmdArgByBuff(caster, buff, 'count');
	arg = arg - 1;

	if arg < 1 then
		RemoveLinkCmdByBuff(caster, buff);
	else
		SetLinkCmdArgByBuff(caster, buff, 'count', arg);
	end
end