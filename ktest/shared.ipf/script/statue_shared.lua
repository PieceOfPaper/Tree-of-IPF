--- statue_shared.lua


function GET_PVP_STATUEPOSITION(ranking)

--	if ranking == 1 then
--		return "c_fedimian", 555, -103, -90;
--	elseif ranking == 2 then
--		return "c_fedimian", 508, -45, -90;
--	elseif ranking == 3 then
--		return "c_fedimian", 535, -13, -90;
--	elseif ranking == 4 then
--		return "c_fedimian", 562, -13, -90;
--	else
--		return "c_fedimian", 590, -45, -90;
--	end	
	if ranking == 1 then
		return "c_Klaipe", -306, 663, -90
	elseif ranking == 2 then
		return "c_Klaipe", -334, 653, -90
	elseif ranking == 3 then
		return "c_Klaipe", -277, 673, -90
	elseif ranking == 4 then
		return "c_Klaipe", -363, 644, -90
	else
		return "c_Klaipe", -249, 683, -90
	end	

end


function GET_JOURNAL_STATUE_POSITION(ranking)

--	if ranking == 1 then
--		return "c_Klaipe", -306, 663, -90
--	elseif ranking == 2 then
--		return "c_Klaipe", -334, 653, -90
--	elseif ranking == 3 then
--		return "c_Klaipe", -277, 673, -90
--	elseif ranking == 4 then
--		return "c_Klaipe", -363, 644, -90
--	else
--		return "c_Klaipe", -249, 683, -90
--	end	

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