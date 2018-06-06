function SCR_USE_EVENT_1712_XMAS_FIRE(self,argObj,BuffName,arg1,arg2)
    local rand = IMCRandom(10,15)
    local tx = TxBegin(self);
    TxEnableInIntegrate(tx);
    TxGiveItem(tx, 'EVENT_1712_SECOND_MIN_ITEM', rand, "EVENT_1712_XMAS_FIRE")
    local ret = TxCommit(tx);
    if ret == 'SUCCESS' then
        AddBuff(self, self, 'EVENT_1712_XMAS_FIRE', 1, 0, 3600000,1)
        AddInstSkill(self, 'Common_firework_green')
        UsePcSkill(self, self, 'Common_firework_green', 1, 1)
        sleep(1500)
        PlayTextEffect(self, "I_SYS_Text_Effect_Skill", rand)
    end
end





function SCR_EVENT_1712_XMAS_NPC_DIALOG(self,pc)
    local select1 = ShowSelDlg(pc, 0, 'EVENT_1712_XMAS_DLG1', ScpArgMsg('EVENT_1707_COMPASS_MSG2'), ScpArgMsg('Auto_DaeHwa_JongLyo'))
    local targetItem = 'EVENT_1712_XMAS_CUBE'
    if select1 == 1 then
        local itemCount = GetInvItemCount(pc, targetItem)
        if itemCount > 0 then
            local tx = TxBegin(pc);
            TxTakeItem(tx, targetItem, 1, "EVENT_1712_XMAS_NPC")
            TxGiveItem(tx, 'Drug_Event_Looting_Potion', 2, "EVENT_1712_XMAS_NPC")
            TxGiveItem(tx, 'Snow_Card_Book', 1, "EVENT_1712_XMAS_NPC")
            TxGiveItem(tx, 'Gacha_Toy_Box_Chrismas_2017', 1, "EVENT_1712_XMAS_NPC")
            TxGiveItem(tx, 'Ability_Point_Stone', 5, "EVENT_1712_XMAS_NPC")
            TxGiveItem(tx, 'Moru_Gold_14d', 3, "EVENT_1712_XMAS_NPC")
            TxGiveItem(tx, 'PremiumToken_1d', 1, "EVENT_1712_XMAS_NPC")
            TxGiveItem(tx, 'Adventure_Reward_Seed', 3, "EVENT_1712_XMAS_NPC")
            TxGiveItem(tx, 'Event_Goddess_Statue_DLC', 3, "EVENT_1712_XMAS_NPC")
            local ret = TxCommit(tx);
            if ret == 'SUCCESS' then
                ShowOkDlg(pc, 'EVENT_1712_XMAS_DLG3', 1)
            end
        else
            ShowOkDlg(pc, 'EVENT_1712_XMAS_DLG2', 1)
        end
    end
end


function EVENT_1712_XMAS_HIDE_TIME_CHECK()
    local now_time = os.date('*t')
    local year = now_time['year']
    local month = now_time['month']
    local yday = now_time['yday']
    local wday = now_time['wday']
    local day = now_time['day']
    local hour = now_time['hour']
    
    if year == 2017 and month == 12 and (day == 24 or day == 25) then
        return 'YES'
    else
        return 'NO'
    end
    
    return 'NO'
end

function SCR_EVENT_1712_XMAS_HIDE_TS_BORN_ENTER(self)
end

function SCR_EVENT_1712_XMAS_HIDE_TS_BORN_UPDATE(self)
    local summonNPC = GetExArgObject(self, 'EVENT_1712_XMAS_NPC')
    local timeCheck = EVENT_1712_XMAS_HIDE_TIME_CHECK()
    if summonNPC ~= nil then
        if timeCheck == 'NO' then
            Kill(summonNPC)
        end
    else
        if timeCheck == 'YES' then
            local x,y,z = GetPos(self)
            local npc = CREATE_NPC(self, 'gacha_cube2', x, y, z, 0, nil, 0, self.Name, 'EVENT_1712_XMAS_NPC')
            if npc ~= nil then
                SetExArgObject(self, 'EVENT_1712_XMAS_NPC', npc)
                EnableAIOutOfPC(npc)
            end
        end
    end
end

function SCR_EVENT_1712_XMAS_HIDE_TS_BORN_LEAVE(self)
end

function SCR_EVENT_1712_XMAS_HIDE_TS_DEAD_ENTER(self)
end

function SCR_EVENT_1712_XMAS_HIDE_TS_DEAD_UPDATE(self)
end

function SCR_EVENT_1712_XMAS_HIDE_TS_DEAD_LEAVE(self)
end
