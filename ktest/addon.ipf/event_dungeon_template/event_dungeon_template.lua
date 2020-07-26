-- event_dungeon_template.lua

function ON_EVENT_DUNGEON_KILL_COUNT(frame, msg, argStr, argNum)
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
        textTimer:ShowWindow(0)

        local timer = GET_CHILD(frame, "challenge_time", "ui::CPicture")
        timer:ShowWindow(0)
        
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