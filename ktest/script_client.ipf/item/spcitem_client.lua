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