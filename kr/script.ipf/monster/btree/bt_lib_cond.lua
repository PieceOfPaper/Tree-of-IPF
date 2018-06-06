
--/**
--* @Function       BT_COND_HATE_ENEMY_NEARBY
--* @Type           Cond
--* @Description        Hate가 있는 적이 있는지
--**/
function BT_COND_HATE_ENEMY_NEARBY(self, state, btree, prop)
    local enemy = GetNearTopHateEnemy(self)

    if enemy == nil then
        return BT_FAILED;
    else
        return BT_SUCCESS;
    end
end

--/**
--* @Function       BT_COND_NO_HATE_ENEMY_NEARBY
--* @Type           Cond
--* @Description        Hate가 있는 적이 없는지
--**/
function BT_COND_NO_HATE_ENEMY_NEARBY(self, state, btree, prop)
    local enemy = GetNearTopHateEnemy(self)

    if enemy == nil then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_NO_ENEMY_NEARBY
--* @Type           Cond
--* @NumArg         거리
--* @Description        주변에 적이 없는지
--**/
function BT_COND_NO_ENEMY_NEARBY(self, state, btree, prop)
    
    local numArg = GetLeafNumArg(prop)
    local enemy = GET_NEAR_ENEMY(self, numArg)
    if enemy == nil then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_EXIST_ENEMY_NEARBY
--* @Type           Cond
--* @NumArg         거리
--* @Description        주변에 적이 있는지
--**/
function BT_COND_EXIST_ENEMY_NEARBY(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop)
    local enemy = GET_NEAR_ENEMY(self, numArg)
    if enemy == nil then
        return BT_FAILED;
    else
        return BT_SUCCESS;
    end
end

--/**
--* @Function       BT_COND_EXIST_PAD
--* @Type           Cond
--* @NumArg         거리
--* @NumArg2            갯수
--* @Description        주변에 장판(PAD)이 갯수 이상 있는지
--**/
function BT_COND_EXIST_PAD(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop)
    local numArg2 = GetLeafNumArg2(prop)
    local x, y, z = GetPos(self);
    local count = SelectPadCount(self, 'ALL', x, y, z, numArg);
    if count > numArg2 then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_PAD_TYPE_COUNT
--* @Type           Cond
--* @NumArg         거리
--* @NumArg2            갯수
--* @Description        주변에 장판(PAD)이 가짓수 이상 있는지
--**/
function BT_COND_PAD_TYPE_COUNT(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop)
    local numArg2 = GetLeafNumArg2(prop)
    
    if MON_COND_PAD_TYPE_COUNT(self, numArg, numArg2) == 1 then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_OBJ_TYPE_COUNT
--* @Type           Cond
--* @NumArg         거리
--* @NumArg2            갯수
--* @Description        주변에 OBJECT가 가짓수 이상 있는지
--**/
function BT_COND_OBJ_TYPE_COUNT(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop)
    local numArg2 = GetLeafNumArg2(prop)

    local count = BT_LIB_GET_OBJ_TYPE_COUNT(self, numArg, "ENEMY")
    if count >= numArg2 then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_PAD_OBJ_TYPE_COUNT
--* @Type           Cond
--* @NumArg         거리
--* @NumArg2            갯수
--* @Description        주변에 PAD, OBJECT 가 가짓수 이상 있는지
--**/
function BT_COND_PAD_OBJ_TYPE_COUNT(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop)
    local numArg2 = GetLeafNumArg2(prop)
    
    local padCount = BT_LIB_GET_PAD_TYPE_COUNT(self, numArg);
    local objCount = BT_LIB_GET_OBJ_TYPE_COUNT(self, numArg, "ENEMY")
    local count = padCount + objCount;

    if count >= numArg2 then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_IS_MOVING
--* @Type           Cond
--* @NumArg         더미1
--* @NumArg2        더미2
--* @Description        self 가 움직이는 중인지
--**/
function BT_COND_IS_MOVING(self, state, btree, prop)
    local moving = IsMoving(self);
    if moving == 1 then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_IS_SKILL_CHASE
--* @Type           Cond
--* @Description        self 가 스킬로 인해 target 을 쫒는 중인지
--**/
function BT_COND_IS_SKILL_CHASE(self, state, btree, prop)
    if MON_COND_IS_SKILL_CHASE(self) == 1 then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_IS_USING_SKILL
--* @Type           Cond
--* @Description        self 가 스킬을 사용중인지
--**/
function BT_COND_IS_USING_SKILL(self, state, btree, prop)
    local skillUsing = IsUsingSkill(self);
    if skillUsing == 1 then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_CHECK_ENEMY_MIN_NUM
--* @Type           Cond
--* @NumArg         거리
--* @NumArg2        적 수
--* @Description        주변에 적이 NumArg2 이상 있는지
--**/
function BT_COND_CHECK_ENEMY_MIN_NUM(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop)
    local numArg2 = GetLeafNumArg2(prop)
    
    if numArg == 0 or numArg2 == 0 then
        return BT_FAILED;
    end

    local objList, objCount = SelectObject(self, numArg, 'ENEMY');
    
    if objCount < numArg2 then
        return BT_FAILED;
    else
        return BT_SUCCESS;
    end
end

--/**
--* @Function       BT_COND_CHECK_HP_BELOW
--* @Type           Cond
--* @NumArg         HP Percent
--* @Description        HP가 NumArg % 이하인지
--**/
function BT_COND_CHECK_HP_BELOW(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop)
    local hpPercent = GetHpPercent(self) * 100;
    if hpPercent <= numArg then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_CHECK_HP_MORE
--* @Type           Cond
--* @NumArg         HP Percent
--* @Description        HP가 NumArg % 초과인지
--**/
function BT_COND_CHECK_HP_MORE(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop)
    numArg = numArg / 100;
    
    local hpPercent = GetHpPercent(self);

    if numArg < hpPercent then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_IS_SKILL_COOLDOWN_BYNAME
--* @Type           Cond
--* @NumArg         SkillNum
--* @Description        스킬 이름으로 쿨체크
--**/
function BT_COND_IS_SKILL_COOLDOWN_BYNAME(self, state, btree, prop)
    local skillName = GetLeafStrArg(prop)
    if skillName == "None" then
        return BT_FAILED;
    end

    local isCoolDown = IsSkillCoolTime(self, skillName);
    if isCoolDown == 0 then
        return BT_SUCCESS;
    end

    return BT_FAILED;
end
--/**
--* @Function       BT_COND_IS_SKILL_COOLDOWN
--* @Type           Cond
--* @NumArg         SkillNum
--* @Description        스킬 번호로 쿨체크
--**/
function BT_COND_IS_SKILL_COOLDOWN(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop)
    local skillName = GetMonsterSkillNameByNum(self, numArg-1); 
    
    if skillName == "None" then
        return BT_FAILED;
    end

    local isCoolDown = IsSkillCoolTime(self, skillName);
    if isCoolDown == 0 then
        return BT_SUCCESS;
    end

    return BT_FAILED;
end

--/**
--* @Function       BT_COND_EQUAL_EX_PROP
--* @Type           Cond
--* @StrArg         PropName
--* @NumArg         같은지 비교할 값
--* @Description        같으면 SUCCESS
--**/
function BT_COND_EQUAL_EX_PROP(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local numArg = GetLeafNumArg(prop);
    if strArg == "None" then
        return BT_FAILED;
    end

    local exProp = GetExProp(self, strArg);
    if exProp == numArg then
        return BT_SUCCESS;  
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_UNEQUAL_EX_PROP
--* @Type           Cond
--* @StrArg         PropName
--* @NumArg         다른지 비교할 값
--* @Description        다르면 SUCCESS
--**/
function BT_COND_UNEQUAL_EX_PROP(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local numArg = GetLeafNumArg(prop);
    if strArg == "None" then
        return BT_FAILED;
    end

    local exProp = GetExProp(self, strArg);
    if exProp ~= numArg then
        return BT_SUCCESS;  
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_HATEST_IS_FAR
--* @Type           Cond
--* @NumArg         거리
--* @Description        어그로 1위가 NumArg 이상 멀리있는지
--**/
function BT_COND_HATEST_IS_FAR(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    
    if MON_COND_HATEST_IS_FAR(self, numArg) == 1 then
        return BT_SUCCESS;
    else
        return BT_FAILED
    end
end

--/**
--* @Function       BT_COND_HATEST_IS_NEAR
--* @Type           Cond
--* @NumArg         거리
--* @Description        어그로 1위가 NumArg 이내에 있는지
--**/
function BT_COND_HATEST_IS_NEAR(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    
    if MON_COND_HATEST_IS_NEAR(self, numArg) == 1 then
        return BT_SUCCESS;
    else
        return BT_FAILED
    end
end

--/**
--* @Function       BT_COND_BELOW_NOT_CHECKED_HP
--* @Type           Cond
--* @NumArg         체크할 HP
--* @StrArg         추가할 이름
--* @Description        HP 이하이고 아직 체크되지 않았는지
--**/
function BT_COND_BELOW_NOT_CHECKED_HP(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    local strArg = GetLeafStrArg(prop);
    if strArg == nil then
        strArg = "";
    end
    local hpCheckStr = "BT_EX_CHECK_HP_" .. strArg .. "_" .. tostring(numArg);
    
    numArg = numArg / 100;  
    local hpPercent = GetHpPercent(self);
    if hpPercent <= numArg then
        if GetExProp(self, hpCheckStr) ~= 1 then
            return BT_SUCCESS;  
        end
    end

    return BT_FAILED;   
end

--/**
--* @Function       BT_COND_RANDOM_BY_PERCENT
--* @Type           Cond
--* @NumArg         Percent
--* @Description        Percent 확률로 SUCCESS
--**/
function BT_COND_RANDOM_BY_PERCENT(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    local random = IMCRandom(1, 100)

    if numArg >= random then
        return BT_SUCCESS;  
    end
    return BT_FAILED;   
end

--/**
--* @Function       BT_COND_TOP_HATED_TIME
--* @Type           Cond
--* @NumArg         Second
--* @Description        어그로 1위가 지속된 시간이 Second 이상이면
--**/
function BT_COND_TOP_HATED_TIME(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);

    if MON_COND_TOP_HATED_TIME(self, numArg) == 1 then
        return BT_SUCCESS;
    else
        return BT_FAILED;   
    end
end

--/**
--* @Function       BT_COND_HAS_BUFF
--* @Type           Cond
--* @StrArg         버프 이름
--* @NumArg         거리
--* @NumArg2            적 수
--* @Description        NumArg 거리 내 StrArg 버프를 NumArg2 이상의 적이 가지고 있을 경우
--**/
function BT_COND_HAS_BUFF(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local numArg = GetLeafNumArg(prop);
    local numArg2 = GetLeafNumArg2(prop);
    
    if MON_COND_HAS_BUFF(self, strArg, numArg, numArg2) == 1 then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_ENEMY_IN_DONUT
--* @Type           Cond
--* @NumArg         min Dist
--* @NumArg2        max Dist
--* @Description        min Dist ~ maxDist 사이에 있는 적이 있는가
--**/
function BT_COND_ENEMY_IN_DONUT(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    local numArg2 = GetLeafNumArg2(prop);
    
    local minList, minCount = SelectObjectNear(self, self, numArg, 'ENEMY');
    local maxList, maxCount = SelectObjectNear(self, self, numArg2, 'ENEMY');

    if maxCount == 0 then
        return BT_FAILED;
    end

    if minCount < maxCount then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_UNEQUAL_LAST_SKILL
--* @Type           Cond
--* @NumArg         skillNum
--* @Description        마지막 스킬이 skillNum과 다른지
--**/
function BT_COND_UNEQUAL_LAST_SKILL(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    
    local selectedSkill = GetMonsterSkillNameByNum(self, numArg-1)
    local lastSkill = GetLastUseSkillName(self);

    if lastSkill == selectedSkill then
        return BT_FAILED;
    else
        return BT_SUCCESS;
    end
end

--/**
--* @Function       BT_COND_EQUAL_LAST_SKILL
--* @Type           Cond
--* @NumArg         skillNum
--* @Description        마지막 스킬이 skillNum과 같은지
--**/
function BT_COND_EQUAL_LAST_SKILL(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    
    local selectedSkill = GetMonsterSkillNameByNum(self, numArg-1)
    local lastSkill = GetLastUseSkillName(self);

    if lastSkill == selectedSkill then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_LAST_SKILL_COUNT
--* @Type           Cond
--* @NumArg         횟수 (> 1);
--* @Description        최근 NumArg 회 내 사용한 스킬이 모두 동일한지
--**/
function BT_COND_LAST_SKILL_COUNT(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    if numArg <= 1 then
        return BT_FAILED;
    end

    local lastSkill = GetLastUseSkillName(self);
    if lastSkill == "None" then
        return BT_FAILED;
    end

    for i = 1, numArg - 1 do
        local skillName = GetUsedSkillName(self, i);
        if lastSkill ~= skillName then
            return BT_FAILED;
        end
    end
    return BT_SUCCESS;
end

--/**
--* @Function       BT_COND_IS_PHASE
--* @Type           Cond
--* @NumArg         Phase
--* @Description        현재 Phase 가 NumArg 인지
--**/
function BT_COND_IS_PHASE(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    local phase = GetPhase(btree)
    if numArg == phase then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_IS_HP_CHECKED
--* @Type           Cond
--* @StrArg         Tag
--* @NumArg         HP
--* @Description        Tag가 HP 까지 체크 되었는지
--**/
function BT_COND_IS_HP_CHECKED(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local numArg = GetLeafNumArg(prop);
    local isChecked = IsHPChecked(btree, strArg, numArg);

    if isChecked == 1 then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end

--/**
--* @Function       BT_COND_IS_NOT_HP_CHECKED
--* @Type           Cond
--* @StrArg         Tag
--* @NumArg         HP
--* @Description        Tag가 HP 까지 체크 되지 않았는지
--**/
function BT_COND_IS_NOT_HP_CHECKED(self, state, btree, prop)
    local strArg = GetLeafStrArg(prop);
    local numArg = GetLeafNumArg(prop);
    local isChecked = IsHPChecked(btree, strArg, numArg);

    if isChecked == 0 then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end



--/**
--* @Function    BT_ACT_SELF_DEBUFF_LIST_CHECK
--* @Type   Cond
--* @NumArg     체크할 디버프 갯수(이상)
--* @Description    자신에게 디버프가 N개 이상일 때
--**/

function BT_ACT_SELF_DEBUFF_LIST_CHECK(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    local list, cnt = GetBuffList(self)
    local i
    local count = 0
    for i = 1, cnt do
        if list[i].Group1 == 'Debuff' then
            count = count + 1
        end
    end
    if count >= numArg then
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end
end


--/**
--* @Function    BT_ACT_SELF_RUNAWAY
--* @Type   Cond
--* @NumArg    도망칠 거리(이상)
--* @Description    어그로 1순위에게서 도망친다.
--**/

function BT_ACT_SELF_RUNAWAY(self, state, btree, prop)
        local numArg = GetLeafNumArg(prop);
        local topHater = GetTopHatePointChar(self);
        if topHater == nil then
            return BT_FAILED;
        end
--        SkillCancel(scpTarget);
        ChangeMoveSpdType(self, "RUN");
        RunAwayFrom(self, topHater, numArg)
end

--/**
--* @Function    BT_COND_SELF_MOVE_CHECK
--* @Type   Cond
--* @NumArg    시간
--* @Description    자신이 이동이 가능한지 여부 체크
--**/

function BT_COND_SELF_MOVE_CHECK(self, state, btree, prop)
    local numArg = GetLeafNumArg(prop);
    local target = GetReservedTarget(btree);
    local targetMissingCheck = IsEnableMoveCloseToTarget(self, target, 100)
    local nowSec = math.floor(os.clock())
    local propSave = GetExProp(self, 'firsttime')
    if targetMissingCheck == 0 and propSave == 0 then
        SetExProp(self, 'firsttime', nowSec)
    end
    
    if targetMissingCheck ~= 0 then
        SetExProp(self, 'firsttime', 0)
    end
    
    local missingTime = nowSec - propSave
    if propSave == 0 then
        missingTime = 0
    end
    if missingTime >= numArg then
        SetExProp(self, 'firsttime', 0)
        return BT_SUCCESS;
    else
        return BT_FAILED;
    end    
    
    return BT_FAILED;
end
