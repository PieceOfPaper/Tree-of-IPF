--buff.lua

s_buff_ui = {};
s_buff_ui["buff_group_cnt"] = 2;	-- 0 : buff(limitcount) / 1 : buff / 2 : debuff
s_buff_ui["slotsets"] = {};
s_buff_ui["slotlist"] = {};
s_buff_ui["captionlist"] = {};
s_buff_ui["slotcount"] = {};
s_buff_ui["txt_x_offset"] = 1;
s_buff_ui["txt_y_offset"] = 1;

function BUFF_ON_INIT(addon, frame)

	addon:RegisterMsg('BUFF_ADD', 'BUFF_ON_MSG');
	addon:RegisterMsg('BUFF_REMOVE', 'BUFF_ON_MSG');
	addon:RegisterMsg('BUFF_UPDATE', 'BUFF_ON_MSG');

	INIT_BUFF_UI(frame, s_buff_ui, "MY_BUFF_TIME_UPDATE");
	INIT_PREMIUM_BUFF_UI(frame);
end

function INIT_PREMIUM_BUFF_UI(frame)
	local slotSet		= frame:GetChild('premium');
	slotSet = tolua.cast(slotSet, 'ui::CSlotSet');
	if slotSet == nil then
		return;
	end	
	local count = slotSet:GetSlotCount();
	for i = 0, count-1 do
		local slot = slotSet:GetSlotByIndex(i);	
		slot:ShowWindow(0);
	end

end



function SET_BUFF_TIME_TO_TEXT(text, time)

	text:SetText(GET_BUFF_TIME_TXT(time, 0));

end


function MY_BUFF_TIME_UPDATE(frame, timer, argstr, argnum, passedtime)

	local myHandle 		= session.GetMyHandle();
	BUFF_TIME_UPDATE(myHandle, s_buff_ui);

end

function GET_BUFF_TIME_TXT(time, istooltip)

	if time == 0.0 then
		return "";
	end

	local sec = time / 1000;

	local day = math.floor(sec / 86400);
	if day < 0 then
		day = 0;
	end

	sec = sec - day * 86400;

	-- 버프를 분단위로 표시하기위해 주석
--	local hour = math.floor(sec / 3600);
--	if hour < 0 then
--		hour = 0;
--	end

--	sec = sec - hour * 3600;

	local min = math.floor(sec / 60);
	if min < 0 then
		min = 0;
	end

	sec = math.floor(sec - min * 60);

	local txt = "{#FFFF00}{ol}{s12}";

	if day > 0 then
		if istooltip == 1 then
			txt = txt .. day .. ScpArgMsg("Auto_il");
		else
			return "{#FFFF00}{ol}{s12}" .. day + 1 .. ScpArgMsg("Auto_il");
		end
	end

	-- 버프를 분단위로 표시하기 위해 주석
--	if hour > 0 then
--		if istooltip == 1 then
--			print("hour return no");
--			txt = txt .. hour .. ScpArgMsg("Auto_SiKan");
--		else
--			print("hour return");
--			return "{#FFFF00}{ol}{s12}" .. hour + 1 .. ScpArgMsg("Auto_SiKan");
--		end
--	end

	if min > 0 then
		if istooltip == 1 then
			txt = txt .. min .. ScpArgMsg("Auto_Bun")
		else
			return "{#FFFF00}{ol}{s12}" .. min .. ScpArgMsg("Auto_Bun");
		end
	end

	if sec < 0 then
		sec = 0;
	end

	return txt .. sec .. ScpArgMsg("Auto_Cho");

end

function REMOVE_BUF(frame, data, argStr, argNum)
	packet.ReqRemoveBuff(argNum);
end

function HOLD_EXP_BOOK_TIME(frame, data, argStr, argNum)	
	if pc.IsNonCombatZone() == 0 then				-- 전투지역에서만 토글 기능이 동작하도록 함(서버에서도 체크함)
		if argNum == 70006 or argNum == 70007 then	-- Client에서 자체적으로 경험의서(x4, x8)인 경우만, Request를 하도록...(서버에서도 체크함)
			--packet.ReqHoldExpBookTime(argNum);					
		end
	end	
end

function SET_BUFF_SLOT(slot, capt, class, buffType, handle, slotlist, buffIndex)	
	local icon 				= slot:GetIcon();
	local imageName 		= 'icon_' .. class.Icon;

	icon:Set(imageName, 'BUFF', buffType, 0);
	icon:SetUserValue("BuffIndex", buffIndex);	
	if tonumber(handle) == nil then
		return
	end
	local buff 					= info.GetBuff(tonumber(handle), buffType);
	if nil == buff then
		return;
	end

	if buff.over > 1 then
		slot:SetText('{s13}{ol}{b}'..buff.over, 'count', 'right', 'bottom', -5, -3);
	else
		slot:SetText("");
	end
	
    if slot:GetTopParentFrame():GetName() ~= "targetbuff" then
    	slot:SetEventScript(ui.RBUTTONUP, 'REMOVE_BUF');
    	slot:SetEventScriptArgNumber(ui.RBUTTONUP, buffType);
	end
	slot:EnableDrop(0);
	slot:EnableDrag(0);

	--slot:SetEventScript(ui.LBUTTONUP, 'HOLD_EXP_BOOK_TIME');  -- 경험의서, 수동 on/off , 좌클릭시에 이벤트 발생
	--slot:SetEventScriptArgNumber(ui.LBUTTONUP, buffType);     -- 인자로 buffID를 넘김
	
	capt:ShowWindow(1);
	capt:SetText(GET_BUFF_TIME_TXT(buff.time, 0));
	
	local targetinfo = info.GetTargetInfo( handle );
	if targetinfo ~= nil then
		if targetinfo.TargetWindow == 0 then
			slot:ShowWindow(0);	
		else
			slot:ShowWindow(1);
		end
	else
		slot:ShowWindow(1);
	end
	
	if class.ClassName == "Premium_Nexon" or class.ClassName =="Premium_Token" then
		icon:SetTooltipType('premium');
		icon:SetTooltipArg(handle, buffType, buff.arg1);
	else
	icon:SetTooltipType('buff');
	icon:SetTooltipArg(handle, buffType, buffIndex);
	end

	--slot:SetSkinName(class.SlotType);

	slot:Invalidate();

end

function SET_DEBUFF_CAPTION_OFFSET(slotset, buff_ui)
    if slotset:GetName() ~= 'debuffslot' then
        return;
    end
    local captionList = buff_ui["captionlist"][2];
    local totalDebuffSlotCount = slotset:GetRow() * slotset:GetCol();
    for i = 0, totalDebuffSlotCount - 1 do
        local slot = slotset:GetSlotByIndex(i);
        local slotHeight = slot:GetHeight();
        local caption = captionList[i];
        caption:SetOffset(caption:GetX(), slotset:GetY() + slotHeight);
    end
end

function GET_BUFF_ARRAY_INDEX(i, colcnt)
	return GET_BUFF_SLOT_INDEX(i, colcnt);
end

--[[
-- 거꾸로 채워나가는 버전
function GET_BUFF_SLOT_INDEX(j, colcnt)
	local row = math.floor(j / colcnt);
	local col = j - row * colcnt;
	local i = row * colcnt + (colcnt - col) - 1;
	return i;
end
]]--

-- 순방향 버젼
function GET_BUFF_SLOT_INDEX(j, colcnt)
	local row = math.floor(j / colcnt);
	local col = j - row * colcnt;
	local i = row * colcnt + col;
	return i;
end

function COMMON_BUFF_MSG(frame, msg, buffType, handle, buff_ui, buffIndex)

	if msg == "SET" then

			local buffCount = info.GetBuffCount(handle);
			for i = 0, buffCount - 1 do
				local buff = info.GetBuffIndexed(handle, i);
				COMMON_BUFF_MSG(frame, "ADD", buff.buffID, handle, buff_ui, buff.index);
			end

		return;
	elseif msg == "CLEAR" then

		for i = 0 , buff_ui["buff_group_cnt"] do
			local slotlist = buff_ui["slotlist"][i];
			local slotcount = buff_ui["slotcount"][i];
			local captionlist = buff_ui["captionlist"][i];
            if slotcount ~= nil and slotcount >= 0 then
    			for i = 0, slotcount - 1 do
    				local slot		= slotlist[i];
    				local text		= captionlist[i];
    				slot:ShowWindow(0);
    				slot:ReleaseBlink();
    				text:SetText("");
    			end
    		end
		end

		frame:Invalidate();
		return;
	end

	if "None" == buffIndex or nil == buffIndex then
		buffIndex = 0;
	end

	local class = GetClassByType('Buff', buffType);
	if class.ShowIcon == "FALSE" then
		return;
	end

	local slotlist;
	local slotcount;
	local captionlist;
	local colcnt = 0;
	local ApplyLimitCountBuff = "YES"
	if class.Group1 == 'Debuff' then
		slotlist = buff_ui["slotlist"][2];
		slotcount = buff_ui["slotcount"][2];
		captionlist = buff_ui["captionlist"][2];
		colcnt = buff_ui["slotsets"][2]:GetCol();
	else
		if class.ApplyLimitCountBuff == 'YES' then
			slotlist = buff_ui["slotlist"][0];
			slotcount = buff_ui["slotcount"][0];
			captionlist = buff_ui["captionlist"][0];
			-- targetbuff인거 같은데 .. 못 받아오면 nil 이되는데 콘솔에 ? 로 작성되서 예외처리
			if nil ~= buff_ui["slotsets"][0] then
				colcnt = buff_ui["slotsets"][0]:GetCol();
			end
		else
			slotlist = buff_ui["slotlist"][1];
			slotcount = buff_ui["slotcount"][1];
			captionlist = buff_ui["captionlist"][1];
			colcnt = buff_ui["slotsets"][1]:GetCol();
			ApplyLimitCountBuff = "NO";
		end
	end

	if msg == 'ADD' then
		for j = 0, slotcount - 1 do
			local i = GET_BUFF_SLOT_INDEX(j, colcnt);
			local slot				= slotlist[i];
           
			if slot:IsVisible() == 0 then
				SET_BUFF_SLOT(slot, captionlist[i], class, buffType, handle, slotlist, buffIndex);
				break;
			end
		end

	elseif msg == 'REMOVE' then

		for i = 0, slotcount - 1 do

			local slot		= slotlist[i];
			local text		= captionlist[i];
			local oldIcon 		= slot:GetIcon();
			if slot:IsVisible() == 1 then
				local oldBuffIndex = oldIcon:GetUserIValue("BuffIndex");			
				local iconInfo = oldIcon:GetInfo();
                local isBuffIndexSame = oldBuffIndex - buffIndex;
				if iconInfo.type == buffType and isBuffIndexSame == 0 then
					CLEAR_BUFF_SLOT(slot, text);
					local j = GET_BUFF_ARRAY_INDEX(i, colcnt);
					PULL_BUFF_SLOT_LIST(slotlist, captionlist, j, slotcount, colcnt, ApplyLimitCountBuff);
					frame:Invalidate();
					break;
				end
			end
		end

	elseif msg == "UPDATE" then

			for i = 0, slotcount - 1 do

			local slot		= slotlist[i];
			local text		= captionlist[i];
			local oldIcon 		= slot:GetIcon();

			if slot:IsVisible() == 1 then
				local iconInfo = oldIcon:GetInfo();
				if iconInfo.type == buffType and oldIcon:GetUserIValue("BuffIndex") == buffIndex then
					SET_BUFF_SLOT(slot, captionlist[i], class, buffType, handle, slotlist, buffIndex);
					break;
				end
			end
		end
	end

    ARRANGE_DEBUFF_SLOT(frame, buff_ui);
end

function ARRANGE_DEBUFF_SLOT(frame, buff_ui)
    if frame:GetName() ~= 'buff' then
        return;
    end

    -- get visible row of unlimitedBuffSlotset
    local unlimitedBuffSlotset = frame:GetChild('buffslot');
    local unlimitedBuffSlotCol = unlimitedBuffSlotset:GetCol();
    local totalUnlimitBuffSlotCount = unlimitedBuffSlotset:GetRow() * unlimitedBuffSlotCol;

    local visibleSlotCount = 0;
    for i = 0, totalUnlimitBuffSlotCount - 1 do
        local unlimitedSlot = unlimitedBuffSlotset:GetSlotByIndex(i);
        if unlimitedSlot == nil or unlimitedSlot:IsVisible() == 0 then
            visibleSlotCount = i;
            break;
        end
    end
    local visibleRowCount = math.floor(visibleSlotCount / unlimitedBuffSlotCol);
    if visibleRowCount > 0 and visibleRowCount % unlimitedBuffSlotCol == 0 then
        visibleRowCount = visibleRowCount + 1;
    end
    visibleRowCount = visibleRowCount + 1;

    -- set offset debuff slotset
    local debuffSlotset = frame:GetChild('debuffslot');
    local DEFAULT_SLOT_Y_OFFSET = tonumber(frame:GetUserConfig('DEFAULT_SLOT_Y_OFFSET'));
    unlimitedBuffSlotset:Resize(unlimitedBuffSlotset:GetWidth(), DEFAULT_SLOT_Y_OFFSET * (visibleRowCount));
    debuffSlotset:SetOffset(debuffSlotset:GetX(), unlimitedBuffSlotset:GetY() + DEFAULT_SLOT_Y_OFFSET * visibleRowCount);

    -- set offset caption
    SET_DEBUFF_CAPTION_OFFSET(debuffSlotset, buff_ui);
end

function PULL_BUFF_SLOT_LIST(slotlist, captionlist, index, slotcount, colcnt, ApplyLimitCountBuff)
	if index == slotcount-1 and "NO" == ApplyLimitCountBuff then
		local actor = GetMyActor();	
		local aslot	= slotlist[index-1];
		local aicon = aslot:GetIcon();
		actor:GetBuff():InvalidateLastBuff(aicon:GetTooltipNumArg(), aicon:GetUserIValue("BuffIndex"));
	end

	for j = index,  slotcount - 2 do
		local i = GET_BUFF_SLOT_INDEX(j, colcnt);
		local ni = GET_BUFF_SLOT_INDEX(j + 1, colcnt);
		local aslot	= slotlist[i];
		local atext = captionlist[i];
		local bslot = slotlist[ni];
		local btext = captionlist[ni];

		if bslot:IsVisible() == 1 then
			COPY_BUFF_SLOT_INFO(bslot, aslot, btext, atext);
			if j+1 <= slotcount-1 and "NO" == ApplyLimitCountBuff then
				local actor = GetMyActor();	
				local bicon = bslot:GetIcon();
				actor:GetBuff():InvalidateLastBuff(bicon:GetTooltipNumArg(), bicon:GetUserIValue("BuffIndex"));
			end
		end
	end
end

function COPY_BUFF_SLOT_INFO(bslot, aslot, btext, atext)

	local bicon = bslot:GetIcon();
	local handle = bicon:GetTooltipStrArg();
	local buffType = bicon:GetTooltipNumArg();
	local class  = GetClassByType('Buff', buffType);
	local buffIndex = bicon:GetUserIValue("BuffIndex");
	SET_BUFF_SLOT(aslot, atext, class, buffType, handle, slotlist, buffIndex);
	CLEAR_BUFF_SLOT(bslot, btext);

end

function CLEAR_BUFF_SLOT(slot, text)
	slot:ShowWindow(0);
	slot:ReleaseBlink();
	text:SetText("");
end

function BUFF_ON_MSG(frame, msg, argStr, argNum)

	local handle = session.GetMyHandle();
	if msg == "BUFF_ADD" then

		COMMON_BUFF_MSG(frame, "ADD", argNum, handle, s_buff_ui, argStr);

	elseif msg == "BUFF_REMOVE" then

		COMMON_BUFF_MSG(frame, "REMOVE", argNum, handle, s_buff_ui, argStr);

	elseif msg == "BUFF_UPDATE" then

		COMMON_BUFF_MSG(frame, "UPDATE", argNum, handle, s_buff_ui, argStr);

	end

	MY_BUFF_TIME_UPDATE(frame);
end




