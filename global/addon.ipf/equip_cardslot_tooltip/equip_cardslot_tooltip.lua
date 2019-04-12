-- equip_cardslot_tooltip.lua --

function EQUIP_CARDSLOT_INFO_TOOLTIP_INIT(addon, frame)
end

function EQUIP_CARDSLOT_INFO_TOOLTIP_OPEN(frame, slot, argStr, groupSlotIndex)
	if slot == nil then
		return
	end

	local parentSlotSet = slot:GetParent()
	if parentSlotSet == nil then
		return
	end

	local slotIndex = slot:GetSlotIndex()
	if parentSlotSet:GetName() == 'ATKcard_slotset' then
		slotIndex = slotIndex + 0
	elseif parentSlotSet : GetName() == 'DEFcard_slotset' then
		slotIndex = slotIndex + 3
	elseif parentSlotSet : GetName() == 'UTILcard_slotset' then		
		slotIndex = slotIndex + 6
	elseif parentSlotSet : GetName() == 'STATcard_slotset' then
		slotIndex = slotIndex + 9
	elseif parentSlotSet : GetName() == 'LEGcard_slotset' then
		slotIndex = slotIndex + 12
	end
	EQUIP_CARDSLOT_TOOLTIP_BOSSCARD(slotIndex);
end;

function EQUIP_CARDSLOT_INFO_TOOLTIP_CLOSE(frame, slot, argStr, argNum)	
	local tooltipFrame    = ui.GetFrame("equip_cardslot_tooltip");	
	tooltipFrame:ShowWindow(0);
end;

function EQUIP_CARDSLOT_INFO_TOOLTIP_CLOSE_TEST(frame, slot, argStr, argNum)	
	local tooltipFrame    = ui.GetFrame("monstercardslot");	
	tooltipFrame:ShowWindow(0);
end;

function EQUIP_CARDSLOT_TOOLTIP_BOSSCARD(slotIndex)
	local frame = ui.GetFrame("equip_cardslot_tooltip");		
	tolua.cast(frame, "ui::CTooltipFrame");
	if frame:IsVisible() == 1 then
		return;
	end	

	local infoFrame = ui.GetFrame('monstercardslot');
	if infoFrame:IsVisible() == 0 then
		return
	end
		
	if slotIndex >= 0 and slotIndex <= 2 or slotIndex >= 6 and slotIndex <= 8 then
		if infoFrame:GetX() - frame:GetWidth() < 0 then
			frame:SetOffset(infoFrame:GetX() + infoFrame:GetWidth(), frame : GetY());
		else
			frame:SetOffset(infoFrame :GetX() - frame:GetWidth() , frame:GetY());
		end
	else
		if infoFrame:GetX() + infoFrame : GetWidth() + frame : GetWidth() > ui.GetClientInitialWidth() then
			frame : SetOffset(infoFrame : GetX() - frame : GetWidth(), frame : GetY());
		else
			frame:SetOffset(infoFrame : GetX() + infoFrame : GetWidth(), frame : GetY());
		end
	end
	local cardID, cardLv, cardExp = GETMYCARD_INFO(slotIndex);
	local cls = GetClassByType("Item", cardID);
	if cardID == 0 then
		return;
	end

	local prop = geItemTable.GetProp(cardID);
	if prop ~= nil then
		cardLv = prop:GetLevel(cardExp);
	end

	local ypos = EQUIP_CARDSLOT_DRAW_TOOLTIP(frame, cardID, cardLv);
	ypos = EQUIP_CARDSLOT_DRAW_ADDSTAT_TOOLTIP(frame, ypos, cardID);
	if cls ~= nil and cls.ToolTipScp ~= 'LEGEND_BOSSCARD' then
		ypos = EQUIP_CARDSLOT_DRAW_EXP_TOOLTIP(frame, ypos, cardID, cardExp);
	end
	frame:Resize(frame:GetWidth(), ypos);
	frame:ShowWindow(1);
end


function EQUIP_CARDSLOT_DRAW_TOOLTIP(tooltipframe, cardID, cardLv)
	local gBox = GET_CHILD(tooltipframe, "bg")
	gBox:RemoveAllChild()

	local CSetBg = gBox : CreateControlSet('tooltip_bosscard_bg', 'boss_bg_inven', 0, 200);
	local CSet = gBox:CreateControlSet('tooltip_bosscard_common', 'boss_common_cset', 0, 0);
	tolua.cast(CSet, "ui::CControlSet");

	local GRADE_FONT_SIZE = CSet:GetUserConfig("GRADE_FONT_SIZE"); -- ��� ��Ÿ���� �� ũ��
	
	local cls = GetClassByType("Item", cardID);
	
	SET_CARD_EDGE_TOOLTIP(CSet, cls);

	-- ������ �̹���
	local spineItemPicture = GET_CHILD(CSet, "itempic");
	SET_SPINE_TOOLTIP_IMAGE(spineItemPicture, cls);

	-- �� �׸���	
	local gradeChild = CSet:GetChild('grade');
	if gradeChild ~= nil then
		local gradeString = GET_STAR_TXT_REDUCED(GRADE_FONT_SIZE, cls, cardLv, 0);
		gradeChild:SetText(gradeString);
	end;

	-- ������ �̸� ����
	local fullname = GET_FULL_NAME(cls, true);
	local nameChild = GET_CHILD(CSet, "name");
	nameChild:SetText(fullname);
		
	-- ���� ����
	local bossCls = GetClassByType('Monster', cls.NumberArg1);
	local typeRichtext = GET_CHILD(CSet, "type_text");
	typeRichtext:SetText(ScpArgMsg(bossCls.RaceType));
    
	local BOTTOM_MARGIN = CSet:GetUserConfig("BOTTOM_MARGIN"); -- �� �Ʒ��� ����
	CSet:Resize(CSet:GetWidth(), 0);
	CSet:Resize(CSet:GetWidth(),typeRichtext:GetY() + typeRichtext:GetHeight() + BOTTOM_MARGIN);
	gBox:Resize(gBox:GetWidth(), 0);
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + CSet:GetHeight())
	return CSet:GetHeight();
end

--����ġ
function EQUIP_CARDSLOT_DRAW_EXP_TOOLTIP(tooltipframe, yPos, cardID, cardExp)
	local gBox = GET_CHILD(tooltipframe, "bg");
	gBox:RemoveChild('tooltip_bosscard_exp');
	
	local CSet = gBox:CreateControlSet('tooltip_bosscard_exp', 'tooltip_bosscard_exp', 0, yPos);
	--����ġ ������
	local gauge = GET_CHILD(CSet,'level_gauge')
	local lv, curExp, maxExp = GET_ITEM_LEVEL_EXP_BYCLASSID(cardID, cardExp);
	if curExp > maxExp then
		curExp = maxExp;
	end
	gauge:SetPoint(curExp, maxExp);
	
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + CSet:GetHeight())
	return CSet:GetHeight() + CSet:GetY();
end

--����
function EQUIP_CARDSLOT_DRAW_ADDSTAT_TOOLTIP(tooltipframe, yPos, cardID)
	local gBox = GET_CHILD(tooltipframe, "bg");
	gBox:RemoveChild('tooltip_bosscard_desc');
	
	local CSet = gBox:CreateControlSet('tooltip_bosscard_desc', 'tooltip_bosscard_desc', 0, yPos)	
	--����
	local desc_text = GET_CHILD(CSet,'desc_text')
	local cls = GetClassByType("Item", cardID);
	if cls ~= nil then
		local tempText1 = cls.Desc;
		local tempText2 = cls.Desc_Sub;
		if tempText1 == "None" then
			tempText1 = "";
		end
		if tempText2 == "None" then
			tempText2 = "";
		end
		local textDesc = string.format("%s{nl}%s{/}", tempText1, tempText2);	
		desc_text:SetTextByKey("text", textDesc);
		CSet:Resize(CSet:GetWidth(), desc_text:GetHeight() + desc_text:GetOffsetY());
	end
	
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + CSet:GetHeight() + 10)
	return CSet:GetHeight() + CSet:GetY() + 10;
end
