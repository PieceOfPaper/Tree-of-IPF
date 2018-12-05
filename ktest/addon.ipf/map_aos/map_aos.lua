

function MAP_AOS_ON_INIT(addon, frame)


	--[[
	addon:RegisterMsg('MAP_CHARACTER_UPDATE', 'MAP_AOS_MYPCUPDATE');
	addon:RegisterMsg('ANGLE_UPDATE', 'MAP_AOS_ANGLEUPDATE');
	addon:RegisterMsg('AOS_OBJ_ENTER', 'ON_AOS_OBJ_ENTER');
	addon:RegisterMsg('AOS_OBJ_LEAVE', 'ON_AOS_OBJ_LEAVE');
	addon:RegisterMsg('AOS_POS_UPDATE', 'ON_AOS_POS_UPDATE');
]]
		
end

function MAP_AOS_CREATE(addon, frame)

	addon:RegisterMsg('MAP_CHARACTER_UPDATE', 'MAP_AOS_MYPCUPDATE');
	addon:RegisterMsg('ANGLE_UPDATE', 'MAP_AOS_ANGLEUPDATE');
	addon:RegisterMsg('AOS_OBJ_ENTER', 'ON_AOS_OBJ_ENTER');
	addon:RegisterMsg('AOS_OBJ_LEAVE', 'ON_AOS_OBJ_LEAVE');
	addon:RegisterMsg('AOS_POS_UPDATE', 'ON_AOS_POS_UPDATE');
	addon:RegisterMsg('CHANGE_VIEW_FOCUS', 'ON_CHANGE_VIEW_FOCUS');
		
	local map = frame:GetChild("map");
	
	frame:SetValue(map:GetX());
	frame:SetValue2(map:GetY());
	
end

--[[
struct AOS_INFO_C
{
	int teamID;
	int	classID;
	int handle;
	int x;
	int y;
};
]]

function SET_AOS_PIC_POS_WORLD(frame, map, pic, x, y)

	local mapprop = session.GetCurrentMapProp();
	local MapPos = mapprop:WorldPosToMinimapPos(x, y);
	SET_AOS_PIC_POS(frame, map, pic, MapPos.x, MapPos.y);
	pic:ShowWindow(1);

end

function ON_AOS_POS_UPDATE(frame, msg, str, handle, info)

	local ctrlName = "__CTRL__" .. handle;
	local pic = frame:GetChild(ctrlName);
	if pic == nil then
		return;
	end
	
	tolua.cast(pic, "ui::CPicture");
	local map = frame:GetChild("map");
	SET_AOS_PIC_POS_WORLD(frame, map, pic, info.x, info.y);
	
end

function ON_AOS_OBJ_ENTER(frame, msg, str, handle, info)

	local iconSize = 12;
	local type = info.classID;
	local iconName = "";
	local colorTone = "";
	if type == 11119 then
		iconName = "fullwhite";
		colorTone = "FF888800";
		iconSize = 4;
	elseif type == 40205 then
		iconName = "minimap_goddess";
	elseif type == 40200 then
		iconName = "minimap_portal";
	elseif type == 40202 or type == 40206 then
		iconName = "fullwhite";
		if info.teamID == GET_MY_TEAMID() then
			colorTone = "FF0000FF";
		else
			colorTone = "FFFF0000";
		end
		
		iconSize = 3;
	elseif type == 40203 then -- golem
		iconName = "fullwhite";
		if info.teamID == GET_MY_TEAMID() then
			colorTone = "FF0000FF";
		else
			colorTone = "FFFF0000";
		end
		
		iconSize = 7;
	elseif type == 40204 then -- midboss
		iconName = "fullwhite";
		colorTone = "FF880088";
		iconSize = 9;
	elseif type == 0 and session.GetMyHandle() ~= handle then
		iconName = "fullwhite";
		if info.teamID == GET_MY_TEAMID() then
			colorTone = "FF0000FF";
		else
			colorTone = "FFFF0000";
		end
		
		iconSize = 6;
	end
	
	if iconName == "" then
		return;
	end
	
	local ctrlName = "__CTRL__" .. handle;
	local pic = frame:CreateOrGetControl('picture', ctrlName, 500, 500, iconSize, iconSize);
	tolua.cast(pic, "ui::CPicture");
	pic:SetImage(iconName);
	pic:SetEnableStretch(1);
	pic:ShowWindow(1);
	if colorTone ~= "" then
		pic:SetColorTone(colorTone);
	end
		
	local map = frame:GetChild("map");
	
	SET_AOS_PIC_POS_WORLD(frame, map, pic, info.x, info.y);
	
end

function ON_AOS_OBJ_LEAVE(frame, msg, str, handle)

	local ctrlName = "__CTRL__" .. handle;
	local pic = frame:GetChild(ctrlName);
	if pic == nil then
		return;
	end
	
	frame:RemoveChild(ctrlName);
	frame:Invalidate();

end

function SET_AOS_PIC_POS(frame, map, obj, x, y)
	
	x = x * map:GetWidth() / 650;
	y = y * map:GetHeight() / 650;
	
	local offsetX = frame:GetValue();
	local offsetY = frame:GetValue2();
	obj:SetOffset(x + offsetX - obj:GetWidth() / 2, y + offsetY - obj:GetHeight() / 2);

end


function ON_CHANGE_VIEW_FOCUS(frame, msg, name, handle)

	local pos = info.GetPositionInMap(handle);
	local my = GET_CHILD(frame, "my", "ui::CPicture");
	local map = frame:GetChild("map");
	SET_AOS_PIC_POS(frame, map, my, pos.x, pos.y);
	my:MakeTopBetweenChild();
	frame:Invalidate();

end

function MAP_AOS_MYPCUPDATE(frame, msg, name, handle)

	local fhandle = view.GetFocusedHandle();
	if fhandle ~= 0 then
		handle = fhandle
	end
	
	local map = frame:GetChild("map");
	local pos = info.GetPositionInMap(handle, map:GetWidth(), map:GetHeight());
	local my = GET_CHILD(frame, "my", "ui::CPicture");	
	SET_AOS_PIC_POS(frame, map, my, pos.x, pos.y);
	my:MakeTopBetweenChild();
	frame:Invalidate();

end


function MAP_AOS_ANGLEUPDATE(frame, msg, name, handle)

	local mapprop = session.GetCurrentMapProp();
	local angle = info.GetAngle(handle) - mapprop.RotateAngle;
	local my = GET_CHILD(frame, "my", "ui::CPicture");
	my:SetAngle(angle);
	frame:Invalidate();	
end








