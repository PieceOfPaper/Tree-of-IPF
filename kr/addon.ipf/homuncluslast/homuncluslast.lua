-- exchangAgreeBox.lua

function HOMUNCLUSLAST_ON_INIT(addon, frame)

end

function HOMUNCLUSLAST_SKL_SAVE_EXCUTE(frame, ctrl)
	local homuncls = ui.GetFrame('homunclus');
	local sklList = homuncls:GetChild('sklList');
	local sklCnt = sklList:GetChildCount();

	for i = 1, sklCnt-1 do
		local child = sklList:GetChildByIndex(i)
		local excute = GET_CHILD(child, "excute", "ui::CCheckBox");
		if excute:IsChecked() == 1 then
			local sklName = child:GetUserValue('SKLNAME');
			local scpString = string.format("/hmunclusSkl %s", sklName);
			ui.Chat(scpString);
		end
	end

	ui.CloseFrame('homuncluslast');
end