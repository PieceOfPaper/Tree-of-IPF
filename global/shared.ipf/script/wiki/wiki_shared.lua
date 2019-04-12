-- wiki_shared.lua

W_PTS_LEVEL = 5;
W_PTS_ITEM = 1;
W_PTS_MONSTER = 1;
W_PTS_ACHIEVE = 10;
W_PTS_QUEST = 5;
W_PTS_RECIPE = 10;
W_PTS_NPC = 1;

function GET_WIKI_POINT_COLLECTION(cnt, satisFiedCount)
	return cnt * 5 + satisFiedCount * 45;
end

--function GET_WIKI_POINT_ACHIEVE(cnt, ncnt)
--	return W_PTS_ACHIEVE * (cnt  + ncnt);
--end

function GET_ITEM_MAX_WIKI_PTS(itemCls, wiki)

	local groupName = itemCls.GroupName;
	if itemCls.ItemType == 'Equip' then
		return GET_EQUIP_WIKI_PTS(itemCls, 10);
	elseif groupName == "Gem" then
		return GET_GEM_WIKI_PTS(itemCls, 10);
	else
		return GET_ITEM_WIKI_PTS(itemCls, wiki);
	end

end

function GET_ITEM_WIKI_PTS(itemCls, wiki)
	
	local groupName = itemCls.GroupName;
	if itemCls.ItemType == 'Equip' then
		local maxReinforce = GetWikiIntProp(wiki, "MaxReinforce")
		return GET_EQUIP_WIKI_PTS(itemCls, maxReinforce);
	elseif groupName == 'Book' then
		return 10;
	elseif groupName == "Gem" then
		local maxLevel = GetWikiIntProp(wiki, "MaxLevel");
		return GET_GEM_WIKI_PTS(itemCls, maxLevel);
	else
		return 1;
	end
	
end

function GET_EQUIP_WIKI_PTS(itemCls, maxReinfore)

	local itemGrade = itemCls.ItemStar;
	local point = itemGrade * 10;
	if maxReinfore > 0 then
		local k = point * 0.03;
		if maxReinfore <= 4 then
			point = point + k * maxReinfore;
		elseif maxReinfore <= 9 then
			point = point + (k * maxReinfore) * (maxReinfore - 3);
		else
			point = point * 4;
		end
		
	end
		
	return point;

end

function GET_GEM_WIKI_PTS(itemCls, maxLevel)

	local point = 10;
	if maxLevel > 0 then
		local k = point * 0.02;
		point = point + k * maxLevel * 10;
	end
		
	return point;

end

function GET_MON_WIKI_PTS(monCls)
	if monCls.MonRank == "Boss" then
		return 50;
	else
		return 10;
	end
end

function GET_WIKI_SCORE_BY_CLS_CB(list, cbFunc)

	if list == nil then
		return 0
	end

	local cnt = #list;
	local ret = 0;
	for i = 1 , cnt  do
		local wi = list[i];
		local tobj = GetWikiTargetObject(wi);
		if tobj ~= nil then
			ret = ret + cbFunc(tobj, wi);
		end
	end

	return ret;
end

function GET_WIKI_CONTENTS_SCORE(pc)
	local totalscore = 0;
	for type = 0, WIKI_COUNT -1 do
		if type == WIKI_NPC then 
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);

		elseif type == WIKI_MGAME then
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);

		elseif type == WIKI_ACHIEVE then
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);

		elseif type == WIKI_QUEST then
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);

		elseif type == WIKI_COLLECTION then
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);
		end
	end

	return totalscore;
end

function GET_WIKI_TOTAL_SCORE(pc)
	local totalscore = 0;
	for type = 0, WIKI_COUNT -1 do
		if type == WIKI_GROWTH then
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);

		elseif type == WIKI_ITEM then	
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);

		elseif type == WIKI_MONSTER then	
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);

		elseif type == WIKI_NPC then 
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);

		elseif type == WIKI_MAP then
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);

		elseif type == WIKI_SETITEM then
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);

		elseif type == WIKI_MGAME then
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);

		elseif type == WIKI_ACHIEVE then
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);

		elseif type == WIKI_RECIPE then
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);

		elseif type == WIKI_QUEST then
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);

		elseif type == WIKI_COLLECTION then
			totalscore = totalscore + GET_WIKI_SCORE(pc, type);
		end
	end

	return totalscore;
end

function GET_WIKI_SCORE(pc, type)

	if type == WIKI_TOTAL then
		return GET_WIKI_TOTAL_SCORE(pc)
	elseif type == WIKI_CONTENTS then	
		return GET_WIKI_CONTENTS_SCORE(pc)
	elseif type == WIKI_GROWTH then
		local joblv, totaljoblv = GetJobLevelByName(pc, pc.JobName);
		return (pc.Lv + totaljoblv) * W_PTS_LEVEL;
	elseif type == WIKI_ITEM then	
		local list = GetPCCategoryWikiList(pc, type);
		return GET_WIKI_SCORE_BY_CLS_CB(list, GET_ITEM_WIKI_PTS);
	elseif type == WIKI_MONSTER then	
		local list = GetPCCategoryWikiList(pc, type);
		return GET_WIKI_SCORE_BY_CLS_CB(list, GET_MON_WIKI_PTS);
	elseif type == WIKI_NPC then 
		local cnt = GetNPCStatePoint(pc);
		return cnt * W_PTS_NPC;
	elseif type == WIKI_MAP then
        local score = GetMapRevealScore(pc);
        return score;
	elseif type == WIKI_SETITEM then
		
	elseif type == WIKI_MGAME then

		local count = GetPCCategoryWikiCount(pc, type);
		return count * 5;

	elseif type == WIKI_ACHIEVE then
		local point = GetAchieveWikiPoint(pc);
		return point;

	elseif type == WIKI_RECIPE then
		local count = GetPCCategoryWikiCount(pc, type);
		return count * W_PTS_RECIPE;

	elseif type == WIKI_QUEST then
		local sObj = GetSessionObject(pc, "ssn_klapeda");		
		if nil == sObj then
			return 0;
		end

		local endCount = GET_END_QUEST_COUNT(sObj);		
		return endCount * W_PTS_QUEST;

	elseif type == WIKI_COLLECTION then
		local cnt, satisCnt = GetCollectionCount(pc);
		return GET_WIKI_POINT_COLLECTION(cnt, satisCnt);
	end

	return 0;
end

function GET_WIKI_MAX_RANKPROP(wiki, nameHead, loopCnt)

	local maxCnt = -1;
	local maxProp = nil;
	local maxCount = 0;
	local maxPropName = nil;

	for i = 1 , loopCnt do
		local propName = nameHead .. i;
		local prop, count = GetWikiProp(wiki, propName);
		if prop == nil then return nil; end
		if count > maxCnt or maxCnt == -1 then
			maxProp = prop;
			maxCnt = count;
			maxPropName = propName;
		end
	end

	return maxProp, maxCnt, maxPropName;

end

function FIND_WIKI_COUNT_PROP(wiki, nameHead, maxCount, propValue)
	for i = 1 , maxCount do
		local propName = nameHead .. i;
		local prop, count = GetWikiProp(wiki, propName);
		if prop == propValue then
			return prop, count;
		end
	end

	return nil;
end

function IS_POSSIBLE_GET_WIKI_REWARD(pc)

	local nowposx,nowposy,nowposz = Get3DPos(pc);
	local etc = GetETCObject(pc);
	local mapname, x, y, z, uiname = GET_LAST_UI_OPEN_POS(etc)

	if mapname == nil then
		return;
	end

	if uiname ~= 'journal' or GET_2D_DIS(x,z,nowposx,nowposz) > 100 or GetZoneName(pc) ~= mapname then
		print('get reward failed!')
		return 0;
	end

	return 1;
end
