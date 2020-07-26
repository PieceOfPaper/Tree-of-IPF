-- ENCHANTCHIP.lua --

function CLIENT_ENCHANTCHIP(invItem)
	local mapCls = GetClass("Map", session.GetMapName());
	if nil == mapCls then
		return;
	end

	if 'City' ~= mapCls.MapType then
		ui.SysMsg(ClMsg("AllowedInTown"));
		return;
	end

	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	local obj = GetIES(invItem:GetObject());
	if 0 == IS_ENCHANT_ITEM(obj) then
		return;
	end
	
	-- check life time of enchant item
	if TryGetProp(obj, "LifeTime") > 0 and TryGetProp(obj, "ItemLifeTimeOver") > 0 then
		return
	end

	HAIRENCHANT_UI_RESET();
	local itemHaveCount = GET_INV_ITEM_COUNT_BY_CLASSID(obj.ClassID);

	local enchantFrame = ui.GetFrame("hairenchant");
	local invframe = ui.GetFrame("inventory");
	invframe:ShowWindow(1);
	enchantFrame:ShowWindow(1);
	enchantFrame:SetMargin(0, 65, invframe:GetWidth(), 0);
	enchantFrame:SetUserValue("Enchant", invItem:GetIESID());
	local cnt = enchantFrame:GetChild("scrollCnt");
	cnt:SetTextByKey("value", itemHaveCount);
	
	ui.SetEscapeScp("CANCEL_ENCHANTCHIP()");

	SET_SLOT_APPLY_FUNC(invframe, "CHECK_ENCHANTCHIP_TARGET_ITEM", nil, "Equip");
	local tab = GET_CHILD_RECURSIVELY(invframe, "inventype_Tab");
	tolua.cast(tab, "ui::CTabControl");
	tab:SelectTab(1);

	if obj.ClassName == 'STEAM_MASTER_Premium_Enchantchip' then
		local text1 = enchantFrame:GetChild("richtext_1")
		tolua.cast(text1, "ui::CRichText");
		text1:SetText(obj.Name)

		local text2 = enchantFrame:GetChild("richtext_2")
		tolua.cast(text2, "ui::CRichText");
		text2:SetTextByKey("value", obj.Name)

		local close = enchantFrame:GetChild("close")
		tolua.cast(close, "ui::CRichText");
		close:SetTextTooltip(ClMsg("master_hairenchant_close"));
	else
		local text1 = GET_CHILD_RECURSIVELY(enchantFrame, "richtext_1")
		tolua.cast(text1, "ui::CRichText");
		text1:SetText(obj.Name);

		-- 마법 부여 스크롤(거래불가) 부분 처리
		local bg = GET_CHILD_RECURSIVELY(enchantFrame, "bg");
		if obj ~= nil and obj.ClassName == "Premium_Enchantchip_CT" and text1:GetLineCount() > 1 then	
			if bg ~= nil then
				bg:SetSkinName("test_Item_tooltip_equip_sub");
				
				local bg_title = bg:CreateControl("groupbox", "bg_title", 0, 5, bg:GetWidth() - 10, 60);
				if bg_title ~= nil then
					bg_title:SetVisible(1);
					bg_title:SetSkinName("magic_give_scroll_title");
					bg_title:SetGravity(ui.CENTER_HORZ, ui.TOP);
				end
				
				local closeBtn = GET_CHILD_RECURSIVELY(enchantFrame, "close");
				if closeBtn ~= nil then
					closeBtn:SetOffset(8, 10);
				end

				local slot = GET_CHILD_RECURSIVELY(enchantFrame, "slot");
				if slot ~= nil then
					slot:SetOffset(0, 98);
				end

				enchantFrame:Invalidate();
			end
		elseif obj ~= nil and obj.ClassName == "Premium_Enchantchip_CT" and  text1:GetLineCount() <= 1 then
			local bg_title = GET_CHILD_RECURSIVELY(bg, "bg_title");
			if bg_title ~= nil then
				bg_title:RemoveChild("bg_title");
				bg:SetSkinName("test_Item_tooltip_equip");

				local closeBtn = GET_CHILD_RECURSIVELY(enchantFrame, "close");
				if closeBtn ~= nil then
					closeBtn:SetOffset(10, 8);
				end

				local slot = GET_CHILD_RECURSIVELY(enchantFrame, "slot");
				if slot ~= nil then
					slot:SetOffset(0, 70);
				end

				enchantFrame:Invalidate();
			end
		end

		local text2 = GET_CHILD_RECURSIVELY(enchantFrame, "richtext_2")
		tolua.cast(text2, "ui::CRichText");
		text2:SetTextByKey("value", obj.Name)	

		local close = enchantFrame:GetChild("close")
		tolua.cast(close, "ui::CRichText");
		close:SetTextTooltip(ClMsg("hairenchant_close"));
	end

	SET_INV_LBTN_FUNC(invframe, "ENCHANTCHIP_LBTN_CLICK");
	ui.GuideMsg("SelectItem");
	CHANGE_MOUSE_CURSOR("MORU", "MORU_UP", "CURSOR_CHECK_ENCHANTCHIP");
end


function CANCEL_ENCHANTCHIP()
	SET_MOUSE_FOLLOW_BALLOON(nil);
	ui.RemoveGuideMsg("SelectItem");
	SET_MOUSE_FOLLOW_BALLOON();
	ui.SetEscapeScp("");
	HAIRENCHANT_UI_RESET();
	local invframe = ui.GetFrame("inventory");
	SET_SLOT_APPLY_FUNC(invframe, "None");
	SET_INV_LBTN_FUNC(invframe, "None");
	RESET_MOUSE_CURSOR();
end

function CURSOR_CHECK_ENCHANTCHIP(slot)
	local item = GET_SLOT_ITEM(slot);
	if item == nil then
		return 0;
	end
	
	if nil ~= session.GetEquipItemByGuid(item:GetIESID()) then
		return 0;
	end

	local obj = GetIES(item:GetObject());
	return ENCHANTCHIP_ABLIE(obj);
end

function CHECK_ENCHANTCHIP_TARGET_ITEM(slot)
	local item = GET_SLOT_ITEM(slot);
	if nil == item then
		return;
	end

	local obj = GetIES(item:GetObject());
	if ENCHANTCHIP_ABLIE(obj) == 1 then
		slot:GetIcon():SetGrayStyle(0);
		slot:SetBlink(60000, 2.0, "FFFFFF00", 1);
	else
		slot:GetIcon():SetGrayStyle(1);
		slot:ReleaseBlink();
	end
end

function ENCHANTCHIP_LBTN_CLICK(frame, invItem)
	local enchantFrame = ui.GetFrame("hairenchant");
	local slot = enchantFrame:GetChild("slot");
	slot  = tolua.cast(slot, 'ui::CSlot');
	HAIRENCHANT_DRAW_HIRE_ITEM(slot, invItem);
end