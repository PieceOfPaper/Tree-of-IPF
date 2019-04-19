

function QUESTDETAIL_ON_INIT(addon, frame)

end

function QUESTDETAIL_ON_MSG(frame, msg, argStr, argNum)

end

function QUESTDETAIL_MAKE_TITLE_CTRL(frame, questIES ) 
	if frame == nil then
		frame = ui.GetFrame('questdetail');
	end

	local pc = SCR_QUESTINFO_GET_PC();
	local sObj = GetSessionObject(pc, 'ssn_klapeda')
	local titleText = GET_QUEST_DETAIL_TITLE(questIES, sObj);    

	local title = GET_CHILD_RECURSIVELY(frame, 'title');
	local level = GET_CHILD_RECURSIVELY(frame, 'level');

	title:SetTextByKey("text", titleText)
	level:SetTextByKey("text", ScpArgMsg("Level{Level}","Level",questIES.Level));
end


function  GET_QUEST_LOCATION_MAPUILIST(questIES, state, txt, txtList)
	local mapListUI = questIES[state .. 'MapListUI']
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
	end
	return txt, txtList
end

function  GET_QUEST_LOCATION_MAPLIST(questIES, state, txt, txtList)
	local map = questIES[state .. 'Map'];
	if map ~= '' and map ~= 'None' then
		local zoneName = GetClassString('Map', map, 'Name')
        if zoneName ~= nil and table.find(txtList, zoneName) == 0 then
            txt = zoneName
            txtList[#txtList + 1] = zoneName
        end
	end
	return txt, txtList
end

function GET_QUEST_LOCATION_SESSIONOBJ(questIES, result, txt, txtList )

	if questIES.Quest_SSN ~= 'None' then
		local pc = SCR_QUESTINFO_GET_PC();
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
	return txt, txtList
end

function GET_QUEST_LOCATION_LIST(questIES, State, txt, txtList)

	local location = questIES[State .. 'Location'];
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
	
	return txt, txtList
end

-- 위치 컨트롤
function QUESTDETAIL_MAKE_LOCATION_CTRL(gbBody, x, y, questIES )
	local pc = GetMyPCObject();
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);
	local State = CONVERT_STATE(result);
    local height =0; 
	local txt =""
	local txtList = {}
	txt, txtList = GET_QUEST_LOCATION_MAPUILIST(questIES, State, txt, txtList)
	txt, txtList = GET_QUEST_LOCATION_MAPLIST(questIES, State, txt, txtList)
	txt, txtList = GET_QUEST_LOCATION_SESSIONOBJ(questIES, result, txt, txtList)
	txt, txtList = GET_QUEST_LOCATION_LIST(questIES, State, txt, txtList)
	
	local topFrame = gbBody:GetTopParentFrame();
    if txt ~= '' then
        -- 제목 
        local tagText = topFrame:GetUserConfig('QUEST_LOC_TEXT');
        if tagText == nil then
            tagText = "{@st38}Loc{/}"
        end
        local contentTitle = gbBody:CreateOrGetControl('richtext', 'QuestLocation', x, y + height, gbBody:GetWidth() - x - SCROLL_WIDTH , 10);
        contentTitle:EnableHitTest(0);
        contentTitle:SetTextFixWidth(1);
        contentTitle:SetText(tagText);
        height = height + contentTitle:GetHeight();

         -- 내용 
        local font =topFrame:GetUserConfig('QUEST_LOC_FONT'); 
        if font == nil then
            font = "{@st38}"
        end
        txt = font .. txt

        local offsetX = topFrame:GetUserConfig('QUEST_LOC_X'); 
        if offsetX == nil then
            offsetX = 10
        end

        local content = gbBody:CreateOrGetControl('richtext', 'QuestLocationDesc', x + offsetX, y + height, gbBody:GetWidth() - x - SCROLL_WIDTH , 10);
        content:EnableHitTest(0);
        content:SetTextFixWidth(1);
        content:SetText(txt);
        height = height + content:GetHeight();
    end

	return height;
end

-- 개요 컨트롤
function QUESTDETAIL_MAKE_SUMMARY_CTRL(gbBody, x, y, questIES )
	local pc = GetMyPCObject();
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);
	local State = CONVERT_STATE(result);
	local txt = questIES[State..'Story']; 
	local topFrame = gbBody:GetTopParentFrame();
    local height =0; 
	-- 값이 있으면 항목 설정.
    if txt ~= '' then
        -- 제목 
		local tagText = topFrame:GetUserConfig('QUEST_SUMMARY_TEXT');
		if tagText == nil then
			tagText = "{@st41}Summary{/}"
        end
    
        local contentTitle = gbBody:CreateOrGetControl('richtext', 'QuestSummary', x, y + height, gbBody:GetWidth() - x - SCROLL_WIDTH , 10);
        contentTitle:EnableHitTest(0);
        contentTitle:SetTextFixWidth(1);
        contentTitle:SetText(tagText);
        height = height + contentTitle:GetHeight();

        -- 내용 
		local font =topFrame:GetUserConfig('QUEST_SUMMARY_FONT'); 
		if font == nil then
			font = "{@st41}"
		end
        txt = font .. txt
        
        local offsetX = topFrame:GetUserConfig('QUEST_SUMMARY_X'); 
        if offsetX == nil then
            offsetX = 10
        end

        local content = gbBody:CreateOrGetControl('richtext', 'QuestSummaryDesc', x + offsetX, y + height, gbBody:GetWidth() - x - SCROLL_WIDTH , 10);
        content:EnableHitTest(0);
        content:SetTextFixWidth(1);
        content:SetText(txt);
        height = height + content:GetHeight();

    end
    
    return height;
end

-- 선행 퀘스트 목록 설정.
function QUESTDETAIL_MAKE_PREQUEST_LIST_CTRL(ctrlset, x, y, questIES)

	if questIES.Succ_Check_QuestCount == 0 then
		return 0;
	end

	local pc = SCR_QUESTINFO_GET_PC();
	
	local sObj_main = GetSessionObject(pc, 'ssn_klapeda');
    if sObj_main == nil then
        return 0;
    end
	
	local height = 0;

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
                    			local content = ctrlset:CreateOrGetControl('richtext', "QUESTCK" .. addIndex, x, y + height, ctrlset:GetWidth() - x - SCROLL_WIDTH, 10);
                				content:EnableHitTest(0);
                    			content:SetTextFixWidth(0);
                    			content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
                    			height = height + content:GetHeight();
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
                    			local content = ctrlset:CreateOrGetControl('richtext', "QUESTCK" .. addIndex, x, y + height, ctrlset:GetWidth() - x - SCROLL_WIDTH, 10);
                				content:EnableHitTest(0);
                    			content:SetTextFixWidth(0);
                    			content:SetText('{s16}{ol}{#ffcc33}'..itemtxt);
                    			height = height + content:GetHeight();
                    		end
                    	end
                    end
                end
            end
        end
    end
    
	return height;
end

-- 목표 컨트롤
function QUESTDETAIL_MAKE_OBJECTIVE_CTRL(gbBody, x, y, questIES )
	local pc = GetMyPCObject();
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);
	local State = CONVERT_STATE(result);
	local txt = questIES[State.."Desc"]  -- 목표
    local height = 0;
    local topFrame = gbBody:GetTopParentFrame();
    local offsetX = topFrame:GetUserConfig('QUEST_OBJECTIVE_X'); 
    if offsetX == nil then
        offsetX = 10
    end

	-- 값이 있으면 항목 설정.
    if txt ~= '' then
         -- 제목 
		local tagText = topFrame:GetUserConfig('QUEST_OBJECTIVE_TEXT');
		if tagText == nil then
			tagText = "{@st41}Obj{/}"
        end

        local contentTitle = gbBody:CreateOrGetControl('richtext', 'QuestObjective', x, y + height, gbBody:GetWidth() - x - SCROLL_WIDTH , 10);
        contentTitle:EnableHitTest(0);
        contentTitle:SetTextFixWidth(1);
        contentTitle:SetText(tagText);
        height = height + contentTitle:GetHeight();
        -- 내용
		local font =topFrame:GetUserConfig('QUEST_OBJECTIVE_FONT'); 
		if font == nil then
			font = "{@st41}"
		end
        txt = font .. txt

        local content = gbBody:CreateOrGetControl('richtext', 'QuestObjectiveDesc', x + offsetX, y + height, gbBody:GetWidth() - x - SCROLL_WIDTH , 10);
        content:EnableHitTest(0);
        content:SetTextFixWidth(1);
        content:SetText(txt);
        height = height + content:GetHeight();
	end

	-- 선행퀘스트 목록 설정.
	height = height + QUESTDETAIL_MAKE_PREQUEST_LIST_CTRL(gbBody, x + offsetX, y+height, questIES);

	return height;
end

-- 보상 컨트롤
function QUESTDETAIL_MAKE_REWARD_CTRL(gbBody, x, y, questIES)

	local height = 0;
	-- 퀘스트가 진행중이거나 완료 상태 일때 필요한 아이템이 있는지 확인하고 그리기
	if result == 'PROGRESS' or result == 'SUCCESS' then
		height = height + QUESTDETAIL_MAKE_REWARD_TAKE_CTRL(gbBody, x, y + height, questIES);
	end
	
	-- 선택 보상 컨트롤 만들기
	height = height + QUESTDETAIL_MAKE_SELECT_REWARD_CTRL(gbBody,  x, y + height, questIES);
	
	-- 퀘스트 보상 정보.
    local reward_result = QUEST_REWARD_CHECK(questIES.ClassName)
   if #reward_result > 0 then
        local topFrame = gbBody:GetTopParentFrame();
        local titleText = topFrame:GetUserConfig('QUEST_REWARD_TEXT');
        if titleText == nil then
			titleText =  ScpArgMsg("Auto_{@st41}BoSang");
		end
        
		height = height +  QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x, y + height, gbBody:GetWidth() - 30, 20, "t_addreward", titleText); -- 타이틀
		height = height +  QUESTDETAIL_MAKE_REWARD_MONEY_CTRL(gbBody, x, y + height, questIES);			-- 실버
		height = height +  QUESTDETAIL_MAKE_REWARD_BUFF_CTRL(gbBody, x, y + height, questIES);    		-- 버프
		height = height +  QUESTDETAIL_MAKE_REWARD_HONOR_CTRL(gbBody, x , y + height, questIES);		-- 칭호
		height = height +  QUESTDETAIL_MAKE_REWARD_PCPROPERTY_CTRL(gbBody, x, y + height, questIES); 	-- 프로퍼티(업적, 스탯등)
		height = height +  QUESTDETAIL_MAKE_REWARD_JOURNEYSHOP_CTRL(gbBody, x, y + height, questIES); 	-- 저니샵??
   end
   
	height = height +  QUESTDETAIL_MAKE_EXP_REWARD_CTRL(gbBody, x, y + height, questIES); 				-- 경험치
	height = height +  QUESTDETAIL_MAKE_REWARD_ITEM_CTRL(gbBody, x, y + height, questIES);    			-- 아이템
	height = height +  QUESTDETAIL_MAKE_REWARD_RANDOM_CTRL(gbBody, x, y + height, questIES); 			-- 랜덤 ?
	height = height +  QUESTDETAIL_MAKE_REWARD_STEP_ITEM_CTRL(gbBody, x, y + height, questIES); 		-- 단계별 ?
	height = height +  QUESTDETAIL_MAKE_REWARD_REPEAT_CTRL(gbBody, x, y + height, questIES); 			-- 반복보상

	return height
end

function QUESTDETAIL_CLOSE_FRAME(ctrl, ct)
    ui.CloseFrame("questdetail");
end

-- 버튼 컨트롤
function QUESTDETAIL_MAKE_BTN_CTRL(gbBody, x, y, questIES, isCompleteQuest)
    
    local pc = GetMyPCObject();
	local result = SCR_QUEST_CHECK_Q(pc, questIES.ClassName);
	local State = CONVERT_STATE(result);
    local questCls = GetClassByType("QuestProgressCheck_Auto", questIES.ClassID);
    local sobjIES = GET_MAIN_SOBJ();
	local abandonCheck = QUEST_ABANDON_RESTARTLIST_CHECK(questIES, sobjIES); -- 포기퀘스트 체크
            

    local height =0; 
    local frame = ui.GetFrame("questdetail");
    local isLocation = false;
    local isAbandon = false;
    local isRestart = false;

    -- 완료 퀘스트인가? 
    if isCompleteQuest ~= nil and isCompleteQuest == true then
        height = height + QUESTDETAIL_MAKE_DIALOG_BTN(frame, gbBody, x, y+height, questIES)
    else
        -- 포기 버튼이 나와야 하는 퀘스트인가
        if  questIES.AbandonUI == 'YES' and  (result == 'PROGRESS' or result == 'SUCCESS') then 
            isAbandon = true;
        end

        -- 재시작 버튼을 만들어야 하는가
        if  abandonCheck == 'ABANDON/LIST' and result == 'POSSIBLE' then
            isRestart = true;
        end

        -- 위치표시가 되어야 하는 퀘스트인가
        if CHECK_QUEST_LOCATION(questIES) == true then
            isLocation = true;
        end
       
        -- 위치보기, 포기 버튼 생성
        if isLocation == true and (isAbandon == true or isRestart == true ) then
            -- 위치보기 버튼 좌측 (margin,gravity 설정)
            height = height +  QUESTDETAIL_MAKE_LOCATION_BTN(frame, gbBody, x, y+height, questIES,
            { horz = ui.LEFT, vert = ui.BOTTOM },
            { 20, 0, 0, 10});

            -- 포기/재시작 버튼 우측(margin,gravity 설정)
            if isRestart == true then
                height = height + QUESTDETAIL_MAKE_RESTART_BTN(frame, gbBody, x, y+height, questIES, 
                { horz = ui.RIGHT, vert = ui.BOTTOM },
                { 0, 0, 20, 10});
            else
                height = height + QUESTDETAIL_MAKE_ABANDON_BTN(frame, gbBody, x, y+height, questIES,
                { horz = ui.RIGHT, vert = ui.BOTTOM },
                { 0, 0, 20, 10});
            end

        elseif isLocation == true then
            height = height +  QUESTDETAIL_MAKE_LOCATION_BTN(frame, gbBody, x, y+height, questIES);
        elseif isAbandon == true then
            height = height + QUESTDETAIL_MAKE_ABANDON_BTN(frame, gbBody, x, y+height, questIES);
        elseif isRestart == true then
            height = height + QUESTDETAIL_MAKE_RESTART_BTN(frame, gbBody, x, y+height, questIES);
        end
    end

	return height;
end

function QUESTDETAIL_INFO(questID, xPos, prop)
	local frame = ui.GetFrame('questdetail');
	local gbBody = frame:GetChild('gbBody');
	tolua.cast(gbBody, "ui::CGroupBox");
	gbBody:DeleteAllControl();

	local questIES = GetClassByType("QuestProgressCheck", questID);

	local y = 0;
	local spaceY = 10
	local x = 10;
    
	if prop.isCompleteQuest == true then    -- 완료 퀘스트
	 	QUESTDETAIL_MAKE_TITLE_CTRL(frame, questIES ) -- 퀘스트 제목, 레벨
	 	-- 개요
		y = y + QUESTDETAIL_MAKE_SUMMARY_CTRL(gbBody, x, y, questIES) + spaceY;
		-- 목표
		y = y + QUESTDETAIL_MAKE_OBJECTIVE_CTRL(gbBody, x, y, questIES) + spaceY;
		-- 보상
		y = y + QUESTDETAIL_MAKE_REWARD_CTRL(gbBody, x, y, questIES) + spaceY;
		-- 버튼 - 대사 보기 버튼.
		y = y + QUESTDETAIL_MAKE_BTN_CTRL(gbBody, 0, y, questIES, prop.isCompleteQuest) + spaceY;
	 else -- 진행중 퀘스트
		QUESTDETAIL_MAKE_TITLE_CTRL(frame, questIES) -- 퀘스트 제목, 레벨
		 -- 위치
		y = y + QUESTDETAIL_MAKE_LOCATION_CTRL(gbBody, x, y, questIES) + spaceY;
		 -- 개요
		y = y + QUESTDETAIL_MAKE_SUMMARY_CTRL(gbBody, x, y, questIES) + spaceY;
		 -- 목표
		y = y + QUESTDETAIL_MAKE_OBJECTIVE_CTRL(gbBody,x, y, questIES) + spaceY;
		 -- 보상
		y = y + QUESTDETAIL_MAKE_REWARD_CTRL(gbBody, x, y, questIES) + spaceY;
		-- 버튼 - 위치보기 / [포기/재시작] 버튼
		y = y + QUESTDETAIL_MAKE_BTN_CTRL(gbBody, 0, y, questIES, prop.isCompleteQuest) + spaceY;
     end
     
	frame:ShowWindow(1);
	gbBody:Resize(gbBody:GetWidth(), y);
	frame:Resize(xPos, frame:GetY(), frame:GetWidth(), y + 120);
	frame:Invalidate()
end

function GET_QUEST_DETAIL_TITLE(questCls, sObj)
    local titleText = nil;
    if questCls.QuestMode == 'REPEAT' then
		if sObj ~= nil then
			if questCls.Repeat_Count ~= 0 then
				titleText = questCls.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/{Auto_2})","Auto_1", sObj[questCls.QuestPropertyName..'_R'] + 1, "Auto_2",questCls.Repeat_Count);
			else
				titleText = questCls.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/MuHan)","Auto_1", sObj[questCls.QuestPropertyName..'_R'])
			end
		end
	elseif questCls.QuestMode == 'PARTY' then
	    if sObj ~= nil then
	        titleText = questCls.Name..ScpArgMsg("Auto__-_BanBog({Auto_1}/{Auto_2})","Auto_1", sObj.PARTY_Q_COUNT1 + 1, "Auto_2",CON_PARTYQUEST_DAYMAX1)
	    end
	end
	
	if titleText == nil then
	    titleText = questCls.Name;
	end
	
    return titleText;
end


function MAKE_ABANDON_CTRL(frame, box, y)
	local abandonBtn = box:CreateControl('button', 'abandon_btn', -15, -40, 160, 50);
	tolua.cast(abandonBtn, 'ui::CButton');
	abandonBtn:SetGravity(ui.CENTER_HORZ, ui.BOTTOM);
	abandonBtn:SetText(frame:GetUserConfig("ABANDON_FONT") .. ClMsg("Abandon"));
	abandonBtn:SetTooltipType('texthelp');
	abandonBtn:SetSkinName(frame:GetUserConfig("ABAONDON_BUTTON_SKIN"));
	abandonBtn:SetTooltipArg(frame:GetUserConfig("ABANDON_TOOLTIP_FONT") .. ClMsg("AbandonQuest"));
    
    local curquest = session.GetUserConfig("CUR_QUEST", 0);
    local StrScript = string.format("EXEC_ABANDON_QUEST(%d)", curquest);
    abandonBtn:SetEventScript(ui.LBUTTONUP, StrScript, true);
	abandonBtn:SetOverSound('button_over');
	abandonBtn:SetClickSound('button_click_big');

	return y + abandonBtn:GetHeight();
end