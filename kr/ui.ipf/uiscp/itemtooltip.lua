-- itemtooltip.lua

-- tooltip.xml에 적혀있는, 툴팁 관련 가장 처음 실행되는 루아 함수. 여기서 아이템의 종류에 따라 각각 다른 전용 툴팁 함수들을 호출한다. 종류되는 함수 명은 item클래스의 CT_ToolTipScp를 따름

function ON_REFRESH_ITEM_TOOLTIP()
	local wholeitem = ui.GetTooltip("wholeitem")
	if wholeitem ~= nil then
		wholeitem:RefreshTooltip();
	end
end

function UPDATE_ITEM_TOOLTIP(tooltipframe, strarg, numarg1, numarg2, userdata, tooltipobj, noTradeCnt)

	tolua.cast(tooltipframe, "ui::CTooltipFrame");
	
	local itemObj, isReadObj = nil

	if tooltipobj ~= nil then
		itemObj = tooltipobj;
		isReadObj = 0;
	else
		itemObj, isReadObj = GET_TOOLTIP_ITEM_OBJECT(strarg, numarg2, numarg1);	
	end

	if nil ~= itemObj and itemObj.GroupName == "Unused" then
		tooltipframe:Resize(1, 1);
        return;
	end


	local recipeitemobj = nil

	local recipeid = IS_RECIPE_ITEM(itemObj)
	-- 레시피 아이템 쪽
		
	if recipeid ~= 0 then
		
		local recipeIES = CreateIESByID('Item', recipeid);
		
		if recipeIES ~= nil then

			recipeitemobj = recipeIES
			local refreshScp = recipeitemobj.RefreshScp;

			if refreshScp ~= "None" then
				refreshScp = _G[refreshScp];
				refreshScp(recipeitemobj);
			end	

		end
	end
	
	--Main Info
	tooltipframe:Resize(tooltipframe:GetOriginalWidth(), tooltipframe:GetOriginalHeight());
	tooltipframe:CheckSize()
	INIT_ITEMTOOLTIPFRAME_CHILDS(tooltipframe)

	if isReadObj == 0 then
		if 1 == IS_DRAG_RECIPE_ITEM(itemObj) then
			local tabTxt = "";
			tabTxt, numarg1 = GET_DRAG_RECIPE_INFO(itemObj);
			isReadObj = 1;
			
			local tabCtrl = GET_CHILD(tooltipframe, "tabText", "ui::CTabControl");
			tabCtrl:ChangeCaption(0, tabText);
			tabCtrl:ShowWindow(1);
		end
	end

	local recipeclass = recipeitemobj;

	if recipeclass ~= nil then
		local ToolTipScp = _G[ 'ITEM_TOOLTIP_' .. recipeclass.ToolTipScp];
		ToolTipScp(tooltipframe, recipeclass, strarg, "usesubframe_recipe");
		DestroyIES(recipeitemobj);
	end

	
	if itemObj == nil then
		return;
	end
	
	-- 비교툴팁
	-- 툴팁 비교는 무기와 장비에만 해당된다.

	if (itemObj.ToolTipScp == 'WEAPON' or itemObj.ToolTipScp == 'ARMOR') and  (strarg == 'inven' or strarg =='sell') and (string.find(itemObj.GroupName, "Pet") == nil) then

		local CompItemToolTipScp = _G[ 'ITEM_TOOLTIP_' .. itemObj.ToolTipScp];
		local ChangeValueToolTipScp = _G[ 'ITEM_TOOLTIP_' .. itemObj.ToolTipScp..'_CHANGEVALUE'];
		-- 한손 무기 / 방패 일 경우

		local isVisble = nil;
		
		if itemObj.EqpType == 'SH' then
		
			if itemObj.DefaultEqpSlot == 'RH' then
				
				local item = session.GetEquipItemBySpot( item.GetEquipSpotNum("RH") );
				if nil ~= item then
				local equipItem = GetIES(item:GetObject());
				
				local classtype = TryGetProp(equipItem, "ClassType"); -- 코스튬은 안뜨도록

				if IS_NO_EQUIPITEM(equipItem) == 0 and classtype ~= "Outer" then
					CompItemToolTipScp(tooltipframe, equipItem, strarg, "usesubframe");
					isVisble = ChangeValueToolTipScp(tooltipframe, itemObj, equipItem, strarg);
				end
				end
			elseif itemObj.DefaultEqpSlot == 'LH' then

				local item = session.GetEquipItemBySpot( item.GetEquipSpotNum("LH") );
				if nil ~= item then
				local equipItem = GetIES(item:GetObject());

				if IS_NO_EQUIPITEM(equipItem) == 0 then
					CompItemToolTipScp(tooltipframe, equipItem, strarg, "usesubframe");
					isVisble = ChangeValueToolTipScp(tooltipframe, itemObj, equipItem, strarg);
				end
				end
			end
			
		-- 양손 무기 일 경우
		elseif itemObj.EqpType == 'DH' then
			
			local item = session.GetEquipItemBySpot(item.GetEquipSpotNum("RH"));
			if nil ~= item then
			local equipItem = GetIES(item:GetObject());

			if IS_NO_EQUIPITEM(equipItem) == 0 then
				CompItemToolTipScp(tooltipframe, equipItem, strarg, "usesubframe");
				isVisble = ChangeValueToolTipScp(tooltipframe, itemObj, equipItem, strarg);
			end
			end
		else

			local equiptype = itemObj.EqpType

			if equiptype == 'RING' then

				if keyboard.IsPressed(KEY_ALT) == 1 then
					equiptype = 'RING2'
				else
					equiptype = 'RING1'
				end
			end

			local equitSpot = item.GetEquipSpotNum(equiptype);

			local item = session.GetEquipItemBySpot(equitSpot);

			if item ~= nil then
				local equipItem = GetIES(item:GetObject());

				if IS_NO_EQUIPITEM(equipItem) == 0 then
					CompItemToolTipScp(tooltipframe, equipItem, strarg, "usesubframe");
					isVisble = ChangeValueToolTipScp(tooltipframe, itemObj, equipItem, strarg);
				end

			end
		end

	end

	-- 메인 프레임. 즉 주된 툴팁 표시.
	if isReadObj == 1 then -- IES가 없는 아이템. 가령 제작서의 완성 아이템 표시 등
			
		local class = itemObj;
		if class ~= nil then

			local ToolTipScp = _G[ 'ITEM_TOOLTIP_' .. class.ToolTipScp];
			ToolTipScp(tooltipframe, class, strarg, "mainframe");
		end

		
	else
		local ToolTipScp = _G[ 'ITEM_TOOLTIP_' .. itemObj.ToolTipScp];
		if nil == noTradeCnt then
			noTradeCnt = 0
		end
		ToolTipScp(tooltipframe, itemObj, strarg, "mainframe",noTradeCnt);

	end
	

	if isReadObj == 1 then
		DestroyIES(itemObj);
	end

	ITEMTOOLTIPFRAME_ARRANGE_CHILDS(tooltipframe)
	ITEMTOOLTIPFRAME_RESIZE(tooltipframe)

end

function ITEMTOOLTIPFRAME_ARRANGE_CHILDS(tooltipframe)

	local cvalueGBox = GET_CHILD(tooltipframe, 'changevalue','ui::CGroupBox')
	local cvalueGBoxheight = cvalueGBox:GetHeight()
	local childCnt = tooltipframe:GetChildCount();
	for i = 0 , childCnt - 1 do
		local chld = tooltipframe:GetChildByIndex(i);
		if chld:GetName() ~= 'changevalue' then
			chld:SetOffset(chld:GetX(), chld:GetY() + cvalueGBoxheight)
		end
	end

end

function INIT_ITEMTOOLTIPFRAME_CHILDS(tooltipframe)

	local childCnt = tooltipframe:GetChildCount();
	for i = 0 , childCnt - 1 do
		local chld = tooltipframe:GetChildByIndex(i);

		chld:RemoveAllChild()
		chld:SetOffset(chld:GetOriginalX(),chld:GetOriginalY());

		if chld:GetName() ~= 'closebtn' then
			chld:Resize(chld:GetOriginalWidth(),0);
		end
	end
end

function ITEMTOOLTIPFRAME_RESIZE(tooltipframe)

	local min_x = 9999;
	local max_x = -9999;

	local min_y = 9999;
	local max_y = -9999;

	local childCnt = tooltipframe:GetChildCount();
	for i = 0 , childCnt - 1 do
		local chld = tooltipframe:GetChildByIndex(i);
		if chld:GetHeight() > 0 then
			local chldminx = chld:GetX()
			local chldmaxx = chld:GetX() + chld:GetWidth()
			local chldminy = chld:GetY()
			local chldmaxy = chld:GetY() + chld:GetHeight()

			if chldminx < min_x then
				min_x = chldminx
			end
			if chldmaxx > max_x then
				max_x = chldmaxx
			end
			if chldminy < min_y then
				min_y = chldminy
			end
			if chldmaxy > max_y then
				max_y = chldmaxy
			end

		end
	end

	local childCnt = tooltipframe:GetChildCount();
	for i = 0 , childCnt - 1 do
		local chld = tooltipframe:GetChildByIndex(i);
		chld:SetOffset(chld:GetX() - min_x, chld:GetY() - min_y)
	end

	tooltipframe:Resize(max_x-min_x, max_y-min_y);

end

--상점에서 가격 표시
function DRAW_SELL_PRICE(tooltipframe, invitem, yPos, mainframename)
    
    if invitem.ShopTrade ~= 'YES' then
        return yPos
    end
    
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_sellinfo');

	if ui.IsFrameVisible("shop") == 0 and invitem.SellPrice ~= 0 and invitem.ShopTrade == 'YES' then
		return yPos
	end
	
	local tooltip_sellinfo_CSet = gBox:CreateControlSet('tooltip_sellinfo', 'tooltip_sellinfo', 0, yPos);
	tolua.cast(tooltip_sellinfo_CSet, "ui::CControlSet");

	local sellprice_text = GET_CHILD(tooltip_sellinfo_CSet,'sellprice','ui::CRichText')
	
	local itemProp = geItemTable.GetPropByName(invitem.ClassName);

	sellprice_text:SetTextByKey("silver", geItemTable.GetSellPrice(itemProp) );

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	tooltip_sellinfo_CSet:Resize(tooltip_sellinfo_CSet:GetWidth(),tooltip_sellinfo_CSet:GetHeight() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + tooltip_sellinfo_CSet:GetHeight())
	
end

function GET_ITEM_TOOLTIP_DESC(obj)

	local invDesc = GET_ITEM_DESC_BY_TOOLTIP_VALUE(obj);
	local byDescColumn = obj.Desc;
	if byDescColumn == 'None' then
		byDescColumn = "";
	end

	if invDesc == "" then
		invDesc = invDesc .. byDescColumn;
	else
		invDesc = invDesc .. "{nl}" .. byDescColumn;
	end	

	return invDesc;
end

-- propNameList만 가져오는 함수. 만일 툴팁이나 기타 등등에 아이템의 옵션을 표시할 때 옵션값들을 하나의 통합된 string 형태가 아니라 그냥 리스트로 가져오고 싶을 때 활용.
function GET_ITEM_PROP_NAME_LIST(obj) 

	local tooltipValue = TryGetProp(obj, "TooltipValue");
	if tooltipValue == nil or tooltipValue == "None" then
		return "";
	end

	local sList = StringSplit(tooltipValue, "/");
	local propNameList = {};
	for i = 1, #sList do
		local propName = sList[i];
		if string.sub(propName, 1, 1) == "#" then
			local func = _G[string.sub(propName, 2, string.len(propName) )];
			func(obj, propNameList);
		else
			propNameList[#propNameList + 1] = {};
			propNameList[#propNameList]["PropName"] = propName;
			propNameList[#propNameList]["PropValue"] = obj[propName];
		end
	end
	
	return propNameList

end

function GET_ITEM_DESC_BY_TOOLTIP_VALUE(obj)

	local propNameList = GET_ITEM_PROP_NAME_LIST(obj)
	local ret = "";

	for i = 1, #propNameList do
		local propName = propNameList[i]["PropName"];
		local propValue = propNameList[i]["PropValue"];
		local useOperator = propNameList[i]["UseOperator"];
		local title = propNameList[i]["Title"];

		local resultMsg = "";
		if title ~= nil then
			resultMsg = title;
		else
			if propName == "CoolDown" then
				propValue = propValue / 1000;
				 resultMsg = ScpArgMsg("CoolDown : {Sec} Sec",'Sec', propValue);
			else
				if useOperator ~= nil and propValue > 0 then
					resultMsg = ClMsg(propName) .. " : " .."{img green_up_arrow 16 16}".. propValue;
				else
					resultMsg = ClMsg(propName) .. " : " .."{img red_down_arrow 16 16}".. propValue;
				end
			end
		end	

		if ret ~= "" then
			ret = ret .. "{nl}";
		end

		ret = ret .. resultMsg;
	end
	
	return ret;
end

function GETCARDTOOLTIP(obj, propNameList)
	
	local lhandSkill = GET_ITEM_LHAND_SKILL(obj);
	if lhandSkill ~= nil then
		local values = CreateTooltipValues();
		GET_SKILL_TOOLTIP_VALUES(lhandSkill, obj.Level, values);

		local tooltipCount = GetTooltipVecCount(values);
		if tooltipCount > 0 then
			local langType = "SkillStats";
			propNameList[#propNameList + 1] = {};
			propNameList[#propNameList]["Title"] = "{#FFFF22}" .. ClMsg(langType) .. "{/}";

			for i = 0 , tooltipCount - 1 do
				local key, value = GetTooltipInfoByIndex(values, i);
				propNameList[#propNameList + 1] = {};
				propNameList[#propNameList]["PropName"] = key;
				propNameList[#propNameList]["PropValue"] = value;
			end	
		end	
	end
end


function CLOSE_ITEM_TOOLTIP()

end


-- ???�수???�크�??�이?�도 ?�시?????�용?�니??
function SET_ITEM_TOOLTIP_ALL_TYPE(icon, invitem, className, strType, ItemType, index)
	
	if className == 'Scroll_SkillItem' then
		local obj = GetIES(invitem:GetObject());
		SET_TOOLTIP_SKILLSCROLL(icon, obj, nil, strType);
	else
		icon:SetTooltipType('wholeitem');
		if nil ~= strType and nil ~= ItemType and nil ~= index then
			icon:SetTooltipArg(strType, ItemType, index);
		end
	end
end

function SET_ITEM_TOOLTIP_TYPE(prop, itemID, itemCls, tooltipType)
	
	local customTooltipScp = TryGetProp(itemCls, "CustomToolTip");
	if customTooltipScp ~= nil and customTooltipScp ~= "None" then
		customTooltipScp = _G[customTooltipScp];
		customTooltipScp(prop, itemCls, nil, tooltipType);
	else
		prop:SetTooltipType('wholeitem');
	end	
	
end

function GET_ITEM_TOOLTIP_TYPE(itemID, itemCls)

	return 'wholeitem'
end

function SET_TOOLTIP_SKILLSCROLL(icon, obj, itemCls, strType)

	if nil == obj or obj.SkillType == 0 then
		return 0;
	end 

	SET_SKILL_TOOLTIP_BY_TYPE_LEVEL(icon, obj.SkillType, obj.SkillLevel);
	if strType ~= nil then
		local slot = icon:GetParent();
		if slot ~= nil then
			slot:SetUserValue("SCROLL_ITEM_ID", GetIESID(obj));
			slot:SetUserValue("SCROLL_ITEM_INVTYPE", strType);
		end
		
		icon:SetUserValue("SCROLL_ITEM_ID", GetIESID(obj));
		icon:SetUserValue("SCROLL_ITEM_INVTYPE", strType);
	end

	return 1;
end

-- 마켓?�에??묘사?�서 ?�킬�??�오?�록
function SET_ITEM_DESC(value, desc, item)
	if desc == "None" then
		desc = "";
	end

	local obj = GetIES(item:GetObject());

	if nil ~= obj and
	   obj.ClassName == 'Scroll_SkillItem' then		
		local sklCls = GetClassByType("Skill", obj.SkillType)
		value:SetTextByKey("value", obj.SkillLevel .. " Level/ "..  sklCls.Name);
	else
		value:SetTextByKey("value", desc);
	end
end

function ICON_SET_INVENTORY_TOOLTIP(icon, invitem, strarg, itemCls)

	if strarg == nil then
		strarg = 'inven';
	end

	SET_ITEM_TOOLTIP_ALL_TYPE(icon, invitem, itemCls.ClassName, strarg, 0, invitem:GetIESID());

	local itemobj = GetIES(invitem:GetObject());
	if itemobj.ItemType == "Equip" and itemobj.MaxDur ~= 0 and itemobj.Dur == 0 then
		icon:SetColorTone("FFFF0000");
	end

end

function ICON_SET_EQUIPITEM_TOOLTIP(icon, equipitem)

	SET_ITEM_TOOLTIP_TYPE(icon, equipitem.type);
	icon:SetTooltipArg('equip', equipitem.type, equipitem:GetIESID());

end