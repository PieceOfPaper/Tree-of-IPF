-- skill_selectground_drawrange.lua
function SCP_GET_RANGE_Elementalist_Meteor(className, range)
	if className == nil then 
		return 0;
	end

	local originRange = range;
	local sklinfo = session.GetSkillByName(className);
	if sklinfo ~= nil then
		local obj = GetIES(sklinfo:GetObject());
		if obj ~= nil then
			if obj.Level >= 5 then 
				range = 140;
			elseif obj.Level == 4 then 
				range = 130; 
			elseif obj.Level == 3 then 
				range = 110; 
			elseif obj.Level == 2 then 
				range = 90;
			elseif obj.Level == 1 then
				range = 70;
			end 
		end
	end

	return range;
end

function SCP_GET_RANGE_Sorcerer_Evocation(className, range)
	if className == nil then 
		return 0;
	end

	local originRange = range;
	local sklinfo = session.GetSkillByName(className);
	if sklinfo ~= nil then
		local obj = GetIES(sklinfo:GetObject());
		if obj ~= nil then
			range = 30 + 15 * obj.Level
		end
	end
	
	return range;
end

function SCP_GET_RANGE_Dragoon_DragonFall(className, range)
	if className == nil then
		return 0;
	end

	-- Equip
	local equipItemList = session.GetEquipItemList();
	local slotNum = item.GetEquipSpotNum("RH");
	local rhItem = equipItemList:GetEquipItem(slotNum);
	local rhItemObj = GetIES(rhItem:GetObject());

	-- DB Hand Check
	if rhItemObj.DBLHand == "YES" then
		-- DB Hand TRUE
	else
		-- DB Hand FALSE
	end

	-- Ability
	local abilList = session.GetAbilityList();
	if abilList ~= nil then
		local count = abilList:Count();
		if count > 0 then
			for i = 0, count do
				local abil = session.GetAbilityByIndex(i);
				if abil ~= nil then
					local abilCls = GetIES(abil:GetObject());
				end
			end
		end
	end
end

function SCP_GET_RANGE_Hoplite_ThrouwingSpear(className, range)
	if className == nil then
		return 0;
	end
end