-- tpitem_costume_exchange.lua

function COSTUME_EXCHANGE_SHOW_TO_ITEM(parent, ctrl, str, num)
	if ctrl ~= nil then
	    ctrl:SetSkinName("baseyellow_btn");
	    local costume_exchange_group1 = GET_CHILD_RECURSIVELY(parent,"costume_exchange_group1");	
	    costume_exchange_group1:SetSkinName("base_btn");
	end

	local frame = ui.GetFrame('tpitem')
	local costume_exchange_basketbuyslotset = GET_CHILD_RECURSIVELY(frame,"costume_exchange_basketbuyslotset");
	costume_exchange_basketbuyslotset:ShowWindow(1)

	local costume_exchange_toitemBtn = GET_CHILD_RECURSIVELY(frame,"costume_exchange_toitemBtn");
	costume_exchange_toitemBtn:ShowWindow(1)

	local costume_exchange_mainBuyText = GET_CHILD_RECURSIVELY(frame,"costume_exchange_mainBuyText");
	costume_exchange_mainBuyText:ShowWindow(1)
	

	UPDATE_COSTUME_EXCHANGE_BASKET_MONEY(frame);	
	COSTUME_EXCHANGE_CREATE_BUY_LIST();
	RECYCLE_CATE_SELECT(frame, true);
end


function UPDATE_COSTUME_EXCHANGE_BASKET_MONEY(frame) 
	local slotset = GET_CHILD_RECURSIVELY(frame,"costume_exchange_basketbuyslotset")
	local slotCount = slotset:GetSlotCount();
	local allprice = 0

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local classname = slot:GetUserValue("TPITEMNAME");
			local alreadyItem = GetClass("costume_exchange_shop",classname)
			if alreadyItem ~= nil then
				allprice = allprice + alreadyItem.BuyPrice			
			end

		end
	end

	local basketTP = GET_CHILD_RECURSIVELY(frame,"costume_exchange_basketTP")
	if allprice == 0 then
		basketTP:SetText("0")
	else
		basketTP:SetText("-"..tostring(allprice))
	end

	local accountObj = GetMyAccountObj();

	local havemedalcnt = 0
	local medal = session.GetInvItemByName("Costume_Exchange_Coupon");

	if medal ~= nil then
		havemedalcnt = medal.count
	end

	local haveTP = GET_CHILD_RECURSIVELY(frame,"costume_exchange_haveTP")
	haveTP:SetText(tostring(havemedalcnt))

	local remainTP = GET_CHILD_RECURSIVELY(frame,"costume_exchange_remainTP")
	remainTP:SetText(tostring(havemedalcnt - allprice))
	
	frame:Invalidate();
end

function COSTUME_EXCHANGE_CREATE_BUY_LIST()
	local frame = ui.GetFrame('tpitem');
	local costume_exchange_mainSubGbox = GET_CHILD_RECURSIVELY(frame,"costume_exchange_mainSubGbox");
	DESTROY_CHILD_BYNAME(costume_exchange_mainSubGbox, "eachitem_");

	local mainSubGbox = GET_CHILD_RECURSIVELY(frame,"costume_exchange_mainSubGbox");
	mainSubGbox:RemoveAllChild();
	local clsList, cnt = GetClassList('costume_exchange_shop');	
	if cnt == 0 or clsList == nil then
		return;
	end

	local x, y;
	local showitemcnt = 1
	for i = 0, cnt - 1 do
		local obj = GetClassByIndexFromList(clsList, i);
		if obj.BuyPrice ~= 0 then
			local itemobj = GetClass("Item", obj.ClassName);
			if CHECK_COSTUME_EXCHANGE_SHOW_ITEM(frame, itemobj) == true then
				x = ( (showitemcnt-1) % 3) * ui.GetControlSetAttribute("tpshop_costume_exchange", 'width')
				y = (math.ceil( (showitemcnt / 3) ) - 1) * (ui.GetControlSetAttribute("tpshop_costume_exchange", 'height') * 1)
				local itemcset = mainSubGbox:CreateOrGetControlSet('tpshop_costume_exchange', 'eachitem_'..showitemcnt, x, y);
				COSTUME_EXCHANGE_DRAW_ITEM_DETAIL(obj, itemobj, itemcset);

				showitemcnt = showitemcnt + 1
			end
		end
	end
end

function CHECK_COSTUME_EXCHANGE_SHOW_ITEM(frame, item)
	-- category check	
	local curSelectCate = frame:GetUserValue('COSTUME_EXCHANGE_SELECTED_CATEGORY');		
	if curSelectCate == 'Wiki_Accessory' and item.ClassType ~= 'Ring' and item.ClassType ~= 'Neck' then
		return false;
	end

	if curSelectCate == 'Drug' and item.GroupName ~= 'Consume' then
		return false;
	end

	if string.find(curSelectCate, 'costume') ~= nil then
		if item.ClassType ~= 'Outer' then
			return false;
		else
			local ctrlType = string.sub(curSelectCate, 0, string.find(curSelectCate, '_') - 1);			
			if ctrlType == 'Com' and item.UseJob ~= 'All' then
				return false;
			elseif ctrlType == 'War' and item.UseJob ~= 'Char1' then
				return false;
			elseif ctrlType == 'Wiz' and item.UseJob ~= 'Char2' then
				return false;
			elseif ctrlType == 'Arc' and item.UseJob ~= 'Char3' then
				return false;
			elseif ctrlType == 'Cle' and item.UseJob ~= 'Char4' then
				return false;
			end
		end
	end

	if curSelectCate == 'Artefact' and item.ClassType ~= 'Artefact' then
		return false;
	end

	-- text check
	local costume_exchange_input = GET_CHILD_RECURSIVELY(frame, 'costume_exchange_input');
	local searchText = costume_exchange_input:GetText();
	if searchText ~= nil and searchText ~= '' then
		local itemName = dic.getTranslatedStr(item.Name);
		itemName = string.lower(itemName); -- 소문자로 변경
		searchText = string.lower(searchText); -- 소문자로 변경
		if string.find(itemName, searchText) == nil then
			return false;
		end
	end

	return true;
end


function COSTUME_EXCHANGE_DRAW_ITEM_DETAIL(obj, itemobj, itemcset, itemguid)
	local title = GET_CHILD_RECURSIVELY(itemcset,"title");
	local subtitle = GET_CHILD_RECURSIVELY(itemcset,"subtitle");
	local nxp = GET_CHILD_RECURSIVELY(itemcset,"nxp")
	local slot = GET_CHILD_RECURSIVELY(itemcset, "icon");
	local pre_Line = GET_CHILD_RECURSIVELY(itemcset,"noneBtnPreSlot_1");
	local pre_Box = GET_CHILD_RECURSIVELY(itemcset,"noneBtnPreSlot_2");
	local pre_Text = GET_CHILD_RECURSIVELY(itemcset,"noneBtnPreSlot_3");
	local staticBuyMedalbox = GET_CHILD_RECURSIVELY(itemcset,"staticBuyMedalbox"); 
	--local staticSellMedalbox = GET_CHILD_RECURSIVELY(itemcset,"staticSellMedalbox");
	local remaincnt = GET_CHILD_RECURSIVELY(itemcset,"remaincnt");
	

	local itemName = itemobj.Name;
	local itemclsID = itemobj.ClassID;
	local tpitem_clsName = obj.ClassName;
	local tpitem_clsID = obj.ClassID;

	local price;
	price = obj.BuyPrice
	staticBuyMedalbox:ShowWindow(1)
--	staticSellMedalbox:ShowWindow(0)
	remaincnt:ShowWindow(0)
	
	title:SetText(itemName);
	pre_Line:SetVisible(0);
	pre_Box:SetVisible(0);
	pre_Text:SetVisible(0);
				
	
	nxp:SetText("{@st43}{s18}"..price.."{/}");
			
	subtitle:SetVisible(0);	

	SET_SLOT_IMG(slot, GET_ITEM_ICON_IMAGE(itemobj));
			
	local icon = slot:GetIcon();
	icon:SetTooltipType('wholeitem');
	icon:SetTooltipArg('', itemclsID, 0);

	local desc = GET_CHILD_RECURSIVELY(itemcset,"desc")
	local tradeable = GET_CHILD_RECURSIVELY(itemcset,"tradeable")

	
	local lv = GETMYPCLEVEL();
	local job = GETMYPCJOB();
	local gender = GETMYPCGENDER();
	local prop = geItemTable.GetProp(itemclsID);
	local result = prop:CheckEquip(lv, job, gender);

	
	if result == "OK" then
		desc:SetText(GET_USEJOB_TOOLTIP(itemobj))
	else
		desc:SetText("{#990000}"..GET_USEJOB_TOOLTIP(itemobj).."{/}")
	end

	
	local itemProp = geItemTable.GetPropByName(itemobj.ClassName);
	if itemProp:IsEnableUserTrade() == true then
		tradeable:ShowWindow(0)
	else
		tradeable:ShowWindow(1)
	end
	
			
	local buyBtn = GET_CHILD_RECURSIVELY(itemcset, "buyBtn");
	local sucValue = string.format("");	
	local isBuyPossible = 1;

	local previewbtn = GET_CHILD_RECURSIVELY(itemcset, "previewBtn");

	
	buyBtn:SetEventScriptArgNumber(ui.LBUTTONUP, tpitem_clsID);
	buyBtn:SetEventScriptArgString(ui.LBUTTONUP, tpitem_clsName);
	buyBtn:ShowWindow(1)
	previewbtn:ShowWindow(0);

	local previewable = false
	if IS_EQUIP(itemobj) == true then
		previewable = true

		local lv = GETMYPCLEVEL();
		local job = GETMYPCJOB();
		local gender = GETMYPCGENDER();
		local prop = geItemTable.GetProp(itemclsID);
		local result = prop:CheckEquip(lv, job, gender);

		if result ~= "OK" then
			previewable = false
		end	
		local pc = GetMyPCObject();
		if pc == nil then
			return;
		end
	
		local useGender = TryGetProp(itemobj,'UseGender')

		if useGender =="Male" and pc.Gender ~= 1 then
			previewable = false
		end

		if useGender =="Female" and pc.Gender ~= 2 then
			previewable = false
		end
	end
	if previewable == true then

		local clstype = TryGetProp(itemobj, "ClassType");	
		if clstype == "Hat" or clstype == "Outer" then
			previewbtn:SetEventScriptArgNumber(ui.LBUTTONUP, tpitem_clsID);		
			previewbtn:SetEventScriptArgString(ui.LBUTTONUP, tpitem_clsName);
			previewbtn:ShowWindow(1);
		end
	end
		
	buyBtn:SetSkinName("test_red_button");	
	buyBtn:EnableHitTest(1);

end

function TPSHOP_ITEM_COSTUME_EXCHANGE_PREVIEW_PREPROCESSOR(parent, control, tpitemname, tpitem_clsID)
	
	local frame = ui.GetFrame("tpitem");
	local slotset = nil;
	
	local obj = GetClassByType("costume_exchange_shop", tpitem_clsID)
	if obj == nil then
		return;
	end
	
	local itemobj = GetClass("Item", obj.ClassName)
	if itemobj == nil then
		return;
	end
	
	if itemobj.ClassType == "Outer" then
		TPSHOP_PREVIEWSLOT_EQUIP(frame, GET_CHILD_RECURSIVELY(frame,"previewslotset0"), 1, tpitemname, itemobj);
	elseif itemobj.ClassType == "Hat" then
		TPSHOP_PREVIEWSLOT_EQUIP(frame, GET_CHILD_RECURSIVELY(frame,"previewslotset1"), 0, tpitemname, itemobj);
	end
end


function TPSHOP_ITEM_TO_COSTUME_EXCHANGE_BUY_BASKET_PREPROCESSOR(parent, control, tpitemname, tpitem_clsID)

	local obj = GetClassByType("costume_exchange_shop", tpitem_clsID)
	if obj == nil then
		return;
	end
	
	local itemobj = GetClass("Item", obj.ClassName)
	if itemobj == nil then
		return;
	end

	local classid = itemobj.ClassID;
	local item = GetClassByType("Item", classid)

	if item == nil then
		return;
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
	
	if isHave == true then
		ui.MsgBox(ClMsg("AlearyHaveItemReallyBuy?"), string.format("TPSHOP_ITEM_TO_COSTUME_EXCHANGE_BUY_BASKET('%s', %d)", tpitemname, classid), "None");
	else
		TPSHOP_ITEM_TO_COSTUME_EXCHANGE_BUY_BASKET(tpitemname, classid)
	end
end


function TPSHOP_ITEM_TO_COSTUME_EXCHANGE_BUY_BASKET(tpitemname, classid)	

	local item = GetClassByType("Item", classid)

	if item == nil then
		return;
	end

	local tpitem = GetClass("costume_exchange_shop", item.ClassName)
	if tpitem == nil then
		ui.MsgBox(ScpArgMsg("DataError"))
		return
	end
	
	local frame = ui.GetFrame("tpitem")
	local slotset = GET_CHILD_RECURSIVELY(frame,"costume_exchange_basketbuyslotset")
	local slotCount = slotset:GetSlotCount();

	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon == nil then

			local slot  = slotset:GetSlotByIndex(i);

			slot:SetEventScript(ui.RBUTTONDOWN, 'TPSHOP_COSTUME_EXCHANGE_BASKETSLOT_BUY_REMOVE');
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
	
	UPDATE_COSTUME_EXCHANGE_BASKET_MONEY(frame)	
end


function TPSHOP_COSTUME_EXCHANGE_BASKETSLOT_BUY_REMOVE(parent, control, strarg, classid)	

	control:ClearText();
	control:ClearIcon();

	control:SetUserValue("CLASSNAME", "None");
	control:SetUserValue("TPITEMNAME", "None");

	UPDATE_COSTUME_EXCHANGE_BASKET_MONEY(parent:GetTopParentFrame())

end

function COSTUME_EXCHANGE_TREE_CLICK(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local selectNode = ctrl:GetLastSelectedNode();
	frame:SetUserValue('COSTUME_EXCHANGE_SELECTED_CATEGORY', selectNode:GetValue());
	COSTUME_EXCHANGE_CREATE_BUY_LIST();	
end


function COSTUME_EXCHANGE_CATE_SELECT(frame, forceSelect)
	local costumeExchangeCateTree = GET_CHILD_RECURSIVELY(frame, 'costumeExchangeCateTree');
	local firstItem = costumeExchangeCateTree:FindByValue('TotalTabName');
	if firstItem == nil then
		return;
	end
	if forceSelect == true then
		costumeExchangeCateTree:Select(firstItem);
	else
		costumeExchangeCateTree:DeSelectAll();
	end
end


function TPSHOP_COSTUME_EXCHANGE_ITEM_BASKET_BUY(parent, control)
	
	local ret = COSTUME_EXCHANGESHOP_POPUPMSG_MAKE_ITEMLIST()
	if ret == true then
		ui.OpenFrame("costume_exchangeshop_popupmsg")
	end
end

function TPSHOP_COSTUME_EXCHANGE_ITEM_BASKET_BUY_CANCEL()
	ui.CloseFrame("costume_exchangeshop_popupmsg")
end

function EXEC_BUY_COSTUME_EXCHANGE_ITEM()
	local slotsetname = nil
	local itemListStr = ""
	
	slotsetname = "costume_exchange_basketbuyslotset"

	local frame = ui.GetFrame("tpitem")
	local btn = GET_CHILD_RECURSIVELY(frame,"costume_exchange_toitemBtn");
	local slotset = GET_CHILD_RECURSIVELY(frame,slotsetname)
	if slotset == nil then

		return;
	end
	local slotCount = slotset:GetSlotCount();

	local allprice = 0
    local cannotEquip = {};
	for i = 0, slotCount - 1 do
		local slotIcon	= slotset:GetIconByIndex(i);

		if slotIcon ~= nil then

			local slot  = slotset:GetSlotByIndex(i);
			local tpitemname = slot:GetUserValue("TPITEMNAME");
            local itemClassName = slot:GetUserValue('CLASSNAME');
			local item = GetClass("Item", itemClassName);
			local tpitem = GetClass("costume_exchange_shop",tpitemname)

			if tpitem ~= nil then
				-- check equip
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
		                if needJobClassName ~= nil and needJobGrade ~= nil and IS_ENABLE_EQUIP_CLASS(pc, needJobClassName, needJobGrade) == false then
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

                -- calculate price
				allprice = allprice + tpitem.BuyPrice
				if itemListStr == "" then
					itemListStr = tostring(tpitem.ClassID)
				else
					itemListStr = itemListStr .." " .. tostring(tpitem.ClassID)
				end
				
			else
				return
			end

		end
	end

	if allprice == 0 then
		return
	end

	local medal = session.GetInvItemByName("Costume_Exchange_Coupon");
	if medal == nil then
		ui.MsgBox(ScpArgMsg("MoreNeedCostumeExchangeCoupon"))
		return
	end

	if medal.count < allprice then 
		ui.MsgBox(ScpArgMsg("MoreNeedCostumeExchangeCoupon"))
		return;
	end

    if #cannotEquip > 0 then
        local clMsg = ClMsg('ExistCannotEquipItem')..'{nl}';
        for i = 1, #cannotEquip do
            local item = cannotEquip[i];
            clMsg = clMsg..'{@st66d}{s18}'..item.Name..'{/}{/}{nl}';
        end
        clMsg = clMsg..ScpArgMsg("ReallyBuy?");
        ui.MsgBox_NonNested_Ex(clMsg, 0x00000004, "tpitem_costume_exchange", "_EXEC_BUY_COSTUME_EXCHANGE_ITEM('"..itemListStr.."')", "TPSHOP_ITEM_BASKET_BUY_CANCEL");
		return;	
    end
	_EXEC_BUY_COSTUME_EXCHANGE_ITEM(itemListStr);		
end

function _EXEC_BUY_COSTUME_EXCHANGE_ITEM(itemListStr)
    pc.ReqExecuteTx_NumArgs("SCR_TX_COSTUME_EXCHANGE_BUY", itemListStr);	
	
	local frame = ui.GetFrame("tpitem");
	frame:ShowWindow(0);
	TPITEM_CLOSE(frame);
end

function COSTUME_EXCHANGE_MAKE_TREE(frame)
	local costumeExchangeCateTree = GET_CHILD_RECURSIVELY(frame, 'costumeExchangeCateTree');
	costumeExchangeCateTree:Clear();
	costumeExchangeCateTree:SetFitToChild(true,10);
	DESTROY_CHILD_BYNAME(costumeExchangeCateTree, 'CATEGORY_');
	costumeExchangeCateTree:CloseNodeAll();

	-- TODO: 추후 카테고리를 늘릴 때에는 여기 아래를 수정하면 됨. 지금은 고정된 것들만 하기로 하였음
	local firstItem = RECYCLE_CREATE_CATEGORY_ITEM(costumeExchangeCateTree, 'TotalTabName');
	COSTUME_EXCHANGE_CREATE_CATEGORY_ITEM(costumeExchangeCateTree, 'War_costume_F');
	COSTUME_EXCHANGE_CREATE_CATEGORY_ITEM(costumeExchangeCateTree, 'Wiz_costume_F');
	COSTUME_EXCHANGE_CREATE_CATEGORY_ITEM(costumeExchangeCateTree, 'Arc_costume_F');
	COSTUME_EXCHANGE_CREATE_CATEGORY_ITEM(costumeExchangeCateTree, 'Cle_costume_F');
	
	costumeExchangeCateTree:OpenNodeAll();
end


function COSTUME_EXCHANGE_CREATE_CATEGORY_ITEM(tree, key)		
	local htreeitem = tree:FindByValue(key);
	if tree:IsExist(htreeitem) == 0 then
	    htreeitem = tree:Add('{@st66}'..ScpArgMsg(key), key);
    end
    return htreeitem;
end

function TPSHOP_COSTUME_EXCHANGE_ITEMSEARCH_CLICK(parent, control, strArg, intArg)
	local editDiff = GET_CHILD(parent, "costume_exchange_editDiff");
	if editDiff == nil then
		return
	end
	 editDiff:SetVisible(0);
	 control:ClearText();
end
