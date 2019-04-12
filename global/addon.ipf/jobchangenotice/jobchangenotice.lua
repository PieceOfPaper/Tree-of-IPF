function JOBCHANGENOTICE_ON_INIT(addon, frame)
	--addon:RegisterMsg('JOB_EXP_ADD', 'JOBCHANGENOTICE_UPDATE');
end

function JOBCHANGENOTICE_UPDATE(frame, msg, str, exp, tableinfo)

	if exp == 0 then
		return;
	end
	local jobLevel = tableinfo.level;

	local job = info.GetJob(session.GetMyHandle());
	local jobCls = GetClassByType('Job', job);
	local jobClsLevel = 1;	-- 여기작업시작할차례. 
	local clsList, cnt = GetClassList("Xp_Job");

	local jobMaxLevel = 0;
	for i=0, cnt-1 do
		local cls = GetClassByIndexFromList(clsList, i);

		local jobLevelStart, jobLevelEnd = string.find(cls.ClassName, '_'..jobClsLevel..'_');
		if jobLevelStart ~= nil then
			local jobLevelTemp = string.sub(cls.ClassName, jobLevelEnd + 1);
			jobMaxLevel = math.max(jobMaxLevel, tonumber(jobLevelTemp));
		end
	end

	if jobLevel >= jobMaxLevel then
		local titleTextCtrl = GET_CHILD(frame, 'title', 'ui::CRichText');
		local titleText = ScpArgMsg("JobChangeTitle", "Auto_1", jobLevel);
		titleTextCtrl:SetText('{@st41b}'..titleText..' !{/}');

		local jobName="";
		local jobClsList, jobCnt = GetClassList('Job');
		local findJobClsName = string.sub(jobCls.ClassName, 1, string.len(jobCls.ClassName) - 1);		
		for i=0, jobCnt-1 do
			local cls = GetClassByIndexFromList(jobClsList, i);

			local jobStart, jobEnd = string.find(cls.ClassName, findJobClsName);			
			if jobStart ~= nil and jobCls.ClassName ~= cls.Name then
				jobName = jobName..GET_JOB_NAME(cls)..', ';
			end
		end

		if jobName ~= "" then
			jobName = string.sub(jobName, 1, string.len(jobName) - 2);
		end

		local descTextCtrl = GET_CHILD(frame, 'desc', 'ui::CRichText');
		local descText = ScpArgMsg("JobChangeDesc","Auto_1", jobName);
		descTextCtrl:SetText('{s20}{#050505}'..descText..'{/}');

		frame:ShowWindow(1);
	end
end
