-- 

--/**
--* @Function       BT_ACT_SUCCESS
--* @Type           Act
--* @Description        성공(Success)
--**/
function BT_ACT_SUCCESS(self, curState)
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_FAILED
--* @Type           Act
--* @Description        실패(Failed)
--**/
function BT_ACT_FAILED(self, curState)
    return BT_FAILED;
end

--/**
--* @Function       BT_ACT_RUNNING
--* @Type           Act
--* @Description        실행중(Running)
--**/
function BT_ACT_RUNNING(self, curState)
    return BT_RUNNING;
end

--/**
--* @Function       BT_ACT_SUSPEND
--* @Type           Act
--* @Description        중지(Suspend)
--**/
function BT_ACT_SUSPEND(self, curState)
    return BT_SUSPEND;
end

--/**
--* @Function       BT_ACT_READY
--* @Type           Act
--* @Description        대기(Ready)
--**/
function BT_ACT_READY(self, curState)
    return BT_READY;
end

--/**
--* @Function       BT_ACT_NORMAL_INCREASE_SKILL
--* @Type           Act
--* @Description        스킬 순서 증가
--**/
function BT_ACT_NORMAL_INCREASE_SKILL(self, state, btree, prop)
    local num = GetExProp(self, "SKILL_ORDER_NORMAL");
    if num == nil then
        num = 0;
    end
    SetExProp(self, "SKILL_ORDER_NORMAL", num + 1);
    return BT_SUCCESS;  
end

--/**
--* @Function       BT_ACT_NORMAL_RESET_SKILL
--* @Type           Act
--* @Description        스킬 순서 초기화
--**/
function BT_ACT_NORMAL_RESET_SKILL(self, state, btree, prop)
    SetExProp(self, "SKILL_ORDER_NORMAL", 0);
    return BT_SUCCESS;  
end

--/**
--* @Function       BT_COND_NORMAL_ORDER_SKILL
--* @Type           Cond
--* @NumArg         스킬 번호
--* @Description        NumArg 번 째 스킬 사용 순서인지 검사
--**/
function BT_COND_NORMAL_ORDER_SKILL(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop); 
    
    if GetExProp(self, "SKILL_ORDER_NORMAL") == numArg then
        return BT_SUCCESS;
    end

    return BT_FAILED;
end

--/**
--* @Function       BT_ACT_MOVE_TO_TARGET
--* @Type           Act
--* @NumArg         거리
--* @Description        타겟과 NumArg 거리까지 좁힘
--**/
function BT_ACT_MOVE_TO_TARGET(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    local target = GetReservedTarget(btree);
    
    if target == nil then
        IMC_LOG("ERROR_BTREE", "target[nil]");
        return;
    end

    if IsChasingSkill(self) == 1 then
        return BT_RUNNING;
    end
        
    local curHate = GetHate(self, target);
    if curHate == 0 then
        InsertHate(self, target, 1);
        StopMove(self);
        LookAt(self, target);
    end     

    ChangeMoveSpdType(self, "RUN");
    
    MoveToTarget(self, target, 1);
    
    if GetDistance(self, target) > numArg then
        return BT_RUNNING;  
    end
        
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_SLEEP
--* @Type           Act
--* @NumArg         시간 (miliseconds)
--* @Description        제자리 대기
--**/
function BT_ACT_SLEEP(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    sleep(numArg);
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_GO_HOME
--* @Type           Act
--* @NumArg         거리
--* @Description        집에 감
--**/
function BT_ACT_GO_HOME(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    SAI_HOMEPOS(self, numArg)
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_STOP_MOVE
--* @Type           Act
--* @Description        이동 멈춤
--**/
function BT_ACT_STOP_MOVE(self, state, btree, prop)
    StopMove(self);
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_STOP_ANIM
--* @Type           Act
--* @Description        애니메이션 멈춤
--**/
function BT_ACT_STOP_ANIM(self, state, btree, prop)
    StopAnim(self);
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_CANCEL_SKILL
--* @Type           Act
--* @Description        스킬 취소
--**/
function BT_ACT_CANCEL_SKILL(self, state, btree, prop)
    CancelMonsterSkill(self)
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_ALL_STOP
--* @Type           Act
--* @Description        모든 행동 취소
--**/
function BT_ACT_ALL_STOP(self, state, btree, prop)
    CancelMonsterSkill(self)
    StopMove(self);
    StopAnim(self);
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_SAY_STATE
--* @Type           Act
--* @Description    print MoveState
--**/
function BT_ACT_SAY_STATE(self, state, btree, prop)
    print(GetMoveState(self));
    return BT_FAILED;
end

--/**
--* @Function       BT_ACT_USE_SKILL_SELF
--* @Type           Act
--* @NumArg         스킬 번호
--* @Description        자신에게 스킬 사용
--**/
function BT_ACT_USE_SKILL_SELF(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);

    local selectedSkill = GetMonsterSkillNameByNum(self, numArg-1);
    if selectedSkill == '' or selectedSkill == 'None' then
        local errSkill = selectedSkill;
        if errSkill == nil then
            errSkill = "nil";
        end
        IMC_LOG("ERROR_BTREE", "NumArg[".. numArg .. "] SelectedSkill["..errSkill.."]");
        return BT_FAILED;
    end
    
    SCR_USE_SKILL_WAIT(self, self, selectedSkill);
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_USE_SKILL_SELF_NOWAIT
--* @Type           Act
--* @NumArg         스킬 번호
--* @Description        자신에게 스킬 사용과 즉시 반환
--**/
function BT_ACT_USE_SKILL_SELF_NOWAIT(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);

    local selectedSkill = GetMonsterSkillNameByNum(self, numArg-1);
    if selectedSkill == '' or selectedSkill == 'None' then
        local errSkill = selectedSkill;
        if errSkill == nil then
            errSkill = "nil";
        end
        IMC_LOG("ERROR_BTREE", "NumArg[".. numArg .. "] SelectedSkill["..errSkill.."]");
        return BT_FAILED;
    end
    
    
    UseMonsterSkill(self, self, selectedSkill);
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_FLY_UP
--* @Type           Act
--* @NumArg         Height
--* @Description    하늘로 올라간다
--**/
function BT_ACT_FLY_UP(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    local time = 1;
    local ease = 0.8;
    Fly(self, numArg);
    sleep(time*1000);
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_FLY_DOWN
--* @Type           Act
--* @Description        하늘에서 내려온다
--**/
function BT_ACT_FLY_DOWN(self, state, btree, prop)
    local time = 0.8;
    local ease = 0.2;
    Fly(self, 0);
    sleep(time*1000);
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_USE_SKILL
--* @Type           Act
--* @NumArg         스킬 번호
--* @Description        어그로 1위에게 스킬 사용
--**/
function BT_ACT_USE_SKILL(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    local selectedSkill = GetMonsterSkillNameByNum(self, numArg-1);
    
    if selectedSkill == '' or selectedSkill == 'None' then
        local errSkill = selectedSkill;
        if errSkill == nil then
            errSkill = "nil";
        end
        IMC_LOG("ERROR_BTREE", "NumArg[".. numArg .. "] SelectedSkill["..errSkill.."]");
        return BT_FAILED;
    end

    local target = GetNearTopHateEnemy(self);
    if target == nil then
        IMC_LOG("ERROR_BTREE", "target[nil]");
        return BT_FAILED;
    end

    SCR_USE_SKILL_WAIT(self, target, selectedSkill);
        
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_USE_SKILL_NOWAIT
--* @Type           Act
--* @NumArg         스킬 번호
--* @Description        어그로 1위에게 스킬 사용과 즉시 반환
--**/
function BT_ACT_USE_SKILL_NOWAIT(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    local selectedSkill = GetMonsterSkillNameByNum(self, numArg-1);
    
    if selectedSkill == '' or selectedSkill == 'None' then
        local errSkill = selectedSkill;
        if errSkill == nil then
            errSkill = "nil";
        end
        IMC_LOG("ERROR_BTREE", "NumArg[".. numArg .. "] SelectedSkill["..errSkill.."]");
        return BT_FAILED;
    end

    local target = GetNearTopHateEnemy(self);
    if target == nil then
        IMC_LOG("ERROR_BTREE", "target[nil]");
        return BT_FAILED;
    end

    UseMonsterSkill(self, target, selectedSkill);
        
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_PLAY_ANIM
--* @Type           Act
--* @StrArg         애니 이름
--* @Description    애니함
--**/
function BT_ACT_PLAY_ANIM(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    PlayAnim(self, strArg)
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_SAY_STR_ARG
--* @Type           Act
--* @StrArg         글자
--* @Description        출력함.
--**/
function BT_ACT_SAY_STR_ARG(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    print(strArg);
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_SAY_NUM_ARG
--* @Type           Act
--* @NumArg         숫자
--* @Description        출력함.
--**/
function BT_ACT_SAY_NUM_ARG(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    print(numArg);
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_SET_CHECKED_HP
--* @Type           Act
--* @NumArg         체크할 HP
--* @StrArg         추가할 이름
--* @Description        HP 검사 없이 체크 표시함
--**/
function BT_ACT_SET_CHECKED_HP(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    local strArg = GetLeafStrArg(prop);
    if strArg == nil then
        strArg = "";
    end
    local hpCheckStr = "BT_EX_CHECK_HP_" .. strArg .. "_" .. tostring(numArg);
    SetExProp(self, hpCheckStr, 1);
    return BT_SUCCESS;  
end

--/**
--* @Function       BT_ACT_SET_EX_PROP
--* @Type           Act
--* @NumArg         Value
--* @StrArg         PropName
--* @Description        SetExProp 설정.
--**/
function BT_ACT_SET_EX_PROP(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local numArg = GetLeafNumArg(prop);
    if strArg == "None" then
        return BT_FAILED;
    end
        
    SetExProp(self, strArg, numArg);
    return BT_SUCCESS;  
end

--/**
--* @Function       BT_ACT_RESET_HATE
--* @Type           Act
--* @Description        어그로 초기화
--**/
function BT_ACT_RESET_HATE(self, state, btree, prop)
    ResetHate(self)
    return BT_SUCCESS;  
end

--/**
--* @Function       BT_ACT_ADD_BUFF
--* @Type           Act
--* @StrArg         버프 이름
--* @StrArg2            타겟 설정(self, target, owner)
--* @Description        버프 검
--**/
function BT_ACT_ADD_BUFF(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local strArg2 = GetLeafStrArg2(prop);
    local target = self
    
    if strArg2 == 'owner' then
        target = GetOwner(self)
    elseif
        strArg2 == 'target' then
        target = GetReservedTarget(btree);
    end
    
    AddBuff(self, target, strArg)

    return BT_SUCCESS;  
end

--/**
--* @Function       BT_ACT_ADD_BUFF_ARGS
--* @Type           Act
--* @StrArg         버프 이름
--* @NumArg         arg1
--* @NumArg2        arg2
--* @NumArg3        time
--* @Description        버프 검 (arg1, arg2, time)
--**/
function BT_ACT_ADD_BUFF_ARGS(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local numArg = GetLeafNumArg(prop);
    local numArg2 = GetLeafNumArg2(prop);
    local numArg3 = GetLeafNumArg3(prop);
    AddBuff(self, self, strArg, numArg, numArg2, numArg3, 1);

    return BT_SUCCESS;  
end

--/**
--* @Function       BT_ACT_REMOVE_BUFF
--* @Type           Act
--* @StrArg         버프 이름
--* @Description        버프 품
--**/
function BT_ACT_REMOVE_BUFF(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    RemoveBuff(self, strArg)
    return BT_SUCCESS;  
end

--/**
--* @Function       BT_ACT_INSERT_HATE_RANDOMLY
--* @Type           Act
--* @NumArg         거리
--* @Description        거리내 랜덤한 적에게 Hate insert
--**/
function BT_ACT_INSERT_HATE_RANDOMLY(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    
    local list, count = SelectObjectNear(self, self, numArg, 'ENEMY');
    
    if count <= 0 then
        return BT_FAILED;
    end

    local random = IMCRandom(1, count)
    local target = list[random];
    
    InsertHate(self, target, 1)

    return BT_SUCCESS;  
end

--/**
--* @Function       BT_ACT_ENABLE_IGNORE_OBB
--* @Type           Act
--* @Description        Enable Ignore OBB
--**/
function BT_ACT_ENABLE_IGNORE_OBB(self, state, btree, prop)
    EnableIgnoreOBB(self, 1);
    return BT_SUCCESS;  
end

--/**
--* @Function       BT_ACT_DISABLE_IGNORE_OBB
--* @Type           Act
--* @Description        Disable Ignore OBB
--**/
function BT_ACT_DISABLE_IGNORE_OBB(self, state, btree, prop)
    EnableIgnoreOBB(self, 0);
    return BT_SUCCESS;  
end

--/**
--* @Function       BT_ACT_REQ_MON_USE_SKILL_TO_MON
--* @Type           Act
--* @StrArg         Monster ClassName
--* @StrArg2        Monster SkillName
--* @Description        몬스터를 ClassName으로 찾아서 SkillName 스킬을 스스로에게 쓰게한다.
--**/
function BT_ACT_REQ_MON_USE_SKILL_TO_MON(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local strArg2 = GetLeafStrArg2(prop);

    if strArg == '' or strArg == 'None' then
        return BT_FAILED;
    end

    if strArg2 == '' or strArg2 == 'None' then
        local errSkill = strArg2;
        if errSkill == nil then
            errSkill = "nil";
        end
        IMC_LOG("ERROR_BTREE", "SelectedSkill["..errSkill.."]");

        return BT_FAILED;
    end
    
    local zoneID = GetZoneInstID(self);
    local layer = GetLayer(self);
    local list, cnt = GetLayerMonList(zoneID, layer);

    if cnt <= 0 then
        return BT_FAILED;
    end

    local monCnt = 0;
    for i=1, cnt do
        local mon = list[i];
        if TryGetProp(mon, "ClassName") == strArg then
        UseMonsterSkill(mon, mon, strArg2);
            monCnt = monCnt + 1;
        end
    end

    if monCnt > 0 then
        return BT_SUCCESS;  
    end
    return BT_FAILED;
end


--/**
--* @Function       BT_ACT_MON_USE_SKILL_TO_MON
--* @Type           Act
--* @StrArg         Monster ClassName
--* @StrArg2        Monster SkillName
--* @Description        몬스터를 ClassName으로 찾아서 SkillName 스킬을 스스로에게 슬립없이 사용.
--**/
function BT_ACT_MON_USE_SKILL_TO_MON(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local strArg2 = GetLeafStrArg2(prop);

    if strArg == '' or strArg == 'None' then
        return BT_FAILED;
    end

    if strArg2 == '' or strArg2 == 'None' then
        local errSkill = strArg2;
        if errSkill == nil then
            errSkill = "nil";
        end
        IMC_LOG("ERROR_BTREE", "SelectedSkill["..errSkill.."]");

        return BT_FAILED;
    end
    
    local zoneID = GetZoneInstID(self);
    local layer = GetLayer(self);
    local list, cnt = GetLayerMonList(zoneID, layer);

    if cnt <= 0 then
        return BT_FAILED;
    end

    local monCnt = 0;
    for i=1, cnt do
        local mon = list[i];
        if TryGetProp(mon, "ClassName") == strArg then
        UseMonsterSkill(mon, mon, strArg2);
            monCnt = monCnt + 1;
        end
    end

    if monCnt > 0 then
        return BT_SUCCESS;  
    end
    return BT_FAILED;
end




--/**
--* @Function       BT_ACT_REQ_MON_REMOVE_PAD
--* @Type           Act
--* @StrArg         Monster ClassName
--* @Description        몬스터를 ClassName으로 찾아서 사용한 Pad를 모두 지우게 한다.
--**/
function BT_ACT_REQ_MON_REMOVE_PAD(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    
    if strArg == nil or strArg == 'None' then
        return BT_FAILED;
    end

    local zoneID = GetZoneInstID(self);
    local layer = GetLayer(self);
    local list, cnt = GetLayerMonList(zoneID, layer);
    
    if cnt <= 0 then
        return BT_FAILED;
    end
    
    local monCnt = 0;
    for i=1, cnt do
        local mon = list[i];
        if TryGetProp(mon, "ClassName") == strArg then
            RemoveAllPad(mon);
            monCnt = monCnt + 1;
        end
    end

    if monCnt > 0 then
        return BT_SUCCESS;
    end
    return BT_FAILED
end

--/**
--* @Function       BT_ACT_SET_MAX_DEFENCED
--* @Type           Act
--* @NumArg         0 or 1
--* @Description    MaxDefenced 상태로 만든다. (1:설정 0:해제)
--**/
function BT_ACT_SET_MAX_DEFENCED(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    if numArg > 0 then
        self.MaxDefenced_BM = 1;
    else
        self.MaxDefenced_BM = 0;
    end
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_SET_PHASE
--* @Type           Act
--* @NumArg         Phase
--* @Description        Phase 설정
--**/
function BT_ACT_SET_PHASE(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    SetPhase(btree, numArg);
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_SET_HP_CHECKED
--* @Type           Act
--* @StrArg         Tag
--* @NumArg         HP
--* @Description        Tag를 HP 까지 체크
--**/
function BT_ACT_SET_HP_CHECKED(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local numArg = GetLeafNumArg(prop);
    SetHPChecked(btree, strArg, numArg);
    return BT_SUCCESS;
end


--/**
--* @Function       BT_ACT_SET_HP_CHECKED_MIN_MAX
--* @Type           Act
--* @StrArg         Tag
--* @NumArg         min
--* @NumArg2        max
--* @Description        Tag를 min~max 사이에 체크
--**/
function BT_ACT_SET_HP_CHECKED_MIN_MAX(self, state, btree, prop)
-- 10~30
    local strArg = GetLeafStrArg(prop);
    local numArg = GetLeafNumArg(prop);
    local numArg2 = GetLeafNumArg2(prop);

    local random = IMCRandom(numArg, numArg2);

    SetHPChecked(btree, strArg, random);
    return BT_SUCCESS;
end

--/**
--* @Function       BT_COND_CUR_HP_ABOVE_TAG
--* @Type           Cond
--* @StrArg         Tag
--* @Description        Tag와 현재 HP를 비교 HP >= Tag
--**/
function BT_COND_CUR_HP_ABOVE_TAG(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local goal = GetHPChecked(btree, strArg);
    
    local curHP = GetHpPercent(self)*100;
    if curHP >= goal then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_CUR_HP_BELOW_TAG
--* @Type           Cond
--* @StrArg         Tag
--* @Description        Tag와 현재 HP를 비교 HP <= Tag
--**/
function BT_COND_CUR_HP_BELOW_TAG(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local goal = GetHPChecked(btree, strArg);
        if  goal == nil then
            return BT_FAILED;
        end

    local curHP = GetHpPercent(self)*100;
    if curHP <= goal then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_ACT_TARGET_RANDOMLY_RELATIONTYPE
--* @Type           Act
--* @StrArg         RerationType(ENEMY, MONSTER, PARTY)
--* @NumArg         MaxDistance
--* @Description        거리 내 랜덤 대상 선택
--**/
function BT_ACT_TARGET_RANDOMLY_RELATIONTYPE(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local numArg = GetLeafNumArg(prop)
    local objList, objCount = SelectObject(self, numArg, 'FRIEND');
    
    if objCount == 0 then
        return BT_FAILED;
    end
    
    local i = IMCRandom(1, objCountt);
    local enemy = objList[i];

    SetReservedTarget(btree, enemy);
    return BT_SUCCESS;  
end

--/**
--* @Function       BT_ACT_TARGET_FACTION_CHECNK
--* @Type           Act
--* @StrArg         Faction(Monster, Summon, NPC)
--* @Description        타겟 팩션 체크
--**/
function BT_ACT_TARGET_FACTION_CHECNK(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local target = GetReservedTarget(btree);
    
    if strArg == nil then
        IMC_LOG("ERROR_BTREE", "StrArg[nil]");
        return BT_FAILED;
    end
    
    if IS_PC(target) == true then
        return BT_FAILED;
    end
    
    if target.Faction ~= strArg then
        return BT_FAILED;
    end
    return BT_SUCCESS;  
end

--/**
--* @Function       BT_ACT_TARGET_MONRANK_CHECNK
--* @Type           Act
--* @StrArg         MonRank
--* @Description        타겟 MonRank 체크
--**/
function BT_ACT_TARGET_MONRANK_CHECNK(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local target = GetReservedTarget(btree);

    if strArg == nil then
        IMC_LOG("ERROR_BTREE", "StrArg[nil]");
        return BT_FAILED;
    end
    
    if IS_PC(target) == true then
        return BT_FAILED;
    end
    
    if target.MonRank ~= strArg then
        return BT_FAILED;
    end
    return BT_SUCCESS;  
end


--/**
--* @Function       BT_MONRANK_FOLLOW_LIVE
--* @Type           Cond
--* @StrArg         Monster ClassName
--* @Description        몬스터의 자식 살아있는지 체크
--**/ 
function BT_MONRANK_FOLLOW_LIVE(self)
    local followerList, followercnt = GetFollowerList(self);
    if followerList == nil or followercnt == 0 then

        return BT_FAILED;
    end

    return BT_SUCCESS;
end


------/**
------* @Function       BT_MONRANK_FOLLOW_DEAD
------* @Type           Act
------* @StrArg         Monster ClassName
------* @Description        몬스터의 자식 죽어있는지 체크
------**/
function BT_MONRANK_FOLLOW_DEAD(self)
    local flwList = GetFollowerList(self);
    local StrArg = GetTacticsArgFloat(Monster);

    if flwList ~= 0 then
        return BT_FAILED;
    end
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_LAYER_PC_RESERVE_TARGET_RANDOMLY
--* @Type           Act
--* @Description        존에 있는 pc를 체크하여 어그로 예약
--**/

function BT_ACT_LAYER_PC_RESERVE_TARGET_RANDOMLY(self, state, btree, prop)
    local zoneID = GetZoneInstID(self)
    local layer = GetLayer(self);
    local list, cnt = GetLayerPCList(zoneID, layer);
    if cnt == 0 then
        return BT_FAILED;
    end
    local i = IMCRandom(1, cnt);
    local enemy = list[i];
    if enemy == nil then
        return BT_FAILED;
    end
    SetReservedTarget(btree, enemy);
    return BT_SUCCESS;
end

--/**
--* @Function       BT_ACT_SELF_SETPOS
--* @Type           Act
--* @NumArg         1 좌표
--* @NumArg2            2 좌표
--* @NumArg3            3 좌표
--* @Description        좌표 이동
--**/
function BT_ACT_SELF_SETPOS(self, state, btree, prop)
    local x, y, z = GetPos(self)
    local numArg = GetLeafNumArg(prop);
    local numArg2 = GetLeafNumArg2(prop);
    local numArg3 = GetLeafNumArg3(prop);
    
    SetPos(self, numArg, numArg2, numArg3)
    return BT_SUCCESS;
end


--/**
--* @Function       BT_ACT_GET_SELF_USE_SKILL
--* @Type           Act
--* @Description        자신의 스킬을 검사해 그중 랜덤으로 스킬사용.
--**/
function BT_ACT_GET_SELF_USE_SKILL(self,state, btree, prop)
    local target = GetReservedTarget(btree);
    local selectedSkill = SelectMonsterSkillByRatio(self);
    if target == nil then
        return BT_FAILED;
    end
     UseMonsterSkill(self, target, selectedSkill);
    --SCR_USE_SKILL_WAIT(self, target, selectedSkill);
        
    return BT_SUCCESS;
end
