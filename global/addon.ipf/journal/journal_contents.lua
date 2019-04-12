

max_sub_ctrl = 3;	

function CREATE_JOURNAL_ARTICLE_CONTENTS(frame, grid, key, text, iconImage, callback)

	CREATE_JOURNAL_ARTICLE(frame, grid, key, text, iconImage, callback);
	local group = GET_CHILD(frame, 'contents', 'ui::CGroupBox')
	group:SetUserValue("CATEGORY", "Contents");
	
	local queue = group:CreateOrGetControl('queue', 'queue', 0, 0, ui.NONE_HORZ, ui.TOP, 20, 50, 0, 0);
	queue = tolua.cast(queue, "ui::CQueue");
	queue:SetSpaceY(15);
	queue:SetSkinName("None");
	queue:SetBorder(0, 10, 10, 0);
	queue:RemoveAllChild();
	
	local totalScore = 0;
	totalScore = totalScore + JOURNAL_CONTENTS_QUEST(frame, group);
	totalScore = totalScore + JOURNAL_CONTENTS_NPC(frame, group);
	totalScore = totalScore + JOURNAL_CONTENTS_COLLECTION(frame, group);
	totalScore = totalScore + JOURNAL_CONTENTS_ACHIEVE(frame, group);
	totalScore = totalScore + JOURNAL_CONTENTS_MGAME(frame, group);

	local ctrlset = group:GetChild("ctrlset");
	ctrlset:GetChild("scoretext"):SetTextByKey("score", totalScore);

	group:UpdateData();
	group:Invalidate();

end

function JOURNAL_OPEN_CONTENTS_ARTICLE(frame, ctrlSet)

	local f = ui.GetFrame("journal");
	JOURNAL_HIDE_ARTICLES(f)
	JOURNAL_OPEN_ARTICLE(f, 'contents');
	imcSound.PlaySoundEvent('button_click_3');
	--SET_JOURNAL_RANK_TYPE(f, 'Contents');
end

function JOURNAL_CONTENTS_RESET_SUB_CTRL(ctrlSet)
	for i = 1 , max_sub_ctrl do
		local subCtrl = ctrlSet:GetChild("sub_" .. i);
		subCtrl:SetTextByKey("text", "");
	end
end

function JOURNAL_CREATE_CONTENTS(frame, group, ctrlName, point, category, countText, customSize)
	local queue = group:GetChild('queue');
	local ctrlSet = queue:CreateControlSet('journal_contents', ctrlName, 10, 0);

	ctrlSet:GetChild("scoretext"):SetTextByKey("score", point);
	ctrlSet:GetChild("title"):SetTextByKey("categoryname", category);
	ctrlSet:GetChild("totaltext"):SetTextByKey("text", countText);

	JOURNAL_CONTENTS_RESET_SUB_CTRL(ctrlSet);
	if customSize ~= nil then
		ctrlSet:Resize(ctrlSet:GetWidth(), customSize);
	end
	return ctrlSet;
end

function JOURNAL_CONTENTS_QUEST(frame, group)
	
	local sObj = GET_MAIN_SOBJ();
	local endCount = GET_END_QUEST_COUNT(sObj);
	local point = session.GetMyWikiScore(WIKI_QUEST);

	local ctrlSet = JOURNAL_CREATE_CONTENTS(frame, group, "quest", point, ClMsg("Quest"), ScpArgMsg("QuestClear_{Auto_1}_Count", "Auto_1", endCount));
		
	local drawCount = 0;
	local cnt = geQuestTable.GetQuestPropertyCount();
	for i = 0 , cnt - 1 do
		local propName = geQuestTable.GetQuestProperty(i);
		if sObj[propName] == 300 then
			local questCls = GetIES(geQuestTable.GetQuestObject(i));
			local subCtrl = ctrlSet:GetChild("sub_" .. (drawCount + 1));
			subCtrl:SetTextByKey("text", questCls.Name);
			drawCount = drawCount + 1;
			if drawCount >= max_sub_ctrl then
				break;
			end
		end
	end

	return point;
end

function JOURNAL_CONTENTS_NPC(frame, group)

	local pc = GetMyPCObject();
	local npcCount = GetNPCStateCount(pc);
	local point = session.GetMyWikiScore(WIKI_NPC);

	local ctrlSet = JOURNAL_CREATE_CONTENTS(frame, group, "npc", point, "NPC", ScpArgMsg("NPC_Meet_{Auto_1}_People", "Auto_1", npcCount));

	local drawCount = 0;

	local npcStates = session.GetNPCStateMap();
	local idx = npcStates:Head();
	while idx ~= npcStates:InvalidIndex() do

		local isExit = false;
		local mapName = npcStates:KeyPtr(idx):c_str();
		local mapCls = GetClass("Map", mapName);
		local npcList = npcStates:Element(idx);
		
		local npcIdx = npcList:Head();
		while npcIdx ~= npcList:InvalidIndex() do
			
			local type = npcList:Key(npcIdx);
			local genCls = GetGenTypeClass(mapName, type);
			
			if nil == genCls then
				break;
			end;
			
			npcIdx = npcList:Next(npcIdx);
			local name = GET_GENCLS_NAME(genCls);

			local subCtrl = ctrlSet:GetChild("sub_" .. (drawCount + 1));
			
			if string.find(name, '{nl}') ~= nil then
			    name = string.gsub(name, '{nl}',' ')
			    while 1 do
			        if string.find(name, '  ') ~= nil then
			            name = string.gsub(name, '  ',' ')
			        else
			            break
			        end
			    end
			end
			
			subCtrl:SetTextByKey("text", string.format("[%s] %s", mapCls.Name, name));
			drawCount = drawCount + 1;
			if drawCount >= max_sub_ctrl then
				isExit = true;
				break;
			end
		end

		if true == isExit then
			break;
		end

		idx = npcStates:Next(idx);
	end

	return point;

end

function JOURNAL_CONTENTS_COLLECTION(frame, group)

	local colls = session.GetMySession():GetCollection();
	local cnt = colls:Count();
	local satisCnt = colls:GetStatisfiedCount();
	local point = GET_WIKI_POINT_COLLECTION(cnt, satisCnt);
	local msg = ScpArgMsg("HaveCollection_{Auto_1}", "Auto_1", cnt) .. "{nl}" .. ScpArgMsg("CompleteCollection_{Auto_1}", "Auto_1", satisCnt);
	
	JOURNAL_CREATE_CONTENTS(frame, group, "collection", point, ClMsg("Collection"), msg, 100);
	return point;
end

function JOURNAL_CONTENTS_ACHIEVE(frame, group)
	local pc = GetMyPCObject();
	local point = session.GetMyWikiScore(WIKI_ACHIEVE);
	local cnt, ncnt = GetAchieveCount(pc);
	
	JOURNAL_CREATE_CONTENTS(frame, group, "achieve", point, ClMsg("Achieve"), ScpArgMsg("HaveAchieve_{Auto_1}", "Auto_1", cnt + ncnt), 100);
	return point;
end

function JOURNAL_CONTENTS_MGAME(frame, group)
	local pc = GetMyPCObject();
	local point = session.GetMyWikiScore(WIKI_MGAME);
	local haveCnt = GetWikiListCountByCategory("MGame");
	local dd = ScpArgMsg("Clear_Mission{Auto_1}", "Auto_1", haveCnt);
	JOURNAL_CREATE_CONTENTS(frame, group, "mission", point, ClMsg("Mission"), ScpArgMsg("Clear_Mission{Auto_1}", "Auto_1", haveCnt), 100);
	return point;
end




