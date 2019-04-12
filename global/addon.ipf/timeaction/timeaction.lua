
function TIMEACTION_ON_INIT(addon, frame)

	addon:RegisterMsg('TIME_ACTION', 'ON_TIME_ACTION');

end

function ON_TIME_ACTION(frame, msg, msgType, isFail, info)
	if msgType == "RESULT" then
		END_TIME_ACTION(frame, isFail);
		return;
	end
	
	info = tolua.cast(info, "TIME_ACTION_INFO");
	START_TIME_ACTION(frame, info.msg, info.time)

			
end

function START_TIME_ACTION(frame, msg, second)
	local uiList = {};
	uiList[#uiList + 1] = "reinforce_renew";
	uiList[#uiList + 1] = "manufac_renew";
	uiList[#uiList + 1] = "upgradeitem";

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	local isUI = false;
	for i = 1 , #uiList do
		if ui.IsFrameVisible(uiList[i]) == 1 then
			isUI = true;
			break;
		end
	end
	
	if isUI then
		frame:EnableHideProcess(1);
		timer:EnableHideUpdate(1);
	else
		frame:ShowWindow(1);
		frame:EnableHideProcess(0);
		timer:EnableHideUpdate(0);
	end

	local fontName = frame:GetUserConfig("TitleFont");
	local title = GET_CHILD_RECURSIVELY(frame,'title')
	title:SetText(fontName .. msg .. "{/}");
	
	local timegauge = GET_CHILD_RECURSIVELY(frame, "timegauge", "ui::CGauge");
	timegauge:SetPoint(0, second);
	timegauge:SetPointWithTime(second, second);

	timer:SetUpdateScript("UPDATE_TIME_ACTION");
	timer:Start(0.01, 0);
	frame:SetValue(second);

	local animpic = GET_CHILD_RECURSIVELY(frame, "animpic");
	LINK_OBJ_TO_GAUGE(frame, animpic, timegauge, 0);
	
end

function CANCEL_TIME_ACTION(frame)
	packet.StopTimeAction();
	END_TIME_ACTION(frame, 1)
		
end

function END_TIME_ACTION(frame, isFail)
	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	frame:ShowWindow(0);
	timer:Stop();
	timer:EnableHideUpdate(0);
	frame:EnableHideProcess(0);
		
end

function STOP_TIEM_ACTINO(frame)
	packet.StopTimeAction();
	END_TIME_ACTION(frame, 1);
end

function UPDATE_TIME_ACTION(frame, timer, str, num, totalTime)
	if 1 == control.IsMoving() then
		STOP_TIEM_ACTINO(frame);
		return;
	end
	
end

function TIMEACTION_TXT(curPoint, maxPoint)
	if maxPoint <= 60 then
		return string.format("%.1f / %.1f", curPoint , maxPoint);
	end
	local ret = GET_TIME_TXT(curPoint) .. " / " .. GET_TIME_TXT(maxPoint);
	return ret;
end





