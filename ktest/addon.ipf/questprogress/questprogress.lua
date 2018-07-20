function QUESTPROGRESS_ON_INIT(addon, frame)
 
    local questHintPt	= frame:GetChild('questhint');
	questHint		= tolua.cast(questHintPt,"ui::CTextView");
	
	addon:RegisterMsg('DIALOG_QUEST_PROGRESS', 'QUESTPROGRESS_ON_MSG');
	addon:RegisterMsg('DIALOG_CLOSE', 'QUESTPROGRESS_ON_MSG');
end 

function QUESTPROGRESS_ON_MSG(frame, msg, argStr, argNum)
 
	if  msg == 'DIALOG_QUEST_PROGRESS'  then 
		questHint:Clear();
		local text = GetClassString('Quest', argNum, 'Hint');
		questHint:AddText(text, 'normal');
		frame:ShowWindow(1);
	end 

	if msg == 'DIALOG_CLOSE' then 
		frame:ShowWindow(0);
	end 
end 

