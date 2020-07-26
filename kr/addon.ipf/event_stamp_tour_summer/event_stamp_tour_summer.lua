function EVENT_STAMP_TOUR_SUMMER_ON_INIT(addon, frame)
	addon:RegisterMsg("EVENT_STAMP_TOUR_SUMMER_UI_OPEN_COMMAND", "ON_EVENT_STAMP_TOUR_UI_OPEN_COMMAND_SUMMER");
	addon:RegisterMsg("EVENT_STAMP_TOUR_REWARD_GET", "ON_EVENT_STAMP_TOUR_REWARD_GET");
end

function ON_EVENT_STAMP_TOUR_UI_OPEN_COMMAND_SUMMER(_,msg,argStr,argNum)
	--EVENT_2007_TOS_VACANCE
	local frame = ui.GetFrame("event_stamp_tour_summer")
	frame:SetUserValue("GROUP_NAME","EVENT_STAMP_TOUR_SUMMER")
	frame:SetUserValue("OPEN_TIME",argStr)
	ui.OpenFrame("event_stamp_tour_summer");
end