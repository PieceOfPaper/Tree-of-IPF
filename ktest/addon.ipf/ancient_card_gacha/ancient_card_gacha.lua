function ANCIENT_CARD_GACHA_ON_INIT(addon, frame)
    addon:RegisterMsg('ANCIENT_CARD_GACHA_START', 'ON_ANCIENT_CARD_GACHA_UPDATE');
    addon:RegisterMsg('ANCIENT_CARD_GACHA_CARD_OPEN', 'ON_ANCIENT_CARD_GACHA_UPDATE');
    addon:RegisterMsg('ANCIENT_CARD_GACHA_CARD_DUMMY_OPEN', 'ON_ANCIENT_CARD_GACHA_UPDATE');
    addon:RegisterMsg('ANCIENT_CARD_GACHA_END', 'ON_ANCIENT_CARD_GACHA_END');
end

function ANCIENT_CARD_GACHA_OPEN(frame)
    ANCIENT_GACHA_LOAD_PACK_ITEM_LIST(frame)
end

function ANCIENT_CARD_GACHA_CLOSE()
    local frame = ui.GetFrame('ancient_card_gacha')
    local on_gacha = frame:GetUserValue("ON_GACHA")
    if on_gacha == 'YES' then
        return
    end
    local cardbg = GET_CHILD_RECURSIVELY(frame,'cardbg')
    for i = 1,5 do
        cardbg:RemoveChild("CARD_"..i)
    end
    ui.CloseFrame('ancient_card_gacha')
end

function ANCIENT_GACHA_SET_CARD_LIST(frame,x,y,rarityStr)
    local rarityList = StringSplit(rarityStr,'/')

    local cardbg = GET_CHILD_RECURSIVELY(frame,'cardbg')
    
    local pic_bg = GET_CHILD_RECURSIVELY(frame,"pic_bg")
    local slot = GET_CHILD_RECURSIVELY(pic_bg,"slot")
    local init_x = slot:GetX() + pic_bg:GetX() + slot:GetWidth()/2
    local init_y = slot:GetY() + pic_bg:GetY() + slot:GetHeight()/2
    for i = 1,5 do
        local ctrlSet = cardbg:CreateControlSet("ancient_card_gacha_slot", "CARD_" .. i, init_x, init_y);
        ctrlSet:EnableHitTest(0)
        ctrlSet:Resize(0,0)
        ctrlSet:SetUserValue("DEST_X",(i-1)*235+450)
        ctrlSet:SetUserValue("DEST_Y",50)
        ctrlSet:SetUserValue("INIT_X",init_x)
        ctrlSet:SetUserValue("INIT_Y",init_y)
        imcSound.PlaySoundEvent("sys_slot_card_whoosh")
        ctrlSet:ReserveScript("ANCIENT_GACHA_SET_CARD_RESERVE", i*i*0.01+0.23,0,"")
        local ancient_card_gbox = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_card_gbox")
        ancient_card_gbox:SetEventScriptArgNumber(ui.LBUTTONDOWN,i)
        local rarity = tonumber(rarityList[i])
        if rarity == nil then
            rarity = 1
        end
        local effectName = "I_screen_card002_mouseover_"..CONVERT_RARITY_TO_EFFECT_STRING(rarity)
        ancient_card_gbox:AddActiveUIEffect(effectName,12,1,"MOUSEON","MOUSEOFF")
    end
    local slot_bg_image = GET_CHILD(slot,"slot_bg_image")
    slot_bg_image:ReserveScript("CLEAR_UI_EFFECT", 10,0,"")
end

function CONVERT_RARITY_TO_EFFECT_STRING(rarity)
    local rarityStrList = {'normal','rare','unique','legend'}
    return rarityStrList[rarity]
end

function CONVERT_RARITY_TO_SOUND_STRING(rarity)
    local rarityStrList = {'normal','magic','unique','legend'}
    return rarityStrList[rarity]
end

function CLEAR_UI_EFFECT(ctrl)
    ctrl:DestroyUICommand(ui.UI_CMD_UIEFFECT_ALWAYS)
end

function ANCIENT_GACHA_SET_CARD_RESERVE(frame)
    frame:RunUpdateScript("ANCIENT_GACHA_CARD_MOVE_ANIM",0.01)
end

function ANCIENT_GACHA_CARD_MOVE_ANIM(frame,elapsedTime)
    local proceed = elapsedTime * 4
    if proceed >= 1 then
        proceed = 1
    end
    local x = tonumber(frame:GetUserValue("DEST_X")) * proceed + tonumber(frame:GetUserValue("INIT_X")) * (1-proceed)
    local y = tonumber(frame:GetUserValue("DEST_Y")) * proceed + tonumber(frame:GetUserValue("INIT_Y")) * (1-proceed)
    local scale =  math.min(1,1 - (450 - x)/450)
    local width = 214 * scale
    local height = 285 * scale
    frame:Resize(x,y,width,height)
    local default_image = GET_CHILD_RECURSIVELY(frame,'default_image')
    default_image:Resize(width,height)
    if proceed == 1 then
        frame:EnableHitTest(1)
        return 0
    end
    return 1
end

function ANCIENT_GACHA_EXECUTE(parent,ctrl,argStr,argNum)
    pc.ReqExecuteTx_NumArgs("SCR_ANCIENT_GACHA_CARD_OPEN", argNum);	 
end

function ANCIENT_GACHA_LOAD_PACK_ITEM_LIST(frame)
    local invItemList = session.GetInvItemList()
    local cardpackList = {}
    FOR_EACH_INVENTORY(invItemList, 
        function(invItemList, invItem, cardpackList)		
            if invItem ~= nil then
                if invItem.isLockState == false then
                    local itemobj = GetIES(invItem:GetObject());
                    if string.find(itemobj.StringArg,'reward_ancient') then
                        cardpackList[#cardpackList+1] = invItem
                    end
                end
            end
        end, false, cardpackList);
    local cardpacklist_bg = GET_CHILD_RECURSIVELY(frame,'cardpacklist_bg')
    cardpacklist_bg:RemoveAllChild()
    for i = 1,#cardpackList do
        local invItem = cardpackList[i]
        local item = GetIES(invItem:GetObject())
        local ctrlSet = cardpacklist_bg:CreateControlSet("ancient_card_gacha_pack_list", "PACK_" .. i, 0, (i-1)*52);
        local ancient_card_slot = ctrlSet:GetChild("ancient_card_slot")
        AUTO_CAST(ctrlSet)
        AUTO_CAST(ancient_card_slot)
        local image = CreateIcon(ancient_card_slot)
        image:SetImage(item.Icon)

        local ancient_card_name = ctrlSet:GetChild("ancient_card_name")
        local font = ctrlSet:GetUserConfig("NORMAL_GRADE_TEXT")
        ancient_card_name:SetTextByKey("name",font..item.Name)
        ancient_card_name:SetTextByKey("count",invItem.count)
        ctrlSet:SetUserValue("ITEM_ID",item.ClassID)
        ctrlSet:SetDragFrame('ancient_gacha_item_drag')
        ctrlSet:SetDragScp("INIT_ANCEINT_GACHA_ITEM_DRAG")
    end
end

function SCR_ANCIENT_CARD_GACHA_OPEN(parent, ctrl, argStr, argNum)
    local zoneName = session.GetMapName();
    if IS_ANCIENT_CARD_UI_ENABLE_MAP(zoneName) == false then
        addon.BroadMsg("NOTICE_Dm_!", ClMsg("ImpossibleInCurrentMap"), 3);
        return
    end
    local frame = parent:GetTopParentFrame()
    local on_gacha = frame:GetUserValue("ON_GACHA")
    if on_gacha == 'YES' then
        return
    end
    local clsID = frame:GetUserValue("LIFTED_ITEM_ID")
    frame:SetUserValue("LIFTED_ITEM_ID","None")
    if tonumber(clsID) == nil then
        return
    end
    local item = session.GetInvItemByType(clsID)
    if item ~= nil and item.isLockState == false then
        local image = CreateIcon(ctrl)
        local itemCls = GetClassByType("Item",clsID)
        local slot_bg_image = GET_CHILD(ctrl,"slot_bg_image")
        slot_bg_image:SetImage(nil)
        image:SetImage(itemCls.Icon)
        slot_bg_image:PlayUIEffect(frame:GetUserConfig("PACK_OPEN_EFFECT"), tonumber(frame:GetUserConfig("PACK_OPEN_EFFECT_SCALE")),"PLAY",true,-12,-10)
        pc.ReqExecuteTx_Item("ANCIENT_GACHA_START", item:GetIESID());
        frame:SetUserValue("ON_GACHA","YES")
        frame:EnableHide(0)
        local cardbg = GET_CHILD_RECURSIVELY(frame,'cardbg')
        for i = 1,5 do
            cardbg:RemoveChild("CARD_"..i)
        end
    end
end

function ON_ANCIENT_CARD_GACHA_UPDATE(frame,msg,argStr,argNum)
    if msg == 'ANCIENT_CARD_GACHA_START' then
        local func = string.format("ON_ANCIENT_CARD_GACHA_START('%s')",argStr)
        ReserveScript(func,1.5)
    elseif msg == 'ANCIENT_CARD_GACHA_CARD_OPEN' then
        ON_ANCIENT_CARD_GACHA_CARD_OPEN(frame,argNum,argStr,true)
    elseif msg == 'ANCIENT_CARD_GACHA_CARD_DUMMY_OPEN' then
        ON_ANCIENT_CARD_GACHA_CARD_OPEN(frame,argNum,argStr,false)
    end
end

function ON_ANCIENT_CARD_GACHA_START(rarityStr)
    local frame = ui.GetFrame('ancient_card_gacha')
    local slot = GET_CHILD_RECURSIVELY(frame,"slot")
    slot:ClearIcon()
    local slot_bg_image = GET_CHILD(slot,"slot_bg_image")
    slot_bg_image:SetImage("socket_slot_bg2")
    ANCIENT_GACHA_SET_CARD_LIST(frame,slot:GetX(),slot:GetY(),rarityStr)
end

function ON_ANCIENT_CARD_GACHA_CARD_OPEN(frame,index,monClassName,isValid)
    local cardbg = GET_CHILD_RECURSIVELY(frame,'cardbg')
    local ctrlSet = cardbg:GetChild('CARD_'..index)
    local default_image = GET_CHILD_RECURSIVELY(ctrlSet,'default_image')
    local ancientCls = GetClass("Ancient_Info",monClassName)
    local rarity = ancientCls.Rarity
    local effectName = "I_screen_card001_open_"..CONVERT_RARITY_TO_EFFECT_STRING(rarity)
    local soundName = "sys_card_button_click_"..CONVERT_RARITY_TO_SOUND_STRING(rarity)
    if isValid == true then
        effectName = effectName.."_s"
    else
        soundName = "sys_card_button_click_normal"
        effectName = effectName.."_0"
    end
    default_image:SetImage(nil)
    local monCls = GetClass("Monster",monClassName)
    imcSound.PlaySoundEvent(soundName)
    ctrlSet:PlayUIEffect(effectName, tonumber(frame:GetUserConfig("CARD_OPEN_EFFECT_SCALE")),"OPEN"..index)
    local ancient_card_gbox = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_card_gbox")
    ancient_card_gbox:EnableHitTest(0)
    ctrlSet:ReserveScript("SET_ANCIENT_CARD_GACHA_RESULT",1,1,monClassName)
end

function SET_ANCIENT_CARD_GACHA_RESULT(ctrlSet,argNum,monClassName)
    local monCls = GetClass("Monster",monClassName)
    local font = "{@st42b}{s16}"
    --slot image
    local slot = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_card_slot")
    AUTO_CAST(slot)
    local icon = CreateIcon(slot);
    local iconName = TryGetProp(monCls, "Icon");
    icon:SetImage(iconName)
    --star drawing
    local starText = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_card_grade")
    local starStr=string.format("{img monster_card_starmark %d %d}", 24, 25)
    
    starText:SetText(starStr)
    --set lv
    local lvText = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_card_lv")
    lvText:SetText(font.."Lv. 1{/}")
    --set lv and name
    local nameText = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_card_name")

    nameText:SetText(font..monCls.Name.."{/}")
    
    --type
    local racetypeDic = {
        Klaida="insect",
        Widling="wild",
        Velnias="devil",
        Forester="plant",
        Paramune="variation",
        None="melee"
    }

    local type1Text = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_card_type1_text")
    type1Text:SetText(font..ScpArgMsg("MonInfo_RaceType_"..monCls.RaceType).."{/}")
    local type1Pic = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_card_type1_pic")
    local type1Icon = CreateIcon(type1Pic)
    type1Icon:SetImage("monster_"..racetypeDic[monCls.RaceType])

    local type2Text = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_card_type2_text")
    type2Text:SetText(font..ScpArgMsg("MonInfo_Attribute_"..monCls.Attribute).."{/}")
    local type2Pic = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_card_type2_pic")
    local type2Icon = CreateIcon(type2Pic)
    type2Icon:SetImage("attribute_"..monCls.Attribute)
    
    local ancientCls = GetClass("Ancient_Info",monCls.ClassName)
    local rarity = ancientCls.Rarity
    --hide
    local background = GET_CHILD_RECURSIVELY(ctrlSet,"ancient_card_background")
    AUTO_CAST(background)
	if rarity == 1 then
		background:SetImage("normal_big_card")
	elseif rarity == 2 then
		background:SetImage("rare_big_card")
	elseif rarity == 3 then
		background:SetImage("unique_big_card")
	elseif rarity == 4 then
		background:SetImage("legend_big_card")
    end
    
    local groupbox = ctrlSet:GetChild("ancient_card_gbox")
    groupbox:SetVisible(1)
end

function ON_ANCIENT_CARD_GACHA_END(frame)
    frame:SetUserValue("ON_GACHA","NO")
    frame:EnableHide(1)
    ui.FlushGachaDelayPacket();
    ANCIENT_GACHA_LOAD_PACK_ITEM_LIST(frame);
    local slot = GET_CHILD_RECURSIVELY(frame,'slot')
    slot:ClearIcon()
end

function SCR_ANCIENT_CARD_GACHA_RESET(parent,ctrl)
    local frame = parent:GetTopParentFrame()
    local on_gacha = frame:GetUserValue("ON_GACHA")
    if on_gacha == 'YES' then
        return
    end
    local cardbg = GET_CHILD_RECURSIVELY(frame,'cardbg')
    for i = 1,5 do
        cardbg:RemoveChild("CARD_"..i)
    end
end