-- barrackupgrade_object.lua

function UPDATE_B_UPGRADE_OBJECT(frame)

	local advBox = GET_CHILD(frame, "AdvBox_Obj", "ui::CAdvListBox");
	advBox:ClearUserItems();

	local account = GetMyAccountObj();

	local clsList, cnt = GetClassList("BarrackObject");
	for i = 0 , cnt - 1 do
		local cls = GetClassByIndexFromList(clsList, i);
		local monCls = GetClass("Monster", cls.ClassName);
		local key = cls.ClassName;

		local batchScp = "{a @B_UPGRADE_PLACE " .. monCls.ClassName .. "}";
		local bitem = SET_ADVBOX_ITEM_C(advBox, key, 0, "{@st41b}" .. batchScp .. monCls.Name, "white_16_ol");
		bitem:EnableHitTest(1);
		bitem:SetTextTooltip(ScpArgMsg("Auto_{@st59}KeulLigHayeo_MiLiBoKi"));
		SET_ADVBOX_ITEM_C(advBox, key, 1, GET_MONEY_IMG(24) .. "{@st41b}   " ..  cls.Price, "white_16_ol");
	end

	advBox:UpdateAdvBox();
end

function B_UPGRADE_PLACE(frame, ctrl, monClsName, numArg)

	local frame = frame:GetTopParentFrame();
	frame:SetUserValue("PLACE_MONSTER", monClsName);
	frame:RunUpdateScript("B_UPGRADE_PLACE_UPDATE", 0.0);
	mouseUtil.SetMouseMonster(monClsName);

end

function B_UPGRADE_PLACE_END()
	mouseUtil.SetMouseMonster("None");
end

function B_UPGRADE_PLACE_UPDATE(frame, elapsedTime)

	if mouseUtil.GetMonster() == "None" then
		return 0;
	end

	if frame:IsVisible() == 0 or keyboard.IsKeyDown("ESCAPE") == 1 then
		B_UPGRADE_PLACE_END();
		return 0;
	end

	if mouse.IsRBtnDown() == 1 then
		mouseUtil.HoldMouseMonster(true);
		B_UPGRADE_PLACE_POPUP(frame:GetUserValue("PLACE_MONSTER"));
	end

	return 1;

end

function B_UPGRADE_PLACE_POPUP(monClsName)

	local monCls = GetClass("Monster", monClsName);
	local objCls = GetClass("BarrackObject", monClsName);

	local menu = ui.CreateContextMenu("barrackPlace", monCls.Name, 0, 0, 100, 100);
	local itemTitle = ScpArgMsg("Auto_BaeChi");
	if objCls.Price > 0 then
		itemTitle = ScpArgMsg("Auto_BaeChi_({Auto_1})","Auto_1", objCls.Price);
	end

	ui.AddContextMenuItem(menu, itemTitle, "B_UPGRADE_EXEC_PLACE()");
	ui.AddContextMenuItem(menu, ScpArgMsg("Auto_ChwiSo"), "None()");
	ui.OpenContextMenu(menu);
	ui.SetContextInactiveScp(menu, "mouseUtil.HoldMouseMonster(false)");

end


function B_UPGRADE_EXEC_PLACE()

	barrackPlace.PlaceMonster();
	B_UPGRADE_PLACE_END();

end




