

function CHAT_MEMBERLIST_ON_INIT(addon, frame)

end

function CHAT_MEMBERLIST_OPEN(frame)

	local roomname = string.sub(frame:GetName(), 9)

	local popupframe = ui.GetFrame("chatpopup_" .. roomname)
	if popupframe == nil then
		return
	end

	frame:SetOffset(popupframe:GetX() + popupframe:GetWidth(), popupframe:GetY())
end

function UPDATE_CHAT_MEMBERLIST(roomid)

	local frame = ui.GetFrame("chatmem_"..roomid)
	local info = session.chat.GetByStringID(roomid)
	if frame == nil or info == nil then
		return;
	end
	
	local colorType = session.chat.GetRoomConfigColorType(roomid)
	local colorCls = GetClassByType("ChatColorStyle", colorType)
	

	local groupbox = GET_CHILD_RECURSIVELY(frame,"mainbox")

	
	local cnt = info:GetMemberCount()
	local y = 0

	DESTROY_CHILD_BYNAME(groupbox, 'chatmemlist_');

	for i = 0, cnt -1 do

		local memctrl = groupbox:CreateOrGetControlSet('chatmemlist', 'chatmemlist_'..i , 0, y);

		local onlineimage = GET_CHILD_RECURSIVELY(memctrl, "online")
		local nametext = GET_CHILD_RECURSIVELY(memctrl, "memname")

		local name = info:GetMember(i)
		local online = info:IsMemberOnline(i)
		

		if colorCls ~= nil then
			name = "{#"..colorCls.TextColor.."}{ol}"..name.."{/}"
			nametext:SetText(name)

			if online == 1 then
				onlineimage:SetColorTone("FF"..colorCls.TextColor)
			else
				onlineimage:SetColorTone("FF000000")
			end

		end

		y = y + ui.GetControlSetAttribute("chatmemlist", 'height')

	end

	frame:Invalidate()

end