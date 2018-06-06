function ADVENTURE_BOOK_QUEST_ON_INIT(addon, frame)
end

function ADVENTURE_BOOK_QUEST_INIT_DETAIL(questID)
   local pc = GetMyPCObject();
   local sObj = GetSessionObject(pc, 'ssn_klapeda');
   local questCls = GetClassByType('QuestProgressCheck', questID);
   local cls = GetClassByType("QuestProgressCheck_Auto", questID);
   local frame = ui.GetFrame('adventure_book_quest');

   local titleText = frame:GetChild('titleText');
   titleText:SetTextByKey('title', GET_QUEST_DETAIL_TITLE(questCls, sObj));

   local regionText = frame:GetChild('regionText');
   local startMapCls = GetClass('Map', questCls.StartMap);
   regionText:SetTextByKey('region', startMapCls.Name);
    
   local rewardBox = frame:GetChild('rewardBox');
   _ADVENTURE_BOOK_QUST_INIT(rewardBox, pc, questCls, cls, sObj);
    
   frame:ShowWindow(1);
end

function _ADVENTURE_BOOK_QUST_INIT(rewardBox, pc, questCls, cls, sObj)
    rewardBox:RemoveAllChild();

    local repeat_reward_item = {};
    local repeat_reward_achieve = {};
    local repeat_reward_achieve_point = {};
    local repeat_reward_exp = 0;
    local repeat_reward_npc_point = 0;
    local repeat_reward_select = false;
    local repeat_reward_select_use = false;
    repeat_reward_item, repeat_reward_achieve, repeat_reward_achieve_point, repeat_reward_exp, repeat_reward_npc_point, repeat_reward_select, repeat_reward_select_use = SCR_REPEAT_REWARD_CHECK(pc, questCls, cls, sObj);

    local y = 0;    
    y = MAKE_SELECT_REWARD_CTRL(rewardBox, y, cls);    
    local reward_result = QUEST_REWARD_CHECK(questCls.ClassName);    
    if #reward_result > 0 then
    	y = BOX_CREATE_RICHTEXT(rewardBox, "t_addreward", y, 20, ScpArgMsg("Auto_{@st41}BoSang"));
    	y = MAKE_BASIC_REWARD_MONEY_CTRL(rewardBox, cls, y);
    	y = MAKE_BASIC_REWARD_BUFF_CTRL(rewardBox, cls, y);
    	y = MAKE_BASIC_REWARD_HONOR_CTRL(rewardBox, cls, y);
    	y = MAKE_BASIC_REWARD_PCPROPERTY_CTRL(rewardBox, cls, y);
        y = MAKE_BASIC_REWARD_ITEM_CTRL(rewardBox, cls, y);    
        y = MAKE_BASIC_REWARD_RANDOM_CTRL(rewardBox, questCls, cls, y + 20);    
	    y = MAKE_BASIC_REWARD_REPE_CTRL(rewardBox, questCls, cls, y + 20);
    end
    
    local frame = rewardBox:GetTopParentFrame();
    local rewardBox = frame:GetChild('rewardBox');
    local bottomY = y + 110
    local preQuestHeight = 0
    if y == 0 then
        bottomY = bottomY + 30
        preQuestHeight = preQuestHeight + 30
    end
    
    local result1, result2  = SCR_QUEST_CHECK(pc, questCls.ClassName)
    local nowpreCount = 0
    if result1 == 'IMPOSSIBLE' and table.find(result2, 'Check_QuestCount') > 0 then
        local t1, t2, t3 = SCR_QUEST_LINK_FIRST(pc,questCls.ClassName)
        if #t2 > 0 then
            bottomY = BOX_CREATE_RICHTEXT(frame, "preQuestTitle", bottomY, 50, ScpArgMsg('adventure_book_quest_prequest_MSG1'), 20);
            bottomY = bottomY + 7
            preQuestHeight = preQuestHeight + 20
            for i = 1, #t2 do
                local preQuestIES = GetClass('QuestProgressCheck', t2[i]);
                bottomY = BOX_CREATE_RICHTEXT(frame, "preQuest"..i..'_'..1, bottomY, 50, '{@st42}{s18}'..preQuestIES.Name..'{/}', 40);
                bottomY = bottomY + 5
                local zoneName = preQuestIES.StartMap
                if zoneName == 'None' then
                    zoneName = ScpArgMsg('IndunRewardItem_Empty')
                else
                    local zoneIES = GetClass('Map', zoneName)
                    if zoneIES ~= nil then
                        zoneName = zoneIES.Name
                    else
                        zoneName = ScpArgMsg('IndunRewardItem_Empty')
                    end
                end
                bottomY = BOX_CREATE_RICHTEXT(frame, "preQuest"..i..'_'..2, bottomY, 50, ScpArgMsg('QuestZoneBasicTxt')..zoneName, 60);
                local zone = frame:GetChild("preQuest"..i..'_'..2);
                zone:SetFontName('white_16_ol')
                bottomY = bottomY + 5
                nowpreCount = nowpreCount + 1
                preQuestHeight = preQuestHeight + 45
            end
        end
    end
    
    frame:SetUserValue('PREQUESTHEIGHT',preQuestHeight)
    
        
    local lastpreCount = tonumber(frame:GetUserValue('PREQUESTCOUNT'))
    if lastpreCount ~= nil and lastpreCount > nowpreCount then
        if nowpreCount == 0 then
            frame:RemoveChild('preQuestTitle')
        end
        for i = nowpreCount + 1, lastpreCount do
            frame:RemoveChild('preQuest'..i..'_'..1)
            frame:RemoveChild('preQuest'..i..'_'..2)
        end
    end
    
    frame:SetUserValue('PREQUESTCOUNT',nowpreCount)
    
    
    ADVENTURE_BOOK_QUEST_AUTO_RESIZE(rewardBox, y);
    
    
    rewardBox:SetUserValue('CURRENTY',y)
end

function ADVENTURE_BOOK_QUEST_AUTO_RESIZE(rewardBox, y)
    local topFrame = rewardBox:GetTopParentFrame();
    local completeBox = topFrame:GetChild('completeBox');
    local completeBoxMargin = completeBox:GetMargin();
    local bottomY = completeBox:GetHeight() + completeBoxMargin.bottom;
    local topY = rewardBox:GetOriginalY();
    local totalHeight = topY + bottomY + y;

    local diff = option.GetClientHeight() - topFrame:GetY() + totalHeight;
    local preQuestHeight = tonumber(topFrame:GetUserValue('PREQUESTHEIGHT'))
    if preQuestHeight == nil then
        preQuestHeight = 0
    end
    if diff > 0 then
        rewardBox:Resize(rewardBox:GetWidth(), y);
        topFrame:Resize(topFrame:GetWidth(), totalHeight + preQuestHeight);
    else
        local rewardHeight = y - diff;
        rewardBox:SetScrollBar(rewardHeight);
        rewardBox:Resize(rewardBox:GetWidth(), rewardHeight);
        topFrame:Resize(topFrame:GetWidth(), totalHeight - diff + preQuestHeight);
    end
end

function UPDATE_QUEST_COMPLETE_LIST(charNameList)
    local frame = ui.GetFrame('adventure_book_quest');
    local listBox = GET_CHILD_RECURSIVELY(frame, 'listBox');
    local CHAR_NAME_FONT = frame:GetUserConfig('CHAR_NAME_FONT');
    listBox:RemoveAllChild();    

    for i = 1, #charNameList do
        local charName = charNameList[i];
        local text = listBox:CreateControl('richtext', 'CHAR_NAME_'..charName, 10, 0, 300, 30);
        text:SetText(charName);
        text:SetFontName(CHAR_NAME_FONT);
    end
    GBOX_AUTO_ALIGN(listBox, 15, 0, 0, true, false);
end