
-- 콜로니전 종료 후, 지연시간에 콜로니전 지역 입장 시 동작 스크립트
function SCR_GUILD_COLONY_ALREADY_END_MSG(self)
    SendAddOnMsg(self, 'NOTICE_Dm_!', ScpArgMsg('GUILD_COLONY_MSG_ALREADY_END'), 5)
end


-- 콜로니전 채널 입장 체크 스크립트
function SCR_GUILD_COLONY_ENTER_CHECK(self, pc)
--    --스팀 콜로니전 일부 지역만 개최시, 그외 지역 입장 스크립트 안돌도록 처리
--    if GetServerNation() ~= 'KOR' then
--        if GetServerNation() == 'GLOBAL' then
--            local warp_clsList = GetClassList("Warp");
--            local enterCls = self.Enter
--            if self.Enter == "None" then
--                enterCls = self.Dialog
--            end
--            local warpCls = GetClassByNameFromList(warp_clsList, enterCls); --warp.xml에 저장된 워프화살표의 class obj
--            local next_ZoneClsName = nil
--            if warpCls ~= nil then
--                next_ZoneClsName = warpCls.TargetZone;
--            end
--            local clsList = GetClassList("guild_colony")
--            local colonyCls = GetClassByNameFromList(clsList, "GuildColony_"..next_ZoneClsName);
--            if colonyCls ~= nil then
--                if TryGetProp(colonyCls, "ID") == 0 then
--                    return "NORMAL"
--                end
--            end
--        end
--    end
    local select = ShowSelDlg(pc,0, 'GUILD_COLONY_DLG', ScpArgMsg('GUILD_COLONY_MSG_ENTER_COLONY'), ScpArgMsg('GUILD_COLONY_MSG_ENTER_NORMAL'))
    if select == 2 then --일반 채널 입장을 선택했다면,
        return "NORMAL"
    elseif select == 1 then --콜로니전 채널 입장을 선택했다면,

        local guildObj = GetGuildObj(pc)
        if guildObj == nil then --만약 길드가 없다면,
            SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('GUILD_COLONY_MSG_ENTER_FAIL1'), 5);
            return "FAIL"
        else --만약 길드가 있다면,
            if IsEnableEnterColonyWar(pc) == 0 then --만약 콜로니전에 참가하지 않았다면,
                SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('GUILD_COLONY_MSG_ENTER_FAIL2'), 5);
                return "FAIL"
            else --만약 콜로니전에 참가했다면,
            	local warp_clsList = GetClassList("Warp");
            	local enterCls = self.Enter
            	if self.Enter == "None" then
            	    enterCls = self.Dialog
            	end
            	local warpCls = GetClassByNameFromList(warp_clsList, enterCls); --warp.xml에 저장된 워프화살표의 class obj
                local next_ZoneClsName = nil
                if warpCls ~= nil then
                    next_ZoneClsName = warpCls.TargetZone;
                end
                local clsList = GetClassList("guild_colony")
                local colonyCls = GetClassByNameFromList(clsList, "GuildColony_"..next_ZoneClsName);
                local zoneClsName = nil
                if colonyCls ~= nil then
                    zoneClsName = TryGetProp(colonyCls, "ZoneClassName")
                end
                local state = GetColonyWarState()
                if state == 4 or state == 5 then
                    SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('GUILD_COLONY_MSG_ENTER_FAIL4'), 5);
                    return "FAIL"
                elseif state == 3 then
                    return "COLONY", zoneClsName, enterCls
                else
                    if state == 1 then
                        local OccupationGuild = GetColonyOccupationGuild(zoneClsName)
                        if OccupationGuild == nil then
                            SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('GUILD_COLONY_MSG_ENTER_FAIL3'), 5);
                            return "FAIL"
                        else
                            if IsSameObject(guildObj, OccupationGuild) == 1 then --자신의 길드가 점령 길드라면,
                                local pet = GetSummonedPet(pc);
                                if pet == nil or pet == "None" then --컴패니언이 동행되어 있지 않다면,
                                    return "COLONY", zoneClsName, enterCls
                                else --컴패니언이 동행되어 있다면,
                                    local isActive = TryGetProp(pet, 'IsActivated');
                                    if isActive == 0 then --컴패니언이 소환되어 있지 있다면,
                                        return "COLONY", zoneClsName, enterCls
                                    else --컴패니언이 소환되어 있다면,
                                        --Char3_14 : Falconer(응사), Char3_2 : Hunter(헌터), Char3_10 : Schwarzereiter(슈바르츠라이터), Char3_7 : Hackapell(하카펠) Char1_7 : Cataphract(캐터프랙트), Char1_17 : Lancer(랜서)
                                        local class_check = SCR_GUILD_COLONY_RESTRICTION_CHECK(pc, "GuildColony_unRestricted_Companion_Class")
                                        if class_check == "YES" then
                                            return "COLONY", zoneClsName, enterCls
                                        end
                                        SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('GUILD_COLONY_MSG_SUMMON_COMPANION_FAIL1'), 5);
                                        return "FAIL"
                                    end
                                end
                            else --자신의 길드가 점령 길드가 아니라면,
                                SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('GUILD_COLONY_MSG_NO_OCCUPATION_FAIL1'), 5);
                                return "FAIL"
                            end
                        end
                    elseif state == 2 then
                        local pet = GetSummonedPet(pc);
                        if pet == nil or pet == "None" then --컴패니언이 동행되어 있지 않다면,
                            return "COLONY", zoneClsName, enterCls
                        else --컴패니언이 동행되어 있다면,
                            local isActive = TryGetProp(pet, 'IsActivated');
                            if isActive == 0 then --컴패니언이 소환되어 있지 있다면,
                                return "COLONY", zoneClsName, enterCls
                            else --컴패니언이 소환되어 있다면,
                                local class_check = SCR_GUILD_COLONY_RESTRICTION_CHECK(pc, "GuildColony_unRestricted_Companion_Class")
                                if class_check == "YES" then
                                    return "COLONY", zoneClsName, enterCls
                                end
                                SendAddOnMsg(pc, 'NOTICE_Dm_!', ScpArgMsg('GUILD_COLONY_MSG_SUMMON_COMPANION_FAIL1'), 5);
                                return "FAIL"
                            end
                        end
                    end
                end
            end
        end

    end
end


--콜로니전 사용 제한 관련 스크립트
function SCR_GUILD_COLONY_RESTRICTION_CHECK(self, restriction_group)
    local list = {}
    local Class_cnt = GetClassCount("pvp_use_restrict")
    for i = 0, Class_cnt - 1 do
        local index = GetClassByIndex("pvp_use_restrict", i)
        local groupName = TryGetProp(index, "GroupName")
        if groupName == restriction_group then
            local name = TryGetProp(index, "Name")
            table.insert(list, name)
        end
    end

    if restriction_group == "GuildColony_unRestricted_Companion_Class" then
        local riding_enable_job_list = {}
        for i = 1, #list do
            local Cls = GetClassByStrProp("pvp_use_restrict", "Name", list[i])
            local riding_enable_job = TryGetProp(Cls, "IsableRidingClass")
            if riding_enable_job == "NO" then
                if GetJobGradeByName(self, list[i]) >= 1 then
                    table.insert(riding_enable_job_list, list[i])
                end
            end
        end
        if #riding_enable_job_list > 0 then
            for i = 1, #list do
                local Cls = GetClassByStrProp("pvp_use_restrict", "Name", list[i])
                local riding_enable_job = TryGetProp(Cls, "IsableRidingClass")
                if riding_enable_job == "YES" then                
                    local another_jobCircle = GetJobGradeByName(self, list[i])
                    if another_jobCircle >= 1 then
                        return "YES"
                    end
                end
            end
        else
            for i = 1, #list do
                local jobCircle = GetJobGradeByName(self, list[i])
                if jobCircle >= 1 then --해당 리스트 클래스를 1서클 이상 올렸다면,
                    return "YES"
                end
            end
        end
        return "NO"
    end

    if restriction_group == "GuildColony_Restricted_Buff_OccupationPoint" then
        for i = 1, #list do
            if IsBuffApplied(self, list[i]) == 'YES' then
                return "YES"
            end
        end
        return "NO"
    end
end


--타워 프랍 태어날 때 동작 스크립트
function SCR_GUILD_COLONY_TOWER_START(self)
    SetColonyWarBoss(self)
    local zoneClsName = GetZoneName(self)
    local clsList = GetClassList("guild_colony")
    local colonyCls = GetClassByNameFromList(clsList, "GuildColony_"..zoneClsName);
    local OccupationGuild = GetColonyOccupationGuild(zoneClsName)
    if  OccupationGuild == nil or OccupationGuild == "None" then --점령길드가 없다면,
        SetFixAnim(self, 'on_loop') --점령 전, 애니, loop형태(작은불)
    else --점령길드가 있다면,
        SetFixAnim(self, 'on_loop2') --점령 후, 애니, loop형태(큰불)
    end
    local range = TryGetProp(colonyCls, "TowerRange") --점령 포인트 획득이 가능한 범위
    local height = 2
    if range == nil then
        range = 150
    end
    AttachEffect(self, 'F_pattern017_blue', (range*0.065), 'BOT', 0, height, 0, 1) --점령 경계선 이펙트 블루
    SCR_GUILD_COLONY_ENHANCER_SUMMON_RUN(self, zoneClsName)
end


--길드 콜로니전 타워 프랍 동작 스크립트(점령 포인트 증가, 감소, 이펙트, 점령 길드 선정 등)
--self.NumArg1 : 점령 시, 일정 시간 포인트 획득 불가 설정(5초)
--self.NumArg2 : 경계선 이펙트 변경 여부(0 : 무반응, 1 : 반응)
function SCR_GUILD_COLONY_TOWER_RUN(self) --타워 프랍 simpleAI 1000msec

    local state = GetColonyWarState()  --콜로니전 진행 상태 체크 (1 = ready, 2 = start, 3 = delay, 4 = end, 5 = close)
    if state == 1 or state == 3 then --콜로니전이 시작대기, 또는 종료후 지연 상태라면,
        return
    elseif state == 2 then --콜로니전이 시작 상태라면,
        if self.NumArg1 > 0 then --점령 길드가 선정되었다면,
            self.NumArg1 = self.NumArg1 + 1 --일정 시간 전 까지 점령 포인트 획득 불가
            if self.NumArg1 > 5 then --일정 시간이 다다랐다면,
                self.NumArg1 = 0 --점령 포인트 획득 가능
            end
            return
        end
        local rule = GetClass("guild_colony_rule", "GuildColony_Rule_Default"); --guild_colony_rule.xml에 저장된 콜로니전 룰 칼럼값
        local maxPoint = TryGetProp(rule, "MaxPoint") --스팟 점령이 가능한 최대 점령 포인트 값
        local removePoint = TryGetProp(rule, "RemovePoint") --점령 포인트 감소 값
        local onePoint = TryGetProp(rule, "One_Point") --점령 포인트 증가 값(1명)
        local twoPoint = TryGetProp(rule, "Two_Point") --점령 포인트 증가 값(2명)
        local threePoint = TryGetProp(rule, "Three_Point") --점령 포인트 증가 값(3명)
        local fourPoint = TryGetProp(rule, "Four_Point") --점령 포인트 증가 값(4명)
        local addPoint = TryGetProp(rule, "Enhancer_AddPoint") --증폭기 점령 포인트 증가 값
        if maxPoint == nil then
            maxPoint = 1000;
        end
        if removePoint == nil then
            removePoint = 1;
        end 
        if onePoint == nil then
            onePoint = 3;
        end
        if twoPoint == nil then
            twoPoint = 5;
        end
        if threePoint == nil then
            threePoint = 7;
        end
        if fourPoint == nil then
            fourPoint = 9;
        end
        if addPoint == nil then
            addPoint = 2;
        end

        local zoneClsName = GetZoneName(self)
        local clsList = GetClassList("guild_colony")
        local colonyCls = GetClassByNameFromList(clsList, "GuildColony_"..zoneClsName);
        local OccupationGuild = GetColonyOccupationGuild(zoneClsName) --해당 지역 점령 길드를 받아옴
        local range = TryGetProp(colonyCls, "TowerRange") --점령 포인트 획득이 가능한 범위
        if range == nil then
            range = 150
        end
        local guildObjList_zone = {} --존 내 모든 pc들이 들고있는 길드오브젝트 리스트
        local guildObjList_area = {} --존 내 모든 pc들 중, 타워 범위 안에 있는 pc들이 들고있는 길드오브젝트 리스트
        local zone_list, zone_cnt = GetLayerPCList(GetZoneInstID(self), GetLayer(self))
        if zone_cnt > 0 then --존 내 pc가 한명이상 있다면,
            for i = 1, zone_cnt do
                local guildObj = GetGuildObj(zone_list[i])
                table.insert(guildObjList_zone, guildObj)
            end
            local area_list, area_cnt = GetWorldObjectList(self, "PC", range)
            if area_cnt > 0 then --타워 범위 안에 pc가 한명이상 있다면,
                local num = 0
                for i = 1, area_cnt do
                    if IsDead(area_list[i]) == 0 then
                        local guildObj = GetGuildObj(area_list[i])
                        if IsSameObject(OccupationGuild, guildObj) == 0 then --점령 길드가 아니라면,
                            local buff_apply_check = SCR_GUILD_COLONY_RESTRICTION_CHECK(area_list[i], "GuildColony_Restricted_Buff_OccupationPoint")
                            if buff_apply_check == "NO" then
                                table.insert(guildObjList_area, guildObj)
                            end
                        elseif IsSameObject(OccupationGuild, guildObj) == 1 then --점령 길드라면,
                            num = num + 1
                        end
                    end
                end
                if num > 0 then 
                    SCR_GUILD_COLONY_OCCUPATION_POINT_DOWN_RUN(self, zoneClsName, num, removePoint)
                end
                SCR_GUILD_COLONY_OCCUPATION_POINT_UP_RUN(self, zoneClsName, guildObjList_zone, guildObjList_area, range, num, maxPoint, onePoint, twoPoint, threePoint, fourPoint, removePoint, addPoint)
                local nowOcuupationGuild = GetColonyOccupationGuild(zoneClsName)
                if IsSameObject(OccupationGuild, nowOcuupationGuild) == 0 then
                    SCR_GUILD_COLONY_DIVIDING_LINE_EFFECT_RUN(self, range, 0) --경계선 이펙트 blue
                    return
                end
                if #guildObjList_area > 0 then --타워 범위 안에 비점령 길드 pc가 한명이상 있다면,
                    SCR_GUILD_COLONY_DIVIDING_LINE_EFFECT_RUN(self, range, 1) --경계선 이펙트 red
                else --타워 범위 안에 비점령 길드 pc가 아무도 없다면,
                    SCR_GUILD_COLONY_DIVIDING_LINE_EFFECT_RUN(self, range, 0) --경계선 이펙트 blue
                end
            else --타워 범위 안에 pc가 한명도 없다면,
                SCR_GUILD_COLONY_DIVIDING_LINE_EFFECT_RUN(self, range, 0) --경계선 이펙트 blue
            end
        end
    end
end


--점령 포인트 증가 스크립트
--guildObjList_zone : 존 내 모든 pc들이 들고있는 길드오브젝트 리스트
--guildObjList_area : 존 내 모든 pc들 중, 타워 범위 안에 있는 pc들이 들고있는 길드오브젝트 리스트
function SCR_GUILD_COLONY_OCCUPATION_POINT_UP_RUN(self, zoneClsName, guildObjList_zone, guildObjList_area, range, num, maxPoint, onePoint, twoPoint, threePoint, fourPoint, removePoint, addPoint)
    local common_addPoint = addPoint
    local common_onePoint = onePoint
    local common_twoPoint = twoPoint
    local common_threePoint = threePoint
    local common_fourPoint = fourPoint
    
    local guildObjList_type = {} --guildObjList_area 길드 종류로 분리한 리스트
    for i = 1, #guildObjList_area do
        local check = 0
        for j = 1, #guildObjList_type + 1 do
            if IsSameObject(guildObjList_type[j], guildObjList_area[i]) == 1 then
                check = 1
            end
        end
        if check ~= 1 then
            table.insert(guildObjList_type, guildObjList_area[i])
        end
    end

    if #guildObjList_type > 1 then --길드 종류로 분리한 리스트를 점령 포인트가 높은 순으로 재정렬
        for i = 1, #guildObjList_type - 1 do
             for j = i+1, #guildObjList_type do
                local point_i = GetGuildColonyOccupationPoint(guildObjList_type[i], zoneClsName)
                local point_j = GetGuildColonyOccupationPoint(guildObjList_type[j], zoneClsName)
                if point_i > point_j then
                    local temp = nil;
                    temp = guildObjList_type[j];
                    guildObjList_type[j] = guildObjList_type[i];
                    guildObjList_type[i] = temp;
                end
            end
        end
    end

    for i = 1, #guildObjList_type do
        local back_i = (#guildObjList_type + 1) - (i)
        local num_area = 0
        for j = 1, #guildObjList_area do
            if IsSameObject(guildObjList_type[back_i], guildObjList_area[j]) == 1 then
                num_area = num_area + 1
            end
        end

        local g_list, g_cnt = GetEnhancerDestroyGuildList(zoneClsName)
        local enhancer_destroy_num = 0
        for j = 1, g_cnt do
            if IsSameObject(guildObjList_type[back_i], g_list[j]) == 1 then
                enhancer_destroy_num = enhancer_destroy_num + 1
            end
        end
        if enhancer_destroy_num ~= 0 then
            addPoint = addPoint * enhancer_destroy_num
            onePoint = onePoint + addPoint
            twoPoint = twoPoint + addPoint
            threePoint = threePoint + addPoint
            fourPoint = fourPoint + addPoint
        else
            addPoint = common_addPoint
            onePoint = common_onePoint
            twoPoint = common_twoPoint
            threePoint = common_threePoint
            fourPoint = common_fourPoint
        end

        local nowPoint = GetGuildColonyOccupationPoint(guildObjList_type[back_i], zoneClsName) --해당 길드의 점령 포인트를 받아옴
        local checkPoint = maxPoint - nowPoint
        if nowPoint < 1 then --현재포인트가  0 이라면,
            local subPoint = num * removePoint
            if num > 10 then
                subPoint = 10 * removePoint
            end
            if num_area < 4 then --타워 범위 내 길원이 4명 미만이라면,
        		if num_area == 1 then
                    if subPoint < onePoint then
                        onePoint = onePoint - subPoint
                        AddColonyOccupationPoint(guildObjList_type[back_i], zoneClsName, onePoint) --해당 길드의 점령 포인트 추가
                    end
                elseif num_area == 2 then
                    if subPoint < twoPoint then
                        twoPoint = twoPoint - subPoint
                        AddColonyOccupationPoint(guildObjList_type[back_i], zoneClsName, twoPoint) --해당 길드의 점령 포인트 추가
                    end
                elseif num_area == 3 then
                    if subPoint < threePoint then
                        threePoint = threePoint - subPoint
                        AddColonyOccupationPoint(guildObjList_type[back_i], zoneClsName, threePoint) --해당 길드의 점령 포인트 추가
                    end
                end
            else --타워 범위 내 길원이 4명 이상이라면,
                if subPoint < fourPoint then
                    fourPoint = fourPoint - subPoint
                    AddColonyOccupationPoint(guildObjList_type[back_i], zoneClsName, fourPoint) --해당 길드의 점령 포인트 추가
                end
            end
        else
            if num_area < 4 then --타워 범위 내 길원이 4명 미만이라면,
        		if num_area == 1 then
        		    if checkPoint <= onePoint then
                        local guild_check = SCR_GUILD_COLONY_OCCUPATION_POINT_OTHER_GUILD_CHECK(self, zoneClsName, guildObjList_type[back_i], guildObjList_type, guildObjList_area, maxPoint)
                        if guild_check == "YES" then
                        else
            		        AddColonyOccupationPoint(guildObjList_type[back_i], zoneClsName, onePoint) --해당 길드의 점령 포인트 추가
            		    end
        		    else
                        AddColonyOccupationPoint(guildObjList_type[back_i], zoneClsName, onePoint) --해당 길드의 점령 포인트 추가
                    end
                elseif num_area == 2 then
        		    if checkPoint <= twoPoint then
                        local guild_check = SCR_GUILD_COLONY_OCCUPATION_POINT_OTHER_GUILD_CHECK(self, zoneClsName, guildObjList_type[back_i], guildObjList_type, guildObjList_area, maxPoint)
                        if guild_check == "YES" then
                        else
            		        AddColonyOccupationPoint(guildObjList_type[back_i], zoneClsName, twoPoint) --해당 길드의 점령 포인트 추가
            		    end
        		    else
                        AddColonyOccupationPoint(guildObjList_type[back_i], zoneClsName, twoPoint) --해당 길드의 점령 포인트 추가
                    end
                elseif num_area == 3 then
        		    if checkPoint <= threePoint then
                        local guild_check = SCR_GUILD_COLONY_OCCUPATION_POINT_OTHER_GUILD_CHECK(self, zoneClsName, guildObjList_type[back_i], guildObjList_type, guildObjList_area, maxPoint)
                        if guild_check == "YES" then
                        else
            		        AddColonyOccupationPoint(guildObjList_type[back_i], zoneClsName, threePoint) --해당 길드의 점령 포인트 추가
            		    end
        		    else
                        AddColonyOccupationPoint(guildObjList_type[back_i], zoneClsName, threePoint) --해당 길드의 점령 포인트 추가
                    end
                end
            else --타워 범위 내 길원이 4명 이상이라면,
    		    if checkPoint <= fourPoint then
                    local guild_check = SCR_GUILD_COLONY_OCCUPATION_POINT_OTHER_GUILD_CHECK(self, zoneClsName, guildObjList_type[back_i], guildObjList_type, guildObjList_area, maxPoint)
                    if guild_check == "YES" then
                    else
        		        AddColonyOccupationPoint(guildObjList_type[back_i], zoneClsName, fourPoint) --해당 길드의 점령 포인트 추가
        		    end
    		    else
                    AddColonyOccupationPoint(guildObjList_type[back_i], zoneClsName, fourPoint) --해당 길드의 점령 포인트 추가
                end
            end
        end
        local nowPoint = GetGuildColonyOccupationPoint(guildObjList_type[back_i], zoneClsName) --해당 길드의 점령 포인트를 받아옴
        if nowPoint >= maxPoint then --현재 점령 포인트가 최대 포인트에 도달했다면,
            self.NumArg1 = 1 --점령 길드가 선정될 경우, 점령 포인트 획득을 일정 시간 동안 멈추기 위한 장치
            local beforeOccupationGuild = GetColonyOccupationGuild(zoneClsName)  --해당 지역 점령 길드를 받아옴
            local map_class = GetClass("Map", zoneClsName);
            local mapName = TryGetProp(map_class, "Name") --해당 지역의 맵 이름을 받아옴

            SetColonyOccupationGuild(guildObjList_type[back_i], zoneClsName) --해당 지역 점령 길드를 새롭게 선정

            local list, cnt = GetHaveOccupationPointGuildList(zoneClsName) --해당 지역의 점령포인트를 1 이상 가지고 있는 길드 리스트를 받아옴
            if cnt > 0 then
                for k = 1, cnt do
                    SetColonyOccupationPoint(list[k], zoneClsName, 0) --해당 길드의 점령 포인트를 0으로 초기화
                end
            end
        	local P_list, P_cnt = GetLayerPCList(GetZoneInstID(self), GetLayer(self)) --존 내 pc 리스트를 새롭게 받아옴
            local partyName = GetPartyName(guildObjList_type[back_i])
            if P_cnt > 0 then
                for p = 1, P_cnt do
                    if IsSameObject(guildObjList_type[back_i], GetGuildObj(P_list[p])) == 1 then --검색된 pc 길드가 점령 길드라면,
                        if IsBuffApplied(P_list[p], "GuildColony_OccupationBuff") == 'NO' then  --점령 버프를 받지 않았다면,
                            AddBuff(self, P_list[p], 'GuildColony_OccupationBuff', 1, 0, 0, 1) -- 점령 버프 제공
                            PlayEffect(P_list[p], 'F_cleric_dodola_line', 0.8, 'BOT')
                            PlayEffect(P_list[p], 'F_lineup020_blue_mint', 0.6, 'BOT')
                        end
                        if GetServerNation() == 'KOR' then --점령 사운드 출력
                            PlaySoundLocal(P_list[p], "battle_occupation")
                        else
                            PlaySoundLocal(P_list[p], "S1_battle_occupation")
                        end
                    elseif IsSameObject(beforeOccupationGuild, GetGuildObj(P_list[p])) == 1 then --검색된 pc 길드가 바로 전에 점령했던 길드라면,
                        SendAddOnMsg(P_list[p], 'NOTICE_Dm_GuildColony2', ScpArgMsg("GUILD_COLONY_MSG_OCCUPIED_1{partyName}{mapName}", "partyName", partyName, "mapName", mapName), 15)
                        if GetServerNation() == 'KOR' then --점령 사운드 출력
                            PlaySoundLocal(P_list[p], "battle_lose_occupation")
                        else
                            PlaySoundLocal(P_list[p], "S1_battle_lose_occupation")
                        end
                        RunScript("SCR_GUILD_COLONY_ZONE_WARP_OUT", P_list[p])
                    else --검색된 pc 길드가 점령 길드 또는 점령했던 길드가 아니라면,
                        SendAddOnMsg(P_list[p], 'NOTICE_Dm_GuildColony3', ScpArgMsg("GUILD_COLONY_MSG_OCCUPIED_2{partyName}{mapName}", "partyName", partyName, "mapName", mapName), 15)
                        if GetServerNation() == 'KOR' then --점령 사운드 출력
                            PlaySoundLocal(P_list[p], "battle_occupied")
                        else
                            PlaySoundLocal(P_list[p], "S1_battle_occupied")
                        end
                        RunScript("SCR_GUILD_COLONY_ZONE_WARP_OUT", P_list[p])
                    end
                end
            end
            
            SCR_GUILD_COLONY_ENHANCER_SUMMON_RUN(self, zoneClsName)
            
            SetFixAnim(self, "on_loop2")
            PlayAnim(self, 'on', 1, 0) --점령 시, 애니, noloop형태(단발성)
            ReserveAnim(self, "on_loop2", 1, 0) --점령 후, 애니, loop형태(큰불)
            SCR_GUILD_COLONY_DIVIDING_LINE_EFFECT_RUN(self, range, 0) --경계선 이펙트 blue
            return
        end

    end

end


--점령 포인트 감소 스크립트
function SCR_GUILD_COLONY_OCCUPATION_POINT_DOWN_RUN(self, zoneClsName, num, removePoint)

    local subPoint = num * removePoint
    if num > 10 then
        subPoint = 10 * removePoint
    end
    local list, cnt = GetHaveOccupationPointGuildList(zoneClsName) --해당 지역의 점령포인트를 1 이상 가지고 있는 길드 리스트를 받아옴
    if cnt > 0 then
        for i = 1, cnt do
            local nowPoint = GetGuildColonyOccupationPoint(list[i], zoneClsName) --해당 길드의 점령 포인트를 받아옴
            if nowPoint > 0 then --해당 길드의 점령 포인트가 0보다 크다면,
                if nowPoint > subPoint then --해당 길드의 점령 포인트가 removePoint값보다 크다면,
            		SubColonyOccupationPoint(list[i], zoneClsName, subPoint) --해당 길드의 점령 포인트 감소
                else --해당 길드의 점령 포인트가 removePoint값보다 작거나 같다면,
            		SetColonyOccupationPoint(list[i], zoneClsName, 0) --해당 길드의 점령 포인트를 0으로 초기화
                end
            end
        end
    end

end


--점령 경계선 이펙트 스크립트
function SCR_GUILD_COLONY_DIVIDING_LINE_EFFECT_RUN(self, range, num)
    local height = 2
    
    if num == 0 then
        if self.NumArg2 ~= 0 then --점령 경계선 이펙트가 반응한 상태였다면,
            DetachEffect(self, 'F_pattern017_red')
            AttachEffect(self, 'F_pattern017_blue', (range*0.065), 'BOT', 0, height, 0, 1) --반응하지 않는 점령 경계선 이펙트
            self.NumArg2 = 0
        end
    elseif num == 1 then
        if self.NumArg2 == 0 then --점령 경계선 이펙트가 반응하지 않는 상태였다면,
            DetachEffect(self, 'F_pattern017_blue')
            AttachEffect(self, 'F_pattern017_red', (range*0.065), 'BOT', 0, height, 0, 1) --반응하는 점령 경계선 이펙트
            self.NumArg2 = 1
        end
    end

end

--길드 콜로니전 점령 버프, 몬스터 버프, 증폭기 버프 스크립트
function SCR_GUILD_COLONY_OCCUPATION_BUFF_RUN(self) --히든 오브젝트 프랍 simpleAI 1000msec

    local state = GetColonyWarState()  --콜로니전 진행 상태 체크 (1 = ready, 2 = start, 3 = delay, 4 = end, 5 = close)
    if state == 2 then --콜로니전이 시작 상태라면,
        local zoneClsName = GetZoneName(self)
        local OccupationGuild = GetColonyOccupationGuild(zoneClsName)
    	local BossKillGuild = GetColonyWarBossKillGuild(zoneClsName)
    	local pcList, pcCount = GetLayerPCList(GetZoneInstID(self), GetLayer(self))
        if BossKillGuild == nil or BossKillGuild == "None" then
        else --보스 처치 길드가 있다면
            local guildObj = GetExProp_Str(self, "BOSS_KILL_AND_OCCUPATION_GUILD")
            if IsSameObject(OccupationGuild, BossKillGuild) == 1 then -- 보스처치 길드가 점령 길드라면
                if guildObj == nil or guildObj == "None" then --현재 보스처치 길드와 점령 길드가 같은 길드가 없다면
                    SetExProp_Str(self, "BOSS_KILL_AND_OCCUPATION_GUILD", GetIESID(BossKillGuild))
                end
            else -- 보스처치 길드가 점령 길드가 아니라면
                if guildObj ~= nil and guildObj ~= "None" then --현재 보스처치 길드와 점령 길드가 같은 길드가 있다면
                    local diff = GetColonyWarBossKillTimeDiff(zoneClsName)
                    local buffTime = 600000 - (diff*1000)
                    if buffTime <= 0 then --버프 유지 시간이 지났다면
                        SetExProp_Str(self, "BOSS_KILL_AND_OCCUPATION_GUILD", "None")
                    end
                end
            end
        end

    	if pcCount > 0 then
    	    for i = 1, pcCount do
                if OccupationGuild == nil or OccupationGuild == "None" then
                else        	    
        	        if IsSameObject(OccupationGuild, GetGuildObj(pcList[i])) == 1 then --현재 존 내 인원이 점령 길드라면,
                        if IsBuffApplied(pcList[i], "GuildColony_OccupationBuff") == 'NO' then  --점령 버프를 받지 않았다면,
                            local diff = GetColonyOccupationTimeDiff(zoneClsName)
                            if diff < 300 then
                                AddBuff(self, pcList[i], 'GuildColony_OccupationBuff', 1, 0, 0, 1)
                            elseif diff < 600 and diff >= 300 then
                                AddBuff(self, pcList[i], 'GuildColony_OccupationBuff', 1, 0, 0, 2)
                            elseif diff >= 600 then
                                AddBuff(self, pcList[i], 'GuildColony_OccupationBuff', 1, 0, 0, 3)
                            end
                            PlayEffect(pcList[i], 'F_cleric_dodola_line', 0.8, 'BOT')
                            PlayEffect(pcList[i], 'F_lineup020_blue_mint', 0.6, 'BOT')                            
                        end
                    end
                end

                if BossKillGuild == nil or BossKillGuild == "None" then
                else
        	        if IsSameObject(BossKillGuild, GetGuildObj(pcList[i])) == 1 then --현재 존 내 인원이 보스 처치 길드라면,
                        if IsBuffApplied(pcList[i], "GuildColony_OccupationBuff") == 'NO' then  --점령 버프를 받지 않았다면,
                            if IsBuffApplied(pcList[i], "GuildColony_BossMonsterBuff_DEF") == 'NO' then  --몬스터 버프를 받지 않았다면,
                                local diff = GetColonyWarBossKillTimeDiff(zoneClsName)
                                local buffTime = 600000 - (diff*1000)
                                if buffTime > 0 then
                                    local guildObj = GetExProp_Str(self, "BOSS_KILL_AND_OCCUPATION_GUILD")
                                    if guildObj == nil or guildObj == "None" then
                                        AddBuff(self, pcList[i], 'GuildColony_BossMonsterBuff_DEF', 1, 0, buffTime, 1) --몬스터 버프(지연시간에 따른 적용시간) 추가
                                    end
                                end
                            end
                        end
                    end
                end

        	    if IsBuffApplied(pcList[i], "GuildColony_EnhancerDestroyBuff_1") == 'NO' then  --포인트 버프를 받지 않았다면,
            	    local list, cnt = GetEnhancerDestroyGuildList(zoneClsName)
            	    local over = 0
            	    for j = 1, cnt do
            	        if IsSameObject(list[j], GetGuildObj(pcList[i])) == 1 then
            	            over = over + 1
            	        end
            	    end
            	    if over ~= 0 then
                        AddBuff(self, pcList[i], 'GuildColony_EnhancerDestroyBuff_1', 1, 0, 0, over)
                    end
                end
            end
        end
    end
end

--길드 콜로니전 증폭기 이속 버프 스크립트
function SCR_GUILD_COLONY_ENHANCER_SPEED_UP_BUFF_RUN(self)
    local state = GetColonyWarState()  --콜로니전 진행 상태 체크 (1 = ready, 2 = start, 3 = delay, 4 = end, 5 = close)
    if state == 2 then --콜로니전이 시작 상태라면,
        local rule = GetClass("guild_colony_rule", "GuildColony_Rule_Default"); --GuildColonyRule.xml에 저장된 콜로니전 룰 칼럼값
        local enhancerCount = TryGetProp(rule, "GuildColonyEnhancerCount") --콜로니 증폭기 개수
        local zoneClsName = GetZoneName(self)
    	local pcList, pcCount = GetLayerPCList(GetZoneInstID(self), GetLayer(self))
       	if pcCount > 0 then
    	    for i = 1, pcCount do
    	        local guildObj = GetGuildObj(pcList[i])
        	    local list, cnt = GetEnhancerDestroyGuildList(zoneClsName)
        	    local over = 0
        	    if cnt > 0 then
        	        for j = 1, cnt do
        	            if IsSameObject(list[j], guildObj) == 1 then --증폭기를 파괴한 길드라면,
        	                over = over + 1
        	            end
        	        end
        	    end
        	    if over ~= 0 then
             	    if IsBuffApplied(pcList[i], "GuildColony_EnhancerDestroyBuff_2") == 'NO' then  --이속 버프를 받지 않았다면,
                	    local guildID = GetIESID(guildObj)
                        local recentEnhancerDestroyTime = 0
                        local check_time = "0".."/".."0"
                        for j = 1, enhancerCount do
                            if tostring(guildID) == GetExProp_Str(self, "ENHANCER_DESTROY_GUILD_"..j) then
                                local time = GetExProp_Str(self, "ENHANCER_DESTROY_TIME_"..j)
                                local string_cut_list1 = SCR_STRING_CUT(time, '/')
                                local string_cut_list2 = SCR_STRING_CUT(check_time, '/')
                                if tonumber(string_cut_list1[1]) > tonumber(string_cut_list2[1]) then
                                    check_time = time
                                    string_cut_list2 = SCR_STRING_CUT(check_time, '/')
                                    recentEnhancerDestroyTime = tonumber(string_cut_list2[2])
                                else
                                    if tonumber(string_cut_list1[1]) == tonumber(string_cut_list2[1]) then
                                        if tonumber(string_cut_list1[2]) < tonumber(string_cut_list2[2]) then
                                            recentEnhancerDestroyTime = tonumber(string_cut_list2[2])
                                        end
                                    end
                                end
                            end
                        end
                        local now_time = os.date('*t')
                        local hour = now_time['hour']
                        local min = now_time['min']
                        local sec = now_time['sec']
                        local time_diff = ((hour*3600) + (min*60) + sec) - recentEnhancerDestroyTime
                        if time_diff <= 600 then
                            local apply_time = (600 - time_diff)*1000
                            AddBuff(self, pcList[i], 'GuildColony_EnhancerDestroyBuff_2', 1, 0, apply_time, 1)
                        end
                    end
                end
            end
        end
    end
end


--길드 콜로니전 보스몬스터 소환 스크립트
function SCR_GUILD_COLONY_SUMMON_MONSTER_RUN(self) --히든 오브젝트 프랍 simpleAI 1000msec
    local state = GetColonyWarState()  --콜로니전 진행 상태 체크 (1 = ready, 2 = start, 3 = delay, 4 = end, 5 = close)
    if state == 1 or state == 3 then --콜로니전이 시작대기, 또는 종료후 지연 상태라면,
        return
    elseif state == 2 then --콜로니전이 시작 상태라면,
        local rule = GetClass("guild_colony_rule", "GuildColony_Rule_Default"); --GuildColonyRule.xml에 저장된 콜로니전 룰 칼럼값
        local remainTime = TryGetProp(rule, "BossMonster_SummonTime") --콜로니전 시작 또는 몬스터 처치 후, 몬스터가 등장하는 시간
        if remainTime == nil then
            remainTime = 1200
        end
        local zoneClsName = GetZoneName(self)
        local diff = GetColonyWarBossKillTimeDiff(zoneClsName)
        if remainTime <= diff then
            local obj = GetScpObjectList(self, "COLONY_SUMMON_MONSTER")
            if #obj ~= 0 then --보스몬스터가 필드에 있다면,
        	    return
        	else --보스몬스터가 필드에 없다면,
            	local clsList = GetClassList("guild_colony"); --GuildColonyRanking.xml에 저장된 콜로니전 점령 관련 칼럼값
                local colonyCls = GetClassByNameFromList(clsList, "GuildColony_"..zoneClsName); --GuildColonyRanking.xml에 저장된 해당 스팟지역의 class obj
                local pos_x = nil
                local pos_y = nil
                local pos_z = nil
                if colonyCls ~= nil then
                    local ran = IMCRandom(1, 3) --몬스터 소환 좌표를 xml에 저장된 좌표 중, 랜덤하게 선정
                    pos_x = TryGetProp(colonyCls, "Pos"..ran.."_X")
                    pos_y = TryGetProp(colonyCls, "Pos"..ran.."_Y")
                    pos_z = TryGetProp(colonyCls, "Pos"..ran.."_Z")
                end
                if pos_x ~= nil and pos_y ~= nil and pos_z ~= nil then
                    local mon = CREATE_MONSTER_EX(self, 'Colony_Boss_Golem_balck', pos_x+IMCRandom(-100, 100), pos_y, pos_z+IMCRandom(-100, 100), 0, 'Monster', nil, SCR_GUILD_COLONY_MON_RUN); --보스몬스터 소환
                    AddScpObjectList(self, "COLONY_SUMMON_MONSTER", mon) --보스몬스터가 필드에 있는지 없는지 체크하기 위해 설정
                	AddScpObjectList(mon, "COLONY_SUMMON_MONSTER", self)
                	local pcList, pcCount = GetLayerPCList(GetZoneInstID(self), GetLayer(self))
                	if pcCount > 0 then
                	    for j = 1, pcCount do
                            if GetServerNation() == 'KOR' then --보스몬스터 등장 사운드 출력
                                PlaySoundLocal(pcList[j], "battle_bossmonster_appear")
                            else
                                PlaySoundLocal(pcList[j], "S1_battle_bossmonster_appear")
                            end
                            SendAddOnMsg(pcList[j], 'NOTICE_Dm_BossAppear', ScpArgMsg("GUILD_COLONY_MSG_BOSSMONSTER_SUMMON"), 15) --보스몬스터 등장 메시지(존 내 인원)
                        end
                    end
                    SetColonyWarBoss(mon)
                    ColonyWarBossGenerate(mon) --로그확인용
                end
            end
        end
    end
end


--보스몬스터 세팅 값
function SCR_GUILD_COLONY_MON_RUN(mon)

	mon.BTree = "BasicBoss";
	mon.Tactics = "None";
    mon.SimpleAI = "GUILD_COLONY_SUMMON_MONSTER_AI"
	mon.Name = "None";

end


--보스몬스터 행동 동작 스크립트
function SCR_GUILD_COLONY_MON_AI(self)
    local state = GetColonyWarState()
    if state == 3 then
        Kill(self)
    end
end


--보스몬스터가 죽었을 때 동작 스크립트
function SCR_GUILD_COLONY_MON_DEAD(self)
    ColonyWarKillBoss(self) --로그확인용
    local obj = GetScpObjectList(self, "COLONY_SUMMON_MONSTER")
    if #obj > 0 then
        for i = 1, #obj do
            RemoveScpObjectList(obj[i], "COLONY_SUMMON_MONSTER", self)
        end
        local lastattacker = GetLastAttacker(self); --몬스터 마지막 타격자 불러옴
        if lastattacker.ClassName == 'PC' then --몬스터 마지막 타격자가 'PC'라면,
            local zoneClsName = GetZoneName(self)
            local guildObj = GetGuildObj(lastattacker)
            local pcList, pcCount = GetLayerPCList(GetZoneInstID(self), GetLayer(self))
            if pcCount > 0 then
                local OccupationGuild = GetColonyOccupationGuild(zoneClsName)
            	local name = GetTeamName(lastattacker)
                local partyName = GetPartyName(guildObj)
                if IsSameObject(guildObj, OccupationGuild) == 0 then --마지막 타격자의 길드가 점령 길드가 아니라면,
            	    for P = 1, pcCount do
                        if IsSameObject(guildObj, GetGuildObj(pcList[P])) == 1 then --마지막 타격자와 같은 길드라면,
                            local buff = GetBuffByName(pcList[P], 'GuildColony_BossMonsterBuff_DEF')
                            if buff == nil then --몬스터 버프를 받고있지 않다면,
                                AddBuff(self, pcList[P], 'GuildColony_BossMonsterBuff_DEF', 1, 0, 600000, 1) --몬스터 버프(10분) 추가
                                buff = GetBuffByName(pcList[P], 'GuildColony_BossMonsterBuff_DEF')
                                SendAddOnMsg(pcList[P], 'NOTICE_Dm_raid_clear', ScpArgMsg("GUILD_COLONY_MSG_BOSSMONSTER_KILL_BUFF{name}{buff}", "name", name, "buff", buff.Name), 15) --보스몬스터 처치한 마지막 타격자의 팀명, 길드명 알림 메시지(존 내 인원)
                            end
                        else
                            SendAddOnMsg(pcList[P], 'NOTICE_Dm_Bell', ScpArgMsg("GUILD_COLONY_MSG_BOSSMONSTER_KILL{partyName}{name}", "partyName", partyName, "name", name), 15) --보스몬스터 처치한 마지막 타격자의 팀명, 길드명 알림 메시지(존 내 인원)
                	    end
                	end
                else
            	    for P = 1, pcCount do
                        if IsSameObject(guildObj, GetGuildObj(pcList[P])) == 0 then --마지막 타격자와 같은 길드가 아니라라면,
                            SendAddOnMsg(pcList[P], 'NOTICE_Dm_Bell', ScpArgMsg("GUILD_COLONY_MSG_BOSSMONSTER_KILL{partyName}{name}", "partyName", partyName, "name", name), 15) --보스몬스터 처치한 마지막 타격자의 팀명, 길드명 알림 메시지(존 내 인원)
                        end
                    end
                end
            end
            SetColonyWarBossKillGuild(guildObj, zoneClsName)
        end
    end
end


--콜로니전 종료 체크
function SCR_GUILD_COLONY_END_TIME_CHECK(self)
    local state = GetColonyWarState()
    if state == 3 then
        return 1
    else
        return 0
    end
end


--콜로니전 종료 UI 출력
function SCR_COLONY_END_UI_OPEN(self)
    local zoneClsName = GetZoneName(self)
    local OccupationGuild = GetColonyOccupationGuild(zoneClsName)
    if OccupationGuild == nil then
        ExecClientScp(self, 'COLONY_RESULT_OPEN(0, "None")') -- 패배일때(점령길드가 없는 경우)
    else
        local guildID = GetIESID(OccupationGuild)
        local guildName = GetPartyName(OccupationGuild)
        local win_guild = guildID.."#"..guildName
        if  IsSameObject(OccupationGuild, GetGuildObj(self)) == 1 then --현재 존 내 인원이 점령 길드라면,
            ExecClientScp(self, 'COLONY_RESULT_OPEN(1, "None")') -- 승리일때
        elseif IsSameObject(OccupationGuild, GetGuildObj(self)) == 0 then  --현재 존 내 인원이 점령 길드가 아니라면,
            ExecClientScp(self, 'COLONY_RESULT_OPEN(0, "'..win_guild..'")') -- 패배일때
        end
    end
end


--콜로니전 종료 타워 이펙트 삭제
function SCR_COLONY_TOWER_EFFECT_OFF(self)
    DetachEffect(self, 'F_pattern017_red')
    DetachEffect(self, 'F_pattern017_blue')
    SetFixAnim(self, "std")
    PlayEffect(self, 'F_levitation039_green', 1, "TOP")
end


--콜로니전 지역 입장 시, 무적 버프
function SCR_GUILD_COLONY_ENTER_INVINCIBLE_BUFF(self)
    local state = GetColonyWarState()  --콜로니전 진행 상태 체크 (1 = ready, 2 = start, 3 = delay, 4 = end, 5 = close)
    if state == 1 or state == 2 then --콜로니전이 시작대기, 또는 종료후 지연 상태라면,
        local x, y, z = GetPos(self)
        local list = GetMyPadList(self, "Guild_Colony_Invinciblation")
        if #list == 0 then --패드가 없다면,
            RunPad(self, "Guild_Colony_Invinciblation", nil, x, y, z, 1, 1);	
        end
    end
end



--콜로니전 점령 포인트 최대 달성 상황에 주변 다른 길드도 같은 상황인지 체크
function SCR_GUILD_COLONY_OCCUPATION_POINT_OTHER_GUILD_CHECK(self, zoneClsName, guildObj, guildObjList_type, guildObjList_area, maxPoint)
    local rule = GetClass("guild_colony_rule", "GuildColony_Rule_Default"); --guild_colony_rule.xml에 저장된 콜로니전 룰 칼럼값
    local maxPoint = TryGetProp(rule, "MaxPoint") --스팟 점령이 가능한 최대 점령 포인트 값
    local onePoint = TryGetProp(rule, "One_Point") --점령 포인트 증가 값(1명)
    local twoPoint = TryGetProp(rule, "Two_Point") --점령 포인트 증가 값(2명)
    local threePoint = TryGetProp(rule, "Three_Point") --점령 포인트 증가 값(3명)
    local fourPoint = TryGetProp(rule, "Four_Point") --점령 포인트 증가 값(4명)
    local addPoint = TryGetProp(rule, "Enhancer_AddPoint") --증폭기 점령 포인트 증가 값
    if maxPoint == nil then
        maxPoint = 1000;
    end
    if onePoint == nil then
        onePoint = 3;
    end
    if twoPoint == nil then
        twoPoint = 5;
    end
    if threePoint == nil then
        threePoint = 7;
    end
    if fourPoint == nil then
        fourPoint = 9;
    end
    if addPoint == nil then
        addPoint = 2;
    end
    for i = 1, #guildObjList_type do
        if IsSameObject(guildObj, guildObjList_type[i]) == 0 then
            local nowPoint = GetGuildColonyOccupationPoint(guildObjList_type[i], zoneClsName)
            local checkPoint = maxPoint - nowPoint
            local num = 0
            for j = 1, #guildObjList_area do
                if IsSameObject(guildObjList_type[i], guildObjList_area[j]) == 1 then
                    num = num + 1
                end
            end

            local g_list, g_cnt = GetEnhancerDestroyGuildList(zoneClsName)
            local enhancer_destroy_num = 0
            for j = 1, g_cnt do
                if IsSameObject(guildObjList_type[i], g_list[j]) == 1 then
                    enhancer_destroy_num = enhancer_destroy_num + 1
                end
            end
            if enhancer_destroy_num ~= 0 then
                addPoint = addPoint * enhancer_destroy_num
                onePoint = onePoint + addPoint
                twoPoint = twoPoint + addPoint
                threePoint = threePoint + addPoint
                fourPoint = fourPoint + addPoint
            end

            if num == 1 then
                if checkPoint <= onePoint then
                    return "YES"
                end
            elseif num == 2 then
                if checkPoint <= twoPoint then
                    return "YES"
                end
            elseif num == 3 then
                if checkPoint <= threePoint then
                    return "YES"
                end
            elseif num >= 4 then
                if checkPoint <= fourPoint then
                    return "YES"
                end
            end
        end
    end
end

function SCR_GUILD_COLONY_MUSIC_PLAY(self)    
    PlayBGM(self, 'battle_colony')
end

--입장 화살표 태어날 때 동작 스크립트
function SCR_GUILD_COLONY_ENTER_START(self)
    local height = 0
    local zonename = GetZoneName(self)
    if zonename == "f_castle_20_3" then
        height = 15
    else
        height = 2
    end

    local name = TryGetProp(self, "Enter")
    if name == "PILGRIM_49_TO_PILGRIM_47" then
        height = 15
    elseif name == "CASTLE_20_3_CASTLE_20_2" then
        height = 25
    elseif name == "CASTLE_20_3_TABLELAND74" then
        height = 60
    end
    AttachEffect(self, 'F_pattern017_green', 29.7, 'BOT', 0, height, 0, 1) --안전지대 경계선 이펙트 그린
end

--입장 화살표 이펙트 삭제
function SCR_GUILD_COLONY_ENTER_EFFECT_OFF(self)
    local list = GetMyPadList(self, "Guild_Colony_Invinciblation")
    if #list ~= 0 then --패드가 있다면,
        for i = 1, #list do
            local pad = list[i];
            KillPad(pad);
        end
    end
    DetachEffect(self, 'F_pattern017_green')
end

function SCR_GUILD_COLONY_ZONE_WARP_OUT(self)
    DelyReturnCityZone(self)
    sleep(2000)
    PlaySoundLocal(self, 'battle_zone_warp_out')
end

--길드 콜로니전 콜로니 증폭기 소환 스크립트
function SCR_GUILD_COLONY_ENHANCER_SUMMON_RUN(self, zoneClsName) -- 증폭기 소환 스크립트
    local rule = GetClass("guild_colony_rule", "GuildColony_Rule_Default"); --GuildColonyRule.xml에 저장된 콜로니전 룰 칼럼값
    local enhancerName = TryGetProp(rule, "GuildColonyEnhancerClassName") --콜로니 증폭기 이름
    local enhancerCount = TryGetProp(rule, "GuildColonyEnhancerCount") --콜로니 증폭기 개수
	local clsList = GetClassList("guild_colony"); --GuildColonyRanking.xml에 저장된 콜로니전 점령 관련 칼럼값
    local colonyCls = GetClassByNameFromList(clsList, "GuildColony_"..zoneClsName); --GuildColonyRanking.xml에 저장된 해당 스팟지역의 class obj

    if colonyCls ~= nil then
        local pos_list = {}
        for i = 1, enhancerCount do
            local pos_x = TryGetProp(colonyCls, "Enhancer_Pos"..i.."_X")
            local pos_y = TryGetProp(colonyCls, "Enhancer_Pos"..i.."_Y")
            local pos_z = TryGetProp(colonyCls, "Enhancer_Pos"..i.."_Z")
            pos_list[i] = {pos_x, pos_y, pos_z}
        end

        if #pos_list == 3 then
            for i = 1, enhancerCount do
                local obj = GetExArgObject(self, "COLONY_ENHANCER_"..i)
                if obj ~= nil then
                    if IsDead(obj) == 0 then
                        Kill(obj)
                    end
                end
                if GetExProp_Str(self, "ENHANCER_DESTROY_GUILD_"..i) ~= "None" then
                    DelExProp(self, "ENHANCER_DESTROY_GUILD_"..i)
                end
                if GetExProp_Str(self, "ENHANCER_DESTROY_TIME_"..i) ~= "None" then
                    DelExProp(self, "ENHANCER_DESTROY_TIME_"..i)
                end
            end

            DeleteEnhancerDestroyGuildList(zoneClsName)
            local occupationGuildObj = GetColonyOccupationGuild(zoneClsName)
            local partyID = 0
            if occupationGuildObj ~= nil then
                partyID = GetIESID(occupationGuildObj)
            end
            for i = 1, enhancerCount do
                local obj = CREATE_MONSTER_EX(self, enhancerName, pos_list[i][1], pos_list[i][2],pos_list[i][3], -45, 'Monster', nil, SCR_GUILD_COLONY_ENHANCER_SET); --콜로니 증폭기 소환
                SetMonsterPartyID(obj, PARTY_GUILD, partyID)
                SetExArgObject(self, "COLONY_ENHANCER_"..i, obj)
                SetExArgObject(obj, "COLONY_ENHANCER_"..i, self)
                SetFixAnim(obj, 'on_loop_left')
                CreateEnhancerMongo(obj)
            end
        end
    end
end

function SCR_GUILD_COLONY_ENHANCER_SET(obj)
    local rule = GetClass("guild_colony_rule", "GuildColony_Rule_Default"); --GuildColonyRule.xml에 저장된 콜로니전 룰 칼럼값
    local enhancerHPCount = TryGetProp(rule, "GuildColonyEnhancerHPCount") --콜로니 증폭기 HP카운트
    obj.Tactics = "MON_DUMMY"
    obj.SimpleAI = "GUILD_COLONY_ENHANCER_AI"
    obj.HPCount = tonumber(enhancerHPCount)
    obj.Name = ScpArgMsg("colony_enhancer_name")
end

--증폭기 일정 시간 마다 HP 회복 스크립트
function SCR_GUILD_COLONY_ENHANCER_HP_UP_RUN(self)
    if self.NumArg1 >= 10 then
        AddHP(self, 10)
        self.NumArg1 = 0
        SetFixAnim(self, 'on_loop_left')
    else
        self.NumArg1 = self.NumArg1 + 1
    end
end

--증폭기 파괴되었을 때 동작 스크립트
function SCR_GUILD_COLONY_ENHANCER_DEAD(self)
    local lastattacker = GetLastAttacker(self); --몬스터 마지막 타격자 불러옴
    if lastattacker.ClassName == 'PC' then --몬스터 마지막 타격자가 'PC'라면,
        DetachEffect(self, 'F_bg_statu_blue')
        local zoneClsName = GetZoneName(self)
        local guildObj = GetGuildObj(lastattacker)
        AddEnhancerDestroyGuildList(zoneClsName, guildObj) --증폭기 파괴 길드 리스트 추가 필요
        DestroyEnhancerMongo(self, lastattacker)
        local rule = GetClass("guild_colony_rule", "GuildColony_Rule_Default"); --GuildColonyRule.xml에 저장된 콜로니전 룰 칼럼값
        local enhancerCount = TryGetProp(rule, "GuildColonyEnhancerCount") --콜로니 증폭기 개수
        local owner = nil
        local enhancer_num
        for i = 1, enhancerCount do
            if GetExArgObject(self, "COLONY_ENHANCER_"..i) ~= nil then
                owner = GetExArgObject(self, "COLONY_ENHANCER_"..i)
                enhancer_num = i
            end
        end
        if owner ~= nil then
            local guildID = GetIESID(guildObj)
            local now_time = os.date('*t')
            local year = now_time['year']
            local month = now_time['month']
            local day = now_time['day']
            local hour = now_time['hour']
            local min = now_time['min']
            local sec = now_time['sec']
            local time = tostring(year..month..day).."/"..tostring(((hour*3600) + (min*60) + sec))
            SetExProp_Str(owner, "ENHANCER_DESTROY_GUILD_"..enhancer_num, guildID)
            SetExProp_Str(owner, "ENHANCER_DESTROY_TIME_"..enhancer_num, time)
        end

        local pcList, pcCount = GetLayerPCList(GetZoneInstID(self), GetLayer(self))
        if pcCount > 0 then
        	local name = GetTeamName(lastattacker)
            local partyName = GetPartyName(guildObj)
            local occupationGuildObj = GetColonyOccupationGuild(zoneClsName)
    	    for P = 1, pcCount do
                if IsSameObject(guildObj, GetGuildObj(pcList[P])) == 1 then --마지막 타격자와 같은 길드라면,
                    local buff = GetBuffByName(pcList[P], 'GuildColony_EnhancerDestroyBuff_1')
                    if buff == nil then --포인트 버프를 받고있지 않다면,
                        AddBuff(self, pcList[P], 'GuildColony_EnhancerDestroyBuff_1', 1, 0, 0, 1) --포인트 버프 추가
                    else
                        AddBuff(self, pcList[P], 'GuildColony_EnhancerDestroyBuff_1', 1, 0, 0, 1) --포인트 버프 중첩 추가
                    end
                    AddBuff(self, pcList[P], 'GuildColony_EnhancerDestroyBuff_2', 1, 0, 600000, 1) --이속 증가 버프(10분) 추가
                    buff = GetBuffByName(pcList[P], 'GuildColony_EnhancerDestroyBuff_1')
                    SendAddOnMsg(pcList[P], 'NOTICE_Dm_raid_clear', ScpArgMsg("GUILD_COLONY_MSG_ENHANCER_DESTROY_BUFF{name}{buff}", "name", name, "buff", buff.Name), 15) --증폭기 파괴한 마지막 타격자의 팀명, 길드명 알림 메시지(존 내 인원)
                    PlayEffect(pcList[P], 'F_lineup002_blue', 1, 'BOT')
                else
                    SendAddOnMsg(pcList[P], 'NOTICE_Dm_Bell', ScpArgMsg("GUILD_COLONY_MSG_ENHANCER_DESTROY{partyName}{name}", "partyName", partyName, "name", name), 15) --증폭기 파괴한 마지막 타격자의 팀명, 길드명 알림 메시지(존 내 인원)
        	    end
        	end
        end
    end
end
