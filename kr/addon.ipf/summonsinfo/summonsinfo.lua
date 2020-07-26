-- summons UI
function SUMMONSINFO_ON_INIT(addon, frame)
    addon:RegisterMsg("GAME_START", "SUMMONSINFO_INIT");
	addon:RegisterMsg("START_JOB_CHANGE", "SUMMONSINFO_INIT");
end

function SUMMONSINFO_INIT()
    local frame = ui.GetFrame("summonsinfo");
    if frame ~= nil then
        ui.OpenFrame("summonsinfo");
        frame:SetVisible(0);
    end

    local isNeedCheck = IS_NEED_SUMMON_UI();
    if frame ~= nil and isNeedCheck == 0 then
        frame:SetVisible(0);
    end
    
	-- pcparty Check
    local pcparty = session.party.GetPartyInfo();
	local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local count = list:Count();
    if pcparty == nil and isNeedCheck == 1 then
        ui.OpenFrame("summonsinfo");
        frame:SetVisible(1);
        
        local partyinfo = ui.GetFrame("partyinfo");
        partyinfo:SetUserConfig("CHANGE_FLAG", "1");
		PARTYINFO_BUTTON_UI_CHECK(0);
	elseif pcparty ~= nil and count >= 1 and isNeedCheck == 1 then
		ui.OpenFrame("summonsinfo");
        frame:SetVisible(0);
        
        local partyinfo = ui.GetFrame("partyinfo");
        partyinfo:SetUserConfig("CHANGE_FLAG", "0");
		PARTYINFO_BUTTON_UI_CHECK(1);
	end

	-- button & buttonText & tooltip
	local button = GET_CHILD_RECURSIVELY(frame, "summonsinfobutton");
	if button ~= nil then
		if count >= 1 then
			button:SetVisible(1);
		elseif count < 1 then
			button:SetVisible(0);
		end

		local hotkey = frame:GetUserConfig("SUMMONINFO_HOTKEY_TEXT");
		local parymemberinfoKeyIdx = config.GetHotKeyElementIndex("ID", "PartyMemberInfo");
		local parymemberinfoKey = config.GetHotKeyElementAttributeForConfig(parymemberinfoKeyIdx, "Key");
		if parymemberinfoKey ~= nil then
			hotkey = parymemberinfoKey;
		end

		SUMMONSINFO_BUTTON_TOOLTIP_CHANGE(hotkey);
		if hotkey ~= nil and hotkey ~= "" then
			button:SetTextTooltip(ClMsg("SummonsInfo_ConvertPartyInfo_ToolTip").."( "..hotkey.." )");
		end
		
		button:EnableHitTest(1);
	end

    local buttonText = GET_CHILD_RECURSIVELY(frame, "buttontitle");
	if buttonText ~= nil then
		buttonText:SetTextByKey("title", ClMsg("SummonsInfo_SummonsInfo"));
	end
end

function SUMMONSINFO_SET_POS(frame, x, y)
	if frame ~= nil then
		frame:MoveFrame(x, y);
	end
end

-- button title change (only partyinfo & summonsinfo)
function CHANGE_BUTTON_TITLE(frame, argstr)
    if frame ~= nil then
        local buttonText = GET_CHILD_RECURSIVELY(frame, "buttontitle");
        buttonText:SetTextByKey("title", argstr);
    end
end

-- need summonui job search
function IS_NEED_SUMMON_UI()
	local mySession = session.GetMySession();
	local pcJobInfo = mySession:GetPCJobInfo();
	local jobhistory = mySession:GetPCJobInfo();
    local gender = info.GetGender(session.GetMyHandle());
	local clslist, cnt  = GetClassList("Job");
	local ret = 0;
	for i = 1, jobhistory:GetJobCount() do
		local nowjobinfo = jobhistory:GetJobInfoByIndex(i - 1);
		local nowjobcls;
		if nil == nowjobinfo then
			return 0; 
		else
			nowjobcls = GetClassByTypeFromList(clslist, nowjobinfo.jobID);
		end

		local needSummonUI = TryGetProp(nowjobcls, "Summon_UI");
		if needSummonUI ~= nil and needSummonUI == "YES" then
			ret = 1;
			return ret;
		else
			ret = 0;
		end
	end
	return ret;
end

-- mouse down
function SUMMONSINFO_TOGGLE_BUTTON(frame, changeFlag)
    if frame ~= nil and changeFlag == 0 then
       frame:SetVisible(1);
    elseif frame ~= nil and changeFlag == 1 then
       frame:SetVisible(0);
    end

    SUMMONSINFO_UPDATE(frame);
end

-- summoninfo update
function SUMMONSINFO_UPDATE(frame)
    local isNeedSummonUI = IS_NEED_SUMMON_UI();
	if isNeedSummonUI == 0 then 
        frame:SetVisible(0);
		return;
	end

    local button = GET_CHILD_RECURSIVELY(frame, "summonsinfobutton");
    local buttonTitle = GET_CHILD_RECURSIVELY(frame, "buttontitle");
	local title_gbox = GET_CHILD_RECURSIVELY(frame, "titlegbox");

    if frame:IsVisible() == 0 then
        button:SetVisible(0);
        buttonTitle:SetVisible(0);
		title_gbox:SetVisible(0);
    else
		title_gbox:SetVisible(1);
		buttonTitle:SetVisible(1);
		
        local pcparty = session.party.GetPartyInfo();
        if pcparty == nil then
			button:SetVisible(0);
			buttonTitle:SetTextByKey("title", ClMsg("SummonsInfo_SummonsInfo"));
        else
			button:SetVisible(1);
	        buttonTitle:SetTextByKey("title", ClMsg("SummonsInfo_SummonsInfo"));
        end
    end
	
    SUMMONSINFO_CONTROLSET_AUTO_ALIGN(frame);
end

-- summon controlset setvisible
function SUMMONSINFO_SETVISIBLE_CONTROLSET(frame, isVisible)
	local count = frame:GetChildCount();
	for i = 1, count do
		local ctrlSet = frame:GetChildByIndex(i);
		if ctrlSet ~= nil then
			local ctrlSetName = ctrlSet:GetName();
			if string.find(ctrlSetName, "SUMMONINFO_") ~= nil then
				ctrlSet:SetVisible(isVisible);
			end
		end
	end

	frame:Invalidate();
	SUMMONSINFO_CONTROLSET_AUTO_ALIGN(frame);
end

-- update follwer monster infomation
function UPDATE_PC_FOLLOWER_LIST(dataStr)
	local monIDList = {};
	local countList = {};
	local datas = StringSplit(dataStr, '#');
	for i = 1, #datas do
		local data = datas[i];
		local colonIndex = string.find(data, ':');
		if colonIndex ~= nil then
			monIDList[#monIDList + 1] = tonumber(string.sub(data, 0, colonIndex - 1));
			countList[#countList + 1] = tonumber(string.sub(data, colonIndex + 1));
		end
	end

	ON_UPDATE_MY_SUMMON_MONSTER(monIDList, countList);
end

local function sort_func(a, b)
    return a < b;
end

-- 현재까지 소환한 소환수 controlset name 정보
local temp = {}

local function startsWith(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

local function is_summoning_mon(mon_name)        
    return startsWith(mon_name:lower(), 'pc_summon_')
end

-- create summonui controlset
function ON_UPDATE_MY_SUMMON_MONSTER(monIdList, monCountList)        
	local frame = ui.GetFrame("summonsinfo");
	if frame == nil then
		return;
	end
    
    local count_map = {}
    local mon_name_list = {}
    local mon_name_id_map = {}
    for i = 1, #monIdList do
        local mon_name = geMonsterTable.GetMonsterNameByType(monIdList[i]);
        count_map[mon_name] = tonumber(monCountList[i])
        mon_name_list[#mon_name_list + 1] = mon_name
        mon_name_id_map[mon_name] = monIdList[i]
    end
        
    table.sort(mon_name_list, sort_func)    
	local ctrlsetHeight = tonumber(frame:GetUserConfig("SUMMONINFO_CTRLSET_HEIGHTOFFSET"));
    
    for k, v in pairs(temp) do
		frame:RemoveChild(k);
    end
    
    for i = 1, #mon_name_list do        
        local class_name = geMonsterTable.GetMonsterClassNameByType( mon_name_id_map[mon_name_list[i]]);
        if is_summoning_mon(class_name) == true then
            local ctrlName = "SUMMONINFO_" .. mon_name_id_map[mon_name_list[i]];        
		    local summonsInfoCtrlSet = frame:CreateOrGetControlSet('summonsinfo', ctrlName, 10, i * ctrlsetHeight); 
		    local summonsName = GET_CHILD_RECURSIVELY(summonsInfoCtrlSet, "summons_name");
		    local summonsCount = GET_CHILD_RECURSIVELY(summonsInfoCtrlSet, "summons_count");
		    local monName = mon_name_list[i]              
            temp[summonsInfoCtrlSet:GetName()] = 1        
		    if monName ~= nil then
			    summonsName:SetTextByKey("name", monName);
			    summonsCount:SetTextByKey("count", count_map[monName]);
            end            
        end
    end

    for i = 1, #mon_name_list do        
        local class_name = geMonsterTable.GetMonsterClassNameByType( mon_name_id_map[mon_name_list[i]]);
        if is_summoning_mon(class_name) == false then
            local ctrlName = "SUMMONINFO_" .. mon_name_id_map[mon_name_list[i]];        
		    local summonsInfoCtrlSet = frame:CreateOrGetControlSet('summonsinfo', ctrlName, 10, i * ctrlsetHeight); 
		    local summonsName = GET_CHILD_RECURSIVELY(summonsInfoCtrlSet, "summons_name");
		    local summonsCount = GET_CHILD_RECURSIVELY(summonsInfoCtrlSet, "summons_count");
		    local monName = mon_name_list[i]              
            temp[summonsInfoCtrlSet:GetName()] = 1        
		    if monName ~= nil then
			    summonsName:SetTextByKey("name", monName);
			    summonsCount:SetTextByKey("count", count_map[monName]);
            end		
        end
    end

    frame:Invalidate();
	SUMMONSINFO_CONTROLSET_AUTO_ALIGN(frame);
end

function SUMMONSINFO_CONTROLSET_AUTO_ALIGN(frame)
	GBOX_AUTO_ALIGN(frame, 10, 0, 0, true, false);
	frame:Invalidate();
end

function SUMMONSINFO_BUTTON_TOOLTIP_CHANGE(changeTxt)
	local parytinfo_frame = ui.GetFrame("partyinfo");
	local summonsinfo_frame = ui.GetFrame("summonsinfo");
	if parytinfo_frame == nil then return; end
	if summonsinfo_frame == nil then return; end

	local partyinfo_button = GET_CHILD_RECURSIVELY(parytinfo_frame, "partyinfobutton");
	local summonsinfo_button = GET_CHILD_RECURSIVELY(summonsinfo_frame, "summonsinfobutton");
	if partyinfo_button == nil then return; end
	if summonsinfo_button == nil then return; end

	if GetServerNation() == "GLOBAL_JP" and changeTxt == "GRAVE" or changeTxt == "`" then
		partyinfo_button:SetTextTooltip("");
		summonsinfo_button:SetTextTooltip("");
		summonsinfo_frame:SetUserConfig("SUMMONINFO_HOTKEY_TEXT", "");
		return;
	end

	if string.find(changeTxt, "GRAVE") ~= nil then
		changeTxt = string.gsub(changeTxt, "GRAVE", "`");	
	end

	summonsinfo_frame:SetUserConfig("SUMMONINFO_HOTKEY_TEXT", changeTxt);
	summonsinfo_button:SetTextTooltip(ClMsg("SummonsInfo_ConvertPartyInfo_ToolTip").."( "..changeTxt.." )");
	partyinfo_button:SetTextTooltip(ClMsg("SummonsInfo_ConvertSummonsInfo_ToolTip").."( "..changeTxt.." )");

	summonsinfo_frame:Invalidate();
	parytinfo_frame:Invalidate();
end