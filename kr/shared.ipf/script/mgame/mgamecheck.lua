--- mgamecheck.lua

function TOURNAMENT_CHECK(pc)
	return 1;
end

function CHECK_MGAME_COMMON(pc, mGame)
	if mGame.minLv > 0 and pc.Lv < mGame.minLv then
	    return 0;
	end

	if mGame.maxLv > 0 and pc.Lv > mGame.maxLv then
	    return 0;
	end

	return 1;
end

function CALCULATE_ELO_SYSTEM_POINT(pvpType, pvpObjList)
    
    local totalScoreA = 0
    local totalScoreB = 0
    
	local teamCountA = 0
	local teamCountB = 0
	
	local winScoreA = 0
	local loseScoreA = 0
	local winScoreB = 0
	local loseScoreB = 0
	
	local Kfactor = 50
	
	for i = 1, #pvpObjList do
		local pvpObj = tolua.cast(pvpObjList[i], "PVP_OBJECT");

		local team = pvpObj:GetPropIValue(pvpType .. "_TEAM");
		local score = pvpObj:GetPropIValue(pvpType .. "_POINT");
		
		if team == 1 then
		    totalScoreA = totalScoreA + score
	        teamCountA = teamCountA + 1
	    else
	        totalScoreB = totalScoreB + score
	        teamCountB = teamCountB + 1
	    end
	end

	local averageScoreA = totalScoreA / teamCountA
	local averageScoreB = totalScoreB / teamCountB
	
	local qA = averageScoreA / (averageScoreA + averageScoreB)
	local qB = averageScoreB / (averageScoreA + averageScoreB)
	local sA = 1
	local sB = 0.3
    
	local winScoreA = math.floor((sA - qA) * Kfactor)
	local loseScoreA = math.floor((sB - qA) * Kfactor)
	local winScoreB = math.floor((sA - qB) * Kfactor)
	local loseScoreB = math.floor((sB - qB) * Kfactor)
	
	for i = 1, #pvpObjList do
		local pvpObj = tolua.cast(pvpObjList[i], "PVP_OBJECT");
		
		local team = pvpObj:GetPropIValue(pvpType .. "_TEAM");
    	if team == 1 then
        	pvpObj:SetPropIValue(pvpType .. "_WINPOINT", winScoreA);
        	pvpObj:SetPropIValue(pvpType .. "_LOSEPOINT", loseScoreA);
        else
            pvpObj:SetPropIValue(pvpType .. "_WINPOINT", winScoreB);
    	    pvpObj:SetPropIValue(pvpType .. "_LOSEPOINT", loseScoreB);
    	end
    end
end