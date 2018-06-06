-- ADVENTURE_BOOK_shared.lua

W_PTS_ACHIEVE = 10;
W_PTS_QUEST = 5;
BOSS_MON_KILL_COUNT_GRADE3 = 80;
BOSS_MON_KILL_COUNT_GRADE2 = 30;
BOSS_MON_KILL_COUNT_GRADE1 = 10;
BASIC_MON_KILL_COUNT_GRADE3 = 4;
BASIC_MON_KILL_COUNT_GRADE2 = 2;
BASIC_MON_KILL_COUNT_GRADE1 = 1;
GET_ITEM_GRADE1 = 1
GET_ITEM_GRADE2 = 10
GET_ITEM_GRADE2 = 30
GET_EQUIP_ITEM_GRADE1 = 1
GET_EQUIP_ITEM_GRADE1 = 1

--ADVENTURE_BOOK monster score
function GET_ADVENTURE_BOOK_MONSTER_POINT(pc)
    local adv_mon_point = 0
    local boss_point = 0
    local basic_point = 0
    
    local monIDList = GetAdventureBookMonList(pc);
    if monIDList == nil then
        return adv_mon_point;
    end
    
--    print("모험일지에 등록된 몬스터 수: ", #monIDList);
    for i = 1, #monIDList do
        local monKillCount = GetMonKillCount(pc, monIDList[i]);
        local monCls = GetClassByType('Monster', monIDList[i]);
        if monCls ~= nil then
            if monCls.MonRank == "Boss" then
        		local boss_point, maxPoint, section = _GET_ADVENTURE_BOOK_MONSTER_POINT(true, monKillCount);
        		adv_mon_point = adv_mon_point+ boss_point
        	else
        		local basic_point, maxPoint, section = _GET_ADVENTURE_BOOK_MONSTER_POINT(false, monKillCount);
        	    adv_mon_point = adv_mon_point+ basic_point
        	end
--            print("-- 몬스터 이름: ", monCls.ClassName);
--            print("-- 킬카운트: ", monKillCount);
        end
    end
    --print("몬스터 점수 : "..adv_mon_point);
    return adv_mon_point;
end

function _GET_ADVENTURE_BOOK_MONSTER_POINT(isBoss, monKillCount)
    local point = 0;
    local maxPoint = 0;
    local section = 0;
    if isBoss == true then
        if monKillCount >= 4 then --BOSS_MON_KILL_COUNT_GRADE3
        	point = 60
            section = 3;
        elseif monKillCount >= 2 then --BOSS_MON_KILL_COUNT_GRADE2
        	point = 20
            section = 2;
        elseif monKillCount >= 1 then --BOSS_MON_KILL_COUNT_GRADE1
        	point = 5
            section = 1;
        else
        	point = 0
        end
        maxPoint = 60;
    else
        if monKillCount >= 80 then --BASIC_MON_KILL_COUNT_GRADE3
        	point = 50
            section = 3;
        elseif monKillCount >= 30 then --BASIC_MON_KILL_COUNT_GRADE2
        	point = 20
            section = 2; 
        elseif monKillCount >= 10 then --BASIC_MON_KILL_COUNT_GRADE1
        	point = 5
            section = 1;
        else
        	point = 0
        end
        maxPoint = 50;
    end
    return point, maxPoint, section;
end

--ADVENTURE_BOOK item score
function GET_ADVENTURE_BOOK_ITEM_POINT(pc)
    local adv_item_point = 0
    
    local idList = GetAdventureBookItemCountableList(pc);
    if idList == nil then
        return adv_item_point;
    end
--    print("모험일지에 등록된 초기화대상 아이템 수: ", #idList);
    for i = 1, #idList do
        local itemObtainCount = GetItemObtainCount(pc, idList[i]);
        local cls = GetClassByType('Item', idList[i]);
        if cls ~= nil then
            if cls.ItemType == "Equip" then
        		local equip_item_point, maxPoint, section = _GET_ADVENTURE_BOOK_POINT_ITEM(true, itemObtainCount);
        		adv_item_point = adv_item_point + equip_item_point
        	else
        	    local basic_point, maxPoint, section = _GET_ADVENTURE_BOOK_POINT_ITEM(false, itemObtainCount);        		
        		adv_item_point = adv_item_point + basic_point
        	end
--            print("-- 아이템 이름: ", cls.Name.." "..cls.ClassName);
--            print("-- 획득 횟수: ", itemObtainCount);
--            print("-- 소비 횟수: ", itemConsumeCount);
        end
    end
    --print("아이템 획득 점수 : "..adv_item_point);
    return adv_item_point
end

function _GET_ADVENTURE_BOOK_POINT_ITEM(isEquip, itemObtainCount)
    local point = 0;
    local maxPoint = 0;
    local section = 0;
    if isEquip == true then
        if itemObtainCount >= 1 then --GET_EQUIP_ITEM_GRADE1
        	point = 20;
            section = 1;
        end
        maxPoint = 20;
    else
        if itemObtainCount >= 30 then --GET_ITEM_GRADE3
        	point = 50
            section = 3;
        elseif itemObtainCount >= 10 then --GET_ITEM_GRADE2
        	point = 20
            section = 2;
        elseif itemObtainCount >= 1 then --GET_ITEM_GRADE1
        	point = 5
            section = 1;
        end
        maxPoint = 50;
    end
    return point, maxPoint, section;
end

--ADVENTURE_BOOK ITEM CONSUME score
function GET_ITEM_CONSUME_POINT(pc)
    local consume_Cnt = 0
    
    local idList = GetAdventureBookItemCountableList(pc);
    if idList == nil then
        return consume_Cnt;
    end
--    print("모험일지에 등록된 초기화대상 아이템 수: ", #idList);
    for i = 1, #idList do
        local itemConsumeCount = GetItemConsumeCount(pc, idList[i]);
        local cls = GetClassByType('Item', idList[i]);
        if cls ~= nil then
            if cls.ItemType == "Consume" then
                if cls.GroupName == "Drug" then
--                    print("-- 아이템 이름: ", cls.ClassName);
--                    print("-- 소비 횟수: ", itemConsumeCount);
                    consume_Cnt = consume_Cnt + itemConsumeCount
                end
            end
        end
    end
    --print("아이템 소비 점수 : "..consume_Cnt)
    return consume_Cnt
end

--ADVENTURE_BOOK RECIPE score
function GET_ADVENTURE_BOOK_RECIPE_POINT(pc)
    local adv_recipe_point = 0
    local a = 0
    
    local idList = GetAdventureBookCraftList(pc);
    if idList == nil then
        return adv_recipe_point;
    end
--    print("모험일지에 등록된 제작 아이템 수: ", #idList);
    for i = 1, #idList do
        local craftCount = GetCraftCount(pc, idList[i]);
        local cls = GetClassByType('Item', idList[i]);
        local creft_point = 0
        if cls ~= nil then
            creft_point, maxPoint, section = _GET_ADVENTURE_BOOK_CRAFT_POINT(craftCount);
            --print("-- 아이템 이름: ", cls.ClassName.." "..cls.Name);
            --print("-- 제작 횟수: ", craftCount);
        end
        adv_recipe_point = adv_recipe_point + creft_point
    end
    --print("제작 점수: ", adv_recipe_point);
    return adv_recipe_point
end

function _GET_ADVENTURE_BOOK_CRAFT_POINT(craftCount)
    local point, maxPoint = 0, 0;
    local section = 0;
    if craftCount >= 1 then --GET_EQUIP_ITEM_GRADE1
        point = 30;
        section = 1;
    end
    maxPoint = 30;
    return point, maxPoint, section;
end

--ADVENTURE_BOOK SHOP score
function GET_ADVENTURE_BOOK_SHOP_POINT(pc)
    local adv_vis_point = 0
    local earnig_Money = 0
    
    local idList = GetAdventureBookAutoSellerList(pc);
    if idList == nil then
        return adv_vis_point;
    end
--    print("모험일지에 등록된 개인 상점 수: ", #idList);
    for i = 1, #idList do
        local earningPay = GetEarningPay(pc, idList[i]);
        local skl = GetClassByType('Skill', idList[i]);
        local money = 0
        if skl.ClassName == "Pardoner_SpellShop" then
            money = earningPay
            --print("--- 개인상점: 버프상점: "..money);
        elseif skl.ClassName == "Squire_Repair" then
            money = earningPay
            --print("--- 개인상점: 리페어 상점: "..money);
        elseif skl.ClassName == "Squire_ArmorTouchUp" then
            money = earningPay
            --print("--- 개인상점: 방어구 손질 상점: "..money);
        elseif skl.ClassName == "Squire_WeaponTouchUp" then
            money = earningPay
            --print("--- 개인상점: 무기 손질 상점: "..money);
        elseif skl.ClassName == "Alchemist_Roasting" then
            money = earningPay
            --print("--- 개인상점: 젬로스팅: "..money);
        elseif skl.ClassName == "Oracle_SwitchGender" then
            money = earningPay
            --print("--- 개인상점: 스위치젠더: "..money);
        elseif skl.ClassName == "Enchanter_EnchantArmor" then
            money = earningPay
            --print("--- 개인상점: 인챈트아머: "..money);
        elseif skl.ClassName == "Appraiser_Apprise" then
            money = earningPay
            --print("--- 개인상점: 감정: "..money);  
        elseif skl.ClassName == "Sage_Portal" then
            money = earningPay
            --print("--- 개인상점: 포탈상점: "..money);  
        end
        earnig_Money = earnig_Money + money
        --print("--- 벌어들인 돈: ", earnig_Money);
    end
    
    local section = 0;
    if earnig_Money > 0 and earnig_Money <= 100000 then
       adv_vis_point = (earnig_Money * 1)/10000
       section = 1;
    elseif earnig_Money > 100000 and earnig_Money <= 1000000 then
        adv_vis_point = (((earnig_Money - 100000)*0.9) + (100000 * 1))/10000
        section = 2;
    elseif earnig_Money > 100000 and earnig_Money <= 5000000 then
        adv_vis_point = (((earnig_Money - 1000000)*0.7) + (900000*0.9) + (100000 * 1))/10000
        section = 3;
    elseif earnig_Money > 5000000 and earnig_Money <= 10000000 then
        adv_vis_point = (((earnig_Money - 5000000)*0.5) + (4000000 *0.7) + (900000*0.9) + (100000 * 1))/10000
        section = 4;
    elseif earnig_Money > 10000000 and earnig_Money <= 50000000 then
        adv_vis_point = (((earnig_Money - 10000000)*0.3) + (5000000*0.5) + (4000000 *0.7) + (900000*0.9) + (100000 * 1))/10000
        section = 5;
    elseif earnig_Money > 50000000 and earnig_Money <= 100000000 then
        adv_vis_point = (((earnig_Money - 50000000)*0.1) + (40000000*0.3) + (5000000*0.5) + (4000000 *0.7) + (900000*0.9) + (100000 * 1))/10000
        section = 6;
    elseif earnig_Money > 100000000 then
        adv_vis_point = (((earnig_Money - 100000000)*0)+ (50000000*0.1) + (40000000*0.3) + (5000000*0.5) + (4000000 *0.7) + (900000*0.9) + (100000 * 1))/10000
        section = 7;
    end
    
    --print("개인상점에서 벌어들인 돈 점수: ", adv_vis_point);
    return math.floor(adv_vis_point)
end

--ADVENTURE_BOOK FISHING score
function GET_ADVENTURE_BOOK_FISHING_POINT(pc)
    local adv_fishing_point = 0
    local fishing_cnt = 0
    local infoCount = 0
    
    local idList = GetAdventureBookFishingList(pc);
    if idList == nil then
        return adv_fishing_point;
    end
--    print("모험일지에 등록된 물고기 수: ", #idList);
    for i = 1, #idList do
        infoCount = GetFishingCount(pc, idList[i]);
        local cls = GetClassByType('Item', idList[i]);
        if cls ~= nil then
            if cls.ClassType2 == "Fishing" then
                if infoCount >= 1 then
                    fishing_cnt = fishing_cnt + infoCount
--                    print("-- 물고기 이름: ", cls.ClassName);
--                    print("-- 낚은 횟수: ", infoCount);
                end
            end
        end
    end
    
    local section = 0;
    if fishing_cnt > 0 and fishing_cnt <= 10 then
       adv_fishing_point = (fishing_cnt * 1)
       section = 1;
    elseif fishing_cnt > 10 and fishing_cnt <= 50 then
        adv_fishing_point = ((fishing_cnt - 10)*0.8) + (10 * 1)
        section = 2;
    elseif fishing_cnt > 50 and fishing_cnt <= 100 then
        adv_fishing_point = ((fishing_cnt - 50)*0.5) + (40*0.8) + (10 * 1)
        section = 3;
    elseif fishing_cnt > 100 and fishing_cnt <= 1000 then
        adv_fishing_point = ((fishing_cnt - 100)*0.2) + (50 *0.5) + (40*0.8) + (10 * 1)
        section = 4;
    elseif fishing_cnt > 1000 and fishing_cnt <= 5000 then
        adv_fishing_point = ((fishing_cnt - 1000)*0.1) + (900*0.2) + (50 *0.5) + (40*0.8) + (10 * 1)
        section = 5;
    elseif fishing_cnt > 5000 then
        adv_fishing_point = ((fishing_cnt - 5000)*0) + (4000*0.1) + (900*0.2) + (50*0.5) + (40*0.8) + (10 * 1)
        section = 6;
    end
--    print("낚시 점수: ", adv_fishing_point);
    return  math.ceil(adv_fishing_point)
end

--ADVENTURE_BOOK INDUN score
function GET_ADVENTURE_BOOK_INDUN_POINT(pc)
    local adv_indun_Point = 0
    local point = 0 
    
    local idList = GetAdventureBookIndunList(pc);
    if idList == nil then
        return adv_indun_Point;
    end
    
--    print("모험일지에 등록된 인던 수: ", #idList);
    for i = 1, #idList do
        local infoCount = GetIndunClearCount(pc, idList[i]);
        local cls = GetClassByType('Indun', idList[i]);
        local indun_Count = 0
        if cls ~= nil then
            --if cls.Journal ~= "FALSE" then
                local section = 0;
                if infoCount >= 1 then
                    --print("-- 인던 이름: ", cls.ClassName);
--                    print("-- 클리어 횟수: ", infoCount);
                    indun_Count = infoCount
                    section = 1;
                end
            --end
        end
        point = point + indun_Count
    end
    
    adv_indun_Point = point *1
    --print("미션/인던 점수 : "..adv_indun_Point)
    return adv_indun_Point
end

--INITIALIZATION_ITEMS(MONSTER, ITEM, RECIPE, SHOP, FISING, INDUN)
function INITIALIZATION_ADVENTURE_BOOK_POINT(pc)
    local totalPoint = 0
    
    totalPoint = totalPoint + GET_ADVENTURE_BOOK_MONSTER_POINT(pc)
    totalPoint = totalPoint + GET_ADVENTURE_BOOK_ITEM_POINT(pc)
    totalPoint = totalPoint + GET_ADVENTURE_BOOK_RECIPE_POINT(pc)
    totalPoint = totalPoint + GET_ADVENTURE_BOOK_SHOP_POINT(pc)
    totalPoint = totalPoint + GET_ADVENTURE_BOOK_FISHING_POINT(pc)
    totalPoint = totalPoint + GET_ADVENTURE_BOOK_INDUN_POINT(pc)
    --print("초기화 항목 점수 "..totalPoint)
    return totalPoint
end

--ADVENTURE_BOOK Grow_TeamLevel_point score
function GET_ADVENTURE_BOOK_TEAMLEVEL_POINT(pc)
    local team_Level = 0;    
    if IsServerObj(pc) == 1 then
        team_Level = GetTeamLevel(pc);
    else
        local account = session.barrack.GetMyAccount();
        if account ~= nil then
            team_Level = account:GetTeamLevel();
        end
    end
    local team_Point = 0
    for i = 1, 100 do
        if team_Level == i then
            team_Point = 100 * i
            --print("팀레벨 점수 : "..team_Point)
            return team_Point
        end
    end
end

--ADVENTURE_BOOK Grow_Class_point score
function GET_ADVENTURE_BOOK_CLASS_POINT(pc)
    local adv_class_Point = 0
    local point = 0
    
    local idList = GetCharacterNameList(pc);
    if idList == nil then
        return adv_class_Point;
    end
    
    local class_List = {}
--    print("현재 팀의 캐릭터 수: ", #idList);
    for i = 1, #idList do
        local jobHistoryStr = GetCharacterJobHistoryString(pc, idList[i]);        
--        print("-- 직업 히스토리: ", jobHistoryStr);
        local job = SCR_STRING_CUT_SEMICOLON(jobHistoryStr)
        if #job >= 1 then
            for j = 1, #job do
                if table.find(class_List, job[j]) == 0 then
--                    print(job[j], #job)
                    table.insert(class_List, job[j])
                end
            end
        end
    end
--    for z = 1, #class_List do
--        print("Class "..class_List[z])
--    end
    point = #class_List
    
    adv_class_Point = point * 50
    --print("클래스 점수 : "..adv_class_Point)
    return adv_class_Point
end

--ADVENTURE_BOOK Adventure_Map_point score
function GET_ADVENTURE_BOOK_MAP_POINT(pc)
    local adv_map_Point = 0;    
    local mapCount, totalMapRevealRate = GetTotalMapRevealInfo(pc);
--    print("모험일지에 등록된 맵 개수: ", mapCount);
--    print("--- 맵 탐사율 총합: ", math.floor(totalMapRevealRate/100));
    
    adv_map_Point = math.floor(totalMapRevealRate/10);
    --print("맵 탐험 점수 : "..adv_map_Point)
    return adv_map_Point;
end

--ADVENTURE_BOOK Adventure_Collection_point score
function GET_ADVENTURE_BOOK_COLLECTION_POINT(pc)
    local collectionCount, completeCount = GetCollectionCount(pc);
    local collect_Point = (collectionCount * 5) + (completeCount * 45);
    --print("콜렉션 점수 : "..collect_Point)
    return collect_Point
end

--ADVENTURE_BOOK Adventure_Achieve_point score
function GET_ADVENTURE_BOOK_ACHIEVE_POINT(pc)
	local adv_Achive_Point = GetAdventureBookAchievePoint(pc);
    return adv_Achive_Point;
end

--ADVENTURE_BOOK Adventure_Quest_point score
function GET_ADVENTURE_BOOK_QUEST_POINT(pc)
	local adv_quest_Point = GetAdventureBookQuestPoint(pc);
	return adv_quest_Point;
end


--ADVENTURE_BOOK TOTAL SCORE
function GET_ADVENTURE_BOOK_TOTAL_SCORE(pc)
    local totalPoint = 0;	
    local jounal, cnt  = GetClassList("AdventureBookPoint")
    for i = 0, cnt-1 do
        cls = GetClassByIndexFromList(jounal, i);
        if cls.ClassName == "Initialization_point" then
             local point = _G[cls.Script]
             totalPoint = totalPoint + point(pc)
             --print("초기화 항목 : "..point(pc))
        elseif cls.ClassName == "Grow_TeamLevel_point" then
             local point = _G[cls.Script]
             totalPoint = totalPoint + point(pc)
             --print("성장 팀 레벨 : "..point(pc))
        elseif cls.ClassName == "Grow_Class_point" then
             local point = _G[cls.Script]
             totalPoint = totalPoint + point(pc)
             --print("성장 클래스 : "..point(pc))
        elseif cls.ClassName == "Adventure_Map_point" then
             local point = _G[cls.Script]
             totalPoint = totalPoint + point(pc)
             --print("탐험 맵 탐사 : "..point(pc))
        elseif cls.ClassName == "Adventure_Collection_point" then
             local point = _G[cls.Script]
             totalPoint = totalPoint + point(pc)
             --print("탐험 콜렉션 : "..point(pc))
        elseif cls.ClassName == "Adventure_Achieve_point" then
             local point = _G[cls.Script]
             totalPoint = totalPoint + point(pc)
             --print("탐험 업적 : "..point(pc))
        elseif cls.ClassName == "Adventure_Quest_point" then
             local point = _G[cls.Script]
             totalPoint = totalPoint + point(pc)
             --print("탐험 퀘스트 : "..point(pc))
        end
    end
    --print("모험일지 점수 : "..totalPoint)
    return totalPoint
end

--ADVENTURE_BOOK max mon kill point
g_max_mon_kill_point = 0;
function SCR_GET_MAX_MON_KILL_POINT(pc)
    if g_max_mon_kill_point > 0 then
        return g_max_mon_kill_point;
    end

    local cls
    local max_Point = 0
    local boss_cnt = 0
    local basic_cnt = 0
    local mon_jounal_list = {}
    local jounal, count  = GetClassList("Monster")
    for i = 0 , count-1 do -- count-1
        cls = GetClassByIndexFromList(jounal, i);
        if cls.GroupName ~= nil and cls.GroupName == "Monster" and cls.GroupName ~= "None" then
            if cls.Journal ~= nil and cls.Journal ~= "None" then
               --print(cls.ClassName, table.count(mon_jounal_list, cls.Journal))
               if table.find(mon_jounal_list, cls.Journal) == 0  then
                    if cls.MonRank == "Boss" then
                        table.insert(mon_jounal_list, cls.Journal)
                        boss_cnt = boss_cnt + 1
                        --print(i.." "..cls.Journal.." "..cls.ClassName.." - Boss cnt : "..boss_cnt)
                    else
                        table.insert(mon_jounal_list, cls.Journal)
                        basic_cnt = basic_cnt + 1
                        --print(i.." "..cls.Journal.." "..cls.ClassName.." - Basic cnt : "..basic_cnt)
                    end
                end
            end
        end
    end
    --print(#mon_jounal_list)
    max_Point = (boss_cnt *60)+(basic_cnt*50)
--    print("basic_cnt : "..basic_cnt..", boss_cnt : "..boss_cnt.." SUM : "..basic_cnt+boss_cnt)
--    print("max_Point : "..max_Point)
    g_max_mon_kill_point = max_Point;
    return max_Point
end

--ADVENTURE_BOOK max item point
g_max_item_point = 0;
function SCR_GET_MAX_ITEM_POINT(pc)
    if g_max_item_point > 0 then
        return g_max_item_point;
    end

    local cls
    local max_Point = 0
    local equip_cnt = 0
    local basic_cnt = 0
    local item_jounal_list = {}
    local jounal, count  = GetClassList("Item")
    for i = 0 , count-1 do -- count-1
        cls = GetClassByIndexFromList(jounal, i);
        if cls.Journal ~= nil and cls.Journal ~= "None" and cls.Journal == "TRUE" then
            if cls.GroupName ~= "Premium" then
                if cls.ItemType ~= "Quest" and cls.ItemType ~= "Recipe" then
                    if cls.ItemType == "Equip" then
                        equip_cnt = equip_cnt + 1
                        --print(i.." "..cls.Journal.." "..cls.ClassName.." - equip cnt : "..equip_cnt)
                    else
                        basic_cnt = basic_cnt + 1
                        --print(i.." "..cls.Journal.." "..cls.ClassName.." - basic cnt : "..basic_cnt)
                    end
                end
            end
        end
    end
    max_Point = (equip_cnt *20)+(basic_cnt*50)
--    print("basic_cnt : "..basic_cnt..", equip_cnt : "..equip_cnt.." SUM : "..basic_cnt+equip_cnt)
--    print("max_Point : "..max_Point)
    g_max_item_point = max_Point;
    return max_Point
end

function SCR_GET_MAX_RECIPE_POINT(pc)
    local max_Point = 0
    local recipe_Point = 30
    local item_list_cnt = 0
    local recipe_Item, recipe_Cnt  = GetClassList("Recipe")
    local cls
    for i = 0 , recipe_Cnt-1 do -- count-1
        cls = GetClassByIndexFromList(recipe_Item, i);
        if cls.Journal ~= nil and cls.Journal ~= "None" and cls.Journal == "TRUE" then
            item_list_cnt = item_list_cnt + 1
        end
    end
    
    max_Point = item_list_cnt * recipe_Point
    --print(max_Point)
    return max_Point
end

function GET_ADVENTURE_BOOK_LIFE_TOTAL_POINT(pc)
    local total_Point = 0
    local shop_Point = 0
    local fishing_Point = 0
    
    shop_Point = GET_ADVENTURE_BOOK_SHOP_POINT(pc)
    fishing_Point= GET_ADVENTURE_BOOK_FISHING_POINT(pc)
    
    total_Point = shop_Point + fishing_Point
    
    return total_Point
end

function SCR_GET_MAX_LIVING_POINT(pc)
    local max_Point = 0
    local shop_Point = 0
    local fishing_Point = 0
    
    --shop
    --1~100,000 * 1
    --100,001~1,000,000 * 0.9
    --1,000,001~5,000,000 * 0.7
    --5,000,001~10,000,000 * 0.5
    --10,000,001~50,000,000 * 0.3
    --50,000,001~100,000,000 * 0.1
    --100,000,001~ * 0
    
    --fishing
    --1~10 * 1
    --11~50 * 0.8
    --51~100 * 0.5
    --101~1,000 * 0.2
    --1,001~5,000 * 0.1
    --5001~ * 0
    
    shop_Point = ((100000*1)+(900000*0.9)+(4000000*0.7)+(5000000*0.5)+(40000000*0.3)+(50000000*0.1)+(1*0))/10000
    fishing_Point = (10*1)+(40*0.8)+(50*0.5)+(900*0.2)+(4000*0.1)+(1*0)
    
    max_Point = math.floor(shop_Point) + math.floor(fishing_Point)
    --print(max_Point)
    return max_Point
end

function SCR_GET_MAX_INDUN_POINT(pc)
    local max_Point = 0
    local point = 10 --clear point
    local pc_Cnt = 4 --pc character count
    local indun = 0
    local indun_type_arr = {}
    local PlayPerReset_arr = {}
    local date = 31
    local play_Indun, play_Cnt  = GetClassList("Indun")
    local cls
    for i = 0 , play_Cnt-1 do -- count-1
        cls = GetClassByIndexFromList(play_Indun, i);
        if cls.Journal ~= nil and cls.Journal ~= "None" and cls.Journal == "TRUE" then
            if table.find(indun_type_arr, cls.PlayPerResetType) == 0 then
                table.insert(indun_type_arr, cls.PlayPerResetType)
                table.insert(PlayPerReset_arr, cls.PlayPerReset)
                --print(cls.PlayPerResetType)
            end
        end
    end
    for j = 1, #PlayPerReset_arr do
        indun = indun + PlayPerReset_arr[j]
        --print(indun)
    end
    
    max_Point = point * pc_Cnt * indun * date
    --print(max_Point)
    return max_Point
end


--Adventure All Category reward
function ADVENTURE_ALL_CATEGORY(pc)
    local score = 0
    score = score + GET_ADVENTURE_BOOK_TOTAL_SCORE(pc)
    
    return score
end

--Adventure Growth reward
function ADVENTURE_GROWTH_CATEGORY(pc)
    local score = 0
    
    score = score + GET_ADVENTURE_BOOK_TEAMLEVEL_POINT(pc)
    score = score + GET_ADVENTURE_BOOK_CLASS_POINT(pc)
    --print(score)
    return score
end

--Adventure Exploration reward
function ADVENTURE_EXPLORATION_CATEGORY(pc)
    local score = 0
    
    score = score + GET_ADVENTURE_BOOK_MAP_POINT(pc)
    score = score + GET_ADVENTURE_BOOK_COLLECTION_POINT(pc)
    score = score + GET_ADVENTURE_BOOK_ACHIEVE_POINT(pc)
    score = score + GET_ADVENTURE_BOOK_QUEST_POINT(pc)
    
    return score
end


function IS_POSSIBLE_GET_WIKI_REWARD(pc)

	local nowposx,nowposy,nowposz = Get3DPos(pc);
	local etc = GetETCObject(pc);
	local mapname, x, y, z, uiname = GET_LAST_UI_OPEN_POS(etc)

	if mapname == nil then
		return;
	end

	if uiname ~= 'journal' or GET_2D_DIS(x,z,nowposx,nowposz) > 100 or GetZoneName(pc) ~= mapname then
		print('get reward failed!')
		return 0;
	end

	return 1;
end

function GET_ADVENTURE_BOOK_CONTENTS_POINT(pc)
    local totalScore = 0;
    totalScore = totalScore + GET_ADVENTURE_BOOK_ACHIEVE_POINT(pc);
    totalScore = totalScore + GET_ADVENTURE_BOOK_QUEST_POINT(pc);
    return totalScore;
end

function GET_ADVENTURE_BOOK_MONSTER_KILL_COUNT_INFO(isBoss, curKillCount)
    local curLv = 1;
    local curMaxCount = 0;
    if isBoss == true then    
        local bossGradeCntCls = GetClass('AdventureBookConst', 'BOSS_MON_GRADE_COUNT');
        local bossTotalGradeCnt = bossGradeCntCls.Value;
        for i = 1, bossTotalGradeCnt do
            local gradeCountCls = GetClass('AdventureBookConst', 'BOSS_MON_KILL_COUNT_GRADE'..i);
            curMaxCount = gradeCountCls.Value;
            curLv = i;
            if curKillCount < curMaxCount then
                break;
            end
        end
    else
        local gradeCntCls = GetClass('AdventureBookConst', 'BASIC_MON_GRADE_COUNT');
        local totalGradeCnt = gradeCntCls.Value;
        for i = 1, totalGradeCnt do
           local gradeCountCls = GetClass('AdventureBookConst', 'BASIC_MON_KILL_COUNT_GRADE'..i);
            curMaxCount = gradeCountCls.Value;
            curLv = i;
            if curKillCount < curMaxCount then
                break;
            end
        end
    end
    local calcedCount = math.min(curKillCount, curMaxCount);
    return curLv, calcedCount, curMaxCount;
end

function GET_ADVENTURE_BOOK_CRAFT_COUNT_INFO(curCount)
    local curLv = 1;
    local calcedCount = curCount;
    local curMaxCount = 0;
    local gradeCountCls = GetClass('AdventureBookConst', 'CREFT_ITEM_GRADE1');
    curMaxCount = gradeCountCls.Value;
    calcedCount = math.min(calcedCount, curMaxCount); -- clamping    
    return curLv, calcedCount, curMaxCount;
end

function GET_ADVENTURE_BOOK_ITEM_OBTAIN_COUNT_INFO(isEquip, curObtainCount)
    local curLv = 1;
    local curMaxCount = 0;
    if isEquip == true then    
        local cntCls = GetClass('AdventureBookConst', 'GET_EQUIP_ITEM_GRADE_COUNT');
        local gradeCnt = cntCls.Value;
        for i = 1, gradeCnt do
            local gradeCountCls = GetClass('AdventureBookConst', 'GET_EQUIP_ITEM_GRADE'..i);
            curMaxCount = gradeCountCls.Value;
            curLv = i;
            if curObtainCount < curMaxCount then
                break;
            end
        end
    else
        local gradeCntCls = GetClass('AdventureBookConst', 'GET_ITEM_GRADE_COUNT');
        local totalGradeCnt = gradeCntCls.Value;        
        for i = 1, totalGradeCnt do
            local gradeCountCls = GetClass('AdventureBookConst', 'GET_ITEM_GRADE'..i);
            curMaxCount = gradeCountCls.Value;
            curLv = i;
            if curObtainCount < curMaxCount then
                break;
            end
        end
    end    
    local calcedCount = math.min(curObtainCount, curMaxCount); -- clamping    
    return curLv, calcedCount, curMaxCount;
end

function GET_ADVENTURE_BOOK_MAP_COUNT()
    local availableCount = 0;
    local mapList, cnt = GetClassList('Map');
    for i = 0, cnt - 1 do
        local mapCls = GetClassByIndexFromList(mapList, i);
        local journal = TryGetProp(mapCls, 'Journal');
        if journal == 'TRUE' then
            availableCount = availableCount + 1;
        end
    end
    return availableCount;
end