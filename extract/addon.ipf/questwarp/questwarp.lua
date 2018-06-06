QUESTWARP_MAX_BTN = 10;

function QUESTWARP_ON_INIT(addon, frame)

	addon:RegisterMsg('QUESTWARPSELECT_UP', 'QUESTWARP_ON_MSG');
	addon:RegisterMsg('QUESTWARPSELECT_DOWN', 'QUESTWARP_ON_MSG');
	addon:RegisterMsg('QUESTWARPSELECT_SELECT', 'QUESTWARP_ON_MSG');
	QuestWarpSelect_index = 0;
	QuestWarpMaxCount = 0;
end

function BUILD_QUESTWARP_LIST(frame)

	local qFrame = ui.GetFrame("questinfoset_2");	
	local groupBox = GET_CHILD(qFrame, "member", "ui::CGroupBox");
	local cnt = groupBox:GetChildCount();
	local btnIndex = 0;
	local index = 0
	for i = 0, QUESTWARP_MAX_BTN -1 do
		frame:SetUserValue("QUEST_WARP_CLASSNAME_"..i, 'None');
		frame:SetUserValue("QUEST_WARP_CLASSID_"..i, 0);
	end
	for  i = 0, cnt -1 do
		local childObj = groupBox:GetChildByIndex(i);
		local pic = GET_CHILD(childObj, "statepicture", "ui::CPicture");
		if pic ~= nil then
			local questName = pic:GetUserValue("RETURN_QUEST_NAME");
			if questName ~= "None" then
				local questIES = GetClass("QuestProgressCheck", questName);
				frame:SetUserValue("QUEST_WARP_CLASSNAME_"..index, questIES.Name);
				frame:SetUserValue("QUEST_WARP_CLASSID_"..index, questIES.ClassID);
				index = index + 1
			end
		end
	end

end

function OPEN_QUESTWARP_FRAME(frame)
	BUILD_QUESTWARP_LIST(frame);

	local questCount = 0;
	local lastIndex = -1;
	local index = 0
	for i=0, QUESTWARP_MAX_BTN-1 do

		
		local quest = frame:GetUserValue("QUEST_WARP_CLASSNAME_"..i);
		if quest ~= 'None' then
		    local childName = 'warp' .. i .. 'btn'
    		local itemBtn = frame:GetChild(childName);
    		local questID = frame:GetUserValue("QUEST_WARP_CLASSID_"..i);
    		local questIES = GetClassByType('QuestProgressCheck',questID)
    		local pc = GetMyPCObject()
    		local result = SCR_QUEST_CHECK_C(pc, questIES.ClassName)
    		local questState = GET_QUEST_NPC_STATE(questIES, result)
			questCount = questCount + 1;
			lastIndex = i;
			
			itemBtn:SetText('{@st66b}'..quest);
			itemBtn:ShowWindow(1);
			if questState ~= nil then
    			itemBtn:SetTextTooltip(questIES[questState..'Desc'])
    		end
		else
		    local childName = 'warp' .. i .. 'btn'
		    local itemBtn = frame:GetChild(childName);
		    itemBtn:ShowWindow(0);
		end

	end

	QuestWarpSelect_index = 0;
	QuestWarpMaxCount = questCount;
	if questCount == 0 then
		frame:ShowWindow(0);
		return;
	elseif questCount == 1 then
	    local questID = frame:GetUserValue("QUEST_WARP_CLASSID_"..lastIndex);
		questID = tonumber(questID);
		QUESTION_QUEST_WARP(nil, nil, nil, questID);
		frame:ShowWindow(0);
		return
	end
	QUESTWARP_ITEM_SELECT(frame)
	frame:Resize(frame:GetWidth(), questCount * 40 + 130);
	frame:ShowWindow(1);
end

function QUESTWARP_ITEM_SELECT(frame)
	local childName = 'warp' .. QuestWarpSelect_index .. 'btn'
	local ItemBtn = frame:GetChild(childName);
	
	local x, y = GET_SCREEN_XY(ItemBtn);
	mouse.SetPos(x + ItemBtn:GetWidth()*0.25,y);
	mouse.SetHidable(0);
end

function QUESTWARP_ON_MSG(frame, msg, argStr, argNum)

	if msg == 'QUESTWARPSELECT_UP' then

		QuestWarpSelect_index = QuestWarpSelect_index - 1;
		if QuestWarpSelect_index < 0 then
			QuestWarpSelect_index = QuestWarpMaxCount-1;			
		end
		QUESTWARP_ITEM_SELECT(frame)

	elseif msg == 'QUESTWARPSELECT_DOWN' then

		QuestWarpSelect_index = QuestWarpSelect_index + 1;
		if QuestWarpSelect_index >= QuestWarpMaxCount then
			QuestWarpSelect_index = 0;
		end
		QUESTWARP_ITEM_SELECT(frame)

	elseif msg == 'QUESTWARPSELECT_SELECT' then

		local questID = frame:GetUserValue("QUEST_WARP_CLASSID_"..QuestWarpSelect_index);
		questID = tonumber(questID);
		QUESTION_QUEST_WARP(nil, nil, nil, questID);
		frame:ShowWindow(0);
	end
end

function QUESTWARP_QUESTID(frame, obj, argStr, index)

	local frame = ui.GetFrame('questwarp');
	local questID = tonumber( frame:GetUserValue("QUEST_WARP_CLASSID_"..index) );
	QUESTION_QUEST_WARP(nil, nil, nil, questID);
	frame:ShowWindow(0);
end
