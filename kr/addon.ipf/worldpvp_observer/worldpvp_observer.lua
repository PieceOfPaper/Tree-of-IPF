

function DEAD_OBSERVER_ENABLE(count, aidList, teamIDList, iconList)

	if count == 0 then
		ui.CloseFrame("worldpvp_observer");
		return;
	end

	local frame = ui.GetFrame("worldpvp_observer");
	local gbox = frame:GetChild("gbox");
	gbox:RemoveAllChild();

	for i = 0 , count - 1 do
		local aid = aidList:Get(i);
		local iconInfo = iconList:GetByIndex(i);
		local ctrlSet = gbox:CreateControlSet("pvp_observer_ctrlset", "CTRL_" .. i, ui.LEFT, ui.CENTER_VERT, 0, 0, 0, 0);
		ctrlSet:SetUserValue("AID", aid);
		ctrlSet:EnableHitTest(1);
		local pic = GET_CHILD(ctrlSet, "pic");
		local imgName = GET_JOB_ICON(iconInfo.job);
		pic:SetImage(imgName);
		local btn = ctrlSet:GetChild("btn");
		local text = ScpArgMsg("Observe{PC}", "PC", iconInfo:GetFamilyName());
		btn:SetTextTooltip(text);

	end

	GBOX_AUTO_ALIGN_HORZ(gbox, 10, 10, 0, true, false);
	frame:ShowWindow(1);

end

function PVP_OBSERVER_SELECT(parent, ctrl)

	local aid = parent:GetUserValue("AID");
	worldPVP.ReqObservePC(aid);

end

