

function FLAGGAME_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg("LAYER_PC_LIST_UPDATE", "FLAGGAME_LAYER_PC_UPDATE");
	addon:RegisterOpenOnlyMsg("MGAME_VALUE_UPDATE", "FLAGGAME_MGAME_VALUE_UPDATE");
	addon:RegisterOpenOnlyMsg("MGAME_SOBJ_UPDATE", "FLAGGAME_SOBJ_UPDATE");
	
end

function AUTO_REVIVE_UI(revTime)

	local frame = ui.GetFrame("gaugetext");
	START_TIME_ACTION(frame, ScpArgMsg("ReviveSomeTimeLater"), revTime);
	frame:SetDuration(revTime);

end

function STOP_AUTO_REVIVE_UI()
	local frame = ui.GetFrame("gaugetext");
	STOP_TIEM_ACTINO(frame);
end


function FLAGGAME_LAYER_PC_UPDATE(frame)
	
	local gbox_ctrlset = frame:GetChild("gbox_ctrlset");
	local teamInfo = session.mission.GetTeam(1);
	gbox_ctrlset:RemoveAllChild();
	if teamInfo ~= nil then
		local teamList = teamInfo:GetPCList();
		local cnt = teamList:size();
		local picWidth = 30;
		for i = 0 , cnt - 1 do
			local pcInfo = teamList:at(i);
			local ctrlSet = gbox_ctrlset:CreateControlSet("flaggame_score", "CTRLSET_" .. pcInfo:GetCID(), 0, 0);
			FLAGGAME_INIT_CONTROLSET(ctrlSet, pcInfo);
		end
		
		GBOX_AUTO_ALIGN(gbox_ctrlset, 0, 0, 0, true, false);
		
	end
end

function FLAGGAME_INIT_CONTROLSET(ctrlSet, pcInfo)

	local txt_name = ctrlSet:GetChild("txt_name");
	local mySession = session.GetMySession();
	local cid = mySession:GetCID();
	if cid == pcInfo:GetCID() then
		txt_name:SetTextByKey("value", "{#0000FF}" .. pcInfo.name);
	else
		txt_name:SetTextByKey("value", pcInfo.name);
	end

	local img = GET_JOB_ICON(pcInfo:GetIcon().job);
	local pic = GET_CHILD(ctrlSet, "pic");
	pic:SetImage(img);
	local txt_score1 = ctrlSet:GetChild("txt_score1");
	txt_score1:SetTextByKey("value", "0");
	FLAGGAME_SET_CTRLSET_ROUNDSCORE(ctrlSet, 0);

end

function FLAGGAME_SET_CTRLSET_ROUNDSCORE(ctrlSet, roundScore)

	local gbox_roundscore = ctrlSet:GetChild("gbox_roundscore");
	for i = 1 , 3 do
		local pic = GET_CHILD(gbox_roundscore, "pic_" .. i);
		if roundScore >= i then
			pic:ShowWindow(1);
		else
			pic:ShowWindow(0);
		end 
	end
end

function FLAGGAME_SOBJ_UPDATE(frame, msg, cid)

	local gbox_ctrlset = frame:GetChild("gbox_ctrlset");
	local ctrlSet = gbox_ctrlset:GetChild("CTRLSET_" .. cid);
	if ctrlSet == nil then
		return;
	end

	local teamInfo = session.mission.GetTeam(1);
	local pcInfo = teamInfo:GetByCID(cid);
	if pcInfo == nil then
		return;
	end

	local obj = GetIES(pcInfo:GetIESObject());
	local txt_score1 = ctrlSet:GetChild("txt_score1");
	txt_score1:SetTextByKey("value", obj.Point);
end

function FLAGGAME_START_C(actor)

	local mgameInfo = session.mission.GetMGameInfo();
	local startTime = mgameInfo:GetUserValue("Battle_START");
	local roundMaxTime = mgameInfo:GetUserValue("RoundMaxTime");
	local elapsedTime = GetServerAppTime() - startTime;
	local remainTime = roundMaxTime - elapsedTime;
	
	local frame = ui.GetFrame("flaggame");
	local timer = GET_CHILD(frame, "timer");
	START_TIMER_CTRLSET_BY_SEC(timer, remainTime, roundMaxTime);

end

function FLAGGAME_END_C(actor)

	local frame = ui.GetFrame("flaggame");
	local timer = GET_CHILD(frame, "timer");
	timer:ShowWindow(0);

	local txt_round = frame:GetChild("txt_round");
	txt_round:ShowWindow(0);

end

function FLAGGAME_MGAME_VALUE_UPDATE(frame, msg, key, value)
	if key == "Round" then
		local txt_round = frame:GetChild("txt_round");
		txt_round:SetTextByKey("value", string.format("%d", value));
	end

end







