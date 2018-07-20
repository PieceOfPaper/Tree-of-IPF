function DIALOGBALLOON_ON_INIT(addon, frame)
end

function BALLOON_TEXT(clsName, duration)

	local frame = ui.GetFrame("dialogballoon");
	local cls = GetClass("DialogText", clsName);
	local text = frame:GetChild("text");
	if cls == nil then
	    text:SetTextByKey("value", clsName);
	else
    	text:SetTextByKey("value", cls.Text);
    end
	frame:ShowWindow(1);

	frame:Resize(text:GetWidth() + 100, text:GetHeight() + 60);
	frame:SetDuration(duration);


end

