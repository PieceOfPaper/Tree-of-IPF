﻿-- barrack_charlist.lua
local prev_select_slot = 0

function BARRACK_CHARLIST_ON_INIT(addon, frame)
	addon:RegisterMsg("BARRACK_ADDCHARACTER", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_NEWCHARACTER", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_SLOT_BUY", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_CREATECHARACTER_BTN", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_DELETECHARACTER", "SELECTCHARINFO_DELETE_CTRL");
	addon:RegisterMsg("BARRACK_SELECTCHARACTER", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_SELECT_BTN", "SELECTTEAM_ON_MSG");
    addon:RegisterMsg("BARRACK_REMOVE_CHARACTER_SCROLLBOX", "REMOVE_CHARACTER_SCROLLBOX");
	
	addon:RegisterMsg("BARRACK_NAME", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("SET_BARRACK_MODE", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("UPDATE_SELECT_BTN_TITLE", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("NOT_HANDLED_ENTER", "SELECTTEAM_OPEN_CHAT");
	
	addon:RegisterMsg("BARRACK_NAME_CHANGE_RESULT", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg("BARRACK_ACCOUNT_PROP_UPDATE", "SELECTTEAM_ON_MSG");
	addon:RegisterMsg('RESULT_CHECK_MARKET', 'ON_RESULT_CHECK_MARKET');
    addon:RegisterMsg("BARRACK_CHARACTER_SWAP_FAIL", "SET_SWAP_REQUEST_FLAG_FALSE")
    addon:RegisterMsg("BARRACK_CHARACTER_SWAP_SUCCESS", "SET_SWAP_REQUEST_FLAG_FALSE")

	frame:SetUserValue("BarrackMode", "Barrack");


	CHAR_LIST_CLOSE_HEIGHT = 128;
	CHAR_LIST_OPEN_HEIGHT = 450;
	CUR_SELECT_GUID = 'None';
	current_layer = 1   
end

local swap_flag = false

local function SET_BTN_ALPHA(frame, hittest, alpha)
	if frame == nil then
		return
	end

	local upBtn = GET_CHILD_RECURSIVELY(frame, "button_up")
    local downBtn = GET_CHILD_RECURSIVELY(frame, "button_down")
    local upBtn_alpha = GET_CHILD_RECURSIVELY(frame, "button_up_alpha")
    local downBtn_alpha = GET_CHILD_RECURSIVELY(frame, "button_down_alpha")
    upBtn:EnableHitTest(hittest)
    upBtn_alpha:SetAlpha(alpha)
    downBtn:EnableHitTest(hittest)
    downBtn_alpha:SetAlpha(alpha)
end

local function disable_char_btn(frame)
    if frame == nil then return end    
    local new_char = GET_CHILD_RECURSIVELY(frame, "button_new_char")
    local char_del = GET_CHILD_RECURSIVELY(frame, "button_char_del")    
    new_char:EnableHitTest(0)
    new_char:SetAlpha(70)
    char_del:EnableHitTest(0)
    char_del:SetAlpha(70)
end

function enable_layer_btn()    
    local frame = ui.GetFrame('barrack_charlist')
    if frame == nil then return end

    local layerCtrl_1 = GET_CHILD(frame, "changeLayer1", "ui::CButton");
	local layerCtrl_2 = GET_CHILD(frame, "changeLayer2", "ui::CButton");
	local layerCtrl_3 = GET_CHILD(frame, "changeLayer3", "ui::CButton");
    
    layerCtrl_1:EnableHitTest(1)
    layerCtrl_1:SetAlpha(100)
    layerCtrl_2:EnableHitTest(1)
    layerCtrl_2:SetAlpha(100)
    layerCtrl_3:EnableHitTest(1)
    layerCtrl_3:SetAlpha(100)
end

function reset_moving_barrack_layer()
	local frame = ui.GetFrame('barrack_charlist')
	if frame == nil then 
		return 
	end

	frame:SetUserValue("MovingBarrackLayer", 0);

end

function disable_layer_btn(frame)
    local frame = ui.GetFrame('barrack_charlist')
    if frame == nil then return end

    local layerCtrl_1 = GET_CHILD(frame, "changeLayer1", "ui::CButton");
	local layerCtrl_2 = GET_CHILD(frame, "changeLayer2", "ui::CButton");
	local layerCtrl_3 = GET_CHILD(frame, "changeLayer3", "ui::CButton");
    
    layerCtrl_1:EnableHitTest(0)
    layerCtrl_1:SetAlpha(70)
    layerCtrl_2:EnableHitTest(0)
    layerCtrl_2:SetAlpha(70)
    layerCtrl_3:EnableHitTest(0)
    layerCtrl_3:SetAlpha(70)
end

function enable_char_btn(f)
    local frame = ui.GetFrame('barrack_charlist')
    if frame == nil then return end

    local new_char = GET_CHILD_RECURSIVELY(frame, "button_new_char")
    local char_del = GET_CHILD_RECURSIVELY(frame, "button_char_del")    
    new_char:EnableHitTest(1)
    new_char:SetAlpha(100)
    char_del:EnableHitTest(1)
    char_del:SetAlpha(100)
end

function SET_SWAP_REQUEST_FLAG_FALSE(frame)    
    swap_flag = false
    if frame == nil then
    	return
    end
    
    SET_BTN_ALPHA(frame, 1, 0)
end

function REMOVE_CHARACTER_SCROLLBOX(frame)    
    local scrollBox = frame:GetChild("scrollBox");
	scrollBox:RemoveAllChild();
end

function INIT_BARRACK_NAME(frame)
	local charlist = ui.GetFrame("barrack_charlist");
	local pccount = charlist:GetChild("pccount");
	pccount:ShowWindow(1);
	pccount:SetTextByKey("curpc", '0');
	pccount:SetTextByKey("maxpc", '4');

	local barrackOwner = session.barrack.GetMyAccount();
	if charlist:GetUserValue('BarrackMode') == 'Visit' then
		barrackOwner = session.barrack.GetCurrentAccount();
	end
	if nil == barrackOwner then
		return;
	end

	local myCharCont = barrackOwner:GetPCCount();
	local buySlot = barrackOwner:GetBuySlotCount();
	local barrackCls = GetClass("BarrackMap", barrackOwner:GetThemaName());
	pccount:SetTextByKey("curpc", tostring(myCharCont));
	local maxpcCount = barrackCls.BaseSlot + buySlot;
	pccount:SetTextByKey("maxpc", tostring(maxpcCount));

	local totalBarrackSlotCount = barrackOwner:GetTotalSlotCount();
	local layercount = GET_CHILD(frame, "layercount", "ui::CRichText");
	if nil ~= layercount then
		layercount:SetTextByKey("curcount", tostring(totalBarrackSlotCount));
		layercount:SetTextByKey("maxcount", tostring(maxpcCount));
	end
	
	local accountObj = GetMyAccountObj();
	local richtext = GET_CHILD_RECURSIVELY(frame, "free");
	if richtext ~= nil then
		richtext:SetTextByKey("value", accountObj.Medal);
		richtext = GET_CHILD_RECURSIVELY(frame, "event");
		richtext:SetTextByKey("value", accountObj.GiftMedal);
		richtext = GET_CHILD_RECURSIVELY(frame, "tp");
		richtext:SetTextByKey("value", accountObj.PremiumMedal);
	end
	CHAR_N_PET_LIST_LOCKMANGED(1);

	app.RequestChannelTraffic(1) -- create command for channel traffic request(this cmd exit when user logout/exit game/start game)
end

function DRAW_BARRACK_MEDAL_COUNT(frame)
	local myaccount = session.barrack.GetMyAccount();
	if nil == myaccount then
		return;
	end

	local accountObj = GetMyAccountObj();
	if accountObj == nil then
		return;
	end

	local barrackName = ui.GetFrame("barrack_name");
	if barrackName == nil then
		return;
	end

	local richtext = GET_CHILD_RECURSIVELY(barrackName, "free");
	if richtext == nil then
		return;
	end

	richtext:SetTextByKey("value", accountObj.Medal);
	richtext = GET_CHILD_RECURSIVELY(barrackName, "event");
	richtext:SetTextByKey("value", accountObj.GiftMedal);
	richtext = GET_CHILD_RECURSIVELY(barrackName, "tp");
	richtext:SetTextByKey("value", accountObj.PremiumMedal);
end

function SELECTTEAM_NEW_CTRL(frame, actor)    
	local account = session.barrack.GetCurrentAccount();
	local myaccount = session.barrack.GetMyAccount();
	local barrackMode = frame:GetUserValue("BarrackMode");
	
	if "Visit" == barrackMode and account == myaccount then
		local scrollBox = frame:GetChild("scrollBox");
		scrollBox:RemoveAllChild();
		return;
	end

	local barrackName = ui.GetFrame("barrack_name");
	local teamlevel = barrackName:GetChild("teamlevel");
	local nameCtrl = GET_CHILD(barrackName, "barrackname");
	nameCtrl:SetPos(teamlevel:GetX() + teamlevel:GetWidth() + 20,nameCtrl:GetY());

	teamlevel:SetTextByKey("value", account:GetTeamLevel());
	local buySlot = myaccount:GetBuySlotCount();
	local myCharCont = myaccount:GetPCCount();
	local barrackCls = GetClass("BarrackMap", myaccount:GetThemaName());
	local maxpcCount = barrackCls.BaseSlot + buySlot;

	local pccount = frame:GetChild("pccount");
	pccount:ShowWindow(1);
	pccount:SetTextByKey("curpc", tostring(myCharCont));
	pccount:SetTextByKey("maxpc", tostring(maxpcCount));

	local layercount = frame:GetChild("layercount");
	layercount:ShowWindow(1);
	layercount:SetTextByKey("curcount", tostring(myCharCont));
	layercount:SetTextByKey("maxcount", tostring(maxpcCount));

	local accountObj = GetMyAccountObj();

	if barrackMode ~= "Visit" then
		local richtext = GET_CHILD_RECURSIVELY(barrackName, "free");
		richtext:SetTextByKey("value", accountObj.Medal);
		richtext = GET_CHILD_RECURSIVELY(barrackName, "event");
		richtext:SetTextByKey("value", accountObj.GiftMedal);
		richtext = GET_CHILD_RECURSIVELY(barrackName, "tp");
		richtext:SetTextByKey("value", accountObj.PremiumMedal);
	end

	if actor ~= nil then
		CREATE_SCROLL_CHAR_LIST(frame, actor);
	end
end

function OPEN_CHAR_MENU(ctrl, btn)

	local mainBox = ctrl;
	local delCtrl = GET_CHILD(mainBox, "delete_btn", "ui::CButton");
	local moveCtrl = GET_CHILD(mainBox, "move_btn", "ui::CButton");
    local upCtrl = GET_CHILD(mainBox, "up_btn", "ui::CButton");
    local downCtrl = GET_CHILD(mainBox, "down_btn", "ui::CButton");    
	if delCtrl:IsVisible() == 1 then
		delCtrl:ShowWindow(0);		
        moveCtrl:ShowWindow(0);
        upCtrl:ShowWindow(0)
        downCtrl:ShowWindow(0);        
	else
		delCtrl:ShowWindow(1);
		moveCtrl:ShowWindow(1);
        upCtrl:ShowWindow(1)
        downCtrl:ShowWindow(1);        
	end

	imcSound.PlaySoundEvent('button_click_big_2');
end

function UP_SWAP_CHARACTER_SLOT(ctr, btn, cid)    
    cid = CUR_SELECT_GUID        
    local frame = ui.GetFrame("barrack_charlist");
    local scrollBox = frame:GetChild("scrollBox");
	for i=0, scrollBox:GetChildCount()-1 do
		local child = scrollBox:GetChildByIndex(i);        
		if string.find(child:GetName(), 'char_') ~= nil and child:GetName() ~= 'char_add' then	            
            local list = StringSplit(child:GetName(), "_");
            if #list == 2 and cid == list[2] then                
                local chi = scrollBox:GetChildByIndex(i - 1)
                if chi ~= nil and chi:GetName() ~= 'char_add' then
                    local list1 = StringSplit(chi:GetName(), "_")                    
                    if #list1 == 2 and swap_flag == false and list1[2] ~= 'SCR' then
                        barrack.SwapCharacterSlot(tostring(cid), tostring(list1[2]))
                        swap_flag = true
                        SET_BTN_ALPHA(frame, 0, 50)
                    end
                end                
            end            
        end
    end
end

function DOWN_SWAP_CHARACTER_SLOT(ctr, btn, cid)
	cid = CUR_SELECT_GUID
    local frame = ui.GetFrame("barrack_charlist");
    local scrollBox = frame:GetChild("scrollBox");
	for i=0, scrollBox:GetChildCount()-1 do
		local child = scrollBox:GetChildByIndex(i);        
		if string.find(child:GetName(), 'char_') ~= nil and child:GetName() ~= 'char_add' then	             
            local list = StringSplit(child:GetName(), "_");
            if #list == 2 and cid == list[2] then                
                local chi = scrollBox:GetChildByIndex(i + 1)
                if chi ~= nil and chi:GetName() ~= 'char_add' then
                    local list1 = StringSplit(chi:GetName(), "_")                    
                    if #list1 == 2 and swap_flag == false then
                        barrack.SwapCharacterSlot(tostring(cid), tostring(list1[2]))
                        swap_flag = true
                        SET_BTN_ALPHA(frame, 0, 50)
                    end
                end                
            end            
        end
    end
end

function CHANGE_BARRACK_LAYER(ctrl, btn, cid, argNum)   
	local jobName = barrack.GetSelectedCharacterJob();
	local charName = barrack.GetSelectedCharacterName();
	local yesScp = string.format("SELECTCHARINFO_CHANGELAYER_CHARACTER(\'%s\')", tostring(cid));
	ui.MsgBox("{nl} {nl}{s22}"..jobName.." {@st43}"..charName..ScpArgMsg("Auto_{/}{nl}{s22}MoveBarrackLayer?"), yesScp, 'SELECTCHARINFO_DELETECHARACTER_CANCEL');
end

-- 특정 layer 이동
function CHANGE_BARRACK_TARGET_LAYER(ctrl, btn, cid, argNum)    
	cid = CUR_SELECT_GUID    
    local frame = ui.GetFrame("barrack_charlist")
    local titleText = ScpArgMsg("InputCount")
    frame:SetUserValue('character_cid', tostring(cid))

	local pcPCInfo = session.barrack.GetMyAccount():GetByStrCID(cid);
	if pcPCInfo == nil then
		return;
	end

	local jobName = barrack.GetSelectedCharacterJob();
	local charName = barrack.GetSelectedCharacterName();
    disable_char_btn(frame)
    INPUT_DROPLIST_BOX(frame, "SELECT_CHARINFO_CHANGE_TARGET_LAYER_CHARACTER", charName, jobName, 1, 3)
end

function SELECT_CHARINFO_CHANGE_TARGET_LAYER_CHARACTER(frame, target, inputframe)    
    inputframe:ShowWindow(0)
    target = tonumber(target)
    if target < 1 or target > 3 then
        return
    end
    
    local cid = frame:GetUserValue('character_cid')
    if cid == nil or cid == 0 then
        return
    end

	barrack.ChangeBarrackTargetLayer(cid, target, false);
	local frame = ui.GetFrame("barrack_charlist");
	local scrollBox = frame:GetChild("scrollBox");
	scrollBox:RemoveAllChild();
	imcSound.PlaySoundEvent('button_click_big_2');
end

function SELECT_CHARINFO_CHANGE_TARGET_LAYER_COMPANION(frame, target, inputframe)
    inputframe:ShowWindow(0)
    target = tonumber(target)
    if target < 1 or target > 3 then
        return
    end
    
    local cid = CUR_SELECT_PET_ID    
    if cid == nil or cid == 0 then
        return
    end

	barrack.ChangeBarrackTargetLayer(cid, target, true);
	local frame = ui.GetFrame("barrack_charlist");
	local scrollBox = frame:GetChild("scrollBox");
	scrollBox:RemoveAllChild();
	imcSound.PlaySoundEvent('button_click_big_2');
end


function SELECTCHARINFO_CHANGELAYER_CHARACTER(cid)
	barrack.ChangeBarrackLayer(cid);

	local frame = ui.GetFrame("barrack_charlist");
	local scrollBox = frame:GetChild("scrollBox");
	scrollBox:RemoveAllChild();
	imcSound.PlaySoundEvent('button_click_big_2');
end

function SELECT_BARRACK_LAYER(frame, ctrl, arg, layer)
	local before = frame:GetUserValue("SelectBarrackLayer");
	local isMoving = frame:GetUserValue("MovingBarrackLayer");
	if tostring(before) == tostring(layer) then
		return;
	end
	
	if tostring(isMoving) == '1' then
		return;
	end
		
	frame:SetUserValue("MovingBarrackLayer", 1);
    
	local pccount = GET_CHILD(frame, "pccount", "ui::CRichText");
	local layerCtrl_1 = GET_CHILD(frame, "changeLayer1", "ui::CButton");
	local layerCtrl_2 = GET_CHILD(frame, "changeLayer2", "ui::CButton");
	local layerCtrl_3 = GET_CHILD(frame, "changeLayer3", "ui::CButton");
	if ctrl:GetName() == 'changeLayer1' then
		layerCtrl_1:SetImage('barrack_on_one_btn');
		layerCtrl_2:SetImage('barrack_off_two_btn');
		layerCtrl_3:SetImage('barrack_off_three_btn');
		pccount:SetTextByKey("value", '1');        
	elseif ctrl:GetName() == 'changeLayer2' then
		layerCtrl_1:SetImage('barrack_off_one_btn');
		layerCtrl_2:SetImage('barrack_on_two_btn');
		layerCtrl_3:SetImage('barrack_off_three_btn');
		pccount:SetTextByKey("value", '2');        
	else
		layerCtrl_1:SetImage('barrack_off_one_btn');
		layerCtrl_2:SetImage('barrack_off_two_btn');
		layerCtrl_3:SetImage('barrack_on_three_btn');
		pccount:SetTextByKey("value", '3');        
	end

	barrack.SelectBarrackLayer(layer);
	frame:SetUserValue("SelectBarrackLayer", layer);
    current_layer = layer    
	local scrollBox = frame:GetChild("scrollBox");
	scrollBox:RemoveAllChild();
    disable_char_btn(frame)
    disable_layer_btn(frame)
	AddLuaTimerFunc('enable_layer_btn', 5000, 0)
	AddLuaTimerFunc('reset_moving_barrack_layer', 5000, 0) -- 5초뒤에 강제로 해제.
end

function BARRACK_GET_CHAR_INDUN_ENTRANCE_COUNT(cid, resetGroupID)
    local accountInfo = session.barrack.GetMyAccount();
	local acc_obj = GetMyAccountObj()
	if resetGroupID < 0 then
		local contentsClsList, count = GetClassList('contents_info')		
        local contentsCls = nil;
        for i = 0, count - 1 do
            contentsCls = GetClassByIndexFromList(contentsClsList, i);
            if contentsCls ~= nil and contentsCls.ResetGroupID == resetGroupID and contentsCls.Category ~= 'None' then
                break;
            end
        end

        if contentsCls.UnitPerReset == 'PC' then
			return accountInfo:GetBarrackCharEtcProp(cid, contentsCls.ResetType);
        else
            return acc_obj[contentsCls.ResetType];
        end
	end
	
    local indunClsList, cnt = GetClassList('Indun');
    local indunCls = nil;
    for i = 0, cnt - 1 do
        indunCls = GetClassByIndexFromList(indunClsList, i);
        if indunCls ~= nil and indunCls.PlayPerResetType == resetGroupID and indunCls.Category ~= 'None' then
            break;
        end
    end
	if indunCls.WeeklyEnterableCount ~= nil and indunCls.WeeklyEnterableCount ~= "None" and indunCls.WeeklyEnterableCount ~= 0 then
		if indunCls.UnitPerReset == 'PC' then
			return accountInfo:GetBarrackCharEtcProp(cid,'IndunWeeklyEnteredCount_'..resetGroupID)  --매주 ?��? ?�수
		else
			return(acc_obj['IndunWeeklyEnteredCount_'..resetGroupID])   							--매주 ?��? ?�수
		end
        
	else
		if indunCls.UnitPerReset == 'PC' then
			return accountInfo:GetBarrackCharEtcProp(cid, 'InDunCountType_'..resetGroupID);         --매일 ?��? ?�수
		else
			return (acc_obj['InDunCountType_'..resetGroupID]);            							--매일 ?��? ?�수
		end        
    end
end

function BARRACK_GET_INDUN_MAX_ENTERANCE_COUNT(resetGroupID)
	if resetGroupID < 0 then
        local contentsClsList, count = GetClassList('contents_info');
        local contentsCls = nil;
        for i = 0, count - 1 do
            contentsCls = GetClassByIndexFromList(contentsClsList, i);
            if contentsCls ~= nil and contentsCls.ResetGroupID == resetGroupID and contentsCls.Category ~= 'None' then
                break;
            end
        end

        local ret = contentsCls.EnterableCount
        if ret == 0 then
            ret = "{img infinity_text 20 10}"
        end
        return ret
	else
		local indunClsList, cnt = GetClassList('Indun');
		local indunCls = nil;
		for i = 0, cnt - 1 do
			indunCls = GetClassByIndexFromList(indunClsList, i);
			if indunCls ~= nil and indunCls.PlayPerResetType == resetGroupID and indunCls.Category ~= 'None' then
				break;
			end
		end
		
		local infinity = TryGetProp(indunCls, 'EnableInfiniteEnter', 'NO')
		if indunCls.AdmissionItemName ~= "None" or infinity == 'YES'  then
			local a = "{img infinity_text 20 10}"
			return a;
		end
		
		local bonusCount = 0;
		if indunCls.WeeklyEnterableCount ~= nil and indunCls.WeeklyEnterableCount ~= "None" and indunCls.WeeklyEnterableCount ~= 0 then
			return indunCls.WeeklyEnterableCount + bonusCount;  --매주 max
		else
			return indunCls.PlayPerReset + bonusCount;          --매일 max
		end
	end    
end

local function toint(n)
    local s = tostring(n)
    local i, j = s:find('%.')
    if i then
        return tonumber(s:sub(1, i-1))
    else
        return n
    end
end

function CREATE_SCROLL_CHAR_LIST(frame, actor)   
    local barrackMode = frame:GetUserValue("BarrackMode");
	local name = actor:GetName();    
	local brk = GetBarrackSystem(actor);
	local key = brk:GetCIDStr();
	local bpc = barrack.GetBarrackPCInfoByCID(key);
	if bpc == nil then        
		return;
	end

	local scrollBox = frame:GetChild("scrollBox");
	local charCtrl = scrollBox:CreateOrGetControlSet('barrack_charlist', 'char_'..key, 10, 0);
	charCtrl = AUTO_CAST(charCtrl)
	charCtrl:SetUserValue("CID", key);
	local mainBox = GET_CHILD(charCtrl,'mainBox','ui::CGroupBox');
	local btn = mainBox:GetChild("btn");
	btn:SetSkinName('character_off');
	btn:SetSValue(name);
	btn:SetOverSound('button_over');
	btn:SetClickSound('button_click_2');
	btn:SetEventScript(ui.LBUTTONUP, "SELECT_CHARBTN_LBTNUP");
	btn:SetEventScriptArgString(ui.LBUTTONUP, key);

	local indunBtn = mainBox:GetChild("indunBtn")
	if session.barrack.GetMyAccount() == session.barrack.GetCurrentAccount() then
		indunBtn:SetTooltipType("indunListTooltip")
		indunBtn:SetTooltipArg(key, 0, 0, actor)
	else
		indunBtn:SetVisible(0)
	end

	if session.barrack.GetMyAccount():GetByStrCID(key) ~= nil and "Barrack" == barrackMode then
		btn:SetEventScript(ui.LBUTTONDBLCLICK, "BARRACK_TO_GAME");
		btn:SetEventScriptArgString(ui.LBUTTONDBLCLICK, key);
	end
		
	btn:ShowWindow(1);

	local apc = bpc:GetApc();
	local gender = apc:GetGender();
	local jobid = apc:GetJob();
	local pic = GET_CHILD(mainBox, "char_icon", "ui::CPicture");
	local headIconName = ui.CaptureModelHeadImageByApperance(apc);
	pic:SetImage(headIconName);    

	local nameCtrl = GET_CHILD(mainBox, "name", "ui::CRichText");
	nameCtrl:SetText("{@st42b}{b}".. name);
        
    -- 대표 클래스 지정
	local barrack_pc = session.barrack.GetMyAccount():GetByStrCID(key);
	if barrack_pc ~= nil and barrack_pc:GetRepID() ~= 0 then 
		jobid = barrack_pc:GetRepID();
	end
    
    local jobCls = GetClassByType("Job", jobid);
	local jobCtrl = GET_CHILD(mainBox, "job", "ui::CRichText");
	jobCtrl:SetText("{@st42b}".. GET_JOB_NAME(jobCls, gender));
	local levelCtrl = GET_CHILD(mainBox, "level", "ui::CRichText");
	levelCtrl:SetText("{@st42b}Lv.".. actor:GetLv());

	local detail = GET_CHILD(charCtrl,'detailBox','ui::CGroupBox');
	local mapNameCtrl = GET_CHILD(detail,'mapName','ui::CRichText');	
	local mapCls = GetClassByType("Map", apc.mapID);
	local mapName = mapCls.Name;
	mapNameCtrl:SetText("{@st66b}".. mapName);
		
	local spotCount = item.GetEquipSpotCount() - 1;
	for i = 0 , spotCount do
		local eqpObj = bpc:GetEquipObj(i);
		local esName = item.GetEquipSpotName(i);
		if eqpObj ~= nil then
			local obj = GetIES(eqpObj);
			local eqpType = TryGet_Str(obj, "EqpType");
			if eqpType == "HELMET" then 
				if item.IsNoneItem(obj.ClassID) == 0 then
					esName = "HAIR";
				end
			end

			if esName == "TRINKET" and obj ~= nil and item.IsNoneItem(obj.ClassID) == 0 then
			     esName = "LH"
		        end
		end
		
		local eqpSlot = GET_CHILD(detail, esName, "ui::CSlot");
		if eqpSlot ~= nil then
			eqpSlot:EnableDrag(0);
			if eqpObj == nil then
				CLEAR_SLOT_ITEM_INFO(eqpSlot);
			else
				local obj = GetIES(eqpObj);
				local refreshScp = obj.RefreshScp;
				if refreshScp ~= "None" then
					refreshScp = _G[refreshScp];
					refreshScp(obj);
				end	

				if 0 == item.IsNoneItem(obj.ClassID) then
					CLEAR_SLOT_ITEM_INFO(eqpSlot);
					SET_SLOT_ITEM_OBJ(eqpSlot, obj, gender, 1);
				else
					CLEAR_SLOT_ITEM_INFO(eqpSlot);
				end
			end
		end
	end

	detail:ShowWindow(0);
	charCtrl:Resize(charCtrl:GetWidth(), CHAR_LIST_CLOSE_HEIGHT);

	GBOX_AUTO_ALIGN(scrollBox, 10, 10, 10, true, false);

end

function CREATE_SCROLL_NEW_CHAR(frame)
	local scrollBox = frame:GetChild("scrollBox");
	scrollBox:RemoveChild('char_add');

	local charCtrl = scrollBox:CreateOrGetControlSet('barrack_newchar', 'char_add', 0, 0);
	charCtrl = tolua.cast(charCtrl, "ui::CControlSet");
	local btn = charCtrl:GetChild("btn");
	btn:SetOverSound('button_over');
	btn:SetClickSound('button_click_2');
	btn:SetEventScript(ui.LBUTTONUP, "BARRACK_GO_CREATE");
	btn:ShowWindow(1);
	local text = charCtrl:GetChild("text");
	text:SetText("{@st42b}{b}" .. ClMsg("CreateNewCharacter"));

	if argStr == 'Hide' then
		charCtrl:Resize(charCtrl:GetWidth(), 1);
	else
		charCtrl:Resize(charCtrl:GetWidth(), CHAR_LIST_CLOSE_HEIGHT);
	end

	GBOX_AUTO_ALIGN(scrollBox, 10, 10, 10, true, false);
end

function UPDATE_SELECT_CHAR_SCROLL(frame)    
	local acc = session.barrack.GetMyAccount();

	local scrollBox = frame:GetChild("scrollBox");
	for i=0, scrollBox:GetChildCount()-1 do
		local child = scrollBox:GetChildByIndex(i);
		if string.find(child:GetName(), 'char_') ~= nil then		
			local guid = child:GetUserValue("CID");
			local detail = GET_CHILD(child,'detailBox','ui::CGroupBox');
			local mainBox = GET_CHILD(child,'mainBox','ui::CGroupBox');
			local btn = mainBox:GetChild("btn");
			local petCnt = GET_CHILD_CNT_BYNAME(child, "attached_pet_");

			if CUR_SELECT_GUID == guid then
				local addY = (petCnt * 30);
				detail:SetOffset(detail:GetOriginalX(), detail:GetOriginalY()+addY); 
				child:Resize(child:GetWidth(), CHAR_LIST_OPEN_HEIGHT + addY);					
				detail:ShowWindow(1);
				btn:SetSkinName('character_on');

			elseif child:GetName() ~= 'char_add' then
				if petCnt == 0 then
					child:Resize(child:GetWidth(), CHAR_LIST_CLOSE_HEIGHT - 20);
				elseif petCnt >= 1 then
					local height = CHAR_LIST_CLOSE_HEIGHT + ((petCnt-1) * 35) + 5;
					child:Resize(child:GetWidth(), height);
				end
				detail:ShowWindow(0);
				btn:SetSkinName('character_off');

			end
		end
	end
	GBOX_AUTO_ALIGN(scrollBox, 10, 10, 10, true, false);
end

function SELECT_CHARBTN_LBTNUP(parent, ctrl, cid, argNum)
	local pcPCInfo = session.barrack.GetMyAccount():GetByStrCID(cid);
	if pcPCInfo == nil then
		return;
	end

	local lbtnupScp = barrack.GetLBtnDownScript();
	if lbtnupScp == "COMPANION_SELECT_PC" then
		barrack.SetLBtnDownScript("None");
		local selActor = barrack.GetPCByID(cid);
		COMPANION_SELECT_PC(selActor);
		return;
	end
	
	local mainBox = parent:GetParent();
	barrack.SelectCharacterByCID(cid);
	CUR_SELECT_GUID = cid;

	local parentFrame = mainBox:GetTopParentFrame();
	UPDATE_SELECT_CHAR_SCROLL(parentFrame);
	UPDATE_PET_BTN_SELECTED();
end

function DELETE_CHAR_SCROLL(ctrl, btn, cid, argNum)	
	-- 스크롤 캐릭터 삭제 버튼
    cid = CUR_SELECT_GUID
	local acc = session.barrack.GetMyAccount();
	local petVec = acc:GetPetVec();

	if petVec:size() ~= 0 then
		for i = 0 , petVec:size() -  1 do
			local pet = petVec:at(i);
			local pcID = pet:GetPCID()
			if pcID == cid then
				ui.SysMsg(ScpArgMsg("BeTogetherWithCompanionReallyDelete"));
				return
			end
		end
	end

	local bpc = barrack.GetBarrackPCInfoByCID(cid);
	if bpc == nil then
		return;
	end

	if 0 < bpc:GetDummyPCZoneID() then 
		ui.MsgBox(ScpArgMsg("CanDelChrBecauseDummyPC"));
		return;
	end

	if IsFinalRelease() == true then
		local isHaveEquipItem = 0		
		for i = 0 , item.GetEquipSpotCount() - 1 do
			local eqpObj = bpc:GetEquipObj(i);
			if eqpObj ~= nil then
				local obj = GetIES(eqpObj);			
				if 0 == item.IsNoneItem(obj.ClassID) then
					--착용중인 아이템이 있음	
					isHaveEquipItem = 1;
					break;
				end
			end	
		end
		

		if isHaveEquipItem == 1 then
			ui.MsgBox(ScpArgMsg("CantDelCharBecauseHaveEquipItem"));
			return;
		end
	end

	CHECK_MARKET_REGISTERED(cid);
end

function CHECK_MARKET_REGISTERED(cid)
	barrack.SelectCharacterByCID(cid);
	barrack.CheckMarketRegistered();	
end

function SELECTCHARINFO_DELETECHARACTER(frame, obj, argStr, argNum)
	imcSound.PlaySoundEvent('button_click_big_2');
	barrack.DeleteCharacter();
--	ui.GetFrame('selectcharmenu'):ShowWindow(0);
end

function SELECTCHARINFO_DELETECHARACTER_CANCEL(frame, obj, argStr, argNum)
	imcSound.PlaySoundEvent('button_click_big');
end

function SELECTTEAM_UPDATE_BTN_TITLE(frame)
	DESTROY_CHILD_BYNAME(frame, 'PET_ICON');

	local acc = session.barrack.GetMyAccount();
	local petVec = acc:GetPetVec();
	if petVec:size() == 0 then
		return;
	end

	for i = 0 , petVec:size() -  1 do
		local pet = petVec:at(i);
		local pcID = pet:GetPCID()
		local pcActor = barrack.GetPCByID(pcID);
		if pcActor ~= nil then
			local brk = GetBarrackSystem(pcActor);
			local btn = frame:GetChild("btn_" .. brk:GetCIDStr());
			if btn ~= nil then
				local x = btn:GetX();
				local y  = btn:GetY();
				local pic = frame:CreateControl("picture", "PET_ICON_" ..pet:GetStrGuid(), x + btn:GetWidth() + 25, y + 3, 64, 64);
				pic = tolua.cast(pic, "ui::CPicture");
				pic:SetEnableStretch(1);

				local monCls = GetClassByType("Monster", pet:GetPetType());
				pic:SetImage(monCls.Icon);

				local tooltipText = "{@st42}" .. ScpArgMsg("BeTogetherWithCompanion[{Name}]", "Name", pet:GetName());
				pic:SetTextTooltip(tooltipText);
			end

		end
	end
	
end

function SELECTTEAM_ON_MSG(frame, msg, argStr, argNum, ud)

	if g_barrackIndunCategoryList == nil then
		g_barrackIndunCategoryList = {100, 10000, 400, 800, 200, 300, 500};
	end
	if msg == "BARRACK_ADDCHARACTER" then
		SELECTTEAM_NEW_CTRL(frame, ud);

	elseif msg == "BARRACK_NEWCHARACTER" then
		SELECTTEAM_NEW_CTRL(frame, ud);
		
	elseif msg == "BARRACK_SLOT_BUY" then
		SELECTTEAM_NEW_CTRL(frame)
		BARRACK_GO_CREATE_RETRY(frame);
	elseif msg == "BARRACK_SELECT_BTN" then
		local argStr = frame:GetUserValue("BarrackMode");
		if argStr ~= "Barrack" then
			return;
		end

		local account = session.barrack.GetMyAccount();
		local bpc = account:GetBySlot(argNum);
        session.barrack.SetSelectSlot(tonumber(argNum))
		local gameStartFrame = ui.GetFrame('barrack_gamestart')
		if argNum == 0 or bpc == nil then
			gameStartFrame:ShowWindow(0);
		else
            local now_select_slot = tonumber(argNum)
			local char_controlset = GET_CHILD_RECURSIVELY(frame, 'char_' .. tostring(bpc:GetCID()))
			if char_controlset ~= nil then
            local y_pos = tonumber(char_controlset:GetY())            
            local ret = math.floor(y_pos / 200)
            if now_select_slot > prev_select_slot then  -- down
                y_pos = (200 * ret)                
            else    -- up                
                y_pos = (150 * ret)
            end
            local scroll_bar = GET_CHILD_RECURSIVELY(frame, 'ScrollBox')
            scroll_bar:SetScrollPos(math.abs(tonumber(y_pos - 10)))                    
            prev_select_slot = now_select_slot
			START_GAME_SET_MAP(gameStartFrame, argNum, bpc:GetApc().mapID, bpc:GetApc().channelID);
			end
			gameStartFrame:ShowWindow(1);
		end
	elseif msg == "BARRACK_SELECTCHARACTER" then    
		ON_CLOSE_BARRACK_SELECT_MONSTER();
		CUR_SELECT_GUID = argStr;
		UPDATE_SELECT_CHAR_SCROLL(frame);
		UPDATE_PET_BTN_SELECTED();
		SELCOMPANIONINFO_ON_SELECT_CHAR(argStr);        
	elseif msg == "BARRACK_NAME" then
		local barrack_name_frame = ui.GetFrame('barrack_name')
		local teamlevel = GET_CHILD(barrack_name_frame, "teamlevel");
		local nameCtrl = GET_CHILD(barrack_name_frame, "barrackname");
		nameCtrl:SetText("{@st43}{#ffcc33}"..argStr..ScpArgMsg("BarrackNameMsg").."{/}");
		nameCtrl:SetPos(teamlevel:GetX() + teamlevel:GetWidth() + 20,nameCtrl:GetY());

	elseif msg == "SET_BARRACK_MODE" then
		SET_BARRACK_MODE(frame, argStr, argNum);
	elseif msg == "UPDATE_SELECT_BTN_TITLE" then
		INIT_BARRACK_NAME(frame);
		SELECTTEAM_UPDATE_BTN_TITLE(frame);	
		UPDATE_BARRACK_PET_BTN_LIST()
	elseif msg == "BARRACK_NAME_CHANGE_RESULT" then		
		-- tp표시갱신
		SELECTTEAM_NEW_CTRL(frame, ud);
		BARRACK_THEMA_UPDATE(ui.GetFrame("barrackthema"))
	elseif msg == "BARRACK_ACCOUNT_PROP_UPDATE" then
		DRAW_BARRACK_MEDAL_COUNT(frame);
	end
	SELECTCHAR_RE_ALIGN(frame);
end

function BARRACK_GO_CREATE()
    if IS_FULL_SLOT_CURRENT_LAYER() == true then
        ui.SysMsg(ScpArgMsg("{layer}LayerFull", 'layer', current_layer))
        return
    end
	barrack.GoCreate()
	ui.CloseFrame("inputstring")
	ui.CloseFrame("barrackthema")
end

function BARRACK_GO_CREATE_RETRY()	
	local accountInfo = session.barrack.GetMyAccount();
	if accountInfo ~= nil then
		local myCharCont = accountInfo:GetTotalSlotCount();
		local buySlot = accountInfo:GetBuySlotCount();
		local barrackCls = GetClass("BarrackMap", accountInfo:GetThemaName());
		if barrackCls ~= nil then
			local baseSlot = barrackCls.BaseSlot;
			if baseSlot + buySlot > myCharCont then
				BARRACK_GO_CREATE();
			end
		end
	end
end

function SELECT_COMPANION_BTNUP(parent, ctrl, argStr, argNum, selectBarrackChar)
	
	local btn = parent:GetChild("btn");
	local mainBox = parent:GetParent();

	local petID = mainBox:GetUserValue("PET_ID");
	CUR_SELECT_PET_ID = petID;
	if selectBarrackChar ~= 0 then	
		barrack.SelectPetByGuid(petID);
	end

end

function SELECTCHAR_RE_ALIGN(frame)
	local btnCtn = 0;
	local height = 70;
	for i=0, frame:GetChildCount()-1 do
		local child = frame:GetChildByIndex(i);
		if child ~= nil then
			if string.find(child:GetName(), 'btn_') ~= nil then
				local xPos = 10;
				local yPos = (btnCtn * (height+4)) + 30;
				child:SetOffset(xPos, yPos);
				btnCtn = btnCtn + 1;
				child:ShowWindow(1);
			end
		end
	end
end

function SELECTCHARINFO_DELETE_CTRL(frame, obj, argStr, argNum)        
	local parentFrame = frame:GetTopParentFrame();
	local scrollBox = parentFrame:GetChild("scrollBox");
	local deleteCtrl = scrollBox:GetChild('char_'.. argStr);
	if deleteCtrl ~= nil then
		scrollBox:RemoveChild('char_'..argStr);
	end
	UPDATE_SELECT_CHAR_SCROLL(parentFrame);
	UPDATE_PET_BTN_SELECTED();
	frame:Invalidate();

	local myaccount = session.barrack.GetMyAccount();
	local barrackName = ui.GetFrame("barrack_charlist");
	local pccount = barrackName:GetChild("pccount");
	pccount:ShowWindow(1);
	local buySlot = myaccount:GetBuySlotCount();
	local myCharCont = myaccount:GetPCCount();
	local barrackCls = GetClass("BarrackMap", myaccount:GetThemaName());
	pccount:SetTextByKey("curpc", tostring(myCharCont));
	local maxpcCount = barrackCls.BaseSlot + buySlot;
	pccount:SetTextByKey("maxpc", tostring(maxpcCount));

	local barrackName = ui.GetFrame("barrack_name");
	local teamlevel = barrackName:GetChild("teamlevel");
	local account = session.barrack.GetCurrentAccount();
	teamlevel:SetTextByKey("value", account:GetTeamLevel());
end


function SELECTTEAM_OPEN_BARRACK_SETTING(frame, btnCtrl, argStr, argNum)

	if frame == nil then
		frame = ui.GetFrame("barrack_name");
		btnCtrl = frame:GetChild("setting");
	end

	local newframe = ui.GetFrame("inputstring");
	newframe:SetUserValue("InputType", "Family_Name");
	
	local acc = session.barrack.GetMyAccount();
	INPUT_STRING_BOX(ClMsg("Family Name"), "BARRACK_SETTING_SAVE", acc:GetFamilyName(), 0, 16);
end

function BARRACK_VISIT_MSGBOX(frame)

	INPUT_STRING_BOX_CB(frame, ScpArgMsg("Auto_aiDiLeul_ipLyeogHaSeyo"), "EXEC_VISIT_BARRACK");

end

function EXEC_VISIT_BARRACK(frame, str)
	if str == "" then
		return;
	end
	barrackVisit.Visit(str);
end

function EXEC_GO_HOME_BARRACK(frame, btnCtrl, argStr, argNum)

	barrackVisit.GoHome();

end

function SELECTTEAM_OPEN_CHAT(frame)

	local frame = ui.GetFrame("barracksimplechat");
	if frame:IsVisible() == 1 then
		frame:ShowWindow(0);
	else
		frame:ShowWindow(1);
		BARRACK_CHAT_ACQUIRE_FOCUS(frame, 0.1);
	end
end

function UPDATE_BARRACK_MODE(frame)
	local argStr = frame:GetUserValue("BarrackMode");
	
	if argStr == "Barrack" then
		SELECTCHAR_RE_ALIGN(frame);
		SHOW_BTNS(frame, 1)

	elseif argStr == "Visit" then
		-- 다른 숙소 방문할땐 캐릭생성관련 버튼은 숨긴다.
		SHOW_BTNS(frame, 0)

		local barrack_nameUI = ui.GetFrame("barrack_name");
		local gbox_tp_all = barrack_nameUI:GetChild("gbox_tp_all");
		if gbox_tp_all ~= nil then
			gbox_tp_all:RemoveAllChild();
			barrack_nameUI:RemoveChild("gbox_tp_all");
			barrack_nameUI:RemoveChild("upgrade");
			barrack_nameUI:RemoveChild("teaminfo");
			barrack_nameUI:RemoveChild("postbox");
			barrack_nameUI:RemoveChild("postbox_new");
		end;

		local pccount = frame:GetChild("pccount");
		pccount:ShowWindow(0);

		-- local barrack_exit = ui.GetFrame("barrack_exit");
		-- local postbox = barrack_exit:GetChild("postbox");
		-- if nil == postbox then
		-- 	return;
		-- end

		-- local postbox_new = GET_CHILD(barrack_exit, "postbox_new");
		-- postbox:ShowWindow(0);
		-- postbox_new:ShowWindow(0);
	end
end

function DRAW_SELECT_LAYER_BUTTON_ACTIVITY(frame, layer)
    local pccount = GET_CHILD(frame, "pccount", "ui::CRichText");
	local layerCtrl_1 = GET_CHILD(frame, "changeLayer1", "ui::CButton");
	local layerCtrl_2 = GET_CHILD(frame, "changeLayer2", "ui::CButton");
	local layerCtrl_3 = GET_CHILD(frame, "changeLayer3", "ui::CButton");
	if tostring(layer) == '1' then
		layerCtrl_1:SetImage('barrack_on_one_btn');
		layerCtrl_2:SetImage('barrack_off_two_btn');
		layerCtrl_3:SetImage('barrack_off_three_btn');
		pccount:SetTextByKey("value", '1');        
	elseif tostring(layer) == '2' then
		layerCtrl_1:SetImage('barrack_off_one_btn');
		layerCtrl_2:SetImage('barrack_on_two_btn');
		layerCtrl_3:SetImage('barrack_off_three_btn');
		pccount:SetTextByKey("value", '2');        
	else
		layerCtrl_1:SetImage('barrack_off_one_btn');
		layerCtrl_2:SetImage('barrack_off_two_btn');
		layerCtrl_3:SetImage('barrack_on_three_btn');
		pccount:SetTextByKey("value", '3');        
	end

	frame:SetUserValue("SelectBarrackLayer", layer);
    current_layer = layer  
end

function SET_BARRACK_MODE(frame, argStr, layer)
	frame:SetUserValue("BarrackMode", argStr);
	UPDATE_BARRACK_MODE(frame);
	if argStr == "Preview" then
		ui.OpenFrame("barrackthema");
	end

	local scrollBox = frame:GetChild("scrollBox");
--	if argStr == "Barrack" then
--		CREATE_SCROLL_NEW_CHAR(frame);
--	else
--		scrollBox:RemoveChild('char_add');
--	end

	GBOX_AUTO_ALIGN(scrollBox, 10, 10, 10, true, false);

	frame:Invalidate();

	local gameStartUI = ui.GetFrame("barrack_gamestart");
	local start_game = GET_CHILD(gameStartUI, "start_game");	
	
	local create_info = gameStartUI:GetChild("create_info");
	local zone = gameStartUI:GetChild("zone");
	local channels = gameStartUI:GetChild("channels"); 

	if argStr == "Barrack" then
		start_game:SetTextByKey("value", ClMsg("StartGame"));
		create_info:ShowWindow(1);
		zone:ShowWindow(1);
		channels:ShowWindow(1);
	else
		start_game:SetTextByKey("value", ClMsg("Return"));
		create_info:ShowWindow(0);
		zone:ShowWindow(0);
		channels:ShowWindow(0);
	end
	
	DRAW_SELECT_LAYER_BUTTON_ACTIVITY(frame, layer)
	frame:SetUserValue("MovingBarrackLayer", 0);
end

function START_GAME_SET_MAP(frame, slotID, mapID, channelID)

	local zone = frame:GetChild("zone");
	local channels = GET_CHILD(frame, "channels", "ui::CDropList");
	local mapCls = GetClassByType("Map", mapID);
	zone:SetTextByKey("value", mapCls.Name);
	frame:SetUserValue("SLOT_ID", slotID);

	local zoneInsts = session.serverState.GetMap(slotID);
	if zoneInsts == nil then
		-- RequestMapState();
	else	
		channels:ClearItems();
	    	
        if mapCls ~= nil and (mapCls.ClassName == 'pvp_Mine' or mapCls.ClassName == 'pvp_Mine_2') then
            local zoneInst = zoneInsts:GetZoneInstByIndex(channelID)
            if zoneInst.channel < 10000 then
                local str, gaugeString = GET_CHANNEL_STRING(zoneInst, true)
			    channels:AddItem(zoneInst.channel, str, 0, nil, gaugeString.." ")
                channels:SelectItemByKey(0)
            else
                local cnt = zoneInsts:GetZoneInstCount();
		        for i = 0  , cnt - 1 do
			        local zoneInst = zoneInsts:GetZoneInstByIndex(i);
			        local str, gaugeString = GET_CHANNEL_STRING(zoneInst, true);
			        channels:AddItem(zoneInst.channel, str, 0, nil, gaugeString.." ");
		        end
                channels:SelectItemByKey(channelID);
            end            
        else
            local cnt = zoneInsts:GetZoneInstCount();
		    for i = 0  , cnt - 1 do
			    local zoneInst = zoneInsts:GetZoneInstByIndex(i);
			    local str, gaugeString = GET_CHANNEL_STRING(zoneInst, true);
			    channels:AddItem(zoneInst.channel, str, 0, nil, gaugeString.." ");
		    end
            channels:SelectItemByKey(channelID);
        end        
	end
end

function SELECT_GAMESTART_CHANNEL(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local channels = GET_CHILD(frame, "channels", "ui::CDropList");

	local slotID = frame:GetUserIValue("SLOT_ID");
	local acc = session.barrack.GetMyAccount();
	local pc = acc:GetBySlot(slotID);

	local key = channels:GetSelItemKey();    
	pc:GetApc():SetChannelID(key);

end

function BARRACK_TO_GAME()	
	if IS_SEASON_SERVER() == "YES" and IS_SEASON_SERVER_OPEN() == false then
		if session.IsGM() ~= 1 then
			ui.SysMsg(ClMsg("SeasonServerCannotZoneEnter"));
            return;
        end
	end
	
	local myaccount = session.barrack.GetMyAccount();
	if nil == myaccount then
		return;
	end
	local myCharCount = myaccount:GetTotalSlotCount();	
	local buySlot = myaccount:GetBuySlotCount();
	local barrackCls = GetClass("BarrackMap", myaccount:GetThemaName());
	local maxCharCount = barrackCls.BaseSlot + buySlot;
	
	if 0 == PostponeCharCount() and myCharCount > maxCharCount then
		ui.SysMsg(ScpArgMsg("Many{CharCount}Than{CharSlot}CantStartGame", "CharCount", myCharCount, "CharSlot", maxCharCount));
	else
		local bpc = barrack.GetGameStartAccount();
		if bpc ~= nil then
			local apc = bpc:GetApc();

			local jobid	= apc:GetJob();
			local level = apc:GetLv();
		
			local JobCtrlType = GetClassString('Job', jobid, 'CtrlType');

			config.SetConfig("LastJobCtrltype", JobCtrlType);
			config.SetConfig("LastPCLevel", level);
		end
		local frame = ui.GetFrame("barrack_gamestart")
		local channels = GET_CHILD(frame, "channels", "ui::CDropList");
		local key = channels:GetSelItemIndex();
		app.BarrackToGame(key);
	end	
end

function UPDATE_BARRACK_PET_BTN_LIST()
	
	local account = session.barrack.GetCurrentAccount();
	local petVec = account:GetPetVec();

	local frame = ui.GetFrame("barrack_charlist");
	local scrollBox = frame:GetChild("scrollBox");

	for i = 0 , scrollBox:GetChildCount() -1 do
		local charCtrl = scrollBox:GetChildByIndex(i);
		DESTROY_CHILD_BYNAME(charCtrl, "attached_pet_");
		charCtrl:SetUserValue("PET_COUNT", 0);
	end	
	
	local offsetX = 120;
	for i = 0 , petVec:size() - 1 do
		local pet = petVec:at(i);
		local pcID = pet:GetPCID();
		local bpc = account:GetByStrCID(pcID);
		if bpc ~= nil then
			local charCtrl = scrollBox:GetChild("char_" .. pcID);
			if charCtrl ~= nil then
				
				local bpcPetCount = charCtrl:GetUserIValue("PET_COUNT");
				charCtrl:SetUserValue("PET_COUNT", bpcPetCount + 1);
				local addtionalY = 0;
				if bpcPetCount > 0 then
				 	addtionalY = 5;
				end
				local height = ui.GetControlSetAttribute("barrack_pet_mini", "height") / 2;
				local petCtrl = charCtrl:CreateOrGetControlSet('barrack_pet_mini', 'attached_pet_'..pet:GetStrGuid(), 50, 75 + (height * bpcPetCount) + addtionalY );
				
				UPDATE_PET_BTN(petCtrl, pet, true);
			end
		end
	end
	--다른 유저의 숙소를 방문할 때 그 유저의 컴페니언을 찾기 위해 방문중임을 알려준다
	local charlist = ui.GetFrame("barrack_charlist");
	UPDATE_PET_LIST(charlist:GetUserValue('BarrackMode'))	
	UPDATE_SELECT_CHAR_SCROLL(frame)
end

function UPDATE_PET_BTN_SELECTED()
	local frame = ui.GetFrame("barrack_petlist");
	local bg = frame:GetChild("bg");
	for i = 0 , bg:GetChildCount() - 1 do
		local petCtrl = bg:GetChildByIndex(i);
		local mainBox = GET_CHILD(petCtrl,'mainBox','ui::CGroupBox');
		if mainBox ~= nil then
			local btn = mainBox:GetChild("btn");
			local petID = petCtrl:GetUserValue("PET_ID");            
			if petID == CUR_SELECT_GUID then
				btn:SetSkinName('companion_on');
			else
				btn:SetSkinName('companion_off');
			end		
		end
	end
end

function UPDATE_PET_BTN(petCtrl, petInfo, useDetachBtn)

	local account = session.barrack.GetCurrentAccount();
	local myaccount = session.barrack.GetMyAccount();

	local mainBox = GET_CHILD(petCtrl,'mainBox','ui::CGroupBox');
	
	local obj = GetIES(petInfo:GetObject());
	local name = GET_CHILD_RECURSIVELY(mainBox, "name")
	name:SetTextByKey("value", petInfo:GetName());
	local level = GET_CHILD_RECURSIVELY(mainBox, "level");
	level:SetTextByKey("value", obj.Lv);
	mainBox:SetUserValue("PET_ID", petInfo:GetStrGuid());
	petCtrl:SetUserValue("PET_ID", petInfo:GetStrGuid());
	
	local char_icon = GET_CHILD(mainBox, "char_icon", "ui::CPicture");
	--char_icon:SetImage(obj.Icon);
	local char_icon_ = GET_CHILD(mainBox, "char_icon_", "ui::CPicture");

	local revive_btn = GET_CHILD(mainBox, "revive_btn", "ui::CButton");
	if revive_btn ~= nil then
		revive_btn:ShowWindow(0);
	end

	if useDetachBtn == false  then
		
		char_icon:SetImage(obj.Icon);
		local btn = mainBox:GetChild("btn");
		btn:SetSkinName('companion_on');
		if account == myaccount then
			btn:SetEventScript(ui.LBUTTONUP, "SELECT_COMPANION_BTNUP");
		end
	
		local job = mainBox:GetChild("job");
		job:SetTextByKey("value", obj.Name);

		local detach_btn = GET_CHILD(mainBox, "detach_btn", "ui::CButton");
		if account ~= myaccount then
			detach_btn:ShowWindow(0);
			return;
		end

		detach_btn:SetImage('barrack_delete_btn');
		detach_btn:SetEventScript(ui.LBUTTONUP, "REQUEST_DELETE_PET");
		
		if obj.OverDate == 10 then
			if revive_btn ~= nil then
				revive_btn:ShowWindow(1);
				revive_btn:SetEventScript(ui.LBUTTONUP, "REQUEST_PET_REVIVE");
			end
		end
			
	elseif useDetachBtn == true then

		local iconName = 'test_companion_01';
		
		if obj ~= nil then
			iconName =	obj.Icon
		end

		char_icon:SetImage(iconName);
		char_icon_:SetImage("barrack_pet_profile_skin")
		local detach_btn = GET_CHILD(mainBox, "detach_btn", "ui::CButton");
		if account ~= myaccount then
			detach_btn:ShowWindow(0);
			return;
		end
		
		detach_btn:SetImage('button_cc_delete');
		detach_btn:SetEventScript(ui.LBUTTONUP, "DETACH_PET_FROM_PC");		
	end	
end

function DETACH_PET_FROM_PC(parent, ctrl)

	local mainBox = parent:GetParent();
	local petGuid = mainBox:GetUserValue("PET_ID");

	local pet = barrack.GetPet(petGuid);
	local brkSystem = GetBarrackSystem(pet);
	brkSystem:SetPetPC(nil);
	
end

function REQUEST_PET_REVIVE(parent, ctrl)

	local mainBox = parent:GetParent();
	local petGuid = mainBox:GetUserValue("PET_ID");
	local pet = barrack.GetPet(petGuid);
	local brkSystem = GetBarrackSystem(pet);
	local petInfo = brkSystem:GetPetInfo();
	local monCls = GetClassByType("Monster", petInfo:GetPetType());
	local obj = GetIES(petInfo:GetObject());

	local priceStr = PET_REVIVE_PRICE(obj) .. " " .. ScpArgMsg("NXP");
	local msg = ScpArgMsg("ReviveCompanion?{Price}WillBeConsumed", "Price", priceStr);
	local execScript = string.format("_EXEC_REVIVE_PET(\"%s\")", petGuid);
	ui.MsgBox(msg, execScript, "None");

end

function _EXEC_REVIVE_PET(petGuid)
	local selFrame = OPEN_BARRACK_SELECT_PC_FRAME("GIVE_PET_REVIVE_ITEM", "SelectCharacterToGetRevivedPetEgg", true);
	selFrame:SetUserValue("PET_GUID", petGuid);
end

function GIVE_PET_REVIVE_ITEM(pcName)
	local selectFrame = ui.GetFrame("postbox_itemget");
	selectFrame:ShowWindow(0);

	local petGuid = selectFrame:GetUserValue("PET_GUID");
	local accountInfo = session.barrack.GetMyAccount();
	local pcInfo = accountInfo:GetByPCName(pcName);

	barrack.RequestReviveDeadPet(petGuid, pcInfo:GetCID());	
end

function REQUEST_DELETE_PET(parent, ctrl)
	local mainBox = parent:GetParent();
	local petGuid = mainBox:GetUserValue("PET_ID");
	local pet = barrack.GetPet(petGuid);
	local brkSystem = GetBarrackSystem(pet);

	local petInfo = brkSystem:GetPetInfo();

	if petInfo:HasItemEquipped() == true then
		ui.MsgBox(ClMsg('CantDelCharBecauseHaveEquipItem'))
		return
	end
	if IsFinalRelease() == true then
		DELETE_WARNING_BOX_ON_INIT(11, petGuid);
		--UPDATE_BARRACK_PET_BTN_LIST();
		CHAR_N_PET_LIST_LOCKMANGED(0);
		return;
	end	


	local monCls = GetClassByType("Monster", petInfo:GetPetType());
	
	local nameStr = string.format("%s (%s)", petInfo:GetName(), monCls.Name);
	local msg = ScpArgMsg("ReallyDelete{Name}", "Name", nameStr);
	local execScript = string.format("_EXEC_DELETE_PET(\"%s\", \"%s\")", petGuid, brkSystem:GetCIDStr());
	ui.MsgBox(msg, execScript, "None");
end

function _EXEC_DELETE_PET(petGuid, charCID)
	barrack.RequestDeletePet(petGuid, charCID);
end

function CHAR_N_PET_LIST_LOCKMANGED(unlock)
	local charFrame = ui.GetFrame("barrack_charlist");
	local petFrame = ui.GetFrame("barrack_petlist");
	charFrame:SetEnable(unlock);
	petFrame:SetEnable(unlock);
end

function ON_RESULT_CHECK_MARKET(frame, msg, cid, registered)	
	barrack.SelectCharacterByCID(cid);
	local jobName = barrack.GetSelectedCharacterJob();
	local charName = barrack.GetSelectedCharacterName();
	local clmsg = "{nl} {nl}{s22}"..jobName.." {@st43}"..charName..ScpArgMsg("Auto_{/}{nl}{s22}KaeLigTeoLeul_SagJeHaKessSeupNiKka?");
	if registered == 1 then	
		clmsg = ClMsg('RegisterItemAtMarketPC')..clmsg;
	end
	ui.MsgBox(clmsg, 'SELECTCHARINFO_DELETECHARACTER', 'SELECTCHARINFO_DELETECHARACTER_CANCEL');
end