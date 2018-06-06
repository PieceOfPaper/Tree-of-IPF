function SCR_GM_CASTLE_01_BOSS_BORN_ATTRIBUTE(self)
    AddBuff(self, self, 'GM_Petrification_Mon_Debuff', 0, 0, 0);
end

function SCR_GM_CASTLE_01_BOSS_CHECK_HOOK(self)
    if IsBuffApplied(self, 'GM_Petrification_Mon_Debuff') == 'YES' then
        RemoveBuff(self, 'GM_Petrification_Mon_Debuff')
        if GetCurrentFaction(self) == 'Neutral' then
            SetCurrentFaction(self, 'Monster')
        end
    end
end

--3번 스테이지 트랩 관련 --
function SCR_GM_CASTLE_01_GIMMICK3_TRAP_ENTER(self)

    local clearCheck = GetMGameValue(self, 's3clear');
    
    if clearCheck == 2 then
        return;
    end
    
    local pc_list, cnt = SelectObject(self, 40, "ALL", 1)
    local i
    if cnt >= 1 then
        for i = 1, cnt do
        local target = pc_list[i];
            if self.NumArg1 == 0 and self.NumArg2 == 0 then
            local tgtCls = TryGetProp(taget, 'ClassName')
                if IS_PC(target) == true then
                    if target.ClassName == 'PC' then
                        if IsBuffApplied(target, 'GM_Petrification_PC_Buff') == 'YES' then
                            return;
                        else
                            AddBuff(self, target, 'GM_Petrification_PC_Debuff');
                            self.NumArg1 = 1
                            self.NumArg3 = 0;
                        end
                    end
                elseif target.Faction == 'Monster'  and target.MonRank ~= 'Boss' then
                    if IsBuffApplied(target, 'GM_Petrification_Mon_Debuff') == 'YES' then
                        return;
                    else
                        AddBuff(self, target, 'GM_Petrification_Mon_Debuff', 1, 0, 20000, 1);
                        self.NumArg2 = 1
                        self.NumArg3 = 0;
                    end
                end
            end
        end
    end

end

--트랩 활성화 관련, NumArg3 = Time --
function GM_CASTLE_01_GIMMICK3_TRAP_TIME_CHECK(self)
    if self.NumArg1 == 1 then -- PC
        self.NumArg3 = self.NumArg3 +1 
        if self.NumArg3 == 10 then
            self.NumArg1 = 0;
        end
    elseif self.NumArg2 == 1 then --Mon
        self.NumArg3 = self.NumArg3 +1 
        if self.NumArg3 == 20 then
            self.NumArg2 = 0;
        end
    end
end

--3번 스테이지에서 주변에 버프걸린 대상을 체크하는 함수 --
function GM_CASTLE_01_GIMMICK3_BUFF_CHECK(self)
    self.NumArg1 = 0; --NumArg1 = 버프 걸린 숫자
    local clearCheck = GetMGameValue(self, 's3clear');
    if clearCheck == 1 or clearCheck == nil then
        self.NumArg2 = self.NumArg2 + 1
        if self.NumArg2 == 300 then --재활성화까지 걸리는 시간 --
            self.NumArg2 = 0;
            SetMGameValue(self, 's3clear', 0)
            SetFixAnim(self, 'event_loop')
        end
        return;
    end
    
    local list, cnt = SelectObject(self, 250, "ALL", 1)
    if cnt >= 1 then
        for i = 1, cnt do
            local target = list[i]
            local bufflist = GetBuffList(target);
            for b = 1, #bufflist do
                local buff = bufflist[b]
                if buff.ClassName == "GM_Petrification_Mon_Debuff" or buff.ClassName == "GM_Petrification_PC_Debuff" then
                    self.NumArg1 = self.NumArg1 + 1
                end
            end
        end
    end
    
    if self.NumArg1 >= 8 then --NumArg1 은 목표 버프걸린 대상 숫자 --
        SetMGameValue(self, 's3clear', 1);
        local clearCheck = GetMGameValue(self, 's3clear');
        PlayAnim(self, 'std');
        return;
    end
end

--1번 기믹용 숫자 놀이 --
function GM_CASTLE_01_GIMMICK1_MATH_EXAMINATION(self)
    local symbol = {'+', '-', '*', '/'}
    local numlist = {}
    local symbolist = {}
    local answer = 0;
    local s1 = 4
    local str
    self.NumArg1 = 1;
    
    repeat
         for n = 1, s1 do
            local num = IMCRandom(1,9)
            numlist[n] = num;
        end
        for s = 1, s1-1 do
            if self.NumArg4 <= 5 then
                local sybolnum = IMCRandom(1,3)   
                symbolist[s] = symbol[sybolnum]     
            elseif self.NumArg4 > 5 then --6회이상 실패했을 경우 난이도 하락 --
                local sybolnum = IMCRandom(1,2)
                symbolist[s] = symbol[sybolnum]
            end
        end
         
        str = numlist[1]
        for i = 1, #symbolist do
            str = str..symbolist[i]..numlist[i+1]
        end
        
        answer = math.floor(loadstring("return " .. str)());
    until(0 <= answer and answer <= 25)
    
    SetTitle(self, str.." = ?");
    
    local user = GetMGameValue(self, 'counts1');

    SetMGameValue(self, 'counts1', 0)
    GM_CASTLE_01_MATH_EXAMINATION(self, answer, str) --몬스터 나오고 숫자 배열하는 걸로 --
    
end

--3번 기믹에서 나오는 몬스터 DeadScript --
function SCR_GM_CASTLE_01_GIMMICK1_MATH_PLUS(self) 
    local mt = GetMGameValue(self, 'counts1')
    if mt == nil then
        return;
    end
    mt = mt + 1
    SetMGameValue(self, 'counts1', mt)
end

-- 기믹장치 다이얼로그 --
function SCR_GM_CASTLE_01_GIMMICK1_MATH_EXAMINATION_DIALOG(self, pc) 
    local value = GetMGameValue(self, 's1clear');
    if value == 1 then
        return;
    end
    
    if self == nil then
        return;
    end
    
    if pc == nil then
        return;
    end
    
    local sel = ShowSelDlg(pc,0, 'GM_CASTLE_GIMMICK_SECLECT_1', ScpArgMsg("Yes"), ScpArgMsg("No"))
    
	if sel == 2 or select == nil then
		return;
	elseif sel == 1 then
	    if self.NumArg1 > 0 then
	        return
	    end
	    GM_CASTLE_01_GIMMICK1_MATH_EXAMINATION(self)
	end    
end

function GM_CASTLE_01_MATH_EXAMINATION(self, answer, str)
    sleep(2500);
    for i = 1, 10 do
        local sec = 11 - i
        local x, y, z = GetPos(self)
        for k = 1, 3 do
            local mathMon = CREATE_MONSTER_EX(self, 'GM_magictrap_core', x+IMCRandom(-150,150), y, z+IMCRandom(-150,150), nil)
            AddScpObjectList(self, "MATH_TESTER", mathMon)
        end
        sleep(1000)
        SetTitle(self, sec);
    end
    
    local mon = GetScpObjectList(self, "MATH_TESTER")
    for j = 1, #mon do
        Dead(mon[j])
    end
    
    SetTitle(self, str.." = "..answer);
    
    local user = GetMGameValue(self, 'counts1');

    if user == answer then
        SetMGameValue(self, 's1clear', 1)
        sleep(3000)
        SetTitle(self, "")
    elseif user ~= answer then
        self.NumArg4 = self.NumArg4 + 1
        self.NumArg1 = 0;
    end
end

function GM_CASTLE_01_GIMMICK4_MEMORY_SET(self)

    local number = {1,2,3,4}
    local mode = 4
    
    for i = 1, mode do
        clr = 'gm4num'..i
        num = 'gme4clr'..i
        local j = IMCRandom(1,#number)
        n = number[j]
        table.remove(number, j)
        SetMGameValue(self, clr, n)
        SetMGameValue(self, num, 0)

    end 
    
end
--GIMMCK4번 다이얼로그 --
function SCR_GM_CASTLE_04_GIMMICK1_MATH_EXAMINATION_DIALOG(self, pc) 
    local value = GetMGameValue(self, 's4clear');
--    if GetMGameValue(self, 'gme4clr1') ~= nil then
--        return;
--    end
    
    if value == 1 then
        return;
    end
    
    if self == nil then
        return;
    end
    
    if pc == nil then
        return;
    end
    
    local sel = ShowSelDlg(pc,0, 'GM_CASTLE_GIMMICK_SECLECT_1', ScpArgMsg("Yes"), ScpArgMsg("No"))
    
	if sel == 2 or sel == nil then
		return;
	elseif sel == 1 then
	    GM_CASTLE_01_GIMMICK4_MEMORY_SET(self)
	end    
end

function TEST_GIMMCK4_CHECK(self, pc, Num)
    local chk1 = GetMGameValue(self, 'gme4clr1');
    local num1 = GetMGameValue(self, 'gm4num1');
    if chk1 ~= 1 then
        if  num1 == Num then
            SetMGameValue(self, 'gme4clr1', 1)
            SetFixAnim(self, 'ON')
        end
        return;
    end
    
    local chk2 = GetMGameValue(self, 'gme4clr2')
    local num2 = GetMGameValue(self, 'gm4num2')
    if chk2 ~= 1 then
        if  num2 == Num then
            SetMGameValue(self, 'gme4clr2', 1)
            SetFixAnim(self, 'ON')
        end
        return;        
    end
    local chk3 = GetMGameValue(self, 'gme4clr3');
    local num3 = GetMGameValue(self, 'gm4num3');    
    if chk3 ~= 1 then
        if  num3 == Num then
            SetMGameValue(self, 'gme4clr3', 1)
            SetFixAnim(self, 'ON')
        end
        return;        
    end    
    local chk4 = GetMGameValue(self, 'gme4clr4');
    local num4 = GetMGameValue(self, 'gm4num4');
    if chk4 ~= 1 then
        if  num4 == Num then
            SetMGameValue(self, 'gme4clr4', 1)
            SetFixAnim(self, 'ON')
            SetMGameValue(self, 's4clear', 1)
        end
    end
end

function SCR_TEST_GIMMCK1_DIALOG(self)
    TEST_GIMMCK4_CHECK(self, pc, 1)
end

function SCR_TEST_GIMMCK2_DIALOG(self)
    TEST_GIMMCK4_CHECK(self, pc, 2)
end

function SCR_TEST_GIMMCK3_DIALOG(self)
    TEST_GIMMCK4_CHECK(self, pc, 3)
end

function SCR_TEST_GIMMCK4_DIALOG(self)
    TEST_GIMMCK4_CHECK(self, pc, 4)
end

function SCR_GM_CASTLE_00_BOSS_SKILL_08(self)
   local list, cnt = SelectObject(self, 250, "ENEMY", 1)
   for i = 1, #list do
       local target = list[i]
       AddBuff(self, target, 'GM_Torment_Blood_Boom_Debuff', 1, 0, 5000, 1);
   end 
end

function TEST_GM_CASTLE_MISSON_GIMMCK_CLEAR(self, num)
    local str = 's'..num..'clear'
    SetMGameValue(self, str, 1)
end

