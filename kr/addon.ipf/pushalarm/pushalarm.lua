function PUSHALARM_ON_INIT(addon, frame)
	
	
end

function UPDATE_ALL_PUSH_MSG(frame)

	frame:RemoveAllChild();

	local cnt = session.bindFunc.GetPushMsgCount();
	for i = 0 , cnt - 1 do
		local msgInfo = session.bindFunc.GetPushMsgByIndex(i);
		local ctrlSet = frame:CreateOrGetControlSet("pushalarm_control", "PUSH_" .. msgInfo:GetKey(), 15, 0);
		local text = ctrlSet:GetChild("text");
		text:SetTextByKey("value", msgInfo:GetMsg());		
		ctrlSet:Resize(ctrlSet:GetWidth(), text:GetHeight() + 20);
		ctrlSet:SetEventScript(ui.LBUTTONUP, "RUN_PUSH_MSG_CB");
		ctrlSet:EnableChangeMouseCursor(1);
		ctrlSet:SetUserValue("KEY", msgInfo:GetKey());
	end

	if cnt > 0 then
		GBOX_AUTO_ALIGN(frame, 15, 3, 10, true, true);
		frame:ShowWindow(1);
	else
		frame:ShowWindow(0);
	end
	
end

function RUN_PUSH_MSG_CB(parent, ctrlSet)
	local key = ctrlSet:GetUserValue("KEY");
	local msgInfo = session.bindFunc.GetPushMsgByKey(key);
	local cbFunc = msgInfo:GetCallBack();
	cbFunc = _G[cbFunc];
	cbFunc(msgInfo);
end

function UPDATE_PUSH_MSG(key)
	local frame = ui.GetFrame("pushalarm");
	local msgInfo = session.bindFunc.GetPushMsgByKey(key);
	local ctrlSet = frame:CreateOrGetControlSet("pushalarm_control", "PUSH_" .. key, 15, 0);
	if ctrlSet ~= nil then
		local text = ctrlSet:GetChild("text");
		text:SetTextByKey("value", msgInfo:GetMsg());		
		ctrlSet:Resize(ctrlSet:GetWidth(), text:GetHeight() + 0);
		ctrlSet:SetEventScript(ui.LBUTTONUP, "RUN_PUSH_MSG_CB");
		ctrlSet:EnableChangeMouseCursor(1);
		ctrlSet:SetUserValue("KEY", msgInfo:GetKey());
	end
	
	local cnt = session.bindFunc.GetPushMsgCount();
	if cnt > 0 then
		GBOX_AUTO_ALIGN(frame, 15, 3, 10, true, true);
		frame:ShowWindow(1);
	else
		frame:ShowWindow(0);
	end
	
end

function ADD_PUSH_MSG(key)
	UPDATE_PUSH_MSG(key);	
end

function REMOVE_PUSH_MSG(key)
	local frame = ui.GetFrame("pushalarm");
	local ctrlName = "PUSH_" .. key;
	frame:RemoveChild(ctrlName);
	local cnt = session.bindFunc.GetPushMsgCount();
	if cnt > 0 then
		GBOX_AUTO_ALIGN(frame, 15, 3, 10, true, true);
		frame:ShowWindow(1);
	else
		frame:ShowWindow(0);
	end
	
end



