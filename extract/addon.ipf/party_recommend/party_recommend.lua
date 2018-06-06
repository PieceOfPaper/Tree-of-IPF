

function PARTY_RECOMMEND_ON_INIT(addon, frame)

end


function PARTY_RECOMMEND_OPEN(frame)

end


function PARTY_RECOMMEND_CLOSE(frame)

	local isOpen = frame:GetUserValue("IS_OPEN");

	if isOpen ~= "true" then
		local popupframe = ui.GetFrame("party_recommend_popup");
		local fname = popupframe:GetUserValue("RECOMMEND_LEADER_FNAME");
		
		party.CancelInvite(0, fname, 2)
	end

	
end


function SHOW_PARTY_RECOMMEND(recommendType)

	--팝업프레임 세팅
	local popupframe = ui.GetFrame("party_recommend_popup");

	if popupframe:IsVisible() == 1 then
		return
	end
	
	local recommendParty = session.party.GetRecommendParty();

	

	local partyInfo = recommendParty.partyInfo
	local partymemberlist = recommendParty:GetMemberList()
		
	local ppartyobj = partyInfo:GetObject();
	local partyObj = GetIES(ppartyobj);

	local partyNameTxt = GET_CHILD_RECURSIVELY(popupframe,'partyName')
	partyNameTxt:SetTextByKey('partyname',partyInfo.info.name)

	-- 파티 설명
	local noteTxt = GET_CHILD_RECURSIVELY(popupframe,'partyNote')
	noteTxt:SetTextByKey('partymemo',partyObj["Note"])
	
	local elapsedTime = session.party.GetHowOldPartyCreated(partyInfo);
	local timeString = GET_TIME_TXT_DHM(elapsedTime);
	
	local createdTimeTxt = GET_CHILD_RECURSIVELY(popupframe,'createdTime')
	createdTimeTxt:SetTextByKey('createtime',timeString)

	local partyNameTxt = GET_CHILD_RECURSIVELY(popupframe,'memberCount')
	partyNameTxt:SetTextByKey('memcount',partymemberlist:Count())

	DESTROY_CHILD_BYNAME(popupframe, 'eachmember_');

	local csetheight = ui.GetControlSetAttribute("party_recommend_member_info", 'height');

	for i = 0 , partymemberlist:Count() - 1 do

		local eachpartymember = partymemberlist:Element(i)		
	
		local memberinfoset = popupframe:CreateOrGetControlSet('party_recommend_member_info', 'eachmember_'..i, 88, partyNameTxt:GetY() + partyNameTxt:GetHeight() + i * csetheight);
		
		local nameTxt = GET_CHILD_RECURSIVELY(memberinfoset,'name')
		local otherinfoTxt = GET_CHILD_RECURSIVELY(memberinfoset,'otherinfo')
		nameTxt:SetText(eachpartymember:GetName())

		if eachpartymember:GetMapID() > 0 then

			otherinfoTxt:SetTextByKey('level',eachpartymember:GetLevel())

			local jobcls = GetClassByType("Job", eachpartymember:GetIconInfo().job);
			otherinfoTxt:SetTextByKey('job',jobcls.Name)
			otherinfoTxt:ShowWindow(1)
			nameTxt:SetColorTone("FFFFFFFF")
		else
			otherinfoTxt:ShowWindow(0)
			nameTxt:SetColorTone("FF888888")
		end

	end


	popupframe:Resize(popupframe:GetWidth(),popupframe:GetOriginalHeight() + (partymemberlist:Count() * csetheight) )

	popupframe:SetUserValue("RECOMMEND_TYPE",recommendType);
	popupframe:SetUserValue("RECOMMEND_LEADER_FNAME", partyInfo.info.leaderName);
	popupframe:SetUserValue("IS_ACK", "false");
	


	local frame = ui.GetFrame("party_recommend");
	frame:SetUserValue("IS_OPEN", "false");
	local description = GET_CHILD_RECURSIVELY(frame,"description")
	local matchmakerCls = GetClassByType("PartyMatchMaker",recommendType)
	description:SetText(matchmakerCls.InviteMent)

	local partyNameTxt2 = GET_CHILD_RECURSIVELY(frame,"partyname")
	partyNameTxt2:SetText(partyInfo.info.name)

	local duration = tonumber(frame:GetUserConfig("POPUP_DURATION"))
	
	frame:ShowWindow(1);
	frame:SetDuration(duration);

end


function POPUP_RECOMMEND_PARTY_UI()
	local frame = ui.GetFrame("party_recommend");
	frame:SetUserValue("IS_OPEN", "true");
	ui.OpenFrame('party_recommend_popup')
	ui.CloseFrame('party_recommend')
end