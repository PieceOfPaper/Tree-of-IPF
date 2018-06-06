--- hardskill_Onmyoji.lua

function SCR_FIREFOXSHIKIGAMI(self, parent, skill)
    local caster = GetOwner(self);
    if caster == nil then
        Kill(self);
        return;
    end
    
--    self.Lv = caster.Lv;
	FollowToActor(self, caster, "Dummy_RU_armband", 10.0, 30.0, 0.0, 1, 0.1);
    SetExProp(self, "ONMYOJI_FIREFOXSHIKIGAMI", 1)
    SetExPropSend(self, "ONMYOJI_FIREFOXSHIKIGAMI");
    SetExProp(caster, "ONMYOJI_FIREFOXSHIKIGAMI", GetHandle(self));
    
    local abilOnmyoji2 = GetAbility(caster, "Onmyoji2")
    if abilOnmyoji2 ~= nil and abilOnmyoji2.ActiveState == 1 then
    	AddBuff(caster, caster, "FireFoxShikigami_Buff", 1, 0, 60000, 1)
    end
end

function SCR_FIREFOX_DEAD(self)
	
end
