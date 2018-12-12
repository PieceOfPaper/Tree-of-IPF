-- tpitem_returnuser.lua

function RETURNUSER_SHOW_TO_ITEM(parent, ctrl, str, num)
	local frame = ui.GetFrame('tpitem')
	
	UPDATE_RETURNUSER_BASKET_MONEY(frame);
	RETURNUSER_CREATE_ITEM_LIST(frame);
	RETURNUSER_CATE_SELECT(frame, true);
end

function RETURNUSER_MAKE_TREE(frame)
    if frame == nil then
        frame = ui.GetFrame("tpitem")
    end

    local categoryTree = GET_CHILD_RECURSIVELY(frame, "returnuserCateTree")
    categoryTree:Clear();
 	DESTROY_CHILD_BYNAME(categoryTree, "TPSHOP_CT_");

    local clsList, cnt = GetClassList('TPitem_Return_User');	
    if cnt == 0 or clsList == nil then
		return;
    end
    
    -- make category tree table
    local categoryList = {}
    for i = 0, cnt - 1 do
        local obj = GetClassByIndexFromList(clsList, i);
        if  categoryList[obj.Category] == nil then
            categoryList[obj.Category] = {}
        end
        categoryList[obj.Category][obj.SubCategory] = true
    end

    -- make category tree ctrl
    categoryTree:CloseNodeAll();
    for categoryKey, subCategoryList in pairs(categoryList) do 
        local ctrlSet = TPITEM_CREATE_CATEGORY_TREE(categoryTree, categoryKey)
        for subCategoryKey,notUse in pairs(subCategoryList) do 
            TPITEM_CREATE_CATEGORY_ITEM(ctrlSet, categoryTree, categoryKey, subCategoryKey)
        end
    end
    categoryTree:OpenNodeAll();
end

function UPDATE_RETURNUSER_BASKET_MONEY(frame) 
	local slotset = GET_CHILD_RECURSIVELY(frame,"returnuser_basketbuyslotset")
	local slotCount = slotset:GetSlotCount();

	local pcSession = session.GetMySession();
	if pcSession == nil then
		return
	end

	local apc = pcSession:GetPCDummyApc();
	
	local allprice = 0

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local classname = slot:GetUserValue("TPITEMNAME");
			local alreadyItem = GetClass("TPitem_Return_User",classname)

			if alreadyItem ~= nil then

				allprice = allprice + alreadyItem.Price
			
			end

		end
	end

	local basketTP = GET_CHILD_RECURSIVELY(frame,"returnuser_basketTP")
	basketTP:SetText(tostring(allprice))

	local accountObj = GetMyAccountObj();

	local haveTP = GET_CHILD_RECURSIVELY(frame,"returnuser_haveTP")
	haveTP:SetText(tostring(GET_CASH_TOTAL_POINT_C()))

	local remainTP = GET_CHILD_RECURSIVELY(frame,"returnuser_remainTP")
	remainTP:SetText(tostring(GET_CASH_TOTAL_POINT_C() - allprice))

	frame:Invalidate();
end

function RETURNUSER_CREATE_ITEM_LIST(frame)
	local frame = ui.GetFrame('tpitem');
	local returnuser_mainSubGbox = GET_CHILD_RECURSIVELY(frame,"returnuser_mainSubGbox");
	DESTROY_CHILD_BYNAME(returnuser_mainSubGbox, "eachitem_");

	local newbie_mainSubGbox = GET_CHILD_RECURSIVELY(frame,"newbie_mainSubGbox");
	newbie_mainSubGbox:RemoveAllChild();

	local mainSubGbox = GET_CHILD_RECURSIVELY(frame,"mainSubGbox");
	mainSubGbox:RemoveAllChild();
	

	local mainSubGbox = GET_CHILD_RECURSIVELY(frame,"mainSubGbox");
    mainSubGbox:RemoveAllChild();
    
	local clsList, cnt = GetClassList('TPitem_Return_User');	
	if cnt == 0 or clsList == nil then
		return;
	end

    local x, y;
	local showitemcnt = 1
	for i = 0, cnt - 1 do
        local obj = GetClassByIndexFromList(clsList, i);
        if obj.Price ~= 0 then
            local itemClassName = TryGetProp(obj, "ItemClassName");
            if itemClassName ~= nil then
                local itemobj = GetClass("Item", itemClassName);
                if CHECK_RETURNUSER_SHOW_ITEM(frame, obj, itemobj) == true then
            
                    x = ( (showitemcnt-1) % 3) * ui.GetControlSetAttribute("tpshop_item", 'width')
                    y = (math.ceil( (showitemcnt / 3) ) - 1) * (ui.GetControlSetAttribute("tpshop_item", 'height') * 1)
                    local itemcset = returnuser_mainSubGbox:CreateOrGetControlSet('tpshop_item', 'eachitem_'..showitemcnt, x, y);
                    TPITEM_RETURNUSER_DRAW_ITEM_DETAIL(obj, itemobj, itemcset); -- tpitem과 로직 동일.
                    showitemcnt = showitemcnt + 1
                end
            end
		end
	end
end

function CHECK_RETURNUSER_SHOW_ITEM(frame, shopObj, itemobj)
    -- category check	
	local curSelectCate = frame:GetUserValue('RETURNUSER_SELECTED_CATEGORY');		
	local categoryName = shopObj.Category.."#"..shopObj.SubCategory
	if curSelectCate ~= categoryName then
		-- 상위 카테고리 확인
		if curSelectCate ~= shopObj.Category then
			return false;
		end		
	end

	if itemobj == nil then
		return false;
	end

	-- text check
	local returnuser_input = GET_CHILD_RECURSIVELY(frame, 'returnuser_input');
	local searchText = returnuser_input:GetText();
	if searchText ~= nil and searchText ~= '' then
		local itemName = dic.getTranslatedStr(itemobj.Name);
		itemName = string.lower(itemName); -- 소문자로 변경
		searchText = string.lower(searchText); -- 소문자로 변경
		if string.find(itemName, searchText) == nil then
			return false;
		end
	end

	return true;
end


function RETURNUSER_CATE_SELECT(frame, forceSelect)
	local returnuserCateTree = GET_CHILD_RECURSIVELY(frame, 'returnuserCateTree');
	local firstItem = returnuserCateTree:FindByValue('TP_Premium');
	if firstItem == nil then
		return;
	end
	if forceSelect == true then
		returnuserCateTree:Select(firstItem);
	else
		returnuserCateTree:DeSelectAll();
	end
end

function RETURNUSER_TREE_CLICK(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local selectNode = ctrl:GetLastSelectedNode();
	frame:SetUserValue('RETURNUSER_SELECTED_CATEGORY', selectNode:GetValue());
	RETURNUSER_CREATE_ITEM_LIST();	
end

function TPSHOP_RETURNUSER_ITEMSEARCH_CLICK(parent, control, strArg, intArg)
	local editDiff = GET_CHILD(parent, "returnuser_editDiff");
	if editDiff == nil then
		return
	end
	 editDiff:SetVisible(0);
	 control:ClearText();
end


function TPITEM_RETURNUSER_DRAW_PREMIUM_CTRL(itemobj, itemcset)
	
	-- 프리미엄 여부에 따라 분류되느 UI를 일괄적으로 받아오고
	local title = GET_CHILD_RECURSIVELY(itemcset,"title");
	local subtitle = GET_CHILD_RECURSIVELY(itemcset,"subtitle");
	local pre_Line = GET_CHILD_RECURSIVELY(itemcset,"noneBtnPreSlot_1");		-- 프리미엄1, 프리미엄 일 때 Visible true 
	local pre_Box = GET_CHILD_RECURSIVELY(itemcset,"noneBtnPreSlot_2");			-- 프리미엄2, 프리미엄 일 때 Visible true
	local pre_Text = GET_CHILD_RECURSIVELY(itemcset,"noneBtnPreSlot_3");		-- 프리미엄3, 프리미엄 일 때 Visible true

	-- 현재는 사용하지 않으므로 꺼둔다.
	subtitle:SetVisible(0);

	local itemName = itemobj.Name;
	
	if  itemobj.ItemGrade == 0 then	--프리미엄일 경우
		local sucValue = string.format("{@st41b}%s", itemName);
		title:SetText(sucValue);
		pre_Line:SetVisible(1);
		pre_Box:SetVisible(1);
		pre_Text:SetVisible(1);
	else						--프리미엄이 아닐 경우
		title:SetText(itemName);
		pre_Line:SetVisible(0);
		pre_Box:SetVisible(0);
		pre_Text:SetVisible(0);
	end
end

function TPITEM_RETURNUSER_DRAW_MARK_CTRL(itemobj, itemcset)
	
	local isNew_mark = GET_CHILD_RECURSIVELY(itemcset,"isNew_mark");		-- 새로운
	local isLimit_mark = GET_CHILD_RECURSIVELY(itemcset,"isLimit_mark");	-- 한정
	local isHot_mark = GET_CHILD_RECURSIVELY(itemcset,"isHot_mark");		-- 잘팔림
	local isEvent_mark = GET_CHILD_RECURSIVELY(itemcset,"isEvent_mark");	-- 이벤트
	local isSale_mark = GET_CHILD_RECURSIVELY(itemcset,"isSale_mark");		-- 세일 마크

	-- 우선 모두 꺼둔다. 
	isNew_mark:SetVisible(0);
	isLimit_mark:SetVisible(0);
	isHot_mark:SetVisible(0);
	isEvent_mark:SetVisible(0);
	isSale_mark:SetVisible(0);
end

function TPITEM_RETURNUSER_DRAW_TIME_SALE_CTRL(itemobj, itemcset)
	
	local limited_line = GET_CHILD_RECURSIVELY(itemcset, "titleLine_limited");
	local limited_case = GET_CHILD_RECURSIVELY(itemcset, "case_limited");
	local limited_bg = GET_CHILD_RECURSIVELY(itemcset, "bg_limited");
	local time_limited_bg = GET_CHILD_RECURSIVELY(itemcset, "time_limited_bg");
	local time_limited_text = GET_CHILD_RECURSIVELY(itemcset, "time_limited_text");

	-- 이것도 필요 없으니 모두 꺼둔다.
	itemcset:SetSkinName('test_skin_01_btn')
	limited_bg:SetVisible(0);
	limited_case:SetVisible(0);
	limited_line:SetVisible(0);
	time_limited_bg:SetVisible(0);
	time_limited_text:SetVisible(0);

end

function TPITEM_RETURNUSER_DRAW_SLOT_CTRL(obj, itemobj, itemcset)

	local itemclsID = itemobj.ClassID;
	local slot = GET_CHILD_RECURSIVELY(itemcset, "icon");
	
	SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(itemobj));
			
	local icon = slot:GetIcon();
	icon:SetTooltipType('wholeitem');
	icon:SetTooltipArg('', itemclsID, 0);

	local argStr = string.format('%d;%d;', obj.ClassID, obj.Price);
	local itemProp = geItemTable.GetPropByName(itemobj.ClassName);
	if itemProp:IsEnableUserTrade() == true then
		argStr = argStr..'T';
	else
		argStr = argStr..'F';
	end

	slot:SetEventScript(ui.LBUTTONDOWN, 'TPITEM_SHOW_PACKAGELIST');
	slot:SetEventScriptArgNumber(ui.LBUTTONDOWN, itemclsID);
	slot:SetEventScriptArgString(ui.LBUTTONDOWN, argStr);
end

function TPITEM_RETURNUSER_DRAW_PRICE_CTRL(obj, itemcset)
	local nxp = GET_CHILD_RECURSIVELY(itemcset,"nxp")
	nxp:SetText("{@st43}{s18}"..obj.Price.."{/}");	
end

function TPITEM_RETURNUSER_DRAW_DESC_CTRL(itemobj, itemcset)
	local itemclsID = itemobj.ClassID;

	local lv = GETMYPCLEVEL();
	local job = GETMYPCJOB();
	local gender = GETMYPCGENDER();
	local prop = geItemTable.GetProp(itemclsID);
	local result = prop:CheckEquip(lv, job, gender);

	-- desc
	local desc = GET_CHILD_RECURSIVELY(itemcset,"desc")
	if result == "OK" then
		desc:SetText(GET_USEJOB_TOOLTIP(itemobj))
	else
		desc:SetText("{#990000}"..GET_USEJOB_TOOLTIP(itemobj).."{/}")
	end

	-- tradeable
	local tradeable = GET_CHILD_RECURSIVELY(itemcset,"tradeable")
	local itemProp = geItemTable.GetPropByName(itemobj.ClassName);
	if itemProp:IsEnableUserTrade() == true then
		tradeable:ShowWindow(0)
	else
		tradeable:ShowWindow(1)
	end
end

function TPITEM_RETURNUSER_DRAW_BUTTON_CTRL(obj, itemcset)
	local tpitem_clsName = obj.ClassName;
	local tpitem_clsID = obj.ClassID;

	-- 구매버튼
	local buyBtn = GET_CHILD_RECURSIVELY(itemcset, "buyBtn");
	buyBtn:SetEventScript(ui.LBUTTONUP, 'TPSHOP_ITEM_TO_RETURNUSER_BUY_BASKET_PREPROCESSOR'); -- 기존 스크립트 교체.
	buyBtn:SetEventScriptArgNumber(ui.LBUTTONUP, tpitem_clsID);
	buyBtn:SetEventScriptArgString(ui.LBUTTONUP, tpitem_clsName);
	buyBtn:SetSkinName("test_red_button");	
	buyBtn:EnableHitTest(1);

	-- 미리보기는 사용하지 않음.
	local previewbtn = GET_CHILD_RECURSIVELY(itemcset, "previewBtn");
	-- previewbtn:SetEventScriptArgNumber(ui.LBUTTONUP, tpitem_clsID);		
	-- previewbtn:SetEventScriptArgString(ui.LBUTTONUP, tpitem_clsName);
	previewbtn:ShowWindow(0);
end

function TPITEM_RETURNUSER_DRAW_ITEM_DETAIL(obj, itemobj, itemcset)

	-- 프리미엄 Text
	TPITEM_RETURNUSER_DRAW_PREMIUM_CTRL(itemobj, itemcset)

	-- 마크
	TPITEM_RETURNUSER_DRAW_MARK_CTRL(itemobj, itemcset)

	-- 기간 한정
	TPITEM_RETURNUSER_DRAW_TIME_SALE_CTRL(itemobj, itemcset)

	-- Slot 설정
	TPITEM_RETURNUSER_DRAW_SLOT_CTRL(obj, itemobj, itemcset)

	-- 금액
	TPITEM_RETURNUSER_DRAW_PRICE_CTRL(obj, itemcset)

	-- 설명
	TPITEM_RETURNUSER_DRAW_DESC_CTRL(itemobj, itemcset)

	-- 버튼 설정
	TPITEM_RETURNUSER_DRAW_BUTTON_CTRL(obj, itemcset)
	
	-- 구매 제한 설정
	TPITEM_RETURNUSER_ENABLE_BY_LIMITATION(obj, itemcset)

	itemcset:SetUserValue("TPITEM_CLSID", obj.ClassID);
end


-- 구매제한 설정.
function  TPITEM_RETURNUSER_ENABLE_BY_LIMITATION(tpitemCls, itemcset )
	local buyBtn = GET_CHILD_RECURSIVELY(itemcset, "buyBtn");

	local shopType = 1; -- 복귀 유저 : 1
	local itemCls = GetClass('Item', tpitemCls.ItemClassName);	
	local curBuyCount = session.shop.GetCurrentBuyLimitCount(shopType, tpitemCls.ClassID, itemCls.ClassID);    
	local accountLimitCount = TryGetProp(tpitemCls, 'AccountLimitCount');
	
	if (accountLimitCount ~= nil and accountLimitCount > 0 and curBuyCount >= accountLimitCount) then
		buyBtn:SetSkinName('test_gray_button');
		buyBtn:SetText(ClMsg('ITEM_IsPurchased0'))
		buyBtn:EnableHitTest(0)
	end
end

function TPSHOP_ITEM_TO_RETURNUSER_BUY_BASKET_PREPROCESSOR(parent, control, tpitemname, tpitem_clsID)

	local shopType = 1; -- 복귀 유저 : 1
	
	local obj = GetClassByType("TPitem_Return_User", tpitem_clsID)
	if obj == nil then
		return false;
	end

	local itemobj = GetClass("Item", obj.ItemClassName)
	if itemobj == nil then
		return false;
	end

	local classid = itemobj.ClassID;
	local item = GetClassByType("Item", classid)
	if item == nil then
		return false;
	end

	if ui.IsMyDefaultHairItem(classid) == true then
        isHave = true;
	end

	local allowDup = TryGetProp(item,'AllowDuplicate')
	
	local isHave = false;
				
	if allowDup == "NO" then
		if session.GetInvItemByType(classid) ~= nil then
			isHave = true;
		end
		if session.GetEquipItemByType(classid) ~= nil then
			isHave = true;
		end
		if session.GetWarehouseItemByType(classid) ~= nil then
			isHave = true;
		end
	end
	
    local limit = GET_LIMITATION_TO_BUY_WITH_SHOPTYPE(obj.ClassID, shopType);
	if isHave == true then
		ui.MsgBox(ClMsg("AlearyHaveItemReallyBuy?"), string.format("TPSHOP_ITEM_TO_RETURNUSER_BUY_BASKET('%s', %d)", tpitemname, classid), "None");
	elseif limit == 'ACCOUNT' then
		local curBuyCount = session.shop.GetCurrentBuyLimitCount(shopType, obj.ClassID, classid);
		if curBuyCount >= obj.AccountLimitCount then
			ui.MsgBox_OneBtnScp(ScpArgMsg("PurchaseItemExceeded","Value", obj.AccountLimitCount), "")
            return false;
		else
			ui.MsgBox(ScpArgMsg("SelectPurchaseRestrictedItem","Value", obj.AccountLimitCount - curBuyCount ), string.format("TPSHOP_ITEM_TO_RETURNUSER_BUY_BASKET('%s', %d)", tpitemname, classid), "None");
		end
	elseif limit == 'MONTH' then
        local curBuyCount = session.shop.GetCurrentBuyLimitCount(shopType, obj.ClassID, classid);
		if curBuyCount >= obj.MonthLimitCount then
			ui.MsgBox_OneBtnScp(ScpArgMsg("PurchaseItemExceeded","Value", obj.MonthLimitCount), "")
            return false;
		else
			ui.MsgBox(ScpArgMsg("SelectPurchaseRestrictedItemByMonth","Value", obj.MonthLimitCount -curBuyCount ), string.format("TPSHOP_ITEM_TO_RETURNUSER_BUY_BASKET('%s', %d)", tpitemname, classid), "None");
		end
	elseif TPITEM_IS_ALREADY_PUT_INTO_BASKET(parent:GetTopParentFrame(), obj) == true then
		ui.MsgBox(ClMsg("AleadyPutInBasketReallyBuy?"), string.format("TPSHOP_ITEM_TO_RETURNUSER_BUY_BASKET('%s', %d)", tpitemname, classid), "None");	
	else
		TPSHOP_ITEM_TO_RETURNUSER_BUY_BASKET(tpitemname, classid)
	end
    return true;
end

function TPSHOP_ITEM_TO_RETURNUSER_BUY_BASKET(tpitemname, classid)	
	local item = GetClassByType("Item", classid)
	if item == nil then
		return;
	end

	local tpitem = GetClass("TPitem_Return_User", tpitemname)
	if tpitem == nil then
		ui.MsgBox(ScpArgMsg("DataError"))
		return
	end

	local frame = ui.GetFrame("tpitem")
	if CHECK_RETURNUSER_ALREADY_IN_LIMIT_ITEM(frame, tpitem) == false then
		ui.SysMsg(ClMsg('AleadyPutInBasket'));
		return;
	end

	local slotset = GET_CHILD_RECURSIVELY(frame,"returnuser_basketbuyslotset")
	local slotCount = slotset:GetSlotCount();
	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon == nil then

			local slot  = slotset:GetSlotByIndex(i);

			slot:SetEventScript(ui.RBUTTONDOWN, 'TPSHOP_RETURNUSER_BASKETSLOT_BUY_REMOVE');
			slot:SetEventScriptArgNumber(ui.RBUTTONDOWN, classid);
			slot:SetUserValue("CLASSNAME", item.ClassName);
			slot:SetUserValue("TPITEMNAME", tpitemname);

			SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(item));
			local icon = slot:GetIcon();
			icon:SetTooltipType('wholeitem');
			icon:SetTooltipArg('', item.ClassID, 0);

			break;

		end
	end

	UPDATE_RETURNUSER_BASKET_MONEY(frame)	
	
end

function TPSHOP_RETURNUSER_BASKETSLOT_BUY_REMOVE(parent, control, strarg, classid)	

	control:ClearText();
	control:ClearIcon();

	control:SetUserValue("CLASSNAME", "None");
	control:SetUserValue("TPITEMNAME", "None");

	UPDATE_RETURNUSER_BASKET_MONEY(parent:GetTopParentFrame())

end

function CHECK_RETURNUSER_ALREADY_IN_LIMIT_ITEM(frame, tpItem)
	local shopType = 1; -- 복귀 유저 : 1
	local limit = GET_LIMITATION_TO_BUY_WITH_SHOPTYPE(tpItem.ClassID, shopType);
	if limit == 'NO' then
		return true;
	end

	local basketslotset = GET_CHILD_RECURSIVELY(frame, 'returnuser_basketbuyslotset');
	local slotCnt = basketslotset:GetSlotCount();
	for i = 0, slotCnt - 1 do
		local slot = basketslotset:GetSlotByIndex(i);
		if slot:GetUserValue('TPITEMNAME') == tpItem.ClassName then
			return false;		
		end	
	end
	return true;
end

function TPSHOP_RETURNUSER_ITEM_BASKET_BUY(parent, control)
	
    local topFrame = parent:GetTopParentFrame();
    local slotset = GET_CHILD_RECURSIVELY(topFrame, 'returnuser_basketbuyslotset');
    local slotCount = slotset:GetSlotCount();
    local cannotEquip = {};
    local needWarningItemList = {};
    local noNeedWarning = {};
    local itemAndTPItemIDTable = {};
	local allPrice = 0;
	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);
		if slotIcon ~= nil then
			local slot  = slotset:GetSlotByIndex(i);			
            local tpItemName = slot:GetUserValue('TPITEMNAME');
            local itemClassName = slot:GetUserValue('CLASSNAME');
			local item = GetClass("Item", itemClassName);			
            local tpitem = GetClass('TPitem_Return_User', tpItemName);

            itemAndTPItemIDTable[item.ClassID] = tpitem.ClassID;

			allPrice = allPrice + tpitem.Price

			if TryGetProp(tpitem, 'WarningMsg', 'NO') == 'YES' then
				needWarningItemList[#needWarningItemList + 1] = item;
			else
				noNeedWarning[#noNeedWarning + 1] = item;
			end

            if IS_EQUIP(item) == true then
		        local lv = GETMYPCLEVEL();
		        local job = GETMYPCJOB();
		        local gender = GETMYPCGENDER();
                local itemCls = GetClass('Item', itemClassName);
                local classid = itemCls.ClassID;
		        local prop = geItemTable.GetProp(classid);
		        local result = prop:CheckEquip(lv, job, gender);

		        if result ~= "OK" then
                    cannotEquip[#cannotEquip + 1] = itemCls;
                else
		            local pc = GetMyPCObject();
		            if pc == nil then
			            return;
		            end

		            local needJobClassName = TryGetProp(tpitem, "Job");
		            local needJobGrade = TryGetProp(tpitem, "JobGrade");
		            if IS_ENABLE_EQUIP_CLASS(pc, needJobClassName, needJobGrade) == false then
			            cannotEquip[#cannotEquip + 1] = itemCls;
                    else
		                local useGender = TryGetProp(item,'UseGender');
		                if useGender =="Male" and pc.Gender ~= 1 then
			                cannotEquip[#cannotEquip + 1] = itemCls;
                        else
		                    if useGender =="Female" and pc.Gender ~= 2 then
			                    cannotEquip[#cannotEquip + 1] = itemCls;
		                    end
		                end
		            end
		        end	
	        end
        end
    end

    if #needWarningItemList > 0 or #cannotEquip > 0 then
		OPEN_TPITEM_POPUPMSG(needWarningItemList, noNeedWarning, cannotEquip, itemAndTPItemIDTable, allPrice, 
		{
			okScp="EXEC_BUY_RETURNUSER_MARKET_ITEM", 
			cancelScp = "TPSHOP_RETURNUSER_ITEM_BASKET_BUY_CANCEL"
		});
    else
    	if config.GetServiceNation() == "GLOBAL" then			
			if CHECK_LIMIT_PAYMENT_STATE_C() == true then
        		ui.MsgBox_NonNested_Ex(ScpArgMsg("ReallyBuy?"), 0x00000004, parent:GetName(), "EXEC_BUY_RETURNUSER_MARKET_ITEM", "TPSHOP_RETURNUSER_ITEM_BASKET_BUY_CANCEL");	
			else
				POPUP_LIMIT_PAYMENT(ScpArgMsg("ReallyBuy?"), parent:GetName(), allPrice)
			end			
		else
			ui.MsgBox_NonNested_Ex(ScpArgMsg("ReallyBuy?"), 0x00000004, parent:GetName(), "EXEC_BUY_RETURNUSER_MARKET_ITEM", "TPSHOP_RETURNUSER_ITEM_BASKET_BUY_CANCEL");	
		end
    end

	control:SetEnable(0);
end

function EXEC_BUY_RETURNUSER_MARKET_ITEM()	
	local itemListStr = ""

	local frame = ui.GetFrame("tpitem")
	local btn = GET_CHILD_RECURSIVELY(frame,"returnuser_toitemBtn");
	local slotset = GET_CHILD_RECURSIVELY(frame,"returnuser_basketbuyslotset")
	if slotset == nil then
		btn:SetEnable(1);
		ui.CloseFrame('tpitem_popupmsg');
		return;
	end
	local slotCount = slotset:GetSlotCount();

	local allprice = 0

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local tpitemname = slot:GetUserValue("TPITEMNAME");
			local tpitem = GetClass('TPitem_Return_User',tpitemname)

			if tpitem ~= nil then
				
				allprice = allprice + tpitem.Price

				if itemListStr == "" then
					itemListStr = tostring(tpitem.ClassID)
				else
					itemListStr = itemListStr .." " .. tostring(tpitem.ClassID)
				end
				
			else
				btn:SetEnable(1);
				ui.CloseFrame('tpitem_popupmsg');
				return
			end

		end
	end
	
	if allprice == 0 then
		btn:SetEnable(1);
		ui.CloseFrame('tpitem_popupmsg');
		return
	end
	
	if GET_CASH_TOTAL_POINT_C() < allprice then 

		ui.MsgBox_NonNested(ScpArgMsg("Auto_MeDali_BuJogHapNiDa."), 0x00000000, frame:GetName(), "None", "None");	
		local tabObj		    = GET_CHILD_RECURSIVELY(frame,"shopTab");	
		local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
		itembox_tab:SelectTab(0);
		TPSHOP_TAB_VIEW(frame, 0);

		btn:SetEnable(1);
		ui.CloseFrame('tpitem_popupmsg');
		return;
	end

	pc.ReqExecuteTx_NumArgs("SCR_TX_RETURNUSER_TP_SHOP", itemListStr);	
	btn:SetEnable(1);
		
	local frame = ui.GetFrame("tpitem");
	frame:ShowWindow(0);
	TPITEM_CLOSE(frame);
end

function TPSHOP_RETURNUSER_ITEM_BASKET_BUY_CANCEL()
	local frame = ui.GetFrame("tpitem");
	local btn = GET_CHILD_RECURSIVELY(frame,"returnuser_toitemBtn");
	btn:SetEnable(1);

	ui.CloseFrame('tpitem_popupmsg');
end
