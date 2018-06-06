


function FRIEND_INSERT_FACEBOK_FRIENDS(frame, groupBox, groupName, titleText)

	local y = 0;
	local titleSet = groupBox:CreateOrGetControlSet('friend_dividebar', groupName .. "_TITLE", ui.LEFT, ui.TOP, 10, y, 0, 0);
	local title = titleSet:GetChild("title");
	title:SetTextByKey("name", titleText);
	
	local groupPCCount = session.friends.GetSNSFriendCount(SNS_FACEBOOK, groupName);
	for i = 0 , groupPCCount - 1 do
		local friendInfo = session.friends.GetSNSFriendByIndex(SNS_FACEBOOK, groupName, i);
		local ctrlSet = groupBox:CreateOrGetControlSet('friend_sns', groupName .. friendInfo:GetSNSInstanceID(), ui.LEFT, ui.TOP, 10, y, 0, 0);
		local sns_name_text = ctrlSet:GetChild("sns_name_text");
		sns_name_text:SetTextByKey("name", friendInfo:GetSNSName());
		local team_name_text = ctrlSet:GetChild("team_name_text");
		team_name_text:SetTextByKey("name", "");
		local map_name_text = ctrlSet:GetChild("map_name_text");
		map_name_text:SetTextByKey("name", "");
		local profileimage = GET_CHILD(ctrlSet, "profileimage", "ui::CWebPicture");
		profileimage:SetUrlInfo(friendInfo:GetPictureURL());

		local jobportrait_bg = ctrlSet:GetChild("jobportrait_bg");
		jobportrait_bg:ShowWindow(0);
		local jobportrait = ctrlSet:GetChild("jobportrait");
		jobportrait:ShowWindow(0);
		local lvbox = ctrlSet:GetChild("lvbox");
		lvbox:ShowWindow(0);
	end
end

function FRIEND_FACEBOOK_UPDATE()
	local frame = ui.GetFrame("friend");
	
	local facebook = frame:GetChild("facebook");
	facebook:RemoveAllChild();

	local y = 0;
	y = FRIEND_INSERT_FACEBOK_FRIENDS(frame, facebook, "LikeTOS", ClMsg("FriendsWhoJoinedTOS"));
	y = FRIEND_INSERT_FACEBOK_FRIENDS(frame, facebook, "Taggable", ClMsg("FriendsNotJoinedTOS"));
	ALIGN_SNS_FRIENDS(facebook, SNS_FACEBOOK);
end

function ALIGN_SNS_FRIENDS_GROUP(groupBox, snsType, y, groupName)
	
	local titleSet = groupBox:GetChild(groupName .. "_TITLE");
	local titleRect = titleSet:GetMargin();
	titleSet:SetMargin(titleRect.left, y, titleRect.right, titleRect.bottom);
	y = y + titleSet:GetHeight();

	local groupPCCount = session.friends.GetSNSFriendCount(snsType, groupName);
	for i = 0 , groupPCCount - 1 do
		local friendInfo = session.friends.GetSNSFriendByIndex(snsType, groupName, i);
		local ctrlSet = groupBox:GetChild(groupName .. friendInfo:GetSNSInstanceID());
		local rect = ctrlSet:GetMargin();
		ctrlSet:SetMargin(rect.left, y, rect.right, rect.bottom);
		y = y + ctrlSet:GetHeight();
	end

	return y;
end

function ALIGN_SNS_FRIENDS(groupBox, snsType)

	local y = 0;
	y = ALIGN_SNS_FRIENDS_GROUP(groupBox, snsType, y, "LikeTOS");
	y = ALIGN_SNS_FRIENDS_GROUP(groupBox, snsType, y, "Taggable");

end

function RECV_SNS_PC_GAME_INFO()

	local frame = ui.GetFrame("friend");
	local facebook = frame:GetChild("facebook");
	local groupName = "LikeTOS";
	local pcCount = session.friends.GetSNSFriendCount(SNS_FACEBOOK, groupName);
	for i = 0 , pcCount - 1 do
		local friendInfo = session.friends.GetSNSFriendByIndex(SNS_FACEBOOK, groupName, i);
		local ctrlSet = facebook:GetChild(groupName .. friendInfo:GetSNSInstanceID());

		local info = friendInfo:GetGameInfo();
		local mapID = friendInfo.mapID;

		local sns_name_text = ctrlSet:GetChild("sns_name_text");
		if mapID == 0 then
			sns_name_text:SetColorTone("FF666666");			
		end

		UPDATE_FRIEND_CONTROLSET_BY_PCINFO(ctrlSet, mapID, -1, info, false);
	end

	ALIGN_SNS_FRIENDS(facebook, SNS_FACEBOOK);

end




