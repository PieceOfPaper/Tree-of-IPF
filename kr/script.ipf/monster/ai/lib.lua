-- lib.lua

function SCR_LIB_AI_INIT(self, flagHate, flagFloat, flagObject, flagHP)
    if flagHate == 'HateYES' then
        ResetHate(self);
    end
    if flagFloat == 'FloatYES' then
        SetTacticsArgFloat(self, 0, 0, 0);
    end
    if flagObject == 'ObjectYES' then
        SetTacticsArgObject(self, nil);
    end
    if flagHP == 'HPYES' then
        if self.HP < self.MHP then
            AddHP(self, self.MHP);
        end
    end

end

function GetNearFriendsCount(self)

    local obj, cnt = SelectObjectByClassName(self, 50, self.ClassName);
    return cnt;

end

function IsValidTarget(self, target)

    if self == nil then
        return 'NO';
    end
    if target ~= nil then
        if IsHostileFaction(self, target) == 'NO' then
            RemoveHate(self, target);
            return 'NO';
        end
        local myLayer = GetLayer(self);
        local tgLayer = GetLayer(target);
        if myLayer ~= tgLayer then
            RemoveHate(self, target);
            return 'NO';
        end
        if GetBodyState(target) ~= 'BS_DEAD' then
            local zoneInstID = GetZoneInstID(self);
            local targetX, targetY, targetZ = GetPos(target);
            local myposX, myposY, myposZ = GetPos(self);
            if IsValidPos(zoneInstID, targetX, targetY, targetZ) == 'YES' and FindPath(zoneInstID, 5 , myposX, myposY, myposZ, targetX, targetY, targetZ) == 'YES' then
                return 'YES';
            end
            RemoveHate(self, target);
        end
    end
    return 'NO';

end

function GetEnemyTargetObject(self)

    local ai = GetAIClass(self);

    local target = GetTacticsArgObject(self);
    local myposX, myposY, myposZ = GetPos(self);

    if IsValidTarget(self, target) == 'NO' then
        target = GetTopHatePointChar(self);
        if IsValidTarget(self, target) == 'YES' then
            return target;
        else
            if ai == nil then               
                return nil;
            end
            local sRange = ai.SearchRange;
            if IsBuffApplied(self, 'Blind') == 'YES' then
                return nil;
            end
            if sRange == 0 then
                return nil;
            end
            local objList, objCount = SelectObject(self, sRange, 'ENEMY');
            if objCount > 0 then
                for index = 1, objCount do
                    local zoneInstID = GetZoneInstID(objList[index]);
                    local targetX, targetY, targetZ = GetPos(objList[index]);
                    if GetBodyState(objList[index]) ~= 'BS_DEAD' and IsValidPos(zoneInstID, targetX, targetY, targetZ) == 'YES' and FindPath(zoneInstID, 5 , myposX, myposY, myposZ, targetX, targetY, targetZ) == 'YES' then
                        
                        InsertHate(self, objList[index], 10);
                        return objList[index];
                    end
                end
            else
                return nil;
            end
        end
    end
    return target;

end

function GetEnemyTargetObject_LawMonster(self)

    local ai = GetAIClass(self);
    local target = GetTacticsArgObject(self);

    if IsValidTarget(self, target) == 'NO' then
        target = GetTopHatePointChar(self);
        if IsValidTarget(self, target) == 'YES' then
            return target;
        else
            local objList, objCount = SelectObject(self, ai.SearchRange, 'ENEMY');
            if ai.SearchRange == 0 then
                return nil;
            end
            if objCount > 0 then
                for index = 1, objCount do
                    local zoneInstID = GetZoneInstID(objList[index]);
                    local targetX, targetY, targetZ = GetPos(objList[index]);
                    if GetBodyState(objList[index]) ~= 'BS_DEAD' and IsValidPos(zoneInstID, targetX, targetY, targetZ) == 'YES' and 0 == IsItem(objList[index]) and objList[index].MHP < 10000 then
                        InsertHate(self, objList[index], 10);
                        return objList[index];
                    end
                end
            else
                return nil;
            end
        end
    end
    return target;

end

function GetNewRandomEnemyTargetObject(self, exception)

    local ai = GetAIClass(self);
    local myposX, myposY, myposZ = GetPos(self);
    local target = nil;
    local cnt = 0;

    local sRange = ai.SearchRange;
    if IsBuffApplied(self, 'Blind') == 'YES' then
        return nil;
    end
    if sRange == 0 then
        return nil;
    end
    local objList, objCount = SelectObject(self, sRange, 'ENEMY');
    if objCount > exception then
        while 1 do
            index = IMCRandom(1, objCount);
            local zoneInstID = GetZoneInstID(objList[index]);
            local targetX, targetY, targetZ = GetPos(objList[index]);
            if GetBodyState(objList[index]) ~= 'BS_DEAD' and IsValidPos(zoneInstID, targetX, targetY, targetZ) == 'YES' and FindPath(zoneInstID, 5 , myposX, myposY, myposZ, targetX, targetY, targetZ) == 'YES' then
                if exception > 0 then
                    local topHate = GetTopHatePointChar(self);
                    if topHate == nil or topHate ~= objList[index] then
                        target = objList[index];
                        break;
                    end
                else
                    target = objList[index];
                    break;
                end
            end
            cnt = cnt + 1;
            if cnt > 20 then
                break;
            end
        end
    end

    return target;

end

function OnSkillUse(self)

    local state = GetActionState(self);
    if state == 'AS_SKILL_USE' or state == 'AS_SKILL_CAST' or state == 'AS_SKILL_CHASE' then
        return 'YES';
    end
    return 'NO';
end

function OnKnockDown(self)

    local state = GetActionState(self);
    if state == 'AS_KNOCKBACK' or state == 'AS_KNOCKDOWN' or state == 'AS_DOWN' then
        return 'YES';
    end
    return 'NO';
end

function IsAttacking(self)

    local state = GetActionState(self);
    if state == 'AS_SKILL_CAST' or state == 'AS_SKILL_USE' then
        return 'YES';
    end
    return 'NO';
end

function GetTargetDirectionByAngle(self, target)

    local x1, y1, z1 = GetPos(self);
    local x2, y2, z2 = GetPos(target);
    local xt = (x2 - x1) / math.sqrt(((x2 - x1) * (x2 - x1)) + ((z2 - z1) * (z2 - z1)));
    local yt = (z2 - z1) / math.sqrt(((x2 - x1) * (x2 - x1)) + ((z2 - z1) * (z2 - z1)));
    local angle = math.atan(yt / xt) / math.pi * 180;
    if xt < 0 then
        angle = 180 + angle;
    end
    if xt > 0 and yt < 0 then
        angle = 360 + angle;
    end
    if xt == 0 and yt == 1 then
        angle = 90;
    elseif xt == 0 and yt == -1 then
        angle = 270;
    end
    angle = math.ceil(angle);
    if angle == 360 then
        angle = 0;
    end
    return angle;
end

-- Use Skill
function UseSelectedMonsterSkill(self, target, skillName)

    UseMonsterSkill(self, target, skillName);

end

-- Change monster shape
function ChangeShape(self, shape)

    self.Shape = shape;
    BroadcastShape(self);

end

-- Get map.xml drop item list
function GetMapDropItemList(self, list, owner)

    if list == 'None' then
        return
    end
    
    local layer_obj = GetLayerObject(GetZoneInstID(self), GetLayer(self));
    if layer_obj ~= nil then
        if layer_obj.GUILD_EVENT_LAYER == 'GUILD_EVENT_LAYER' then
            return
        end
    end
    
    
    local itemname = {};
    local drop_sObj = GetSessionObject(owner, 'ssn_drop')
    local drop = GetClass('Map', GetZoneName(self))

    for i = 1, 10 do
        if GetPropType(drop, 'DropItemClassName'..i) ~= nil and  drop['DropItemClassName'..i] ~= 'None' and GetClass('Monster', drop['DropItemClassName'..i]) ~= nil then
            local rate = IMCRandom(1,10000)
            local ratio
            
            if drop ~= nil then
                -- 드랍 제외된 몬스터 일 때 예외처리
                if drop['DropItemExceptMon'..i] ~= 'None' then
                    local stirng_cut_list = SCR_STRING_CUT(drop['DropItemExceptMon'..i])
                    
                    if #stirng_cut_list > 0 then
                        for j = 1, #stirng_cut_list do
                            if self.ClassName == stirng_cut_list[j] then
                                return
                            end
                        end
                    end
                end
                
                local drop_bonus = 0
                if drop['DropItemBNType'..i] ~= 'None' then
                    drop_bonus = drop_sObj[drop['DropItemBNType'..i]..'_BN']
                end
                
                local drop_ratio = drop['DropItemRatio'..i]
    
                ratio = drop_ratio + math.floor(drop_ratio *  drop_bonus / 100)

                ratio = ratio * JAEDDURY_ZONE_ITEM_RATE;        -- JAEDDURY : 존 아이템 드랍율 조절.
    
                if rate <= ratio then
                    
                    itemname[#itemname + 1] = {}
                    itemname[#itemname][1] = drop['DropItemClassName'..i];
                    itemname[#itemname][2] = 1;
                    itemname[#itemname][3] = drop;                    
                    
                end
            end
        end
    end
    
    return itemname;
end

-- Get zone drop item list
function GetZoneDropItemList(self, list, owner)

    if list == nil or list == 'None' then
        return
    end
    
    local zoneName = GetZoneName(self);
    if zoneName ~= nil then
        local zoneDropList, zoneDropCnt  = GetClassList("ZoneDropItemList_"..zoneName);
        if zoneDropList ~= nil then
            local layer_obj = GetLayerObject(GetZoneInstID(self), GetLayer(self));
            if layer_obj ~= nil then
                if layer_obj.GUILD_EVENT_LAYER == 'GUILD_EVENT_LAYER' then
                    return
                end
            end
            
            
            local itemname = {};
            local drop_sObj = GetSessionObject(owner, 'ssn_drop')
            if zoneDropCnt >= 1 then
                for i = 0, zoneDropCnt - 1 do
                    local drop = GetClassByIndexFromList(zoneDropList, i);
                    local rate = IMCRandom(1,10000)
                    local ratio
                    local itemcount = 1
                    local result_ratio, index
                    
                    if drop ~= nil then
                        
                        local drop_bonus = drop_sObj[drop.Type..'_BN']
                        local drop_ratio = drop.DropRatio
                        local drop_classname = drop.ItemClassName
                        
                        -- 드롭 그룹 시스템으로 드롭 교체 --
					    local drop_group = TryGetProp(drop, 'DropGroup');
					    if drop_group ~= nil and drop_group ~= 'None' then
                        	drop_classname = SCR_DROP_GROUP_CALC(drop_group, drop_classname);
                        end
                        
		                -- 루팅 찬스 --
		                local itemClass = GetClass('Item', drop_classname);
		                local needRandomOptionItem = TryGetProp(itemClass, 'NeedRandomOption');
		                if needRandomOptionItem == 1 then
		                	drop_ratio = SCR_LOOTING_CHANCE_CALC(owner, drop_ratio);
		                end
                        
                        if drop.Type == 'Money_Hi' then
                            result_ratio, index = SCR_MODIFY_RATIO(self, owner, drop_sObj, 'Money_Hi', drop_ratio)
                            if droptype ~= -1 then
                                drop_ratio = 2
                            end
                        elseif drop.Type == 'Exp_Hi' then
                            result_ratio, index = SCR_MODIFY_RATIO(self, owner, drop_sObj, 'Exp_Hi', drop_ratio)
                            
                            if result_ratio ~= nil then
                                drop_ratio = result_ratio
                            end
                        end
                        
                        
                        
                        ratio = drop_ratio + math.floor(drop_ratio *  drop_bonus / 100)
                        
                        ratio = ratio * JAEDDURY_DROP_ITEM_RATE;        -- JAEDDURY : 일반 아이템 드랍율 조절. (monsterdroplist.xml에 등록된 아이템)
                        
                        if rate <= ratio then
                            if drop.Type == 'Money_Hi' or drop.Type == 'Money_Mid' or drop.Type == 'Money_Low' then
                                if drop.Type == 'Money_Hi' then
                                    if index ~= nil and index > 0 then
                                        drop_sObj['Money_Session'..index] = drop_sObj['Money_Session'..index] + 1
                                        SaveSessionObject(owner, drop_sObj)
                                    end
                                end
                                
                                local min_count = drop.Money_Min
                                local max_count = drop.Money_Max
                                
                                if IsBuffApplied(self, 'drop_inceaseMoney') == 'YES' then -- 실버 증가 버프일때 돈을 배율로 올려준다
                                    local buff = GetBuffByName(self, 'drop_inceaseMoney');
                                    local moneyRatio = GetExProp(buff, "MoneyRatio");
                                    min_count = math.floor(min_count * moneyRatio);
                                    max_count = math.floor(max_count * moneyRatio);
                                end
                                
                                itemcount = IMCRandom(min_count, max_count)
                                itemcount = itemcount * JAEDDURY_GOLD_RATE;         -- JAEDDURY : 드랍되는 골드량을 조절.
                                
                                if itemcount <= 0 then
                                    itemcount = 1
                                end
                                
                                -- 돈금액에따른 아이템 종류/크기 구분
                                if drop_classname == 'Moneybag2' then
                                    drop_classname = CalcVisSize(itemcount);
                                end
                            elseif drop.Type == 'Exp_Hi' then
                                local random_min = 90
                                local random_max = 110
                                local max_bonus_percent = (GetClassNumber('Xp',GetMaxLv(),'Session') - GetClassNumber('Xp',level,'Session'))*5
                                if max_bonus_percent >= 25 then
                                    max_bonus_percent = 25
                                elseif max_bonus_percent < 0 then
                                    max_bonus_percent = 0
                                end
                                local percent = 10 + max_bonus_percent
                                local next_xp
                                if level == 1 then
                                    next_xp = GetClassNumber('Xp',level,'TotalXp')
                                else
                                    next_xp = GetClassNumber('Xp',level,'TotalXp') - GetClassNumber('Xp',level - 1,'TotalXp')
                                end
                                
                                itemcount = math.floor(next_xp * percent / 100 * IMCRandom(random_min, random_max)/100)
                                
                                if index ~= nil and  index > 0 then
                                    drop_sObj['Exp_Session'..index] = drop_sObj['Exp_Session'..index] + 1
                                    SaveSessionObject(owner, drop_sObj)
                                end
                            end
                            
                            local duplication_index = SCR_TABLE_FIND(itemname, drop)
                            
                            if duplication_index > 0 then
                                itemname[duplication_index][1] = drop_classname;
                                itemname[duplication_index][2] = itemcount
                                itemname[duplication_index][3] = drop;
                            elseif duplication_index == 0 then
                                itemname[#itemname + 1] = {}
                                itemname[#itemname][1] = drop_classname;
                                itemname[#itemname][2] = itemcount
                                itemname[#itemname][3] = drop;
                            end
                        end
                    end
                end
                
                return itemname;
            end
        end
    end
    
    return
end

function GET_LEVEL_FOR_DROP(self)

    local level = GetExProp(self, "LEVEL_FOR_DROP");
    if level == 0 then
        level = self.Lv;
    end
    
    return level;

end

-- Get drop item list
function GetMonsterDropItemList(self, list, owner)
    if list == 'None' then
        return
    end
    
    local cnt, droptype = GET_SUPERDROP(self);  
    
    local itemname = {};
    local drop_sObj = CREATE_SOBJ(owner, 'ssn_drop')
    if drop_sObj == nil then
        return;
    end

    local bonusMoney = 0;
    local level = GET_LEVEL_FOR_DROP(self);

    local clsList, cnt  = GetClassList("MonsterDropItemList_" .. list);
    for i = 0 , cnt - 1 do

        local drop = GetClassByIndexFromList(clsList, i);
        local rate = IMCRandom(1,10000)
        local ratio
        local itemcount = 1
        local result_ratio, index

        if drop ~= nil then
            if TryGetProp(drop,'Zone') == 'None' or SCR_MON_DROP_ZONE_VALID(self,drop) == 'YES' then
                
                local drop_bonus = drop_sObj[drop.Type..'_BN']
                local drop_ratio = drop.DropRatio
                local drop_classname = drop.ItemClassName
                
                -- 드롭 그룹 시스템으로 드롭 교체 --
			    local drop_group = TryGetProp(drop, 'DropGroup');
			    if drop_group ~= nil and drop_group ~= 'None' then
                	drop_classname = SCR_DROP_GROUP_CALC(drop_group, drop_classname);
                end
                
                -- 루팅 찬스 --
                local itemClass = GetClass('Item', drop_classname);
                local needRandomOptionItem = TryGetProp(itemClass, 'NeedRandomOption');
                if needRandomOptionItem == 1 then
                	drop_ratio = SCR_LOOTING_CHANCE_CALC(owner, drop_ratio);
                end
                
                if drop.Type == 'Money_Hi' then
                    result_ratio, index = SCR_MODIFY_RATIO(self, owner, drop_sObj, 'Money_Hi', drop_ratio)
                    if droptype ~= -1 then
                        drop_ratio = 2
                    end
                elseif drop.Type == 'Exp_Hi' then
                    result_ratio, index = SCR_MODIFY_RATIO(self, owner, drop_sObj, 'Exp_Hi', drop_ratio)
                    
                    if result_ratio ~= nil then
                        drop_ratio = result_ratio
                    end
                end
    
                ratio = drop_ratio + math.floor(drop_ratio *  drop_bonus / 100)
                 
--                if drop.Type == 'Exp_Hi' or drop.Type == 'Money_Hi' then
--                    print(self.Name, ScpArgMsg('Auto__DeuLapTaip')..drop.Type, ScpArgMsg('Auto__/_KiJun')..rate, ScpArgMsg('Auto__/_ChoeJong_HwagLyul')..ratio,ScpArgMsg('Auto__/_SeolJeong_HwagLyul')..drop.DropRatio,ScpArgMsg('Auto__/_BoJeong_Jeogyong_HwagLyul')..drop_ratio)
--                end
    
                ratio = ratio * JAEDDURY_DROP_ITEM_RATE;        -- JAEDDURY : 일반 아이템 드랍율 조절. (monsterdroplist.xml에 등록된 아이템)
                
                if rate <= ratio then
                    if drop.Type == 'Money_Hi' or drop.Type == 'Money_Mid' or drop.Type == 'Money_Low' then
                        if drop.Type == 'Money_Hi' then
                            if index ~= nil and index > 0 then
                                drop_sObj['Money_Session'..index] = drop_sObj['Money_Session'..index] + 1
                                SaveSessionObject(owner, drop_sObj)
                            end
                        end

                        local min_count = drop.Money_Min
                        local max_count = drop.Money_Max
                        
                        if IsBuffApplied(self, 'drop_inceaseMoney') == 'YES' then -- 실버 증가 버프일때 돈을 배율로 올려준다
                            local buff = GetBuffByName(self, 'drop_inceaseMoney');
                            local moneyRatio = GetExProp(buff, "MoneyRatio");
                            min_count = math.floor(min_count * moneyRatio);
                            max_count = math.floor(max_count * moneyRatio);
                        end
                        
                        itemcount = IMCRandom(min_count, max_count)
                        itemcount = itemcount * JAEDDURY_GOLD_RATE;         -- JAEDDURY : 드랍되는 골드량을 조절.

                    

                        if itemcount <= 0 then
                            itemcount = 1
                        end

                        -- 돈금액에따른 아이템 종류/크기 구분
                        if drop_classname == 'Moneybag2' then
                            drop_classname = CalcVisSize(itemcount);
                        end

                    elseif drop.Type == 'Exp_Hi' then
                        local random_min = 90
                        local random_max = 110
                        local max_bonus_percent = (GetClassNumber('Xp',GetMaxLv(),'Session') - GetClassNumber('Xp',level,'Session'))*5
                        if max_bonus_percent >= 25 then
                            max_bonus_percent = 25
                        elseif max_bonus_percent < 0 then
                            max_bonus_percent = 0
                        end
                        local percent = 10 + max_bonus_percent
                        local next_xp
                        if level == 1 then
                            next_xp = GetClassNumber('Xp',level,'TotalXp')
                        else
                            next_xp = GetClassNumber('Xp',level,'TotalXp') - GetClassNumber('Xp',level - 1,'TotalXp')
                        end
    
                        itemcount = math.floor(next_xp * percent / 100 * IMCRandom(random_min, random_max)/100)
                        
                        if index ~= nil and  index > 0 then
                            drop_sObj['Exp_Session'..index] = drop_sObj['Exp_Session'..index] + 1
                            SaveSessionObject(owner, drop_sObj)
                        end
                    end
                    local duplication_index = SCR_TABLE_FIND(itemname, drop)
                    --print(duplication_index)
                    if duplication_index > 0 then
                        itemname[duplication_index][1] = drop_classname;
                        itemname[duplication_index][2] = itemcount
                        itemname[duplication_index][3] = drop;
                    elseif duplication_index == 0 then
                        itemname[#itemname + 1] = {}
                        itemname[#itemname][1] = drop_classname;
                        itemname[#itemname][2] = itemcount
                        itemname[#itemname][3] = drop;
                    end
                end
            end
        end
    end

    SaveSessionObject(owner, drop_sObj)
        
    return itemname;
end


function SCR_MON_DROP_ZONE_VALID(self,drop)
    local zone_list = SCR_STRING_CUT(TryGetProp(drop,'Zone'))
    local now_zone = GetZoneName(self)
    local i
    if zone_list ~= nil and #zone_list > 0 then
        for i = 1, #zone_list do
            if zone_list[i] == now_zone then
                return 'YES'
            end
        end
    end
    
    return 'NO'
end

function SCR_TABLE_FIND(target, drop)
    local i
    local target_type = {Item = 8, Exp_Hi = 7, Money_Hi= 6, Money_Mid=5, Money_Low=4, Etc_Hi = 3, Etc_Mid = 2, Etc_Low = 1}
    local flag = 'NO'

    if target ~= nil then
        for i = 1, #target do           
            if target[i][3] == drop.GroupName then
                flag = 'YES'                
                                
                if target_type[target[i][2]] < target_type[drop.Type] then
                    return i
                elseif target_type[target[i][2]] == target_type[drop.Type] then
                                
                    if target[i][4] >= drop.DropRatio then
                    
                        if drop.GroupName == 'Item' then
                            return 0;
                        else
                            return i
                        end
                    end
                end
            end
        end
    else
        return 0
    end

    if flag == 'YES' then
        return -100
    else
        return 0
    end
end



function SCR_MODIFY_RATIO(self, owner, drop_sObj, drop_type, drop_ratio)
    local result = drop_ratio
    local index = 0
    
    if drop_sObj ~= nil then
        local startLv = 0
        local endLv = 0
        local targetRatio = 2000
        
        local column1 = ''
        local column2 = ''
        
        if drop_type == 'Money_Hi' then
            column1 = 'Money_MINMAX'
            column2 = 'Money_Session'
        elseif drop_type == 'Exp_Hi' then
            column1 = 'Exp_MINMAX'
            column2 = 'Exp_Session'
        end
        for i = 1, 2 do
            if owner.Lv <= drop_sObj[column1..i] then
                index = i
                endLv = drop_sObj[column1..i]
                break
            end
                startLv = drop_sObj[column1..i]
        end
        
        if index > 0 and owner.Lv > 3 and GET_LEVEL_FOR_DROP(self) >= owner.Lv - 5 then
            if drop_sObj[column2..index] == 0 then
                result = drop_ratio + math.floor(targetRatio * (owner.Lv - startLv) / (endLv - startLv))
            end
        end
        return result, index
    end
end

function INIT_ITEM_OWNER(self, pc)
        if IS_PC(pc) == true then
            self.UniqueName = GetPcAIDStr(pc);
        else
            name = GetName(pc)
        end 
end

function SCR_LIB_DROP_MONEY(self, x, y, z, target, target_name, itemlist, index, className, itemCount, max_cipher, delay_count, delay_time)
    if #itemlist > 0 then
        for i = 1, #itemlist do
            local iesObj = CreateGCIES('Monster', className);

            iesObj.ItemCount = itemlist[i];
            iesObj.UniqueName = target_name;
                iesObj.Name = target_name..ScpArgMsg("Auto_ui_")..itemlist[i]..ScpArgMsg("Auto__SilBeo")
            
            x2 = IMCRandom(x - 30, x + 30)
            z2 = IMCRandom(z - 30, z + 30)
            
            local item = CREATE_ITEM(self, iesObj, target, x2, y, z2, 0, 1);
            if item ~= nil then
                SetPickTime(item, 0.5);
                if i == 1 then
                    SetTacticsArgFloat(item, 0, 0, 10000)
                else
                    SetTacticsArgFloat(item, 0, 0, 1000)
                end
                local self_layer = GetLayer(self);
                if self_layer ~= nil and self_layer ~= 0 then
                    SetLayer(item, self_layer);
                end
            end
        end
    end
    

    return delay_count, delay_time;
end

function SCR_DROP_MONEY_HI(self, targetpc, target_name, drop_list, delay_time)

    local x, y, z = GetDeadPos(self);
    local i
    local max_cipher
    local itemlist = {}
    local delay_count = 0
    
    local drop_count = math.floor(drop_list / 100)
    local value = drop_list % 100
    if drop_count == 0 then
        for i = 1, value do
            local tempValue = 1
            itemlist[#itemlist + 1] = tempValue
        end
        
        max_cipher = 100
    else
        for i = 1, 100 do
            local tempValue = drop_count
            if i < value then
                tempValue = drop_count + 1
            end
            itemlist[#itemlist + 1] = tempValue
        end
        
        max_cipher = 100
    end
--    else
--        itemlist[#itemlist + 1] = math.floor(drop_list / 10000)
--    
--        itemlist[#itemlist + 1] = math.floor((drop_list - (10000 * itemlist[#itemlist])) / 1000 )
--        itemlist[#itemlist + 1] = math.floor((drop_list - (10000 * itemlist[#itemlist - 1]) - (1000 * itemlist[#itemlist])) / 100 )
--        itemlist[#itemlist + 1] = math.floor((drop_list - (10000 * itemlist[#itemlist - 2]) - (1000 * itemlist[#itemlist - 1])- (100 * itemlist[#itemlist])) / 10 )
--        itemlist[#itemlist + 1] = math.floor(drop_list - (10000 * itemlist[#itemlist - 3]) - (1000 * itemlist[#itemlist - 2])- (100 * itemlist[#itemlist - 1]) - (10 * itemlist[#itemlist]))
--    
--        for i = 1, #itemlist do
--            if itemlist[i] > 0 then
--                max_cipher = i
--                break
--            end
--        end
--    end
--    print('itemlist[1]'..itemlist[1])
--    print('itemlist[2]'..itemlist[2])
--    print('itemlist[3]'..itemlist[3])
--    print('itemlist[4]'..itemlist[4])
--    print('itemlist[5]'..itemlist[5])
--    print('max_cipher'..max_cipher)

    PlayEffect(self, 'F_light048_blue', 6.0, 1, "BOT", 1);
    PlaySound(self, 'money_jackpot');
    delay_count, delay_time = SCR_LIB_DROP_MONEY(self, x, y, z, targetpc, target_name, itemlist, 1, 'Moneybag1', itemCnt, max_cipher, delay_count, delay_time);
--    for i = 1 , 5 do
--      local index = 6 - i;
--      local itemName
--      if i < 3 then
--          itemName = 'Moneybag1';
--      else
--          itemName = 'Moneybag2';
--      end
----        local itemName = 'Moneybag' .. i;
--      local itemCnt = math.pow(10, i -1);
--      
--      delay_count, delay_time = SCR_LIB_DROP_MONEY(self, x, y, z, targetpc, target_name, itemlist, index, itemName, itemCnt, max_cipher, delay_count, delay_time);
--    end

end

function GetXZFromDistAngle(dist, angle)

    local x = dist * math.cos(angle * math.pi / 180);
    local y = dist * math.sin(angle * math.pi / 180);
    return x, y;

end

-- IsBuffApplied(self, 'MonReduceDamage') == 'NO'

--[[
function GetDirectionByAngle(self)

    local a, b = GetDirection(self);
    local angle = math.atan(b / a) / math.pi * 180;
    if a < 0 then
        angle = 180 + angle;
    end
    if a > 0 and b < 0 then
        angle = 360 + angle;
    end
    if a == 0 and b == 1 then
        angle = 90;
    elseif a == 0 and b == -1 then
        angle = 270;
    end
    angle = math.ceil(angle);
    if angle == 360 then
        angle = 0;
    end
    return angle;
end
]]

function ANGLE_TO_DIR(angle)

    return math.cos(angle), math.sin(angle);

end

function GotoOwner(self)

    local owner =  GetOwner(self);
    if owner == nil then
        return;
    end

    local x, y, z = GetPos(owner);
    GoTo(self, x, y, z, 30, 'TS_BATTLE');

end

function GotoCreatedPos(self)

    GoTo(self, self.CreateX, self.CreateY, self.CreateZ, 1, 'TM_IDLE');

end

function GoTo(self, x, y, z, checkRange, endTactics)
    if IsNearFrom(self, x, z, checkRange) ~= 'YES' then
        if GetMoveState(self) ~= 'MS_MOVE_PATH' then
            MoveEx(self, x, y, z, 1);
        end
    else
        ChangeTacticsMainState(self, endTactics);
        return;
    end

end

function ForceGotoCreatedPos(self)

    if IsBuffApplied(self, 'MoveSpeed') == 'NO' then
        AddBuff(self, self, "MoveSpeed", 1, 0, 30000, 1);
    end

    CancelMonsterSkill(self);
    StopMove(self);
    SetTacticsArgFloat(self, 100);
    ChangeTacticsMainState(self, 'TM_IDLE');

end

function GET_TOPHATE_NEAR_CHEAR(self, maxR)

    local target = GetTopHatePointChar(self);
    if target == nil then
        return nil;
    end

    local dist = GetDistance(self, target);
    if GetDistance(self, target) > maxR then
        SetTacticsArgObject(self, nil);
        ResetHate(self, target);
        target = nil;
    end

    return target;
end

function GetNearEnemyTarget(self, maxR)

    local ai = GetAIClass(self);
    local target = GetTacticsArgObject(self);

    if IsValidTarget(self, target) == 'NO' then
        target = GET_TOPHATE_NEAR_CHEAR(self, maxR);
        if IsValidTarget(self, target) == 'YES' then
            return target;
        else
            target = GetNearestTarget(self);
        end
    else
        if GetDistance(self, target) > maxR then
            SetTacticsArgObject(self,nil);
            ResetHate(self, target);
            target = nil;
        end
    end

    return target;

end

function GetNearestTarget(self)

    local zoneInstID = GetZoneInstID(self);
    local minDist = 999999;
    local minObj = nil;

    local ai = GetAIClass(self);
    local objList, objCount = SelectObject(self, ai.SearchRange, 'ENEMY');
    if objCount > 0 then
        for index = 1, objCount do
            local obj = objList[index];
            local tx, ty, tz = GetPos(obj);
            if GetBodyState(obj) ~= 'BS_DEAD' and IsValidPos(zoneInstID, tx, ty, tz) == 'YES' then
                local dist = GetDistance(self, obj);
                if dist < minDist then
                    minDist = dist;
                    minObj = obj;
                end
            end
        end
    end

    return minObj;

end

function MON_RETURN_ENTER(self, x, y, z)

    self.MSPD_BM = self.MSPD_BM + self.RunMSPD - self.WlkMSPD;
    ResetHate(self);
    SetTacticsArgObject(self, nil);
    if MoveEx(self, x, y, z, 1) == 'NO' then
        MON_CREATEPOS_RESET(self)
    end
    InvalidateStates(self);

end

function MON_RETURN_LEAVE(self)
    ResetHate(self);
    SetTacticsArgFloat(self, 0);
    self.MSPD_BM = self.MSPD_BM - self.RunMSPD + self.WlkMSPD;
    InvalidateStates(self);
end

function GET_OWNER_POS(self)

    local owner =  GetOwner(self);
    if owner == nil then
        return GetPos(self);
    end

    return GetPos(owner);

end

function MON_GOTO_CREATEPOS(self)
    MoveEx(self, self.CreateX, self.CreateY, self.CreateZ, 1);
end

function MON_CREATEPOS_RESET(self)
    local x, y, z = GetPos(self);
    if nil == x or nil == y or nil == z then
        Dead(self);
        return;
    end
    self.CreateX = x;
    self.CreateY = y;
    self.CreateZ = z;
--    self.CreateX, self.CreateY, self.CreateZ = GetPos(self);
end

function SCR_JUMP_HIT_MOVE(self)

    RemoveBuff(self, "MoveSpeedFix");
    RandomMove(self, 30);

end

function GetCloserNumber(num, arg1, arg2)

    local value1 = math.abs(arg1 - num);
    local value2 = math.abs(arg2 - num);

    if value1 > value2 then
        return arg2;
    elseif value2 > value1 then
        return arg1;
    else
        if num < 0 then
            if arg1 < arg2 then
                return arg2;
            else
                return arg1;
            end
        else
            if arg1 < arg2 then
                return arg1;
            else
                return arg2;
            end
        end
    end
end

function CRE_ITEM(pc, x, y, z, itemType, itemCount, range)

    local monType = geItemTable.GetItemMonster(itemType);
    local dropIES = CreateGCIESByID('Monster', monType);
    dropIES.ItemCount = itemCount;
    INIT_ITEM_OWNER(dropIES, pc);
    CREATE_ITEM(nil, dropIES, pc, x, y, z, 0, range);
   
end

function CREATE_ITEM(mon, itemObj, pc, x, y, z, dir, range, isPayItem)
    if itemObj ~= nil then        
        if itemObj.ItemCount <= 0 then            
            return nil
        end
    end
    
    if mon ~= nil then
        itemObj.Lv = mon.Lv;
    end
    
    INIT_ITEM_OWNER(itemObj, pc);
    if isPayItem ~= nil and isPayItem == true then
        -- apc에 추가하기싫어서 UniqueName에 'payItem_'를 붙이는걸로...
        itemObj.UniqueName = 'payItem_' .. GetPcAIDStr(pc); 
    end
    

    if 1 == GetExProp(mon, "SUPER_DROP") then
        range = 50
    end

    local result;
    if mon == nil then  
        result = CreateItem(pc, itemObj, x, y, z, dir, range);
    else
        result = CreateItem(mon, itemObj, x, y, z, dir, range);
    end

    if result ~= nil then

        local layer = GetLayer(pc);
        SetLayer(result, layer);
    
        if mon ~= nil then
            result.NumArg4 = mon.ClassID;
            result.StrArg1 = mon.ClassName;
        end
    end

    return result;

end

function MoveToPetPosition(self, dist)

    local owner = GetOwner(self);
    if owner ~= nil then
        local targetX, targetY, targetZ = GetPos(owner);
        if math.floor(targetX) ~= self.CreateX or math.floor(targetZ) ~= self.CreateZ then
            self.PetPosition = 0;
            local setPosX = math.floor(targetX + dist * math.cos((GetDirectionByAngle(owner) + 135) * math.pi / 180));
            local setPosZ = math.floor(targetZ + dist * math.sin((GetDirectionByAngle(owner) + 135) * math.pi / 180));
            self.CreateX = math.floor(targetX);
            self.CreateZ = math.floor(targetZ);
            if GetMoveState(self) ~= 'MS_MOVE_PATH' then
                MoveEx(self, setPosX, targetY, setPosZ, 1);
            end
        end
        if GetMoveState(self) == 'MS_STOP' then
            if GetDirectionByAngle(self) ~= GetDirectionByAngle(owner) and self.PetPosition == 0 then
                SetDirectionByAngle(self, GetDirectionByAngle(owner));
                self.PetPosition = 1;
            end
        end
    end

end




function LevelMoneyItem(self, itemname)
    local totalMoney = GET_LEVEL_FOR_DROP(self);
    -- 최대 동전 5개로 드랍하도록
    for i=0, 4 do       
        if totalMoney == 0 then
            break;
        end

        local money     = IMCRandom(1, math.min(totalMoney, 50));   -- 동전1개에 최대 금액은 50원
        local moneyType = CalcVisSize(money);

        itemname[#itemname + 1] = {};
        itemname[#itemname][1] = moneyType;
        itemname[#itemname][2] = 'Money_Low';
        itemname[#itemname][3] = 'Money';
        itemname[#itemname][4] = 10000;
        itemname[#itemname][5] = money;

        totalMoney = totalMoney - money;
    end
    
    -- 남은 금액있으면 마지막 5개째에 몰아넣기
    if totalMoney > 0 then
        local moneyType = CalcVisSize(totalMoney);
        itemname[#itemname + 1] = {};
        itemname[#itemname][1] = moneyType;
        itemname[#itemname][2] = 'Money_Low';
        itemname[#itemname][3] = 'Money';
        itemname[#itemname][4] = 10000;
        itemname[#itemname][5] = money;
    end

    return itemname;
end

function DEAD_SLOW_MOTION(self, factor, time)

    if FindCmdLine("-VIDEOTEST") > 0 then
        return;
    end

    local key = GenerateSyncKey(self);
    StartSyncPacket(self, key);
    SlotMotion(self, factor, time);
    EndSyncPacket(self, key);
    SyncPacketByHit(self, key);

    if GetLayer(self) > 0 then
        local list, cnt = GetLayerPCList(self);     
        for i = 1, cnt do
            SetExProp(list[i], "SLOW_TIME", imcTime.GetAppTime() + time);
        end     
    end
end





function GET_MONSTER_SUPER_DROP_ITEM_LIST(self, list, owner)
    if list == 'None' then
        return
    end
    
    local cnt, droptype = GET_SUPERDROP(self);  
    
    if GetExProp_Str(self, "CHANGE_MON") ~= "None" then
        list = GetExProp_Str(self, "CHANGE_MON");
    end
    
    local itemname = {};
    local drop_sObj = CREATE_SOBJ(owner, 'ssn_drop')
    if drop_sObj == nil then
        return;
    end

    local bonusMoney = 0;

    local clsList, cnt  = GetClassList("MonsterDropItemList_" .. list);
    for i = 0 , cnt - 1 do

        local drop = GetClassByIndexFromList(clsList, i);
        local rate = IMCRandom(1,10000)
        local ratio
        local itemcount = 1
        local result_ratio, index
        local dropItemList = self.DropItemList; 

        if drop ~= nil then
            if TryGetProp(drop,'Zone') == 'None' or SCR_MON_DROP_ZONE_VALID(self,drop) == 'YES' then
                local loopCount = 0;
                local drop_bonus = drop_sObj[drop.Type..'_BN']

                local drop_ratio = drop.DropRatio
                if drop_ratio ~= 0 then
                local drop_classname = drop.ItemClassName
                    
                ratio = drop_ratio + math.floor(drop_ratio *  drop_bonus / 100)

                ratio = ratio * JAEDDURY_DROP_ITEM_RATE;        -- JAEDDURY : 일반 아이템 드랍율 조절. (monsterdroplist.xml에 등록된 아이템)
                
                    if drop.Type == 'Money_Hi' or drop.Type == 'Money_Mid' or drop.Type == 'Money_Low' then
                        if drop.Type == 'Money_Hi' then
                            if index ~= nil and index > 0 then
                                drop_sObj['Money_Session'..index] = drop_sObj['Money_Session'..index] + 1
                                SaveSessionObject(owner, drop_sObj)
                            end
                        end

                        local min_count = drop.Money_Min
                        local max_count = drop.Money_Max
                        
                        itemcount = IMCRandom(min_count, max_count)

                        itemcount = itemcount * JAEDDURY_GOLD_RATE;         -- JAEDDURY : 드랍되는 골드량을 조절.

                        if droptype == 1 then
                            itemcount = itemcount * 20
                            loopCount = 50;
                        elseif droptype == 0  then
                            itemcount = itemcount * 5
                            loopCount = 20;
                        end
                        
                        if itemcount <= 0 then
                            itemcount = 1
                        end

                        -- 돈금액에따른 아이템 종류/크기 구분
                        if drop_classname == 'Moneybag2' then
                            drop_classname = CalcVisSize(itemcount);
                        end
                    end

                    local dpkValue = (drop.DPK_Min + drop.DPK_Max) / 2;

                    if drop.Type == "Item" then
                        if droptype == 1 then   -- 초대박 슈퍼드랍일때
                            if drop.DropRatio <= 50 or dpkValue > 200 then
                                if dpkValue == 0 then
                                    dpkValue = 1;
                                end
                                local maxRatio = (drop.DropRatio / 10000) * (1 / dpkValue);
                                maxRatio = maxRatio * 100 * 1000;   
                                local result = IMCRandom(1, 10000);
                                if result <= maxRatio then
                                    loopCount = 1;
                                end
                            elseif drop.DropRatio <= 500 or dpkValue > 20 then
                                loopCount = IMCRandom(2, 3);
                            else
                                if dpkValue == 0 then
                                    dpkValue = 1;
                                end
                                local maxRatio = (drop.DropRatio / 10000) * (1 / dpkValue);
                                loopCount = maxRatio * 50;
                                if loopCount > 15 then
                                    loopCount = 15;
                                end
                            end
                        else
                            if drop.DropRatio <= 50 or dpkValue > 200 then
                                if dpkValue == 0 then
                                    dpkValue = 1;
                                end
                                local maxRatio = (drop.DropRatio / 10000) * (1 / dpkValue);
                                maxRatio = maxRatio * 100 * 100; 
                                local result = IMCRandom(1, 10000);
                                if result <= maxRatio then
                                    loopCount = 1;
                                end
                            elseif drop.DropRatio <= 500 or dpkValue > 20 then
                                loopCount = 1;
                            else
                                if dpkValue == 0 then
                                    dpkValue = 1;
                                end
                                local maxRatio = (drop.DropRatio / 10000) * (1 / dpkValue);
                                loopCount = maxRatio * 10;
                                if loopCount > 15 then
                                    loopCount = 15;
                                end
                            end
                        end
                    end

                    for j = 1, loopCount do 
                        AddMonDropList(self, dropItemList, drop_classname, itemcount, drop.ClassID, 1);
                    end

                end
            end
        end
        end
    SaveSessionObject(owner, drop_sObj)
    SetExProp(self, "SUPER_DROP", 1)
        
    return itemname;
end



function SCR_LOOTING_CHANCE_CALC(owner, drop_ratio)
	local LootingChance = TryGetProp(owner, 'LootingChance');
	if LootingChance == nil then
		LootingChance = 0;
	end
	
	if LootingChance > 4000 then
		LootingChance = 4000;
	end
	
	LootingChance = LootingChance / 1000;
	
	drop_ratio = drop_ratio * (1 + LootingChance);
    
    return drop_ratio;
end

-- 드롭 그룹 시스템 시작 --
function SCR_DROP_GROUP_CALC(drop_group, drop_classname)
	local dropGroupClassList, dropGroupCount = GetClassList(drop_group);
	if dropGroupClassList ~= nil then
		-- 드롭 그룹 만들기 --
		local dropGroupList = { };
		local totalGroupRatio = 0;
		for i = 0, dropGroupCount - 1 do
    		local dropGroupClass = GetClassByIndexFromList(dropGroupClassList, i)
    		if dropGroupClass ~= nil then
    			local groupItem = { };
    			groupItem[1] = TryGetProp(dropGroupClass, 'ItemClassName');
    			groupItem[2] = TryGetProp(dropGroupClass, 'DropRatio');
    			if groupItem[2] ~= nil then
    				groupItem[2] = groupItem[2] + totalGroupRatio;
    			end
    			
    			if groupItem[1] ~= nil and groupItem[2] ~= nil then
    				dropGroupList[#dropGroupList + 1] = groupItem;
    				totalGroupRatio = groupItem[2];
    			end
    		end
    	end
    	
    	-- 드롭 아이템 선택 --
    	if totalGroupRatio > 0 then
    		local groupRandom = IMCRandom(1, totalGroupRatio)
    		for j = 1, #dropGroupList do
    			if dropGroupList[j][2] >= groupRandom then
    				drop_classname = dropGroupList[j][1];
    				break;
    			end
    		end
    	end
	end
    
    return drop_classname;
end
-- 드롭 그룹 시스템 끝 --