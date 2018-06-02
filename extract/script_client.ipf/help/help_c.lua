
function AddHelpByName_C(helpname)

	local helpCls = GetClass("Help", helpname);
	if helpCls ~=nil then
		AddHelpByClient(helpCls.ClassID);
		return 1
	end
	
	return 0

end