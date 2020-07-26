--buff.lua
-- 0 : buff(limitcount) / 1 : buff / 2 : debuff / 3 : sub buff(othercastbuff)
s_buff_ui = {};
s_buff_ui["buff_group_cnt"] = 3;	
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
	addon:RegisterMsg('TEST_ADDON_MSG_DUMP_MSG', 'TEST_ADDON_MSG_DUMP');
	INIT_BUFF_UI(frame, s_buff_ui, "MY_BUFF_TIME_UPDATE");
	INIT_PREMIUM_BUFF_UI(frame);
end

function TEST_ADDON_MSG_DUMP(frame)
	test.TestFunction();
end

function INIT_PREMIUM_BUFF_UI(frame)
	local slotSet = frame:GetChild('premium');
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
	local myHandle = session.GetMyHandle();
	BUFF_TIME_UPDATE(myHandle, s_buff_ui);
end

function GET_BUFF_TIME_TXT(time, istooltip, isOtherCast)
	if time == 0.0 then
		return "";
	end

	local sec = time / 1000;
	local day = math.floor(sec / 86400);
	if day < 0 then
		day = 0;
	end

	sec = sec - day * 86400;
	local hour = math.floor(sec / 3600);
	if hour < 0 then
		hour = 0;
	end

	sec = sec - hour * 3600;
	local min = math.floor(sec / 60);
	if min < 0 then
		min = 0;
	end

	sec = math.floor(sec - min * 60);
	local txt = "{#FFFF00}{ol}{s12}";
	if isOtherCast == true then
		txt = "{#FFFF00}{ol}{s8}";
	end

	if day > 0 then
		if istooltip == 1 then
			txt = txt .. day .. ScpArgMsg("Auto_il");
		else
		    if day == 1 then
		        return "{#FFFF00}{ol}{s12}" .. hour + day*24 .. ScpArgMsg("Auto_SiKan");
		    else
    			return "{#FFFF00}{ol}{s12}" .. day .. ScpArgMsg("Auto_il");
    		end
		end
	end

	if hour > 0 then
		if istooltip == 1 then
			txt = txt .. hour .. ScpArgMsg("Auto_SiKan");
		else
		    if hour == 1 then
		        return "{#FFFF00}{ol}{s12}" .. min + hour*60 .. ScpArgMsg("Auto_Bun");
		    else
    			return "{#FFFF00}{ol}{s12}" .. hour .. ScpArgMsg("Auto_SiKan");
    		end
		end
	end

	if min > 0 then
		if istooltip == 1 then
			txt = txt .. min .. ScpArgMsg("Auto_Bun")
		else
		    if min == 1 then
		        return "{#FFFF00}{ol}{s12}" .. sec + min * 60 .. ScpArgMsg("Auto_Cho");
		    else
    			return "{#FFFF00}{ol}{s12}" .. min .. ScpArgMsg("Auto_Bun");
    		end
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
	if pc.IsNonCombatZone() == 0 then -- 전투지역에서만 토글 기능이 동작하도록 함(서버에서도 체크함)
		if argNum == 70006 or argNum == 70007 then	-- Client에서 자체적으로 경험의서(x4, x8)인 경우만, Request를 하도록...(서버에서도 체크함)
			--packet.ReqHoldExpBookTime(argNum);					
		end
	end	
end

function GET_BUFF_ICON_NAME(buffCls)
	local imageName = 'icon_' .. buffCls.Icon;
	return imageName;
end

function SET_BUFF_SLOT(slot, capt, class, buffType, handle, slotlist, buffIndex, isOtherCast)
	local icon = slot:GetIcon();
	local imageName = GET_BUFF_ICON_NAME(class);

	icon:Set(imageName, 'BUFF', buffType, 0);
	if buffIndex ~= nil then
		icon:SetUserValue("BuffIndex", buffIndex);	
	end

	if tonumber(handle) == nil then
		return;
	end

	local buff = info.GetBuff(tonumber(handle), buffType);
	if nil == buff then
		return;
	end

	local frame = ui.GetFrame("buff")
	local bufflockoffset = tonumber(frame:GetUserConfig("DEFAULT_BUFF_LOCK_OFFSET"));
	local buffGroup1 = TryGetProp(class, "Group1", "Buff");
	if buffGroup1 == "Debuff" then
		local bufflv = TryGetProp(class, "Lv", "99");
		if bufflv == 4 then
			slot:SetBgImage("buff_lock_icon_3");
		elseif bufflv > 4 then
			slot:SetBgImage("buff_lock_icon_4");
		end

		if bufflv <= 3 then
			slot:SetBgImageSize(0, 0);
		else 
			slot:SetBgImageSize(slot:GetWidth() + bufflockoffset, slot:GetHeight() + bufflockoffset);
		end		
	end

	if buff.over > 1 then
		slot:SetText('{s13}{ol}{b}'..buff.over, 'count', ui.RIGHT, ui.BOTTOM, -5, -3);
	else
		slot:SetText("");
	end
	
    if slot:GetTopParentFrame():GetName() ~= "targetbuff" then
    	slot:SetEventScript(ui.RBUTTONUP, 'REMOVE_BUF');
    	slot:SetEventScriptArgNumber(ui.RBUTTONUP, buffType);
	end

	slot:EnableDrop(0);
	slot:EnableDrag(0);

	if capt ~= nil then
		capt:ShowWindow(1);
		capt:SetText(GET_BUFF_TIME_TXT(buff.time, 0, isOtherCast));
	end
	
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
	    if buffIndex ~= nil then
	    	icon:SetTooltipArg(handle, buffType, buffIndex);
	    end
	end

	slot:Invalidate();
end

function SET_BUFF_CAPTION_OFFSET(slotset, buff_ui, index)
	if index == 1 then
		if slotset:GetName() ~= "buffslot" then
			return;
		end
	elseif index == 2 then
		if slotset:GetName() ~= "debuffslot" then
			return;
		end
	elseif index == 3 then
		if slotset:GetName() ~= "buffcountslot_sub" then
			return;
		end
	end

	local captionlist = buff_ui["captionlist"][index];
    local totalCount = slotset:GetRow() * slotset:GetCol();
    for i = 0, totalCount - 1 do
        local slot = slotset:GetSlotByIndex(i);
        local slotHeight = slot:GetHeight();
        local caption = captionlist[i];
        caption:SetOffset(caption:GetX(), slotset:GetY() + slotHeight);
    end
end

function GET_BUFF_ARRAY_INDEX(i, colcnt)
	return GET_BUFF_SLOT_INDEX(i, colcnt);
end

function GET_BUFF_SLOT_INDEX(j, colcnt)
	local row = math.floor(j / colcnt);
	local col = j - row * colcnt;
	local i = row * colcnt + col;
	return i;
end

function get_exist_debuff_in_slotlist(slotlist, buff_id)
    for k = 0, #slotlist - 1 do
        local slot =  slotlist[k];
        if slot ~= nil then
            local icon = slot:GetIcon(); 
            if icon ~= nil then
                local iconInfo = icon:GetInfo()
                if iconInfo ~= nil then
                    if tonumber(iconInfo.type) == tonumber(buff_id) then
                        return slot, k;
                    end
                end
            end
        end
    end

    return nil;
end

function BUFF_TOTAL_COUNT_CHECK(frame, msg, buffType, handle, buff_ui, buffIndex)
	local buffCls = GetClassByType('Buff', buffType);
	if buffCls == nil or buffCls.ShowIcon == "FALSE" then
		return;
	end

	local apply_limit_count_buff = 0;
	if buffCls.ApplyLimitCountBuff == "YES" then
		apply_limit_count_buff = 1;
	else
		apply_limit_count_buff = 0;
	end

	local buffcount_totalcnt = frame:GetUserIValue("BUFF_COUNT_TOTAL_CNT"); 
	local buff_totalcnt = frame:GetUserIValue("BUFF_TOTAL_CNT"); 
	local debuff_totalcnt = frame:GetUserIValue("DEBUFF_TOTAL_CNT"); 
	local totalCount = 0;
	local buff_ui_index = 0;
	if buffCls.Group1 == "Debuff" then
		debuff_totalcnt = info.GetBuffcountByProperty(handle, buffCls.Group1, apply_limit_count_buff, 1);
		buff_ui_index = 2;
		frame:SetUserValue("DEBUFF_TOTAL_CNT", debuff_totalcnt);
		totalCount = debuff_totalcnt;
	else
		if apply_limit_count_buff == 1 then
			buffcount_totalcnt = info.GetBuffcountByProperty(handle, buffCls.Group1, apply_limit_count_buff, 1);
			buff_ui_index = 0;
			frame:SetUserValue("BUFF_COUNT_TOTAL_CNT", buffcount_totalcnt);
			totalCount = buffcount_totalcnt;
		else
			buff_totalcnt = info.GetBuffcountByProperty(handle, buffCls.Group1, apply_limit_count_buff, 1);
			buff_ui_index = 1;
			frame:SetUserValue("BUFF_TOTAL_CNT", buff_totalcnt);
			totalCount = buff_totalcnt;
		end
	end

	local row = buff_ui["slotsets"][buff_ui_index]:GetRow();
	local col = buff_ui["slotsets"][buff_ui_index]:GetCol();
	
	if msg == "ADD" and totalCount > col * row then
		buff_ui["slotsets"][buff_ui_index]:ExpandRow();
		UPDATE_BUFF_UI_SLOTSET(frame, buff_ui, buff_ui_index);
	end
	
	buff_ui["slotsets"][buff_ui_index]:AutoCheckDecreaseRow();
	buff_ui["slotsets"][buff_ui_index]:Invalidate();
end

function COMMON_BUFF_MSG(frame, msg, buffType, handle, buff_ui, buffIndex)
	BUFF_TOTAL_COUNT_CHECK(frame, msg, buffType, handle, buff_ui, buffIndex);
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
    				local slot = slotlist[i];
    				local text = captionlist[i];
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

	buffIndex = tonumber(buffIndex);

	local class = GetClassByType('Buff', buffType);
	if class.ShowIcon == "FALSE" then
		return;
	end

	local slotlist;
	local slotcount;
	local captionlist;
	local colcnt = 0;
	local ApplyLimitCountBuff = "YES";

	local isOtherCastBuff = false;
	local buff = info.GetBuff(handle, buffType);
	if buff ~= nil then
		local casterHandle = buff:GetHandle();
		if casterHandle ~= nil and casterHandle ~= handle then
			isOtherCastBuff = true;
		end
	end

	if class.Group1 == 'Debuff' then
		slotlist = buff_ui["slotlist"][2];
		slotcount = buff_ui["slotcount"][2];
		captionlist = buff_ui["captionlist"][2];
		if nil ~= buff_ui["slotsets"][2] then
			colcnt = buff_ui["slotsets"][2]:GetCol();
		end
	else
		if class.ApplyLimitCountBuff == 'YES' then
			local slotlistIndex = 0;
			if class.UserRemove == "NO" then
				slotlistIndex = 1;
			end
			
			if isOtherCastBuff == true then
				slotlistIndex = 3;
			end

			slotlist = buff_ui["slotlist"][slotlistIndex];
			slotcount = buff_ui["slotcount"][slotlistIndex];
			captionlist = buff_ui["captionlist"][slotlistIndex];
			if nil ~= buff_ui["slotsets"][slotlistIndex] then
				colcnt = buff_ui["slotsets"][slotlistIndex]:GetCol();
			end
		else
			local slotlistIndex = 1;
			if isOtherCastBuff == true and (class.RemoveBySkill == "YES" or class.Lv < 4) then
				slotlistIndex = 3;
			end

			slotlist = buff_ui["slotlist"][slotlistIndex];
			slotcount = buff_ui["slotcount"][slotlistIndex];
			captionlist = buff_ui["captionlist"][slotlistIndex];
			if nil ~= buff_ui["slotsets"][slotlistIndex] then
				colcnt = buff_ui["slotsets"][slotlistIndex]:GetCol();
			end
			ApplyLimitCountBuff = "NO";
		end
	end

	if msg == 'ADD' then
        local skip = false
        if class ~= nil then
            if TryGetProp(class, 'OnlyOneBuff', 'None') == 'YES' and TryGetProp(class, 'Duplicate', 1) == 0 then
                local exist_slot, i = get_exist_debuff_in_slotlist(slotlist, buffType)
                if exist_slot ~= nil then
					if exist_slot:IsVisible() == 0 then
                        SET_BUFF_SLOT(exist_slot, captionlist[i], class, buffType, handle, slotlist, buffIndex, isOtherCastBuff);
                    end
                    skip = true                  
                end
            end
        end
        
		if skip == false then
			for j = 0, slotcount - 1 do
				local i = GET_BUFF_SLOT_INDEX(j, colcnt);
				local slot = slotlist[i];
				if slot:IsVisible() == 0 then
				    SET_BUFF_SLOT(slot, captionlist[i], class, buffType, handle, slotlist, buffIndex, isOtherCastBuff);                    
				    break;
			    end
		    end
        end
	elseif msg == 'REMOVE' then
		for i = 0, slotcount - 1 do
			local slot = slotlist[i];
			local text = captionlist[i];
			local oldIcon = slot:GetIcon();
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
		REMOVE_BUFF_COUNT_SLOT_SUB(frame, buff_ui, buffType, buffIndex, colcnt, ApplyLimitCountBuff);
	elseif msg == "UPDATE" then    
		for i = 0, slotcount - 1 do
			local slot = slotlist[i];
			local text = captionlist[i];
			local oldIcon = slot:GetIcon();
			if slot:IsVisible() == 1 then
				local iconInfo = oldIcon:GetInfo();
				if iconInfo.type == buffType and oldIcon:GetUserIValue("BuffIndex") == buffIndex then                
					SET_BUFF_SLOT(slot, captionlist[i], class, buffType, handle, slotlist, buffIndex, isOtherCastBuff);
					break;
				end
			end
		end
	end

    ARRANGE_BUFF_SLOT(frame, buff_ui);
    COLONY_POINT_INFO_DRAW_BUFF_ICON();
end

function REMOVE_BUFF_COUNT_SLOT_SUB(frame, buff_ui, buffType, buffIndex, colcnt, ApplyLimitCountBuff)
	local slotlist = buff_ui["slotlist"][3];
	local slotcount = buff_ui["slotcount"][3];
	local captionlist = buff_ui["captionlist"][3];
	if slotcount == nil or slotcount <= 0 then 
		return;
	end

	for i = 0, slotcount - 1 do
		local slot = slotlist[i];
		local text = captionlist[i];
		local oldIcon = slot:GetIcon();
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
end

function BUFF_SLOTSET_ALIGN(frame, buff_ui, index)
	if frame == nil then return; end
	if index == nil then return; end
end

function ARRANGE_BUFF_SLOT(frame, buff_ui)
	if frame:GetName() ~= 'buff' and frame:GetName() ~= "targetbuff" then
        return;
	end

	local default_slot_y_offset = tonumber(frame:GetUserConfig('DEFAULT_SLOT_Y_OFFSET'));
	local default_sub_slot_y_offset = tonumber(frame:GetUserConfig("DEFAULT_SUB_SLOT_Y_OFFSET"));

	-- buff count -----------------------------------------------------------------
	local buffCount = GET_CHILD_RECURSIVELY(frame, "buffcountslot", "ui::CSlotSet");
	if buffCount == nil then return; end

	local col_buffcount = buffCount:GetCol();
	local slotCnt_buffcount = buffCount:GetRow() * col_buffcount;

	local visibleCnt_buffcount = 0;
	for i = 0, slotCnt_buffcount - 1 do
		local slot = buffCount:GetSlotByIndex(i);
		if slot == nil or slot:IsVisible() == 0 then
			visibleCnt_buffcount = i;
			break;
		end
	end

	local visibleRow_buffcount = math.floor(visibleCnt_buffcount / col_buffcount);
	if visibleRow_buffcount > 0 and visibleRow_buffcount % col_buffcount == 0 then
		visibleRow_buffcount = visibleRow_buffcount + 1;
	end
	visibleRow_buffcount = visibleRow_buffcount + 1;
	-------------------------------------------------------------------------------
	-- buff count sub -------------------------------------------------------------
	local buffSub = GET_CHILD_RECURSIVELY(frame, "buffcountslot_sub", "ui::CSlotSet");
	if buffSub == nil then return; end

	local col_buffsub = buffSub:GetCol();
	local slotCnt_buffsub = buffSub:GetRow() * col_buffsub;

	buffSub:SetOffset(buffSub:GetX(), buffCount:GetY() + default_slot_y_offset * visibleRow_buffcount);
	SET_BUFF_CAPTION_OFFSET(buffSub, buff_ui, 3);

	local visibleCnt_buffsub = 0;
	for i = 0, slotCnt_buffsub - 1 do
		local slot = buffSub:GetSlotByIndex(i);
		if slot == nil or slot:IsVisible() == 0 then
			visibleCnt_buffsub = i;
			break;
		end
	end

	local visibleRow_buffsub = math.floor(visibleCnt_buffsub / col_buffsub);
	if visibleRow_buffsub > 0 and visibleRow_buffsub % col_buffsub == 0 then
		visibleRow_buffsub = visibleRow_buffsub + 1;
	end
	visibleRow_buffsub = visibleRow_buffsub + 1;

	buffSub:Resize(buffSub:GetWidth(), default_sub_slot_y_offset * visibleRow_buffsub);
	-------------------------------------------------------------------------------
	-- buff -----------------------------------------------------------------------
	local buff = GET_CHILD_RECURSIVELY(frame, "buffslot", "ui::CSlotSet");
	if buff == nil then return; end
	
	local col_buff = buff:GetCol();
	local slotCnt_buff = buff:GetRow() * col_buff;
	
	buff:SetOffset(buff:GetX(), buffSub:GetY() + default_sub_slot_y_offset * visibleRow_buffsub);
	SET_BUFF_CAPTION_OFFSET(buff, buff_ui, 1);

	local visibleCnt_buff = 0;
	for i = 0, slotCnt_buff - 1 do
		local slot = buff:GetSlotByIndex(i);
		if slot == nil or slot:IsVisible() == 0 then
			visibleCnt_buff = i;
			break;
		end
	end

	local visibleRow_buff = math.floor(visibleCnt_buff / col_buff);
	if visibleRow_buff > 0 and visibleRow_buff % col_buff == 0 then
		visibleRow_buff = visibleRow_buff + 1;
	end
	visibleRow_buff = visibleRow_buff + 1;

	buff:Resize(buff:GetWidth(), default_slot_y_offset * visibleRow_buff);
	-------------------------------------------------------------------------------
    -- debuff ---------------------------------------------------------------------
	local debuff = GET_CHILD_RECURSIVELY(frame, "debuffslot", "ui::CSlotSet");
	if debuff == nil then return; end

	local col_debuff = debuff:GetCol();
	local slotCnt_debuff = debuff:GetRow() * col_debuff;
	
	debuff:SetOffset(debuff:GetX(), buff:GetY() + default_slot_y_offset * visibleRow_buff);
	SET_BUFF_CAPTION_OFFSET(debuff, buff_ui, 2);

	local visibleCnt_debuff = 0;
	for i = 0, slotCnt_debuff - 1 do
		local slot = debuff:GetSlotByIndex(i);
		if slot == nil or slot:IsVisible() == 0 then
			visibleCnt_debuff = i;
			break;
		end
	end

	local visibleRow_debuff = math.floor(visibleCnt_debuff / col_debuff);
	if visibleRow_debuff > 0 and visibleRow_debuff % col_debuff == 0 then
		visibleRow_debuff = visibleRow_debuff + 1;
	end
	visibleRow_debuff = visibleRow_debuff + 1;

	debuff:Resize(debuff:GetWidth(), (default_slot_y_offset) * visibleRow_debuff);
	-------------------------------------------------------------------------------
end

function PULL_BUFF_SLOT_LIST(slotlist, captionlist, index, slotcount, colcnt, ApplyLimitCountBuff)
	if index == slotcount-1 and "NO" == ApplyLimitCountBuff then
		local actor = GetMyActor();	
		local aslot	= slotlist[index-1];
		local aicon = aslot:GetIcon();
		actor:GetBuff():InvalidateLastBuff(aicon:GetTooltipNumArg(), aicon:GetUserIValue("BuffIndex"));
	end

	for j = index, slotcount - 2 do
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
	if buffType == 0 then
		return
	end		

	local isOtherCastBuff = false;
	local buff = info.GetBuff(handle, buffType);
	if buff ~= nil and buff:GetHandle() ~= handle then
		isOtherCastBuff = true;
	end

	local class  = GetClassByType('Buff', buffType);
	local buffIndex = bicon:GetUserIValue("BuffIndex");
	SET_BUFF_SLOT(aslot, atext, class, buffType, handle, slotlist, buffIndex, isOtherCastBuff);
	CLEAR_BUFF_SLOT(bslot, btext);
end

function CLEAR_BUFF_SLOT(slot, text)
	slot:ShowWindow(0);
	slot:ReleaseBlink();
	if text ~= nil then
		text:SetText("");
	end
	local icon = slot:GetIcon();
	local iconInfo = icon:GetInfo();
	iconInfo.type = 0;
end

function BUFF_ON_MSG(frame, msg, argStr, argNum)
	local handle = session.GetMyHandle();

	if BUFF_CHECK_SEPARATELIST(argNum) == true then
		return;
	end

	if msg == "BUFF_ADD" then
		COMMON_BUFF_MSG(frame, "ADD", argNum, handle, s_buff_ui, argStr);
	elseif msg == "BUFF_REMOVE" then
		COMMON_BUFF_MSG(frame, "REMOVE", argNum, handle, s_buff_ui, argStr);
	elseif msg == "BUFF_UPDATE" then
		COMMON_BUFF_MSG(frame, "UPDATE", argNum, handle, s_buff_ui, argStr);
	end

	MY_BUFF_TIME_UPDATE(frame);
	BUFF_RESIZE(frame, s_buff_ui);
end

function BUFF_RESIZE(frame, buff_ui)
	local buffcount_slotsets = buff_ui["slotsets"][0];
	local buff_slotsets = buff_ui["slotsets"][1];
	local debuff_slotsets = buff_ui["slotsets"][2];
	local buffcount_subslotsets = buff_ui["slotsets"][3];

	local height = buffcount_slotsets:GetHeight() + buffcount_subslotsets:GetHeight() + buff_slotsets:GetHeight() + debuff_slotsets:GetHeight();

	frame:Resize(frame:GetWidth(), height + 20);
end