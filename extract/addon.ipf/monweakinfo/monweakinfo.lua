function MONWEAKINFO_ON_INIT(addon, frame)

	addon:RegisterMsg('MON_WEAK_INFO_SET', 'ON_MON_WEAK_INFO_SET_MSG');

end

function ON_MON_WEAK_INFO_SET_MSG(frame, msg, iconName, handle)
	
	local targetinfo = info.GetTargetInfo(handle);
	local weakFrame = ui.GetFrame("monWeakInfo_"..handle);
	if targetinfo == nil or weakFrame == nil then
		return;
	end
	
	local image = weakFrame:GetChild('weak_img');
	tolua.cast(image, "ui::CPicture");

	if iconName == 'None' then
		image:ShowWindow(0);
		weakFrame:ShowWindow(0);
	else		
		image:SetEnableStretch(1);
		image:SetImage(iconName);
		image:ShowWindow(1);
	end
end