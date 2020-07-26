function EVENT_FLEX_BOX_REWARD_LIST_ON_INIT(addon, frame)

end

function EVENT_FLEX_BOX_REWARD_LIST_TOGGLE()
    local frame = ui.GetFrame("event_flex_box_reward_list");
    if frame:IsVisible() == 1 then
        frame:ShowWindow(0);
        return;
    end

    frame:ShowWindow(1);
end

function EVENT_FLEX_BOX_REWARD_LIST_CLOSE(frame)    
    frame:ShowWindow(0);
end

function EVENT_FLEX_BOX_REWARD_LIST_INIT(frame)
	local itemlist = GET_CHILD_RECURSIVELY(frame, "itemlist");
    itemlist:RemoveAllChild();
    
    local titleCtrl = GET_CHILD_RECURSIVELY(frame, "title");
    titleCtrl:SetTextByKey("value", "");
end

function EVENT_FLEX_BOX_REWARD_LIST_UPDATE(argStr)
    local frame = ui.GetFrame("event_flex_box_reward_list");
    
    EVENT_FLEX_BOX_REWARD_LIST_INIT(frame);
    
    local itemlist = GET_CHILD_RECURSIVELY(frame, "itemlist");
    local gradeinfo_text = GET_CHILD_RECURSIVELY(frame, "gradeinfo_text");

    local RewardItemStr = StringSplit(argStr, ';');
	for i = 1, #RewardItemStr do
		local itemStrlist = StringSplit(RewardItemStr[i], '/');
        
        local itemGrade = itemStrlist[1];
        local itemClassName = itemStrlist[2];
        local itemCount = itemStrlist[3];
        EVENT_FLEX_BOX_REWARD_LIST_CREATE(itemlist, i, itemClassName, itemCount, itemGrade);

        local mainframe = ui.GetFrame("event_flex_box");    
        if i == 1 then
            gradeinfo_text:SetTextByKey("startgrade", itemGrade);

            local start_grade_pic = GET_CHILD_RECURSIVELY(mainframe, "start_grade_pic");
            start_grade_pic:SetImage(string.lower(itemGrade).."_item_rank");
        elseif i == #RewardItemStr then
            gradeinfo_text:SetTextByKey("endgrade", itemGrade);
            
            local end_grade_pic = GET_CHILD_RECURSIVELY(mainframe, "end_grade_pic");
            end_grade_pic:SetImage(string.lower(itemGrade).."_item_rank");
        end
    end
    
    GBOX_AUTO_ALIGN(itemlist, 0, -5, 0, true, false);
end

function EVENT_FLEX_BOX_REWARD_LIST_CREATE(groupbox, index, itemClassName, itemCount, itemGrade, accCount, isScroll)
    local itemCls = GetClass("Item", itemClassName);
    if itemCls ~= nil then
        local ctrl = groupbox:CreateOrGetControlSet("reward_item_list", "LIST_"..index, 0, 0);
        if isScroll == false then
            ctrl:Resize(570, 90);
        end
        
        local icon = GET_CHILD(ctrl, "icon");
        icon:SetImage(itemCls.Icon);
        SET_ITEM_TOOLTIP_BY_NAME(icon, itemCls.ClassName);
        
        local name = GET_CHILD(ctrl, "name");
        name:SetTextByKey("name", itemCls.Name);

        local count = GET_CHILD(ctrl, "count");
        count:SetTextByKey("count", itemCount);
        
        local gradectrl = GET_CHILD(ctrl, "grade");
        if itemGrade ~= nil then
            gradectrl:SetImage(string.lower(itemGrade).."_item_rank");
        end

        local text = GET_CHILD(ctrl, "text");
        if accCount ~= nil then
            text:SetTextByKey("value", accCount..ClMsg("NumberOfThings"));
        end
    end
end

function EVENT_FLEX_BOX_ACCRUE_LIST_UPDATE()
    local frame = ui.GetFrame("event_flex_box_reward_list");

	local accruelist = GET_CHILD_RECURSIVELY(frame, "accruelist");
    accruelist:RemoveAllChild();

    local table = GET_EVENT_FLEX_BOX_ACCRUE_REWARD_TABLE();
    local isScroll = true;
    if #table < 7 then
        isScroll = false;
    end

    for i = 1, #table do
        local rewardlist = StringSplit(table[i], "/");

        local accCount = rewardlist[1];
        local className = rewardlist[2];
        local count = rewardlist[3];
        
        EVENT_FLEX_BOX_REWARD_LIST_CREATE(accruelist, i, className, count, nil, accCount, isScroll);
    end
    
    GBOX_AUTO_ALIGN(accruelist, 0, -5, 0, true, false);
end