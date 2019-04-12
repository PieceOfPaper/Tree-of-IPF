--- trigger_pc.lua --

function TRIGGER_PC(handle)
    if session.colonywar.GetIsColonyWarMap() == true then
		return;
	end
	local targetInfo= info.GetTargetInfo(handle);
	if targetInfo.IsDummyPC == 1 then
		packet.DummyPCDialog(handle);
		return;
	end

	local cid = info.GetCID(handle);
	local info = session.otherPC.GetByStrCID(cid);
	if info == nil or info:GetAge() >= 10 then
		ui.PropertyCompare(handle, 1);
	else
		SHOW_PC_COMPARE(cid);
	end

end


function DIALOG_PERSONAL_SHOP_CHECK()
	return true;
end

function DIALOG_PERSONAL_SHOP(actor, isSelect)
	if isSelect == 1 then
		local sellBalloon = ui.GetFrame("SELL_BALLOON_" .. actor:GetHandleVal());
		if sellBalloon ~= nil then
			local sellType = sellBalloon:GetUserIValue("SELL_TYPE");
			session.autoSeller.RequestOpenShop(actor:GetHandleVal(), sellType);
		end
	end
end

