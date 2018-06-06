-- padskill_obj_c.lua

function C_PAD_TGT_EFT(pad, padGuid, actor, x, y, z, eft, eftScale, lifeTime, delay)
	effect.PlayGroundEffect(actor, eft, eftScale, x, y, z, lifeTime, "None", 0, delay);
end


function C_PAD_MON_ANI(pad, padGuid, actor, monName, aniName, delay)
	geClientPadSkill.PlayClientMonsterAnim(padGuid, monName, aniName, delay);
end