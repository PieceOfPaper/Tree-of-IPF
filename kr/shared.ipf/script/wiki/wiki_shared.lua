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
