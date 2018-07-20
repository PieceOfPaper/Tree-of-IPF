
function GUILDCREATE_ON_INIT(addon, frame)

	
	
end

function GUILDCREATE_ON_MSG(frame, msg, argStr, argNum)



end

function GUILDCREATE_ON_LOAD(frame, obj, argStr, argNum)


end


function GUILDCREATE_LIST_UPDATE()


end


function OPEN_GUILD_CREATE_UI()

	local frame = ui.GetFrame("guildcreate");
	local editbox = GET_CHILD(frame, 'input');
	editbox:SetText("");
	GUILD_CREATE_UPDATE(frame);
	frame:ShowWindow(1);

end

function GUILD_CREATE_UPDATE(frame)

	local txt_currentcount = frame:GetChild("txt_currentcount");
	local text = ScpArgMsg("YouConsume{Price}SilverToMakeGuild", "Price", GetCommaedText(GET_GUILD_MAKE_PRICE()));
	txt_currentcount:SetTextByKey("value", text);

end

function REQ_CREATE_GUILD(frame, obj, argStr, argNum)

	CREATE_GUILD(frame);
end

function CLEAR_GUILDCREATE_INPUT()

	local frame = ui.GetFrame('guildcreate');
	local editbox = GET_CHILD(frame, 'input');
	editbox:SetText("");	
	editbox:AcquireFocus();
	
end

function CREATE_GUILD(frame)

	local curVis = GET_GUILD_MAKE_PRICE();
	local myMaxMoney = GET_TOTAL_MONEY();
	if curVis > myMaxMoney then
		ui.SysMsg(ScpArgMsg("NotEnoughMoney"));
		return;
	end

	local editbox = GET_CHILD(frame, 'input');
	if ui.IsValidCharacterName(editbox:GetText()) == true then
		ui.Chat("/makeguild " .. editbox:GetText() );
	end
		frame:ShowWindow(0);
	
end

