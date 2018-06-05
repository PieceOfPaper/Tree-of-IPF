function SOCIALBALLOON_ON_INIT(addon, frame)		
end


function SCR_SOCIAL_MODE_SIMPLE(frame, socialMode, handle)
	frame:SetSkinName("textballoon_mid");
	frame:Resize(200, 57);
	HIDE_CHILD_BYNAME(frame, "Gbox");
	if socialMode == "MyPage" then
		SOCIAL_MYPAGE_MODE_SIMPLE(frame, handle);
	elseif socialMode == "Buy" then
		SOCIAL_ITEMBUY_MODE_SIMPLE(frame, handle);
	end	
end

function SCR_SOCIAL_MODE_DETAIL(frame, socialMode, handle)	
	HIDE_CHILD_BYNAME(frame, "Gbox");
	if socialMode == "MyPage" then
		SOCIAL_MYPAGE_MODE_DETAIL(frame, handle);
	elseif socialMode == "Buy" then
		SOCIAL_ITEMBUY_MODE_DETAIL(frame, handle);
	end
end