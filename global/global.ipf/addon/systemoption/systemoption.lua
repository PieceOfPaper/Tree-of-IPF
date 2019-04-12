function INIT_SCREEN_CONFIG(frame)

	local getGroup = GET_CHILD_RECURSIVELY(frame, "pipwin_low", "ui::CGroupBox")
	local getPipwin_low = GET_CHILD_RECURSIVELY(frame, "pipwin_low", "ui::CGroupBox")
	local catelist = GET_CHILD_RECURSIVELY(frame, "resolutionList", "ui::CDropList");
	catelist:ClearItems();

	local curWidth = option.GetClientWidth();
	local curHeight = option.GetClientHeight();
	local selIndex = 0;

	local cnt = option.GetDisplayModeCount();

	for i = 0 , cnt - 1 do
		local width = option.GetDisplayModeWidth(i);
		local height = option.GetDisplayModeHeight(i);
		local resString = string.format("{@st42b}%d * %d{/}", width, height);
		catelist:AddItem(i, resString);

		if curWidth == width and curHeight == height then
			selIndex = i;
		end
	end

	catelist:SelectItem(selIndex);
	local scrMode = option.GetScreenMode();
	local scrBtn = GET_CHILD_RECURSIVELY(frame,"scrtype_" .. scrMode,"ui::CRadioButton");
	if scrBtn ~= nil then
		scrBtn:Select();
	end

	local autoPerfMode = config.GetAutoAdjustLowLevel();
	local autoPerfBtn = GET_CHILD_RECURSIVELY(frame,"perftype_" .. autoPerfMode);
	if autoPerfBtn ~= nil then
		autoPerfBtn:Select();
	end
	
	local chkOptimization = GET_CHILD_RECURSIVELY(frame, "check_optimization", "ui::CCheckBox");
	if nil ~= chkOptimization then
		chkOptimization:SetCheck(imcperfOnOff.IsEnableOptimization());
	end;

	local syncMode = option.IsEnableVSync()
	local syncBtn = GET_CHILD_RECURSIVELY(frame,"vsync_" .. syncMode,"ui::CRadioButton");
	if syncBtn ~= nil then
		syncBtn:Select()
	end

end