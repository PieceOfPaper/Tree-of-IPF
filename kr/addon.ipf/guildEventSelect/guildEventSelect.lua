function REQ_OPEN_GUILD_EVENT_PIP()
 	gGuileEventList = {"FBOSS", "MISSION"}
	GUILD_EVENT_OPEN(nil)
end


function GUILD_EVENT_OPEN(frame)

	if frame == nil then
		frame = ui.GetFrame("guildEventSelect")
	end
	
	ui.OpenFrame("guildEventSelect");

	local pcGuild = session.party.GetPartyInfo(PARTY_GUILD);
	if pcGuild == nil then
		return;
	end

	local guildObj = GetIES(pcGuild:GetObject());
	local lv = guildObj.Level;

	local lvText = GET_CHILD_RECURSIVELY(frame, "guildLevel");
	lvText:SetTextByKey("value", lv);

	CREATE_GUILD_EVENT_LIST_INIT(frame)
	CREATE_GUILD_EVENT_LIST(frame)
end

function CREATE_GUILD_EVENT_LIST(frame)
	local gbox = GET_CHILD(frame, "bg_title_key");
	DESTROY_CHILD_BY_USERVALUE(gbox, "GUILD_EVENT_CTRL", "YES");
	local droplist = GET_CHILD(frame, "droplist_1", "ui::CDropList");
	local clsList, cnt = GetClassList("GuildEvent");

	local pcGuild = session.party.GetPartyInfo(PARTY_GUILD);
	if pcGuild == nil then
	end
	local guildObj = GetIES(pcGuild:GetObject());
	local lv = guildObj.Level;

	for i = 0, cnt - 1 do	
		local cls = GetClassByIndexFromList(clsList, i);
		if cls.EventType == gGuileEventList[droplist:GetSelItemIndex()+1] then
		    local ticket_value = 1
		    if cls.ClassName == 'GM_BorutosKapas_1' then
		        ticket_value = 3
		    end

			if cls.GuildLv > 0 and lv >= cls.GuildLv then
				local ctrlSet = gbox:CreateControlSet("guild_event", cls.ClassName, ui.LEFT, ui.TOP, 0, 0, 0, 0);
				ctrlSet:SetUserValue("GUILD_EVENT_CTRL", "YES");
				local eventName = GET_CHILD(ctrlSet, "EventName");
				eventName:SetTextByKey("value", cls.Name);

				local userCount = GET_CHILD(ctrlSet, "UserCount");
				userCount:SetTextByKey("value", cls.MaxPlayerCnt);

				local timeLimit = GET_CHILD(ctrlSet, "TimeLimit");	
				timeLimit:SetTextByKey("value", cls.TimeLimit/60);

				local detailInfo = GET_CHILD(ctrlSet, "detailInfo");	
				detailInfo:SetTextByKey("value", cls.DetailInfo);

				local ticketText = GET_CHILD(ctrlSet, "ticketText");	

				ticketText:SetTextByKey("value", ticket_value);

				local eventType = GET_CHILD_RECURSIVELY(ctrlSet, "EventType", "ui::CPicture");
				local imgName = frame:GetUserConfig("EVENT_TYPE_"..droplist:GetSelItemIndex())
				eventType:SetImage(imgName);
				ctrlSet:SetUserValue("CLSID", cls.ClassID);
				--local addheight = gbox:GetHeight() - gbox:GetOriginalHeight()
				--ctrlSet:Resize(ctrlSet:GetOriginalWidth(), ctrlSet:GetOriginalHeight() + addheight)
			end
		end
	end

	GBOX_AUTO_ALIGN(gbox, 0, 0, 10, true, false);

	--local ctrlSet = gbox:CreateControlSet("guild_event", "A", ui.LEFT, ui.TOP, 0, 0, 0, 0);	
end

function CREATE_GUILD_EVENT_LIST_INIT(frame)
	
	local droplist = GET_CHILD(frame, "droplist_1", "ui::CDropList");
	droplist:ClearItems();
	droplist:AddItem("0",  ClMsg("GuildIBossSummon"), 0);
	droplist:AddItem("1",  ClMsg("GuildMission"), 0);
end

function CREATE_GUILD_EVENT_LIST_CLICK(frame, ctrl)
	local list = tolua.cast(ctrl, "ui::CDropList");
	CREATE_GUILD_EVENT_LIST(frame)
end


function ACCEPT_GUILD_EVENT(parent, ctrl)
	local clsID = parent:GetUserIValue("CLSID");
	local cls = GetClassByType("GuildEvent", clsID)
	local msg = ScpArgMsg("DoYouWant{GuildEvent}Start?", "GuildEvent", cls.Name);
	local yesScp = string.format("EXEC_GUILD_EVENT(%d)", clsID);
	ui.MsgBox(msg, yesScp, "None");
end

function EXEC_GUILD_EVENT(clsID)
    local cls = GetClassByType("GuildEvent", clsID)
    local special_mission = 0
    if cls.ClassName == 'GM_BorutosKapas_1' then
        special_mission = 1
    end

	local pcGuild = session.party.GetPartyInfo(PARTY_GUILD);
	if pcGuild == nil then
		return;
	end
	local guildObj = GetIES(pcGuild:GetObject());

	local haveTicket = GET_REMAIN_TICKET_COUNT(guildObj)

	if haveTicket <= 0 then
		ui.SysMsg(ScpArgMsg("NotEnoughTicketPossibleCount"));
		return;
	end
	
	if special_mission == 1 then
	    local CheckTime = guildObj.GuildEvent_BorutosKapas_Count

        if CheckTime > 0 then
            ui.SysMsg(ScpArgMsg("NotEnoughTicketPossibleCount_GMBK"));
            return
        end

	    if haveTicket < 3 then
    		ui.SysMsg(ScpArgMsg("NotEnoughTicketPossibleCount"));
    		return;
    	end
	end
	
	ui.CloseFrame('guildEventSelect');
	control.CustomCommand("GUILD_EVENT_START_REQUEST", clsID);
end