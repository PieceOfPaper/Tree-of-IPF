function GODPROTECTION_ON_INIT(addon, frame)
	addon:RegisterMsg('FIELD_BOSS_WORLD_EVENT_START', 'GODPROTECTION_START');
	addon:RegisterMsg('FIELD_BOSS_WORLD_EVENT_END', 'GODPROTECTION_END');

	addon:RegisterMsg('FIELD_BOSS_WORLD_EVENT_ITEM_GET', 'GODPROTECTION_ITEM_GET');
	addon:RegisterMsg('FIELD_BOSS_WORLD_EVENT_LEGEND_ITEM_GET', 'GODPROTECTION_LEGEND_ITEM_GET');
end

-- 아이콘으로 UI 오픈
function GODPROTECTION_DO_OPEN()
	local frame = ui.GetFrame("godprotection");
	ui.OpenFrame("godprotection");

	local silvercost = session.GodProtection.GetSilverCost();
	local silver = GET_CHILD_RECURSIVELY(frame, 'dedication_silver');
	silver:SetText(silvercost);

	GODPROTECTION_DEDICATION_INIT()
	GODPROTECTION_REMAIN_TIME(frame)
	GODPROTECTION_ITME_LIST_UPDATE(frame)
end

function GODPROTECTION_OPEN(frame)
	local spinepic = GET_CHILD_RECURSIVELY(frame, 'spinepic');
	spinepic:ShowWindow(1);

	GODPROTECTION_SPINE(frame);
end

function GODPROTECTION_CLOSE(frame)
	if ui.CheckHoldedUI() == true then
        return;
	end

	ui.CloseFrame("godprotection");
end

-- 남은 시간 설정 -------------------------------------
function GODPROTECTION_REMAIN_TIME(frame)	
	local endtime = session.GodProtection.GetEndTime();
	local remainsec = imcTime.GetDifSec(endtime, geTime.GetServerSystemTime());
	if remainsec < 0 then
		return 0;
	end
	
	local time = GET_CHILD_RECURSIVELY(frame, 'time');
	time:RunUpdateScript("UPDATE_GODPROTECTION_REMAIN_TIME", 0.1);
	UPDATE_GODPROTECTION_TIME_CTRL(time, remainsec)
end

function UPDATE_GODPROTECTION_REMAIN_TIME(ctrl)	
	local endtime = session.GodProtection.GetEndTime();
	local remainsec = imcTime.GetDifSec(endtime, geTime.GetServerSystemTime());
	if remainsec < 0 then
		return 0;
	end

	UPDATE_GODPROTECTION_TIME_CTRL(ctrl, remainsec)

	return 1;
end

function UPDATE_GODPROTECTION_TIME_CTRL(ctrl, remainsec, isClear)
	local min = math.floor(remainsec/60)
	local sec = math.floor(remainsec%60)

	if isClear == true then
		local frame = ctrl:GetTopParentFrame();
		local font = frame:GetUserConfig("TIME_FONT_NOMAL");
		ctrl:SetFormat(font..ClMsg("RemainTime").." %s"..ClMsg("UI_Min").." %s"..ClMsg("UI_Sec"));
		ctrl:ReleaseBlink();
	elseif min < 1 then
		local frame = ctrl:GetTopParentFrame();
		ctrl = tolua.cast(ctrl, 'ui::CRichText');
		local font = frame:GetUserConfig("TIME_FONT_ONEMINUTE");
		if font ~= nil then
			ctrl:SetFormat(font..ClMsg("RemainTime").." %s"..ClMsg("UI_Min").." %s"..ClMsg("UI_Sec"));
			ctrl:SetBlink(600000, 1.0, "55FFFFFF", 1);
		end
	end

	ctrl:SetTextByKey('min', min);
	ctrl:SetTextByKey('sec', sec);

end
--------------------------------------------------------

-- 일반 아이템 정보 설정 (초기화)
function GODPROTECTION_ITME_LIST_INIT(frame)
	if frame == nil then
		frame = ui.GetFrame("godprotection");
	end

	local allcnt = tonumber(frame:GetUserConfig("ALL_ITEM_COUTN"));
	local legendcnt = tonumber(frame:GetUserConfig("LEGEND_ITEM_COUTN"));
	local cnt = session.GodProtection.GetItemListCount();
	-- slot 12 부터 생성, 일반 아이템 슬롯만 설정
	for i = allcnt - 1, 2, -1 do
		cnt = cnt - 1;
		slot = GET_CHILD_RECURSIVELY(frame, 'slot_'..i);
		if slot ~= nil then
			local itemid = session.GodProtection.GetItemIDbyIndex(cnt);	
			local itemCls = GetClassByType('Item', itemid);
			if itemCls ~= nil then
				SET_SLOT_IMG(slot, itemCls.Icon);
				SET_ITEM_TOOLTIP_BY_TYPE(slot:GetIcon(), itemCls.ClassID);
				slot:GetIcon():SetTooltipOverlap(1);
				slot:SetUserValue("ITEM_ID", itemid);
			end
		end		
	end 

	-- 레전드 아이템 slot 설정
	GODPROTECTION_ITME_LIST_UPDATE(frame);
end

-- 레전드 아이템 slot 설정
function GODPROTECTION_ITME_LIST_UPDATE(frame)
	if frame == nil then
		frame = ui.GetFrame("godprotection");
	end

	local legendcnt = tonumber(frame:GetUserConfig("LEGEND_ITEM_COUTN"));
	for i = 0, legendcnt - 1 do
		slot = GET_CHILD_RECURSIVELY(frame, 'slot_'..i);
		if slot ~= nil then
			local itemid = session.GodProtection.GetLegendItemIdbyIndex(i);
			local itemCls = GetClassByType('Item', itemid);
			if itemCls ~= nil then
				SET_SLOT_IMG(slot, itemCls.Icon);
				SET_ITEM_TOOLTIP_BY_TYPE(slot:GetIcon(), itemCls.ClassID);
				slot:GetIcon():SetTooltipOverlap(1);							
				slot:SetUserValue("ITEM_ID", itemid);

				local slot_pic = GET_CHILD_RECURSIVELY(frame, 'slot_'..i..'_pic');
				if session.GodProtection.GetIsLegendItembyIndex(i) == false then
					if slot_pic ~= nil then
						slot_pic:SetColorTone('FF444444');
					end
					
					if slot:GetIcon() ~= nil then
						slot:GetIcon():SetColorTone('FF444444');
					end
				end				
			end
		end		
	end 

end

-- 봉헌 버튼 클릭, 조건확인 
function GODPROTECTION_DEDICATION_CLICK(ctrl)
	if ui.CheckHoldedUI() == true then
        return;
	end
	
	local frame = ui.GetFrame("godprotection");

	local endtime = session.GodProtection.GetEndTime();
	local remainsec = imcTime.GetDifSec(endtime, geTime.GetServerSystemTime());
	if remainsec < 0 then
		return;
	end

	local silver = 0; 
	local silvercost = session.GodProtection.GetSilverCost();
	local invItem = session.GetInvItemByName('Vis');
	if invItem ~= nil then
		silver = tonumber(invItem:GetAmountStr());
	end

	if silver < silvercost then
		ui.SysMsg(ScpArgMsg("REQUEST_TAKE_SILVER"));		
		return;
	end

	-- 봉헌!
	ui.SetHoldUI(true);
	RequestBidFieldBossWorldEvent();
	GODPROTECTION_PLAY_DEDICATION_EFFECT(frame)    
	ReserveScript("BUTTON_UNFREEZE()", WORLD_EVENT_CLICK_DELAY);
end

function BUTTON_UNFREEZE()
	ui.SetHoldUI(false);
end

-- 획득 가능한 아이템 SLOT들, 버튼 이펙트
function GODPROTECTION_PLAY_DEDICATION_EFFECT(frame)
	local DEDICATION_BUTTON_EFFECT_NAME = frame:GetUserConfig('DEDICATION_BUTTON_EFFECT');
	local DEDICATION_BUTTON_EFFECT_SCALE = tonumber(frame:GetUserConfig('DEDICATION_BUTTON_EFFECT_SCALE'));
	local DEDICATION_BUTTON_EFFECT_DURATION = tonumber(frame:GetUserConfig('DEDICATION_BUTTON_EFFECT_DURATION'));
	local dedication_btn_gb = GET_CHILD_RECURSIVELY(frame, 'dedication_btn_gb');
	if dedication_btn_gb == nil then
		return;
	end
	dedication_btn_gb:PlayUIEffect(DEDICATION_BUTTON_EFFECT_NAME, DEDICATION_BUTTON_EFFECT_SCALE, 'DEDICATION_BUTTON_EFFECT');
    ReserveScript("_DEDICATION_EFFECT()", DEDICATION_BUTTON_EFFECT_DURATION);
end

function _DEDICATION_EFFECT()
	local frame = ui.GetFrame("godprotection");
	if frame:IsVisible() == 0 then
		return;
	end

	local dedication_btn_gb = GET_CHILD_RECURSIVELY(frame, 'dedication_btn_gb');
	if dedication_btn_gb ~= nil then
		dedication_btn_gb:StopUIEffect('DEDICATION_BUTTON_EFFECT', true, 0.5);
	end
end

function GODPROTECTION_RESULT_EFFECT(itemid)
	local frame = ui.GetFrame("godprotection");
	if frame:IsVisible() == 0 then
		return;
	end
	
	local btn = GET_CHILD_RECURSIVELY(frame, 'dedication_btn');
	btn:ShowWindow(0);

	local okbtn = GET_CHILD_RECURSIVELY(frame, 'dedication_okbtn');
	okbtn:ShowWindow(1);

	-- 획득 가능 아이템 slot 들 중 획득한 아이템 slot
	local RESULT_EFFECT_NAME = frame:GetUserConfig('RESULT_EFFECT');
	local RESULT_EFFECT_SCALE = tonumber(frame:GetUserConfig('RESULT_EFFECT_SCALE'));
	local RESULT_EFFECT_DURATION = tonumber(frame:GetUserConfig('RESULT_EFFECT_DURATION'));
	local resultslot = GODPROTECTION_GET_SLOT(itemid);
	if resultslot == nil then
		return;
	end

	resultslot:PlayUIEffect(RESULT_EFFECT_NAME, RESULT_EFFECT_SCALE, 'RESULT_EFFECT');
	ReserveScript("_DEDICATION_RESULT_EFFECT()", RESULT_EFFECT_DURATION);
end

function _DEDICATION_RESULT_EFFECT()
	local frame = ui.GetFrame("godprotection");
	if frame:IsVisible() == 0 then
		return;
	end
	
	local dedication_slot = GET_CHILD_RECURSIVELY(frame, 'dedication_slot');
	local itemid = dedication_slot:GetUserValue("ITEM_ID");
	local resultslot = GODPROTECTION_GET_SLOT(itemid);
	if resultslot == nil then
		return;
	end

	resultslot:StopUIEffect('RESULT_EFFECT', true, 0.5);
end

-- 꽝 아이템 획득
function GODPROTECTION_ITEM_GET(frame, msg, argStr, itemid)
	if itemid == 0 or itemid == "None" then
		return;
	end

	GODPROTECTION_DEDICATION_ITEM_GET(frame, itemid);	
	GODPROTECTION_RESULT_EFFECT(itemid);
end

--레전드 아이템 획득
function GODPROTECTION_LEGEND_ITEM_GET(frame, msg, argStr, itemid)
	if itemid == 0 or itemid == "None" then
		return;
	end

	if argStr == "MINE" then
		-- 자신이 레전드 아이템에 당첨되었을 경우 아이템이 마켓 보관함으로 지급되었다는 안내 필요
		ui.MsgBox_OneBtnScp(ScpArgMsg("GodProtectionItemToCabinet"), "GODPROTECTION_ITME_LIST_UPDATE");
		GODPROTECTION_DEDICATION_ITEM_GET(frame, itemid)
	else
		-- 다른사람이 획득했을 경우에는 UI변경
		GODPROTECTION_ITME_LIST_UPDATE(frame);
	end

	GODPROTECTION_RESULT_EFFECT(itemid);
end

-- 아이템 획득시 획득 아이템 slot 변경
function GODPROTECTION_DEDICATION_ITEM_GET(frame, itemid)
	local slot = GET_CHILD_RECURSIVELY(frame, 'dedication_slot');
	local itemCls = GetClassByType('Item', itemid);
	if itemCls ~= nil then	
		SET_SLOT_IMG(slot, itemCls.Icon);
		SET_ITEM_TOOLTIP_BY_TYPE(slot:GetIcon(), itemCls.ClassID);
		slot:GetIcon():SetTooltipOverlap(1);
		slot:SetUserValue("ITEM_ID", itemid);
	end

	-- 아이템 획득 사운드
	local GET_ITEM_SOUND = frame:GetUserConfig('GET_ITEM_SOUND');
    imcSound.PlaySoundEvent(GET_ITEM_SOUND);
end

-- 봉헌 · 확인 버튼, 획득 아이템 slot 초기화
function GODPROTECTION_DEDICATION_INIT()
	if ui.CheckHoldedUI() == true then
        return;
	end

	local frame = ui.GetFrame("godprotection");
	local dedication_slot = GET_CHILD_RECURSIVELY(frame, 'dedication_slot');
	dedication_slot:ClearIcon();

	local btn = GET_CHILD_RECURSIVELY(frame, 'dedication_btn');
	btn:ShowWindow(1);

	local okbtn = GET_CHILD_RECURSIVELY(frame, 'dedication_okbtn');
	okbtn:ShowWindow(0);
end

function GODPROTECTION_START(frame)
	if frame == nil then
		return;
	end

	local time = GET_CHILD_RECURSIVELY(frame, 'time');
	local font = frame:GetUserConfig("TIME_FONT_NOMAL");
	time:SetFormat(font..ClMsg("RemainTime").." %s"..ClMsg("UI_Min").." %s"..ClMsg("UI_Sec"));
	time:ReleaseBlink();

	local dedication_slot = GET_CHILD_RECURSIVELY(frame, 'dedication_slot');
	dedication_slot:ClearIcon();
	
	local silvercost = session.GodProtection.GetSilverCost();
	local silver = GET_CHILD_RECURSIVELY(frame, 'dedication_silver');
	silver:SetText(silvercost);

	GODPROTECTION_DEDICATION_INIT();
	GODPROTECTION_REMAIN_TIME(frame);	
	GODPROTECTION_ITME_LIST_INIT(frame);
end

function GODPROTECTION_END(frame)
	if frame == nil then
		return;
	end

	-- slivercost control 초기화
	local silvercost = session.GodProtection.GetSilverCost();
	local silver = GET_CHILD_RECURSIVELY(frame, 'dedication_silver');
	silver:SetText(0);

	-- time control 초기화
	local time = GET_CHILD_RECURSIVELY(frame, 'time');
	local font = frame:GetUserConfig("TIME_FONT_NOMAL");
	time:StopUpdateScript("UPDATE_GODPROTECTION_REMAIN_TIME");
	UPDATE_GODPROTECTION_TIME_CTRL(time, 0, true)

	ReserveScript("GODPROTECTION_SLOT_CLEAR()", 10);
end

function GODPROTECTION_SLOT_CLEAR()
	local frame = ui.GetFrame("godprotection");

	-- slot들 아이콘 초기화
	local allcnt = tonumber(frame:GetUserConfig("ALL_ITEM_COUTN"));
	for i = 0, allcnt - 1 do
		local slot = GET_CHILD_RECURSIVELY(frame, 'slot_'..i);
		local slot_pic = GET_CHILD_RECURSIVELY(frame, 'slot_'..i..'_pic');
		if slot_pic ~= nil then
			slot_pic:SetColorTone(0);
		end
			
		if slot:GetIcon() ~= nil then
			slot:GetIcon():SetColorTone(0);
		end
		slot:ClearIcon();
		slot:SetUserValue("ITEM_ID", "None");
	end
end

-- itemid로 해당 아이템이 출력되는 slot 반환
function GODPROTECTION_GET_SLOT(itemid)
	local frame = ui.GetFrame("godprotection");

	if itemid == "None" then
		return nil;
	end

	local allcnt = tonumber(frame:GetUserConfig("ALL_ITEM_COUTN"));
	for i = 0, allcnt - 1 do
		local slot = GET_CHILD_RECURSIVELY(frame, 'slot_'..i);
		local slotitemid = slot:GetUserValue("ITEM_ID");
		if tonumber(itemid) == tonumber(slotitemid) then
			return slot;
		end		 
	end

	return nil;
end
function GODPROTECTION_SPINE(frame)
	local frame = ui.GetFrame("godprotection");
    local picture = GET_CHILD_RECURSIVELY(frame, 'spinepic');
	local isEnableSpine = config.GetXMLConfig("EnableAnimateItemIllustration");
	if isEnableSpine == 1 then

		local spineToolTip = frame:GetUserConfig("SPINE");
		local spineInfo = geSpine.GetSpineInfo(spineToolTip);
		if spineInfo ~= nil then
			picture:CreateSpineActor(spineInfo:GetRoot(), spineInfo:GetAtlas(), spineInfo:GetJson(), "", spineInfo:GetAnimation());
		end	
	end
	
end
