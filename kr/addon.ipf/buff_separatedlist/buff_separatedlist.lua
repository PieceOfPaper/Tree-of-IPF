-- buff_separateedlist
function BUFF_SEPARATEDLIST_ON_INIT(addon, frame)
	addon:RegisterMsg('BUFF_ADD', 'BUFF_SEPARATED_ON_MSG');
	addon:RegisterMsg('BUFF_REMOVE', 'BUFF_SEPARATED_ON_MSG');
	addon:RegisterMsg('BUFF_UPDATE', 'BUFF_SEPARATED_ON_MSG');
	addon:RegisterMsg('RELOAD_BUFF_ADD', 'BUFF_SEPARATED_ON_MSG');
	INIT_BUFF_SEPARATEDLIST_UI(frame);
end

function BUFF_SEPARATEDLIST_ON_RELOAD(frame)
	INIT_BUFF_SEPARATEDLIST_UI(frame);
end

function INIT_BUFF_SEPARATEDLIST_UI(frame)
	if frame ~= nil then
		local charbaseinfoFrame = ui.GetFrame("charbaseinfo1_my");
		if charbaseinfoFrame ~= nil then
			frame:MoveFrame(option.GetClientWidth() / 2 + 100, option.GetClientHeight() / 2 + 350);
		end

		local timer = GET_CHILD_RECURSIVELY(frame, "addontimer");
		tolua.cast(timer, "ui::CAddOnTimer");
		timer:SetUpdateScript("BUFF_SEPARATED_TIME_UPDATE");
		timer:Start(0.45);

		frame:SetUserConfig("BUFF_ROW", 0);
		frame:SetUserConfig("BUFF_COL", 0);

		local gbox = GET_CHILD_RECURSIVELY(frame, "gbox");
		gbox:ShowWindow(1);

		local buffGBox = GET_CHILD_RECURSIVELY(frame, "buffGBox");
		if buffGBox == nil then
			return;
		end

		local offsetX = tonumber(frame:GetUserConfig("DEFAULT_SLOT_X_OFFSET"));
		local offsetY = tonumber(frame:GetUserConfig("DEFAULT_SLOT_Y_OFFSET"));
		local gboxAdd = tonumber(frame:GetUserConfig("GBOX_ADD"));
		local defaultwidth = tonumber(frame:GetUserConfig("DEFAULT_GBOX_WIDTH"));
		BUFF_SEPARATEDLIST_CTRLSET_GBOX_AUTO_ALIGN(buffGBox, 10, offsetX, gboxAdd, defaultwidth, true, offsetY, true);
		buffGBox:Invalidate();

		if buffGBox:GetChildCount() <= 1 then
			frame:ShowWindow(0);
		end
		
		BUFF_SEPARATED_LIST_CHECKSIZE(frame);
		BUFF_SEPARATEDLIST_SET_POS(frame);
	end
end

function BUFF_SEPARATEDLIST_SET_POS(frame)
	if frame ~= nil then
		local pos = ui.GetCatchMovePos(frame:GetName());
		if pos.x == 0 and pos.y == 0 then
			return;
		end
		frame:MoveFrame(pos.x, pos.y);
	end
end

function BUFF_SEPARATED_TIME_UPDATE(frame, timer, argstr, argnum, passedtime)
	local myhandle = session.GetMyHandle();
	local TOKEN_BUFF_ID = TryGetProp(GetClass("Buff", "Premium_Token"), "ClassID");

	local gbox = GET_CHILD_RECURSIVELY(frame, "buffGBox");
	if gbox == nil then
		return;
	end

	local updated = 0;
	local cnt = gbox:GetChildCount();
	for i = 1, cnt do 
		local ctrlSet = gbox:GetChildByIndex(i - 1);
		if ctrlSet ~= nil then
			local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot");
			local text = GET_CHILD_RECURSIVELY(ctrlSet, "caption");
			if slot:IsVisible() == 1 then
				local icon = slot:GetIcon();
				local iconInfo = icon:GetInfo();
				local buffIndex = icon:GetUserIValue("BuffIndex");
				local buff = info.GetBuff(myhandle, iconInfo.type, buffIndex);
				if buff ~= nil then
					text:SetText(GET_BUFF_TIME_TXT(buff.time, 0));
					updated = 1;

					if buff.time < 5000 and buff.time ~= 0.0 then
						if slot:IsBlinking() == 0 then
							slot:SetBlink(600000, 1.0, "55FFFFFF", 1);
						end
					elseif buff.buffID == TOKEN_BUFF_ID and GET_REMAIN_TOKEN_SEC() < 3600 then
						if slot:IsBlinking() == 0 then
							slot:SetBlink(0, 1.0, "55FFFFFF", 1);
						end
					else
						if slot:IsBlinking() == 1 then
							slot:ReleaseBlink();
						end
					end
				end
			end
		end
	end

	if updated == 1 then
		ui.UpdateVisibleToolTips("buff");
	end
end

function BUFF_SEPARATED_LIST_CHECKSIZE(frame)
	local gbox = GET_CHILD_RECURSIVELY(frame, "gbox");
	if gbox == nil then
		return;
	end

	BUFF_SEPARATED_LIST_GBOX_AUTO_ALIGN(gbox, 20, 15, 0, 0, true, true);
	gbox:Invalidate();

	frame:Resize(frame:GetWidth(), gbox:GetHeight());
	frame:Invalidate();
end

function BUFF_SEPARATED_ON_MSG(frame, msg, argStr, argNum)
	local handle = session.GetMyHandle();
	if msg == "BUFF_ADD" or msg == "BUFF_UPDATE" or msg == "RELOAD_BUFF_ADD" then
		BUFF_SEPARATEDLIST_CTRLSET_CREATE(frame, handle, argStr, argNum);
	elseif msg == "BUFF_REMOVE" then
		BUFF_SEPARATEDLIST_CTRLSET_REMOVE(frame, handle, argStr, argNum);
	end

	BUFF_SEPARATED_TIME_UPDATE(frame);	
	BUFF_SEPARATED_LIST_CHECKSIZE(frame);
end

function BUFF_SEPARATEDLIST_CTRLSET_CREATE(frame, handle, buffIndex, buffID)
	local buff = info.GetBuff(tonumber(handle), buffID);
	local buffCls = GetClassByType("Buff", buffID);
	if buffCls == nil then
		return;
	end

	if buffCls.ShowIcon == "FALSE" then
		return;
	end
	
	if BUFF_CHECK_SEPARATELIST(buffID) == false then
		return;
	end
	
	CTRLSET_CREATE(frame, handle, buff, buffCls, buffIndex, buffID);
end

function CTRLSET_CREATE(frame, handle, buff, buffCls, buffIndex, buffID)
	if frame ~= nil then
		frame:ShowWindow(1);
	end

	local gbox = GET_CHILD_RECURSIVELY(frame, "buffGBox");
	if gbox == nil then
		return;
	end

	if handle == nil then
		return; 
	end

	local colCnt = tonumber(frame:GetUserConfig("COL_COUNT"));
	local row = tonumber(frame:GetUserConfig("BUFF_ROW"));
	local col = tonumber(frame:GetUserConfig("BUFF_COL"));

	if col % colCnt == 0 and col >= colCnt then
		col = 0;
		row = row + 1;
		frame:SetUserConfig(row_configname, row);
	end		

	local ctrlSet = gbox:CreateOrGetControlSet("bufficon_slot", "BUFFSLOT_buff"..buffID, 0, 0);
	if ctrlSet == nil then
		return;
	end

	col = col + 1;
	frame:SetUserConfig(col_configname, col);

	local slot = GET_CHILD_RECURSIVELY(ctrlSet, "slot");
	local caption = GET_CHILD_RECURSIVELY(ctrlSet, "caption");
	if slot ~= nil and caption ~= nil then
		local icon = CreateIcon(slot);
		local iconImageName = GET_BUFF_ICON_NAME(buffCls);
		if iconImageName == "icon_ability_Warrior_Hoplite39" then
			iconImageName = "ability_Warrior_Hoplite39";	
		end

		icon:SetDrawCoolTimeText(0);
		icon:Set(iconImageName, "BUFF", buffID, 0);
		if buffIndex ~= nil then
			icon:SetUserValue("BuffIndex", buffIndex);
		end				

		local bufflockoffset = tonumber(frame:GetUserConfig("DEFAULT_BUFF_LOCK_OFFSET"));
		local buffGroup1 = TryGetProp(buffCls, "Group1", "Buff");
		local IsRemove = TryGetProp(buffCls, "RemoveBySkill", "NO");
		if buffGroup1 == "Debuff" and IsRemove == "YES" then
			local bufflv = TryGetProp(buffCls, "Lv", "99");
			if bufflv <= 3 then
				slot:SetBgImage("buff_lock_icon_3");
			elseif bufflv == 4 then
				slot:SetBgImage("buff_lock_icon_4");
			end
			slot:SetBgImageSize(slot:GetWidth() + bufflockoffset, slot:GetHeight() + bufflockoffset);
		end

		if buff.over > 1 then
			slot:SetText('{s13}{ol}{b}'..buff.over, 'count', ui.RIGHT, ui.BOTTOM, -5, -3);
		else
			slot:SetText("");
		end

		if slot:GetTopParentFrame():GetName() ~= "targetbuff" then
    		slot:SetEventScript(ui.RBUTTONUP, 'REMOVE_BUF');
    		slot:SetEventScriptArgNumber(ui.RBUTTONUP, buffID);
		end 

		slot:EnableDrop(0);
		slot:EnableDrag(0);

		caption:ShowWindow(1);
		caption:SetText(GET_BUFF_TIME_TXT(buff.time, 0));

		local targetinfo = info.GetTargetInfo(handle);
		if targetinfo ~= nil then
			if targetinfo.TargetWindow == 0 then
				slot:ShowWindow(0);	
			else
				slot:ShowWindow(1);
			end
		else
			slot:ShowWindow(1);
		end

		if buffCls.ClassName == "Premium_Nexon" or buffCls.ClassName == "Premium_Token" then
			icon:SetTooltipType("premium");
			icon:SetTooltipArg(handle, buffID, buff.arg1);
		else
			icon:SetTooltipType("buff");
			if buffIndex ~= nil then
				icon:SetTooltipArg(handle, buffID, buffIndex);
			end
		end

		slot:Invalidate();
	end

	local offsetX = tonumber(frame:GetUserConfig("DEFAULT_SLOT_X_OFFSET"));
	local offsetY = tonumber(frame:GetUserConfig("DEFAULT_SLOT_Y_OFFSET"));
	local gboxAdd = tonumber(frame:GetUserConfig("GBOX_ADD"));
	local defaultwidth = tonumber(frame:GetUserConfig("DEFAULT_GBOX_WIDTH"));
	BUFF_SEPARATEDLIST_CTRLSET_GBOX_AUTO_ALIGN(gbox, 10, offsetX, gboxAdd, defaultwidth, true, offsetY, true);
	gbox:Invalidate();
end

function BUFF_SEPARATEDLIST_CTRLSET_REMOVE(frame, handle, buffIndex, buffID)
	local buffCls = GetClassByType("Buff", buffID);
	if buffCls ~= nil then
		if BUFF_CHECK_SEPARATELIST(buffID) == false then
			return;
		end

		CTRLSET_REMOVE(frame, "buff", buffID);
	end
end

function CTRLSET_REMOVE(frame, groupName, buffID)
	local slotName = "BUFFSLOT_"..groupName..buffID;
	local gbox = GET_CHILD_RECURSIVELY(frame, groupName.."GBox");
	if gbox ~= nil then
		local childCnt = gbox:GetChildCount();
		if childCnt > 0 then
			for i = 0, childCnt - 1 do
				local child = gbox:GetChildByIndex(i);
				if child ~= nil and slotName == child:GetName() then
					gbox:RemoveChildByIndex(i);
					frame:Invalidate();
					break;
				end
			end

			local row = tonumber(frame:GetUserConfig("BUFF_ROW"));
			local col = tonumber(frame:GetUserConfig("BUFF_COL"));
			local colCnt = tonumber(frame:GetUserConfig("COL_COUNT"));
			if childCnt % colCnt == 0 then
				row = row - 1;
				col = colCnt;
				frame:SetUserConfig(row_configname, row);
			end
					
			if col > 0 then
				col = col - 1;
				frame:SetUserConfig(col_configname, col);
			end
		end

		if childCnt <= 1 and frame ~= nil  then
			frame:ShowWindow(0);
		end
	end

	local offsetX = tonumber(frame:GetUserConfig("DEFAULT_SLOT_X_OFFSET"));
	local offsetY = tonumber(frame:GetUserConfig("DEFAULT_SLOT_Y_OFFSET"));
	local gboxAdd = tonumber(frame:GetUserConfig("GBOX_ADD"));
	local defaultwidth = tonumber(frame:GetUserConfig("DEFAULT_GBOX_WIDTH"));
	BUFF_SEPARATEDLIST_CTRLSET_GBOX_AUTO_ALIGN(gbox, 10, offsetX, gboxAdd, defaultwidth, true, offsetY, true);
	gbox:Invalidate();
end

function FIND_BUFF_SEPARATEDLIST_VARMODE_SLOT_NAME(frame, groupName, buffID)
	local slotName = "BUFFSLOT_"..groupName..buffID;
	local gbox = GET_CHILD_RECURSIVELY(frame, groupName.."GBox");
	if gbox ~= nil then
		local cnt = gbox:GetChildCount();
		if cnt > 0 then
			for i = 0, cnt - 1 do
				local ctrl = gbox:GetChildByIndex(i);
				if ctrl ~= nil then
					if slotName == ctrl:GetName() then
						return 1;
					end
				end
			end
		end
	end

	return 0;
end

function BUFF_CHECK_SEPARATELIST(buffID)
	if buffID == nil then return; end

	local isSeparate = false;
	if ui.buff.IsBuffSeparate(buffID) == 1 then
		isSeparate = true;
	end

	return isSeparate;
end