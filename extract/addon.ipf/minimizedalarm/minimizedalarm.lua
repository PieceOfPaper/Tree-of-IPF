function MINIMIZEDALARM_ON_INIT(addon, frame)
	
	addon:RegisterMsg('PVP_PLAYING_UPDATE', 'ON_PVP_PLAYING_UPDATE'); 
	addon:RegisterMsg('PARTY_COMPETITION_STATE', 'ON_PVP_PLAYING_UPDATE'); 

end

function ON_PVP_PLAYING_UPDATE(frame)

	if true == IsHaveCommandLine("-NOPVP") then
		frame:ShowWindow(0);
		return;
	end

	local partyCount = session.party.GetPartyCompetitionStates();
	local cnt = session.worldPVP.GetPlayTypeCount();
	local partySize = partyCount:size();
	if cnt == 0 and partySize == 0 then
		frame:ShowWindow(0);
	else
		frame:ShowWindow(1);
		
		local gbox = frame:GetChild("gbox");
		local gbox_mission = frame:GetChild("gbox_mission");
		if cnt == 0 then
			gbox:ShowWindow(0);
		else
			gbox:ShowWindow(1);

			local pic = gbox:GetChild("pic");
			pic:SetEventScript(ui.LBUTTONUP, "OPEN_PVP_FRAME");
		end

		if partySize > 0 then
			gbox_mission:ShowWindow(1);

			local pic = gbox_mission:GetChild("pic");
			pic:SetEventScript(ui.LBUTTONUP, "OPEN_PARTY_COMPETITION");

		else
			gbox_mission:ShowWindow(0);
		end				

	end
end

function WORLDPVP_START_ICON_NOTICE()

	local frame = ui.GetFrame("minimizedalarm");
	local pic = frame:GetChild("pic");
	UI_PLAYFORCE(pic, "emphasize_pvp", 0, 0);
end


function OPEN_PVP_FRAME(frame)
	ui.OpenFrame("worldpvp");
	frame:ShowWindow(0);
end


function OPEN_PARTY_COMPETITION(parent, ctrl)

	local frame = ui.GetFrame("partycompetitionlist");
	frame:ShowWindow(1);
	UPDATE_PARTY_COMPETITION_LIST(frame);
	

end

