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

--EVENT_1909_ANCIENT_MON
function EVENT_1909_CHECK_REGISTER(invItem)
	local itemobj = GetIES(invItem:GetObject());
	local monClassName = TryGetProp(itemobj,'KeyWord')
	local monCls = GetClass("Monster",monClassName)
	local monName = monCls.Name
	
	local str = ScpArgMsg("AncientMonRegItemUse","monName",monName)
	local guid = invItem:GetIESID()
	local yesScp = string.format("EVENT_1909_REGISTER_ANCIENT_MON_C(\"%s\")", guid);
	ui.MsgBox(str, yesScp, "None");
end

--EVENT_1909_ANCIENT_MON
function EVENT_1909_REGISTER_ANCIENT_MON_C(itemGuid)
	local invItem = session.GetInvItemByGuid(itemGuid)
	
	if nil == invItem then
		return;
	end
	
	if true == invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock"));
		return;
	end
	
	item.UseByGUID(invItem:GetIESID());
end
--EVENT_1909_ANCIENT
function ANCIENT_SCROLL_CHECK_MSG(invItem)
	local itemobj = GetIES(invItem:GetObject());
	local needItem = session.GetInvItemByName("EVENT_190919_ANCIENT_COIN");
	if needItem == nil then
		addon.BroadMsg("NOTICE_Dm_scroll", ClMsg("AncientNoCoinInInventory"), 3);
        return;
    end
	local str = ScpArgMsg("AncientScrollItemUse","itemName",itemobj.Name)
	local guid = invItem:GetIESID()
	local yesScp = string.format("EVENT_1909_REGISTER_ANCIENT_MON_C(\"%s\")", guid);
	ui.MsgBox(str, yesScp, "None");
end
--EVENT_1909_ANCIENT
function ANCIENT_SCROLL_EMPTY_USE(iesID)
	pc.ReqExecuteTx_Item("SCR_TRADE_SELECT_AMCIEMT_MON", iesID,'');
	local frame = ui.GetFrame('tradeselectitem')
	frame:ShowWindow(0)
end