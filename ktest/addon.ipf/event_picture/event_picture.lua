-- event_picture.lua

function EVENT_PICTURE_ON_INIT(addon, frame)
	addon:RegisterMsg("EVENT_PICTURE", "EVENT_PICTURE_ON_MSG");
end

function EVENT_PICTURE_ON_MSG(frame, msg, str, arg1, arg2)
	local sList = StringSplit(str, "#");
	local imgName = "";
	local width, height = 0, 0;
	if #sList >= 1 then
		imgName = sList[1];
	end
	if #sList >= 2 then
		width = tonumber(sList[2]);
	end
	if #sList >= 3 then
		height = tonumber(sList[3]);
	end
	EVENT_PICTURE_OPEN(frame, imgName, width, height);
end

function EVENT_PICTURE_OPEN(frame, imgName, width, height)
	if nil == frame then
		frame = ui.GetFrame("event_picture");
	end

	frame:ShowWindow(1);

	local event_picture = GET_CHILD(frame, "picture", "ui::CPicture");
	event_picture:Resize(width, height);
	event_picture:SetImage(imgName);
	frame:Resize(width + 5 , height + 5);
end

function EVENT_PICTURE_CLOSE(frame, ctrl)
	local top = frame:GetTopParentFrame()
	top:ShowWindow(0);
end