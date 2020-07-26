--- tooltip.lua -

function TRY_PARSE_TOOLTIPCOND(obj, caption)

    local ifPos = string.find(caption, "#!");
    if ifPos == nil then
        return caption, 0;
    end

    local ifEndPos = FIND_STRING(caption, ifPos + 2, " THEN ");
    if ifEndPos == nil then
        return caption, 0;
    end

    local thenPos = FIND_STRING(caption, ifEndPos + 2, " ELSE ");
    if thenPos == nil then
        return caption, 0;
    end

    local elsePos = FIND_STRING(caption, thenPos + 2, " END ");
    if elsePos == nil then
        return caption, 0;
    end


    local ifParsed = string.sub(caption, ifPos + 3, ifEndPos - 2);
    local thenParsed = string.sub(caption, ifEndPos + 5, thenPos - 2);
    local elseParsed = string.sub(caption, thenPos + 6, elsePos - 2);
    local beforeStr = string.sub(caption, 1, ifPos - 1);
    local afterStr = string.sub(caption, elsePos + 4, string.len(caption));

    local funcStr = string.format("function SKL_TEMP_FUNC(obj)\
        if %s then return \"%s\"; else return \"%s\"; end; end;", ifParsed, thenParsed, elseParsed);


    local runLoadString = load(funcStr);
    local funcc = runLoadString(obj);
    local result = SKL_TEMP_FUNC(obj);

    return (beforeStr .. result .. afterStr), 1;

end

function TRY_PARSE_PROPERTY(obj, nextObj, caption)
    local tagStart = string.find(caption, "#{");
    if tagStart ~= nil then
        local nextStr = string.sub(caption, tagStart + 2, string.len(caption));
        local tagEnd = string.find(nextStr, "}#");
        if tagEnd ~= nil then
            local tagText = string.sub(caption, tagStart + 2, tagStart + tagEnd);
            local beforeStr = string.sub(caption, 1, tagStart - 1);
            local endStr = string.sub(caption, tagStart + tagEnd + 3, string.len(caption));

            local propValue;
            if string.sub(tagText, 1, 1) == "1" then
                local propName = string.sub(tagText, 2, string.len(tagText));
                propValue = nextObj[propName];
            else
                propValue = nextObj[tagText]
            end

            if propValue % 1 ~= 0 then
                propValue = string.format("%.1f", propValue);
            end
            return (beforeStr .. propValue .. endStr), 1;
        end

    end
    return caption, 0;
end

function PARSE_TOOLTIP_CAPTION(_obj, caption, predictSkillPoint)
    caption = dictionary.ReplaceDicIDInCompStr(caption);
    local obj;  
    local parsed = 0;
    
    local hasSkil = true;
    if _obj.Level < 1 then
        hasSkil = false;
    end
    
    --CloneIES_UseCP use -> buff normal, attack abnormal
    --CloneIES       use -> buff abnormal, attack normal

    local valueType = TryGetProp(_obj, 'ClassName');

    if ValueType  == "Attack" then
        obj = CloneIES(_obj);
    else
        obj = CloneIES_UseCP(_obj);
    end
    
    if obj == nil then
        return caption;
    end
    
    local addCaption = ""
    local skillValueType = TryGetProp(obj,"ValueType")
    if skillValueType ~= nil then
        local skillClassType = TryGetProp(obj,"ClassType","None")
        local skillAttackType = TryGetProp(obj,"AttackType","None")
        local skillAttribute = TryGetProp(obj,"Attribute","None")
        local skillAffectedByAttackSpeedRate = TryGetProp(obj,"AffectedByAttackSpeedRate","None")
        local skillEnableCompanion = TryGetProp(obj,"EnableCompanion","None")
        local skillHitType = TryGetProp(obj, "HitType", "None")
        
        if skillValueType == "Attack" then
            if skillClassType == "Melee" then
                addCaption = addCaption..ScpArgMsg('SKILL_CAPTION_MSG1')
                if skillAttackType == "Aries" then
                    addCaption = addCaption.." - "..ScpArgMsg('SKILL_CAPTION_MSG4')
                elseif skillAttackType == "Slash" then
                    addCaption = addCaption.." - "..ScpArgMsg('SKILL_CAPTION_MSG5')
                elseif skillAttackType == "Strike" then
                    addCaption = addCaption.." - "..ScpArgMsg('SKILL_CAPTION_MSG6')
                end
            elseif skillClassType == "Magic" then
                addCaption = addCaption..ScpArgMsg('SKILL_CAPTION_MSG2')
            elseif skillClassType == "Missile" then
                addCaption = addCaption..ScpArgMsg('SKILL_CAPTION_MSG3')
                if skillAttackType == "Arrow" then
                    addCaption = addCaption.." - "..ScpArgMsg('SKILL_CAPTION_MSG7')
                elseif skillAttackType == "Gun" then
                    addCaption = addCaption.." - "..ScpArgMsg('SKILL_CAPTION_MSG8')
                elseif skillAttackType == "Cannon" then
                    addCaption = addCaption.." - "..ScpArgMsg('SKILL_CAPTION_MSG9')
                end
            end
            
            if skillAttribute == "Fire" then
                addCaption = addCaption.." - "..ScpArgMsg('SKILL_CAPTION_MSG10')
            elseif skillAttribute == "Ice" then
                addCaption = addCaption.." - "..ScpArgMsg('SKILL_CAPTION_MSG11')
            elseif skillAttribute == "Lightning" then
                addCaption = addCaption.." - "..ScpArgMsg('SKILL_CAPTION_MSG12')
            elseif skillAttribute == "Poison" then
                addCaption = addCaption.." - "..ScpArgMsg('SKILL_CAPTION_MSG13')
            elseif skillAttribute == "Earth" then
                addCaption = addCaption.." - "..ScpArgMsg('SKILL_CAPTION_MSG14')
            elseif skillAttribute == "Dark" then
                addCaption = addCaption.." - "..ScpArgMsg('SKILL_CAPTION_MSG15')
            elseif skillAttribute == "Holy" then
                addCaption = addCaption.." - "..ScpArgMsg('SKILL_CAPTION_MSG16')
            elseif skillAttribute == "Soul" then
                addCaption = addCaption.." - "..ScpArgMsg('SKILL_CAPTION_MSG17')
            end
            
            if addCaption ~= "" then
                addCaption = addCaption.."{nl}"
            end
            
            if skillAffectedByAttackSpeedRate == "YES" then
                addCaption = addCaption..ScpArgMsg('SKILL_CAPTION_MSG18').."{nl}"
            end
        end
        
        local classname = TryGetProp(obj, "ClassName", "None")
        if skillEnableCompanion == "BOTH" and (classname ~= "Templer_BattleOrders" and classname ~= "Templer_AdvancedOrders" and classname ~= "Templer_HorseRiding") then
            addCaption = addCaption..ScpArgMsg('SKILL_CAPTION_MSG19').."{nl}"
        elseif skillEnableCompanion == "YES" then
            addCaption = addCaption..ScpArgMsg('SKILL_CAPTION_MSG20').."{nl}"
        end
        
        if skillHitType == "Pad" then
            if skillClassType == "Magic" then
                addCaption = addCaption..ScpArgMsg('SKILL_CAPTION_MSG21').."{nl}"
            else
                addCaption = addCaption..ScpArgMsg('SKILL_CAPTION_MSG22').."{nl}"
            end
        elseif skillHitType == "Installation" then
            addCaption = addCaption..ScpArgMsg('SKILL_CAPTION_MSG23').."{nl}"
        end        
        
        if addCaption ~= "" then
            addCaption = "{#DD5500}{ol}"..addCaption.."{/}{/}"
        end
        
        caption = addCaption..caption
    end

    local nextObj = CloneIES_UseCP(obj);

    if ValueType  == "Attack" then
        nextObj = CloneIES(obj);
    else
        nextObj = CloneIES_UseCP(obj);
    end

    while 1 do
        caption, parsed = TRY_PARSE_TOOLTIPCOND(obj, caption);
        if parsed == 0 then
            break;
        end
    end
    
    
    if nextObj == nil then
        DestroyIES(obj);
        return caption;
    end

    local lvCaption = caption;    
    
    local skillLevel = 0;
    if predictSkillPoint == true then
        skillLevel = session.GetUserConfig("SKLUP_" .. nextObj.ClassName);
    end

    if hasSkil == false and skillLevel < 1 then
        skillLevel = 1;
    end
    
    skillLevel = _obj.Level + skillLevel;
    local LevelByDB = TryGetProp(nextObj, 'LevelByDB');
    
    if LevelByDB ~= nil then
        nextObj.LevelByDB = skillLevel;
    else
        nextObj.Level = skillLevel
    end
    
    local lvStart, lvEnd = string.find(caption, "Lv.");
    if lvStart ~= nil then
        local beforeText = string.sub(lvCaption, 1, lvStart - 1);        
        local afterText  = string.sub(lvCaption, lvEnd+1, string.len(lvCaption));        
        lvCaption = beforeText .. "ch."..afterText;        
    end
    
    while 1 do
        lvStart, lvEnd = string.find(lvCaption, "Lv.");        
        if lvStart ~= nil then
            local propStart = string.find(caption, "#{");
            if propStart ~= nil then
                if lvStart < propStart then
                    beforeText = string.sub(lvCaption, 1, lvStart - 1);
                    afterText  = string.sub(lvCaption, lvEnd+1, string.len(lvCaption));                    
                    lvCaption = beforeText .. "ch."..afterText;                    
                    DestroyIES(nextObj);                
                    nextObj = CloneIES_UseCP(_obj);
                    skillLevel = skillLevel + 1;                    

                    if LevelByDB ~= nil then
                        nextObj.LevelByDB = skillLevel;
                    else
                        nextObj.Level = skillLevel
                    end
                    
                end
            end
        end

        -- current level        
        caption, parsed = TRY_PARSE_PROPERTY(obj, nextObj, caption);        
        -- next level
        lvCaption, parsed = TRY_PARSE_PROPERTY(obj, nextObj, lvCaption);      
        if parsed == 0 then
            break;
        end
    end
    DestroyIES(obj);
    DestroyIES(nextObj);
    return caption;

end


function UPDATE_ABILITY_TOOLTIP(frame, strarg, numarg1, numarg2)

    local abil = session.GetAbilityByGuid(numarg2);
    local obj = nil;
    if abil == nil then
        obj = GetClassByType("Ability", numarg1);
    else
        obj = GetIES(abil:GetObject());
    end

    if obj == nil then
        return;
    end

    local iconPicture = GET_CHILD(frame, "icon", "ui::CPicture");
    iconPicture:SetImage(obj.Icon);

    local name = frame:GetChild('name');
    name:SetText('{@st43}'.. obj.Name..'{/}');

    local typeCtrl = GET_CHILD(frame, "type", "ui::CRichText");
    typeCtrl:SetText('{@st42}'..ClMsg("Ability"));

    local descCtrl = GET_CHILD(frame, "desc", "ui::CRichText");
    descCtrl:SetTextAlign("left", "top");
    descCtrl:SetGravity(ui.CENTER_HORZ, ui.TOP);
    local translatedData = dictionary.ReplaceDicIDInCompStr(obj.Desc);
    if obj.Desc ~= translatedData then
        descCtrl:SetDicIDText(obj.Desc)
    end
    descCtrl:SetText('{#1f100b}'..PARSE_TOOLTIP_CAPTION(obj, obj.Desc, true));

    local ypos = descCtrl:GetY() + descCtrl:GetHeight();

    local originalText = ""
    local translatedData2 = dictionary.ReplaceDicIDInCompStr(obj.Desc2);
    if obj.Desc2 ~= translatedData2 then
        originalText = obj.Desc2
    end

    local skillLvDesc = PARSE_TOOLTIP_CAPTION(obj, obj.Desc2, true);

    local lvDescStart, lvDescEnd = string.find(skillLvDesc, "Lv.");

    local lv = 1;
    local totalLevel = 0;

    local stateLevel = session.GetUserConfig("SKLUP_" .. strarg, 0);
    local skl = session.GetAbilityByName(obj.ClassName)
    if skl ~= nil then
        skillObj = GetIES(skl:GetObject());
        totalLevel = skillObj.Level + stateLevel;
    else
        totalLevel = stateLevel;
    end

    if lvDescStart ~= nil and totalLevel ~= 0 then
        skillLvDesc = string.sub(skillLvDesc, lvDescEnd + 2, string.len(skillLvDesc));

        while true do
            
            local levelvalue = 2
            if lv >= 9 then
                levelvalue = 3
            elseif lv >= 99 then
                levelvalue = 4
            end

            lvDescStart, lvDescEnd = string.find(skillLvDesc, "Lv.");
            if lvDescStart == nil then
                local lvDesc = string.sub(skillLvDesc, 2, string.len(skillLvDesc));
                ypos = SKILL_LV_DESC_TOOLTIP(frame, obj, totalLevel, lv, lvDesc, ypos, originalText);
                break;
            end
            local lvDesc = string.sub(skillLvDesc, 2, lvDescStart -1);
            skillLvDesc  = string.sub(skillLvDesc, lvDescEnd + levelvalue, string.len(skillLvDesc));
            
            ypos = SKILL_LV_DESC_TOOLTIP(frame, obj, totalLevel, lv, lvDesc, ypos, originalText);
            lv = lv + 1;
        end
    end
    frame:Resize(frame:GetWidth(), ypos + 30);
 end

 function MAKE_STANCE_ICON(reqstancectrl, reqstance, EnableCompanion, leftOffset, topOffset)
	local mainSum = 1;
	local mainWeapon = {}
	local mainWeaponName = {}
	local subSum = 1;
	local subWeapon = {}
	local subWeaponName = {}
	local tooltipText = "";
	local iconCount = 0;
    local compainon = 0;

	if EnableCompanion == "YES" then
		local shareBtn = reqstancectrl:CreateControl("picture", "companion", leftOffset, topOffset, 28, 20)
		shareBtn:ShowWindow(1);	
		shareBtn = tolua.cast(shareBtn, "ui::CPicture");
		shareBtn:SetImage("weapon_companion");
		--shareBtn:SetTextTooltip();
		tooltipText = ScpArgMsg("companionRide").."{nl}"
		compainon = 20;	
	end

    local width = 0;
	if reqstance == "None" then
		local shareBtn = reqstancectrl:CreateControl("picture", "All", leftOffset + compainon, topOffset, 28, 20)
		shareBtn:ShowWindow(1);	
		shareBtn = tolua.cast(shareBtn, "ui::CPicture");
		shareBtn:SetImage("weapon_All");
		--shareBtn:SetTextTooltip(ScpArgMsg("EquipAll"));
		local tooltipSize = 28;
		if compainon ~= 0 then
			tooltipSize = tooltipSize + 20
		end

		local shareBtn = reqstancectrl:CreateControl("picture", "iconTooltip", leftOffset, topOffset, tooltipSize, 20)
		shareBtn = tolua.cast(shareBtn, "ui::CPicture");
		shareBtn:SetTextTooltip(tooltipText..ScpArgMsg("EquipAll"));				
		return 0, compainon/20;
	end	
	
	local stancelist, stancecnt = GetClassList("Stance");	
	for word in string.gmatch(reqstance, "%a+")do
		local stance = GetClassByNameFromList(stancelist, word);	
		local index = string.find(stance.ClassName, "Artefact")
		if index == nil then
				tooltipText = tooltipText..stance.Name.."{nl}";
		end
	end
	
	for i = 0, stancecnt -1 do
		local stance = GetClassByIndexFromList(stancelist, i)
		local index = string.find(reqstance, stance.ClassName)
		--스탠스는 TwoHandBow인데.. 쇠뇌이름이 Bow라서 위에 스트링파인드에 걸림..
		--쇠뇌이름을 변경하면 데이터작업자들이 고통스러우니.. 예외를 둔다.. 진짜 망한 구조임..
		
		if (reqstance == "TwoHandBow") and (stance.ClassName == "Bow") then
			index = nil;
		end
		if index ~= nil then
			local index = string.find(stance.ClassName, "Artefact")
			if index == nil then
				if stance.UseSubWeapon == "NO" then
					mainWeapon[mainSum] = stance.Icon
					mainWeaponName[mainSum] = stance.Name
					mainSum = mainSum + 1
				elseif stance.UseSubWeapon == "YES" then
					local flag = 0
					for i = 0, #subWeapon do
						if subWeapon[i] == stance.Icon then
							flag = 1
						end
					end
					if flag == 0 then
						subWeapon[subSum] = stance.Icon
						subWeaponName[subSum] = stance.Name
						subSum = subSum + 1
					end
				end
			end
		end
	end
	
	local index = 0	
	for i = 1, #mainWeapon do
		local shareBtn = reqstancectrl:CreateControl("picture", mainWeapon[i]..i, (leftOffset + compainon)+((i-1)*20), topOffset, 20, 20)
		shareBtn = tolua.cast(shareBtn, "ui::CPicture");
		shareBtn:SetImage(mainWeapon[i]);
		--shareBtn:SetTextTooltip(mainWeaponName[i]);	
		index = index + 1
		iconCount = iconCount + 1
	end

	for i = 1, #subWeapon do
		local shareBtn = reqstancectrl:CreateControl("picture", subWeapon[i]..index+i, (leftOffset + compainon)+((index+i-1)*20), topOffset, 20, 20)
		shareBtn = tolua.cast(shareBtn, "ui::CPicture");
		shareBtn:SetImage(subWeapon[i]);
		--shareBtn:SetTextTooltip(subWeaponName[i]);	
		iconCount = iconCount + 1
	end

    local compainonindex = 0		
	if iconCount > 0 then 
		if compainon ~= 0 then
			compainonindex = 1
		end
		local shareBtn = reqstancectrl:CreateControl("picture", "iconTooltip", leftOffset, topOffset, (compainonindex + iconCount)*20, 20)
		shareBtn = tolua.cast(shareBtn, "ui::CPicture");
		shareBtn:SetTextTooltip(tooltipText);	
	end
	return iconCount, compainonindex;
end

function SET_SKILL_TOOLTIP_ICON_AND_NAME(skillFrame, obj, useTranslateData)    
    local iconPicture = GET_CHILD(skillFrame, "icon", "ui::CPicture");
    local iconname = "icon_" .. obj.Icon;
    iconPicture:SetImage(iconname);
    local name = skillFrame:GetChild('name');
    local nameText = '{@st43}'..obj.Name;

    if useTranslateData == true then
        local translatedData = dictionary.ReplaceDicIDInCompStr(obj.Name);
        if obj.EngName ~= translatedData then
            if config.GetServiceNation() ~= "GLOBAL" then
                nameText = nameText .. "{/}{nl}" .. obj.EngName;
            end
        end
    end
    name:SetText(nameText); 
end

function SET_SKILL_TOOLTIP_CAPTION(skillFrame, caption, parsedCaption)
    local skillDesc = GET_CHILD(skillFrame, "desc", "ui::CRichText");   
    skillDesc:Resize(skillDesc:GetWidth(), 20);
    skillDesc:SetTextAlign("left", "top");
    local translatedData = dictionary.ReplaceDicIDInCompStr(caption);
    if caption ~= translatedData then
        skillDesc:SetDicIDText(caption)
    end
    skillDesc:SetText('{#1f100b}'..parsedCaption);
    skillDesc:EnableSplitBySpace(0);
end

function SET_SKILL_PUB_CREATECHAR_TOOLTIP_CAPTION(skillFrame, caption, parsedCaption)
    local skillDesc = GET_CHILD(skillFrame, "desc", "ui::CRichText");   
    skillDesc:Resize(skillDesc:GetWidth(), 20);
    skillDesc:SetTextAlign("left", "top");
    local translatedData = dictionary.ReplaceDicIDInCompStr(caption);
    if caption ~= translatedData then
        skillDesc:SetDicIDText(caption)
    end
    skillDesc:SetText('{@st41b}{s16}'..parsedCaption);
    skillDesc:EnableSplitBySpace(0);
end

local function get_remove_buff_additional_tooltip(func, lv, lvDesc, additional_remove_buff_tooltip)
    -- 버프 삭제 로직 툴팁 관련    
    if func ~= nil then
        local args = func(lv)    
        if args ~= nil then
            local token = StringSplit(args, '/')                        
            local msg = ScpArgMsg('AdditionalRemoveEnemyBuff{level}{prob}{count}', 'level', token[2], 'prob', tonumber(token[4]), 'count', token[3])
            additional_remove_buff_tooltip = dictionary.ReplaceDicIDInCompStr(msg)
        end
    end

    if additional_remove_buff_tooltip ~= nil then
        lvDesc = string.format("%s{nl}%s", lvDesc, additional_remove_buff_tooltip)
    end

    return lvDesc
end

local function get_decrease_heal_debuff_additional_tooltip(func, lv, lvDesc, additional_decrease_heal_debuff_tooltip)
    if func ~= nil then
        local args = func(lv)                        
        local token = StringSplit(args, '/')                
        local msg = ScpArgMsg('AdditionalDecreaseHealEnemy{duration}{ratio}', 'duration', math.floor(tonumber(token[4])/1000), 'ratio', string.format("%.1f", tonumber(token[3])/1000))
        additional_decrease_heal_debuff_tooltip = dictionary.ReplaceDicIDInCompStr(msg)
    end

    if additional_decrease_heal_debuff_tooltip ~= nil then
        lvDesc = string.format("%s{nl}%s", lvDesc, additional_decrease_heal_debuff_tooltip)
    end

    return lvDesc
end

local function get_remove_debuff_additional_tooltip(func, lv, lvDesc, additional_decrease_heal_debuff_tooltip)
    -- 디버프 삭제 로직 툴팁 관련    
    if func ~= nil then
        local args = func(lv)        
        local token = StringSplit(args, '/')
        local msg = ''
        if token[6] == 'self' then
            msg = ScpArgMsg('AdditionalRemoveSelfDebuff{level}{prob}{count}', 'level', token[2], 'prob', tonumber(token[4]), 'count', token[3])
        else
            msg = ScpArgMsg('AdditionalRemoveFriendDebuff{level}{prob}{count}', 'level', token[2], 'prob', tonumber(token[4]), 'count', token[3])
        end
        additional_remove_buff_tooltip = dictionary.ReplaceDicIDInCompStr(msg)
    end

    if additional_remove_buff_tooltip ~= nil then
        lvDesc = string.format("%s{nl}%s", lvDesc, additional_remove_buff_tooltip)
    end

    return lvDesc
end

function UPDATE_SKILL_TOOLTIP(frame, strarg, numarg1, numarg2, userData, obj)  	
    -- destroy skill, ability tooltip
    DESTROY_CHILD_BYNAME(frame:GetChild('skill_desc'), 'SKILL_CAPTION_');
    DESTROY_CHILD_BYNAME(frame:GetChild('ability_desc'), 'ABILITY_CAPTION_');

    local abil = session.GetSkillByGuid(numarg2);	
    local obj = nil;
    local objIsClone = false;
    local tooltipStartLevel = 1;
    if abil == nil then
        local cloneObjLevel = 0;
        if strarg == "Level" then
            cloneObjLevel = numarg2;
        end
        obj = GetClassByType("Skill", numarg1);
        obj = CloneIES_UseCP(obj);
        obj.LevelByDB = cloneObjLevel;
        tooltipStartLevel = cloneObjLevel;
        objIsClone = true;
    else	
        --존 이동시 아이템에 의한 스킬레벨이 툴팁에 적용되지 않음
        obj = GetIES(abil:GetObject());
        tooltipStartLevel = obj.Level;
    end

    if obj == nil then
        return;
    end
	
    --------------------------- skill description frame ------------------------------------
    local skillFrame = GET_CHILD(frame, "skill_desc", "ui::CGroupBox")
    -- set skill icon and name
    SET_SKILL_TOOLTIP_ICON_AND_NAME(skillFrame, obj, true);    
    
    -- set skill description
    local skillDesc = GET_CHILD(skillFrame, "desc", "ui::CRichText");   	
    SET_SKILL_TOOLTIP_CAPTION(skillFrame, obj.Caption, PARSE_TOOLTIP_CAPTION(obj, obj.Caption, true));    	

    local stateLevel = 0;
    if strarg ~= "quickslot" then
        stateLevel = session.GetUserConfig("SKLUP_" .. obj.ClassName, 0);
    end
    tooltipStartLevel = tooltipStartLevel + stateLevel;    

    local skilltreecls = GetClassByStrProp("SkillTree", "SkillName", obj.ClassName);
    local iconPicture = GET_CHILD(skillFrame, "icon", "ui::CPicture");
    local iconEndPos = iconPicture:GetY() + iconPicture:GetHeight()
    local ypos = skillDesc:GetY() + skillDesc:GetHeight()

    if ypos < iconEndPos then
        ypos = iconEndPos + 10
    end

    -- set weapon info
    local weaponBox = GET_CHILD(skillFrame, "weapon_box", "ui::CGroupBox")
    local stancePic = weaponBox:GetChild("stance_pic")
    stancePic:RemoveAllChild()
    if TryGetProp(obj, 'ReqStance') ~= nil and TryGetProp(obj, 'EnableCompanion') ~= nil then       
        MAKE_STANCE_ICON(stancePic, obj.ReqStance, obj.EnableCompanion, 100, 37)

        local childCount = stancePic:GetChildCount()
        for i=0, childCount-1 do
            local child = stancePic:GetChildByIndex(i);
            child:SetOffset(child:GetWidth() * i + 5, 10)
        end
    end
    
    weaponBox:SetOffset(0, ypos)
    ypos = weaponBox:GetY() + weaponBox:GetHeight() + 5;
    

    -- skill level description controlset
    local skillCaption2 = MAKE_SKILL_CAPTION2(obj.ClassName, obj.Caption2, tooltipStartLevel);    
    local originalText = ""
    local translatedData2 = dictionary.ReplaceDicIDInCompStr(skillCaption2);        
    if skillCaption2 ~= translatedData2 then
        originalText = skillCaption2
    end    
    
    local skillLvDesc = PARSE_TOOLTIP_CAPTION(obj, skillCaption2, strarg ~= "quickslot");	
    local lvDescStart, lvDescEnd = string.find(skillLvDesc, "Lv.");
    local lv = 1;
    if tooltipStartLevel > 0 then
        lv = tooltipStartLevel;
    end 

    local totalLevel = 0;
    local skl = session.GetSkillByName(obj.ClassName);
    if strarg ~= "Level" then
        if skl ~= nil then
            skillObj = GetIES(skl:GetObject());
            totalLevel = skillObj.Level + stateLevel;
        else
            totalLevel = stateLevel;
        end
    else
        totalLevel = obj.LevelByDB;
    end
    
    -- 적 버프 제거 관련 --------------------------------------------------
    local skill_class_name = TryGetProp(obj, 'ClassName', 'None')
    local additional_remove_buff_tooltip = nil
    local func_name_remove_buff = nil
    if skill_class_name ~= 'None' then
        func_name_remove_buff = string.format('get_remove_buff_tooltip_%s', skill_class_name)
    end
    
    -- 아군 디버프 제거 관련 
    local additional_remove_debuff_tooltip = nil
    local func_name_remove_debuff = nil
    if skill_class_name ~= 'None' then
        func_name_remove_debuff = string.format('get_remove_debuff_tooltip_%s', skill_class_name)
    end
    --------------------------------------------------------------------
    
    -- 적에게 힐량 감소 디버프 부여 관련 ----------------------------------
    local additional_decrease_heal_debuff_tooltip = nil
    local func_name_decrease_heal = nil
    if skill_class_name ~= 'None' then
        func_name_decrease_heal = string.format('get_decrease_heal_debuff_tooltip_%s', skill_class_name)
    end
    --------------------------------------------------------------------

    local currLvCtrlSet = nil    
    if totalLevel == 0 and lvDescStart ~= nil then  -- no have skill case
        skillLvDesc = string.sub(skillLvDesc, lvDescEnd + 2, string.len(skillLvDesc));
        lvDescStart, lvDescEnd = string.find(skillLvDesc, "Lv.");        
        if lvDescStart ~= nil then              
            local lvDesc = string.sub(skillLvDesc, 2, lvDescStart -1);
            skillLvDesc  = string.sub(skillLvDesc, lvDescEnd + 2    , string.len(skillLvDesc));

            -- 버프 삭제 로직 툴팁 관련 ----------------------------------------------------------------
            if func_name_remove_buff ~= nil and _G[func_name_remove_buff] ~= nil then 
                local func = _G[func_name_remove_buff]                            
                lvDesc = get_remove_buff_additional_tooltip(func, 1, lvDesc, additional_remove_buff_tooltip)
            end

            if func_name_remove_debuff ~= nil and _G[func_name_remove_debuff] ~= nil then 
                local func = _G[func_name_remove_debuff]            
                lvDesc = get_remove_debuff_additional_tooltip(func, 1, lvDesc, additional_remove_buff_tooltip)
            end
            -------------------------------------------------------------------------------------------------

            -- 힐량 감소 디버프 부여 툴팁 관련 ----------------------------------------------------------------
            if func_name_decrease_heal ~= nil and _G[func_name_decrease_heal] ~= nil then
                local func = _G[func_name_decrease_heal]
                lvDesc = get_decrease_heal_debuff_additional_tooltip(func, 1, lvDesc, additional_decrease_heal_debuff_tooltip)
            end
            -------------------------------------------------------------------------------------------------

            ypos = SKILL_LV_DESC_TOOLTIP(skillFrame, obj, totalLevel, lv, lvDesc, ypos, originalText);
        else -- max skill level = 1        
            local lvDesc = string.sub(skillLvDesc, 2, string.len(skillLvDesc));
            
            -- 버프 삭제 로직 툴팁 관련 ----------------------------------------------------------------
            if func_name_remove_buff ~= nil and _G[func_name_remove_buff] ~= nil then 
                local func = _G[func_name_remove_buff]
                lvDesc = get_remove_buff_additional_tooltip(func, 1, lvDesc, additional_remove_buff_tooltip)
            end

            if func_name_remove_debuff ~= nil and _G[func_name_remove_debuff] ~= nil then 
                local func = _G[func_name_remove_debuff]            
                lvDesc = get_remove_debuff_additional_tooltip(func, 1, lvDesc, additional_remove_buff_tooltip)
            end
            -------------------------------------------------------------------------------------------------

            -- 힐량 감소 디버프 부여 툴팁 관련 ----------------------------------------------------------------
            if func_name_decrease_heal ~= nil and _G[func_name_decrease_heal] ~= nil then
                local func = _G[func_name_decrease_heal]
                lvDesc = get_decrease_heal_debuff_additional_tooltip(func, 1, lvDesc, additional_decrease_heal_debuff_tooltip)
            end
            -------------------------------------------------------------------------------------------------

            ypos = SKILL_LV_DESC_TOOLTIP(skillFrame, obj, totalLevel, lv, lvDesc, ypos, originalText);
        end            
    elseif lvDescStart ~= nil and totalLevel ~= 0 then        
        skillLvDesc = string.sub(skillLvDesc, lvDescEnd + 2, string.len(skillLvDesc));                		
        while 1 do			

            local levelvalue = 2
            if lv >= 9 then
                levelvalue = 3
            elseif lv >= 99 then
                levelvalue = 4
            end
            
            lvDescStart, lvDescEnd = string.find(skillLvDesc, "Lv.");  
            if lvDescStart == nil then -- max skill level = 1
                local lvDesc = string.sub(skillLvDesc, 2, string.len(skillLvDesc));
                
                -- 버프 삭제 로직 툴팁 관련 -----------------------------------------------------------------------
                if func_name_remove_buff ~= nil and _G[func_name_remove_buff] ~= nil then 
                    local func = _G[func_name_remove_buff]
                    lvDesc = get_remove_buff_additional_tooltip(func, lv, lvDesc, additional_remove_buff_tooltip)
                end

                if func_name_remove_debuff ~= nil and _G[func_name_remove_debuff] ~= nil then 
                    local func = _G[func_name_remove_debuff]            
                    lvDesc = get_remove_debuff_additional_tooltip(func, lv, lvDesc, additional_remove_buff_tooltip)
                end
                -------------------------------------------------------------------------------------------------
                
                -- 힐량 감소 디버프 부여 툴팁 관련 ----------------------------------------------------------------
                if func_name_decrease_heal ~= nil and _G[func_name_decrease_heal] ~= nil then
                    local func = _G[func_name_decrease_heal]
                    lvDesc = get_decrease_heal_debuff_additional_tooltip(func, lv, lvDesc, additional_decrease_heal_debuff_tooltip)
                end
                -------------------------------------------------------------------------------------------------

                ypos = SKILL_LV_DESC_TOOLTIP(skillFrame, obj, totalLevel, lv, lvDesc, ypos, originalText);                				
                break;
            end            
            local lvDesc = string.sub(skillLvDesc, 2, lvDescStart -1);   			            
            local comma = string.sub(lvDesc, 1, 1)            
            if comma ~= nil and comma == ',' then                
                lvDesc = string.sub(skillLvDesc, 3, lvDescStart -1);   
            end
            skillLvDesc  = string.sub(skillLvDesc, lvDescEnd + levelvalue, string.len(skillLvDesc))
            
            -- 버프 삭제 로직 툴팁 관련 ----------------------------------------------------------------
            if func_name_remove_buff ~= nil and _G[func_name_remove_buff] ~= nil then 
                local func = _G[func_name_remove_buff]
                lvDesc = get_remove_buff_additional_tooltip(func, lv, lvDesc, additional_remove_buff_tooltip)
            end

            if func_name_remove_debuff ~= nil and _G[func_name_remove_debuff] ~= nil then 
                local func = _G[func_name_remove_debuff]            
                lvDesc = get_remove_debuff_additional_tooltip(func, lv, lvDesc, additional_remove_buff_tooltip)
            end
            -------------------------------------------------------------------------------------------------

            -- 힐량 감소 디버프 부여 툴팁 관련 ----------------------------------------------------------------
            if func_name_decrease_heal ~= nil and _G[func_name_decrease_heal] ~= nil then
                local func = _G[func_name_decrease_heal]
                lvDesc = get_decrease_heal_debuff_additional_tooltip(func, lv, lvDesc, additional_decrease_heal_debuff_tooltip)
            end
            -------------------------------------------------------------------------------------------------

            ypos = SKILL_LV_DESC_TOOLTIP(skillFrame, obj, totalLevel, lv, lvDesc, ypos, originalText);            
            lv = lv + 1;
        end
    end
         
    local noTrade = GET_CHILD(skillFrame, "trade_text", "ui::CRichText");
    local itemID = frame:GetUserValue("SCROLL_ITEM_ID");
    local noTradeCnt = nil;
    if itemID ~= "None" then
        local scrollInvType = frame:GetUserValue("SCROLL_ITEM_INVTYPE");
        local itemObj, isReadObj = GET_TOOLTIP_ITEM_OBJECT(scrollInvType, itemID);
        if itemObj ~= nil then
            noTradeCnt = TryGetProp(itemObj, "BelongingCount");
            if isReadObj == 1 then
                DestroyIES(itemObj);
            end
        end
    end
   
    if noTradeCnt ~= nil and 0 <= noTradeCnt then
        noTrade:SetTextByKey('count', noTradeCnt);
        noTrade:ShowWindow(1);
        noTrade:SetOffset(noTrade:GetOriginalX() + 10, ypos - noTrade:GetOriginalHeight());
    else
        noTrade:SetOffset(noTrade:GetOriginalX(),noTrade:GetOriginalY());
        noTrade:ShowWindow(0);
    end
    noTrade:Invalidate();
    
    --[[ pvp info: pvp info is not documented
    ypos = PVP_DESC_TOOLTIP(skillFrame, ypos)   
    ]]--

    skillFrame:Resize(frame:GetWidth(), ypos + 10)
    frame:Resize(frame:GetWidth(), skillFrame:GetHeight() + 10)


    ------------------------ ability description frame ---------------------------------
    local isShowNoHaveAbility = false
    local abilFrame = GET_CHILD(frame, 'ability_desc', 'ui::CGroupBox')
    abilFrame:SetOffset(0, ypos)
    ypos = 20 -- init by ability frame

    local jobEngNameList = {}
    local mySession = session.GetMySession();
    local jobHistory = mySession:GetPCJobInfo();
    local jobHistoryCnt = jobHistory:GetJobCount();
    for i = 0, jobHistoryCnt - 1 do
		local jobInfo = jobHistory:GetJobInfoByIndex(i);
        local jobCls = GetClassByType("Job", jobInfo.jobID)
        jobEngNameList[#jobEngNameList+1] = jobCls.EngName
    end

    local showAbilCnt = 0;
    local abilList, abilCnt = GET_ABILITYLIST_BY_SKILL_NAME(obj.ClassName, jobEngNameList);

    local pcAbilCnt = 0 -- ability count for showing
    local pcAbilList = {}
    for i = 0, abilCnt-1 do     
        -- check pc have abilList[i]
        local pcAbilIES  = GetAbilityIESObject(GetMyPCObject(), abilList[i].ClassName);             
        if isShowNoHaveAbility or (pcAbilIES ~= nil and pcAbilIES.ActiveState == 1) then
            if pcAbilCnt > 0 then -- secondary ability: label line added
                local labelLine = abilFrame:CreateOrGetControl('labelline', 'ABILITY_CAPTION_'..tostring(i), 0, ypos, 480, 2);
                ypos = ypos + 10
                labelLine:SetGravity(ui.CENTER_HORZ, ui.TOP)
                labelLine:SetSkinName('labelline_def_2')
            end
            ypos = ABILITY_DESC_TOOLTIP(abilFrame, abilList[i], i, ypos, GetMyPCObject(), pcAbilIES)
            showAbilCnt = showAbilCnt + 1
        end

        if isShowNoHaveAbility then
            pcAbilList[pcAbilCnt] = abilList[i]
            pcAbilCnt = pcAbilCnt + 1
        elseif pcAbilIES ~= nil then
            pcAbilList[pcAbilCnt] = pcAbilIES
            pcAbilCnt = pcAbilCnt + 1
        end
    end

    if totalLevel > 0 and showAbilCnt > 0 then
        local captionFrame = skillFrame:GetChild('SKILL_CAPTION_'..tostring(totalLevel))
        tolua.cast(captionFrame, "ui::CControlSet");
        ADD_SPEND_SKILL_LV_DESC_TOOLTIP(captionFrame, pcAbilList, pcAbilCnt)
        abilFrame:Resize(frame:GetWidth(), ypos)
        frame:Resize(frame:GetWidth(), frame:GetHeight() + abilFrame:GetHeight());
        abilFrame:ShowWindow(1)
    else
        abilFrame:ShowWindow(0)
    end
    frame:Invalidate();

    if objIsClone == true then
        DestroyIES(obj);
    end
end

function UPDATE_SKILL_PUB_CREATECHAR_TOOLTIP(frame, strarg, numarg1, numarg2, userData, obj)
    DESTROY_CHILD_BYNAME(frame:GetChild('skill_desc'), 'SKILL_CAPTION_');
    DESTROY_CHILD_BYNAME(frame:GetChild('ability_desc'), 'ABILITY_CAPTION_');

    local abil = session.GetSkillByGuid(numarg2);
    local obj = nil; local objIsClone = false;
   
    local tooltipStartLevel = 1;
    if abil == nil then
        local cloneObjLevel = 0;
        if strarg == "Level" then
            cloneObjLevel = numarg2;
        end
        obj = GetClassByType("Skill", numarg1);
        obj = CloneIES_UseCP(obj);
        obj.LevelByDB = cloneObjLevel;
        tooltipStartLevel = cloneObjLevel;
        objIsClone = true;
    else	
        obj = GetIES(abil:GetObject());
        tooltipStartLevel = obj.Level;
    end

    if obj == nil then return; end
    
    -----description frame
    local skill_desc = GET_CHILD_RECURSIVELY(frame, "skill_desc");
    SET_SKILL_TOOLTIP_ICON_AND_NAME(skill_desc, obj, true);

    local desc_text = GET_CHILD_RECURSIVELY(skill_desc, "desc");
    SET_SKILL_PUB_CREATECHAR_TOOLTIP_CAPTION(skill_desc, obj.Caption, PARSE_TOOLTIP_CAPTION(obj, obj.Caption, true));

    local stateLv = 0;
    if strarg ~= "quickslot" then
        stateLv = session.GetUserConfig("SKLUP_"..obj.ClassName, 0);
    end
    tooltipStartLevel = tooltipStartLevel + stateLv;

    local icon_pic = GET_CHILD_RECURSIVELY(skill_desc, "icon");
    if icon_pic == nil then return; end

    local icon_end_pos = icon_pic:GetY() + icon_pic:GetHeight();
    local ypos = desc_text:GetY() + desc_text:GetHeight();    
    if ypos < icon_end_pos then
        ypos = icon_end_pos + 10;
    end

    -- weapon info
    local weapon_box = GET_CHILD_RECURSIVELY(frame, "weapon_box");
    local stance_pic = GET_CHILD_RECURSIVELY(weapon_box, "stance_pic");
    stance_pic:RemoveAllChild();

    if TryGetProp(obj, "ReqStance") ~= nil and TryGetProp(obj, "EnableCompanion") ~= nil then
        MAKE_STANCE_ICON(stance_pic, obj.ReqStance, obj.EnableCompanion, 100, 37);

        local childCnt = stance_pic:GetChildCount();
        for i = 0, childCnt - 1 do
            local child = stance_pic:GetChildByIndex(i);
            if child ~= nil then
                child:SetOffset(child:GetWidth() * i + 5, 10);
            end
        end
    end

    weapon_box:SetOffset(0, ypos);
    ypos = weapon_box:GetY() + weapon_box:GetHeight() + 5;

    -- level desc controlset
    local skl_caption2 = MAKE_SKILL_CAPTION2(obj.ClassName, obj.Caption2, tooltipStartLevel);

    local origin_text = "";
    local translated_data2 = dictionary.ReplaceDicIDInCompStr(skl_caption2);
    if skl_caption2 ~= translated_data2 then
        origin_text = skl_caption2;
    end

    local skllv_desc = PARSE_TOOLTIP_CAPTION(obj, skl_caption2, strarg ~= "quickslot");
    local lvdesc_start, lvdesc_end = string.find(skllv_desc, "Lv.");
    local lv = 1;

    local curLevelCtrlSet = nil;
    skllv_desc = string.sub(skllv_desc, lvdesc_end + 2, string.len(skllv_desc));
    lvdesc_start, lvdesc_end = string.find(skllv_desc, "Lv.");
    if lvdesc_start ~= nil then
        local lv_desc = string.sub(skllv_desc, 2, lvdesc_start - 1);
        skllv_desc = string.sub(skllv_desc, lvdesc_end + 2, string.len(skllv_desc));

        ypos = SKILL_LV_DESC_TOOLTIP(skill_desc, obj, lv, lv, lv_desc, ypos, origin_text);
    end

    local no_trade_cnt = nil;
    local no_trade = GET_CHILD_RECURSIVELY(skill_desc, "trade_text");
    local item_id = frame:GetUserValue("SCROLL_ITEM_ID");
    if item_id ~= "None" then
        local scroll_invtype = skill_desc:GetUserValue("SCROLL_ITEM_INVTYPE");
        local item_obj, is_read_obj = GET_TOOLTIP_ITEM_OBJECT(scroll_invtype, item_id);
        if item_obj ~= nil then
            no_trade_cnt = TryGetProp(item_obj, "BelongingCount");
            if is_read_obj == 1 then
                DestroyIES(item_obj);
            end
        end
    end

    if no_trade_cnt ~= nil and no_trade_cnt >= 0 then
        no_trade:SetTextByKey("count", no_trade_cnt);
        no_trade:ShowWindow(1);
        no_trade:SetOffSet(no_trade:GetOriginalX() + 10, ypos - no_trade:GetOriginalHeight());
    else
        no_trade:SetOffset(no_trade:GetOriginalX(), no_trade:GetOriginalY());
        no_trade:ShowWindow(0);
    end
    no_trade:Invalidate();

    skill_desc:Resize(frame:GetWidth(), ypos + 10);
    frame:Resize(frame:GetWidth(), skill_desc:GetHeight() + 10);
    frame:Invalidate();

    if objIsClone == true then
        DestroyIES(obj);
    end
end

 function MAKE_SKILL_CAPTION2(className, caption2, curLv)
    local originCaption = caption2;

    local clslist, cnt  = GetClassList("SkillTree");
    if cnt == 0 then
        return originCaption;
    end

    local caption = "";
    local beginLv = 1;
    local maxLevel = 2;
	local find = false;
    for i=0, cnt-1 do
        local class = GetClassByIndexFromList(clslist, i);
        if class ~= nil then
            if class.SkillName == className then
                maxLevel = class.MaxLevel;
				find = true;
                break;
            end
        end
    end

	if find == false then
		maxLevel = 1;
		curLv = 1;
	end
    if maxLevel < curLv then
        maxLevel = curLv
    end

    -- 1 ~ maxLevel caption cause to client down. use only two captions which you need
    if curLv ~= nil then
        if curLv == 0 then
            beginLv = 1;
        else
            beginLv = curLv;
        end

        if maxLevel >= beginLv + 1 then
            maxLevel = beginLv + 1;
        end
    end
        
    for i = beginLv, maxLevel do
        caption = caption .. "Lv."..i;
        caption = caption .. "," .. originCaption;
    end

    return caption;
 end

function SKILL_LV_DESC_TOOLTIP(frame, obj, totalLevel, lv, desc, ypos, dicidtext)       
    if totalLevel ~= lv and totalLevel + 1 ~= lv then        
        return ypos;
    end
    
    local lvDescCtrlSet = frame:CreateOrGetControlSet("skilllvdesc", "SKILL_CAPTION_"..tostring(lv), 0, ypos);
    tolua.cast(lvDescCtrlSet, "ui::CControlSet");
    
    -- user config
    local LEVEL_FONTNAME = lvDescCtrlSet:GetUserConfig("LEVEL_FONTNAME")
    local LEVEL_NEXTLV_FONTNAME = lvDescCtrlSet:GetUserConfig("LEVEL_NEXTLV_FONTNAME")
    local DESC_FONTNAME = lvDescCtrlSet:GetUserConfig("DESC_FONTNAME")
    local DESC_NEXTLV_FONTNAME = lvDescCtrlSet:GetUserConfig("DESC_NEXTLV_FONTNAME")

    local LABEL_SKIN_NAME = lvDescCtrlSet:GetUserConfig("LABEL_SKIN_NAME")
    local SKIN_NEXTLV_NAME = lvDescCtrlSet:GetUserConfig("SKIN_NEXTLV_NAME")
    local SP_ICON = lvDescCtrlSet:GetUserConfig("SP_ICON")
    local OVERHEAT_ICON = lvDescCtrlSet:GetUserConfig("OVERHEAT_ICON")

    local lvFont = LEVEL_FONTNAME
    local descFont = DESC_FONTNAME

    -- controls
    local lvText = lvDescCtrlSet:GetChild("level");
    local spText = lvDescCtrlSet:GetChild("sp_text");
    local overheatText = lvDescCtrlSet:GetChild("overheat_text");
    local coolText = lvDescCtrlSet:GetChild("cool_text");
    local padText = lvDescCtrlSet:GetChild("pad_text");
    local descText = GET_CHILD(lvDescCtrlSet, "desc", "ui::CRichText");

    -- data
    local coolTime = 0
    
    padText:ShowWindow(0) -- skill type is not documented yet. padText is not used currently
    descText:EnableSplitBySpace(0);
    
    if dicidtext ~= nil and dicidtext ~= "" then
        descText:SetDicIDText(dicidtext)
    end
    
    -- font and data setting
    local pub_frame = ui.GetFrame("pub_createchar");
    if pub_frame == nil or pub_frame:IsVisible() == 0 then
        if totalLevel == lv then
            lvDescCtrlSet:SetDraw(1);
            lvFont = LEVEL_FONTNAME
            descFont = DESC_FONTNAME
        else        
            lvDescCtrlSet:SetDraw(1);
            lvDescCtrlSet:SetSkinName(SKIN_NEXTLV_NAME);
            lvFont = LEVEL_NEXTLV_FONTNAME
            descFont = DESC_NEXTLV_FONTNAME
        end
    else
        lvDescCtrlSet:SetDraw(1);
        lvFont = LEVEL_FONTNAME;
        descFont = "{@st41b}{s16}";
    end
    
    if TryGetProp(obj, 'CoolDown') ~= nil then
        local tempObj = CreateGCIESByID("Skill", obj.ClassID);
        if tempObj ~= nil then
            tempObj.Level = lv;
        else
            tempObj = obj;
        end
        coolTime = tempObj.CoolDown * 0.001
        if coolTime == 0 then
            coolTime = tempObj.BasicCoolDown * 0.001
        end
    end

    local overHeat = 0;
    local sklProp = geSkillTable.Get(obj.ClassName);
    if sklProp ~= nil then
        overHeat = sklProp:GetOverHeatCnt();
    end

    if overHeat == 0 then
        if pub_frame == nil or pub_frame:IsVisible() == 0 then
            overHeat = GET_SKILL_OVERHEAT_COUNT(obj);
        else
            if obj ~= nil then
                overHeat = TryGetProp(obj, "SklUseOverHeat", 0);
            end

            if overHeat == 0 then
                overHeat = 1;
            end
        end
    end
  
    local sp = GET_SPENDSP_BY_LEVEL(obj, lv);
    local pc = GetMyPCObject();

    -- data setting
    lvText:SetText(lvFont.."Lv."..tostring(lv));
    spText:SetText(SP_ICON..lvFont.." "..math.floor(sp))
    spText:SetUserValue('SPEND_SP_VALUE', math.floor(sp));
    if coolTime == 0 then
        coolText:SetText(lvFont..ScpArgMsg("{Sec}","Sec", 0))        
    else
        coolText:SetText(lvFont..GET_TIME_TXT_TWO_FIGURES(coolTime))        
    end

    overheatText:SetText(OVERHEAT_ICON ..lvFont..ScpArgMsg("count{value}", "value", overHeat))
    
    -- trim desc    
    local trimedDesc = desc:match("^%s*(.+)");
    if trimedDesc ~= nil then
        local detect_comma = string.find(trimedDesc, ',');        
        if detect_comma ~= nil and detect_comma == 1 then
            trimedDesc = string.sub(trimedDesc, 2, string.len(trimedDesc))
        end
        descText:SetText(descFont..trimedDesc);
    end

    lvDescCtrlSet:SetGravity(ui.CENTER_HORZ, ui.TOP)
    lvDescCtrlSet:Resize(frame:GetWidth() - 20, descText:GetY() + descText:GetHeight() + 15);
    lvDescCtrlSet:ShowWindow(1);
    return ypos + lvDescCtrlSet:GetHeight(), lvDescCtrlSet
end

function SET_TOOLTIP_ZOMBIECAPSULE_DESC(obj)

    local retString = "";
    local keyWordIndex = 1;
    while 1 do
        local keyWord = TryGetProp(obj, GET_KEYWORD_PROP_NAME(keyWordIndex));
        if keyWord == nil or keyWord == "None" then
            break;
        end

        local monList = TokenizeByChar(keyWord, "@");
        for j = 1 , #monList do
            local monInfo = monList[j];
            local info = TokenizeByChar(monInfo, "#");
            local monType = info[1];
            local lv = info[2];
            local zombieType = tonumber(info[3]);
            local hp = info[4];
            
            if retString ~= "" then
                retString = retString .. "{nl}";
            end

            local monCls = GetClass("Monster", GET_SUMMON_ZOMBIE_NAME(zombieType));
            retString = retString  .. monCls.Name .. " (Lv." .. lv .. " , HP:" .. hp .. "%)";
        end
        
        keyWordIndex = keyWordIndex + 1;
    end
    
    return retString;
end

function ABILITY_DESC_TOOLTIP(frame, abilCls, index, ypos, pc, pcAbilIES)
    if abilCls == nil or TryGetProp(abilCls, 'Name') == nil or TryGetProp(abilCls, 'Desc') == nil then
        return
    end

    -- CONTROL SET
    local abilCtrlSet = frame:CreateOrGetControlSet('abilitydesc', "ABILITY_CAPTION_"..abilCls.ClassName, 0, ypos)
    tolua.cast(abilCtrlSet, "ui::CControlSet");

    -- USER CONFIG
    local NAME_FONTNAME = abilCtrlSet:GetUserConfig("NAME_FONTNAME")

    -- CONTROL
    local slot = GET_CHILD(abilCtrlSet, "icon_slot", "ui::CSlot")
    local level = abilCtrlSet:GetChild('abil_lv')
    local name = abilCtrlSet:GetChild('abil_name')
    local desc = abilCtrlSet:GetChild('abil_desc')
    local icon = CreateIcon(slot);  
    icon:SetImage(abilCls.Icon);

    if pcAbilIES == nil then
        icon:SetGrayStyle(1)
        level:SetText(NAME_FONTNAME..level:GetText())
    else
        level:SetText(NAME_FONTNAME.."Lv."..tostring(pcAbilIES.Level))
    end 
    
    name:SetText(NAME_FONTNAME..abilCls.Name)
    desc:SetText(abilCls.Desc)

    local amendSize = slot:GetHeight()
    if amendSize < desc:GetY() + desc:GetHeight() then
        amendSize = desc:GetY() + desc:GetHeight()
    end

    abilCtrlSet:Resize(frame:GetWidth(), amendSize + 10);
    return abilCtrlSet:GetY() + abilCtrlSet:GetHeight() + 10, pcAbilIES
end

function ADD_SPEND_SKILL_LV_DESC_TOOLTIP(ctrlSet, pcAbilList, pcAbilCnt)
    if pcAbilCnt < 1 then
        return
    end

    if TryGetProp(pcAbilList[0], 'AddSpend') == nil then
        return
    end

    local addValueSP = 0
    local addValueCoolTime = 0  
    local spText = ctrlSet:GetChild('sp_text')
    local coolText = ctrlSet:GetChild('cool_text')
    local ADD_ABILITY_STYLE = ctrlSet:GetUserConfig('ADD_ABILITY_STYLE')

    for i = 0, pcAbilCnt - 1 do
        local addSpendStr = pcAbilList[i].AddSpend
        if pcAbilList[i].ActiveState == 1 and addSpendStr ~= 'None' then
            local addSpendList = GET_ADD_SPEND_LIST(addSpendStr)

            for i = 0, #addSpendList, 2 do  -- AddSpendStr?? prop/value pair
                local addValueStr = addSpendList[i + 1]
                local addValue = tonumber(addValueStr)
        
                if addSpendList[i] == "SP" then
                    addValueSP = addValueSP + addSpendList[i + 1]
                end
                if addSpendList[i] == "CoolDown" then
                    addValueCoolTime = addValueCoolTime + addSpendList[i + 1]
                end
            end 
        end
    end

    if addValueSP ~= 0 then
        local spendSP = tonumber(spText:GetUserIValue('SPEND_SP_VALUE'));
        local totalAddValueSP = math.floor(spendSP + spendSP * (addValueSP / 100)) - spendSP;
        local addValueStr = tostring(totalAddValueSP);
        if totalAddValueSP > 0 then
            addValueStr = "+"..addValueStr
            spText:SetText(spText:GetText()..ADD_ABILITY_STYLE.."("..addValueStr..")")
        end
    end

    if addValueCoolTime ~= 0 then       
        local addValueStr = ""

        addValueCoolTime = addValueCoolTime * 0.001 -- unit ammend
        if addValueCoolTime > 0 then
            addValueStr = "+"..GET_TIME_TXT_TWO_FIGURES(addValueCoolTime)
        elseif addValueCoolTime < 0 then
            addValueStr = "-"..GET_TIME_TXT_TWO_FIGURES(-addValueCoolTime)
        end
        coolText:SetText(coolText:GetText()..ADD_ABILITY_STYLE.."("..addValueStr..")")
    end
end

function GET_ADD_SPEND_LIST(AddSpendStr)
    local tokList = {}
    local index = 0
    for word in string.gmatch(AddSpendStr, '([^/]+)') do
        tokList[index] = word
        index = index + 1
    end

    return tokList
end

function PVP_DESC_TOOLTIP(frame, ypos)

    local pvpCtrlSet = frame:CreateOrGetControlSet('pvpdesc', 'SKILL_CAPTION_PVP', 0, ypos)
    pvpCtrlSet:ShowWindow(1)

    return pvpCtrlSet:GetY() + pvpCtrlSet:GetHeight() + 10
end

function UPDATE_MON_SIMPLE_TOOLTIP(frame, monName)
    local monCls = GetClass("Monster", monName);
    local image = GET_CHILD(frame, "image");
    image:SetImage(GET_MON_ILLUST(monCls));

    local name = GET_CHILD(frame, "name");
    name:SetTextByKey("value", monCls.Name);

    local racetype = GET_CHILD(frame, "racetype");
    local racetypeText = ClMsg("RaceType") .. " {img " .. "Tribe_" .. monCls.RaceType .. " 32 32}";
    racetype:SetTextByKey("value", racetypeText);
    local attr = GET_CHILD(frame, "attr");
    local attrText = ClMsg("Attribute") .. " {img " .. "attri_" ..monCls.Attribute .. " 32 32}";
    attr:SetTextByKey("value", attrText);
    
    local t_desc = GET_CHILD(frame, "t_desc");
    t_desc:SetTextByKey("value", monCls.Desc);

    frame:Resize(frame:GetWidth(), t_desc:GetY() + t_desc:GetHeight() + 10);
end

local legend_raid_item_restrict = {
    'Scroll_SkillItem',
}

function UPDATE_RESTRICT_INFO_TOOLTIP(frame, mapKeyword, isLegendRaid)
    local titleBox = GET_CHILD_RECURSIVELY(frame, "titleBox");
    local INNER_X = frame:GetUserConfig("INNER_X");
    local INNER_Y = frame:GetUserConfig("INNER_Y");
    local ctrlsetWidth = frame:GetUserConfig("CTRLSET_WIDTH");

    local xpos = 0;
    local ypos = titleBox:GetHeight();
    local restrictList, cnt = GetClassList("SkillRestrict");
    for i = 0, cnt - 1 do
        local skillRestrict = GetClassByIndexFromList(restrictList, i);
        local keyword = TryGetProp(skillRestrict, "Keyword");
        
        if string.find(keyword, mapKeyword) ~= nil then
            local width, height = MAKE_RESTRICT_INFO(frame, skillRestrict, ypos + INNER_Y, ctrlsetWidth);
            xpos = math.max(xpos, width);
            ypos = height;
        end
    end

    if isLegendRaid == 1 then
        for i = 1, #legend_raid_item_restrict do
            local width, height = MAKE_ITEM_RESTRICT_INFO(frame, legend_raid_item_restrict[i], ypos + INNER_Y, ctrlsetWidth);
            xpos = math.max(xpos, width);
            ypos = height;
        end
    end

    frame:Resize(xpos + INNER_X, ypos + INNER_Y);
end

function MAKE_RESTRICT_INFO(frame, skillRestrict, ypos, ctrlSetWidth)
    local className = TryGetProp(skillRestrict, "ClassName");
    local skill = GetClass("Skill", TryGetProp(skillRestrict, "ClassName"));
    local imgName = TryGetProp(skill, "Icon");
    local ICON_SIZE = frame:GetUserConfig("ICON_SIZE");
    local img = string.format("{img %s %d %d}", "icon_"..imgName, ICON_SIZE, ICON_SIZE);
    local name = TryGetProp(skill, "Name");
    local caption = TryGetProp(skillRestrict, "Desc");

    local INNER_X = frame:GetUserConfig("INNER_X");
    local ctrlSet = frame:CreateOrGetControlSet("skill_restrict_info_list", "SKILL_RESTRICT_INFO_" .. className, INNER_X, ypos);
    local text = GET_CHILD_RECURSIVELY(ctrlSet, "skill_info");
    text:SetTextByKey("img", img);
    text:SetTextByKey("name", name);
    text:SetTextByKey("caption", caption);
    
    local textWidth = text:GetTextWidth();
    ctrlSet:Resize(textWidth, text:GetHeight());
    return textWidth, ypos + ctrlSet:GetHeight();
end

function MAKE_ITEM_RESTRICT_INFO(frame, clsName, ypos, strlSetWidth)
    local itemCls = GetClass("Item", clsName);
    local imgName = TryGetProp(itemCls, "Icon");
    local ICON_SIZE = frame:GetUserConfig("ICON_SIZE");
    local img = string.format("{img %s %d %d}", imgName, ICON_SIZE, ICON_SIZE);
    local name = TryGetProp(itemCls, "Name");
    local caption = ScpArgMsg("ImpossibleToUse");

    local INNER_X = frame:GetUserConfig("INNER_X");
    local ctrlSet = frame:CreateOrGetControlSet("skill_restrict_info_list", "SKILL_RESTRICT_INFO_" .. clsName, INNER_X, ypos);
    local text = GET_CHILD_RECURSIVELY(ctrlSet, "skill_info");
    text:SetTextByKey("img", img);
    text:SetTextByKey("name", name);
    text:SetTextByKey("caption", caption);
    
    local textWidth = text:GetTextWidth();
    ctrlSet:Resize(textWidth, text:GetHeight());
    return textWidth, ypos + ctrlSet:GetHeight();
end