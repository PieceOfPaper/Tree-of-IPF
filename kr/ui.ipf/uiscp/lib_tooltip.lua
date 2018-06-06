-- lib_tooltip.lua --

function MAKE_BALLOON_FRAME(text, x, y, linkText, customName, font, isFixWidth)

	local tframe = ui.CreateNewFrame("balloon", customName);
	if tframe == nil then
		return nil;
	end

	local setText;
	if linkText ~= nil then
		setText = "{ul}{a " .. linkText .. "}".. text .. "{/}{/}";
	else
		setText = text;
	end
		
	local textCtrl = GET_CHILD(tframe, "text", "ui::CRichText");
	if isFixWidth == 1 then
		textCtrl:SetTextFixWidth(1);
	else
		textCtrl:SetTextFixWidth(0);
	end

	if font ~= nil then
		textCtrl:SetTextByKey("Font", font);
	end
	textCtrl:SetTextByKey("Text", setText);
	
	local width = textCtrl:GetWidth() + 40;
	local height = textCtrl:GetHeight() + 20;
	tframe:Resize(width, height);
	tframe:MoveFrame(x - width, y - height);
	tframe:EnableCloseButton(0);
	tframe:ShowWindow(1);
	return tframe;

end

function MAKE_BALLOON_FRAME_IMAGE(imageName, text, font, frameName)

	local tframe = ui.CreateNewFrame("balloon", frameName);
	if tframe == nil then
		return nil;
	end
	
	local textCtrl = tframe:GetChild("text");
	if font ~= nil then
		textCtrl:SetTextByKey("Font", font);
	end
	textCtrl:SetTextByKey("Text", text);

	local pictureui = tframe:GetChild("textImage");
	local imgCtrl = tolua.cast(pictureui, 'ui::CPicture');
	imgCtrl:SetImage(imageName);	

	local width = imgCtrl:GetWidth();
	local height = imgCtrl:GetHeight();
	tframe:Resize(width, height);	
	tframe:EnableCloseButton(0);
	tframe:SetSkinName('slot_empty');
	return tframe;

end

function BALLOON_FRAME_SET_TEXT(tframe, text)
	local textCtrl = tframe:GetChild("text");
	textCtrl:SetTextByKey("Text", text);
	local width = textCtrl:GetWidth() + 40;
	local height = textCtrl:GetHeight() + 20;
	tframe:Resize(width, height);
end

function GET_STAR_TXT(imgSize, count, obj)
    local transcend = 0;
    
    if obj ~= nil and obj.ItemType == "Equip" then
        transcend = TryGetProp(obj, "Transcend");
    end
	
	local gradeString = "";
	for i = 1 , count do
	    if obj ~= nil and transcend > 0 then
	        gradeString = gradeString .. string.format("{img star_mark3 %d %d}", imgSize, imgSize);
		else
		gradeString = gradeString .. string.format("{img star_mark %d %d}", imgSize, imgSize);
	end
	end

	return gradeString;
end

function GET_STAR_TXT_REDUCED(imgSize, count, removeCount)
    local transcend = 0;        
	local gradeString = "";
	for i = 1 , count - removeCount do
    	gradeString = gradeString .. string.format("{img star_mark %d %d}", imgSize, imgSize);
	end	
	for i = 1 , removeCount do
	   gradeString = gradeString .. string.format("{img star_mark2 %d %d}", imgSize, imgSize);
	end

	return gradeString;
end

function GET_ITEM_GRADE_TXT(obj, imgSize)

	return GET_ITEM_STAR_TXT(obj, imgSize)

	--[[ 이제 별과 그레이드는 관계 없어졌다. 스펙 확정되면 이 함수 날리고 GET_ITEM_STAR_TXT만 쓰면 됨
	local grade = obj.ItemGrade;	
	if grade == nil or grade == 'None' then
		grade = 1;
	end

	return GET_STAR_TXT(imgSize, grade);
	]]
end


function GET_ITEM_STAR_TXT(obj, imgSize)

	local starcount = 1;	

	if obj.ItemType ~= "Equip" and obj.GroupName ~="Gem" and obj.GroupName ~='Card'  then
		return ""
	end

	local star = nil

	if obj.GroupName == "Gem" or  obj.GroupName == "Card"  then
		local lv = GET_ITEM_LEVEL_EXP(obj);
		star = lv
	else
		star = obj.ItemStar;
	end
	
	return GET_STAR_TXT(imgSize, star, obj);
end

function SET_MOUSE_FOLLOW_BALLOON(msg, autoPos, x, y)
	local frameName = "mousefollow";
	if msg == nil then
		ui.CloseFrame(frameName);
		return;
	end
	
	local frame = MAKE_BALLOON_FRAME(msg, 0, 0, nil, frameName, "{#050505}{s20}{b}");
	frame:EnableHitTest(0);
	if autoPos == 1 then
		SET_FRAME_AUTO_MOUSEPOS(frame, -frame:GetWidth() -50, 0);
	else
		frame:StopUpdateScript("FOLLOW_MOUSE_POS");
		frame:MoveFrame(x, y);
	end
end

function SET_FRAME_AUTO_MOUSEPOS(frame, xOffset, yOffset)
	frame:SetUserValue("AUTOPOS_X", xOffset);
	frame:SetUserValue("AUTOPOS_Y", yOffset);
	frame:RunUpdateScript("FOLLOW_MOUSE_POS", 0, 0, 0, 1);
	FOLLOW_MOUSE_POS(frame);
end

function FOLLOW_MOUSE_POS(frame)
	frame = tolua.cast(frame, "ui::CFrame");
	local x, y = GET_MOUSE_POS();
	
	local xOffset = frame:GetUserIValue("AUTOPOS_X");
	local yOffset = frame:GetUserIValue("AUTOPOS_Y");
	x = x + xOffset;
	y = y + yOffset;
	frame:MoveIntoClientRegion(x, y);
	return 1;
end

function MOVE_FRAME_TO_MOUSE_POS(frame, xOffset, yOffset)
	frame = tolua.cast(frame, "ui::CFrame");
	local x, y = GET_MOUSE_POS();
	x = x - frame:GetWidth() - 50;
	if xOffset ~= nil then
		x = x + xOffset;
	end

	if yOffset ~= nil then
		y = y + yOffset;
	end

	frame:MoveIntoClientRegion(x, y);
	return 1;
end

