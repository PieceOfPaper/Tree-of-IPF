
function EVENT_REWARD_NOTIFY_ON_INIT(addon, frame)
	addon:RegisterMsg('EVENT_REWARD_NOTIFY_INIT', 'EVENT_REWARD_NOTIFY_ON_MSG');
	addon:RegisterMsg('EVENT_REWARD_NOTIFY_ITEM_GET', 'EVENT_REWARD_NOTIFY_ON_MSG');
end

function EVENT_REWARD_NOTIFY_ON_MSG(frame, msg, argStr, argNum)
	if msg == "EVENT_REWARD_NOTIFY_INIT" then
		frame:ShowWindow(0);
		return;
	elseif msg == "EVENT_REWARD_NOTIFY_ITEM_GET" then	
		local argList = StringSplit(argStr, ';');
		if #argList ~= 2 then
			frame:ShowWindow(0);
			return;
		end

		EVENT_REWARD_NOTIFY_SHOW(frame, argList[1], argList[2])
		return;
	end
end

function EVENT_REWARD_NOTIFY_SHOW(frame, eventName, rewardName)	
	local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");

	local margin = tonumber(frame:GetUserConfig("TEXT_MARGIN"));
	local duration = tonumber(frame:GetUserConfig("DURATION"));
	local quotes = frame:GetUserConfig("QUOTES");
		
	local event_name = GET_CHILD(bg, "event_name", "ui::CRichText");
	event_name:SetTextByKey("value", "");
	event_name:SetTextByKey("value", quotes .. eventName .. quotes);
					
	local reward_name = GET_CHILD(bg, "reward_name", "ui::CRichText");
	reward_name:SetTextByKey("value", "");
	reward_name:SetTextByKey("value", rewardName);
		
	local width1 = event_name:GetWidth() + margin;
	local width2 = reward_name:GetWidth() + margin;
	local width = bg:GetOriginalWidth();

	if width < width1 then
		width = width1;
	end
	if width < width2 then
		width = width2;
	end
	bg:Resize(width, bg:GetHeight());

	if frame:GetWidth() < width then
		frame:Resize(width, frame:GetHeight())
	end

	frame:ShowWindow(1);
	frame:SetDuration(duration);
end