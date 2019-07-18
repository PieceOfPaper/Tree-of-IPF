
helplist_opencloseflag = {}


function HELPLIST_ON_INIT(addon, frame)

	addon:RegisterMsg("HELP_MSG_ADD", "ON_ADD_HELPLIST");
	addon:RegisterMsg("GAME_START", "ON_HELPLIST_UPDATE");

end


function UI_TOGGLE_HELPLIST()
	if app.IsBarrackMode() == true then
		return;
	end

	ui.ToggleFrame('helplist')
end

function UI_TOGGLE_CHATMACRO()
	if app.IsBarrackMode() == true then
		return;
	end

	ui.ToggleFrame('chatmacro');
end

function HELPLIST_ON_RELOAD(frame)

end

function HELPLIST_CLOSE(frame)

	ui.CloseFrame('piphelp')
	
end

function HELPLIST_OPEN(frame)
	
	ON_HELPLIST_UPDATE(frame)
end

function HELPLIST_GET_LIST_WITH_CATEGORY()

	local helpCount = session.GetHelpVecCount();

	local newlist = {}
	local categoryNameList = {}

	for i=0, helpCount -1 do
		
		local helpType = session.GetHelpTypeByIndex(i);
		local helpCls = GetClassByType("Help", helpType);

		if newlist[helpCls.Category] ~= nil then

			newlist[helpCls.Category][#newlist[helpCls.Category]+1] = helpCls
		else
			if helplist_opencloseflag[#categoryNameList+1] == nil then
				helplist_opencloseflag[#categoryNameList+1] = 1
			end
			
			categoryNameList[#categoryNameList+1] = helpCls.Category
			newlist[helpCls.Category] = {}
			newlist[helpCls.Category][#newlist[helpCls.Category]+1] = helpCls
		end

	end

	return categoryNameList, newlist

end

function ON_ADD_HELPLIST(frame, msg)

	ON_HELPLIST_UPDATE(frame);
--	local helpCount = session.GetHelpVecCount();
--	if helpCount == 1 then
--		SYSMENU_FORCE_ALARM("helplist", "HelpList");
--	end
	frame:Invalidate();

end


function ON_HELPLIST_UPDATE(frame)    

	local x = 10;
	local y = 20;
	local gbox = GET_CHILD(frame,"gbox");

	local categoryNameList, newlist = HELPLIST_GET_LIST_WITH_CATEGORY()

	for i = 1, #categoryNameList do

		local csetName = "HELP_CATE_CSET_" .. i;
		local cset = gbox:CreateOrGetControlSet('helplist_category', csetName, x, y);

		cset = tolua.cast(cset, "ui::CControlSet");
			
		cset:SetOverSound('button_over');
		cset:SetClickSound('button_click_stats');
				
		y = y + ui.GetControlSetAttribute("helplist_category", "height");

		local cnameRichText = GET_CHILD(cset, "help_category", "ui::CRichText");        
        
        local translated_name = categoryNameList[i]

        local start_index, end_index = string.find(categoryNameList[i], '@dicID')
        if start_index == 1 then
            translated_name = dic.getTranslatedStr(categoryNameList[i])
        end

		cnameRichText:SetTextByKey("help_category_param1", translated_name)
                
		local qwe = cset:GetEventScript(ui.LBUTTONDOWN)

		cset:SetEventScript(ui.LBUTTONDOWN, 'HELPCATEGORY_LCLICK')
		cset:SetEventScriptArgNumber(ui.LBUTTONDOWN, i);

		for j = 1, #newlist[categoryNameList[i]] do
			local helpCls = newlist[categoryNameList[i]][j]
			local setName = "HELP_CTRLSET_" .. i .. j;
			local set = gbox:CreateOrGetControlSet('helplist', setName, x + 10, y);
			set = tolua.cast(set, "ui::CControlSet");
			set:SetOverSound('button_over');
			set:SetClickSound('button_click_stats');

			if helplist_opencloseflag[i] == 1 then
				set:ShowWindow(1)
				y = y + ui.GetControlSetAttribute("helplist", "height");

				local nameRichText = GET_CHILD(set, "help_title", "ui::CRichText");
                
				local translated_helpCls_title = helpCls.Title
                local start_index, end_index = string.find(helpCls.Title, '@dicID')
                if start_index == 1 then
                    translated_helpCls_title = dic.getTranslatedStr(helpCls.Title)
                end

				nameRichText:SetTextByKey("help_name_param1", translated_helpCls_title);                
				set:SetEventScript(ui.LBUTTONDOWN, 'HELPLIST_LCLICK')
				set:SetEventScriptArgNumber(ui.LBUTTONDOWN, helpCls.ClassID);
				
			else
				set:ShowWindow(0)
			end
		end
		
		y = y + 10
	end

	gbox:UpdateData();
	gbox:SetCurLine(0);
	gbox:InvalidateScrollBar();
	frame:Invalidate()

end

function HELPCATEGORY_LCLICK(frame, slot, argStr, argNum)

	local index = argNum

	if helplist_opencloseflag[index] == 0 then
		helplist_opencloseflag[index] = 1
	else
		helplist_opencloseflag[index] = 0
	end

	local helpframe = ui.GetFrame('helplist');

	ON_HELPLIST_UPDATE(helpframe)
end

function ON_HELPLIST_UPDATE_OLD(frame)

	local helpCount = session.GetHelpVecCount();

	local x = 10;
	local y = 20;
	local gbox = frame:GetChild("gbox");

	for i=0, helpCount -1 do
		
		local helpType = session.GetHelpTypeByIndex(i);

		if helpType ~= -1 then
			local helpCls = GetClassByType("Help", helpType);

			local setName = "HELP_CTRLSET_" .. i;
			local set = gbox:CreateOrGetControlSet('helplist', setName, x, y);

			set = tolua.cast(set, "ui::CControlSet");
			
			set:SetOverSound('button_over');
			set:SetClickSound('button_click_stats');
				
			y = y + ui.GetControlSetAttribute("helplist", "height");

			local nameRichText = GET_CHILD(set, "help_title", "ui::CRichText");
			nameRichText:SetTextByKey("help_name_param1", helpCls.Title);

			set:SetEventScript(ui.LBUTTONDOWN, 'HELPLIST_LCLICK')
			set:SetEventScriptArgNumber(ui.LBUTTONDOWN, helpType);

		end
	end
end

function HELPLIST_LCLICK(frame, slot, argStr, argNum)

--	local helpmsgbox = ui.GetFrame("helpmsgbox");
--	HELPMSGBOX_MSG(helpmsgbox, "FORCE_OPEN", argStr, argNum)

	local piphelp = ui.GetFrame("piphelp");
	PIPHELP_MSG(piphelp, "FORCE_OPEN", argStr, argNum)
end




