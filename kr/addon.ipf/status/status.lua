g_reserve_reset = 0;
MAX_INV_COUNT = 4999;

function STATUS_ON_INIT(addon, frame)

	addon:RegisterMsg('PC_PROPERTY_UPDATE', 'STATUS_UPDATE');
	addon:RegisterOpenOnlyMsg('STAT_UPDATE', 'STATUS_UPDATE');
	addon:RegisterMsg('RESET_STAT_UP', 'RESERVE_RESET');
	addon:RegisterMsg('STAT_AVG', 'STATUS_ON_MSG');
	addon:RegisterOpenOnlyMsg('ACHIEVE_POINT', 'ACHIEVE_RESET');
	addon:RegisterOpenOnlyMsg('ACHIEVE_REWARD', 'ACHIEVE_RESET');
	addon:RegisterMsg("GAME_START", "STATUS_ON_GAME_START");
	addon:RegisterMsg("PC_COMMENT_CHANGE", "STATUS_ON_PC_COMMENT_CHANGE");
	addon:RegisterMsg("MYPC_CHANGE_SHAPE", "ACHIEVE_RESET");
	addon:RegisterMsg("JOB_CHANGE", "STATUS_JOB_CHANGE");
	addon:RegisterMsg("LIKEIT_WHO_LIKE_ME", "STATUS_INFO");
	addon:RegisterMsg("TOKEN_STATE", "TOKEN_ON_MSG");
	
	
	
	STATUS_INFO_VIEW(frame);
end

function UI_TOGGLE_STATUS()
	if app.IsBarrackMode() == true then
		return;
	end
	ui.ToggleFrame('status')
end

function STATUS_ON_GAME_START(frame)

	STATUS_ON_PC_COMMENT_CHANGE(frame);
	STATUS_JOB_CHANGE(frame);

end

function SHOW_TOKEN_REMAIN_TIME(ctrl)
	local elapsedSec = imcTime.GetAppTime() - ctrl:GetUserIValue("STARTSEC");
	local startSec = ctrl:GetUserIValue("REMAINSEC");
	startSec = startSec - elapsedSec;
	if 0 > startSec then
		ctrl:SetTextByKey("value", "");
		return 0;
	end
	local timeTxt = GET_TIME_TXT(startSec);
	ctrl:SetTextByKey("value", "{@st42}" .. timeTxt);
	return 1;
end

function TOKEN_ON_MSG(frame, msg, argStr, argNum)

	local logoutGBox = frame:GetChild("logoutGBox");
	local logoutInternal = logoutGBox:GetChild("logoutInternal");
	local gToken = logoutInternal:GetChild("gToken");
	local time = gToken:GetChild("time");
	time:ShowWindow(0);

	local tokenList = gToken:GetChild("tokenList");
	tokenList:RemoveAllChild();
	
	if argNum ~= ITEM_TOKEN or "NO" == argStr then
		return;
	end

	local sysTime = geTime.GetServerSystemTime();
	local endTime = session.loginInfo.GetTokenTime();
	local difSec = imcTime.GetDifSec(endTime, sysTime);
		
	if 0 < difSec then
		time:ShowWindow(1);
		time:SetUserValue("REMAINSEC", difSec);
		time:SetUserValue("STARTSEC", imcTime.GetAppTime());
		SHOW_TOKEN_REMAIN_TIME(time);
		time:RunUpdateScript("SHOW_TOKEN_REMAIN_TIME");
	else
		time:SetTextByKey("value", "");
		time:StopUpdateScript("SHOW_TOKEN_REMAIN_TIME");
	end

	for i = 0 , 3 do
		local ctrlSet = tokenList:CreateControlSet("tokenDetail", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local str, value = GetCashInfo(ITEM_TOKEN, i)
		if nil ~= str then
			local prop = ctrlSet:GetChild("prop");
			local normal = GetCashValue(0, str) 
			local txt = "None"
			if str == "marketSellCom" then
				normal = normal + 0.01;
				value = value + 0.01;
				local img = string.format("{img 67percent_image %d %d}",55, 45) 
				prop:SetTextByKey("value", img..ClMsg(str)); 
				txt = string.format("{img 67percent_image2 %d %d}", 100, 45) 
			elseif str =="abilityMax" then
				local img = string.format("{img paid_immed_image %d %d}", 55, 45) 
				prop:SetTextByKey("value", img..ClMsg(str)); 
				txt = string.format("{img 2plus_image2 %d %d}", 100, 45) 
			elseif str == "speedUp"then
				local img = string.format("{img 3plus_image %d %d}", 55, 45) 
				prop:SetTextByKey("value",img.. ClMsg(str)); 
				txt = string.format("{img 3plus_image2 %d %d}", 100, 45) 
			else
				local img = string.format("{img 9plus_image %d %d}", 55, 45) 
				prop:SetTextByKey("value", img..ClMsg(str)); 
				txt = string.format("{img 9plus_image2 %d %d}", 100, 45) 
			end

			local value = ctrlSet:GetChild("value");
			if str =="abilityMax" then
				value:ShowWindow(0);
			else
				value:SetTextByKey("value", txt); 
			end
		else
			return;
		end
	end

	local ctrlSet = tokenList:CreateControlSet("tokenDetail", "CTRLSET_" .. 5,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
	local prop = ctrlSet:GetChild("prop");
    local imag = string.format(STATUS_OVERRIDE_GET_IMGNAME1(), 55, 45) 
	prop:SetTextByKey("value", imag.. ScpArgMsg("Token_ExpUp{PER}", "PER", " ")); 
    local value = ctrlSet:GetChild("value");
	imag = string.format(STATUS_OVERRIDE_GET_IMGNAME2(), 100, 45) 
    value:SetTextByKey("value", imag);

	local itemClassID = session.loginInfo.GetPremiumStateArg(ITEM_TOKEN)
	local itemCls = GetClassByType("Item", itemClassID);
	if nil ~= itemCls and itemCls.NumberArg2 > 0 then
		local ctrlSet = tokenList:CreateControlSet("tokenDetail", "CTRLSET_" .. 6,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local prop = ctrlSet:GetChild("prop");
		local img = string.format("{img dealok_image %d %d}", 55, 45) 
		prop:SetTextByKey("value", img .. ScpArgMsg("AllowTradeByCount"));

		local value = ctrlSet:GetChild("value");
		img = string.format("{img dealok30_image2 %d %d}", 100, 45) 
		value:SetTextByKey("value", img);
	end
	
	local ctrlSet = tokenList:CreateControlSet("tokenDetail", "CTRLSET_" .. 7,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img 1plus_image %d %d}", 55, 45) 
    prop:SetTextByKey("value", imag..ClMsg("CanGetMoreBuff")); 
    local value = ctrlSet:GetChild("value");
    value:ShowWindow(0);

	local ctrlSet = tokenList:CreateControlSet("tokenDetail", "CTRLSET_" .. 8,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
    local prop = ctrlSet:GetChild("prop");
    local imag = string.format("{img paid_pose_image %d %d}", 55, 45) 
    prop:SetTextByKey("value", imag..ClMsg("AllowPremiumPose")); 
    local value = ctrlSet:GetChild("value");
    value:ShowWindow(0);

	STATUS_OVERRIDE_NEWCONTROLSET1(tokenList)
	
	GBOX_AUTO_ALIGN(tokenList, 0, 0, 0, false, true);
end

function STATUS_OVERRIDE_NEWCONTROLSET1(tokenList)
	--do Nothing(override)
end

function STATUS_OVERRIDE_GET_IMGNAME1()
	return "{img 20percent_image %d %d}"
end

function STATUS_OVERRIDE_GET_IMGNAME2()
	return "{img 20percent_image2 %d %d}"
end


function STATUS_ON_PC_COMMENT_CHANGE(frame)

	local socialInfo = session.social.GetMySocialInfo();
	local logoutGBox = frame:GetChild("logoutGBox");
	local logoutInternal = logoutGBox:GetChild("logoutInternal");
	local pccomment = logoutInternal:GetChild("pccomment");
	pccomment:SetTextByKey("value", socialInfo:GetPCComment(PC_COMMENT_TITLE));
end

function REQ_CHANGE_PC_COMMENT(parent, ctrl)

	local socialInfo = session.social.GetMySocialInfo();
	local curComment = socialInfo:GetPCComment(PC_COMMENT_TITLE);
	local frame = parent:GetTopParentFrame();
	INPUT_STRING_BOX_CB(frame, ScpArgMsg("InputWelcomeComment"), "EXEC_CHANGE_PC_COMMENT", curComment, nil, nil, GetMaxCommentLen());

end

function EXEC_CHANGE_PC_COMMENT(frame, comment)
	packet.SendChangePCComment(PC_COMMENT_TITLE, comment);
end

function STATUS_ON_MSG(frame, msg, argStr, argNum)
	if msg == 'INV_ITEM_ADD' then
		STATUS_EMPTY_EQUIP_SET(frame, argNum);
	elseif msg == 'STAT_AVG' then
		STATUS_AVG(frame);
	end
end

function STATUS_EMPTY_EQUIP_SET(frame, argNum)
	local invItem = session.GetInvItem(argNum);
	if invItem ~= nil then
		local itemobj = GetIES(invItem:GetObject());
		local child = frame:GetChild(itemobj.EqpType);
		if child ~= nil then
			local slot = tolua.cast(child, 'ui::CSlot');
			if slot:GetIcon() == nil then
				ITEM_EQUIP(argNum);
			end
		end
	end
end

function STATUS_ONLOAD(frame, obj, argStr, argNum)

	STAT_RESET(frame);
	ACHIEVE_RESET(frame);

	STATUS_TAB_CHANGE(frame);
	STATUS_INFO();

	--local invenFrame = ui.GetFrame('inventory');
	--invenFrame:ShowWindow(1);
end

function STATUS_CLOSE(frame, obj, argStr, argNum)
	local shopFrame = ui.GetFrame('shop');
	--if shopFrame:IsVisible() ~= 1 then
	--	local invenFrame = ui.GetFrame('inventory');
	--	invenFrame:ShowWindow(0);
	--end

	--ui.CloseMsgBoxByBalloon(ClMsg("REALLY_EXECUTE_STAT_BY_POINT"));
end

function COMMIT_STAT(frame)
	--ui.MsgBoxByBalloon(ClMsg("REALLY_EXECUTE_STAT_BY_POINT"), "EXEC_COMMIT_STAT", "None");
	EXEC_COMMIT_STAT(frame);
end

function EXEC_COMMIT_STAT(frame)

	local TxArgString = "";
	
	for i = 0 , STAT_COUNT - 1 do
		local typeStr = GetStatTypeStr(i);
		TxArgString = TxArgString .. string.format("%d", session.GetUserConfig(typeStr .. "_UP"));
		if i ~= STAT_COUNT - 1 then
			TxArgString = TxArgString .. " ";
		end
	end
	

	pc.ReqExecuteTx_NumArgs("SCR_TX_STAT_UP", TxArgString);

	imcSound.PlaySoundEvent('button_click_stats_up');

end

function ROLLBACK_STAT(frame)
	frame = frame:GetTopParentFrame();
	STAT_RESET(frame)
end

function STATUS_UPDATE(frame)

	if g_reserve_reset == 1 then
		STAT_RESET(frame, 1);
		g_reserve_reset = 0;
	else
		DebounceScript("STATUS_INFO", 0.1);
	end
	STATUS_INFO();
end

function RESERVE_RESET(frame)
	g_reserve_reset = 1;
end

function STAT_RESET(frame, update)

	local changed = update;

	for i = 0 , STAT_COUNT - 1 do
		local typeStr = GetStatTypeStr(i);
		if 1 == session.SetUserConfig(typeStr.. "_UP", 0) then
			changed = 1;
		end
	end

	if changed == 1 then
		STATUS_INFO();
	end
end

function ACHIEVE_RESET(frame)
	STATUS_ACHIEVE_INIT(frame);
end

function SET_STAT_TEXT(frame, ctrlname, pc, propname, addprop, consumed, vpc, xpos, ypos, totalValue, argValue)

	local configName = propname .. "_UP";
	local statup = session.GetUserConfig(configName);
	local add = pc[addprop];
	local total = pc[propname];

	local value = (total + statup) / totalValue;
	local percValue = math.floor(value * 100);
	local addYpos = percValue - 25;
	local buttonPos = ypos;
	ypos = ypos - addYpos;

	local gboxctrl = frame:GetChild('statusUpGbox');
	local statusUpControlSet = gboxctrl:CreateOrGetControlSet('statusinfo', ctrlname, xpos, ypos);
	tolua.cast(statusUpControlSet, "ui::CControlSet");

	local bgPic = GET_CHILD(statusUpControlSet, "bgPic", "ui::CPicture");
	bgPic:SetImage(propname..'_slot');


	local name = GET_CHILD(statusUpControlSet, "name", "ui::CRichText");
	name:SetText('{@st66b}{s18}'..ClMsg(propname));

	local onepic = GET_CHILD(statusUpControlSet, "one", "ui::CPicture");
	local tenpic = GET_CHILD(statusUpControlSet, "ten", "ui::CPicture");
	local hunpic = GET_CHILD(statusUpControlSet, "hun", "ui::CPicture");
	local thopic = GET_CHILD(statusUpControlSet, "tho", "ui::CPicture");

	onepic:ShowWindow(0);
	tenpic:ShowWindow(0);
	hunpic:ShowWindow(0);
	thopic:ShowWindow(0);

	local statupValue = total + statup;

	if statupValue >= 1000 then
		local one = statupValue % 10;
		local ten = math.floor(statupValue%100 / 10);
		local hun = math.floor(statupValue%1000 / 100);
		local tho = math.floor(statupValue / 1000);

		onepic:SetImage(tostring(one));
		onepic:ShowWindow(1);
		onepic:SetOffset(30, 115);
		tenpic:SetImage(tostring(ten));
		tenpic:ShowWindow(1);
		tenpic:SetOffset(10, 115);
		hunpic:SetImage(tostring(hun));
		hunpic:ShowWindow(1);
		hunpic:SetOffset(-10, 115);
		thopic:SetImage(tostring(tho));
		thopic:ShowWindow(1);
		thopic:SetOffset(-30, 115);
	elseif statupValue >= 100 then
		local one = statupValue % 10;
		local ten = math.floor(statupValue%100 / 10);
		local hun = math.floor(statupValue%1000 / 100);

		onepic:SetImage(tostring(one));
		onepic:ShowWindow(1);
		onepic:SetOffset(20, 115);
		tenpic:SetImage(tostring(ten));
		tenpic:ShowWindow(1);
		tenpic:SetOffset(0, 115);
		hunpic:SetImage(tostring(hun));
		hunpic:ShowWindow(1);
		hunpic:SetOffset(-20, 115);

	elseif statupValue >= 10 then
		local one = statupValue % 10;
		local ten = math.floor(statupValue / 10);

		onepic:SetImage(tostring(one));
		onepic:ShowWindow(1);
		onepic:SetOffset(15, 115);
		tenpic:SetImage(tostring(ten));
		tenpic:ShowWindow(1);
		tenpic:SetOffset(-12, 115);
	else

		onepic:SetImage(tostring(statupValue));
		onepic:ShowWindow(1);
		onepic:SetOffset(0, 115);
	end

	local btnUp = GET_CHILD(statusUpControlSet, "upbtn", "ui::CButton");
	if ctrlname == "STR" then
	    name:EnableHitTest(1);
        name:SetTextTooltip(ScpArgMsg("Auto_{@st59}KongKyeogLyeoge_yeongHyangeul_Jum{/}"));
        btnUp:SetTextTooltip(ScpArgMsg("Auto_{@st59}KongKyeogLyeogeul_JeungKa_SiKinDa{/}"));
	elseif ctrlname == "CON" then
	    name:EnableHitTest(1);
        name:SetTextTooltip(ScpArgMsg("Auto_{@st59}ChoeDae_HPe_yeongHyangeul_Jum{/}"));
        btnUp:SetTextTooltip(ScpArgMsg("Auto_{@st59}ChoeDae_HPLeul_JeungKa_SiKinDa{/}"));
	elseif ctrlname == "INT" then
	    name:EnableHitTest(1);
        name:SetTextTooltip(ScpArgMsg("Auto_{@st59}ChoeDae_SPe_yeongHyangeul_Jum{/}"));
        btnUp:SetTextTooltip(ScpArgMsg("Auto_{@st59}ChoeDae_SPLeul_JeungKa_SiKinDa{/}"));
    elseif ctrlname == "MNA" then
	    name:EnableHitTest(1);
        name:SetTextTooltip(ScpArgMsg("MNA_UI_MSG1"));
        btnUp:SetTextTooltip(ScpArgMsg("MNA_UI_MSG2"));
	elseif ctrlname == "DEX" then
	    name:EnableHitTest(1);
        name:SetTextTooltip(ScpArgMsg("Auto_{@st59}ChiMyeongTa_Mich_HoePie_yeongHyangeul_Jum{/}"));
        btnUp:SetTextTooltip(ScpArgMsg("Auto_{@st59}ChiMyeongTa_Mich_HoePiLeul_JeungKa_SiKinDa{/}"));
	end
	btnUp:SetEventScript(ui.LBUTTONUP, "REQ_STAT_UP");
	btnUp:SetEventScriptArgString(ui.LBUTTONUP, propname);
	btnUp:SetClickSound("button_click_stats");

	btnUp:SetEventScript(ui.RBUTTONUP, "OPERATOR_REQ_STAT_UP");
	btnUp:SetEventScriptArgString(ui.RBUTTONUP, propname);

	if statup > 0 then
		if vpc == nil then
			vpc = CloneIES_UseCP(pc);
		end

		local statpropname = propname .. "_STAT";
		vpc[statpropname] = vpc[statpropname] + statup;
	end

	return consumed + statup, vpc;
end


function REQ_STAT_UP(frame, control, argstr, argnum)

	if GET_REMAIN_STAT_PTS() <= 0 then
		return;
	end

	local configName = argstr .. "_UP";
	local curstat = session.GetUserConfig(configName);
	

	session.SetUserConfig(configName, curstat + 1);
	frame = frame:GetTopParentFrame();
	STATUS_INFO();
end

function OPERATOR_REQ_STAT_UP(frame, control, argstr, argnum)

	if GET_REMAIN_STAT_PTS() <= 0 then
		return;
	end

	local configName = argstr .. "_UP";
	local curstat = session.GetUserConfig(configName);
	local bonusstat = GET_REMAIN_STAT_PTS();
	local increase = 10;
	local remainder = 0;

	if curstat + increase > bonusstat or increase > bonusstat then 
		remainder = bonusstat - (curstat + increase);
	end

	if 0 > remainder then
		remainder = 0;
		increase = bonusstat;
	end
	session.SetUserConfig(configName, curstat + increase + remainder);
	frame = frame:GetTopParentFrame();
	STATUS_INFO();
end

function GET_REMAIN_STAT_PTS()

	local pc = GetMyPCObject();
    local consumed = 0;
	for i = 0 , STAT_COUNT - 1 do
		local typeStr = GetStatTypeStr(i);
		consumed = consumed + session.GetUserConfig(typeStr .. "_UP");
	end
    
	local bonusstat = GET_STAT_POINT(pc) - consumed;
	return bonusstat;
end

function UPDATE_STATUS_STAT(frame, gboxctrl, pc)

	local vpc = nil;

	local consumed = 0;
	local totalValue = 0;
	for i = 0 , STAT_COUNT - 1 do
		local typeStr = GetStatTypeStr(i);
		totalValue = totalValue + pc[typeStr] + session.GetUserConfig(typeStr .. "_UP");
	end

	for i = 0 , STAT_COUNT - 1 do
		local typeStr = GetStatTypeStr(i);
		local x = tonumber(frame:GetUserConfig("StatIconStartX")) + i * 85;
		local avg = session.GetStatAvg(i) + pc[typeStr];
		consumed, vpc = SET_STAT_TEXT(frame, typeStr, pc, typeStr, typeStr .. "_ADD", consumed, vpc, x, 60, totalValue, avg);
	end


	local statusupGbox = frame:GetChild('statusUpGbox');
	local bonusstat = GET_STAT_POINT(pc);
	local title_RemainStat = GET_CHILD(statusupGbox, "Title_RemainStat", "ui::CRichText");
	if bonusstat <= 0 and consumed == 0 then
		title_RemainStat:ShowWindow(0);
	else
		title_RemainStat:SetTextByKey("statpts", bonusstat - consumed);
		title_RemainStat:ShowWindow(1);
	end

	if bonusstat - consumed > 0 then
		for i = 0 , STAT_COUNT - 1 do
			local typeStr = GetStatTypeStr(i);
			STATUS_BTN_UP_VISIBLE(frame, typeStr, pc, 1);
		end
    else
		for i = 0 , STAT_COUNT - 1 do
			local typeStr = GetStatTypeStr(i);
			STATUS_BTN_UP_VISIBLE(frame, typeStr, pc, 0);
		end
    end
    if consumed > 0 then
		statusupGbox:GetChild("COMMIT"):ShowWindow(1);
		statusupGbox:GetChild("CANCEL"):ShowWindow(1);
    else
		statusupGbox:GetChild("COMMIT"):ShowWindow(0);
		statusupGbox:GetChild("CANCEL"):ShowWindow(0);
    end

    return vpc;

end

function STATUS_BTN_UP_VISIBLE(frame, controlsetName, pc, visible)
	local gboxctrl = frame:GetChild('statusUpGbox');
	local statusUpControlSet = GET_CHILD(gboxctrl, controlsetName, "ui::CControlSet");

	local statName = controlsetName;
	if pc[statName] + session.GetUserConfig(statName.."_UP") >= 9999 then
		visible = 0;
	end

	local btnUp = GET_CHILD(statusUpControlSet, "upbtn", "ui::CPicture");
	btnUp:ShowWindow(visible);
end

function GET_ONLINE_PARTY_MEMBER_N_ADDEXP()
	local pcparty = session.party.GetPartyInfo();
	if pcparty == nil then
		return 0, 0;	
	end

	local partyInfo = pcparty.info;
	local obj = GetIES(pcparty:GetObject());
	local list = session.party.GetPartyMemberList(PARTY_NORMAL);
	local count = list:Count();
	local memberIndex = 0;
	local addValue = 0;
	local matchCount = 0;
	local jobNumList = {};
	jobNumList['Warrior'] = 0;
	jobNumList['Wizard'] = 0;
	jobNumList['Archer'] = 0;
	jobNumList['Cleric'] = 0;
		
	local myAid = session.loginInfo.GetAID();
	for i = 0 , count - 1 do
		local partyMemberInfo = list:Element(i)
		if geMapTable.GetMapName(partyMemberInfo:GetMapID()) ~= 'None' then			
			local stat = partyMemberInfo:GetInst();
			local pos = stat:GetPos();
			local myHandle		= session.GetMyHandle();
			local dist = info.GetDestPosDistance(pos.x, pos.y, pos.z, myHandle);
			local sharedcls = GetClass("SharedConst",'PARTY_SHARE_RANGE');

			local mymapname = session.GetMapName();
			local partymembermapName = GetClassByType("Map", partyMemberInfo:GetMapID()).ClassName;			
						
			if dist < sharedcls.Value and mymapname == partymembermapName then
				memberIndex = memberIndex + 1;
								
				local iconinfo = partyMemberInfo:GetIconInfo();
				local jobCls  = GetClassByType("Job", iconinfo.job);	
				jobNumList[jobCls.CtrlType] = jobNumList[jobCls.CtrlType] + 1;		
			end		
		end
	end	

	if memberIndex >= 3 then
		matchCount = jobNumList['Warrior']
		if matchCount < 3 then
			matchCount = jobNumList['Wizard']
			if matchCount < 3 then
				matchCount = jobNumList['Archer']
				if matchCount < 3 then
					matchCount = jobNumList['Cleric']
				end
			end
		end
		local tempStr = "";
		SWITCH(math.floor(matchCount)) {				
			[3] = function() tempStr = "PARTY_EXP_JOB_BALANCE_BONUS_COUNT_THREE"; end,
			[4] = function() tempStr = "PARTY_EXP_JOB_BALANCE_BONUS_COUNT_FOUR"; end,	
			default = function() end,
			}	
		
		if string.len(tempStr) > 0 then
			local cls = GetClass("SharedConst",tempStr);
			local val = cls.Value;	
			if val ~= nil then
				addValue = val;
			end	
		end
	end

	return memberIndex, addValue;
end

function SETEXP_SLOT_PARTY(expupBuffBox, addValue, index, entireSum)	
		local cls = GetClass("SharedConst","PARTY_EXP_BONUS");
		local percSum = sum;
		local val = cls.Value;
		if val ~= nil then
			local sum = val + addValue;
			local class  = GetClassByType('Buff', 4542);
			percSum = SETSLOTCTRL_EXP(class, class.Icon, expupBuffBox, index, entireSum, sum * 100);
			return true, percSum;
		end
		return false, percSum;
end

function SETEXP_SLOT(gbox)
	local expupBuffBox = gbox:GetChild('expupBuffBox');	
	DESTROY_CHILD_BYNAME(expupBuffBox, "expBuffslot_");			--EXP_Rate
	
	-- s_buff_ui : cf) buff.lua 
	local slotlist = s_buff_ui["slotlist"][1];
	local slotcount = s_buff_ui["slotcount"][1];
	local captionlist = s_buff_ui["captionlist"][1];
    
	local index = 0;
	local percSum = 0;
	
	--[[
	if IS_SEASON_SERVER(nil) == "YES" then
		local cls1 = GetClass("SharedConst","JAEDDURY_MON_EXP_RATE");
		local val1 = cls1.Value;
	if val1 ~= nil then
	if val1 > 0.0 then
		local class  = GetClassByType('Buff', 4540);	
		percSum = SETSLOTCTRL_EXP(class, class.Icon, expupBuffBox, index, percSum, val1 * 100);
		index = index + 1;
		end
	end
	end
	]]--

	if 1 == session.loginInfo.GetPremiumState() then	
		local cls2 = GetClass("SharedConst","JAEDDURY_NEXON_PC_EXP_RATE");
		local val2 = cls2.Value;	
		if val2 ~= nil then
	if val2 > 0.0 then
		local class  = GetClassByType('Buff', 4541);	
		percSum = SETSLOTCTRL_EXP(class, class.Icon, expupBuffBox, index, percSum, val2 * 100);
		index = index + 1;
			end
	end
	end
	
		--[[
	--일반 파티 경험치 계산
	local retParty = false;
	local partyMember, addValue1 =	GET_ONLINE_PARTY_MEMBER_N_ADDEXP();	
	SWITCH(math.floor(partyMember)) {				
		[0] = function() end,
		[1] = function() end,	
		[4] = function() -- 4인 260 -> 280
			local addValue2 = 0;
			local cls = GetClass("SharedConst","PARTY_EXP_BONUS_MEMBER_COUNT_FOUR");
			local val = cls.Value;	
			if val ~= nil then
				addValue2 = val;
			end	
			retParty, percSum = SETEXP_SLOT_PARTY(expupBuffBox, addValue2 + addValue1, index, percSum);
		end,
		[5] = function() -- 5인 300 -> 350
			local addValue2 = 0;
			local cls = GetClass("SharedConst","PARTY_EXP_BONUS_MEMBER_COUNT_FIVE");
			local val = cls.Value;	
			if val ~= nil then
				addValue2 = val;
			end	
			retParty, percSum = SETEXP_SLOT_PARTY(expupBuffBox, addValue2 + addValue1, index, percSum);
		end,
		default = function() --		1인 100. 2인 180, 3인 220
			retParty, percSum = SETEXP_SLOT_PARTY(expupBuffBox, addValue1, index, percSum);
		end,
		}	
	if retParty == true then
		index = index + 1;
	end
	]]--
	if slotcount ~= nil and slotcount >= 0 then
    	for i = 0, slotcount - 1 do
    		local slot		= slotlist[i];
			local icon		= slot:GetIcon();
			local info		= icon:GetInfo();
			local type		= info.type;
			if type ~= 0 then
				local class  = GetClassByType('Buff', type);	
				if class ~= nil then
					local exp = TryGetProp(class, "BuffExpUP");
					if nil == exp then
						exp = 0;
					else
						exp = tonumber(exp);
					end

					if exp > 0.0 then
						percSum = SETSLOTCTRL_EXP(class, class.Icon, expupBuffBox, index, percSum, exp * 100);
						index = index + 1;					
					else
						SWITCH(class.ClassName) {				
						['TeamLevel'] = function() 
							local account = session.barrack.GetCurrentAccount();
							if account ~= nil then
								local lv = account:GetTeamLevel();
									local expT = account:GetTeamLevel() - 1;
									if expT > 0.0 then
										percSum = SETSLOTCTRL_EXP(class, "teamexpup", expupBuffBox, index, percSum, expT);
										index = index + 1;
									end
								end	
						end,
						--[[
						['PartyIndunExpBuff'] = function() 
										local cls = GetClass("SharedConst","INDUN_AUTO_FIND_EXP_BONUS");
										local val = cls.Value;
										if val > 0.0 then
											if partyMember > 1 then
												percSum = SETSLOTCTRL_EXP(class, "cler_daino", expupBuffBox, index, percSum, val * 100);
										index = index + 1;
											end
										end
						end,
						]]--
						default = function() end,
						}	
					end
				end
			end
    	end
    end
			
	local expupTextBox = gbox:GetChild('expupTextBox');	
	local expUP_Dyn = expupTextBox:GetChild('expUP_Dyn');	
		
	expUP_Dyn:SetTextByKey("perc", math.floor(percSum));
	
	expupTextBox:Invalidate();	
end

function SETSLOTCTRL_EXP(cls, strIcon, parent, index, sum, perc)
	local slotbox = parent:CreateOrGetControl('groupbox', 'expBuffslot_'.. cls.ClassID, 42, 70, ui.LEFT, ui.TOP, 42 * index, 0, 0, 0);												
	tolua.cast(slotbox, "ui::CGroupBox");	
	slotbox:EnableDrawFrame(0);

	local newslot = slotbox:CreateOrGetControl('slot', 'slotExp_'..index, 42, 42, ui.LEFT, ui.TOP, 0, 0, 0, 0);	
	tolua.cast(newslot, "ui::CSlot");	
	if cls ~= nil then
		newslot:SetEventScriptArgNumber(ui.RBUTTONUP, cls.ClassID);
	end
	newslot:EnableDrop(0);
	newslot:EnableDrag(0);
	newslot:ClearIcon();
	local newicon = newslot:GetIcon();			
	if newicon == nil then		
		newicon = CreateIcon(newslot);
	end;	
	
	if cls ~= nil then
		local handle = session.GetMyHandle();
		if cls.ClassName == "Premium_Nexon" or cls.ClassName =="Premium_Token" then
			local buff = info.GetBuff(tonumber(handle), cls.ClassID);
			if nil ~= buff then
				newicon:SetTooltipType('premium');		
				newicon:SetTooltipArg(handle, cls.ClassID, buff.arg1);
				newicon:SetTooltipOverlap(1);
			end
		else
			newicon:SetTooltipType('buff');
			newicon:SetTooltipArg(handle, cls.ClassID, "");
			newicon:SetTooltipOverlap(1);
		end
	end
	
	local imageName = strIcon;
	if imageName ~= nil then
		newicon:SetImage('icon_' .. strIcon);
	end;

	local percText = slotbox:CreateOrGetControl('richtext', 'staticExptext_'..index, 10, 10, ui.CENTER_HORZ, ui.TOP, 0, 42, 0, 0);	
	tolua.cast(percText, "ui::CRichText");
	
	local strCaption = string.format("{s13}%d", math.floor(perc));
	strCaption = strCaption .. "%{/}";		
	percText:SetFontName("white_18_ol");
	percText:SetText(strCaption);
	return sum + perc;
end

function STATUS_INFO()
	local frame = ui.GetFrame('status');
	local MySession		= session.GetMyHandle()
	local CharName		= info.GetName(MySession);
--	local CharProperty	= GetProperty(MySession);

	local NameObj	= GET_CHILD(frame, "NameText", "ui::CRichText");
    local LevJobObj = GET_CHILD(frame, "LevJobText", "ui::CRichText");

    local lv = info.GetLevel(session.GetMyHandle());
    local job = info.GetJob(session.GetMyHandle());
    local gender = info.GetGender(session.GetMyHandle());
    local jobCls = GetClassByType("Job", job);
	local jName = GET_JOB_NAME(jobCls, gender);	
	
	local lvText = jName;

	NameObj:SetText('{@st53}'..CharName)
    LevJobObj:SetText('{@st41}{s20}'..lvText)

	local pc = GetMyPCObject();
	local opc = nil;
	local gboxctrl2 = frame:GetChild('statusGbox');
	local gboxctrl = GET_CHILD(gboxctrl2,'internalstatusBox');
	local vpc = UPDATE_STATUS_STAT(frame, gboxctrl, pc);
	if vpc ~= nil then
		opc = pc;
		pc = vpc;
	end
	local y = 0;

	y = y + 10;

	local expupGBox = GET_CHILD(gboxctrl,'expupGBox');
	SETEXP_SLOT(expupGBox);
	y = y + expupGBox:GetHeight() + 10;

	local returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "MHP", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "MSP", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "RHP", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "RSP", y);
	y = returnY + 24;

	returnY = STATUS_ATTRIBUTE_VALUE_RANGE_NEW(pc, opc, frame, gboxctrl, "PATK", "MINPATK", "MAXPATK", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_RANGE_NEW(pc, opc, frame, gboxctrl, "PATK_SUB", "MINPATK_SUB", "MAXPATK_SUB", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_RANGE_NEW(pc, opc, frame, gboxctrl, "MATK", "MINMATK", "MAXMATK", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "SR", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "HR", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "MHR", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "BLK_BREAK", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "CRTATK", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "CRTHR", y);
	y = returnY + 10;
	
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "DEF", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "MDEF", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "SDR", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "DR", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "BLK", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "CRTDR", y);
	y = returnY + 10;
	
	returnY = STATUS_ATTRIBUTE_VALUE_DIVISIONBYTHOUSAND_NEW(pc, opc, frame, gboxctrl, "MaxSta", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "MSPD", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "MaxWeight", y);
	y = returnY + 10;
	
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Fire_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Ice_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Lightning_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Soul_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Earth_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Poison_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Holy_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Dark_Atk", y);
	y = returnY + 10;
	
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "ResFire", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "ResIce", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "ResLightning", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "ResSoul", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "ResEarth", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "ResSoul", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "ResPoison", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "ResHoly", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "ResDark", y);
	y = returnY + 10;
	
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "DefAries", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "DefSlash", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "DefStrike", y);
	y = returnY + 10;
	
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "SmallSize_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "MiddleSize_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "LargeSize_Atk", y);
	y = returnY + 10;
	
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Cloth_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Leather_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Iron_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Ghost_Atk", y);
	y = returnY + 10;
	
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Forester_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Widling_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Klaida_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Paramune_Atk", y);
	if returnY ~= y then
		y = returnY + 3;
	end
	returnY = STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, "Velnias_Atk", y);
	y = returnY + 10;
	
        --STATUS_ATTRIBUTE_VALUE_RANGE(pc, opc, frame, gboxctrl, "PATK", "MINPATK", "MAXPATK");
	--STATUS_ATTRIBUTE_VALUE_RANGE(pc, opc, frame, gboxctrl, "MATK", "MINMATK", "MAXMATK");
	--STATUS_ATTR_SET_PERCENT(pc, opc, frame, gboxctrl, "CRTHR");
	--STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "CRTHR");
	--STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "SR");
	--STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "HR");
	--STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "Fire_Atk");
	--STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "Ice_Atk");
	--STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "Lightning_Atk");
	--STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "Poison_Atk");
	--STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "Holy_Atk");
	--STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "Dark_Atk");



        --STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "DEF");
	STATUS_ATTR_SET_PERCENT(pc, opc, frame, gboxctrl, "BLK");
	STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "CRTDR");
	STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "SDR");
	STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "DR");
	STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "ResFire");
	STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "ResIce");
	STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "ResLightning");
	STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "ResSoul");
	STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "ResPoison");
	STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "ResHoly");
	STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, "ResDark");
	y = y + 10;

	gboxctrl:SetScrollPos(0)
	frame:Invalidate();

	if vpc ~= nil then
		DestroyIES(vpc);
	end

	local loceCountText = GET_CHILD_RECURSIVELY(frame, "loceCountText")
	loceCountText:SetTextByKey("Count",session.likeit.GetWhoLikeMeCount());

end

function STATUS_TEXT_SET(textStr)
	local findStart, findEnd = string.find(textStr, '.');

	if findStart == nil then
		return textStr;
	end

	local intStr = string.sub(textStr, 1, findStart+1);
	local subStr = string.sub(textStr, findEnd+2, string.len(textStr) - 1);
	return string.format("%s{s14}{#cccccc}%s{/}{/}%s", intStr, subStr,"%");
end

function STATUS_SLOT_RBTNDOWN(frame, slot, argStr, equipSpot)
	if true == BEING_TRADING_STATE() then
		return;
	end

	local isEmptySlot = false;

	local invItemList = session.GetInvItemList();
	local index = invItemList:Head();
	local itemCount = session.GetInvItemList():Count();
	
	if session.GetInvItemList():Count() < MAX_INV_COUNT then
		isEmptySlot = true;
	end
	
	if isEmptySlot == true then
		imcSound.PlaySoundEvent('inven_unequip');
		local spot = equipSpot;
		item.UnEquip(spot);
	else
		ui.SysMsg(ScpArgMsg("Auto_inBenToLie_Bin_SeulLosi_PilyoHapNiDa."));

	end
end

function CHECK_EQP_LBTN(frame, slot, argStr, argNum)

	local targetItem = item.HaveTargetItem();

	if targetItem == 1 then
		local luminItemIndex = item.GetTargetItem();

		local luminItem = session.GetInvItem(luminItemIndex);
		if luminItem ~= nil then
			local itemobj = GetIES(luminItem:GetObject());

			if itemobj.GroupName == 'Gem' then
				if itemobj.Usable == 'ITEMTARGET' then
					
					SCR_GEM_ITEM_SELECT(argNum, luminItem, 'status');
					return;
				end
			end
		end
	end

	tolua.cast(slot, 'ui::CSlot');
	local toicon = slot:GetIcon();
	if toicon == nil then
		return;
	end

	local iesID = toicon:GetTooltipIESID();
	local curLBtn = frame:GetUserValue("LBTN_SCP");
	if curLBtn ~= "None" then
		local invitem = GET_ITEM_BY_GUID(iesID, 1);
		if invitem ~= nil then
			local func = _G[curLBtn];
			func(frame, invitem, slot);
			return;
		end
	end


	if keyboard.IsPressed(KEY_CTRL) == 1 then
		local invitem = GET_ITEM_BY_GUID(iesID, 1);
		LINK_ITEM_TEXT(invitem);
		return;
	end


	local exchangeFrame = ui.GetFrame('exchange');
	exchangeFrame:SetUserValue('CLICK_EQUIP_INV_ITEM', 'NO')
	if exchangeFrame:IsVisible() == 1 then
		exchangeFrame:SetUserValue('CLICK_EQUIP_INV_ITEM', 'YES')
	end



	local fromID = GET_USING_ITEM_GUID();
	if fromID ~= 0 then
		SCR_MAGICAMULET_EQUIP(item.GetUsingItem(),GET_ITEM_BY_GUID(iesID, 1));
	end

end

function GET_USING_ITEM_GUID()

	local fromItem = item.GetUsingItem();
	if fromItem == nil then
		return "0";
	end

	return fromItem:GetIESID();

end

function GET_USING_ITEM_OBJ()

	local fromItem = item.GetUsingItem();
	if fromItem == nil then
		return nil;
	end

	return GetIES(fromItem:GetObject());

end

function SET_VALUE_ZERO(value)
	if value == 0 then
		return 1, '0';
	else
		return 0, value;
	end
end

function STATUS_ATTR_SET_PERCENT(pc, opc, frame, gboxctrl, attibuteName)
	local txtctrl_CRTHR = gboxctrl:GetChild(attibuteName);
	if txtctrl_CRTHR ~= nil then
		local textValue = STATUS_TEXT_SET(string.format("%.2f%%", pc[attibuteName] / 100));
		if opc ~= nil and opc[attibuteName] ~= pc[attibuteName] then
			local colStr = frame:GetUserConfig("ADD_STAT_COLOR")
			txtctrl_CRTHR:SetText(colStr .. textValue);
		else
			txtctrl_CRTHR:SetText(textValue);
		end
	end
end

function STATUS_ATTRIBUTE_VALUE_RANGE(pc, opc, frame, gboxctrl, attibuteName, minName, maxName)
	local txtctrl = GET_CHILD(gboxctrl, attibuteName, 'ui::CRichText');
	if txtctrl == nil then
		return;
	end

	local minVal = pc[minName];
	local maxVal = pc[maxName];

	if pc ~= nil and pc.ATK_COMMON_BM > 0 then
		minVal = minVal + pc.ATK_COMMON_BM;
		maxVal = maxVal + pc.ATK_COMMON_BM;
	end

	local grayStyle;
	local value;
	if maxVal == 0 then
		grayStyle = 1;
		value = 0;
	else
		grayStyle = 0;

		if attibuteName == "ATK" and item.IsUseJungtanRank() > 0 then
			value = string.format("%d~%d(+%d)", minVal, maxVal, item.GetJungtanDamage());
		else
			value = string.format("%d~%d", minVal, maxVal);
		end
	end

	if opc ~= nil and opc[maxName] ~= maxVal then
		local colBefore = frame:GetUserConfig("BEFORE_STAT_COLOR");
		local colStr = frame:GetUserConfig("ADD_STAT_COLOR")


		local beforeValue = value;
		if attibuteName == "ATK" and item.IsUseJungtanRank() > 0 then
			beforeValue = string.format("%d~%d(+%d)", opc[minName], opc[maxName], item.GetJungtanDamage());
		else
			beforeValue = string.format("%d~%d", opc[minName], opc[maxName]);
		end

		if beforeValue ~= value then
			txtctrl:SetText(colBefore.. beforeValue..ScpArgMsg("Auto_{/}__{/}")..colStr .. value);
		else
			txtctrl:SetText(value);
		end
	else
		txtctrl:SetText(value);
	end
end

function STATUS_ATTRIBUTE_VALUE_RANGE_NEW(pc, opc, frame, gboxctrl, attibuteName, minName, maxName, y)
	local controlSet = gboxctrl:CreateOrGetControlSet('status_stat', attibuteName, 0, y);
	tolua.cast(controlSet, "ui::CControlSet");
		
	local title = GET_CHILD(controlSet, "title", "ui::CRichText");
	title:SetText(ScpArgMsg(attibuteName));

	local stat = GET_CHILD(controlSet, "stat", "ui::CRichText");


	local minVal = pc[minName];
	local maxVal = pc[maxName];

	local grayStyle;
	local value;
	if maxVal == 0 then
		grayStyle = 1;
		value = 0;
	else
		grayStyle = 0;
		value = string.format("%d~%d", minVal, maxVal);		
	end


	if opc ~= nil and opc[maxName] ~= maxVal then
		local colBefore = frame:GetUserConfig("BEFORE_STAT_COLOR");
		local colStr = frame:GetUserConfig("ADD_STAT_COLOR")
		
		local beforeValue = value;
		beforeValue = string.format("%d~%d", opc[minName], opc[maxName]);		

		if beforeValue ~= value then
			stat:SetText(colBefore.. beforeValue..ScpArgMsg("Auto_{/}__{/}")..colStr .. value);
		else
			stat:SetText(value);
		end
	else
		stat:SetText(value);
	end

	controlSet:Resize(controlSet:GetWidth(), stat:GetHeight());
	return y + controlSet:GetHeight();
end


function STATUS_ATTRIBUTE_VALUE_NEW(pc, opc, frame, gboxctrl, attibuteName, y)
	local controlSet = gboxctrl:CreateOrGetControlSet('status_stat', attibuteName, 0, y);
	tolua.cast(controlSet, "ui::CControlSet");
	local title = GET_CHILD(controlSet, "title", "ui::CRichText");
	title:SetText(ScpArgMsg(attibuteName));

	local stat = GET_CHILD(controlSet, "stat", "ui::CRichText");
	title:SetUseOrifaceRect(true)
	stat:SetUseOrifaceRect(true)

	--stat:SetText('120');

	local grayStyle, value = SET_VALUE_ZERO(pc[attibuteName]);
	
	if 1 == grayStyle then
		stat:SetText('');
		controlSet:Resize(controlSet:GetWidth(), stat:GetHeight());
		return y + controlSet:GetHeight();
	end

	if opc ~= nil and opc[attibuteName] ~= value then
		local colBefore = frame:GetUserConfig("BEFORE_STAT_COLOR");
		local colStr = frame:GetUserConfig("ADD_STAT_COLOR")

		local beforeGray, beforeValue = SET_VALUE_ZERO(opc[attibuteName]);
		
		if beforeValue ~= value then
			stat:SetText(colBefore.. beforeValue..ScpArgMsg("Auto_{/}__{/}")..colStr .. value);
		else
			stat:SetText(value);
		end
	else
		stat:SetText(value);
	end

	controlSet:Resize(controlSet:GetWidth(), stat:GetHeight());
	return y + controlSet:GetHeight();
end

function STATUS_ATTRIBUTE_VALUE_DIVISIONBYTHOUSAND_NEW(pc, opc, frame, gboxctrl, attibuteName, y)
	
	local controlSet = gboxctrl:CreateOrGetControlSet('status_stat', attibuteName, 0, y);
	tolua.cast(controlSet, "ui::CControlSet");
		
	local title = GET_CHILD(controlSet, "title", "ui::CRichText");
	title:SetText(ScpArgMsg(attibuteName));

	local stat = GET_CHILD(controlSet, "stat", "ui::CRichText");


	--stat:SetText('120');

	local grayStyle, value = SET_VALUE_ZERO(pc[attibuteName]);
	if 1 == grayStyle then
		stat:SetText('');
		controlSet:Resize(controlSet:GetWidth(), stat:GetHeight());
		return y + controlSet:GetHeight();
	end
	value = math.floor(value / 1000);
	if opc ~= nil and opc[attibuteName] ~= value then
		local colBefore = frame:GetUserConfig("BEFORE_STAT_COLOR");
		local colStr = frame:GetUserConfig("ADD_STAT_COLOR")

		local beforeGray, beforeValue = SET_VALUE_ZERO(opc[attibuteName]);
		if 'MaxSta' == attibuteName then
			beforeValue = math.floor(beforeValue / 1000);
		end
		if beforeValue ~= value then
			stat:SetText(colBefore.. beforeValue..ScpArgMsg("Auto_{/}__{/}")..colStr .. value);
		else
			stat:SetText(value);
		end
	else
		stat:SetText(value);
	end
	controlSet:Resize(controlSet:GetWidth(), stat:GetHeight());
	return y + controlSet:GetHeight();
end

function STATUS_ATTRIBUTE_VALUE(pc, opc, frame, gboxctrl, attibuteName)

	local txtctrl = gboxctrl:GetChild(attibuteName);
	if txtctrl == nil then
		return;
	end

	tolua.cast(txtctrl, 'ui::CRichText');

	local grayStyle, value = SET_VALUE_ZERO(pc[attibuteName]);
	if opc ~= nil and opc[attibuteName] ~= value then
		local colBefore = frame:GetUserConfig("BEFORE_STAT_COLOR");
		local colStr = frame:GetUserConfig("ADD_STAT_COLOR")

		local beforeGray, beforeValue = SET_VALUE_ZERO(opc[attibuteName]);

		if attibuteName == 'DR' then
			beforeValue = string.format("%.1f", beforeValue);
			value = string.format("%.1f", value);
		end

		if beforeValue ~= value then
			txtctrl:SetText(colBefore.. beforeValue..ScpArgMsg("Auto_{/}__{/}")..colStr .. value);
		else
			txtctrl:SetText(value);
		end
	else
		txtctrl:SetText(value);

		if pc ~= nil and pc.DEF_COMMON_BM > 0 then
			value = value + pc.DEF_COMMON_BM;
		end

		if attibuteName == "DEF" and item.IsUseJungtanDefRank() > 0 then
			local value2 = string.format("(+%d)",item.GetJungtanDefence());
			txtctrl:SetText(value .. value2);
		else
			if attibuteName == 'DR' then
				value = string.format("%.1f", value);
			end
			txtctrl:SetText(value);
		end

	end
end

function STATUS_TAB_CHANGE(frame, ctrl, argStr, argNum)
	local tabObj		    = frame:GetChild('statusTab');
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	local curtabIndex	    = itembox_tab:GetSelectItemIndex();
	STATUS_VIEW(frame, curtabIndex);
end

function STATUS_VIEW(frame, curtabIndex)
	if curtabIndex == 0 then
		STATUS_INFO_VIEW(frame);
	elseif curtabIndex == 1 then
		STATUS_ACHIEVE_VIEW(frame);
	elseif curtabIndex == 2 then
		STATUS_LOGOUTPC_VIEW(frame);
	end
end

function STATUS_INFO_VIEW(frame)
	local gboxctrl = frame:GetChild('statusGbox');
	gboxctrl:ShowWindow(1);
	local achievectrl = frame:GetChild('achieveGbox');
	achievectrl:ShowWindow(0);
	local logoutGBox = frame:GetChild("logoutGBox");
	logoutGBox:ShowWindow(0);
	local statusupGbox = frame:GetChild('statusUpGbox');
	statusupGbox:ShowWindow(1);
end

function STATUS_ACHIEVE_VIEW(frame)
	local gboxctrl = frame:GetChild('statusGbox');
	gboxctrl:ShowWindow(0);
	local achievectrl = frame:GetChild('achieveGbox');
	achievectrl:ShowWindow(1);
	local logoutGBox = frame:GetChild("logoutGBox");
	logoutGBox:ShowWindow(0);
	local statusupGbox = frame:GetChild('statusUpGbox');
	statusupGbox:ShowWindow(0);
end

function STATUS_LOGOUTPC_VIEW(frame)
	local gboxctrl = frame:GetChild('statusGbox');
	gboxctrl:ShowWindow(0);
	local achievectrl = frame:GetChild('achieveGbox');
	achievectrl:ShowWindow(0);
	local logoutGBox = frame:GetChild("logoutGBox");
	logoutGBox:ShowWindow(1);
	local statusupGbox = frame:GetChild('statusUpGbox');
	statusupGbox:ShowWindow(0);
end

function CHANGE_MYPC_NAME(frame)

	local charName = GETMYPCNAME();
	local newframe = ui.GetFrame("inputstring");
	newframe:SetUserValue("InputType", "InputNameForChange");
	INPUT_STRING_BOX(ClMsg("InputNameForChange"), "EXEC_CHANGE_NAME", charName, 0, 16);

end

CHAR_NAME_LEN = 20;

function EXEC_CHANGE_NAME(inputframe, ctrl)

	if ctrl:GetName() == "inputstr" then
		inputframe = ctrl;
	end

	local changedName = GET_INPUT_STRING_TXT(inputframe);
	OPEN_CHECK_USER_MIND_BEFOR_YES(inputframe, changedName);
end

function STATUS_AVG(frame)
	local pc = GetMyPCObject();

	local totalValue = 0;
	
	for i = 0 , STAT_COUNT - 1 do
		local typeStr = GetStatTypeStr(i);
		local avg = session.GetStatAvg(i) + pc[typeStr];	
		totalValue = totalValue + avg;
	end
	
	for i = 0 , STAT_COUNT - 1 do
		local typeStr = GetStatTypeStr(i);
		local avg = session.GetStatAvg(i) + pc[typeStr];	

		local x = tonumber(frame:GetUserConfig("StatIconStartX")) + i * 85;		
		SET_STAT_AVG_TEXT(frame, typeStr .. "_AVG", typeStr, pc[typeStr], avg, x, 87, totalValue);
	end
	
	
end

function SET_STAT_AVG_TEXT(frame, ctrlname, propName, propValue, avgStr, xpos, ypos, totalValue)

	local value = avgStr / totalValue;
	local percValue = math.floor(value * 100);
	local addYpos = percValue - 25;

	ypos = ypos - addYpos;

	local gboxctrl = frame:GetChild('statusAvgGbox');
	local statusUpControlSet = gboxctrl:CreateOrGetControlSet('statusinfo', ctrlname, xpos, ypos);
	tolua.cast(statusUpControlSet, "ui::CControlSet");

	local bgPic = GET_CHILD(statusUpControlSet, "bgPic", "ui::CPicture");

	--bgPic:SetImage(propName..'_slot');

	local colorTone = "AAFFFFFF";
	if avgStr > propValue then
		colorTone = "AA66CC00";
	end
	bgPic:SetColorTone(colorTone);

	local name = GET_CHILD(statusUpControlSet, "name", "ui::CRichText");
	name:ShowWindow(0);
	--name:SetText('{@st41}'..ClMsg(propName));

	local onepic = GET_CHILD(statusUpControlSet, "one", "ui::CPicture");
	local tenpic = GET_CHILD(statusUpControlSet, "ten", "ui::CPicture");
	onepic:ShowWindow(0);
	tenpic:ShowWindow(0);

	--[[local statupValue = avgStr;
	if statupValue >= 10 then
		local one = statupValue % 10;
		local ten = math.floor(statupValue / 10);

		onepic:SetImage(tostring(one));
		onepic:ShowWindow(1);
		onepic:SetOffset(15, 20);
		tenpic:SetImage(tostring(ten));
		tenpic:ShowWindow(1);
		tenpic:SetOffset(-12, 20);
	else
		onepic:SetImage(tostring(statupValue));
		onepic:ShowWindow(1);
		onepic:SetOffset(0, 20);
	end]]--

	local btnUp = GET_CHILD(statusUpControlSet, "upbtn", "ui::CButton");
	btnUp:ShowWindow(0);
end


function STATUS_ACHIEVE_INIT(frame)

	local achieveGbox = frame:GetChild('achieveGbox');
	local internalBox = achieveGbox:GetChild("internalBox");

	local clslist, clscnt = GetClassList("Achieve");
	local etcObj = GetMyEtcObject();
	local x = 10;
	local y = 10;

	local equipAchieveName = pc.GetEquipAchieveName();

	for i = 0, clscnt-1 do

		local cls = GetClassByIndexFromList(clslist, i);
		if cls == nil then
			break;
		end

		if HAVE_ACHIEVE_FIND(cls.ClassID) == 1 or cls.Hidden == "NO" then

			local nowpoint = GetAchievePoint(GetMyPCObject(), cls.NeedPoint)

			local eachAchiveCSet = internalBox:CreateOrGetControlSet('each_achieve', 'ACHIEVE_RICHTEXT_'..i, x, y);
			tolua.cast(eachAchiveCSet, "ui::CControlSet");

			eachAchiveCSet:SetUserValue('ACHIEVE_ID', cls.ClassID);

			local NORMAL_SKIN = eachAchiveCSet:GetUserConfig("NORMAL_SKIN")
			local HAVE_SKIN= eachAchiveCSet:GetUserConfig("HAVE_SKIN")

			local eachAchiveGBox = GET_CHILD_RECURSIVELY(eachAchiveCSet,'each_achieve_gbox')
			local eachAchiveDescTitle = GET_CHILD_RECURSIVELY(eachAchiveCSet,'achieve_desctitle')
			local eachAchiveReward = GET_CHILD_RECURSIVELY(eachAchiveCSet,'achieve_reward')
			local eachAchiveGauge = GET_CHILD_RECURSIVELY(eachAchiveCSet,'achieve_gauge')
			local eachAchiveStaticDesc = GET_CHILD_RECURSIVELY(eachAchiveCSet,'achieve_static_desc')
			local eachAchiveDesc = GET_CHILD_RECURSIVELY(eachAchiveCSet,'achieve_desc')
			local eachAchiveName = GET_CHILD_RECURSIVELY(eachAchiveCSet,'achieve_name')
			local eachAchiveReqBtn = GET_CHILD_RECURSIVELY(eachAchiveCSet,'req_reward_btn')
			eachAchiveReqBtn:ShowWindow(0);
			eachAchiveDesc:SetOffset(eachAchiveStaticDesc:GetX() + eachAchiveStaticDesc:GetWidth() + 10, eachAchiveDesc:GetY() )
			eachAchiveGauge:SetOffset(eachAchiveStaticDesc:GetX() + eachAchiveStaticDesc:GetWidth() + 10, eachAchiveGauge:GetY() )
			eachAchiveGauge:Resize(eachAchiveGBox:GetWidth() - eachAchiveStaticDesc:GetWidth() - 50, eachAchiveGauge:GetHeight() )
			eachAchiveGauge:SetTextTooltip("(" .. nowpoint .. "/" .. cls.NeedCount ..")")

			if HAVE_ACHIEVE_FIND(cls.ClassID) == 1 then
				if equipAchieveName == cls.Name then
					eachAchiveDescTitle:SetText('{@stx2}'..cls.DescTitle..ScpArgMsg('Auto__(SayongJung)'));
				else
					eachAchiveDescTitle:SetText('{@stx2}'..cls.DescTitle);
				end
				eachAchiveGBox:SetSkinName(HAVE_SKIN)
			else
				eachAchiveDescTitle:SetText(cls.DescTitle);
				eachAchiveGBox:SetSkinName(NORMAL_SKIN)
			end

			eachAchiveDesc:SetText(cls.Desc);
			eachAchiveGauge:SetPoint(nowpoint, cls.NeedCount);
			eachAchiveName:SetTextByKey('name', cls.Name);
        		eachAchiveReward:SetTextByKey('reward', cls.Reward);

			if HAVE_ACHIEVE_FIND(cls.ClassID) == 1 then
				eachAchiveGauge:ShowWindow(0)
				--eachAchiveCSet:SetEventScript(ui.LBUTTONDOWN, "ACHIEVE_EQUIP");
				--eachAchiveCSet:SetEventScriptArgNumber(ui.LBUTTONDOWN, cls.ClassID);
				--eachAchiveCSet:SetTextTooltip(ScpArgMsg('YouCanEquipAchieve'));
				local etcObjValue = TryGetProp(etcObj, 'AchieveReward_' .. cls.ClassName);
				--if etcObj['AchieveReward_' .. cls.ClassName] == 0 then
				if etcObjValue ~= nil and etcObjValue == 0 then
					eachAchiveReqBtn:ShowWindow(1);
				end
			else
				eachAchiveGauge:ShowWindow(1)
				--eachAchiveDesc:SetText(' ' .. cls.Desc);
				--eachAchiveCSet:SetEventScript(ui.LBUTTONDOWN, "None");
				--eachAchiveCSet:SetTextTooltip('');
			end

			local suby = eachAchiveDesc:GetY() + eachAchiveDesc:GetHeight() + 10;


			if cls.Name ~= 'None' then
				eachAchiveName:ShowWindow(1)
				eachAchiveName:SetOffset(eachAchiveName:GetX(), suby)
				suby = eachAchiveName:GetY() + eachAchiveName:GetHeight() + 10
			else
				eachAchiveName:ShowWindow(0)
			end

			if cls.Reward ~= 'None' then
				eachAchiveReward:ShowWindow(1)
				eachAchiveReward:SetOffset(eachAchiveReward:GetX(), suby)
				suby = eachAchiveReward:GetY() + eachAchiveReward:GetHeight() + 10
			else
				eachAchiveReward:ShowWindow(0)
			end

			eachAchiveGBox:Resize(eachAchiveGBox:GetWidth(), suby)

			eachAchiveCSet:Resize(eachAchiveCSet:GetWidth(),eachAchiveGBox:GetHeight())

			y = y + eachAchiveCSet:GetHeight() + 10;

		end
	end

	local customizingGBox = GET_CHILD_RECURSIVELY(frame,'customizingGBox')
	DESTROY_CHILD_BYNAME(customizingGBox, "hairColor_");

	local pc = GetMyPCObject()
	local etc = GetMyEtcObject();
	local nowAllowedColor = etc['AllowedHairColor']

	local nowheadindex = item.GetHeadIndex()

	local Rootclasslist = imcIES.GetClassList('HairType');
	local Selectclass   = Rootclasslist:GetClass(pc.Gender);
	local Selectclasslist = Selectclass:GetSubClassList();

	local nowhaircls = Selectclasslist:GetByIndex(nowheadindex-1);
	if nil == nowhaircls then
		return;
	end
	local nowengname = imcIES.GetString(nowhaircls, 'EngName') 
	local nowcolor = imcIES.GetString(nowhaircls, 'ColorE')
	nowcolor = string.lower(nowcolor)
	
	local haircount = 0;
	for i = 0, Selectclasslist:Count() do
		local eachcls = Selectclasslist:GetByIndex(i);
		if eachcls ~= nil then
			local eachengname = imcIES.GetString(eachcls, 'EngName') 
			if eachengname == nowengname then
				
				local eachColorE = imcIES.GetString(eachcls, 'ColorE') 
				local eachColor = imcIES.GetString(eachcls, 'Color') 
				eachColorE = string.lower(eachColorE)

				-- 업적 받으면 헤어 컬러 사라지는 현상이 있다고 해서 HairColor 프로퍼티 값으로도 확인
				if string.find(nowAllowedColor, eachColorE) ~= nil or TryGetProp(etc, "HairColor_"..eachColorE) == 1 then
				
					local eachhairimg = customizingGBox:CreateOrGetControl('picture', 'hairColor_'..eachColorE, 30 + 35 * haircount, 55, 35, 35);
					tolua.cast(eachhairimg, "ui::CPicture");
				
					local colorimgname = GET_HAIRCOLOR_IMGNAME_BY_ENGNAME(eachColorE)
					eachhairimg:SetImage(colorimgname); 
					eachhairimg:SetTextTooltip(eachColor)
					eachhairimg:SetEventScript(ui.LBUTTONDOWN, "REQ_CHANGE_HAIR_COLOR");
					eachhairimg:SetEventScriptArgString(ui.LBUTTONDOWN, eachColorE);
				
					if nowcolor == eachColorE then
						local selectedimg = customizingGBox:CreateOrGetControl('picture', 'hairColor_Selected', 30 + 35 * haircount, 45, 35, 35);
						tolua.cast(selectedimg, "ui::CPicture");
						selectedimg:SetImage('color_check');
					end

					haircount = haircount + 1
				end
			end
		end
	end

	DESTROY_CHILD_BYNAME(customizingGBox, "ACHIEVE_RICHTEXT_");
	local index = 0;
	local x = 40;
	local y = 145;

	for i = 0, clscnt-1 do

		local cls = GetClassByIndexFromList(clslist, i);
		if cls == nil then
			break;
		end

		if HAVE_ACHIEVE_FIND(cls.ClassID) == 1 and cls.Name ~= "None" then

			local achiveRichCtrl = customizingGBox:CreateOrGetControl('richtext', 'ACHIEVE_RICHTEXT_'..i, x, y, frame:GetWidth() - 5, 20);
			
			if equipAchieveName == cls.Name then
				achiveRichCtrl:SetText('{@stx2}'..cls.Name..ScpArgMsg('Auto__(SayongJung)'));
			else
				achiveRichCtrl:SetText('{@st41b}'..cls.Name);
			end
			achiveRichCtrl:SetEventScript(ui.LBUTTONDOWN, "ACHIEVE_EQUIP");
			achiveRichCtrl:SetEventScriptArgNumber(ui.LBUTTONDOWN, cls.ClassID);
			achiveRichCtrl:SetTextTooltip(cls.Desc);
			achiveRichCtrl:SetTooltipMaxWidth(350);
			y = y + achiveRichCtrl:GetHeight() + 10;

		end
	end

	frame:Invalidate();

end

function REQ_ACHIEVE_REWARD(frame, ctrl)

	local achieveID = frame:GetUserIValue('ACHIEVE_ID');
	session.ReqAchieveReward(achieveID);
end

function REQ_CHANGE_HAIR_COLOR(frame, ctrl, hairColorName)
	item.ReqChangeHead(hairColorName);
end


function GET_HAIRCOLOR_IMGNAME_BY_ENGNAME(engname)
	
	if engname == 'black' then
		return "black_color"
	end

	if engname == 'blue' then
		return "blue_color"
	end

	if engname == 'pink' then
		return "peach_color"
	end

	if engname == 'white' then
		return "white_color"
	end
	
	if engname == 'blond' then
		return "blond_color"
	end
	
	if engname == 'red' then
		return "red_color"
	end
	
	if engname == 'green' then
		return "green_color"
	end
	
	if engname == 'gray' then
		return "gray_color"
	end
	
	if engname == 'lightsalmon' then
		return "lightsalmon_color"
	end
	
	if engname == 'purple' then
		return "purple_color"
	end
	
	if engname == 'orange' then
		return "orange_color"
	end
	return "basic_color"

end


function GET_HAIRCOLOR_COLORTONE_BY_ENGNAME(engname)
	
	if engname == 'black' then
		return "FF111111"
	end

	if engname == 'blue' then
		return "FF00FF00"
	end

	if engname == 'pink' then
		return "FF000066"
	end

	if engname == 'white' then
		return "FFFFFFFF"
	end

	return "default"

end

function STATUS_JOB_CHANGE(frame)

--[[

	local logoutGBox = frame:GetChild("logoutGBox");
	local logoutInternal = logoutGBox:GetChild("logoutInternal");
	local makelogoutpc = GET_CHILD(logoutInternal, "makelogoutpc");
	local totalJobGrade = session.GetPcTotalJobGrade();
	if totalJobGrade >= 3 then
		makelogoutpc:SetTextByKey("value", ClMsg("PossibleToUse"));
	else
		makelogoutpc:SetTextByKey("value", ClMsg("ImpossibleToUse"));
	end
	]]
	
end


--캐릭터 이름 변경
function CHANGE_MYPC_NAME_BY_ITEM(invItem)
	local newframe = ui.GetFrame("inputstring");

	if invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock")); 
		newframe:ShowWindow(0);
		return;
	end

	local charName = GETMYPCNAME();
	newframe:SetUserValue("InputType", "InputNameForChange");
	newframe:SetUserValue("ItemIES", invItem:GetIESID());
	newframe:SetUserValue("ItemType", "PcName");
	INPUT_STRING_BOX(ClMsg("InputNameForChange"), "EXEC_CHANGE_NAME_BY_ITEM", charName, 0, 16);
end

--팀 이름 변경
function CHANGE_TEAM_NAME_BY_ITEM(invItem)
	local newframe = ui.GetFrame("inputstring");

	if invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock")); 
		newframe:ShowWindow(0);
		return;
	end

	local charName = GETMYFAMILYNAME();
	newframe:SetUserValue("InputType", "InputNameForChange");
	newframe:SetUserValue("ItemIES", invItem:GetIESID());
	newframe:SetUserValue("ItemType", "TeamName");
	INPUT_STRING_BOX(ClMsg("ChangeFamilyName"), "EXEC_CHANGE_NAME_BY_ITEM", charName, 0, 16);
end

--길드 이름 변경
function CHANGE_GUILD_NAME_BY_ITEM(invItem)
	local newframe = ui.GetFrame("inputstring");

	if invItem.isLockState then
		ui.SysMsg(ClMsg("MaterialItemIsLock")); 
		newframe:ShowWindow(0);
		return;
	end

	local guild = session.party.GetPartyInfo(PARTY_GUILD);
	if guild == nil then
		newframe:ShowWindow(0);
		return;
	end


	local charName = guild.info.name;
	newframe:SetUserValue("InputType", "InputNameForChange");
	newframe:SetUserValue("ItemIES", invItem:GetIESID());
	newframe:SetUserValue("ItemType", "GuildName");
	INPUT_STRING_BOX(ClMsg("ChangeGuildName"), "EXEC_CHANGE_NAME_BY_ITEM", charName, 0, 16);
end

function EXEC_CHANGE_NAME_BY_ITEM(inputframe, ctrl)

	if ctrl:GetName() == "inputstr" then
		inputframe = ctrl;
	end
	local newframe = ui.GetFrame("inputstring");
	local itemIES = nil;
	local itemIES = newframe:GetUserValue("ItemIES");
	local itemType = newframe:GetUserValue("ItemType");

	local changedName = GET_INPUT_STRING_TXT(newframe);

	if ui.IsValidCharacterName(changedName) == false then
		ui.SysMsg(ClMsg("HadFobbidenWord"));
		return;
	end

	OPEN_CHECK_USER_MIND_BEFOR_YES_BY_ITEM(inputframe, changedName, itemIES, itemType);
end
