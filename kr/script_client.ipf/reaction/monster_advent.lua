-- monster_advent.lua
function C_ADVENT_EFFECT(actor, effectName, scale, nodeName, lifeTime)
	effect.PlayActorEffect(actor, effectName, nodeName, lifeTime, scale);
end

function IS_ALWAYS_VISIBLE_MON_TITLE(mon)	
	if mon == nil then
		return 0;
	end

	local targetClsName = {'Saloon', 'pcskill_CorpseTower', 'pcskill_shogogoth'};
	for i = 1, #targetClsName do
		if targetClsName[i] == mon.ClassName then
			return 1;
		end
	end
	return 0;
end	