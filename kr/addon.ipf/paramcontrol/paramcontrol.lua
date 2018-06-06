
function PARAMCONTROL_ON_INIT(addon, frame)

end



function OPEN_PARAMCONTROL()
    local frame = ui.GetFrame('paramcontrol');
	if session.IsGM() ~= 1 then
		frame:ShowWindow(0);
		return;
	end

	frame:ShowWindow(1);
	local cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local ctrl = frame:GetChildByIndex(i);
		local name = ctrl:GetName();
		local uiType = ctrl:GetClassName();
		if uiType == "slidebar" then
			local constName = name;
			local sl = tolua.cast(ctrl, "ui::CSlideBar");
			sl:SetMinSlideLevel(0);

			local text = frame:GetChild(constName .. "_text");
			local cls = GetClass("SharedConst", name);
			if name ~= "TOKEN_MARKET_REG_LIMIT_PRICE" and name ~= "TOKEN_MARKET_REG_MAX_PRICE" then
				sl:SetMaxSlideLevel(1000);
			else
				sl:SetMaxSlideLevel(99999999);
			end
			text:SetTextByKey("title", cls.Desc);
		end
	end

	cnt = frame:GetChildCount();
	for i = 0, cnt - 1 do
		local ctrl = frame:GetChildByIndex(i);
		local name = ctrl:GetName();
		local uiType = ctrl:GetClassName();
		if uiType == "edit" then
			local constName = string.sub(name, 1, string.len(name) - 5);
			local cls = GetClass("SharedConst",constName);
			local val = cls.Value;
			local valStr = string.format("%.2f", val);
			ctrl:SetText(valStr);
		elseif uiType == "slidebar" then
			local constName = name;
			local cls = GetClass("SharedConst",constName);
			local slideValue = cls.Value * 100;
			local sl = tolua.cast(ctrl, "ui::CSlideBar");
			sl:SetLevel(slideValue);
		end
	end

end

function REQ_SERVER_UPDATE_PARAM_CTRL(frame, clsName)
	
	if session.IsGM() ~= 1 then
		return;
	end

	local text = frame:GetChild(clsName .. "_edit");
	local val = tonumber(text:GetText());
	local valStr = string.format("%.2f", val);
	local cls = GetClass("SharedConst", clsName);
	iesman.ChangeIESProp("SharedConst", cls.ClassID, cls.ClassName, "Value", valStr, "Change By Tool", 1);
end

function PARAM_CONTROL_EDIT(frame, ctrl, str, num)
	local ed = tolua.cast(ctrl, "ui::CEditControl");
	local name = ctrl:GetName();
	local constName = string.sub(name, 1, string.len(name) - 5);
	local sl = GET_CHILD(frame, constName, "ui::CSlideBar");
	local val = tonumber(ed:GetText());
	sl:SetLevel(val * 100);
	REQ_SERVER_UPDATE_PARAM_CTRL(frame, constName);
end

function PARAM_CONTROL_SLIDE_RESET(frame, ctrl, str, num)
	local sl = tolua.cast(ctrl, "ui::CSlideBar");
	local clsName = sl:GetName();
	local edit = frame:GetChild(clsName .. "_edit");
	edit:SetText("1.00");
	sl:SetLevel(100);
	REQ_SERVER_UPDATE_PARAM_CTRL(frame, sl:GetName());
end

function PARAM_CONTROL_SLIDE(frame, ctrl, str, num)
	local sl = tolua.cast(ctrl, "ui::CSlideBar");
	local val = sl:GetLevel();
	local text = frame:GetChild(ctrl:GetName() .. "_edit");
	local str = string.format("%.2f", val * 0.01);
	text:SetText(str);
end

function PARAM_CONTROL_SILVER_RESET(frame, ctrl, str, num)
	local sl = tolua.cast(ctrl, "ui::CSlideBar");
	local clsName = sl:GetName();
	local edit = frame:GetChild(clsName .. "_edit");
	edit:SetText("28000");
	sl:SetLevel(99999999);
	REQ_SERVER_UPDATE_PARAM_CTRL(frame, sl:GetName());
end

function PARAM_CONTROL_SILVER_SLIDE(frame, ctrl, str, num)
	local sl = tolua.cast(ctrl, "ui::CSlideBar");
	local val = sl:GetLevel();
	local text = frame:GetChild(ctrl:GetName() .. "_edit");
	local str = string.format("%d", val);
	text:SetText(str);
end

function PARAM_SLIDE_END(frame, ctrl, str, num)
	local sl = tolua.cast(ctrl, "ui::CSlideBar");
	REQ_SERVER_UPDATE_PARAM_CTRL(frame, sl:GetName());
end


