-- lib_groupbox.lua

function QUEST_GBOX_AUTO_ALIGN(frame, GroupCtrl, starty, spacey, gboxaddy) -- questinfoset_2
	local height = GroupCtrl:GetHeight()
	local needResize = true
	if height >= GroupCtrl:GetOriginalHeight() then
		needResize = false
	end

	if needResize then
		GBOX_AUTO_ALIGN(GroupCtrl, starty, spacey, gboxaddy);
		frame:Resize(frame:GetWidth(), height);
	else
		GroupCtrl:SetScrollBar(GroupCtrl:GetOriginalHeight())
		GBOX_AUTO_ALIGN(GroupCtrl, starty, spacey, gboxaddy, false, false);
	end
end

function GBOX_AUTO_ALIGN(gbox, starty, spacey, gboxaddy, alignByMargin, autoResizeGroupBox)

	local cnt = gbox:GetChildCount();
	local y = starty;
	for i = 0, cnt - 1 do
		local ctrl = gbox:GetChildByIndex(i);
		if ctrl:GetName() ~= "_SCR" then
			
			if alignByMargin == true then
				local rect = ctrl:GetMargin();
				ctrl:SetMargin(rect.left, y, rect.right, rect.bottom);
			else
				ctrl:SetOffset(ctrl:GetX(), y);
			end

			y = y + ctrl:GetHeight() + spacey;
		end
	end
	
	if autoResizeGroupBox ~= false then
		gbox:Resize(gbox:GetWidth(), y + gboxaddy);
	end
end


function GBOX_AUTO_ALIGN_HORZ(gbox, startx, spacex, gboxaddx, alignByMargin, autoResizeWidth, lineHeight, autoResizeHeight)

	if lineHeight == nil then
		lineHeight = 0;
	end

	local maxHeight = gbox:GetHeight();
	local cnt = gbox:GetChildCount();
	local x = startx;
	local lineCount = 0;
	local maxX = x;
	for i = 0, cnt - 1 do
		local ctrl = gbox:GetChildByIndex(i);
		if ctrl:GetName() ~= "_SCR" then
			
			if x + ctrl:GetWidth() > gbox:GetWidth() then
				x = startx;
				lineCount = lineCount + 1;
			end

			if alignByMargin == true then
				local rect = ctrl:GetMargin();
				ctrl:SetMargin(x, rect.top + lineCount * lineHeight, rect.right, rect.bottom);
				if autoResizeHeight == true then
					maxHeight = math.max(maxHeight, ctrl:GetY() + ctrl:GetHeight());
				end
			else
				ctrl:SetOffset(x, ctrl:GetY());
			end

			x = x + ctrl:GetHeight() + spacex;
			maxX = math.max(maxX, x);
		end
	end
	
	if autoResizeWidth ~= false or autoResizeHeight == true then
		local resizedWidth = gbox:GetWidth();
		if autoResizeWidth ~= false then
			resizedWidth = maxX;
		end

		gbox:Resize(resizedWidth, maxHeight);
	end
end

