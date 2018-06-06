-- itembuffopen.lua

function ITEMBUFFOPEN_ON_INIT(addon, frame)
end

function SQIORE_SLOT_POP(parent, ctrl)
	local frame = parent:GetTopParentFrame();
	SQUTE_UI_RESET(frame);
end

function SQIORE_SLOT_DROP(parent, ctrl)
	local frame				= parent:GetTopParentFrame();
	local liftIcon 			= ui.GetLiftIcon();
	local slot 			    = tolua.cast(ctrl, 'ui::CSlot');
	local iconInfo			= liftIcon:GetInfo();
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

	-- �̹����� �ְ�
	SET_SLOT_ITEM_IMANGE(slot, invItem);
	
	local repairbox = frame:GetChild("repair");
	local slotNametext = repairbox:GetChild("slotName");
	-- �̸��� ��ȭ ��ġ�� ǥ���Ѵ�.
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

	local nameList, fromList, toList = ExtractDiffProperty(obj, nextObj);
	-- ȿ���� ǥ���Ѵ�.
	local effectBox = repairbox:GetChild("effectGbox");
	local maxtextStr = effectBox:GetChild("maxpower");
	local mintextStr = effectBox:GetChild("minpower");
	
	local prop1, prop2 = GET_ITEM_PROPERT_STR(obj);

	maxtextStr:SetTextByKey("txt",  prop1);
	mintextStr:SetTextByKey("txt", prop2);
	local maxtext = effectBox:GetChild("maxpowerstr");
	local mintext = effectBox:GetChild("minpowerstr");
	local timestr = effectBox:GetChild("timestr");

	if obj.GroupName == "Weapon" or obj.GroupName == "SubWeapon" then
		if obj.BasicTooltipProp == "ATK" then -- �ִ�, �ּ� ���ݷ�
			maxtext:SetTextByKey("txt", obj.MAXATK .." > ".. nextObj.MAXATK);
			mintext:SetTextByKey("txt", obj.MINATK .." > ".. nextObj.MINATK);
		elseif obj.BasicTooltipProp == "MATK" then -- �������ݷ�
			maxtext:SetTextByKey("txt", obj.MATK .." > ".. nextObj.MATK);
			mintext:SetTextByKey("txt", "");
		end
	else
		if obj.BasicTooltipProp == "DEF" then -- ���
			maxtext:SetTextByKey("txt", obj.DEF .." > ".. nextObj.DEF);
		elseif obj.BasicTooltipProp == "MDEF" then -- �Ǽ��縮
			maxtext:SetTextByKey("txt", obj.MDEF .." > ".. nextObj.MDEF);
		elseif  obj.BasicTooltipProp == "HR" then -- ����
			maxtext:SetTextByKey("txt", obj.HR .." > ".. nextObj.HR);
		elseif  obj.BasicTooltipProp == "DR" then -- ȸ��
			maxtext:SetTextByKey("txt", obj.DR .." > ".. nextObj.DR);
		elseif  obj.BasicTooltipProp == "MHR" then -- ��������
			maxtext:SetTextByKey("txt", obj.MHR .." > ".. nextObj.MHR);
		elseif  obj.BasicTooltipProp == "ADD_FIRE" then -- ȭ��
			maxtext:SetTextByKey("txt", obj.FIRE .." > ".. nextObj.FIRE);
		elseif  obj.BasicTooltipProp == "ADD_ICE" then -- ����
			maxtext:SetTextByKey("txt", obj.ICE .." > ".. nextObj.ICE);
		elseif  obj.BasicTooltipProp == "ADD_LIGHTNING" then -- ����
			maxtext:SetTextByKey("txt", obj.LIGHTNING .." > ".. nextObj.LIGHTNING);
		end
		mintext:SetTextByKey("txt", "");
	end
	timestr:SetTextByKey("txt", string.format("{img %s %d %d}", "squaier_buff", 25, 25) .." ".. validSec/3600 .. ClMsg("QuestReenterTimeH"));
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

	-- �׷� �̰��� �Ǹ���
	if handle == session.GetMyHandle() then
		if "Squire_Repair" == skillName then
			SQIORE_REPAIR_CENCEL();
			return;
		end
	end

	-- ����
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
	local maxtext = effectBox:GetChild("maxpowerstr");
	local mintext = effectBox:GetChild("minpowerstr");
	local timestr = effectBox:GetChild("timestr");

	local maxtextStr = effectBox:GetChild("maxpower");
	local mintextStr = effectBox:GetChild("minpower");
	maxtextStr:SetTextByKey("txt",  "");
	mintextStr:SetTextByKey("txt", "");
	maxtext:SetTextByKey("txt", "");
	mintext:SetTextByKey("txt", "");
	timestr:SetTextByKey("txt", "");
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
	local gboxctrl = frame:GetChild("log");
	gboxctrl:ShowWindow(0);
end

function SQIORE_LOG_VIEW(frame)
	local gboxctrl = frame:GetChild("repair");
	gboxctrl:ShowWindow(0);
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
		
		local propStr = "";
		for j = 3 , #sList do
			local propNameValue = sList[j];
			local propToken = StringSplit(propNameValue, "@");
			local strBuf = string.format("%s %s -> %s", propToken[1] , propToken[2], propToken[3]);
			if 3 < #propToken then -- ��������� �� ���ٵ�
				strBuf = strBuf .. "{nl}" .. string.format("%s %s -> %s", propToken[4] , propToken[5], propToken[6]);
			end
			if j > 3 then
				propStr = propStr .. "{nl}";
			end
			propStr = propStr .. strBuf;
		end
	
		local property = ctrlSet:GetChild("Property");
		property:SetTextByKey("value", propStr);

	end

	GBOX_AUTO_ALIGN(log_gbox, 20, 3, 10, true, false);
end


