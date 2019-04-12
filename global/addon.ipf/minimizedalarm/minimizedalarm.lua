function MINIMIZEDALARM_ON_INIT(addon, frame)
	
	addon:RegisterMsg('PVP_PLAYING_UPDATE', 'ON_PVP_PLAYING_UPDATE'); 
	addon:RegisterMsg('PARTY_COMPETITION_STATE', 'ON_PVP_PLAYING_UPDATE'); 

end

function ON_PVP_PLAYING_UPDATE(frame)

	if true == IsHaveCommandLine("-NOPVP") then
		frame:ShowWindow(0);
		return;
	end

	if session.IsMissionMap() == true then
		frame:ShowWindow(0);
		return;
	end

	local partyCount = session.party.GetPartyCompetitionStates();
	local cnt = session.worldPVP.GetPlayTypeCount();
	local partySize = partyCount:size();
	if cnt == 0 and partySize == 0 then
		frame:ShowWindow(0);
		return;
	end
		frame:ShowWindow(1);
	local playGuildBattle = false;
	for i = 0, cnt -1 do
		local type = session.worldPVP.GetPlayTypeByIndex(i);
		if type == 200 then
			playGuildBattle = true;
			break;
		end
	end
		local gbox = frame:GetChild("gbox");
		local gbox_mission = frame:GetChild("gbox_mission");
		if cnt == 0 then
			gbox:ShowWindow(0);
		else

			local pic = gbox:GetChild("pic");
		tolua.cast(pic, "ui::CPicture");
		if false == playGuildBattle then
			pic:SetEventScript(ui.LBUTTONUP, "OPEN_PVP_FRAME");
			pic:SetImage('journal_pvp_icon');			
		else
			if 0 == session.worldPVP.GetRemainSecondToNextSeason() then
				worldPVP.RequestPVPInfo();
				worldPVP.RequestGuildBattlePrevSeasonTop(200);
			end
			pic:SetEventScript(ui.LBUTTONUP, "OPEN_GUILDBATTLE_FRAME");
			pic:SetImage('journal_guild_icon');
		end
		end


	if partySize > 0 then
		gbox_mission:ShowWindow(1);
	
		local pic = gbox_mission:GetChild("pic");
		if nil ~= pic then
		pic:SetEventScript(ui.LBUTTONUP, "OPEN_PARTY_COMPETITION");
		else
			gbox_mission:ShowWindow(0);
		end
	
	else
		gbox_mission:ShowWindow(0);
	end				
end

function WORLDPVP_START_ICON_NOTICE()
	local frame = ui.GetFrame("minimizedalarm");
	local gbox = frame:GetChild("gbox");
	local pic = gbox:GetChild("pic");
	UI_PLAYFORCE(pic, "emphasize_pvp", 0, 0);
end

function OPEN_PVP_FRAME(frame)
	ui.OpenFrame("worldpvp");
	frame = frame:GetTopParentFrame();
	frame:ShowWindow(0);

	local guildbattle_league =  ui.GetFrame("guildbattle_league");
	guildbattle_league:ShowWindow(0);
	

	local pvpFrame = ui.GetFrame("worldpvp");
	local tab = GET_CHILD(pvpFrame, "tab");
	if tab ~= nil then
		tab:SelectTab(0);
	end
end

function OPEN_GUILDBATTLE_FRAME(frame)
	ui.OpenFrame("guildbattle_league");
	frame = frame:GetTopParentFrame();
	frame:ShowWindow(0);
	
	local worldpvp =  ui.GetFrame("worldpvp");
	worldpvp:ShowWindow(0);
	
	OPEN_GUILDBATTLE_RANKING_FRAME();
	local pvpFrame = ui.GetFrame("guildbattle_league");
	local tab = GET_CHILD(pvpFrame, "tab");
	if tab ~= nil then
		tab:SelectTab(0);
	end
end


function OPEN_PARTY_COMPETITION(parent, ctrl)

	local frame = ui.GetFrame("partycompetitionlist");
	frame:ShowWindow(1);
	UPDATE_PARTY_COMPETITION_LIST(frame);
	

end

