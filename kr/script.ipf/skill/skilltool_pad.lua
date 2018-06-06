-- skilltool_pad.lua

function MONSKL_CRE_PAD(mon, skl, x, y, z, angle, padName)       
    if padName == 'Sadhu_Bind' then
        SetExProp(skl, 'Sadhu_Bind_StartTime', imcTime.GetAppTimeMS())
    end
	RunPad(mon, padName, skl, x, y, z, angle, 1);
end

function MONSKL_CRE_PAD_HORIZONTAL(mon, skl, x, y, z, padName, maxCellCount, cellSize, eftName, eftSize, seftName, seftSize, delay)
    RunPad_Horizontal(mon, skl, padName, x, y, z, maxCellCount, cellSize, eftName, eftSize, seftName, seftSize, delay);
end

function MONSKL_CRE_PAD_OOBE_POS(mon, skl, angle, padName)
	local oobe = GetOOBEObject(mon);
	if oobe ~= nil then
		local x, y, z = GetPos(oobe);
		RunPad(mon, padName, skl, x, y, z, angle, 1);
	end
end

function MONSKL_START_SPAWN_PAD(mon, skl, padName, maxTime, distBetweenPad)

-- SKL_CONSUME_SKILL_COOLDOWN함수에서도 이중으로 sp를 소비시킨다.
-- 부활하고 싶으면 기락씨에게 말하셈
--if 1 ~= ConsumeSkill(mon, skl) then
--	return;
--end
	StartSpawnPad(mon, skl.ClassName, padName, maxTime, distBetweenPad);


end

function MONSKL_END_SPAWN_PAD(mon, skl)
	
	StartSpawnPad(mon, "None", "None");

end

function MONSKL_CRE_DISABLE_PAD(mon, skl, x, y, z, angle, padName)
	RunPad(mon, padName, skl, x, y, z, angle, 0);
end

function MONSKL_CRE_PAD_CELL(self, skl, padName, cellCount, cellSize, eft, eftScale, seft, seftScale, delay)
	RunPad_ContinuousCell(self, skl, padName, cellCount, cellSize, eft, eftScale, seft, seftScale, delay);
end

function MONSKL_REMOVE_PAD(self, skl, padName)
	RemovePad(self, padName);
end

function MONSKL_FORMATION(self, skl, formName, cellSize, maxPC)
	RunFormation(self, skl, formName, cellSize, maxPC);
end

function MONSKL_PAD_BOMBARDMENT(self, skl, padName, x, y, z, startDelay, count, countDelay, sin, bombardmentTime)
	
	local list = GetMyPadList(self, padName);	
	for i = 1 , #list do
		local pad = list[i];
		if count > 0 then
			SetPadBombardment(pad, x, y, z, countDelay * (i-1) + startDelay, sin, bombardmentTime)
			count = count - 1;
		end
	end
end

function MONSKL_PAD_MOVE_BY_TIME(self, skl, padName, padCount, x, y, z, time, destroyArrival)

	local moveCount = 0;
	local list = GetMyPadList(self, padName);	
	for i = 1 , #list do
		local pad = list[i];
		SetPadDestPosByTime(pad, x, y, z, time, destroyArrival);
		moveCount = moveCount + 1;
		if padCount > 0 and moveCount >= padCount then
			return;
		end
	end
end


function MONSKL_PAD_MOVE_BY_SPEED(self, skl, padName, padCount, x, y, z, speed, accel, destroyArrival)
	
	local moveCount = 0;
	local list = GetMyPadList(self, padName);	

	for i = 1 , #list do
		local pad = list[i];
		SetPadDestPos(pad, x, y, z, speed, aceel, destroyArrival);
		moveCount = moveCount + 1;
		if padCount > 0 and moveCount >= padCount then
			return;
		end
	end
end

function MONSKL_PAD_MSL_BUCK(self, skl, x, y, z, padName, startAngle, moveRange, shootCnt, shootAngle, spd, accel, shootDelay)

	local angleList = {};			
	for i = 1 , shootCnt  do
		angleList[i] = startAngle + ((i-1) * shootAngle);
		if angleList[i] < 0 then
			angleList[i] = angleList[i] + 360;
		end
	end

	local padList = {};
	for i = 1 , shootCnt do
		padList[i] = RunPad(self, padName, skl, x, y, z, 0, 1);
	end
	
	local accumDelay = 0;
	for i = 1 , #padList do
		local pad = padList[i];
		if pad ~= nil then
			local angle = angleList[i];
			local ex, ey, ez = GetFrontPosByAngle(self, angle, moveRange, 0, x, y, z);
			SetPadDestPosWithDelay(pad, ex, ey, ez, spd, accel, 1, accumDelay);
			accumDelay = accumDelay + shootDelay;
		end		
	end
end


function MONSKL_PAD_FRONT_MSL(self, skl, x, y, z, padName, moveRange, shootCnt, spd, accel, shootDelay)

	local padList = {};
	for i = 1 , shootCnt do
		padList[i] = RunPad(self, padName, skl, x, y, z, 0, 1);
	end

	local accumDelay = 0;
	for i = 1 , #padList do
		local pad = padList[i];
		if pad ~= nil then
			local ex, ey, ez = GetFrontPos(self, moveRange);
			SetPadDestPosWithDelay(pad, ex, ey, ez, spd, accel, 1, accumDelay);
			accumDelay = accumDelay + shootDelay;
		end
		
	end
end

function MONSKL_PAD_DIR_MSL(self, skl, x, y, z, padName, moveRange, shootCnt, spd, accel, shootDelay, addAngle, checkCrePadMon)

	if checkCrePadMon == 1 then
		self = GetExArgObject(self, "SUMMONER");
	end

	local padList = {};
	for i = 1 , shootCnt do
		padList[i] = RunPad(self, padName, skl, x, y, z, 0, 1);
	end

	local accumDelay = 0;
	for i = 1 , #padList do
		local pad = padList[i];
		if pad ~= nil then
			local ex, ey, ez = GetFrontPosByAngle(self, addAngle, moveRange);
			SetPadDestPosWithDelay(pad, ex, ey, ez, spd, accel, 1, accumDelay);
			accumDelay = accumDelay + shootDelay;
		end		
	end
end

function MONSKL_PAD_LOOK_DIR_MSL(self, skl, x, y, z, padName, moveRange, shootCnt, spd, accel, shootDelay, addAngle)
	
	local angle = GetDirectionByAngle(self);

	local padList = {};
	for i = 1 , shootCnt do
		padList[i] = RunPad(self, padName, skl, x, y, z, angle, 1);
	end
	
	local accumDelay = 0;
	for i = 1 , #padList do
		local pad = padList[i];
		if pad ~= nil then
			local ex, ey, ez = GetFrontPosByAngle(self, addAngle, moveRange);
			SetPadDestPosWithDelay(pad, ex, ey, ez, spd, accel, 1, accumDelay);
			accumDelay = accumDelay + shootDelay;
		end		
	end
end

function MONSKL_PAD_TGTPOS_MSL(self, skl, x, y, z, padName, spd, accel)

	local pad = RunPad(self, padName, skl, x, y, z, 0, 1);	
	if pad ~= nil then
		local target = GetSkillTarget(self);
		if target ~= nil then
			local ex, ey, ez = GetPos(target);
			SetPadDestPos(pad, ex, ey, ez, spd, accel, 1);
		else
			RemovePad(self, padName);
		end
	end
end


function MONSKL_FORMATION_PAD_ADD_EFFECT(self, skl, index, eft, eftScale)
	
	local actor = GetFormationActorByIndex(self, index-1);
	if actor == nil then
		return;
	end

	local pad = GetFormationPadByIndex(self, index-1);
	if pad ~= nil then
		AddPadEffect(pad, eft, eftScale);
	end
end


function MONSKL_FORMATION_PAD_REMOVE_EFFECT(self, skl, index, eft)
	
	local pad = GetFormationPadByIndex(self, index-1);
	if pad ~= nil then
		RemovePadEffect(pad, eft);
	end
end

function MONSKL_POWERRANGER(self, skl, formName, cellSize, maxPC)
	RunFormation(self, skl, formName, cellSize, maxPC);
end




