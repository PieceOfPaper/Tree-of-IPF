
function MIC_ON_INIT(addon, frame)

	addon:RegisterMsg('CHANGE_CLIENT_SIZE', 'MIC_SIZE_UPDATE');
	addon:RegisterMsg('MOVE_ZONE', 'MIC_REMOVE_CONTEXT_MENU');

	-- if mouse over, stop flow text during 2 seconds	
	frame:SetEventScript(ui.MOUSEMOVE, "MIC_MOUSE_OVER");	

	MIC_SIZE_UPDATE(frame);
	RUN_MIC();

end

function MIC_REMOVE_CONTEXT_MENU()
	ui.CloseAllContextMenu()
end

function MIC_SIZE_UPDATE(frame)
	if ui.GetSceneHeight() / ui.GetSceneWidth() <= ui.GetClientInitialHeight() / ui.GetClientInitialWidth() then
		frame:Resize(-50, 0, (ui.GetSceneWidth() * ui.GetClientInitialHeight() / ui.GetSceneHeight()) + 100, frame:GetOriginalHeight());
	else
		frame:Resize(-50, 0, ui.GetClientInitialWidth() + 100, frame:GetOriginalHeight());
	end
	
	frame:Invalidate();
end

function RUN_MIC()
	local frame = ui.GetFrame("mic");

	local showMicFrameValue = config.GetXMLConfig("ShowMicFrame")
	
	if showMicFrameValue == 0 then
		frame:ShowWindow(0);
	else
		frame:ShowWindow(1);
	end


	frame:RunUpdateScript("PROCESS_MIC", 0.01, 0, 0, 1);
end

function SHOW_PC_CONTEXT_MENU_BY_NAME(familyName)
	if familyName == nil then
		return nil
	end

	local pc = GetMyPCObject()
	local myName = TryGetProp(pc, 'Name')
	if myName ~= nil and myName == familyName then
		return nil
	end

	local context = ui.CreateContextMenu("PC_CONTEXT_MENU", familyName, 0, 0, 170, 100);
	if session.world.IsIntegrateServer() == false then
		-- whisper 
		local strScp = string.format("ui.WhisperTo('%s')", familyName);		
		ui.AddContextMenuItem(context, ClMsg("WHISPER"), strScp);

		-- invite party
		strScp = string.format("PARTY_INVITE(\"%s\")", familyName);
		ui.AddContextMenuItem(context, ClMsg("PARTY_INVITE"), strScp);

		-- invite guild
		if AM_I_LEADER(PARTY_GUILD) == 1 or IS_GUILD_AUTHORITY(1) == 1 then
			strScp = string.format("GUILD_INVITE(\"%s\")", familyName);
			ui.AddContextMenuItem(context, ClMsg("GUILD_INVITE"), strScp);
		end

		-- register friend
		strScp = string.format("friends.RequestRegister('%s')", familyName);
		ui.AddContextMenuItem(context, ScpArgMsg("ReqAddFriend"), strScp);

		-- block
		strScp = string.format("CHAT_BLOCK_MSG('%s')", familyName);
		ui.AddContextMenuItem(context, ScpArgMsg("FriendBlock"), strScp)

		-- report auto bot
		strScp =  string.format("REPORT_AUTOBOT_MSGBOX(\"%s\")", familyName)
		ui.AddContextMenuItem(context, ScpArgMsg("Report_AutoBot"), strScp);

		-- cancel
		ui.AddContextMenuItem(context, ScpArgMsg("Cancel"), "None");
	end

	ui.OpenContextMenu(context);
	return context;
end


function CHANGE_LINKTEXT_COLOR(micText, changeColor)
	local filterByColorTag = StringSplit(micText, "{#");
	if #filterByColorTag == 1 then
		return micText;
	end

	local retStr = filterByColorTag[1];
	for i = 2 , #filterByColorTag do
		retStr = retStr .. "{#FFFF00}";
		local str = filterByColorTag[i];
		retStr = retStr .. string.sub(str, 8, string.len(str));
	end

	return retStr;
end

function MIC_PUSH(frame, mic)
	if config.GetXMLConfig("ShowMicFrame") == 0 then
		frame:RemoveAllChild();
		return;
	end

	local lastCtrl = nil;
	for i = 0 , frame:GetChildCount() - 1 do
		local ctrl = frame:GetChildByIndex(i);
		lastCtrl = ctrl;
	end

	local startX = frame:GetWidth() + 100
	if lastCtrl ~= nil and lastCtrl:GetX() + lastCtrl:GetWidth() > startX - 30 then
		return 0;
	end

	local index = frame:GetUserIValue("CTRL_INDEX");
	local ctrlName = "T_" .. index;
	local ctrl = frame:CreateControl("richtext", ctrlName, startX, 0, 10, 20);
	
	local rBtnHandler = string.format("SHOW_PC_CONTEXT_MENU_BY_NAME('%s')", mic:GetName())
	ctrl:SetEventScript(ui.RBUTTONDOWN, rBtnHandler)
	ctrl:SetEventScript(ui.MOUSEMOVE, "MIC_MOUSE_OVER")

	ctrl:ShowWindow(1);
	ctrl = tolua.cast(ctrl, "ui::CRichText");
	ctrl:SetUseOrifaceRect(true);
	ctrl:EnableResizeByText(1);

	--local imgName = ui.CaptureModelHeadImage_IconInfo(mic:GetIconInfo());
	--local txt = string.format("{@st41}{img %s 20 20}[%s] : %s", imgName, mic:GetName(), mic:GetText());
	
	local micText = mic:GetText();
	local slflag = string.find(micText,'a SL%a')
	if slflag ~= nil then
		micText = CHANGE_LINKTEXT_COLOR(micText, "{#CCCCFF}");
	end

	local txt = string.format("{s20}{ol}{#FFFFFF}[%s] : %s", mic:GetName(), micText);

	--[[ all mic can be enable hit: rBtnDown->context menu function
	local slflag = string.find(txt,'a SL%a')

	if slflag == nil then
		ctrl:EnableHitTest(0)
	else
		ctrl:EnableHitTest(1)
	end
	]]--
	ctrl:EnableHitTest(1)

	ctrl:SetText(txt);

	frame:SetUserValue("CTRL_INDEX", index + 1);
	return 1;

end

function PROCESS_MIC(frame, totalTime)

	if ui.IsStopFlowText() == 1 then
		return 1;
	end
	
	local showMicFrameValue = config.GetXMLConfig("ShowMicFrame")
	if showMicFrameValue == 0 then
		frame:ShowWindow(0);
		return 1;
	else
		if frame:GetChildCount() > 0 then
			frame:ShowWindow(1);
		end
	end


	local spd = 100;
	local elapsed = imcTime.GetElapasedTime();
	local accum = frame:GetValue();

	accum = accum + elapsed * 1000 * spd;

	local dx = 0;
	dx = math.floor(accum / 1000);
	accum = accum % 1000;
	
	frame:SetValue(accum);

	if dx == 0 then
		return 1;
	end

	for i = 0 , frame:GetChildCount() - 1 do
		local ctrl = frame:GetChildByIndex(i);
		local x = ctrl:GetX();
		x = x - dx;
		ctrl:SetOffset(x, ctrl:GetY());
	end

	if frame:GetChildCount() > 0 then
		frame:Invalidate();
		local ctrl = frame:GetChildByIndex(0);
		if ctrl:GetX() < -ctrl:GetWidth() then
			frame:RemoveChildByIndex(0);
		end
	end

	local mic = session.ui.GetMic();
	if mic ~= nil then
		if mic.showMicFrame == 0 or MIC_PUSH(frame, mic) == 1 then
			session.ui.RemoveMicHead();
		end
	else
		if frame:GetChildCount() == 0 then
			frame:ShowWindow(0);

		end
	end

	return 1;
end

function MIC_MOUSE_OVER()
	ui.StopMicFlowText();
end
