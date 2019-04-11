function SELECTCHARMENU_ON_INIT(addon, frame)

	addon:RegisterMsg("SELECTCHARACTER_OPEN", "SELECTCHARMENU_ON_MSG")
	addon:RegisterMsg("SELECTCHARACTER_CLOSE", "SELECTCHARMENU_ON_MSG")

end

function SELECTCHARMENU_ON_MSG(frame, msg, argStr, argNum)
	if msg == "SELECTCHARACTER_OPEN" then

		local selObj = barrack.GetSelectedObject();
		if selObj == nil or false == GetBarrackSystem(selObj):IsMyAccount() then
			frame:ShowWindow(0);
		else
			frame:ShowWindow(1);
		end		
	elseif msg == "SELECTCHARACTER_CLOSE" then
		frame:ShowWindow(0);
	end
end

function TOGGLE_BARRACK_POSE_UI(frame)

	local social = ui.GetFrame("social");
	if social:IsVisible() == 1 then
		social:ShowWindow(0);
	else
		social:ShowWindow(1);
		SOCIAL_VIEW_CHANGE(social, nil, "pose", nil);
	end

end




