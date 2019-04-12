
function MAP_EXPLORE_NOTIFY_ON_INIT(addon, frame)
	addon:RegisterMsg('MAP_EXPLORE_NOTIFY_INIT', 'MAP_EXPLORE_NOTIFY_ON_MSG');
	addon:RegisterMsg('MAP_EXPLORE_NOTIFY_COMPLETE', 'MAP_EXPLORE_NOTIFY_ON_MSG');
end

function MAP_EXPLORE_NOTIFY_ON_MSG(frame, msg, argStr, argNum)
	if msg == "MAP_EXPLORE_NOTIFY_INIT" then
		frame:ShowWindow(0);
		return;
	elseif msg == "MAP_EXPLORE_NOTIFY_COMPLETE" then
		local map_name = GET_CHILD(frame, "map_name", "ui::CRichText");
		map_name:SetTextByKey("value", argStr);
		frame:ShowWindow(1);
		frame:SetDuration(3);
		return;
	end
end