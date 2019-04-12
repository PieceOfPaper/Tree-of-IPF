
function GUILDGROWTH_ON_INIT(addon, frame)
	
	addon:RegisterMsg("OPEN_DLG_GUILDGROWTH", "ON_OPEN_DLG_GUILDGROWTH");		
	addon:RegisterOpenOnlyMsg("GUILD_PROPERTY_UPDATE", "GUILDGROWTH_GUILD_PROPERTY_UPDATE");
	addon:RegisterOpenOnlyMsg("GUILD_MEMBER_PROP_UPDATE", "GUILDGROWTH_GUILD_PROPERTY_UPDATE");
	

end

function ON_OPEN_DLG_GUILDGROWTH(frame)
	frame:ShowWindow(1);
end

function GUILDGROWTH_UPDATE_ABILITY(frame, guildObj)

	local abilities = GET_CHILD(frame, "abilities");

	local txt_current_point = GET_CHILD(abilities, "txt_current_point");
	local used = guildObj.UsedAbilStat;
	local current = GET_GUILD_ABILITY_POINT(guildObj);
	local ablePoint = current - used;
	local ablePointText = ScpArgMsg("UsableAbilityPoint") .. " : " .. ablePoint;	
	txt_current_point:SetTextByKey("value", ablePointText);
	
	local gbox_ability = abilities:GetChild("gbox_ability");
	local gbox_list = gbox_ability:GetChild("gbox_list");
	gbox_list:RemoveAllChild();
	
	local clsList, cnt = GetClassList("Guild_Ability");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		local ctrlSet = gbox_list:CreateControlSet("guild_ability_ctrl", "CTRLSET_" .. cls.ClassID,  ui.LEFT, ui.TOP, 0, 0, 0, 0);
		UPDATE_GUILD_ABILITY_CTRLSET(ctrlSet, cls, guildObj);
	end

	GBOX_AUTO_ALIGN(gbox_list, 10, 10, 10, true, false);
	

end

function UPDATE_GUILD_ABILITY_CTRLSET(ctrlSet, cls, guildObj)
	ctrlSet:SetUserValue("CLASSID", cls.ClassID);
	
	local pic = GET_CHILD(ctrlSet, "pic");
	pic:SetImage(cls.Icon);
	local t_ability_name = GET_CHILD(ctrlSet, "t_ability_name");
	t_ability_name:SetTextByKey("value", cls.Name);

	local t_ability_desc = GET_CHILD(ctrlSet, "t_ability_desc");
	t_ability_desc:SetTextByKey("value", cls.Desc);
	local t_level = GET_CHILD(ctrlSet, "t_level");

	local curLevel = guildObj["AbilLevel_" .. cls.ClassName];
	t_level:SetTextByKey("value", curLevel);

	local t_sp = GET_CHILD(ctrlSet, "t_sp");
	local t_cooldown = GET_CHILD(ctrlSet, "t_cooldown");
	if cls.SkillName == "None" then
		t_sp:ShowWindow(0);
		t_cooldown:ShowWindow(0);
	else
		t_sp:ShowWindow(1);
		t_cooldown:ShowWindow(1);
	end
	
	if curLevel >= cls.MaxLevel then
		local btn = GET_CHILD(ctrlSet, "btn");
		btn:ShowWindow(0);
	end
	
end

function GUILD_ABILITY_UP(parent, ctrl)

	local isLeader = AM_I_LEADER(PARTY_GUILD);
	if isLeader == 0 then
		ui.MsgBox(ScpArgMsg("OnlyGuildLeader"));
		return;
	end

	local clsID = parent:GetUserIValue("CLASSID");
	local yesScp = string.format("_EXEC_GUILD_ABILITY_UP(%d)", clsID);
	ui.MsgBox( ScpArgMsg("ExecLearnAbility"), yesScp, "None");
	
end

function _EXEC_GUILD_ABILITY_UP(clsID)

	local pcGuild = session.party.GetPartyInfo(PARTY_GUILD);
	local guildObj = GetIES(pcGuild:GetObject());
	local used = guildObj.UsedAbilStat;
	local current = GET_GUILD_ABILITY_POINT(guildObj);
	local ablePoint = current - used;
	if ablePoint <= 0 then
		ui.MsgBox(ScpArgMsg("NotEnoughPoint"));
		return;
	end


	local scpString = string.format("/learnguildabil %d", clsID);
	ui.Chat(scpString);

end

function GUILDGROWTH_OPEN(frame)

	local pcGuild = session.party.GetPartyInfo(PARTY_GUILD);
	if pcGuild == nil then
		--frame:ShowWindow(0);
		--return;
	end

	local guildObj = GetIES(pcGuild:GetObject());
	local lv = guildObj.Level;
	local nextLv = lv + 1;

	local ctrlset_growth = frame:GetChild("ctrlset_growth");
	local txt_nextlvdesc = ctrlset_growth:GetChild("txt_nextlvdesc");
	local gbox_next = ctrlset_growth:GetChild("gbox_next");
	local txt_nextlv = gbox_next:GetChild("txt_nextlv");

	local nextExpCls = GetClassByType("GuildExp", nextLv);
	if nextExpCls ~= nil then
		txt_nextlvdesc:SetTextByKey("value", nextExpCls.Desc);
	else
		txt_nextlvdesc:SetTextByKey("value", ScpArgMsg("MaxLevel"));
	end

	local currentExp = guildObj.Exp;
	local curLevelCls = GetClass("GuildExp", lv);
	local nextLevelCls = GetClass("GuildExp", nextLv);
	local curExp = currentExp - curLevelCls.Exp;

	local gbox_exp = ctrlset_growth:GetChild("gbox_exp");
	local gauge = GET_CHILD(gbox_exp, "gauge");
	local txt_lv_current = gbox_exp:GetChild("txt_lv_current");
	local txt_lv_next = gbox_exp:GetChild("txt_lv_next");

	txt_lv_current:SetTextByKey("value", lv);
	if nextLevelCls ~= nil then
		local text = ScpArgMsg("NextGuildTower") .. " Lv. "  ..nextLv;
		txt_nextlv:SetTextByKey("value", text);
		gauge:SetPoint(curExp, nextLevelCls.Exp - curLevelCls.Exp);
		txt_lv_next:SetTextByKey("value", nextLv);
		txt_lv_next:ShowWindow(1);
	else
		txt_lv_next:ShowWindow(0);
		txt_nextlv:SetTextByKey("value", ScpArgMsg("MaxLevel"));
		gauge:SetPoint(1000, 1000);
	end		

	GUILDGROWTH_UPDATE_CONTRIBUTION(frame, guildObj)
	GUILDGROWTH_UPDATE_ABILITY(frame, guildObj);

end

function GUILDGROWTH_UPDATE_CONTRIBUTION(frame, guildObj)
	local ctrlset_growth = frame:GetChild("ctrlset_growth");
	local gbox_contribution = ctrlset_growth:GetChild("gbox_contribution");
	local gbox_list = gbox_contribution:GetChild("gbox_list");

	gbox_list:RemoveAllChild();

	local currentExp = guildObj.Exp;
	local list = session.party.GetSortedPartyMemberList(PARTY_GUILD, "Contribution", true);
	local count = list:Count();
	local rank = 1;
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i);
		local memberObj = GetIES( partyMemberInfo:GetObject() );
		local curContribution = memberObj.Contribution;
		if curContribution > 0 then

			local ctrlSet = gbox_list:CreateControlSet("guildgrowth_contribution", "CTRLSET_" .. i,  ui.LEFT, ui.TOP, 0, 0, 0, 0);
			local t_rank = GET_CHILD(ctrlSet, "t_rank");
			t_rank:SetTextByKey("value", rank);
			rank = rank + 1;

			local t_name = GET_CHILD(ctrlSet, "t_name");
			t_name:SetTextByKey("value", partyMemberInfo:GetName());
			if currentExp > 0 then
				local percent = curContribution * 100 / currentExp;
				local t_percent = GET_CHILD(ctrlSet, "t_percent");
				t_percent:SetTextByKey("value", percent);
				local gauge = GET_CHILD(ctrlSet, "gauge");
				gauge:SetPoint(curContribution, currentExp);
			end
			
		end


	end	
	
	GBOX_AUTO_ALIGN(gbox_list, 0, 0, 0, true, false);

end

function GUILDGROWTH_CLOSE(frame)

	control.DialogOk();

end

function DROP_GUILDGROWTH_TALT(parent, ctrl)

	local invItem = GET_DRAG_INVITEM_INFO();

	local dropItemCls = GetClassByType("Item", invItem.type);
	local itemName = GET_GUILD_EXPUP_ITEM_INFO();
	local taltCls = GetClass("Item", itemName);
	if itemName ~= dropItemCls.ClassName then
		local text = ScpArgMsg("DropItem{Name}ForGuildExpUp", "Name", taltCls.Name);
		ui.SysMsg(text);
		return;
	end

	local frame = parent:GetTopParentFrame();
	INPUT_NUMBER_BOX(frame, ScpArgMsg("InputCount"), "EXEC_DROP_GUILDTALT", invItem.count, 1, invItem.count);
	frame:SetUserValue("IES_ID", invItem:GetIESID());
	

end

function EXEC_DROP_GUILDTALT(frame, count, inputframe, fromFrame)
	
	frame = frame:GetTopParentFrame();
	local iesID = frame:GetUserValue("IES_ID"); 
	
	local ctrlset_growth = frame:GetChild("ctrlset_growth");
	local pic = GET_CHILD(ctrlset_growth, "pic");
	local invItem = session.GetInvItemByGuid(iesID);
	SET_SLOT_ITEM(pic, invItem);
	SET_SLOT_COUNT_TEXT(pic, count);
	frame:SetUserValue("Count", count);

end

function EXEC_GUILD_GROWTH_TALT(parent, ctrl)

	local pic = GET_CHILD(parent, "pic");

	local item = GET_SLOT_ITEM(pic);
	if nil == item then
		ui.SysMsg(ClMsg('NoTaltinTheSlot'));
		return;
	end;

	local yesScp = "_EXEC_GUILD_GROWTH_TALT()";
	ui.MsgBox(ScpArgMsg('REALLY_DO'), yesScp, "None");

end

function _EXEC_GUILD_GROWTH_TALT()
	
	local frame = ui.GetFrame("guildgrowth");
	local iesID = frame:GetUserValue("IES_ID"); 
	local count = frame:GetUserIValue("Count"); 
	
	local scpString = string.format("/guildexpup %s %d", iesID, count);
	ui.Chat(scpString);


	local ctrlset_growth = frame:GetChild("ctrlset_growth");
	local pic = GET_CHILD(ctrlset_growth, "pic");
	CLEAR_SLOT_ITEM_INFO(pic);
end

function GUILDGROWTH_GUILD_PROPERTY_UPDATE(frame)

	GUILDGROWTH_OPEN(frame);	

end





