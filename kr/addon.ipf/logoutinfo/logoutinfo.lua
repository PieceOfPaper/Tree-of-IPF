
function LOGOUTINFO_ON_INIT(addon, frame)

end

function DO_REMAIN_LOGOUTPC(isWillRemain)

	local logoutinfoframe = ui.GetFrame("logoutinfo");
	local type = logoutinfoframe:GetUserValue("LOGOUT_TYPE")

	if isWillRemain == true then
		if GET_DPC_REMAIN_PC_PRICE() > GET_CASH_TOTAL_POINT_C() then
			ui.SysMsg(ScpArgMsg("NotEnoughMedal"));
			return
		end
	end

	if "tobarrack" == type then
		app.GameToBarrack(isWillRemain)
	elseif "tologin" == type then
		app.GameToLogin(isWillRemain)
	elseif "quit" == type then
		app.Quit(isWillRemain)
	end

end