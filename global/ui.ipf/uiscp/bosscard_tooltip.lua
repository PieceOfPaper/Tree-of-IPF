-- bosscard_tooltip.lua
-- 보스카드 아이템

function ITEM_TOOLTIP_BOSSCARD(tooltipframe, invitem, strarg)

	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local mainframename = 'bosscard'

	local ypos = DRAW_BOSSCARD_COMMON_TOOLTIP(tooltipframe, invitem, mainframename); -- 보스 카드라면 공통적으로 그리는 툴팁들
	ypos = DRAW_BOSSCARD_ADDSTAT_TOOLTIP(tooltipframe, invitem, ypos, mainframename);
	ypos = DRAW_BOSSCARD_EXP_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 경험치 바
	ypos = DRAW_SELL_PRICE(tooltipframe, invitem, ypos, mainframename);
end


function DRAW_BOSSCARD_COMMON_TOOLTIP(tooltipframe, invitem, mainframename)
	
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveAllChild()
	
	local CSet = gBox:CreateControlSet('tooltip_bosscard_common', 'boss_common_cset', 0, 0);
	tolua.cast(CSet, "ui::CControlSet");

	local GRADE_FONT_SIZE = CSet:GetUserConfig("GRADE_FONT_SIZE"); -- 등급 나타내는 별 크기

	-- 아이템 이미지
	local itemPicture = GET_CHILD(CSet, "itempic");
	itemPicture:SetImage(invitem.TooltipImage);

	-- 별 그리기
	SET_GRADE_TOOLTIP(CSet, invitem, GRADE_FONT_SIZE);

	-- 아이템 이름 세팅
	local fullname = GET_FULL_NAME(invitem, true);
	local nameChild = GET_CHILD(CSet, "name");
	nameChild:SetText(fullname);

	-- 종족 세팅
	local bossCls = GetClassByType('Monster', invitem.NumberArg1);
	local typeRichtext = GET_CHILD(CSet, "type_text");
	typeRichtext:SetText(ScpArgMsg(bossCls.RaceType));


	local BOTTOM_MARGIN = CSet:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	CSet:Resize(CSet:GetWidth(),typeRichtext:GetY() + typeRichtext:GetHeight() + BOTTOM_MARGIN);
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+CSet:GetHeight())
	return CSet:GetHeight();
end

--포텐 및 내구도
function DRAW_BOSSCARD_EXP_TOOLTIP(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename)
	gBox:RemoveChild('tooltip_bosscard_exp');
	
	local CSet = gBox:CreateControlSet('tooltip_bosscard_exp', 'tooltip_bosscard_exp', 0, yPos);

	--경험치 게이지
	local gauge = GET_CHILD(CSet,'level_gauge','ui::CGauge')
	local lv, curExp, maxExp = GET_ITEM_LEVEL_EXP(invitem);
	if curExp > maxExp then
		curExp = maxExp;
	end
	gauge:SetPoint(curExp, maxExp);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + CSet:GetHeight())
	return CSet:GetHeight() + CSet:GetY();
end

--스텟
function DRAW_BOSSCARD_ADDSTAT_TOOLTIP(tooltipframe, invitem, yPos, mainframename)
	local gBox = GET_CHILD(tooltipframe, mainframename)
	gBox:RemoveChild('tooltip_bosscard_desc');
	
	local CSet = gBox:CreateControlSet('tooltip_bosscard_desc', 'tooltip_bosscard_desc', 0, yPos);
		
	--스텟
	local desc_text = GET_CHILD(CSet,'desc_text')
	desc_text:SetTextByKey("text", invitem.Desc);
	CSet:Resize(CSet:GetWidth(), desc_text:GetHeight() + desc_text:GetOffsetY());
	
	
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + CSet:GetHeight() + 10)
	return CSet:GetHeight() + CSet:GetY() + 10;
end
