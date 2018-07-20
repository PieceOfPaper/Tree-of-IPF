function DIALOGBALLOON_ON_INIT(addon, frame)
end

function BALLOON_TEXT(clsName, duration)

	local frame = ui.GetFrame("dialogballoon");
	frame = AUTO_CAST(frame)
	frame:Resize(frame:GetUserConfig("WIDTH_DEFAULT"), frame:GetUserConfig("HEIGHT_DEFAULT"))
	local cls = GetClass("DialogText", clsName);
	local text = frame:GetChild("text");
	if cls == nil then
	    text:SetTextByKey("value", clsName);
	else
    	text:SetTextByKey("value", cls.Text);
    end

	local showBalloonSkin = cls.ShowBalloonSkin
	if showBalloonSkin ~= nil and showBalloonSkin ~= "None" then
		frame:SetSkinName(showBalloonSkin)
	end

	frame:ShowWindow(1);

	local resizeWidth = text:GetWidth() + 100
	local resizeHeight = text:GetHeight() + 60

	if resizeWidth > frame:GetWidth() then
		frame:Resize(resizeWidth, frame:GetHeight())
	end

	if resizeHeight > frame:GetHeight() then
		frame:Resize(frame:GetWidth(), resizeHeight)
	end

	frame:SetDuration(duration);

end

