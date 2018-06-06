function FIRST_RANDOM_OPTION_ITEM(pc, item, skill)

    local randomOptionClass, randomOptionCnt = GetClassList('item_random')
    
    
    local SkillRatio = 1;
    if skill ~= nil then
       SkillRatio = SkillRatio + (skill.Level * 0.01);
    end
    
    --OptionCnt--
    local optionCnt = 0;
    local checkRatio = IMCRandom(1,10000)

    local itemGrade = TryGetProp(item, "ItemGrade")
    
    if itemGrade == nil then
        return;
    end
    
    local gradeOptionCnt = {0,4,3,2}
    local gradeCnt = gradeOptionCnt[itemGrade]

    if gradeCnt <= 0 then
        return;
    end

    for i = 0, 3 do
        local optionCntRatio = math.floor(100/(gradeCnt^i)*100 * SkillRatio);
        if optionCntRatio >= checkRatio then
            optionCnt = optionCnt + 1;
        end
    end

    -- DBLHand True/False Check -- 
    local dblHand = TryGetProp(item, "DBLHand")
    
    if dblHand == nil then
        return;
    end
    
    -- DBLHand Add OptionCnt +2 -- 
    if dblHand ~= nil and dblHand == 'YES' then
        optionCnt = optionCnt + 2
    end
    
    --group select--
    local groupList = {};
    local equipGroup = TryGetProp(item, 'EquipGroup');
    local itemClassType = TryGetProp(item, 'ClassType');
  
    if equipGroup == nil or itemClassType == nil then
        return;
    end
    
    --equipGroup  Option Group List Select -- 
    if equipGroup == 'Weapon' or equipGroup == 'THWeapon' or (equipGroup == 'SubWeapon' and itemClassType ~= 'Shield') then
        groupList = {'ATK','STAT','UTIL_WEAPON'};    
    elseif equipGroup == 'SHIRT' or equipGroup == 'PANTS' or equipGroup == 'BOOTS' or equipGroup == 'GLOVES' then
        groupList = {'DEF','STAT','UTIL_ARMOR'};
    elseif  itemClassType == 'Shield' then
        groupList = {'DEF','STAT','UTIL_SHILED'};
    else
        return;
    end
    
    -- Option Group select --
    local itemGroupList = {};
    local groupCount = {};
    local atrributeGroup = ITEM_RANDOME_OPTION_GROUP_FILTER(randomOptionClass, randomOptionCnt, groupList);
    
    if atrributeGroup == nil then
        return
    end
    
    for i = 1 , optionCnt do
        local groupRatio = IMCRandom(1,#groupList)
        itemGroupList[i] = groupList[groupRatio]
        for j = 1, #groupList do
            if itemGroupList[i] == groupList[j] then
                if groupCount[j] == nil then
                    groupCount[j] = 0;
                end
                groupCount[j] = groupCount[j] + 1
                
                if groupCount[j] >= #atrributeGroup[groupList[j]] then
                    table.remove(groupList, j)
                end
            end
        end
    end

        
    --option name select--
    
    local optionNameList = {}
    local optionIndex = 0
    for i = 1, optionCnt do
      optionNameList[i] = SELECT_RANDOM_OPTION_NAME(randomOptionClass, randomOptionCnt, atrributeGroup[itemGroupList[i]] , itemGroupList[i] )
      if optionNameList[i] == nil then
        return
      end
  
      for j = 1, #atrributeGroup[itemGroupList[i]] do
        if atrributeGroup[itemGroupList[i]][j] == optionNameList[i] then
            optionIndex = j;
            break;
        end
      end
      table.remove(atrributeGroup[itemGroupList[i]], optionIndex)
    end

    
    --option state select--
    local optionStateList = {};
    
    for i = 1 , optionCnt do
        for j = 0, randomOptionCnt - 1 do
            local itemRandomOptionList = GetClassByIndexFromList(randomOptionClass, j)
            local optionNameCheckList = TryGetProp(itemRandomOptionList, "OptionName")
            if optionNameCheckList == nil then
                return ;
            end
            
            local optionStat = TryGetProp(itemRandomOptionList, "OptionValue")
            if optionStat == nil then
                return ;
            end
            local groupCheck = TryGetProp(itemRandomOptionList, "Group");
            
            if optionNameList[i] == optionNameCheckList and groupCheck == itemGroupList[i] then
                local optionValue = optionStat
                local scp = _G[optionValue]
                if scp ~= nil then
                    optionStateList[i] = scp(item)
                end
            end
        end
    end
    
    return itemGroupList, optionNameList, optionCnt, optionStateList
    
end

function SELECT_RANDOM_OPTION_NAME(randomOptionClass, randomOptionCnt, atrributeGroup, groupName)
    local ratioList = {}
    local totalRatio = 0;
    
    for i = 0 , randomOptionCnt-1 do
        local randomOptionClass = GetClassByIndexFromList(randomOptionClass, i)
        local optionName = TryGetProp(randomOptionClass, "OptionName")
        local groupCheck = TryGetProp(randomOptionClass, "Group")
        
        if groupCheck == groupName then
            for j = 1, #atrributeGroup do
                if atrributeGroup[j] == optionName then
                    local groupReward = {}
                    local optionRatio = TryGetProp(randomOptionClass, "Ratio")
                    groupReward[1] = optionName
                    groupReward[2] = totalRatio + optionRatio
                    totalRatio = totalRatio + optionRatio
                    ratioList[#ratioList + 1] = groupReward;
                end
            end
        end
    end
    local ratio = IMCRandom(1, totalRatio)
    local optionName
    for i = 1, #atrributeGroup do
        if ratioList[i][2] >= ratio then
            optionName = ratioList[i][1];
            break;
        end
    end
    
    return optionName
end

function ITEM_RANDOME_OPTION_GROUP_FILTER(randomOptionClass, randomOptionCnt, groupList)
    
    local atrributeGroup = {};
    
    for i = 1, #groupList do
        local group = { };
        for j = 0, randomOptionCnt - 1 do 
            local groupCheckList = GetClassByIndexFromList(randomOptionClass, j)
            local groupCkeck = TryGetProp(groupCheckList, "Group")
            
            if groupCkeck == nil then
                return;
            end
            
            local groupOptionName = TryGetProp(groupCheckList, "OptionName")
            if groupOptionName == nil then
                return;
            end
            if groupList[i] == groupCkeck then
                group[#group + 1] = groupOptionName;
            end
        end
        atrributeGroup[groupList[i]] = group;
       
    end
    return atrributeGroup;
end

-- RandomOptionLog --

function SCR_RANDOM_SETIESPROP_LOG(itemList)
    local wrongItemList = {}; -- 잘못된 아이템 정보를 넣을 리스트
    local randomOptCls, clsCnt = GetClassList('item_random')
    
    for i = 1, #itemList do -- itemList: 감정대상이었던 리스트(랜덤옵션 아이템 리스트)
        local item = itemList[i];
        local checkItemTable = {}; -- 정보를 넣기 위한 구조체
        checkItemTable['Item'] = item;
        local searchErr = 0;  -- 에러 감지용 플래그. 문제 발생하면 1
        for j = 1, 6 do
            local errorIndexFound = 0;

            -- 원래 넣으려고 했던 랜덤옵션 기댓값, 어떤 그룹, 옵션, 수치
            local randomOptGroup = GetExProp_Str(item, 'RandomOptionGroup_'..j);
            local randomOptName =  GetExProp_Str(item, 'RandomOption_'..j);
            local randomOptValue = GetExProp(item, 'RandomOptionValue_'..j);
            
            -- 실제 부여된 랜덤옵션 값
            local compareOptGroup = TryGetProp(item, 'RandomOptionGroup_'..j, 'None');            
            local compareOptName = TryGetProp(item, 'RandomOption_'..j, 'None');
            local compareOptValue =  TryGetProp(item, 'RandomOptionValue_'..j, 0);

           -- print(j,"ITEM", item.Name, "GroupName:", compareOptGroup, "OptName:", compareOptName, "OptValue:", compareOptValue)
            
            -- 저장 됐어야할 값과 현재 값 비교 현재값:compareOpt~~ --
            if randomOptGroup ~= compareOptGroup then
                checkItemTable['ErrGroup_'..j] = randomOptGroup
                searchErr = 1;
                errorIndexFound = 1;
            end
            
            if randomOptName ~= compareOptName then
                checkItemTable['ErrName_'..j] = randomOptName
                searchErr = 1;
                errorIndexFound = 1;
            end
            
            if compareOptValue ~= 0 then
            --저장된 값이 잘못 된 경우 검사 --
                for k = 0, clsCnt-1 do
                    local itemRandomOptList = GetClassByIndexFromList(randomOptCls, k)
                    local optNameCheckList = TryGetProp(itemRandomOptList, "OptionName")
                    local optionStat = TryGetProp(itemRandomOptList, "OptionValue")
                    
                    if compareOptName == optNameCheckList then -- 원래 부여되기로 했던 옵션 이름과 체크할 이름이 같으면
                        local optionValue = optionStat
                        local scp = _G[optionValue]
                        if scp ~= nil then
                            local checkOptValue, min , max = scp(item)
                            if compareOptValue < min or compareOptValue > max then -- out of range
                                checkItemTable['ErrRange_'..j] = compareOptValue
                                searchErr = 1;
                                errorIndexFound = 1;
                            end
                        end
                    end
                end
            end
            
            if randomOptValue ~= compareOptValue then
                checkItemTable['ErrValue_'..j] = randomOptValue
                searchErr = 1;
                errorIndexFound = 1;
            end

            if errorIndexFound == 1 then
                checkItemTable['ErrOption_'..j] = 'YES';
            end
        end
        
        if searchErr == 1 then
            wrongItemList[#wrongItemList + 1] = checkItemTable;
        end
    end
    
    -- 잘 들어갔는지 확인용
--    if wrongItemList ~= nil and #wrongItemList >= 1 then
--        local errList = { 'Item', 'ErrGroup_', 'ErrName_', 'ErrRange_', 'ErrValue_' };
--        for i = 1, #wrongItemList do
--            print(wrongItemList[i][errList[1]])
--           for j = 1, 6 do
--                for k = 2, #errList do
--                    if wrongItemList[i][errList[k]..j] ~= nil then
--                        print(errList[k]..j .. ' : ' .. wrongItemList[i][errList[k]..j])
--                    end
--                end
--            end
--            
--            print('------------------------------------------------------')
--        end
--    end
        
    return wrongItemList;
end


--Option Calc--

function SCR_RANDOM_STAT_CALC(item)
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    
    local itemEquipGroup = TryGetProp(item, 'EquipGroup');
    if itemEquipGroup == nil then
        return;
    end
    
    local itemClassType = TryGetProp(item, 'ClassType');
    if itemClassType == nil then
        return;
    end
    
    local dblHand = TryGetProp(item, 'DBLHand')
    local handRatio = 1;
    if dblHand ~= nil and  dblHand == 'YES' then
        handRatio = 1.2
    end
        
    local maxEquipGroupRatio = 0;
    
    if itemEquipGroup == 'Weapon' or itemEquipGroup == 'THWeapon' or (itemEquipGroup == 'SubWeapon' and itemClassType ~='Shield') then
        maxEquipGroupRatio = 1.8;
    elseif itemEquipGroup == 'SHIRT' or itemEquipGroup == 'PANTS' or itemEquipGroup == 'BOOTS' or itemEquipGroup == 'GLOVES' or itemClassType == 'Shield' then
        maxEquipGroupRatio = 1.2;
    else
        return;
    end
    
    local tempStat = SyncFloor(((itemLv / 30) + (itemLv/(50/itemGrade)))*handRatio)
    
    
    local maxStat = SyncFloor(tempStat * maxEquipGroupRatio);
    local minStat = SyncFloor(maxStat * 0.25)
    
    local finalStat = IMCRandom(minStat, maxStat);
    
    return finalStat, minStat, maxStat;    
end

--mdef / def same calc--
function SCR_RANDOM_DEF_CALC(item)
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    
    local tempDef = 20 + SyncFloor((itemLv * 3) * 0.25 * itemGrade/3 ) ;
    
   
    local maxDef = SyncFloor(tempDef * 0.9);
    local minDef = SyncFloor(maxDef * 0.25);
    
    local finalDef = IMCRandom(minDef, maxDef)
    
    return finalDef, minDef, maxDef
    
end

function SCR_RANDOM_SEPCIAL_DEF_CALC(item)
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    
    local tempDef = 20 + SyncFloor( (itemLv * 3) * 0.25 * itemGrade/3 ) ;
    
    local maxDef = SyncFloor(tempDef * 1.17);
    local minDef = SyncFloor(maxDef * 0.25);
    
    local finalDef = IMCRandom(minDef, maxDef)
    
    return finalDef, minDef, maxDef
    
end

function SCR_RANDOM_ATTRIBUTE_RES_CALC(item)
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    
    local tempAttributeRes = 50 + SyncFloor( (itemLv / 5) * 3.5 * itemGrade/3 ) ;
    
    local maxRes = SyncFloor(tempAttributeRes * 0.15);
    local minRes = SyncFloor(maxRes * 0.25);
    
    local finalRes = IMCRandom(minRes, maxRes)
    
    return finalRes, minRes, maxRes;
    
end

function SCR_RANDOM_CRI_CALC(item)
 -- CRTHR --
 
    local itemEquipGroup = TryGetProp(item, 'EquipGroup');
    if itemEquipGroup == nil then
        return;
    end
    
    local itemClassType = TryGetProp(item, 'ClassType');
    if itemClassType == nil then
        return;
    end
    
    local max = 0;
    if itemEquipGroup == 'Weapon' or itemEquipGroup == 'THWeapon' or (itemEquipGroup == 'SubWeapon' and itemClassType ~='Shield') then
        max = 30;
    elseif itemEquipGroup == 'SHIRT' or itemEquipGroup == 'PANTS' or itemEquipGroup == 'BOOTS' or itemEquipGroup == 'GLOVES' or itemClassType == 'Shield' then
        max = 20;
    else
        return;
    end
    
    local min = SyncFloor(max/4)
    
    local finalStatus = IMCRandom(min, max)
    
    return finalStatus, min, max;
end

function SCR_RANDOM_CRI_DR_CALC(item)
 --CRTDR--
    local max = 30;
    
    local min = SyncFloor(max/4)
    
    local finalStatus = IMCRandom(min, max)
    
    return finalStatus, min, max;
end

function SCR_RANDOM_BLK_CLAC(item)
     --blk , blk_break --
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    
    local temp = 5 + SyncFloor( (itemLv/25) * ( itemGrade/3) )
    
    
    local max = SyncFloor(temp * 3)
    local min = SyncFloor(max * 0.25)
    local finalStatus = IMCRandom(min, max)
    
    return finalStatus, min, max;
    
end

function SCR_RANDOM_HDR_CALC(item)
    --HR , DR --
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    local temp = SyncFloor(5 + ((itemLv/25) * itemGrade/3))
    
    local max = SyncFloor(temp * 3);
    local min = SyncFloor(max * 0.25);
    local finalStatus = IMCRandom(min, max)
    
    return finalStatus, min, max;
end

function SCR_RANDOM_MSP_CALC(item)
    -- MSP/MHP -- 
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    local temp = SyncFloor(( 3.5 * (itemLv / 5) ) * itemGrade/3)
    
    local max = SyncFloor(temp * 1.8);
    local min = SyncFloor(max * 0.25);
    
    local finalStatus = IMCRandom(min, max)
    
    return finalStatus, min, max;
end

function SCR_RANDOM_MHP_CALC(item)
    -- MSP/MHP -- 
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    local temp = SyncFloor(( 3.5 * (itemLv / 5) ) * itemGrade)
    
    local max = SyncFloor(temp * 1.8);
    local min = SyncFloor(max * 0.25);
    
    local finalStatus = IMCRandom(min, max)
    
    return finalStatus, min, max;
end

function SCR_RANDOM_MSTA_CALC(item)
    -- MSTA --
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    
    local max = SyncFloor( 15 * itemGrade/3)
    local min = SyncFloor( max * 0.25 )
    local finalStatus = IMCRandom(min, max)
    
    return finalStatus, min, max;
end

function SCR_RANDOM_RSHP_CALC(item)
    -- RSP/RHP -- 
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    local temp = SyncFloor(itemLv/10 * itemGrade/3)
    
    local max = temp
    local min = SyncFloor(max/4)
    
    local finalRestore = IMCRandom(min, max)
    
    return finalRestore, min, max;
end

function SCR_RANDOM_ATK_CALC(item)
    
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local dblHand = TryGetProp(item, "DBLHand")
    
    if dblHand == nil then
        return;
    end
    
    local handRatio = 1;
    
    if dblHand ~= nil and dblHand == 'YES' then
        handRatio = 1.2;
    end
    
    local gradRatio = {0.9, 1, 1.1, 1.25, 1.4}
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    
    local basicAtk = 20 + SyncFloor((itemLv * 3) * handRatio * gradRatio[itemGrade])
    
    
    local max = SyncFloor(basicAtk * 0.132);
    local min = SyncFloor(max * 0.25);
    
    local finalAtk = IMCRandom(min, max)
    
    return finalAtk, min, max;
end

function SCR_RANDOM_MHR_CALC(item)
    
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local hand = TryGetProp(item, "DBLHand")
    
    if hand == nil then
        return;
    end
    
    local handRatio = 1;
    
    if hand ~= nil and hand == 'YES' then
        handRatio = 1.2;
    end
    
    local gradRatio = {0.9, 1, 1.1, 1.25, 1.4}
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    
    local basicMatk = 20 + SyncFloor((itemLv * 3) * handRatio * gradRatio[itemGrade])
    
    
    local max = SyncFloor(basicMatk * 0.405);
    local min = SyncFloor( max * 0.25 );
    
    local finalMhr = IMCRandom(min, max)
    return finalMhr, min, max;
end

function SCR_RANDOM_CRIATK_CALC(item)
    
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local hand = TryGetProp(item, "DBLHand")
    
    if hand == nil then
        return;
    end
    
    local handRatio = 1;
    
    if hand ~= nil and hand == 'YES' then
        handRatio = 1.2;
    end
    
    local gradRatio = {0.9, 1, 1.1, 1.25, 1.4}
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    
    local basicAtk = 20 + SyncFloor((itemLv * 3) * handRatio * gradRatio[itemGrade])
    
    
    local max = SyncFloor(basicAtk * 0.1651);
    local min = SyncFloor(max * 0.25);
    
    local finalCriAtk = IMCRandom(min, max)
    
    return finalCriAtk, min, max;
end

function SCR_RANDOM_DEF_TYPE_ATK_CALC(item)
    
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local hand = TryGetProp(item, "DBLHand")
    
    if hand == nil then
        return;
    end
    
    local handRatio = 1;
    
    if hand ~= nil and hand == 'YES' then
        handRatio = 1.2;
    end
    
    local gradRatio = {0.9, 1, 1.1, 1.25, 1.4}
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    
    local basicAtk = 20 + SyncFloor((itemLv * 3) * handRatio * gradRatio[itemGrade])
    
    
    local max = SyncFloor(basicAtk * 0.1651);
    local min = SyncFloor(max * 0.25);
    
    local finalCriAtk = IMCRandom(min, max)
    
    return finalCriAtk, min, max;
end

function SCR_RANDOM_SIZE_TYPE_ATK_CALC(item)
    
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local hand = TryGetProp(item, "DBLHand")
    
    if hand == nil then
        return;
    end
    
    local handRatio = 1;
    
    if hand ~= nil and hand == 'YES' then
        handRatio = 1.2;
    end
    
    local gradRatio = {0.9, 1, 1.1, 1.25, 1.4}
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    
    local basicAtk = 20 + SyncFloor((itemLv * 3) * handRatio * gradRatio[itemGrade])
    
    
    local max = SyncFloor(basicAtk * 0.1651);
    local min = SyncFloor(max * 0.25);
    
    local finalCriAtk = IMCRandom(min, max)
    
    return finalCriAtk, min, max;
end

function SCR_RANDOM_ATTRIBUTE_ATK_CALC(item)
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local itemGrade = TryGetProp(item,"ItemGrade")
    if itemGrade == nil then
        return;
    end
    
    local basicAtk = 50 +  SyncFloor((itemLv/5) * 3.5 * itemGrade/3)
    
    local max = SyncFloor(basicAtk * 0.6)
    local min = SyncFloor(max * 0.25)
    
    local attributeAtk = IMCRandom(min, max)
    
    return attributeAtk, min, max;
end

function SCR_RANDOM_SPECIAL_ATK_TRIBE_CALC(item)
    
    local itemLv = TryGetProp(item, "UseLv")
    if itemLv == nil then
        return;
    end
    
    local dblHand = TryGetProp(item, "DBLHand")
    
    if dblHand == nil then
        return;
    end
    
    local handRatio = 1;
    
    if dblHand ~= nil and dblHand == 'YES' then
        handRatio = 1.2;
    end
    
    local gradRatio = {0.9, 1, 1.1, 1.25, 1.4}
    
    local itemGrade = TryGetProp(item, "ItemGrade")
    if itemGrade == nil then
        return;
    end
    
    local basicAtk = 20 + SyncFloor((itemLv * 3) * handRatio * gradRatio[itemGrade])
    
    local max = SyncFloor(basicAtk * 0.2475);
    local min = SyncFloor(max * 0.25);
    
    local finalSpecialAtk = IMCRandom(min, max)
    
    return finalSpecialAtk, min, max;
end

function SCR_RANDOM_LOOTINGCHANCE_CALC(item)
    local finalStatus = 0;
    
    for i = 1, 2 do
        local temp = IMCRandom(i - 1, 63)
        finalStatus = finalStatus + temp;
    end
    
    return finalStatus, 0 , 126;
end

function IS_APPLIED_VALID_RANDOM_OPTION(item, guidStr, category)
    if item == nil then
        return false;
    end

    local maxRandomOptionCnt = 6;
    for j = 1, maxRandomOptionCnt do                
        local randomOptCls, clsCnt = GetClassList('item_random');
        for k = 0, clsCnt - 1 do
            local itemRandomOptList = GetClassByIndexFromList(randomOptCls, k);
            local optNameCheckList = TryGetProp(itemRandomOptList, "OptionName")
            local optionStat = TryGetProp(itemRandomOptList, "OptionValue")
            
            local randomOption = TryGetProp(item, 'RandomOption_'..j, 'None');
            if randomOption == optNameCheckList then                
                local compareOptValue = item['RandomOptionValue_'..j];                
                local optionValue = optionStat
                local scp = _G[optionValue]
                if scp ~= nil then                    
                    local checkOptValue, min , max = scp(item);                                                            
                    if compareOptValue < min or compareOptValue > max then -- out of range

                        if guidStr ~= nil then -- 캐비넷 등에서 검사할 때에는 인벤토리에 아이템이 없어서 GetItemGuid 함수를 사용할 수가 없음
                            IMC_LOG('ERROR_RANDOM_OPTION', 'InvalidRandomOption: category['..category..'], item['..guidStr..'], option['..randomOption..'], value['..compareOptValue..'], min['..min..'], max['..max..']');
                        end

                        return false, randomOption, compareOptValue, min, max;
                    end
                end
            end
        end
    end
    return true;
end

-- 인벤토리 검사 해서 전체 랜덤옵션 확인용
function TEST_CHECK_RANDOM_OPTION_INVENTORY(pc)
    local invList = GetInvItemList(pc);
    if invList == nil or #invList < 1 then
        Chat(pc, '텅빈 인벤토리에요');
        return;
    end

    Chat(pc, '랜덤옵션 검사 시작: 아이템 개수['..#invList..']')
    for i = 1 , #invList do
        local invItem = invList[i];
        local baseCls = GetClass('Item', invItem.ClassName);
        if baseCls.ItemType == 'Equip' and TryGetProp(baseCls, 'NeedRandomOption', 0) == 1 then
            local ret, optionName, optionValue, normalMin, normalMax = IS_APPLIED_VALID_RANDOM_OPTION(invItem);            
            if ret == false then
                local chatStr = 'Find Error RandomOption Item! idx['..GetItemGuid(invItem)..'], name['..invItem.ClassName..']';
                if optionName ~= nil then
                    chatStr = chatStr..', option['..optionName..'], value['..optionValue..'], range['..normalMin..'~'..normalMax..']';
                end
                Chat(pc, chatStr);
                return;
            end
        end
    end
    Chat(pc, '랜덤옵션 이상무');
end