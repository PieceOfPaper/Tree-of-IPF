 -- comparsion_tooltip.lua

 -- whole functions of this file has been integrated in UPDATE_ITEM_TOOLTIP() function.

 --[[

 function UPDATE_ITEM_COMPARISON_TOOLTIP(tooltipframe, strarg, numarg1, numarg2)

	local itemObj, isReadObj  = GET_TOOLTIP_ITEM_OBJECT(strarg, numarg2, numarg1);

	HIDE_EX_INFO_COMPARITION(tooltipframe);

	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local ToolTipScp = _G[ 'ITEM_TOOLTIP_' .. itemObj.ToolTipScp..'_COMPARISON'];

	-- 툴팁 비교는 무기와 장비에만 해당된다.
	if itemObj.ToolTipScp == 'WEAPON' or itemObj.ToolTipScp == 'ARMOR' then
	    -- 한손 무기 / 방패 일 경우
		
		if itemObj.EqpType == 'SH' then
		
			if itemObj.DefaultEqpSlot == 'RH' or itemObj.DefaultEqpSlot == 'RH LH' then
				
				local item = session.GetEquipItemBySpot( item.GetEquipSpotNum("RH") );
				local equipItem = GetIES(item:GetObject());
				
				if equipItem.ClassName == 'NoWeapon' then
				
					tooltipframe:Resize(tooltipframe:GetOriginalWidth(),tooltipframe:GetOriginalHeight());
					tooltipframe:ShowWindow(0);

					subframe = ui.GetFrame("additionaltooltip2");
					if subframe ~= nil then
						subframe:ShowWindow(0)
					end
				
				end
				local classtype = TryGetProp(equipItem, "ClassType"); -- 코스튬은 안뜨도록
				if classtype ~= nil then
					if classtype == "Outer" then
						tooltipframe:Resize(tooltipframe:GetOriginalWidth(),tooltipframe:GetOriginalHeight());
						tooltipframe:ShowWindow(0);

						subframe = ui.GetFrame("additionaltooltip2");
						if subframe ~= nil then
							subframe:ShowWindow(0)
						end
					end
				end

				
				
				ToolTipScp(tooltipframe, itemObj, equipItem, strarg);
				
				ITEM_COMPARISON_SET_OFFSET(tooltipframe, isReadObj);
				

			elseif itemObj.DefaultEqpSlot == 'LH' then
			
				local item = session.GetEquipItemBySpot( item.GetEquipSpotNum("LH") );
				local equipItem = GetIES(item:GetObject());

				if equipItem.ClassName == 'NoWeapon' then
					tooltipframe:Resize(tooltipframe:GetOriginalWidth(),tooltipframe:GetOriginalHeight());
					tooltipframe:ShowWindow(0);

					subframe = ui.GetFrame("additionaltooltip2");
					if subframe ~= nil then
						subframe:ShowWindow(0)
					end
				end

				ToolTipScp(tooltipframe, itemObj, equipItem, strarg);
				ITEM_COMPARISON_SET_OFFSET(tooltipframe, isReadObj);
			end
			
		-- 양손 무기 일 경우
		elseif itemObj.EqpType == 'DH' then
			
			local item = session.GetEquipItemBySpot(item.GetEquipSpotNum("RH"));
			local equipItem = GetIES(item:GetObject());

			if equipItem.ClassName == 'NoWeapon' then
				tooltipframe:Resize(tooltipframe:GetOriginalWidth(),tooltipframe:GetOriginalHeight());
				tooltipframe:ShowWindow(0);

				subframe = ui.GetFrame("additionaltooltip2");
				if subframe ~= nil then
					subframe:ShowWindow(0)
				end
			end

			ToolTipScp(tooltipframe, itemObj, equipItem, strarg);
			ITEM_COMPARISON_SET_OFFSET(tooltipframe, isReadObj);
		else
			local equitSpot = item.GetEquipSpotNum(itemObj.EqpType);
			local item = session.GetEquipItemBySpot(equitSpot);
			if item ~= nil then
				local equipItem = GetIES(item:GetObject());

				if equipItem.ClassName == 'NoWeapon' then
					tooltipframe:Resize(tooltipframe:GetOriginalWidth(),tooltipframe:GetOriginalHeight());
					tooltipframe:ShowWindow(0);

					subframe = ui.GetFrame("additionaltooltip2");
					if subframe ~= nil then
						subframe:ShowWindow(0)
					end
				end

				ToolTipScp(tooltipframe, itemObj, equipItem, strarg);
				ITEM_COMPARISON_SET_OFFSET(tooltipframe, isReadObj);
			else
				tooltipframe:ShowWindow(0);

				subframe = ui.GetFrame("additionaltooltip2");
				if subframe ~= nil then
					subframe:ShowWindow(0)
				end
			end
		end
	else
		tooltipframe:ShowWindow(0);

		subframe = ui.GetFrame("additionaltooltip2");
		if subframe ~= nil then
			subframe:ShowWindow(0)
		end
	end
	
	if strarg == 'equip' then
		tooltipframe:Resize(tooltipframe:GetOriginalWidth(),tooltipframe:GetOriginalHeight());
		tooltipframe:ShowWindow(0);

		subframe = ui.GetFrame("additionaltooltip2");
		if subframe ~= nil then
			subframe:ShowWindow(0)
		end
	end
	
	local targetItem = item.HaveTargetItem();
	if targetItem == 1 then
		local luminItemIndex = item.GetTargetItem();

		local luminItem = session.GetInvItem(luminItemIndex);
		if luminItem ~= nil then
			local itemobj = GetIES(luminItem:GetObject());

			if itemobj.GroupName == 'Gem' or itemobj.GroupName == 'Card' then
				if itemobj.Usable == 'ITEMTARGET' then
					tooltipframe:Resize(tooltipframe:GetOriginalWidth(),tooltipframe:GetOriginalHeight());
					tooltipframe:ShowWindow(0);

					subframe = ui.GetFrame("additionaltooltip2");
					if subframe ~= nil then
						subframe:ShowWindow(0)
					end
				end
			end
		end
	end
	
	if isReadObj == 1 then
		DestroyIES(itemObj);
	end
 end

 function ITEM_TOOLTIP_WEAPON_COMPARISON(frame, invitem, equipItem, strarg)

 	if equipItem.ClassName ~= 'NoWeapon' then
		ITEM_TOOLTIP_EQUIP(frame, equipItem, strarg, "comparison");
		frame:ShowWindow(1);
	else
		frame:ShowWindow(0);
	end
end

function ITEM_TOOLTIP_ARMOR_COMPARISON(frame, invitem, equipItem, strarg)

	if IS_NO_EQUIPITEM(equipItem) == 0 then
		ITEM_TOOLTIP_EQUIP(frame, equipItem, strarg, "comparison");
		frame:ShowWindow(1);
	else
		frame:ShowWindow(0);
	end
end
]]