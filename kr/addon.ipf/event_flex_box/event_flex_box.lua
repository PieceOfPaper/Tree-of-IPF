function EVENT_FLEX_BOX_ON_INIT(addon, frame)
    addon:RegisterMsg("EVENT_FLEX_BOX_STATE_INIT", "EVENT_FLEX_BOX_STATE_INIT");    
    addon:RegisterMsg("EVENT_FLEX_BOX_REWARD_UPDATE", "EVENT_FLEX_BOX_REWARD_UPDATE");
    addon:RegisterMsg("EVENT_FLEX_BOX_ACCRUE_REWARD_UPDATE", "EVENT_FLEX_BOX_ACCRUE_REWARD_UPDATE");
    
    addon:RegisterMsg("EVENT_FLEX_BOX_REWARD_GET_SUCCESS", "EVENT_FLEX_BOX_REWARD_GET_SUCCESS");
end

function EVENT_FLEX_BOX_OPEN_REQ()
    if ui.CheckHoldedUI() == true then
        return;
    end
    
    control.CustomCommand("REQ_EVENT_FLEX_BOX_STATE_INIT", 0);
end

function EVENT_FLEX_BOX_CLOSE(frame, ctrl)
    if ui.CheckHoldedUI() == true then
        return;
    end
    
    if frame:IsVisible() == 0 then
        return;
    end

    local listframe = ui.GetFrame("event_flex_box_reward_list");
    if listframe:IsVisible() == 1 then
        listframe:ShowWindow(0);
    end

    frame:ShowWindow(0);
end

function EVENT_FLEX_BOX_STATE_INIT()
	local accObj = GetMyAccountObj();
    local frame = ui.GetFrame("event_flex_box");

    local itemClassName = GET_EVENT_FLEX_BOX_CONSUME_CLASSNAME();
    local itemCls = GetClass("Item", itemClassName);

    local open_btn = GET_CHILD(frame, "open_btn");
    open_btn:SetTextByKey("value", GET_EVENT_FLEX_BOX_TITLE());

    local open_count_text = GET_CHILD(frame, "open_count_text");
    open_count_text:SetTextByKey("cur", TryGetProp(accObj, "EVENT_FLEX_BOX_OPEN_COUNT", 0));
    if GET_EVENT_FLEX_BOX_MAX_OPEN_COUNT() ~= "None" then
        open_count_text:SetTextByKey("max", "/"..GET_EVENT_FLEX_BOX_MAX_OPEN_COUNT());	
    end

    local curCnt = GET_INV_ITEM_COUNT_BY_PROPERTY({{Name = "ClassName", Value = itemClassName}}, false);
    
    local main_text = GET_CHILD(frame, "main_text");
    main_text:SetTextByKey("value", itemCls.Name);

    local tooltipText = ScpArgMsg("event_flex_box_open_btn_tip_text{ITEM}{COUNT}", "ITEM", itemCls.Name, "COUNT", GET_EVENT_FLEX_BOX_CONSUME_COUNT());
    open_btn:SetTextTooltip(tooltipText);

    local item_text = GET_CHILD(frame, "item_text");
    item_text:SetTextByKey("value", itemCls.Name);
    item_text:SetTextByKey("count", curCnt);

    frame:ShowWindow(1);
    
    local listframe = ui.GetFrame("event_flex_box_reward_list");
    listframe:ShowWindow(1);
end

function EVENT_FLEX_BOX_STATE_UPDATE()
    local accObj = GetMyAccountObj();
    
    local frame = ui.GetFrame("event_flex_box");
    local open_count_text = GET_CHILD(frame, "open_count_text");
    open_count_text:SetTextByKey("cur", TryGetProp(accObj, "EVENT_FLEX_BOX_OPEN_COUNT", 0));
    
    local itemClassName = GET_EVENT_FLEX_BOX_CONSUME_CLASSNAME();
    local itemCls = GetClass("Item", itemClassName);
    local curCnt = GET_INV_ITEM_COUNT_BY_PROPERTY({{Name = "ClassName", Value = itemClassName}}, false);

    local item_text = GET_CHILD(frame, "item_text");
    item_text:SetTextByKey("value", itemCls.Name);
    item_text:SetTextByKey("count", curCnt);
end

function EVENT_FLEX_BOX_REWARD_UPDATE(frame, msg, argStr)
    EVENT_FLEX_BOX_REWARD_LIST_UPDATE(argStr);
end

function EVENT_FLEX_BOX_ACCRUE_REWARD_UPDATE(frame)
    EVENT_FLEX_BOX_ACCRUE_LIST_UPDATE();
end

function EVENT_FLEX_BOX_REWARD_LIST_OPEN_BTN_CLICK()
    EVENT_FLEX_BOX_REWARD_LIST_TOGGLE();
end

function EVENT_FLEX_BOX_OPEN_BTN_CLICK(parent, ctrl)
    if ui.CheckHoldedUI() == true then
        return;
    end
    
	ui.SetHoldUI(true);
    ReserveScript("EVENT_FLEX_BOX_UNFREEZE()", 3);
    
    imcSound.PlaySoundEvent(parent:GetUserConfig("BUTTON_CLICK_SOUND"));
    control.CustomCommand("REQ_EVENT_FLEX_BOX_OPEN", 0);
end

function EVENT_FLEX_BOX_UNFREEZE()
    ui.SetHoldUI(false);
end

local PoseTimer = 0;
function EVENT_FLEX_BOX_REWARD_GET_SUCCESS(frame, msg, argStr)
    EVENT_FLEX_BOX_UNFREEZE()

    -- 아이템 획득 이미지
    local strlist = StringSplit(argStr, '/');
    local grade = strlist[1];
    EVENT_FLEX_BOX_REWARD_FULLDARK_UI_OPEN(grade, strlist[2], strlist[3]);

    EVENT_FLEX_BOX_STATE_UPDATE();

    if grade == "SSS" or grade == "SS" or grade == "S" then
        PoseTimer = 4;
    	frame:RunUpdateScript("EVENT_FLEX_BOX_POSE_UNFREEZE", 1, 0, 0, 1);
    end
end

function EVENT_FLEX_BOX_POSE_UNFREEZE()    
    PoseTimer = PoseTimer - 1;
    if PoseTimer <= 0 then
        local handle = session.GetMyHandle();
        movie.PlayAnim(handle, "ATKSTAND", 1.0, 1);
        return 0;
    end

    return 1;
end