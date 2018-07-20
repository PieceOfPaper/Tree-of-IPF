-- rankreset


function RANKRESET_ON_INIT(addon, frame)
	addon:RegisterOpenOnlyMsg('EQUIP_ITEM_LIST_GET', 'RANKRESET_PC_EQUIP_STATE');
	addon:RegisterOpenOnlyMsg('RESET_ABILITY_UP', 'RANKRESET_PC_ABILITY_STATE');
	addon:RegisterOpenOnlyMsg('AUTOSELLER_UPDATE', 'RANKRESET_PC_AUTOSELLER_STATE'); 
end

function RANKRESET_ITEM_USE(invItem)
	if invItem.isLockState then 
		return;
	end

	local invframe = ui.GetFrame("inventory");
	if true == IS_TEMP_LOCK(invframe, invItem) then
		return false;
	end

	local obj = GetIES(invItem:GetObject());
	if obj.ItemLifeTimeOver > 0 then
		ui.SysMsg(ScpArgMsg('LessThanItemLifeTime'));
		return;
	end

    local obj = GetIES(invItem:GetObject());
    if obj.ClassName == '1706Event_RankReset' then
        if session.GetPcTotalJobGrade() > 6 then
          ui.SysMsg(ScpArgMsg('CantUseRankRest6Rank'));
          return
        end
    end
    
	local frame = ui.GetFrame("rankreset");
	frame:ShowWindow(1)
	frame:SetUserValue("itemIES", invItem:GetIESID());


	RANKRESET_CHECK_PLAYER_STATE(frame);
end

function RANKRESET_CHECK_PLAYER_STATE(frame)

	RANKRESET_PC_EQUIP_STATE(frame);
	RANKRESET_PC_ABILITY_STATE(frame);
	RANKRESET_PC_WITH_COMMPANION(frame);
	RANKRESET_PC_LOCATE(frame);
	RANKRESET_PC_AUTOSELLER_STATE(frame);
	RANKRESET_PC_TIMEACTION_STATE(frame);
    RANKRESET_PC_UNIQUE_TEMPLER_GUILD_MASTER_STATE(frame);
end

function RANKRESET_PC_TIMEACTION_STATE(frame)
	local timeActionFrame = ui.GetFrame("timeaction");
	local actor = GetMyActor();	
	local nonstate = true;
	if 1 == actor:HasCmd("TIME_ACTION_ANIM_CMD") or timeActionFrame:IsVisible() == 1 then
		nonstate = false;
	end

	local invframe = ui.GetFrame("inventory");
	if invframe:GetUserValue('ITEM_GUID_IN_MORU') ~= 'None'
		or 'None' ~= invframe:GetUserValue("ITEM_GUID_IN_TRANSCEND")
		or 'None' ~= invframe:GetUserValue("ITEM_GUID_IN_TRANSCEND_SCROLL") then
		nonstate = false;
	end

	local timeaction = GET_CHILD(frame, 'timeaction_check', "ui::CCheckBox");
	if nonstate == true then
		timeaction:SetCheck(1);
	else
		timeaction:SetCheck(0);
	end
end

function RANKRESET_PC_AUTOSELLER_STATE(frame)
	local nonstate = true;
	for i = 0, AUTO_SELL_COUNT-1 do
	-- ���ϳ��� true��
		if session.autoSeller.GetMyAutoSellerShopState(i) == true then
			nonstate = false;
			break;
		end
	end

	local shop_check = GET_CHILD(frame, 'shop_check', "ui::CCheckBox");
	if nonstate == true then
		shop_check:SetCheck(1);
	else
		shop_check:SetCheck(0);
	end
end

function RANKRESET_PC_LOCATE(frame)
	local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);
	local home_check = GET_CHILD(frame, 'home_check', "ui::CCheckBox");
    if mapCls == nil or mapCls.MapType ~= "City" then
        home_check:SetCheck(0);
	else
		home_check:SetCheck(1);
    end
        
end

function RANKRESET_PC_WITH_COMMPANION(frame)
	local summonedPet = GET_SUMMONED_PET();
	local com_check = GET_CHILD(frame, 'com_check', "ui::CCheckBox");
	if summonedPet == nil then
		com_check:SetCheck(1);
	else
		com_check:SetCheck(0);
	end
end

function RANKRESET_PC_EQUIP_STATE(frame)
	local equipList = session.GetEquipItemList();
	local unEquip = false;
	for i = 0, equipList:Count() - 1 do
		local equipItem = equipList:Element(i);
		local spotName = item.GetEquipSpotName(equipItem.equipSpot);	
		if  equipItem.type  ~=  item.GetNoneItem(equipItem.equipSpot)  then
			unEquip = true;
			break;
		end
	end

	local armor_check = GET_CHILD(frame, 'armor_check', "ui::CCheckBox");
	if false == unEquip then
		armor_check:SetCheck(1);
	else
		armor_check:SetCheck(0);
	end
end

function RANKRESET_PC_ABILITY_STATE(frame)
	local pc = GetMyPCObject();
	local runAbil = false;
	for i = 0, RUN_ABIL_MAX_COUNT do
		local prop = "None";
		if 0 == i then
			prop = "LearnAbilityID";
		else
			prop = "LearnAbilityID_" ..i;
		end
		if pc[prop] ~= nil and pc[prop] > 0 then
			runAbil = true;
			break;
		end
	end

	local ability_check = GET_CHILD(frame, 'ability_check', "ui::CCheckBox");
	if false == runAbil then
		ability_check:SetCheck(1);
	else
		ability_check:SetCheck(0);
	end
end

function RANKRESET_ITEM_USE_BUTTON_CLICK(frame, ctrl)
	local gradeRank = session.GetPcTotalJobGrade();
	if gradeRank <= 1 then
		ui.SysMsg(ScpArgMsg("CantUseRankRest1Rank"));
	    return;
	end
	
    local mapprop = session.GetCurrentMapProp();
	local mapCls = GetClassByType("Map", mapprop.type);
    if mapCls == nil or mapCls.MapType ~= "City" then
        ui.SysMsg(ClMsg("AllowedInTown"));
        return;
    end
     
    if CHECK_INVENTORY_HAS_RANK_CARD() == true then
        ui.MsgBox_NonNested(ClMsg('YouHaveRankCardReallyRankReset?'), 0x00000000, frame:GetName(), 'None', 'None');
        return;
    end

    if IS_UNIQUE_TEMPLER_GUILD_MASTER_C() == true then
        ui.SysMsg(ClMsg('CannotRankResetBecauseUniqueTemplerMaster'));
        return;
    end
    
    local templerCls = GetClass('Job', 'Char1_16');    
    if AM_I_LEADER(PARTY_GUILD) == 1 and IS_EXIST_JOB_IN_HISTORY(templerCls.ClassID) == true then
        local yesscp = string.format("RANKRESET_REQUEST_RANK_RESET()");
        ui.MsgBox(ClMsg('YouMustUpdateTowerLevel'), yesscp, 'None');
        return;
    end

    RANKRESET_REQUEST_RANK_RESET();
end

function CHECK_INVENTORY_HAS_RANK_CARD()
    -- n랭크 카드
    for i = 2, JOB_CHANGE_MAX_RANK do
        local rankCardName = 'jexpCard_UpRank'..i;
        if session.GetInvItemByName(rankCardName) ~= nil then
            return true;
        end
    end
    
    -- 클래스 경험치 복구 카드
    if session.GetInvItemByName('jexpCard_RestoreLastRank') ~= nil then
        return true;
    end

    return false;
end

function RANKRESET_REQUEST_RANK_RESET()
    local frame = ui.GetFrame('rankreset');
    local itemIES = frame:GetUserValue("itemIES");
	packet.RankResetItemUse(itemIES);
end

function RANKRESET_CANCEL_BUTTON_CLICK(frame, ctrl)
	frame = frame:GetTopParentFrame();
	frame:SetUserValue("itemIES", 'None');
	frame:ShowWindow(0);
end

function RANKRESET_DELETE_RANK_CARD(className)
    local deleteItem = session.GetInvItemByName(className);
    if deleteItem == nil then
        return;
    end
    local deleteItemCls = GetClass('Item', className);
    if deleteItemCls == nil then
        return;
    end
    local yesScp = string.format('control.CustomCommand("TAKE_ITEM", %d)', deleteItemCls.ClassID);

    ui.MsgBox(ClMsg('DeleteCardBecauseYourRankTooHigh'), yesScp, 'None');
end

function IS_UNIQUE_TEMPLER_GUILD_MASTER_C()
    if AM_I_LEADER(PARTY_GUILD) == 1 then
        local templerCls = GetClass('Job', 'Char1_16');
        if IS_EXIST_JOB_IN_HISTORY(templerCls.ClassID) == true then
            local myHandle = session.GetMyHandle();
            local myName = info.GetName(myHandle);
            local charList = GetCharacterNameList();
            for i = 1, #charList do
                local charName = charList[i];
                if charName ~= myName then                
                    local jobString = GetCharacterJobHistoryString(nil, charName);                    
                    local jobList = StringSplit(jobString, ';');
                    for j = 1, #jobList do                    
                        if jobList[j] == 'Char1_16' then                        
                            return false;
                        end
                    end
                end
            end
            return true;
        end
    end
    return false;
end

function RANKRESET_PC_UNIQUE_TEMPLER_GUILD_MASTER_STATE(frame)
    local enable = 1;
    if IS_UNIQUE_TEMPLER_GUILD_MASTER_C() == true then
        enable = 0;
    end    
    local master_check = GET_CHILD(frame, 'master_check');
    master_check:SetCheck(enable);
end