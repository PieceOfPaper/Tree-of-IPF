function ADVENTURE_BOOK_REWARD_ON_INIT(addon, frame)    
end

function ADVENTURE_BOOK_REWARD_OPEN(rewardCategory, curLevel, isOpenByNPC)
    local frame = ui.GetFrame('adventure_book_reward');
    frame:SetUserValue('REWARD_CATEGORY', rewardCategory);

    local pointCls = ADVENTURE_BOOK_REWARD_INIT_TITLE(frame, rewardCategory);
    ADVENTURE_BOOK_REWARD_INIT_LIST(frame, pointCls, curLevel);
    frame:SetUserValue('POINT_CLASS_NAME', pointCls.ClassName);
    frame:SetUserValue('CUR_STEP', curLevel);

    ADVENTURE_BOOK_REWARD_INIT_BUTTON(frame, isOpenByNPC, rewardCategory, curLevel);
    frame:ShowWindow(1);
end

function ADVENTURE_BOOK_REWARD_INIT_TITLE(frame, rewardCategory)
    if rewardCategory == nil or rewardCategory == 'None' then
        return nil;
    end

    local pointClsList, cnt = GetClassList('AdventureBookPoint');
    for i = 0, cnt - 1 do
        local pointCls = GetClassByIndexFromList(pointClsList, i);
        if pointCls.RewardCategory == rewardCategory then
            local titleText = frame:GetChild('titleText');
            titleText:SetTextByKey('category', pointCls.Name);
            return pointCls;     
        end
    end
    return nil;
end

function ADVENTURE_BOOK_REWARD_INIT_LIST(frame, pointCls, curStep)
    local rewardCategory = pointCls.RewardCategory;    
    local preStep = GetMyRewardStep(rewardCategory);
    local totalStep = GetAdventureBookRewardStepCount(rewardCategory);
        
    local ENABLE_LEVEL_STYLE = frame:GetUserConfig('ENABLE_LEVEL_STYLE');
    local ALREADY_GET_SKIN = frame:GetUserConfig('ALREADY_GET_SKIN');
    local REWARD_INTERVAL = tonumber(frame:GetUserConfig('REWARD_INTERVAL'));
    local REWARD_DETAIL_INTERVAL = tonumber(frame:GetUserConfig('REWARD_DETAIL_INTERVAL'));

    local listBox = frame:GetChild('listBox');
    listBox:RemoveAllChild();

    local startIndex = 1;
    local allCheck = GET_CHILD_RECURSIVELY(frame, 'allCheck');
    local exceptPreReward = allCheck:IsChecked();
    if exceptPreReward == 0 then
        startIndex = preStep + 1;
    end
    for i = startIndex, totalStep do
        local rewardItemCount = GetAdventureBookRewardItemTotalCount(rewardCategory, i);
        local achieveClassName, achievePoint = GetAdventureBookRewardAchieve(rewardCategory, i);
        local achieveCls = GetClass('AchievePoint', achieveClassName);
        if rewardItemCount > 0 or achieveCls ~= nil then
            local rewardSet = listBox:CreateOrGetControlSet('adventure_book_reward', 'REWARD_STEP_'..i, 0, 0);        
            rewardSet = AUTO_CAST(rewardSet);
            -- level
            local levelText = rewardSet:GetChild('levelText');
            levelText:SetTextByKey('level', i);        
            if i > preStep and i <= curStep then        
                levelText:SetTextByKey('style', ENABLE_LEVEL_STYLE);
            end

            -- skin
            local bgBox = rewardSet:GetChild('bgBox');
            local isGray = false;
            if i <= preStep then            
                bgBox:SetSkinName(ALREADY_GET_SKIN);
            elseif i > curStep then
                rewardSet:EnableGrayWithText(1);
                rewardSet:SetColorTone('FF444444');
                isGray = true;
            end

            -- stamp
            local stampPic = rewardSet:GetChild('stampPic');
            if i > preStep then
                stampPic:ShowWindow(0);
            end

            -- reward
            local rewardBox = rewardSet:GetChild('rewardBox');
            rewardBox:RemoveAllChild();
              
            for j = 0, rewardItemCount - 1 do
                local itemName, itemCount = GetAdventureBookRewardItem(rewardCategory, i, j);
                local itemCls = GetClass('Item', itemName);
                if itemCls ~= nil then
                    local rewardSet = rewardBox:CreateOrGetControlSet('adventure_book_reward_detail', 'REWARD_ITEM_'..j, 0, 0);
                    local iconPic = GET_CHILD(rewardSet, 'iconPic');
                    local nameText = rewardSet:GetChild('nameText');
                    local countText = rewardSet:GetChild('countText');
                    iconPic:SetImage(itemCls.Icon);
                    nameText:SetText(itemCls.Name);
                    countText:SetTextByKey('count', itemCount);
                    SET_ITEM_TOOLTIP_BY_NAME(iconPic, itemName);

                    if isGray == true then
                        rewardSet:SetColorTone('FF444444');
                    end
                end
            end
            GBOX_AUTO_ALIGN(rewardBox, 0, REWARD_DETAIL_INTERVAL, 0, true, true);

            -- achieve                        
            if achieveCls ~= nil then
                local y = rewardBox:GetHeight() + 5;
                local achieveSet = rewardBox:CreateOrGetControlSet('adventure_book_reward_achieve', 'ACHIEVE', 0, y);
                local achieveText = achieveSet:GetChild('achieveText');                
                achieveText:SetText(achieveCls.Name);
                    
                local addY = 0;     
                if rewardItemCount == 0 then -- 아이템이 없는 경우
                    addY = levelText:GetY() + 2;
                    achieveSet:SetOffset(achieveSet:GetX(), addY);                    
                end
                rewardBox:Resize(rewardBox:GetWidth(), rewardBox:GetHeight() + achieveSet:GetHeight() + addY + 5);
            end

            -- resize
            local width = rewardSet:GetWidth();
            local height = math.max(rewardSet:GetOriginalHeight(), rewardBox:GetY() + rewardBox:GetHeight() + 10);
            bgBox:Resize(width, height);
            rewardSet:Resize(width, height);
        end
    end
    GBOX_AUTO_ALIGN(listBox, 0, REWARD_INTERVAL, 0, true, false);
end

function ADVENTURE_BOOK_REWARD_INIT_BUTTON(frame, isOpenByNPC, rewardCategory, curLevel)
    local reqBtn = frame:GetChild('reqBtn');
    local preLevel = GetMyRewardStep(rewardCategory);
    if isOpenByNPC == 'YES' and preLevel < curLevel then
        reqBtn:SetEnable(1);
    else
        reqBtn:SetEnable(0);
    end
end

function ADVENTURE_BOOK_REQ_REWARD(parent, ctrl)
    local topFrame = parent:GetTopParentFrame();
    local rewardCategory = topFrame:GetUserValue('REWARD_CATEGORY');
    if rewardCategory == 'None' then
        return;
    end
    ReqAdventureBookReward(rewardCategory);
    ui.CloseFrame('adventure_book_reward');
end

function ADVENTURE_BOOK_REWARD_FILTER(frame, checkBox)
    local pointCls = GetClass('AdventureBookPoint', frame:GetUserValue('POINT_CLASS_NAME'));
    local curStep = frame:GetUserIValue('CUR_STEP');
    ADVENTURE_BOOK_REWARD_INIT_LIST(frame, pointCls, curStep);
end