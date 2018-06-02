
function GRIMOIRE_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg("UPDATE_GRIMOIRE_UI", "GRIMOIRE_MSG");
	addon:RegisterMsg("DO_OPEN_GRIMOIRE_UI", "GRIMOIRE_MSG");
end

function GRIMOIRE_MSG(frame, msg, argStr, argNum)

	if msg == "UPDATE_GRIMOIRE_UI" then
		UPDATE_GRIMOIRE_UI(frame)		
	elseif msg == "DO_GRIMOIRE_UI" then
		frame:ShowWindow(1);
	end
end

function UPDATE_GRIMOIRE_UI(frame)

	local etc_pc = GetMyEtcObject();

	local MAX_CARD_COUNT = 2; 

	local gbox = GET_CHILD(frame,'grimoireGbox',"ui::CGroupBox")
	for i = 1, MAX_CARD_COUNT do
		local slotname = 'Sorcerer_bosscard'..i
		local nowcard_classname = 'Sorcerer_bosscardGUID'..i
		
		local bosscardid = etc_pc[nowcard_classname]
		local invitem = session.GetInvItemByGuid(bosscardid);
		if nil ~= invitem then
			local itemobj = GetIES(invitem:GetObject());
			local slotchild = GET_CHILD(gbox, slotname,"ui::CSlot");
			if itemobj ~= nil then
				SET_SLOT_ICON(slotchild, itemobj.TooltipImage);			
				SET_ITEM_TOOLTIP_BY_OBJ(slotchild:GetIcon(), invitem);
				SET_CARD_STATE(frame, itemobj, i);
			else
				SET_SLOT_ICON(slotchild, 'test_card_slot_point');			
			end
		end
		
	end
end

function SET_CARD_STATE(frame, bosscardcls, i)
	local grimoireGbox = GET_CHILD(frame,'grimoireGbox',"ui::CGroupBox")
	if nil == grimoireGbox then
		return;
	end
	local descriptGbox = GET_CHILD(grimoireGbox,'descriptGbox',"ui::CGroupBox")
	if nil == descriptGbox then
		return;
	end

	if 1 == i then -- 메인카드
		local gbox = GET_CHILD(descriptGbox,'my_card',"ui::CRichText")
		if nil ~= gbox then
			gbox:SetTextByKey("actorcard",bosscardcls.Name);
		end
	else
		local gbox = GET_CHILD(descriptGbox,'my_assist_card',"ui::CRichText")
		if nil ~= gbox then
			gbox:SetTextByKey("actorassistcard",bosscardcls.Name);
		end
	end

	local bossMonID = bosscardcls.NumberArg1;
	local monCls = GetClassByType("Monster", bossMonID);
	if nil == monCls then
		return;
	end

	-- 가상몹을 생성합시다.
	local tempObj = CreateGCIES("Monster", monCls.ClassName);
	if nil == tempObj then
		return;
	end

	local skl = session.GetSkillByName('Sorcerer_Summoning');
	if nil ~= skl then
		CLIENT_SORCERER_SUMMONING_MON(tempObj, GetMyPCObject(), GetIES(skl:GetObject()), bosscardcls);
	end

	-- 체력
	local myHp = GET_CHILD(descriptGbox,'my_hp',"ui::CRichText")
	if nil ~= skl then
		local hp = math.floor(SCR_Get_MON_MHP(tempObj));
		myHp:SetTextByKey("value", hp);
	else
		myHp:SetTextByKey("value", 0);
	end
	
	-- 물리 공격력
	local richText = GET_CHILD(descriptGbox,'my_attack',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", math.floor(tempObj.MAXPATK));
	else
		richText:SetTextByKey("value", 0);
	end

	-- 마법 공격력
	richText = GET_CHILD(descriptGbox,'my_Mattack',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", math.floor(tempObj.MAXMATK));
	else
		richText:SetTextByKey("value", 0);
	end

	-- 방어력
	richText = GET_CHILD(descriptGbox,'my_defen',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", math.floor(tempObj.DEF));
	else
		richText:SetTextByKey("value", 0);
	end

	-- 마법 방어력
	richText = GET_CHILD(descriptGbox,'my_Mdefen',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", math.floor(tempObj.MDEF));
	else
		richText:SetTextByKey("value", 0);
	end

	------- 스텟정보

	-- 힘
	richText = GET_CHILD(descriptGbox,'my_power',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "STR"));
	else
		richText:SetTextByKey("value", 0);
	end

	-- 체력
	richText = GET_CHILD(descriptGbox,'my_con',"ui::CRichText")
	 -- 기본적으로 GET_MON_STAT을 쓰지만 체력은 따로해달라는 평직씨의 요청
	 if nil ~= skl then
		local con = math.floor(GET_MON_STAT_CON(tempObj, tempObj.Lv, "CON"));
		richText:SetTextByKey("value", con);
	else
		richText:SetTextByKey("value", 0);
	end

	-- 지능
	richText = GET_CHILD(descriptGbox,'my_int',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "INT"));
	else
		richText:SetTextByKey("value", 0);
	end

	-- 민첩
	richText = GET_CHILD(descriptGbox,'my_dex',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "DEX"));
	else
		richText:SetTextByKey("value", 0);
	end

	-- 정신
	richText = GET_CHILD(descriptGbox,'my_mna',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "MNA"));
	else
		richText:SetTextByKey("value", 0);
	end

	-- 생성한 가상몹을 지워야져
	DestroyIES(tempObj);
end

function GRIMOIRE_SLOT_DROP(frame, control, argStr, argNum) 
	local liftIcon 			= ui.GetLiftIcon();
	local iconParentFrame 	= liftIcon:GetTopParentFrame();
	local slot 			    = tolua.cast(control, 'ui::CSlot');
	local iconInfo			= liftIcon:GetInfo();
	local invenItemInfo = session.GetInvItem(iconInfo.ext);

	if nil == invenItemInfo then
		return;
	end

	local tempobj = invenItemInfo:GetObject()
	local cardobj = GetIES(invenItemInfo:GetObject());

	if cardobj.GroupName ~= 'Card' then
		return 
	end

	session.ResetItemList();
	session.AddItemID(iconInfo:GetIESID());

	SET_GRI_CARD_COMMIT(slot:GetName())

end

function SET_GRI_CARD_COMMIT(slotname)

	local resultlist = session.GetItemIDList();
	local slotnumber = GET_GRI_SLOT_NUMBER(slotname)	
	item.DialogTransaction("SET_SORCERER_CARD", resultlist, slotnumber);

end

function GET_GRI_SLOT_NUMBER(slotname)
	if slotname == 'Sorcerer_bosscard1' then
		return 1;
	elseif slotname == 'Sorcerer_bosscard2' then
		return 2;
	end

	return 0;
end

function GRIMOIRE_FRAME_OPEN(frame)
	UPDATE_GRIMOIRE_UI(frame)
end

function GRIMOIRE_FRAME_CLOSE(frame)
end
