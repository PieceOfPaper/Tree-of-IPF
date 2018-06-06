-- development_script.lua



function DEV_CHEAT(self)
    local cheatList = {
    					"ClassID 중복 검사",
    					"XML 파일 깨짐 검사",
                        "테스트용 검 연습대 소환",
                        "특성샵에 있는 어빌리티 출력(C:\)",
                        "특성 배우기",
                        "특성 배우기(습득 가능한 모든 특성)",
                        "모든 무기 사용 특성 배우기",
                        "모든 맵 탐사율 100% (재접속 필요)",
                        "인벤토리 아이템 전부 감정",
                        "개발용 랭크 초기화",
                        "몬스터 소환 후 킬",
                        "버프 스킬 리스트 출력(C:\)",
                        "재료 기준 레시피 검색 및 출력(C:\)"
                      }
                      
    local cheatFunc = {
    					{ "D_CHECK" },
    					{ "XML_CHECK" },
                        { "TEST_MON", "몬스터 레벨", "몬스터 수", "속성(숫자 입력){nl}1 = 불 / 2 = 얼음 / 3 = 전기 / 4 = 땅 / 5 = 독 / 6 = 어둠 / 7 = 신성 / 8 = 염", "종족(숫자 입력){nl}1 = 야수형 / 2 = 식물형 / 3 = 변이형 / 4 = 악마형 / 5 = 곤충형", "방어타입(숫자 입력){nl}1 = 천 / 2 = 가죽 / 3 = 판금 / 4 = 유체", "크기(숫자 입력){nl}1 = 소형(S) / 2 = 중형(M) / 3 = 대형(L) / 4 = 초대형(XL)", "이동타입(숫자 입력){nl}1 = 지상형 / 2 = 공중형 / 3 = 고정형" },
                        { "JOB_ABIL_LIST", "ClassName(Job){nl} 입력하지 않으면 모든 클래스 출력" },
                        { "ABIL_UP", "ClassName(Abiliy)", "Ability Level" },
                        { "ABIL_MASTER", "강화특성 레벨{nl} 최대 몇레벨 까지 올릴 것인가? (입력하지 않으면 MaxLevel)" },
                        { "WEAPON_MASTER" },
                        { "BLACK_SHEEP_WALL" },
                        { "ALL_APPRAISAL" },
                        { "DEV_RANK_RESET" },
                        { "CREATE_MON_AND_KILL", "ClassName(Monster)", "1회당 몬스터 소환 수", "반복 소환 횟수" },
                        { "JOB_BUFF_SKILL_LIST", "Job Name{nl}(skill.xml에 있는 Job 컬럼값" },
                        { "RECIPE_SEARCH", "ClassName(Item)", "xml 파일을 생성할 것인가? (0 or 1){nl} 0 = 생성하지 않음, 1 = 생성{nl} (xml 파일은 C:\에 생성)" }
                      }
    
    local selectList = SCR_SEL_LIST(self, cheatList, "Cheat_Start_dlg1", 1);
    if selectList > #cheatFunc then
        return;
    end
    
    local script = cheatFunc[selectList][1];
    local argList = { };
    if #cheatFunc[selectList] >= 1 then
        local dialogText = "EMPTY_DIALOG" .. '\\';
        for i = 2, #cheatFunc[selectList] do
            argList[#argList + 1] = ShowTextInputDlg(self, 0, dialogText..cheatFunc[selectList][i]);
        end
    end
    
    _G[script](self, unpack(argList))
end



-- 특성 배우기 --
-- //run ABIL_UP (특성ClassName) (특성레벨) --
function ABIL_UP(pc, abilName, lv)
    if abilName == nil or abilName == 0 or abilName == "" then
        return;
    end
    
    if lv == nil or lv == 0 or lv == "" then
        lv = 1;
    end
    
    RunScript('ABIL_UP_RUN', pc, abilName, lv)
end

function ABIL_UP_RUN(pc, abilName, lv)
    lv = tonumber(lv)
    
    local abilLv = 0;
    local abil = GetAbility(pc, abilName);
    if abil ~= nil then
        abilLv = abil.Level;
        if lv <= abilLv then
            return
        end
        
        lv = lv - abilLv;
    end
    
    local maxLevel = lv;
    local clsList, clsCnt = GetClassList("Job");
    if clsList ~= nil and clsCnt >= 1 then
        for i = 0, clsCnt - 1 do
            local clsIndex = GetClassByIndexFromList(clsList, i);
            if clsIndex ~= nil then
                local abilCls = GetClass("Ability_"..clsIndex.EngName, abilName)
                if abilCls ~= nil then
                    if abilCls.MaxLevel < lv then
                        Chat(pc, "Ability Max Level : "..abilCls.MaxLevel);
                        lv = abilCls.MaxLevel - abilLv;
                        break;
                    end
                end
            end
        end
    end
    
    for i = 1, lv do
        TEST_ABIL(pc, abilName)
        sleep(100)
    end
end



-- 모든 특성 배우기 --
-- 현재 배울 수 있는 모든 특성을 만렙까지 배움 --
-- //run ABIL_MASTER --
function ABIL_MASTER(pc, limitLv)
	ABIL_RESET(pc);
    RunScript('ABIL_MASTER_RUN', pc, limitLv);
end

function ABIL_MASTER_RUN(pc, limitLv)
    limitLv = tonumber(limitLv);
    if limitLv == 0 or limitLv == nil or limitLv == "" then
        limitLv = 100;
    end
    
    if limitLv > 100 then
        limitLv = 100;
    end
    
    local jobHistory = GetJobHistoryString(pc);
    local myJobList = SCR_STRING_CUT(jobHistory, ";");
    if myJobList ~= nil then
        if #myJobList < 1 then
            return;
        end
        
        for i = 1, #myJobList do
            local jobClass = GetClass("Job", myJobList[i]);
            if jobClass ~= nil then
                local abilClassList, abilClassCount = GetClassList("Ability_"..jobClass.EngName);
                if abilClassList ~= nil then
                    for j = 0, abilClassCount - 1 do
                        local abilClass = GetClassByIndexFromList(abilClassList, j);
                        local abilName = TryGetProp(abilClass, "ClassName");
                        local abilFunc = TryGetProp(abilClass, "UnlockScr");
                        local abilArgStr = TryGetProp(abilClass, "UnlockArgStr");
                        local abilArgNum = TryGetProp(abilClass, "UnlockArgNum");
                        local abilMaxLevel = TryGetProp(abilClass, "MaxLevel");
                        
                        local abilUnlock = _G[abilFunc](pc, abilArgStr, abilArgNum, abilClass);
                        if abilUnlock == "UNLOCK" or abilFunc == 'UNLOCK_ABIL_SKILL' then
                            if abilUnlock ~= "UNLOCK" and abilFunc == 'UNLOCK_ABIL_SKILL' then
                            	Chat(pc, abilName .. " : " .. TryGetProp(abilClass, 'UnlockDesc'));
                            end
                        	
                            local abilLevel = abilMaxLevel;
                            if abilMaxLevel == 100 then
                                abilLevel = limitLv;
                            end
                            
                            local abil = GetAbility(pc, abilName);
                            if abil == nil then
                                TEST_ABIL(pc, abilName);
                                sleep(100);
                                abil = GetAbility(pc, abilName);
                                if abil == nil then
                                    print("Abil Err!!");
                                    break;
                                end
                            end
                            
                            if abil.Level ~= abilLevel then
                                local tx = TxBegin(pc);
                                TxSetIESProp(tx, abil, "Level", abilLevel);
                                local txRet = TxCommit(tx);
                                sleep(100);
                            end
                        end
                    end
                end
            end
        end
        
        Chat(pc, "Ability Master!");
    end
end



-- 특성 지우기 --
-- //run ABIL_RESET (특성ClassName) --
function ABIL_RESET(pc, abilName)
    local abilList = GetAbilityNames(pc);
    if #abilList == 0 then
        return;
    end
    
    if abilName ~= nil and abilName ~= 0 then
        local tx = TxBegin(pc)
        for i = 1, #abilList do
            if abilList[i] == abilName then
                TxRemoveAbility(tx, abilName);
            end
        end
        
        local ret = TxCommit(tx)
        PlayEffect(pc, 'F_circle020_light', 1.0);
        InvalidateStates(pc);
        return;
    end
    
    local tx = TxBegin(pc)
    for i = 1, #abilList do
        TxRemoveAbility(tx, abilList[i])
    end
    
    local ret = TxCommit(tx)
    
    local jobList = GetJobHistoryString(pc)
    jobList = SCR_STRING_CUT_SEMICOLON(jobList);
    for j = 1, #jobList do
        local jobObj = GetClass("Job", jobList[j]);
        local defaultAbilList = StringSplit(jobObj.DefHaveAbil, '#');
        for k = 1 , #defaultAbilList do
            if defaultAbilList[k] ~= 'None' then
                ABIL_UP(pc, defaultAbilList[k], 1);
                sleep(100);
            end
        end
    end
    
    InvalidateStates(pc);
end



-- 모든 무기 사용 특성 마스터 --
-- //run WEAPON_MASTER --
function WEAPON_MASTER(pc)
    local abilList = {
                        "Sword",
                        "THSword",
                        "Spear",
                        "THSpear",
                        "THBow",
                        "Bow",
                        "Staff",
                        "THStaff",
                        "Mace",
                        "Pistol",
                        "Rapier",
                        "Musket",
                        "SubSword",
                        "THMace",
                        "CompanionRide"
                     };
    for i = 1, #abilList do
        local abilName = abilList[i];
        local abil = GetAbility(pc, abilName);
        if abil == nil then
            TEST_ABIL(pc, abilName)
            sleep(100)
        end
    end
end



-- 컴페니언 레벨 업 --
-- //run petlvup (경험치) --
function petlvup(self, exp)
    if exp ~= nil and exp ~= 0 then
        exp = tonumber(exp)
        TestAddPetExp(self, exp)
    end
end



-- 테스트용 검 연습대 소환 --
-- //run TEST_MON (레벨) (소환 수) --
-- TEST_MON 은 print 없음, TEST_MON2 는 print 포함 --
function TEST_MON(self, lv, cnt, customAttribute, customRaceType, customArmorMaterial, customSize, customMoveType)
    local log = 0;
    local scaleOption = 0;
    
    TEST_MON_RUN(self, log, scaleOption, lv, cnt, customAttribute, customRaceType, customArmorMaterial, customSize, customMoveType)
end

function TEST_MON2(self, lv, cnt, customAttribute, customRaceType, customArmorMaterial, customSize, customMoveType)
    local log = 1;
    local scaleOption = 0;
    TEST_MON_RUN(self, log, scaleOption, lv, cnt, customAttribute, customRaceType, customArmorMaterial, customSize, customMoveType)
end

function TEST_MON_RUN(self, log, scaleOption, lv, cnt, customAttribute, customRaceType, customArmorMaterial, customSize, customMoveType)
    lv = tonumber(lv);
    if lv == nil or lv <= 0 then
        lv = 1;
    end
    
    cnt = tonumber(cnt);
    if cnt == nil or cnt <= 0 then
        cnt = 1;
    end
    
    local x, y, z = GetFrontPos(self, 50);
    
    local mon = { };
    for i = 1, cnt do
        local randomPos = 0;
        if i > 1 then
            randomPos = 50;
        end
        mon[i] = CREATE_MONSTER_EX(self, 'wood_carving', x + IMCRandom((randomPos * -1), randomPos), y, z + IMCRandom((randomPos * -1), randomPos), 0, 'Monster', lv, TEST_MONSTER_SET, customAttribute, customRaceType, customArmorMaterial, customSize, customMoveType);
        AddBuff(mon[i], mon[i], 'HealingFactor_Buff', 9999, 0, 0, 1)
        AddBuff(mon[i], mon[i], 'HPLock', 1, 0, 0, 1)
        if log == 1 then
            SetTakeDamageScp(mon[i], "TEST_MONSTER_TAKE_DAMAGE_SCRIPT")
        end
        
        if scaleOption == 1 then
            ChangeScale(mon[i], 1.2);
            AddBuff(mon[i], mon[i], "Aiming_Buff", 30, 0, 0, 1);
        end
        
	    local monText = "Size : "..mon[i].Size.." / ".."MoveType : "..mon[i].MoveType;
	    SetTitle(mon[i], monText);
    end
end

function TEST_MON_BIG(self, lv, cnt)
    local log = 0;
    local scaleOption = 1;
    TEST_MON_RUN(self, log, scaleOption, lv, cnt);
end

function TEST_MONSTER_SET(mon, customAttribute, customRaceType, customArmorMaterial, customSize, customMoveType)
    local attributeList = {                 -- [속성] --
                            "Fire",         -- 1. 불 --
                            "Ice",          -- 2. 얼음 --
                            "Lightning",    -- 3. 전기 --
                            "Earth",        -- 4. 땅 --
                            "Poison",       -- 5. 독 --
                            "Dark",         -- 6. 어둠 --
                            "Holy",         -- 7. 신성 --
                            "Soul"          -- 8. 염 --
                          };
    
    local raceTypeList = {              -- [종족] --
                            "Widling",  -- 1. 야수형 --
                            "Forester", -- 2. 식물형 --
                            "Paramune", -- 3. 변이형 --
                            "Velnias",  -- 4. 악마형 --
                            "Klaida"    -- 5. 곤충형 --
                         };
    
    local armorTypeList = {             -- [방어타입] --
                            "Cloth",    -- 1. 천 --
                            "Leather",  -- 2. 가죽 --
                            "Iron",     -- 3. 판금 --
                            "Ghost"     -- 4. 유체 --
                          };
	
    local sizeList = {                  -- [크기] --
                            "S",        -- 1. 소형 --
                            "M",        -- 2. 중형 --
                            "L",        -- 3. 대형 --
                            "XL"        -- 4. 초대형 --
                          };
    
    local MoveTypeList = {			    -- [이동타입] --
                            "Normal",   -- 1. 지상형 --
                            "Flying",   -- 2. 공중형 --
                            "Holding"   -- 3. 고정형 --
                          };
    
    attributeList[0] = "Melee";
    raceTypeList[0] = "None";
    armorTypeList[0] = "None";
    sizeList[0] = "M";
    MoveTypeList[0] = "Holding";
    
    -- 검 연습대의 종족/속성/방어타입에 세팅이 필요한 경우 주석을 풀고 사용 --
    -- 위 배열에서 맞는 번호를 넣으면 됨 --
    -- Ex : 땅속성 검 연습대가 필요한 경우 : mon.Attribute = attributeList[4]; --
    ---------- 여기서부터 수동 설정 구간 ----------
    
    mon.Attribute = attributeList[0];
    mon.RaceType = raceTypeList[0];
    mon.ArmorMaterial = armorTypeList[0];
    mon.Size = sizeList[0];
    mon.MoveType = MoveTypeList[0];
    
    ---------- 여기까지 수동 설정 구간 ----------
    
    
    
	---------- 여기서부터 자동 설정 구간 ----------
	customAttribute = tonumber(customAttribute);
	if customAttribute ~= nil and customAttribute ~= 0 then
		mon.Attribute = attributeList[customAttribute];
	end
	
	customRaceType = tonumber(customRaceType);
	if customRaceType ~= nil and customRaceType ~= 0 then
		mon.RaceType = raceTypeList[customRaceType];
	end
	
	customArmorMaterial = tonumber(customArmorMaterial);
	if customArmorMaterial ~= nil and customArmorMaterial ~= 0 then
		mon.ArmorMaterial = armorTypeList[customArmorMaterial];
	end
	
	customSize = tonumber(customSize);
	if customSize ~= nil and customSize ~= 0 then
		mon.Size = sizeList[customSize];
	end
	
	customMoveType = tonumber(customMoveType);
	if customMoveType ~= nil and customMoveType ~= 0 then
		mon.MoveType = MoveTypeList[customMoveType];
	end
	---------- 여기까지 자동 설정 구간 ----------
	
    mon.MHPRate = 99999;
    
    local monText = "Attribute : "..mon.Attribute.."{nl}".."RaceType : "..mon.RaceType.."{nl}".."Armor : "..mon.ArmorMaterial;
    mon.Name = monText;
end

function TEST_MONSTER_TAKE_DAMAGE_SCRIPT(mon, attacker, skill, damage, ret)
    local skillName = GetExProp_Str(mon, "SkillName");
    local skillLevel = GetExProp(mon, "SkillLevel");
    if (skillName ~= skill.ClassName and skillName ~= nil and skillName ~= "None") or (skillLevel ~= skill.Level and skillLevel ~= nil and skillLevel ~= 0) then
        DelExProp(mon, "SkillLevel");
        DelExProp(mon, "SkillDamage");
        DelExProp(mon, "SkillFactor");
        DelExProp(mon, "SkillHitCount");
        print("------------------------------");
    end
    
    skillName = skill.ClassName;
    SetExProp_Str(mon, "SkillName", skillName);
    
    skillLevel = skill.Level;
    SetExProp(mon, "SkillLevel", skillLevel);
    
    local skillDamage = GetExProp(mon, "SkillDamage");
    skillDamage = skillDamage + damage;
    SetExProp(mon, "SkillDamage", skillDamage);
    
    local skillFactor = GetExProp(mon, "SkillFactor");
    skillFactor = skillFactor + skill.SkillFactor;
    SetExProp(mon, "SkillFactor", skillFactor);
    
    local skillHitCount = GetExProp(mon, "SkillHitCount");
    skillHitCount = skillHitCount + 1;
    SetExProp(mon, "SkillHitCount", skillHitCount);
    
    print(skillName.." (Lv"..skillLevel..")".."\n".."Total Damage : "..skillDamage.."\n".."SkillFactor : "..skillFactor.." Percent".."\n".."Hit Count : "..skillHitCount)
end



-- 스킬 테스트 --
-- //run AUTO_SKILL_TEST (skill.ClassName _ 앞 부분) --
-- Ex : 하이랜더 스킬들을 보고 싶다면 하이랜더 스킬들의 ClassName에 공통으로 들어가는 직업명을 씀 --
-- Highlander_WagonWheel 처럼 "Highlander" 부분을 넣으면 됨 --
function AUTO_SKILL_TEST(self, classStr)
    if classStr == 0 or classStr == nil or classStr == "" then
        classStr = "None";
    end
    
    RunScript("AUTO_SKILL_TEST_RUN", self, classStr)
end

function AUTO_SKILL_TEST_RUN(self, classStr)
    local jobObj = GetJobObject(self);
    if jobObj == nil then
        return
    end
    
    local minSkillID = 0;
    local maxSkillID = 0;
    local CtrlTypeList = { "Warrior", "Wizard", "Archer", "Cleric" }
    for i = 1, #CtrlTypeList do
        if jobObj.CtrlType == CtrlTypeList[i] then
            minSkillID = i * 10000;
            maxSkillID = (i + 1) * 10000;
        end
    end
    
    local clsList, clsCnt = GetClassList("Skill")
    if clsList ~= nil and clsCnt >= 1 then
        SetExProp(self, "AUTO_SKILL_TEST", 1);
        local x, y, z = GetPos(self);
        
        for i = 0, clsCnt - 1 do
            local skill = nil
            local clsIndex = GetClassByIndexFromList(clsList, i)
            if clsIndex.ClassID >= minSkillID and clsIndex.ClassID < maxSkillID then
                local skillClassName = clsIndex.ClassName;
                local skillJob = SCR_STRING_CUT_UNDERBAR(skillClassName);
                if skillJob[1] == classStr or classStr == "None" then
                    if clsIndex.ValueType == "Attack" then
                        local stanceCheck = 0;
                        
                        local myStance = GetStance(self).ClassName;
                        local reqStance = clsIndex.ReqStance;
                        reqStance = SCR_STRING_CUT_SEMICOLON(reqStance);
                        for j = 1, #reqStance do
                            if reqStance[j] == "None" or reqStance[j] == myStance then
                                stanceCheck = 1;
                                break;
                            end
                        end
                        
                        -- 스탠스가 맞지 않을 경우 강제 변경 --
                        if stanceCheck == 0 and reqStance[1] ~= "None" then
                            ChangeStance(self, reqStance[1])
                        end
                        
                        Chat(self, clsIndex.Name.."("..clsIndex.ClassID..")")
                        
                        skill = AddInstSkill(self, skillClassName)
                        if skill ~= nil then
                            UseSkillToNearByEnemy(self, skill)
                            
                            while 1 do
                                sleep(3000)
                                if IsSkillUsing(self) == 0 then
                                    break;
                                end
                            end
                        end
                        
                        -- 스탠스 복구 --
                        if myStance ~= GetStance(self).ClassName then
                            ChangeStance(self, myStance)
                        end
                        
                        if GetDistFromPos(self, x, y, z) >= 1 then
                            SetPos(self, x, y, z);
                            sleep(1000);
                        end
                    end
                end
            end
            
            if GetExProp(self, "AUTO_SKILL_TEST") ~= 1 then
                break;
            end
        end
        
        Chat(self, "Test Complete");
    end
end

function AUTO_SKILL_STOP(self)
    if GetExProp(self, "AUTO_SKILL_TEST") == 1 then
        DelExProp(self, "AUTO_SKILL_TEST");
    end
end



-- 물리 공격력 평균값으로 세팅 --
-- //run AVERAGE_ATK (on / off) --
-- 자동으로 갱신되지 않으니 아이템을 바꾸면 다시 on 세팅 해줘야 함 --
function AVERAGE_ATK(self, switch)
    if switch == 0 then
        switch = "on";
    end
    
    local isAverageATK = GetExProp(self, "IS_AVERAGE_ATK");
    if switch == "on" then
        if isAverageATK == 1 then
            SCR_AVER_ATK_LEAVE(self);
        end
        SCR_AVER_ATK_ENTER(self);
        
        Chat(self, "AverageATK On");
        
        SetExProp(self, "IS_AVERAGE_ATK", 1);
        
        if IsRunningScript(self, 'SCR_AVER_ATK_UPDATE') == 0 then
        	RunScript('SCR_AVER_ATK_UPDATE', self);
        end
    elseif switch == "off" then
        SCR_AVER_ATK_LEAVE(self);
        
        isAverageATK = 0;
        
        Chat(self, "AverageATK Off");
        
        SetExProp(self, "IS_AVERAGE_ATK", 0);
    end
end

function SCR_AVER_ATK_ENTER(self)
    local averagePATK = math.floor((self.MAXPATK + self.MINPATK) / 2);
    local addMaxPATK = self.MAXPATK - averagePATK;
    local addMinPATK = averagePATK - self.MINPATK;
    
    local averagePATK_SUB = math.floor((self.MAXPATK_SUB + self.MINPATK_SUB) / 2);
    local addMaxPATK_SUB = self.MAXPATK_SUB - averagePATK_SUB;
    local addMinPATK_SUB = averagePATK_SUB - self.MINPATK_SUB;
    
    self.MAXPATK_BM = self.MAXPATK_BM - addMaxPATK;
    self.MINPATK_BM = self.MINPATK_BM + addMinPATK;
    
    self.MAXPATK_SUB_BM = self.MAXPATK_SUB_BM - addMaxPATK_SUB;
    self.MINPATK_SUB_BM = self.MINPATK_SUB_BM + addMinPATK_SUB;
	
    SetExProp(self, "ADD_AVER_ATK_MAXPATK", addMaxPATK);
    SetExProp(self, "ADD_AVER_ATK_MINPATK", addMinPATK);
    
    SetExProp(self, "ADD_AVER_ATK_MAXPATK_SUB", addMaxPATK_SUB);
    SetExProp(self, "ADD_AVER_ATK_MINPATK_SUB", addMinPATK_SUB);
    
    Invalidate(self, "MAXPATK")
    Invalidate(self, "MINPATK")
    
    Invalidate(self, "MAXPATK_SUB")
    Invalidate(self, "MINPATK_SUB")
    
	local itemGuidRH = 0;
	local itemRH = GetEquipItem(self, 'RH');
	if itemRH ~= nil then
		itemGuidRH = GetItemGuid(itemRH);
	end
	
	local itemGuidLH = 0;
	local itemLH = GetEquipItem(self, 'LH');
	if itemLH ~= nil then
		itemGuidLH = GetItemGuid(itemLH);
	end
	
	SetExProp_Str(self, 'AVER_ATK_RH_ITEM', itemGuidRH);
	SetExProp_Str(self, 'AVER_ATK_LH_ITEM', itemGuidLH);
end

function SCR_AVER_ATK_UPDATE(self)
	while 1 do
		local isAverageATK = GetExProp(self, "IS_AVERAGE_ATK");
		if isAverageATK ~= 1 then
			break;
		end
		
		local nowGuidRH = 0;
		local nowItemRH = GetEquipItem(self, 'RH');
		if nowItemRH ~= nil then
			nowGuidRH = GetItemGuid(nowItemRH);
		end
		
		local nowGuidLH = 0;
		local nowItemLH = GetEquipItem(self, 'LH');
		if nowItemLH ~= nil then
			nowGuidLH = GetItemGuid(nowItemLH);
		end
		
		local itemGuidRH = GetExProp_Str(self, 'AVER_ATK_RH_ITEM');
		local itemGuidLH = GetExProp_Str(self, 'AVER_ATK_LH_ITEM');
		
		if (nowGuidRH ~= itemGuidRH) or (nowGuidLH ~= itemGuidLH) then
			SCR_AVER_ATK_LEAVE(self);
			SCR_AVER_ATK_ENTER(self);
		end
		sleep(1000);
	end
	
	SCR_AVER_ATK_LEAVE(self);
	
	Chat(self, "AverageATK Off and Update Stop");
end

function SCR_AVER_ATK_LEAVE(self)
    local addMaxPATK = GetExProp(self, "ADD_AVER_ATK_MAXPATK");
    local addMinPATK = GetExProp(self, "ADD_AVER_ATK_MINPATK");
    
    local addMaxPATK_SUB = GetExProp(self, "ADD_AVER_ATK_MAXPATK_SUB");
    local addMinPATK_SUB = GetExProp(self, "ADD_AVER_ATK_MINPATK_SUB");
    
    self.MAXPATK_BM = self.MAXPATK_BM + addMaxPATK;
    self.MINPATK_BM = self.MINPATK_BM - addMinPATK;
    
    self.MAXPATK_SUB_BM = self.MAXPATK_SUB_BM + addMaxPATK_SUB;
    self.MINPATK_SUB_BM = self.MINPATK_SUB_BM - addMinPATK_SUB;
	
    DelExProp(self, "ADD_AVER_ATK_MAXPATK");
    DelExProp(self, "ADD_AVER_ATK_MINPATK");
    
    DelExProp(self, "ADD_AVER_ATK_MAXPATK_SUB");
    DelExProp(self, "ADD_AVER_ATK_MINPATK_SUB");
    
    Invalidate(self, "MAXPATK")
    Invalidate(self, "MINPATK")
    
    Invalidate(self, "MAXPATK_SUB")
    Invalidate(self, "MINPATK_SUB")
    
	DelExProp_Str(self, 'AVER_ATK_RH_ITEM');
	DelExProp_Str(self, 'AVER_ATK_LH_ITEM');
end



-- 특정 몬스터가 전 맵에 몇마리 배치되어 있는지 확인 --
-- //run ALL_MAP_MON_COUNT "MonClassName" --
function ALL_MAP_MON_COUNT(self, monName)
    if monName == nil or monName == 0 then
        return;
    end
    
    local mapClsList, mapClsCount = GetClassList('Map');
    if mapClsList ~= nil then
        print("----------------------------------------")
        local totalMonCount = 0;
        for i = 0, mapClsCount - 1 do
            local map = GetClassByIndexFromList(mapClsList, i);
            local genTypeClsList, genTypeClsCount = GetClassList("GenType_" .. map.ClassName);
            if genTypeClsList ~= nil then
                local mapMon = 0;
                for j = 0, genTypeClsCount do
                    local gen = GetClassByIndexFromList(genTypeClsList, j);
                    if TryGetProp(gen, "ClassType") == monName then
                        local maxPop = TryGetProp(gen, "MaxPop");
                        if maxPop == nil then
                            maxPop = 0;
                        end
                        
                        mapMon = mapMon + maxPop;
                    end
                end
                
                if mapMon ~= 0 then
                    print(map.Name .. "(" .. map.ClassName .. ") : " .. mapMon);
                    totalMonCount = totalMonCount + mapMon;
                end
            end
        end
        
        print("Total Count : " .. totalMonCount);
        print("----------------------------------------")
    end
end



-- 각 클래스 별로 버프 스킬 리스트 출력  --
-- //run JOB_BUFF_SKILL_LIST "jobClassName" --
-- jobClassName 을 생략하면 전 클래스 출력 --
function JOB_BUFF_SKILL_LIST(self, jobClassName)
    if jobClassName == nil or jobClassName == 0 or jobClassName == "" then
        jobClassName = "ALL";
    end
    
    local classList, classCount = GetClassList("Skill");
    if classList == nil or classCount == 0 then
        return;
    end
    
    local skillName = { };
    local skillClassName = { };
    local jobCategory = { };
    
    for i = 0, classCount - 1 do
        local skill = GetClassByIndexFromList(classList, i);
        if skill ~= nil then
            local skillJob = TryGetProp(skill, "Job");
            local valueType = TryGetProp(skill, "ValueType");
            if ((skillJob == jobClassName or jobClassName == "ALL") and skillJob ~= nil )  and valueType == "Buff" then
                skillName[#skillName + 1] = TryGetProp(skill, "Name");
                skillClassName[#skillClassName + 1] = TryGetProp(skill, "ClassName");
                jobCategory[#jobCategory + 1] = skillJob;
            end
        end
    end
    
    local file = io.open("C:\\testxml\\BuffList_" .. jobClassName .. ".xml", "w");
    if file == nil then
        file = io.open("C:\\BuffList_" .. jobClassName .. ".xml", "w");
    end
    
    
    local headText = '<?xml version="1.0" encoding="UTF-8"?>\n<!-- edited with XMLSPY v2004 rel. 2 U (http://www.xmlspy.com) by imc (imc) -->\n    <Category>\n';
    local text = "";
    
    local startLine = '<Class ';
    local endLine = ' />\n';
    
    local jobTemp = nil;
    for j = 1, #skillName do
        if jobTemp == nil then
            text = text .. '<Category Name="' .. jobCategory[j] .. '">\n';
        elseif jobCategory[j] ~= jobTemp then
            text = text .. '</Category>\n';
            text = text .. '<Category Name="' .. jobCategory[j] .. '">\n';
        end
        
        text = text .. startLine .. 'Name="' .. skillName[j] .. '"' .. ' ClassName="' .. skillClassName[j] .. '"' .. endLine;
        
        jobTemp = jobCategory[j];
    end
    
    text = text .. '</Category>\n';
    
    local bottonText = '</Category>';
    
    file:write(headText, text, bottonText);
    io.close(file);
end



function RECIPE_SEARCH(self, itemClassName, createXml)
    if itemClassName == nil or itemClassName == 0 or itemClassName == "" then
        return;
    end
    
    local classList, classCount = GetClassList("Recipe");
    if classList == nil or classCount == 0 then
        return;
    end
    
    if GetClass("Item", itemClassName) == nil then
        return;
    end
    
    -- xml --
    local file = io.open("C:\\testxml\\Recipe_" .. itemClassName .. ".xml", "w");
    if file == nil then
        file = io.open("C:\\Recipe_" .. itemClassName .. ".xml", "w");
    end
    
    local headText = '<?xml version="1.0" encoding="UTF-8"?>\n<!-- edited with XMLSPY v2004 rel. 2 U (http://www.xmlspy.com) by imc (imc) -->\n    <Category>\n';
    local text = "";
    
    local startLine = '<Class ';
    local endLine = ' />\n';
    -- -- --
    
    
    local listClassName = { };
    local listName = { };
    local listCount = { };
    
    for i = 0, classCount - 1 do
        local recipe = GetClassByIndexFromList(classList, i);
        if recipe ~= nil then
            local itemCount = 0;
            for j = 1, 5 do
                local needItem = TryGetProp(recipe, "Item_" .. j .. "_1");
                if needItem == itemClassName then
                    local needitemCount = TryGetProp(recipe, "Item_" .. j .. "_1_Cnt");
                    if needitemCount == nil then
                        needitemCount = 0;
                    end
                    itemCount = itemCount + needitemCount;
                end
            end
            
            if itemCount ~= 0 then
                local itemClassList, itemClassCount = GetClassList("Wiki");
                local recipeClassName = recipe.ClassName;
                local recipeWiki = GetClassByNameFromList(itemClassList, recipeClassName);
                
                print("\n" .. recipeWiki.Name .. " (" .. recipeWiki.ClassName .. ") : " .. itemCount);
                
                listClassName[#listClassName + 1] = recipeWiki.ClassName;
                listName[#listName + 1] = recipeWiki.Name;
                listCount[#listCount + 1] = itemCount;
            end
        end
    end
    
    -- xml --
    for k = 1, #listClassName do
        text = text .. startLine;
        text = text .. 'ClassName="' .. listClassName[k] .. '"';
        text = text .. ' Name="' .. listName[k] .. '"';
        text = text .. ' Count="' .. listCount[k] .. '"';
        text = text .. endLine;
    end
    
    local bottonText = '</Category>';
    
    if tonumber(createXml) == 1 then
        file:write(headText, text, bottonText);
    end
    
    io.close(file);
    -- -- --
end



function CREATE_MON_AND_KILL(self, monClassName, monCount, loop)
    local monClass = GetClass("Monster", monClassName);
    if monClass == nil then
        return;
    end
    
    if monCount == nil or monCount == 0 then
        monCount = 1;
    end
    
    if loop == nil or loop == 0 then
        loop = 1;
    end
    
    local x, y, z = GetPos(self);
    local sx = { 50,  50,  50,   0, -50, -50, -50,   0,  50 };
    local sz = { 50,   0, -50, -50, -50,   0,  50,  50,  50 };
    
    
    AddBuff(self, self, "GUILD_RAID_FOLLOWER", 1, 0, 0, 1);
    
    for i = 1, loop do
        for j = 1, monCount do
            local mon = CREATE_MONSTER_EX(self, monClassName, x, y, z, 0, 'Monster');
        end
        
        sleep(1000);
        
        for k = 1, #sx do
            SetPos(self, x + sx[k], y, z + sz[k]);
            sleep(200);
        end
        
        SetPos(self, x, y, z);
        
        sleep(2000);
    end
    
    RemoveBuff(self, "GUILD_RAID_FOLLOWER");
end



-- 각 클래스 별로 실제 사용되는(상점에서 파는) 특성 리스트 출력  --
-- //run JOB_ABIL_LIST "jobClassName" --
-- jobClassName 을 생략하면 전 클래스 출력 --
function JOB_ABIL_LIST(self, jobClassName)
    if jobClassName == nil or jobClassName == 0 or jobClassName == "" then
        jobClassName = "ALL";
    end
    
	ExecClientScp(self, 'JOB_ABIL_LIST_CLIENT(' .. jobClassName .. ')');
	
--    if jobClassName == nil or jobClassName == 0 or jobClassName == "" then
--        jobClassName = "ALL";
--    end
--    
--    local classList, classCount = GetClassList("Job");
--    if classList == nil or classCount == 0 then
--        return;
--    end
--    
--    local abilList = { };
--    local jobCategory = { };
--    
--    for i = 0, classCount - 1 do
--        local job = GetClassByIndexFromList(classList, i);
--        if job ~= nil then
--            if (jobClassName == TryGetProp(job, "ClassName") or jobClassName == "ALL") and 10 >= TryGetProp(job, "Rank") then
--                local jobName = TryGetProp(job, "EngName");
--                local abilClass, abilCount = GetClassList("Ability_" .. jobName);
--                
--                if abilClass ~= nil then
--                    for j = 0, abilCount - 1 do
--                        local abil = GetClassByIndexFromList(abilClass, j);
--                        if abil ~= nil then
--                            local abilName = TryGetProp(abil, "ClassName");
--                            local abilXML = GetClass("Ability", abilName);
--                            if abilXML ~= nil then
--                                jobCategory[#jobCategory + 1] = TryGetProp(job, "ClassName");
--                                
--                                abilList[#abilList + 1] = abilXML;
--                            end
--                        end
--                    end
--                end
--            end
--        end
--    end
--    
--    
--    
--    local file = io.open("C:\\testxml\\JobAbilList_" .. jobClassName .. ".xml", "w");
--    if file == nil then
--        file = io.open("C:\\JobAbilList_" .. jobClassName .. ".xml", "w");
--    end
--    
--    
--    local headText = '<?xml version="1.0" encoding="UTF-8"?>\n<!-- edited with XMLSPY v2004 rel. 2 U (http://www.xmlspy.com) by imc (imc) -->\n    <Category>\n';
--    local text = "";
--    
--    local startLine = '<Class ';
--    local endLine = ' />\n';
--    
--    local jobTemp = nil;
--    for k = 1, #abilList do
--        if jobTemp == nil then
--            text = text .. '<Category Name="' .. GetClass("Job", jobCategory[k]).Name .. '">\n';
--        elseif jobCategory[k] ~= jobTemp then
--            text = text .. '</Category>\n';
--            text = text .. '<Category Name="' .. GetClass("Job", jobCategory[k]).Name .. '">\n';
--        end
--        
--        local jobEngName = GetClass("Job", jobCategory[k]).EngName;
--        
--        text = text .. startLine
--        			.. 'Name="' .. abilList[k].Name .. '"'
--        			.. ' ClassName="' .. abilList[k].ClassName .. '"'
--        			.. ' Desc="' .. abilList[k].Desc .. '"'
----        			.. ' AlwaysActive="' .. abilList[k].AlwaysActive .. '"'
--        			.. ' Icon="' .. abilList[k].Icon .. '"'
--        			.. ' MaxLevel="' .. GetClass("Ability_" .. jobEngName, abilList[k].ClassName).MaxLevel .. '"'
--        			.. ' UnlockDesc="' .. GetClass("Ability_" .. jobEngName, abilList[k].ClassName).UnlockDesc .. '"'
--        			.. ' JobClassID="' .. GetClass("Job", jobCategory[k]).ClassID .. '"'
--        			.. endLine;
--        
--        jobTemp = jobCategory[k];
--    end
--    
--    text = text .. '</Category>\n';
--    
--    local bottonText = '</Category>';
--    
--    file:write(headText, text, bottonText);
--    io.close(file);
end



-- 모든 맵의 탐사율 100%  --
-- //run BLACK_SHEEP_WALL --
function BLACK_SHEEP_WALL(self, allMap)
--    allMap = tonumber(allMap);
--    if allMap == nil or allMap == 0 or allMap == "" then
--        allMap = 0;
--    else
--        allMap = 1;
--    end
    
    local mapClassList, mapClassCount = GetClassList("Map");
    if mapClassList ~= nil then
        for i = 0, mapClassCount - 1 do
            local mapClass = GetClassByIndexFromList(mapClassList, i);
            if mapClass ~= nil then
                local mapClassName = TryGetProp(mapClass, "ClassName");
                local mapPreOpen = TryGetProp(mapClass, "WorldMapPreOpen");
                
--                if mapPreOpen == "YES" or allMap == 1 then
                if mapPreOpen == "YES" then
                    MapRevealComplete(self, mapClassName);
                    sleep(100);
                end
            end
        end
        SendUpdateWorldMap(self)
        InvalidateStates(self);
        Chat(self, "All Map Clear!");
    end
end



-- 소유한 모든 아이템 감정 --
-- //run ALL_APPRAISAL --
function ALL_APPRAISAL(pc)
    local invItemList = GetInvItemList(pc);
    local itemList = { };
    if invItemList == nil or #invItemList == 0 then
    	return;
    end
    
    for i = 1, #invItemList do
    	local item = invItemList[i];
		if IS_NEED_APPRAISED_ITEM(item) == true or IS_NEED_RANDOM_OPTION_ITEM(item) == true then 
			local itemCls = GetClass("Item", item.ClassName)
			if nil ~= itemCls then
				itemList[#itemList + 1] = item;
			end
        end
    end
    
    if itemList == nil or #itemList == 0 then
    	return;
    end
	
	local itemName = "";
	local prList = {};
	local socketList = {};
	local priceList = {};
	for i = 1, #itemList do
		local item = itemList[i]
		if item == nil then
			SendSysMsg(pc, "DataError");
			return;
		end
		
		-- 현재 기획엔 장비아이템만 가능하며, 감정 한번받은 아이템은 감정못함.
		if IS_NEED_APPRAISED_ITEM(item) == false  and IS_NEED_RANDOM_OPTION_ITEM(item) == false then 
			SendSysMsg(pc, "DataError");
            return;
		end
		
		local itemCls = GetClass("Item", item.ClassName)
		if nil == itemCls then
			SendSysMsg(pc, "DataError");
			return;
		end
		
        if IsShutDown("Item",item.ClassName,item) == 1 or IsShutDown("ShutDownContent","UserAndNPCTrade") == 1 then
            SendAddOnMsg(pc, "SHUTDOWN_BLOCKED", "", 0);
            return;
        end
		
		prList[#prList + 1] = itemCls.MaxPR;
		socketList[#socketList + 1] = itemCls.MaxSocket_COUNT;
		priceList[#priceList + 1] = thisItemPrice;
	end
	
	-- 구/신 감정 리스트 분류 -- 
	local randomItemList = {}
	local appraisalItemList = {}
	
	for i = 1, #itemList do
	    local tempItem = itemList[i]
	    local needRandomoption = TryGetProp(tempItem, "NeedRandomOption")
	    local needAppraisal = TryGetProp(tempItem, "NeedAppraisal")
	    
	    if needRandomoption == 1 then
	        randomItemList[#randomItemList + 1] = tempItem
	    elseif needAppraisal == 1 then
	        appraisalItemList[#appraisalItemList + 1] = tempItem
	    end
	end
	
	local RandomOptionGroup = {};
	local RandomOption = {};
	local RandomOptionValue = {};
	local optionCount = {}
	
	-- 아이템 랜덤 옵션 옵션 획득 --
	if #randomItemList > 0 then
        for i = 1, #randomItemList do
            local item = randomItemList[i];
            local itemGroupList, optionNameList, optionCnt, optionStateList = FIRST_RANDOM_OPTION_ITEM(pc, item, skill);
            if itemGroupList== nil or  optionNameList== nil or optionCnt== nil or optionStateList == nil then
                return;
            end
            RandomOptionGroup[i] = itemGroupList;
        	RandomOption[i] = optionNameList;
        	RandomOptionValue[i] = optionStateList;
        	optionCount[i] = optionCnt;
        end
    end
    
    local tx = TxBegin(pc);
    -- (구) 감정 아이템 리스트 TX --
    if #appraisalItemList > 0 then
        for i = 1, #appraisalItemList do
            local appraisalItem = appraisalItemList[i]
            local addPR = GET_APPRAISAL_PR_COUNT(appraisalItem, prList[i], skill);
            local maxPR = prList[i] + addPR;
            local addSoket = GET_APPRAISAL_SOCKET_COUNT(appraisalItem, socketList[i], skill);
        
            -- 로그용임
            SetExProp(appraisalItem, "APPRAISER_MaxPR", maxPR)
            SetExProp(appraisalItem, "APPRAISER_ADDPR", addPR)
            SetExProp(appraisalItem, "APPRAISER_ADDSOKET", addSoket)
            SetExProp(appraisalItem, "APPRAISER_PRICE", priceList[i]);
        
            TxIsAppraisal(tx, appraisalItem, addPR, addSoket, maxPR);
        end
    end
    -- 아이템 랜덤 옵션 감정 아이템 리스트 TX --
    if #randomItemList > 0 then
        for i = 1, #randomItemList do
            local randomItem = randomItemList[i]
            for j = 1, optionCount[i] do
                local group = RandomOptionGroup[i][j];
                local option = RandomOption[i][j];
                local value = RandomOptionValue[i][j];

                TxSetIESProp(tx, randomItem, 'RandomOptionGroup_'..j, group);
               	TxSetIESProp(tx, randomItem, 'RandomOption_'..j, option);
               	TxSetIESProp(tx, randomItem, 'RandomOptionValue_'..j, value);

                -- 로그용
                SetExProp_Str(randomItem, 'RandomOptionGroup_'..j, group);
                SetExProp_Str(randomItem, 'RandomOption_'..j, option);
                SetExProp(randomItem, 'RandomOptionValue_'..j, value);
       	    end
       	    TxSetIESProp(tx, randomItem, "NeedRandomOption", 0);

            -- 로그용
            SetExProp(randomItem, 'RANDOM_OPTION_CNT', optionCount[i]);
        end
    end
    
    local ret = TxCommit(tx);
    
	ITEM_APPRAISAL_DELETE_PROP(itemList);

	if ret ~= 'SUCCESS' then
		SendSysMsg(pc, "DataError");
		return;
	end
    
	ItemAppraisalMongoLog(pc, "NPC");
	
	
    
    local showLoop = math.floor(#itemList / 6) + 1;
    
    for i = 1, showLoop do
        for j = (i * 6) - 5, math.min(i * 6, #itemList) do
            local item = itemList[j]
            if item ~= nil then
                ShowTargetItemBalloon(pc, GetHandle(pc), "{@st43}", "AppraisalSuccess", item, 1, nil);
            end
        end
        sleep(1500)
    end
end



-- 개발용 랭크 초기화 --
-- //run DEV_RANK_RESET --
function DEV_RANK_RESET(pc)
    local rankResetItem, rankResetItemCount = GetInvItemByName(pc, 'Premium_RankReset')
    if rankResetItem == nil then
        local tx = TxBegin(pc);
        TxGiveItem(tx, 'Premium_RankReset', 1, "CHEAT_RANK_RESET");
        local ret = TxCommit(tx);
    end
    
    rankResetItem, rankResetItemCount = GetInvItemByName(pc, 'Premium_RankReset')
    if rankResetItem ~= nil then
        DEV_CLEAR_CARD(pc);
        local itemGuid = GetItemGuid(rankResetItem);
        local scriptString = string.format("DEV_RANK_RESET_CLIENT(%d)", rankResetItem.ClassID)
        ExecClientScp(pc, scriptString)
    end
end

function DEV_RANK_RESET_CLIENT(itemID)
    local frame = ui.GetFrame("rankreset");
    
    local gradeRank = session.GetPcTotalJobGrade();
    if gradeRank <= 1 then
        ui.SysMsg(ScpArgMsg("CantUseRankRest1Rank"));
        return;
    end
    
    local mapprop = session.GetCurrentMapProp();
    local mapCls = GetClassByType("Map", mapprop.type);
    if mapCls == nil or mapCls.MapType ~= "City" then
        ui.SysMsg(ClMsg("AllowedInTown"));
        return;
    end
     
    if CHECK_INVENTORY_HAS_RANK_CARD() == true then
        ui.MsgBox_NonNested(ClMsg('YouHaveRankCardReallyRankReset?'), 0x00000000, frame:GetName(), 'None', 'None');
        return;
    end
    
    
    
    local resetItem = session.GetInvItemByType(itemID);
    if resetItem ~= nil then
        local resetItemIES = resetItem:GetIESID();
        if resetItemIES ~= nil then
            packet.RankResetItemUse(resetItemIES);
        end
    end
end

-- 랭초 카드 전부 삭제 --
-- //run DEV_CLEAR_CARD --
function DEV_CLEAR_CARD(pc)
    local invItemList, invItemCountList = GetInvItemList(pc);
    if invItemList ~= nil then
        local tx = TxBegin(pc);
        for i = 1, #invItemList do
            local item = invItemList[i];
            if TryGetProp(item, "Script") == "SCR_USE_ITEM_JEXP_MAX" or TryGetProp(item, "Script") == "SCR_RESTORE_LAST_JOB_EXP" then
                TxTakeItemByObject(tx, item, 1, "DEV_CHEAT_CLEAR_CARD");
            end
        end
        local ret = TxCommit(tx);
    end
end



-- 모든 퀘스트 클리어 처리 --
-- 매우 오래 걸리니 꼭 필요한 상황이 아니면 사용하지 마시오 --
-- //run ALL_QUEST_CLEAR --
function ALL_QUEST_CLEAR(pc)
	local sObj = GetSessionObject(pc, 'ssn_klapeda');
	if sObj == nil then
		return;
	end
	
	local questClassList, questClassCnt = GetClassList('QuestProgressCheck');
	if questClassList ~= nil then
		for i = 0, questClassCnt - 1 do
			local questClass = GetClassByIndexFromList(questClassList, i);
			local questName = TryGetProp(questClass, 'ClassName');
			
			if questName ~= 'None' and TryGetProp(sObj, questName) ~= nil then
				sObj[questName] = 300;
			end
		end
		SaveSessionObject(pc, sObj)
		Chat(pc, 'All Quest Clear!');
	end
end



-- ClassID 중복 체크 기능 --
-- data\xml_server\dev\_test_duplicate_checklist.xml 에 있는 리스트를 기반으로 중복 검사 --
-- 필요한 경우 해당 xml에 추가 하면 됨 --
function D_CHECK(self)
	SCR_S_C_PRINT(self, '------------------------------')
	SCR_S_C_PRINT(self, 'S T A R T');
	
--	local dataPath = 'C:\\_svn\\r1\\data\\';
	local dataPath = GetDataPath();
	if dataPath == nil then
		SCR_S_C_PRINT(self, 'Data Path Err!');
		return;
	end
	
	local classList, classCount = GetClassList('dev_duplicate_checklist');
	if classList == nil or classCount == 0 then
		SCR_S_C_PRINT(self, 'err!! Not Found : _test_duplicate_checklist.xml');
		return;
	end
	
	local fileGroup = { };
	for i = 0, classCount - 1 do
		local classIndex = GetClassByIndexFromList(classList, i);
		local clsIdSpace = TryGetProp(classIndex, 'IDSpace');
		local clsXmlFile = TryGetProp(classIndex, 'XmlFile');
		if classIndex ~= nil and clsIdSpace ~= nil and clsXmlFile ~= nil then
			if fileGroup[clsIdSpace] == nil then
				fileGroup[clsIdSpace] = { clsXmlFile };
				fileGroup[#fileGroup + 1] = clsIdSpace;
			else
				fileGroup[clsIdSpace][#fileGroup[clsIdSpace] + 1] = clsXmlFile;
			end
		end
	end
	
	local testSuccess = 1;
	
	for i = 1, #fileGroup do
		local fileName = fileGroup[fileGroup[i]];
		local duplicationList = { };
		for j = 1, #fileName do
			local data;
			
		    local file = io.open(dataPath .. fileName[j], "r");
		    if file == nil then
		    	Chat(self, 'File is nil');
		    	SCR_S_C_PRINT(self, 'File is nil', dataPath .. fileName[j]);
		    	
		    	io.close(file);
		    	
		    	return;
		    else
			    data = file:read("*line");
			    if data == nil then
			    	Chat(self, 'Data is nil');
			    	SCR_S_C_PRINT(self, 'Data is nil');
			    	
			    	io.close(file);
			    	
			    	return;
			    end
		    end
		    
		    if file ~= nil and data ~= nil then
			    while 1 do
				    local findDataStart1, findDataStart2 = string.find(data, 'ClassID="', 1);
				    if findDataStart1 ~= nil then
					    local findDataEnd = string.find(data, '"', findDataStart2 + 1);
					    local findText = string.sub(data, findDataStart2 + 1, findDataEnd - 1)
						
					    findText = tonumber(findText);
						
					    if findText ~= nil then
					    	if duplicationList[findText] == nil then
					    		duplicationList[findText] = fileName[j];
					    	else
					    		testSuccess = 0;
					    		
					    		Chat(self, 'ClassID Duplicate!!');
					    		SCR_S_C_PRINT(self, fileGroup[i] .. ' : ' .. findText);
					    		SCR_S_C_PRINT(self, duplicationList[findText] .. ' = ' .. fileName[j]);
					    		SCR_S_C_PRINT(self, '------------------------------');
					    	end
						else
							testSuccess = 0;
							
							SCR_S_C_PRINT(self, 'ClassID가 비어있거나 문자가 포함되어 있습니다');
						end
					end
					
					data = file:read("*line");
					
					if data == nil then
						break;
					end
				end
			    
			    io.close(file);
			end
		end
	end
	
	if testSuccess == 1 then
		Chat(self, 'Test Success!');
	end
	
    SCR_S_C_PRINT(self, 'E N D');
    SCR_S_C_PRINT(self, '------------------------------');
end







-- xml 깨진 것 체크 기능 --
function XML_CHECK(self)
	SCR_S_C_PRINT(self, '------------------------------');
	SCR_S_C_PRINT(self, 'S T A R T (XML List Loading..)');
	
--	local dataPath = 'C:\\_svn\\r1\\data\\';
	local dataPath = GetDataPath();
	if dataPath == nil then
		SCR_S_C_PRINT(self, 'Data Path Err!');
		return;
	end
	
--	dataPath = dataPath .. 'xml\\'
--	dataPath = dataPath .. 'xml_ability\\'
--	dataPath = dataPath .. 'xml_client\\'
--	dataPath = dataPath .. 'xml_drop\\'
--	dataPath = dataPath .. 'xml_lang\\'
--	dataPath = dataPath .. 'xml_minigame\\'
--	dataPath = dataPath .. 'xml_mongen\\'
--	dataPath = dataPath .. 'xml_server\\'
--	dataPath = dataPath .. 'xml_service\\'
--	dataPath = dataPath .. 'xml_sklmove\\'
--	dataPath = dataPath .. 'xml_tool\\'
--	dataPath = dataPath .. 'xml_tree\\'
--	dataPath = dataPath .. 'addon\\'
--	dataPath = dataPath .. 'addon_d\\'
--	dataPath = dataPath .. 'ui\\'
	
	local xmlList = { };
	xmlList = SCR_GET_WELL_FORMED_CHECK_LIST(dataPath, xmlList, '');
	
	SCR_S_C_PRINT(self, 'E   N   D (XML List : ' .. #xmlList .. ')');
	
	SCR_S_C_PRINT(self, 'S T A R T (XML Not Well-Formed Check)');
	local testSuccess = 1;
	local errList = { };
	for i = 1, #xmlList do
		local data = nil;
		
	    local file = io.open(dataPath .. xmlList[i], "r+");
	    if file == nil then
	    	Chat(self, 'File is nil');
	    	SCR_S_C_PRINT(self, 'File is nil', dataPath .. xmlList[i]);
	    	
	    	io.close(file);
	    	
	    	return;
	    end
		
	    if file ~= nil then
	    	sleep(10);
	    	
	    	local errorText = nil;
	    	local searchWord = 0;
	    	
		    while 1 do
			    data = file:read(1);	-- 파일의 내용을 한 글자씩 읽어옴 --
				if data == nil then
					break;
				end
				
		    	if data == '"' then
		    		if searchWord == 1 then
		    			searchWord = 0;
		    			local nextWord = file:read(1);	-- 두 번째 ["]를 찾으면 다음 글자를 읽어 옴 --
		    			if nextWord ~= ' ' and nextWord ~= '/' and nextWord ~= '>' and nextWord ~= '?' and nextWord ~= '-' and nextWord ~= ')' then
							if testSuccess == 0 then
								SCR_S_C_PRINT(self, '-----');
							end
							
				    		testSuccess = 0;
				    		errorText = nextWord;
				    		
				    		Chat(self, 'Xml not well-formed!!');
							SCR_S_C_PRINT(self, '[' .. dataPath .. xmlList[i] .. ']');
		    			end
		    		else
		    			searchWord = 1;
		    		end
		    	end
			end
			
			if errorText ~= nil then
				errList[#errList + 1] = xmlList[i] .. '[' .. errorText .. ']';
			end
		    
		    io.close(file);
		end
	end
	
	if testSuccess == 1 then
		Chat(self, 'Test Success!');
	end
	
	SCR_S_C_PRINT(self, 'E   N   D (XML Not Well-Formed Check)');
    SCR_S_C_PRINT(self, '------------------------------');
    
    if errList ~= nil and #errList >= 1 then
    	local errFiles = 'Error Files : ';
	    for i = 1, #errList do
	    	errFiles = errFiles .. ' ' .. errList[i];
	    end
	    SCR_S_C_PRINT(self, errFiles);
	end
end

function SCR_GET_WELL_FORMED_CHECK_LIST(dataPath, xmlList, subFolder)
	for f in io.popen('dir "' .. dataPath .. subFolder .. '" /b'):lines() do
		if string.find(f, "%.xml$") then
			if SCR_GET_WELL_FORMED_CHECK_IGNORE_FILE_LIST(f) == 1 then
				xmlList[#xmlList + 1] = subFolder .. f;
			end
		end
	end
	
	for i in io.popen('dir "' .. dataPath .. subFolder .. '" /b /ad'):lines() do
		sleep(10);
		if SCR_GET_WELL_FORMED_CHECK_IGNORE_FOLDER_LIST(i) == 1 then
			local folderName = i .. '\\';
			
			SCR_GET_WELL_FORMED_CHECK_LIST(dataPath, xmlList, subFolder .. folderName);
		end
	end
	
	return xmlList;
end

function SCR_GET_WELL_FORMED_CHECK_IGNORE_FOLDER_LIST(folderName)
	local ignoreList = {
							'testo'
						}
	
	for i = 1, #ignoreList do
		local ignoreFile = ignoreList[i];
		if fileName == ignoreFile then
			return 0;
		end
	end
	
	return 1;
end

function SCR_GET_WELL_FORMED_CHECK_IGNORE_FILE_LIST(fileName)
	local ignoreList = {
							'loadingfaq.xml',
							'skillani_onride.xml'
						}
	
	for i = 1, #ignoreList do
		local ignoreFile = ignoreList[i];
		if fileName == ignoreFile then
			return 0;
		end
	end
	
	return 1;
end

-- 서버와 클라에 동시에 print를 찍는 기능 --
function SCR_S_C_PRINT(pc, ...)
	local valueList = { ... };
	if #valueList ~= nil and #valueList >= 1 then
		local value = '"' .. valueList[1] .. '"' ;
		if #valueList >= 2 then
			for i = 2, #valueList do
				local temp = valueList[i];
				value = value .. ', "' .. temp .. '"';
			end
		end
		
		print(...);
		ExecClientScp(pc, 'SCR_CLIENT_PRINT(' .. value .. ')');
	end
end
