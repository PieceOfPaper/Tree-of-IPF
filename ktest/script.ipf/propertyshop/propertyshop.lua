
function GET_PVP_POINT(pc, tx, price)


	TxAddWorldPVPProp(tx, "ShopPoint", -price);
	return 1;

end

function PVP_CARD_GET_ITEM(pc)

	local level = pc.Lv;	
	local name, count = GetWorldPVPExpCard(level);
	return name, count;

end

function PVPShop_SUCCESS(pc, shopName)
	print('PVPShop_SUCCESS')
end

function GET_CASH_POINT(pc, tx, price)

if 1 == 1 then
		return;
	end

	local aobj = GetAccountObj(pc);
	if GetPCTotalTPCount(pc) < price then
		Chat(pc, ScpArgMsg('Auto_MeDali_BuJogHapNiDa.'));
		return 0;
	else
		TxAddIESProp(tx, aobj, "Medal", -price, "NpcShop");
		return 1;
	end

	return 0;
end

function CashShop_SUCCESS(pc, shopName)
	SendAddOnMsg(pc, "UPDATE_PROPERTY_SHOP", shopName, 1);
end

function SCR_TP_TEST_NPC_DIALOG(self, pc)
	if 1 == 1 then
		return;
	end

    local select = ShowSelDlg(pc, 0, 'DTACURLING_DLG1', ScpArgMsg('SelectTPShop'), ScpArgMsg('SelectTPCharge'), ScpArgMsg('Close'));
    if select == 1 then
        SendAddOnMsg(pc, "PROPERTY_SHOP_UI_OPEN", "TestCashShop", 0);
        return
    elseif select == 2 then
        Chat(self, "TP Charge", 3)
        return
    elseif select == 3 then
        return
    else
        return
    end
end

function GET_PVP_MINE_POINT(pc, tx, price)
    local aObj = GetAccountObj(pc);
	TxAddIESProp(tx, aObj, "PVP_MINE_POINT", -price, "PVP_MINE_POINT");
	return 1;
end