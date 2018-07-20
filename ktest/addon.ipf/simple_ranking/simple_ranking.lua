function SIMPLE_RANKING_ON_INIT(addon, frame)
end

function OPEN_SIMPLE_RANKING(_titleText, nameList, startRank, totalRankCount, myRank, myScore, totalRankerCountInRanking, isCharRank)	
	local frame = ui.GetFrame('simple_ranking');
	local titleText = GET_CHILD_RECURSIVELY(frame, 'titleText');
	titleText:SetTextByKey('title', _titleText);

	local nameHeaderText = GET_CHILD_RECURSIVELY(frame, 'nameHeaderText');
	if isCharRank == true then
		nameHeaderText:SetText(ClMsg('CharacterName'));
	else
		nameHeaderText:SetText(ClMsg('TeamName'));
	end

	local rankingListBox = GET_CHILD_RECURSIVELY(frame, 'rankingListBox');
	rankingListBox:RemoveAllChild();
	for i = 1, #nameList-1 do
		CREATE_SIMPLE_RANKING_CTRL(frame, rankingListBox, 'RANK_INFO_'..i, startRank + i, nameList[i], i % 2 == 1);
	end
	GBOX_AUTO_ALIGN(rankingListBox, 0, 0, 0, true, false);

	local myRankInfoBox = GET_CHILD_RECURSIVELY(frame, 'myRankInfoBox');
	if myRank > 0 then
		local myName = '';
		if isCharRank == true then
			local pc = GetMyPCObject();
			myName = pc.Name;
		else
			local myHandle = session.GetMyHandle();
			myName = info.GetFamilyName(myHandle);
		end

		local myInfoBox = CREATE_SIMPLE_RANKING_CTRL(frame, myRankInfoBox, 'MY_RANK_INFO', myRank, myName, false);
		myInfoBox:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);
	else
	    local myInfoBox = CREATE_SIMPLE_RANKING_CTRL(frame, myRankInfoBox, 'MY_RANK_INFO', '', '', false);
		myInfoBox:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);
	end

	frame:ShowWindow(1);
end

function CREATE_SIMPLE_RANKING_CTRL(frame, parent, ctrlName, rank, name, drawSkin)
	local ODD_INDEX_RANK_BG_SKIN = frame:GetUserConfig('ODD_INDEX_RANK_BG_SKIN');
	local RANK_CTRL_FONTNAME = frame:GetUserConfig('RANK_CTRL_FONTNAME');	
	local RANK_CTRL_HEIGHT = tonumber(frame:GetUserConfig('RANK_CTRL_HEIGHT'));
	local RANK_CTRL_OFFSET_RANK = tonumber(frame:GetUserConfig('RANK_CTRL_OFFSET_RANK'));
	local RANK_CTRL_OFFSET_NAME = tonumber(frame:GetUserConfig('RANK_CTRL_OFFSET_NAME'));

	local bgBox = parent:CreateControl('groupbox', ctrlName, 0, 0, parent:GetWidth(), RANK_CTRL_HEIGHT);
	if drawSkin == true then
		bgBox:SetSkinName(ODD_INDEX_RANK_BG_SKIN);
	else
		bgBox:SetSkinName('None');
	end

	local rankTextBox = bgBox:CreateControl('groupbox', 'rankTextBox', RANK_CTRL_OFFSET_RANK, 0, 50, 30);
	rankTextBox:SetSkinName('None');
	local rankText = rankTextBox:CreateControl('richtext', 'rankText', 0, 0, 100, 30);
	rankText:SetFontName(RANK_CTRL_FONTNAME);
	rankText:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);
	rankText:SetTextAlign(ui.CENTER_HORZ, ui.CENTER_VERT);
	rankText:SetText(rank);
	
	local nameTextBox = bgBox:CreateControl('groupbox', 'nameTextBox', RANK_CTRL_OFFSET_NAME, 0, 250, 30);
	nameTextBox:SetSkinName('None');
	local nameText = nameTextBox:CreateControl('richtext', 'nameText', 0, 0, 250, 30);
	nameText:SetFontName(RANK_CTRL_FONTNAME);
	nameText:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);
	nameText:SetTextAlign(ui.CENTER_HORZ, ui.CENTER_VERT);
	nameText:SetText(name);

	return bgBox;
end