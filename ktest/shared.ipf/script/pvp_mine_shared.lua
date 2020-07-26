
function SCR_PVP_MINE_GET_REGION_RULE()
	local pvp_mine_rule = GetClass('pvp_mine_rule', 'pvp_mine_rule')
	if GetServerNation() == 'GLOBAL' then
		if GetServerGroupID() == 1001 or GetServerGroupID() == 10001 then
			pvp_mine_rule = GetClass('pvp_mine_rule', 'pvp_mine_rule_steam_1001')
		elseif GetServerGroupID() == 1003 or GetServerGroupID() == 10003 then
			pvp_mine_rule = GetClass('pvp_mine_rule', 'pvp_mine_rule_steam_1003')
		elseif GetServerGroupID() == 1004 or GetServerGroupID() == 10004 then
			pvp_mine_rule = GetClass('pvp_mine_rule', 'pvp_mine_rule_steam_1004')
		elseif GetServerGroupID() == 1005 or GetServerGroupID() == 10005 then
			pvp_mine_rule = GetClass('pvp_mine_rule', 'pvp_mine_rule_steam_1005')
		end
	end 
	return pvp_mine_rule;
end

function CHECK_PVP_MINE_ZONE_OPEN()
	local pvp_mine_rule = SCR_PVP_MINE_GET_REGION_RULE()

	local diff = PVP_MINE_GET_DIFF_TIME()
	if diff > 1200 then
		return nil,"NotActiveTimePVP"
	elseif diff > 840 then
		return pvp_mine_rule.FirstStartMap
	elseif diff >= 0 then
		return pvp_mine_rule.FirstStartMap,"pvp_mine_enter_5min"
	elseif diff > -360 then
		return pvp_mine_rule.SecondStartMap
	elseif diff > -900 then
		return pvp_mine_rule.SecondStartMap,"pvp_mine_enter_5min"
	end
	return nil,"NotActiveTimePVP"
end

function PVP_MINE_GET_DIFF_TIME()
	local now_time = os.date('*t')
	local year = now_time['year']
	local month = now_time['month']
	local day = now_time['day']
	local hour = now_time['hour']
	local min = now_time['min']
	local sec = now_time['sec']

	local now = hour * 3600 + min * 60 + sec
	local pvp_mine_rule = SCR_PVP_MINE_GET_REGION_RULE()
	local pvp_time = 20 * 3600 + 30 * 60
	if pvp_mine_rule ~= nil then
		pvp_time = pvp_mine_rule.StartHour * 3600 + pvp_mine_rule.SecondStartMin * 60
	end
	return pvp_time - now
end