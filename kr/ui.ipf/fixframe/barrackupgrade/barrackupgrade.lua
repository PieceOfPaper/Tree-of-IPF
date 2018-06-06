function BARRACKUPGRADE_ON_INIT(addon, frame)

	--꾸미기 에드온은 부르지 않는다.
	--아직 구현이안되있기때문에... 10.05 주석함
	--addon:RegisterMsg("ACCOUNT_PROP_UPDATE", "ON_ACCOUNT_PROP_UPDATE");

end

function ON_ACCOUNT_PROP_UPDATE(frame)
	BARRACKUPGRADE_UPDATE(frame);
end

function BARRACKUPGRADE_FIRST_OPEN(frame)
	BARRACKUPGRADE_UPDATE(frame);
end

function BARRACKUPGRADE_UPDATE(frame)
	UPDATE_B_UPGRADE_THEMA(frame);
	UPDATE_B_UPGRADE_OBJECT(frame);
end

function UPDATE_B_UPGRADE_THEMA(frame)

	local advBox = GET_CHILD(frame, "AdvBox", "ui::CAdvListBox");
	advBox:ClearUserItems();

	local account = GetMyAccountObj();
	local curID = account.SelectedBarrack;

	local clsList, cnt = GetClassList("BarrackMap");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		local mapCls = GetClass("Map", cls.ClassName);
		local key = cls.ClassName;
		--local isHave = account["Have_" .. cls.ClassName];

		local mapNameStr = string.format("%s %s", mapCls.Name, string.format("%dPeople", cls.BaseSlot));
		local previewScp = "{a @BARRACK_PREVIEW " .. mapCls.ClassName .. "}";
		local bitem = SET_ADVBOX_ITEM_C(advBox, key, 0, "{@st41b}" .. previewScp .. mapNameStr, "white_16_ol");
		bitem:EnableHitTest(1);
		bitem:SetTextTooltip(ScpArgMsg("Auto_{@st59}KeulLigHayeo_MiLiBoKi"));

		if config.GetServiceNation() == "KOR" then
		SET_ADVBOX_ITEM_C(advBox, key, 1, "{@st41b}   " ..  cls.Price .. " TP", "white_16_ol");
		else
			SET_ADVBOX_ITEM_C(advBox, key, 1, "{@st41b}   " ..  cls.Price .. " iCoin", "white_16_ol");
		end

		if mapCls.ClassID == curID then
			bitem = SET_ADVBOX_ITEM_C(advBox, key, 2, ScpArgMsg("Auto_{@st41b}SayongJung"), "white_16_ol");
		else
			local selectScp = "{a @BARRACK_BUY " .. mapCls.ClassName .. "}";
			bitem = SET_ADVBOX_ITEM_C(advBox, key, 2, "{@st41b} " .. selectScp .. ScpArgMsg("Auto_SeonTaeg"), "white_16_ol");
		end
		bitem:EnableHitTest(1);
	end

	advBox:UpdateAdvBox();
end

function BARRACK_PREVIEW(frame, ctrl, str, num)
	barrack.Preview(str);
end

function BARRACK_SET_CURRENT(frame, ctlr, str, num)
	barrack.SelectThema(str);
end

function BAR_UPGRADE_TAB_CHANGE(frame)



end
