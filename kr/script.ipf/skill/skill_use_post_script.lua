--- skill_use_post_script.lua

function SCR_SKILL_POST_SCRIPT(self, skill)
    local sklID = TryGetProp(skill, "ClassID")
    if IsNormalSKillBySkillID(self, sklID) ~= 1 then
        if GetExProp(skill, "PASS_COOLDOWN") == 1 then
            DelExProp(skill, "PASS_COOLDOWN")
        end
    end
end

--[[
function SCR_SKILL_POST_SCRIPT_스킬클래스네임(self, skill)

end
]]


