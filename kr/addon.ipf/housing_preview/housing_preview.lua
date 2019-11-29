function HOUSING_PREVIEW_ON_INIT(addon, frame)
end

function HOUSING_PREVIEW_CLOSE()
	housing.ClosePreview();

	local guild_rank_info = ui.GetFrame("guild_rank_info");
	if guild_rank_info ~= nil then
		local isOpened = guild_rank_info:GetUserValue("IsOpened");
		if isOpened == "YES" then
			guild_rank_info:SetUserValue("IsOpened", "NO");
			guild_rank_info:ShowWindow(1);
		end
	end

	local guildinfo_detail = ui.GetFrame("guildinfo_detail");
	if guildinfo_detail ~= nil then
		local isOpened = guildinfo_detail:GetUserValue("IsOpened");
		if isOpened == "YES" then
			guildinfo_detail:SetUserValue("IsOpened", "NO");
			guildinfo_detail:ShowWindow(1);
			
			local promoBox = GET_CHILD_RECURSIVELY(guildinfo_detail, "promoBox");
			local isScrollBarVisible = promoBox:GetUserValue("IsScrollBarVisible");
			if isScrollBarVisible == 1 then
				promoBox:SetScrollBarVisible(true);
			else
				promoBox:SetScrollBarVisible(false);
			end
		end
	end
end