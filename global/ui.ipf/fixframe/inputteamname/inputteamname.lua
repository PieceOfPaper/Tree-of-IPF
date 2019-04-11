
function INPUTTEAMNAME_ON_INIT(addon, frame)

end

function INPUT_TEAMNAME_EXEC(parent, ctrl)

	local frame = parent:GetTopParentFrame();
	local bg = frame:GetChild("bg");
	local input = GET_CHILD(bg, "input", "ui::CEditControl");	
	local btn = bg:GetChild("btn");
	barrack.ChangeBarrackName(input:GetText());
	btn:SetEnable(0);

	frame:SetUserValue("BeforName", "");
end
