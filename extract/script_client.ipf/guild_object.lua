
function GUILD_ITEM_OBJECT_CHECK()
	return true;
end

function GUILD_ITEM_OBJECT(actor, isSelect)

	if isSelect == 2 then

		local guid = actor:GetUserSValue("GUID");
		local obj = session.guildHouse.GetObjectByStrGuid(guid);
		if obj == nil then
			return;
		end

		local clsName = obj:GetPropValue("ClassName");
		local seedCls = GetClass("Seed", clsName);
		local objType = seedCls.ObjType;
		
		local frame = ui.GetFrame("plantwater");
		local pic = GET_CHILD(frame, "pic");
		if objType == "Plant" then		
			pic:SetImage("icon_item_wateringcan");
		else
			pic:SetImage("icon_item_meat_01");
		end

		WATER_VALUE_FRAME_UPDATE(frame, obj);
		frame:SetUserValue("GUID", guid);
		frame:ShowWindow(1);
		local offsetY = 0;
		FRAME_AUTO_POS_TO_OBJ(frame, actor:GetHandleVal(), -frame:GetWidth() / 2, offsetY, 3);

	elseif isSelect == 1 then

		packet.SendClickTrigger(actor:GetHandleVal());

	elseif isSelect == 0 then

		local guid = actor:GetUserSValue("GUID");
		local obj = session.guildHouse.GetObjectByStrGuid(guid);
		if obj == nil then
			return;
		end

		local clsName = obj:GetPropValue("ClassName");
		local seedCls = GetClass("Seed", clsName);
		local objType = seedCls.ObjType;

		if objType == "Plant" then
			ui.CloseFrame("plantwater");
		else

		end

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

