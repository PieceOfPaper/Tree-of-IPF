-- jansori.lua

function JANSORI_MOVE_BALLOON_FRAME(tframe, x, y, moveYByFrameHeight)
	local textCtrl = tframe:GetChild("text");
	local width = textCtrl:GetWidth() + 30;
	local height = textCtrl:GetHeight() + 10;
	if moveYByFrameHeight ~= nil then
		height = height - tframe:GetHeight();
	end
	local retHeight = y - height;
	if retHeight < 10 then
		retHeight = 10;
	end

	tframe:MoveFrame(x - width, retHeight);
end

function JANSORI_SET_VALUE(clsName, value)
	local frame = ui.GetFrame("sysmenu");
	frame:SetUserValue("JANSORI_VAL_" .. clsName, value);
end

function GET_JS_TEXT(frame, cls)
	local txt = cls.Text;
	local funcTxt = string.sub(txt, 2, string.len(txt));
	if string.sub(txt, 1, 1) == "#" then
		local funcTxt = string.sub(txt, 2, string.len(txt));
		txt = _G[funcTxt](frame, cls);
	end

	local hideCond = cls.HideCond;
	if hideCond == "TextClick" then
		return "{a @JS_AUTOHIDE}" .. txt;
	end

	return txt;
end

function JS_AUTOHIDE(frame)
	JANSORI_SET_NOTIFIED(frame);
end


function JANSORI(frame)

	local clslist, cnt  = GetClassList("Jansori");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);
		local hideSec = frame:GetUserIValue("JS_HIDE_SEC_" .. cls.ClassName);

		-- 조건체크해서 바뀌었다면 아래 로직을 돈다.
		local curCond = -1;
		if JANSORI_IS_NOTIFIED(cls) then
			curCond = 0;
		end

		if curCond == -1 then
			if hideSec > imcTime.GetAppTime() then
				curCond = 0;
			else
				if cls.CondScp == "None" then
					curCond = frame:GetUserIValue("JANSORI_VAL_" .. cls.ClassName);
				else
					local condScp = _G[cls.CondScp];
					if condScp == nil then
						ErrorLog(cls.CondScp .. ScpArgMsg("Auto__HamSuKaeopeum_JanSoLiKeulLaeSeu_:_") .. cls.ClassName);
					else
						curCond = condScp(frame, cls);
					end

				end
			end
		end

		local frameName = "JANSORI_" .. cls.ClassName;
		local beforeCond = frame:GetUserIValue(frameName);
		if beforeCond ~= curCond then
			local condChangeScp = _G[cls.CondChangeScp];
			if condChangeScp ~= nil then
				condChangeScp(frame, curCond);
			end

			frame:SetUserValue(frameName, curCond);

			-- 프레임이 없다면 프레임을 생성
			local jsFrame = nil;
			if cls.TextImage ~= 'None' then
				jsFrame = MAKE_BALLOON_FRAME_IMAGE(cls.TextImage, GET_JS_TEXT(frame, cls), "{#050505}{s20}{b}",  frameName);
			end

			if jsFrame == nil then
				jsFrame = MAKE_BALLOON_FRAME(GET_JS_TEXT(frame, cls), 0, 0, nil, frameName, "{#050505}{s20}{b}", 1);
			end

			local x, y, moveYByFrameHeight = _G[cls.PosScp](frame, cls, jsFrame);
			JANSORI_MOVE_BALLOON_FRAME(jsFrame, x, y, moveYByFrameHeight);
			jsFrame:SetUserValue("ClassName", cls.ClassName);
			jsFrame:EnableHitTest(cls.HittestFrame);
			if curCond == 1 then
				jsFrame:ShowWindow(1);
				JANSORI_HIDE_FOR_SEC("cls.ClassName", 10);	-- 아무것도안해도 10초지나면 다시 보이지않게.
			else
				jsFrame:ShowWindow(0);
				JANSORI_CNT_NOTIFIED(cls);
			end
			
		else
			if curCond == 1 then
				local jsFrame = ui.GetFrame(frameName);
				if jsFrame ~= nil then
					local x, y, moveYByFrameHeight = _G[cls.PosScp](frame, cls, jsFrame);
					JANSORI_MOVE_BALLOON_FRAME(jsFrame, x, y, moveYByFrameHeight);
			
				end
			end
		end

	end

	return 1;
end

function JANSORI_IS_NOTIFIED(cls)

	local sObj = session.GetSessionObjectByName("Jansori");
	if sObj == nil then
		return false;
	end

	sObj = GetIES(sObj:GetIESObject());
	if cls.NotifyType == "Once" then
		if TryGet(sObj, cls.ClassName.. "_Clicked") == 1 then
			return true;
		end
	end

	local curCount = TryGet(sObj, cls.ClassName.. "_CurCnt");
	if curCount >= cls.NotifyMax then
    return true;
  end

	if cls.NotifyMin > 0 then
		local lastNotifyTime = TryGet(sObj, cls.ClassName.. "_LastTime");
		if lastNotifyTime > 0 then
			local curTime = geTime.GetServerDBTimeInFloat();
			local difff = curTime - lastNotifyTime;
			if curTime < lastNotifyTime + cls.NotifyMin then
				return true;
			end
		end
	end

	return false;
end

function _JANSORI_SET_NOTIFIED(clsName)

	local sObj = session.GetSessionObjectByName("Jansori");
	if sObj == nil then
		return;
	end

	local cls = GetClass("Jansori", clsName);
	sObj = GetIES(sObj:GetIESObject());
	if TryGet(sObj, clsName.. "_Clicked") == 0 then
		sObj[clsName.. "_Clicked"] = 1;
		control.CustomCommand("JANSORI_CLICK", cls.ClassID);
	end

	if cls.NotifyMin > 0 then
		local curTime = geTime.GetServerDBTimeInFloat();
		sObj[clsName.. "_LastTime"] = curTime;
		control.CustomCommand("JANSORI_SETTIME", cls.ClassID);
	end

end

function JANSORI_SET_NOTIFIED(frame)

	local clsName = frame:GetUserValue("ClassName");
	_JANSORI_SET_NOTIFIED(clsName);

end

function JANSORI_CNT_NOTIFIED(cls)

	local sObj = session.GetSessionObjectByName("Jansori");
	if sObj == nil then
		return;
	end

	sObj = GetIES(sObj:GetIESObject());

	--print('JANSORI_CNT_NOTIFIED : '..cls.ClassName..', '..TryGet(sObj, cls.ClassName.. "_CurCnt")..', '..cls.NotifyMax);

  local curCount = TryGet(sObj, cls.ClassName.. "_CurCnt");
	if curCount >= cls.NotifyMax then
    return;
	else
    sObj[cls.ClassName.. "_CurCnt"] = sObj[cls.ClassName.. "_CurCnt"] + 1;
	  control.CustomCommand("JANSORI_COUNT", cls.ClassID, sObj[cls.ClassName.. "_CurCnt"]);
  end

end

function JANSORI_HIDE_FOR_SEC(clsName, sec)

	local frame = ui.GetFrame("sysmenu");
	frame:SetUserValue("JS_HIDE_SEC_" .. clsName, imcTime.GetAppTime() + sec);

end

function JS_UPDATE_TEXT(frame, cls, jsFrame)
	local newText = GET_JS_TEXT(frame, cls);
	BALLOON_FRAME_SET_TEXT(jsFrame, newText);
end

-- ClassName : InvFull

function JS_INV_STATE_CHANGED(frame, cond)
	--[[
	if cond == 1 then
		
	else
		
	end
	]]
end

function JS_CHECK_INV_FULL(frame)

	local maxCnt = item.GetMaxInvSlotCount();
	local curCnt = session.GetInvItemList():Count();
	if curCnt >= maxCnt then
		return 1;
	end

	return 0;
end

function JS_INV_FULL_POS(frame, cls)

	local clsName = cls.ClassName;
	local lastY = -1;
	local clslist, cnt  = GetClassList("Jansori");

	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clslist, i);

		if cls.ClassName == clsName then
			break;
		end

		local frameName = "JANSORI_" .. cls.ClassName;
		if ui.IsFrameVisible(frameName) == 1 then
			local fr = ui.GetFrame(frameName);
			lastY = fr:GetGlobalY() + fr:GetHeight() - 10;
		end
	end

	local btn = frame:GetChild("inven");

	if btn == nil then
		return -500,-500;
	end

	local x, y = GET_GLOBAL_XY(btn);
	x = x - 10;
	y = y + btn:GetHeight() / 2;
	if lastY > 0 then
		y = lastY;
		return x, y, true;
	end
	return x, y;

end

function JS_INV_FULL_TEXT(frame)
	local rein_link = "{#003300}{a @UI_TUTO_REINF}";
	local shop_link = "{#003300}{a @UI_TUTO_SHOP}";
	return ScpArgMsg("Auto___SoJiPumi_KaDeug_ChassSeupNiDa.{nl}").. rein_link  .. ScpArgMsg("Auto___KangHwa{/}{/}Na_") .. shop_link .. ScpArgMsg("Auto_']'Ki_JeugSeogSangJeom{/}{/}e{nl}__PanMaeHaSeyo.");
end

function UI_TUTO_REINF(frame)
	JANSORI_SET_NOTIFIED(frame);
	ui.OpenFrame("inventory");
end

function UI_TUTO_SHOP(frame)
	JANSORI_SET_NOTIFIED(frame);	
	frame:EnableHideProcess(1);
	frame:RunUpdateScript("_UI_TUTO_AUTO_GOTO_SHOP", 0.8);

end

function _UI_TUTO_GOTO_REINFORCE(frame)

	JANSORI_HIDE_FOR_SEC("InvFull", 3);
	local sysFrame = ui.GetFrame("sysmenu");
	local btn = sysFrame:GetChild("inven");
	btn:PlayEvent("BIG_ITEM_GET");
	local x, y = GET_SCREEN_XY(btn);
	mouse.SetPos(x,y);
	frame:EnableHideProcess(0);
	sysFrame:RunUpdateScript("_UI_TUTO_OPEN_REINFORCE", 0.5);
	return 0;
end

function _UI_TUTO_AUTO_GOTO_SHOP(frame)
	JANSORI_HIDE_FOR_SEC("InvFull", 3);
	local sysFrame = ui.GetFrame("sysmenu");
	local btn = sysFrame:GetChild("shop");
	btn:PlayEvent("BIG_ITEM_GET");
	local x, y = GET_SCREEN_XY(btn);
	mouse.SetPos(x,y);
	sysFrame:RunUpdateScript("_UI_TUTO_OPEN_SHOP", 0.5);
	return 0;

end

function _UI_TUTO_OPEN_SHOP(frame)
	COMMON_SHOP_TOGGLE();
	return 0;
end

-- ClassName : InvHalf
function JS_CHECK_EQP_ITEMS(frame)
	local ssi = GET_INV_EQUIP_ITEM_COUNT();
	if ssi >= 15 then
		return 1;
	end

	return 0;
end


function JS_EQP_ITEMS_TEXT(frame)
	local rein_link = "{#003300}{a @UI_TUTO_REINF}";

	local txt = ScpArgMsg("Auto___KangHwaJaeLyoKa_ManSeupNiDa.{nl}").. rein_link  .. ScpArgMsg("Auto___aiTem_KangHwa{/}{/}Leul_HaeBoSeyo.");
	--frame:SetDuration(5);
	return txt;
end

-- upgradable check
function JS_CHECK_UPGRADABLE(frame)
	local cnt = GET_PC_UPGRDABLE_ITEM_COUNT();
	if cnt >= 1 then
		return 1;
	end

	return 0;
end

function JS_UPGRADABLE_TEXT(frame)

	local txt = ScpArgMsg("Auto___eopKeuLeiDeu_KaNeungHan{nl}aiTemi_issSeupNiDa.{nl}");
	local list = {};
	GET_PC_UPGRADABLE_ITEMS(list);
	for i = 1 , math.min(3, #list) do
		local obj = GetIES(list[i]:GetObject());
		local upgr_link = "{#003300}{a @UI_TUTO_UPGL " ..  list[i]:GetIESID() .. "}";
		txt = txt .. upgr_link .. "{img " .. obj.Icon .. " 48 48}" .. GET_FULL_NAME(obj) .. "{/}{/}{nl}";
	end

	return txt ;
end

function UI_TUTO_UPGL(frame, ctrl, iesID)
	JANSORI_SET_NOTIFIED(frame);
	local invItem = GET_PC_ITEM_BY_GUID(iesID);
	if invItem == nil then
		return;
	end

	local upgrFrame = ui.GetFrame("upgradeitem");
	UPGR_SET_ITEM(upgrFrame, invItem);

end


--------- jansori_quest_returnable
function JS_QUEST_RETURN_POS(frame)

	local questFrame = ui.GetFrame("questinfoset_2");
	local GroupCtrl = GET_CHILD(questFrame, "member", "ui::CGroupBox");


	for i = 0 , GroupCtrl:GetChildCount() - 1 do
		local chl = GroupCtrl:GetChildByIndex(i);
		local statePic = chl:GetChild("statepicture");
		if statePic ~= nil and statePic:GetClassName() == "picture" then
			statePic = tolua.cast(statePic, "ui::CPicture");
			if statePic:GetImageName() == "questinfo_return" then
				local x, y = GET_GLOBAL_XY(statePic);
				return x - 10, y;
			end
		end
	end

	return -500,-500;

end


-- collection

function JS_CHECK_COLLECTION(frame)
	local collection = frame:GetChild("collection");
	if collection ~= nil then
		return collection:IsVisible();		
	else
		return 0;
	end
end

function JS_SHOP_POS(frame)

	local btn = frame:GetChild("inven");
	if btn == nil then
		return -500,-500;
	end

	local x, y = GET_GLOBAL_XY(btn);
	x = x - 10;

	return x, y;

end

--- Shop_Able

function JS_CHECK_SHOP_ABLE(frame)

	local money = GET_PC_MONEY();
	if money >= 300 then
		if ui.IsFrameVisible("shop") == 1 then
			_JANSORI_SET_NOTIFIED("Shop_Able");
		end

		return 1;
	end

	return 0;
end

function JS_COLLETION_POS(frame)

	local btn = frame:GetChild("collection");
	if btn == nil then
		return -500,-500;
	end
	local x, y = GET_GLOBAL_XY(btn);
	return x, y;

end

-- BGEventHit
function JS_BGEVENT_HIT(frame)

	local obj = GetMyActor();
	local minEvent = bgevent.GetNearAbleBGEvent(obj:GetPos(), 300);
	if minEvent ~= nil then
		return 1;
	end

	return 0;
end

function JS_BGEVENT_POS(frame, cls)

	local obj = GetMyActor();
	local minEvent = bgevent.GetNearAbleBGEvent(obj:GetPos(), 300);
	if minEvent ~= nil then
		local pos = minEvent:Pos();
		local pts = world.ToScreenPos(pos.x, pos.y + 30, pos.z);
		return pts.x - 50, pts.y;
	end

	return -500,-500;

end

-- Monster

function JS_MONSTER(frame, cls)

	local clsName = cls.ScpArg;
	local mon = world.GetMonsterByClassName(clsName, 200);
	if mon == nil then
		return 0;
	end

	return 1;
end

function JS_MONSTER_POS(frame, cls)

	local clsName = cls.ScpArg;
	local mon = world.GetMonsterByClassName(clsName, 250);
	if mon == nil then
		return -500,-500;
	end

	local point = info.GetPositionInUI(mon:GetHandleVal(), 2);

	return point.x - 30, point.y;
end

-- Monster By Func
function JS_MONSTER_FUNC(frame, cls)

	local funcName = cls.ScpArg;
	if nil ~= funcName then
	local mon = world.GetMonsterByScp(funcName);
	if mon ~= nil then
		return 1;
	end
	end
	return 0;
end

function JS_MONSTER_FUNC_POS(frame, cls)
	local funcName = cls.ScpArg;
	local mon = world.GetMonsterByScp(funcName);
	if mon == nil then
		return -500,-500;
	end

	local point = info.GetPositionInUI(mon:GetHandleVal(), 2);
	return point.x - 30, point.y
end

-- monster Functions
function JS_GET_QUEST_NPC(baseObj, monCls)
	if baseObj:GetSystem():HaveNPCMark() == true then
		return 1;
	end

	return 0;
end

function JS_GET_QUEST_NPC_POS(baseobj, monCls)

	return 500, 500;

end


--- HP Potion
function GET_HP_POTION_FUNC(cls)
	return cls.CoolDownGroup == "HPPOTION";
end

function JS_CHECK_HP(frame, cls)

	local stat = info.GetStat(session.GetMyHandle());
	if stat == nil then
		return 0;
	end

	local per = stat.HP / stat.maxHP;
	if per <= 0.4  then
		local quickSlotFrame = ui.GetFrame("quickslotnexpbar");
		local slot = GET_QUICKSLOT_ITEM_BY_FUNC(quickSlotFrame, GET_HP_POTION_FUNC);
		if slot == nil then
			return 0;
		end

		return 1;
	end

	return 0;

end

function JS_HP_POS(frame, cls)

	local quickSlotFrame = ui.GetFrame("quickslotnexpbar");
	local slot = GET_QUICKSLOT_ITEM_BY_FUNC(quickSlotFrame, GET_HP_POTION_FUNC);
	if slot == nil then
		return -500,-500;
	end

	local x, y = GET_GLOBAL_XY(slot);

	return x, y - 30;

end

function JS_HP_TEXT(frame, cls)

	local quickSlotFrame = ui.GetFrame("quickslotnexpbar");
	local slot = GET_QUICKSLOT_ITEM_BY_FUNC(quickSlotFrame, GET_HP_POTION_FUNC);

	local retTxt = ScpArgMsg("Auto___Mulyag_aiTemeul_SayongHae{nl}HPLeul_HoeBogHal_Su_issSeupNiDa.");
	if slot ~= nil then
		local hotKey = GET_QUICKSLOT_SLOT_HOTKEY(quickSlotFrame, slot);
		retTxt = retTxt .. ScpArgMsg("Auto_{nl}DanChugKi_:_{#0000FF}") .. hotKey;
	end
	return retTxt;
end

--- SP Potion
function GET_SP_POTION_FUNC(cls)
	return cls.CoolDownGroup == "SPPOTION";
end

function JS_CHECK_SP(frame, cls)

	local stat = info.GetStat(session.GetMyHandle());
	if stat == nil then
		return 0;
	end

	local per = stat.SP / stat.maxSP;
	if per <= 0.5  then
		local quickSlotFrame = ui.GetFrame("quickslotnexpbar");
		local slot = GET_QUICKSLOT_ITEM_BY_FUNC(quickSlotFrame, GET_SP_POTION_FUNC);
		if slot == nil then
			return 0;
		end

		return 1;
	end

	return 0;

end

function JS_SP_POS(frame, cls)

	local quickSlotFrame = ui.GetFrame("quickslotnexpbar");
	local slot = GET_QUICKSLOT_ITEM_BY_FUNC(quickSlotFrame, GET_SP_POTION_FUNC);
	if slot == nil then
		return -500,-500;
	end

	local x, y  = GET_GLOBAL_XY(slot);

	return x, y - 30;

end

function JS_SP_TEXT(frame, cls)

	local quickSlotFrame = ui.GetFrame("quickslotnexpbar");
	local slot = GET_QUICKSLOT_ITEM_BY_FUNC(quickSlotFrame, GET_SP_POTION_FUNC);

	local retTxt = ScpArgMsg("Auto___Mulyag_aiTemeul_SayongHae{nl}SPLeul_HoeBogHal_Su_issSeupNiDa.");
	if slot ~= nil then
		local hotKey = GET_QUICKSLOT_SLOT_HOTKEY(quickSlotFrame, slot);
		retTxt = retTxt .. ScpArgMsg("Auto_{nl}DanChugKi_:_{#0000FF}") .. hotKey;
	end
	return retTxt;
end

--- STA Potion
function GET_STA_POTION_FUNC(cls)
	return cls.CoolDownGroup == "STAPOTION";
end

function JS_CHECK_STA(frame, cls)

	local stat = info.GetStat(session.GetMyHandle());
	if stat == nil then
		return 0;
	end

	local per = stat.Stamina / stat.MaxStamina;
	if per <= 0.1  then
		local quickSlotFrame = ui.GetFrame("quickslotnexpbar");
		local slot = GET_QUICKSLOT_ITEM_BY_FUNC(quickSlotFrame, GET_STA_POTION_FUNC);
		if slot == nil then
			return 0;
		end

		return 1;
	end

	return 0;

end

function JS_STA_POS(frame, cls)

	local quickSlotFrame = ui.GetFrame("quickslotnexpbar");
	local slot = GET_QUICKSLOT_ITEM_BY_FUNC(quickSlotFrame, GET_STA_POTION_FUNC);
	if slot == nil then
		return -500,-500;
	end

	local x, y  = GET_GLOBAL_XY(slot);

	return x, y - 30;

end

function JS_STA_TEXT(frame, cls)

	local quickSlotFrame = ui.GetFrame("quickslotnexpbar");
	local slot = GET_QUICKSLOT_ITEM_BY_FUNC(quickSlotFrame, GET_STA_POTION_FUNC);

	local retTxt = ScpArgMsg("Auto___Mulyag_aiTemeul_SayongHae{nl}SeuTaeMiNeoLeul_HoeBogHal_Su_issSeupNiDa.");
	if slot ~= nil then
		local hotKey = GET_QUICKSLOT_SLOT_HOTKEY(quickSlotFrame, slot);
		retTxt = retTxt .. ScpArgMsg("Auto_{nl}DanChugKi_:_{#0000FF}") .. hotKey;
	end
	return retTxt;
end

-- statup

function JS_STAT_UP(frame, cls)
--[[
	local pc = GetCommanderPC();
	local statPts = GET_STAT_POINT(pc);
	if pc.UsedStat > 0 then
		_JANSORI_SET_NOTIFIED("StatUp");
	end
	if statPts <= 0 then
		return 0;
	end
	]]
	return 0;
end
--
--function _JS_STAT_UP_POS(frame)
--	local statusFrame = ui.GetFrame("status");
--	if 0 == statusFrame:IsVisible() then
--		local statBtn = frame:GetChild("status");
--		local x, y = GET_GLOBAL_XY(statBtn);
--		return x - 10, y - 10;
--	end
--
--	return statusFrame:GetWidth() - 40, 530;
--
--end
--
--function JS_STAT_UP_POS(frame, cls, jsFrame)
--
--	local bx = jsFrame:GetUserIValue("_X");
--	local by = jsFrame:GetUserIValue("_Y");
--	local x, y =  _JS_STAT_UP_POS(frame);
--	if bx ~= x or by ~= y then
--		jsFrame:SetUserValue("_X", x);
--		jsFrame:SetUserValue("_Y", y);
--		JS_UPDATE_TEXT(frame, cls, jsFrame);
--	end
--
--	return x, y;
--end
--
--function JS_STAT_UP_TEXT(frame, cls)
--
--	local statusFrame = ui.GetFrame("status");
--	if 0 == statusFrame:IsVisible() then
--		return ScpArgMsg("Auto_{s18}{#001100}LeBeleopSie_KaeLigTeoui{nl}NeungLyeogChiLeul_olLil_Su_issSeupNiDa.");
--	end
--
--	return ScpArgMsg("Auto_{s18}{#001100}'+'_BeoTeuneuLo_NeungLyeogChiLeul_olLiKo{nl}Jeogyongeul_NulLeoJuSeyo.");
--
--end

function JS_GET_MORU_ITEM()
	local item, itemCnt = session.GetInvItemByName("Moru_1_Q");
	if item ~= nil then
		return item;
	end

	item, itemCnt  = session.GetInvItemByName("Moru_1");
	if item ~= nil then
		return item;
	end

	return nil;
end

function JS_MORU(frame, cls)
	local item = JS_GET_MORU_ITEM();
	if item ~= nil then
		return 1;
	end
	
	return 0;

end

function UI_TUTO_MORU(frame)
	ui.OpenFrame("inventory");
	frame:EnableHideProcess(1);
	JANSORI_SET_NOTIFIED(frame);
	frame:RunUpdateScript("_UI_FOCUS_MORU", 0, 0, 0);
end

function _UI_FOCUS_MORU(frame)
	local invFrame = ui.GetFrame("inventory");
	if invFrame:IsPIPMoving() == 1 then
		return 1;
	end

	local item = JS_GET_MORU_ITEM();
	if item == nil then
		return 0;
	end

	local slot = INV_GET_SLOT_BY_ITEMGUID(item:GetIESID())
	if slot == nil then
		return 0;
	end

	local x, y = GET_SCREEN_XY(slot);
	mouse.SetPos(x, y);
	return 0;
end

function JS_MORU_TEXT(frame, cls)
	return ScpArgMsg("Auto_{s18}{#001100}{a_@UI_TUTO_MORU}MoLuLeul_uKeulLigHae_aiTemeul_KangHwaHaSeyo.");
end

function JS_MORU_POS(frame, cls)
	return JS_INV_FULL_POS(frame, cls);
end



--OPEN_SHOP

function JS_SHOP_OPEN_JANSORI()
	
	local frame = ui.GetFrame('shop')	
	local ShopOpenFlag = frame:GetUserValue("SHOP_ONCE_OPEN");

	if ShopOpenFlag == '1' then
		return 1;
	else
		return 0;
	end
end

--[[
	JS_SHOP_OPEN() 와 JS_SHOP_CLOSE()는
	shop.lua 파일의 SHOP_UI_OPEN 함수와 SHOP_UI_CLOSE 함수 내에서 호출
	SHOP_UI 가 열리면 JS_SHOP_OPEN() 호출
	SHOP_UI 닫히면 JS_SHOP_CLOSE() 호출
  ]]

function JS_SHOP_OPEN(frame)
	
	frame:SetUserValue("SHOP_ONCE_OPEN", '1');

end

function JS_SHOP_CLOSE(frame)
	
	frame:SetUserValue("SHOP_ONCE_OPEN", '0')

end


function JS_OPEN_POS(frame, cls)

	local ShopFrame = ui.GetFrame("shop");
	local x, y = GET_GLOBAL_XY(ShopFrame);
	
	x = x + ShopFrame:GetWidth();
	y = y + ShopFrame:GetHeight() / 6 
	
	return x+285, y;

end

function JS_OPEN_SHOP_TEXT(frame, cls)
	return ScpArgMsg("Auto_{s18}{#001100}JeugSi_SangJeomeun_ilBan_SangJeomBoDa{nl}KaKyeogi_BiSsapNiDa.");
end



