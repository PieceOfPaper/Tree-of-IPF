function SCR_BUFF_UPDATE_Event_Penalty(self, buff, arg1, arg2, RemainTime, ret, over)

    if IsJumping(self) == 1 then
        AddBuff(self, self, 'Blind', 1, 0, 5000);
    end
    return 1

end

function SCR_BUFF_ENTER_Event_Nru_Buff_Item(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_sys_expcard_normal', 2.5, 1, "BOT", 1);
end

function SCR_BUFF_UPDATE_Event_Nru_Buff_Item(self, buff, arg1, arg2, RemainTime, ret, over)

    if RemainTime > 3600000 then
        SetBuffRemainTime(self, buff.ClassName, 3600000)
    end
    return 1

end

function SCR_BUFF_LEAVE_Event_Nru_Buff_Item(self, buff, arg1, arg2, over)
end

function SCR_BUFF_ENTER_Event_Cb_Buff_Item(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_sys_expcard_normal', 2.5, 1, "BOT", 1);
    self.MHP_BM = self.MHP_BM + 2000;
    self.MSP_BM = self.MSP_BM + 1000;
    self.MSPD_BM = self.MSPD_BM + 1;  
end

function SCR_BUFF_UPDATE_Event_Cb_Buff_Item(self, buff, arg1, arg2, RemainTime, ret, over)

    if RemainTime > 3600000 then
        SetBuffRemainTime(self, buff.ClassName, 3600000)
    end
    return 1

end

function SCR_BUFF_LEAVE_Event_Cb_Buff_Item(self, buff, arg1, arg2, over)
    self.MHP_BM = self.MHP_BM - 2000;
    self.MSP_BM = self.MSP_BM - 1000;
    self.MSPD_BM = self.MSPD_BM - 1;
end

function SCR_BUFF_LEAVE_GIMMICK_Drug_Elements_Ice_Atk(self, buff, arg1, arg2, over)
   self.Ice_Atk_BM = self.Ice_Atk_BM - arg1;
end
--湲곤옙? 蹂댁긽--
function SCR_BUFF_ENTER_GIMMICK_Drug_Elements_Lightning_Atk(self, buff, arg1, arg2, over)
   self.Lightning_Atk_BM = self.Lightning_Atk_BM + arg1;
end

function SCR_BUFF_LEAVE_Event_Cb_Buff_Item(self, buff, arg1, arg2, over)
    self.MHP_BM = self.MHP_BM - 2000;
    self.MSP_BM = self.MSP_BM - 1000;
    self.MSPD_BM = self.MSPD_BM - 1;
end

function SCR_BUFF_ENTER_Event_Cb_Buff_Potion(self, buff, arg1, arg2, over)
    PlayEffect(self, 'F_sys_expcard_normal', 2.5, 1, "BOT", 1);
    self.PATK_BM = self.PATK_BM + 500
	self.MATK_BM = self.MATK_BM + 500
end

function SCR_BUFF_UPDATE_Event_Cb_Buff_Potion(self, buff, arg1, arg2, RemainTime, ret, over)

    if RemainTime > 3600000 then
        SetBuffRemainTime(self, buff.ClassName, 3600000)
    end
    return 1

end

function SCR_BUFF_LEAVE_Event_Cb_Buff_Potion(self, buff, arg1, arg2, over)
    self.PATK_BM = self.PATK_BM - 500
	self.MATK_BM = self.MATK_BM - 500
end

-- _Fortunecookie
-- 1
function SCR_BUFF_ENTER_Premium_Fortunecookie_1(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 1;
end

function SCR_BUFF_UPDATE_Premium_Fortunecookie_1(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Premium_Fortunecookie_1(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 1;
end

-- 2
function SCR_BUFF_ENTER_Premium_Fortunecookie_2(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 2;
end

function SCR_BUFF_UPDATE_Premium_Fortunecookie_2(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Premium_Fortunecookie_2(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 2;
end

-- 3
function SCR_BUFF_ENTER_Premium_Fortunecookie_3(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 3;
    self.MHP_BM = self.MHP_BM + 500;
end

function SCR_BUFF_UPDATE_Premium_Fortunecookie_3(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Premium_Fortunecookie_3(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 3;
    self.MHP_BM = self.MHP_BM - 500;
end

-- 4
function SCR_BUFF_ENTER_Premium_Fortunecookie_4(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 4;
    self.MHP_BM = self.MHP_BM + 1000;
end

function SCR_BUFF_UPDATE_Premium_Fortunecookie_4(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Premium_Fortunecookie_4(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 4;
    self.MHP_BM = self.MHP_BM - 1000;
end

-- 5
function SCR_BUFF_ENTER_Premium_Fortunecookie_5(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + 5;
    self.MHP_BM = self.MHP_BM + 2000;
end

function SCR_BUFF_UPDATE_Premium_Fortunecookie_5(self, buff, arg1, arg2, RemainTime, ret, over)
    if RemainTime > 1800000 then
        SetBuffRemainTime(self, buff.ClassName, 1800000)
    end
    return 1
end

function SCR_BUFF_LEAVE_Premium_Fortunecookie_5(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - 5;
    self.MHP_BM = self.MHP_BM - 2000;
end