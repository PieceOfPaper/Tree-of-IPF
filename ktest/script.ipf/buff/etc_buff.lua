-- Event_1710_Holiday
function SCR_BUFF_ENTER_Event_1710_Holiday(self, buff, arg1, arg2, over)
    local rootingChance = 1000;
    
    self.LootingChance_BM = self.LootingChance_BM + rootingChance;
    SetExProp(buff, "ADD_ENTER_Event_1710_Holiday", rootingChance);
end

function SCR_BUFF_LEAVE_Event_1710_Holiday(self, buff, arg1, arg2, over)
    local rootingChance = GetExProp(buff, "ADD_ENTER_Event_1710_Holiday");
    self.LootingChance_BM = self.LootingChance_BM - rootingChance;
end

function SCR_BUFF_ENTER_RootCrystalMoveSpeed(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + arg1;
end

function SCR_BUFF_LEAVE_RootCrystalMoveSpeed(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - arg1;
end

-- Colletor_Etc_Low_20
function SCR_BUFF_ENTER_Colletor_Etc_Low(self, buff, arg1, arg2, over)
    local drop_sObj = GetSessionObject(self, 'ssn_drop')
    drop_sObj.Etc_Low_BN = drop_sObj.Etc_Low_BN + 5
    SaveSessionObject(self, drop_sObj)
end

function SCR_BUFF_LEAVE_Colletor_Etc_Low(self, buff, arg1, arg2, over)
    local drop_sObj = GetSessionObject(self, 'ssn_drop')
    drop_sObj.Etc_Low_BN = drop_sObj.Etc_Low_BN - 5
    SaveSessionObject(self, drop_sObj)
end


-- TagTaggerChange
function SCR_BUFF_ENTER_TagTaggerChange(self, buff, arg1, arg2, over)
    RemoveBuff(self, 'TagPlayer')
end

function SCR_BUFF_LEAVE_TagTaggerChange(self, buff, arg1, arg2, over)
   AddBuff(self,self,'TagTagger',1,0,0,1)
end


-- TagTagger
function SCR_BUFF_ENTER_TagTagger(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_TagTagger(self, buff, arg1, arg2, over)
    local player_ssn = GetSessionObject(self,'ssn_tag_player')
    if player_ssn ~= nil then
        AddBuff(self,self,'TagPlayer',1,0,0,1)
    end
end

-- TagPlayer
function SCR_BUFF_ENTER_TagPlayer(self, buff, arg1, arg2, over)
end

function SCR_BUFF_LEAVE_TagPlayer(self, buff, arg1, arg2, over)
end


function SCR_BUFF_ENTER_Treasuremon(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM + ((arg1-1) * 15)
end

function SCR_BUFF_LEAVE_Treasuremon(self, buff, arg1, arg2, over)
    self.MSPD_BM = self.MSPD_BM - ((arg1-1) * 15)
end


-- Fever Buff
function SCR_BUFF_ENTER_FeverTime(self, buff, arg1, arg2, over)
--
--  local combo = arg1;
--  local maxCombo = arg2;
--
--  -- 콤보 중첩당 데미지 + 5
--  if combo >= 1 and combo <= maxCombo then
--      
--      local bonusDamage = 5 * combo;
--      SetExProp(buff, "FEVER_DAMAGE", bonusDamage);
--
--      self.BonusDmg_BM = self.BonusDmg_BM + bonusDamage;
--  end
--  
--  -- 애드온 메시지
--  if combo >= 10 then
--      SendAddOnMsg(self, "NOTICE_Dm_GuildQuestSuccess", ScpArgMsg("Auto_FEVER_TIME!!_ChuKa_KongKyeogLyeogi_JeogyongDoepNiDa!"), 5);
--  elseif combo >= 1 then
--      SendAddOnMsg(self, "NOTICE_Dm_GuildQuestSuccess", ScpArgMsg("Auto_FEVER_TIME!!_ChuKa_KongKyeogLyeogi_JeogyongDoepNiDa!"), 5);
--  end
        
    local addRate = 1;
    local caster = GetBuffCaster(buff);
    if caster ~= nil then
        local _JollyRoger = GetSkill(caster, "Corsair_JollyRoger")
        if _JollyRoger ~= nil then
            addRate = _JollyRoger.Level;
    end
    end
    SetBuffArgs(buff, addRate, 0, 0);
end

function SCR_BUFF_LEAVE_FeverTime(self, buff, arg1, arg2, over)
--
--  local rate = GetExProp(buff, "FEVER_DAMAGE");
--  self.BonusDmg_BM = self.BonusDmg_BM - rate;
end


-- Born
function SCR_BUFF_ENTER_Born(self, buff, arg1, arg2, over)

    SetHittable(self, 0);
end

function SCR_BUFF_LEAVE_Born(self, buff, arg1, arg2, over)

    SetHittable(self, 1);
end

-- Born
function SCR_BUFF_ENTER_Event_CharExpRate(self, buff, arg1, arg2, over)
    -- 할게 있을까?
    
end

function SCR_BUFF_LEAVE_Event_CharExpRate(self, buff, arg1, arg2, over)
    -- 할게 있나?   
end



-- Fishing_SpreadBait
function SCR_BUFF_ENTER_Fishing_SpreadBait(self, buff, arg1, arg2, over)
    SetExProp(self, "FishingSpreadBait", arg2);
end

function SCR_BUFF_LEAVE_Fishing_SpreadBait(self, buff, arg1, arg2, over)
    DelExProp(self, "FishingSpreadBait");
end

-- Fishing_Fire
function SCR_BUFF_ENTER_Fishing_Fire(self, buff, arg1, arg2, over)
    
end

function SCR_BUFF_LEAVE_Fishing_Fire(self, buff, arg1, arg2, over)
    
end

-- Fishing_SpreadBait_PC
function SCR_BUFF_ENTER_Fishing_SpreadBait_PC(self, buff, arg1, arg2, over)
    local fishingPlace = GetExArgObject(self, "MyFishingPlace")
    if fishingPlace ~= nil then
        local effectName = GetExProp_Str(fishingPlace, "FishingSpreadBaitEffect");
        if effectName == nil or effectName == "None" then
            effectName = "F_fish_foreshadow_blue";
        end
        
        AttachEffect(self, effectName, 4.0, "BOT");
        SetExProp_Str(buff, "EFFECT_NAME", effectName);
    end
end

function SCR_BUFF_LEAVE_Fishing_SpreadBait_PC(self, buff, arg1, arg2, over)
    local effectName = GetExProp_Str(buff, "EFFECT_NAME");
    if effectName ~= nil then
        DetachEffect(self, effectName);
    end
end

function SCR_BUFF_ENTER_ChallengeMode_Player(self, buff, arg1, arg2, over)
	local level = GetExProp(self, "ChallengeMode_Level");
	
	local clsList, cnt = GetClassList("challenge_mode");
	local lootingChangeBonus = GetClassByNameFromList(clsList, "LootingChangeBonus_Lv" .. level);

	local rootingChance = TryGet(lootingChangeBonus, "Value");

	SetExProp(buff, "CHALLENGE_MODE_PLAYER_BUFF", rootingChance);

    self.LootingChance_BM = self.LootingChance_BM + rootingChance;
end

function SCR_BUFF_LEAVE_ChallengeMode_Player(self, buff, arg1, arg2, over)
	local rootingChance = GetExProp(buff, "CHALLENGE_MODE_PLAYER_BUFF");
	self.LootingChance_BM = self.LootingChance_BM - rootingChance;
end