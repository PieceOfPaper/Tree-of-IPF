-- equipbosscard_effect.lua

-- self, target, obj, TypeValue, arg1, arg2, arg3
-- typevalue : CardCount/StarCount/MaxStar

-- arg1 : nil
function SCR_CARDEFFECT_STATUS_RATE_HP_SP(self, target, obj, TypeValue, arg1, arg2, arg3)
    SCR_CARDEFFECT_STATUS_RATE(self, target, obj, TypeValue, 'RHP_BM', 'RHP', 'None')
    SCR_CARDEFFECT_STATUS_RATE(self, target, obj, TypeValue, 'RSP_BM', 'RSP', 'None')
end

-- arg1 : status_bm
-- arg2 : status
-- arg3 : coeffitient
function SCR_CARDEFFECT_STATUS_RATE(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TryGetProp(self, arg1) ~= nil and TryGetProp(self, arg2) ~= nil and TypeValue ~= nil then
        if arg3 == 'None' then
            arg3 = 1;
        end
        
        self[arg1] = self[arg1] + (TypeValue / 100 * arg3);
        Invalidate(self, arg2);
    end
end

-- arg1 : status_bm
-- arg2 : None or status
-- arg3 : coeffitient
function SCR_CARDEFFECT_STATUS_PLUS(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TryGetProp(self, arg1) ~= nil and TypeValue ~= nil then
        if arg3 == 'None' then
            arg3 = 1;
        end
        local arg3_int = arg3

        if TypeValue < 0 then
            arg3_int = math.ceil(TypeValue * arg3)
        elseif TypeValue >= 0 then
            arg3_int = math.floor(TypeValue * arg3)
        end
        
        self[arg1] = self[arg1] + arg3_int;        
        
        if arg2 ~= 'None' then
            if arg2 == "PATK" or arg2 == "MATK" or arg2 == "PATK_SUB" then
                Invalidate(self, "MAX" .. arg2);
                Invalidate(self, "MIN" .. arg2);
            end
            Invalidate(self, arg2);
        else
            InvalidateStates(self);
        end
    end
end

-- arg1 : immune
-- arg2 : None or status
-- arg3 : coeffitient
function SCR_CARDEFFECT_STATUS_IMMUNE(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TryGetProp(self, arg1) ~= nil and TypeValue ~= nil then
        if arg3 == 'None' then
            arg3 = 1;
        end
        self[arg1] = self[arg1] + math.floor(TypeValue * arg3 * 100);
        if arg2 ~= 'None' then
            Invalidate(self, arg2);
        else        
            InvalidateStates(self);
        end
    end
end

-- arg1 : status_bm
-- arg2 : None or status
-- arg3 : coeffitient
function SCR_CARDEFFECT_STATUS_PLUS_TYPE_SECOND(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TryGetProp(self, arg1) ~= nil and TypeValue ~= nil then
        if arg3 == 'None' then
            arg3 = 1;
        end
        self[arg1] = self[arg1] + math.floor((TypeValue * 1000) * arg3);        
        if arg2 ~= 'None' then
            Invalidate(self, arg2);
        else        
            InvalidateStates(self);
        end
    end
end

-- arg1 : status_bm
-- arg2 : None or status
-- arg3 : coeffitient
function SCR_CARDEFFECT_STATUS_MINUS(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TryGetProp(self, arg1) ~= nil and TypeValue ~= nil then
        if arg3 == 'None' then
            arg3 = 1;
        end
        self[arg1] = self[arg1] - math.floor(TypeValue * arg3);         
        if arg2 ~= 'None' then
            Invalidate(self, arg2);
        else        
            InvalidateStates(self);
        end
    end
end

-- arg1 : buffname
-- arg2 : buffArg2
-- arg3 : time
function SCR_CARDEFFECT_ADD_BUFF_MONSTER(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue > 0 then
        if GetRelation(self, target) == "ENEMY" then
            if obj.ClassName ~= "Default" then
                AddBuff(self, target, arg1, 1, arg2, arg3, 1);
            end
        end
    else
        RemoveBuff(self, arg1);
    end
end

-- arg1 : buffname
-- arg2 : buffArg2
-- arg3 : time
function SCR_CARDEFFECT_ADD_BUFF_PC(self, target, obj, TypeValue, arg1, arg2, arg3) 
    if TypeValue > 0 then
        AddBuff(self, self, arg1, 1, arg2, arg3, 1);
    else
        RemoveBuff(self, arg1)
    end
end

-- arg1 : buffname
-- arg2 : buffArg2 ex.( Size/Type/Race/Attribute )
function SCR_CARDEFFECT_ADD_BUFF_PC_DAMAGE(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue > 0 then
        AddBuff(self, self, arg1, TypeValue, arg2, 0, 1);
    else
        RemoveBuff(self, arg1)
    end
end

-- arg1 : buffname
-- arg2 : buffArg2 ex.( Size/Type/Race/Attribute )
function SCR_CARDEFFECT_ADD_DAMAGE_RATE_BM(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue > 0 then
        local cardDamageRate = GetExProp(self, "CARD_DAMAGE_RATE_BM");
        if cardDamageRate == nil then
            cardDamageRate = 0;
        end
        
        local arg3_int = arg3

        if TypeValue < 0 then
            arg3_int = math.ceil(TypeValue * arg3)
        elseif TypeValue >= 0 then
            arg3_int = math.floor(TypeValue * arg3)
        end

        local addRate = arg3_int;
        
        local rateValue = cardDamageRate + addRate;
        SetExProp(self, "CARD_DAMAGE_RATE_BM", rateValue)
    end
end

-- arg1 : buffname
-- arg2 : buffArg2
-- arg3 : time
function SCR_CARDEFFECT_ADD_BUFF_PC_PLUS(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue > 0 then 
        local plus = TypeValue;
        AddBuff(self, self, arg1, plus, arg2, arg3, 1);
    else
        RemoveBuff(self, arg1);
    end
end

-- arg1 : buffname
-- arg2 : buffArg2
-- arg3 : time
function SCR_CARDEFFECT_ADD_BUFF_PC_PLUS_MANTICEN(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue > 0 then
        local plus = math.floor(TypeValue / 5);
        AddBuff(self, self, arg1, plus, arg2, arg3, 1);
    else
        RemoveBuff(self, arg1);
    end
end

-- arg1 : buffname
-- arg2 : status
-- arg3 : time
function SCR_CARDEFFECT_ADD_BUFF_PC_RATE(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TryGetProp(self, arg2) ~= nil then
        if TypeValue > 0 then
            AddBuff(self, self, arg1, TypeValue, arg2, arg3, 1);
        else
            RemoveBuff(self, arg1);
        end
    end
end

-- arg1 : nil
-- arg2 : nil
-- arg3 : nil
function SCR_CARDEFFECT_ADDITIONAL_BLIND(self, target, obj, TypeValue, arg1, arg2, arg3)
    local time = 7000;
    local range = 80;
    local enemyList, count = SelectObjectNear(self, target, range, 'ENEMY');
    for i=1, count do
        local enemy = enemyList[i];
        SCR_CARDEFFECT_ADD_BUFF_MONSTER(self, enemy, obj, TypeValue, "UC_blind", arg2, time)
    end 
end

-- obj : skill
-- arg1 : nil
-- arg2 : nil
-- arg3 : nil
function SCR_CARDEFFECT_ADDITIONAL_SPLASH(self, target, obj, TypeValue, arg1, arg2, arg3)
    local maxCount = 5;
    local damage = SCR_LIB_ATKCALC_RH(self, obj);
    local range = 80;
    local enemyList, count = SelectObjectNear(self, target, range, 'ENEMY');

    for i=1, math.min(count, maxCount) do
        local enemy = enemyList[i];     
        PlayEffect(enemy, 'F_buff_explosion_burst', 1.3);
        TakeDamage(self, enemy, "None", damage);    
    end
end

-- arg1 : potionGroup
function SCR_CARDEFFECT_ITEM_EFFECTIVE(self, target, obj, TypeValue, arg1, arg2, arg3)

    if arg1 == 'HPPOTION' then
        self.HPPotion_BM = self.HPPotion_BM + TypeValue;
    elseif arg1 == 'SPPOTION' then
        self.SPPotion_BM = self.SPPotion_BM + TypeValue;
    elseif arg1 == 'STAPOTION' then 
        self.STAPotion_BM = self.STAPotion_BM + TypeValue;
    end
end

-- arg1 : itemName
-- arg2 : itemCount
function SCR_CARDEFFECT_GET_ITEM(self, target, obj, TypeValue, arg1, arg2, arg3)
    RunScript('GIVE_ITEM_TX', self, arg1, arg2, "CARDEFFECT_GET_ITEM");
end

-- arg1 : nil
-- arg2 : nil
-- arg3 : nil
function SCR_CARDEFFECT_GET_ITEM_WOOD(self, target, obj, TypeValue, arg1, arg2, arg3)

    local count = 1;
    local random = IMCRandom(1, 4);
    local wood = 'wood_0' .. random;

    SCR_CARDEFFECT_GET_ITEM(self, target, obj, TypeValue, wood, count, arg3)
end

-- arg1 : rate
function SCR_CARDEFFECT_RECOVER_SP(self, target, obj, TypeValue, arg1, arg2, arg3)
    local msp = TryGetProp(self, 'MSP');    
    if msp ~= nil and arg1 ~= nil then
        local healSp = math.floor(msp * arg1 / 100); 

        HealSP(self, healSp, 0);
        
        local nowtime = imcTime.GetAppTimeMS();
        SetExProp(self, "CARD_EFFECT_ACTIVE", nowtime)
    end
end

function SCR_CARDEFFECT_REFLECT(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue > 0 then
        SetExProp(self, "CARD_REFLECT_RATE"..arg1, TypeValue)
        SetExProp_Str(self, "CARD_REFLECT_ATTRIBUTE"..arg1, arg2)
        SetExProp(self, "CARD_REFLECT_DAMAGE_RATE"..arg1, arg3)

        AddBuff(self, self, arg1, arg2, arg3, 0, 1);
    else
        RemoveBuff(self, arg1);
    end
end

-- arg1 : nil
function SCR_CARDEFFECT_REVIVAL(self, target, obj, TypeValue, arg1, arg2, arg3)
    if IsDead(self) == 1 then 
        if TypeValue ~= nil then
             RunScript("SCR_CARDEFFECT_REVIVAL_SUB", self, TypeValue)
        end
    end
end

function SCR_CARDEFFECT_REVIVAL_SUB(self, TypeValue)
    ResurrectPc(self, "SCR_CARDEFFECT_REVIVAL", 2, TypeValue);
    if IsPVPServer(self) == 1 then 
        local durahanCardCount = GetExProp(self, "DURAHAN_CARD_COUNT") + 1
        SetExProp(self, "DURAHAN_CARD_COUNT", durahanCardCount)
    end
    sleep(1000);
    PlayEffect(self, "F_cleric_resurrection_shot", 1);
end

function SCR_CARDEFFECT_AS_BACK_ATTACK(self, target, obj, TypeValue, arg1, arg2, arg3)
    SetExProp(self, "IS_BACKATTACK", 1);
end

--????��? ???????? ?????? arg1?? ???????? ?????? ??��?.
function SCR_CARDEFFECT_DEAD_PART_GET(self, target, obj, TypeValue, arg1, arg2, arg3)
    
    local totalCount = 300;

    local etc = GetETCObject(self);
    if etc == nil then
        return 0;
    end

    local monID = target.ClassID;

    local curPartsCnt = 0;
    local monCls = GetClassByType("Monster", monID);
    if monCls == nil then
        return 0;
    end
    
    curPartsCnt = etc.Necro_DeadPartsCnt + 1

    if curPartsCnt > totalCount then
        return 0;
    end

    local arg1List = StringSplit(arg1, ';');
    arg1 = arg1List[1];

    for i = 1, arg1 do
        etc["NecroDParts_"..curPartsCnt] = monID
        etc.Necro_DeadPartsCnt = etc.Necro_DeadPartsCnt + 1;
    
        SendProperty(self, etc);
        SendAddOnMsg(self, "UPDATE_NECRONOMICON_UI");
    end
end

-- arg1 : amount of increase
function SCR_CARDEFFECT_WUGUSHI_POISON_GET(self, target, obj, TypeValue, arg1, arg2, arg3)
    local etc = GetETCObject(self)
    local poisonAmount = tonumber( etc['Wugushi_PoisonAmount'] )
    local etcpoisonMaxAmount = tonumber( etc['Wugushi_PoisonMaxAmount'] )

    if poisonAmount == nil or etcpoisonMaxAmount == nil then
        return;
    end
    poisonAmount = poisonAmount + arg1;
    if poisonAmount <= etcpoisonMaxAmount then
        etc['Wugushi_PoisonAmount'] = poisonAmount;
    end
    
    SendProperty(self, etc);
    SendAddOnMsg(self, "MSG_UPDATE_POISONPOT_UI", "", 0);
end

-- arg3 : ratio (n%)
function SCR_CARDEFFECT_ADD_HATE_RATE(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue ~= nil then
        local cardHateRate = GetExProp(self, "CARD_HATE_RATE", hateValue);
        if cardHateRate == nil then
            cardHateRate = 0;
        end
        
        local addHate = TypeValue * arg3;
        
        local hateValue = cardHateRate + addHate;

        SetExProp(self, "CARD_HATE_RATE", hateValue);
    end
end

-- arg1 : keyward (ex : Wound, Poison... or BuffName)
-- arg2 : keyward Type (ex : ClassName, Keyword..)
-- arg3 : ratio (n%)
function SCR_CARDEFFECT_DAMAGE_RATE_BY_BUFF(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue ~= nil then
        if GetBuffByProp(target, arg2, arg1) ~= nil then
            local cardDamageRate = GetExProp(self, "CARD_DAMAGE_RATE_BM");
            if cardDamageRate == nil then
                cardDamageRate = 0;
            end
            
            local addRate = TypeValue * arg3;
            local rateValue = cardDamageRate + addRate;
            SetExProp(self, "CARD_DAMAGE_RATE_BM", rateValue);
        end
    end
end


function SCR_CARDEFFECT_STATUS_DUAL_PLUS(self, target, obj, TypeValue, arg1, arg2, arg3)
    local arg1List = StringSplit(arg1, "/");
    
    local arg3List = { };
    if arg3 ~= "None" then
        arg3List = StringSplit(arg3, "/");
    end
    
    if arg1List ~= nil and #arg1List >= 1 then
        local arg2List = StringSplit(arg2, "/");
        for i =1, #arg1List do
            if TryGetProp(self, arg1List[i]) ~= nil and TypeValue ~= nil then
                if arg3List[i] == nil then
                    arg3List[i] = 1;
                end
                
                local arg3_int = arg3List[i];

                if TypeValue < 0 then
                    arg3_int = math.ceil(TypeValue * arg3List[i]);
                elseif TypeValue >= 0 then
                    arg3_int = math.floor(TypeValue * arg3List[i]);
                end
                
                self[arg1List[i]] = self[arg1List[i]] + arg3_int;
                if arg2 ~= 'None' then
                    if arg2List[i] == "PATK" or arg2List[i] == "MATK" or arg2List[i] == "PATK_SUB" then
                        Invalidate(self, "MAX" .. arg2List[i]);
                        Invalidate(self, "MIN" .. arg2List[i]);
                    end

                    Invalidate(self, arg2List[i]);
                    
                end
            end
        end
        
        if arg2 == "None" then
            InvalidateStates(self);
        end
    end
end

function SCR_CARDEFFECT_ATK_SPEED(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue ~= nil then
        local basicatkspd = 0;
        local addspdrate = TypeValue * arg3;
        local addspd = basicatkspd - addspdrate;
        SET_NORMAL_ATK_SPEED(self, addspd)
    end
end

function SCR_CARDEFFECT_ATK_PLUS(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TryGetProp(self, arg1) ~= nil and TypeValue ~= nil then
        if arg3 == 'None' then
            arg3 = 1;
        end
    
        self[arg1] = self[arg1] +  math.floor(TypeValue * arg3);
        
        if arg2 ~= 'None' then
            if arg2 == "PATK" or arg2 == "MATK" or arg2 == "PATK_SUB" then
                Invalidate(self, "MAX" .. arg2);
                Invalidate(self, "MIN" .. arg2);
            end
            Invalidate(self, arg2);
        else
            InvalidateStates(self);
        end
    end
end

function SCR_CARDEFFECT_DEF_FACTOR_PLUS(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TryGetProp(self, arg1) ~= nil and TypeValue ~= nil then
        if arg3 == 'None' then
            arg3 = 1;
        end

        self[arg1] = self[arg1] + (TypeValue * arg3);

        if arg2 ~= 'None' then
            if arg2 == "PATK" or arg2 == "MATK" or arg2 == "PATK_SUB" then
                Invalidate(self, "MAX" .. arg2);
                Invalidate(self, "MIN" .. arg2);
            end
            Invalidate(self, arg2);
        else
            InvalidateStates(self);
        end
    end
end


function SCR_CARDEFFECT_SUB_PATK_PLUS(self, target, obj, TypeValue, arg1, arg2, arg3)
local arg1List = StringSplit(arg1, "/");
    
    if arg1List ~= nil and #arg1List >= 1 then
        local arg2List = StringSplit(arg2, "/");
        for i =1, #arg1List do
            if TryGetProp(self, arg1List[i]) ~= nil and TypeValue ~= nil then
                if arg3 == 'None' then
                    arg3 = 1;
                end
                
                local arg3_int = arg3

                if TypeValue < 0 then
                    arg3_int = math.ceil(TypeValue * arg3)
                elseif TypeValue >= 0 then
                    arg3_int = math.floor(TypeValue * arg3)
                end

                self[arg1List[i]] = self[arg1List[i]] + arg3_int;
  
                if arg2 ~= 'None' then
                    if arg2List[i] == "PATK_SUB" then
                        Invalidate(self, "MAX"..arg2List[i]);
                        Invalidate(self, "MIN"..arg2List[i]);
                    end
                    Invalidate(self, arg2List[i]);
                end
            end
        end
        
        if arg2 == "None" then
            InvalidateStates(self);
        end
    end
end

function SCR_CARDEFFECT_RECOVER_HP(self, target, obj, TypeValue, arg1, arg2, arg3)
    local mhp = TryGetProp(self, 'MHP');    
    if mhp ~= nil and arg1 ~= nil then
        local healhp = math.floor(mhp * arg1 / 100); 

        Heal(self, healhp, 0);
        
        local nowtime = imcTime.GetAppTimeMS();
        SetExProp(self, "CARD_EFFECT_ACTIVE", nowtime)
    end
end

function SCR_CARDEFFECT_STATUS_DUAL_IMMUNE(self, target, obj, TypeValue, arg1, arg2, arg3)
    local arg1List = StringSplit(arg1, "/");
    
    local arg3List = { };
    if arg3 ~= "None" then
        arg3List = StringSplit(arg3, "/");
    end
    
    if arg1List ~= nil and #arg1List >= 1 then
        local arg2List = StringSplit(arg2, "/");
        for i =1, #arg1List do
            if TryGetProp(self, arg1List[i]) ~= nil and TypeValue ~= nil then
                if arg3List[i] == nil then
                    arg3List[i] = 1;
                end
                
                local arg3_int = arg3List[i];

                if TypeValue < 0 then
                    arg3_int = math.ceil(TypeValue * arg3List[i] * 100);
                elseif TypeValue >= 0 then
                    arg3_int = math.floor(TypeValue * arg3List[i] * 100);
                end
                
                self[arg1List[i]] = self[arg1List[i]] + arg3_int;
                if arg2 ~= 'None' then
                    
                    Invalidate(self, arg2List[i]);
                    
                end
            end
        end
        
        if arg2 == "None" then
            InvalidateStates(self);
        end
    end
end


function SCR_CARDEFFECT_PATK_PLUS(self, target, obj, TypeValue, arg1, arg2, arg3)
local arg1List = StringSplit(arg1, "/");
    
    if arg1List ~= nil and #arg1List >= 1 then
        local arg2List = StringSplit(arg2, "/");
        for i =1, #arg1List do
            if TryGetProp(self, arg1List[i]) ~= nil and TypeValue ~= nil then
                if arg3 == 'None' then
                    arg3 = 1;
                end
                
                local arg3_int = arg3

                if TypeValue < 0 then
                    arg3_int = math.ceil(TypeValue * arg3)
                elseif TypeValue >= 0 then
                    arg3_int = math.floor(TypeValue * arg3)
                end

                self[arg1List[i]] = self[arg1List[i]] + arg3_int;
  
                if arg2 ~= 'None' then
                    if arg2List[i] == "PATK" then
                        Invalidate(self, "MAX"..arg2List[i]);
                        Invalidate(self, "MIN"..arg2List[i]);
                    end
                    Invalidate(self, arg2List[i]);
                end
            end
        end
        
        if arg2 == "None" then
            InvalidateStates(self);
        end
    end
end

function SCR_CARDEFFECT_MATK_PLUS(self, target, obj, TypeValue, arg1, arg2, arg3)
    local arg1List = StringSplit(arg1, "/");
    
    if arg1List ~= nil and #arg1List >= 1 then
        local arg2List = StringSplit(arg2, "/");
        for i =1, #arg1List do
            if TryGetProp(self, arg1List[i]) ~= nil and TypeValue ~= nil then
                if arg3 == 'None' then
                    arg3 = 1;
                end
                
                local arg3_int = arg3

                if TypeValue < 0 then
                    arg3_int = math.ceil(TypeValue * arg3)
                elseif TypeValue >= 0 then
                    arg3_int = math.floor(TypeValue * arg3)
                end
                
                self[arg1List[i]] = self[arg1List[i]] + arg3_int;
  
                if arg2 ~= 'None' then
                    if arg2List[i] == "MATK" then
                        Invalidate(self, "MAX"..arg2List[i]);
                        Invalidate(self, "MIN"..arg2List[i]);
                    end
                    Invalidate(self, arg2List[i]);
                end
            end
        end
        
        if arg2 == "None" then
            InvalidateStates(self);
        end
    end
end

function SCR_CARDEFFECT_BE_FIXED_RECOVER_HP(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue ~= nil then
        if arg3 == 'None' then
            arg3 = 1;
        end
        
        local healhp = math.floor(TypeValue * arg3);
        
        AddHP(self, healhp, 0)
        
        local nowtime = imcTime.GetAppTimeMS();
        SetExProp(self, "CARD_EFFECT_ACTIVE", nowtime)
    end
end

function SCR_CARDEFFECT_SHIELD(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue ~= nil then
        if arg3 == 'None' then
            arg3 = 1;
        end
        
        local shieldValue = math.floor(TypeValue * arg3);
        AddBuff(self, self, "CARD_Shield",1,shieldValue,10000)
    end
end

function SCR_CARDEFFECT_STATUS_ALL_PLUS(self, target, obj, TypeValue, arg1, arg2, arg3)
    local arg1List = { };
    if arg1 ~= "None" then
        arg1List = StringSplit(arg1, "/");
    end
    
    local arg3List = { };
    if arg3 ~= "None" then
        arg3List = StringSplit(arg3, "/");
    end
    
    if arg1List ~= nil and #arg1List >= 1 then
        local arg2List = StringSplit(arg2, "/");
        for i =1, #arg1List do
            if TryGetProp(self, arg1List[i]) ~= nil and TypeValue ~= nil then
                if arg3List[i] == nil then
                    arg3List[i] = 1;
                end
                
                local arg3_int = arg3List[i];

                if TypeValue < 0 then
                    arg3_int = math.ceil(TypeValue * arg3List[i]);
                elseif TypeValue >= 0 then
                    arg3_int = math.floor(TypeValue * arg3List[i]);
                end

                self[arg1List[i]] = self[arg1List[i]] + arg3_int;

                if arg2 ~= 'None' then
                    InvalidateStates(self, arg2List[i]);
                end
            end
        end
        
        if arg2 == "None" then
            InvalidateStates(self);
        end
    end
end

function SCR_CARDEFFECT_ADD_BUFF_PC_STAT(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TryGetProp(self, arg2) ~= nil then
        if TypeValue > 0 then
            local addstat = math.floor(TypeValue * 1.5);
            AddBuff(self, self, arg1, addstat, arg2, arg3, 1);
        else
            RemoveBuff(self, arg1);
        end
    end
end

function SCR_CARDEFFECT_CRITICAL_ATTACK(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue ~= nil then
        if arg3 == 'None' then
            arg3 = 1;
        end
        
        local ratio = TypeValue * 2
        local maxRatio = IMCRandom(1, 100);
        
        if ratio >= maxRatio then
            SetExProp(self, "IS_CRITICAL", 1)
        end
    end
end

function SCR_CARDEFFECT_BE_FIXED_RECOVER_SP_LEGEND(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue ~= nil then
        if arg3 == 'None' then
            arg3 = 1;
        end
        
        local healSP = math.floor(TypeValue * arg3);
        AddSP(self, healSP, 0)
    end
end

function SCR_CARDEFFECT_ATTRIBUTE_PENALTY_REDUCTION(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue ~= nil then
        if arg3 == 'None' then
            arg3 = 1;
        end
        
        local reduction = math.floor(TypeValue * arg3);
        local attributePenaltyReductionRate = GetExProp(self, 'CARD_ATTRIBUTE_PENALTY_REDUCTION');
        SetExProp(self, 'CARD_ATTRIBUTE_PENALTY_REDUCTION', attributePenaltyReductionRate + reduction);
    end
end

function SCR_CARDEFFECT_ADD_NO_TIME_BUFF_PC(self, target, obj, TypeValue, arg1, arg2, arg3) 
    if TypeValue == 10 or TypeValue == -10 then
        arg1 = arg1.."LV10"
    elseif TypeValue == 9 or TypeValue == -9 then
        arg1 = arg1.."LV9"
    elseif TypeValue == 8 or TypeValue == -8 then
        arg1 = arg1.."LV8"
    elseif TypeValue == 7 or TypeValue == -7 then
        arg1 = arg1.."LV7"
    elseif TypeValue == 6 or TypeValue == -6 then
        arg1 = arg1.."LV6"
    elseif TypeValue == 5 or TypeValue == -5 then
        arg1 = arg1.."LV5"
    elseif TypeValue == 4 or TypeValue == -4 then
        arg1 = arg1.."LV4"
    elseif TypeValue == 3 or TypeValue == -3 then
        arg1 = arg1.."LV3"
    elseif TypeValue == 2 or TypeValue == -2 then
        arg1 = arg1.."LV2"
    elseif TypeValue == 1 or TypeValue == -1 then
        arg1 = arg1.."LV1"
    end
    
    if TypeValue > 0 then
        AddBuff(self, self, arg1, 1, arg2, 0, 1);
    else
        RemoveBuff(self, arg1)
    end
end

function SCR_CARDEFFECT_DAMAGE_REDUCTION_RATE_FROM_PC(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue ~= 0 then
        if arg3 == "None" then
            arg3 = 0;
        end
        
        local reduction = math.floor(TypeValue * arg3);
        local damageReductionRateFromPC = GetExProp(self, "DAMAGE_REDUCTION_RATE_FROM_PC");
        SetExProp(self, "DAMAGE_REDUCTION_RATE_FROM_PC", damageReductionRateFromPC + reduction);
    end
end

function SCR_CARDEFFECT_DAMAGE_REDUCTION_RATE_FROM_MON(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue ~= 0 then
        if arg3 == "None" then
            arg3 = 0;
        end
        
        if TypeValue > 0 then
            tonumber(TypeValue)
            AddBuff(self, self, arg1, TypeValue, 0, 0, 1);
        else
            RemoveBuff(self, arg1)
        end
    end
end

function SCR_CARDEFFECT_SUMMON_ATK_RANGE(self, target, obj, TypeValue, arg1, arg2, arg3)
    if TypeValue ~= 0 then
        if arg3 == "None" then
            arg3 = 0;
        end
        
        local aveAtk = TypeValue * arg3
        local aveAtkFromPC = GetExProp(self, "MON_AVERAGE_ATK_FROM_PC");

        SetExProp(self, "MON_AVERAGE_ATK_FROM_PC", aveAtkFromPC + aveAtk);
    end
end