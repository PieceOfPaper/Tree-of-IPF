function CHARBASEINFO_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg('LEVEL_UPDATE', 'CHARBASEINFO_ON_MSG');
	addon:RegisterMsg('EXP_UPDATE', 'CHARBASEINFO_ON_MSG');
	addon:RegisterMsg('JOB_EXP_UPDATE', 'ON_JOB_EXP_UPDATE');
	addon:RegisterMsg('JOB_EXP_ADD', 'ON_JOB_EXP_UPDATE');

	addon:RegisterMsg('CHANGE_COUNTRY', 'CHARBASEINFO_ON_MSG');

end

function CHARBASEINFO_LBTNUP(frame, msg, argStr, argNum)
	local statusFrame = ui.GetFrame('status');
	if statusFrame:IsVisible() == 1 then
		statusFrame:ShowWindow(0);
	else
		statusFrame:ShowWindow(1);
	end
end


function ON_JOB_EXP_UPDATE(frame, msg, str, exp, tableinfo)
	local curExp = exp - tableinfo.startExp;
	local maxExp = tableinfo.endExp - tableinfo.startExp;
	if tableinfo.isLastLevel == true then
		curExp = tableinfo.before:GetLevelExp();
		maxExp = curExp;

		-- 전직이 가능해지면 클래스 & 스킬쪽 업데이트하기
		local skillAbilityFrame = ui.GetFrame('skillability')
		if skillAbilityFrame:IsVisible() == 1 then
			SKILLABILITY_ON_OPEN(skillAbilityFrame)
		end
	end

	local expObject = GET_CHILD(frame, 'skillexp', "ui::CGauge");
	expObject:SetPoint(curExp, maxExp);


	local skillLevelObject = GET_CHILD(frame, 'joblevel', "ui::CRichText");
	skillLevelObject:SetText('{@sti8}{s16}'..tableinfo.level);

	local percent = curExp / maxExp * 100;
	if percent > 100 then
		percent = 100.0;
	end

	expObject:SetTextTooltip(string.format("{@st42b}%.1f%% / %.1f%%{/}", percent, 100.0));
	
	local levelPercentObject    = GET_CHILD(frame, 'skillexppercent', 'ui::CRichText');
	levelPercentObject:SetText('{@st42b}{s14}'..string.format('%.1f',percent)..'{s14}%{/}');
	if str ~= nil and str ~= "None" and str ~= "" then
		SHOW_GET_JOBEXP(frame, str)
	end
end

function CHARBASEINFO_ON_MSG(frame, msg, argStr, argNum)
	if msg == 'EXP_UPDATE'  or  msg == 'STAT_UPDATE' or msg == 'LEVEL_UPDATE' or msg == 'CHANGE_COUNTRY' then
		local expGauge 			= GET_CHILD(frame, "exp", "ui::CGauge");
		local exp = session.GetEXP()
		local maxExp = session.GetMaxEXP()
		local percent = 0.0;
		ui.UpdateVisibleToolTips();
		if maxExp ~= 0 and maxExp > 0 then
			percent = exp / maxExp * 100;
			expGauge:SetPoint(exp, maxExp);
		elseif maxExp == 0 then
			percent = 100.0;
			expGauge:SetPoint(1,1);				
		end
		
		if percent > 100 then
			percent = 100.0;
		end

		local levelPercentObject    = GET_CHILD(frame, 'levelexppercent', 'ui::CRichText');
		levelPercentObject:SetText(''..string.format('{@st42b}{s14}%.1f',percent)..'{s14}%{/}');

		expGauge:SetTextTooltip(string.format("{@st42b}%.1f%% / %.1f%%{/}", percent, 100.0));
		local levelTextObject		= GET_CHILD(frame, "levelexp", "ui::CRichText");
		local level 				= info.GetLevel(session.GetMyHandle());
		levelTextObject:SetText('{@sti7}{s16}'..level);
		if argNum ~= nil and argNum ~= 0 then
			SHOW_GET_EXP(frame, argNum)
		elseif msg == 'LEVEL_UPDATE' and argNum == -1 then
			SHOW_GET_EXP(frame, -1)
		end

	end

end

function CHARBASEINFO_EXCHANGE()
    ui.ToggleFrame('charbaseinfo1')
    ui.ToggleFrame('charbaseinfo1name')
end


