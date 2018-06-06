
function SCR_MISSION_ROKAS_TREASUREBOX_1_DIALOG(self, pc)
    local raid_sObj = GetSessionObject(pc, 'ssn_raid')
    if raid_sObj ~= nil then
        if raid_sObj.MISSION_ROKAS_REWARD1 > 0 then
            raid_sObj.MISSION_ROKAS_REWARD1 = 0
            SaveSessionObject(pc, raid_sObj)
            PlayAnimLocal(pc, pc, 'KICKBOX', 0);
            PlayAnimLocal(self, pc, 'OPENED', 1)
            GivePickReward(pc, "RAID_ROKAS1_1", 0.15, 0.3,  "RAID_ROKAS1_2", 0.40, 0.5,  "RAID_ROKAS1_3", 0.55, 0.2 );
        end
    end
end



function RAID_ROKAS_START(self)
    RunMGame(self, 'MISSION_ROKAS_01');
end



function MROKAS_RUINA_RUN(pc)
    ShowOkDlg(pc, 'MROKAS_RUINA_02', 1)
end



function MROKAS_RUINA_MOVE(self)
    if self.ClassName ~= 'PC' then
        if self.Name == ScpArgMsg('Auto_LuiNa') then
            SetMGameValue(self, 'MROKAS_RUINA_01', 2);
        end
    end
end

function MROKAS_RUINA_KILL(self)
    Kill(self)
end

function SCR_MROKAS_BOMB_FLOWER_DIALOG(self, pc)
    local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_PogTanKkoch_SuJip"), '#SITGROPESET', 3)
    if result == 1 then
        local itemType = GetClass("Item", 'MROKAS_BOMBFLOWER').ClassID;
        local item_cnt = GetInvItemCountByType(pc, itemType);
        if item_cnt == 0 then
        	RunScript('GIVE_ITEM_TX', pc, 'MROKAS_BOMBFLOWER', 1, "Quest")
        	SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_'PogTanKkocheul_HoegDeugHaessSeupNiDa!"), 5);
        else
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_PogTanKkocheul_iMi_SoJiHaKo_issSeupNiDa!"), 5);
        end
    end
end

function SCR_MROKAS_FUSE_DIALOG(self, pc)
    local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_KiLeumMuteun_DoHwaSeon_SuJip"), '#SITGROPESET2', 3)
    if result == 1 then
        local itemType = GetClass("Item", 'MROKAS_BOMBFUSE').ClassID;
        local item_cnt = GetInvItemCountByType(pc, itemType);
        if item_cnt == 0 then
        	RunScript('GIVE_ITEM_TX', pc, 'MROKAS_BOMBFUSE', 1, "Quest")
        	SendAddOnMsg(pc, "NOTICE_Dm_GetItem", ScpArgMsg("Auto_'KiLeumMuteun_DoHwaSeon'eul_HoegDeugHaessSeupNiDa!"), 5);
        else
            SendAddOnMsg(pc, "NOTICE_Dm_!", ScpArgMsg("Auto_DoHwaSeoneul_iMi_SoJiHaKo_issSeupNiDa!"), 5);
        end
    end
end

function SCR_MROKAS_RUINA_01_DIALOG(self, pc)
    local val = GetMGameValue(pc, 'MROKAS_RUINA_01');
    if  val == 2 then
        ShowOkDlg(pc, 'MROKAS_RUINA_03', 1)
    elseif val == 4 then
        if GetInvItemCount(pc, 'mrokas_Cannon') == 0 then
            local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_JaeLyo_JeonDal_Jung"), 'TALK', 3)
            if result == 1 then
                SetMGameValue(pc, 'MROKAS_RUINA_02', 1);
                RunScript('GIVE_TAKE_ITEM_TX', pc, 'mrokas_Cannon/1', 'MROKAS_BOMBFLOWER/-100/MROKAS_BOMBFUSE/-100', "MISSION_ROKAS_01")
                ShowOkDlg(pc, 'MROKAS_RUINA_01', 1)
            end
        else
            local val2 = GetMGameValue(pc, 'MROKAS_RUINA_02');
            if val2 ~= 1 then
                local result = DOTIMEACTION_R(pc, ScpArgMsg("Auto_JaeLyo_JeonDal_Jung"), 'TALK', 3)
                if result == 1 then
                    SetMGameValue(pc, 'MROKAS_RUINA_02', 1);
                    ShowOkDlg(pc, 'MROKAS_RUINA_01', 1)
                end
            else
                ShowOkDlg(pc, 'MROKAS_RUINA_01', 1)
            end
        end
    end
end

function SCR_MROKAS_GATE_DIALOG(self, pc)
    local val = GetMGameValue(pc, 'MROKAS_RUINA_02'); 
    if val == 1 then
        local result = DOTIMEACTION_R(pc, ScpArgMsg("PILGRIM311_SQ_04_ITEM_DO"), '#SITGROPESET2', 2)
        if result == 1 then
            local x,y,z = GetPos(self)
            local mon = CREATE_NPC(pc, 'Bomb_RokasMission', x, y, z, 0, nil, nil, nil, nil, nil, nil, 1, nil, 'MON_BOMB_ROKASMISSION')
            if mon ~= nil then
                SetOwner(mon, self)
                RunScript('GIVE_TAKE_ITEM_TX', pc, nil, 'mrokas_Cannon/-100', "MISSION_ROKAS_01")
            end
        end
    end
end




function MROKAS_HOGMA_CANNON(self, from, skill, damage, ret)
    if skill.ClassName == 'Quest_Cannon' then
        Dead(self)
    end
end




function MROKAS_GATE_02(self, from, skill, damage, ret)
    if skill.ClassName == 'Quest_Cannon' then
        SetMGameValue(self, 'MROKAS_CHASER_01', -1);
        
    end
end

function MROKAS_ENT_TRIGER(self)
    if IS_PC(self) == true then
        SetPos(self, 524, 181, -23)
    end
end



function MROKAS_GATE2_DAMAGE(self, from, skill, damage, ret, valueName, value)
    if skill.ClassName == 'Quest_Cannon' then
        Kill(self)
    end
end


function SCR_NUNNERY_CUBE_REWARD_CHECK(self)
    local pcetc = GetETCObject(self)
    if pcetc ~= nil then
        if pcetc.InDunRewardCountType_300 > 0 then
            return 'YES'
        end
    end
    return 'NO'
end
