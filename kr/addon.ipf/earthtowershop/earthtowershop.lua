local s_earth_shop_frame_name = ""
local s_earth_shop_parent_name = ""
local g_earth_shop_control_name = ""

function EARTHTOWERSHOP_ON_INIT(addon, frame)
    addon:RegisterMsg('EARTHTOWERSHOP_BUY_ITEM', 'EARTHTOWERSHOP_BUY_ITEM');
    addon:RegisterMsg('EARTHTOWERSHOP_BUY_ITEM_RESULT', 'EARTHTOWERSHOP_BUY_ITEM_RESULT');
end

function EARTHTOWERSHOP_BUY_ITEM_RESULT(frame, msg, argStr, argNum)
    local token = StringSplit(argStr, '/')
    ui.SysMsg(ScpArgMsg("RESULT_MISC_PVP_MINE2", "count1", GET_COMMAED_STRING(token[1]), "count2", GET_COMMAED_STRING(token[2])));
    local propertyRemain = GET_CHILD_RECURSIVELY(frame,"propertyRemain")
    local itemCls = GetClass('Item','misc_pvp_mine2')
    propertyRemain:SetTextByKey('itemName',itemCls.Name)
    local aObj = GetMyAccountObj()
    local count = TryGetProp(aObj,"MISC_PVP_MINE2", '0')
    if count == 'None' then
        count = '0'
    end
    propertyRemain:SetTextByKey('itemCount', GET_COMMAED_STRING(count))
end

function EARTHTOWERSHOP_BUY_ITEM(frame, msg, itemName, itemCount)    
	local controlFrame = ui.GetFrame(s_earth_shop_frame_name);
	if controlFrame == nil then
		return
	end

    local parent = GET_CHILD_RECURSIVELY(controlFrame, s_earth_shop_parent_name);
	local control = GET_CHILD_RECURSIVELY(parent, g_earth_shop_control_name);
	if control == nil or parent == nil then
		return
	end

    local ctrlset = parent;
    local recipecls = GetClass('ItemTradeShop', ctrlset:GetName());
    local exchangeCountText = GET_CHILD(ctrlset, "exchangeCount");
	if recipecls.NeedProperty ~= 'None' then
		local sObj = GetSessionObject(GetMyPCObject(), "ssn_shop");
		local sCount = TryGetProp(sObj, recipecls.NeedProperty); 
		local cntText = string.format("%d", sCount).. ScpArgMsg("Excnaged_Count_Remind");
		local tradeBtn = GET_CHILD(ctrlset, "tradeBtn");
		if sCount <= 0 then
			cntText = ScpArgMsg("Excnaged_No_Enough");
            tradeBtn:SetColorTone("FF444444");
            tradeBtn:SetEnable(0);
		end;
		exchangeCountText:SetTextByKey("value", cntText);
	end;
	
	if recipecls.AccountNeedProperty ~= 'None' then
	    local aObj = GetMyAccountObj()
        local sCount = TryGetProp(aObj, recipecls.AccountNeedProperty); 
--        --EVENT_1906_SUMMER_FESTA
--        local time = geTime.GetServerSystemTime()
--        time = time.wYear..time.wMonth..time.wDay
--        if time < '2019725' then
--            if recipecls.ClassName == 'EventTotalShop1906_25' or recipecls.ClassName == 'EventTotalShop1906_26' then
--                sCount = sCount - 2
--            end
--        end
		local cntText = ScpArgMsg("Excnaged_AccountCount_Remind","COUNT",string.format("%d", sCount))
        local tradeBtn = GET_CHILD(ctrlset, "tradeBtn");
        if sCount <= 0 then
            cntText = ScpArgMsg("Excnaged_No_Enough");
            tradeBtn:SetColorTone("FF444444");
            tradeBtn:SetEnable(0);
        end;
        exchangeCountText:SetTextByKey("value", cntText);
    end

end
function REQ_EARTH_TOWER_SHOP_OPEN()

    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'EarthTower');
    ui.OpenFrame('earthtowershop');
end

function REQ_EARTH_TOWER2_SHOP_OPEN()

    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'EarthTower2');
    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_ITEM_SHOP_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'EventShop');
    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_ITEM_SHOP2_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'EventShop2');
    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_ITEM_SHOP3_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'EventShop3');
    ui.OpenFrame('earthtowershop');
end

function REQ_KEY_QUEST_TRADE_HETHRAN_LV1_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'KeyQuestShop1');
    ui.OpenFrame('earthtowershop');
end

function REQ_KEY_QUEST_TRADE_HETHRAN_LV2_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'KeyQuestShop2');
    ui.OpenFrame('earthtowershop');
end

function HALLOWEEN_EVENT_ITEM_SHOP_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'HALLOWEEN');
    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_ITEM_SHOP8_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'EventShop8');
    ui.OpenFrame('earthtowershop');
end

function REQ_PVP_MINE_SHOP_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'PVPMine');
    ui.OpenFrame('earthtowershop');
end

function REQ_MASSIVE_CONTENTS_SHOP1_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'MCShop1');
    ui.OpenFrame('earthtowershop');
end

function REQ_SoloDungeon_Bernice_SHOP_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'Bernice');
    ui.OpenFrame('earthtowershop');
end

function REQ_DAILY_REWARD_SHOP_1_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'DailyRewardShop');
    ui.OpenFrame('earthtowershop');
end

function REQ_NEW_CHAR_SHOP_1_OPEN()
--    local frame = ui.GetFrame("earthtowershop");
--    frame:SetUserValue("SHOP_TYPE", 'NewChar');
--    ui.OpenFrame('earthtowershop');
end

function REQ_VIVID_CITY2_SHOP_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'VividCity2_Shop');
    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT1906_TOTAL_SHOP_OPEN()
--    local frame = ui.GetFrame("earthtowershop");
--    frame:SetUserValue("SHOP_TYPE", 'EventTotalShop1906');
--    ui.OpenFrame('earthtowershop');
end


function REQ_EVENT1907_ICE_SHOP_OPEN()
--    local frame = ui.GetFrame("earthtowershop");
--    frame:SetUserValue("SHOP_TYPE", 'EventIceShop1907');
--    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_1909_MINI_FULLMOON_SHOP_OPEN()
--    local frame = ui.GetFrame("earthtowershop");
--    frame:SetUserValue("SHOP_TYPE", 'EventMiniMoonShop1909');
--    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_1910_HALLOWEEN_SHOP_OPEN()
        -- local frame = ui.GetFrame("earthtowershop");
        -- frame:SetUserValue("SHOP_TYPE", 'HalloweenShop');
        -- ui.OpenFrame('earthtowershop');
end

function REQ_EVENT1912_4TH_SHOP_OPEN()
--    local frame = ui.GetFrame("earthtowershop");
--    frame:SetUserValue("SHOP_TYPE", 'Event4thShop1912');
--    ui.OpenFrame('earthtowershop');
end

function REQ_SELL_TPSHOP1912_SHOP_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'Sell_TPShop1912');
    ui.OpenFrame('earthtowershop');
end

function REQ_BUY_TPSHOP1912_SHOP_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'Buy_TPShop1912');
    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT1912_GREWUP_SHOP_OPEN()
--    local frame = ui.GetFrame("earthtowershop");
--    frame:SetUserValue("SHOP_TYPE", 'GrewUpShop');
--    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_2001_NEWYEAR_SHOP_OPEN()
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", 'NewYearShop');
    ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_2002_FISHING_SHOP_OPEN()
    -- local frame = ui.GetFrame("earthtowershop");
    -- frame:SetUserValue("SHOP_TYPE", 'FishingShop2002');
    -- ui.OpenFrame('earthtowershop');
end

function REQ_EVENT_SHOP_OPEN_COMMON(shopType)
    local frame = ui.GetFrame("earthtowershop");
    frame:SetUserValue("SHOP_TYPE", shopType);
    ui.OpenFrame('earthtowershop');
end

function EARTH_TOWER_SHOP_OPEN(frame)
    if frame == nil then
        frame = ui.GetFrame("earthtowershop")
    end
    
    local shopType = frame:GetUserValue("SHOP_TYPE");
    if shopType == 'None' then
        shopType = "EarthTower";
        frame:SetUserValue("SHOP_TYPE", shopType);
    end

    EARTH_TOWER_INIT(frame, shopType)

    local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
    bg:ShowWindow(1);

    local article = GET_CHILD(frame, 'recipe', "ui::CGroupBox");
    if article ~= nil then
        article:ShowWindow(0)
    end

    local bg = GET_CHILD(frame, "bg", "ui::CGroupBox");
    bg:ShowWindow(0);
    
    local group = GET_CHILD(frame, 'Recipe', 'ui::CGroupBox')
    group:ShowWindow(1)
    imcSound.PlaySoundEvent('button_click_3');

    session.ResetItemList();
end

function EARTH_TOWER_SHOP_OPTION(frame, ctrl)
    session.ResetItemList();
    frame = frame:GetTopParentFrame();
    local shopType = frame:GetUserValue("SHOP_TYPE");
    EARTH_TOWER_INIT(frame, shopType);
end

function EARTH_TOWER_INIT(frame, shopType)

    INVENTORY_SET_CUSTOM_RBTNDOWN("None");
    RESET_INVENTORY_ICON();
    local propertyRemain = GET_CHILD_RECURSIVELY(frame,"propertyRemain")
    propertyRemain:ShowWindow(0)

    local title = GET_CHILD(frame, 'title', 'ui::CRichText')
    local close = GET_CHILD(frame, 'close');
    if shopType == 'EarthTower' or shopType == 'EarthTower2' then
        title:SetText('{@st43}'..ScpArgMsg("EarthTowerShop"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EarthTowerShop")));
    elseif shopType == 'EventShop' or shopType == 'EventShop2' or shopType == 'EventShop3' then
        title:SetText('{@st43}'..ScpArgMsg("EventShop"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EventShop")));
    elseif shopType == 'KeyQuestShop1' then
        title:SetText('{@st43}'..ScpArgMsg("KeyQuestShopTitle1"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("KeyQuestShopTitle1")));
    elseif shopType == 'KeyQuestShop2' then
        title:SetText('{@st43}'..ScpArgMsg("KeyQuestShopTitle2"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("KeyQuestShopTitle2")));
    elseif shopType == 'HALLOWEEN' then
        title:SetText('{@st43}'..ScpArgMsg("EVENT_HALLOWEEN_SHOP_NAME"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EVENT_HALLOWEEN_SHOP_NAME")));
    elseif shopType == 'PVPMine' then
        title:SetText('{@st43}'..ScpArgMsg("pvp_mine_shop_name"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("pvp_mine_shop_name")));
        --property setting
        propertyRemain:ShowWindow(1)
        local itemCls = GetClass('Item','misc_pvp_mine2')
        propertyRemain:SetTextByKey('itemName',itemCls.Name)
        local aObj = GetMyAccountObj()
        local count = TryGetProp(aObj,"MISC_PVP_MINE2", '0')
        if count == 'None' then
            count = '0'
        end
        propertyRemain:SetTextByKey('itemCount', GET_COMMAED_STRING(count))
    elseif shopType == 'MCShop1' then
        title:SetText('{@st43}'..ScpArgMsg("MASSIVE_CONTENTS_SHOP_NAME"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("MASSIVE_CONTENTS_SHOP_NAME")));
    elseif shopType == 'EventShop8' then
        local taltPropCls = GetClassByType('Anchor_c_Klaipe', 5187);
        title:SetText('{@st43}'..taltPropCls.Name);
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', taltPropCls.Name));
    elseif shopType == 'DailyRewardShop' then
        title:SetText('{@st43}'..ScpArgMsg("DAILY_REWARD_SHOP_1"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("DAILY_REWARD_SHOP_1")));
    elseif shopType == 'Bernice' then
        title:SetText('{@st43}'..ScpArgMsg("SoloDungeonSelectMsg_5"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("SoloDungeonSelectMsg_5")));
    elseif shopType == 'NewChar' then
        title:SetText('{@st43}'..ScpArgMsg("NEW_CHAR_SHOP_1"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("NEW_CHAR_SHOP_1")));
    elseif shopType == 'VividCity2_Shop' then
        title:SetText('{@st43}'..ScpArgMsg("EventShop"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EventShop")));
    elseif shopType == 'EventTotalShop1906' then
        title:SetText('{@st43}'..ScpArgMsg("EventShop"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EventShop")));
    elseif shopType == 'EventIceShop1907' then
--        title:SetText('{@st43}'..ScpArgMsg("EventShop"));
--        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EVENT_1907_ICESHOP_TITLE_NAME_1")));
    elseif shopType == 'EventMiniMoonShop1909' then
--        title:SetText('{@st43}'..ScpArgMsg("EventMiniMoonShop1909_TITLE_NAME_1"));
--        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EventMiniMoonShop1909_TITLE_NAME_1")));
    elseif shopType == 'HalloweenShop' then
        -- title:SetText('{@st43}'..ScpArgMsg("EVENT_1910_HALLOWEEN_SHOP"));
        -- close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EventShop")));
    elseif shopType == 'Event4thShop1912' then
        title:SetText('{@st43}'..ScpArgMsg("Event4thShop1912_TITLE_NAME_1"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("Event4thShop1912_TITLE_NAME_1")));
    elseif shopType == 'Sell_TPShop1912' then
        title:SetText('{@st43}'..ScpArgMsg("TP_201912_Wing_change"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("TP_201912_Wing_change")));
    elseif shopType == 'Buy_TPShop1912' then
        title:SetText('{@st43}'..ScpArgMsg("TP_201912_fur_change"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("TP_201912_fur_change")));
--    elseif shopType == 'GrewUpShop' then
--        title:SetText('{@st43}'..ScpArgMsg("NEW_CHAR_SHOP_1"));
--        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("NEW_CHAR_SHOP_1")));
    elseif shopType == 'NewYearShop' then
        title:SetText('{@st43}'..ScpArgMsg("EVENT_2001_NEWYEAR_SHOP"));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EventShop")));
    elseif shopType == 'FishingShop2002' then
        -- title:SetText('{@st43}'..ScpArgMsg("EVENT_2002_FISHING_SHOP"));
        -- close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EventShop")));
    else
        title:SetText('{@st43}'..ScpArgMsg(shopType));
        close:SetTextTooltip(ScpArgMsg('CloseUI{NAME}', 'NAME', ScpArgMsg("EventShop")));
    end


    local group = GET_CHILD(frame, 'Recipe', 'ui::CGroupBox')

    local slotHeight = ui.GetControlSetAttribute('earthTowerRecipe', 'height') + 5;

    local tree_box = GET_CHILD(group, 'recipetree_Box','ui::CGroupBox')
    local tree = GET_CHILD(tree_box, 'recipetree','ui::CTreeControl')

    if nil == tree then
        return;
    end
    tree:Clear();
    tree:EnableDrawTreeLine(false)
    tree:EnableDrawFrame(false)
    tree:SetFitToChild(true,200)
    tree:SetFontName("brown_18_b");
    tree:SetTabWidth(5);



    local clslist = GetClassList("ItemTradeShop");
    if clslist == nil then return end

    local i = 0;
    local cls = GetClassByIndexFromList(clslist, i);

    local showonlyhavemat = GET_CHILD(frame, "showonlyhavemat", "ui::CCheckBox");   
    local checkHaveMaterial = showonlyhavemat:IsChecked();

    local showExchangeEnable = GET_CHILD(frame, "showExchangeEnable", "ui::CCheckBox");
    local checkExchangeEnable = showExchangeEnable:IsChecked();

    if string.find(shopType, "EarthTower") ~= nil or shopType == "DailyRewardShop" then
        showExchangeEnable:ShowWindow(0);
        checkExchangeEnable = 0;
    end
    
    while cls ~= nil do

        if cls.ShopType == shopType then
            if EARTH_TOWER_IS_ITEM_SELL_TIME(cls) == true then
                local isExchangeEnable = true;
                if checkExchangeEnable == 1 and EXCHANGE_COUNT_CHECK(cls) == 0 then
                    isExchangeEnable = false;
                end

                local haveM = CRAFT_HAVE_MATERIAL(cls);
                if checkHaveMaterial == 1 then
                    if haveM == 1 then
                        if isExchangeEnable == true then
                            INSERT_ITEM(cls, tree, slotHeight, haveM, shopType);
                        end
                    end
                else
                    if isExchangeEnable == true then
                        INSERT_ITEM(cls, tree, slotHeight, haveM, shopType);
                    end
                end
            end
        end
        
        i = i + 1;
        cls = GetClassByIndexFromList(clslist, i);
    end

    tree:OpenNodeAll();

end

function EARTH_TOWER_IS_ITEM_SELL_TIME(recipeCls)
    local startDateString = TryGetProp(recipeCls,'SellStartTime',nil)
    local endDateString = TryGetProp(recipeCls,'SellEndTime',nil)
    if startDateString ~= nil and endDateString ~= nil then
        return IS_CURREUNT_IN_PERIOD(startDateString, endDateString, true)
    end
    return true;
end

function EXCHANGE_COUNT_CHECK(cls)
    local recipecls = GetClass('ItemTradeShop', cls.ClassName);

    if recipecls.AccountNeedProperty ~= 'None' then
        local aObj = GetMyAccountObj()
        local sCount = TryGetProp(aObj, recipecls.AccountNeedProperty);
        return sCount;
    end

    if recipecls.NeedProperty ~= 'None' then
        local sObj = GetSessionObject(GetMyPCObject(), "ssn_shop");
        local sCount = TryGetProp(sObj, recipecls.NeedProperty);
        return sCount;
    end

    return "None";
end

function INSERT_ITEM(cls, tree, slotHeight, haveMaterial, shopType)    
    local item = GetClass('Item', cls.TargetItem);
    if item == nil then
        return;
    end

    local groupName = item.GroupName;
    local classType = nil;
    if GetPropType(item, "ClassType") ~= nil then
        classType = item.ClassType;
        if classType == 'None' then
            classType = nil
        end
    end
    
    EXCHANGE_CREATE_TREE_PAGE(tree, slotHeight, groupName, classType, cls, shopType);
end


function EXCHANGE_CREATE_TREE_PAGE(tree, slotHeight, groupName, classType, cls, shopType)    
    local hGroup = tree:FindByValue(groupName);
    if tree:IsExist(hGroup) == 0 then
        hGroup = tree:Add(ScpArgMsg(groupName), groupName);
        tree:SetNodeFont(hGroup,"brown_18_b")
    end

    local hParent = nil;
    if classType == nil then
        hParent = hGroup;
    else
        local hClassType = tree:FindByValue(hGroup, classType);
        if tree:IsExist(hClassType) == 0 then
            hClassType = tree:Add(hGroup, ScpArgMsg(classType), classType);
            tree:SetNodeFont(hClassType,"brown_18_b");
        end

        hParent = hClassType;
    end
    
    local pageCtrlName = "PAGE_" .. groupName;
    if classType ~= nil then
        pageCtrlName = pageCtrlName .. "_" .. classType;
    end

    --DESTROY_CHILD_BY_USERVALUE(tree, "EARTH_TOWER_CTRL", "YES");

    --local page = tree:GetChild(pageCtrlName);
    --if page == nil then
    --page = tree:CreateOrGetControl('page', pageCtrlName, 0, 1000, tree:GetWidth()-35, 470);
    --CreateOrGetControl('groupbox', "upbox", 0, 0, detailView:GetWidth(), 0);
    --local groupbox = tree:CreateOrGetControlSet('groupbox_sub', tree:GetName(), 0, 0)
    --local groupbox = CreateOrGetControl('groupbox', 'questreward', 10, 10, frame:GetWidth()-70, frame:GetHeight());
    --print(tree:GetName())
    
    local page = tree:GetChild(pageCtrlName);
    if page == nil then
        page = tree:CreateOrGetControl('page', pageCtrlName, 0, 1000, tree:GetWidth()-35, 470);

        tolua.cast(page, 'ui::CPage')
        page:SetSkinName('None');
        page:SetSlotSize(415, slotHeight);
        page:SetFocusedRowHeight(-1, slotHeight);
        page:SetFitToChild(true, 10);
        page:SetSlotSpace(0, 0)
        page:SetBorder(5, 0, 0, 0)
        CRAFT_MINIMIZE_FOCUS(page);
        tree:Add(hParent, page);    
        tree:SetNodeFont(hParent,"brown_18_b")      
    end

    local ctrlset = page:CreateOrGetControlSet('earthTowerRecipe', cls.ClassName, 10, 10);
    local groupbox = ctrlset:CreateOrGetControl('groupbox', pageCtrlName, 0, 0, 530, 200);
    
    groupbox:SetSkinName("None")
    groupbox:EnableHitTest(0);
    groupbox:ShowWindow(1);
    tree:Add(hParent, groupbox);    
    tree:SetNodeFont(hParent,"brown_18_b")

    local x = 180;
    local startY = 80;
    local y = startY; 
    y = y + 10;
    local itemHeight = 0
    if shopType == 'PVPMine' then
        itemHeight = ui.GetControlSetAttribute('craftRecipe_detail_pvp_mine_item', 'height');
    else
        itemHeight = ui.GetControlSetAttribute('craftRecipe_detail_item', 'height');
    end
    local recipecls = GetClass('ItemTradeShop', ctrlset:GetName());
    local targetItem = GetClass("Item", recipecls.TargetItem);
    local itemName = GET_CHILD(ctrlset, "itemName")
    local itemIcon = GET_CHILD(ctrlset, "itemIcon")
    local minHeight = itemIcon:GetHeight() + startY + 10;

    if recipecls["Item_2_1"]~= "None" then
        local itemCountGBox = GET_CHILD_RECURSIVELY(ctrlset, "gbox");
        if itemCountGBox ~= nil then
            itemCountGBox:ShowWindow(0);
        end
    end
    
    itemName:SetTextByKey("value", targetItem.Name .. " [" .. recipecls.TargetItemCnt .. ScpArgMsg("Piece") .. "]");
    if targetItem.StringArg == "EnchantJewell" and cls.TargetItemAppendProperty ~= 'None' then
        local number_arg1 = TryGetProp(targetItem, 'NumberArg1', 0)
        if number_arg1 ~= 0 then
            itemName:SetTextByKey("value", targetItem.Name .. " [" .. recipecls.TargetItemCnt .. ScpArgMsg("Piece") .. "]");
        else
            itemName:SetTextByKey("value", "[Lv. "..cls.TargetItemAppendValue.."] "..targetItem.Name .. " [" .. recipecls.TargetItemCnt .. ScpArgMsg("Piece") .. "]");
        end      
    end
    
    itemIcon:SetImage(targetItem.Icon);
    itemIcon:SetEnableStretch(1);
    
    if targetItem.StringArg == "EnchantJewell" and cls.TargetItemAppendProperty ~= 'None' then
        SET_ITEM_TOOLTIP_BY_CLASSID(itemIcon, targetItem.ClassName, 'ItemTradeShop', cls.ClassName);
    else  
        SET_ITEM_TOOLTIP_ALL_TYPE(itemIcon, nil, targetItem.ClassName, '', targetItem.ClassID, 0);
    end
    
    local itemCount = 0;
    for i = 1, 5 do
        if recipecls["Item_"..i.."_1"] ~= "None" then
        local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist  = GET_RECIPE_MATERIAL_INFO(recipecls, i);
            if invItemlist ~= nil then
                for j = 0, recipeItemCnt - 1 do
                    local itemSet = nil
                    if shopType == 'PVPMine' then
                        itemSet = ctrlset:CreateOrGetControlSet('craftRecipe_detail_pvp_mine_item', "EACHMATERIALITEM_" .. i ..'_'.. j, x, y);
                    else
                        itemSet = ctrlset:CreateOrGetControlSet('craftRecipe_detail_item', "EACHMATERIALITEM_" .. i ..'_'.. j, x, y);
                    end
                    
                    itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'nonselected');
                    local slot = GET_CHILD(itemSet, "slot", "ui::CSlot");
                    local needcountTxt = GET_CHILD(itemSet, "needcount", "ui::CSlot");
                    needcountTxt:SetTextByKey("count", recipeItemCnt)

                    SET_SLOT_ITEM_CLS(slot, dragRecipeItem);
                    slot:SetEventScript(ui.DROP, "ITEMCRAFT_ON_DROP");
                    slot:SetEventScriptArgNumber(ui.DROP, dragRecipeItem.ClassID);
                    slot:SetEventScriptArgString(ui.DROP, 1)
                    slot:EnableDrag(0);
                    slot:SetOverSound('button_cursor_over_2');
                    slot:SetClickSound('button_click');

                    local icon      = slot:GetIcon();
                    icon:SetColorTone('33333333')
                    itemSet:SetUserValue("ClassName", dragRecipeItem.ClassName);
                    
                    local itemtext = GET_CHILD(itemSet, "item", "ui::CRichText");
                    itemtext:SetText(dragRecipeItem.Name);

                    y = y + itemHeight;
                    itemCount = itemCount + 1;              
                end
            else            
                local itemSet = nil
                if shopType == 'PVPMine' then
                    itemSet = ctrlset:CreateOrGetControlSet('craftRecipe_detail_pvp_mine_item', "EACHMATERIALITEM_" .. i, x, y);
                else
                    itemSet = ctrlset:CreateOrGetControlSet('craftRecipe_detail_item', "EACHMATERIALITEM_" .. i, x, y);
                end
                 
                itemSet:SetUserValue("MATERIAL_IS_SELECTED", 'nonselected');
                local slot = GET_CHILD(itemSet, "slot", "ui::CSlot");
                local needcountTxt = GET_CHILD(itemSet, "needcount", "ui::CSlot");
                needcountTxt:SetTextByKey("count", recipeItemCnt);

                SET_SLOT_ITEM_CLS(slot, dragRecipeItem);
                slot:SetEventScript(ui.DROP, "ITEMCRAFT_ON_DROP");
                slot:SetEventScriptArgNumber(ui.DROP, dragRecipeItem.ClassID);
                slot:SetEventScriptArgString(ui.DROP, tostring(recipeItemCnt));
                slot:EnableDrag(0); 
                slot:SetOverSound('button_cursor_over_2');
                slot:SetClickSound('button_click');

                local icon = slot:GetIcon();
                icon:SetColorTone('33333333')
                itemSet:SetUserValue("ClassName", dragRecipeItem.ClassName)

                local itemtext = GET_CHILD(itemSet, "item", "ui::CRichText");
                itemtext:SetText(dragRecipeItem.Name);

                y = y + itemHeight;
                itemCount = itemCount + 1;
            end
        end
    end

    -- edittext Reset
    local edit_itemcount = GET_CHILD_RECURSIVELY(ctrlset, "itemcount");
    if edit_itemcount ~= nil then
        edit_itemcount:SetText(1);
    end

    local height = 0;   
    if y < minHeight then
        height = minHeight;
    else
        height = 120 + (itemCount * 55);
    end;
        
    local lableLine = GET_CHILD(ctrlset, "labelline_1");
    local exchangeCountText = GET_CHILD(ctrlset, "exchangeCount");  
    
    local exchangeCountTextFlag = 0
    if recipecls.NeedProperty ~= 'None' then
        local sObj = GetSessionObject(GetMyPCObject(), "ssn_shop");
        local sCount = TryGetProp(sObj, recipecls.NeedProperty); 
        local cntText = string.format("%d", sCount).. ScpArgMsg("Excnaged_Count_Remind");
        local tradeBtn = GET_CHILD(ctrlset, "tradeBtn");
        if sCount <= 0 then
            cntText = ScpArgMsg("Excnaged_No_Enough");
            tradeBtn:SetColorTone("FF444444");
            tradeBtn:SetEnable(0);
        end

        exchangeCountText:SetTextByKey("value", cntText);

        lableLine:SetPos(0, height);
        height = height + 10 + lableLine:GetHeight();
        exchangeCountText:SetPos(0, height);
        height = height + 10 + exchangeCountText:GetHeight() + 15;
        lableLine:SetVisible(1);
        exchangeCountText:SetVisible(1);
        exchangeCountTextFlag = 1
    end;
    
    if recipecls.AccountNeedProperty ~= 'None' then
        local aObj = GetMyAccountObj()
        local sCount = TryGetProp(aObj, recipecls.AccountNeedProperty); 
        local cntText = ScpArgMsg("Excnaged_AccountCount_Remind","COUNT",string.format("%d", sCount))
        local tradeBtn = GET_CHILD(ctrlset, "tradeBtn");
        if sCount <= 0 then
            cntText = ScpArgMsg("Excnaged_No_Enough");
            tradeBtn:SetColorTone("FF444444");
            tradeBtn:SetEnable(0);
        end;
        
        exchangeCountText:SetTextByKey("value", cntText);

        lableLine:SetPos(0, height);
        height = height + 10 + lableLine:GetHeight();
        exchangeCountText:SetPos(0, height);
        height = height + 10 + exchangeCountText:GetHeight() + 15;
        lableLine:SetVisible(1);
        exchangeCountText:SetVisible(1);
        exchangeCountTextFlag = 1
    end
    
    if exchangeCountTextFlag == 0 then
        height = height + 20;
        lableLine:SetVisible(0);
        exchangeCountText:SetVisible(0);
    end;

    ctrlset:Resize(ctrlset:GetWidth(), height);
    GBOX_AUTO_ALIGN(groupbox, 0, 0, 10, true, false);

    groupbox:SetUserValue("HEIGHT_SIZE", groupbox:GetUserIValue("HEIGHT_SIZE") + ctrlset:GetHeight())
    groupbox:Resize(groupbox:GetWidth(), groupbox:GetUserIValue("HEIGHT_SIZE"));
    page:SetSlotSize(ctrlset:GetWidth(), ctrlset:GetHeight() + 40)
end

function EARTH_TOWER_SHOP_EXEC(parent, ctrl)    
    local frame = parent:GetTopParentFrame();
    local shopType = frame:GetUserValue("SHOP_TYPE");
	s_earth_shop_frame_name = frame:GetName();
	s_earth_shop_parent_name = parent:GetName();
    g_earth_shop_control_name = ctrl:GetName();
    
    local parentcset = ctrl:GetParent();
    local edit_itemcount = GET_CHILD_RECURSIVELY(parentcset, "itemcount");
    if edit_itemcount == nil then 
        return; 
    end

    local itemCountGBox = GET_CHILD_RECURSIVELY(parentcset, "gbox");
    local resultCount = tonumber(edit_itemcount:GetText());
    if itemCountGBox:IsVisible() == 0 then
        resultCount = 1;
    end

    local recipecls = GetClass('ItemTradeShop', parent:GetName());


    if shopType ~= 'PVPMine' then
        if recipecls ~= nil then
            local isExceptionFlag = false;
            for index = 1, 5 do
                local clsName = "Item_"..index.."_1";
                local itemName = recipecls[clsName];
                local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist = GET_RECIPE_MATERIAL_INFO(recipecls, index);

                if dragRecipeItem ~= nil then
                    local itemCount = GET_TOTAL_ITEM_CNT(dragRecipeItem.ClassID);
                    if itemCount < recipeItemCnt * resultCount then
                        ui.AddText("SystemMsgFrame", ScpArgMsg('NotEnoughRecipe'));
                        isExceptionFlag = true;
                        break;
                    end
                end
            end

            if isExceptionFlag == true then
                isExceptionFlag = false;
                return;
            end
        end
    end
    
    
    if recipecls==nil or recipecls["Item_2_1"] ~='None' then        
        if shopType == 'PVPMine' then
            AddLuaTimerFuncWithLimitCountEndFunc("PVP_MINE_SHOP_TRADE_ENTER", 100, resultCount - 1, "EARTH_TOWER_SHOP_TRADE_LEAVE");            
        else
            AddLuaTimerFuncWithLimitCountEndFunc("EARTH_TOWER_SHOP_TRADE_ENTER", 100, resultCount - 1, "EARTH_TOWER_SHOP_TRADE_LEAVE");
        end
        
    else        
        if shopType == 'PVPMine' then
            AddLuaTimerFuncWithLimitCountEndFunc("PVP_MINE_SHOP_TRADE_ENTER", 100, 0, "EARTH_TOWER_SHOP_TRADE_LEAVE");
        else
            AddLuaTimerFuncWithLimitCountEndFunc("EARTH_TOWER_SHOP_TRADE_ENTER", 100, 0, "EARTH_TOWER_SHOP_TRADE_LEAVE");
        end
    end
end

function EARTH_TOWER_SHOP_TRADE_ENTER()
	local frame = ui.GetFrame(s_earth_shop_frame_name);
	if frame == nil then
		return
    end

    local parent = GET_CHILD_RECURSIVELY(frame, s_earth_shop_parent_name);
    local control = GET_CHILD_RECURSIVELY(parent, g_earth_shop_control_name);
    
    if frame:GetName() == 'legend_craft' then
        LEGEND_CRAFT_EXECUTE(parent, control);
        return;
    end

    local parentcset = parent;
    local cnt = parentcset:GetChildCount();
    for i = 0, cnt - 1 do
        local eachcset = parentcset:GetChildByIndex(i);    
        if string.find(eachcset:GetName(),'EACHMATERIALITEM_') ~= nil then
            local selected = eachcset:GetUserValue("MATERIAL_IS_SELECTED")
            if selected ~= 'selected' then
                ui.AddText("SystemMsgFrame", ScpArgMsg('NotEnoughRecipe'));
                return;
            end
        end
    end

	local resultlist = session.GetItemIDList();
	local someflag = 0
	for i = 0, resultlist:Count() - 1 do
		local tempitem = resultlist:PtrAt(i);

		if IS_VALUEABLE_ITEM(tempitem.ItemID) == 1 then
			someflag = 1
		end
	end

    session.ResetItemList();

    local pc = GetMyPCObject();
    if pc == nil then
        return;
    end

    local recipeCls = GetClass("ItemTradeShop", parentcset:GetName())
    for index = 1, 5 do
        local clsName = "Item_"..index.."_1";
        local itemName = recipeCls[clsName];
        local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist = GET_RECIPE_MATERIAL_INFO(recipeCls, index);

        if dragRecipeItem ~= nil then
            local itemCount = GET_TOTAL_ITEM_CNT(dragRecipeItem.ClassID);
            if itemCount < recipeItemCnt then
                ui.AddText("SystemMsgFrame", ScpArgMsg('NotEnoughRecipe'));
                break;
            end
        end

        local invItem = session.GetInvItemByName(itemName);
        if "None" ~= itemName then
            if nil == invItem then
                ui.AddText("SystemMsgFrame", ClMsg('NotEnoughRecipe'));
                return;
            else
                if true == invItem.isLockState then
                    ui.SysMsg(ClMsg("MaterialItemIsLock"));
                    return;
                end
                session.AddItemID(invItem:GetIESID(), recipeItemCnt);
            end
        end
    end

	local resultlist = session.GetItemIDList();
	local cntText = string.format("%s %s", recipeCls.ClassID, 1);
	
    local edit_itemcount = GET_CHILD_RECURSIVELY(parentcset, "itemcount");
    if edit_itemcount == nil then 
        return; 
    end

    local itemCountGBox = GET_CHILD_RECURSIVELY(parentcset, "gbox");
    local resultCount = tonumber(edit_itemcount:GetText());
    if itemCountGBox:IsVisible() == 0 then
        resultCount = 1;
    end
    cntText = string.format("%s %s", recipeCls.ClassID, resultCount);
    local shopType = frame:GetUserValue("SHOP_TYPE");
	if shopType == 'EarthTower' then
		item.DialogTransaction("EARTH_TOWER_SHOP_TREAD", resultlist, cntText);
	elseif shopType == 'EarthTower2' then
		item.DialogTransaction("EARTH_TOWER_SHOP_TREAD2", resultlist, cntText);
	elseif shopType == 'EventShop' then
		item.DialogTransaction("EVENT_ITEM_SHOP_TREAD", resultlist, cntText);
	elseif shopType == 'EventShop2' then
		item.DialogTransaction("EVENT_ITEM_SHOP_TREAD2", resultlist, cntText);
	elseif shopType == 'KeyQuestShop1' then
		item.DialogTransaction("KEYQUESTSHOP1_SHOP_TREAD", resultlist, cntText);
	elseif shopType == 'KeyQuestShop2' then
		item.DialogTransaction("KEYQUESTSHOP2_SHOP_TREAD", resultlist, cntText);
	elseif shopType == 'HALLOWEEN' then
		item.DialogTransaction("HALLOWEEN_SHOP_TREAD", resultlist, cntText);
	elseif shopType == 'EventShop3' then
		item.DialogTransaction("EVENT_ITEM_SHOP_TREAD3", resultlist, cntText);	
	elseif shopType == 'EventShop4' then
		item.DialogTransaction("EVENT_ITEM_SHOP_TREAD4", resultlist, cntText);
    elseif shopType == 'EventShop8' then
        item.DialogTransaction("EVENT_ITEM_SHOP_TREAD8", resultlist, cntText);	
	elseif shopType == 'MCShop1' then
		item.DialogTransaction("MASSIVE_CONTENTS_SHOP_TREAD1", resultlist, cntText);
	elseif shopType == 'DailyRewardShop' then
		item.DialogTransaction("DAILY_REWARD_SHOP_1_TREAD1", resultlist, cntText);
    elseif shopType == 'Bernice' then
        item.DialogTransaction("SoloDungeon_Bernice_SHOP", resultlist, cntText);
    elseif shopType == 'NewChar' then
        item.DialogTransaction("NEW_CHAR_SHOP_1_TREAD1", resultlist, cntText);
	elseif shopType == 'VividCity2_Shop' then
        item.DialogTransaction("EVENT_VIVID_CITY2_SHOP_1_TREAD1", resultlist, cntText);
    elseif shopType == 'EventTotalShop1906' then
        item.DialogTransaction("EVENT_1906_TOTAL_SHOP_1_TREAD1", resultlist, cntText);
    elseif shopType == 'EventIceShop1907' then
        item.DialogTransaction("EVENT_1907_ICE_SHOP_1_TREAD1", resultlist, cntText);
    elseif shopType == 'EventMiniMoonShop1909' then
--        item.DialogTransaction("EVENT_1909_MINI_FULLMOON_SHOP_1_TREAD1", resultlist, cntText);
    elseif shopType == 'HalloweenShop' then
        -- item.DialogTransaction("EVENT_1910_HALLOWEEN_SHOP_1_TREAD1", resultlist, cntText);
    elseif shopType == 'Event4thShop1912' then
        item.DialogTransaction("EVENT1912_4TH_SHOP_1_TREAD1", resultlist, cntText);
    elseif shopType == 'Sell_TPShop1912' then
        item.DialogTransaction("SELL_TPSHOP1912_SHOP_1_TREAD1", resultlist, cntText);
    elseif shopType == 'Buy_TPShop1912' then
        item.DialogTransaction("BUY_TPSHOP1912_SHOP_1_TREAD1", resultlist, cntText);
    elseif shopType == 'GrewUpShop' then
--        item.DialogTransaction("EVENT1912_GREWUP_SHOP_1_TREAD1", resultlist, cntText);
    elseif shopType == 'NewYearShop' then
        item.DialogTransaction("EVENT_2001_NEWYEAR_SHOP_1_THREAD1", resultlist, cntText);
    elseif shopType == 'FishingShop2002' then
        -- item.DialogTransaction("EVENT_2002_FISHING_SHOP_1_THREAD1", resultlist, cntText);
    else
        local strArgList = NewStringList();
        strArgList:Add(shopType);
        item.DialogTransaction("EVENT_SHOP_1_THREAD1", resultlist, cntText,strArgList);
	end
end

-- 용병단 증표
function PVP_MINE_SHOP_TRADE_ENTER()    
	local frame = ui.GetFrame(s_earth_shop_frame_name);
	if frame == nil then
		return
    end

    local shopType = frame:GetUserValue("SHOP_TYPE");
    if shopType ~= 'PVPMine' then
        return
    end    

    local parent = GET_CHILD_RECURSIVELY(frame, s_earth_shop_parent_name);    
        
    local parentcset = parent;
    local cnt = parentcset:GetChildCount();
    for i = 0, cnt - 1 do
        local eachcset = parentcset:GetChildByIndex(i);    
        if string.find(eachcset:GetName(),'EACHMATERIALITEM_') ~= nil then
            local selected = eachcset:GetUserValue("MATERIAL_IS_SELECTED")
            if selected ~= 'selected' then
                ui.AddText("SystemMsgFrame", ScpArgMsg('NotEnoughRecipe'));                
                return;
            end
        end
    end
	
    session.ResetItemList();
    session.AddItemID(tostring(0), 1);
    local recipeCls = GetClass("ItemTradeShop", parentcset:GetName())    
	local resultlist = session.GetItemIDList();
	local cntText = string.format("%s %s", recipeCls.ClassID, 1);
	
    local edit_itemcount = GET_CHILD_RECURSIVELY(parentcset, "itemcount");
    if edit_itemcount == nil then 
        return; 
    end

    local itemCountGBox = GET_CHILD_RECURSIVELY(parentcset, "gbox");
    local resultCount = tonumber(edit_itemcount:GetText());
    if itemCountGBox:IsVisible() == 0 then
        resultCount = 1;
    end
    cntText = string.format("%s %s", recipeCls.ClassID, resultCount);
    item.DialogTransaction("PVP_MINE_SHOP", resultlist, cntText);    
end

function EARTH_TOWER_SHOP_TRADE_LEAVE()
	local frame = ui.GetFrame(s_earth_shop_frame_name);
	if frame == nil then
		return
	end

    local parent = GET_CHILD_RECURSIVELY(frame, s_earth_shop_parent_name);
	local control = GET_CHILD_RECURSIVELY(parent, g_earth_shop_control_name);
	if control == nil or parent == nil then
		return
	end
	
    session.ResetItemList();
	
    local ctrlSet = parent;

    local recipecls = GetClass('ItemTradeShop', ctrlSet:GetName());
    if recipecls == nil then
        return;
    end

    local targetItem = GetClass("Item", recipecls.TargetItem);

    -- itemName Reset
    local itemName = GET_CHILD_RECURSIVELY(ctrlSet, "itemName");
    if itemName ~= nil then
        itemName:SetTextByKey("value", targetItem.Name.." ["..recipecls.TargetItemCnt..ScpArgMsg("Piece").."]");
    end

    if targetItem.StringArg == "EnchantJewell" and recipecls.TargetItemAppendProperty ~= 'None' then
        itemName:SetTextByKey("value", "[Lv. "..recipecls.TargetItemAppendValue.."] "..targetItem.Name .. " [" .. recipecls.TargetItemCnt .. ScpArgMsg("Piece") .. "]");
    end  

    for i = 1, 5 do
        if recipecls["Item_"..i.."_1"] ~= "None" then
            local recipeItemCnt, invItemCnt, dragRecipeItem, invItem, recipeItemLv, invItemlist  = GET_RECIPE_MATERIAL_INFO(recipecls, i);
            local eachSet = GET_CHILD_RECURSIVELY(ctrlSet, "EACHMATERIALITEM_"..i);
            if invItemlist == nil and eachSet~=nil then
               -- needCount Reset
               local needCount = GET_CHILD_RECURSIVELY(eachSet, "needcount");
               needCount:SetTextByKey("count", recipeItemCnt)
                
               -- material icon Reset
               eachSet:SetUserValue("MATERIAL_IS_SELECTED", 'nonselected');

               local slot = GET_CHILD_RECURSIVELY(eachSet, "slot");
               if slot ~= nil then
                   SET_SLOT_ITEM_CLS(slot, dragRecipeItem);
                   slot:SetEventScript(ui.DROP, "ITEMCRAFT_ON_DROP");
                   slot:SetEventScriptArgNumber(ui.DROP, dragRecipeItem.ClassID);
                   slot:SetEventScriptArgString(ui.DROP, tostring(recipeItemCnt));
                   slot:EnableDrag(0); 
                   slot:SetOverSound('button_cursor_over_2');
                   slot:SetClickSound('button_click');

                   local icon = slot:GetIcon();
                   icon:SetColorTone('33333333')
                   eachSet:SetUserValue("ClassName", dragRecipeItem.ClassName)
               end

               -- btn Reset
               local btn = GET_CHILD_RECURSIVELY(eachSet, "btn");
               if btn ~= nil then
                    btn:ShowWindow(1);
               end
            end
        end
    end

    -- edittext Reset
    local edit_itemcount = GET_CHILD_RECURSIVELY(ctrlSet, "itemcount");
    if edit_itemcount ~= nil then
        edit_itemcount:SetText(1);
    end

    INVENTORY_SET_CUSTOM_RBTNDOWN("None");
    RESET_INVENTORY_ICON();

    ctrlSet:Invalidate();
end

function EARTHTOWERSHOP_UPBTN(frame, ctrl)
    if ui.CheckHoldedUI() == true then
        return;
    end

    if frame == nil then
        return
    end
        
    local topFrame = frame:GetTopParentFrame()
    if topFrame == nil then
        return
    end

    EARTHTOWERSHOP_CHANGECOUNT(frame, ctrl, 1);
end

function EARTHTOWERSHOP_DOWNBTN(frame, ctrl)
    if ui.CheckHoldedUI() == true then
        return;
    end

    if frame == nil then
        return
    end
        
    local topFrame = frame:GetTopParentFrame()
    if topFrame == nil then
        return
    end

    EARTHTOWERSHOP_CHANGECOUNT(frame, ctrl, -1);
end

function EARTHTOWERSHOP_CHANGECOUNT(frame, ctrl, change)    
    if ctrl == nil then return; end
    
    local gbox = ctrl:GetParent(); if gbox == nil then return; end
    local parentCtrl = gbox:GetParent(); if parentCtrl == nil then return; end
    local ctrlset = parentCtrl:GetParent(); if ctrlset == nil then return; end
    local cnt = ctrlset:GetChildCount();

    -- item count increase
    local countText = EARTHTOWERSHOP_CHANGECOUNT_NUM_CHANGE(ctrlset,change)
    if cnt ~= nil then
        for i = 0, cnt - 1 do
            local eachSet = ctrlset:GetChildByIndex(i);
            if string.find(eachSet:GetName(), "EACHMATERIALITEM_") ~= nil then
                local recipecls = GetClass('ItemTradeShop', ctrlset:GetName());
                local targetItem = GetClass("Item", recipecls.TargetItem);
                
                -- item Name Setting
                local targetItemName_text = GET_CHILD_RECURSIVELY(ctrlset, "itemName");
                if targetItem.StringArg == "EnchantJewell" and recipecls.TargetItemAppendProperty ~= 'None' then
                    targetItemName_text:SetTextByKey("value", "[Lv. "..recipecls.TargetItemAppendValue.."] "..targetItem.Name .. " [" .. recipecls.TargetItemCnt * countText .. ScpArgMsg("Piece") .. "]");
                else
                    targetItemName_text:SetTextByKey("value", targetItem.Name.." ["..recipecls.TargetItemCnt * countText..ScpArgMsg("Piece").."]");
                end            

                for j = 1, 5 do
                    if recipecls["Item_"..j.."_1"] ~= "None" then
                       local recipeItemCnt, recipeItemLv = GET_RECIPE_REQITEM_CNT(recipecls, "Item_"..j.."_1");

                       -- needCnt Setting
                       local needcountText = GET_CHILD_RECURSIVELY(eachSet, "needcount", "ui::CSlot");
                       needcountText:SetTextByKey("count", countText * recipeItemCnt);
                    end
                end
            end

            eachSet:Invalidate();
        end
    end
end

function UPDATE_EARTHTOWERSHOP_CHANGECOUNT(parent, ctrl)
    EARTHTOWERSHOP_CHANGECOUNT(parent,ctrl,0)
end

function EARTHTOWERSHOP_CHANGECOUNT_NUM_CHANGE(ctrlset,change)
    
    local edit_itemcount = GET_CHILD_RECURSIVELY(ctrlset, "itemcount");
    local countText = tonumber(edit_itemcount:GetText());
    if countText == nil then
        countText = 0
    end
    countText = countText + change
    if countText < 0 then
        countText = 0
    elseif countText>9999 then
        countText = 9999
    end
    local recipecls = GetClass('ItemTradeShop', ctrlset:GetName());
    if recipecls.NeedProperty ~= 'None' then
		local sObj = GetSessionObject(GetMyPCObject(), "ssn_shop");
        local sCount = TryGetProp(sObj, recipecls.NeedProperty); 
        if sCount < countText then
            countText = sCount
        end
    end
    if recipecls.AccountNeedProperty ~= 'None' then
        local aObj = GetMyAccountObj()
        local sCount = TryGetProp(aObj, recipecls.AccountNeedProperty); 
--        --EVENT_1906_SUMMER_FESTA
--        local time = geTime.GetServerSystemTime()
--        time = time.wYear..time.wMonth..time.wDay
--        if time < '2019725' then
--            if recipecls.ClassName == 'EventTotalShop1906_25' or recipecls.ClassName == 'EventTotalShop1906_26' then
--                sCount = sCount - 2
--            end
--        end
        if sCount < countText then
            countText = sCount
        end
    end
    edit_itemcount:SetText(countText);
    return countText;
end

function CRAFT_ITEM_CANCEL(eachSet, slot, stringArg)
    if eachSet~=nil then
        eachSet:SetUserValue("MATERIAL_IS_SELECTED", 'nonselected');
        eachSet:SetUserValue(eachSet:GetName(), 'None');

        local slot = GET_CHILD_RECURSIVELY(eachSet, "slot");
        if slot ~= nil then
            slot:SetEventScript(ui.DROP, "ITEMCRAFT_ON_DROP");
            slot:EnableDrag(0); 
            local icon = slot:GetIcon();
            icon:SetColorTone('33333333')
            session.RemoveItemID(stringArg);
        end

        -- btn Reset
        local btn = GET_CHILD_RECURSIVELY(eachSet, "btn");
        if btn ~= nil then
            btn:ShowWindow(1);
        end
    end
    
    local invframe = ui.GetFrame('inventory');
    INVENTORY_UPDATE_ICONS(invframe);
end