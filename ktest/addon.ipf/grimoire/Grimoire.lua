
function GRIMOIRE_ON_INIT(addon, frame)
    addon:RegisterOpenOnlyMsg("UPDATE_GRIMOIRE_UI", "GRIMOIRE_MSG");
    addon:RegisterMsg("DO_OPEN_GRIMOIRE_UI", "GRIMOIRE_MSG");
    addon:RegisterMsg("SORCERER_OBEY_BUFF", "GRIMOIRE_OBEY_BUFF");

    frame:SetUserValue('OBEY_BUFF_VALUE', 0);
end

function GRIMOIRE_MSG(frame, msg, argStr, argNum)

    if msg == "UPDATE_GRIMOIRE_UI" then
        UPDATE_GRIMOIRE_UI(frame)       
    elseif msg == "DO_GRIMOIRE_UI" then
        frame:ShowWindow(1);
    end
end

function UPDATE_GRIMOIRE_UI(frame)

    local etc_pc = GetMyEtcObject();

    local MAX_CARD_COUNT = 2; 

    local gbox = GET_CHILD(frame,'grimoireGbox',"ui::CGroupBox")
    for i = 1, MAX_CARD_COUNT do
        local nowcard_classname = 'Sorcerer_bosscardGUID'..i
        local bosscardid = etc_pc[nowcard_classname]
        local invitem  = nil;
        if "None" ~= bosscardid then
             invitem = session.GetInvItemByGuid(bosscardid);
        end
    
        local slotname = 'Sorcerer_bosscard'..i
        local slotchild = GET_CHILD(gbox, slotname,"ui::CSlot");
        if nil ~= invitem then
            local itemobj = GetIES(invitem:GetObject());
            if itemobj ~= nil then
                SET_SLOT_ICON(slotchild, itemobj.TooltipImage);         
                SET_ITEM_TOOLTIP_BY_OBJ(slotchild:GetIcon(), invitem);
                SET_CARD_STATE(frame, itemobj, i);
            else
                SET_SLOT_ICON(slotchild, 'test_card_slot_point');           
            end

            local icon = slotchild:GetIcon();
            if nil ~= icon then
                icon:SetIESID(invitem:GetIESID());
            end
        else
            slotchild:ClearIcon();
            GRIMOIRE_STATE_UI_RESET(frame, i)
            if "None" ~= bosscardid then
                GRIMOIRE_CARD_UI_RESET(gbox, slotchild, bosscardid);
            end
        end
    end
end

function GRIMOIRE_CARD_UI_RESET(parent, ctrl, bosscardid)
    local frame = parent:GetTopParentFrame();
    local slot = tolua.cast(ctrl, "ui::CSlot");
    local icon, iconInfo, itemIES = nil, nil, nil;
    icon = slot:GetIcon();
    if nil ~= icon then
         iconInfo = icon:GetInfo();
    end

    if nil ~= iconInfo then
        itemIES = iconInfo:GetIESID();
    end
    session.ResetItemList();

    if nil == itemIES and nil ~= bosscardid then
         itemIES = bosscardid
    end

    if nil~= itemIES then
        session.AddItemID(itemIES);
    end

    SET_GRI_CARD_COMMIT(slot:GetName(),"UnEquip")
end

function GRIMOIRE_STATE_TEXT_RESET(descriptGbox)
    -- 체력
    local myHp = GET_CHILD(descriptGbox,'my_hp',"ui::CRichText")
    myHp:SetTextByKey("value", 0);
    
    -- 물리 공격력
    local richText = GET_CHILD(descriptGbox,'my_attack',"ui::CRichText")
    richText:SetTextByKey("value", 0);

    -- 마법 공격력
    richText = GET_CHILD(descriptGbox,'my_Mattack',"ui::CRichText")
    richText:SetTextByKey("value", 0);

    -- 방어력
    richText = GET_CHILD(descriptGbox,'my_defen',"ui::CRichText")
    richText:SetTextByKey("value", 0);
    

    -- 마법 방어력
    richText = GET_CHILD(descriptGbox,'my_Mdefen',"ui::CRichText")
    richText:SetTextByKey("value", 0);

    ------- 스텟정보
    -- 힘
    richText = GET_CHILD(descriptGbox,'my_power',"ui::CRichText")
    richText:SetTextByKey("value", 0);
    
    -- 체력
    richText = GET_CHILD(descriptGbox,'my_con',"ui::CRichText")
    richText:SetTextByKey("value", 0);

    -- 지능
    richText = GET_CHILD(descriptGbox,'my_int',"ui::CRichText")
    richText:SetTextByKey("value", 0);

    -- 민첩
    richText = GET_CHILD(descriptGbox,'my_dex',"ui::CRichText")
    richText:SetTextByKey("value", 0)

    -- 정신
    richText = GET_CHILD(descriptGbox,'my_mna',"ui::CRichText")
    richText:SetTextByKey("value", 0);
end

function GRIMOIRE_STATE_UI_RESET(frame, i)
    local grimoireGbox = GET_CHILD(frame,'grimoireGbox',"ui::CGroupBox")
    if nil == grimoireGbox then
        return;
    end

    local descriptGbox = GET_CHILD(grimoireGbox,'descriptGbox',"ui::CGroupBox")
    if nil == descriptGbox then
        return;
    end

    if 1 == i then -- 메인카드
        local gbox = GET_CHILD(descriptGbox,'my_card',"ui::CRichText")
        if nil ~= gbox then
            gbox:SetTextByKey("actorcard","");
        end
    else
        local gbox = GET_CHILD(descriptGbox,'my_assist_card',"ui::CRichText")
        if nil ~= gbox then
            gbox:SetTextByKey("actorassistcard","");
        end

        return;
    end

    GRIMOIRE_STATE_TEXT_RESET(descriptGbox);
end

function SET_CARD_STATE(frame, bosscardcls, i)
    local grimoireGbox = GET_CHILD(frame,'grimoireGbox',"ui::CGroupBox")
    if nil == grimoireGbox then
        return;
    end
    local descriptGbox = GET_CHILD(grimoireGbox,'descriptGbox',"ui::CGroupBox")
    if nil == descriptGbox then
        return;
    end

    if 1 == i then -- 메인카드
        local gbox = GET_CHILD(descriptGbox,'my_card',"ui::CRichText")
        if nil ~= gbox then
            gbox:SetTextByKey("actorcard",bosscardcls.Name);
        end
    else
        local gbox = GET_CHILD(descriptGbox,'my_assist_card',"ui::CRichText")
        if nil ~= gbox then
            gbox:SetTextByKey("actorassistcard",bosscardcls.Name);
        end

        return;
    end

    GRIMOIRE_STATE_TEXT_RESET(descriptGbox);

    local skl = session.GetSkillByName('Sorcerer_Summoning');
    if nil == skl then
        return;
    end

    local bossMonID = bosscardcls.NumberArg1;
    local monCls = GetClassByType("Monster", bossMonID);
    if nil == monCls then
        return;
    end

    -- 가상몹을 생성합시다.
    local tempObj = CreateGCIES("Monster", monCls.ClassName);
    if nil == tempObj then
        return;
    end

    CLIENT_SORCERER_SUMMONING_MON(tempObj, GetMyPCObject(), GetIES(skl:GetObject()), bosscardcls);
    
    -- 체력
    local myHp = GET_CHILD(descriptGbox,'my_hp',"ui::CRichText")
    local hp = math.floor(SCR_Get_MON_MHP(tempObj));
    myHp:SetTextByKey("value", hp);
    
    local addValue = frame:GetUserIValue('OBEY_BUFF_VALUE');

    -- 물리 공격력
    local richText = GET_CHILD(descriptGbox,'my_attack',"ui::CRichText")
    richText:SetTextByKey("value", math.floor((SCR_Get_MON_MINPATK(tempObj) + SCR_Get_MON_MAXPATK(tempObj)) / 2 + addValue));

    -- 마법 공격력
    richText = GET_CHILD(descriptGbox,'my_Mattack',"ui::CRichText")
    richText:SetTextByKey("value", math.floor((SCR_Get_MON_MINMATK(tempObj) + SCR_Get_MON_MAXMATK(tempObj)) / 2 + addValue));

    -- 방어력
    richText = GET_CHILD(descriptGbox,'my_defen',"ui::CRichText")
    richText:SetTextByKey("value", math.floor(SCR_Get_MON_DEF(tempObj)));
    
    -- 마법 방어력
    richText = GET_CHILD(descriptGbox,'my_Mdefen',"ui::CRichText")
    richText:SetTextByKey("value", math.floor(SCR_Get_MON_MDEF(tempObj)));
    
    ------- 스텟정보

    -- 힘
    richText = GET_CHILD(descriptGbox,'my_power',"ui::CRichText")
    richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "STR"));
    
    -- 체력
    richText = GET_CHILD(descriptGbox,'my_con',"ui::CRichText")
     -- 기본적으로 GET_MON_STAT을 쓰지만 체력은 따로해달라는 평직씨의 요청
--  local con = math.floor(GET_MON_STAT_CON(tempObj, tempObj.Lv, "CON"));
--  richText:SetTextByKey("value", con);
    richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "CON"));
    

    -- 지능
    richText = GET_CHILD(descriptGbox,'my_int',"ui::CRichText")
    richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "INT"));

    -- 민첩
    richText = GET_CHILD(descriptGbox,'my_dex',"ui::CRichText")
    richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "DEX"));

    -- 정신
    richText = GET_CHILD(descriptGbox,'my_mna',"ui::CRichText")
    richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "MNA"));

    -- 생성한 가상몹을 지워야져
    DestroyIES(tempObj);
end

function GRIMOIRE_SLOT_DROP(frame, control, argStr, argNum) 
    local liftIcon          = ui.GetLiftIcon();
    local iconParentFrame   = liftIcon:GetTopParentFrame();
    local slot              = tolua.cast(control, 'ui::CSlot');
    local iconInfo          = liftIcon:GetInfo();
    local invenItemInfo = session.GetInvItem(iconInfo.ext);

    if nil == invenItemInfo then
        return;
    end

    local tempobj = invenItemInfo:GetObject()
    local cardobj = GetIES(invenItemInfo:GetObject());

    if cardobj.GroupName ~= 'Card' then
        ui.SysMsg(ClMsg("PutOnlyCardItem"));
        return 
    end

    local cardItemCls = GetClassByType("Item", cardobj.ClassID);
    if nil == cardItemCls then
        ui.SysMsg(ClMsg("PutOnlyCardItem"));
        return;
    end
    local monCls = GetClassByType("Monster", cardItemCls.NumberArg1);
    if monCls == nil then
        ui.SysMsg(ClMsg("CheckCardType"));
        return;
    end

    if monCls.RaceType ~= 'Velnias' then
        ui.SysMsg(ClMsg("CheckCardType"));
        return;
    end

    local etc_pc = GetMyEtcObject();
    local MAX_CARD_COUNT = 2; 
    local itemIES = GetIESID(cardobj);
    for i = 1, MAX_CARD_COUNT do
        local bosscardslotname = 'Sorcerer_bosscardGUID'..i
        if etc_pc[bosscardslotname] == itemIES then
            ui.SysMsg(ClMsg("AlreadRegSameCard"));
            return;
        end
    end
    

    session.ResetItemList();
    session.AddItemID(iconInfo:GetIESID());
    SET_GRI_CARD_COMMIT(slot:GetName(), "Equip")

end

function SET_GRI_CARD_COMMIT(slotname, type)

    local resultlist = session.GetItemIDList();
    local slotnumber = GET_GRI_SLOT_NUMBER(slotname)
    local iType = 1;
    if "UnEquip" == type then
        iType = 0;
    end
    local argStr = string.format("%s %s", tostring(slotnumber), iType);
    item.DialogTransaction("SET_SORCERER_CARD", resultlist, argStr);

end

function GET_GRI_SLOT_NUMBER(slotname)
    if slotname == 'Sorcerer_bosscard1' then
        return 1;
    elseif slotname == 'Sorcerer_bosscard2' then
        return 2;
    end

    return 0;
end

function GRIMOIRE_FRAME_OPEN(frame)
    UPDATE_GRIMOIRE_UI(frame)
end

function GRIMOIRE_FRAME_CLOSE(frame)
end

function GRIMOIRE_OBEY_BUFF(frame, msg, argStr, argNum)
    frame:SetUserValue('OBEY_BUFF_VALUE', argNum);
    UPDATE_GRIMOIRE_UI(frame);
end