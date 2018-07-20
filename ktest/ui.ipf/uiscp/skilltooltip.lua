-- skilltooltip.lua --

function GET_SKILL_TOOLTIP_VALUES(skl, sklLevel, values)

	if sklLevel == nil then
		sklLevel = skl.Level;
	end
	
	RunSkillTooltipValueScript(skl, sklLevel, values);
end


function TOOLTIP_EFT_AND_HIT(self, skl, values, x, y, z, dcEft, dcEftScale, posDelay, eftName, eftScale, range, kdPower, delay, hitCount, hitDuration, casterEftName, casterEftScale, casterNodeName)
	AddTooltipValue(values, "AttackRange", range);
end


function TOOLTIP_MONSKL_PAD_MSL_BUCK(self, skl, values, x, y, z, padName, startAngle, moveRange, shootCnt, shootAngle, spd, accel, shootDelay)
	AddTooltipValue(values, "MOVERANGE", moveRange);
	AddTooltipValue(values, "SPEED", spd);
end


function TOOLTIP_MSL_THROW(self, skl, values, eftName, eftScale, endEftName, endScale, dotEffect, dotScale, x, y, z, range, flyTime, delayTime, gravity, spd, hitTime, hitCount, dcEft, dcEftScale, dcDelay, eftMoveDelay)
	
	AddTooltipValue(values, "AttackRange", range);
end


function TOOLTIP_MSL_FALL(self, skl, values, eftName, eftScale, endEftName, endScale, dotEffect, dotScale, x, y, z, range, delayTime, flyTime, height, easing, hitTime, hitCount, hitStartFix, startEasing, dcEft, dcEftScale)
	
	AddTooltipValue(values, "AttackRange", range);
end

function TOOLTIP_MONSKL_R_KNOCKDOWN(self, skl, values, knockType, isInverseAngle, power, vAngle, hAngle, bound, kdRank)

	
end

