
function NEARPARTYLIST_ON_INIT(addon, frame)

	addon:RegisterMsg("GAME_START", "UPDATE_NEAR_PARTY_LIST");
	addon:RegisterMsg("PARTY_UPDATE", "UPDATE_NEAR_PARTY_LIST");
	addon:RegisterMsg("PARTY_INST_UPDATE", "UPDATE_NEAR_PARTY_LIST");
	addon:RegisterMsg("PARTY_PROPERTY_UPDATE", "UPDATE_NEAR_PARTY_LIST");
	addon:RegisterMsg("PARTY_PROPERTY_NOTE_UPDATE", "UPDATE_NEAR_PARTY_LIST");

	addon:RegisterMsg('NEAR_PARTY_UPDATE', 'UPDATE_NEAR_PARTY_LIST');
	
end

function IS_JOINABLE_PARTY(eachpartyinfo, eachpartymemberlist)


	local memcount = eachpartymemberlist:Count()
	if memcount >= 5 then
		return false
	end
	
	local ppartyobj = eachpartyinfo:GetObject();
	local partyObj = GetIES(ppartyobj);

	if partyObj["IsPrivate"] == 1 then
		return false;
	end

	if partyObj["UseLevelLimit"] == 1 then
		if partyObj["MinLv"] > GETMYPCLEVEL() then
			return false
		end
		if partyObj["MaxLv"] < GETMYPCLEVEL() then
			return false
		end
	end


	local curClassType = partyObj["RecruitClassType"];

	local num = curClassType
	local calcresult={}
	local i = 0
	
	while num > 0 do
		
		calcresult[i] = num%2
		num = math.floor(num/2)
		i = i + 1
		if num < 1 then
			break;
		end
	end

	
	local pc = GetMyPCObject();
	local pcjobinfo = GetClass('Job', pc.JobName)

	if pcjobinfo.CtrlType == 'Warrior' then
		if calcresult[0] ~= 1 then
			return false;
		end
	end

	if pcjobinfo.CtrlType == 'Wizard' then
		if calcresult[1] ~= 1 then
			return false;
		end
	end

	if pcjobinfo.CtrlType == 'Archer' then
		if calcresult[2] ~= 1 then
			return false;
		end
	end

	if pcjobinfo.CtrlType == 'Cleric' then
		if calcresult[3] ~= 1 then
			return false;
		end
	end

	return true
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

			local ctrlheight = ui.GetControlSetAttribute('nearpartyinfo', 'height') + 3
			local set = mainGbox:CreateOrGetControlSet('nearpartyinfo', 'nearpartylist_'..i, 0, startYmargin + ctrlheight*i);
			local bgbox = GET_CHILD_RECURSIVELY(set,"neainfo_bg")
			if nearPartyList:Element(i) == nil then
				break;
			end
			local eachpartyinfo = nearPartyList:Element(i).partyInfo

			local eachpartymemberlist = nearPartyList:Element(i):GetMemberList()
		
			-- 파티 이름
			local nameTxt = GET_CHILD_RECURSIVELY(set,'partyName')
			nameTxt:SetTextByKey("partyname",eachpartyinfo.info.name)
			nameTxt:SetTextByKey("nowcnt",eachpartymemberlist:Count())

			-- 리더 이름
			local leaderName = GET_CHILD_RECURSIVELY(set,'leaderName')
			leaderName:SetTextByKey("leadername",eachpartyinfo.info.leaderName)

			-- 파티 멤버 수
			if IS_JOINABLE_PARTY(eachpartyinfo, eachpartymemberlist) == true then
				bgbox:EnableHitTest(1)
				bgbox:SetColorTone("FFFFFFFF");
				bgbox:SetEventScript(ui.LBUTTONDOWN, "LCLICK_PARTY_LIST");
				bgbox:SetEventScriptArgString(ui.LBUTTONDOWN, eachpartyinfo.info.leaderName );
				bgbox:SetTooltipType("partyinfotooltip");
				bgbox:SetTooltipArg("", i)
			else
				bgbox:EnableHitTest(0)
				bgbox:SetColorTone("FF444444");
				bgbox:SetEventScript(ui.LBUTTONDOWN, "None");
				set:SetTooltipType("partyinfotooltip");
				set:SetTooltipArg("", i)
				
			end

		end

	end

	frame:Invalidate()

end
