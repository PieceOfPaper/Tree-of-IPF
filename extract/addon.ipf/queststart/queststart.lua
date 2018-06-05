function QUESTSTART_ON_INIT(addon, frame)
 
	--addon:RegisterMsg('DIALOG_QUEST_START', 'QUESTSTART_ON_MSG');
	--addon:RegisterMsg('DIALOG_CLOSE', 'QUESTSTART_ON_MSG');
end 

function QUESTSTART_ON_MSG(frame, msg, argStr, argNum)
 
	if  msg == 'DIALOG_QUEST_START'  then 
		questObjective:Clear();
		local questID = argNum;
		local text = GetClassString('Quest', argNum, 'Scenario');
		questObjective:AddText(text, 'normal');
		frame:ShowWindow(1);
	end 

	if msg == 'DIALOG_CLOSE' then 
		frame:ShowWindow(0);
	end 
end 

