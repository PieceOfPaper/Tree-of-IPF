
function BARRACKTHEMA_ON_INIT(addon, frame)

	addon:RegisterMsg("ACCOUNT_PROP_UPDATE", "BARRACKTHEMA_ACCOUNT_PROP_UPDATE");
	
end

function BARRACKTHEMA_FIRST_OPEN(frame)
	BARRACK_THEMA_UPDATE(frame);
end

function BARRACKTHEMA_ACCOUNT_PROP_UPDATE(frame)
	BARRACK_THEMA_UPDATE(frame);
end

function BARRACK_THEMA_UPDATE(frame)
	if frame == nil then
		return;
	end

	frame:SetUserValue("InputType", "Family_Name");

	local bg = frame:GetChild("nxp_bg");
	local account = GetMyAccountObj();
	local mynxp = bg:GetChild("mynxp");
	local accountObj = GetMyAccountObj();
	mynxp:SetTextByKey("value", accountObj.GiftMedal + accountObj.PremiumMedal);
	local bg_1 = frame:GetChild("nxp_bg_1");
	local mynxp_1 = bg_1:GetChild("mynxp_1");
	mynxp_1:SetTextByKey("value", accountObj.Medal);

	local tpText = ScpArgMsg("TPText{Premium}and{Event}","Premium", tostring(accountObj.PremiumMedal),"Event",tostring(accountObj.GiftMedal))
	bg:SetTextTooltip(tpText)

	local curID = account.SelectedBarrack;
	local bg_mid = frame:GetChild("bg_mid");
	local advBox = GET_CHILD(bg_mid, "AdvBox", "ui::CAdvListBox");
	advBox:ClearUserItems();
	local clsList, cnt = GetClassList("BarrackMap");

	local preViewName = barrack.GetPreViewName();
	for i = 0 , cnt - 1 do
		local ctrlSet = advBox:CreateOrGetControlSet("barrackList", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local cls = GetClassByIndexFromList(clsList, i);

		local skinImage = GET_CHILD(ctrlSet,"image");
		skinImage:SetImage(cls.imageName);

		local skinName = GET_CHILD(ctrlSet,"name");
		skinName:SetTextByKey("value", cls.Name);

		local charCntBox = ctrlSet:GetChild("charCnt");
		local cashCnt = charCntBox:GetChild("cashCnt");
		cashCnt:SetTextByKey("value", cls.MaxCashPC);

		local nxpBox = ctrlSet:GetChild("nxp");
		local nxpCnt = nxpBox:GetChild("nxpCnt");
		nxpCnt:SetTextByKey("value", cls.Price);

		local goBackBarrack = ctrlSet:GetChild("goBackBarrack");
		goBackBarrack:ShowWindow(0);

		local env = GetEnv();
		if env.Mode == "Preview" and preViewName == cls.ClassName then
			goBackBarrack:ShowWindow(1);
		end

		local changeBtn = ctrlSet:GetChild("changeBtn");
		changeBtn:ShowWindow(0);

		local buyBtn = ctrlSet:GetChild("buyBtn");
		local state = ctrlSet:GetChild("state");
		local mapCls = GetClass("Map", cls.ClassName);
	
		local preViewBtn = ctrlSet:GetChild("preViewBtn");
		local previewScp = string.format("BARRACKTHEMA_PREVIEW(\'%s\')", cls.ClassName);
		preViewBtn:SetEventScript(ui.LBUTTONUP, previewScp, true);

		local have = barrack.HaveThame(mapCls.ClassID, cls.Price);

		if true == have then -- ���� �׸��� ������ ���� ��
			local appliedScp = string.format("BARRACKTHEMA_APPLIED(\'%s\')", cls.ClassName);
			changeBtn:SetEventScript(ui.LBUTTONUP, appliedScp, true);
			changeBtn:ShowWindow(1);
			buyBtn:ShowWindow(0);

			if mapCls.ClassID == curID then -- ���� �������̶��
				preViewBtn:ShowWindow(0);
				state:SetTextByKey("value", ClMsg("IsApplied"));
				changeBtn:SetEnable(0);
			else
				state:SetTextByKey("value", ClMsg("IsHaved"));
			end
		else
			local buyScp = string.format("BARRACK_BUY(\'%s\')", cls.ClassName);
			buyBtn:SetEventScript(ui.LBUTTONUP, buyScp, true);
		end


		if cls.Price == 0 or have then
			nxpBox:ShowWindow(0);
		else
			nxpBox:ShowWindow(1);
		end
	end
	
	advBox:UpdateAdvBox();
	GBOX_AUTO_ALIGN(advBox, 5, 3, 10, true, false);
end

function BARRACKTHEMA_PREVIEW(themaName)
	barrack.Preview(themaName);
end

function BARRACKTHEMA_APPLIED(themaName)
	barrack.SelectThema(themaName);
end

function BARRACKTHEMA_CANCEL_PREVIEW(parent, ctrl)
	if barrack.IsPreviewMode() == true then
		barrack.ToMyBarrack();
	else
		ui.CloseFrame("barrackthema")
	end
end

function BARRACKTHEMA_REQ_SLOT_PRICE()
	local scp = ClMsg("DoyouBuySlotInBarrack");
	ui.MsgBox(scp, "barrack.ReqSlotPrice()", "None");
end

function BARRACKTHEMA_ASK_BUY_SLOT(price)
	local str = ScpArgMsg('{TP}ReqSlotBuy', "TP", price);
	if nil == str then
		ui.MsgBox(ClMsg("DataError"));
		return;
	end

	local yesScp = string.format("barrack.ReqBuyCharSlot(%d)", price);
	ui.MsgBox(str, yesScp, "None");
end

function BARRACK_BUY(buyMap)
	local cls = GetClass("BarrackMap", buyMap);

	local msgBoxStr = ClMsg("ReallyBuy?") .. "{nl}" .. cls.Price .. " " .. ScpArgMsg("NXP");

	local yesScp = string.format("EXEC_BUY_BARRACK(\"%s\")", buyMap);
	if GET_CASH_TOTAL_POINT_C() < cls.Price then
		ui.MsgBox(ClMsg("NotEnoughMedal"));		
	else
		ui.MsgBox(msgBoxStr, yesScp, "None");
	end

end

function EXEC_BUY_BARRACK(name)
	barrack.BuyThema(name);

end

