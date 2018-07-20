
-- statuscaption.lua


function StatueCaption_PVPStatue(handle, funcArg, familyName, pcName)

	local frame = ui.CreateNewFrame("statuecaption", "STATUE_CAPTION" .. handle);
	if frame == nil then
		return nil;
	end

	funcArg = tonumber(funcArg);
	local pvpType = math.floor(funcArg / 100);
	local ranking = math.mod(funcArg, 100);
	local title = GET_CHILD(frame, "title");
	local aniName = "None";
	local shaderName = "Statue";

	if ranking == 1 then
		title:SetTextByKey("title", ScpArgMsg("TeamBattleLeagueChampion"));
		aniName = "winner1";
	else
		title:SetTextByKey("title", ScpArgMsg("TeamBattleLeagueRank{Rank}", "Rank", ranking));		
	end

	local nameText = string.format("%s (%s)", familyName, pcName);
	title:SetTextByKey("name", nameText);

	FRAME_AUTO_POS_TO_OBJ(frame, handle, - frame:GetWidth() * 0.35, 20, 0, 1, 1);
	local result = 1.8 - ranking * 0.1;
	return aniName, shaderName, result; 
end


function StatueCaption_JournalStatue(handle, funcArg, familyName, pcName)

	local frame = ui.CreateNewFrame("statuecaption", "STATUE_CAPTION" .. handle);
	if frame == nil then
		return nil;
	end

	funcArg = tonumber(funcArg);
	local pvpType = math.floor(funcArg / 100);
	local ranking = math.mod(funcArg, 100);
	local title = GET_CHILD(frame, "title");
	local aniName = "None";
	local shaderName = "Statue";
	title:SetTextByKey("title", ScpArgMsg("JournalRank{Rank}", "Rank", ranking));
		
	local nameText = string.format("%s (%s)", familyName, pcName);
	title:SetTextByKey("name", nameText);

	FRAME_AUTO_POS_TO_OBJ(frame, handle, - frame:GetWidth() * 0.35, 20, 0, 1, 1);
	
	local result = 1.8 - ranking * 0.1;
	return aniName, shaderName, result;

end

function StatueCaption_FishRubbingStatue(handle, funcArg, familyName, pcName)
	local frame = ui.CreateNewFrame("statuecaption", "STATUE_CAPTION" .. handle);
	if frame == nil then
		return nil;
	end

	funcArg = tonumber(funcArg);
	local pvpType = math.floor(funcArg / 100);
	local ranking = math.mod(funcArg, 100);
	local title = GET_CHILD(frame, "title");
	local aniName = "BIGFISH";
	local shaderName = "GoldStatue";
	title:SetTextByKey("title", ScpArgMsg("RubbingScore{Rank}", "Rank", ranking));
		
	local nameText = string.format("%s (%s)", familyName, pcName);
	title:SetTextByKey("name", nameText);

	FRAME_AUTO_POS_TO_OBJ(frame, handle, - frame:GetWidth() * 0.35, 20, 0, 1, 1);
	
	local result = 1.8 - ranking * 0.1;
	return aniName, shaderName, result;
end