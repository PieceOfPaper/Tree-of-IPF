--skill_buff_ratetable.lua
-- FINAL_DAMAGECALC() -> SCR_BUFF_RATETABLE_UPDATE(self, from, skill, atk, ret, rateTable);
-- must check IsBuffApplied(self or from, buffname) == 'YES' / 'NO'


function SCR_BUFF_IMMUNE_Cyclone_Buff_ImmuneAbil(self, buffName, buffLv, rate)
	if IsBuffApplied(self, 'Cyclone_Buff_ImmuneAbil') == 'YES' then
	    rate = rate + GetExProp(self, "ADD_CYCLONE_IMMUNE")
		return rate;
	end
end

function SCR_BUFF_IMMUNE_PainBarrier_Buff(self, buffName, buffLv, rate)
	if IsBuffApplied(self, 'PainBarrier_Buff') == 'YES' then
	    rate = rate + 2000
		return rate;
	end
end

function SCR_BUFF_IMMUNE_DashRun(self, buffName, buffLv, rate)
	if IsBuffApplied(self, 'DashRun') == 'YES' then
		rate = rate + 3000
		return rate;
	end
end

function SCR_BUFF_IMMUNE_Slithering_Buff(self, buffName, buffLv, rate)
	if IsBuffApplied(self, 'Slithering_Buff') == 'YES' then
		rate = rate + 7000
		return rate;
	end
end

function SCR_BUFF_IMMUNE_Warrior_RushMove_Buff(self, buffName, buffLv, rate)
	if IsBuffApplied(self, 'Warrior_RushMove_Buff') == 'YES' then
		rate = rate + 7000
		return rate;
	end
end

function SCR_BUFF_IMMUNE_murmillo_helmet(self, buffName, buffLv, rate)
	if buffName == "EquipDesrption_Debeff" then
	    return 0;
	elseif IsBuffApplied(self, 'murmillo_helmet') == 'YES' then
		rate = rate + 5000
		return rate;
	end
end

function SCR_BUFF_IMMUNE_Commence_Buff(self, buffName, buffLv, rate)
	if IsBuffApplied(self, 'Commence_Buff') == 'YES' then
		rate = rate + 7000
		return rate;
	end
end

