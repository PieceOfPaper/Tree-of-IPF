

function CHAT_TYPE_INIT(addon, frame)	
	CHAT_TYPE_LISTSET(config.GetConfigInt("ChatTypeNumber"));
end

function CHAT_TYPE_CLOSE(frame)
	local chattype_frame = ui.GetFrame('chattypelist');	chattype_frame:ShowWindow(0);end

--ä�� Ÿ�� ��Ͽ��� ���ý� ä��Ÿ���� �ٲ��ְ� ����� �ݾ��ش�. 
function CHAT_TYPE_SELECTION(frame, ctrl)
	-- ������ �ɺ��� ���õ� Ÿ���� �˾ƺ���.
	local typeIvalue = ctrl:GetUserIValue("CHAT_TYPE_CONFIG_VALUE");
	if (nil == typeIvalue) or (0 == typeIvalue) or (typeIvalue > 5) then
		return;
	end;
	
	ui.SetChatType(typeIvalue-1);
	CHAT_TYPE_LISTSET(typeIvalue);
	CHAT_TYPE_CLOSE(frame);
end;

--ä�� Ÿ�� ��Ͽ��� 5���� Ÿ�Ե鿡 ���Ͽ� ��ư��ϵ��� ������ش�. 
function CHAT_TYPE_LISTSET(selected)
	if selected == 0 then
		return;
	end;



	local frame = ui.GetFrame('chat');		
	frame:SetUserValue("CHAT_TYPE_SELECTED_VALUE", selected);
	local chattype_frame = ui.GetFrame('chattypelist');
	
	local btn_type = GET_CHILD(frame, "button_type");
	if btn_type == nil then
		return;
	end			
	local w = btn_type:GetWidth();
	local h = btn_type:GetHeight();

	local j = 1;
	for i = 1, 5 do

		local color = frame:GetUserConfig("COLOR_BTN_" .. i);	
		if selected ~= i then	
			
		-- ���õ��� ���� Ÿ�Ե��� ���ȭ
		local btn_Chattype = GET_CHILD(chattype_frame, "button_type" .. j);
			if btn_Chattype == nil then
				return;
			end						btn_Chattype:Resize(w, h);
			
			local msg = "{@st60}".. ScpArgMsg("ChatType_" .. i)  .. "{/}";
			btn_Chattype:SetText(msg);	
			btn_Chattype:SetTextTooltip( ScpArgMsg("ChatType_" .. i .. "_ToolTip") );
			btn_Chattype:SetPosTooltip(btn_Chattype:GetWidth() + 10 , (btn_Chattype:GetHeight() /2));
			btn_Chattype:SetColorTone( "FF".. color);

			--�ٸ� �����ӿ����� ��ư�ٿ��� �Ǿ������� ���־�� �����ϴ� ��ó�� ���̰� �ϱ� ���� ����
			btn_Chattype:SetIsUpCheckBtn(true);

			--���߿� ��� �߿��� ���õǾ������� �ش� Ÿ���� �����ϱ� ���� �ɺ� ����. 
			btn_Chattype:SetUserValue("CHAT_TYPE_CONFIG_VALUE", i);

			--ä��â�� ��ư�� ��ϵ��� ���� �ٸ� ���������μ� �ش� ��ȣ�� ���� �޸� ī��Ʈ�ȴ�.
			j = j + 1;
			btn_Chattype:Invalidate();
		else

		--���õ� Ÿ���� ä�ù��� ��ư����
			local msg = "{@st60}".. ScpArgMsg("ChatType_" .. i) .. "{/}";
			btn_type:SetText(msg);	
			btn_type:SetColorTone("FF".. color);
			config.SetConfig("ChatTypeNumber", i);
			btn_type:Invalidate();
		end;
	end;
	chattype_frame:Resize(w, chattype_frame:GetHeight());
	chattype_frame:Invalidate();
end;



















