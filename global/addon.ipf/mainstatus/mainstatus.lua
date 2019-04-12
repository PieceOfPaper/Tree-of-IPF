

function MAINSTATUS_ON_INIT(addon, frame)
end

function MAIN_STATUS_SET_PROP(frame, pc, propName, addProp, multiPly, tailTxt)
	
	local txt = GET_CHILD(frame, propName .. "_text", "ui::CRichText");
	if txt == nil then
		return;
	end
	
	local cur = pc[propName];
	local add = pc[addProp];
	if multiPly ~= nil then
		cur = cur * multiPly;
		add = add * multiPly;
	end
	local setTxt = "";
	
	if add == 0 then
		local sfont = frame:GetUserConfig("Font_Normal");
		setTxt = string.format("%s%d", sfont, cur);
	else
		local sfont = frame:GetUserConfig("Font_Add");
		setTxt = string.format("%s%d (%d+%d)", sfont, cur, cur - add, add);
	end
	
	if tailTxt ~= nil then
		setTxt = setTxt .. tailTxt;
	end
	
	txt:SetText(setTxt);

end

function MAIN_STATUS_SET_PROP_RANGE(frame, pc, minProp, maxProp, addProp)
	local txt = GET_CHILD(frame, minProp .. "_text", "ui::CRichText");
	if txt == nil then
		return;
	end
	
	local curMin = pc[minProp];
	local curMax = pc[maxProp];
	local add = pc[addProp];
	if multiPly ~= nil then
		cur = cur * multiPly;
		add = add * multiPly;
	end
	local setTxt = "";
	
	if add == 0 then
		local sfont = frame:GetUserConfig("Font_Normal");
		setTxt = string.format("%s%d~%d", sfont, curMin, curMax);
	else
		local sfont = frame:GetUserConfig("Font_Add");
		setTxt = string.format("%s%d~%d+%d", sfont, curMin, curMax, add);
	end
	
	if tailTxt ~= nil then
		setTxt = setTxt .. tailTxt;
	end
	
	txt:SetText(setTxt);	
end

