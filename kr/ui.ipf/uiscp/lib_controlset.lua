---- lib_controlset.lua

function RUNFUNC_TO_MERGED_CTRLSET(ctrlset, setName, func)

	local setInfo = ui.GetControlSetInfo(setName);	
	if setInfo == nil then
		return;
	end

	local cnt = setInfo:GetControlCount();
	for i = 0 , cnt - 1 do
		local name = setInfo:GetControl(i):GetName();
		local child = ctrlset:GetChild(name);
		func(child);
	end

end

