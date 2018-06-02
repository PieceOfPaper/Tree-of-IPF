
function NECRONOMICON_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg("UPDATE_NECRONOMICON_UI", "NECRONOMICON_MSG");
	addon:RegisterMsg("DO_OPEN_NECRONOMICON_UI", "NECRONOMICON_MSG");
end

function NECRONOMICON_MSG(frame, msg, argStr, argNum)

	if msg == "UPDATE_NECRONOMICON_UI" then
		UPDATE_NECRONOMICON_UI(frame)		
	elseif msg == "DO_OPEN_NECRONOMICON_UI" then
		frame:ShowWindow(1);
	end
end

function SET_NECRO_CARD_STATE(frame, bosscardcls, i)
	local necoGbox = GET_CHILD(frame,'necoGbox',"ui::CGroupBox")
	if nil == necoGbox then
		return;
	end

	local descriptGbox = GET_CHILD(necoGbox,'descriptGbox',"ui::CGroupBox")
	if nil == descriptGbox then
		return;
	end

	local gbox = GET_CHILD(descriptGbox,'desc_name',"ui::CRichText")
	if nil ~= gbox then
		gbox:SetTextByKey("bossname",bosscardcls.Name);
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

	local skl = session.GetSkillByName('Necromancer_CreateShoggoth');

	if nil ~= skl then
		CLIENT_SORCERER_SUMMONING_MON(tempObj, GetMyPCObject(), GetIES(skl:GetObject()), bosscardcls);
	end

	-- 체력
	local myHp = GET_CHILD(descriptGbox,'desc_hp',"ui::CRichText")
	if nil ~= skl then
		local hp = math.floor(SCR_Get_MON_MHP(tempObj));
		myHp:SetTextByKey("value", hp);
	else
		myHp:SetTextByKey("value", 0);
	end

	-- 물리 공격력
	local richText = GET_CHILD(descriptGbox,'desc_fower',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", math.floor(tempObj.MAXPATK));
	else
		richText:SetTextByKey("value", 0);
	end

	-- 방어력
	richText = GET_CHILD(descriptGbox,'desc_defense',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", math.floor(tempObj.DEF));
	else
		richText:SetTextByKey("value", 0);
	end

	-- 힘
	richText = GET_CHILD(descriptGbox,'desc_Str',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "STR"));
	else
		richText:SetTextByKey("value", 0);
	end

	-- 체력
	richText = GET_CHILD(descriptGbox,'desc_Con',"ui::CRichText")

	if nil ~= skl then
	 -- 기본적으로 GET_MON_STAT을 쓰지만 체력은 따로해달라는 평직씨의 요청
		local con = math.floor(GET_MON_STAT_CON(tempObj, tempObj.Lv, "CON"));
		richText:SetTextByKey("value", con);
	else
		richText:SetTextByKey("value", 0);
	end

	-- 지능
	richText = GET_CHILD(descriptGbox,'desc_Int',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "INT"));
	else
		richText:SetTextByKey("value", 0);
	end

	-- 민첩
	richText = GET_CHILD(descriptGbox,'desc_Dex',"ui::CRichText")
	if nil ~= skl then
		richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "DEX"));
	else
		richText:SetTextByKey("value", 0);
	end

	-- 정신
	richText = GET_CHILD(descriptGbox,'desc_Mna',"ui::CRichText")
	if nil~= skl then
		richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "MNA"));
	else
		richText:SetTextByKey("value", 0);
	end

	-- 생성한 가상몹을 지워야져
	DestroyIES(tempObj);
end

function UPDATE_NECRONOMICON_UI(frame)
		
	local etc_pc = GetMyEtcObject();

	local MAX_CARD_COUNT = 4; -- 설마 이 숫자가 늘어나려나. 끼우는 카드 수. 1은 메인 카드.(소환) 2,3,4는 서브카드


	--데드파츠갯수 업데이트
	-- 네크로 파츠 1종
	local deadPartsCnt = etc_pc.Necro_DeadPartsCnt

	local deadpartsGbox = GET_CHILD(frame,'deadpartsGbox',"ui::CGroupBox")
	if nil == deadpartsGbox then
		return;
	end
	
	local part_gaugename = 'part_gauge1'
	local part_gauge = GET_CHILD(deadpartsGbox, part_gaugename,"ui::CGauge")
	part_gauge:SetPoint(deadPartsCnt,300) -- 기획 변경으로 100개 씩 3개있던걸 300개로 변경



	local gbox = GET_CHILD(frame,'necoGbox',"ui::CGroupBox")
	for i = 1, MAX_CARD_COUNT do
		local slotname = 'subboss'..i
		--local slottextname = 'subbosstext'..i
		local nowcard_classname = 'Necro_bosscard'..i
		local nowcard_guidname = 'Necro_bosscardGUID'..i;
		
		local bosscardid = etc_pc[nowcard_classname]
		local nowcard_guid = etc_pc[nowcard_guidname];

		local invitem = session.GetInvItemByGuid(nowcard_guid);
		if nil ~= invitem then
			local itemobj = GetIES(invitem:GetObject());
			print(itemobj.ClassName);
			local slotchild = GET_CHILD(gbox,slotname,"ui::CSlot");
			--local slotchild_text= GET_CHILD(gbox, slottextname,"ui::CRichText");
			if itemobj ~= nil then
				SET_SLOT_ICON(slotchild, itemobj.TooltipImage);		
				SET_ITEM_TOOLTIP_BY_OBJ(slotchild:GetIcon(), invitem);
				SET_NECRO_CARD_STATE(frame, itemobj, i);
				--slotchild_text:SetText(itemobj.Name)
			else
				SET_SLOT_ICON(slotchild, 'monster_card');			
			end
		end

		--slotchild_text:SetText('');
	end

	local necoGbox = GET_CHILD(frame,'necoGbox',"ui::CGroupBox")
	if nil == necoGbox then
		return;
	end

	local descriptGbox = GET_CHILD(necoGbox,'descriptGbox',"ui::CGroupBox")
	if nil == descriptGbox then
		return;
	end

	local desc_needparts = GET_CHILD(descriptGbox,'desc_needparts',"ui::CRichText")
	if nil ~= desc_needparts then
		desc_needparts:SetTextByKey("value", "30");
	end
	
	-- 네크로 파츠 1종
	local deadPartsCnt = etc_pc.Necro_DeadPartsCnt

	local gbox = GET_CHILD(frame,'deadpartsGbox',"ui::CGroupBox")
	if nil == gbox then
		return;
	end

	local part_gaugename = 'part_gauge1'
	local part_gauge = GET_CHILD(gbox, part_gaugename,"ui::CGauge")
	part_gauge:SetPoint(deadPartsCnt,300) -- 기획 변경으로 100개 씩 3개있던걸 300개로 변경

	
end

function NECRONOMICON_FRAME_OPEN(frame)
	UPDATE_NECRONOMICON_UI(frame)
end

function NECRONOMICON_FRAME_CLOSE(frame)
	
end

function NECRONOMICON_SLOT_DROP(frame, control, argStr, argNum) 

	local liftIcon 					= ui.GetLiftIcon();
	local iconParentFrame 			= liftIcon:GetTopParentFrame();
	local slot 						= tolua.cast(control, 'ui::CSlot');
	
	local iconInfo = liftIcon:GetInfo();
	local invenItemInfo = session.GetInvItem(iconInfo.ext);

	local tempobj = invenItemInfo:GetObject()
	local cardobj = GetIES(invenItemInfo:GetObject());

	if cardobj.GroupName ~= 'Card' then
		return 
	end

	session.ResetItemList();
	session.AddItemID(iconInfo:GetIESID());

	SET_NECRO_CARD_COMMIT(slot:GetName())

end


function SET_NECRO_CARD_COMMIT(slotname)

	local resultlist = session.GetItemIDList();

	local slotnumber = GET_NEC_SLOT_NUMBER(slotname)
	item.DialogTransaction("SET_NECRO_CARD", resultlist, slotnumber); -- 서버의 SCR_SET_CARD()가 호출된다.

end

function GET_NEC_SLOT_NUMBER(slotname)

	if slotname == 'subboss1' then
		return 1;
	elseif slotname == 'subboss2' then
		return 2;
	elseif slotname == 'subboss3' then
		return 3;
	elseif slotname == 'subboss4' then
		return 4;
	end

	return 0;

end

function SET_NECRO_CARD_ROTATE()
	
	local resultlist = session.GetItemIDList();
	item.DialogTransaction("SET_NECRO_CARD_ROTATE", resultlist);
end

