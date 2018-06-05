function QUESTEND_ON_INIT(addon, frame)
 
    local questThanksPt	= frame:GetChild('questthanks');
	questThanks			= tolua.cast(questThanksPt,"ui::CTextView");
	
	addon:RegisterMsg('DIALOG_QUEST_END', 'QUESTEND_ON_MSG');
	addon:RegisterMsg('DIALOG_CLOSE', 'QUESTEND_ON_MSG');
end 

function QUESTEND_ON_MSG(frame, msg, argStr, argNum)
 
	if  msg == 'DIALOG_QUEST_END'  then 
		questThanks:Clear();
		local text = GetClassString('Quest', argNum, 'Thanks');
		questThanks:AddText(text, 'normal');
		frame:ShowWindow(1);
	end 

	if msg == 'DIALOG_CLOSE' then 
		frame:ShowWindow(0);
	end 
end 

