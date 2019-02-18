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

		button:SetTextTooltip("파티 정보로 전환(`)");
		button:EnableHitTest(1);
	end

    local buttonText = GET_CHILD_RECURSIVELY(frame, "buttontitle");
	if buttonText ~= nil then
		buttonText:SetTextByKey("title", "소환수 정보");
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
			buttonTitle:SetTextByKey("title", "소환수 정보");
        else
			button:SetVisible(1);
	        buttonTitle:SetTextByKey("title", "소환수 정보");
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

-- create summonui controlset
function ON_UPDATE_MY_SUMMON_MONSTER(monIdList, monCountList)
	local frame = ui.GetFrame("summonsinfo");
	if frame == nil then
		return;
	end

	local ctrlsetHeight = tonumber(frame:GetUserConfig("SUMMONINFO_CTRLSET_HEIGHTOFFSET"));
	for i = 1, #monIdList do
		local ctrlName = "SUMMONINFO_" .. monIdList[i];
		local summonsInfoCtrlSet = frame:CreateOrGetControlSet('summonsinfo', ctrlName, 10, i * ctrlsetHeight); 

		local summonsName = GET_CHILD_RECURSIVELY(summonsInfoCtrlSet, "summons_name");
		local summonsCount = GET_CHILD_RECURSIVELY(summonsInfoCtrlSet, "summons_count");
		local monName = geMonsterTable.GetMonsterNameByType(monIdList[i]);
		if monName ~= nil then
			summonsName:SetTextByKey("name", monName);
			summonsCount:SetTextByKey("count", monCountList[i]);
		end		

		if monCountList[i] <= 0 then
			frame:RemoveChild(summonsInfoCtrlSet:GetName());
        end
	end

    frame:Invalidate();
	SUMMONSINFO_CONTROLSET_AUTO_ALIGN(frame);
end

function SUMMONSINFO_CONTROLSET_AUTO_ALIGN(frame)
	GBOX_AUTO_ALIGN(frame, 10, 0, 0, true, false);
	frame:Invalidate();
end
