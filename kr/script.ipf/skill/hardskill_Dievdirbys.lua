function SCR_SUMMON_OWL(mon, self, skl)
    if IsPVPServer(self) == 1 then
        mon.HPCount = 10;
    else
        mon.HPCount = 40 + skl.Level * 10;
    end
    --CalcUserControlMonsterStat(mon, self.STR, self.CON, self.INT, self.MNA, self.DEX)
    mon.Lv = self.Lv
    mon.MATK_BM = self.MINMATK + skl.SkillAtkAdd
    
    mon.STR = self.STR
    mon.INT = self.INT
    
end

function SCR_SUMMON_ZEMINA(mon, self, skl)
    if IsPVPServer(self) == 1 then
        mon.HPCount = 15;
    else
        mon.HPCount = 19 + skl.Level;
    end
    mon.Lv = skl.Level * 10;
    
    SetExProp(mon, "ZEMINA_SKILL_LV", skl.Level);
end

function SCR_SUMMON_LAIMA(mon, self, skl)
    if IsPVPServer(self) == 1 then
        mon.HPCount = 15;
    else
        mon.HPCount = 19 + skl.Level;
    end
    mon.Lv = skl.Level * 10;
    
    SetExProp(mon, "LAIMA_SKILL_LV", skl.Level);
end


function SCR_SUMMON_AUSIRINE(mon, self, skl)
    if IsPVPServer(self) == 1 then
        mon.HPCount = 15;
    else
        mon.HPCount = 19 + skl.Level;
    end
    mon.Lv = skl.Level * 10;
    SetExProp(mon, 'SKL_COUNT', skl.Level);
    SetExProp(mon, 'SKL_LEVEL', skl.Level);
end


function SCR_SUMMON_AUSTRASKOKS(mon, self, skl)
    if IsPVPServer(self) == 1 then
        mon.HPCount = 15;
    else
        mon.HPCount = 19 + skl.Level;
    end
    mon.Lv = skl.Level * 10;
    SetExProp(mon, 'AUSTRASKOKS_SKILL_LV', skl.Level);
end


function SCR_SUMMON_VAKARINE(mon, self, skl)
   mon.HPCount = 19 + skl.Level;
  SetExProp(mon, "REMAIN_WARP_COUNT", skl.Level);
	SetExProp(mon, "OWNER_HANDLE", GetHandle(self));
	SetTakeDamageScp(mon, "SCR_CARVE_TAKEDAMAGE");
		

	SCR_SUMMON_SET_EXPROP(mon, self, skl);		
end

function SCR_CARVE_TAKEDAMAGE(self, from, skl, damage, ret)	

	local ownerHandle = GetExProp(self, "OWNER_HANDLE");
	local instID = GetZoneInstID(self);
	local owner = GetByHandle(instID, ownerHandle);

	if owner ~= nil then
		if IS_APPLY_RELATION(owner, from, "ENEMY") == false then
			NO_HIT_RESULT(ret);
			return;
		end
	end

end

function SCR_AUSIRINE_HOVER(self, skl, pad, obj)
	local list = GetMyPadList(self, 'Dievdirbys_CarveAusirine');
	for i = 1, #list do
		local ausirinePad = list[i];
		if ausirinePad ~= nil then
			local id = GetPadID(ausirinePad);
			SetExProp(self, 'AUSIRINE_'..id, i);
		end
	end
	local padID = GetPadID(pad);
	local beforePadID = GetExProp(obj, 'PAD_ID');
	SetExProp(obj, 'PAD_ID', padID);
	local oldIndex = GetExProp(self, 'AUSIRINE_'..beforePadID);
	local newIndex = GetExProp(self, 'AUSIRINE_'..padID);
	if oldIndex == newIndex then
		return;
	end
	oldIndex = oldIndex % #list + 1;
	
	local cnt = GetExProp(obj, 'AUSIRINE_COUNT');
	if cnt < 0 then
		return;
	end
	if oldIndex == newIndex then
		SetExProp(obj, 'AUSIRINE_COUNT', cnt + 1);
	else
		SetExProp(obj, 'AUSIRINE_COUNT', 0);
	end
	-- 버프 시간 관련, 팀배틀리그에선 절반으로 줄여준다 --
	local sklLevel = GetExProp(self, 'SKL_LEVEL');
	local buffTime = 8000 + sklLevel * 2000
	if IsPVPServer(self) == 1 then
	    buffTime = buffTime * 0.7 
	end
	
	if GetExProp(obj, 'AUSIRINE_COUNT') >= 3 and GetRelation(self, obj) ~= "ENEMY" then
	    local sklCount =  GetExProp(self, 'SKL_COUNT');
		AddBuff(obj, obj, 'Ausirine_Buff', 1, 0, buffTime, 1);
		SetExProp(obj, 'AUSIRINE_COUNT', 0);
		sklCount = sklCount -1;
		if sklCount <= 0 then
			Dead(self);
		end
		SetExProp(self, 'SKL_COUNT', sklCount);
	end
end