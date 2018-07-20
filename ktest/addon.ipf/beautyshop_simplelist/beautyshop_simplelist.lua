-- beautyshop_simplelist.lua
BEAUTYSHOP_SIMPLE_PURCHASE_LIST = {};
function BEAUTYSHOP_SIMPLELIST_ON_INIT(addon, frame)	
end

function BEAUTYSHOP_SIMPLELIST_OPEN(frame, list, isTryMode)
    local smallModeBox = GET_CHILD_RECURSIVELY(frame, 'smallModeBox');
    smallModeBox:ShowWindow(0);

    BEAUTYSHOP_SIMPLELIST_INIT_COUPON(frame, list);
    BEAUTYSHOP_SIMPLELIST_UPDATE_ITEM_LIST(list);
    if isTryMode == true then
        BEAUTYSHOP_SIMPLELIST_UPDATE_SMALLMODE(frame, list);
    end
end

function BEAUTYSHOP_SIMPLELIST_INIT_COUPON(frame, list)
  local hairCouponBox = GET_CHILD_RECURSIVELY(frame, 'hairCouponBox');
  local dyeCouponBox = GET_CHILD_RECURSIVELY(frame, 'dyeCouponBox');
  hairCouponBox:ShowWindow(0);
  dyeCouponBox:ShowWindow(0);

  BEAUTYSHOP_SIMPLELIST_RESET_SLOTSET(GET_CHILD_RECURSIVELY(frame, 'hairCouponSlotset'));
  BEAUTYSHOP_SIMPLELIST_RESET_SLOTSET(GET_CHILD_RECURSIVELY(frame, 'dyeCouponSlotset'));

  local rtHaircouponTP = GET_CHILD_RECURSIVELY(frame, 'rtHaircouponTP');
  local rtColorcouponTP = GET_CHILD_RECURSIVELY(frame, 'rtColorcouponTP');
  rtHaircouponTP:SetTextByKey('value', 0);
  rtColorcouponTP:SetTextByKey('value', 0);
end

function BEAUTYSHOP_SIMPLELIST_UPDATE_SMALLMODE(frame, list)
    local slotBox = GET_CHILD_RECURSIVELY(frame, 'slotBox');
    local childCnt = slotBox:GetChildCount();
    for i = 0, childCnt - 1 do
        local child = slotBox:GetChildByIndex(i);
        if string.find(child:GetName(), 'slotPreview_') ~= nil then
            child = AUTO_CAST(child);
            child:ClearIcon(); 
            BEAUTYSHOP_CLEAR_SLOT(child)
        end
    end

    for i = 1, #list do
        local itemCls = GetClass('Item', list[i]['ItemClassName']);
        local slot = GET_CHILD_RECURSIVELY(frame, 'slotPreview_'..list[i]['equipType']);
        local icon = slot:GetIcon();
        if icon == nil then
            icon = CreateIcon(slot);
        end
        icon:SetImage(itemCls.Icon);

        local colorName = list[i]['ColorName'];        
        if colorName ~= nil and colorName ~= "None" and colorName ~= "default" then   
          BEAUTYSHOP_ADD_PALLETE_IMAGE(slot);
        end
        local fullName = BEAUTYSHOP_GET_HAIR_FULLNAME(itemCls.Name, itemCls.ClassName, colorName);
        icon:SetTextTooltip(fullName);
    end
end

-- 패키지에 속한 아이템들을 하나로 모아서 패키지아이템으로 만들어줌
function BEAUTYSHOP_SIMPLELIST_TRANS_PURCHASE_ITEM_LIST(originList)
  
  local list = {} -- originList

  -- 패키지 아이템 
  local packageItemSet ={}

  for k,v in pairs(originList) do 
    -- IDSpace == 'Beauty_Shop_Package_Cube' 이고, ClassName과 ItemClassName 다를 경우(패키지 아이템 자체가 아닌경우)
    if v.IDSpace =='Beauty_Shop_Package_Cube' and v.ClassName ~= v.ItemClassName then
      if packageItemSet[v.ClassName] == nil then
        -- ItemClassName을 ClassName으로 바꿔서 하나로 만든다.
        -- copy해야함.
        packageItemSet[v.ClassName] = {
          IDSpace = v.IDSpace,
          ColorName = v.ColorName,
          ClassName= v.ClassName,
          HairClassName= v.HairClassName,
          ItemClassName= v.ClassName,  -- ItemClassName 자리에 ClassName 을 넣어줘야함.
          equipType= v.equipType,
          ColorClassName= v.ColorClassName,
        }
      end
    else -- 아니면 그대로 list에 넣기(복사해야 원본 리스트를 변형 하지 않음.)

       local data = {
         IDSpace = v.IDSpace,
         ColorName = v.ColorName,
         ClassName= v.ClassName,
         HairClassName= v.HairClassName,
         ItemClassName= v.ItemClassName,
         equipType= v.equipType,
         ColorClassName= v.ColorClassName,
       }

       table.insert(list, data)
    end
  end

  -- 저장된 패키지 list에 넣기
  for k,v in pairs(packageItemSet) do
    table.insert(list, v)
  end

  return list
end

function BEAUTYSHOP_SIMPLELIST_UPDATE_ITEM_LIST(list)
  local frame = ui.GetFrame("beautyshop_simplelist");
  local gbItemList = GET_CHILD_RECURSIVELY(frame,"gbItemList");	
  if gbItemList == nil then
    return;
  end

  -- 패키지 아이템을 하나로 걸러낸다.
  local transList = BEAUTYSHOP_SIMPLELIST_TRANS_PURCHASE_ITEM_LIST(list)

  local itemPrefix = "item_"
  -- 그룹박스내의 "shopitem_"로 시작하는 항목들을 제거
  DESTROY_CHILD_BYNAME(gbItemList, itemPrefix);

  local x = 0;
  local y = 0;
  local index = 0
  local width = ui.GetControlSetAttribute("beautyshop_list_item", "width");
  local height = ui.GetControlSetAttribute("beautyshop_list_item", "height");    
  local hairExist, dyeExist = 0, 0;
  for i = 1, #transList do
    local info = transList[i]
    local itemCls = GetClass("Item", info['ItemClassName']);
    if itemCls ~= nil then
      local ctrl = nil;
      y = height * index;
      index = index + 1;
      ctrlSet = gbItemList:CreateOrGetControlSet("beautyshop_list_item", itemPrefix..index, x, y);
      local hairPrice, dyePrice = BEAUTYSHOP_SIMPLELIST_DRAW_ITEM_DETAIL(ctrlSet, itemCls, info);
      if hairPrice ~= nil and hairPrice > 0 then
        hairExist = 1;
      end
      if dyePrice ~= nil and dyePrice > 0 then
        dyeExist = 1;
      end
    end
  end

  BEAUTYSHOP_SIMPLELIST_ENABLE_COUPON_BTN(frame, hairExist, dyeExist);  
  BEAUTYSHOP_SIMPLE_PURCHASE_LIST = transList; -- 리스트 저장  
  BEAUTYSHOP_SIMPLELIST_UPDATE_PURCHASE_PRICE(frame);
end

function BEAUTYSHOP_SIMPLELIST_UPDATE_PURCHASE_PRICE(frame)
    if frame == nil then
        return
    end

   local accountObj = GetMyAccountObj();
   local HaveTP = GET_TOTAL_TP(accountObj);
   local TotalPurchaseTP = BEAUTYSHOP_SIMPLELIST_GET_PURCHASE_TP(frame);
   local HairCouponTP = BEAUTYSHOP_SIMPLELIST_GET_HAIR_COUPON_TP(frame);
   local DyeCouponTP = BEAUTYSHOP_SIMPLELIST_GET_DYE_COUPON_TP(frame);
   local PayTP = TotalPurchaseTP + HairCouponTP + DyeCouponTP;
   local RemainTP = HaveTP - PayTP; 

   local rtHaveTP =  GET_CHILD_RECURSIVELY(frame,"rtHaveTP");
   local rtBasketTP =  GET_CHILD_RECURSIVELY(frame,"rtBasketTP");
   local rtHaircouponTP =  GET_CHILD_RECURSIVELY(frame,"rtHaircouponTP");
   local rtColorcouponTP =  GET_CHILD_RECURSIVELY(frame,"rtColorcouponTP");
   local rtRemainTP =  GET_CHILD_RECURSIVELY(frame,"rtRemainTP");
   local rtPayTP = GET_CHILD_RECURSIVELY(frame, 'rtPayTP');

   rtHaveTP:SetTextByKey("value", tostring(HaveTP));
   rtBasketTP:SetTextByKey("value", tostring(TotalPurchaseTP))
   rtHaircouponTP:SetTextByKey("value", tostring(HairCouponTP))
   rtColorcouponTP:SetTextByKey("value", tostring(DyeCouponTP))
   rtRemainTP:SetTextByKey("value", tostring(RemainTP))   
   rtPayTP:SetTextByKey('value', PayTP);
end

function BEAUTYSHOP_SIMPLELIST_DRAW_ITEM_DETAIL(ctrlset, itemCls, info)
    local idSpace = info['IDSpace'];
    local className = info['ClassName'];
    local beautyShopCls = GetClass(idSpace, className);
    local icon = GET_CHILD(ctrlset, 'icon');
    local _icon = CreateIcon(icon);
    _icon:SetImage(itemCls.Icon);    

    local rtTitle = GET_CHILD(ctrlSet, 'rtTitle');
    local colorName = info['ColorName'];
    rtTitle:SetText(BEAUTYSHOP_GET_HAIR_FULLNAME(itemCls.Name, itemCls.ClassName, colorName));
  
    local pc = GetMyPCObject();
    local rtNxp = GET_CHILD(ctrlSet, 'rtNxp');
    local priceInfo = {
      IDSpace = info['IDSpace'],
      ClassName = info['ClassName'],
      ColorClassName = info['ColorClassName'],
      ColorEngName = colorName,
    };
    if priceInfo.ColorClassName ~= 'None' then
      priceInfo.IDSpace = 'Beauty_Shop_Hair';
      priceInfo.ClassName = itemCls.ClassName;
    end
    local price, hairPrice, dyePrice = GET_BEAUTYSHOP_ITEM_PRICE(pc, priceInfo, nil, nil);
    local totalPrice = 0;
    if hairPrice ~= nil then
      rtNxp:SetText(hairPrice..' + '..dyePrice..' TP');
      totalPrice = hairPrice + dyePrice;
    else
      rtNxp:SetText(price..' TP');
      totalPrice = price;
    end

    ctrlset:SetUserValue('TOTAL_PRICE', totalPrice);
    ctrlset:SetUserValue('HAIR_PRICE', hairPrice);
    ctrlset:SetUserValue('DYE_PRICE', dyePrice);

    -- 구매를 위한 정보 세팅
    local hairClassName = info['HairClassName'];
    if hairClassName ~= 'None' then
        idSpace = 'Beauty_Shop_Hair';
        className = hairClassName;
    end
    ctrlset:SetUserValue('IDSPACE', idSpace);
    ctrlset:SetUserValue('CLASS_NAME', className);
    ctrlset:SetUserValue('COLOR_CLASS_NAME', info['ColorClassName']);

    return hairPrice, dyePrice;
end

function BEAUTYSHOP_SIMPLELIST_GET_PURCHASE_TP(frame)
    return GET_TOTAL_ITEM_PRICE_BY_TYPE(frame, 'TOTAL');
end

function BEAUTYSHOP_SIMPLELIST_GET_HAIR_COUPON_TP(frame)
    local rtHaircouponTP = GET_CHILD_RECURSIVELY(frame, 'rtHaircouponTP');
    return tonumber(rtHaircouponTP:GetTextByKey('value'));
end


function BEAUTYSHOP_SIMPLELIST_GET_DYE_COUPON_TP(frame)
  local rtColorcouponTP = GET_CHILD_RECURSIVELY(frame, 'rtColorcouponTP');
  return tonumber(rtColorcouponTP:GetTextByKey('value'));
end

function BEAUTYSHOP_SIMPLLIST_MINIMIZE(parent, ctrl)
  local frame = parent:GetTopParentFrame();
  local smallModeBox = GET_CHILD_RECURSIVELY(frame, 'smallModeBox');    
  if smallModeBox:IsVisible() == 1 then
    BEAUTYSHOP_SIMPLLIST_MINIMIZE_TO_BIG(frame, smallModeBox);
  else
    BEAUTYSHOP_SIMPLLIST_MINIMIZE_TO_SMALL(frame, smallModeBox);
  end
end

function BEAUTYSHOP_SIMPLLIST_MINIMIZE_TO_SMALL(frame, smallModeBox)
  local bigModeBox = GET_CHILD_RECURSIVELY(frame, 'bigModeBox');
  local gbBackGround = GET_CHILD_RECURSIVELY(frame, 'gbBackGround');
  local targetHeight = smallModeBox:GetHeight() + smallModeBox:GetY() + 30;
  local slotBox = GET_CHILD(smallModeBox, 'slotBox');  
  bigModeBox:ShowWindow(0);
  smallModeBox:ShowWindow(1);    
  gbBackGround:Resize(gbBackGround:GetWidth(), targetHeight);
  frame:Resize(frame:GetWidth(), targetHeight);
end

function BEAUTYSHOP_SIMPLLIST_MINIMIZE_TO_BIG(frame, smallModeBox)  
  local bigModeBox = GET_CHILD_RECURSIVELY(frame, 'bigModeBox');
  local gbBackGround = GET_CHILD_RECURSIVELY(frame, 'gbBackGround');
  local targetHeight = frame:GetOriginalHeight();    
  bigModeBox:ShowWindow(1);
  smallModeBox:ShowWindow(0);
  gbBackGround:Resize(gbBackGround:GetWidth(), targetHeight);
  frame:Resize(frame:GetWidth(), targetHeight);
end

function BEAUTYSHOP_SIMPLELIST_CANCEL_HAIR_COUPON(parent, ctrl)  
  local frame = parent:GetTopParentFrame();
  local hairCouponBox = GET_CHILD_RECURSIVELY(frame, 'hairCouponBox');
  local hairCouponSlotset = GET_CHILD_RECURSIVELY(frame, 'hairCouponSlotset');
  hairCouponSlotset:ClearSelectedSlot();
  hairCouponBox:ShowWindow(0);  
  BEAUTYSHOP_SIMPLELIST_APPLY_COUPON(frame, 'hairCouponSlotset');
end

function BEAUTYSHOP_SIMPLELIST_APPLY_HAIR_COUPON(parent, ctrl)
  local frame = parent:GetTopParentFrame();
  local hairCouponBox = GET_CHILD_RECURSIVELY(frame, 'hairCouponBox');
  hairCouponBox:ShowWindow(0);
  BEAUTYSHOP_SIMPLELIST_APPLY_COUPON(frame, 'hairCouponSlotset');
end

function BEAUTYSHOP_SIMPLELIST_CANCEL_DYE_COUPON(parent, ctrl)  
  local frame = parent:GetTopParentFrame();
  local dyeCouponBox = GET_CHILD_RECURSIVELY(frame, 'dyeCouponBox');
  local dyeCouponSlotset = GET_CHILD_RECURSIVELY(frame, 'dyeCouponSlotset');
  dyeCouponSlotset:ClearSelectedSlot();
  dyeCouponBox:ShowWindow(0);
  BEAUTYSHOP_SIMPLELIST_APPLY_COUPON(frame, 'dyeCouponSlotset');
end

function BEAUTYSHOP_SIMPLELIST_APPLY_DYE_COUPON(parent, ctrl)
  local frame = parent:GetTopParentFrame();
  local dyeCouponBox = GET_CHILD_RECURSIVELY(frame, 'dyeCouponBox');
  dyeCouponBox:ShowWindow(0);
  BEAUTYSHOP_SIMPLELIST_APPLY_COUPON(frame, 'dyeCouponSlotset');
end

function SHOW_BEAUTYSHOP_SIMPLELIST(isTryMode, list, shopName)  
    local frame = ui.GetFrame('beautyshop_simplelist');
    frame:SetUserValue('CURRENT_SHOP', shopName);

    local rtTitle = GET_CHILD_RECURSIVELY(frame, 'rtTitle');
    local minimizeBtn = GET_CHILD_RECURSIVELY(frame, 'minimizeBtn');
    local btnClose = GET_CHILD_RECURSIVELY(frame, 'btnClose');
    BEAUTYSHOP_SIMPLELIST_OPEN(frame, list, isTryMode);  
    if isTryMode == true then
        BEAUTYSHOP_SIMPLLIST_MINIMIZE_TO_SMALL(frame, GET_CHILD_RECURSIVELY(frame, 'smallModeBox'));
        rtTitle:SetTextByKey('title_name', ClMsg('TryItOnList'));
        minimizeBtn:ShowWindow(1);
        btnClose:ShowWindow(0);
    else
        BEAUTYSHOP_SIMPLLIST_MINIMIZE_TO_BIG(frame, GET_CHILD_RECURSIVELY(frame, 'smallModeBox'));
        rtTitle:SetTextByKey('title_name', ClMsg('ShoppingBag'));
        minimizeBtn:ShowWindow(0);
        btnClose:ShowWindow(1);
    end
    frame:ShowWindow(1);
end

function BEAUTYSHOP_SIMPLELIST_OPEN_HAIR_COUPON(parent, ctrl)
  local frame = parent:GetTopParentFrame();
  local hairCouponBox = GET_CHILD_RECURSIVELY(frame, 'hairCouponBox');  
  hairCouponBox:ShowWindow(1);

  local hairCouponSlotset = GET_CHILD_RECURSIVELY(frame, 'hairCouponSlotset');
  local selectedSlotCount = hairCouponSlotset:GetSelectedSlotCount();
  if selectedSlotCount < 1 then
    BEAUTYSHOP_SIMPLELIST_MAKE_COUPON_SLOTSET(frame, hairCouponSlotset, 'Hair');
  end
end

function BEAUTYSHOP_SIMPLELIST_MAKE_COUPON_SLOTSET(frame, slotset, type)
  slotset:ClearIconAll();
  local curCnt = 0;
  local totalSlotCount = slotset:GetSlotCount();
  local invItemList = session.GetInvItemList();
  local index = invItemList:Head();
  local itemCount = session.GetInvItemList():Count();  
  for i = 0, itemCount - 1 do
    local invItem = invItemList:Element(index);
    if invItem ~= nil then
      local itemObj = GetIES(invItem:GetObject());
      if IS_COUPON_ITEM(itemObj, type) == true then
        local slot = slotset:GetSlotByIndex(curCnt);        
        SET_SLOT_IMG(slot, itemObj.Icon);
        SET_SLOT_COUNT(slot, invItem.count);
        SET_SLOT_COUNT_TEXT(slot, invItem.count);
        SET_SLOT_IESID(slot, invItem:GetIESID());
        SET_SLOT_ITEM_TEXT_USE_INVCOUNT(slot, invItem, itemObj, nil);
        SET_ITEM_TOOLTIP_BY_NAME(slot:GetIcon(), itemObj.ClassName);

        slot:SetUserValue('COUPON_CLASS_NAME', itemObj.ClassName);
        slot:SetUserValue('COUPON_GUID', invItem:GetIESID());
        slot:SetSelectedImage('socket_slot_check');
        curCnt = curCnt + 1;
      end
    end
    index = invItemList:Next(index);
  end
end

function BEAUTYSHOP_SIMPLELIST_OPEN_COLOR_COUPON(parent, ctrl)
  local frame = parent:GetTopParentFrame();
  local dyeCouponBox = GET_CHILD_RECURSIVELY(frame, 'dyeCouponBox');
  dyeCouponBox:ShowWindow(1);

  local dyeCouponSlotset = GET_CHILD_RECURSIVELY(frame, 'dyeCouponSlotset');
  local selectedSlotCount = dyeCouponSlotset:GetSelectedSlotCount();
  if selectedSlotCount < 1 then
    BEAUTYSHOP_SIMPLELIST_MAKE_COUPON_SLOTSET(frame, dyeCouponSlotset, 'Dye');
  end
end

function BEAUTYSHOP_SIMPLELIST_RESET_SLOTSET(slotset)
  slotset:ClearSelectedSlot();
  slotset:SetUserValue('USE_COUPON_GUID', 0);
end

function BEAUTYSHOP_SIMPLELIST_APPLY_COUPON(frame, slotsetName)
  local slotset = GET_CHILD_RECURSIVELY(frame, slotsetName);
  local textCtrl = nil;
  local type = 'HAIR';
  if string.find(slotsetName, 'hair') ~= nil then
    textCtrl = GET_CHILD_RECURSIVELY(frame, 'rtHaircouponTP');
  else
    textCtrl = GET_CHILD_RECURSIVELY(frame, 'rtColorcouponTP');
    type = 'DYE';
  end

  local slot = slotset:GetSelectedSlot(0);
  local useCouponGuid = '0';
  if slot == nil then -- cancel
    textCtrl:SetTextByKey('value', '0');    
  else -- apply
    local rtBasketTP = GET_CHILD_RECURSIVELY(frame, 'rtBasketTP');
    local couponCls = GetClass('Item', slot:GetUserValue('COUPON_CLASS_NAME'));
    local price = GET_TOTAL_ITEM_PRICE_BY_TYPE(frame, type);
    if price < 1 then
      ui.SysMsg(ClMsg('NotExistApplyTargetTP'));
      BEAUTYSHOP_SIMPLELIST_RESET_SLOTSET(slotset);
      return;
    end

    textCtrl:SetTextByKey('value', '-'..math.floor( (price / 100 * couponCls.NumberArg1) + 0.5));
    useCouponGuid = slot:GetUserValue('COUPON_GUID');
  end
  slotset:SetUserValue('USE_COUPON_GUID', useCouponGuid);
  BEAUTYSHOP_SIMPLELIST_UPDATE_PURCHASE_PRICE(frame);
end

function GET_TOTAL_ITEM_PRICE_BY_TYPE(frame, type)
  local price = 0;
  local gbItemList = GET_CHILD_RECURSIVELY(frame, 'gbItemList');
  local childCnt = gbItemList:GetChildCount();
  for i = 0, childCnt - 1 do
    local child = gbItemList:GetChildByIndex(i);
    if string.find(child:GetName(), 'item_') ~= nil then      
      price = price + child:GetUserIValue(type..'_PRICE');
    end
  end
  return price;
end

function BEAUTYSHOP_RETURN(parent, ctrl) 
  local frame = parent:GetTopParentFrame();   
  ui.CloseFrame('beautyshop_simplelist');
  BEAUTYSHOP_DO_OPEN(ui.GetFrame('beautyshop'), nil, frame:GetUserValue('CURRENT_SHOP'), BEAUTYSHOP_GET_GENDER());
end

function BEAUTYSHOP_LIST_PREVIEW_BUY(parent, control, strarg, numarg)
  local frame = parent:GetTopParentFrame();
  local rtRemainTP = GET_CHILD_RECURSIVELY(frame, 'rtRemainTP');
  local remainTP = tonumber(rtRemainTP:GetTextByKey('value'));
  if remainTP < 0 then
    ui.SysMsg(ClMsg('NotEnoughMedal'));
    return;
  end

  local packageItemList = GET_PACKAGE_ITEM_IN_BEAUTYSHOP_BASKET(frame);  
  if #packageItemList > 0 then
    local clmsg = ClMsg('ContainProbabilityItem')..'{nl} {nl}';
    local checkMap = {};
    for i = 1, #packageItemList do
      local itemCls = GetClass('Item', packageItemList[i].ItemClassName);
      if checkMap[itemCls.ClassName] == nil then
        clmsg = clmsg..'{@st66d_y}'..itemCls.Name..'{/}{nl}';
        checkMap[itemCls.ClassName] = true;
      end
    end

    clmsg = clmsg..' {nl}{#85070a}'..ClMsg('ContainWarningItem')..'{/}{nl} {nl}'..ClMsg('ReallyBuy?');
    ui.MsgBox(clmsg, '_BEAUTYSHOP_LIST_PREVIEW_BUY()', 'None');
    return;
  end

  local gbItemList = GET_CHILD_RECURSIVELY(frame, 'gbItemList');
  local childCnt = gbItemList:GetChildCount();
  local idSpaceList = {};
  local classNameList = {};
  local colorList = {};
  for i = 0, childCnt - 1 do
    local child = gbItemList:GetChildByIndex(i);
    if string.find(child:GetName(), 'item_') ~= nil then
        local idspace = child:GetUserValue('IDSPACE');
        local className = child:GetUserValue('CLASS_NAME');
        local colorClassName = child:GetUserValue('COLOR_CLASS_NAME');
        idSpaceList[#idSpaceList + 1] = idspace;
        classNameList[#classNameList + 1] = className;
        colorList[#colorList + 1] = colorClassName;
    end
  end

  local hairCouponSlotset = GET_CHILD_RECURSIVELY(frame, 'hairCouponSlotset');
  local dyeCouponSlotset = GET_CHILD_RECURSIVELY(frame, 'dyeCouponSlotset');  
  BEAUTYSHOP_EXEC_BUY_PURCHASE_ITEM(idSpaceList, classNameList, colorList, hairCouponSlotset:GetUserValue('USE_COUPON_GUID'), dyeCouponSlotset:GetUserValue('USE_COUPON_GUID'));
  ui.CloseFrame('beautyshop_simplelist');
  ui.CloseFrame('beautyshop');  
  ui.CloseFrame('packagelist');
end

function _BEAUTYSHOP_LIST_PREVIEW_BUY()
  local frame = ui.GetFrame('beautyshop_simplelist');
  local gbItemList = GET_CHILD_RECURSIVELY(frame, 'gbItemList');
  local childCnt = gbItemList:GetChildCount();
  local idSpaceList = {};
  local classNameList = {};
  local colorList = {};
  for i = 0, childCnt - 1 do
    local child = gbItemList:GetChildByIndex(i);
    if string.find(child:GetName(), 'item_') ~= nil then
        local idspace = child:GetUserValue('IDSPACE');
        local className = child:GetUserValue('CLASS_NAME');
        local colorClassName = child:GetUserValue('COLOR_CLASS_NAME');
        idSpaceList[#idSpaceList + 1] = idspace;
        classNameList[#classNameList + 1] = className;
        colorList[#colorList + 1] = colorClassName;
    end
  end

  local hairCouponSlotset = GET_CHILD_RECURSIVELY(frame, 'hairCouponSlotset');
  local dyeCouponSlotset = GET_CHILD_RECURSIVELY(frame, 'dyeCouponSlotset');  
  BEAUTYSHOP_EXEC_BUY_PURCHASE_ITEM(idSpaceList, classNameList, colorList, hairCouponSlotset:GetUserValue('USE_COUPON_GUID'), dyeCouponSlotset:GetUserValue('USE_COUPON_GUID'));
  ui.CloseFrame('beautyshop_simplelist');
  ui.CloseFrame('beautyshop');  
end

function BEAUTYSHOP_SIMPLELIST_ENABLE_COUPON_BTN(frame, hairExist, dyeExist)  
  local btnColorCouponlist = GET_CHILD_RECURSIVELY(frame, 'btnColorCouponlist');
  local btnHairCouponlist = GET_CHILD_RECURSIVELY(frame, 'btnHairCouponlist');
  btnHairCouponlist:SetEnable(hairExist);
  btnColorCouponlist:SetEnable(dyeExist);
end

function GET_PACKAGE_ITEM_IN_BEAUTYSHOP_BASKET(frame)
  local itemList = {};
  local gbItemList = GET_CHILD_RECURSIVELY(frame, 'gbItemList');
   local childCnt = gbItemList:GetChildCount();
  for i = 0, childCnt - 1 do
    local child = gbItemList:GetChildByIndex(i);
    if string.find(child:GetName(), 'item_') ~= nil then
        local idspace = child:GetUserValue('IDSPACE');
        if idspace == 'Beauty_Shop_Package_Cube' then
          local beautyshopCls = GetClass(idspace, child:GetUserValue('CLASS_NAME'));
          if TryGetProp(beautyshopCls, 'PackageList', 'None') ~= 'None' then
            itemList[#itemList + 1] = beautyshopCls;
          end
        end
    end
  end

  return itemList;
end