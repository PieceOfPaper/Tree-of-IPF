--- scpitem_client.lua

function SPCI_DAGGER_MULTIPLE_HIT_C(actor, skill, hitInfo, additionalInfo)
	
	if hitInfo.clientSkillID == 10 or hitInfo.clientSkillID == 20 then
		additionalInfo.multipleHitCount = 2;
	end
end

function SCR_USE_EVENT_PICTURE_ITEM(invItem)
	local itemobj = GetIES(invItem:GetObject());
	EVENT_PICTURE_OPEN(ui.GetFrame("event_picture"), itemobj.StringArg, itemobj.NumberArg1, itemobj.NumberArg2);
end

function REGISTER_EXP_ORB_ITEM(invItem)
    local itemobj = invItem:GetIESID();
    item.RegExpOrbItem(itemobj);
end

function SCR_BARRACK_CREATE_FAIRY_GUILTY(handle)
	SCR_CREATE_FAIRY(handle, "guilty");
end

function SCR_CREATE_FAIRY(ownerHandle, monName)
	local ownerActor = world.GetActor(ownerHandle);
	local monActor = ownerActor:GetClientMonster():GetClientMonsterByName(monName);
	if monActor == nil then
		local ownerPos = ownerActor:GetPos();

		ownerActor:GetClientMonster():ClientMonsterToPos(monName, "STD", ownerPos.x, ownerPos.y, ownerPos.z, 0, 0);
		monActor = ownerActor:GetClientMonster():GetClientMonsterByName(monName);
		local monHandle = monActor:GetHandleVal();
		FollowToActor(monHandle, ownerHandle, "None", 7.0, 30.0, 10.0, 1, 0.1);
		StartImitatingAnimation(monHandle, ownerHandle);
	end
end

function SCR_REMOVE_FAIRY(ownerHandle, monName)
	local ownerActor = world.GetActor(ownerHandle);
	ownerActor:GetClientMonster():DeleteClientMonster(monName, 0.75);
end