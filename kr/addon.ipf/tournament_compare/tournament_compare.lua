
function TOURNAMENT_COMPARE_ON_INIT(addon, frame)


end


function TOURNA_PROP_INSERT(frame, queue, title, targetValue)
	local set = queue:CreateOrGetControlSet("pvp_prop_set", "SETS_" .. title, ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	set:ShowWindow(1);
	local t_title = set:GetChild("t_title");
	t_title:SetTextByKey("value", ClMsg(title));
	local v_target = set:GetChild("v_target");
	v_target:SetTextByKey("value", targetValue);
	
end

function CLOSE_TNMT_COMPARE(cid)
	ui.CloseFrame("tournament_compare_" .. cid);
end

function OPEN_TNMT_COMPARE(cid, argStr)

	local info = session.otherPC.GetByStrCID(cid);
	if info == nil then
		return;
	end

	local frame = ui.CreateNewFrame("tournament_compare", "tournament_compare_" .. cid, 0);
	frame:ShowWindow(1);
	
	if argStr == nil then
		local xPos = 0;
		local y = (ui.GetClientInitialHeight() - frame:GetHeight()) / 2;
		frame:SetOffset(xPos, y);
	else
		local mgameInfo = session.mission.GetMGameInfo();
		local pcCount = mgameInfo:GetUserValue("Tournament_PCCount");

		frame:SetUserValue("FACTION", argStr);
		local xPos = 0;
		local y = ui.GetClientInitialHeight() / 2;
		local cnt = ui.GetVisibleFrameCountByUserValue("FACTION", argStr);
		if pcCount % 2 == 1 then
			y = y - frame:GetHeight() / 2;
		end

		y = y + frame:GetHeight() * (cnt - pcCount);
		
		local centerSpace = 50;
		if argStr == "Team_1" then
			local width =  ui.GetClientInitialWidth();
			xPos = width / 2 - frame:GetWidth() * 1.0 - centerSpace;
		elseif argStr == "Team_2" then
			local width =  ui.GetClientInitialWidth();
			xPos = width / 2 + centerSpace;
		end

		frame:SetOffset(xPos, y);
	end

	local obj = GetIES(info:GetObject());
	local etcObj = GetIES(info:GetETCObject());
	local icon = ui.CaptureModelHeadImage_IconInfo(info:GetIconInfo());

	TOURNAMENT_UPDATE_PROP_BY_INFO(frame, obj, etcObj, icon);
	
	local queue = frame:GetChild("queue");
	DESTROY_CHILD_BYNAME(queue, "SETS_");
	TOURNA_PROP_INSERT(frame, queue, "Level", obj.Lv);
	TOURNA_PROP_INSERT(frame, queue, "JournalRank", info:GetOtherpcWikiRanking(WIKI_TOTAL) + 1);
	TOURNA_PROP_INSERT(frame, queue, "JournalScore", info.wikiTotalScore);
	TOURNA_PROP_INSERT(frame, queue, "MAXATK", obj.MAXATK);

	queue:UpdateData();
	frame:Invalidate();
	return frame;
end

function CLOSE_TNMT_COMPARE(cid, argStr)
	ui.CloseFrame("tournament_compare_" .. cid);
end


