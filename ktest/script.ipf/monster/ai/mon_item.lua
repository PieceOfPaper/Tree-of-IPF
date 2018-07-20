-- TS_BORN : State for monster generate

function ITEM_GET_ABLE(self, pc)
	local itemName = self.UniqueName;
	if itemName == "None" then
		return 1;
	end

	if pc.Name == itemName then
		return 1;
	end

	return 0;
end

function AUTO_CHANGE_OWNER(self)
	local dropGem = GetExProp(self, "isDromGem")
	local bossDrop = GetExProp(self, "IS_BOSS_DROP")
	if 1 == dropGem then
		sleep(DROP_ITEM_LIFE_SEC_GEM * 1000);
		StopRunScript(self, "AUTO_CHANGE_OWNER");
		SetZombie(self);
		return;
	elseif 1 == bossDrop then
		sleep(DROP_ITEM_LIFE_SEC_BOSS_DROP * 1000);
		StopRunScript(self, "AUTO_CHANGE_OWNER");
		SetZombie(self);
		return;
	end

	sleep(DROP_ITEM_RESET_OWNER_SEC * 1000);

	self.UniqueName = "None";
	UpdateItemPriority(self);

	sleep(DROP_ITEM_LIFE_SEC_MAX * 1000);
	SetZombie(self);
end

function INIT_ITEM(self, power)	
	SetLifeTime(self, DROP_ITEM_LIFE_SEC_MAX);
	RunScript("AUTO_CHANGE_OWNER", self);

	if self.ClassName == 'Small_Bag' then
		PlaySound(self, 'item_whoosh');
	end
	
	local dropStyle = GetClassString('Item', self.ItemClassName, 'DropStyle');	
	
	local minPower = 158;
	local maxPower = 168;
	local speed = 1.0;
	local minVAngle = 78;
	local maxVAngle = 85;
	local minHAngle = 10;
	local maxHAngle = 360;

	if power ~= nil then
		maxPower = maxPower * power
		minPower = minPower * power
	end

	local power = IMCRandom(minPower, maxPower);
	local hAngle = IMCRandom(minHAngle, maxHAngle);
	local vAngle = IMCRandom(minVAngle, maxVAngle);
	
	local loop, argf2, argf3 = GetTacticsArgFloat(self);
	if argf3 >= 1000 then
		power = IMCRandom(80, 100);
		vAngle = 60
		if argf3 == 10000 then
			vAngle = 89				
			AttachEffect(self, 'PICK_UP', 6.0, 1, "BOT", 1);
		end
	end
	
	local customPower = GetExProp(self, "KD_POWER_MAX");
	if customPower > 0 then
		local minPower = GetExProp(self, "KD_POWER_MIN");
		power = IMCRandom(minPower, customPower);
	end

	ItemKnockDown(self, power, hAngle, vAngle, speed);	
end
