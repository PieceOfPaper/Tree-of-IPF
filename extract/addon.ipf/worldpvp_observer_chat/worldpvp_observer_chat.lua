

function CHAT_OBSERVER_ENABLE(count, aidList, teamIDList, iconList)

	if count == 0 then
		ui.CloseFrame("worldpvp_observer_chat");
		return;
	end

	local frame = ui.GetFrame("worldpvp_observer_chat");
	for i = 1 , 2 do
		local gbox = frame:GetChild("gbox_" .. i);
		gbox:RemoveAllChild();
	end
	
	for i = 0 , count - 1 do
		local aid = aidList:Get(i);
		local iconInfo = iconList:GetByIndex(i);
		local gbox = frame:GetChild("gbox_" .. teamIDList:Get(i));

		local ctrlSet = gbox:CreateControlSet("pvp_observer_ctrlset", "CTRL_" .. i, ui.LEFT, ui.CENTER_VERT, 0, 0, 0, 0);
		ctrlSet:SetUserValue("AID", aid);
		ctrlSet:EnableHitTest(1);
		local pic = GET_CHILD(ctrlSet, "pic");
		local imgName = ui.CaptureModelHeadImage_IconInfo(iconInfo);
		pic:SetImage(imgName);
		local btn = ctrlSet:GetChild("btn");
		local text = ScpArgMsg("Observe{PC}", "PC", iconInfo:GetFamilyName());
		btn:SetTextTooltip(text);

	end

	for i = 1 , 2 do
		local gbox = frame:GetChild("gbox_" .. i);
		GBOX_AUTO_ALIGN_HORZ(gbox, 10, 10, 0, true, false);
	end

	frame:ShowWindow(1);

end


function WORLDPVP_NICO_CHAT(parent, ctrl)

	local text = ctrl:GetText();
	if text ~= "" then
		worldPVP.RequestChat(text, true);
		ctrl:SetText("");
	end
	
end

function END_PVP_OBSERVER(parent, ctrl)
	worldPVP.ReturnToOriginalServer();
end
