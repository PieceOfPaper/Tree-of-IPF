
function DRAGRECIPE_ON_INIT(addon, frame)



end

function START_DRAG_RECIPE(frame, dragDlgFrame, makeID, recipeID, recipeCount)

	for i=1, 5 do
		if dragDlgFrame:GetUserValue("ITEMID_"..i) ~= "None" then
			local item = session.GetInvItemByGuid(dragDlgFrame:GetUserValue("ITEMID_"..i));
			frame:SetUserValue("ITEMID_"..i, item:GetIESID());
			
			local itemObj = GetIES(item:GetObject());
			local slot = GET_CHILD(frame, "item"..i, "ui::CSlot");
			
			if slot ~= nil then
				SET_SLOT_IMG(slot, itemObj.Icon);
			end
		else
			frame:SetUserValue("ITEMID_"..i, "None");
		end
	end	
	frame:SetUserValue("MAKE_ITEMID", makeID);
	frame:SetUserValue("RECIPECOUNT", recipeCount);
	frame:SetUserValue("RECIPE_ID", recipeID);
	frame:SetUserValue("RECIPE_NOWCOUNT", 1);
	
	local recipeCls = GetClassByType("Recipe", recipeID);
	local second = recipeCls.RecipeTime;

	local timegauge = GET_CHILD(frame, "timegauge", "ui::CGauge");
	timegauge:SetPoint(0, second);
	timegauge:SetPointWithTime(second, second);

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("CHECK_DRAG_RECIPE_TIME");
	timer:Start(0.01, 0);
	frame:SetValue(second);
	frame:ShowWindow(1);

	packet.ClientDirect("StartManufacture", recipeCls.Playanim);

end

function CHECK_DRAG_RECIPE_TIME(frame, timer, str, num, totalTime)

	if 1 == control.IsMoving() then
		ui.AlarmMsg("ItemMakingFailedByMoving");
		frame:ShowWindow(0);
		timer:Stop();
		return;
	end

	local makeCount = tonumber(frame:GetUserValue("RECIPECOUNT"));
	local nowMakeCount = tonumber(frame:GetUserValue("RECIPE_NOWCOUNT"));

	local makeCountCtrl = GET_CHILD(frame, "count", "ui::CRichText");
	makeCountCtrl:SetText(string.format("{@st45tw2}%d / %d", nowMakeCount, makeCount));

	local manuFactureTime = frame:GetValue();
	if totalTime < manuFactureTime then
		imcSound.PlaySoundEvent('sys_jam_barguage');
		return;
	end

	--packet.ClientDirect("StopManufacture");
	timer:Stop();
	
	local makeItemID = frame:GetUserValue("MAKE_ITEMID");
	session.ResetItemList();
	
	for i=1, 5 do
		if frame:GetUserValue("ITEMID_"..i) ~= "None" then
			local itemID = frame:GetUserValue("ITEMID_"..i);
			session.AddItemID(itemID);
		end
	end
	
	local resultlist = session.GetItemIDList();

	local recipeID = frame:GetUserValue("RECIPE_ID");
	local cntText = string.format("%s %s", "1", recipeID);

	item.DialogTransaction("DRAG_RECIPE_MANUFACTURE", resultlist, cntText);

	frame:SetUserValue("RECIPE_NOWCOUNT", tostring(nowMakeCount + 1));

	if makeCount < nowMakeCount + 1 then
		frame:ShowWindow(0);
		packet.ClientDirect("StopManufacture");
		timer:Stop();
		session.ResetItemList();
				
		for i=1, 5 do
			frame:SetUserValue("ITEMID_"..i, "None");
		end
	
		return;
	end


	RESTART_DRAG_RECIPE(frame);

	imcSound.PlaySoundEvent('system_craft_potion_succes');
end

function RESTART_DRAG_RECIPE(frame)
	local recipeID = frame:GetUserValue("RECIPE_ID");

	local recipeCls = GetClassByType("Recipe", recipeID);
	local second = recipeCls.RecipeTime;

	local timegauge = GET_CHILD(frame, "timegauge", "ui::CGauge");
	timegauge:SetPoint(0, second);
	timegauge:SetPointWithTime(second, second);

	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");
	timer:SetUpdateScript("CHECK_DRAG_RECIPE_TIME");
	timer:Start(0.01, 0);
	frame:SetValue(second);

	--packet.ClientDirect("StartManufacture", recipeCls.Playanim);
end

function CANCEL_DRAG_RECIPE(frame)

	for i=1, 5 do
		frame:SetUserValue("ITEMID_"..i, "None");
	end
	
	local timer = GET_CHILD(frame, "addontimer", "ui::CAddOnTimer");	
	timer:Stop();
	frame:ShowWindow(0);
	packet.ClientDirect("StopManufacture");

end
