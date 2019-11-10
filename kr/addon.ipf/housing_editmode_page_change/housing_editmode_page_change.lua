function HOUSING_EDITMODE_PAGE_CHANGE_ON_INIT(addon, frame)
end

function DO_HOUSING_EDITMODE_PAGE_CHANGE(gbox, btn)
	local frame = gbox:GetTopParentFrame();
	local pageIndex = tonumber(frame:GetUserValue("PageIndex"));
	if pageIndex == nil or pageIndex < 1 then
		return;
	end

	housing.PageLoad(pageIndex);
	ON_HOUSING_EDITMODE_CLOSE();
	ui.CloseFrame("housing_editmode_page_change");
end

function DO_HOUSING_PAGE_CHANGE_CANCEL(frame, btn)
	ui.CloseFrame("housing_editmode_page_change");
end

function CLOSE_HOUSING_EDITMODE_PAGE_CHANGE()
	ui.CloseFrame("housing_editmode_page_change");
end