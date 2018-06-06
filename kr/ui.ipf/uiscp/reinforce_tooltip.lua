-- reinforce_tooltip.lua

function UPDATE_REINFORCE_ITEM_TOOLTIP(tooltipframe, strarg, numarg1, numarg2)
	
	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local itemObj, isReadObj = nil;
	itemObj, isReadObj = GET_TOOLTIP_ITEM_OBJECT(strarg, numarg2, numarg1);	

	if itemObj == nil then
		return;
	end
 
	if isReadObj == 1 then
		DestroyIES(itemObj);	
		return;
	end

	-- 원본을 복사해서 강화더미데이터를 만듬
	local viewObj = CloneIES_NotUseCalc(itemObj);
	if viewObj == nil then
		return;
	end

	if strarg == "transcendscroll" then
		local scrollCls = GetClassByType("Item", numarg1)
		local transcend, rate = GET_ANTICIPATED_TRANSCEND_SCROLL_SUCCESS(viewObj, scrollCls);
		if transcend == nil then
			DestroyIES(viewObj);
			return;
		end
		viewObj.Transcend = transcend;
	else
	-- 강회데이터를 위해 +1
		viewObj.Reinforce_2 = viewObj.Reinforce_2+1;
	end

	-- 갱신
	if viewObj.RefreshScp ~= 'None' then
		local scp = _G[viewObj.RefreshScp];
		if scp ~= nil then
			scp(viewObj);
		end
	end

	if nil ~= itemObj and itemObj.GroupName == "Unused" then
		tooltipframe:Resize(1, 1);
		DestroyIES(viewObj); -- viewObj는 지워줘야함
        return;
	end
	
	--Main Info
	tooltipframe:Resize(tooltipframe:GetOriginalWidth(), tooltipframe:GetOriginalHeight());
	tooltipframe:CheckSize()
	INIT_ITEMTOOLTIPFRAME_CHILDS(tooltipframe)

	-- 메인 프레임. 즉 주된 툴팁 표시.
	if isReadObj == 0  then
		local ToolTipScp = _G[ 'REINFORCE_ITEM_TOOLTIP_' .. itemObj.ToolTipScp];
		local CompItemToolTipScp = _G[ 'REINFORCE_ITEM_TOOLTIP_' .. itemObj.ToolTipScp];
		local ChangeValueToolTipScp = _G[ 'REINFORCE_ITEM_TOOLTIP_' .. itemObj.ToolTipScp..'_CHANGEVALUE'];

		ToolTipScp(tooltipframe, itemObj, strarg, "usesubframe",0);
		CompItemToolTipScp(tooltipframe, viewObj, strarg, "mainframe");
		ChangeValueToolTipScp(tooltipframe, viewObj, itemObj, strarg);
	end

	--복사된것 삭제
	DestroyIES(viewObj);

	ITEMTOOLTIPFRAME_ARRANGE_CHILDS(tooltipframe)
	ITEMTOOLTIPFRAME_RESIZE(tooltipframe)
end

function REINFORCE_ITEM_TOOLTIP_WEAPON(tooltipframe, invitem, strarg, usesubframe)
	ITEM_TOOLTIP_EQUIP(tooltipframe, invitem, strarg, usesubframe)
end

function REINFORCE_ITEM_TOOLTIP_ARMOR(tooltipframe, invitem, strarg, usesubframe)
	ITEM_TOOLTIP_EQUIP(tooltipframe, invitem, strarg, usesubframe)
end

function REINFORCE_ITEM_TOOLTIP_EQUIP(tooltipframe, invitem, strarg, usesubframe)

	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local mainframename = 'equip_main'
	local addinfoframename = 'equip_main_addinfo'
	
	if usesubframe == "usesubframe" then
		mainframename = 'equip_sub'
		addinfoframename = 'equip_sub_addinfo'
	elseif usesubframe == "usesubframe_recipe" then
		mainframename = 'equip_sub'
		addinfoframename = 'equip_sub_addinfo'
	end

	local ypos = DRAW_EQUIP_COMMON_TOOLTIP(tooltipframe, invitem, mainframename); -- 장비라면 공통적으로 그리는 툴팁들
	
	ypos = DRAW_ITEM_TYPE_N_WEIGHT(tooltipframe, invitem, ypos, mainframename) -- 타입, 무게.

    local basicTooltipProp = invitem.BasicTooltipProp;
    if basicTooltipProp ~= 'None' then
        local basicTooltipPropList = StringSplit(invitem.BasicTooltipProp, ';');
        for i = 1, #basicTooltipPropList do
            basicTooltipProp = basicTooltipPropList[i];
            ypos = DRAW_EQUIP_ATK_N_DEF(tooltipframe, invitem, ypos, mainframename, strarg, basicTooltipProp); -- 공격력, 방어력, 타입 아이콘 
        end
    end

    if basicTooltipProp ~= 'None' then
        local itemGuid = tooltipframe:GetUserValue('TOOLTIP_ITEM_GUID');
	    local isEquiped = 1;
	    if session.GetEquipItemByGuid(itemGuid) == nil then
		    isEquiped = 0
	    end
        local tooltipMainFrame = GET_CHILD(tooltipframe, mainframename, 'ui::CGroupBox');
        ypos = SET_REINFORCE_TEXT(tooltipMainFrame, invitem, ypos, isEquiped, basicTooltipProp);
	    ypos = SET_TRANSCEND_TEXT(tooltipMainFrame, invitem, ypos, isEquiped);
	    ypos = SET_BUFF_TEXT(tooltipMainFrame, invitem, ypos, strarg);
	    ypos = SET_REINFORCE_BUFF_TEXT(tooltipMainFrame, invitem, ypos);
    end

	local addinfoGBox = GET_CHILD(tooltipframe, addinfoframename,'ui::CGroupBox') -- 젬 툴팁 위치 삽입
	addinfoGBox:SetOffset(addinfoGBox:GetX(),ypos)
	addinfoGBox:Resize(addinfoGBox:GetOriginalWidth(),0)
	
		ypos = DRAW_EQUIP_PROPERTY(tooltipframe, invitem, ypos, mainframename) --각종 프로퍼티
	ypos = DRAW_EQUIP_SET(tooltipframe, invitem, ypos, mainframename) -- 세트아이템
	ypos = DRAW_EQUIP_MEMO(tooltipframe, invitem, ypos, mainframename) -- 제작 템 시 들어간 메모
	ypos = DRAW_EQUIP_DESC(tooltipframe, invitem, ypos, mainframename) -- 각종 프로퍼티
	ypos = DRAW_AVAILABLE_PROPERTY(tooltipframe, invitem, ypos, mainframename) -- 장착제한, 거래제한, 소켓, 레벨 제한 등등
	ypos = DRAW_EQUIP_PR_N_DUR(tooltipframe, invitem, ypos, mainframename) -- 포텐셜 및 내구도
	ypos = DRAW_EQUIP_ONLY_PR(tooltipframe, invitem, ypos, mainframename) -- 포텐셜 만 있는 애들은 여기서 그림 (그릴 아이템인지 검사는 내부에서)
	
	local isHaveLifeTime = TryGetProp(invitem, "LifeTime");	
	if 0 == isHaveLifeTime then
		ypos = DRAW_SELL_PRICE(tooltipframe, invitem, ypos, mainframename);
	else
		ypos = DRAW_REMAIN_LIFE_TIME(tooltipframe, invitem, ypos, mainframename);
	end

	local subframeypos = 0

	--서브프레임쪽.
	if IS_NEED_DRAW_GEM_TOOLTIP(invitem) == true then
		subframeypos = DRAW_EQUIP_SOCKET(tooltipframe, invitem, subframeypos, addinfoframename) -- 소켓 및 옵션
	end

	if IS_NEED_DRAW_MAGICAMULET_TOOLTIP(invitem) == true then
		subframeypos = DRAW_EQUIP_MAGICAMULET(tooltipframe, invitem, subframeypos, addinfoframename) -- 매직어뮬렛
	end

	--tooltipframe:Resize(tooltipframe:GetOriginalWidth(), ypos);

end


function REINFORCE_ITEM_TOOLTIP_WEAPON_CHANGEVALUE(frame,  reinforceItem, oriItem, strarg, ispickitem)
	local ypos = DRAW_REINFORCE_CHANGE_WEAPON_TOOLTIP(frame, reinforceItem, oriItem, ypos, ispickitem);
	return ypos;
end

function REINFORCE_ITEM_TOOLTIP_ARMOR_CHANGEVALUE(tooltipframe, reinforceItem, oriItem, strarg, ispickitem)
	local ypos = DRAW_REINFORCE_CHANGE_ARMOR_TOOLTIP(tooltipframe, reinforceItem, oriItem, ypos, ispickitem);
	return ypos;
end

function DRAW_REINFORCE_CHANGE_WEAPON_TOOLTIP(tooltipframe, reinforceItem, oriItem, ypos, ispickitem)
	local GroupCtrl   = tooltipframe:GetChild('changevalue');
	local reinforcechange = tolua.cast(GroupCtrl, 'ui::CGroupBox');

	local cnt 			 = GroupCtrl:GetChildCount();
	local ControlSetObj	 = GroupCtrl:CreateControlSet('changevalue', "EX" .. cnt , 0, 0);
	local ControlSetCtrl = tolua.cast(ControlSetObj, 'ui::CControlSet');

	local X_MARGIN_OF_TITLE = ControlSetCtrl:GetUserConfig("X_MARGIN_OF_TITLE")
	local Y_MARGIN_OF_TITLE = ControlSetCtrl:GetUserConfig("Y_MARGIN_OF_TITLE")
	local MARGIN_BETWEEN_VALUE_N_VALUE = ControlSetCtrl:GetUserConfig("MARGIN_BETWEEN_VALUE_N_VALUE")

	ControlSetCtrl:SetOffset(X_MARGIN_OF_TITLE, cnt * MARGIN_BETWEEN_VALUE_N_VALUE + Y_MARGIN_OF_TITLE)

	local richtextChild	 = GET_CHILD(ControlSetCtrl, "changetext", "ui::CRichText");
	richtextChild:SetText(ScpArgMsg('Auto_{#050505}{s22}{b}JangBi_KangWhaSi'));
    
    local list = GET_ATK_PROP_CHANGEVALUETOOLTIP_LIST();
    
    if ispickitem == 1 then
        list = GET_ATK_PICK_PROP_LIST();
	end
	ABILITY_CHANGEVALUE_SKINSET(tooltipframe, "WEAPON", reinforceItem, oriItem);
	return COMPARISON_BY_PROPLIST(list, reinforceItem, oriItem, tooltipframe, reinforcechange, ispickitem);

end


function DRAW_REINFORCE_CHANGE_ARMOR_TOOLTIP(tooltipframe, reinforceItem, oriItem, ypos, ispickitem)

	local GroupCtrl = tooltipframe:GetChild('changevalue');
	local reinforcechange = tolua.cast(GroupCtrl, 'ui::CGroupBox');

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
	
	richtextChild:SetText(ScpArgMsg('Auto_{#050505}{s22}{b}JangBi_KangWhaSi'));
	
	ABILITY_CHANGEVALUE_SKINSET(tooltipframe, "ARMOR", reinforceItem, oriItem);

	local list = GET_DEF_PROP_CHANGEVALUETOOLTIP_LIST();
	return COMPARISON_BY_PROPLIST(list,reinforceItem, oriItem, tooltipframe, reinforcechange, ispickitem);

end
