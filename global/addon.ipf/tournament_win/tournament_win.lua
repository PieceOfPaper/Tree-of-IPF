
function TOURNAMENT_WIN_ON_INIT(addon, frame)

	addon:RegisterMsg("TOURNAMENT_WIN", "ON_TOURNAMENT_WIN");

end

function GET_TEAM_TEXT(mgameInfo, team, imgSize)
	local ret = "";
	for i = 0 , team:GetPCCount() - 1 do
		if i ~= 0 then
			ret = ret .. " ";
		end

		local pc = team:GetPC(i);
		local rewardInfo = mgameInfo:GetRewardByCID(pc:GetCID());
		local iconName = ui.CaptureModelHeadImage_IconInfo(pc:GetIcon());
		ret = ret .. string.format("{img %s %d %d} %s", iconName, imgSize, imgSize, pc:GetName());

		if rewardInfo ~= nil then
			local exp = rewardInfo.exp;
			local itemCnt = rewardInfo:GetItemCount();
			local rewardTxt = string.format("Exp : %s", GetCommaedText(exp));
			for j = 0 , itemCnt - 1 do
				local item = rewardInfo:GetItemByIndex(j);
				local itemCls = GetClassByType("Item", item.type);
				rewardTxt = rewardTxt .. string.format(" {img %s 24 24}%s", itemCls.Icon, GetCommaedText(item.count));
			end

			ret = ret .. " " .. string.format("[%s]", rewardTxt);
		end
	end

	return ret;
end

function ON_TOURNAMENT_WIN(frame)

	local mgameInfo = session.mission.GetMGameInfo();
	local totalCnt = mgameInfo:GetTeamCount();
	if totalCnt == 0 then
		return;
	end

	frame:ShowWindow(1);

	local needWinCnt = mgameInfo.needWinCnt;
	local pcCount  = math.pow(2, needWinCnt);

	local winTeam = mgameInfo:GetTeam(0);
	local winText = GET_TEAM_TEXT(mgameInfo, winTeam, 80);
	local winner = frame:GetChild("winner");
	winner:SetTextByKey("text", winText);
		
	local gbox = frame:GetChild("rankers");
	local queue = GET_CHILD(gbox, "queue", "ui::CQueue");
	queue:RemoveAllChild();

	for i = 1 , totalCnt - 1 do
		local text = queue:CreateOrGetControl('richtext', "RANK_" .. i, 200, 30, ui.LEFT, ui.TOP, 0, 0, 0, 0);
		text = tolua.cast(text, "ui::CRichText");
		text:SetMaxWidth(queue:GetWidth() - 100);

		local team = mgameInfo:GetTeam(i);
		local topCnt = math.floor(pcCount / math.pow(2, team.step - 1));
		local topText;
		if topCnt <= 2 then
			topText = ClMsg("FinalMatch");
		else
			topText  = ScpArgMsg("Top{Auto_1}", "Auto_1", topCnt);
		end
		local txt = topText .. " " ..GET_TEAM_TEXT(mgameInfo, team, 48);
		text:SetText("{@st45}" .. txt);
	end

	queue:UpdateData();
end

