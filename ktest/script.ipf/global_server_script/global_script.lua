function SCR_SOCCER_EVENT_LOG()
	local curSettedResetTime = GetWorldProperty('SoccerEvent');
	local goalGameTypeName = 'Penalty_Goal_';
	local missionGameTypeName = 'SOCCER_MISSION_S';
	if curSettedResetTime == '2018061406' then
		goalGameTypeName = goalGameTypeName..'1';
		missionGameTypeName = missionGameTypeName..'1';
	elseif curSettedResetTime == '2018062806' then
		goalGameTypeName = goalGameTypeName..'2';
		missionGameTypeName = missionGameTypeName..'2';
	else
		IMC_LOG('ERROR_LOGIC', 'SCR_SOCCER_EVENT_LOG: SoccerEvent ResetTime Error['..curSettedResetTime..']');
	end

    WriteRedisLog('EventFootBall', goalGameTypeName, 5, 'SoccerEvent', goalGameTypeName);
    WriteRedisLog('EVENT_1806_SOCCER', missionGameTypeName, 3, 'SoccerEvent', missionGameTypeName);
end