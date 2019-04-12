-- reinforce_by_mix.lua

function REINFORCE_BY_MIX_ON_INIT(addon, frame)

	addon:RegisterMsg("ITEM_EXP_STOP", "REINFORCE_MIX_ITEM_EXP_STOP");
	addon:RegisterMsg("ITEM_EXPUP_END", "REINFORCE_MIX_ITEM_EXPUP_END");

end

function GET_MAT_SLOT(frame)
	local box_material = frame:GetChild("box_material");
	local box_slot = box_material:GetChild("box_slot");
	return GET_CHILD(box_slot, "matslot", "ui::CSlotSet");
end

function CLEAR_REINFORCE_BY_MIX(frame)
	frame:StopUpdateScript("REINF_MIX_UPDATE_EXP_UP");
	local matslot = GET_MAT_SLOT(frame);
	matslot:ShowWindow(0);
	local box_item = frame:GetChild("box_item");
	local box_stats = box_item:GetChild("box_stats");
	box_stats:RemoveAllChild();
	local itemname = box_item:GetChild("itemname");
	itemname:SetTextByKey("value", ScpArgMsg("DragItemToReinforce"));
	local startext = box_item:GetChild("startext");
	startext:SetText("");
	local item_pic = GET_CHILD(box_item, "item_pic", "ui::CSlot");
	item_pic:ShowWindow(0);
	local gauge_exp = GET_CHILD(box_item, "gauge_exp", "ui::CGauge");
	gauge_exp:ShowWindow(0);
	local title_gauge = box_item:GetChild("title_gauge");
	title_gauge:ShowWindow(0);
	local exp_plus = box_item:GetChild("exp_plus");
	exp_plus:ShowWindow(0);

	local box_stats_gem = box_item:GetChild("box_stats_gem");
	box_stats_gem:ShowWindow(0)
	
	local box_material = frame:GetChild("box_material");
	local sel_item_count = box_material:GetChild("sel_item_count");
	sel_item_count:ShowWindow(0);
	

	local reinforceClsName = frame:GetUserValue("REINFORCE_CLS");
	local reinforceCls = GetClass("Reinforce", reinforceClsName);
	if reinforceCls ~= nil then
		INVENTORY_SET_ICON_SCRIPT("REINF_MIX_RECOVER_ICON");
		frame:SetUserValue("REINFORCE_CLS", "None");
	end
	
	INVENTORY_SET_CUSTOM_RBTNDOWN("REINFORCE_MIX_RBTN");
	INVENTORY_SET_CUSTOM_RDBTNDOWN("None");
	INVENTORY_SET_ICON_SCRIPT("None");
end

function CLOSE_REINFORCE_BY_MIX(frame)
	CLEAR_REINFORCE_BY_MIX(frame);
	INVENTORY_SET_CUSTOM_RBTNDOWN("None");
	ui.CloseFrame("inventory");
end

function OPEN_REINFORCE_BY_MIX(frame)
	frame:SetUserValue("EXECUTE_REINFORCE", 0);
	CLEAR_REINFORCE_BY_MIX(frame);
	ui.OpenFrame("inventory");
end

function REINFORCE_MIX_DROP(frame, icon, argStr, argNum)
	local liftIcon 				= ui.GetLiftIcon();
	local FromFrame 			= liftIcon:GetTopParentFrame();
	frame = frame:GetTopParentFrame();
	if FromFrame:GetName() == 'inventory' then

		imcSound.PlaySoundEvent("sys_jam_slot_equip");

		local iconInfo = liftIcon:GetInfo();
		local guid = iconInfo:GetIESID();
		local invItem = GET_ITEM_BY_GUID(guid);

		local obj = GetIES(invItem:GetObject());
		if IS_KEY_ITEM(obj) == true or IS_KEY_MATERIAL(obj) == true or obj.ItemLifeTimeOver ~= 0 then
			ui.SysMsg(ClMsg("CanNotBeUsedMaterial"));
			return;
		end
		local lv = GET_ITEM_LEVEL(obj);
		REINFORCE_BY_MIX_SETITEM(frame, invItem)
	end
end

function REINFORCE_MIX_RBTN(itemObj, slot)    
	if IS_KEY_ITEM(itemObj) == true or IS_KEY_MATERIAL(itemObj) == true or itemObj.ItemLifeTimeOver ~= 0 then
		ui.SysMsg(ClMsg("CanNotBeUsedMaterial"));
		return;
	end
		
	local frame = ui.GetFrame("reinforce_by_mix");
	
	local icon = slot:GetIcon()
	local iconInfo = icon:GetInfo();
	local guid = iconInfo:GetIESID();
	local invItem = GET_ITEM_BY_GUID(guid);
	local obj = GetIES(invItem:GetObject());
	local lv = GET_ITEM_LEVEL(obj);
	REINFORCE_BY_MIX_SETITEM(frame, invItem)

end

function REINFORCE_BY_MIX_UPDATE_STAT(box_item, obj, nextObj, statName)
	local ctrlSet = box_item:GetChild("stat_" .. statName);
	if ctrlSet ~= nil then
		ctrlSet:ShowWindow(1);
		local title = ctrlSet:GetChild("title");
		local from = ctrlSet:GetChild("from");
		local indicator = ctrlSet:GetChild("indicator");
		local to = ctrlSet:GetChild("to");
		title:SetTextByKey("value", ClMsg(statName));
		local propValue = obj[statName];
		from:SetTextByKey("value", propValue);
		ctrlSet:SetUserValue("_PROP_VALUE", propValue);
		if nextObj == nil or nextObj.Level == obj.Level then
			to:ShowWindow(0);
			indicator:ShowWindow(0);
		else
			to:ShowWindow(1);
			indicator:ShowWindow(1);
			to:SetTextByKey("value", nextObj[statName]);
		end
	end
end

function REINFORCE_MIX_UPDATE_ITEM_STATS(frame, obj, nextObj)
	local starsize = frame:GetUserConfig("STAR_TEXT_SIZE")
	local startextrtext = GET_CHILD_RECURSIVELY(frame, 'startext','ui::CRichText');
	local objstartext = GET_ITEM_STAR_TXT(obj,starsize);

	if nextObj ~= nil then
		
		local nextobjstartext = GET_ITEM_STAR_TXT(nextObj,starsize);
		if objstartext ~= nextobjstartext then			
			startextrtext:SetText(objstartext.." {img white_right_arrow 16 16} "..nextobjstartext..'{/}');	
		end
	else
		startextrtext:SetText(objstartext);	
	end
		
	local gauge_exp = GET_CHILD_RECURSIVELY(frame, "gauge_exp", "ui::CGauge");

	if 1 == gauge_exp:IsTimeProcessing() then
		return;
	end
	
	local lv, curExp, maxExp = GET_ITEM_LEVEL_EXP(obj);
	
	if curExp > maxExp then
		curExp = maxExp;
	end
	gauge_exp:SetPoint(curExp, maxExp);
	gauge_exp:ShowWindow(1);
	
	local title_gauge = GET_CHILD_RECURSIVELY(frame, "title_gauge", "ui::CRichText");
	title_gauge:ShowWindow(1);


	if obj.GroupName == "Gem" then
		local box_stats_gem = GET_CHILD_RECURSIVELY(frame,'box_stats_gem','ui::CGroupBox')
		box_stats_gem:ShowWindow(1)
		local inner_yPos = 0;
		local innerCSet = nil
		local innerpropcount = 0
		local innerpropypos = 0

		local propNameList = GET_ITEM_PROP_NAME_LIST(obj)
		local nextobjpropNameList = nil 
		if nextObj ~= nil then
			nextobjpropNameList = GET_ITEM_PROP_NAME_LIST(nextObj)
		end

		for i = 1 , #propNameList do

			local title = propNameList[i]["Title"];
			local propName = propNameList[i]["PropName"];
			local propValue = propNameList[i]["PropValue"];
			local propOptDesc = propNameList[i]["OptDesc"];
			local useOperator = propNameList[i]["UseOperator"];

			local nextPropValue = nil
			if nextObj ~= nil then
				nextPropValue = nextobjpropNameList[i]["PropValue"];
			end
		
			if title ~= nil then
				innerCSet = box_stats_gem:CreateOrGetControlSet('each_gem_property_for_gemreinforceui', title, 0, inner_yPos); 
				DESTROY_CHILD_BYNAME(innerCSet, 'proptext');
				local type_text = GET_CHILD(innerCSet,'type_text','ui::CRichText')
				type_text:SetText( ScpArgMsg(title) )
				local type_icon = GET_CHILD(innerCSet,'type_icon','ui::CPicture')
				local imgname = GET_ICONNAME_BY_WHENEQUIPSTR(frame,title)
				type_icon:SetImage( imgname )
				innerpropcount = 0
				innerpropypos = type_text:GetHeight()+type_text:GetY()
			
			else
				local type_text = GET_CHILD(innerCSet,'type_text','ui::CRichText')

				innerInnerCSet = innerCSet:CreateOrGetControlSet('each_gem_property_each_text_for_gemreinforceui', 'proptext'..innerpropcount, 0, innerpropypos);
			
				local realtext = nil
				local realtext_nextobj = nil
				if propName == "CoolDown" then
					propValue = propValue / 1000;
					realtext = ScpArgMsg("CoolDown : {Sec} Sec", "Sec", propValue);

					if nextPropValue ~= nil then
						nextPropValue = nextPropValue / 1000;
						if propValue ~= nextPropValue then
							realtext_nextobj = "{img white_right_arrow 12 12}".. ScpArgMsg("CoolDown : {Sec} Sec", "Sec", nextPropValue);
						end
					end
				elseif propName == "OptDesc" then
					realtext = propOptDesc
				else
					if useOperator ~= nil and propValue > 0 then
						realtext = ScpArgMsg(propName) .. " : " .."{img green_up_arrow 16 16}".. propValue;
						
						if nextPropValue ~= nil then
							if propValue ~= nextPropValue then
								realtext_nextobj = "{img white_right_arrow 12 12}    ".."{img green_up_arrow 16 16}".. nextPropValue;
							end
						end

					else
						realtext = ScpArgMsg(propName) .. " : " .."{img red_down_arrow 16 16}".. propValue;

						if nextPropValue ~= nil then
							if propValue ~= nextPropValue then
								realtext_nextobj = "{img white_right_arrow 12 12}    ".."{img red_down_arrow 16 16}".. nextPropValue;
							end
						end
					end
				end
			
				local proptext = GET_CHILD(innerInnerCSet,'prop_text','ui::CRichText')
				
				proptext:SetText( realtext )
				
				local prop_text_addval = GET_CHILD(innerInnerCSet,'prop_text_addval','ui::CRichText')
				if realtext_nextobj ~= nil then
					prop_text_addval:SetText( realtext_nextobj )
				else
					prop_text_addval:SetText('')
				end
				
				innerpropcount = innerpropcount + 1
			
				tolua.cast(innerCSet, "ui::CControlSet");
				local BOTTOM_MARGIN = innerCSet:GetUserConfig("BOTTOM_MARGIN")

				if BOTTOM_MARGIN == 'None' then
					BOTTOM_MARGIN = 10
				end

				innerpropypos = innerInnerCSet:GetY() + innerInnerCSet:GetHeight() 
				innerCSet:Resize(innerCSet:GetOriginalWidth(), innerInnerCSet:GetY() + innerInnerCSet:GetHeight() + BOTTOM_MARGIN )
				inner_yPos = innerCSet:GetY() + innerCSet:GetHeight()
			
			end

		
		end
	
		
	else
		local box_item = frame:GetChild("box_item");
		REINFORCE_BY_MIX_UPDATE_STAT(box_item, obj, nextObj, "Level");

		local box_stats = box_item:GetChild("box_stats");
		box_stats:RemoveAllChild();

		local lhandSkill = GET_ITEM_LHAND_SKILL(obj);
		if lhandSkill ~= nil then
			local values = CreateTooltipValues();
			GET_SKILL_TOOLTIP_VALUES(lhandSkill, obj.Level, values);

			local nextValues = nil;
			if nextObj ~= nil and obj.Level ~= nextObj.Level then
				nextValues = CreateTooltipValues();
				GET_SKILL_TOOLTIP_VALUES(lhandSkill, nextObj.Level, nextValues);
			end
	
			local tooltipCount = GetTooltipVecCount(values);
			for i = 0 , tooltipCount - 1 do
				local key, value = GetTooltipInfoByIndex(values, i);
				local ctrlSet = box_stats:CreateControlSet("reinforce_mix_stat", "LH_" .. i , ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
				ctrlSet:GetChild("title"):SetTextByKey("value", ClMsg(key));
				ctrlSet:GetChild("from"):SetTextByKey("value", value);
				if nextValues == nil then
					ctrlSet:GetChild("to"):ShowWindow(0);
					ctrlSet:GetChild("indicator"):ShowWindow(0);
				else
					local nextkey, nextValue = GetTooltipInfoByIndex(nextValues, i);
					ctrlSet:GetChild("to"):SetTextByKey("value", nextValue);
				end
				ctrlSet:SetUserValue("_PROP_VALUE", value);		
			end
			DeleteTooltipValues(values);
			if nextValues ~= nil then
				DeleteTooltipValues(nextValues);
			end
		end

		GBOX_AUTO_ALIGN(box_stats, 10, 0, 10, true, false);
	end
	
	
end

function CLICK_ITEM_PIC_RBTN(ctrl)
	local frame = ctrl:GetTopParentFrame();	
	if 1 == frame:GetUserIValue("EXECUTE_REINFORCE") then
		return 0;
	end
	CLEAR_REINFORCE_BY_MIX(frame);
end


function REINFORCE_BY_MIX_SETITEM(frame, invItem)    
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end

	CLEAR_REINFORCE_BY_MIX(frame);
	
    local obj = GetIES(invItem:GetObject());		
	local reinforceCls = GetClass("Reinforce", obj.Reinforce_Type);
	if reinforceCls == nil then
		return;
	end
	local lv, curExp, maxExp = GET_ITEM_LEVEL_EXP(obj);
	if maxExp == 0 then
		ui.SysMsg(ClMsg("ThisGemCantReinforce"));
		return;
	end

	frame:SetUserValue("REINFORCE_CLS", reinforceCls.ClassName);
	local box_item = frame:GetChild("box_item");
	local itemname = box_item:GetChild("itemname");
	itemname:SetTextByKey("value", GET_FULL_NAME(obj));

	local startext = box_item:GetChild("startext");
	local starsize = frame:GetUserConfig("STAR_TEXT_SIZE")
	startext:SetText(GET_ITEM_STAR_TXT(obj,starsize));	
			
	REINFORCE_MIX_UPDATE_ITEM_STATS(frame, obj, nil);
				
	local item_pic = GET_CHILD(box_item, "item_pic", "ui::CSlot");
	item_pic:ShowWindow(1);
	item_pic:SetEventScript(ui.RBUTTONUP, "CLICK_ITEM_PIC_RBTN");
	SET_SLOT_ITEM(item_pic, invItem);        

	frame:SetUserValue("ITEM_GUID", invItem:GetIESID());
	
    local matslot = GET_MAT_SLOT(frame);        
	matslot:ShowWindow(1);
	matslot:SetSkinName(reinforceCls.SlotSkin);
	matslot:SetSlotSize(reinforceCls.SlotWidth, reinforceCls.SlotHeight);
	matslot:SetSpc(reinforceCls.SlotSpaceX, reinforceCls.SlotSpaceY);
	matslot:RemoveAllChild();
	matslot:CreateSlots();
    
	INVENTORY_SET_ICON_SCRIPT("REINF_MIX_CHECK_ICON", "GET_REINFORCE_MIX_ITEM");
	INVENTORY_SET_CUSTOM_RBTNDOWN("REINFORCE_MIX_INV_RBTN");
	INVENTORY_SET_CUSTOM_RDBTNDOWN("REINFORCE_MIX_INV_RDBTN");
end

function REINFORCE_MIX_UPDATE_EXP(frame)
	local slots = GET_MAT_SLOT(frame);
	local totalCount = 0;
	local addExp = 0;

	local cnt = slots:GetSlotCount();
	for i = 0 , cnt - 1 do
		local slot = slots:GetSlotByIndex(i);
		local icon = slot:GetIcon();
		local matItem, matItemcount = GET_SLOT_ITEM(slot);
		if matItem ~= nil then
			matItem = GetIES(matItem:GetObject());
			local matExp = matItemcount * GET_MIX_MATERIAL_EXP(matItem);
			addExp = addExp + matExp;
			totalCount = totalCount + matItemcount;
		end
	end
	
	local box_material = frame:GetChild("box_material");
	local sel_item_count = box_material:GetChild("sel_item_count");
	sel_item_count:ShowWindow(1);
	sel_item_count:SetTextByKey("value", totalCount);
	
	local box_item = frame:GetChild("box_item");
	local exp_plus = box_item:GetChild("exp_plus");
	if addExp > 0 then
		exp_plus:ShowWindow(1);
		exp_plus:SetTextByKey("value", addExp);
	else
		exp_plus:ShowWindow(0);
	end

	local tgtItem = GET_REINFORCE_MIX_ITEM();
	local lv = GET_ITEM_LEVEL_EXP(tgtItem, tgtItem.ItemExp + addExp);
	if lv == tgtItem.Level then
		REINFORCE_MIX_UPDATE_ITEM_STATS(frame, tgtItem, nil);
	else
		local nextObj = CloneIES(tgtItem);
		nextObj.ItemExp = tgtItem.ItemExp + addExp;
		local refreshScp = nextObj.RefreshScp;
		if refreshScp ~= "None" then
			refreshScp = _G[refreshScp];
			refreshScp(nextObj);
		end	

		REINFORCE_MIX_UPDATE_ITEM_STATS(frame, tgtItem, nextObj);
		DestroyIES(nextObj);
	end

end

function GET_REINFORCE_MIX_ITEM()
	local frame = ui.GetFrame("reinforce_by_mix");
	local guid = frame:GetUserValue("ITEM_GUID");
	local invItem = GET_ITEM_BY_GUID(guid);
	return GetIES(invItem:GetObject());
end

-- 아이템을 올렸을 때, 재료로 사용할 수 없는 아이템의 아이콘을 비활성화를 시킨다.
function REINF_MIX_CHECK_ICON(slot, reinfItemObj, invItem, itemobj)
	slot:EnableDrag(0);
	slot:EnableDrop(0);

	local icon = slot:GetIcon();
	if itemobj ~= nil and reinfItemObj ~= nil and TryGetProp(reinfItemObj, 'Reinforce_Type') ~= nil then
		local reinforceCls = GetClass("Reinforce", reinfItemObj.Reinforce_Type);
		local materialScp = TryGetProp(reinforceCls, 'MaterialScript')
		if materialScp ~= nil then
			if 1 == _G[materialScp](reinfItemObj, itemobj) then
				--slot:PlayUIEffect("I_sys_item_slot_loop_yellow", 1.7, "Reinforce");
				if 0 == slot:GetUserIValue("REINF_MIX_SELECTED") and itemobj.ItemLifeTimeOver == 0 then
						icon:SetColorTone("FFFFFFFF");
					else
						icon:SetColorTone("33000000");
					end
					return;
				end
			end
		end
	
	--slot:StopUIEffect("Reinforce", true, 0.0);
	if icon ~= nil then
		icon:SetColorTone("AA000000");
	end

end

function REINF_MIX_RECOVER_ICON(slot, reinfItemObj, invItem, itemobj)
--	slot:StopUIEffect("Reinforce", true, 0.0);
	slot:SetUserValue("REINF_MIX_SELECTED", 0);
end

function REINFORCE_MIX_INV_RDBTN(itemObj, slot)
	REINFORCE_MIX_INV_RBTN(itemObj, slot,'YES')
end

function REINFORCE_MIX_INV_RBTN(itemObj, slot, selectall)        
	local invitem = session.GetInvItemByGuid(GetIESID(itemObj))
	if nil == invitem then
		return;
	end

	if IS_KEY_ITEM(itemObj) == true or IS_KEY_MATERIAL(itemObj) == true or itemObj.ItemLifeTimeOver ~= 0 then
		ui.SysMsg(ClMsg("CanNotBeUsedMaterial"));
		return;
	end

	local reinfItem = GET_REINFORCE_MIX_ITEM();
	local reinforceCls = GetClass("Reinforce", reinfItem.Reinforce_Type);
	if 1 == _G[reinforceCls.MaterialScript](reinfItem, itemObj) then

		if true == invitem.isLockState then
			ui.SysMsg(ClMsg("MaterialItemIsLock"));
			return;
		end
		local nowselectedcount = slot:GetUserIValue("REINF_MIX_SELECTED")

		if selectall == 'YES' then
			nowselectedcount = invitem.count -1;
		end

		if nowselectedcount < invitem.count then
			local reinfFrame = ui.GetFrame("reinforce_by_mix");
			local icon = slot:GetIcon();
					
			if 1 == REINFORCE_BY_MIX_ADD_MATERIAL(reinfFrame, itemObj, nowselectedcount + 1)  then
					
				imcSound.PlaySoundEvent("icon_get_down");

				slot:SetUserValue("REINF_MIX_SELECTED", nowselectedcount + 1);
				local nowselectedcount = slot:GetUserIValue("REINF_MIX_SELECTED")
						
				if icon ~= nil and nowselectedcount == invitem.count then
					icon:SetColorTone("AA000000");
				end
			end
		end
	end	
end

function REINFORCE_BY_MIX_ADD_MATERIAL(frame, itemObj, count)	
	
	if 1 == frame:GetUserIValue("EXECUTE_REINFORCE") then
		return 0;
	end

	local slots = GET_MAT_SLOT(frame);
	local slot = GET_SLOT_BY_ITEMID(slots, GetIESID(itemObj))
	
	if slot == nil then
		slot = GET_EMPTY_SLOT(slots);
	end

	if slot == nil then
		return 0; 
	end
	
		local invItem = GET_ITEM_BY_GUID(GetIESID(itemObj));
		SET_SLOT_ITEM(slot, invItem, count);
	
		if invItem.count > 1 then
			local icon  = slot:GetIcon()
			icon:SetText(count, 'quickiconfont', 'right', 'bottom', -2, 1);
		end
	
		slot:SetEventScript(ui.RBUTTONDOWN, "REINFORCE_BY_MIX_SLOT_RBTN");
	
		REINFORCE_MIX_UPDATE_EXP(frame);
	return 1
end

function REINFORCE_BY_MIX_SLOT_RBTN(parent, slot)    
	local frame = ui.GetFrame("reinforce_by_mix");	
	if 1 == frame:GetUserIValue("EXECUTE_REINFORCE") then
		return 0;
	end

	local invItem = GET_SLOT_ITEM(slot);
	local guid = invItem:GetIESID();

	local invSlot = GET_PC_SLOT_BY_ITEMID(guid);
	local icon = invSlot:GetIcon();
	icon:SetColorTone("FFFFFFFF");
	slot:ClearIcon();
	invSlot:SetUserValue("REINF_MIX_SELECTED", 0);
	ui.UpdateVisibleToolTips();

	REINFORCE_MIX_UPDATE_EXP(frame);
	imcSound.PlaySoundEvent("icon_pick_up");
end

function REINFORCE_BY_MIX_EXECUTE(parent)
  
  if  session.world.IsIntegrateServer() == true or
	    session.world.IsIntegrateIndunServer() == true or
	    session.IsMissionMap() == true then      
	      ui.SysMsg(ClMsg("CannotCraftInIndun"));
        return
    end


	local frame = parent:GetTopParentFrame();

	local slots = GET_MAT_SLOT(frame);
	local cnt = slots:GetSlotCount();
	
    local tgtItem = GET_REINFORCE_MIX_ITEM();
    if tgtItem.ItemLifeTimeOver == 1 then
        ui.SysMsg(ScpArgMsg("CannotUseLifeTimeOverItem"))
        return
    end
	local slots = GET_MAT_SLOT(frame);
	local cnt = slots:GetSlotCount();
	for i = 0 , cnt - 1 do
		local slot = slots:GetSlotByIndex(i);
		local matItem, count = GET_SLOT_ITEM(slot);
		if matItem ~= nil then
		    local obj = GetIES(matItem:GetObject());
		    if obj.ItemLifeTimeOver == 1 then
                ui.SysMsg(ScpArgMsg("CannotUseLifeTimeOverItem"))
        		return
        	end
		end
	end

    
	local ishavevalue = 0
    local canProcessReinforce = false

	for i = 0 , cnt - 1 do
		local slot = slots:GetSlotByIndex(i);
		local matItem, count = GET_SLOT_ITEM(slot);
		if matItem ~= nil then            
		    if IS_VALUEABLE_ITEM(matItem:GetIESID()) == 1 then
				ishavevalue = 1
				break
			else
                canProcessReinforce = true
            end
		end
	end
    
	if ishavevalue == 1 then
		local yesScp = string.format("_REINFORCE_BY_MIX_EXECUTE()");
		ui.MsgBox(ScpArgMsg("IsValueAbleItem"), yesScp, "None");
	elseif canProcessReinforce then
		_REINFORCE_BY_MIX_EXECUTE()
	end
end

function _REINFORCE_BY_MIX_EXECUTE()
    local tgtItem = GET_REINFORCE_MIX_ITEM();
	if tgtItem.GroupName == "Card" then
		local lv, curExp, maxExp = GET_ITEM_LEVEL_EXP(tgtItem, tgtItem.ItemExp);
		if lv == 10 then		-- 카드 합성 제한이다. 제한선을 수정할 경우 여기도 바꿔줘야한다. 카드 레벨 제한을 경험치 분할 갯수로 따지기 때문에 제함점을 따로 얻어올 방법을 못찾겠다.
			ui.MsgBox(ScpArgMsg("CardLvisMax"));			
			return;
		end
	end
	local frame = ui.GetFrame("reinforce_by_mix");
	local reinforceButton = GET_CHILD_RECURSIVELY(frame, "exec_mixreinf");
	if reinforceButton ~= nil then
	  reinforceButton:EnableHitTest(0);
    end
	
    frame:SetUserValue("EXECUTE_REINFORCE", 1)

	session.ResetItemList();

	session.AddItemID(frame:GetUserValue("ITEM_GUID"));

    -- 재료로 사용된 아이템 GUID를 저장하자
    local mat_list = "";

	local slots = GET_MAT_SLOT(frame);
	local cnt = slots:GetSlotCount();
	for i = 0 , cnt - 1 do
		local slot = slots:GetSlotByIndex(i);
		local matItem, count = GET_SLOT_ITEM(slot);
		
		if matItem ~= nil then
			session.AddItemID(matItem:GetIESID(), count);
            -- STRING으로 가져다 붙여
            if mat_list ~= '' then
                mat_list = mat_list .. ';' .. tostring(matItem:GetIESID())
            else
                mat_list = tostring(matItem:GetIESID())
            end
            
		end
	end
	
    -- 재료로 사용된 아이템의 GUID를 저장한다.
    frame:SetUserValue("UsedMaterialItemList", mat_list);

	local resultlist = session.GetItemIDList();
	if resultlist:Count() > 1 then
		item.DialogTransaction("SCR_ITEM_EXP_UP", resultlist);	
	end
	--local tgtItem = GET_REINFORCE_MIX_ITEM();
	frame:SetUserValue("LAST_REQ_EXP", tgtItem.ItemExp);
	CloneTempObj("REINF_MIX_TEMPOBJ", tgtItem);	
end


------------------------------------------------------
function REINFORCE_MIX_ITEM_EXP_STOP()	
	local frame = ui.GetFrame("reinforce_by_mix");
	frame:SetUserValue("EXECUTE_REINFORCE", 0);
    local reinforceButton = GET_CHILD_RECURSIVELY(frame, "exec_mixreinf");
	if reinforceButton ~= nil then
	  reinforceButton:EnableHitTest(1);
    end
end;

function REINFORCE_MIX_FORCE(slot, resultText, x, y)

	if slot:GetIcon() == nil then
		return 0;
	end

	UI_PLAYFORCE(slot, "reinf_slot_" .. resultText, x, y);
	return slot:GetUserIValue("_EXP");

end

function REINFORCE_MIX_ITEM_EXPUP_END(frame, msg, multiPly, totalPoint)     
	local reinforceButton = GET_CHILD_RECURSIVELY(frame, "exec_mixreinf");
	if reinforceButton ~= nil then
	  reinforceButton:EnableHitTest(1);
    end   
	imcSound.PlaySoundEvent("sys_jam_mix_whoosh");
		
	local box_item = frame:GetChild("box_item");
	local item_pic = GET_CHILD(box_item, "item_pic", "ui::CSlot");
	local slots = GET_MAT_SLOT(frame);
	
	local exp_plus = box_item:GetChild("exp_plus");
	exp_plus:ShowWindow(0);

	local effectName = "reinf_result_";
	local resultText;
	if multiPly == 3.0 then
		resultText = "jackpot";
	elseif multiPly == 1.5 then
		resultText = "great";
	else
		resultText = "normal";
	end

	local sel_item_countRtext = GET_CHILD_RECURSIVELY(frame, 'sel_item_count', 'ui::CRichText')
	sel_item_countRtext:ShowWindow(0)
	
	local slot = GET_CHILD(frame, "mix_itemSlot", "ui::CSlot");
	local x, y = GET_UI_FORCE_POS(item_pic);
	APPLY_TO_ALL_ITEM_SLOT(slots, REINFORCE_MIX_FORCE, resultText, x, y);

	local gauge_exp = GET_CHILD(box_item, "gauge_exp", "ui::CGauge");
	local gx, gy = GET_UI_FORCE_POS(gauge_exp);
	gx = gx - 50;
	UI_FORCE(effectName, gx, gy);

	frame:SetUserValue("_FORCE_SHOOT_EXP", totalPoint * multiPly);

	local box_stats = box_item:GetChild("box_stats");
	for i = 0 , box_stats:GetChildCount() - 1 do
		local ctrlSet = box_stats:GetChildByIndex(i);
		local to = ctrlSet:GetChild("to");
		if to ~= nil then to:ShowWindow(0); end
		local indicator = ctrlSet:GetChild("indicator");
		if indicator ~= nil then indicator:ShowWindow(0); end
	end
    frame:SetUserValue("EXECUTE_REINFORCE", 0);
    
    -- 사실 재료가 box_material 내의 box_slot 에 들어가면 정보가 계속 남아 있는듯 하다. 
    -- 그래서 해당 정보를 아이콘 삭제를 통해 지운다.
    local box_material = frame:GetChild("box_material");
    local slot_cnt = slots:GetSlotCount()    
    for i = 1, slot_cnt do
        local a = GET_CHILD_RECURSIVELY(box_material, "slot" .. tostring(i))
        a:ClearIcon();
    end
    CLEAR_MATERIAL_SLOT(frame)

end

function CLEAR_MATERIAL_SLOT(frame)
	local matslot = GET_MAT_SLOT(frame);
	matslot:ShowWindow(0);
	local box_material = frame:GetChild("box_material");
	local sel_item_count = box_material:GetChild("sel_item_count");
	sel_item_count:ShowWindow(0);
	
	local reinforceClsName = frame:GetUserValue("REINFORCE_CLS");
	local reinforceCls = GetClass("Reinforce", reinforceClsName);    
	if reinforceCls ~= nil then
		INVENTORY_SET_ICON_SCRIPT("REINF_MIX_RECOVER_ICON");
        INVENTORY_SET_CUSTOM_RBTNDOWN("None")
        INVENTORY_SET_CUSTOM_RDBTNDOWN("None");    
	end
end

function RECREATE_MATERIAL_SLOT(frame)    
    local reinforceClsName = frame:GetUserValue("REINFORCE_CLS");
	local reinforceCls = GetClass("Reinforce", reinforceClsName);
    if reinforceCls == nil then
		return;
	end

    local box_material = frame:GetChild("box_material");
	local sel_item_count = box_material:GetChild("sel_item_count");
	sel_item_count:ShowWindow(0);
    local matslot = GET_MAT_SLOT(frame);        
    matslot:ShowWindow(1);    
	matslot:SetSkinName(reinforceCls.SlotSkin);
	matslot:SetSlotSize(reinforceCls.SlotWidth, reinforceCls.SlotHeight);
	matslot:SetSpc(reinforceCls.SlotSpaceX, reinforceCls.SlotSpaceY);
	matslot:RemoveAllChild();
	matslot:CreateSlots();

    INVENTORY_SET_CUSTOM_RBTNDOWN("REINFORCE_MIX_INV_RBTN");
	INVENTORY_SET_CUSTOM_RDBTNDOWN("REINFORCE_MIX_INV_RDBTN");
end

function RESTORE_COLOR_INV_MATERIAL_ITEM(frame)    
    local slots = GET_MAT_SLOT(frame);
    local mat_list = frame:GetUserValue('UsedMaterialItemList')
    local token = StringSplit(mat_list, ";")
    
    for i = 1, #token do      
        local frame = ui.GetFrame("reinforce_by_mix");	
        local guid = token[i];        
        local invSlot = GET_PC_SLOT_BY_ITEMID(guid);
        if invSlot ~= nil then
            local icon = invSlot:GetIcon();
            icon:SetColorTone("FFFFFFFF");                    
            ui.UpdateVisibleToolTips();
        end        
    end
    frame:SetUserValue('UsedMaterialItemList', '')
end


function REINF_FORCE_END()
	local frame = ui.GetFrame("reinforce_by_mix");
	local exp = frame:GetUserIValue("_FORCE_SHOOT_EXP");
	if exp == 0 then
		return;
	end
    local reinforceButton = GET_CHILD_RECURSIVELY(frame, "exec_mixreinf");
	if reinforceButton ~= nil then
	  reinforceButton:EnableHitTest(1);
    end
	frame:SetUserValue("_FORCE_SHOOT_EXP", "0");
	frame:SetUserValue("_EXP_UP_VALUE", exp);
	
	frame:SetUserValue("_EXP_UP_START_TIME", exp);
	frame:StopUpdateScript("REINF_MIX_UPDATE_EXP_UP");
	frame:RunUpdateScript("REINF_MIX_UPDATE_EXP_UP", 0.2);

	local box_item = frame:GetChild("box_item");
	local item_pic = GET_CHILD(box_item, "item_pic", "ui::CSlot");
	item_pic:SetBlink(1, 1, "00FFFFFF");
    local frame = ui.GetFrame("reinforce_by_mix");
    -- 애니가 끝나면 슬롯을 비우고 새로 그린다. 인벤 아이템 아이콘 색깔도 복구한다.
    if frame ~= nil then        
        RESTORE_COLOR_INV_MATERIAL_ITEM(frame)
        RECREATE_MATERIAL_SLOT(frame)
    end
end

function REINF_MIX_UPDATE_EXP_UP(frame)

	local box_item = frame:GetChild("box_item");
	local gauge = GET_CHILD(box_item, "gauge_exp", "ui::CGauge");
	local exp = frame:GetUserIValue("_EXP_UP_VALUE");

	local obj = GetTempObj("REINF_MIX_TEMPOBJ");
	
	if exp == 0 then
		return 0;
	end

	if 1 == gauge:IsTimeProcessing() then
		return 1;
	end

	local lv, curExp, maxExp = GET_ITEM_LEVEL_EXP(obj, obj.ItemExp);
	local needExp = maxExp - curExp;
	local processExp = 0;
	if exp >= needExp then
		processExp = needExp;
	else
		processExp = exp;
	end

	if gauge:GetCurPoint() == gauge:GetMaxPoint() then
		if processExp == 0 then
			R_RENEW_SHOW_EXP_APPLIED(frame, obj);
			if curExp > maxExp then
				curExp = maxExp;
			end
			gauge:SetPoint(curExp, maxExp);
			frame:SetUserValue("IS_ING", 0);
			return 0;
		end

		R_RENEW_SHOW_EXP_APPLIED(frame, obj);
		local lv, curExp, maxExp = GET_ITEM_LEVEL_EXP(obj, obj.ItemExp);
		gauge:SetPoint(0, maxExp);
		return -0.5;
	end

	exp = exp - processExp;
	frame:SetUserValue("_EXP_UP_VALUE", exp);
	
	local gaugeTime = processExp / maxExp * 3.0;
	local point = curExp + processExp;
	
	gauge:SetPoint(curExp, maxExp);
	gauge:SetPointWithTime(point, gaugeTime);
	gauge:SetProgressSound("sys_jam_shot", 0.05);
	obj.ItemExp = obj.ItemExp + processExp;
	obj.Level = GET_ITEM_LEVEL(obj);
	local reservtime = gaugeTime * 0.7
	ReserveScript('RESERVE_REINFORCE_MIX_UPDATE_ITEM_STATS()',reservtime)

	return 1;
end

function RESERVE_REINFORCE_MIX_UPDATE_ITEM_STATS()
	local frame = ui.GetFrame('reinforce_by_mix')	
	local obj = GetTempObj("REINF_MIX_TEMPOBJ");
	REINFORCE_MIX_UPDATE_ITEM_STATS(frame,obj)

end

function R_RENEW_SHOW_EXP_APPLIED(frame, obj)

	frame = tolua.cast(frame, "ui::CFrame");
	local refreshScp = obj.RefreshScp;
	if refreshScp ~= "None" then
		refreshScp = _G[refreshScp];
		refreshScp(obj);
	end

	local box_item = frame:GetChild("box_item");

	local list = {};
	local ctrlList = {};
	local endValues = {};
	GET_WEAPON_PARAM_LIST(obj, list);
	
	local propCnt = #list;
	for i = 1 , #list do
		local propName = list[i];
		local ctrlSet = box_item:GetChild("stat_" .. propName);
		ctrlList[i] = ctrlSet;
		endValues[i] = TryGetProp(obj, propName);
	end

	local box_stats = box_item:GetChild("box_stats");
	
	local lhandSkill = GET_ITEM_LHAND_SKILL(obj);
	if lhandSkill ~= nil then
		local values = CreateTooltipValues();
		GET_SKILL_TOOLTIP_VALUES(lhandSkill, obj.Level, values);

		local tooltipCount = GetTooltipVecCount(values);
		for i = 0 , tooltipCount - 1 do
			local key, value = GetTooltipInfoByIndex(values, i);
			local index = #list + 1;
			list[index] = key;
			local ctrlSet = box_stats:GetChild("LH_" .. i);
			ctrlList[index] = ctrlSet;
			endValues[index] = value;
		end
	end


	for i = propCnt + 1 , #list do
		local propName = list[i];

	end

	for i = 1 , #list do
		local propName = list[i];
		local ctrlSet = ctrlList[i];
		if ctrlSet ~= nil then
			local startValue = ctrlSet:GetUserIValue("_PROP_VALUE");
			local endValue = endValues[i];
			if startValue ~= endValue then
				ctrlSet:SetUserValue("_PROP_VALUE", endValue);
				local from = ctrlSet:GetChild("from");
				UI_PLAYFORCE(from, "text_eft_1", 0, 0);
				local from = ctrlSet:GetChild("from");
				from:PlayTextChangeEvent(0.05, "value", startValue, endValue);
			end
		end
	end
end
