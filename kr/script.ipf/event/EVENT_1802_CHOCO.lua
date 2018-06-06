function SCR_PRE_EVENT_1802_CHOCO(self, argStr1, argnum1, argnum2)
    if IsBuffApplied(self, 'EVENT_1802_CHOCO_BUFF5') == 'YES' then
        return 0
    else
        return 1
    end
end

function SCR_USE_EVENT_1802_CHOCO(self,argObj,argStr1,arg1,arg2)
    local aObj = GetAccountObj(self);
    local result = 0;
    local buffName = 'None'
    if IsBuffApplied(self, 'EVENT_1802_CHOCO_BUFF1') == 'YES' then
        buffName = 'EVENT_1802_CHOCO_BUFF2'
    elseif IsBuffApplied(self, 'EVENT_1802_CHOCO_BUFF2') == 'YES' then
        buffName = 'EVENT_1802_CHOCO_BUFF3'
    elseif IsBuffApplied(self, 'EVENT_1802_CHOCO_BUFF3') == 'YES' then
        buffName = 'EVENT_1802_CHOCO_BUFF4'
    elseif IsBuffApplied(self, 'EVENT_1802_CHOCO_BUFF4') == 'YES' then
        buffName = 'EVENT_1802_CHOCO_BUFF5'
    elseif IsBuffApplied(self, 'EVENT_1802_CHOCO_BUFF5') == 'YES' then
        buffName = 'EVENT_1802_CHOCO_BUFF5'
    else
        buffName = 'EVENT_1802_CHOCO_BUFF1'
    end
    
    AddBuff(self, self, buffName, arg1, 0, arg2, 1);
    PlayEffect(self, 'I_spread_out001_light_pink', 1, 1,'TOP')
end





function SCR_BUFF_ENTER_EVENT_1802_CHOCO_BUFF1(self, buff, arg1, arg2, over)
    local addMhp = 500
    SetExProp(buff, "EVENT_1802_CHOCO_BUFF1", addMhp);
    self.MHP_BM = self.MHP_BM + addMhp;
end

function SCR_BUFF_UPDATE_EVENT_1802_CHOCO_BUFF1(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    local RemainTime = math.floor(RemainTime/1000)
    if RemainTime % 10 == 0 then
        Heal(self, 100, 0)
        HealSP(self, 50, 0)
    end
    return 1
end

function SCR_BUFF_LEAVE_EVENT_1802_CHOCO_BUFF1(self, buff, arg1, arg2, over)
    local addMhp = GetExProp(buff, "EVENT_1802_CHOCO_BUFF1");
    self.MHP_BM = self.MHP_BM - addMhp;
end


function SCR_BUFF_ENTER_EVENT_1802_CHOCO_BUFF2(self, buff, arg1, arg2, over)
    local addMhp = 1000
    SetExProp(buff, "EVENT_1802_CHOCO_BUFF2", addMhp);
    self.MHP_BM = self.MHP_BM + addMhp;
end

function SCR_BUFF_UPDATE_EVENT_1802_CHOCO_BUFF2(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    local RemainTime = math.floor(RemainTime/1000)
    if RemainTime % 10 == 0 then
        Heal(self, 200, 0)
        HealSP(self, 100, 0)
    end
    return 1
end

function SCR_BUFF_LEAVE_EVENT_1802_CHOCO_BUFF2(self, buff, arg1, arg2, over)
    local addMhp = GetExProp(buff, "EVENT_1802_CHOCO_BUFF2");
    self.MHP_BM = self.MHP_BM - addMhp;
end

function SCR_BUFF_ENTER_EVENT_1802_CHOCO_BUFF3(self, buff, arg1, arg2, over)
    local addMhp = 1500
    SetExProp(buff, "EVENT_1802_CHOCO_BUFF3", addMhp);
    self.MHP_BM = self.MHP_BM + addMhp;
end

function SCR_BUFF_UPDATE_EVENT_1802_CHOCO_BUFF3(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    local RemainTime = math.floor(RemainTime/1000)
    if RemainTime % 10 == 0 then
        Heal(self, 300, 0)
        HealSP(self, 150, 0)
    end
    return 1
end

function SCR_BUFF_LEAVE_EVENT_1802_CHOCO_BUFF3(self, buff, arg1, arg2, over)
    local addMhp = GetExProp(buff, "EVENT_1802_CHOCO_BUFF3");
    self.MHP_BM = self.MHP_BM - addMhp;
end

function SCR_BUFF_ENTER_EVENT_1802_CHOCO_BUFF4(self, buff, arg1, arg2, over)
    local addMhp = 2000
    SetExProp(buff, "EVENT_1802_CHOCO_BUFF4", addMhp);
    self.MHP_BM = self.MHP_BM + addMhp;
end

function SCR_BUFF_UPDATE_EVENT_1802_CHOCO_BUFF4(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    local RemainTime = math.floor(RemainTime/1000)
    if RemainTime % 10 == 0 then
        Heal(self, 400, 0)
        HealSP(self, 200, 0)
    end
    return 1
end

function SCR_BUFF_LEAVE_EVENT_1802_CHOCO_BUFF4(self, buff, arg1, arg2, over)
    local addMhp = GetExProp(buff, "EVENT_1802_CHOCO_BUFF4");
    self.MHP_BM = self.MHP_BM - addMhp;
end

function SCR_BUFF_ENTER_EVENT_1802_CHOCO_BUFF5(self, buff, arg1, arg2, over)
    local addMhp = 2500
    SetExProp(buff, "EVENT_1802_CHOCO_BUFF5", addMhp);
    self.MHP_BM = self.MHP_BM + addMhp;
end

function SCR_BUFF_UPDATE_EVENT_1802_CHOCO_BUFF5(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    local RemainTime = math.floor(RemainTime/1000)
    if RemainTime % 10 == 0 then
        Heal(self, 500, 0)
        HealSP(self, 250, 0)
    end
    return 1
end

function SCR_BUFF_LEAVE_EVENT_1802_CHOCO_BUFF5(self, buff, arg1, arg2, over)
    local addMhp = GetExProp(buff, "EVENT_1802_CHOCO_BUFF5");
    self.MHP_BM = self.MHP_BM - addMhp;
end