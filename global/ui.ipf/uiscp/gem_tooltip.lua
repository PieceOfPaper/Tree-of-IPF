---- gem_tooltip.lua
-- 보석 아이템

function ITEM_TOOLTIP_GEM(tooltipframe, invitem, strarg)

	tolua.cast(tooltipframe, "ui::CTooltipFrame");

	local mainframename = 'gem'

	local ypos = DRAW_GEM_COMMON_TOOLTIP(tooltipframe, invitem, mainframename); -- 기타 템이라면 공통적으로 그리는 툴팁들
	ypos = DRAW_GEM_PROPERTYS_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 젬의 속성들 그려줌
	ypos = DRAW_GEM_DESC_TOOLTIP(tooltipframe, invitem, ypos, mainframename); -- 젬 설명. 프로퍼티 말고. 오른쪽 클릭 후 장착하고 어쩌고 하는 그런것들
	ypos = DRAW_SELL_PRICE(tooltipframe, invitem, ypos, mainframename);

end


function DRAW_GEM_COMMON_TOOLTIP(tooltipframe, invitem, mainframename)
	
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveAllChild()
	
	local CSet = gBox:CreateControlSet('tooltip_gem_common', 'gem_common_cset', 0, 0);
	tolua.cast(CSet, "ui::CControlSet");

	local GRADE_FONT_SIZE = CSet:GetUserConfig("GRADE_FONT_SIZE"); -- 등급 나타내는 별 크기

	-- 아이템 이미지
	local itemPicture = GET_CHILD(CSet, "itempic", "ui::CPicture");
	if invitem.TooltipImage ~= nil and invitem.TooltipImage ~= 'None' then
		itemPicture:SetImage(invitem.TooltipImage);
		itemPicture:ShowWindow(1);
	else
		itemPicture:ShowWindow(0);
	end
	
	-- 로스팅 레벨
	local roatingText = GET_CHILD(CSet, "roastinglv_text");
	roatingText:ShowWindow(0);
	roatingText:SetTextByKey('level',invitem.GemRoastingLv)
	if invitem.GemRoastingLv > 0  then
        roatingText:ShowWindow(1)
	end
	

	-- 별 그리기
	SET_GRADE_TOOLTIP(CSet, invitem, GRADE_FONT_SIZE);

	-- 아이템 이름 세팅
	local fullname = GET_FULL_NAME(invitem, true);
	local nameChild = GET_CHILD(CSet, "name", "ui::CRichText");
	nameChild:SetText(fullname);

	-- 레벨 몇인지 : 그냥 경험치만 표시하고 레벨은 별 개수로 표시하도록 바꿈 - 140722 ayase
	local level_text = GET_CHILD(CSet,'level_text','ui::CGauge')
	--level_text:SetTextByKey("level", invitem.Level);

	-- 경험치 게이지
	local level_gauge = GET_CHILD(CSet,'level_gauge','ui::CGauge')
	local lv, curExp, maxExp = GET_ITEM_LEVEL_EXP(invitem);
	if curExp > maxExp then
		curExp = maxExp;
	end
	level_gauge:SetPoint(curExp, maxExp);

	if maxExp == 0 then
		level_text:ShowWindow(0)
		level_gauge:ShowWindow(0)
	end

	-- 무게
	local weightRichtext = GET_CHILD(CSet, "weight_text", "ui::CRichText");
	weightRichtext:SetTextByKey("weight",invitem.Weight);

	local BOTTOM_MARGIN = CSet:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	CSet:Resize(CSet:GetWidth(),level_gauge:GetY() + level_gauge:GetHeight() + BOTTOM_MARGIN);
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+CSet:GetHeight())
	return CSet:GetHeight();
end

-- 젬의 부위별 속성들
function DRAW_GEM_PROPERTYS_TOOLTIP(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_gem_property');
	
	local CSet = gBox:CreateOrGetControlSet('tooltip_gem_property', 'tooltip_gem_property', 0, yPos);
	local property_gbox= GET_CHILD(CSet,'gem_property_gbox','ui::CGroupBox')

	local inner_yPos = 0;
	local innerCSet = nil
	local innerpropcount = 0
	local innerpropypos = 0

	local propNameList = GET_ITEM_PROP_NAME_LIST(invitem)
	for i = 1 , #propNameList do

		local title = propNameList[i]["Title"];
		local propName = propNameList[i]["PropName"];
		local propValue = propNameList[i]["PropValue"];
		local useOperator = propNameList[i]["UseOperator"];
		local propOptDesc = propNameList[i]["OptDesc"];
		if title ~= nil then
			-- 각 프로퍼티 마다 컨트롤셋 생성. 무기에서 한번, 상의에서 한번 이런 식
			innerCSet = property_gbox:CreateOrGetControlSet('tooltip_each_gem_property', title, 0, inner_yPos); 
			local type_text = GET_CHILD(innerCSet,'type_text','ui::CRichText')
			type_text:SetText( ScpArgMsg(title) )
			local type_icon = GET_CHILD(innerCSet,'type_icon','ui::CPicture')
			tolua.cast(CSet, "ui::CControlSet");
			local imgname = GET_ICONNAME_BY_WHENEQUIPSTR(CSet,title)
			type_icon:SetImage( imgname )
			innerpropcount = 0
			innerpropypos = type_text:GetHeight()+type_text:GetY()
			
		else
			local type_text = GET_CHILD(innerCSet,'type_text','ui::CRichText')
			-- 각 프로퍼티의 옵션 마다 컨트롤셋 생성. 공격력+10에서 한번, 블럭+10에서 한번 이런 식
			innerInnerCSet = innerCSet:CreateOrGetControlSet('tooltip_each_gem_property_each_text', 'proptext'..innerpropcount, 0, innerpropypos);
			
			local realtext = nil
			if propName == "CoolDown" then
				propValue = propValue / 1000;
				realtext = ScpArgMsg("CoolDown : {Sec} Sec", "Sec", propValue);
			elseif propName == "OptDesc" then
				realtext = propOptDesc;
			else
				if useOperator ~= nil and propValue > 0 then
					realtext = ScpArgMsg(propName) .. " : " .."{img green_up_arrow 16 16}".. propValue;
				else
					realtext = ScpArgMsg(propName) .. " : " .."{img red_down_arrow 16 16}".. propValue;
				end
			end
			
			local proptext = GET_CHILD(innerInnerCSet,'prop_text','ui::CRichText')
			if propName == "OptDesc" then
				realtext = propOptDesc;
			proptext:SetText( realtext )
			else
				proptext:SetText( realtext )
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

	property_gbox:Resize(property_gbox:GetOriginalWidth(),inner_yPos);

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	CSet:Resize(CSet:GetWidth(),CSet:GetHeight() + property_gbox:GetHeight() + property_gbox:GetY() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + CSet:GetHeight())
	return CSet:GetHeight() + CSet:GetY();
end

function DRAW_GEM_DESC_TOOLTIP(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_gem_desc');
	
	local CSet = gBox:CreateOrGetControlSet('tooltip_gem_desc', 'tooltip_gem_desc', 0, yPos);
	local descRichtext= GET_CHILD(CSet,'desc_text','ui::CRichText')

	descRichtext:SetText(invitem.Desc)

	tolua.cast(CSet, "ui::CControlSet");
	local BOTTOM_MARGIN = CSet:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	CSet:Resize(CSet:GetWidth(), descRichtext:GetHeight() + BOTTOM_MARGIN);
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+CSet:GetHeight())
	return CSet:GetHeight() + CSet:GetY();

end


-- 젬 툴팁의 옵션값들 리스트 생성.
function GETGEMTOOLTIP(obj, propNameList)
	
	local prop = geItemTable.GetProp(obj.ClassID);
	local gemExp = obj.ItemExp
	local lv = GET_ITEM_LEVEL_EXP(obj, gemExp);
	local socketProp = prop:GetSocketPropertyByLevel(lv);

	-- 알케미스트 젬 로스팅.  패널티부분을 로스팅 스킬레벨 만큼 빼서 적용
	local penaltyLv = 0;
	penaltyLv = lv - obj.GemRoastingLv;
	local drawPanetly = true;
	if 0 > penaltyLv then
		penaltyLv = 0;
	end
	if obj.GemRoastingLv > 0 and 0 >= penaltyLv then
		drawPanetly = false
	end

	local socketPenaltyProp = prop:GetSocketPropertyByLevel(penaltyLv);
	
	for i = 0, ITEM_SOCKET_PROPERTY_TYPE_COUNT - 1 do
		local cnt = socketProp:GetPropAddCount(i);
		if cnt > 0 then
			local socketType = geItemTable.GetSocketPropertyTypeStr(i);
			local langType = "WhenEquipTo" ..socketType;

			propNameList[#propNameList + 1] = {};
			propNameList[#propNameList]["Title"] = langType;
		end

		-- 추가효과
		for j = 0 , cnt - 1 do
			local propAdd = socketProp:GetPropAddByIndex(i, j);
			-- 나도 얘네는 "Title"의 하위 테이블로 들어가는게 구조상 맞다고 생각은 하지만, 루아 테이블을 3중 이상 쓰는 것은 썩 좋지 않은거 같다. 안타깝게도 내 머리가 못따라감.
			propNameList[#propNameList + 1] = {};
			propNameList[#propNameList]["PropName"] = propAdd:GetPropName(); 
			propNameList[#propNameList]["PropValue"] = propAdd.value;
			propNameList[#propNameList]["UseOperator"] = true;
			if propAdd:GetPropName() == "OptDesc" then
			--print(propAdd:GetPropDesc())
				propNameList[#propNameList]["OptDesc"] = propAdd:GetPropDesc();
			end
		end
		
		if true == drawPanetly then
			-- 패널티
			cnt = socketPenaltyProp:GetPropPenaltyAddCount(i);
			for j = 0 , cnt - 1 do
				local propPenaltyAdd = socketPenaltyProp:GetPropPenaltyAddByIndex(i, j);
				-- 나도 얘네는 "Title"의 하위 테이블로 들어가는게 구조상 맞다고 생각은 하지만, 루아 테이블을 3중 이상 쓰는 것은 썩 좋지 않은거 같다. 안타깝게도 내 머리가 못따라감.
				propNameList[#propNameList + 1] = {};
				propNameList[#propNameList]["PropName"] = propPenaltyAdd:GetPropName(); 
				propNameList[#propNameList]["PropValue"] = propPenaltyAdd.value;
				propNameList[#propNameList]["UseOperator"] = true;
				if propPenaltyAdd:GetPropName() == "OptDesc" then
					propNameList[#propNameList]["OptDesc"] = propPenaltyAdd:GetPropDesc();
				end
			end
		end
	end
end



