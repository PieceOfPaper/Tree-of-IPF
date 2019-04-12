function ATTENDANCE_TOGGLE_VAKARINE_UI() --VakarinePackege --
	local vakarineCls = GetClass('TPEventAttendance', 'SteamNewRank');
	local frame = ui.GetFrame('attendance');
	if frame ~= nil and frame:IsVisible() == 1 then
		ui.CloseFrame('attendance');
		return;
	end
	ON_ATTENDANCE_RESULT(frame, '', '', vakarineCls.ClassID);
end