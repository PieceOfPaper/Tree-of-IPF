

function RAIDASSEMBLE_READY_ON_INIT(addon, frame)
	addon:RegisterMsg("RAID_STATE", "ON_RAID_STATE");

end

function ON_RAID_STATE(frame, msg, mGameName, num)
	if mGameName == "None" then
		frame:ShowWindow(0);
		return;
	end

	frame:SetUserValue("MGAMENAME", mGameName);
	frame:ShowWindow(1);

	local startAnim = GET_CHILD(frame, 'start_anim', 'ui::CAnimPicture');
	startAnim:PlayAnimation();
end

function RAID_EX_CANCEL(frame)
	frame = frame:GetTopParentFrame();

	frame = frame:GetTopParentFrame();
	RA_HIDE(frame);

	local mGameName = frame:GetUserValue("MGAMENAME");
	geMGame.ReqMGameCmd(mGameName, 3);

end


