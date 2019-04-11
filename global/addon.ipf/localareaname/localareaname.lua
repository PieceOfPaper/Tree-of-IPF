function LOCALAREANAME_ON_INIT(addon, frame)
 
	addon:RegisterMsg('LOCALAREA_ENTER', 'LOCALAREANAME_ON_MSG');
	addon:RegisterMsg('LOCALAREA_LEAVE', 'LOCALAREANAME_ON_MSG');
end 

function LOCALAREANAME_ON_MSG(frame, msg, argStr, argNum)
 
	if msg == 'LOCALAREA_ENTER' then 
		local LocalNameObject 		= frame:GetChild('localname');
		local LocalNameControl		= tolua.cast(LocalNameObject, "ui::CRichText");
		local text 					= GetClassString('AreaName', argStr, 'Text');
		
		LocalNameControl:SetText('{s30} ' .. text);

		frame:ShowWindow(1);
		frame:SetDuration(5);
	end 

	if msg == 'LOCALAREA_LEAVE' then 
		frame:ShowWindow(0);
	end 
end 