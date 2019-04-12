
function NEARPARTYINFO_ON_INIT(addon, frame)
	
end


function NEAR_PARTY_INFO_DO_OPEN(parent, btn, strArg, index)

    local frame = ui.GetFrame("nearpartyinfo")
    frame:ShowWindow(0)

    NEAR_PARTY_INFO_UPDATE(index)

    frame:SetOffset(btn:GetGlobalX() + btn:GetWidth() ,btn:GetGlobalY())
    frame:ShowWindow(1)
end

function NEAR_PARTY_INFO_UPDATE(index)

    local frame = ui.GetFrame("nearpartyinfo")

    local name = GET_CHILD_RECURSIVELY(frame,"partyname")
	local getterPartyList = session.party.GetNearPartyList();
		
	if getterPartyList == nil then
		return;
	end	

	local eachpartyinfo = getterPartyList:Element(index).partyInfo;
	local eachpartymemberlist = getterPartyList:Element(index):GetMemberList();

	if eachpartyinfo == nil then
		return;
	end

    UPDATE_COMMON_PARTY_INFO(frame, eachpartyinfo, eachpartymemberlist, name)
	
    local btn_req_join = GET_CHILD_RECURSIVELY(frame,'btn_req_join')

    btn_req_join:SetEventScript(ui.LBUTTONDOWN, "NEAR_PARTY_INFO_REQ_JOIN");
    btn_req_join:SetEventScriptArgString(ui.LBUTTONDOWN, eachpartyinfo.info.leaderName );

    local bgGbox = GET_CHILD_RECURSIVELY(frame,'bg')

    bgGbox:Resize(bgGbox:GetOriginalWidth(), 210 + (eachpartymemberlist:Count() * 30) )
	frame:Resize(frame:GetOriginalWidth(), 240 + (eachpartymemberlist:Count() * 30) )

	frame:Invalidate()
	

end

function NEAR_PARTY_INFO_DO_CLOSE(parent, btn)

    ui.CloseFrame("nearpartyinfo")
    
end

function NEAR_PARTY_INFO_REQ_JOIN(parent, btn, familyName, argNum)	

    if familyName == nil then
        return
    end
    	
	if session.party.GetPartyInfo() ~= nil then
		ui.SysMsg(ClMsg('HadMyParty'));
		return;
	end

	local str = ScpArgMsg("AreYouWantReqJoinTheParty");
	local yesScp = string.format("REQUEST_JOIN_FOUND_PARTY(\"%s\")", familyName);
	ui.MsgBox(str, yesScp, "None");

    local frame = ui.GetFrame("nearpartyinfo")
    frame:ShowWindow(0)

end
