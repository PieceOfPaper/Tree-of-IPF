function DIALOGBALLOON_ON_INIT(addon, frame)
end

function BALLOON_TEXT(clsName, duration)

	local frame = ui.GetFrame("dialogballoon");
	frame = AUTO_CAST(frame)
	frame:Resize(frame:GetUserConfig("WIDTH_DEFAULT"), frame:GetUserConfig("HEIGHT_DEFAULT"))
	frame:SetLayerLevel(30);
	local cls = GetClass("DialogText", clsName);
	local text = frame:GetChild("text");
	if cls == nil then
	    text:SetTextByKey("value", clsName);
	else
		text:SetTextByKey("value", cls.Text);
	end

	local imgObject = GET_CHILD(frame, "image");
	local gb = GET_CHILD(frame, "gb");

	local resizeWidth = text:GetWidth() + frame:GetUserConfig("RESIZE_WIDTH_S");
	local resizeHeight = text:GetHeight() + frame:GetUserConfig("RESIZE_HEIGHT_S");
	local showBalloonSkin = cls.ShowBalloonSkin
	if showBalloonSkin ~= nil and showBalloonSkin ~= "None" then
		frame:SetSkinName(showBalloonSkin);
		gb:SetSkinName(showBalloonSkin);

		if resizeWidth > frame:GetWidth() then
			frame:Resize(resizeWidth, frame:GetHeight());
		end

		if resizeHeight > frame:GetHeight() then
			frame:Resize(frame:GetWidth(), resizeHeight);
		end
		gb:Resize(frame:GetWidth(), frame:GetHeight());
	else
		frame:Resize(resizeWidth, resizeHeight);
		frame:SetSkinName("shadow_box");
		
		gb:SetSkinName("shadow_box");
		gb:Resize(resizeWidth + frame:GetUserConfig("RESIZE_WIDTH_S"), resizeHeight);
	end
	
	local imgname = TryGetProp(cls, "ImgName", "None")
	if imgname == "None" or imgname == "blank" then
		-- 텍스트만 출력
		imgObject:ShowWindow(0);
		gb:ShowWindow(0);
	else
		-- 이미지와 텍스트 출력
		frame:SetSkinName("None");
		imgObject:ShowWindow(1);
		gb:ShowWindow(1);

		if cls ~= nil and imgname ~= 'None' then			
			imgObject:SetImage(imgname);	
		else
			imgObject:SetImage("");
		end
		imgObject:SetGravity(ui.LEFT, ui.CENTER_VERT);
		if showBalloonSkin ~= nil and showBalloonSkin ~= "None" then
			frame:Resize(frame:GetWidth() + frame:GetUserConfig("RESIZE_WIDTH_S"), frame:GetHeight() + imgObject:GetHeight());
		else
			frame:Resize(frame:GetWidth() + frame:GetUserConfig("RESIZE_WIDTH_M"),  frame:GetHeight() + imgObject:GetHeight());
		end

		-- 이미지 위치 조정 : 텍스트 그룹 박스와 끝나는 Y값이 같도록
		local gb_Y = gb:GetY() + gb:GetHeight();
		local pic_Y = imgObject:GetY() + imgObject:GetHeight();
		local Offset_Y = pic_Y - gb_Y;
		
		local rect = imgObject:GetMargin();
		imgObject:SetMargin(rect.left, rect.top - Offset_Y, rect.right, rect.bottom);		
	end

	frame:ShowWindow(1);	
	frame:SetDuration(duration);

end

