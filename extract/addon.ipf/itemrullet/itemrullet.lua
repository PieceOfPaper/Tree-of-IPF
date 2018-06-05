
--[[
function ITEMRULLET_ON_INIT(addon, frame)


end

function ITEMRULLET_CREATE(addon, frame)

	RULLET_FRAME_SET_UPDATE(frame);	
	
end

function SHOW_RULLET_INFO(info, index, totalCnt)

	local groupName = GET_RULLET_GROUPNAME(info.groupFirstType);
	local frame = OPENNEW('itemrullet');
	SET_RULLET_POS_BY_INDEX(frame, index, totalCnt);
	
	SET_SCORE_PROP_TO_FRAME(frame, info.name);
	EXEC_RULLET_TO_FRAME(frame, groupName, info.selectedType);
	frame:ShowWindow(1);

end

function EXEC_RULLET_TO_FRAME(frame, groupName, selectedType)

	SHOW_RULLET_BY_GROUP(frame, groupName, selectedType);

end

function SET_SCORE_PROP_TO_FRAME(frame, pcName)

	local pcInfo = session.GetLayerPCInfo(pcName);
	if pcInfo == nil then
		frame:SetTextByKey("pcName", pcName);
		frame:GetChild("scoreGBox"):ShowWindow(0);
		frame:Resize(frame:GetWidth(), 200);
	else
		local name = pcInfo.name;
		local obj = GetIES(pcInfo:GetIESObject());
		frame:SetTextByKey("pcName", name);
		frame:SetTextByKey("kill", obj.Step1);
		frame:SetTextByKey("overkill", obj.Step2);
		frame:SetTextByKey("hit", obj.Step3);
		frame:SetTextByKey("dead", obj.Step4);
	
		local min, sec = GET_QUEST_MIN_SEC(obj.Step24);				
		frame:SetTextByKey("time", ScpArgMsg("Auto_{Auto_1}Bun_{Auto_2}Cho","Auto_1", min, "Auto_2",sec) );
		frame:SetTextByKey("total", obj.Step25);
	end

end


function GET_RULLET_GROUPNAME(type)

	local group = GetClassByType("Rullet", type);
	local name = group.ClassName;
	return string.sub(name, 1, string.len(name) - 2);

end

function SET_RULLET_POS_BY_INDEX(frame, index, totalCnt)

	local perPage = RULLET_PER_PAGE;
	totalCnt = totalCnt % RULLET_PER_PAGE;
	index = index % RULLET_PER_PAGE;

	local perRow = RULLET_PER_PAGE / 2;
	
	local screenWidth	=  ui.GetClientInitialWidth();
	local screenHeight	=  ui.GetClientInitialHeight();
	local fWidth = frame:GetWidth();
	local fHeight = frame:GetHeight();
		
	if totalCnt == 1 then
		frame:MoveFrame((screenWidth - fWidth) / 2, frame:GetY());
		return;
	end

	local row = math.floor(index / perRow);
	local col = index % perRow;
	
	local x = col * fWidth + 100;
	local y = row * fHeight + 100;
	
	frame:MoveFrame(x, y);
	
end

function SHOW_RULLET_BY_GROUP(frame, groupName, type)

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetArgString(groupName);
	timer:SetArgNum(type);
	
	RULLET_FRAME_SET_UPDATE(frame);

end

function UPDATE_RULLET_TIME(frame, timer, groupName, argNum, time)

	local slot = frame:GetChild("giftitem");
	tolua.cast(slot, "ui::CSlot");	
	local itemname = frame:GetChild("itemname");

	if time > 2.0 then
		STOP_RULLET_TIMER(frame);
		RULLET_FRAME_SET_HIDE(frame);
		local item = GET_RULLET_ITEM_BY_TYPE(argNum);
		SET_RULLET_ITEM_IMG(item, slot, itemname);
		return;
	end
	
	local cls = GET_RANDOM_GROUP_CLS(groupName);
	SET_RULLET_IMAGE(cls, slot, itemname);
end

function UPDATE_RULLET_TIME_HIDE(frame, timer, str, num, time)

	if time > RULLET_FREEZE_TIME then
		STOP_RULLET_TIMER(frame);
		frame:ShowWindow(0);	
	end
	
end

------------------------ lib functions

function STOP_RULLET_TIMER(frame)
	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:Stop();
	--imcSound.PlaySoundItem('sys_confirm');
end

function RULLET_FRAME_SET_UPDATE(frame)

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_RULLET_TIME");
	timer:Start(0.1);
	
end

function RULLET_FRAME_SET_WAIT(frame)

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_RULLET_TIME_WAIT");
	timer:Start(0.1);

end

function RULLET_FRAME_SET_HIDE(frame)

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("UPDATE_RULLET_TIME_HIDE");
	timer:Start(0.1);

end


function SET_RULLET_ITEM_IMG(itemCls, slot, itemname)

	local icon = CreateIcon(slot);
	local imgName = itemCls.Icon;
	icon:SetImage(imgName);
	slot:Invalidate();
	
	SET_ITEM_TOOLTIP_BY_TYPE(icon, itemCls.ClassID);
	ui.UpdateVisibleToolTips();
	--imcSound.PlaySoundItem('inven_equip');
	itemname:SetText(itemCls.Name);

end

function SET_RULLET_IMAGE(cls, slot, itemname)

	local itemCls = GetClass("Item", cls.Name);
	
	SET_RULLET_ITEM_IMG(itemCls, slot, itemname);
		
	local blinkColor = cls.BlinkColor;
	if blinkColor == "None" then
		slot:ReleaseBlink();
	else
		slot:SetBlink(600000, 0.5, blinkColor, 1);
	end
end

function GET_RANDOM_GROUP_CLS(group)

	local list = GET_CLS_GROUP("Rullet", group);
	local cnt = #list;
	local idx = IMCRandom(1, cnt);
	local cls = list[idx];
	return cls;

end

function GET_RULLET_ITEM_BY_TYPE(type)

	local cls = GetClassByType("Rullet", type);
	return GetClass("Item", cls.Name);

end


function CHECK_R_ITEMNAME_VALID()

	local clsList, cnt = GetClassList("Rullet");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		local itemName = cls.Name;
		local cls = GetClass("Item", itemName);
		if cls == nil then
			print(itemName .. "  ".. "Not Exist");
		end
	end

end
]]