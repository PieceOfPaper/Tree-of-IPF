-- equip_tooltip.lua

function ITEM_TOOLTIP_WEAPON(tooltipframe, invitem, strarg, usesubframe)

	ITEM_TOOLTIP_EQUIP(tooltipframe, invitem, strarg, usesubframe)
end

function ITEM_TOOLTIP_ARMOR(tooltipframe, invitem, strarg, usesubframe, isForgery)
	ITEM_TOOLTIP_EQUIP(tooltipframe, invitem, strarg, usesubframe, isForgery) ;
end

function ITEM_TOOLTIP_EQUIP(tooltipframe, invitem, strarg, usesubframe, isForgery)
	if isForgery == nil then
		isForgery = false;
	end
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
    local ypos = 0

    local addinfoGBox = GET_CHILD(tooltipframe, addinfoframename,'ui::CGroupBox') -- 서브 프레임 위치 삽입
	addinfoGBox:SetOffset(addinfoGBox:GetX(),ypos)
	addinfoGBox:Resize(addinfoGBox:GetOriginalWidth(),0)

    if IS_USE_SET_TOOLTIP(invitem) == 1 then
    	ypos = DRAW_EQUIP_COMMON_TOOLTIP_SMALL_IMG(tooltipframe, invitem, mainframename, isForgery); -- 장비라면 공통적으로 그리는 툴팁들
    else
		ypos = DRAW_EQUIP_COMMON_TOOLTIP(tooltipframe, invitem, mainframename, isForgery); -- 장비라면 공통적으로 그리는 툴팁들
		ypos = DRAW_ITEM_TYPE_N_WEIGHT(tooltipframe, invitem, ypos, mainframename) -- 타입, 무게.
	end

    local basicTooltipProp = 'None';
    if invitem.BasicTooltipProp ~= 'None' then
        local basicTooltipPropList = StringSplit(invitem.BasicTooltipProp, ';');
        for i = 1, #basicTooltipPropList do
            basicTooltipProp = basicTooltipPropList[i];
            ypos = DRAW_EQUIP_ATK_N_DEF(tooltipframe, invitem, ypos, mainframename, strarg, basicTooltipProp); -- 공격력, 방어력, 타입 아이콘 
        end
    end
    

	local value = IS_TOGGLE_EQUIP_ITEM_TOOLTIP_DESC();
    if basicTooltipProp ~= 'None' and value ~= 1 then
    	local bg_ypos = ypos -- 음영처리할 box ypos
        local itemGuid = tooltipframe:GetUserValue('TOOLTIP_ITEM_GUID');
	    local isEquiped = 1;
	    if session.GetEquipItemByGuid(itemGuid) == nil then
		    isEquiped = 0
	    end

        local tooltipMainFrame = GET_CHILD(tooltipframe, mainframename, 'ui::CGroupBox');
        DRAW_TOOLTIP_SUB_BG(tooltipMainFrame, bg_ypos)
        ypos = SET_REINFORCE_TEXT(tooltipMainFrame, invitem, ypos, isEquiped, basicTooltipProp);
	    ypos = SET_TRANSCEND_TEXT(tooltipMainFrame, invitem, ypos, isEquiped);
	    ypos = SET_BUFF_TEXT(tooltipMainFrame, invitem, ypos, strarg);
	    ypos = SET_REINFORCE_BUFF_TEXT(tooltipMainFrame, invitem, ypos);
	    local bg_height = ypos - bg_ypos		
		RESIZE_TOOLTIP_SUB_BG(tooltipMainFrame, bg_ypos, bg_height)
	end
	if invitem.InheritanceItemName ~= nil and invitem.InheritanceItemName ~= "None" then
		local temp = GetClass('Item', invitem.InheritanceItemName)
		ypos = DRAW_EQUIP_PROPERTY(tooltipframe, temp, ypos, mainframename, invitem) -- 각종 프로퍼티
	else
		ypos = DRAW_EQUIP_PROPERTY(tooltipframe, invitem, ypos, mainframename) -- 각종 프로퍼티
	end

	ypos = DRAW_EQUIP_SOCKET_COUNT(tooltipframe, invitem, ypos, mainframename)
	if IS_NEED_DRAW_GEM_TOOLTIP(invitem) == true then
		ypos = DRAW_EQUIP_SOCKET(tooltipframe, invitem, ypos, mainframename) -- 소켓 및 옵션
	end
	ypos = DRAW_EQUIP_MEMO(tooltipframe, invitem, ypos, mainframename) -- 제작 템 시 들어간 메모
	ypos = DRAW_EQUIP_DESC(tooltipframe, invitem, ypos, mainframename) -- 각종 설명문
	if IS_USE_SET_TOOLTIP(invitem) ~= 1 then
		ypos = DRAW_AVAILABLE_PROPERTY(tooltipframe, invitem, ypos, mainframename) -- 장착제한, 거래제한, 소켓, 레벨 제한 등등
	end
    ypos = DRAW_EQUIP_TRADABILITY(tooltipframe, invitem, ypos, mainframename) -- 거래 제한

	if IS_USE_SET_TOOLTIP(invitem) == 1 then
    	ypos = DRAW_CANNOT_REINFORCE(tooltipframe, invitem, ypos, mainframename) -- 초월 및 강화불가
    end

	ypos = DRAW_EQUIP_PR_N_DUR(tooltipframe, invitem, ypos, mainframename) -- 포텐셜 및 내구도
	ypos = DRAW_EQUIP_ONLY_PR(tooltipframe, invitem, ypos, mainframename) -- 포텐셜 만 있는 애들은 여기서 그림 (그릴 아이템인지 검사는 내부에서)
	local isHaveLifeTime = TryGetProp(invitem, "LifeTime");	
	if 0 == isHaveLifeTime then
		ypos = DRAW_SELL_PRICE(tooltipframe, invitem, ypos, mainframename);
	else
		ypos = DRAW_REMAIN_LIFE_TIME(tooltipframe, invitem, ypos, mainframename);
	end
    
    ypos = DRAW_TOGGLE_EQUIP_DESC(tooltipframe, invitem, ypos, mainframename); -- 설명문 토글 여부



	local subframeypos = 0
	--서브프레임쪽.
	subframeypos = DRAW_EQUIP_SET(tooltipframe, invitem, subframeypos, addinfoframename) -- 세트아이템
	if IS_NEED_DRAW_MAGICAMULET_TOOLTIP(invitem) == true then
		subframeypos = DRAW_EQUIP_MAGICAMULET(tooltipframe, invitem, subframeypos, addinfoframename) -- 매직어뮬렛
	end
    local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
    gBox:Resize(gBox:GetWidth(), ypos)
end

-- 기본 정보
function DRAW_EQUIP_COMMON_TOOLTIP(tooltipframe, invitem, mainframename, isForgery)
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveAllChild()
	
    if invitem.ItemGrade == 0 then -- 유료 프리미엄 아이템 등급: 2~3만원 헤어
        local SkinName  = GET_ITEM_TOOLTIP_SKIN(invitem);
    	gBox:SetSkinName('premium_skin');
    else
        local SkinName  = GET_ITEM_TOOLTIP_SKIN(invitem);
    	gBox:SetSkinName('test_Item_tooltip_equip2');
    end

	local equipCommonCSet = gBox:CreateControlSet('tooltip_equip_common', 'equip_common_cset', 0, 0);
	tolua.cast(equipCommonCSet, "ui::CControlSet");

	local GRADE_FONT_SIZE = equipCommonCSet:GetUserConfig("GRADE_FONT_SIZE"); -- 등급 나타내는 별 크기

	-- 아이템 배경 이미지 : grade기준
	local item_bg = GET_CHILD(equipCommonCSet, "item_bg", "ui::CPicture");
	local needAppraisal = TryGetProp(invitem, "NeedAppraisal");
	local needRandomOption = TryGetProp(invitem, "NeedRandomOption")
	local gradeBGName = GET_ITEM_BG_PICTURE_BY_GRADE(invitem.ItemGrade, needAppraisal, needRandomOption)
	item_bg:SetImage(gradeBGName);
	-- 아이템 이미지
	local itemPicture = GET_CHILD(equipCommonCSet, "itempic", "ui::CPicture");
	if (needAppraisal ~= nil and needAppraisal == 1) or (needRandomOption ~= nil and needRandomOption == 1) then
		itemPicture:SetColorTone("FF111111");
	end

	if invitem.TooltipImage ~= nil and invitem.TooltipImage ~= 'None' then
	
    	if invitem.ClassType ~= 'Outer' and invitem.ClassType ~= 'SpecialCostume' then
			imageName = GET_EQUIP_ITEM_IMAGE_NAME(invitem, "TooltipImage")
    		itemPicture:SetImage(imageName);
    		itemPicture:ShowWindow(1);

    	else -- 코스튬은 남녀공용, 남자PC는 남자 코스튬 툴팁이미지, 여자PC는 여자 코스튬 툴팁이미지가 보임
            local gender = 0;
            if GetMyPCObject() ~= nil then
                local pc = GetMyPCObject();
                gender = pc.Gender;
            else
                gender = barrack.GetSelectedCharacterGender();
            end

			-- 살펴보기 중에는 살펴보기 중인 아이의 성별을 보자
			if tooltipframe:GetTopParentFrameName() == 'compare' then
				local compare = ui.GetFrame('compare');
				gender = compare:GetUserIValue('COMPARE_PC_GENDER');
			end

			local tempiconname = ''
			local origin = invitem.TooltipImage;
			local reverseIconName = origin:reverse();

			local underBarIndex = string.find(reverseIconName, '_');
			if underBarIndex ~= nil then
                tempiconname = string.sub(reverseIconName, 0, underBarIndex-1);
    			tempiconname = tempiconname:reverse();
    		end
			
            if tempiconname == "both" then
                local bothIndex = string.find(origin, '_both');
                tooltipImg = string.sub(invitem.TooltipImage, 0, bothIndex - 1);
        		itemPicture:SetImage(tooltipImg);
			elseif tempiconname ~= "m" and tempiconname ~= "f" then
				if gender == 1 then
        			tooltipImg = invitem.TooltipImage.."_m"
        			itemPicture:SetImage(tooltipImg);
        		else
        			tooltipImg = invitem.TooltipImage.."_f"
        			itemPicture:SetImage(tooltipImg);
        		end
			else
				itemPicture:SetImage(invitem.TooltipImage);
			end

    	    
    	end
	else
		itemPicture:ShowWindow(0);
	end


	-- 장착중 아이콘 
	local itemNowEquip = GET_CHILD(equipCommonCSet, "nowequip");
	if IsEquiped(invitem) == 1 then
		itemNowEquip:ShowWindow(1)
	else
		itemNowEquip:ShowWindow(0)
	end

	-- 모조품
	local forgeryEquip = GET_CHILD_RECURSIVELY(equipCommonCSet, 'forgeryequip');
	if mainframename == 'equip_main' and isForgery == true and tooltipframe:GetTopParentFrameName() == 'inventory' then
		forgeryEquip:ShowWindow(1);
		itemNowEquip:ShowWindow(0);
		APPRAISER_FORGERY_TOOLTIP_SET_BUFFTIME(forgeryEquip:GetChild('forgeryequip_text'));
	else
		forgeryEquip:ShowWindow(0);
	end
	
	-- 강화불가 
	local itemCantRFPicture = GET_CHILD(equipCommonCSet, "cantreinforce", "ui::CPicture");
	local itemCantRFText = GET_CHILD(equipCommonCSet, "cantrf_text", "ui::CPicture");
	if invitem.Reinforce_Type == "None" then
		itemCantRFPicture:ShowWindow(1);
		itemCantRFText:ShowWindow(1);
	else
		itemCantRFPicture:ShowWindow(0);
		itemCantRFText:ShowWindow(0);
	end

	-- 별 그리기
	--SET_GRADE_TOOLTIP(equipCommonCSet, invitem, GRADE_FONT_SIZE);

	-- 아이템 이름 세팅
	local itemGuid = tooltipframe:GetUserValue('TOOLTIP_ITEM_GUID');
	local isEquipedItem = 0;
	if session.GetEquipItemByGuid(itemGuid) ~= nil then
		isEquipedItem = 1;
	end
	local fullname = GET_FULL_NAME(invitem, true, isEquipedItem);
	local nameChild = GET_CHILD(equipCommonCSet, "name", "ui::CRichText");
	nameChild:SetText(fullname);
	nameChild:AdjustFontSizeByWidth(gBox:GetWidth());		-- 폰트 사이즈를 조정
	nameChild:SetTextAlign("center","center");				-- 중앙 정렬
	
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+equipCommonCSet:GetHeight())

	local retypos = equipCommonCSet:GetHeight();

	return retypos;
end

-- 작은 이미지 툴팁 기본 정보
function DRAW_EQUIP_COMMON_TOOLTIP_SMALL_IMG(tooltipframe, invitem, mainframename, isForgery)
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveAllChild()
	
    if invitem.ItemGrade == 0 then -- 유료 프리미엄 아이템 등급: 2~3만원 헤어
        local SkinName  = GET_ITEM_TOOLTIP_SKIN(invitem);
    	gBox:SetSkinName('premium_skin');
    else
        local SkinName  = GET_ITEM_TOOLTIP_SKIN(invitem);
    	gBox:SetSkinName('test_Item_tooltip_equip2');
    end

	local equipCommonCSet = gBox:CreateControlSet('tooltip_equip_small_img', 'equip_common_cset', 0, 0);
	tolua.cast(equipCommonCSet, "ui::CControlSet");

	local legendTitle = GET_CHILD_RECURSIVELY(equipCommonCSet, "legendTitle")
	legendTitle:ShowWindow(0)
--	local GRADE_FONT_SIZE = equipCommonCSet:GetUserConfig("GRADE_FONT_SIZE"); -- 등급 나타내는 별 크기

	local itemClass = GetClassByType("Item", invitem.ClassID);
	local gradeText = equipCommonCSet:GetUserConfig("GRADE_TEXT_FONT")
	if itemClass.ItemGrade == 1 then
		gradeText = gradeText .. equipCommonCSet:GetUserConfig("NORMAL_GRADE_TEXT")
	elseif itemClass.ItemGrade == 2 then
		gradeText = gradeText .. equipCommonCSet:GetUserConfig("MAGIC_GRADE_TEXT")
	elseif itemClass.ItemGrade == 3 then
		gradeText = gradeText .. equipCommonCSet:GetUserConfig("RARE_GRADE_TEXT")
	elseif itemClass.ItemGrade == 4 then
		gradeText = gradeText .. equipCommonCSet:GetUserConfig("UNIQUE_GRADE_TEXT")
	else
		gradeText = gradeText .. equipCommonCSet:GetUserConfig("LEGEND_GRADE_TEXT")
	end

	local transcend = TryGetProp(invitem, "Transcend");
	if transcend ~= nil and transcend > 0 then -- 초월한 경우 특수 title 배경
		legendTitle:ShowWindow(1)
	end

	local gradeName = GET_CHILD_RECURSIVELY(equipCommonCSet, "gradeName")
	gradeName:SetText(gradeText)

	-- 아이템 배경 이미지 : grade기준
	local item_bg = GET_CHILD(equipCommonCSet, "item_bg", "ui::CPicture");
	local needAppraisal = TryGetProp(invitem, "NeedAppraisal");
	local needRandomOption = TryGetProp(invitem, "NeedRandomOption")
	local gradeBGName = GET_ITEM_BG_PICTURE_BY_GRADE(invitem.ItemGrade, needAppraisal, needRandomOption)
	item_bg:SetImage(gradeBGName);
	-- 아이템 이미지
	local itemPicture = GET_CHILD(equipCommonCSet, "itempic", "ui::CPicture");
	if (needAppraisal ~= nil and needAppraisal == 1) or (needRandomOption ~= nil and needRandomOption == 1) then
		itemPicture:SetColorTone("FF111111");
	end

	if invitem.TooltipImage ~= nil and invitem.TooltipImage ~= 'None' then
	
    	if invitem.ClassType ~= 'Outer' and invitem.ClassType ~= 'SpecialCostume' then
			imageName = GET_EQUIP_ITEM_IMAGE_NAME(invitem, "TooltipImage")
    		itemPicture:SetImage(imageName);
    		itemPicture:ShowWindow(1);

    	else -- 코스튬은 남녀공용, 남자PC는 남자 코스튬 툴팁이미지, 여자PC는 여자 코스튬 툴팁이미지가 보임
            local gender = 0;
            if GetMyPCObject() ~= nil then
                local pc = GetMyPCObject();
                gender = pc.Gender;
            else
                gender = barrack.GetSelectedCharacterGender();
            end

			-- 살펴보기 중에는 살펴보기 중인 아이의 성별을 보자
			if tooltipframe:GetTopParentFrameName() == 'compare' then
				local compare = ui.GetFrame('compare');
				gender = compare:GetUserIValue('COMPARE_PC_GENDER');
			end

			local tempiconname = string.sub(invitem.TooltipImage,string.len(invitem.TooltipImage)-1);

			if tempiconname ~= "_m" and tempiconname ~= "_f" then
				if gender == 1 then
        			tooltipImg = invitem.TooltipImage.."_m"
        			itemPicture:SetImage(tooltipImg);
        		else
        			tooltipImg = invitem.TooltipImage.."_f"
        			itemPicture:SetImage(tooltipImg);
        		end
			else
				itemPicture:SetImage(invitem.TooltipImage);
			end

    	    
    	end
	else
		itemPicture:ShowWindow(0);
	end


	-- 장착중 아이콘 
	local itemNowEquip = GET_CHILD(equipCommonCSet, "nowequip");
	if IsEquiped(invitem) == 1 then
		itemNowEquip:ShowWindow(1)
	else
		itemNowEquip:ShowWindow(0)
	end

	-- 모조품
	local forgeryEquip = GET_CHILD_RECURSIVELY(equipCommonCSet, 'forgeryequip');
	if mainframename == 'equip_main' and isForgery == true and tooltipframe:GetTopParentFrameName() == 'inventory' then
		forgeryEquip:ShowWindow(1);
		itemNowEquip:ShowWindow(0);
		APPRAISER_FORGERY_TOOLTIP_SET_BUFFTIME(forgeryEquip:GetChild('forgeryequip_text'));
	else
		forgeryEquip:ShowWindow(0);
	end
	
	-- 강화불가 
--	local itemCantRFPicture = GET_CHILD(equipCommonCSet, "cantreinforce", "ui::CPicture");
--	local itemCantRFText = GET_CHILD(equipCommonCSet, "cantrf_text", "ui::CPicture");
--	if invitem.Reinforce_Type == "None" then
--		itemCantRFPicture:ShowWindow(1);
--		itemCantRFText:ShowWindow(1);
--	else
--		itemCantRFPicture:ShowWindow(0);
--		itemCantRFText:ShowWindow(0);
--	end

	-- 별 그리기
	--SET_GRADE_TOOLTIP(equipCommonCSet, invitem, GRADE_FONT_SIZE);

	-- 아이템 이름 세팅
	local itemGuid = tooltipframe:GetUserValue('TOOLTIP_ITEM_GUID');
	local isEquipedItem = 0;
	if session.GetEquipItemByGuid(itemGuid) ~= nil then
		isEquipedItem = 1;
	end
	local fullname = GET_FULL_NAME(invitem, true, isEquipedItem);
	local nameChild = GET_CHILD(equipCommonCSet, "name", "ui::CRichText");
	nameChild:SetText(fullname);
	nameChild:AdjustFontSizeByWidth(gBox:GetWidth());		-- 폰트 사이즈를 조정
	nameChild:SetTextAlign("center","center");				-- 중앙 정렬
	
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+equipCommonCSet:GetHeight())

	local retypos = equipCommonCSet:GetHeight();

	local value_type = GET_CHILD_RECURSIVELY(equipCommonCSet, "value_type")
	value_type:SetTextByKey("type", GET_REQ_TOOLTIP(invitem))

	local value_level = GET_CHILD_RECURSIVELY(equipCommonCSet, "value_level")

	local equipableLevelFont = ""
	if GETMYPCLEVEL() < invitem.UseLv then
		equipableLevelFont = equipCommonCSet:GetUserConfig("CANNOT_EQUIP_LEVEL_FONT")
	end

	value_level:SetTextByKey("level", equipableLevelFont .. invitem.UseLv ..' ');

	local value_weight = GET_CHILD_RECURSIVELY(equipCommonCSet, "value_weight")
	value_weight:SetTextByKey("weight", invitem.Weight..' ');

	SELECT_JOB_IMAGE(tooltipframe, invitem)


	return retypos;
end

function SELECT_JOB_IMAGE(tooltipframe, invitem)
	local warrior, wizard, archer, cleric = GET_USEJOB_TOOLTIP_SMALL_IMG(invitem)

	_SELECT_JOB_IMAGE(tooltipframe, invitem, warrior, wizard, archer, cleric)

end

function _SELECT_JOB_IMAGE(tooltipframe, invitem, warrior, wizard, archer, cleric)
	local jobImageGbox = GET_CHILD_RECURSIVELY(tooltipframe, "jobImageGbox")

	local warrior_unselect = GET_CHILD_RECURSIVELY(jobImageGbox, "jobimage_warrior_close")
	local warrior_select = GET_CHILD_RECURSIVELY(jobImageGbox, "jobimage_warrior_open")
	local wizard_unselect = GET_CHILD_RECURSIVELY(jobImageGbox, "jobimage_wizard_close")
	local wizard_select = GET_CHILD_RECURSIVELY(jobImageGbox, "jobimage_wizard_open")
	local archer_unselect = GET_CHILD_RECURSIVELY(jobImageGbox, "jobimage_archer_close")
	local archer_select = GET_CHILD_RECURSIVELY(jobImageGbox, "jobimage_archer_open")
	local cleric_unselect = GET_CHILD_RECURSIVELY(jobImageGbox, "jobimage_cleric_close")
	local cleric_select = GET_CHILD_RECURSIVELY(jobImageGbox, "jobimage_cleric_open")

	warrior_unselect:ShowWindow(1 - warrior)
	warrior_select:ShowWindow(warrior)
	wizard_unselect:ShowWindow(1 - wizard)
	wizard_select:ShowWindow(wizard)
	archer_unselect:ShowWindow(1 - archer)
	archer_select:ShowWindow(archer)
	cleric_unselect:ShowWindow(1 - cleric)
	cleric_select:ShowWindow(cleric)

end

function GET_USEJOB_TOOLTIP_SMALL_IMG(invitem)
	local usejob = TryGetProp(invitem,'UseJob')
	if usejob == nil then
		return 0, 0, 0, 0;
	end

	local warrior = 0
	local wizard = 0
	local archer = 0
	local cleric = 0

	if usejob == "All" then
		warrior = 1
		wizard = 1
		archer = 1
		cleric = 1
	else
    	local char1 = string.find(usejob, 'Char1')
    
    	if char1 ~= nil then
    		warrior = 1
    	end

    	local char2 = string.find(usejob, 'Char2')
    
    	if char2 ~= nil then
    		wizard = 1
    	end

    	local char3 = string.find(usejob, 'Char3')

    	if char3 ~= nil then
    		archer = 1
    	end

    	local char4 = string.find(usejob, 'Char4')
    
    	if char4 ~= nil then
			cleric = 1
   		end
	end

	return warrior, wizard, archer, cleric
end




--아이템 타입 및 무게
function DRAW_ITEM_TYPE_N_WEIGHT(tooltipframe, invitem, yPos, mainframename)
	
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')

	-- 아이템 타입 설정
	gBox:RemoveChild('tooltip_equip_type_n_weight');

--	local classtype = TryGetProp(invitem, "ClassType"); -- 코스튬은 안뜨도록
--	if classtype ~= nil then
--		if classtype == "Outer" then
--			return yPos;
--		end
--	end

	local tooltip_equip_type_n_weight_Cset = gBox:CreateOrGetControlSet('tooltip_equip_type_n_weight', 'tooltip_equip_type_n_weight', 0, yPos);

	local typeChild = GET_CHILD(tooltip_equip_type_n_weight_Cset,'type','ui::CRichText');
	typeChild:SetText(GET_REQ_TOOLTIP(invitem));
	typeChild:ShowWindow(1);

	local weightChild = GET_CHILD(tooltip_equip_type_n_weight_Cset,'weight','ui::CRichText');
	weightChild:SetTextByKey("weight",invitem.Weight..' ');
	weightChild:ShowWindow(1);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight()+tooltip_equip_type_n_weight_Cset:GetHeight())
	return tooltip_equip_type_n_weight_Cset:GetHeight() + tooltip_equip_type_n_weight_Cset:GetY();
end

--공격력 및 방어력
function DRAW_EQUIP_ATK_N_DEF(tooltipframe, invitem, yPos, mainframename, strarg, basicProp)
	
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_equip_atk_n_def');
	local tooltip_equip_atk_n_def_Cset = gBox:CreateOrGetControlSet('tooltip_equip_atk_n_def', 'tooltip_equip_atk_n_def'..basicProp, 0, yPos);
	
	local typeiconname = nil
	local typestring = nil
	local arg1 = nil
	local arg2 = nil
	local reinforceaddvalue = 0
	local socketaddvalue = 0
	
	-- 무기 타입 아이콘
	local pc = GetMyPCObject();
	local ignoreReinf = TryGetProp(pc, 'IgnoreReinforce');
	local bonusReinf = TryGetProp(pc, 'BonusReinforce');
	local itemGuid = tooltipframe:GetUserValue('TOOLTIP_ITEM_GUID');
	local isEquiped = 1;
	if session.GetEquipItemByGuid(itemGuid) == nil then
		isEquiped = 0
	end

	if TryGetProp(invitem, 'EquipGroup') ~= 'SubWeapon' or isEquiped == 0 then
		bonusReinf = 0;
	end
	if isEquiped == 0 then
		ignoreReinf = 0;
	end
	local refreshScpStr = TryGetProp(invitem, 'RefreshScp');
	if refreshScpStr ~= nil and refreshScpStr ~= 'None' then
		local refreshScp = _G[refreshScpStr];
		refreshScp(invitem, nil, ignoreReinf, bonusReinf);
	end
    	
	if basicProp == 'ATK' then
	    typeiconname = 'test_sword_icon'
		typestring = ScpArgMsg("Melee_Atk")
		reinforceaddvalue = math.floor( GET_REINFORCE_ADD_VALUE_ATK(invitem, ignoreReinf, bonusReinf, basicProp) )
		socketaddvalue =  GET_ITEM_SOCKET_ADD_VALUE(basicProp, invitem);
		arg1 = invitem.MINATK - reinforceaddvalue - socketaddvalue;
		arg2 = invitem.MAXATK - reinforceaddvalue - socketaddvalue;
	elseif basicProp == 'MATK' then
	    typeiconname = 'test_sword_icon'
		typestring = ScpArgMsg("Magic_Atk")
		reinforceaddvalue = math.floor( GET_REINFORCE_ADD_VALUE_ATK(invitem, ignoreReinf, bonusReinf, basicProp) )
		socketaddvalue =  GET_ITEM_SOCKET_ADD_VALUE(basicProp, invitem)
		arg1 = invitem.MATK - reinforceaddvalue - socketaddvalue;
		arg2 = invitem.MATK - reinforceaddvalue - socketaddvalue;
	else
		typeiconname = 'test_shield_icon'
		typestring = ScpArgMsg(basicProp);
		if invitem.RefreshScp ~= 'None' then
			local scp = _G[invitem.RefreshScp];
			if scp ~= nil then
				scp(invitem);
			end
		end
		
		reinforceaddvalue = GET_REINFORCE_ADD_VALUE(basicProp, invitem, ignoreReinf, bonusReinf);
		socketaddvalue =  GET_ITEM_SOCKET_ADD_VALUE(basicProp, invitem)
		arg1 = TryGetProp(invitem, basicProp) - reinforceaddvalue - socketaddvalue;
		arg2 = TryGetProp(invitem, basicProp) - reinforceaddvalue - socketaddvalue;
	end
        	
	SET_DAMAGE_TEXT(tooltip_equip_atk_n_def_Cset, typestring, typeiconname, arg1, arg2, 1, reinforceaddvalue);
	yPos = yPos + tooltip_equip_atk_n_def_Cset:GetHeight();
	
	gBox:Resize(gBox:GetWidth(),  yPos);
	return yPos;
end

function DRAW_TOOLTIP_SUB_BG(gBox, bg_ypos)
	local bg_gbox = gBox:CreateOrGetControl('groupbox', "tooltip_sub_bg", 0, bg_ypos, gBox:GetWidth(), 0);
	if bg_gbox == nil then
		return
	end

	bg_gbox:SetSkinName("test_Item_tooltip_bg");
	bg_gbox = tolua.cast(bg_gbox, "ui::CGroupBox");
	bg_gbox:EnableScrollBar(0)
	bg_gbox:ShowWindow(1);
end


function RESIZE_TOOLTIP_SUB_BG(gBox, bg_ypos, bg_height)
	local bg_gbox = gBox:CreateOrGetControl('groupbox', "tooltip_sub_bg", 0, bg_ypos, gBox:GetWidth(), 0);
	if bg_gbox == nil then
		return
	end

	bg_gbox:Resize(gBox:GetWidth(), bg_height)
end

-- 아이템에 의한 추가 속성 정보 (광역공격 +1)
function DRAW_EQUIP_PROPERTY(tooltipframe, invitem, yPos, mainframename, setItem, drawLableline)
	local gBox = GET_CHILD(tooltipframe,mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_equip_property');
	
	local basicList = GET_EQUIP_TOOLTIP_PROP_LIST(invitem);
    local list = {};
    local basicTooltipPropList = StringSplit(invitem.BasicTooltipProp, ';');
    for i = 1, #basicTooltipPropList do
        local basicTooltipProp = basicTooltipPropList[i];
        list = GET_CHECK_OVERLAP_EQUIPPROP_LIST(basicList, basicTooltipProp, list);
    end

	local list2 = GET_EUQIPITEM_PROP_LIST();
	local cnt = 0;
	for i = 1 , #list do

		local propName = list[i];
		local propValue = invitem[propName];
		
		if propValue ~= 0 then
            local checkPropName = propName;
            if propName == 'MINATK' or propName == 'MAXATK' then
                checkPropName = 'ATK';
            end
            if EXIST_ITEM(basicTooltipPropList, checkPropName) == false then
                cnt = cnt + 1;
            end
		end
	end

	for i = 1 , #list2 do
		local propName = list2[i];
		local propValue = invitem[propName];
		if propValue ~= 0 then

			cnt = cnt +1
		end
	end

	for i = 1 , 3 do
		local propName = "HatPropName_"..i;
		local propValue = "HatPropValue_"..i;
		if invitem[propValue] ~= 0 and invitem[propName] ~= "None" then
			cnt = cnt +1
		end
	end

	if cnt <= 0 and (invitem.OptDesc == nil or invitem.OptDesc == "None" ) then -- 일단 그릴 프로퍼티가 있는지 검사. 없으면 컨트롤 셋 자체를 안만듬
		if setItem == nil then
		if invitem.ReinforceRatio == 100 then
    		return yPos
    	end
	end

	end

	local tooltip_equip_property_CSet = gBox:CreateOrGetControlSet('tooltip_equip_property', 'tooltip_equip_property', 0, yPos);
    local labelline = GET_CHILD(tooltip_equip_property_CSet, 'labelline');
    if drawLableline == false then
        tooltip_equip_property_CSet:SetOffset(tooltip_equip_property_CSet:GetX(), tooltip_equip_property_CSet:GetY() - 20);
        labelline:ShowWindow(0);
    else
        labelline:ShowWindow(1);
    end

	local property_gbox = GET_CHILD(tooltip_equip_property_CSet,'property_gbox','ui::CGroupBox');
	local class = GetClassByType("Item", invitem.ClassID);

	local inner_yPos = 0;
	
	local maxRandomOptionCnt = 6;
	local randomOptionProp = {};
	for i = 1, maxRandomOptionCnt do
		if invitem['RandomOption_'..i] ~= 'None' then
			randomOptionProp[invitem['RandomOption_'..i]] = invitem['RandomOptionValue_'..i];
		end
	end

	for i = 1 , #list do
		local propName = list[i];
		local propValue = class[propName];
	--	if socketitem ~= nil then
	--		propValue = socketitem[propName]
	--	end
		
		local needToShow = true;
		for j = 1, #basicTooltipPropList do
			if basicTooltipPropList[j] == propName then
				needToShow = false;
			end
		end

		if needToShow == true and propValue ~= 0 and randomOptionProp[propName] == nil then -- 랜덤 옵션이랑 겹치는 프로퍼티는 여기서 출력하지 않음
			if  invitem.GroupName == 'Weapon' then
				if propName ~= "MINATK" and propName ~= 'MAXATK' then
					local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);					
					inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
				end
			elseif  invitem.GroupName == 'Armor' then
				if invitem.ClassType == 'Gloves' then
					if propName ~= "HR" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end
				elseif invitem.ClassType == 'Boots' then
					if propName ~= "DR" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end
				else
					if propName ~= "DEF" then
						local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);
						inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
					end
				end
			else
				local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), propValue);
				inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
			end
		end
	end

	for i = 1 , 3 do
		local propName = "HatPropName_"..i;
		local propValue = "HatPropValue_"..i;
		if invitem[propValue] ~= 0 and invitem[propName] ~= "None" then
			local opName = string.format("[%s] %s", ClMsg("EnchantOption"), ScpArgMsg(invitem[propName]));
			local strInfo = ABILITY_DESC_PLUS(opName, invitem[propValue]);
			inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
		end
	end
	
	for i = 1 , maxRandomOptionCnt do
	    local propGroupName = "RandomOptionGroup_"..i;
		local propName = "RandomOption_"..i;
		local propValue = "RandomOptionValue_"..i;
		local clientMessage = 'None'
		
		local propItem = invitem

		if setItem ~= nil then
			propItem = setItem
		end

		if propItem[propGroupName] == 'ATK' then
		    clientMessage = 'ItemRandomOptionGroupATK'
		elseif propItem[propGroupName] == 'DEF' then
		    clientMessage = 'ItemRandomOptionGroupDEF'
		elseif propItem[propGroupName] == 'UTIL_WEAPON' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif propItem[propGroupName] == 'UTIL_ARMOR' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif propItem[propGroupName] == 'UTIL_SHILED' then
		    clientMessage = 'ItemRandomOptionGroupUTIL'
		elseif propItem[propGroupName] == 'STAT' then
		    clientMessage = 'ItemRandomOptionGroupSTAT'
		end
		
		if propItem[propValue] ~= 0 and propItem[propName] ~= "None" then
			local opName = string.format("%s %s", ClMsg(clientMessage), ScpArgMsg(propItem[propName]));
			local strInfo = ABILITY_DESC_NO_PLUS(opName, propItem[propValue], 0);

			inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
		end
	end

	for i = 1 , #list2 do
		local propName = list2[i];
		local propValue = invitem[propName];
		if propValue ~= 0 then
			local strInfo = ABILITY_DESC_PLUS(ScpArgMsg(propName), invitem[propName]);
			inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
		end
	end

	if invitem.OptDesc ~= nil and invitem.OptDesc ~= 'None' then
		inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, invitem.OptDesc, 0, inner_yPos);
	end

	if setItem == nil then
		if invitem.IsAwaken == 1 then
			local opName = string.format("[%s] %s", ClMsg("AwakenOption"), ScpArgMsg(invitem.HiddenProp));
			local strInfo = ABILITY_DESC_PLUS(opName, invitem.HiddenPropValue);
			inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
		end
	else
		if setItem.IsAwaken == 1 then
			local opName = string.format("[%s] %s", ClMsg("AwakenOption"), ScpArgMsg(setItem.HiddenProp));
			local strInfo = ABILITY_DESC_PLUS(opName, setItem.HiddenPropValue);
			inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo, 0, inner_yPos);
		end
	end

	if invitem.ReinforceRatio > 100 then
		local opName = ClMsg("ReinforceOption");
		local strInfo = ABILITY_DESC_PLUS(opName, math.floor(10 * invitem.ReinforceRatio/100));
		inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, strInfo.."0%"..ClMsg("ReinforceOptionAtk"), 0, inner_yPos);
	end

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	BOTTOM_MARGIN = tonumber(BOTTOM_MARGIN)
	if BOTTOM_MARGIN == nil then
		BOTTOM_MARGIN = 0
	end
	tooltip_equip_property_CSet:Resize(tooltip_equip_property_CSet:GetWidth(),tooltip_equip_property_CSet:GetHeight() + property_gbox:GetHeight() + property_gbox:GetY() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + tooltip_equip_property_CSet:GetHeight())
	return tooltip_equip_property_CSet:GetHeight() + tooltip_equip_property_CSet:GetY();
end

-- 제작 시 넣은 메모
function DRAW_EQUIP_MEMO(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_equip_memo');

	local memo = invitem.Memo
	if memo == "None" then -- 일단 메모가 있는지 검사. 없으면 컨트롤 셋 자체를 안만듬
		return yPos
	end

	memo = ScpArgMsg("ItIsMemo") ..memo
	
	local tooltip_equip_property_CSet = gBox:CreateOrGetControlSet('tooltip_equip_memo', 'tooltip_equip_memo', 0, yPos);
	local property_gbox = GET_CHILD(tooltip_equip_property_CSet,'property_gbox','ui::CGroupBox')
		
	local inner_yPos = 0;
	inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, memo, 0, inner_yPos);
	
	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	tooltip_equip_property_CSet:Resize(tooltip_equip_property_CSet:GetWidth(),tooltip_equip_property_CSet:GetHeight() + property_gbox:GetHeight() + property_gbox:GetY() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + tooltip_equip_property_CSet:GetHeight())
	return tooltip_equip_property_CSet:GetHeight() + tooltip_equip_property_CSet:GetY();
end

-- 아이템에 의한 추가 속성 정보 (광역공격 +1 둥등)
function DRAW_EQUIP_DESC(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_equip_desc');

	local desc = GET_ITEM_TOOLTIP_DESC(invitem);    
	if desc == "" then -- 일단 그릴 설명이 있는지 검사. 없으면 컨트롤 셋 자체를 안만듬
		return yPos
	end

    local value = IS_TOGGLE_EQUIP_ITEM_TOOLTIP_DESC();
    if value == 1 then
        return yPos
    end
	
	local tooltip_equip_property_CSet = gBox:CreateOrGetControlSet('tooltip_equip_desc', 'tooltip_equip_desc', 0, yPos);
	local property_gbox = GET_CHILD(tooltip_equip_property_CSet,'property_gbox','ui::CGroupBox')
		
	local inner_yPos = 0;
	inner_yPos = ADD_ITEM_PROPERTY_TEXT(property_gbox, desc, 0, inner_yPos);

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	tooltip_equip_property_CSet:Resize(tooltip_equip_property_CSet:GetWidth(),tooltip_equip_property_CSet:GetHeight() + property_gbox:GetHeight() + property_gbox:GetY() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + tooltip_equip_property_CSet:GetHeight())
	return tooltip_equip_property_CSet:GetHeight() + tooltip_equip_property_CSet:GetY();
end

-- 소켓 정보
function DRAW_EQUIP_SOCKET_COUNT(tooltipframe, invitem, yPos, addinfoframename)
	local value = IS_TOGGLE_EQUIP_ITEM_TOOLTIP_DESC();
    if value == 1 then
        return yPos
    end

    if invitem.MaxSocket == 0 then
    	return yPos
    end

	local gBox = GET_CHILD(tooltipframe, addinfoframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_equip_socket');
	
	local tooltip_equip_socket_CSet = gBox:CreateOrGetControlSet('tooltip_equip_socket', 'tooltip_equip_socket', 0, yPos);

	local socket_gbox= GET_CHILD(tooltip_equip_socket_CSet,'socket_gbox','ui::CGroupBox')
	local socket_value = GET_CHILD_RECURSIVELY(tooltip_equip_socket_CSet, 'socket_value')
	tolua.cast(tooltip_equip_socket_CSet, "ui::CControlSet");
	socket_value:SetTextByKey("curCount", 0)
	socket_value:SetTextByKey("maxCount", invitem.MaxSocket)
	return tooltip_equip_socket_CSet:GetHeight() + tooltip_equip_socket_CSet:GetY();
end

function DRAW_EQUIP_SOCKET(tooltipframe, invitem, yPos, addinfoframename)
	local value = IS_TOGGLE_EQUIP_ITEM_TOOLTIP_DESC();
    if value == 1 then
        return yPos
    end

	local gBox = GET_CHILD(tooltipframe, addinfoframename,'ui::CGroupBox')
	local tooltip_equip_socket_CSet = GET_CHILD_RECURSIVELY(gBox, 'tooltip_equip_socket');
	local socket_gbox= GET_CHILD(tooltip_equip_socket_CSet,'socket_gbox','ui::CGroupBox')
	local socket_value = GET_CHILD_RECURSIVELY(tooltip_equip_socket_CSet, 'socket_value')

	tolua.cast(tooltip_equip_socket_CSet, "ui::CControlSet");
	local DEFAULT_POS_Y = tooltip_equip_socket_CSet:GetUserConfig("DEFAULT_POS_Y")
	local inner_yPos = DEFAULT_POS_Y;

	local curCount = 0
	for i=0, invitem.MaxSocket-1 do
		if invitem['Socket_' .. i] > 0 then
			curCount = curCount + 1
			inner_yPos = ADD_ITEM_SOCKET_PROP(socket_gbox, invitem, 
											invitem['Socket_' .. i], 
											invitem['Socket_Equip_' .. i], 
											invitem['SocketItemExp_' .. i],
											invitem['Socket_JamLv_' ..i],
											inner_yPos);
		end
	end

	socket_value:SetTextByKey("curCount", curCount)

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	tooltip_equip_socket_CSet:Resize(tooltip_equip_socket_CSet:GetWidth(),socket_gbox:GetHeight() + socket_gbox:GetY() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + tooltip_equip_socket_CSet:GetHeight())
	return tooltip_equip_socket_CSet:GetHeight() + tooltip_equip_socket_CSet:GetY();
end


-- 매직어뮬렛 정보
function DRAW_EQUIP_MAGICAMULET(subframe, invitem, yPos,addinfoframename)

	local gBox = GET_CHILD(subframe, addinfoframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_equip_magicamulet');
	
	local CSet = gBox:CreateOrGetControlSet('tooltip_equip_magicamulet', 'tooltip_equip_magicamulet', 0, yPos);
	local amulet_gbox= GET_CHILD(CSet,'magicamulet_gbox','ui::CGroupBox')

	local inner_yPos = 0;


	for i=0, invitem.MaxSocket_MA-1 do
		if invitem['MagicAmulet_' .. i] > 0 then

			local amuletitemclass = GetClassByType('Item',invitem['MagicAmulet_' .. i]);

			local each_amulet_cset = amulet_gbox:CreateControlSet('tooltip_item_prop_magicamulet', 'tooltip_item_prop_magicamulet'..i, 0, inner_yPos);
			local amulet_image = GET_CHILD(each_amulet_cset,'amulet_image','ui::CPicture')
			local amulet_name = GET_CHILD(each_amulet_cset,'amulet_name','ui::CRichText')
			local amulet_desc = GET_CHILD(each_amulet_cset,'amulet_desc','ui::CRichText')
			local labelline = each_amulet_cset:GetChild("labelline")
			
			if yPos == 0 and i == 0 then
				labelline:ShowWindow(0)
			else
				labelline:ShowWindow(1)
			end

			amulet_image:SetImage(amuletitemclass.Icon)
			amulet_name:SetText(amuletitemclass.Name)
			amulet_desc:SetText(amuletitemclass.Desc)

			inner_yPos = inner_yPos + each_amulet_cset:GetHeight()

		end
	end

	amulet_gbox:Resize(amulet_gbox:GetOriginalWidth(),inner_yPos);

	local BOTTOM_MARGIN = subframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	CSet:Resize(CSet:GetWidth(),CSet:GetHeight() + amulet_gbox:GetHeight() + amulet_gbox:GetY() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + CSet:GetHeight())
	return CSet:GetHeight() + CSet:GetY();
end

--세트 아이템
function DRAW_EQUIP_SET(tooltipframe, invitem, ypos, mainframename)

	local gBox = GET_CHILD(tooltipframe,mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_set');

	
	local tooltip_CSet = gBox:CreateControlSet('tooltip_set', 'tooltip_set', 0, ypos);
	tolua.cast(tooltip_CSet, "ui::CControlSet");
	local set_gbox_type= GET_CHILD(tooltip_CSet,'set_gbox_type','ui::CGroupBox')
	local set_gbox_prop= GET_CHILD(tooltip_CSet,'set_gbox_prop','ui::CGroupBox')

	local inner_yPos = 0;
	local inner_xPos = 0;
	local DEFAULT_POS_Y = tooltip_CSet:GetUserConfig("DEFAULT_POS_Y")
	inner_yPos = DEFAULT_POS_Y;
	inner_xPos = 0;

	-- 세트아이템 세트 효과 텍스트 표시 부분


	-- 세트아이템 이미지 그려주는 부분
	
	local isUseLegendSet = 0	
	if invitem.LegendGroup == nil or invitem.LegendGroup == 'None' then
		isUseLegendSet = 0
	else
		isUseLegendSet = 1
	end

	local EntireHaveCount = 0;
	local setList = {'RH', 'LH', 'SHIRT', 'PANTS', 'GLOVES', 'BOOTS'}
	local setFlagList = {RH_flag, LH_flag, SHIRT_flag, PANTS_flag, GLOVES_flag, BOOTS_flag}
	local setItemCount = 0
	setItemCount, setFlagList[1], setFlagList[2], setFlagList[3], setFlagList[4], setFlagList[5], setFlagList[6] = CHECK_EQUIP_SET_ITEM(invitem)
	if isUseLegendSet == 1 then
		if invitem.LegendPrefix == nil or invitem.LegendPrefix == "None" then
			return ypos
		end

		for i = 1, setItemCount do
			local setItemTextCset = set_gbox_type:CreateControlSet('eachitem_in_setitemtooltip', 'setItemText'..i, inner_xPos, inner_yPos);
			tolua.cast(setItemTextCset, "ui::CControlSet");
			local setItemName = GET_CHILD_RECURSIVELY(setItemTextCset, "setitemtext")
			if setFlagList[i] == 0 then
				setItemName:SetTextByKey("font", tooltip_CSet:GetUserConfig("NOT_HAVE_ITEM_FONT"))
			else 
				setItemName:SetTextByKey("font", tooltip_CSet:GetUserConfig("HAVE_ITEM_FONT"))
				EntireHaveCount = EntireHaveCount + 1
			end

			local prefixCls = GetClass('LegendSetItem', invitem.LegendPrefix)

			local temp = ""
			if prefixCls ~= nil then
				temp = prefixCls.Name
			end
			local setItemText = temp .. ' ' .. tooltip_CSet:GetUserConfig(setList[i] .. '_SET_TEXT')
			setItemName:SetTextByKey("itemname", setItemText)
			local heightMargin = setItemTextCset:GetUserConfig("HEIGHT_MARGIN")
			inner_yPos = inner_yPos + heightMargin;
		end
	else
		local itemProp = geItemTable.GetProp(invitem.ClassID);

		local set = itemProp.setInfo;
		if set == nil then
			return ypos;
		end
		local cnt =	set:GetItemCount();
		local clsID = 0
		local HaveCount = 0;
		for i = 0, cnt - 1 do
			local itemClsName = set:GetItemClassName(i)
			local itemCls = GetClass("Item", itemClsName)

			if itemCls ~= nil then
				local setItemName = set:GetItemName(i)

				local setItemTextCset = set_gbox_type:CreateControlSet('eachitem_in_setitemtooltip', 'setItemText'..i, inner_xPos, inner_yPos);
				tolua.cast(setItemTextCset, "ui::CControlSet");
				local setItemName = GET_CHILD_RECURSIVELY(setItemTextCset, "setitemtext")

				if itemCls.ClassID ~= clsID then
					HaveCount = 0
				end

				local count = GET_EQP_ITEM_CNT(itemCls.ClassID)
				count = count - HaveCount

				if count == 0 then
					setItemName:SetTextByKey("font", tooltip_CSet:GetUserConfig("NOT_HAVE_ITEM_FONT"))
					HaveCount = 0
				else 
					setItemName:SetTextByKey("font", tooltip_CSet:GetUserConfig("HAVE_ITEM_FONT"))
					EntireHaveCount = EntireHaveCount + 1
					HaveCount = HaveCount + 1
					clsID = itemCls.ClassID
				end

				setItemName:SetTextByKey("itemname", itemCls.Name)
				local heightMargin = setItemTextCset:GetUserConfig("HEIGHT_MARGIN")
				inner_yPos = inner_yPos + heightMargin;
			end
		end
	end
	set_gbox_type:Resize(set_gbox_type:GetWidth(), inner_yPos)
	
	local USE_SETOPTION_FONT = tooltip_CSet:GetUserConfig("USE_SETOPTION_FONT")
	local NOT_USE_SETOPTION_FONT = tooltip_CSet:GetUserConfig("NOT_USE_SETOPTION_FONT")

	inner_yPos = DEFAULT_POS_Y

	if isUseLegendSet == 1 then
		local prefixCls = GetClass('LegendSetItem', invitem.LegendPrefix)
		if prefixCls ~= nil then
			for i = 0, 2 do
		
			local index = 'EffectDesc_' .. i+3
		--	local setEffect = set:GetSetEffect(i);

				local color = USE_SETOPTION_FONT
				if EntireHaveCount >= i + 3 then
					color = NOT_USE_SETOPTION_FONT
				end

				local setTitle = ScpArgMsg("Auto_{s16}{Auto_1}{Auto_2}_SeTeu_HyoKwa__{nl}", "Auto_1",color, "Auto_2",i + 3);
				local setDesc = string.format("{s16}%s%s", color, prefixCls[index]);

				local each_text_CSet = set_gbox_prop:CreateControlSet('tooltip_set_each_prop_text', 'each_text_CSet'..i, inner_xPos, inner_yPos);
				tolua.cast(each_text_CSet, "ui::CControlSet");
				local set_text = GET_CHILD(each_text_CSet,'set_prop_Text','ui::CRichText')
				set_text:SetTextByKey("setTitle",setTitle)
				set_text:SetTextByKey("setDesc",setDesc)

				local labelline = GET_CHILD_RECURSIVELY(each_text_CSet, 'labelline')
				local y_margin = each_text_CSet:GetUserConfig("TEXT_Y_MARGIN")				
				local testRect = set_text:GetMargin();
				each_text_CSet:Resize(each_text_CSet:GetWidth(), set_text:GetHeight() + testRect.top);
				inner_yPos = inner_yPos + each_text_CSet:GetHeight() + y_margin;
			end
		end
	else
		local itemProp = geItemTable.GetProp(invitem.ClassID);

		local set = itemProp.setInfo;
		if set == nil then
			return ypos;
		end
		local cnt =	set:GetItemCount();
		for i = 0, cnt - 1 do
		
			local setEffect = set:GetSetEffect(i);
			if setEffect ~= nil then
				local color = USE_SETOPTION_FONT
				if EntireHaveCount >= i + 1 then
					color = NOT_USE_SETOPTION_FONT
				end

				local setTitle = ScpArgMsg("Auto_{s16}{Auto_1}{Auto_2}_SeTeu_HyoKwa__{nl}", "Auto_1",color, "Auto_2",i + 1);
				local setDesc = string.format("{s16}%s%s", color, setEffect:GetDesc());
		
				local each_text_CSet = set_gbox_prop:CreateControlSet('tooltip_set_each_prop_text', 'each_text_CSet'..i, inner_xPos, inner_yPos);
				tolua.cast(each_text_CSet, "ui::CControlSet");
				local y_margin = each_text_CSet:GetUserConfig("TEXT_Y_MARGIN")
				local set_text = GET_CHILD(each_text_CSet,'set_prop_Text','ui::CRichText')
				set_text:SetTextByKey("setTitle",setTitle)
				set_text:SetTextByKey("setDesc",setDesc)
				local labelline = GET_CHILD_RECURSIVELY(each_text_CSet, 'labelline')
				local testRect = set_text:GetMargin();
				each_text_CSet:Resize(each_text_CSet:GetWidth(), set_text:GetHeight() + testRect.top);
				inner_yPos = inner_yPos + each_text_CSet:GetHeight() + y_margin;
			end
		end
	end
	
	-- 맨 아랫쪽 여백
	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN");
	set_gbox_prop:Resize( set_gbox_prop:GetWidth() ,inner_yPos  + BOTTOM_MARGIN)
	set_gbox_prop:SetOffset(set_gbox_prop:GetX(),set_gbox_type:GetY()+set_gbox_type:GetHeight())
	tooltip_CSet:Resize(tooltip_CSet:GetWidth(), set_gbox_prop:GetHeight() + set_gbox_prop:GetY() + BOTTOM_MARGIN);
	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + tooltip_CSet:GetHeight())
	return tooltip_CSet:GetHeight() + tooltip_CSet:GetY();

end

function CHECK_EQUIP_SET_ITEM(invitem)
	local legendGroup = invitem.LegendGroup

	local invframe = ui.GetFrame("inventory")

	local RHflag = 0
	local LHflag = 0
	local SHIRTflag = 0
	local PANTSflag = 0
	local GLOVESflag = 0
	local BOOTSflag = 0

	local setItemCount = 0
	if legendGroup == nil or legendGroup == 'None' then
		local itemProp = geItemTable.GetProp(invitem.ClassID);
		local set = itemProp.setInfo;
		if set == nil then
			return 0, 0,0,0,0,0,0
		end
	else
		RHflag, LHflag, SHIRTflag, PANTSflag, GLOVESflag, BOOTSflag = GET_PREFIX_SET_ITEM_FLAG(invitem)
-- 세트아이템 수 정해야함
		setItemCount = 6
	end

	return setItemCount, RHflag, LHflag, SHIRTflag, PANTSflag, GLOVESflag, BOOTSflag
end

function GET_PREFIX_SET_ITEM_FLAG(invitem)

	local frame = ui.GetFrame("inventory");
	if frame == nil then
		frame = ui.GetFrame("barrack_charlist")
	end

	local prefixCls = GetClass('LegendSetItem', invitem.LegendPrefix)
	if prefixCls == nil then
		return 0, 0, 0, 0, 0, 0;
	end

	local equipTable = {"RH", "LH", "SHIRT", "PANTS", "GLOVES", "BOOTS"};
	local returnValue = {0 , 0, 0, 0, 0, 0};
	for i = 1, #equipTable do
		local slot = GET_CHILD_RECURSIVELY(frame, equipTable[i])
		local slotIcon = slot:GetIcon()
		if slotIcon ~= nil then
			local slotIconInfo = slotIcon:GetInfo()
			local slotItem = GET_ITEM_BY_GUID(slotIconInfo:GetIESID())
			if slotItem ~= nil then
				local obj = GetIES(slotItem:GetObject())
				if prefixCls.ClassName == obj.LegendPrefix then		
					returnValue[i] = 1;
				else
					returnValue[i] = 0;
				end
			end
		end
	end

	local slot = GET_CHILD_RECURSIVELY(frame, "RH")
	local slotIcon = slot:GetIcon()
	if slotIcon ~= nil then
		local slotIconInfo = slotIcon:GetInfo()
		local slotItem = GET_ITEM_BY_GUID(slotIconInfo:GetIESID())
		if slotItem ~= nil then
			local obj = GetIES(slotItem:GetObject())
			local isDoubleHand = TryGetProp(obj, "DBLHand");
			if isDoubleHand == "YES" then
				returnValue[2] = 0;
			end
		end
	end
	return returnValue[1], returnValue[2], returnValue[3], returnValue[4], returnValue[5], returnValue[6]

end



function CHECK_EQUIP_SET_ITEM_SLOT(invitem, slotName)
	local frame = ui.GetFrame("inventory")
	local flag = 0
	local prefixCls = GetClass('LegendSetItem', invitem.LegendPrefix)
	if prefixCls == nil then
		return flag
	end
	local legendSetName = prefixCls.ClassName
	local slot = GET_CHILD_RECURSIVELY(frame, slotName)
	local slotIcon = slot:GetIcon()
	if slotIcon ~= nil then
		local slotIconInfo = slotIcon:GetInfo()
		local slotItem = GET_ITEM_BY_GUID(slotIconInfo:GetIESID())
		local obj = GetIES(slotItem:GetObject())
		if obj.LegendPrefix == legendSetName then
			flag = 1
		end
	end
	return flag
end

--각종 제한사항(렙제, 직업제한, 소켓 등등)
function DRAW_AVAILABLE_PROPERTY(tooltipframe, invitem, yPos,mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_available_property');
	
	local tooltip_available_property_CSet = gBox:CreateControlSet('tooltip_available_property', 'tooltip_available_property', 0, yPos);
	tolua.cast(tooltip_available_property_CSet, "ui::CControlSet");

	local levelNusejob_text = GET_CHILD(tooltip_available_property_CSet,'levelNusejob','ui::CRichText')
	local maxSocekt_text = GET_CHILD(tooltip_available_property_CSet,'maxSocket','ui::CRichText')	

	--레벨제한 표시
	if invitem.UseLv > 1 then
		levelNusejob_text:SetTextByKey("level",invitem.UseLv..ScpArgMsg("EQUIP_LEVEL"));
	else
		levelNusejob_text:SetTextByKey("level",ScpArgMsg("UNLIMITED_ITEM_LEVEL"));
	end

	--장착제한 표시
	levelNusejob_text:SetTextByKey("usejob",GET_USEJOB_TOOLTIP(invitem));

	maxSocekt_text:SetOffset(maxSocekt_text:GetX(),levelNusejob_text:GetY() + levelNusejob_text:GetHeight() + 5)

	local itemClass = GetClassByType("Item", invitem.ClassID);

	--소켓제한 표시
    local maxSocket = SCR_GET_MAX_SOKET(invitem);
	if maxSocket <= 0 then
		maxSocekt_text:SetText(ScpArgMsg("CantAddSocket"))
	else
		if itemClass.NeedAppraisal == 1 then
			local needAppraisal = TryGetProp(invitem, "NeedAppraisal");
			if nil ~= needAppraisal and needAppraisal == 1 then
				maxSocekt_text:SetTextByKey("socketcount","{@st66d_y}????{/}");
			else
				maxSocekt_text:SetTextByKey("socketcount","{@st66d_y}"..maxSocket.."{/}");
			end
		else
			maxSocekt_text:SetTextByKey("socketcount",maxSocket);
		end
	end

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	tooltip_available_property_CSet:Resize(tooltip_available_property_CSet:GetWidth(),maxSocekt_text:GetY() + maxSocekt_text:GetHeight() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + tooltip_available_property_CSet:GetHeight())
	return tooltip_available_property_CSet:GetHeight() + tooltip_available_property_CSet:GetY();
end

function DRAW_EQUIP_TRADABILITY(tooltipframe, invitem, yPos, mainframename)
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_equip_tradability');
	
	local CSet = gBox:CreateControlSet('tooltip_equip_tradability', 'tooltip_equip_tradability', 0, yPos);
	tolua.cast(CSet, "ui::CControlSet");

	TOGGLE_TRADE_OPTION(CSet, invitem, 'option_npc', 'option_npc_text', 'ShopTrade')
	TOGGLE_TRADE_OPTION(CSet, invitem, 'option_market', 'option_market_text', 'MarketTrade')
	TOGGLE_TRADE_OPTION(CSet, invitem, 'option_teamware', 'option_teamware_text', 'TeamTrade')
	TOGGLE_TRADE_OPTION(CSet, invitem, 'option_trade', 'option_trade_text', 'UserTrade')
    
    local bottomMargin = CSet:GetUserConfig("BOTTOM_MARGIN");
	CSet:Resize(CSet:GetWidth(), CSet:GetHeight() + bottomMargin)
	gBox:Resize(gBox:GetWidth(), gBox:GetHeight() + CSet:GetHeight())
	return yPos + CSet:GetHeight();
end

-- 초월 및 강화불가
function DRAW_CANNOT_REINFORCE(tooltipframe, invitem, yPos, mainframename)

	local reinforce_flag = 0
	local transcend_flag = 0
	local extract_flag = 0
	local socket_flag = 0
	local text = ""

	if REINFORCE_ABLE_131014(invitem) == 0 then
		reinforce_flag = 1
	end

	if IS_TRANSCEND_ABLE_ITEM(invitem) == 0 then
		transcend_flag = 1
	end

	local itemClass = GetClassByType("Item", invitem.ClassID);
	if itemClass ~= nil and itemClass.Extractable == 'No' then
		extract_flag = 1
	end

	if invitem.MaxSocket == 0 then
		socket_flag = 1
	end

	if reinforce_flag == 0 and transcend_flag == 0 and extract_flag == 0 and socket_flag == 0 then
		return yPos
	end

	local gBox = GET_CHILD_RECURSIVELY(tooltipframe, mainframename)
	gBox:RemoveChild('tooltip_equip_cannot_reinforce');

	local CSet = gBox:CreateControlSet('tooltip_equip_cannot_reinforce', 'tooltip_equip_cannot_reinforce', 0, yPos);
	tolua.cast(CSet, "ui::CControlSet");

	local socket_text = GET_CHILD_RECURSIVELY(CSet, 'socket_text')
	

	local text_font = CSet:GetUserConfig("TEXT_FONT")
	text = text .. text_font

	if reinforce_flag == 1 then
		local text_temp = CSet:GetUserConfig("REINFORCE_TEXT")
		text = text .. text_temp
	end

	if transcend_flag == 1 then
		local text_temp = CSet:GetUserConfig("TRANSCEND_TEXT")
		if reinforce_flag == 1 then
			text = text .. ', ' .. text_temp
		else
			text = text .. text_temp
		end
	end

	if extract_flag == 1 then
		local text_temp = CSet:GetUserConfig("EXTRACT_TEXT")
		if reinforce_flag == 1 or transcend_flag == 1 then
			text = text .. ', ' .. text_temp
		else
			text = text .. text_temp
		end
	end

	if socket_flag == 1 then
		local text_temp = CSet:GetUserConfig("SOCKET_TEXT")
		if reinforce_flag == 1 or transcend_flag == 1 or extract_flag == 1 then
			text = text .. ', ' .. text_temp
		else
			text = text .. text_temp
		end
	end

	socket_text:SetText(text)

	local bottomMargin = CSet:GetUserConfig("BOTTOM_MARGIN");
--	CSet:Resize(CSet:GetWidth(), CSet:GetHeight() + bottomMargin)
--	gBox:Resize(gBox:GetWidth(), gBox:GetHeight() + CSet:GetHeight())
	return yPos + CSet:GetHeight()

end

--포텐 및 내구도
function DRAW_EQUIP_PR_N_DUR(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_pr_n_dur');

	local itemClass = GetClassByType("Item", invitem.ClassID);
	if invitem.GroupName ~= "Armor" and invitem.GroupName ~= "Weapon" then -- 내구도 개념이 없는 템

	    if invitem.BasicTooltipProp == "None" then
    		return yPos;
		end
	end

	local classtype = TryGetProp(invitem, "ClassType"); -- 코스튬은 안뜨도록
	if classtype ~= nil then
		if (classtype == "Outer") 
		or (classtype == "Hat") 
		or (classtype == "Hair") 
		or ((itemClass.PR == 0) and (invitem.MaxDur <= 0)) then
			return yPos;
		end
		
		local isHaveLifeTime = TryGetProp(invitem, "LifeTime");	
		if isHaveLifeTime ~= nil then
			if ((isHaveLifeTime > 0) and (invitem.MaxDur <= 0))  then
				return yPos;
			end;
		end
	end
	
	local CSet = gBox:CreateControlSet('tooltip_pr_n_dur', 'tooltip_pr_n_dur', 0, yPos);
	tolua.cast(CSet, "ui::CControlSet");

	local inf_value = CSet:GetUserConfig("INF_VALUE")

	local pr_gauge = GET_CHILD(CSet,'pr_gauge','ui::CGauge')
	local mpr = invitem.MaxPR;
	if 0 == mpr then
		mpr = itemClass.PR;
	end

	pr_gauge:SetPoint(invitem.PR, mpr);

	local dur_gauge = GET_CHILD(CSet,'dur_gauge','ui::CGauge')
	local temparg1 = math.floor(invitem.Dur/100);
	local temparg2 = math.floor(invitem.MaxDur/100);
	if  invitem.MaxDur == -1 then
		dur_gauge:SetPoint(inf_value, inf_value);
	else
		dur_gauge:SetPoint(temparg1, temparg2);
	end

	if itemClass.NeedAppraisal == 1 or itemClass.NeedRandomOption == 1 then
		local needAppraisal = TryGetProp(invitem, "NeedAppraisal");
		local needRandomOption = TryGetProp(invitem, "NeedRandomOption");
		if needAppraisal ~= nil and  needAppraisal == 0 and itemClass.NeedAppraisal == 1 then -- 감정아이템
			pr_gauge:SetStatFont(0, "yellow_14_b")
		elseif  needRandomOption == 1 or needAppraisal == 1 then --미감정아이템
		    if needAppraisal == 1 then 
			    pr_gauge:SetTextStat(0, "{@st66d_y}????{/}")
            end
            
			local picture = CSet:CreateControl('picture', 'appraisalPic', 0, dur_gauge:GetY(), 400, 46);
		--	picture:SetGravity(ui.CENTER_VERT, ui.TOP)
			picture:ShowWindow(1);
			picture = tolua.cast(picture, "ui::CPicture");
			picture:SetImage("USsentiment_message");

			local rect = picture:CreateControl('richtext', 'appraisalStr', 200, 40, ui.CENTER_VERT, ui.CENTER_HORZ, 0, 0, 0, 0);
			rect = tolua.cast(rect, "ui::CRichText");
			rect:SetText('{@st66b}'..ScpArgMsg("AppraisalItem"))
			rect:SetTextAlign("center","center");
			CSet:Resize(CSet:GetWidth(),CSet:GetHeight() + picture:GetHeight() - 30);
		end
	end

	local extraMarginY = 0;

	local dur_text = GET_CHILD(CSet,'dur_text');
	local pr_text = GET_CHILD(CSet,'pr_text');

	if invitem.MaxDur <= 0 then
		dur_text:ShowWindow(0);
		dur_gauge:ShowWindow(0);
		pr_gauge:SetPos(pr_gauge:GetOffsetX(), 10);
		pr_text:SetPos(pr_text:GetOffsetX(), 20);
		extraMarginY = 0;
	else
		dur_text:ShowWindow(1);
		dur_gauge:ShowWindow(1);
	end
	
	if itemClass.PR <= 0 then
		pr_text:ShowWindow(0);
		pr_gauge:ShowWindow(0);
		dur_gauge:SetPos(dur_gauge:GetOffsetX(), 10);
		dur_text:SetPos(dur_text:GetOffsetX(), 20);
		extraMarginY = 0;
	else
		pr_text:ShowWindow(1);
		pr_gauge:ShowWindow(1);
	end

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	CSet:Resize(CSet:GetWidth(),CSet:GetHeight() + BOTTOM_MARGIN - extraMarginY);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + CSet:GetHeight()- extraMarginY)
	return CSet:GetHeight() + CSet:GetY() - extraMarginY;
end

--악세서리 등 포텐만 존재하는 녀석 들
function DRAW_EQUIP_ONLY_PR(tooltipframe, invitem, yPos, mainframename)

	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_only_pr');

	local itemClass = GetClassByType("Item", invitem.ClassID);

	local classtype = TryGetProp(invitem, "ClassType"); -- 코스튬은 안뜨도록
		
	if classtype ~= nil then
		if (classtype ~= "Hat" and invitem.BasicTooltipProp ~= "None")
		or (itemClass.PR == 0) 
		or (classtype == "Outer")
		or (itemClass.ItemGrade == 0 and classtype == "Hair") then
			return yPos;
		end;
	end


	local CSet = gBox:CreateControlSet('tooltip_only_pr', 'tooltip_only_pr', 0, yPos);
	tolua.cast(CSet, "ui::CControlSet");

	local inf_value = CSet:GetUserConfig("INF_VALUE")

	local pr_gauge = GET_CHILD(CSet,'pr_gauge','ui::CGauge')
	pr_gauge:SetPoint(invitem.PR, itemClass.PR);

	local BOTTOM_MARGIN = tooltipframe:GetUserConfig("BOTTOM_MARGIN"); -- 맨 아랫쪽 여백
	CSet:Resize(CSet:GetWidth(),CSet:GetHeight() + BOTTOM_MARGIN);

	gBox:Resize(gBox:GetWidth(),gBox:GetHeight() + CSet:GetHeight())
	return CSet:GetHeight() + CSet:GetY();
end

-- 설명문 토글
function DRAW_TOGGLE_EQUIP_DESC(tooltipframe, invitem, yPos, mainframename)
	local gBox = GET_CHILD(tooltipframe, mainframename,'ui::CGroupBox')
	gBox:RemoveChild('tooltip_toggle_desc');

	local tooltip_toggle_CSet = gBox:CreateControlSet('tooltip_toggle_desc', 'tooltip_toggle_desc', 0, yPos);
	tolua.cast(tooltip_toggle_CSet, "ui::CControlSet");
	local toggle_desc_text = GET_CHILD(tooltip_toggle_CSet, 'toggle_desc_text', 'ui::CRichText');

    local toggleText = ClMsg('Show');
    if IS_TOGGLE_EQUIP_ITEM_TOOLTIP_DESC() ~= 1 then
        toggleText = ClMsg('Close');
	end
    toggle_desc_text:SetTextByKey('Toggle', toggleText);

	gBox:Resize(gBox:GetWidth(), gBox:GetHeight() + tooltip_toggle_CSet:GetHeight())
	return tooltip_toggle_CSet:GetHeight() + tooltip_toggle_CSet:GetY();
end

function IS_USE_SET_TOOLTIP(invitem)
	local itemClass = GetClassByType("Item", invitem.ClassID);

	local type = itemClass.ClassType 
	if type == nil then
		return 0
	end

	if type == 'Helmet' 
		or type == 'Armband' 
		or type == 'Hair' 
		or type == 'Lens' 
		or type == 'Outer' 
		or type == 'Hat' 
		or type == 'Artefact' 
		or type == 'Wing'
		or type == 'SpecialCostume'
		or type == 'EffectCostume' then
		return 0
	else
		return 1
	end

end
