function GUILDBATTLE_LEAGUE_ON_INIT(addon, frame)

	addon:RegisterMsg("PVP_TIME_TABLE", "ON_PVP_TIME_TABLE");
	addon:RegisterMsg("PVP_PC_INFO", "ON_PVP_PC_INFO");
	addon:RegisterMsg("PVP_STATE_CHANGE", "ON_PVP_STATE_CHANGE");
	addon:RegisterMsg("PVP_PROPERTY_UPDATE", "ON_PVP_PROPERTY_UPDATE");
	addon:RegisterMsg("PVP_HISTORY_UPDATE", "ON_PVP_HISTORY_UPDATE");
			
end

g_enablePVPExp = 1;

function GUILDBATTLE_LEAGUE_FIRST_OPEN(frame)
	frame:SetUserValue("DROPLIST_CREATED", 1);
	local bg = frame:GetChild("bg");
	local charinfo = bg:GetChild("charinfo");
	local droplist = GET_CHILD(charinfo, "droplist", "ui::CDropList");
	droplist:ClearItems();
	local clsList, cnt = GetClassList("WorldPVPType");
	local select = 0;
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		if cls.MatchType =="Guild" then
		droplist:AddItem(cls.ClassID, "{@st42}" .. cls.Name);
			select = i;
	end
	end

	droplist:SelectItemByKey(select);

	if cnt <= 1 then
		droplist:ShowWindow(0);
		droplist_rank:ShowWindow(0);
	end

	ON_PVP_HISTORY_UPDATE(frame);
end

function GUILDBATTLE_LEAGUE_ON_RELOAD(frame)
	GUILDBATTLE_LEAGUE_FIRST_OPEN(frame);
end

function CLOSE_GUILDBATTLE_LEAGUE(frame)
	local popup = ui.GetFrame("minimizedalarm");
	ON_PVP_PLAYING_UPDATE(popup);
end

function OPEN_GUILDBATTLE_LEAGUE(frame)

	UPDATE_WORLDPVP(frame);
	local title = frame:GetChild("title");
	title:SetTextByKey("value", ScpArgMsg("WorldGuildPVP"));
    
	local tab = GET_CHILD(frame, "tab");
	if tab ~= nil then
		tab:SelectTab(0);
	end

	GUILDBATTLE_LEAGUE_SET_UI_MODE(frame, "");
	local ret = worldPVP.RequestPVPInfo();
	if ret == false then
		ON_PVP_TIME_TABLE(frame);
	else
		local bg = frame:GetChild("bg");
		local loadingtext = bg:GetChild("loadingtext");
		local charinfo = bg:GetChild("charinfo");
		loadingtext:ShowWindow(1);
		charinfo:ShowWindow(0);
	end

	ON_PVP_STATE_CHANGE(frame);
end

function GUILDBATTLE_LEAGUE_TAB_CHANGE(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local tab = GET_CHILD(frame, "tab");
	local index = tab:GetSelectItemIndex();
	if index == 0 then
		SHOW_GUILDBATTLE_LEAGUE_PAGE(frame);
	elseif index == 1 then
		GUILDBATTLE_LEAGUE_OBSERVE_UI(frame);
	end
	
end

function GUILDBATTLE_LEAGUE_OBSERVE_UI(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	worldPVP.RequestPublicGameList();
	GUILDBATTLE_LEAGUE_SET_UI_MODE(frame, "observer");
				
end

function SHOW_GUILDBATTLE_LEAGUE_PAGE(parent)
	local frame = parent:GetTopParentFrame();
	GUILDBATTLE_LEAGUE_SET_UI_MODE(frame, "");
end

function GUILDBATTLE_LEAGUE_SET_UI_MODE(frame, uiType)
	local bg_observer = frame:GetChild("bg_observer");
	local bg = frame:GetChild("bg");
	bg_observer:ShowWindow(0);
	bg:ShowWindow(0);
	if uiType == "" then
		bg:ShowWindow(1);
	else
		local openBG = frame:GetChild("bg_" .. uiType);
		openBG:ShowWindow(1);
	end
	
end	