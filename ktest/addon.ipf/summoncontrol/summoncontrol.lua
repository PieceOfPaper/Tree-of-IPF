

function SUMMONCONTROL_ON_INIT(addon, frame)
 

	
end 

function OPEN_SUMMONCONTROL(frame)
	
	ui.CloseFrame("quickslotnexpbar");
	
	local bg = frame:GetChild("bg");
	bg:RemoveAllChild();
	local y = 0;
	local hotKey = hotKeyTable.GetHotKeyString("NormalAttack");	
	local ctrlSet =INSERT_HOR_RINGCOMMAND(bg, "RINGCMD_0", "druid_attack_icon", hotKey, ClMsg("Attack"), 0, y, "{@st42b}");
	ctrlSet:Resize(48, 48);
	local pic = GET_CHILD_RECURSIVELY(ctrlSet,"pic")
	pic:Resize(48, 48);

	local text = GET_CHILD_RECURSIVELY(ctrlSet,"text")
	text:Resize(48, text:GetOriginalHeight());

--hotKey = hotKeyTable.GetHotKeyString("Jump");	
--ctrlSet = INSERT_HOR_RINGCOMMAND(bg, "RINGCMD_1", "druid_jump_icon", hotKey, ClMsg("Jump"), 53, y, "{@st42b}");
--ctrlSet:Resize(48, 48);
	hotKey = hotKeyTable.GetHotKeyString("LHand");
	ctrlSet = INSERT_HOR_RINGCOMMAND(bg, "RINGCMD_2", "druid_Unride_icon", "C", ClMsg("Unride"), 53, y, "{@st42b}");
	ctrlSet:Resize(48, 48);
	local pic = GET_CHILD_RECURSIVELY(ctrlSet,"pic")
	pic:Resize(48, 48);

	local text = GET_CHILD_RECURSIVELY(ctrlSet,"text")
	text:Resize(48, text:GetOriginalHeight());

	bg:Resize(ctrlSet:GetX() + ctrlSet:GetWidth(), bg:GetHeight());
	frame:RunUpdateScript("PROCESS_SUMMON_INPUT", 0);

end

function PROCESS_SUMMON_INPUT(frame)
	
	if imcinput.IsHotKeyDown("NormalAttack") == true then
		geSummonControl.UseSkill(0);
	elseif imcinput.IsHotKeyDown("Jump") == true then
		geSummonControl.Jump();
	elseif imcinput.IsHotKeyDown("LHand") == true then
		geSummonControl.Unride();
		ui.OpenFrame("quickslotnexpbar");
	end
	
	return 1;
end
