
--/**
--* @Function		NULL3
--* @Type			Cond
--* @Description	=============================
--**/
--/**
--* @Function		NULL4
--* @Type			Act
--* @Description	=============================
--**/

--/**
--* @Function		BT_COND_CHECK_FIXED_TIMER
--* @Type			Cond
--* @StrArg			TimerName
--* @NumArg			msec
--* @Description		고정 시간마다 SUCCESS 리턴하는 타이머. 처음 시작할 때에도 SUCCESS 리턴.
--**/
function BT_COND_CHECK_FIXED_TIMER(self, state, btree, prop)
	local strArg = GetLeafStrArg(prop)
	local numArg = GetLeafNumArg(prop)

	if self == nil or strArg == "" then
		return BT_FAILED;
	end

	local name = 'BT_Timer_' .. strArg;
	local num = GetExProp(self, name);
	local now = imcTime.GetAppTimeMS();
	-- 시작할때도 SUCCESS
	if num == 0 then
		SetExProp(self, name, now + numArg);
		return BT_SUCCESS;
	elseif num <= now then
		SetExProp(self, name, now + numArg);
		return BT_SUCCESS;
	else
		return BT_FAILED;
	end
end

--/**
--* @Function		BT_COND_IS_SKILL_CHASE_TIMER_EXPIRED
--* @Type			Cond
--* @StrArg			TimerName
--* @Description		스킬로 쫒기 타이머 만료 체크
--**/
function BT_COND_IS_SKILL_CHASE_TIMER_EXPIRED(self, state, btree, prop)
	local num = GetExProp(self, 'BT_Skill_Chase_Timer');
	local now = imcTime.GetAppTimeMS();
	
	if num == 0 then
		return BT_FAILED;
	end

	if num <= now then
		BT_LIB_SKILL_CHASE_TIMER_END(self);
		return BT_SUCCESS;
	else		
		return BT_FAILED;
	end
end
--/**
--* @Function		BT_ACT_SKILL_CHASE_TIMER_START
--* @Type			Act
--* @NumArg			ms
--* @Description		스킬로 쫒는 시간 타이머 시작
--**/
function BT_ACT_SKILL_CHASE_TIMER_START(self, state, btree, prop)
	local numArg = GetLeafNumArg(prop);
	local now = imcTime.GetAppTimeMS();	
	SetExProp(self, 'BT_Skill_Chase_Timer', now + numArg);
	return BT_SUCCESS;
end

function BT_LIB_SKILL_CHASE_TIMER_END(self)
	DelExProp(self, 'BT_Skill_Chase_Timer');
end

--/**
--* @Function		BT_COND_ABOVE_COUNTER
--* @Type			Cond
--* @StrArg			카운터 이름
--* @NumArg			갯수
--* @Description		카운트가 NumArg 이상인지
--**/
function BT_COND_ABOVE_COUNTER(self, state, btree, prop)
	local strArg = GetLeafStrArg(prop);
	local numArg = GetLeafNumArg(prop);

	if strArg == nil then
		return BT_FAILED;
	end

	local count = GetExProp(self, 'BT_COUNTER_' .. strArg);
	if count ~= nil then
		if count >= numArg then
			return BT_SUCCESS;
		end
	end
	return BT_FAILED;
end

--/**
--* @Function		BT_COND_BELOW_COUNTER
--* @Type			Cond
--* @StrArg			카운터 이름
--* @NumArg			갯수
--* @Description		카운트가 NumArg 이하인지
--**/
function BT_COND_BELOW_COUNTER(self, state, btree, prop)
	local strArg = GetLeafStrArg(prop);
	local numArg = GetLeafNumArg(prop);

	if strArg == nil then
		return BT_FAILED;
	end

	local count = GetExProp(self, 'BT_COUNTER_' .. strArg);
	if count ~= nil then
		if count < numArg then
			print(count, numArg)
			return BT_SUCCESS;
		end
	end
	return BT_FAILED;
end

--/**
--* @Function		BT_ACT_RESET_COUNTER
--* @Type			Act
--* @StrArg			카운터 이름
--* @Description		카운터 초기화
--**/
function BT_ACT_RESET_COUNTER(self, state, btree, prop)
	local strArg = GetLeafStrArg(prop);
	if strArg == nil then
		return BT_FAILED;
	end

	DelExProp(self, 'BT_COUNTER_' .. strArg);
	return BT_SUCCESS;
end

--/**
--* @Function		BT_ACT_INCREASE_COUNTER
--* @Type			Act
--* @StrArg			카운터 이름
--* @Description		카운터 증가
--**/
function BT_ACT_INCREASE_COUNTER(self, state, btree, prop)
	local strArg = GetLeafStrArg(prop);
	if strArg == nil or strArg == "" then
		return BT_FAILED;
	end
	
	local count = GetExProp(self, 'BT_COUNTER_' .. strArg);
	count = count + 1;
	SetExProp(self, 'BT_COUNTER_' .. strArg, count);
	return BT_SUCCESS;
end

--/**
--* @Function		BT_ACT_DECREASE_COUNTER
--* @Type			Act
--* @StrArg			카운터 이름
--* @Description		카운터 감소
--**/
function BT_ACT_DECREASE_COUNTER(self, state, btree, prop)
	local strArg = GetLeafStrArg(prop);
	if strArg == nil or strArg == "" then
		return BT_FAILED;
	end
	
	local count = GetExProp(self, 'BT_COUNTER_' .. strArg);
	count = count - 1;
	SetExProp(self, 'BT_COUNTER_' .. strArg, count);
	return BT_SUCCESS;
end