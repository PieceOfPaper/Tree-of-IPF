-- Red Apple
function SCR_BUFF_ENTER_Steam_Drug_Heal100HP_Dot(self, buff, arg1, arg2, over)
    local healHp = self.MHP * (arg1 / 100);
    
    if self.HPPotion_BM > 0 then 
        healHp = math.floor(healHp * (1 + self.HPPotion_BM/100));
    end
    Heal(self, healHp, 0);
end

function SCR_BUFF_UPDATE_Steam_Drug_Heal100HP_Dot(self, buff, arg1, arg2, RemainTime, ret, over)
   local healHp = self.MHP * (arg1 / 100);
    
    if self.HPPotion_BM > 0 then 
        healHp = math.floor(healHp * (1 + self.HPPotion_BM/100));
    end

    healHp = healHp / 5
    Heal(self, healHp, 0);
    return 1;
end

function SCR_BUFF_LEAVE_Steam_Drug_Heal100HP_Dot(self, buff, arg1, arg2, over)

end

-- Blue Apple
function SCR_BUFF_ENTER_Steam_Drug_Heal100SP_Dot(self, buff, arg1, arg2, over)
    local healSp = self.MSP * (arg1 / 100);
    
    if self.SPPotion_BM > 0 then
        healSp = math.floor(healSp * (1 + self.SPPotion_BM/100));
    end
    HealSP(self, healSp, 0);
end

function SCR_BUFF_UPDATE_Steam_Drug_Heal100SP_Dot(self, buff, arg1, arg2, RemainTime, ret, over)

    local healSp = self.MSP * (arg1 / 100);
    
    if self.SPPotion_BM > 0 then
        healSp = math.floor(healSp * (1 + self.SPPotion_BM/100));
    end
    
    healSp = math.floor(healSp / 5);
    HealSP(self, healSp, 0);
    return 1;
end

function SCR_BUFF_LEAVE_Steam_Drug_Heal100SP_Dot(self, buff, arg1, arg2, over)

end