-- targetbuff.lua
t_buff_ui = {};
t_buff_ui["buff_group_cnt"] = 3;
t_buff_ui["slotsets"] = {};
t_buff_ui["slotlist"] = {};
t_buff_ui["captionlist"] = {};
t_buff_ui["slotcount"] = {};
t_buff_ui["txt_x_offset"] = 1;
t_buff_ui["txt_y_offset"] = 1;
s_buff_ui_debuff_min_count = 20;
s_lsgmsg = "";
s_lasthandle = 0;

function TARGETBUFF_ON_INIT(addon, frame)
	addon:RegisterMsg('TARGET_BUFF_ADD', 'TARGETBUFF_ON_MSG');
	addon:RegisterMsg('TARGET_BUFF_REMOVE', 'TARGETBUFF_ON_MSG');
	addon:RegisterMsg('TARGET_BUFF_UPDATE', 'TARGETBUFF_ON_MSG');
	addon:RegisterMsg('TARGET_SET', 'TARGETBUFF_ON_MSG');
	addon:RegisterMsg('TARGET_CLEAR', 'TARGETBUFF_ON_MSG');
	INIT_BUFF_UI(frame, t_buff_ui, "TARGET_BUFF_UPDATE");
	INIT_TARGETBUFF(frame);
end 

function INIT_TARGETBUFF(frame)
	if frame == nil then return; end
	local button = GET_CHILD_RECURSIVELY(frame, "debuffminimizebutton");
	if button ~= nil then
		button:Resize(0, 0);
		button:SetVisible(0);
		button:SetTextTooltip(ClMsg("TargetBuffButtonToolTipMin"));
	end

	local pos = ui.GetCatchMovePos(frame:GetName());
	if pos.x ~= 0 and pos.y ~= 0 then
		frame:MoveFrame(pos.x, pos.y);
	end
end 

function TARGET_BUFF_UPDATE(frame, timer, argStr, argNum, passedTime)
	local handle= session.GetTargetHandle();
	BUFF_TIME_UPDATE(handle, t_buff_ui);
end

function TARGETBUFF_ON_MSG(frame, msg, argStr, argNum)
	local handle = session.GetTargetHandle();
	if msg == "TARGET_BUFF_ADD" then
		if TARGETBUFF_DEBUFF_LIMIT(frame, handle, argNum) == false then 
		COMMON_BUFF_MSG(frame, "ADD", argNum, handle, t_buff_ui, argStr);
		end
	elseif msg == "TARGET_BUFF_REMOVE" then
		COMMON_BUFF_MSG(frame, "REMOVE", argNum, handle, t_buff_ui, argStr);
	elseif msg == "TARGET_BUFF_UPDATE" then
		COMMON_BUFF_MSG(frame, "UPDATE", argNum, handle, t_buff_ui, argStr);
	elseif msg == "TARGET_SET" then
		if s_lsgmsg == msg and s_lasthandle == handle then
			return;
		end
		s_lsgmsg = msg;
		s_lasthandle = handle;
		COMMON_BUFF_MSG(frame, "CLEAR", argNum, handle, t_buff_ui);		
		local isLimitDebuff = tonumber(frame:GetUserValue("IS_LIMIT_DEBUFF"));
		if isLimitDebuff == 1 then
			ui.TargetBuffAddonMsg("SET", handle);
		else
		COMMON_BUFF_MSG(frame, "SET", argNum, handle, t_buff_ui);
		end
		TARGETBUFF_VISIBLE(frame, 1);
	elseif msg == "TARGET_CLEAR" then
		if s_lsgmsg == msg then 
			return;
		end
		s_lsgmsg = msg;
		COMMON_BUFF_MSG(frame, "CLEAR", argNum, handle, t_buff_ui);
		TARGETBUFF_VISIBLE(frame, 0);		
	end
	
	TARGET_BUFF_UPDATE(frame);
	TARGETBUFF_RESIZE(frame, t_buff_ui);
end 

function TARGETBUFF_RESIZE(frame, buff_ui)
	local buffcount_slotsets = buff_ui["slotsets"][0];
	local buff_slotsets = buff_ui["slotsets"][1];
	local debuff_slotsets = buff_ui["slotsets"][2];
	local buffcount_subslotsets = buff_ui["slotsets"][3];
	local height = buffcount_slotsets:GetHeight() + buffcount_subslotsets:GetHeight() + buff_slotsets:GetHeight() + debuff_slotsets:GetHeight();
	frame:Resize(frame:GetWidth(), height + 30);
end

--------------------------------------------------------------------------------------------------
function TARGETBUFF_VISIBLE(frame, isVisible)
	if frame == nil then return; end
	local button = GET_CHILD_RECURSIVELY(frame, "debuffminimizebutton");
	if button ~= nil then
		button:SetVisible(isVisible);
	end
end

function TARGETBUFF_DEBUFF_TOGGLE(frame, button)
	local option = config.GetShowTargetDeBuffMinimize();
	if option == nil or option == 0 then
		config.SetShowTargetDeBuffMinimize(1);
	elseif option == 1 then
		config.SetShowTargetDeBuffMinimize(0);
	end
end

function TARGETBUFF_DEBUFF_LIMIT(frame, handle, buffType)
	if handle == nil then
		return false;
	end

	if buffType == nil or buffType == 0 then
		return false;
	end

	local option = config.GetShowTargetDeBuffMinimize();
	local isLimitDebuff = tonumber(frame:GetUserValue("IS_LIMIT_DEBUFF"));
	if isLimitDebuff == 1 and option == 1 then
		local buffCls = GetClassByType('Buff', buffType);
		if buffCls ~= nil and buffCls.Group1 == "Debuff" then
			return true;
		end
	end
	
	return false;
end

function TARGETBUFF_DEBUFF_MINIMIZE_CHECK(isLimitDebuff)
	local frame = ui.GetFrame("targetbuff");
	if frame ~= nil then
		frame:SetUserValue("IS_LIMIT_DEBUFF", isLimitDebuff);
	end
end

function TARGETBUFF_DEBUFF_MINIMIZE_ON_MSG(msg, argStr, argNum)
	local frame = ui.GetFrame("targetbuff");
	if frame ~= nil then
		local handle = session.GetTargetHandle();
		if handle ~= nil then
			if msg == "ADD" then
				COMMON_BUFF_MSG(frame, msg, argNum, handle, t_buff_ui, argStr);
				TARGET_BUFF_UPDATE(frame);
				TARGETBUFF_RESIZE(frame, t_buff_ui);
			end
		end
	end
end

function TARGETBUFF_DEBUFF_BUTTON_UPDATE()
	local handle = session.GetTargetHandle();
	if handle ~= nil then
		local frame = ui.GetFrame("targetbuff");
		if frame == nil then return; end
		local button = GET_CHILD_RECURSIVELY(frame, "debuffminimizebutton");
		if button ~= nil then
			local option = config.GetShowTargetDeBuffMinimize();
			if option == 1 then
				local maxImageName = frame:GetUserConfig("DEBUFF_MAX_BTN_IMAGE_NAME");
				button:SetImage(maxImageName);
				button:SetTextTooltipByTargetBuff(ClMsg("TargetBuffButtonToolTipMax"));
				ui.ChangeTooltipTextByTargetBuff(ClMsg("TargetBuffButtonToolTipMax"));
			elseif option == 0 then
				local minImageName = frame:GetUserConfig("DEBUFF_MIN_BTN_IMAGE_NAME");
				button:SetImage(minImageName);
				button:SetTextTooltipByTargetBuff(ClMsg("TargetBuffButtonToolTipMin"));
				ui.ChangeTooltipTextByTargetBuff(ClMsg("TargetBuffButtonToolTipMin"));
			end
			button:Resize(26, 26);
			button:Invalidate();
		end
	end
end

function TARGETBUFF_DBUFF_SLOTSET_MINIMIZE()
	local frame = ui.GetFrame("targetbuff");
	if frame ~= nil then
		if t_buff_ui ~= nil then
			local row = 2;
			local col = t_buff_ui["slotsets"][2]:GetCol();
			t_buff_ui["slotsets"][2]:SetColRow(col, row);
			t_buff_ui["slotsets"][2]:AutoCheckDecreaseRow();
			t_buff_ui["slotsets"][2]:Invalidate();
			frame:Invalidate();
		end
	end
end