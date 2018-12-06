
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

function NECRONOMICON_STATE_UI_RESET(frame, i)
	if 1 ~= i then
		return;
	end

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
		gbox:SetTextByKey("bossname", "");
	end
	
	NECRONOMICON_STATE_TEXT_RESET(descriptGbox)
end

function NECRONOMICON_STATE_TEXT_RESET(descriptGbox)
	-- 체력
	local myHp = GET_CHILD(descriptGbox,'desc_hp',"ui::CRichText")
	myHp:SetTextByKey("value", 0);

	-- 물리 공격력
	local richText = GET_CHILD(descriptGbox,'desc_fower',"ui::CRichText")
	richText:SetTextByKey("value", 0);

	-- 방어력
	richText = GET_CHILD(descriptGbox,'desc_defense',"ui::CRichText")
	richText:SetTextByKey("value", 0);

	-- 힘
	richText = GET_CHILD(descriptGbox,'desc_Str',"ui::CRichText")
	richText:SetTextByKey("value", 0);
	
	-- 체력
	richText = GET_CHILD(descriptGbox,'desc_Con',"ui::CRichText")
	richText:SetTextByKey("value", 0);
	
	-- 지능
	richText = GET_CHILD(descriptGbox,'desc_Int',"ui::CRichText")
	richText:SetTextByKey("value", 0);
	
	-- 민첩
	richText = GET_CHILD(descriptGbox,'desc_Dex',"ui::CRichText")
	richText:SetTextByKey("value", 0);
	
	-- 정신
	richText = GET_CHILD(descriptGbox,'desc_Mna',"ui::CRichText")
	richText:SetTextByKey("value", 0);
end

function SET_NECRO_CARD_STATE(frame, bosscardcls, i)
	if 1 ~= i then
		return;
	end
	
	local necoGbox = GET_CHILD(frame,'necoGbox',"ui::CGroupBox")
	if nil == necoGbox then
		return;
	end

	local descriptGbox = GET_CHILD(necoGbox,'descriptGbox',"ui::CGroupBox")
	if nil == descriptGbox then
		return;
	end

	NECRONOMICON_STATE_TEXT_RESET(descriptGbox);

	local gbox = GET_CHILD(descriptGbox,'desc_name',"ui::CRichText")
	if nil ~= gbox then
		gbox:SetTextByKey("bossname",bosscardcls.Name);
	end

	local skl = session.GetSkillByName('Necromancer_CreateShoggoth');
	if nil == skl then
		return;
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

	CLIENT_SORCERER_SUMMONING_MON(tempObj, GetMyPCObject(), GetIES(skl:GetObject()), bosscardcls);
	
	-- 체력
	local myHp = GET_CHILD(descriptGbox,'desc_hp',"ui::CRichText")
	local hp = math.floor(SCR_Get_MON_MHP(tempObj));
	myHp:SetTextByKey("value", hp);

	-- 물리 공격력
	local richText = GET_CHILD(descriptGbox,'desc_fower',"ui::CRichText")
	richText:SetTextByKey("value", math.floor(SCR_Get_MON_MAXPATK(tempObj)));

	-- 방어력
	richText = GET_CHILD(descriptGbox,'desc_defense',"ui::CRichText")
	richText:SetTextByKey("value", math.floor(SCR_Get_MON_DEF(tempObj)));

	-- 힘
	richText = GET_CHILD(descriptGbox,'desc_Str',"ui::CRichText")
	richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "STR"));

	-- 체력
	richText = GET_CHILD(descriptGbox,'desc_Con',"ui::CRichText")
	 -- 기본적으로 GET_MON_STAT을 쓰지만 체력은 따로해달라는 평직씨의 요청
	local con = math.floor(GET_MON_STAT(tempObj, tempObj.Lv, "CON"));
	richText:SetTextByKey("value", con);

	-- 지능
	richText = GET_CHILD(descriptGbox,'desc_Int',"ui::CRichText")
	richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "INT"));

	-- 민첩
	richText = GET_CHILD(descriptGbox,'desc_Dex',"ui::CRichText")
	richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "DEX"));

	-- 정신
	richText = GET_CHILD(descriptGbox,'desc_Mna',"ui::CRichText")
	richText:SetTextByKey("value", GET_MON_STAT(tempObj, tempObj.Lv, "MNA"));
	
	-- 생성한 가상몹을 지워야져
	DestroyIES(tempObj);
end

function UPDATE_NECRONOMICON_UI(frame)
		
	local etc_pc = GetMyEtcObject();

	local MAX_CARD_COUNT = 4; -- 설마 이 숫자가 늘어나려나. 끼우는 카드 수. 1은 메인 카드.(소환) 2,3,4는 서브카드

	--데드파츠개수 업데이트
	-- 네크로 파츠 1종
	local deadPartsCnt = etc_pc.Necro_DeadPartsCnt

	local deadpartsGbox = GET_CHILD(frame,'deadpartsGbox',"ui::CGroupBox")
	if nil == deadpartsGbox then
		return;
	end
	
	local part_gaugename = 'part_gauge1'
	local part_gauge = GET_CHILD(deadpartsGbox, part_gaugename,"ui::CGauge")
	local totalCount = GET_NECRONOMICON_TOTAL_COUNT();	
	part_gauge:SetPoint(deadPartsCnt, totalCount) -- 기획 변경으로 100개 씩 3개있던걸 300개로 변경


	local gbox = GET_CHILD(frame,'necoGbox',"ui::CGroupBox")
	for i = 1, MAX_CARD_COUNT do
		local slotname = 'subboss'..i
		--local slottextname = 'subbosstext'..i
		local nowcard_classname = 'Necro_bosscard'..i
		local nowcard_guidname = 'Necro_bosscardGUID'..i;
		
		local bosscardid = etc_pc[nowcard_classname]
		local nowcard_guid = etc_pc[nowcard_guidname];
		local slotchild = GET_CHILD(gbox, slotname,"ui::CSlot");
		local invitem = nil;
		if "None" ~= nowcard_guid then
			invitem = session.GetInvItemByGuid(nowcard_guid);
		end

		if nil ~= invitem then
			local itemobj = GetIES(invitem:GetObject());
			if itemobj ~= nil then
				SET_SLOT_ICON(slotchild, itemobj.TooltipImage);		
				SET_ITEM_TOOLTIP_BY_OBJ(slotchild:GetIcon(), invitem);
				SET_NECRO_CARD_STATE(frame, itemobj, i);
			else
				SET_SLOT_ICON(slotchild, 'bg2');			
			end

			local icon = slotchild:GetIcon();
			if nil ~= icon then
				icon:SetIESID(invitem:GetIESID());
			end
		else
			slotchild:ClearIcon();
			NECRONOMICON_STATE_UI_RESET(frame, i)
		end
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

    local showHUDGauge = config.GetXMLConfig('NecronomiconHUD');
    local hudCheck = GET_CHILD_RECURSIVELY(frame, 'hudCheck');
    hudCheck:SetCheck(showHUDGauge);
end

function NECRONOMICON_FRAME_OPEN(frame)
	UPDATE_NECRONOMICON_UI(frame)
end

function NECRONOMICON_FRAME_CLOSE(frame)
	
end

function NECRONOMICON_SLOT_RESET(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local slot = tolua.cast(ctrl, "ui::CSlot");
	local icon, iconInfo, itemIES = nil, nil, nil;
	icon = slot:GetIcon();
	if nil ~= icon then
		 iconInfo = icon:GetInfo();
	end

	if nil ~= iconInfo then
		itemIES = iconInfo:GetIESID();
	end
	session.ResetItemList();
	if nil~= itemIES then
		session.AddItemID(itemIES);
	end
	SET_NECRO_CARD_COMMIT(slot:GetName(),"UnEquip")
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
		ui.SysMsg(ClMsg("PutOnlyCardItem"));
		return 
	end

	local cardItemCls = GetClassByType("Item", cardobj.ClassID);
	if nil == cardItemCls then
		ui.SysMsg(ClMsg("PutOnlyCardItem"));
		return;
	end

	local monCls = GetClassByType("Monster", cardItemCls.NumberArg1);
	if monCls == nil then
		ui.SysMsg(ClMsg("CheckCardType"));
		return;
	end

	if monCls.RaceType == 'Velnias' or monCls.RaceType == 'Klaida' then
		ui.SysMsg(ClMsg("CheckCardType"));
		return;
	end

	local MAX_CARD_COUNT = 4;
	local etc_pc = GetMyEtcObject();
	local itemIES = GetIESID(cardobj);
	for i = 1, MAX_CARD_COUNT do
		local bosscardslotname = 'Necro_bosscardGUID'..i
		if etc_pc[bosscardslotname] == itemIES then
			ui.SysMsg(ClMsg("AlreadRegSameCard"));
			return;
		end
	end

	session.ResetItemList();
	session.AddItemID(iconInfo:GetIESID());

	SET_NECRO_CARD_COMMIT(slot:GetName(), "Equip")

end


function SET_NECRO_CARD_COMMIT(slotname, type)

	local resultlist = session.GetItemIDList();

	local slotnumber = GET_NEC_SLOT_NUMBER(slotname)

	local iType = 1;
	if "UnEquip" == type then
		iType = 0;
	end

	local argStr = string.format("%s %s", tostring(slotnumber), iType);
	item.DialogTransaction("SET_NECRO_CARD", resultlist, argStr); -- 서버의 SCR_SET_CARD()가 호출된다.

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

function UI_CHECK_NECRO_UI_OPEN(propname, propvalue)
	local jobcls = GetClass("Job", 'Char2_9');
	local jobid = jobcls.ClassID

	if IS_HAD_JOB(jobid) == true then
		return 1
	end

	return 0;
end

function NECRONOMICON_HUD_CONFIG_CHANGE()
    local hudShow = NECRONOMICON_HUD_CHECK_VISIBLE();
    if hudShow == true then
        local hudFrame = ui.GetFrame('necronomicon_hud');
        NECRONOMICON_HUD_SET_SAVED_OFFSET(hudFrame);
    end
end