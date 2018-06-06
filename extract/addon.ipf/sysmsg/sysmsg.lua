function SYSMSG_ON_INIT(addon, frame)

	--¸Þ½ÃÁö
	addon:RegisterMsg('QUEST_START', 'SYSMSG_ON_MSG');
	addon:RegisterMsg('QUEST_END', 'SYSMSG_ON_MSG');
end
function SYSMSG_ON_MSG(frame, msg, argStr, argNum)
	
	if  msg ==  'QUEST_START' then 
	
				
		local subTextObj		= frame:GetChild('sysgropubox');
		local subTextGroupBox 	= tolua.cast(subTextObj, "ui::CGroupBox");
		local subTextCtrl 		= subTextGroupBox:GetChild('sysmsginfo'); 
		local subText			= tolua.cast(subTextCtrl, "ui::CRichText");
		local text 			= GetClassString('Quest', argNum, 'StartHelp');
		
		if text ~= 'None' then
			subText:SetText('{s15} ' .. text);
			ui.OpenFrame('sysmsg');
		end
	elseif  msg ==  'QUEST_END' then
	
		local subTextObj		= frame:GetChild('sysgropubox');
		local subTextGroupBox 	= tolua.cast(subTextObj, "ui::CGroupBox");
		local subTextCtrl 		= subTextGroupBox:GetChild('sysmsginfo'); 
		local subText			= tolua.cast(subTextCtrl, "ui::CRichText");
		local text 			= GetClassString('Quest', argNum, 'EndHelp');
		
		if text ~= 'None' then
			subText:SetText('{s15} ' .. text);
			ui.OpenFrame('sysmsg');
		end
	end	
end 
