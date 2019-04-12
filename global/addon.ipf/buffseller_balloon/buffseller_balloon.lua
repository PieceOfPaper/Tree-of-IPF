-- buffseller_ballon.lua

function BUFFSELLER_BALLOON_ON_INIT(addon, frame)

	
end

function AUTOSELLER_BALLOON(title, sellType, handle, skillID, skillLv)
	if title == "" then
		local frame = nil;
		if AUTO_SELL_BUFF == sellType then
			 frame = ui.GetFrame("buffseller_target");
		elseif  sellType == AUTO_SELL_PERSONAL_SHOP then
			frame = ui.GetFrame("personal_shop_register");
		elseif sellType == AUTO_TITLE_FOOD_TABLE then
		elseif sellType == AUTO_SELL_OBLATION then
			frame = ui.GetFrame("oblation_sell");
		elseif sellType == AUTO_SELL_ORACLE_SWITCHGENDER then
			frame = ui.GetFrame("switchgender")
		elseif sellType == AUTO_SELL_ENCHANTERARMOR then
			frame = ui.GetFrame("enchantarmor");
		else
			CLOSE_SQUIRE_STORE(handle, skillID);
		end
		if nil ~= frame then
			local ownerHandle = frame:GetUserIValue("HANDLE");
			if ownerHandle == handle then
				ui.CloseFrame(frame:GetName());
			end
		end
		ui.DestroyFrame("SELL_BALLOON_" .. handle);
		return;
	end

	local frameName = "SELL_BALLOON_" .. handle;
	local frame = ui.CreateNewFrame("buffseller_balloon", frameName);
	if frame == nil then
		return nil;
	end

	local pic = GET_CHILD(frame, "bg", "ui::CPicture");
	if AUTO_SELL_BUFF == sellType then
		pic:SetImage("sign_buff");
	elseif sellType == AUTO_TITLE_FOOD_TABLE then
		pic:SetImage("sign_food");
	elseif sellType == AUTO_SELL_GEM_ROASTING then
		pic:SetImage("sign_gem");
	elseif sellType == AUTO_SELL_SQUIRE_BUFF then
		pic:SetImage("sign_fix");
	elseif sellType == AUTO_SELL_OBLATION then
		pic:SetImage("sign_bong");
	elseif sellType == AUTO_SELL_ORACLE_SWITCHGENDER then
		pic:SetImage("sign_gender");
  elseif sellType == AUTO_ENCHANTAROR_STORE_OPEN then
		pic:SetImage("sign_gender");
	elseif sellType == AUTO_SELL_ENCHANTERARMOR then
		pic:SetImage("sign_enchant");
  elseif sellType == AUTO_SELL_ORACLE_SWITCHGENDER then
		pic:SetImage("sign_gender");
	elseif sellType == AUTO_SELL_APPRAISE then
		pic:SetImage("sign_Appraiser");
	else
		pic:SetImage("sign_buy");
	end

	frame:SetUserValue("SELL_TYPE", sellType);
	frame:SetUserValue("HANDLE", handle);

	-- level을 표시해야 하는 경우 레벨과 타이틀이 함께 있는 ui를 보여주고, 아니면 이름만 보여줌
	local lvBox = frame:GetChild("withLvBox")
	local text = frame:GetChild("text");
	if sellType == AUTO_SELL_BUFF or sellType == AUTO_SELL_GEM_ROASTING or sellType == AUTO_SELL_SQUIRE_BUFF or sellType == AUTO_SELL_ENCHANTERARMOR or sellType == AUTO_SELL_APPRAISE then
		local lvText = lvBox:GetChild("lv_text")
		local lvTitle = lvBox:GetChild('lv_title')
		lvText:SetTextByKey("value", skillLv)
		lvTitle:SetTextByKey("value", title)
		text:ShowWindow(0)
	else
		text:SetTextByKey("value", title);
		lvBox:ShowWindow(0)
	end	
	frame:ShowWindow(1);

	local offsetY = - 100;
	if sellType == AUTO_TITLE_FOOD_TABLE then
		offsetY = -50;
	end
	
	local actor = world.GetActor(handle);
	if actor ~= nil then
		actor:GetTitle():SetBuffSellerBalloonFrame(frameName, offsetY);
	end
	
end

function BUFFSELLER_OPEN(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local sellType = frame:GetUserIValue("SELL_TYPE");
	local handle = parent:GetUserIValue("HANDLE");

	if sellType == AUTO_TITLE_FOOD_TABLE then
		local frame = ui.GetFrame("foodtable_ui");
		session.camp.RequestOpenFoodTable(handle);
	else
		session.autoSeller.RequestOpenShop(handle, sellType);
	end
end

function CLOSE_SQUIRE_STORE(handle, skillID)
	if 0 == skillID then		
		return;
	end

	local skillName = GetClassByType("Skill", skillID).ClassName;
	 -- GetUserIValue 는 string, GetUserIValue inter!

	if "Squire_Repair" == skillName then
		local repair = ui.GetFrame("itembuffrepair");
		local re_handle = repair:GetUserIValue("HANDLE");
		if  handle == re_handle then
			ui.CloseFrame("itembuffrepair");
		end
	elseif "Squire_WeaponTouchUp" == skillName or "Squire_ArmorTouchUp" == skillName then
		local mending = ui.GetFrame("itembuffopen");
		local mend_handle = mending:GetUserIValue("HANDLE");
		if handle == mend_handle then
			ui.CloseFrame("itembuffopen");
		end
		packet.StopTimeAction(1);

	elseif "Alchemist_Roasting" == skillName then
		local mending = ui.GetFrame("itembuffgemroasting");
		local mend_handle = mending:GetUserIValue("HANDLE");
		if handle == mend_handle then
				ui.CloseFrame("itembuffgemroasting");
		end
	elseif skillName == 'Appraiser_Apprise' then
		local pcAppraise = ui.GetFrame('appraisal_pc');
		local buyerHandle = pcAppraise:GetUserIValue('HANDLE');
		if handle == buyerHandle then
			ui.CloseFrame('appraisal_pc');
		end
	end
		
end