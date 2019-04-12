--- lib_uiscp.lua --

function OPEN_WINDOW(frame, arg)
	frame:ShowWindow(arg);
end

function GET_GENNPC_NAME(frame, monProp)
	local name = string.format( "_NPC_GEN_%d", monProp.GenType);
	return name;	
end

function INIT_MAP_PICTURE_UI(pic, mapName, hitTest)

	if hitTest == 1 then
		pic:EnableHitTest(hitTest);
	end

	pic:SetUserValue("MAP_NAME", mapName);
	pic:ShowWindow(1);
	pic:SetEventScript(ui.LBUTTONDOWN, "MAP_LBTN_DOWN");

end

function DISABLE_BUTTON_DOUBLECLICK_WITH_CHILD(framename,childname,buttonname)

	local frame = ui.GetFrame(framename)
	local child = GET_CHILD_RECURSIVELY(frame,childname)
	local btn = GET_CHILD_RECURSIVELY(child,buttonname)

	local strScp = string.format("ENABLE_BUTTON_DOUBLECLICK_WITH_CHILD(\"%s\",\"%s\", \"%s\")", framename, childname, buttonname);

	ReserveScript(strScp, 5);
	btn:SetEnable(0)
end

function ENABLE_BUTTON_DOUBLECLICK_WITH_CHILD(framename,childname,buttonname)

	local frame = ui.GetFrame(framename)
	local child = GET_CHILD_RECURSIVELY(frame,childname)
	local btn = GET_CHILD_RECURSIVELY(child,buttonname)
	btn:SetEnable(1)

end

function DISABLE_BUTTON_DOUBLECLICK(framename,buttonname, sec)
	local delay = 5;
	if sec ~= nil then
		delay = sec;
	end
	local frame = ui.GetFrame(framename)
	local btn = GET_CHILD_RECURSIVELY(frame,buttonname)

	local strScp = string.format("ENABLE_BUTTON_DOUBLECLICK(\"%s\", \"%s\")", framename, buttonname);

	ReserveScript(strScp, delay);
	btn:SetEnable(0)
end

function ENABLE_BUTTON_DOUBLECLICK(framename,buttonname)

	local frame = ui.GetFrame(framename)
	local btn = GET_CHILD_RECURSIVELY(frame,buttonname)
	btn:SetEnable(1)

end

function INIT_BUFF_UI(frame, buff_ui, updatescp)

	local slotcountSetPt		= frame:GetChild('buffcountslot');
	local slotSetPt				= frame:GetChild('buffslot');
	local deslotSetPt			= frame:GetChild('debuffslot');

	buff_ui["slotsets"][0]			= tolua.cast(slotcountSetPt, 'ui::CSlotSet');
	buff_ui["slotsets"][1]			= tolua.cast(slotSetPt, 'ui::CSlotSet');
	buff_ui["slotsets"][2]			= tolua.cast(deslotSetPt, 'ui::CSlotSet');

	for i = 0 , buff_ui["buff_group_cnt"] do
	buff_ui["slotcount"][i] = 0;
	buff_ui["slotlist"][i] = {};
	buff_ui["captionlist"][i] = {};
		while 1 do
			if buff_ui["slotsets"][i] == nil then
				break;
			end

			local slot = buff_ui["slotsets"][i]:GetSlotByIndex(buff_ui["slotcount"][i]);
			if slot == nil then
				break;
			end

			buff_ui["slotlist"][i][buff_ui["slotcount"][i]] = slot;
			slot:ShowWindow(0);
			local icon = CreateIcon(slot);
			icon:SetDrawCoolTimeText(0);


			local x = buff_ui["slotsets"][i]:GetX() + slot:GetX() + buff_ui["txt_x_offset"];
			local y = buff_ui["slotsets"][i]:GetY() + slot:GetY() + slot:GetHeight() + buff_ui["txt_y_offset"];

			local capt = frame:CreateOrGetControl('richtext', "_t_" .. i .. "_".. buff_ui["slotcount"][i], x, y, 50, 20);
			--capt:SetTextAlign("center", "top");
			capt:SetFontName("yellow_13");
			buff_ui["captionlist"][i][buff_ui["slotcount"][i]] = capt;

			buff_ui["slotcount"][i] = buff_ui["slotcount"][i] + 1;
		end

	end


	local timer = frame:GetChild("addontimer");
	tolua.cast(timer, "ui::CAddOnTimer");
	timer:SetUpdateScript(updatescp);
	timer:Start(0.45);

end

function IS_STATE_PRINT(state)

	if state == 'COMPLETE' or state == 'IMPOSSIBLE' then
		return 0;
	end

	return 1;

end

function GET_NPC_STATE(npcname, statelist, npclist, questIESList)
	if npcname == 'SKILLPOINTUP' then
		return -3;
	end

	if npcname == "None" then
		return -2;
	end

	local returnIDX = -2;
	local selectedQuestMode = 100;
	local stateToNumber = 100;

	local cnt = #npclist;
	for i = 1 , cnt do
		local name = npclist[i];
		local state = statelist[i];
		if name == npcname and IS_STATE_PRINT(state) == 1 then
			local questIES = questIESList[i];
			local questmode_icon = questIES.QuestMode;
			
			if state == "SUCCESS" then
			    if stateToNumber == 3 then
    			    if selectedQuestMode > QUESTMODE_TONUMBER(questmode_icon) then
    			        stateToNumber = STATE_TONUMBER(state)
    					returnIDX = i;
    					selectedQuestMode = QUESTMODE_TONUMBER(questmode_icon);
    				end
    			else
    			    stateToNumber = STATE_TONUMBER(state)
					returnIDX = i;
					selectedQuestMode = QUESTMODE_TONUMBER(questmode_icon);
    			end
		    elseif stateToNumber ~= 3 then
		        if stateToNumber > STATE_TONUMBER(state) then
		            stateToNumber = STATE_TONUMBER(state)
					returnIDX = i;
					selectedQuestMode = QUESTMODE_TONUMBER(questmode_icon);
		        elseif stateToNumber == STATE_TONUMBER(state) and selectedQuestMode > QUESTMODE_TONUMBER(questmode_icon) then
		            stateToNumber = STATE_TONUMBER(state)
					returnIDX = i;
					selectedQuestMode = QUESTMODE_TONUMBER(questmode_icon);
		        end
		    end
		end
	end
	
	return returnIDX;
end

function MAKE_MY_CURSOR_TOP(frame)
	local my = frame:GetChild('my');
	if my ~= nil and my:IsVisible() == 1 then
		my:MakeTopBetweenChild();
	end
end


function MAP_UPDATE_PARTY(frame, msg, arg, type, info)

	DESTROY_CHILD_BYNAME(frame, 'PM_');

	local mapprop = session.GetCurrentMapProp();
	local list = session.party.GetPartyMemberList();
	local count = list:Count();
	
	if count == 1 then
		return;
	end

	for i = 0 , count - 1 do
		local pcInfo = list:Element(i);
		CREATE_PM_PICTURE(frame, pcInfo, type, mapprop);
	end

end

function MAP_UPDATE_GUILD(frame, msg, arg, type, info)

	DESTROY_CHILD_BYNAME(frame, 'GM_');

	local mapprop = session.GetCurrentMapProp();
	local list = session.party.GetPartyMemberList(PARTY_GUILD);
	local count = list:Count();
	

	if count == 1 then
		return;
	end

	for i = 0 , count - 1 do
		local pcInfo = list:Element(i);
		CREATE_PM_PICTURE(frame, pcInfo, PARTY_GUILD, mapprop);
	end

end


function MAKE_TOP_QUEST_ICONS(frame)

	for i = 0 , frame:GetChildCount() - 1 do
		local child = frame:GetChildByIndex(i);
		local value = child:GetValue2();
		if value == 1 then
			child:MakeTopBetweenChild();
		end
	end

	for i = 0 , frame:GetChildCount() - 1 do
		local child = frame:GetChildByIndex(i);
		local value = child:GetValue2();
		if value == 2 then
			child:MakeTopBetweenChild();
		end
	end

end



function STATE_TONUMBER(state)
	if state == "POSSIBLE" then
		return 1;
	elseif state == "PROGRESS" then
		return 2;
	elseif state == "SUCCESS" then
		return 3;
	end

	return 0;
end

function QUESTMODE_TONUMBER(state)
	if state == "MAIN" then
		return 1;
	elseif state == "SUB" then
		return 2;
	elseif state == "REPEAT" then
		return 3;
	elseif state == "PARTY" then
		return 4;
	end

	return 0;
end



function SET_PICTURE_BUTTON(picture)
		picture:SetEnable(1);
		--picture:SetEnableStretch(1);
		picture:EnableChangeMouseCursor(1);
end

function GET_NPC_ICON(i, statelist, questIESlist)
	if i == -3 then
		return "minimap_goddess", "", 0, 0;
	end

	if i == -2 then
		return "minimap_0", "", 0, 0;
	end

	local state;
	local questmode_icon;
	local questID;
	local iconState;
	local questies

	if i ~= -1 then
		state = statelist[i];
		questies = questIESlist[i];
		questID = questies.ClassID;
		questmode_icon = questies.QuestMode;
		iconState = 2;
	end
	return GET_ICON_BY_STATE_MODE(state, questies), state, questID, iconState;
end

function SET_MAP_MONGEN_NPC_INFO(picture, mapprop, WorldPos, MonProp, mapNpcState, npclist, statelist, questIESlist)

	SET_PICTURE_BUTTON(picture);

	local cheat = string.format("//setpos %d %d %d", WorldPos.x, WorldPos.y, WorldPos.z);
	local scpstr = string.format( "ui.Chat(\"%s\")", cheat);
	picture:SetEventScript(ui.LBUTTONUP, scpstr, true);

	local idx = GET_NPC_STATE(MonProp:GetDialog(), statelist, npclist, questIESlist);
	local Icon, state, questclsid, iconState = GET_NPC_ICON(idx, statelist, questIESlist);
	local Icon_copy
	local Icon_basic
	local iconOverride = MonProp:GetMinimapIcon();
	
    if iconOverride ~= "None" then
		Icon_basic = iconOverride;
	else
	    Icon_basic = 'minimap_0'
	end
	
	Icon_copy = Icon_basic
	
	if Icon ~= nil and Icon ~= "None" then
    	Icon_copy = Icon
    end
	
	
	if questIESlist[idx] ~= nil then
	    if state == 'PROGRESS' and questIESlist[idx].StartNPC == questIESlist[idx].ProgNPC then
	        Icon_copy = Icon_basic
	    end
	else
	    Icon_copy = Icon_basic
	end
	

	local pc = GetMyPCObject();
	local mongenprop = tolua.cast(MonProp, "geMapTable::MAP_NPC_PROPERTY");
	local questclsIdStr = '';
	local cnt = #npclist;
	for i = 1 , cnt do
		local name = npclist[i];
		if  MonProp:IsHaveDialog(name) then
			local questIES = questIESlist[i];
			local result = SCR_QUEST_CHECK_C(pc, questIES.ClassName);
			if questclsIdStr == '' then
				questclsIdStr = result..'/'..tostring(questIES.ClassID);
			else
				questclsIdStr = questclsIdStr ..'/'.. result..'/'..tostring(questIES.ClassID);
			end
		end
	end
	
	SET_NPC_STATE_ICON(picture, Icon_copy, state, questclsid, WorldPos);
	picture:SetTooltipType('minimap');
	picture:SetTooltipArg(questclsIdStr, questclsid, "", MonProp);
	picture:ShowWindow(1);
	picture:SetValue2(iconState);

	SET_MONGEN_NPC_VISIBLE(picture, mapprop, mapNpcState, MonProp);

	return idx, Icon;

end

function SET_MONGEN_NPC_VISIBLE(picture, mapprop, mapNpcState, MonProp)
	if mapprop.NotUseHide == 1 then
		picture:ShowWindow(1);
	elseif mapNpcState == nil then
		picture:ShowWindow(0);
	else
		local dlg = MonProp:GetDialog();
		local hidnpcCls = GetClass("HideNPC", dlg);
		local hide = false;
		local pc = GetMyEtcObject();
		if hidnpcCls ~= nil then
			if 1 == pc["Hide_" .. hidnpcCls.ClassID] then
				hide = true;
			end
		end
        

		if hide == true then
			picture:ShowWindow(0);
		elseif MonProp.GenType == 0 then
			picture:ShowWindow(1);
		else
			local curState = mapNpcState:FindAndGet(MonProp.GenType);
			if curState > 0 and picture:GetUserIValue("IsHide") == 0 then
				picture:ShowWindow(1);
			else
				picture:ShowWindow(0);
			end
		end
	end
end




function SET_NPC_STATE_ICON(PictureC, iconName, state, questID, worldPos)
	PictureC:SetSValue(state);
	PictureC:SetValue(questID);
	PictureC:SetImage(iconName);
	PictureC:SetEnableStretch(1);
	--local xFix = math.floor((iconW - ) / 2);
	--local yFix = math.floor((iconH - PictureC:GetImageHeight()) / 2);
	--PictureC:Resize(PictureC:GetOffsetX() + xFix, PictureC:GetOffsetY() + yFix, PictureC:GetImageWidth(), PictureC:GetImageHeight());

end




function BUFF_TIME_UPDATE(handle, buff_ui)

	local updated = 0;
	for j = 0 , buff_ui["buff_group_cnt"] do

		local slotlist = buff_ui["slotlist"][j];
		local captlist = buff_ui["captionlist"][j];
		if buff_ui["slotcount"][j] ~= nil and buff_ui["slotcount"][j] >= 0 then
    		for i = 0,  buff_ui["slotcount"][j] - 1 do
    
    			local slot		= slotlist[i];
    			local text		= captlist[i];
    
    			if slot:IsVisible() == 1 then
    				local icon 		= slot:GetIcon();
    				local iconInfo = icon:GetInfo();
					local buffIndex = icon:GetUserIValue("BuffIndex");
    				local buff = info.GetBuff(handle, iconInfo.type, buffIndex);
    				if buff ~= nil then
    					SET_BUFF_TIME_TO_TEXT(text, buff.time);
    					updated = 1;
    
    					if buff.time < 5000 and buff.time ~= 0.0 then
    						if slot:IsBlinking() == 0 then
    							slot:SetBlink(600000, 1.0, "55FFFFFF", 1);
    						end
    					else
    						if slot:IsBlinking() == 1 then
    							slot:ReleaseBlink();
    						end
    					end
    				end
    			end
    		end
		end
	end

	if updated == 1 then
		ui.UpdateVisibleToolTips("buff");
	end


end


function GET_QUEST_NPC_NAMES(mapname, npclist, statelist, questIESList, questPropList)

	local idx = 1;
	local pc = GetMyPCObject();
	local questIES = nil;
	local cnt = GetClassCount('QuestProgressCheck')
	local subQuestZoneList = {}
	for i = 0, cnt - 1 do
		questIES = GetClassByIndex('QuestProgressCheck', i);
		if questIES.ClassName ~= 'None' then
    		local result = SCR_QUEST_CHECK_C(pc,questIES.ClassName);

    		if result ~= 'IMPOSSIBLE' then
    		    local flag = 0
    		    
    		    if questIES.PossibleUI_Notify == 'UNCOND' or result ~= 'POSSIBLE' then
    		        flag = 1
    		    end
    		    
    		    if flag == 0 then
    		        if questIES.QuestStartMode == 'NPCENTER_HIDE' 
    		        or questIES.QuestStartMode == 'GETITEM' 
    		        or questIES.QuestStartMode == 'USEITEM'
    		        or questIES.PossibleUI_Notify == 'NO' then
    				else
    				    flag = 1
    				end
    		    end
    		    local result2
    		    result2, subQuestZoneList = SCR_POSSIBLE_UI_OPEN_CHECK(pc, questIES, subQuestZoneList, 'ZoneMap')
    		    if result == "POSSIBLE" and result2 == "HIDE" then
    		        flag = 0
    		    end
    		    
    		    if flag == 1 then
    		        local State = CONVERT_STATE(result);
        			local questMap = questIES[State .. 'Map'];
					local npcname = questIES[State .. 'NPC'];
                    
					--if npcname ~= 'None' then
						npclist[idx] = npcname;
						statelist[idx] = result;
						questIESList[idx] = questIES;
						questPropList[idx] = geQuestTable.GetPropByIndex(i);
						idx = idx + 1;
					--end
    		    end
    		end
		end
	end

end

function GET_JOB_ICON(job)

	local cls = GetClassByType("Job", job);
	if cls == nil then
		return "None";
	end

	return cls.Icon;

end


function GET_MON_ILLUST(monCls)

	if monCls == nil then
		return "unknown_monster";
	end

	local name = monCls.Journal;
	if ui.IsImageExist(name) == true then
		return name;
	end
	
	name = "mon_"..name
	if ui.IsImageExist(name) == true then
		return name;
	end

	name = monCls.Icon;
	if ui.IsImageExist(name) == true then
		return name;
	end
	
	return "unknown_monster";
end