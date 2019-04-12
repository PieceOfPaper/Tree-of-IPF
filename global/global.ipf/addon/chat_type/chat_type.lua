
function CHAT_TYPE_LISTSET(selected)
	if selected == 0 then
		return;
	end;

	if ui.GetWhisperTargetName() == nil and selected == 5 then
		return;
	end

	if (ui.GetGroupChatTargetID() == nil or ui.GetGroupChatTargetID() == "") and selected == 6 then
		return;
	end


	local frame = ui.GetFrame('chat');		
	frame:SetUserValue("CHAT_TYPE_SELECTED_VALUE", selected);
	local chattype_frame = ui.GetFrame('chattypelist');
	local j = 1;
	for i = 1, 6 do

		local color = frame:GetUserConfig("COLOR_BTN_" .. i);	
		if selected ~= i then	
			
			local btn_Chattype = GET_CHILD(chattype_frame, "button_type" .. j);
			if btn_Chattype == nil then
				return;
			end			
			
			btn_Chattype:Resize(btn_Chattype:GetOriginalWidth(), btn_Chattype:GetOriginalHeight()); 
			local msg = "{@st60}".. ScpArgMsg("ChatType_" .. i)  .. "{/}";
			
			btn_Chattype:SetText(msg);	
			btn_Chattype:SetTextTooltip( ScpArgMsg("ChatType_" .. i .. "_ToolTip") );
			btn_Chattype:SetPosTooltip(btn_Chattype:GetWidth() + 10 , (btn_Chattype:GetHeight() /2));
			btn_Chattype:SetColorTone( "FF".. color);

			btn_Chattype:SetIsUpCheckBtn(true);

			btn_Chattype:SetUserValue("CHAT_TYPE_CONFIG_VALUE", i);

			j = j + 1;
		else

			local btn_type = GET_CHILD(frame, "button_type");
			btn_type:Resize(btn_type:GetOriginalWidth()+20, btn_type:GetOriginalHeight());
			if btn_type == nil then
				return;
			end			
			local msg = "{@st60}".. ScpArgMsg("ChatType_" .. i) .. "{/}";
			btn_type:SetText(msg);	
			btn_type:SetColorTone("FF".. color);
			config.SetConfig("ChatTypeNumber", i);
			
		end;
	end;
end;


