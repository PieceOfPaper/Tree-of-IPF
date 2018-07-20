function SOLDIERINFO_ON_INIT(addon, frame)

	addon:RegisterMsg("DUMMYPC_LIST", "ON_DUMMYPC_LIST");
	addon:RegisterMsg("DUMMYPC_HP_UPDATE", "ON_DUMMYPC_HP_UPDATE");
	
end

function ON_DUMMYPC_LIST(frame, msg, str, arg)

	local cnt = dummyPC.GetHiredCount();
	if cnt == 0 then
		frame:ShowWindow(0);
		return;
	end
	
	frame:ShowWindow(1);
	--frame:ShowWindow(0);
	DESTROY_CHILD_BY_USERVALUE(frame, "IS_DUMMYPC_CTRL", "YES");
	for i = 0 , cnt - 1 do
		local cid = dummyPC.GetHiredCIDByIndex(i);
		local info = dummyPC.GetByCID(cid);
		if info:IsEnableSession() == true then
			local ctrlSet = frame:CreateOrGetControlSet('partyinfo_helper', "_DPC_" .. cid, 10, i * 80);

			ctrlSet:ShowWindow(1);
			--ctrlSet:ShowWindow(0);	
			ctrlSet:SetUserValue("IS_DUMMYPC_CTRL", "YES");
			
			SET_MONB_ALWAYS_VISIBLE(info:GetHandle(), 1);
			
			local obj = GetIES(info:GetObject());
			local name_text= GET_CHILD(ctrlSet, 'name_text', "ui::CRichText");
			name_text:SetText("{@st41}" .. obj.Name);
			local levelObj = GET_CHILD(ctrlSet, 'level_text', "ui::CRichText");
			levelObj:SetText("{@st41}" .. obj.Lv);

			local jobportrait = GET_CHILD(ctrlSet, "jobportrait", "ui::CPicture");
			local imageName = ui.CaptureModelHeadImage_IconInfo(info:GetIconInfo());
			jobportrait:SetImage(imageName);
			jobportrait:SetEnableStretch(1);
			
			local hp = GET_CHILD(ctrlSet, "hp", "ui::CGauge");
			hp:SetPoint(info:GetHP(), info:GetMHP());
			local sp = GET_CHILD(ctrlSet, "sp", "ui::CGauge");
			sp:SetPoint(obj.MSP, obj.MSP);
		end
		
	end

	frame:Resize(240, cnt * 80 + 50)

end

function ON_DUMMYPC_HP_UPDATE(frame, msg, cid, hp)

	local ctrlSet = frame:GetChild("_DPC_" .. cid);
	if ctrlSet ~= nil then
		local hpctrl = GET_CHILD(ctrlSet, "hp", "ui::CGauge");
		local info = dummyPC.GetByCID(cid);
		hpctrl:SetCurPoint(hp);
		UPDATE_MONB(info:GetHandle());
	end

	
end






