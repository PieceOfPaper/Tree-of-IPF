-- questepisodereward.lua

function QUESTEPISODEREWARD_ON_INIT(addon, frame)
    addon:RegisterMsg('EPISODE_REWARD_CLEAR', 'QUESTEPISODEREWARD_FRAME_CLOSE');
    
end

function QUESTEPISODEREWARD_INFO(episodeName, xPos, prop)
    local frame = ui.GetFrame('questepisodereward');
    local gbBody = frame:GetChild('gbBody');
	tolua.cast(gbBody, "ui::CGroupBox");
	gbBody:DeleteAllControl();

    local episodeRewardIES = GetClass("Episode_Reward", episodeName);
    local pcObj = GetMyPCObject();
	local result = SCR_EPISODE_CHECK(pcObj, episodeRewardIES.ClassName)
	
    -- 최신 에피소드 보상 UI 출력 예외 처리
	if result == 'New' or result == 'Next' then
	    return
	end

    -- 에피소드 텍스트 
    local episodeNumberText = GET_CHILD_RECURSIVELY(frame, "episodeNumberText");
    local episodeNameText = GET_CHILD_RECURSIVELY(frame, "episodeNameText");
    episodeNumberText:SetTextByKey("name",episodeRewardIES.ClassNumberString )
    episodeNameText:SetTextByKey("name",episodeRewardIES.EpisodeName )
   
	local y = 0;
	local spaceY = 10
    local x = 10;
    
    -- 보상
    y = y + QUESTEPISODEREWARD_MAKE_REWARD_CTRL(gbBody, x, y, episodeRewardIES) + spaceY;
    
    gbBody:Resize(gbBody:GetWidth(), y);
    local gbBottom = GET_CHILD_RECURSIVELY(frame, "gbBottom");
    y = y + gbBottom:GetHeight();
    
    -- 버튼에 arg 전달
    local btnReward = GET_CHILD_RECURSIVELY(frame, "btnReward");
    btnReward:SetEventScriptArgString(ui.LBUTTONUP, episodeRewardIES.ClassName);
    btnReward:SetSkinName("test_red_button");
    btnReward:SetEnable(1)
    if result ~= 'Reward' then
        btnReward:SetSkinName("test_gray_button");
        btnReward:SetEnable(0)
    end

    frame:Resize(xPos, frame:GetY(), frame:GetWidth(), y + 200);
    frame:ShowWindow(1);
	frame:Invalidate()
end

function QUESTEPISODEREWARD_FRAME_CLOSE(frame)
    ui.CloseFrame('questepisodereward');
end


-- 보상 컨트롤
function QUESTEPISODEREWARD_MAKE_REWARD_CTRL(gbBody, x, y, episodeRewardIES)
    local height = 0;
    local topFrame = gbBody:GetTopParentFrame();
    local titleText = topFrame:GetUserConfig('QUEST_REWARD_TEXT');
    if titleText == nil then
        titleText =  ScpArgMsg("Auto_{@st41}BoSang");
    end

    height = height +  QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x, y + height, gbBody:GetWidth() - 30, 20, "t_addreward", titleText); -- 타이틀
	height = height +  QUESTEPISODEREWARD_MAKE_REWARD_ITEM_CTRL(gbBody, x, y + height, episodeRewardIES);    	-- 아이템 (최대 5개)
    height = height +  QUESTEPISODEREWARD_MAKE_REWARD_HONOR_CTRL(gbBody, x , y + height, episodeRewardIES);		-- 칭호

    return height
end

-- 보상 - 아이템
function QUESTEPISODEREWARD_MAKE_REWARD_ITEM_CTRL(gbBody, x, y, episodeRewardIES)

    local height = 0;
    for i = 1, 6 do
        local propName = "RewardItemName" .. i;
        if episodeRewardIES[propName] ~= "None" and episodeRewardIES[propName] ~= "Vis" then
            height = height + QUESTEPISODEREWARD_MAKE_ITEM_TAG_TEXT_CTRL(gbBody, x, y + height,  "reward_item", episodeRewardIES[propName], episodeRewardIES["RewardItemCount" .. i], i);
        end
    end
	return height;
end

-- 보상 : 칭호
function QUESTEPISODEREWARD_MAKE_REWARD_HONOR_CTRL(gbBody, x, y, episodeRewardIES)
  local height = 0;
    local RewardHonorPoint = TryGetProp(episodeRewardIES, "RewardHonorPoint");
    if RewardHonorPoint == nil then
        return height;
    end

	if RewardHonorPoint ~= "None" then
        local honor_name, point_value = string.match(RewardHonorPoint,'(.+)[/](.+)')
        if honor_name ~= nil then
            
            local titleWidth = gbBody:GetWidth() * 0.2;
            local valueWidth = gbBody:GetWidth() - titleWidth - 30 ;

            local _height = height;
           QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x, y + _height, titleWidth ,20, "reward_Honor_text",  ClMsg("Episode_Reward_Title_Honor"));

            local txt = GET_HONOR_TAG_TXT(honor_name, point_value ,{ noTitle = 1, color = "{#FFFF00}", font = "{s20}{ol}"});
            height = height +QUESTDETAIL_BOX_CREATE_RICHTEXT(gbBody, x + titleWidth + 10, y + _height, valueWidth , 20, "reward_Honor_value", txt,  {text_align = { horz = "right", vert = "center" }});
	    end
	end

	return height;
end

function CLICK_EPISODE_REWARD_BTN(parent,ctrl, rewardClassName ,argNum)

    local pcObj = GetMyPCObject();
	local result = SCR_EPISODE_CHECK(pcObj, rewardClassName)
	if result == "Reward" then
        pc.ReqExecuteTx("SCR_TX_EPISODE_REWARD", rewardClassName);	 
    end
end

-- 태그 텍스트 컨트롤
function QUESTEPISODEREWARD_MAKE_ITEM_TAG_TEXT_CTRL(baseCtrl, x, y, name, itemName, itemCount, index, prop) 

    -- itemCount가 존재해야하고 Vis가 아니어야함.
    if itemCount == nil or tonumber(itemCount) < 0 or itemName == 'Vis' then
        return
    end

	local cls = GetClass("Item", itemName);
	if cls == nil then
		return 0;
	end

	local height = 0;
	local icon = GET_ITEM_ICON_IMAGE(cls);
	local chIndex = index;
	
    while 1 do
        local check = GET_CHILD(baseCtrl, name .. chIndex);
        if check ~= nil then
            chIndex = chIndex + 1
        else
            break
        end
	end

	local ctrlSet = baseCtrl:CreateOrGetControlSet('episodequest_reward', name .. chIndex, x, y);
	tolua.cast(ctrlSet, "ui::CControlSet");
	ctrlSet:SetValue(chIndex);
	ctrlSet:SetStretch(1);
    ctrlSet:Resize(baseCtrl:GetWidth() - 20, ctrlSet:GetHeight());
    
    local itemCls = GetClass("Item", itemName);
	local slot = GET_CHILD(ctrlSet, "slot", "ui::CSlot");
    SET_SLOT_IMG(slot, icon);
    
    local itemNameGb = GET_CHILD_RECURSIVELY(ctrlSet, "nameGb");
    local itemNameCtrl = GET_CHILD_RECURSIVELY(ctrlSet, "ItemName");
    tolua.cast(itemNameCtrl, "ui::CRichText");
    local itemCountGb = GET_CHILD_RECURSIVELY(ctrlSet, "countGb");
    local ItemCountCtrl = GET_CHILD_RECURSIVELY(ctrlSet, "ItemCount");
    tolua.cast(ItemCountCtrl, "ui::CRichText");

	local itemText = ScpArgMsg("{Auto_1}ItemName","Auto_1", itemCls.Name);
    local itemCount =ScpArgMsg("{Auto_1}NeedCount","Auto_1",GetCommaedText(itemCount));
    
    itemNameCtrl:SetText(itemText);
    ItemCountCtrl:SetText(itemCount);
    
    local lineCount = itemNameCtrl:GetLineCount();
    if lineCount >= 2 then
        local org_height = itemNameGb:GetOriginalHeight();
        local new_height = org_height * lineCount + 10;
        itemNameGb:Resize(itemNameGb:GetWidth(), new_height);
        itemCountGb:Resize(itemCountGb:GetWidth(), new_height);

        if itemNameGb:GetHeight() >= ctrlSet:GetHeight() then
            ctrlSet:Resize(ctrlSet:GetWidth(), itemNameGb:GetHeight() + 30);
        end

    end
    
    ctrlSet:SetEnableSelect(1);
	ctrlSet:SetSelectGroupName("QuestRewardList");
	ctrlSet:SetOverSound('button_cursor_over_2');
	SET_ITEM_TOOLTIP_BY_TYPE(ctrlSet, itemCls.ClassID);
	return ctrlSet:GetHeight();
end
