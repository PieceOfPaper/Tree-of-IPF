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

function SCR_BUFF_ENTER_Event_Steam_Carnival_Fire(self, buff, arg1, arg2, over)
    SetMSPDBuffInfo(self,"Event_Steam_Carnival_Fire", 2)
    self.PATK_BM = self.PATK_BM + 50;
    self.MATK_BM = self.MATK_BM + 50;

    local x,y,z = GetPos(self);
    local fndList1, fndCount1 = SelectObjectPos(self, x, y, z, 50, "ALL");
    
    for i = 1, fndCount1 do
        --print(fndList1[i].ClassName)
        if fndList1[i].ClassName == 'Scarecrow' then
            LookAt(self, fndList1[i])
            local EquipOuter = GetEquipItem(self, "OUTER")
            if EquipOuter.ClassName == 'Steam_Event_costume_Com_17' or EquipOuter.ClassName == 'Steam_Event_costume_Com_18' then
                AddBuff(self,self, 'Event_Steam_Carnival_Fire_2', 1, 0, 3600000, 1)
                SendAddOnMsg(self, "NOTICE_Dm_Clear", ScpArgMsg("EVENT_STEAM_CARNIVAL_FIRE_MSG2"), 3);
            elseif IsBuffApplied(self, 'Event_Steam_Carnival_Fire_2') == 'NO' and (EquipOuter.ClassName ~= 'Steam_Event_costume_Com_17' or EquipOuter.ClassName ~= 'Steam_Event_costume_Com_18') then
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_STEAM_CARNIVAL_FIRE_MSG3"), 3)
                return
            elseif EquipOuter.ClassName ~= 'Steam_Event_costume_Com_17' or EquipOuter.ClassName ~= 'Steam_Event_costume_Com_18' then
                SendAddOnMsg(self, "NOTICE_Dm_scroll", ScpArgMsg("EVENT_STEAM_CARNIVAL_FIRE_MSG3"), 3)
                return            
            end
        end
    end
end

function SCR_BUFF_UPDATE_Event_Steam_Carnival_Fire(self, buff, arg1, arg2, RemainTime, ret, over)
    SCR_BUFF_UPDATE_REMAINTIME_IES_APPLYTIME_SET(self, buff, RemainTime)
    return 1
end

function SCR_BUFF_LEAVE_Event_Steam_Carnival_Fire(self, buff, arg1, arg2, over)
    RemoveMSPDBuffInfo(self,"Event_Steam_Carnival_Fire")
    self.PATK_BM = self.PATK_BM - 50;
    self.MATK_BM = self.MATK_BM - 50;
end