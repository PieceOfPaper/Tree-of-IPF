--- hardskill_linker.lua

function SKL_MAKE_LINK(self, skl, dist1, angle1, height1, height, width, tgtType, buffName, maxTime, splashRange, addCaster, linkCnt, linkName, cancelByMove, linkSecond, linkEft, linkEftScale, linkSound)
    RemoveLinkByBuffName(self, buffName);
    RemoveLinkByBuffName(self, 'Link_Party');

    local x, y, z = GetPos(self);
    local sx, sz = GetAroundPos(self, math.deg(angle1), dist1);
    local ex, ez = GetAroundPos(self, math.deg(angle1), height);
    local list, cnt = SelectObjectBySquareCoor(self, tgtType, sx, y, sz, ex, y, ez, width, 50); 
    if cnt == 0 then
        return;
    end

    local firstTarget = nil;
    for i=1, cnt do
        if IsSameObject(list[i], self) == 0 then

            local ableLink = true;
            if GetObjType(self) == OT_PC and (buffName == 'Link' or buffName == 'Link_Physical') and IS_PC(list[i]) == false then
                ableLink = false;           
            end
            
            if ableLink == true then
                firstTarget = list[i];
                break;
            end
        end
    end
    
    if firstTarget ~= nil then
        MAKE_LINK_TARGET(self, skl, firstTarget, tgtType, buffName, maxTime, splashRange, addCaster, linkCnt, linkName, cancelByMove, linkSecond, linkEft, linkEftScale, linkSound);
    end
end

function MAKE_LINK_TARGET(self, skl, firstTarget, tgtType, buffName, maxTime, splashRange, addCaster, linkCnt, linkName, cancelByMove, linkSecond, linkEft, linkEftScale, linkSound)
    
    local isBuffIgnore = IsBuffIgnore(firstTarget, buffName);
    if isBuffIgnore == 1 then
        SkillTextEffect(nil, firstTarget, nil, 'SHOW_SKILL_EFFECT', 0, nil, 'Debuff_Resister');
        PlayEffect(firstTarget, "I_sphere001_mash2", 1, 1, 'MID');
        return;
    end

    local cmd = CreateLink(self, linkName, buffName, maxTime, cancelByMove, addCaster, skl.Level);

    local addedLinkObject = 0;
    AddLinkObject(cmd, firstTarget);
    addedLinkObject = addedLinkObject + 1;

    local objList, objCount = SelectObjectNear(self, firstTarget, splashRange, tgtType);
    objCount = math.min(objCount, linkCnt);
    objCount = math.floor(objCount);
    local x, y, z = GetPos(firstTarget);
    local minY, maxY = y, y;
    
    for i = 1 , objCount do
        local tgt = objList[i];
        
        local ableLink = true;
        if (buffName == 'Link' or buffName == 'Link_Physical') and IS_PC(tgt) == false then
            ableLink = false;
        end

        if 0 == IsSameObject(tgt, firstTarget) and ableLink == true then
                    
            local isBuffIgnore = IsBuffIgnore(tgt, buffName);
            if isBuffIgnore == 1 then
                SkillTextEffect(nil, tgt, nil, 'SHOW_SKILL_EFFECT', 0, nil, 'Debuff_Resister');
                PlayEffect(tgt, "I_sphere001_mash2", 1, 1, 'MID');
            else
                local tgtX, tgtY, tgtZ = GetPos(tgt);
                local beforeMinY, beforeMaxY = minY, maxY;
                if minY > tgtY then
                    minY = tgtY;
                end
                if maxY < tgtY then
                    maxY = tgtY;
                end
    
                if maxY - minY <= 25 then
                    AddLinkObject(cmd, tgt, objCount + addCaster);
                    addedLinkObject = addedLinkObject + 1;
                else
                    minY, maxY = beforeMinY, beforeMaxY;
                end
            end
        end
    end 
    
    if addCaster == 1 and addedLinkObject > 0 then
        StartLink(cmd, linkSecond, linkEft, linkEftScale, linkSound);
    elseif addCaster == 0 and addedLinkObject > 1 then
        StartLink(cmd, linkSecond, linkEft, linkEftScale, linkSound);
    else
        RemoveLink(cmd)
    end
end

function S_R_MAKE_LINK(self, target, skl, ret, tgtType, buffName, maxTime, splashRange, addCaster, linkCnt, linkName, cancelByMove, linkSecond, linkEft, linkEftScale, linkSound)
    NO_HIT_RESULT(ret);
	
    local beforeTime = GetExProp(self, 'R_MAKE_LINK');
    if beforeTime == imcTime.GetAppTime() then
        return;
    end

    SetExProp(self, 'R_MAKE_LINK', imcTime.GetAppTime());
    local buffCls = GetClass("Buff", buffName);
    if buffCls.Duplicate == 0 then
        RemoveBuff(target, buffName);
    end

    local key = GetSkillSyncKey(self, ret);
    StartSyncPacket(self, key);
    MAKE_LINK_TARGET(self, skl, target, tgtType, buffName, maxTime, splashRange, addCaster, linkCnt, linkName, cancelByMove, linkSecond, linkEft, linkEftScale, linkSound);
    EndSyncPacket(self, key);
end


function SKL_MAKE_PARTY_LINK(self, skl, linkRange, buffName, maxTime, linkName, cancelByMove, linkSecond, linkEft, linkEftScale, linkSound)
    RemoveLinkByBuffName(self, buffName);
    RemoveLinkByBuffName(self, 'Link');
    RemoveLinkByBuffName(self, 'Link_Physical');

    local cmd = CreateLink(self, linkName, buffName, maxTime, cancelByMove, 1);
    local addedLinkObject = 1;      
    local objList, objCount = GetPartyMemberList(self, PARTY_NORMAL, linkRange);
    local x, y, z = GetPos(self);
    local minY, maxY = y, y;
    
    for i = 1 , objCount do
        local tgt = objList[i];
        if 0 == IsSameObject(tgt, self) then

            local tgtX, tgtY, tgtZ = GetPos(tgt);
            local beforeMinY, beforeMaxY = minY, maxY;
            if minY > tgtY then
                minY = tgtY;
            end
            if maxY < tgtY then
                maxY = tgtY;
            end
            if maxY - minY <= 25 then
                AddLinkObject(cmd, tgt);
                addedLinkObject = addedLinkObject + 1;
            else
                minY, maxY = beforeMinY, beforeMaxY;
            end
        end
    end 

    if addedLinkObject > 1 then
        StartLink(cmd, linkSecond, linkEft, linkEftScale, linkSound);
    else
        RemoveLink(cmd)
    end
end

function LINK_DESTRUCT(self, buffName)
    local linkCmdCount = GetLinkCmdCount(self, buffName);
    for i=0, linkCmdCount-1 do
        local objList, keyList = MakeLinkSyncPacket(self, buffName, i);
        DestructLink(self, buffName, i, 0, 0, 0, 'None');   
    end
end

function SKL_LINK_DESTRUCT(self, skl, buffName, linkSecond, linkEft, linkEftScale, sound)

    local linkCmdCount = GetLinkCmdCount(self, buffName);
    
    for i=0, linkCmdCount-1 do
        if buffName == "Link_Enemy" and GetAbility(self, 'Linker7') ~= nil then
            local Linker7_abil = GetAbility(self, 'Linker7')
            local damage = self.MAXMATK
            local objList = GetLinkObjectsByCmdIndex(self, buffName, i)
            if objList ~= nil then
                for i = 1, #objList do
                    TakeDamage(self, objList[i], "None", damage * (1 + (Linker7_abil.Level - 1) * 0.1));
                end
            end
        end
        
        DestructLink(self, buffName, i, linkSecond, linkEft, linkEftScale, sound);
    end
    
    local linkBuff = GetBuffByName(self, buffName);
    if nil == linkBuff then
        return;
    end

    local linkOwner = self;
    local caster = GetBuffCaster(linkBuff);
	if caster ~= nil and buffName == "SpiritShock_Debuff" then
		DestructLink(caster, buffName, i, linkSecond, linkEft, linkEftScale, sound);
	end
end

function SKL_LINK_ATTACK(self, skl, buffName, linkSecond, linkEft, linkEftScale, sound)    
    EnableTakeDamageScp(0);
    local linkCmdCount = GetLinkCmdCount(self, buffName);
    for i=0, linkCmdCount-1 do
        local objList, keyList = MakeLinkSyncPacket(self, buffName, i);
        if objList ~= nil then
            for i = 1, #objList do
                local key = keyList[i];
                local actor = objList[i];
                StartSyncPacket(self, key);

                local damage = SCR_LIB_ATKCALC_RH(self, skl);               
                
                TakeDamage(self, actor, skl.ClassName, damage);
                
                EndSyncPacket(self, key);
            end
        end

        DestructLink(self, buffName, i, linkSecond, linkEft, linkEftScale, sound);  
    end
    EnableTakeDamageScp(1);
end

function TAKE_DMG_LINK(self, from, skl, damage, ret)        
    if ret == nil then
        return;
    end

    local buffName = GetExProp_Str(self, "LINK_BUFF");
    local buff = GetBuffByName(self, buffName);
    local caster = GetBuffCaster(buff);
    if caster ~= nil then        
        local objList = GetLinkObjectsWithRelation(caster, self, buff.ClassName, from);
        if objList == nil then
            return;
        end
        
        local skillobjlist = #objList + buff.Lv
        
        local key = GetSkillSyncKey(from, ret);
        StartSyncPacket(from, key);

        EnableTakeDamageScp(0);
        
        for i = 1 , #objList do            
            local obj = objList[i];            
            if 0 == IsSameObject(self, obj) then                
                
                if GetExProp(obj, "LinkDmg_" .. GetHandle(from)) == imcTime.GetAppTime() then
                    break;
                end

                if IsBuffApplied(obj, 'Link') == 'YES' then
                    SetExProp(obj, 'FulldrawLinkState', 1)
                end
                SetExProp(obj, "LinkDmg_" .. GetHandle(from), imcTime.GetAppTime());                
                TakeDamage(from, obj, skl.ClassName, damage, "Melee", "Melee", "TrueDamage", HIT_NOMOTION, HITRESULT_BLOW);             
            end
        end

        EnableTakeDamageScp(1);

        EndSyncPacket(from, key);
    end
    
end

function TAKE_DMG_LINK_PHYSICAL(self, from, skl, damage, ret)    
    
    if ret == nil then
        return;
    end

    local buffName = GetExProp_Str(self, "LINK_BUFF");
    local buff = GetBuffByName(self, buffName);    
    local caster = GetBuffCaster(buff);    
    if caster ~= nil then
        local objList = GetLinkObjectsWithRelation(caster, self, buff.ClassName, from);        
        if objList == nil then
            return;
        end
        
        local skillobjlist = #objList + buff.Lv     
        local divDamage = damage / skillobjlist
        
        if divDamage == 0 then
            return;
        end

		if divDamage < 1 then
            divDamage = 1
        end

        ret.Damage = divDamage;
        damage = damage - divDamage;
    
        local key = GetSkillSyncKey(from, ret);
        StartSyncPacket(from, key);

        EnableTakeDamageScp(0);

        for i = 1 , #objList do
            local obj = objList[i];            
            if 0 == IsSameObject(self, obj) then        
                
                if GetExProp(obj, "LinkDmg_" .. GetHandle(from)) == imcTime.GetAppTime() then
                    break;
                end

                SetExProp(obj, "LinkDmg_" .. GetHandle(from), imcTime.GetAppTime());
                TakeDamage(from, obj, skl.ClassName, divDamage, "Melee", "Melee", "PhysicalLink", HIT_NOMOTION, HITRESULT_BLOW);
        
                damage = damage - divDamage;                
                if damage <= 0 then
                    break;
                end
           end            
        end

        EnableTakeDamageScp(1);

        EndSyncPacket(from, key);
    end
    
end

function SKL_LINK_BUFF(self, skl, linkBuff, buffName, arg1, arg2, buffMS, over)
    BuffToLinkObjectList(self, linkBuff, buffName, arg1, arg2, buffMS, over, 0);
end
    
function SKL_LINK_CASTER_BUFF(self, skl, linkBuff, buffName, arg1, arg2, buffMS, over)
    BuffToLinkObject(self, self, linkBuff, buffName, arg1, arg2, buffMS, over);
end

function SCR_TAKE_DMG_LINK_ENEMY(self, from, skl, damage)
--  local HitType = GET_HIT_TYPE_NUMBER(skl.Attribute)
    NonHitScpTakeDamage(from, self, 'None', damage, skl.Attribute, skl.AttackType, "AbsoluteDamage")
end

function TAKE_DMG_LINK_ENEMY(self, from, skl, damage, ret)
    if ret == nil then
        return;
    end

    if skl.ClassName == 'Oracle_TwistOfFate' or skl.ClassName == 'Linker_HangmansKnot' then
        return;
    end
    
    if GetExProp(self, 'S_R_EXPLODE_DAMAGE') == 1 then
        return;
    end

    local buffName = GetExProp_Str(self, "LINK_ENEMY_BUFF");
    local buff = GetBuffByName(self, buffName);
    local caster = GetBuffCaster(buff);
    if caster == nil then
        return;
    end
    
    local objList = GetLinkObjects(caster, self, buff.ClassName);
    if objList == nil then
        return;
    end

    local key = GetSkillSyncKey(from, ret);
    StartSyncPacket(from, key);

    EnableTakeDamageScp(0);
	local attackerDaddak = GetExProp(from, 'IsDaDak');

    for i = 1 , #objList do
        local obj = objList[i];
        if 0 == IsSameObject(self, obj) and GetRelation(from, obj) == "ENEMY" then
            RunScript('SCR_TAKE_DMG_LINK_ENEMY', obj, from, skl, damage);
            if 1 == attackerDaddak then
                SetExProp(obj, 'AlredyAttackDaddk', 1);
            end
        end
    end
    
    -- steam_different
    TAKE_DMG_LINK_ENEMY_COUNTCHECK(caster, buff)
    --
    EnableTakeDamageScp(1);

    EndSyncPacket(from, key);

end

function TAKE_DMG_LINK_ENEMY_COUNTCHECK(caster, buff)
    
    local count = GetExProp(buff, 'LINK_COUNT');
    count = count - 1;
    
    if count < 1 then
        RemoveLinkCmdByBuff(caster, buff);
    else
        SetExProp(buff, 'LINK_COUNT', count);
    end
    
--  local arg = GetLinkCmdArgByBuff(caster, buff, 'count');
--  arg = arg - 1;
--
--  if arg < 1 then
--      RemoveLinkCmdByBuff(caster, buff);
--  else
--      SetLinkCmdArgByBuff(caster, buff, 'count', arg);
--  end
end

function SKL_LINK_GATHER2(self, skl, buffName, time)
    
    local dist = 150;
    local width = 80;
    local x, y, z = GetPos(self);
    local ex, ey, ez = GetFrontPos(self, dist);
    local list, cnt = SelectObjectBySquareCoor(self, 'ALL', x, y, z, ex, ey, ez, width, 50);    
    if cnt == 0 then
        return;
    end

    local linkActorList = {};
    for i=1, cnt do
        local actor = list[i];
        local buff = GetBuffByName(actor, buffName);
        if buff ~= nil then
            linkActorList[#linkActorList + 1] = actor;
        end
    end

    if #linkActorList == 0 then
        return;
    end

    local xx, yy, zz;
    local minDist = 999999;
    for i=1, #linkActorList do
        local actor = linkActorList[i];
        if actor.MonRank ~= "Boss" then
            dist = GetDistance(self, actor);
            if dist < minDist then
                minDist = dist;
                xx, yy, zz = GetPos(actor);
            end
        end
    end

    if yy == nil then
        for i = 1, #linkActorList do
            local actor = linkActorList[i];
            dist = GetDistance(self, actor);
            if dist < minDist then
                minDist = dist;
                xx, yy, zz = GetPos(actor);
            end
        end
    end
    

    local linkCmdCount = GetLinkCmdCount(self, buffName);
    for i=0, linkCmdCount-1 do

        local objList = GetLinkObjectsByCmdIndex(self, buffName, i);
        if objList ~= nil then
            local listCount = #objList;
            local useSkill = false;
            for j=1, listCount do
                local actor = objList[j];

                for k=1, #linkActorList do
                    if IsSameObject(actor, linkActorList[k]) == 1 then
                        useSkill = true;
                        break;
                    end
                end

                if useSkill == true then
                    break;
                end
            end

            if listCount >= 2 and useSkill == true then

                local linker6_abil = GetAbility(self, 'Linker6');
                local linker2_abil = GetAbility(self, 'Linker2');

                for j = 1, listCount do
                    local actor = objList[j];
                    if actor.MonRank ~= "Boss" then
                    SkillCancel(actor);
                    
                    if IS_PC(actor) == true then
                        Move3DByTime(actor, xx, yy+5, zz, time, 1, 1);
                    else
                        local prop = TryGetProp(actor, "MoveType");
                        if nil == prop then                 
                            IMC_LOG("INFO_NORMAL", "actor.MoveType == nill :: actor.CID = ["..actor.ClassID.."], actor.CName = ["..actor.ClassName.."]" );
                        else
                            if 'Holding' ~= prop then
                                Move3DByTime(actor, xx, yy+5, zz, time, 1, 1);
                            end
                        end
                    end
                    
                    -- steam_different
                    ADDBUFF_HANGMANSKNOT_DEBUFF(self, actor, skl)
                    --
                    
                    local skill = GetSkill(self, "Linker_HangmansKnot")
                    if skill == nil then
                        return
                    end
                    
                    if linker2_abil ~= nil and skill.Level >= 3 then
                        local damage = SCR_LIB_ATKCALC_RH(self, skl);                   
                        damage = damage * linker2_abil.Level * 0.2;
                        if damage < 1 then
                            damage = 1;
                        end
                        
                        AddBuff(self, actor, 'DelayDamage', damage, HIT_BASIC, time * 1000 + 300, 1);
                    end

                    if linker6_abil ~= nil then
                        AddBuff(self, actor, 'Hangmansknot_SDR_Debuff', linker6_abil.Level, 0, 3000, 1);                    
                    end         
                end
            end
        end 
    end
end
end

function ADDBUFF_HANGMANSKNOT_DEBUFF(self, actor, skl)
    AddBuff(self, actor, 'HangmansKnot_Debuff', 1, 0, 1000 + skl.Level * 200, 1);   
end

function SKL_LINK_GATHER(self, skl, buffName, gatherType, time)
    local linkCmdCount = GetLinkCmdCount(self, buffName);
    for i=0, linkCmdCount-1 do

        local objList = GetLinkObjectsByCmdIndex(self, buffName, i);
        if objList ~= nil then
        
            local listCount = #objList;
            if listCount < 2 then
                return;
            end

            local x , y, z = 0, 0, 0;
        
            if gatherType == 0 then 
                for i = 1, listCount do
                    local actor = objList[i];
                    local xx, yy, zz = GetPos(actor);
                
                    x = x + xx;
                    z = z + zz;
                    if y < yy then
                        y = yy;
                    end
                end

                x = x / listCount;
                z = z / listCount;
                        
            elseif gatherType == 1 then 
            
                local from = objList[1];
                x, y, z = GetPos(from);

            elseif gatherType == 2 then     
                x, y, z = GetFrontPos(self, 10);

            end

            
            local linker6_abil = GetAbility(self, 'Linker6');
            local linker2_abil = GetAbility(self, 'Linker2');

            for i = 1, listCount do
                local actor = objList[i];
                SkillCancel(actor);
                Move3DByTime(actor, x, y+5, z, time, 1, 1);
                AddBuff(self, actor, 'HangmansKnot_Debuff', 1, 0, skl.Level * 1000, 1); 
                
                if linker2_abil ~= nil then
                    local damage = SCR_LIB_ATKCALC_RH(self, skl);                   
                    damage = damage * linker2_abil.Level * 0.2;
                    if damage < 1 then
                        damage = 1;
                    end

                    AddBuff(self, actor, 'DelayDamage', damage, HIT_BASIC, time * 1000 + 300, 1);
                end

                if linker6_abil ~= nil then
                    AddBuff(self, actor, 'Hangmansknot_SDR_Debuff', linker6_abil.Level, 0, 3000, 1);                    
                end
            end
        end 
    end
end

function SKL_LINK_ACTOR_SETPOS(self, skl, buffName)
    
    local linkBuff = GetBuffByName(self, buffName);
    if nil == linkBuff then
        return;
    end

    local linkOwner = self;
    local caster = GetBuffCaster(linkBuff);
    if nil ~= caster and caster ~= self then
        linkOwner = caster;
    end
    
    local linkCmdCount = GetLinkCmdCount(linkOwner, buffName);
    for i=0, linkCmdCount-1 do
        local objList = GetLinkObjectsByCmdIndex(linkOwner, buffName, i);
        if objList ~= nil then
        
            local listCount = #objList;
            if listCount < 2 then
                return;
            end

            local x, y, z = GetActorRandomPos(self, 30);
            for i = 1, listCount do
                local actor = objList[i];
                SkillCancel(actor);
                SetPos(actor, x, y, z);
            end
        end 
    end
end