----- lib_cooldown.lua


function ICON_SET_ITEM_COOLDOWN_OBJ(icon, itemIES)
	if icon == nil then
		return;
	end

	local clientScp = itemIES.ClientScp;
	if clientScp == "SCR_SKILLITEM" then
		icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_ITEM_SKILL');
		return;	
	end
	
	if itemIES.CoolDownGroup ~= 'None' or itemIES.ClassName == 'Scroll_SkillItem' then		
		icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_ITEM_COOLDOWN');
		return;
	end

	if TryGetProp(itemIES, "GuildCoolDownGroup") ~= nil and itemIES.GuildCoolDownGroup ~= 'None' then
		icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_ITEM_GUILD_COOLDOWN');
		return;
	end
end

function ICON_UPDATE_ITEM_COOLDOWN(icon)
	if icon == nil then
		return 0, 0;
	end
	
	local iconInfo = icon:GetInfo();
	local itemtype = iconInfo.type;
	local curTime = item.GetCoolDown(itemtype);
	local totalTime = item.GetTotalCoolDown(itemtype);	

	-- ��ũ�Ѿ����۽�ų (�ø��)
	local iconInfo = icon:GetInfo();
	local invItem = session.GetInvItemByGuid(iconInfo:GetIESID());
	if invItem ~= nil then
		local obj = GetIES(invItem:GetObject());
		if obj ~= nil and obj.ClassName == 'Scroll_SkillItem' then
			local skillInfo = session.GetSkill(obj.SkillType);
			if skillInfo ~= nil then
				local skl = GetIES(skillInfo:GetObject());
				local cooldownGroupName = 'Scroll_' .. skl.ClassName;
				curTime = item.GetScrollItemCoolDown(cooldownGroupName);
				totalTime = item.GetScrollItemTotalCoolDown(cooldownGroupName);
			end
		end
	end

	return curTime, totalTime;
end

function ICON_UPDATE_ITEM_SKILL(icon)

	if icon == nil then
		return;
	end
	
	local iconInfo = icon:GetInfo();
	local itemtype = iconInfo.type;
	local sklName = GetClassByType("Item", itemtype).StringArg;
		
	local totalTime = 0;
	local curTime = 0;
	local iconInfo = icon:GetInfo();
	local skillInfo = session.GetSkillByName(sklName);
	if skillInfo ~= nil then
		curTime = skillInfo:GetCurrentCoolDownTime();
		totalTime = skillInfo:GetTotalCoolDownTime();
	end
	
	return curTime, totalTime;	
	
 end
 
 function _ICON_CUSTOM_COOLDOWN(icon)
	local curTime = imcTime.GetAppTime() - icon:GetUserIValue("_CUSTOM_CD_START")
	local totalTime = icon:GetUserIValue("_CUSTOM_CD");
	if curTime > totalTime then
		icon:RemoveCoolTimeUpdateScp();
	end
	
	local cur = totalTime - curTime;
	if cur > totalTime then
		cur = totalTime - 0.1;
	end

 	return cur * 1000, totalTime * 1000;
 end

 function ICON_SET_COOLDOWN(icon, startTime, totalTime)
	if icon ~= nil then
		local curTime = imcTime.GetAppTime();	
		icon:SetUserValue("_CUSTOM_CD_START", curTime + startTime);
		icon:SetUserValue("_CUSTOM_CD", totalTime);
 		icon:SetOnCoolTimeUpdateScp('_ICON_CUSTOM_COOLDOWN');
	end
 end

 
-- Item CoolDown
function ICON_SET_ITEM_COOLDOWN(icon, itemType)
	local itemCls = GetClassByType('Item', itemType);

	if itemCls.ClientScp == "SCR_SKILLITEM" then
		icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_ITEM_SKILL');
		return;	
	end

	if itemCls.CoolDownGroup ~= 'None' or itemCls.ClassName == 'Scroll_SkillItem' then		
		icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_ITEM_COOLDOWN');
		return;
	end

	if TryGetProp(itemCls, "GuildCoolDownGroup") ~= nil and itemCls.GuildCoolDownGroup ~= 'None' then
		icon:SetOnCoolTimeUpdateScp('ICON_UPDATE_ITEM_GUILD_COOLDOWN');
		return;
	end
	
end

-- Item Guild Cooldown Update
function ICON_UPDATE_ITEM_GUILD_COOLDOWN(icon)
	local iconinfo = icon:GetInfo();
	local invitem = GET_ICON_ITEM(iconinfo);
	if invitem == nil then
		return 0, 0;
	end
	local itemCls = GetClassByType("Item", invitem.type);
	
	local coolDownGroup = TryGetProp(itemCls, "GuildCoolDownGroup");
	if coolDownGroup == nil then
		return 0, 0;
	end

	local coolCls = GetClass("CoolDown_Guild", coolDownGroup);
	if coolCls == nil then
		return 0, 0;
	end
	
	local curTime = session.guildcooldown.GetRemainSec(coolCls.ClassID);
	local totalTime = itemCls.ItemGuildCoolDown;
	return curTime*1000, totalTime;
end
