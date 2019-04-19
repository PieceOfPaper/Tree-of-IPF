-- itembuffopen.lua

function ITEMBUFFOPEN_ON_INIT(addon, frame)
end

function SQIORE_SLOT_POP(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	SQUTE_UI_RESET(frame);
end

local function _GET_SOCKET_ADD_VALUE(item, invItem, i)    
	
    if invItem:IsAvailableSocket(i) == false then
        return;
	end
	
	local gem = invItem:GetEquipGemID(i);
    if gem == 0 then
        return;
    end
    
	local gemExp = invItem:GetEquipGemExp(i);
	local roastingLv = invItem:GetEquipGemRoastingLv(i);
    local props = {};
    local gemclass = GetClassByType("Item", gem);
    local lv = GET_ITEM_LEVEL_EXP(gemclass, gemExp);
    local prop = geItemTable.GetProp(gem);
    local socketProp = prop:GetSocketPropertyByLevel(lv);
    local type = item.ClassID;
    local benefitCnt = socketProp:GetPropCountByType(type);
    for i = 0 , benefitCnt - 1 do
        local benefitProp = socketProp:GetPropAddByType(type, i);
        props[#props + 1] = {benefitProp:GetPropName(), benefitProp.value}
    end
    
    local penaltyCnt = socketProp:GetPropPenaltyCountByType(type);
    local penaltyLv = lv - roastingLv;
    if 0 > penaltyLv then
        penaltyLv = 0;
    end
    local socketPenaltyProp = prop:GetSocketPropertyByLevel(penaltyLv);
    for i = 0 , penaltyCnt - 1 do
        local penaltyProp = socketPenaltyProp:GetPropPenaltyAddByType(type, i);
        local value = penaltyProp.value
        penaltyProp:GetPropName()
        props[#props + 1] = {penaltyProp:GetPropName(), penaltyProp.value}
    end
    return props;
end

local function _GET_ITEM_SOCKET_ADD_VALUE(targetPropName, item)
	local invItem, where = GET_INV_ITEM_BY_ITEM_OBJ(item);

    local value = 0;
    local sockets = {};
    if item.MaxSocket > 100 then item.MaxSocket = 0 end
    for i=0, item.MaxSocket - 1 do
        sockets[#sockets + 1] = _GET_SOCKET_ADD_VALUE(item, invItem, i);
    end

    for i = 1, #sockets do
        local props = sockets[i];
        for j = 1, #props do
            local prop = props[j]
            if prop[1] == targetPropName then                
                value = value + prop[2];
            end
        end
    end
    return value;
end

function SQIORE_SLOT_DROP(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	local liftIcon = ui.GetLiftIcon();
	local slot = tolua.cast(ctrl, 'ui::CSlot');
	local iconInfo = liftIcon:GetInfo();
	local invItem = GET_PC_ITEM_BY_GUID(iconInfo:GetIESID());
	
	if nil == invItem then
		return;
	end

	if iconInfo == nil or invItem == nil or slot == nil then
		return;
	end

	local pc = GetMyPCObject();
	local obj = GetIES(invItem:GetObject());

	if obj.Dur <= 0 then
		ui.SysMsg(ClMsg("DurUnder0"));
		return;
	end

	local checkItem = _G["ITEMBUFF_CHECK_" .. frame:GetUserValue("SKILLNAME")];
	if 1 ~= checkItem(pc, obj) then
		ui.SysMsg(ClMsg("WrongDropItem"));
		return;
	end
	
	local checkFunc = _G["ITEMBUFF_NEEDITEM_" .. frame:GetUserValue("SKILLNAME")];
	local name, cnt = checkFunc(pc, obj);

	-- 이미지를 넣고
	SET_SLOT_ITEM_IMAGE(slot, invItem);
	
	local repairbox = frame:GetChild("repair");
	local slotNametext = repairbox:GetChild("slotName");
	-- 이름과 강화 수치를 표시한다.
	slotNametext:SetTextByKey("txt", obj.Name);

	local skillLevel = frame:GetUserIValue("SKILLLEVEL");
	local valueFunc = _G["ITEMBUFF_VALUE_" .. frame:GetUserValue("SKILLNAME")];
	local value, validSec = valueFunc(pc, obj, skillLevel);
	local nextObj = CloneIES(obj);
	nextObj.BuffValue = value;
	local refreshScp = nextObj.RefreshScp;
	if refreshScp ~= "None" then
		refreshScp = _G[refreshScp];
		refreshScp(nextObj);
	end	

	-- 효과를 표시한다.
	local nameList, fromList, toList = ExtractDiffProperty(obj, nextObj);
	local effectBox = repairbox:GetChild("effectGbox");
	local timestr = effectBox:GetChild("timestr");
	timestr:SetTextByKey("txt", string.format("{img %s %d %d}", "squaier_buff", 25, 25) .." ".. validSec/3600 .. ClMsg("QuestReenterTimeH"));

    local basicPropBox = GET_CHILD_RECURSIVELY(frame, 'basicPropBox');
    basicPropBox:RemoveAllChild();
    local basicPropList = StringSplit(obj.BasicTooltipProp, ';');
    for i = 1 , #basicPropList do
        local basicTooltipProp = basicPropList[i];
        local propertyCtrl = basicPropBox:CreateOrGetControlSet('basic_property_set', 'BASIC_PROP_'..i, 20, 0);

	    -- 최대, 최소를 작성하고자 해당 항목의 속성을 가지고 옵니다.
	    local mintextStr = propertyCtrl:GetChild("minPowerStr");
	    local maxtextStr = propertyCtrl:GetChild("maxPowerStr");
        local maxtext = propertyCtrl:GetChild("maxPower");
	    local mintext = propertyCtrl:GetChild("minPower");
	
	    local prop1, prop2 = GET_ITEM_PROPERT_STR(obj, basicTooltipProp);

        if  basicTooltipProp ~= "ATK" then
            local temp = prop1;
            prop1 = prop2;
            prop2 = temp;
        end

	    maxtextStr:SetTextByKey("txt", prop1);
	    mintextStr:SetTextByKey("txt", prop2);

	    if obj.GroupName == "Weapon" or obj.GroupName == "SubWeapon" then
		    if basicTooltipProp == "ATK" then -- 최대, 최소 공격력
			    maxtext:SetTextByKey("txt", obj.MAXATK .." > ".. nextObj.MAXATK);
			    mintext:SetTextByKey("txt", obj.MINATK .." > ".. nextObj.MINATK);
			elseif basicTooltipProp == "MATK" then -- 마법공격력
				local socketaddvalue =  _GET_ITEM_SOCKET_ADD_VALUE(basicTooltipProp, obj)
			    mintext:SetTextByKey("txt", obj.MATK - socketaddvalue .." > ".. nextObj.MATK + socketaddvalue);
			    maxtext:SetTextByKey("txt", "");
                propertyCtrl:Resize(propertyCtrl:GetWidth(), mintext:GetHeight());
		    end
	    else
		    if basicTooltipProp == "DEF" then -- 방어
			    mintext:SetTextByKey("txt", obj.DEF .." > ".. nextObj.DEF);
		    elseif basicTooltipProp == "MDEF" then -- 악세사리
			    mintext:SetTextByKey("txt", obj.MDEF .." > ".. nextObj.MDEF);
		    elseif  basicTooltipProp == "HR" then -- 명중
			    mintext:SetTextByKey("txt", obj.HR .." > ".. nextObj.HR);
		    elseif  basicTooltipProp == "DR" then -- 회피
			    mintext:SetTextByKey("txt", obj.DR .." > ".. nextObj.DR);
		    elseif  basicTooltipProp == "CRTMATK" then -- 마법관통
			    mintext:SetTextByKey("txt", obj.CRTMATK .." > ".. nextObj.CRTMATK);
		    elseif  basicTooltipProp == "ADD_FIRE" then -- 화염
			    mintext:SetTextByKey("txt", obj.FIRE .." > ".. nextObj.FIRE);
		    elseif  basicTooltipProp == "ADD_ICE" then -- 빙한
			    mintext:SetTextByKey("txt", obj.ICE .." > ".. nextObj.ICE);
		    elseif  basicTooltipProp == "ADD_LIGHTNING" then -- 전격
			    mintext:SetTextByKey("txt", obj.LIGHTNING .." > ".. nextObj.LIGHTNING);
		    end
		    maxtext:SetTextByKey("txt", "");
            propertyCtrl:Resize(propertyCtrl:GetWidth(), mintext:GetHeight());
	    end
    end
    GBOX_AUTO_ALIGN(basicPropBox, 0, 0, 0, true, false, true);
	DestroyIES(nextObj);

	SQUIRE_UPDATE_MATERIAL(frame, cnt, iconInfo:GetIESID());
	
	local imoney = frame:GetUserIValue("PRICE");
	local money = repairbox:GetChild("reqitemMoney");
	if session.GetMyHandle() ~= frame:GetUserIValue("HANDLE") then
		money:SetTextByKey("txt", imoney * cnt);
	else
	    money:SetTextByKey("txt", 0);
	end
end

function SQIORE_TARGET_UI_CLOSE()
	ui.CloseFrame("itembuffopen");
end

function SQUIRE_TARGET_BUFF_CENCEL(sellerHandle)
	packet.StopTimeAction(1);
end

function SQUIRE_BUFF_CENCEL_CHECK(frame)
	frame = frame:GetTopParentFrame();
	local handle = frame:GetUserIValue("HANDLE");
	local skillName = frame:GetUserValue("SKILLNAME");

	-- 그럼 이것은 판매자
	if handle == session.GetMyHandle() then
		if "Squire_Repair" == skillName then
			SQIORE_REPAIR_CENCEL();
			return;
		end
	end

	-- 유저
	session.autoSeller.BuyerClose(AUTO_SELL_SQUIRE_BUFF, handle);
end

function SQUTE_UI_RESET(frame)
	local repairbox = frame:GetChild("repair");
	local materialbox = repairbox:GetChild("materialGbox");
	local materialtext = materialbox:GetChild("reqitemNeedCount");
	materialtext:SetTextByKey("txt", "");

	local slot  = repairbox:GetChild("slot");
	slot  = tolua.cast(slot, 'ui::CSlot');
	slot:ClearIcon();
	slot:EnableDrag(1);
	slot:EnableDrop(1);

	local slotNametext = repairbox:GetChild("slotName");
	slotNametext:SetTextByKey("txt", "");

	local effectBox = repairbox:GetChild("effectGbox");
	local timestr = effectBox:GetChild("timestr");
	timestr:SetTextByKey("txt", "");

    local basicPropBox = GET_CHILD_RECURSIVELY(frame, 'basicPropBox');
    basicPropBox:RemoveAllChild();
end

function SQIORE_BUFF_EXCUTE(parent, ctrl)
	
	local frame = parent:GetTopParentFrame();
	local targetbox = frame:GetChild("repair");
	local effectBox = targetbox:GetChild("materialGbox");
	local guid = effectBox:GetChild("reqitemImage");

	local handle = frame:GetUserValue("HANDLE");
	local skillName = frame:GetUserValue("SKILLNAME");
	if "" ==  guid:GetTextByKey("guid") then
		return;
	end
	local slot  = targetbox:GetChild("slot");
	slot  = tolua.cast(slot, 'ui::CSlot');
	slot:EnableDrag(0);
	slot:EnableDrop(0);
	session.autoSeller.BuySquireBuff(handle, AUTO_SELL_SQUIRE_BUFF, skillName, guid:GetTextByKey("guid"));
		
end

function SQIORE_TAP_CHANGE(frame)
	local tabObj		    = frame:GetChild('statusTab');
	local itembox_tab		= tolua.cast(tabObj, "ui::CTabControl");
	if nil ~= itembox_tab then
		local curtabIndex	    = itembox_tab:GetSelectItemIndex();
		if curtabIndex == 0 then
			SQIORE_BUFF_VIEW(frame);
		elseif curtabIndex == 1 then
			SQIORE_LOG_VIEW(frame);
		end
	end
end
function SQIORE_BUFF_VIEW(frame)
	local gboxctrl = frame:GetChild("repair");
	gboxctrl:ShowWindow(1);

    local basicPropBox = GET_CHILD_RECURSIVELY(frame, 'basicPropBox');
    if basicPropBox ~= nil then
        basicPropBox:ShowWindow(1);
    end

	local gboxctrl = frame:GetChild("log");
	gboxctrl:ShowWindow(0);
end

function SQIORE_LOG_VIEW(frame)
	local gboxctrl = frame:GetChild("repair");
	gboxctrl:ShowWindow(0);
    
    local basicPropBox = GET_CHILD_RECURSIVELY(frame, 'basicPropBox');
    if basicPropBox ~= nil then
        basicPropBox:ShowWindow(0);
    end

	local gboxctrl = frame:GetChild("log");
	gboxctrl:ShowWindow(1);
end

function SQUIRE_BUFF_CLOSE(frame)
	frame = frame:GetTopParentFrame();
	local groupName = frame:GetUserValue("GroupName");
	local groupInfo = session.autoSeller.GetByIndex(groupName, 0);
	if groupInfo == nil then
		return;
	end
	
	session.autoSeller.Close(groupName);
	frame:ShowWindow(0);
end

function SQUIRE_UPDATE_MATERIAL(frame, cnt, guid)
	local repairbox = frame:GetChild("repair");
	local reqitembox = repairbox:GetChild("materialGbox");
	local reqitemtext = reqitembox:GetChild("reqitemCount");
	local reqitemName = reqitembox:GetChild("reqitemNameStr");
	local reqitemIamge= reqitembox:GetChild("reqitemImage");
	local reqitemNeed= reqitembox:GetChild("reqitemNeedCount");

	local invItemList = session.GetInvItemList();
	local checkFunc = _G["ITEMBUFF_STONECOUNT_" .. frame:GetUserValue("SKILLNAME")];
	local name, cnt2 = checkFunc(invItemList);
	local cls = GetClass("Item", name);
	reqitemIamge:SetTextByKey("txt", GET_ITEM_IMG_BY_CLS(cls, 50));
	local txt = cls.Name;
	reqitemName:SetTextByKey("txt", txt);
	local text = cnt2 .. " " .. ClMsg("CountOfThings");
	reqitemtext:SetTextByKey("txt", text);
	
	
	if nil ~= cnt then
		reqitemNeed:SetTextByKey("txt", cnt  ..ClMsg("CountOfThings"));
	else
		reqitemNeed:SetTextByKey("txt", "");
	end
	if nil ~= guid then
		reqitemIamge:SetTextByKey("guid", guid);
	else
		reqitemIamge:SetTextByKey("guid", "");
	end
	

	local imoney = frame:GetUserIValue("PRICE");
	if session.GetMyHandle() == frame:GetUserIValue("HANDLE") then

		local money = repairbox:GetChild("reqitemMoney");
		money:SetTextByKey("txt", 0);
	end	
	

	
end

function SQUIRE_ITEM_SUCCEED()
	local frame = ui.GetFrame("itembuffopen");
	local handle = frame:GetUserValue("HANDLE");
	SQUIRE_UPDATE_MATERIAL(frame);
	SQUTE_UI_RESET(frame);
end

function ITEMBUFF_UPDATE_HISTORY(frame)

	local groupName = frame:GetUserValue("GroupName");	
	local cnt = session.autoSeller.GetHistoryCount(groupName);

	local gboxctrl = frame:GetChild("log");
	local log_gbox = gboxctrl:GetChild("log_gbox");
	log_gbox:RemoveAllChild();

	for i = cnt -1 , 0, -1 do
		local info = session.autoSeller.GetHistoryByIndex(groupName, i);
		local ctrlSet = log_gbox:CreateControlSet("squire_history", "CTRLSET_" .. i,  ui.CENTER_HORZ, ui.TOP, 0, 0, 0, 0);
		local sList = StringSplit(info:GetHistoryStr(), "#");
		local itemClsID = sList[2];
		local itemCls = GetClassByType("Item", itemClsID);

		local UserName = ctrlSet:GetChild("userName");
		UserName:SetTextByKey("value", sList[1] .. ClMsg("ItemBuff"));

		local itemname = ctrlSet:GetChild("itemName");
		itemname:SetTextByKey("value", itemCls.Name);
		
	    local propValues = sList[3];
	    local propToken = StringSplit(propValues, "@");
        
		local propStr = "";
        local tokenIndex = 1;
        for i = 1, #propToken do
            if i == tokenIndex then
                local propertyClMsg = "";
                local token = propToken[i];
                if token == 'MATK' then
                    propertyClMsg = ClMsg('Magic_Atk');
                else
                    propertyClMsg = ClMsg(token);
                end
			    local strBuf = string.format("%s %s -> %s", propertyClMsg , propToken[i+1], propToken[i+2]);			
			    if i > 3 then
				    propStr = propStr .. "{nl}";
			    end
			    propStr = propStr .. strBuf;
                tokenIndex = tokenIndex + 3;
            end
		end
	    local property = ctrlSet:GetChild("Property");
	    property:SetTextByKey("value", propStr);
    end

	GBOX_AUTO_ALIGN(log_gbox, 20, 3, 10, true, false);
end


