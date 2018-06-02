-- buff_tooltip.lua

function UPDATE_BUFF_TOOLTIP(frame, handle, numarg1, numarg2)

	local buff 					= info.GetBuff(handle, numarg1);
	local buffOver;
	local buffTime;
	if buff ~= nil then
		buffOver = buff.over;
		buffTime = buff.time;
	else
		buffOver = 0;
		buffTime = 0.0;
	end

	local cls = GetClassByType('Buff', numarg1);
	local name = frame:GetChild("name");
	local nametxt = cls.Name;
	if buffOver > 1 then
		nametxt = nametxt .. " X " .. buffOver;
	end

	name:SetText("{@st41}"..nametxt);

	local comment = frame:GetChild("comment");

	local tooltipfunc = _G["BUFF_TOOLTIP_" .. cls.ClassName];
	local tooltip = "";
	if tooltipfunc == nil then
		tooltip = cls.ToolTip;
	else
		tooltip = tooltipfunc(buff, cls);
	end

	if buffTime == 0.0 then
		comment:SetText("{@st59}"..tooltip);
	else
		local txt = tooltip
		..
		"{nl}"
		.. ScpArgMsg("Auto_NameunSiKan_:_") .. GET_BUFF_TIME_TXT(buffTime, 1);

		comment:SetText("{@st59}"..txt);
	end

end

function BUFF_TOOLTIP_Rejuvenation(buff, cls)

	local heal = 5
	return string.format(ScpArgMsg("Auto_HPwa_SPLeul_HoeBogSiKipNiDa."), heal);

end

function BUFF_TOOLTIP_OgouVeve(buff, cls)

	return ScpArgMsg("Auto_HimKwa_JiNeungeul_olLyeoJupNiDa.");

end


