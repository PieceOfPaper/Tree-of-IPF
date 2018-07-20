--- hardskill_NakMuay.lua

function SCR_NAKMUAY_COOLDOWN(self)
	if IsBuffApplied(self, 'MuayThai_Buff') == 'YES' then
		local skillList = {}
		local list, cnt = GetClassList("Skill")
		if list ~= nil then
			for i = 1, cnt - 1 do
				local skill = GetClassByIndexFromList(list, i)
				if skill ~= nil then
					if TryGetProp(skill, "Job") == "NakMuay" then
						skillList[#skillList + 1] = skill
					end
				end
			end
		end
		
		for j = 1, #skillList do
			local skill = skillList[j]
			AddCoolDown(self, skill.CoolDownGroup, -1000)
		end
	end
end
