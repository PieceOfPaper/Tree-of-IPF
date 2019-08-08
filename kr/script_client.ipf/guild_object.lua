
function GUILD_ITEM_OBJECT_CHECK()
	return true;
end

function GUILD_SEND_CLICK_TRIGGER(handle)
	local mobj = GetMyActor();
	local comHandle = handle;
	if handle == nil then
		comHandle = mobj:GetUserIValue("COMPANION_HANDLE");
	end
	
	packet.SendClickTrigger(comHandle);
end

function GUILD_ITEM_OBJECT(actor, isSelect)
	local guid = actor:GetUserSValue("GUID");
	local obj = session.guildHouse.GetObjectByStrGuid(guid);
	if obj == nil then
		return;
	end

	local clsName = obj:GetPropValue("ClassName");
	local seedCls = GetClass("Seed", clsName);
	if nil == seedCls then
		return;
	end

	local objType = seedCls.ObjType;
	if isSelect == 2 then	
		local frame = ui.GetFrame("plantwater");
		local pic = GET_CHILD(frame, "pic");
		pic:SetImage(seedCls.GaugeIcon);
		
		WATER_VALUE_FRAME_UPDATE(frame, obj);
		frame:SetUserValue("GUID", guid);
		frame:ShowWindow(1);

		local offsetY = 0;
		FRAME_AUTO_POS_TO_OBJ(frame, actor:GetHandleVal(), -frame:GetWidth() / 2, offsetY, 3);
	elseif isSelect == 1 then
		if objType == "Animal" and seedCls.FullGrowMin <= obj:GetPropIValue("Age") then
			if  1 == TRY_CHECK_BARRACK_SLOT(actor:GetHandleVal(), 1) then
				return;
			end
			local mobj = GetMyActor();
			mobj:SetUserValue("COMPANION_HANDLE", tostring(actor:GetHandleVal()));
		else
			packet.SendClickTrigger(actor:GetHandleVal());
		end
	elseif isSelect == 0 then
		ui.CloseFrame("plantwater");
	end
end

function GUILD_ITEM_OBJECT_UPDATE(guid)
	local frame = ui.GetFrame("plantwater");
	if frame:IsVisible() == 0 then
		return;
	end

	local obj = session.guildHouse.GetObjectByStrGuid(guid);
	if obj == nil then
		return;
	end

	local clsName = obj:GetPropValue("ClassName");
	local seedCls = GetClass("Seed", clsName);
	local fullGrowMin = seedCls.FullGrowMin;
	local curGuid = frame:GetUserValue("GUID");
	if curGuid ~= guid then
		return;
	end

	WATER_VALUE_FRAME_UPDATE(frame, obj, fullGrowMin);
end


function GUILD_ITEM_OBJECT_PROP_CHANGE(guid, propName, beforeValue, afterValue)
	local frame = ui.GetFrame("plantwater");
	if frame:IsVisible() == 0 then
		return;
	end

	local curGuid = frame:GetUserValue("GUID");
	if curGuid ~= guid then
		return;
	end

	local obj = session.guildHouse.GetObjectByStrGuid(guid);
	if obj == nil then
		return;
	end

	local clsName = obj:GetPropValue("ClassName");
	local seedCls = GetClass("Seed", clsName);
	local fullGrowMin = seedCls.FullGrowMin;

	if propName == "WaterValue" then
		local watergauge = GET_CHILD(frame, "watergauge");
		watergauge:SetPointWithTime(afterValue, 1);
	else
		WATER_VALUE_FRAME_UPDATE(frame, obj);
	end
end

function WATER_VALUE_FRAME_UPDATE(frame, obj, fullGrowMin)
	if frame == nil then return; end

	local watergauge = GET_CHILD(frame, "watergauge");
	local pic = GET_CHILD(frame, "pic");
	if pic ~= nil and watergauge ~= nil then	
		local clsName = obj:GetPropValue("ClassName");
		local seedCls = GetClass("Seed", clsName);
		local fullGrowMin = seedCls.FullGrowMin;
		local age = obj:GetPropIValue("Age");
		if fullGrowMin ~= nil and fullGrowMin <= age then
			pic:SetVisible(0);
			watergauge:SetVisible(0);
			return;
		elseif fullGrowMin ~= nil and fullGrowMin > age then
			pic:SetVisible(1);
			watergauge:SetVisible(1);
		end

		local waterValue = obj:GetPropIValue("WaterValue");
		watergauge:SetPoint(waterValue, 10000);
	end
end

