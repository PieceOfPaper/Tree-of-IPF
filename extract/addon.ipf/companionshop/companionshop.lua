
function COMPANIONSHOP_ON_INIT(addon, frame)
	addon:RegisterMsg('OPEN_DLG_COMPANIONSHOP', 'ON_OPEN_DLG_COMPANIONSHOP');
end

function ON_OPEN_DLG_COMPANIONSHOP(frame, msg, shopGroup)
	frame:SetUserValue("SHOP_GROUP", shopGroup);
	frame:ShowWindow(1);
end

function UPDATE_COMPANION_SELL_LIST(frame)
	
	local shopGroup = frame:GetUserValue("SHOP_GROUP");
	local bg = frame:GetChild("bg");
	bg:RemoveAllChild();

	local invenZeny = GET_CHILD_RECURSIVELY(frame, 'invenZeny', 'ui::CRichText');
	invenZeny:SetText("{@st41b}".. GET_TOTAL_MONEY())

	local pc = GetMyPCObject();
	local clsList, cnt = GetClassList("Companion");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		local sellPrice = cls.SellPrice;
		if sellPrice ~= "None" and shopGroup == cls.ShopGroup then
			sellPrice = _G[sellPrice];
			local price = sellPrice(cls, pc);		
			local ctrlSet = bg:CreateControlSet("companionshop_ctrl", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
			ctrlSet:SetUserValue("CLSNAME", cls.ClassName);
			local name = ctrlSet:GetChild("name");
			local priceCtrl = ctrlSet:GetChild("price");
			priceCtrl:SetTextByKey("txt", GET_MONEY_IMG(20) ..  " " .. GetCommaedText(price));
			local monCls = GetClass("Monster", cls.ClassName);
			name:SetTextByKey("txt", monCls.Name);
			name:SetTextByKey("JobID", cls.JobID);
			local slot = GET_CHILD(ctrlSet, "slot", "ui::CSlot");
			local icon = CreateIcon(slot);
			icon:SetImage(monCls.Icon);
			local btn = ctrlSet:GetChild("btn");
			btn:SetEventScript(ui.LBUTTONUP, "BUY_COMPANION");
			
		end
		
	end

	GBOX_AUTO_ALIGN(bg, 20, 10, 10, true, false);
end

function BUY_COMPANION(ctrlSet, btn)
	local name = ctrlSet:GetChild("name");
	local clsName = ctrlSet:GetUserValue("CLSNAME");
	local cls = GetClass("Companion", clsName);

	-- 일반적으로 0 이거나, 등록된 잡아이디와 같지 않으면 살수없음!
	-- ex) 응사는 매만 살 수 있다.
	if cls.JobID == 0 or 0 ~= session.GetJobGrade(cls.JobID) then
		OPEN_COMPANION_HIRE(clsName);
	else
		ui.MsgBox(ScpArgMsg("HaveNotJobForbyingCompaion"));
	end

end

function CLOSE_COMPANION_SHOP(frame)
	control.DialogOk();
end