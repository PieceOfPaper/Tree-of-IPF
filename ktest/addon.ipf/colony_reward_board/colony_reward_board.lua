-- colont reward board
function COLONY_REWARD_BOARD_ON_INIT(addon, frame)
	addon:RegisterMsg("SUCCESS_SECOND_LEAGUE_COLONY_REWARD", "ON_SUCCESS_REWARD_ITEM");
	addon:RegisterMsg("UPDATE_COLONY_REWARD_DEATIL_LIST", "ON_UPDATE_REWARD_DETAIL_ITEM");
	addon:RegisterMsg("START_SECOND_LEAGUE_COLONY_REWARD", "ON_SECOND_LEAGUE_START");
end

function COLONY_REWARD_BOARD_REQINFO()
	session.colonyReward.LoadRewardItemDate();
    session.colonyReward.ReqTaxInquireList();
end

function ON_SECOND_LEAGUE_START(frame)
	if frame == nil then return; end
	local reward_list_gb = GET_CHILD_RECURSIVELY(frame, "reward_list_gb");
	local rewardInfoCount = session.colonyReward.GetSizeChallengersRewardList();
	if reward_list_gb ~= nil and rewardInfoCount ~= nil and rewardInfoCount > 0 then
		REWARD_LIST_CLEAR(reward_list_gb);
		CREATE_COLONY_REWARD_LIST(reward_list_gb);
	end
	frame:Invalidate();
end

function ON_OPEN_COLONY_REWARD_BOARD(frame)
	local taxboardUI = ui.GetFrame("colony_tax_board");
	if taxboardUI ~= nil and taxboardUI:IsVisible() == 1 then
		ui.CloseFrame("colony_tax_board");
	end

	local rewardwarning_text = GET_CHILD_RECURSIVELY(frame, "rewardwarning_text");
	local rewardDetailMsg = ScpArgMsg("ColonyLeague_2nd_Reward_Detail{RewardLoadDelay}{RewardReceiveTime}", "RewardLoadDelay", (COLONY_TAX_DISTRIBUTE_DELAY_MIN/60), "RewardReceiveTime", (COLONY_TAX_DISTRIBUTE_PERIOD_MIN/1440));
	rewardwarning_text:SetTextByKey("value", rewardDetailMsg);

	local reward_list_gb = GET_CHILD_RECURSIVELY(frame, "reward_list_gb");
	local rewardInfoCount = session.colonyReward.GetSizeChallengersRewardList();
	if reward_list_gb ~= nil and rewardInfoCount ~= nil and rewardInfoCount > 0 then
		CREATE_COLONY_REWARD_LIST(reward_list_gb)
	elseif reward_list_gb ~= nil and rewardInfoCount <= 0 then
		REWARD_LIST_CLEAR(reward_list_gb);
	end
end

function REWARD_LIST_CLEAR(listgb)
	if listgb == nil then return; end
	local count = listgb:GetChildCount();
	if count ~= nil and count > 0 then
		listgb:RemoveAllChild();
	end
	listgb:Invalidate();
end

function GET_SEONCDLEAGUE_REWARD_LIST()
	local secondLeagueRateList = {};
	local count = session.colonyReward.GetSizeChallengersRewardList();
	for i = 0, count - 1 do
		local guildInfo = session.party.GetPartyInfo(PARTY_GUILD);
		local guildID = guildInfo.info:GetPartyID();
		local rewardInfo = session.colonyReward.GetMyGuildRewardInfo(i, guildID);
		if rewardInfo ~= nil then
            local mapID = rewardInfo:GetColonyMapID();
            local mapCls = GetClassByType('Map', mapID);
            local cityMapName = GET_COLONY_MAP_CITY(mapCls.ClassName)
            local cityMapCls = GetClass("Map", cityMapName)
            local colonyCls = GetClassByStrProp("guild_colony", "TaxApplyCity", cityMapCls.ClassName)
            local colonyLeague = TryGetProp(colonyCls, "ColonyLeague")
			if colonyLeague == 2  then
				secondLeagueRateList[#secondLeagueRateList + 1] = rewardInfo;
			end
		end
	end

	return secondLeagueRateList;
end

function CREATE_COLONY_REWARD_LIST(listgb)
	local frame = listgb:GetTopParentFrame()
	if frame == nil then return; end
	listgb:RemoveAllChild();

	local pcparty = session.party.GetPartyInfo(PARTY_GUILD);
	if pcparty == nil or pcparty.info == nil then
		return;
	end

	local secondLg_rewardInfoList = GET_SEONCDLEAGUE_REWARD_LIST();
	if secondLg_rewardInfoList == nil then return; end

	local listCnt = #secondLg_rewardInfoList;
	for i = 1, listCnt do
		local SKIN_ODD = frame:GetUserConfig("SKIN_ODD");
		local SKIN_EVEN = frame:GetUserConfig("SKIN_EVEN");
		local width = ui.GetControlSetAttribute("colony_reward_elem", "width");
		local height = ui.GetControlSetAttribute("colony_reward_elem", "height");
		SET_COLONY_TAX_RATE_LIST_SKIN(listgb, width, height, listCnt, SKIN_ODD, SKIN_EVEN);

		local rewardInfo = secondLg_rewardInfoList[i];
		local mapID = rewardInfo:GetColonyMapID();
		local mapCls = GetClassByType("Map", mapID);
		local cityMapName = GET_COLONY_MAP_CITY(mapCls.ClassName);
		local cityMapCls = GetClass("Map", cityMapName);
		local colonyCls = GetClassByStrProp("guild_colony", "TaxApplyCity", cityMapCls.ClassName);
		local colonyMapID = TryGetProp(colonyCls, "ClassID");

		if rewardInfo ~= nil then
			local ctrlSet = listgb:CreateOrGetControlSet("colony_reward_elem", "REWARD_"..colonyMapID, ui.LEFT, ui.TOP, 0, (i - 1) * height, 0, 0);
			if ctrlSet ~= nil then
				AUTO_CAST(ctrlSet);
				FILL_COLONY_REWARD_ELEM(ctrlSet, rewardInfo);
			end
		end
	end
	listgb:Invalidate();
end

function FILL_COLONY_REWARD_ELEM(ctrlset, rewardInfo)
	local paymentdate_text = GET_CHILD_RECURSIVELY(ctrlset, "paymentdate_text");
	local colonymap_text = GET_CHILD_RECURSIVELY(ctrlset, "colonymap_text");

	-- map name
	local mapID = rewardInfo:GetColonyMapID();
	local mapCls = GetClassByType("Map", mapID);
	colonymap_text:SetTextByKey("value", mapCls.Name);
	
	local cityMapName = GET_COLONY_MAP_CITY(mapCls.ClassName);
    local cityMapCls = GetClass("Map", cityMapName);
    local colonyCls = GetClassByStrProp("guild_colony", "TaxApplyCity", cityMapCls.ClassName);
    local colonyMapID = TryGetProp(colonyCls, "ClassID");
	colonymap_text:SetUserValue("COLONY_MAPID", colonyMapID);

	local reward_gb = GET_CHILD_RECURSIVELY(ctrlset, "reward_gb");
	if reward_gb ~= nil then
		local rewardItemCnt = session.colonyReward.GetRewardInfoListCountByType(colonyMapID);		
		local height = ui.GetControlSetAttribute("colony_rewarddetail_elem", "height");

		for i = 0, rewardItemCnt - 1 do
			local deatilCtrlSet = reward_gb:CreateOrGetControlSet("colony_rewarddetail_elem", "REWARD_DETAIL_"..i, ui.LEFT, ui.TOP, 0, (i - 1) * height, 0, 0);
			
			local rewardItemInfo = session.colonyReward.GetRwardInfo(colonyMapID, i);
			if deatilCtrlSet ~= nil and rewardItemInfo ~= nil then
				local time = rewardItemInfo:GetStartTime();
				paymentdate_text:SetTextByKey("year", time.wYear);
				paymentdate_text:SetTextByKey("month", time.wMonth);
				paymentdate_text:SetTextByKey("day", time.wDay);

				if rewardItemInfo:IsExpire() == false and session.colonyReward.IsRewardState(colonyMapID) == false then
					AUTO_CAST(deatilCtrlSet);
					FILL_COLONY_REWARD_ELEM_ITEM_DETAIL(deatilCtrlSet, rewardItemInfo);
				else
					local commitButton = GET_CHILD_RECURSIVELY(ctrlset, "commit_btn");
					if commitButton ~= nil and session.colonyReward.IsRewardState(colonyMapID) == true then
						commitButton:SetSkinName("test_gray_button");	
						commitButton:EnableHitTest(0);
						session.colonyReward.SetRewardCompleteByType(mapID, true);
					end

					local itemicon_pic = GET_CHILD_RECURSIVELY(deatilCtrlSet, "item_pic");
					local itemClassName = rewardItemInfo:GetitemClassName();
					if itemClassName ~= nil and itemicon_pic ~= nil then
						local itemCls = GetClass("Item", itemClassName);
						local itemIconName = GET_ITEM_ICON_IMAGE(itemCls);
						itemicon_pic:SetImage(itemIconName);
						itemicon_pic:SetTooltipOverlap(1);
						itemicon_pic:SetTextTooltip(itemCls.Name);
					end
				end
			end
		end
	end

	GBOX_AUTO_ALIGN(reward_gb, 0, 0, 0, true, true, false);
end

function FILL_COLONY_REWARD_ELEM_ITEM_DETAIL(ctrlSet, rewardInfo)
	if ctrlSet == nil then return; end
	if rewardInfo == nil then return; end
	
	local itemicon_pic = GET_CHILD_RECURSIVELY(ctrlSet, "item_pic");
	local rewardItem_text = GET_CHILD_RECURSIVELY(ctrlSet, "rewarditem_text");

	local itemClassName = rewardInfo:GetitemClassName();
	if itemClassName ~= nil and itemicon_pic ~= nil then
		local itemCls = GetClass("Item", itemClassName);
		local itemIconName = GET_ITEM_ICON_IMAGE(itemCls);
		itemicon_pic:SetImage(itemIconName);
		itemicon_pic:SetTooltipOverlap(1);
		itemicon_pic:SetTextTooltip(itemCls.Name);
	end

	local itemCnt = rewardInfo:GetRewardItemCount();
	if itemCnt ~= nil and rewardItem_text ~= nil then
		rewardItem_text:SetTextByKey("count", itemCnt);
	end
end

function ON_COMMIT_COLONY_REWARD_ITEM(frame, ctrl)
	if frame == nil then return; end
	local gb = frame:GetParent();
	if gb == nil then return; end
	local rewardCtrlSet = gb:GetParent();
	if rewardCtrlSet == nil then return; end

	local colonymap_text = GET_CHILD_RECURSIVELY(rewardCtrlSet, "colonymap_text");
	if colonymap_text == nil then return; end
	
	local colonyMapID = colonymap_text:GetUserValue("COLONY_MAPID");
	if colonyMapID ~= nil then
		session.colonyReward.ReqRewardItem(colonyMapID);
	end
end

function ON_SUCCESS_REWARD_ITEM(frame, msg, mapID)
	if frame == nil then return; end
	if mapID == nil then return; end
	ui.SysMsg(ClMsg("ColonyLeague_World_map_2nd_Reward_Success"));	
end

function ON_UPDATE_REWARD_DETAIL_ITEM(frame, msg, mapID)
	if frame == nil then return; end
	if mapID == nil then return; end

	mapID = math.floor(mapID);	
	local count = session.colonyReward.GetRewardInfoListCountByType(mapID);
	if count == nil then return; end

	local reward_list_gb = GET_CHILD_RECURSIVELY(frame, "reward_list_gb");
	if reward_list_gb == nil then return; end

	reward_list_gb:RemoveAllChild();
	CREATE_COLONY_REWARD_LIST(reward_list_gb);
	
	local childCnt = reward_list_gb:GetChildCount();
	for i = 1, childCnt do
		local child = reward_list_gb:GetChildByIndex(i);
		if child ~= nil and string.find(child:GetName(), "REWARD_") ~= nil then
			local colonymap_text = GET_CHILD_RECURSIVELY(child, "colonymap_text");
			local userValue = tonumber(colonymap_text:GetUserValue("COLONY_MAPID"));
			if colonymap_text ~= nil and userValue == mapID then
				local commitButton = GET_CHILD_RECURSIVELY(child, "commit_btn");
				if commitButton ~= nil and session.colonyReward.IsRewardState(mapID) == true then
					commitButton:SetSkinName("test_gray_button");	
					commitButton:EnableHitTest(0);
					session.colonyReward.SetRewardCompleteByType(mapID, true);
				end
			end
		end
	end

	frame:Invalidate();
end