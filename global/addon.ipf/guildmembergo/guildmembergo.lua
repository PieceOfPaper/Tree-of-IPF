
function GUILDMEMBER_GO_UPDATE_MEMBERLIST(frame, skillType)

	frame:SetUserValue("SKILLTYPE", skillType);	
	local skill = session.GetSkill(skillType);
	local obj = GetIES(skill:GetObject());
	local level = obj.Level;
	frame:SetUserValue("SKILLLEVEL", obj.Level);

	local gbox_list = frame:GetChild("gbox_list");
	gbox_list:RemoveAllChild();
	frame:SetUserValue("Count", 0);

	local connectionCount = 1;
	local myAid = session.loginInfo.GetAID();
	local list = session.party.GetPartyMemberList(PARTY_GUILD);
	local count = list:Count();
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);
		if partyMemberInfo:GetMapID() > 0 and partyMemberInfo:GetAID() ~= myAid then
			local ctrlSet = gbox_list:CreateControlSet("guildsummon_set", "MEMBER_" .. i, ui.LEFT, ui.TOP, 0, 0, 0, 0);
			ctrlSet:SetUserValue("AID", partyMemberInfo:GetAID());
			local txt_location = ctrlSet:GetChild("txt_location");
			local txt_teamname = ctrlSet:GetChild("txt_teamname");
			txt_teamname:SetTextByKey("value", partyMemberInfo:GetName());
			txt_teamname:SetTextTooltip(partyMemberInfo:GetName());
			connectionCount = connectionCount + 1;
			local locationText = "";
			if partyMemberInfo:GetMapID() > 0 then
				local mapCls = GetClassByType("Map", partyMemberInfo:GetMapID());
				if mapCls ~= nil then
					locationText = string.format("[%s%d] %s", ScpArgMsg("Channel"), partyMemberInfo:GetChannel() + 1, mapCls.Name);
				end
			end

			txt_location:SetTextByKey("value", locationText);
			txt_location:SetTextTooltip(locationText);

			GUILDMEMBER_GO_CTRLSET_UPDATE(ctrlSet, 0);
		end
	end

	GBOX_AUTO_ALIGN(gbox_list, 0, 0, 0, true, false);

	local txt_currentcount = frame:GetChild("txt_currentcount");
	local txt = ScpArgMsg("CurrentConnectionCount{Cur}/{Max}", "Cur", connectionCount, "Max", count);
	txt_currentcount:SetTextByKey("value", txt);

end

function GET_TOTAL_CHECK_COUNT(frame)



end

function GUILDMEMBER_GO_CTRLSET_UPDATE(ctrlSet, updateTotalCheckCount)

	local frame = ctrlSet:GetTopParentFrame();
	local level = frame:GetUserIValue("SKILLLEVEL");

	local checkbox = GET_CHILD(ctrlSet, "checkbox");
	local isChecked = checkbox:IsChecked();
	local bg = ctrlSet:GetChild("bg");
	if isChecked == 1 then 
		if updateTotalCheckCount ~= 0 then
			local curCount = frame:GetUserIValue("Count");
			if curCount >= level then
				checkbox:SetCheck(0);
				return;
			end
		end

		bg:SetSkinName("baseyellow_btn");
	else
		bg:SetSkinName("base_btn");
	end

	if updateTotalCheckCount ~= 0 then
		local checkCount = 0;
		local gbox_list = frame:GetChild("gbox_list");
		for i = 0 , gbox_list:GetChildCount() - 1 do
			local ctrlSet = gbox_list:GetChildByIndex(i);
			local aid = ctrlSet:GetUserValue("AID");
			if aid ~= "None" then
				local checkbox = GET_CHILD(ctrlSet, "checkbox");
				local isChecked = checkbox:IsChecked();
				if isChecked == 1 then
					checkCount = checkCount + 1;
				end
			end
		end

		frame:SetUserValue("Count", checkCount);
	end

end

function GUILD_CALL_EXEC(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local skillType = frame:GetUserIValue("SKILLTYPE");
	local sklCls = GetClassByType("Skill", skillType);

	local msgString = ScpArgMsg("WillYouUseSkill{SkillName}?", "SkillName", sklCls.Name);
	local yesScp = string.format("_GUILD_GO_EXEC(\"%s\")", frame:GetName());
	ui.MsgBox(msgString, yesScp, "None");

end

function GUILD_GO_EXEC(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local skillType = frame:GetUserIValue("SKILLTYPE");
	local sklCls = GetClassByType("Skill", skillType);

	local msgString = ScpArgMsg("WillYouUseSkill{SkillName}?", "SkillName", sklCls.Name);
	local yesScp = string.format("_GUILD_GO_EXEC(\"%s\")", frame:GetName());
	ui.MsgBox(msgString, yesScp, "None");

end

function _GUILD_GO_EXEC(frameName)

	local frame = ui.GetFrame(frameName);

	local skillType = frame:GetUserIValue("SKILLTYPE");
	session.party.ClearSkillTargetList();

	local gbox_list = frame:GetChild("gbox_list");
	for i = 0 , gbox_list:GetChildCount() - 1 do
		local ctrlSet = gbox_list:GetChildByIndex(i);
		local aid = ctrlSet:GetUserValue("AID");
		if aid ~= "None" then
			local checkbox = GET_CHILD(ctrlSet, "checkbox");
			if checkbox:IsChecked() == 1 then
				session.party.AddSkillTarget(aid);
			end
		end
	end
	
	session.party.ReqUsePartyMemberSkill(PARTY_GUILD, skillType);
	frame:ShowWindow(0);

end

function GUILD_MEMBER_SKILL_INVITE(argList)
    
	local sList = StringSplit(argList, "#");
    
	local aid = sList[1];
	local skillType = tonumber( sList[2] );
    
    local callMember = session.party.GetPartyMemberInfoByAID(PARTY_GUILD, aid);
	local callMemberName = callMember:GetName();
	
	local sklCls = GetClassByType("Skill", skillType);
	local msgString = ScpArgMsg("{CallMemberName}Use{SkillName}Skill_WillYouToAccept?", "CallMemberName", callMemberName, "SkillName", sklCls.Name);
    
    if callMemberName == nil then
        msgString = ScpArgMsg("GuildLeaderUse{SkillName}Skill_WillYouToAccept?", "SkillName", sklCls.Name);
    end
    
    local yesScp = string.format("ACCEPT_GUILD_SKILL(\"%s\", %d)", aid, skillType);
	ui.MsgBox(msgString, yesScp, "None");
end

function ACCEPT_GUILD_SKILL(aid, skillType)

	session.party.AcceptUsePartyMemberSkill(aid, skillType);
	
end




