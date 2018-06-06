-- equip_cardslot_tooltip.lua --

function EQUIP_CARDSLOT_INFO_TOOLTIP_INIT(addon, frame)
end

function EQUIP_CARDSLOT_INFO_TOOLTIP_OPEN(frame, slot, argStr, argNum)
	EQUIP_CARDSLOT_TOOLTIP_BOSSCARD(argNum);
end;

function EQUIP_CARDSLOT_INFO_TOOLTIP_CLOSE(frame, slot, argStr, argNum)	
	local tooltipFrame    = ui.GetFrame("equip_cardslot_tooltip");	
	tooltipFrame:ShowWindow(0);
end;

function EQUIP_CARDSLOT_TOOLTIP_BOSSCARD(argNum)
	
	local invenframe = ui.GetFrame('inventory');
	local frame    = ui.GetFrame("equip_cardslot_tooltip");		
	if frame:IsVisible() == 1 then
		return;
	end	
	local infoFrame = ui.GetFrame('equip_cardslot_info');
	if infoFrame:IsVisible() == 1 then
		frame:SetOffset(invenframe:GetX() - frame:GetWidth() - infoFrame:GetWidth(), frame:GetY());			
	else
		frame:SetOffset(invenframe:GetX() - frame:GetWidth(), frame:GetY());	
	end;

		
	local cardID, cardLv, cardExp = GETMYCARD_INFO(argNum);
	if cardID == 0 then
		return;
	end
	local ypos = EQUIP_CARDSLOT_DRAW_TOOLTIP(frame, cardID, cardLv); -- ���� ī���� ���������� �׸��� ������
	ypos = EQUIP_CARDSLOT_DRAW_ADDSTAT_TOOLTIP(frame, ypos, cardID);
	ypos = EQUIP_CARDSLOT_DRAW_EXP_TOOLTIP(frame, ypos, cardID, cardExp); -- ����ġ ��
	frame:Resize(frame:GetWidth(), ypos);
	frame:ShowWindow(1);
end


function EQUIP_CARDSLOT_DRAW_TOOLTIP(tooltipframe, cardID, cardLv)
	local gBox = GET_CHILD(tooltipframe, "bg")
	gBox:RemoveAllChild()

	local CSet = gBox:CreateControlSet('tooltip_bosscard_common', 'boss_common_cset', 0, 0);
	tolua.cast(CSet, "ui::CControlSet");

	local GRADE_FONT_SIZE = CSet:GetUserConfig("GRADE_FONT_SIZE"); -- ��� ��Ÿ���� �� ũ��
	
	local cls = GetClassByType("Item", cardID);
	
	-- ������ �̹���
	local itemPicture = GET_CHILD(CSet, "itempic");
	itemPicture:SetImage(cls.TooltipImage);
	
	-- �� �׸���	
	local gradeChild = CSet:GetChild('grade');
	if gradeChild ~= nil then
		local gradeString = GET_STAR_TXT_REDUCED(GRADE_FONT_SIZE, cardLv, 0);
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
