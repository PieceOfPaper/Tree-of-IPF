--item_monstercardbook.lua

function SCR_SUMMON_MONSTER_FROM_CARDBOOK(self, argObj, cardType)
	local clsList, cnt = GetClassList("item_summonboss")
	local totalRatio = 0;
    local cardTypeList = StringSplit(cardType, "/");
    local groupList = { }

    for i = 1, #cardTypeList do
    	for j = 0, cnt -1 do
    		local cls = GetClassByIndexFromList(clsList, j);
    		if cls.Group == cardTypeList[i] or cardTypeList[i] == 'All' then
    			totalRatio = totalRatio + cls.Ratio
    		end
    	end
    end

	local summonRandom = IMCRandom(1, totalRatio)

	for i = 1, #cardTypeList do
    	for j = 0, cnt - 1 do
    		local cls = GetClassByIndexFromList(clsList, j);

    		if cls == nil then
    			return;
    		end
    		if cls.Group == cardTypeList[i] or cardTypeList[i] == 'All' then
    			if summonRandom <= cls.Ratio then
    				SUMMON_MONSTER(self, cls.MonsterClassName, cls.SummonLv, cls.Count, cls.LifeTime, cls.Group)
    				return
    			else
    				summonRandom = summonRandom - cls.Ratio
    			end
    		end
    	end
    end
end

function SUMMON_MONSTER(self, monClsName, SummonLv, Count, LifeTime, Group)
	local zObj = GetLayerObject(self)

	for i = 1, Count do
		local iesObj = CreateGCIES('Monster', monClsName);
		if iesObj ~= nil then
			iesObj.Lv = SummonLv;
			local x, y, z = GetFrontPos(self, 30);
	
			local mon = CreateMonster(self, iesObj, x, y, z, 0, 0);
			SetLifeTime(mon, LifeTime);
			SetDeadScript(mon, "SCR_IS_CARDBOOK_BOSS_DEAD")

			-- 대상, 이펙트 이름, 이펙트 크기, 모름, 이펙트 위치, 크기 --	
            if Group == "Red" then
                PlayEffect(mon, "F_pc_CardBook_ground_red", 2.0, 'BOT', 3)
            elseif Group == "Blue" then
                PlayEffect(mon, "F_pc_CardBook_ground_blue", 2.0, 'BOT', 3)
            elseif Group == "Green" then
                PlayEffect(mon, "F_pc_CardBook_ground_green", 2.0, 'BOT', 3)
            elseif Group == "Purple" then
                PlayEffect(mon, "F_pc_CardBook_ground_violet", 2.0, 'BOT', 3)
--            elseif Group == "Field" then
--                SetFieldBoss(mon)
--                PlayEffect(mon, "F_pc_CardBook_ground_dark", 2.0, 'BOT', 3)
            end

			zObj.SUMMON_BOSS_MONSTER_COUNT = zObj.SUMMON_BOSS_MONSTER_COUNT + 1
		end
	end
end

function TEST_RESET_FIELD_SUMMONBOSS_COUNT_RESET(self)
	local zObj = GetLayerObject(self)
	zObj.SUMMON_BOSS_MONSTER_COUNT = 0
end

function SCR_IS_CARDBOOK_BOSS_DEAD(self)
	if self == nil then
		return
	end

	local clsList, cnt = GetClassList("item_summonboss")
	local isCardbookBoss = 0;


	for i = 0, cnt -1 do
		local cls = GetClassByIndexFromList(clsList, i);
		if cls.MonsterClassName == self.ClassName then
			isCardbookBoss = 1
		end
	end

	if isCardbookBoss == 1 then
		local zObj = GetLayerObject(self)
		zObj.SUMMON_BOSS_MONSTER_COUNT = zObj.SUMMON_BOSS_MONSTER_COUNT - 1
	end
end
