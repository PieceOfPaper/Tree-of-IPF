--- tooltip.lua -

function UPDATE_MONSTER_TOOLTIP(frame, monName)

	local monCls = GetClass("Monster", monName);
	local image = GET_CHILD(frame, "image");
	image:SetImage(GET_MON_ILLUST(monCls));
    
	local completeBtn = GET_CHILD(frame, "complete");
	local completeText = GET_CHILD(frame, "t_complete");
	completeBtn:SetVisible(0);
	completeText:SetVisible(0);
	local jIES = GetClass('Journal_monkill_reward', monCls.ClassName)
	if jIES ~= nil then
	    if jIES ~= nil and jIES.Count1 > 0 then
	        local wiki = GetWikiByName(monCls.ClassName)
            if wiki ~= nil then
                local killcount = GetWikiIntProp(wiki, "KillCount");
                if killcount >= jIES.Count1 then
					completeBtn:SetVisible(1);
					completeText:SetVisible(1);
--                    local picMonKillReward = frame:CreateControl('picture', 'COM_'..monCls.ClassName, 0, 40, 95, 95)
--        			tolua.cast(picMonKillReward, 'ui::CPicture')
--                	picMonKillReward:SetImage('icon_item_expcard');
                end
            end
	    end
	end
	
	local name = GET_CHILD(frame, "name");
	name:SetTextByKey("value", monCls.Name);

	local racetype = GET_CHILD(frame, "racetype");
	local racetypeText = ClMsg("RaceType") .. " {img " .. "Tribe_" .. monCls.RaceType .. " 32 32}";
	racetype:SetTextByKey("value", racetypeText);
	local attr = GET_CHILD(frame, "attr");
	local attrText = ClMsg("Attribute") .. " {img " .. "attri_" ..monCls.Attribute .. " 32 32}";
	attr:SetTextByKey("value", attrText);
	
	local wiki = GetWikiByName(monName);
	local t_exp = GET_CHILD(frame, "t_exp");
	if wiki == nil then
		t_exp:ShowWindow(0);	
	else
		t_exp:ShowWindow(1);
		t_exp:SetTextByKey("exp", GetWikiIntProp(wiki, "Exp"));
		t_exp:SetTextByKey("jobexp", GetWikiIntProp(wiki, "JobExp"));
	end	
	
	local t_desc = GET_CHILD(frame, "t_desc");
	t_desc:SetTextByKey("value", monCls.Desc);            
	
	local offset = t_desc:GetHeight() - t_desc:GetOriginalHeight();
	SCR_GET_MON_RANKINFO(frame, monName, offset);
end

function SCR_GET_MON_RANKINFO(tooltipFrame, monName, offset)
	
	local ranking = geServerWiki.GetWikiServRank();
	if ranking == nil then
		SET_WIKI_MONRANK_INFO(tooltipFrame, monName, 0, offset);
		return;
	end
	
	local isShow = 1;
	if ranking:GetMonName() ~= monName then
		packet.ReqMonsterRankInfo(monName);
		isShow = 0;
	end	

	SET_WIKI_MONRANK_INFO(tooltipFrame, monName, isShow, offset);
end

function SET_WIKI_MONRANK_INFO(frame, monName, isShow, offset)
	
	local ranking = geServerWiki.GetWikiServRank();
	local myGBox = GET_CHILD(frame, "myRanking", "ui::CGroupBox");
	
	local myTitleText = GET_CHILD(myGBox, "myTitle");
	local myKillTitle = GET_CHILD(myGBox, "myKillTitle");
	local myDamageTitle = GET_CHILD(myGBox, "myDamageTitle");
	local myKillRankText = GET_CHILD(myGBox, "myKillRank");
	local myKillScoreText = GET_CHILD(myGBox, "myKillScore");
	local myDamageRankText = GET_CHILD(myGBox, "myDamageRank");
	local myDamageScoreText = GET_CHILD(myGBox, "myDamageScore");

	myTitleText:SetText(ScpArgMsg("MyRanking"));
	myKillTitle:SetText(ScpArgMsg("KillRanking"));
	myDamageTitle:SetText(ScpArgMsg("DamageRanking"));
	
	myKillRankText:SetTextByKey("rank", ranking.myKillRank + 1);
	myDamageRankText:SetTextByKey("rank", ranking.myDamageRank + 1);
	myDamageScoreText:SetTextByKey("score", ranking.myDamageScore);
	
    local myKillFlag = 0
    local pcetc = GetMyEtcObject()
	local jIES = GetClass('Journal_monkill_reward', monName)
	if jIES ~= nil and pcetc ~= nil then
	    if jIES ~= nil and jIES.Count1 > 0 then
	        local wiki = GetWikiByName(monName)
            if wiki ~= nil then
                local killcount = ranking.myKillScore
                local property = 'Reward_'..monName
    		    if GetPropType(pcetc, property) ~= nil then
    		        if pcetc[property] == 1 then
                        local text = '{img M_message_open 30 30}'..ScpArgMsg("myKillScoreText")..killcount
                        myKillScoreText:SetText(text);
                        myKillFlag = 1
    		        end
    		    end
    		    if myKillFlag == 0 then
                    local text = ScpArgMsg("myKillScoreText")..killcount..' / '..jIES.Count1
                    if jIES.Count1 <= killcount then
                        text = '{img M_message_Unopen 30 30}'..text
                    end
                    myKillScoreText:SetText(text);
                    myKillFlag = 1
    		    end
            end
	    end
	end
	
	if myKillFlag == 0 then
        local text = ScpArgMsg("myKillScoreText")..ranking.myKillScore
        myKillScoreText:SetText(text);
	end
	

	SHOW_CHILD_LIST(myGBox, isShow);
	
	local killGBox = GET_CHILD(frame, "killRanking", "ui::CGroupBox");
	local killTitleText = GET_CHILD(killGBox, "killTitle");
	local damageGBox = GET_CHILD(frame, "damageRanking", "ui::CGroupBox");
	local damageTitleText = GET_CHILD(damageGBox, "damageTitle");
	for i=1, 3 do	
		
		-- killRank
		local killRankText = GET_CHILD(killGBox, "killRank"..i);
		local killScoreText = GET_CHILD(killGBox, "killScore"..i);
		killTitleText:SetText(ScpArgMsg("KillRanking"));
		killRankText:SetTextByKey("name", ' ');
		killScoreText:SetTextByKey("score", ' ');

		local killIconInfo = ranking:GetMonKillRankIconInfo(i);
		if killIconInfo ~= nil then
			local nameText =  killIconInfo:GetFamilyName() .. "   " .. killIconInfo:GetGivenName();		
			killRankText:SetTextByKey("name", nameText);
			killScoreText:SetTextByKey("score", ranking:GetMonKillRankScore(i));
		end
		SHOW_CHILD_LIST(killGBox, isShow);


		-- damageRank
		local damageRankText = GET_CHILD(damageGBox, "damageRank"..i);
		local damageScoreText = GET_CHILD(damageGBox, "damageScore"..i);
		damageTitleText:SetText(ScpArgMsg("DamageRanking"));
		damageRankText:SetTextByKey("name", ' ');
		damageScoreText:SetTextByKey("score", ' ');
		
		local damageIconInfo = ranking:GetMonDamageRankIconInfo(i);
		if damageIconInfo ~= nil then
			local nameText =  damageIconInfo:GetFamilyName() .. "   " .. damageIconInfo:GetGivenName();
			damageRankText:SetTextByKey("name", nameText);
			damageScoreText:SetTextByKey("score", ranking:GetMonDamageRankScore(i));
		end
		SHOW_CHILD_LIST(damageGBox, isShow);
	end

	for i = 1 , 3 do 
		local frameLine = GET_CHILD(frame, "label_" ..i , "ui::CGroupBox");	
		frameLine:SetPos(myGBox:GetOriginalX(), myGBox:GetOriginalY() + offset);
	end;
	
	myGBox:SetPos(myGBox:GetOriginalX(), myGBox:GetOriginalY() + offset);
	killGBox:SetPos(killGBox:GetOriginalX(), killGBox:GetOriginalY() + offset);	
	damageGBox:SetPos(damageGBox:GetOriginalX(), damageGBox:GetOriginalY() + offset);
		
	frame:Resize(frame:GetWidth(), frame:GetOriginalHeight() + offset + 30);
end

function SCR_WIKI_MONRANK_TOOLTIP(parent, frame, monName, num)
	
	UPDATE_MONSTER_TOOLTIP(frame, monName);
end

function TRY_PARSE_TOOLTIPCOND(obj, caption)

    local ifPos = string.find(caption, "#!");
	if ifPos == nil then
		return caption, 0;
	end

	local ifEndPos = FIND_STRING(caption, ifPos + 2, " THEN ");
	if ifEndPos == nil then
		return caption, 0;
	end

	local thenPos = FIND_STRING(caption, ifEndPos + 2, " ELSE ");
	if thenPos == nil then
		return caption, 0;
	end

	local elsePos = FIND_STRING(caption, thenPos + 2, " END ");
	if elsePos == nil then
		return caption, 0;
	end


	local ifParsed = string.sub(caption, ifPos + 3, ifEndPos - 2);
	local thenParsed = string.sub(caption, ifEndPos + 5, thenPos - 2);
	local elseParsed = string.sub(caption, thenPos + 6, elsePos - 2);
	local beforeStr = string.sub(caption, 1, ifPos - 1);
	local afterStr = string.sub(caption, elsePos + 4, string.len(caption));

	local funcStr = string.format("function SKL_TEMP_FUNC(obj)\
	  	if %s then return \"%s\"; else return \"%s\"; end; end;", ifParsed, thenParsed, elseParsed);


	local runLoadString		= loadstring(funcStr);
	local funcc = runLoadString(obj);
	local result = SKL_TEMP_FUNC(obj);

	return (beforeStr .. result .. afterStr), 1;

end

function TRY_PARSE_PROPERTY(obj, nextObj, caption)
	local tagStart = string.find(caption, "#{");
	if tagStart ~= nil then
		local nextStr = string.sub(caption, tagStart + 2, string.len(caption));
		local tagEnd = string.find(nextStr, "}#");
		if tagEnd ~= nil then
			local tagText = string.sub(caption, tagStart + 2, tagStart + tagEnd);
			local beforeStr = string.sub(caption, 1, tagStart - 1);
			local endStr = string.sub(caption, tagStart + tagEnd + 3, string.len(caption));

			local propValue;
			if string.sub(tagText, 1, 1) == "1" then
				propValue = nextObj[string.sub(tagText, 2, string.len(tagText))];
			else
				propValue = nextObj[tagText]
			end

			if propValue % 1 ~= 0 then
				propValue = string.format("%.1f", propValue);
			end
			return (beforeStr .. propValue .. endStr), 1;
		end

	end
	return caption, 0;
end

function PARSE_TOOLTIP_CAPTION(_obj, caption)
	caption = dictionary.ReplaceDicIDInCompStr(caption);
	local obj;	
	local parsed = 0;
	
	local hasSkil = true;
	if _obj.Level < 1 then
		hasSkil = false;
	    _obj.Level = 1
	end
	
	--CloneIES_UseCP 를 사용하면 Buff는 정상 Attack는 비정상
	--CloneIES		 를 사용하면 Attack는 정상 buff는 비정상

	local valueType = TryGetProp(_obj, 'ClassName');

	if ValueType  == "Attack" then
		obj = CloneIES(_obj);
	else
		obj = CloneIES_UseCP(_obj);
	end
	
	if obj == nil then
		return caption;
	end

	local nextObj = CloneIES_UseCP(obj);

	if ValueType  == "Attack" then
		nextObj = CloneIES(obj);
	else
		nextObj = CloneIES_UseCP(obj);
	end

	while 1 do
		caption, parsed = TRY_PARSE_TOOLTIPCOND(obj, caption);
		if parsed == 0 then
			break;
		end
	end
	
	
	if nextObj == nil then
		DestroyIES(obj);
		return caption;
	end

	local lvCaption = caption;
	local lvStart, lvEnd = string.find(lvCaption, "Lv.");
	local captionLevel = 0;
	if nil ~= lvStart then
		local afterText  = string.sub(lvCaption, lvEnd+1, lvEnd+1);
		captionLevel = tonumber(afterText);
	end

	local skillLevel = session.GetUserConfig("SKLUP_" .. nextObj.ClassName);
	-- 아직 새션에 레벨업을 안헷거나,
	-- 그 레벨이 현재 레벨보다 작거나
	-- 캡션션레벨과 오브젝트의 레벨이 일치할 때
	if 0 == skillLevel or skillLevel < _obj.Level or captionLevel == _obj.Level then
		if hasSkil == true then
			skillLevel = _obj.Level + skillLevel;
		else
		skillLevel = _obj.Level 
		end
	else-- 아니였다면, skl_pts_up을 하지 않았다는 것
		skillLevel = skillLevel + 1;
	end

	local LevelByDB = TryGetProp(nextObj, 'LevelByDB');

	if LevelByDB ~= nil then
		nextObj.LevelByDB = skillLevel;
	else
		nextObj.Level = skillLevel
	end

	local lvStart, lvEnd = string.find(caption, "Lv.");
	if lvStart ~= nil then
		local beforeText = string.sub(lvCaption, 1, lvStart - 1);
		local afterText  = string.sub(lvCaption, lvEnd+1, string.len(lvCaption));
		lvCaption = beforeText .. "ch."..afterText;
	end
	
	while 1 do
		lvStart, lvEnd = string.find(lvCaption, "Lv.");
		if lvStart ~= nil then
			local propStart = string.find(caption, "#{");
			if propStart ~= nil then
				if lvStart < propStart then
					beforeText = string.sub(lvCaption, 1, lvStart - 1);
					afterText  = string.sub(lvCaption, lvEnd+1, string.len(lvCaption));
					lvCaption = beforeText .. "ch."..afterText;
					DestroyIES(nextObj);				
					nextObj = CloneIES_UseCP(_obj);
					skillLevel = skillLevel + 1;

					if LevelByDB ~= nil then
						nextObj.LevelByDB = skillLevel;
					else
						nextObj.Level = skillLevel
					end
					
				end
			end
		end

		-- 현재레벨
		caption, parsed = TRY_PARSE_PROPERTY(obj, nextObj, caption);
		-- 다음레벨
		lvCaption, parsed = TRY_PARSE_PROPERTY(obj, nextObj, lvCaption);
		if parsed == 0 then
			break;
		end
	end
	DestroyIES(obj);
	DestroyIES(nextObj);
	return caption;

end


function UPDATE_ABILITY_TOOLTIP(frame, strarg, numarg1, numarg2)

	HIDE_CHILD_BYNAME(frame, "1");
	HIDE_CHILD_BYNAME(frame, "2");
	HIDE_CHILD_BYNAME(frame, "3");
	HIDE_CHILD_BYNAME(frame, "4");
	HIDE_CHILD_BYNAME(frame, "5");

	local abil = session.GetAbilityByGuid(numarg2);
	local obj = nil;
	if abil == nil then
		obj = GetClassByType("Ability", numarg1);
	else
		obj = GetIES(abil:GetObject());
	end

	if obj == nil then
		return;
	end

	local iconPicture = GET_CHILD(frame, "icon", "ui::CPicture");
	iconPicture:SetImage(obj.Icon);

	local name = frame:GetChild('name');
	name:SetText('{@st43}'.. obj.Name..'{/}');

	local typeCtrl = GET_CHILD(frame, "type", "ui::CRichText");
	typeCtrl:SetText('{@st42}'..ClMsg("Ability"));

	local descCtrl = GET_CHILD(frame, "desc", "ui::CRichText");
	descCtrl:Resize(frame:GetWidth() - 20, 20);
	descCtrl:SetTextAlign("center", "top");
	descCtrl:SetGravity(ui.CENTER_HORZ, ui.TOP);
	local translatedData = dictionary.ReplaceDicIDInCompStr(obj.Desc);
	if obj.Desc ~= translatedData then
		descCtrl:SetDicIDText(obj.Desc)
	end
	descCtrl:SetText('{#1f100b}'..PARSE_TOOLTIP_CAPTION(obj, obj.Desc));

	local ypos = descCtrl:GetY() + descCtrl:GetHeight();

	local originalText = ""
	local translatedData2 = dictionary.ReplaceDicIDInCompStr(obj.Desc2);
	if obj.Desc2 ~= translatedData2 then
		originalText = obj.Desc2
	end
	local skillLvDesc = PARSE_TOOLTIP_CAPTION(obj, obj.Desc2);

	local lvDescStart, lvDescEnd = string.find(skillLvDesc, "Lv.");

	local lv = 1;
	local totalLevel = 0;

	local stateLevel = session.GetUserConfig("SKLUP_" .. strarg, 0);
	local skl = session.GetAbilityByName(obj.ClassName)
	if skl ~= nil then
		skillObj = GetIES(skl:GetObject());
		totalLevel = skillObj.Level + stateLevel;
	else
		totalLevel = stateLevel;
	end

	if lvDescStart ~= nil and totalLevel ~= 0 then
		skillLvDesc = string.sub(skillLvDesc, lvDescEnd + 2, string.len(skillLvDesc));
		while 1 do

			local levelvalue = 2
			if lv >= 9 then
				levelvalue = 3
			elseif lv >= 99 then
				levelvalue = 4
			end

			lvDescStart, lvDescEnd = string.find(skillLvDesc, "Lv.");
			if lvDescStart == nil then
				local lvDesc = string.sub(skillLvDesc, 2, string.len(skillLvDesc));
				ypos = SKILL_LV_DESC_TOOLTIP(frame, obj, totalLevel, lv, lvDesc, ypos, originalText);
				break;
			end
			local lvDesc = string.sub(skillLvDesc, 2, lvDescStart -1);
			skillLvDesc  = string.sub(skillLvDesc, lvDescEnd + levelvalue, string.len(skillLvDesc));
			ypos = SKILL_LV_DESC_TOOLTIP(frame, obj, totalLevel, lv, lvDesc, ypos, originalText);
			lv = lv + 1;
		end
	end

	frame:Resize(frame:GetWidth(), ypos + 30);
 end

function UPDATE_SKILL_TOOLTIP(frame, strarg, numarg1, numarg2, userData, obj)
	DESTROY_CHILD_BYNAME(frame, 'SKILL_CAPTION_');
	local abil = session.GetSkillByGuid(numarg2);
	local obj = nil;
	local objIsClone = false;
	local tooltipStartLevel = 1;
	if abil == nil then
		obj = GetClassByType("Skill", numarg1);
		if strarg == "Level" then
			obj = CloneIES_UseCP(obj);
			obj.LevelByDB = numarg2;
			tooltipStartLevel = numarg2;
			objIsClone= true;
		end
	else
		obj = GetIES(abil:GetObject());
		tooltipStartLevel = obj.Level;
	end

	if obj == nil then
		return;
	end
	local iconPicture = GET_CHILD(frame, "icon", "ui::CPicture");
	local iconname = "icon_" .. obj.Icon;
	iconPicture:SetImage(iconname);

	local name = frame:GetChild('name');
	local nameText = '{@st43}'..obj.Name;
	
	local translatedData = dictionary.ReplaceDicIDInCompStr(obj.Name);
	if obj.EngName ~= translatedData then
		if config.GetServiceNation() ~= "GLOBAL" then
			nameText = nameText .. "{/}{nl}" .. obj.EngName;
		end
	end

	name:SetText(nameText);

	local skillDesc = GET_CHILD(frame, "desc", "ui::CRichText");
	
	skillDesc:Resize(320, 20);
	skillDesc:SetTextAlign("left", "top");
	skillDesc:SetGravity(ui.CENTER_HORZ, ui.TOP);
	local translatedData = dictionary.ReplaceDicIDInCompStr(obj.Caption);
	if obj.Caption ~= translatedData then
		skillDesc:SetDicIDText(obj.Caption)
	end
	skillDesc:SetText('{#1f100b}'..PARSE_TOOLTIP_CAPTION(obj, obj.Caption));
	skillDesc:EnableSplitBySpace(0);


	local stateLevel = session.GetUserConfig("SKLUP_" .. strarg, 0);
	tooltipStartLevel = tooltipStartLevel + stateLevel;


	local skilltreecls = GetClassByStrProp("SkillTree", "SkillName", obj.ClassName);
	if skilltreecls ~= nil then
		if skilltreecls.MaxLevel < tooltipStartLevel then
			 tooltipStartLevel = skilltreecls.MaxLevel
		end
	end

	local ypos = skillDesc:GetY() + skillDesc:GetHeight() + 40;
	local skillCaption2 = MAKE_SKILL_CAPTION2(obj.ClassName, obj.Caption2, tooltipStartLevel);
	
	local originalText = ""
	local translatedData2 = dictionary.ReplaceDicIDInCompStr(skillCaption2);
	
	if skillCaption2 ~= translatedData2 then
		originalText = skillCaption2
	end
	
	local skillLvDesc = PARSE_TOOLTIP_CAPTION(obj, skillCaption2);
	local lvDescStart, lvDescEnd = string.find(skillLvDesc, "Lv.");

	local lv = 1;
	if tooltipStartLevel > 0 then
		lv = tooltipStartLevel;
	end	
		
	local totalLevel = 0;
	local skl = session.GetSkillByName(obj.ClassName);
	if strarg ~= "Level" then
		if skl ~= nil then
			skillObj = GetIES(skl:GetObject());
			totalLevel = skillObj.Level + stateLevel;
		else
			totalLevel = totalLevel + stateLevel;
		end
	else
		totalLevel = obj.LevelByDB;
	end

	if skilltreecls ~= nil then
		if skilltreecls.MaxLevel < totalLevel then
			totalLevel = skilltreecls.MaxLevel
		end
	end

	if totalLevel == 0 and lvDescStart ~= nil then
	
		skillLvDesc = string.sub(skillLvDesc, lvDescEnd + 2, string.len(skillLvDesc));
		lvDescStart, lvDescEnd = string.find(skillLvDesc, "Lv.");
		if lvDescStart ~= nil then
	
			local lvDesc = string.sub(skillLvDesc, 2, lvDescStart -1);
			skillLvDesc  = string.sub(skillLvDesc, lvDescEnd + 2	, string.len(skillLvDesc));
			ypos = SKILL_LV_DESC_TOOLTIP(frame, obj, totalLevel, lv, lvDesc, ypos, originalText);

			local lvDescCtrlSet = frame:GetChild("SKILL_CAPTION_1");
			lvDescCtrlSet:SetDraw(1);
			local descText = GET_CHILD(lvDescCtrlSet, "desc", "ui::CRichText");
			local newfontstr = string.sub(descText:GetText(),9,string.len(descText:GetText()))
			descText:SetText("{@st66b}"..newfontstr);
		else -- 1레벨밖에 없는 스킬의 경우
			local lvDesc = string.sub(skillLvDesc, 2, string.len(skillLvDesc));
			ypos = SKILL_LV_DESC_TOOLTIP(frame, obj, totalLevel, lv, lvDesc, ypos, originalText);

			local lvDescCtrlSet = frame:GetChild("SKILL_CAPTION_1");
			lvDescCtrlSet:SetDraw(1);
			local descText = GET_CHILD(lvDescCtrlSet, "desc", "ui::CRichText");
			local newfontstr = string.sub(descText:GetText(),9,string.len(descText:GetText()))
			descText:SetText("{@st66b}"..newfontstr);
			
		end
	
	elseif lvDescStart ~= nil and totalLevel ~= 0 then
		skillLvDesc = string.sub(skillLvDesc, lvDescEnd + 2, string.len(skillLvDesc));

		while 1 do

			local levelvalue = 2
			if lv >= 9 then
				levelvalue = 3
			elseif lv >= 99 then
				levelvalue = 4
			end

			lvDescStart, lvDescEnd = string.find(skillLvDesc, "Lv.");

			if lvDescStart == nil then
				local lvDesc = string.sub(skillLvDesc, 2, string.len(skillLvDesc));
				ypos = SKILL_LV_DESC_TOOLTIP(frame, obj, totalLevel, lv, lvDesc, ypos, originalText);
				break;
			end
			local lvDesc = string.sub(skillLvDesc, 2, lvDescStart -1);
			skillLvDesc  = string.sub(skillLvDesc, lvDescEnd + levelvalue	, string.len(skillLvDesc));
			ypos = SKILL_LV_DESC_TOOLTIP(frame, obj, totalLevel, lv, lvDesc, ypos, originalText);
			lv = lv + 1;
		end
	end
	
	local noTrade = GET_CHILD(frame, "trade_text", "ui::CRichText");
	local itemID = frame:GetUserValue("SCROLL_ITEM_ID");
	local noTradeCnt = nil;
	if itemID ~= "None" then
		local scrollInvType = frame:GetUserValue("SCROLL_ITEM_INVTYPE");
		local itemObj, isReadObj = GET_TOOLTIP_ITEM_OBJECT(scrollInvType, itemID);
		if itemObj ~= nil then
			noTradeCnt = TryGetProp(itemObj, "BelongingCount");
			if isReadObj == 1 then
				DestroyIES(itemObj);
			end
		end
	end
	
	if noTradeCnt ~= nil and 0 <= noTradeCnt then
		noTrade:SetTextByKey('count', noTradeCnt);
		noTrade:ShowWindow(1);
		noTrade:SetOffset(noTrade:GetOriginalX() + 10, ypos - noTrade:GetOriginalHeight());
	else
		noTrade:SetOffset(noTrade:GetOriginalX(),noTrade:GetOriginalY());
		noTrade:ShowWindow(0);
	end

	noTrade:Invalidate();
	frame:Resize(frame:GetWidth(), ypos + 10);
	frame:Invalidate();

	if objIsClone == true then
		DestroyIES(obj);
	end
 end

 function MAKE_SKILL_CAPTION2(className, caption2, curLv)

	local originCaption = caption2;

	local clslist, cnt  = GetClassList("SkillTree");
	if cnt == 0 then
		return originCaption;
	end

	local caption = "";
	local beginLv = 1;
	local maxLevel = 2;
	for i=0, cnt-1 do
		local class = GetClassByIndexFromList(clslist, i);
		if class ~= nil then
			if class.SkillName == className then
				maxLevel = class.MaxLevel;
				break;
			end
		end
	end

	-- 1~maxLevel까지 모든 caption을 한번에 가져오면 버퍼사이즈 넘어서 클라다운됨. 필요한거 2개만 가져오도록 함.
	if curLv ~= nil then
		if curLv == 0 then
			beginLv = 1;
		else
			beginLv = curLv;
		end

		if maxLevel >= beginLv + 1 then
			maxLevel = beginLv + 1;
		end
	end
		
	for i = beginLv, maxLevel do
		caption = caption .. "Lv."..i;
		if i < 10 then
			caption = caption .. "," .. originCaption;
		else
			caption = caption .. " " ..  originCaption;
		end
	end

	return caption;
 end

 function SKILL_LV_DESC_TOOLTIP(frame, obj, totalLevel, lv, desc, ypos, dicidtext)

	if totalLevel ~= lv and totalLevel + 1 ~= lv then
		return ypos;
	end

	local lvDescCtrlSet = frame:CreateOrGetControlSet("skilllvdesc", "SKILL_CAPTION_"..tostring(lv), 100, ypos);
	tolua.cast(lvDescCtrlSet, "ui::CControlSet");
	local LEVEL_FONTNAME = lvDescCtrlSet:GetUserConfig("LEVEL_FONTNAME")
	local LEVEL_NEXTLV_FONTNAME = lvDescCtrlSet:GetUserConfig("LEVEL_NEXTLV_FONTNAME")
	local DESC_FONTNAME = lvDescCtrlSet:GetUserConfig("DESC_FONTNAME")
	local DESC_NEXTLV_FONTNAME = lvDescCtrlSet:GetUserConfig("DESC_NEXTLV_FONTNAME")

	local lvText = lvDescCtrlSet:GetChild("level");

	lvText:SetText(LEVEL_FONTNAME..ScpArgMsg("Level{Level}","Level",lv));
	local descText = GET_CHILD(lvDescCtrlSet, "desc", "ui::CRichText");
	descText:EnableSplitBySpace(0);

	if dicidtext ~= nil and dicidtext ~= "" then
		descText:SetDicIDText(dicidtext)
	end

	if totalLevel == lv then
		lvDescCtrlSet:SetDraw(1);
		lvText:SetText(LEVEL_FONTNAME..ScpArgMsg("Level{Level}","Level",lv));
		descText:SetText(DESC_FONTNAME..desc);
	else
		lvDescCtrlSet:SetDraw(0);
		lvText:SetText(LEVEL_NEXTLV_FONTNAME..ScpArgMsg("Level{Level}","Level",lv));
		descText:SetText(DESC_NEXTLV_FONTNAME..desc);
	end

	lvDescCtrlSet:Resize(frame:GetWidth()-120, descText:GetY()+descText:GetHeight() + 15);

	lvDescCtrlSet:ShowWindow(1);
	return ypos + lvDescCtrlSet:GetHeight() + 5;
 end

function SET_TOOLTIP_ZOMBIECAPSULE_DESC(obj)

	local retString = "";
	local keyWordIndex = 1;
	while 1 do
		local keyWord = TryGetProp(obj, GET_KEYWORD_PROP_NAME(keyWordIndex));
		if keyWord == nil or keyWord == "None" then
			break;
		end

		local monList = TokenizeByChar(keyWord, "@");
		for j = 1 , #monList do
			local monInfo = monList[j];
			local info = TokenizeByChar(monInfo, "#");
			local monType = info[1];
			local lv = info[2];
			local zombieType = tonumber(info[3]);
			local hp = info[4];
			
			if retString ~= "" then
				retString = retString .. "{nl}";
			end

			local monCls = GetClass("Monster", GET_SUMMON_ZOMBIE_NAME(zombieType));
			retString = retString  .. monCls.Name .. " (Lv." .. lv .. " , HP:" .. hp .. "%)";
		end
		
		keyWordIndex = keyWordIndex + 1;
	end
	
	return retString;
end


