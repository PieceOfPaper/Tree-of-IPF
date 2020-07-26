
function GUILDCREATE_ON_INIT(addon, frame)
    addon:RegisterMsg('ENABLE_CREATE_GUILD_NAME', 'ENABLE_CREATE_GUILD_NAME');	
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
	local curVis = GET_GUILD_MAKE_PRICE();
	if IsGreaterThanForBigNumber(curVis, GET_TOTAL_MONEY_STR()) == 1 then
		ui.SysMsg(ScpArgMsg("NotEnoughMoney"));
		return;
	end

	local editbox = GET_CHILD(frame, 'input');
	if ui.IsValidCharacterName(editbox:GetText()) == true then
        pc.CheckUseName("GuildName", editbox:GetText(), "ENABLE_CREATE_GUILD_NAME");
	end
end

function CLEAR_GUILDCREATE_INPUT()

	local frame = ui.GetFrame('guildcreate');
	local editbox = GET_CHILD(frame, 'input');
	editbox:SetText("");	
	editbox:AcquireFocus();
end

function ENABLE_CREATE_GUILD_NAME(frame, msg, argStr, argNum)
	local frame = ui.GetFrame("guildcreate");
	local editbox = GET_CHILD(frame, 'input');
	local guildName = editbox:GetText();

	local yesScp = string.format("CREATE_GUILD(\"%s\")", guildName);
	local msg = ScpArgMsg("PossibleChangeName_2{Name}", "Name", guildName).." {nl}"..ScpArgMsg("ReallCreate?");
	local msgBox = ui.MsgBox(msg, yesScp, "None");	
end

function CREATE_GUILD(guildName)
	if ui.IsValidCharacterName(guildName) == true then
		CreateGuild(guildName);
		
		local frame = ui.GetFrame("guildcreate");
		frame:ShowWindow(0);
	end
end
