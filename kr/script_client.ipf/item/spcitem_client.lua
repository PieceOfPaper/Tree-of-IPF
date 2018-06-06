--- scpitem_client.lua

function SPCI_DAGGER_MULTIPLE_HIT_C(actor, skill, hitInfo, additionalInfo)
	
	if hitInfo.clientSkillID == 10 or hitInfo.clientSkillID == 20 then
		additionalInfo.multipleHitCount = 2;
	end
end
