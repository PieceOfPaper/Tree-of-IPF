function DIALOG_ACCEPT_FIELD_DUNGEON_TEMPLATE_REJOIN()
	ui.MsgBox(ClMsg("Rift_Dungeon_Accept_ReJoin"), "ACCEPT_FIELD_DUNGEON_TEMPLATE_REJOIN", "None");
end

function ACCEPT_FIELD_DUNGEON_TEMPLATE_REJOIN()
	packet.AcceptFieldDungeonRejoin();
end

function ON_FIELD_DUNGEON_START_TIMER(frame, msg, argStr, argNum)
	if argStr == "Start" then
		ui.OpenFrame("eventtimer");
		local frame = ui.GetFrame("eventtimer");
		TIMER_SET_EVENTTIMER(frame, argNum);
		frame:ShowWindow(1);
		frame:SetTextByKey("title", "");
		frame:SetGravity(ui.RIGHT, ui.TOP);
		frame:SetMargin(0, -20, 250, 0);
	elseif argStr == "End" then
		ui.CloseFrame("eventtimer");
	end
end

function UPDATE_FIELD_DUNGEON_MINIMAP_MARK(name, x, y, z, isAlive)
	if isAlive == 1 then
		session.minimap.AddIconInfo(name, "trasuremapmark", x, y, z, ClMsg(name), true, nil, 1.5);
	else
		session.minimap.RemoveIconInfo(name);
	end
end

function ON_FIELD_DUNGEON_KILL_COUNT(frame, msg, argStr, argNum)
	local msgList = StringSplit(argStr, '#')
	if #msgList < 1 then
		return
	end

	if msgList[1] == "Set" then
		ui.OpenFrame("challenge_mode")
		frame:ShowWindow(1)

		local gauge_lv = math.floor((argNum + 1) / 3) + 1
		local gauge_no = argNum
		if gauge_lv > 4 then
			gauge_lv = 4
		end

		local challenge_pic_logo = GET_CHILD(frame, "challenge_pic_logo", "ui::CPicture")
		challenge_pic_logo:SetImage("challenge_level_text")

		local progressGauge = GET_CHILD(frame, "challenge_gauge_lv", "ui::CGauge")
		progressGauge:SetSkinName("challenge_gauge_lv" .. gauge_lv)
		progressGauge:SetMaxPointWithTime(0, 1, 0.1, 0.5)

		local picLevel = GET_CHILD(frame, "challenge_pic_lv", "ui::CPicture")
		picLevel:SetImage("challenge_gauge_no" .. gauge_no)

		local picMax = GET_CHILD(frame, "challenge_pic_max", "ui::CPicture")
		picMax:ShowWindow(0)
		picMax:StopUpdateScript("MAX_PICTURE_FADEINOUT")

		local textTimer = GET_CHILD(frame, "challenge_mode_timer", "ui::CPicture")
		textTimer:StopUpdateScript("CHALLENGE_MODE_TIMER")
		textTimer:SetTextByKey('time', "00:00");
	elseif msgList[1] == "Start" then
		frame:ShowWindow(1)

		local textTimer = GET_CHILD(frame, "challenge_mode_timer", "ui::CPicture")
		textTimer:StopUpdateScript("CHALLENGE_MODE_TIMER")
		textTimer:RunUpdateScript("CHALLENGE_MODE_TIMER")
		local curTime = imcTime.GetAppTimeMS()
		textTimer:SetUserValue("CHALLENGE_MODE_START_TIME", tostring(curTime))
		textTimer:SetUserValue("CHALLENGE_MODE_LIMIT_TIME", tostring(argNum))
	elseif msgList[1] == "Refresh" then
		frame:ShowWindow(1)

		local killCount = tonumber(msgList[2])
		local targetKillCount = tonumber(msgList[3])

		local progressGauge = GET_CHILD(frame, "challenge_gauge_lv", "ui::CGauge")
		progressGauge:SetMaxPointWithTime(killCount, targetKillCount, 0.1, 0.5)
		progressGauge:ShowWindow(1)

		local picMax = GET_CHILD(frame, "challenge_pic_max", "ui::CPicture");
		if killCount >= targetKillCount and picMax:IsVisible() == 0 then
			picMax:ShowWindow(1);
			picMax:RunUpdateScript("MAX_PICTURE_FADEINOUT", 0.01);
		end
	elseif msgList[1] == "End" then
		ui.CloseFrame("challenge_mode")
	end
end