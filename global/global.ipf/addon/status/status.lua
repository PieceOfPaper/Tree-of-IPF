function STATUS_HIDDEN_JOB_UNLOCK_VIEW(pc, opc, frame, gboxctrl, y)
    local jobList, jobListCnt = GetClassList('Job');
    local etcObj = GetMyEtcObject();
   	for i = 0, jobListCnt-1 do
		local jobIES = GetClassByIndexFromList(jobList, i);
		if jobIES ~= nil then
		    if jobIES.HiddenJob == 'YES' then
		        local flag = false
		        if jobIES.ClassName == 'Char4_12' then
		            local jobCircle = session.GetJobGrade(GetClassNumber('Job','Char4_2','ClassID'))
		            if jobCircle >= 3 then
		                flag = true
		            end
		        else
		            flag = true
		        end
		        if flag == true and ( etcObj["HiddenJob_"..jobIES.ClassName] == 300 or IS_KOR_TEST_SERVER()) then
                    local hidden_job = gboxctrl:CreateControl('richtext', 'HIDDEN_JOB_'..jobIES.ClassName, 10, y, 100, 25);
                    hidden_job:SetText('{@sti8}'..ScpArgMsg("HIDDEN_JOB_UNLOCK_VIEW_MSG1","JOBNAME",jobIES.EngName))
                    y = y + 25
                end
		    end
		end
	end
    return y
end