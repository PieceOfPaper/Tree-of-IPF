

function MCY_KILLER_ON_INIT(addon, frame)

	addon:RegisterMsg('MCY_KILL_PC', 'ON_MCY_KILL_PC');
		
end

function ON_MCY_KILL_PC(frame, msg, str, num)

	local cnt, kil, death = Tokenize(str);
	
	local isOurForce = 0;
	if num == GET_MY_TEAMID() then
		isOurForce = 1;
	end
		
	MCY_PUSH_KILLER(kil, death, isOurForce);

end

function MCY_PUSH_KILLER(killer, target, isOurForce)

	MCY_PUSH_RESULT();
	
	local frame = ui.GetFrame("mcy_killer");
	local gbox = GET_CHILD(frame, "record", "ui::CGroupBox");
	local k1 = gbox:GetChild("k1");
	local t1 = gbox:GetChild("t1");
	
	local font_kill = frame:GetUserConfig("Font_Dead");
	local font_dead = frame:GetUserConfig("Font_Kill");
	if isOurForce == 1 then
		k1:SetText(font_dead .. killer);
		t1:SetText(font_kill .. target);		
	else
		k1:SetText(font_kill  .. target);
		t1:SetText(font_dead.. killer);		
	end

	frame:SetDuration(5);
	frame:ShowWindow(1);
	frame:Invalidate();

end

function MCY_PUSH_RESULT()

	local MAX_SHOW_KILLER = 5;
	local frame = ui.GetFrame("mcy_killer");
	
	local gbox = GET_CHILD(frame, "record", "ui::CGroupBox");
	
	for i = 0, MAX_SHOW_KILLER - 2 do
		local idx1 = MAX_SHOW_KILLER - i;
		local idx2 = MAX_SHOW_KILLER - i - 1;

		local ctrl1 = gbox:GetChild("k" .. idx2);
		local ctrl2 = gbox:GetChild("k" .. idx1);
		ctrl2:SetText(ctrl1:GetText());	
		
		ctrl1 = gbox:GetChild("t" .. idx2);
		ctrl2 = gbox:GetChild("t" .. idx1);
		ctrl2:SetText(ctrl1:GetText());	
	end

end


