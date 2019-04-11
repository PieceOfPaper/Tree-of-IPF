

function FONT_LIST_ON_INIT(addon, frame)


end

function SEARCH_FONT_LIST(frame)
	FONT_LIST_UPDATE(frame);
end

function CLOSE_FONT_LIST(frame)
	Tool_CloseFontEdit();
end

function DBLCLICK_FONT_LIST(frame)
	local advBox = GET_CHILD(frame, "advlistbox", "ui::CAdvListBox");
	local key = advBox:GetSelectedKey();
	Tool_SelectFont(key);

end

function FONT_LIST_UPDATE(frame)

	local edit = GET_CHILD(frame, "input", "ui::CEditControl");
	local advBox = GET_CHILD(frame, "advlistbox", "ui::CAdvListBox");
	advBox:ClearUserItems();
	
	local editTxt = edit:GetText();
	local cnt = ui.GetStyleSheetCount();
	for i = 0 , cnt - 1 do
		local styleName = ui.GetStyleSheetByIndex(i);
		if editTxt == "" or string.find(styleName, editTxt) ~= nil then
			local txtName = " {@" .. styleName .. "}".. styleName .. "Hello";
			SET_ADVBOX_ITEM_C(advBox, styleName, 0, txtName, "white_16_ol");
		end
	end
end

function FONT_LIST_FIRST_OPEN(frame)
	FONT_LIST_UPDATE(frame);
end



