
function NEARPARTYLIST_ON_INIT(addon, frame)

	addon:RegisterMsg("GAME_START", "UPDATE_NEAR_PARTY_LIST");
	addon:RegisterMsg("PARTY_UPDATE", "UPDATE_NEAR_PARTY_LIST");
	addon:RegisterMsg("PARTY_INST_UPDATE", "UPDATE_NEAR_PARTY_LIST");
	addon:RegisterMsg("PARTY_PROPERTY_UPDATE", "UPDATE_NEAR_PARTY_LIST");
	addon:RegisterMsg("PARTY_PROPERTY_NOTE_UPDATE", "UPDATE_NEAR_PARTY_LIST");

	addon:RegisterMsg('NEAR_PARTY_UPDATE', 'UPDATE_NEAR_PARTY_LIST');
	
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

	if msg == "NEAR_PARTY_UPDATE" then

		
		local listcount = nearPartyList:Count()
		local mainGbox = GET_CHILD_RECURSIVELY(frame,'mainGbox','ui::CGroupBox')

		DESTROY_CHILD_BYNAME(mainGbox, 'nearpartylist_');

		local startYmargin = 30;
	
		if listcount > 5 then
			listcount = 5;
        end
	
		for i = 0, listcount-1 do

            if nearPartyList:Element(i) == nil then
			    break;
			end

			local eachpartyinfo = nearPartyList:Element(i).partyInfo
			local eachpartymemberlist = nearPartyList:Element(i):GetMemberList()

         
            local ctrlheight = ui.GetControlSetAttribute('nearpartyinfo', 'height') + 3
			local set = mainGbox:CreateOrGetControlSet('nearpartyinfo', 'nearpartylist_'..i, 0, startYmargin + ctrlheight*i);
			local bgbox = GET_CHILD_RECURSIVELY(set,"neainfo_bg")
		
			-- 파티 이름
			local nameTxt = GET_CHILD_RECURSIVELY(set,'partyName')
			nameTxt:SetTextByKey("partyname",eachpartyinfo.info.name)
			nameTxt:SetTextByKey("nowcnt",eachpartymemberlist:Count())

			-- 리더 이름
			local leaderName = GET_CHILD_RECURSIVELY(set,'leaderName')
			leaderName:SetTextByKey("leadername",eachpartyinfo.info.leaderName)

			bgbox:EnableHitTest(1)
			bgbox:SetColorTone("FFFFFFFF");
			bgbox:SetEventScript(ui.LBUTTONDOWN, "NEAR_PARTY_INFO_DO_OPEN");
			bgbox:SetEventScriptArgNumber(ui.LBUTTONDOWN, i );

		end

	end

	frame:Invalidate()

end
