---- companion.lua

function DIALOG_COMPANION(actor, isOn)
	local rider = actor:GetUserIValue("COMPANION_OWNER");
	if rider == session.GetMyHandle() then
		if isOn == 1 then
			SHOW_PET_RINGCOMMAND(actor);
		else	
			CLOSE_PET_RINGCOMMAND(actor);
		end
	end
end

function DIALOG_COMPANION_CHECK(actor)
	if 1 == 1 then
		return false;
	end

	local fsmActor = GetMyActor();
	if fsmActor:GetVehicleState() == true then
		return false;
	end

	return true;
end

function RIDE_COMPANION(companion, isRide)

	if isRide == 1 then
		ui.CloseFrame("ringcommand");
		companion = tolua.cast(companion, "CFSMActor");
		ui.CloseFrame("targetSpace_" .. companion:GetHandleVal());
	end

end

