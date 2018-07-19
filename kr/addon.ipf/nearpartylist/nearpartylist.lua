
function NEARPARTYLIST_ON_INIT(addon, frame)

	addon:RegisterMsg("GAME_START", "UPDATE_NEAR_PARTY_LIST");
	addon:RegisterMsg("PARTY_UPDATE", "UPDATE_NEAR_PARTY_LIST");
	addon:RegisterMsg("PARTY_INST_UPDATE", "UPDATE_NEAR_PARTY_LIST");
	addon:RegisterMsg("PARTY_PROPERTY_UPDATE", "UPDATE_NEAR_PARTY_LIST");
	addon:RegisterMsg("PARTY_PROPERTY_NOTE_UPDATE", "UPDATE_NEAR_PARTY_LIST");
end

function OPEN_NEARPARTYLIST(frame)
	
end

function UPDATE_NEAR_PARTY_LIST(frame, msg, str, page)

	local showNearParty = config.GetXMLConfig("ShowNearParty");
	local myPartyInfo = session.party.GetPartyInfo();	
	local nearPartyList = session.party.GetNearPartyList();

	local titleText = GET_CHILD_RECURSIVELY(frame,"titleText")

	if myPartyInfo == nil and showNearParty ~= 0 and nearPartyList:Count() > 0 then
		frame:ShowWindow(1)
		titleText:ShowWindow(1)
	else
		frame:ShowWindow(0)
		titleText:ShowWindow(0)
	end

	frame:Invalidate()
end
