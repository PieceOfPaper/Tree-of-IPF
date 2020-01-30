function REWARDLIST_OPEN(frame)
end

function REWARDLIST_CLOSE(frame)
end

function WEEKLYBOSS_REWARD_LIST_SHOW(itemID, rewardtype)
	local packageName = GET_PACKAGE_ITEM_NAME(itemID);	
	if packageName == 'None' then
		return;
	end

	local frame = ui.GetFrame('rewardlist');
	WEEKLY_BOSS_PACKAGELIST_INIT(frame, itemID, packageName, rewardtype)
	frame:ShowWindow(1);
end

function WEEKLY_BOSS_PACKAGELIST_INIT(frame, itemID, packageName, rewardtype)
	
	local itemCls = GetClassByType('Item', itemID);
	local itemIconPic = GET_CHILD_RECURSIVELY(frame, 'itemIconPic');
	itemIconPic:SetImage(itemCls.Icon);

	local itemNameText = GET_CHILD_RECURSIVELY(frame, 'itemNameText');
	itemNameText:SetText(itemCls.Name);

	local btn_ok = GET_CHILD_RECURSIVELY(frame, 'btn_ok');
	local btn_reward = GET_CHILD_RECURSIVELY(frame, 'btn_reward');
	if rewardtype ~= "" and rewardtype ~= nil then
		-- 계열 순위 보상, 누적 대미지 보상 버튼에서 출력
        btn_ok:SetGravity(ui.LEFT, ui.CENTER_VERT);
        btn_reward:SetGravity(ui.RIGHT, ui.CENTER_VERT);
		btn_reward:ShowWindow(1);

        btn_reward:SetEventScript(ui.LBUTTONUP, 'WEEKLY_BOSS_REWARD_BUTTON_CLICK')
        btn_reward:SetEventScriptArgString(ui.LBUTTONUP, rewardtype);
        btn_reward:SetEventScriptArgNumber(ui.LBUTTONUP, itemCls.ClassID);
	else
		-- 보상 목록에서 출력
        btn_ok:SetGravity(ui.CENTER_HORZ, ui.CENTER_VERT);
		btn_reward:ShowWindow(0);
	end

	WEEKLY_BOSS_PACKAGELIST_INIT_ITEMLIST(frame, itemCls, packageName);
end

-- 아이템 패키지 목록
function WEEKLY_BOSS_PACKAGELIST_INIT_ITEMLIST(frame, itemCls, packageName)
	local itemListBox = GET_CHILD_RECURSIVELY(frame, 'itemListBox');
	itemListBox:RemoveAllChild();

	local tpitem = ui.GetFrame('tpitem');
	local infoMap = GET_PACKAGE_CACHE_MAP();
	local packageList = infoMap[packageName];
	for i = 1, #packageList do
		local packageItemCls = GetClass('Item', packageList[i].ItemName);
		local ctrlset = itemListBox:CreateOrGetControlSet('packagelist_item', 'ITEM_'..packageItemCls.ClassName, 0, 0);
		local itemSlot = GET_CHILD(ctrlset, 'itemSlot');
		local icon = CreateIcon(itemSlot);
		
		local iconName = GET_ITEM_ICON_IMAGE(packageItemCls);
		icon:SetImage(iconName);
		SET_ITEM_TOOLTIP_BY_NAME(icon, packageItemCls.ClassName);

		local nameText = GET_CHILD(ctrlset, 'nameText');
		local name = packageItemCls.Name
		if string.len(name) >= 63 then
			name = string.sub(name,1,60)
			name = name.."..."
		end
		nameText:SetText(name);

		local typeText = GET_CHILD(ctrlset, 'typeText');
		if packageList[i].EquipType == "None" then
			typeText:SetText("");
		else
			typeText:SetText(GET_REQ_TOOLTIP(packageItemCls));
		end
	
		local previewBtn = GET_CHILD(ctrlset, 'previewBtn');
		previewBtn:ShowWindow(0);
	end
	GBOX_AUTO_ALIGN(itemListBox, 0, -5, 0, true, false, false);
end

function WEEKLYBOSS_MY_REWARD_LIST_SHOW(week_num, rewardtype)
	local frame = ui.GetFrame('rewardlist');
	local rewardstr = "";
	if rewardtype == 'rank' then
		local myrank = session.weeklyboss.GetMyRankInfo(week_num);
		rewardstr = session.weeklyboss.GetRankingRewardToString(week_num, myrank);
	elseif rewardtype == 'damage' then
		local accumulateDamage = session.weeklyboss.GetWeeklyBossAccumulatedDamage(week_num);
		rewardstr = session.weeklyboss.GetAbsolutedRewardToString(week_num, accumulateDamage);		
	end
	rewardstr = 'Gacha_HairAcc_001'; -- 임시

    local rewardlist = StringSplit(rewardstr, "/")
    local itemcls = GetClass("Item", rewardlist[1])
    if itemcls == nil then
        return;
	end
	
	WEEKLYBOSS_REWARD_LIST_SHOW(itemcls.ClassID, rewardtype);
end

-- 보상 받기 버튼 클릭
function WEEKLY_BOSS_REWARD_BUTTON_CLICK(frame, ctrl, argStr, argNum)
	local page_num = WEEKLY_BOSS_RANK_WEEKNUM_NUMBER();
    local week_num = session.weeklyboss.GetNowWeekNum() - page_num + 1;

	if argStr == 'rank' then
		local myrank = session.weeklyboss.GetMyRankInfo(week_num);
		weekly_boss.RequestAccpetRankingReward(week_num, myrank);
	elseif argStr == 'damage' then
		local accumulateDamage = session.weeklyboss.GetWeeklyBossAccumulatedDamage(week_num);   -- 누적 대미지
		weekly_boss.RequestAcceptAbsoluteReward(week_num, accumulateDamage);
	end
end