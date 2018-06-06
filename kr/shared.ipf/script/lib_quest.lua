---- lib_quest.lua

function GET_END_QUEST_COUNT(sObj)

	if sObj == nil then
		return 0
	end

	local ret = 0;
	local cnt = geQuestTable.GetQuestPropertyCount();
	for i = 0 , cnt - 1 do
		local propName = geQuestTable.GetQuestProperty(i);
		if TryGetProp(sObj, propName) ~= nil and sObj[propName] == 300 then
			ret = ret + 1;
		end
	end

	return ret;
end

function GET_ICON_BY_STATE_MODE(state, questIES)
    local tail = GET_MARK_TAIL(questIES)
    local modeicon = 'MAIN'
    if tail == '_sub' then
        modeicon = 'SUB'
    elseif tail == '_repeat' then
        modeicon = 'REPEAT'
    elseif tail == '_period' then
        modeicon = 'PERIOD'
    elseif tail == '_party' then
        modeicon = 'PARTY'
    elseif tail == '_key' then
        modeicon = 'KEYQUEST'
    end
    
	if state == 'SUCCESS' then
		return "minimap_3_" ..modeicon;
	elseif state == 'PROGRESS' then
	    if questIES ~= nil and questIES.StartNPC ~= questIES.ProgNPC and questIES.StartNPC ~= questIES.EndNPC and questIES.ProgNPC == questIES.EndNPC then
	        local questIES_auto = GetClass('QuestProgressCheck_Auto',questIES.ClassName)
	        if questIES_auto ~= nil and ( questIES_auto.Progress_NextNPC == 'SUCCESS' or questIES_auto.Progress_NextNPC == 'ENDNPC') then
    	        return "minimap_3_" ..modeicon;
    	    end
	    end

        return "minimap_2_" .. modeicon;
	elseif state == 'POSSIBLE' then
		return "minimap_1_" .. modeicon;
	end

	return "minimap_0";
end

function GET_MARK_TAIL(questies)
    if questies.QuestMode == "MAIN" then
		return "", 1;
	elseif questies.PeriodInitialization ~= "None" then
	    return "_period", 0;
	elseif questies.QuestMode == "REPEAT" then
	    return "_repeat", 0;
	elseif questies.QuestMode == "SUB" then
	    return "_sub", 0;
	elseif questies.QuestMode == "PARTY" then
	    return "_party", 0;
	elseif questies.QuestMode == "KEYITEM" then
	    return "_key", 0;
	end
	
	return "_sub", 0;

end

function GET_PROGRESS_VALUE_BY_STRING(progressStr)
	if progressStr == 'POSSIBLE' then
		return 1;
	elseif progressStr == 'SUCCESS' then
		return 2;
	elseif progressStr == 'PROGRESS' then
		return 3;
	elseif progressStr == 'COMPLETE' then
		return 4;
	end
	return 0;
end
