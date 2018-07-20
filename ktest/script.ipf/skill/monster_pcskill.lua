--- monster_pcskill.lua

function MONPCSKILL_GET_POS_Thaumaturge_Reversi(self, target)

	local padList = GetMyPadList(target, "ALL");
	if padList == nil then
	    return 0;
	end
	
	if #padList == 0 then
		return GetPos(target);
	end

	local pad = padList[1];
	return GetPadPos(pad);

end

function MONPCSKILL_GET_POS_MonPCSKill_Quicken(self, target)
	SetExArgObject(self, "MONPCSKILL_TARGET", target);
	return GetPos(target);
end

function CHECK_IS_FIRE_PAD_SKILL(clsName, self)
	
	if string.find(clsName, "Fire") == nil then
		return 0;
	end
	
	SetExProp_Str(self, "PadName", clsName);
	return 1;

end

function MONPCSKILL_GET_POS_Elementalist_Rain(self, target)

	local padName = GetExProp_Str(self, "PadName");
	local padList = GetMyPadList(target, padName);
	if #padList == 0 then
		return GetPos(target);
	end

	local pad = padList[1];
	return GetPadPos(pad);

end


function MONPCSKILL_GET_POS_Psychokino_Teleportation(self, target)

	target = GetTopHatePointChar(self);

    if target == nil then
        return 0;
    end
	
	local angle = GetAngleTo(target, self);
	angle = angle + IMCRandom(-30, 30);
	local teleportDist = 100;
	angle = DegToRad(angle);
	local addX = math.cos(angle) * teleportDist;
	local addZ = math.sin(angle) * teleportDist;

	local x, y, z = GetPos(self);
	x = x + addX;
	z = z + addZ;
	return x, y, z;

end

function MONPCSKILL_USE_Rogue_Burrow(self)
	RunScript("AUTO_REMOVE_BURROW_BUFF", self);
end

function AUTO_REMOVE_BURROW_BUFF(self)

	sleep(5000);
	RemoveBuff(self, "Burrow_Rogue");	

end

function ANI_CHANGE_HP(self)
	AddBuff(self, self, "AniChangeHP")
end

function ANI_CHANGE_TIME(self)
	AddBuff(self, self, "AniChangeTime")
end

