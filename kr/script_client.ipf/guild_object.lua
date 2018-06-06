
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
		---if objType == "Plant" then
			ui.CloseFrame("plantwater");
		--end

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

	local curGuid = frame:GetUserValue("GUID");
	if curGuid ~= guid then
		return;
	end

	WATER_VALUE_FRAME_UPDATE(frame, obj);

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

	if propName == "WaterValue" then
		local watergauge = GET_CHILD(frame, "watergauge");
		watergauge:SetPointWithTime(afterValue, 1);
	else
		WATER_VALUE_FRAME_UPDATE(frame, obj);
	end
	

end

function WATER_VALUE_FRAME_UPDATE(frame, obj)
	local waterValue = obj:GetPropIValue("WaterValue");			
	local watergauge = GET_CHILD(frame, "watergauge");
	watergauge:SetPoint(waterValue, 10000);
end

