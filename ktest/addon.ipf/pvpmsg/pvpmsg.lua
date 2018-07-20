

function MCY_KILLMSG_ON_INIT(addon, frame)

	addon:RegisterMsg('MCY_MY_KILL', 'ON_MCY_MY_KILL');
			
end

function ON_MCY_MY_KILL(frame, msg, str, cnt)

	MCY_SHOW_KILL_MSG(str, cnt);
	--local stringScp = string.format("MCY_SHOW_KILL_MSG(\"%s\", %d)", str, cnt);
	--ReserveScript(stringScp, 2.0);

end

function MCY_SHOW_KILL_MSG(str, cnt)

	local frame = ui.GetFrame("mcy_killmsg");
	frame:GetChild("text"):SetTextByKey("text", str);
	frame:ShowWindow(1);
	frame:SetDuration(3);
	local tenDigit = math.floor(cnt / 10);
	local oneDigit = cnt % 10;
	
	local d1 = GET_CHILD(frame, "d1", "ui::CPicture");
	local d2 = GET_CHILD(frame, "d2", "ui::CPicture");
	if tenDigit > 0 then
		d1:SetImage(tostring(tenDigit));
		d1:PlayEvent("ITEM_GET");
		d1:ShowWindow(1);
	else
		d1:ShowWindow(0);
	end
	
	d2:SetImage(tostring(oneDigit));
	d2:PlayEvent("ITEM_GET");
	
	frame:Invalidate();
		

end






