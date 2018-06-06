--- statue_shared.lua


function GET_PVP_STATUEPOSITION(ranking)

	if ranking == 1 then
		return "c_fedimian", 555, -72, -90;
	elseif ranking == 2 then
		return "c_fedimian", 508, -45, -90;
	elseif ranking == 3 then
		return "c_fedimian", 535, -45, -90;
	elseif ranking == 4 then
		return "c_fedimian", 562, -45, -90;
	else
		return "c_fedimian", 590, -45, -90;
	end	

end


function GET_JOURNAL_STATUE_POSITION(ranking)

	if ranking == 1 then
		return "c_Klaipe", -878, 167, 0
	elseif ranking == 2 then
		return "c_Klaipe", -861, 214, 0
	elseif ranking == 3 then
		return "c_Klaipe", -844, 262, 0
	elseif ranking == 4 then
		return "c_Klaipe", -827, 309, 0
	else
		return "c_Klaipe", -811, 357, 0
	end	

end


function GET_JOB_NAME(jobCls, gender)
	local jobName = "";
	
	if TryGetProp(jobCls, "Name") then
		jobName = jobCls.Name;
	end

	local jobClassName = TryGetProp(jobCls, "ClassName");
	if jobClassName == "Char4_18" then
		if gender == "Male" or gender == 1 then
			jobName = ScpArgMsg('Kannushi');
		end
	end
	return jobName;	
end