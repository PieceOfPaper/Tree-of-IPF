QUEST_TITLE_FONT = "{@st41b}";
QUEST_GROUP_TITLE_FONT = "{@st42b}";
QUEST_NORMAL_FONT = "{@st42b}";
ABANDON_TEXT = ScpArgMsg("Auto_{@st45tw}PoKiHaKi");
GUILD_QUEST_FONT = "{@st42b}";
ABANDON_BTN_SKIN_NAME = "button_abandon";
SUCCESS_QUEST_INFO = {};
IES_CTRL_OFFSET = 25;
SCROLL_WIDTH = 20;

function QUESTINFOSET_2_ON_INIT(addon, frame)

	addon:RegisterMsg('END_QUEST_KILLCNT', 'QUEST_KILLCNT_END');
	--addon:RegisterMsg('POSSIBLE_QUEST', 'QUESTINFOSET_2_POSSIBLE_QUEST');
	addon:RegisterMsg('GAME_START', 'UPDATE_QUESTINFOSET_2');
	addon:RegisterMsg('QUEST_UPDATE', 'UPDATE_QUESTINFOSET_2');
	--addon:RegisterMsg('ACHIEVE_POINT', 'UPDATE_QUESTINFOSET_2');
	addon:RegisterMsg('LAYER_CHANGE', 'UPDATE_QUESTINFOSET_2');
	addon:RegisterMsg('SET_REMAIN_TIME', 'UPDATE_QUESTINFOSET_2');
	addon:RegisterMsg('SESSIONOBJ_QUEST_ADD', 'UPDATE_CHECK_QUEST');
	addon:RegisterMsg('QUEST_EFFECT_START', 'QUESTINFOSET_2_QUEST_EFFECT');
	addon:RegisterOpenOnlyMsg('ANGLE_UPDATE', 'QUESTINFOSET_2_QUEST_ANGLE');
	addon:RegisterMsg('PARTY_MEMBER_PROP_UPDATE', 'QUEST_PARTY_MEMBER_PROP_UPDATE');
	addon:RegisterMsg('PARTY_MEMBER_UPDATE', 'QUESTSET2_PARTY_MEMBER_UPDATE');
	addon:RegisterMsg("PARTY_SOBJ_UPDATE", "QUEST_PARTY_SOBJ_UPDATE");

	addon:RegisterMsg('S_OBJ_UPDATE', 'UPDATE_QUESTINFOSET_2');
		
end

g_questCheckFunc = nil;

function SCR_QUEST_CHECK_Q(pc, questName)
	if g_questCheckFunc == nil then
		return SCR_QUEST_CHECK_C(pc, questName);
	else
		return g_questCheckFunc(pc, questName);
	end
end

g_questCheckPC = nil;
g_questCheckPCInfo = nil;

function SCR_QUESTINFO_GET_PC()
	if g_questCheckPC ~= nil then
		return g_questCheckPC;
	end

	return GetMyPCObject();
end

function GET_QUESTINFO_PC_FID()
	if g_questCheckPC ~= nil then
		return g_questCheckPCInfo:GetAID();
	end

	return 0;
end

g_getItemCountFunc = nil;

function SCR_QUEST_GET_INVITEM_COUNT(itemName)
	if g_getItemCountFunc == nil then
		local item = session.GetInvItemByName(itemName);
		local itemcnt = 0;
		if item ~= nil then
			itemcnt = item.count;
		end

		return itemcnt;
	else
		return g_getItemCountFunc(itemName);
	end
end

function SCR_QUEST_GET_SOBJ(pc, sObjName)
	local s_obj = GetClass("SessionObject", sObjName);
    local myObj = GetSessionObject(pc, sObjName);
	if myObj ~= nil then	
		return myObj;
	end

	return s_obj;
end

function QUESTINFOSET_2_POSSIBLE_QUEST(frame, msg, argStr, questID)
    QUESTINFOSET_2_NEW_QUEST(frame, msg, argStr, questID);
end

function QUEST_KILLCNT_END(frame, msg, argStr, questID)
	quest.RemoveAllQuestMonsterList(questID);
end

function QUESTINFOSET_2_NEW_QUEST(frame, msg, argStr, questID)

    local questcls = GetClassByType("QuestProgressCheck", questID);
	local pc = SCR_QUESTINFO_GET_PC();
	if 1 == HIDE_IN_QUEST_LIST(pc, questcls) then
		return;
	end

	if questcls.JobLvup ~= 'None' or questcls.JobLvdown ~= 'None' or tonumber(questcls.JobStep) ~= 0 then
		quest.CheckJobLvQuestList();
		UPDATE_QUESTINFOSET_2(frame);
	end

	if questcls.QuestMode ~= 'MAIN' then
		return;
	end

	if quest.GetCheckQuestCount() >= 5 then
		return;
	end

	quest.AddCheckQuest(questID);

	local questFrame = ui.GetFrame('quest');
	local ctrlName = "_Q_" .. questID;
	local questCtrl = questFrame:GetChild(ctrlName);
	if questCtrl ~= nil then
		local checkBox = GET_CHILD(questCtrl, "save", "ui::CCheckBox");
		checkBox:SetCheck(1);
	end

end

function QUESTINFOSET_2_QUEST_EFFECT(frame, msg, argStr, argNum)

	local questCls = GetClass('QuestProgressCheck', argStr);
	local GroupCtrl = GET_CHILD(frame, "member", "ui::CGroupBox");
	local ctrlname = "_Q_" .. questCls.ClassID;
	local ctrlSet = GroupCtrl:GetChild(ctrlname);
	local pc = GetMyPCObject();
	
	if SCR_QUEST_CHECK_C(pc, questCls.ClassName) == 'PROGRESS' then
	    local ret = SCR_QUEST_POSSIBLE_CHECK_ITEM_LIST(pc, questCls)
	    if table.find(ret, 'Check_QuestCount') > 0 then
    	    table.remove(ret, table.find(ret, 'Check_QuestCount'))
    	end
    	if table.find(ret, 'Lvup') > 0 then
    	    table.remove(ret, table.find(ret, 'Lvup'))
    	end
    	if table.find(ret, 'Lvdown') > 0 then
    	    table.remove(ret, table.find(ret, 'Lvdown'))
    	end
	    if #ret > 0 then
	        imcSound.PlaySoundEvent('sys_secret_alarm')
	    else
	        imcSound.PlaySoundEvent('quest_event_click')
	    end
    else
        imcSound.PlaySoundEvent('quest_event_click')
    end
    
	if ctrlSet ~= nil then
		local posX, posY = GET_SCREEN_XY(ctrlSet);
		if argNum == 1 then
			movie.PlayUIEffect("SYS_quest_mark", posX, posY, 1.0);
		else
			movie.PlayUIEffect("SYS_quest_mark_blue", posX, posY, 1.0);
		end
	end
end

function PC_ENTER_QUESTINFO(frame)
	local cnt = quest.GetCheckQuestCount();
	for i = 0 , cnt - 1 do
		local questID =  quest.GetCheckQuest(i);
		quest.AddCheckQuestMonsterListById(questID);
	end
end

function UPDATE_QUESTINFOSET_2_BY_TYPE(GroupCtrl, msg, updateQuestID)

	local questcls = GetClassByType("QuestProgressCheck", updateQuestID);

	local ctrlset = MAKE_QUEST_INFO_C(GroupCtrl, questcls, msg);
end

function QUESTINFOSET_2_AUTO_ALIGN(frame, GroupCtrl)
	QUEST_GBOX_AUTO_ALIGN(frame, GroupCtrl, 0, 3, 100);
end

function QUESTINFOSET_2_REMOVE_QUEST(frame, questID)

	local questIES = GetClassByType("QuestProgressCheck", questID);

	local translated_QuestGroup = dictionary.ReplaceDicIDInCompStr(questIES.QuestGroup);

	local GroupCtrl = GET_CHILD(frame, "member", "ui::CGroupBox");
	if translated_QuestGroup == "None" then
		local ctrlname = "_Q_" .. questID;
		GroupCtrl:RemoveChild(ctrlname);
	else
		local strFindStart, strFindEnd = string.find(translated_QuestGroup, "/");
		local questGroupName  = string.sub(translated_QuestGroup, 1, strFindStart-1);
		local ctrlname = "_Q_" .. questGroupName;
		GroupCtrl:RemoveChild(ctrlname);
	end

	QUESTINFOSET_2_AUTO_ALIGN(frame, GroupCtrl);
end

function UPDATE_QUESTINFOSET_2(frame, msg, check, updateQuestID)
--	local warpFrame = ui.GetFrame('questwarp');
--	for i=0, QUESTWARP_MAX_BTN-1 do
--		warpFrame:SetUserValue("QUEST_WARP_CLASSNAME_"..i, "None");
--	end
    if UI_CHECK_NOT_PVP_MAP() == 0 then
        frame:ShowWindow(0);
        return;
    end

	local cnt = quest.GetCheckQuestCount();
	local customCnt = geQuest.GetCustomQuestCount();
	if cnt + customCnt > 0 then
		frame:ShowWindow(1);
	else
		frame:ShowWindow(0);
	end

	if updateQuestID ~= nil and updateQuestID > 0 then
		local GroupCtrl = GET_CHILD(frame, "member", "ui::CGroupBox");
		UPDATE_QUESTINFOSET_2_BY_TYPE(GroupCtrl, msg, updateQuestID);
		QUESTINFOSET_2_AUTO_ALIGN(frame, GroupCtrl);
		return;
	end

	if msg == 'GAME_START' then
		PC_ENTER_QUESTINFO(frame);
	end
	
	local GroupCtrl = GET_CHILD(frame, "member", "ui::CGroupBox");
	GroupCtrl:DeleteAllControl();

	for i = 0 , cnt - 1 do
		local questID = quest.GetCheckQuest(i);
		local questcls = GetClassByType("QuestProgressCheck", questID);
		MAKE_QUEST_INFO_C(GroupCtrl, questcls, msg);
	end

	if customCnt > 0 then
		QUESTINFOSET_2_MAKE_CUSTOM(frame, true);
	end

	QUESTINFOSET_2_AUTO_ALIGN(frame, GroupCtrl);

	QUEST_PARTY_MEMBER_PROP_UPDATE(frame);

end

function CHEAK_QUEST_MONSTER(questIES)
	local pc = GetMyPCObject();
    local quest_sObj
    if questIES.Quest_SSN ~= 'None' then
        quest_sObj = GetSessionObject(pc, questIES.Quest_SSN);
    end
    
	for i = 1 , QUEST_MAX_MON_CHECK do
		local monname = questIES["Succ_MonKillName" .. i];
		if monname == "None" then
			break;
		end
		
		if questIES.Succ_Check_MonKill > 0 then
    		if quest_sObj ~= nil and quest_sObj['KillMonster'..i] < questIES["Succ_MonKillCount" .. i] then
        		ADD_QUEST_CHECK_MONSTER(questIES.ClassID, monname);
        	else
        	    local cutStr = SCR_STRING_CUT(monname);
            	if #cutStr > 1 then
            		for y = 1 , #cutStr do
            		    quest.RemoveCheckQuestMonsterList(questIES.ClassID, cutStr[y])
            		end
            	else
            		quest.RemoveCheckQuestMonsterList(questIES.ClassID, monname)
            	end
        	end
        else
--            local invIndex = tonumber(string.gsub(questIES["Succ_MonKill_ItemGive" .. i], 'Succ_InvItemName', ''))
            local itemClassName = questIES[questIES["Succ_MonKill_ItemGive" .. i]]
            local needCount = questIES[questIES["Succ_MonKill_ItemGiveCount" .. i]]
            if itemClassName ~= nil then
                local nowCount = GetInvItemCount(pc, itemClassName)
                if nowCount < needCount then
                    ADD_QUEST_CHECK_MONSTER(questIES.ClassID, monname);
                else
                    local cutStr = SCR_STRING_CUT(monname);
                	if #cutStr > 1 then
                		for y = 1 , #cutStr do
                		    quest.RemoveCheckQuestMonsterList(questIES.ClassID, cutStr[y])
                		end
                	else
                		quest.RemoveCheckQuestMonsterList(questIES.ClassID, monname)
                	end
                end
            end
        end
	end
	for i = 1 , QUEST_MAX_INVITEM_CHECK do
		local questItem = questIES["Succ_InvItemName" .. i];
		if questItem == 'None' then
			break;
		end

		local needcnt = questIES["Succ_InvItemCount" .. i];

		local itemcnt = SCR_QUEST_GET_INVITEM_COUNT(questItem);
	end
	
	if pc ~= nil then
	    if questIES.Quest_SSN ~= 'None' then
    	    if quest_sObj ~= nil then
    	        if quest_sObj.SSNMonKill ~= 'None' then
    	            local monInfo = SCR_STRING_CUT(quest_sObj.SSNMonKill, ":")
                    if #monInfo >= 3 and #monInfo % 3 == 0 and monInfo[1] ~= 'ZONEMONKILL' then
                        local ssnMonListCount = #monInfo / 3
                        local flag = 0
                        for i = 1, QUEST_MAX_MON_CHECK do
                            if ssnMonListCount >= i then
                                local needCount = tonumber(monInfo[i*3 - 1])
                                local nowCount = quest_sObj['KillMonster'..i]
                                if nowCount < needCount and GetZoneName(pc) == monInfo[i*3] then
                                    ADD_QUEST_CHECK_MONSTER(questIES.ClassID, monInfo[i*3 - 2]);
                                end
                            else
                                break
                            end
                        end
                    elseif monInfo[1] == 'ZONEMONKILL'  then
                        for i = 1, QUEST_MAX_MON_CHECK do
                            if #monInfo - 1 >= i then
                                local index = i + 1
                                local zoneMonInfo = SCR_STRING_CUT(monInfo[index])
                                local needCount = tonumber(zoneMonInfo[2])
                                local nowCount = quest_sObj['KillMonster'..i]
                                if nowCount < needCount and GetZoneName(pc) == zoneMonInfo[1] then
                                    local targetMonList = SCR_GET_ZONE_FACTION_OBJECT(zoneMonInfo[1], 'Monster', 'Normal/Material/Elite', 120000)
                                    for i2 = 1, #targetMonList do
                                        ADD_QUEST_CHECK_MONSTER(questIES.ClassID, targetMonList[i2][1]);
                                    end
                                end
                            else
                                break
                            end
                        end
                    end
    	        end
    	    end
    	end
	end
	
	
	for i = 1 , QUEST_MAX_MON_CHECK do
		local monname = questIES["Succ_Journal_MonKillName" .. i];
		if monname == "None" then
			break;
		end
		
		if GetPropType(questIES, 'Succ_Journal_MonKillName'..i) ~= nil and questIES["Succ_Journal_MonKillName" .. i] ~= 'None' then
		    local monCls = GetClass('Monster', questIES['Succ_Journal_MonKillName'..i]);
            local monID = TryGetProp(monCls, 'ClassID');
		    local killCount
            if monID ~= nil and IsExistMonsterInAdevntureBook(pc, monID) == 'YES' then
                killCount = GetMonKillCount(pc, monID);
            end
            if killCount ~= nil and killCount < questIES["Succ_Journal_MonKillCount" .. i] then
                ADD_QUEST_CHECK_MONSTER(questIES.ClassID, monname);
            else
                quest.RemoveCheckQuestMonsterList(questIES.ClassID, monname)
            end
        end
	end

	CHECK_QUEST_MONSTER_GROUP(questIES);
end

function UPDATE_CHECK_QUEST(frame, msg, argStr, argNum)
	local s_obj = GetClassByType('SessionObject', argNum);
	if s_obj == nil then
		return;
	end
	local sobjinfo = session.GetSessionObject(s_obj.ClassID);
	if sobjinfo ~= nil then
		local obj = GetIES(sobjinfo:GetIESObject());
		local questIES = GetClass("QuestProgressCheck", s_obj.QuestName);
		if obj ~= nil and questIES ~= nil then

			for i = 1, SESSION_MAX_MON_NAME_GROUP do
				local monNameGroup = obj["QuestMonNameGroup"..i];
				local monNameGroupView = obj["QuestMonView"..i];
				if monNameGroup ~= "None" and monNameGroupView == 1 then
					local monName = monNameGroup;
					if string.find(monName, "/") == nil then
						ADD_QUEST_CHECK_MONSTER(questIES.ClassID, monName);
					else
						while 1 do
							local divStart, divEnd = string.find(monName, "/");
							if divStart == nil then
								ADD_QUEST_CHECK_MONSTER(questIES.ClassID, monName);
								break;
							end

							local divMonName = string.sub(monName, 1, divStart-1);
							ADD_QUEST_CHECK_MONSTER(questIES.ClassID, divMonName);
							monName = string.sub(monName, divEnd +1, string.len(monName));
						end
					end
				elseif monNameGroup ~= "None" and monNameGroupView == 0 then
					local monName = monNameGroup;
					if string.find(monName, "/") == nil then
						quest.RemoveCheckQuestMonsterList(questIES.ClassID, monName);
					else
						while 1 do
							local divStart, divEnd = string.find(monName, "/");
							if divStart == nil then
								quest.RemoveCheckQuestMonsterList(questIES.ClassID, monName);
								break;
							end

							local divMonName = string.sub(monName, 1, divStart-1);
							quest.RemoveCheckQuestMonsterList(questIES.ClassID, divMonName);
							monName = string.sub(monName, divEnd +1, string.len(monName));
						end
					end
				end
			end
		end
	end

end

function CHECK_QUEST_MONSTER_GROUP(questIES)
	local s_obj = GetClass("SessionObject", questIES.Quest_SSN);
	if s_obj ~= nil then
		local sobjinfo = session.GetSessionObject(s_obj.ClassID);
		if sobjinfo ~= nil then
			local obj = GetIES(sobjinfo:GetIESObject());
			if obj ~= nil then
				for i = 1, SESSION_MAX_MON_NAME_GROUP do
					local monNameGroup = obj["QuestMonNameGroup"..i];
					local monNameGroupView = obj["QuestMonView"..i];
					if monNameGroup ~= "None" and monNameGroupView == 1 then
						local monName = monNameGroup;
						if string.find(monName, "/") == nil then
							ADD_QUEST_CHECK_MONSTER(questIES.ClassID, monName);
						else
							while 1 do
								local divStart, divEnd = string.find(monName, "/");
								if divStart == nil then
									ADD_QUEST_CHECK_MONSTER(questIES.ClassID, monName);
									break;
								end

								local divMonName = string.sub(monName, 1, divStart-1);
								ADD_QUEST_CHECK_MONSTER(questIES.ClassID, divMonName);
								monName = string.sub(monName, divEnd +1, string.len(monName));
							end
						end
					elseif monNameGroup ~= "None" and monNameGroupView == 0 then
						local monName = monNameGroup;
						if string.find(monName, "/") == nil then
							quest.RemoveCheckQuestMonsterList(questIES.ClassID, monName);
						else
							while 1 do
								local divStart, divEnd = string.find(monName, "/");
								if divStart == nil then
									quest.RemoveCheckQuestMonsterList(questIES.ClassID, monName);
									break;
								end

								local divMonName = string.sub(monName, 1, divStart-1);
								quest.RemoveCheckQuestMonsterList(questIES.ClassID, divMonName);
								monName = string.sub(monName, divEnd +1, string.len(monName));
							end
						end
					end
				end
			end
		end
	end
end

DEFAULT_START_X = 30

function ATTACH_TIME_CTRL(ctrlset, sObj, y)

	if sObj == nil then
		return y;
	end

	local sObjInfo = session.GetSessionObject(sObj.ClassID);
	if sObjInfo == nil then
		return y;
	end

	local time = sObjInfo:GetRemainTime();

	if time == 0 then
		return y;
	end

	local txt = ctrlset:CreateOrGetControl("richtext", "commatext", DEFAULT_START_X + 85, y + 5, 100, 100);
	tolua.cast(txt, "ui::CRichText");
	txt:SetText("{s18}{ol}:{/}");

	local m1time = ctrlset:CreateOrGetControl('picture', "m1time", 80, y + 5, 28, 38);
	local m2time = ctrlset:CreateOrGetControl('picture', "m2time", 110, y + 5, 28, 38);
	local s1time = ctrlset:CreateOrGetControl('picture', "s1time", 150, y + 5, 28, 38);
	local s2time = ctrlset:CreateOrGetControl('picture', "s2time", 180, y + 5, 28, 38);
	tolua.cast(m1time, "ui::CPicture");
	m1time:SetImage("time_0");
	y = y + m1time:GetHeight();

	ctrlset:RunUpdateScript("UPDATE_Q_TIME_CTRLSET", 0.3);

	local time = sObjInfo:GetRemainTime();
	local min, sec = GET_QUEST_MIN_SEC(time);
	SET_QUESTINFO_TIME_TO_SET(min, sec, ctrlset);

	return y;
end

function UPDATE_Q_TIME_CTRLSET(ctrlset)

	local sObj = session.GetSessionObject(ctrlset:GetValue());
	if sObj == nil then
		return 0;
	end

	local time = sObj:GetRemainTime();
	local min, sec = GET_QUEST_MIN_SEC(time);

	SET_QUESTINFO_TIME_TO_SET(min, sec, ctrlset);
	--ctrlset:GetTopParentFrame():Invalidate();
	return 1;

end

function SET_QUESTINFO_TIME_TO_SET(min, sec, ctrlset)

	local m1time = ctrlset:GetChild('m1time');
	local m2time = ctrlset:GetChild('m2time');
	local s1time = ctrlset:GetChild('s1time');
	local s2time = ctrlset:GetChild('s2time');

	tolua.cast(m1time, "ui::CPicture");
	tolua.cast(m2time, "ui::CPicture");
	tolua.cast(s1time, "ui::CPicture");
	tolua.cast(s2time, "ui::CPicture");

	SET_QUESTINFO_TIME_TO_PIC(min, sec, m1time, m2time, s1time, s2time);

end

function ATTACH_QUEST_ITEM_INFO(ctrlset, QuestIES, result, titleWidth)

	local itemName = QuestIES.QuestItem;
	if itemName == "None" or result ~= "PROGRESS" then
		return DEFAULT_START_X, titleWidth;
	end

	local itemCls = GetClass("Item", itemName);
	local type = itemCls.ClassID;
	local invItem = session.GetInvItemByType(type);
	if invItem == nil or invItem.count == 0 then
		return DEFAULT_START_X, titleWidth;
	end

	local itemIconSize = 36;
	local slotX = 5;

	local slot = ctrlset:CreateOrGetControl('slot', "questItem", slotX, 0, itemIconSize, itemIconSize);
	SET_SLOT_ITEM_INV(slot, GetClass("Item", itemName));
	slot:SetSkinName('questitemslot');
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	ICON_SET_ITEM_COOLDOWN(icon, invItem.type);
	icon:Set(iconInfo.imageName, 'Item', invItem.type, invItem.invIndex, invItem:GetIESID(), invItem.count);
	slot:EnableDrag(0);
	slot:EnableHitTest(1);
	ctrlset:EnableHitTest(1);

	return DEFAULT_START_X, ctrlset:GetWidth() - itemIconSize - 15;

end

function GET_MONGEN_NPCTYPE(mapName, npcFuncName)
	local mapprop = geMapTable.GetMapProp(mapName);
	if mapprop == nil then
		return nil;
	end
	local mongens = mapprop.mongens;

	if mongens == nil then
		return nil;
	end
	local cnt = mongens:Count();
	local WorldPos;
	local minimapPos;


	for i = 0 , cnt - 1 do
		local MonProp = mongens:Element(i);
		if MonProp:GetDialog() == npcFuncName then
			return MonProp:GetClassType();
		end
	end

	return nil;
end

function GET_MONGEN_NPC_MONPROP(mapName, npcFuncName)
	local mapprop = geMapTable.GetMapProp(mapName);
	if mapprop == nil then
		return nil;
	end
	local mongens = mapprop.mongens;

	if mongens == nil then
		return nil;
	end

	local cnt = mongens:Count();
	for i = 0 , cnt - 1 do
		local MonProp = mongens:Element(i);
		if MonProp:GetDialog() == npcFuncName then
			return MonProp;
		end
	end

	return nil;
end

function GET_QUESTINFOSET_ICON_BY_STATE_MODE(state, questIES)
    local tail = GET_MARK_TAIL(questIES)
    local modeicon = 'MAIN'
    if tail == '_sub' then
        modeicon = 'SUB'
    elseif tail == '_repeat' then
        modeicon = 'REPEAT'
    elseif tail == '_period' then
        modeicon = 'PERIOD'
    elseif tail == '_party' then
        modeicon = 'PARTY'
    elseif tail == '_key' then
        modeicon = 'KEYQUEST'
    end
    
	if state == 'SUCCESS' then
		return "questinfo_3_" ..modeicon;
	elseif state == 'PROGRESS' then
	    if questIES ~= nil and questIES.StartNPC ~= questIES.ProgNPC and questIES.StartNPC ~= questIES.EndNPC and questIES.ProgNPC == questIES.EndNPC then
	        local questIES_auto = GetClass('QuestProgressCheck_Auto',questIES.ClassName)
	        if questIES_auto ~= nil and ( questIES_auto.Progress_NextNPC == 'SUCCESS' or questIES_auto.Progress_NextNPC == 'ENDNPC') then
    	        return "questinfo_3_" ..modeicon;
    	    end
	    end

        return "questinfo_2_" .. modeicon;
	elseif state == 'POSSIBLE' then
		return "questinfo_1_" .. modeicon;
	end

	--return "questinfo_0";
	return "questinfo_1_MAIN";
end

function SCR_ISFIRSTJOBCHANGEQUEST(questIES)
    local ret = 'NO'
    for i = 1, 5 do
        if string.find(questIES['Script'..i], 'IS_SELECTED_JOB') ~= nil then
            ret = 'YES'
            break
        end
    end
    return ret
end

function MAKE_QUEST_INFO(GroupCtrl, questIES, msg, progVal) -- progVal이 nil이면 내 pc의 퀘스트임
	local ctrlname = "_Q_" .. questIES.ClassID;
	local pc = SCR_QUESTINFO_GET_PC();
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);

	-- 공유중인 퀘스트가 성공한 시점에는 퀘스트 세션 정보를 파티에 보내주자
	local myPartyInfo = GET_MY_PARTY_INFO_C()
	local sharedQuestID = TryGetProp(myPartyInfo, 'Shared_Quest')
	if sharedQuestID == questIES.ClassID and progVal == nil and result ~= TryGetProp(myPartyInfo, 'Shared_Progress') then		
		party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Progress", quest.GetQuestStateValue(result))
	end

	if progVal ~= nil then
		result = quest.GetQuestStateString(tonumber(progVal))
	end

	if result == "COMPLETE" or result == "IMPOSSIBLE" then
		GroupCtrl:RemoveChild(ctrlname);
		return nil;
	elseif  result == 'POSSIBLE' and SCR_POSSIBLE_UI_OPEN_CHECK(pc, questIES, nil, 'Set2') == "HIDE" then
		GroupCtrl:RemoveChild(ctrlname);
	    return nil;
	elseif result == 'POSSIBLE' and questIES.QuestStartMode ~= 'NPCDIALOG' then
		GroupCtrl:RemoveChild(ctrlname);
	    return nil;
	end

	if questIES.ClassName ~= 'None' and result == 'PROGRESS' then
		CHEAK_QUEST_MONSTER(questIES);
	end

	local child = GroupCtrl:GetChild(ctrlname);
	if child ~= nil then
		GroupCtrl:RemoveChild(ctrlname);
	end

	local ctrlset = GroupCtrl:CreateOrGetControlSet('emptyset2', ctrlname, 0, 0);

	tolua.cast(ctrlset, 'ui::CControlSet');
	ctrlset:SetValue2(questIES.ClassID);
	ctrlset:SetSValue(result);
	ctrlset:Resize(GroupCtrl:GetWidth(), ctrlset:GetHeight());
	--ctrlset:Resize(350, ctrlset:GetHeight());

	local titleWidth = ctrlset:GetWidth() - 10;
	local titleX = 0;
	titleX, titleWidth = ATTACH_QUEST_ITEM_INFO(ctrlset, questIES, result, titleWidth);

	local npcType = GET_MONGEN_NPCTYPE(questIES.StartMap, questIES.StartNPC);
	local npcCls = GetClass('Monster', npcType);
	if npcCls ~= nil and npcCls.HeadIcon ~= 'None' then
		local npcPic = ctrlset:CreateOrGetControl('picture', "npcPic", 0, 0, 64, 64);
		tolua.cast(npcPic, "ui::CPicture");
		npcPic:SetGravity(ui.RIGHT, ui.CENTER_VERT);
		npcPic:SetEnableStretch(1);
		npcPic:SetImage(npcCls.HeadIcon);
		npcPic:SetTooltipType('questtalk');
		npcPic:SetTooltipArg('questtalk', questIES.ClassID, "");
	end

	local picture = ctrlset:CreateOrGetControl('picture', "statepicture", titleX + 10, 0, 36, 36);
	tolua.cast(picture, "ui::CPicture");
	picture:EnableHitTest(0);
	
	picture:SetImage(GET_QUESTINFOSET_ICON_BY_STATE_MODE(result, questIES));
	picture:SetEnableStretch(1);

	local y = 7;

	local startx = titleX + 50;
    local content = ctrlset:CreateOrGetControl('richtext', 'groupQuest_title', startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
    local questName
    if questIES.QuestMode == 'REPEAT' then
        local sObj = GetSessionObject(pc, 'ssn_klapeda')
		if sObj ~= nil then
			if questIES.Repeat_Count ~= 0 then
				questName = questIES.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/{Auto_2})","Auto_1", sObj[questIES.QuestPropertyName..'_R'] + 1, "Auto_2",questIES.Repeat_Count)
			else
				questName = questIES.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/MuHan)","Auto_1", sObj[questIES.QuestPropertyName..'_R'])
			end
		end
	elseif questIES.QuestMode == 'PARTY' then
	    local sObj = GetSessionObject(pc, 'ssn_klapeda')
	    if sObj ~= nil then
	    	local curCnt = math.min(sObj.PARTY_Q_COUNT1 + 1, CON_PARTYQUEST_DAYMAX1);
	        questName = questIES.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/{Auto_2})","Auto_1", curCnt, "Auto_2",CON_PARTYQUEST_DAYMAX1);
	    end
	end
	if questName == nil then
	    questName = questIES.Name
	end
	content:SetTextFixWidth(1);
	content:SetText(QUEST_TITLE_FONT..questName);
	content:EnableHitTest(0);
	y = y + content:GetHeight();

	MAKE_QUEST_INFO_COMMON(pc, questIES, picture, result);

	if result == 'SUCCESS' then
		local s_obj = SCR_QUEST_GET_SOBJ(pc, questIES.Quest_SSN);
		if s_obj ~= nil then
    		ctrlset:SetValue(s_obj.ClassID);
    	end
		
		
		y = MAKE_QUESTINFO_MAP(ctrlset, questIES, titleX + 60, y, s_obj, result)
		
		y = MAKE_QUESTINFO_REWARD_LVUP(ctrlset, questIES, titleX + 60, y)
		
		if msg ~= 'GAME_START' and msg ~= nil then
			local isSucc = 1;
			for i, x in pairs(SUCCESS_QUEST_INFO) do
				if x == questIES.ClassID then
					isSucc = 0;
				end
			end
			if isSucc == 1 then
				SUCCESS_QUEST_INFO[table.getn(SUCCESS_QUEST_INFO) + 1] = questIES.ClassID;
				--imcSound.PlaySoundItem('quest_sucess_1');
			end
		end

	    local desc = questIES.EndDesc;
    	local txt = "{@st42b}";

		--[[
    	if desc == 'None' then
		
    	elseif string.len(desc) > 36 then
    		txt = string.sub(desc, 1, 33) .. " ...";
    	else
    		txt = desc;
    	end
		]]
		txt = desc;
		
		local startx = titleX + 60;
    	local content = ctrlset:CreateOrGetControl('richtext', 'PROGDESC', startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
    	content:SetTextFixWidth(1);
    	content:SetText('{s16}{ol}{#ffcc33}'..txt);
		content:EnableHitTest(0);
    	y = y + content:GetHeight();

        if SCR_QUESTINFOSETVIEW_CHECK(questIES.QuestInfosetView, 'SUCCESS') == 'YES' then
            y = MAKE_QUESTINFO_SUCCESS_STORY(ctrlset, questIES, titleX+60, y, s_obj, result);
        end

		-- 파티원이 공유 설정한 퀘스트 완료한 경우에는 지우지 않게 수정
		if progVal == nil then
			quest.RemoveAllQuestCheckItem(questIES.ClassID);
		end

		local height = math.max(64, y + 10);
		ctrlset:Resize(GroupCtrl:GetWidth(), height);
		return ctrlset;
	end

	local s_obj = SCR_QUEST_GET_SOBJ(pc, questIES.Quest_SSN);
	if s_obj ~= nil then
    	ctrlset:SetValue(s_obj.ClassID);
    end

	y = MAKE_QUESTINFO_BY_IES(ctrlset, questIES, titleX + 60, y, s_obj, result);
	if result == 'PROGRESS' then
    	y = ATTACH_TIME_CTRL(ctrlset, s_obj, y);
    end

	ctrlset:Resize(GroupCtrl:GetWidth(), y + 10);
	return ctrlset;
end

function MAKE_QUEST_INFO_C(gBox, questIES, msg, progVal)
	gBox:Resize(gBox:GetParent():GetWidth() - gBox:GetX(), gBox:GetOriginalHeight());
	if questIES.QuestGroup == "None" then
		return MAKE_QUEST_INFO(gBox, questIES, msg, progVal);
	else
		return MAKE_QUEST_GROUP_INFO(gBox, questIES, msg, progVal);
	end
end

function MAKE_QUEST_GROUP_INFO(gBox, questIES, msg, progVal)
	local translated_QuestGroup = dictionary.ReplaceDicIDInCompStr(questIES.QuestGroup); 

	local strFindStart, strFindEnd = string.find(translated_QuestGroup, "/");
	local questGroupName  = string.sub(translated_QuestGroup, 1, strFindStart-1);
	local ctrlname = "_Q_" .. questGroupName;
	gBox:RemoveChild(ctrlname);

	if msg == 'ABANDON_QUEST' then
		return;
	end

	local pc = SCR_QUESTINFO_GET_PC();
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);

	-- 공유중인 퀘스트 프로그레스 바뀌면 파티원에게도 업데이트 해줌
	local myPartyInfo = GET_MY_PARTY_INFO_C()
	local sharedQuestID = TryGetProp(myPartyInfo, 'Shared_Quest')
	if sharedQuestID == questIES.ClassID and progVal == nil and result ~= TryGetProp(myPartyInfo, 'Shared_Progress') then		
		party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Progress", quest.GetQuestStateValue(result))
	end
	
	if progVal ~= nil then
		result = quest.GetQuestStateString(tonumber(progVal))
	end

	if result == "COMPLETE" or result == "IMPOSSIBLE" then
		return nil;
	elseif  result == 'POSSIBLE' and SCR_POSSIBLE_UI_OPEN_CHECK(pc, questIES, nil, 'Set2') == "HIDE" then
	    return nil
	elseif result == 'POSSIBLE' and questIES.QuestStartMode ~= 'NPCDIALOG' then
	    return nil;
	end
	
	if questIES.ClassName ~= 'None' and result == 'PROGRESS' then
		CHEAK_QUEST_MONSTER(questIES);
	end

	local questRemi       = string.sub(translated_QuestGroup, strFindEnd+1);
	local titleFindStart, titleFindEnd = string.find(questRemi, "/");
	local questTitle	  = string.sub(questRemi, 1, titleFindStart-1);
	local questGroupIndex = tonumber(string.sub(questRemi, titleFindEnd+1, string.len(questRemi)));

	local ctrlset = gBox:CreateOrGetControlSet('emptyset2', ctrlname, 0, 0);
	tolua.cast(ctrlset, 'ui::CControlSet');
	ctrlset:SetValue2(questIES.ClassID);
	ctrlset:SetSValue(result);
	ctrlset:Resize(gBox:GetWidth() - gBox:GetX(), ctrlset:GetHeight());

	local titleWidth = ctrlset:GetWidth() - 10;
	local titleX = 0;
	titleX, titleWidth = ATTACH_QUEST_ITEM_INFO(ctrlset, questIES, result, titleWidth);

	local picture = ctrlset:CreateOrGetControl('picture', "statepicture", titleX + 10, 0, 36, 36);
	tolua.cast(picture, "ui::CPicture");
	picture:EnableHitTest(0);
    
	picture:SetImage(GET_QUESTINFOSET_ICON_BY_STATE_MODE(result, questIES));
	picture:SetEnableStretch(1);

	local y = 7;
	local startx = titleX + 50;
	local content = ctrlset:CreateOrGetControl('richtext', 'groupQuest_title', startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
	content:SetTextFixWidth(0);

    if questIES.QuestMode == 'REPEAT' then
        local sObj = GetSessionObject(pc, 'ssn_klapeda')
		if sObj ~= nil then
			if questIES.Repeat_Count ~= 0 then
				questTitle = questTitle..ScpArgMsg("Auto__-_BanBog({Auto_1}/{Auto_2})","Auto_1", sObj[questIES.QuestPropertyName..'_R'] + 1, "Auto_2",questIES.Repeat_Count)
			else
				questTitle = questTitle..ScpArgMsg("Auto__-_BanBog({Auto_1}/MuHan)","Auto_1", sObj[questIES.QuestPropertyName..'_R'])
			end
		end
	elseif questIES.QuestMode == 'PARTY' then
	    local sObj = GetSessionObject(pc, 'ssn_klapeda')
	    if sObj ~= nil then
	        questTitle = questTitle..ScpArgMsg("Auto__-_BanBog({Auto_1}/{Auto_2})","Auto_1", sObj.PARTY_Q_COUNT1 + 1, "Auto_2",CON_PARTYQUEST_DAYMAX1)
	    end
	end
	
	if questIES.QuestMode == 'MAIN' then
		content:SetText(QUEST_TITLE_FONT..'{#FFcc33}'..questTitle);
	else
		content:SetText(QUEST_TITLE_FONT..questTitle);
	end


	content:EnableHitTest(0);
	y = y + content:GetHeight();
	
	--[[ 2013년에 주석처리된 부분인데 혹시 몰라서 일단 안지움
	local btnsize = 24;
	local cbtn = ctrlset:CreateOrGetControl('button', "cancelbtn", picture:GetX() + 10, picture:GetHeight() + 25, btnsize, btnsize);
	tolua.cast(cbtn, "ui::CButton");
	cbtn:SetEventScript(ui.LBUTTONUP, "ABANDON_QUEST");
	cbtn:SetEventScriptArgNumber(ui.LBUTTONUP, questIES.ClassID);
	cbtn:SetImage(ABANDON_BTN_SKIN_NAME);
	]]--

    local s_obj = SCR_QUEST_GET_SOBJ(pc, questIES.Quest_SSN);

	local pc = SCR_QUESTINFO_GET_PC();
	MAKE_QUEST_INFO_COMMON(pc, questIES, picture, result);

	if result == 'SUCCESS' then

  		y = MAKE_QUESTINFO_MAP(ctrlset, questIES, titleX + 60, y, s_obj, result);
  		
  		y = MAKE_QUESTINFO_REWARD_LVUP(ctrlset, questIES, titleX + 60, y)
  		
		if s_obj ~= nil then
			ctrlset:SetValue(s_obj.ClassID);
		end

		if msg ~= 'GAME_START' and msg ~= nil then
			local isSucc = 1;
			for i, x in pairs(SUCCESS_QUEST_INFO) do
				if x == questIES.ClassID then
					isSucc = 0;
				end
			end
			if isSucc == 1 then
				SUCCESS_QUEST_INFO[table.getn(SUCCESS_QUEST_INFO) + 1] = questIES.ClassID;
				--imcSound.PlaySoundItem('quest_sucess_1');
			end
		end

		local State = CONVERT_STATE(result);
		local questDesc = {questIES.StartDesc, questIES.ProgDesc, questIES.EndDesc};
		local questCtrlName = {"StartDesc", "ProgDesc", "EndDesc"};
	    local questState = State.."Desc";
		for i=1, #questCtrlName do
			local isQuestView = true;

			if questDesc[i] == questDesc[i-1] and i ~= #questCtrlName then
				isQuestView = false;
			end

			if questCtrlName[i] == "ProgDesc" and questDesc[i] == questIES.EndDesc then
				isQuestView = false;
			end

			if i == 1 and beforeQuestCls ~= nil and beforeQuestCls.EndDesc == questIES.StartDesc then
				isQuestView = false;
			end

			if isQuestView == true then
				local desc = questIES[questCtrlName[i]];
				if desc ~= 'None' then --and g_isPartyMembetQuest == nil then -- 파티멤버퀘스트도 desc 보여주게 함. 왜 안보여주게 했을까? 기획의도인가?
					local startx = titleX + 60;
					local content = ctrlset:CreateOrGetControl('richtext', questCtrlName[i], startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
					tolua.cast(content, "ui::CRichText");
    				if questState == questCtrlName[i] then
    					content:EnableHitTest(0);
    					content:SetTextFixWidth(1);
    					content:SetText('{s16}{ol}{#ffcc33}'..desc);
    					y = y + content:GetHeight();
    					break;
--    				else
--    					content:EnableHitTest(0);
--    					content:SetTextFixWidth(1);
--    					content:SetText(QUEST_GROUP_TITLE_FONT.."{cl}"..desc);
--    					y = y + content:GetHeight();
    				end
    			end
			end
		end

		-- 파티원이 공유 설정한 퀘스트 완료시에는 지우지 않도록 수정
		if progVal == nil then
			quest.RemoveAllQuestCheckItem(questIES.ClassID);
		end

		if SCR_QUESTINFOSETVIEW_CHECK(questIES.QuestInfosetView, 'SUCCESS') == 'YES' then
            y = MAKE_QUESTINFO_SUCCESS_STORY(ctrlset, questIES, titleX+60, y, s_obj, result);
        end
		local height = math.max(64, y + 10);
		ctrlset:Resize(gBox:GetWidth(), height);
		return ctrlset;
	end


	local s_obj = SCR_QUEST_GET_SOBJ(pc, questIES.Quest_SSN);
	if s_obj ~= nil then
		ctrlset:SetValue(s_obj.ClassID);
	end

	y = MAKE_QUESTINFO_BY_IES(ctrlset, questIES, titleX + 60, y, s_obj, result);
	if result == 'PROGRESS' then
    	y = ATTACH_TIME_CTRL(ctrlset, s_obj, y);
    end

	ctrlset:Resize(gBox:GetWidth(), y + 10);
	return ctrlset;
end

function MAKE_QUEST_INFO_COMMON(pc, questIES, picture, result)
    local banQuestWarpZone = {'d_prison_62_1_event'}
    
	if table.find(banQuestWarpZone,GetZoneName(pc)) == 0 and GetLayer(pc) == 0 and ( (result == 'POSSIBLE' and questIES.POSSI_WARP == 'YES') or (result == 'PROGRESS' and questIES.PROG_WARP == 'YES') or (result == 'SUCCESS' and questIES.SUCC_WARP == 'YES')) then
        local questnpc_state = GET_QUEST_NPC_STATE(questIES, result);
        
        if questnpc_state ~= nil then
    		local mapProp = geMapTable.GetMapProp(questIES[questnpc_state..'Map']);
    		if mapProp ~= nil then
    			local npcProp = mapProp:GetNPCPropByDialog(questIES[questnpc_state..'NPC']);
    			if npcProp~= nil then
    				local genList = npcProp.GenList;
    				if genList ~= nil then
        				local genPos = genList:Element(0);
       
        				picture:SetImage("questinfo_return");
        				picture:SetEventScript(ui.LBUTTONUP, "QUESTION_QUEST_WARP");
						picture:SetUserValue("PC_FID", GET_QUESTINFO_PC_FID());
        				picture:SetEventScriptArgNumber(ui.LBUTTONUP, questIES.ClassID);
        				if result == 'POSSIBLE' or result == 'PROGRESS' then
        				    picture:SetTextTooltip(ClMsg("QuestWarp_PossiProg"));
            			else
            				picture:SetTextTooltip(ClMsg("QuestWarp"));
            			end
        				picture:EnableHitTest(1);
    					picture:SetAngleLoop(-3);
    					picture:SetUserValue("RETURN_QUEST_NAME", questIES.ClassName);
                    else
                        ErrorLog("Error : Quest ".. questIES.ClassID.." : "..questIES.ClassName.." : "..questnpc_state..'Map'.." : "..questnpc_state..'NPC'.." search data null")
                    end
    			end
    		end
        end
	end
end

function QUESTION_QUEST_WARP(frame, ctrl, argStr, questID)
    local pc = GetMyPCObject()
    local ZoneClassName = GetZoneName(pc) -- event V I V I D CICY --
	if ZoneClassName == 'VIVID_c_Klaipe' or ZoneClassName == 'VIVID_c_orsha' or ZoneClassName == 'VIVID_c_fedimian' then
        ui.SysMsg(ClMsg('ThisLocalUseNot'));
        return 0;
    end -- event V I V I D CICY --
    
    if session.colonywar.GetIsColonyWarMap() == true then
        ui.SysMsg(ClMsg('ThisLocalUseNot'));
        return 0;
    end

	if control.IsRestSit() == true then
		ui.SysMsg(ClMsg('DontQuestWarpForSit'));
		return;
	end

	if world.GetLayer() ~= 0 then
		return;
	end

	local cls = GetClassList('Map');
    local mapClassName = session.GetMapName();

	local obj = GetClassByNameFromList(cls, mapClassName);

	if obj.Type == "MISSION" then
		ui.SysMsg(ScpArgMsg("WarpQuestDisabled"));
        return;
    end


	local questIES = GetClassByType("QuestProgressCheck", questID);
	local pc = GetMyPCObject();
	if ctrl ~= nil then
		local fid = ctrl:GetUserValue("PC_FID");
		if fid ~= "None" then -- 파티원 공유 퀘스트 돌아가기 누른 경우
			local memberInfo = session.party.GetPartyMemberInfoByAID(PARTY_NORMAL, fid);
			if memberInfo ~= nil then
				local memberObj = GetIES(memberInfo:GetObject());
				g_questCheckFunc = SCR_QUEST_CHECK;
				local result = TryGetProp(memberObj, 'Shared_Progress');
				local progressStr = quest.GetQuestStateString(result);
				if progressStr == 'POSSIBLE' or progressStr == 'PROGRESS' or progressStr == 'SUCCESS' then					
					g_questCheckFunc = nil;
					local cheat = string.format("/reqpartyquest %s %d %s", fid, questID, memberInfo:GetName());
					movie.QuestWarp(session.GetMyHandle(), cheat, 0);
					packet.ClientDirect("QuestWarp");
					return;
				end			
			end
		end
	end

	local isMoveMap = 0;
    local mapClassName = session.GetMapName();
	local questIES = GetClassByType("QuestProgressCheck", questID);
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);
	local questnpc_state = GET_QUEST_NPC_STATE(questIES, result);

    if mapClassName ~= questIES[questnpc_state..'Map'] then
		isMoveMap = 1;
    end

	local cheat = string.format("/retquest %d", questID);
	local mapName , x, y, z = GET_QUEST_RET_POS(pc, questIES)
	if mapName ~= nil and 0 == isMoveMap then
		gePreload.PreloadArea(x, y, z);
	end

	movie.QuestWarp(session.GetMyHandle(), cheat, isMoveMap);
	packet.ClientDirect("QuestWarp");
end

function MAKE_COMPLETE_QUEST_GROUP_CTRL_CHILD(ctrlSet, questCls, beforeQuestCls, xPos, yPos, width, height, line_count, line_maxcount)
	local questDesc = {questCls.StartDesc, questCls.ProgDesc, questCls.EndDesc};
	local questCtrlName = {"StartDesc", "ProgDesc", "EndDesc"};
    
	local groupQuestCtrl = nil;
	for i=1, #questDesc do
	    if questDesc[i] ~= 'None' then
    		if questDesc[i] ~= questDesc[i-1] then
    			if i == 1 and beforeQuestCls ~= nil and beforeQuestCls.EndDesc == questDesc.StartDesc then

    			else
    			    if line_count <= line_maxcount then
        				groupQuestCtrl = ctrlSet:CreateOrGetControl("richtext", "groupQuest_"..questCls.ClassID..questCtrlName[i], xPos, yPos, width, height);
        				groupQuestCtrl:SetText(QUEST_GROUP_TITLE_FONT.."{cl}"..questDesc[i]);
        				yPos = yPos + groupQuestCtrl:GetHeight();
        			else
        			    line_count = line_count -1
        			end
    			end
    		end
    	end
	end

	return yPos, line_count;
end

function SCR_QUESTINFOSETVIEW_CHECK(target, state)
    if target == 'None' then
        return 'NO'
    end
    local list = SCR_STRING_CUT(target)
    if #list > 0 then
        for i = 1, #list do
            if list[i] == state then
                return 'YES'
            end
        end
    end
    
    return 'NO'
end

function MAKE_QUESTINFO_BY_IES(ctrlset, questIES, startx, y, s_obj, result, isQuestDetail)
    local questautoIES = GetClass('QuestProgressCheck_Auto', questIES.ClassName);
	if questautoIES == nil then
		ErrorLog('ERROR : questautoIES is nil :'.. questIES.ClassName)
		return y;
	end
    
    local flag = 'YES';
    if questautoIES.Track1 ~= None then
        local list = SCR_STRING_CUT(questautoIES.Track1);

        if list[1] == 'SProgress' then
            local pc = SCR_QUESTINFO_GET_PC();
			local sObj_main = SCR_QUEST_GET_SOBJ(pc, 'ssn_klapeda');
            if sObj_main[questIES.QuestPropertyName] < 10 then
                flag = 'NO';
            end
        end
    end
    
    y = MAKE_QUESTINFO_MAP(ctrlset, questIES, startx, y, s_obj, result);
    
    y = MAKE_QUESTINFO_REWARD_LVUP(ctrlset, questIES, startx, y)
    
    if result ~= 'POSSIBLE' and result ~= 'IMPOSSIBLE' and flag == 'YES' then
    	local starty = y;
    	y = MAKE_QUESTINFO_STEP_REWARD_BY_IES(ctrlset, questIES, startx, y, result);
    	y = MAKE_QUESTINFO_BASIC_BY_IES(ctrlset, questIES, startx, y, result);
    	y = MAKE_QUESTINFO_BUFF_BY_IES(ctrlset, questIES, startx, y);
    	y = MAKE_QUESTINFO_EQUIP_BY_IES(ctrlset, questIES, startx, y);
    	y = MAKE_QUESTINFO_ITEM_BY_IES(ctrlset, questIES, startx, s_obj, y);
    	y = MAKE_QUESTINFO_MONSTER_BY_IES(ctrlset, questIES, startx, y, s_obj);
    	y = MAKE_QUESTINFO_JOURNALMONSTER_BY_IES(ctrlset, questIES, startx, y, s_obj);
    	y = MAKE_QUESTINFO_OVERKILL_BY_IES(ctrlset, questIES, startx, y, s_obj);
    	y = MAKE_QUESTINFO_ETC_BY_IES(ctrlset, questIES, startx, y, s_obj, isQuestDetail);
    	y = MAKE_QUESTINFO_MAPFOGSEARCH_BY_IES(ctrlset, questIES, startx, y);
    	y = MAKE_QUESTINFO_HONORPOINT_BY_IES(ctrlset, questIES, startx, y);
    	y = MAKE_QUESTINFO_QUEST_BY_IES(ctrlset, questIES, startx, y);
        
    	if starty == y  then
    		y = MAKE_QUESTINFO_PROG_DESC(ctrlset, questIES, startx, y, s_obj, result);
    	end
    	
        if SCR_QUESTINFOSETVIEW_CHECK(questIES.QuestInfosetView, 'PROGRESS')  == 'YES'  and isQuestDetail ~= 1 then
            y = MAKE_QUESTINFO_PROG_STORY(ctrlset, questIES, startx, y, s_obj);
        end

    	return y;
    else
        local starty = y;
        y = MAKE_QUESTINFO_POSSIBLE_DESC(ctrlset, questIES, startx, y, s_obj, isQuestDetail, result);
        if result == 'POSSIBLE' and SCR_QUESTINFOSETVIEW_CHECK(questIES.QuestInfosetView, 'POSSIBLE') == 'YES' and isQuestDetail ~= 1  then 
            y = MAKE_QUESTINFO_POSSIBLE_STORY(ctrlset, questIES, startx, y, s_obj, result);
        elseif result == 'PROGRESS' and SCR_QUESTINFOSETVIEW_CHECK(questIES.QuestInfosetView, 'PROGRESS') == 'YES' and isQuestDetail ~= 1  then 
            y = MAKE_QUESTINFO_PROG_STORY(ctrlset, questIES, startx, y, s_obj, result);
        elseif result == 'SUCCESS' and SCR_QUESTINFOSETVIEW_CHECK(questIES.QuestInfosetView, 'SUCCESS') == 'YES' and isQuestDetail ~= 1  then 
            y = MAKE_QUESTINFO_SUCCESS_STORY(ctrlset, questIES, startx, y, s_obj, result);
        end
        
        return y;
    end

end
function MAKE_QUESTINFO_STEP_REWARD_BY_IES(ctrlset, questIES, startx, y, result)

	--local pc = SCR_QUESTINFO_GET_PC();
	--local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);
	local quest_auto = GetClass('QuestProgressCheck_Auto',questIES.ClassName)
	if TryGetProp(quest_auto , 'StepRewardList1') ~= nil and TryGetProp(quest_auto , 'StepRewardList1') ~= 'None' then
    	local pc = GetMyPCObject();
    	local maxRewardIndex
        for index = 1, 10 do
            local stepRewardList = TryGetProp(quest_auto , 'StepRewardList'..index)
            local stepRewardFuncList = TryGetProp(quest_auto, 'StepRewardFunc'..index)
            if stepRewardList ~= nil and stepRewardList ~= 'None' and stepRewardFuncList ~= nil and stepRewardFuncList ~= 'None' then
                stepRewardFuncList = SCR_STRING_CUT(stepRewardFuncList)
                local stepRewardFunc = _G[stepRewardFuncList[1]]
                if stepRewardFunc ~= nil then
                    local result = stepRewardFunc(pc, stepRewardFuncList)
                    if result == 'YES' then
                        maxRewardIndex = index
                    end
                end
            end
        end
        if maxRewardIndex ~= nil and maxRewardIndex > 0 then
    		local content = ctrlset:CreateOrGetControl('richtext', "Succ_StepReward", startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
    		content:EnableHitTest(0);
    		content:SetTextFixWidth(0);
    		content:SetText('{@st42b}'..ScpArgMsg('QUEST_STEPREWARD_MSG3','STEP',maxRewardIndex));
    		y = y + content:GetHeight();
        end
    end
	
	return y;
end

function MAKE_QUESTINFO_BASIC_BY_IES(ctrlset, questIES, startx, y, result)

	--local pc = SCR_QUESTINFO_GET_PC();
	--local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);
	local State = CONVERT_STATE(result);

	local txt = questIES[State .. 'Desc'];

	if txt == 'None' then
	    txt = ''
	end

	local Succ_Lv = questIES.Succ_Lv;
	if Succ_Lv ~= 0  then
		local content = ctrlset:CreateOrGetControl('richtext', "Succ_Lv", startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
		content:EnableHitTest(0);
		content:SetTextFixWidth(0);
		content:SetText('{s16}{ol}{#ffcc33}'..txt);
		y = y + content:GetHeight();
	end

	local Succ_Atkup = questIES.Succ_Atkup;
	if Succ_Atkup ~= 0  then
		local content = ctrlset:CreateOrGetControl('richtext', "Succ_Atkup", startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
		content:EnableHitTest(0);
		content:SetTextFixWidth(0);
		content:SetText('{s16}{ol}{#ffcc33}'..txt);
		y = y + content:GetHeight();
	end

	local Succ_Defup = questIES.Succ_Defup;
	if Succ_Defup ~= 0  then
		local content = ctrlset:CreateOrGetControl('richtext', "Succ_Defup", startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
		content:EnableHitTest(0);
		content:SetTextFixWidth(0);
		content:SetText('{s16}{ol}{#ffcc33}'..txt);
		y = y + content:GetHeight();
	end

	local Succ_Mhpup = questIES.Succ_Mhpup;
	if Succ_Mhpup ~= 0  then
		local content = ctrlset:CreateOrGetControl('richtext', "Succ_Mhpup", startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
		content:EnableHitTest(0);
		content:SetTextFixWidth(0);
		content:SetText('{s16}{ol}{#ffcc33}'..txt);
		y = y + content:GetHeight();
	end

	return y;
end

function MAKE_QUESTINFO_BUFF_BY_IES(ctrlset, questIES, startx, y)

	if questIES.Succ_Check_Buff == 0 then
		return y;
	end

	for i = 1 , QUEST_MAX_BUFF_CHECK do
		local buffName = questIES["Succ_BuffName" .. i];
		if buffName == "None" then
			break;
		end

		local buff = info.GetMyPcBuff(buffName);
		local txt = "";
		if buff ~= nil then
			txt = ScpArgMsg("Auto_{Auto_1}_BeoPeu(wanLyo)", "Auto_1", buffName);
		else
			txt = ScpArgMsg("Auto_{Auto_1}_BeoPeu", "Auto_1", buffName);
		end

		local content = ctrlset:CreateOrGetControl('richtext', "BUFF" .. i, startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
		content:EnableHitTest(0);
		content:SetTextFixWidth(0);
		content:SetText('{s16}{ol}{#ffcc33}'..txt);
		y = y + content:GetHeight();

	end

	return y;
end

function MAKE_QUESTINFO_EQUIP_BY_IES(ctrlset, questIES, startx, y)

	if questIES.Succ_Check_EqItem == 0 then
		return y;
	end

	for i = 1 , QUEST_MAX_EQUIP_CHECK do


		local itemname = questIES["Succ_EqItemName" .. i];
		if itemname == "None" then
			break;
		end

		local itemclass = GetClass("Item", itemname);
		if itemclass == nil then
			break;
		end

		local pc = SCR_QUESTINFO_GET_PC();
		local use_job = SCR_STRING_CUT_COMMA(itemclass.UseJob)
		local flag = 0
		local z

		for z = 1, #use_job do
		    if pc.JobName == use_job[z] then
		        flag = flag + 1
		    end
		end

		if flag ~= 0 then
    		local item = session.GetEquipItemByType(itemclass.ClassID);
    		if item == nil then
    			local itemtxt = ScpArgMsg("Auto_{Auto_1}_(JangChaganDoem)","Auto_1", itemclass.Name);
    			local content = ctrlset:CreateOrGetControl('richtext', "EQUIP" .. i, startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
				content:EnableHitTest(0);
    			content:SetTextFixWidth(0);
    			content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
    			y = y + content:GetHeight();

    		end
    	end
	end

	return y;
end

function MAKE_QUESTINFO_ITEM_BY_IES(ctrlset, questIES, startx, s_obj, y)
    local flag = false
    local pc
    local sObj_quest
    if questIES.Quest_SSN ~= 'None' then
	    pc = GetMyPCObject();
        sObj_quest = GetSessionObject(pc, questIES.Quest_SSN)
        if sObj_quest ~= nil and sObj_quest.SSNInvItem ~= 'None' then
            flag = true
        end
    end
	if questIES.Succ_Check_InvItem == 0 and flag == false then
		return y;
	end
	
	if questIES.Succ_Check_InvItem > 0 then
    	for i = 1 , QUEST_MAX_INVITEM_CHECK do
    		local InvItemName = questIES["Succ_InvItemName" .. i];
    		local itemclass = GetClass("Item", InvItemName);
    		if itemclass ~= nil then
        		local itemcount = SCR_QUEST_GET_INVITEM_COUNT(InvItemName);
        		
        		local needcnt = questIES["Succ_InvItemCount" .. i];
        		if itemcount < needcnt then
        			local itemtxt;
        			local invItemText = questIES["Succ_InvItemtext"..i];
        			invItemText = dictionary.ReplaceDicIDInCompStr(invItemText);
        			
        			if needcnt <= 1 then
        			    if invItemText ~= "None" and string.find(invItemText,"%%s") ~= nil then
        					itemtxt = string.format(invItemText, itemclass.Name);
        				elseif invItemText ~= "None" then
        				    itemtxt = invItemText
        				else
        					itemtxt = itemclass.Name
        				end
        			else
            			if invItemText ~= "None" and string.find(invItemText,"%%s") ~= nil then
            				itemtxt = string.format(invItemText.." (%d/%d)", itemclass.Name, itemcount, needcnt);
            			elseif invItemText ~= "None" then
            			    itemtxt = string.format(invItemText.." (%d/%d)", itemcount, needcnt);
            			else
            				itemtxt = string.format("%s (%d/%d)", itemclass.Name, itemcount, needcnt);
            			end
            		end
        
					monname = dictionary.ReplaceDicIDInCompStr(monname); -- dicToOriginal

        			if itemcount ~= 0 and itemcount ~= tonumber(ctrlset:GetParent():GetUserValue('QuestCntAlarmSound')) then
        				imcSound.PlaySoundEvent('quest_count');
        				ctrlset:GetParent():SetUserValue('QuestCntAlarmSound', itemcount);
        			end
					
        			local content = ctrlset:CreateOrGetControl('richtext', "ITEM_" .. i, startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
        			tolua.cast(content, "ui::CRichText");
        			content:EnableSplitBySpace(0);
        			content:EnableHitTest(0);
        			content:SetTextFixWidth(1);
        			content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
        			y = y + content:GetHeight();
        
        			local pictureCtrl = GET_CHILD(ctrlset, "statepicture", "ui::CPicture");
        			if pictureCtrl ~= nil then
        				pictureCtrl:SetPartitionImage("quest_count");
        				pictureCtrl:SetPartitionRate(itemcount / needcnt);
        				--pictureCtrl:Invalidate();
        			end
        		end
        	end
    	end
    end
	
	
	if questIES.Quest_SSN ~= 'None' then
	    pc = GetMyPCObject();
        sObj_quest = GetSessionObject(pc, questIES.Quest_SSN)
        if sObj_quest ~= nil and sObj_quest.SSNInvItem ~= 'None' then
            local itemList = SCR_STRING_CUT(sObj_quest.SSNInvItem, ':')
            local maxCount = math.floor(#itemList/3)
            for i = 1, maxCount do
        		local InvItemName = itemList[i*3 - 2]
        		local itemclass = GetClass("Item", InvItemName);
        		if itemclass ~= nil then
            		local itemcount = SCR_QUEST_GET_INVITEM_COUNT(InvItemName);
            		
            		local needcnt = itemList[i*3 - 1]
            		if itemcount < needcnt then
            			local itemtxt;
            			if needcnt <= 1 then
        					itemtxt = itemclass.Name
            			else
            				itemtxt = string.format("%s (%d/%d)", itemclass.Name, itemcount, needcnt);
                		end
                		
            			if itemcount ~= 0 and itemcount ~= tonumber(ctrlset:GetParent():GetUserValue('QuestCntAlarmSound')) then
            				imcSound.PlaySoundEvent('quest_count');
            				ctrlset:GetParent():SetUserValue('QuestCntAlarmSound', itemcount);
            			end
            
            			local content = ctrlset:CreateOrGetControl('richtext', "ITEM_" .. i, startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
            			tolua.cast(content, "ui::CRichText");
            			content:EnableSplitBySpace(0);
            			content:EnableHitTest(0);
            			content:SetTextFixWidth(1);
            			content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
            			y = y + content:GetHeight();
            
            			local pictureCtrl = GET_CHILD(ctrlset, "statepicture", "ui::CPicture");
            			if pictureCtrl ~= nil then
            				pictureCtrl:SetPartitionImage("quest_count");
            				pictureCtrl:SetPartitionRate(itemcount / needcnt);
            				--pictureCtrl:Invalidate();
            			end
            		end
            	end
            end
        end
    end

	return y;
end

function MAKE_QUESTINFO_JOURNALMONSTER_BY_IES(ctrlset, questIES, startx, y, s_obj, ssninfo)
    local returnFlag1 = true
	local monUIIndex = 0
    
	if GetPropType(questIES, 'Succ_Check_JournalMonKillCount') ~= nil and questIES.Succ_Check_JournalMonKillCount > 0 then
		returnFlag1 = false
	end
    
    if returnFlag1 == true then
        return y
    end
    
    if returnFlag1 == false then
    	for i = 1 , QUEST_MAX_MON_CHECK do
    	    if GetPropType(questIES, "Succ_Journal_MonKillName" .. i) == nil or questIES["Succ_Journal_MonKillName" .. i] == 'None' or questIES["Succ_Journal_MonKillName" .. i] == '' then
    	        break
    	    end
    		local monname = GetClassString('Monster',questIES["Succ_Journal_MonKillName" .. i], 'Name');            
            local monCls = GetClass('Monster', questIES['Succ_Journal_MonKillName'..i]);
            local monID = TryGetProp(monCls, 'ClassID');
            local curcnt = 0
            if monID ~= nil and IsExistMonsterInAdevntureBook(pc, monID) == 'YES' then
                curcnt = GetMonKillCount(pc, monID);
            end
            
            if GetPropType(questIES, "Succ_Journal_MonKillCount" .. i) == nil or questIES["Succ_Journal_MonKillCount" .. i] > 0 then
                local needcnt = questIES["Succ_Journal_MonKillCount" .. i];
                if curcnt < needcnt then
                    local itemtxt
        			local monClassName = questIES["Succ_Journal_MonKillName" .. i]
        			local monbasicname = monname
        			itemtxt = ScpArgMsg("JOURNAL_SUCC_MONKILL")..string.format(monname.." (%d/%d)", curcnt, needcnt);
        			
        			if curcnt ~= 0 and curcnt ~= tonumber(ctrlset:GetParent():GetUserValue('KillCntAlarmSound')) then
        				imcSound.PlaySoundEvent('sys_alarm_mon_kill_count');
        				ctrlset:GetParent():SetUserValue('KillCntAlarmSound', curcnt);
        			end
                    
                    monUIIndex = i
        			local content = ctrlset:CreateOrGetControl('richtext', "JOURNAL_MON_" .. i, startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
        			content:EnableHitTest(0);
        			content:SetTextFixWidth(1);
        			content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
        			y = y + content:GetHeight();
        
        			local pictureCtrl = GET_CHILD(ctrlset, "statepicture", "ui::CPicture");
        			if pictureCtrl ~= nil then
        				pictureCtrl:SetPartitionImage("quest_count");
        				pictureCtrl:SetPartitionRate(curcnt / needcnt);
        				--pictureCtrl:Invalidate();
        			end
                end
            end
    	end
    end
	

	return y;
end 
function MAKE_QUESTINFO_MONSTER_BY_IES(ctrlset, questIES, startx, y, s_obj, ssninfo)
    local returnFlag1 = true
    local returnFlag2 = true
	local monUIIndex = 0
    
	if questIES.Succ_Check_MonKill > 0 then
		returnFlag1 = false
	end
	local pc = GetMyPCObject();
	local quest_sObj
	
	if pc ~= nil then
	    if questIES.Quest_SSN ~= 'None' then
    	    quest_sObj = GetSessionObject(pc, questIES.Quest_SSN);
    	    if quest_sObj ~= nil then
    	        if quest_sObj.SSNMonKill ~= 'None' then
    	            returnFlag2 = false
    	        end
    	    end
    	end
    end
    
    if returnFlag1 == true and returnFlag2 == true then
        return y
    end
    
    if returnFlag1 == false then
    
    	for i = 1 , QUEST_MAX_MON_CHECK do
    		local monname = questIES["Succ_MonKillNameKOR" .. i];
    		if monname == "None" then
    			break;
    		end
    
    		local curcnt = s_obj["KillMonster" .. i];
    
    		local needcnt = questIES["Succ_MonKillCount" .. i];
    		if curcnt < needcnt then
    			local itemtxt
    			local monClassName = questIES["Succ_MonKillName" .. i]
    			local monbasicname
    			monClassName = SCR_STRING_CUT(monClassName, '/')
    			if #monClassName > 0 then
    			    for x = 1, #monClassName do
    			        local monIES = GetClass("Monster", monClassName[x]);
                		if monIES ~= nil then
                			if monbasicname == nil then
        			            monbasicname = monIES.Name
        			        else
        			            monbasicname = monbasicname..', '..monIES.Name
        			        end
                		end
    			    end
    			end
    			
				monname = dictionary.ReplaceDicIDInCompStr(monname); -- dicToOriginal

    			if monname ~= "None" and string.find(monname,"%%s") ~= nil then
    				itemtxt = string.format(monname.." (%d/%d)", monbasicname, curcnt, needcnt);
    			elseif monname ~= "None" then
    			    itemtxt = string.format(monname.." (%d/%d)", curcnt, needcnt);
    			else
    				itemtxt = string.format("%s (%d/%d)", monbasicname, curcnt, needcnt);
    			end
    			
    
    			if curcnt ~= 0 and curcnt ~= tonumber(ctrlset:GetParent():GetUserValue('KillCntAlarmSound')) then
    				imcSound.PlaySoundEvent('sys_alarm_mon_kill_count');
    				ctrlset:GetParent():SetUserValue('KillCntAlarmSound', curcnt);
    			end
                
                monUIIndex = i
    			local content = ctrlset:CreateOrGetControl('richtext', "MON_" .. i, startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
    			content:EnableHitTest(0);
    			content:SetTextFixWidth(1);
    			content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
    			y = y + content:GetHeight();
    
    			local pictureCtrl = GET_CHILD(ctrlset, "statepicture", "ui::CPicture");
    			if pictureCtrl ~= nil then
    				pictureCtrl:SetPartitionImage("quest_count");
    				pictureCtrl:SetPartitionRate(curcnt / needcnt);
    				--pictureCtrl:Invalidate();
    			end
    		end
    	end
    end
	
	if returnFlag2 == false then
    	if pc ~= nil then
    	    if questIES.Quest_SSN ~= 'None' then
        	    if quest_sObj ~= nil then
        	        if quest_sObj.SSNMonKill ~= 'None' then
        	            local monInfo = SCR_STRING_CUT(quest_sObj.SSNMonKill, ":")
                        if #monInfo >= 3 and #monInfo % 3 == 0 and monInfo[1] ~= 'ZONEMONKILL' then
                            local ssnMonListCount = #monInfo / 3
                            local flag = 0
                            for i = 1, QUEST_MAX_MON_CHECK do
                                if ssnMonListCount >= i then
                                    local needCount = tonumber(monInfo[i*3 - 1])
                                    local nowCount = quest_sObj['KillMonster'..i]
                                    if nowCount < needCount then
                                        local monClassName = monInfo[i*3 - 2]
                                        local monKORName = GetClassString("Monster", monClassName, "Name")
                                        if monKORName ~= "None" then
                            			    itemtxt = string.format(ScpArgMsg("QUEST_KILL_MON_UI_MSG1","MONSTER", monKORName).." (%d/%d)", nowCount, needCount);
                            			    
                            			    local content = ctrlset:CreateOrGetControl('richtext', "MON_" .. (monUIIndex + i), startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
                                			content:EnableHitTest(0);
                                			content:SetTextFixWidth(1);
                                			content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
                                			y = y + content:GetHeight();
                            			end
                                    end
                                else
                                    break
                                end
                            end
                        elseif monInfo[1] == 'ZONEMONKILL'  then
                            for i = 1, QUEST_MAX_MON_CHECK do
                                if #monInfo - 1 >= i then
                                    local index = i + 1
                                    local zoneMonInfo = SCR_STRING_CUT(monInfo[index])
                                    local needCount = tonumber(zoneMonInfo[2])
                                    local nowCount = quest_sObj['KillMonster'..i]
                                    if nowCount < needCount then
                                        local zoneName = GetClassString("Map", zoneMonInfo[1], "Name")
                                        if zoneName ~= "None" then
                            			    itemtxt = string.format(ScpArgMsg("QUEST_KILL_MON_UI_MSG2","ZONE", zoneName).." (%d/%d)", nowCount, needCount);
                            			    
                            			    local content = ctrlset:CreateOrGetControl('richtext', "MON_" .. (monUIIndex + i), startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
                                			content:EnableHitTest(0);
                                			content:SetTextFixWidth(1);
                                			content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
                                			y = y + content:GetHeight();
                            			end
                                    end
                                else
                                    break
                                end
                            end
                        end
        	        end
        	    end
        	end
    	end
    end

	return y;
end

function MAKE_QUESTINFO_OVERKILL_BY_IES(ctrlset, questIES, startx, y, s_obj, ssninfo)

	if questIES.Succ_Check_OverKill == 0 then
		return y;
	end

	for i = 1 , QUEST_MAX_OVERKILL_CHECK do
		local monname = questIES["Succ_OverKillNameKOR" .. i];
		if monname == "None" then
			break;
		end

		local curcnt = s_obj["OverKill" .. i];

		local needcnt = questIES["Succ_OverKillCount" .. i];
		if curcnt < needcnt then
			local itemtxt
			local monClassName = questIES["Succ_OverKillName" .. i]
			local monbasicname
			monClassName = SCR_STRING_CUT(monClassName, '/')
			if #monClassName > 0 then
			    for x = 1, #monClassName do
			        local monIES = GetClass("Monster", monClassName[x]);
            		if monIES ~= nil then
            			if monbasicname == nil then
    			            monbasicname = monIES.Name
    			        else
    			            monbasicname = monbasicname..', '..monIES.Name
    			        end
            		end
			    end
			end
			
			if monname ~= "None" and string.find(monname,"%%s") ~= nil then
				itemtxt = string.format(monname.." (%d/%d)", monbasicname, curcnt, needcnt);
			elseif monname ~= "None" then
			    itemtxt = string.format(monname.." (%d/%d)", curcnt, needcnt);
			else
				itemtxt = string.format("%s (%d/%d)", monbasicname, curcnt, needcnt);
			end
			
			

			local content = ctrlset:CreateOrGetControl('richtext', "MON_" .. i, startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
			content:EnableHitTest(0);
			content:SetTextFixWidth(0);
			content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
			y = y + content:GetHeight();

			local pictureCtrl = GET_CHILD(ctrlset, "statepicture", "ui::CPicture");
			if pictureCtrl ~= nil then
				pictureCtrl:SetPartitionImage("quest_count");
				pictureCtrl:SetPartitionRate(curcnt / needcnt);
				--pictureCtrl:Invalidate();
			end

		end
	end

	return y;
end

function MAKE_QUESTINFO_ETC_BY_IES(ctrlset, questIES, startx, y, s_obj, isQuestDetail)

	if s_obj == nil then
		return y;
	end

	for i = 1, QUEST_MAX_ETC_CNT do
		local questname  = s_obj["QuestInfoName" .. i];
		if questname == "None" then
			break;
		end

		local textWidth = ctrlset:GetWidth() - startx - 15;

		local curcnt = s_obj["QuestInfoValue" .. i];
		local needcnt = s_obj["QuestInfoMaxCount" .. i];
        if s_obj.QuestName == 'CATHEDRAL_BOSSENTER' then
            if curcnt < needcnt then
    			local itemtxt
    			itemtxt = string.format("%s (%d/%d)", questname, curcnt, needcnt);
--    			if needcnt <= 1 then
--        			itemtxt = questname
--        		else
--        		    itemtxt = string.format("%s (%d/%d)", questname, curcnt, needcnt);
--        		end
    			local content = ctrlset:CreateOrGetControl('richtext', "ETC_" .. i, startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
				content:EnableHitTest(0);
    			content:SetTextFixWidth(0);


				if isQuestDetail == 1 then
--					content:SetText('{S16}{#FFFFFF}'..itemtxt);
				else
					content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
				end

    			y = y + content:GetHeight();

				local pictureCtrl = GET_CHILD(ctrlset, "statepicture", "ui::CPicture");
				if pictureCtrl ~= nil then
					pictureCtrl:SetPartitionImage("quest_count");
					pictureCtrl:SetPartitionRate(curcnt / needcnt);
					--pictureCtrl:Invalidate();
				end

    		else
    		    local itemtxt = string.format("%s : %s", questname, string.char(curcnt));
    			local content = ctrlset:CreateOrGetControl('richtext', "ETC_" .. i, startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
				content:EnableHitTest(0);
    			content:SetTextFixWidth(0);


				if isQuestDetail == 1 then
--					content:SetText('{S16}{#FFFFFF}'..itemtxt);
				else
					content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
				end

    			y = y + content:GetHeight();
    		end
		elseif curcnt < needcnt then
			local itemtxt
			itemtxt = string.format("%s (%d/%d)", questname, curcnt, needcnt);
--			if needcnt <= 1 or s_obj["QuestInfoViewType" .. i] ~= 'None' then
--    			itemtxt = questname
--    		else
--				itemtxt = string.format("%s (%d/%d)", questname, curcnt, needcnt);
--			end
			local content = ctrlset:CreateOrGetControl('richtext', "ETC_" .. i, startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
			content:EnableHitTest(0);
			content:SetTextFixWidth(1);

			content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
			
			y = y + content:GetHeight();
			
			local pictureCtrl = GET_CHILD(ctrlset, "statepicture", "ui::CPicture");
			if pictureCtrl ~= nil then
				pictureCtrl:SetPartitionImage("quest_count");
				pictureCtrl:SetPartitionRate(curcnt / needcnt);
			end

			if s_obj["QuestInfoViewType" .. i] ~= 'None' then
				y = MAKE_QUESTINFO_COUNT_GAUGE(s_obj, ctrlset, i, startx, y);
			end
		elseif curcnt >= needcnt then
--			local itemtxt
--			if needcnt <= 1 then
--    			itemtxt = questname
--    		else
--    		    itemtxt = string.format("%s (%d/%d)", questname, curcnt, needcnt);
--    		end
--			local content = ctrlset:CreateOrGetControl('richtext', "ETC_" .. i, startx, y, textWidth , 10);
--			content:EnableHitTest(0);
--			content:SetTextFixWidth(0);
--			content:SetText('{cl}{s16}{ol}{#ffcc33}'..itemtxt);
--
--			y = y + content:GetHeight();
		end
	end

	return y;
end

function MAKE_QUESTINFO_COUNT_GAUGE(sObj, ctrlset, i, startx, y)

	local gauge = ctrlset:CreateOrGetControl('gauge', 'gauge_'..i, startx, y, 200, 40);
	tolua.cast(gauge, 'ui::CGauge');

	local curcnt = sObj["QuestInfoValue" .. i];
	local needcnt = sObj["QuestInfoMaxCount" .. i];

	gauge:SetPoint(curcnt, needcnt);
	gauge:AddStat('%v/%m');
	gauge:SetStatFont(0, 'white_12_ol');
	gauge:SetStatOffset(0, -3, -2);
	gauge:SetStatAlign(0, 'center', 'center');
	y = y + gauge:GetHeight();
	return y;
end


function MAKE_QUESTINFO_MAPFOGSEARCH_BY_IES(ctrlset, questIES, startx, y)

	if questIES.Succ_MapFogSearch == 'None' then
		return y;
	end

    if string.find(questIES.Succ_MapFogSearch, '/') == nil then
        return y;
    end
    
    local mapList = SCR_STRING_CUT(questIES.Succ_MapFogSearch)
    local flag = true
    for x = 1, #mapList/2 do
        local map_classname = mapList[x*2 - 1]
        local percent = mapList[x*2]
        if map_classname ~= nil then
            local zoneIES = GetClass('Map',map_classname)
            if zoneIES ~= nil then
                local txt = "";
                local pc = SCR_QUESTINFO_GET_PC()
                local now_percent = GetMapFogSearchRate(pc, map_classname)
                if now_percent == nil then
                    now_percent = 0
                else
                    now_percent = math.floor(now_percent)
                end
                
                if now_percent < tonumber(percent) then
                    txt = ScpArgMsg("Auto_{@st42b}{Auto_1}_TamSaegLyul{nl}{Auto_2}%%/{Auto_3}%%","Auto_1",zoneIES.Name,"Auto_2",now_percent,"Auto_3",percent)
                else
                    txt = ScpArgMsg("Auto_{cl}{@st42b}{Auto_1}_TamSaegLyul_wanLyo","Auto_1",zoneIES.Name,"Auto_2",percent)
                end
                local content = ctrlset:CreateOrGetControl('richtext', "MAPFOGSEARCH"..x, startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
            	content:EnableHitTest(0);
            	content:SetTextFixWidth(0);
            	content:SetText('{s16}{ol}{#ffcc33}'..txt);
            	y = y + content:GetHeight();
            end
        end
    end
	return y;
end

function MAKE_QUESTINFO_HONORPOINT_BY_IES(ctrlset, questIES, startx, y)

	if questIES.Succ_HonorPoint == 'None' then
		return y;
	end

    if string.find(questIES.Succ_HonorPoint, '/') == nil then
        return y;
    end

    local honor_name, honor_point = string.match(questIES.Succ_HonorPoint,'(.+)[/](.+)')
	local now_honor_point = 0;
    honor_point = tonumber(honor_point)
    if honor_name ~= nil then
        local honorIES = GetClass('AchievePoint',honor_name)
        if honorIES ~= nil then
            local pc = SCR_QUESTINFO_GET_PC()
            now_honor_point = GetAchievePoint(pc, honor_name)
            if now_honor_point < honor_point then
                txt = string.format("%s %d/%d",honorIES.Name,now_honor_point,honor_point)
            else
                txt = ScpArgMsg("Auto_{cl}{@st42b}{Auto_1}_{Auto_2}_wanLyo","Auto_1",honorIES.Name,now_honor_point,"Auto_2",honor_point)
            end
        end
    end

    local content = ctrlset:CreateOrGetControl('richtext', "HONORPOINT", startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
	content:EnableHitTest(0);
	content:SetTextFixWidth(0);
	content:SetText('{s16}{ol}{#ffcc33}'..txt);
	content:SetValue(now_honor_point);
	y = y + content:GetHeight();

	return y;
end

function MAKE_QUESTINFO_QUEST_BY_IES(ctrlset, questIES, startx, y)

	if questIES.Succ_Check_QuestCount == 0 then
		return y;
	end
	local pc = SCR_QUESTINFO_GET_PC();
	
	local sObj_main = GetSessionObject(pc, 'ssn_klapeda');
    if sObj_main == nil then
        return y;
    end
    
    if questIES.Succ_Quest_Condition == 'AND' then
        local Succ_req_quest_check = 0;
        local i
        local flag = false
        local addIndex = 0
        local tempList = {}
        for i = 1, 10 do
            if questIES['Succ_QuestName'..i] ~= 'None' then
                local ret = SCR_QUEST_SUCC_CHECK_MODULE_QUEST_SUB(pc, questIES, sObj_main, i)
                if ret == 'NO' then
                    local t1, t2, t3 = SCR_QUEST_LINK_FIRST(pc,questIES['Succ_QuestName'..i])
                    for i2 = 1, #t2 do
                        if table.find(tempList, t2[i2]) == 0 then
                            local questCount, questTerms
                            for i3 = 1, #t3 do
                                if t2[i2] == t3[i3][1] then
                                    questCount = t3[i3][2]
                                    questTerms = t3[i3][3]
                                end
                            end
                            
                            if questIES['Succ_QuestName'..i] == t2[i2] then
                                questCount = questIES['Succ_QuestCount'..i]
                            end
                            
                            local msg
                            if questCount <= 0 then
                                msg = '{#ffff00}'..ScpArgMsg('Quest_POSSIBLE')..'{/}'
                            elseif questCount == 1 then
                                msg = '{#44ccff}'..ScpArgMsg('Quest_PROGRESS')..'{/}'
                            elseif questCount == 200 then
                                msg = '{#00ffff}'..ScpArgMsg('Quest_SUCCESS')..'{/}'
                            elseif questCount == 300 then
                                msg = '{#00ff00}'..ScpArgMsg('Quest_COMPLETE')..'{/}'
                            end
                            
                            local itemtxt = ''
                            if flag == false then
                                flag = true
                                itemtxt = ScpArgMsg('QUESTINFO_QUEST')
                            end
                            local succQuestIES = GetClass('QuestProgressCheck',t2[i2])
                            if succQuestIES ~= nil then
                    			itemtxt = itemtxt..msg..' '..succQuestIES.Name
                    		else
                    		    itemtxt = itemtxt..t2[i2]
                            end
                            
                            if itemtxt ~= nil then
                                tempList[#tempList + 1] = t2[i2]
                                addIndex = addIndex + 1
                    			local content = ctrlset:CreateOrGetControl('richtext', "QUESTCK" .. addIndex, startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
                				content:EnableHitTest(0);
                    			content:SetTextFixWidth(0);
                    			content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
                    			y = y + content:GetHeight();
                    		end
                    	end
                    end
                end
            end
        end
    elseif questIES.Succ_Quest_Condition == 'OR' then
        local i
        local flag = false
        local addIndex = 0
        local tempList = {}
        for i = 1, 10 do
            if questIES['Succ_QuestName'..i] ~= 'None' then
                local ret = SCR_QUEST_SUCC_CHECK_MODULE_QUEST_SUB(pc, questIES, sObj_main, i)
                if ret == 'NO' then
                    local t1, t2, t3 = SCR_QUEST_LINK_FIRST(pc,questIES['Succ_QuestName'..i])
                    for i2 = 1, #t2 do
                        if table.find(tempList, t2[i2]) == 0 then
                            local questCount, questTerms
                            for i3 = 1, #t3 do
                                if t2[i2] == t3[i3][1] then
                                    questCount = t3[i3][2]
                                    questTerms = t3[i3][3]
                                end
                            end
                            
                            if questIES['Succ_QuestName'..i] == t2[i2] then
                                questCount = questIES['Succ_QuestCount'..i]
                            end
                            
                            local msg
                            if questCount <= 0 then
                                msg = '{#ffff00}'..ScpArgMsg('Quest_POSSIBLE')..'{/}'
                            elseif questCount == 1 then
                                msg = '{#44ccff}'..ScpArgMsg('Quest_PROGRESS')..'{/}'
                            elseif questCount == 200 then
                                msg = '{#00ffff}'..ScpArgMsg('Quest_SUCCESS')..'{/}'
                            elseif questCount == 300 then
                                msg = '{#00ff00}'..ScpArgMsg('Quest_COMPLETE')..'{/}'
                            end
                            
                            local itemtxt = ''
                            if flag == false then
                                flag = true
                                itemtxt = ScpArgMsg('QUESTINFO_QUEST')
                            end
                            local succQuestIES = GetClass('QuestProgressCheck',t2[i2])
                            if succQuestIES ~= nil then
                    			itemtxt = itemtxt..msg..' '..succQuestIES.Name
                    		else
                    		    itemtxt = itemtxt..t2[i2]
                            end
                            
                            if itemtxt ~= nil then
                                tempList[#tempList + 1] = t2[i2]
                                addIndex = addIndex + 1
                    			local content = ctrlset:CreateOrGetControl('richtext', "QUESTCK" .. addIndex, startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
                				content:EnableHitTest(0);
                    			content:SetTextFixWidth(0);
                    			content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
                    			y = y + content:GetHeight();
                    		end
                    	end
                    end
                end
            end
        end
    end
    
	return y;
end

function MAKE_QUESTINFO_REWARD_LVUP(ctrlset, questIES, startx, y, font)
    local pc = SCR_QUESTINFO_GET_PC();
    local nextPCLvIES = GetClass('Xp', pc.Lv + 1)
    
    if nextPCLvIES == nil then
        return y
    end
    
    if GET_QUESTINFO_PC_FID() ~= 0 then
        return y
    end
    
    local quest_auto = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
    
    local repeat_reward_item = {}
    local repeat_reward_achieve = {}
    local repeat_reward_achieve_point = {}
    local repeat_reward_exp = 0;
    local repeat_reward_npc_point = 0
    local repeat_reward_select = false
    local repeat_reward_select_use = false
    
    repeat_reward_item, repeat_reward_achieve, repeat_reward_achieve_point, repeat_reward_exp, repeat_reward_npc_point, repeat_reward_select, repeat_reward_select_use = SCR_REPEAT_REWARD_CHECK(pc, questIES, quest_auto, sObj)
    
    local qRewardExp = 0
    
    if quest_auto.Success_Exp > 0 then
        qRewardExp = qRewardExp + quest_auto.Success_Exp
    end
    
    if repeat_reward_exp ~= nil or repeat_reward_exp > 0 then
        qRewardExp = qRewardExp + repeat_reward_exp
    end
    
    if quest_auto.Success_Lv_Exp > 0 and pc.Lv < PC_MAX_LEVEL then
        local xpIES = GetClass('Xp', pc.Lv)
        if xpIES ~= nil then
            local lvexpvalue =  math.floor(xpIES.QuestStandardExp * quest_auto.Success_Lv_Exp)
            if lvexpvalue ~= nil and lvexpvalue > 0 then
	            qRewardExp = qRewardExp + lvexpvalue
            end
        end
    end
    
    if font == nil then
        font = '{@st42b}'
    end
    
    if pc.Lv < PC_MAX_LEVEL and qRewardExp > 0 and session.GetMaxEXP() - session.GetEXP() - qRewardExp <= 0 then
        local content = ctrlset:CreateOrGetControl('richtext', 'QUESTINFOREWARDLVUP', startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
    	content:EnableHitTest(0);
    	content:SetTextFixWidth(0);
    	content:SetText(font..ScpArgMsg('QUESTINFOREWARDLVUP','Auto_1',pc.Lv + 1));
    	y = y + content:GetHeight()+5;
    end
    
	return y;
end
function MAKE_QUESTINFO_MAP(ctrlset, questIES, startx, y, s_obj, sharedProgress)
    local pc = SCR_QUESTINFO_GET_PC();
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);
	if sharedProgress ~= nil then -- 공유중인 퀘스트는 공유 퀘스트 상태로 보여줘야 함
		result = sharedProgress;
	end
	local State = CONVERT_STATE(result);
	
    local mapListUI = questIES[State .. 'MapListUI']
	local map = questIES[State .. 'Map'];
	local location = questIES[State .. 'Location'];
	local txt = "";
	local txtList = {}

    if mapListUI ~= '' and mapListUI ~= 'None' then
        local list = SCR_STRING_CUT(mapListUI)
        for i = 1, #list do
            local zoneName
            if GetClass('Map', list[i]) ~= nil then
                zoneName = GetClassString('Map', list[i], 'Name')
            end
            if zoneName == nil or zoneName == 'None' then
                if GetClass('Map_Area', list[i]) ~= nil then
                    local areaZone = GetClassString('Map_Area', list[i], 'ZoneClassName')
                    local areaName = GetClassString('Map_Area', list[i], 'Name')
                    
                    if areaName == nil or areaName == 'None' then
                        zoneName = list[i]
                    else
                        zoneName = GetClassString('Map', areaZone, 'Name')..'('..areaName..')'
                    end
                end
            end
            
            if zoneName == nil then
                zoneName = list[i]
            end
            
            if table.find(txtList, zoneName) == 0 then
                if txt == '' then
                    txt = zoneName
                else
                    txt = txt..'{nl}'..zoneName
                end
                txtList[#txtList + 1] = zoneName
            end
        end
    elseif map ~= '' and map ~= 'None' then
        local zoneName = GetClassString('Map', map, 'Name')
        if zoneName ~= nil and table.find(txtList, zoneName) == 0 then
            txt = zoneName
            txtList[#txtList + 1] = zoneName
        end
    end
    
    if questIES.Quest_SSN ~= 'None' then
        local sObj_quest = GetSessionObject(pc, questIES.Quest_SSN)
        if sObj_quest ~= nil and sObj_quest.SSNInvItem ~= 'None' then
            local itemList = SCR_STRING_CUT(sObj_quest.SSNInvItem, ':')
            local maxCount = math.floor(#itemList/3)
            for i = 1, maxCount do
                local zoneTemp = itemList[i*3]
                local zoneName = GetClassString('Map', zoneTemp, 'Name')
                if table.find(txtList, zoneName) == 0 then
                    if txt == '' then
                        txt = txt..zoneName
                        firstInpu = true
                    else
                        txt = txt..'{nl}'..zoneName
                    end
                    txtList[#txtList + 1] = zoneName
                end
            end
        end
        
        if sObj_quest ~= nil and sObj_quest.SSNMonKill ~= 'None' then
            local monList = SCR_STRING_CUT(sObj_quest.SSNMonKill, ':')
            if #monList >= 3 and #monList % 3 == 0 and monList[1] ~= 'ZONEMONKILL' then
                local maxCount = math.floor(#monList/3)
                for i = 1, maxCount do
                    local zoneTemp = monList[i*3]
                    local zoneName = GetClassString('Map', zoneTemp, 'Name')
                    if table.find(txtList, zoneName) == 0 then
                        if txt == '' then
                            txt = txt..zoneName
                            firstInpu = true
                        else
                            txt = txt..'{nl}'..zoneName
                        end
                        txtList[#txtList + 1] = zoneName
                    end
                end
            elseif monList[1] == 'ZONEMONKILL'  then
                for i = 1, QUEST_MAX_MON_CHECK do
                    if #monList - 1 >= i then
                        local index = i + 1
                        local zoneMonInfo = SCR_STRING_CUT(monList[index])
                        local zoneName = GetClassString("Map", zoneMonInfo[1], "Name")
                        if zoneName ~= "None" then
                            if table.find(txtList, zoneName) == 0 then
                                if txt == '' then
                                    txt = txt..zoneName
                                    firstInpu = true
                                else
                                    txt = txt..'{nl}'..zoneName
                                end
                                txtList[#txtList + 1] = zoneName
                            end
            			end
                    end
                end
            end
        end
        
        if result == 'PROGRESS' then
            local ssnIES = GetClass('SessionObject',questIES.Quest_SSN)
            if ssnIES ~= nil then
                for x = 1, 10 do
                    if ssnIES['QuestMapPointGroup'..x] ~= 'None' then
                        local strList = SCR_STRING_CUT(ssnIES['QuestMapPointGroup'..x],' ')
                        local i = 1
                        while i < #strList do
                            local mapTemp 
                            if tonumber(strList[i + 1]) ~= nil then
                                mapTemp = strList[i]
                                i = i + 5
                            else
                                if IS_WARPNPC(strList[i], strList[i + 1]) == 'NO' then
                                    mapTemp = strList[i]
                                end
                                i = i + 3
                            end
                            
                        
                            if mapTemp ~= nil then
                                if GetClass('Map', mapTemp) ~= nil then
                                    local zoneName = GetClassString('Map', mapTemp, 'Name')
                                    if table.find(txtList, zoneName) == 0 then
                                        if txt == '' then
                                            txt = zoneName
                                        else
                                            txt = txt..'{nl}'..zoneName
                                        end
                                        txtList[#txtList + 1] = zoneName
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if txt == '' and location ~= '' and location ~= 'None' then
        local strList = SCR_STRING_CUT(location,' ')
        local i = 1
        while i < #strList do
            local mapTemp 
            if tonumber(strList[i + 1]) ~= nil then
                mapTemp = strList[i]
                i = i + 5
            else
                if IS_WARPNPC(strList[i], strList[i + 1]) == 'NO' then
                    mapTemp = strList[i]
                end
                i = i + 3
            end
            
            if mapTemp ~= nil then
                if GetClass('Map', mapTemp) ~= nil then
                    local zoneName = GetClassString('Map', mapTemp, 'Name')
                    if table.find(txtList, zoneName) == 0 then
                        if txt == '' then
                            txt = zoneName
                        else
                            txt = txt..'{nl}'..zoneName
                        end
                        txtList[#txtList + 1] = zoneName
                    end
                end
            end
        end
    end

    if txt ~= '' then
        if string.find(txt, '{nl}') ~= nil then
            txt = ClMsg('QuestZoneBasicTxt')..'{nl}'..txt
        else
            txt = ClMsg('QuestZoneBasicTxt')..txt
        end
    end
--    if txt ~= '' then
--    	if string.len(txt) > 50 then
--    		txt = string.sub(txt, 1, 47) .. " ...";
--    	else
--    		txt = txt;
--    	end
--    end
	local content = ctrlset:CreateOrGetControl('richtext', 'QUESTINFOMAP', startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH , 10);
	content:EnableHitTest(0);
	content:SetTextFixWidth(1);
	content:SetText('{@st42b}'..txt);
	y = y + content:GetHeight()+5;
	return y;
end

function MAKE_QUESTINFO_PROG_DESC(ctrlset, questIES, startx, y, s_obj, sharedProgress)
	local pc = SCR_QUESTINFO_GET_PC();
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);
	if sharedProgress ~= nil then
		result = sharedProgress;
	end	
	local State = CONVERT_STATE(result);

	local desc = questIES[State .. 'Desc'];

	local txt = "";
	--[[
    if desc == 'None' then
	
	elseif string.len(desc) > 56 then
		txt = string.sub(desc, 1, 53) .. " ...";
	else
		txt = desc;
	end
	]]
	txt = desc;
	
	local content = ctrlset:CreateOrGetControl('richtext', 'PROGDESC', startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
	content:EnableHitTest(0);
	content:SetTextFixWidth(1);
	content:SetText('{s16}{ol}{#ffcc33}'..txt);
    
	y = y + content:GetHeight();
	return y;
end

function MAKE_QUESTINFO_POSSIBLE_STORY(ctrlset, questIES, startx, y, s_obj, sharedProg)
	local pc = SCR_QUESTINFO_GET_PC();
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);

	-- 공유 퀘스트인 경우에는 내 pc가 아니라 파티원 pc의 프로그레스를 참조해서 그려줘야 한다.
	if sharedProg ~= nil then
		result = sharedProg
	end

	local State = CONVERT_STATE(result);

	local story = questIES[State .. 'Story'];

	if story ~= 'None' then
    	local txt = story;
    	local content = ctrlset:CreateOrGetControl('richtext', 'STARTSTORY', startx, y, ctrlset:GetWidth()- startx - SCROLL_WIDTH, 10);
    	tolua.cast(content, "ui::CRichText");
    	content:EnableHitTest(0);
    	content:SetTextFixWidth(1);
	    content:SetText('{@st42b}'..txt);
	    
    	y = y + content:GetHeight();
    end

	return y;
end

function MAKE_QUESTINFO_PROG_STORY(ctrlset, questIES, startx, y, s_obj, sharedProg)
	local pc = SCR_QUESTINFO_GET_PC();
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);

	if sharedProg ~= nil then
		result = sharedProg
	end

	local State = CONVERT_STATE(result);

	local story = questIES[State .. 'Story'];

	if story ~= 'None' then
    	local txt = story;

    	local content = ctrlset:CreateOrGetControl('richtext', 'PROGSTORY', startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
    	tolua.cast(content, "ui::CRichText");
    	content:EnableHitTest(0);
    	content:SetTextFixWidth(1);
	    content:SetText('{@st42b}'..txt);
	    
    	y = y + content:GetHeight();
    end

	return y;
end

function MAKE_QUESTINFO_SUCCESS_STORY(ctrlset, questIES, startx, y, s_obj, sharedProg)
	local pc = SCR_QUESTINFO_GET_PC();
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);

	if sharedProg ~= nil then
		result = sharedProg
	end

	local State = CONVERT_STATE(result);

	local story = questIES[State .. 'Story'];

	if story ~= 'None' then
    	local txt = story;

    	local content = ctrlset:CreateOrGetControl('richtext', 'ENDSTORY', startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
    	tolua.cast(content, "ui::CRichText");
    	content:EnableHitTest(0);
    	content:SetTextFixWidth(1);
	    content:SetText('{@st42b}'..txt);
	    
    	y = y + content:GetHeight();
    end

	return y;
end

function MAKE_QUESTINFO_POSSIBLE_DESC(ctrlset, questIES, startx, y, s_obj, isQuestDetail, sharedRes)
	local pc = SCR_QUESTINFO_GET_PC();
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);

	-- override shared quest progress
	if sharedRes ~= nil then
		result = sharedRes
	end

	local State = CONVERT_STATE(result);
	local questDesc = {questIES.StartDesc, questIES.ProgDesc, questIES.EndDesc};
	local questCtrlName = {"StartDesc", "ProgDesc", "EndDesc"};

	local questState = State.."Desc";
	for i=1, #questCtrlName do
		local desc = questIES[questCtrlName[i]];
		if desc == 'None' then
		else
			local content = ctrlset:CreateOrGetControl('richtext', questCtrlName[i], startx, y, ctrlset:GetWidth() - startx - SCROLL_WIDTH, 10);
			tolua.cast(content, "ui::CRichText");
    		if questState == questCtrlName[i] then
    			content:EnableHitTest(0);
    			content:SetTextFixWidth(1);

				if isQuestDetail == 1 then
					content:SetText('{@st42b}'..desc);
				else
    				content:SetText('{s16}{ol}{#ffcc33}'..desc);
				end

    			y = y + content:GetHeight();
    			break;
--    		else
--    			content:EnableHitTest(0);
--    			content:SetTextFixWidth(1);
--    			content:SetText(QUEST_GROUP_TITLE_FONT.."{cl}"..desc);
--    			y = y + content:GetHeight();
    		end
    	end
	end

	return y;
end

function QUESTINFOSET_2_QUEST_ANGLE(frame, msg, argStr, argNum)
	local groupBox = GET_CHILD(frame, "member", "ui::CGroupBox");

	local myHandle = session.GetMyHandle()
	local mapprop = session.GetCurrentMapProp();
	local mapName = mapprop:GetClassName();

	local cnt = groupBox:GetChildCount();
	for  i = 0, cnt -1 do
		local childObj = groupBox:GetChildByIndex(i);
		local name = childObj:GetName();
		if string.find(name, "_Q_") ~= nil and string.find(name, "_Q_CUSTOM_") == nil then
			local posDistance = 1000000;
			local destX, destY, destZ;
			local questProperty = geQuestTable.GetPropByType(childObj:GetValue2());
			local result = childObj:GetSValue();
			local questIES = GetClassByType("QuestProgressCheck", childObj:GetValue2());
			if (result == 'POSSIBLE' and questIES.POSSI_WARP == 'YES') or (result == 'PROGRESS' and questIES.PROG_WARP == 'YES') or (result == 'SUCCESS' and questIES.SUCC_WARP == 'YES') then
			else
				local stateIndex = STATE_NUMBER(result);
				if stateIndex ~= -1 then
					local locationlist = questProperty:GetLocation(stateIndex);
					if locationlist ~= nil then
						local loccnt = locationlist:Count();
						for k = 0 , loccnt - 1 do
							local locinfo = locationlist:Element(k);
							if mapName == locinfo:GetMapName() then
								local WorldPos = locinfo.point;
								if WorldPos ~= nil then
									local dist = info.GetDestPosDistance(WorldPos.x, WorldPos.y, WorldPos.z, myHandle);
									if dist < posDistance then
										posDistance = dist;
										destX = WorldPos.x;
										destY = WorldPos.y
										destZ = WorldPos.z;
									end
								else
									local npcFuncName = locinfo:GetNpcName();
									if npcFuncName ~= "None" then
										local GenList = GET_MONGEN_NPCPOS(mapprop, npcFuncName);
										if GenList ~= nil and GenList:Count() >= 1 then
											WorldPos = GenList:Element(0);
											local dist = info.GetDestPosDistance(WorldPos.x, WorldPos.y, WorldPos.z, myHandle);
											if dist < posDistance then
												posDistance = dist;
												destX = WorldPos.x;
												destY = WorldPos.y
												destZ = WorldPos.z;
											end
										end
									end
								end
							end
						end
					else
						local sobjinfo = session.GetSessionObject(childObj:GetValue());
						if sobjinfo ~= nil then
							local obj = GetIES(sobjinfo:GetIESObject());
							local roundCount = 0;
							for k = 1, SESSION_MAX_MAP_POINT_GROUP do
								local mapPointGroupStr = obj["QuestMapPointGroup" .. k];
								local mapPointGroupView = obj["QuestMapPointView" .. k];
								if mapPointGroupStr ~= "None" and mapPointGroupView == 1 then
									local genName = "None";
									local genType = 0;
									local count = 0;
									local x, y, z, range = 0;
									for locationMapName in string.gfind(mapPointGroupStr, "%S+") do
										if count == 0 and locationMapName ~= mapName then
											count = 0;
											roundCount = roundCount + 1;
											break;
										elseif count == 0 and locationMapName == mapName then
											checkMapName = locationMapName;
										end

										if count == 1 then
											local GenList = GET_MONGEN_NPCPOS(mapprop, locationMapName);
											if GenList == nil then
												x = tonumber(locationMapName);
											else
												genType = 1;
												genName = locationMapName;
											end
										elseif count == 2 then
											if genType == 0 then
												y = tonumber(locationMapName);
											else
												range = tonumber(locationMapName);
												local GenList = GET_MONGEN_NPCPOS(mapprop, genName);
												local GenCnt = GenList:Count();
												for j = 0 , GenCnt - 1 do
													local WorldPos = GenList:Element(j);
													local dist = info.GetDestPosDistance(WorldPos.x, WorldPos.y, WorldPos.z, myHandle);
													if dist < posDistance then
														posDistance = dist;
														destX = WorldPos.x;
														destY = WorldPos.y
														destZ = WorldPos.z;
													end
													roundCount = roundCount+1;
												end
												genName = "None";
												genType = 0;
												count = 5;
											end
										elseif count == 3 then
											z = tonumber(locationMapName);
										elseif count == 4 then
											range = tonumber(locationMapName);
											roundCount = roundCount + 1;

											destX = x;
											destY = y;
											destZ = z;
										end

										if count < 4 then
											count = count + 1;
										else
											count = 0;
										end
									end
								end
							end
						end
					end
				end

				local angle = 0;
				if destX == nil then
					local State    = CONVERT_STATE(childObj:GetSValue());

					local questMapname  = questIES[State .. 'Map'];
					local npcname  = questIES[State .. 'NPC'];
					local monProp = GET_MONGEN_NPC_MONPROP(questMapname, npcname);
					if monProp ~= nil and npcname ~= "None" and questMapname == mapName then
						local GenList = monProp.GenList;
						local GenCnt = GenList:Count();
						for j = 0 , GenCnt - 1 do
							local WorldPos = GenList:Element(j);
							if WorldPos ~= nil then
								local dist = info.GetDestPosDistance(WorldPos.x, WorldPos.y, WorldPos.z, myHandle);
								if dist < posDistance then
									posDistance = dist;
									destX = WorldPos.x;
									destY = WorldPos.y
									destZ = WorldPos.z;
								end
							end
						end
					end
				end

				if destX ~= nil then
					angle = info.GetDestPosAngle(destX, destY, destZ, myHandle) - mapprop.RotateAngle;
				end
				local picture = GET_CHILD(childObj, "statepicture", "ui::CPicture");
				picture:SetAngle(angle);
			end
		end
	end

end

g_currentPartyMemberInfo = nil;

function SCR_GET_PARTY_MEMBER_ITEM(itemName)
	local prop = geItemTable.GetPropByName(itemName);
	return g_currentPartyMemberInfo:GetItemCount(prop.type);
end

function QUESTSET2_PARTY_MEMBER_UPDATE(frame)
	QUEST_PARTY_MEMBER_PROP_UPDATE(frame);
end

function QUEST_PARTY_MEMBER_PROP_UPDATE(frame)
	local groupCtrl = GET_CHILD(frame, "member", "ui::CGroupBox");
	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		groupCtrl:RemoveChild("QUEST_SHARE");
		QUESTINFOSET_2_AUTO_ALIGN(frame, groupCtrl);
		return;
	end

	local partyObj = GetIES(pcparty:GetObject());
	if partyObj.IsQuestShare == 0 then
		groupCtrl:RemoveChild("QUEST_SHARE");
		QUESTINFOSET_2_AUTO_ALIGN(frame, groupCtrl);
		return;
	end
	
	local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local myInfo = session.party.GetMyPartyObj(PARTY_NORMAL);
	local count = list:Count();

	local drawCount = 0;
	for i = 0 , count - 1 do
		local pcInfo = list:Element(i);
		if pcInfo ~= myInfo and pcInfo:GetMapID() > 0 then
			local memberObj = GetIES(pcInfo:GetObject());
			if memberObj.Shared_Quest > 0 then --or memberObj.Before_Quest > 0 then (beforeQuest 혼선만 줘서 삭제함)
				drawCount = drawCount + 1;
			end
		end
	end

	if drawCount == 0 then
		groupCtrl:RemoveChild("QUEST_SHARE");
	else
		groupCtrl:RemoveChild("QUEST_SHARE");
		local ctrlSet = groupCtrl:CreateOrGetControlSet("partyquestfolder", "QUEST_SHARE", ui.LEFT, ui.TOP, 0, 0, 0, 0);
		groupCtrl:MoveChildBefore(ctrlSet, 0);

		ctrlSet:SetTextByKey('value',drawCount)

		g_isPartyMembetQuest = true;
		g_questCheckFunc = SCR_QUEST_CHECK;
		g_getItemCountFunc = SCR_GET_PARTY_MEMBER_ITEM;
		local bg = ctrlSet:GetChild("bg");
		bg:RemoveAllChild();
		for i = 0 , count - 1 do
			local pcInfo = list:Element(i);
			if pcInfo ~= myInfo and pcInfo:GetMapID() > 0 then			
				local pcObj = GetIES(pcInfo:GetPCObj());
				local memberObj = GetIES(pcInfo:GetObject());
				g_questCheckPC = pcObj;
				g_questCheckPCInfo = pcInfo;
				g_currentPartyMemberInfo = pcInfo;

				local questID = memberObj.Shared_Quest;
				local beforeQuest = memberObj.Before_Quest;
				if questID > 0 then --or beforeQuest > 0 then (beforeQuest는 혼선만 줘서 삭제함)
					local ctrlTxt = bg:CreateOrGetControl("richtext", "_NAME_" .. pcInfo:GetAID() , 0, 0, bg:GetWidth(), 20);
					ctrlTxt:ShowWindow(1);
					ctrlTxt:SetText("{@sti9}" .. ScpArgMsg("QuestOf{Name}", "Name", pcInfo:GetName()));
				end

				if questID > 0 then
					local questIES = GetClassByType("QuestProgressCheck", questID);
					MAKE_QUEST_INFO_C(bg, questIES, nil, TryGetProp(memberObj, 'Shared_Progress'))
				end

				g_currentPartyMemberInfo = nil;
				g_questCheckPC = nil;
			end
		end

		g_isPartyMembetQuest = nil;
		g_questCheckFunc = nil;
		g_getItemCountFunc = nil;
		GBOX_AUTO_ALIGN(bg, 0, 3, 10, true);
		local curValue = config.GetXMLConfig("QuestShareFolded");
		if curValue == 0 then
			ctrlSet:Resize(ctrlSet:GetWidth(), bg:GetHeight() + bg:GetY());
		else
			ctrlSet:Resize(ctrlSet:GetWidth(), 30);
		end

	end
	
	QUESTINFOSET_2_AUTO_ALIGN(groupCtrl:GetTopParentFrame(), groupCtrl);	
	if drawCount > 0 then        
		frame:ShowWindow(UI_CHECK_NOT_PVP_MAP());
	end
end

function QUEST_PARTY_SOBJ_UPDATE(frame)
	QUEST_PARTY_MEMBER_PROP_UPDATE(frame);
end

function TOGGLE_PARTY_QUEST_FOLDER(parent, ctrl)

	local curValue = config.GetXMLConfig("QuestShareFolded");
	
	if curValue == 0 then
		curValue = 1;
	else
		curValue = 0;
	end

	config.ChangeXMLConfig("QuestShareFolded", curValue);
	local frame = parent:GetTopParentFrame();
	local groupCtrl = GET_CHILD(frame, "member", "ui::CGroupBox");
	local ctrlSet = groupCtrl:GetChild("QUEST_SHARE");
	if ctrlSet ~= nil then
		local bg = ctrlSet:GetChild("bg");	
		local curValue = config.GetXMLConfig("QuestShareFolded");
		if curValue == 0 then
			ctrlSet:Resize(ctrlSet:GetWidth(), bg:GetHeight() + bg:GetY());
		else
			ctrlSet:Resize(ctrlSet:GetWidth(), 30);
		end
		QUESTINFOSET_2_AUTO_ALIGN(groupCtrl:GetTopParentFrame(), groupCtrl);	
	end
	
end

