--

--/**
--* @Function		NULL1
--* @Type			Cond
--* @Description	=============================
--**/
--/**
--* @Function		NULL2
--* @Type			Act
--* @Description	=============================
--**/

--/**
--* @Function		BT_ACT_RESERVE_TARGET_TOP_HATE
--* @Type			Act
--* @Description		Hate가 제일 높은 적 선택해서 타겟 예약 설정.
--**/
function BT_ACT_RESERVE_TARGET_TOP_HATE(self, state, btree, prop)
	local enemy = GetNearTopHateEnemy(self)

	if enemy == nil then
		return BT_FAILED;
	else
		SetReservedTarget(btree, enemy);
		return BT_SUCCESS;
	end
end

--/**
--* @Function		BT_ACT_RESERVE_TARGET_NEAR
--* @Type			Act
--* @NumArg			MaxDistance
--* @Description		가장 가까이 있는 적 타겟 예약
--**/
function BT_ACT_RESERVE_TARGET_NEAR(self, state, btree, prop)
	local numArg = GetLeafNumArg(prop)
	local enemy = GET_NEAR_ENEMY(self, numArg)

	if enemy == nil then
		return BT_FAILED;
	else
		SetReservedTarget(btree, enemy);
		return BT_SUCCESS;
	end
end

--/**
--* @Function		BT_ACT_RESERVE_TARGET_FAR
--* @Type			Act
--* @NumArg			MaxDistance
--* @Description		거리 내 가장 멀리 있는 적 타겟 예약
--**/
function BT_ACT_RESERVE_TARGET_FAR(self, state, btree, prop)
	local numArg = GetLeafNumArg(prop)
	local enemy = GET_FAR_ENEMY(self, numArg)
	
	if enemy == nil then
		return BT_FAILED;
	end
	SetReservedTarget(btree, enemy);
	return BT_SUCCESS;	
end

--/**
--* @Function		BT_ACT_RESERVE_TARGET_RANDOMLY
--* @Type			Act
--* @NumArg			MaxDistance
--* @Description		거리 내 랜덤 적 선택
--**/
function BT_ACT_RESERVE_TARGET_RANDOMLY(self, state, btree, prop)
	local numArg = GetLeafNumArg(prop)
	local objList, objCount = SelectObject(self, numArg, 'ENEMY');

	if objCount == 0 then
		return BT_FAILED;
	end

	local i = IMCRandom(1, objCount);
	local enemy = objList[i];
	SetReservedTarget(btree, enemy);
	return BT_SUCCESS;	
end

--/**
--* @Function		BT_ACT_CLEAR_RESERVED_TARGET
--* @Type			Act
--* @Description		타겟 예약 취소/종료 (FAIL 리턴)
--**/
function BT_ACT_CLEAR_RESERVED_TARGET(self, state, btree, prop)
	ClearReservedTarget(btree);
	return BT_FAILED;
end

--/**
--* @Function		BT_ACT_RESERVE_CASTING_ENEMY
--* @Type			Act
--* @NumArg			거리
--* @Description		캐스팅중인 적이 있으면 타겟 예약.
--**/
function BT_ACT_RESERVE_CASTING_ENEMY(self, state, btree, prop)
	local numArg = GetLeafNumArg(prop);

	local objList, objCount = SelectObjectNear(self, self, numArg, 'ENEMY');
	for i = 1, objCount do
		local obj = objList[i];
		if IS_PC(obj) == true then
			local chargingTime, skillID, maxTime, isLoopingCharge = GetDynamicCastingSkill(obj);
			if skillID ~= 0 then
				SetReservedTarget(btree, obj);
				return BT_SUCCESS;	
			end
		end
	end
	
	return BT_FAILED;
end

--/**
--* @Function		BT_ACT_RESERVE_TARGET_IN_DISTANCE
--* @Type			Act
--* @NumArg			거리
--* @Description		거리 이내에 Hate가 제일 높은 적 예약
--**/
function BT_ACT_RESERVE_TARGET_IN_DISTANCE(self, state, btree, prop)
	local numArg = GetLeafNumArg(prop);
	local objList, objCount = SelectObjectNear(self, self, numArg, 'ENEMY');
	if objCount <= 0 then
		return BT_FAILED;
	end

	local target = nil;
	local hatest = 0;

	for i=1, objCount do
		local obj = objList[i];
		local hate = GetHate(self, obj);
		if hatest < hate then
			target = obj;
		end
	end

	if target == nil then
		return BT_FAILED;
	else
		SetReservedTarget(btree, target);
		return BT_SUCCESS;
	end
end

--/**
--* @Function		BT_ACT_RESERVE_HAS_BUFF
--* @Type			Act
--* @StrArg			버프 이름
--* @NumArg			거리
--* @Description		NumArg 거리 내 StrArg 버프를 가진 적 예약
--**/
function BT_ACT_RESERVE_HAS_BUFF(self, state, btree, prop)
	local strArg = GetLeafStrArg(prop);
	local numArg = GetLeafNumArg(prop);
	
	local target = nil;
	
	local objList, objCount = SelectObjectNear(self, self, numArg, 'ENEMY');
	for i=1, objCount do
		local obj = objList[i];
		local buff = GetBuffByName(obj, strArg);
		if buff ~= nil then
			target = obj;
			break;
		end
	end

	if target ~= nil then
		SetReservedTarget(btree, target);
		return BT_SUCCESS;
	else
		return BT_FAILED;
	end
end

--/**
--* @Function		BT_ACT_USE_SKILL_RESERVED
--* @Type			Act
--* @NumArg			스킬 번호
--* @Description		예약된 타겟에게 스킬 사용
--**/
function BT_ACT_USE_SKILL_RESERVED(self, state, btree, prop)
	local numArg = GetLeafNumArg(prop);
	local selectedSkill = GetMonsterSkillNameByNum(self, numArg-1);
	
	if selectedSkill == '' or selectedSkill == 'None' then
		local errSkill = selectedSkill;
		if errSkill == nil then
			errSkill = "nil";
		end
		IMC_LOG("ERROR_BTREE", "NumArg[".. numArg .. "] SelectedSkill["..errSkill.."]");
		return BT_FAILED;
	end

	local target = GetReservedTarget(btree);
	if target == nil then
		IMC_LOG("ERROR_BTREE", "reserved target[nil]");
		return BT_FAILED;
	end

	SCR_USE_SKILL_WAIT(self, target, selectedSkill);
		
	return BT_SUCCESS;
end

--/**
--* @Function		BT_ACT_USE_SKILL_RESERVED_NOWAIT
--* @Type			Act
--* @NumArg			스킬 번호
--* @Description		예약된 타겟에게 스킬 사용, 즉시반환
--**/
function BT_ACT_USE_SKILL_RESERVED_NOWAIT(self, state, btree, prop)
	local numArg = GetLeafNumArg(prop);
	local selectedSkill = GetMonsterSkillNameByNum(self, numArg-1);
	
	if selectedSkill == '' or selectedSkill == 'None' then
		local errSkill = selectedSkill;
		if errSkill == nil then
			errSkill = "nil";
		end
		IMC_LOG("ERROR_BTREE", "NumArg[".. numArg .. "] SelectedSkill["..errSkill.."]");
		return BT_FAILED;
	end

	local target = GetReservedTarget(btree);
	if target == nil then
		IMC_LOG("ERROR_BTREE", "reserved target[nil]");
		return BT_FAILED;
	end

	UseMonsterSkill(self, target, selectedSkill);
		
	return BT_SUCCESS;
end

--/**
--* @Function		BT_COND_EXIST_RESERVED_TARGET
--* @Type			Cond
--* @Description		예약 타겟이 있는지 검사
--**/
function BT_COND_EXIST_RESERVED_TARGET(self, state, btree, prop)
	local target = GetReservedTarget(btree);
	if target == nil then
		return BT_FAILED;
	else
		return BT_SUCCESS;
	end
end

--/**
--* @Function		BT_COND_NOT_EXIST_RESERVED_TARGET
--* @Type			Cond
--* @Description		예약 타겟이 없는지 검사
--**/
function BT_COND_NOT_EXIST_RESERVED_TARGET(self, state, btree, prop)
	local target = GetReservedTarget(btree);
	if target == nil then
		return BT_SUCCESS;
	else
		return BT_FAILED;
	end
end