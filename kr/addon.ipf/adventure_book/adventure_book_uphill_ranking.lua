function ON_UPHILL_RANK_PAGE(frame, msg, argStr, page)
    local page_upHillRanking = GET_CHILD_RECURSIVELY(frame, 'page_upHillRanking');
    local adventureBookRankingSet = GET_CHILD(page_upHillRanking, 'upHillRankingSet');
    ADVENTURE_BOOK_UPHILL_RANK_SELECT_PAGE(adventureBookRankingSet, page);
    ADVENTURE_BOOK_UPHILL_UPDATE_POINT(page_upHillRanking);
end

function ADVENTURE_BOOK_UPHILL_RANK_SELECT_PAGE(adventureBookRankingSet, page)
    local EACH_RANK_SET_HEIGHT = tonumber(adventureBookRankingSet:GetUserConfig('EACH_RANK_SET_HEIGHT'));
    local pageCtrl = GET_CHILD(adventureBookRankingSet, 'control');
    pageCtrl:SetCurPage(page);

    local advBookConstCls = GetClass('AdventureBookConst', 'ADVENTURE_BOOK_RANK_PER_PAGE');
    local numPerPage = advBookConstCls.Value;
    local startRank = page * numPerPage;
    local ranking = geServerUphill.GetMGameRank();
    
    -- left box
    local rankBox_left = adventureBookRankingSet:GetChild('rankBox_left');
    DESTROY_CHILD_BYNAME(rankBox_left, 'ADVENTURE_BOOK_RANK_');
    local width = rankBox_left:GetWidth();
    for i = 0, numPerPage / 2 - 1 do
        local rankIndex = ranking:GetIndexByRank(startRank + i);
		if rankIndex < 0 then
			break;
		end
		local rankInfo = ranking:GetByIndex(rankIndex);
		if rankInfo == nil and rankInfo.totalScore <= 0 then
			break;
		end
		local imgName = GET_JOB_ICON(rankInfo:GetIconInfo().job);
		local rankFont;
		if cid == rankInfo:GetStrCID() then
			rankFont = adventureBookRankingSet:GetUserConfig("RANK_MY_FONT_NAME");
		else
			rankFont = adventureBookRankingSet:GetUserConfig("RANK_FONT_NAME");
		end
        local rankSet = rankBox_left:CreateOrGetControlSet('journal_rank_set', "ADVENTURE_BOOK_RANK_" .. rankInfo.ranking, 0, 0);
		local rankStr = string.format("%s%d", rankFont, rankInfo.ranking+1, imgName);
		local txt_score = rankSet:GetChild("txt_score");
		txt_score:SetTextByKey("value", rankInfo.totalScore);
		local txt_rank = rankSet:GetChild("txt_rank");
		txt_rank:SetTextByKey("value", rankInfo.ranking+1);
		local txt_name = rankSet:GetChild("txt_name");
		local nameText =  rankInfo:GetIconInfo():GetGivenName() .. "{nl}" .. rankInfo:GetIconInfo():GetFamilyName();
		txt_name:SetTextByKey("value", nameText);
        rankSet:Resize(width, EACH_RANK_SET_HEIGHT);
    end
    GBOX_AUTO_ALIGN(rankBox_left, 0, 0, 0, true, false);    

    -- right box
    local rankBox_right = adventureBookRankingSet:GetChild('rankBox_right');
    DESTROY_CHILD_BYNAME(rankBox_right, 'ADVENTURE_BOOK_RANK_');
    for i = numPerPage / 2, numPerPage - 1 do
        local rankIndex = ranking:GetIndexByRank(startRank + i);		
		if rankIndex < 0 then
			break;
		end
		local rankInfo = ranking:GetByIndex(rankIndex);
		if rankInfo == nil and rankInfo.totalScore <= 0 then
			break;
		end
		local imgName = GET_JOB_ICON(rankInfo:GetIconInfo().job);
		local rankFont;
		if cid == rankInfo:GetStrCID() then
			rankFont = adventureBookRankingSet:GetUserConfig("RANK_MY_FONT_NAME");
		else
			rankFont = adventureBookRankingSet:GetUserConfig("RANK_FONT_NAME");
		end
        local rankSet = rankBox_right:CreateOrGetControlSet('journal_rank_set', "ADVENTURE_BOOK_RANK_" .. rankInfo.ranking, 0, 0);
		local rankStr = string.format("%s%d", rankFont, rankInfo.ranking+1, imgName);
		local txt_score = rankSet:GetChild("txt_score");
		txt_score:SetTextByKey("value", rankInfo.totalScore);
		local txt_rank = rankSet:GetChild("txt_rank");
		txt_rank:SetTextByKey("value", rankInfo.ranking+1);
		local txt_name = rankSet:GetChild("txt_name");
		local nameText =  rankInfo:GetIconInfo():GetGivenName() .. "{nl}" .. rankInfo:GetIconInfo():GetFamilyName();
		txt_name:SetTextByKey("value", nameText);
        rankSet:Resize(width, EACH_RANK_SET_HEIGHT);
    end
    GBOX_AUTO_ALIGN(rankBox_right, 0, 0, 0, true, false);
end

function ADVENTURE_BOOK_UPHILL_RANKING_SHOW_BY_SEARCH(adventureBookFrame, charName, rank, score, familyName)
    if rank ~= nil and tonumber(rank) < 0 then -- cannot search
        return;
    end

    local adventureBookRankingSet = GET_CHILD_RECURSIVELY(adventureBookFrame, 'upHillRankingSet');    
    local EACH_RANK_SET_HEIGHT = tonumber(adventureBookRankingSet:GetUserConfig('EACH_RANK_SET_HEIGHT'));
    local pageCtrl = GET_CHILD(adventureBookRankingSet, 'control');
    pageCtrl:SetCurPage(1);

    -- left box
    local rankBox_left = adventureBookRankingSet:GetChild('rankBox_left');
    DESTROY_CHILD_BYNAME(rankBox_left, 'ADVENTURE_BOOK_RANK_');
    local width = rankBox_left:GetWidth();
    local rankSet = rankBox_left:CreateOrGetControlSet('journal_rank_set', 'ADVENTURE_BOOK_RANK_'..charName, 0, 0);
    local txt_score = rankSet:GetChild('txt_score');
    local txt_rank = rankSet:GetChild('txt_rank');
    txt_score:SetTextByKey('value', score);
    txt_rank:SetTextByKey('value', rank + 1);

    local txt_name = rankSet:GetChild("txt_name");
	local nameText = charName
    if familyName ~= nil then
        nameText = nameText .. familyName;
    end
	txt_name:SetTextByKey("value", nameText);
    rankSet:Resize(width, EACH_RANK_SET_HEIGHT);

    -- right box
    local rankBox_right = adventureBookRankingSet:GetChild('rankBox_right');
    DESTROY_CHILD_BYNAME(rankBox_right, 'ADVENTURE_BOOK_RANK_');
end

function GET_SHOP_POINT_CLASS_NAME()
    return 'Three';
end

function ADVENTURE_BOOK_UPHILL_UPDATE_POINT(uphillPage)
    local clsName = GET_SHOP_POINT_CLASS_NAME();
    local curDateString = imcTime.GetCurDateString();
	local lastPointGetDateName = GetPVPPointPropName(clsName, "LastPointGetDate");
	local todayGetShopPointName = GetPVPPointPropName(clsName, "TodayGetShopPoint");
	local shopPointName = GetPVPPointPropName(clsName, "ShopPoint");
    local mySession = session.GetMySession();
	local cid = mySession:GetCID();
    local ret = worldPVP.RequestPVPInfo();        
    if ret == true then
        return;
    end

	local pvpObj = session.worldPVP.GetPVPObject(cid);        
    if pvpObj == nil then
        return;
    end

    if shopPointName ~= "None" then
		local todayGetShopPoint = 0;
		if curDateString == pvpObj:GetPropValue(lastPointGetDateName) then
			todayGetShopPoint = pvpObj:GetPropValue(todayGetShopPointName);
		end

		local dailyPointGauge = GET_CHILD_RECURSIVELY(uphillPage, "dailyPointGauge");
		dailyPointGauge:SetPoint(todayGetShopPoint, PVP_DAY_MAX_SHOP_POINT);

		local totalPointValueText = GET_CHILD_RECURSIVELY(uphillPage, "totalPointValueText");
		totalPointValueText:SetTextByKey("point", pvpObj:GetPropValue(shopPointName));
	end    
end
