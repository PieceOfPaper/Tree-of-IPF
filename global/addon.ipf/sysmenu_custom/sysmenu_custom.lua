function SYSMENU_CUSTOM_ON_INIT(addon, frame)

	addon:RegisterMsg("GAME_START", "SYSMENU_CUSTOM_UPDATE");
	addon:RegisterMsg("JOB_CHANGE", "SYSMENU_CUSTOM_UPDATE");
	
	SYSMENU_CUSTOM_LIST = {}

end

function SYSMENU_CUSTOM_UPDATE(frame) -- 게임 접속, 잡 체인징 시 돌아야 할 듯.
	local gBox = GET_CHILD(frame,'maingbox','ui::CGroupBox')
	gBox:RemoveAllChild();

	for i = 1 , #SYSMENU_CUSTOM_LIST do
		SYSMENU_CUSTOM_LIST[i] = nil
	end
	
	local clslist, cnt  = GetClassList("sysmenu_custom_list");

	for i = 0 , cnt - 1 do

		local cls = GetClassByIndexFromList(clslist, i);

		--local jobcls = GetClass("Job", cls.JobName);
		--local jobid = jobcls.ClassID

		local targetframe = ui.GetFrame(cls.ClassName)
		--if IS_HAD_JOB(jobid) == 1 and targetframe:CheckOpenCondScp() == true then
		if targetframe:CheckOpenCondScp() == true then -- 확장성을 위해서. 만일 직업전용 UI로만 sysmenu_custom을 쓴다면 그냥 해드잡으로 검사하면 약간 더 빠를 듯.
			local x = (#SYSMENU_CUSTOM_LIST) * 44
			local btn = gBox:CreateControl('button', 'btn_'..cls.ClassName, x, 36, 44, 44);
			tolua.cast(btn, "ui::CButton");
			
			btn:SetImage(cls.ImageName)
			btn:SetTextTooltip(cls.TextTooltip)
			btn:SetEventScript(ui.LBUTTONUP, "ui.ToggleFrame('".. cls.ClassName .."')", true);	
			frame:SetLayerLevel(96);

			SYSMENU_CUSTOM_LIST[#SYSMENU_CUSTOM_LIST + 1] = cls.ClassName
		end
	end

end

function SYSMENU_CUSTOM_HOTKEY_OPEN(index)

	local framename = SYSMENU_CUSTOM_LIST[index]

	if framename == nil then
		return
	end

	ui.ToggleFrame(framename);
end