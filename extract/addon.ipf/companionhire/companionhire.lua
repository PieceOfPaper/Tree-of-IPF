
function COMPANIONHIRE_ON_INIT(addon, frame)

end

function OPEN_COMPANION_HIRE(clsName)
	
	local frame = ui.GetFrame("companionhire");
	frame:ShowWindow(1);

	frame:SetUserValue("CLSNAME", clsName);
	local cls = GetClass("Companion", clsName);
	
	local input = frame:GetChild("input");
	input:SetText("");

	local price = frame:GetChild("price");

	local sellPrice = cls.SellPrice;
	if sellPrice ~= "None" then
		sellPrice = _G[sellPrice];
		sellPrice = sellPrice(cls, pc);
		price:SetTextByKey("value", GET_MONEY_IMG(24) .. " " .. GetCommaedText(sellPrice));
	else
		price:SetTextByKey("value", "");
	end

	local monCls = GetClass("Monster", clsName);
	local pic = GET_CHILD(frame ,"pic", "ui::CPicture");
	pic:SetImage(monCls.Icon);
	
	local petname = frame:GetChild("petname");
	petname:SetTextByKey("value", monCls.Name);
        

end

function TRY_COMPANION_HIRE(parent, ctrl)
	local clsName = parent:GetUserValue("CLSNAME");

	local cls = GetClass("Companion", clsName);
	local sellPrice = cls.SellPrice;
	if sellPrice ~= "None" then
		sellPrice = _G[sellPrice];
		sellPrice = sellPrice(cls, pc);

		local name = parent:GetChild("input");
		if string.find(name:GetText(), ' ') ~= nil then
			ui.SysMsg(ClMsg("NameCannotIncludeSpace"));
			return;
		end

		if ui.IsValidCharacterName(name:GetText()) == true then
			if GET_TOTAL_MONEY() < sellPrice then
				ui.SysMsg(ClMsg('NotEnoughMoney'));
			else
				local scpString = string.format("EXEC_BUY_COMPANION(\"%s\", \"%s\")", clsName, name:GetText());
				ui.MsgBox(ScpArgMsg("ReallyBuyCompanion?"), scpString, "None");
			end
		end

	end

end

function EXEC_BUY_COMPANION(clsName, inputName)

	local petCls = GetClass("Companion", clsName);
	local scpString = string.format("/pethire %d %s",  petCls.ClassID, inputName);
	ui.Chat(scpString);

end

function PET_ADOPT_SUC()
	ui.CloseFrame("companionhire");
	ui.CloseFrame("companionshop");

	ui.SysMsg(ClMsg("CompanionAdoptionSuccess"));
end

function PET_ADOPT_SUC_BARRACK()
	ui.CloseFrame("companionhire");
	ui.CloseFrame("companionshop");

	ui.SysMsg(ClMsg("CompanionAdoptionSuccessBarrack"));
end

