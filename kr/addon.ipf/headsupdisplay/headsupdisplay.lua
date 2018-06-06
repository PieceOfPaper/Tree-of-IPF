function HEADSUPDISPLAY_ON_INIT(addon, frame)

	addon:RegisterOpenOnlyMsg('STANCE_CHANGE', 'HEADSUPDISPLAY_ON_MSG');
	addon:RegisterOpenOnlyMsg('NAME_UPDATE', 'HEADSUPDISPLAY_ON_MSG');
	addon:RegisterOpenOnlyMsg('STAT_UPDATE', 'HEADSUPDISPLAY_ON_MSG');
	addon:RegisterOpenOnlyMsg('TAKE_DAMAGE', 'HEADSUPDISPLAY_ON_MSG');
	addon:RegisterOpenOnlyMsg('TAKE_HEAL', 'HEADSUPDISPLAY_ON_MSG');
    
    addon:RegisterOpenOnlyMsg('STA_UPDATE', 'STAMINA_UPDATE');
    addon:RegisterOpenOnlyMsg('PC_PROPERTY_UPDATE', 'STAMINA_UPDATE');
    addon:RegisterOpenOnlyMsg('CANT_RUN_STA', 'CANT_RUN_ALARM');
    addon:RegisterOpenOnlyMsg('CANT_JUMP_STA', 'CANT_JUMP_ALARM');

	addon:RegisterMsg('CAUTION_DAMAGE_INFO', 'HEADSUPDISPLAY_ON_MSG');
	addon:RegisterMsg('CAUTION_DAMAGE_INFO_RELEASE', 'HEADSUPDISPLAY_ON_MSG');

	addon:RegisterMsg('STAT_UPDATE', 'HEADSUPDISPLAY_ON_MSG');
	addon:RegisterMsg('GAME_START', 'HEADSUPDISPLAY_ON_MSG');
	addon:RegisterMsg('LEVEL_UPDATE', 'HEADSUPDISPLAY_ON_MSG');

	addon:RegisterMsg('CHANGE_COUNTRY', 'HEADSUPDISPLAY_ON_MSG');

	addon:RegisterMsg("MYPC_CHANGE_SHAPE", "HEADSUPDISPLAY_ON_MSG");
    addon:RegisterMsg('GAME_START', 'HUD_SET_SAVED_OFFSET');
    addon:RegisterMsg('CHANGE_RESOLUTION', 'HUD_SET_SAVED_OFFSET');
    addon:RegisterMsg("CAMP_UPDATE", "HEADSUPDISPLAY_SET_CAMP_BTN");
    addon:RegisterMsg("PARTY_UPDATE", "HEADSUPDISPLAY_SET_CAMP_BTN");

	local leaderMark = GET_CHILD(frame, "Isleader", "ui::CPicture");
	leaderMark:SetImage('None_Mark');
end

function CANT_RUN_ALARM(frame, msg, argStr, argNum)

	local sta = frame:GetChild('sta1');
	local staGauge = tolua.cast(sta, "ui::CGauge");
	staGauge:SetGrayStyle(0);
	ui.AlarmMsg("NotEnoughStamina");
	imcSound.PlaySoundEvent('stamina_alarm');

end

function CANT_JUMP_ALARM(frame, msg, argStr, argNum)
	CANT_RUN_ALARM(frame, msg, argStr, argNum);
end

function MOVETOCAMP(aid)
	session.party.RequestMoveToCamp(aid);
end

function CONTEXT_MY_INFO(frame, ctrl)
	local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local count = list:Count();
	-- 파티원이 존재 할 때
	if 0 < count then
		local context = ui.CreateContextMenu("CONTEXT_PARTY", "", 0, 0, 170, 100);
		local campCount = 0;
		for i = 0 , count - 1 do
			local partyMemberInfo = list:Element(i);
			local map = GetClassByType("Map", partyMemberInfo.campMapID);
			if  nil ~= map then
				campCount = campCount +1;
			end
		end
		if 0 < campCount then
			local str =  string.format("{@st41b}%s(%d)", ClMsg("MoveToCampChar"), campCount);
			ui.AddContextMenuItem(context, str, "None");
		end

		for i = 0 , count - 1 do
			local partyMemberInfo = list:Element(i);
			if partyMemberInfo.campMapID ~= 0 then
				local map = GetClassByType("Map", partyMemberInfo.campMapID);
				if nil ~= map then
					local obj = GetIES(partyMemberInfo:GetObject());
					str = string.format("      {@st59s}{#FFFF00}%s {#FFFFFF}%s",obj.Name, map.Name);
					ui.AddContextMenuItem(context, str, string.format("MOVETOCAMP(\"%s\")", partyMemberInfo:GetAID()));
				end
			end
		end
		ui.AddContextMenuItem(context, ScpArgMsg("WithdrawParty"), "OUT_PARTY()");	
		ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
		ui.OpenContextMenu(context);
		return;
	end

	local mapID = session.loginInfo.GetSquireMapID();
	local map = GetClassByType("Map", mapID);
	if nil == map then
		return;
	end
	
	local context = ui.CreateContextMenu("CONTEXT_PARTY", "", 0, 0, 170, 100);
	local str =  string.format("{@st41b}%s(1)", ClMsg("MoveToCampChar"));
	ui.AddContextMenuItem(context, str, "None");

	local obj = GetMyPCObject();
	str = string.format("      {@st59s}{#FFFF00}%s {#FFFFFF}%s",obj.Name, map.Name);
	ui.AddContextMenuItem(context, str, string.format("MOVETOCAMP(\"%s\")", session.loginInfo.GetAID()));
	ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
	ui.OpenContextMenu(context);
end

function HEADSUPDISPLAY_ON_MSG(frame, msg, argStr, argNum)
	local hpGauge = GET_CHILD(frame, "hp", "ui::CGauge");
	local spGauge = GET_CHILD(frame, "sp", "ui::CGauge");

	if msg == 'STANCE_CHANGE' or msg == 'NAME_UPDATE' or msg == 'LEVEL_UPDATE' or msg == 'GAME_START' or msg == 'CHANGE_COUNTRY' or msg == 'MYPC_CHANGE_SHAPE' then        
		local levelRichText = GET_CHILD(frame, "level_text", "ui::CRichText");
		local level = GETMYPCLEVEL();
        levelRichText:SetText('{@st41}Lv. '..level);

		local MySession = session.GetMyHandle()
		local CharName = info.GetFamilyName(MySession);
		local nameRichText = GET_CHILD(frame, "name_text", "ui::CRichText");
		nameRichText:SetText('{@st41}'..CharName)

		local MyJobNum = info.GetJob(MySession);
		local JobCtrlType = GetClassString('Job', MyJobNum, 'CtrlType');
		config.SetConfig("LastJobCtrltype", JobCtrlType);
		config.SetConfig("LastPCLevel", level);

        HUD_SET_EMBLEM(frame, MyJobNum);
	end

	if msg == 'LEVEL_UPDATE'  or  msg == 'STAT_UPDATE'  or  msg == 'TAKE_DAMAGE'  or  msg == 'TAKE_HEAL' or msg == 'GAME_START' or msg == 'CHANGE_COUNTRY' then
		local stat = info.GetStat(session.GetMyHandle());
		local beforeVal = hpGauge:GetCurPoint();
		if beforeVal > 0 and stat.HP < beforeVal then
			UI_PLAYFORCE(hpGauge, "gauge_damage");
		end		
		hpGauge:SetMaxPointWithTime(stat.HP, stat.maxHP, 0.1, 0.5);
		spGauge:SetMaxPointWithTime(stat.SP, stat.maxSP, 0.1, 0.5);
        
		local hpRatio = stat.HP / stat.maxHP;
		if  hpRatio <= 0.3 and hpRatio > 0 then
            --hpGauge:SetBlink(0.0, 1.0, 0xffff3333); -- (duration, 주기, 색상) -- 게이지 양 끝에 점멸되는 버그 잡고 써야함.
		else
			hpGauge:ReleaseBlink();
		end
	end

	if msg == 'CAUTION_DAMAGE_INFO' then
		CAUTION_DAMAGE_INFO(argNum);
	elseif msg == 'CAUTION_DAMAGE_INFO_RELEASE' then
		CAUTION_DAMAGE_INFO_RELEASE();
	end
end

function HUD_SET_EMBLEM(frame, jobClassID)
    local jobCls = GetClassByType('Job', jobClassID);
    local jobIcon = TryGetProp(jobCls, 'Icon');
    if jobIcon == nil then
        return;
    end    
    local mySession = session.GetMySession();
    local jobPic = GET_CHILD_RECURSIVELY(frame, 'jobPic');
    jobPic:SetImage(jobIcon);
    PARTY_JOB_TOOLTIP_BY_CID(mySession:GetCID(), jobPic, jobCls);

    local jobStarText = GET_CHILD_RECURSIVELY(frame, 'jobStarText');
    local STAR_SIZE = frame:GetUserConfig('STAR_SIZE');
    local pcJobInfo = mySession.pcJobInfo;
    local classLv = pcJobInfo:GetJobGrade(jobClassID);
    local startext = "";
	local maxIndex = 3;
	if jobCls.HiddenJob == 'YES' then
		maxIndex = 1;
	end
	for i = 1, maxIndex do
		if i <= classLv then
			startext = startext .. string.format("{img star_in_arrow %d %d}", STAR_SIZE, STAR_SIZE);
		else
		    startext = startext .. string.format("{img star_out_arrow %d %d}", STAR_SIZE, STAR_SIZE);
		end
	end
	jobStarText:SetText(startext);
    HEADSUPDISPLAY_SET_CAMP_BTN(frame);
end

function STAMINA_UPDATE(frame, msg, argStr, argNum)

	session.UpdateMaxStamina();

	local stGauge 	= GET_CHILD(frame, "sta1", "ui::CGauge");
	stGauge:ShowWindow(1)
	
	local stat 		= info.GetStat(session.GetMyHandle());
	stGauge:StopTimeProcess();
	local stamanaValue = stat.Stamina;

	if stamanaValue > 0 then
		stamanaValue = stamanaValue + 999;		-- ui에서 0인데 실제로는 아직 sta가 남아있어서 ui출력할때 999더해서 출력함. 1000으로하면 max보다 올라가므로 999로.
	end
        
	stGauge:SetPoint( math.floor(stamanaValue / 1000), stat.MaxStamina / 1000);	
    	
	local staRatio = stat.Stamina / stat.MaxStamina;
	if staRatio <= 0.3 and staRatio > 0 then
		stGauge:SetBlink(0.0, 1.0, 0xffffffff);
	else
		stGauge:ReleaseBlink();
	end
end

function CAUTION_DAMAGE_INFO(damage)
	local frame = ui.GetFrame('charbaseinfo');
	local hpGauge = frame:GetChild('hp');
	tolua.cast(hpGauge, 'ui::CGauge');

	hpGauge:SetCautionBlink(damage, 1.0, 0xffffffff);
end

function CAUTION_DAMAGE_INFO_RELEASE()
	local frame = ui.GetFrame('charbaseinfo');
	local hpGauge = frame:GetChild('hp');
	tolua.cast(hpGauge, 'ui::CGauge');

	hpGauge:ReleaseCautionBlink();
end

function HEADSUPDISPLAY_LBTN_UP(frame, msg, argStr, argNum)
    SET_CONFIG_HUD_OFFSET(frame);
end

function HUD_SET_SAVED_OFFSET(frame, msg, argStr, argNum)
    local savedX, savedY = GET_CONFIG_HUD_OFFSET(frame, frame:GetOriginalX(), frame:GetOriginalY());
    local _savedX, _savedY = GET_OFFSET_IN_SCREEN(savedX, savedY, frame:GetWidth(), frame:GetHeight());    
    _savedX = math.max(_savedX, frame:GetOriginalX());
    _savedY = math.max(_savedY, frame:GetOriginalY());    
    frame:SetOffset(_savedX, _savedY);    

    if savedX ~= _savedX or savedY ~= _savedY then
        SET_CONFIG_HUD_OFFSET(frame);
    end
end

function HEDADSUPDISPLAY_CAMP_BTN_CLICK(parent, ctrl)
	local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local count = list:Count();
    -- 파티원이 존재 할 때
	if 0 < count then
		local context = ui.CreateContextMenu("CONTEXT_PARTY", "", 0, 0, 170, 100);
		local campCount = 0;
		for i = 0 , count - 1 do
			local partyMemberInfo = list:Element(i);
			local map = GetClassByType("Map", partyMemberInfo.campMapID);
			if  nil ~= map then
				campCount = campCount +1;
			end
		end
		if 0 < campCount then
			local str =  string.format("{@st41b}%s(%d)", ClMsg("MoveToCampChar"), campCount);
			ui.AddContextMenuItem(context, str, "None");
		end

		for i = 0 , count - 1 do
			local partyMemberInfo = list:Element(i);
			if partyMemberInfo.campMapID ~= 0 then
				local map = GetClassByType("Map", partyMemberInfo.campMapID);
				if nil ~= map then
					local obj = GetIES(partyMemberInfo:GetObject());
					str = string.format("      {@st59s}{#FFFF00}%s {#FFFFFF}%s",obj.Name, map.Name);
					ui.AddContextMenuItem(context, str, string.format("MOVETOCAMP(\"%s\")", partyMemberInfo:GetAID()));
				end
			end
		end
		ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
		ui.OpenContextMenu(context);
		return;
	end

	local mapID = session.loginInfo.GetSquireMapID();
	local map = GetClassByType("Map", mapID);
	if nil == map then
		return;
	end
	
	local context = ui.CreateContextMenu("CONTEXT_PARTY", "", 0, 0, 170, 100);
	local str =  string.format("{@st41b}%s(1)", ClMsg("MoveToCampChar"));
	ui.AddContextMenuItem(context, str, "None");

	local obj = GetMyPCObject();
	str = string.format("      {@st59s}{#FFFF00}%s {#FFFFFF}%s",obj.Name, map.Name);
	ui.AddContextMenuItem(context, str, string.format("MOVETOCAMP(\"%s\")", session.loginInfo.GetAID()));
	ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
	ui.OpenContextMenu(context);
end

function HEADSUPDISPLAY_SET_CAMP_BTN(frame)
    local campBtn = frame:GetChild('campBtn');
    local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local count = list:Count();
    -- 파티원이 존재 할 때
	if 0 < count then
        local campCount = 0;
		for i = 0 , count - 1 do
			local partyMemberInfo = list:Element(i);
			local map = GetClassByType("Map", partyMemberInfo.campMapID);            
			if nil ~= map then
				campCount = campCount +1;
			end
		end
        if campCount > 0 then            
            campBtn:ShowWindow(1);
            return;
        end
    end
        
    local mapID = session.loginInfo.GetSquireMapID();    
	local map = GetClassByType("Map", mapID);
	if nil == map then
        campBtn:ShowWindow(0);
		return;
	end
    campBtn:ShowWindow(1);
end