-- fade.lua

function FRAME_SET_FADE_IN(parent, obj, argStr, argNum)

	local frame = tolua.cast(obj, "ui::CFrame");
	local fade = frame:GetFadeInManager();

	-- 프레임에 설정한 argStr 과 argNum 를 이용하여 유형별 페이드인 을 설정합니다.
	-- 필요한 데이터는 문자열에 포함시켜 파싱하여 사용하도록 한다.

	argStr = string.lower(argStr);
	if argStr == "mainmenu" then
		fade:Enable(true);
		fade:SetPivot(0.5, 0.5);
		fade:SetBasePosition(200 + 50 * argNum, 600);

		fade:SetBlend(0.4);
		fade:SetScaleX(0.2, 0.5);
		fade:SetScaleY(0.2, 0.5);
		fade:SetMove(0.3);
	elseif argStr == "rotate" then
		fade:Enable(true);		-- 페이드 인 사용 여부
		fade:SetClipScale(true);	-- 스케일 할때 이미지가 클립 되는지 축소/확대 되는지 여부

		fade:SetPivot(0.5, 0.5);	-- 회전과 스케일에 대한 프레인 내부의 피벗 (x = 0~1.0 , y = 0~1.0)
		fade:SetBasePosition(350, 300); -- (이동의) 시작 지점

		fade:SetBlend(0.8);		-- float형 초단위 블렌딩이 완성되는 시간 (초)
		fade:SetScaleX(0, 1);		-- 스케일 x 시작 비율 (0 ~ 1.0) , 완성되는 시간 (초)
		fade:SetScaleY(0, 1);		-- 스케일 y 시작 비율 (0 ~ 1.0) , 완성되는 시간  (초)
		fade:SetRotation(0.5, 2, 1);	-- 회전 시작 각도 (0 ~ 1.0) , 회전수 (0~), 완성되는 시간 (초)
		fade:SetMove(1);		-- 시작점에서 원래 위치까지 이동 완성되는 시간 (초)
	elseif argStr == "musictitle" then
		local x = frame:GetX();
		local y = frame:GetY();

		fade:Enable(true);
		fade:SetPivot(0.5, 0.5);
		fade:SetBasePosition(x + 20, y);

		fade:SetBlend(0.5);
		fade:SetScaleX(2.0, 0.2);
		fade:SetScaleY(0.2, 0.2);
		fade:SetMove(2);
	elseif argStr == "selectcharinfo" then
		local x = frame:GetX();
		local y = frame:GetY();

		fade:Enable(true);
		fade:SetPivot(0.5, 0.5);
		fade:SetBasePosition(x + 20, y);

		fade:SetBlend(0.5);
		fade:SetScaleX(2.0, 0.2);
		fade:SetScaleY(0.2, 0.2);
		fade:SetMove(2);
	elseif argStr == "areaname1" then
		fade:Enable(true);
		fade:SetClipScale(true);
		fade:SetPivot(0.5, 0.5);
		fade:SetBasePosition(2000, 1000);

		fade:SetBlend(10);
		fade:SetScaleX(0.0, 10);
		fade:SetMove(10);
    elseif argStr == "pickitem" then
		fade:Enable(true);		-- 페이드 인 사용 여부
		fade:SetPivot(0.5, 0.5);	-- 회전과 스케일에 대한 프레인 내부의 피벗 (x = 0~1.0 , y = 0~1.0)
		fade:SetBasePosition(frame:GetX(), frame:GetY()-50); -- (이동의) 시작 지점
		fade:SetScaleX(1, 1);		-- 스케일 x 시작 비율 (0 ~ 1.0) , 완성되는 시간 (초)
		fade:SetScaleY(1, 1);		-- 스케일 y 시작 비율 (0 ~ 1.0) , 완성되는 시간  (초)
		fade:SetMove(1);		-- 시작점에서 원래 위치까지 이동 완성되는 시간 (초)
		fade:SetBlend(0.3);
    elseif argStr == "dialog" then
		fade:Enable(true);
		fade:SetClipScale(true);
		fade:SetPivot(0.5, 0);
		fade:SetBasePosition(50, 105);

		fade:SetBlend(0.3);
		fade:SetScaleY(0.0, 0.3);
		fade:SetMove(0.2);
	elseif argStr == "loadingbg" then
		fade:Enable(true);
		fade:SetPivot(0, 0);
		fade:SetBlend(5.0);
	elseif argStr == "dialog_npc" then
		fade:Enable(true);
		fade:SetPivot(0, 0);
		fade:SetBlend(0.3);
	elseif argStr == "moncharinfo" then
		fade:Enable(true);
	elseif argStr == "mapname" then
		fade:Enable(true);
		fade:SetPivot(0.5, 0.5);
		fade:SetBlend(1);
		fade:SetBasePosition(frame:GetX() - 10, frame:GetY());
		fade:SetMove(1);
	elseif argStr == "textballoon" then
		fade:Enable(true);
		fade:SetPivot(0.5, 0.5);
		fade:SetScaleX(0.5, 0.1);
		fade:SetScaleY(0.5, 0.1);
		fade:SetBlend(0.5);
    elseif argStr == "none" then
		fade:Enable(false);
    else
		fade:Enable(true);
		fade:SetPivot(0.5, 0.5);

		fade:SetBlend(0.3);
		fade:SetScaleX(1.0, 0.3);
		fade:SetScaleY(1.0, 0.3);
	end
 end

function FRAME_SET_FADE_OUT(parent, obj, argStr, argNum)

	local frame = tolua.cast(obj, "ui::CFrame");
	local fade = frame:GetFadeOutManager();

	argStr = string.lower(argStr);
	if argStr == "mainmenu" then
		fade:Enable(true);
		fade:SetPivot(0.5, 0.5);
		fade:SetBasePosition(200 + 50 * argNum, 600);

		fade:SetBlend(0.4);
		fade:SetScaleX(0.2, 0.5);
		fade:SetScaleY(0.2, 0.5);
		fade:SetMove(0.3);
	  elseif argStr == "rotate" then
		fade:Enable(true);		-- 페이드 인 사용 여부
		fade:SetClipScale(true);	-- 스케일 할때 이미지가 클립 되는지 축소/확대 되는지 여부

		fade:SetPivot(0.5, 0.5);	-- 회전과 스케일에 대한 프레인 내부의 피벗 (x = 0~1.0 , y = 0~1.0)
		fade:SetBasePosition(350, 300); -- (이동의) 시작 지점

		fade:SetBlend(0.8);		-- float형 초단위 블렌딩이 완성되는 시간 (초)
		fade:SetScaleX(0, 1);		-- 스케일 x 시작 비율 (0 ~ 1.0) , 완성되는 시간 (초)
		fade:SetScaleY(0, 1);		-- 스케일 y 시작 비율 (0 ~ 1.0) , 완성되는 시간  (초)
		fade:SetRotation(0.5, 2, 1);	-- 회전 시작 각도 (0 ~ 1.0) , 회전수 (0~), 완성되는 시간 (초)
		fade:SetMove(1);		-- 시작점에서 원래 위치까지 이동 완성되는 시간 (초)
	  elseif argStr == "musictitle" then
		local x = frame:GetX();
		local y = frame:GetY();

		fade:Enable(true);
		fade:SetPivot(0.5, 0.5);

		fade:SetBlend(0.3);
		fade:SetScaleX(2.0, 0.2);
		fade:SetScaleY(0.2, 0.2);
	  elseif argStr == "selectcharinfo" then
		fade:Enable(true);
		fade:SetClipScale(true);
		fade:SetPivot(0.5, 0.5);

		fade:SetBlend(0.3);
		fade:SetScaleY(0.0, 0.3);
	  elseif argStr == "loadingbg" then
		fade:Enable(true);
	  elseif argStr == "pickitem" then
		local systemFrame = ui.GetFrame("sysmenu");
		local inven		  = systemFrame:GetChild('inven');
		local invenObj    = tolua.cast(inven, "ui::CObject");

		fade:Enable(true);		-- 페이드 인 사용 여부
		--fade:SetPivot(0.5, 0.5);	-- 회전과 스케일에 대한 프레인 내부의 피벗 (x = 0~1.0 , y = 0~1.0)
		fade:SetBasePosition(invenObj:GetGlobalX(), invenObj:GetGlobalY()); -- (이동의) 시작 지점
		fade:SetScaleX(0, 1);		-- 스케일 x 시작 비율 (0 ~ 1.0) , 완성되는 시간 (초)
		fade:SetScaleY(0, 1);		-- 스케일 y 시작 비율 (0 ~ 1.0) , 완성되는 시간  (초)
		fade:SetMove(1);		-- 시작점에서 원래 위치까지 이동 완성되는 시간 (초)
		fade:SetBlend(0.1);
	elseif argStr == "moncharinfo" then
		fade:Enable(true);
		--fade:SetPivot(0.5, 0.5);

		--fade:SetBlend(0.3);
		--fade:SetScaleX(1.2, 0.2);
		--fade:SetScaleY(1.2, 0.2);
	elseif argStr == "dialog_npc" then
		fade:Enable(true);
		fade:SetPivot(0, 0);
		fade:SetBlend(0.3);
	elseif argStr == "mapname" then
		fade:Enable(true);
		fade:SetPivot(0.5, 0.5);
		fade:SetBlend(1);
		fade:SetBasePosition(frame:GetGlobalX() + 10, frame:GetGlobalY());
		fade:SetMove(1);
	elseif argStr == "textballoon" then
		fade:Enable(true);
		fade:SetPivot(0.5, 0.5);
		fade:SetScaleX(0.5, 0.1);
		fade:SetScaleY(0.5, 0.1);
		fade:SetBlend(0.5);
	elseif argStr == "none" then
		fade:Enable(false);
	 else
		fade:Enable(true);
		fade:SetPivot(0.5, 0.5);

		fade:SetBlend(0.3);
		fade:SetScaleX(1.0, 0.4);
		fade:SetScaleY(1.0, 0.4);
	 end
 end

 function CONTROL_FADE_IN(parent, obj, argStr, argNum)
	local frame = tolua.cast(obj, "ui::CObject");
	local fade = frame:GetFadeInManager();

	-- 프레임에 설정한 argStr 과 argNum 를 이용하여 유형별 페이드인 을 설정합니다.
	-- 필요한 데이터는 문자열에 포함시켜 파싱하여 사용하도록 한다.

	argStr = string.lower(argStr);
	if argStr == "loading_gauge" then
		fade:Enable(true);
		--fade:SetBlend(5.0);
		fade:SetBasePosition(frame:GetX(), frame:GetY()+200); -- (이동의) 시작 지점
		fade:SetMove(1);		-- 시작점에서 원래 위치까지 이동 완성되는 시간 (초)
	 elseif argStr == "none" then
		fade:Enable(false);
	else
		fade:Enable(true);
		--fade:SetBlend(5.0);
		fade:SetBasePosition(frame:GetX(), frame:GetY()+200); -- (이동의) 시작 지점
		fade:SetMove(3);		-- 시작점에서 원래 위치까지 이동 완성되는 시간 (초)
	end
end

 function CONTROL_FADE_OUT(parent, obj, argStr, argNum)
	local frame = tolua.cast(obj, "ui::CObject");
	local fade = frame:GetFadeOutManager();

	-- 프레임에 설정한 argStr 과 argNum 를 이용하여 유형별 페이드인 을 설정합니다.
	-- 필요한 데이터는 문자열에 포함시켜 파싱하여 사용하도록 한다.

	argStr = string.lower(argStr);
	if argStr == "loading_gauge" then
		fade:Enable(true);
		--fade:SetBlend(5.0);
		fade:SetBasePosition(frame:GetX(), frame:GetY()+300); -- (이동의) 시작 지점
		fade:SetMove(1);		-- 시작점에서 원래 위치까지 이동 완성되는 시간 (초)
	elseif argStr == "loading_image" then
		fade:Enable(true);
		fade:SetBlend(5.0);
	elseif argStr == "none" then
		fade:Enable(false);
	else
		fade:Enable(true);
		--fade:SetBlend(5.0);
		fade:SetBasePosition(frame:GetX(), frame:GetY()+300); -- (이동의) 시작 지점
		fade:SetMove(4);		-- 시작점에서 원래 위치까지 이동 완성되는 시간 (초)
	end
end
