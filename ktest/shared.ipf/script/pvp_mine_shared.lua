
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
	
	local now_time = os.date('*t')
	local hour = now_time['hour']
	local min = now_time['min']

	local firstStartTime = pvp_mine_rule.StartHour*60+pvp_mine_rule.FirstStartMin
	local secondStartTime = pvp_mine_rule.StartHour*60+pvp_mine_rule.SecondStartMin
	local nowTime = hour * 60 + min
	if nowTime - firstStartTime >= 0 and secondStartTime + 15 - nowTime >= 0 then
		if nowTime - firstStartTime < 5 then
			return pvp_mine_rule.FirstStartMap
		elseif nowTime - secondStartTime < 0 then
			return pvp_mine_rule.FirstStartMap,"pvp_mine_enter_5min"
		elseif nowTime - secondStartTime < 5 then
			return pvp_mine_rule.SecondStartMap
		else
			return pvp_mine_rule.SecondStartMap,"pvp_mine_enter_5min"
		end
	end
	return nil,"NotActiveTimePVP"
end
