

function CHAT_OBSERVER_ENABLE(count, aidList, teamIDList, iconList)

	local frame = ui.GetFrame("worldpvp_observer_chat");
	for i = 1 , 2 do
		local gbox = frame:GetChild("gbox_" .. i);
		gbox:RemoveAllChild();
	end
	
	frame:ShowWindow(1);
	if count == 0 then
		for i = 0 , frame:GetChildCount() - 1 do
			local child = frame:GetChildByIndex(i);
			if string.find(child:GetName(), "button") ~= nil or string.find(child:GetName(), "mainchat") ~= nil then
				child:ShowWindow(1)
			else
				child:ShowWindow(0)
			end
		end
		return;
	end

	local aniPCAID = nil;
	for i = 0 , count - 1 do
		local aid = aidList:Get(i);
		local iconInfo = iconList:GetByIndex(i);
		local gbox = frame:GetChild("gbox_" .. teamIDList:Get(i));

		local ctrlSet = gbox:CreateControlSet("pvp_observer_ctrlset", "CTRL_" .. i, ui.LEFT, ui.CENTER_VERT, 0, 0, 0, 0);
		ctrlSet:SetUserValue("AID", aid);
		if aniPCAID == nil then
			aniPCAID = aid;
		end

		ctrlSet:EnableHitTest(1);
		local pic = GET_CHILD(ctrlSet, "pic");

		local imgName = GET_JOB_ICON(iconInfo.job);
		pic:SetImage(imgName);
		local btn = ctrlSet:GetChild("btn");
		local text = ScpArgMsg("Observe{PC}", "PC", iconInfo:GetFamilyName());
		btn:SetTextTooltip(text);

	end

	for i = 1 , 2 do
		local gbox = frame:GetChild("gbox_" .. i);
		GBOX_AUTO_ALIGN_HORZ(gbox, 10, 10, 0, true, false);
	end

	if aniPCAID ~= nil then
		if camera.IsViewFocsedToSelf() == true then
			worldPVP.ReqObservePC(aniPCAID);
		end
	end

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