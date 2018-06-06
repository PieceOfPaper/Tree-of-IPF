
function MIC_ON_INIT(addon, frame)

	addon:RegisterMsg('CHANGE_CLIENT_SIZE', 'MIC_SIZE_UPDATE');
	MIC_SIZE_UPDATE(frame);
	RUN_MIC();

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

	local slflag = string.find(txt,'a SL%a')
	if slflag == nil then
		ctrl:EnableHitTest(0)
	else
		ctrl:EnableHitTest(1)
	end

	ctrl:SetText(txt);

	frame:SetUserValue("CTRL_INDEX", index + 1);
	return 1;

end

function PROCESS_MIC(frame, totalTime)

	
	local showMicFrameValue = config.GetXMLConfig("ShowMicFrame")
	
	if showMicFrameValue == 0 then
		frame:ShowWindow(0);
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
		if MIC_PUSH(frame, mic) == 1 then
			session.ui.RemoveMicHead();
		end
	else
		if frame:GetChildCount() == 0 then
			frame:ShowWindow(0);

		end
	end

	return 1;
end


