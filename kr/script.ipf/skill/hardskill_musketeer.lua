-- hardskill_musketeer.lua


function SCR_MUSKETEER_PRIMEANDLOAD_COOLDOWN_SET(self, skill)
	local skillList = { };
	skillList[#skillList + 1] = { 'Musketeer_CoveringFire', 5000 };
	skillList[#skillList + 1] = { 'Musketeer_HeadShot', 10000 };
	skillList[#skillList + 1] = { 'Musketeer_Snipe', 10000 };
	skillList[#skillList + 1] = { 'Musketeer_PenetrationShot', 5000 };
	skillList[#skillList + 1] = { 'Musketeer_Volleyfire', 5000 };
	skillList[#skillList + 1] = { 'Musketeer_Birdfall', 10000 };
	
	local totalAddCooldown = 0;
    for i = 1, #skillList do
    	local skillName = skillList[i][1];
    	local addCooldown = skillList[i][2];
    	
        local targetSkill = GetSkill(self, skillName);
        if targetSkill ~= nil and IsCoolTime(targetSkill) > 0 then
            local cls = GetClass("CoolDown", targetSkill.CoolDownGroup)
            if cls ~= nil then
                SetCoolDown(self, targetSkill.CoolDownGroup, 0);
                totalAddCooldown = totalAddCooldown + addCooldown;
            end
        end
    end
    
	AddCoolDown(self, skill.CoolDownGroup, totalAddCooldown);
end
