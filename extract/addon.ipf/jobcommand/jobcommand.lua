

function JOBCOMMAND_ON_INIT(addon, frame)
 
	addon:RegisterMsg("JOB_CHANGE", "JOBCOMMAND_JOB_CHANGE");
	
end 

function JOBCOMMAND_JOB_CHANGE(frame, msg, str, num)

	local job = GETMYPCJOB();
	local jobCls = GetClassByType("Job", job);
	local func = "JOBUI_" .. jobCls.EngName;
	func = _G[func];
	if func == nil then
		frame:ShowWindow(0);
	else
		frame:ShowWindow(1);
		func(frame);
	end

end

function JOB_COMMAND(commandIndex)
	if commandIndex == 2 then
		TEST_PARTY();
	end
	local job = GETMYPCJOB();
	local jobCls = GetClassByType("Job", job);
	local func = "JOBCOMMAND_" .. jobCls.EngName;
	func = _G[func];
	if func ~= nil then
		func(commandIndex);
	end
end


--[[
--- sorcerer
function JOBCOMMAND_Sorcerer(index)
	if index == 0 then

	elseif index == 1 then
		
	end
end

function JOBUI_Sorcerer(frame)
	
	local bg = frame:GetChild("bg");
	bg:RemoveAllChild();
	local y = 0;
	
	local hotKey = hotKeyTable.GetHotKeyString("JobCommand_1");	
	y = INSERT_RINGCOMMAND(bg, "RINGCMD_0", "icon_warri_Approach", hotKey, ClMsg("Ride"), y);
	hotKey = hotKeyTable.GetHotKeyString("JobCommand_2");	
	y = INSERT_RINGCOMMAND(bg, "RINGCMD_1", "icon_warri_Approach", hotKey, ClMsg("Attack"), y);
	GBOX_AUTO_ALIGN(bg, 10, 0, 50, true);

end

]]








