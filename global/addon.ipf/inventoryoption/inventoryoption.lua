	-- inventoryoption.lua


g_invenOptionType = {"Equip", "Card", "Etc", "Gem"};
g_invenOptionDetail_defaultOn = {{"All", "Normal", "Magic", "Rare", "Unique", "Legend"}, 
								 {"All", "Red", "Blue", "Green", "Purple", "Legend", "Etc"},
								 {"All", "Usual", "Quest", "Etc", "Collect", "Special", "Mineral"},
								 {"All", "Red", "Blue", "Yellow", "Green", "White", "Skill"}}
g_invenOptionDetail_defaultOff = {{"Upgrade", "Random"},
								  {""}, {""}, {""}}

function INVENTORYOPTION_ON_INIT(addon, frame)

end


function INVENTORYOPTION_CLOSE()
	local frame = ui.GetFrame("inventoryoption")
	ui.CloseFrame("inventoryoption")
end

function INVENTORYOPTION_RESET_BTN()
	local frame = ui.GetFrame("inventoryoption")

	if #g_invenOptionType == 0 then
		return
	end

	for i = 1, #g_invenOptionType do
		if #g_invenOptionDetail_defaultOn > 0 then
			for j = 1, #g_invenOptionDetail_defaultOn[i] do
				local checkBoxName = "cbox_" .. g_invenOptionType[i] .. "_" .. g_invenOptionDetail_defaultOn[i][j]
				local checkBox = GET_CHILD_RECURSIVELY(frame, checkBoxName)
				if checkBox ~= nil then
					checkBox:SetCheck(1)
				end
			end
		end

		if #g_invenOptionDetail_defaultOff > 0 then
			for j = 1, #g_invenOptionDetail_defaultOff[i] do
				local checkBoxName = "cbox_" .. g_invenOptionType[i] .. "_" .. g_invenOptionDetail_defaultOff[i][j]
				local checkBox = GET_CHILD_RECURSIVELY(frame, checkBoxName)
				if checkBox ~= nil then
					checkBox:SetCheck(0)
				end
			end
		end
	end

	INVENTORY_TOTAL_LIST_GET(frame)
end

function INVENTORYOPTION_CHECK_ALL(frame, ctrl, argStr, argNum)
	local invOptionFrame = ui.GetFrame("inventoryoption")
	if invOptionFrame == nil or argNum == nil or argNum <= 0 or argNum > #g_invenOptionType then
		return
	end

	if #g_invenOptionDetail_defaultOn[argNum] > 1 then
		for i = 2, #g_invenOptionDetail_defaultOn[argNum] do
			local checkBoxName = "cbox_" .. g_invenOptionType[argNum] .. "_" .. g_invenOptionDetail_defaultOn[argNum][i]
			local checkBox = GET_CHILD_RECURSIVELY(invOptionFrame, checkBoxName)

			if ctrl:IsChecked() == 1 then
				checkBox:SetCheck(1)
			else
				checkBox:SetCheck(0)
			end
		end
	end

	INVENTORY_TOTAL_LIST_GET(frame)
end

function INVENTORYOPTION_CHECK_NOT_ALL(frame, ctrl, argStr, argNum)
	local invOptionFrame = ui.GetFrame("inventoryoption")
	if invOptionFrame == nil or argNum == nil or argNum <= 0 or argNum > #g_invenOptionType then
		return
	end

	local checkBoxName = "cbox_" .. g_invenOptionType[argNum] .. "_" .. g_invenOptionDetail_defaultOn[argNum][1]
	local checkBox = GET_CHILD_RECURSIVELY(invOptionFrame, checkBoxName)

	if ctrl:IsChecked() == 0 then
		checkBox:SetCheck(0)
	end

	INVENTORY_TOTAL_LIST_GET(frame)
end

function INVENTORYOPTION_CHECK_EXTRA(frame, ctrl, argStr, argNum)
	INVENTORY_TOTAL_LIST_GET(frame)
end