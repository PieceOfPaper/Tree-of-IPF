-- changevalue_tooltip.lua

function UPDATE_ITEM_CHANGEVALUE_TOOLTIP(tooltipframe, strarg, numarg1, numarg2)

	tooltipframe = tolua.cast(tooltipframe, "ui::CTooltipFrame");
	local itemObj = GET_TOOLTIP_ITEM_OBJECT(strarg, numarg2, numarg1);

	HIDE_EX_INFO_CHANGEVALUE(tooltipframe);
	
	local isVisble = 0;
	if itemObj ~= nil then

		local targetItem = item.HaveTargetItem(); -- 타겟아이템이 뭐지?
		if targetItem == 1 and 1==0 then
		
			local luminItemIndex = item.GetTargetItem();

			local luminItem = session.GetInvItem(luminItemIndex);
			if luminItem ~= nil then
				local itemobj = GetIES(luminItem:GetObject());

				if itemobj.GroupName == 'Gem' or itemobj.GroupName == 'Card' then
					if itemobj.Usable == 'ITEMTARGET' then
						ITEM_TOOLTIP_SOCKETCHANGEVALUE(tooltipframe, itemObj, itemobj, strarg);
					end
				end
			end
		else

			if itemObj.ToolTipScp == 'WEAPON' or itemObj.ToolTipScp == 'ARMOR' then
				
					-- 한손 무기 / 방패 일 경우
				local ToolTipScp = _G[ 'ITEM_TOOLTIP_' .. itemObj.ToolTipScp..'_CHANGEVALUE'];

				local equipItem = nil;
				local equipItemObj = nil;
				
				if itemObj.EqpType == 'SH' then
					if itemObj.DefaultEqpSlot == 'RH' or itemObj.DefaultEqpSlot == 'RH LH' then
						equipItem = session.GetEquipItemBySpot(item.GetEquipSpotNum("RH"));
						equipItemObj = GetIES(equipItem:GetObject());
					elseif itemObj.DefaultEqpSlot == 'LH' then
						equipItem = session.GetEquipItemBySpot(item.GetEquipSpotNum("LH"));
						equipItemObj = GetIES(equipItem:GetObject());
					end
				-- 양손 무기 일 경우
				
				elseif itemObj.EqpType == 'DH' then
					equipItem = session.GetEquipItemBySpot(item.GetEquipSpotNum("RH"));
					equipItemObj = GetIES(equipItem:GetObject());
				else
					local equitSpot = item.GetEquipSpotNum(itemObj.EqpType);
					equipItem = session.GetEquipItemBySpot(equitSpot);
					if equipItem ~= nil then
						equipItemObj = GetIES(equipItem:GetObject());
					end
				end
				
				if equipItem ~= nil and equipItemObj ~= nil then
					if 1 == item.IsNoneItem(equipItemObj.ClassID) then
						
						tooltipframe:ForceClose();
						return;
					else
						isVisble = ToolTipScp(tooltipframe, itemObj, equipItemObj, strarg);
					end
				end
				
				if isVisble ~= 0 and strarg ~= 'equip' then
					if strarg ~= 'inven' then
						local gbox = GET_CHILD(tooltipframe,'changevalue','ui::CGroupBox')
						if gbox:GetSkinName() == 'comparisonballoon_negative' then
							gbox:SetSkinName('comparisonballoon_negative_left');
						else
							gbox:SetSkinName('comparisonballoon_positive_left');
						end
					end
					
					tooltipframe:ShowWindow(1);
				else
					
					tooltipframe:ForceClose();
					tooltipframe:ShowWindow(0);
				end
			else
			
				tooltipframe:ShowWindow(0);
			end
		end
	else
		tooltipframe:ShowWindow(0);
	end
end

function ITEM_TOOLTIP_SOCKETCHANGEVALUE(frame, invItem, socketItem, strarg)
	local socketCnt = GET_NEXT_SOCKET_SLOT_INDEX(invItem);

	-- 일단 소켓 비교 툴팁 안뜨게 변경
	if socketCnt < 0 then
		local GroupCtrl   = GET_CHILD(frame, 'changevalue', 'ui::CGroupBox');
		local cnt 			 = GroupCtrl:GetChildCount();
		local ControlSetObj	 = GroupCtrl:CreateControlSet('changevalue', "EX" .. cnt , 0, 0);
		local ControlSetCtrl = tolua.cast(ControlSetObj, 'ui::CControlSet');

		local MARGIN_BETWEEN_TITLE_N_VALUE = ControlSetCtrl:GetUserConfig("MARGIN_BETWEEN_TITLE_N_VALUE")
		local MARGIN_BETWEEN_VALUE_N_VALUE = ControlSetCtrl:GetUserConfig("MARGIN_BETWEEN_VALUE_N_VALUE")

		ControlSetCtrl:SetOffset(0, cnt * MARGIN_BETWEEN_VALUE_N_VALUE + MARGIN_BETWEEN_TITLE_N_VALUE)

		local richtextChild	 = GET_CHILD(ControlSetCtrl, 'text', 'ui::CRichText');
		richtextChild:EnableResizeByText(1);
		richtextChild:SetTextFixWidth(0);
		richtextChild:SetText(ScpArgMsg('Auto_{#050505}{s18}{b}SoKaes_JangChagSi'));
		richtextChild:SetGravity(ui.CENTER_HORZ, ui.TOP);

		local gemcls = GetClassByStrProp("Socket", "ClassName", socketItem.StringArg);
		if gemcls ~= nil then
			if socketItem.MINATK ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("MINATK").." +"..socketItem.MINATK);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.MAXATK ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("MAXATK").." +"..socketItem.MAXATK);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.STR ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("STR").." +"..socketItem.STR);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.DEX ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("DEX").." +"..socketItem.DEX);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.INT ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("INT").." +"..socketItem.INT);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.CON ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("CON").." +"..socketItem.CON);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.MHP ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("MHP").." +"..socketItem.MHP);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.MSP ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("MSP").." +"..socketItem.MSP);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.CRTHR ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("CRTHR").." +"..socketItem.CRTHR);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			--[[
			if socketItem.CRTATK ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("CRTATK").." +"..socketItem.CRTATK);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.HR ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("HR").." +"..socketItem.HR);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end
			]]

			if socketItem.SR ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("SR").." +"..socketItem.SR);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.RSTA ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("RSTA").." +"..socketItem.RSTA);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.SkillPower ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("SkillPower").." +"..socketItem.SkillPower);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.Aries_Range ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("Aries_Range").." +"..socketItem.Aries_Range);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.Slash_Range ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("Slash_Range").." +"..socketItem.Slash_Range);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.Strike_Range ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("Strike_Range").." +"..socketItem.Strike_Range);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.SkillRange ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("SkillRange").." +"..socketItem.SkillRange);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

            if socketItem.SkillWidthRange ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("SkillWidthRange").." +"..socketItem.SkillWidthRange);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.SkillAngle ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("SkillAngle").." +"..socketItem.SkillAngle);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.BlockRate ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("BlockRate").." +"..socketItem.BlockRate);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.HitCount ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("HitCount").." +"..socketItem.HitCount);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end

			if socketItem.BackHit ~= 0 then
				local newtxt = string.format("{#050505}{s18}{b}%s", ScpArgMsg("BackHit").." +"..socketItem.BackHit);
				CREATE_SOCKETCHANGEVALUE_TEXT(GroupCtrl, newtxt);
			end
		end

		local cnt = GroupCtrl:GetChildCount();
		local lastChild = GroupCtrl:GetChild(cnt - 1);

	else
		frame:Resize(frame:GetOriginalWidth(),frame:GetOriginalHeight());
		frame:ShowWindow(0);
	end
end

function CREATE_SOCKETCHANGEVALUE_TEXT(groupBox, valueText)
	local cnt 					= groupBox:GetChildCount();
	local ControlSetObj			= groupBox:CreateControlSet('changevalue', "EX" .. cnt , 0, 0);
	local ControlSetCtrl		= tolua.cast(ControlSetObj, 'ui::CControlSet');

	local MARGIN_BETWEEN_TITLE_N_VALUE = ControlSetCtrl:GetUserConfig("MARGIN_BETWEEN_TITLE_N_VALUE")
	local MARGIN_BETWEEN_VALUE_N_VALUE = ControlSetCtrl:GetUserConfig("MARGIN_BETWEEN_VALUE_N_VALUE")

	ControlSetCtrl:SetOffset(0, cnt * MARGIN_BETWEEN_VALUE_N_VALUE + MARGIN_BETWEEN_TITLE_N_VALUE)

	local richtextChild	 		= GET_CHILD(ControlSetCtrl, 'text', 'ui::CRichText');
	richtextChild:SetText(valueText);
	
end

function ITEM_TOOLTIP_WEAPON_CHANGEVALUE(frame, invitem, equipItem, strarg, ispickitem)

	if IS_NO_EQUIPITEM(equipItem) == 0 then
		local ypos = DRAW_EQUIP_CHANGE_WEAPON_TOOLTIP(frame, invitem, equipItem, ypos, ispickitem);
		return ypos;
	else
		local ypos = DRAW_UNEQUIP_CHANGE_WEAPON_TOOLTIP(frame, invitem, ypos, ispickitem);
		return ypos;
	end
end

function ITEM_TOOLTIP_ARMOR_CHANGEVALUE(tooltipframe, invitem, equipItem, strarg, ispickitem)

	if IS_NO_EQUIPITEM(equipItem) == 0 then
		local ypos = DRAW_EQUIP_CHANGE_ARMOR_TOOLTIP(tooltipframe, invitem, equipItem, ypos, ispickitem);
		return ypos;
	else
		local ypos = DRAW_UNEQUIP_CHANGE_ARMOR_TOOLTIP(tooltipframe, invitem, ypos, ispickitem);
		return ypos;
	end
end

function DRAW_APPRAISAL_PICTURE(tooltipframe)
	local GroupCtrl   = tooltipframe:GetChild('appraisal');
	local cnt 			 = GroupCtrl:GetChildCount();
	local ControlSetObj	 = GroupCtrl:CreateControlSet('appralsal', "EX" .. cnt , 0, 0);
	local ControlSetCtrl = tolua.cast(ControlSetObj, 'ui::CControlSet');

	local X_MARGIN_OF_TITLE = ControlSetCtrl:GetUserConfig("X_MARGIN_OF_TITLE")
	local Y_MARGIN_OF_TITLE = ControlSetCtrl:GetUserConfig("Y_MARGIN_OF_TITLE")
	local MARGIN_BETWEEN_VALUE_N_VALUE = ControlSetCtrl:GetUserConfig("MARGIN_BETWEEN_VALUE_N_VALUE")

	ControlSetCtrl:SetOffset(X_MARGIN_OF_TITLE, cnt * MARGIN_BETWEEN_VALUE_N_VALUE + Y_MARGIN_OF_TITLE)

	local pic	 = GET_CHILD(ControlSetCtrl, "pic", "ui::CPicture");
	pic:SetImage("USsentiment_top");
	local equipchange = tolua.cast(GroupCtrl, 'ui::CGroupBox');
	local cnt = equipchange:GetChildCount();
	local width = equipchange:GetWidth();
	if cnt > 0 then
		width = -1;
		for i = 0 , cnt - 1 do
			local obj = equipchange:GetChildByIndex(i);
			width = math.max(width, obj:GetWidth() + 50);
		end
	end

	local lastChild = equipchange:GetChild("EX" .. cnt-1)
	local lastHeight = lastChild:GetY() + lastChild:GetHeight();
	equipchange:Resize(width, lastHeight)
	tooltipframe:Resize(width, lastHeight);
end

function DRAW_EQUIP_CHANGE_WEAPON_TOOLTIP(tooltipframe, invitem, equipItem, ypos, ispickitem)
	local GroupCtrl   = tooltipframe:GetChild('changevalue');
	local equipchange = tolua.cast(GroupCtrl, 'ui::CGroupBox');

	local cnt 			 = GroupCtrl:GetChildCount();
	local ControlSetObj	 = GroupCtrl:CreateControlSet('changevalue', "EX" .. cnt , 0, 0);
	local ControlSetCtrl = tolua.cast(ControlSetObj, 'ui::CControlSet');

	local X_MARGIN_OF_TITLE = ControlSetCtrl:GetUserConfig("X_MARGIN_OF_TITLE")
	local Y_MARGIN_OF_TITLE = ControlSetCtrl:GetUserConfig("Y_MARGIN_OF_TITLE")
	local MARGIN_BETWEEN_VALUE_N_VALUE = ControlSetCtrl:GetUserConfig("MARGIN_BETWEEN_VALUE_N_VALUE")

	ControlSetCtrl:SetOffset(X_MARGIN_OF_TITLE, cnt * MARGIN_BETWEEN_VALUE_N_VALUE + Y_MARGIN_OF_TITLE)

	local richtextChild	 = GET_CHILD(ControlSetCtrl, "changetext", "ui::CRichText");
	richtextChild:SetText(ScpArgMsg('Auto_{#050505}{s22}{b}JangBi_KyoCheSi'));
    
    local list = GET_ATK_PROP_CHANGEVALUETOOLTIP_LIST();
    
    if ispickitem == 1 then
        list = GET_ATK_PICK_PROP_LIST();
	end
	ABILITY_CHANGEVALUE_SKINSET(tooltipframe, "WEAPON", invitem, equipItem);
	return COMPARISON_BY_PROPLIST(list, invitem, equipItem, tooltipframe, equipchange, ispickitem);

end

function DRAW_UNEQUIP_CHANGE_WEAPON_TOOLTIP(tooltipframe, invitem, ypos, ispickitem)

	local GroupCtrl   = tooltipframe:GetChild('changevalue');
	--GroupCtrl:SetSkinName("comparisonballoon_positive");
	local equipchange = tolua.cast(GroupCtrl, 'ui::CGroupBox');

	local cnt 			 = GroupCtrl:GetChildCount();
	local ControlSetObj	 = GroupCtrl:CreateControlSet('changevalue', "EX" .. cnt , 0, 0);
	local ControlSetCtrl = tolua.cast(ControlSetObj, 'ui::CControlSet');

	local X_MARGIN_OF_TITLE = ControlSetCtrl:GetUserConfig("X_MARGIN_OF_TITLE")
	local Y_MARGIN_OF_TITLE = ControlSetCtrl:GetUserConfig("Y_MARGIN_OF_TITLE")
	local MARGIN_BETWEEN_VALUE_N_VALUE = ControlSetCtrl:GetUserConfig("MARGIN_BETWEEN_VALUE_N_VALUE")

	ControlSetCtrl:SetOffset(X_MARGIN_OF_TITLE, cnt * MARGIN_BETWEEN_VALUE_N_VALUE + Y_MARGIN_OF_TITLE)

	local richtextChild	 = ControlSetCtrl:GetChild('changetext');
	tolua.cast(richtextChild, "ui::CRichText");
	
	richtextChild:SetText(ScpArgMsg('Auto_{#050505}{s22}{b}JangBi_KyoCheSi'));
	richtextChild:Invalidate()

	local list = GET_ATK_PROP_CHANGEVALUETOOLTIP_LIST();

	ABILITY_CHANGEVALUE_SKINSET(tooltipframe, "WEAPON", invitem, equipItem);
	return COMPARISON_BY_PROPLIST(list, invitem, nil, tooltipframe, equipchange, ispickitem);

end

function DRAW_EQUIP_CHANGE_ARMOR_TOOLTIP(tooltipframe, invitem, equipItem, ypos, ispickitem)

	local GroupCtrl = tooltipframe:GetChild('changevalue');
	local equipchange = tolua.cast(GroupCtrl, 'ui::CGroupBox');

	local cnt = GroupCtrl:GetChildCount();
	local ControlSetObj			= GroupCtrl:CreateControlSet('changevalue', "EX" .. cnt , 0, 0);
	local ControlSetCtrl		= tolua.cast(ControlSetObj, 'ui::CControlSet');

	local X_MARGIN_OF_TITLE = ControlSetCtrl:GetUserConfig("X_MARGIN_OF_TITLE")
	local Y_MARGIN_OF_TITLE = ControlSetCtrl:GetUserConfig("Y_MARGIN_OF_TITLE")
	local MARGIN_BETWEEN_VALUE_N_VALUE = ControlSetCtrl:GetUserConfig("MARGIN_BETWEEN_VALUE_N_VALUE")

	ControlSetCtrl:SetOffset(X_MARGIN_OF_TITLE, cnt * MARGIN_BETWEEN_VALUE_N_VALUE + Y_MARGIN_OF_TITLE)

	local richtextChild	 = ControlSetCtrl:GetChild('changetext');
	tolua.cast(richtextChild, "ui::CRichText");
	local parent = richtextChild:GetParent();
	
	richtextChild:SetText(ScpArgMsg('Auto_{#050505}{s22}{b}JangBi_KyoCheSi'));
	
	ABILITY_CHANGEVALUE_SKINSET(tooltipframe, "ARMOR", invitem, equipItem);

	local list = GET_DEF_PROP_CHANGEVALUETOOLTIP_LIST();
	return COMPARISON_BY_PROPLIST(list, invitem, equipItem, tooltipframe, equipchange, ispickitem);

end

function DRAW_UNEQUIP_CHANGE_ARMOR_TOOLTIP(tooltipframe, invitem, ypos)
	
	local GroupCtrl = tooltipframe:GetChild('changevalue');
	--GroupCtrl:SetSkinName("comparisonballoon_positive");
	local equipchange = tolua.cast(GroupCtrl, 'ui::CGroupBox');

	local cnt = GroupCtrl:GetChildCount();
	local ControlSetObj			= GroupCtrl:CreateControlSet('changevalue', "EX" .. cnt , 0, 0);
	local ControlSetCtrl		= tolua.cast(ControlSetObj, 'ui::CControlSet');

	local X_MARGIN_OF_TITLE = ControlSetCtrl:GetUserConfig("X_MARGIN_OF_TITLE")
	local Y_MARGIN_OF_TITLE = ControlSetCtrl:GetUserConfig("Y_MARGIN_OF_TITLE")
	local MARGIN_BETWEEN_VALUE_N_VALUE = ControlSetCtrl:GetUserConfig("MARGIN_BETWEEN_VALUE_N_VALUE")

	ControlSetCtrl:SetOffset(X_MARGIN_OF_TITLE, cnt * MARGIN_BETWEEN_VALUE_N_VALUE + Y_MARGIN_OF_TITLE)

	local richtextChild	 = ControlSetCtrl:GetChild('changetext');
	tolua.cast(richtextChild, "ui::CRichText");
	local parent = richtextChild:GetParent();
	
	richtextChild:SetText(ScpArgMsg('Auto_{#050505}{s22}{b}JangBi_KyoCheSi'));

	ABILITY_CHANGEVALUE_SKINSET(tooltipframe, "ARMOR", invitem, equipItem);

	local list = GET_DEF_PROP_CHANGEVALUETOOLTIP_LIST();
	return COMPARISON_BY_PROPLIST(list, invitem, nil, tooltipframe, equipchange, ispickitem);

end