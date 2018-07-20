
function QUEST_ON_INIT(addon, frame)
	addon:RegisterMsg('GAME_START', 'UPDATE_ALLQUEST');
	addon:RegisterMsg('QUEST_UPDATE', 'UPDATE_ALLQUEST');
	addon:RegisterMsg('UPDATE_SKILLMAP', 'UPDATE_ALLQUEST');
	addon:RegisterMsg('GET_NEW_QUEST', 'NEW_QUEST_ADD');

	addon:RegisterMsg('AVANDON_QUEST', 'ON_AVANDON_QUEST_RESTART');
	addon:RegisterMsg('QUEST_DELETED', 'ON_QUEST_DELETED');
	addon:RegisterMsg('CUSTOM_QUEST_UPDATE', 'ON_CUSTOM_QUEST_UPDATE');
	addon:RegisterMsg('CUSTOM_QUEST_DELETE', 'ON_CUSTOM_QUEST_DELETE');
	addon:RegisterMsg('MYPC_PARTY_JOIN', 'QUEST_MYPC_PARTY_JOIN');
	addon:RegisterMsg("PARTY_PROPERTY_UPDATE", "QUEST_PARTY_PROPERTY_UPDATE");

	addon:RegisterMsg('PARTY_UPDATE', "ON_PARTY_UPDATE_SHARED_QUEST")
	
end

function UI_TOGGLE_QUEST()
	if app.IsBarrackMode() == true then
		return;
	end
	ui.ToggleFrame('quest')
end

function IS_ABOUT_JOB(questIES)
	if questIES.JobLvup ~= 'None' or questIES.JobLvdown ~= 'None' or tonumber(questIES.JobStep) ~= 0 then
		return true;
	end

	return false;
end


function ALIGN_QUEST_CTRLS(groupBox)
	ALIGN_CHILDS(groupBox, 0, 10, nil, "_Q_")
end

s_curtabIndex = 0;

function QUEST_FRAME_OPEN(frame)
	local groupbox			= frame:GetChild('questGbox');
	local questbox_tab 		= GET_CHILD(frame, 'questbox', "ui::CTabControl");

	s_curtabIndex = 0;
	questbox_tab:ChangeTab(s_curtabIndex);		
	local abandonbox = frame:GetChild("abandonbox");
	abandonbox:ShowWindow(0);
	groupbox:ShowWindow(1);

	UPDATE_ALLQUEST(frame);
end

function QUEST_FRAME_CLOSE(frame)
	local questDetailFrame = ui.GetFrame('questdetail');
	if questDetailFrame:IsVisible() == 1 then
		questDetailFrame:ShowWindow(0);
	end
end

function NEW_QUEST_ADD(frame, msg, argStr, argNum)

	local questIES = GetClassByType("QuestProgressCheck", argNum);
	local sobjIES = GET_MAIN_SOBJ();

	local ret = QUEST_ABANDON_RESTARTLIST_CHECK(questIES, sobjIES);
	if ret == 'NOTABANDON' then
		UPDATE_ALLQUEST(frame, nil, 1, argNum, 1);
	elseif ret == 'ABANDON/LIST' then
		UPDATE_ALLQUEST_ABANDONLIST(frame);
	end

	CHECK_PARTY_QUEST_ADD(frame, argNum)
end

function ON_AVANDON_QUEST_RESTART(frame, msg, argStr, argNum)

	UPDATE_ALLQUEST(frame, nil, 1, argNum, 0);
end

function ON_QUEST_DELETED(frame, msg, argStr, argNum)
	local ctrlName = "_Q_" .. argNum;
	local groupbox			= frame:GetChild('questGbox');
	groupbox:RemoveChild(ctrlName);

	ALIGN_QUEST_CTRLS(groupbox);

	local questinfoset2Frame = ui.GetFrame('questinfoset_2');
	QUESTINFOSET_2_REMOVE_QUEST(questinfoset2Frame, argNum);

	CHECK_PARTY_QUEST_DELETE(frame, argNum)
end

function COMPLETE_QUEST_CHECK(frame, obj, argStr, argNum)
	UPDATE_ALLQUEST(frame);
end

function QUEST_TAB_CHANGE(frame, argStr, argNum)
	local topFrame			= frame:GetTopParentFrame();
	local groupbox			= topFrame:GetChild('questGbox');
	local abandonbox = topFrame:GetChild('abandonbox');

	local questbox_tab 		= GET_CHILD(topFrame, 'questbox', "ui::CTabControl");
	s_curtabIndex	    = questbox_tab:GetSelectItemIndex();
	if s_curtabIndex == 0 then
    	-- UPDATE_ALLQUEST(topFrame);
		abandonbox:ShowWindow(0);
		groupbox:ShowWindow(1);
    elseif s_curtabIndex == 1 then
        UPDATE_ALLQUEST_ABANDONLIST(topFrame)
		abandonbox:ShowWindow(1);
		groupbox:ShowWindow(0);
    end
end

function SHOW_QUEST_BY_ID(frame, ctrl, argstr, clsid)
	local questframe = ui.GetFrame("quest");
	questframe:ShowWindow(1);
	ui.SetTopMostFrame(questframe);
end

function UPDATE_ALLQUEST_ABANDONLIST(frame)

	local pc = GetMyPCObject();
	local posY = 60;
	local questGbox = frame:GetChild('abandonbox');
	local sobjIES = GET_MAIN_SOBJ();

	-- Update All
	local clsList, cnt = GetClassList("QuestProgressCheck");
	for i = 0, cnt -1 do
		local questIES = GetClassByIndexFromList(clsList, i);

		if questIES.QuestPropertyName ~= 'None' then
			local ctrlName = "_Q_" .. questIES.ClassID;

			if QUEST_ABANDON_RESTARTLIST_CHECK(questIES, sobjIES) == 'ABANDON/LIST' then
    			local questAutoIES = GetClass('QuestProgressCheck_Auto',questIES.ClassName)
    			if questIES.ClassName ~= "None" then
    				local result = SCR_QUEST_CHECK_C(pc,questIES.ClassName);
    				posY = SET_QUEST_LIST_SET(frame, questGbox, posY, ctrlName, questIES, result, isNew, questID, 'ABANDON/LIST');
    			end
			else
				questGbox:RemoveChild(ctrlName);
    		end
		end
	end
	
	ALIGN_QUEST_CTRLS(questGbox);
	frame:Invalidate();
end

function UPDATE_ALLQUEST(frame, msg, isNew, questID, isNewQuest)
	local pc = GetMyPCObject();
	local mylevel = info.GetLevel(session.GetMyHandle());
	local posY = 60;

	local sobjIES = GET_MAIN_SOBJ();
	local questGbox = frame:GetChild('questGbox');

	local newCtrlAdded = false;
	if questID ~= nil and questID > 0 then
		local questIES = GetClassByType("QuestProgressCheck", questID);
		local result = SCR_QUEST_CHECK_C(pc, questIES.ClassName);
		local ctrlName = "_Q_" .. questIES.ClassID;


		-- ???? ????? ?????????? ???? ?????????? ui???? ???? ????.
		if isNewQuest == 0 and isNew == 1 then
			questGbox:RemoveChild(ctrlName);
		elseif QUEST_ABANDON_RESTARTLIST_CHECK(questIES, sobjIES) == 'NOTABANDON' then
			local newY = SET_QUEST_LIST_SET(frame, questGbox, posY, ctrlName, questIES, result, isNew, questID);
			if newY ~= posY then
				newCtrlAdded = true;
			end
			posY = newY;
		end

	else
		-- Update All
		local clsList, cnt = GetClassList("QuestProgressCheck");
		for i = 0, cnt -1 do
			local questIES = GetClassByIndexFromList(clsList, i);
			local questAutoIES = GetClass('QuestProgressCheck_Auto',questIES.ClassName)
            if questIES.QuestMode == 'MAIN' then
    			if questIES.ClassName ~= "None" then
    				local ctrlName = "_Q_" .. questIES.ClassID;
    				local abandonCheck = QUEST_ABANDON_RESTARTLIST_CHECK(questIES, sobjIES)
    				if abandonCheck == 'NOTABANDON' or abandonCheck == 'ABANDON/NOTLIST' then
    
    					local result = SCR_QUEST_CHECK_C(pc, questIES.ClassName);
    					if IS_ABOUT_JOB(questIES) == true then
    						if result ~= 'IMPOSSIBLE' and result ~= 'None' then
    							posY = SET_QUEST_LIST_SET(frame, questGbox, posY, ctrlName, questIES, result, isNew, questID);
    						end
    					else
    						posY = SET_QUEST_LIST_SET(frame, questGbox, posY, ctrlName, questIES, result, isNew, questID);
    					end
    				else
    					questGbox:RemoveChild(ctrlName);
    				end
    			end
    		end
		end
		
		
		local subQuestCount = 0
		for i = 0, cnt -1 do
			local questIES = GetClassByIndexFromList(clsList, i);
			local questAutoIES = GetClass('QuestProgressCheck_Auto',questIES.ClassName)
			
            if questIES.QuestMode ~= 'MAIN' then
    			if questIES.ClassName ~= "None" then
    				local ctrlName = "_Q_" .. questIES.ClassID;
    				local abandonCheck = QUEST_ABANDON_RESTARTLIST_CHECK(questIES, sobjIES)
    				if abandonCheck == 'NOTABANDON' or abandonCheck == 'ABANDON/NOTLIST' then
    					local result = SCR_QUEST_CHECK_C(pc, questIES.ClassName);
    					if IS_ABOUT_JOB(questIES) == true then
    						if result ~= 'IMPOSSIBLE' and result ~= 'None' then
    							posY, subQuestCount = SET_QUEST_LIST_SET(frame, questGbox, posY, ctrlName, questIES, result, isNew, questID, nil, subQuestCount);
    						end
    					else
    						posY, subQuestCount = SET_QUEST_LIST_SET(frame, questGbox, posY, ctrlName, questIES, result, isNew, questID, nil, subQuestCount);
    					end
    				else
    					questGbox:RemoveChild(ctrlName);
    				end
    			end
    		end
		end
	end

	ALIGN_QUEST_CTRLS(questGbox);
	if isNewQuest == nil then
		UPDATE_QUEST_DETAIL(frame, questID);
	elseif questID ~= nil and isNewQuest > 0 then
		local questIES = GetClassByType("QuestProgressCheck", questID);
		if newCtrlAdded == true then
			UPDATE_QUEST_DETAIL(frame, questID);
		end
	end

	frame:Invalidate();
end

function IS_WORLDMAPPREOPEN(zoneClassName)
    local mapCls = GetClass('Map', zoneClassName)
    if mapCls ~= nil and GetPropType(mapCls, 'WorldMapPreOpen') ~= nil and mapCls.WorldMapPreOpen == 'YES' then
        return 'YES'
    end
    return 'NO'
end

function QUEST_VIEWCHECK_LEVEL(pc, questIES)
--    if pc.Lv < 10 then
--       if questIES.Level <= pc.Lv + 10 then
--            return 'YES'
--        end
--    else
--        if questIES.Level <= pc.Lv + 10 and questIES.Level >= pc.Lv - 10 then
--            return 'YES'
--        end
--    end
--    
--    return 'NO'
end

function LINKZONECHECK(fromZone, toZone)
    local result = 'NO'

    if fromZone == toZone then
        result = 'YES'
        return result
    end

    if fromZone == nil or toZone == nil or fromZone == 'None' or toZone == 'None' then
        return result
    else
        local zoneIES1 = GetClass('Map', fromZone)
        local zoneIES2 = GetClass('Map', toZone)
        if zoneIES1 == nil or zoneIES2 == nil then
            return result
        end

        local linkList = SCR_STRING_CUT(zoneIES1.QuestLinkZone)
        if #linkList > 0 then
            for i = 1, #linkList do
                if linkList[i] == toZone then
                    result = 'YES'
                    return result
                end
            end
        end
    end

    return result
end

function HIDE_IN_QUEST_LIST(pc, questIES, abandonResult, subQuestCount)
	local startMode = questIES.QuestStartMode;
	local sObj = session.GetSessionObjectByName("ssn_klapeda");
	if sObj ~= nil then
    	sObj = GetIES(sObj:GetIESObject());
    end
    local result1
    result1, subQuestCount = SCR_POSSIBLE_UI_OPEN_CHECK(pc, questIES, subQuestCount)
    
	if abandonResult == 'ABANDON/LIST' or questIES.PossibleUI_Notify == 'UNCOND' then
	elseif result1 == "HIDE" then
	    return 1, subQuestCount
	elseif startMode == 'NPCENTER_HIDE' then
	    return 1, subQuestCount
	elseif startMode == "GETITEM" then
	    return 1, subQuestCount
	elseif startMode == "USEITEM" then
	    return 1, subQuestCount
	elseif IS_WORLDMAPPREOPEN(questIES.StartMap) == 'NO' then
	    return 1, subQuestCount
	elseif sObj ~= nil and questIES.QuestMode == 'MAIN' and pc.Lv < 100 and questIES.QStartZone ~= 'None' and sObj.QSTARTZONETYPE ~= 'None' and questIES.QStartZone ~=  sObj.QSTARTZONETYPE and LINKZONECHECK(GetZoneName(pc), questIES.StartMap) == 'NO'  then
	    return 1, subQuestCount
	elseif (questIES.QuestMode == 'MAIN' or questIES.QuestMode == 'REPEAT' or questIES.QuestMode == 'SUB') and LINKZONECHECK(GetZoneName(pc), questIES.StartMap) == 'NO' and QUEST_VIEWCHECK_LEVEL(pc, questIES) == 'NO' and SCR_ISFIRSTJOBCHANGEQUEST(questIES) == 'NO'  then
		return 1, subQuestCount
	end

	return 0, subQuestCount;
end

function SET_QUEST_LIST_SET(frame, questGbox, posY, ctrlName, questIES, result, isNew, questID, abandonResult, subQuestCount)

	questGbox:RemoveChild(ctrlName);
	if result == 'IMPOSSIBLE' or result == 'COMPLETE' then
		return posY, subQuestCount;
	elseif result == 'POSSIBLE' then
	    local pc = GetMyPCObject();
	    local result
	    
	    result1, subQuestCount = HIDE_IN_QUEST_LIST(pc, questIES, abandonResult, subQuestCount)
		if result1 == 1 then
			return posY, subQuestCount;
		end
	end

	local Quest_Ctrl = questGbox:CreateOrGetControlSet('quest_list', ctrlName, 20, posY);
	Quest_Ctrl = tolua.cast(Quest_Ctrl, "ui::CControlSet");
	Quest_Ctrl:SetUserValue("QUEST_CLASSID", questIES.ClassID);

	local state = CONVERT_STATE(result);
	local questname = questIES.Name
	local questname = questIES[state .. 'Desc'];
	if questIES.QuestMode == 'REPEAT' then
		local pc = GetMyPCObject();
		local now_count = GetSessionObject(pc, 'ssn_klapeda')
		if now_count ~= nil then
			if questIES.Repeat_Count ~= 0 then
				questname = questIES.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/{Auto_2})","Auto_1", now_count[questIES.QuestPropertyName..'_R'] + 1, "Auto_2",questIES.Repeat_Count)
			else
				questname = questIES.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/MuHan)","Auto_1", now_count[questIES.QuestPropertyName..'_R'])
			end
		end
	elseif questIES.QuestMode == 'PARTY' then
		local pc = GetMyPCObject();
	    local sObj = GetSessionObject(pc, 'ssn_klapeda')
		if sObj ~= nil then
			questname = questIES.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/{Auto_2})","Auto_1", sObj.PARTY_Q_COUNT1 + 1, "Auto_2",CON_PARTYQUEST_DAYMAX1)
		end
	end

	Q_CTRL_BASIC_SET(Quest_Ctrl, questIES.ClassID, isNew);
	Q_CTRL_TITLE_SET(Quest_Ctrl, questIES, questname, result);
	Quest_Ctrl:ShowWindow(1);


	Quest_Ctrl:EnableHitTest(1);
    Quest_Ctrl:SetTextTooltip(ScpArgMsg("ClickToViewDetailInfomation"))

	local avandonquest_tryBtn = Quest_Ctrl:GetChild('avandonquest_try');
	if s_curtabIndex == 0 then
		avandonquest_tryBtn:ShowWindow(0);
		
		local dialogReplay_Btn = Quest_Ctrl:GetChild('dialogReplay');
		
	    if result ~= 'PROGRESS' and result ~= 'SUCCESS' then
	        dialogReplay_Btn:ShowWindow(0)
	    else
	        local pc = GetMyPCObject();
	        local dialogFlag = SCR_QUEST_POSSIBLE_DIALOG_CHECK(pc, questIES.ClassName)
	        if dialogFlag ~= 'YES' then
	            dialogReplay_Btn:ShowWindow(0)
	        end
	    end
	    
	    local abandon_Btn = Quest_Ctrl:GetChild('abandon');
	    if (questIES.AbandonUI ~= 'YES') or (result ~= 'PROGRESS' and result ~= 'SUCCESS') then
            abandon_Btn:ShowWindow(0)
        end
	else
	    local dialogReplay_Btn = Quest_Ctrl:GetChild('dialogReplay');
	    dialogReplay_Btn:ShowWindow(0)
	    local abandon_Btn = Quest_Ctrl:GetChild('abandon');
	    abandon_Btn:ShowWindow(0)
	    
		avandonquest_tryBtn:ShowWindow(1);
		local checkBox = Quest_Ctrl:GetChild("save");
		tolua.cast(checkBox, "ui::CCheckBox");
		checkBox:SetCheck(0);
		checkBox:ShowWindow(0);
	end


	if questIES.QuestMode == 'MAIN' then
		Quest_Ctrl:SetSkinName('test_mainquest_skin');
	elseif questIES.QuestMode == 'SUB' then
		Quest_Ctrl:SetSkinName('test_subquest_skin');
	elseif questIES.PeriodInitialization ~= "None" then -- 일일 퀘스트
		Quest_Ctrl:SetSkinName('test_dayquest_skin');
	elseif questIES.QuestMode == 'REPEAT' then
		Quest_Ctrl:SetSkinName('test_repeatquest_skin');
	elseif questIES.QuestMode == 'PARTY' then
		Quest_Ctrl:SetSkinName('test_partyquest_skin');
	elseif questIES.QuestMode == 'KEYITEM' then
		Quest_Ctrl:SetSkinName('test_keyque_skin');
	end

	QUEST_CTRL_UPDATE_PARTYINFO(Quest_Ctrl, questIES);
	
	return Quest_Ctrl:GetHeight() + posY + 5, subQuestCount;
end

function ADD_QUEST_DETAIL(frame, ctrl, argStr, questClassID, notUpdateRightUI)
	tolua.cast(ctrl, "ui::CCheckBox");
	if ctrl:IsChecked() == 1 then
		quest.AddCheckQuest(questClassID);
		if quest.GetCheckQuestCount() > 5 then
			ctrl:SetCheck(0);
			quest.RemoveCheckQuest(questClassID);
			return;
		end
	else
		quest.RemoveCheckQuest(questClassID);
	end

	if notUpdateRightUI ~= true then
		local questframe2 = ui.GetFrame("questinfoset_2");
		UPDATE_QUESTINFOSET_2(questframe2);
	end
end

function UPDATE_QUEST_DETAIL(frame, questID)
    
	local questframe2 = ui.GetFrame("questinfoset_2");

	frame = frame:GetTopParentFrame();
	local groupbox			= frame:GetChild('questGbox');

	local updated = false;
	local i = 0;
	while 1 do	
		if i >= quest.GetCheckQuestCount() then
			break;
		end

		local questID = quest.GetCheckQuest(i);
		if questID == -1 then
			local qctrl = frame:GetChild("gquest");
			if qctrl == nil then
				quest.RemoveCheckQuestByIndex(i);
			else
				local checkBox = qctrl:GetChild("save");
				tolua.cast(checkBox, "ui::CCheckBox");
				checkBox:SetCheck(1);
				i = i + 1;
			end
		else
			local ctrlname = "_Q_" .. questID;
			local questexist = 1;
			local Quest_Ctrl = nil;
			local qctrl = groupbox:GetChild(ctrlname);

			if qctrl ~= nil then
				Quest_Ctrl = qctrl;
			end

			if Quest_Ctrl ~= nil then
				tolua.cast(Quest_Ctrl, "ui::CControlSet");
				if Quest_Ctrl:IsEnable() == 0 then
					questexist = 0;
				end
			else
				questexist = 0;
			end

			if questexist == 1 then
				local checkBox = GET_CHILD(Quest_Ctrl, "save", "ui::CCheckBox");
				checkBox:SetCheck(1);

				UPDATE_QUESTINFOSET_2(questframe2, nil, 1, questID);
				i = i + 1;
			else
				quest.RemoveCheckQuestByIndex(i);
			end
		end
	end
end

function ABANDON_QUEST(frame, ctrl, argStr, argNum)

	local questDetailFrame = ui.GetFrame('questdetail');

	if questDetailFrame:IsVisible() == 1 then
		questDetailFrame:ShowWindow(0);
	end
	local curquest = session.GetUserConfig("CUR_QUEST", 0);

	if curquest  == -1 then
		local msg = ScpArgMsg("Auto_{s22}JeongMalLo_uiLoeLeul_PoKiHaSiKessSeupNiKka?");
		local StrScript = string.format("EXEC_ABANDON_QUEST(%d)", -1);
		ui.MsgBox(msg, StrScript, "None");
		return;
	end

	local questIES = GetClassByType('QuestProgressCheck', curquest);
	if questIES == nil then
		return;
	end

	local pc = GetMyPCObject();
	local result = SCR_QUEST_CHECK_C(pc, questIES.ClassName);

	if CAN_ABANDON_STATE(result) == 0 then
		ui.MsgBox(ScpArgMsg("Auto_{s22}JinHaengJungin_KweSeuTeuKa_aNipNiDa."));
		return;
	end

--	if questIES.QuestStartMode == 'BEFOREQUEST' then
--	    ui.MsgBox(ScpArgMsg("Auto_JaDong_SiJag_KweSeuTeu_PoKi_BulKa"));
--        return;
--	end

	local msg
	if questIES.StartNPC == 'None' then
    	msg = ScpArgMsg("Auto_{nl}_{nl}{s18}{ol}{#ffffcc}JeongMalLo_{@st43}[{Auto_1}]{/}{s18}{ol}{#ffffcc}_KweSeuTeuLeul_PoKiHaSiKessSeupNiKka?{nl}HaeDang_KweSeuTeuNeun_PoKi_Hu_JaeSiJagi_BulKaNeung_HapNiDa.","Auto_1", questIES.Name);
    else
        msg = ScpArgMsg("Auto_{nl}_{nl}{s18}{ol}{#ffffcc}JeongMalLo_{@st43}[{Auto_1}]{/}{s18}{ol}{#ffffcc}_KweSeuTeuLeul_PoKiHaSiKessSeupNiKka?","Auto_1", questIES.Name);
    end
	local StrScript = string.format("EXEC_ABANDON_QUEST(%d)", questIES.ClassID);
	ui.MsgBox(msg, StrScript, "None");

end

function EXEC_ABANDON_QUEST(questID)

	local frame = ui.GetFrame('quest');
	local Quest_Ctrl = frame:GetChild("_Q_" .. questID);
	if Quest_Ctrl ~= nil then
		frame:RemoveChild("_Q_" .. questID);
	end

	pc.ReqExecuteTx("ABANDON_Q", questID);

	local questinfoset2Frame = ui.GetFrame('questinfoset_2');
	UPDATE_QUESTINFOSET_2(questinfoset2Frame, 'ABANDON_QUEST', 0, questID);

	quest.RemoveAllQuestMonsterList(questID);
	frame:ShowWindow(0);
end

function QUEST_INFO_S(frame, ctrl, argStr, argNum)

	local questIES = GetClassByType('QuestProgressCheck', argNum);
	local pc = GetMyPCObject();
	local result = SCR_QUEST_CHECK_C(pc, questIES.ClassName);
	local State = CONVERT_STATE(result);

	local mapname = questIES[State .. 'Map'];
	local npcname = questIES[State .. 'NPC'];

	SHOW_QUEST_NPC(mapname, npcname);

end

function QUEST_CLICK_INFO(frame, slot, argStr, argNum)

	if argNum == 0 then
		return;
	else
		local xPos = frame:GetWidth() -50;
		session.SetUserConfig("CUR_QUEST", argNum);
		QUESTDETAIL_INFO(argNum, xPos);
		return;
	end
end

function Q_CTRL_BASIC_SET(Quest_Ctrl, classID, isNew)
    Quest_Ctrl:SetEnableSelect(1);
    Quest_Ctrl:SetSelectGroupName('Q_GROUP');
    Quest_Ctrl:EnableToggle(1);
	Quest_Ctrl:SetUpdateTopParent(1);

	Quest_Ctrl:SetEventScript(ui.LBUTTONDOWN, "QUEST_CLICK_INFO");
	Quest_Ctrl:SetEventScriptArgNumber(ui.LBUTTONDOWN, classID);

	Quest_Ctrl:SetEventScript(ui.RBUTTONUP, "RUN_EDIT_QUEST_REWARD");
	Quest_Ctrl:SetEventScriptArgNumber(ui.RBUTTONUP, classID);

	local checkBox = GET_CHILD(Quest_Ctrl, "save", "ui::CCheckBox");
	checkBox:SetTextTooltip(ScpArgMsg("Auto_{@st59}CheKeu_HaMyeon_HwaMyeon_oLeunJjoge_KweSeuTeu_alLiMiKa_NaopNiDa{nl}KweSeuTeu_alLiMiNeun_ChoeDae_5KaeKkaJi_DeungLog_KaNeungHapNiDa{/}"))

	if isNew == 1 or quest.IsCheckQuest(classID) == true then

		local pc = GetMyPCObject();
		local questIES = GetClassByType("QuestProgressCheck", classID);
		local result = SCR_QUEST_CHECK_C(pc, questIES.ClassName);
		if result == "POSSIBLE" and SCR_ISFIRSTJOBCHANGEQUEST(questIES) == 'NO' and questIES.POSSI_WARP ~= 'YES' then
			
			--????? ????? ?????? ?????? ????????
			checkBox:SetCheck(1);
			ADD_QUEST_DETAIL(Quest_Ctrl:GetTopParentFrame(), checkBox, 'None', classID, true);	
		else
			quest.AddCheckQuest(classID);
			checkBox:SetCheck(1);
			ADD_QUEST_DETAIL(Quest_Ctrl:GetTopParentFrame(), checkBox, 'None', classID, true);
		end
	end

    checkBox:SetEventScript(ui.LBUTTONDOWN, "ADD_QUEST_DETAIL");
	checkBox:SetEventScriptArgNumber(ui.LBUTTONDOWN, classID);
end

function RUN_EDIT_QUEST_REWARD(frame, ctrl, str, questID)
    RUN_QUEST_EDIT_TOOL(questID)
--	EDIT_QUEST_REWARD(questID);
end


function Q_CTRL_TITLE_SET(Quest_Ctrl, questIES, questname, result)

	local translated_QuestGroup = dictionary.ReplaceDicIDInCompStr(questIES.QuestGroup); -- ????? ?????? ????? ???? ?????? ???? ???? ???? dicID?? ?? ???????? ?? ???????? ?????????
    local questTab = questIES.QuestMode;
	local questIconImgName = GET_ICON_BY_STATE_MODE(result, questIES);
	local mylevel = info.GetLevel(session.GetMyHandle());

	local questMarkPic = GET_CHILD(Quest_Ctrl, "questmark", "ui::CPicture");
	local questTabTxt = ClMsg(questTab)..' '..ClMsg("Quest")
    

	if result == 'POSSIBLE' then
        questMarkPic:EnableHitTest(1);
        questMarkPic:SetTextTooltip("{@st59}"..questTabTxt.." '"..questIES.Name..ScpArgMsg("Auto_'_SiJag_KaNeungHapNiDa{/}"))
    elseif result == 'PROGRESS' then
        questMarkPic:EnableHitTest(1);
        questMarkPic:SetTextTooltip("{@st59}"..questTabTxt.." '"..questIES.Name..ScpArgMsg("Auto_'_JinHaeng_JungipNiDa{/}"))
    elseif result == 'SUCCESS' then
        questMarkPic:EnableHitTest(1);
        questMarkPic:SetTextTooltip("{@st59}"..questTabTxt.." '"..questIES.Name..ScpArgMsg("Auto_'_BoSangeul_BateuSeyo{/}"))
    end

	--local show_Str;			-- ???? ??????? ????????? ??????? ??? ???o??
	if result == 'COMPLETE' then
		questMarkPic:ShowWindow(0);
		--show_Str = string.format("     %s%s%d%s{/} %s%s{/}", GET_LEVEL_COLOR(mylevel, questIES.Level),"{@st41}{#504030}",questIES.Level, ScpArgMsg("LEVEL"), "{@st41}{cl}{#403020}", ScpArgMsg(SCR_QUEST_TAB_CHECK(questIES.QuestMode))..ScpArgMsg("Quest").."{/}");
	else
		questMarkPic:ShowWindow(1);
		questMarkPic:SetImage(questIconImgName);
		--show_Str = string.format("%s%s%d%s{/}{/} %s%s{/}", GET_LEVEL_COLOR(mylevel, questIES.Level),"{@st41}",questIES.Level, ScpArgMsg("LEVEL"),"{@st41}", ScpArgMsg(SCR_QUEST_TAB_CHECK(questIES.QuestMode))..ScpArgMsg("Quest").."{/}");
	end

	local nametxt = GET_CHILD(Quest_Ctrl, "name", "ui::CRichText");
	--nametxt:SetText(show_Str);

	local y = nametxt:GetY() + nametxt:GetHeight() + 45;
	local titleWidth = 330;

--	y = nametxt:GetY() + nametxt:GetHeight() + 30;

	y = MAKE_QUESTINFO_MAP(Quest_Ctrl, questIES, 55, y, nil, nil)
    
	if translated_QuestGroup == "None" then
		nametxt:SetText(questIES.Name)		-- ???? ??????? ?????????

--		y = nametxt:GetY() + nametxt:GetHeight() + 10;
		local descTxt = Quest_Ctrl:CreateOrGetControl("richtext", "state", 55, y, titleWidth, 18);
		local desc = questIES[CONVERT_STATE(result) .. 'Desc'];
		tolua.cast(descTxt, "ui::CRichText");
		descTxt:SetFontName("brown_16_b");
		descTxt:SetTextFixWidth(1);
		descTxt:EnableResizeByText(1);
		descTxt:SetText(ScpArgMsg("QuestDescBasicTxt")..desc);

		y = y + descTxt:GetHeight() + 5;

	else
		Quest_Ctrl:RemoveChild("state");
		local strFindStart, strFindEnd = string.find(translated_QuestGroup, "/");
		local questGroupName  = string.sub(translated_QuestGroup, 1, strFindStart-1);
		local questRemi       = string.sub(translated_QuestGroup, strFindEnd+1);
		local titleFindStart, titleFindEnd = string.find(questRemi, "/");
		local questTitle	  = string.sub(questRemi, 1, titleFindStart-1);
		local questGroupIndex = tonumber(string.sub(questRemi, titleFindEnd+1, string.len(questRemi)));



		if questIES.QuestMode == 'MAIN' then
			nametxt:SetText(QUEST_TITLE_FONT..'{#FF6600}'..questTitle)		-- ???? ??????? ?????????
		else
			nametxt:SetText(QUEST_TITLE_FONT..questTitle)		-- ???? ??????? ?????????
		end

        local descTxt = Quest_Ctrl:CreateOrGetControl("richtext", "state", 55, y, titleWidth - 15, 18);
		local desc = questIES[CONVERT_STATE(result) .. 'Desc'];
		tolua.cast(descTxt, "ui::CRichText");
		descTxt:SetFontName("brown_16_b");
		descTxt:SetTextFixWidth(1);
		descTxt:EnableResizeByText(1);
		descTxt:SetText(ScpArgMsg("QuestDescBasicTxt")..desc);
		y = y + descTxt:GetHeight() + 5;

--
----		y = nametxt:GetY() + nametxt:GetHeight() + 10;
----		local content = Quest_Ctrl:CreateOrGetControl('richtext', 'groupQuest_title', 50, y, titleWidth, 10);
----		content:SetTextFixWidth(0);
----		content:SetText(QUEST_TITLE_FONT..questTitle);
----
----
----
----		content:EnableHitTest(0);
----		y = y + content:GetHeight();
--
--
--		local beforeQuestCls = nil;
--
--		local line_count = 0
--    	local line_maxcount = 1
--
--    	local beforeQuestCls_2 = nil
--		
--    	for i= 1, questGroupIndex-1 do
--		
--    		local groupQuestId 	 = geQuestTable.GetQuestIDByGroupIndex(questGroupName, i);
--    		local groupQuestCls  = GetClassByType("QuestProgressCheck", groupQuestId);
--    		local questDesc = {groupQuestCls.StartDesc, groupQuestCls.ProgDesc, groupQuestCls.EndDesc};
--        	local questCtrlName = {"StartDesc", "ProgDesc", "EndDesc"};
--
--        	for i=1, #questDesc do
--        	    if questDesc[i] ~= 'None' then
--            		if questDesc[i] ~= questDesc[i-1] then
--            			if i == 1 and beforeQuestCls_2 ~= nil and beforeQuestCls_2.EndDesc == questDesc.StartDesc then
--            			else
--            			    line_count = line_count + 1
--            			end
--            		end
--            	end
--        	end
--    		beforeQuestCls_2 = groupQuestCls;
--    	end
--
--    	for i= 1, questGroupIndex-1 do
--			local groupQuestId 	 = geQuestTable.GetQuestIDByGroupIndex(questGroupName, i);
--			local groupQuestCls  = GetClassByType("QuestProgressCheck", groupQuestId);
--			y, line_count = MAKE_COMPLETE_QUEST_GROUP_CTRL_CHILD(Quest_Ctrl, groupQuestCls, beforeQuestCls, 40, y + 5, titleWidth, 10, line_count, line_maxcount);
--			beforeQuestCls = groupQuestCls;
--		end
--
--		if result == 'SUCCESS' then
--			local State = CONVERT_STATE(result);
--			local questDesc = {questIES.StartDesc, questIES.ProgDesc, questIES.EndDesc};
--			local questCtrlName = {"StartDesc", "ProgDesc", "EndDesc"};
--			local questState = State.."Desc";
--			for i=1, #questCtrlName do
--				local isQuestView = true;
--
--				if questDesc[i] == questDesc[i-1] and i ~= #questCtrlName then
--					isQuestView = false;
--				end
--
--				if questCtrlName[i] == "ProgDesc" and questDesc[i] == questIES.EndDesc then
--					isQuestView = false;
--				end
--
--				if i == 1 and beforeQuestCls ~= nil and beforeQuestCls.EndDesc == questIES.StartDesc then
--					isQuestView = false;
--				end
--
--				if isQuestView == true then
--				    if desc ~= 'None' then
--    					local desc = questIES[questCtrlName[i]];
--    					if questState == questCtrlName[i] then
--    						local content = Quest_Ctrl:CreateOrGetControl('richtext', questCtrlName[i], 40, y + 5, titleWidth, 10);
--    						content:EnableHitTest(0);
--    						content:SetTextFixWidth(1);
--    						content:SetText(QUEST_TITLE_FONT..desc);
--    						y = y + content:GetHeight();
--    						break;
--    					else
--    						local content = Quest_Ctrl:CreateOrGetControl('richtext', questCtrlName[i], 40, y + 5, titleWidth, 10);
--    						content:EnableHitTest(0);
--    						content:SetTextFixWidth(1);
--    						content:SetText(QUEST_GROUP_TITLE_FONT.."{cl}"..desc);
--    						y = y + content:GetHeight();
--    					end
--    				end
--				end
--			end
--		else
--			local descTxt = Quest_Ctrl:CreateOrGetControl("richtext", "state", 40, y + 5, titleWidth, 18);
--			local desc = questIES[CONVERT_STATE(result) .. 'Desc'];
--			tolua.cast(descTxt, "ui::CRichText");
--			descTxt:SetFontName("white_16_ol");
--			descTxt:SetTextFixWidth(1);
--			descTxt:EnableResizeByText(1);
--			descTxt:SetText(ScpArgMsg("QuestDescBasicTxt")..desc);
--			y = y + descTxt:GetHeight();
--		end
	end

	Quest_Ctrl:Resize(Quest_Ctrl:GetWidth(), y + 20);
end

function QUESTTREE_CHOICE(questTabName)
	if questTabName == "MAIN" then
		return "mainctrl";
	elseif questTabName == "SUB" then
		return "subctrl";
	else
		return "guildctrl";
	end
end

function RUN_QUEST_EDIT_TOOL(questID)
	if 1 == session.IsGM() then
	    local quest_ClassName = GetClassString('QuestProgressCheck', questID, 'ClassName')
        local questdocument = io.open('..\\release\\questauto\\InGameEdit_Quest.txt','w')
        questdocument:write(quest_ClassName)
        io.close(questdocument)

        local path = debug.GetR1Path();
        path = path .. "questauto\\QuestAutoTool_v1.exe";

		debug.ShellExecute(path);
	end

end

function SCR_QUEST_DIALOG_REPLAY(ctrlSet, ctrl)
    local questClassID = ctrlSet:GetUserValue("QUEST_CLASSID");
    control.CustomCommand("QUEST_DIALOG_REPLAY_SERVER", questClassID);
end

function SCR_QUEST_ABANDON_SELECT(ctrlSet, ctrl)
    local questClassID = ctrlSet:GetUserValue("QUEST_CLASSID");
    local questIES = GetClassByType('QuestProgressCheck', questClassID)
    ui.MsgBox(ScpArgMsg("QUEST_ABANDON_SELECT_MSG","QUEST",questIES.Name), string.format("EXEC_ABANDON_QUEST(%d)", tonumber(questClassID)), "None");
end

function SCR_ABANDON_QUEST_TRY(ctrlSet, ctrl)

	-- ????????? ??? ?????u
	local questClassID = ctrlSet:GetUserValue("QUEST_CLASSID");
	pc.ReqExecuteTx("RESTART_Q", questClassID);
	ui.GetFrame('quest'):ShowWindow(0);
end

function QUEST_ABANDON_RESTARTLIST_CHECK(questIES, sObj_main)
    local result
	if sObj_main == nil then
		return nil;
	end
    local questAutoIES = GetClass('QuestProgressCheck_Auto',questIES.ClassName)
    if (sObj_main[questIES.ClassName] == QUEST_ABANDON_VALUE or sObj_main[questIES.ClassName] == QUEST_FAIL_VALUE or sObj_main[questIES.ClassName] == QUEST_SYSTEMCANCEL_VALUE) and questIES.QuestMode ~= 'KEYITEM'  then
        local trackInfo = SCR_STRING_CUT(questAutoIES.Track1)
        if trackInfo[1] == 'SPossible' or (trackInfo[1] == 'SProgress' and questAutoIES.Possible_NextNPC == 'PROGRESS') or (trackInfo[1] == 'SSuccess' and questAutoIES.Possible_NextNPC == 'SUCCESS') then
            --???? ???????? ???? ????????? ??????? ???
            result = 'ABANDON/NOTLIST'
        elseif questIES.ClassName == 'DROPITEM_COLLECTINGQUEST' or questIES.ClassName == 'DROPITEM_REQUEST1' then
            result = 'NOTABANDON'
        else
            result = 'ABANDON/LIST'
        end
    else
        result = 'NOTABANDON'
    end

    return result
end

function QUEST_CTRL_UPDATE_PARTYINFO(ctrlSet)

	local pcparty = session.party.GetPartyInfo();
	ctrlSet:RemoveChild("SHARE_PARTY");
	if pcparty == nil then
		return;
	end

	local partyObj = GetIES(pcparty:GetObject());
	if partyObj.IsQuestShare == 0 then
		return;
	end

	local myInfo = session.party.GetMyPartyObj(PARTY_NORMAL);
	local isSharedQuest = false;
		if myInfo ~= nil then
		local obj = GetIES(myInfo:GetObject());
		local clsID = ctrlSet:GetUserIValue("QUEST_CLASSID");
		local savedID = obj.Shared_Quest;
		if savedID == clsID then
			isSharedQuest = true;
		end
	end


	if isSharedQuest == true then
		local shareBtn = ctrlSet:CreateControl("picture", "SHARE_PARTY", 60, 60, ui.RIGHT, ui.TOP, 0, 5, 35, 0);
		shareBtn:ShowWindow(1);	
		shareBtn = tolua.cast(shareBtn, "ui::CPicture");
		shareBtn:SetImage("party_indi_icon");
		shareBtn:SetTextTooltip(ClMsg("ThisQuestIsSharedToParty"));
		shareBtn:SetEventScript(ui.LBUTTONUP, "CANCEL_SHARE_QUEST_WITH_PARTY");

	else

		local shareBtn = ctrlSet:CreateControl("button", "SHARE_PARTY", 18, 18, ui.RIGHT, ui.TOP, 0, 15, 45, 0);
		shareBtn:ShowWindow(1);	
		shareBtn = tolua.cast(shareBtn, "ui::CButton");
		shareBtn:SetImage("btn_partyshare");
		shareBtn:SetTextTooltip(ClMsg("ClickToSharedQuestWithParty"));
		shareBtn:SetEventScript(ui.LBUTTONUP, "SHARE_QUEST_WITH_PARTY");

	end
end

function CANCEL_SHARE_QUEST_WITH_PARTY(parent, ctrlSet)
	party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Quest", 0);
	party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Quest", -1);

	local gbox = parent:GetParent();
	gbox:RunUpdateScript("QUEST_GBOX_UPDATE_PARTY_PROP");
	local questframe = parent:GetTopParentFrame();
	UPDATE_ALLQUEST(questframe);
end

function SHARE_QUEST_WITH_PARTY(parent, ctrlSet)
	local clsID = parent:GetUserIValue("QUEST_CLASSID");
	party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Quest", clsID);
	REQUEST_SHARED_QUEST_PROGRESS(clsID)

	local gbox = parent:GetParent();
	gbox:RunUpdateScript("QUEST_GBOX_UPDATE_PARTY_PROP");	
	local questframe = parent:GetTopParentFrame();
	UPDATE_ALLQUEST(questframe);
end

function QUEST_PARTY_PROPERTY_UPDATE(frame)
	local questGbox = frame:GetChild('questGbox');
	QUEST_GBOX_UPDATE_PARTY_PROP(questGbox);

	local questinfoset2 = ui.GetFrame("questinfoset_2");
	QUEST_PARTY_MEMBER_PROP_UPDATE(questinfoset2);
end

function QUEST_GBOX_UPDATE_PARTY_PROP(gbox)
	local cnt = gbox:GetChildCount();
	for i = 0 , cnt - 1 do
		local child = gbox:GetChildByIndex(i);
		local clsID = child:GetUserIValue("QUEST_CLASSID");
		if clsID > 0 then
			QUEST_CTRL_UPDATE_PARTYINFO(child);
		end
	end

	return 0;
end

function CHECK_PARTY_QUEST_DELETE(frame, questID)

	local myInfo = session.party.GetMyPartyObj(PARTY_NORMAL);
	if myInfo == nil then
		return;
	end	
	
	local myObj = GetIES(myInfo:GetObject());
	if questID == myObj.Shared_Quest then
		party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Quest", questID);
		REQUEST_SHARED_QUEST_PROGRESS(questID)
	end

end

function QUEST_MYPC_PARTY_JOIN(frame)
	local myInfo = session.party.GetMyPartyObj(PARTY_NORMAL);
	if myInfo == nil then
		return;
	end	

	local questGbox = frame:GetChild('questGbox');
	if questGbox:GetChildCount() > 0 then
		for i = 0 , questGbox:GetChildCount() - 1 do
			local ctrlSet = questGbox:GetChildByIndex(i);
			local clsID = ctrlSet:GetUserIValue("QUEST_CLASSID");
			if clsID > 0 then
				party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Quest", clsID);
				REQUEST_SHARED_QUEST_PROGRESS(clsID)
				local questinfoset2 = ui.GetFrame("questinfoset_2");
				local questGbox = questinfoset2:GetChild('member');
				questGbox:RunUpdateScript("QUEST_GBOX_UPDATE_PARTY_PROP");
			end
		end
	end
	
end

function CHECK_PARTY_QUEST_ADD(frame, questID)

	local myInfo = session.party.GetMyPartyObj(PARTY_NORMAL);
	if myInfo == nil then
		return;
	end	

	local myObj = GetIES(myInfo:GetObject());	
	if myObj.Shared_Quest > 0 then

		local sObj = GetClassByType("QuestProgressCheck", myObj.Shared_Quest)
		local pc = GetMyPCObject();
		local ret = SCR_QUEST_CHECK_C(pc, sObj.ClassName);
		if ret == "SUCCESS" or ret == "COMPLETE" then
			
			local questnpc_state = GET_QUEST_NPC_STATE(sObj, ret);
			if questnpc_state == nil then
				questnpc_state = GET_QUEST_NPC_STATE(sObj, "SUCCESS");
			end

			if questnpc_state ~= nil then
				local mapName, x, y, z = GET_QUEST_RET_POS(pc, sObj, questnpc_state)
				if mapName ~= nil then
					local stateKey = StringToIntKey(questnpc_state);
					party.ReqChangeMemberProperty(PARTY_NORMAL, "Before_Quest", myObj.Shared_Quest);
					party.ReqChangeMemberProperty(PARTY_NORMAL, "Before_Quest_State", stateKey);				
				end
			end

			party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Quest", questID);
			REQUEST_SHARED_QUEST_PROGRESS(questID)
			local questinfoset2 = ui.GetFrame("questinfoset_2");
			local questGbox = questinfoset2:GetChild('member');
			questGbox:RunUpdateScript("QUEST_GBOX_UPDATE_PARTY_PROP");
		end
	else
		party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Quest", questID);
		REQUEST_SHARED_QUEST_PROGRESS(questID)
		local questinfoset2 = ui.GetFrame("questinfoset_2");
		local questGbox = questinfoset2:GetChild('member');
		questGbox:RunUpdateScript("QUEST_GBOX_UPDATE_PARTY_PROP");	
	end
end

function REQUEST_SHARED_QUEST_PROGRESS(questClsID)
	party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Progress", -1) -- 값을 초기화해야 바뀜

	local myInfo = session.party.GetMyPartyObj(PARTY_NORMAL);
	if nil == myInfo then
		return;
	end

	local myObj = GET_MY_PARTY_INFO_C()
	local sharedQuestID = TryGetProp(myObj, 'Shared_Quest')
	if nil == sharedQuestID or sharedQuestID == 0 then
		return;
	end

	local questIES = GetClassByType("QuestProgressCheck", questClsID)
	if questIES == nil then
		return;
	end

	local progStr = SCR_QUEST_CHECK_C(GetMyPCObject(), questIES.ClassName)
	local progValue = quest.GetQuestStateValue(progStr)
	party.ReqChangeMemberProperty(PARTY_NORMAL, "Shared_Progress", progValue)
	party.SendSharedQuestSession(questIES.ClassID, questIES.ClassName, myInfo:GetAID());
end

function ON_PARTY_UPDATE_SHARED_QUEST()
	local myInfo = session.party.GetMyPartyObj(PARTY_NORMAL);
	local myPartyMemObj = GET_MY_PARTY_INFO_C()
	local sharedQuestID = TryGetProp(myPartyMemObj, 'Shared_Quest')
	if myInfo ~= nil and sharedQuestID ~= nil and sharedQuestID > 0 then
		local questCls = GetClassByType('QuestProgressCheck', sharedQuestID)
		if questCls ~= nil then
			REQUEST_SHARED_QUEST_PROGRESS(sharedQuestID)
		end
	end
end

	