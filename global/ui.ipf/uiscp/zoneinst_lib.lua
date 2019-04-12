---- zoneinst_lib.lua --

function GET_CHANNEL_STRING(zoneInst, isShowPCCount)
	if zoneInst == nil then 
		return
	end

	local maxCount = session.serverState.GetMaxPCCount();
	local fontStr = "{@st42b}";
	local fullColor = "{#FF0000}";
	local normalColor = "{#FFCC33}";
	local emptyColor = "{#FFFFFF}";

	local ret = string.format("%s %d", ClMsg("Channel"), zoneInst.channel + 1);
	
	if isShowPCCount == true and zoneInst.pcCount >= 0 then
		ret = ret..string.format(" (%d/%d)", zoneInst.pcCount, maxCount)
	end
	
	local stateString = "";
	if zoneInst.pcCount == - 1 then
		stateString = ClMsg("Closed");
	else
		local drawCount = 5;
		local divided = math.floor(zoneInst.pcCount * drawCount / maxCount) + 1;
		for i = 1, drawCount do
			if i <= divided then
				stateString = "{img channel_mark_full 14 20 C}" .. stateString
			else
				stateString = "{img channel_mark_empty 14 20 C}" .. stateString;
			end
		end

		if divided >= 4 then
			fontStr = fontStr .. fullColor;
		elseif divided >= 2 then
			fontStr = fontStr .. normalColor;
		else
			fontStr = fontStr .. emptyColor;
		end
	end

	ret = fontStr .. ret;
	stateString = fontStr .. stateString;
	
	return ret, stateString;

end